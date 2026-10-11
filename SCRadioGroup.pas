{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCRadioGroup;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, SCCommon, SCConsts, SCControl, SCStdControls;

type
  TSCCustomRadioGroup = class;

  THCRadioGroupButton = class(TCollectionItem)
  private
    FCaption: string;
    FData: Pointer;
    FEnabled: Boolean;
    FTag: Integer;
    FVisible: Boolean;
    FDestroying: Boolean;
    procedure SetCaption(const Value: String);
    function  GetChecked: Boolean;
    procedure SetEnabled(Value: Boolean);
    procedure SetVisible(Value: Boolean);
  protected
    function  GetGroup: TSCCustomRadioGroup;
    function  GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Data: Pointer read FData write FData;
    property Destroying: Boolean read FDestroying;
    property Checked: Boolean read GetChecked;
  published
    property Caption: string read FCaption write SetCaption;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Tag: Integer read FTag write FTag default 0;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  THCRadioGroupButtons = class(TCollection)
  private
    FOwner: TSCCustomRadioGroup;
    function  GetItem(Index: Integer): THCRadioGroupButton;
    procedure SetItem(Index: Integer; Value: THCRadioGroupButton);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TSCCustomRadioGroup); virtual;
    function Add: THCRadioGroupButton;
    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomRadioGroup read FOwner;
    {$ENDIF}
    property Items[Index: Integer]: THCRadioGroupButton read GetItem write SetItem; default;
  end;

  TSCCustomRadioGroup = class(TSCCustomGroupBox)
  private
    FAsCheckbox: Boolean;
    FColumns: Integer;
    FBoxCheckedColor: TColor;
    FBoxFrameColor: TColor;
    FBoxToggleColor: TColor;
    FBoxUncheckedColor: TColor;
    FEndEllipsis: Boolean;
    FHighlightColor: TColor;
    FHottrackColor: TColor;
    FImageChecked: TImageIndex;
    FImageToggle: TImageIndex;
    FImageUnchecked: TImageIndex;
    FImageMark: TImageIndex;
    FItemColor: TColor;
    FItemDisabledColor: TColor;
    FItemHotColor: TColor;
    FItemHotUnderline: Boolean;
    FItemHottrack: Boolean;
    FItemIndex: Integer;
    FLayout: TSCRadioLayout;
    FMarkColor: TColor;
    FMultiline: Boolean;
    FItems: THCRadioGroupButtons;
    FStyle: TSCRadioStyle;
    FHotIndex: Integer;
    FDownIndex: Integer;
    FOfficeMarkColor: TColor;
    FVisibleItemCount: Integer;
    FClickCount: Integer;
    procedure SetAsCheckbox(Value: Boolean);
    procedure SetColumns(Value: Integer);
    procedure SetBoxCheckedColor(Value: TColor);
    procedure SetBoxFrameColor(Value: TColor);
    procedure SetBoxToggleColor(Value: TColor);
    procedure SetBoxUncheckedColor(Value: TColor);
    procedure SetEndEllipsis(Value: Boolean);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHottrackColor(Value: TColor);
    procedure SetImageChecked(Value: TImageIndex);
    procedure SetImageToggle(Value: TImageIndex);
    procedure SetImageUnchecked(Value: TImageIndex);
    procedure SetImageMark(Value: TImageIndex);
    procedure SetItemColor(Value: TColor);
    procedure SetItemDisabledColor(Value: TColor);
    procedure SetItemHotColor(Value: TColor);
    procedure SetItemHotUnderline(Value: Boolean);
    procedure SetItemHottrack(Value: Boolean);
    procedure SetItemIndex(Value: Integer);
    procedure SetItems(Value: THCRadioGroupButtons);
    procedure SetLayout(Value: TSCRadioLayout);
    procedure SetMarkColor(Value: TColor);
    procedure SetMultiline(Value: Boolean);
    procedure SetStyle(Value: TSCRadioStyle);

    procedure GenerateOctPoints(Rc: TRect; RoundBy: Integer; var Pts: array of TPoint);
    procedure DrawXPRb(Index: Integer; ClientR: TRect; FrmColor, InnerColor,
      OutterColor, TrackColor, CheckColor: TColor);
    procedure DrawWin2kRb(Index: Integer; ClientR: TRect; InnerColor,
      CheckColor: TColor);
    procedure DrawFlatRb(Index: Integer; ClientR: TRect; FrmColor,
      InnerColor, CheckColor: TColor);
    procedure DrawFlatFrameRb(Index: Integer; ClientR: TRect; InnerColor,
      CheckColor: TColor);
    procedure DrawMacRb(Index: Integer; ClientR: TRect; FrmColor, InnerColor,
      OutterColor, CheckColor: TColor; Pressed: Boolean);

    procedure DoDrawMark(Index: Integer; R: TRect; AColor: TColor = clNone);
    procedure DoDrawText(Index: Integer; var R: TRect; CalcRect: Boolean = False);
    procedure DoDrawAsRadio(Index: Integer; ClientR: TRect);

    procedure DoDrawCorelCb(Index: Integer; ClientR: TRect);
    procedure DoDrawFlatCb(Index: Integer; ClientR: TRect);
    procedure DoDrawImageCb(Index: Integer; ClientR: TRect);
    procedure DoDrawMacCb(Index: Integer; ClientR: TRect);
    procedure DoDrawOfficeXPCb(Index: Integer; ClientR: TRect);
    procedure DoDrawWin2kCb(Index: Integer; ClientR: TRect);
    procedure DoDrawXPCb(Index: Integer; ClientR: TRect);
    procedure DoDrawMetalCb(Index: Integer; ClientR: TRect);

    procedure UpdateVisibleItemCount;
    function  FindEnabled(Index: Integer; BackSearch: Boolean = False): Integer;

    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure ReadState(Reader: TReader); override;

    procedure Click; override;

    procedure FocusChanged; override;
    procedure MouseInControlChanged; override;
    procedure StopTracking; override;
    procedure EnabledChanged; override;

    procedure ItemsChanged; dynamic;
    procedure ItemChanged(Item: THCRadioGroupButton);
    procedure ResetDownIndex;
    function  CanModify: Boolean; virtual;

    function  GetBlendValue: Word; override;

    function  GetBoxWidth: Integer;
    function  GetBoxHeight: Integer;
    function  GetBoxFaceColor(Index: Integer): TColor;

    function  InToggle(Index: Integer): Boolean;
    procedure DrawItem(Index: Integer); virtual;

    function  Checked(Index: Integer): Boolean;
    function  MousePressed(Index: Integer): Boolean;
    function  MouseInItem(Index: Integer): Boolean;
    function  ItemFocused(Index: Integer): Boolean;

    function  BoxRect(R: TRect): TRect;
    function  InnerRect(R: TRect): TRect;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property Columns: Integer read FColumns write SetColumns default 1;
    property AsCheckbox: Boolean read FAsCheckbox write SetAsCheckbox default False;
    property BoxCheckedColor: TColor read FBoxCheckedColor write SetBoxCheckedColor default clWindow;
    property BoxFrameColor: TColor read FBoxFrameColor write SetBoxFrameColor default clBtnShadow;
    property BoxToggleColor: TColor read FBoxToggleColor write SetBoxToggleColor default clBtnFace;
    property BoxUncheckedColor: TColor read FBoxUncheckedColor write SetBoxUncheckedColor default clWindow;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default False;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default SC_HighlightColor;
    property HottrackColor: TColor read FHottrackColor write SetHottrackColor default SC_HottrackColor;
    property ImageChecked: TImageIndex read FImageChecked write SetImageChecked default -1;
    property ImageToggle: TImageIndex read FImageToggle write SetImageToggle default -1;
    property ImageUnchecked: TImageIndex read FImageUnchecked write SetImageUnchecked default -1;
    property ImageMark: TImageIndex read FImageMark write SetImageMark default -1;
    property ItemColor: TColor read FItemColor write SetItemColor default clNone;
    property ItemDisabledColor: TColor read FItemDisabledColor write SetItemDisabledColor default clGrayText;
    property ItemHotColor: TColor read FItemHotColor write SetItemHotColor default clRed;
    property ItemHotUnderline: Boolean read FItemHotUnderline write SetItemHotUnderline default True;
    property ItemHottrack: Boolean read FItemHottrack write SetItemHottrack default True;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: THCRadioGroupButtons read FItems write SetItems;
    property Layout: TSCRadioLayout read FLayout write SetLayout default scrlMiddle;
    property MarkColor: TColor read FMarkColor write SetMarkColor default clWindowText;
    property Multiline: Boolean read FMultiline write SetMultiline default False;
    property Style: TSCRadioStyle read FStyle write SetStyle default scrsWin2k;
    property VisibleItemCount: Integer read FVisibleItemCount;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  GetItemRect(Index: Integer): TRect;
    function  GetItemAtPos(X, Y: Integer): Integer;
  end;

  TSCRadioGroup = class(TSCCustomRadioGroup)
  public
    property VisibleItemCount;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AsCheckbox;
    property Bevel;
    property BevelEdges;
    property BevelColor;
    property BevelWidth;
    property BiDiMode;
    property BorderProps;
    property BoxCheckedColor;
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
    property ImageToggle;
    property ImageUnchecked;
    property ImageMark;
    property Indent;
    property ItemColor;
    property ItemDisabledColor;
    property ItemHotColor;
    property ItemHotUnderline;
    property ItemHottrack;
    property ItemIndex;
    property Items;
    property Layout;
    property MarkColor;
    property Multiline;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
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

{ THCRadioGroupButtons }

function THCRadioGroupButtons.Add: THCRadioGroupButton;
begin
  Result := THCRadioGroupButton(inherited Add);
end;

constructor THCRadioGroupButtons.Create(AOwner: TSCCustomRadioGroup);
begin
  inherited Create(THCRadioGroupButton);
  FOwner := AOwner;
end;

function THCRadioGroupButtons.GetItem(Index: Integer): THCRadioGroupButton;
begin
  Result := THCRadioGroupButton(inherited GetItem(Index));
end;

function THCRadioGroupButtons.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure THCRadioGroupButtons.SetItem(Index: Integer;
  Value: THCRadioGroupButton);
begin
  inherited SetItem(Index, Value);
end;

procedure THCRadioGroupButtons.Update(Item: TCollectionItem);
begin
  if FOwner <> nil then
    TSCCustomRadioGroup(FOwner).ItemChanged(THCRadioGroupButton(Item));
end;

{ THCRadioGroupButton }

procedure THCRadioGroupButton.Assign(Source: TPersistent);
begin
  if Source is THCRadioGroupButton then
  begin
    with THCRadioGroupButton(Source) do
    begin
      Self.FCaption := Caption;
      Self.FEnabled := Enabled;
      Self.FVisible := Visible;
    end;

    Changed(False);
  end else
    inherited Assign(Source);

end;

constructor THCRadioGroupButton.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FEnabled := True;
  FVisible := True;
end;

destructor THCRadioGroupButton.Destroy;
begin
  FDestroying := True;
  inherited Destroy;
end;

function THCRadioGroupButton.GetChecked: Boolean;
var
  Grp: TSCCustomRadioGroup;
begin
  Result := False;
  
  Grp := GetGroup;
  if Grp <> nil then
    Result := Grp.ItemIndex = Self.Index;
end;

function THCRadioGroupButton.GetDisplayName: string;
begin
  Result := Caption;
  if Result = '' then Result := inherited GetDisplayName;
end;

function THCRadioGroupButton.GetGroup: TSCCustomRadioGroup;
begin
  Result := nil;
  if (Collection is THCRadioGroupButtons) and
    (THCRadioGroupButtons(Collection).FOwner is TSCCustomRadioGroup) then
    Result := TSCCustomRadioGroup(THCRadioGroupButtons(Collection).FOwner);
end;

procedure THCRadioGroupButton.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure THCRadioGroupButton.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed(False);
  end;
end;

procedure THCRadioGroupButton.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(False);
  end;
end;

{ TSCCustomRadioGroup }

function TSCCustomRadioGroup.BoxRect(R: TRect): TRect;
var
  H: Integer;
begin
  Result := R;
  H := GetBoxHeight;

  case FLayout of
    scrlTop:
      Inc(Result.Top);
    scrlMiddle:
      Result.Top := Result.Top + ((Result.Bottom - Result.Top) - H) div 2;
    scrlBottom:
      Result.Top := Result.Bottom - H - 1;
  end;

  Result.Bottom := Result.Top + H;

  Result.Left := Result.Left + 2;
  Result.Right := Result.Left + GetBoxWidth;
end;

function TSCCustomRadioGroup.CanModify: Boolean;
begin
  Result := True;
end;

function TSCCustomRadioGroup.Checked(Index: Integer): Boolean;
begin
  Result := (Index > -1) and (Index < FItems.Count) and
    (Index = FItemIndex);
end;

constructor TSCCustomRadioGroup.Create(AOwner: TComponent);
begin
  FColumns := 1;
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csDoubleClicks];
  ClickFocus := True;
  DoubleBuffered := True;
  
  FHotIndex := -1;
  FDownIndex := -1;
  FAsCheckbox := False;
  FBoxCheckedColor := clWindow;
  FBoxFrameColor := clBtnShadow;
  FBoxToggleColor := clBtnFace;
  FBoxUncheckedColor := clWindow;
  FHighlightColor := SC_HighlightColor;
  FHottrackColor := SC_HottrackColor;
  FLayout := scrlMiddle;
  FImageChecked := -1;
  FImageToggle := -1;
  FImageUnchecked := -1;
  FImageMark := -1;
  FItemColor := clNone;
  FItemDisabledColor := clGrayText;
  FItemHotColor := clRed;
  FItemHotUnderline := True;
  FItemHottrack := True;
  FItemIndex := -1;
  FItems := THCRadioGroupButtons.Create(Self);
  FMarkColor := clWindowText;
  FStyle := scrsWin2k;
end;

destructor TSCCustomRadioGroup.Destroy;
begin
  Destroying;
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TSCCustomRadioGroup.DoDrawAsRadio(Index: Integer; ClientR: TRect);
var
  C, TCl: TColor;
  IsChecked, IsPressed,
  IsFocused, InControl: Boolean;
begin
  if FStyle = scrsImage then
  begin
    DoDrawImageCb(Index, ClientR);
    Exit;
  end;

  if FStyle = scrsOfficeXP then
  begin
    DoDrawOfficeXPCb(Index, ClientR);
    Exit;
  end;

  IsChecked := Checked(Index);
  IsPressed := MousePressed(Index);
  InControl := MouseInItem(Index);
  IsFocused := ItemFocused(Index);

  C := clNone;
  if IsChecked then C := FMarkColor;

  case FStyle of
    scrsCorel:
    begin
      if IsFocused or IsPressed or InControl then
        DrawWin2kRb(Index, ClientR, GetBoxFaceColor(Index), C)
      else
        DrawFlatRb(Index, ClientR, clNone, GetBoxFaceColor(Index), C);
    end;
    scrsFlatFrame:
    begin
      if IsFocused or IsPressed or InControl then
        DrawWin2kRb(Index, ClientR, GetBoxFaceColor(Index), C)
      else
        DrawFlatFrameRb(Index, ClientR, GetBoxFaceColor(Index), C);
    end;
    scrsFlat:
      DrawFlatRb(Index, ClientR, clNone, GetBoxFaceColor(Index), C);
    scrsMetal:
      DrawFlatFrameRb(Index, ClientR, GetBoxFaceColor(Index), C);
    scrsImage:
      DoDrawImageCb(Index, ClientR);
    scrsMac:
      DrawMacRb(Index, ClientR, clWindowFrame, clWindow,
        Self.Color, C, IsChecked or InToggle(Index));
    scrsOfficeXP:
      DoDrawOfficeXPCb(Index, ClientR);
    scrsXP:
    begin
      TCl := clNone;
      if not IsPressed and InControl then
        TCl := FHottrackColor
      else
      if (IsPressed and not InControl) or (IsFocused and
        not (IsPressed or InControl)) then
        TCl := FHighlightColor;

      DrawXPRb(Index, ClientR, FBoxFrameColor,
        GetBoxFaceColor(Index), Self.Color, TCl, C);
    end;
    else
      DrawWin2kRb(Index, ClientR, GetBoxFaceColor(Index), C);
  end;
end;

procedure TSCCustomRadioGroup.DoDrawCorelCb(Index: Integer; ClientR: TRect);
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

procedure TSCCustomRadioGroup.DoDrawFlatCb(Index: Integer; ClientR: TRect);
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
    scrsFlat:
    begin
      if ItemFocused(Index) or MousePressed(Index) or MouseInItem(Index) then
        scFrame3D(Canvas, BoxR, clBtnShadow, clBtnHighlight, 1, 0);
    end;
    scrsFlatFrame:
    begin
      scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
      if ItemFocused(Index) or MousePressed(Index) or MouseInItem(Index) then
        scFrame3D(Canvas, BoxR, clBtnShadow, clBtnHighlight, 1, 0)
      else
        scFrame3D(Canvas, R, clBtnFace, clBtnFace, 1, 0)
    end;
  end;  
end;

procedure TSCCustomRadioGroup.DoDrawImageCb(Index: Integer; ClientR: TRect);
var
  Img: Integer;
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

  Img := FImageUnchecked;

  if InToggle(Index) then
    Img := FImageToggle
  else
  if Checked(Index) then
    Img := FImageChecked;

  if IsValidImage(Img) then
    Images.Draw(Canvas, BoxR.Left, BoxR.Top, Img, True);

  DoDrawMark(Index, BoxR);
end;

procedure TSCCustomRadioGroup.DoDrawMacCb(Index: Integer; ClientR: TRect);
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

procedure TSCCustomRadioGroup.DoDrawMark(Index: Integer; R: TRect;
  AColor: TColor);
var
  MR: TRect;
  L, T, I: Integer;
  Pts: array[0..2] of TPoint;
begin
  if (Canvas = nil) or (Index < 0) or
    (Index > FItems.Count-1) or not CanGetClientRect or
    not Checked(Index) then
    Exit;

  MR := R;
  if FStyle = scrsMac then
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
  if FStyle = scrsImage then
  begin
    if Checked(Index) and IsValidImage(FImageChecked) then
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

procedure TSCCustomRadioGroup.DoDrawOfficeXPCb(Index: Integer; ClientR: TRect);
var
  BoxR, R: TRect;
  Pts: array[0..8] of TPoint;
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

  if Checked(Index) then
  begin
    R := BoxR;
    
    if FAsCheckBox then
      DoDrawMark(Index, R, FOfficeMarkColor)
    else begin
      InflateRect(R, -4, -4);
      Dec(R.Right); Dec(R.Bottom);

      GenerateOctPoints(R, 1, Pts);

      with Canvas do
      begin
        Brush.Color := FOfficeMarkColor;
        Pen.Style := psSolid;
        Pen.Color := FOfficeMarkColor;

        Polygon(Pts);
      end;
    end;
  end;

  R := BoxR;
  scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
end;

procedure TSCCustomRadioGroup.DoDrawText(Index: Integer; var R: TRect;
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

procedure TSCCustomRadioGroup.DoDrawWin2kCb(Index: Integer; ClientR: TRect);
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

procedure TSCCustomRadioGroup.DoDrawXPCb(Index: Integer; ClientR: TRect);
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

procedure TSCCustomRadioGroup.DrawFlatRb(Index: Integer; ClientR: TRect;
  FrmColor, InnerColor, CheckColor: TColor);

  function GetBoxRect(Inflate: Integer): TRect;
  begin
    Result := BoxRect(ClientR);

    if Inflate > 12 then Inflate := 12;
    InflateRect(Result, Inflate, Inflate);
  end;

var
  R: TRect;
  I, J: Integer;
  TopColors: array[0..1] of TColor;
  BtmColors: array[0..1] of TColor;
begin
  TopColors[0] := clBtnShadow;
  TopColors[1] := clWindow;

  BtmColors[0] := clBtnHighlight;
  BtmColors[1] := clWindow;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Pen.Style := psSolid;
    Pen.Width := 1;

    Pen.Color := InnerColor;
    Brush.Color := InnerColor;

    if FrmColor <> clNone then
    begin
      TopColors[Low(TopColors)] := FrmColor;
      BtmColors[Low(BtmColors)] := FrmColor;
    end;

    TopColors[High(TopColors)] := InnerColor;
    BtmColors[High(BtmColors)] := InnerColor;

    R := GetBoxRect(0);
    Ellipse(R.Left, R.Top, R.Right, R.Bottom);

    if CheckColor <> clNone then
    begin
      Pen.Color := CheckColor;
      Brush.Color := CheckColor;

      R := GetBoxRect(-4);
      Ellipse(R.Left, R.Top, R.Right, R.Bottom);

      Pen.Color := InnerColor;
      Brush.Color := InnerColor;
    end;

    for I := 0 to 1 do
    begin
      R := GetBoxRect(-I);

      Pen.Color := TopColors[I];

      Dec(R.Right);
      Dec(R.Bottom);

      for J := 0 to 2 do
      begin
        Arc(R.Left, R.Top, R.Right, R.Bottom, R.Right - 1, R.Top, R.Left, R.Bottom - 1);

        Inc(R.Right);
        Inc(R.Bottom);
      end;
    end;

    for I := 0 to 1 do
    begin
      R := GetBoxRect(-I);

      Pen.Color := BtmColors[I];

      Inc(R.Left);
      Inc(R.Top);

      for J := 0 to 2 do
      begin
        Arc(R.Left, R.Top, R.Right, R.Bottom, R.Left + 1, R.Bottom, R.Right, R.Top + 1);

        Dec(R.Left);
        Dec(R.Top);
      end;
    end;
  end;
end;

procedure TSCCustomRadioGroup.DrawItem(Index: Integer);
var
  SR: Integer;
  R, CR, RgnR, Tr: TRect;
begin
  if (Index > -1) and (Index < FItems.Count) then
  begin
    CR := ClientRect;
    AdjustClientRect(CR);

    InflateRect(CR, -2, -2);

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

      if not FAsCheckbox then
        DoDrawAsRadio(Index, R)
      else begin
        case FStyle of
          scrsCorel:
            DoDrawCorelCb(Index, R);
          scrsFlat, scrsFlatFrame:
            DoDrawFlatCb(Index, R);
          scrsImage:
            DoDrawImageCb(Index, R);
          scrsMac:
            DoDrawMacCb(Index, R);
          scrsOfficeXP:
            DoDrawOfficeXPCb(Index, R);
          scrsWin2k:
            DoDrawWin2kCb(Index, R);
          scrsXP:
            DoDrawXPCb(Index, R);
          scrsMetal:
            DoDrawMetalCb(Index, R);
        end;
      end;

      CR := R;

      R := InnerRect(R);
      if IsRectEmpty(R) then
        Exit;

      IntersectRect(RgnR, R, CR);
      if IsRectEmpty(RgnR) then
        Exit;

      if FMultiline or (HasFocus and ItemFocused(Index)) then
      begin
        Tr := R;
        DoDrawText(Index, Tr, True);

        OffsetRect(Tr, -Tr.Left, -Tr.Top);
        OffsetRect(Tr, R.Left, 0);

        case FLayout of
          scrlTop:
            OffsetRect(Tr, 0, R.Top);
          scrlMiddle:
            OffsetRect(Tr, 0, R.Top + ((R.Bottom - R.Top) - (Tr.Bottom - Tr.Top)) div 2);
          scrlBottom:
            OffsetRect(Tr, 0, R.Bottom - Tr.Bottom);
        end;

        R := Tr;
      end;

      DoDrawText(Index, R);

      if HasFocus and ItemFocused(Index) and not IsRectEmpty(R) then
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

procedure TSCCustomRadioGroup.DrawMacRb(Index: Integer;
  ClientR: TRect; FrmColor, InnerColor, OutterColor, CheckColor: TColor;
  Pressed: Boolean);

  function GetBoxRect(Inflate: Integer): TRect;
  begin
    Result := BoxRect(ClientR);

    if Inflate > 11 then Inflate := 11;
    InflateRect(Result, Inflate, Inflate);
  end;

var
  R: TRect;
  I, J, Mix: Integer;
  Pts: array[0..8] of TPoint;
  C: TColor;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Pen.Style := psSolid;
    Pen.Width := 1;

    R := GetBoxRect(0);
    InflateRect(R, 1, 1);
    Inc(R.Left);
    Inc(R.Top);

    Brush.Color := InnerColor;
    Pen.Color := InnerColor;
    Ellipse(R.Left, R.Top, R.Right, R.Bottom);

    if not Pressed then
    begin
      Brush.Style := bsClear;
      C := MixColors(InnerColor, clBlack, 30);

      R := GetBoxRect(-2);
      Inc(R.Right);
      Inc(R.Bottom);

      Mix := 15;
      while not IsRectEmpty(R) do
      begin
        Pen.Color := C;

        Rectangle(R.Left, R.Top, R.Right, R.Bottom);

        Dec(R.Right);
        Dec(R.Bottom);

        if Mix < 100 then
        begin
          Inc(Mix, 15);
          if Mix > 100 then Mix := 100;

          C := MixColors(C, clWhite, Mix);
        end else
          Break;
      end;

      C := MixColors(InnerColor, clBlack, 30);

      R := GetBoxRect(-2);
      Inc(R.Right);
      Inc(R.Bottom);

      Mix := 0; J := 0;
      while 2*J <= R.Right - R.Left do
      begin
        Pen.Color := C;

        Dec(R.Right, J);
        Dec(R.Bottom, J);
        try
          for I := 0 to 1 do
          begin
            GenerateOctPoints(R, I + 4, Pts);

            MoveTo(Pts[3].x, Pts[3].y);
            LineTo(Pts[4].x - 1, Pts[4].y + 1);
          end;
        finally
          Inc(R.Right, J);
          Inc(R.Bottom, J);
        end;

        Inc(J);

        if Mix < 100 then
        begin
          Inc(Mix, 15);
          if Mix > 100 then Mix := 100;

          C := MixColors(C, clWhite, Mix);
        end else
          Break;
      end;

      Brush.Style := bsSolid;

      for I := 0 to 2 do
      begin
        Pen.Color := MixColors(InnerColor, clBlack, 25 - 5*I);
        GenerateOctPoints(GetBoxRect(-1), I + 2, Pts);

        MoveTo(Pts[6].x, Pts[6].y);

        LineTo(Pts[7].x, Pts[7].y);
        LineTo(Pts[0].x, Pts[0].y);
        LineTo(Pts[1].x, Pts[1].y);
      end;

      Pen.Color := MixColors(InnerColor, clBlack, 5);
      for I := 0 to 1 do
      begin
        GenerateOctPoints(GetBoxRect(-2), I + 3, Pts);

        MoveTo(Pts[6].x, Pts[6].y + 1);

        LineTo(Pts[7].x, Pts[7].y);
        LineTo(Pts[0].x, Pts[0].y);
        LineTo(Pts[1].x + 2, Pts[1].y);
      end;

      Pen.Color := MixColors(InnerColor, clBlack, 45);
      for I := 0 to 2 do
      begin
        GenerateOctPoints(GetBoxRect(-1), I + 1, Pts);

        MoveTo(Pts[2].x, Pts[2].y);

        LineTo(Pts[3].x, Pts[3].y);
        LineTo(Pts[4].x, Pts[4].y);
        LineTo(Pts[5].x, Pts[5].y);
      end;
    end else
    begin

    end;

    if CheckColor <> clNone then
    begin
      Brush.Color := MixColors(CheckColor, InnerColor, 40);
      Pen.Color := Brush.Color;

      GenerateOctPoints(GetBoxRect(-4), 1, Pts);
      Polygon(Pts);

      Brush.Color := CheckColor;
      Pen.Color := CheckColor;

      GenerateOctPoints(GetBoxRect(-4), 2, Pts);
      Polygon(Pts);

      Brush.Color := InnerColor;
      Pen.Color := InnerColor;
    end;

    Pen.Color := MixColors(FrmColor, OutterColor, 90);
    GenerateOctPoints(GetBoxRect(0), 2, Pts);
    PolyLine(Pts);

    Pen.Color := FrmColor;
    GenerateOctPoints(GetBoxRect(0), 3, Pts);
    PolyLine(Pts);

    Pen.Color := MixColors(FrmColor, OutterColor, 70);
    for I := Low(Pts) to High(Pts) do
    begin
      MoveTo(Pts[I].x, Pts[I].y);
      LineTo(Pts[I].x, Pts[I].y + 1);
    end;

    Pen.Color := MixColors(FrmColor, OutterColor, 30);
    GenerateOctPoints(GetBoxRect(0), 4, Pts);
    for I := Low(Pts) to High(Pts) do
    begin
      MoveTo(Pts[I].x, Pts[I].y);
      LineTo(Pts[I].x, Pts[I].y + 1);
    end;

    Pen.Color := MixColors(FrmColor, InnerColor, 40);
    GenerateOctPoints(GetBoxRect(-1), 2, Pts);
    for I := Low(Pts) to High(Pts) do
    begin
      MoveTo(Pts[I].x, Pts[I].y);
      LineTo(Pts[I].x, Pts[I].y + 1);
    end;
  end;
end;

procedure TSCCustomRadioGroup.DrawWin2kRb(Index: Integer; ClientR: TRect;
  InnerColor, CheckColor: TColor);

  function GetBoxRect(Inflate: Integer): TRect;
  begin
    Result := BoxRect(ClientR);

    if Inflate > 12 then Inflate := 12;
    InflateRect(Result, Inflate, Inflate);
  end;

var
  R: TRect;
  I, J: Integer;
  TopColors: array[0..2] of TColor;
  BtmColors: array[0..2] of TColor;
begin
  TopColors[0] := clBtnShadow;
  TopColors[1] := cl3DDkShadow;
  TopColors[2] := clWindow;

  BtmColors[0] := clBtnHighlight;
  BtmColors[1] := clBtnFace;
  BtmColors[2] := clWindow;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Pen.Style := psSolid;
    Pen.Width := 1;

    Pen.Color := InnerColor;
    Brush.Color := InnerColor;

    TopColors[High(TopColors)] := InnerColor;
    BtmColors[High(BtmColors)] := InnerColor;

    R := GetBoxRect(0);
    Ellipse(R.Left, R.Top, R.Right, R.Bottom);

    if CheckColor <> clNone then
    begin
      Pen.Color := CheckColor;
      Brush.Color := CheckColor;

      R := GetBoxRect(-4);
      Ellipse(R.Left, R.Top, R.Right, R.Bottom);

      Pen.Color := InnerColor;
      Brush.Color := InnerColor;
    end;

    for I := 0 to 2 do
    begin
      R := GetBoxRect(-I);

      Pen.Color := TopColors[I];

      Dec(R.Right);
      Dec(R.Bottom);

      for J := 0 to 2 do
      begin
        Arc(R.Left, R.Top, R.Right, R.Bottom, R.Right - 1, R.Top, R.Left, R.Bottom - 1);

        Inc(R.Right);
        Inc(R.Bottom);
      end;
    end;

    for I := 0 to 2 do
    begin
      R := GetBoxRect(-I);

      Pen.Color := BtmColors[I];

      Inc(R.Left);
      Inc(R.Top);

      for J := 0 to 2 do
      begin
        Arc(R.Left, R.Top, R.Right, R.Bottom, R.Left + 1, R.Bottom, R.Right, R.Top + 1);

        Dec(R.Left);
        Dec(R.Top);
      end;
    end;
  end;
end;

procedure TSCCustomRadioGroup.DrawXPRb(Index: Integer; ClientR: TRect;
  FrmColor, InnerColor, OutterColor, TrackColor, CheckColor: TColor);

  function GetBoxRect(Inflate: Integer): TRect;
  begin
    Result := BoxRect(ClientR);

    if Inflate > 12 then Inflate := 12;
    InflateRect(Result, Inflate, Inflate);
  end;

var
  R: TRect;
  I, Mid: Integer;
  Pts: array[0..8] of TPoint;
  TrackTopColor, TrackBtmColor: TColor;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Pen.Style := psSolid;
    Pen.Width := 1;

    R := GetBoxRect(0);
    Inc(R.Left);
    Inc(R.Top);

    Brush.Color := InnerColor;
    Pen.Color := InnerColor;
    Ellipse(R.Left, R.Top, R.Right, R.Bottom);

    if CheckColor <> clNone then
    begin
      Brush.Color := MixColors(CheckColor, InnerColor, 40);
      Pen.Color := Brush.Color;

      GenerateOctPoints(GetBoxRect(-4), 1, Pts);
      Polygon(Pts);

      Brush.Color := CheckColor;
      Pen.Color := CheckColor;

      GenerateOctPoints(GetBoxRect(-4), 2, Pts);
      Polygon(Pts);

      Brush.Color := InnerColor;
      Pen.Color := InnerColor;
    end;

    TrackTopColor := InnerColor;
    TrackBtmColor := InnerColor;

    if TrackColor <> clNone then
    begin
      TrackTopColor := MixColors(TrackColor, InnerColor, 40);
      TrackBtmColor := MixColors(TrackColor, InnerColor, -20);

      Pen.Color := TrackBtmColor;
      GenerateOctPoints(GetBoxRect(-1), 3, Pts);
      PolyLine(Pts);

      GenerateOctPoints(GetBoxRect(-2), 2, Pts);
      PolyLine(Pts);

      GenerateOctPoints(GetBoxRect(-2), 3, Pts);
      PolyLine(Pts);

      Pen.Color := TrackTopColor;

      GenerateOctPoints(GetBoxRect(-1), 3, Pts);
      MoveTo(Pts[6].x, Pts[6].y);
      LineTo(Pts[7].x, Pts[7].y);
      LineTo(Pts[0].x, Pts[0].y);
      LineTo(Pts[1].x, Pts[1].y);
      LineTo(Pts[2].x, Pts[2].y);

      GenerateOctPoints(GetBoxRect(-2), 2, Pts);
      MoveTo(Pts[6].x, Pts[6].y);
      LineTo(Pts[7].x, Pts[7].y);
      LineTo(Pts[0].x, Pts[0].y);
      LineTo(Pts[1].x, Pts[1].y);
      LineTo(Pts[2].x, Pts[2].y);

      GenerateOctPoints(GetBoxRect(-2), 3, Pts);
      MoveTo(Pts[6].x, Pts[6].y);
      LineTo(Pts[7].x, Pts[7].y);
      LineTo(Pts[0].x, Pts[0].y);
      LineTo(Pts[1].x, Pts[1].y);
      LineTo(Pts[2].x, Pts[2].y);

      Pen.Color := MixColors(TrackColor, InnerColor, 70);
      GenerateOctPoints(GetBoxRect(-3), 2, Pts);
      for I := Low(Pts) to High(Pts) do
      begin
        MoveTo(Pts[I].x, Pts[I].y);
        LineTo(Pts[I].x, Pts[I].y + 1);
      end;
    end;

    Pen.Color := FrmColor;
    GenerateOctPoints(GetBoxRect(0), 4, Pts);
    PolyLine(Pts);

    Pen.Color := MixColors(FrmColor, OutterColor, 50);
    GenerateOctPoints(GetBoxRect(0), 3, Pts);

    MoveTo(Pts[1].x + 1, Pts[1].y + 1);
    LineTo(Pts[2].x, Pts[2].y);

    MoveTo(Pts[3].x - 1, Pts[3].y + 1);
    LineTo(Pts[4].x, Pts[4].y);

    MoveTo(Pts[5].x - 1, Pts[5].y - 1);
    LineTo(Pts[6].x, Pts[6].y);

    MoveTo(Pts[7].x + 1, Pts[7].y - 1);
    LineTo(Pts[0].x, Pts[0].y);

    GenerateOctPoints(GetBoxRect(0), 4, Pts);
    for I := Low(Pts) to High(Pts) do
    begin
      MoveTo(Pts[I].x, Pts[I].y);
      LineTo(Pts[I].x, Pts[I].y + 1);
    end;

    Pen.Color := MixColors(FrmColor, TrackBtmColor, 70);
    GenerateOctPoints(GetBoxRect(-1), 3, Pts);
    PolyLine(Pts);

    if TrackColor <> clNone then
    begin
      Pen.Color := MixColors(FrmColor, TrackTopColor, 70);
      GenerateOctPoints(GetBoxRect(-1), 3, Pts);

      MoveTo(Pts[5].x, Pts[5].y);
      LineTo(Pts[6].x, Pts[6].y);
      LineTo(Pts[7].x, Pts[7].y);
      LineTo(Pts[0].x, Pts[0].y);
      LineTo(Pts[1].x, Pts[1].y);
      LineTo(Pts[2].x, Pts[2].y);
    end;

    Pen.Color := MixColors(FrmColor, TrackBtmColor, 50);
    for I := Low(Pts) to High(Pts) do
    begin
      MoveTo(Pts[I].x, Pts[I].y);
      LineTo(Pts[I].x, Pts[I].y + 1);
    end;

    Pen.Color := TrackTopColor;

    Mid := Pts[0].x + (Pts[1].x - Pts[0].x) div 2;
    MoveTo(Mid, Pts[0].y);
    LineTo(Mid, Pts[0].y + 1);

    Mid := Pts[7].y + (Pts[6].y - Pts[7].y) div 2;
    MoveTo(Pts[7].x, Mid);
    LineTo(Pts[7].x, Mid + 1);

    Pen.Color := TrackBtmColor;

    Mid := Pts[5].x + (Pts[4].x - Pts[5].x) div 2;
    MoveTo(Mid, Pts[5].y);
    LineTo(Mid, Pts[5].y + 1);

    Mid := Pts[2].y + (Pts[3].y - Pts[2].y) div 2;
    MoveTo(Pts[2].x, Mid);
    LineTo(Pts[2].x, Mid + 1);
  end;
end;

procedure TSCCustomRadioGroup.EnabledChanged;
begin
  if (FHotIndex > -1) or (FDownIndex > -1) then
  begin
    FHotIndex := -1;
    FDownIndex := -1;

    Invalidate;
  end;
  inherited EnabledChanged;
end;

procedure TSCCustomRadioGroup.FocusChanged;
begin
  if not HasFocus and (FDownIndex > -1) then
  begin
    FDownIndex := -1;
    Invalidate;
  end;
  inherited FocusChanged;
end;

procedure TSCCustomRadioGroup.GenerateOctPoints(Rc: TRect;
  RoundBy: Integer; var Pts: array of TPoint);
var
  Mid, I, L, H: Integer;
begin
  if Length(Pts) = 0 then Exit;

  Mid := (Rc.Right - Rc.Left) div 2;
  if RoundBy > Mid then RoundBy := Mid;

  Mid := (Rc.Bottom - Rc.Top) div 2;
  if RoundBy > Mid then RoundBy := Mid;

  L := Low(Pts);
  H := High(Pts);

  Pts[L].x := Rc.Left + RoundBy;
  Pts[L].y := Rc.Top;

  Inc(L);
  if L > H then Exit;

  Pts[L].x := Rc.Right - RoundBy;
  Pts[L].y := Rc.Top;

  Inc(L);
  if L > H then Exit;

  Pts[L].x := Rc.Right;
  Pts[L].y := Rc.Top + RoundBy;

  Inc(L);
  if L > H then Exit;

  Pts[L].x := Rc.Right;
  Pts[L].y := Rc.Bottom - RoundBy;

  Inc(L);
  if L > H then Exit;

  Pts[L].x := Rc.Right - RoundBy;
  Pts[L].y := Rc.Bottom;

  Inc(L);
  if L > H then Exit;

  Pts[L].x := Rc.Left + RoundBy;
  Pts[L].y := Rc.Bottom;

  Inc(L);
  if L > H then Exit;

  Pts[L].x := Rc.Left;
  Pts[L].y := Rc.Bottom - RoundBy;

  Inc(L);
  if L > H then Exit;

  Pts[L].x := Rc.Left;
  Pts[L].y := Rc.Top + RoundBy;

  Inc(L);
  if L > H then Exit;

  Pts[L].x := Rc.Left + RoundBy;
  Pts[L].y := Rc.Top;

  Inc(L);
  for I := L to H do
  begin
    Pts[I].x := -1;
    Pts[I].y := -1;
  end;
end;

function TSCCustomRadioGroup.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomRadioGroup.GetBoxFaceColor(Index: Integer): TColor;
var
  Checked, IsHot, IsDown: Boolean;
begin
  Checked := Index = FItemIndex;
  
  if FStyle = scrsOfficeXP then
  begin
    Result := GetOfficeXPBtnColor;
    FOfficeMarkColor := clBtnText;

    if (Index < 0) or (Index > FItems.Count-1) then
      Exit;

    IsHot  := FHotIndex = Index;
    IsDown := FDownIndex = Index;

    if Checked then
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
    if Checked then
      Result := FBoxCheckedColor;
  end;    
end;

function TSCCustomRadioGroup.GetBoxHeight: Integer;
begin
  Result := 13;
  if FStyle = scrsMac then Result := 12;

  if not FAsCheckbox and (FStyle <> scrsOfficeXP) then
    Dec(Result);

  if (FStyle = scrsImage) and (Images <> nil) then
    Result := Images.Height;
end;

function TSCCustomRadioGroup.GetBoxWidth: Integer;
begin
  Result := 13;
  if FStyle = scrsMac then Result := 12;

  if not FAsCheckbox and (FStyle <> scrsOfficeXP) then
    Dec(Result);

  if (FStyle = scrsImage) and (Images <> nil) then
    Result := Images.Width;
end;

function TSCCustomRadioGroup.FindEnabled(Index: Integer; BackSearch: Boolean): Integer;
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

function TSCCustomRadioGroup.GetItemAtPos(X, Y: Integer): Integer;
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

function TSCCustomRadioGroup.GetItemRect(Index: Integer): TRect;
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

function TSCCustomRadioGroup.InnerRect(R: TRect): TRect;
var
  BoxR: TRect;
begin
  Result := R;

  BoxR := BoxRect(R);
  Result.Left := BoxR.Right + 4;

  if Result.Left > Result.Right then
    Result.Left := Result.Right;
end;

function TSCCustomRadioGroup.InToggle(Index: Integer): Boolean;
begin
  Result := False;
end;

procedure TSCCustomRadioGroup.ItemChanged(Item: THCRadioGroupButton);
begin
  if not IsDestroying then
  begin
    UpdateVisibleItemCount;
    Invalidate;
  end;  
end;

function TSCCustomRadioGroup.ItemFocused(Index: Integer): Boolean;
begin
  Result := HasFocus and (Index > -1) and (Index < FItems.Count) and
    FItems[Index].Enabled and ((Index = FDownIndex) or
    ((FDownIndex = -1) and (Index = FItemIndex)));
end;

procedure TSCCustomRadioGroup.ItemsChanged;
begin
  //
end;

procedure TSCCustomRadioGroup.KeyDown(var Key: Word; Shift: TShiftState);
var
  Index, ColCnt: Integer;
begin
  inherited KeyDown(Key, Shift);

  if FDownIndex < -1 then
  begin
    FDownIndex := -1;
    Invalidate;
  end;

  if (Key in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT,
    VK_HOME, VK_END]) and not CanModify then
    Exit;
    
  case Key of
    VK_UP:
    begin
      Index := FItemIndex;

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
      if Index > -1 then SetItemIndex(Index);
    end;
    VK_DOWN:
    begin
      Index := FItemIndex;

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
      if Index > -1 then SetItemIndex(Index);
    end;
    VK_RIGHT:
    begin
      Index := FItemIndex;

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
          if FItemIndex div ColCnt < FColumns-1 then
             Index := FItems.Count-1;
        end;
      end;
      
      Index := FindEnabled(Index, True);
      if Index > -1 then SetItemIndex(Index);
    end;
    VK_LEFT:
    begin
      Index := FItemIndex;

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
      if Index > -1 then SetItemIndex(Index);
    end;
    VK_HOME:
    begin
      Index := 0;
      if FItems.Count = 0 then
        Index := -1;

      Index := FindEnabled(Index);
      if Index > -1 then SetItemIndex(Index);
    end;
    VK_END:
    begin
      Index := FindEnabled(FItems.Count-1, True);
      if Index > -1 then SetItemIndex(Index);
    end;
  end;
end;

procedure TSCCustomRadioGroup.Loaded;
begin
  inherited Loaded;
  UpdateVisibleItemCount;
end;

procedure TSCCustomRadioGroup.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldHot: Integer;
begin
  OldHot := FHotIndex;
  
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
  end;

  if (OldHot <> FHotIndex) or (FDownIndex > -1) then
    Invalidate;
end;

procedure TSCCustomRadioGroup.MouseInControlChanged;
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

function TSCCustomRadioGroup.MouseInItem(Index: Integer): Boolean;
begin
  Result := (Index > -1) and (Index < FItems.Count) and
    (Index = FHotIndex);
end;

procedure TSCCustomRadioGroup.MouseMove(Shift: TShiftState; X, Y: Integer);
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

function TSCCustomRadioGroup.MousePressed(Index: Integer): Boolean;
begin
  Result := (Index > -1) and (Index < FItems.Count) and
    (Index = FDownIndex);
end;

procedure TSCCustomRadioGroup.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldIndex, OldDown, OldHot: Integer;
begin
  OldDown := FDownIndex;
  FDownIndex := -1;

  OldHot := FHotIndex;
  OldIndex := FItemIndex;

  FHotIndex := GetItemAtPos(X, Y);
  if (FHotIndex > -1) and not FItems[FHotIndex].Enabled then
    FHotIndex := -1;

  if (Button = mbLeft) and (OldDown = FHotIndex) and
    (FHotIndex > -1) and CanModify then
    SetItemIndex(FHotIndex);

  if (OldIndex = FItemIndex) and ((OldDown > -1) or
    (OldHot <> FHotIndex)) then
    Invalidate;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomRadioGroup.Paint;
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

procedure TSCCustomRadioGroup.ReadState(Reader: TReader);
begin
  inherited ReadState(Reader);
  UpdateVisibleItemCount;
end;

procedure TSCCustomRadioGroup.ResetDownIndex;
begin
  if FDownIndex > -1 then
  begin
    FDownIndex := -1;
    Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetAsCheckbox(Value: Boolean);
begin
  if FAsCheckbox <> Value then
  begin
    FAsCheckbox := Value;
    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetBoxCheckedColor(Value: TColor);
begin
  if FBoxCheckedColor <> Value then
  begin
    FBoxCheckedColor := Value;
    if (FStyle <> scrsImage) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetBoxFrameColor(Value: TColor);
begin
  if FBoxFrameColor <> Value then
  begin
    FBoxFrameColor := Value;
    if (FStyle = scrsXP) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetBoxToggleColor(Value: TColor);
begin
  if FBoxToggleColor <> Value then
  begin
    FBoxToggleColor := Value;
    if (FStyle <> scrsImage) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetBoxUncheckedColor(Value: TColor);
begin
  if FBoxUncheckedColor <> Value then
  begin
    FBoxUncheckedColor := Value;
    if (FStyle <> scrsImage) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetColumns(Value: Integer);
begin
  if Value < 1 then Value := 1;

  if FColumns <> Value then
  begin
    FColumns := Value;
    if (FItems <> nil) and (FItems.Count > 1) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    if FItems.Count > 0 then
      Invalidate;
  end;    
end;

procedure TSCCustomRadioGroup.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    if (FStyle = scrsXP) and (FItems <> nil) and (FItems.Count > 1) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetHottrackColor(Value: TColor);
begin
  if FHottrackColor <> Value then
  begin
    FHottrackColor := Value;
    if (FStyle = scrsXP) and (FItems <> nil) and (FItems.Count > 1) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetImageChecked(Value: TImageIndex);
begin
  if FImageChecked <> Value then
  begin
    FImageChecked := Value;
    if (FStyle = scrsImage) and (Images <> nil) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetImageMark(Value: TImageIndex);
begin
  if FImageMark <> Value then
  begin
    FImageMark := Value;
    if (FStyle = scrsImage) and (Images <> nil) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetImageToggle(Value: TImageIndex);
begin
  if FImageToggle <> Value then
  begin
    FImageToggle := Value;
    if (FStyle = scrsImage) and (Images <> nil) and
      (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetImageUnchecked(Value: TImageIndex);
begin
  if FImageUnchecked <> Value then
  begin
    FImageUnchecked := Value;
    if (FStyle = scrsImage) and (Images <> nil) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetItemColor(Value: TColor);
begin
  if FItemColor <> Value then
  begin
    FItemColor := Value;
    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetItemDisabledColor(Value: TColor);
begin
  if FItemDisabledColor <> Value then
  begin
    FItemDisabledColor := Value;
    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetItemHotColor(Value: TColor);
begin
  if FItemHotColor <> Value then
  begin
    FItemHotColor := Value;

    if FItemHottrack and (FHotIndex > -1) and
      (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetItemHottrack(Value: Boolean);
begin
  if FItemHottrack <> Value then
  begin
    FItemHottrack := Value;
    if (FHotIndex > -1) and (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetItemHotUnderline(Value: Boolean);
begin
  if FItemHotUnderline <> Value then
  begin
    FItemHotUnderline := Value;

    if FItemHottrack and (FHotIndex > -1) and
      (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetItemIndex(Value: Integer);
begin
  if Value < -1 then Value := -1;

  if FItemIndex <> Value then
  begin
    FItemIndex := Value;

    FDownIndex := -1;
    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;

    Change;
    if not (IsLoading or IsDestroying) then
    begin
      Inc(FClickCount);
      try
        Click;
      finally
        if (Self <> nil) then
          Dec(FClickCount);
      end;
    end;
  end;
end;

procedure TSCCustomRadioGroup.SetItems(Value: THCRadioGroupButtons);
begin
  FItems.Assign(Value);
  UpdateVisibleItemCount;

  ItemsChanged;
end;

procedure TSCCustomRadioGroup.SetMarkColor(Value: TColor);
begin
  if FMarkColor <> Value then
  begin
    FMarkColor := Value;
    if (FStyle <> scrsImage) and (FItems <> nil) and (FItems.Count > 1) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetStyle(Value: TSCRadioStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.StopTracking;
begin
  if FDownIndex = -1 then
  begin
    if GetCapture = Handle then
      ReleaseCapture;
  end else
  begin
    FHotIndex := -1;
    FDownIndex := -1;

    Invalidate;
  end;
  inherited StopTracking;
end;

procedure TSCCustomRadioGroup.UpdateVisibleItemCount;
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

procedure TSCCustomRadioGroup.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTCHARS or DLGC_WANTARROWS;
end;

procedure TSCCustomRadioGroup.SetMultiline(Value: Boolean);
begin
  if FMultiline <> Value then
  begin
    FMultiline := Value;
    if FItems.Count > 0 then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.SetLayout(Value: TSCRadioLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioGroup.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomRadioGroup then
  begin
    with TSCCustomRadioGroup(Source) do
    begin
      Self.Columns := Columns;
      Self.AsCheckbox := AsCheckbox;
      Self.BoxCheckedColor := BoxCheckedColor;
      Self.BoxFrameColor := BoxFrameColor;
      Self.BoxToggleColor := BoxToggleColor;
      Self.BoxUncheckedColor := BoxUncheckedColor;
      Self.EndEllipsis := EndEllipsis;
      Self.HighlightColor := HighlightColor;
      Self.HottrackColor := HottrackColor;
      Self.ImageChecked := ImageChecked;
      Self.ImageToggle := ImageToggle;
      Self.ImageUnchecked := ImageUnchecked;
      Self.ImageMark := ImageMark;
      Self.ItemColor := ItemColor;
      Self.ItemDisabledColor := ItemDisabledColor;
      Self.ItemHotColor := ItemHotColor;
      Self.ItemHotUnderline := ItemHotUnderline;
      Self.ItemHottrack := ItemHottrack;
      Self.ItemIndex := ItemIndex;
      Self.Items := Items;
      Self.Layout := Layout;
      Self.MarkColor := MarkColor;
      Self.Multiline := Multiline;
      Self.Style := Style;
    end;
  end;
end;

procedure TSCCustomRadioGroup.DrawFlatFrameRb(Index: Integer;
  ClientR: TRect; InnerColor, CheckColor: TColor);

  function GetBoxRect(Inflate: Integer): TRect;
  begin
    Result := BoxRect(ClientR);

    if Inflate > 12 then Inflate := 12;
    InflateRect(Result, Inflate, Inflate);
  end;

var
  R: TRect;
  I, J: Integer;
  TopColors: array[0..2] of TColor;
  BtmColors: array[0..2] of TColor;
begin
  TopColors[0] := clBtnShadow;
  TopColors[1] := clBtnFace;
  TopColors[2] := clWindow;

  BtmColors[0] := clBtnHighlight;
  BtmColors[1] := clBtnFace;
  BtmColors[2] := clWindow;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Pen.Style := psSolid;
    Pen.Width := 1;

    Pen.Color := InnerColor;
    Brush.Color := InnerColor;

    TopColors[High(TopColors)] := InnerColor;
    BtmColors[High(BtmColors)] := InnerColor;

    R := GetBoxRect(0);
    Ellipse(R.Left, R.Top, R.Right, R.Bottom);

    if CheckColor <> clNone then
    begin
      Pen.Color := CheckColor;
      Brush.Color := CheckColor;

      R := GetBoxRect(-4);
      Ellipse(R.Left, R.Top, R.Right, R.Bottom);

      Pen.Color := InnerColor;
      Brush.Color := InnerColor;
    end;

    for I := 0 to 2 do
    begin
      R := GetBoxRect(-I);

      Pen.Color := TopColors[I];

      Dec(R.Right);
      Dec(R.Bottom);

      for J := 0 to 2 do
      begin
        Arc(R.Left, R.Top, R.Right, R.Bottom, R.Right - 1, R.Top, R.Left, R.Bottom - 1);

        Inc(R.Right);
        Inc(R.Bottom);
      end;
    end;

    for I := 0 to 2 do
    begin
      R := GetBoxRect(-I);

      Pen.Color := BtmColors[I];

      Inc(R.Left);
      Inc(R.Top);

      for J := 0 to 2 do
      begin
        Arc(R.Left, R.Top, R.Right, R.Bottom, R.Left + 1, R.Bottom, R.Right, R.Top + 1);

        Dec(R.Left);
        Dec(R.Top);
      end;
    end;
  end;
end;

procedure TSCCustomRadioGroup.DoDrawMetalCb(Index: Integer;
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

procedure TSCCustomRadioGroup.Click;
begin
  if FClickCount > 0 then
    inherited Click;
end;

{$I SCVerRec.inc}

end.
