{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCColorbox;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCConsts, SCCommon, SCControl;

type
  TSCColorboxOption = (sccoShowAutoColor, sccoShowMoreButton, sccoShowBasicColors,
    sccoShowSystemColors, sccoShowWebSafeColors, sccoShowNoneColor, sccoShowCustomColors,
    sccoShowUniqueColors);

  TSCColorboxOptions = set of TSCColorboxOption;

  TSCColorBoxStyle = (sccbDefaultbox, sccbFlatbox, sccbMetalbox, sccbOfficeXPbox);

const
  DefaultColorboxOptions = [sccoShowAutoColor, sccoShowMoreButton, sccoShowBasicColors,
    sccoShowSystemColors, sccoShowCustomColors];
       
type
  TSCCustomColorbox = class;

  TSCColorboxItem = class(TCollectionItem)
  private
    FCaption: String;
    FColor: TColor;
    FBounds: TRect;
    procedure SetCaption(const Value: String);
    procedure SetColor(Value: TColor);
  protected
    function GetDisplayName: string; override;
    property Bounds: TRect read FBounds;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Caption: String read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor default clBlack;
  end;

  TSCColorUpdateEvent = procedure(Sender: TObject; Item: TSCColorboxItem) of object;

  TSCColorboxItems = class(TCollection)
  private
    FOwner: TSCCustomControl;
    FOnUpdate: TSCColorUpdateEvent;
    function  GetItem(Index: Integer): TSCColorboxItem;
    procedure SetItem(Index: Integer; Value: TSCColorboxItem);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
    property OnUpdate: TSCColorUpdateEvent read FOnUpdate write FOnUpdate;
  public
    constructor Create(AOwner: TSCCustomControl); virtual;
    function Add: TSCColorboxItem;
    property Items[Index: Integer]: TSCColorboxItem read GetItem write SetItem; default;
  end;

  TSCBasicColorType = (scbtFrontPage, scbtWordFont);

  TSCOnShowColorHintEvent = procedure(Sender: TObject; C: TColor; var H: String) of object;

  TSCColorboxBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccbFlat;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCCustomColorbox = class(TSCCustomSizableControl)
  private
    FAutoColor: TColor;
    FAutoCaption: String;
    FBasicColorType: TSCBasicColorType;
    FCellSize: Integer;
    FColumnCount: Integer;
    FCustomColors: TSCColorboxItems;
    FMoreColor: TColor;
    FMoreCaption: String;
    FOptions: TSCColorboxOptions;
    FSelectedColor: TColor;
    FShowColorHints: Boolean;
    FStyle: TSCColorBoxStyle;
    FBaseColorList: TSCIntList;
    FSystemColorList: TSCIntList;
    FWebSafeColorList: TSCIntList;
    FCustomColorList: TSCIntList;
    FClickedItem: Integer;
    FFocusedItem: Integer;
    FHintWnd: THintWindow;
    FHintTimer: Integer;
    FOnBoxClick: TNotifyEvent;
    FOnMoreButtonClick: TNotifyEvent;
    FOnSelectedColorChange: TNotifyEvent;
    FOnShowColorHintEvent: TSCOnShowColorHintEvent;
    function  GetBaseColor(Index: Integer): TColor;
    function  GetSystemColor(Index: Integer): TColor;
    function  GetWebSafeColor(Index: Integer): TColor;
    function  GetCustomColor(Index: Integer): TColor;
    procedure SetAutoColor(Value: TColor);
    procedure SetAutoCaption(const Value: String);
    procedure SetBasicColorType(Value: TSCBasicColorType);
    procedure SetCellSize(Value: Integer);
    procedure SetCustomColors(Value: TSCColorboxItems);
    procedure SetColumnCount(Value: Integer);
    procedure SetMoreColor(Value: TColor);
    procedure SetMoreCaption(const Value: String);
    procedure SetOptions(Value: TSCColorboxOptions);
    procedure SetSelectedColor(Value: TColor);
    procedure SetShowColorHints(Value: Boolean);
    procedure SetStyle(Value: TSCColorBoxStyle);

    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;

    procedure RefreshColors;
    procedure UpdateColumnCount;
    procedure CustomColorsUpdated(Sender: TObject; Item: TSCColorboxItem);
  protected
    procedure Paint; override;
    procedure ConstrainedResize(var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer); override;
    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure AdjustBounds; override;

    procedure SystemColorsChanged; override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;

    procedure DoBoxClick; dynamic;
    procedure DoMoreButtonClick; dynamic;
    procedure DoSelectedColorChange; dynamic;
    procedure DoShowColorHint(C: TColor; var H: String); dynamic;

    procedure ShowHintWindow(P: TPoint);
    procedure HideHintWindow;

    procedure CaptureChanged(Captured: Boolean); override;
    procedure StopTracking; override;
    procedure MouseInControlChanged; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure DrawAutoButton; virtual;
    procedure DrawMoreButton; virtual;
    procedure DrawColorCells; virtual;

    function  GetButtonHeight: Integer; virtual;
    function  GetCellWidth: Integer;
    function  GetMaxColumnCount: Integer;

    function  GetAutoCaption: String; virtual;
    function  GetMoreCaption: String; virtual;

    property BaseColor[Index: Integer]: TColor read GetBaseColor;
    property SystemColor[Index: Integer]: TColor read GetSystemColor;
    property WebSafeColor[Index: Integer]: TColor read GetWebSafeColor;
    property CustomColor[Index: Integer]: TColor read GetCustomColor;

    property AutoColor: TColor read FAutoColor write SetAutoColor default clNone;
    property AutoCaption: String read FAutoCaption write SetAutoCaption;
    property AutoSize default True;
    property BasicColorType: TSCBasicColorType read FBasicColorType write SetBasicColorType default scbtWordFont;
    property BlendColor default False;
    property Border default sccbFlat;
    property CellSize: Integer read FCellSize write SetCellSize default 12;
    property Color default clWindow;
    property ColumnCount: Integer read FColumnCount write SetColumnCount default 8;
    property CustomColors: TSCColorboxItems read FCustomColors write SetCustomColors;
    property MoreColor: TColor read FMoreColor write SetMoreColor default clNone;
    property MoreCaption: String read FMoreCaption write SetMoreCaption;
    property Options: TSCColorboxOptions read FOptions write SetOptions default DefaultColorboxOptions;
    property ParentColor default False;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clNone;
    property ShowColorHints: Boolean read FShowColorHints write SetShowColorHints default True;
    property Style: TSCColorBoxStyle read FStyle write SetStyle default sccbOfficeXPbox;
    property OnBoxClick: TNotifyEvent read FOnBoxClick write FOnBoxClick;
    property OnMoreButtonClick: TNotifyEvent read FOnMoreButtonClick write FOnMoreButtonClick;
    property OnSelectedColorChange: TNotifyEvent read FOnSelectedColorChange write FOnSelectedColorChange;
    property OnShowColorHintEvent: TSCOnShowColorHintEvent read FOnShowColorHintEvent write FOnShowColorHintEvent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  BaseColorCount: Integer;
    function  SystemColorCount: Integer;
    function  WebSafeColorCount: Integer;
    function  CustomColorCount: Integer;

    function  ItemAtPos(X, Y: Integer): Integer;
    function  ItemRect(Index: Integer): TRect;
  end;

  TSCColorbox = class(TSCCustomColorbox)
  public
    property BaseColor;
    property SystemColor;
    property CustomColor;
  published
    property Align;
    property Anchors;
    property AutoColor;
    property AutoCaption;
    property AutoSize;
    property BasicColorType;
    property BorderProps;
    property CellSize;
    property Color;
    property ColumnCount;
    property Constraints;
    property CustomColors;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property MoreColor;
    property MoreCaption;
    property Options;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property SelectedColor;
    property ShowColorHints;
    property ShowHint;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarColor;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnBoxClick;
    property OnConstrainedResize;
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
    property OnMoreButtonClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnSelectedColorChange;
    property OnShowColorHintEvent;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

const
  SC_CLBOXHINT_TIMERID = 5335;

  AUTOCOLOR_INDEX    = 0;
  MORECOLOR_INDEX    = 1;
  MOREBUTTON_INDEX   = 2;
  BASICCOLORS_BASE   = 100;
  SYSTEMCOLORS_BASE  = 200;
  WEBSAFECOLORS_BASE = 300;
  CUSTOMCOLORS_BASE  = 500;

{ TSCColorboxItem }

procedure TSCColorboxItem.Assign(Source: TPersistent);
begin
  if Source is TSCColorboxItem then
  begin
    with TSCColorboxItem(Source) do
    begin
      Self.Caption := Caption;
      Self.Color   := Color;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCColorboxItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FColor := clBlack;
end;

function TSCColorboxItem.GetDisplayName: string;
var
  C: LongInt;
begin
  Result := FCaption;
  if Result = '' then
  begin
    C := ColorToRGB(FColor);
    Result := 'RGB : ' + IntToHex(GetRValue(C), 2) +  ', ' +
      IntToHex(GetGValue(C), 2) +  ', ' + IntToHex(GetBValue(C), 2);
  end;
end;

procedure TSCColorboxItem.SetCaption(const Value: String);
begin
  FCaption := Value;
end;

procedure TSCColorboxItem.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed(False);
  end;
end;

{ TSCColorboxItems }

function TSCColorboxItems.Add: TSCColorboxItem;
begin
  Result := TSCColorboxItem(inherited Add);
end;

constructor TSCColorboxItems.Create(AOwner: TSCCustomControl);
begin
  inherited Create(TSCColorboxItem);
  FOwner := AOwner;
end;

function TSCColorboxItems.GetItem(Index: Integer): TSCColorboxItem;
begin
  Result := TSCColorboxItem(inherited GetItem(Index));
end;

function TSCColorboxItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCColorboxItems.SetItem(Index: Integer;
  Value: TSCColorboxItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCColorboxItems.Update(Item: TCollectionItem);
begin
  if Assigned(FOnUpdate) then
    FOnUpdate(Self, TSCColorboxItem(Item));
end;

{ TSCCustomColorbox }

procedure TSCCustomColorbox.AdjustBounds;
begin
  AdjustSize;
end;

function TSCCustomColorbox.BaseColorCount: Integer;
begin
  Result := FBaseColorList.Count;
end;

function TSCCustomColorbox.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
var
  TempI, Bw,
  Bh, BtnH, Cnt, Cw,
  BaseCnt, SysCnt,
  WebCnt, CustCnt: Integer;
begin
  Result := True;
  if HandleAllocated and AutoSize and not IsLoading then
  begin
    if FCellSize < 6 then FCellSize := 6;
    if FCellSize > 40 then FCellSize := 40;

    Bw  := 2*(GetBorderSize + BorderWidth + GetInnerBorderSize + 2);

    TempI := (Width - ClientWidth) + 4;
    if TempI > Bw then Bw := TempI;

    Cw := GetCellWidth;

    FColumnCount := Round((NewWidth - Bw) / Cw);
    if FColumnCount < 1 then
      FColumnCount := 1;

    Cnt := GetMaxColumnCount;
    if FColumnCount > Cnt then
      FColumnCount := Cnt;

    NewWidth := (FColumnCount*Cw) + Bw;

    NewHeight := 0;
    BtnH := GetButtonHeight;

    BaseCnt := FBaseColorList.Count;
    SysCnt  := FSystemColorList.Count;
    WebCnt  := FWebSafeColorList.Count;
    CustCnt := FCustomColorList.Count;

    if sccoShowAutoColor in FOptions then
    begin
      Inc(NewHeight, BtnH);

      if (sccoShowMoreButton in FOptions) or (BaseCnt > 0) or
        (SysCnt > 0) or (WebCnt > 0) or (CustCnt > 0) then
        Inc(NewHeight, 2);
    end;

    if sccoShowMoreButton in FOptions then
    begin
      Inc(NewHeight, BtnH);

      if (sccoShowAutoColor in FOptions) or (BaseCnt > 0) or
        (SysCnt > 0) or (WebCnt > 0) or (CustCnt > 0) then
        Inc(NewHeight, 2);
    end;

    if BaseCnt > 0 then
    begin
      Cnt := FBaseColorList.Count div FColumnCount;
      if (FBaseColorList.Count mod FColumnCount) <> 0 then
        Inc(Cnt);

      Inc(NewHeight, Cnt*Cw);

      if (SysCnt > 0) or (WebCnt > 0) or (CustCnt > 0) then
        Inc(NewHeight, 9);
    end;

    if SysCnt > 0 then
    begin
      Cnt := SysCnt div FColumnCount;
      if (SysCnt mod FColumnCount) <> 0 then
        Inc(Cnt);

      Inc(NewHeight, Cnt*Cw);

      if (CustCnt > 0) or (WebCnt > 0) then
        Inc(NewHeight, 9);
    end;

    if WebCnt > 0 then
    begin
      Cnt := WebCnt div FColumnCount;
      if (WebCnt mod FColumnCount) <> 0 then
        Inc(Cnt);

      Inc(NewHeight, Cnt*Cw);

      if CustCnt > 0 then
        Inc(NewHeight, 9);
    end;

    if CustCnt > 0 then
    begin
      Cnt := CustCnt div FColumnCount;
      if (CustCnt mod FColumnCount) <> 0 then
        Inc(Cnt);

      Inc(NewHeight, Cnt*Cw);
    end;

    Bh  := 2*(GetBorderSize + BorderWidth + GetInnerBorderSize + 2);
    if ShowStatusbar then Inc(Bh, GetStatusbarHeight);

    TempI := (Height - ClientHeight) + 4;
    if TempI > Bh then Bh := TempI;

    Inc(NewHeight, Bh);
  end;
end;

procedure TSCCustomColorbox.CaptureChanged(Captured: Boolean);
begin
  FFocusedItem := -1;
  Invalidate;

  inherited CaptureChanged(Captured);
end;

constructor TSCCustomColorbox.Create(AOwner: TComponent);
begin
  FColumnCount := 8;
  
  FBaseColorList := TSCIntList.Create;
  FSystemColorList := TSCIntList.Create;
  FWebSafeColorList := TSCIntList.Create;
  FCustomColorList := TSCIntList.Create;

  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls];
  DoubleBuffered := True;
  AutoSize := True;
  BlendColor := False;
  Border := sccbFlat;
  ParentColor := False;
  Color := clWindow;
  SetBounds(Left, Top, 150, 223);

  FCustomColors := TSCColorboxItems.Create(Self);
  FCustomColors.OnUpdate := CustomColorsUpdated;

  FClickedItem := -1;
  FFocusedItem := -1;
  FHintTimer   := -1;

  FAutoColor := clNone;
  FBasicColorType := scbtWordFont;
  FCellSize  := 12;
  FColumnCount := 8;
  FMoreColor := clNone;
  FOptions   := DefaultColorboxOptions;
  FSelectedColor  := clNone;
  FShowColorHints := True;
  FStyle := sccbOfficeXPbox;

  RefreshColors;
end;

function TSCCustomColorbox.CustomColorCount: Integer;
begin
  Result := FCustomColorList.Count;
end;

procedure TSCCustomColorbox.CustomColorsUpdated(Sender: TObject;
  Item: TSCColorboxItem);
begin
  RefreshColors;
  if AutoSize then
    AdjustBounds
  else
    UpdateColumnCount;
end;

destructor TSCCustomColorbox.Destroy;
begin
  HideHintWindow;

  FreeAndNil(FCustomColorList);
  FreeAndNil(FSystemColorList);
  FreeAndNil(FWebSafeColorList);
  FreeAndNil(FBaseColorList);

  FCustomColors.OnUpdate := nil;
  FreeAndNil(FCustomColors);
  inherited Destroy;
end;

procedure TSCCustomColorbox.DrawAutoButton;
var
  Text: String;
  CR, R, R2, R3: TRect;
  TempI, Bh, Flags: Integer;
begin
  if sccoShowAutoColor in FOptions then
  begin
    Bh := GetButtonHeight;
    if Bh <= 0 then Exit;

    CR := GetClientRect;

    InflateRect(CR, -2, -2);
    if IsRectEmpty(CR) then Exit;

    Flags := DT_SINGLELINE or DT_LEFT or DT_END_ELLIPSIS or DT_VCENTER;

    R := CR;
    R.Bottom := R.Top + Bh;

    InflateRect(R, -3, -3);
    if not IsRectEmpty(R) then
    begin
      R2 := R;
      InflateRect(R2, 3, 3);

      case FStyle of
        sccbFlatbox:
        if (FSelectedColor = FAutoColor) and (FFocusedItem <> AUTOCOLOR_INDEX) then
        begin
          Canvas.Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);
          Canvas.FillRect(R2);
        end;
        sccbOfficeXPbox:
        if (FFocusedItem = AUTOCOLOR_INDEX) and ((FClickedItem > -1) or (FSelectedColor = FAutoColor)) then
        begin
          Canvas.Brush.Color := GetOfficeXPDownedSelColor;
          Canvas.FillRect(R2);
        end else
        if (FSelectedColor = FAutoColor) or (FFocusedItem = AUTOCOLOR_INDEX) then
        begin
          Canvas.Brush.Color := GetOfficeXPDownedColor;
          Canvas.FillRect(R2);
        end;
      end;

      R2 := R;
      Inc(R2.Left, R.Bottom - R.Top + 2);
      InflateRect(R2, -3, -3);

      if not IsRectEmpty(R2) then
      begin
        Text := GetAutoCaption;

        if Text <> '' then
        begin
          Canvas.Font.Assign(Self.Font);

          if (FStyle = sccbOfficeXPbox) and ((FFocusedItem = AUTOCOLOR_INDEX) and
            ((FClickedItem > -1) or (FSelectedColor = FAutoColor))) then
            Canvas.Font.Color := clWindow;

          Canvas.Brush.Style := bsClear;

          R3 := R2;
          DrawText(Canvas.Handle, PChar(Text), Length(Text), R3,
            Flags or DT_CALCRECT);

          TempI := ((R.Right - R.Left) - (R3.Right - R3.Left)) div 2;
          if TempI < R2.Left then TempI := R2.Left;

          R3 := R2;
          R3.Left := TempI;
          DrawText(Canvas.Handle, PChar(Text), Length(Text), R3, Flags);
        end;
      end;

      R2 := R;
      InflateRect(R2, -3, -3);

      TempI := R2.Bottom - R2.Top;
      if TempI > FCellSize then
        TempI := FCellSize;

      R3 := R2;
      R3.Right := R2.Left + TempI;

      Inc(R3.Top, ((R2.Bottom - R2.Top) - TempI) div 2);
      if R3.Top < R2.Top then R3.Top := R2.Top;

      R3.Bottom := R3.Top + TempI;
      OffsetRect(R3, 1, 0);

      if R3.Right > R.Right - 4 then
        R3.Right := R.Right - 4;

      if not IsRectEmpty(R3) then
        with Canvas do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Color := clBtnShadow;
          Pen.Width := 1;

          Brush.Style := bsSolid;
          Brush.Color := FAutoColor;

          Rectangle(R3.Left, R3.Top, R3.Right, R3.Bottom);
        end;
    end;

    if FStyle = sccbDefaultbox then
    begin
      R3 := R;
      InflateRect(R3, 1, 1);

      scFrame3D(Canvas, R3, clBtnShadow, clBtnHighlight, 1, 0);
      scFrame3D(Canvas, R3, cl3DDkShadow, clBtnFace, 1, 0);
    end else
    if FStyle = sccbMetalbox then
    begin
      R3 := R;
      InflateRect(R3, 1, 1);

      scFrame3D(Canvas, R3, clBtnShadow, clBtnHighlight, 1, 0);
      scFrame3D(Canvas, R3, clBtnFace, clBtnFace, 1, 0);
    end else
    if FStyle = sccbFlatbox then
      scFrame3D(Canvas, R, clBtnShadow, clBtnShadow, 1, 0);

    if (FSelectedColor = FAutoColor) or ((FClickedItem <> MOREBUTTON_INDEX) and
      (FFocusedItem = AUTOCOLOR_INDEX)) then
      case FStyle of
        sccbDefaultbox:
        begin
          R3 := R;
          InflateRect(R3, 2, 2);

          scFrame3D(Canvas, R3, clHighlight, clHighlight, 1, 0);
          scFrame3D(Canvas, R3, clWindow, clWindow, 1, 0);
          scFrame3D(Canvas, R3, clHighlight, clHighlight, 1, 0);
        end;
        sccbMetalbox:
        begin
          R3 := R;
          InflateRect(R3, 1, 1);

          scFrame3D(Canvas, R3, clHighlight, clHighlight, 1, 0);
          scFrame3D(Canvas, R3, clBtnHighlight, clBtnHighlight, 1, 0);
        end;
        sccbFlatbox:
        begin
          R3 := R;
          InflateRect(R3, 4, 4);

          if (FSelectedColor = FAutoColor) or (FClickedItem > -1) then
            scFrame3D(Canvas, R3, clBtnShadow, clBtnHighlight, 1, 0)
          else
            scFrame3D(Canvas, R3, clBtnHighlight, clBtnShadow, 1, 0);
        end;
        sccbOfficeXPbox:
        begin
          R3 := R;
          InflateRect(R3, 3, 3);
          scFrame3D(Canvas, R3, clHighlight, clHighlight, 1, 0);
        end;
      end;
  end;
end;

procedure TSCCustomColorbox.DrawMoreButton;
var
  Text: String;
  CR, R, R2, R3: TRect;
  TempI, T, Bh, Cw,
  Flags, BaseCnt,
  SysCnt, WebCnt, CustCnt: Integer;
begin
  if sccoShowMoreButton in FOptions then
  begin
    Bh := GetButtonHeight;
    if Bh <= 0 then Exit;

    CR := GetClientRect;

    InflateRect(CR, -2, -2);
    if IsRectEmpty(CR) then Exit;

    Flags := DT_SINGLELINE or DT_LEFT or DT_END_ELLIPSIS or DT_VCENTER;

    BaseCnt := FBaseColorList.Count;
    SysCnt  := FSystemColorList.Count;
    WebCnt  := FWebSafeColorList.Count;
    CustCnt := FCustomColorList.Count;

    T := 0;
    if sccoShowAutoColor in FOptions then
      Inc(T, Bh + 2);

    Cw := GetCellWidth;

    if BaseCnt > 0 then
    begin
      TempI := BaseCnt div FColumnCount;
      if (BaseCnt mod FColumnCount) <> 0 then
        Inc(TempI);

      Inc(T, TempI*Cw);
      if (SysCnt > 0) or (CustCnt > 0) or (WebCnt > 0) then
        Inc(T, 9);
    end;

    if SysCnt > 0 then
    begin
      TempI := SysCnt div FColumnCount;
      if (SysCnt mod FColumnCount) <> 0 then
        Inc(TempI);

      Inc(T, TempI*Cw);
      if (CustCnt > 0) or (WebCnt > 0) then
        Inc(T, 9);
    end;

    if WebCnt > 0 then
    begin
      TempI := WebCnt div FColumnCount;
      if (WebCnt mod FColumnCount) <> 0 then
        Inc(TempI);

      Inc(T, TempI*Cw);
      if CustCnt > 0 then
        Inc(T, 9);
    end;

    if CustCnt > 0 then
    begin
      TempI := CustCnt div FColumnCount;
      if (CustCnt mod FColumnCount) <> 0 then
        Inc(TempI);

      Inc(T, TempI*Cw);
    end;

    if (sccoShowAutoColor in FOptions) or (BaseCnt > 0) or
      (SysCnt > 0) or (WebCnt > 0) or (CustCnt > 0) then
      Inc(T, 2);

    R := CR;
    R.Bottom := R.Top + Bh;
    InflateRect(R, -3, -3);

    OffsetRect(R, 0, T);
    IntersectRect(R2, R, CR);

    if not IsRectEmpty(R2) then
    begin
      R2 := R;
      R2.Left := R2.Right - (R2.Bottom - R2.Top);

      R3 := R2;
      InflateRect(R3, 3, 3);

      case FStyle of
        sccbFlatbox:
        if (FSelectedColor = FMoreColor) and (FFocusedItem <> MORECOLOR_INDEX) then
        begin
          Canvas.Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);
          Canvas.FillRect(R3);
        end;
        sccbOfficeXPbox:
        begin
          if (FFocusedItem = MORECOLOR_INDEX) and (FClickedItem <> MOREBUTTON_INDEX) and
            ((FClickedItem > -1) or (FSelectedColor = FMoreColor)) then
          begin
            Canvas.Brush.Color := GetOfficeXPDownedSelColor;
            Canvas.FillRect(R3);
          end else
          if (FSelectedColor = FMoreColor) or ((FClickedItem <> MOREBUTTON_INDEX) and
            (FFocusedItem = MORECOLOR_INDEX)) then
          begin
            Canvas.Brush.Color := GetOfficeXPDownedColor;
            Canvas.FillRect(R3);
          end;
        end;  
      end;

      with Canvas do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Color := clBtnShadow;
        Pen.Width := 1;

        Brush.Style := bsSolid;
        Brush.Color := FMoreColor;

        Rectangle(R2.Left, R2.Top, R2.Right, R2.Bottom);
      end;

      if FStyle = sccbDefaultbox then
      begin
        R3 := R2;
        InflateRect(R3, 1, 1);

        scFrame3D(Canvas, R3, clBtnShadow, clBtnHighlight, 1, 0);
        scFrame3D(Canvas, R3, cl3DDkShadow, clBtnFace, 1, 0);
      end else
      if FStyle = sccbMetalbox then
      begin
        R3 := R2;
        InflateRect(R3, 1, 1);

        scFrame3D(Canvas, R3, clBtnShadow, clBtnHighlight, 1, 0);
        scFrame3D(Canvas, R3, FMoreColor, GetBtnFaceOf(FMoreColor), 1, 0);
      end;

      if (FSelectedColor = FMoreColor) or ((FClickedItem <> MOREBUTTON_INDEX) and
        (FFocusedItem = MORECOLOR_INDEX)) then
        case FStyle of
          sccbDefaultbox:
          begin
            R3 := R2;
            InflateRect(R3, 2, 2);

            scFrame3D(Canvas, R3, clHighlight, clHighlight, 1, 0);
            scFrame3D(Canvas, R3, clWindow, clWindow, 1, 0);
            scFrame3D(Canvas, R3, clHighlight, clHighlight, 1, 0);
          end;
          sccbMetalbox:
          begin
            R3 := R2;
            InflateRect(R3, 1, 1);

            scFrame3D(Canvas, R3, clHighlight, clHighlight, 1, 0);
            scFrame3D(Canvas, R3, clBtnHighlight, clBtnHighlight, 1, 0);
          end;
          sccbFlatbox:
          begin
            R3 := R2;
            InflateRect(R3, 3, 3);

            if (FSelectedColor = FMoreColor) or (FClickedItem > -1) then
              scFrame3D(Canvas, R3, clBtnShadow, clBtnHighlight, 1, 0)
            else
              scFrame3D(Canvas, R3, clBtnHighlight, clBtnShadow, 1, 0);
          end;
          sccbOfficeXPbox:
          begin
            R3 := R2;
            InflateRect(R3, 3, 3);
            scFrame3D(Canvas, R3, clHighlight, clHighlight, 1, 0);
          end;
        end;

      R2.Right := R2.Left - 6;
      R2.Left  := R.Left;
      InflateRect(R2, 0, 1);

      if not IsRectEmpty(R2) then
      begin
        if FStyle in [sccbDefaultbox, sccbMetalbox, sccbFlatbox] then
          with Canvas do
          begin
            Pen.Style := psSolid;
            Pen.Mode  := pmCopy;
            Pen.Color := clBtnShadow;
            Pen.Width := 1;

            Brush.Style := bsSolid;
            Brush.Color := clBtnFace;

            Rectangle(R2.Left, R2.Top, R2.Right, R2.Bottom);
          end;

        if FStyle = sccbDefaultbox then
        begin
          R3 := R2;
          InflateRect(R3, 1, 1);

          if (FClickedItem = FFocusedItem) and (FFocusedItem = MOREBUTTON_INDEX) then
          begin
            scFrame3D(Canvas, R3, clWindowFrame, clWindowFrame, 1, 0);
            scFrame3D(Canvas, R3, clBtnShadow, clBtnShadow, 1, 0);
          end else
          begin
            scFrame3D(Canvas, R3, clBtnHighlight, cl3DDkShadow, 1, 0);
            scFrame3D(Canvas, R3, clBtnFace, clBtnShadow, 1, 0);
          end;
        end else
        if FStyle = sccbMetalbox then
        begin
          R3 := R2;
          InflateRect(R3, 1, 1);

          if (FClickedItem = FFocusedItem) and (FFocusedItem = MOREBUTTON_INDEX) then
          begin
            scFrame3D(Canvas, R3, clBtnShadow, clBtnShadow, 1, 0);
            scFrame3D(Canvas, R3, clBtnFace, clBtnHighlight, 1, 0);
          end else
          begin
            scFrame3D(Canvas, R3, clBtnShadow, clBtnShadow, 1, 0);
            scFrame3D(Canvas, R3, clBtnHighlight, clBtnFace, 1, 0);
          end;
        end else
        if (FStyle = sccbFlatbox) and (FFocusedItem = MOREBUTTON_INDEX) then
        begin
          R3 := R2;

          if (FFocusedItem = MOREBUTTON_INDEX) and ((FClickedItem > -1) or (FClickedItem = MOREBUTTON_INDEX)) then
            scFrame3D(Canvas, R3, clBtnShadow, clBtnHighlight, 1, 0)
          else
            scFrame3D(Canvas, R3, clBtnHighlight, clBtnShadow, 1, 0);
        end else
        if FStyle = sccbOfficeXPbox then
        begin
          R3 := R2;
          InflateRect(R3, 3, 2);

          if (FFocusedItem = MOREBUTTON_INDEX) and ((FClickedItem > -1) or (FClickedItem = MOREBUTTON_INDEX)) then
          begin
            Canvas.Brush.Color := GetOfficeXPDownedSelColor;
            Canvas.FillRect(R3);
          end else
          if (FClickedItem = MOREBUTTON_INDEX) or (FFocusedItem = MOREBUTTON_INDEX) then
          begin
            Canvas.Brush.Color := GetOfficeXPDownedColor;
            Canvas.FillRect(R3);
          end;

          if (FClickedItem = MOREBUTTON_INDEX) or (FFocusedItem = MOREBUTTON_INDEX) then
            scFrame3D(Canvas, R3, clHighlight, clHighlight, 1, 0);
        end;

        InflateRect(R2, -3, -3);
        
        if not IsRectEmpty(R2) then
        begin
          Text := GetMoreCaption;

          if Text <> '' then
          begin
            Canvas.Font.Assign(Self.Font);
            
            if (FStyle = sccbOfficeXPbox) and (FFocusedItem = MOREBUTTON_INDEX) and
              ((FClickedItem > -1) or (FClickedItem = MOREBUTTON_INDEX)) then
              Canvas.Font.Color := clWindow;

            Canvas.Brush.Style := bsClear;

            R3 := R2;
            DrawText(Canvas.Handle, PChar(Text), Length(Text), R3,
              Flags or DT_CALCRECT);

            TempI := ((R2.Right - R2.Left) - (R3.Right - R3.Left)) div 2;
            if TempI < 0 then TempI := 0;

            Inc(TempI, R2.Left);

            R3 := R2;
            R3.Left := TempI;

            if ((FStyle in [sccbDefaultbox, sccbMetalbox]) and (FClickedItem = FFocusedItem) and
              (FFocusedItem = MOREBUTTON_INDEX)) or ((FStyle = sccbFlatbox) and
              (FFocusedItem = MOREBUTTON_INDEX) and ((FClickedItem > -1) or (FClickedItem = MOREBUTTON_INDEX))) then
            begin
              Inc(R3.Left, 1);
              Inc(R3.Top, 1);
            end;

            if not IsRectEmpty(R3) then
              DrawText(Canvas.Handle, PChar(Text), Length(Text), R3, Flags);
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomColorbox.DrawColorCells;

  procedure DrawColors(L: TSCIntList; CR: TRect; SelIndex, Cw: Integer; var T: Integer);
  var
    R, R2: TRect;
    I: Integer;
  begin
    if IsRectEmpty(CR) or (Cw < 8) or
      (T > CR.Bottom) or (L.Count = 0) then
      Exit;

    OffsetRect(CR, 0, -CR.Top + T);
    if IsRectEmpty(CR) then
      Exit;

    R := CR;

    R.Right  := R.Left + Cw;
    R.Bottom := R.Top + Cw;

    Inc(T, Cw);

    if R.Top < CR.Bottom then
      for I := 0 to L.Count-1 do
      begin
        case FStyle of
          sccbFlatbox:
          if (FSelectedColor = L[I]) and (SelIndex <> I) then
          begin
            Canvas.Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);
            Canvas.FillRect(R);
          end;
          sccbOfficeXPbox:
          if (SelIndex = I) and ((FClickedItem > -1) or (FSelectedColor = L[I])) then
          begin
            Canvas.Brush.Color := GetOfficeXPDownedSelColor;
            Canvas.FillRect(R);
          end else
          if (FSelectedColor = L[I]) or (SelIndex = I) then
          begin
            Canvas.Brush.Color := GetOfficeXPDownedColor;
            Canvas.FillRect(R);
          end;
        end;

        R2 := R;
        InflateRect(R2, -3, -3);

        Canvas.Brush.Color := L[I];
        Canvas.Rectangle(R2.Left, R2.Top, R2.Right, R2.Bottom);

        if FStyle = sccbDefaultbox then
        begin
          InflateRect(R2, 1, 1);

          scFrame3D(Canvas, R2, clBtnShadow, clBtnHighlight, 1, 0);
          scFrame3D(Canvas, R2, cl3DDkShadow, clBtnFace, 1, 0);
        end else
        if FStyle = sccbMetalbox then
        begin
          InflateRect(R2, 1, 1);

          scFrame3D(Canvas, R2, clBtnShadow, clBtnHighlight, 1, 0);
          scFrame3D(Canvas, R2, GetBtnFaceOf(L[I]), GetBtnFaceOf(L[I]), 1, 0);
        end;

        R2 := R;
        InflateRect(R2, -3, -3);

        if (FSelectedColor = L[I]) or (SelIndex = I) then
          case FStyle of
            sccbDefaultbox:
            begin
              InflateRect(R2, 2, 2);

              scFrame3D(Canvas, R2, clHighlight, clHighlight, 1, 0);
              scFrame3D(Canvas, R2, clWindow, clWindow, 1, 0);
              scFrame3D(Canvas, R2, clHighlight, clHighlight, 1, 0);
            end;
            sccbMetalbox:
            begin
              InflateRect(R2, 1, 1);

              scFrame3D(Canvas, R2, clHighlight, clHighlight, 1, 0);
              scFrame3D(Canvas, R2, clBtnHighlight, clBtnHighlight, 1, 0);
            end;
            sccbFlatbox:
            begin
              InflateRect(R2, 3, 3);

              if (FSelectedColor = L[I]) or (FClickedItem > -1) then
                scFrame3D(Canvas, R2, clBtnShadow, clBtnHighlight, 1, 0)
              else
                scFrame3D(Canvas, R2, clBtnHighlight, clBtnShadow, 1, 0);
            end;
            sccbOfficeXPbox:
            begin
              InflateRect(R2, 3, 3);
              scFrame3D(Canvas, R2, clHighlight, clHighlight, 1, 0);
            end;
          end;

        OffsetRect(R, Cw, 0);

        if (R.Right > CR.Right) and (I < L.Count-1) then
        begin
          R.Left  := CR.Left;
          R.Right := R.Left + Cw;

          OffsetRect(R, 0, Cw);
          Inc(T, Cw);

          if R.Top >= CR.Bottom then
            Exit;
        end;
      end;
  end;

var
  CR: TRect;
  T, Cw, Bh,
  SelIndex, SysCnt,
  WebCnt, CustCnt: Integer;
begin
  SysCnt  := FSystemColorList.Count;
  WebCnt  := FWebSafeColorList.Count;
  CustCnt := FCustomColorList.Count;

  if (FBaseColorList.Count = 0) and (SysCnt = 0) and
    (WebCnt = 0) and (CustCnt = 0) then
    Exit;

  CR := GetClientRect;

  InflateRect(CR, -2, -2);
  if IsRectEmpty(CR) then Exit;

  if sccoShowAutoColor in FOptions then
  begin
    Bh := GetButtonHeight;
    if Bh > 0 then
    begin
      Inc(Bh, 2);

      Inc(CR.Top, Bh);
      if IsRectEmpty(CR) then
        Exit;
    end;
  end;

  with Canvas do
  begin
    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Pen.Color := clBtnShadow;
    Pen.Width := 1;

    Brush.Style := bsSolid;
  end;

  Cw := GetCellWidth;

  T := CR.Top;
  if FBaseColorList.Count > 0 then
  begin
    SelIndex := -1;
    if (FFocusedItem > -1) and (FClickedItem <> MOREBUTTON_INDEX) and
      (FFocusedItem >= BASICCOLORS_BASE) and (FFocusedItem < SYSTEMCOLORS_BASE) then
      SelIndex := FFocusedItem - BASICCOLORS_BASE;

    DrawColors(FBaseColorList, CR, SelIndex, Cw, T);

    OffsetRect(CR, 0, -CR.Top + T);
    if IsRectEmpty(CR) then
      Exit;

    if (SysCnt > 0) or (WebCnt > 0) or (CustCnt > 0) then
    begin
      OffsetRect(CR, 0, 5);

      Canvas.MoveTo(CR.Left, CR.Top);
      Canvas.LineTo(CR.Right, CR.Top);

      OffsetRect(CR, 0, 4);

      Inc(T, 9);
      if IsRectEmpty(CR) then
        Exit;
    end;
  end;

  if SysCnt > 0 then
  begin
    SelIndex := -1;
    if (FFocusedItem > -1) and (FClickedItem <> MOREBUTTON_INDEX) and
      (FFocusedItem >= SYSTEMCOLORS_BASE) and (FFocusedItem < WEBSAFECOLORS_BASE) then
      SelIndex := FFocusedItem - SYSTEMCOLORS_BASE;

    DrawColors(FSystemColorList, CR, SelIndex, Cw, T);

    OffsetRect(CR, 0, -CR.Top + T);
    if IsRectEmpty(CR) then
      Exit;

    if (WebCnt > 0) or (CustCnt > 0) then
    begin
      OffsetRect(CR, 0, 5);

      Canvas.MoveTo(CR.Left, CR.Top);
      Canvas.LineTo(CR.Right, CR.Top);

      OffsetRect(CR, 0, 4);

      Inc(T, 9);
      if IsRectEmpty(CR) then
        Exit;
    end;
  end;

  if WebCnt > 0 then
  begin
    SelIndex := -1;
    if (FFocusedItem > -1) and (FClickedItem <> MOREBUTTON_INDEX) and
      (FFocusedItem >= WEBSAFECOLORS_BASE) and (FFocusedItem < CUSTOMCOLORS_BASE) then
      SelIndex := FFocusedItem - WEBSAFECOLORS_BASE;

    DrawColors(FWebSafeColorList, CR, SelIndex, Cw, T);

    OffsetRect(CR, 0, -CR.Top + T);
    if IsRectEmpty(CR) then
      Exit;

    if CustCnt > 0 then
    begin
      OffsetRect(CR, 0, 5);

      Canvas.MoveTo(CR.Left, CR.Top);
      Canvas.LineTo(CR.Right, CR.Top);

      OffsetRect(CR, 0, 4);

      Inc(T, 9);
      if IsRectEmpty(CR) then
        Exit;
    end;
  end;

  if FCustomColorList.Count > 0 then
  begin
    SelIndex := -1;
    if (FFocusedItem > -1) and (FClickedItem <> MOREBUTTON_INDEX) and
      (FFocusedItem >= CUSTOMCOLORS_BASE) then
      SelIndex := FFocusedItem - CUSTOMCOLORS_BASE;

    DrawColors(FCustomColorList, CR, SelIndex, Cw, T);
  end;
end;

function TSCCustomColorbox.GetAutoCaption: String;
begin
  Result := FAutoCaption;
  if Result = '' then
    Result := 'Automatic';
end;

function TSCCustomColorbox.GetBaseColor(Index: Integer): TColor;
begin
  Result := -1;
  if (Index > -1) and (Index < FBaseColorList.Count) then
    Result := FBaseColorList[Index];
end;

function TSCCustomColorbox.GetButtonHeight: Integer;
begin
  Result := 24;
end;

function TSCCustomColorbox.GetCellWidth: Integer;
begin
  Result := FCellSize + 6;
end;

function TSCCustomColorbox.GetCustomColor(Index: Integer): TColor;
begin
  Result := -1;
  if (Index > -1) and (Index < FCustomColorList.Count) then
    Result := FCustomColorList[Index];
end;

function TSCCustomColorbox.ItemAtPos(X, Y: Integer): Integer;

  function GetCellAtPos(L: TSCIntList; CR: TRect; Cw: Integer; T: Integer; P: TPoint): Integer;
  var
    R: TRect;
    I: Integer;
  begin
    Result := -1;
    if IsRectEmpty(CR) or (T > CR.Bottom) or (L.Count = 0) then
      Exit;

    OffsetRect(CR, 0, -CR.Top + T);
    if IsRectEmpty(CR) then
      Exit;

    R := CR;

    R.Right  := R.Left + Cw;
    R.Bottom := R.Top + Cw;

    if R.Top < CR.Bottom then
      for I := 0 to L.Count-1 do
      begin
        if PtInRect(R, P) then
        begin
          Result := I;
          Exit;
        end;

        OffsetRect(R, Cw, 0);

        if (R.Right > CR.Right) and (I < L.Count-1) then
        begin
          R.Left  := CR.Left;
          R.Right := R.Left + Cw;

          OffsetRect(R, 0, Cw);
          if R.Top >= CR.Bottom then
            Exit;
        end;
      end;
  end;

var
  P: TPoint;
  CR, R, R2: TRect;
  T, TempT, Bh, Cw,
  TempI, BaseCnt, SysCnt,
  WebCnt, CustCnt: Integer;
begin
  Result := -1;

  CR := GetClientRect;
  InflateRect(CR, -2, -2);

  P  := Point(X, Y);
  if IsRectEmpty(CR) or not PtInRect(CR, P) then
    Exit;

  Bh := GetButtonHeight;

  T := CR.Top;
  if sccoShowAutoColor in FOptions then
  begin
    Inc(T, Bh + 2);

    R := CR;
    R.Bottom := R.Top + Bh;

    if PtInRect(R, P) then
    begin
      Result := AUTOCOLOR_INDEX;
      Exit;
    end;
  end;

  Cw := GetCellWidth;

  BaseCnt := FBaseColorList.Count;
  SysCnt  := FSystemColorList.Count;
  WebCnt  := FWebSafeColorList.Count;
  CustCnt := FCustomColorList.Count;

  if BaseCnt > 0 then
  begin
    TempT := T;

    TempI := BaseCnt div FColumnCount;
    if (BaseCnt mod FColumnCount) <> 0 then
      Inc(TempI);

    Inc(T, TempI*Cw);

    R := CR;
    R.Top := TempT;
    R.Bottom := T;

    IntersectRect(R2, R, CR);
    if IsRectEmpty(R2) then
      Exit;

    if PtInRect(R, P) then
    begin
      TempI := GetCellAtPos(FBaseColorList, CR, Cw, TempT, P);
      if TempI > -1 then
        Result := BASICCOLORS_BASE + TempI;
        
      Exit;
    end;

    if (SysCnt > 0) or (CustCnt > 0) or (WebCnt > 0) then
      Inc(T, 9);
  end;

  if SysCnt > 0 then
  begin
    TempT := T;
    
    TempI := SysCnt div FColumnCount;
    if (SysCnt mod FColumnCount) <> 0 then
      Inc(TempI);

    Inc(T, TempI*Cw);

    R := CR;
    R.Top := TempT;
    R.Bottom := T;

    IntersectRect(R2, R, CR);
    if IsRectEmpty(R2) then
      Exit;

    if PtInRect(R, P) then
    begin
      TempI := GetCellAtPos(FSystemColorList, CR, Cw, TempT, P);
      if TempI > -1 then
        Result := SYSTEMCOLORS_BASE + TempI;

      Exit;
    end;

    if (CustCnt > 0) or (WebCnt > 0) then
      Inc(T, 9);
  end;

  if WebCnt > 0 then
  begin
    TempT := T;
    
    TempI := WebCnt div FColumnCount;
    if (WebCnt mod FColumnCount) <> 0 then
      Inc(TempI);

    Inc(T, TempI*Cw);

    R := CR;
    R.Top := TempT;
    R.Bottom := T;

    IntersectRect(R2, R, CR);
    if IsRectEmpty(R2) then
      Exit;

    if PtInRect(R, P) then
    begin
      TempI := GetCellAtPos(FWebSafeColorList, CR, Cw, TempT, P);
      if TempI > -1 then
        Result := WEBSAFECOLORS_BASE + TempI;

      Exit;
    end;

    if CustCnt > 0 then
      Inc(T, 9);
  end;

  if CustCnt > 0 then
  begin
    TempT := T;
    
    TempI := CustCnt div FColumnCount;
    if (CustCnt mod FColumnCount) <> 0 then
      Inc(TempI);

    Inc(T, TempI*Cw);

    R := CR;
    R.Top := TempT;
    R.Bottom := T;

    IntersectRect(R2, R, CR);
    if IsRectEmpty(R2) then
      Exit;

    if PtInRect(R, P) then
    begin
      TempI := GetCellAtPos(FCustomColorList, CR, Cw, TempT, P);
      if TempI > -1 then
        Result := CUSTOMCOLORS_BASE + TempI;

      Exit;
    end;
  end;

  if sccoShowMoreButton in FOptions then
  begin
    if (sccoShowAutoColor in FOptions) or (BaseCnt > 0) or
      (SysCnt > 0) or (WebCnt > 0) or (CustCnt > 0) then
      Inc(T, 2);

    R := CR;

    R.Bottom := R.Top + Bh;
    OffsetRect(R, 0, -R.Left + T);

    if PtInRect(R, P) then
    begin
      R2 := R;

      InflateRect(R2, -3, -2);
      if FStyle in [sccbDefaultbox, sccbMetalbox] then
        InflateRect(R2, 1, 1);

      Dec(R2.Right, R.Bottom - R.Top);
      if FStyle = sccbOfficeXPbox then
        InflateRect(R2, 3, 2);

      if not IsRectEmpty(R2) and PtInRect(R2, P) then
      begin
        Result := MOREBUTTON_INDEX;
        Exit;
      end;

      R2 := R;
      R2.Left := R2.Right - (R.Bottom - R.Top);

      IntersectRect(R2, R2, CR);
      if not IsRectEmpty(R2) and PtInRect(R2, P) then
      begin
        Result := MORECOLOR_INDEX;
        Exit;
      end;
    end;
  end;
end;

function TSCCustomColorbox.GetMaxColumnCount: Integer;
begin
  Result := 1;
  if sccoShowBasicColors in FOptions then
    Result := FBaseColorList.Count;

  if (sccoShowSystemColors in FOptions) and (FSystemColorList.Count > Result) then
    Result := FSystemColorList.Count;

  if (sccoShowWebSafeColors in FOptions) and (FWebSafeColorList.Count > Result) then
    Result := FWebSafeColorList.Count;

  if (sccoShowCustomColors in FOptions) and (FCustomColorList.Count > Result) then
    Result := FCustomColorList.Count;

  if Result < 1 then Result := 1;
end;

function TSCCustomColorbox.GetMoreCaption: String;
begin
  Result := FMoreCaption;
  if Result = '' then
    Result := 'More Colors...';
end;

function TSCCustomColorbox.GetSystemColor(Index: Integer): TColor;
begin
  Result := -1;
  if (Index > -1) and (Index < FSystemColorList.Count) then
    Result := FSystemColorList[Index];
end;

function TSCCustomColorbox.GetWebSafeColor(Index: Integer): TColor;
begin
  Result := -1;
  if (Index > -1) and (Index < FWebSafeColorList.Count) then
    Result := FWebSafeColorList[Index];
end;

procedure TSCCustomColorbox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  FClickedItem := -1;
  FFocusedItem := -1;

  if ClickFocus and CanFocus and not Focused then
    Exit;

  HideHintWindow;

  FClickedItem := ItemAtPos(X, Y);
  FFocusedItem := FClickedItem;

  if FClickedItem > -1 then
    Invalidate;
end;

procedure TSCCustomColorbox.MouseInControlChanged;
var
  P: TPoint;
  Index: Integer;
begin
  if MouseInControl then
  begin
    HideHintWindow;

    if GetCursorPos(P) then
    begin
      Index := FFocusedItem;
      P := Self.ScreenToClient(P);

      FFocusedItem := ItemAtPos(P.x, P.y);
      if Index <> FFocusedItem then
        Invalidate;

      if FFocusedItem >= BASICCOLORS_BASE then
      begin
        P := Self.ClientToScreen(P);
        ShowHintWindow(P);
      end;
    end;
  end else
  if FFocusedItem > -1 then
  begin
    HideHintWindow;

    FFocusedItem := -1;
    Invalidate;
  end;
end;

procedure TSCCustomColorbox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  OldFocus: Integer;
begin
  OldFocus := FFocusedItem;

  FFocusedItem := ItemAtPos(X, Y);
  if (OldFocus <> FFocusedItem) and (not MouseIsDown or (FClickedItem > -1) and
    ((FClickedItem <> MOREBUTTON_INDEX) or (OldFocus = MOREBUTTON_INDEX) or
    (FFocusedItem = MOREBUTTON_INDEX))) then
  begin
    Invalidate;

    P := Point(X, Y);
    P := Self.ClientToScreen(P);

    ShowHintWindow(P);
  end else
  if (FClickedItem = MOREBUTTON_INDEX) or
    ((FFocusedItem <> MORECOLOR_INDEX) and (FFocusedItem < BASICCOLORS_BASE)) then
    HideHintWindow;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomColorbox.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  C: TColor;
  Index, OldClick, OldFocus: Integer;
begin
  OldClick := FClickedItem;
  OldFocus := FFocusedItem;

  FFocusedItem := ItemAtPos(X, Y);
  FClickedItem := -1;

  if ((FStyle in [sccbDefaultbox, sccbMetalbox]) and (OldClick = MOREBUTTON_INDEX) and
    (OldClick = FFocusedItem)) or (not (FStyle in [sccbDefaultbox, sccbMetalbox]) and
    (FFocusedItem = MOREBUTTON_INDEX) and (OldClick > -1)) then
  begin
    Invalidate;
    DoMoreButtonClick;
  end else
  if (OldClick > -1) and (FFocusedItem > -1) and
    (OldClick <> MOREBUTTON_INDEX) and (FFocusedItem <> MOREBUTTON_INDEX) then
  begin
    if FFocusedItem = AUTOCOLOR_INDEX then
    begin
      if (sccoShowAutoColor in FOptions) and (FSelectedColor <> FAutoColor) then
      begin
        SetSelectedColor(FAutoColor);
        DoBoxClick;
      end;
    end else
    if FFocusedItem = MORECOLOR_INDEX then
    begin
      if (sccoShowMoreButton in FOptions) and (FSelectedColor <> FMoreColor) then
      begin
        SetSelectedColor(FMoreColor);
        DoBoxClick;
      end;
    end else
    if (FFocusedItem >= BASICCOLORS_BASE) and (FFocusedItem < SYSTEMCOLORS_BASE) then
    begin
      if sccoShowBasicColors in FOptions then
      begin
        Index := FFocusedItem - BASICCOLORS_BASE;

        if (Index > -1) and (Index < FBaseColorList.Count) then
        begin
          C := FBaseColorList[Index];

          if FSelectedColor <> C then
          begin
            SetSelectedColor(C);
            DoBoxClick;
          end;
        end;
      end;
    end else
    if (FFocusedItem >= SYSTEMCOLORS_BASE) and (FFocusedItem < WEBSAFECOLORS_BASE) then
    begin
      if sccoShowSystemColors in FOptions then
      begin
        Index := FFocusedItem - SYSTEMCOLORS_BASE;

        if (Index > -1) and (Index < FSystemColorList.Count) then
        begin
          C := FSystemColorList[Index];

          if FSelectedColor <> C then
          begin
            SetSelectedColor(C);
            DoBoxClick;
          end;
        end;
      end;
    end else
    if (FFocusedItem >= WEBSAFECOLORS_BASE) and (FFocusedItem < CUSTOMCOLORS_BASE) then
    begin
      if sccoShowWebSafeColors in FOptions then
      begin
        Index := FFocusedItem - WEBSAFECOLORS_BASE;

        if (Index > -1) and (Index < FWebSafeColorList.Count) then
        begin
          C := FWebSafeColorList[Index];

          if FSelectedColor <> C then
          begin
            SetSelectedColor(C);
            DoBoxClick;
          end;
        end;
      end;
    end else
    if FFocusedItem >= CUSTOMCOLORS_BASE then
    begin
      if sccoShowCustomColors in FOptions then
      begin
        Index := FFocusedItem - CUSTOMCOLORS_BASE;

        if (Index > -1) and (Index < FCustomColorList.Count) then
        begin
          C := FCustomColorList[Index];

          if FSelectedColor <> C then
          begin
            SetSelectedColor(C);
            DoBoxClick;
          end;
        end;
      end;
    end;
  end;

  if (OldFocus < -1) and (OldFocus <> FFocusedItem) and (OldClick <> MOREBUTTON_INDEX) then
    Invalidate;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomColorbox.Paint;
var
  CR: TRect;
begin
  if not HandleAllocated then
    Exit;

  CR := GetClientRect;
  if not IsRectEmpty(CR) then
  begin
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := DefaultBlendedColor(Self.Color);

      FillRect(CR);
    end;

    if Transparent then
      PaintParentOn(Canvas);

    DrawPicture(Canvas);

    DrawColorCells;
    DrawAutoButton;
    DrawMoreButton;
  end;
end;

procedure TSCCustomColorbox.RefreshColors;
var
  L: TSCIntList;
  I, K, C: Integer;
begin
  L := TSCIntList.Create;
  try
    FBaseColorList.Clear;
    if sccoShowBasicColors in FOptions then
    begin
      if FBasicColorType = scbtWordFont then
      begin
        for I := Low(scBaseColors) to High(scBaseColors) do
        begin
          C := scBaseColors[I].Value;
          
          L.Add(C);
          FBaseColorList.Add(C);
        end;
      end else
      begin
        K := Low(scColors) + 15;
        for I := Low(scColors) to K do
        begin
          C := scColors[I].Value;

          L.Add(C);
          FBaseColorList.Add(C);
        end;
      end;
    end;

    FSystemColorList.Clear;
    if sccoShowSystemColors in FOptions then
      for I := Low(scSystemColors) to High(scSystemColors) do
      begin
        C := scSystemColors[I].Value;
        if ((C = clNone) and not (sccoShowNoneColor in FOptions)) or
          ((sccoShowUniqueColors in FOptions) and (L.IndexOf(C) > -1)) then
          Continue;

        L.Add(C);
        FSystemColorList.Add(C);
      end;

    FWebSafeColorList.Clear;
    if sccoShowWebSafeColors in FOptions then
      for I := Low(scWebSafeColorsForBox) to High(scWebSafeColorsForBox) do
      begin
        C := scWebSafeColorsForBox[I].Value;
        if ((C = clNone) and not (sccoShowNoneColor in FOptions)) or
          ((sccoShowUniqueColors in FOptions) and (L.IndexOf(C) > -1)) then
          Continue;

        L.Add(C);
        FWebSafeColorList.Add(C);
      end;

    FCustomColorList.Clear;
    if sccoShowCustomColors in FOptions then
    begin
      for I := 0 to FCustomColors.Count-1 do
      begin
        C := FCustomColors[I].Color;
        if ((C = clNone) and not (sccoShowNoneColor in FOptions)) or
          ((sccoShowUniqueColors in FOptions) and (L.IndexOf(C) > -1)) then
          Continue;

        L.Add(C);
        FCustomColorList.Add(C);
      end;
    end;

    if L.IndexOf(FSelectedColor) = -1 then
      FMoreColor := FSelectedColor;
  finally
    L.Free;
  end;
  
  Invalidate;
end;

procedure TSCCustomColorbox.SetAutoCaption(const Value: String);
begin
  if FAutoCaption <> Value then
  begin
    FAutoCaption := Value;
    if sccoShowAutoColor in FOptions then
      Invalidate;
  end;
end;

procedure TSCCustomColorbox.SetAutoColor(Value: TColor);
begin
  if FAutoColor <> Value then
  begin
    FAutoColor := Value;
    if sccoShowAutoColor in FOptions then
      Invalidate;
  end;
end;

procedure TSCCustomColorbox.SetCellSize(Value: Integer);
var
  W, OldVal: Integer;
begin
  if Value < 6 then Value := 6;
  if Value > 40 then Value := 40;

  if FCellSize <> Value then
  begin
    OldVal := FCellSize;
    FCellSize := Value;

    if not IsLoading then
    begin
      if AutoSize then
      begin
        W := Width;
        Inc(W, FColumnCount*(FCellSize - OldVal));

        Width := W;
      end else
        UpdateColumnCount;
    end;
  end;
end;

procedure TSCCustomColorbox.SetColumnCount(Value: Integer);
var
  Bw, TempI, Cnt: Integer;
begin
  if Value < 1 then Value := 1;

  Cnt := GetMaxColumnCount;
  if Value > Cnt then Value := Cnt;

  if FColumnCount <> Value then
  begin
    FColumnCount := Value;

    if AutoSize then
    begin
      if not IsLoading then
      begin
        if FCellSize < 6 then FCellSize := 6;
        if FCellSize > 40 then FCellSize := 40;

        Bw  := 2*(GetBorderSize + BorderWidth + GetInnerBorderSize + 2);

        TempI := (Width - ClientWidth) + 4;
        if TempI > Bw then Bw := TempI;

        Width := (FColumnCount*GetCellWidth) + Bw;
      end;

      AdjustBounds;
    end;  
  end;
end;

procedure TSCCustomColorbox.SetCustomColors(Value: TSCColorboxItems);
begin
  FCustomColors.Assign(Value);
end;

procedure TSCCustomColorbox.SetMoreCaption(const Value: String);
begin
  if FMoreCaption <> Value then
  begin
    FMoreCaption := Value;
    if sccoShowMoreButton in FOptions then
      Invalidate;
  end;
end;

procedure TSCCustomColorbox.SetMoreColor(Value: TColor);
var
  OldCl: TColor;
  SelChanged: Boolean;
begin
  if FMoreColor <> Value then
  begin
    OldCl := FMoreColor;
    FMoreColor := Value;

    SelChanged := not (IsLoading or IsDesigning) and
      (sccoShowMoreButton in FOptions) and (FSelectedColor = OldCl);

    if not SelChanged then
      Invalidate
    else
      SetSelectedColor(Value);
  end;
end;

procedure TSCCustomColorbox.SetOptions(Value: TSCColorboxOptions);
var
  OldCnt: Integer;
begin
  if FOptions <> Value then
  begin
    OldCnt := FBaseColorList.Count + FSystemColorList.Count +
      FWebSafeColorList.Count + FCustomColorList.Count;

    FOptions := Value;

    RefreshColors;

    if AutoSize then
    begin
      if OldCnt = 0 then SetColumnCount(8);
      AdjustBounds;
    end else
      UpdateColumnCount;
  end;
end;

procedure TSCCustomColorbox.SetSelectedColor(Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;

    Invalidate;
    DoSelectedColorChange;
  end;
end;

procedure TSCCustomColorbox.SetStyle(Value: TSCColorBoxStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TSCCustomColorbox.StopTracking;
begin
  HideHintWindow;

  FFocusedItem := -1;
  FClickedItem := -1;
  Invalidate;
  
  inherited StopTracking;
end;

function TSCCustomColorbox.SystemColorCount: Integer;
begin
  Result := FSystemColorList.Count;
end;

function TSCCustomColorbox.WebSafeColorCount: Integer;
begin
  Result := FWebSafeColorList.Count;
end;

procedure TSCCustomColorbox.UpdateColumnCount;
var
  ColCnt, Bw, TempI: Integer;
begin
  if not AutoSize and HandleAllocated then
  begin
    Bw  := 2*(GetBorderSize + BorderWidth + GetInnerBorderSize + 2);

    TempI := (Width - ClientWidth) + 4;
    if TempI > Bw then Bw := TempI;

    ColCnt := (Width - Bw) div GetCellWidth;

    if ColCnt < 1 then ColCnt := 1;

    TempI := GetMaxColumnCount;
    if ColCnt > TempI then ColCnt := TempI;

    SetColumnCount(ColCnt);
  end;
end;

procedure TSCCustomColorbox.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateColumnCount;
end;

function TSCCustomColorbox.ItemRect(Index: Integer): TRect;
var
  CR: TRect;
  T, L, Bh, Cw,
  TempI, BaseCnt,
  SysCnt, WebCnt, CustCnt: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  CR := GetClientRect;

  InflateRect(CR, -2, -2);
  if IsRectEmpty(CR) then
    Exit;

  Bh := GetButtonHeight;
  if Bh < 0 then Bh := 0;

  if Index = AUTOCOLOR_INDEX then
  begin
    if (Bh > 0) and (sccoShowAutoColor in FOptions) then
    begin
      Result := CR;
      Result.Bottom := Result.Top + Bh;

      IntersectRect(Result, Result, CR);
    end;

    Exit;
  end;

  Cw := GetCellWidth;

  BaseCnt := FBaseColorList.Count;
  SysCnt  := FSystemColorList.Count;
  WebCnt  := FWebSafeColorList.Count;
  CustCnt := FCustomColorList.Count;

  if sccoShowAutoColor in FOptions then
  begin
    Inc(CR.Top, Bh);

    if (sccoShowMoreButton in FOptions) or (BaseCnt > 0) or
      (SysCnt > 0) or (WebCnt > 0) or (CustCnt > 0) then
      Inc(CR.Top, 2);

    if (BaseCnt > 0) or (SysCnt > 0) or (WebCnt > 0) or (CustCnt > 0) then
      Inc(CR.Top, 2);

    if IsRectEmpty(CR) then
      Exit;
  end;

  if (Index >= BASICCOLORS_BASE) and (Index < SYSTEMCOLORS_BASE) then
  begin
    Dec(Index, BASICCOLORS_BASE);

    if (Index > -1) and (Index < BaseCnt) then
    begin
      L := Index mod FColumnCount;
      T := Index div FColumnCount;

      Result.Left   := CR.Left + (L*Cw);
      Result.Right  := Result.Left + Cw;

      Result.Top    := CR.Top + (T*Cw);
      Result.Bottom := Result.Top + Cw;
    end;

    Exit;
  end;

  if BaseCnt > 0 then
  begin
    TempI := BaseCnt div FColumnCount;
    if (BaseCnt mod FColumnCount) <> 0 then
      Inc(TempI);

    Inc(CR.Top, TempI*Cw);
    if (SysCnt > 0) or (CustCnt > 0) or (WebCnt > 0) then
      Inc(CR.Top, 9);
  end;

  if IsRectEmpty(CR) then
    Exit;

  if (Index >= SYSTEMCOLORS_BASE) and (Index < WEBSAFECOLORS_BASE) then
  begin
    Dec(Index, SYSTEMCOLORS_BASE);

    if (Index > -1) and (Index < SysCnt) then
    begin
      L := Index mod FColumnCount;
      T := Index div FColumnCount;

      Result.Left   := CR.Left + (L*Cw);
      Result.Right  := Result.Left + Cw;

      Result.Top    := CR.Top + (T*Cw);
      Result.Bottom := Result.Top + Cw;
    end;

    Exit;
  end;

  if SysCnt > 0 then
  begin
    TempI := SysCnt div FColumnCount;
    if (SysCnt mod FColumnCount) <> 0 then
      Inc(TempI);

    Inc(CR.Top, TempI*Cw);
    if (CustCnt > 0) or (WebCnt > 0) then
      Inc(CR.Top, 9);
  end;

  if IsRectEmpty(CR) then
    Exit;

  if (Index >= WEBSAFECOLORS_BASE) and (Index < CUSTOMCOLORS_BASE) then
  begin
    Dec(Index, WEBSAFECOLORS_BASE);

    if (Index > -1) and (Index < WebCnt) then
    begin
      L := Index mod FColumnCount;
      T := Index div FColumnCount;

      Result.Left   := CR.Left + (L*Cw);
      Result.Right  := Result.Left + Cw;

      Result.Top    := CR.Top + (T*Cw);
      Result.Bottom := Result.Top + Cw;
    end;

    Exit;
  end;

  if WebCnt > 0 then
  begin
    TempI := WebCnt div FColumnCount;
    if (WebCnt mod FColumnCount) <> 0 then
      Inc(TempI);

    Inc(CR.Top, TempI*Cw);
    if CustCnt > 0 then
      Inc(CR.Top, 9);
  end;

  if IsRectEmpty(CR) then
    Exit;

  if Index > CUSTOMCOLORS_BASE then
  begin
    Dec(Index, CUSTOMCOLORS_BASE);

    if (Index > -1) and (Index < CustCnt) then
    begin
      L := Index mod FColumnCount;
      T := Index div FColumnCount;

      Result.Left   := CR.Left + (L*Cw);
      Result.Right  := Result.Left + Cw;

      Result.Top    := CR.Top + (T*Cw);
      Result.Bottom := Result.Top + Cw;
    end;

    Exit;
  end;

  if CustCnt > 0 then
  begin
    TempI := CustCnt div FColumnCount;
    if (CustCnt mod FColumnCount) <> 0 then
      Inc(TempI);

    Inc(CR.Top, TempI*Cw);
  end;

  if IsRectEmpty(CR) then
    Exit;

  if (sccoShowMoreButton in FOptions) and ((Index = MORECOLOR_INDEX) or
    (Index = MOREBUTTON_INDEX)) then
  begin
    if (sccoShowAutoColor in FOptions) or (BaseCnt > 0) or
      (SysCnt > 0) or (WebCnt > 0) or (CustCnt > 0) then
      Inc(CR.Top, 2);

    if (BaseCnt > 0) or (SysCnt > 0) or (WebCnt > 0) or (CustCnt > 0) then
      Inc(CR.Top, 2);

    if Index = MOREBUTTON_INDEX then
    begin
      Result := CR;
      Result.Bottom := Result.Top + Bh;

      TempI := Result.Bottom - Result.Top;
      IntersectRect(Result, Result, CR);

      if not IsRectEmpty(Result) then
      begin
        if FStyle <> sccbOfficeXPbox then
          InflateRect(Result, -3, -2);

        Dec(Result.Right, TempI);
      end;
    end else
    if Index = MORECOLOR_INDEX then
    begin
      Result := CR;
      Result.Bottom := Result.Top + Bh;

      TempI := Result.Bottom - Result.Top;
      IntersectRect(Result, Result, CR);

      if not IsRectEmpty(Result) then
        Result.Left := Result.Right - TempI;
    end;
  end;
end;

procedure TSCCustomColorbox.ConstrainedResize(var MinWidth, MinHeight,
  MaxWidth, MaxHeight: Integer);
var
  W, H: Integer;
begin
  if AutoSize then
  begin
    W := MinWidth;
    if W = 0 then W := Width;

    H := MinHeight;
    if H = 0 then H := Height;

    CanAutoSize(W, H);

    if MinWidth > 0 then MinWidth := W;
    if MinHeight > 0 then MinHeight := H;
  end;

  inherited ConstrainedResize(MinWidth, MinHeight, MaxWidth, MaxHeight);
end;

procedure TSCCustomColorbox.SetBasicColorType(Value: TSCBasicColorType);
begin
  if FBasicColorType <> Value then
  begin
    FBasicColorType := Value;
    
    if sccoShowBasicColors in FOptions then
    begin
      RefreshColors;

      if AutoSize then
        AdjustBounds
      else
        UpdateColumnCount;
    end;    
  end;
end;

procedure TSCCustomColorbox.DoMoreButtonClick;
begin
  if Assigned(FOnMoreButtonClick) then
    FOnMoreButtonClick(Self);
end;

procedure TSCCustomColorbox.DoSelectedColorChange;
begin
  if Assigned(FOnSelectedColorChange) then
    FOnSelectedColorChange(Self);
end;

procedure TSCCustomColorbox.DoShowColorHint(C: TColor; var H: String);
begin
  if Assigned(FOnShowColorHintEvent) then
    FOnShowColorHintEvent(Self, C, H);
end;

procedure TSCCustomColorbox.HideHintWindow;
begin
  if (FHintTimer <> 0) and HandleAllocated then
  begin
    KillTimer(Handle, FHintTimer);
    FHintTimer := 0;
  end;

  if FHintWnd <> nil then
  begin
    FHintWnd.ReleaseHandle;
    FHintWnd := nil;
  end;
end;

procedure TSCCustomColorbox.ShowHintWindow(P: TPoint);
var
  C: TColor;
  P2: TPoint;
  CR, R: TRect;
  AllowShow: Boolean;
  I, Index: Integer;
  HintStr: String;
  {$IFDEF SC_DELPHI4_AND_EARLY}
  NonClientMetrics: TNonClientMetrics;
  {$ENDIF}
begin
  if IsDesigning or not (FShowColorHints and HandleAllocated) then
    Exit;

  AllowShow := False;
  try
    P2 := Self.ScreenToClient(P);

    CR := GetClientRect;
    if IsRectEmpty(CR) or not PtInRect(CR, P2) then
      Exit;

    Index := ItemAtPos(P2.X, P2.Y);
    
    if (Index >= BASICCOLORS_BASE) or
      ((sccoShowMoreButton in FOptions) and (Index = MORECOLOR_INDEX)) then
    begin
      if Index = MORECOLOR_INDEX then
        C := FMoreColor
      else
      if (Index >= BASICCOLORS_BASE) and (Index < SYSTEMCOLORS_BASE) then
      begin
        I := Index - BASICCOLORS_BASE;
        if (I > -1) and (I < FBaseColorList.Count) then
          C := FBaseColorList[I]
        else
          Exit;
      end else
      if (Index >= SYSTEMCOLORS_BASE) and (Index < WEBSAFECOLORS_BASE) then
      begin
        I := Index - SYSTEMCOLORS_BASE;
        if (I > -1) and (I < FSystemColorList.Count) then
          C := FSystemColorList[I]
        else
          Exit;
      end else
      if (Index >= WEBSAFECOLORS_BASE) and (Index < CUSTOMCOLORS_BASE) then
      begin
        I := Index - WEBSAFECOLORS_BASE;
        if (I > -1) and (I < FWebSafeColorList.Count) then
          C := FWebSafeColorList[I]
        else
          Exit;
      end else
      begin
        I := Index - CUSTOMCOLORS_BASE;
        if (I > -1) and (I < FCustomColorList.Count) then
          C := FCustomColorList[I]
        else
          Exit;
      end;

      HintStr := '';
      DoShowColorHint(C, HintStr);

      if HintStr <> '' then
      begin
        AllowShow := True;
        scApplicationCancelHint;

        if FHintWnd = nil then
          FHintWnd := THintWindow.Create(Self);

        with FHintWnd do
        begin
          Color := Application.HintColor;
          {$IFDEF SC_DELPHI4_AND_EARLY}
          NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
          if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
            Canvas.Font.Handle := CreateFontIndirect(NonClientMetrics.lfStatusFont)
          else
            Canvas.Font.Size := 8;
          {$ELSE}
          Canvas.Font.Assign(Screen.HintFont);
          {$ENDIF}
        end;

        R := ItemRect(Index);
        if not IsRectEmpty(R) then
        begin
          R.TopLeft := Self.ClientToScreen(R.TopLeft);
          R.BottomRight := Self.ClientToScreen(R.BottomRight);

          P.x := R.Left;
          P.y := R.Bottom - 2 + (GetCellWidth div 2);
        end;

        R := FHintWnd.CalcHintRect(Screen.Width, HintStr, nil);
        OffsetRect(R, -R.Left + P.x, -R.Top + P.y);

        if R.Right > Screen.Width then
          OffsetRect(R, Screen.Width - R.Right, 0);

        if R.Left < 0 then
          OffsetRect(R, -R.Left, 0);

        if R.Bottom > Screen.Height then
          OffsetRect(R, 0, Screen.Height - R.Bottom);

        if R.Top < 0 then
          OffsetRect(R, 0, -R.Top);

        GetWindowRect(FHintWnd.Handle, CR);

        if not IsWindowVisible(FHintWnd.Handle) or
          not ((R.Left = CR.Left) and (R.Top = CR.Top)) then
        begin
          FHintWnd.ActivateHint(R, HintStr);

          if (FHintTimer <> -1) and HandleAllocated then
          begin
            KillTimer(Handle, FHintTimer);
            FHintTimer := 0;
          end;

          FHintTimer := SetTimer(Handle, SC_CLBOXHINT_TIMERID,
            scApplicationHintHidePause, nil);
        end;
      end;
    end;
  finally
    if not AllowShow then
      HideHintWindow;
  end;
end;

procedure TSCCustomColorbox.SetShowColorHints(Value: Boolean);
begin
  if FShowColorHints <> Value then
  begin
    FShowColorHints := Value;
    if not Value then
      HideHintWindow;
  end;
end;

procedure TSCCustomColorbox.WMTimer(var Message: TWMTimer);
begin
  inherited;

  if HandleAllocated and (FHintTimer <> 0) and
    (Message.TimerID = SC_CLBOXHINT_TIMERID) then
    HideHintWindow;
end;

procedure TSCCustomColorbox.CMHintShow(var Message: TMessage);
begin
  inherited;

  if (Message.Result = 0) and (FHintWnd <> nil) then
    Message.Result := 1;
end;

procedure TSCCustomColorbox.DoBoxClick;
begin
  if Assigned(FOnBoxClick) then
    FOnBoxClick(Self);
end;

function TSCCustomColorbox.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCColorboxBorderProps;
end;

procedure TSCCustomColorbox.SystemColorsChanged;
begin
  RefreshColors;
  inherited SystemColorsChanged;
end;

procedure TSCCustomColorbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomColorbox then
  begin
    with TSCCustomColorbox(Source) do
    begin
      Self.AutoColor := AutoColor;
      Self.AutoCaption := AutoCaption;
      Self.BasicColorType := BasicColorType;
      Self.CellSize := CellSize;
      Self.ColumnCount := ColumnCount;
      Self.CustomColors := CustomColors;
      Self.MoreColor := MoreColor;
      Self.MoreCaption := MoreCaption;
      Self.Options := Options;
      Self.SelectedColor := SelectedColor;
      Self.ShowColorHints := ShowColorHints;
      Self.Style := Style;
    end;
  end;
end;

{ TSCColorboxBorderProps }

constructor TSCColorboxBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccbFlat;
end;

end.
