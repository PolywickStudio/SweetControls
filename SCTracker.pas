{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCTracker;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCommon, SCConsts, SCControl, SCStdControls;

type
  TSCCustomTracker = class;

  TSCTrackerSlider = class(TPersistent)
  private
    FOwner: TSCCustomTracker;
    FColor: TColor;
    FSize: Integer;
    FVisible: Boolean;
    procedure SetColor(Value: TColor);
    procedure SetSize(Value: Integer);
    procedure SetVisible(Value: Boolean);
  protected
    procedure Changed;

    function GetOwner: TPersistent; override;
    property Tracker: TSCCustomTracker read FOwner;
  public
    constructor Create(AOwner: TSCCustomTracker);
    procedure Assign(Source: TPersistent); override;
  published
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Size: Integer read FSize write SetSize default 8;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TSCCustomTracker = class(TSCCustomProgress)
  private
    FPageSize: Integer;
    FSlider: TSCTrackerSlider;
    procedure SetSlider(Value: TSCTrackerSlider);

    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  protected
    procedure Paint; override;
    procedure SliderChanged; dynamic;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure ProcessTrackKey(Key: Word);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function GetSliderVisible: Boolean;
    function GetSliderRect: TRect; dynamic;
    function OnSlider(P: TPoint): Boolean;
    function PositionAtPos(P: TPoint): Integer;

    property PageSize: Integer read FPageSize write FPageSize default 2;
    property Slider: TSCTrackerSlider read FSlider write SetSlider;
    property TabStop default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  end;

  TSCTracker = class(TSCCustomTracker)
  published
    property Align;
    property Anchors;
    property BorderProps;
    property Color;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Max;
    property Min;
    property Orientation;
    property ParentColor;
    property ParentShowHint;
    property Percentage;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Position;
    property PositionColor;
    property PositionEndColor;
    property ShowHint;
    property Slice;
    property Slider;
    property Step;
    property Style;
    property TabOrder;
    property TabStop;
    property Tag;
    property Transparent;
    property Visible;
    property OnCanResize;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

{ TSCCustomTracker }

procedure TSCCustomTracker.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomTracker then
    Slider.Assign(TSCCustomTracker(Source).Slider);
end;

constructor TSCCustomTracker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TabStop := True;
  ClickFocus := True;

  FPageSize := 2;
  FSlider := TSCTrackerSlider.Create(Self);
end;

destructor TSCCustomTracker.Destroy;
begin
  FreeAndNil(FSlider);
  inherited Destroy;
end;

function TSCCustomTracker.GetSliderRect: TRect;
var
  R: TRect;
  Dif, Pos, P, RectSize: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if CanGetClientRect and GetSliderVisible then
  begin
    P := 0;
    Dif := Max - Min;

    R := GetClientRect;

    if Dif > 0 then
    begin
      Pos := NormalizePosition(Self.Position);
      
      if Orientation = scoHorizontal then
        RectSize := Result.Right - Result.Left
      else
        RectSize := Result.Bottom - Result.Top;

      if RectSize > 0 then
        P := Round((Pos - Min) * (RectSize / Dif));
    end;

    Result := R;
    Dif := Round(FSlider.Size / 2);

    if Orientation = scoHorizontal then
    begin
      Inc(Result.Left, P - Dif);
      Result.Right := Result.Left + FSlider.Size;
    end else
    begin
      Inc(Result.Top, P - Dif);
      Result.Bottom := Result.Top + FSlider.Size;
    end;
  end;
end;

function TSCCustomTracker.GetSliderVisible: Boolean;
begin
  Result := FSlider.Visible and (FSlider.Color <> clNone);
end;

procedure TSCCustomTracker.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  ProcessTrackKey(Key);
end;

procedure TSCCustomTracker.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if not (Ord(Key) in [VK_HOME, VK_END]) then
    ProcessTrackKey(Ord(Key));
end;

procedure TSCCustomTracker.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if CanGetFocus and not Focused then
    Self.SetFocus;

  if Focused and MouseIsDown then
    SetPosition(PositionAtPos(Point(X, Y)));
end;

procedure TSCCustomTracker.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if MouseIsDown then
    SetPosition(PositionAtPos(Point(X, Y)));

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomTracker.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if MouseIsDown then
    SetPosition(PositionAtPos(Point(X, Y)));

  inherited MouseUp(Button, Shift, X, Y);
end;

function TSCCustomTracker.OnSlider(P: TPoint): Boolean;
var
  R: TRect;
begin
  Result := False;
  if GetSliderVisible and CanGetClientRect then
  begin
    R := GetClientRect;

    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      R := GetSliderRect;
      Result := not IsRectEmpty(R) and
        PtInRect(R, P);
    end;
  end;
end;

procedure TSCCustomTracker.Paint;
var
  R: TRect;
begin
  inherited Paint;

  if GetSliderVisible then
  begin
    R := GetSliderRect;
    if not IsRectEmpty(R) then
    begin
      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := FSlider.Color;

        FillRect(R);
      end;

      scFrame3D(Canvas, R, GetBtnHighlightOf(FSlider.Color),
         Get3DDkShadowOf(FSlider.Color), 1, 0);

      scFrame3D(Canvas, R, FSlider.Color,
        GetBtnShadowOf(FSlider.Color), 1, 0);
    end;
  end;
end;

function TSCCustomTracker.PositionAtPos(P: TPoint): Integer;
var
  R: TRect;
  Count: Integer;
begin
  Result := NormalizePosition(Self.Position);

  if CanGetClientRect then
  begin
    Count := Max - Min;
    if Count < 1 then
      Exit;

    R  := GetClientRect;
    if IsRectEmpty(R) then
      Exit;

    if Orientation = scoHorizontal then
    begin
      if P.x < R.Left then
      begin
        Result := Min;
        Exit;
      end;

      if P.x > R.Right then
      begin
        Result := Max;
        Exit;
      end;

      Result := Min + Muldiv(Count, P.x, R.Right);
    end else
    begin
      if P.y < R.Top then
      begin
        Result := Min;
        Exit;
      end;

      if P.y > R.Bottom then
      begin
        Result := Max;
        Exit;
      end;

      Result := Min + Muldiv(Count, P.y, R.Bottom);
    end;
  end;

  if Result < Min then
    Result := Min;

  if Result > Max then
    Result := Max;
end;

procedure TSCCustomTracker.ProcessTrackKey(Key: Word);
var
  P1, P2: Integer;
begin
  P1 := NormalizePosition(Position);
  P2 := P1;

  case Key of
    VK_LEFT, VK_UP:
      Dec(P2, Step);
    VK_RIGHT, VK_DOWN:
      Inc(P2, Step);
    VK_PRIOR:
      Dec(P2, PageSize);
    VK_NEXT:
      Inc(P2, PageSize);
    VK_HOME:
      P2 := Min;
    VK_END:
      P2 := Max;
  end;

  if P1 <> P2 then
    SetPosition(P2);
end;

procedure TSCCustomTracker.SetSlider(Value: TSCTrackerSlider);
begin
  FSlider.Assign(Value);
end;

procedure TSCCustomTracker.SliderChanged;
begin
  Invalidate;
end;

procedure TSCCustomTracker.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTALLKEYS or DLGC_WANTARROWS;
end;

procedure TSCCustomTracker.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if Message.WheelDelta < 0 then
    SetPosition(Position + Step)
  else
  if Message.WheelDelta > 0 then
    SetPosition(Position - Step);
end;

{ TSCTrackerSlider }

procedure TSCTrackerSlider.Assign(Source: TPersistent);
begin
  if Source is TSCTrackerSlider then
  begin
    with TSCTrackerSlider(Source) do
    begin
      Self.FColor := Color;
      Self.FSize := Size;
      Self.FVisible := Visible;
    end;
  end else
    inherited Assign(Source);
end;

procedure TSCTrackerSlider.Changed;
begin
  if FOwner <> nil then FOwner.SliderChanged;
end;

constructor TSCTrackerSlider.Create(AOwner: TSCCustomTracker);
begin
  inherited Create;
  FOwner := AOwner;
  FColor := clBtnFace;
  FSize := 8;
  FVisible := True;
end;

function TSCTrackerSlider.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCTrackerSlider.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed;
  end;
end;

procedure TSCTrackerSlider.SetSize(Value: Integer);
begin
  if Value < 2 then
    Value := 2;

  if FSize <> Value then
  begin
    FSize := Value;
    Changed;
  end;
end;

procedure TSCTrackerSlider.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed;
  end;
end;

{$I SCVerRec.inc}

end.
