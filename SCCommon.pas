{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCCommon;

{$I SweetControls.inc}

{$IFDEF SC_DELPHI6_UP}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Math, {$IFDEF SC_DELPHI6_UP} Variants, {$ENDIF} SCConsts, SCResStrs;

type
  {$IFDEF SC_DELPHI4_AND_EARLY}
  TWMContextMenu = packed record
    Msg: Cardinal;
    hWnd: HWND;
    case Integer of
      0: (
        XPos: Smallint;
        YPos: Smallint);
      1: (
        Pos: TSmallPoint;
        Result: Longint);
  end;
  {$ENDIF}

  TSCStringList = class;

  TSCStringDatas = array[0..9] of LongInt;

  TSCStringItem = record
    FString : String;
    FObject : TObject;
    FData   : TSCStringDatas;
  end;
  PSCStringItem = ^TSCStringItem;

  TSCStringsSortCompare = function(List: TSCStringList; Index1, Index2: Integer): Integer;

  TSCStringList = class(TStrings)
  private
    FList: TList;
    FDestroying: Boolean;
    FUpdating: Boolean;
    FSorted: Boolean;
    {$IFNDEF SC_CBUILDER}
    FInitialDatas: TSCStringDatas;
    {$ENDIF}
    FOnChange: TNotifyEvent;
    FOnChanging: TNotifyEvent;
    FOnEndUpdate: TNotifyEvent;
    FOnStartUpdate: TNotifyEvent;
    FDuplicates: TSCDuplicates;
    procedure SetSorted(Value: Boolean);
    {$IFNDEF SC_CBUILDER}
    procedure SetInitialDatas(Value: TSCStringDatas);
    {$ENDIF}
    procedure InsertItem(Index: Integer; const S: string);
    procedure RemoveItem(Index: Integer);
    procedure ExchangeItems(Index1, Index2: Integer);
    procedure QuickSort(L, R: Integer; SCompare: TSCStringsSortCompare);
    procedure DoUpdated;
    procedure DoUpdating;
  protected
    {$IFDEF SC_CBUILDER}
    InitialDatas: TSCStringDatas;
    {$ENDIF}
    procedure Destroying;
    procedure Changed; virtual;
    procedure Changing; virtual;

    procedure Updating; dynamic;
    procedure Updated; dynamic;

    function  GetData(Item, Index: Integer): Integer; virtual;
    procedure SetData(Item, Index, Value: Integer); virtual;
    procedure SetDataInternally(Item, Index, Value: Integer); virtual;

    function  Get(Index: Integer): string; override;
    function  GetCount: Integer; override;
    function  GetObject(Index: Integer): TObject; override;
    procedure Put(Index: Integer; const S: string); override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
    procedure SetUpdateState(Updating: Boolean); override;

    property List: TList read FList;
    property Data[Item, Index: Integer]: Integer read GetData write SetData;
    {$IFNDEF SC_CBUILDER}
    property InitialDatas: TSCStringDatas read FInitialDatas write SetInitialDatas;
    {$ENDIF}
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChanging: TNotifyEvent read FOnChanging write FOnChanging;
    property OnStartUpdate: TNotifyEvent read FOnStartUpdate write FOnStartUpdate;
    property OnEndUpdate: TNotifyEvent read FOnEndUpdate write FOnEndUpdate;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    function  Add(const S: string): Integer; override;
    procedure AddStrings(Strings: TStrings); override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Exchange(Index1, Index2: Integer); override;
    function  Find(const S: string; var Index: Integer; CaseSensitive: Boolean): Boolean; virtual;
    function  IndexOf(const S: string): Integer; override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure Sort; virtual;
    procedure CustomSort(Compare: TSCStringsSortCompare); virtual;
    function  FindText(const S: String): Integer; virtual;
    function  CompletedText(const S: String; CaseSensitive: Boolean): Integer; virtual;
    procedure Move(CurIndex, NewIndex: Integer); override;

    property InUpdate: Boolean read FUpdating;
    property InDestroy: Boolean read FDestroying;
    property Sorted: Boolean read FSorted write SetSorted;
    property Duplicates: TSCDuplicates read FDuplicates write FDuplicates;
  end;


  PSCIntegerList = ^TSCIntegerList;
  TSCIntegerList = array[0..MaxListSize - 1] of Integer;
  TSCListNotification = (sclnAdded, sclnExtracted, sclnDeleted);

  TSCIntList = class(TObject)
  private
    FList: PSCIntegerList;
    FCount: Integer;
    FCapacity: Integer;
  protected
    procedure Grow; virtual;
    function  Get(Index: Integer): Integer;
    procedure Put(Index: Integer; Item: Integer);
    procedure Notify(Index: Integer; Action: TSCListNotification); virtual;
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetCount(NewCount: Integer);
  public
    destructor Destroy; override;
    function  Add(Item: Integer): Integer;
    procedure Clear; virtual;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    function  Expand: TSCIntList;
    function  Extract(Index: Integer): Integer;
    function  IndexOf(Item: Integer): Integer;
    procedure Insert(Index: Integer; Item: Integer);
    procedure Move(CurIndex, NewIndex: Integer);
    function  Remove(Item: Integer; All: Boolean): Integer;

    property Capacity: Integer read FCapacity write SetCapacity;
    property Count: Integer read FCount write SetCount;
    property Items[Index: Integer]: Integer read Get write Put; default;
    property List: PSCIntegerList read FList;
  end;
  
  ESCOSError = class(Exception)
  public
    ErrorCode: DWORD;
  end;

  TSCThumbStyle = (sctsArrow, sctsExArrow, sctsMac, sctsMetal, sctsNew,
    sctsPS, sctsPSNew, sctsWindows);

  TSCGradient = (scgNone, scgLeftToRight, scgRightToLeft, scgTopToBottom, scgBottomToTop);



function  GetRealColor(AColor: COLORREF): COLORREF;
function  OffsetColor(BaseColor: COLORREF; DeltaR, DeltaG, DeltaB: Integer; Light: Boolean): COLORREF;
function  BlendedColor(AColor: TColor; DeltaR, DeltaG, DeltaB: Integer; Light: Boolean): TColor;
function  GetLightColor(BtnFaceColor, HighlightColor, WindowColor: Integer): COLORREF;
function  IsColorLight(AColor: TColor): Boolean;
function  scBlendColor(AColor: TColor; Increment: Integer): TColor;
function  MixColors(AColor, WithColor: TColor; Percent: Integer): TColor;


{$IFDEF SC_DELPHI4_AND_EARLY}
procedure FreeAndNil(var Obj);
function  AnsiSameText(const S1, S2: string): Boolean;
function  SameText(const S1, S2: string): Boolean;
{$ENDIF}

procedure scRaiseLastOSError;

function  WinOSUsesGradientCaption: Boolean;
procedure InitiateCaptionGradientColors;
function  scGetParentForm(Control: TControl): TCustomForm;


function  GetBtnHighlightOf(C: TColor): TColor;
function  GetBtnShadowOf(C: TColor): TColor;
function  GetBtnFaceOf(C: TColor): TColor;
function  Get3DDkShadowOf(C: TColor): TColor;

function  GetOfficeXPBtnColor: COLORREF;
function  GetOfficeXPBtnColorOf(AColor: TColor): COLORREF;
function  GetOfficeXPDownedColor: COLORREF;
function  GetOfficeXPDownedSelColor: COLORREF;
function  GetOfficeXPSelColor: COLORREF;

function  GetOffice12GradientDark(AColor: TColor): TColor;
function  GetOffice12GradientLight(AColor: TColor): TColor;
function  GetOffice12GradientExDark(AColor: TColor): TColor;
function  GetOffice12GradientExLight(AColor: TColor): TColor;
function  GetOffice12GradientPeal(AColor: TColor): TColor;
function  GetOffice12GradientPreDark(AColor: TColor): TColor;
function  GetOffice12GradientPreLight(AColor: TColor): TColor;
function  GetOffice12GradientShadow(AColor: TColor): TColor;
function  GetOffice12GradientHighLight(AColor: TColor): TColor;


function  IsOneOfParents(C: TControl; P: TWinControl): Boolean;


procedure scFillGradientRectVertical(ACanvas: TCanvas; ARect: TRect;
  StartColor, EndColor: TColor; ColorCount: Integer; Reverse: Boolean);
procedure scFillGradientRectHorizontal(ACanvas: TCanvas; ARect: TRect;
  StartColor, EndColor: TColor; ColorCount: Integer; Reverse: Boolean);
procedure scFillGradientRect(ACanvas: TCanvas; ARect: TRect; ColorCount: Integer;
  Orientation: TSCGradient; StartColor, EndColor: TColor);
procedure scDrawGradient(ACanvas: TCanvas; R: TRect; Orientation: TSCGradient;
  StartColor, EndColor: TColor);


procedure scDrawXPFace(Kind: TSCScrollbarKind; C: TCanvas; R: TRect;
  Cl, BkCl: TColor; IsDown, IsHot: Boolean);
procedure scDrawXPFace2(Kind: TSCScrollbarKind; C: TCanvas; R: TRect;
  Cl, BkCl: TColor; IsThumb, IsDown, IsHot: Boolean);
procedure scDraw3DFace(Kind: TSCScrollbarKind; C: TCanvas; R: TRect;
  Cl, BkCl: TColor; Reverse, IsDown, IsHot: Boolean);
procedure scDrawNewFace(Kind: TSCScrollbarKind; C: TCanvas; R: TRect;
  Cl, BkCl: TColor; Reverse, IsDown, IsHot: Boolean);
procedure scDrawSports2Face(Kind: TSCScrollbarKind; C: TCanvas; R: TRect;
  Cl: TColor; IsDown, IsHot: Boolean);
procedure scDrawOffice12Face(Kind: TSCScrollbarKind; C: TCanvas; R: TRect;
  Cl, BkCl: TColor; Reverse, IsDown, IsHot, HasFrame, Rounded: Boolean);

  
procedure scFillTriGradient(ACanvas: TCanvas; ARect: TRect; Color1, Color2,
  Color3: TColor; ColorCount: Integer);
procedure scDrawTriGradient(ACanvas: TCanvas; R: TRect; Color1, Color2, Color3: TColor);
procedure CbFastFillTriGradient(ACanvas: TCanvas; ARect: TRect; Color1, Color2, Color3: TColor);
procedure scFillFourGradient(ACanvas: TCanvas; ARect: TRect; LeftTopColor, RightTopColor,
  LeftBottomColor, RightBottomColor: TColor; ColorCount: Integer);
procedure scDrawFourGradient(ACanvas: TCanvas; R: TRect; LeftTopColor, RightTopColor,
  LeftBottomColor, RightBottomColor: TColor);


procedure scFillVerticalRainbow(ACanvas: TCanvas; ARect: TRect; Reverse: Boolean);
procedure scFillHorizontalRainbow(ACanvas: TCanvas; ARect: TRect; Reverse: Boolean);
procedure scFillVerticalExRainbow(ACanvas: TCanvas; ARect: TRect; ExColor: TColor;
  VertReverse, HorzReverse: Boolean);
procedure scFillHorizontalExRainbow(ACanvas: TCanvas; ARect: TRect; ExColor: TColor;
  VertReverse, HorzReverse: Boolean);


function  scVerticalGradientColorOf(P: TPoint; R: TRect; StartColor, EndColor: TColor;
  ColorCount: Integer; Reverse: Boolean): TColor;
function  scHorizontalGradientColorOf(P: TPoint; R: TRect; StartColor, EndColor: TColor;
  ColorCount: Integer; Reverse: Boolean): TColor;
function  scGradientFourColorOf(P: TPoint; R: TRect; LeftTopColor, RightTopColor,
  LeftBottomColor, RightBottomColor: TColor; ColorCount: Integer): TColor;


procedure scDrawFocusRect(C: TCanvas; R: TRect; LineColor: TColor);
procedure scFrame3D(C: TCanvas; var ARect: TRect; TopColor, BottomColor: TColor;
  LineWidth, Rounded: Integer; UseNoneColor: Boolean = True);
procedure scRoundRect(C: TCanvas; var ARect: TRect; TopColor, BottomColor: TColor;
  LineWidth: Integer);
procedure scFillCorners(C: TCanvas; ARect: TRect; AColor: TColor; Rounded: Integer);
procedure scFillWithColors(C: TCanvas; R: TRect; AColor, WithColor: TColor);


procedure scDrawEdgeEx(DC: HDC; R: TRect; C, ParentColor: TColor;
  FillCorner: Boolean; B: TSCBorder; Edges: TSCBorderEdges = SCAllBorderEdges);
procedure scDrawEdge(ACanvas: TCanvas; R: TRect; C, ParentColor: TColor;
  FillCorner: Boolean; B: TSCBorder; Edges: TSCBorderEdges = SCAllBorderEdges);
procedure scDrawBevelEx(DC: HDC; R: TRect; C, ParentColor: TColor;
  FillCorner: Boolean; B: TSCBorder; Edges: TSCBorderEdges = SCAllBorderEdges);
procedure scDrawBevel(ACanvas: TCanvas; R: TRect; C, ParentColor: TColor;
  FillCorner: Boolean; B: TSCBorder; Edges: TSCBorderEdges = SCAllBorderEdges);


procedure scDrawDownSlider(ACanvas: TCanvas; P: TPoint; W, H: Integer;
  Style: TSCThumbStyle; Blind: Boolean; FrameColor: TColor = clNone;
  FaceColor: TColor = clNone);
procedure scDrawUpSlider(ACanvas: TCanvas; P: TPoint; W, H: Integer;
  Style: TSCThumbStyle; Blind: Boolean; FrameColor: TColor = clNone;
  FaceColor: TColor = clNone);
procedure scDrawRightSlider(ACanvas: TCanvas; P: TPoint; W, H: Integer;
  Style: TSCThumbStyle;  Blind: Boolean; FrameColor: TColor = clNone;
  FaceColor: TColor = clNone);
procedure scDrawLeftSlider(ACanvas: TCanvas; P: TPoint; W, H: Integer;
  Style: TSCThumbStyle;  Blind: Boolean; FrameColor: TColor = clNone;
  FaceColor: TColor = clNone);


procedure scDrawXPButton(C: TCanvas; R: TRect; Cl, BkCl: TColor; IsDown, IsHot: Boolean);
procedure scDrawXPThumb(C: TCanvas; R: TRect; Cl: TColor; IsDown, IsHot: Boolean);


function  MouseWheelLine: Integer;
function  GetWinOperatingSystem: Integer;
function  CbxAlphaBlend(Src1, Src2: TBitmap; Amount: Extended): TBitmap;


procedure scHSVtoRGB(const H, S, V: Integer; var R, G, B: Byte);
procedure scRGBToHSV(const R, G, B: Byte; var H, S, V: Integer);
procedure scHSLtoRGB(const H, S, L: Word; var R, G, B: Byte);
procedure scRGBToHSL(const R, G, B: Byte; var H, S, L: Word);
procedure scHSBtoRGB(const H, S, Br: Integer; var R, G, B: Byte);
procedure scRGBToHSB(const R, G, B: Byte; var H, S, Br: Integer);
procedure scRGBToCMYK(const R, G, B: Byte; var C, M, Y, K: Byte);
procedure scCMYKToRGB(C, M, Y, K: Byte; var R, G, B : Byte);

function  scHSVtoColor(const H, S, V: Integer): TColor;
procedure scColorToHSV(const Color: TColor; var H, S, V: Integer);
function  scHSLtoColor(const H, S, L: Word): TColor;
procedure scColorToHSL(const Color: TColor; var H, S, L: Word);
function  scHSBtoColor(const H, S, Br: Integer): TColor;
procedure scColorToHSB(const Color: TColor; var H, S, Br: Integer);
function  scCMYKToColor(const C, M, Y, K: Byte): TColor;
procedure scColorToCMYK(const Color: TColor; var C, M, Y, K: Byte);


function  scDblClickTime: DWord;
function  scKeyBoardDelay: Integer;
function  scKeyBoardSpeed: Integer;
procedure scKillMessage(Wnd: HWnd; Msg: Integer);
function  scVertScrollbarWidth: Integer;
function  scHorzScrollbarHeight: Integer;
function  scVertScrollButtonHeight: Integer;
function  scHorzScrollButtonWidth: Integer;
procedure scApplicationCancelHint;
function  scApplicationHintHidePause: Integer;


function scIsHex(S: string): Boolean;
function scIsFloat(const S: string): Boolean; overload;
function scIsFloat(const S: string; out Value: Extended): Boolean; overload;
function scIsFloat(const S: string; Currency: Boolean): Boolean; overload;
function scIsFloat2(const S: string; out Value: Extended): Boolean;
function scStrToFloatDef(const S: String; Def: Extended): Extended;
function scIsInteger(const S: string): Boolean; overload;
function scIsInteger(const S: string; out Value: Integer): Boolean; overload;
function scIsInt64(const S: string; out Value: Int64): Boolean;


function scFloatToStr(Value: Extended; IsCurrency: Boolean): String;
function scCurrencyToStr(Value: Extended; UseThousandsSeperator: Boolean;
  DecimalPlaces: Byte): String;
function scArrangeDecimalSeperator(S: String; IsCurrency: Boolean; DecimalPlaces: Integer = -1): String;


function scDaysPerMonth(AYear, AMonth: Integer): Integer;
function scGetMonthIndex(M: TSCMonth): Integer;
function scFirstDayOfWeek(D: TDateTime): Word;
function scStrToTime(const S: string; const ATime: TTime; OnError: TSCTimeValidation): TTime;
function scStrToDateTime(const S: string; const ADate: TDateTime; OnError: TSCDateValidation): TDateTime;
function scAdjustTime(T: TTime; AHour, AMinute, ASecond: Integer): TTime;
function scAdjustDate(D: TDateTime; AYear, AMonth, ADay: Integer): TDateTime;

function  scGetSpecialKeyName(ShortCut: TShortCut): string;
function  scShortCutToText(ShortCut: TShortCut): string;
function  scTextToShortCut(Text: string): TShortCut;
function  scShortCut(Key: Word; Shift: TShiftState): TShortCut;
procedure scShortCutToKey(ShortCut: TShortCut; var Key: Word; var Shift: TShiftState);
function  scShiftStateToKeys(Shift: TShiftState): Word;
function  scKeysToShiftState(Keys: Word): TShiftState;
function  scKeyDataToShiftState(KeyData: Longint): TShiftState;
function  scKeyboardStateToShiftState(const KeyboardState: TKeyboardState): TShiftState;


function  scComponentToString(Component: TComponent): string;
function  scStringToComponent(Value: string): TComponent;


function  scVarEquals(const V1, V2: Variant): Boolean;


const
  clSCMacAqua = $00DD8040;
  scRainbowColors: array[0..6] of TColor = (clRed, clYellow, clLime, clAqua,
    clBlue, clFuchsia, clRed);

implementation

function IsOneOfParents(C: TControl; P: TWinControl): Boolean;
var
  W: TWinControl;
begin
  Result := (C <> nil) and (P <> nil);
  if not Result then Exit;

  W := C.Parent;
  while W <> nil do
  begin
    Result := W = P;
    if Result then Exit;

    W := W.Parent;
  end;
end;


var
  GradientLibrary: THandle;
  // GradientFill: function(DC: hDC; pVertex: Pointer; dwNumVertex: DWORD;
  //     pMesh: Pointer; dwNumMesh, dwMode: DWORD): DWord; stdcall;

  GradientFill: function(DC: hDC; pVertex: LongInt; dwNumVertex: DWORD;
      pMesh: LongInt; dwNumMesh, dwMode: DWORD): DWord; stdcall;

type
  TRIVERTEX = packed record
    X, Y: DWORD;
    Red, Green, Blue, Alpha: Word;
  end;

function CbxAlphaBlend(Src1, Src2: TBitmap; Amount: Extended): TBitmap;
var
  w, h, x, y, XFactor: Integer;
  AmountFit: Extended;
  Ps1, Ps2, Pd: PByteArray;
begin
  Result := TBitmap.Create;

  w := Src1.Width;
  h := Src1.Height;

  if (w <> Src2.Width) or (h <> Src2.Height) then
    raise Exception.Create('Source dimensions are not the identical.');

  AmountFit := 1-Amount;

  Result.Width  := w;
  Result.Height := h;
  Result.PixelFormat := pf24bit;

  if Src1.PixelFormat <> pf24bit then Src1.PixelFormat := pf24bit;
  if Src2.PixelFormat <> pf24bit then Src2.PixelFormat := pf24bit;

  for y := 0 to h - 1 do
  begin
    Ps1 := Src1.ScanLine[y];
    Ps2 := Src2.ScanLine[y];
    Pd  := Result.ScanLine[y];

    for x := 0 to w - 1 do
    begin
      XFactor := 3*x;
      Pd[XFactor] := Round(AmountFit*Ps1[XFactor] + Amount*Ps2[XFactor]);
      Pd[XFactor + 1] := Round(AmountFit*Ps1[XFactor + 1] + Amount*Ps2[XFactor + 1]);
      Pd[XFactor + 2] := Round(AmountFit*Ps1[XFactor + 2] + Amount*Ps2[XFactor + 2]);
    end;
  end;
end;

function MouseWheelLine: Integer;
begin
  Result := 1;
  if (scCurrentOperatingSystem >= cOsWinNT) and
    not SystemParametersInfo(SPI_GETWHEELSCROLLLINES, 0, @Result, 0) then
    Result := 1;
end;

function GetWinOperatingSystem: Integer;
var
  osVerInfo: TOSVersionInfo;
  majorVer, minorVer: Integer;
begin
  Result := cOsUnknown;
  { set operating system type flag }
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(osVerInfo) then
  begin
   majorVer := osVerInfo.dwMajorVersion;
   minorVer := osVerInfo.dwMinorVersion;
    case osVerInfo.dwPlatformId of
      VER_PLATFORM_WIN32_NT: { Windows NT/2000 }
        begin
          if majorVer <= 4 then
            Result := cOsWinNT
          else if (majorVer = 5) and (minorVer= 0) then
            Result := cOsWin2000
          else if (majorVer = 5) and (minorVer = 1) then
            Result := cOsXP
          else if (majorVer >= 5) then
            Result := cOsOverXP
          else
            Result := cOsUnknown;
        end;
      VER_PLATFORM_WIN32_WINDOWS:  { Windows 9x/ME }
        begin
          if (majorVer < 4) then
            Result := cOsBelow95
          else if (majorVer = 4) and (minorVer = 0) then
            Result := cOsWin95
          else if (majorVer = 4) and (minorVer = 10) then
          begin
            if osVerInfo.szCSDVersion[1] = 'A' then
              Result := cOsWin98SE
            else
              Result := cOsWin98;
          end
          else if (majorVer = 4) and (minorVer = 90) then
            Result := cOsWinME
          else
            Result := cOsUnknown;
        end;
    else
      Result := cOsUnknown;
    end;
  end;
end;

function GetRealColor(AColor: COLORREF): COLORREF;
var
  DC: HDC;
begin
  DC := GetDC(0);
  Result := GetNearestColor(DC, AColor);
  ReleaseDC(0, DC);
end;

function OffsetColor(BaseColor: COLORREF; DeltaR, DeltaG, DeltaB: Integer;
  Light: Boolean): COLORREF;
var
  R, G, B: Integer;
begin
  if Light then
  begin
    R := GetRValue(BaseColor) + Abs(DeltaR);
    if R > 255 then R := 255;
    G := GetGValue(BaseColor) + Abs(DeltaG);
    if G > 255 then G := 255;
    B := GetBValue(BaseColor) + Abs(DeltaB);
    if B > 255 then B := 255;
  end else
  begin
    R := GetRValue(BaseColor) - Abs(DeltaR);
    if R < 0 then R := 0;
    G := GetGValue(BaseColor) - Abs(DeltaG);
    if G < 0 then G := 0;
    B := GetBValue(BaseColor) - Abs(DeltaB);
    if B < 0 then B := 0;
  end;
  Result := RGB(R, G, B);
end;

function BlendedColor(AColor: TColor; DeltaR, DeltaG, DeltaB: Integer;
  Light: Boolean): TColor;
var
  AColorRef: TColorRef;
begin
  AColorRef := TColorRef(ColorToRGB(AColor));
  Result := GetRealColor(OffsetColor(AColorRef, DeltaR, DeltaG, DeltaB, Light));
end;

function GetLightColor(BtnFaceColor, HighlightColor, WindowColor: Integer): COLORREF;
var
  ABtnFace, AHighlight, AWindow: COLORREF;

  function GetLightIndex(ABtnFaceValue, AHighlightValue, AWindowValue: Byte): Integer;
  begin
    Result := MulDiv(ABtnFaceValue, BtnFaceColor, 100) +
      MulDiv(AHighlightValue, HighlightColor, 100) +
      MulDiv(AWindowValue, WindowColor, 100);

    if Result < 0 then Result := 0;
    if Result > 255 then Result := 255;
  end;

begin
  ABtnFace   := GetSysColor(COLOR_BTNFACE);
  AHighlight := GetSysColor(COLOR_HIGHLIGHT);
  AWindow    := GetSysColor(COLOR_WINDOW);

  if (ABtnFace = 0) or (ABtnFace = $FFFFFF) then
    Result := AHighlight
  else
    Result := RGB(
      GetLightIndex(GetRValue(ABtnFace), GetRValue(AHighlight), GetRValue(AWindow)),
      GetLightIndex(GetGValue(ABtnFace), GetGValue(AHighlight), GetGValue(AWindow)),
      GetLightIndex(GetBValue(ABtnFace), GetBValue(AHighlight), GetBValue(AWindow)));
end;

function IsColorLight(AColor: TColor): Boolean;
var
  AColorRef: TColorRef;
begin
  AColorRef := TColorRef(ColorToRGB(AColor));
  Result := Round((GetRValue(AColorRef) +
    GetBValue(AColorRef) + GetGValue(AColorRef))/3) >= 225;
end;

function scBlendColor(AColor: TColor; Increment: Integer): TColor;
var
  C: LongInt;
  R, G, B: Integer;
begin
  if Increment < -255 then
    Increment := -255;

  if Increment > 255 then
    Increment := 255;

  C := ColorToRGB(AColor);

  R := GetRValue(C);
  G := GetGValue(C);
  B := GetBValue(C);

  Inc(R, Increment);
  if R < 0 then R := 0
  else
  if R > 255 then R := 255;

  Inc(G, Increment);
  if G < 0 then G := 0
  else
  if G > 255 then G := 255;

  Inc(B, Increment);
  if B < 0 then B := 0
  else
  if B > 255 then B := 255;

  Result := RGB(R, G, B);
end;

function MixColors(AColor, WithColor: TColor; Percent: Integer): TColor;
var
  C1, C2: LongInt;
  R1, G1, B1,
  R2, G2, B2: Integer;
begin
  if Percent < -100 then
    Percent := -100;

  if Percent > 100 then
    Percent := 100;

  C1 := ColorToRGB(AColor);
  C2 := ColorToRGB(WithColor);

  if C1 = C2 then
  begin
    Result := AColor;
    Exit;
  end;

  R1 := GetRValue(C1);
  G1 := GetGValue(C1);
  B1 := GetBValue(C1);

  R2 := GetRValue(C2);
  G2 := GetGValue(C2);
  B2 := GetBValue(C2);

  Inc(R1, Round(Percent*(R2 - R1)/100));
  if R1 < 0 then R1 := 0
  else
  if R1 > 255 then R1 := 255;

  Inc(G1, Round(Percent*(G2 - G1)/100));
  if G1 < 0 then G1 := 0
  else
  if G1 > 255 then G1 := 255;

  Inc(B1, Round(Percent*(B2 - B1)/100));
  if B1 < 0 then B1 := 0
  else
  if B1 > 255 then B1 := 255;

  Result := RGB(R1, G1, B1);
end;

function GetBtnHighlightOf(C: TColor): TColor;
var
  Cl: LongInt;
  R, G, B: Integer;
begin
  // Result := BlendedColor(C, 220, 220, 220, True);

  Cl := ColorToRGB(C);

  R := GetRValue(Cl);
  G := GetGValue(Cl);
  B := GetBValue(Cl);

  Inc(R, Round(7*(255 - R) / 8));
  Inc(G, Round(7*(255 - G) / 8));
  Inc(B, Round(7*(255 - B) / 8));

  Result := RGB(R, G, B);
end;

function GetBtnShadowOf(C: TColor): TColor;
var
  Cl: LongInt;
  R, G, B: Integer;
begin
  // Result := BlendedColor(C, 96, 96, 96, False);

  Cl := ColorToRGB(C);

  R := GetRValue(Cl);
  G := GetGValue(Cl);
  B := GetBValue(Cl);

  Dec(R, Round(3*R / 8));
  Dec(G, Round(3*G / 8));
  Dec(B, Round(3*B / 8));

  Result := RGB(R, G, B);
end;

function GetBtnFaceOf(C: TColor): TColor;
begin
  // Result := BlendedColor(C, 24, 24, 24, False);
  Result := C;
end;

function Get3DDkShadowOf(C: TColor): TColor;
var
  Cl: LongInt;
  R, G, B: Integer;
begin
  // Result := BlendedColor(C, 160, 160, 160, False);

  Cl := ColorToRGB(C);

  R := GetRValue(Cl);
  G := GetGValue(Cl);
  B := GetBValue(Cl);

  Dec(R, Round(5*R / 7));
  Dec(G, Round(5*G / 7));
  Dec(B, Round(5*B / 7));

  Result := RGB(R, G, B);
end;

function GetOfficeXPBtnColor: COLORREF;

  function GetLightValue(Value: Byte): Byte;
  begin
    Result := Value + MulDiv(255 - Value, 16, 100);
  end;

begin
  Result := GetSysColor(COLOR_BTNFACE);
  Result := RGB(GetLightValue(GetRValue(Result)),
    GetLightValue(GetGValue(Result)), GetLightValue(GetBValue(Result)));

  Result := GetRealColor(Result);
end;

function GetOfficeXPBtnColorOf(AColor: TColor): COLORREF;

  function GetLightValue(Value: Byte): Byte;
  begin
    Result := Value + MulDiv(255 - Value, 16, 100);
  end;

begin
  Result := ColorToRGB(AColor);
  Result := RGB(GetLightValue(GetRValue(Result)),
    GetLightValue(GetGValue(Result)), GetLightValue(GetBValue(Result)));

  Result := GetRealColor(Result);
end;

function GetOfficeXPDownedColor: COLORREF;
begin
  Result := GetRealColor(GetLightColor(11, 9, 73));
end;

function GetOfficeXPDownedSelColor: COLORREF;
begin
  Result := GetRealColor(GetLightColor(14, 44, 40));
end;

function GetOfficeXPSelColor: COLORREF;
begin
  Result := GetRealColor(GetLightColor(-2, 30, 72));
end;

function GetOffice12GradientDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -16);
end;

function GetOffice12GradientExDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -40);
end;

function GetOffice12GradientExLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 40);
end;

function GetOffice12GradientLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 30);
end;

function GetOffice12GradientPeal(AColor: TColor): TColor;
begin
  Result := BlendedColor(AColor, 52, 44, 112, True);
end;

function GetOffice12GradientPreDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -80);
end;

function GetOffice12GradientPreLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 100);
end;

function GetOffice12GradientShadow(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -6);
end;

function GetOffice12GradientHighLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 120);
end;

{$IFDEF SC_DELPHI4_AND_EARLY}
procedure FreeAndNil(var Obj);
var
  P: TObject;
begin
  P := TObject(Obj);
  TObject(Obj) := nil;  // clear the reference before destroying the object
  P.Free;
end;

function AnsiSameText(const S1, S2: string): Boolean;
begin
  Result := AnsiCompareText(S1, S2) = 0;
end;

function SameText(const S1, S2: string): Boolean; assembler;
asm
        CMP     EAX,EDX
        JZ      @1
        OR      EAX,EAX
        JZ      @2
        OR      EDX,EDX
        JZ      @3
        MOV     ECX,[EAX-4]
        CMP     ECX,[EDX-4]
        JNE     @3
        CALL    CompareText
        TEST    EAX,EAX
        JNZ     @3
@1:     MOV     AL,1
@2:     RET
@3:     XOR     EAX,EAX
end;
{$ENDIF}

function WinOSUsesGradientCaption: Boolean;
begin
  if not SystemParametersInfo(SPI_GETGRADIENTCAPTIONS, 0, @Result, 0) then
    Result := False;
end;

procedure scFillGradientRectVertical(ACanvas: TCanvas; ARect: TRect;
  StartColor, EndColor: TColor; ColorCount: Integer; Reverse: Boolean);
var
  R: TRect;
  I, H: Integer;
  YDif, ThisRGB, RGB1, RGB2: array[0..2] of DWord;
  C1, C2, Tmp: LongInt;
  ThisColor: TColor;
begin
  if (ACanvas = nil) or IsRectEmpty(ARect) then
    Exit;

  R := ARect;
  H := R.Bottom - R.Top;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Pen.Mode    := pmCopy;
    Pen.Style   := psSolid;
  end;

  if (H = 1) or (StartColor = EndColor) then
  begin
    with ACanvas do
    begin
      Brush.Color := StartColor;
      FillRect(ARect);
    end;

    Exit;
  end;

  C1 := ColorToRGB(StartColor);
  C2 := ColorToRGB(EndColor);

  if Reverse then
  begin
    Tmp := C1;
    C1  := C2;
    C2  := Tmp;
  end;

  RGB1[0] := GetRValue(C1);
  RGB1[1] := GetGValue(C1);
  RGB1[2] := GetBValue(C1);

  RGB2[0] := GetRValue(C2);
  RGB2[1] := GetGValue(C2);
  RGB2[2] := GetBValue(C2);

  if ColorCount > H - 1 then
    ColorCount := H - 1;

  if ColorCount > 255 then ColorCount := 255;

  YDif[0] := RGB1[0] - RGB2[0];
  YDif[1] := RGB1[1] - RGB2[1];
  YDif[2] := RGB1[2] - RGB2[2];

  R.Top := ARect.Top;
  R.Bottom := R.Top;

  for I := 0 to ColorCount do
  begin
    Inc(R.Bottom, MulDiv(I, H-1, ColorCount) - MulDiv(I-1, H-1, ColorCount));
    if R.Bottom = R.Top then Inc(R.Bottom);

    try
      IntersectRect(R, R, ARect);
      if IsRectEmpty(R) then Continue;

      ThisRGB[0] := RGB1[0] - DWord(Muldiv(I, YDif[0], ColorCount));
      ThisRGB[1] := RGB1[1] - DWord(Muldiv(I, YDif[1], ColorCount));
      ThisRGB[2] := RGB1[2] - DWord(Muldiv(I, YDif[2], ColorCount));

      with ACanvas do
      begin
        ThisColor := TColor(RGB(ThisRGB[0], ThisRGB[1], ThisRGB[2]));

        if (R.Right - R.Left = 1) and (R.Bottom - R.Top = 1) then
          Pixels[R.Left, R.Top] := ThisColor
        else begin
          Brush.Color := ThisColor;
          PatBlt(Handle, R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top, PatCopy);
        end;
      end;
    finally
      R.Top := R.Bottom;
    end;
  end;
end;

procedure scFillGradientRectHorizontal(ACanvas: TCanvas; ARect: TRect;
  StartColor, EndColor: TColor; ColorCount: Integer; Reverse: Boolean);
var
  R: TRect;
  I, W: Integer;
  XDif, ThisRGB, RGB1, RGB2: array[0..2] of DWord;
  C1, C2, Tmp: LongInt;
  ThisColor: TColor;
begin
  if (ACanvas = nil) or IsRectEmpty(ARect) then
    Exit;

  R := ARect;
  W := R.Right - R.Left;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Pen.Mode    := pmCopy;
    Pen.Style   := psSolid;
  end;

  if (W = 1) or (StartColor = EndColor) then
  begin
    with ACanvas do
    begin
      Brush.Color := StartColor;
      FillRect(ARect);
    end;

    Exit;
  end;

  C1 := ColorToRGB(StartColor);
  C2 := ColorToRGB(EndColor);

  if Reverse then
  begin
    Tmp := C1;
    C1  := C2;
    C2  := Tmp;
  end;

  RGB1[0] := GetRValue(C1);
  RGB1[1] := GetGValue(C1);
  RGB1[2] := GetBValue(C1);

  RGB2[0] := GetRValue(C2);
  RGB2[1] := GetGValue(C2);
  RGB2[2] := GetBValue(C2);

  if ColorCount > W - 1 then
    ColorCount := W - 1;

  if ColorCount > 255 then ColorCount := 255;

  XDif[0] := RGB1[0] - RGB2[0];
  XDif[1] := RGB1[1] - RGB2[1];
  XDif[2] := RGB1[2] - RGB2[2];

  R.Left  := ARect.Left;
  R.Right := R.Left;

  for I := 0 to ColorCount do
  begin
    Inc(R.Right, MulDiv(I, W-1, ColorCount) - MulDiv(I-1, W-1, ColorCount));
    if R.Right = R.Left then Inc(R.Right);

    try
      IntersectRect(R, R, ARect);
      if IsRectEmpty(R) then Continue;

      ThisRGB[0] := RGB1[0] - DWord(Muldiv(I, XDif[0], ColorCount));
      ThisRGB[1] := RGB1[1] - DWord(Muldiv(I, XDif[1], ColorCount));
      ThisRGB[2] := RGB1[2] - DWord(Muldiv(I, XDif[2], ColorCount));

      with ACanvas do
      begin
        ThisColor := TColor(RGB(ThisRGB[0], ThisRGB[1], ThisRGB[2]));

        if (R.Right - R.Left = 1) and (R.Bottom - R.Top = 1) then
          Pixels[R.Left, R.Top] := ThisColor
        else begin
          Brush.Color := ThisColor;
          PatBlt(Handle, R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top, PatCopy);
        end;
      end;
    finally
      R.Left := R.Right;
    end;
  end;
end;

procedure scFillGradientRect(ACanvas: TCanvas; ARect: TRect; ColorCount: Integer;
  Orientation: TSCGradient; StartColor, EndColor: TColor);
begin
  if (Orientation = scgNone) or (ACanvas = nil) or IsRectEmpty(ARect) then
    Exit;

  case Orientation of
    scgLeftToRight, scgRightToLeft:
    begin
      scFillGradientRectHorizontal(ACanvas, ARect, StartColor, EndColor,
        ColorCount, Orientation = scgRightToLeft);
    end;
    scgTopToBottom, scgBottomToTop:
    begin
      scFillGradientRectVertical(ACanvas, ARect, StartColor, EndColor,
        ColorCount, Orientation = scgBottomToTop);
    end;
  end;
end;

procedure scDrawGradient(ACanvas: TCanvas; R: TRect;
  Orientation: TSCGradient; StartColor, EndColor: TColor);
var
  ARect: TRect;
  Os: Integer;
  TVs: array[0..1] of TRIVERTEX;
  GradRect: GRADIENT_RECT;
  AStartColor, AEndColor: TColor;
  StartColorRef, EndColorRef: TColorRef;
begin
  if (Orientation = scgNone) or (ACanvas = nil) or IsRectEmpty(R) then
    Exit;

  ARect := R;
  Os := scCurrentOperatingSystem;
  if (Os = cOsUnknown) or (Os = cOsWin95) or (Os = cOsWinNT) then
  begin
    scFillGradientRect(ACanvas, ARect, 255, Orientation,
      StartColor, EndColor);
    Exit;
  end;

  if GradientLibrary <= 0 then
  begin
    scFillGradientRect(ACanvas, ARect, 255, Orientation,
      StartColor, EndColor);
    Exit;
  end;

  @GradientFill := GetProcAddress(GradientLibrary, PChar('GradientFill'));
  if @GradientFill = nil then
  begin
    scFillGradientRect(ACanvas, ARect, 255, Orientation,
      StartColor, EndColor);
    Exit;
  end;

  case Orientation of
    scgLeftToRight, scgTopToBottom:
      begin
        AStartColor := StartColor;
        AEndColor := EndColor;
      end;
    scgRightToLeft, scgBottomToTop:
      begin
        AStartColor := EndColor;
        AEndColor := StartColor;
      end;
    else begin
      AStartColor := StartColor;
      AEndColor := EndColor;
    end;
  end;

  StartColorRef := TColorRef(ColorToRGB(AStartColor));
  EndColorRef := TColorRef(ColorToRGB(AEndColor));

  with TVs[0] do
  begin
    x := ARect.Left;
    y := ARect.Top;
    Green := GetGValue(StartColorRef) shl 8;
    Blue := GetBValue(StartColorRef) shl 8;
    Red := GetRValue(StartColorRef) shl 8;
  end;

  with TVs[1] do
  begin
    x := ARect.Right;
    y := ARect.Bottom;
    Green := GetGValue(EndColorRef) shl 8;
    Blue := GetBValue(EndColorRef) shl 8;
    Red := GetRValue(EndColorRef) shl 8;
  end;

  with GradRect do
  begin
    UpperLeft := 0;
    LowerRight := 1;
  end;

  try
    with ACanvas do
    begin
      Brush.Color := AEndColor;
      ARect := R;
      FillRect(ARect);
      if (Orientation = scgLeftToRight) or (Orientation = scgRightToLeft) then
        GradientFill(ACanvas.Handle, LongInt(@TVs), 2, LongInt(@GradRect), 1, GRADIENT_FILL_RECT_H)
      else
        GradientFill(ACanvas.Handle, LongInt(@TVs), 2, LongInt(@GradRect), 1, GRADIENT_FILL_RECT_V);
    end;
  finally
    // FreeLibrary(H);
  end;
end;

procedure scDrawXPFace(Kind: TSCScrollbarKind; C: TCanvas; R: TRect;
  Cl, BkCl: TColor; IsDown, IsHot: Boolean);
var
  CR: TRect;
  GradOrient: TSCGradient;
  BtmColor, TopColor,
  CornerColor1, CornerColor2: TColor;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  CR := R;

  GradOrient := scgTopToBottom;
  if Kind = scskVertical then
    GradOrient := scgLeftToRight;

  // outter sunken frame
  if BkCl = clNone then BkCl := clBtnFace;

  TopColor := BlendedColor(BkCl, 16, 16, 16, False);
  BtmColor := BlendedColor(BkCl, 48, 48, 48, True);

  scDrawGradient(C, R, GradOrient, TopColor, BtmColor);

  if not IsRectEmpty(R) then
    with C do
    begin
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := BkCl;

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
  TopColor := BlendedColor(Cl, 144, 144, 144, False);
  BtmColor := BlendedColor(TopColor, 16, 16, 16, True);

  scDrawGradient(C, R, GradOrient, TopColor, BtmColor);

  if not IsRectEmpty(R) then
    with C do
    begin
      Pen.Mode  := pmCopy;
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

  // face
  if IsDown and IsHot then
  begin
    TopColor := BlendedColor(Cl, 24, 24, 24, True);
    BtmColor := BlendedColor(Cl, 48, 48, 48, True);
  end else
  begin
    TopColor := BlendedColor(Cl, 48, 48, 48, True);
    BtmColor := BlendedColor(Cl, 24, 24, 24, False);
  end;

  scDrawGradient(C, R, GradOrient, TopColor, BtmColor);

  if not IsRectEmpty(R) then
    with C do
    begin
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Color := TopColor;

      MoveTo(R.Left, R.Top);
      LineTo(R.Left, R.Bottom);

      MoveTo(R.Right - 1, R.Top);
      LineTo(R.Right - 1, R.Bottom);
    end;

  R := CR;
  InflateRect(R, -1, -1);

  if not IsRectEmpty(R) then
    with C do
    begin
      Pen.Mode  := pmCopy;
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

  R := CR;  
  with C do
  begin
    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
    Pen.Color := BkCl;

    MoveTo(R.Left, R.Top);
    LineTo(R.Left, R.Top + 1);

    MoveTo(R.Right - 1, R.Top);
    LineTo(R.Right - 1, R.Top + 1);

    MoveTo(R.Left, R.Bottom - 1);
    LineTo(R.Left, R.Bottom - 2);

    MoveTo(R.Right - 1, R.Bottom - 1);
    LineTo(R.Right - 1, R.Bottom - 2);
  end;
end;

procedure scDrawXPFace2(Kind: TSCScrollbarKind; C: TCanvas; R: TRect;
  Cl, BkCl: TColor; IsThumb, IsDown, IsHot: Boolean);
var
  CR: TRect;
  GradOrient: TSCGradient;
  BtmColor, TopColor,
  CornerColor1, CornerColor2: TColor;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  CR := R;

  if IsThumb then
  begin
    GradOrient := scgTopToBottom;
    if Kind = scskVertical then
      GradOrient := scgLeftToRight;
  end else
  begin
    GradOrient := scgLeftToRight;
    if Kind = scskVertical then
      GradOrient := scgTopToBottom;
  end;

  // outter frame
  if BkCl = clNone then BkCl := clBtnFace;

  TopColor := BlendedColor(BkCl, 16, 16, 16, False);
  BtmColor := BlendedColor(BkCl, 48, 48, 48, True);

  CornerColor1 := TopColor;
  CornerColor2 := BtmColor;

  TopColor := BlendedColor(Cl, 144, 144, 144, False);
  BtmColor := BlendedColor(TopColor, 16, 16, 16, True);

  scDrawGradient(C, R, GradOrient, TopColor, BtmColor);

  if not IsRectEmpty(R) then
    with C do
    begin
      Pen.Mode  := pmCopy;
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

  // face
  if IsDown and IsHot then
  begin
    TopColor := BlendedColor(Cl, 24, 24, 24, True);
    BtmColor := BlendedColor(Cl, 48, 48, 48, True);
  end else
  begin
    TopColor := BlendedColor(Cl, 48, 48, 48, True);
    BtmColor := BlendedColor(Cl, 24, 24, 24, False);
  end;

  scDrawGradient(C, R, GradOrient, TopColor, BtmColor);

  if not IsRectEmpty(R) and ((IsThumb and (Kind = scskHorizontal)) or
    (not IsThumb and (Kind = scskVertical))) then
    with C do
    begin
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Color := TopColor;

      MoveTo(R.Left, R.Top);
      LineTo(R.Left, R.Bottom);

      MoveTo(R.Right - 1, R.Top);
      LineTo(R.Right - 1, R.Bottom);
    end;

  R := CR;

  if not IsRectEmpty(R) then
    with C do
    begin
      Pen.Mode  := pmCopy;
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

  R := CR;  
  with C do
  begin
    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
    Pen.Color := BkCl;

    MoveTo(R.Left, R.Top);
    LineTo(R.Left, R.Top + 1);

    MoveTo(R.Right - 1, R.Top);
    LineTo(R.Right - 1, R.Top + 1);

    MoveTo(R.Left, R.Bottom - 1);
    LineTo(R.Left, R.Bottom - 2);

    MoveTo(R.Right - 1, R.Bottom - 1);
    LineTo(R.Right - 1, R.Bottom - 2);
  end;
end;

procedure scDraw3DFace(Kind: TSCScrollbarKind; C: TCanvas; R: TRect;
  Cl, BkCl: TColor; Reverse, IsDown, IsHot: Boolean);
var
  R2: TRect;
  C1, C2: TColor;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  if (not Reverse and (Kind = scskHorizontal)) or
    (Reverse and (Kind = scskVertical)) then
  begin
    C1 := SCCommon.scBlendColor(Cl, 64);
    C2 := SCCommon.scBlendColor(Cl, -64);

    if IsDown and IsHot then
    begin
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C2;

        FillRect(R);
      end;
    end else
    begin
      R2 := R;
      R2.Bottom := R2.Top + Round((R2.Bottom - R2.Top) / 2);

      scDrawGradient(C, R2, scgTopToBottom, C1, Cl);

      R2 := R;
      R2.Top := R2.Bottom - Round((R2.Bottom - R2.Top) / 2);

      scDrawGradient(C, R2, scgTopToBottom, Cl, C2);
    end;

    R2 := R;
    scFrame3D(C, R2, C1, C2, 1, 0);

    C1 := SCCommon.scBlendColor(Cl, 48);
    C2 := SCCommon.scBlendColor(Cl, -48);

    scFrame3D(C, R2, C1, C2, 1, 0);
  end else
  begin
    C1 := SCCommon.scBlendColor(Cl, 64);
    C2 := SCCommon.scBlendColor(Cl, -64);

    if IsDown and IsHot then
    begin
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C2;

        FillRect(R);
      end;
    end else
    begin
      R2 := R;
      R2.Right := R2.Left + ((R2.Right - R2.Left) div 2);

      scDrawGradient(C, R2, scgLeftToRight, C1, Cl);

      R2 := R;
      R2.Left := R2.Right - ((R2.Right - R2.Left) div 2);

      scDrawGradient(C, R2, scgLeftToRight, Cl, C2);
    end;

    R2 := R;
    scFrame3D(C, R2, C1, C2, 1, 0);

    C1 := SCCommon.scBlendColor(Cl, 48);
    C2 := SCCommon.scBlendColor(Cl, -48);

    scFrame3D(C, R2, C1, C2, 1, 0);
  end;
end;

procedure scDrawNewFace(Kind: TSCScrollbarKind; C: TCanvas; R: TRect;
  Cl, BkCl: TColor; Reverse, IsDown, IsHot: Boolean);
var
  R2: TRect;
  C1, C2: TColor;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  if (not Reverse and (Kind = scskHorizontal)) or
    (Reverse and (Kind = scskVertical)) then
  begin
    C1 := SCCommon.scBlendColor(Cl, 48);
    C2 := SCCommon.scBlendColor(Cl, -48);

    if IsDown and IsHot then
    begin
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C2;

        FillRect(R);
      end;
    end else
    begin
      R2 := R;
      R2.Bottom := R2.Top + Round((R2.Bottom - R2.Top) / 2);

      scDrawGradient(C, R2, scgTopToBottom, C1, Cl);

      R2 := R;
      R2.Top := R2.Bottom - Round((R2.Bottom - R2.Top) / 2);

      scDrawGradient(C, R2, scgTopToBottom, Cl, C2);
    end;

    R2 := R;
    scFrame3D(C, R2, C1, C2, 1, 0);

    InflateRect(R2, 1, 1);
    C1 := SCCommon.scBlendColor(Cl, -96);

    scFrame3D(C, R2, C1, C1, 1, 0);
  end else
  begin
    C1 := SCCommon.scBlendColor(Cl, 48);
    C2 := SCCommon.scBlendColor(Cl, -48);

    if IsDown and IsHot then
    begin
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C2;

        FillRect(R);
      end;
    end else
    begin
      R2 := R;
      R2.Right := R2.Left + ((R2.Right - R2.Left) div 2);

      scDrawGradient(C, R2, scgLeftToRight, C1, Cl);

      R2 := R;
      R2.Left := R2.Right - ((R2.Right - R2.Left) div 2);

      scDrawGradient(C, R2, scgLeftToRight, Cl, C2);
    end;

    R2 := R;
    scFrame3D(C, R2, C1, C2, 1, 0);

    InflateRect(R2, 1, 1);
    C1 := SCCommon.scBlendColor(Cl, -96);

    scFrame3D(C, R2, C1, C1, 1, 0);
  end;
end;

procedure scDrawOffice12Face(Kind: TSCScrollbarKind; C: TCanvas; R: TRect;
  Cl, BkCl: TColor; Reverse, IsDown, IsHot, HasFrame, Rounded: Boolean);
var
  R1, R2: TRect;
  C1, C2: TColor;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  R1 := R;
  InflateRect(R1, -1, -1);
  
  C1 := SCCommon.scBlendColor(Cl, 48);
  C2 := SCCommon.scBlendColor(Cl, -24);

  if IsDown then
  begin
    C1 := SCCommon.scBlendColor(Cl, 32);
    C2 := SCCommon.scBlendColor(Cl, -48);
  end else
  if IsHot then
  begin
    C1 := SCCommon.scBlendColor(Cl, 32);
    C2 := SCCommon.scBlendColor(Cl, -36);
  end;

  if (not Reverse and (Kind = scskHorizontal)) or
    (Reverse and (Kind = scskVertical)) then
  begin
    R2 := R1;
    R2.Bottom := R2.Top + Round((R2.Bottom - R2.Top) / 2);

    scDrawGradient(C, R2, scgTopToBottom, C1, Cl);

    R2 := R1;
    R2.Top := R2.Bottom - Round((R2.Bottom - R2.Top) / 2);

    scDrawGradient(C, R2, scgTopToBottom, C2, C1);
  end else
  begin
    R2 := R1;
    R2.Right := R2.Left + ((R2.Right - R2.Left) div 2);

    scDrawGradient(C, R2, scgLeftToRight, C1, Cl);

    R2 := R1;
    R2.Left := R2.Right - ((R2.Right - R2.Left) div 2);

    scDrawGradient(C, R2, scgLeftToRight, C2, C1);
  end;

  if HasFrame then
  begin
    R2 := R;
    InflateRect(R2, -1, -1);

    C1 := SCCommon.scBlendColor(Cl, 24);
    scFrame3D(C, R2, C1, Cl, 1, 0);

    R2 := R;
    C1 := SCCommon.scBlendColor(Cl, -86);
    
    if Rounded then
      scFrame3D(C, R2, C1, C1, 1, 2)
    else scFrame3D(C, R2, C1, C1, 1, 0);

    if Rounded then
    begin
      InflateRect(R2, 1, 1);
      Dec(R2.Right);
      Dec(R2.Bottom);

      C2 := MixColors(C1, C.Pixels[R2.Left, R2.Top], 60);
      C.Pixels[R2.Left, R2.Top] := C2;

      C2 := MixColors(C1, C.Pixels[R2.Right, R2.Top], 60);
      C.Pixels[R2.Right, R2.Top] := C2;

      C2 := MixColors(C1, C.Pixels[R2.Right, R2.Bottom], 60);
      C.Pixels[R2.Right, R2.Bottom] := C2;

      C2 := MixColors(C1, C.Pixels[R2.Left, R2.Bottom], 60);
      C.Pixels[R2.Left, R2.Bottom] := C2;
    end;
  end;
end;

procedure scDrawSports2Face(Kind: TSCScrollbarKind; C: TCanvas; R: TRect;
  Cl: TColor; IsDown, IsHot: Boolean);
var
  CR: TRect;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  with C do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Cl;

    FillRect(R);
  end;

  CR := R;

  if IsDown and IsHot then
    scFrame3D(C, CR, Get3DDkShadowOf(Cl), Get3DDkShadowOf(Cl), 1, 0, True)
  else  
    scFrame3D(C, CR, GetBtnHighlightOf(Cl), Get3DDkShadowOf(Cl), 1, 0, True);

  InflateRect(CR, -1, -1);

  with C do
  begin
    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Pen.Width := 1;
    Pen.Color := GetBtnHighlightOf(Cl);

    Rectangle(CR.Left, CR.Top, CR.Right, CR.Bottom);

    Inc(CR.Left);
    Inc(CR.Top);

    Rectangle(CR.Left, CR.Top, CR.Right, CR.Bottom);

    OffsetRect(CR, -1, -1);
    Pen.Color := GetBtnShadowOf(Cl);

    Rectangle(CR.Left, CR.Top, CR.Right, CR.Bottom);
  end;
end;

function scGetParentForm(Control: TControl): TCustomForm;
begin
  Result := nil;
  while (Control <> nil) and (Control.Parent <> nil) do
  begin
    Control := Control.Parent;

    if Control is TCustomForm then
    begin
      Result := TCustomForm(Control);
      Exit;
    end;
  end;  
end;

procedure InitiateCaptionGradientColors;
begin
  {$IFDEF SC_DELPHI5_AND_EARLY}
  if WinOSUsesGradientCaption then
  begin
    clActiveCaptionGradient := TColor(GetSysColor(COLOR_GRADIENTACTIVECAPTION));
    clInactiveCaptionGradient := TColor(GetSysColor(COLOR_GRADIENTINACTIVECAPTION));
  end else
  begin
    clActiveCaptionGradient := TColor(GetSysColor(COLOR_ACTIVECAPTION));
    clInactiveCaptionGradient := TColor(GetSysColor(COLOR_INACTIVECAPTION));
  end;
  {$ENDIF}
end;

procedure scFillTriGradient(ACanvas: TCanvas; ARect: TRect; Color1, Color2,
  Color3: TColor; ColorCount: Integer);
var
  R: TRect;
  I, J, W, H,
  XCount, YCount: Integer;
  XDif, YDif, endRGB,
  ThisRGB, RGB1, RGB2, RGB3: array[0..2] of DWord;
  C1, C2, C3: LongInt;
  ThisColor: TColor;
begin
  if (ACanvas = nil) or IsRectEmpty(ARect) then Exit;

  R := ARect;
  W := R.Right - R.Left;
  H := R.Bottom - R.Top;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
  end;

  if ((W = 1) and (H = 1)) or
    ((Color1 = Color2) and (Color1 = Color3)) then
  begin
    with ACanvas do
    begin
      Brush.Color := Color1;
      FillRect(ARect);
    end;

    Exit;
  end;

  C1 := ColorToRGB(Color1); // <-- left_top color
  C2 := ColorToRGB(Color2); // <-- right_top color
  C3 := ColorToRGB(Color3); // <-- right_bottom color

  RGB1[0] := GetRValue(C1);
  RGB1[1] := GetGValue(C1);
  RGB1[2] := GetBValue(C1);

  RGB2[0] := GetRValue(C2);
  RGB2[1] := GetGValue(C2);
  RGB2[2] := GetBValue(C2);

  RGB3[0] := GetRValue(C3);
  RGB3[1] := GetGValue(C3);
  RGB3[2] := GetBValue(C3);

  XCount := ColorCount;
  if XCount > W - 1 then XCount := W - 1;

  YCount := ColorCount;
  if YCount > H - 1 then YCount := H - 1;

  if XCount > 255 then XCount := 255;
  if YCount > 255 then YCount := 255;

  YDif[0] := RGB2[0] - RGB3[0];
  YDif[1] := RGB2[1] - RGB3[1];
  YDif[2] := RGB2[2] - RGB3[2];

  R.Bottom := ARect.Top;
  for J := 0 to YCount do
  begin
    R.Left  := ARect.Left;
    R.Right := R.Left;

    Inc(R.Bottom, MulDiv(J, H-1, YCount) - MulDiv(J-1, H-1, YCount));
    if R.Bottom = R.Top then Inc(R.Bottom);

    endRGB[0] := RGB2[0] - DWord(Muldiv(J, YDif[0], YCount));
    endRGB[1] := RGB2[1] - DWord(Muldiv(J, YDif[1], YCount));
    endRGB[2] := RGB2[2] - DWord(Muldiv(J, YDif[2], YCount));

    XDif[0] := RGB1[0] - endRGB[0];
    XDif[1] := RGB1[1] - endRGB[1];
    XDif[2] := RGB1[2] - endRGB[2];

    try
      for I := 0 to XCount do
      begin
        Inc(R.Right, MulDiv(I, W-1, XCount) - MulDiv(I-1, W-1, XCount));
        if R.Right = R.Left then Inc(R.Right);

        try
          IntersectRect(R, R, ARect);
          if IsRectEmpty(R) then Continue;

          ThisRGB[0] := RGB1[0] - DWord(Muldiv(I, XDif[0], XCount));
          ThisRGB[1] := RGB1[1] - DWord(Muldiv(I, XDif[1], XCount));
          ThisRGB[2] := RGB1[2] - DWord(Muldiv(I, XDif[2], XCount));

          with ACanvas do
          begin
            ThisColor := TColor(RGB(ThisRGB[0], ThisRGB[1], ThisRGB[2]));

            if (R.Right - R.Left = 1) and (R.Bottom - R.Top = 1) then
              Pixels[R.Left, R.Top] := ThisColor
            else begin
              Brush.Color := ThisColor;
              PatBlt(Handle, R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top, PatCopy);
            end;
          end;
        finally
          R.Left := R.Right;
        end;
      end;
    finally
      R.Top := R.Bottom;
    end;
  end;
end;

procedure scDrawTriGradient(ACanvas: TCanvas; R: TRect; Color1, Color2, Color3: TColor);
var
  Os: Integer;
  verts: array[0..2] of TRIVERTEX;
  GradTri: GRADIENT_TRIANGLE;
  C1, C2, C3: LongInt;
begin
  if (ACanvas = nil) or IsRectEmpty(R) then Exit;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
  end;

  if ((R.Right - R.Left = 1) and (R.Bottom - R.Top = 1)) or
    ((Color1 = Color2) and (Color1 = Color3)) then
  begin
    with ACanvas do
    begin
      Brush.Color := Color1;
      FillRect(R);
    end;

    Exit;
  end;

  Os := scCurrentOperatingSystem;
  if (Os = cOsUnknown) or (Os = cOsWin95) or (Os = cOsWinNT) then
  begin
    scFillTriGradient(ACanvas, R, Color1, Color2, Color3, 255);
    Exit;
  end;

  if GradientLibrary <= 0 then
  begin
    scFillTriGradient(ACanvas, R, Color1, Color2, Color3, 255);
    Exit;
  end;

  @GradientFill := GetProcAddress(GradientLibrary, PChar('GradientFill'));
  if @GradientFill = nil then
  begin
    scFillTriGradient(ACanvas, R, Color1, Color2, Color3, 255);
    Exit;
  end;

  C1 := ColorToRGB(Color1);
  C2 := ColorToRGB(Color2);
  C3 := ColorToRGB(Color3);

  verts[0].x := R.Left;
  verts[0].y := R.Bottom;

  verts[1].x := R.Right;
  verts[1].y := R.Top;

  verts[2].x := R.Right;
  verts[2].y := R.Bottom;

  verts[0].Red   := GetRValue(C1) shl 8;
  verts[0].Green := GetGValue(C1) shl 8;
  verts[0].Blue  := GetBValue(C1) shl 8;

  verts[1].Red   := GetRValue(C2) shl 8;
  verts[1].Green := GetGValue(C2) shl 8;
  verts[1].Blue  := GetBValue(C2) shl 8;

  verts[2].Red   := GetRValue(C3) shl 8;
  verts[2].Green := GetGValue(C3) shl 8;
  verts[2].Blue  := GetBValue(C3) shl 8;

  GradTri.Vertex1 := 0;
  GradTri.Vertex2 := 1;
  GradTri.Vertex3 := 2;

  GradientFill(ACanvas.Handle, LongInt(@verts), 3, LongInt(@GradTri), 1, GRADIENT_FILL_TRIANGLE);

  verts[0].x := R.Left;
  verts[0].y := R.Top;

  verts[1].x := R.Right;
  verts[1].y := R.Top;

  verts[2].x := R.Left;
  verts[2].y := R.Bottom;

  verts[2].Red   := verts[0].Red;
  verts[2].Green := verts[0].Green;
  verts[2].Blue  := verts[0].Blue;

  GradientFill(ACanvas.Handle, LongInt(@verts), 3, LongInt(@GradTri), 1, GRADIENT_FILL_TRIANGLE);
end;

procedure CbFastFillTriGradient(ACanvas: TCanvas; ARect: TRect; Color1, Color2, Color3: TColor);
var
  R : TRect;
  I, J, W, H,
  RectTop, EndColor : Integer;
  C1, C2, C3 : LongInt;
  RGB1, RGB2, RGB3 : array[0..2] of Byte;
  XDif, YDif : array[0..2] of Integer;
begin
  if (ACanvas = nil) or IsRectEmpty(ARect) then Exit;

  R := ARect;
  W := R.Right - R.Left;
  H := R.Bottom - R.Top;

  with ACanvas do
  begin
    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
  end;

  C1 := ColorToRGB(Color1);
  C2 := ColorToRGB(Color2);
  C3 := ColorToRGB(Color3);

  RGB1[0] := GetRValue(C1);
  RGB1[1] := GetGValue(C1);
  RGB1[2] := GetBValue(C1);

  RGB2[0] := GetRValue(C2);
  RGB2[1] := GetGValue(C2);
  RGB2[2] := GetBValue(C2);

  YDif[0] := GetRValue(C3) - RGB2[0];
  YDif[1] := GetGValue(C3) - RGB2[1];
  YDif[2] := GetBValue(C3) - RGB2[2];

  RGB3[0] := RGB1[0];
  RGB3[1] := RGB1[1];
  RGB3[2] := RGB1[2];

  for I := 0 to 64 do
  begin
    EndColor := ColorToRGB(RGB(RGB2[0] + MulDiv(4*I, YDif[0], 255),
                               RGB2[1] + MulDiv(4*I, YDif[1], 255),
                               RGB2[2] + MulDiv(4*I, YDif[2], 255)));

    XDif[0] := GetRValue(EndColor) - RGB3[0];
    XDif[1] := GetGValue(EndColor) - RGB3[1];
    XDif[2] := GetBValue(EndColor) - RGB3[2];

    RectTop := MulDiv(4*I, H, 255);
    for J := 0 to 64 do
    begin
      R := Rect(MulDiv(4*J, W, 255), RectTop, MulDiv(4*(J + 1), W, 255),
                RectTop + MulDiv(5, H, 255));
      
      OffsetRect(R, ARect.Left, ARect.Top);
      IntersectRect(R, R, ARect);

      if IsRectEmpty(R) then Continue;

      with ACanvas do
      begin
        Brush.Color := RGB(RGB3[0] + MulDiv(4*J, XDif[0], 255),
                           RGB3[1] + MulDiv(4*J, XDif[1], 255),
                           RGB3[2] + MulDiv(4*J, XDif[2], 255));
        FillRect(R);
      end;
    end;
  end;
end;

procedure scFillFourGradient(ACanvas: TCanvas; ARect: TRect; LeftTopColor, RightTopColor,
  LeftBottomColor, RightBottomColor: TColor; ColorCount: Integer);
var
  R: TRect;
  I, J, W, H,
  XCount, YCount: Integer;
  XDif, LeftDif, RightDif,
  StartRGB, endRGB, ThisRGB,
  LT_RGB, RT_RGB, LB_RGB, RB_RGB: array[0..2] of DWord;
  LT_C, RT_C, LB_C, RB_C: LongInt;
  ThisColor: TColor;
begin
  if (ACanvas = nil) or IsRectEmpty(ARect) then Exit;

  R := ARect;
  W := R.Right - R.Left;
  H := R.Bottom - R.Top;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
  end;

  if ((W = 1) and (H = 1)) or
    ((LeftTopColor = LeftBottomColor) and
     (LeftTopColor = RightTopColor) and (RightTopColor = RightBottomColor)) then
  begin
    with ACanvas do
    begin
      Brush.Color := LeftTopColor;
      FillRect(ARect);
    end;

    Exit;
  end;

  LT_C := ColorToRGB(LeftTopColor);
  RT_C := ColorToRGB(RightTopColor);
  LB_C := ColorToRGB(LeftBottomColor);
  RB_C := ColorToRGB(RightBottomColor);

  LT_RGB[0] := GetRValue(LT_C);
  LT_RGB[1] := GetGValue(LT_C);
  LT_RGB[2] := GetBValue(LT_C);

  RT_RGB[0] := GetRValue(RT_C);
  RT_RGB[1] := GetGValue(RT_C);
  RT_RGB[2] := GetBValue(RT_C);

  LB_RGB[0] := GetRValue(LB_C);
  LB_RGB[1] := GetGValue(LB_C);
  LB_RGB[2] := GetBValue(LB_C);

  RB_RGB[0] := GetRValue(RB_C);
  RB_RGB[1] := GetGValue(RB_C);
  RB_RGB[2] := GetBValue(RB_C);

  LeftDif[0] := LT_RGB[0] - LB_RGB[0];
  LeftDif[1] := LT_RGB[1] - LB_RGB[1];
  LeftDif[2] := LT_RGB[2] - LB_RGB[2];

  RightDif[0] := RT_RGB[0] - RB_RGB[0];
  RightDif[1] := RT_RGB[1] - RB_RGB[1];
  RightDif[2] := RT_RGB[2] - RB_RGB[2];

  XCount := ColorCount;
  if XCount > W - 1 then XCount := W - 1;

  YCount := ColorCount;
  if YCount > H - 1 then YCount := H - 1;

  if XCount > 255 then XCount := 255;
  if YCount > 255 then YCount := 255;

  R.Bottom := ARect.Top;
  for J := 0 to YCount do
  begin
    R.Left  := ARect.Left;
    R.Right := R.Left;

    Inc(R.Bottom, MulDiv(J, H-1, YCount) - MulDiv(J-1, H-1, YCount));
    if R.Bottom = R.Top then Inc(R.Bottom);

    StartRGB[0] := LT_RGB[0] - DWord(Muldiv(J, LeftDif[0], YCount));
    StartRGB[1] := LT_RGB[1] - DWord(Muldiv(J, LeftDif[1], YCount));
    StartRGB[2] := LT_RGB[2] - DWord(Muldiv(J, LeftDif[2], YCount));

    endRGB[0] := RT_RGB[0] - DWord(Muldiv(J, RightDif[0], YCount));
    endRGB[1] := RT_RGB[1] - DWord(Muldiv(J, RightDif[1], YCount));
    endRGB[2] := RT_RGB[2] - DWord(Muldiv(J, RightDif[2], YCount));

    XDif[0] := StartRGB[0] - endRGB[0];
    XDif[1] := StartRGB[1] - endRGB[1];
    XDif[2] := StartRGB[2] - endRGB[2];

    try
      for I := 0 to XCount do
      begin
        Inc(R.Right, MulDiv(I, W-1, XCount) - MulDiv(I-1, W-1, XCount));
        if R.Right = R.Left then Inc(R.Right);

        try
          IntersectRect(R, R, ARect);
          if IsRectEmpty(R) then Continue;

          ThisRGB[0] := StartRGB[0] - DWord(Muldiv(I, XDif[0], XCount));
          ThisRGB[1] := StartRGB[1] - DWord(Muldiv(I, XDif[1], XCount));
          ThisRGB[2] := StartRGB[2] - DWord(Muldiv(I, XDif[2], XCount));

          with ACanvas do
          begin
            ThisColor := TColor(RGB(ThisRGB[0], ThisRGB[1], ThisRGB[2]));

            if (R.Right - R.Left = 1) and (R.Bottom - R.Top = 1) then
              Pixels[R.Left, R.Top] := ThisColor
            else begin
              Brush.Color := ThisColor;
              PatBlt(Handle, R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top, PatCopy);
            end;
          end;
        finally
          R.Left := R.Right;
        end;
      end;
    finally
      R.Top := R.Bottom;
    end;
  end;
end;

procedure scDrawFourGradient(ACanvas: TCanvas; R: TRect; LeftTopColor, RightTopColor,
  LeftBottomColor, RightBottomColor: TColor);
var
  Os: Integer;
  verts: array[0..4] of TRIVERTEX;
  GradTri:array[0..1] of GRADIENT_TRIANGLE;
  LT_C, RT_C, LB_C, RB_C: LongInt;
begin
  if (ACanvas = nil) or IsRectEmpty(R) then Exit;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
  end;

  if ((R.Right - R.Left = 1) and (R.Bottom - R.Top = 1)) or
     ((LeftTopColor = LeftBottomColor) and
      (LeftTopColor = RightTopColor) and (RightTopColor = RightBottomColor)) then
  begin
    with ACanvas do
    begin
      Brush.Color := LeftTopColor;
      FillRect(R);
    end;

    Exit;
  end;

  Os := scCurrentOperatingSystem;
  if (Os = cOsUnknown) or (Os = cOsWin95) or (Os = cOsWinNT) then
  begin
    scFillFourGradient(ACanvas, R, LeftTopColor, RightTopColor,
      LeftBottomColor, RightBottomColor, 255);
    Exit;
  end;

  if GradientLibrary <= 0 then
  begin
    scFillFourGradient(ACanvas, R, LeftTopColor, RightTopColor,
      LeftBottomColor, RightBottomColor, 255);
    Exit;
  end;

  @GradientFill := GetProcAddress(GradientLibrary, PChar('GradientFill'));
  if @GradientFill = nil then
  begin
    scFillFourGradient(ACanvas, R, LeftTopColor, RightTopColor,
      LeftBottomColor, RightBottomColor, 255);
    Exit;
  end;

  LT_C := ColorToRGB(LeftTopColor);
  RT_C := ColorToRGB(RightTopColor);
  LB_C := ColorToRGB(LeftBottomColor);
  RB_C := ColorToRGB(RightBottomColor);

  verts[0].x     := R.Left;
  verts[0].y     := R.Top;
  verts[0].Red   := GetRValue(LT_C) shl 8;
  verts[0].Green := GetGValue(LT_C) shl 8;
  verts[0].Blue  := GetBValue(LT_C) shl 8;
  verts[0].Alpha := $0000;

  verts[1].x     := R.Right;
  verts[1].y     := R.Top;
  verts[1].Red   := GetRValue(RT_C) shl 8;
  verts[1].Green := GetGValue(RT_C) shl 8;
  verts[1].Blue  := GetBValue(RT_C) shl 8;
  verts[1].Alpha := $0000;

  verts[2].x     := R.Right;
  verts[2].y     := R.Bottom;
  verts[2].Red   := GetRValue(RB_C) shl 8;
  verts[2].Green := GetGValue(RB_C) shl 8;
  verts[2].Blue  := GetBValue(RB_C) shl 8;
  verts[2].Alpha := $0000;

  verts[3].x     := R.Left;
  verts[3].y     := R.Bottom;
  verts[3].Red   := GetRValue(LB_C) shl 8;
  verts[3].Green := GetGValue(LB_C) shl 8;
  verts[3].Blue  := GetBValue(LB_C) shl 8;
  verts[3].Alpha := $0000;

  GradTri[0].Vertex1 := 0;
  GradTri[0].Vertex2 := 1;
  GradTri[0].Vertex3 := 3;

  GradTri[1].Vertex1 := 1;
  GradTri[1].Vertex2 := 2;
  GradTri[1].Vertex3 := 3;

  GradientFill(ACanvas.Handle, LongInt(@verts), 4, LongInt(@GradTri), 2, GRADIENT_FILL_TRIANGLE);
end;

procedure scFillVerticalRainbow(ACanvas: TCanvas; ARect: TRect; Reverse: Boolean);
var
  I, SecCount, H: Integer;
  StColor, EndColor: TColor;
  R: TRect;
begin
  SecCount := Length(scRainbowColors) - 1;
  if (SecCount <= 1) or (ACanvas = nil) or IsRectEmpty(ARect) then Exit;

  R := ARect;

  H := ARect.Bottom - ARect.Top;

  R.Bottom := R.Top;

  for I := 1 to SecCount do
  begin
    R.Top  := ARect.Top + Muldiv(I-1, H, SecCount);
    R.Bottom := ARect.Top + Muldiv(I, H, SecCount);

    if Reverse then
    begin
      StColor  := scRainbowColors[High(scRainbowColors) - (I - 1)];
      EndColor := scRainbowColors[High(scRainbowColors) - I];
    end else
    begin
      StColor  := scRainbowColors[Low(scRainbowColors) + I - 1];
      EndColor := scRainbowColors[Low(scRainbowColors) + I];
    end;

    scFillGradientRectVertical(ACanvas, R, StColor, EndColor, 255, False);
  end;
end;

procedure scFillHorizontalRainbow(ACanvas: TCanvas; ARect: TRect; Reverse: Boolean);
var
  I, SecCount, W: Integer;
  StColor, EndColor: TColor;
  R: TRect;
begin
  SecCount := Length(scRainbowColors) - 1;
  if (SecCount <= 1) or (ACanvas = nil) or IsRectEmpty(ARect) then Exit;

  R := ARect;
  R.Right := R.Left;

  W := ARect.Right - ARect.Left;

  for I := 1 to SecCount do
  begin
    R.Left  := ARect.Left + Muldiv(I-1, W, SecCount);
    R.Right := ARect.Left + Muldiv(I, W, SecCount);

    if Reverse then
    begin
      StColor  := scRainbowColors[High(scRainbowColors) - (I - 1)];
      EndColor := scRainbowColors[High(scRainbowColors) - I];
    end else
    begin
      StColor  := scRainbowColors[Low(scRainbowColors) + I - 1];
      EndColor := scRainbowColors[Low(scRainbowColors) + I];
    end;

    scFillGradientRectHorizontal(ACanvas, R, StColor, EndColor, 255, False);
  end;
end;

procedure scFillVerticalExRainbow(ACanvas: TCanvas; ARect: TRect; ExColor: TColor;
  VertReverse, HorzReverse: Boolean);
var
  I, SecCount, H: Integer;
  StColor, EndColor: TColor;
  R: TRect;
begin
  SecCount := Length(scRainbowColors) - 1;
  if (SecCount <= 1) or (ACanvas = nil) or IsRectEmpty(ARect) then Exit;

  R := ARect;

  H := ARect.Bottom - ARect.Top;

  R.Bottom := R.Top;

  for I := 1 to SecCount do
  begin
    R.Top  := ARect.Top + Muldiv(I-1, H, SecCount);
    R.Bottom := ARect.Top + Muldiv(I, H, SecCount);

    if VertReverse then
    begin
      StColor  := scRainbowColors[High(scRainbowColors) - (I - 1)];
      EndColor := scRainbowColors[High(scRainbowColors) - I];
    end else
    begin
      StColor  := scRainbowColors[Low(scRainbowColors) + I - 1];
      EndColor := scRainbowColors[Low(scRainbowColors) + I];
    end;

    if HorzReverse then
      scFillFourGradient(ACanvas, R, ExColor, ExColor, StColor, EndColor, 255)
    else
      scFillFourGradient(ACanvas, R, StColor, EndColor, ExColor, ExColor, 255);
  end;
end;

procedure scFillHorizontalExRainbow(ACanvas: TCanvas; ARect: TRect; ExColor: TColor;
  VertReverse, HorzReverse: Boolean);
var
  I, SecCount, W: Integer;
  StColor, EndColor: TColor;
  R: TRect;
begin
  SecCount := Length(scRainbowColors) - 1;
  if (SecCount <= 1) or (ACanvas = nil) or IsRectEmpty(ARect) then Exit;

  R := ARect;
  R.Right := R.Left;

  W := ARect.Right - ARect.Left;

  for I := 1 to SecCount do
  begin
    R.Left  := ARect.Left + Muldiv(I-1, W, SecCount);
    R.Right := ARect.Left + Muldiv(I, W, SecCount);

    if HorzReverse then
    begin
      StColor  := scRainbowColors[High(scRainbowColors) - (I - 1)];
      EndColor := scRainbowColors[High(scRainbowColors) - I];
    end else
    begin
      StColor  := scRainbowColors[Low(scRainbowColors) + I - 1];
      EndColor := scRainbowColors[Low(scRainbowColors) + I];
    end;

    if VertReverse then
      scFillFourGradient(ACanvas, R, ExColor, ExColor, StColor, EndColor, 255)
    else
      scFillFourGradient(ACanvas, R, StColor, EndColor, ExColor, ExColor, 255);
  end;
end;

function scVerticalGradientColorOf(P: TPoint; R: TRect; StartColor, EndColor: TColor;
  ColorCount: Integer; Reverse: Boolean): TColor;
var
  J, Y, H: Integer;
  YDif, RGB1, RGB2: array[0..2] of DWord;
  C1, C2, Tmp: LongInt;
begin
  Result := StartColor;

  H := R.Bottom - R.Top;
  if (H <= 1) or (StartColor = EndColor) or not PtInRect(R, P) then Exit;

  C1 := ColorToRGB(StartColor);
  C2 := ColorToRGB(EndColor);

  if Reverse then
  begin
    Tmp := C1;
    C1  := C2;
    C2  := Tmp;
  end;

  RGB1[0] := GetRValue(C1);
  RGB1[1] := GetGValue(C1);
  RGB1[2] := GetBValue(C1);

  RGB2[0] := GetRValue(C2);
  RGB2[1] := GetGValue(C2);
  RGB2[2] := GetBValue(C2);

  if ColorCount > H - 1 then
    ColorCount := H - 1;

  if ColorCount > 255 then ColorCount := 255;

  YDif[0] := RGB1[0] - RGB2[0];
  YDif[1] := RGB1[1] - RGB2[1];
  YDif[2] := RGB1[2] - RGB2[2];

  Y := P.Y - R.Top;
  J := Muldiv(Y, ColorCount, H);

  RGB2[0] := RGB1[0] - DWord(Muldiv(J, YDif[0], ColorCount));
  RGB2[1] := RGB1[1] - DWord(Muldiv(J, YDif[1], ColorCount));
  RGB2[2] := RGB1[2] - DWord(Muldiv(J, YDif[2], ColorCount));

  Result := TColor(RGB(RGB2[0], RGB2[1], RGB2[2]));
end;

function scHorizontalGradientColorOf(P: TPoint; R: TRect; StartColor, EndColor: TColor;
  ColorCount: Integer; Reverse: Boolean): TColor;
var
  I, X, W: Integer;
  XDif, RGB1, RGB2: array[0..2] of DWord;
  C1, C2, Tmp: LongInt;
begin
  Result := StartColor;
  if Reverse then Result := EndColor;

  W := R.Right - R.Left;
  if (W <= 1) or (StartColor = EndColor) or (P.Y < R.Top) then Exit;

  if P.Y > R.Bottom then
  begin
    Result := EndColor;
    if Reverse then Result := StartColor;

    Exit;
  end;

  C1 := ColorToRGB(StartColor);
  C2 := ColorToRGB(EndColor);

  if Reverse then
  begin
    Tmp := C1;
    C1  := C2;
    C2  := Tmp;
  end;

  RGB1[0] := GetRValue(C1);
  RGB1[1] := GetGValue(C1);
  RGB1[2] := GetBValue(C1);

  RGB2[0] := GetRValue(C2);
  RGB2[1] := GetGValue(C2);
  RGB2[2] := GetBValue(C2);

  if ColorCount > W - 1 then
    ColorCount := W - 1;

  if ColorCount > 255 then ColorCount := 255;

  XDif[0] := RGB1[0] - RGB2[0];
  XDif[1] := RGB1[1] - RGB2[1];
  XDif[2] := RGB1[2] - RGB2[2];

  X := P.x - R.Left;
  I := Muldiv(X, ColorCount, W);

  RGB2[0] := RGB1[0] - DWord(Muldiv(I, XDif[0], ColorCount));
  RGB2[1] := RGB1[1] - DWord(Muldiv(I, XDif[1], ColorCount));
  RGB2[2] := RGB1[2] - DWord(Muldiv(I, XDif[2], ColorCount));

  Result := TColor(RGB(RGB2[0], RGB2[1], RGB2[2]));
end;

function scGradientFourColorOf(P: TPoint; R: TRect; LeftTopColor, RightTopColor,
  LeftBottomColor, RightBottomColor: TColor; ColorCount: Integer): TColor;
var
  I, J, W, H,
  X, Y, XCount, YCount: Integer;
  XDif, LeftDif, RightDif,
  StartRGB, endRGB, ThisRGB,
  LT_RGB, RT_RGB, LB_RGB, RB_RGB: array[0..2] of DWord;
  LT_C, RT_C, LB_C, RB_C: LongInt;
begin
  Result := LeftTopColor;

  W := R.Right - R.Left;
  H := R.Bottom - R.Top;
  if (W <= 0) or (H <= 0) or ((W = 1) and (H = 1)) or
    ((LeftTopColor = RightTopColor) and (LeftBottomColor = RightBottomColor) and
     (LeftTopColor = LeftBottomColor)) or not PtInRect(R, P) then Exit;

  LT_C := ColorToRGB(LeftTopColor);
  RT_C := ColorToRGB(RightTopColor);
  LB_C := ColorToRGB(LeftBottomColor);
  RB_C := ColorToRGB(RightBottomColor);

  LT_RGB[0] := GetRValue(LT_C);
  LT_RGB[1] := GetGValue(LT_C);
  LT_RGB[2] := GetBValue(LT_C);

  RT_RGB[0] := GetRValue(RT_C);
  RT_RGB[1] := GetGValue(RT_C);
  RT_RGB[2] := GetBValue(RT_C);

  LB_RGB[0] := GetRValue(LB_C);
  LB_RGB[1] := GetGValue(LB_C);
  LB_RGB[2] := GetBValue(LB_C);

  RB_RGB[0] := GetRValue(RB_C);
  RB_RGB[1] := GetGValue(RB_C);
  RB_RGB[2] := GetBValue(RB_C);

  LeftDif[0] := LT_RGB[0] - LB_RGB[0];
  LeftDif[1] := LT_RGB[1] - LB_RGB[1];
  LeftDif[2] := LT_RGB[2] - LB_RGB[2];

  RightDif[0] := RT_RGB[0] - RB_RGB[0];
  RightDif[1] := RT_RGB[1] - RB_RGB[1];
  RightDif[2] := RT_RGB[2] - RB_RGB[2];

  XCount := ColorCount;
  if XCount > W - 1 then XCount := W - 1;

  YCount := ColorCount;
  if YCount > H - 1 then YCount := H - 1;

  if XCount > 255 then XCount := 255;
  if YCount > 255 then YCount := 255;

  X := P.X - R.Left;
  I := Muldiv(X, XCount, W);

  Y := P.Y - R.Top;
  J := Muldiv(Y, YCount, H);

  StartRGB[0] := LT_RGB[0] - DWord(Muldiv(J, LeftDif[0], YCount));
  StartRGB[1] := LT_RGB[1] - DWord(Muldiv(J, LeftDif[1], YCount));
  StartRGB[2] := LT_RGB[2] - DWord(Muldiv(J, LeftDif[2], YCount));

  endRGB[0] := RT_RGB[0] - DWord(Muldiv(J, RightDif[0], YCount));
  endRGB[1] := RT_RGB[1] - DWord(Muldiv(J, RightDif[1], YCount));
  endRGB[2] := RT_RGB[2] - DWord(Muldiv(J, RightDif[2], YCount));

  XDif[0] := StartRGB[0] - endRGB[0];
  XDif[1] := StartRGB[1] - endRGB[1];
  XDif[2] := StartRGB[2] - endRGB[2];

  ThisRGB[0] := StartRGB[0] - DWord(Muldiv(I, XDif[0], XCount));
  ThisRGB[1] := StartRGB[1] - DWord(Muldiv(I, XDif[1], XCount));
  ThisRGB[2] := StartRGB[2] - DWord(Muldiv(I, XDif[2], XCount));

  Result := TColor(RGB(ThisRGB[0], ThisRGB[1], ThisRGB[2]));
end;

procedure scDrawFocusRect(C: TCanvas; R: TRect; LineColor: TColor);
var
  B: Boolean;
  I, X, Y: Integer;
begin
  Dec(R.Right); Dec(R.Bottom);
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  with C do
  begin
    Pen.Color := LineColor;
    Pen.Width := 1;
    Pen.Style := psSolid;
    Pen.Mode  := pmNotMerge;

    X := R.Left;
    Y := R.Top;

    OffsetRect(R, -R.Left, -R.Top);

    B := True;
    for I := 0 to R.Right-1 do
    begin
      if B then
      begin
        MoveTo(I + X, Y);
        LineTo(I + X, Y + 1);
      end;

      B := not B;
    end;

    for I := 0 to R.Bottom-1 do
    begin
      if B then
      begin
        MoveTo(X + R.Right, Y + I);
        LineTo(X + R.Right - 1, Y + I + 1);
      end;

      B := not B;
    end;

    for I := R.Right downto 1 do
    begin
      if B then
      begin
        MoveTo(I + X, Y + R.Bottom);
        LineTo(I + X, Y + R.Bottom - 1);
      end;

      B := not B;
    end;

    for I := R.Bottom downto 1 do
    begin
      if B then
      begin
        MoveTo(X,     Y + I);
        LineTo(X + 1, Y + I);
      end;

      B := not B;
    end;

    Pen.Mode := pmCopy;
  end;
end;

procedure scFrame3D(C: TCanvas; var ARect: TRect; TopColor, BottomColor: TColor;
  LineWidth, Rounded: Integer; UseNoneColor: Boolean);
var
  R: TRect;
  RD: Integer;
  TopPoints, BtmPoints: array of TPoint;
  PenStyle: TPenStyle;
  PenWidth: Integer;
  PenColor: TColor;
  PenMode: TPenMode;
begin
  if (C = nil) or IsRectEmpty(ARect) then
    Exit;

  R := ARect;
  InflateRect(ARect, -1, -1);

  Dec(R.Bottom);
  Dec(R.Right);

  if R.Right < R.Left then R.Right := R.Left;
  if R.Bottom < R.Top then R.Bottom := R.Top;

  with C do
  begin
    PenColor := Pen.Color;
    PenStyle := Pen.Style;
    PenMode  := Pen.Mode;
    PenWidth := Pen.Width;

    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
    
    try
      if IsRectEmpty(R) then
      begin
        Pen.Width := 1;
        Pen.Color := BottomColor;
        PolyLine([Point(R.Left, R.Top), Point(R.Right, R.Bottom)]);
        Exit;
      end;

      RD := Rounded div 2;
      if RD > 0 then
      begin
        if RD > R.Bottom - R.Top then
          RD := R.Bottom - R.Top;
        if RD > R.Right - R.Left then
          RD := R.Right - R.Left;
      end;

      SetLength(TopPoints, 5);

      TopPoints[0].x := R.Left + RD;
      TopPoints[0].y := R.Bottom;
      TopPoints[1].x := R.Left;
      TopPoints[1].y := R.Bottom - RD;
      TopPoints[2].x := R.Left;
      TopPoints[2].y := R.Top + RD;
      TopPoints[3].x := R.Left + RD;
      TopPoints[3].y := R.Top;
      TopPoints[4].x := R.Right - RD;
      TopPoints[4].y := R.Top;

      SetLength(BtmPoints, 5);

      BtmPoints[0].x := R.Right - RD;
      BtmPoints[0].y := R.Top;
      BtmPoints[1].x := R.Right;
      BtmPoints[1].y := R.Top + RD;
      BtmPoints[2].x := R.Right;
      BtmPoints[2].y := R.Bottom - RD;
      BtmPoints[3].x := R.Right - RD;
      BtmPoints[3].y := R.Bottom;
      BtmPoints[4].x := R.Left + RD - 1;
      BtmPoints[4].y := R.Bottom;

      Pen.Width := LineWidth;
      PenStyle  := psInsideFrame;

      if (TopColor <> clNone) or UseNoneColor then
      begin
        Pen.Color := TopColor;
        PolyLine(TopPoints);
      end;

      if (BottomColor <> clNone) or UseNoneColor then
      begin
        Pen.Color := BottomColor;
        PolyLine(BtmPoints);
      end;  
    finally
      Pen.Color := PenColor;
      Pen.Style := PenStyle;
      Pen.Width := PenWidth;
      Pen.Mode  := PenMode;
    end;
  end;
end;

procedure scRoundRect(C: TCanvas; var ARect: TRect; TopColor, BottomColor: TColor;
  LineWidth: Integer);
var
  I: Integer;
  OldPenColor: TColor;
  Sx, Sy, Ex, Ey: Integer;
begin
  if (C = nil) or IsRectEmpty(ARect) then
    Exit;

  with C do
  begin
    OldPenColor := Pen.Color;

    Sx := ARect.Left;
    Sy := ARect.Bottom;
    Ex := ARect.Right;
    Ey := ARect.Top;

    for I := 0 to LineWidth-1 do
    begin
      Pen.Color := BottomColor;
      Arc(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom,
        Sx, Sy, Ex, Ey);

      Pen.Color := TopColor;
      Arc(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom,
        Ex, Ey, Sx, Sy);

      InflateRect(ARect, -1, -1);
    end;
    Pen.Color := OldPenColor;
  end;
end;

procedure scFillCorners(C: TCanvas; ARect: TRect; AColor: TColor; Rounded: Integer);
var
  h, rh: HRGN;
  OldBrushColor: TColor;
begin
  if (C = nil) or IsRectEmpty(ARect) then
    Exit;

  with C do
  begin
    OldBrushColor := Brush.Color;
    Brush.Color := AColor;

    h := 0;
    rh := 0;
    try
      h := CreateRectRgn(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
      rh := CreateRoundRectRgn(ARect.Left, ARect.Top, ARect.Right+1,
        ARect.Bottom + 1, Rounded, Rounded);

      CombineRgn(h, h, rh, RGN_DifF);
      PaintRgn(Handle, h);
    finally
      if h <> 0 then DeleteObject(h);
      if rh <> 0 then DeleteObject(rh);
    end;

    Brush.Color := OldBrushColor;
  end;
end;

procedure scFillWithColors(C: TCanvas; R: TRect; AColor, WithColor: TColor);
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  with C do
  begin
    if AColor = WithColor then
      Brush.Color := AColor
    else
      Brush.Bitmap := AllocPatternBitmap(AColor, WithColor);
      
    FillRect(R);
    Brush.Bitmap := nil;
  end;
end;

procedure scDrawBevelEx(DC: HDC; R: TRect; C, ParentColor: TColor;
  FillCorner: Boolean; B: TSCBorder; Edges: TSCBorderEdges);

  procedure Draw3DFrame(R: TRect; TCl, BCl: TColor; P: TPen);
  begin
    if R.Right > R.Left then Dec(R.Right);
    if R.Bottom > R.Top then Dec(R.Bottom);

    P.Color := TCl;
    SelectObject(DC, P.Handle);

    if scbeTop in Edges then
    begin
      Windows.MoveToEx(DC, R.Right, R.Top, nil);
      Windows.LineTo(DC, R.Left, R.Top);
    end;  

    if scbeLeft in Edges then
    begin
      Windows.MoveToEx(DC, R.Left, R.Top, nil);
      Windows.LineTo(DC, R.Left, R.Bottom);
    end;

    P.Color := BCl;
    SelectObject(DC, P.Handle);

    if scbeBottom in Edges then
    begin
      Windows.MoveToEx(DC, R.Left, R.Bottom, nil);
      Windows.LineTo(DC, R.Right, R.Bottom);
    end;

    if scbeRight in Edges then
    begin
      Windows.MoveToEx(DC, R.Right, R.Bottom, nil);
      Windows.LineTo(DC, R.Right, R.Top);
    end;  
  end;

  procedure DrawFrameRounded(R: TRect; Cl: TColor; P: TPen; AFillCorner: Boolean;
    RoundBy: Word = 2);
  var
    BR: TRect;
  begin
    BR := R;
    if R.Right > R.Left then Dec(R.Right);
    if R.Bottom > R.Top then Dec(R.Bottom);

    if (BR.Right < BR.Left + 2*RoundBy) or (BR.Bottom < BR.Top + 2*RoundBy) then
    begin
      Draw3DFrame(BR, Cl, Cl, P);
      Exit;
    end;

    P.Color := Cl;
    SelectObject(DC, P.Handle);

    if scbeTop in Edges then
    begin
      if scbeRight in Edges then
        Windows.MoveToEx(DC, R.Right - RoundBy, R.Top, nil)
      else
        Windows.MoveToEx(DC, R.Right, R.Top, nil);

      if scbeLeft in Edges then
      begin
        Windows.LineTo(DC, R.Left + RoundBy, R.Top);
        Windows.LineTo(DC, R.Left, R.Top + RoundBy);
      end else
        Windows.LineTo(DC, R.Left - 1, R.Top);
    end;

    if scbeLeft in Edges then
    begin
      if scbeTop in Edges then
        Windows.MoveToEx(DC, R.Left, R.Top + RoundBy, nil)
      else
        Windows.MoveToEx(DC, R.Left, R.Top, nil);

      if scbeBottom in Edges then
      begin
        Windows.LineTo(DC, R.Left, R.Bottom - RoundBy);
        Windows.LineTo(DC, R.Left + RoundBy, R.Bottom);
      end else
        Windows.LineTo(DC, R.Left, R.Bottom + 1);
    end;

    if scbeBottom in Edges then
    begin
      if scbeLeft in Edges then
        Windows.MoveToEx(DC, R.Left + RoundBy, R.Bottom, nil)
      else  
        Windows.MoveToEx(DC, R.Left, R.Bottom, nil);

      if scbeRight in Edges then
      begin
        Windows.LineTo(DC, R.Right - RoundBy, R.Bottom);
        Windows.LineTo(DC, R.Right, R.Bottom - RoundBy);
      end else
        Windows.LineTo(DC, R.Right + 1, R.Bottom);
    end;

    if scbeRight in Edges then
    begin
      if scbeBottom in Edges then
        Windows.MoveToEx(DC, R.Right, R.Bottom - RoundBy, nil)
      else
        Windows.MoveToEx(DC, R.Right, R.Bottom, nil);

      if scbeTop in Edges then
      begin
        Windows.LineTo(DC, R.Right, R.Top + RoundBy);
        Windows.LineTo(DC, R.Right - RoundBy, R.Top);
      end else
        Windows.LineTo(DC, R.Right, R.Top - 1);
    end;

    if AFillCorner and (RoundBy = 2) and (Edges <> []) and (ParentColor <> clNone) then
    begin
      P.Color := ParentColor;
      SelectObject(DC, P.Handle);

      if (scbeTop in Edges) and (scbeLeft in Edges) then
      begin
        Windows.MoveToEx(DC, R.Left + 1, R.Top, nil);

        Windows.LineTo(DC, R.Left, R.Top);
        Windows.LineTo(DC, R.Left, R.Top + 1);
        Windows.LineTo(DC, R.Left + 1, R.Top);
      end;

      if (scbeLeft in Edges) and (scbeBottom in Edges) then
      begin
        Windows.MoveToEx(DC, R.Left, R.Bottom - 1, nil);

        Windows.LineTo(DC, R.Left, R.Bottom);
        Windows.LineTo(DC, R.Left + 1, R.Bottom);
        Windows.LineTo(DC, R.Left, R.Bottom - 1);
      end;

      if (scbeBottom in Edges) and (scbeRight in Edges) then
      begin
        Windows.MoveToEx(DC, R.Right - 1, R.Bottom, nil);

        Windows.LineTo(DC, R.Right, R.Bottom);
        Windows.LineTo(DC, R.Right, R.Bottom - 1);
        Windows.LineTo(DC, R.Right - 1, R.Bottom);
      end;

      if (scbeRight in Edges) and (scbeTop in Edges) then
      begin
        Windows.MoveToEx(DC, R.Right, R.Top + 1, nil);

        Windows.LineTo(DC, R.Right, R.Top);
        Windows.LineTo(DC, R.Right - 1, R.Top);
        Windows.LineTo(DC, R.Right, R.Top + 1);
      end;
    end;
  end;
  
var
  TopC, BtmC: TColor;
  P: TPen;
  OldPen: HPen;
begin
  if (DC = 0) or (B = sccbNone) or IsRectEmpty(R) or (Edges = []) then
    Exit;

  OldPen := 0;
  P := TPen.Create;
  try
    P.Width := 1;
    P.Style := psSolid;

    SetROP2(DC, R2_COPYPEN);
    OldPen := SelectObject(DC, P.Handle);

    case B of
      sccbRaised:
      begin
        TopC := GetBtnHighlightOf(C);
        BtmC := GetBtnShadowOf(C);

        Draw3DFrame(R, TopC, BtmC, P);
      end;
      sccbLowered:
      begin
        TopC := GetBtnShadowOf(C);
        BtmC := GetBtnHighlightOf(C);

        Draw3DFrame(R, TopC, BtmC, P);
      end;
      sccb3DRaised:
      begin
        TopC := GetBtnHighlightOf(C);
        BtmC := Get3DDkShadowOf(C);

        Draw3DFrame(R, TopC, BtmC, P);
        InflateRect(R, -1, -1);

        TopC := GetBtnFaceOf(C);
        BtmC := GetBtnShadowOf(C);

        Draw3DFrame(R, TopC, BtmC, P);
      end;
      sccb3DLowered:
      begin
        TopC := GetBtnShadowOf(C);
        BtmC := GetBtnHighlightOf(C);

        Draw3DFrame(R, TopC, BtmC, P);
        InflateRect(R, -1, -1);

        TopC := Get3DDkShadowOf(C);
        BtmC := GetBtnFaceOf(C);

        Draw3DFrame(R, TopC, BtmC, P);
      end;
      sccbBumped:
      begin
        TopC := GetBtnHighlightOf(C);
        BtmC := GetBtnShadowOf(C);

        Draw3DFrame(R, TopC, BtmC, P);
        InflateRect(R, -1, -1);

        TopC := GetBtnShadowOf(C);
        BtmC := GetBtnHighlightOf(C);

        Draw3DFrame(R, TopC, BtmC, P);
      end;
      sccbEtched:
      begin
        TopC := GetBtnShadowOf(C);
        BtmC := GetBtnHighlightOf(C);

        Dec(R.Right); Dec(R.Bottom);
        OffsetRect(R, 1, 1);

        Draw3DFrame(R, BtmC, BtmC, P);
        OffsetRect(R, -1, -1);

        Draw3DFrame(R, TopC, TopC, P);
      end;
      sccbFlat:
      begin
        Draw3DFrame(R, C, C, P);
      end;
      sccbFlatBold:
      begin
        Draw3DFrame(R, C, C, P);

        InflateRect(R, -1, -1);
        Draw3DFrame(R, C, C, P);
      end;
      sccbFlatRounded:
      begin
        DrawFrameRounded(R, C, P, FillCorner, 2);
      end;
      sccbFlatBoldRounded:
      begin
        DrawFrameRounded(R, C, P, FillCorner, 2);
        InflateRect(R, -1, -1);

        DrawFrameRounded(R, C, P, False, 1);
        DrawFrameRounded(R, C, P, False, 2);
      end;
      sccbColor:
      begin
        Draw3DFrame(R, C, C, P);
      end;
      sccbMacLowered:
      begin
        TopC := GetBtnShadowOf(C);
        BtmC := GetBtnHighlightOf(C);

        Draw3DFrame(R, TopC, BtmC, P);
        InflateRect(R, -1, -1);

        TopC := BlendedColor(C, 212, 212, 212, False);

        Draw3DFrame(R, TopC, TopC, P);
      end;
      sccbMacRaised:
      begin
        TopC := BlendedColor(C, 212, 212, 212, False);
        Draw3DFrame(R, TopC, TopC, P);
        InflateRect(R, -1, -1);

        TopC := GetBtnHighlightOf(C);
        BtmC := GetBtnShadowOf(C);

        Draw3DFrame(R, TopC, BtmC, P);
      end;
      sccbMetal:
      begin
        TopC := GetBtnShadowOf(C);
        BtmC := GetBtnHighlightOf(C);

        Draw3DFrame(R, TopC, BtmC, P);
        InflateRect(R, -1, -1);

        TopC := GetBtnFaceOf(C);
        Draw3DFrame(R, TopC, TopC, P);
      end;
      sccbSoftLowered:
      begin
        TopC := GetBtnShadowOf(C);
        BtmC := GetBtnHighlightOf(C);

        Draw3DFrame(R, C, BtmC, P);
        InflateRect(R, -1, -1);
        Draw3DFrame(R, TopC, TopC, P);
      end;
      sccbSoftRaised:
      begin
        TopC := GetBtnShadowOf(C);
        BtmC := GetBtnHighlightOf(C);

        Draw3DFrame(R, TopC, TopC, P);
        InflateRect(R, -1, -1);
        Draw3DFrame(R, BtmC, C, P);
      end;
    end;
  finally
    if OldPen <> 0 then SelectObject(DC, OldPen);
    P.Free;
  end;
end;

procedure scDrawEdgeEx(DC: HDC; R: TRect; C, ParentColor: TColor;
  FillCorner: Boolean; B: TSCBorder; Edges: TSCBorderEdges);

  procedure Draw3DFrame(R: TRect; TCl, BCl: TColor; P: TPen);
  begin
    if R.Right > R.Left then Dec(R.Right);
    if R.Bottom > R.Top then Dec(R.Bottom);

    P.Color := TCl;
    SelectObject(DC, P.Handle);

    if scbeTop in Edges then
    begin
      Windows.MoveToEx(DC, R.Right, R.Top, nil);
      Windows.LineTo(DC, R.Left, R.Top);
    end;

    if scbeLeft in Edges then
    begin
      Windows.MoveToEx(DC, R.Left, R.Top, nil);
      Windows.LineTo(DC, R.Left, R.Bottom);
    end;

    P.Color := BCl;
    SelectObject(DC, P.Handle);

    if scbeBottom in Edges then
    begin
      Windows.MoveToEx(DC, R.Left, R.Bottom, nil);
      Windows.LineTo(DC, R.Right, R.Bottom);
    end;

    if scbeRight in Edges then
    begin
      Windows.MoveToEx(DC, R.Right, R.Bottom, nil);
      Windows.LineTo(DC, R.Right, R.Top);
    end;  
  end;

  procedure DrawFrameRounded(R: TRect; Cl: TColor; P: TPen; AFillCorner: Boolean;
    RoundBy: Word = 2);
  var
    BR: TRect;
  begin
    BR := R;
    if R.Right > R.Left then Dec(R.Right);
    if R.Bottom > R.Top then Dec(R.Bottom);

    if (BR.Right < BR.Left + 2*RoundBy) or (BR.Bottom < BR.Top + 2*RoundBy) then
    begin
      Draw3DFrame(BR, Cl, Cl, P);
      Exit;
    end;

    P.Color := Cl;
    SelectObject(DC, P.Handle);

    if scbeTop in Edges then
    begin
      if scbeRight in Edges then
        Windows.MoveToEx(DC, R.Right - RoundBy, R.Top, nil)
      else
        Windows.MoveToEx(DC, R.Right, R.Top, nil);

      if scbeLeft in Edges then
      begin
        Windows.LineTo(DC, R.Left + RoundBy, R.Top);
        Windows.LineTo(DC, R.Left, R.Top + RoundBy);
      end else
        Windows.LineTo(DC, R.Left - 1, R.Top);
    end;

    if scbeLeft in Edges then
    begin
      if scbeTop in Edges then
        Windows.MoveToEx(DC, R.Left, R.Top + RoundBy, nil)
      else
        Windows.MoveToEx(DC, R.Left, R.Top, nil);

      if scbeBottom in Edges then
      begin
        Windows.LineTo(DC, R.Left, R.Bottom - RoundBy);
        Windows.LineTo(DC, R.Left + RoundBy, R.Bottom);
      end else
        Windows.LineTo(DC, R.Left, R.Bottom + 1);
    end;

    if scbeBottom in Edges then
    begin
      if scbeLeft in Edges then
        Windows.MoveToEx(DC, R.Left + RoundBy, R.Bottom, nil)
      else  
        Windows.MoveToEx(DC, R.Left, R.Bottom, nil);

      if scbeRight in Edges then
      begin
        Windows.LineTo(DC, R.Right - RoundBy, R.Bottom);
        Windows.LineTo(DC, R.Right, R.Bottom - RoundBy);
      end else
        Windows.LineTo(DC, R.Right + 1, R.Bottom);
    end;

    if scbeRight in Edges then
    begin
      if scbeBottom in Edges then
        Windows.MoveToEx(DC, R.Right, R.Bottom - RoundBy, nil)
      else
        Windows.MoveToEx(DC, R.Right, R.Bottom, nil);

      if scbeTop in Edges then
      begin
        Windows.LineTo(DC, R.Right, R.Top + RoundBy);
        Windows.LineTo(DC, R.Right - RoundBy, R.Top);
      end else
        Windows.LineTo(DC, R.Right, R.Top - 1);
    end;

    if AFillCorner and (RoundBy = 2) and (Edges <> []) and (ParentColor <> clNone) then
    begin
      P.Color := ParentColor;
      SelectObject(DC, P.Handle);

      if (scbeTop in Edges) and (scbeLeft in Edges) then
      begin
        Windows.MoveToEx(DC, R.Left + 1, R.Top, nil);

        Windows.LineTo(DC, R.Left, R.Top);
        Windows.LineTo(DC, R.Left, R.Top + 1);
        Windows.LineTo(DC, R.Left + 1, R.Top);
      end;

      if (scbeLeft in Edges) and (scbeBottom in Edges) then
      begin
        Windows.MoveToEx(DC, R.Left, R.Bottom - 1, nil);

        Windows.LineTo(DC, R.Left, R.Bottom);
        Windows.LineTo(DC, R.Left + 1, R.Bottom);
        Windows.LineTo(DC, R.Left, R.Bottom - 1);
      end;

      if (scbeBottom in Edges) and (scbeRight in Edges) then
      begin
        Windows.MoveToEx(DC, R.Right - 1, R.Bottom, nil);

        Windows.LineTo(DC, R.Right, R.Bottom);
        Windows.LineTo(DC, R.Right, R.Bottom - 1);
        Windows.LineTo(DC, R.Right - 1, R.Bottom);
      end;

      if (scbeRight in Edges) and (scbeTop in Edges) then
      begin
        Windows.MoveToEx(DC, R.Right, R.Top + 1, nil);

        Windows.LineTo(DC, R.Right, R.Top);
        Windows.LineTo(DC, R.Right - 1, R.Top);
        Windows.LineTo(DC, R.Right, R.Top + 1);
      end;
    end;
  end;
  
var
  P: TPen;
  OldPen: HPen;
begin
  if (DC = 0) or (B = sccbNone) or IsRectEmpty(R) or (Edges = []) then
    Exit;

  OldPen := 0;
  P := TPen.Create;
  try
    P.Width := 1;
    P.Style := psSolid;

    SetROP2(DC, R2_COPYPEN);
    OldPen := SelectObject(DC, P.Handle);

    case B of
      sccb3DRaised:
      begin
        DrawEdge(DC, R, BDR_RAISEDOUTER, BF_ADJUST or BF_RECT);
        DrawEdge(DC, R, BDR_RAISEDINNER, BF_ADJUST or BF_RECT);
      end;
      sccb3DLowered:
      begin
        DrawEdge(DC, R, BDR_SUNKENOUTER, BF_ADJUST or BF_RECT);
        DrawEdge(DC, R, BDR_SUNKENINNER, BF_ADJUST or BF_RECT);
      end;
      sccbBumped:
      begin
        DrawEdge(DC, R, BDR_RAISEDINNER, BF_ADJUST or BF_RECT);
        DrawEdge(DC, R, BDR_SUNKENOUTER, BF_ADJUST or BF_RECT);
      end;
      sccbEtched:
        DrawEdge(DC, R, EDGE_ETCHED, BF_ADJUST or BF_RECT);
      sccbRaised:
        DrawEdge(DC, R, BDR_RAISEDINNER, BF_ADJUST or BF_RECT);
      sccbLowered:
        DrawEdge(DC, R, BDR_SUNKENOUTER, BF_ADJUST or BF_RECT);
      sccbFlat, sccbColor:
      begin
        Draw3DFrame(R, C, C, P);
      end;
      sccbFlatBold:
      begin
        Draw3DFrame(R, C, C, P);
        InflateRect(R, -1, -1);
        Draw3DFrame(R, C, C, P);
      end;
      sccbFlatRounded:
      begin
        DrawFrameRounded(R, C, P, FillCorner, 2);
      end;
      sccbFlatBoldRounded:
      begin
        DrawFrameRounded(R, C, P, FillCorner, 2);
        InflateRect(R, -1, -1);

        DrawFrameRounded(R, C, P, False, 1);
        DrawFrameRounded(R, C, P, False, 2);
      end;
      sccbMacLowered:
      begin
        DrawEdge(DC, R, BDR_SUNKENOUTER, BF_ADJUST or BF_RECT);
        Draw3DFrame(R, clWindowFrame, clWindowFrame, P);
      end;
      sccbMacRaised:
      begin
        Draw3DFrame(R, clWindowFrame, clWindowFrame, P);
        InflateRect(R, -1, -1);

        DrawEdge(DC, R, BDR_RAISEDINNER, BF_ADJUST or BF_RECT);
      end;
      sccbMetal:
      begin
        Draw3DFrame(R, clBtnShadow, clBtnHighlight, P);

        InflateRect(R, -1, -1);
        Draw3DFrame(R, clBtnFace, clBtnFace, P);
      end;
      sccbSoftLowered:
      begin
        Draw3DFrame(R, clBtnFace, clBtnHighlight, P);

        InflateRect(R, -1, -1);
        Draw3DFrame(R, clBtnShadow, clBtnShadow, P);
      end;
      sccbSoftRaised:
      begin
        Draw3DFrame(R, clBtnShadow, clBtnShadow, P);

        InflateRect(R, -1, -1);
        Draw3DFrame(R, clBtnHighlight, clBtnFace, P);
      end;
    end;
  finally
    if OldPen <> 0 then SelectObject(DC, OldPen);
    P.Free;
  end;
end;

procedure scDrawEdge(ACanvas: TCanvas; R: TRect; C, ParentColor: TColor;
  FillCorner: Boolean; B: TSCBorder; Edges: TSCBorderEdges);
begin
  if (ACanvas <> nil) and (B <> sccbNone) and (Edges <> []) then
    scDrawEdgeEx(ACanvas.Handle, R, C, ParentColor, FillCorner, B, Edges);
end;

procedure scDrawBevel(ACanvas: TCanvas; R: TRect; C, ParentColor: TColor;
  FillCorner: Boolean; B: TSCBorder; Edges: TSCBorderEdges);
begin
  if (ACanvas <> nil) and (B <> sccbNone) and (Edges <> []) then
    scDrawBevelEx(ACanvas.Handle, R, C, ParentColor, FillCorner, B, Edges);
end;

procedure scHSVtoRGB(const H, S, V: Integer; var R, G, B: Byte);
const
  divisor: Integer = 255*60;
var
  f, hTemp,
  p, q, t, VS: Integer;
begin
  if S = 0 then  // achromatic:  shades of gray
  begin
    R := V;
    G := V;
    B := V;
  end else
  begin   // chromatic color
    if H = 360 then hTemp := 0
    else hTemp := H;

    f     := hTemp mod 60; // f is IN [0, 59]
    hTemp := hTemp div 60; // h is now IN [0..6]

    VS := V*S;
    p := V - VS div 255;                 // p = v * (1 - s)
    q := V - (VS*f) div divisor;         // q = v * (1 - s*f)
    t := V - (VS*(60 - f)) div divisor;  // t = v * (1 - s * (1 - f))

    case hTemp of
      0:
      begin
        R := V;
        G := t;
        B := p;
      end;
      1:
      begin
        R := q;
        G := V;
        B := p;
      end;
      2:
      begin
        R := p;
        G := V;
        B := t;
      end;
      3:
      begin
        R := p;
        G := q;
        B := V;
      end;
      4:
      begin
        R := t;
        G := p;
        B := V;
      end;
      5:
      begin
        R := V;
        G := p;
        B := q;
      end;
      else begin // should never happen; avoid compiler warning
        R := 0;
        G := 0;
        B := 0;
      end;
    end;
  end;
end;

procedure scRGBToHSV(const R, G, B: Byte; var H, S, V: Integer);
var
  Delta, Min: Integer;
begin
  Min := MinIntValue([R, G, B]);
  V   := MaxIntValue([R, G, B]);

  Delta := V - Min;

  // Calculate saturation: saturation is 0 if r, g and b are all 0
  if V = 0 then S := 0
  else S := MulDiv(Delta, 255, V);

  if S = 0 then
    H := 0 // Achromatic:  When s = 0, h is undefined but assigned the value 0
  else begin // Chromatic
    if R = V then  // degrees -- between yellow and magenta
      H := MulDiv(G - B, 60, Delta)
    else if G = V then // between cyan and yellow
      H := 120 + MulDiv(B - R, 60, Delta)
    else if B = V then // between magenta and cyan
      H := 240 + MulDiv(R - G, 60, Delta);

    if H < 0 then H := H + 360;
  end;
end;

procedure scHSLtoRGB(const H, S, L: Word; var R, G, B: Byte);
var
  HR, SR, LR,
  RR, GR, BR,
  Val, M, SV,
  Fract, VSF, Mid1, Mid2: Real;
  HI: Integer;
begin
  HR := H / 239;
  SR := S / 240;
  LR := L / 240;

  if LR < 0.5 then
    Val := LR * (1.0 + SR)
  else
    Val := LR + SR - LR * SR;

  if Val <= 0 then
  begin
    RR := 0.0;
    GR := 0.0;
    BR := 0.0;
  end else
  begin
    M := (2 * LR) - Val;
    SV := (Val - M) / Val;

    HR := HR * 6.0;
    HI := Trunc(HR);
    Fract := HR - HI;

    VSF := Val * SV * Fract;
    Mid1 := M + VSF;
    Mid2 := Val - VSF;

    case HI of
      0: begin
        RR := Val;
        GR := Mid1;
        BR := M;
      end;
      1: begin
        RR := Mid2;
        GR := Val;
        BR := M;
      end;
      2: begin
        RR := M;
        GR := Val;
        BR := Mid1;
      end;
      3: begin
        RR := M;
        GR := Mid2;
        BR := Val;
      end;
      4: begin
        RR := Mid1;
        GR := M;
        BR := Val;
      end;
      5: begin
        RR := Val;
        GR := M;
        BR := Mid2;
      end;
      else begin
        RR := Val;
        GR := Mid1;
        BR := M;
      end;
    end;
  end;

  if RR > 1.0 then RR := 1.0;
  if GR > 1.0 then GR := 1.0;
  if BR > 1.0 then BR := 1.0;

  R := Round(RR * 255);
  G := Round(GR * 255);
  B := Round(BR * 255);
end;

procedure scRGBToHSL(const R, G, B: Byte; var H, S, L: Word);
var
  MnMxDif, Cmax, Cmin,
  RR, GR, BR,
  TmpH, TmpS, TmpL: Real;
begin
  RR := GetRValue(R) / 255;
  GR := GetGValue(G) / 255;
  BR := GetBValue(B) / 255;

  CMax := MaxValue([RR, GR, BR]);
  CMin := MinValue([RR, GR, BR]);

  TmpL := (Cmax + Cmin) / 2.0;

  if Cmax = Cmin then
  begin
    TmpS := 0;
    TmpH := 0;
  end else
  begin
    MnMxDif := Cmax - Cmin;

    if TmpL < 0.5 then
      TmpS := MnMxDif / (Cmax + Cmin)
    else
      TmpS := MnMxDif / (2.0 - (Cmax + Cmin));

    if RR = Cmax then
      TmpH := (GR - BR) / MnMxDif
    else if GR = Cmax then
      TmpH := 2.0 + (BR - RR) / MnMxDif
    else
      TmpH := 4.0 + (RR - GR) / MnMxDif;

    TmpH := TmpH / 6;
    if TmpH < 0 then TmpH := TmpH + 1;
  end;

  H := Round(240 * TmpH);
  H := H mod 240;

  S := Round(240 * TmpS);
  L := Round(240 * TmpL);
end;

procedure scRGBToCMY(const R, G, B: Byte; var C, M, Y: Byte);
begin
  C := 255 - R;
  M := 255 - G;
  Y := 255 - B;
end;

procedure scHSBtoRGB(const H, S, Br: Integer; var R, G, B: Byte);
var
  Sat, Val: Integer;
begin
  Sat := Muldiv(S, 255, 100);
  Val := Muldiv(Br, 255, 100);

  scHSVtoRGB(H, Sat, Val, R, G, B);
end;

procedure scRGBToHSB(const R, G, B: Byte; var H, S, Br: Integer);
begin
  scRGBToHSV(R, G, B, H, S, Br);

  S  := Muldiv(S, 100, 255);
  Br := Muldiv(Br, 100, 255);
end;

procedure scRGBToCMYK(const R, G, B: Byte; var C, M, Y, K: Byte);
begin
  scRGBToCMY(R, G, B, C, M, Y);
  K := MinIntValue([C, M, Y]);

  C := C - K;
  M := M - K;
  Y := Y - K;
end;

procedure scCMYKToRGB(C, M, Y, K: Byte; var R, G, B : Byte);
begin
  if (Integer(C) + Integer(K)) < 255 then R := 255 - (C + K) else R := 0;
  if (Integer(M) + Integer(K)) < 255 then G := 255 - (M + K) else G := 0;
  if (Integer(Y) + Integer(K)) < 255 then B := 255 - (Y + K) else B := 0;
end;

procedure scColorToHSV(const Color: TColor; var H, S, V: Integer);
var
  C: LongInt;
begin
  C := ColorToRGB(Color);
  scRGBToHSV(GetRValue(C), GetGValue(C), GetBValue(C), H, S, V);
end;

function scHSVtoColor(const H, S, V: Integer): TColor;
var
  R, G, B: Byte;
begin
  scHSVtoRGB(H, S, V, R, G, B);
  Result := RGB(R, G, B);
end;

function scHSLtoColor(const H, S, L: Word): TColor;
var
  R, G, B: Byte;
begin
  scHSLtoRGB(H, S, L, R, G, B);
  Result := RGB(R, G, B);
end;

procedure scColorToHSL(const Color: TColor; var H, S, L: Word);
var
  C: LongInt;
begin
  C := ColorToRGB(Color);
  scRGBToHSL(GetRValue(C), GetGValue(C), GetBValue(C), H, S, L);
end;

function  scHSBtoColor(const H, S, Br: Integer): TColor;
var
  R, G, B: Byte;
begin
  scHSBtoRGB(H, S, Br, R, G, B);
  Result := RGB(R, G, B);
end;

procedure scColorToHSB(const Color: TColor; var H, S, Br: Integer);
var
  C: LongInt;
begin
  C := ColorToRGB(Color);
  scRGBToHSB(GetRValue(C), GetGValue(C), GetBValue(C), H, S, Br);
end;

function scCMYKToColor(const C, M, Y, K: Byte): TColor;
var
  R, G, B: Byte;
begin
  scCMYKToRGB(C, M, Y, K, R, G, B);
  Result := RGB(R, G, B);
end;

procedure scColorToCMYK(const Color: TColor; var C, M, Y, K: Byte);
var
  RGBVal: LongInt;
begin
  RGBVal := ColorToRGB(Color);
  scRGBToCMYK(GetRValue(RGBVal), GetGValue(RGBVal), GetBValue(RGBVal),
    C, M, Y, K);
end;

procedure scDrawDownSlider(ACanvas: TCanvas; P: TPoint; W, H: Integer;
  Style: TSCThumbStyle; Blind: Boolean; FrameColor: TColor; FaceColor: TColor);
var
  R, R2: TRect;
  Indent, Tail: Integer;
  Pts1: array[0..4] of TPoint;
  Pts2: array[0..2] of TPoint;
  Pts3: array[0..3] of TPoint;
  Pts6: array[0..6] of TPoint;
begin
  if (H > 0) and (W > 0) and (ACanvas <> nil) then
  begin
    case Style of
      sctsNew:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        if FrameColor = clNone then
          FrameColor := clHighlight;

        W := W div 2;

        if H < W then H := W;

        if Blind then
        begin
          with ACanvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := FaceColor;
            Pen.Mode    := pmCopy;
            Pen.Style   := psSolid;

            R := Rect(P.x - W, P.y, P.x + W, P.y + H);
            InflateRect(R, 0, -1);
            FillRect(R);

            InflateRect(R, 0, 1);

            Pen.Color   := GetBtnShadowOf(FaceColor);
            MoveTo(R.Left + 1,  R.Top);
            LineTo(R.Right, R.Top);

            MoveTo(R.Left, R.Top + 1);
            LineTo(R.Left, R.Bottom - 1);


            Pen.Color := Get3DDkShadowOf(FaceColor);
            MoveTo(R.Right, R.Top + 1);
            LineTo(R.Right, R.Bottom - 1);

            MoveTo(R.Left + 1,  R.Bottom - 1);
            LineTo(R.Right, R.Bottom - 1);


            InflateRect(R, -1, -1);

            R2 := R;
            Inc(R2.Right);
            scFrame3D(ACanvas, R2, GetBtnHighlightOf(FaceColor),
              GetBtnShadowOf(FaceColor), 1, 0);

            Dec(R2.Right);
            Pen.Color := BlendedColor(FaceColor, 48, 48, 48, False);
            MoveTo(R2.Right, R2.Top);
            LineTo(R2.Right, R2.Bottom);


            R2 := R;
            R2.Bottom := R2.Top + 3;

            Brush.Color := BlendedColor(FrameColor, 24, 24, 24, True);
            FillRect(R2);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, True);
            MoveTo(R2.Left, R2.Top);
            LineTo(R2.Left, R2.Bottom);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, False);
            MoveTo(R2.Right, R2.Top);
            LineTo(R2.Right, R2.Bottom);

            R2 := R;
            R2.Top := R2.Bottom - 3;

            Brush.Color := FrameColor;
            FillRect(R2);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, True);
            MoveTo(R2.Left, R2.Top);
            LineTo(R2.Left, R2.Bottom);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, False);
            MoveTo(R2.Right, R2.Top);
            LineTo(R2.Right, R2.Bottom);
          end;

          Exit;
        end;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          Pen.Color   := GetBtnShadowOf(FaceColor);

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x + W;
          Pts1[1].y := P.y + W;
          Pts1[2].x := P.x + W;
          Pts1[2].y := P.y + H;
          Pts1[3].x := P.x - W;
          Pts1[3].y := P.y + H;
          Pts1[4].x := P.x - W;
          Pts1[4].y := P.y + W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          // Pen.Color   := clBtnShadow;
          Pen.Color := GetBtnShadowOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y + 1;
          Pts3[1].x := P.x + W - 1;
          Pts3[1].y := P.y + W;
          Pts3[2].x := P.x + W - 1;
          Pts3[2].y := P.y + H - 1;
          Pts3[3].x := P.x - W;
          Pts3[3].y := P.y + H - 1;
          PolyLine(Pts3);

          // Pen.Color   := clBtnHighlight;
          Pen.Color := GetBtnHighlightOf(FaceColor);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y + 3;
          Pts2[1].x := P.x - W + 1;
          Pts2[1].y := P.y + W + 2;
          Pts2[2].x := P.x - W + 1;
          Pts2[2].y := P.y + H - 1;
          PolyLine(Pts2);

          // Pen.Color   := BlendedColor(clBtnFace, 48, 48, 48, False);
          Pen.Color   := BlendedColor(FaceColor, 48, 48, 48, False);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y + 2;
          Pts2[1].x := P.x + W - 2;
          Pts2[1].y := P.y + W;
          Pts2[2].x := P.x + W - 2;
          Pts2[2].y := P.y + H - 1;
          PolyLine(Pts2);

          Pen.Color   := FrameColor;
          Pts2[0].x := P.x - W + 1;
          Pts2[0].y := P.y + W;
          Pts2[1].x := P.x;
          Pts2[1].y := P.y + 1;
          Pts2[2].x := P.x + W;
          Pts2[2].y := P.y + W + 1;
          PolyLine(Pts2);

          Pen.Color   := FrameColor;
          Pts2[0].x := P.x - W + 1;
          Pts2[0].y := P.y + W + 1;
          Pts2[1].x := P.x;
          Pts2[1].y := P.y + 2;
          Pts2[2].x := P.x + W;
          Pts2[2].y := P.y + W + 2;
          PolyLine(Pts2);

          Pen.Color   := BlendedColor(FrameColor, 42, 36, 16, True);
          MoveTo(P.x - W + 1, P.y + W);
          LineTo(P.x + 1, P.y);

          Pen.Color   := FrameColor;
          MoveTo(P.x + W - 1, P.y + H - 3);
          LineTo(P.x - W,     P.y + H - 3);
          MoveTo(P.x + W - 1, P.y + H - 2);
          LineTo(P.x - W,     P.y + H - 2);
          MoveTo(P.x + W - 1, P.y + H - 1);
          LineTo(P.x - W,     P.y + H - 1);

          Pen.Color   := BlendedColor(FrameColor, 42, 36, 16, True);
          MoveTo(P.x - W + 1, P.y + H - 3);
          LineTo(P.x - W + 1, P.y + H);

          Pen.Color   := BlendedColor(FrameColor, 42, 36, 16, False);
          MoveTo(P.x + W - 1, P.y + H - 3);
          LineTo(P.x + W - 1, P.y + H);

          // Pen.Color   := cl3DDkShadow;
          Pen.Color := Get3DDkShadowOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x + W;
          Pts3[1].y := P.y + W;
          Pts3[2].x := P.x + W;
          Pts3[2].y := P.y + H;
          Pts3[3].x := P.x - W - 1;
          Pts3[3].y := P.y + H;
          PolyLine(Pts3);

          // Pen.Color   := clBtnFace;
          Pen.Color := FaceColor;
          MoveTo(P.x - W, P.y + H);
          LineTo(P.x - W + 1, P.y + H);

          // Pen.Color   := clBtnFace;
          Pen.Color := FaceColor;
          MoveTo(P.x + W, P.y + H);
          LineTo(P.x + W - 1, P.y + H);
        end;
      end;
      sctsWindows:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        W := W div 2;

        if H < W then H := W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          // Pen.Color   := clBtnFace;
          Pen.Color   := FaceColor;

          if Blind then
          begin
            R := Rect(P.x - W, P.y, P.x + W + 1, P.y + H);

            FillRect(R);

            scFrame3D(ACanvas, R, GetBtnHighlightOf(FaceColor),
              Get3DDkShadowOf(FaceColor), 1, 0);
            scFrame3D(ACanvas, R, FaceColor, GetBtnShadowOf(FaceColor), 1, 0);

            Exit;
          end;

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x + W;
          Pts1[1].y := P.y + W;
          Pts1[2].x := P.x + W;
          Pts1[2].y := P.y + H;
          Pts1[3].x := P.x - W;
          Pts1[3].y := P.y + H;
          Pts1[4].x := P.x - W;
          Pts1[4].y := P.y + W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          // Pen.Color   := clBtnShadow;
          Pen.Color := GetBtnShadowOf(FaceColor);

          Pts3[0].x := P.x;
          Pts3[0].y := P.y + 1;
          Pts3[1].x := P.x + W - 1;
          Pts3[1].y := P.y + W;
          Pts3[2].x := P.x + W - 1;
          Pts3[2].y := P.y + H - 1;
          Pts3[3].x := P.x - W;
          Pts3[3].y := P.y + H - 1;
          PolyLine(Pts3);

          // Pen.Color   := clBtnHighlight;
          Pen.Color := GetBtnHighlightOf(FaceColor);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x - W;
          Pts2[1].y := P.y + W;
          Pts2[2].x := P.x - W;
          Pts2[2].y := P.y + H;
          PolyLine(Pts2);

          // Pen.Color   := cl3DDkShadow;
          Pen.Color := Get3DDkShadowOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x + W;
          Pts3[1].y := P.y + W;
          Pts3[2].x := P.x + W;
          Pts3[2].y := P.y + H;
          Pts3[3].x := P.x - W - 1;
          Pts3[3].y := P.y + H;
          PolyLine(Pts3);
        end;
      end;
      sctsMetal:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        W := W div 2;

        if H < W then H := W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          // Pen.Color   := FaceColor;

          if Blind then
          begin
            R := Rect(P.x - W, P.y, P.x + W + 1, P.y + H);

            FillRect(R);

            scFrame3D(ACanvas, R, GetBtnShadowOf(FaceColor), GetBtnShadowOf(FaceColor), 1, 0);
            scFrame3D(ACanvas, R, SCCommon.scBlendColor(FaceColor, 64), FaceColor, 1, 0);

            Exit;
          end;

          Pen.Color := GetBtnShadowOf(FaceColor);

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x + W;
          Pts1[1].y := P.y + W;
          Pts1[2].x := P.x + W;
          Pts1[2].y := P.y + H;
          Pts1[3].x := P.x - W;
          Pts1[3].y := P.y + H;
          Pts1[4].x := P.x - W;
          Pts1[4].y := P.y + W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          Pen.Color := SCCommon.scBlendColor(FaceColor, 64);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y + 1;
          Pts2[1].x := P.x - W + 1;
          Pts2[1].y := P.y + W;
          Pts2[2].x := P.x - W + 1;
          Pts2[2].y := P.y + H - 1;
          PolyLine(Pts2);
        end;
      end;
      sctsPSNew:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        W := W div 2;

        if H < W then H := W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          Pen.Color   := Get3DDkShadowOf(FaceColor);

          if Blind then
          begin
            R := Rect(P.x - W, P.y, P.x + W + 1, P.y + H);

            FillRect(R);

            scFrame3D(ACanvas, R, Get3DDkShadowOf(FaceColor), Get3DDkShadowOf(FaceColor), 1, 0);
            scFrame3D(ACanvas, R, GetBtnHighlightOf(FaceColor), FaceColor, 1, 0);

            Exit;
          end;

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x + W;
          Pts1[1].y := P.y + W;
          Pts1[2].x := P.x + W;
          Pts1[2].y := P.y + H;
          Pts1[3].x := P.x - W;
          Pts1[3].y := P.y + H;
          Pts1[4].x := P.x - W;
          Pts1[4].y := P.y + W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          Pen.Color := GetBtnHighlightOf(FaceColor);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y + 1;
          Pts2[1].x := P.x - W + 1;
          Pts2[1].y := P.y + W;
          Pts2[2].x := P.x - W + 1;
          Pts2[2].y := P.y + H;
          PolyLine(Pts2);

          Pen.Color := Get3DDkShadowOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x + W;
          Pts3[1].y := P.y + W;
          Pts3[2].x := P.x + W;
          Pts3[2].y := P.y + H;
          Pts3[3].x := P.x - W - 1;
          Pts3[3].y := P.y + H;
          PolyLine(Pts3);
        end;
      end;
      sctsMac, sctsPS:
      begin
        if FaceColor = clNone then
        begin
          if Style = sctsPS then
            FaceColor := clBtnFace
          else FaceColor := clWindowFrame;
        end;

        if (Style = sctsPS) and (FrameColor = clNone) then
          FrameColor := clWindowFrame;

        W := W div 2;

        Dec(P.x);
        Pts2[0].x := P.x;
        Pts2[0].y := P.y;
        Pts2[1].x := P.x + W;
        Pts2[1].y := P.y + H;
        Pts2[2].x := P.x - W;
        Pts2[2].y := P.y + H;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          
          if Style = sctsPS then
            Pen.Color := FrameColor
          else Pen.Color := FaceColor;

          Polygon(Pts2);
        end;
      end;
      sctsArrow, sctsExArrow:
      begin
        if FaceColor = clNone then
          FaceColor := clWindowFrame;

        if FrameColor = clNone then
          FrameColor := clWindowFrame;

        W := W div 2;
        Indent := W div 2;

        if H < W + 2 then H := W + 2;

        Tail := 0;
        if Style = sctsExArrow then
        begin
          if H < W + 4 then H := W + 4;

          Tail := H - (W + 3);
          H := W + 2;
        end;

        Dec(P.x);
        Pts6[0].x := P.x;
        Pts6[0].y := P.y;
        Pts6[1].x := P.x + W;
        Pts6[1].y := P.y + W;
        Pts6[2].x := P.x + Indent;
        Pts6[2].y := P.y + W;
        Pts6[3].x := P.x + Indent;
        Pts6[3].y := P.y + H;
        Pts6[4].x := P.x - Indent;
        Pts6[4].y := P.y + H;
        Pts6[5].x := P.x - Indent;
        Pts6[5].y := P.y + W;
        Pts6[6].x := P.x - W;
        Pts6[6].y := P.y + W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          Pen.Color   := FrameColor;

          Polygon(Pts6);

          if Style = sctsExArrow then
          begin
            Inc(H, 2);

            Pts3[0].x := P.x - Indent;
            Pts3[0].y := P.y + H;
            Pts3[1].x := P.x + Indent;
            Pts3[1].y := P.y + H;
            Pts3[2].x := P.x + Indent;
            Pts3[2].y := P.y + H + Tail;
            Pts3[3].x := P.x - Indent;
            Pts3[3].y := P.y + H + Tail;

            Polygon(Pts3);
          end;
        end;
      end;
    end;
  end;
end;

procedure scDrawUpSlider(ACanvas: TCanvas; P: TPoint; W, H: Integer;
  Style: TSCThumbStyle; Blind: Boolean; FrameColor: TColor; FaceColor: TColor);
var
  R, R2: TRect;
  Pts1: array[0..4] of TPoint;
  Pts2: array[0..2] of TPoint;
  Pts3: array[0..3] of TPoint;
  Pts6: array[0..6] of TPoint;
  Indent, Tail: Integer;
begin
  if (H > 0) and (W > 0) and (ACanvas <> nil) then
  begin
    case Style of
      sctsNew:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        if FrameColor = clNone then
          FrameColor := clHighlight;

        W := W div 2;

        if H < W then H := W;

        if Blind then
        begin
          with ACanvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := FaceColor;
            Pen.Mode    := pmCopy;
            Pen.Style   := psSolid;
            
            R := Rect(P.x - W, P.y - H, P.x + W, P.y);
            InflateRect(R, 0, -1);
            FillRect(R);

            InflateRect(R, 0, 1);

            Pen.Color   := GetBtnShadowOf(FaceColor);
            MoveTo(R.Left + 1,  R.Top);
            LineTo(R.Right, R.Top);

            MoveTo(R.Left, R.Top + 1);
            LineTo(R.Left, R.Bottom - 1);


            Pen.Color := Get3DDkShadowOf(FaceColor);
            MoveTo(R.Right, R.Top + 1);
            LineTo(R.Right, R.Bottom - 1);

            MoveTo(R.Left + 1,  R.Bottom - 1);
            LineTo(R.Right, R.Bottom - 1);


            InflateRect(R, -1, -1);

            R2 := R;
            Inc(R2.Right);
            scFrame3D(ACanvas, R2, GetBtnHighlightOf(FaceColor),
              GetBtnShadowOf(FaceColor), 1, 0);

            Dec(R2.Right);
            Pen.Color := BlendedColor(FaceColor, 48, 48, 48, False);
            MoveTo(R2.Right, R2.Top);
            LineTo(R2.Right, R2.Bottom);

            
            R2 := R;
            R2.Bottom := R2.Top + 3;

            Brush.Color := BlendedColor(FrameColor, 24, 24, 24, True);
            FillRect(R2);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, True);
            MoveTo(R2.Left, R2.Top);
            LineTo(R2.Left, R2.Bottom);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, False);
            MoveTo(R2.Right, R2.Top);
            LineTo(R2.Right, R2.Bottom);

            R2 := R;
            R2.Top := R2.Bottom - 3;

            Brush.Color := FrameColor;
            FillRect(R2);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, True);
            MoveTo(R2.Left, R2.Top);
            LineTo(R2.Left, R2.Bottom);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, False);
            MoveTo(R2.Right, R2.Top);
            LineTo(R2.Right, R2.Bottom);
          end;

          Exit;
        end;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          // Brush.Color := clBtnFace;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          // Pen.Color   := clBtnShadow;
          Pen.Color   := GetBtnShadowOf(FaceColor);

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x + W;
          Pts1[1].y := P.y - W;
          Pts1[2].x := P.x + W;
          Pts1[2].y := P.y - H;
          Pts1[3].x := P.x - W;
          Pts1[3].y := P.y - H;
          Pts1[4].x := P.x - W;
          Pts1[4].y := P.y - W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          // Pen.Color   := clBtnShadow;
          Pen.Color   := GetBtnShadowOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y - 1;
          Pts3[1].x := P.x + W - 1;
          Pts3[1].y := P.y - W;
          Pts3[2].x := P.x + W - 1;
          Pts3[2].y := P.y - H + 1;
          Pts3[3].x := P.x - W;
          Pts3[3].y := P.y - H + 1;
          PolyLine(Pts3);

          // Pen.Color   := clBtnHighlight;
          Pen.Color   := GetBtnHighlightOf(FaceColor);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y - 3;
          Pts2[1].x := P.x - W + 1;
          Pts2[1].y := P.y - W - 2;
          Pts2[2].x := P.x - W + 1;
          Pts2[2].y := P.y - H + 1;
          PolyLine(Pts2);

          // Pen.Color   := BlendedColor(clBtnFace, 48, 48, 48, False);
          Pen.Color   := BlendedColor(FaceColor, 48, 48, 48, False);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y - 2;
          Pts2[1].x := P.x + W - 2;
          Pts2[1].y := P.y - W;
          Pts2[2].x := P.x + W - 2;
          Pts2[2].y := P.y - H + 1;
          PolyLine(Pts2);

          Pen.Color   := FrameColor;
          Pts2[0].x := P.x - W + 1;
          Pts2[0].y := P.y - W;
          Pts2[1].x := P.x;
          Pts2[1].y := P.y - 1;
          Pts2[2].x := P.x + W;
          Pts2[2].y := P.y - W - 1;
          PolyLine(Pts2);

          Pen.Color   := FrameColor;
          Pts2[0].x := P.x - W + 1;
          Pts2[0].y := P.y - W - 1;
          Pts2[1].x := P.x;
          Pts2[1].y := P.y - 2;
          Pts2[2].x := P.x + W;
          Pts2[2].y := P.y - W - 2;
          PolyLine(Pts2);

          Pen.Color   := BlendedColor(FrameColor, 42, 36, 16, True);
          MoveTo(P.x - W + 1, P.y - W);
          LineTo(P.x + 1, P.y);

          Pen.Color   := FrameColor;
          MoveTo(P.x + W - 1, P.y - H + 3);
          LineTo(P.x - W,     P.y - H + 3);
          MoveTo(P.x + W - 1, P.y - H + 2);
          LineTo(P.x - W,     P.y - H + 2);
          MoveTo(P.x + W - 1, P.y - H + 1);
          LineTo(P.x - W,     P.y - H + 1);

          Pen.Color   := BlendedColor(FrameColor, 42, 36, 16, True);
          MoveTo(P.x - W + 1, P.y - H + 3);
          LineTo(P.x - W + 1, P.y - H);

          Pen.Color   := BlendedColor(FrameColor, 42, 36, 16, False);
          MoveTo(P.x + W - 1, P.y - H + 3);
          LineTo(P.x + W - 1, P.y - H);

          // Pen.Color   := cl3DDkShadow;
          Pen.Color   := Get3DDkShadowOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x + W;
          Pts3[1].y := P.y - W;
          Pts3[2].x := P.x + W;
          Pts3[2].y := P.y - H;
          Pts3[3].x := P.x - W - 1;
          Pts3[3].y := P.y - H;
          PolyLine(Pts3);

          // Pen.Color   := clBtnFace;
          Pen.Color := FaceColor;
          MoveTo(P.x - W, P.y - H);
          LineTo(P.x - W + 1, P.y - H);

          // Pen.Color   := clBtnFace;
          Pen.Color := FaceColor;
          MoveTo(P.x + W, P.y - H);
          LineTo(P.x + W - 1, P.y - H);
        end;
      end;
      sctsWindows:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        W := W div 2;

        if H < W then H := W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          // Pen.Color   := clBtnFace;
          Pen.Color   := FaceColor;

          if Blind then
          begin
            R := Rect(P.x - W, P.y - H, P.x + W + 1, P.y);

            FillRect(R);

            scFrame3D(ACanvas, R, GetBtnHighlightOf(FaceColor),
              Get3DDkShadowOf(FaceColor), 1, 0);
            scFrame3D(ACanvas, R, FaceColor, GetBtnShadowOf(FaceColor), 1, 0);

            Exit;
          end;

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x + W;
          Pts1[1].y := P.y - W;
          Pts1[2].x := P.x + W;
          Pts1[2].y := P.y - H;
          Pts1[3].x := P.x - W;
          Pts1[3].y := P.y - H;
          Pts1[4].x := P.x - W;
          Pts1[4].y := P.y - W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          // Pen.Color   := clBtnHighlight;
          Pen.Color := GetBtnHighlightOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x - W;
          Pts3[1].y := P.y - W;
          Pts3[2].x := P.x - W;
          Pts3[2].y := P.y - H;
          Pts3[3].x := P.x + W;
          Pts3[3].y := P.y - H;
          PolyLine(Pts3);

          // Pen.Color   := clBtnShadow;
          Pen.Color := GetBtnShadowOf(FaceColor);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y - 1;
          Pts2[1].x := P.x + W - 1;
          Pts2[1].y := P.y - W;
          Pts2[2].x := P.x + W - 1;
          Pts2[2].y := P.y - H;
          PolyLine(Pts2);

          // Pen.Color   := cl3DDkShadow;
          Pen.Color := Get3DDkShadowOf(FaceColor);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x + W;
          Pts2[1].y := P.y - W;
          Pts2[2].x := P.x + W;
          Pts2[2].y := P.y - H - 1;
          PolyLine(Pts2);
        end;
      end;
      sctsMetal:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        W := W div 2;

        if H < W then H := W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;

          if Blind then
          begin
            R := Rect(P.x - W, P.y - H, P.x + W + 1, P.y);

            FillRect(R);

            scFrame3D(ACanvas, R, GetBtnShadowOf(FaceColor), GetBtnShadowOf(FaceColor), 1, 0);
            scFrame3D(ACanvas, R, SCCommon.scBlendColor(FaceColor, 64), FaceColor, 1, 0);

            Exit;
          end;

          Pen.Color := GetBtnShadowOf(FaceColor);
          
          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x + W;
          Pts1[1].y := P.y - W;
          Pts1[2].x := P.x + W;
          Pts1[2].y := P.y - H;
          Pts1[3].x := P.x - W;
          Pts1[3].y := P.y - H;
          Pts1[4].x := P.x - W;
          Pts1[4].y := P.y - W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          Pen.Color := SCCommon.scBlendColor(FaceColor, 64);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y - 1;
          Pts3[1].x := P.x - W + 1;
          Pts3[1].y := P.y - W;
          Pts3[2].x := P.x - W + 1;
          Pts3[2].y := P.y - H + 1;
          Pts3[3].x := P.x + W - 1;
          Pts3[3].y := P.y - H + 1;
          PolyLine(Pts3);
        end;
      end;
      sctsPSNew:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        W := W div 2;

        if H < W then H := W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          Pen.Color   := Get3DDkShadowOf(FaceColor);

          if Blind then
          begin
            R := Rect(P.x - W, P.y - H, P.x + W + 1, P.y);

            FillRect(R);

            scFrame3D(ACanvas, R, Get3DDkShadowOf(FaceColor), Get3DDkShadowOf(FaceColor), 1, 0);
            scFrame3D(ACanvas, R, GetBtnHighlightOf(FaceColor), FaceColor, 1, 0);

            Exit;
          end;

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x + W;
          Pts1[1].y := P.y - W;
          Pts1[2].x := P.x + W;
          Pts1[2].y := P.y - H;
          Pts1[3].x := P.x - W;
          Pts1[3].y := P.y - H;
          Pts1[4].x := P.x - W;
          Pts1[4].y := P.y - W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          Pen.Color := GetBtnHighlightOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y - 1;
          Pts3[1].x := P.x - W + 1;
          Pts3[1].y := P.y - W;
          Pts3[2].x := P.x - W + 1;
          Pts3[2].y := P.y - H + 1;
          Pts3[3].x := P.x + W;
          Pts3[3].y := P.y - H + 1;
          PolyLine(Pts3);

          Pen.Color := Get3DDkShadowOf(FaceColor);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x + W;
          Pts2[1].y := P.y - W;
          Pts2[2].x := P.x + W;
          Pts2[2].y := P.y - H - 1;
          PolyLine(Pts2);
        end;
      end;
      sctsMac, sctsPS:
      begin
        if FaceColor = clNone then
        begin
          if Style = sctsPS then
            FaceColor := clBtnFace
          else FaceColor := clWindowFrame;
        end;

        if (Style = sctsPS) and (FrameColor = clNone) then
          FrameColor := clWindowFrame;

        W := W div 2;

        Dec(P.x);
        Pts2[0].x := P.x;
        Pts2[0].y := P.y;
        Pts2[1].x := P.x + W;
        Pts2[1].y := P.y - H;
        Pts2[2].x := P.x - W;
        Pts2[2].y := P.y - H;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          
          if Style = sctsPS then
            Pen.Color := FrameColor
          else Pen.Color := FaceColor;

          Polygon(Pts2);
        end;
      end;
      sctsArrow, sctsExArrow:
      begin
        if FaceColor = clNone then
          FaceColor := clWindowFrame;

        if FrameColor = clNone then
          FrameColor := clWindowFrame;

        W := W div 2;
        Indent := W div 2;

        if H < W + 2 then H := W + 2;

        Tail := 0;
        if Style = sctsExArrow then
        begin
          if H < W + 4 then H := W + 4;

          Tail := H - (W + 3);
          H := W + 2;
        end;

        Dec(P.x);
        Pts6[0].x := P.x;
        Pts6[0].y := P.y;
        Pts6[1].x := P.x + W;
        Pts6[1].y := P.y - W;
        Pts6[2].x := P.x + Indent;
        Pts6[2].y := P.y - W;
        Pts6[3].x := P.x + Indent;
        Pts6[3].y := P.y - H;
        Pts6[4].x := P.x - Indent;
        Pts6[4].y := P.y - H;
        Pts6[5].x := P.x - Indent;
        Pts6[5].y := P.y - W;
        Pts6[6].x := P.x - W;
        Pts6[6].y := P.y - W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          Pen.Color   := FrameColor;

          Polygon(Pts6);

          if Style = sctsExArrow then
          begin
            Inc(H, 2);

            Pts3[0].x := P.x - Indent;
            Pts3[0].y := P.y - H;
            Pts3[1].x := P.x + Indent;
            Pts3[1].y := P.y - H;
            Pts3[2].x := P.x + Indent;
            Pts3[2].y := P.y - (H + Tail);
            Pts3[3].x := P.x - Indent;
            Pts3[3].y := P.y - (H + Tail);

            Polygon(Pts3);
          end;
        end;
      end;
    end;
  end;
end;

procedure scDrawLeftSlider(ACanvas: TCanvas; P: TPoint; W, H: Integer;
  Style: TSCThumbStyle; Blind: Boolean; FrameColor: TColor; FaceColor: TColor);
var
  R, R2: TRect;
  Pts1: array[0..4] of TPoint;
  Pts2: array[0..2] of TPoint;
  Pts3: array[0..3] of TPoint;
  Pts6: array[0..6] of TPoint;
  Indent, Tail: Integer;
begin
  if (H > 0) and (W > 0) and (ACanvas <> nil) then
  begin
    case Style of
      sctsNew:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        if FrameColor = clNone then
          FrameColor := clHighlight;

        W := W div 2;

        if H < W then H := W;

        if Blind then
        begin
          with ACanvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := FaceColor;
            Pen.Mode    := pmCopy;
            Pen.Style   := psSolid;

            R := Rect(P.x - H, P.y - W, P.x, P.y + W);
            Dec(R.Right);
            InflateRect(R, 0, -1);

            FillRect(R);

            InflateRect(R, 0, 1);

            Pen.Color   := GetBtnShadowOf(FaceColor);
            MoveTo(R.Left + 1,  R.Top);
            LineTo(R.Right, R.Top);

            MoveTo(R.Left, R.Top + 1);
            LineTo(R.Left, R.Bottom);


            Pen.Color := Get3DDkShadowOf(FaceColor);
            MoveTo(R.Right, R.Top + 1);
            LineTo(R.Right, R.Bottom);

            MoveTo(R.Left + 1,  R.Bottom);
            LineTo(R.Right, R.Bottom);

            
            InflateRect(R, -1, -1);
            Inc(R.Right);

            R2 := R;
            Inc(R2.Bottom);
            scFrame3D(ACanvas, R2, GetBtnHighlightOf(FaceColor),
              GetBtnShadowOf(FaceColor), 1, 0);

            Dec(R2.Bottom);
            Pen.Color := BlendedColor(FaceColor, 48, 48, 48, False);
            MoveTo(R2.Left,  R2.Bottom);
            LineTo(R2.Right, R2.Bottom);

            R2 := R;
            R2.Right := R2.Left + 3;

            Brush.Color := BlendedColor(FrameColor, 24, 24, 24, True);
            FillRect(R2);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, False);
            MoveTo(R2.Left,  R2.Bottom);
            LineTo(R2.Right, R2.Bottom);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, True);
            MoveTo(R2.Left,  R2.Top);
            LineTo(R2.Right, R2.Top);

            R2 := R;
            R2.Left := R2.Right - 3;

            Brush.Color := FrameColor;
            FillRect(R2);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, False);
            MoveTo(R2.Left,  R2.Bottom);
            LineTo(R2.Right, R2.Bottom);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, True);
            MoveTo(R2.Left,  R2.Top);
            LineTo(R2.Right, R2.Top);
          end;

          Exit;
        end;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          // Brush.Color := clBtnFace;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          // Pen.Color   := clBtnShadow;
          Pen.Color   := GetBtnShadowOf(FaceColor);

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x - W;
          Pts1[1].y := P.y + W;
          Pts1[2].x := P.x - H;
          Pts1[2].y := P.y + W;
          Pts1[3].x := P.x - H;
          Pts1[3].y := P.y - W;
          Pts1[4].x := P.x - W;
          Pts1[4].y := P.y - W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          // Pen.Color   := clBtnShadow;
          Pen.Color := GetBtnShadowOf(FaceColor);
          Pts3[0].x := P.x - 1;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x - W;
          Pts3[1].y := P.y + W - 1;
          Pts3[2].x := P.x - H + 1;
          Pts3[2].y := P.y + W - 1;
          Pts3[3].x := P.x - H + 1;
          Pts3[3].y := P.y - W;
          PolyLine(Pts3);

          // Pen.Color   := clBtnHighlight;
          Pen.Color := GetBtnHighlightOf(FaceColor);
          Pts2[0].x := P.x - 3;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x - W - 2;
          Pts2[1].y := P.y - W + 1;
          Pts2[2].x := P.x - H + 1;
          Pts2[2].y := P.y - W + 1;
          PolyLine(Pts2);

          // Pen.Color   := BlendedColor(clBtnFace, 48, 48, 48, False);
          Pen.Color := BlendedColor(FaceColor, 48, 48, 48, False);
          Pts2[0].x := P.x - 2;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x - W;
          Pts2[1].y := P.y + W - 2;
          Pts2[2].x := P.x - H + 1;
          Pts2[2].y := P.y + W - 2;
          PolyLine(Pts2);

          Pen.Color   := FrameColor;
          Pts2[0].x := P.x - W;
          Pts2[0].y := P.y - W + 1;
          Pts2[1].x := P.x - 1;
          Pts2[1].y := P.y;
          Pts2[2].x := P.x - W - 1;
          Pts2[2].y := P.y + W;
          PolyLine(Pts2);

          Pen.Color   := FrameColor;
          Pts2[0].x := P.x - W - 1;
          Pts2[0].y := P.y - W + 1;
          Pts2[1].x := P.x - 2;
          Pts2[1].y := P.y;
          Pts2[2].x := P.x - W - 2;
          Pts2[2].y := P.y + W;
          PolyLine(Pts2);

          Pen.Color   := BlendedColor(FrameColor, 42, 36, 16, True);
          MoveTo(P.x - W, P.y - W + 1);
          LineTo(P.x,     P.y + 1);

          Pen.Color   := FrameColor;
          MoveTo(P.x - H + 3, P.y + W - 1);
          LineTo(P.x - H + 3, P.y - W);
          MoveTo(P.x - H + 2, P.y + W - 1);
          LineTo(P.x - H + 2, P.y - W);
          MoveTo(P.x - H + 1, P.y + W - 1);
          LineTo(P.x - H + 1, P.y - W);

          Pen.Color   := BlendedColor(FrameColor, 42, 36, 16, True);
          MoveTo(P.x - H + 3, P.y - W + 1);
          LineTo(P.x - H,     P.y - W + 1);

          Pen.Color   := BlendedColor(FrameColor, 42, 36, 16, False);
          MoveTo(P.x - H + 3, P.y + W - 1);
          LineTo(P.x - H,     P.y + W - 1);

          // Pen.Color   := cl3DDkShadow;
          Pen.Color := Get3DDkShadowOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x - W;
          Pts3[1].y := P.y + W;
          Pts3[2].x := P.x - H;
          Pts3[2].y := P.y + W;
          Pts3[3].x := P.x - H;
          Pts3[3].y := P.y - W - 1;
          PolyLine(Pts3);

          // Pen.Color   := clBtnFace;
          Pen.Color := FaceColor;
          MoveTo(P.x - H, P.y - W);
          LineTo(P.x - H, P.y - W + 1);

          // Pen.Color   := clBtnFace;
          Pen.Color := FaceColor;
          MoveTo(P.x - H, P.y + W);
          LineTo(P.x - H, P.y + W - 1);
        end;
      end;
      sctsWindows:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        W := W div 2;

        if H < W then H := W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          // Pen.Color   := clBtnFace;
          Pen.Color   := FaceColor;

          if Blind then
          begin
            R := Rect(P.x - H, P.y - W, P.x, P.y + W + 1);

            FillRect(R);

            scFrame3D(ACanvas, R, GetBtnHighlightOf(FaceColor),
              Get3DDkShadowOf(FaceColor), 1, 0);
            scFrame3D(ACanvas, R, FaceColor, GetBtnShadowOf(FaceColor), 1, 0);

            Exit;
          end;

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x - W;
          Pts1[1].y := P.y - W;
          Pts1[2].x := P.x - H;
          Pts1[2].y := P.y - W;
          Pts1[3].x := P.x - H;
          Pts1[3].y := P.y + W;
          Pts1[4].x := P.x - W;
          Pts1[4].y := P.y + W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          // Pen.Color   := clBtnHighlight;
          Pen.Color := GetBtnHighlightOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x - W;
          Pts3[1].y := P.y - W;
          Pts3[2].x := P.x - H;
          Pts3[2].y := P.y - W;
          Pts3[3].x := P.x - H;
          Pts3[3].y := P.y + W;
          PolyLine(Pts3);

          // Pen.Color   := clBtnShadow;
          Pen.Color := GetBtnShadowOf(FaceColor);
          Pts2[0].x := P.x - 1;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x - W;
          Pts2[1].y := P.y + W - 1;
          Pts2[2].x := P.x - H;
          Pts2[2].y := P.y + W - 1;
          PolyLine(Pts2);

          // Pen.Color   := cl3DDkShadow;
          Pen.Color := Get3DDkShadowOf(FaceColor);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x - W;
          Pts2[1].y := P.y + W;
          Pts2[2].x := P.x - H - 1;
          Pts2[2].y := P.y + W;
          PolyLine(Pts2);
        end;
      end;
      sctsMetal:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        W := W div 2;

        if H < W then H := W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;

          if Blind then
          begin
            R := Rect(P.x - H, P.y - W, P.x, P.y + W + 1);

            FillRect(R);

            scFrame3D(ACanvas, R, GetBtnShadowOf(FaceColor), GetBtnShadowOf(FaceColor), 1, 0);
            scFrame3D(ACanvas, R, SCCommon.scBlendColor(FaceColor, 64), FaceColor, 1, 0);

            Exit;
          end;

          Pen.Color := GetBtnShadowOf(FaceColor);

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x - W;
          Pts1[1].y := P.y - W;
          Pts1[2].x := P.x - H;
          Pts1[2].y := P.y - W;
          Pts1[3].x := P.x - H;
          Pts1[3].y := P.y + W;
          Pts1[4].x := P.x - W;
          Pts1[4].y := P.y + W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          Pen.Color := SCCommon.scBlendColor(FaceColor, 64);
          Pts3[0].x := P.x - 1;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x - W;
          Pts3[1].y := P.y - W + 1;
          Pts3[2].x := P.x - H + 1;
          Pts3[2].y := P.y - W + 1;
          Pts3[3].x := P.x - H + 1;
          Pts3[3].y := P.y + W - 1;
          PolyLine(Pts3);
        end;
      end;
      sctsPSNew:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        W := W div 2;

        if H < W then H := W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          Pen.Color   := Get3DDkShadowOf(FaceColor);

          if Blind then
          begin
            R := Rect(P.x - H, P.y - W, P.x, P.y + W + 1);

            FillRect(R);

            scFrame3D(ACanvas, R, Get3DDkShadowOf(FaceColor), Get3DDkShadowOf(FaceColor), 1, 0);
            scFrame3D(ACanvas, R, GetBtnHighlightOf(FaceColor), FaceColor, 1, 0);

            Exit;
          end;

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x - W;
          Pts1[1].y := P.y - W;
          Pts1[2].x := P.x - H;
          Pts1[2].y := P.y - W;
          Pts1[3].x := P.x - H;
          Pts1[3].y := P.y + W;
          Pts1[4].x := P.x - W;
          Pts1[4].y := P.y + W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          Pen.Color := GetBtnHighlightOf(FaceColor);
          Pts3[0].x := P.x - 1;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x - W;
          Pts3[1].y := P.y - W + 1;
          Pts3[2].x := P.x - H + 1;
          Pts3[2].y := P.y - W + 1;
          Pts3[3].x := P.x - H + 1;
          Pts3[3].y := P.y + W;
          PolyLine(Pts3);

          Pen.Color := Get3DDkShadowOf(FaceColor);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x - W;
          Pts2[1].y := P.y + W;
          Pts2[2].x := P.x - H - 1;
          Pts2[2].y := P.y + W;
          PolyLine(Pts2);
        end;
      end;
      sctsMac, sctsPS:
      begin
        if FaceColor = clNone then
        begin
          if Style = sctsPS then
            FaceColor := clBtnFace
          else FaceColor := clWindowFrame;
        end;

        if (Style = sctsPS) and (FrameColor = clNone) then
          FrameColor := clWindowFrame;

        W := W div 2;

        Dec(P.y);
        Pts2[0].x := P.x;
        Pts2[0].y := P.y;
        Pts2[1].x := P.x - H;
        Pts2[1].y := P.y + W;
        Pts2[2].x := P.x - H;
        Pts2[2].y := P.y - W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;

          if Style = sctsPS then
            Pen.Color := FrameColor
          else Pen.Color := FaceColor;

          Polygon(Pts2);
        end;
      end;
      sctsArrow, sctsExArrow:
      begin
        if FaceColor = clNone then
          FaceColor := clWindowFrame;

        if FrameColor = clNone then
          FrameColor := clWindowFrame;

        W := W div 2;
        Indent := W div 2;

        if H < W + 2 then H := W + 2;

        Tail := 0;
        if Style = sctsExArrow then
        begin
          if H < W + 4 then H := W + 4;

          Tail := H - (W + 3);
          H := W + 2;
        end;

        Dec(P.y);
        Pts6[0].x := P.x;
        Pts6[0].y := P.y;
        Pts6[1].x := P.x - W;
        Pts6[1].y := P.y + W;
        Pts6[2].x := P.x - W;
        Pts6[2].y := P.y + Indent;
        Pts6[3].x := P.x - H;
        Pts6[3].y := P.y + Indent;
        Pts6[4].x := P.x - H;
        Pts6[4].y := P.y - Indent;
        Pts6[5].x := P.x - W;
        Pts6[5].y := P.y - Indent;
        Pts6[6].x := P.x - W;
        Pts6[6].y := P.y - W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          Pen.Color   := FrameColor;

          Polygon(Pts6);

          if Style = sctsExArrow then
          begin
            Inc(H, 2);

            Pts3[0].x := P.x - H;
            Pts3[0].y := P.y - Indent;
            Pts3[1].x := P.x - H;
            Pts3[1].y := P.y + Indent;
            Pts3[2].x := P.x - (H + Tail);
            Pts3[2].y := P.y + Indent;
            Pts3[3].x := P.x - (H + Tail);
            Pts3[3].y := P.y - Indent;

            Polygon(Pts3);
          end;
        end;
      end;
    end;
  end;
end;

procedure scDrawRightSlider(ACanvas: TCanvas; P: TPoint; W, H: Integer;
  Style: TSCThumbStyle; Blind: Boolean; FrameColor: TColor; FaceColor: TColor);
var
  R, R2: TRect;
  Pts1: array[0..4] of TPoint;
  Pts2: array[0..2] of TPoint;
  Pts3: array[0..3] of TPoint;
  Pts6: array[0..6] of TPoint;
  Indent, Tail: Integer;
begin
  if (H > 0) and (W > 0) and (ACanvas <> nil) then
  begin
    case Style of
      sctsNew:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        if FrameColor = clNone then
          FrameColor := clHighlight;

        W := W div 2;

        if H < W then H := W;

        if Blind then
        begin
          with ACanvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := FaceColor;
            Pen.Mode    := pmCopy;
            Pen.Style   := psSolid;

            R := Rect(P.x, P.y - W, P.x + H, P.y + W);
            Dec(R.Right);
            InflateRect(R, 0, -1);

            FillRect(R);

            InflateRect(R, 0, 1);

            Pen.Color   := GetBtnShadowOf(FaceColor);
            MoveTo(R.Left + 1,  R.Top);
            LineTo(R.Right, R.Top);

            MoveTo(R.Left, R.Top + 1);
            LineTo(R.Left, R.Bottom);


            Pen.Color := Get3DDkShadowOf(FaceColor);
            MoveTo(R.Right, R.Top + 1);
            LineTo(R.Right, R.Bottom);

            MoveTo(R.Left + 1,  R.Bottom);
            LineTo(R.Right, R.Bottom);


            InflateRect(R, -1, -1);
            Inc(R.Right);

            R2 := R;
            Inc(R2.Bottom);
            scFrame3D(ACanvas, R2, GetBtnHighlightOf(FaceColor),
              GetBtnShadowOf(FaceColor), 1, 0);

            Dec(R2.Bottom);
            Pen.Color := BlendedColor(FaceColor, 48, 48, 48, False);
            MoveTo(R2.Left,  R2.Bottom);
            LineTo(R2.Right, R2.Bottom);

            R2 := R;
            R2.Right := R2.Left + 3;

            Brush.Color := BlendedColor(FrameColor, 24, 24, 24, True);
            FillRect(R2);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, False);
            MoveTo(R2.Left,  R2.Bottom);
            LineTo(R2.Right, R2.Bottom);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, True);
            MoveTo(R2.Left,  R2.Top);
            LineTo(R2.Right, R2.Top);

            R2 := R;
            R2.Left := R2.Right - 3;

            Brush.Color := FrameColor;
            FillRect(R2);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, False);
            MoveTo(R2.Left,  R2.Bottom);
            LineTo(R2.Right, R2.Bottom);

            Pen.Color := BlendedColor(FrameColor, 42, 36, 16, True);
            MoveTo(R2.Left,  R2.Top);
            LineTo(R2.Right, R2.Top);
          end;

          Exit;
        end;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          // Brush.Color := clBtnFace;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          // Pen.Color   := clBtnShadow;
          Pen.Color   := GetBtnShadowOf(FaceColor);

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x + W;
          Pts1[1].y := P.y + W;
          Pts1[2].x := P.x + H;
          Pts1[2].y := P.y + W;
          Pts1[3].x := P.x + H;
          Pts1[3].y := P.y - W;
          Pts1[4].x := P.x + W;
          Pts1[4].y := P.y - W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          // Pen.Color   := clBtnShadow;
          Pen.Color := GetBtnShadowOf(FaceColor);
          Pts3[0].x := P.x + 1;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x + W;
          Pts3[1].y := P.y + W - 1;
          Pts3[2].x := P.x + H - 1;
          Pts3[2].y := P.y + W - 1;
          Pts3[3].x := P.x + H - 1;
          Pts3[3].y := P.y - W;
          PolyLine(Pts3);

          // Pen.Color   := clBtnHighlight;
          Pen.Color := GetBtnHighlightOf(FaceColor);
          Pts2[0].x := P.x + 3;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x + W + 2;
          Pts2[1].y := P.y - W + 1;
          Pts2[2].x := P.x + H - 1;
          Pts2[2].y := P.y - W + 1;
          PolyLine(Pts2);

          // Pen.Color   := BlendedColor(clBtnFace, 48, 48, 48, False);
          Pen.Color   := BlendedColor(FaceColor, 48, 48, 48, False);
          Pts2[0].x := P.x + 2;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x + W;
          Pts2[1].y := P.y + W - 2;
          Pts2[2].x := P.x + H - 1;
          Pts2[2].y := P.y + W - 2;
          PolyLine(Pts2);

          Pen.Color   := FrameColor;
          Pts2[0].x := P.x + W;
          Pts2[0].y := P.y - W + 1;
          Pts2[1].x := P.x + 1;
          Pts2[1].y := P.y;
          Pts2[2].x := P.x + W + 1;
          Pts2[2].y := P.y + W;
          PolyLine(Pts2);

          Pen.Color   := FrameColor;
          Pts2[0].x := P.x + W + 1;
          Pts2[0].y := P.y - W + 1;
          Pts2[1].x := P.x + 2;
          Pts2[1].y := P.y;
          Pts2[2].x := P.x + W + 2;
          Pts2[2].y := P.y + W;
          PolyLine(Pts2);

          Pen.Color   := BlendedColor(FrameColor, 42, 36, 16, True);
          MoveTo(P.x + W, P.y - W + 1);
          LineTo(P.x,     P.y + 1);

          Pen.Color   := FrameColor;
          MoveTo(P.x + H - 3, P.y + W - 1);
          LineTo(P.x + H - 3, P.y - W);
          MoveTo(P.x + H - 2, P.y + W - 1);
          LineTo(P.x + H - 2, P.y - W);
          MoveTo(P.x + H - 1, P.y + W - 1);
          LineTo(P.x + H - 1, P.y - W);

          Pen.Color   := BlendedColor(FrameColor, 42, 36, 16, True);
          MoveTo(P.x + H - 3, P.y - W + 1);
          LineTo(P.x + H,     P.y - W + 1);

          Pen.Color   := BlendedColor(FrameColor, 42, 36, 16, False);
          MoveTo(P.x + H - 3, P.y + W - 1);
          LineTo(P.x + H,     P.y + W - 1);

          // Pen.Color   := cl3DDkShadow;
          Pen.Color := Get3DDkShadowOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x + W;
          Pts3[1].y := P.y + W;
          Pts3[2].x := P.x + H;
          Pts3[2].y := P.y + W;
          Pts3[3].x := P.x + H;
          Pts3[3].y := P.y - W - 1;
          PolyLine(Pts3);

          // Pen.Color   := clBtnFace;
          Pen.Color := FaceColor;
          MoveTo(P.x + H, P.y - W);
          LineTo(P.x + H, P.y - W + 1);

          // Pen.Color   := clBtnFace;
          Pen.Color := FaceColor;
          MoveTo(P.x + H, P.y + W);
          LineTo(P.x + H, P.y + W - 1);
        end;
      end;
      sctsWindows:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        W := W div 2;

        if H < W then H := W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          // Pen.Color   := clBtnFace;
          Pen.Color   := FaceColor;

          if Blind then
          begin
            R := Rect(P.x, P.y - W, P.x + H, P.y + W + 1);

            FillRect(R);

            scFrame3D(ACanvas, R, GetBtnHighlightOf(FaceColor),
              Get3DDkShadowOf(FaceColor), 1, 0);
            scFrame3D(ACanvas, R, FaceColor, GetBtnShadowOf(FaceColor), 1, 0);

            Exit;
          end;

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x + W;
          Pts1[1].y := P.y - W;
          Pts1[2].x := P.x + H;
          Pts1[2].y := P.y - W;
          Pts1[3].x := P.x + H;
          Pts1[3].y := P.y + W;
          Pts1[4].x := P.x + W;
          Pts1[4].y := P.y + W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          // Pen.Color   := clBtnShadow;
          Pen.Color := GetBtnShadowOf(FaceColor);
          Pts3[0].x := P.x + 1;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x + W;
          Pts3[1].y := P.y + W - 1;
          Pts3[2].x := P.x + H - 1;
          Pts3[2].y := P.y + W - 1;
          Pts3[3].x := P.x + H - 1;
          Pts3[3].y := P.y - W;
          PolyLine(Pts3);

          // Pen.Color   := clBtnHighlight;
          Pen.Color := GetBtnHighlightOf(FaceColor);
          Pts2[0].x := P.x;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x + W;
          Pts2[1].y := P.y - W;
          Pts2[2].x := P.x + H;
          Pts2[2].y := P.y - W;
          PolyLine(Pts2);

          // Pen.Color   := cl3DDkShadow;
          Pen.Color := Get3DDkShadowOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x + W;
          Pts3[1].y := P.y + W;
          Pts3[2].x := P.x + H;
          Pts3[2].y := P.y + W;
          Pts3[3].x := P.x + H;
          Pts3[3].y := P.y - W - 1;
          PolyLine(Pts3);
        end;
      end;
      sctsMetal:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        W := W div 2;

        if H < W then H := W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;

          if Blind then
          begin
            R := Rect(P.x, P.y - W, P.x + H, P.y + W + 1);

            FillRect(R);

            scFrame3D(ACanvas, R, GetBtnShadowOf(FaceColor), GetBtnShadowOf(FaceColor), 1, 0);
            scFrame3D(ACanvas, R, SCCommon.scBlendColor(FaceColor, 64), FaceColor, 1, 0);

            Exit;
          end;

          Pen.Color := GetBtnShadowOf(FaceColor);

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x + W;
          Pts1[1].y := P.y - W;
          Pts1[2].x := P.x + H;
          Pts1[2].y := P.y - W;
          Pts1[3].x := P.x + H;
          Pts1[3].y := P.y + W;
          Pts1[4].x := P.x + W;
          Pts1[4].y := P.y + W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          Pen.Color := SCCommon.scBlendColor(FaceColor, 64);
          Pts2[0].x := P.x + 1;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x + W;
          Pts2[1].y := P.y - W + 1;
          Pts2[2].x := P.x + H - 1;
          Pts2[2].y := P.y - W + 1;
          PolyLine(Pts2);
        end;
      end;
      sctsPSNew:
      begin
        if FaceColor = clNone then
          FaceColor := clBtnFace;

        W := W div 2;

        if H < W then H := W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          Pen.Color   := Get3DDkShadowOf(FaceColor);

          if Blind then
          begin
            R := Rect(P.x, P.y - W, P.x + H, P.y + W + 1);

            FillRect(R);

            scFrame3D(ACanvas, R, Get3DDkShadowOf(FaceColor), Get3DDkShadowOf(FaceColor), 1, 0);
            scFrame3D(ACanvas, R, GetBtnHighlightOf(FaceColor), FaceColor, 1, 0);

            Exit;
          end;

          Pts1[0].x := P.x;
          Pts1[0].y := P.y;
          Pts1[1].x := P.x + W;
          Pts1[1].y := P.y - W;
          Pts1[2].x := P.x + H;
          Pts1[2].y := P.y - W;
          Pts1[3].x := P.x + H;
          Pts1[3].y := P.y + W;
          Pts1[4].x := P.x + W;
          Pts1[4].y := P.y + W;
          Polygon(Pts1);

          Brush.Style := bsClear;

          Pen.Color := GetBtnHighlightOf(FaceColor);
          Pts2[0].x := P.x + 1;
          Pts2[0].y := P.y;
          Pts2[1].x := P.x + W;
          Pts2[1].y := P.y - W + 1;
          Pts2[2].x := P.x + H - 1;
          Pts2[2].y := P.y - W + 1;
          PolyLine(Pts2);

          Pen.Color := Get3DDkShadowOf(FaceColor);
          Pts3[0].x := P.x;
          Pts3[0].y := P.y;
          Pts3[1].x := P.x + W;
          Pts3[1].y := P.y + W;
          Pts3[2].x := P.x + H;
          Pts3[2].y := P.y + W;
          Pts3[3].x := P.x + H;
          Pts3[3].y := P.y - W - 1;
          PolyLine(Pts3);
        end;
      end;
      sctsMac, sctsPS:
      begin
        if FaceColor = clNone then
        begin
          if Style = sctsPS then
            FaceColor := clBtnFace
          else FaceColor := clWindowFrame;
        end;

        if (Style = sctsPS) and (FrameColor = clNone) then
          FrameColor := clWindowFrame;

        W := W div 2;

        Dec(P.y);
        Pts2[0].x := P.x;
        Pts2[0].y := P.y;
        Pts2[1].x := P.x + H;
        Pts2[1].y := P.y + W;
        Pts2[2].x := P.x + H;
        Pts2[2].y := P.y - W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          
          if Style = sctsPS then
            Pen.Color := FrameColor
          else Pen.Color := FaceColor;

          Polygon(Pts2);
        end;
      end;
      sctsArrow, sctsExArrow:
      begin
        if FaceColor = clNone then
          FaceColor := clWindowFrame;

        if FrameColor = clNone then
          FrameColor := clWindowFrame;

        W := W div 2;
        Indent := W div 2;

        if H < W + 2 then H := W + 2;

        Tail := 0;
        if Style = sctsExArrow then
        begin
          if H < W + 4 then H := W + 4;

          Tail := H - (W + 3);
          H := W + 2;
        end;

        Dec(P.y);
        Pts6[0].x := P.x;
        Pts6[0].y := P.y;
        Pts6[1].x := P.x + W;
        Pts6[1].y := P.y + W;
        Pts6[2].x := P.x + W;
        Pts6[2].y := P.y + Indent;
        Pts6[3].x := P.x + H;
        Pts6[3].y := P.y + Indent;
        Pts6[4].x := P.x + H;
        Pts6[4].y := P.y - Indent;
        Pts6[5].x := P.x + W;
        Pts6[5].y := P.y - Indent;
        Pts6[6].x := P.x + W;
        Pts6[6].y := P.y - W;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FaceColor;
          Pen.Mode    := pmCopy;
          Pen.Style   := psSolid;
          Pen.Color   := FrameColor;

          Polygon(Pts6);

          if Style = sctsExArrow then
          begin
            Inc(H, 2);

            Pts3[0].x := P.x + H;
            Pts3[0].y := P.y - Indent;
            Pts3[1].x := P.x + H;
            Pts3[1].y := P.y + Indent;
            Pts3[2].x := P.x + H + Tail;
            Pts3[2].y := P.y + Indent;
            Pts3[3].x := P.x + H + Tail;
            Pts3[3].y := P.y - Indent;

            Polygon(Pts3);
          end;
        end;
      end;
    end;
  end;
end;


procedure scDrawXPButton(C: TCanvas; R: TRect; Cl, BkCl: TColor;
  IsDown, IsHot: Boolean);
var
  X, I: Integer;
  R1: TRect;
  FCl, C1: TColor;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  FCl := Cl;
  if IsDown then
    FCl := SCCommon.scBlendColor(FCl, -24)
  else
  if IsHot then
    FCl := SCCommon.scBlendColor(FCl, 16);

  R1 := R;
  with C do
  begin
    Brush.Style := bsSolid;
    Brush.Color := FCl;
    FillRect(R1);

    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
    Pen.Width := 1;

    C1 := BkCl;
    if BkCl = clNone then
      C1 := GetBtnHighlightOf(Cl);
      
    scFrame3D(C, R1, C1, C1, 1, 0);

    C1 := SCCommon.scBlendColor(Cl, 32);
    scFrame3D(C, R1, C1, C1, 1, 0);
    InflateRect(R1, 1, 1);

    C1 := SCCommon.scBlendColor(Cl, -16);
    scFrame3D(C, R1, C1, C1, 1, 0);

    if IsDown then
      C1 := SCCommon.scBlendColor(FCl, -24)
    else
      C1 := SCCommon.scBlendColor(FCl, 16);

    Pen.Color := C1;
    MoveTo(R1.Left,  R1.Top);
    LineTo(R1.Right - 2, R1.Top);

    if IsDown then
    begin
      Pen.Color := SCCommon.scBlendColor(C1, 12);

      if R1.Top + 1 < R1.Bottom then
      begin
        MoveTo(R1.Left,  R1.Top + 1);
        LineTo(R1.Right - 2, R1.Top + 1);

        MoveTo(R1.Left,  R1.Top + 2);
        LineTo(R1.Right - 2, R1.Top + 2);
      end;  
    end;

    for I := 0 to 2 do
    begin
      Pen.Color := SCCommon.scBlendColor(FCl, -12 + 4*I);

      X := R1.Right - 2*I;
      if X < R1.Left then Break;

      MoveTo(X, R1.Top + 1);
      LineTo(X, R1.Bottom);

      Dec(X);
      if X < R1.Left then Break;

      MoveTo(X, R1.Top + 1);
      LineTo(X, R1.Bottom);
    end;

    if IsDown then
      for I := 0 to 2 do
      begin
        Pen.Color := SCCommon.scBlendColor(FCl, -18 + 6*I);

        X := R1.Left + 3*I;
        if X > R1.Right then Break;

        MoveTo(X, R1.Top + 1);
        LineTo(X, R1.Bottom);

        Inc(X);
        if X > R1.Right then Break;

        MoveTo(X, R1.Top + 1);
        LineTo(X, R1.Bottom);

        Inc(X);
        if X > R1.Right then Break;

        MoveTo(X, R1.Top + 1);
        LineTo(X, R1.Bottom);
      end;
  end;

  C1 := GetBtnHighlightOf(Cl);
  C1 := SCCommon.scBlendColor(C1, -16);

  R1 := R;
  scFrame3D(C, R1, C1, C1, 1, 0);
end;

procedure scDrawXPThumb(C: TCanvas; R: TRect; Cl: TColor;
  IsDown, IsHot: Boolean);
var
  X, I: Integer;
  R1: TRect;
  FCl, C1, C2: TColor;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  FCl := Cl;
  if IsDown then
    FCl := SCCommon.scBlendColor(FCl, -24)
  else
  if IsHot then
    FCl := SCCommon.scBlendColor(FCl, 16);

  R1 := R;
  with C do
  begin
    Brush.Style := bsSolid;
    Brush.Color := FCl;
    FillRect(R1);

    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
    Pen.Width := 1;

    C1 := GetBtnHighlightOf(Cl);
    scFrame3D(C, R1, C1, C1, 1, 0);
    scFrame3D(C, R1, C1, C1, 1, 0);

    C1 := SCCommon.scBlendColor(Cl, 32);
    scFrame3D(C, R1, C1, C1, 1, 0);
    InflateRect(R1, 1, 1);

    C1 := SCCommon.scBlendColor(Cl, -16);
    scFrame3D(C, R1, C1, C1, 1, 2);

    if IsDown then
      C1 := SCCommon.scBlendColor(FCl, -24)
    else
      C1 := SCCommon.scBlendColor(FCl, 16);

    Pen.Color := C1;
    MoveTo(R1.Left,  R1.Top);
    LineTo(R1.Right - 2, R1.Top);

    if IsDown then
    begin
      Pen.Color := SCCommon.scBlendColor(C1, 12);

      if R1.Top + 1 < R1.Bottom then
      begin
        MoveTo(R1.Left,  R1.Top + 1);
        LineTo(R1.Right - 2, R1.Top + 1);

        MoveTo(R1.Left,  R1.Top + 2);
        LineTo(R1.Right - 2, R1.Top + 2);
      end;  
    end;

    for I := 0 to 2 do
    begin
      Pen.Color := SCCommon.scBlendColor(FCl, -12 + 4*I);

      X := R1.Right - 2*I;
      if X < R1.Left then Break;

      MoveTo(X, R1.Top + 1);
      LineTo(X, R1.Bottom);

      Dec(X);
      if X < R1.Left then Break;

      MoveTo(X, R1.Top + 1);
      LineTo(X, R1.Bottom);
    end;

    if IsDown then
      for I := 0 to 2 do
      begin
        Pen.Color := SCCommon.scBlendColor(FCl, -18 + 6*I);

        X := R1.Left + 3*I;
        if X > R1.Right then Break;

        MoveTo(X, R1.Top + 1);
        LineTo(X, R1.Bottom);

        Inc(X);
        if X > R1.Right then Break;

        MoveTo(X, R1.Top + 1);
        LineTo(X, R1.Bottom);

        Inc(X);
        if X > R1.Right then Break;

        MoveTo(X, R1.Top + 1);
        LineTo(X, R1.Bottom);
      end;
  end;

  C1 := GetBtnHighlightOf(Cl);
  C1 := SCCommon.scBlendColor(C1, -16);

  C2 := GetBtnShadowOf(Cl);
  C2 := SCCommon.scBlendColor(C2, 16);

  R1 := R;
  scFrame3D(C, R1, C1, C2, 1, 4);

  with C do
  begin
    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
    Pen.Width := 1;

    Pen.Color := C1;
    MoveTo(R.Left, R.Top + 1);
    LineTo(R.Left, R.Bottom - 1);

    C1 := GetBtnHighlightOf(Cl);
    Pen.Color := C1;

    MoveTo(R.Left,  R.Top);
    LineTo(R.Right, R.Top);

    Pen.Color := C2;
    MoveTo(R.Left + 1, R.Bottom - 2);
    LineTo(R.Left + 3, R.Bottom);

    Pen.Color := C1;
    MoveTo(R.Right - 3, R.Top);
    LineTo(R.Right, R.Top + 3);
  end;
end;


// Shotcut methods

function scShortCut(Key: Word; Shift: TShiftState): TShortCut;
begin
  Result := 0;
  if WordRec(Key).Hi <> 0 then Exit;
  Result := Key;
  if ssShift in Shift then Inc(Result, scShift);
  if ssCtrl in Shift then Inc(Result, scCtrl);
  if ssAlt in Shift then Inc(Result, scAlt);
end;

procedure scShortCutToKey(ShortCut: TShortCut; var Key: Word; var Shift: TShiftState);
begin
  Key := ShortCut and not (scShift + scCtrl + scAlt);
  Shift := [];
  if ShortCut and scShift <> 0 then Include(Shift, ssShift);
  if ShortCut and scCtrl <> 0 then Include(Shift, ssCtrl);
  if ShortCut and scAlt <> 0 then Include(Shift, ssAlt);
end;

type
  TSCKeyCap = (sckcBkSp, sckcTab, sckcEsc, sckcEnter, sckcSpace, sckcPgUp,
    sckcPgDn, sckcEnd, sckcHome, sckcLeft, sckcUp, sckcRight, sckcDown, sckcIns,
    sckcDel, sckcShift, sckcCtrl, sckcAlt);

var
  SCKeyCaps: array[TSCKeyCap] of string = (
    scskBkSp, scskTab, scskEsc,  scskEnter, scskSpace, scskPgUp,
    scskPgDn, scskEnd, scskHome, scskLeft,  scskUp,    scskRight,
    scskDown, scskIns, scskDel,  scskShift, scskCtrl,  scskAlt);

function scGetSpecialKeyName(ShortCut: TShortCut): string;
var
  ScanCode: Integer;
  KeyName: array[0..255] of Char;
begin
  Result := '';
  ScanCode := MapVirtualKey(WordRec(ShortCut).Lo, 0) shl 16;
  if ScanCode <> 0 then
  begin
    GetKeyNameText(ScanCode, KeyName, SizeOf(KeyName));
    Result := KeyName;
  end;
end;

function scTextToShortCut(Text: string): TShortCut;

  function CompareFront(var Text: string; const Front: string): Boolean;
  begin
    Result := False;
    if (Length(Text) >= Length(Front)) and
      (AnsiStrLIComp(PChar(Text), PChar(Front), Length(Front)) = 0) then
    begin
      Result := True;
      Delete(Text, 1, Length(Front));
    end;
  end;

var
  Key: TShortCut;
  Shift: TShortCut;
begin
  Result := 0;
  Shift := 0;
  while True do
  begin
    if CompareFront(Text, SCKeyCaps[sckcShift]) then Shift := Shift or scShift
    else if CompareFront(Text, '^') then Shift := Shift or scCtrl
    else if CompareFront(Text, SCKeyCaps[sckcCtrl]) then Shift := Shift or scCtrl
    else if CompareFront(Text, SCKeyCaps[sckcAlt]) then Shift := Shift or scAlt
    else Break;
  end;
  if Text = '' then Exit;
  for Key := $08 to $255 do { Copy range from table in ShortCutToText }
    if AnsiCompareText(Text, scShortCutToText(Key)) = 0 then
    begin
      Result := Key or Shift;
      Exit;
    end;
end;

function scShortCutToText(ShortCut: TShortCut): string;
var
  Name: string;
begin
  case WordRec(ShortCut).Lo of
    $08, $09:
      Name := SCKeyCaps[TSCKeyCap(Ord(sckcBkSp) + WordRec(ShortCut).Lo - $08)];
    $0D: Name := SCKeyCaps[sckcEnter];
    $1B: Name := SCKeyCaps[sckcEsc];
    $20..$28:
      Name := SCKeyCaps[TSCKeyCap(Ord(sckcSpace) + WordRec(ShortCut).Lo - $20)];
    $2D..$2E:
      Name := SCKeyCaps[TSCKeyCap(Ord(sckcIns) + WordRec(ShortCut).Lo - $2D)];
    $30..$39: Name := Chr(WordRec(ShortCut).Lo - $30 + Ord('0'));
    $41..$5A: Name := Chr(WordRec(ShortCut).Lo - $41 + Ord('A'));
    $60..$69: Name := Chr(WordRec(ShortCut).Lo - $60 + Ord('0'));
    $70..$87: Name := 'F' + IntToStr(WordRec(ShortCut).Lo - $6F);
  else
    Name := scGetSpecialKeyName(ShortCut);
  end;
  if Name <> '' then
  begin
    Result := '';
    if ShortCut and scCtrl <> 0 then Result := Result + SCKeyCaps[sckcCtrl];
    if ShortCut and scShift <> 0 then Result := Result + SCKeyCaps[sckcShift];
    if ShortCut and scAlt <> 0 then Result := Result + SCKeyCaps[sckcAlt];
    Result := Result + Name;
  end
  else Result := '';
end;

function  scShiftStateToKeys(Shift: TShiftState): Word;
begin
  Result := 0;
  if ssShift in Shift then Result := Result or SC_SHIFT;
  if ssCtrl in Shift then Result := Result or SC_CONTROL;
  if ssLeft in Shift then Result := Result or SC_LBUTTON;
  if ssRight in Shift then Result := Result or SC_RBUTTON;
  if ssMiddle in Shift then Result := Result or SC_MBUTTON;
  if ssAlt in Shift then Result := Result or SC_MENU;
end;

function scKeysToShiftState(Keys: Word): TShiftState;
begin
  Result := [];
  if Keys and MK_SHIFT <> 0 then Include(Result, ssShift);
  if Keys and MK_CONTROL <> 0 then Include(Result, ssCtrl);
  if Keys and MK_LBUTTON <> 0 then Include(Result, ssLeft);
  if Keys and MK_RBUTTON <> 0 then Include(Result, ssRight);
  if Keys and MK_MBUTTON <> 0 then Include(Result, ssMiddle);
  if GetKeyState(VK_MENU) < 0 then Include(Result, ssAlt);
end;

function scKeyDataToShiftState(KeyData: Longint): TShiftState;
const
  AltMask = $20000000;
begin
  Result := [];
  if GetKeyState(VK_SHIFT) < 0 then Include(Result, ssShift);
  if GetKeyState(VK_CONTROL) < 0 then Include(Result, ssCtrl);
  if KeyData and AltMask <> 0 then Include(Result, ssAlt);
end;

function scKeyboardStateToShiftState(const KeyboardState: TKeyboardState): TShiftState;
begin
  Result := [];
  if KeyboardState[VK_SHIFT] and $80 <> 0 then Include(Result, ssShift);
  if KeyboardState[VK_CONTROL] and $80 <> 0 then Include(Result, ssCtrl);
  if KeyboardState[VK_MENU] and $80 <> 0 then Include(Result, ssAlt);
  if KeyboardState[VK_LBUTTON] and $80 <> 0 then Include(Result, ssLeft);
  if KeyboardState[VK_RBUTTON] and $80 <> 0 then Include(Result, ssRight);
  if KeyboardState[VK_MBUTTON] and $80 <> 0 then Include(Result, ssMiddle);
end;

function scDblClickTime: DWord;
begin
  Result := GetDoubleClickTime;
end;

function scKeyBoardDelay: Integer;
var
  D: DWord;
begin
  SystemParametersInfo(SPI_GETKEYBOARDDELAY, 0, @D, 0);
  Result := 200*(D + 1);
end;

function scKeyBoardSpeed: Integer;
var
  D: DWord;
begin
  SystemParametersInfo(SPI_GETKEYBOARDSPEED, 0, @D, 0);
  Result := Round(1000 / (2.3*(D + 1)));
end;

procedure scKillMessage(Wnd: HWnd; Msg: Integer);
var
  Ms: TMsg;
begin
  Ms.Message := 0;
  if PeekMessage(Ms, Wnd, Msg, Msg, PM_REMOVE) and (Ms.Message = WM_QUIT) then
    PostQuitMessage(Ms.Wparam);
end;

function scVertScrollbarWidth: Integer;
begin
  Result := GetSystemMetrics(SM_CXVSCROLL);
end;

function scVertScrollButtonHeight: Integer;
begin
  Result := GetSystemMetrics(SM_CYVSCROLL);
end;

function scHorzScrollbarHeight: Integer;
begin
  Result := GetSystemMetrics(SM_CYHSCROLL);
end;

function scHorzScrollButtonWidth: Integer;
begin
  Result := GetSystemMetrics(SM_CXHSCROLL);
end;

procedure scApplicationCancelHint;
begin
  Application.CancelHint;
end;

function scApplicationHintHidePause: Integer;
begin
  Result := Application.HintHidePause;
end;

function scComponentToString(Component: TComponent): string;
var
  BinStream:TMemoryStream;
  StrStream: TStringStream;
  s: string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result := StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;

function scStringToComponent(Value: string): TComponent;
var
  StrStream:TStringStream;
  BinStream: TMemoryStream;
begin
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result := BinStream.ReadComponent(nil);
    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;

{ TSCIntList }

function TSCIntList.Add(Item: Integer): Integer;
begin
  Result := FCount;
  if Result = FCapacity then
    Grow;

  FList^[Result] := Item;
  Inc(FCount);

  Notify(Result, sclnAdded);
end;

procedure TSCIntList.Clear;
begin
  SetCount(0);
  SetCapacity(0);
end;

procedure TSCIntList.Delete(Index: Integer);
begin
  if (Index > -1) and (Index < FCount) then
  begin
    Dec(FCount);
    if Index < FCount then
      System.Move(FList^[Index + 1], FList^[Index],
        (FCount - Index) * SizeOf(Integer));
    Notify(Index, sclnDeleted);
  end;
end;

destructor TSCIntList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TSCIntList.Exchange(Index1, Index2: Integer);
var
  Item: Integer;
begin
  if (Index1 > -1) and (Index1 < FCount) and
    (Index2 > -1) and (Index2 < FCount) then
  begin
    Item := FList^[Index1];
    FList^[Index1] := FList^[Index2];
    FList^[Index2] := Item;
  end;
end;

function TSCIntList.Expand: TSCIntList;
begin
  if FCount = FCapacity then
    Grow;
  Result := Self;
end;

function TSCIntList.Extract(Index: Integer): Integer;
begin
  Result := 0;
  if (Index > -1) and (Index < FCount) then
  begin
    Delete(Index);
    Notify(Index, sclnExtracted);
  end;
end;

function TSCIntList.Get(Index: Integer): Integer;
begin
  Result := 0;
  if (Index > -1) and (Index < FCount) then
    Result := FList^[Index];
end;

procedure TSCIntList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then
    Delta := FCapacity div 4
  else
    if FCapacity > 8 then
      Delta := 16
    else
      Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TSCIntList.IndexOf(Item: Integer): Integer;
begin
  Result := 0;
  while (Result < FCount) and (FList^[Result] <> Item) do
    Inc(Result);
  if Result = FCount then
    Result := -1;
end;

procedure TSCIntList.Insert(Index, Item: Integer);
begin
  if (Index > -1) and (Index <= FCount) then
  begin
    if FCount = FCapacity then
      Grow;

    if Index < FCount then
      System.Move(FList^[Index], FList^[Index + 1],
        (FCount - Index) * SizeOf(Integer));

    FList^[Index] := Item;
    Inc(FCount);

    Notify(Index, sclnAdded);
  end;
end;

procedure TSCIntList.Move(CurIndex, NewIndex: Integer);
var
  Item: Integer;
begin
  if (CurIndex <> NewIndex) and
    (CurIndex > 0) and (CurIndex < FCount) and
    (NewIndex > 0) and (NewIndex < FCount) then
  begin
    Item := Get(CurIndex);
    Delete(CurIndex);

    Insert(NewIndex, Item);
  end;
end;

procedure TSCIntList.Notify(Index: Integer; Action: TSCListNotification);
begin
end;

procedure TSCIntList.Put(Index, Item: Integer);
begin
  if (Index > -1) and (Index < FCount) then
  begin
    FList^[Index] := Item;

    Notify(Index, sclnDeleted);
    Notify(Index, sclnAdded);
  end;    
end;

function TSCIntList.Remove(Item: Integer; All: Boolean): Integer;
var
  I: Integer;
begin
  I := 0;
  while I < FCount do
  begin
    if FList^[I] = Item then
    begin
      Delete(I);
      if not All then
        Break;
    end;

    Inc(I);
  end;
  Result := FCount;
end;

procedure TSCIntList.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
    Exit;

  if NewCapacity <> FCapacity then
  begin
    ReallocMem(FList, NewCapacity * SizeOf(Integer));
    FCapacity := NewCapacity;
  end;
end;

procedure TSCIntList.SetCount(NewCount: Integer);
var
  I: Integer;
begin
  if (NewCount < 0) or (NewCount > MaxListSize) then
    Exit;

  if NewCount > FCapacity then
    SetCapacity(NewCount);

  if NewCount > FCount then
    FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(Integer), 0)
  else
    for I := FCount - 1 downto NewCount do
      Delete(I);
  FCount := NewCount;
end;

function StrListAnsiCompare(List: TSCStringList; Index1, Index2: Integer): Integer;
var
  Item1, Item2: PSCStringItem;
begin
  Item1 := List.FList[Index1];
  Item2 := List.FList[Index2];

  Result := AnsiCompareText(Item1^.FString, Item2^.FString);
end;

{ TSCStringList }

function TSCStringList.Add(const S: string): Integer;
begin
  if not Sorted then
    Result := Count
  else
    if Find(S, Result, False) then
      case Duplicates of
        scdpIgnore: Exit;
        scdpError: Error(SSCDuplicateString, 0);
      end;
  InsertItem(Result, S);
end;

procedure TSCStringList.AddStrings(Strings: TStrings);
var
  I, J, Indx: Integer;
  IsMacList: Boolean;
  Item: PSCStringItem;
begin
  Changing;
  BeginUpdate;
  try
    IsMacList := Strings is TSCStringList;

    for I := 0 to Strings.Count - 1 do
    begin
      Indx := AddObject(Strings[I], Strings.Objects[I]);

      if (Indx > -1) and IsMacList then
      begin
        Item := FList[I];
        for J := Low(Item^.FData) to High(Item^.FData) do
          Item^.FData[J] := TSCStringList(Strings).Data[I, J];
      end;
    end;
  finally
    EndUpdate;
  end;
  Changed;
end;

procedure TSCStringList.Assign(Source: TPersistent);
begin
  if Source is TStrings then
  begin
    Changing;
    BeginUpdate;
    try
      Clear;
      AddStrings(TStrings(Source));
    finally
      EndUpdate;
    end;
    Changed;
  end else
    inherited Assign(Source);
end;

procedure TSCStringList.Changed;
begin
  if not (FUpdating or FDestroying) and Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TSCStringList.Changing;
begin
  if not (FUpdating or FDestroying) and Assigned(FOnChanging) then
    FOnChanging(Self);
end;

procedure TSCStringList.Clear;
var
  I: Integer;
  Item: PSCStringItem;
begin
  if Count > 0 then
  begin
    Changing;
    BeginUpdate;
    try
      for I := FList.Count-1 downto 0 do
      begin
        Item := FList[I];
        if Item <> nil then
          Dispose(Item);
      end;

      FList.Clear;
    finally
      EndUpdate;
    end;
    Changed;
  end;
end;

function TSCStringList.CompletedText(const S: String;
  CaseSensitive: Boolean): Integer;
var
  I, Ln: Integer;
  Str, SubStr: String;
begin
  Result := -1;
  if not FUpdating and (Count > 0) and (S <> '') then
  begin
    Str := S;
    if not CaseSensitive then
      Str := AnsiLowerCase(Str);

    Ln := Length(Str);
    for I := 0 to Count-1 do
    begin
      SubStr := Copy(Get(I), 1, Ln);
      if not CaseSensitive then
        SubStr := AnsiLowerCase(SubStr);

      if Str = SubStr then
      begin
        Result := I;
        Exit;
      end;
    end;
  end;
end;

constructor TSCStringList.Create;
var
  I: Integer;
begin
  inherited Create;
  FList := TList.Create;
  {$IFDEF SC_CBUILDER}
  for I := Low(InitialDatas) to High(InitialDatas) do
    InitialDatas[I] := 0;
  {$ELSE}
  for I := Low(FInitialDatas) to High(FInitialDatas) do
    FInitialDatas[I] := 0;
  {$ENDIF}
end;

procedure TSCStringList.CustomSort(Compare: TSCStringsSortCompare);
begin
  if not Sorted and (FList.Count > 1) then
  begin
    Changing;
    BeginUpdate;
    try
      QuickSort(0, FList.Count - 1, Compare);
    finally
      EndUpdate;
    end;
    Changed;
  end;
end;

procedure TSCStringList.Delete(Index: Integer);
begin
  RemoveItem(Index);
end;

destructor TSCStringList.Destroy;
begin
  Destroying;

  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TSCStringList.Destroying;
begin
  FDestroying := True;

  FOnChanging := nil;
  FOnChange   := nil;
  FOnStartUpdate := nil;
  FOnEndUpdate   := nil;
end;

procedure TSCStringList.DoUpdated;
begin
  if not (FUpdating or FDestroying) then
  begin
    Updated;
    if Assigned(FOnEndUpdate) then
      FOnEndUpdate(Self);
  end;
end;

procedure TSCStringList.DoUpdating;
begin
  if FUpdating and not FDestroying then
  begin
    Updating;
    if Assigned(FOnStartUpdate) then
      FOnStartUpdate(Self);
  end;
end;

procedure TSCStringList.Exchange(Index1, Index2: Integer);
begin
  Changing;
  ExchangeItems(Index1, Index2);
  Changed;
end;

procedure TSCStringList.ExchangeItems(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;

function TSCStringList.Find(const S: string; var Index: Integer;
  CaseSensitive: Boolean): Boolean;
var
  Item: PSCStringItem;
  L, H, I, C: Integer;
begin
  Result := False;

  Index := -1;
  if not FSorted then
  begin
    for I := 0 to FList.Count-1 do
    begin
      Item := FList[I];

      if CaseSensitive then
        C := AnsiCompareStr(Item^.FString, S)
      else
        C := AnsiCompareText(Item^.FString, S);

      if C = 0 then
      begin
        Result := True;
        Index := I;

        Break;
      end;
    end;
  end else
  begin
    L := 0;
    H := FList.Count - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;

      Item := FList[I];

      if CaseSensitive then
        C := AnsiCompareStr(Item^.FString, S)
      else
        C := AnsiCompareText(Item^.FString, S);

      if C < 0 then L := I + 1 else
      begin
        H := I - 1;
        if C = 0 then
        begin
          Result := True;
          if Duplicates <> scdpAccept then L := I;
        end;
      end;
    end;
    Index := L;
  end;
end;

function TSCStringList.FindText(const S: String): Integer;
var
  SubStr: String;
  I, J: Integer;
begin
  Result := -1;
  if not FUpdating and (Count > 0) then
    for I := 1 to Length(S) do
    begin
      SubStr := Copy(S, 1, I);
      for J := 0 to Count-1 do
        if AnsiSameText(SubStr, Copy(Get(J), 1, I)) then
        begin
          Result := J;
          Break;
        end;
    end;
end;

function TSCStringList.Get(Index: Integer): string;
var
  Item: PSCStringItem;
begin
  Item := FList[Index];
  Result := Item^.FString;
end;

function TSCStringList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSCStringList.GetData(Item, Index: Integer): Integer;
var
  ListItem: PSCStringItem;
begin
  ListItem := FList[Item];
  Result := ListItem^.FData[Index];
end;

function TSCStringList.GetObject(Index: Integer): TObject;
var
  Item: PSCStringItem;
begin
  Item := FList[Index];
  Result := Item^.FObject;
end;

function TSCStringList.IndexOf(const S: string): Integer;
begin
  if not Find(S, Result, False) then
    Result := -1;
end;

procedure TSCStringList.Insert(Index: Integer; const S: string);
begin
  if Sorted then Error(SSCSortedListError, 0);
  if (Index < 0) or (Index > FList.Count) then Error(SSCListIndexError, Index);
  InsertItem(Index, S);
end;

procedure TSCStringList.InsertItem(Index: Integer; const S: string);
var
  I, P: Integer;
  S1: String;
  Item: PSCStringItem;
begin
  if Index < 0 then
    Index := 0
  else
  if Index > FList.Count then
    Index := FList.Count;

  Changing;

  BeginUpdate;
  try
    New(Item);
    {$IFDEF SC_CBUILDER}
    for I := Low(Item^.FData) to High(Item^.FData) do
      Item^.FData[I] := InitialDatas[I];
    {$ELSE}
    for I := Low(Item^.FData) to High(Item^.FData) do
      Item^.FData[I] := FInitialDatas[I];
    {$ENDIF}

    P := AnsiPos(#13, S1);
    if P = 0 then
    begin
      Item^.FString := S;
      FList.Insert(Index, Item);
    end else
    begin
      S1 := Copy(S, 1, P - 1);
      if (Length(S1) > 0) and (S1[Length(S1)] = #10) then
        System.Delete(S1, Length(S1), 1);

      Item^.FString := S1;

      S1 := Copy(S, P + 1, Length(S) - P);
      if (Length(S1) > 0) and (S1[1] = #10) then
        System.Delete(S1, 1, 1);

      InsertItem(Index + 1, S1);
    end;
  finally
    EndUpdate;
  end;

  Changed;
end;

procedure TSCStringList.Move(CurIndex, NewIndex: Integer);
begin
  if CurIndex <> NewIndex then
  begin
    BeginUpdate;
    try
      FList.Move(CurIndex, NewIndex);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TSCStringList.Put(Index: Integer; const S: string);
var
  Item: PSCStringItem;
begin
  if Sorted then Error(SSCSortedListError, 0);
  if (Index < 0) or (Index >= FList.Count) then Error(SSCListIndexError, Index);

  Item := FList[Index];

  Changing;
  Item^.FString := S;
  Changed;
end;

procedure TSCStringList.PutObject(Index: Integer; AObject: TObject);
var
  Item: PSCStringItem;
begin
  if (Index < 0) or (Index >= FList.Count) then Error(SSCListIndexError, Index);

  Item := FList[Index];

  Changing;
  Item^.FObject := AObject;
  Changed;
end;

procedure TSCStringList.QuickSort(L, R: Integer; SCompare: TSCStringsSortCompare);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while SCompare(Self, I, P) < 0 do
        Inc(I);
      while SCompare(Self, J, P) > 0 do
        Dec(J);

      if I <= J then
      begin
        ExchangeItems(I, J);
        if P = I then
          P := J
        else
        if P = J then
          P := I;

        Inc(I);
        Dec(J);
      end;
    until I > J;

    if L < J then
      QuickSort(L, J, SCompare);
    L := I;
  until I >= R;
end;

procedure TSCStringList.RemoveItem(Index: Integer);
var
  Item: PSCStringItem;
begin
  Changing;
  Item := FList[Index];
  FList.Delete(Index);

  if Item <> nil then
    Dispose(Item);

  Changed;
end;

procedure TSCStringList.SetData(Item, Index, Value: Integer);
var
  ListItem: PSCStringItem;
begin
  ListItem := FList[Item];

  Changing;
  ListItem^.FData[Index] := Value;
  Changed;
end;

procedure TSCStringList.SetDataInternally(Item, Index, Value: Integer);
var
  ListItem: PSCStringItem;
begin
  ListItem := FList[Item];
  ListItem^.FData[Index] := Value;
end;

procedure TSCStringList.SetInitialDatas(Value: TSCStringDatas);
begin
  FInitialDatas := Value;
end;

procedure TSCStringList.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then Sort;
    FSorted := Value;
  end;
end;

procedure TSCStringList.SetUpdateState(Updating: Boolean);
begin
  if FUpdating <> Updating then
  begin
    FUpdating := Updating;
    if FUpdating then
      DoUpdating
    else
    if not FUpdating then
      DoUpdated;
  end;
end;

procedure TSCStringList.Sort;
begin
  CustomSort(StrListAnsiCompare);
end;

procedure TSCStringList.Updated;
begin
  //
end;

procedure TSCStringList.Updating;
begin
  //
end;

function scIsHex(S: string): Boolean;
begin
  Result := False;
  if Length(S) > 0 then
  begin
    if S[1] <> '$' then S := '$' + S;
    Result := scIsInteger(S);
  end;
end;

function scIsFloat(const S: string): Boolean;
var
  V: Extended;
begin
  Result := scIsFloat(S, V);
end;

function scIsFloat(const S: string; out Value: Extended): Boolean;
begin
  Result := TextToFloat(PChar(S), Value, fvExtended);
end;

function scIsFloat(const S: string; Currency: Boolean): Boolean;
var
  Value: Extended;
begin
  if Currency then
    Result := TextToFloat(PChar(S), Value, fvCurrency)
  else
    Result := TextToFloat(PChar(S), Value, fvExtended);
end;

function scIsFloat2(const S: string; out Value: Extended): Boolean;
var
  E: Integer;
begin
  Val(S, Value, E);
  Result := E = 0;
end;

function scStrToFloatDef(const S: String; Def: Extended): Extended;
var
  E: Integer;
begin
  Val(S, Result, E);
  if E <> 0 then Result := Def;
end;

function scIsInteger(const S: string): Boolean;
var
  V: Integer;
begin
  Result := scIsInteger(S, V);
end;

function scIsInteger(const S: string; out Value: Integer): Boolean;
var
  E: Integer;
begin
  Val(S, Value, E);
  Result := E = 0;
end;

function scIsInt64(const S: string; out Value: Int64): Boolean;
var
  E: Integer;
begin
  Val(S, Value, E);
  Result := E = 0;
end;

function scArrangeDecimalSeperator(S: String; IsCurrency: Boolean; DecimalPlaces: Integer): String;
var
  Str: String;
  DecimalChar: Char;
  P, I, Len: Integer;
begin
  Result := S;

  DecimalChar := {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF} DecimalSeparator;
  // if IsCurrency then DecimalChar := scCurDecimalSeparator;

  P := Pos(DecimalChar, S);

  if P = 0 then
  begin
    if DecimalPlaces > 0 then
      Result := Result + DecimalChar + StringOfChar('0', DecimalPlaces);

    Exit;
  end;

  if DecimalPlaces > 20 then DecimalPlaces := 20;

  Str := Copy(Result, P + 1, Length(Result) - P);
  Len := Length(Str);

  Result := Copy(Result, 1, P - 1);

  if DecimalPlaces < 0 then
  begin
    if Len > 20 then Str := Copy(Str, 1, 20);
    Result := Result + DecimalChar + Str;

    Exit;
  end;

  if Len = DecimalPlaces then
  begin
    if Len > 0 then
      Result := Result + DecimalChar + Str;

    Exit;
  end;

  if DecimalPlaces = 0 then
  begin
    P := 0;
    for I := Len downto 1 do
    begin
      if Str[I] <> '0' then
        Break;

      Inc(P);
    end;

    Delete(Str, Len - P + 1, P);
    Len := Length(Str);
  end;

  if Len > DecimalPlaces then
    Str := Copy(Str, 1, DecimalPlaces)
  else if Len < DecimalPlaces then
    Str := Str + StringOfChar('0', DecimalPlaces - Len);

  if Str <> '' then
    Result := Result + DecimalChar + Str;
end;

function scFloatToStr(Value: Extended; IsCurrency: Boolean): String;
begin
  Result := scArrangeDecimalSeperator(FloatToStr(Value), IsCurrency);
end;

function scCurrencyToStr(Value: Extended; UseThousandsSeperator: Boolean;
  DecimalPlaces: Byte): String;
begin
  Result := FloatToStr(Value);
  if not UseThousandsSeperator then
    Result := StringReplace(Result, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll])
  else
    Result := scArrangeDecimalSeperator(FloatToStr(Value), True, DecimalPlaces);
end;

function scDaysPerMonth(AYear, AMonth: Integer): Integer;
const
  DaysInMonth: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := DaysInMonth[AMonth];
  if (AMonth = 2) and IsLeapYear(AYear) then Inc(Result); { leap-year Feb is special }
end;

function scGetMonthIndex(M: TSCMonth): Integer;
begin
  Result := Integer(M) + 1;
end;

function scFirstDayOfWeek(D: TDateTime): Word;
begin
  Result := (DateTimeToTimeStamp(D).Date - 1) mod 7 + 1;
end;

function scStrToTime(const S: string; const ATime: TTime; OnError: TSCTimeValidation): TTime;
begin
  Result := ATime;
  if S = '' then
  begin
    Result := SysUtils.Time;
    Exit;
  end;

  try
    Result := StrToDateTime(S);
  except
    case OnError of
      sctvRaiseError:
        raise;
      sctvSetToNow:
        Result := SysUtils.Time;
      sctvDontUpdate:
        Result := ATime;
    end;
  end;
end;

function scStrToDateTime(const S: string; const ADate: TDateTime; OnError: TSCDateValidation): TDateTime;
begin
  Result := ADate;
  if S = '' then
  begin
    Result := 0;
    Exit;
  end;

  try
    Result := StrToDateTime(S);
  except
    case OnError of
      scdvRaiseError:
        raise;
      scdvSetToNull:
        Result := 0;
      scdvSetToToday:
        Result := SysUtils.Date;
      scdvDontUpdate:
        Result := ADate;
    end;
  end;
end;

function scAdjustTime(T: TTime; AHour, AMinute, ASecond: Integer): TTime;
var
  Hour, Min, Sec, MSec: Word;
begin
  T := T - Trunc(T);
  DecodeTime(T, Hour, Min, Sec, MSec);

  Inc(AHour, Hour);
  Inc(AMinute, Min);
  Inc(ASecond, Sec);

  Inc(AMinute, ASecond div 60);

  ASecond := ASecond mod 60;
  if ASecond < 0 then
  begin
    Inc(ASecond, 60);
    Dec(AMinute);
  end;

  Inc(AHour, AMinute div 60);

  AMinute := AMinute mod 60;
  if AMinute < 0 then
  begin
    Inc(AMinute, 60);
    Dec(AHour);
  end;

  AHour := AHour mod 24;
  if AHour < 0 then Inc(AHour, 24);

  Result := EncodeTime(AHour, AMinute, ASecond, MSec);
end;

function scAdjustDate(D: TDateTime; AYear, AMonth, ADay: Integer): TDateTime;
var
  ATime: TDateTime;
  DayOfMonth: Integer;
  Year, Month, Day: Word;
begin
  DecodeDate(D, Year, Month, Day);
  ATime := D - Trunc(D);

  Inc(AYear, Year);

  Inc(AMonth, Month);

  if AMonth > 12 then
  begin
    Inc(AYear, AMonth div 12);
    AMonth := AMonth mod 12;
  end else
  if AMonth < 1 then
  begin
    AMonth := Abs(AMonth);

    Dec(AYear, (AMonth div 12) + 1);
    AMonth := 12 - AMonth;
  end;

  if AYear < 1 then
  begin
    Result := EncodeDate(1, 1, 1) + ATime;
    Exit;
  end;

  if AYear > 9999 then
  begin
    Result := EncodeDate(9999, 12, scDaysPerMonth(9999, 12)) + ATime;
    Exit;
  end;

  if ADay = 0 then
  begin
    ADay := Day;

    DayOfMonth := scDaysPerMonth(AYear, AMonth);
    if ADay > DayOfMonth then
      ADay := DayOfMonth;
  end else
  begin
    Inc(ADay, Day);
    if ADay > 28 then
    begin
      repeat
        if AYear > 9999 then
        begin
          Result := EncodeDate(9999, 12, scDaysPerMonth(9999, 12)) + ATime;
          Exit;
        end;

        DayOfMonth := scDaysPerMonth(AYear, AMonth);
        if ADay <= DayOfMonth then
          Break;

        Dec(ADay, DayOfMonth);

        Inc(AMonth);
        if AMonth > 12 then
        begin
          AMonth := 1;
          Inc(AYear);
        end;
      until ADay > 28;
    end else
    if ADay < 1 then
    begin
      repeat
        Dec(AMonth);
        if AMonth < 1 then
        begin
          AMonth := 12;
          Dec(AYear);
        end;

        if AYear < 1 then
        begin
          Result := EncodeDate(1, 1, 1) + ATime;
          Exit;
        end;

        DayOfMonth := scDaysPerMonth(AYear, AMonth);
        Inc(ADay, DayOfMonth);
      until ADay > 0;
    end;
  end;  

  if AYear < 1 then
  begin
    Result := EncodeDate(1, 1, 1) + ATime;
    Exit;
  end;

  if AYear > 9999 then
  begin
    Result := EncodeDate(9999, 12, scDaysPerMonth(9999, 12)) + ATime;
    Exit;
  end;

  Result := EncodeDate(AYear, AMonth, ADay) + ATime;
end;

function scVarEquals(const V1, V2: Variant): Boolean;
begin
  Result := False;
  try
    Result := V1 = V2;
  except
  end;
end;

procedure SetInitializeValues;
{$IFDEF SC_DELPHI6_UP}
var
  S: String;
{$ENDIF}
begin
  try
    scCurrentOperatingSystem := GetWinOperatingSystem;
  except
    scCurrentOperatingSystem := cOsUnknown;
  end;

  try
    InitiateCaptionGradientColors;
    GradientLibrary := LoadLibrary(PChar('msimg32.dll'));
  except
  end;

{$IFDEF SC_DELPHI6_UP}
  scDefaultLCID := GetThreadLocale;
  scSystemLCID := GetSystemDefaultLCID;

  {$IFDEF MSWINDOWS}
  try
    scNegativeFormat := 1;
    scNegativeFormat := StrToIntDef(GetLocaleStr(scDefaultLCID, LOCALE_INEGNUMBER, '0'), 1);
  except
    scNegativeFormat := 1;
  end;

  try
    scNegativeSign := '-';
    S := GetLocaleStr(scDefaultLCID, LOCALE_SNEGATIVESIGN, '-');
    if Length(S) > 0 then scNegativeSign := S[1];
  except
    scNegativeSign := '-';
  end;

  try
    scNegativeCurFormat := 1;
    scNegativeCurFormat := StrToIntDef(GetLocaleStr(scDefaultLCID, LOCALE_INEGCURR, '0'), 1);
  except
    scNegativeCurFormat := 1;
  end;

  try
    scSysDecimalSeparator := '.';
    S := GetLocaleChar(scSystemLCID, LOCALE_SDECIMAL, '.');
    if Length(S) = 0 then
      scSysDecimalSeparator := '.'
    else
      scSysDecimalSeparator := S[1];
  except
    scSysDecimalSeparator := '.';
  end;

  try
    scCurThousandSeparator := ',';
    S := GetLocaleChar(scDefaultLCID, LOCALE_SMONTHOUSANDSEP, ',');
    if Length(S) = 0 then
      scCurThousandSeparator := ','
    else
      scCurThousandSeparator := S[1];
  except
    scCurThousandSeparator := ',';
  end;

  try
    scCurDecimalSeparator := '.';
    S := GetLocaleChar(scDefaultLCID, LOCALE_SMONDECIMALSEP, '.');
    if Length(S) = 0 then
      scCurDecimalSeparator := '.'
    else
      scCurDecimalSeparator := S[1];
  except
    scCurDecimalSeparator := '.';
  end;
  {$ENDIF}
{$ENDIF}
end;

procedure scRaiseLastOSError;
var
  LastError: Integer;
  Error: ESCOSError;
begin
  LastError := GetLastError;
  if LastError <> 0 then
    Error := ESCOSError.Create(Format(SSCOSError, [LastError,
      SysErrorMessage(LastError)]))
  else
    Error := ESCOSError.Create(SSCUnkOSError);
  Error.ErrorCode := LastError;
  raise Error;
end;

initialization
  SetInitializeValues;

finalization
  if GradientLibrary > 0 then
    FreeLibrary(GradientLibrary);

end.



