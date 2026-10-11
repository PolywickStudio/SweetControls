{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCTrackbar;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCommon, SCConsts, SCControl;

type
  TSCCustomTrackbar = class;

  TSCOrientation = (sctoHorizontal, sctoVertical);
  TSCTrackStyle = (scthImage, scthMac, scthMetal, scthNew, scthPS,
    scthPSNew, scthWindows);

  TSCTrackAlign = (sctaLeftToRight, sctaRightToLeft);
  TSCTrackLinePosition = (sclpBottomRight, sclpTopLeft, sclpBoth);

  TSCTrackProgressStyle = (sctp3D, sctpClassic, sctpGradient3D,
    sctpGradientFull, sctpGradientComplementary, sctpMetal, sctpOffice12,
    sctpRaised, sctpSliced, sctpSlicedGradient, sctpXP);

  TSCTrackbarPaintEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; var Handled: Boolean) of object;

  TSCTrackbarProgress = class(TPersistent)
  private
    FOwner: TSCCustomTrackbar;
    function  GetBkColor: TColor;
    procedure SetBkColor(Value: TColor);
    function  GetBorder: TSCControlBorder;
    procedure SetBorder(Value: TSCControlBorder);
    function  GetBorderColor: TColor;
    procedure SetBorderColor(Value: TColor);
    function  GetColor: TColor;
    procedure SetColor(Value: TColor);
    function  GetEndColor: TColor;
    procedure SetEndColor(Value: TColor);
    function  GetHeight: Integer;
    procedure SetHeight(Value: Integer);
    function  GetSlice: Integer;
    procedure SetSlice(Value: Integer);
    function  GetStyle: TSCTrackProgressStyle;
    procedure SetStyle(Value: TSCTrackProgressStyle);
  public
    constructor Create(AOwner: TSCCustomTrackbar); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property BkColor: TColor read GetBkColor write SetBkColor default clWindow;
    property Border: TSCControlBorder read GetBorder write SetBorder default sccb3DLowered;
    property BorderColor: TColor read GetBorderColor write SetBorderColor default cl3DDkShadow;
    property Color: TColor read GetColor write SetColor default clHighlight;
    property EndColor: TColor read GetEndColor write SetEndColor default clAqua;
    property Height: Integer read GetHeight write SetHeight default 12;
    property Slice: Integer read GetSlice write SetSlice default 10;
    property Style: TSCTrackProgressStyle read GetStyle write SetStyle default sctpClassic;
  end;

  TSCTrackbarSlider = class(TPersistent)
  private
    FOwner: TSCCustomTrackbar;
    function  GetColor: TColor;
    procedure SetColor(Value: TColor);
    function  GetFocusColor: TColor;
    procedure SetFocusColor(Value: TColor);
    function  GetFrameColor: TColor;
    procedure SetFrameColor(Value: TColor);
    function  GetHottracks: Boolean;
    procedure SetHottracks(Value: Boolean);
    function  GetHotColor: TColor;
    procedure SetHotColor(Value: TColor);
    function  GetOffset: Integer;
    procedure SetOffset(Value: Integer);
    function  GetSize: Integer;
    procedure SetSize(Value: Integer);
    function  GetStyle: TSCTrackStyle;
    procedure SetStyle(Value: TSCTrackStyle);
  public
    constructor Create(AOwner: TSCCustomTrackbar); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Color: TColor read GetColor write SetColor default clBtnFace;
    property FocusColor: TColor read GetFocusColor write SetFocusColor default clHighlight;
    property FrameColor: TColor read GetFrameColor write SetFrameColor default clGreen;
    property Hottracks: Boolean read GetHottracks write SetHottracks default True;
    property HotColor: TColor read GetHotColor write SetHotColor default clBlue;
    property Offset: Integer read GetOffset write SetOffset default 0;
    property Size: Integer read GetSize write SetSize default 4;
    property Style: TSCTrackStyle read GetStyle write SetStyle default scthWindows;
  end;

  TSCSliderStyle = TSCThumbStyle;

  TSCCustomTrackbar = class(TSCCustomControl)
  private
    FAlignment: TSCTrackAlign;
    FFrequency: Integer;
    FLineColor: TColor;
    FLinePosition: TSCTrackLinePosition;
    FLineSize: Integer;
    FMax: Integer;
    FMin: Integer;
    FOrientation: TSCOrientation;
    FPageSize: Integer;
    FPosition: Integer;
    FProgress: TSCTrackbarProgress;
    FProgressBkColor: TColor;
    FProgressBorder: TSCControlBorder;
    FProgressBorderColor: TColor;
    FProgressColor: TColor;
    FProgressEndColor: TColor;
    FProgressSlice: Integer;
    FProgressStyle: TSCTrackProgressStyle;
    FProgressHeight: Integer;
    FShowFocusRect: Boolean;
    FShowLines: Boolean;
    FShowProgress: Boolean;
    FShowSlider: Boolean;
    FSlider: TSCTrackbarSlider;
    FSliderColor: TColor;
    FSliderFocusColor: TColor;
    FSliderFrameColor: TColor;
    FSliderHottracks: Boolean;
    FSliderHotColor: TColor;
    FSliderOffset: Integer;
    FSliderSize: Integer;
    FSliderStyle: TSCTrackStyle;
    FLeftClicked: Boolean;
    FSliderClicked: Boolean;
    FSliderIsHot: Boolean;
    FOnCustomDrawBack: TSCTrackbarPaintEvent;
    FOnCustomDrawLines: TSCTrackbarPaintEvent;
    FOnCustomDrawProgress: TSCTrackbarPaintEvent;
    FOnCustomDrawSlider: TSCTrackbarPaintEvent;
    procedure SetAlignment(Value: TSCTrackAlign);
    procedure SetFrequency(Value:  Integer);
    procedure SetLineColor(Value: TColor);
    procedure SetLinePosition(Value: TSCTrackLinePosition);
    procedure SetMax(Value: Integer);
    procedure SetMin(Value: Integer);
    procedure SetOrientation(Value: TSCOrientation);
    procedure SetProgress(Value: TSCTrackbarProgress);
    procedure SetProgressBkColor(Value: TColor);
    procedure SetProgressBorder(Value: TSCControlBorder);
    procedure SetProgressBorderColor(Value: TColor);
    procedure SetProgressColor(Value: TColor);
    procedure SetProgressEndColor(Value: TColor);
    procedure SetProgressHeight(Value: Integer);
    procedure SetProgressSlice(Value: Integer);
    procedure SetProgressStyle(Value: TSCTrackProgressStyle);
    procedure SetShowFocusRect(Value: Boolean);
    procedure SetShowLines(Value: Boolean);
    procedure SetShowProgress(Value: Boolean);
    procedure SetShowSlider(Value: Boolean);
    procedure SetSlider(Value: TSCTrackbarSlider);
    procedure SetSliderColor(Value: TColor);
    procedure SetSliderFocusColor(Value: TColor);
    procedure SetSliderFrameColor(Value: TColor);
    procedure SetSliderHottracks(Value: Boolean);
    procedure SetSliderHotColor(Value: TColor);
    procedure SetSliderOffset(Value: Integer);
    procedure SetSliderSize(Value: Integer);
    procedure SetSliderStyle(Value: TSCTrackStyle);

    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  protected
    procedure Paint; override;
    procedure Loaded; override;

    function  NormalizePosition(Value: Integer): Integer;
    function  GetPosition: Integer; virtual;
    procedure SetPosition(Value: Integer); virtual;

    procedure DoChange; override;

    function  CanSetValue(var Value: LongInt): Boolean; virtual;
    function  CanSetUserValue(var Value: LongInt): Boolean; virtual;

    procedure ImageListChange(Sender: TObject); override;
    function  GetSliderSize: Integer;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure ProcessTrackKey(Key: Word);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function  GetProgressBorderSize: Integer;
    function  GetProgressRect: TRect; dynamic;
    function  GetSliderRect: TRect; dynamic;

    function  GetGradientShadow(AColor: TColor): TColor;
    function  GetGradientDark(AColor: TColor): TColor;
    function  GetGradientLight(AColor: TColor): TColor;
    function  GetGradientExDark(AColor: TColor): TColor;
    function  GetGradientExLight(AColor: TColor): TColor;
    function  GetGradientPeal(AColor: TColor): TColor;
    function  GetGradientPreDark(AColor: TColor): TColor;
    function  GetGradientPreLight(AColor: TColor): TColor;
    function  GetGradientHighLight(AColor: TColor): TColor;

    procedure DoDrawLines(ACanvas: TCanvas); virtual;
    procedure DoDrawSlider(ACanvas: TCanvas); virtual;
    procedure DoDrawProgress(ACanvas: TCanvas); virtual;
    procedure DoDraw(ACanvas: TCanvas); virtual;

    property Alignment: TSCTrackAlign read FAlignment write SetAlignment default sctaLeftToRight;
    property BlendColor default False;
    property Color default clBtnFace;
    property Frequency: Integer read FFrequency write SetFrequency default 1;
    property LineColor: TColor read FLineColor write SetLineColor default clBtnText;
    property LinePosition: TSCTrackLinePosition read FLinePosition write SetLinePosition default sclpBottomRight;
    property LineSize: Integer read FLineSize write FLineSize default 1;
    property Max: Integer read FMax write SetMax default 10;
    property Min: Integer read FMin write SetMin default 0;
    property Orientation: TSCOrientation read FOrientation write SetOrientation default sctoHorizontal;
    property PageSize: Integer read FPageSize write FPageSize default 2;
    property ParentColor default False;
    property Position: Integer read GetPosition write SetPosition default 0;
    property ProgressBkColor: TColor read FProgressBkColor write SetProgressBkColor default clWindow;
    property ProgressBorder: TSCControlBorder read FProgressBorder write SetProgressBorder default sccb3DLowered;
    property ProgressBorderColor: TColor read FProgressBorderColor write SetProgressBorderColor default cl3DDkShadow;
    property ProgressColor: TColor read FProgressColor write SetProgressColor default clHighlight;
    property ProgressEndColor: TColor read FProgressEndColor write SetProgressEndColor default clAqua;
    property ProgressSlice: Integer read FProgressSlice write SetProgressSlice default 10;
    property ProgressStyle: TSCTrackProgressStyle read FProgressStyle write SetProgressStyle default sctpClassic;
    property ProgressHeight: Integer read FProgressHeight write SetProgressHeight default 12;
    property Progress: TSCTrackbarProgress read FProgress write SetProgress;
    property ShowFocusRect: Boolean read FShowFocusRect write SetShowFocusRect default True;
    property ShowLines: Boolean read FShowLines write SetShowLines default True;
    property ShowProgress: Boolean read FShowProgress write SetShowProgress default True;
    property ShowSlider: Boolean read FShowSlider write SetShowSlider default True;
    property SliderColor: TColor read FSliderColor write SetSliderColor default clBtnFace;
    property SliderFocusColor: TColor read FSliderFocusColor write SetSliderFocusColor default clHighlight;
    property SliderFrameColor: TColor read FSliderFrameColor write SetSliderFrameColor default clGreen;
    property SliderHottracks: Boolean read FSliderHottracks write SetSliderHottracks default True;
    property SliderHotColor: TColor read FSliderHotColor write SetSliderHotColor default clBlue;
    property SliderOffset: Integer read FSliderOffset write SetSliderOffset default 0;
    property SliderSize: Integer read FSliderSize write SetSliderSize default 4;
    property SliderStyle: TSCTrackStyle read FSliderStyle write SetSliderStyle default scthWindows;
    property Slider: TSCTrackbarSlider read FSlider write SetSlider;
    property Spacing default 0;
    property TabStop default True;
    property OnCustomDrawBack: TSCTrackbarPaintEvent read FOnCustomDrawBack
      write FOnCustomDrawBack;
    property OnCustomDrawLines: TSCTrackbarPaintEvent read FOnCustomDrawLines
      write FOnCustomDrawLines;
    property OnCustomDrawProgress: TSCTrackbarPaintEvent read FOnCustomDrawProgress
      write FOnCustomDrawProgress;
    property OnCustomDrawSlider: TSCTrackbarPaintEvent read FOnCustomDrawSlider
      write FOnCustomDrawSlider;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  PtOnSlider(P: TPoint): Boolean;
    function  PositionAtPos(P: TPoint): Integer;
  end;

  TSCTrackbar = class(TSCCustomTrackbar)
  published
    property Align;
    property Alignment;
    property Anchors;
    property BlendColor;
    property BorderProps;
    property Color;
    property Constraints;
    property Cursor;
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
    property Position;
    property Progress;
    property ShowHint;
    property ShowFocusRect;
    property ShowLines;
    property ShowProgress;
    property ShowSlider;
    property Slider;
    property Spacing;
    property TabOrder;
    property TabStop;
    property Transparent;
    property Tag;
    property OnChange;
    property OnClick;
    property OnCanResize;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnCustomDrawBack;
    property OnCustomDrawLines;
    property OnCustomDrawProgress;
    property OnCustomDrawSlider;
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

implementation

{ TSCCustomTrackbar }

procedure TSCCustomTrackbar.CMMouseEnter(var Message: TMessage);
var
  P: TPoint;
  Hot: Boolean;
begin
  if not IsDesigning then
  begin
    GetCursorPos(P);
    P := ScreenToClient(P);

    Hot := FSliderIsHot;
    FSliderIsHot := PtOnSlider(P);

    if (FSliderStyle <> scthImage) and
      FSliderHottracks and (Hot <> FSliderIsHot) then
      Invalidate;
  end;

  inherited;
end;

procedure TSCCustomTrackbar.CMMouseLeave(var Message: TMessage);
var
  Hot: Boolean;
begin
  if not IsDesigning then
  begin
    Hot := FSliderIsHot;
    FSliderIsHot := False;

    if (FSliderStyle <> scthImage) and
      FSliderHottracks and (Hot <> FSliderIsHot) then
      Invalidate;
  end;
  
  inherited;
end;

constructor TSCCustomTrackbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(Left, Top, 150, 45);
  DoubleBuffered := True;
  ClickFocus := True;
  Color := clBtnFace;
  ParentColor := False;
  TabStop := True;
  BlendColor := False;
  Spacing := 0;

  FAlignment := sctaLeftToRight;
  FFrequency := 1;
  FLineColor := clBtnText;
  FLinePosition := sclpBottomRight;
  FLineSize := 1;
  FMax := 10;
  FMin := 0;
  FOrientation := sctoHorizontal;
  FPageSize := 2;
  FPosition := 0;
  FProgressBkColor := clWindow;
  FProgressBorder := sccb3DLowered;
  FProgressBorderColor := cl3DDkShadow;
  FProgressColor := clHighlight;
  FProgressEndColor := clAqua;
  FProgressHeight := 12;
  FProgressSlice := 10;
  FProgressStyle := sctpClassic;
  FShowFocusRect := True;
  FShowLines := True;
  FShowProgress := True;
  FShowSlider := True;
  FSliderColor := clBtnFace;
  FSliderFocusColor := clHighlight;
  FSliderFrameColor := clGreen;
  FSliderHottracks := True;
  FSliderHotColor := clBlue;
  FSliderOffset := 0;
  FSliderSize := 4;
  FSliderStyle := scthWindows;

  FProgress := TSCTrackbarProgress.Create(Self);
  FSlider := TSCTrackbarSlider.Create(Self);
end;

procedure TSCCustomTrackbar.DoChange;
begin
  Invalidate;
end;

procedure TSCCustomTrackbar.DoDrawLines(ACanvas: TCanvas);
var
  C: TColor;
  Handled: Boolean;
  PR, R, CR: TRect;
  Cnt, P, Frq, ThS, I, W, H: Integer;
begin
  if (ACanvas = nil) or not (FShowLines and CanGetClientRect) then
    Exit;

  Cnt := FMax - FMin;
  if Cnt > 0 then
  begin
    PR := GetProgressRect;

    Handled := False;
    if Assigned(FOnCustomDrawLines) then
    begin
      R := PR;
      CR := GetClientRect;

      if FOrientation = sctoHorizontal then
      begin
        R.Top := CR.Top;
        R.Bottom := CR.Bottom;
      end else
      begin
        R.Left := CR.Left;
        R.Right := CR.Right;
      end;

      FOnCustomDrawLines(Self, Canvas, R, Handled);
    end;

    if Handled then
      Exit;

    P := GetProgressBorderSize;
    InflateRect(PR, -P, -P);

    if FOrientation = sctoHorizontal then
      W := PR.Right - PR.Left
    else
      W := PR.Bottom - PR.Top;

    if W <= 0 then Exit;

    ThS := GetSliderSize;

    R := PR;
    if FOrientation = sctoHorizontal then
    begin
      if FSliderStyle <> scthImage then
        InflateRect(R, 0, ThS + FSliderOffset + 4)
      else begin
        InflateRect(R, 0, 6);
        if (Images <> nil) and (FProgressHeight < Images.Height) then
          InflateRect(R, 0, (Images.Height - FProgressHeight) div 2);
      end;

      Dec(R.Top);

      if not FShowSlider then
        InflateRect(R, 0, 2);
    end else
    begin
      if FSliderStyle <> scthImage then
        InflateRect(R, ThS + FSliderOffset + 4, 0)
      else begin
        InflateRect(R, 6, 0);
        if (Images <> nil) and (FProgressHeight < Images.Width) then
          InflateRect(R, (Images.Width - FProgressHeight) div 2, 0);
      end;
        
      Dec(R.Left);

      if not FShowSlider then
        InflateRect(R, 2, 0);
    end;

    C := FLineColor;
    if C = clNone then C := clWindowText;

    with ACanvas do
    begin
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Width := 1;
      Pen.Color := C;

      Frq := FFrequency;
      if Frq < 1 then Frq := 1;

      for I := 0 to Cnt do
      if (Frq = 1) or (I = 0) or
        (I = Cnt) or ((I mod Frq) = 0) then
      begin
        P := MulDiv(I, W, Cnt);

        H := 4;
        if (I > 0) and (I < Cnt) then
          H := 3;

        if FOrientation = sctoHorizontal then
        begin
          if FLinePosition in [sclpBottomRight, sclpBoth] then
          begin
            MoveTo(R.Left + P, R.Bottom);
            LineTo(R.Left + P, R.Bottom + H);
          end;

          if FLinePosition in [sclpTopLeft, sclpBoth] then
          begin
            MoveTo(R.Left + P, R.Top);
            LineTo(R.Left + P, R.Top - H);
          end;
        end else
        begin
          if FLinePosition in [sclpBottomRight, sclpBoth] then
          begin
            MoveTo(R.Right,     R.Top + P);
            LineTo(R.Right + H, R.Top + P);
          end;
          
          if FLinePosition in [sclpTopLeft, sclpBoth] then
          begin
            MoveTo(R.Left,     R.Top + P);
            LineTo(R.Left - H, R.Top + P);
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTrackbar.DoDrawProgress(ACanvas: TCanvas);
var
  DoSlicing, Handled: Boolean;
  CR, R, R2, R3, R4: TRect;
  I, St, W, P, Ps, Pb: Integer;
  C, C1, C2, C3, C4, ClStart, ClEnd: TColor;
begin
  if (ACanvas = nil) or not CanGetClientRect then
    Exit;

  CR := GetProgressRect;

  IntersectRect(R, CR, ClientRect);

  if not (IsRectEmpty(CR) or IsRectEmpty(R)) then
  begin
    Handled := False;
    if Assigned(FOnCustomDrawProgress) then
      FOnCustomDrawProgress(Self, Canvas, CR, Handled);

    if Handled then
      Exit;

    C := FProgressBkColor;
    if (C = clNone) and (FProgressStyle in [sctpGradientComplementary,
      sctpSliced, sctpSlicedGradient, sctpXP, sctpMetal]) then
    begin
      C := Self.Color;
      if C = clNone then C := clBtnFace;
    end;

    if C <> clNone then
      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C;

        R := CR;
        FillRect(R);
      end;

    if FShowProgress then
    begin
      R := CR;

      Pb := GetProgressBorderSize;
      InflateRect(R, -(Pb + Spacing), -(Pb + Spacing));

      if not IsRectEmpty(R) then
      begin
        Ps := NormalizePosition(Position);

        P := 0;
        if FMax - FMin > 0 then
        begin
          if FOrientation = sctoHorizontal then
            W := R.Right - R.Left
          else
            W := R.Bottom - R.Top;

          if W > 0 then
          begin
            P := Ps - FMin;
            P := Round(P * (W / (FMax - FMin)));
          end;
        end;

        if P > 0 then
        begin
          C := FProgressBkColor;
          if C = clNone then C := Self.Color;

          C1 := FProgressColor;
          if C1 = clNone then C1 := C;

          C2 := FProgressEndColor;
          if C2 = clNone then C2 := C;

          R2 := R;
          if FOrientation = sctoHorizontal then
          begin
            if FAlignment = sctaLeftToRight then
              R2.Right := R2.Left + P
            else
              R2.Left := R2.Right - P;
          end else
          begin
            if FAlignment = sctaLeftToRight then
              R2.Bottom := R2.Top + P
            else
              R2.Top := R2.Bottom - P;
          end;

          if not IsRectEmpty(R2) then
            case FProgressStyle of
              sctpRaised, sctpClassic:
              begin
                if C1 <> C then
                  with ACanvas do
                  begin
                    Brush.Style := bsSolid;
                    Brush.Color := C1;

                    FillRect(R2);
                  end;

                if FProgressStyle = sctpRaised then
                begin
                  C3 := SCCommon.scBlendColor(C1, 64);
                  C4 := SCCommon.scBlendColor(C1, -64);

                  scFrame3D(ACanvas, R2, C3, C4, 1, 0);
                end;
              end;
              sctpOffice12:
              begin
                InflateRect(R2, -1, -1);

                if not IsRectEmpty(R) then
                begin
                  with ACanvas do
                  begin
                    Brush.Style := bsSolid;
                    Brush.Color := C1;

                    FillRect(R2);
                  end;

                  ClEnd := C1;
                  ClStart := GetGradientPreLight(C1);

                  if FOrientation = sctoHorizontal then
                  begin
                    R3 := R2;
                    Dec(R3.Bottom, Round((R3.Bottom - R3.Top)/4));

                    scDrawGradient(ACanvas, R3, scgTopToBottom, ClStart, ClEnd);
                  end else
                  begin
                    R3 := R2;
                    Dec(R3.Right, Round((R3.Right - R3.Left)/4));

                    scDrawGradient(ACanvas, R3, scgLeftToRight, ClStart, ClEnd);
                  end;

                    ClStart := GetGradientDark(C1);
                    ClEnd := GetGradientLight(C1);

                  if FOrientation = sctoHorizontal then
                  begin
                    R3 := R2;
                    Inc(R3.Top, (R3.Bottom - R3.Top) div 2);

                    if not IsRectEmpty(R3) then
                      scDrawGradient(ACanvas, R3, scgTopToBottom, ClStart, ClEnd);
                  end else
                  begin
                    R3 := R2;
                    Inc(R3.Left, (R3.Right - R3.Left) div 2);

                    if not IsRectEmpty(R3) then
                      scDrawGradient(ACanvas, R3, scgLeftToRight, ClStart, ClEnd);
                  end;

                  R3 := R2;
                  InflateRect(R3, -1, -1);

                  ClStart := GetGradientPreLight(C1);
                  scFrame3D(ACanvas, R3, ClStart, ClStart, 1, 0);

                  R3 := R2;

                  ClStart := GetGradientPreDark(C1);
                  scFrame3D(ACanvas, R3, ClStart, ClStart, 1, 0);
                end;
              end;
              sctp3D, sctpGradient3D:
              begin
                if C1 <> C then
                  with ACanvas do
                  begin
                    Brush.Style := bsSolid;
                    Brush.Color := C1;

                    FillRect(R2);
                  end;

                R3 := R2;
                if FOrientation = sctoHorizontal then
                  R3.Bottom := R3.Top + ((R3.Bottom - R3.Top) div 2)
                else
                  R3.Right := R3.Left + ((R3.Right - R3.Left) div 2);

                if not IsRectEmpty(R2) then
                begin
                  C3 := SCCommon.scBlendColor(C1, 64);
                  if FOrientation = sctoHorizontal then
                    scDrawGradient(ACanvas, R3, scgTopToBottom, C3, C1)
                  else
                    scDrawGradient(ACanvas, R3, scgLeftToRight, C3, C1);

                  R3 := R2;
                  if FOrientation = sctoHorizontal then
                    R3.Top := R3.Bottom - ((R3.Bottom - R3.Top) div 2)
                  else
                    R3.Left := R3.Right - ((R3.Right - R3.Left) div 2);

                  C4 := SCCommon.scBlendColor(C1, -64);
                  if FOrientation = sctoHorizontal then
                    scDrawGradient(ACanvas, R3, scgTopToBottom, C1, C4)
                  else
                    scDrawGradient(ACanvas, R3, scgLeftToRight, C1, C4);

                  if FProgressStyle = sctp3D then
                  begin
                    R3 := R2;
                    scFrame3D(ACanvas, R3, C3, C4, 1, 0);

                    C3 := SCCommon.scBlendColor(C1, 48);
                    C4 := SCCommon.scBlendColor(C1, -48);

                    scFrame3D(ACanvas, R3, C3, C4, 1, 0);
                  end;
                end;
              end;
              sctpSliced, sctpSlicedGradient,
              sctpXP, sctpMetal:
              begin
                InflateRect(R2, -1, -1);

                if not IsRectEmpty(R2) and ((FProgressStyle in [sctpXP, sctpMetal]) or
                   ((C1 <> C) and (FProgressStyle = sctpSliced)) or
                   (((C1 <> C) or (C2 <> C)) and (FProgressStyle = sctpSlicedGradient))) then
                begin
                  with ACanvas do
                  begin
                    Brush.Style := bsSolid;
                    Brush.Color := C1;

                    FillRect(R2);
                  end;

                  if FProgressStyle in [sctpXP, sctpMetal] then
                  begin
                    R3 := R2;
                    if FOrientation = sctoHorizontal then
                      R3.Bottom := R3.Top + ((R3.Bottom - R3.Top) div 2)
                    else
                      R3.Right := R3.Left + ((R3.Right - R3.Left) div 2);

                    if not IsRectEmpty(R2) then
                    begin
                      C3 := SCCommon.scBlendColor(C1, 128);
                      if FOrientation = sctoHorizontal then
                      begin
                        scDrawGradient(ACanvas, R3, scgTopToBottom, C3, C1);

                        R3 := R2;
                        R3.Top := R3.Bottom - ((R3.Bottom - R3.Top) div 2);

                        scDrawGradient(ACanvas, R3, scgTopToBottom, C1, C3)
                      end else
                      begin
                        scDrawGradient(ACanvas, R3, scgLeftToRight, C3, C1);

                        R3 := R2;
                        R3.Left := R3.Right - ((R3.Right - R3.Left) div 2);

                        scDrawGradient(ACanvas, R3, scgLeftToRight, C1, C3);
                      end;
                    end;
                  end else
                  if FProgressStyle = sctpSlicedGradient then
                  begin
                    R3 := R;
                    InflateRect(R3, -1, -1);

                    if FOrientation = sctoHorizontal then
                      scDrawGradient(ACanvas, R3, scgLeftToRight, C1, C2)
                    else
                      scDrawGradient(ACanvas, R3, scgTopToBottom, C1, C2);

                    R3 := R2;
                    if FOrientation = sctoHorizontal then
                    begin
                      if FAlignment = sctaLeftToRight then
                      begin
                        R3.Left  := R3.Right;
                        R3.Right := R.Right - 1;
                      end else
                      begin
                        R3.Right := R3.Left;
                        R3.Left  := R.Left + 1;
                      end;
                    end else
                    begin
                      if FAlignment = sctaLeftToRight then
                      begin
                        R3.Top := R3.Bottom;
                        R3.Bottom  := R.Top + 1;
                      end else
                      begin
                        R3.Bottom := R3.Top;
                        R3.Top  := R.Bottom - 1;
                      end;
                    end;

                    with ACanvas do
                    begin
                      Brush.Style := bsSolid;
                      Brush.Color := C;

                      FillRect(R3);
                    end;
                  end;
                  
                  DoSlicing := (FProgressSlice > 0) and (Ps > FMin) and
                    (FProgressSlice < P);

                  if DoSlicing then
                  begin
                    with ACanvas do
                    begin
                      Brush.Style := bsSolid;
                      Brush.Color := C;

                      Pen.Width := 1;
                      Pen.Style := psSolid;
                      Pen.Mode  := pmCopy;
                      Pen.Color := C1;
                    end;

                    St := Round((P-2) / (FProgressSlice + 2));

                    if FOrientation = sctoHorizontal then
                    begin
                      if FAlignment = sctaLeftToRight then
                      begin
                        R3 := R2;
                        R3.Right := R3.Left + 2;

                        R4 := R2;
                        R4.Right := R4.Left + FProgressSlice;

                        for I := 0 to St-1 do
                        begin
                          OffsetRect(R3, FProgressSlice, 0);

                          with ACanvas do
                          begin
                            Brush.Style := bsSolid;
                            FillRect(R3);
                          end;  

                          OffsetRect(R3, R3.Right - R3.Left, 0);

                          if (FProgressStyle = sctpMetal) and not IsRectEmpty(R4) then
                          begin
                            with ACanvas do
                            begin
                              Brush.Style := bsClear;
                              Rectangle(R4.Left, R4.Top, R4.Right, R4.Bottom);
                            end;

                            OffsetRect(R4, FProgressSlice + 2, 0);
                          end;
                        end;
                      end else
                      begin
                        R3 := R2;
                        R3.Left := R3.Right - 2;

                        R4 := R2;
                        R4.Left := R4.Right - FProgressSlice;

                        for I := 0 to St-1 do
                        begin
                          OffsetRect(R3, -FProgressSlice, 0);

                          with ACanvas do
                          begin
                            Brush.Style := bsSolid;
                            FillRect(R3);
                          end;

                          OffsetRect(R3, -(R3.Right - R3.Left), 0);

                          if (FProgressStyle = sctpMetal) and not IsRectEmpty(R4) then
                          begin
                            with ACanvas do
                            begin
                              Brush.Style := bsClear;
                              Rectangle(R4.Left, R4.Top, R4.Right, R4.Bottom);
                            end;

                            OffsetRect(R4, -(FProgressSlice + 2), 0);
                          end;
                        end;
                      end;
                    end else
                    begin
                      if FAlignment = sctaLeftToRight then
                      begin
                        R3 := R2;
                        R3.Bottom := R3.Top + 2;

                        R4 := R2;
                        R4.Bottom := R4.Top + FProgressSlice;

                        for I := 0 to St-1 do
                        begin
                          OffsetRect(R3, 0, FProgressSlice);

                          with ACanvas do
                          begin
                            Brush.Style := bsSolid;
                            FillRect(R3);
                          end;

                          OffsetRect(R3, 0, R3.Bottom - R3.Top);

                          if (FProgressStyle = sctpMetal) and not IsRectEmpty(R4) then
                          begin
                            with ACanvas do
                            begin
                              Brush.Style := bsClear;
                              Rectangle(R4.Left, R4.Top, R4.Right, R4.Bottom);
                            end;

                            OffsetRect(R4, 0, FProgressSlice + 2);
                          end;
                        end;
                      end else
                      begin
                        R3 := R2;
                        R3.Top := R3.Bottom - 2;

                        R4 := R2;
                        R4.Top := R4.Bottom - FProgressSlice;

                        for I := 0 to St-1 do
                        begin
                          OffsetRect(R3, 0, -FProgressSlice);

                          with ACanvas do
                          begin
                            Brush.Style := bsSolid;
                            FillRect(R3);
                          end;

                          OffsetRect(R3, 0, -(R3.Bottom - R3.Top));

                          if (FProgressStyle = sctpMetal) and not IsRectEmpty(R4) then
                          begin
                            with ACanvas do
                            begin
                              Brush.Style := bsClear;
                              Rectangle(R4.Left, R4.Top, R4.Right, R4.Bottom);
                            end;

                            OffsetRect(R4, 0, -(FProgressSlice + 2));
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
              sctpGradientFull:
              begin
                if (C1 <> C) or (C2 <> C) then
                begin
                  if FOrientation = sctoHorizontal then
                    scDrawGradient(ACanvas, R2, scgLeftToRight, C1, C2)
                  else
                    scDrawGradient(ACanvas, R2, scgTopToBottom, C1, C2);
                end;
              end;
              sctpGradientComplementary:
              begin
                if (C1 <> C) or (C2 <> C) then
                begin
                  if FOrientation = sctoHorizontal then
                    scDrawGradient(ACanvas, R, scgLeftToRight, C1, C2)
                  else
                    scDrawGradient(ACanvas, R, scgTopToBottom, C1, C2);

                  if FOrientation = sctoHorizontal then
                  begin
                    if FAlignment = sctaLeftToRight then
                    begin
                      R2.Left  := R2.Right;
                      R2.Right := R.Right;
                    end else
                    begin
                      R2.Right := R2.Left;
                      R2.Left  := R.Left;
                    end;
                  end else
                  begin
                    if FAlignment = sctaLeftToRight then
                    begin
                      R2.Top := R2.Bottom;
                      R2.Bottom  := R.Top;
                    end else
                    begin
                      R2.Bottom := R2.Top;
                      R2.Top  := R.Bottom;
                    end;
                  end;

                  with ACanvas do
                  begin
                    Brush.Style := bsSolid;
                    Brush.Color := C;

                    FillRect(R2);
                  end;
                end;
              end;
            end;
        end;
      end;
    end;

    R := CR;
    scDrawEdge(ACanvas, R, FlatColor, clNone, False, FProgressBorder);
  end;
end;

procedure TSCCustomTrackbar.DoDraw(ACanvas: TCanvas);
var
  R: TRect;
  C: TColor;
begin
  if (ACanvas <> nil) and CanGetClientRect then
  begin
    R := ClientRect;
    if IsRectEmpty(R) then Exit;

    if FShowLines then
      DoDrawLines(ACanvas);

    DoDrawProgress(ACanvas);
    DoDrawSlider(ACanvas);

    if FShowFocusRect and Focused then
    begin
      C := Self.Color;
      if Transparent or (C = clNone) then
        C := clBtnFace;

      with ACanvas do
      begin
        Brush.Style := bsClear;
        Brush.Color := C;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C;

        ACanvas.DrawFocusRect(R);
      end;
    end;
  end;
end;

function TSCCustomTrackbar.GetProgressBorderSize: Integer;
begin
  Result := 0;
  if FProgressBorder in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
    Result := 1
  else if FProgressBorder in [sccbFlatBold, sccb3DRaised, sccb3DLowered,
    sccbBumped, sccbEtched, sccbMacLowered, sccbMacRaised, sccbMetal,
    sccbSoftLowered, sccbSoftRaised] then
    Result := 2;
end;

function TSCCustomTrackbar.GetProgressRect: TRect;
var
  Pb, ThS: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if not CanGetClientRect then Exit;

  Result := ClientRect;
  InflateRect(Result, -2, -2);

  if IsRectEmpty(Result) then Exit;

  ThS := GetSliderSize;

  if FOrientation = sctoHorizontal then
  begin
    InflateRect(Result, -(ThS + 6), 0);
    Result.Bottom := Result.Top + FProgressHeight;

    OffsetRect(Result, 0, FSliderOffset + Indent + 4);

    if FSliderStyle = scthImage then
    begin
      OffsetRect(Result, 0, 6);
      if (Images <> nil) and (FProgressHeight < Images.Height) then
        OffsetRect(Result, 0, (Images.Height - FProgressHeight) div 2);
    end else
    begin
      case FLinePosition of
        sclpBottomRight:
          OffsetRect(Result, 0, ThS div 2);
        sclpTopLeft:
          OffsetRect(Result, 0, ThS);
        sclpBoth:
        begin
          if FSliderStyle in [scthWindows, scthMetal, scthPSNew, scthNew] then
            OffsetRect(Result, 0, ThS div 2)
          else
          if FSliderStyle in [scthMac, scthPS] then
            OffsetRect(Result, 0, ThS);
        end;
      end;
    end;

    if FShowLines and (FLinePosition in [sclpTopLeft, sclpBoth]) then
      OffsetRect(Result, 0, 10);

    if not FShowSlider and (FLinePosition in [sclpBoth, sclpTopLeft]) then
      OffsetRect(Result, 0, 2);
  end else
  begin
    InflateRect(Result, 0, -(ThS + 6));
    Result.Right := Result.Left + FProgressHeight;

    OffsetRect(Result, FSliderOffset + Indent + 4, 0);

    if FSliderStyle = scthImage then
    begin
      OffsetRect(Result, 6, 0);
      if (Images <> nil) and (FProgressHeight < Images.Width) then
        OffsetRect(Result, (Images.Width - FProgressHeight) div 2, 0);
    end else
    begin
      case FLinePosition of
        sclpBottomRight:
          OffsetRect(Result, ThS div 2, 0);
        sclpTopLeft:
          OffsetRect(Result, ThS, 0);
        sclpBoth:
        begin
          if FSliderStyle in [scthWindows, scthMetal, scthPSNew, scthNew] then
            OffsetRect(Result, ThS div 2, 0)
          else
          if FSliderStyle in [scthMac, scthPS] then
            OffsetRect(Result, ThS, 0);
        end;
      end;
    end;
    
    if FShowLines and (FLinePosition in [sclpTopLeft, sclpBoth]) then
      OffsetRect(Result, 10, 0);

    if not FShowSlider and (FLinePosition in [sclpBoth, sclpTopLeft]) then
      OffsetRect(Result, 2, 0);
  end;

  Pb := GetProgressBorderSize;
  InflateRect(Result, Pb, Pb);
end;

function TSCCustomTrackbar.GetSliderRect: TRect;
var
  W, P, Ps, Pb, ThS: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if not CanGetClientRect then Exit;

  Result := GetProgressRect;

  Pb := GetProgressBorderSize;
  if FOrientation = sctoHorizontal then
    InflateRect(Result, -Pb, 0)
  else
    InflateRect(Result, 0, -Pb);

  Ps := NormalizePosition(Position);

  P := 0;
  if FMax - FMin > 0 then
  begin
    if FOrientation = sctoHorizontal then
      W := Result.Right - Result.Left
    else
      W := Result.Bottom - Result.Top;

    if W > 0 then
    begin
      P := Ps - FMin;
      P := Round(P * (W / (FMax - FMin)));
    end;
  end;

  ThS := GetSliderSize;

  if FOrientation = sctoHorizontal then
  begin
    if FAlignment = sctaLeftToRight then
    begin
      Dec(Result.Left, ThS);
      Result.Right := Result.Left + 2*ThS;

      OffsetRect(Result, P, 0);
    end else
    begin
      Inc(Result.Right, ThS);
      Result.Left := Result.Right - 2*ThS;

      OffsetRect(Result, -P, 0);
    end;

    if FSliderStyle = scthImage then
    begin
      InflateRect(Result, 0, 6);
      if (Images <> nil) and (FProgressHeight < Images.Height) then
        InflateRect(Result, 0, (Images.Height - FProgressHeight) div 2);
    end else
    begin
      case FLinePosition of
        sclpBottomRight:
        begin
          Dec(Result.Top, ThS div 2);
          Inc(Result.Bottom, ThS);
        end;
        sclpTopLeft:
        begin
          Dec(Result.Top, ThS);
          Inc(Result.Bottom, ThS div 2);
        end;
        sclpBoth:
        begin
          if FSliderStyle in [scthWindows, scthMetal, scthPSNew, scthNew] then
            InflateRect(Result, 0, ThS div 2)
          else
          if FSliderStyle in [scthMac, scthPS] then
            InflateRect(Result, 0, ThS);
        end;
      end;
    end;

    InflateRect(Result, 0, FSliderOffset);
  end else
  begin
    if FAlignment = sctaLeftToRight then
    begin
      Dec(Result.Top, ThS);
      Result.Bottom := Result.Top + 2*ThS;

      OffsetRect(Result, 0, P);
    end else
    begin
      Inc(Result.Bottom, ThS);
      Result.Top := Result.Bottom - 2*ThS;

      OffsetRect(Result, 0, -P);
    end;

    if FSliderStyle = scthImage then
    begin
      InflateRect(Result, 6, 0);
      if (Images <> nil) and (FProgressHeight < Images.Width) then
        InflateRect(Result, (Images.Width - FProgressHeight) div 2, 0);
    end else
    begin
      case FLinePosition of
        sclpBottomRight:
        begin
          Dec(Result.Left, ThS div 2);
          Inc(Result.Right, ThS);
        end;
        sclpTopLeft:
        begin
          Dec(Result.Left, ThS);
          Inc(Result.Right, ThS div 2);
        end;
        sclpBoth:
        begin
          if FSliderStyle in [scthWindows, scthMetal, scthPSNew, scthNew] then
            InflateRect(Result, ThS div 2, 0)
          else
          if FSliderStyle in [scthMac, scthPS] then
            InflateRect(Result, ThS, 0);
        end;
      end;
    end;

    InflateRect(Result, FSliderOffset, 0);
  end;
end;

procedure TSCCustomTrackbar.KeyDown(var Key: Word; Shift: TShiftState);
begin
  ProcessTrackKey(Key);
  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomTrackbar.KeyPress(var Key: Char);
begin
  if not (Ord(Key) in [VK_HOME, VK_END]) then
    ProcessTrackKey(Ord(Key));
  inherited KeyPress(Key);
end;

procedure TSCCustomTrackbar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Ps, P1, P2: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if CanGetFocus and Focused then
  begin
    P1 := NormalizePosition(Position);

    P2 := PositionAtPos(Point(X, Y));
    if CanSetUserValue(P2) then
      Position := P2;

    FSliderIsHot := False;
    FLeftClicked := Button = mbLeft;

    FSliderIsHot := PtOnSlider(Point(X, Y));
    FSliderClicked := FSliderIsHot;

    Ps := NormalizePosition(Position);

    if (FSliderStyle <> scthImage) and (P1 = Ps) and
      FSliderIsHot and FSliderHottracks then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Hot: Boolean;
  Ps, P1, P2: Integer;
begin
  Hot := FSliderIsHot or FSliderClicked;
  FSliderIsHot := PtOnSlider(Point(X, Y));

  P1 := NormalizePosition(Position);
  if FLeftClicked then
  begin
    P2 := PositionAtPos(Point(X, Y));
    if CanSetUserValue(P2) then
      Position := P2;
  end;

  Ps := NormalizePosition(Position);

  if (FSliderStyle <> scthImage) and (P1 = Ps) and
    FSliderHottracks and (Hot <> FSliderIsHot) then
    Invalidate;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomTrackbar.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  Hot: Boolean;
  Ps, P1, P2: Integer;
begin
  Hot := FSliderIsHot or FSliderClicked;

  FSliderClicked := False;
  FSliderIsHot := PtOnSlider(Point(X, Y));

  P1 := NormalizePosition(Position);
  if FLeftClicked then
  begin
    FLeftClicked := False;

    P2 := PositionAtPos(Point(X, Y));
    if CanSetUserValue(P2) then
      Position := P2;
  end;

  Ps := NormalizePosition(Position);

  if (FSliderStyle <> scthImage) and (P1 = Ps) and
    FSliderHottracks and (Hot <> FSliderIsHot) then
    Invalidate;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomTrackbar.Paint;
var
  R: TRect;
  Handled: Boolean;
begin
  if not HandleAllocated then
    Exit;

  R := ClientRect;
  OffsetRect(R, -R.Left, -R.Top);

  if not IsRectEmpty(R) then
  begin
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := GetFaceColor;

      FillRect(R);
    end;

    Handled := False;
    if Assigned(FOnCustomDrawBack) then
      FOnCustomDrawBack(Self, Canvas, R, Handled);

    if not Handled then
    begin
      if Transparent then
        PaintParentOn(Canvas);
      DrawPicture(Canvas);
    end;

    DoDraw(Canvas);
  end;
end;

function TSCCustomTrackbar.PtOnSlider(P: TPoint): Boolean;
var
  R, R2: TRect;
  ThS: Integer;
begin
  Result := False;
  if FShowSlider and CanGetClientRect then
  begin
    R := GetClientRect;

    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      R := GetSliderRect;
      Result := not IsRectEmpty(R) and PtInRect(R, P);

      if Result and (FLinePosition = sclpBoth) and
        (FSliderStyle in [scthMac, scthPS]) then
      begin
        Result := False;

        ThS := GetSliderSize;
        if ThS <= 0 then Exit;

        if FOrientation = sctoHorizontal then
        begin
          R2 := R;

          R2.Bottom := R2.Top + ThS;
          if IsRectEmpty(R2) then Exit;

          Result := PtInRect(R2, P);
          if Result then Exit;

          R2 := R;

          R2.Top := R2.Bottom - ThS;
          if IsRectEmpty(R2) then Exit;

          Result := PtInRect(R2, P);
        end else
        begin
          R2 := R;

          R2.Right := R2.Left + ThS;
          if IsRectEmpty(R2) then Exit;

          Result := PtInRect(R2, P);
          if Result then Exit;

          R2 := R;

          R2.Left := R2.Right - ThS;
          if IsRectEmpty(R2) then Exit;

          Result := PtInRect(R2, P);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTrackbar.ProcessTrackKey(Key: Word);
var
  P1, P2: Integer;
begin
  P1 := NormalizePosition(Position);
  P2 := P1;

  case Key of
    VK_LEFT:
      if FAlignment = sctaLeftToRight then
        Dec(P2, LineSize)
      else
        Inc(P2, LineSize);
    VK_RIGHT:
      if FAlignment = sctaLeftToRight then
        Inc(P2, LineSize)
      else
        Dec(P2, LineSize);
    VK_DOWN:
    begin
      if FOrientation = sctoVertical then
      begin
        if FAlignment = sctaLeftToRight then
          Inc(P2, LineSize)
        else
          Dec(P2, LineSize);
      end else
        Dec(P2, LineSize);
    end;
    VK_UP:
    begin
      if FOrientation = sctoVertical then
      begin
        if FAlignment = sctaLeftToRight then
          Dec(P2, LineSize)
        else
          Inc(P2, LineSize);
      end else
        Inc(P2, LineSize);
    end;
    VK_PRIOR:
      if FAlignment = sctaLeftToRight then
        Dec(P2, PageSize)
      else
        Inc(P2, PageSize);
    VK_NEXT:
      if FAlignment = sctaLeftToRight then
        Inc(P2, PageSize)
      else
        Dec(P2, PageSize);
    VK_HOME:
      P2 := FMin;
    VK_END:
      P2 := FMax;
  end;

  if CanSetUserValue(P2) and (P1 <> P2) then
    Position := P2;
end;

procedure TSCCustomTrackbar.SetAlignment(Value: TSCTrackAlign);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetFrequency(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FFrequency <> Value then
  begin
    FFrequency := Value;
    if FShowLines then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetLineColor(Value: TColor);
begin
  if FLineColor <> Value then
  begin
    FLineColor := Value;
    if FShowLines then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetLinePosition(Value: TSCTrackLinePosition);
begin
  if FLinePosition <> Value then
  begin
    FLinePosition := Value;
    Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetMax(Value: Integer);
begin
  if Value < FMin then Value := FMin;

  if FMax <> Value then
  begin
    FMax := Value;
    if FPosition > FMax then
      FPosition := FMax;
    Change;
  end;
end;

procedure TSCCustomTrackbar.SetMin(Value: Integer);
begin
  if Value > FMax then Value := FMax;

  if FMin <> Value then
  begin
    FMin := Value;
    if FPosition < FMin then
      FPosition := FMin;
    Change;
  end;
end;

procedure TSCCustomTrackbar.SetOrientation(Value: TSCOrientation);
var
  H: Integer;
  R: TRect;
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;

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

    Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetPosition(Value: Integer);
begin
  Value := NormalizePosition(Value);
  if (FPosition <> Value) and CanSetValue(Value) then
  begin
    FPosition := Value;
    Change;
  end;
end;

procedure TSCCustomTrackbar.SetProgressBkColor(Value: TColor);
begin
  if FProgressBkColor <> Value then
  begin
    FProgressBkColor := Value;
    if FShowProgress then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetProgressBorder(Value: TSCControlBorder);
begin
  if FProgressBorder <> Value then
  begin
    FProgressBorder := Value;
    if FShowProgress then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetProgressBorderColor(Value: TColor);
begin
  if FProgressBorderColor <> Value then
  begin
    FProgressBorderColor := Value;
    if FShowProgress then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetProgressEndColor(Value: TColor);
begin
  if FProgressEndColor <> Value then
  begin
    FProgressEndColor := Value;
    if FShowProgress and (FPosition > FMin) then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetProgressHeight(Value: Integer);
begin
  if Value < 0 then
    Value := 0
  else
  if Value > 100 then
    Value := 100;

  if FProgressHeight <> Value then
  begin
    FProgressHeight := Value;
    Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetProgressColor(Value: TColor);
begin
  if FProgressColor <> Value then
  begin
    FProgressColor := Value;
    if FShowProgress and (FPosition > FMin) then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetShowLines(Value: Boolean);
begin
  if FShowLines <> Value then
  begin
    FShowLines := Value;
    Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetShowProgress(Value: Boolean);
begin
  if FShowProgress <> Value then
  begin
    FShowProgress := Value;
    if FPosition > FMin then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetShowSlider(Value: Boolean);
begin
  if FShowSlider <> Value then
  begin
    FShowSlider := Value;
    Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetSliderStyle(Value: TSCTrackStyle);
begin
  if FSliderStyle <> Value then
  begin
    FSliderStyle := Value;
    Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetSliderColor(Value: TColor);
begin
  if FSliderColor <> Value then
  begin
    FSliderColor := Value;
    if FShowSlider then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetSliderFocusColor(Value: TColor);
begin
  if FSliderFocusColor <> Value then
  begin
    FSliderFocusColor := Value;
    if FShowSlider and HandleAllocated and Focused then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetSliderFrameColor(Value: TColor);
begin
  if FSliderFrameColor <> Value then
  begin
    FSliderFrameColor := Value;
    if FShowSlider then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetSliderHotColor(Value: TColor);
begin
  if FSliderHotColor <> Value then
  begin
    FSliderHotColor := Value;
    if FShowSlider then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetSliderHottracks(Value: Boolean);
begin
  if FSliderHottracks <> Value then
  begin
    FSliderHottracks := Value;
    if FShowSlider then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetSliderSize(Value: Integer);
begin
  if Value < 3 then
    Value := 3
  else
  if Value > 20 then
    Value := 20;

  if FSliderSize <> Value then
  begin
    FSliderSize := Value;
    Invalidate;
  end;
end;

procedure TSCCustomTrackbar.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTALLKEYS or DLGC_WANTARROWS;
end;

procedure TSCCustomTrackbar.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if Message.WheelDelta < 0 then
    SetPosition(Position + 1)
  else
  if Message.WheelDelta > 0 then
    SetPosition(Position - 1);
end;

function TSCCustomTrackbar.PositionAtPos(P: TPoint): Integer;
var
  R, R1: TRect;
  Cnt, I: Integer;
  InRect: Boolean;
begin
  Result := NormalizePosition(Position);
  
  if CanGetClientRect then
  begin
    Cnt := FMax - FMin;
    if Cnt < 1 then Exit;

    R1 := GetClientRect;
    R  := GetProgressRect;

    if FOrientation = sctoHorizontal then
    begin
      R.Top := R1.Top - 100;
      R.Bottom := R1.Bottom + 100;

      Dec(P.x, R.Left);
      OffsetRect(R, -R.Left, 0);

      InRect := (P.x >= R.Left) and (P.x <= R.Right);
    end else
    begin
      R.Left := R1.Left - 100;
      R.Right := R1.Right + 100;

      Dec(P.y, R.Top);
      OffsetRect(R, 0, -R.Top);

      InRect := (P.y >= R.Top) and (P.y <= R.Bottom);
    end;

    if not IsRectEmpty(R) and InRect then
    begin
      if FOrientation = sctoHorizontal then
      begin
        if P.x < R.Left then
        begin
          Result := FMin;
          if FAlignment = sctaRightToLeft then
            Result := FMax;

          Exit;
        end;

        if P.x > R.Right then
        begin
          Result := FMax;
          if FAlignment = sctaRightToLeft then
            Result := FMin;

          Exit;
        end;

        I := Muldiv(Cnt, P.x, R.Right);
        if FAlignment = sctaLeftToRight then
          Result := FMin + I
        else
          Result := FMax - I;
      end else
      begin
        if P.y < R.Top then
        begin
          Result := FMin;
          if FAlignment = sctaRightToLeft then
            Result := FMax;

          Exit;
        end;

        if P.y > R.Bottom then
        begin
          Result := FMax;
          if FAlignment = sctaRightToLeft then
            Result := FMin;

          Exit;
        end;

        I := Muldiv(Cnt, P.y, R.Bottom);
        if FAlignment = sctaLeftToRight then
          Result := FMin + I
        else
          Result := FMax - I;
      end;
    end;
  end;

  if Result < FMin then
    Result := FMin;

  if Result > FMax then
    Result := FMax;
end;

procedure TSCCustomTrackbar.SetShowFocusRect(Value: Boolean);
begin
  if FShowFocusRect <> Value then
  begin
    FShowFocusRect := Value;
    if HandleAllocated and Focused then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetProgressStyle(Value: TSCTrackProgressStyle);
begin
  if FProgressStyle <> Value then
  begin
    FProgressStyle := Value;
    if FShowProgress then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.SetSliderOffset(Value: Integer);
begin
  if Value < 0 then Value := 0
  else
  if Value > 100 then Value := 100;

  if FSliderOffset <> Value then
  begin
    FSliderOffset := Value;
    if FShowSlider then
      Invalidate;
  end;
end;

function TSCCustomTrackbar.GetSliderSize: Integer;
begin
  Result := 0;
  if not FShowSlider then Exit;

  Result := FSliderSize;
  if (FSliderStyle = scthImage) and (Images <> nil) then
  begin
    Result := Images.Height div 2;
    if FOrientation = sctoHorizontal then
      Result := Images.Width div 2;
  end;
end;

procedure TSCCustomTrackbar.ImageListChange(Sender: TObject);
begin
  if FSliderStyle = scthImage then
    Invalidate;
end;

procedure TSCCustomTrackbar.SetProgress(Value: TSCTrackbarProgress);
begin
  FProgress.Assign(Value);
end;

destructor TSCCustomTrackbar.Destroy;
begin
  FreeAndNil(FProgress);
  FreeAndNil(FSlider);
  inherited Destroy;
end;

procedure TSCCustomTrackbar.SetSlider(Value: TSCTrackbarSlider);
begin
  FSlider.Assign(Value);
end;

procedure TSCCustomTrackbar.SetProgressSlice(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FProgressSlice <> Value then
  begin
    FProgressSlice := Value;
    if FShowProgress and (FPosition > FMin) then
      Invalidate;
  end;
end;

procedure TSCCustomTrackbar.Loaded;
begin
  inherited Loaded;
  Invalidate;
end;

function TSCCustomTrackbar.CanSetValue(var Value: Integer): Boolean;
begin
  Result := True;
  if Value < FMin then
    Value := FMin
  else if Value > FMax then
    Value := FMax;
end;

function TSCCustomTrackbar.CanSetUserValue(var Value: Integer): Boolean;
begin
  Result := True;
end;

procedure TSCCustomTrackbar.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomTrackbar then
  begin
    with TSCCustomTrackbar(Source) do
    begin
      Self.Alignment := Alignment;
      Self.Frequency := Frequency;
      Self.LineColor := LineColor;
      Self.LinePosition := LinePosition;
      Self.LineSize := LineSize;
      Self.Max := Max;
      Self.Min := Min;
      Self.Orientation := Orientation;
      Self.PageSize := PageSize;
      Self.Position := Position;
      Self.ProgressBkColor := ProgressBkColor;
      Self.ProgressBorder := ProgressBorder;
      Self.ProgressBorderColor := ProgressBorderColor;
      Self.ProgressColor := ProgressColor;
      Self.ProgressEndColor := ProgressEndColor;
      Self.ProgressSlice := ProgressSlice;
      Self.ProgressStyle := ProgressStyle;
      Self.ProgressHeight := ProgressHeight;
      Self.Progress := Progress;
      Self.ShowFocusRect := ShowFocusRect;
      Self.ShowLines := ShowLines;
      Self.ShowProgress := ShowProgress;
      Self.ShowSlider := ShowSlider;
      Self.SliderColor := SliderColor;
      Self.SliderFocusColor := SliderFocusColor;
      Self.SliderFrameColor := SliderFrameColor;
      Self.SliderHottracks := SliderHottracks;
      Self.SliderHotColor := SliderHotColor;
      Self.SliderOffset := SliderOffset;
      Self.SliderSize := SliderSize;
      Self.SliderStyle := SliderStyle;
      Self.Slider := Slider;
    end;
  end;
end;

function TSCCustomTrackbar.GetPosition: Integer;
begin
  Result := FPosition;
end;

function TSCCustomTrackbar.NormalizePosition(Value: Integer): Integer;
begin
  Result := Value;
  if Result < FMin then Result := FMin;
  if Result > FMax then Result := FMax;
end;

function TSCCustomTrackbar.GetGradientDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -16);
end;

function TSCCustomTrackbar.GetGradientExDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -40);
end;

function TSCCustomTrackbar.GetGradientExLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 40);
end;

function TSCCustomTrackbar.GetGradientLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 30);
end;

function TSCCustomTrackbar.GetGradientPeal(AColor: TColor): TColor;
begin
  Result := BlendedColor(AColor, 52, 44, 112, True);
end;

function TSCCustomTrackbar.GetGradientPreDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -80);
end;

function TSCCustomTrackbar.GetGradientPreLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 100);
end;

function TSCCustomTrackbar.GetGradientShadow(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -6);
end;

function TSCCustomTrackbar.GetGradientHighLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 120);
end;

procedure TSCCustomTrackbar.DoDrawSlider(ACanvas: TCanvas);

  function GetHotTrackColor: TColor;
  begin
    Result := FSliderFrameColor;

    if Focused and (FSliderFocusColor <> clNone) then
      Result := FSliderFocusColor
    else
    if FSliderClicked or (not FSliderClicked and FSliderIsHot) then
    begin
      Result := FSliderHotColor;
      if Result = clNone then
      begin
        Result := FSliderFrameColor;
        if Result = clNone then
          Result := FSliderColor;
      end;
    end;
  end;

var
  Pt: TPoint;
  CR, R: TRect;
  C1, C2: TColor;
  Handled: Boolean;
  ThW, ThH: Integer;
  ThmStyle: TSCSliderStyle;
begin
  if (ACanvas = nil) or not (FShowSlider and CanGetClientRect) then
    Exit;

  CR := GetSliderRect;
  if IsRectEmpty(CR) then
    Exit;

  IntersectRect(R, CR, ClientRect);

  if not IsRectEmpty(R) then
  begin
    Handled := False;
    if Assigned(FOnCustomDrawSlider) then
      FOnCustomDrawSlider(Self, Canvas, CR, Handled);

    if Handled then
      Exit;

    if FSliderStyle = scthImage then
    begin
      if IsValidImage(ImageIndex) then
      begin
        R := GetProgressRect;
        if FOrientation = sctoHorizontal then
        begin
          Inc(CR.Left, (CR.Right - CR.Left - Images.Width) div 2);
          CR.Top := R.Top + ((R.Bottom - R.Top - Images.Height) div 2);
        end else
        begin
          Inc(CR.Top,  (CR.Bottom - CR.Top - Images.Height) div 2);
          CR.Left := R.Left + ((R.Right - R.Left - Images.Width) div 2);
        end;

        Images.Draw(ACanvas, CR.Left, CR.Top, ImageIndex, True);
      end;

      Exit;
    end;

    IntersectRect(R, CR, ClientRect);
    if IsRectEmpty(CR) or IsRectEmpty(R) then Exit;

    C1 := FSliderColor;
    C2 := FSliderFrameColor;

    if FSliderHottracks then
    begin
      if FSliderStyle = scthMac then
        C1 := GetHotTrackColor
      else
        C2 := GetHotTrackColor;
    end;

    ThmStyle := sctsWindows;
    case FSliderStyle of
      scthWindows:
        ThmStyle := sctsWindows;
      scthMac:
        ThmStyle := sctsMac;
      scthMetal:
        ThmStyle := sctsMetal;
      scthPS:
        ThmStyle := sctsPS;
      scthPSNew:
        ThmStyle := sctsPSNew;
      scthNew:
        ThmStyle := sctsNew;
    end;

    case FSliderStyle of
      scthWindows,
      scthMetal, scthNew, scthPSNew:
      begin
        if FOrientation = sctoHorizontal then
        begin
          ThW := CR.Right - CR.Left;
          ThH := CR.Bottom - CR.Top;

          if FSliderStyle in [scthWindows, scthMetal, scthPSNew] then
            C1 := FSliderColor;

          case FLinePosition of
            sclpBottomRight:
            begin
              Pt.x := CR.Left + ((CR.Right - CR.Left) div 2);
              Pt.y := CR.Bottom;

              scDrawUpSlider(ACanvas, Pt, ThW, ThH, ThmStyle, False, C2, C1);
            end;
            sclpTopLeft:
            begin
              Pt.x := CR.Left + ((CR.Right - CR.Left) div 2);
              Pt.y := CR.Top;

              scDrawDownSlider(ACanvas, Pt, ThW, ThH, ThmStyle, False, C2, C1);
            end;
            sclpBoth:
            begin
              Pt.x := CR.Left + ((CR.Right - CR.Left) div 2);
              Pt.y := CR.Bottom;

              scDrawUpSlider(ACanvas, Pt, ThW, ThH, ThmStyle, True, C2, C1);
            end;
          end;
        end else
        begin
          ThH := CR.Right - CR.Left;
          ThW := CR.Bottom - CR.Top;

          case FLinePosition of
            sclpBottomRight:
            begin
              Pt.x := CR.Right;
              Pt.y := CR.Top + ((CR.Bottom - CR.Top) div 2);

              scDrawLeftSlider(ACanvas, Pt, ThW, ThH, ThmStyle, False, C2, C1);
            end;
            sclpTopLeft:
            begin
              Pt.x := CR.Left;
              Pt.y := CR.Top + ((CR.Bottom - CR.Top) div 2);

              scDrawRightSlider(ACanvas, Pt, ThW, ThH, ThmStyle, False, C2, C1);
            end;
            sclpBoth:
            begin
              Pt.x := CR.Right;
              Pt.y := CR.Top + ((CR.Bottom - CR.Top) div 2);

              scDrawLeftSlider(ACanvas, Pt, ThW, ThH, ThmStyle, True, C2, C1);
            end;
          end;
        end;
      end;
      scthMac, scthPS:
      begin
        if FSliderStyle = scthMac then
        begin
          if C1 = Self.Color then
            C1 := clNone;
          C2 := C1;
        end;

        if FOrientation = sctoHorizontal then
        begin
          ThW := CR.Right - CR.Left;
          ThH := ThW div 2;

          Pt.x := CR.Left + ((CR.Right - CR.Left) div 2);
          Inc(Pt.x);

          if FLinePosition in [sclpBottomRight, sclpBoth] then
          begin
            Pt.y := CR.Bottom - ThH;
            scDrawDownSlider(ACanvas, Pt, ThW, ThH, ThmStyle, False, C2, C1);
          end;

          if FLinePosition in [sclpTopLeft, sclpBoth] then
          begin
            Pt.y := CR.Top + ThH - 1;
            scDrawUpSlider(ACanvas, Pt, ThW, ThH, ThmStyle, False, C2, C1);
          end;
        end else
        begin
          ThW := CR.Bottom - CR.Top;
          ThH := ThW div 2;

          Pt.y := CR.Top + ((CR.Bottom - CR.Top) div 2);
          Inc(Pt.y);

          if FLinePosition in [sclpBottomRight, sclpBoth] then
          begin
            Pt.x := CR.Right - ThH;
            scDrawRightSlider(ACanvas, Pt, ThW, ThH, ThmStyle, False, C2, C1);
          end;

          if FLinePosition in [sclpTopLeft, sclpBoth] then
          begin
            Pt.x := CR.Left + ThH - 1;
            scDrawLeftSlider(ACanvas, Pt, ThW, ThH, ThmStyle, False, C2, C1);
          end;
        end;
      end;
    end;
  end;
end;

{ TSCTrackbarProgress }

procedure TSCTrackbarProgress.Assign(Source: TPersistent);
begin
  if Source is TSCTrackbarProgress then
  begin
    if FOwner = nil then Exit;

    with TSCTrackbarProgress(Source) do
    begin
      Self.FOwner.FProgressBkColor  := BkColor;
      Self.FOwner.FProgressBorder   := Border;
      Self.FOwner.FProgressBorderColor := BorderColor;
      Self.FOwner.FProgressColor    := Color;
      Self.FOwner.FProgressEndColor := EndColor;
      Self.FOwner.FProgressHeight   := Height;
      Self.FOwner.FProgressSlice    := Slice;
      Self.FOwner.FProgressStyle    := Style;
    end;

    FOwner.Invalidate;
  end else
    inherited Assign(Source);
end;

constructor TSCTrackbarProgress.Create(AOwner: TSCCustomTrackbar);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCTrackbarProgress.GetBkColor: TColor;
begin
  Result := clWindow;
  if FOwner <> nil then
    Result := FOwner.ProgressBkColor;
end;

function TSCTrackbarProgress.GetBorder: TSCControlBorder;
begin
  Result := sccb3DLowered;
  if FOwner <> nil then
    Result := FOwner.ProgressBorder;
end;

function TSCTrackbarProgress.GetBorderColor: TColor;
begin
  Result := cl3DDkShadow;
  if FOwner <> nil then
    Result := FOwner.ProgressBorderColor;
end;

function TSCTrackbarProgress.GetColor: TColor;
begin
  Result := clHighlight;
  if FOwner <> nil then
    Result := FOwner.ProgressColor;
end;

function TSCTrackbarProgress.GetEndColor: TColor;
begin
  Result := clAqua;
  if FOwner <> nil then
    Result := FOwner.ProgressEndColor;
end;

function TSCTrackbarProgress.GetHeight: Integer;
begin
  Result := 12;
  if FOwner <> nil then
    Result := FOwner.ProgressHeight;
end;

function TSCTrackbarProgress.GetSlice: Integer;
begin
  Result := 10;
  if FOwner <> nil then
    Result := FOwner.ProgressSlice;
end;

function TSCTrackbarProgress.GetStyle: TSCTrackProgressStyle;
begin
  Result := sctpClassic;
  if FOwner <> nil then
    Result := FOwner.ProgressStyle;
end;

procedure TSCTrackbarProgress.SetBkColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.ProgressBkColor := Value;
end;

procedure TSCTrackbarProgress.SetBorder(Value: TSCControlBorder);
begin
  if FOwner <> nil then
    FOwner.ProgressBorder := Value;
end;

procedure TSCTrackbarProgress.SetBorderColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.ProgressBorderColor := Value;
end;

procedure TSCTrackbarProgress.SetColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.ProgressColor := Value;
end;

procedure TSCTrackbarProgress.SetEndColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.ProgressEndColor := Value;
end;

procedure TSCTrackbarProgress.SetHeight(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.ProgressHeight := Value;
end;

procedure TSCTrackbarProgress.SetSlice(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.ProgressSlice := Value;
end;

procedure TSCTrackbarProgress.SetStyle(Value: TSCTrackProgressStyle);
begin
  if FOwner <> nil then
    FOwner.ProgressStyle := Value;
end;

{ TSCTrackbarSlider }

procedure TSCTrackbarSlider.Assign(Source: TPersistent);
begin
  if Source is TSCTrackbarSlider then
  begin
    if FOwner = nil then Exit;

    with TSCTrackbarSlider(Source) do
    begin
      Self.FOwner.FSliderColor      := Color;
      Self.FOwner.FSliderFocusColor := FocusColor;
      Self.FOwner.FSliderFrameColor := FrameColor;
      Self.FOwner.FSliderHottracks  := Hottracks;
      Self.FOwner.FSliderHotColor   := HotColor;
      Self.FOwner.FSliderOffset     := Offset;
      Self.FOwner.FSliderSize       := Size;
      Self.FOwner.FSliderStyle      := Style;
    end;

    FOwner.Invalidate;
  end else
    inherited Assign(Source);
end;

constructor TSCTrackbarSlider.Create(AOwner: TSCCustomTrackbar);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCTrackbarSlider.GetColor: TColor;
begin
  Result := clBtnFace;
  if FOwner <> nil then
    Result := FOwner.SliderColor;
end;

function TSCTrackbarSlider.GetFocusColor: TColor;
begin
  Result := clHighlight;
  if FOwner <> nil then
    Result := FOwner.SliderFocusColor;
end;

function TSCTrackbarSlider.GetFrameColor: TColor;
begin
  Result := clGreen;
  if FOwner <> nil then
    Result := FOwner.SliderFrameColor;
end;

function TSCTrackbarSlider.GetHotColor: TColor;
begin
  Result := clBlue;
  if FOwner <> nil then
    Result := FOwner.SliderHotColor;
end;

function TSCTrackbarSlider.GetHottracks: Boolean;
begin
  Result := True;
  if FOwner <> nil then
    Result := FOwner.SliderHottracks;
end;

function TSCTrackbarSlider.GetOffset: Integer;
begin
  Result := 0;
  if FOwner <> nil then
    Result := FOwner.SliderOffset;
end;

function TSCTrackbarSlider.GetSize: Integer;
begin
  Result := 4;
  if FOwner <> nil then
    Result := FOwner.SliderSize;
end;

function TSCTrackbarSlider.GetStyle: TSCTrackStyle;
begin
  Result := scthWindows;
  if FOwner <> nil then
    Result := FOwner.SliderStyle;
end;

procedure TSCTrackbarSlider.SetColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.SliderColor := Value;
end;

procedure TSCTrackbarSlider.SetFocusColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.SliderFocusColor := Value;
end;

procedure TSCTrackbarSlider.SetFrameColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.SliderFrameColor := Value;
end;

procedure TSCTrackbarSlider.SetHotColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.SliderHotColor := Value;
end;

procedure TSCTrackbarSlider.SetHottracks(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.SliderHottracks := Value;
end;

procedure TSCTrackbarSlider.SetOffset(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.SliderOffset := Value;
end;

procedure TSCTrackbarSlider.SetSize(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.SliderSize := Value;
end;

procedure TSCTrackbarSlider.SetStyle(Value: TSCTrackStyle);
begin
  if FOwner <> nil then
    FOwner.SliderStyle := Value;
end;

{$I SCVerRec.inc}

end.
