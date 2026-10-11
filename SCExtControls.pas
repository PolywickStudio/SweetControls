{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCExtControls;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, StdActns, ActnList, Menus, SCCommon, SCConsts, SCControl,
  SCStdControls;

type
  TSCHeaderColumn = class;
  TSCCustomHeader = class;

  TSCHeaderColActionLink = class(TActionLink)
  protected
    FClient: TSCHeaderColumn;
    procedure AssignClient(AClient: TObject); override;
    function  IsCaptionLinked: Boolean; override;
    function  IsEnabledLinked: Boolean; override;
    function  IsHintLinked: Boolean; override;
    function  IsImageIndexLinked: Boolean; override;
    function  IsShortCutLinked: Boolean; override;
    function  IsVisibleLinked: Boolean; override;
    function  IsOnExecuteLinked: Boolean; override;
    procedure SetCaption(const Value: string); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetHint(const Value: string); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetShortCut(Value: TShortCut); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
  end;

  TSCHeaderColActionLinkClass = class of TSCHeaderColActionLink;

  TSCHeaderColStyle = (schsImage, schsImageAndText, schsOwnerDraw, schsText);

  TSCHeaderColBevel = (schbNone, schb3D, schb3DX, schbRaised, schbFlat,
    schb3DRaised, schbSpace, schbMac, schbMetal, schbWinXP);

  TSCHeaderColumn = class(TCollectionItem)
  private
    FActionLink: TSCHeaderColActionLink;
    FAlignment: TAlignment;
    FAllowClick: Boolean;
    FBorderColor: TColor;
    FColor: TColor;
    FDown: Boolean;
    FEnabled: Boolean;
    FEndEllipsis: Boolean;
    FImageIndex: TImageIndex;
    FIndent: Cardinal;
    FMinWidth: Integer;
    FMaxWidth: Integer;
    FParentColor: Boolean;
    FSizable: Boolean;
    FStyle: TSCHeaderColStyle;
    FText: string;
    FVisible: Boolean;
    FWidth: Integer;
    FXPHotColor: TColor;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseUp: TMouseEvent;
    function  GetAction: TBasicAction;
    procedure SetAction(const Value: TBasicAction);
    procedure SetAlignment(Value: TAlignment);
    procedure SetBorderColor(Value: TColor);
    procedure SetColor(Value: TColor);
    procedure SetDown(Value: Boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure SetEndEllipsis(Value: Boolean);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetIndent(Value : Cardinal);
    procedure SetMaxWidth(Value: Integer);
    procedure SetMinWidth(Value: Integer);
    procedure SetParentColor(Value: Boolean);
    procedure SetStyle(Value: TSCHeaderColStyle);
    procedure SetText(const Value: string);
    procedure SetVisible(Value: Boolean);
    procedure SetWidth(Value: Integer);
    procedure UpdateColumnDown; virtual;
    function  GetComponentState: TComponentState;
  protected
    function GetDisplayName: string; override;
    function GetDefaultWidth: Cardinal; virtual;
    function GetImages: TCustomImageList;
    function GetParentColor: TColor; virtual;

    function IsCaptionStored: Boolean;
    function IsEnabledStored: Boolean;
    function IsImageIndexStored: Boolean;
    function IsOnClickStored: Boolean;
    function IsVisibleStored: Boolean;

    procedure DoActionChange(Sender: TObject);
    function  GetActionLinkClass: TSCHeaderColActionLinkClass; dynamic;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); dynamic;

    property ActionLink: TSCHeaderColActionLink read FActionLink write FActionLink;
    property Down: Boolean read FDown write SetDown;
    property ComponentState: TComponentState read GetComponentState;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Action: TBasicAction read GetAction write SetAction;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AllowClick: Boolean read FAllowClick write FAllowClick default True;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clBtnShadow;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Enabled: Boolean read FEnabled write SetEnabled stored IsEnabledStored default True;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default True;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Indent: Cardinal read FIndent write SetIndent default 0;
    property MaxWidth: Integer read FMaxWidth write SetMaxWidth default 10000;
    property MinWidth: Integer read FMinWidth write SetMinWidth default 0;
    property ParentColor: Boolean read FParentColor write SetParentColor default True;
    property Sizable: Boolean read FSizable write FSizable default True;
    property Style: TSCHeaderColStyle read FStyle write SetStyle default schsText;
    property Text: string read FText write SetText;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Width: Integer read FWidth write SetWidth default 100;
    property XPHotColor: TColor read FXPHotColor write FXPHotColor default SC_HottrackColor;
    property OnClick: TNotifyEvent read FOnClick write FOnClick stored IsOnClickStored;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
  end;

  TSCHeaderColumns = class(TCollection)
  private
    FHeader: TSCCustomHeader;
    function  GetItem(Index: Integer): TSCHeaderColumn;
    procedure SetItem(Index: Integer; Value: TSCHeaderColumn);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
    function  UniqueColText(Base: String): String;
  public
    constructor Create(Header: TSCCustomHeader);
    function Add: TSCHeaderColumn;
    property Items[Index: Integer]: TSCHeaderColumn read GetItem write SetItem; default;
    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomHeader read FHeader;
    {$ENDIF}
  end;

  TSCDrawColumnEvent = procedure(Header: TSCCustomHeader; Column: TSCHeaderColumn;
    ColCanvas: TCanvas; const Rect: TRect) of object;

  TSCColumnEvent = procedure(Header: TSCCustomHeader; Column: TSCHeaderColumn) of object;

  TSCColumnHitTest = (schtClient, schtColumn, schtColumnLeft, schtColumnRight,
    schtNowhere);

  TSCHeaderHitInfo = record
    X, Y: Integer;
    Column: Integer;
    HitPos: TSCColumnHitTest;
  end;
  PHeaderHitInfo = ^TSCHeaderHitInfo;

  TSCCustomHeader = class(TSCCustomControl)
  private
    FArrowColor: TColor;
    FArrowBorderColor: TColor;
    FClientBevel: TSCHeaderColBevel;
    FColumns: TSCHeaderColumns;
    FColumnSpace: Cardinal;
    FDefaultBevel: TSCHeaderColBevel;
    FDefaultColWidth: Cardinal;
    FDragImageList: TImageList;
    FDragReorder: Boolean;
    FFullDrag: Boolean;
    FHotTrack: Boolean;
    FHotTrackFontColor: TColor;
    FLimitClient: Boolean;
    FOnColumnClick: TSCColumnEvent;
    FOnColumnDblClick: TSCColumnEvent;
    FOnColumnResize: TSCColumnEvent;
    FOnDrawColumn: TSCDrawColumnEvent;
    FHitInfo: TSCHeaderHitInfo;
    FHottrackInfo: TSCHeaderHitInfo;
    FMouseDownHitInfo: TSCHeaderHitInfo;
    FColumnClicked: Boolean;
    FColumnDblClicked: Boolean;
    FSizing: Boolean;
    FDraggedColumn: Integer;
    FOldCursor: TCursor;
    FMouseIsDown: Boolean;
    FDraggedOnColumn: Integer;
    procedure SetClientBevel(Value: TSCHeaderColBevel);
    function  GetColumnDragging: Boolean;
    procedure SetColumns(Value: TSCHeaderColumns);
    procedure SetColumnSpace(Value: Cardinal);
    procedure SetDefaultBevel(Value: TSCHeaderColBevel);
    procedure SetFullDrag(Value: Boolean);
    procedure SetHotTrack(Value: Boolean);
    procedure SetHotTrackFontColor(Value: TColor);
    procedure SetLimitClient(Value: Boolean);

    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMParentColorChanged(var Message: TMessage); message CM_PARENTCOLORCHANGED;
    procedure CMWantSpecialKey(var Message: TCMWantSpecialKey); message CM_WANTSPECIALKEY;

    procedure WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
  protected
    procedure Paint; override;
    procedure SetAutoSize(Value: Boolean); override;
    function  GetBlendValue: Word; override;

    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;

    procedure InitializeHitTest(AHitInfo: PHeaderHitInfo);
    procedure ResetHitInfo;
    procedure ResetHotTrackInfo;

    procedure AutoSizeChanged; override;
    procedure EnabledChanged; override;

    procedure SetColumnCursor(AHitType: TSCColumnHitTest);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure DoDockOver(Source: TDragDockObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;

    function CalculateImageRect(Column: TSCHeaderColumn; ARect: TRect): TRect; reintroduce; virtual;

    procedure DrawSizeLine(ACanvas: TCanvas; X, Y: Integer);
    procedure DrawColumn(Column: TSCHeaderColumn; C: TCanvas;
      const ARect: TRect; InternalDraw: Boolean);
    procedure DrawColumnBorder(Column: TSCHeaderColumn; C: TCanvas;
      const ARect: TRect; InternalDraw: Boolean);
    procedure DrawClientBevel(C: TCanvas; const ARect: TRect);

    procedure DrawImageColumn(Column: TSCHeaderColumn; ColumnCanvas: TCanvas;
      const ARect: TRect; InternalDraw: Boolean);
    procedure DrawTextColumn(Column: TSCHeaderColumn; ColumnCanvas: TCanvas;
      const ARect: TRect; InternalDraw: Boolean);

    procedure ColumnSized(Column: TSCHeaderColumn);
    procedure UpdateColumnColors(OldColor: TColor);
    procedure UpdateColumn(Index: Integer; Repaint: Boolean); dynamic;
    procedure UpdateColumns; dynamic;

    procedure InitiateColumnDrag(Col: Integer); virtual;
    procedure BeginColumnDragging(Col: Integer); virtual;
    procedure DoColumnDragMove; dynamic;
    procedure DrawDragArrow;
    procedure StopDragging;
    procedure DoColumnDrag(FromColumn, ToColumn: Integer); dynamic;

    property Align default alTop;
    property ArrowColor: TColor read FArrowColor write FArrowColor default clLime;
    property ArrowBorderColor: TColor read FArrowBorderColor write FArrowBorderColor default clNavy;
    property ClientBevel: TSCHeaderColBevel read FClientBevel write SetClientBevel default schbWinXP;
    property Color default clBtnFace;
    property Columns: TSCHeaderColumns read FColumns write SetColumns;
    property ColumnSpace: Cardinal read FColumnSpace write SetColumnSpace default 0;
    property DefaultBevel: TSCHeaderColBevel read FDefaultBevel write SetDefaultBevel default schbWinXP;
    property DefaultColWidth: Cardinal read FDefaultColWidth write FDefaultColWidth default 100;
    property DragReorder: Boolean read FDragReorder write FDragReorder default False;
    property FullDrag: Boolean read FFullDrag write SetFullDrag default True;
    property HotTrack: Boolean read FHotTrack write SetHotTrack default False;
    property HotTrackFontColor: TColor read FHotTrackFontColor write SetHotTrackFontColor default clBlue;
    property LimitClient: Boolean read FLimitClient write SetLimitClient default False;
    property ParentColor default False;
    property ParentFont default False;
    property OnColumnClick: TSCColumnEvent read FOnColumnClick write FOnColumnClick;
    property OnColumnDblClick: TSCColumnEvent read FOnColumnDblClick write FOnColumnDblClick;
    property OnColumnResize: TSCColumnEvent read FOnColumnResize write FOnColumnResize;
    property OnDrawColumn: TSCDrawColumnEvent read FOnDrawColumn write FOnDrawColumn;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function  ExecuteAction(Action: TBasicAction): Boolean; override;

    function GetClickedColumn: Integer; dynamic;
    function ColumnAtPos(P: TPoint): Integer; dynamic;
    function ClientToColumn(P: TPoint): TPoint;
    function ColumnRect(Column: TSCHeaderColumn): TRect; overload;
    function ColumnRect(Index: Integer): TRect; overload;
    function GetLastVisible: Integer;
    function SpaceRect: TRect;
    function GetHitInfo(P: TPoint): TSCHeaderHitInfo; virtual;
    function GetHitTypeAt(X, Y: Integer): TSCColumnHitTest;
    function IsValidColumn(Col: Integer): Boolean;

    property ColumnDragging: Boolean read GetColumnDragging;
    property DraggedColumn: Integer read FDraggedColumn;
    property Sizing: Boolean read FSizing;
  end;

  TSCHeader = class(TSCCustomHeader)
  published
    property Align;
    property Anchors;
    property ArrowColor;
    property ArrowBorderColor;
    property AutoSize;
    property BlendColor;
    property ClientBevel;
    property Color;
    property Columns;
    property ColumnSpace;
    property Constraints;
    property Cursor;
    property DefaultBevel;
    property DefaultColWidth;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DragReorder;
    property Enabled;
    property Font;
    property FullDrag;
    property Hint;
    property HotTrack;
    property HotTrackFontColor;
    property Images;
    property LimitClient;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Tag;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnColumnClick;
    property OnColumnDblClick;
    property OnColumnResize;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnDblClick;
    property OnDrawColumn;
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

  TSCSimpleImageBox = class(TSCCustomControl)
  protected
    function GetBlendValue: Word; override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property BlendColor;
    property Border;
    property BorderColor;
    property Color default clWindow;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatColor;
    property ImageIndex;
    property Images;
    property ParentColor default False;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnMouseWheel;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TSCCustomBevel = class(TSCGraphicControl)
  private
    FBevel: TSCControlBevel;
    FBevelColor: TColor;
    FBevelEdges: TSCBorderEdges;
    FBevelWidth: TSCBevelWidth;
    procedure SetBevel(Value: TSCControlBevel);
    procedure SetBevelColor(Value: TColor);
    procedure SetBevelEdges(Value: TSCBorderEdges);
    procedure SetBevelWidth(Value: TSCBevelWidth);
  protected
    procedure Paint; override;
    procedure AdjustBevelRect(var Rect: TRect); virtual;
    function  GetBevelSize: Integer;

    property Bevel: TSCControlBevel read FBevel write SetBevel default sccbLowered;
    property BevelColor: TColor read FBevelColor write SetBevelColor default clNone;
    property BevelEdges: TSCBorderEdges read FBevelEdges write SetBevelEdges default SCAllBorderEdges;
    property BevelWidth: TSCBevelWidth read FBevelWidth write SetBevelWidth default 0;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCBevel = class(TSCCustomBevel)
  published
    property Align;
    property Anchors;
    property Bevel;
    property BevelColor;
    property BevelEdges;
    property BevelWidth;
    property Color;
    property Constraints;
    property Cursor;
    property Hint;
    property ParentColor;
    property ParentShowHint;
    property Visible;
    property Transparent;
  end;

implementation

type
  TSCFakeControl = class(TWinControl);

{ TSCHeaderColActionLink }

procedure TSCHeaderColActionLink.AssignClient(AClient: TObject);
begin
  FClient := AClient as TSCHeaderColumn;
end;

function TSCHeaderColActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and
    AnsiSameText(FClient.Text, (Action as TCustomAction).Caption);
end;

function TSCHeaderColActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and
    (FClient.Enabled = (Action as TCustomAction).Enabled);
end;

function TSCHeaderColActionLink.IsHintLinked: Boolean;
begin
  Result := False;
end;

function TSCHeaderColActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and
    (FClient.ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TSCHeaderColActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and
    (@FClient.OnClick = @Action.OnExecute);
end;

function TSCHeaderColActionLink.IsShortCutLinked: Boolean;
begin
  Result := False;
end;

function TSCHeaderColActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and
    (FClient.Visible = (Action as TCustomAction).Visible);
end;

procedure TSCHeaderColActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then FClient.Text := Value;
end;

procedure TSCHeaderColActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then FClient.Enabled := Value;
end;

procedure TSCHeaderColActionLink.SetHint(const Value: string);
begin
  inherited;
end;

procedure TSCHeaderColActionLink.SetImageIndex(Value: Integer);
begin
  if IsImageIndexLinked then FClient.ImageIndex := Value;
end;

procedure TSCHeaderColActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then FClient.OnClick := Value;
end;

procedure TSCHeaderColActionLink.SetShortCut(Value: TShortCut);
begin
  inherited;
end;

procedure TSCHeaderColActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then FClient.Visible := Value;
end;

{ TSCHeaderColumn }

procedure TSCHeaderColumn.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  if Action is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or (Self.Text = '') then
        Self.Text := Caption;
      if not CheckDefaults or (Self.Enabled = True) then
        Self.Enabled := Enabled;
      if not CheckDefaults or (Self.ImageIndex = -1) then
        Self.ImageIndex := ImageIndex;
      if not CheckDefaults or (Self.Visible = True) then
        Self.Visible := Visible;
      if not CheckDefaults or not Assigned(Self.OnClick) then
        Self.OnClick := OnExecute;
    end;
end;

procedure TSCHeaderColumn.Assign(Source: TPersistent);
begin
  if Source is TSCHeaderColumn then
  begin
    with TSCHeaderColumn(Source) do
    begin
      Self.Alignment := Alignment;
      Self.BorderColor := BorderColor;
      Self.Color := Color;
      Self.Enabled := Enabled;
      Self.EndEllipsis := EndEllipsis;
      Self.ImageIndex := ImageIndex;
      Self.ParentColor := ParentColor;
      Self.Style := Style;
      Self.Text := Text;
      Self.Visible := Visible;
      Self.Width := Width;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCHeaderColumn.Create(Collection: TCollection);
begin
  FMaxWidth := 10000;
  FAllowClick := True;
  FImageIndex := -1;
  inherited Create(Collection);

  FWidth := GetDefaultWidth;
  FBorderColor := clBtnShadow;
  FColor := GetParentColor;
  FEnabled := True;
  FEndEllipsis := True;
  FParentColor := True;
  FSizable := True;
  FStyle := schsText;
  FVisible := True;
  FXPHotColor := SC_HottrackColor;
end;

destructor TSCHeaderColumn.Destroy;
begin
  FreeAndNil(FActionLink);
  inherited Destroy;
end;

procedure TSCHeaderColumn.DoActionChange(Sender: TObject);
begin
  if Sender = Action then ActionChange(Sender, False);
end;

function TSCHeaderColumn.GetAction: TBasicAction;
begin
  if FActionLink <> nil then
    Result := FActionLink.Action else
    Result := nil;
end;

function TSCHeaderColumn.GetActionLinkClass: TSCHeaderColActionLinkClass;
begin
  Result := TSCHeaderColActionLink;
end;

function TSCHeaderColumn.GetComponentState: TComponentState;
var
  AOwner: TPersistent;
begin
  Result := [csLoading];

  AOwner := TSCHeaderColumns(Collection).Owner;
  if AOwner is TComponent then
    Result := TComponent(AOwner).ComponentState;
end;

function TSCHeaderColumn.GetDefaultWidth: Cardinal;
var
  AOwner: TPersistent;
begin
  AOwner := TSCHeaderColumns(Collection).Owner;
  if AOwner is TSCCustomHeader then
    Result := TSCCustomHeader(AOwner).DefaultColWidth
  else
    Result := 100;
end;

function TSCHeaderColumn.GetDisplayName: string;
begin
  Result := Text;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TSCHeaderColumn.GetImages: TCustomImageList;
begin
  Result := nil;
  if TSCHeaderColumns(Collection).FHeader <> nil then
    Result := TSCHeaderColumns(Collection).FHeader.Images;
end;

function TSCHeaderColumn.GetParentColor: TColor;
var
  AOwner: TPersistent;
begin
  AOwner := TSCHeaderColumns(Collection).Owner;
  if AOwner is TSCCustomHeader then
    Result := TSCCustomHeader(AOwner).Color
  else
    Result := clBtnFace;
end;

function TSCHeaderColumn.IsCaptionStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsCaptionLinked;
end;

function TSCHeaderColumn.IsEnabledStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsEnabledLinked;
end;

function TSCHeaderColumn.IsImageIndexStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsImageIndexLinked;
end;

function TSCHeaderColumn.IsOnClickStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsOnExecuteLinked;
end;

function TSCHeaderColumn.IsVisibleStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsVisibleLinked;
end;

procedure TSCHeaderColumn.SetAction(const Value: TBasicAction);
begin
  if Value = nil then
  begin
    FActionLink.Free;
    FActionLink := nil;
  end
  else
  begin
    if FActionLink = nil then
      FActionLink := GetActionLinkClass.Create(Self);
    FActionLink.Action := Value;
    FActionLink.OnChange := DoActionChange;
    ActionChange(Value, csLoading in Value.ComponentState);
  end;
end;

procedure TSCHeaderColumn.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Changed(False);
  end;
end;

procedure TSCHeaderColumn.SetBorderColor(Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Changed(False);
  end;
end;

procedure TSCHeaderColumn.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    if FParentColor and (Value <> GetParentColor) then
      FParentColor := False;

    Changed(True);
  end;
end;

procedure TSCHeaderColumn.SetDown(Value: Boolean);
begin
  if not FEnabled and Value then Value := False;

  if FDown <> Value then
  begin
    FDown := Value;
    if Value then UpdateColumnDown;

    Changed(True);
  end;
end;

procedure TSCHeaderColumn.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed(False);
  end;
end;

procedure TSCHeaderColumn.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    Changed(False);
  end;
end;

procedure TSCHeaderColumn.SetImageIndex(const Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if (Style in [schsImage,
      schsImageAndText, schsOwnerDraw]) then
        Changed(False);
  end;
end;

procedure TSCHeaderColumn.SetIndent(Value: Cardinal);
begin
  if FIndent <> Value then
  begin
    FIndent := Value;
    if (Style in [schsText,
      schsImageAndText, schsOwnerDraw]) then
       Changed(False);
  end;
end;

procedure TSCHeaderColumn.SetMaxWidth(Value: Integer);
begin
  if Value < FMinWidth then Value := FMinWidth;
  if Value > 10000 then Value := 10000;
  FMaxWidth := Value;
  SetWidth(FWidth);
end;

procedure TSCHeaderColumn.SetMinWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if Value > FMaxWidth then Value := FMaxWidth;
  FMinWidth := Value;
  SetWidth(FWidth);
end;

procedure TSCHeaderColumn.SetParentColor(Value: Boolean);
begin
  if FParentColor <> Value then
  begin
    FParentColor := Value;
    if FParentColor then
      Color := GetParentColor;
  end;
end;

procedure TSCHeaderColumn.SetStyle(Value: TSCHeaderColStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Changed(False);
  end;
end;

procedure TSCHeaderColumn.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    Changed(False);
  end;
end;

procedure TSCHeaderColumn.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(True);
  end;
end;

procedure TSCHeaderColumn.SetWidth(Value: Integer);
var
  Cs: TComponentState;
begin
  if Value < FMinWidth then Value := FMinWidth;
  if Value > FMaxWidth then Value := FMaxWidth;

  Cs := ComponentState;

  if (FWidth <> Value) and (FSizable or (Cs*[csLoading, csDesigning] <> [])) then
  begin
    FWidth := Value;
    
    if Collection <> nil then
    begin
      Changed(True);
      TSCHeaderColumns(Collection).FHeader.ColumnSized(Self);
    end;
  end;
end;

procedure TSCHeaderColumn.UpdateColumnDown;
var
  I: Integer;
begin
  for I := 0 to Collection.Count-1 do
    if Collection.Items[I] <> Self then
      TSCHeaderColumn(Collection.Items[I]).Down := False;
end;

{ TSCHeaderColumns }

function TSCHeaderColumns.Add: TSCHeaderColumn;
begin
  Result := TSCHeaderColumn(inherited Add);
end;

constructor TSCHeaderColumns.Create(Header: TSCCustomHeader);
begin
  inherited Create(TSCHeaderColumn);
  FHeader := Header;
end;

function TSCHeaderColumns.GetItem(Index: Integer): TSCHeaderColumn;
begin
  Result := TSCHeaderColumn(inherited GetItem(Index));
end;

function TSCHeaderColumns.GetOwner: TPersistent;
begin
  Result := FHeader;
end;

procedure TSCHeaderColumns.SetItem(Index: Integer;
  Value: TSCHeaderColumn);
begin
  inherited SetItem(Index, Value);
end;

function TSCHeaderColumns.UniqueColText(Base: String): String;
var
  S: String;
  I: Integer;
begin
  S := Base;
  if (S <> '') and SameText(S[1], 'T') then
    System.Delete(S, 1, 1);
  if S = '' then S := Base;

  for I := 1 to Count do
    if not SameText(S + IntToStr(I), Items[I-1].Text) then
    begin
      Result := S + IntToStr(I);
      Exit;
    end;

  Result := S + IntToStr(Count+1);
end;

procedure TSCHeaderColumns.Update(Item: TCollectionItem);
begin
  if Item <> nil then
    FHeader.UpdateColumn(Item.Index, False) else
    FHeader.UpdateColumns;
end;

{ TSCCustomHeader }

procedure TSCCustomHeader.BeginColumnDragging(Col: Integer);
var
  W, H: Integer;
  P1, P2: TPoint;
begin
  if IsValidColumn(Col) and GetCursorPos(P1) then
  begin
    W := FColumns[Col].Width;
    H := ClientHeight;

    if (W > 0) and (H > 0) and FColumns[Col].Visible then
    begin
      P2 := ClientToColumn(ScreenToClient(P1));

      InitiateColumnDrag(Col);
      FDragImageList.DragCursor := crDefault;
      FDragImageList.SetDragImage(0, P2.X, P2.Y);

      FDragImageList.BeginDrag(GetDeskTopWindow, P1.X, P1.Y);
      Application.CancelHint;
    end;
  end;  
end;

function TSCCustomHeader.CalculateImageRect(Column: TSCHeaderColumn;
  ARect: TRect): TRect;
begin
  Result := ARect;
  if not (Column.Style in [schsImage,
    schsImageAndText]) then
  begin
    Result.Right := Result.Left;
    Exit;
  end;

  case Column.Alignment of
    taLeftJustify:
      Inc(Result.Left, 1);
    taRightJustify:
      Dec(Result.Right, 1);
    taCenter:
    begin
      Inc(Result.Left, 1);
      Dec(Result.Right, 1);
    end;
  end;
  if Result.Bottom < Result.Top then
    Result.Bottom := Result.Top;

  if Result.Right < Result.Left then
    Result.Right := Result.Left;
  if Images = nil then
  begin
    case Column.Alignment of
      taLeftJustify, taCenter:
        Result.Right := Result.Left;
      taRightJustify:
        Result.Left := Result.Right;
    end;
    Exit;
  end;

  case Column.Style of
    schsImage, schsImageAndText:
    begin
      if not IsValidImage(Column.ImageIndex) or
        (Images.Width = 0) or (Images.Height = 0) then
      begin
        case Column.Alignment of
          taLeftJustify, taCenter:
            Result.Right := Result.Left;
          taRightJustify:
            Result.Left := Result.Right;
        end;
        Exit;
      end;
    end;
  end;

  if Result.Bottom - Result.Top <> Images.Height then
  begin
    Inc(Result.Top,
      ((Result.Bottom - Result.Top) - Images.Height) div 2);
    Result.Bottom := Result.Top + Images.Height;
  end;

  if Result.Right - Result.Left > Images.Width then
  begin
    case Column.Alignment of
      taLeftJustify:
        Result.Right := Result.Left + Images.Width;
      taRightJustify:
        Result.Left := Result.Right - Images.Width;
      taCenter:
      begin
        Inc(Result.Left,
          ((Result.Right - Result.Left) - Images.Width) div 2);
        Result.Right := Result.Left + Images.Width;
      end;
    end;
  end;

  if Result.Right < Result.Left then
    Result.Right := Result.Left;
  if Result.Bottom < Result.Top then
    Result.Bottom := Result.Top;
end;

function TSCCustomHeader.ClientToColumn(P: TPoint): TPoint;
var
  R: TRect;
  Col: Integer;
begin
  Result := Point(0, 0);
  Col := ColumnAtPos(P);

  if IsValidColumn(Col) then
  begin
    R := ColumnRect(Col);

    Result.X := P.X - R.Left;
    Result.Y := P.Y - R.Top;
  end;  
end;

procedure TSCCustomHeader.CMColorChanged(var Message: TMessage);
begin
  inherited;
  UpdateColumnColors(Canvas.Brush.Color);
  Invalidate;
end;

procedure TSCCustomHeader.CMMouseEnter(var Message: TMessage);
begin
  inherited;
end;

procedure TSCCustomHeader.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if not IsDesigning then
    ResetHotTrackInfo;
end;

procedure TSCCustomHeader.CMParentColorChanged(var Message: TMessage);
begin
  inherited;
  if ParentColor then
  begin
    UpdateColumnColors(Canvas.Brush.Color);
    Invalidate;
  end;
end;

procedure TSCCustomHeader.CMWantSpecialKey(var Message: TCMWantSpecialKey);
begin
  inherited;

  if Message.CharCode = VK_ESCAPE then
  begin
    Message.Result := 1;

    if ColumnDragging then
      FDraggedOnColumn := -1;

    if FSizing or ColumnDragging then
      SendMessage(Handle, WM_LBUTTONUP, 0,
        MakeLong(FMouseDownHitInfo.X, FMouseDownHitInfo.Y));
  end;
end;

function TSCCustomHeader.ColumnAtPos(P: TPoint): Integer;
var
  I: Integer;
  R: TRect;
begin
  Result := -1;

  for I := 0 to FColumns.Count-1 do
    if FColumns[I].Visible then
    begin
      R := ColumnRect(I);

      if PtInRect(R, P) then
      begin
        Result := I;
        Break;
      end;
    end;
end;

function TSCCustomHeader.ColumnRect(Column: TSCHeaderColumn): TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if (Column <> nil) and Column.Visible and (Column.Collection = FColumns) then
    Result := ColumnRect(Column.Index);
end;

function TSCCustomHeader.ColumnRect(Index: Integer): TRect;
var
  R: TRect;
  Col: TSCHeaderColumn;
  I, CRight: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (Index > -1) and (Index < FColumns.Count) and FColumns[Index].Visible then
  begin
    R := ClientRect;
    CRight := R.Right;

    if not IsRectEmpty(R) then
    begin
      R.Right := R.Left;
      Result := R;

      for I := 0 to FColumns.Count-1 do
      begin
        Col := FColumns[I];

        if I = Index then
        begin
          R.Right := R.Left + Col.Width;
          Break;
        end;
        
        if Col.Visible then
          OffsetRect(R, Integer(ColumnSpace) + Col.Width, 0);

        if R.Left > R.Right then
        begin
          R.Left := R.Right;
          Break;
        end;
      end;

      if LimitClient then
      begin
        if R.Right > CRight then R.Right := CRight;
        if R.Left > CRight then R.Left := CRight;
      end;

      Result := R;

      if AutoSize and (Index = GetLastVisible) then
        Result.Right := CRight;

      if Result.Right < Result.Left then
        Result.Right := Result.Left;
    end;    
  end;
end;

procedure TSCCustomHeader.ColumnSized(Column: TSCHeaderColumn);
begin
  if Assigned(FOnColumnResize) then
    FOnColumnResize(Self, Column);
end;

constructor TSCCustomHeader.Create(AOwner: TComponent);
begin
  InitializeHitTest(@FHitInfo);
  InitializeHitTest(@FMouseDownHitInfo);
  inherited Create(AOwner);
  Align := alTop;
  Height := 17;
  DoubleBuffered := True;
  Color := clBtnFace;
  ParentFont := False;

  FArrowColor := clLime;
  FArrowBorderColor := clNavy;
  ClickFocus := False;
  FClientBevel := schbWinXP;
  FDefaultBevel := schbWinXP;
  FDefaultColWidth := 100;
  FDraggedColumn := -1;
  FFullDrag := True;
  FHotTrack := False;
  FHotTrackFontColor := clBlue;
  FOldCursor := Cursor;
  FColumns := TSCHeaderColumns.Create(Self);
  ResetHitInfo;
  ResetHotTrackInfo;
end;

destructor TSCCustomHeader.Destroy;
begin
  FreeAndNil(FColumns);
  inherited Destroy;
end;

procedure TSCCustomHeader.DoColumnDrag(FromColumn, ToColumn: Integer);
begin
  if ToColumn = Columns.Count then Dec(ToColumn);

  if not ((FromColumn <> ToColumn) and
    IsValidColumn(FromColumn) and IsValidColumn(ToColumn)) then Exit;

  try
    Columns.BeginUpdate;
    Columns[FromColumn].Index := ToColumn;
  finally
    Columns.EndUpdate;
  end;
end;

procedure TSCCustomHeader.DoColumnDragMove;
var
  P: TPoint;
begin
  if not (ColumnDragging and GetCursorPos(P) and
    IsValidColumn(FHitInfo.Column)) then Exit;

  DrawDragArrow;

  FDragImageList.DragMove(P.X, P.Y);
end;

procedure TSCCustomHeader.DoDockOver(Source: TDragDockObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  inherited;
  Invalidate;
end;

procedure TSCCustomHeader.DrawColumn(Column: TSCHeaderColumn;
  C: TCanvas; const ARect: TRect; InternalDraw: Boolean);
var
  R2, BRect: TRect;
  Cl, C1, C2: TColor;
  IsHotTrackCol: Boolean;
begin
  IsHotTrackCol := FHotTrack and (FHotTrackInfo.Column > -1) and
    (FHotTrackInfo.Column = Column.Index);

  Cl := CurrentBlendedColor(Column.Color);

  if InternalDraw and IsHotTrackCol and (FDefaultBevel = schbWinXP) and
    (not FMouseIsDown or (Column.Down and FMouseIsDown)) then
    Cl := BlendedColor(Column.Color, 32, 32, 32, True)
  else
  if InternalDraw and (FDefaultBevel = schbMac) and Column.Down then
    Cl := BlendedColor(Column.Color, 64, 64, 64, False);

  BRect := ARect;
  OffsetRect(BRect, -BRect.Left, -BRect.Top);

  with C do
  begin
    Brush.Color := Cl;

    FillRect(BRect);
    Font.Assign(Self.Font);

    if InternalDraw and IsHotTrackCol and not Dragging then
      Font.Color := FHotTrackFontColor;

    if not (Column.Enabled and Enabled) then
      Font.Color := clGrayText;
  end;

  if not Column.Visible then
    Exit;

  if FDefaultBevel in [schb3D, schb3DX] then
  begin
    C1 := SCCommon.scBlendColor(Cl, 64);
    C2 := SCCommon.scBlendColor(Cl, -64);

    if not (InternalDraw and Column.Down) then
    begin
      R2 := ARect;
      R2.Bottom := R2.Top + Round((R2.Bottom - R2.Top) / 2);

      scDrawGradient(C, R2, scgTopToBottom, C1, Cl);

      R2 := ARect;
      R2.Top := R2.Bottom - Round((R2.Bottom - R2.Top) / 2);

      scDrawGradient(C, R2, scgTopToBottom, Cl, C2);
    end;
  end;

  BRect := ARect;
  if (Column.Style = schsOwnerDraw) and Assigned(FOnDrawColumn) then
    FOnDrawColumn(Self, Column, C, BRect)
  else begin
    case Column.Style of
      schsText:
      begin
        InflateRect(BRect, -1, -1);
        DrawTextColumn(Column, C, BRect, InternalDraw);
      end;
      schsImage:
      begin
        InflateRect(BRect, -1, 0);
        DrawImageColumn(Column, C, BRect, InternalDraw);
      end;
      schsImageAndText:
      begin
        InflateRect(BRect, -1, 0);
        DrawImageColumn(Column, C, BRect, InternalDraw);

        if Column.Alignment <> taCenter then
        begin
          BRect := ARect;
          InflateRect(BRect, -1, 0);

          BRect := CalculateImageRect(Column, BRect);
          BRect.Top := ARect.Top;
          BRect.Bottom := ARect.Bottom;

          InflateRect(BRect, 0, -1);
          if not IsValidImage(Column.ImageIndex) then
            InflateRect(BRect, -1, 0);

          if Column.Alignment in [taLeftJustify, taRightJustify] then
          begin
            if Column.Alignment = taLeftJustify then
            begin
              BRect.Left := BRect.Right;
              BRect.Right := ARect.Right;
            end else
            begin
              BRect.Right := BRect.Left;
              BRect.Left := ARect.Left;
            end;

            DrawTextColumn(Column, C, BRect, InternalDraw);
          end;
        end;
      end;
    end;
  end;

  DrawColumnBorder(Column, C, ARect, InternalDraw);
end;

procedure TSCCustomHeader.DrawColumnBorder(Column: TSCHeaderColumn;
  C: TCanvas; const ARect: TRect; InternalDraw: Boolean);
var
  BRect, R2: TRect;
  Cl, C1, C2: TColor;
  IsHotTrackCol: Boolean;
begin
  IsHotTrackCol := not FMouseIsDown and FHotTrack and
    (FHotTrackInfo.Column > -1) and (FHotTrackInfo.Column = Column.Index);

  if (C = nil) or not Column.Visible or IsRectEmpty(ARect) then
    Exit;

  BRect := ARect;
  if (FDefaultBevel <> schbNone) and (BRect.Right - BRect.Left = 1) then
  begin
    scFrame3D(C, BRect, CurrentBlendedColor(Self.Color), CurrentBlendedColor(Self.Color), 1, 0);
    Exit;
  end;

  case FDefaultBevel of
    schbNone:
    begin
      if InternalDraw and Column.Down then
        scFrame3D(C, BRect, clBtnShadow, clBtnHighlight, 1, 0);
    end;
    schb3D:
    begin
      R2 := ARect;
      InflateRect(R2, 0, -3);

      if not IsRectEmpty(R2) then
        with C do
        begin
          Pen.Color := BlendedColor(Column.Color, 36, 36, 36, False);
          MoveTo(R2.Right - 2, R2.Top);
          LineTo(R2.Right - 2, R2.Bottom);

          Pen.Color := BlendedColor(Column.Color, 80, 80, 80, True);
          MoveTo(R2.Right - 1, R2.Top);
          LineTo(R2.Right - 1, R2.Bottom);
        end;
    end;
    schb3DX:
    begin
      Cl := CurrentBlendedColor(Column.Color);

      C1 := SCCommon.scBlendColor(Cl, 64);
      C2 := SCCommon.scBlendColor(Cl, -64);

      R2 := ARect;
      scFrame3D(C, R2, C1, C2, 1, 0);

      C1 := SCCommon.scBlendColor(Cl, 48);
      C2 := SCCommon.scBlendColor(Cl, -48);

      scFrame3D(C, R2, C1, C2, 1, 0);
    end;
    schbRaised:
    begin
      if InternalDraw and Column.Down then
        scFrame3D(C, BRect, clBtnShadow, clBtnHighlight, 1, 0)
      else
        scFrame3D(C, BRect, clBtnHighlight, clBtnShadow, 1, 0);
    end;
    schbFlat:
    begin
      if InternalDraw and Column.Down then
        scFrame3D(C, BRect, clBtnShadow, clBtnHighlight, 1, 0)
      else
        scFrame3D(C, BRect, Column.BorderColor, Column.BorderColor, 1, 0);
    end;
    schb3DRaised:
    begin
      if InternalDraw and Column.Down then
        scFrame3D(C, BRect, clBtnShadow, clBtnShadow, 1, 0)
      else begin
        scFrame3D(C, BRect, clBtnHighlight, cl3DDkShadow, 1, 0);
        scFrame3D(C, BRect, clBtnFace, clBtnShadow, 1, 0);
      end;
    end;
    schbSpace:
    begin
      if InternalDraw and Column.Down then
        scFrame3D(C, BRect, clBtnShadow, clBtnHighlight, 1, 0)
      else begin
        Dec(BRect.Left, 2);
        Dec(BRect.Top, 2);

        scFrame3D(C, BRect, clBtnHighlight, clBtnHighlight, 1, 0);
        scFrame3D(C, BRect, clBtnShadow, clBtnShadow, 1, 0);
      end;
    end;
    schbWinXP:
    begin
      with C do
      begin
        if InternalDraw and Column.Down then
        begin
          scFrame3D(C, BRect,
            BlendedColor(Column.Color, 48, 48, 48, False),
            BlendedColor(Column.Color, 48, 48, 48, False), 1, 0);
        end else
        if IsHotTrackCol and not MouseIsDown then
        begin
          Pen.Color := Column.XPHotColor;

          MoveTo(BRect.Left, BRect.Bottom - 3);
          LineTo(BRect.Right, BRect.Bottom - 3);

          MoveTo(BRect.Left + 1, BRect.Bottom - 2);
          LineTo(BRect.Right - 1, BRect.Bottom - 2);

          if Column.Width > 3 then
          begin
            Pen.Color := BlendedColor(Column.XPHotColor, 32, 32, 32, False);

            MoveTo(BRect.Left + 2, BRect.Bottom - 1);
            LineTo(BRect.Right - 2, BRect.Bottom - 1);

            MoveTo(BRect.Left, BRect.Bottom - 3);
            LineTo(BRect.Left + 2, BRect.Bottom - 1);

            MoveTo(BRect.Right - 1, BRect.Bottom - 3);
            LineTo(BRect.Right - 3, BRect.Bottom - 1);
          end;
        end else
        begin
          Pen.Color := BlendedColor(Column.Color, 36, 36, 36, False);
          MoveTo(BRect.Left, BRect.Bottom - 1);
          LineTo(BRect.Right, BRect.Bottom - 1);

          Pen.Color := BlendedColor(Column.Color, 24, 24, 24, False);
          MoveTo(BRect.Left, BRect.Bottom - 2);
          LineTo(BRect.Right, BRect.Bottom - 2);

          Pen.Color := BlendedColor(Column.Color, 12, 12, 12, False);
          MoveTo(BRect.Left, BRect.Bottom - 3);
          LineTo(BRect.Right, BRect.Bottom - 3);

          R2 := BRect;
          Inc(R2.Top, 3);
          Dec(R2.Bottom, 5);
          
          if R2.Bottom > R2.Top then
          begin
            Pen.Color := BlendedColor(Column.Color, 36, 36, 36, False);
            MoveTo(R2.Right - 2, R2.Top);
            LineTo(R2.Right - 2, R2.Bottom);

            Pen.Color := BlendedColor(Column.Color, 80, 80, 80, True);
            MoveTo(R2.Right - 1, R2.Top);
            LineTo(R2.Right - 1, R2.Bottom);
          end;
        end;
      end;
    end;
    schbMac:
    begin
      if InternalDraw and Column.Down then
      begin
        scFrame3D(C, BRect, clWindowFrame, cl3DDkShadow, 1, 0);
        scFrame3D(C, BRect, BlendedColor(Column.Color, 96, 96, 96, False),
          BlendedColor(Column.Color, 24, 24, 24, False), 1, 0);
      end else
      begin
        scFrame3D(C, BRect, clBtnShadow, cl3DDkShadow, 1, 0);
        scFrame3D(C, BRect, BlendedColor(Column.Color, 128, 128, 128, True),
          BlendedColor(Column.Color, 48, 48, 48, False), 1, 0);
      end;
    end;
    schbMetal:
    begin
      scFrame3D(C, BRect, GetBtnShadowOf(Column.Color),
        GetBtnShadowOf(Column.Color), 1, 0);

      if InternalDraw and Column.Down then
        scFrame3D(C, BRect, Column.Color, SCCommon.scBlendColor(Column.Color, 64), 1, 0)
      else
        scFrame3D(C, BRect, SCCommon.scBlendColor(Column.Color, 64), Column.Color, 1, 0);
    end;
  end;
end;

procedure TSCCustomHeader.DrawDragArrow;
var
  P, SP: TPoint;
  ColIndx, MidX, MidY: Integer;
  R1, R2: TRect;
  CurBrush: TBrush;
  CurPen: TPen;
  CurP: array [0..6] of TPoint;
  ColIsValid: Boolean;
begin
  if not ((Columns <> nil) and (Columns.Count > 0) and ColumnDragging and
    GetCursorPos(SP) and (FDragImageList <> nil) and FDragImageList.Dragging) then
    Exit;

  P := Self.ScreenToClient(SP);
  ColIndx := ColumnAtPos(P);
  ColIsValid := IsValidColumn(ColIndx);

  if ColIsValid then
  begin
    R1 := ColumnRect(ColIndx);

    R2 := R1;
    Inc(R2.Left, (R2.Right - R2.Left) div 2);

    if PtInRect(R2, P) then
    begin
      Inc(ColIndx);

      if IsValidColumn(ColIndx) then
        R1 := ColumnRect(ColIndx)
      else
      if ColIndx < 0 then
        R1 := ColumnRect(0)
      else
      if ColIndx > FColumns.Count-1 then
        R1 := ColumnRect(FColumns.Count-1)
    end;
  end;

  if ColIndx = FDraggedOnColumn then
    Exit;

  FDragImageList.HideDragImage;
  Invalidate;
  Application.ProcessMessages;

  if not ColIsValid then
  begin
    FDraggedOnColumn := ColIndx;
    FDragImageList.ShowDragImage;
    FDragImageList.DragMove(SP.X, SP.Y);

    Exit;
  end;

  MidX := R1.Right;
  if ColIndx < Columns.Count then
    MidX := R1.Left;

  R1.Left := MidX - 10;
  R1.Right := MidX + 10;
  MidY := R1.Top + ((R1.Bottom - R1.Top) div 2);

  with Canvas do
  begin
    CurBrush := TBrush.Create;
    CurPen := TPen.Create;

    try
      CurBrush.Assign(Brush);
      CurPen.Assign(Pen);

      Brush.Color := FArrowColor;
      Pen.Color := FArrowBorderColor;

      CurP[0] := Point(MidX, MidY);
      CurP[1] := Point(MidX - 7, MidY + 7);
      CurP[2] := Point(MidX - 7, MidY + 3);
      CurP[3] := Point(MidX - 10, MidY + 3);
      CurP[4] := Point(MidX - 10, MidY - 3);
      CurP[5] := Point(MidX - 7, MidY - 3);
      CurP[6] := Point(MidX - 7, MidY - 7);
      Polygon(CurP);

      CurP[0] := Point(MidX, MidY);
      CurP[1] := Point(MidX + 7, MidY + 7);
      CurP[2] := Point(MidX + 7, MidY + 3);
      CurP[3] := Point(MidX + 10, MidY + 3);
      CurP[4] := Point(MidX + 10, MidY - 3);
      CurP[5] := Point(MidX + 7, MidY - 3);
      CurP[6] := Point(MidX + 7, MidY - 7);
      Polygon(CurP);
    finally
      Brush.Assign(CurBrush);
      Pen.Assign(CurPen);
      CurBrush.Free;
      CurPen.Free;
    end;
  end;

  FDraggedOnColumn := ColIndx;
  FDragImageList.ShowDragImage;
end;

procedure TSCCustomHeader.DrawImageColumn(Column: TSCHeaderColumn;
  ColumnCanvas: TCanvas; const ARect: TRect; InternalDraw: Boolean);
var
  BRect: TRect;
begin
  if not Column.Visible or not IsValidImage(Column.ImageIndex) then
    Exit;

  BRect := ARect;
  BRect := CalculateImageRect(Column, BRect);
  if InternalDraw and Column.Down then
    OffsetRect(BRect, 1, 1);

  if (BRect.Right <= BRect.Left) or (BRect.Bottom <= BRect.Top) then
    Exit;

  Images.Draw(ColumnCanvas, BRect.Left, BRect.Top,
    Column.ImageIndex, Column.Enabled and Enabled);
end;

procedure TSCCustomHeader.DrawSizeLine(ACanvas: TCanvas; X, Y: Integer);
begin
  with ACanvas do
  begin
    Pen.Style := psSolid;
    Pen.Mode  := pmXor;
    Pen.Width := 2;
    Pen.Color := clGray;

    Brush.Style := bsClear;

    MoveTo(X, 0);
    LineTo(X, ClientHeight);
  end;
end;

procedure TSCCustomHeader.DrawTextColumn(Column: TSCHeaderColumn;
  ColumnCanvas: TCanvas; const ARect: TRect; InternalDraw: Boolean);
const
  AlignType: array[TAlignment] of DWORD = (DT_LEFT, DT_RIGHT, DT_CENTER);
  EllipsisFlags: array [Boolean] of Integer = (0, DT_END_ELLIPSIS);
var
  BRect: TRect;
  BStyle: TBrushStyle;
begin
  if not Column.Visible then
  Exit;

  with ColumnCanvas do
  begin
    BRect := ARect;

    case Column.Alignment of
      taLeftJustify:
        Inc(BRect.Left, Column.Indent + 1);
      taRightJustify:
        Dec(BRect.Right, Column.Indent + 1);
      taCenter:
      begin
        Inc(BRect.Left, Column.Indent);
        Dec(BRect.Right, Column.Indent);
      end;
    end;

    if InternalDraw and Column.Down then
      OffsetRect(BRect, 1, 1);

    if (BRect.Right <= BRect.Left) or (BRect.Bottom <= BRect.Top) then
      Exit;

    BStyle := Brush.Style;
    Brush.Style := bsClear;

    DrawText(Handle, PChar(Column.Text), Length(Column.Text), BRect,
      DT_SINGLELINE or DT_VCENTER or DWord(EllipsisFlags[Column.EndEllipsis]) or
      AlignType[Column.Alignment]);

    Brush.Style := BStyle;
  end;
end;

function TSCCustomHeader.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action);
end;

function TSCCustomHeader.GetBlendValue: Word;
begin
  Result := inherited GetBlendValue;

  if Result > 0 then
    Result := 16;
end;

function TSCCustomHeader.GetClickedColumn: Integer;
var
  P: TPoint;
begin
  Result := -1;
  if GetCursorPos(P) then
  begin
    P := ScreenToClient(P);
    Result := ColumnAtPos(P);

    if (Result > -1) and not FColumns[Result].Enabled then
      Result := -3;
  end;    
end;

function TSCCustomHeader.GetColumnDragging: Boolean;
begin
  Result := IsValidColumn(FDraggedColumn);
end;

function TSCCustomHeader.GetHitInfo(P: TPoint): TSCHeaderHitInfo;
var
  R, BRect: TRect;
begin
  with Result do
  begin
    X := P.X;
    Y := P.Y;
    Column := -1;
    HitPos := schtNowhere;
  end;

  R := SpaceRect;
  if PtInRect(R, P) then
  begin
    Result.HitPos := schtClient;

    if FColumns.Count > 0 then
    begin
      R.Right := R.Left + 6;

      if PtInRect(R, P) then
      begin
        Result.HitPos := schtColumnRight;
        if not Columns[Columns.Count-1].Sizable then
          Result.HitPos := schtColumn;
          
        Result.Column := FColumns.Count-1;
      end;
    end;

    Exit;
  end;

  if FColumns.Count = 0 then
  begin
    Result.HitPos := schtClient;
    Exit;
  end;

  Result.Column := ColumnAtPos(P);
  if Result.Column > -1 then
  begin
    R := ColumnRect(Result.Column);

    if R.Right - R.Left <= 0 then
    begin
      Result.Column := -1;
      Result.HitPos := schtNowhere;

      Exit;
    end;

    if R.Right - R.Left <= 12 then
    begin
      Result.HitPos := schtColumn;
      Exit;
    end;

    BRect := R;
    BRect.Left := BRect.Right - 6;

    if PtInRect(BRect, P) then
    begin
      Result.HitPos := schtColumnRight;
      if not Columns[Result.Column].Sizable or
        (AutoSize and (Result.Column = GetLastVisible)) then
        Result.HitPos := schtColumn;

      Exit;
    end;

    BRect := R;
    BRect.Right := BRect.Left + 6;

    if PtInRect(BRect, P) then
    begin
      Result.HitPos := schtColumnLeft;
      if (Result.Column = 0) or ((Result.Column > 0) and
        not Columns[Result.Column-1].Sizable) then
        Result.HitPos := schtColumn;

      Exit;
    end;

    if R.Right - R.Left > 0 then
      Result.HitPos := schtColumn;
  end;
end;

function TSCCustomHeader.GetHitTypeAt(X, Y: Integer): TSCColumnHitTest;
begin
  Result := GetHitInfo(Point(X, Y)).HitPos;
end;

function TSCCustomHeader.GetLastVisible: Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Columns.Count-1 downto 0 do
    if Columns[I].Visible then
    begin
      Result := I;
      Break;
    end;
end;

procedure TSCCustomHeader.InitializeHitTest(AHitInfo: PHeaderHitInfo);
begin
  with AHitInfo^ do
  begin
    X := -1;
    Y := -1;
    Column := -1;
    HitPos := schtNowhere;
  end;
end;

procedure TSCCustomHeader.InitiateColumnDrag(Col: Integer);
var
  ColBmp: TBitmap;
  W, H: Integer;
  R: TRect;
begin
  if not (IsValidColumn(Col) and FColumns[Col].Visible and FColumns[Col].Enabled) then
    Exit;

  R := ColumnRect(Col);
  OffsetRect(R, -R.Left, -R.Top);

  W := R.Right;
  H := R.Bottom;

  if (W = 0) or (H = 0) then
    Exit;

  ColBmp := TBitmap.Create;

  ColBmp.Width := W;
  ColBmp.Height := H;

  DrawColumn(FColumns[Col], ColBmp.Canvas, R, False);

  if FDragImageList <> nil then
    FreeAndNil(FDragImageList);

  FDragImageList := TImageList.CreateSize(W, H);
  FDragImageList.AddMasked(ColBmp, clNone);
  FDragImageList.DragCursor := Cursor;
end;

function TSCCustomHeader.IsValidColumn(Col: Integer): Boolean;
begin
  Result := (Col > -1) and (Col < FColumns.Count);
end;

procedure TSCCustomHeader.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  P: TPoint;
  AHitTest: TSCHeaderHitInfo;
  IsColumnClick: Boolean;
begin
  FMouseIsDown := Button = mbLeft;

  P := Point(X, Y);
  AHitTest := GetHitInfo(P);

  if (AHitTest.Column > -1) and
    not Columns[AHitTest.Column].Enabled then
  begin
    FColumnDblClicked := False;
    ResetHitInfo;

    Exit;
  end;

  if AHitTest.Column < 0 then
  begin
    FColumnDblClicked := False;
    FSizing := False;

    inherited MouseDown(Button, Shift, X, Y);
  end else
  begin
    FColumnClicked := Columns[AHitTest.Column].AllowClick and
      (AHitTest.HitPos = schtColumn);

    IsColumnClick := FColumnClicked and (AHitTest.HitPos = FHitInfo.HitPos);

    if IsColumnClick and (Button = mbLeft) and (ssDouble in Shift) and
      (AHitTest.Column = FHitInfo.Column) then
    begin
      FColumnDblClicked := True;

      if Assigned(Columns[AHitTest.Column].OnDblClick) then
        Columns[AHitTest.Column].OnDblClick(Columns[AHitTest.Column]);

      if Assigned(FOnColumnDblClick) then
        FOnColumnDblClick(Self, Columns[AHitTest.Column]);
    end else
      FColumnDblClicked := False;

    if FColumnClicked and Assigned(Columns[AHitTest.Column].OnMouseDown) then
    begin
      P := ClientToColumn(P);
      Columns[AHitTest.Column].OnMouseDown(Columns[AHitTest.Column], Button, Shift, P.X, P.Y);
    end;

    if FColumnClicked then
      Columns[AHitTest.Column].Down := True;

    FSizing := AHitTest.HitPos in [schtColumnLeft, schtColumnRight];

    if not FSizing and not Columns[AHitTest.Column].AllowClick then
      InitializeHitTest(@AHitTest);

    if FSizing and not FullDrag then
      Invalidate;
  end;

  FHitInfo := AHitTest;
  FMouseDownHitInfo := AHitTest;
end;

procedure TSCCustomHeader.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  AHitTest, OldHotTrackInfo: TSCHeaderHitInfo;
  Indx, SizedValue, OldSize: Integer;
  ColumnIsDragging: Boolean;
begin
  P := Point(X, Y);

  Indx := FHitInfo.Column;
  if FSizing then
  begin
    if (Indx < 0) or (Indx > Columns.Count-1) or
      not (FHitInfo.HitPos in [schtColumnLeft, schtColumnRight]) then
    begin
      ResetHitInfo;
      Exit;
    end;

    if FHitInfo.HitPos = schtColumnLeft then
      Dec(Indx);

    if (Indx < 0) or (Indx > Columns.Count-1) then
    begin
      ResetHitInfo;
      Exit;
    end;

    OldSize := Columns[Indx].Width;
    SizedValue := OldSize + (X - FHitInfo.X);

    if FullDrag then
    begin
      Columns[Indx].Width := SizedValue;

      if OldSize <> Columns[Indx].Width then
      begin
        FHitInfo.X := X;
        FHitInfo.Y := Y;
      end;
    end else
    begin
      FHitInfo.X := X;
      FHitInfo.Y := Y;
      Invalidate;
    end;

    if FHotTrack then
    begin
      AHitTest := GetHitInfo(P);
      FHottrackInfo := AHitTest;

      if (AHitTest.Column > -1) and (OldHotTrackInfo.Column <> AHitTest.Column) then
        UpdateColumn(AHitTest.Column, True);
    end;

    Exit;
  end;

  ColumnIsDragging := ColumnDragging;

  AHitTest := GetHitInfo(P);

  OldHotTrackInfo := FHottrackInfo;
  if not ColumnIsDragging and (OldHotTrackInfo.Column <> AHitTest.Column) then
    ResetHotTrackInfo;

  if not ColumnIsDragging then
  begin
    FDraggedColumn := -1;
    SetColumnCursor(AHitTest.HitPos);
  end;

  if FHotTrack and not ColumnIsDragging then
  begin
    FHottrackInfo := AHitTest;
    if (AHitTest.Column > -1) and (OldHotTrackInfo.Column <> AHitTest.Column) then
      UpdateColumn(AHitTest.Column, True);
  end;

  if FHitInfo.Column < 0 then
  begin
    if (AHitTest.Column > -1) and (AHitTest.Column < Columns.Count) then
    begin
      if Assigned(Columns[AHitTest.Column].OnMouseMove) then
      begin
        P := ClientToColumn(P);
        Columns[AHitTest.Column].OnMouseMove(Columns[AHitTest.Column], Shift, P.X, P.Y);
      end;
    end else
    begin
      ResetHotTrackInfo;
      inherited MouseMove(Shift, X, Y);
    end;
  end else
  if IsValidColumn(FHitInfo.Column) then
  begin
    if not ColumnIsDragging and MouseIsDown and (FHotTrackInfo.Column <> -1) then
      ResetHotTrackInfo;

    if FColumnClicked and not ColumnIsDragging then
      Columns[FHitInfo.Column].Down := AHitTest.Column = FHitInfo.Column;

    if (FHitInfo.HitPos = schtColumn) and Columns[FHitInfo.Column].Enabled then
    begin
      if Assigned(Columns[FHitInfo.Column].OnMouseMove) then
      begin
        P := ClientToColumn(P);
        Columns[FHitInfo.Column].OnMouseMove(Columns[FHitInfo.Column], Shift, X, Y);
      end;

      if ColumnIsDragging then
      begin
        ResetHotTrackInfo;
        DoColumnDragMove;
      end else
      if FDragReorder and FMouseIsDown and PtInRect(ClientRect, Point(X, Y)) and
        (Abs(FHitInfo.X - AHitTest.X) >= Mouse.DragThreshold) then
      begin
        FDraggedColumn := FHitInfo.Column;
        BeginColumnDragging(FDraggedColumn);
      end;
    end;
  end;
end;

procedure TSCCustomHeader.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  P: TPoint;
  AHitTest: TSCHeaderHitInfo;
  Indx: Integer;
begin
  FMouseIsDown := False;

  if ColumnDragging then
    StopDragging;

  if FSizing then
  begin
    Indx := FMouseDownHitInfo.Column;
    if not FullDrag then
    begin
      Invalidate;

      if FMouseDownHitInfo.HitPos = schtColumnLeft then
        Dec(Indx);

      if (Indx > -1) and (Indx < Columns.Count) then
        Columns[Indx].Width := Columns[Indx].Width + (X - FMouseDownHitInfo.X);
    end else
    begin
      if FMouseDownHitInfo.HitPos = schtColumnLeft then
        Dec(Indx);

      if IsValidColumn(Indx) then
        Columns[Indx].Width := Columns[Indx].Width + (X - FHitInfo.X);
    end;

    ResetHitInfo;

    if FHotTrack then
    begin
      AHitTest := GetHitInfo(P);
      FHottrackInfo := AHitTest;
      if (AHitTest.Column > -1) and (AHitTest.Column < Columns.Count) then
        UpdateColumn(AHitTest.Column, True);
    end;

    Exit;
  end;

  if FHitInfo.Column < 0 then
  begin
    ResetHitInfo;
    FColumnDblClicked := False;
    inherited MouseUp(Button, Shift, X, Y);
  end else
  if (FHitInfo.Column < Columns.Count) then
  begin
    Columns[FHitInfo.Column].Down := False;

    if not Columns[FHitInfo.Column].Enabled then
    begin
      FColumnDblClicked := False;
      ResetHitInfo;

      Exit;
    end;

    P := Point(X, Y);
    AHitTest := GetHitInfo(P);
    if AHitTest.Column > Columns.Count then
      AHitTest.Column := -1;

    if (AHitTest.Column > -1) and (AHitTest.Column = FHitInfo.Column) then
    begin
      if (Button = mbLeft) then
      begin
        if FColumnDblClicked then
        begin
          ResetHitInfo;
          FColumnDblClicked := False;
        end else
        begin
          if Assigned(Columns[AHitTest.Column].OnClick) then
            Columns[AHitTest.Column].OnClick(Columns[AHitTest.Column]);

          if Assigned(FOnColumnClick) then
            FOnColumnClick(Self, Columns[AHitTest.Column]);
        end;
      end;

      if Assigned(Columns[AHitTest.Column].OnMouseUp) then
      begin
        P := ClientToColumn(P);
        Columns[AHitTest.Column].OnMouseUp(Columns[AHitTest.Column], Button, Shift, P.X, P.Y);
      end;
    end else
    begin
      ResetHitInfo;
      FColumnDblClicked := False;
    end;
  end;

  FColumnClicked := False;
end;

procedure TSCCustomHeader.Paint;
var
  ColumnBmp: TBitmap;
  ARect, BRect: TRect;
  I: Integer;
begin
  ColumnBmp := TBitmap.Create;
  try
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := CurrentBlendedColor(Self.Color);
      Font.Assign(Self.Font);

      ARect := ClientRect;
      FillRect(ARect);

      for I := 0 to Columns.Count-1 do
      begin
        ARect := ColumnRect(I);

        with ColumnBmp do
        begin
          BRect := ARect;
          OffsetRect(BRect, -BRect.Left, -BRect.Top);

          Height := BRect.Bottom;
          Width := BRect.Right;

          DrawColumn(Columns[I], Canvas, BRect, True);
        end;

        Brush.Color := Columns[I].Color;
        Draw(ARect.Left, ARect.Top, ColumnBmp);
      end;
    end;

    DrawClientBevel(Canvas, SpaceRect);

    if FSizing and not FullDrag then
      DrawSizeLine(Canvas, FHitInfo.X, FHitInfo.Y);
  finally
    ColumnBmp.Free;
  end;
end;

procedure TSCCustomHeader.ResetHitInfo;
begin
  if not IsLoading and (Columns <> nil) and (FHitInfo.Column > -1) and
    (FHitInfo.Column < Columns.Count) then
    Columns[FHitInfo.Column].Down := False;

  InitializeHitTest(@FHitInfo);

  FSizing := False;
  FColumnClicked := False;
  FDraggedOnColumn := -1;
  SetColumnCursor(schtColumn);
end;

procedure TSCCustomHeader.ResetHotTrackInfo;
var
  Indx: Integer;
begin
  Indx := -1;
  if (Columns <> nil) and (FHotTrackInfo.Column > -1) and
    (FHotTrackInfo.Column < Columns.Count) then
    Indx := FHotTrackInfo.Column;

  InitializeHitTest(@FHottrackInfo);

  if Indx <> -1 then
    UpdateColumn(Indx, True);
end;

procedure TSCCustomHeader.SetAutoSize(Value: Boolean);
begin
  if AutoSize <> Value then
  begin
    inherited SetAutoSize(Value);
    
    if (FColumns <> nil) and (FColumns.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomHeader.SetClientBevel(Value: TSCHeaderColBevel);
begin
  if FClientBevel <> Value then
  begin
    FClientBevel := Value;
    if (Columns <> nil) and (Columns.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomHeader.SetColumns(Value: TSCHeaderColumns);
begin
  FColumns.Assign(Value);
end;

procedure TSCCustomHeader.SetColumnSpace(Value: Cardinal);
begin
  if FColumnSpace <> Value then
  begin
    FColumnSpace := Value;
    UpdateColumns;
  end;
end;

procedure TSCCustomHeader.SetFullDrag(Value: Boolean);
begin
  if FFullDrag <> Value then
  begin
    FFullDrag := Value;
    StopDragging;
  end;
end;

procedure TSCCustomHeader.SetHotTrack(Value: Boolean);
begin
  if FHotTrack <> Value then
  begin
    FHotTrack := Value;

    if (Columns <> nil) and (FHottrackInfo.Column > -1) and
      (FHottrackInfo.Column < -1) then
      UpdateColumn(FHottrackInfo.Column, True)
    else
      ResetHotTrackInfo;
  end;
end;

procedure TSCCustomHeader.SetHotTrackFontColor(Value: TColor);
begin
  if FHotTrackFontColor <> Value then
  begin
    FHotTrackFontColor := Value;

    if (Columns <> nil) and (FHottrackInfo.Column > -1) and
      (FHottrackInfo.Column < -1) then
      UpdateColumn(FHottrackInfo.Column, True)
    else
      ResetHotTrackInfo;
  end;
end;

procedure TSCCustomHeader.SetLimitClient(Value: Boolean);
begin
  if FLimitClient <> Value then
  begin
    FLimitClient := Value;
    UpdateColumns;
  end;
end;

function TSCCustomHeader.SpaceRect: TRect;
var
  R: TRect;
  Indx: Integer;
begin
  Result := ClientRect;
  Indx := GetLastVisible;

  if Indx > -1 then
  begin
    R := ColumnRect(Indx);

    if R.Right > Result.Right then
      R.Right := Result.Right;

    Result.Left := R.Right;
  end;
end;

procedure TSCCustomHeader.StopDragging;
var
  FromColumn, ToColumn: Integer;
begin
  FromColumn := FDraggedColumn;
  ToColumn := FDraggedOnColumn;

  if ColumnDragging then
    FDraggedColumn := -1;

  if (FDragImageList <> nil) then
  begin
    if FDragImageList.Dragging then
      FDragImageList.EndDrag;

    FreeAndNil(FDragImageList);
  end;

  ResetHitInfo;
  InitializeHitTest(@FMouseDownHitInfo);
  FColumnClicked := False;
  FColumnDblClicked := False;
  FMouseIsDown := False;

  DoColumnDrag(FromColumn, ToColumn);
end;

procedure TSCCustomHeader.UpdateColumn(Index: Integer; Repaint: Boolean);
var
  ARect, BRect: TRect;
  ColumnBmp: TBitmap;
begin
  if not (HandleAllocated and (Index < Columns.Count)) then Exit;

  ColumnBmp := TBitmap.Create;
  try
    ARect := ColumnRect(Index);
    with ColumnBmp do
    begin
      BRect := ARect;
      OffsetRect(BRect, -BRect.Left, -BRect.Top);

      Height := BRect.Bottom;
      Width := BRect.Right;

      DrawColumn(Columns[Index], Canvas, BRect, True);
    end;

    Canvas.Draw(ARect.Left, ARect.Top, ColumnBmp);

    if FSizing and not FullDrag then
      DrawSizeLine(Canvas, FHitInfo.X, FHitInfo.Y);
  finally
    ColumnBmp.Free;
  end;
end;

procedure TSCCustomHeader.UpdateColumnColors(OldColor: TColor);
var
  I: Integer;
begin
  if not HandleAllocated then Exit;

  for I := 0 to Columns.Count-1 do
    if (Columns[I].ParentColor) then
      Columns[I].Color := Self.Color;
end;

procedure TSCCustomHeader.UpdateColumns;
begin
  Invalidate;
end;

procedure TSCCustomHeader.WMCancelMode(var Message: TMessage);
begin
  ResetHitInfo;
  ResetHotTrackInfo;
  StopDragging;
  inherited;
end;

procedure TSCCustomHeader.WMSize(var Message: TWMSize);
begin
  { if not IsLoading then
    Resize; }
  inherited;
  Repaint;
end;

{ TSCImageBox }

constructor TSCSimpleImageBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 100;
  Width := 100;
  Color := clWindow;
  ParentColor := False;
end;

function TSCSimpleImageBox.GetBlendValue: Word;
begin
  Result := inherited GetBlendValue;
  if Result > 0 then Result := 16;
end;

procedure TSCSimpleImageBox.Paint;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := CurrentBlendedColor(Self.Color);
    Font.Assign(Self.Font);

    FillRect(ClientRect);
  end;
end;

procedure TSCCustomHeader.WMKeyDown(var Message: TWMKeyDown);
begin
  if Message.CharCode = VK_ESCAPE then
  begin
    if ColumnDragging then
      FDraggedOnColumn := -1;

    if FSizing or ColumnDragging then
      SendMessage(Handle, WM_LBUTTONUP, 0,
        MakeLong(FMouseDownHitInfo.X, FMouseDownHitInfo.Y));
  end;
end;

procedure TSCCustomHeader.SetColumnCursor(AHitType: TSCColumnHitTest);
begin
  if AHitType in [schtColumnLeft, schtColumnRight] then
  begin
    if (Cursor <> crHSplit) then
    begin
      FOldCursor := Cursor;
      Cursor := crHSplit;
    end;
  end else
    if Cursor = crHSplit then
      Cursor := FOldCursor;
end;

procedure TSCCustomHeader.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;
  Invalidate;
end;

procedure TSCCustomHeader.SetDefaultBevel(Value: TSCHeaderColBevel);
begin
  if FDefaultBevel <> Value then
  begin
    FDefaultBevel := Value;
    UpdateColumns;
  end;
end;

procedure TSCCustomHeader.EnabledChanged;
begin
  FColumnDblClicked := False;
  FSizing := False;

  ResetHitInfo;
  ResetHotTrackInfo;
  if ColumnDragging then StopDragging;

  Invalidate;
  inherited EnabledChanged;
end;

procedure TSCCustomHeader.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomHeader then
  begin
    with TSCCustomHeader(Source) do
    begin
      Self.ArrowColor := ArrowColor;
      Self.ArrowBorderColor := ArrowBorderColor;
      Self.ClientBevel := ClientBevel;
      Self.Columns := Columns;
      Self.ColumnSpace := ColumnSpace;
      Self.DefaultBevel := DefaultBevel;
      Self.DefaultColWidth := DefaultColWidth;
      Self.DragReorder := DragReorder;
      Self.FullDrag := FullDrag;
      Self.HotTrack := HotTrack;
      Self.HotTrackFontColor := HotTrackFontColor;
      Self.LimitClient := LimitClient;
    end;
  end;
end;

procedure TSCCustomHeader.DrawClientBevel(C: TCanvas; const ARect: TRect);
var
  SR: Integer;
  R, R2: TRect;
  C1, C2: TColor;
begin
  if (Columns.Count > 0) and (ClientBevel <> schbNone) and
    (C <> nil) and not IsRectEmpty(ARect) then
  begin
    R := ARect;
    SR := IntersectClipRect(C.Handle, R.Left, R.Top, R.Right, R.Bottom);
    try
      if SR <> NULLREGION then
      begin
        Inc(R.Right, 4);

        case ClientBevel of
          schbRaised:
            scFrame3D(C, R, clBtnHighlight, clBtnShadow, 1, 0);
          schbFlat:
            scFrame3D(C, R, clBtnShadow, clBtnShadow, 1, 0);
          schb3DRaised:
          begin
            scFrame3D(C, R, clBtnHighlight, cl3DDkShadow, 1, 0);
            scFrame3D(C, R, clBtnFace, clBtnShadow, 1, 0);
          end;
          schbSpace:
          begin
            with C do
            begin
              Pen.Color := clBtnHighlight;
              MoveTo(R.Left, R.Bottom-1);
              LineTo(R.Right, R.Bottom-1);

              Pen.Color := clBtnShadow;
              MoveTo(R.Left, R.Bottom-2);
              LineTo(R.Right, R.Bottom-2);
            end;  
          end;
          schbWinXP:
          begin
            with C do
            begin
              Pen.Color := BlendedColor(Self.Color, 36, 36, 36, False);
              MoveTo(R.Left, R.Bottom-1);
              LineTo(R.Right, R.Bottom-1);

              Pen.Color := BlendedColor(Self.Color, 24, 24, 24, False);
              MoveTo(R.Left, R.Bottom-2);
              LineTo(R.Right, R.Bottom-2);

              Pen.Color := BlendedColor(Self.Color, 12, 12, 12, False);
              MoveTo(R.Left, R.Bottom-3);
              LineTo(R.Right, R.Bottom-3);
            end;  
          end;
          schbMac:
          begin
            scFrame3D(C, R, clBtnShadow, cl3DDkShadow, 1, 0);
            scFrame3D(C, R, clBtnHighlight, clBtnShadow, 1, 0);
          end;
          schbMetal:
          begin
            scFrame3D(C, R, GetBtnShadowOf(Self.Color), GetBtnShadowOf(Self.Color), 1, 0);
            scFrame3D(C, R, SCCommon.scBlendColor(Self.Color, 64), Self.Color, 1, 0);
          end;
          schb3D, schb3DX:
          begin
            C1 := SCCommon.scBlendColor(Self.Color, 64);
            C2 := SCCommon.scBlendColor(Self.Color, -64);

            R2 := ARect;
            R2.Bottom := R2.Top + Round((R2.Bottom - R2.Top) / 2);

            scDrawGradient(C, R2, scgTopToBottom, C1, Self.Color);

            R2 := ARect;
            R2.Top := R2.Bottom - Round((R2.Bottom - R2.Top) / 2);

            scDrawGradient(C, R2, scgTopToBottom, Self.Color, C2);

            if FClientBevel = schb3DX then
            begin
              R2 := ARect;
              
              C1 := SCCommon.scBlendColor(Self.Color, 64);
              C2 := SCCommon.scBlendColor(Self.Color, -64);

              R2 := ARect;
              scFrame3D(C, R2, C1, C2, 1, 0);

              C1 := SCCommon.scBlendColor(Self.Color, 48);
              C2 := SCCommon.scBlendColor(Self.Color, -48);

              scFrame3D(C, R2, C1, C2, 1, 0);
            end;
          end;
        end;
      end;
    finally
      SelectClipRgn(C.Handle, 0);
    end;
  end;
end;

procedure TSCCustomHeader.AutoSizeChanged;
begin
  if Columns.Count > 0 then
    Invalidate;
end;

function TSCCustomHeader.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := True;
end;

{ TSCCustomBevel }

procedure TSCCustomBevel.AdjustBevelRect(var Rect: TRect);
begin
  //
end;

procedure TSCCustomBevel.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomBevel then
  begin
    with TSCCustomBevel(Source) do
    begin
      Self.Bevel := Bevel;
      Self.BevelColor := BevelColor;
      Self.BevelEdges := BevelEdges;
      Self.BevelWidth := BevelWidth;
    end;
  end;
end;

constructor TSCCustomBevel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(Left, Top, 50, 50);
  FBevel := sccbLowered;
  FBevelColor := clNone;
  FBevelEdges := SCAllBorderEdges;
  FBevelWidth := 0;
end;

function TSCCustomBevel.GetBevelSize: Integer;
begin
  Result := 0;
  if FBevel <> sccbNone then
  begin
    Inc(Result, FBevelWidth);

    if FBevel in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
      Inc(Result)
    else if FBevel in [sccbFlatBold, sccbFlatRounded, sccb3DRaised,
      sccb3DLowered, sccbBumped, sccbEtched, sccbMacLowered, sccbMacRaised,
      sccbMetal, sccbSoftLowered, sccbSoftRaised] then
      Inc(Result, 2);
  end;
end;

procedure TSCCustomBevel.Paint;
var
  R: TRect;
  C: TColor;
begin
  inherited Paint;

  if (FBevel <> sccbNone) and (FBevelEdges <> []) then
  begin
    R := ClientRect;
    AdjustBevelRect(R);

    C := FBevelColor;
    if C = clNone then
    begin
      C := Self.Color;
      if C = clNone then C := clBtnFace;

      if FBevel in [sccbFlat, sccbFlatBold,
        sccbFlatBoldRounded, sccbFlatRounded] then
        C := GetBtnShadowOf(C);
    end;

    scDrawBevel(Canvas, R, C, TSCFakeControl(Parent).Color, False, FBevel, FBevelEdges);
  end;
end;

procedure TSCCustomBevel.SetBevel(Value: TSCControlBevel);
begin
  if FBevel <> Value then
  begin
    FBevel := Value;
    if FBevelEdges <> [] then
      Invalidate;
  end;
end;

procedure TSCCustomBevel.SetBevelColor(Value: TColor);
begin
  if FBevelColor <> Value then
  begin
    FBevelColor := Value;
    if (FBevel <> sccbNone) and (FBevelEdges <> []) then
      Invalidate;
  end;
end;

procedure TSCCustomBevel.SetBevelEdges(Value: TSCBorderEdges);
begin
  if FBevelEdges <> Value then
  begin
    FBevelEdges := Value;
    if FBevel <> sccbNone then
      Invalidate;
  end;
end;

procedure TSCCustomBevel.SetBevelWidth(Value: TSCBevelWidth);
begin
  if FBevelWidth <> Value then
  begin
    FBevelWidth := Value;
    if (FBevel <> sccbNone) and (FBevelEdges <> []) then
      Invalidate;
  end;
end;

{$I SCVerRec.inc}

end.
