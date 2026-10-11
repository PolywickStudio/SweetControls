unit SCGradient;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SCCommon, SCConsts;

type
  PRGBQuadArray = ^TRGBQuadArray;
  TRGBQuadArray = array[0..1024] of TRGBQuad;

  TSCGradientColors = array[0..255] of TRGBQuad;

  TSCGradientShift = -100..100;
  TSCGradientRotation = -100..100;

  TSCGradientStyle = (scdgsNone, scdgsRadialC, scdgsRadialT, scdgsRadialB,
    scdgsRadialL, scdgsRadialR, scdgsRadialTL, scdgsRadialTR, scdgsRadialBL,
    scdgsRadialBR, scdgsLinearH, scdgsLinearV, scdgsReflectedH, scdgsReflectedV,
    scdgsDiagonalLF, scdgsDiagonalLB, scdgsDiagonalRF, scdgsDiagonalRB,
    scdgsArrowL, scdgsArrowR, scdgsArrowU, scdgsArrowD, scdgsDiamond,
    scdgsButterfly);

  TSCCustomGradientEvent = procedure(Sender: TObject;
    const Colors: TSCGradientColors; Pattern: TBitmap) of object;

  TSCGradientPainter = class(TPersistent)
  private
    FColorBegin: TColor;
    FColorEnd: TColor;
    FStyle: TSCGradientStyle;
    FShift: TSCGradientShift;
    FRotation: TSCGradientRotation;
    FReverse: Boolean;
    FPattern: TBitmap;
    FOnCustom: TSCCustomGradientEvent;
    FUpdateCount: Integer;
    FUpdatePended: Boolean;
    FDirty: Boolean;
    FOwner: TPersistent;
    FOnChange: TNotifyEvent;
    procedure SetStyle(Value: TSCGradientStyle);
    procedure SetShift(Value: TSCGradientShift);
    procedure SetRotation(Value: TSCGradientRotation);
    procedure SetReverse(Value: Boolean);

    function CustomPaint(const Colors: TSCGradientColors; APattern: TBitmap): Boolean;
  protected
    function  GetOwner: TPersistent; override;

    function  GetColorBegin: TColor; virtual;
    function  GetColorEnd: TColor; virtual;
    procedure SetColorBegin(Value: TColor); virtual;
    procedure SetColorEnd(Value: TColor); virtual;
    function  IsColorBeginSaved: Boolean; virtual;
    function  IsColorEndSaved: Boolean; virtual;

    procedure Changed;
    procedure DoChanged; dynamic;

    procedure UpdatePattern; virtual;
    function  DoCustomPaint(const Colors: TSCGradientColors; APattern: TBitmap): Boolean; virtual;

    property Pattern: TBitmap read FPattern;
    property OnCustom: TSCCustomGradientEvent read FOnCustom write FOnCustom;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TPersistent); 
    destructor Destroy; override;

    function  CopyPatternTo(ABitmap: TBitmap): Boolean;
    procedure InvalidatePattern;

    procedure BeginUpdate;
    procedure EndUpdate;

    procedure Paint(ACanvas: TCanvas; ARect: TRect);

    property Reverse: Boolean read FReverse write SetReverse default False;
    property Rotation: TSCGradientRotation read FRotation write SetRotation default 0;
    property Shift: TSCGradientShift read FShift write SetShift default 0;
  published
    property ColorBegin: TColor read GetColorBegin write SetColorBegin stored IsColorBeginSaved;
    property ColorEnd: TColor read GetColorEnd write SetColorEnd stored IsColorEndSaved;
    property Style: TSCGradientStyle read FStyle write SetStyle default scdgsLinearV;
  end;

implementation

procedure RadialCentral(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y, rX: Integer;
  pRGB: PRGBQuad;
  Row1, Row2: PRGBQuadArray;
  PreCalcXs: array[0..180] of Integer;
begin
  Pattern.Width := 362;
  Pattern.Height := 362;

  rX := 0;
  for X := 180 downto 0 do
  begin
    PreCalcXs[rX] := X * X;
    Inc(rX);
  end;

  for Y := 180 downto 0 do
  begin
    Row1 := PRGBQuadArray(Pattern.ScanLine[Y]);
    Row2 := PRGBQuadArray(Pattern.ScanLine[361-Y]);
    for X := 180 downto 0 do
    begin
      rX := 361 - X;
      pRGB := @Colors[Round(Sqrt(PreCalcXs[X] + PreCalcXs[Y]))];
      Row1[X] := pRGB^;
      Row1[rX] := pRGB^;
      Row2[X] := pRGB^;
      Row2[rX] := pRGB^;
    end;
  end;
end;

procedure RadialTop(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y, rX, rY: Integer;
  pRGB: PRGBQuad;
  Row: PRGBQuadArray;
  PreCalcY: Integer;
  PreCalcXs: array[0..180] of Integer;
begin
  Pattern.Width := 362;
  Pattern.Height := 181;

  rX := 0;
  for X := 180 downto 0 do
  begin
    PreCalcXs[rX] := X * X;
    Inc(rX);
  end;

  rY := 0;
  for Y := 180 downto 0 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    PreCalcY := PreCalcXs[rY];
    rX := 181;
    for X := 180 downto 0 do
    begin
      pRGB := @Colors[Round(Sqrt(PreCalcXs[X] + PreCalcY))];
      Row[X] := pRGB^;
      Row[rX] := pRGB^;
      Inc(rX);
    end;
    Inc(rY);
  end;
end;

procedure RadialBottom(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y, rX: Integer;
  pRGB: PRGBQuad;
  Row: PRGBQuadArray;
  PreCalcY: Integer;
  PreCalcXs: array[0..180] of Integer;
begin
  Pattern.Width := 362;
  Pattern.Height := 181;

  rX := 0;
  for X := 180 downto 0 do
  begin
    PreCalcXs[rX] := X * X;
    Inc(rX);
  end;

  for Y := 180 downto 0 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    PreCalcY := PreCalcXs[Y];
    rX := 181;
    for X := 180 downto 0 do
    begin
      pRGB := @Colors[Round(Sqrt(PreCalcXs[X] + PreCalcY))];
      Row[X] := pRGB^;
      Row[rX]:= pRGB^;
      Inc(rX);
    end;
  end;
end;

procedure RadialLeft(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y, rY: Integer;
  pRGB: PRGBQuad;
  Row1, Row2: PRGBQuadArray;
  PreCalcY: Integer;
  PreCalcXs: array[0..180] of Integer;
begin
  Pattern.Width := 181;
  Pattern.Height := 362;

  for X := 180 downto 0 do
    PreCalcXs[X] := X * X;

  rY := 180;
  for Y := 0 to 180 do
  begin
    Row1 := PRGBQuadArray(Pattern.ScanLine[Y]);
    Row2 := PRGBQuadArray(Pattern.ScanLine[361-Y]);
    PreCalcY := PreCalcXs[rY];
    for X := 0 to 180 do
    begin
      pRGB := @Colors[Round(Sqrt(PreCalcXs[X] + PreCalcY))];
      Row1[X] := pRGB^;
      Row2[X] := pRGB^;
    end;
    Dec(rY);
  end;
end;

procedure RadialRight(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y, rX: Integer;
  pRGB: PRGBQuad;
  Row1, Row2: PRGBQuadArray;
  PreCalcXs: array[0..180] of Integer;
begin
  Pattern.Width := 181;
  Pattern.Height := 362;

  rX := 0;
  for X := 180 downto 0 do
  begin
    PreCalcXs[rX] := X * X;
    Inc(rX);
  end;

  for Y := 0 to 180 do
  begin
    Row1 := PRGBQuadArray(Pattern.ScanLine[Y]);
    Row2 := PRGBQuadArray(Pattern.ScanLine[361-Y]);
    for X := 0 to 180 do
    begin
      pRGB := @Colors[Round(Sqrt(PreCalcXs[X] + PreCalcXs[Y]))];
      Row1[X] := pRGB^;
      Row2[X] := pRGB^;
    end;
  end;
end;

procedure RadialTopLeft(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y: Integer;
  Row: PRGBQuadArray;
  PreCalcY: Integer;
  PreCalcXs: array[0..180] of Integer;
begin
  Pattern.Width := 181;
  Pattern.Height := 181;

  for X := 180 downto 0 do
    PreCalcXs[X] := X * X;

  for Y := 0 to 180 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    PreCalcY := PreCalcXs[Y];
    for X := 0 to 180 do
      Row[X] := Colors[Round(Sqrt(PreCalcXs[X] + PreCalcY))];
  end;
end;

procedure RadialTopRight(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y, rX, rY: Integer;
  Row: PRGBQuadArray;
  PreCalcY: Integer;
  PreCalcXs: array[0..180] of Integer;
begin
  Pattern.Width := 181;
  Pattern.Height := 181;

  rX :=0;
  for X := 180 downto 0 do
  begin
    PreCalcXs[rX] := X * X;
    Inc(rX);
  end;

  rY := 180;
  for Y := 0 to 180 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    PreCalcY := PreCalcXs[rY];
    for X := 0 to 180 do
      Row[X] := Colors[Round(Sqrt(PreCalcXs[X] + PreCalcY))];
    Dec(rY);
  end;
end;

procedure RadialBottomLeft(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y, rY: Integer;
  Row: PRGBQuadArray;
  PreCalcY: Integer;
  PreCalcXs: array[0..180] of Integer;
begin
  Pattern.Width := 181;
  Pattern.Height := 181;

  for X := 180 downto 0 do
    PreCalcXs[X] := X * X;

  rY := 180;
  for Y := 0 to 180 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    PreCalcY := PreCalcXs[rY];
    for X := 0 to 180 do
      Row[X] := Colors[Round(Sqrt(PreCalcXs[X] + PreCalcY))];
    Dec(rY);
  end;
end;

procedure RadialBottomRight(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y, rX: Integer;
  Row: PRGBQuadArray;
  PreCalcY: Integer;
  PreCalcXs: array[0..180] of Integer;
begin
  Pattern.Width := 181;
  Pattern.Height := 181;

  rX := 0;
  for X := 180 downto 0 do
  begin
    PreCalcXs[rX] := X * X;
    Inc(rX);
  end;

  for Y := 0 to 180 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    PreCalcY := PreCalcXs[Y];
    for X := 0 to 180 do
      Row[X] := Colors[Round(Sqrt(PreCalcXs[X] + PreCalcY))];
  end;
end;

procedure LinearHorizontal(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 256;
  Pattern.Height := 1;
  Row := PRGBQuadArray(Pattern.ScanLine[0]);
  for X := 0 to 255 do
    Row[X] := Colors[X];
end;

procedure LinearVertical(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  Y: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 1;
  Pattern.Height := 256;
  for Y := 0 to 255 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    Row[0] := Colors[Y];
  end;
end;

procedure ReflectedHorizontal(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  Y: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 1;
  Pattern.Height := 512;
  for Y := 0 to 255 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    Row[0] := Colors[255 - Y];
    Row := PRGBQuadArray(Pattern.ScanLine[511 - Y]);
    Row[0] := Colors[255 - Y];
  end;
end;

procedure ReflectedVertical(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 512;
  Pattern.Height := 1;
  Row := PRGBQuadArray(Pattern.ScanLine[0]);
  for X := 0 to 255 do
  begin
    Row[X] := Colors[255 - X];
    Row[511 - X] := Colors[255 - X];
  end;
end;

procedure DiagonalLinearForward(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 128;
  Pattern.Height := 129;
  for Y := 0 to 128 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 127 do
      Row[X] := Colors[X + Y];
  end;
end;

procedure DiagonalLinearBackward(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 128;
  Pattern.Height := 129;
  for Y := 0 to 128 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 127 do
      Row[X] := Colors[127 + (Y - X)];
  end;
end;

procedure DiagonalReflectedForward(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 256;
  Pattern.Height := 256;
  for Y := 0 to 255 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 255 do
      if X + Y < 255 then
        Row[X] := Colors[255 - (X + Y)]
      else
        Row[X] := Colors[(Y + X) - 255];
  end;
end;

procedure DiagonalReflectedBackward(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 256;
  Pattern.Height := 256;
  for Y := 0 to 255 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 255 do
      if X > Y then
        Row[X] := Colors[X - Y]
      else
        Row[X] := Colors[Y - X];
  end;
end;

procedure ArrowLeft(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 129;
  Pattern.Height := 256;
  for Y := 0 to 127 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 128 do
      Row[X] := Colors[255 - (X + Y)];
  end;
  for Y := 128 to 255 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 128 do
      Row[X] := Colors[Y - X];
  end;
end;

procedure ArrowRight(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 129;
  Pattern.Height := 256;
  for Y := 0 to 127 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 128 do
      Row[X] := Colors[(X - Y) + 127];
  end;
  for Y := 128 to 255 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 128 do
      Row[X] := Colors[(X + Y) - 128];
  end;
end;

procedure ArrowUp(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 256;
  Pattern.Height := 129;
  for Y := 0 to 128 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 127 do
      Row[X] := Colors[255 - (X + Y)];
    for X := 128 to 255 do
      Row[X] := Colors[X - Y];
  end;
end;

procedure ArrowDown(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 256;
  Pattern.Height := 129;
  for Y := 0 to 128 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 127 do
      Row[X] := Colors[127 + (Y - X)];
    for X := 128 to 255 do
      Row[X] := Colors[(X + Y) - 128];
  end;
end;

procedure Diamond(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 256;
  Pattern.Height := 256;
  for Y := 0 to 127 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 127 do
      Row[X] := Colors[255 - (X + Y)];
    for X := 128 to 255 do
      Row[X] := Colors[X - Y];
  end;
  for Y := 128 to 255 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 127 do
      Row[X] := Colors[Y - X];
    for X := 128 to 255 do
      Row[X] := Colors[(X + Y) - 255];
  end;
end;

procedure Butterfly(const Colors: TSCGradientColors; Pattern: TBitmap);
var
  X, Y: Integer;
  Row: PRGBQuadArray;
begin
  Pattern.Width := 256;
  Pattern.Height := 256;
  for Y := 0 to 127 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 127 do
      Row[X] := Colors[(X - Y) + 128];
    for X := 128 to 255 do
      Row[X] := Colors[383 - (X + Y)];
  end;
  for Y := 128 to 255 do
  begin
    Row := PRGBQuadArray(Pattern.ScanLine[Y]);
    for X := 0 to 127 do
      Row[X] := Colors[(X + Y) - 128];
    for X := 128 to 255 do
      Row[X] := Colors[128 + (Y - X)];
  end;
end;

{ TSCGradient }

type
  TSCPatternBuilder = procedure(const Colors: TSCGradientColors; Pattern: TBitmap);

const
  PatternBuilder: array[TSCGradientStyle] of TSCPatternBuilder = (nil,
    RadialCentral, RadialTop, RadialBottom, RadialLeft, RadialRight,
    RadialTopLeft, RadialTopRight, RadialBottomLeft, RadialBottomRight,
    LinearHorizontal, LinearVertical, ReflectedHorizontal, ReflectedVertical,
    DiagonalLinearForward, DiagonalLinearBackward, DiagonalReflectedForward,
    DiagonalReflectedBackward, ArrowLeft, ArrowRight, ArrowUp, ArrowDown,
    Diamond, Butterfly);

constructor TSCGradientPainter.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
  
  FColorBegin := clWindow;
  FColorEnd := clBtnFace;
  FStyle := scdgsLinearV;
  FShift := 0;
  FRotation := 0;
  FReverse := False;

  FPattern := TBitmap.Create;
  FPattern.PixelFormat := pf32bit;

  UpdatePattern;
end;

function TSCGradientPainter.CustomPaint(const Colors: TSCGradientColors;
  APattern: TBitmap): Boolean;
begin
  Result := DoCustomPaint(Colors, APattern);

  if not Result and Assigned(FOnCustom) then
  begin
    Result := True;
    FOnCustom(Self, Colors, APattern);
  end;
end;

destructor TSCGradientPainter.Destroy;
begin
  FreeAndNil(FPattern);
  inherited Destroy;
end;

procedure TSCGradientPainter.DoChanged;
begin
  //
end;

function TSCGradientPainter.DoCustomPaint(const Colors: TSCGradientColors;
  APattern: TBitmap): Boolean;
begin
  Result := False;
end;

procedure TSCGradientPainter.Paint(ACanvas: TCanvas; ARect: TRect);
begin
 if not FDirty and not IsRectEmpty(ARect) then
   ACanvas.StretchDraw(ARect, Pattern);
end;

procedure TSCGradientPainter.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TSCGradientPainter.EndUpdate;
begin
  Dec(FUpdateCount);
  if (FUpdateCount = 0) and FUpdatePended then
    UpdatePattern;
end;

function TSCGradientPainter.GetColorBegin: TColor;
begin
  Result := FColorBegin;
end;

function TSCGradientPainter.GetColorEnd: TColor;
begin
  Result := FColorEnd;
end;

function TSCGradientPainter.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCGradientPainter.Changed;
begin
  UpdatePattern;
  DoChanged;

  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TSCGradientPainter.CopyPatternTo(ABitmap: TBitmap): Boolean;
begin
  Result := False;
  if not FDirty and (FUpdateCount = 0) and Assigned(ABitmap) then
  begin
    ABitmap.Assign(Self.Pattern);
    Result := True;
  end;
end;

procedure TSCGradientPainter.InvalidatePattern;
begin
  UpdatePattern;
end;

procedure TSCGradientPainter.SetColorBegin(Value: TColor);
begin
  if FColorBegin <> Value then
  begin
    FColorBegin := Value;
    Changed;
  end;
end;

procedure TSCGradientPainter.SetColorEnd(Value: TColor);
begin
  if FColorEnd <> Value then
  begin
    FColorEnd := Value;
    Changed;
  end;
end;

procedure TSCGradientPainter.SetStyle(Value: TSCGradientStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Changed;
  end;
end;

procedure TSCGradientPainter.SetShift(Value: TSCGradientShift);
begin
  if Value < Low(TSCGradientShift) then
    Value := Low(TSCGradientShift)
  else if Value > High(TSCGradientShift) then
    Value := High(TSCGradientShift);

  if FShift <> Value then
  begin
    FShift := Value;
    Changed;
  end;
end;

procedure TSCGradientPainter.SetRotation(Value: TSCGradientRotation);
begin
  if Value < Low(TSCGradientRotation) then
    Value := Low(TSCGradientRotation)
  else if Value > High(TSCGradientRotation) then
    Value := High(TSCGradientRotation);

  if FRotation <> Value then
  begin
    FRotation := Value;
    Changed;
  end;
end;

procedure TSCGradientPainter.SetReverse(Value: Boolean);
begin
  if FReverse <> Value then
  begin
    FReverse := Value;
    Changed;
  end;
end;

function TSCGradientPainter.IsColorBeginSaved: Boolean;
begin
  Result := ColorBegin <> clWindow;
end;

function TSCGradientPainter.IsColorEndSaved: Boolean;
begin
  Result := ColorEnd <> clBtnFace;
end;

procedure TSCGradientPainter.UpdatePattern;
var
  Colors: TSCGradientColors;
  dRed, dGreen, dBlue: Integer;
  RGBColor1, RGBColor2: TColor;
  RGB1, RGB2: TRGBQuad;
  Index, rIndex: Integer;
  M, rM: Integer;
begin
  FUpdatePended := True;

  if (FUpdateCount <> 0) then
    Exit;

  FUpdatePended := False;

  if Reverse then
  begin
    RGBColor1 := ColorToRGB(ColorEnd);
    RGBColor2 := ColorToRGB(ColorBegin);
  end else
  begin
    RGBColor1 := ColorToRGB(ColorBegin);
    RGBColor2 := ColorToRGB(ColorEnd);
  end;

  RGB1.rgbRed := GetRValue(RGBColor1);
  RGB1.rgbGreen := GetGValue(RGBColor1);
  RGB1.rgbBlue := GetBValue(RGBColor1);
  RGB1.rgbReserved := 0;

  RGB2.rgbRed := GetRValue(RGBColor2);
  RGB2.rgbGreen := GetGValue(RGBColor2);
  RGB2.rgbBlue := GetBValue(RGBColor2);
  RGB2.rgbReserved := 0;

  if Shift > 0 then
  begin
    RGB1.rgbRed := Byte(RGB1.rgbRed + MulDiv(RGB2.rgbRed - RGB1.rgbRed, Shift, 100));
    RGB1.rgbGreen := Byte(RGB1.rgbGreen + MulDiv(RGB2.rgbGreen - RGB1.rgbGreen, Shift, 100));
    RGB1.rgbBlue := Byte(RGB1.rgbBlue + MulDiv(RGB2.rgbBlue - RGB1.rgbBlue, Shift, 100));
  end
  else if Shift < 0 then
  begin
    RGB2.rgbRed := Byte(RGB2.rgbRed + MulDiv(RGB2.rgbRed - RGB1.rgbRed, Shift, 100));
    RGB2.rgbGreen := Byte(RGB2.rgbGreen + MulDiv(RGB2.rgbGreen - RGB1.rgbGreen, Shift, 100));
    RGB2.rgbBlue := Byte(RGB2.rgbBlue + MulDiv(RGB2.rgbBlue - RGB1.rgbBlue, Shift, 100));
  end;

  dRed := RGB2.rgbRed - RGB1.rgbRed;
  dGreen := RGB2.rgbGreen - RGB1.rgbGreen;
  dBlue := RGB2.rgbBlue - RGB1.rgbBlue;

  M := MulDiv(255, Rotation, 100);
  if M = 0 then
    for Index := 0 to 255 do
      with Colors[Index] do
      begin
        rgbRed := RGB1.rgbRed + (Index * dRed) div 255;
        rgbGreen := RGB1.rgbGreen + (Index * dGreen) div 255;
        rgbBlue := RGB1.rgbBlue + (Index * dBlue) div 255;
      end
  else if M > 0 then
  begin
    M := 255 - M;
    for Index := 0 to M - 1 do
      with Colors[Index] do
      begin
        rgbRed := RGB1.rgbRed + (Index * dRed) div M;
        rgbGreen := RGB1.rgbGreen + (Index * dGreen) div M;
        rgbBlue := RGB1.rgbBlue + (Index * dBlue) div M;
      end;
    for Index := M to 255 do
      with Colors[Index] do
      begin
        rIndex := 255 - Index;
        rM := 255 - M;
        rgbRed := RGB1.rgbRed + ((rIndex) * dRed) div (rM);
        rgbGreen := RGB1.rgbGreen + ((rIndex) * dGreen) div (rM);
        rgbBlue := RGB1.rgbBlue + ((rIndex) * dBlue) div (rM);
      end;
  end
  else if M < 0 then
  begin
    M := -M;
    for Index := 0 to M do
      with Colors[Index] do
      begin
        rgbRed := RGB2.rgbRed - (Index * dRed) div M;
        rgbGreen := RGB2.rgbGreen - (Index * dGreen) div M;
        rgbBlue := RGB2.rgbBlue - (Index * dBlue) div M;
      end;
    for Index := M + 1 to 255 do
      with Colors[Index] do
      begin
        rIndex := 255 - Index;
        rM := 255 - M;
        rgbRed := RGB2.rgbRed - ((rIndex) * dRed) div (rM);
        rgbGreen := RGB2.rgbGreen - ((rIndex) * dGreen) div (rM);
        rgbBlue := RGB2.rgbBlue - ((rIndex) * dBlue) div (rM);
      end;
  end;

  FDirty := True;
  try
    if @PatternBuilder[Style] <> nil then
      PatternBuilder[Style](Colors, Pattern)
    else
    if not CustomPaint(Colors, Pattern) then
    begin
      Pattern.Width := 2;
      Pattern.Height := 2;

      RGBColor1 := ColorToRGB(ColorBegin);

      Pattern.Canvas.Pixels[0, 0] := RGBColor1;
      Pattern.Canvas.Pixels[0, 1] := RGBColor1;
      Pattern.Canvas.Pixels[1, 0] := RGBColor1;
      Pattern.Canvas.Pixels[1, 1] := RGBColor1;
    end;
  finally
    FDirty := False;
  end;
end;

end.