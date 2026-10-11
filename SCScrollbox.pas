{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCScrollbox;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Math, SCCommon, SCConsts, SCResStrs, SCControl;

type
  TSCScrollboxScrollbar = class(TSCControlScrollbar)
  private
    FVisible: Boolean;
    FCalcRange: Integer;
    procedure SetVisible(Value: Boolean);
    function  GetScrollPos: Integer;
  protected
    procedure SetPosition(Value: Integer); override;
    function  GetSensitivity: Integer; override;

    property Sensitivity default 120;
  public
    constructor Create(AOwner: TSCCustomControl; AKind: TSCScrollbarKind); override;
    function  GetCalcRange: Integer; override;

    property ScrollPos: Integer read GetScrollPos;
  published
    property Background;
    property ButtonColors;
    property Icons;
    property SlideLine;
    property Thumb;
    property Track default False;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TSCScrollboxScrollbars = class(TSCControlScrollbars);

  TSCScrollboxBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccb3DLowered;
    property Color default clWindow;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCCustomScrollbox = class(TSCCustomScrollControl)
  private
    FScaled: Boolean;
    FAutoScroll: Boolean;
    FAutoRangeCount: Integer;
    FGridX: Integer;
    FGridY: Integer;
    FGridOffsetX: Integer;
    FGridOffsetY: Integer;
    FCreatingWnd: Integer;
    FUpdatingScrollBars: Integer;
    FHorzSize: Integer;
    FVertSize: Integer;
    FScrolling: Integer;
    FShowGrid: Boolean;
    FScrollbarChanging: Integer;
    procedure SetAutoScroll(Value: Boolean);
    procedure SetGridOffsetX(Value: Integer);
    procedure SetGridOffsetY(Value: Integer);
    procedure SetGridX(Value: Integer);
    procedure SetGridY(Value: Integer);
    procedure SetShowGrid(Value: Boolean);

    procedure ScrollByPos(Kind: TSCScrollbarKind; Dif: Integer); overload;
    procedure UpdateScrollBars;
    procedure UpdateScrollbar(Kind: TSCScrollbarKind);
    procedure ScaleScrollBars(M, D: Integer);

    procedure CalcAutoSize;
    procedure CalcAutoRange;

    function  ControlSize(CalcWidth, IgnoreSB: Boolean): Integer;

    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure CreateWnd; override;
    procedure CreateParams(var Params: TCreateParams); override;

    procedure AdjustClientRect(var Rect: TRect); override;
    procedure AlignControls(AControl: TControl; var ARect: TRect); override;
    procedure ChangeScale(M, D: Integer); override;

    function  GetControlScrollbarsClass: TSCControlCustomScrollbarsClass; override;
    function  GetScrollbarClass: TSCCustomControlScrollbarClass; override;
    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;

    procedure NeedsScrollBarsVisible(var Horz, Vert: Boolean);
    procedure DoScrollerPositionChanged(Kind: TSCScrollbarKind;
      OldPos, NewPos: Integer); override;

    function  AutoScrollEnabled: Boolean; virtual;
    procedure AutoScrollInView(AControl: TControl); virtual;
    procedure Resizing(State: TWindowState); virtual;

    property AutoScroll: Boolean read FAutoScroll write SetAutoScroll default True;
    property Border default sccb3DLowered;
    property GridOffsetX: Integer read FGridOffsetX write SetGridOffsetX default 0;
    property GridOffsetY: Integer read FGridOffsetY write SetGridOffsetY default 0;
    property GridX: Integer read FGridX write SetGridX default 8;
    property GridY: Integer read FGridY write SetGridY default 8;
    property ShowGrid: Boolean read FShowGrid write SetShowGrid default False;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    procedure DisableAutoRange;
    procedure EnableAutoRange;
    procedure ScrollInView(AControl: TControl);
    procedure ScrollByPos(HorzDif, VertDif: Integer); overload;
    function  GetScrollPos(Kind: TSCScrollbarKind): Integer;
  end;

  TSCScrollbox = class(TSCCustomScrollbox)
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Color nodefault;
    property Font;
    property GridOffsetX;
    property GridOffsetY;
    property GridX;
    property GridY;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Scrollbars;
    property ShowGrid;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnScroll;
    property OnScrollChangeEvent;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation

type
  TSCFakeScrollbar = class(TSCCustomControlScrollbar);

{ TSCCustomScrollbox }

procedure TSCCustomScrollbox.AdjustClientRect(var Rect: TRect);
begin
  Rect := Bounds(-TSCScrollboxScrollbar(ScrollBarHorz).Position,
    -TSCScrollboxScrollbar(ScrollBarVert).Position,
    Max(TSCScrollboxScrollbar(ScrollBarHorz).Range, ClientWidth),
    Max(ClientHeight, TSCScrollboxScrollbar(ScrollBarVert).Range));

  inherited AdjustClientRect(Rect);
end;

procedure TSCCustomScrollbox.AlignControls(AControl: TControl;
  var ARect: TRect);
begin
  CalcAutoSize;
  inherited AlignControls(AControl, ARect);
  UpdateScrollbars;
end;

function TSCCustomScrollbox.AutoScrollEnabled: Boolean;
begin
  Result := not AutoSize and not (DockSite and UseDockManager);
end;

procedure TSCCustomScrollbox.AutoScrollInView(AControl: TControl);
begin
  if (AControl <> nil) and not (csLoading in AControl.ComponentState) and
    not IsLoading then
    ScrollInView(AControl);
end;

procedure TSCCustomScrollbox.CalcAutoRange;
begin
  if (FAutoRangeCount = 0) and FAutoScroll then
  begin
    CalcAutoSize;

    TSCScrollboxScrollbar(ScrollbarHorz).SetRange(FHorzSize);
    TSCScrollboxScrollbar(ScrollbarVert).SetRange(FVertSize);
  end;
end;

procedure TSCCustomScrollbox.CalcAutoSize;
var
  NewRange, AlignMargin: Integer;

  procedure ProcessHorz(Control: TControl);
  begin
    if Control.Visible then
      case Control.Align of
        alLeft, alNone:
          if (Control.Align = alLeft) or (Control.Anchors * [akLeft, akRight] = [akLeft]) then
            NewRange := Math.Max(NewRange, Control.Left + Control.Width);
        alRight:
          Inc(AlignMargin, Control.Width);
      end;
  end;

  procedure ProcessVert(Control: TControl);
  begin
    if Control.Visible then
      case Control.Align of
        alTop, alNone:
          if (Control.Align = alTop) or (Control.Anchors * [akTop, akBottom] = [akTop]) then
            NewRange := Math.Max(NewRange, Control.Top + Control.Height);
        alBottom:
          Inc(AlignMargin, Control.Height);
      end;
  end;

  procedure UpdateRange(CalcHorz: Boolean);
  var
    I: Integer;
  begin
    NewRange := 0;
    AlignMargin := 0;

    if AutoScrollEnabled then
    begin
      for I := 0 to ControlCount - 1 do
        if CalcHorz then
          ProcessHorz(Controls[I]) else
          ProcessVert(Controls[I]);
    end;

    if CalcHorz then
      FHorzSize := NewRange + AlignMargin + TSCFakeScrollbar(ScrollbarHorz).Position
    else
      FVertSize := NewRange + AlignMargin + TSCFakeScrollbar(ScrollbarVert).Position;
  end;

begin
  UpdateRange(True);
  UpdateRange(False);
end;

procedure TSCCustomScrollbox.ChangeScale(M, D: Integer);
begin
  ScaleScrollBars(M, D);
  inherited ChangeScale(M, D);
end;

function TSCCustomScrollbox.ControlSize(CalcWidth, IgnoreSB: Boolean): Integer;

  function Adjustment(CalcWidth: Boolean): Integer;
  var
    Sb: TSCFakeScrollbar;
  begin
    Result := 0;

    if IgnoreSB then
    begin
      Sb := TSCFakeScrollbar(ScrollbarHorz);
      if CalcWidth then Sb := TSCFakeScrollbar(ScrollbarVert);

      if Sb.Visible then
      begin
        Result := GetHorzScrollbarHeight;
        if CalcWidth then Result := GetVertScrollbarWidth;
      end;
    end;  
  end;

begin
  if CalcWidth then Result := ClientWidth
  else Result := ClientHeight;
  
  Inc(Result, Adjustment(CalcWidth));
end;

constructor TSCCustomScrollbox.Create(AOwner: TComponent);
begin
  FAutoScroll := True;
  FGridX := 8;
  FGridY := 8;
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse,
    csClickEvents, csSetCaption, csDoubleClicks];

  SetBounds(Left, Top, 185, 140);
  Border := sccb3DLowered;
  ClickFocus := False;
end;

procedure TSCCustomScrollbox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params.WindowClass do
    style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TSCCustomScrollbox.CreateWnd;
begin
  Inc(FCreatingWnd);
  try
    inherited CreateWnd;
  finally
    Dec(FCreatingWnd);
  end;
  UpdateScrollBars;
end;

procedure TSCCustomScrollbox.DisableAutoRange;
begin
  Inc(FAutoRangeCount);
end;

procedure TSCCustomScrollbox.DoScrollerPositionChanged(
  Kind: TSCScrollbarKind; OldPos, NewPos: Integer);
begin
  if FScrolling = 0 then
  begin
    Inc(FScrollbarChanging);
    try
      ScrollByPos(Kind, OldPos - NewPos);
    finally
      Dec(FScrollbarChanging);
    end;
  end;
end;

procedure TSCCustomScrollbox.EnableAutoRange;
begin
  if FAutoRangeCount > 0 then
  begin
    Dec(FAutoRangeCount);
    if (FAutoRangeCount = 0) then
      UpdateScrollBars;
  end;
end;

function TSCCustomScrollbox.GetControlScrollbarsClass: TSCControlCustomScrollbarsClass;
begin
  Result := TSCScrollboxScrollbars;
end;

function TSCCustomScrollbox.GetScrollbarClass: TSCCustomControlScrollbarClass;
begin
  Result := TSCScrollboxScrollbar;
end;

procedure TSCCustomScrollbox.NeedsScrollBarsVisible(var Horz, Vert: Boolean);
var
  W, H: Integer;
begin
  CalcAutoSize;

  W := ControlSize(True, True);
  if W < 0 then W := 0;

  Horz := FHorzSize > W;

  H := ControlSize(False, True);
  if H < 0 then H := 0;

  if Horz then Dec(H, GetHorzScrollbarHeight);
  Vert := FVertSize > H;

  if not Horz and Vert then
  begin
    Dec(W, GetVertScrollbarWidth);
    Horz := FHorzSize > W;
  end;
end;

procedure TSCCustomScrollbox.Resizing(State: TWindowState);
begin

end;

procedure TSCCustomScrollbox.ScaleScrollBars(M, D: Integer);
begin
  FScaled := False;
  if M <> D then
  begin
    if not IsLoading then
      FScaled := True;

    TSCScrollboxScrollbar(ScrollBarHorz).Position := 0;
    TSCScrollboxScrollbar(ScrollBarVert).Position := 0;

    if not FAutoScroll then
    begin
      with TSCScrollboxScrollbar(ScrollBarHorz) do
        if FScaled then Range := MulDiv(Range, M, D);

      with TSCScrollboxScrollbar(ScrollBarVert) do
        if FScaled then Range := MulDiv(Range, M, D);
    end;
  end;

  FScaled := False;
end;

procedure TSCCustomScrollbox.ScrollInView(AControl: TControl);
var
  Rect: TRect;
  P1, P2, OldHorz, OldVert: Integer;
begin
  if AControl <> nil then
  begin
    P1 := TSCScrollboxScrollbar(ScrollBarHorz).Position;
    P2 := TSCScrollboxScrollbar(ScrollBarVert).Position;

    Rect := AControl.ClientRect;

    Rect.TopLeft := ScreenToClient(AControl.ClientToScreen(Rect.TopLeft));
    Rect.BottomRight := ScreenToClient(AControl.ClientToScreen(Rect.BottomRight));

    if Rect.Left < 0 then
    begin
      with TSCScrollboxScrollbar(ScrollBarHorz) do
        Inc(P1, Rect.Left)
    end else
    if Rect.Right > ClientWidth then
    begin
      if Rect.Right - Rect.Left > ClientWidth then
        Rect.Right := Rect.Left + ClientWidth;

      with TSCScrollboxScrollbar(ScrollBarHorz) do
        Inc(P1, Rect.Right - ClientWidth);
    end;

    if Rect.Top < 0 then
    begin
      with TSCScrollboxScrollbar(ScrollBarVert) do
        Inc(P2, Rect.Top)
    end else
    if Rect.Bottom > ClientHeight then
    begin
      if Rect.Bottom - Rect.Top > ClientHeight then
        Rect.Bottom := Rect.Top + ClientHeight;

      with TSCScrollboxScrollbar(ScrollBarVert) do
        Inc(P2, Rect.Bottom - ClientHeight);
    end;

    Inc(FScrolling);
    try
      OldHorz := TSCScrollboxScrollbar(ScrollBarHorz).Position;
      OldVert := TSCScrollboxScrollbar(ScrollBarVert).Position;

      TSCScrollboxScrollbar(ScrollBarHorz).Position := P1;
      TSCScrollboxScrollbar(ScrollBarVert).Position := P2;

      P1 := TSCScrollboxScrollbar(ScrollBarHorz).Position;
      P2 := TSCScrollboxScrollbar(ScrollBarVert).Position;

      ScrollByPos(OldHorz - P1, OldVert - P2);
    finally
      Dec(FScrolling);
    end;
  end;
end;

procedure TSCCustomScrollbox.ScrollByPos(Kind: TSCScrollbarKind; Dif: Integer);
var
  Form: TCustomForm;
begin
  if Dif <> 0 then
  begin
    Inc(FScrolling);
    try
      if Kind = scskHorizontal then
        ScrollBy(Dif, 0) else
        ScrollBy(0, Dif);

      if IsDesigning then
      begin
        Form := GetParentForm(Self);
        if (Form <> nil) and (Form.Designer <> nil) then
          Form.Designer.Modified;
      end;

      UpdateScrollBars;
    finally
      Dec(FScrolling);
    end;
  end;
end;

procedure TSCCustomScrollbox.SetAutoScroll(Value: Boolean);
begin
  if FAutoScroll <> Value then
  begin
    FAutoScroll := Value;
    UpdateScrollBars;
  end;
end;

procedure TSCCustomScrollbox.UpdateScrollbar(Kind: TSCScrollbarKind);
var
  CW, CH, W, H: Integer;
  Horz, Vert: Boolean;
  Sb: TSCScrollboxScrollbar;
  SiOld, SiNew: TSCScrollInfo;
begin
  Sb := TSCScrollboxScrollbar(ScrollbarHorz);
  if Kind = scskVertical then
    Sb := TSCScrollboxScrollbar(ScrollbarVert);

  Sb.FCalcRange := 0;

  if HandleAllocated and (FCreatingWnd = 0) and not IsLoading then
  begin
    SiOld := GetScrollbarInfo(Kind);
    SiNew := SiOld;

    SiNew.Page  := 1;
    SiNew.Range := 0;
    SiNew.Min   := 0;
    SiNew.Max   := 0;
    SiNew.Pos   := 0;

    CW := ControlSize(True, True);
    if CW < 0 then CW := 0;

    W := CW;
    Horz := FHorzSize > W;

    CH := ControlSize(False, True);
    if CH < 0 then CH := 0;

    H := CH;

    if Horz then Dec(H, GetHorzScrollbarHeight);
    Vert := FVertSize > H;

    if Vert then
    begin
      Dec(W, GetVertScrollbarWidth);
      if not Horz then Horz := FHorzSize > W;
    end;

    if Sb.FVisible then
    begin
      if Kind = scskHorizontal then
        Sb.FCalcRange := SiOld.Range - W
      else Sb.FCalcRange := SiOld.Range - H;

      if Sb.FCalcRange < 0 then Sb.FCalcRange := 0;

      if Sb.FCalcRange > 0 then SiNew.Max := SiOld.Range;
    end;

    SiNew.Pos := SiOld.Pos;
    if Kind = scskHorizontal then
    begin
      SiNew.Page := W;
      SiNew.LargeChange := (CW * 9) div 10;
      SiNew.Visible := Sb.FVisible and Horz;
    end else
    begin
      SiNew.Page := H;
      SiNew.LargeChange := (CH * 9) div 10;
      SiNew.Visible := Sb.FVisible and Vert;
    end;

    SiNew.SmallChange := SiNew.LargeChange div 10;

    SetScrollbarInfo(Kind, SiNew);
  end;
end;

procedure TSCCustomScrollbox.UpdateScrollBars;
begin
  if (FUpdatingScrollBars = 0) and HandleAllocated and FAutoScroll then
  begin
    CalcAutoRange;

    Inc(FUpdatingScrollBars);
    try
      UpdateScrollbar(scskVertical);
      UpdateScrollbar(scskHorizontal);
    finally
      Dec(FUpdatingScrollBars);
    end;
  end;  
end;

procedure TSCCustomScrollbox.WMSize(var Message: TWMSize);
var
  NewState: TWindowState;
begin
  Inc(FAutoRangeCount);
  try
    inherited;

    NewState := wsNormal;
    case Message.SizeType of
      SIZENORMAL:
        NewState := wsNormal;
      SIZEICONIC:
        NewState := wsMinimized;
      SIZEFULLSCREEN:
        NewState := wsMaximized;
    end;

    Resizing(NewState);
  finally
    Dec(FAutoRangeCount);
  end;

  UpdateScrollBars;
end;

procedure TSCCustomScrollbox.Paint;
var
  DC: HDC;
  CR, R: TRect;
  X, Y: Integer;
begin
  if not HandleAllocated then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;

    FillRect(R);
  end;

  if Transparent then
    PaintParentOn(Canvas);

  DrawPicture(Canvas);

  if FShowGrid then
  begin
    R := CR;

    Inc(R.Left, FGridOffsetX);
    Inc(R.Top, FGridOffsetY);

    R.Left := R.Left + ((FGridX - TSCFakeScrollbar(ScrollbarHorz).Position) mod FGridX);
    R.Top := R.Top + ((FGridY - TSCFakeScrollbar(ScrollbarVert).Position) mod FGridY);

    DC := Canvas.Handle;

    for X := 0 to (R.Right - R.Left) div FGridX do
      for Y := 0 to (R.Bottom - R.Top) div FGridY do
        PatBlt(DC, X * FGridX + R.Left, Y * FGridY + R.Top, 1, 1, PATINVERT);
  end;
end;

procedure TSCCustomScrollbox.Loaded;
begin
  inherited Loaded;
  UpdateScrollBars;
end;

procedure TSCCustomScrollbox.SetGridX(Value: Integer);
begin
  if Value < 2 then Value := 2
  else if Value > 100 then
    Value := 100;

  if FGridX <> Value then
  begin
    FGridX := Value;
    Invalidate;
  end;
end;

procedure TSCCustomScrollbox.SetGridY(Value: Integer);
begin
  if Value < 2 then Value := 2
  else if Value > 100 then
    Value := 100;

  if FGridY <> Value then
  begin
    FGridY := Value;
    Invalidate;
  end;
end;

procedure TSCCustomScrollbox.SetShowGrid(Value: Boolean);
begin
  if FShowGrid <> Value then
  begin
    FShowGrid := Value;
    Invalidate;
  end;
end;

procedure TSCCustomScrollbox.CMFocusChanged(var Message: TCMFocusChanged);
var
  C, P: TWinControl;
begin
  C := TWinControl(Message.Sender);
  if (C <> nil) and (C.Parent <> nil) then
  begin
    P := C.Parent;
    while P <> nil do
    begin
      if P is TCustomForm then
        Break;

      if P = Self then AutoScrollInView(C);
      P := P.Parent;  
    end;
  end;

  inherited;
end;

procedure TSCCustomScrollbox.ScrollByPos(HorzDif, VertDif: Integer);
var
  Form: TCustomForm;
begin
  if (HorzDif <> 0) or (VertDif <> 0) then
  begin
    Inc(FScrolling);
    try
      ScrollBy(HorzDif, VertDif);

      if IsDesigning then
      begin
        Form := GetParentForm(Self);
        if (Form <> nil) and (Form.Designer <> nil) then
          Form.Designer.Modified;
      end;

      UpdateScrollBars;
    finally
      Dec(FScrolling);
    end;
  end;
end;

function TSCCustomScrollbox.GetScrollPos(Kind: TSCScrollbarKind): Integer;
var
  Sb: TSCScrollboxScrollbar;
begin
  Sb := TSCScrollboxScrollbar(ScrollbarHorz);
  if Kind = scskVertical then
    Sb := TSCScrollboxScrollbar(ScrollbarVert);

  Result := Sb.ScrollPos;
end;

procedure TSCCustomScrollbox.SetGridOffsetX(Value: Integer);
begin
  if FGridOffsetX <> Value then
  begin
    FGridOffsetX := Value;
    Invalidate;
  end;
end;

procedure TSCCustomScrollbox.SetGridOffsetY(Value: Integer);
begin
  if FGridOffsetY <> Value then
  begin
    FGridOffsetY := Value;
    Invalidate;
  end;
end;

procedure TSCCustomScrollbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomScrollbox then
    with TSCCustomScrollbox(Source) do
    begin
      Self.AutoScroll := AutoScroll;
      Self.GridOffsetX := GridOffsetX;
      Self.GridOffsetY := GridOffsetY;
      Self.GridX := GridX;
      Self.GridY := GridY;
      Self.ShowGrid := ShowGrid;
    end;
end;

function TSCCustomScrollbox.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCScrollboxBorderProps;
end;

{ TSCScrollboxScrollbar }

constructor TSCScrollboxScrollbar.Create(AOwner: TSCCustomControl;
  AKind: TSCScrollbarKind);
begin
  inherited Create(AOwner, AKind);
  Sensitivity := 120;
  Track := False;
  FVisible := True;
end;

function TSCScrollboxScrollbar.GetCalcRange: Integer;
begin
  Result := FCalcRange;
end;

function TSCScrollboxScrollbar.GetScrollPos: Integer;
begin
  Result := 0;
  if Visible then Result := Position;
end;

function TSCScrollboxScrollbar.GetSensitivity: Integer;
begin
  Result := -1;
  if not Track then Result := inherited GetSensitivity;
end;

procedure TSCScrollboxScrollbar.SetPosition(Value: Integer);
begin
  if not (csReading in TControl(Owner).ComponentState) then
  begin
    if Value > FCalcRange then Value := FCalcRange
    else if Value < 0 then Value := 0;
  end;

  inherited SetPosition(Value);
end;

procedure TSCScrollboxScrollbar.SetVisible(Value: Boolean);
begin
  FVisible := Value;
  TSCCustomScrollbox(Owner).UpdateScrollBars;
end;

{ TSCScrollboxBorderProps }

constructor TSCScrollboxBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccb3DLowered;
end;

{.$I SCVerRec.inc}

end.

