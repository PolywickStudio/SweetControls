{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCLookups;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdActns, Menus, Db, {$IFDEF SC_DELPHI6_UP} Variants, {$ENDIF} ImgList,
  ActnList, Clipbrd, SCCommon, SCConsts, SCResStrs, SCControl, SCDBCommon,
  SCAdvEdits;

type
  TSCCustomDBLookupListbox = class;

  TSCDBLookupProps = class(TSCCustomDBLookupData)
  public
    property Field;
    property KeyValue;
  published
    property DataField;
    property DataSource;
    property KeyField;
    property ListField;
    property ListFieldIndex;
    property ListSource;
  end;

  TSCLookupListboxBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccb3DLowered;
    property Color;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCLookupListboxScrollbar = class(TSCControlScrollbar)
  public
    constructor Create(AOwner: TSCCustomControl; AKind: TSCScrollbarKind); override;
  published
    property Background;
    property ButtonColors;
    property Icons;
    property SlideLine;
    property Thumb;
  end;

  TSCLookupListScrollbar = class(TSCControlCustomScrollbars)
  private
    function  GetExtraProps: TSCCustomControlScrollbar;
    procedure SetExtraProps(Value: TSCCustomControlScrollbar);
    function  GetWidth: Integer;
    procedure SetWidth(Value: Integer);
  published
    property ExtraProps: TSCCustomControlScrollbar read GetExtraProps write SetExtraProps;
    property Layout;
    property Style;
    property ThumbLines;
    property Width: Integer read GetWidth write SetWidth default -1;
  end;

  TSCDrawLookupListboxItemEvent = procedure(Sender: TObject; Rect: TRect;
    Enabled, Selected: Boolean; var Done: Boolean) of object;

  TSCCustomDBLookupListbox = class(TSCCustomScrollControl)
  private
    FRecordIndex: Integer;
    FRecordCount: Integer;
    FRowCount: Integer;
    FPopup: Boolean;
    FKeySelected: Boolean;
    FTracking: Boolean;
    FTimerActive: Boolean;
    FLockPosition: Boolean;
    FMousePos: Integer;
    FSelectedItem: string;
    FLookupProps: TSCDBLookupProps;
    FDisabledColor: TColor;
    FDisabledTextColor: TColor;
    FHideFocusRect: Boolean;
    FHideSelection: Boolean;
    FHideSelectionColor: TColor;
    FHideSelectionTextColor: TColor;
    FHighlightColor: TColor;
    FHighlightTextColor: TColor;
    FEndEllipsis: Boolean;
    FItemHeight: Integer;
    FUpdatingScrollbar: Integer;
    FScrollPosChanging: Integer;
    FOnDrawItem: TSCDrawLookupListboxItemEvent;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    procedure SetRowCount(Value: Integer);
    procedure SetLookupProps(Value: TSCDBLookupProps);
    procedure SetDisabledColor(Value: TColor);
    procedure SetDisabledTextColor(Value: TColor);
    procedure SetEndEllipsis(Value: Boolean);
    procedure SetHideFocusRect(Value: Boolean);
    procedure SetHideSelection(Value: Boolean);
    procedure SetHideSelectionColor(Value: TColor);
    procedure SetHideSelectionTextColor(Value: TColor);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHighlightTextColor(Value: TColor);
    procedure SetItemHeight(Value: Integer);

    function  GetKeyIndex: Integer;
    procedure SelectCurrent;
    procedure SelectItemAt(X, Y: Integer);
    procedure StopTimer;
    procedure TimerScroll;

    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMTimer(var Message: TMessage); message WM_TIMER;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  protected
    procedure CreateWnd; override;
    procedure Paint; override;
    procedure Loaded; override;

    procedure DoPaintBack(C: TCanvas); virtual;

    procedure DoPaintItem(C: TCanvas; Text: String; ClientR, R: TRect;
      Enabled, Selected: Boolean; Alignment: TAlignment);
    procedure DoDrawItem(C: TCanvas; Text: String; CR, R: TRect;
      Enabled, Selected: Boolean; Alignment: TAlignment); virtual;

    procedure BeforePaintItem(C: TCanvas; ClientR, R: TRect; Enabled,
      Selected: Boolean); virtual;
    procedure AfterPaintItem(C: TCanvas; ClientR, R: TRect; Enabled,
      Selected: Boolean); virtual;

    function  GetTextHeight: Integer; override;

    procedure StopTracking; override;
    procedure BorderChanged; override;
    procedure UpdateScrollBar;

    procedure DoScrollerPositionChanged(Kind: TSCScrollbarKind); override;
    procedure DoScrollerPositionChanging(Kind: TSCScrollbarKind; CurPos: Integer;
      var ScrollPos: Integer; var CanScroll: Boolean); override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetControlScrollbarsClass: TSCControlCustomScrollbarsClass; override;
    function  GetScrollbarClass: TSCCustomControlScrollbarClass; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    procedure KeyValueChanged(Sender: TObject); virtual;
    procedure ListLinkDataChanged(Sender: TObject); virtual;
    procedure UpdateListFields(Sender: TObject); virtual;

    property BorderProps;
    property LookupProps: TSCDBLookupProps read FLookupProps write SetLookupProps;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clBtnFace;
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default False;
    property HideFocusRect: Boolean read FHideFocusRect write SetHideFocusRect default False;
    property HideSelection: Boolean read FHideSelection write SetHideSelection default False;
    property HideSelectionColor: TColor read FHideSelectionColor write SetHideSelectionColor default clBtnFace;
    property HideSelectionTextColor: TColor read FHideSelectionTextColor write SetHideSelectionTextColor default clBtnText;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default clHighlight;
    property HighlightTextColor: TColor read FHighlightTextColor write SetHighlightTextColor default clHighlightText;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 0;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property RowCount: Integer read FRowCount write SetRowCount stored False;
    property Width;
    property Height;
    property OnDrawItem: TSCDrawLookupListboxItemEvent read FOnDrawItem write FOnDrawItem;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  ExecuteAction(Action: TBasicAction): Boolean; override;
    function  UpdateAction(Action: TBasicAction): Boolean; override;
    function  UseRightToLeftAlignment: Boolean; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    property SelectedItem: string read FSelectedItem;
    property Color default clWindow;
    property ParentColor default False;
    property TabStop default True;
  end;

  TSCDBLookupListbox = class(TSCCustomDBLookupListbox)
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderProps;
    property Color;
    property Constraints;
    property DisabledColor;
    property DisabledTextColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndEllipsis;
    property Font;
    property HideFocusRect;
    property HideSelection;
    property HideSelectionColor;
    property HideSelectionTextColor;
    property HighlightColor;
    property HighlightTextColor;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property LookupProps;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property RowCount;
    property Scrollbars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
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
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomDBLookupComboBox = class;

  TSCLookupPopupProps = class(TPersistent)
  private
    FOwner: TSCCustomDBLookupComboBox;
    FBorderStyle: TSCEditStyle;
    FColor: TColor;
    FEndEllipsis: Boolean;
    FHighlightColor: TColor;
    FHighlightTextColor: TColor;
    FItemHeight: Integer;
    procedure SetBorderStyle(Value: TSCEditStyle);
    procedure SetColor(Value: TColor);
    procedure SetEndEllipsis(Value: Boolean);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHighlightTextColor(Value: TColor);
    procedure SetItemHeight(Value: Integer);
    function  GetScrollbars: TSCLookupListScrollbar;
    procedure SetScrollbars(Value: TSCLookupListScrollbar);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TSCCustomDBLookupComboBox); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomDBLookupComboBox read FOwner;
  published
    property BorderStyle: TSCEditStyle read FBorderStyle write SetBorderStyle default scesDefault;
    property Color: TColor read FColor write SetColor default clWindow;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default False;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default clHighlight;
    property HighlightTextColor: TColor read FHighlightTextColor write SetHighlightTextColor default clHighlightText;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 0;
    property Scrollbars: TSCLookupListScrollbar read GetScrollbars write SetScrollbars;
  end;

  TSCCustomDBLookupComboBox = class(TSCCustomDropDown)
  private
    FDropDownRows: Integer;
    FDropDownWidth: Integer;
    FDataList: TSCCustomDBLookupListbox;
    FLookupProps: TSCDBLookupProps;
    FPopupProps: TSCLookupPopupProps;
    FPressed: Boolean;
    FTracking: Boolean;
    procedure SetLookupProps(Value: TSCDBLookupProps);
    procedure SetPopupProps(Value: TSCLookupPopupProps);

    procedure ListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure TrackButton(X, Y: Integer);

    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure CMBiDiModeChanged(var Message: TMessage); message CM_BIDIMODECHANGED;

    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function  GetReadOnly: Boolean; override;
    procedure SetReadOnly(Value: Boolean); override;

    function  GetLineText(Index: Integer): String; override;

    function  DoWantKeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    procedure KeyValueChanged(Sender: TObject); virtual;
    procedure UpdateListFields(Sender: TObject); virtual;

    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; override;

    function  GetAlignment: TAlignment; override;
    function  GetDropDownText: String; override;

    procedure StopTracking; override;

    function  GetPopupStyle: TSCEditStyle; override;
    procedure DropDownPopupbox; override;
    procedure CloseUp; overload; override;
    procedure CloseUp(Accept: Boolean); overload; override;
    procedure PrepareDropWindow; override;

    function  CanDropDown: Boolean; override;
    function  GetDroppedDown: Boolean; override;
    function  GetDropDownWindow: TWinControl; override;

    property IsDropDown default True;
    property LookupProps: TSCDBLookupProps read FLookupProps write SetLookupProps;
    property PopupProps: TSCLookupPopupProps read FPopupProps write SetPopupProps;
    property DropDownRows: Integer read FDropDownRows write FDropDownRows default 7;
    property DropDownWidth: Integer read FDropDownWidth write FDropDownWidth default 0;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
  end;

  TSCDBLookupComboBox = class(TSCCustomDBLookupComboBox)
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property BrowseButtonVisible;
    property ButtonClickKey;
    property ButtonInsideFrame;
    property ButtonProps;
    property Checkbox;
    property Color;
    property Colors;
    property Constraints;
    property Ctl3D;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownKey;
    property DropDownRows;
    property DropDownWidth;
    property Enabled;
    property EnterAsTab;
    property FocusExpandSize;
    property Font;
    property ImageIndex;
    property Images;
    property ImeMode;
    property ImeName;
    property Layout;
    property LookupProps;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property PopupProps;
    property ReadOnly;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property Visible;
    property OnBrowseClick;
    property OnClick;
    property OnCloseUp;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

type
  TPopupDataList = class(TSCCustomDBLookupListbox)
  private
    FInPopup: Boolean;
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    property InPopup: Boolean read FInPopup;
  end;

{ TSCLookupListboxBorderProps }

constructor TSCLookupListboxBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccb3DLowered;
end;

{ TSCLookupListboxScrollbar }

constructor TSCLookupListboxScrollbar.Create(AOwner: TSCCustomControl;
  AKind: TSCScrollbarKind);
begin
  inherited Create(AOwner, AKind);
  Track := False;
end;

{ TSCLookupListScrollbar }

function TSCLookupListScrollbar.GetExtraProps: TSCCustomControlScrollbar;
begin
  Result := Self.Vertical;
end;

function TSCLookupListScrollbar.GetWidth: Integer;
begin
  Result := Self.Height;
end;

procedure TSCLookupListScrollbar.SetExtraProps(
  Value: TSCCustomControlScrollbar);
begin
  Self.Vertical.Assign(Value);
end;

procedure TSCLookupListScrollbar.SetWidth(Value: Integer);
begin
  Self.Height := Value;
end;

{ TSCCustomDBLookupListbox }

procedure TSCCustomDBLookupListbox.AfterPaintItem(C: TCanvas; ClientR, R: TRect;
  Enabled, Selected: Boolean);
begin
  //
end;

procedure TSCCustomDBLookupListbox.Assign(Source: TPersistent);
begin
  if Source is TSCCustomDBLookupListbox then
    with TSCCustomDBLookupListbox(Source) do
    begin
      Self.LookupProps := LookupProps;
      Self.DisabledColor := DisabledColor;
      Self.DisabledTextColor := DisabledTextColor;
      Self.EndEllipsis := EndEllipsis;
      Self.HideFocusRect := HideFocusRect;
      Self.HideSelection := HideSelection;
      Self.HideSelectionColor := HideSelectionColor;
      Self.HideSelectionTextColor := HideSelectionTextColor;
      Self.HighlightColor := HighlightColor;
      Self.HighlightTextColor := HighlightTextColor;
      Self.ItemHeight := FItemHeight;
      Self.Picture := Picture;
      Self.ReadOnly := ReadOnly;
      Self.RowCount := RowCount;
    end;

  inherited Assign(Source);
end;

procedure TSCCustomDBLookupListbox.BeforePaintItem(C: TCanvas; ClientR, R: TRect;
  Enabled, Selected: Boolean);
begin
  //
end;

procedure TSCCustomDBLookupListbox.BorderChanged;
begin
  inherited BorderChanged;

  if not IsLoading then
  begin
    UpdateScrollBar;
    RowCount := RowCount;
  end;
end;

procedure TSCCustomDBLookupListbox.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls then
  begin
    RecreateWnd;
    RowCount := RowCount;
  end;
  inherited;
end;

procedure TSCCustomDBLookupListbox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Height := Height;
end;

constructor TSCCustomDBLookupListbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csDoubleClicks];
  DoubleBuffered := True;
  Width := 121;
  RowCount := 7;
  ParentColor := False;
  Color := clWindow;
  TabStop := True;
  Border := sccb3DLowered;

  FLookupProps := TSCDBLookupProps.Create(Self);
  FLookupProps.OnKeyValueChange := KeyValueChanged;
  FLookupProps.OnListLinkDataChange := ListLinkDataChanged;
  FLookupProps.OnUpdateListFields := UpdateListFields;

  FDisabledColor := clBtnFace;
  FDisabledTextColor := clGrayText;
  FHideFocusRect := False;
  FHideSelection := False;
  FHideSelectionColor := clBtnFace;
  FHideSelectionTextColor := clBtnText;
  FHighlightColor := clHighlight;
  FHighlightTextColor := clHighlightText;
end;

procedure TSCCustomDBLookupListbox.CreateWnd;
begin
  inherited CreateWnd;
  UpdateScrollBar;
end;

destructor TSCCustomDBLookupListbox.Destroy;
begin
  Destroying;

  FLookupProps.OnKeyValueChange := nil;
  FLookupProps.OnListLinkDataChange := nil;
  FLookupProps.OnUpdateListFields := nil;
  FreeAndNil(FLookupProps);
  inherited Destroy;
end;

procedure TSCCustomDBLookupListbox.DoDrawItem(C: TCanvas; Text: String;
  CR, R: TRect; Enabled, Selected: Boolean; Alignment: TAlignment);
var
  R2: TRect;
  Cl, Fcl: TColor;
  F: LongInt;
begin
  if (C = nil) or IsRectEmpty(R) or IsRectEmpty(CR) then
    Exit;

  with C do
  begin
    Brush.Style := bsClear;
    Font.Assign(Self.Font);

    Cl  := Self.Color;
    FCl := clNone;

    if not Enabled then
    begin
      Brush.Style := bsSolid;

      Cl := FDisabledColor;
      FCl := FDisabledTextColor;
      
      if Cl <> clNone then
      begin
        Brush.Color := Cl;
        FillRect(R);
      end;  
    end else
    if Selected then
    begin
      Brush.Style := bsSolid;

      Cl  := FHighlightColor;
      FCl := FHighlightTextColor;

      if not HasFocus then
      begin
        Cl := clNone;
        FCl := clNone;

        if not FHideSelection then
        begin
          Cl  := FHideSelectionColor;
          FCl := FHideSelectionTextColor;
        end;
      end;

      if Cl <> clNone then
      begin
        Brush.Color := Cl;
        FillRect(R);
      end;
    end;

    if FCl <> clNone then
      Font.Color := FCl;

    if Text <> '' then
    begin
      R2 := R;

      Inc(R2.Left, 2);
      Dec(R2.Right, 2);
      Inc(R2.Top);

      if IsRectEmpty(R2) then
        Exit;

      F := DT_LEFT or DT_TOP or DT_NOPREFIX or DT_SINGLELINE;
      case Alignment of
        taRightJustify:
          F := F or DT_RIGHT;
        taCenter:
          F := F or DT_CENTER;
      end;

      if FEndEllipsis then
        F := F or DT_END_ELLIPSIS;

      InflateRect(R2, -1, 0);

      Brush.Style := bsClear;
      DrawText(C.Handle, PChar(Text), Length(Text), R2, F);
    end;

    if not IsDesigning and not FHideFocusRect and
      Selected and HasFocus then
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      scDrawFocusRect(C, R, Cl);
    end;
  end;
end;

procedure TSCCustomDBLookupListbox.DoPaintBack(C: TCanvas);
var
  R: TRect;
begin
  if C = nil then
    Exit;

  if Transparent then
    PaintParentOn(C)
  else begin
    R := GetClientRect;
    if not IsRectEmpty(R) then
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Self.Color;

        FillRect(R);
      end;
  end;
end;

procedure TSCCustomDBLookupListbox.DoPaintItem(C: TCanvas; Text: String;
  ClientR, R: TRect; Enabled, Selected: Boolean; Alignment: TAlignment);
var
  R2: TRect;
  Done: Boolean;
begin
  if (C = nil) or IsRectEmpty(ClientR) or IsRectEmpty(R) or
    not IntersectRect(R2, R, ClientR) then
    Exit;

  BeforePaintItem(C, ClientR, R2, Enabled, Selected);

  try
    if IntersectClipRect(C.Handle, R2.Left,
      R2.Top, R2.Right, R2.Bottom) = NULLREGION then
      Exit;

    if SysLocale.MiddleEast then
      TControlCanvas(Canvas).UpdateTextFlags;

    if Assigned(FOnDrawItem) then
    begin
      Done := False;
      FOnDrawItem(Self, R2, Enabled, Selected, Done);

      if Done then
        Exit;
    end;

    if not IsRectEmpty(R2) then
      DoDrawItem(C, Text, ClientR, R2, Enabled, Selected, Alignment);
  finally
    SelectClipRgn(C.Handle, 0);
    AfterPaintItem(C, ClientR, R2, Enabled, Selected);
  end;
end;

procedure TSCCustomDBLookupListbox.DoScrollerPositionChanged(
  Kind: TSCScrollbarKind);
begin
  if FScrollPosChanging = 0 then
  begin
    Inc(FScrollPosChanging);
    try
      if (FLookupProps <> nil) and (Kind = scskVertical) then
        FLookupProps.SearchText := '';
    finally
      Dec(FScrollPosChanging);
    end;
  end;  
end;

procedure TSCCustomDBLookupListbox.DoScrollerPositionChanging(
  Kind: TSCScrollbarKind; CurPos: Integer; var ScrollPos: Integer;
  var CanScroll: Boolean);
var
  Sb: TSCLookupListboxScrollbar;
begin
  if FUpdatingScrollbar > 0 then
  begin
    CanScroll := True;
    Exit;
  end;

  CanScroll := False;

  Inc(FScrollPosChanging);
  try
    if (CurPos <> ScrollPos) and (FLookupProps <> nil) and (Kind = scskVertical) then
    begin
      FLookupProps.SearchText := '';

      Sb := TSCLookupListboxScrollbar(ScrollbarVert);
      
      with FLookupProps.ListLink.DataSet do
      begin
        if ScrollPos <= Sb.Min then
          First
        else if ScrollPos >= (Sb.Max - Sb.PageSize) then
          Last
        else if (CurPos - ScrollPos) = -Sb.PageSize then
          MoveBy(FRecordCount - FRecordIndex + FRecordCount - 2)
        else if (CurPos - ScrollPos) = Sb.PageSize then
          MoveBy(-FRecordIndex - FRecordCount + 1)
        else if CurPos < ScrollPos then
          MoveBy(FRecordCount - FRecordIndex)
        else if CurPos > ScrollPos then
          MoveBy(-FRecordIndex - 1);
      end;
    end;
  finally
    Dec(FScrollPosChanging);
  end;
end;

function TSCCustomDBLookupListbox.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := False;
  if FLookupProps <> nil then
    Result := inherited ExecuteAction(Action) or (FLookupProps.DataLink <> nil) and
      FLookupProps.DataLink.ExecuteAction(Action);
end;

function TSCCustomDBLookupListbox.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCLookupListboxBorderProps;
end;

function TSCCustomDBLookupListbox.GetControlScrollbarsClass: TSCControlCustomScrollbarsClass;
begin
  Result := TSCLookupListScrollbar;
end;

function TSCCustomDBLookupListbox.GetKeyIndex: Integer;
var
  KeyValue: Variant;
  FieldValue: Variant;
begin
  if FLookupProps <> nil then
  begin
    KeyValue := FLookupProps.KeyValue;

    if not VarIsNull(KeyValue) then
      for Result := 0 to FRecordCount - 1 do
      begin
        FLookupProps.ListLink.ActiveRecord := Result;

        FieldValue := FLookupProps.KeyFieldObj.Value;
        FLookupProps.ListLink.ActiveRecord := FRecordIndex;
        
        if scVarEquals(FieldValue, KeyValue) then Exit;
      end;
  end;

  Result := -1;
end;

function TSCCustomDBLookupListbox.GetReadOnly: Boolean;
begin
  Result := (FLookupProps <> nil) and FLookupProps.ReadOnly;
end;

function TSCCustomDBLookupListbox.GetScrollbarClass: TSCCustomControlScrollbarClass;
begin
  Result := TSCLookupListboxScrollbar;
end;

function TSCCustomDBLookupListbox.GetTextHeight: Integer;
begin
  Result := FItemHeight;
  if Result = 0 then
    Result := inherited GetTextHeight + 2;
end;

procedure TSCCustomDBLookupListbox.KeyDown(var Key: Word;
  Shift: TShiftState);
var
  Delta, KeyIndex: Integer;
begin
  inherited KeyDown(Key, Shift);

  if (FLookupProps <> nil) and FLookupProps.CanModify then
  begin
    Delta := 0;

    case Key of
      VK_UP, VK_LEFT:
        Delta := -1;
      VK_DOWN, VK_RIGHT:
        Delta := 1;
      VK_PRIOR:
        Delta := 1 - FRowCount;
      VK_NEXT:
        Delta := FRowCount - 1;
      VK_HOME:
        Delta := -Maxint;
      VK_END:
        Delta := Maxint;
    end;

    if Delta <> 0 then
    begin
      with FLookupProps do
      begin
        SearchText := '';

        if Delta = -Maxint then
          ListLink.DataSet.First
        else if Delta = Maxint then
          ListLink.DataSet.Last
        else begin
          KeyIndex := GetKeyIndex;

          if KeyIndex >= 0 then
            ListLink.DataSet.MoveBy(KeyIndex - FRecordIndex)
          else begin
            Self.KeyValueChanged(FLookupProps);
            Delta := 0;
          end;

          ListLink.DataSet.MoveBy(Delta);
        end;
      end;

        SelectCurrent;
    end;
  end;
end;

procedure TSCCustomDBLookupListbox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if FLookupProps <> nil then
    FLookupProps.ProcessSearchKey(Key);
end;

procedure TSCCustomDBLookupListbox.KeyValueChanged(Sender: TObject);
begin
  if FLookupProps <> nil then
    with FLookupProps do
    begin
      if ListActive and not FLockPosition and not LocateKey then
        ListLink.DataSet.First;

      if ListFieldObj <> nil then
        FSelectedItem := ListFieldObj.DisplayText
      else
        FSelectedItem := '';
    end;
end;

procedure TSCCustomDBLookupListbox.ListLinkDataChanged(Sender: TObject);
begin
  if FLookupProps <> nil then
  begin
    if FLookupProps.ListActive then
    begin
      FRecordIndex := FLookupProps.ListLink.ActiveRecord;
      FRecordCount := FLookupProps.ListLink.RecordCount;
      FKeySelected := not VarIsNull(FLookupProps.KeyValue) or
        not FLookupProps.ListLink.DataSet.BOF;
    end else
    begin
      FRecordIndex := 0;
      FRecordCount := 0;
      FKeySelected := False;
    end;
  end;
  
  if HandleAllocated then
  begin
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TSCCustomDBLookupListbox.Loaded;
begin
  inherited Loaded;
  UpdateScrollBar;
  Height := Height;
end;

procedure TSCCustomDBLookupListbox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if FLookupProps <> nil then
      FLookupProps.SearchText := '';

    if not FPopup then
    begin
      SetFocus;
      if not HasFocus then
        Exit;
    end;

    if (FLookupProps <> nil) and FLookupProps.CanModify then
      if ssDouble in Shift then
      begin
        if FRecordIndex = Y div GetTextHeight then
          DblClick;
      end else
      begin
        MouseCapture := True;
        FTracking := True;
        SelectItemAt(X, Y);
      end;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TSCCustomDBLookupListbox.MouseMove(Shift: TShiftState; X,
  Y: Integer);
begin
  if FTracking then
  begin
    SelectItemAt(X, Y);
    FMousePos := Y;
    TimerScroll;
  end;
  
  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomDBLookupListbox.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FTracking then
  begin
    StopTracking;
    SelectItemAt(X, Y);
  end;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomDBLookupListbox.Paint;
var
  S: String;
  C: TColor;
  CR, R: TRect;
  KeyVal: Variant;
  Selected: Boolean;
  FieldItem: TField;
  AAlignment: TAlignment;
  I, J, CW, W, TextHeight,
  TextWidth, LastFieldIndex: Integer;
begin
  DoPaintBack(Canvas);
  DrawPicture(Canvas);

  if FLookupProps = nil then
    Exit;

  Canvas.Font := Font;
  TextWidth := Canvas.TextWidth('0');
  TextHeight := GetTextHeight;

  with FLookupProps do
  begin
    CR := ClientRect;
    CW := CR.Right - CR.Left;

    C := clBtnFace;
    if ColorToRGB(Self.Color) = ColorToRGB(clBtnFace) then
      C := clBtnShadow;

    LastFieldIndex := ListFields.Count - 1;

    for I := 0 to FRowCount - 1 do
    begin
      Selected := not FKeySelected and (I = 0);

      R.Left := 0;
      R.Right := CW;

      R.Top := I * TextHeight;
      R.Bottom := R.Top + TextHeight;

      if not IsRectEmpty(R) and (I < FRecordCount) then
      begin
        R.Right := 0;
        ListLink.ActiveRecord := I;

        KeyVal := KeyValue;
        if not VarIsNull(KeyVal) and scVarEquals(KeyFieldObj.Value, KeyVal) then
          Selected := True;

        for J := 0 to LastFieldIndex do
        begin
          FieldItem := ListFields[J];

          S := FieldItem.DisplayText;

          if J < LastFieldIndex then
            W := FieldItem.DisplayWidth * TextWidth + 4
          else
            W := CW - R.Right;

          AAlignment := FieldItem.Alignment;
          if UseRightToLeftAlignment then
            ChangeBiDiModeAlignment(AAlignment);

          R.Left := R.Right;
          Inc(R.Right, W);

          if R.Left > CW then R.Left := CW;
          if R.Left < 0 then R.Left := 0;

          if R.Right > CW then R.Right := CW;
          if R.Right < 0 then R.Right := 0;

          DoPaintItem(Canvas, S, CR, R, Self.Enabled, Selected, AAlignment);

          if J < LastFieldIndex then
          begin
            with Canvas do
            begin
              Pen.Width := 1;
              Pen.Style := psSolid;
              Pen.Color := C;

              MoveTo(R.Right, R.Top);
              LineTo(R.Right, R.Bottom);
            end;  

            Inc(R.Right);
            if R.Right >= CW - 2 then
              Break;
          end;
        end;
      end;

      R.Left := 0;
      R.Right := CW;

      if not IsDesigning and HasFocus and
        not FHideFocusRect and Selected and (FRecordCount = 0) then
      begin
        Brush.Style := bsSolid;
        Brush.Color := Self.Color;

        scDrawFocusRect(Canvas, R, Self.Color);
      end;
    end;

    if FRecordCount <> 0 then
      ListLink.ActiveRecord := FRecordIndex;
  end;
end;

procedure TSCCustomDBLookupListbox.SelectCurrent;
begin
  if FLookupProps <> nil then
  begin
    FLockPosition := True;
    try
      FLookupProps.SelectKeyValue(FLookupProps.KeyFieldObj.Value);
    finally
      FLockPosition := False;
    end;
  end;
end;

procedure TSCCustomDBLookupListbox.SelectItemAt(X, Y: Integer);
var
  Delta: Integer;
begin
  if FLookupProps <> nil then
  begin
    if Y < 0 then Y := 0;
    if Y >= ClientHeight then Y := ClientHeight - 1;
    Delta := Y div GetTextHeight - FRecordIndex;

    FLookupProps.ListLink.DataSet.MoveBy(Delta);
    SelectCurrent;
  end;  
end;

procedure TSCCustomDBLookupListbox.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
var
  BorderSize, TextHeight, Rows: Integer;
begin
  if IsLoading then
  begin
    inherited SetBounds(ALeft, ATop, AWidth, AHeight);
    Exit;
  end;

  BorderSize := 2*(GetBorderSize + BorderWidth + GetInnerBorderSize);

  TextHeight := GetTextHeight;
  Rows := (AHeight - BorderSize) div TextHeight;

  if Rows < 1 then Rows := 1;
  FRowCount := Rows;

  if FLookupProps <> nil then
    if FLookupProps.ListLink.BufferCount <> Rows then
    begin
      FLookupProps.ListLink.BufferCount := Rows;
      ListLinkDataChanged(FLookupProps);
    end;

  inherited SetBounds(ALeft, ATop, AWidth, Rows * TextHeight + BorderSize);
end;

procedure TSCCustomDBLookupListbox.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomDBLookupListbox.SetDisabledTextColor(Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomDBLookupListbox.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    Invalidate;
  end;
end;

procedure TSCCustomDBLookupListbox.SetHideFocusRect(Value: Boolean);
begin
  if FHideFocusRect <> Value then
  begin
    FHideFocusRect := Value;
    if HasFocus then
      Invalidate;
  end;
end;

procedure TSCCustomDBLookupListbox.SetHideSelection(Value: Boolean);
begin
  if FHideSelection <> Value then
  begin
    FHideSelection := Value;
    if not HasFocus then
      Invalidate;
  end;
end;

procedure TSCCustomDBLookupListbox.SetHideSelectionColor(Value: TColor);
begin
  if FHideSelectionColor <> Value then
  begin
    FHideSelectionColor := Value;
    if not FHideSelection and not HasFocus then
      Invalidate;
  end;
end;

procedure TSCCustomDBLookupListbox.SetHideSelectionTextColor(Value: TColor);
begin
  if FHideSelectionTextColor <> Value then
  begin
    FHideSelectionTextColor := Value;
    if not FHideSelection and not HasFocus then
      Invalidate;
  end;
end;

procedure TSCCustomDBLookupListbox.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    if HasFocus then
      Invalidate;
  end;
end;

procedure TSCCustomDBLookupListbox.SetHighlightTextColor(Value: TColor);
begin
  if FHighlightTextColor <> Value then
  begin
    FHighlightTextColor := Value;
    if HasFocus then
      Invalidate;
  end;
end;

procedure TSCCustomDBLookupListbox.SetItemHeight(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FItemHeight <> Value then
  begin
    FItemHeight := Value;
    
    UpdateScrollBar;
    RowCount := RowCount;
  end;
end;

procedure TSCCustomDBLookupListbox.SetLookupProps(Value: TSCDBLookupProps);
begin
  FLookupProps.Assign(Value);
end;

procedure TSCCustomDBLookupListbox.SetReadOnly(Value: Boolean);
begin
  if FLookupProps <> nil then
    FLookupProps.ReadOnly := Value;
end;

procedure TSCCustomDBLookupListbox.SetRowCount(Value: Integer);
var
  B: Integer;
begin
  if Value < 1 then Value := 1;
  if Value > 100 then Value := 100;

  if IsLoading then
  begin
    FRowCount := Value;
    Exit;
  end;

  B := 2*(GetBorderSize + BorderWidth + GetInnerBorderSize);
  Height := Value * GetTextHeight + B;
end;

procedure TSCCustomDBLookupListbox.StopTimer;
begin
  if FTimerActive then
  begin
    KillTimer(Handle, 1);
    FTimerActive := False;
  end;
end;

procedure TSCCustomDBLookupListbox.StopTracking;
begin
  inherited StopTracking;
  
  if FTracking then
  begin
    StopTimer;
    FTracking := False;
    MouseCapture := False;
  end;
end;

procedure TSCCustomDBLookupListbox.TimerScroll;
var
  Delta, Distance, Interval: Integer;
begin
  Delta := 0;
  Distance := 0;

  if FMousePos < 0 then
  begin
    Delta := -1;
    Distance := -FMousePos;
  end;

  if FMousePos >= ClientHeight then
  begin
    Delta := 1;
    Distance := FMousePos - ClientHeight + 1;
  end;

  if Delta = 0 then
    StopTimer
  else if FLookupProps <> nil then
  begin
    if FLookupProps.ListLink.DataSet.MoveBy(Delta) <> 0 then
      SelectCurrent;

    Interval := 200 - Distance * 15;
    if Interval < 0 then Interval := 0;

    SetTimer(Handle, 1, Interval, nil);
    FTimerActive := True;
  end;
end;

function TSCCustomDBLookupListbox.UpdateAction(
  Action: TBasicAction): Boolean;
begin
  Result := False;
  if FLookupProps <> nil then
    Result := inherited UpdateAction(Action) or (FLookupProps.DataLink <> nil) and
      FLookupProps.DataLink.UpdateAction(Action);
end;

procedure TSCCustomDBLookupListbox.UpdateListFields(Sender: TObject);
begin
  if FLookupProps <> nil then
  begin
    if FLookupProps.ListActive then
      KeyValueChanged(FLookupProps)
    else
      ListLinkDataChanged(FLookupProps);
  end;
end;

procedure TSCCustomDBLookupListbox.UpdateScrollBar;
var
  Pos, Max, Page: Integer;
  SiOld, SiNew: TSCScrollInfo;
begin
  if HandleAllocated and not IsLoading then
  begin
    Inc(FUpdatingScrollbar);

    try
      Pos := 0;
      Max := 0;
      Page := 1;
    
      if (FLookupProps <> nil) and (FRecordCount = FRowCount) then
      begin
        Max := 8;
        Page := 2;
        if not FLookupProps.ListLink.DataSet.BOF then
        begin
          Pos := 8;
          if not FLookupProps.ListLink.DataSet.EOF then
            Pos := 3;
        end;
      end;

      SiOld := Self.GetScrollbarInfo(scskVertical);

      SiNew := SiOld;
      SiNew.Min  := 0;

      SiNew.Min  := 0;
      SiNew.Max  := Max;
      SiNew.Pos  := Pos;

      SiNew.Page := Page;
      SiNew.Visible := (SiNew.Page > -1) and (SiNew.Max > 0) and
        (SiNew.Max - SiNew.Min > 0) and (SiNew.Page < SiNew.Max - SiNew.Min);

      SiNew.TrimPageSize := True;
      SiNew.LargeChange  := SiNew.Page;

      if (SiNew.Max <> SiOld.Max) or (SiNew.Pos <> SiOld.Pos) or
        (SiNew.Visible <> SiOld.Visible) then
        Self.SetScrollbarInfo(scskVertical, SiNew);
    finally
      Dec(FUpdatingScrollbar);
    end;
  end;
end;

function TSCCustomDBLookupListbox.UseRightToLeftAlignment: Boolean;
begin
  Result := (FLookupProps <> nil) and
    DBUseRightToLeftAlignment(Self, FLookupProps.Field);
end;

procedure TSCCustomDBLookupListbox.WMCancelMode(var Message: TMessage);
begin
  StopTracking;
  inherited;
end;

procedure TSCCustomDBLookupListbox.WMGetDlgCode(
  var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := DLGC_WANTARROWS;
end;

procedure TSCCustomDBLookupListbox.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if not IsDesigning and (FLookupProps <> nil) then
  begin
    FLookupProps.SearchText := '';
    with FLookupProps.ListLink.DataSet do
    begin
      if Message.WheelDelta < 0 then
        MoveBy(FRecordCount - FRecordIndex)
      else
      if Message.WheelDelta > 0 then
        MoveBy(-FRecordIndex - 1);
    end;
  end;
end;

procedure TSCCustomDBLookupListbox.WMTimer(var Message: TMessage);
begin
  inherited;
  TimerScroll;
end;

procedure TSCCustomDBLookupListbox.WMVScroll(var Message: TWMVScroll);
begin
  if IsDesigning and (FLookupProps <> nil) then
  begin
    inherited;
    Exit;
  end;

  FLookupProps.SearchText := '';
  with Message, FLookupProps.ListLink.DataSet do
    case ScrollCode of
      SB_LINEUP:
        MoveBy(-FRecordIndex - 1);
      SB_LINEDOWN:
        MoveBy(FRecordCount - FRecordIndex);
      SB_PAGEUP:
        MoveBy(-FRecordIndex - FRecordCount + 1);
      SB_PAGEDOWN:
        MoveBy(FRecordCount - FRecordIndex + FRecordCount - 2);
      SB_THUMBPOSITION:
      begin
        case Pos of
          0: First;
          1: MoveBy(-FRecordIndex - FRecordCount + 1);
          2: Exit;
          3: MoveBy(FRecordCount - FRecordIndex + FRecordCount - 2);
          4: Last;
        end;
      end;
      SB_BOTTOM:
        Last;
      SB_TOP:
        First;
    end;
end;

{ TPopupDataList }

constructor TPopupDataList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable];
  ClickFocus := False;
  FPopup := True;
end;

procedure TPopupDataList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    Style := WS_POPUP and not WS_BORDER;

    ExStyle := WS_EX_TOOLWINDOW;
    AddBiDiModeExStyle(ExStyle);
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TPopupDataList.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

{ TSCCustomDBLookupComboBox }

procedure TSCCustomDBLookupComboBox.Assign(Source: TPersistent);
begin
  inherited;

end;

function TSCCustomDBLookupComboBox.CanDropDown: Boolean;
begin
  Result := not IsDesigning and (FLookupProps <> nil) and
    FLookupProps.ListActive and not GetDroppedDown;
end;

procedure TSCCustomDBLookupComboBox.CloseUp;
begin
  CloseUp(False);
end;

procedure TSCCustomDBLookupComboBox.CloseUp(Accept: Boolean);
var
  ListValue: Variant;
begin
  if GetDroppedDown then
  begin
    if GetCapture <> 0 then
      SendMessage(GetCapture, WM_CANCELMODE, 0, 0);

    ListValue := FDataList.LookupProps.KeyValue;
    
    SetWindowPos(FDataList.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);

    SetDroppedDownFlag(False);
    TPopupDataList(FDataList).FInPopup := False;

    FDataList.LookupProps.ListSource := nil;

    Invalidate;
    FLookupProps.SearchText := '';

    if Accept and FLookupProps.CanModify then
      FLookupProps.SelectKeyValue(ListValue);

    AfterCloseUp;  
    DoCloseUp;
  end;
end;

procedure TSCCustomDBLookupComboBox.CMBiDiModeChanged(var Message: TMessage);
begin
  inherited;
  FDataList.BiDiMode := BiDiMode;
end;

procedure TSCCustomDBLookupComboBox.CMCancelMode(
  var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and (Message.Sender <> FDataList) then
    CloseUp(False);
end;

procedure TSCCustomDBLookupComboBox.CMDialogKey(var Message: TCMDialogKey);
begin
  if (Message.CharCode in [VK_RETURN, VK_ESCAPE]) and GetDroppedDown then
  begin
    CloseUp(Message.CharCode = VK_RETURN);
    Message.Result := 1;
  end else
    inherited;
end;

procedure TSCCustomDBLookupComboBox.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := 0;
  if FLookupProps <> nil then
    Message.Result := Integer(FLookupProps.DataLink);
end;

constructor TSCCustomDBLookupComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 145;
  IsDropDown := True;
  UseUndo := False;

  FDataList := TPopupDataList.Create(Self);
  FDataList.FreeNotification(Self);

  FDataList.Visible := False;
  FDataList.Parent := Self;
  FDataList.OnMouseUp := ListMouseUp;
  FDropDownRows := 7;

  FPopupProps := TSCLookupPopupProps.Create(Self);

  FLookupProps := TSCDBLookupProps.Create(Self);
  FLookupProps.OnKeyValueChange := KeyValueChanged;
  FLookupProps.OnUpdateListFields := UpdateListFields;
end;

destructor TSCCustomDBLookupComboBox.Destroy;
begin
  Destroying;

  FreeAndNil(FPopupProps);

  FLookupProps.OnKeyValueChange := nil;
  FLookupProps.OnUpdateListFields := nil;
  FreeAndNil(FLookupProps);

  FreeAndNil(FDataList);
  inherited Destroy;
end;

function TSCCustomDBLookupComboBox.DoWantKeyDown(var Key: Word;
  Shift: TShiftState): Boolean;
begin
  if (Key = VK_ESCAPE) and (FDataList <> nil) and
    FDataList.HandleAllocated and IsWindowVisible(FDataList.Handle) then
  begin
    Result := FDataList.Focused;
    if Result then
      Exit;
  end;

  Result := inherited DoWantKeyDown(Key, Shift);
end;

procedure TSCCustomDBLookupComboBox.DropDownPopupbox;
var
  P: TPoint;
  Y: Integer;
begin
  if CanDropDown and AllowDropDown then
  begin
    PrepareDropWindow;

    Windows.SetFocus(Handle);
    if GetFocus <> Handle then
      Exit;

    SetDropState(sccsDropping);
    try
      DoDropDown;

      P := Parent.ClientToScreen(Point(Left, Top));
      Y := P.Y + Height;

      if Y + FDataList.Height > Screen.Height then
        Y := P.Y - FDataList.Height;

      SetWindowPos(FDataList.Handle, HWND_TOP, P.X, Y, 0, 0,
        SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);

      SetDroppedDownFlag(True);
      TPopupDataList(FDataList).FInPopup := True;
    finally
      SetDropState(sccsDefault);
      Repaint;

      AfterDropDown;  
    end;
  end;
end;

function TSCCustomDBLookupComboBox.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := False;
  if FLookupProps <> nil then
    Result := inherited ExecuteAction(Action) or (FLookupProps.DataLink <> nil) and
      FLookupProps.DataLink.ExecuteAction(Action);
end;

function TSCCustomDBLookupComboBox.GetAlignment: TAlignment;
begin
  Result := Self.Alignment;
  if (csPaintCopy in ControlState) and (FLookupProps.Field <> nil) and
    (FLookupProps.Field.Lookup) then
    Result := FLookupProps.Field.Alignment;

  if UseRightToLeftAlignment then
    ChangeBiDiModeAlignment(Result);
end;

function TSCCustomDBLookupComboBox.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCDropDownButtonProps;
end;

function TSCCustomDBLookupComboBox.GetDropDownText: String;
begin
  Result := Self.Text;
  if (csPaintCopy in ControlState) and (FLookupProps.Field <> nil) and
    (FLookupProps.Field.Lookup) then
    Result := FLookupProps.Field.DisplayText
  else
  if IsDesigning and (FLookupProps.Field = nil) then
    Result := Name;
end;

function TSCCustomDBLookupComboBox.GetDropDownWindow: TWinControl;
begin
  Result := FDataList;
end;

function TSCCustomDBLookupComboBox.GetDroppedDown: Boolean;
begin
  Result := GetDroppedDownFlag and
   (FDataList <> nil) and TPopupDataList(FDataList).InPopup;
end;

function TSCCustomDBLookupComboBox.GetReadOnly: Boolean;
begin
  Result := False;
  if FLookupProps <> nil then
    Result := FLookupProps.ReadOnly;
end;

procedure TSCCustomDBLookupComboBox.KeyDown(var Key: Word;
  Shift: TShiftState);
var
  Delta: Integer;
begin
  if DoDropDownKeys(Key, Shift) then
    Exit;

  inherited KeyDown(Key, Shift);

  if FLookupProps <> nil then
  begin
    if FLookupProps.ListActive and ((Key = VK_UP) or (Key = VK_DOWN)) then
    begin
      if not GetDroppedDown then
        with FLookupProps do
        begin
          if not LocateKey then
            ListLink.DataSet.First
          else begin
            Delta := 1;
            if Key = VK_UP then Delta := -1;

            ListLink.DataSet.MoveBy(Delta);
          end;

          SelectKeyValue(KeyFieldObj.Value);
          Key := 0;
        end;
    end;

    if (Key <> 0) and GetDroppedDown then
      FDataList.KeyDown(Key, Shift);
  end;
end;

procedure TSCCustomDBLookupComboBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  
  if GetDroppedDown then
  begin
    if Key in [#13, #27] then
      CloseUp(Key = #13)
    else
      FDataList.KeyPress(Key);
  end else
  if FLookupProps <> nil then
    FLookupProps.ProcessSearchKey(Key);
end;

procedure TSCCustomDBLookupComboBox.KeyValueChanged(Sender: TObject);
begin
  if FLookupProps <> nil then
  begin
    with FLookupProps do
      if LookupMode then
      begin
        // Caption := Field.DisplayText;
        Text := Field.DisplayText;
        Alignment := Field.Alignment;
      end else
      if ListActive and LocateKey then
      begin
        // Caption := ListFieldObj.DisplayText;
        Text := ListFieldObj.DisplayText;
        Alignment := ListFieldObj.Alignment;
      end else
      begin
        // Caption := '';
        Text := '';
        Alignment := taLeftJustify;
      end;

    Invalidate;
  end;
end;

procedure TSCCustomDBLookupComboBox.ListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    CloseUp(PtInRect(FDataList.ClientRect, Point(X, Y)));
end;

procedure TSCCustomDBLookupComboBox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and not (ssDouble in Shift) then
  begin
    SetFocus;
    if not HasFocus then
      Exit;

    if GetDroppedDown then
      CloseUp(False)
    else if FLookupProps.ListActive then
    begin
      MouseCapture := True;
      FTracking := True;
      TrackButton(X, Y);
      DropDown;
    end;
  end;

  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TSCCustomDBLookupComboBox.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  ListPos: TPoint;
  MousePos: TSmallPoint;
begin
  if FTracking then
  begin
    TrackButton(X, Y);

    if GetDroppedDown then
    begin
      ListPos := FDataList.ScreenToClient(ClientToScreen(Point(X, Y)));

      if PtInRect(FDataList.ClientRect, ListPos) then
      begin
        StopTracking;
        MousePos := PointToSmallPoint(ListPos);
        SendMessage(FDataList.Handle, WM_LBUTTONDOWN, 0, Integer(MousePos));
        
        Exit;
      end;
    end;
  end;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomDBLookupComboBox.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  StopTracking;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomDBLookupComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = FDataList) then
    FDataList := nil;
end;

procedure TSCCustomDBLookupComboBox.PrepareDropWindow;
var
  S: String;
  I: Integer;
begin
  if FDataList = nil then
    Exit;

  BeforePrepareDropWindow;

  with TPopupDataList(FDataList) do
  begin
    ParentColor := False;
    Color := Self.FPopupProps.Color;
    Font := Self.Font;
    EndEllipsis := Self.FPopupProps.EndEllipsis;
    HideSelection := False;
    HideSelectionColor := Self.FPopupProps.HighlightColor;
    HideSelectionTextColor := Self.FPopupProps.HighlightTextColor;
    HighlightColor := Self.FPopupProps.HighlightColor;
    HighlightTextColor := Self.FPopupProps.HighlightTextColor;
    ItemHeight := ItemHeight;

    ApplyPopupBorder(TPopupDataList(FDataList));

    if FDropDownWidth > 0 then
      Width := Self.FDropDownWidth
    else
      Width := Self.Width;
  end;

  FDataList.ReadOnly := not FLookupProps.CanModify;

  if (FLookupProps.ListLink.DataSet.RecordCount > 0) and
     (FDropDownRows > FLookupProps.ListLink.DataSet.RecordCount) then
    FDataList.RowCount := FLookupProps.ListLink.DataSet.RecordCount
  else
    FDataList.RowCount := FDropDownRows;

  FDataList.LookupProps.KeyField := FLookupProps.KeyField;
  for I := 0 to Self.FLookupProps.ListFields.Count - 1 do
    S := S + TField(Self.FLookupProps.ListFields[I]).FieldName + ';';

  FDataList.LookupProps.ListField := S;
  FDataList.LookupProps.ListFieldIndex := FLookupProps.ListFields.IndexOf(FLookupProps.ListFieldObj);

  FDataList.LookupProps.ListSource := FLookupProps.ListLink.DataSource;
  FDataList.LookupProps.KeyValue := FLookupProps.KeyValue;
end;

procedure TSCCustomDBLookupComboBox.SetPopupProps(
  Value: TSCLookupPopupProps);
begin
  FPopupProps.Assign(Value);
end;

procedure TSCCustomDBLookupComboBox.SetLookupProps(
  Value: TSCDBLookupProps);
begin
  FLookupProps.Assign(Value);
end;

procedure TSCCustomDBLookupComboBox.SetReadOnly(Value: Boolean);
begin
  if FLookupProps <> nil then
    FLookupProps.ReadOnly := Value;
end;

procedure TSCCustomDBLookupComboBox.StopTracking;
begin
  if FTracking then
  begin
    TrackButton(-1, -1);
    FTracking := False;
    MouseCapture := False;
  end;
  
  inherited StopTracking;
end;

procedure TSCCustomDBLookupComboBox.TrackButton(X, Y: Integer);
var
  NewState: Boolean;
begin
  NewState := PtInRect(Rect(ClientWidth - Button.GetWidth, 0,
    ClientWidth, ClientHeight), Point(X, Y));
    
  if FPressed <> NewState then
  begin
    FPressed := NewState;
    Repaint;
  end;
end;

function TSCCustomDBLookupComboBox.UpdateAction(
  Action: TBasicAction): Boolean;
begin
  Result := False;
  if FLookupProps <> nil then
    Result := inherited UpdateAction(Action) or (FLookupProps.DataLink <> nil) and
      FLookupProps.DataLink.UpdateAction(Action);
end;

procedure TSCCustomDBLookupComboBox.UpdateListFields(Sender: TObject);
begin
  KeyValueChanged(Sender);
end;

function TSCCustomDBLookupComboBox.UseRightToLeftAlignment: Boolean;
begin
  Result := (FLookupProps <> nil) and
    DBUseRightToLeftAlignment(Self, FLookupProps.Field);
end;

procedure TSCCustomDBLookupComboBox.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  CloseUp(False);
end;

procedure TSCCustomDBLookupComboBox.WndProc(var Message: TMessage);
var
  Shift: TShiftState;
begin
  case Message.Msg of
    WM_KEYDOWN, WM_SYSKEYDOWN, WM_CHAR:
    begin
      with TWMKey(Message) do
      begin
        Shift := KeyDataToShiftState(KeyData);
        if (Message.Msg <> WM_CHAR) and DoDropDownKeys(CharCode, Shift) then
          Exit;
      end;
    end;
  end;

  inherited;
end;

procedure TSCCustomDBLookupComboBox.WMMouseWheel(var Message: TWMMouseWheel);
var
  Delta: Integer;
  DropHandle: HWND;
begin
  if GetDroppedDown then
  begin
    DropHandle := GetDropDownHandle;
    
    if DropHandle <> 0 then
    begin
      if SmallInt(HiWord(Message.Keys)) > 0 then
        SendMessage(DropHandle, WM_VSCROLL, SB_LINEUP, 0)
      else
        SendMessage(DropHandle, WM_VSCROLL, SB_LINEDOWN, 0);

      Exit;
    end;
  end else
  if FLookupProps <> nil then
    with FLookupProps do
    begin
      if not LocateKey then
        ListLink.DataSet.First
      else begin
        Delta := 1;
        if Message.WheelDelta > 0 then
          Delta := -1;

        ListLink.DataSet.MoveBy(Delta);
      end;

      SelectKeyValue(KeyFieldObj.Value);
    end;

  inherited;
end;

function TSCCustomDBLookupComboBox.GetPopupStyle: TSCEditStyle;
begin
  Result := FPopupProps.BorderStyle;
end;

function TSCCustomDBLookupComboBox.GetLineText(Index: Integer): String;
begin
  Result := inherited GetLineText(Index);
  if not IsDesigning and (csPaintCopy in ControlState) and
    (FLookupProps <> nil) and (FLookupProps.Field <> nil) then
  begin
    Result := ArrangeText(FLookupProps.Field.Text);

    if MaxLength > 0 then
      Result := Copy(Result, 1, MaxLength);

    {$IFDEF SC_DELPHI2009_EARLY}
    if OEMConvert then
      Result := OEMConvertText(Result);
    {$ENDIF}
  end;
end;

{ TSCLookupPopupProps }

procedure TSCLookupPopupProps.Assign(Source: TPersistent);
begin
  if Source is TSCLookupPopupProps then
  begin
    with TSCLookupPopupProps(Source) do
    begin
      Self.FBorderStyle := BorderStyle;
      Self.FColor := Color;
      Self.FEndEllipsis := EndEllipsis;
      Self.FHighlightColor := HighlightColor;
      Self.FHighlightTextColor := HighlightTextColor;
      Self.FItemHeight := FItemHeight;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCLookupPopupProps.Create(AOwner: TSCCustomDBLookupComboBox);
begin
  inherited Create;
  FOwner := AOwner;

  FBorderStyle := scesDefault;
  FColor := clWindow;
  FEndEllipsis := False;
  FHighlightColor := clHighlight;
  FHighlightTextColor := clHighlightText;
  FItemHeight := 0;
end;

function TSCLookupPopupProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCLookupPopupProps.GetScrollbars: TSCLookupListScrollbar;
begin
  Result := nil;
  if (FOwner <> nil) and (FOwner.FDataList <> nil) then
    Result := TSCLookupListScrollbar(FOwner.FDataList.Scrollbars);
end;

procedure TSCLookupPopupProps.SetBorderStyle(Value: TSCEditStyle);
begin
  FBorderStyle := Value;
end;

procedure TSCLookupPopupProps.SetColor(Value: TColor);
begin
  FColor := Value;
end;

procedure TSCLookupPopupProps.SetEndEllipsis(Value: Boolean);
begin
  FEndEllipsis := Value;
end;

procedure TSCLookupPopupProps.SetHighlightColor(Value: TColor);
begin
  FHighlightColor := Value;
end;

procedure TSCLookupPopupProps.SetHighlightTextColor(Value: TColor);
begin
  FHighlightTextColor := Value;
end;

procedure TSCLookupPopupProps.SetItemHeight(Value: Integer);
begin
  FItemHeight := Value;
end;

procedure TSCLookupPopupProps.SetScrollbars(Value: TSCLookupListScrollbar);
begin
  if (FOwner <> nil) and (FOwner.FDataList <> nil) then
    FOwner.FDataList.Scrollbars := Value;
end;

{$I SCVerRec.inc}

end.
