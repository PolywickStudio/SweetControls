{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCGraphicButton;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, StdActns, ActnList, Menus, SCConsts, SCCommon, SCControl;

type
  TSCGraphicButtonBorderProps = class(TSCGraphicBorderProps)
  published
    property Border;
    property Color;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCGraphicButtonBase = class(TSCGraphicControl)
  private
    FDblClicked: Boolean;
    FEndEllipsis: Boolean;
    FTimerEnabled: Boolean;
    FInterval: Integer;
    FWindowHandle: HWND;
    procedure DoTimer;
    procedure UpdateTimer;
    procedure SetInterval(Value: Integer);
    procedure SetEndEllipsis(Value: Boolean);
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure StartTimer;
    procedure StopTimer;

    function  GetInterval: Integer; virtual;
    procedure Timer; virtual;

    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    function  GetBorderPropsClass: TSCGraphicBorderPropsClass; override;

    property DblClicked: Boolean read FDblClicked;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default True;
    property Transparent default False;
    property WindowHandle: HWND read FWindowHandle;
    property Interval: Integer read GetInterval write SetInterval default 50;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCCustomGraphicButton = class(TSCGraphicButtonBase)
  private
    FAllowAllUp: Boolean;
    FArrowColor: TColor;
    FCancel: Boolean;
    FCenter: Boolean;
    FDown: Boolean;
    FDropdownMenu: TPopupMenu;
    FGradient: TSCButtonGradient;
    FGroupIndex: Integer;
    FHighlightColor: TColor;
    FHottrackColor: TColor;
    FLayout: TSCButtonLayout;
    FPopupArrow: Boolean;
    FRepeatClick: Boolean;
    FRepeatInterval: Integer;
    FRoundColor: TColor;
    FRounded: Boolean;
    FRoundWithParentColor: Boolean;
    FShowCaption: Boolean;
    FStyle: TSCButtonStyle;
    FModalResult: TModalResult;
    FMultiline: Boolean;
    FFontColor: TColor;
    FPopArrowColor: TColor;
    FInnerRect: TRect;
    FImgOffset: TPoint;
    FTxtOffset: TPoint;
    FPopOffset: TPoint;
    FMousePressed: Boolean;
    FOnStateChange: TNotifyEvent;
    procedure SetAllowAllUp(Value: Boolean);
    procedure SetArrowColor(Value: TColor);
    procedure SetCenter(Value: Boolean);
    procedure SetDown(Value: Boolean);
    procedure SetDropdownMenu(Value: TPopupMenu);
    procedure SetGradient(Value: TSCButtonGradient);
    procedure SetGroupIndex(Value: Integer);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHottrackColor(Value: TColor);
    procedure SetLayout(Value: TSCButtonLayout);
    procedure SetPopupArrow(Value: Boolean);
    procedure SetRepeatClick(Value: Boolean);
    procedure SetRepeatInterval(Value: Integer);
    procedure SetRoundColor(Value: TColor);
    procedure SetRounded(Value: Boolean);
    procedure SetRoundWithParentColor(Value: Boolean);
    procedure SetShowCaption(Value: Boolean);
    procedure SetStyle(Value: TSCButtonStyle);
    procedure SetMultiline(Value: Boolean);

    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;

    procedure CMButtonPressed(var Message: TMessage); message CM_BUTTONPRESSED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;

    procedure CMParentColorChanged(var Message: TMessage); message CM_PARENTCOLORCHANGED;

    function  CanDoUp: Boolean;
    procedure UpdateGroupDown;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure Timer; override;

    function  IsTransparent: Boolean; override;

    function  PopupDropdownMenu: Boolean;
    function  CheckMenuDropdown: Boolean;

    procedure StopTracking; override;
    procedure MouseInControlChanged; override;
    procedure SpacingChanged; override;
    procedure EnabledChanged; override;

    procedure StartRepeat;
    procedure StopRepeat;
    function  CanRepeat: Boolean;

    function  GetGradientShadow(AColor: TColor): TColor;
    function  GetGradientDark(AColor: TColor): TColor;
    function  GetGradientLight(AColor: TColor): TColor;
    function  GetGradientExDark(AColor: TColor): TColor;
    function  GetGradientExLight(AColor: TColor): TColor;
    function  GetGradientPeal(AColor: TColor): TColor;
    function  GetGradientPreDark(AColor: TColor): TColor;
    function  GetGradientPreLight(AColor: TColor): TColor;
    function  GetGradientHighLight(AColor: TColor): TColor;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure DrawPopupArrow(R: TRect; AColor: TColor = clNone);
    procedure DrawImageAndText(var R: TRect; FontColor: TColor = clNone);

    procedure DoDrawCorel;
    procedure DoDrawFlatMacSpeed;
    procedure DoDrawHower;
    procedure DoDrawMacSpeed;
    procedure DoDrawNew;
    procedure DoDrawOfficeXP;
    procedure DoDrawRaisedShadow;
    procedure DoDrawSpeed;
    procedure DoDrawWin2k;
    procedure DoDrawXP;
    procedure DoDrawOffice12;
    procedure DoDrawOffice2003;
    procedure DoDrawDarkling;
    procedure DoDrawMetal;

    property AllowAllUp: Boolean read FAllowAllUp write SetAllowAllUp default False;
    property ArrowColor: TColor read FArrowColor write SetArrowColor default clBtnText;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Center: Boolean read FCenter write SetCenter default True;
    property Color default clBtnFace;
    property Gradient: TSCButtonGradient read FGradient write SetGradient default scbgTopToBottom;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property Down: Boolean read FDown write SetDown default False;
    property DropdownMenu: TPopupMenu read FDropdownMenu write SetDropdownMenu;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default SC_HighlightColor;
    property HottrackColor: TColor read FHottrackColor write SetHottrackColor default SC_HottrackColor;
    property Layout: TSCButtonLayout read FLayout write SetLayout default scblLeft;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property Multiline: Boolean read FMultiline write SetMultiline default False;
    property ParentColor default False;
    property PopupArrow: Boolean read FPopupArrow write SetPopupArrow default False;
    property RepeatClick: Boolean read FRepeatClick write SetRepeatClick default False;
    property RepeatInterval: Integer read FRepeatInterval write SetRepeatInterval default 50;
    property RoundColor: TColor read FRoundColor write SetRoundColor default clBtnFace;
    property Rounded: Boolean read FRounded write SetRounded default True;
    property RoundWithParentColor: Boolean read FRoundWithParentColor write SetRoundWithParentColor default True;
    property ShowCaption: Boolean read FShowCaption write SetShowCaption default True;
    property Style: TSCButtonStyle read FStyle write SetStyle default scbsWin2k;
    property OnStateChange: TNotifyEvent read FOnStateChange write FOnStateChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Click; override;
    function  UseRightToLeftAlignment: Boolean; override;
  end;

  TSCSpeedButton = class(TSCCustomGraphicButton)
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
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropdownMenu;
    property Enabled;
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
    property OnStateChange;
  end;
  
implementation

type
  TColoredControl = class(TControl);

{ TSCGraphicButtonBase }

procedure TSCGraphicButtonBase.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCGraphicButtonBase then
  begin
    with TSCGraphicButtonBase(Source) do
    begin
      Self.EndEllipsis := EndEllipsis;
      Self.Interval := Interval;
    end;
  end;
end;

constructor TSCGraphicButtonBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEndEllipsis := True;
  FInterval := 50;
{$IFDEF SC_DELPHI6_UP}
{$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}
  FWindowHandle := AllocateHWnd(WndProc);
{$IFDEF SC_DELPHI6_UP}
{$WARN SYMBOL_DEPRECATED ON}
{$ENDIF}
  Transparent := False;
end;

destructor TSCGraphicButtonBase.Destroy;
begin
{$IFDEF SC_DELPHI6_UP}
{$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}
  DeallocateHWnd(FWindowHandle);
{$IFDEF SC_DELPHI6_UP}
{$WARN SYMBOL_DEPRECATED ON}
{$ENDIF}
  FWindowHandle := 0;
  inherited Destroy;
end;

procedure TSCGraphicButtonBase.DoMouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  FDblClicked := ssDouble in Shift;
  inherited DoMouseDown(Button, Shift, X, Y);
end;

procedure TSCGraphicButtonBase.DoMouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if FDblClicked then
  begin
    FDblClicked := False;
    Click;
  end;

  inherited DoMouseUp(Button, Shift, X, Y);
end;

procedure TSCGraphicButtonBase.DoTimer;
begin
  if Enabled and FTimerEnabled and not IsDesigning then
    Timer;
end;

function TSCGraphicButtonBase.GetBorderPropsClass: TSCGraphicBorderPropsClass;
begin
  Result := TSCGraphicButtonBorderProps;
end;

function TSCGraphicButtonBase.GetInterval: Integer;
begin
  Result := FInterval;
end;

procedure TSCGraphicButtonBase.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    Invalidate;
  end;
end;

function TSCCustomGraphicButton.CanDoUp: Boolean;
var
  I: Integer;
  Control: TControl;
begin
  Result := FAllowAllUp or (FGroupIndex = 0);

  if not Result and (Parent <> nil) then
    with Parent do
      for I := 0 to ControlCount - 1 do
      begin
        Control := Controls[I];
        if (Control <> Self) and (Control is TSCCustomGraphicButton) then
          with TSCCustomGraphicButton(Control) do
            if FGroupIndex = Self.FGroupIndex then
            begin
              Result := Down;
              if Result then Exit;
            end;
      end;
end;

procedure TSCCustomGraphicButton.Click;
var
  Form: TCustomForm;
begin
  if Parent <> nil then
  begin
    Form := GetParentForm(Self);
    if Form <> nil then
      Form.ModalResult := ModalResult;
  end;
  inherited Click;
end;

procedure TSCCustomGraphicButton.CMButtonPressed(var Message: TMessage);
var
  Sender: TSCCustomGraphicButton;
begin
  if Message.WParam = FGroupIndex then
  begin
    Sender := TSCCustomGraphicButton(Message.LParam);

    if Sender <> Self then
    begin
      if Sender.Down and FDown then
      begin
        FDown := False;
        Invalidate;
      end;

      FAllowAllUp := Sender.AllowAllUp;
    end;
  end;
end;

procedure TSCCustomGraphicButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) then
    begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TSCCustomGraphicButton.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
    if  (CharCode = VK_ESCAPE) and FCancel and
      (KeyDataToShiftState(Message.KeyData) = []) then
    begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TSCCustomGraphicButton.CMParentColorChanged(var Message: TMessage);
begin
  inherited;

  if FRoundWithParentColor then
  begin
    if Message.wParam <> 0 then
      SetRoundColor(TColor(Message.lParam)) else
      SetRoundColor(TColoredControl(Parent).Color);
    FRoundWithParentColor := True;
  end;
end;

constructor TSCCustomGraphicButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csSetCaption, csOpaque, csDoubleClicks];
  SetBounds(Left, Top, 72, 25);
  DoubleBuffered := True;
  ParentColor := False;
  Color := clBtnFace;

  FAllowAllUp := False;
  FArrowColor := clBtnText;
  FCenter := True;
  FDown := False;
  FGradient := scbgTopToBottom;
  FGroupIndex := 0;
  FHighlightColor := SC_HighlightColor;
  FHottrackColor := SC_HottrackColor;
  FLayout := scblLeft;
  FPopupArrow := False;
  FRepeatInterval := 50;
  FRoundColor := clBtnFace;
  FRounded := True;
  FRoundWithParentColor := True;
  FShowCaption := True;
  FStyle := scbsWin2k;
end;

procedure TSCCustomGraphicButton.DoDrawCorel;
var
  CR, R: TRect;
  TopColor, BtmColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  if not Transparent then
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if not FDown then
        Brush.Color := Self.Color
      else begin
        if IsColorLight(Self.Color) then
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
        else
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);
      end;

      FillRect(R);
    end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -3, -3);

  if Enabled and not FDown and (FGroupIndex = 0) and FMousePressed then
    InflateRect(FInnerRect, -1, -1);

  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  R := CR;
  if Enabled and ((FDown and (FMousePressed or MouseInControl)) or
    (FMousePressed and MouseInControl)) then
  begin
    if not FDown and (FGroupIndex = 0) and FMousePressed then
    begin
      TopColor := Get3DDkShadowOf(Self.Color);
      BtmColor := TopColor;

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);

      TopColor := GetBtnShadowOf(Self.Color);
      BtmColor := GetBtnHighlightOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    end else
    begin
      TopColor := GetBtnShadowOf(Self.Color);
      BtmColor := GetBtnHighlightOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);

      TopColor := Get3DDkShadowOf(Self.Color);
      BtmColor := BlendedColor(Self.Color, 16, 16, 16, True);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    end;
  end else
  if FDown and (not Enabled or not (FMousePressed or MouseInControl)) then
  begin
    TopColor := GetBtnShadowOf(Self.Color);
    BtmColor := GetBtnHighlightOf(Self.Color);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
  end else
  begin
    if Enabled and (FGroupIndex = 0) and FMousePressed then
    begin
      TopColor := Get3DDkShadowOf(Self.Color);
      BtmColor := TopColor;

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    end;

    if Enabled and ((FMousePressed and not MouseInControl) or
      (not FMousePressed and MouseInControl)) then
    begin
      TopColor := GetBtnHighlightOf(Self.Color);
      BtmColor := Get3DDkShadowOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);

      TopColor := BlendedColor(Self.Color, 16, 16, 16, True);
      BtmColor := GetBtnShadowOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    end else
    begin
      TopColor := GetBtnHighlightOf(Self.Color);
      BtmColor := GetBtnShadowOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    end;
  end;
end;

procedure TSCCustomGraphicButton.DoDrawFlatMacSpeed;
var
  CR, R: TRect;
  RoundBy: Integer;
  TopColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  if not Transparent then
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if FDown then
      begin
        if not (Enabled and FMousePressed and MouseInControl) then
          Brush.Color := Self.Color
        else
        if IsColorLight(Self.Color) then
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
        else
          Brush.Color := BlendedColor(Self.Color, 96, 96, 96, True);
      end else
      begin
        if IsColorLight(Self.Color) then
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
        else
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);
      end;

      FillRect(R);
    end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -3, -3);

  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  RoundBy := 0;
  if FRounded then RoundBy := 4;

  if IsDesigning or FDown or (Enabled and
    (FMousePressed or MouseInControl)) then
  begin
    R := CR;
    TopColor := GetBtnShadowOf(Self.Color);
    scFrame3D(Canvas, R, TopColor, TopColor, 1, RoundBy);
  end;

  if FRounded and not Transparent then
  begin
    R := CR;
    SCFillCorners(Canvas, R, FRoundColor, RoundBy);
  end;
end;

procedure TSCCustomGraphicButton.DoDrawHower;
var
  CR, R: TRect;
  FC, C: TColor;
  Rd, I: Integer;
  RoundBy: Integer;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  FInnerRect := CR;
  InflateRect(FInnerRect, -6, -6);

  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  C := Self.Color;
  if Enabled and not FMousePressed and MouseInControl then
    C := FHottrackColor
  else
  if Enabled and FMousePressed and not MouseInControl then
    C := FHighlightColor;

  if FDown then
  begin
    if IsColorLight(Self.Color) then
      C := BlendedColor(C, 24, 24, 24, False)
    else
      C := BlendedColor(C, 24, 24, 24, True);
  end;

  R := CR;
  if Transparent then
    InflateRect(R, -4, -4)
  else begin
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if FRounded and not Transparent then
      begin
        Brush.Color := FRoundColor;
        FillRect(R);
      end;

      InflateRect(R, -4, -4);

      Brush.Color := C;
      FillRect(R);
    end;
  end;

  RoundBy := 0; Rd := 0;
  if FRounded then
  begin
    RoundBy := 2;
    Rd := RoundBy + 2;
  end;

  FC := BlendedColor(C, 16, 16, 16, True);
  for I := 0 to 3 do
  begin
    R := CR;
    InflateRect(R, I - 3, I - 3);

    scFrame3D(Canvas, R, FC, FC, 1, Rd);

    if FRounded then
    begin
      InflateRect(R, 1, 1);
      scFrame3D(Canvas, R, FC, FC, 1, Rd + 2);
    end;  

    FC := BlendedColor(FC, 12, 12, 12, True);
  end;

  R := CR;
  InflateRect(R, -4, -4);

  FC := BlendedColor(C, 64, 64, 64, False);
  scFrame3D(Canvas, R, FC, FC, 1, RoundBy);
end;

procedure TSCCustomGraphicButton.DoDrawMacSpeed;
var
  CR, R: TRect;
  RoundBy: Integer;
  TopColor, BtmColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  if not Transparent then
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if FDown then
      begin
        if not (Enabled and FMousePressed and MouseInControl) then
          Brush.Color := Self.Color
        else
        if IsColorLight(Self.Color) then
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
        else
          Brush.Color := BlendedColor(Self.Color, 96, 96, 96, True);
      end else
      begin
        if IsColorLight(Self.Color) then
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
        else
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);
      end;

      FillRect(R);
    end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -3, -3);

  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  RoundBy := 0;
  if FRounded then RoundBy := 4;

  R := CR;
  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    TopColor := GetBtnShadowOf(Self.Color);
    BtmColor := GetBtnHighlightOf(Self.Color);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, RoundBy);
  end else
  begin
    TopColor := GetBtnHighlightOf(Self.Color);
    BtmColor := GetBtnShadowOf(Self.Color);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, RoundBy);
  end;

  if FRounded and not Transparent then
  begin
    R := CR;
    SCFillCorners(Canvas, R, FRoundColor, RoundBy);
  end;
end;

procedure TSCCustomGraphicButton.DoDrawNew;
var
  CR, R: TRect;
  Round1, Round2, Round3: Integer;
  DownState, Track: Boolean;
  BtmColor, TopColor,
  FrameColor, FaceColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;

  FInnerRect := CR;
  InflateRect(FInnerRect, -5, -5);

  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  Round1 := 0; Round2 := 0; Round3 := 0;
  if FRounded then
  begin
    Round1 := 4;
    Round2 := 2;
    Round3 := 0;
  end;

  // face
  FaceColor := Self.Color;
  if FDown then
    FaceColor := BlendedColor(Self.Color, 24, 24, 24, True)
  else
  if Enabled and FMousePressed and MouseInControl then
    FaceColor := BlendedColor(Self.Color, 8, 8, 8, False);

  if not Transparent then
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := FaceColor;

      FillRect(R);
    end;

  // outter sunken frame
  TopColor := BlendedColor(clBtnFace, 16, 16, 16, False);
  BtmColor := BlendedColor(clBtnFace, 48, 48, 48, True);

  scFrame3D(Canvas, R, TopColor, BtmColor, 1, Round1);

  // outter frame
  TopColor := BlendedColor(Self.Color, 144, 144, 144, False);
  BtmColor := BlendedColor(TopColor, 16, 16, 16, True);

  scFrame3D(Canvas, R, TopColor, BtmColor, 1, Round1);

  // highligh or hottrack frame
  Track := False;
  FrameColor := Self.Color;

  if Enabled and not FMousePressed and MouseInControl then
  begin
    Track := True;
    FrameColor := FHottrackColor;
  end else
  if Enabled and FMousePressed then
  begin
    Track := True;
    FrameColor := FHighlightColor;
  end;

  DownState := FDown or (Enabled and not FDown and
    FMousePressed and MouseInControl);

  TopColor := BlendedColor(FrameColor, 16, 16, 16, True);
  if DownState and Track then
    BtmColor := TopColor
  else
    BtmColor := BlendedColor(FrameColor, 40, 40, 40, False);

  if Track then
  begin
    TopColor := BlendedColor(TopColor, 32, 32, 32, True);
    BtmColor := BlendedColor(BtmColor, 32, 32, 32, True);
  end;

  scFrame3D(Canvas, R, TopColor, BtmColor, 1, Round2);
  if Track then
    scFrame3D(Canvas, R, TopColor, BtmColor, 1, Round3)
  else
  if not DownState then
  begin
    TopColor := BlendedColor(TopColor, 4, 4, 4, False);
    BtmColor := BlendedColor(BtmColor, 12, 12, 12, True);

    InflateRect(R, 1, 0);
    scFrame3D(Canvas, R, TopColor, BtmColor, 1, Round3);

    TopColor := BlendedColor(TopColor, 4, 4, 4, False);
    BtmColor := BlendedColor(BtmColor, 12, 12, 12, True);

    InflateRect(R, 1, 0);
    scFrame3D(Canvas, R, TopColor, BtmColor, 1, Round3);
  end;  

  if FRounded and not Transparent then
  begin
    R := CR;
    SCFillCorners(Canvas, R, FRoundColor, Round1);
  end;
end;

procedure TSCCustomGraphicButton.DoDrawOfficeXP;
var
  CR, R: TRect;
  IsDefaultColor: Boolean;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  FFontColor := clBtnText;
  FPopArrowColor := clBtnText;

  IsDefaultColor := False;

  R := CR;

  with Canvas do
  begin
    Brush.Style := bsSolid;

    if FDown then
    begin
      if Enabled and (FMousePressed or MouseInControl) then
      begin
        Brush.Color := GetOfficeXPDownedSelColor;

        FFontColor := clHighlightText;
        FPopArrowColor := clHighlightText;
      end else
        Brush.Color := GetOfficeXPDownedColor;
    end else
    if Enabled and FMousePressed and MouseInControl then
    begin
      Brush.Color := GetOfficeXPDownedSelColor;

      FFontColor := clHighlightText;
      FPopArrowColor := clHighlightText;
    end else
    if Enabled and (FMousePressed or MouseInControl) then
      Brush.Color := GetOfficeXPSelColor
    else begin
      Brush.Color := GetOfficeXPBtnColor;
      IsDefaultColor := True;
    end;

    if not (Transparent and IsDefaultColor) then
      FillRect(R);
  end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -3, -3);

  if Enabled and ((MouseInControl and not FMousePressed) or
    (FMousePressed and not MouseInControl)) then
  begin
    FImgOffset := Point(-1, -1);
    FTxtOffset := Point(0, 0);
    FPopOffset := Point(0, 0);
  end;

  R := CR;
  if FDown or (Enabled and (FMousePressed or MouseInControl)) then
    scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
end;

procedure TSCCustomGraphicButton.DoDrawRaisedShadow;
var
  CR, R, MainR: TRect;
  FaceColor, TopColor: TColor;
  UpMode: Boolean;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  MainR := CR;

  if not Transparent then
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := FRoundColor;

      FillRect(MainR);
    end;

  Dec(MainR.Right, 2);
  Dec(MainR.Bottom, 2);

  if IsRectEmpty(MainR) then
    Exit;

  UpMode := not FDown and Enabled and ((not FMousePressed and MouseInControl) or
     (FMousePressed and not MouseInControl));

  if not UpMode then
    OffsetRect(MainR, 2, 2);

  R := MainR;
  with Canvas do
  begin
    Brush.Style := bsSolid;

    if not Enabled or not (FDown or FMousePressed or MouseInControl) then
      FaceColor := Self.Color
    else begin
      UpMode := True;
      if IsColorLight(Self.Color) then
        FaceColor := BlendedColor(Self.Color, 32, 32, 32, False)
      else
        FaceColor := BlendedColor(Self.Color, 48, 48, 48, True);
    end;

    Brush.Color := FaceColor;
    if UpMode or not Transparent then
      FillRect(R);
  end;

  FInnerRect := MainR;
  InflateRect(FInnerRect, -3, -3);

  if Enabled and (MouseInControl or
    (FMousePressed and not MouseInControl)) then
  begin
    FImgOffset := Point(0, 0);
    FTxtOffset := Point(0, 0);
    FPopOffset := Point(0, 0);
  end;

  if UpMode then
  begin
    R := CR;

    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Width := 1;
      Pen.Color := GetBtnShadowOf(clBtnFace);

      MoveTo(R.Left  + 2, R.Bottom - 2);
      LineTo(R.Right - 2, R.Bottom - 2);
      LineTo(R.Right - 2, R.Top);

      MoveTo(R.Left  + 2, R.Bottom - 1);
      LineTo(R.Right - 1, R.Bottom - 1);
      LineTo(R.Right - 1, R.Top);
    end;
  end;

  R := MainR;
  TopColor := GetBtnShadowOf(FaceColor);
  scFrame3D(Canvas, R, TopColor, TopColor, 1, 0);
end;

procedure TSCCustomGraphicButton.DoDrawSpeed;
var
  CR, R: TRect;
  RoundBy: Integer;
  TopColor, BtmColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  if not Transparent then
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if not FDown then
        Brush.Color := Self.Color
      else
      if IsColorLight(Self.Color) then
        Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
      else
        Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);

      FillRect(R);
    end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -3, -3);

  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  RoundBy := 0;
  if FRounded then RoundBy := 4;

  R := CR;
  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    TopColor := GetBtnShadowOf(Self.Color);
    BtmColor := GetBtnHighlightOf(Self.Color);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, RoundBy);
  end else
  if IsDesigning or (Enabled and MouseInControl) then
  begin
    TopColor := GetBtnHighlightOf(Self.Color);
    BtmColor := GetBtnShadowOf(Self.Color);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, RoundBy);
  end;

  if FRounded and not Transparent then
  begin
    R := CR;
    SCFillCorners(Canvas, R, FRoundColor, RoundBy);
  end;
end;

procedure TSCCustomGraphicButton.DoDrawWin2k;
var
  CR, R: TRect;
  FrameDrawn: Boolean;
  TopColor, BtmColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  if not Transparent then
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if not FDown then
        Brush.Color := Self.Color
      else
      if IsColorLight(Self.Color) then
        Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
      else
        Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);

      FillRect(R);
    end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -3, -3);

  if Enabled and not FDown and (FGroupIndex = 0) and FMousePressed then
    InflateRect(FInnerRect, -1, -1);

  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  R := CR;
  if FDown or (Enabled and (FGroupIndex <> 0) and
    FMousePressed and MouseInControl) then
  begin
    TopColor := GetBtnShadowOf(Self.Color);
    BtmColor := GetBtnHighlightOf(Self.Color);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);

    TopColor := Get3DDkShadowOf(Self.Color);
    BtmColor := BlendedColor(Self.Color, 16, 16, 16, True);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
  end else
  begin
    FrameDrawn := False;
    if Enabled and (FGroupIndex = 0) and FMousePressed then
    begin
      FrameDrawn := True;
      scFrame3D(Canvas, R, clWindowFrame, clWindowFrame, 1, 0);
    end;

    if Enabled and FMousePressed and MouseInControl then
    begin
      if not FrameDrawn then
      begin
        TopColor := Get3DDkShadowOf(Self.Color);
        scFrame3D(Canvas, R, TopColor, TopColor, 1, 0);
      end;  

      BtmColor := GetBtnShadowOf(Self.Color);
      scFrame3D(Canvas, R, BtmColor, BtmColor, 1, 0);
    end else
    begin
      TopColor := GetBtnHighlightOf(Self.Color);
      BtmColor := Get3DDkShadowOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);

      TopColor := BlendedColor(Self.Color, 16, 16, 16, True);
      BtmColor := GetBtnShadowOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    end;
  end;
end;

procedure TSCCustomGraphicButton.DoDrawXP;
var
  CR, R: TRect;
  Track: Boolean;
  GradOrient: TSCGradient;
  BtmColor, TopColor,
  TrackColor, CornerColor1, CornerColor2: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;

  FInnerRect := CR;
  InflateRect(FInnerRect, -5, -5);

  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  GradOrient := scgTopToBottom;
  if FGradient = scbgLeftToRight then GradOrient := scgLeftToRight;

  // outter sunken frame
  TopColor := BlendedColor(clBtnFace, 16, 16, 16, False);
  BtmColor := BlendedColor(clBtnFace, 48, 48, 48, True);

  scDrawGradient(Canvas, R, GradOrient, TopColor, BtmColor);

  if FRounded and not IsRectEmpty(R) then
    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := FRoundColor;

      MoveTo(R.Left, R.Top);
      LineTo(R.Left + 1, R.Top);
      MoveTo(R.Right - 1, R.Top);
      LineTo(R.Right, R.Top);

      MoveTo(R.Left, R.Bottom - 1);
      LineTo(R.Left + 1, R.Bottom - 1);
      MoveTo(R.Right - 1, R.Bottom - 1);
      LineTo(R.Right, R.Bottom - 1);
    end;

  InflateRect(R, -1, -1);

  CornerColor1 := TopColor;
  CornerColor2 := BtmColor;

  // outter frame
  TopColor := BlendedColor(Self.Color, 144, 144, 144, False);
  BtmColor := BlendedColor(TopColor, 16, 16, 16, True);

  scDrawGradient(Canvas, R, GradOrient, TopColor, BtmColor);

  if FRounded and not IsRectEmpty(R) then
    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := CornerColor1;

      MoveTo(R.Left, R.Top);
      LineTo(R.Left + 1, R.Top);
      MoveTo(R.Right - 1, R.Top);
      LineTo(R.Right, R.Top);

      Pen.Color := CornerColor2;

      MoveTo(R.Left, R.Bottom - 1);
      LineTo(R.Left + 1, R.Bottom - 1);
      MoveTo(R.Right - 1, R.Bottom - 1);
      LineTo(R.Right, R.Bottom - 1);
    end;

  InflateRect(R, -1, -1);

  CornerColor1 := BlendedColor(TopColor, 64, 64, 64, True);
  CornerColor2 := BlendedColor(BtmColor, 64, 64, 64, True);

  // highligh or hottrack frame
  Track := False;
  TrackColor := clNone;

  if Enabled and not FMousePressed and MouseInControl then
  begin
    Track := True;
    TrackColor := FHottrackColor;
  end else
  if Enabled and FMousePressed and not MouseInControl then
  begin
    Track := True;
    TrackColor := FHighlightColor;
  end;

  if Enabled and Track then
  begin
    if FDown or (FMousePressed and MouseInControl) then
    begin
      TopColor := BlendedColor(TrackColor, 16, 16, 16, False);
      BtmColor := BlendedColor(TrackColor, 16, 16, 16, True);
    end else
    begin
      TopColor := BlendedColor(TrackColor, 64, 64, 64, True);
      BtmColor := BlendedColor(TrackColor, 16, 16, 16, False);
    end;

    scDrawGradient(Canvas, R, GradOrient, TopColor, BtmColor);
    InflateRect(R, -2, -2);
  end;

  // face
  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    TopColor := BlendedColor(Self.Color, 24, 24, 24, True);
    BtmColor := BlendedColor(Self.Color, 48, 48, 48, True);
  end else
  begin
    TopColor := BlendedColor(Self.Color, 48, 48, 48, True);
    BtmColor := BlendedColor(Self.Color, 24, 24, 24, False);
  end;

  scDrawGradient(Canvas, R, GradOrient, TopColor, BtmColor);

  if not Track and not IsRectEmpty(R) then
    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Color := TopColor;

      MoveTo(R.Left, R.Top);
      LineTo(R.Left, R.Bottom);

      MoveTo(R.Right - 1, R.Top);
      LineTo(R.Right - 1, R.Bottom);
    end;

  if FRounded then
  begin
    R := CR;
    InflateRect(R, -1, -1);

    if not IsRectEmpty(R) then
      with Canvas do
      begin
        Pen.Style := psSolid;
        Pen.Width := 1;

        Pen.Color := CornerColor1;

        MoveTo(R.Left + 1, R.Top);
        LineTo(R.Left - 1, R.Top + 2);
        MoveTo(R.Right - 2, R.Top);
        LineTo(R.Right, R.Top + 2);

        Pen.Color := CornerColor2;

        MoveTo(R.Left, R.Bottom - 2);
        LineTo(R.Left + 2, R.Bottom);
        MoveTo(R.Right - 1, R.Bottom - 2);
        LineTo(R.Right - 3, R.Bottom);

        InflateRect(R, -1, -1);

        CornerColor1 := BlendedColor(CornerColor1, 32, 32, 32, False);
        CornerColor2 := BlendedColor(CornerColor2, 32, 32, 32, False);

        Pen.Color := CornerColor1;

        MoveTo(R.Left, R.Top);
        LineTo(R.Left + 1, R.Top);
        MoveTo(R.Right - 1, R.Top);
        LineTo(R.Right, R.Top);

        Pen.Color := CornerColor2;

        MoveTo(R.Left, R.Bottom - 1);
        LineTo(R.Left + 1, R.Bottom - 1);
        MoveTo(R.Right - 1, R.Bottom - 1);
        LineTo(R.Right, R.Bottom - 1);
      end;
  end;
end;

procedure TSCCustomGraphicButton.DrawImageAndText(var R: TRect; FontColor: TColor);
var
  Text: String;
  Img: TImageIndex;
  ImgR, TxtR: TRect;
  ImageValid: Boolean;
  SR, ImgW, ImgH, TxtW,
  X, Y, TxtH, TxtFlags: Integer;
  AImageList: TCustomImageList;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  Canvas.Font.Assign(Self.Font);

  if FontColor = clNone then
    FontColor := FFontColor;

  if FLayout = scblRight then
  begin
    Dec(R.Right, Indent);
    TxtFlags := DT_RIGHT;
  end else
  begin
    Inc(R.Left, Indent);
    TxtFlags := DT_LEFT;
  end;

  if not IsRectEmpty(R) then
  begin
    SR := IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
    try
      if SR <> NULLREGION then
      begin
        ImgW := 0;
        ImgH := 0;

        Img := GetImageIndex;
        AImageList := GetImages;

        ImageValid := (AImageList <> nil) and IsValidImage(Img);
        
        if ImageValid then
        begin
          ImgW := AImageList.Width;
          ImgH := AImageList.Height;

          if FShowCaption then
          begin
            if FLayout in [scblLeft, scblRight] then
              Inc(ImgW, Spacing)
            else
              Inc(ImgH, Spacing);
          end;    
        end;

        Text := '';
        TxtFlags := TxtFlags or DT_TOP;

        if FEndEllipsis then
          TxtFlags := TxtFlags or DT_END_ELLIPSIS;

        TxtFlags := DrawTextBiDiModeFlags(TxtFlags);

        TxtR := Rect(0, 0, 0, 0);

        if FShowCaption then
        begin
          Text := Caption;

          TxtR := R;
          if FLayout = scblLeft then
            Inc(TxtR.Left, ImgW)
          else
          if FLayout = scblRight then
            Dec(TxtR.Right, ImgW)
          else
            Inc(TxtR.Top, ImgH);
    
          OffsetRect(TxtR, -TxtR.Left, -TxtR.Top);

          if IsRectEmpty(TxtR) then
          begin
            TxtR.Left := TxtR.Right;
            TxtR.Top  := TxtR.Bottom;
          end else
          begin
            if not FMultiline then
              TxtFlags := TxtFlags or DT_SINGLELINE
            else TxtFlags := TxtFlags or DT_WORDBREAK;

            DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, DT_CALCRECT or TxtFlags);
          end;
        end;

        OffsetRect(TxtR, -TxtR.Left, -TxtR.Top);

        TxtW := TxtR.Right;
        TxtH := TxtR.Bottom;

        case FLayout of
          scblLeft:
          begin
            ImgR := R;
            if FCenter then
            begin
              ImgR.Left := R.Left + ((R.Right - R.Left) - ImgW - TxtW) div 2;
              if (FShowCaption or not FCenter) and (ImgR.Left < R.Left) then
                ImgR.Left := R.Left;
            end;

            if ImageValid then
            begin
              ImgR.Top := R.Top + ((R.Bottom - R.Top) - ImgH) div 2;

              X := FImgOffset.x + ImgR.Left;
              Y := FImgOffset.y + ImgR.Top;

              AImageList.Draw(Canvas, X, Y, Img, Enabled);
            end;
            ImgR.Right := ImgR.Left + ImgW;

            OffsetRect(TxtR, ImgR.Right, 0);

            if TxtR.Left < ImgR.Left then TxtR.Left := ImgR.Right;
            if TxtR.Right > R.Right then TxtR.Right := R.Right;

            if FShowCaption then
            begin
              TxtR.Top := R.Top + ((R.Bottom - R.Top) - TxtH) div 2;
              TxtR.Bottom := R.Bottom;

              IntersectRect(TxtR, TxtR, R);
              OffsetRect(TxtR, FTxtOffset.x, FTxtOffset.y);

              if not IsRectEmpty(TxtR) then
              begin
                with Canvas do
                begin
                  Brush.Style := bsClear;

                  Font := Self.Font;
                  Font.Color := FontColor;
                end;

                if not Enabled then
                begin
                  OffsetRect(TxtR, 1, 1);
                  Canvas.Font.Color := clBtnHighlight;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);

                  OffsetRect(TxtR, -1, -1);
                  Canvas.Font.Color := clBtnShadow;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
                end else
                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
              end;
            end;

            R.Right := TxtR.Right;
          end;
          scblTop:
          begin
            ImgR := R;
            if FCenter then
            begin
              ImgR.Left := R.Left + ((R.Right - R.Left) - ImgW) div 2;
              if (FShowCaption or not FCenter) and (ImgR.Left < R.Left) then
                ImgR.Left := R.Left;
            end;

            if ImageValid then
            begin
              ImgR.Top := R.Top + ((R.Bottom - R.Top) - ImgH - TxtH) div 2;

              X := FImgOffset.x + ImgR.Left;
              Y := FImgOffset.y + ImgR.Top;

              AImageList.Draw(Canvas, X, Y, Img, Enabled);

              ImgR.Bottom := ImgR.Top + ImgH;
            end else
            begin
              ImgR.Top := R.Top + ((R.Bottom - R.Top) - TxtH) div 2;
              ImgR.Bottom := ImgR.Top;
            end;

            ImgR.Right := ImgR.Left + ImgW;

            OffsetRect(TxtR, R.Left, 0);

            if FCenter then
            begin
              OffsetRect(TxtR, ((R.Right - R.Left) - TxtW) div 2, 0);
              if TxtR.Left < R.Left then TxtR.Left := R.Left;
            end;

            if TxtR.Right > R.Right then TxtR.Right := R.Right;

            if FShowCaption then
            begin
              OffsetRect(TxtR, 0, ImgR.Bottom);
              if TxtR.Bottom > R.Bottom then
                TxtR.Bottom := R.Bottom;

              IntersectRect(TxtR, TxtR, R);
              OffsetRect(TxtR, FTxtOffset.x, FTxtOffset.y);

              if not IsRectEmpty(TxtR) then
              begin
                with Canvas do
                begin
                  Brush.Style := bsClear;

                  Font := Self.Font;
                  Font.Color := FontColor;
                end;

                if FCenter then TxtFlags := TxtFlags or DT_CENTER;
          
                if not Enabled then
                begin
                  OffsetRect(TxtR, 1, 1);
                  Canvas.Font.Color := clBtnHighlight;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);

                  OffsetRect(TxtR, -1, -1);
                  Canvas.Font.Color := clBtnShadow;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
                end else
                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
              end;
            end;

            R := ImgR;
          end;
          scblRight:
          begin
            ImgR := R;
            if FCenter then
            begin
              ImgR.Right := R.Right - ((R.Right - R.Left) - ImgW - TxtW) div 2;
              if (FShowCaption or not FCenter) and (ImgR.Right > R.Right) then
                ImgR.Right := R.Right;
                
              ImgR.Left := ImgR.Right - ImgW;
            end;

            ImgR.Left := ImgR.Right - ImgW;
            if ImageValid then
            begin
              ImgR.Top := R.Top + ((R.Bottom - R.Top) - ImgH) div 2;

              X := FImgOffset.x + ImgR.Left;
              if FShowCaption then Inc(X, Spacing);

              Y := FImgOffset.y + ImgR.Top;

              AImageList.Draw(Canvas, X, Y, Img, Enabled);
            end;

            TxtR.Left := R.Left;
            TxtR.Right := ImgR.Left;
            if FShowCaption then Inc(TxtR.Right, Spacing);

            if TxtR.Right > ImgR.Left then TxtR.Right := ImgR.Left;
            if TxtR.Left < R.Left then TxtR.Left  := R.Left;

            if FShowCaption then
            begin
              TxtR.Top := R.Top + ((R.Bottom - R.Top) - TxtH) div 2;
              TxtR.Bottom := R.Bottom;

              IntersectRect(TxtR, TxtR, R);
              OffsetRect(TxtR, FTxtOffset.x, FTxtOffset.y);

              if not IsRectEmpty(TxtR) then
              begin
                with Canvas do
                begin
                  Brush.Style := bsClear;

                  Font := Self.Font;
                  Font.Color := FontColor;
                end;

                if not Enabled then
                begin
                  OffsetRect(TxtR, 1, 1);
                  Canvas.Font.Color := clBtnHighlight;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);

                  OffsetRect(TxtR, -1, -1);
                  Canvas.Font.Color := clBtnShadow;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
                end else
                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
              end;
            end;

            R.Left := TxtR.Left;
          end;
          scblBottom:
          begin
            ImgR := R;
            if FCenter then
            begin
              ImgR.Left := R.Left + ((R.Right - R.Left) - ImgW) div 2;
              if (FShowCaption or not FCenter) and (ImgR.Left < R.Left) then
                ImgR.Left := R.Left;
            end;

            if ImageValid then
            begin
              ImgR.Bottom := R.Bottom - ((R.Bottom - R.Top) - ImgH - TxtH) div 2;
              ImgR.Top := ImgR.Bottom - ImgH;

              X := FImgOffset.x + ImgR.Left;

              Y := FImgOffset.y + ImgR.Top;
              if FShowCaption then Inc(Y, Spacing);

              AImageList.Draw(Canvas, X, Y, Img, Enabled);
            end else
            begin
              ImgR.Bottom := R.Bottom - ((R.Bottom - R.Top) - TxtH) div 2;
              ImgR.Top := ImgR.Bottom;
            end;

            ImgR.Right := ImgR.Left + ImgW;

            OffsetRect(TxtR, R.Left, 0);

            if FCenter then
            begin
              OffsetRect(TxtR, ((R.Right - R.Left) - TxtW) div 2, 0);
              if TxtR.Left < R.Left then TxtR.Left := R.Left;
            end;

            if TxtR.Right > R.Right then TxtR.Right := R.Right;

            if FShowCaption then
            begin
              TxtR.Bottom := ImgR.Top;
              TxtR.Top := TxtR.Bottom - TxtH;

              if TxtR.Bottom > R.Bottom then
                TxtR.Bottom := R.Bottom;

              IntersectRect(TxtR, TxtR, R);
              OffsetRect(TxtR, FTxtOffset.x, FTxtOffset.y);

              if not IsRectEmpty(TxtR) then
              begin
                with Canvas do
                begin
                  Brush.Style := bsClear;

                  Font := Self.Font;
                  Font.Color := FontColor;
                end;

                if FCenter then TxtFlags := TxtFlags or DT_CENTER;

                if not Enabled then
                begin
                  OffsetRect(TxtR, 1, 1);
                  Canvas.Font.Color := clBtnHighlight;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);

                  OffsetRect(TxtR, -1, -1);
                  Canvas.Font.Color := clBtnShadow;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
                end else
                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
              end;
            end;

            R := ImgR;
          end;
        end;
      end;
    finally
      SelectClipRgn(Canvas.Handle, 0);
    end;
  end;
end;

procedure TSCCustomGraphicButton.DrawPopupArrow(R: TRect; AColor: TColor);
var
  P: TPoint;
  Rgn: HRGN;
begin
  if (Canvas = nil) or IsRectEmpty(R) or
    not CanGetClientRect then Exit;

  if AColor = clNone then
    AColor := FPopArrowColor;

  Rgn := CreateRectRgnIndirect(R);
  try
    SelectClipRgn(Canvas.Handle, Rgn);

    if FLayout = scblRight then
      P.x := R.Left + 4 + FPopOffset.x
    else
      P.x := R.Right - 4 + FPopOffset.x;

    P.y := R.Top + ((R.Bottom - R.Top) div 2) + 2 + FPopOffset.y;

    SCDrawUpSlider(Canvas, P, 4, 2, sctsMac, False, AColor);
  finally
    SelectClipRgn(Canvas.Handle, 0);
    DeleteObject(Rgn);
  end;
end;

procedure TSCCustomGraphicButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  FMousePressed := False;
  if Enabled then
  begin
    FMousePressed := Button = mbLeft;

    if FMousePressed then
    begin
      Invalidate;
      StartRepeat;
    end;
  end;
end;

procedure TSCCustomGraphicButton.MouseInControlChanged;
begin
  if Enabled then
  begin
    if MouseInControl then
      StartRepeat
    else
      StopRepeat;

    if FMousePressed or (FStyle <> scbsWin2k) then
      Invalidate;
  end;    
end;

procedure TSCCustomGraphicButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  WasDown: Boolean;
begin
  StopRepeat;

  if Enabled and (FMousePressed or MouseIsDown) then
  begin
    FMousePressed := False;

    if (FGroupIndex = 0) or not MouseInControl then
    begin
      Invalidate;
      if MouseInControl and PopupDropdownMenu then
        Exit;
    end else
    begin
      WasDown := Down;
      Down := not WasDown;
      if WasDown = Down then
        Invalidate;
    end;
  end;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomGraphicButton.Paint;
var
  CR, R: TRect;
begin
  CR := ClientRect;

  FFontColor := Font.Color;
  FPopArrowColor := FArrowColor;

  FInnerRect := CR;

  FImgOffset := Point(0, 0);
  FTxtOffset := Point(0, 0);
  FPopOffset := Point(0, 0);

  case FStyle of
    scbsCorel:
      DoDrawCorel;
    scbsFlatMacSpeed:
      DoDrawFlatMacSpeed;
    scbsHower:
      DoDrawHower;
    scbsMacSpeed:
      DoDrawMacSpeed;
    scbsNew:
      DoDrawNew;
    scbsOfficeXP:
      DoDrawOfficeXP;
    scbsRaisedShadow:
      DoDrawRaisedShadow;
    scbsSpeed:
      DoDrawSpeed;
    scbsWin2k:
      DoDrawWin2k;
    scbsXP:
      DoDrawXP;
    scbsOffice12:
      DoDrawOffice12;
    scbsOffice2003:
      DoDrawOffice2003;
    scbsDarkling:
      DoDrawDarkling;
    scbsMetal:
      DoDrawMetal;
    else  
      DoDrawWin2k;
  end;

  R := FInnerRect;
  if not FShowCaption and FCenter then R := CR;

  DrawImageAndText(R);

  if FPopupArrow then
  begin
    InflateRect(R, 12, 12);
    IntersectRect(R, R, FInnerRect);

    DrawPopupArrow(R);
  end;

  R := ClientRect;
  if not (FStyle in [scbsNew, scbsXP, scbsCorel, scbsWin2k, scbsOffice2003]) then
    InflateRect(R, -2, -2)
  else begin
    InflateRect(R, -3, -3);

    if (FStyle in [scbsCorel, scbsWin2k]) and
      not FDown and (FGroupIndex = 0) and FMousePressed then
      InflateRect(R, -1, -1);
  end;
end;

procedure TSCCustomGraphicButton.SetAllowAllUp(Value: Boolean);
begin
  if FAllowAllUp <> Value then
  begin
    FAllowAllUp := Value;
    UpdateGroupDown;
  end;
end;

procedure TSCCustomGraphicButton.SetArrowColor(Value: TColor);
begin
  if FArrowColor <> Value then
  begin
    FArrowColor := Value;
    if FPopupArrow then Invalidate;
  end;
end;

procedure TSCCustomGraphicButton.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    Invalidate;
  end;
end;

type
  TFakeFocusControl = class(TWinControl);

procedure TSCCustomGraphicButton.SetDown(Value: Boolean);
begin
  if Value then
    Value := FGroupIndex <> 0
  else
  if FDown and not Value then
    Value := not CanDoUp;

  if FDown <> Value then
  begin
    FDown := Value;
    Invalidate;

    UpdateGroupDown;

    if Assigned(FOnStateChange) then
      FOnStateChange(Self);
  end;
end;

procedure TSCCustomGraphicButton.SetGradient(Value: TSCButtonGradient);
begin
  if FGradient <> Value then
  begin
    FGradient := Value;
    if FStyle in [scbsXP, scbsOffice2003] then
      Invalidate;
  end;
end;

procedure TSCCustomGraphicButton.SetGroupIndex(Value: Integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    Invalidate;

    UpdateGroupDown;
  end;
end;

procedure TSCCustomGraphicButton.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;

    if Enabled and (FStyle in [scbsXP,
      scbsOffice12, scbsOffice2003]) then
      Invalidate;
  end;
end;

procedure TSCCustomGraphicButton.SetHottrackColor(Value: TColor);
begin
  if FHottrackColor <> Value then
  begin
    FHottrackColor := Value;

    if Enabled and (FStyle in [scbsXP,
      scbsOffice12, scbsOffice2003]) then
      Invalidate;
  end;
end;

procedure TSCCustomGraphicButton.SetLayout(Value: TSCButtonLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TSCCustomGraphicButton.SetMultiline(Value: Boolean);
begin
  if FMultiline <> Value then
  begin
    FMultiline := Value;
    Invalidate;
  end;
end;

procedure TSCCustomGraphicButton.SetPopupArrow(Value: Boolean);
begin
  if FPopupArrow <> Value then
  begin
    FPopupArrow := Value;
    Invalidate;
  end;
end;

procedure TSCCustomGraphicButton.SetRoundColor(Value: TColor);
begin
  if FRoundColor <> Value then
  begin
    FRoundColor := Value;
    FRoundWithParentColor := False;
    if FRounded then
      Invalidate;
  end;
end;

procedure TSCCustomGraphicButton.SetRounded(Value: Boolean);
begin
  if FRounded <> Value then
  begin
    FRounded := Value;
    Invalidate;
  end;
end;

procedure TSCCustomGraphicButton.SetRoundWithParentColor(Value: Boolean);
begin
  if FRoundWithParentColor <> Value then
  begin
    FRoundWithParentColor := Value;
    if Value and FRounded and (Parent <> nil) then
      Perform(CM_PARENTCOLORCHANGED, 0, 0);
  end;
end;

procedure TSCCustomGraphicButton.SetShowCaption(Value: Boolean);
begin
  if FShowCaption <> Value then
  begin
    FShowCaption := Value;
    Invalidate;
  end;
end;

procedure TSCCustomGraphicButton.SetStyle(Value: TSCButtonStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TSCCustomGraphicButton.StopTracking;
begin
  FMousePressed := False;
  Invalidate;
  StopRepeat;
  inherited StopTracking;
end;

procedure TSCCustomGraphicButton.UpdateGroupDown;
var
  Msg: TMessage;
begin
  if (FGroupIndex <> 0) and (Parent <> nil) then
  begin
    Msg.Msg := CM_BUTTONPRESSED;
    Msg.WParam := FGroupIndex;
    Msg.LParam := Longint(Self);
    Msg.Result := 0;
    Parent.Broadcast(Msg);
  end;
end;

function TSCCustomGraphicButton.UseRightToLeftAlignment: Boolean;
begin
  Result := False;
end;

procedure TSCCustomGraphicButton.SpacingChanged;
begin
  Invalidate;
end;

procedure TSCCustomGraphicButton.SetRepeatClick(Value: Boolean);
begin
  if FRepeatClick <> Value then
  begin
    FRepeatClick := Value;
    StartRepeat;
  end;
end;

procedure TSCCustomGraphicButton.SetRepeatInterval(Value: Integer);
begin
  if Value < 10 then Value := 10;
  FRepeatInterval := Value;
end;

procedure TSCCustomGraphicButton.StartRepeat;
begin
  if CanRepeat then
  begin
    Interval := GetDoubleClickTime;
    StartTimer;
  end;
end;

procedure TSCCustomGraphicButton.StopRepeat;
begin
  StopTimer;
  Invalidate;
end;

procedure TSCCustomGraphicButton.Timer;
begin
  if Enabled then
  begin
    Interval := FRepeatInterval;
    Click;
  end;
end;

function TSCCustomGraphicButton.CanRepeat: Boolean;
begin
  Result := Enabled and FRepeatClick and FMousePressed and
    MouseInControl and not IsDesigning;
end;

destructor TSCCustomGraphicButton.Destroy;
begin
  StopRepeat;
  inherited Destroy;
end;

procedure TSCCustomGraphicButton.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TSCCustomGraphicButton.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then Click;
end;

procedure TSCCustomGraphicButton.SetDropdownMenu(Value: TPopupMenu);
begin
  if FDropdownMenu <> Value then
  begin
    FDropdownMenu := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;
end;

procedure TSCCustomGraphicButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DropdownMenu) then
    DropdownMenu := nil;
end;

function TSCCustomGraphicButton.CheckMenuDropdown: Boolean;
begin
  Result := not IsDesigning and not RepeatClick and
    (DropdownMenu <> nil) and (DropdownMenu.Items.Count > 0);
end;

function TSCCustomGraphicButton.PopupDropdownMenu: Boolean;
var
  P: TPoint;
  Bs: Integer;
begin
  Result := CheckMenuDropdown;
  if not Result then
    Exit;

  Bs := GetBorderSize + GetInnerBorderSize +
    TSCGraphicButtonBorderProps(BorderProps).Width;
    
  if Bs < 0 then Bs := 0;

  P := Point(-Bs, ClientHeight + Bs);
  P := Self.ClientToScreen(P);

  SendCancelMode(nil);
  DropdownMenu.Popup(P.x, P.y);
  
  UpdateTracking;
  Invalidate;
end;

procedure TSCCustomGraphicButton.EnabledChanged;
begin
  FMousePressed := False;
  Invalidate;
  StopRepeat;
  inherited EnabledChanged;
end;

procedure TSCGraphicButtonBase.SetInterval(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FInterval <> Value then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

procedure TSCGraphicButtonBase.StartTimer;
begin
  FTimerEnabled := True;
  UpdateTimer;
end;

procedure TSCGraphicButtonBase.StopTimer;
begin
  FTimerEnabled := False;
  UpdateTimer;
end;

procedure TSCGraphicButtonBase.Timer;
begin
  //
end;

procedure TSCGraphicButtonBase.UpdateTimer;
var
  I: Integer;
begin
  KillTimer(FWindowHandle, 1);

  I := Interval;
  if Enabled and FTimerEnabled and (I > 0) and not IsDesigning then
    SetTimer(FWindowHandle, 1, I, nil);
end;

procedure TSCGraphicButtonBase.WndProc(var Message: TMessage);
begin
  if Message.Msg <> WM_TIMER then
    inherited WndProc(Message)
  else begin
    try
      DoTimer;
    except
      Application.HandleException(Self);
    end
  end;
end;

function TSCCustomGraphicButton.IsTransparent: Boolean;
begin
  Result := Transparent and not (FStyle in
    [scbsXP, scbsOffice12, scbsOffice2003]);
end;

procedure TSCCustomGraphicButton.DoDrawOffice2003;
var
  CR, R: TRect;
  IsDefault: Boolean;
  GradOrient: TSCGradient;
  BtmColor, TopColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;

  FFontColor := clBtnText;
  FPopArrowColor := clBtnText;

  IsDefault := False;

  with Canvas do
  begin
    Brush.Style := bsSolid;

    if FDown then
    begin
      if Enabled and (FMousePressed or MouseInControl) then
      begin
        Brush.Color := GetOfficeXPDownedSelColor;

        FFontColor := clHighlightText;
        FPopArrowColor := clHighlightText;
      end else
        Brush.Color := GetOfficeXPDownedColor;
    end else
    if Enabled and FMousePressed and MouseInControl then
    begin
      Brush.Color := GetOfficeXPDownedSelColor;

      FFontColor := clHighlightText;
      FPopArrowColor := clHighlightText;
    end else
    if Enabled and (FMousePressed or MouseInControl) then
      Brush.Color := GetOfficeXPSelColor
    else begin
      Brush.Color := GetOfficeXPBtnColor;
      IsDefault := True;
    end;

    FillRect(R);
  end;

  FInnerRect := CR;
  
  if IsDefault then
  begin
    GradOrient := scgTopToBottom;
    if FGradient = scbgLeftToRight then GradOrient := scgLeftToRight;

    TopColor := BlendedColor(Self.Color, 48, 48, 48, True);
    BtmColor := BlendedColor(Self.Color, 24, 24, 24, False);

    scDrawGradient(Canvas, R, GradOrient, TopColor, BtmColor);
  end;

  if (MouseInControl and not FMousePressed) or
    (FMousePressed and not MouseInControl) then
  begin
    FImgOffset := Point(0, 0);
    FTxtOffset := Point(0, 0);
    FPopOffset := Point(0, 0);
  end;

  R := CR;
  if not IsDefault and (FDown or FMousePressed or MouseInControl) then
    scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
end;

procedure TSCCustomGraphicButton.DoDrawDarkling;
var
  C: TColor;
  CR, R: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  FInnerRect := CR;
  InflateRect(FInnerRect, -1, -1);

  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  C := Self.Color;
  if Enabled and not FMousePressed and MouseInControl then
    C := FHottrackColor
  else
  if Enabled and FMousePressed and not MouseInControl then
    C := FHighlightColor;

  if FDown then
  begin
    if IsColorLight(Self.Color) then
      C := BlendedColor(C, 24, 24, 24, False)
    else
      C := BlendedColor(C, 24, 24, 24, True);
  end;

  R := CR;
  InflateRect(R, -1, -1);
  
  if not Transparent then
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := C;
      FillRect(R);
    end;

  R := CR;

  C := BlendedColor(C, 64, 64, 64, False);
  scFrame3D(Canvas, R, C, C, 1, 0);
end;

procedure TSCCustomGraphicButton.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomGraphicButton then
  begin
    with TSCCustomGraphicButton(Source) do
    begin
      Self.AllowAllUp := AllowAllUp;
      Self.ArrowColor := ArrowColor;
      Self.Cancel := Cancel;
      Self.Center := Center;
      Self.Gradient := Gradient;
      Self.GroupIndex := GroupIndex;
      Self.Down := Down;
      Self.DropdownMenu := DropdownMenu;
      Self.HighlightColor := HighlightColor;
      Self.HottrackColor := HottrackColor;
      Self.Layout := Layout;
      Self.ModalResult := ModalResult;
      Self.Multiline := Multiline;
      Self.PopupArrow := PopupArrow;
      Self.RepeatClick := RepeatClick;
      Self.RepeatInterval := RepeatInterval;
      Self.RoundColor := RoundColor;
      Self.Rounded := Rounded;
      Self.RoundWithParentColor := RoundWithParentColor;
      Self.ShowCaption := ShowCaption;
      Self.Style := Style;
    end;
  end;
end;

procedure TSCCustomGraphicButton.DoDrawMetal;
var
  CR, R: TRect;
  FaceColor, TopColor, BtmColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  FaceColor := Self.Color;

  if not Transparent then
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if not FDown then
        FaceColor := Self.Color
      else
      if IsColorLight(Self.Color) then
        FaceColor := BlendedColor(Self.Color, 24, 24, 24, False)
      else
        FaceColor := BlendedColor(Self.Color, 24, 24, 24, True);

      Brush.Color := FaceColor;
      FillRect(R);
    end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -3, -3);

  if Enabled and not FDown and (FGroupIndex = 0) and FMousePressed then
    InflateRect(FInnerRect, -1, -1);

  if FDown or (Enabled and FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  R := CR;

  TopColor := GetBtnShadowOf(Self.Color);
  scFrame3D(Canvas, R, TopColor, TopColor, 1, 0);

  if FDown or (Enabled and (FGroupIndex <> 0) and
    FMousePressed and MouseInControl) then
  begin
    TopColor := FaceColor;
    BtmColor := SCCommon.scBlendColor(FaceColor, 64);
  end else
  if Enabled and FMousePressed and MouseInControl then
  begin
    TopColor := Self.Color;
    BtmColor := SCCommon.scBlendColor(FaceColor, 64);
  end else
  begin
    TopColor := SCCommon.scBlendColor(FaceColor, 64);
    BtmColor := Self.Color;
  end;

  scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
end;

procedure TSCCustomGraphicButton.DoDrawOffice12;
var
  CR, R, ARect: TRect;
  AColor, ClStart, ClEnd: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  ARect := CR;

  AColor := GetDefaultBackColor;
  FFontColor := GetDefaultForeColor;
  FPopArrowColor := clBtnText;

  if FDown or FMousePressed or MouseInControl then
  begin
    AColor := FHottrackColor;
    if MouseInControl and FMousePressed then
      AColor := FHighlightColor;

    if AColor = clNone then
      AColor := GetDefaultBackColor
    else AColor := BlendedColor(AColor, 24, 24, 24, True);

    if FDown then
    begin
      if MouseInControl or (MouseInControl and FMousePressed) then
        AColor := scBlendColor(AColor, -12)
      else
        AColor := scBlendColor(AColor, 20);
    end else
    if MouseInControl and FMousePressed then
      AColor := scBlendColor(AColor, -16)
    else
    if MouseInControl or FMousePressed then
      AColor := scBlendColor(AColor, -6);
  end;

  with Canvas do
  begin
    Brush.Color := AColor;
    Brush.Style := bsSolid;

    FillRect(ARect);
  end;

  ClEnd := AColor;
  ClStart := GetGradientPreLight(AColor);

  R := ARect;
  Dec(R.Bottom, Round((R.Bottom - R.Top)/4));

  scDrawGradient(Canvas, R, scgTopToBottom, ClStart, ClEnd);

  R := ARect;
  Inc(R.Top, (R.Bottom - R.Top) div 2);

  if not IsRectEmpty(R) then
  begin
    ClStart := GetGradientDark(AColor);
    ClEnd := GetGradientLight(AColor);

    scDrawGradient(Canvas, R, scgTopToBottom, ClStart, ClEnd);
  end;

  R := ARect;
  InflateRect(R, -1, -1);

  ClStart := GetGradientPreLight(AColor);
  scFrame3D(Canvas, R, ClStart, ClStart, 1, 0);

  R := ARect;

  ClStart := GetGradientPreDark(AColor);
  scFrame3D(Canvas, R, ClStart, ClStart, 1, 0);

  FInnerRect := CR;
  InflateRect(FInnerRect, -3, -3);

  if (MouseInControl and not FMousePressed) or
    (FMousePressed and not MouseInControl) then
  begin
    FImgOffset := Point(0, 0);
    FTxtOffset := Point(0, 0);
    FPopOffset := Point(0, 0);
  end;
end;

function TSCCustomGraphicButton.GetGradientDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -16);
end;

function TSCCustomGraphicButton.GetGradientExDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -40);
end;

function TSCCustomGraphicButton.GetGradientExLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 40);
end;

function TSCCustomGraphicButton.GetGradientLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 30);
end;

function TSCCustomGraphicButton.GetGradientPeal(AColor: TColor): TColor;
begin
  Result := BlendedColor(AColor, 52, 44, 112, True);
end;

function TSCCustomGraphicButton.GetGradientPreDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -80);
end;

function TSCCustomGraphicButton.GetGradientPreLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 100);
end;

function TSCCustomGraphicButton.GetGradientShadow(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -6);
end;

function TSCCustomGraphicButton.GetGradientHighLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 120);
end;

{$I SCVerRec.inc}

end.

