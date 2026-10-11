{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCDbExtCtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DbConsts, SCConsts, SCCommon, SCDbCommon, SCControl, SCStdControls,
  SCDbCtrls, SCTrackbar, SCScrollbars, SCRadioGroup, SCLinkedControls,
  SCSimpleListbox;

type
  TSCCustomDBTrackbar = class(TSCCustomTrackbar)
  private
    FDataLink: TSCFieldDataLink;
    FValue: String;
    FValues: TStrings;
    FChangingData: Integer;
    function  GetDataField: String;
    procedure SetDataField(const Value: String);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    function  GetPositionValue(Index: Integer): String;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    function  GetValue: String;
    procedure SetValue(const Value: String);
    function  GetValuePosition(Value: String): Integer;
    procedure SetValues(Value: TStrings);

    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  GetPosition: Integer; override;
    procedure BeforeExit; override;

    procedure ListChanged(Sender: TObject);
    procedure DoChange; override;
    procedure KeyPress(var Key: Char); override;

    function  CanSetValue(var Value: Integer): Boolean; override;
    function  CanSetUserValue(var Value: Integer): Boolean; override;

    property DataLink: TSCFieldDataLink read FDataLink;
    property DataField: String read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property Values: TStrings read FValues write SetValues;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Position;
    property Field: TField read GetField;
    property Value: string read GetValue write SetValue;
  end;

  TSCDBTrackbar = class(TSCCustomDBTrackbar)
  published
    property Align;
    property Anchors;
    property BlendColor;
    property BorderProps;
    property Color;
    property Constraints;
    property Cursor;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Frequency;
    property Hint;
    property Images;
    property ImageIndex;
    property Indent;
    property LineColor;
    property LinePosition;
    property LineSize;
    property Max;
    property Min;
    property Orientation;
    property PageSize;
    property ParentColor;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Progress;
    property ReadOnly;
    property ShowHint;
    property ShowFocusRect;
    property ShowLines;
    property ShowProgress;
    property ShowSlider;
    property Slider;
    property Spacing;
    property Values;
    property TabOrder;
    property TabStop;
    property Transparent;
    property Tag;
    property OnChange;
    property OnClick;
    property OnCanResize;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnDblClick;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;
  
  TSCCustomDBProgress = class(TSCCustomProgress)
  private
    FDataLink: TSCFieldDataLink;
    FValue: String;
    FValues: TStrings;
    FChangingData: Integer;
    function  GetDataField: String;
    procedure SetDataField(const Value: String);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    function  GetPositionValue(Index: Integer): String;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    function  GetValue: String;
    procedure SetValue(const Value: String);
    function  GetValuePosition(Value: String): Integer;
    procedure SetValues(Value: TStrings);

    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  GetPosition: Integer; override;
    procedure BeforeExit; override;

    procedure ListChanged(Sender: TObject);
    procedure DoChange; override;
    procedure KeyPress(var Key: Char); override;

    function  CanSetValue(var Value: Integer): Boolean; override;

    property DataLink: TSCFieldDataLink read FDataLink;
    property DataField: String read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property Values: TStrings read FValues write SetValues;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Position;
    property Percentage;
    property Field: TField read GetField;
    property Value: string read GetValue write SetValue;
  end;

  TSCDBProgress = class(TSCCustomDBProgress)
  published
    property Align;
    property Anchors;
    property BorderProps;
    property Color;
    property Constraints;
    property Cursor;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Max;
    property Min;
    property Orientation;
    property ParentColor;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property PositionColor;
    property PositionEndColor;
    property ReadOnly;
    property ShowHint;
    property Slice;
    property Step;
    property Style;
    property TabOrder;
    property TabStop;
    property Tag;
    property Transparent;
    property Values;
    property Visible;
    property OnCanResize;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomDBScrollbar = class(TSCCustomScrollbar)
  private
    FDataLink: TSCFieldDataLink;
    FValue: String;
    FValues: TStrings;
    FChangingData: Integer;
    function  GetDataField: String;
    procedure SetDataField(const Value: String);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    function  GetValuePosition(Value: String): Integer;
    function  GetPositionValue(Index: Integer): String;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    function  GetValue: String;
    procedure SetValue(const Value: String);
    procedure SetValues(Value: TStrings);

    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  GetPosition: Integer; override;
    procedure BeforeExit; override;

    procedure ListChanged(Sender: TObject);
    procedure DoChange; override;
    procedure KeyPress(var Key: Char); override;

    function  CanSetValue(var Value: Integer): Boolean; override;

    property ClickFocus default True;
    property DataLink: TSCFieldDataLink read FDataLink;
    property DataField: String read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property Values: TStrings read FValues write SetValues;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Position;
    property Field: TField read GetField;
    property Value: string read GetValue write SetValue;
  end;

  TSCDBScrollbar = class(TSCCustomDBScrollbar)
  published
    property Align;
    property Anchors;
    property BackColors;
    property BorderProps;
    property ButtonColors;
    property ButtonIconColors;
    property ButtonLayout;
    property ButtonSize;
    property ClickFocus;
    property Constraints;
    property Cursor;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property LargeChange;
    property Max;
    property Min;
    property Kind;
    property PageSize;
    property ParentShowHint;
    property ReadOnly;
    property Sensitivity;
    property ShowButtons;
    property ShowHint;
    property ShowSlideLine;
    property ShowThumb;
    property SmallChange;
    property Style;
    property TabOrder;
    property TabStop;
    property ThumbColors;
    property ThumbLines;
    property ThumbSize;
    property Tracking;
    property TrimPageSize;
    property Values;
    property Visible;
    property OnCanResize;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;
  
  TSCCustomDBRadioGroup = class(TSCCustomRadioGroup)
  private
    FDataLink: TSCFieldDataLink;
    FValue: string;
    FValues: TStrings;
    FInSetValue: Boolean;
    function  GetDataField: string;
    procedure SetDataField(const Value: string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    procedure SetValue(const Value: string);
    procedure SetValues(Value: TStrings);

    function  GetButtonValue(Index: Integer): string;
    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
  protected
    procedure Click; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    procedure BeforeExit; override;

    procedure ItemsChanged; override;

    procedure KeyPress(var Key: Char); override;
    function  CanModify: Boolean; override;

    property DataLink: TSCFieldDataLink read FDataLink;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property Values: TStrings read FValues write SetValues;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Field: TField read GetField;
    property ItemIndex;
    property Value: string read FValue write SetValue;
  end;

  TSCDBRadioGroup = class(TSCCustomDBRadioGroup)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AsCheckbox;
    property Bevel;
    property BevelEdges;
    property BevelColor;
    property BevelWidth;
    property BiDiMode;
    property BorderProps;
    property BoxCheckedColor;
    property BoxFrameColor;
    property BoxToggleColor;
    property BoxUncheckedColor;
    property Caption;
    property CaptionBevel;
    property CaptionBevelColor;
    property CaptionBkColor;
    property Color;
    property Columns;
    property Constraints;
    property Cursor;
    property DataField;
    property DataSource;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndEllipsis;
    property Font;
    property HighlightColor;
    property HottrackColor;
    property Images;
    property ImageChecked;
    property ImageToggle;
    property ImageUnchecked;
    property ImageMark;
    property Indent;
    property ItemColor;
    property ItemDisabledColor;
    property ItemHotColor;
    property ItemHotUnderline;
    property ItemHottrack;
    property Items;
    property Layout;
    property MarkColor;
    property Multiline;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Spacing;
    property SpareColor;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseDockManager;
    property Values;
    property Visible;
    property OnCanResize;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TDBSCRadioGroup = class(TSCDBRadioGroup);

  TSCCustomDBListBoxEx = class(TSCCustomListboxEx)
  private
    FChangingData: Integer;
    FDataLink: TSCFieldDataLink;
    FUseValues: Boolean;
    function  GetDataField: string;
    procedure SetDataField(const Value: string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    procedure SetUseValues(Value: Boolean);

    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Click; override;

    procedure DoSetItems; override;

    procedure CanChangeCheckState(OldSt: TSCCheckState; var NewSt: TSCCheckState); override;
    function  CanChangeItemIndex(Index: Integer): Integer; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property UseValues: Boolean read FUseValues write SetUseValues default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property ItemIndex;
    property Field: TField read GetField;
  end;

  TSCDBListBoxEx = class(TSCCustomDBListBoxEx)
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderProps;
    property CenterImages;
    property Color;
    property Colors;
    property Columns;
    property Constraints;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndEllipsis;
    property Font;
    property HideFocusRect;
    property HideSelection;
    property Hottrack;
    property HottrackColor;
    property HottrackUnderline;
    property Images;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property ItemsEx;
    property LineSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property Revertable;
    property ShowCheckboxes;
    property ShowItemHints;
    property ShowItemImages;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseValues;
    property Values;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnHottrack;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaintHint;
    property OnPictureChange;
    property OnResize;
    property OnShowItemHint;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

{ TSCCustomDBTrackbar }

procedure TSCCustomDBTrackbar.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBTrackbar then
  begin
    with TSCCustomDBTrackbar(Source) do
    begin
      Self.DataSource := DataSource;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.Values := Values;
    end;
  end;
end;

procedure TSCCustomDBTrackbar.BeforeExit;
begin
  inherited BeforeExit;
  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SetFocus;
      raise;
    end;
  end;
end;

function TSCCustomDBTrackbar.CanSetUserValue(var Value: Integer): Boolean;
begin
  Result := CanSetValue(Value);
end;

function TSCCustomDBTrackbar.CanSetValue(var Value: Integer): Boolean;
begin
  Result := True;
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if Readonly then
      Result := FChangingData > 0
    else
    if not (IsDesigning or IsLoading) then
      Result := (FChangingData > 0) or FDataLink.Edit;

    Exit;
  end;

  if IsDesigning then
  begin
    Value := Min;
    Exit;
  end;

  if (FDataLink = nil) or ReadOnly then
    Value := Min
  else
    Result := (FChangingData > 0) or FDataLink.Edit;
end;

procedure TSCCustomDBTrackbar.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

constructor TSCCustomDBTrackbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;

  FValue := '';
  FValues := TStringList.Create;
  TStringList(FValues).OnChange := ListChanged;
end;

procedure TSCCustomDBTrackbar.DataChange(Sender: TObject);
begin
  Inc(FChangingData);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
      Value := FDataLink.Field.Text
    else
      Value := EmptyStr;
  finally
    Dec(FChangingData);
  end;
end;

destructor TSCCustomDBTrackbar.Destroy;
begin
  FreeAndNil(FDataLink);

  TStringList(FValues).OnChange := nil;
  FreeAndNil(FValues);
  inherited Destroy;
end;

procedure TSCCustomDBTrackbar.DoChange;
begin
  Value := GetPositionValue(Position);
  if (FDataLink <> nil) and FDataLink.Editing then
    FDataLink.Modified;

  inherited DoChange;
end;

function TSCCustomDBTrackbar.GetDataField: String;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

function TSCCustomDBTrackbar.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

function TSCCustomDBTrackbar.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

function TSCCustomDBTrackbar.GetPosition: Integer;
var
  S: String;
  I: Integer;
begin
  Result := inherited GetPosition;
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    S := EmptyStr;
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
      S := FDataLink.Field.Text;

    if GetPositionValue(Result) <> S then
    begin
      I := GetValuePosition(S);
      if I <> -Maxint then
        Result := I;
    end;
  end;
end;

function TSCCustomDBTrackbar.GetPositionValue(Index: Integer): String;
begin
  Dec(Index, Min);
  Result := '';
  if (Index > -1) and (Index < FValues.Count) and (FValues[Index] <> '') then
    Result := FValues[Index]
  else if (Index >= 0) and (Index <= Max - Min) then
  begin
    Inc(Index, Min);
    Result := IntToStr(Index);
  end;
end;

function TSCCustomDBTrackbar.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

function TSCCustomDBTrackbar.GetValue: String;
begin
  Result := FValue;
end;

function TSCCustomDBTrackbar.GetValuePosition(Value: String): Integer;
var
  I: Integer;
begin
  for I := 0 to FValues.Count-1 do
    if FValues[I] = Value then
    begin
      Result := I + Min;
      Exit;
    end;

  Result := StrToIntDef(Value, -Maxint);
  if Result <> -Maxint then
  begin
    if Result < Min then
      Result := Min
    else if Result > Max then
      Result := Max;
  end;
end;

procedure TSCCustomDBTrackbar.KeyPress(var Key: Char);
begin
  inherited;
  if (FDataLink <> nil) and (Key = #27) then
    FDataLink.Reset;
end;

procedure TSCCustomDBTrackbar.ListChanged(Sender: TObject);
var
  Cnt: Integer;
begin
  Cnt := FValues.Count;
  if Cnt > 0 then Max := Min + Cnt - 1;
end;

procedure TSCCustomDBTrackbar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TSCCustomDBTrackbar.SetDataField(const Value: String);
begin
  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

procedure TSCCustomDBTrackbar.SetDataSource(Value: TDataSource);
begin
  if (FDataLink <> nil) and
    not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;
end;

procedure TSCCustomDBTrackbar.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

procedure TSCCustomDBTrackbar.SetValue(const Value: String);
var
  I: Integer;
begin
  FValue := Value;
  if GetPositionValue(Position) <> Value then
  begin
    I := GetValuePosition(Value);
    if I <> -Maxint then
      Position := I;
  end;
end;

procedure TSCCustomDBTrackbar.SetValues(Value: TStrings);
begin
  FValues.Assign(Value);
  Max := Min + FValues.Count - 1;
  DataChange(Self);
end;

procedure TSCCustomDBTrackbar.UpdateData(Sender: TObject);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Field.Text := Value;
end;

{ TSCCustomDBProgress }

procedure TSCCustomDBProgress.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBProgress then
  begin
    with TSCCustomDBProgress(Source) do
    begin
      Self.DataSource := DataSource;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.Values := Values;
    end;
  end;
end;

procedure TSCCustomDBProgress.BeforeExit;
begin
  inherited BeforeExit;
  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SetFocus;
      raise;
    end;
  end;
end;

function TSCCustomDBProgress.CanSetValue(var Value: Integer): Boolean;
begin
  Result := True;
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if Readonly then
      Result := FChangingData > 0
    else
    if not (IsDesigning or IsLoading) then
      Result := (FChangingData > 0) or FDataLink.Edit;

    Exit;
  end;

  if IsDesigning then
  begin
    Value := Min;
    Exit;
  end;

  if (FDataLink = nil) or ReadOnly then
    Value := Min
  else
    Result := (FChangingData > 0) or FDataLink.Edit;
end;

procedure TSCCustomDBProgress.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

constructor TSCCustomDBProgress.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;

  FValue := '';
  FValues := TStringList.Create;
  TStringList(FValues).OnChange := ListChanged;
end;

procedure TSCCustomDBProgress.DataChange(Sender: TObject);
begin
  Inc(FChangingData);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
      Value := FDataLink.Field.Text
    else
      Value := EmptyStr;
  finally
    Dec(FChangingData);
  end;
end;

destructor TSCCustomDBProgress.Destroy;
begin
  FreeAndNil(FDataLink);

  TStringList(FValues).OnChange := nil;
  FreeAndNil(FValues);
  inherited Destroy;
end;

procedure TSCCustomDBProgress.DoChange;
begin
  Value := GetPositionValue(Position);
  if (FDataLink <> nil) and FDataLink.Editing then
    FDataLink.Modified;

  inherited DoChange;
end;

function TSCCustomDBProgress.GetDataField: String;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

function TSCCustomDBProgress.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

function TSCCustomDBProgress.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

function TSCCustomDBProgress.GetPosition: Integer;
var
  S: String;
  I: Integer;
begin
  Result := inherited GetPosition;
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    S := EmptyStr;
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
      S := FDataLink.Field.Text;

    if GetPositionValue(Result) <> S then
    begin
      I := GetValuePosition(S);
      if I <> -Maxint then
        Result := I;
    end;
  end;
end;

function TSCCustomDBProgress.GetPositionValue(Index: Integer): String;
begin
  Dec(Index, Min);
  Result := '';
  if (Index > -1) and (Index < FValues.Count) and (FValues[Index] <> '') then
    Result := FValues[Index]
  else if (Index >= 0) and (Index <= Max - Min) then
  begin
    Inc(Index, Min);
    Result := IntToStr(Index);
  end;
end;

function TSCCustomDBProgress.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

function TSCCustomDBProgress.GetValue: String;
begin
  Result := FValue;
end;

function TSCCustomDBProgress.GetValuePosition(Value: String): Integer;
var
  I: Integer;
begin
  for I := 0 to FValues.Count-1 do
    if FValues[I] = Value then
    begin
      Result := I + Min;
      Exit;
    end;

  Result := StrToIntDef(Value, -Maxint);
  if Result <> -Maxint then
  begin
    if Result < Min then
      Result := Min
    else if Result > Max then
      Result := Max;
  end;
end;

procedure TSCCustomDBProgress.KeyPress(var Key: Char);
begin
  inherited;
  if (FDataLink <> nil) and (Key = #27) then
    FDataLink.Reset;
end;

procedure TSCCustomDBProgress.ListChanged(Sender: TObject);
var
  Cnt: Integer;
begin
  Cnt := FValues.Count;
  if Cnt > 0 then Max := Min + Cnt - 1;
end;

procedure TSCCustomDBProgress.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TSCCustomDBProgress.SetDataField(const Value: String);
begin
  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

procedure TSCCustomDBProgress.SetDataSource(Value: TDataSource);
begin
  if (FDataLink <> nil) and
    not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;
end;

procedure TSCCustomDBProgress.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

procedure TSCCustomDBProgress.SetValue(const Value: String);
var
  I: Integer;
begin
  FValue := Value;
  if GetPositionValue(Position) <> Value then
  begin
    I := GetValuePosition(Value);
    if I <> -Maxint then
      Position := I;
  end;
end;

procedure TSCCustomDBProgress.SetValues(Value: TStrings);
begin
  FValues.Assign(Value);
  Max := Min + FValues.Count - 1;
  DataChange(Self);
end;

procedure TSCCustomDBProgress.UpdateData(Sender: TObject);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Field.Text := Value;
end;

{ TSCCustomDBScrollbar }

procedure TSCCustomDBScrollbar.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBScrollbar then
  begin
    with TSCCustomDBScrollbar(Source) do
    begin
      Self.DataSource := DataSource;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.Values := Values;
    end;
  end;
end;

procedure TSCCustomDBScrollbar.BeforeExit;
begin
  inherited BeforeExit;
  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SetFocus;
      raise;
    end;
  end;
end;

function TSCCustomDBScrollbar.CanSetValue(var Value: Integer): Boolean;
begin
  Result := True;
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if Readonly then
      Result := FChangingData > 0
    else
    if not (IsDesigning or IsLoading) then
      Result := (FChangingData > 0) or FDataLink.Edit;

    Exit;
  end;

  if IsDesigning then
  begin
    Value := Min;
    Exit;
  end;

  if (FDataLink = nil) or ReadOnly then
    Value := Min
  else
    Result := (FChangingData > 0) or FDataLink.Edit;
end;

procedure TSCCustomDBScrollbar.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

constructor TSCCustomDBScrollbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ClickFocus := True;
  
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;

  FValue := '';
  FValues := TStringList.Create;
  TStringList(FValues).OnChange := ListChanged;
end;

procedure TSCCustomDBScrollbar.DataChange(Sender: TObject);
begin
  Inc(FChangingData);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
      Value := FDataLink.Field.Text
    else
      Value := EmptyStr;
  finally
    Dec(FChangingData);
  end;
end;

destructor TSCCustomDBScrollbar.Destroy;
begin
  FreeAndNil(FDataLink);

  TStringList(FValues).OnChange := nil;
  FreeAndNil(FValues);
  inherited Destroy;
end;

procedure TSCCustomDBScrollbar.DoChange;
begin
  Value := GetPositionValue(Position);
  if (FDataLink <> nil) and FDataLink.Editing then
    FDataLink.Modified;

  inherited DoChange;
end;

function TSCCustomDBScrollbar.GetDataField: String;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

function TSCCustomDBScrollbar.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

function TSCCustomDBScrollbar.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

function TSCCustomDBScrollbar.GetPosition: Integer;
var
  S: String;
  I: Integer;
begin
  Result := inherited GetPosition;
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    S := EmptyStr;
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
      S := FDataLink.Field.Text;

    if GetPositionValue(Result) <> S then
    begin
      I := GetValuePosition(S);
      if I <> -Maxint then
        Result := I;
    end;
  end;
end;

function TSCCustomDBScrollbar.GetPositionValue(Index: Integer): String;
begin
  Dec(Index, Min);
  Result := '';
  if (Index > -1) and (Index < FValues.Count) and (FValues[Index] <> '') then
    Result := FValues[Index]
  else if (Index >= 0) and (Index <= Max - Min) then
  begin
    Inc(Index, Min);
    Result := IntToStr(Index);
  end;
end;

function TSCCustomDBScrollbar.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

function TSCCustomDBScrollbar.GetValue: String;
begin
  Result := FValue;
end;

function TSCCustomDBScrollbar.GetValuePosition(Value: String): Integer;
var
  I: Integer;
begin
  for I := 0 to FValues.Count-1 do
    if FValues[I] = Value then
    begin
      Result := I + Min;
      Exit;
    end;

  Result := StrToIntDef(Value, -Maxint);
  if Result <> -Maxint then
  begin
    if Result < Min then
      Result := Min
    else if Result > Max then
      Result := Max;
  end;
end;

procedure TSCCustomDBScrollbar.KeyPress(var Key: Char);
begin
  inherited;
  if (FDataLink <> nil) and (Key = #27) then
    FDataLink.Reset;
end;

procedure TSCCustomDBScrollbar.ListChanged(Sender: TObject);
var
  Cnt: Integer;
begin
  Cnt := FValues.Count;
  if Cnt > 0 then Max := Min + Cnt - 1;
end;

procedure TSCCustomDBScrollbar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TSCCustomDBScrollbar.SetDataField(const Value: String);
begin
  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

procedure TSCCustomDBScrollbar.SetDataSource(Value: TDataSource);
begin
  if (FDataLink <> nil) and
    not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;
end;

procedure TSCCustomDBScrollbar.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

procedure TSCCustomDBScrollbar.SetValue(const Value: String);
var
  I: Integer;
begin
  FValue := Value;
  if GetPositionValue(Position) <> Value then
  begin
    I := GetValuePosition(Value);
    if I <> -Maxint then
      Position := I;
  end;
end;

procedure TSCCustomDBScrollbar.SetValues(Value: TStrings);
begin
  FValues.Assign(Value);
  Max := Min + FValues.Count - 1;
  DataChange(Self);
end;

procedure TSCCustomDBScrollbar.UpdateData(Sender: TObject);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Field.Text := Value;
end;

{ TSCCustomDBRadioGroup }

constructor TSCCustomDBRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csReplicatable];

  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FValues := TStringList.Create;
end;

destructor TSCCustomDBRadioGroup.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FValues.Free;
  inherited Destroy;
end;

procedure TSCCustomDBRadioGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBRadioGroup.UseRightToLeftAlignment: Boolean;
begin
  Result := inherited UseRightToLeftAlignment;
end;

procedure TSCCustomDBRadioGroup.DataChange(Sender: TObject);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    Value := FDataLink.Field.Text
  else
    Value := '';
end;

procedure TSCCustomDBRadioGroup.UpdateData(Sender: TObject);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Field.Text := Value;
end;

function TSCCustomDBRadioGroup.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBRadioGroup.SetDataSource(Value: TDataSource);
begin
  if FDataLink <> nil then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;    
end;

function TSCCustomDBRadioGroup.GetDataField: string;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBRadioGroup.SetDataField(const Value: string);
begin
  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBRadioGroup.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBRadioGroup.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBRadioGroup.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

function TSCCustomDBRadioGroup.GetButtonValue(Index: Integer): string;
begin
  if (Index < FValues.Count) and (FValues[Index] <> '') then
    Result := FValues[Index]
  else if Index < Items.Count then
    Result := Items[Index].Caption
  else
    Result := '';
end;

procedure TSCCustomDBRadioGroup.SetValue(const Value: string);
var
  I, Index: Integer;
begin
  if FValue <> Value then
  begin
    FInSetValue := True;
    try
      Index := -1;
      for I := 0 to Items.Count - 1 do
        if Value = GetButtonValue(I) then
        begin
          Index := I;
          Break;
        end;
      ItemIndex := Index;
    finally
      FInSetValue := False;
    end;
    FValue := Value;
    Change;
  end;
end;

procedure TSCCustomDBRadioGroup.Click;
begin
  if not FInSetValue then
  begin
    inherited Click;
    if ItemIndex >= 0 then Value := GetButtonValue(ItemIndex);
    if (FDataLink <> nil) and FDataLink.Editing then
      FDataLink.Modified;
  end;
end;

procedure TSCCustomDBRadioGroup.ItemsChanged;
begin
  DataChange(Self);
end;

procedure TSCCustomDBRadioGroup.SetValues(Value: TStrings);
begin
  FValues.Assign(Value);
  DataChange(Self);
end;

procedure TSCCustomDBRadioGroup.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  
  if FDataLink <> nil then
  begin
    case Key of
      #8, ' ':
        FDataLink.Edit;
      #27:
        FDataLink.Reset;
    end;
  end;
end;

function TSCCustomDBRadioGroup.CanModify: Boolean;
begin
  Result := (FDataLink <> nil) and FDataLink.Edit;
end;

function TSCCustomDBRadioGroup.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBRadioGroup.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBRadioGroup.BeforeExit;
begin
  inherited BeforeExit;
  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      ResetDownIndex;
      raise;
    end;
  end;
end;

procedure TSCCustomDBRadioGroup.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBRadioGroup then
  begin
    with TSCCustomDBRadioGroup(Source) do
    begin
      Self.DataSource := DataSource;
      Self.Values := Values;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
    end;
  end;
end;

{ TSCCustomDBListBoxEx }

constructor TSCCustomDBListBoxEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csReplicatable];

  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
end;

destructor TSCCustomDBListBoxEx.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCustomDBListBoxEx.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBListBoxEx.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBListBoxEx.DataChange(Sender: TObject);
begin
  Inc(FChangingData);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      if FUseValues then
        ItemIndex := ItemsEx.IndexOfValue(FDataLink.Field.Text)
      else
        ItemIndex := ItemsEx.IndexOf(FDataLink.Field.Text);
    end else
      ItemIndex := -1;
  finally
    Dec(FChangingData);
  end;
end;

procedure TSCCustomDBListBoxEx.UpdateData(Sender: TObject);
var
  S: String;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if ItemIndex >= 0 then
    begin
      S := ItemsEx[ItemIndex].Text;
      if FUseValues then
        S := ItemsEx[ItemIndex].Value;

      FDataLink.Field.Text := S;
    end else
      FDataLink.Field.Text := '';
  end;
end;

procedure TSCCustomDBListBoxEx.Click;
begin
  if not (IsLoading or IsDesigning) and
    (FChangingData = 0) and (FDataLink <> nil) and FDataLink.Edit then
  begin
    inherited Click;
    FDataLink.Modified;
  end;
end;

function TSCCustomDBListBoxEx.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBListBoxEx.SetDataSource(Value: TDataSource);
begin
  if FDataLink <> nil then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;    
end;

function TSCCustomDBListBoxEx.GetDataField: string;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBListBoxEx.SetDataField(const Value: string);
begin
  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBListBoxEx.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBListBoxEx.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBListBoxEx.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBListBoxEx.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key in [VK_PRIOR, VK_NEXT, VK_END, VK_HOME, VK_LEFT, VK_UP,
    VK_RIGHT, VK_DOWN]) and ((FDataLink = nil) or not FDataLink.Edit) then
    Key := 0;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBListBoxEx.KeyPress(var Key: Char);
begin
  case Key of
    #32..#255:
      if (FDataLink = nil) or not FDataLink.Edit then
        Key := #0;
    #27:
    if FDataLink <> nil then
      FDataLink.Reset;
  end;

  inherited KeyPress(Key);
end;

procedure TSCCustomDBListBoxEx.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if (FDataLink <> nil) and FDataLink.Edit then
    inherited
  else begin
    SetFocus;
    with Message do
      MouseDown(mbLeft, KeysToShiftState(Keys), XPos, YPos);
  end;
end;

procedure TSCCustomDBListBoxEx.CMExit(var Message: TCMExit);
begin
  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SetFocus;
      raise;
    end;
  end;
  inherited;
end;

procedure TSCCustomDBListBoxEx.DoSetItems;
begin
  DataChange(Self);
end;

function TSCCustomDBListBoxEx.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBListBoxEx.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBListBoxEx.CanChangeCheckState(OldSt: TSCCheckState;
  var NewSt: TSCCheckState);
begin
  if ReadOnly then
    NewSt := OldSt;
end;

function TSCCustomDBListBoxEx.CanChangeItemIndex(Index: Integer): Integer;
begin
  Result := -1;
  if FDataLink.Field <> nil then
    Result := Index;
end;

procedure TSCCustomDBListBoxEx.SetUseValues(Value: Boolean);
begin
  FUseValues := Value;
end;

procedure TSCCustomDBListBoxEx.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBListBoxEx then
  begin
    with TSCCustomDBListBoxEx(Source) do
    begin
      Self.DataSource := DataSource;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.UseValues := UseValues;
    end;
  end;
end;

{$I SCVerRec.inc}

end.

