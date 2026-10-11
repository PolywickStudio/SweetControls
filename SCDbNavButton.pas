{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCDbNavButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, Db, DbConsts, SCConsts, SCControl, SCGraphicButton, SCDbCommon;

type
  TSCNavConfirmEvent = procedure(Sender: TObject; NavType: TSCNavigateType;
    var CanOperate: Boolean) of object;

  TSCNavButtonDataLink = class;

  TSCCustomNavButton = class(TSCCustomGraphicButton)
  private
    FDataLink: TSCNavButtonDataLink;
    FConfirmDelete: Boolean;
    FNavType: TSCNavigateType;
    FOnBeforeAction: TSCNavConfirmEvent;
    FOnAfterAction: TNotifyEvent;
    FOnConfirmDelete: TSCNavConfirmEvent;
    function  GetDataSource:TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure SetNavType(Value: TSCNavigateType);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;

    function  GetImages: TCustomImageList; override;
    function  GetImageIndex: TImageIndex; override;

    function  CanActivate: Boolean; dynamic;
    procedure EditingChanged;
    procedure DataChanged;
    procedure ActiveChanged;

    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property NavType: TSCNavigateType read FNavType write SetNavType default scntFirst;
    property RepeatClick default False;
    property RepeatInterval default 150;
    property Transparent default False;
    property OnAfterAction: TNotifyEvent read FOnAfterAction write FOnAfterAction;
    property OnBeforeAction: TSCNavConfirmEvent read FOnBeforeAction write FOnBeforeAction;
    property OnConfirmDelete: TSCNavConfirmEvent read FOnConfirmDelete write FOnConfirmDelete;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Click; override;

    property Enabled default False;
  end;

  TSCNavButton = class(TSCCustomNavButton)
  published
    property Align;
    property AllowAllUp;
    property Anchors;
    property ArrowColor;
    property BiDiMode;
    property Cancel;
    property Caption;
    property Center;
    property Color;
    property ConfirmDelete;
    property Constraints;
    property Cursor;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropdownMenu;
    property EndEllipsis;
    property Font;
    property Gradient;
    property GroupIndex;
    property Down;
    property HighlightColor;
    property HottrackColor;
    property Images;
    property ImageIndex;
    property Indent;
    property Layout;
    property ModalResult;
    property Multiline;
    property NavType;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupArrow;
    property RepeatClick;
    property RepeatInterval;
    property RoundColor;
    property Rounded;
    property RoundWithParentColor;
    property ShowCaption;
    property ShowHint;
    property Spacing;
    property Style;
    property Transparent;
    property Visible;
    property OnAfterAction;
    property OnBeforeAction;
    property OnConfirmDelete;
    property OnCanResize;
    property OnClick;
    {$IFDEF SC_DELPHI5_UP}
    property OnContextPopup;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCNavButtonDataLink = class(TDataLink)
  private
    FNavigator: TSCCustomNavButton;
  protected
    procedure EditingChanged; override;
    procedure DataSetChanged; override;
    procedure ActiveChanged; override;
  public
    constructor Create(ANavBtn: TSCCustomNavButton);
    destructor Destroy; override;
  end;

implementation

{ TSCNavButtonDataLink }

procedure TSCNavButtonDataLink.ActiveChanged;
begin
  if FNavigator <> nil then
    FNavigator.ActiveChanged;
end;

constructor TSCNavButtonDataLink.Create(ANavBtn: TSCCustomNavButton);
begin
  inherited Create;
  FNavigator := ANavBtn;
  VisualControl := True;
end;

procedure TSCNavButtonDataLink.DataSetChanged;
begin
  if FNavigator <> nil then
    FNavigator.DataChanged;
end;

destructor TSCNavButtonDataLink.Destroy;
begin
  FNavigator := nil;
  inherited Destroy;
end;

procedure TSCNavButtonDataLink.EditingChanged;
begin
  if FNavigator <> nil then
    FNavigator.EditingChanged;
end;


{ TSCCustomNavButton }

procedure TSCCustomNavButton.ActiveChanged;
begin
  if (FDataLink = nil) or not (FDataLink.Active and CanActivate) then
    Enabled := False
  else begin
    DataChanged;
    EditingChanged;
  end;
end;

procedure TSCCustomNavButton.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomNavButton then
  begin
    with TSCCustomNavButton(Source) do
    begin
      Self.DataSource := DataSource;
      Self.ConfirmDelete := ConfirmDelete;
      Self.NavType := NavType;
    end;
  end;
end;

function TSCCustomNavButton.CanActivate: Boolean;
begin
  Result := True;
end;

procedure TSCCustomNavButton.Click;
var
  CanOperate: Boolean;
begin
  inherited Click;

  if (IsLoading or IsDestroying) or not Enabled or
    (DataSource = nil) or (DataSource.DataSet = nil) or
    (DataSource.DataSet.State = dsInactive) then
    Exit;

  CanOperate := True;
  if Assigned(FOnBeforeAction) then
    FOnBeforeAction(Self, FNavType, CanOperate);

  if CanOperate then
    with DataSource.DataSet do
    begin
      case NavType of
        scntAppend: Append;
        scntInsert: Insert;
        scntEdit: Edit;
        scntPost: Post;
        scntCancel: Cancel;
        scntRefresh: Refresh;
        scntFirst: First;
        scntPrior: Prior;
        scntNext: Next;
        scntLast: Last;
        scntDelete:
        begin
          CanOperate := True;
          if FConfirmDelete and Assigned(FOnConfirmDelete) then
            FOnConfirmDelete(Self, FNavType, CanOperate);

          if CanOperate then
            Delete;
        end;
      end;
    end;

  if Assigned(FOnAfterAction) then
    FOnAfterAction(Self);
end;

constructor TSCCustomNavButton.Create(AOwner: TComponent);
begin
  FNavType := scntFirst;
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csReplicatable];

  FDataLink := TSCNavButtonDataLink.Create(Self);
  FConfirmDelete := True;
  Enabled := False;
  Transparent := False;
  RepeatClick := False;
  RepeatInterval := 150;
  SetNavType(scntFirst);
end;

procedure TSCCustomNavButton.DataChanged;
var
  UpEnable, DnEnable: Boolean;
begin
  UpEnable := (FDataLink <> nil) and FDataLink.Active and
    (FDataLink.DataSet <> nil) and not FDataLink.DataSet.BOF;
  DnEnable := (FDataLink <> nil) and FDataLink.Active and
    (FDataLink.DataSet <> nil) and not FDataLink.DataSet.EOF;

  case FNavType of
    scntFirst:
      Enabled := UpEnable;
    scntPrior:
      Enabled := UpEnable;
    scntNext:
      Enabled := DnEnable;
    scntLast:
      Enabled := DnEnable;
    scntDelete:
      Enabled := (FDataLink <> nil) and FDataLink.Active and
        (FDataLink.DataSet <> nil) and FDataLink.DataSet.CanModify and
        not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF);
  end;
end;

destructor TSCCustomNavButton.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCustomNavButton.EditingChanged;
var
  CanModify: Boolean;
begin
  CanModify := (FDataLink <> nil) and FDataLink.Active and
    (FDataLink.DataSet <> nil) and FDataLink.DataSet.CanModify;

  case FNavType of
    scntAppend:
      Enabled := CanModify;
    scntInsert:
      Enabled := CanModify;
    scntEdit:
      Enabled := CanModify and not FDataLink.Editing;
    scntPost:
      Enabled := CanModify and FDataLink.Editing;
    scntCancel:
      Enabled := CanModify and FDataLink.Editing;
    scntRefresh:
      Enabled := CanModify;
  end;
end;

function TSCCustomNavButton.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

function TSCCustomNavButton.GetImageIndex: TImageIndex;
begin
  Result := inherited GetImageIndex;
  if Self.Images = nil then
    case FNavType of
      scntFirst:
        Result := 0;
      scntPrior:
        Result := 1;
      scntNext:
        Result := 2;
      scntLast:
        Result := 3;
      scntInsert:
        Result := 4;
      scntAppend:
        Result := 5;
      scntDelete:
        Result := 6;
      scntEdit:
        Result := 7;
      scntPost:
        Result := 8;
      scntCancel:
        Result := 9;
      scntRefresh:
        Result := 10;
    end;
end;

function TSCCustomNavButton.GetImages: TCustomImageList;
begin
  Result := inherited GetImages;
  if Result = nil then Result := SCDBImages;
end;

procedure TSCCustomNavButton.Loaded;
begin
  inherited Loaded;
  ActiveChanged;
end;

procedure TSCCustomNavButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TSCCustomNavButton.SetDataSource(Value: TDataSource);
begin
  if FDataLink <> nil then
    FDataLink.DataSource := Value;
end;

procedure TSCCustomNavButton.SetNavType(Value: TSCNavigateType);
var
  R1, R2: TSCNavButtonRec;
begin
  R1 := GetNavigateTypeRec(FNavType);
  R2 := GetNavigateTypeRec(Value);

  FNavType := Value;

  if (Caption = R1.Caption) or ((Caption = Self.Name) and IsDesigning) then
    Self.Caption := R2.Caption;

  if (Hint = R1.Hint) or ((Hint = '') and IsDesigning) then
    Self.Hint := R2.Hint;

  ActiveChanged;    
end;

{$I SCVerRec.inc}

end.

