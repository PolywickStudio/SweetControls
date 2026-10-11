{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCCheckGroup;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, SCCommon, SCConsts, SCControl, SCStdControls;

type
  TSCCustomCheckGroup = class;

  TSCCheckGroupButton = class(TCollectionItem)
  private
    FCaption: string;
    FData: Pointer;
    FEnabled: Boolean;
    FState: TSCCheckState;
    FTag: Integer;
    FVisible: Boolean;
    FDestroying: Boolean;
    procedure SetCaption(const Value: String);
    function  GetChecked: Boolean;
    procedure SetChecked(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetState(Value: TSCCheckState);
    procedure SetVisible(Value: Boolean);
  protected
    function  GetGroup: TSCCustomCheckGroup;
    function  GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Data: Pointer read FData write FData;
    property Destroying: Boolean read FDestroying;
  published
    property Caption: string read FCaption write SetCaption;
    property Checked: Boolean read GetChecked write SetChecked default False;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property State: TSCCheckState read FState write SetState default sccbUnchecked;
    property Tag: Integer read FTag write FTag default 0;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TSCCheckGroupButtons = class(TCollection)
  private
    FOwner: TSCCustomCheckGroup;
    function  GetItem(Index: Integer): TSCCheckGroupButton;
    procedure SetItem(Index: Integer; Value: TSCCheckGroupButton);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TSCCustomCheckGroup); virtual;
    function Add: TSCCheckGroupButton;
    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomCheckGroup read FOwner;
    {$ENDIF}
    property Items[Index: Integer]: TSCCheckGroupButton read GetItem write SetItem; default;
  end;

  TSCItemChangedEvent = procedure(Sender: TObject; Button: TSCCheckGroupButton) of object;

  TSCCustomCheckGroup = class(TSCCustomGroupBox)
  private
    FAllowGrayed: Boolean;
    FColumns: Integer;
    FBoxCheckedColor: TColor;
    FBoxGrayedColor: TColor;
    FBoxFrameColor: TColor;
    FBoxToggleColor: TColor;
    FBoxUncheckedColor: TColor;
    FEndEllipsis: Boolean;
    FHighlightColor: TColor;
    FHottrackColor: TColor;
    FImageChecked: TImageIndex;
    FImageGrayed: TImageIndex;
    FImageToggle: TImageIndex;
    FImageUnchecked: TImageIndex;
    FImageMark: TImageIndex;
    FImageMarkGrayed: TImageIndex;
    FItemColor: TColor;
    FItemDisabledColor: TColor;
    FItemHotColor: TColor;
    FItemHotUnderline: Boolean;
    FItemHottrack: Boolean;
    FFocusedIndex: Integer;
    FLayout: TSCCheckboxLayout;
    FMarkColor: TColor;
    FMarkGrayedColor: TColor;
    FMultiline: Boolean;
    FItems: TSCCheckGroupButtons;
    FShowFocus: Boolean;
    FStyle: TSCCheckboxStyle;
    FHotIndex: Integer;
    FDownIndex: Integer;
    FSpaceDown: Integer;
    FOfficeMarkColor: TColor;
    FVisibleItemCount: Integer;
    FClickCount: Integer;
    FOnItemChanged: TSCItemChangedEvent;
    procedure SetAllowGrayed(Value: Boolean);
    procedure SetColumns(Value: Integer);
    procedure SetBoxCheckedColor(Value: TColor);
    procedure SetBoxGrayedColor(Value: TColor);
    procedure SetBoxFrameColor(Value: TColor);
    procedure SetBoxToggleColor(Value: TColor);
    procedure SetBoxUncheckedColor(Value: TColor);
    procedure SetEndEllipsis(Value: Boolean);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHottrackColor(Value: TColor);
    procedure SetImageChecked(Value: TImageIndex);
    procedure SetImageGrayed(Value: TImageIndex);
    procedure SetImageToggle(Value: TImageIndex);
    procedure SetImageUnchecked(Value: TImageIndex);
    procedure SetImageMark(Value: TImageIndex);
    procedure SetImageMarkGrayed(Value: TImageIndex);
    procedure SetItemColor(Value: TColor);
    procedure SetItemDisabledColor(Value: TColor);
    procedure SetItemHotColor(Value: TColor);
    procedure SetItemHotUnderline(Value: Boolean);
    procedure SetItemHottrack(Value: Boolean);
    procedure SetItems(Value: TSCCheckGroupButtons);
    procedure SetLayout(Value: TSCCheckboxLayout);
    procedure SetMarkColor(Value: TColor);
    procedure SetMarkGrayedColor(Value: TColor);
    procedure SetMultiline(Value: Boolean);
    procedure SetShowFocus(Value: Boolean);
    procedure SetStyle(Value: TSCCheckboxStyle);

    procedure DoDrawMark(Index: Integer; R: TRect; AColor: TColor = clNone);
    procedure DoDrawText(Index: Integer; var R: TRect; CalcRect: Boolean = False);

    procedure DoDrawCorelCb(Index: Integer; ClientR: TRect);
    procedure DoDrawFlatCb(Index: Integer; ClientR: TRect);
    procedure DoDrawImageCb(Index: Integer; ClientR: TRect);
    procedure DoDrawMacCb(Index: Integer; ClientR: TRect);
    procedure DoDrawOfficeXPCb(Index: Integer; ClientR: TRect);
    procedure DoDrawWin2kCb(Index: Integer; ClientR: TRect);
    procedure DoDrawXPCb(Index: Integer; ClientR: TRect);
    procedure DoDrawMetalCb(Index: Integer; ClientR: TRect);

    procedure ItemStateChanged(Item: TSCCheckGroupButton);
    procedure ItemChanged(Item: TSCCheckGroupButton);
    procedure UpdateVisibleItemCount;
    function  FindEnabled(Index: Integer; BackSearch: Boolean = False): Integer;

    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure ReadState(Reader: TReader); override;

    procedure DoClick;
    procedure Click; override;
    procedure SetFocusedIndex(Value: Integer);

    procedure FocusChanged; override;
    procedure MouseInControlChanged; override;
    procedure StopTracking; override;
    procedure EnabledChanged; override;

    procedure DoItemStateChanged(Item: TSCCheckGroupButton); virtual;
    procedure ItemsChanged; dynamic;
    function  CanModify: Boolean; virtual;

    function  GetBlendValue: Word; override;

    function  GetBoxWidth: Integer;
    function  GetBoxHeight: Integer;
    function  GetBoxFaceColor(Index: Integer): TColor;

    function  SwitchState(S: TSCCheckState): TSCCheckState; virtual;
    function  GetDrawState(Index: Integer): TSCCheckState; virtual;

    procedure DrawItem(Index: Integer); virtual;

    procedure Toggle(Index: Integer); virtual;
    function  InToggle(Index: Integer): Boolean;

    function  MousePressed(Index: Integer): Boolean;
    function  MouseInItem(Index: Integer): Boolean;
    function  ItemFocused(Index: Integer): Boolean;

    function  BoxRect(R: TRect): TRect;
    function  InnerRect(R: TRect): TRect;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property AllowGrayed: Boolean read FAllowGrayed write SetAllowGrayed default False;
    property Columns: Integer read FColumns write SetColumns default 1;
    property BoxCheckedColor: TColor read FBoxCheckedColor write SetBoxCheckedColor default clWindow;
    property BoxGrayedColor: TColor read FBoxGrayedColor write SetBoxGrayedColor default clBtnFace;
    property BoxFrameColor: TColor read FBoxFrameColor write SetBoxFrameColor default clBtnShadow;
    property BoxToggleColor: TColor read FBoxToggleColor write SetBoxToggleColor default clBtnFace;
    property BoxUncheckedColor: TColor read FBoxUncheckedColor write SetBoxUncheckedColor default clWindow;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default False;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default SC_HighlightColor;
    property HottrackColor: TColor read FHottrackColor write SetHottrackColor default SC_HottrackColor;
    property ImageChecked: TImageIndex read FImageChecked write SetImageChecked default -1;
    property ImageGrayed: TImageIndex read FImageGrayed write SetImageGrayed default -1;
    property ImageToggle: TImageIndex read FImageToggle write SetImageToggle default -1;
    property ImageUnchecked: TImageIndex read FImageUnchecked write SetImageUnchecked default -1;
    property ImageMark: TImageIndex read FImageMark write SetImageMark default -1;
    property ImageMarkGrayed: TImageIndex read FImageMarkGrayed write SetImageMarkGrayed default -1;
    property ItemColor: TColor read FItemColor write SetItemColor default clNone;
    property ItemDisabledColor: TColor read FItemDisabledColor write SetItemDisabledColor default clNone;
    property ItemHotColor: TColor read FItemHotColor write SetItemHotColor default clRed;
    property ItemHotUnderline: Boolean read FItemHotUnderline write SetItemHotUnderline default True;
    property ItemHottrack: Boolean read FItemHottrack write SetItemHottrack default True;
    property Items: TSCCheckGroupButtons read FItems write SetItems;
    property Layout: TSCCheckboxLayout read FLayout write SetLayout default scclMiddle;
    property MarkColor: TColor read FMarkColor write SetMarkColor default clWindowText;
    property MarkGrayedColor: TColor read FMarkGrayedColor write SetMarkGrayedColor default clWindowText;
    property Multiline: Boolean read FMultiline write SetMultiline default False;
    property ShowFocus: Boolean read FShowFocus write SetShowFocus default True;
    property Style: TSCCheckboxStyle read FStyle write SetStyle default sccsWin2k;
    property VisibleItemCount: Integer read FVisibleItemCount;
    property OnItemChanged: TSCItemChangedEvent read FOnItemChanged write FOnItemChanged;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  GetItemRect(Index: Integer): TRect;
    function  GetItemAtPos(X, Y: Integer): Integer;
  end;

  TSCCheckGroup = class(TSCCustomCheckGroup)
  public
    property VisibleItemCount;
  published
    property Align;
    property Alignment;
    property AllowGrayed;
    property Anchors;
    property Bevel;
    property BevelEdges;
    property BevelColor;
    property BevelWidth;
    property BiDiMode;
    property BorderProps;
    property BoxCheckedColor;
    property BoxGrayedColor;
    property BoxFrameColor;
    property BoxToggleColor;
    property BoxUncheckedColor;
    property Caption;
    property CaptionBevel;
    property CaptionBevelColor;
    property CaptionBkColor;
    property CaptionFont;
    property Color;
    property Columns;
    property Constraints;
    property Cursor;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndEllipsis;
    property Font;
    property HighlightColor;
    property HottrackColor;
    property Images;
    property ImageChecked;
    property ImageGrayed;
    property ImageToggle;
    property ImageUnchecked;
    property ImageMark;
    property ImageMarkGrayed;
    property Indent;
    property ItemColor;
    property ItemDisabledColor;
    property ItemHotColor;
    property ItemHotUnderline;
    property ItemHottrack;
    property Items;
    property Layout;
    property MarkColor;
    property MarkGrayedColor;
    property Multiline;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ShowFocus;
    property ShowHint;
    property Spacing;
    property SpareColor;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseDockManager;
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
    property OnItemChanged;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;


implementation

{ TSCCheckGroupButtons }

function TSCCheckGroupButtons.Add: TSCCheckGroupButton;
begin
  Result := TSCCheckGroupButton(inherited Add);
end;

constructor TSCCheckGroupButtons.Create(AOwner: TSCCustomCheckGroup);
begin
  inherited Create(TSCCheckGroupButton);
  FOwner := AOwner;
end;

function TSCCheckGroupButtons.GetItem(Index: Integer): TSCCheckGroupButton;
begin
  Result := TSCCheckGroupButton(inherited GetItem(Index));
end;

function TSCCheckGroupButtons.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCCheckGroupButtons.SetItem(Index: Integer;
  Value: TSCCheckGroupButton);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCCheckGroupButtons.Update(Item: TCollectionItem);
begin
  if FOwner <> nil then
    TSCCustomCheckGroup(FOwner).ItemChanged(TSCCheckGroupButton(Item));
end;

{ TSCCheckGroupButton }

procedure TSCCheckGroupButton.Assign(Source: TPersistent);
begin
  if Source is TSCCheckGroupButton then
  begin
    with TSCCheckGroupButton(Source) do
    begin
      Self.FCaption := Caption;
      Self.FEnabled := Enabled;
      Self.FVisible := Visible;
    end;

    Changed(False);
  end else
    inherited Assign(Source);

end;

constructor TSCCheckGroupButton.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FEnabled := True;
  FVisible := True;
  FState := sccbUnchecked;
end;

destructor TSCCheckGroupButton.Destroy;
begin
  FDestroying := True;
  inherited Destroy;
end;

function TSCCheckGroupButton.GetChecked: Boolean;
begin
  Result := FState = sccbChecked;
end;

function TSCCheckGroupButton.GetDisplayName: string;
begin
  Result := Caption;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TSCCheckGroupButton.GetGroup: TSCCustomCheckGroup;
begin
  Result := nil;
  if (Collection is TSCCheckGroupButtons) and
    (TSCCheckGroupButtons(Collection).FOwner is TSCCustomCheckGroup) then
    Result := TSCCustomCheckGroup(TSCCheckGroupButtons(Collection).FOwner);
end;

procedure TSCCheckGroupButton.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure TSCCheckGroupButton.SetChecked(Value: Boolean);
begin
  if GetChecked <> Value then
  begin
    if FState = sccbChecked then
      SetState(sccbUnchecked)
    else
      SetState(sccbChecked);

    Changed(False);
  end;
end;

procedure TSCCheckGroupButton.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed(False);
  end;
end;

procedure TSCCheckGroupButton.SetState(Value: TSCCheckState);
var
  G: TSCCustomCheckGroup;
begin
  G := GetGroup;
  if (Value = sccbGrayed) and (G <> nil) and not G.FAllowGrayed then
  begin
    Value := sccbUnchecked;
    if FState = sccbUnchecked then
      Value := sccbChecked;
  end;

  if FState <> Value then
  begin
    FState := Value;
    Changed(False);

    if (G <> nil) and not (G.IsLoading or G.IsDestroying) then
    begin
      G.ItemStateChanged(Self);
      G.DoClick;
    end;
  end;
end;

procedure TSCCheckGroupButton.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(False);
  end;
end;

{ TSCCustomCheckGroup }

function TSCCustomCheckGroup.BoxRect(R: TRect): TRect;
var
  H: Integer;
begin
  Result := R;
  H := GetBoxHeight;

  case FLayout of
    scclTop:
      Inc(Result.Top);
    scclMiddle:
      Result.Top := Result.Top + ((Result.Bottom - Result.Top) - H) div 2;
    scclBottom:
      Result.Top := Result.Bottom - H - 1;
  end;

  Result.Bottom := Result.Top + H;

  Result.Left := Result.Left + 2;
  Result.Right := Result.Left + GetBoxWidth;
end;

function TSCCustomCheckGroup.CanModify: Boolean;
begin
  Result := True;
end;

constructor TSCCustomCheckGroup.Create(AOwner: TComponent);
begin
  FColumns := 1;
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csDoubleClicks];
  ClickFocus := True;
  DoubleBuffered := True;

  FHotIndex := -1;
  FDownIndex := -1;
  FSpaceDown := -1;

  FBoxCheckedColor := clWindow;
  FBoxGrayedColor := clBtnFace;
  FBoxFrameColor := clBtnShadow;
  FBoxToggleColor := clBtnFace;
  FBoxUncheckedColor := clWindow;
  FHighlightColor := SC_HighlightColor;
  FHottrackColor := SC_HottrackColor;
  FLayout := scclMiddle;
  FImageChecked := -1;
  FImageGrayed := -1;
  FImageToggle := -1;
  FImageUnchecked := -1;
  FImageMark := -1;
  FImageMarkGrayed := -1;
  FItemColor := clNone;
  FItemDisabledColor := clNone;
  FItemHotColor := clRed;
  FItemHotUnderline := True;
  FItemHottrack := True;
  FFocusedIndex := -1;
  FItems := TSCCheckGroupButtons.Create(Self);
  FMarkColor := clWindowText;
  FMarkGrayedColor := clWindowText;
  FShowFocus := True;
  FStyle := sccsWin2k;
end;

destructor TSCCustomCheckGroup.Destroy;
begin
  Destroying;
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TSCCustomCheckGroup.DoDrawCorelCb(Index: Integer; ClientR: TRect);
var
  BoxR, R: TRect;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  BoxR := BoxRect(ClientR);

  IntersectRect(R, BoxR, ClientR);
  if IsRectEmpty(R) then
    Exit;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor(Index);

    if Brush.Color <> clNone then
      FillRect(BoxR);
  end;

  DoDrawMark(Index, BoxR);

  scFrame3D(Canvas, BoxR, clBtnShadow, clBtnHighlight, 1, 0);
  if ItemFocused(Index) or MousePressed(Index) or MouseInItem(Index) then
    scFrame3D(Canvas, BoxR, cl3DDkShadow, clBtnFace, 1, 0);
end;

procedure TSCCustomCheckGroup.DoDrawFlatCb(Index: Integer; ClientR: TRect);
var
  BoxR, R: TRect;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  BoxR := BoxRect(ClientR);

  IntersectRect(R, BoxR, ClientR);
  if IsRectEmpty(R) then
    Exit;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor(Index);

    if Brush.Color <> clNone then
      FillRect(BoxR);
  end;

  DoDrawMark(Index, BoxR);

  case FStyle of
    sccsFlat:
    begin
      if ItemFocused(Index) or MousePressed(Index) or MouseInItem(Index) then
        scFrame3D(Canvas, BoxR, clBtnShadow, clBtnHighlight, 1, 0);
    end;
    sccsFlatFrame:
    begin
      scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
      if ItemFocused(Index) or MousePressed(Index) or MouseInItem(Index) then
        scFrame3D(Canvas, R, cl3DDkShadow, clBtnFace, 1, 0)
      else
        scFrame3D(Canvas, R, clBtnFace, clBtnFace, 1, 0)
    end;
    sccsFlatEx:
    begin
      scFrame3D(Canvas, BoxR, FBoxFrameColor, FBoxFrameColor, 1, 0);
    end;
    sccsFlatDouble:
    begin
      scFrame3D(Canvas, BoxR, FBoxFrameColor, FBoxFrameColor, 1, 0);
      scFrame3D(Canvas, BoxR, FBoxFrameColor, FBoxFrameColor, 1, 0);
    end;
  end;
end;

procedure TSCCustomCheckGroup.DoDrawImageCb(Index: Integer; ClientR: TRect);
var
  Img: Integer;
  BoxR, R: TRect;
  St: TSCCheckState;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  BoxR := BoxRect(ClientR);

  IntersectRect(R, BoxR, ClientR);
  if IsRectEmpty(R) then
    Exit;

  St := GetDrawState(Index);

  Img := FImageUnchecked;

  if InToggle(Index) then
    Img := FImageToggle
  else begin
    case St of
      sccbChecked:
        Img := FImageChecked;
      sccbUnchecked:
        Img := FImageUnchecked;
      sccbGrayed:
        Img := FImageGrayed;
    end;
  end;

  if IsValidImage(Img) then
    Images.Draw(Canvas, BoxR.Left, BoxR.Top, Img, True);

  DoDrawMark(Index, BoxR);
end;

procedure TSCCustomCheckGroup.DoDrawMacCb(Index: Integer; ClientR: TRect);
var
  BoxR, R: TRect;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  BoxR := BoxRect(ClientR);

  IntersectRect(R, BoxR, ClientR);
  if IsRectEmpty(R) then
    Exit;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor(Index);

    if Brush.Color <> clNone then
      FillRect(BoxR);
  end;

  R := BoxR;
  scFrame3D(Canvas, R, clWindowFrame, clWindowFrame, 1, 0);
  scFrame3D(Canvas, R, clBtnHighlight, clBtnShadow, 1, 0);

  DoDrawMark(Index, BoxR);
end;

procedure TSCCustomCheckGroup.DoDrawMark(Index: Integer; R: TRect;
  AColor: TColor);
var
  MR: TRect;
  L, T, I: Integer;
  St: TSCCheckState;
  Pts: array[0..2] of TPoint;
begin
  St := GetDrawState(Index);

  if (Canvas = nil) or (Index < 0) or (Index > FItems.Count-1) or
    (St = sccbUnchecked) or not CanGetClientRect then
    Exit;

  MR := R;
  if FStyle = sccsMac then
  begin
    with Canvas.Pen do
    begin
      Style := psSolid;
      Mode := pmCopy;

      if AColor <> clNone then
        Color := AColor
      else
        Color := FMarkColor;
    end;

    InflateRect(MR, -2, -2);

    L := MR.Left + (MR.Right - MR.Left - 12) div 2;
    if L < MR.Left then L := MR.Left;

    T := MR.Top + (MR.Bottom - MR.Top - 8) div 2;
    Dec(T);

    Pts[0].x := L + 1;
    Pts[0].y := T + 4;
    Pts[1].x := Pts[0].x + 2;
    Pts[1].y := Pts[0].y + 2;
    Pts[2].x := Pts[1].x + 7;
    Pts[2].y := T - 1;

    Canvas.Polyline(Pts);

    Pts[0].x := L;
    Pts[0].y := T + 4;
    Pts[1].x := Pts[0].x + 3;
    Pts[1].y := Pts[0].y + 3;
    Pts[2].x := Pts[1].x + 8;
    Pts[2].y := T - 1;

    Canvas.Polyline(Pts);

    Canvas.Pen.Color := BlendedColor(clBtnShadow, 12, 12, 12, True);

    Pts[0].x := L + 1;
    Pts[0].y := T + 6;
    Pts[1].x := Pts[0].x + 2;
    Pts[1].y := Pts[0].y + 2;
    Pts[2].x := Pts[1].x + 8;
    Pts[2].y := T;

    Canvas.Polyline(Pts);

    with Canvas do
    begin
      Pen.Color := BlendedColor(clBtnShadow, 64, 64, 64, True);

      MoveTo(L + 1, T + 6);
      LineTo(L + 3, T + 8);

      MoveTo(L + 4, T + 8);
      LineTo(L + 12, T);
    end;
  end else
  if FStyle = sccsImage then
  begin
    if St = sccbGrayed then
    begin
      if IsValidImage(FImageGrayed) then
        Images.Draw(Canvas, R.Left, R.Top, FImageMarkGrayed, True);
    end else
    if (St = sccbChecked) and IsValidImage(FImageMark) then
      Images.Draw(Canvas, R.Left, R.Top, FImageMark, True);
  end else
  begin
    with Canvas.Pen do
    begin
      Style := psSolid;
      Mode := pmCopy;

      if AColor <> clNone then
        Color := AColor
      else
        Color := FMarkColor;
    end;

    L := MR.Left + (MR.Right - MR.Left - 7) div 2;
    if L < MR.Left then L := MR.Left;

    T := MR.Top + (MR.Bottom - MR.Top - 7) div 2;
    if T < MR.Top then T := MR.Top;

    Pts[0].x := L;
    Pts[0].y := T + 2;
    Pts[1].x := Pts[0].x + 2;
    Pts[1].y := Pts[0].y + 2;
    Pts[2].x := Pts[1].x + 5;
    Pts[2].y := T - 1;

    for I := 0 to 2 do
    begin
      Canvas.Polyline(Pts);

      Inc(Pts[0].y);
      Inc(Pts[1].y);
      Inc(Pts[2].y);
    end;
  end;
end;

procedure TSCCustomCheckGroup.DoDrawOfficeXPCb(Index: Integer; ClientR: TRect);
var
  BoxR, R: TRect;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  BoxR := BoxRect(ClientR);

  IntersectRect(R, BoxR, ClientR);
  if IsRectEmpty(R) then
    Exit;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor(Index);

    FillRect(BoxR);
  end;

  if GetDrawState(Index) <> sccbUnchecked then
  begin
    R := BoxR;
    DoDrawMark(Index, BoxR, FOfficeMarkColor);
  end;

  scFrame3D(Canvas, BoxR, clHighlight, clHighlight, 1, 0);
end;

procedure TSCCustomCheckGroup.DoDrawText(Index: Integer; var R: TRect;
  CalcRect: Boolean);
var
  Text: String;
  TxtFlags: Integer;
begin
  if (Canvas = nil) or IsRectEmpty(R) or not CanGetClientRect or
    (Index < 0) or (Index > FItems.Count-1) then
    Exit;

  TxtFlags := DT_LEFT or DT_EXPANDTABS;

  if not CalcRect then
    IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);

  Text := Items[Index].Caption;
  if CalcRect and ((Text = '') or
    ((Length(Text) > 1) and (Text[1] = '&') and (Text[2] = #0))) then
    Text := Text + ' ';

  if FMultiline then
  begin
    TxtFlags := TxtFlags or DT_WORDBREAK or DT_TOP;

    if FEndEllipsis and not CalcRect then
      TxtFlags := TxtFlags or DT_END_ELLIPSIS;
  end else
  begin
    TxtFlags := TxtFlags or DT_SINGLELINE;

    if not CalcRect then
    begin
      TxtFlags := TxtFlags or DT_VCENTER;
      if FEndEllipsis then
        TxtFlags := TxtFlags or DT_END_ELLIPSIS;
    end;
  end;

  if CalcRect then
    TxtFlags := TxtFlags or DT_CALCRECT;

  TxtFlags := DrawTextBiDiModeFlags(TxtFlags);

  with Canvas do
  begin
    Brush.Style := bsClear;
    Font := Self.Font;

    if CalcRect then
      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags)
    else
    if not Enabled or not Items[Index].Enabled then
    begin
      if FItemDisabledColor <> clNone then
      begin
        Font.Color := FItemDisabledColor;
        DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);
      end else
      begin
        OffsetRect(R, 1, 1);
        Font.Color := clBtnHighlight;

        DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);

        OffsetRect(R, -1, -1);
        Font.Color := clBtnShadow;

        DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);
      end;
    end else
    begin
      if FItemHottrack and (FHotIndex = Index) then
      begin
        if FItemHotColor <> clNone then
          Font.Color := FItemHotColor;

        if FItemHotUnderline then
          Font.Style := Font.Style + [fsUnderline];
      end else
      if FItemColor <> clNone then
        Font.Color := FItemColor;

      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);
    end;

    if not CalcRect then
      SelectClipRgn(Handle, 0);
  end;
end;

procedure TSCCustomCheckGroup.DoDrawWin2kCb(Index: Integer; ClientR: TRect);
var
  BoxR, R: TRect;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  BoxR := BoxRect(ClientR);

  IntersectRect(R, BoxR, ClientR);
  if IsRectEmpty(R) then
    Exit;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor(Index);

    if Brush.Color <> clNone then
      FillRect(BoxR);
  end;

  DoDrawMark(Index, BoxR);

  scFrame3D(Canvas, BoxR, clBtnShadow, clBtnHighlight, 1, 0);
  scFrame3D(Canvas, BoxR, cl3DDkShadow, clBtnFace, 1, 0);
end;

procedure TSCCustomCheckGroup.DoDrawXPCb(Index: Integer; ClientR: TRect);
var
  Track: Boolean;
  BoxR, R: TRect;
  TrackColor, TopColor, BtmColor: TColor;
  IsPressed, InControl, IsFocused: Boolean;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  BoxR := BoxRect(ClientR);

  IntersectRect(R, BoxR, ClientR);
  if IsRectEmpty(R) then
    Exit;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor(Index);

    if Brush.Color <> clNone then
      FillRect(BoxR);
  end;

  DoDrawMark(Index, BoxR);

  // highligh or hottrack frame
  Track := False;
  TrackColor := clNone;

  IsPressed := MousePressed(Index);
  InControl := MouseInItem(Index);
  IsFocused := ItemFocused(Index);

  if InControl and not IsPressed then
  begin
    Track := True;
    TrackColor := FHottrackColor;
  end else
  if (IsPressed and not InControl) or
    (IsFocused and not (IsPressed or InControl)) then
  begin
    Track := True;
    TrackColor := FHighlightColor
  end;

  R := BoxR;
  InflateRect(R, -1, -1);

  if Track and not IsRectEmpty(R) then
  begin
    if InToggle(Index) then
    begin
      TopColor := BlendedColor(TrackColor, 16, 16, 16, False);
      BtmColor := BlendedColor(TrackColor, 16, 16, 16, True);
    end else
    begin
      TopColor := BlendedColor(TrackColor, 64, 64, 64, True);
      BtmColor := BlendedColor(TrackColor, 16, 16, 16, False);
    end;

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
  end;

  R := BoxR;
  scFrame3D(Canvas, R, FBoxFrameColor, FBoxFrameColor, 1, 0);
end;


procedure TSCCustomCheckGroup.DrawItem(Index: Integer);
var
  SR: Integer;
  R, CR, RgnR, Tr: TRect;
begin
  if (Index > -1) and (Index < FItems.Count) then
  begin
    CR := ClientRect;
    AdjustClientRect(CR);

    InflateRect(R, -2, -2);

    if IsRectEmpty(CR) then
      Exit;

    R := GetItemRect(Index);
    if IsRectEmpty(R) then
      Exit;

    IntersectRect(RgnR, R, CR);
    if IsRectEmpty(RgnR) then
      Exit;

    SR := IntersectClipRect(Canvas.Handle, RgnR.Left, RgnR.Top, RgnR.Right, RgnR.Bottom);
    try
      if SR = NULLREGION then
        Exit;

      case FStyle of
        sccsCorel:
          DoDrawCorelCb(Index, R);
        sccsFlat, sccsFlatFrame,
        sccsFlatEx, sccsFlatDouble:
          DoDrawFlatCb(Index, R);
        sccsImage:
          DoDrawImageCb(Index, R);
        sccsMac:
          DoDrawMacCb(Index, R);
        sccsOfficeXP:
          DoDrawOfficeXPCb(Index, R);
        sccsXP:
          DoDrawXPCb(Index, R);
        sccsMetal:
          DoDrawMetalCb(Index, R);
        else
          DoDrawWin2kCb(Index, R);
      end;

      CR := R;

      R := InnerRect(R);
      if IsRectEmpty(R) then
        Exit;

      IntersectRect(RgnR, R, CR);
      if IsRectEmpty(RgnR) then
        Exit;

      if FMultiline or (HasFocus and FShowFocus and ItemFocused(Index)) then
      begin
        Tr := R;
        DoDrawText(Index, Tr, True);

        OffsetRect(Tr, -Tr.Left, -Tr.Top);
        OffsetRect(Tr, R.Left, 0);

        case FLayout of
          scclTop:
            OffsetRect(Tr, 0, R.Top);
          scclMiddle:
            OffsetRect(Tr, 0, R.Top + ((R.Bottom - R.Top) - (Tr.Bottom - Tr.Top)) div 2);
          scclBottom:
            OffsetRect(Tr, 0, R.Bottom - Tr.Bottom);
        end;

        R := Tr;
      end;

      DoDrawText(Index, R);

      if HasFocus and FShowFocus and ItemFocused(Index) and not IsRectEmpty(R) then
      begin
        InflateRect(R, 2, 1);
        Inc(R.Bottom);
        Inc(R.Right);

        if R.Right > CR.Right + 2 then R.Right := CR.Right + 2;

        if not IsRectEmpty(R) then
          with Canvas do
          begin
            Brush.Color := Self.Color;
            Brush.Style := bsSolid;

            scDrawFocusRect(Canvas, R, Self.Color);
          end;
      end;
    finally
      SelectClipRgn(Canvas.Handle, 0);
    end;
  end;
end;


procedure TSCCustomCheckGroup.EnabledChanged;
begin
  if (FHotIndex > -1) or (FDownIndex > -1) then
  begin
    FHotIndex := -1;
    FDownIndex := -1;
    FSpaceDown := -1;

    Invalidate;
  end;
  inherited EnabledChanged;
end;

procedure TSCCustomCheckGroup.FocusChanged;
var
  DoInvalidate: Boolean;
begin
  if not HasFocus then
  begin
    DoInvalidate := (FDownIndex > -1) or (FFocusedIndex > -1) or
      (FSpaceDown > -1);

    FSpaceDown := -1;
    FDownIndex := -1;
  end else
  begin
    DoInvalidate := (FSpaceDown > -1) or (FDownIndex > -1) or
      ((FFocusedIndex < 0) or (FFocusedIndex > FItems.Count-1));

    FSpaceDown := -1;  
    FDownIndex := -1;
    if (FFocusedIndex < 0) or (FFocusedIndex > FItems.Count-1) then
      FFocusedIndex := 0;
  end;

  if DoInvalidate then
    Invalidate;

  inherited FocusChanged;
end;

function TSCCustomCheckGroup.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomCheckGroup.GetBoxFaceColor(Index: Integer): TColor;
var
  St: TSCCheckState;
  IsHot, IsDown: Boolean;
begin
  St := GetDrawState(Index);
  if FStyle = sccsOfficeXP then
  begin
    Result := GetOfficeXPBtnColor;
    FOfficeMarkColor := clBtnText;

    if (Index < 0) or (Index > FItems.Count-1) then
      Exit;

    IsHot  := FHotIndex = Index;
    IsDown := FDownIndex = Index;

    if St = sccbChecked then
    begin
      if IsDown or IsHot then
      begin
        Result := GetOfficeXPDownedSelColor;
        FOfficeMarkColor := clHighlightText;
      end else
        Result := GetOfficeXPDownedColor;
    end else
    if IsDown and IsHot then
    begin
      Result := GetOfficeXPDownedSelColor;
      FOfficeMarkColor := clHighlightText;
    end else
    if IsDown or IsHot then
      Result := GetOfficeXPSelColor;
  end else
  begin
    Result := FBoxUncheckedColor;

    if InToggle(Index) then
      Result := FBoxToggleColor
    else
    if St = sccbGrayed then
      Result := FBoxGrayedColor
    else
    if St = sccbChecked then
      Result := FBoxCheckedColor;
  end;    
end;

function TSCCustomCheckGroup.GetBoxHeight: Integer;
begin
  Result := 13;
  if FStyle = sccsMac then Result := 12;

  if (FStyle = sccsImage) and (Images <> nil) then
    Result := Images.Height;
end;

function TSCCustomCheckGroup.GetBoxWidth: Integer;
begin
  Result := 13;
  if FStyle = sccsMac then Result := 12;

  if (FStyle = sccsImage) and (Images <> nil) then
    Result := Images.Width;
end;

function TSCCustomCheckGroup.FindEnabled(Index: Integer; BackSearch: Boolean): Integer;
var
  I: Integer;
begin
  Result := -1;
  if (Index < -1) or (Index > FItems.Count-1) and
    (FVisibleItemCount = 0) then
    Exit;

  if BackSearch then
  begin
    for I := Index downto 0 do
      if FItems[I].Visible and FItems[I].Enabled then
      begin
        Result := I;
        Exit;
      end;

    for I := FItems.Count-1 downto Index + 1 do
      if FItems[I].Visible and FItems[I].Enabled then
      begin
        Result := I;
        Exit;
      end;
  end else
  begin
    for I := Index to FItems.Count-1 do
      if FItems[I].Visible and FItems[I].Enabled then
      begin
        Result := I;
        Exit;
      end;

    for I := 0 to Index - 1 do
      if FItems[I].Visible and FItems[I].Enabled then
      begin
        Result := I;
        Exit;
      end;
  end;
end;

function TSCCustomCheckGroup.GetItemAtPos(X, Y: Integer): Integer;
var
  R: TRect;
  P: TPoint;
  I: Integer;
begin
  Result := -1;

  P := Point(X, Y);
  for I := FItems.Count-1 downto 0 do
    if FItems[I].Visible then
    begin
      R := GetItemRect(I);
      if not IsRectEmpty(R) and PtInRect(R, P) then
      begin
        Result := I;
        Exit;
      end;
    end;
end;

function TSCCustomCheckGroup.GetItemRect(Index: Integer): TRect;
var
  R: TRect;
  I, H, W, Indx, Col, Cnt: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (Index > -1) and (Index < FItems.Count) then
  begin
    if not FItems[Index].Visible then
      Exit;

    R := ClientRect;
    AdjustClientRect(R);

    InflateRect(R, -5, -4);
    Dec(R.Right, 2);

    if IsRectEmpty(R) then
      Exit;
      
    Indx := 0;
    for I := 0 to FItems.Count-1 do
      if FItems[I].Visible then
      begin
        if I = Index then Break;
        Inc(Indx);
      end;

    Cnt := (FVisibleItemCount + FColumns - 1) div FColumns;

    Col := Indx div Cnt;
    Indx := Indx mod Cnt;

    R.Bottom := R.Top + ((R.Bottom - R.Top) div Cnt);
    R.Right := R.Left + ((R.Right - R.Left) div FColumns);

    W := R.Right - R.Left;
    H := R.Bottom - R.Top;

    OffsetRect(R, W*Col, H*Indx);
    Result := R;
  end;
end;

function TSCCustomCheckGroup.InnerRect(R: TRect): TRect;
var
  BoxR: TRect;
begin
  Result := R;

  BoxR := BoxRect(R);
  Result.Left := BoxR.Right + 4;

  if Result.Left > Result.Right then
    Result.Left := Result.Right;
end;

function TSCCustomCheckGroup.InToggle(Index: Integer): Boolean;
begin
  Result := HasFocus and (Index > -1) and (Index < FItems.Count) and
    (((FSpaceDown = Index) and (FFocusedIndex = Index)) or
    (MouseInItem(Index) and MousePressed(Index)));
end;

procedure TSCCustomCheckGroup.ItemChanged(Item: TSCCheckGroupButton);
begin
  if not IsDestroying then
  begin
    UpdateVisibleItemCount;
    Invalidate;
  end;  
end;

function TSCCustomCheckGroup.ItemFocused(Index: Integer): Boolean;
begin
  Result := HasFocus and (Index > -1) and (Index < FItems.Count) and
    FItems[Index].Enabled and ((Index = FDownIndex) or
    ((FDownIndex = -1) and (Index = FFocusedIndex)));
end;

procedure TSCCustomCheckGroup.ItemsChanged;
begin
  //
end;

procedure TSCCustomCheckGroup.KeyDown(var Key: Word; Shift: TShiftState);
var
  OldSpace, OldDown, Index, ColCnt: Integer;
begin
  inherited KeyDown(Key, Shift);

  if (FSpaceDown = -1) or ((FSpaceDown > -1) and (Key <> VK_SPACE)) then
  begin
    OldDown := FDownIndex;
    FDownIndex := -1;

    if OldDown <> FDownIndex then
      Invalidate;
  end;

  if (Key in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT,
    VK_HOME, VK_END]) and not CanModify then
    Exit;

  case Key of
    VK_SPACE:
    begin
      if FSpaceDown > -1 then
      begin
        Key := 0;
        Exit;
      end;

      if (FFocusedIndex < 0) or (FFocusedIndex > FItems.Count-1) then
      begin
        FFocusedIndex := 0;
        if FItems.Count = 0 then FFocusedIndex := -1;
      end;

      OldSpace := FSpaceDown;
      FSpaceDown := FFocusedIndex;
      if (FDownIndex = -1) or (FSpaceDown <> OldSpace) then
        Invalidate;
    end;
    VK_UP:
    begin
      Index := FFocusedIndex;

      if Index = -1 then
      begin
        Index := 0;
        if FItems.Count = 0 then
          Index := -1;
      end else
      begin
        Dec(Index);
        if Index < 0 then
          Index := FItems.Count-1;
      end;

      Index := FindEnabled(Index, True);
      if Index > -1 then SetFocusedIndex(Index);
    end;
    VK_DOWN:
    begin
      Index := FFocusedIndex;

      if Index = -1 then
      begin
        Index := 0;
        if FItems.Count = 0 then
          Index := -1;
      end else
      begin
        Inc(Index);
        if Index > FItems.Count-1 then
        begin
          Index := 0;
          if FItems.Count = 0 then
            Index := -1;
        end;
      end;

      Index := FindEnabled(Index);
      if Index > -1 then SetFocusedIndex(Index);
    end;
    VK_RIGHT:
    begin
      Index := FFocusedIndex;

      if Index = -1 then
      begin
        Index := 0;
        if FItems.Count = 0 then
          Index := -1;
      end else
      if FColumns = 1 then
      begin
        Inc(Index);
        if Index > FItems.Count-1 then
        begin
          Index := 0;
          if FItems.Count = 0 then
            Index := -1;
        end;
      end else
      begin
        ColCnt := (FVisibleItemCount + FColumns - 1) div FColumns;

        Inc(Index, ColCnt);
        if Index > FItems.Count-1 then
        begin
          Index := Index mod ColCnt;
          if FFocusedIndex div ColCnt < FColumns-1 then
             Index := FItems.Count-1;
        end;
      end;
      
      Index := FindEnabled(Index, True);
      if Index > -1 then SetFocusedIndex(Index);
    end;
    VK_LEFT:
    begin
      Index := FFocusedIndex;

      if Index = -1 then
      begin
        Index := 0;
        if FItems.Count = 0 then
          Index := -1;
      end else
      if FColumns = 1 then
      begin
        Dec(Index);
        if Index < 0 then
          Index := FItems.Count-1;
      end else
      begin
        ColCnt := (FVisibleItemCount + FColumns - 1) div FColumns;

        Dec(Index, ColCnt);
        if Index < 0 then
          Index := FItems.Count-1;
      end;
      
      Index := FindEnabled(Index, True);
      if Index > -1 then SetFocusedIndex(Index);
    end;
    VK_HOME:
    begin
      Index := 0;
      if FItems.Count = 0 then
        Index := -1;

      Index := FindEnabled(Index);
      if Index > -1 then SetFocusedIndex(Index);
    end;
    VK_END:
    begin
      Index := FindEnabled(FItems.Count-1, True);
      if Index > -1 then SetFocusedIndex(Index);
    end;
  end;
end;

procedure TSCCustomCheckGroup.Loaded;
begin
  inherited Loaded;
  UpdateVisibleItemCount;
end;

procedure TSCCustomCheckGroup.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldSpace, OldHot, OldFocused: Integer;
begin
  OldHot := FHotIndex;
  OldSpace := FSpaceDown;
  OldFocused := FFocusedIndex;

  FHotIndex := -1;
  FDownIndex := -1;

  inherited MouseDown(Button, Shift, X, Y);

  if CanFocus and not Focused and not ClickFocus then
    SetFocus;

  FHotIndex := GetItemAtPos(X, Y);
  if (FHotIndex > -1) and not FItems[FHotIndex].Enabled then
    FHotIndex := -1;
    
  if Focused and (Button = mbLeft) then
  begin
    SetCapture(Handle);
    
    FDownIndex := FHotIndex;
    if FHotIndex > -1 then
      FFocusedIndex := FHotIndex;
  end;

  if (OldHot <> FHotIndex) or (FDownIndex > -1) or
    (FFocusedIndex <> OldFocused) or (OldSpace <> FFocusedIndex) then
    Invalidate;
end;

procedure TSCCustomCheckGroup.MouseInControlChanged;
var
  P: TPoint;
begin
  if not MouseInControl then
  begin
    if FHotIndex > -1 then
    begin
      FHotIndex := -1;
      Invalidate;
    end;
  end else
  if GetCursorPos(P) then
  begin
    P := Self.ScreenToClient(P);
    FHotIndex := GetItemAtPos(P.x, P.y);

    if FHotIndex > -1 then
      Invalidate;
  end;

  inherited MouseInControlChanged;
end;

function TSCCustomCheckGroup.MouseInItem(Index: Integer): Boolean;
begin
  Result := (Index > -1) and (Index < FItems.Count) and
    (Index = FHotIndex);
end;

procedure TSCCustomCheckGroup.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  OldHot: Integer;
begin
  inherited MouseMove(Shift, X, Y);

  OldHot := FHotIndex;

  FHotIndex  := GetItemAtPos(X, Y);
  if (FHotIndex > -1) and not FItems[FHotIndex].Enabled then
    FHotIndex := -1;

  if OldHot <> FHotIndex then
    Invalidate;
end;

function TSCCustomCheckGroup.MousePressed(Index: Integer): Boolean;
begin
  Result := HasFocus and (Index > -1) and (Index < FItems.Count) and
    (Index = FDownIndex);
end;

procedure TSCCustomCheckGroup.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldSpace, OldIndex, OldDown, OldHot: Integer;
begin
  OldSpace := FSpaceDown;
  if FSpaceDown <> FDownIndex then
    FSpaceDown := -1;
  
  OldDown := FDownIndex;
  FDownIndex := -1;

  OldHot := FHotIndex;
  OldIndex := FFocusedIndex;

  FHotIndex := GetItemAtPos(X, Y);
  if (FHotIndex > -1) and not FItems[FHotIndex].Enabled then
    FHotIndex := -1;

  if Button = mbLeft then
  begin
    if OldDown > -1 then SetFocusedIndex(OldDown);
    if (OldDown = FHotIndex) and (FHotIndex > -1) and CanModify then
      Toggle(FHotIndex);
  end;

  if (OldIndex = FFocusedIndex) and ((OldDown > -1) or
    (OldHot <> FHotIndex)) or (OldSpace <> FSpaceDown) then
    Invalidate;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomCheckGroup.Paint;
var
  CR: TRect;
  Cl: TColor;
  I: Integer;
begin
  if not HandleAllocated then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  if IsRectEmpty(CR) then
    Exit;

  Cl := Self.Color;
  if Cl = clNone then Cl := clBtnFace;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Cl;

    FillRect(CR);

    if Transparent then
      PaintParentOn(Canvas);
  end;

  DrawPicture(Canvas);

  for I := 0 to FItems.Count-1 do
    DrawItem(I);

  DoDrawBevel;
end;

procedure TSCCustomCheckGroup.ReadState(Reader: TReader);
begin
  inherited ReadState(Reader);
  UpdateVisibleItemCount;
end;

procedure TSCCustomCheckGroup.SetBoxCheckedColor(Value: TColor);
begin
  if FBoxCheckedColor <> Value then
  begin
    FBoxCheckedColor := Value;
    if (FStyle <> sccsImage) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetBoxFrameColor(Value: TColor);
begin
  if FBoxFrameColor <> Value then
  begin
    FBoxFrameColor := Value;
    if (FStyle = sccsXP) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetBoxToggleColor(Value: TColor);
begin
  if FBoxToggleColor <> Value then
  begin
    FBoxToggleColor := Value;
    if (FStyle <> sccsImage) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetBoxUncheckedColor(Value: TColor);
begin
  if FBoxUncheckedColor <> Value then
  begin
    FBoxUncheckedColor := Value;
    if (FStyle <> sccsImage) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetColumns(Value: Integer);
begin
  if Value < 1 then Value := 1;

  if FColumns <> Value then
  begin
    FColumns := Value;
    if (FItems <> nil) and (FItems.Count > 1) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    if FItems.Count > 0 then
      Invalidate;
  end;    
end;

procedure TSCCustomCheckGroup.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    if (FStyle = sccsXP) and (FItems <> nil) and (FItems.Count > 1) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetHottrackColor(Value: TColor);
begin
  if FHottrackColor <> Value then
  begin
    FHottrackColor := Value;
    if (FStyle = sccsXP) and (FItems <> nil) and (FItems.Count > 1) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetImageChecked(Value: TImageIndex);
begin
  if FImageChecked <> Value then
  begin
    FImageChecked := Value;
    if (FStyle = sccsImage) and (Images <> nil) and
      (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetImageMark(Value: TImageIndex);
begin
  if FImageMark <> Value then
  begin
    FImageMark := Value;
    if (FStyle = sccsImage) and (Images <> nil) and
      (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetImageToggle(Value: TImageIndex);
begin
  if FImageToggle <> Value then
  begin
    FImageToggle := Value;
    if (FStyle = sccsImage) and (Images <> nil) and
      (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetImageUnchecked(Value: TImageIndex);
begin
  if FImageUnchecked <> Value then
  begin
    FImageUnchecked := Value;
    if (FStyle = sccsImage) and (Images <> nil) and
      (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetItemColor(Value: TColor);
begin
  if FItemColor <> Value then
  begin
    FItemColor := Value;
    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetItemDisabledColor(Value: TColor);
begin
  if FItemDisabledColor <> Value then
  begin
    FItemDisabledColor := Value;
    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetItemHotColor(Value: TColor);
begin
  if FItemHotColor <> Value then
  begin
    FItemHotColor := Value;

    if FItemHottrack and (FHotIndex > -1) and
      (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetItemHottrack(Value: Boolean);
begin
  if FItemHottrack <> Value then
  begin
    FItemHottrack := Value;
    if (FHotIndex > -1) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetItemHotUnderline(Value: Boolean);
begin
  if FItemHotUnderline <> Value then
  begin
    FItemHotUnderline := Value;

    if FItemHottrack and (FHotIndex > -1) and
      (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetItems(Value: TSCCheckGroupButtons);
begin
  FItems.Assign(Value);
  UpdateVisibleItemCount;

  ItemsChanged;
end;

procedure TSCCustomCheckGroup.SetMarkColor(Value: TColor);
begin
  if FMarkColor <> Value then
  begin
    FMarkColor := Value;
    if (FStyle <> sccsImage) and (FItems <> nil) and (FItems.Count > 1) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetStyle(Value: TSCCheckboxStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.StopTracking;
var
  DoInvalidate: Boolean;
begin
  DoInvalidate := (FSpaceDown > -1) or (FDownIndex > -1) or (FHotIndex > -1);

  FSpaceDown := -1;
  FHotIndex := -1;
  FDownIndex := -1;

  if FDownIndex = -1 then
  begin
    if GetCapture = Handle then
      ReleaseCapture;
  end;

  if DoInvalidate then
    Invalidate;

  inherited StopTracking;
end;

procedure TSCCustomCheckGroup.UpdateVisibleItemCount;
var
  I, OldCount: Integer;
begin
  OldCount := FVisibleItemCount;

  FVisibleItemCount := 0;
  for I := 0 to FItems.Count-1 do
    if FItems[I].Visible then
      Inc(FVisibleItemCount);

  if OldCount <> FVisibleItemCount then
    Invalidate;  
end;

procedure TSCCustomCheckGroup.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTCHARS or DLGC_WANTARROWS;
end;

procedure TSCCustomCheckGroup.SetAllowGrayed(Value: Boolean);
begin
  if FAllowGrayed <> Value then
  begin
    FAllowGrayed := Value;
    if (FItems <> nil) and (FItems.Count > 1) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetMarkGrayedColor(Value: TColor);
begin
  if FMarkGrayedColor <> Value then
  begin
    FMarkGrayedColor := Value;
    if (FStyle <> sccsImage) and (FItems <> nil) and (FItems.Count > 1) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetBoxGrayedColor(Value: TColor);
begin
  if FBoxGrayedColor <> Value then
  begin
    FBoxGrayedColor := Value;
    if (FStyle <> sccsImage) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetImageGrayed(Value: TImageIndex);
begin
  if FImageGrayed <> Value then
  begin
    FImageGrayed := Value;
    if (FStyle = sccsImage) and (Images <> nil) and
      (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetImageMarkGrayed(Value: TImageIndex);
begin
  if FImageMarkGrayed <> Value then
  begin
    FImageMarkGrayed := Value;
    if (FStyle = sccsImage) and (Images <> nil) and
      (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetFocusedIndex(Value: Integer);
begin
  if Value < -1 then Value := -1;

  if FFocusedIndex <> Value then
  begin
    FFocusedIndex := Value;
    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

function TSCCustomCheckGroup.GetDrawState(Index: Integer): TSCCheckState;
begin
  Result := sccbUnchecked;
  if (Index > -1) and (Index < FItems.Count) then
    Result := FItems[Index].State;
end;

function TSCCustomCheckGroup.SwitchState(S: TSCCheckState): TSCCheckState;
begin
  Result := S;
  case Result of
    sccbChecked:
      Result := sccbUnchecked;
    sccbUnchecked:
      if FAllowGrayed then
        Result := sccbGrayed else
        Result := sccbChecked;
    sccbGrayed:
      Result := sccbChecked;
  end;
end;

procedure TSCCustomCheckGroup.KeyUp(var Key: Word; Shift: TShiftState);
var
  AState: TSCCheckState;
  OldSpace, Index: Integer;
begin
  if (FSpaceDown > -1) and (Key in [VK_SPACE, VK_ESCAPE]) then
  begin
    OldSpace := FSpaceDown;
    FSpaceDown := -1;

    Index := FFocusedIndex;
    if (Index < 0) or (Index > FItems.Count-1) then
    begin
      Index := 0;
      if FItems.Count = 0 then Index := -1;
    end;

    if (Key = VK_ESCAPE) or (Index = -1) or
      (FFocusedIndex <> OldSpace) then
      Invalidate
    else begin
      AState := FItems[Index].State;
      Toggle(Index);

      if AState = FItems[Index].State then
        Invalidate;
    end;
  end;

  inherited KeyUp(Key, Shift);
end;

procedure TSCCustomCheckGroup.Toggle(Index: Integer);
var
  Button: TSCCheckGroupButton;
begin
  if (Index > -1) and (Index < FItems.Count) then
  begin
    Button := FItems[Index];
    Button.State := SwitchState(Button.State);
  end;
end;

procedure TSCCustomCheckGroup.ItemStateChanged(Item: TSCCheckGroupButton);
begin
  DoItemStateChanged(Item);
  Change;
end;

procedure TSCCustomCheckGroup.DoItemStateChanged(Item: TSCCheckGroupButton);
begin
end;

procedure TSCCustomCheckGroup.SetShowFocus(Value: Boolean);
begin
  if FShowFocus <> Value then
  begin
    FShowFocus := Value;
    if HasFocus and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetMultiline(Value: Boolean);
begin
  if FMultiline <> Value then
  begin
    FMultiline := Value;
    if FItems.Count > 0 then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.SetLayout(Value: TSCCheckboxLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckGroup.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomCheckGroup then
  begin
    with TSCCustomCheckGroup(Source) do
    begin
      Self.AllowGrayed := AllowGrayed;
      Self.Columns := Columns;
      Self.BoxCheckedColor := BoxCheckedColor;
      Self.BoxGrayedColor := BoxGrayedColor;
      Self.BoxFrameColor := BoxFrameColor;
      Self.BoxToggleColor := BoxToggleColor;
      Self.BoxUncheckedColor := BoxUncheckedColor;
      Self.EndEllipsis := EndEllipsis;
      Self.HighlightColor := HighlightColor;
      Self.HottrackColor := HottrackColor;
      Self.ImageChecked := ImageChecked;
      Self.ImageGrayed := ImageGrayed;
      Self.ImageToggle := ImageToggle;
      Self.ImageUnchecked := ImageUnchecked;
      Self.ImageMark := ImageMark;
      Self.ImageMarkGrayed := ImageMarkGrayed;
      Self.ItemColor := ItemColor;
      Self.ItemDisabledColor := ItemDisabledColor;
      Self.ItemHotColor := ItemHotColor;
      Self.ItemHotUnderline := ItemHotUnderline;
      Self.ItemHottrack := ItemHottrack;
      Self.Items := Items;
      Self.Layout := Layout;
      Self.MarkColor := MarkColor;
      Self.MarkGrayedColor := MarkGrayedColor;
      Self.Multiline := Multiline;
      Self.ShowFocus := ShowFocus;
      Self.Style := Style;
    end;
  end;
end;

procedure TSCCustomCheckGroup.DoDrawMetalCb(Index: Integer;
  ClientR: TRect);
var
  Cl: TColor;
  BoxR, R: TRect;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  BoxR := BoxRect(ClientR);

  IntersectRect(R, BoxR, ClientR);
  if IsRectEmpty(R) then
    Exit;

  Cl := GetBoxFaceColor(Index);
  
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Cl;

    if Brush.Color <> clNone then
      FillRect(BoxR);
  end;

  DoDrawMark(Index, BoxR);

  scFrame3D(Canvas, BoxR, clBtnShadow, clBtnHighlight, 1, 0);
  scFrame3D(Canvas, BoxR, Cl, clBtnFace, 1, 0);
end;

procedure TSCCustomCheckGroup.Click;
begin
  if FClickCount > 0 then
    inherited Click;
end;

procedure TSCCustomCheckGroup.DoClick;
begin
  Inc(FClickCount);
  try
    Click;
  finally
    if (Self <> nil) then
      Dec(FClickCount);
  end;
end;

{$I SCVerRec.inc}

end.
