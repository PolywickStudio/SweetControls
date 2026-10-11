{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCScrollbars;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Extctrls, ImgList, StdActns, ActnList, Menus, SCCommon, SCConsts, SCControl;

type
  TSCCustomScrollbar = class;

  TSCScrollbarColors = class(TPersistent)
  private
    FOwner: TSCCustomScrollbar;
    FActiveColor: TColor;
    FBlendColors: Boolean;
    FDefaultColor: TColor;
    FDisabledColor: TColor;
    FDownColor: TColor;
    FHotColor: TColor;
    FUpdateCount: Integer;
    procedure SetActiveColor(Value: TColor);
    procedure SetBlendColors(Value: Boolean);
    procedure SetDefaultColor(Value: TColor);
    procedure SetDisabledColor(Value: TColor);
    procedure SetDownColor(Value: TColor);
    procedure SetHotColor(Value: TColor);
  protected
    procedure DoChange;
    function  GetBlendColors: Boolean; virtual;

    function  GetNoneColor: TColor; virtual;
    function  GetActiveColor: TColor; virtual;
    function  GetDefaultColor: TColor; virtual;
    function  GetDisabledColor: TColor; virtual;
    function  GetDownColor: TColor; virtual;
    function  GetHotColor: TColor; virtual;
  public
    constructor Create(AOwner: TSCCustomScrollbar); virtual;
    procedure Assign(Source: TPersistent); override;

    function  InUpdate: Boolean;
    procedure BeginUpdate;
    procedure EndUpdate;
  published
    property ActiveColor: TColor read FActiveColor write SetActiveColor default clBtnFace;
    property BlendColors: Boolean read FBlendColors write SetBlendColors default False;
    property DefaultColor: TColor read FDefaultColor write SetDefaultColor default clBtnFace;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clBtnFace;
    property DownColor: TColor read FDownColor write SetDownColor default clBtnFace;
    property HotColor: TColor read FHotColor write SetHotColor default clBtnFace;
  end;

  TSCScrollbarBkColors = class(TSCScrollbarColors)
  public
    constructor Create(AOwner: TSCCustomScrollbar); override;
  published
    property BlendColors default True;
    property DownColor default cl3DDkShadow;
  end;

  TSCScrollbarIconColors = class(TSCScrollbarColors)
  protected
    function GetNoneColor: TColor; override;
  public
    constructor Create(AOwner: TSCCustomScrollbar); override;
  published
    property ActiveColor default clBtnText;
    property DefaultColor default clBtnText;
    property DisabledColor default clBtnShadow;
    property DownColor default clBtnText;
    property HotColor default clBtnText;
  end;

  TSCCustomScrollbar = class(TSCCustomControl)
  private
    FFlashColor: TColor;
    FFlashOnFocus: Boolean;
    FBackColors: TSCScrollbarColors;
    FButtonColors: TSCScrollbarColors;
    FButtonIconColors: TSCScrollbarColors;
    FThumbColors: TSCScrollbarColors;
    FButtonLayout: TSCScrollButtonLayout;
    FButtonSize: Integer;
    FLargeChange: TSCScrollBarInc;
    FMax: Integer;
    FMin: Integer;
    FKind: TSCScrollbarKind;
    FPageSize: Integer;
    FPosition: Integer;
    FShowButtons: Boolean;
    FShowSlideLine: Boolean;
    FShowThumb: Boolean;
    FSmallChange: TSCScrollBarInc;
    FThumbLines: TSCScrollThumbline;
    FThumbSize: Integer;
    FTracking: Boolean;
    FTrimPageSize: Boolean;
    FDefH_ButtonSize: Integer;
    FDefV_ButtonSize: Integer;
    FDownPoint: TPoint;
    FMovePoint: TPoint;
    FDownPosition: Integer;
    FMovingThumb: Boolean;
    FPressedPart: TSCScrollerHitPart;
    FHotPart: TSCScrollerHitPart;
    FScrolling: Boolean;
    FScrollTimer: Integer;
    FSensitivity: Integer;
    FShowExtraButton: Boolean;
    FStyle: TSCScrollbarStyle;
    FKeyboardSpeed: Integer;
    FFlashOn: Boolean;
    FFlashTimer: Integer;
    FOnScroll: TSCScrollEvent;
    procedure SetFlashColor(Value: TColor);
    procedure SetFlashOnFocus(Value: Boolean);
    procedure SetBackColors(Value: TSCScrollbarColors);
    procedure SetButtonColors(Value: TSCScrollbarColors);
    procedure SetButtonIconColors(Value: TSCScrollbarColors);
    procedure SetButtonLayout(Value: TSCScrollButtonLayout);
    procedure SetButtonSize(Value: Integer);
    procedure SetLargeChange(Value: TSCScrollBarInc);
    procedure SetMax(Value: Integer);
    procedure SetMin(Value: Integer);
    procedure SetKind(Value: TSCScrollbarKind);
    procedure SetPageSize(Value: Integer);
    procedure SetShowButtons(Value: Boolean);
    procedure SetShowExtraButton(Value: Boolean);
    procedure SetShowSlideLine(Value: Boolean);
    procedure SetShowThumb(Value: Boolean);
    procedure SetSmallChange(Value: TSCScrollBarInc);
    procedure SetSensitivity(Value: Integer);
    procedure SetStyle(Value: TSCScrollbarStyle);
    procedure SetThumbColors(Value: TSCScrollbarColors);
    procedure SetThumbLines(Value: TSCScrollThumbline);
    procedure SetThumbSize(Value: Integer);
    procedure SetTrimPageSize(Value: Boolean);

    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;

    procedure StartFlash;
    procedure StopFlash;

    procedure StartScrolling;
    procedure ScrollControl;
    procedure StopScrolling;
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure DoSettingsChanged; dynamic;

    function  NormalizePosition(Value: Integer): Integer;
    function  GetPosition: Integer; virtual;
    procedure SetPosition(Value: Integer); virtual;

    function  CanSetValue(var Value: Integer): Boolean; dynamic;

    function  GetBlendValue: Word; override;
    function  GetBorderExColor: TColor; override;

    function  GetMaximumValue: Integer;
    procedure StopTracking; override;
    procedure MouseInControlChanged; override;
    procedure FocusChanged; override;
    procedure EnabledChanged; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure ProcessScrollKey(var Key: Word; IsKeyPress: Boolean);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    function  GetBackColor: TColor;
    function  GetExtraBtnColor: TColor;
    function  GetExtraBtnIconColor: TColor;
    function  GetLeftBtnColor: TColor;
    function  GetLeftBtnIconColor: TColor;
    function  GetRightBtnColor: TColor;
    function  GetRightBtnIconColor: TColor;
    function  GetThumbColor: TColor;

    procedure DoDrawXPFace(C: TCanvas; R: TRect; Cl, BkCl: TColor; IsThumb,
      IsDown, IsHot: Boolean); virtual;

    procedure DoDrawBack(C: TCanvas; R: TRect); virtual;
    procedure DoDrawScrollBack(C: TCanvas; R: TRect); virtual;
    procedure DoDrawExtraButton(C: TCanvas; R: TRect); virtual;
    procedure DoDrawLeftButton(C: TCanvas; R: TRect); virtual;
    procedure DoDrawRightButton(C: TCanvas; R: TRect); virtual;
    procedure DoDrawThumb(C: TCanvas; R: TRect); virtual;
    procedure DoDrawThumbLine(C: TCanvas; R: TRect; Cl: TColor); virtual;
    procedure DoDrawBorder(C: TCanvas; R: TRect); virtual;
    procedure DoDrawOffice12Border(C: TCanvas; R: TRect);

    procedure RearrangeDefaults;
    function  GetButtonSize: Integer;
    function  GetThumbOffset: Integer;
    function  GetThumbSize: Integer;
    function  GetDefaultThumbSize(Pg: Integer): Integer;
    function  GetPositionPos(P: Integer): Integer;

    function  GetBackRectFrom(R: TRect): TRect; dynamic;
    function  GetBackRect: TRect; dynamic;
    function  GetExtraButtonRect: TRect; dynamic;
    function  GetLeftButtonRect: TRect; dynamic;
    function  GetRightButtonRect: TRect; dynamic;
    function  GetThumbRect: TRect; dynamic;

    property FlashColor: TColor read FFlashColor write SetFlashColor default SC_FlashColor;
    property FlashOnFocus: Boolean read FFlashOnFocus write SetFlashOnFocus default False;
    property BackColors: TSCScrollbarColors read FBackColors write SetBackColors;
    property ButtonColors: TSCScrollbarColors read FButtonColors write SetButtonColors;
    property ButtonIconColors: TSCScrollbarColors read FButtonIconColors write SetButtonIconColors;
    property ButtonLayout: TSCScrollButtonLayout read FButtonLayout write SetButtonLayout default scsbDefault;
    property ButtonSize: Integer read FButtonSize write SetButtonSize default -1;
    property ClickFocus default False;
    property LargeChange: TSCScrollBarInc read FLargeChange write SetLargeChange default 1;
    property Max: Integer read FMax write SetMax default 100;
    property Min: Integer read FMin write SetMin default 0;
    property Kind: TSCScrollbarKind read FKind write SetKind default scskHorizontal;
    property PageSize: Integer read FPageSize write SetPageSize default 0;
    property Position: Integer read GetPosition write SetPosition default 0;
    property Sensitivity: Integer read FSensitivity write SetSensitivity default -1;
    property ShowButtons: Boolean read FShowButtons write SetShowButtons default True;
    property ShowExtraButton: Boolean read FShowExtraButton write SetShowExtraButton default False;
    property ShowSlideLine: Boolean read FShowSlideLine write SetShowSlideLine default False;
    property ShowThumb: Boolean read FShowThumb write SetShowThumb default True;
    property SmallChange: TSCScrollBarInc read FSmallChange write SetSmallChange default 1;
    property Style: TSCScrollbarStyle read FStyle write SetStyle default scssDefault;
    property ThumbColors: TSCScrollbarColors read FThumbColors write SetThumbColors;
    property ThumbLines: TSCScrollThumbline read FThumbLines write SetThumbLines default sctlNone;
    property ThumbSize: Integer read FThumbSize write SetThumbSize default -1;
    property Tracking: Boolean read FTracking write FTracking default True;
    property TrimPageSize: Boolean read FTrimPageSize write SetTrimPageSize default True;
    property OnScroll: TSCScrollEvent read FOnScroll write FOnScroll;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  CanScroll(AsLeft: Boolean): Boolean;
    function  Scrolling: Boolean;
    function  ScrollPaused: Boolean;
    procedure PauseScrolling;
    procedure ResumeScrolling;

    function  GetPartAtPos(X, Y: Integer): TSCScrollerHitPart;
    function  GetDistanceIncrement(Dist: Integer): Integer;
    function  GetPositionAtPos(X, Y: Integer; IncParts: Boolean): Integer;
  end;

  TSCScrollbar = class(TSCCustomScrollbar)
  published
    property FlashColor;
    property FlashOnFocus;
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
    property Position;
    property Sensitivity;
    property ShowButtons;
    property ShowExtraButton;
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
    property OnScroll;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

const
  SC_BAR_SCROLLTIMERID = 93210;
  SC_BAR_FlashTIMERID  = 93211;

{ TSCCustomScrollbar }

constructor TSCCustomScrollbar.Create(AOwner: TComponent);
begin
  FScrolling   := False;
  FScrollTimer := -1;

  inherited Create(AOwner);
  SetBounds(Left, Top, 160, 18);
  DoubleBuffered := True;
  ClickFocus := False;

  FDownPoint := Point(-1, -1);
  FMovePoint := Point(-1, -1);

  FPressedPart := scspNone;
  FHotPart := scspNone;

  FFlashColor := SC_FlashColor;
  FFlashOnFocus := False;
  FFlashOn := False;
  FFlashTimer := -1;
  FButtonLayout := scsbDefault;
  FButtonSize := -1;
  FLargeChange := 1;
  FMax := 100;
  FMin := 0;
  FKind := scskHorizontal;
  FSensitivity := -1;
  FShowButtons := True;
  FShowThumb := True;
  FSmallChange := 1;
  FStyle := scssDefault;
  FThumbSize := -1;
  FThumbLines := sctlNone;
  FTracking := True;
  FTrimPageSize := True;

  FBackColors := TSCScrollbarBkColors.Create(Self);
  FButtonColors := TSCScrollbarColors.Create(Self);
  FButtonIconColors := TSCScrollbarIconColors.Create(Self);
  FThumbColors := TSCScrollbarColors.Create(Self);

  RearrangeDefaults;
end;

destructor TSCCustomScrollbar.Destroy;
begin
  StopFlash;
  StopScrolling;
  FreeAndNil(FBackColors);
  FreeAndNil(FButtonColors);
  FreeAndNil(FButtonIconColors);
  FreeAndNil(FThumbColors);
  inherited Destroy;
end;

procedure TSCCustomScrollbar.DoSettingsChanged;
begin
  Invalidate;
end;

procedure TSCCustomScrollbar.DoDrawOffice12Border(C: TCanvas; R: TRect);
var
  Cl: TColor;
begin
  if (FStyle = scssOffice12) and (C <> nil) and not IsRectEmpty(R) then
  begin
    Cl := FBackColors.DefaultColor;
    if Cl = clNone then
      Cl := clScrollBar;

    Cl := SCCommon.scBlendColor(Cl, 12);

    with C do
    begin
      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Color := Cl;
      Pen.Width := 1;
    end;

    if FKind = scskHorizontal then
    begin
      C.MoveTo(R.Left, R.Top);
      C.LineTo(R.Right, R.Top);

      C.MoveTo(R.Left, R.Bottom - 1);
      C.LineTo(R.Right, R.Bottom - 1);
    end else
    begin
      C.MoveTo(R.Left, R.Top);
      C.LineTo(R.Left, R.Bottom);

      C.MoveTo(R.Right - 1, R.Top);
      C.LineTo(R.Right - 1, R.Bottom);
    end;
  end;
end;

function TSCCustomScrollbar.GetBackRect: TRect;
begin
  Result := GetBackRectFrom(GetClientRect);
end;

function TSCCustomScrollbar.GetButtonSize: Integer;
var
  R: TRect;
  Ms: Integer;
begin
  Result := FButtonSize;
  if Result = -1 then
  begin
    if FKind = scskHorizontal then
      Result := FDefV_ButtonSize
    else
      Result := FDefH_ButtonSize;
  end;

  if Result > 0 then
  begin
    R := GetClientRect;
    if FKind = scskHorizontal then
      Ms := (R.Right - R.Left) div 2
    else
      Ms := (R.Bottom - R.Top) div 2;

    if Ms < 0 then
      Ms := 0;

    if Result > Ms then
      Result := Ms;
  end else
  if Result < 0 then
    Result := 0;
end;

function TSCCustomScrollbar.GetLeftButtonRect: TRect;
var
  Bs: Integer;
begin
  if not FShowButtons or (FButtonSize = 0) then
  begin
    Result := Rect(0, 0, 0, 0);
    Exit;
  end;

  Result := GetClientRect;
  Bs := GetButtonSize;

  if FKind = scskHorizontal then
  begin
    if (FButtonLayout in [scsbDefault, scsbLeftTop]) or FShowExtraButton then
      Result.Right := Result.Left + Bs
    else begin
      Dec(Result.Right, Bs);
      Result.Left := Result.Right - Bs;
    end;
  end else
  begin
    if (FButtonLayout in [scsbDefault, scsbLeftTop]) or FShowExtraButton then
      Result.Bottom := Result.Top + Bs
    else begin
      Dec(Result.Bottom, Bs);
      Result.Top := Result.Bottom - Bs;
    end;
  end;
end;

function TSCCustomScrollbar.GetRightButtonRect: TRect;
var
  Bs: Integer;
begin
  if not FShowButtons or (FButtonSize = 0) then
  begin
    Result := Rect(0, 0, 0, 0);
    Exit;
  end;

  Result := GetClientRect;
  Bs := GetButtonSize;

  if FKind = scskHorizontal then
  begin
    if FButtonLayout in [scsbDefault, scsbRightBottom] then
      Result.Left := Result.Right - Bs
    else begin
      Inc(Result.Left, Bs);
      Result.Right := Result.Left + Bs;
    end;
  end else
  begin
    if FButtonLayout in [scsbDefault, scsbRightBottom] then
      Result.Top := Result.Bottom - Bs
    else begin
      Inc(Result.Top, Bs);
      Result.Bottom := Result.Top + Bs;
    end;
  end;
end;

function TSCCustomScrollbar.GetThumbRect: TRect;
var
  R1, R2: TRect;
  W, P, S, Ts, Mx: Integer;
  ThumbMoving: Boolean;
begin
  Result := Rect(0, 0, 0, 0);
  if not (Enabled and FShowThumb) then
    Exit;

  R1 := GetBackRect;
  if IsRectEmpty(R1) then
    Exit;

  Mx := GetMaximumValue;

  S := Mx - FMin;
  if S <= 0 then Exit;

  Ts := GetThumbSize;
  P  := NormalizePosition(Position) - FMin;

  ThumbMoving := Enabled and FShowThumb and FMovingThumb and
    (FThumbSize <> 0) and (FPressedPart = scspThumb) and
    (FDownPoint.x > -1) and (FDownPoint.y > -1) and (FMin < Mx);

  if ThumbMoving then
    P := FDownPosition - FMin;

  R2 := R1;
  if FKind = scskHorizontal then
  begin
    OffsetRect(R2, -R2.Left, 0);

    if Ts < R2.Right then
    begin
      W := R2.Right - Ts;
      R2.Right := Ts;

      P := Muldiv(W, P, S);

      if ThumbMoving then
        Inc(P, FMovePoint.x - FDownPoint.x);

      OffsetRect(R2, P, 0);
    end;

    OffsetRect(R2, R1.Left, 0);
    if R2.Right > R1.Right then
      OffsetRect(R2, R1.Right - R2.Right, 0);
    if R2.Left < R1.Left then
      OffsetRect(R2, R1.Left - R2.Left, 0);
  end else
  begin
    OffsetRect(R2, 0, -R2.Top);

    if Ts < R2.Bottom then
    begin
      W := R2.Bottom - Ts;
      R2.Bottom := Ts;

      P := Muldiv(W, P, S);

      if ThumbMoving then
        Inc(P, FMovePoint.y - FDownPoint.y);

      OffsetRect(R2, 0, P);
    end;

    OffsetRect(R2, 0, R1.Top);
    if R2.Bottom > R1.Bottom then
      OffsetRect(R2, 0, R1.Bottom - R2.Bottom);
    if R2.Top < R1.Top then
      OffsetRect(R2, 0, R1.Top - R2.Top);
  end;

  Result := R2;
  IntersectRect(Result, Result, R1);
end;

procedure TSCCustomScrollbar.Paint;
var
  R: TRect;
begin
  R := GetBackRect;
  DoDrawScrollBack(Canvas, R);

  R := GetClientRect;
  DoDrawBorder(Canvas, R);

  R := GetThumbRect;
  DoDrawThumb(Canvas, R);

  R := GetLeftButtonRect;
  DoDrawLeftButton(Canvas, R);

  R := GetRightButtonRect;
  DoDrawRightButton(Canvas, R);

  if FShowExtraButton then
  begin
    R := GetExtraButtonRect;
    DoDrawExtraButton(Canvas, R);
  end;
end;

procedure TSCCustomScrollbar.SetBackColors(Value: TSCScrollbarColors);
begin
  FBackColors.Assign(Value);
end;

procedure TSCCustomScrollbar.SetButtonColors(Value: TSCScrollbarColors);
begin
  FButtonColors.Assign(Value);
end;

procedure TSCCustomScrollbar.SetButtonLayout(Value: TSCScrollButtonLayout);
begin
  if FButtonLayout <> Value then
  begin
    FButtonLayout := Value;
    DoSettingsChanged;
  end;
end;

procedure TSCCustomScrollbar.SetButtonSize(Value: Integer);
begin
  if Value < -1 then
    Value := -1
  else
  if (Value > 0) and (Value < 12) then
    Value := 12;

  if FButtonSize <> Value then
  begin
    FButtonSize := Value;
    if FShowButtons then
      DoSettingsChanged;
  end;
end;

procedure TSCCustomScrollbar.SetMax(Value: Integer);
var
  Mx: Integer;
begin
  if FMax <> Value then
  begin
    StopScrolling;

    FMax := Value;
    if FMin > FMax then FMin := Value;

    Mx := GetMaximumValue;
    if FPosition > Mx then
      FPosition := Mx;

    Change;
    DoSettingsChanged;
  end;
end;

procedure TSCCustomScrollbar.SetMin(Value: Integer);
begin
  if FMin <> Value then
  begin
    StopScrolling;

    FMin := Value;
    if FMax < FMin then FMax := FMin;

    if FPosition < FMin then
      FPosition := FMin;

    Change;
    DoSettingsChanged;
  end;
end;

procedure TSCCustomScrollbar.SetKind(Value: TSCScrollbarKind);
var
  H: Integer;
  R: TRect;
begin
  if FKind <> Value then
  begin
    FKind := Value;

    if HandleAllocated and not (IsLoading or IsReading) then
    begin
      R := BoundsRect;

      Dec(R.Right, R.Left);
      Dec(R.Bottom, R.Top);

      H := R.Bottom;
      R.Bottom := R.Right;
      R.Right := H;

      SetBounds(R.Left, R.Top, R.Right, R.Bottom);
    end;

    DoSettingsChanged;
  end;
end;

procedure TSCCustomScrollbar.SetPosition(Value: Integer);
var
  Mx: Integer;
  CanScroll: Boolean;
begin
  if not CanSetValue(Value) then
    Exit;

  Mx := GetMaximumValue;
  
  if Value > Mx then Value := Mx;
  if Value < FMin then Value := FMin;

  CanScroll := True;
  if (FPosition <> Value) and Assigned(FOnScroll) then
  begin
    FOnScroll(Self, FKind, FPosition, Value, CanScroll);

    if CanScroll then
    begin
      Mx := GetMaximumValue;

      if Value > Mx then Value := Mx;
      if Value < FMin then Value := FMin;
    end;
  end;

  if CanScroll and (FPosition <> Value) then
  begin
    FPosition := Value;

    Change;
    DoSettingsChanged;
  end;
end;

procedure TSCCustomScrollbar.SetShowButtons(Value: Boolean);
begin
  if FShowButtons <> Value then
  begin
    FShowButtons := Value;
    if FButtonSize <> 0 then
      DoSettingsChanged;
  end;
end;

procedure TSCCustomScrollbar.SetThumbColors(Value: TSCScrollbarColors);
begin
  FThumbColors.Assign(Value);
end;

procedure TSCCustomScrollbar.SetLargeChange(Value: TSCScrollBarInc);
begin
  FLargeChange := Value;
  DoSettingsChanged;
end;

procedure TSCCustomScrollbar.SetPageSize(Value: Integer);
begin
  if FPageSize <> Value then
  begin
    FPageSize := Value;
    DoSettingsChanged;
  end;
end;

procedure TSCCustomScrollbar.SetSmallChange(Value: TSCScrollBarInc);
begin
  FSmallChange := Value;
  DoSettingsChanged;
end;

procedure TSCCustomScrollbar.RearrangeDefaults;
begin
  FDefH_ButtonSize := GetSystemMetrics(SM_CYVTHUMB);
  FDefV_ButtonSize := GetSystemMetrics(SM_CXHTHUMB);
end;

procedure TSCCustomScrollbar.SetThumbSize(Value: Integer);
begin
  if Value < -1 then
    Value := -1;

  if FThumbSize <> Value then
  begin
    FThumbSize := Value;
    DoSettingsChanged;
  end;
end;

function TSCCustomScrollbar.GetThumbSize: Integer;
begin
  Result := 0;
  if not (Enabled and FShowThumb) then
    Exit;

  Result := FThumbSize;
  if Result = -1 then
    Result := GetDefaultThumbSize(PageSize);

  if Result < 0 then
    Result := 0;
end;

function TSCCustomScrollbar.GetPartAtPos(X, Y: Integer): TSCScrollerHitPart;
var
  P: TPoint;
  CR, R: TRect;
  ThumbEmpty: Boolean;
begin
  Result := scspNone;

  P := Point(X, Y);

  CR := GetClientRect;
  if PtInRect(CR, P) then
  begin
    if FShowButtons and (FButtonSize <> 0) then
    begin
      R := GetLeftButtonRect;
      if PtInRect(R, P) then
      begin
        Result := scspLeftButton;
        Exit;
      end;

      R := GetRightButtonRect;
      if PtInRect(R, P) then
      begin
        Result := scspRightButton;
        Exit;
      end;

      if FShowExtraButton then
      begin
        R := GetExtraButtonRect;
        
        if PtInRect(R, P) then
        begin
          Result := scspExtraButton;
          Exit;
        end;
      end;
    end;

    ThumbEmpty := not (Enabled and FShowThumb and (FThumbSize <> 0));

    R := Rect(0, 0, 0, 0);
    if not ThumbEmpty then
    begin
      R := GetThumbRect;
      ThumbEmpty := IsRectEmpty(R);
    end;

    if ThumbEmpty then
    begin
      R := GetBackRect;

      if FKind = scskHorizontal then
      begin
        R.Right := R.Left + ((R.Right - R.Left) div 2);
        R.Left  := R.Right;
      end else
      begin
        R.Bottom := R.Top + ((R.Bottom - R.Top) div 2);
        R.Top    := R.Bottom;
      end;
    end;

    if not ThumbEmpty and PtInRect(R, P) then
    begin
      Result := scspThumb;
      Exit;
    end;

    if FKind = scskHorizontal then
    begin
      if X < R.Left then
        Result := scspLeftSpare
      else
      if X >= R.Right then
        Result := scspRightSpare;
    end else
    begin
      if Y < R.Top then
        Result := scspLeftSpare
      else
      if Y >= R.Bottom then
        Result := scspRightSpare;
    end;
  end;
end;

procedure TSCCustomScrollbar.DoDrawBack(C: TCanvas; R: TRect);
var
  R1: TRect;
  Cl, C1: TColor;
begin
  if (C = nil) or IsRectEmpty(R) then Exit;

  Cl := GetBackColor;
  if FStyle = scssOffice12 then
  begin
    Cl := FBackColors.DefaultColor;
    if Cl = clNone then
      Cl := clScrollBar;

    Cl := SCCommon.scBlendColor(Cl, 12);
  end;

  with C do
  begin
    Brush.Color := Cl;
    FillRect(R);
  end;

  if FStyle = scssOffice12 then
  begin
    C1 := SCCommon.scBlendColor(Cl, 36);

    if FKind = scskHorizontal then
    begin
      R1 := R;
      R1.Bottom := R1.Top + ((R1.Bottom - R1.Top) div 5);

      if not IsRectEmpty(R1) then
        scDrawGradient(C, R1, scgTopToBottom, C1, Cl);

      R1 := R;
      R1.Top := R1.Bottom - ((R1.Bottom - R1.Top) div 5);

      if not IsRectEmpty(R1) then
        scDrawGradient(C, R1, scgTopToBottom, Cl, C1);
    end else
    begin
      R1 := R;
      R1.Right := R1.Left + ((R1.Right - R1.Left) div 5);

      if not IsRectEmpty(R1) then
        scDrawGradient(C, R1, scgLeftToRight, C1, Cl);

      R1 := R;
      R1.Left := R1.Right - ((R1.Right - R1.Left) div 5);

      if not IsRectEmpty(R1) then
        scDrawGradient(C, R1, scgLeftToRight, Cl, C1);
    end;
  end;
end;

procedure TSCCustomScrollbar.DoDrawScrollBack(C: TCanvas; R: TRect);
var
  Cl, C1: TColor;
  BR, R1, R2: TRect;
begin
  if (C = nil) or IsRectEmpty(R) then Exit;

  DoDrawBack(C, R);

  Cl := GetBackColor;
  BR := GetBackRectFrom(R);

  if FStyle = scssSports then
  begin
    R1 := BR;

    if not IsRectEmpty(R1) then
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R1);

        scFrame3D(C, R1, Get3DDkShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0);
      end;
  end else
  if (FHotPart = FPressedPart) and (FPressedPart in [scspLeftSpare, scspRightSpare]) then
  begin
    R2 := GetThumbRect;
    R1 := R;

    if not IsRectEmpty(R2) then
    begin
      if FKind = scskHorizontal then
      begin
        if FPressedPart = scspLeftSpare then
        begin
          if R2.Left >= R.Left then
            R1.Right := R2.Left;
        end else
        if R2.Right <= R.Right then
          R1.Left := R2.Right;
      end else
      begin
        if FPressedPart = scspLeftSpare then
        begin
          if R2.Top >= R.Top then
            R1.Bottom := R2.Top;
        end else
        if R2.Bottom <= R.Bottom then
          R1.Top := R2.Bottom;
      end;
    end;

    if FStyle <> scssMetal then
    begin
      Cl := FBackColors.GetDownColor;
      if FStyle = scssOffice2k then
        Cl := GetOfficeXPDownedSelColor;

      with C do
      begin
        Brush.Color := Cl;
        FillRect(R1);
      end;

      if FStyle = scssOffice12 then
      begin
        C1 := SCCommon.scBlendColor(Cl, 36);

        if FKind = scskHorizontal then
        begin
          R2 := R1;
          R2.Bottom := R2.Top + ((R2.Bottom - R2.Top) div 5);

          if not IsRectEmpty(R2) then
            scDrawGradient(C, R2, scgTopToBottom, C1, Cl);

          R2 := R1;
          R2.Top := R2.Bottom - ((R2.Bottom - R2.Top) div 5);

          if not IsRectEmpty(R2) then
            scDrawGradient(C, R2, scgTopToBottom, Cl, C1);
        end else
        begin
          R2 := R1;
          R2.Right := R2.Left + ((R2.Right - R2.Left) div 5);

          if not IsRectEmpty(R2) then
            scDrawGradient(C, R2, scgLeftToRight, C1, Cl);

          R2 := R1;
          R2.Left := R2.Right - ((R2.Right - R2.Left) div 5);

          if not IsRectEmpty(R2) then
            scDrawGradient(C, R2, scgLeftToRight, Cl, C1);
        end;
      end;
    end;  
  end;

  if FShowSlideLine then
  begin
    R1 := BR;

    if FKind = scskHorizontal then
    begin
      InflateRect(R1, -4, 0);

      if R1.Bottom - R1.Top > 3 then
      begin
        R1.Top := R1.Top + ((R1.Bottom - R1.Top) div 2);
        R1.Bottom := R1.Top + 1;

        if not IsRectEmpty(R1) then
          with C do
          begin
            Pen.Style := psSolid;

            Pen.Color := GetBtnShadowOf(Cl);
            MoveTo(R1.Left, R1.Top);
            LineTo(R1.Right, R1.Top);

            Pen.Color := GetBtnHighlightOf(Cl);
            MoveTo(R1.Left, R1.Bottom);
            LineTo(R1.Right, R1.Bottom);
          end;
      end;
    end else
    begin
      InflateRect(R1, 0, -4);

      if R1.Right - R1.Left > 3 then
      begin
        R1.Left := R1.Left + ((R1.Right - R1.Left) div 2);
        R1.Right := R1.Left + 1;

        if not IsRectEmpty(R1) then
          with C do
          begin
            Pen.Style := psSolid;

            Pen.Color := GetBtnShadowOf(Cl);
            MoveTo(R1.Left, R1.Top);
            LineTo(R1.Left, R1.Bottom);

            Pen.Color := GetBtnHighlightOf(Cl);
            MoveTo(R1.Right, R1.Top);
            LineTo(R1.Right, R1.Bottom);
          end;
      end;
    end;
  end;
end;

procedure TSCCustomScrollbar.DoDrawLeftButton(C: TCanvas; R: TRect);
var
  W, H, I: Integer;
  OffP, P: TPoint;
  C1, C2, C3, C4: TColor;

  procedure DrawButtonIcon;
  begin
    OffP := Point(0, 0);
    if (FPressedPart = scspLeftButton) and (FPressedPart = FHotPart) and
      not (FStyle in [scssOffice2k, scssXP, scssXP2, scssFlatEx]) then
    begin
      OffP := Point(1, 1);

      if FStyle = scssMac then
      begin
        if FKind = scskHorizontal then
          OffP := Point(-1, 0)
        else
          OffP := Point(0, -1);
      end;
    end;

    if C2 <> C1 then
    begin
      W := 6; H := 3;

      I := R.Right - R.Left;
      if I > R.Bottom - R.Top then
        I := R.Bottom - R.Top;

      if I < 16 then
      begin
        W := 4; H := 2;
        if I < 12 then
        begin
          W := 2; H := 1;
        end;
      end;

      if FKind = scskHorizontal then
      begin
        P.x := R.Left + ((R.Right - R.Left) div 2) - 2 + OffP.x;
        P.y := R.Top +  ((R.Bottom - R.Top) div 2) + OffP.y;

        scDrawRightSlider(C, P, W, H, sctsMac, False, C2, C2);
      end else
      begin
        P.x := R.Left + ((R.Right - R.Left) div 2) + OffP.x;
        P.y := R.Top +  ((R.Bottom - R.Top) div 2) - 2 + OffP.y;

        scDrawDownSlider(C, P, W, H, sctsMac, False, C2, C2);
      end;
    end;
  end;

begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  C1 := GetLeftBtnColor;
  C2 := GetLeftBtnIconColor;

  with C do
  begin
    Brush.Color := C1;
    FillRect(R);
  end;

  DrawButtonIcon;
  
  case FStyle of
    scssDefault, scssDefaultEx:
    begin
      if (FHotPart = FPressedPart) and
        (FPressedPart = scspLeftButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssFlat:
    begin
      if (FHotPart = FPressedPart) and
        (FPressedPart = scspLeftButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssFlatEx:
    begin
      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssFlatHover:
    begin
      if (FHotPart = FPressedPart) and
        (FPressedPart = scspLeftButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      if HasFocus or MouseInControl then
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssMetal:
    begin
      InflateRect(R, -1, -1);

      if (FHotPart = FPressedPart) and
        (FPressedPart = scspLeftButton) then
      begin
        C3 := C1;
        C4 := SCCommon.scBlendColor(C1, 64);
      end else
      begin
        C3 := SCCommon.scBlendColor(C1, 64);
        C4 := C1;
      end;

      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C3, C4, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssOffice2k:
    begin
      C3 := clHighlight;
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssOffice12:
    begin
      DoDrawBack(C, R);
      DoDrawOffice12Border(C, R);
      
      if FHotPart <> scspNone then
        scDrawOffice12Face(Kind, C, R, C1, GetBackColor, True,
          FPressedPart = scspLeftButton, FHotPart = scspLeftButton,
          True, False);

      DrawButtonIcon;
    end;
    scss3D, scss3DX:
    begin
      scDraw3DFace(Kind, C, R, C1, GetBackColor, FStyle = scss3DX,
        FPressedPart = scspLeftButton, FHotPart = scspLeftButton);

      DrawButtonIcon;
    end;
    scssNew, scssNewX:
    begin
      scDrawNewFace(Kind, C, R, C1, GetBackColor, FStyle = scssNewX,
        FPressedPart = scspLeftButton, FHotPart = scspLeftButton);

      DrawButtonIcon;
    end;
    scssXP, scssXP2:
    begin
      DoDrawXPFace(C, R, C1, GetBackColor, False, FPressedPart = scspLeftButton,
        FHotPart = scspLeftButton);

      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C2;

        W := 4;

        I := R.Right - R.Left;
        if I > R.Bottom - R.Top then
          I := R.Bottom - R.Top;

        if I < 14 then
        begin
          W := 3;
          if I < 8 then
            W := 2;
        end;

        if FKind = scskHorizontal then
        begin
          Dec(P.x);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x + (W - 1), P.y - (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y + W);

            Inc(P.x);
          end;
        end else
        begin
          Dec(P.y);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x - (W - 1), P.y + (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y + W);

            Inc(P.y);
          end;
        end;
      end;
    end;
    scssMac:
    begin
      if (FHotPart = FPressedPart) and
        (FPressedPart = scspLeftButton) then
      begin
        C2 := SCCommon.scBlendColor(C1, -48);
        C3 := SCCommon.scBlendColor(C1, 48);
      end else
      begin
        C2 := SCCommon.scBlendColor(C1, 48);
        C3 := SCCommon.scBlendColor(C1, -48);
      end;

      InflateRect(R, -1, -1);
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C2, C3, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := Get3DDkShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
  end;
end;

procedure TSCCustomScrollbar.DoDrawRightButton(C: TCanvas; R: TRect);
var
  W, H, I: Integer;
  OffP, P: TPoint;
  C1, C2, C3, C4: TColor;

  procedure DrawButtonIcon;
  begin
    OffP := Point(0, 0);
    if (FPressedPart = scspRightButton) and (FPressedPart = FHotPart) and
      not (FStyle in [scssOffice2k, scssXP, scssXP2, scssFlatEx]) then
    begin
      OffP := Point(1, 1);

      if FStyle = scssMac then
      begin
        if FKind = scskHorizontal then
          OffP := Point(1, 0)
        else
          OffP := Point(0, 1);
      end;
    end;

    if C2 <> C1 then
    begin
      W := 6; H := 3;

      I := R.Right - R.Left;
      if I > R.Bottom - R.Top then
        I := R.Bottom - R.Top;

      if I < 16 then
      begin
        W := 4; H := 2;
        if I < 12 then
        begin
          W := 2; H := 1;
        end;
      end;

      if FKind = scskHorizontal then
      begin
        P.x := R.Left + ((R.Right - R.Left) div 2) + 1 + OffP.X;
        P.y := R.Top +  ((R.Bottom - R.Top) div 2) + OffP.y;

        scDrawLeftSlider(C, P, W, H, sctsMac, False, C2, C2);
      end else
      begin
        P.x := R.Left + ((R.Right - R.Left) div 2) + OffP.x;
        P.y := R.Top +  ((R.Bottom - R.Top) div 2) + 1 + OffP.y;

        scDrawUpSlider(C, P, W, H, sctsMac, False, C2, C2);
      end;
    end;
  end;

begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  C1 := GetRightBtnColor;
  C2 := GetRightBtnIconColor;

  with C do
  begin
    Brush.Color := C1;
    FillRect(R);
  end;

  DrawButtonIcon;

  case FStyle of
    scssDefault, scssDefaultEx:
    begin
      if (FHotPart = FPressedPart) and
        (FPressedPart = scspRightButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssFlat:
    begin
      if (FHotPart = FPressedPart) and
        (FPressedPart = scspRightButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssFlatEx:
    begin
      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssFlatHover:
    begin
      if (FHotPart = FPressedPart) and
        (FPressedPart = scspRightButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      if HasFocus or MouseInControl then
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssMetal:
    begin
      InflateRect(R, -1, -1);

      if (FHotPart = FPressedPart) and
        (FPressedPart = scspRightButton) then
      begin
        C3 := C1;
        C4 := SCCommon.scBlendColor(C1, 64);
      end else
      begin
        C3 := SCCommon.scBlendColor(C1, 64);
        C4 := C1;
      end;

      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C3, C4, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssOffice2k:
    begin
      C3 := clHighlight;
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssOffice12:
    begin
      DoDrawBack(C, R);
      DoDrawOffice12Border(C, R);
      
      if FHotPart <> scspNone then
        scDrawOffice12Face(Kind, C, R, C1, GetBackColor, True,
          FPressedPart = scspRightButton, FHotPart = scspRightButton,
          True, False);

      DrawButtonIcon;
    end;
    scss3D, scss3DX:
    begin
      scDraw3DFace(Kind, C, R, C1, GetBackColor, FStyle = scss3DX,
        FPressedPart = scspRightButton, FHotPart = scspRightButton);

      DrawButtonIcon;
    end;
    scssNew, scssNewX:
    begin
      scDrawNewFace(Kind, C, R, C1, GetBackColor, FStyle = scssNewX,
        FPressedPart = scspRightButton, FHotPart = scspRightButton);

      DrawButtonIcon;
    end;
    scssXP, scssXP2:
    begin
      DoDrawXPFace(C, R, C1, GetBackColor, False, FPressedPart = scspRightButton,
        FHotPart = scspRightButton);

      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C2;

        W := 4;

        I := R.Right - R.Left;
        if I > R.Bottom - R.Top then
          I := R.Bottom - R.Top;

        if I < 14 then
        begin
          W := 3;
          if I < 8 then
            W := 2;
        end;

        if FKind = scskHorizontal then
        begin
          Dec(P.x);

          for I := 0 to W - 2 do
          begin
            MoveTo(P.x - (W - 1), P.y - (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x - W, P.y + W);

            Inc(P.x);
          end;
        end else
        begin
          Dec(P.y);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x - (W - 1), P.y - (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y - W);

            Inc(P.y);
          end;
        end;
      end;
    end;
    scssMac:
    begin
      if (FHotPart = FPressedPart) and
        (FPressedPart = scspRightButton) then
      begin
        C2 := SCCommon.scBlendColor(C1, -48);
        C3 := SCCommon.scBlendColor(C1, 48);
      end else
      begin
        C2 := SCCommon.scBlendColor(C1, 48);
        C3 := SCCommon.scBlendColor(C1, -48);
      end;

      InflateRect(R, -1, -1);
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C2, C3, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := Get3DDkShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
  end;
end;

procedure TSCCustomScrollbar.DoDrawThumb(C: TCanvas; R: TRect);
var
  R1: TRect;
  C1, C2, C3, Cl: TColor;
  I, J, K, L, X, Y, SR: Integer;
begin
  if not (Enabled and FShowThumb) or (C = nil) or IsRectEmpty(R) then
    Exit;

  C1 := GetThumbColor;

  with C do
  begin
    R1 := R;
    if FStyle = scssSports then
      InflateRect(R1, -1, -1);

    Brush.Color := C1;
    FillRect(R1);
  end;

  if FThumbLines <> sctlNone then
    DoDrawThumbLine(C, R, C1);

  case FStyle of
    scssDefault:
    begin
      C2 := C1;
      C3 := Get3DDkShadowOf(C1);
      scFrame3D(C, R, C2, C3, 1, 0);

      C2 := GetBtnHighlightOf(C1);
      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C2, C3, 1, 0);
    end;
    scssDefaultEx:
    begin
      if FPressedPart = scspThumb then
      begin
        C2 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C2, 1, 0);
      end else
      begin
        C2 := C1;
        C3 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C2, C3, 1, 0);

        C2 := GetBtnHighlightOf(C1);
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C3, 1, 0);
      end;
    end;
    scssFlat:
    begin
      if FPressedPart = scspThumb then
      begin
        C2 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C2, 1, 0);
      end else
      begin
        C2 := GetBtnHighlightOf(C1);
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C3, 1, 0);
      end;
    end;
    scssFlatEx:
    begin
      C2 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C2, C2, 1, 0);
    end;
    scssFlatHover:
    begin
      if FPressedPart = scspThumb then
      begin
        C2 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C2, 1, 0);
      end else
      if HasFocus or MouseInControl then
      begin
        C2 := C1;
        C3 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C2, C3, 1, 0);

        C2 := GetBtnHighlightOf(C1);
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C3, 1, 0);
      end else
      begin
        C2 := GetBtnHighlightOf(C1);
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C3, 1, 0);
      end;
    end;
    scssOffice2k:
    begin
      C2 := clHighlight;
      scFrame3D(C, R, C2, C2, 1, 0);
    end;
    scssOffice12:
    begin
      scDrawOffice12Face(Kind, C, R, C1, GetBackColor, False,
        FPressedPart = scspThumb, (FHotPart = scspThumb) or (FPressedPart = scspThumb),
        True, True);

      if FThumbLines <> sctlNone then
        DoDrawThumbLine(C, R, C1);
    end;
    scss3D, scss3DX:
    begin
      scDraw3DFace(Kind, C, R, C1, GetBackColor, FStyle = scss3DX,
        FPressedPart = scspThumb, FPressedPart = scspThumb);

      if FThumbLines <> sctlNone then
        DoDrawThumbLine(C, R, C1);
    end;
    scssSports:
    begin
      R1 := R;
      InflateRect(R1, -1, -1);

      if not IsRectEmpty(R1) then
        scFrame3D(C, R1, GetBtnHighlightOf(C1), Get3DDkShadowOf(C1), 1, 0);
    end;
    scssNew, scssNewX:
    begin
      scDrawNewFace(Kind, C, R, C1, GetBackColor, FStyle = scssNewX,
        FPressedPart = scspThumb, FPressedPart = scspThumb);

      if FThumbLines <> sctlNone then
        DoDrawThumbLine(C, R, C1);
    end;
    scssXP, scssXP2:
    begin
      DoDrawXPFace(C, R, C1, GetBackColor, True, FPressedPart = scspThumb,
        (FHotPart = scspThumb) and (FPressedPart = scspNone));

      InflateRect(R, -2, -2);
      if FKind = scskHorizontal then
      begin
        InflateRect(R, -2, 0);
        if FPressedPart = scspThumb then
          OffsetRect(R, 0, 1);
      end else
      begin
        InflateRect(R, 0, -2);
        if FPressedPart = scspThumb then
          OffsetRect(R, 1, 0);
      end;

      DoDrawThumbLine(C, R, C1);
    end;
    scssMac:
    begin
      C2 := SCCommon.scBlendColor(C1, 48);
      C3 := SCCommon.scBlendColor(C1, -48);

      InflateRect(R, -1, -1);
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C2, C3, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := Get3DDkShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssMetal:
    begin
      InflateRect(R, -3, -3);
      if not IsRectEmpty(R) then
      begin
        SR := IntersectClipRect(C.Handle, R.Left, R.Top, R.Right, R.Bottom);
        try
          if SR <> NULLREGION then
          begin
            C2 := SCCommon.scBlendColor(C1, 64);
            C3 := GetBtnShadowOf(C1);

            C.Pen.Width := 1;
            C.Pen.Style := psSolid;

            if FKind = scskHorizontal then
            begin
              K := R.Right - R.Left;
              L := (R.Bottom - R.Top) div 4;

              for I := 0 to K do
              begin
                if (I = K) and not Odd(I) then
                  Break;

                for J := 0 to L do
                begin
                  X := I;
                  Y := 4*J;

                  Cl := C2;
                  if Odd(X) then
                  begin
                    Cl := C3;
                    Inc(Y);

                    if Odd((X - 1) div 2) then
                      Inc(Y, 2);
                  end else
                  if Odd(X div 2) then
                    Inc(Y, 2);

                  C.Pen.Color := Cl;

                  Inc(X, R.Left);
                  Inc(Y, R.Top);

                  C.MoveTo(X, Y);
                  C.LineTo(X + 1, Y);
                end;
              end;  
            end else
            begin
              K := R.Bottom - R.Top;
              L := (R.Right - R.Left) div 4;

              for I := 0 to K do
              begin
                if (I = K) and not Odd(I) then
                  Break;

                for J := 0 to L do
                begin
                  X := 4*J;
                  Y := I;

                  Cl := C2;
                  if Odd(Y) then
                  begin
                    Cl := C3;
                    Inc(X);

                    if Odd((Y - 1) div 2) then
                      Inc(X, 2);
                  end else
                  if Odd(Y div 2) then
                    Inc(X, 2);

                  C.Pen.Color := Cl;

                  Inc(X, R.Left);
                  Inc(Y, R.Top);

                  C.MoveTo(X, Y);
                  C.LineTo(X + 1, Y);
                end;
              end;
            end;
          end;
        finally
          SelectClipRgn(C.Handle, 0);
        end;
      end;

      InflateRect(R, 3, 3);

      C2 := SCCommon.scBlendColor(C1, 64);
      C3 := C1;

      InflateRect(R, -1, -1);
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C2, C3, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
  end;
end;

procedure TSCCustomScrollbar.SetButtonIconColors(Value: TSCScrollbarColors);
begin
  FButtonIconColors.Assign(Value);
end;

procedure TSCCustomScrollbar.KeyDown(var Key: Word; Shift: TShiftState);
begin
  ProcessScrollKey(Key, False);
  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomScrollbar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  FMovingThumb  := True;
  FDownPoint    := Point(X, Y);
  FMovePoint    := Point(X, Y);

  FDownPosition := NormalizePosition(Position);

  inherited MouseDown(Button, Shift, X, Y);

  FHotPart := GetPartAtPos(X, Y);
  FPressedPart := scspNone;

  StopScrolling;
  
  if Button = mbLeft then
  begin
    FPressedPart := FHotPart;

    if (FPressedPart in [scspExtraButton, scspLeftButton, scspLeftSpare,
      scspRightButton, scspRightSpare]) and CanScroll(FPressedPart in
      [scspExtraButton, scspLeftButton, scspLeftSpare]) then
      StartScrolling;
  end;

  if (FHotPart <> scspNone) or (FPressedPart <> scspNone) then
    Invalidate;
end;

procedure TSCCustomScrollbar.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  R, BkR, ThR: TRect;
  OldPoint: TPoint;
  P, OldP, Mx: Integer;
  OldHot: TSCScrollerHitPart;
begin
  FMovingThumb := True;

  OldHot := FHotPart;
  FHotPart := GetPartAtPos(X, Y);

  Mx := GetMaximumValue;
  
  if FPressedPart <> scspNone then
  begin
    OldPoint := FMovePoint;
    FMovePoint := Point(X, Y);

    if FMin >= Mx then Exit;

    R := GetClientRect;

    BkR := GetBackRect;

    ThR := Rect(0, 0, 0, 0);
    if not IsRectEmpty(BkR) then
      ThR := GetThumbRect;

    if IsRectEmpty(BkR) or EqualRect(BkR, ThR) then
      Exit;

    case FPressedPart of
      scspThumb:
      begin
        OldP := NormalizePosition(Position);

        if FKind = scskHorizontal then
        begin
          P := FDownPosition + GetDistanceIncrement(FMovePoint.x - FDownPoint.x);

          if (FSensitivity > -1) and ((FMovePoint.y < R.Top - FSensitivity) or
            (FMovePoint.y > R.Bottom + FSensitivity)) then
          begin
            FMovingThumb := False;
            if FTracking then
              SetPosition(FDownPosition);

            if (OldP <> NormalizePosition(Position)) and
              (OldPoint.x <> FDownPoint.x) and (OldPoint.y <> FDownPoint.y) then
              Invalidate;

            Exit;
          end;
        end else
        begin
          P := FDownPosition + GetDistanceIncrement(FMovePoint.y - FDownPoint.y);

          if (FSensitivity > -1) and ((FMovePoint.x < R.Left - FSensitivity) or
            (FMovePoint.x > R.Right + FSensitivity)) then
          begin
            FMovingThumb := False;
            if FTracking then
              SetPosition(FDownPosition);

            if (OldP <> NormalizePosition(Position)) and
              (OldPoint.x <> FDownPoint.x) and (OldPoint.y <> FDownPoint.y) then
              Invalidate;

            Exit;
          end;
        end;

        if P < FMin then P := FMin;

        if P > Mx then P := Mx;

        if FTracking then
          SetPosition(P);

        if (NormalizePosition(Position) = OldP) and
          (((FKind = scskHorizontal) and (FMovePoint.x <> OldPoint.x)) or
           ((FKind = scskVertical) and (FMovePoint.y <> OldPoint.y))) then
          Invalidate;
      end;
      scspExtraButton, scspLeftButton,
      scspRightButton, scspLeftSpare, scspRightSpare:
      begin
        if OldHot <> FHotPart then
          Invalidate;
      end;
    end;
  end else
  begin
    FMovePoint := Point(X, Y);

    if OldHot <> FHotPart then
      Invalidate;
  end;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomScrollbar.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  P: Integer;
  OldHot, OldDown: TSCScrollerHitPart;
begin
  FMovingThumb := False;

  if FKind = scskHorizontal then
    P := FDownPosition + GetDistanceIncrement(FMovePoint.x - FDownPoint.x)
  else
    P := FDownPosition + GetDistanceIncrement(FMovePoint.y - FDownPoint.y);

  FDownPoint := Point(-1, -1);
  FMovePoint := Point(-1, -1);

  FDownPosition := 0;

  OldHot  := FHotPart;
  OldDown := FPressedPart;

  FHotPart := GetPartAtPos(X, Y);
  FPressedPart := scspNone;

  StopScrolling;
  if not Scrolling and (OldDown = scspThumb) then
    SetPosition(P);

  if (OldHot <> FHotPart) or (FPressedPart <> OldDown) then
    Invalidate;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomScrollbar.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TSCCustomScrollbar.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if Message.WheelDelta < 0 then
    SetPosition(Position + LargeChange)
  else
  if Message.WheelDelta > 0 then
    SetPosition(Position - LargeChange);
end;

procedure TSCCustomScrollbar.WMTimer(var Message: TWMTimer);
var
  P: TPoint;
  Ps, Mx: Integer;
begin
  inherited;

  if FFlashOnFocus and HandleAllocated and
    (Message.TimerID = SC_BAR_FlashTIMERID) then
  begin
    if not Enabled then
    begin
      StopFlash;
      Exit;
    end;

    FFlashOn := not FFlashOn;
    FFlashTimer := SetTimer(Handle, SC_BAR_FlashTIMERID, 500, nil);
    Invalidate;
  end;
    
  if HandleAllocated and Scrolling and
    (Message.TimerID = SC_BAR_SCROLLTIMERID) then
  begin
    if FKeyboardSpeed = 0 then
      FKeyboardSpeed := scKeyBoardSpeed;

    if FKeyboardSpeed = 0 then
      FKeyboardSpeed := 30;

    if not (Enabled and GetCursorPos(P)) then
    begin
      StopScrolling;
      Exit;
    end;

    P := Self.ScreenToClient(P);
    FHotPart := GetPartAtPos(P.x, P.y);

    Ps := NormalizePosition(Position);
    ScrollControl;

    if FScrollTimer <> -1 then
      KillTimer(Handle, FScrollTimer);

    Mx := GetMaximumValue;

    if (Ps = NormalizePosition(Position)) and (FMin < Mx) and (Ps > FMin) and
      (Ps < Mx) and (FPressedPart <> FHotPart) and
      (FPressedPart in [scspLeftSpare, scspRightSpare]) then
      Invalidate;

    FScrollTimer := SetTimer(Handle, SC_BAR_SCROLLTIMERID, FKeyboardSpeed, nil);
    FScrolling := FScrollTimer <> -1;
  end;
end;

procedure TSCCustomScrollbar.SetShowThumb(Value: Boolean);
begin
  if FShowThumb <> Value then
  begin
    FShowThumb := Value;
    if FThumbSize <> 0 then
      DoSettingsChanged;
  end;
end;

function TSCCustomScrollbar.GetDistanceIncrement(Dist: Integer): Integer;
var
  W, P, Mx: Integer;
  R1, R2: TRect;
begin
  Result := 0;

  Mx := GetMaximumValue;
  if (Dist = 0) or (FMin >= Mx) then Exit;

  R1 := GetBackRect;
  if IsRectEmpty(R1) then Exit;

  R2 := GetThumbRect;
  OffsetRect(R2, R1.Left - R2.Left, R1.Top - R2.Top);

  if EqualRect(R1, R2) then Exit;

  if FKind = scskHorizontal then
  begin
    R1.Left := R2.Right;
    W := R1.Right - R1.Left;
  end else
  begin
    R1.Top := R2.Bottom;
    W := R1.Bottom - R1.Top;
  end;

  if W <= 0 then Exit;

  P := Abs(Dist);
  if P > W then
  begin
    Result := Mx - FMin;
    if Dist < 0 then
      Result := -Result;

    Exit;
  end;

  Result := Muldiv(Mx - FMin, P, W);
  if Dist < 0 then
    Result := -Result;
end;

function TSCCustomScrollbar.GetPositionAtPos(X, Y: Integer; IncParts: Boolean): Integer;
var
  P: TPoint;
  R, R2: TRect;
  I, M, W, Mx: Integer;
begin
  Result := FMin;

  Mx := GetMaximumValue;
  if FMin >= Mx then Exit;

  Result := NormalizePosition(Position);

  R := GetBackRect;
  if IsRectEmpty(R) then Exit;

  R2 := R;
  if FKind = scskHorizontal then
    R2.Right := R2.Left
  else
    R2.Bottom := R2.Top;

  P := Point(X, Y);

  if not IncParts then
  begin
    if not PtInRect(R, P) then
      Exit;

    if FShowThumb and (FThumbSize <> 0) then
    begin
      R2 := GetThumbRect;
      if not IsRectEmpty(R2) and PtInRect(R2, P) then
        Exit;
    end;
  end;

  if FKind = scskHorizontal then
  begin
    if X <= R.Left then
    begin
      if not IncParts and (X < R.Left) then
        Exit;

      Result := FMin;
    end else
    if X >= R.Right then
    begin
      if not IncParts then
        Exit;

      Result := Mx;
    end else
    begin
      W := R.Right - R.Left;
      M := Mx - FMin;

      if M = 1 then
      begin
        R.Right := W div 2;

        if PtInRect(R, P) then
          Result := FMin
        else
          Result := Mx;

        Exit;
      end;

      Dec(X, R.Left);
      OffsetRect(R, -R.Left, 0);

      for I := 0 to M-1 do
      begin
        R.Left  := Muldiv(I, W, M);
        R.Right := Muldiv(I + 1, W, M);

        if (X >= R.Left) and (X < R.Right) then
        begin
          Result := FMin + I;
          Exit;
        end;
      end;
    end;
  end else
  begin
    if Y <= R.Top then
    begin
      if not IncParts and (Y < R.Top) then
        Exit;

      Result := FMin;
    end else
    if Y >= R.Bottom then
    begin
      if not IncParts then
        Exit;

      Result := Mx;
    end else
    begin
      W := R.Bottom - R.Top;
      M := Mx - FMin;

      if M = 1 then
      begin
        R.Bottom := W div 2;

        if PtInRect(R, P) then
          Result := FMin
        else
          Result := Mx;

        Exit;
      end;

      Dec(Y, R.Top);
      OffsetRect(R, 0, -R.Top);

      for I := 0 to M-1 do
      begin
        R.Left  := Muldiv(I, W, M);
        R.Right := Muldiv(I + 1, W, M);

        if (Y >= R.Top) and (Y < R.Bottom) then
        begin
          Result := FMin + I;
          Exit;
        end;
      end;
    end;
  end;
end;

function TSCCustomScrollbar.CanScroll(AsLeft: Boolean): Boolean;
var
  Mx: Integer;
begin
  Mx := GetMaximumValue;
  Result := Enabled and (FMin < Mx) and
    (FPressedPart = FHotPart);
    
  if Result then
  begin
    if AsLeft then
      Result := (Position > FMin) and
        (FPressedPart in [scspExtraButton, scspLeftSpare, scspLeftButton])
    else
      Result := (Position < Mx) and
        (FPressedPart in [scspRightSpare, scspRightButton]);
  end;
end;

procedure TSCCustomScrollbar.PauseScrolling;
begin
  FScrolling := False;
end;

procedure TSCCustomScrollbar.ResumeScrolling;
begin
  FScrolling := (FScrollTimer <> -1) and
    (CanScroll(True) or CanScroll(False));
end;

procedure TSCCustomScrollbar.ScrollControl;
var
  Mx: Integer;
  ScrlPart: TSCScrollerHitPart;
begin
  if not Scrolling or ScrollPaused then
    Exit;

  if CanScroll(True) then
  begin
    if FPressedPart in [scspExtraButton, scspLeftButton] then
      SetPosition(Position - FSmallChange)
    else
      SetPosition(Position - FLargeChange);

    if Position <= FMin then
    begin
      ScrlPart := FPressedPart;
      StopScrolling;

      FPressedPart := ScrlPart;
      Invalidate;
    end;
  end else
  if CanScroll(False) then
  begin
    if FPressedPart = scspRightButton then
      SetPosition(Position + FSmallChange)
    else
      SetPosition(Position + FLargeChange);

    Mx := GetMaximumValue;
    if Position >= Mx then
    begin
      ScrlPart := FPressedPart;
      StopScrolling;

      FPressedPart := ScrlPart;
      Invalidate;
    end;
  end;
end;

function TSCCustomScrollbar.Scrolling: Boolean;
begin
  Result := Enabled and FScrolling and (FPressedPart = FHotPart) and
    (FScrollTimer <> -1) and (CanScroll(True) or CanScroll(False));
end;

function TSCCustomScrollbar.ScrollPaused: Boolean;
begin
  Result := not (Enabled and FScrolling and (FPressedPart = FHotPart)) and
    (FScrollTimer <> -1) and (CanScroll(True) or CanScroll(False));
end;

procedure TSCCustomScrollbar.StartScrolling;
var
  P: TPoint;
  ScrlPart: TSCScrollerHitPart;
begin
  if not HandleAllocated then Exit;

  if CanScroll(False) or CanScroll(True) then
  begin
    FKeyboardSpeed := scKeyBoardSpeed;

    if not Enabled then
    begin
      StopScrolling;
      Exit;
    end;

    if ScrollPaused then
    begin
      ResumeScrolling;
      Exit;
    end;

    if not Scrolling then
    begin
      ScrlPart := FPressedPart;

      StopScrolling;
      FPressedPart := ScrlPart;

      FScrollTimer := SetTimer(Handle, SC_BAR_SCROLLTIMERID, scKeyBoardDelay, nil);
      FScrolling := FScrollTimer <> -1;

      ScrollControl;
      if not GetCursorPos(P) then
        StopScrolling
      else begin
        P := Self.ScreenToClient(P);
        FHotPart := GetPartAtPos(P.x, P.y);
      end;
    end;
  end;
end;

procedure TSCCustomScrollbar.StopScrolling;
begin
  FScrolling   := False;
  FPressedPart := scspNone;

  if FScrollTimer <> -1 then
  begin
    FKeyboardSpeed := 0;

    if HandleAllocated then
      KillTimer(Handle, FScrollTimer);

    FScrollTimer := -1;
    Invalidate;
  end;
end;

function TSCCustomScrollbar.GetPositionPos(P: Integer): Integer;
var
  R: TRect;
  W, ThS, Mx: Integer;
begin
  R := GetBackRect;
  Mx := GetMaximumValue;

  if FKind = scskHorizontal then
  begin
    if P <= FMin then
      Result := R.Left
    else begin
      ThS := GetThumbSize;
      if ThS < 0 then ThS := 0;

      W := R.Right - R.Left - ThS;

      if P >= FMin then
      begin
        Result := R.Left + W;
        Exit;
      end;

      P := Muldiv(W, P, Mx - FMin);
      Result := R.Left + P;
    end;
  end else
  begin
    if P <= FMin then
      Result := R.Top
    else begin
      ThS := GetThumbSize;
      if ThS < 0 then ThS := 0;

      W := R.Bottom - R.Top - ThS;

      if P >= FMin then
      begin
        Result := R.Top + W;
        Exit;
      end;

      P := Muldiv(W, P, Mx - FMin);
      Result := R.Top + P;
    end;
  end;
end;

function TSCCustomScrollbar.GetThumbOffset: Integer;
var
  ThS: Integer;
begin
  Result := 0;
  if (FThumbSize > 0) or (PageSize > 0) then
  begin
    ThS := GetDefaultThumbSize(PageSize);
    if ThS < 0 then ThS := 0;

    if FThumbSize > 0 then
      Result := FThumbSize - ThS
    else
      Result := ThS - GetDefaultThumbSize(0);

    Result := Round(Result / 2);  
    if Result < 0 then Result := 0;
  end;
end;

function TSCCustomScrollbar.GetDefaultThumbSize(Pg: Integer): Integer;
var
  R: TRect;
  Bs: Integer;
begin
  if Pg <= 0 then
  begin
    if FKind = scskHorizontal then
      Result := FDefV_ButtonSize
    else
      Result := FDefH_ButtonSize;
  end else
  begin
    R := GetBackRect;
    if FKind = scskHorizontal then
      Bs := R.Right - R.Left
    else
      Bs := R.Bottom - R.Top;

    if Bs <= 0 then
    begin
      Result := 0;
      Exit;
    end;

    Result := MulDiv(Pg, Bs, (FMax - FMin + 1));

    if FKind = scskHorizontal then
      Bs := Muldiv(2, FDefV_ButtonSize, 3)
    else
      Bs := Muldiv(2, FDefH_ButtonSize, 3);

    if Result < Bs then
      Result := Bs;
  end;
end;

procedure TSCCustomScrollbar.ProcessScrollKey(var Key: Word;
  IsKeyPress: Boolean);
begin
  case Key of
    VK_UP:
      SetPosition(Position + LargeChange);
    VK_DOWN:
      SetPosition(Position - LargeChange);
    VK_HOME:
      SetPosition(FMin);
    VK_END:
      SetPosition(GetMaximumValue);
    VK_PRIOR, VK_LEFT:
      SetPosition(Position - SmallChange);
    VK_NEXT, VK_RIGHT:
      SetPosition(Position + SmallChange);
  end;
end;

procedure TSCCustomScrollbar.MouseInControlChanged;
var
  P: TPoint;
begin
  if MouseInControl then
    ResumeScrolling
  else
    PauseScrolling;

  if not MouseInControl then
    FHotPart := scspNone
  else begin
    GetCursorPos(P);
    P := Self.ScreenToClient(P);

    FHotPart := GetPartAtPos(P.x, P.y);
  end;

  Invalidate;
end;

procedure TSCCustomScrollbar.StopTracking;
begin
  StopFlash;
  StopScrolling;
  inherited StopTracking;
end;

procedure TSCCustomScrollbar.Loaded;
begin
  inherited Loaded;
  Invalidate;
end;

procedure TSCCustomScrollbar.DoDrawBorder(C: TCanvas; R: TRect);
var
  Cl: TColor;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  if FStyle = scssOffice12 then
    DoDrawOffice12Border(C, R)
  else
  if FStyle = scssMac then
  begin
    Cl := Get3DDkShadowOf(GetBackColor);
    scFrame3D(C, R, Cl, Cl, 1, 0);
  end else
  if FStyle = scssMetal then
  begin
    Cl := GetBtnShadowOf(GetBackColor);
    scFrame3D(C, R, Cl, Cl, 1, 0);
  end;
end;

procedure TSCCustomScrollbar.SetStyle(Value: TSCScrollbarStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    DoSettingsChanged;
  end;
end;

function TSCCustomScrollbar.GetBorderExColor: TColor;
begin
  Result := Self.Color;
  if FBackColors <> nil then
    Result := FBackColors.DefaultColor;
end;

procedure TSCCustomScrollbar.DoDrawThumbLine(C: TCanvas; R: TRect; Cl: TColor);
var
  R1, R2: TRect;
  C1, C2, C3: TColor;
  I, J, Cnt, L, T, X, Y, H: Integer;
begin
  if (C = nil) or IsRectEmpty(R) or (FThumbLines = sctlNone) or
    (FStyle = scssMetal) then
    Exit;

  R1 := R;
  InflateRect(R1, -3, -3);
  if IsRectEmpty(R1) then Exit;

  C1 := GetBtnHighlightOf(Cl);
  C2 := GetBtnShadowOf(Cl);

  if FThumbLines in [sctlLowered, sctlDots] then
  begin
    C3 := C1;
    C1 := C2;
    C2 := C3;
  end;

  if FKind = scskHorizontal then
  begin
    if FThumbLines = sctlDash then
    begin
      if FStyle = scssOffice12 then
        C1 := C2;
        
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C1;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C1;
      end;

      X := (R1.Right - R1.Left) div 2;
      if X > 4 then X := 4;

      H := R1.Bottom - R1.Top - 2;
      if H > 16 then H := 16;

      L := R1.Left + ((R1.Right - R1.Left - (2*X - 1)) div 2);
      T := R1.Top + ((R1.Bottom - R1.Top - H) div 2);

      for I := 0 to X - 1 do
      begin
        R2 := Rect(L, T, L + 1, T + H);
        C.FillRect(R2);
        Inc(L, 2);
      end;
      
      Exit;
    end;

    if FThumbLines = sctlWideDash then
    begin
      if FStyle = scssOffice12 then
        C1 := C2;
        
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C1;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C1;
      end;

      X := (R1.Right - R1.Left) div 4;
      if X > 4 then X := 4;

      H := R1.Bottom - R1.Top - 2;
      if H > 16 then H := 16;

      L := R1.Left + ((R1.Right - R1.Left - (4*X - 2)) div 2);
      T := R1.Top + ((R1.Bottom - R1.Top - H) div 2);

      for I := 0 to X - 1 do
      begin
        R2 := Rect(L, T, L + 2, T + H);
        C.FillRect(R2);
        Inc(L, 4);
      end;
      
      Exit;
    end;
    
    if FThumbLines = sctlDots then
    begin
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C1;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C2;
      end;

      X := (R1.Right - R1.Left) div 4;
      if X > 5 then X := 5;

      Y := (R1.Bottom - R1.Top) div 4;
      if Y > 3 then Y := 3;

      L := R1.Left + ((R1.Right - R1.Left) div 2) + (1 - 2*X);
      for I := 0 to X-1 do
      begin
        T := R1.Top + ((R1.Bottom - R1.Top) div 2) + (1 - 2*Y);

        for J := 0 to Y-1 do
        begin
          R2 := Rect(L, T, L + 2, T + 2);
          with C do
          begin
            Brush.Color := C1;
            FillRect(R2);

            Inc(R2.Left);
            Inc(R2.Top);

            Brush.Color := C2;
            FillRect(R2);
          end;

          Inc(T, 4);
        end;

        Inc(L, 4);
      end;

      Exit;
    end;

    Cnt := (R1.Right - R1.Left) div 2;
    if Cnt > 4 then Cnt := 4
    else
    if Cnt <= 0 then Exit;

    R1.Left  := R1.Left + ((R1.Right - R1.Left) div 2);
    R1.Right := R1.Left;

    Dec(R1.Left, Cnt);
    Inc(R1.Right, Cnt);

    with C do
    begin
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := C1;
      for I := 0 to Cnt-1 do
      begin
        MoveTo(R1.Left + 2*I, R1.Top);
        LineTo(R1.Left + 2*I, R1.Bottom - 1);
      end;

      Pen.Color := C2;
      for I := 0 to Cnt-1 do
      begin
        MoveTo(R1.Left + 1 + 2*I, R1.Top + 1);
        LineTo(R1.Left + 1 + 2*I, R1.Bottom);
      end;
    end;
  end else
  begin
    if FThumbLines = sctlDash then
    begin
      if FStyle = scssOffice12 then
        C1 := C2;

      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C1;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C1;
      end;

      Y := (R1.Bottom - R1.Top) div 2;
      if Y > 4 then Y := 4;

      H := R1.Right - R1.Left - 2;
      if H > 16 then H := 16;

      L := R1.Left + ((R1.Right - R1.Left - H) div 2);
      T := R1.Top + ((R1.Bottom - R1.Top - (2*Y - 1)) div 2);

      for I := 0 to Y - 1 do
      begin
        R2 := Rect(L, T, L + H, T + 1);
        C.FillRect(R2);
        Inc(T, 2);
      end;

      Exit;
    end;

    if FThumbLines = sctlWideDash then
    begin
      if FStyle = scssOffice12 then
        C1 := C2;

      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C1;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C1;
      end;

      Y := (R1.Bottom - R1.Top) div 4;
      if Y > 4 then Y := 4;

      H := R1.Right - R1.Left - 2;
      if H > 16 then H := 16;

      L := R1.Left + ((R1.Right - R1.Left - H) div 2);
      T := R1.Top + ((R1.Bottom - R1.Top - (4*Y - 2)) div 2);

      for I := 0 to Y - 1 do
      begin
        R2 := Rect(L, T, L + H, T + 2);
        C.FillRect(R2);
        Inc(T, 4);
      end;

      Exit;
    end;

    if FThumbLines = sctlDots then
    begin
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C1;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C2;
      end;

      X := (R1.Right - R1.Left) div 4;
      if X > 3 then X := 3;

      Y := (R1.Bottom - R1.Top) div 4;
      if Y > 5 then Y := 5;

      L := R1.Left + ((R1.Right - R1.Left) div 2) + (1 - 2*X);
      for I := 0 to X-1 do
      begin
        T := R1.Top + ((R1.Bottom - R1.Top) div 2) + (1 - 2*Y);

        for J := 0 to Y-1 do
        begin
          R2 := Rect(L, T, L + 2, T + 2);
          with C do
          begin
            Brush.Color := C1;
            FillRect(R2);

            Inc(R2.Left);
            Inc(R2.Top);

            Brush.Color := C2;
            FillRect(R2);
          end;

          Inc(T, 4);
        end;

        Inc(L, 4);
      end;

      Exit;
    end;

    Cnt := (R1.Bottom - R1.Top) div 2;
    if Cnt > 4 then Cnt := 4
    else
    if Cnt <= 0 then Exit;

    R1.Top  := R1.Top + ((R1.Bottom - R1.Top) div 2);
    R1.Bottom := R1.Top;

    Dec(R1.Top, Cnt);
    Inc(R1.Bottom, Cnt);

    with C do
    begin
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := C1;
      for I := 0 to Cnt-1 do
      begin
        MoveTo(R1.Left,      R1.Top + 2*I);
        LineTo(R1.Right - 1, R1.Top + 2*I);
      end;

      Pen.Color := C2;
      for I := 0 to Cnt-1 do
      begin
        MoveTo(R1.Left + 1, R1.Top + 1 + 2*I);
        LineTo(R1.Right,    R1.Top + 1 + 2*I);
      end;
    end;
  end;
end;

procedure TSCCustomScrollbar.SetThumbLines(Value: TSCScrollThumbline);
begin
  if FThumbLines <> Value then
  begin
    FThumbLines := Value;
    if FShowThumb and (FThumbSize <> 0) then
      DoSettingsChanged;
  end;
end;

function TSCCustomScrollbar.GetBackColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    if FPressedPart in [scspLeftSpare, scspRightSpare] then
    begin
      if FHotPart <> scspNone then
        Result := GetOfficeXPSelColor
      else
        Result := GetOfficeXPDownedSelColor;
    end else
    if (FPressedPart = scspNone) and
      (FHotPart in [scspLeftSpare, scspRightSpare]) then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;

    if FBackColors.BlendColors then
      Result := BlendedColor(Result, 24, 24, 24, True);
  end else
  begin
    Result := FBackColors.GetDefaultColor;
    if not Enabled then
      Result := FBackColors.GetDisabledColor
    else
    if (FPressedPart = scspNone) and
      (FHotPart in [scspLeftSpare, scspRightSpare]) then
      Result := FBackColors.GetHotColor
    else
    if Focused then
      Result := FBackColors.GetActiveColor;

    if Result = clNone then
      Result := clScrollBar;
  end;    
end;

function TSCCustomScrollbar.GetLeftBtnColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    if FPressedPart = scspLeftButton then
    begin
      if FHotPart = scspLeftButton then
        Result := GetOfficeXPDownedSelColor
      else
        Result := GetOfficeXPSelColor;
    end else
    if (FPressedPart = scspNone) and (FHotPart = scspLeftButton) then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;

    if FButtonColors.BlendColors then
      Result := BlendedColor(Result, 24, 24, 24, True);
  end else
  begin
    Result := FButtonColors.GetDefaultColor;
    if not Enabled then
      Result := FButtonColors.GetDisabledColor
    else
    if FPressedPart = scspLeftButton then
      Result := FButtonColors.GetDownColor
    else
    if (FPressedPart = scspNone) and (FHotPart = scspLeftButton) then
      Result := FButtonColors.GetHotColor
    else
    if Focused then
      Result := FButtonColors.GetActiveColor;

    if Result = clNone then
      Result := clScrollBar;
  end;
end;

function TSCCustomScrollbar.GetRightBtnColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    if FPressedPart = scspRightButton then
    begin
      if FHotPart = scspRightButton then
        Result := GetOfficeXPDownedSelColor
      else
        Result := GetOfficeXPSelColor;
    end else
    if (FPressedPart = scspNone) and (FHotPart = scspRightButton) then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;

    if FButtonColors.BlendColors then
      Result := BlendedColor(Result, 24, 24, 24, True);
  end else
  begin
    Result := FButtonColors.GetDefaultColor;
    if not Enabled then
      Result := FButtonColors.GetDisabledColor
    else
    if FPressedPart = scspRightButton then
      Result := FButtonColors.GetDownColor
    else
    if (FPressedPart = scspNone) and
      (FHotPart = scspRightButton) then
      Result := FButtonColors.GetHotColor
    else
    if Focused then
      Result := FButtonColors.GetActiveColor;

    if Result = clNone then
      Result := clScrollBar;
  end;    
end;

function TSCCustomScrollbar.GetThumbColor: TColor;
begin
  if FFlashOnFocus and FFlashOn and not IsDesigning then
  begin
    Result := FFlashColor;
    if Result <> clNone then Exit;
  end;

  if FStyle = scssOffice2k then
  begin
    if FPressedPart = scspThumb then
    begin
      if FHotPart = scspThumb then
        Result := GetOfficeXPDownedSelColor
      else
        Result := GetOfficeXPSelColor;
    end else
    if (FPressedPart = scspNone) and (FHotPart = scspThumb) then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;

    if FThumbColors.BlendColors then
      Result := BlendedColor(Result, 24, 24, 24, True);
  end else
  begin
    Result := FThumbColors.GetDefaultColor;
    if not Enabled then
      Result := FThumbColors.GetDisabledColor
    else
    if FPressedPart = scspThumb then
      Result := FThumbColors.GetDownColor
    else
    if (FPressedPart = scspNone) and
      (FHotPart = scspThumb) then
      Result := FThumbColors.GetHotColor
    else
    if Focused then
      Result := FThumbColors.GetActiveColor;

    if Result = clNone then
      Result := clScrollBar;
  end;    
end;

function TSCCustomScrollbar.GetLeftBtnIconColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    Result := clBtnText;
    if (FPressedPart = scspLeftButton) and (FHotPart = FPressedPart) then
      Result := clHighlightText;
  end else
  begin
    Result := FButtonIconColors.GetDefaultColor;
    if not Enabled then
      Result := FButtonIconColors.GetDisabledColor
    else
    if FPressedPart = scspLeftButton then
      Result := FButtonIconColors.GetDownColor
    else
    if (FPressedPart = scspNone) and
      (FHotPart = scspLeftButton) then
      Result := FButtonIconColors.GetHotColor
    else
    if Focused then
      Result := FButtonIconColors.GetActiveColor;

    if Result = clNone then
      Result := clWindowText;
  end;
end;

function TSCCustomScrollbar.GetRightBtnIconColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    Result := clBtnText;
    if (FPressedPart = scspRightButton) and (FHotPart = FPressedPart) then
      Result := clHighlightText;
  end else
  begin
    Result := FButtonIconColors.GetDefaultColor;
    if not Enabled then
      Result := FButtonIconColors.GetDisabledColor
    else
    if FPressedPart = scspRightButton then
      Result := FButtonIconColors.GetDownColor
    else
    if (FPressedPart = scspNone) and
      (FHotPart = scspRightButton) then
      Result := FButtonIconColors.GetHotColor
    else
    if Focused then
      Result := FButtonIconColors.GetActiveColor;

    if Result = clNone then
      Result := clWindowText;
  end;    
end;

function TSCCustomScrollbar.GetBlendValue: Word;
begin
  Result := 0;
end;

procedure TSCCustomScrollbar.DoDrawXPFace(C: TCanvas; R: TRect; Cl, BkCl: TColor;
  IsThumb, IsDown, IsHot: Boolean);
begin
  if FStyle = scssXP then
    scDrawXPFace(FKind, C, R, Cl, BkCl, IsDown, IsHot)
  else  
    scDrawXPFace2(FKind, C, R, Cl, BkCl, IsThumb, IsDown, IsHot);
end;

procedure TSCCustomScrollbar.SetSensitivity(Value: Integer);
begin
  if Value < -1 then Value := -1;
  FSensitivity := Value;
end;

procedure TSCCustomScrollbar.SetTrimPageSize(Value: Boolean);
var
  Mx: Integer;
begin
  if FTrimPageSize <> Value then
  begin
    StopScrolling;

    FTrimPageSize := Value;

    Mx := GetMaximumValue;
    if FTrimPageSize and (Position > Mx) then
      SetPosition(Mx);
  end;
end;

function TSCCustomScrollbar.GetMaximumValue: Integer;
var
  Pg: Integer;
begin
  Result := FMax;
  if FTrimPageSize and (FPageSize > 0) then
  begin
    Pg := FPageSize;
    if Pg > 0 then Dec(Pg);

    Result := FMax - Pg;
    if Result < FMin then
      Result := FMin;
  end;
end;

procedure TSCCustomScrollbar.SetShowSlideLine(Value: Boolean);
begin
  if FShowSlideLine <> Value then
  begin
    FShowSlideLine := Value;
    DoSettingsChanged;
  end;
end;

function TSCCustomScrollbar.GetBackRectFrom(R: TRect): TRect;
var
  Rr, Rl, Re: TRect;
  REmpty, LEmpty, EEmpty: Boolean;
begin
  Result := R;

  if FShowButtons and (FButtonSize <> 0) and not IsRectEmpty(Result) then
  begin
    Rl := GetLeftButtonRect;
    Rr := GetRightButtonRect;
    Re := GetExtraButtonRect;

    LEmpty := IsRectEmpty(Rl);
    REmpty := IsRectEmpty(Rr);
    EEmpty := IsRectEmpty(Re);

    if FKind = scskHorizontal then
    begin
      case FButtonLayout of
        scsbDefault:
        begin
          if not LEmpty and (Rl.Right > Result.Left) then
            Result.Left := Rl.Right;

          if not REmpty and (Rr.Left < Result.Right) then
            Result.Right := Rr.Left;

          if FShowExtraButton and not EEmpty and (Re.Left < Result.Right) then
            Result.Right := Re.Left;
        end;
        scsbLeftTop:
        begin
          if not LEmpty and (Rl.Right > Result.Left) then
            Result.Left := Rl.Right;

          if not REmpty and (Rr.Right > Result.Left) then
            Result.Left := Rr.Right;

          if FShowExtraButton and not EEmpty and (Re.Left < Result.Right) then
            Result.Right := Re.Left;
        end;
        scsbRightBottom:
        begin
          if not FShowExtraButton then
          begin
            if not LEmpty and (Rl.Left < Result.Right) then
              Result.Right := Rl.Left;
          end else
          begin
            if not LEmpty and (Rl.Right > Result.Left) then
              Result.Left := Rl.Right;

            if not EEmpty and (Re.Left < Result.Right) then
              Result.Right := Re.Left;
          end;

          if not REmpty and (Rr.Left < Result.Right) then
            Result.Right := Rr.Left;
        end;
      end;
    end else
    begin
      case FButtonLayout of
        scsbDefault:
        begin
          if not LEmpty and (Rl.Bottom > Result.Top) then
            Result.Top := Rl.Bottom;

          if not REmpty and (Rr.Top < Result.Bottom) then
            Result.Bottom := Rr.Top;

          if FShowExtraButton and not EEmpty and (Re.Top < Result.Bottom) then
            Result.Bottom := Re.Top;
        end;
        scsbLeftTop:
        begin
          if not LEmpty and (Rl.Bottom > Result.Top) then
            Result.Top := Rl.Bottom;

          if not REmpty and (Rr.Bottom > Result.Top) then
            Result.Top := Rr.Bottom;

          if FShowExtraButton and not EEmpty and (Re.Top < Result.Bottom) then
            Result.Bottom := Re.Top;
        end;
        scsbRightBottom:
        begin
          if not FShowExtraButton then
          begin
            if not LEmpty and (Rl.Top < Result.Bottom) then
              Result.Bottom := Rl.Top;
          end else
          begin
            if not LEmpty and (Rl.Bottom > Result.Top) then
              Result.Top := Rl.Bottom;

            if not EEmpty and (Re.Top < Result.Bottom) then
              Result.Bottom := Re.Top;
          end;

          if not REmpty and (Rr.Top < Result.Bottom) then
            Result.Bottom := Rr.Top;
        end;
      end;
    end;

    if IsRectEmpty(Result) then
      Result := Rect(0, 0, 0, 0);
  end;
end;

function TSCCustomScrollbar.CanSetValue(var Value: Integer): Boolean;
begin
  Result := True;
  if Value < FMin then
    Value := FMin
  else if Value > FMax then
    Value := FMax;
end;

procedure TSCCustomScrollbar.SetFlashOnFocus(Value: Boolean);
begin
  if FFlashOnFocus <> Value then
  begin
    FFlashOnFocus := Value;
    if not Value then StopFlash
    else if Focused then
      StartFlash;
  end;
end;

procedure TSCCustomScrollbar.StopFlash;
begin
  FFlashOn  := False;
  if FFlashTimer <> -1 then
  begin
    if HandleAllocated then
      KillTimer(Handle, FFlashTimer);

    FFlashTimer := -1;
    Invalidate;
  end;
end;

procedure TSCCustomScrollbar.StartFlash;
begin
  StopFlash;
  if not (FFlashOnFocus and HandleAllocated) then
    Exit;

  if FFlashTimer = -1 then
  begin
    FFlashOn := True;
    FFlashTimer := SetTimer(Handle, SC_BAR_FlashTIMERID, 500, nil);
    Invalidate;
  end;  
end;

procedure TSCCustomScrollbar.SetFlashColor(Value: TColor);
begin
  if FFlashColor <> Value then
  begin
    FFlashColor := Value;
    if FFlashOnFocus and FFlashOn and not IsDesigning then
      Invalidate;
  end;
end;

procedure TSCCustomScrollbar.EnabledChanged;
begin
  StopFlash;
  StopScrolling;
  inherited EnabledChanged;
end;

procedure TSCCustomScrollbar.FocusChanged;
begin
  if not HasFocus or IsDestroying then
    StopFlash
  else
    StartFlash;

  inherited FocusChanged;
end;

procedure TSCCustomScrollbar.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomScrollbar then
  begin
    with TSCCustomScrollbar(Source) do
    begin
      Self.FlashColor := FlashColor;
      Self.FlashOnFocus := FlashOnFocus;
      Self.BackColors := BackColors;
      Self.ButtonColors := ButtonColors;
      Self.ButtonIconColors := ButtonIconColors;
      Self.ButtonLayout := ButtonLayout;
      Self.ButtonSize := ButtonSize;
      Self.LargeChange := LargeChange;
      Self.Max := Max;
      Self.Min := Min;
      Self.Kind := Kind;
      Self.PageSize := PageSize;
      Self.Position := Position;
      Self.Sensitivity := Sensitivity;
      Self.ShowButtons := ShowButtons;
      Self.ShowSlideLine := ShowSlideLine;
      Self.ShowThumb := ShowThumb;
      Self.SmallChange := SmallChange;
      Self.Style := Style;
      Self.ThumbColors := ThumbColors;
      Self.ThumbLines := ThumbLines;
      Self.ThumbSize := ThumbSize;
      Self.Tracking := Tracking;
      Self.TrimPageSize := TrimPageSize;
    end;
  end;
end;

function TSCCustomScrollbar.GetPosition: Integer;
begin
  Result := FPosition;
end;

function TSCCustomScrollbar.NormalizePosition(Value: Integer): Integer;
begin
  Result := Value;
  if Result < FMin then Result := FMin;
  if Result > FMax then Result := FMax;
end;

procedure TSCCustomScrollbar.SetShowExtraButton(Value: Boolean);
begin
  if FShowExtraButton <> Value then
  begin
    FShowExtraButton := Value;
    if FShowButtons then
      Invalidate;
  end;
end;

function TSCCustomScrollbar.GetExtraButtonRect: TRect;
var
  Bs: Integer;
begin
  if not FShowButtons or not FShowExtraButton or (FButtonSize = 0) then
  begin
    Result := Rect(0, 0, 0, 0);
    Exit;
  end;

  Result := GetClientRect;
  Bs := GetButtonSize;

  if FKind = scskHorizontal then
  begin
    if FButtonLayout in [scsbDefault, scsbRightBottom] then
      Dec(Result.Right, Bs);

    Result.Left := Result.Right - Bs;
  end else
  begin
    if FButtonLayout in [scsbDefault, scsbRightBottom] then
      Dec(Result.Bottom, Bs);

    Result.Top := Result.Bottom - Bs;
  end;
end;

procedure TSCCustomScrollbar.DoDrawExtraButton(C: TCanvas; R: TRect);
var
  W, H, I: Integer;
  OffP, P: TPoint;
  C1, C2, C3, C4: TColor;

  procedure DrawButtonIcon;
  begin
    OffP := Point(0, 0);
    if (FPressedPart = scspExtraButton) and (FPressedPart = FHotPart) and
      not (FStyle in [scssOffice2k, scssXP, scssXP2, scssFlatEx]) then
    begin
      OffP := Point(1, 1);

      if FStyle = scssMac then
      begin
        if FKind = scskHorizontal then
          OffP := Point(-1, 0)
        else
          OffP := Point(0, -1);
      end;
    end;

    if C2 <> C1 then
    begin
      W := 6; H := 3;

      I := R.Right - R.Left;
      if I > R.Bottom - R.Top then
        I := R.Bottom - R.Top;

      if I < 16 then
      begin
        W := 4; H := 2;
        if I < 12 then
        begin
          W := 2; H := 1;
        end;
      end;

      if FKind = scskHorizontal then
      begin
        P.x := R.Left + ((R.Right - R.Left) div 2) - 2 + OffP.x;
        P.y := R.Top +  ((R.Bottom - R.Top) div 2) + OffP.y;

        scDrawRightSlider(C, P, W, H, sctsMac, False, C2, C2);
      end else
      begin
        P.x := R.Left + ((R.Right - R.Left) div 2) + OffP.x;
        P.y := R.Top +  ((R.Bottom - R.Top) div 2) - 2 + OffP.y;

        scDrawDownSlider(C, P, W, H, sctsMac, False, C2, C2);
      end;
    end;
  end;

begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  C1 := GetExtraBtnColor;
  C2 := GetExtraBtnIconColor;

  with C do
  begin
    Brush.Color := C1;
    FillRect(R);
  end;

  DrawButtonIcon;
  
  case FStyle of
    scssDefault, scssDefaultEx:
    begin
      if (FHotPart = FPressedPart) and
        (FPressedPart = scspExtraButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssFlat:
    begin
      if (FHotPart = FPressedPart) and
        (FPressedPart = scspExtraButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssFlatEx:
    begin
      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssFlatHover:
    begin
      if (FHotPart = FPressedPart) and
        (FPressedPart = scspExtraButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      if HasFocus or MouseInControl then
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssMetal:
    begin
      InflateRect(R, -1, -1);

      if (FHotPart = FPressedPart) and
        (FPressedPart = scspExtraButton) then
      begin
        C3 := C1;
        C4 := SCCommon.scBlendColor(C1, 64);
      end else
      begin
        C3 := SCCommon.scBlendColor(C1, 64);
        C4 := C1;
      end;

      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C3, C4, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssOffice2k:
    begin
      C3 := clHighlight;
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssOffice12:
    begin
      DoDrawBack(C, R);
      DoDrawOffice12Border(C, R);

      if FHotPart <> scspNone then
        scDrawOffice12Face(Kind, C, R, C1, GetBackColor, True,
          FPressedPart = scspExtraButton, FHotPart = scspExtraButton,
          True, False);

      DrawButtonIcon;
    end;
    scss3D, scss3DX:
    begin
      scDraw3DFace(Kind, C, R, C1, GetBackColor, FStyle = scss3DX,
        FPressedPart = scspExtraButton, FHotPart = scspExtraButton);

      DrawButtonIcon;
    end;
    scssNew, scssNewX:
    begin
      scDrawNewFace(Kind, C, R, C1, GetBackColor, FStyle = scssNewX,
        FPressedPart = scspExtraButton, FHotPart = scspExtraButton);

      DrawButtonIcon;
    end;
    scssXP, scssXP2:
    begin
      DoDrawXPFace(C, R, C1, GetBackColor, False, FPressedPart = scspExtraButton,
        FHotPart = scspExtraButton);

      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C2;

        W := 4;

        I := R.Right - R.Left;
        if I > R.Bottom - R.Top then
          I := R.Bottom - R.Top;

        if I < 14 then
        begin
          W := 3;
          if I < 8 then
            W := 2;
        end;

        if FKind = scskHorizontal then
        begin
          Dec(P.x);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x + (W - 1), P.y - (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y + W);

            Inc(P.x);
          end;
        end else
        begin
          Dec(P.y);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x - (W - 1), P.y + (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y + W);

            Inc(P.y);
          end;
        end;
      end;
    end;
    scssMac:
    begin
      if (FHotPart = FPressedPart) and
        (FPressedPart = scspExtraButton) then
      begin
        C2 := SCCommon.scBlendColor(C1, -48);
        C3 := SCCommon.scBlendColor(C1, 48);
      end else
      begin
        C2 := SCCommon.scBlendColor(C1, 48);
        C3 := SCCommon.scBlendColor(C1, -48);
      end;

      InflateRect(R, -1, -1);
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C2, C3, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := Get3DDkShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
  end;
end;

function TSCCustomScrollbar.GetExtraBtnColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    if FPressedPart = scspExtraButton then
    begin
      if FHotPart = scspExtraButton then
        Result := GetOfficeXPDownedSelColor
      else
        Result := GetOfficeXPSelColor;
    end else
    if (FPressedPart = scspNone) and (FHotPart = scspExtraButton) then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;

    if FButtonColors.BlendColors then
      Result := BlendedColor(Result, 24, 24, 24, True);
  end else
  begin
    Result := FButtonColors.GetDefaultColor;
    if not Enabled then
      Result := FButtonColors.GetDisabledColor
    else
    if FPressedPart = scspExtraButton then
      Result := FButtonColors.GetDownColor
    else
    if (FPressedPart = scspNone) and (FHotPart = scspExtraButton) then
      Result := FButtonColors.GetHotColor
    else
    if Focused then
      Result := FButtonColors.GetActiveColor;

    if Result = clNone then
      Result := clScrollBar;
  end;
end;

function TSCCustomScrollbar.GetExtraBtnIconColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    Result := clBtnText;
    if (FPressedPart = scspExtraButton) and (FHotPart = FPressedPart) then
      Result := clHighlightText;
  end else
  begin
    Result := FButtonIconColors.GetDefaultColor;
    if not Enabled then
      Result := FButtonIconColors.GetDisabledColor
    else
    if FPressedPart = scspExtraButton then
      Result := FButtonIconColors.GetDownColor
    else
    if (FPressedPart = scspNone) and (FHotPart = scspExtraButton) then
      Result := FButtonIconColors.GetHotColor
    else
    if Focused then
      Result := FButtonIconColors.GetActiveColor;

    if Result = clNone then
      Result := clWindowText;
  end;
end;

{ TSCScrollbarColors }

procedure TSCScrollbarColors.Assign(Source: TPersistent);
begin
  if Source is TSCScrollbarColors then
  begin
    with TSCScrollbarColors(Source) do
    begin
      Self.FActiveColor := FActiveColor;
      Self.FBlendColors := BlendColors;
      Self.FDefaultColor := FDefaultColor;
      Self.FDisabledColor := FDisabledColor;
      Self.FDownColor := FDownColor;
      Self.FHotColor := FHotColor;
    end;

    DoChange;
  end else
    inherited Assign(Source);
end;

procedure TSCScrollbarColors.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

constructor TSCScrollbarColors.Create(AOwner: TSCCustomScrollbar);
begin
  inherited Create;
  FOwner := AOwner;

  FActiveColor := clBtnFace;
  FDefaultColor := clBtnFace;
  FDisabledColor := clBtnFace;
  FDownColor := clBtnFace;
  FHotColor := clBtnFace;
end;

procedure TSCScrollbarColors.DoChange;
begin
  if (FOwner <> nil) and not InUpdate then
    FOwner.DoSettingsChanged;
end;

procedure TSCScrollbarColors.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      DoChange;
  end;
end;

function TSCScrollbarColors.GetActiveColor: TColor;
begin
  Result := FActiveColor;
  if Result = clNone then
    Result := GetNoneColor;

  if GetBlendColors then
    Result := BlendedColor(GetOfficeXPBtnColorOf(Result), 24, 24, 24, True);
end;

function TSCScrollbarColors.GetBlendColors: Boolean;
begin
  Result := FBlendColors;
end;

function TSCScrollbarColors.GetDefaultColor: TColor;
begin
  Result := FDefaultColor;
  if Result = clNone then
    Result := GetNoneColor;

  if GetBlendColors then
    Result := BlendedColor(GetOfficeXPBtnColorOf(Result), 24, 24, 24, True);
end;

function TSCScrollbarColors.GetDisabledColor: TColor;
begin
  Result := FDisabledColor;
  if Result = clNone then
    Result := GetNoneColor;

  if GetBlendColors then
    Result := BlendedColor(GetOfficeXPBtnColorOf(Result), 24, 24, 24, True);
end;

function TSCScrollbarColors.GetDownColor: TColor;
begin
  Result := FDownColor;
  if Result = clNone then
    Result := GetNoneColor;

  if GetBlendColors then
    Result := BlendedColor(GetOfficeXPBtnColorOf(Result), 24, 24, 24, True);
end;

function TSCScrollbarColors.GetHotColor: TColor;
begin
  Result := FHotColor;
  if Result = clNone then
    Result := GetNoneColor;

  if GetBlendColors then
    Result := BlendedColor(GetOfficeXPBtnColorOf(Result), 24, 24, 24, True);
end;

function TSCScrollbarColors.GetNoneColor: TColor;
begin
  Result := clScrollbar;
end;

function TSCScrollbarColors.InUpdate: Boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TSCScrollbarColors.SetActiveColor(Value: TColor);
begin
  if FActiveColor <> Value then
  begin
    FActiveColor := Value;
    DoChange;
  end;
end;

procedure TSCScrollbarColors.SetBlendColors(Value: Boolean);
begin
  if FBlendColors <> Value then
  begin
    FBlendColors := Value;
    DoChange;
  end;
end;

procedure TSCScrollbarColors.SetDefaultColor(Value: TColor);
begin
  if FDefaultColor <> Value then
  begin
    FDefaultColor := Value;
    DoChange;
  end;
end;

procedure TSCScrollbarColors.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    DoChange;
  end;
end;

procedure TSCScrollbarColors.SetDownColor(Value: TColor);
begin
  if FDownColor <> Value then
  begin
    FDownColor := Value;
    DoChange;
  end;
end;

procedure TSCScrollbarColors.SetHotColor(Value: TColor);
begin
  if FHotColor <> Value then
  begin
    FHotColor := Value;
    DoChange;
  end;
end;

{ TSCScrollbarBkColors }

constructor TSCScrollbarBkColors.Create(AOwner: TSCCustomScrollbar);
begin
  inherited Create(AOwner);
  FBlendColors := True;
  FDownColor := cl3DDkShadow;
end;

{ TSCScrollbarIconColors }

constructor TSCScrollbarIconColors.Create(AOwner: TSCCustomScrollbar);
begin
  inherited Create(AOwner);
  FActiveColor := clBtnText;
  FDefaultColor := clBtnText;
  FDisabledColor := clBtnShadow;
  FDownColor := clBtnText;
  FHotColor := clBtnText;
end;

function TSCScrollbarIconColors.GetNoneColor: TColor;
begin
  Result := clBtnText;
end;

{$I SCVerRec.inc}

end.
