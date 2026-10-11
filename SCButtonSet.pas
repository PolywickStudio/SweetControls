{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCButtonSet;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Extctrls, ImgList, StdActns, ActnList, Menus, SCCommon, SCConsts, SCControl,
  SCBitmap;

type
  TSCButtonSet = class;
  TSCButtonSetButton = class;

  TSCButtonSetActionLink = class(TActionLink)
  protected
    FClient: TSCButtonSetButton;
    procedure AssignClient(AClient: TObject); override;
    function  IsCaptionLinked: Boolean; override;
    function  IsCheckedLinked: Boolean; override;
    function  IsEnabledLinked: Boolean; override;
    function  IsHintLinked: Boolean; override;
    function  IsImageIndexLinked: Boolean; override;
    function  IsShortCutLinked: Boolean; override;
    function  IsVisibleLinked: Boolean; override;
    function  IsOnExecuteLinked: Boolean; override;
    procedure SetCaption(const Value: string); override;
    procedure SetChecked(Value: Boolean); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetHint(const Value: string); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetShortCut(Value: TShortCut); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
  end;

  TSCButtonSetActionLinkClass = class of TSCButtonSetActionLink;

  TSCButtonSetButton = class(TCollectionItem)
  private
    FAlignment: TLeftRight;
    FCancel: Boolean;
    FCaption: string;
    FColor: TColor;
    FData: TObject;
    FDown: Boolean;
    FEnabled: Boolean;
    FImageIndex: TImageIndex;
    FLockChange: Boolean;
    FHint: String;
    FModalResult: TModalResult;
    FParentColor: Boolean;
    FPopupMenu: TPopupMenu;
    FTag: Integer;
    FVisible: Boolean;
    FWidth: Integer;
    FActionLink: TSCButtonSetActionLink;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseUp: TMouseEvent;
    function  GetAction: TBasicAction;
    procedure SetAction(const Value: TBasicAction);
    procedure SetAlignment(Value: TLeftRight);
    procedure SetCaption(const Value: string);
    procedure SetColor(Value: TColor);
    procedure SetDown(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    function  GetFocused: Boolean;
    procedure SetFocused(Value: Boolean);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetParentColor(Value: Boolean);
    procedure SetPopupMenu(Value: TPopupMenu);
    procedure SetVisible(Value: Boolean);
    procedure SetWidth(Value: Integer);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); virtual;
    procedure UpdateFocus;
    procedure DoChanged(IsVisibleChange, AllItems: Boolean);
    function  GetDisplayName: string; override;
    function  IsAutoSized: Boolean;
    function  IsCaptionStored: Boolean;
    function  IsDownStored: Boolean;
    function  IsEnabledStored: Boolean;
    function  IsHintStored: Boolean;
    function  IsImageIndexStored: Boolean;
    function  IsOnClickStored: Boolean;
    function  IsVisibleStored: Boolean;
    procedure DoActionChange(Sender: TObject);
    function  OwnerState: TComponentState;
    function  GetButtonSet: TSCButtonSet;
    function  GetImages: TCustomImageList;
    procedure UpdateButtonSelection; virtual;
    function  GetActionLinkClass: TSCButtonSetActionLinkClass; dynamic;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); dynamic;

    property ActionLink: TSCButtonSetActionLink read FActionLink write FActionLink;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property ButtonSet: TSCButtonSet read GetButtonSet;
    property Data: TObject read FData write FData;
  published
    property Action: TBasicAction read GetAction write SetAction;
    property Alignment: TLeftRight read FAlignment write SetAlignment default taLeftJustify;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Caption: string read FCaption write SetCaption stored IsCaptionStored;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Down: Boolean read FDown write SetDown stored IsDownStored default False;
    property Enabled: Boolean read FEnabled write SetEnabled stored IsEnabledStored default True;
    property Hint: String read FHint write FHint;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex stored IsImageIndexStored default -1;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property ParentColor: Boolean read FParentColor write SetParentColor default True;
    property PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
    property Tag: Integer read FTag write FTag default 0;
    property Visible: Boolean read FVisible write SetVisible stored IsVisibleStored default True;
    property Width: Integer read FWidth write SetWidth default 75;
    property Focused: Boolean read GetFocused write SetFocused stored False default False;
    property OnClick: TNotifyEvent read FOnClick write FOnClick stored IsOnClickStored;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
  end;

  TSCButtonSetButtons = class(TCollection)
  private
    FButtonSet: TSCButtonSet;
    function  GetItem(Index: Integer): TSCButtonSetButton;
    procedure SetItem(Index: Integer; Value: TSCButtonSetButton);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(ButtonSet: TSCButtonSet);
    function Add: TSCButtonSetButton;
    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCButtonSet read FButtonSet;
    {$ENDIF}
    property Items[Index: Integer]: TSCButtonSetButton read GetItem write SetItem; default;
  end;

  TSCButtonChangeEvent = procedure(Sender: TObject; NewButton: Integer;
    var AllowChange: Boolean) of object;
  TSCDrawButtonEvent = procedure(Sender: TObject; AButton: TSCButtonSetButton;
    ACanvas: TCanvas; const ARect: TRect) of object;
  TSCOwnerDrawEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    const ARect: TRect) of object;

  TSCButtonSetPaintStyle = (scbpsDefault, scbpsFlat, scbpsMac, scbpsMacSquare,
    scbpsMacDefault, scbpsMacSpeed, scbpsNew, scbpsOfficeXP, scbpsSpeed, scbpsXP);

  TSCButtonSetStyle = (scbsDefault, scbsChecked, scbsRadio);

  TSCButtonSetState = (scstPressed, scstDown, scstHot);
  TSCButtonSetStates = set of TSCButtonSetState;

  TSCButtonSet = class(TSCCustomControl)
  private
    FAllowAllUp: Boolean;
    FButtonIndex: Integer;
    FButtons: TSCButtonSetButtons;
    FFlatColor: TColor;
    FFocusedStyle: TFontStyles;
    FHideFocusRect: Boolean;
    FHorizontalSpace: Integer;
    FImageIndent: Integer;
    FPaintStyle: TSCButtonSetPaintStyle;
    FResetWidths: Boolean;
    FSeperation: Integer;
    FStyle: TSCButtonSetStyle;
    FUseSystemFont: Boolean;
    FMouseInBtn: Integer;
    FMouseDownBtn: Integer;
    FClickedBtn: Integer;
    FDblClicked: Boolean;
    function  GetActiveButton: TSCButtonSetButton;
    procedure SetAllowAllUp(const Value: Boolean);
    procedure SetButtonIndex(Value: Integer);
    procedure SetButtons(Value: TSCButtonSetButtons);
    procedure SetFlatColor(const Value: TColor);
    procedure SetFocusedStyle(const Value: TFontStyles);
    procedure SetHideFocusRect(const Value : Boolean);
    procedure SetHorizontalSpace(Value: Integer);
    procedure SetImageIndent(Value: Integer);
    procedure SetPaintStyle(const Value: TSCButtonSetPaintStyle);
    procedure SetResetWidths(const Value: Boolean);
    procedure SetSeperation(Value: Integer);
    procedure SetStyle(const Value: TSCButtonSetStyle);
    procedure SetUseSystemFont(const Value: Boolean);

    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CMSysFontChanged(var Message: TMessage); message CM_SYSFONTCHANGED;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;

    procedure UpdateDowns(Index: Integer = -1);

    procedure DoBtnClick(Index: Integer);
    procedure DoBtnDblClick(Index: Integer);
    procedure DoBtnMouseDown(Index: Integer; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DoBtnMouseMove(Index: Integer; Shift: TShiftState; X, Y: Integer);
    procedure DoBtnMouseUp(Index: Integer; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  protected
    procedure Paint; override;
    procedure AdjustSize; override;
    procedure Loaded; override;
    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure AdjustBounds; override;
    procedure SetAutoSize(Value: Boolean); override;
    function  CanGetFocus: Boolean; override;
    function  GetBlendValue: Word; override;
    procedure ImageListChange(Sender: TObject); override;

    procedure StopTracking; override;
    procedure MouseInControlChanged; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    function  DownButtonCount: Integer;
    function  CanDoDown(Index: Integer; DownState: Boolean): Boolean;

    function  GetSeperatorWidth: Integer; virtual;
    function  GetFrameWidth: Integer; virtual;
    function  GetPopupArrowWidth: Integer; virtual;
    function  GetButtonHeight: Integer; virtual;
    function  GetButtonFrameWidth: Integer; virtual;

    function  GetButtonBounds(Index: Integer; AsAutoSized, CheckVisible: Boolean;
      BtnHeight: Integer = -1): TRect; virtual;
    function  GetButtonRect(Index: Integer; BtnHeight: Integer = -1): TRect; virtual;
    procedure UpdateButton(Index: Integer); virtual;
    procedure UpdateButtons; dynamic;
    procedure SyncToSystemFont;

    procedure DoDrawButton(C: TCanvas; R: TRect; Index: Integer;
      DrawFrame: Boolean = False);
    procedure DoDrawOfficeXP(ACanvas: TCanvas; R: TRect; Index: Integer); virtual;
    procedure DoDrawDefault(ACanvas: TCanvas; R: TRect; Index: Integer); virtual;
    procedure DoDrawMac(ACanvas: TCanvas; R: TRect; Index: Integer); virtual;
    procedure DoDrawSpeed(ACanvas: TCanvas; R: TRect; Index: Integer); virtual;
    procedure DoDrawNew(ACanvas: TCanvas; R: TRect; Index: Integer); virtual;
    procedure DoDrawXP(ACanvas: TCanvas; R: TRect; Index: Integer); virtual;

    procedure DoDrawButtons(ACanvas: TCanvas; X, Y: Integer);
    procedure DoDrawArrow(ACanvas: TCanvas; X, Y: Integer; AColor: TColor); virtual;
    procedure DoDrawSeperator(ACanvas: TCanvas; R: TRect); virtual;
    procedure DoDrawFrame(ACanvas: TCanvas; R: TRect); virtual;

    property ButtonFrameWidth: Integer read GetButtonFrameWidth;
    property ButtonHeight: Integer read GetButtonHeight;
    property FrameWidth: Integer read GetFrameWidth;
    property PopupArrowWidth: Integer read GetPopupArrowWidth;
    property SeperatorWidth: Integer read GetSeperatorWidth;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  GetButtonAtPos(P: TPoint): Integer;
    function  ButtonRect(Index: Integer): TRect;
    function  ClientToButton(P: TPoint): TPoint;
    function  ButtonRectangle: TRect;
    function  VisibleCount: Integer;
    function  IsValidButton(Index: Integer): Boolean;
    procedure DoResetWidths;

    property ActiveButton: TSCButtonSetButton read GetActiveButton;
  published
    property Style: TSCButtonSetStyle read FStyle write SetStyle default scbsDefault;
    property Align default alNone;
    property AllowAllUp: Boolean read FAllowAllUp write SetAllowAllUp default False;
    property Anchors;
    property AutoSize;
    property BlendColor default False;
    property ButtonIndex: Integer read FButtonIndex write SetButtonIndex default -1;
    property Buttons: TSCButtonSetButtons read FButtons write SetButtons;
    property Color default clBtnFace;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatColor: TColor read FFlatColor write SetFlatColor default clBtnShadow;
    property FocusedStyle: TFontStyles read FFocusedStyle write SetFocusedStyle default [fsBold];
    property Font;
    property HideFocusRect: Boolean read FHideFocusRect write SetHideFocusRect default False;
    property Hint;
    property HorizontalSpace: Integer read FHorizontalSpace write SetHorizontalSpace default 0;
    property ImageIndent: Integer read FImageIndent write SetImageIndent default 2;
    property Images;
    property Indent;
    property PaintStyle: TSCButtonSetPaintStyle read FPaintStyle write SetPaintStyle default scbpsNew;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ResetWidths: Boolean read FResetWidths write SetResetWidths stored False default False;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Tag;
    property Seperation: Integer read FSeperation write SetSeperation default 0;
    property UseSystemFont: Boolean read FUseSystemFont write SetUseSystemFont default False;
    property OnClick;
    property OnCanResize;
    property OnConstrainedResize;
    property OnContextPopup;
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

{ TSCButtonSetButton }

procedure TSCButtonSetButton.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  if Action is TCustomAction then
    try
      if Collection <> nil then Collection.BeginUpdate;

      with TCustomAction(Sender) do
      begin
        if not CheckDefaults or (Self.Caption = '') then
          Self.Caption := Caption;

        if not CheckDefaults or (Self.Enabled = True) then
          Self.Enabled := Enabled;

        if not CheckDefaults or (Self.ImageIndex = -1) then
          Self.ImageIndex := ImageIndex;

        if not CheckDefaults or (Self.Visible = True) then
          Self.Visible := Visible;

        if not CheckDefaults or not Assigned(Self.OnClick) then
          Self.OnClick := OnExecute;
      end;
    finally
      if Collection <> nil then Collection.EndUpdate;
    end;
end;

procedure TSCButtonSetButton.Assign(Source: TPersistent);
begin
  if Source is TSCButtonSetButton then
  begin
    FLockChange := True;
    Collection.BeginUpdate;
    try
      with TSCButtonSetButton(Source) do
      begin
        Self.Action := Action;
        Self.Alignment := Alignment;
        Self.Cancel := Cancel;
        Self.Caption := Caption;
        Self.Color := Color;
        Self.Down := Down;
        Self.Enabled := Enabled;
        Self.Hint := Hint;
        Self.ImageIndex := ImageIndex;
        Self.ModalResult := ModalResult;
        Self.ParentColor := ParentColor;
        Self.PopupMenu := PopupMenu;
        Self.Visible := Visible;
        Self.Width := Width;
        Self.Tag := Tag;
        Self.Focused := Focused;
      end;
    finally
      FLockChange := False;
      Collection.EndUpdate;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCButtonSetButton.Create(Collection: TCollection);
begin
  FWidth := 75;
  FImageIndex := -1;
  inherited Create(Collection);

  FColor := clBtnFace;
  FEnabled := True;
  FParentColor := True;
  FTag := 0;
  FVisible := True;
end;

destructor TSCButtonSetButton.Destroy;
begin
  FreeAndNil(FActionLink);
  inherited Destroy;
end;

procedure TSCButtonSetButton.DoActionChange(Sender: TObject);
begin
  if Sender = Action then ActionChange(Sender, False);
end;

function TSCButtonSetButton.GetAction: TBasicAction;
begin
  if FActionLink <> nil then
    Result := FActionLink.Action else
    Result := nil;
end;

function TSCButtonSetButton.GetActionLinkClass: TSCButtonSetActionLinkClass;
begin
  Result := TSCButtonSetActionLink;
end;

function TSCButtonSetButton.GetDisplayName: string;
begin
  Result := Caption;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

function TSCButtonSetButton.GetImages: TCustomImageList;
var
  AButtonSet: TSCButtonSet;
begin
  Result := nil;
  
  AButtonSet := ButtonSet;
  if AButtonSet <> nil then
    Result := AButtonSet.Images;
end;

function TSCButtonSetButton.IsAutoSized: Boolean;
begin
  Result := TSCButtonSetButtons(Collection).FButtonSet.AutoSize;
end;

function TSCButtonSetButton.IsCaptionStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsCaptionLinked;
end;

function TSCButtonSetButton.IsEnabledStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsEnabledLinked;
end;

function TSCButtonSetButton.IsHintStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsHintLinked;
end;

function TSCButtonSetButton.IsImageIndexStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsImageIndexLinked;
end;

function TSCButtonSetButton.IsOnClickStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsOnExecuteLinked;
end;

function TSCButtonSetButton.IsVisibleStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsVisibleLinked;
end;

function TSCButtonSetButton.OwnerState: TComponentState;
begin
  Result := [];
  if TSCButtonSetButtons(Collection).FButtonSet <> nil then
    Result := TSCButtonSetButtons(Collection).FButtonSet.ComponentState;
end;

procedure TSCButtonSetButton.SetAction(const Value: TBasicAction);
begin
  if Value = nil then
    FreeAndNil(FActionLink)
  else begin
    if FActionLink = nil then
      FActionLink := GetActionLinkClass.Create(Self);
    FActionLink.Action := Value;
    FActionLink.OnChange := DoActionChange;
    ActionChange(Value, csLoading in Value.ComponentState);
  end;
end;

procedure TSCButtonSetButton.SetAlignment(Value: TLeftRight);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    DoChanged(False, False);
  end;
end;

procedure TSCButtonSetButton.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    UpdateFocus;
    DoChanged(False, False);
  end;
end;

procedure TSCButtonSetButton.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    DoChanged(False, IsAutoSized);
  end;
end;

procedure TSCButtonSetButton.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    DoChanged(False, IsAutoSized);
  end;
end;

procedure TSCButtonSetButton.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    UpdateFocus;
    DoChanged(True, True);
  end;
end;

procedure TSCButtonSetButton.SetWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FWidth <> Value then
  begin
    FWidth := Value;
    DoChanged(False, True);
  end;
end;

procedure TSCButtonSetButton.UpdateButtonSelection;
var
  I: Integer;
begin
  for I := 0 to Collection.Count-1 do
    if Collection.Items[I] <> Self then
      TSCButtonSetButton(Collection.Items[I]).Focused := False;
end;

procedure TSCButtonSetButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (FPopupMenu <> nil) and
    (AComponent = FPopupMenu) then
    PopupMenu := nil;
end;

procedure TSCButtonSetButton.DoChanged(IsVisibleChange, AllItems: Boolean);
begin
  if not FLockChange and (IsVisibleChange or Visible) then
    Changed(IsVisibleChange or AllItems);
end;

procedure TSCButtonSetButton.SetFocused(Value: Boolean);
var
  Indx: Integer;
  IsFocused: Boolean;
  AButtonSet: TSCButtonSet;
begin
  Value := FEnabled and FVisible and Value;

  AButtonSet := ButtonSet;
  if AButtonSet = nil then Exit;

  IsFocused := AButtonSet.ButtonIndex = Self.Index;
  if IsFocused <> Value then
  begin
    Indx := -1;
    if not IsFocused then Indx := Self.Index;

    AButtonSet.ButtonIndex := Indx;
    DoChanged(False, True);
  end;
end;

function TSCButtonSetButton.GetFocused: Boolean;
var
  AButtonSet: TSCButtonSet;
begin
  AButtonSet := ButtonSet;
  Result := (AButtonSet <> nil) and (AButtonSet.ButtonIndex = Self.Index);
end;

function TSCButtonSetButton.GetButtonSet: TSCButtonSet;
begin
  Result := nil;
  if (Collection <> nil) and (Collection is TSCButtonSetButtons) then
    Result := TSCButtonSetButtons(Collection).FButtonSet;
end;

procedure TSCButtonSetButton.UpdateFocus;
begin
  Focused := FEnabled and FVisible and Focused;
end;

procedure TSCButtonSetButton.SetDown(Value: Boolean);
var
  AButtonSet: TSCButtonSet;
begin
  if FDown <> Value then
  begin
    AButtonSet := GetButtonSet;
    if (AButtonSet <> nil) and
      not AButtonSet.CanDoDown(Self.Index, Value) then Exit;

    FDown := Value;
    if FDown and (AButtonSet <> nil) then
      AButtonSet.UpdateDowns(Self.Index);

    DoChanged(False, False);
  end;
end;

function TSCButtonSetButton.IsDownStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsCheckedLinked;
end;

procedure TSCButtonSetButton.SetPopupMenu(Value: TPopupMenu);
var
  AButtonSet: TSCButtonSet;
begin
  if FPopupMenu <> Value then
  begin
    FPopupMenu := Value;

    AButtonSet := ButtonSet;
    if AButtonSet = nil then Exit;

    DoChanged(False, AButtonSet.AutoSize);
  end;
end;

procedure TSCButtonSetButton.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    if not (csLoading in OwnerState) then
      FParentColor := False;

    if not FParentColor then
      DoChanged(False, False);
  end;
end;

procedure TSCButtonSetButton.SetParentColor(Value: Boolean);
var
  AButtonSet: TSCButtonSet;
begin
  if FParentColor <> Value then
  begin
    FParentColor := Value;

    if FParentColor then
    begin
      AButtonSet := GetButtonSet;
      if AButtonSet <> nil then
        FColor := AButtonSet.Color;
    end;

    DoChanged(False, False);
  end;
end;

{ TSCButtonSetButtons }

function TSCButtonSetButtons.Add: TSCButtonSetButton;
begin
  Result := TSCButtonSetButton(inherited Add);
end;

constructor TSCButtonSetButtons.Create(ButtonSet: TSCButtonSet);
begin
  inherited Create(TSCButtonSetButton);
  FButtonSet := ButtonSet;
end;

function TSCButtonSetButtons.GetItem(Index: Integer): TSCButtonSetButton;
begin
  Result := TSCButtonSetButton(inherited GetItem(Index));
end;

function TSCButtonSetButtons.GetOwner: TPersistent;
begin
  Result := FButtonSet;
end;

procedure TSCButtonSetButtons.SetItem(Index: Integer; Value: TSCButtonSetButton);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCButtonSetButtons.Update(Item: TCollectionItem);
begin
  if Item <> nil then
    FButtonSet.UpdateButton(Item.Index) else
    FButtonSet.UpdateButtons;
end;

{ TSCButtonSet }

procedure TSCButtonSet.AdjustSize;
var
  W, H: Integer;
begin
  if not CanGetClientRect then Exit;

  W := Width; H := Height;
  if AutoSize then inherited AdjustSize;
  if (W = Width) and (H = Height) then Invalidate;
end;

function TSCButtonSet.ButtonRectangle: TRect;
var
  I, BtnHeight,
  FrmWidth, SepWidth: Integer;
  AButton: TSCButtonSetButton;
  R: TRect;
begin
  FrmWidth := FrameWidth;
  if FrmWidth < 0 then FrmWidth := 0;

  Result := Rect(0, 0, 2*FrmWidth, 2*FrmWidth);

  if (FButtons <> nil) and
    (FButtons.Count > 0) and CanGetClientRect then
  begin
    Result := Rect(0, 0, 0, 0);

    SepWidth := SeperatorWidth;
    if SepWidth < 0 then SepWidth := 0;

    BtnHeight := GetButtonHeight;

    for I := 0 to FButtons.Count-1 do
    begin
      AButton := FButtons[I];
      if not AButton.Visible then Continue;

      R := GetButtonBounds(I, AutoSize, True, BtnHeight);
      OffsetRect(R, -R.Left, -R.Top);

      Inc(Result.Right, R.Right + SepWidth);
    end;

    Dec(Result.Right, SepWidth);
    
    Result.Bottom := Result.Top + BtnHeight;
    if FrmWidth > 0 then
      InflateRect(Result, FrmWidth, FrmWidth);
    OffsetRect(Result, -Result.Left, -Result.Top);
  end;
end;

function TSCButtonSet.CanAutoSize(var NewWidth,
  NewHeight: Integer): Boolean;
var
  R: TRect;
begin
  Result := True;
  if (FButtons <> nil) and (FButtons.Count > 0) then
  begin
    R := ButtonRectangle;
    OffsetRect(R, -R.Left, -R.Top);

    if R.Right < 0 then R.Right := 0;
    if R.Bottom < 0 then R.Bottom := 0;

    if Align in [alNone, alLeft, alRight] then
      NewWidth := R.Right;
    if Align in [alNone, alTop, alBottom] then
      NewHeight := R.Bottom;
  end;
end;

constructor TSCButtonSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  SetBounds(Left, Top, 75, 25);
  BlendColor := False;
  Color := clBtnFace;
  ParentColor := False;
  TabStop := True;

  FMouseInBtn := -1;
  FMouseDownBtn := -1;
  FDblClicked := False;

  FAllowAllUp := False;
  FButtons := TSCButtonSetButtons.Create(Self);
  FButtonIndex := -1;
  FFlatColor := clBtnShadow;
  FFocusedStyle := [fsBold];
  FHorizontalSpace := 0;
  FImageIndent := 2;
  FPaintStyle := scbpsNew;
  FSeperation := 0;
  FStyle := scbsDefault;
  FUseSystemFont := False;
end;

destructor TSCButtonSet.Destroy;
begin
  FreeAndNil(FButtons);
  inherited Destroy;
end;

procedure TSCButtonSet.DoDrawButton(C: TCanvas; R: TRect;
  Index: Integer; DrawFrame: Boolean);
var
  // BtnRgn: HRGN;
  SR: Integer;
  FR, CR: TRect;
begin
  if (C = nil) or not CanGetClientRect or IsRectEmpty(R) then
    Exit;

  // BtnRgn := CreateRectRgnIndirect(R);
  // SelectClipRgn(C.Handle, BtnRgn);

  SR := IntersectClipRect(C.Handle, R.Left, R.Top, R.Right, R.Bottom);
  try
    if SR = NULLREGION then
      Exit;

    case FPaintStyle of
      scbpsXP:
        DoDrawXP(C, R, Index);
      scbpsDefault:
        DoDrawDefault(C, R, Index);
      scbpsMac, scbpsMacSquare:
        DoDrawMac(C, R, Index);
      scbpsSpeed, scbpsFlat,
      scbpsMacDefault, scbpsMacSpeed:
        DoDrawSpeed(C, R, Index);
      scbpsOfficeXP:
        DoDrawOfficeXP(C, R, Index);
      scbpsNew:
        DoDrawNew(C, R, Index);
    end;
  finally
    // DeleteObject(BtnRgn);
    SelectClipRgn(C.Handle, 0);
  end;

  if DrawFrame then
  begin
    CR := ClientRect;
    FR := ButtonRectangle;
    IntersectRect(FR, FR, CR);

    FR.Top := CR.Top;
    FR.Bottom := CR.Bottom;
    if not IsRectEmpty(FR) then
      DoDrawFrame(C, FR);
  end;
end;

procedure TSCButtonSet.DoDrawButtons(ACanvas: TCanvas; X, Y: Integer);
var
  I, BtnHeight,
  SepWidth, FrmWidth: Integer;
  LimitExited: Boolean;
  CR, BtnR, R: TRect;
  AButton: TSCButtonSetButton;
begin
  if (ACanvas = nil) or not CanGetClientRect then Exit;

  CR := ClientRect;
  if IsRectEmpty(CR) then Exit;

  FrmWidth := FrameWidth;
  if FrmWidth < 0 then FrmWidth := 0;

  InflateRect(CR, -FrmWidth, -FrmWidth);
  try
    if IsRectEmpty(CR) then Exit;
    OffsetRect(CR, X, Y);

    R := CR;

    BtnHeight := GetButtonHeight;
    if BtnHeight < 0 then BtnHeight := 0;

    R.Bottom := R.Top;
    Inc(R.Bottom, BtnHeight);

    SepWidth := SeperatorWidth;
    if SepWidth < 0 then SepWidth := 0;

    R.Right := R.Left;

    LimitExited := False;
    for I := 0 to FButtons.Count-1 do
    begin
      if LimitExited then Exit;

      AButton := FButtons[I];
      if not AButton.Visible then Continue;

      BtnR := GetButtonBounds(I, AutoSize, True);

      OffsetRect(BtnR, -BtnR.Left, 0);
      Inc(R.Right, BtnR.Right);

      LimitExited := R.Right >= CR.Right;
      if LimitExited then
      begin
        R.Right := CR.Right;
        if IsRectEmpty(R) then Exit;
      end;

      if not IsRectEmpty(R) then
      begin
        DoDrawButton(ACanvas, R, I);
        R.Left := R.Right;

        if (SepWidth > 0) and (I < FButtons.Count-1) then
        begin
          Inc(R.Right, SepWidth);
          DoDrawSeperator(ACanvas, R);
          R.Left := R.Right;
        end;
      end;
    end;
  finally
    InflateRect(CR, FrmWidth, FrmWidth);

    R := ButtonRectangle;
    IntersectRect(R, R, CR);

    R.Top := CR.Top;
    R.Bottom := CR.Bottom;
    if not IsRectEmpty(R) then DoDrawFrame(ACanvas, R);
  end;
end;

procedure TSCButtonSet.DoDrawFrame(ACanvas: TCanvas; R: TRect);
var
  CR: TRect;
  BtnFaceLight, BtnShadowDark,
  BtnFaceExLight, HighlightLight,
  HighlightExLight: TColor;
begin
  if (ACanvas = nil) or IsRectEmpty(R) then Exit;

  if FrameWidth <= 0 then Exit;

  case FPaintStyle of
    scbpsNew:
    begin
      CR := R;
      scFillCorners(ACanvas, CR, Self.Color, 8);

      BtnFaceLight := BlendedColor(clBtnFace, 32, 32, 32, True);
      BtnShadowDark := BlendedColor(clBtnShadow, 32, 32, 32, False);

      CR := R;
      InflateRect(CR, -2, -2);
      scFrame3D(ACanvas, CR, BtnFaceLight, BtnFaceLight, 1, 2);

      Inc(R.Left, 2);
      if R.Left > R.Right then R.Left := R.Right;

      Inc(R.Top, 2);
      if R.Top > R.Bottom then R.Top := R.Bottom;

      CR := R;
      scFrame3D(ACanvas, CR, BtnFaceLight, BtnFaceLight, 1, 4);

      OffsetRect(R, -1, -1);

      CR := R;
      scFrame3D(ACanvas, CR, clBtnHighlight, clBtnHighlight, 1, 4);

      OffsetRect(R, -1, -1);

      CR := R;
      scFrame3D(ACanvas, CR, BtnShadowDark, BtnShadowDark, 1, 4);
    end;
    scbpsXP:
    begin
      CR := R;
      scFillCorners(ACanvas, CR, Self.Color, 6);

      BtnFaceLight := BlendedColor(clBtnFace, 24, 24, 24, True);
      BtnFaceExLight := BlendedColor(clBtnFace, 32, 32, 32, True);

      CR := R;
      scFrame3D(ACanvas, CR, BtnFaceLight, BtnFaceExLight, 1, 4);

      HighlightLight := BlendedColor(clHighlight, 12, 12, 12, True);
      HighlightExLight := BlendedColor(clHighlight, 80, 80, 80, True);

      CR := R;
      InflateRect(CR, -1, -1);
      scFrame3D(ACanvas, CR, HighlightExLight, HighlightExLight, 1, 2);

      CR := R;
      InflateRect(CR, -1, -1);
      scFrame3D(ACanvas, CR, HighlightLight, HighlightLight, 1, 4);

      BtnFaceLight := BlendedColor(clBtnFace, 8, 8, 8, True);
      BtnFaceExLight := BlendedColor(clBtnFace, 64, 64, 64, True);

      CR := R;
      InflateRect(CR, -2, -2);
      scFrame3D(ACanvas, CR, BtnFaceExLight, BtnFaceLight, 1, 2);
    end;
  end;
end;

procedure TSCButtonSet.DoDrawSeperator(ACanvas: TCanvas; R: TRect);
var
  BtnFaceLight, HighlightLight,
  TriDShadowLight: TColor;
begin
  if (ACanvas = nil) or IsRectEmpty(R) then Exit;

  case FPaintStyle of
    scbpsNew:
    begin
      BtnFaceLight := BlendedColor(clBtnFace, 32, 32, 32, True);
      TriDShadowLight := BlendedColor(cl3DDkShadow, 32, 32, 32, True);

      with ACanvas do
      begin
        Pen.Style := psSolid;

        Pen.Color := TriDShadowLight;
        MoveTo(R.Left, R.Top);
        LineTo(R.Left, R.Bottom);

        Pen.Color := clBtnHighlight;
        MoveTo(R.Left + 1, R.Top);
        LineTo(R.Left + 1, R.Bottom);

        Pen.Color := BtnFaceLight;
        MoveTo(R.Left + 2, R.Top);
        LineTo(R.Left + 2, R.Bottom);
      end;
    end;
    scbpsXP:
    begin
      BtnFaceLight := BlendedColor(clBtnFace, 64, 64, 64, True);
      HighlightLight := BlendedColor(clHighlight, 12, 12, 12, True);

      with ACanvas do
      begin
        Pen.Style := psSolid;

        Pen.Color := HighlightLight;
        MoveTo(R.Left, R.Top);
        LineTo(R.Left, R.Bottom);

        Pen.Color := BtnFaceLight;
        MoveTo(R.Left + 1, R.Top);
        LineTo(R.Left + 1, R.Bottom);
      end;
    end;
  end;
end;

function TSCButtonSet.GetActiveButton: TSCButtonSetButton;
begin
  Result := nil;
  if (FButtons <> nil) and (FButtonIndex > -1) and
    (FButtonIndex < FButtons.Count) then Result := FButtons[FButtonIndex];
end;

function TSCButtonSet.GetButtonBounds(Index: Integer; AsAutoSized,
  CheckVisible: Boolean; BtnHeight: Integer): TRect;
var
  R: TRect;
  Text: String;
  PopArrowW, ImageWidth, BtnFrmWidth: Integer;
  ImgValid: Boolean;
  AButton: TSCButtonSetButton;
begin
  Result := Rect(0, 0, 0, 0);

  if CanGetClientRect and (Canvas <> nil) and
    (Index > -1) and (Index < FButtons.Count) then
  begin
    AButton := FButtons[Index];
    if CheckVisible and not AButton.Visible then Exit;

    if BtnHeight < 0 then BtnHeight := GetButtonHeight;
    Inc(Result.Bottom, BtnHeight);

    if not AsAutoSized then
    begin
      Inc(Result.Right, AButton.Width);
      Exit;
    end;

    BtnFrmWidth := ButtonFrameWidth;
    if BtnFrmWidth > 0 then Inc(Result.Right, 2*BtnFrmWidth);

    ImageWidth := 0;
    ImgValid := IsValidImage(AButton.ImageIndex);
    if ImgValid then ImageWidth := (Images.Width + 2) + 2*ImageIndent;
    if ImageWidth < 4 then ImageWidth := 4;

    Inc(Result.Right, ImageWidth);

    if AButton.Caption <> '' then
    begin
      Canvas.Font := Self.Font;

      if not ImgValid then Inc(Result.Right, 2);
      Inc(Result.Right, Indent);


      R := Rect(0, 0, 0, 0);
      Text := AButton.Caption;
      DrawText(Canvas.Handle, PChar(Text), Length(Text), R, DT_CALCRECT or
        DT_SINGLELINE or DT_VCENTER or DT_LEFT);

      Inc(Result.Right, (R.Right - R.Left) + 4);
    end;

    if AButton.PopupMenu <> nil then
    begin
      PopArrowW := PopupArrowWidth;
      if PopArrowW < 0 then PopArrowW := 0;
      Inc(Result.Right, PopArrowW);
    end;

    if FHorizontalSpace > 0 then InflateRect(Result, FHorizontalSpace, 0);

    OffsetRect(Result, -Result.Left, -Result.Top);
  end;
end;

function TSCButtonSet.GetButtonFrameWidth: Integer;
begin
  Result := 2;
  case FPaintStyle of
    scbpsDefault,
    scbpsMac, scbpsMacSquare:
      Result := 3;
    scbpsNew, scbpsXP:
      Result := 0;
  end;
end;

function TSCButtonSet.GetButtonHeight: Integer;
var
  FrmWidth, TxHeight,
  BtnFrmWidth: Integer;
begin
  Result := 0;
  if CanGetClientRect and (Canvas <> nil) then
  begin
    if not AutoSize then
    begin
      Result := ClientHeight;

      FrmWidth := FrameWidth;
      if FrmWidth > 0 then Dec(Result, 2*FrmWidth);
    end else
    begin
      if Images <> nil then Result := Images.Height + 2;

      TxHeight := Canvas.TextHeight('O');
      if Result < TxHeight then Result := TxHeight;

      BtnFrmWidth := ButtonFrameWidth;
      if BtnFrmWidth > 0 then Inc(Result, 2*BtnFrmWidth);

      Inc(Result, 2);
      if FPaintStyle in [scbpsMac, scbpsMacSquare] then Inc(Result, 4);
    end;

    if Result < 0 then Result := 0;
  end;
end;

function TSCButtonSet.GetButtonRect(Index: Integer; BtnHeight: Integer): TRect;
var
  I, FrmWidth, SepWidth: Integer;
  R: TRect;
begin
  Result := Rect(0, 0, 0, 0);

  if CanGetClientRect and (Canvas <> nil) and
    (Index > -1) and (Index < FButtons.Count) and FButtons[Index].Visible then
  begin
    SepWidth := SeperatorWidth;
    if SepWidth < 0 then SepWidth := 0;

    if BtnHeight < 0 then BtnHeight := GetButtonHeight;

    Result := GetButtonBounds(Index, AutoSize, True, BtnHeight);
    OffsetRect(Result, -Result.Left, -Result.Top);

    for I := 0 to Index-1 do
    begin
      R := GetButtonBounds(I, AutoSize, True, BtnHeight);
      OffsetRect(R, -R.Left, -R.Top);

      OffsetRect(Result, R.Right + SepWidth, 0);
    end;

    FrmWidth := FrameWidth;
    if FrmWidth > 0 then OffsetRect(Result, FrmWidth, FrmWidth);
  end;
end;

function TSCButtonSet.GetFrameWidth: Integer;
begin
  Result := 0;
  case FPaintStyle of
    scbpsNew:
      Result := 3;
    scbpsXP:
      Result := 3;
  end;
end;

function TSCButtonSet.GetPopupArrowWidth: Integer;
begin
  Result := 7;
end;

function TSCButtonSet.GetSeperatorWidth: Integer;
begin
  Result := FSeperation;
  case FPaintStyle of
    scbpsNew: Result := 3;
    scbpsXP: Result := 2;
  end;
end;

procedure TSCButtonSet.Loaded;
begin
  inherited Loaded;
  if AutoSize then AdjustSize;
end;

procedure TSCButtonSet.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent <> nil) and
    (AComponent is TPopupMenu) and (FButtons <> nil) then
      for I := 0 to FButtons.Count-1 do
        FButtons[I].Notification(AComponent, Operation);
end;

procedure TSCButtonSet.Paint;
var
  R: TRect;
  ABitmap: TSCBitmap;
begin
  if not HandleAllocated then Exit;

  ABitmap := nil;
  try
    ABitmap := TSCBitmap.Create;

    R := ClientRect;
    OffsetRect(R, -R.Left, -R.Top);

    with ABitmap, ABitmap.Canvas do
    begin
      SetBounds(R.Right, R.Bottom);

      Brush.Style := bsSolid;
      Brush.Color := GetFaceColor;

      FillRect(R);
    end;

    DoDrawButtons(ABitmap.Canvas, 0, 0);
    Canvas.Draw(0, 0, ABitmap);
  finally
    if ABitmap <> nil then
      ABitmap.Free;
  end;
end;

procedure TSCButtonSet.SetButtonIndex(Value: Integer);
var
  I, Start: Integer;
begin
  if IsLoading then
  begin
    FButtonIndex := Value;
    Exit;
  end;

  if (Value < 0) or (FButtons.Count = 0) then
    Value := -1
  else if Value > FButtons.Count-1 then
    Value := 0;

  if Value > -1 then
  begin
    Start := Value;
    Value := -1;

    for I := Start to FButtons.Count-1 do
      if FButtons[I].Enabled and FButtons[I].Visible then
      begin
        Value := I;
        Break;
      end;

    if (Value = -1) and (Start > 0) then
      for I := 0 to Start-1 do
        if FButtons[I].Enabled and FButtons[I].Visible then
        begin
          Value := I;
          Break;
        end;
  end;

  if FButtonIndex <> Value then
  begin
    FButtonIndex := Value;
    Invalidate;
  end;
end;

procedure TSCButtonSet.SetButtons(Value: TSCButtonSetButtons);
begin
  FButtons.Assign(Value);
end;

procedure TSCButtonSet.SetFocusedStyle(const Value: TFontStyles);
begin
  if FFocusedStyle <> Value then
  begin
    FFocusedStyle := Value;
    if IsValidButton(0) then Invalidate;
  end;
end;

procedure TSCButtonSet.SetImageIndent(Value: Integer);
begin
  if Value < 0 then Value := 0
  else if Value > 20 then Value := 20;

  if FImageIndent <> Value then
  begin
    FImageIndent := Value;
    AdjustSize;
  end;
end;

procedure TSCButtonSet.SetPaintStyle(const Value: TSCButtonSetPaintStyle);
begin
  if FPaintStyle <> Value then
  begin
    FPaintStyle := Value;
    AdjustSize;
    if IsValidButton(0) then Invalidate;
  end;
end;

procedure TSCButtonSet.UpdateButton(Index: Integer);
begin
  Invalidate;
end;

procedure TSCButtonSet.UpdateButtons;
begin
  AdjustSize;
end;

function TSCButtonSet.VisibleCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  if FButtons = nil then Exit;

  for I := 0 to FButtons.Count-1 do
    if FButtons[I].Enabled and
      FButtons[I].Visible then Inc(Result);
end;

function TSCButtonSet.GetBlendValue: Word;
begin
  Result := 0;
  if BlendColor then Result := 10;
end;

procedure TSCButtonSet.SetStyle(const Value: TSCButtonSetStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;

    // Update down buttons
    if FStyle = scbsDefault then
      UpdateDowns(-1)
    else if FStyle = scbsRadio then
      UpdateDowns(-2);

    if IsValidButton(0) then Invalidate;
  end;
end;

procedure TSCButtonSet.UpdateDowns(Index: Integer);
var
  First, I: Integer;
begin
  if (FButtons <> nil) and (FButtons.Count > 0) then
  begin
    if Index < -1 then Index := -2
    else if Index > FButtons.Count-1 then
      Index := FButtons.Count-1;

    First := Index;
    if (First = -1) and not FAllowAllUp then Exit;

    for I := 0 to FButtons.Count-1 do
    begin
      case FStyle of
        scbsDefault:
          FButtons[I].FDown := False;
        scbsRadio:
        begin
          if (First = -2) and FButtons[I].Down then
            First := I;
          FButtons[I].FDown := I = First;
        end;
        scbsChecked:
        begin
          if (First = -2) and FButtons[I].Down then
            First := I;

          if First = -1 then
            FButtons[I].FDown := False
          else if I = First then
            FButtons[I].FDown := True;
        end;
      end;
    end;
  end;
end;

procedure TSCButtonSet.SetAllowAllUp(const Value: Boolean);
begin
  FAllowAllUp := Value;
end;

function TSCButtonSet.CanDoDown(Index: Integer;
  DownState: Boolean): Boolean;
begin
  Result := (FButtons <> nil) and
    (Index > -1) and (Index < FButtons.Count);
  if not Result then Exit;

  if DownState then
    Result := (FStyle <> scbsDefault)
  else
    Result := AllowAllUp or (DownButtonCount > 1);
end;

function TSCButtonSet.DownButtonCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  if (FButtons <> nil) and (FButtons.Count > 0) then
    for I := 0 to FButtons.Count-1 do
      if FButtons[I].Down then Inc(Result);
end;

procedure TSCButtonSet.SetFlatColor(const Value: TColor);
begin
  if FFlatColor <> Value then
  begin
    FFlatColor := Value;
    if IsValidButton(0) then Invalidate;
  end;
end;

procedure TSCButtonSet.DoDrawOfficeXP(ACanvas: TCanvas; R: TRect;
  Index: Integer);
var
  TxtFormat, ImgMid,
  BtnFrmWidth, DrawOffset, PopArrowW: Integer;
  ImgValid, TxtValid: Boolean;
  BtnAlignment: TLeftRight;
  BtnState, CheckState: TSCButtonSetStates;
  BtnR: TRect;
  Text: String;
  AColor, FntColor: TColor;
  FntStyle: TFontStyles;
  AButton: TSCButtonSetButton;
begin
  if (ACanvas = nil) or (FButtons = nil) or IsRectEmpty(R) or
    (FPaintStyle <> scbpsOfficeXP) or not IsValidButton(Index) then Exit;

  BtnFrmWidth := ButtonFrameWidth;
  if BtnFrmWidth < 0 then BtnFrmWidth := 0;
  InflateRect(R, -BtnFrmWidth, -BtnFrmWidth);

  AButton := FButtons[Index];

  BtnState := [];
  with AButton do
  begin
    if Down then Include(BtnState, scstDown);

    if Enabled and Visible then
    begin
      if FMouseDownBtn = Index then Include(BtnState, scstPressed);
      if (FMouseInBtn = Index) and ((FMouseDownBtn = -1) or
        (FMouseDownBtn = FMouseInBtn)) then Include(BtnState, scstHot);
    end;
  end;

  FntColor := clBtnText;
  AColor := GetOfficeXPBtnColor;

  if scstPressed in BtnState then
  begin
    AColor := GetOfficeXPSelColor;

    if BtnState*[scstDown, scstHot] <> [] then
    begin
      FntColor := clHighlightText;
      AColor := GetOfficeXPDownedSelColor;
    end;
  end else
  begin
    if scstDown in BtnState then
    begin
      AColor := GetOfficeXPDownedColor;

      if scstHot in BtnState then
      begin
        FntColor := clHighlightText;
        AColor := GetOfficeXPDownedSelColor;
      end;
    end else
    if scstHot in BtnState then
      AColor := GetOfficeXPSelColor;
  end;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := AColor;

    BtnR := R;
    InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);
    FillRect(BtnR);
  end;

  BtnR := R;
  if FHorizontalSpace > 0 then InflateRect(BtnR, -FHorizontalSpace, 0);

  BtnAlignment := AButton.Alignment;
  ImgValid := IsValidImage(AButton.ImageIndex);

  TxtValid := True;
  if ImgValid then
  begin
    ImgMid := BtnR.Top + ((BtnR.Bottom - BtnR.Top - Images.Height) div 2);

    DrawOffset := 0;
    CheckState := BtnState*[scstHot, scstPressed];
    if ((CheckState = [scstHot]) or (CheckState = [scstPressed])) then
      DrawOffset := -1;

    if BtnAlignment = taLeftJustify then
    begin
      TxtValid := BtnR.Left + ImageIndent + Images.Width <= BtnR.Right;

      if TxtValid then
      begin
        Inc(BtnR.Left, ImageIndent);
        if DrawOffset = -1 then
        begin
          // Draw grayed image
        end;

        Images.Draw(ACanvas, BtnR.Left + DrawOffset,
          ImgMid + DrawOffset, AButton.ImageIndex, AButton.Enabled);
        Inc(BtnR.Left, 2 + Images.Width + ImageIndent);
      end;
    end else
    begin
      TxtValid := BtnR.Right - (ImageIndent + Images.Width) >= BtnR.Left;

      if TxtValid then
      begin
        Dec(BtnR.Right, ImageIndent + Images.Width);
        if DrawOffset = -1 then
        begin
          // Draw grayed image
        end;

        Images.Draw(ACanvas, BtnR.Right + DrawOffset,
          ImgMid + DrawOffset, AButton.ImageIndex, AButton.Enabled);
        Dec(BtnR.Right, ImageIndent + 2);
      end;
    end;
  end;

  PopArrowW := 0;
  if AButton.PopupMenu <> nil then
  begin
    PopArrowW := PopupArrowWidth;
    if PopArrowW < 0 then PopArrowW := 0;

    if AButton.Alignment = taLeftJustify then
      Dec(BtnR.Right, PopArrowW)
    else Inc(BtnR.Left, PopArrowW);
  end;

  if TxtValid and (AButton.Caption <> '') and
    not IsRectEmpty(BtnR) then
  begin
    TxtFormat := DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS;
    if not ImgValid then
    begin
      TxtFormat := TxtFormat or DT_CENTER;
      InflateRect(BtnR, -2, 0);
    end else
      if BtnAlignment = taLeftJustify then
      begin
        TxtFormat := TxtFormat or DT_LEFT;

        Inc(BtnR.Left, Indent);
        if not ImgValid then Inc(BtnR.Left, 2);
        Dec(BtnR.Right, 4);
      end else
      begin
        TxtFormat := TxtFormat or DT_RIGHT;

        Dec(BtnR.Right, Indent);
        if not ImgValid then Dec(BtnR.Right, 2);
        Inc(BtnR.Left, 4);
      end;

    if not IsRectEmpty(BtnR) then
      with ACanvas do
      begin
        Font := Self.Font;
        Font.Color := FntColor;

        FntStyle := Self.Font.Style;
        if FUseSystemFont and (FPaintStyle = scbpsOfficeXP) then
          FntStyle := []
        else
        if AButton.Focused and AButton.Enabled then
          FntStyle := Self.FocusedStyle;

        Font.Style := FntStyle;

        Brush.Style := bsClear;
        Text := AButton.Caption;

        if AButton.Enabled then
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat)
        else begin
          OffsetRect(BtnR, 1, 1);
          Font.Color := clBtnHighlight;
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat);

          OffsetRect(BtnR, -1, -1);
          Font.Color := clBtnShadow;
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat);
        end;

        Brush.Style := bsSolid;
      end;
  end;

  if PopArrowW > 0 then
  begin
    BtnR := R;
    InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);

    if (BtnR.Bottom - BtnR.Top >= 3) and (BtnR.Right - BtnR.Left >= 5) then
    begin
      DrawOffset := (PopArrowW - 5) div 2;
      if DrawOffset < 4 then DrawOffset := 4;

      if AButton.Alignment = taLeftJustify then
      begin
        Dec(BtnR.Right, DrawOffset);
        BtnR.Left := BtnR.Right - 5;
      end else
      begin
        Inc(BtnR.Left, DrawOffset);
        BtnR.Right := BtnR.Left + 5;
      end;

      IntersectRect(BtnR, BtnR, R);
      if not IsRectEmpty(BtnR) then
      begin
        AColor := clBtnText;
        if not AButton.Enabled then AColor := clGrayText;

        BtnR.Top := BtnR.Top + ((BtnR.Bottom - BtnR.Top - 3) div 2);
        DoDrawArrow(ACanvas, BtnR.Left, BtnR.Top, AColor);
      end;
    end;
  end;

  BtnR := R;
  InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);

  if (BtnState*[scstDown, scstHot, scstPressed] <> []) or
    (Focused and AButton.Focused and not FHideFocusRect) then
    scFrame3D(ACanvas, BtnR, clHighlight, clHighlight, 1, 0);
end;

procedure TSCButtonSet.DoDrawNew(ACanvas: TCanvas; R: TRect;
  Index: Integer);
var
  TxtFormat, ImgMid,
  BtnFrmWidth, DrawOffset,
  PopArrowW: Integer;
  ImgValid, TxtValid: Boolean;
  BtnAlignment: TLeftRight;
  BtnState: TSCButtonSetStates;
  BtnR: TRect;
  Text: String;
  AColor, FntColor,
  BtnFaceLight, BtnFaceDark: TColor;
  FntStyle: TFontStyles;
  AButton: TSCButtonSetButton;
begin
  if (ACanvas = nil) or (FButtons = nil) or IsRectEmpty(R) or
    (FPaintStyle <> scbpsNew) or not IsValidButton(Index) then Exit;

  BtnFrmWidth := ButtonFrameWidth;
  if BtnFrmWidth < 0 then BtnFrmWidth := 0;
  InflateRect(R, -BtnFrmWidth, -BtnFrmWidth);

  AButton := FButtons[Index];

  BtnState := [];
  with AButton do
  begin
    if Down then Include(BtnState, scstDown);

    if Enabled and Visible then
    begin
      if FMouseDownBtn = Index then Include(BtnState, scstPressed);
      if (FMouseInBtn = Index) and ((FMouseDownBtn = -1) or
        (FMouseDownBtn = FMouseInBtn)) then Include(BtnState, scstHot);
    end;
  end;

  FntColor := Self.Font.Color;
  AColor := clBtnFace;

  if (scstDown in BtnState) or
    (BtnState*[scstHot, scstPressed] = [scstHot, scstPressed]) then
  begin
    BtnFaceLight := BlendedColor(clBtnFace, 32, 32, 32, False);
    BtnFaceDark  := BlendedColor(clBtnFace, 24, 24, 24, True);
  end else
  begin
    BtnFaceLight := BlendedColor(clBtnFace, 24, 24, 24, True);
    BtnFaceDark  := BlendedColor(clBtnFace, 32, 32, 32, False);
  end;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := AColor;

    BtnR := R;
    InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);
    FillRect(BtnR);

    BtnR := R;
    BtnR.Bottom := BtnR.Top + ((BtnR.Bottom - BtnR.Top) div 2);
    scDrawGradient(ACanvas, BtnR, scgTopToBottom, BtnFaceLight, clBtnFace);

    BtnR := R;
    BtnR.Top := BtnR.Bottom - ((BtnR.Bottom - BtnR.Top) div 2);
    scDrawGradient(ACanvas, BtnR, scgTopToBottom, clBtnFace, BtnFaceDark);
  end;

  BtnR := R;
  if FHorizontalSpace > 0 then InflateRect(BtnR, -FHorizontalSpace, 0);

  BtnAlignment := AButton.Alignment;
  ImgValid := IsValidImage(AButton.ImageIndex);

  DrawOffset := 0;
  if (scstDown in BtnState) or
    (BtnState*[scstHot, scstPressed]=[scstHot, scstPressed]) then
    DrawOffset := 1;

  TxtValid := True;
  if ImgValid then
  begin
    ImgMid := BtnR.Top + ((BtnR.Bottom - BtnR.Top - Images.Height) div 2);

    if BtnAlignment = taLeftJustify then
    begin
      TxtValid := BtnR.Left + ImageIndent + Images.Width <= BtnR.Right;

      if TxtValid then
      begin
        Inc(BtnR.Left, ImageIndent);
        Images.Draw(ACanvas, BtnR.Left + DrawOffset, ImgMid + DrawOffset,
          AButton.ImageIndex, AButton.Enabled);
        Inc(BtnR.Left, 2 + Images.Width + ImageIndent);
      end;
    end else
    begin
      TxtValid := BtnR.Right - (ImageIndent + Images.Width) >= BtnR.Left;

      if TxtValid then
      begin
        Dec(BtnR.Right, ImageIndent + Images.Width);
        Images.Draw(ACanvas, BtnR.Right + DrawOffset, ImgMid + DrawOffset,
          AButton.ImageIndex, AButton.Enabled);
        Dec(BtnR.Right, ImageIndent + 2);
      end;
    end;
  end;

  PopArrowW := 0;
  if AButton.PopupMenu <> nil then
  begin
    PopArrowW := PopupArrowWidth;
    if PopArrowW < 0 then PopArrowW := 0;

    if AButton.Alignment = taLeftJustify then
      Dec(BtnR.Right, PopArrowW)
    else Inc(BtnR.Left, PopArrowW);
  end;

  if TxtValid and (AButton.Caption <> '') and
    not IsRectEmpty(BtnR) then
  begin
    TxtFormat := DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS;
    if not ImgValid then
    begin
      TxtFormat := TxtFormat or DT_CENTER;
      InflateRect(BtnR, -2, 0);
    end else
      if BtnAlignment = taLeftJustify then
      begin
        TxtFormat := TxtFormat or DT_LEFT;

        Inc(BtnR.Left, Indent);
        if not ImgValid then Inc(BtnR.Left, 2);
        Dec(BtnR.Right, 4);
      end else
      begin
        TxtFormat := TxtFormat or DT_RIGHT;

        Dec(BtnR.Right, Indent);
        if not ImgValid then Dec(BtnR.Right, 2);
        Inc(BtnR.Left, 4);
      end;

    if not IsRectEmpty(BtnR) then
      with ACanvas do
      begin
        Font := Self.Font;
        Font.Color := FntColor;

        FntStyle := Self.Font.Style;
        if FUseSystemFont and (FPaintStyle = scbpsOfficeXP) then
          FntStyle := []
        else
        if AButton.Focused and AButton.Enabled then
          FntStyle := Self.FocusedStyle;

        Font.Style := FntStyle;

        Brush.Style := bsClear;
        Text := AButton.Caption;

        OffsetRect(BtnR, DrawOffset, DrawOffset);
        if AButton.Enabled then
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat)
        else begin
          OffsetRect(BtnR, 1, 1);
          Font.Color := clBtnHighlight;
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat);

          OffsetRect(BtnR, -1, -1);
          Font.Color := clBtnShadow;
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat);
        end;

        Brush.Style := bsSolid;
      end;
  end;

  if PopArrowW > 0 then
  begin
    BtnR := R;
    if FHorizontalSpace > 0 then InflateRect(BtnR, -FHorizontalSpace, 0);

    InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);

    if (BtnR.Bottom - BtnR.Top >= 3) and (BtnR.Right - BtnR.Left >= 5) then
    begin
      DrawOffset := (PopArrowW - 5) div 2;
      if DrawOffset < 4 then DrawOffset := 4;

      if AButton.Alignment = taLeftJustify then
      begin
        Dec(BtnR.Right, DrawOffset);
        BtnR.Left := BtnR.Right - 5;
      end else
      begin
        Inc(BtnR.Left, DrawOffset);
        BtnR.Right := BtnR.Left + 5;
      end;

      IntersectRect(BtnR, BtnR, R);
      if not IsRectEmpty(BtnR) then
      begin
        AColor := clBtnText;
        if not AButton.Enabled then AColor := clGrayText;

        BtnR.Top := BtnR.Top + ((BtnR.Bottom - BtnR.Top - 3) div 2);
        if (scstDown in BtnState) or
          (BtnState*[scstHot, scstPressed]=[scstHot, scstPressed]) then
          OffsetRect(BtnR, 1, 1);

        DoDrawArrow(ACanvas, BtnR.Left, BtnR.Top, AColor);
      end;
    end;
  end;
end;

procedure TSCButtonSet.DoDrawXP(ACanvas: TCanvas; R: TRect;
  Index: Integer);
var
  TxtFormat, ImgMid,
  BtnFrmWidth, DrawOffset,
  PopArrowW: Integer;
  ImgValid, TxtValid: Boolean;
  BtnAlignment: TLeftRight;
  BtnState: TSCButtonSetStates;
  BtnR: TRect;
  Text: String;
  AColor, FntColor,
  BtnFaceLight, BtnFaceDark: TColor;
  FntStyle: TFontStyles;
  AButton: TSCButtonSetButton;
begin
  if (ACanvas = nil) or (FButtons = nil) or IsRectEmpty(R) or
    (FPaintStyle <> scbpsXP) or not IsValidButton(Index) then Exit;

  BtnFrmWidth := ButtonFrameWidth;
  if BtnFrmWidth < 0 then BtnFrmWidth := 0;
  InflateRect(R, -BtnFrmWidth, -BtnFrmWidth);

  AButton := FButtons[Index];

  BtnState := [];
  with AButton do
  begin
    if Down then Include(BtnState, scstDown);

    if Enabled and Visible then
    begin
      if FMouseDownBtn = Index then Include(BtnState, scstPressed);
      if (FMouseInBtn = Index) and ((FMouseDownBtn = -1) or
        (FMouseDownBtn = FMouseInBtn)) then Include(BtnState, scstHot);
    end;
  end;

  FntColor := Self.Font.Color;
  AColor := clBtnFace;

  if (scstDown in BtnState) or
    (BtnState*[scstHot, scstPressed] = [scstHot, scstPressed]) then
  begin
    BtnFaceLight := BlendedColor(clBtnFace, 8, 8, 8, True);
    BtnFaceDark  := BlendedColor(clBtnFace, 64, 64, 64, True);
  end else
  begin
    BtnFaceLight := BlendedColor(clBtnFace, 64, 64, 64, True);
    BtnFaceDark  := BlendedColor(clBtnFace, 8, 8, 8, True);
  end;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := AColor;

    BtnR := R;
    FillRect(BtnR);

    InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);
    scDrawGradient(ACanvas, BtnR, scgTopToBottom, BtnFaceLight, BtnFaceDark);
  end;

  BtnR := R;
  if FHorizontalSpace > 0 then InflateRect(BtnR, -FHorizontalSpace, 0);

  BtnAlignment := AButton.Alignment;
  ImgValid := IsValidImage(AButton.ImageIndex);

  DrawOffset := 0;
  if (scstDown in BtnState) or
    (BtnState*[scstHot, scstPressed]=[scstHot, scstPressed]) then
    DrawOffset := 1;

  TxtValid := True;
  if ImgValid then
  begin
    ImgMid := BtnR.Top + ((BtnR.Bottom - BtnR.Top - Images.Height) div 2);

    if BtnAlignment = taLeftJustify then
    begin
      TxtValid := BtnR.Left + ImageIndent + Images.Width <= BtnR.Right;

      if TxtValid then
      begin
        Inc(BtnR.Left, ImageIndent);
        Images.Draw(ACanvas, BtnR.Left + DrawOffset, ImgMid + DrawOffset,
          AButton.ImageIndex, AButton.Enabled);
        Inc(BtnR.Left, 2 + Images.Width + ImageIndent);
      end;
    end else
    begin
      TxtValid := BtnR.Right - (ImageIndent + Images.Width) >= BtnR.Left;

      if TxtValid then
      begin
        Dec(BtnR.Right, ImageIndent + Images.Width);
        Images.Draw(ACanvas, BtnR.Right + DrawOffset, ImgMid + DrawOffset,
          AButton.ImageIndex, AButton.Enabled);
        Dec(BtnR.Right, ImageIndent + 2);
      end;
    end;
  end;

  PopArrowW := 0;
  if AButton.PopupMenu <> nil then
  begin
    PopArrowW := PopupArrowWidth;
    if PopArrowW < 0 then PopArrowW := 0;

    if AButton.Alignment = taLeftJustify then
      Dec(BtnR.Right, PopArrowW)
    else Inc(BtnR.Left, PopArrowW);
  end;

  if TxtValid and (AButton.Caption <> '') and
    not IsRectEmpty(BtnR) then
  begin
    TxtFormat := DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS;
    if not ImgValid then
    begin
      TxtFormat := TxtFormat or DT_CENTER;
      InflateRect(BtnR, -2, 0);
    end else
      if BtnAlignment = taLeftJustify then
      begin
        TxtFormat := TxtFormat or DT_LEFT;

        Inc(BtnR.Left, Indent);
        if not ImgValid then Inc(BtnR.Left, 2);
        Dec(BtnR.Right, 4);
      end else
      begin
        TxtFormat := TxtFormat or DT_RIGHT;

        Dec(BtnR.Right, Indent);
        if not ImgValid then Dec(BtnR.Right, 2);
        Inc(BtnR.Left, 4);
      end;

    if not IsRectEmpty(BtnR) then
      with ACanvas do
      begin
        Font := Self.Font;
        Font.Color := FntColor;

        FntStyle := Self.Font.Style;
        if FUseSystemFont and (FPaintStyle = scbpsOfficeXP) then
          FntStyle := []
        else
        if AButton.Focused and AButton.Enabled then
          FntStyle := Self.FocusedStyle;

        Font.Style := FntStyle;

        Brush.Style := bsClear;
        Text := AButton.Caption;

        OffsetRect(BtnR, DrawOffset, DrawOffset);
        if AButton.Enabled then
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat)
        else begin
          OffsetRect(BtnR, 1, 1);
          Font.Color := clBtnHighlight;
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat);

          OffsetRect(BtnR, -1, -1);
          Font.Color := clBtnShadow;
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat);
        end;

        Brush.Style := bsSolid;
      end;
  end;

  if PopArrowW > 0 then
  begin
    BtnR := R;
    if FHorizontalSpace > 0 then InflateRect(BtnR, -FHorizontalSpace, 0);

    InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);

    if (BtnR.Bottom - BtnR.Top >= 3) and (BtnR.Right - BtnR.Left >= 5) then
    begin
      DrawOffset := (PopArrowW - 5) div 2;
      if DrawOffset < 4 then DrawOffset := 4;

      if AButton.Alignment = taLeftJustify then
      begin
        Dec(BtnR.Right, DrawOffset);
        BtnR.Left := BtnR.Right - 5;
      end else
      begin
        Inc(BtnR.Left, DrawOffset);
        BtnR.Right := BtnR.Left + 5;
      end;

      IntersectRect(BtnR, BtnR, R);
      if not IsRectEmpty(BtnR) then
      begin
        AColor := clBtnText;
        if not AButton.Enabled then AColor := clGrayText;

        BtnR.Top := BtnR.Top + ((BtnR.Bottom - BtnR.Top - 3) div 2);
        if (scstDown in BtnState) or
          (BtnState*[scstHot, scstPressed]=[scstHot, scstPressed]) then
          OffsetRect(BtnR, 1, 1);

        DoDrawArrow(ACanvas, BtnR.Left, BtnR.Top, AColor);
      end;
    end;
  end;

  BtnR := R;
  InflateRect(BtnR, -1, 0);
  if not FHideFocusRect and Focused and AButton.Focused then
    ACanvas.DrawFocusRect(BtnR);
end;

procedure TSCButtonSet.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ClkBtn, InBtn: Integer;
  R: TRect;
  P: TPoint;
  AButton: TSCButtonSetButton;
begin
  if not HandleAllocated then Exit;

  FMouseDownBtn := -1;
  FMouseInBtn := -1;

  if Button <> mbLeft then
  begin
    inherited MouseDown(Button, Shift, X, Y);
    Exit;
  end;

  ClkBtn := FMouseDownBtn;
  InBtn  := FMouseInBtn;
  try
    FMouseDownBtn := GetButtonAtPos(Point(X, Y));
    FMouseInBtn := FMouseDownBtn;

    FDblClicked := False;

    AButton := nil;
    if IsValidButton(FMouseDownBtn) then
    begin
      AButton := FButtons[FMouseDownBtn];
      if not (AButton.Enabled and AButton.Visible) then
        AButton := nil;
    end;

    if AButton = nil then
    begin
      FDblClicked := False;
      FMouseInBtn := -1;
      FMouseDownBtn := -1;

      if CanGetFocus then SetFocus;
      Exit;
    end;

    if Button = mbLeft then
    begin
      AButton.Focused := True;

      if AButton.PopupMenu <> nil then
      begin
        if FPaintStyle = scbpsOfficeXP then
          FMouseDownBtn := -1;
        FDblClicked := False;
        Invalidate;

        R := GetButtonRect(AButton.Index, -1);
        with AButton.PopupMenu do
        begin
          PopupComponent := Self;
          P := Self.ClientToScreen(Point(R.Left, R.Bottom));

          Popup(P.X, P.Y);
        end;

        if (Self <> nil) and
          HandleAllocated and GetCursorPos(P) then
        begin
          FMouseDownBtn := -1;
          FMouseInBtn := GetButtonAtPos(P);
          Invalidate;
        end;

        Exit;
      end;

      if (ClkBtn = FMouseDownBtn) and (ssDouble in Shift) then
      begin
        FMouseDownBtn := -1;
        FMouseInBtn := -1;
        FDblClicked := True;
        DoBtnDblClick(ClkBtn);
      end;
    end;

    DoBtnMouseDown(FMouseDownBtn, Button, Shift, X, Y);
  finally
    FClickedBtn := -1;
    if (ClkBtn <> FMouseDownBtn) or (InBtn <> FMouseInBtn) then
      Invalidate;

    inherited MouseDown(Button, Shift, X, Y);
  end;
end;

procedure TSCButtonSet.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  InBtn: Integer;
begin
  if not HandleAllocated then Exit;

  InBtn := FMouseInBtn;
  try
    FMouseInBtn := -1;
    if MouseInControl then
      FMouseInBtn := GetButtonAtPos(Point(X, Y));

    if InBtn <> FMouseInBtn then Invalidate;

    DoBtnMouseMove(FMouseInBtn, Shift, X, Y);
  finally
    inherited MouseMove(Shift, X, Y);
  end;  
end;

procedure TSCButtonSet.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  ClkBtn, InBtn: Integer;
  CanPaint: Boolean;
  AButton: TSCButtonSetButton;
begin
  if not HandleAllocated then Exit;

  if Button <> mbLeft then
  begin
    FMouseInBtn := -1;
    FClickedBtn := -1;
    FMouseDownBtn := -1;

    Invalidate;

    inherited MouseUp(Button, Shift, X, Y);
    Exit;
  end;

  InBtn := FMouseInBtn;
  FClickedBtn := FMouseDownBtn;
  FMouseDownBtn := -1;

  CanPaint := FClickedBtn <> FMouseDownBtn;
  try
    ClkBtn := GetButtonAtPos(Point(X, Y));
    FMouseInBtn := ClkBtn;

    AButton := nil;
    if (FClickedBtn = ClkBtn) and IsValidButton(ClkBtn) then
      AButton := FButtons[FClickedBtn];

    if not ((AButton <> nil) and AButton.Enabled and AButton.Visible) then
    begin
      CanPaint := True;
      FDblClicked := False;
      FClickedBtn := -1;

      Exit;
    end;

    CanPaint := CanPaint or (InBtn <> FMouseInBtn);

    AButton.SetDown(not AButton.Down);
    if Button = mbLeft then
    begin
      if not FDblClicked then
        DoBtnClick(ClkBtn)
      else begin
        FMouseDownBtn := -1;
        FDblClicked := False;
      end;
    end;

    DoBtnMouseUp(ClkBtn, Button, Shift, X, Y);
  finally
    if CanPaint then Invalidate;
    inherited MouseUp(Button, Shift, X, Y);
  end;
end;

procedure TSCButtonSet.MouseInControlChanged;
var
  P: TPoint;
  Indx: Integer;
begin
  Indx := FMouseInBtn;
  FMouseInBtn := -1;

  if MouseInControl and GetCursorPos(P) then
  begin
    P := Self.ScreenToClient(P);
    FMouseInBtn := GetButtonAtPos(P);
  end;

  if Indx <> FMouseInBtn then
    Invalidate;
end;

function TSCButtonSet.GetButtonAtPos(P: TPoint): Integer;
var
  CR, R, BtnR: TRect;
  I, BtnHeight,
  FrmWidth, SepWidth: Integer;
  AButton: TSCButtonSetButton;
begin
  Result := -1;
  if not (CanGetClientRect and (FButtons <> nil) and (FButtons.Count > 0)) then
    Exit;

  FrmWidth := FrameWidth;
  if FrmWidth < 0 then FrmWidth := 0;

  CR := ClientRect;
  InflateRect(CR, -FrmWidth, -FrmWidth);

  if not IsRectEmpty(CR) and PtInRect(CR, P) then
  begin
    BtnHeight := GetButtonHeight;
    if BtnHeight <= 0 then Exit;

    SepWidth := SeperatorWidth;
    if SepWidth < 0 then SepWidth := 0;

    BtnR := Rect(FrmWidth, FrmWidth, FrmWidth + 1, BtnHeight + FrmWidth);

    R := BtnR;

    IntersectRect(BtnR, R, CR);
    if IsRectEmpty(BtnR) then Exit;

    if EqualRect(R, BtnR) then Dec(BtnR.Right);

    for I := 0 to FButtons.Count-1 do
    begin
      AButton := FButtons[I];
      if not AButton.Visible then
        Continue;

      R := GetButtonBounds(I, AutoSize, True, BtnHeight);
      OffsetRect(R, -R.Left, 0);

      Inc(BtnR.Right, R.Right);

      R := BtnR;
      IntersectRect(BtnR, BtnR, CR);
      if PtInRect(BtnR, P) then
      begin
        Result := I;
        Exit;
      end;

      if not EqualRect(R, BtnR) then Exit;

      OffsetRect(BtnR, SepWidth, 0);
      BtnR.Left := BtnR.Right;
    end;
  end;
end;

procedure TSCButtonSet.StopTracking;
var
  CanPaint: Boolean;
begin
  if HandleAllocated then
  begin
    CanPaint := MouseIsDown or MouseInControl or
      (FMouseInBtn > -1) or (FMouseDownBtn > -1);

    MouseIsDown   := False;
    FDblClicked   := False;
    FClickedBtn   := -1;
    FMouseInBtn   := -1;
    FMouseDownBtn := -1;

    if CanPaint then Invalidate;
  end;
end;

function TSCButtonSet.IsValidButton(Index: Integer): Boolean;
begin
  Result := (FButtons <> nil) and (Index > -1) and
    (Index < FButtons.Count);
end;

function TSCButtonSet.ClientToButton(P: TPoint): TPoint;
var
  Btn: Integer;
  R: TRect;
begin
  Result := P;

  Btn := GetButtonAtPos(P);
  if IsValidButton(Btn) then
  begin
    R := GetButtonRect(Btn, -1);
    Result.x := P.x - R.Left;
    Result.y := P.y - R.Top;
  end;
end;

procedure TSCButtonSet.DoBtnClick(Index: Integer);
var
  AButton: TSCButtonSetButton;
begin
  if IsValidButton(Index) then
  begin
    AButton := FButtons[Index];
    if AButton.Enabled and AButton.Visible and
      Assigned(AButton.OnClick) then AButton.OnClick(AButton);
  end;
end;

procedure TSCButtonSet.DoBtnDblClick(Index: Integer);
var
  AButton: TSCButtonSetButton;
begin
  if IsValidButton(Index) then
  begin
    AButton := FButtons[Index];
    if AButton.Enabled and AButton.Visible and
      Assigned(AButton.OnDblClick) then AButton.OnDblClick(AButton);
  end;  
end;

procedure TSCButtonSet.DoBtnMouseDown(Index: Integer;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  AButton: TSCButtonSetButton;
begin
  if IsValidButton(Index) then
  begin
    AButton := FButtons[Index];
    if AButton.Enabled and AButton.Visible and
      Assigned(AButton.OnMouseDown) then
    begin
      P := Point(X, Y);
      P := ClientToButton(P);
      AButton.OnMouseDown(AButton, Button, Shift, P.X, P.Y);
    end;
  end;
end;

procedure TSCButtonSet.DoBtnMouseMove(Index: Integer; Shift: TShiftState;
  X, Y: Integer);
var
  P: TPoint;
  AButton: TSCButtonSetButton;
begin
  if IsValidButton(Index) then
  begin
    AButton := FButtons[Index];
    if AButton.Enabled and AButton.Visible and
      Assigned(AButton.OnMouseMove) then
    begin
      P := Point(X, Y);
      P := ClientToButton(P);
      AButton.OnMouseMove(AButton, Shift, P.X, P.Y);
    end;
  end;
end;

procedure TSCButtonSet.DoBtnMouseUp(Index: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  AButton: TSCButtonSetButton;
begin
  if IsValidButton(Index) then
  begin
    AButton := FButtons[Index];
    if AButton.Enabled and AButton.Visible and
      Assigned(AButton.OnMouseUp) then
    begin
      P := Point(X, Y);
      P := ClientToButton(P);
      AButton.OnMouseUp(AButton, Button, Shift, P.X, P.Y);
    end;
  end;
end;

procedure TSCButtonSet.SetHideFocusRect(const Value: Boolean);
begin
  if FHideFocusRect <> Value then
  begin
    FHideFocusRect := Value;
    if GetActiveButton <> nil then Invalidate;
  end;
end;

procedure TSCButtonSet.SetUseSystemFont(const Value: Boolean);
begin
  if FUseSystemFont <> Value then
  begin
    FUseSystemFont := Value;
    if Value then
    begin
      if ParentFont then ParentFont := False;
      SyncToSystemFont;
    end;
  end;
end;

procedure TSCButtonSet.CMSysFontChanged(var Message: TMessage);
begin
  inherited;
  SyncToSystemFont;
end;

procedure TSCButtonSet.SyncToSystemFont;
{$IFDEF SC_DELPHI4_AND_EARLY}
var
  NonClientMetrics: TNonClientMetrics;
{$ENDIF}
begin
  {$IFDEF SC_DELPHI4_AND_EARLY}
  if FUseSystemFont then
  begin
    NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
    if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
      Font.Handle := CreateFontIndirect(NonClientMetrics.lfMenuFont)
    else
      Font.Handle := GetStockObject(SYSTEM_FONT);
  end;
  {$ELSE}
  if FUseSystemFont then Font := Screen.MenuFont;
  {$ENDIF}
end;

procedure TSCButtonSet.CMParentFontChanged(var Message: TMessage);
begin
  inherited;
  if FUseSystemFont and ParentFont then FUseSystemFont := False;
end;

procedure TSCButtonSet.DoDrawDefault(ACanvas: TCanvas; R: TRect;
  Index: Integer);
var
  TxtFormat, ImgMid,
  BtnFrmWidth, DrawOffset,
  PopArrowW, FcOffset: Integer;
  ImgValid, TxtValid: Boolean;
  BtnAlignment: TLeftRight;
  BtnState: TSCButtonSetStates;
  BtnR: TRect;
  Text: String;
  AColor, FntColor: TColor;
  FntStyle: TFontStyles;
  AButton: TSCButtonSetButton;
begin
  if (ACanvas = nil) or (FButtons = nil) or IsRectEmpty(R) or
    (FPaintStyle <> scbpsDefault) or not IsValidButton(Index) then Exit;

  BtnFrmWidth := ButtonFrameWidth;
  if BtnFrmWidth < 0 then BtnFrmWidth := 0;
  InflateRect(R, -BtnFrmWidth, -BtnFrmWidth);

  AButton := FButtons[Index];

  BtnState := [];
  with AButton do
  begin
    if Down then Include(BtnState, scstDown);

    if Enabled and Visible then
    begin
      if FMouseDownBtn = Index then Include(BtnState, scstPressed);
      if (FMouseInBtn = Index) and ((FMouseDownBtn = -1) or
        (FMouseDownBtn = FMouseInBtn)) then Include(BtnState, scstHot);
    end;
  end;

  FntColor := Self.Font.Color;
  if AButton.ParentColor then
    AColor := DefaultBlendedColor(clBtnFace)
  else AColor := DefaultBlendedColor(AButton.Color);

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := AColor;

    BtnR := R;
    InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);
    FillRect(BtnR);
  end;

  BtnR := R;
  if FHorizontalSpace > 0 then InflateRect(BtnR, -FHorizontalSpace, 0);

  BtnAlignment := AButton.Alignment;
  ImgValid := IsValidImage(AButton.ImageIndex);

  DrawOffset := 0;
  if (scstDown in BtnState) or
    (BtnState*[scstHot, scstPressed]=[scstHot, scstPressed]) then
    DrawOffset := 1;

  TxtValid := True;
  if ImgValid then
  begin
    ImgMid := BtnR.Top + ((BtnR.Bottom - BtnR.Top - Images.Height) div 2);

    if BtnAlignment = taLeftJustify then
    begin
      TxtValid := BtnR.Left + ImageIndent + Images.Width <= BtnR.Right;

      if TxtValid then
      begin
        Inc(BtnR.Left, ImageIndent);
        Images.Draw(ACanvas, BtnR.Left + DrawOffset, ImgMid + DrawOffset,
          AButton.ImageIndex, AButton.Enabled);
        Inc(BtnR.Left, 2 + Images.Width + ImageIndent);
      end;
    end else
    begin
      TxtValid := BtnR.Right - (ImageIndent + Images.Width) >= BtnR.Left;

      if TxtValid then
      begin
        Dec(BtnR.Right, ImageIndent + Images.Width);
        Images.Draw(ACanvas, BtnR.Right + DrawOffset, ImgMid + DrawOffset,
          AButton.ImageIndex, AButton.Enabled);
        Dec(BtnR.Right, ImageIndent + 2);
      end;
    end;
  end;

  PopArrowW := 0;
  if AButton.PopupMenu <> nil then
  begin
    PopArrowW := PopupArrowWidth;
    if PopArrowW < 0 then PopArrowW := 0;

    if AButton.Alignment = taLeftJustify then
      Dec(BtnR.Right, PopArrowW)
    else Inc(BtnR.Left, PopArrowW);
  end;

  if TxtValid and (AButton.Caption <> '') and
    not IsRectEmpty(BtnR) then
  begin
    TxtFormat := DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS;
    if not ImgValid then
    begin
      TxtFormat := TxtFormat or DT_CENTER;
      InflateRect(BtnR, -2, 0);
    end else
      if BtnAlignment = taLeftJustify then
      begin
        TxtFormat := TxtFormat or DT_LEFT;

        Inc(BtnR.Left, Indent);
        if not ImgValid then Inc(BtnR.Left, 2);
        Dec(BtnR.Right, 4);
      end else
      begin
        TxtFormat := TxtFormat or DT_RIGHT;

        Dec(BtnR.Right, Indent);
        if not ImgValid then Dec(BtnR.Right, 2);
        Inc(BtnR.Left, 4);
      end;

    if not IsRectEmpty(BtnR) then
      with ACanvas do
      begin
        Font := Self.Font;
        Font.Color := FntColor;

        FntStyle := Self.Font.Style;
        if FUseSystemFont and (FPaintStyle = scbpsOfficeXP) then
          FntStyle := []
        else
        if AButton.Focused and AButton.Enabled then
          FntStyle := Self.FocusedStyle;

        Font.Style := FntStyle;

        Brush.Style := bsClear;
        Text := AButton.Caption;

        OffsetRect(BtnR, DrawOffset, DrawOffset);
        if AButton.Enabled then
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat)
        else begin
          OffsetRect(BtnR, 1, 1);
          Font.Color := clBtnHighlight;
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat);

          OffsetRect(BtnR, -1, -1);
          Font.Color := clBtnShadow;
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat);
        end;

        Brush.Style := bsSolid;
      end;
  end;

  if PopArrowW > 0 then
  begin
    BtnR := R;
    if FHorizontalSpace > 0 then InflateRect(BtnR, -FHorizontalSpace, 0);

    InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);

    if (BtnR.Bottom - BtnR.Top >= 3) and (BtnR.Right - BtnR.Left >= 5) then
    begin
      DrawOffset := (PopArrowW - 5) div 2;
      if DrawOffset < 4 then DrawOffset := 4;

      if AButton.Alignment = taLeftJustify then
      begin
        Dec(BtnR.Right, DrawOffset);
        BtnR.Left := BtnR.Right - 5;
      end else
      begin
        Inc(BtnR.Left, DrawOffset);
        BtnR.Right := BtnR.Left + 5;
      end;

      IntersectRect(BtnR, BtnR, R);
      if not IsRectEmpty(BtnR) then
      begin
        AColor := clBtnText;
        if not AButton.Enabled then AColor := clGrayText;

        BtnR.Top := BtnR.Top + ((BtnR.Bottom - BtnR.Top - 3) div 2);
        if (scstDown in BtnState) or
          (BtnState*[scstHot, scstPressed]=[scstHot, scstPressed]) then
          OffsetRect(BtnR, 1, 1);

        DoDrawArrow(ACanvas, BtnR.Left, BtnR.Top, AColor);
      end;
    end;
  end;

  BtnR := R;
  InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);

  FcOffset := 0;
  if scstDown in BtnState then
  begin
    Inc(FcOffset);

    scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnShadow),
      DefaultBlendedColor(clBtnHighlight), 1, 0);
    scFrame3D(ACanvas, BtnR, DefaultBlendedColor(cl3DDkShadow),
      DefaultBlendedColor(clBtnFace), 1, 0);
  end else
  if BtnState*[scstHot, scstPressed] = [scstHot, scstPressed] then
  begin
    Inc(FcOffset);

    scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clWindowFrame),
      DefaultBlendedColor(clWindowFrame), 1, 0);
    scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnShadow),
      DefaultBlendedColor(clBtnShadow), 1, 0);
  end else
  begin
    if AButton.Focused then
      scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clWindowFrame),
        DefaultBlendedColor(clWindowFrame), 1, 0);

    scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnHighlight),
      DefaultBlendedColor(cl3DDkShadow), 1, 0);
    scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnFace), DefaultBlendedColor(clBtnShadow), 1, 0);
  end;

  if not FHideFocusRect and Focused and AButton.Focused then
  begin
    Inc(FcOffset);
    InflateRect(BtnR, -FcOffset, -FcOffset);
    ACanvas.DrawFocusRect(BtnR);
  end;
end;

procedure TSCButtonSet.DoDrawSpeed(ACanvas: TCanvas; R: TRect;
  Index: Integer);
var
  TxtFormat, ImgMid,
  BtnFrmWidth, DrawOffset,
  PopArrowW: Integer;
  ImgValid, TxtValid: Boolean;
  BtnAlignment: TLeftRight;
  BtnState: TSCButtonSetStates;
  BtnR: TRect;
  Text: String;
  AColor, FntColor: TColor;
  FntStyle: TFontStyles;
  AButton: TSCButtonSetButton;
begin
  if (ACanvas = nil) or (FButtons = nil) or IsRectEmpty(R) or
    not (FPaintStyle in [scbpsFlat, scbpsMacDefault, scbpsMacSpeed, scbpsSpeed]) or
    not IsValidButton(Index) then Exit;

  BtnFrmWidth := ButtonFrameWidth;
  if BtnFrmWidth < 0 then BtnFrmWidth := 0;
  InflateRect(R, -BtnFrmWidth, -BtnFrmWidth);

  AButton := FButtons[Index];

  BtnState := [];
  with AButton do
  begin
    if Down then Include(BtnState, scstDown);

    if Enabled and Visible then
    begin
      if FMouseDownBtn = Index then Include(BtnState, scstPressed);
      if (FMouseInBtn = Index) and ((FMouseDownBtn = -1) or
        (FMouseDownBtn = FMouseInBtn)) then Include(BtnState, scstHot);
    end;
  end;

  FntColor := Self.Font.Color;
  if FPaintStyle in [scbpsMacDefault, scbpsMacSpeed] then
    AColor := DefaultBlendedColor(clBtnFace)
  else begin
    AColor := AButton.Color;
    if AButton.ParentColor then AColor := Self.Color;

    AColor := DefaultBlendedColor(AColor);
  end;

  with ACanvas do
  begin
    with Brush do
    begin
      Bitmap := nil;
      Style := bsSolid;
      Color := AColor;
    end;

    if FPaintStyle in [scbpsMacSpeed, scbpsMacDefault] then
    begin
      if (scstDown in BtnState) or
        (BtnState*[scstHot, scstPressed] = [scstHot, scstPressed]) then
        Brush.Color := DefaultBlendedColor(clBtnHighlight);
    end else
    if (scstDown in BtnState) and (BtnState*[scstHot, scstPressed] = []) then
      Brush.Bitmap := AllocPatternBitmap(AColor, clBtnHighlight);

    BtnR := R;
    InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);

    FillRect(BtnR);
  end;

  BtnR := R;
  if FHorizontalSpace > 0 then InflateRect(BtnR, -FHorizontalSpace, 0);

  BtnAlignment := AButton.Alignment;
  ImgValid := IsValidImage(AButton.ImageIndex);

  DrawOffset := 0;
  if (scstDown in BtnState) or
    (BtnState*[scstHot, scstPressed]=[scstHot, scstPressed]) then
    DrawOffset := 1;

  TxtValid := True;
  if ImgValid then
  begin
    ImgMid := BtnR.Top + ((BtnR.Bottom - BtnR.Top - Images.Height) div 2);

    if BtnAlignment = taLeftJustify then
    begin
      TxtValid := BtnR.Left + ImageIndent + Images.Width <= BtnR.Right;

      if TxtValid then
      begin
        Inc(BtnR.Left, ImageIndent);
        Images.Draw(ACanvas, BtnR.Left + DrawOffset, ImgMid + DrawOffset,
          AButton.ImageIndex, AButton.Enabled);
        Inc(BtnR.Left, 2 + Images.Width + ImageIndent);
      end;
    end else
    begin
      TxtValid := BtnR.Right - (ImageIndent + Images.Width) >= BtnR.Left;

      if TxtValid then
      begin
        Dec(BtnR.Right, ImageIndent + Images.Width);
        Images.Draw(ACanvas, BtnR.Right + DrawOffset, ImgMid + DrawOffset,
          AButton.ImageIndex, AButton.Enabled);
        Dec(BtnR.Right, ImageIndent + 2);
      end;
    end;
  end;

  PopArrowW := 0;
  if AButton.PopupMenu <> nil then
  begin
    PopArrowW := PopupArrowWidth;
    if PopArrowW < 0 then PopArrowW := 0;

    if AButton.Alignment = taLeftJustify then
      Dec(BtnR.Right, PopArrowW)
    else Inc(BtnR.Left, PopArrowW);
  end;

  if TxtValid and (AButton.Caption <> '') and
    not IsRectEmpty(BtnR) then
  begin
    TxtFormat := DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS;
    if not ImgValid then
    begin
      TxtFormat := TxtFormat or DT_CENTER;
      InflateRect(BtnR, -2, 0);
    end else
      if BtnAlignment = taLeftJustify then
      begin
        TxtFormat := TxtFormat or DT_LEFT;

        Inc(BtnR.Left, Indent);
        if not ImgValid then Inc(BtnR.Left, 2);
        Dec(BtnR.Right, 4);
      end else
      begin
        TxtFormat := TxtFormat or DT_RIGHT;

        Dec(BtnR.Right, Indent);
        if not ImgValid then Dec(BtnR.Right, 2);
        Inc(BtnR.Left, 4);
      end;

    if not IsRectEmpty(BtnR) then
      with ACanvas do
      begin
        Font := Self.Font;
        Font.Color := FntColor;

        FntStyle := Self.Font.Style;
        if FUseSystemFont and (FPaintStyle = scbpsOfficeXP) then
          FntStyle := []
        else
        if AButton.Focused and AButton.Enabled then
          FntStyle := Self.FocusedStyle;

        Font.Style := FntStyle;

        Brush.Style := bsClear;
        Text := AButton.Caption;

        OffsetRect(BtnR, DrawOffset, DrawOffset);
        if AButton.Enabled then
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat)
        else begin
          OffsetRect(BtnR, 1, 1);
          Font.Color := clBtnHighlight;
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat);

          OffsetRect(BtnR, -1, -1);
          Font.Color := clBtnShadow;
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat);
        end;

        Brush.Style := bsSolid;
      end;
  end;

  if PopArrowW > 0 then
  begin
    BtnR := R;
    if FHorizontalSpace > 0 then InflateRect(BtnR, -FHorizontalSpace, 0);

    InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);

    if (BtnR.Bottom - BtnR.Top >= 3) and (BtnR.Right - BtnR.Left >= 5) then
    begin
      DrawOffset := (PopArrowW - 5) div 2;
      if DrawOffset < 4 then DrawOffset := 4;

      if AButton.Alignment = taLeftJustify then
      begin
        Dec(BtnR.Right, DrawOffset);
        BtnR.Left := BtnR.Right - 5;
      end else
      begin
        Inc(BtnR.Left, DrawOffset);
        BtnR.Right := BtnR.Left + 5;
      end;

      IntersectRect(BtnR, BtnR, R);
      if not IsRectEmpty(BtnR) then
      begin
        AColor := clBtnText;
        if not AButton.Enabled then AColor := clGrayText;

        if FPaintStyle in [scbpsMacDefault, scbpsMacSpeed] then
          BtnR.Top := BtnR.Bottom - 5
        else BtnR.Top := BtnR.Top + ((BtnR.Bottom - BtnR.Top - 3) div 2);

        if (scstDown in BtnState) or
          (BtnState*[scstHot, scstPressed]=[scstHot, scstPressed]) then
          OffsetRect(BtnR, 1, 1);

        DoDrawArrow(ACanvas, BtnR.Left, BtnR.Top, AColor);
      end;
    end;
  end;

  BtnR := R;
  InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);

  case FPaintStyle of
    scbpsFlat:
    begin
      if (scstDown in BtnState) or
        (BtnState*[scstHot, scstPressed] = [scstHot, scstPressed]) then
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(cl3DDkShadow),
          DefaultBlendedColor(clBtnHighlight), 1, 0)
      else
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(FFlatColor),
          DefaultBlendedColor(FFlatColor), 1, 0);
    end;
    scbpsMacDefault:
    begin
      scFillCorners(ACanvas, BtnR, DefaultBlendedColor(Self.Color), 4);
      if (scstDown in BtnState) or
        (BtnState*[scstHot, scstPressed] = [scstHot, scstPressed]) then
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnShadow),
          DefaultBlendedColor(clBtnHighlight), 1, 4)
      else
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnHighlight),
          DefaultBlendedColor(clBtnShadow), 1, 4);

      InflateRect(BtnR, -1, -1);
      if not FHideFocusRect and Focused and AButton.Focused then
        ACanvas.DrawFocusRect(BtnR);
    end;
    scbpsMacSpeed:
    begin
      scFillCorners(ACanvas, BtnR, DefaultBlendedColor(Self.Color), 4);
      if (scstDown in BtnState) or
        (BtnState*[scstHot, scstPressed] = [scstHot, scstPressed]) then
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnShadow),
          DefaultBlendedColor(clBtnHighlight), 1, 4)
      else
      if (BtnState*[scstHot, scstPressed] = [scstHot]) or
        (BtnState*[scstHot, scstPressed] = [scstPressed]) then
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnHighlight),
          DefaultBlendedColor(clBtnShadow), 1, 4);
    end;
    scbpsSpeed:
    begin
      if (scstDown in BtnState) or
        (BtnState*[scstHot, scstPressed] = [scstHot, scstPressed]) then
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnShadow),
          DefaultBlendedColor(clBtnHighlight), 1, 0)
      else
      if (BtnState*[scstHot, scstPressed] = [scstHot]) or
        (BtnState*[scstHot, scstPressed] = [scstPressed]) then
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnHighlight),
          DefaultBlendedColor(clBtnShadow), 1, 0);
    end;
  end;
end;

procedure TSCButtonSet.SetSeperation(Value: Integer);
begin
  if Value < 0 then Value := 0
  else if Value > 20 then Value := 20;

  if FSeperation <> Value then
  begin
    FSeperation := Value;
    if IsValidButton(0) then Invalidate;
  end;
end;

procedure TSCButtonSet.DoDrawArrow(ACanvas: TCanvas; X, Y: Integer;
  AColor: TColor);
var
  BrushColor: TColor;
begin
  if ACanvas <> nil then
    with ACanvas do
    begin
      with Brush do
      begin
        BrushColor := Color;
        Color := AColor;
        Style := bsSolid;
      end;

      with Pen do
      begin
        Width := 1;
        Style := psSolid;
        Color := AColor;
      end;

      Polygon([Point(X, Y), Point(X + 4, Y), Point(X + 2, Y + 2)]);
      Brush.Color := BrushColor;
    end;
end;

procedure TSCButtonSet.SetAutoSize(Value: Boolean);
begin
  if AutoSize <> Value then
  begin
    DoAutoSize(Value);
    if Value then AdjustSize;
  end;
end;

procedure TSCButtonSet.DoResetWidths;
var
  R: TRect;
  BtnHeight, I: Integer;
begin
  if not (CanGetClientRect and (FButtons <> nil)) then Exit;

  if AutoSize then
  begin
    AdjustSize;
    Exit;
  end;

  BtnHeight := GetButtonHeight;
  if BtnHeight < 0 then BtnHeight := 0;

  FButtons.BeginUpdate;
  try
    for I := 0 to FButtons.Count - 1 do
    begin
      R := GetButtonBounds(I, True, False, BtnHeight);
      OffsetRect(R, -R.Left, 0);

      if R.Right < 0 then R.Right := 0;

      with FButtons[I] do
      begin
        try
          FLockChange := True;
          Width := R.Right;
        finally
          FLockChange := False;
        end;
      end;
    end;
  finally
    FButtons.EndUpdate;
  end;
end;

procedure TSCButtonSet.SetResetWidths(const Value: Boolean);
begin
  if Value then DoResetWidths;
end;

procedure TSCButtonSet.SetHorizontalSpace(Value: Integer);
begin
  if Value < 0 then Value := 0
  else if Value > 100 then Value := 100;

  if FHorizontalSpace <> Value then
  begin
    FHorizontalSpace := Value;
    if AutoSize then AdjustSize;
    Invalidate;
  end;
end;

function TSCButtonSet.CanGetFocus: Boolean;
begin
  Result := inherited CanGetFocus and
    (FPaintStyle in [scbpsDefault, scbpsMac, scbpsMacSquare, scbpsXP]);
end;

procedure TSCButtonSet.CMDialogChar(var Message: TCMDialogChar);
var
  Indx, I: Integer;
  AButton: TSCButtonSetButton;
begin
  with Message do
  begin
    Indx := -1;

    if (FButtons <> nil) and Enabled and Visible and
      (Parent <> nil) and Parent.Showing and CanFocus then
    begin
      for I := 0 to FButtons.Count-1 do
      begin
        AButton := FButtons[I];

        if AButton.Enabled and AButton.Visible and
          IsAccel(CharCode, AButton.FCaption) then
        begin
          Indx := I;
          Break;
        end;
      end;
    end;

    if IsValidButton(Indx) then
    begin
      DoBtnClick(Indx);
      Result := 1;
    end else
      inherited;
  end;
end;

procedure TSCButtonSet.CMDialogKey(var Message: TCMDialogKey);
var
  Indx, Fc, I: Integer;
  AButton: TSCButtonSetButton;
begin
  with Message do
  begin
    Indx := -1;

    if (FButtons <> nil) and Enabled and Visible and
      (Parent <> nil) and Parent.Showing and
      (KeyDataToShiftState(Message.KeyData) = []) and CanFocus then
    begin
      Fc := FButtonIndex;

      for I := 0 to FButtons.Count-1 do
      begin
        AButton := FButtons[I];

        if AButton.Enabled and AButton.Visible and
          (((Fc = I) and (CharCode = VK_RETURN)) or
           (AButton.Cancel and (CharCode = VK_ESCAPE))) then
        begin
          Indx := I;
          Break;
        end;
      end;
    end;

    if IsValidButton(Indx) then
    begin
      DoBtnClick(Indx);
      Result := 1;
    end else
      inherited;
  end;
end;

procedure TSCButtonSet.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TSCButtonSet.KeyDown(var Key: Word; Shift: TShiftState);
var
  Indx, I: Integer;
begin
  inherited KeyDown(Key, Shift);

  if (FButtons <> nil) and (FButtons.Count > 0) then
  begin
    Indx := FButtonIndex;
    case Key of
      107, 52,
      VK_NEXT, VK_RIGHT, VK_DOWN:
      begin
        if FButtonIndex < FButtons.Count-1 then
          for I := Indx + 1 to FButtons.Count-1 do
            if FButtons[I].Visible and FButtons[I].Enabled then
            begin
              Indx := I;
              Break;
            end;
      end;
      109, 189,
      VK_PRIOR, VK_LEFT, VK_UP:
      begin
        if FButtonIndex > 0 then
          for I := Indx - 1 downto 0 do
            if FButtons[I].Visible and FButtons[I].Enabled then
            begin
              Indx := I;
              Break;
            end;
      end;
      VK_HOME:
      begin
        if FButtonIndex <> 0 then
          for I := 0 to FButtons.Count-1 do
            if FButtons[I].Visible and FButtons[I].Enabled then
            begin
              Indx := I;
              Break;
            end;
      end;
      VK_END:
      begin
        if FButtonIndex <> FButtons.Count-1 then
          for I := FButtons.Count-1 downto 0 do
            if FButtons[I].Visible and FButtons[I].Enabled then
            begin
              Indx := I;
              Break;
            end;
      end;
    end;

    SetButtonIndex(Indx);
  end;
end;

procedure TSCButtonSet.DoDrawMac(ACanvas: TCanvas; R: TRect;
  Index: Integer);
var
  TxtFormat, ImgMid,
  BtnFrmWidth, DrawOffset, PopArrowW: Integer;
  ImgValid, TxtValid: Boolean;
  BtnAlignment: TLeftRight;
  BtnState: TSCButtonSetStates;
  BtnR: TRect;
  Text: String;
  AColor, FcColor, FntColor: TColor;
  FntStyle: TFontStyles;
  AButton: TSCButtonSetButton;
begin
  if (ACanvas = nil) or (FButtons = nil) or IsRectEmpty(R) or
    not (FPaintStyle in [scbpsMac, scbpsMacSquare]) or not IsValidButton(Index) then Exit;

  BtnFrmWidth := ButtonFrameWidth;
  if BtnFrmWidth < 0 then BtnFrmWidth := 0;
  InflateRect(R, -BtnFrmWidth, -BtnFrmWidth);

  AButton := FButtons[Index];

  BtnState := [];
  with AButton do
  begin
    if Down then Include(BtnState, scstDown);

    if Enabled and Visible then
    begin
      if FMouseDownBtn = Index then Include(BtnState, scstPressed);
      if (FMouseInBtn = Index) and ((FMouseDownBtn = -1) or
        (FMouseDownBtn = FMouseInBtn)) then Include(BtnState, scstHot);
    end;
  end;

  FntColor := Self.Font.Color;
  FcColor := DefaultBlendedColor(clBtnFace);

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := FcColor;

    BtnR := R;
    InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);
    FillRect(BtnR);
  end;

  BtnR := R;
  if FHorizontalSpace > 0 then InflateRect(BtnR, -FHorizontalSpace, 0);

  BtnAlignment := AButton.Alignment;
  ImgValid := IsValidImage(AButton.ImageIndex);

  DrawOffset := 0;
  if (scstDown in BtnState) or
    (BtnState*[scstHot, scstPressed]=[scstHot, scstPressed]) then
    DrawOffset := 1;

  TxtValid := True;
  if ImgValid then
  begin
    ImgMid := BtnR.Top + ((BtnR.Bottom - BtnR.Top - Images.Height) div 2);

    if BtnAlignment = taLeftJustify then
    begin
      TxtValid := BtnR.Left + ImageIndent + Images.Width <= BtnR.Right;

      if TxtValid then
      begin
        Inc(BtnR.Left, ImageIndent);
        Images.Draw(ACanvas, BtnR.Left + DrawOffset, ImgMid + DrawOffset,
          AButton.ImageIndex, AButton.Enabled);
        Inc(BtnR.Left, 2 + Images.Width + ImageIndent);
      end;
    end else
    begin
      TxtValid := BtnR.Right - (ImageIndent + Images.Width) >= BtnR.Left;

      if TxtValid then
      begin
        Dec(BtnR.Right, ImageIndent + Images.Width);
        Images.Draw(ACanvas, BtnR.Right + DrawOffset, ImgMid + DrawOffset,
          AButton.ImageIndex, AButton.Enabled);
        Dec(BtnR.Right, ImageIndent + 2);
      end;
    end;
  end;

  PopArrowW := 0;
  if AButton.PopupMenu <> nil then
  begin
    PopArrowW := PopupArrowWidth;
    if PopArrowW < 0 then PopArrowW := 0;

    if AButton.Alignment = taLeftJustify then
      Dec(BtnR.Right, PopArrowW)
    else Inc(BtnR.Left, PopArrowW);
  end;

  if TxtValid and (AButton.Caption <> '') and
    not IsRectEmpty(BtnR) then
  begin
    TxtFormat := DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS;
    if not ImgValid then
    begin
      TxtFormat := TxtFormat or DT_CENTER;
      InflateRect(BtnR, -2, 0);
    end else
      if BtnAlignment = taLeftJustify then
      begin
        TxtFormat := TxtFormat or DT_LEFT;

        Inc(BtnR.Left, Indent);
        if not ImgValid then Inc(BtnR.Left, 2);
        Dec(BtnR.Right, 4);
      end else
      begin
        TxtFormat := TxtFormat or DT_RIGHT;

        Dec(BtnR.Right, Indent);
        if not ImgValid then Dec(BtnR.Right, 2);
        Inc(BtnR.Left, 4);
      end;

    if not IsRectEmpty(BtnR) then
      with ACanvas do
      begin
        Font := Self.Font;
        Font.Color := FntColor;

        FntStyle := Self.Font.Style;
        if FUseSystemFont and (FPaintStyle = scbpsOfficeXP) then
          FntStyle := []
        else
        if AButton.Focused and AButton.Enabled then
          FntStyle := Self.FocusedStyle;

        Font.Style := FntStyle;

        Brush.Style := bsClear;
        Text := AButton.Caption;

        OffsetRect(BtnR, DrawOffset, DrawOffset);
        if AButton.Enabled then
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat)
        else begin
          OffsetRect(BtnR, 1, 1);
          Font.Color := clBtnHighlight;
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat);

          OffsetRect(BtnR, -1, -1);
          Font.Color := clBtnShadow;
          DrawText(ACanvas.Handle, PChar(Text), Length(Text), BtnR, TxtFormat);
        end;

        Brush.Style := bsSolid;
      end;
  end;

  if PopArrowW > 0 then
  begin
    BtnR := R;
    if FHorizontalSpace > 0 then InflateRect(BtnR, -FHorizontalSpace, 0);

    InflateRect(BtnR, BtnFrmWidth, BtnFrmWidth);

    if (BtnR.Bottom - BtnR.Top >= 3) and (BtnR.Right - BtnR.Left >= 5) then
    begin
      DrawOffset := (PopArrowW - 5) div 2;
      if DrawOffset < 4 then DrawOffset := 4;

      if AButton.Alignment = taLeftJustify then
      begin
        Dec(BtnR.Right, DrawOffset);
        BtnR.Left := BtnR.Right - 5;
      end else
      begin
        Inc(BtnR.Left, DrawOffset);
        BtnR.Right := BtnR.Left + 5;
      end;

      IntersectRect(BtnR, BtnR, R);
      if not IsRectEmpty(BtnR) then
      begin
        AColor := clBtnText;
        if not AButton.Enabled then AColor := clGrayText;

        BtnR.Top := BtnR.Top + ((BtnR.Bottom - BtnR.Top - 3) div 2);
        if (scstDown in BtnState) or
          (BtnState*[scstHot, scstPressed]=[scstHot, scstPressed]) then
          OffsetRect(BtnR, 1, 1);

        DoDrawArrow(ACanvas, BtnR.Left, BtnR.Top, AColor);
      end;
    end;
  end;

  AColor := FcColor;
  if not FHideFocusRect and Focused and AButton.Focused then
    AColor := BlendedColor(clHighlight, 80, 80, 80, True);

  case FPaintStyle of
    scbpsMac:
    begin
      BtnR := R;
      scFillCorners(ACanvas, BtnR, FcColor, 6);

      InflateRect(R, BtnFrmWidth, BtnFrmWidth);
      BtnR := R;

      scFrame3D(ACanvas, BtnR, AColor, AColor, 1, 4);
      scFrame3D(ACanvas, BtnR, AColor, AColor, 1, 6);
      InflateRect(BtnR, 1, 1);
      scFrame3D(ACanvas, BtnR, AColor, AColor, 1, 4);
      InflateRect(BtnR, 1, 1);
      scFrame3D(ACanvas, BtnR, AColor, AColor, 1, 2);

      BtnR := R;
      InflateRect(BtnR, -2, -2);

      if (scstDown in BtnState) or
        (BtnState*[scstHot, scstPressed] = [scstHot, scstPressed]) then
      begin
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clWindowFrame),
          DefaultBlendedColor(clWindowFrame), 1, 4);

        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(cl3DDkShadow),
          DefaultBlendedColor(clBtnFace), 1, 2);
        InflateRect(BtnR, 1, 1);
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(cl3DDkShadow),
          DefaultBlendedColor(clBtnFace), 1, 4);

        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnShadow),
          DefaultBlendedColor(clBtnHighlight), 1, 2);
        InflateRect(BtnR, 1, 1);
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnShadow),
          DefaultBlendedColor(clBtnHighlight), 1, 4);
      end else
      begin
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clWindowFrame),
          DefaultBlendedColor(clWindowFrame), 1, 4);

        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnFace),
          DefaultBlendedColor(cl3DDkShadow), 1, 2);
        InflateRect(BtnR, 1, 1);
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnFace),
          DefaultBlendedColor(cl3DDkShadow), 1, 4);

        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnHighlight),
          DefaultBlendedColor(clBtnShadow), 1, 2);
        InflateRect(BtnR, 1, 1);
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnHighlight),
          DefaultBlendedColor(clBtnShadow), 1, 4);
      end;
    end;
    scbpsMacSquare:
    begin
      InflateRect(R, BtnFrmWidth, BtnFrmWidth);
      BtnR := R;

      scFrame3D(ACanvas, BtnR, AColor, AColor, 1, 0);
      scFrame3D(ACanvas, BtnR, AColor, AColor, 1, 0);

      BtnR := R;
      InflateRect(BtnR, -2, -2);

      if (scstDown in BtnState) or
        (BtnState*[scstHot, scstPressed] = [scstHot, scstPressed]) then
      begin
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clWindowFrame),
          DefaultBlendedColor(clWindowFrame), 1, 0);

        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(cl3DDkShadow),
          DefaultBlendedColor(clBtnFace), 1, 0);

        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnShadow),
          DefaultBlendedColor(clBtnHighlight), 1, 0);
      end else
      begin
        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clWindowFrame),
          DefaultBlendedColor(clWindowFrame), 1, 0);

        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnFace),
          DefaultBlendedColor(cl3DDkShadow), 1, 0);

        scFrame3D(ACanvas, BtnR, DefaultBlendedColor(clBtnHighlight),
          DefaultBlendedColor(clBtnShadow), 1, 0);
      end;
    end;
  end;
end;

procedure TSCButtonSet.ImageListChange(Sender: TObject);
begin
  inherited;
  if AutoSize then AdjustSize;
end;

procedure TSCButtonSet.AdjustBounds;
begin
  inherited AdjustBounds;
  if AutoSize then AdjustSize;
end;

procedure TSCButtonSet.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCButtonSet then
  begin
    with TSCButtonSet(Source) do
    begin
      Self.Style := Style;
      Self.AllowAllUp := AllowAllUp;
      Self.ButtonIndex := ButtonIndex;
      Self.Buttons := Buttons;
      Self.FlatColor := FlatColor;
      Self.FocusedStyle := FocusedStyle;
      Self.HideFocusRect := HideFocusRect;
      Self.HorizontalSpace := HorizontalSpace;
      Self.ImageIndent := ImageIndent;
      Self.PaintStyle := PaintStyle;
      Self.ResetWidths := ResetWidths;
      Self.Seperation := Seperation;
      Self.UseSystemFont := UseSystemFont;
    end;
  end;
end;

procedure TSCButtonSet.CMHintShow(var Message: TMessage);
const
  EmptyHint = '';
var
  P: TPoint;
  Indx: Integer;
  HRect: TRect;
begin
  inherited;

  with TCMHintShow(Message) do
  begin
    P := HintInfo.CursorPos;

    Indx := GetButtonAtPos(P);
    if (Indx > -1) and (FButtons <> nil) and (Indx < FButtons.Count) then
    begin
      HintInfo.CursorRect := ButtonRect(Indx);

      if (FButtons[Indx].Hint = '') or
        not (FButtons[Indx].Visible and FButtons[Indx].Enabled) then
      begin
        HintInfo.HintStr := EmptyHint;
        Result := 1;
      end else
        HintInfo.HintStr := FButtons[Indx].Hint;
    end else
    begin
      Indx := GetButtonAtPos(Point(P.X + 1, P.Y));

      if (Indx > -1) and (FButtons <> nil) and (Indx < FButtons.Count) then
      begin
        HRect := ClientRect;
        HRect.Left  := P.X - 1;
        HRect.Right := P.X + 1;
        HintInfo.CursorRect := HRect;
      end else
      begin
        Indx := GetButtonAtPos(Point(P.X - 1, P.Y));

        if (Indx > -1) and (FButtons <> nil) and (Indx < FButtons.Count) then
        begin
          HRect := ClientRect;
          HRect.Left  := P.X;
          HRect.Right := P.X + 2;
          HintInfo.CursorRect := HRect;
        end;
      end;
    end;
  end;
end;

function TSCButtonSet.ButtonRect(Index: Integer): TRect;
var
  CR, R, BtnR: TRect;
  I, BtnHeight,
  FrmWidth, SepWidth: Integer;
  AButton: TSCButtonSetButton;
begin
  Result := Rect(0, 0, 0, 0);
  if (Index > -1) and (FButtons <> nil) and (Index < FButtons.Count) then
  begin
    FrmWidth := FrameWidth;
    if FrmWidth < 0 then FrmWidth := 0;

    CR := ClientRect;
    InflateRect(CR, -FrmWidth, -FrmWidth);

    if not IsRectEmpty(CR) then
    begin
      BtnHeight := GetButtonHeight;
      if BtnHeight <= 0 then Exit;

      SepWidth := SeperatorWidth;
      if SepWidth < 0 then SepWidth := 0;

      BtnR := Rect(FrmWidth, FrmWidth, FrmWidth + 1, BtnHeight + FrmWidth);

      R := BtnR;

      IntersectRect(BtnR, R, CR);
      if IsRectEmpty(BtnR) then Exit;

      if EqualRect(R, BtnR) then Dec(BtnR.Right);

      for I := 0 to FButtons.Count-1 do
      begin
        AButton := FButtons[I];
        if not AButton.Visible then
          Continue;

        R := GetButtonBounds(I, AutoSize, True, BtnHeight);
        OffsetRect(R, -R.Left, 0);

        Inc(BtnR.Right, R.Right);

        R := BtnR;
        IntersectRect(BtnR, BtnR, CR);

        if I = Index then
        begin
          Result := BtnR;
          Exit;
        end;

        if not EqualRect(R, BtnR) then
          Exit;

        OffsetRect(BtnR, SepWidth, 0);
        BtnR.Left := BtnR.Right;
      end;
    end;
  end;
end;

{ TSCButtonSetActionLink }

procedure TSCButtonSetActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  FClient := AClient as TSCButtonSetButton;
end;

function TSCButtonSetActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and
    (FClient.Caption = (Action as TCustomAction).Caption);
end;

function TSCButtonSetActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and
    (FClient.Down = (Action as TCustomAction).Checked);
end;

function TSCButtonSetActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and
    (FClient.Enabled = (Action as TCustomAction).Enabled);
end;

function TSCButtonSetActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and
    (FClient.Hint = (Action as TCustomAction).Hint);
end;

function TSCButtonSetActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and
    (FClient.ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TSCButtonSetActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and
    (@FClient.OnClick = @Action.OnExecute);
end;

function TSCButtonSetActionLink.IsShortCutLinked: Boolean;
begin
  Result := False;
end;

function TSCButtonSetActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and
    (FClient.Visible = (Action as TCustomAction).Visible);
end;

procedure TSCButtonSetActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then FClient.Caption := Value;
end;

procedure TSCButtonSetActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then FClient.Down := Value;
end;

procedure TSCButtonSetActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then FClient.Enabled := Value;
end;

procedure TSCButtonSetActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then FClient.Hint := Value;
end;

procedure TSCButtonSetActionLink.SetImageIndex(Value: Integer);
begin
  if IsCaptionLinked then FClient.ImageIndex := Value;
end;

procedure TSCButtonSetActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then FClient.OnClick := Value;
end;

procedure TSCButtonSetActionLink.SetShortCut(Value: TShortCut);
begin
  // if IsShortCutLinked then FClient.Shortcut := Value;
end;

procedure TSCButtonSetActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then FClient.Visible := Value;
end;

end.
