{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCVirtualListBox;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Clipbrd, SCConsts, SCCommon, SCControl;

type
  TSCCustomVirtualListbox = class;

  TSCGetListItemEvent = function(Sender: TObject; Index: Integer; var S: String;
    var ImageIndex: Integer): Boolean of object;

  TSCGetListItemIndexEvent = function(Sender: TObject; S: String): Integer of object;

  TSCVirtualListState = set of (scvsFocused, scvsHottrack, scvsDisabled);

  TSCDrawVirtualListItemEvent = procedure(Sender: TObject; Index: Integer;
    Rect: TRect; State: TSCVirtualListState; var Done: Boolean) of object;

  TSCVirtualListBorderProps = class(TSCControlBorderProps)
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

  TSCVListPictureProps = class(TSCPictureProps);

  TSCVirtualListboxScrollbar = class(TSCControlScrollbar)
  published
    property Background;
    property ButtonColors;
    property Icons;
    property SlideLine;
    property Thumb;
  end;

  TSCVirtualListScrollbar = class(TSCControlCustomScrollbars)
  private
    function  GetExtraProps: TSCCustomControlScrollbar;
    procedure SetExtraProps(Value: TSCCustomControlScrollbar);
    function  GetWidth: Integer;
    procedure SetWidth(Value: Integer);
  published
    property ExtraButton;
    property ExtraProps: TSCCustomControlScrollbar read GetExtraProps write SetExtraProps;
    property Layout;
    property Style;
    property ThumbLines;
    property Width: Integer read GetWidth write SetWidth default -1;
  end;

  TSCCustomVirtualListbox = class(TSCCustomScrollControl)
  private
    FAlignment: TLeftRight;
    FDisabledColor: TColor;
    FDisabledTextColor: TColor;
    FItemIndex: Integer;
    FItemCount: Integer;
    FItemHeight: Integer;
    FRowHeight: Integer;
    FRowCount: Integer;
    FPopup: Boolean;
    FTopIndex: Integer;
    FSelectedItem: string;
    FItems: TSCStringList;
    FEndEllipsis: Boolean;
    FHideFocusRect: Boolean;
    FHideSelection: Boolean;
    FHideSelectionColor: TColor;
    FHideSelectionTextColor: TColor;
    FHighlightColor: TColor;
    FHighlightTextColor: TColor;
    FHottrack: Boolean;
    FHotIndex: Integer;
    FHottrackColor: TColor;
    FHottrackUnderline: Boolean;
    FMouseDownIndex: Integer;
    FRevertable: Boolean;
    FShowItemImages: Boolean;
    FShowScrollbar: Boolean;
    FScrolling: Boolean;
    FScrollTimer: Integer;
    FScrollPosChanging: Integer;
    FScrollbarChanging: Integer;
    FCreatingWnd: Integer;
    FDropping: Boolean;
    FForceDropdownClick: Boolean;
    FOnDrawItem: TSCDrawVirtualListItemEvent;
    FOnGetItem: TSCGetListItemEvent;
    FOnGetItemIndex: TSCGetListItemIndexEvent;
    procedure SetAlignment(Value: TLeftRight);
    procedure SetDisabledColor(Value: TColor);
    procedure SetDisabledTextColor(Value: TColor);
    procedure SetEndEllipsis(Value: Boolean);
    procedure SetHideFocusRect(Value: Boolean);
    procedure SetHideSelection(Value: Boolean);
    procedure SetHideSelectionColor(Value: TColor);
    procedure SetHideSelectionTextColor(Value: TColor);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHighlightTextColor(Value: TColor);
    procedure SetHottrack(Value: Boolean);
    procedure SetHottrackColor(Value: TColor);
    procedure SetHottrackUnderline(Value: Boolean);
    procedure SetItemHeight(Value: Integer);
    procedure SetItemCount(Value: Integer);
    procedure SetItemIndex(Value: Integer);
    procedure SetShowItemImages(Value: Boolean);
    procedure SetShowScrollbar(Value: Boolean);
    procedure SetTopIndex(Value: Integer);

    function  GetItem(Index: Integer; var S: String; var ImageIndex: Integer): Boolean;

    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure CreateWnd; override;
    procedure Paint; override;
    procedure Loaded; override;

    procedure StopTracking; override;
    procedure MouseInControlChanged; override;

    procedure BeforePaintItem(C: TCanvas; Index: Integer; ClientR, R: TRect;
      State: TSCVirtualListState); virtual;
    procedure AfterPaintItem(C: TCanvas; Index: Integer; ClientR, R: TRect;
      State: TSCVirtualListState); virtual;

    procedure DoPaintItem(C: TCanvas; Index: Integer; Text: String;
      ClientR, R: TRect; Alignment: TLeftRight);
    procedure DoDrawItem(C: TCanvas; Index: Integer; Text: String;
      CR, R: TRect; State: TSCVirtualListState; Alignment: TLeftRight); virtual;

    procedure DoPaintBack(C: TCanvas); virtual;

    procedure DoAlignmentChanged; dynamic;
    function  GetItemImage(Index: Integer): Integer; virtual;
    procedure GetItemState(Index: Integer; var State: TSCVirtualListState); virtual;
    function  IsSelected(Index: Integer): Boolean; virtual;
    procedure SelectItemAt(X, Y: Integer);
    procedure DoItemClick(Index: Integer); dynamic;

    function  GetPageDownIndex(Index: Integer): Integer; dynamic;
    function  GetPageUpIndex(Index: Integer): Integer; dynamic;

    function  CanScrollToPos(Kind: TSCScrollbarKind; var NewValue: Integer): Boolean; override;
    procedure DoScrollerPositionChanged(Kind: TSCScrollbarKind); override;

    procedure StartScrolling(TimerTrigger: Boolean = False);
    procedure StopScrolling;
    function  Scrolling: Boolean;
    function  ScrollPaused: Boolean;
    procedure PauseScrolling;
    procedure ResumeScrolling;

    procedure First; dynamic;
    procedure Last; dynamic;
    function  MoveBy(Delta: Integer): Integer; dynamic;
    procedure MakeVisible(Index: Integer); dynamic;
    procedure CheckTopIndex(OldIndex, NewIndex: Integer); dynamic;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    function  CanModify: Boolean; dynamic;
    function  CanChangeItemIndex(Index: Integer): Integer; dynamic;
    function  DoGetItem(Index: Integer; var S: String; var ImageIndex: Integer): Boolean; dynamic;

    procedure UpdateBufferList;
    function  GetTextHeight: Integer; override;
    procedure CalculateRowCount;

    procedure DoUpdateBufferList; dynamic;
    procedure DoCalculateRowCount; dynamic;

    function  IsVertScrollBarVisible: Boolean; override;
    function  IsHorzScrollBarVisible: Boolean; override;
    function  CanShowScrollbar: Boolean; dynamic;
    function  UpdateScrollbar: Boolean;

    procedure DoHotChange; dynamic;
    procedure SetHotIndex(Value: Integer; DoUpdate: Boolean = True);
    procedure UpdateHotTrack(Draw: Boolean = True);

    function  GetRowHeight: Integer;
    procedure VerifyIndex(var Index: Integer); dynamic;
    procedure VerifyTopIndex(var Index: Integer); dynamic;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetPicturePropsClass: TSCCustomPicturePropsClass; override;
    function  GetControlScrollbarsClass: TSCControlCustomScrollbarsClass; override;
    function  GetScrollbarClass: TSCCustomControlScrollbarClass; override;

    procedure ColorsChanged; dynamic;

    property Dropping: Boolean read FDropping write FDropping;
    property ForceDropdownClick: Boolean read FForceDropdownClick write FForceDropdownClick default False;
    property Alignment: TLeftRight read FAlignment write SetAlignment default taLeftJustify;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clBtnFace;
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default False;
    property HideFocusRect: Boolean read FHideFocusRect write SetHideFocusRect default False;
    property HideSelection: Boolean read FHideSelection write SetHideSelection default False;
    property HideSelectionColor: TColor read FHideSelectionColor write SetHideSelectionColor default clBtnFace;
    property HideSelectionTextColor: TColor read FHideSelectionTextColor write SetHideSelectionTextColor default clBtnText;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default clHighlight;
    property HighlightTextColor: TColor read FHighlightTextColor write SetHighlightTextColor default clHighlightText;
    property HotIndex: Integer read FHotIndex;
    property Hottrack: Boolean read FHottrack write SetHottrack default True;
    property HottrackColor: TColor read FHottrackColor write SetHottrackColor default clHighlight;
    property HottrackUnderline: Boolean read FHottrackUnderline write SetHottrackUnderline default False;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 0;
    property ItemCount: Integer read FItemCount write SetItemCount default 0;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Popup: Boolean read FPopup write FPopup default False;
    property Revertable: Boolean read FRevertable write FRevertable default False;
    property RowCount: Integer read FRowCount;
    property SelectedItem: string read FSelectedItem;
    property ShowItemImages: Boolean read FShowItemImages write SetShowItemImages default False;
    property ShowScrollbar: Boolean read FShowScrollbar write SetShowScrollbar default True;
    property TopIndex: Integer read FTopIndex write SetTopIndex;
    property OnDrawItem: TSCDrawVirtualListItemEvent read FOnDrawItem write FOnDrawItem;
    property OnGetItem: TSCGetListItemEvent read FOnGetItem write FOnGetItem;
    property OnGetItemIndex: TSCGetListItemIndexEvent read FOnGetItemIndex write FOnGetItemIndex;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    function  ItemRect(Index: Integer; InView: Boolean = True): TRect;
    function  ItemAtPos(X, Y: Integer; InView: Boolean = False): Integer;
    function  ItemInView(Index: Integer; PartitialAllowed: Boolean = True): Boolean;
    function  LastVisibleItem(PartitialAllowed: Boolean = True): Integer;
    function  IndexOfItem(Str: String): Integer; virtual;
    function  ItemText(Index: Integer): String; virtual;
    function  GetListItemIndex(Str: String): Integer;

    property Color default clWindow;
    property ParentColor default False;
    property TabStop default True;
  end;

  TSCCustomVirtualListboxClass = class of TSCCustomVirtualListbox;

  TSCVirtualListBox = class(TSCCustomVirtualListbox)
  public
    property RowCount;
    property SelectedItem;
  published
    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property BorderProps;
    property Color;
    property Constraints;
    property Ctl3D;
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
    property Hottrack;
    property HottrackColor;
    property HottrackUnderline;
    property ImeMode;
    property ImeName;
    property ItemCount;
    property ItemHeight;
    property ItemIndex;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Revertable;
    property Scrollbars;
    property ShowHint;
    property ShowItemImages;
    property ShowScrollbar;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
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
    property OnGetItem;
    property OnGetItemIndex;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPictureChange;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCVirtualListboxClass = class of TSCVirtualListbox;

implementation

const
  SC_VLISTSCROLL_TIMERID = 4345;

type
  TSCVListStrings = class(TSCStringList);

{ TSCVirtualListBorderProps }

constructor TSCVirtualListBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccb3DLowered;
end;

{ TSCVirtualListScrollbar }

function TSCVirtualListScrollbar.GetExtraProps: TSCCustomControlScrollbar;
begin
  Result := Self.Vertical;
end;

function TSCVirtualListScrollbar.GetWidth: Integer;
begin
  Result := Self.Height;
end;

procedure TSCVirtualListScrollbar.SetExtraProps(
  Value: TSCCustomControlScrollbar);
begin
  Self.Vertical.Assign(Value);
end;

procedure TSCVirtualListScrollbar.SetWidth(Value: Integer);
begin
  Self.Height := Value;
end;

{ TSCCustomVirtualListbox }

constructor TSCCustomVirtualListbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csDoubleClicks];
  SetBounds(Left, Top, 121, 97);
  DoubleBuffered := True;
  ParentColor := False;
  Color := clWindow;
  TabStop := True;
  Border := sccb3DLowered;

  FItems := TSCStringList.Create;
  FAlignment := taLeftJustify;

  FHotIndex := -1;
  FItemCount := 0;
  FItemIndex := -1;
  FItemHeight := 0;
  FRowCount := 0;
  FRowHeight := -1;
  FMouseDownIndex := -1;

  FScrolling := False;
  FScrollTimer := -1;

  FDisabledColor := clBtnFace;
  FDisabledTextColor := clGrayText;
  FHideFocusRect := False;
  FHideSelection := False;
  FHideSelectionColor := clBtnFace;
  FHideSelectionTextColor := clBtnText;
  FHighlightColor := clHighlight;
  FHighlightTextColor := clHighlightText;
  FHottrack := True;
  FHottrackColor := clHighlight;
  FHottrackUnderline := False;

  FShowItemImages := False;
  FShowScrollbar := True;
end;

procedure TSCCustomVirtualListbox.CreateWnd;
begin
  Inc(FCreatingWnd);
  try
    inherited CreateWnd;
  finally
    Dec(FCreatingWnd);
  end;

  CalculateRowCount;
  UpdateScrollBar;
end;

procedure TSCCustomVirtualListbox.KeyDown(var Key: Word; Shift: TShiftState);
var
  Delta: Integer;
begin
  inherited KeyDown(Key, Shift);
  
  if CanModify and (Key in SCArrowKeys) and (FItemCount > 0) then
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
      if Delta = -Maxint then
        First
      else if Delta = Maxint then
        Last
      else
        MoveBy(Delta);
    end;
  end;
end;

procedure TSCCustomVirtualListbox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Indx, OldHot, OldIndex: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);

  FMouseDownIndex := -1;
  if CanFocus then
    SetFocus;

  if not Focused then
  begin
    if FForceDropdownClick and (Button = mbLeft) then
    begin
      Indx := ItemAtPos(X, Y);
      VerifyIndex(Indx);

      FMouseDownIndex := Indx;
    end;

    Exit;
  end;

  OldHot := FHotIndex;

  FHotIndex := ItemAtPos(X, Y);
  VerifyIndex(FHotIndex);

  OldIndex  := FItemIndex;

  if Button <> mbLeft then
  begin
    Indx := FHotIndex;
    FHotIndex := OldHot;

    SetHotIndex(Indx, True);
  end else
  begin
    FMouseDownIndex := FHotIndex;

    VerifyIndex(FMouseDownIndex);
    VerifyIndex(FItemIndex);

    if FHotIndex > -1 then
    begin
      SetItemIndex(FHotIndex);
      CheckTopIndex(OldIndex, FItemIndex);

      if OldIndex <> FItemIndex then
        DoItemClick(FItemIndex);
    end else
    begin
      Indx := FHotIndex;
      FHotIndex := OldHot;

      SetHotIndex(Indx, True);
    end;
  end;
end;

procedure TSCCustomVirtualListbox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  OldHot, Indx, OldIndex: Integer;
begin
  VerifyIndex(FMouseDownIndex);

  OldHot := FHotIndex;

  FHotIndex := ItemAtPos(X, Y);
  VerifyIndex(FHotIndex);

  OldIndex := FItemIndex;

  if FMouseDownIndex < 0 then
  begin
    Indx := FHotIndex;
    FHotIndex := OldHot;

    SetHotIndex(Indx, True);
  end else
  if FItemCount > 0 then
  begin
    Indx := FHotIndex;
    VerifyIndex(Indx);

    if Indx > -1 then
    begin
      SetItemIndex(Indx);
      CheckTopIndex(OldIndex, FItemIndex);
    end;

    Indx := FHotIndex;
    FHotIndex := OldHot;

    SetHotIndex(Indx, True);

    R := GetClientRect;
    if not (IsRectEmpty(R) or PtInRect(R, Point(X, Y))) then
      StartScrolling
    else
    if Scrolling then
      PauseScrolling;
  end;

  if OldIndex <> FItemIndex then
    DoItemClick(FItemIndex);

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomVirtualListbox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  OldIndex: Integer;
begin
  StopScrolling;

  OldIndex := FItemIndex;
  FMouseDownIndex  := -1;

  SetHotIndex(ItemAtPos(X, Y), True);

  if OldIndex <> FItemIndex then
    DoItemClick(FItemIndex);

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomVirtualListbox.Paint;
var
  S: String;
  CR, R: TRect;
  TopIndx, Indx, 
  H, W, I, Max: Integer;
  AAlignment: TLeftRight;
begin
  DoPaintBack(Canvas);
  DrawPicture(Canvas);

  H := GetRowHeight;
  if (FItemCount = 0) or (H < 1) then
    Exit;

  CR := GetClientRect;
  if IsRectEmpty(CR) then
    Exit;

  TopIndx := FTopIndex;
  VerifyTopIndex(TopIndx);

  Max := TopIndx + FRowCount;
  VerifyIndex(Max);

  W := CR.Right - CR.Left;

  R := CR;
  R.Bottom := R.Top;

  AAlignment := FAlignment;
  if UseRightToLeftAlignment then
    case Alignment of
      taLeftJustify:
        AAlignment := taRightJustify;
      taRightJustify:
        AAlignment := taLeftJustify;
    end;

  for I := TopIndx to Max do
  begin
    S := '';
    
    Indx := I - TopIndx;
    if Indx < FItems.Count then
      S := FItems[Indx];

    R.Bottom := R.Top  + H;
    R.Right  := R.Left + W;

    DoPaintItem(Canvas, I, S, CR, R, AAlignment);

    R.Top := R.Bottom;
  end;
end;

procedure TSCCustomVirtualListbox.SelectItemAt(X, Y: Integer);
var
  RH, Current, Delta, TopIndx: Integer;
begin
  RH := GetRowHeight;

  if (RH > 0) then
  begin
    if Y < 0 then Y := 0;
    if Y >= ClientHeight then Y := ClientHeight - 1;

    Current := FItemIndex;
    if Current < 0 then Current := 0;
    if Current > FItemCount then Current := FItemCount;

    TopIndx := FTopIndex;
    VerifyTopIndex(TopIndx);

    Delta := (Y div RH) - Current + TopIndx;
    MoveBy(Delta);
  end;
end;

procedure TSCCustomVirtualListbox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  CalculateRowCount;
end;

procedure TSCCustomVirtualListbox.StopTracking;
begin
  FMouseDownIndex  := -1;

  StopScrolling;
  inherited StopTracking;
end;

function TSCCustomVirtualListbox.UpdateScrollbar: Boolean;
var
  Dist, H: Integer;
  ScrlVisible: Boolean;
  SiOld, SiNew: TSCScrollInfo;
begin
  Result := False;
  if HandleAllocated and (FCreatingWnd = 0) and not IsLoading then
  begin
    SiOld := Self.GetScrollbarInfo(scskVertical);
    ScrlVisible := SiOld.Visible and (SiOld.Page <= SiOld.Max);

    SiNew := SiOld;
    SiNew.Min := 0;

    H := GetRowHeight;
    if FShowScrollbar and CanShowScrollbar and (FItemCount > 1) and (H > 0) then
    begin
      SiNew.Page := (Self.ClientHeight div H) - 1;

      SiNew.Min  := 0;
      SiNew.Max  := FItemCount - 1;
      SiNew.Pos  := FTopIndex;
    end else
    begin
      SiNew.Page := 1;
      SiNew.Min  := 0;
      SiNew.Max  := 0;
      SiNew.Pos  := 0;
    end;

    SiNew.TrimPageSize := True;
    SiNew.LargeChange  := SiNew.Page;

    Dist := SiNew.Max - SiNew.Min;
    SiNew.Visible := (SiNew.Page > -1) and (SiNew.Max > 0) and
      (Dist > 0) and (SiNew.Page < Dist);

    if (SiNew.Min <> SiOld.Min) or (SiNew.Max <> SiOld.Max) or
      (SiNew.Page <> SiOld.Page) or (SiNew.Pos <> SiOld.Pos) or
      (SiNew.Visible <> SiOld.Visible) then
    begin
      Self.SetScrollbarInfo(scskVertical, SiNew);
      if Integer(SiNew.Page) > SiNew.Max then
        SetTopIndex(SiNew.Min);
    end;

    Result := ScrlVisible <> (Integer(SiNew.Page) <= SiNew.Max);
  end;
end;

procedure TSCCustomVirtualListbox.CMFontChanged(var Message: TMessage);
begin
  inherited;

  CalculateRowCount;
  UpdateHotTrack(False);
end;

procedure TSCCustomVirtualListbox.WMCancelMode(var Message: TMessage);
begin
  StopTracking;
  inherited;
end;

procedure TSCCustomVirtualListbox.WMTimer(var Message: TWMTimer);
begin
  inherited;
  if Scrolling and (Message.TimerID = SC_VLISTSCROLL_TIMERID) then
    StartScrolling(True);
end;

procedure TSCCustomVirtualListbox.WMVScroll(var Message: TWMVScroll);
var
  I: Integer;
  SI: TScrollInfo;
begin
  if IsDesigning then
  begin
    inherited;
    Exit;
  end;

  SI.cbSize := SizeOf(SI);
  SI.fMask := SIF_ALL;

  GetScrollInfo(Self.Handle, SB_VERT, SI);

  case Message.ScrollCode of
    SB_LINEUP:
      SetTopIndex(FTopIndex - 1);
    SB_LINEDOWN:
      SetTopIndex(FTopIndex + 1);
    SB_PAGEUP:
    begin
      I := GetPageUpIndex(FTopIndex);
      SetTopIndex(I);
    end;
    SB_PAGEDOWN:
    begin
      I := GetPageDownIndex(FTopIndex);
      SetTopIndex(I);
    end;
    SB_THUMBPOSITION, SB_THUMBTRACK:
    begin
      if SI.nTrackPos <= SI.nMin then
        SetTopIndex(SI.nMin)
      else
      if SI.nTrackPos >= SI.nMax then
        SetTopIndex(SI.nMax)
      else
        SetTopIndex(SI.nTrackPos);
    end;
    SB_TOP:
      SetTopIndex(SI.nMin);
    SB_BOTTOM:
      SetTopIndex(SI.nMax);
  end;
end;

procedure TSCCustomVirtualListbox.CalculateRowCount;
var
  OldTop, CH,
  RH, H, Rows: Integer;
begin
  if not IsLoading and HandleAllocated then
  begin
    Rows := FRowCount;
    RH := GetRowHeight;

    FRowHeight := GetTextHeight;
    H := GetRowHeight;

    if H < 1 then
      FRowCount := 0
    else begin
      CH := ClientHeight;
      FRowCount := CH div H;

      if CH mod H > 0 then
        Inc(FRowCount);
    end;

    if FRowCount < 1 then
      FRowCount := 1;

    OldTop := FTopIndex;
    VerifyTopIndex(OldTop);

    if OldTop <> FTopIndex then
      SetTopIndex(OldTop);

    if (Rows <> FRowCount) or (RH <> GetRowHeight) then
    begin
      UpdateBufferList;
      UpdateScrollBar;
    end;

    DoCalculateRowCount;
  end;
end;

destructor TSCCustomVirtualListbox.Destroy;
begin
  Destroying;

  StopScrolling;
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TSCCustomVirtualListbox.UpdateBufferList;
var
  S: String;
  Item: PSCStringItem;
  Index, I, TopIndx, Max, Image: Integer;
begin
  FItems.BeginUpdate;
  try
    FItems.Clear;

    TopIndx := FTopIndex;
    VerifyTopIndex(TopIndx);

    Max := TopIndx + FRowCount;
    VerifyIndex(Max);

    for I := TopIndx to Max do
    begin
      S := '';
      Image := -1;

      if not GetItem(I, S, Image) then
      begin
        S := '';
        Image := -1;
      end;

      if Image < -1 then Image := -1;
      Index := FItems.Add(S);
      
      Item := TSCVListStrings(FItems).List[Index];
      Item^.FData[0] := Image;
    end;
  finally
    FItems.EndUpdate;
    Invalidate;
  end;

  DoUpdateBufferList;
end;

function TSCCustomVirtualListbox.GetItem(Index: Integer; var S: String;
  var ImageIndex: Integer): Boolean;
begin
  S := '';
  Result := False;
  if Index > -1 then
  begin
    Result := DoGetItem(Index, S, ImageIndex);
    if Assigned(FOnGetItem) then
      Result := FOnGetItem(Self, Index, S, ImageIndex);
  end;
end;

function TSCCustomVirtualListbox.DoGetItem(Index: Integer;
  var S: String; var ImageIndex: Integer): Boolean;
begin
  Result := False;
  if (Index > -1) and (Index < FItemCount) then
  begin
    Result := True;

    S := '';
    ImageIndex := -1;
  end;
end;

procedure TSCCustomVirtualListbox.Loaded;
begin
  inherited Loaded;
  CalculateRowCount;
end;

procedure TSCCustomVirtualListbox.First;
var
  OldIndex, NewIndex: Integer;
begin
  NewIndex := 0;
  OldIndex := FItemIndex;

  VerifyIndex(NewIndex);
  if (NewIndex < 0) and (FItemCount > 0) then
    NewIndex := 0;

  SetItemIndex(NewIndex);
  CheckTopIndex(OldIndex, FItemIndex);
end;

procedure TSCCustomVirtualListbox.Last;
var
  OldIndex, NewIndex: Integer;
begin
  OldIndex := FItemIndex;

  NewIndex := FItemCount-1;
  if (NewIndex < 0) and (FItemCount > 0) then
    NewIndex := 0;

  VerifyIndex(NewIndex);
  if (NewIndex < 0) and (FItemCount > 0) then
    NewIndex := 0;

  SetItemIndex(NewIndex);
  CheckTopIndex(OldIndex, FItemIndex);
end;

function TSCCustomVirtualListbox.MoveBy(Delta: Integer): Integer;
var
  OldIndex, NewIndex: Integer;
begin
  Result := 0;

  NewIndex := FItemIndex;
  OldIndex := FItemIndex;

  if NewIndex = -1 then NewIndex := 0;

  Inc(NewIndex, Delta);
  VerifyIndex(NewIndex);
  if NewIndex = -1 then NewIndex := 0;

  SetItemIndex(NewIndex);
  CheckTopIndex(OldIndex, FItemIndex);
end;

function TSCCustomVirtualListbox.CanModify: Boolean;
begin
  Result := True;
end;

procedure TSCCustomVirtualListbox.DoCalculateRowCount;
begin
  //
end;

procedure TSCCustomVirtualListbox.DoUpdateBufferList;
begin
  //
end;

procedure TSCCustomVirtualListbox.DoAlignmentChanged;
begin
  //
end;

procedure TSCCustomVirtualListbox.SetAlignment(Value: TLeftRight);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;

    DoAlignmentChanged;
  end;
end;

function TSCCustomVirtualListbox.IsSelected(Index: Integer): Boolean;
begin
  Result := (Index > -1) and (Index < FItemCount) and (Index = FItemIndex);
end;

procedure TSCCustomVirtualListbox.DoPaintBack(C: TCanvas);
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

function TSCCustomVirtualListbox.GetPicturePropsClass: TSCCustomPicturePropsClass;
begin
  Result := TSCVListPictureProps;
end;

procedure TSCCustomVirtualListbox.SetHideFocusRect(Value: Boolean);
begin
  if FHideFocusRect <> Value then
  begin
    FHideFocusRect := Value;
    if (FItemCount > 0) and HasFocus and
      ItemInView(FItemIndex, True) then
      Invalidate;
  end;
end;

procedure TSCCustomVirtualListbox.SetHideSelection(Value: Boolean);
begin
  if FHideSelection <> Value then
  begin
    FHideSelection := Value;

    if (FItemCount > 0) and not HasFocus and
      ItemInView(FItemIndex) then
      Invalidate;
  end;
end;

procedure TSCCustomVirtualListbox.SetHideSelectionColor(Value: TColor);
begin
  if FHideSelectionColor <> Value then
  begin
    FHideSelectionColor := Value;

    if not FHideSelection and (FItemCount > 0) and
      not HasFocus and ItemInView(FItemIndex) then
      Invalidate;

    ColorsChanged;
  end;
end;

procedure TSCCustomVirtualListbox.SetHideSelectionTextColor(Value: TColor);
begin
  if FHideSelectionTextColor <> Value then
  begin
    FHideSelectionTextColor := Value;

    if not FHideSelection and (FItemCount > 0) and
      not HasFocus and ItemInView(FItemIndex) then
      Invalidate;

    ColorsChanged;
  end;
end;

procedure TSCCustomVirtualListbox.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;

    if (FItemCount > 0) and HasFocus and
      ItemInView(FItemIndex) then
      Invalidate;

    ColorsChanged;
  end;
end;

procedure TSCCustomVirtualListbox.SetHighlightTextColor(Value: TColor);
begin
  if FHighlightTextColor <> Value then
  begin
    FHighlightTextColor := Value;
    
    if (FItemCount > 0) and HasFocus and
      ItemInView(FItemIndex) then
      Invalidate;

    ColorsChanged;
  end;
end;

procedure TSCCustomVirtualListbox.SetHottrack(Value: Boolean);
begin
  if FHottrack <> Value then
  begin
    FHottrack := Value;
    if (FHotIndex > -1) and (FItemCount > 0) then
      UpdateHotTrack(True);

    Invalidate;
  end;
end;

procedure TSCCustomVirtualListbox.SetHottrackColor(Value: TColor);
begin
  if FHottrackColor <> Value then
  begin
    FHottrackColor := Value;

    if FHottrack and (FHotIndex > -1) and (FItemCount > 0) then
      UpdateHotTrack(True);

    ColorsChanged;
  end;
end;

procedure TSCCustomVirtualListbox.SetHottrackUnderline(Value: Boolean);
begin
  if FHottrackUnderline <> Value then
  begin
    FHottrackUnderline := Value;
    if FHottrack and (FHotIndex > -1) and (FItemCount > 0) then
      UpdateHotTrack(True);
  end;
end;

function TSCCustomVirtualListbox.ItemAtPos(X, Y: Integer;
  InView: Boolean): Integer;
var
  CR: TRect;
  H, Max, TopIndx: Integer;
begin
  Result := -1;

  H := GetRowHeight;
  if (FItemCount = 0) or (H < 1) then
    Exit;

  if not InView and (FItemCount = 1) then
  begin
    Result := 0;
    Exit;
  end;

  CR := GetClientRect;

  if not InView then
  begin
    if Y < CR.Top then
    begin
      Result := -Maxint;
      Exit;
    end;

    if Y >= CR.Bottom then
    begin
      Result := Maxint;
      Exit;
    end;
  end;

  if InView and ((X < CR.Left) or (X >= CR.Right)) then
  begin
    Result := -1;
    Exit;
  end;

  TopIndx := FTopIndex;
  VerifyTopIndex(TopIndx);

  if TopIndx < 0 then
    TopIndx := 0;

  Max := TopIndx + FRowCount;
  VerifyIndex(Max);

  Result := Y div H;

  Inc(Result, TopIndx);

  if InView then
  begin
    if Result < 0 then
    begin
      Result := -Maxint;
      Exit;
    end;

    if Result > FItemIndex then
    begin
      Result := Maxint;
      Exit;
    end;
  end;

  if (Result <> -Maxint) and (Result <> Maxint) then
    VerifyIndex(Result);
end;

function TSCCustomVirtualListbox.ItemInView(Index: Integer;
  PartitialAllowed: Boolean): Boolean;
var
  H, Rows, Max, TopIndx: Integer;
begin
  Result := False;

  if FItemCount < 2 then
  begin
    Result := True;
    Exit;
  end;

  H := GetRowHeight;
  if (FItemCount = 0) or (H < 1) or
    (Index < 0) or (Index > FItemCount - 1) then
    Exit;

  TopIndx := FTopIndex;
  VerifyTopIndex(TopIndx);

  if TopIndx < 0 then
    TopIndx := 0;

  Rows := FRowCount;
  if not PartitialAllowed then
    Rows := ClientHeight div H;

  Max := TopIndx + Rows - 1;
  VerifyIndex(Max);

  Result := (Index >= TopIndx) and (Index <= Max);
end;

function TSCCustomVirtualListbox.ItemRect(Index: Integer; InView: Boolean): TRect;
var
  CR, R: TRect;
  H, Max, TopIndx: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  H := GetRowHeight;
  if (FItemCount = 0) or (H < 1) or
    (Index < 0) or (Index > FItemCount - 1) then
    Exit;

  TopIndx := FTopIndex;
  VerifyTopIndex(TopIndx);

  if TopIndx < 0 then
    TopIndx := 0;

  Max := TopIndx + FRowCount;
  VerifyIndex(Max);

  if not InView and ((Index < TopIndx) or (Index > Max)) then
    Exit;

  CR := GetClientRect;
  if IsRectEmpty(CR) then
    Exit;

  Result := CR;
  Result.Bottom := Result.Top + H;

  OffsetRect(Result, 0, -(TopIndx * H));

  if not InView and (not IntersectRect(R, Result, CR) or
    not EqualRect(R, Result)) then
    Result := Rect(0, 0, 0, 0);
end;

function TSCCustomVirtualListbox.LastVisibleItem(
  PartitialAllowed: Boolean): Integer;
var
  H, Rows, TopIndx: Integer;
begin
  Result := -1;

  H := GetRowHeight;
  if (FItemCount = 0) or (H < 1) then
    Exit;

  TopIndx := FTopIndex;
  VerifyTopIndex(TopIndx);

  if TopIndx < 0 then
    TopIndx := 0;

  Rows := FRowCount;
  if not PartitialAllowed then
    Rows := ClientHeight div H;

  Result := TopIndx + Rows;
  VerifyIndex(Result);
end;

procedure TSCCustomVirtualListbox.UpdateHotTrack(Draw: Boolean);
var
  P: TPoint;
  Indx, OldHot: Integer;
begin
  OldHot := FHotIndex;

  if HandleAllocated then
  begin
    if not GetCursorPos(P) then
      FHotIndex := -1
    else begin
      P := Self.ScreenToClient(P);
      
      FHotIndex := ItemAtPos(P.x, P.y);
      VerifyIndex(FHotIndex);
    end;
  end;

  if Draw and FHotTrack and (OldHot <> FHotIndex) and
    (ItemInView(OldHot) or ItemInView(FHotIndex)) then
    Invalidate;

  Indx := FHotIndex;
  FHotIndex := OldHot;

  SetHotIndex(Indx, False);
end;

procedure TSCCustomVirtualListbox.VerifyIndex(var Index: Integer);
begin
  if Index < -1 then
    Index := -1;

  if not (IsLoading or IsReading) then
  begin
    if (Index < -1) or (Index = Maxint) then
      Index := -1
    else
    if Index > FItemCount - 1 then
      Index := FItemCount - 1;
  end;    
end;

procedure TSCCustomVirtualListbox.VerifyTopIndex(var Index: Integer);
var
  RH, MaxTop, Rows: Integer;
begin
  if Index <= 0 then
  begin
    Index := 0;
    Exit;
  end;

  if not (IsLoading or IsReading) then
  begin
    if Index > FItemCount - 1 then
      Index := FItemCount - 1;

    Rows := 1;
    RH := GetRowHeight;

    if (RH > 0) then
    begin
      Rows := ClientHeight div GetRowHeight;
      if Rows <= 0 then
        Rows := 1;
    end;

    MaxTop := FItemCount - Rows;
    if MaxTop < 0 then
      MaxTop := 0;

    if Index > MaxTop then
      Index := MaxTop;

    if Index < 0 then
      Index := 0;
  end;
end;

function TSCCustomVirtualListbox.GetRowHeight: Integer;
begin
  if FRowHeight <= 0 then FRowHeight := GetTextHeight;
  Result := FRowHeight;
end;

procedure TSCCustomVirtualListbox.DoDrawItem(C: TCanvas; Index: Integer;
  Text: String; CR, R: TRect; State: TSCVirtualListState;
  Alignment: TLeftRight);
var
  R2: TRect;
  Cl, Fcl: TColor;
  F: LongInt;
  Img, T: Integer;
begin
  if (C = nil) or IsRectEmpty(R) or IsRectEmpty(CR) or
    (Index < 0) or (Index > FItemCount-1) then
    Exit;

  if FShowItemImages and (Images <> nil) and (Images.Width > 0) then
  begin
    R2 := R;
    R2.Right := R2.Left + Images.Width + 2;

    R.Left := R2.Right;
    Img := GetItemImage(Index);

    if IsValidImage(Img) and not IsRectEmpty(R2) and
      (R2.Right > CR.Left) and (R2.Left < CR.Right) then
    begin
      T := R2.Top + ((R2.Bottom - R2.Top - Images.Height) div 2);

      Images.Draw(C, R2.Left + 1, T, Img, Enabled and not (scvsDisabled in State));
    end;
  end;

  with C do
  begin
    Brush.Style := bsClear;
    Font.Assign(Self.Font);

    Cl  := Self.Color;
    FCl := clNone;

    if scvsDisabled in State then
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
    if scvsFocused in State then
    begin
      Brush.Style := bsSolid;

      Cl  := FHighlightColor;
      Fcl := FHighlightTextColor;

      if not HasFocus then
      begin
        Cl := clNone;
        FCl := clNone;

        if not FHideSelection then
        begin
          Cl  := FHideSelectionColor;
          FCl := FHideSelectionTextColor;
        end else
        if FHottrack and (scvsHottrack in State) and not IsDesigning then
        begin
          FCl := FHottrackColor;
          if FHottrackUnderline then
            Font.Style := Font.Style + [fsUnderline];
        end;
      end;

      if Cl <> clNone then
      begin
        Brush.Color := Cl;
        FillRect(R);
      end;
    end else
    if (scvsHottrack in State) and not IsDesigning then
    begin
      FCl := FHottrackColor;
      if FHottrackUnderline then
        Font.Style := Font.Style + [fsUnderline];
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
      if Alignment = taRightJustify then
        F := F or DT_RIGHT;

      if FEndEllipsis then
        F := F or DT_END_ELLIPSIS;

      Brush.Style := bsClear;
      DrawText(C.Handle, PChar(Text), Length(Text), R2, F);
    end;

    if not IsDesigning and not FHideFocusRect and
      (scvsFocused in State) and HasFocus then
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      scDrawFocusRect(C, R, Cl);
    end;
  end;
end;

procedure TSCCustomVirtualListbox.DoPaintItem(C: TCanvas; Index: Integer;
  Text: String; ClientR, R: TRect; Alignment: TLeftRight);
var
  R2: TRect;
  W: Integer;
  Done: Boolean;
  St: TSCVirtualListState;
begin
  if (C = nil) or IsRectEmpty(ClientR) or IsRectEmpty(R) or
    (Index < 0) or (Index > FItemCount-1) then
    Exit;

  W := ClientR.Right - ClientR.Left;
  if W <= 0 then
    Exit;

  R.Left := ClientR.Left;
  R.Right := R.Left + W;

  IntersectRect(R2, R, ClientR);
  if IsRectEmpty(R2) then
    Exit;

  St := [];
  GetItemState(Index, St);

  if not FHottrack then
    St := St - [scvsHottrack];

  BeforePaintItem(C, Index, ClientR, R, St);

  try
    if IntersectClipRect(C.Handle, R2.Left,
      R2.Top, R2.Right, R2.Bottom) = NULLREGION then
      Exit;

    if Assigned(FOnDrawItem) then
    begin
      Done := False;
      FOnDrawItem(Self, Index, R, St, Done);

      if Done then
        Exit;
    end;

    if not IsRectEmpty(R) then
      DoDrawItem(C, Index, Text, ClientR, R, St, Alignment);
  finally
    SelectClipRgn(C.Handle, 0);
    AfterPaintItem(C, Index, ClientR, R, St);
  end;
end;

procedure TSCCustomVirtualListbox.SetShowItemImages(Value: Boolean);
begin
  if FShowItemImages <> Value then
  begin
    FShowItemImages := Value;
    if (Images <> nil) and (FItemCount > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomVirtualListbox.AfterPaintItem(C: TCanvas;
  Index: Integer; ClientR, R: TRect; State: TSCVirtualListState);
begin
  //
end;

procedure TSCCustomVirtualListbox.BeforePaintItem(C: TCanvas;
  Index: Integer; ClientR, R: TRect; State: TSCVirtualListState);
begin
  //
end;

procedure TSCCustomVirtualListbox.GetItemState(Index: Integer;
  var State: TSCVirtualListState);
begin
  State := [];
  if (Index > -1) and (Index < FItemCount) then
  begin
    State := State - [scvsFocused, scvsHottrack];

    if Index = FItemIndex then
      State := State + [scvsFocused];

    if FHottrack and (Index = FHotIndex) then
      State := State + [scvsHottrack];

    if not Enabled then
      State := State + [scvsDisabled];
  end;
end;

procedure TSCCustomVirtualListbox.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    if FItemCount > 0 then
      Invalidate;
  end;
end;

procedure TSCCustomVirtualListbox.SetDisabledTextColor(Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    if FItemCount > 0 then
      Invalidate;
  end;
end;

function TSCCustomVirtualListbox.GetItemImage(Index: Integer): Integer;
begin
  Result := -1;
end;

function TSCCustomVirtualListbox.GetScrollbarClass: TSCCustomControlScrollbarClass;
begin
  Result := TSCVirtualListboxScrollbar;
end;

procedure TSCCustomVirtualListbox.SetShowScrollbar(Value: Boolean);
begin
  if FShowScrollbar <> Value then
  begin
    FShowScrollbar := Value;

    if HandleAllocated and (FItemCount > 0) then
    begin
      UpdateScrollBar;
      if not IsDesigning then
        UpdateHotTrack(True);
    end;
  end;
end;

procedure TSCCustomVirtualListbox.SetHotIndex(Value: Integer;
  DoUpdate: Boolean);
begin
  VerifyIndex(Value);

  if FHotIndex <> Value then
  begin
    FHotIndex := Value;

    if FHotTrack and DoUpdate then
      Invalidate;

    DoHotChange;
  end;
end;

procedure TSCCustomVirtualListbox.DoHotChange;
begin
  //
end;

function TSCCustomVirtualListbox.CanScrollToPos(Kind: TSCScrollbarKind;
  var NewValue: Integer): Boolean;
begin
  Result := False;
  if Kind = scskHorizontal then
  begin
    NewValue := 0;
    Exit;
  end;

  Result := True;
  if NewValue < 0 then
    NewValue := 0;

  if NewValue > FItemCount then
    NewValue := FItemCount;
end;

procedure TSCCustomVirtualListbox.DoScrollerPositionChanged(
  Kind: TSCScrollbarKind);
var
  Sb: TSCVirtualListboxScrollbar;
begin
  if FScrollPosChanging  > 0 then
    Exit;

  Inc(FScrollbarChanging);
  try
    if Kind = scskVertical then
    begin
      Sb := TSCVirtualListboxScrollbar(ScrollbarVert);
      SetTopIndex(Sb.Position);
    end;
  finally
    Dec(FScrollbarChanging);
  end;
end;

procedure TSCCustomVirtualListbox.SetTopIndex(Value: Integer);
var
  P: TPoint;
  Indx, OldHot: Integer;
begin
  Inc(FScrollPosChanging);
  try
    if IsDesigning then
      Value := 0;

    VerifyTopIndex(Value);

    if FTopIndex <> Value then
    begin
      FTopIndex := Value;
      UpdateBufferList;

      OldHot := FHotIndex;
      if GetCursorPos(P) then
      begin
        P := Self.ScreenToClient(P);
        FHotIndex := ItemAtPos(P.X, P.Y);
      end;

      UpdateScrollbar;
      if FItemCount > 0 then
        Invalidate;

      FTopIndex := Value;

      Indx := FHotIndex;
      FHotIndex := OldHot;

      SetHotIndex(Indx, False);
    end;

    if FScrollbarChanging = 0 then
      TSCVirtualListboxScrollbar(ScrollbarVert).Position := FTopIndex;
  finally
    Dec(FScrollPosChanging);
  end;
end;

function TSCCustomVirtualListbox.CanShowScrollbar: Boolean;
var
  CH, H, Rows: Integer;
begin
  H := GetRowHeight;

  Result := (FItemCount > 1) and (FRowCount > 1) and (H > 0);

  if Result and (H > 0) then
  begin
    CH := ClientHeight;
    Rows := CH div H;

    Result := (CH mod H > 0) or (FItemCount > Rows);
  end;
end;

function TSCCustomVirtualListbox.IsHorzScrollBarVisible: Boolean;
begin
  Result := False;
end;

function TSCCustomVirtualListbox.IsVertScrollBarVisible: Boolean;
begin
  Result := FShowScrollbar and inherited IsVertScrollBarVisible;
end;

function TSCCustomVirtualListbox.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCVirtualListBorderProps;
end;

procedure TSCCustomVirtualListbox.SetItemCount(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FItemCount <> Value then
  begin
    FItemCount := Value;

    CalculateRowCount;
    UpdateScrollBar;
  end;
end;

procedure TSCCustomVirtualListbox.SetItemIndex(Value: Integer);
var
  NeedPaint: Boolean;
begin
  VerifyIndex(Value);
  Value := CanChangeItemIndex(Value);

  if FItemIndex <> Value then
  begin
    NeedPaint := (FItemCount > -1) and
      (ItemInView(FItemIndex) or ItemInView(Value));

    FItemIndex := Value;
    if NeedPaint then
      Invalidate;

    DoItemClick(FItemIndex);
    Click;
  end;
end;

procedure TSCCustomVirtualListbox.DoItemClick(Index: Integer);
begin
  //
end;

function TSCCustomVirtualListbox.GetPageDownIndex(Index: Integer): Integer;
begin
  Result := Index;

  if (FItemCount > 0) and (GetRowHeight < 1) then
  begin
    Inc(Result, FRowCount);

    if FRevertable and (Result > FItemCount) then
      Result := 0;
  end;

  VerifyIndex(Result);
  if Result < 0 then
    Result := 0;
end;

function TSCCustomVirtualListbox.GetPageUpIndex(Index: Integer): Integer;
begin
  Result := Index;

  if (FItemCount > 0) and (GetRowHeight < 1) then
  begin
    Dec(Result, FRowCount);

    if FRevertable and (Result < 0) then
      Result := FItemCount;
  end;

  VerifyIndex(Result);
  if Result < 0 then
    Result := 0;
end;

procedure TSCCustomVirtualListbox.WMMouseWheel(var Message: TWMMouseWheel);
var
  Dif: Integer;
begin
  if not IsDesigning and (FItemCount > 0) and (FRowCount > 0) then
  begin
    Dif := 3;
    if FRowCount <= 1 then
      Dif := 1
    else if Dif > FRowCount then
      Dif := FRowCount;

    if Message.WheelDelta < 0 then
      SetTopIndex(FTopIndex + Dif)
    else
    if Message.WheelDelta > 0 then
      SetTopIndex(FTopIndex - Dif);
  end;    
end;

procedure TSCCustomVirtualListbox.SetItemHeight(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FItemHeight <> Value then
  begin
    FItemHeight := Value;

    CalculateRowCount;
    UpdateScrollBar;
  end;
end;

function TSCCustomVirtualListbox.GetTextHeight: Integer;
begin
  Result := FItemHeight;
  if Result = 0 then Result := inherited GetTextHeight + 2;
end;

function TSCCustomVirtualListbox.GetControlScrollbarsClass: TSCControlCustomScrollbarsClass;
begin
  Result := TSCVirtualListScrollbar;
end;

function TSCCustomVirtualListbox.CanChangeItemIndex(
  Index: Integer): Integer;
begin
  Result := Index;
end;

procedure TSCCustomVirtualListbox.MouseInControlChanged;
var
  Indx, OldHot: Integer;
begin
  OldHot := FHotIndex;
  FHotIndex := -1;

  if not MouseInControl then
  begin
    Indx := FHotIndex;
    FHotIndex := OldHot;

    SetHotIndex(Indx, True);
  end else
  begin
    UpdateHotTrack(False);
    if FHotTrack and (OldHot <> FHotIndex) then
      Invalidate;
  end;
end;

procedure TSCCustomVirtualListbox.PauseScrolling;
begin
  FScrolling := False;
end;

procedure TSCCustomVirtualListbox.ResumeScrolling;
begin
  FScrolling := (FScrollTimer <> -1) and Enabled and (FMouseDownIndex > -1);
end;

function TSCCustomVirtualListbox.Scrolling: Boolean;
begin
  Result := Enabled and FScrolling and (FMouseDownIndex > -1) and
    (FScrollTimer <> -1);
end;

function TSCCustomVirtualListbox.ScrollPaused: Boolean;
begin
  Result := not (Enabled and FScrolling and (FMouseDownIndex > -1)) and
    (FScrollTimer <> -1);
end;

procedure TSCCustomVirtualListbox.StartScrolling(TimerTrigger: Boolean);
var
  R: TRect;
  P: TPoint;
  OldIndex, Index,
  Dif, ScrollDelay: Integer;
begin
  if HandleAllocated then
  begin
    if not GetCursorPos(P) then
      Exit;

    if ScrollPaused then
    begin
      ResumeScrolling;
      Exit;
    end;

    if TimerTrigger or not Scrolling then
    begin
      OldIndex := FItemIndex;
      
      ScrollDelay := 60;
      StopScrolling;

      R := GetClientRect;
      P := Self.ScreenToClient(P);

      Dif := 0;
      if P.y > R.Bottom then
      begin
        SetTopIndex(FTopIndex + 1);
        Dif := Abs(R.Bottom - P.y);

        Index := LastVisibleItem(False);
        SetItemIndex(Index);
      end else
      if P.y < R.Top then
      begin
        SetTopIndex(FTopIndex - 1);
        Dif := Abs(R.Top - P.y);

        SetItemIndex(FTopIndex);
      end;

      CheckTopIndex(OldIndex, FItemIndex);

      if Dif >= 50 then
        ScrollDelay := 20
      else
      if Dif >= 25 then
        ScrollDelay := 40;

      if FScrollTimer <> -1 then
        KillTimer(Handle, FScrollTimer);

      FScrollTimer := SetTimer(Handle, SC_VLISTSCROLL_TIMERID, ScrollDelay, nil);
      FScrolling := FScrollTimer <> -1;
    end;
  end;
end;

procedure TSCCustomVirtualListbox.StopScrolling;
begin
  FScrolling   := False;
  if FScrollTimer <> -1 then
  begin
    if HandleAllocated then
      KillTimer(Handle, FScrollTimer);

    FScrollTimer := -1;
    Invalidate;
  end;
end;

procedure TSCCustomVirtualListbox.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateScrollbar;

  CalculateRowCount;
end;

procedure TSCCustomVirtualListbox.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := DLGC_WANTARROWS;
end;

procedure TSCCustomVirtualListbox.WMLButtonDown(
  var Message: TWMLButtonDown);
var
  ShiftState: TShiftState;
begin
  ShiftState := KeysToShiftState(Message.Keys);
  inherited;

  if (DragMode = dmAutomatic) and (ShiftState*[ssShift, ssCtrl] = []) then
    BeginDrag(False);
end;

procedure TSCCustomVirtualListbox.WndProc(var Message: TMessage);
begin
  if (DragMode = dmAutomatic) and not IsDesigning and not Dragging and
    ((Message.Msg = WM_LBUTTONDOWN) or (Message.Msg = WM_LBUTTONDBLCLK)) then
  begin
    if IsControlMouseMsg(TWMMouse(Message)) then
      Exit;

    if not Focused and CanFocus then
      SetFocus;

    ControlState := ControlState + [csLButtonDown];
    Dispatch(Message);

    Exit;
  end;

  inherited WndProc(Message);
end;

procedure TSCCustomVirtualListbox.ColorsChanged;
begin
  //
end;

procedure TSCCustomVirtualListbox.CheckTopIndex(OldIndex, NewIndex: Integer);
var
  CH, RH, Rows: Integer;
begin
  if not ItemInView(NewIndex, False) then
  begin
    if OldIndex > NewIndex then
      SetTopIndex(NewIndex)
    else begin
      CH := ClientHeight;
      if CH < 0 then CH := 0;

      RH := GetRowHeight;
      if RH < 1 then RH := 1;

      Rows := CH div RH;
      SetTopIndex(NewIndex - Rows + 1);
    end;
  end;
end;

procedure TSCCustomVirtualListbox.MakeVisible(Index: Integer);
var
  TopIndx: Integer;
begin
  if (Index > -1) and (Index < FItemCount) and
    not ItemInView(Index, False) then
  begin
    TopIndx := FTopIndex;
    VerifyTopIndex(TopIndx);

    if Index < TopIndx then
      SetTopIndex(Index)
    else
    if Index > TopIndx then
    begin
      TopIndx := GetPageUpIndex(Index);
      VerifyTopIndex(TopIndx);

      SetTopIndex(TopIndx);
    end;
  end;
end;

procedure TSCCustomVirtualListbox.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    if FItemCount > 0 then
      Invalidate;
  end;
end;

function TSCCustomVirtualListbox.IndexOfItem(Str: String): Integer;
var
  S: String;
  I, Start, Cnt, Img: Integer;
begin
  Result := -1;
  if FItemCount > 0 then
  begin
    if FItems.Count > 0 then
    begin
      Result := FItems.IndexOf(Str);

      if (Result >= 0) and (FTopIndex > -1) then
      begin
        Inc(Result, FTopIndex);

        Cnt := Result + FRowCount;
        if Cnt > FItemCount-1 then
          Cnt := FItemCount-1;

        for I := Result to Cnt do
        begin
          S := '';
          Img := -1;

          if GetItem(I, S, Img) and AnsiSameText(Str, S) then
          begin
            Result := I;
            Exit;
          end;
        end;
      end;
    end;

    Cnt := FTopIndex - 1;
    for I := 0 to Cnt do
    begin
      S := '';
      Img := -1;

      if not GetItem(I, S, Img) then
      begin
        Result := -1;
        Exit;
      end;

      if AnsiSameText(Str, S) then
      begin
        Result := I;
        Exit;
      end;
    end;

    if Result > -1 then
      Exit;

    Start := FTopIndex + FRowCount;

    Cnt := FItemCount - Start - 1;
    for I := Start to Cnt do
    begin
      S := '';
      Img := -1;

      if not GetItem(I, S, Img) then
      begin
        Result := -1;
        Exit;
      end;

      if AnsiSameText(Str, S) then
      begin
        Result := I;
        Exit;
      end;
    end;
  end;
end;

function TSCCustomVirtualListbox.ItemText(Index: Integer): String;
var
  Img: Integer;
begin
  Result := '';
  if (Index > -1) and (Index < FItemCount) then
  begin
    if (Index >= FTopIndex) and (Index < FTopIndex + FItems.Count) then
      Result := FItems[Index - FTopIndex]
    else begin
      Img := -1;
      if not GetItem(Index, Result, Img) then
        Result := '';
    end;
  end;
end;

procedure TSCCustomVirtualListbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomVirtualListbox then
  begin
    with TSCCustomVirtualListbox(Source) do
    begin
      Self.ForceDropdownClick := ForceDropdownClick;
      Self.Alignment := Alignment;
      Self.DisabledColor := DisabledColor;
      Self.DisabledTextColor := DisabledTextColor;
      Self.EndEllipsis := EndEllipsis;
      Self.HideFocusRect := HideFocusRect;
      Self.HideSelection := HideSelection;
      Self.HideSelectionColor := HideSelectionColor;
      Self.HideSelectionTextColor := HideSelectionTextColor;
      Self.HighlightColor := HighlightColor;
      Self.HighlightTextColor := HighlightTextColor;
      Self.Hottrack := Hottrack;
      Self.HottrackColor := HottrackColor;
      Self.HottrackUnderline := HottrackUnderline;
      Self.ItemHeight := ItemHeight;
      Self.ItemCount := ItemCount;
      Self.ItemIndex := ItemIndex;
      Self.Picture := Picture;
      Self.PictureProps := PictureProps;
      Self.PictureOrient := PictureOrient;
      Self.PictureIndent := PictureIndent;
      Self.PictureTopIndent := PictureTopIndent;
      Self.PictureTransparent := PictureTransparent;
      Self.Revertable := Revertable;
      Self.ShowItemImages := ShowItemImages;
      Self.ShowPicture := ShowPicture;
      Self.ShowScrollbar := ShowScrollbar;
      Self.TopIndex := TopIndex;
    end;
  end;
end;

function TSCCustomVirtualListbox.GetListItemIndex(Str: String): Integer;
begin
  if Assigned(FOnGetItemIndex) then
    Result := FOnGetItemIndex(Self, Str)
  else Result := IndexOfItem(Str);
end;

{$I SCVerRec.inc}

end.
