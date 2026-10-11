{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCStatusBar;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCConsts, SCControl, SCCommon, TypInfo, Extctrls, ImgList, StdActns,
  ActnList;

type
  TSCCustomStatusBar = class;
  TSCStatusPanel = class;

  TSCPanelAlign = (scpaLeft, scpaRight);

  TSCStatusPanelStyle = (scpsAnimation, scpsControl, scpsGauge,
    scpsImage, scpsImageAndText, scpsOwnerDraw, scpsText);

  TSCStatusPanelBevel = (scpbNone, scpbLowered, scpbRaised, scpbFlat,
    scpb3DLowered, scpb3DRaised);
    
  TSCBarStyle = (scbsStatusWindows, scbsStatusMac, scbsStatusOffice12,
    scbsStatusXP);

  TSCStatusPanelActionLink = class(TActionLink)
  protected
    FClient: TSCStatusPanel;
    procedure AssignClient(AClient: TObject); override;
    function  IsCaptionLinked: Boolean; override;
    function  IsEnabledLinked: Boolean; override;
    function  IsHintLinked: Boolean; override;
    function  IsImageIndexLinked: Boolean; override;
    function  IsShortCutLinked: Boolean; override;
    function  IsVisibleLinked: Boolean; override;
    function  IsOnExecuteLinked: Boolean; override;
    procedure SetCaption(const Value: string); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetHint(const Value: string); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetShortCut(Value: TShortCut); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
  end;

  TSCStatusPanelActionLinkClass = class of TSCStatusPanelActionLink;

  TSCStatusGaugeStyle = (scsg3d, scsgClasic, scsgSliced, scsgSlicedGradient,
    scsgGradient, scsgRaised, scsgXP);

  TSCStatusPanelGauge = class(TPersistent)
  private
    FColor: TColor;
    FEndColor: TColor;
    FPosition: Word;
    FStyle: TSCStatusGaugeStyle;
    FMin: Integer;
    FMax: Integer;
    FCaption: String;
    FOnChange: TNotifyEvent;
    FNotifyLocked: Boolean;
    procedure SetCaption(const Value: String);
    procedure SetColor(Value: TColor);
    procedure SetEndColor(Value: TColor);
    procedure SetMin(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure SetPosition(Value: Word);
    procedure SetStyle(Value: TSCStatusGaugeStyle);
  protected
    procedure DoChange; virtual;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Caption: String read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor default clHighlight;
    property EndColor: TColor read FEndColor write SetEndColor default clAqua;
    property Min: Integer read FMin write SetMin default 0;
    property Max: Integer read FMax write SetMax default 100;
    property Position: Word read FPosition write SetPosition default 0;
    property Style: TSCStatusGaugeStyle read FStyle write SetStyle default scsgClasic;
  end;

  TSCStatusPanel = class(TCollectionItem)
  private
    FText: string;
    FWidth: Integer;
    FAlignment: TAlignment;
    FAutoSize: Boolean;
    FBevel: TSCStatusPanelBevel;
    FStyle: TSCStatusPanelStyle;
    FColor: TColor;
    FParentColor: Boolean;
    FImageIndex: TImageIndex;
    FAnimationStart: TImageIndex;
    FAnimationStop: TImageIndex;
    FAnimateTimer: TTimer;
    FAnimationInterval: Cardinal;
    FAnimate: Boolean;
    FVisible: Boolean;
    FEnabled: Boolean;
    FActionLink: TSCStatusPanelActionLink;
    FIndent: Integer;
    FEndEllipsis: Boolean;
    FGauge: TSCStatusPanelGauge;
    FBorderColor: TColor;
    FHint: String;
    FShowing: Boolean;
    FFlash: Boolean;
    FFlashShowPause: Cardinal;
    FFlashHidePause: Cardinal;
    FFlashTimer: TTimer;
    FFontColor: TColor;
    FCurAnimateIndex: TImageIndex;
    FOnAnimate: TNotifyEvent;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseUp: TMouseEvent;
    FControl: TControl;
    function  GetAction: TBasicAction;
    procedure SetAction(const Value: TBasicAction);
    procedure SetAlignment(Value: TAlignment);
    procedure SetAnimationStart(Value: TImageIndex);
    procedure SetAnimationStop(Value: TImageIndex);
    function  GetAnimationInterval: Cardinal;
    procedure SetAnimationInterval(Value: Cardinal);
    function  GetAnimate: Boolean;
    procedure SetAnimate(Value: Boolean);
    procedure SetAutoSize(Value: Boolean);
    procedure SetBevel(Value: TSCStatusPanelBevel);
    procedure SetBorderColor(Value: TColor);
    procedure SetColor(Value: TColor);
    procedure SetControl(Value: TControl);
    procedure SetEnabled(Value: Boolean);
    procedure SetEndEllipsis(Value: Boolean);
    procedure SetFlash(Value: Boolean);
    procedure SetFlashShowPause(Value: Cardinal);
    procedure SetFlashHidePause(Value: Cardinal);
    procedure SetFontColor(Value: TColor);
    procedure SetGauge(Value: TSCStatusPanelGauge);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetIndent(Value : Integer);
    procedure SetParentColor(Value: Boolean);
    function  GetStatusBar: TSCCustomStatusBar;
    procedure SetStyle(Value: TSCStatusPanelStyle);
    procedure SetText(const Value: string);
    procedure SetVisible(Value: Boolean);
    procedure SetWidth(Value: Integer);

    procedure DoChange(AllItems: Boolean; Force: Boolean = False);
  protected
    function  GetDisplayName: string; override;
    function  GetParentColor: TColor; virtual;

    procedure Notification(AComponent: TComponent; Operation: TOperation); virtual;
    procedure FreeNotification(AComponent: TComponent);
    procedure RemoveFreeNotification(AComponent: TComponent);

    function  IsCaptionStored: Boolean;
    function  IsEnabledStored: Boolean;
    function  IsHintStored: Boolean;
    function  IsImageIndexStored: Boolean;
    function  IsOnClickStored: Boolean;
    function  IsVisibleStored: Boolean;
    procedure DoActionChange(Sender: TObject);
    procedure GaugeChanged(Sender: TObject);
    function  OwnerState: TComponentState;
    function  GetImages: TCustomImageList;
    procedure InitiateAnimation;
    function  InitiateAnimationTimer: TTimer;
    procedure ReleaseAnimationTimer;
    procedure AnimateThis(Sender: TObject);
    procedure InitiateFlashing;
    function  InitiateFlashTimer: TTimer;
    procedure ReleaseFlashTimer;
    procedure FlashMe(Sender: TObject);
    function  GetActionLinkClass: TSCStatusPanelActionLinkClass; dynamic;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); dynamic;

    property ActionLink: TSCStatusPanelActionLink read FActionLink write FActionLink;
    property CurAnimateIndex: TImageIndex read FCurAnimateIndex;
    property StatusBar: TSCCustomStatusBar read GetStatusbar;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    
    procedure ResetCurAnimation;
    property Showing: Boolean read FShowing;
  published
    property Action: TBasicAction read GetAction write SetAction;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Control: TControl read FControl write SetControl;

    { Animation }
    property AnimationStart: TImageIndex read FAnimationStart write SetAnimationStart default -1;
    property AnimationStop: TImageIndex read FAnimationStop write SetAnimationStop default -1;
    property AnimationInterval: Cardinal read GetAnimationInterval write SetAnimationInterval default 1000;
    property Animate: Boolean read GetAnimate write SetAnimate stored True default False;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    property Bevel: TSCStatusPanelBevel read FBevel write SetBevel default scpbLowered;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clBtnShadow;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Enabled: Boolean read FEnabled write SetEnabled stored IsEnabledStored default True;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default True;

    property Flash: Boolean read FFlash write SetFlash stored True default False;
    property FlashHidePause: Cardinal read FFlashHidePause write SetFlashHidePause default 200;
    property FlashShowPause: Cardinal read FFlashShowPause write SetFlashShowPause default 500;

    property FontColor: TColor read FFontColor write SetFontColor default clNone;
    property Gauge: TSCStatusPanelGauge read FGauge write SetGauge;
    property Hint: String read FHint write FHint;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex stored IsImageIndexStored default -1;
    property Indent: Integer read FIndent write SetIndent default 0;
    property ParentColor: Boolean read FParentColor write SetParentColor default True;
    property Style: TSCStatusPanelStyle read FStyle write SetStyle default scpsText;
    property Text: string read FText write SetText stored IsCaptionStored;
    property Visible: Boolean read FVisible write SetVisible stored IsVisibleStored default True;
    property Width: Integer read FWidth write SetWidth default 50;
    property OnAnimate: TNotifyEvent read FOnAnimate write FOnAnimate;
    property OnClick: TNotifyEvent read FOnClick write FOnClick stored IsOnClickStored;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
  end;

  TSCStatusPanels = class(TCollection)
  private
    FStatusBar: TSCCustomStatusBar;
    function  GetItem(Index: Integer): TSCStatusPanel;
    procedure SetItem(Index: Integer; Value: TSCStatusPanel);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(StatusBar: TSCCustomStatusBar);
    function Add: TSCStatusPanel;

    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomStatusBar read FStatusBar;
    {$ENDIF}
    property Items[Index: Integer]: TSCStatusPanel read GetItem write SetItem; default;
  end;

  TSCDrawStatusEvent = procedure(StatusBar: TSCCustomStatusBar; Panel: TSCStatusPanel;
    StatusCanvas: TCanvas; const Rect: TRect) of object;

  TSCCustomStatusBar = class(TSCCustomControl)
  private
    FPanels: TSCStatusPanels;
    FSimpleText: string;
    FSimplePanel: Boolean;
    FUseSystemFont: Boolean;
    FSizeGrip: Boolean;
    FLeftSpace: Cardinal;
    FStyle: TSCBarStyle;
    FAutoHint: Boolean;
    FPanelAlign: TSCPanelAlign;
    FOnHint: TNotifyEvent;
    FOnDrawPanel: TSCDrawStatusEvent;
    FSzGripClick: Boolean;
    FOldCursor: TCursor;
    FMouseDownPanel: Integer;
    FPanelDblClicked: Boolean;
    procedure SetPanelAlign(Value: TSCPanelAlign);
    procedure SetStyle(Value: TSCBarStyle);
    procedure SetPanels(Value: TSCStatusPanels);
    procedure SetSimplePanel(Value: Boolean);
    procedure SetSimpleText(const Value: string);
    procedure SetLeftSpace(Value: Cardinal);
    procedure SetSizeGrip(Value: Boolean);
    procedure SetUseSystemFont(const Value: Boolean);
    
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure CMParentColorChanged(var Message: TMessage); message CM_PARENTCOLORCHANGED;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMWinIniChange(var Message: TMessage); message CM_WININICHANGE;
    procedure CMSysFontChanged(var Message: TMessage); message CM_SYSFONTCHANGED;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    procedure Paint; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;

    function  GetGradientDark(AColor: TColor): TColor;
    function  GetGradientLight(AColor: TColor): TColor;
    function  GetGradientPreLight(AColor: TColor): TColor;

    function  GetMacSpace: Integer;
    function  GetSimpleLeft: Integer;
    function  GetPanelSpacing: Integer;
    function  GetSizeGripWidth: Integer;

    procedure StopTracking; override;

    procedure DoDockOver(Source: TDragDockObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    function  DoHint: Boolean; virtual;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    procedure SyncToSystemFont;
    procedure PanelControlAssigned(Panel: TSCStatusPanel; AControl: TControl);

    function  GetPanelSpace: Word; dynamic;
    procedure UpdatePanelColors(OldColor: TColor);
    procedure UpdatePanel(Index: Integer; Repaint: Boolean); dynamic;
    procedure UpdatePanels; dynamic;

    function  GetDefaultBackColor: TColor; override;

    function  GetMacClientWidth: Integer;
    function  CalculateImageRect(Panel: TSCStatusPanel; R: TRect): TRect; reintroduce;
    function  SizerRect: TRect; dynamic;

    procedure DrawOffice12Face(ACanvas: TCanvas; ARect: TRect);
    procedure DoDrawSpace(PanelCanvas: TCanvas; const R: TRect);
    procedure DoDrawPanel(Panel: TSCStatusPanel; PanelCanvas: TCanvas; const R: TRect);
    procedure DoDrawImagePanel(Panel: TSCStatusPanel; PanelCanvas: TCanvas; const R: TRect);
    procedure DoDrawAnimatePanel(Panel: TSCStatusPanel; PanelCanvas: TCanvas; const R: TRect);
    procedure DoDrawTextPanel(Panel: TSCStatusPanel; PanelCanvas: TCanvas; const R: TRect);
    procedure DoDrawGaugePanel(Panel: TSCStatusPanel; PanelCanvas: TCanvas; const R: TRect);

    procedure DoDrawPanelBorder(Panel: TSCStatusPanel; PanelCanvas: TCanvas; const R: TRect);
    procedure DoDrawMacBorder(ACanvas: TCanvas);
    procedure DoDrawXPBorder(ACanvas: TCanvas);
    procedure DoDrawOffice12Border(ACanvas: TCanvas);
    procedure DoDrawWinSizer(ACanvas: TCanvas);
    procedure DoDrawMacSizer(ACanvas: TCanvas);
    procedure DoDrawXPSizer(ACanvas: TCanvas);
    procedure DoDrawOffice12Sizer(ACanvas: TCanvas);

    property Align default alBottom;
    property AutoHint: Boolean read FAutoHint write FAutoHint default False;
    property Color default clBtnFace;
    property LeftSpace: Cardinal read FLeftSpace write SetLeftSpace default 0;
    property PanelAlign: TSCPanelAlign read FPanelAlign write SetPanelAlign default scpaLeft;
    property Panels: TSCStatusPanels read FPanels write SetPanels;
    property ParentColor default False;
    property ParentFont default False;
    property SimplePanel: Boolean read FSimplePanel write SetSimplePanel default False;
    property SimpleText: string read FSimpleText write SetSimpleText;
    property SizeGrip: Boolean read FSizeGrip write SetSizeGrip default True;
    property Style: TSCBarStyle read FStyle write SetStyle default scbsStatusWindows;
    property UseSystemFont: Boolean read FUseSystemFont write SetUseSystemFont default True;
    property OnDrawPanel: TSCDrawStatusEvent read FOnDrawPanel write FOnDrawPanel;
    property OnHint: TNotifyEvent read FOnHint write FOnHint;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function  ExecuteAction(Action: TBasicAction): Boolean; override;

    function  GetLastVisiblePanel: Integer;
    function  GetClickedPanel: Integer; dynamic;
    function  IsSizeGrip(X, Y: Integer): Boolean; dynamic;
    function  PanelAtPos(P: TPoint): Integer; dynamic;
    function  ClientToPanel(P: TPoint): TPoint;
    function  PanelRect(Panel: TSCStatusPanel): TRect;
  end;

  TSCStatusBar = class(TSCCustomStatusBar)
  published
    property Align;
    property Anchors;
    property AutoHint;
    property Color;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Hint;
    property Images;
    property LeftSpace;
    property PanelAlign;
    property Panels;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property SimplePanel;
    property SimpleText;
    property SizeGrip;
    property ShowHint;
    property Style;
    property Tag;
    property UseSystemFont;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnDblClick;
    property OnDrawPanel;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnHint;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCControlSizerStyle = (sccsWindows, sccsMac, sccsXP);

  TSCControlSizer = class(TSCCustomControl)
  private
    FStyle: TSCControlSizerStyle;
    procedure SetStyle(Value: TSCControlSizerStyle);
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMParentColorChanged(var Message: TWMNoParams); message CM_PARENTCOLORCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    procedure Paint; override;
    procedure DoDrawWinSizer(ACanvas: TCanvas); dynamic;
    procedure DoDrawMacSizer(ACanvas: TCanvas); dynamic;
    procedure DoDrawXPSizer(ACanvas: TCanvas); dynamic;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function  GetBlendValue: Word; override;

    property BlendColor default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property BorderProps;
    property Color default clBtnFace;
    property Cursor default crSizeNWSE;
    property ParentColor default False;
    property Style: TSCControlSizerStyle read FStyle write SetStyle default sccsWindows;
    property Transparent;
    property Visible;
  end;

implementation

const
  SC_SizeGripWidth = 16;
  SC_PanelSpace = 2;
  SC_MacSpace = 4;
  SC_SimpleLeft = 4;

type
  TWinControlFake = class(TWinControl);

{ TSCCustomStatusBar }

function TSCCustomStatusBar.CalculateImageRect(Panel: TSCStatusPanel;
  R: TRect): TRect;
begin
  Result := R;
  if (Panel = nil) or not (Panel.Style in [scpsAnimation,
    scpsImage, scpsImageAndText]) then
  begin
    Result.Right := Result.Left;
    Exit;
  end;

  InflateRect(Result, -2, 0);
  if Panel.Bevel in [scpb3DLowered, scpb3DRaised] then
    InflateRect(Result, -1, -1);

  if Result.Bottom < Result.Top then
    Result.Bottom := Result.Top;

  if Result.Right < Result.Left then
    Result.Right := Result.Left;
    
  if Images = nil then
  begin
    case Panel.Alignment of
      taLeftJustify, taCenter:
        Result.Right := Result.Left;
      taRightJustify:
        Result.Left := Result.Right;
    end;
    
    Exit;
  end;

  case Panel.Style of
    scpsAnimation:
    begin
      if not IsValidImage(Panel.CurAnimateIndex) or
        (Images.Width = 0) or (Images.Height = 0) then
      begin
        case Panel.Alignment of
          taLeftJustify, taCenter:
            Result.Right := Result.Left;
          taRightJustify:
            Result.Left := Result.Right;
        end;
        
        Exit;
      end;
    end;
    scpsImage, scpsImageAndText:
    begin
      if not IsValidImage(Panel.ImageIndex) or
        (Images.Width = 0) or (Images.Height = 0) then
      begin
        case Panel.Alignment of
          taLeftJustify, taCenter:
            Result.Right := Result.Left;
          taRightJustify:
            Result.Left := Result.Right;
        end;

        Exit;
      end;
    end;
  end;

  if Result.Bottom - Result.Top <> Images.Height then
  begin
    Inc(Result.Top,
      ((Result.Bottom - Result.Top) - Images.Height) div 2);
    Result.Bottom := Result.Top + Images.Height;
  end;

  if Result.Right - Result.Left > Images.Width then
  begin
    case Panel.Alignment of
      taLeftJustify:
        Result.Right := Result.Left + Images.Width;
      taRightJustify:
        Result.Left := Result.Right - Images.Width;
      taCenter:
      begin
        Inc(Result.Left,
          ((Result.Right - Result.Left) - Images.Width) div 2);
        Result.Right := Result.Left + Images.Width;
      end;
    end;
  end;

  if Result.Right < Result.Left then
    Result.Right := Result.Left;
  if Result.Bottom < Result.Top then
    Result.Bottom := Result.Top;
end;

function TSCCustomStatusBar.PanelRect(Panel: TSCStatusPanel): TRect;
var
  CRect: TRect;
  P: TSCStatusPanel;
  Pw, ExSpace, I, CLeft,
  CRight, VisibleCount: Integer;
begin
  CRect := ClientRect;
  Inc(CRect.Left, FLeftSpace);

  ExSpace := GetPanelSpace;

  case Style of
    scbsStatusWindows:
    begin
      Inc(CRect.Top, 2);
      if SizeGrip then Dec(CRect.Right, GetSizeGripWidth);
    end;
    scbsStatusMac:
    begin
      Dec(CRect.Right, GetSizeGripWidth + 4);
      Inc(CRect.Left, GetMacSpace);
      Inc(CRect.Top, 1);
      Dec(CRect.Bottom, 2);
    end;
    scbsStatusOffice12:
    begin
      if SizeGrip then Dec(CRect.Right, GetSizeGripWidth);
    end;
    scbsStatusXP:
    begin
      if SizeGrip then Dec(CRect.Right, GetSizeGripWidth);

      InflateRect(CRect, -2, -2);
      Inc(CRect.Top, 2);
    end;
    else begin
      Result := CRect;
      Exit;
    end;
  end;

  if IsRectEmpty(CRect) then
  begin
    with CRect do
    begin
      Bottom := Top;
      Right  := Left;
    end;

    Result := CRect;
    Exit;
  end;

  if SimplePanel or (Panel = nil) then
  begin
    Result := CRect;
    Exit;
  end;

  CLeft := CRect.Left;
  CRight := CRect.Right;

  VisibleCount := 0;
  for I := 0 to Panels.Count-1 do
    if Panels[I].Visible then
      Inc(VisibleCount);

  Canvas.Font := Self.Font;
  
  if FPanelAlign = scpaLeft then
  begin
    Result := CRect;

    for I := 0 to Panels.Count - 1 do
    begin
      P := Panels[I];
      Pw := P.Width;

      if (VisibleCount > 1) and (Pw > 0) and P.Visible and P.AutoSize and
        (P.Style in [scpsImageAndText, scpsText]) and (P.Text <> '') then
      begin
        Pw := Canvas.TextWidth(P.Text) + 4 + P.Indent;
        Inc(Pw, 4);

        if P.Bevel in [scpb3DLowered, scpb3DRaised] then
          Inc(Pw, 2);

        if Style = scbsStatusMac then
          Inc(Pw, GetMacSpace);

        if (P.Style = scpsImageAndText) and IsValidImage(P.ImageIndex) then
          Inc(Pw, Images.Width);
      end;

      if P = Panel then
      begin
        if Panel.Index < Panels.Count-1 then
          CRect.Right := CRect.Left + Pw;

        Break;
      end;

      Inc(CRect.Left, GetPanelSpacing + ExSpace + Pw);

      if CRect.Left >= CRect.Right then
      begin
        CRect.Left := CRect.Right;
        Break;
      end;
    end;

    if CRect.Right > CRight then
      CRect.Right := CRight;

    Result := CRect;
  end else
  begin
    Result := CRect;
    
    for I := Panels.Count - 1 downto 0 do
    begin
      P := Panels[I];
      Pw := P.Width;

      if (VisibleCount > 1) and (Pw > 0) and P.Visible and P.AutoSize and
        (P.Style in [scpsImageAndText, scpsText]) and (P.Text <> '') then
      begin
        Pw := Canvas.TextWidth(P.Text) + 4 + P.Indent;
        Inc(Pw, 4);

        if P.Bevel in [scpb3DLowered, scpb3DRaised] then
          Inc(Pw, 2);

        if Style = scbsStatusMac then
          Inc(Pw, GetMacSpace);

        if (P.Style = scpsImageAndText) and IsValidImage(P.ImageIndex) then
          Inc(Pw, Images.Width);
      end;

      if P = Panel then
      begin
        if Panel.Index > 0 then
          CRect.Left := CRect.Right - Pw;
          
        Break;
      end;

      Dec(CRect.Right, GetPanelSpacing + ExSpace + Pw);

      if CRect.Left >= CRect.Right then
      begin
        CRect.Left := CRect.Right;
        Break;
      end;
    end;

    if CRect.Left < CLeft then
      CRect.Left := CLeft;

    Result := CRect;
  end;

  if Result.Right < Result.Left then
    Result.Right := Result.Left;
end;

function TSCCustomStatusBar.ClientToPanel(P: TPoint): TPoint;
var
  Pnl: Integer;
  R: TRect;
begin
  Result := P;
  Pnl := PanelAtPos(P);
  if (Pnl > -1) and (Pnl < Panels.Count) then
  begin
    R := PanelRect(Panels[Pnl]);
    Result.X := P.X - R.Left;
    Result.Y := P.Y - R.Top;
  end;
end;

procedure TSCCustomStatusBar.CMColorChanged(var Message: TMessage);
begin
  inherited;
  UpdatePanelColors(Canvas.Brush.Color);
  Invalidate;
end;

procedure TSCCustomStatusBar.CMHintShow(var Message: TMessage);
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
    Indx := PanelAtPos(P);
    if (Indx > -1) and (Indx < Panels.Count) then
    begin
      HintInfo.CursorRect := PanelRect(Panels[Indx]);
      if (Panels[Indx].Hint = '') or
        not (Panels[Indx].Visible and Panels[Indx].Enabled) then
      begin
        HintInfo.HintStr := EmptyHint;
        Result := 1;
      end else
        HintInfo.HintStr := Panels[Indx].Hint;
    end else
    if IsSizeGrip(P.X, P.Y) then
    begin
      HintInfo.CursorRect := SizerRect;
      HintInfo.HintStr := EmptyHint;
      Result := 1;
    end else
    begin
      Indx := PanelAtPos(Point(P.X + 1, P.Y));

      if (Indx > -1) and (Indx < Panels.Count) then
      begin
        HRect := ClientRect;
        HRect.Left  := P.X - 1;
        HRect.Right := P.X + 1;
        HintInfo.CursorRect := HRect;
      end else
      begin
        Indx := PanelAtPos(Point(P.X - 1, P.Y));

        if (Indx > -1) and (Indx < Panels.Count) then
        begin
          HRect := ClientRect;
          HRect.Left  := P.X;
          HRect.Right := P.X + 2;
          HintInfo.CursorRect := HRect;
        end else
        begin
          HRect := ClientRect;
          HRect.Bottom := HRect.Top + 2;

          if (Self.Style = scbsStatusMac) or (Self.SizeGrip and
            (Self.Style in [scbsStatusOffice12, scbsStatusWindows, scbsStatusXP])) then
            Dec(HRect.Right, GetSizeGripWidth);

          if (HRect.Right > HRect.Left) and PtInRect(HRect, P) then
            HintInfo.CursorRect := HRect;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomStatusBar.CMParentColorChanged(var Message: TMessage);
begin
  inherited;
  if ParentColor then
  begin
    UpdatePanelColors(Canvas.Brush.Color);
    Invalidate;
  end;
end;

procedure TSCCustomStatusBar.CMParentFontChanged(var Message: TMessage);
begin
  inherited;
  if FUseSystemFont and ParentFont then FUseSystemFont := False;
end;

procedure TSCCustomStatusBar.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  UpdatePanelColors(Canvas.Brush.Color);
  Invalidate;
end;

procedure TSCCustomStatusBar.CMSysFontChanged(var Message: TMessage);
begin
  inherited;
  SyncToSystemFont;
end;

procedure TSCCustomStatusBar.CMWinIniChange(var Message: TMessage);
begin
  inherited;
  if (Message.WParam = 0) or (Message.WParam = SPI_SETNONCLIENTMETRICS) then
    SyncToSystemFont;
end;

constructor TSCCustomStatusBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  DoubleBuffered := True;
  Color := clBtnFace;
  ParentColor := False;
  ParentFont := False;
  Height := 19;
  Align := alBottom;

  FPanelAlign := scpaLeft;
  FOldCursor := Cursor;
  FMouseDownPanel := -1;
  FPanels := TSCStatusPanels.Create(Self);
  FSizeGrip := True;
  ParentFont := False;
  FUseSystemFont := True;
  FStyle := scbsStatusWindows;
  SyncToSystemFont;
end;

destructor TSCCustomStatusBar.Destroy;
begin
  FreeAndNil(FPanels);
  inherited Destroy;
end;

function TSCCustomStatusBar.DoHint: Boolean;
begin
  Result := False;
  if Assigned(FOnHint) then
  begin
    FOnHint(Self);
    Result := True;
  end;
end;

procedure TSCCustomStatusBar.DoDrawAnimatePanel(Panel: TSCStatusPanel;
  PanelCanvas: TCanvas; const R: TRect);
var
  R2: TRect;
begin
  if (Panel = nil) or not Panel.Visible or (Images = nil) or
    (Panel.Flash and not Panel.Showing) then
    Exit;

  R2 := R;
  R2 := CalculateImageRect(Panel, R2);

  if (Panel.CurAnimateIndex = -1) or
    (Panel.CurAnimateIndex > Images.Count-1) or
    (R2.Right <= R2.Left) or (R2.Bottom <= R2.Top) then Exit;

  Images.Draw(PanelCanvas, R2.Left, R2.Top,
    Panel.CurAnimateIndex, Panel.Enabled and Enabled);
end;

procedure TSCCustomStatusBar.DoDrawGaugePanel(Panel: TSCStatusPanel;
  PanelCanvas: TCanvas; const R: TRect);
var
  Text: String;
  R1, R2, R3: TRect;
  I, PW, Range,
  BasePos, Slice, SliceCnt: Integer;
  BrushStyle: TBrushStyle;
  Cs, Ce, C1, C2,
  BrushColor, PenColor: TColor;
  DoSlice, IsGradient: Boolean;
begin
  if (Panel = nil) or not Panel.Visible or SimplePanel or
    (Panel.Flash and not Panel.Showing) then
    Exit;

  with Panel.Gauge do
  begin
    Cs := Color;
    if Cs = clNone then Cs := Panel.Color;

    Ce := EndColor;
    if Ce = clNone then Ce := Cs;

    DoSlice := FStyle in [scsgSliced, scsgSlicedGradient, scsgXP];
    IsGradient := (Cs <> Ce) and (FStyle in [scsg3d, scsgXP,
      scsgSlicedGradient, scsgGradient]);

    Range   := FMax - FMin;
    BasePos := FPosition - FMin;
  end;

  with PanelCanvas do
  begin
    R2 := R;

    InflateRect(R2, -1, -1);
    if Panel.Bevel in [scpb3DLowered, scpb3DRaised] then
      InflateRect(R2, -1, -1);

    PW := 0;
    if not ((Range = 0) or (BasePos > Range) or (BasePos < 0)) then
      PW := Round((R2.Right - R2.Left) * (BasePos/Range));

    case Panel.Alignment of
      taLeftJustify:
        R2.Right := R2.Left + PW;
      taRightJustify:
        R2.Left := R2.Right - PW;
      taCenter:
      begin
        Inc(R2.Left, ((R2.Right - R2.Left) - PW) div 2);
        R2.Right := R2.Left + PW;
      end;
    end;

    if R2.Right > R.Right - 1 then
      R2.Right := R.Right - 1;

    if R2.Left < R.Left + 1 then
      R2.Left := R.Left + 1;

    if R2.Right < R2.Left then
      R2.Right := R2.Left;

    BrushStyle  := Brush.Style;
    BrushColor  := Brush.Color;
    PenColor := Pen.Color;

    try
      Brush.Style := bsSolid;
      Brush.Color := Cs;
      Pen.Color   := Cs;

      FillRect(R2);

      if not IsGradient then
      begin
        R1 := R2;

        if Panel.Gauge.FStyle = scsgRaised then
        begin
          C1 := SCCommon.scBlendColor(Cs, 64);
          C2 := SCCommon.scBlendColor(Cs, -64);

          scFrame3D(PanelCanvas, R1, C1, C2, 1, 0);
        end;
      end else
      begin
        case Panel.Gauge.FStyle of
          scsg3d, scsgGradient:
          begin
            R1 := R2;
            R1.Bottom := R1.Top + Round((R1.Bottom - R1.Top) / 2);

            if not IsRectEmpty(R1) then
            begin
              C1 := SCCommon.scBlendColor(Cs, 64);
              scDrawGradient(PanelCanvas, R1, scgTopToBottom, C1, Cs);

              R1 := R2;
              R1.Top := R1.Bottom - Round((R1.Bottom - R1.Top) / 2);

              C2 := SCCommon.scBlendColor(Cs, -64);
              scDrawGradient(PanelCanvas, R1, scgTopToBottom, Cs, C2);

              if Panel.Gauge.FStyle = scsg3D then
              begin
                R1 := R2;
                scFrame3D(PanelCanvas, R1, C1, C2, 1, 0);

                C1 := SCCommon.scBlendColor(Cs, 48);
                C2 := SCCommon.scBlendColor(Cs, -48);

                scFrame3D(PanelCanvas, R1, C1, C2, 1, 0);
              end;
            end;
          end;
          scsgSlicedGradient:
          begin
            R1 := R2;
            scDrawGradient(PanelCanvas, R1, scgLeftToRight, Cs, Ce);
          end;
          scsgXP:
          begin
            R1 := R2;
            R1.Bottom := R1.Top + ((R1.Bottom - R1.Top) div 2);

            if not IsRectEmpty(R1) then
            begin
              C1 := SCCommon.scBlendColor(Cs, 128);
              scDrawGradient(PanelCanvas, R1, scgTopToBottom, C1, Cs);

              R1 := R2;
              R1.Top := R1.Bottom - ((R1.Bottom - R1.Top) div 2);

              scDrawGradient(PanelCanvas, R1, scgTopToBottom, Cs, C1);
            end;
          end;
        end;
      end;

      if DoSlice then
      begin
        Slice := 3*((R2.Bottom - R2.Top) div 4);

        with Panel.Gauge, PanelCanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := Panel.Color;

          if (PW > 0) and (Slice > 0) and
            (FPosition > FMin) then
          begin
            SliceCnt := PW div (Slice + 2);

            if Panel.Alignment in [taLeftJustify, taCenter] then
            begin
              R3 := R2;
              R3.Right := R3.Left + 2;

              for I := 0 to SliceCnt-1 do
              begin
                OffsetRect(R3, Slice, 0);
                FillRect(R3);

                OffsetRect(R3, R3.Right - R3.Left, 0);
              end;
            end else
            begin
              R3 := R2;
              R3.Left := R3.Right - 2;

              for I := 0 to SliceCnt-1 do
              begin
                OffsetRect(R3, -Slice, 0);
                FillRect(R3);

                OffsetRect(R3, -(R3.Right - R3.Left), 0);
              end;
            end;
          end;
        end;
      end;

      Text := Panel.Gauge.Caption;
      if Trim(Text) <> '' then
      begin
        R2 := R;
        InflateRect(R2, -1, -1);

        Brush.Style := bsClear;
        DrawText(Handle, PChar(Text), Length(Text), R2,
          DT_SINGLELINE or DT_VCENTER or DT_CENTER);
      end;
    finally
      Brush.Color := BrushColor;
      Brush.Style := BrushStyle;
      Pen.Color   := PenColor;
    end;  
  end;
end;

procedure TSCCustomStatusBar.DoDrawImagePanel(Panel: TSCStatusPanel;
  PanelCanvas: TCanvas; const R: TRect);
var
  R2: TRect;
begin
  if (Panel = nil) or not Panel.Visible or (Images = nil) or
    (Panel.Flash and not Panel.Showing) then
    Exit;

  R2 := R;
  R2 := CalculateImageRect(Panel, R2);

  if (R2.Left > R2.Right) or (R2.Top > R2.Bottom) or
    not IsValidImage(Panel.ImageIndex) then
    Exit;

  Images.Draw(PanelCanvas, R2.Left, R2.Top,
    Panel.ImageIndex, Panel.Enabled and Enabled);
end;

procedure TSCCustomStatusBar.DoDrawMacBorder(ACanvas: TCanvas);
var
  R: TRect;
  C: TColor;
  Cl: TColor;
  OldPen: TPen;
begin
  R := ClientRect;

  Dec(R.Right, GetSizeGripWidth + 1);
  Inc(R.Top, 1);
  OffsetRect(R, -1, 0);

  Cl := GetDefaultBackColor;
  
  if R.Right > R.Left then
  begin
    C := GetBtnHighlightOf(Cl);
    scFrame3D(ACanvas, R, C, C, 1, 0);
  end;

  R := ClientRect;
  Dec(R.Right, GetSizeGripWidth + 3);
  Dec(R.Bottom, 1);

  if R.Right > R.Left then
  begin
    C := Get3DDkShadowOf(Cl);
    scFrame3D(ACanvas, R, C, C, 1, 0);
  end;

  R := ClientRect;
  Dec(R.Right, GetSizeGripWidth + 4);
  Dec(R.Bottom, 3);

  OldPen := TPen.Create;
  OldPen.Assign(ACanvas.Pen);

  try
    with ACanvas, Pen do
    begin
      Color := Cl;
      Width := 1;
      Style := psSolid;
      Mode  := pmCopy;

      MoveTo(1, R.Bottom);
      LineTo(R.Right, R.Bottom);
      
      MoveTo(R.Right - 1, R.Top + 2);
      LineTo(R.Right - 1, R.Bottom);
    end;
  finally
    ACanvas.Pen.Assign(OldPen);
  end;
end;

procedure TSCCustomStatusBar.DoDrawOffice12Border(ACanvas: TCanvas);
begin

end;

procedure TSCCustomStatusBar.DoDrawXPBorder(ACanvas: TCanvas);
var
  R: TRect;
  C, Cl: TColor;
  I, Y: Integer;
  OldPen: TPen;
begin
  R := ClientRect;
  if IsRectEmpty(R) then Exit;

  OldPen := TPen.Create;
  try
    OldPen.Assign(ACanvas.Pen);

    with ACanvas do
    begin
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Width := 1;

      Cl := GetDefaultBackColor;

      C := Cl;
      Y := R.Top + 3;

      for I := 0 to 3 do
      begin
        C := SCCommon.scBlendColor(C, -8*(I + 1));
        Pen.Color := C;

        MoveTo(R.Left,  Y);
        LineTo(R.Right, Y);

        Dec(Y);
      end;

      Pen.Color := SCCommon.scBlendColor(Cl, -24);

      MoveTo(R.Left,  R.Bottom - 1);
      LineTo(R.Right, R.Bottom - 1);
    end;
  finally
    ACanvas.Pen.Assign(OldPen);
    OldPen.Free;
  end;
end;

procedure TSCCustomStatusBar.DoDrawOffice12Sizer(ACanvas: TCanvas);

  procedure DrawSizerPoint(C: TCanvas; Cl: TColor; R: TRect);
  begin
    with C do
    begin
      Brush.Color := scBlendColor(Cl, 32);
      FillRect(R);

      OffsetRect(R, -1, -1);

      Brush.Color := scBlendColor(Cl, -64);
      FillRect(R);
    end;
  end;

var
  Cl: TColor;
  R, R1, R2: TRect;
  SizerBmp: TBitmap;
begin
  R := ClientRect;
  R.Left := R.Right - GetSizeGripWidth;

  if IsRectEmpty(R) then
    Exit;

  SizerBmp := TBitmap.Create;
  try
    R1 := R;
    OffsetRect(R1, -R1.Left, -R1.Top);

    with SizerBmp do
    begin
      Width := R1.Right;
      Height := R1.Bottom;
    end;

    Cl := GetDefaultBackColor;

    with SizerBmp.Canvas do
    begin
      Brush.Color := Cl;
      Brush.Style := bsSolid;

      FillRect(R1);
    end;

    if FStyle = scbsStatusOffice12 then
      DrawOffice12Face(SizerBmp.Canvas, R1);

    R2 := Rect(0, 0, 2, 2);
    OffsetRect(R2, R1.Right - 2, R1.Bottom - 2);
    DrawSizerPoint(SizerBmp.Canvas, Cl, R2);

    R2 := Rect(0, 0, 2, 2);
    OffsetRect(R2, R1.Right - 6, R1.Bottom - 2);
    DrawSizerPoint(SizerBmp.Canvas, Cl, R2);

    R2 := Rect(0, 0, 2, 2);
    OffsetRect(R2, R1.Right - 10, R1.Bottom - 2);
    DrawSizerPoint(SizerBmp.Canvas, Cl, R2);

    R2 := Rect(0, 0, 2, 2);
    OffsetRect(R2, R1.Right - 2, R1.Bottom - 6);
    DrawSizerPoint(SizerBmp.Canvas, Cl, R2);

    R2 := Rect(0, 0, 2, 2);
    OffsetRect(R2, R1.Right - 2, R1.Bottom - 10);
    DrawSizerPoint(SizerBmp.Canvas, Cl, R2);

    R2 := Rect(0, 0, 2, 2);
    OffsetRect(R2, R1.Right - 6, R1.Bottom - 6);
    DrawSizerPoint(SizerBmp.Canvas, Cl, R2);

    ACanvas.Draw(R.Left, R.Top, SizerBmp);
  finally
    SizerBmp.Free;
  end;
end;

procedure TSCCustomStatusBar.DoDrawXPSizer(ACanvas: TCanvas);

  procedure DrawSizerPoint(C: TCanvas; R: TRect);
  begin
    with C do
    begin
      FillRect(R);

      MoveTo(R.Right - 1, R.Top);
      LineTo(R.Right - 2, R.Top);
    end;
  end;

var
  R1, R2, R3: TRect;
  SizerBmp: TBitmap;
  Cl, C1, C2: TColor;
begin
  R1 := ClientRect;
  R1.Left := R1.Right - GetSizeGripWidth;
  if IsRectEmpty(R1) then Exit;

  SizerBmp := TBitmap.Create;
  try
    R2 := R1;
    OffsetRect(R2, -R2.Left, -R2.Top);

    with SizerBmp do
    begin
      Height := R2.Bottom - R2.Top;
      Width := R2.Right - R2.Left;
    end;

    Cl := GetDefaultBackColor;
    
    with SizerBmp.Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      FillRect(R2);

      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;

      C1 := GetBtnShadowOf(Cl);
      C1 := SCCommon.scBlendColor(C1, 32);

      C2 := Get3DDkShadowOf(Cl);
      C2 := SCCommon.scBlendColor(C2, 16);

      Pen.Color := C2;
      Brush.Color := C1;

      R3 := Rect(0, 0, 2, 2);
      OffsetRect(R3, R2.Right - 6, R2.Bottom - 6);
      DrawSizerPoint(SizerBmp.Canvas, R3);

      R3 := Rect(0, 0, 2, 2);
      OffsetRect(R3, R2.Right - 10, R2.Bottom - 6);
      DrawSizerPoint(SizerBmp.Canvas, R3);

      R3 := Rect(0, 0, 2, 2);
      OffsetRect(R3, R2.Right - 14, R2.Bottom - 6);
      DrawSizerPoint(SizerBmp.Canvas, R3);

      R3 := Rect(0, 0, 2, 2);
      OffsetRect(R3, R2.Right - 6, R2.Bottom - 10);
      DrawSizerPoint(SizerBmp.Canvas, R3);

      R3 := Rect(0, 0, 2, 2);
      OffsetRect(R3, R2.Right - 6, R2.Bottom - 14);
      DrawSizerPoint(SizerBmp.Canvas, R3);

      R3 := Rect(0, 0, 2, 2);
      OffsetRect(R3, R2.Right - 10, R2.Bottom - 10);
      DrawSizerPoint(SizerBmp.Canvas, R3);
    end;

    ACanvas.Draw(R1.Left, R1.Top, SizerBmp);
  finally
    SizerBmp.Free;
  end;
end;

procedure TSCCustomStatusBar.DoDrawMacSizer(ACanvas: TCanvas);
var
  R, R2: TRect;
  SizerBmp: TBitmap;
  Cl, C1, C2: TColor;
  I, Dif, Step: Integer;
begin
  R := ClientRect;
  R.Left := R.Right - GetSizeGripWidth;
  if IsRectEmpty(R) then Exit;

  SizerBmp := TBitmap.Create;
  try
    R2 := R;
    OffsetRect(R2, -R2.Left, -R2.Top);

    with SizerBmp do
    begin
      Height := R2.Bottom - R2.Top;
      Width  := R2.Right - R2.Left;
    end;

    Cl := GetDefaultBackColor;

    C1 := GetBtnShadowOf(Cl);
    C2 := GetBtnHighlightOf(Cl);

    with SizerBmp.Canvas do
    begin
      Brush.Color := Cl;
      FillRect(R2);

      Inc(R2.Top, (((R2.Bottom - R2.Top) - GetSizeGripWidth) div 2));
      R2.Bottom := R2.Top + GetSizeGripWidth;

      InflateRect(R2, -5, -5);
      OffsetRect(R2, 1, 2);

      Dif := 6;
      Step := 0;
      for I := 0 to 2 do
      begin
        Pen.Color := C1;
        MoveTo(R2.Right - Dif,  R2.Bottom - Step);
        LineTo(R2.Right - Step, R2.Bottom - Dif);

        Pen.Color := C2;
        MoveTo(R2.Right - (Dif + 1),  R2.Bottom - (Step + 1));
        LineTo(R2.Right - (Step + 1), R2.Bottom - (Dif + 1));

        Pen.Color := BlendedColor(C1, 24, 24, 24, True);
        MoveTo(R2.Right - (Dif + 1), R2.Bottom - Step);
        LineTo(R2.Right - (Dif + 1), R2.Bottom - Step - 1);

        Pen.Color := C2;
        MoveTo(R2.Right - (Step + 1), R2.Bottom - Dif);
        LineTo(R2.Right - (Step + 2), R2.Bottom - Dif);
        
        Inc(Dif,  2);
        Inc(Step, 2);
      end;
    end;
    
    ACanvas.Draw(R.Left, R.Top, SizerBmp);
  finally
    SizerBmp.Free;
  end;
end;

procedure TSCCustomStatusBar.DoDrawSpace(PanelCanvas: TCanvas;
  const R: TRect);
begin
  if not IsRectEmpty(R) then
  begin
    if FStyle = scbsStatusOffice12 then
      DrawOffice12Face(PanelCanvas, R);
  end;
end;

procedure TSCCustomStatusBar.DoDrawPanel(Panel: TSCStatusPanel;
  PanelCanvas: TCanvas; const R: TRect);
var
  R2: TRect;
  FC, PC, C: TColor;
begin
  with PanelCanvas do
  begin
    R2 := R;
    OffsetRect(R2, -R2.Left, -R2.Top);

    PC := GetDefaultBackColor;

    C := PC;
    if not SimplePanel and (Panel <> nil) and Panel.Visible then
      C := Panel.Color;

    if C = clNone then C := PC;

    Brush.Color := C;
    FillRect(R2);

    if FStyle = scbsStatusOffice12 then
      DrawOffice12Face(PanelCanvas, R);

    Font.Assign(Self.Font);

    FC := Self.Font.Color;
    if FC = clNone then FC := clWindowText;

    if not SimplePanel and (Panel <> nil) then
    begin
      if not (Self.Enabled and Panel.Enabled) then
      begin
        FC := clGrayText;
        if C <> clNone then FC := GetBtnShadowOf(C);
      end else
      if Panel.FontColor <> clNone then
        FC := Panel.FontColor;
    end;

    Font.Color := FC;

    if SimplePanel then
    begin
      Inc(R2.Left, GetSimpleLeft);
      DoDrawTextPanel(Panel, PanelCanvas, R2);
      
      Exit;
    end;

    if not Panel.Visible then Exit;

    R2 := R;
    if (Panel.Style = scpsOwnerDraw) and Assigned(FOnDrawPanel) then
       FOnDrawPanel(Self, Panel, PanelCanvas, R2)
    else begin
      case Panel.Style of
        scpsControl:
        begin
          //
        end;
        scpsGauge:
        begin
          InflateRect(R2, -1, -1);
          DoDrawGaugePanel(Panel, PanelCanvas, R2);
        end;
        scpsText:
        begin
          InflateRect(R2, -1, -1);
          DoDrawTextPanel(Panel, PanelCanvas, R2);
        end;
        scpsAnimation:
        begin
          InflateRect(R2, -1, 0);
          DoDrawAnimatePanel(Panel, PanelCanvas, R2);
        end;
        scpsImage:
        begin
          InflateRect(R2, -1, 0);
          DoDrawImagePanel(Panel, PanelCanvas, R2);
        end;
        scpsImageAndText:
        begin
          InflateRect(R2, -1, 0);
          DoDrawImagePanel(Panel, PanelCanvas, R2);

          if Panel.Alignment <> taCenter then
          begin
            R2 := R;
            InflateRect(R2, -1, 0);

            R2 := CalculateImageRect(Panel, R2);
            R2.Top := R.Top;
            R2.Bottom := R.Bottom;

            InflateRect(R2, 0, -1);
            case Panel.Alignment of
              taLeftJustify:
              begin
                R2.Left := R2.Right;
                R2.Right := R.Right;
                DoDrawTextPanel(Panel, PanelCanvas, R2);
              end;
              taRightJustify:
              begin
                R2.Right := R2.Left;
                R2.Left := R.Left;
                DoDrawTextPanel(Panel, PanelCanvas, R2);
              end;
            end;
          end;  
        end;
      end;
    end;

    R2 := R;
    DoDrawPanelBorder(Panel, PanelCanvas, R2);
  end;
end;

procedure TSCCustomStatusBar.DoDrawPanelBorder(Panel: TSCStatusPanel;
  PanelCanvas: TCanvas; const R: TRect);
var
  R2: TRect;
  Cl: TColor;
begin
  if (Panel = nil) or not Panel.Visible or IsRectEmpty(R) then
    Exit;

  R2 := R;
  Cl := GetDefaultBackColor;
  
  if (Panel.Bevel <> scpbNone) and (R2.Right - R2.Left = 1) then
  begin
    scFrame3D(PanelCanvas, R2, Cl, Cl, 1, 0);
    Exit;
  end;

  if Self.Style in [scbsStatusWindows, scbsStatusXP] then
  begin
    case Panel.Bevel of
      scpbNone: ;
      scpbLowered:
        scFrame3D(PanelCanvas, R2, clBtnShadow, clBtnHighlight, 1, 0);
      scpbRaised:
        scFrame3D(PanelCanvas, R2, clBtnHighlight, clBtnShadow, 1, 0);
      scpbFlat:
        scFrame3D(PanelCanvas, R2, Panel.BorderColor, Panel.BorderColor, 1, 0);
      scpb3DLowered:
      begin
        scFrame3D(PanelCanvas, R2, clBtnShadow, clBtnHighlight, 1, 0);
        scFrame3D(PanelCanvas, R2, cl3DDkShadow, clBtnFace, 1, 0);
      end;
      scpb3DRaised:
      begin
        scFrame3D(PanelCanvas, R2, clBtnHighlight, cl3DDkShadow, 1, 0);
        scFrame3D(PanelCanvas, R2, clBtnFace, clBtnShadow, 1, 0);
      end;
    end;
  end;
end;

procedure TSCCustomStatusBar.DoDrawTextPanel(Panel: TSCStatusPanel;
  PanelCanvas: TCanvas; const R: TRect);
const
  AlignType: array[TAlignment] of DWORD = (DT_LEFT, DT_RIGHT, DT_CENTER);
  EllipsisFlags: array [Boolean] of Integer = (0, DT_END_ELLIPSIS);
var
  R2: TRect;
  BrushStyle: TBrushStyle;
begin
  if not SimplePanel and ((Panel = nil) or
    not Panel.Visible or (Panel.Flash and not Panel.Showing)) then
    Exit;

  R2 := R;
  InflateRect(R2, -2, 0);
  if (Panel <> nil) and (Panel.Bevel in [scpb3DLowered, scpb3DRaised]) then
    InflateRect(R2, -1, -1);

  if Style = scbsStatusMac then
  begin
    Dec(R2.Right, GetMacSpace);
    if SimplePanel then
      Inc(R2.Left, GetMacSpace);
  end;

  if IsRectEmpty(R2) then
    Exit;

  with PanelCanvas do
  begin
    BrushStyle := Brush.Style;
    Brush.Style := bsClear;

    if SimplePanel then
      DrawText(Handle, PChar(SimpleText), Length(SimpleText),
        R2, DT_SINGLELINE or DT_VCENTER or EllipsisFlags[True])
    else
    begin
      DrawText(Handle, PChar(Panel.Text), Length(Panel.Text), R2,
        DT_SINGLELINE or DT_VCENTER or DWord(EllipsisFlags[Panel.EndEllipsis]) or
        AlignType[Panel.Alignment]);
    end;

    Brush.Style := BrushStyle;
  end;
end;

procedure TSCCustomStatusBar.DoDrawWinSizer(ACanvas: TCanvas);
var
  R, R2: TRect;
  I, Dif: Integer;
  SizerBmp: TBitmap;
  Cl, C1, C2: TColor;
begin
  R := ClientRect;
  R.Left := R.Right - GetSizeGripWidth;
  if IsRectEmpty(R) then Exit;

  SizerBmp := TBitmap.Create;
  try
    R2 := R;
    OffsetRect(R2, -R2.Left, -R2.Top);

    with SizerBmp do
    begin
      Height := R2.Bottom;
      Width  := R2.Right;
    end;

    Cl := GetDefaultBackColor;

    C1 := GetBtnShadowOf(Cl);
    C2 := GetBtnHighlightOf(Cl);

    with SizerBmp.Canvas do
    begin
      Brush.Color := Cl;
      FillRect(R2);

      Dif := 3;
      for I := 0 to 2 do
      begin
        Pen.Color := C1;
        MoveTo(R2.Right - Dif, R2.Bottom);
        LineTo(R2.Right, R2.Bottom - Dif);

        MoveTo(R2.Right - (Dif + 1), R2.Bottom);
        LineTo(R2.Right, R2.Bottom - (Dif + 1));

        Pen.Color := C2;
        MoveTo(R2.Right -( Dif + 2), R2.Bottom);
        LineTo(R2.Right, R2.Bottom - (Dif + 2));

        Inc(Dif, 4);
      end;
    end;
    
    ACanvas.Draw(R.Left, R.Top, SizerBmp);
  finally
    SizerBmp.Free;
  end;
end;

function TSCCustomStatusBar.ExecuteAction(Action: TBasicAction): Boolean;
begin
  if AutoHint and (Action is THintAction) and not DoHint then
  begin
    Result := True;
    if SimplePanel or (Panels.Count = 0) then
      SimpleText := THintAction(Action).Hint
    else
      Panels[0].Text := THintAction(Action).Hint;
  end else
    Result := inherited ExecuteAction(Action);
end;

function TSCCustomStatusBar.GetClickedPanel: Integer;
var
  P: TPoint;
begin
  Result := -1;

  if GetCursorPos(P) then
  begin
    P := ScreenToClient(P);
    Result := PanelAtPos(P);

    if (Result < 0) and IsSizeGrip(P.X, P.Y) then
      Result := -2
    else
    if (Result > -1) and not Panels[Result].Enabled then
      Result := -3;
  end;    
end;

function TSCCustomStatusBar.GetMacClientWidth: Integer;
begin
  Result := ClientWidth - (GetSizeGripWidth + 4);
end;

function TSCCustomStatusBar.IsSizeGrip(X, Y: Integer): Boolean;
var
  R: TRect;
begin
  R := SizerRect;
  Result := SizeGrip and PtInRect(R, Point(X, Y));
end;

procedure TSCCustomStatusBar.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  P: TPoint;
  ClickedPanel: Integer;
  DoInherit: Boolean;
begin
  DoInherit := True;

  P := Point(X, Y);
  ClickedPanel := PanelAtPos(P);
  if ClickedPanel > Panels.Count then
    ClickedPanel := -1;

  FSzGripClick := False;

  if (ClickedPanel > -1) and not Panels[ClickedPanel].Enabled then
  begin
    FPanelDblClicked := False;
    FMouseDownPanel := -1;

    Exit;
  end;

  if ClickedPanel < 0 then
  begin
    FPanelDblClicked := False;

    if IsSizeGrip(X, Y) and (Parent <> nil) and (Align <> alNone) then
    begin
      DoInherit := False;

      ReleaseCapture;

      FSzGripClick := True;
      SendMessage(Parent.Handle, WM_NCLBUTTONDOWN, HTBOTTOMRIGHT, 0);
    end;
  end else
  begin
    if(Button = mbLeft) and (ssDouble in Shift) and
      (ClickedPanel = FMouseDownPanel) then
    begin
      FPanelDblClicked := True;

      if Assigned(Panels[ClickedPanel].OnDblClick) then
        Panels[ClickedPanel].OnDblClick(Panels[ClickedPanel]);
    end else
      FPanelDblClicked := False;

    if Assigned(Panels[ClickedPanel].OnMouseDown) then
    begin
      DoInherit := False;

      P := ClientToPanel(P);
      Panels[ClickedPanel].OnMouseDown(Panels[ClickedPanel],
        Button, Shift, P.x, P.y);
    end;
  end;

  FMouseDownPanel := ClickedPanel;

  if FSzGripClick then
  begin
    FSzGripClick := False;

    if (Parent <> nil) then
    begin
      R := Parent.ClientRect;
      TWinControlFake(Parent).AdjustClientRect(R);

      if R.Right < R.Left then R.Right := R.Left;
      if R.Bottom < R.Top then R.Bottom := R.Top;

      if Self.Align in [alTop, alBottom] then
      begin
        if (R.Right - R.Left <> Self.Width) or (R.Left <> Self.Left) or
          (R.Right <> Self.Width + Self.Left) then
          Parent.Realign;
      end else
      if (Self.Align in [alLeft, alRight]) and
        ((R.Bottom - R.Top <> Self.Height) or (R.Top <> Self.Top) or
        (R.Bottom <> Self.Top + Self.Height)) then
        Parent.Realign;
    end;
  end;

  if DoInherit then
    inherited MouseDown(Button, Shift, X, Y);
end;

procedure TSCCustomStatusBar.MouseMove(Shift: TShiftState; X, Y: Integer);

  procedure SetPanelCursor(Ax, Ay: Integer);
  begin
    if IsSizeGrip(Ax, Ay) then
    begin
      if (Cursor <> crSizeNWSE) then
      begin
        FOldCursor := Cursor;
        Cursor := crSizeNWSE;
      end;
    end else
      if Cursor = crSizeNWSE then
        Cursor := FOldCursor;
  end;

var
  P: TPoint;
  DoInherit: Boolean;
  MsMovedPanel: Integer;
begin
  DoInherit := True;

  P := Point(X, Y);
  if FMouseDownPanel < 0 then
  begin
    MsMovedPanel := PanelAtPos(P);
    SetPanelCursor(X, Y);

    if (MsMovedPanel > -1) and (MsMovedPanel < Panels.Count) and
      Assigned(Panels[MsMovedPanel].OnMouseMove) then
    begin
      DoInherit := False;

      P := ClientToPanel(P);
      Panels[MsMovedPanel].OnMouseMove(Panels[MsMovedPanel],
        Shift, P.X, P.Y);
    end;
  end else
  if (FMouseDownPanel > -1) and (FMouseDownPanel < Panels.Count) and
    Panels[FMouseDownPanel].Enabled and Assigned(Panels[FMouseDownPanel].OnMouseMove) then
  begin
    DoInherit := False;

    P := ClientToPanel(P);
    Panels[FMouseDownPanel].OnMouseMove(Panels[FMouseDownPanel],
      Shift, X, Y);
  end;

  if DoInherit then
    inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomStatusBar.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  DoInherit: Boolean;
  ClickedPanel: Integer;
begin
  DoInherit := True;

  if FMouseDownPanel < 0 then
    FPanelDblClicked := False
  else
  if FMouseDownPanel < Panels.Count then
  begin
    if not Panels[FMouseDownPanel].Enabled then
    begin
      FPanelDblClicked := False;
      FMouseDownPanel := -1;

      Exit;
    end;

    P := Point(X, Y);
    ClickedPanel := PanelAtPos(P);
    if ClickedPanel > Panels.Count then
      ClickedPanel := -1;

    if (ClickedPanel > -1) and (ClickedPanel = FMouseDownPanel) then
    begin
      if Button = mbLeft then
      begin
        if FPanelDblClicked then
        begin
          FMouseDownPanel := -1;
          FPanelDblClicked := False;
        end else
        if Assigned(Panels[ClickedPanel].OnClick) then
        begin
          DoInherit := False;
          Panels[ClickedPanel].OnClick(Panels[ClickedPanel]);
        end;
      end;

      if Assigned(Panels[ClickedPanel].OnMouseUp) then
      begin
        DoInherit := False;

        P := ClientToPanel(Point(X, Y));
        Panels[ClickedPanel].OnMouseUp(Panels[ClickedPanel],
          Button, Shift, P.X, P.Y);
      end;
    end;
  end;

  if DoInherit then
    inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomStatusBar.Notification(AComponent: TComponent; Operation: TOperation);
var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = Images) then
    Images := nil;

  if FPanels <> nil then
    for I := 0 to FPanels.Count - 1 do
      if FPanels[I].Control <> nil then
        FPanels[I].Notification(AComponent, Operation);
end;

procedure TSCCustomStatusBar.Paint;
var
  C: TControl;
  CR, R, R2: TRect;
  PanelBmp: TBitmap;
  Cl, C1, C2: TColor;
  Panel: TSCStatusPanel;
  I, LvPanel, Sp, Cnt: Integer;
begin
  CR := ClientRect;

  PanelBmp := TBitmap.Create;
  try
    Cl := GetDefaultBackColor;
    C1 := Cl;
    
    with Canvas do
    begin
      Brush.Color := C1;
      Font.Assign(Self.Font);

      Brush.Color := C1;
      FillRect(CR);

      if FStyle = scbsStatusOffice12 then
        DrawOffice12Face(Canvas, CR)
      else begin
        if Transparent then PaintParentOn(Canvas);
        DrawPicture(Canvas);
      end;

      if SimplePanel then
      begin
        R := PanelRect(nil);

        with PanelBmp do
        begin
          R2 := R;
          OffsetRect(R2, -R2.Left, -R2.Top);

          Height := R2.Bottom;
          Width  := R2.Right;

          DoDrawPanel(nil, Canvas, R2);
        end;

        Brush.Color := Color;
        Draw(R.Left, R.Top, PanelBmp);
      end else
      begin
        LvPanel := GetLastVisiblePanel;

        C1 := GetBtnShadowOf(Cl);
        C2 := GetBtnHighlightOf(Cl);

        Cnt := 0;
        Sp := GetPanelSpacing + GetPanelSpace;

        for I := 0 to FPanels.Count-1 do
        begin
          Panel := FPanels[I];
          if not Panel.Visible then
            Continue;

          R := PanelRect(Panel);
          if IsRectEmpty(R) then
            Continue;

          Inc(Cnt);
          if (Sp > 0) and (Cnt > 1) then
          begin
            R2 := R;
            R2.Right := R2.Left;
            R2.Left := R2.Right - Sp;
            
            DoDrawSpace(Canvas, R2);
          end;

          with PanelBmp do
          begin
            R2 := R;
            OffsetRect(R2, -R2.Left, -R2.Top);

            Height := R2.Bottom;
            Width  := R2.Right;

            DoDrawPanel(Panel, Canvas, R2);
          end;

          Brush.Color := Panel.Color;
          Draw(R.Left, R.Top, PanelBmp);

          C := Panel.Control;
          if (C <> nil) and not (csDestroying in C.ComponentState) then
            C.SetBounds(R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top);

          if (Style in [scbsStatusOffice12, scbsStatusXP]) and (I < LvPanel) then
          begin
            Pen.Mode  := pmCopy;
            Pen.Style := psSolid;
            Pen.Width := 1;

            R2 := CR;
            Inc(R2.Top, 2);
            Dec(R2.Bottom, 1);

            if not IsRectEmpty(R2) then
            begin
              R2.Left := R.Right + (GetPanelSpace - 2);

              Pen.Color := C1;
              MoveTo(R2.Left, R2.Top);
              LineTo(R2.Left, R2.Bottom);

              Pen.Color := C2;
              MoveTo(R2.Left + 1, R2.Top);
              LineTo(R2.Left + 1, R2.Bottom);
            end;
          end;
        end;
      end;
    end;
  finally
    PanelBmp.Free;
  end;

  case Style of
    scbsStatusMac:
    begin
      if SizeGrip then DoDrawMacSizer(Canvas);
      DoDrawMacBorder(Canvas);
    end;
    scbsStatusWindows:
    begin
      if SizeGrip then DoDrawWinSizer(Canvas);
    end;
    scbsStatusOffice12:
    begin
      if SizeGrip then DoDrawOffice12Sizer(Canvas);
      DoDrawOffice12Border(Canvas);
    end;
    scbsStatusXP:
    begin
      if SizeGrip then DoDrawXPSizer(Canvas);
      DoDrawXPBorder(Canvas);
    end;
  end;
end;

function TSCCustomStatusBar.PanelAtPos(P: TPoint): Integer;
var
  I: Integer;
  R: TRect;
begin
  Result := -1;

  for I := 0 to Panels.Count-1 do
  begin
    R := PanelRect(Panels[I]);

    if PtInRect(R, P) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

procedure TSCCustomStatusBar.SetPanelAlign(Value: TSCPanelAlign);
begin
  if FPanelAlign <> Value then
  begin
    FPanelAlign := Value;
    Invalidate;
  end;
end;

procedure TSCCustomStatusBar.SetPanels(Value: TSCStatusPanels);
begin
  FPanels.Assign(Value);
end;

procedure TSCCustomStatusBar.SetSimplePanel(Value: Boolean);
begin
  if FSimplePanel <> Value then
  begin
    FSimplePanel := Value;
    Invalidate;
  end;
end;

procedure TSCCustomStatusBar.SetSimpleText(const Value: string);
begin
  FSimpleText := Value;
  if SimplePanel then
    Invalidate;
end;

procedure TSCCustomStatusBar.SetSizeGrip(Value: Boolean);
begin
  if FSizeGrip <> Value then
  begin
    FSizeGrip := Value;
    Invalidate;
  end;
end;

procedure TSCCustomStatusBar.SetStyle(Value: TSCBarStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TSCCustomStatusBar.SetUseSystemFont(const Value: Boolean);
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

function TSCCustomStatusBar.SizerRect: TRect;
begin
  Result := ClientRect;

  if not SizeGrip then
  begin
    Result.Left := Result.Right;
    Exit;
  end;

  Result.Left := Result.Right - GetSizeGripWidth;
  if Result.Left < 0 then
    Result.Left := 0;
  if Result.Left > Result.Right then
    Result.Left := Result.Right;
end;

procedure TSCCustomStatusBar.SyncToSystemFont;
{$IFDEF SC_DELPHI4_AND_EARLY}
var
  NonClientMetrics: TNonClientMetrics;
{$ENDIF}
begin
  if FUseSystemFont then
  begin
    {$IFDEF SC_DELPHI4_AND_EARLY}
    NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
    if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
      Font.Handle := CreateFontIndirect(NonClientMetrics.lfStatusFont)
    else
      Font.Size := 8;
    {$ELSE}
    Font.Assign(Screen.HintFont);
    {$ENDIF}
  end;
end;

procedure TSCCustomStatusBar.UpdatePanel(Index: Integer; Repaint: Boolean);
var
  R, R2: TRect;
  PanelBmp: TBitmap;
begin
  if not HandleAllocated or (Index < 0) or (Index > Panels.Count-1) then
    Exit;

  PanelBmp := TBitmap.Create;
  try
    R := PanelRect(Panels[Index]);

    with PanelBmp do
    begin
      R2 := R;
      OffsetRect(R2, -R2.Left, -R2.Top);
      
      Height := R2.Bottom;
      Width  := R2.Right;
      DoDrawPanel(Panels[Index], Canvas, R2);
    end;

    Canvas.Draw(R.Left, R.Top, PanelBmp);
  finally
    PanelBmp.Free;
  end;

  case Style of
    scbsStatusMac:
    begin
      if SizeGrip then DoDrawMacSizer(Canvas);
      DoDrawMacBorder(Canvas);
    end;
    scbsStatusWindows:
    begin
      if SizeGrip then DoDrawWinSizer(Canvas);
    end;
    scbsStatusOffice12:
    begin
      if SizeGrip then DoDrawOffice12Sizer(Canvas);
      DoDrawOffice12Border(Canvas);
    end;
    scbsStatusXP:
    begin
      if SizeGrip then DoDrawXPSizer(Canvas);
      DoDrawXPBorder(Canvas);
    end;
  end;
end;

procedure TSCCustomStatusBar.UpdatePanelColors(OldColor: TColor);
var
  I: Integer;
begin
  if not HandleAllocated then Exit;

  Panels.BeginUpdate;
  try
    for I := 0 to Panels.Count-1 do
      if Panels[I].ParentColor then
        Panels[I].Color := GetDefaultBackColor;
  finally
    Panels.EndUpdate;
  end;
end;

procedure TSCCustomStatusBar.UpdatePanels;
begin
  Invalidate;
end;

procedure TSCCustomStatusBar.WMSize(var Message: TWMSize);
begin
  inherited;
  if not IsLoading then
    Resize;
  Repaint;
end;

procedure TSCCustomStatusBar.DoDockOver(Source: TDragDockObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  Invalidate;
end;

procedure TSCCustomStatusBar.SetLeftSpace(Value: Cardinal);
begin
  if FLeftSpace <> Value then
  begin
    FLeftSpace := Value;
    Invalidate;
  end;
end;

function TSCCustomStatusBar.GetPanelSpace: Word;
begin
  Result := 0;
  if FStyle = scbsStatusXP then
    Result := 5;
end;

function TSCCustomStatusBar.GetLastVisiblePanel: Integer;
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to Panels.Count-1 do
    if Panels[I].Visible then
      Result := I;
end;

procedure TSCCustomStatusBar.WMMove(var Message: TWMMove);
begin
  inherited;
end;

procedure TSCCustomStatusBar.StopTracking;
begin
  FSzGripClick := False;
  inherited StopTracking;
end;

procedure TSCCustomStatusBar.PanelControlAssigned(Panel: TSCStatusPanel;
  AControl: TControl);
var
  I: Integer;
begin
  if (Panel <> nil) and (AControl <> nil) then
    for I := 0 to FPanels.Count - 1 do
      if (Panel <> FPanels[I]) and (AControl = FPanels[I].Control) then
        FPanels[I].SetControl(nil);
end;

procedure TSCCustomStatusBar.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomStatusBar then
  begin
    with TSCCustomStatusBar(Source) do
    begin
      Self.AutoHint := AutoHint;
      Self.LeftSpace := LeftSpace;
      Self.PanelAlign := PanelAlign;
      Self.Panels := Panels;
      Self.SimplePanel := SimplePanel;
      Self.SimpleText := SimpleText;
      Self.SizeGrip := SizeGrip;
      Self.Style := Style;
      Self.UseSystemFont := UseSystemFont;
    end;
  end;
end;

procedure TSCCustomStatusBar.AlignControls(AControl: TControl;
  var Rect: TRect);
begin
  //
end;

function TSCCustomStatusBar.GetDefaultBackColor: TColor;
begin
  Result := Self.Color;
  if Result = clNone then Result := clBtnFace;
end;

function TSCCustomStatusBar.GetGradientDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -16);
end;

function TSCCustomStatusBar.GetGradientLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 30);
end;

function TSCCustomStatusBar.GetGradientPreLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 80);
end;

procedure TSCCustomStatusBar.DrawOffice12Face(ACanvas: TCanvas; ARect: TRect);
var
  R: TRect;
  Cl, ClStart, ClEnd: TColor;
begin
  Cl := GetDefaultBackColor;

  with ACanvas do
  begin
    Brush.Color := Cl;
    FillRect(ARect);
  end;

  R := ARect;
  Dec(R.Bottom, Round((R.Bottom - R.Top)/4));

  ClEnd := Cl;
  ClStart := GetGradientPreLight(Cl);

  scDrawGradient(ACanvas, R, scgTopToBottom, ClStart, ClEnd);

  R := ARect;
  Inc(R.Top, (R.Bottom - R.Top) div 2);

  if not IsRectEmpty(R) then
  begin
    ClStart := GetGradientDark(Cl);
    ClEnd := GetGradientLight(Cl);

    scDrawGradient(ACanvas, R, scgTopToBottom, ClStart, ClEnd);
  end;
end;

function TSCCustomStatusBar.GetPanelSpacing: Integer;
begin
  Result := SC_PanelSpace;
  if FStyle = scbsStatusOffice12 then
    Result := 2;
end;

function TSCCustomStatusBar.GetSizeGripWidth: Integer;
begin
  Result := SC_SizeGripWidth;
end;

function TSCCustomStatusBar.GetMacSpace: Integer;
begin
  Result := SC_MacSpace;
end;

function TSCCustomStatusBar.GetSimpleLeft: Integer;
begin
  Result := SC_SimpleLeft;
end;

{ TSCStatusPanels }

function TSCStatusPanels.Add: TSCStatusPanel;
begin
  Result := TSCStatusPanel(inherited Add);
end;

constructor TSCStatusPanels.Create(StatusBar: TSCCustomStatusBar);
begin
  inherited Create(TSCStatusPanel);
  FStatusBar := StatusBar;
end;

function TSCStatusPanels.GetItem(Index: Integer): TSCStatusPanel;
begin
  Result := TSCStatusPanel(inherited GetItem(Index));
end;

function TSCStatusPanels.GetOwner: TPersistent;
begin
  Result := FStatusBar;
end;

procedure TSCStatusPanels.SetItem(Index: Integer;
  Value: TSCStatusPanel);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCStatusPanels.Update(Item: TCollectionItem);
begin
  if Item <> nil then
    FStatusBar.UpdatePanel(Item.Index, False) else
    FStatusBar.UpdatePanels;
end;

{ TSCStatusPanel }

procedure TSCStatusPanel.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  if Action is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or (Self.Text = '') then
        Self.Text := Caption;
      if not CheckDefaults or (Self.Enabled = True) then
        Self.Enabled := Enabled;
      if not CheckDefaults or (Self.ImageIndex = -1) then
        Self.ImageIndex := ImageIndex;
      if not CheckDefaults or (Self.Visible = True) then
        Self.Visible := Visible;
      if not CheckDefaults or not Assigned(Self.OnClick) then
        Self.OnClick := OnExecute;
    end;
end;

procedure TSCStatusPanel.AnimateThis(Sender: TObject);
begin
  InitiateAnimation;
  if Animate and Visible and Enabled then
  begin
    if FAnimationStop > FAnimationStart then
    begin
      Inc(FCurAnimateIndex);
      if FCurAnimateIndex > FAnimationStop then
        ResetCurAnimation;
    end else
    begin
      Dec(FCurAnimateIndex);
      if FCurAnimateIndex < FAnimationStop then
        ResetCurAnimation;
    end;
    
    DoChange(False);

    if Assigned(FOnAnimate) then FOnAnimate(Self);
  end;
end;

procedure TSCStatusPanel.Assign(Source: TPersistent);
begin
  if Source is TSCStatusPanel then
  begin
    with TSCStatusPanel(Source) do
    begin
      Self.FAlignment := Alignment;
      Self.FAnimationStart := AnimationStart;
      Self.FAnimationStop := AnimationStop;
      Self.FAnimationInterval := AnimationInterval;
      Self.FAnimate := Animate;
      Self.FBevel := Bevel;
      Self.FBorderColor := BorderColor;
      Self.FColor := Color;
      Self.FEnabled := Enabled;
      Self.FFontColor := FontColor;
      Self.FEndEllipsis := EndEllipsis;
      Self.FGauge := Gauge;
      Self.FHint := Hint;
      Self.FImageIndex := ImageIndex;
      Self.FIndent := Indent;
      Self.FParentColor := ParentColor;
      Self.FStyle := Style;
      Self.FText := Text;
      Self.FVisible := Visible;
      Self.FWidth := Width;
    end;

    DoChange(True, True);
  end else
    inherited Assign(Source);
end;

constructor TSCStatusPanel.Create(Collection: TCollection);
begin
  FWidth := 50;
  FBevel := scpbLowered;
  FImageIndex := -1;
  FControl := nil;

  FAnimationStart := -1;
  FAnimationStop := -1;
  FCurAnimateIndex := -1;
  FAnimationInterval := 1000;
  FAnimate := False;

  FFlashShowPause := 500;
  FFlashHidePause := 200;
  FShowing := True;
  FFlash := False;
  inherited Create(Collection);

  FGauge := TSCStatusPanelGauge.Create;
  FGauge.OnChange := GaugeChanged;

  FFontColor := clNone;
  FStyle := scpsText;
  FParentColor := True;
  FColor := clBtnFace;
  FVisible := True;
  FEnabled := True;
  FEndEllipsis := True;
  FBorderColor := clBtnShadow;
end;

destructor TSCStatusPanel.Destroy;
begin
  FreeAndNil(FActionLink);
  FGauge.OnChange := nil;
  FreeAndNil(FGauge);
  ReleaseAnimationTimer;
  ReleaseFlashTimer;
  inherited Destroy;
end;

procedure TSCStatusPanel.DoActionChange(Sender: TObject);
begin
  if Sender = Action then ActionChange(Sender, False);
end;

procedure TSCStatusPanel.DoChange(AllItems, Force: Boolean);
begin
  if FVisible or Force then
    Changed(AllItems);
end;

procedure TSCStatusPanel.FlashMe(Sender: TObject);
begin
  InitiateFlashing;
  if Flash and Visible and Enabled then
  begin
    FShowing := not FShowing;
    if FFlashTimer <> nil then
      with FFlashTimer do
      begin
        if Showing then
          Interval := FFlashShowPause
        else Interval := FFlashHidePause;
      end;

    DoChange(False);
  end;
end;

procedure TSCStatusPanel.FreeNotification(AComponent: TComponent);
var
  S: TSCCustomStatusBar;
begin
  if AComponent <> nil then
  begin
    S := GetStatusBar;
    if S <> nil then
      S.FreeNotification(AComponent);
  end;
end;

procedure TSCStatusPanel.GaugeChanged(Sender: TObject);
begin
  if (Style in [scpsGauge, scpsOwnerDraw]) then
    DoChange(False);
end;

function TSCStatusPanel.GetAction: TBasicAction;
begin
  if FActionLink <> nil then
    Result := FActionLink.Action else
    Result := nil;
end;

function TSCStatusPanel.GetActionLinkClass: TSCStatusPanelActionLinkClass;
begin
  Result := TSCStatusPanelActionLink;
end;

function TSCStatusPanel.GetAnimate: Boolean;
begin
  Result := FAnimate;
end;

function TSCStatusPanel.GetAnimationInterval: Cardinal;
begin
  Result := FAnimationInterval;
end;

function TSCStatusPanel.GetDisplayName: string;
begin
  Result := Text;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TSCStatusPanel.GetImages: TCustomImageList;
var
  S: TSCCustomStatusBar;
begin
  Result := nil;
  S := GetStatusBar;
  if S <> nil then Result := S.Images;
end;

function TSCStatusPanel.GetParentColor: TColor;
var
  S: TSCCustomStatusBar;
begin
  Result := clBtnFace;
  S := GetStatusBar;
  if S <> nil then Result := S.Color;
end;

function TSCStatusPanel.GetStatusBar: TSCCustomStatusBar;
begin
  Result := nil;
  if TSCStatusPanels(Collection) <> nil then
    Result := TSCStatusPanels(Collection).FStatusBar;
end;

procedure TSCStatusPanel.InitiateAnimation;
begin
  if (FAnimateTimer = nil) or (csLoading in OwnerState) then
    Exit;
  if Animate and ((GetImages = nil) or (Style <> scpsAnimation)) then
    Animate := False;
end;

function TSCStatusPanel.InitiateAnimationTimer: TTimer;
begin
  if FAnimateTimer = nil then
  begin
    ResetCurAnimation;
    FAnimateTimer := TTimer.Create(nil);
    FAnimateTimer.Enabled := FAnimate;
    InitiateAnimation;
    FAnimateTimer.OnTimer := AnimateThis;
    FAnimateTimer.Interval := FAnimationInterval;
  end;
  Result := FAnimateTimer;
end;

procedure TSCStatusPanel.InitiateFlashing;
begin
  if (FFlashTimer = nil) or
    (csLoading in OwnerState) then Exit;

  if Flash and ((Style = scpsAnimation) or not Visible) then
    Flash := False;
end;

function TSCStatusPanel.InitiateFlashTimer: TTimer;
begin
  if FFlashTimer = nil then
  begin
    FShowing := True;
    FFlashTimer := TTimer.Create(nil);
    FFlashTimer.Enabled := FAnimate;
    InitiateFlashing;
    FFlashTimer.OnTimer := FlashMe;
    FFlashTimer.Interval := FlashShowPause;
  end;
  Result := FFlashTimer;
end;

function TSCStatusPanel.IsCaptionStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsCaptionLinked;
end;

function TSCStatusPanel.IsEnabledStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsEnabledLinked;
end;

function TSCStatusPanel.IsHintStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsHintLinked;
end;

function TSCStatusPanel.IsImageIndexStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsImageIndexLinked;
end;

function TSCStatusPanel.IsOnClickStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsOnExecuteLinked;
end;

function TSCStatusPanel.IsVisibleStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsVisibleLinked;
end;

procedure TSCStatusPanel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FControl) then
  begin
    FControl := nil;
    SetStyle(scpsText);
  end;
end;

function TSCStatusPanel.OwnerState: TComponentState;
var
  S: TSCCustomStatusBar;
begin
  Result := [];
  S := GetStatusBar;
  if S <> nil then Result := S.ComponentState;
end;

procedure TSCStatusPanel.ReleaseAnimationTimer;
begin
  if FAnimateTimer <> nil then
  begin
    FAnimateTimer.OnTimer := nil;
    FreeAndNil(FAnimateTimer);
  end;
end;

procedure TSCStatusPanel.ReleaseFlashTimer;
begin
  if FFlashTimer <> nil then
  begin
    FFlashTimer.OnTimer := nil;
    FreeAndNil(FFlashTimer);
  end;
end;

procedure TSCStatusPanel.RemoveFreeNotification(AComponent: TComponent);
{$IFDEF SC_DELPHI5_UP}
var
  S: TSCCustomStatusBar;
{$ENDIF}
begin
{$IFDEF SC_DELPHI5_UP}
  if AComponent <> nil then
  begin
    S := GetStatusBar;
    if S <> nil then
      S.RemoveFreeNotification(AComponent);
  end;
{$ENDIF}
end;

procedure TSCStatusPanel.ResetCurAnimation;
begin
  FCurAnimateIndex := FAnimationStart;
end;

procedure TSCStatusPanel.SetAction(const Value: TBasicAction);
begin
  if Value = nil then
  begin
    FActionLink.Free;
    FActionLink := nil;
  end else
  begin
    if FActionLink = nil then
      FActionLink := GetActionLinkClass.Create(Self);

    FActionLink.Action := Value;
    FActionLink.OnChange := DoActionChange;
    ActionChange(Value, csLoading in Value.ComponentState);
  end;
end;

procedure TSCStatusPanel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    if (Style in [scpsText, scpsImage, scpsGauge,
      scpsAnimation, scpsImageAndText, scpsOwnerDraw]) then
      DoChange(False);
  end;
end;

procedure TSCStatusPanel.SetAnimate(Value: Boolean);
begin
  if FAnimate <> Value then
  begin
    FAnimate := Value;
    if Style = scpsAnimation then
      InitiateAnimationTimer;

    if FAnimateTimer <> nil then
    begin
      FAnimateTimer.Enabled := FAnimate;
      DoChange(False);
    end;
  end;
  InitiateAnimation;
end;

procedure TSCStatusPanel.SetAnimationInterval(Value: Cardinal);
begin
  if FAnimationInterval <> Value then
  begin
    FAnimationInterval := Value;
    if FAnimateTimer <> nil then
    begin
      FAnimateTimer.Interval := Value;
      if (Style = scpsAnimation) and Animate then
        DoChange(False);
    end;
  end;
end;

procedure TSCStatusPanel.SetAnimationStart(Value: TImageIndex);
begin
  if FAnimationStart <> Value then
  begin
    FAnimationStart := Value;
    ResetCurAnimation;
    if Style = scpsAnimation then
      DoChange(False);
  end;
end;

procedure TSCStatusPanel.SetAnimationStop(Value: TImageIndex);
begin
  if FAnimationStop <> Value then
  begin
    FAnimationStop := Value;
    ResetCurAnimation;
    if Style = scpsAnimation then
      DoChange(False);
  end;
end;

procedure TSCStatusPanel.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    if FStyle in [scpsImageAndText, scpsText] then
      DoChange(True);
  end;
end;

procedure TSCStatusPanel.SetBevel(Value: TSCStatusPanelBevel);
begin
  if FBevel <> Value then
  begin
    FBevel := Value;
    DoChange(FAutoSize);
  end;
end;

procedure TSCStatusPanel.SetBorderColor(Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    if Bevel = scpbFlat then
      DoChange(False);
  end;
end;

procedure TSCStatusPanel.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    if FParentColor and (Value <> GetParentColor) then
      FParentColor := False;

    DoChange(True);
  end;
end;

procedure TSCStatusPanel.SetControl(Value: TControl);
var
  R: TRect;
  C: TControl;
  F: TCustomForm;
  S: TSCCustomStatusBar;
begin
  if FControl <> Value then
  begin
    S := GetStatusBar;
    if (Value <> nil) and (Value = S) then
      Exit;

    C := FControl;
    FControl := Value;

    RemoveFreeNotification(C);
    FreeNotification(FControl);

    if (S <> nil) and (C <> nil) then
    begin
      F := GetParentForm(S);
      if F <> nil then C.Parent := F;
    end;

    if S <> nil then
      S.PanelControlAssigned(Self, FControl);

    if FControl = nil then
      SetStyle(scpsText)
    else if FControl <> nil then
    begin
      SetStyle(scpsControl);

      if S <> nil then
      begin
        FControl.Parent := S;

        R := S.PanelRect(Self);

        if R.Right < R.Left then
          R.Right := R.Left;

        if R.Bottom < R.Top then
          R.Bottom := R.Top;

        FControl.BoundsRect := R;
      end;
    end;
  end;
end;

procedure TSCStatusPanel.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    DoChange(False);
  end;
end;

procedure TSCStatusPanel.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    if (Style in [scpsText, scpsImageAndText, scpsOwnerDraw]) then
      DoChange(FAutoSize);
  end;
end;

procedure TSCStatusPanel.SetFlash(Value: Boolean);
begin
  if FFlash <> Value then
  begin
    FFlash := Value;
    if Style <> scpsAnimation then
      InitiateFlashTimer;

    if FFlashTimer <> nil then
    begin
      FFlashTimer.Enabled := FFlash;
      DoChange(False);
    end;
  end;
  InitiateFlashing;
end;

procedure TSCStatusPanel.SetFlashHidePause(Value: Cardinal);
begin
  if FFlashHidePause <> Value then
  begin
    FFlashHidePause := Value;

    if FFlashTimer <> nil then
    begin
      FFlashTimer.Interval := Value;
      FShowing := False;
      if (Style <> scpsAnimation) and Flash then
        DoChange(False);
    end;
  end;
end;

procedure TSCStatusPanel.SetFlashShowPause(Value: Cardinal);
begin
  if FFlashShowPause <> Value then
  begin
    FFlashShowPause := Value;

    if FFlashTimer <> nil then
    begin
      FFlashTimer.Interval := Value;
      FShowing := True;
      if (Style <> scpsAnimation) and Flash then
        DoChange(False);
    end;
  end;
end;

procedure TSCStatusPanel.SetFontColor(Value: TColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    DoChange(False);
  end;
end;

procedure TSCStatusPanel.SetGauge(Value: TSCStatusPanelGauge);
begin
  FGauge.Assign(Value);
end;

procedure TSCStatusPanel.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if (Style in [scpsImage, scpsImageAndText, scpsOwnerDraw]) then
      DoChange(FAutoSize);
  end;
end;

procedure TSCStatusPanel.SetIndent(Value: Integer);
begin
  if FIndent <> Value then
  begin
    FIndent := Value;
    if (Style in [scpsText, scpsImageAndText, scpsOwnerDraw]) then
      DoChange(FAutoSize);
  end;
end;

procedure TSCStatusPanel.SetParentColor(Value: Boolean);
begin
  if FParentColor <> Value then
  begin
    FParentColor := Value;
    if FParentColor then SetColor(GetParentColor);
  end;
end;

procedure TSCStatusPanel.SetStyle(Value: TSCStatusPanelStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;

    if FStyle = scpsAnimation then
    begin
      InitiateAnimationTimer;
      InitiateAnimation;
      ReleaseFlashTimer;
    end else
    begin
      ReleaseAnimationTimer;
      if Flash then
      begin
        InitiateFlashTimer;
        InitiateFlashing;
      end;
    end;

    DoChange(FAutoSize);
  end;
end;

procedure TSCStatusPanel.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    if (Style in [scpsText, scpsImageAndText, scpsOwnerDraw]) then
      DoChange(FAutoSize);
  end;
end;

procedure TSCStatusPanel.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    DoChange(True, True);
  end;
end;

procedure TSCStatusPanel.SetWidth(Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    DoChange(True);
  end;
end;

{ TSCStatusPanelActionLink }

procedure TSCStatusPanelActionLink.AssignClient(AClient: TObject);
begin
  FClient := AClient as TSCStatusPanel;
end;

function TSCStatusPanelActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and
    AnsiSameText(FClient.Text, (Action as TCustomAction).Caption);
end;

function TSCStatusPanelActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and
    (FClient.Enabled = (Action as TCustomAction).Enabled);
end;

function TSCStatusPanelActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and
    (FClient.Hint = (Action as TCustomAction).Hint);
end;

function TSCStatusPanelActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and
    (FClient.ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TSCStatusPanelActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and
    (@FClient.OnClick = @Action.OnExecute);
end;

function TSCStatusPanelActionLink.IsShortCutLinked: Boolean;
begin
  Result := False;
end;

function TSCStatusPanelActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and
    (FClient.Visible = (Action as TCustomAction).Visible);
end;

procedure TSCStatusPanelActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then FClient.Text := Value;
end;

procedure TSCStatusPanelActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then FClient.Enabled := Value;
end;

procedure TSCStatusPanelActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then FClient.Hint := Value;
end;

procedure TSCStatusPanelActionLink.SetImageIndex(Value: Integer);
begin
  if IsImageIndexLinked then FClient.ImageIndex := Value;
end;

procedure TSCStatusPanelActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then FClient.OnClick := Value;
end;

procedure TSCStatusPanelActionLink.SetShortCut(Value: TShortCut);
begin
  inherited;
end;

procedure TSCStatusPanelActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then FClient.Visible := Value;
end;

{ TSCStatusPanelGauge }

procedure TSCStatusPanelGauge.Assign(Source: TPersistent);
begin
  if Source is TSCStatusPanelGauge then
  begin
    FNotifyLocked := True;
    try
      with TSCStatusPanelGauge(Source) do
      begin
        Self.Color := Color;
        Self.EndColor := EndColor;
        Self.Min := Min;
        Self.Max := Max;
        Self.Position := Position;
        Self.Style := Style;
      end;
    finally
      FNotifyLocked := False;
      DoChange;
    end;
  end else
    inherited;
end;

constructor TSCStatusPanelGauge.Create;
begin
  FNotifyLocked := False;
  inherited Create;
  FColor := clHighlight;
  FEndColor := clAqua;
  FMin := 0;
  FMax := 100;
  FStyle := scsgClasic;
end;

procedure TSCStatusPanelGauge.DoChange;
begin
  if not FNotifyLocked and Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TSCStatusPanelGauge.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    DoChange;
  end;
end;

procedure TSCStatusPanelGauge.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    DoChange;
  end;
end;

procedure TSCStatusPanelGauge.SetEndColor(Value: TColor);
begin
  if FEndColor <> Value then
  begin
    FEndColor := Value;
    DoChange;
  end;
end;

procedure TSCStatusPanelGauge.SetMax(Value: Integer);
begin
  if Value < FMin then
    Value := FMin;

  if FMax <> Value then
  begin
    FMax := Value;
    if FPosition > FMax then
      FPosition := FMax;

    DoChange;
  end;
end;

procedure TSCStatusPanelGauge.SetMin(Value: Integer);
begin
  if Value > FMax then
    Value := FMax;

  if FMin <> Value then
  begin
    FMin := Value;
    if FPosition < FMin then
      FPosition := FMin;

    DoChange;
  end;
end;

procedure TSCStatusPanelGauge.SetPosition(Value: Word);
var
  OldValue: Word;
begin
  if FPosition <> Value then
  begin
    OldValue := FPosition;
    if Value > FMax then
      FPosition := FMax
    else if Value < FMin then
      FPosition := FMin
    else
      FPosition := Value;

    if OldValue <> FPosition then
      DoChange;
  end;
end;

procedure TSCStatusPanelGauge.SetStyle(Value: TSCStatusGaugeStyle);
begin
  if FStyle <> value then
  begin
    FStyle := Value;
    DoChange;
  end;
end;

{ TSCControlSizer }

procedure TSCControlSizer.CMColorChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TSCControlSizer.CMParentColorChanged(
  var Message: TWMNoParams);
begin
  inherited;
  Invalidate;
end;

procedure TSCControlSizer.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

constructor TSCControlSizer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  DoubleBuffered := True;
  Color := clBtnFace;
  ParentColor := False;
  Align := alBottom;
  Height := 19;
  Width := 19;
  Cursor := crSizeNWSE;
  BlendColor := False;

  FStyle := sccsWindows;
end;

destructor TSCControlSizer.Destroy;
begin
  inherited Destroy;
end;

procedure TSCControlSizer.DoDrawMacSizer(ACanvas: TCanvas);
var
  R: TRect;
  Cl, C1, C2: TColor;
  I, Dif, Step: Integer;
begin
  R := ClientRect;
  if IsRectEmpty(R) then
    Exit;

  Cl := GetDefaultBackColor;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Cl;

    FillRect(R);
    if Transparent then
      PaintParentOn(ACanvas);

    Inc(R.Top, (((R.Bottom - R.Top) - SC_SizeGripWidth) div 2));
    R.Bottom := R.Top + SC_SizeGripWidth;

    InflateRect(R, -5, -5);
    OffsetRect(R,  2, 2);

    C1 := GetBtnShadowOf(Cl);
    C2 := GetBtnHighlightOf(Cl);

    Dif := 6;
    Step := 0;
    for I := 0 to 2 do
    begin
      Pen.Color := C1;
      MoveTo(R.Right - Dif,  R.Bottom - Step);
      LineTo(R.Right - Step, R.Bottom - Dif);

      Pen.Color := C2;
      MoveTo(R.Right - (Dif + 1),  R.Bottom - (Step + 1));
      LineTo(R.Right - (Step + 1), R.Bottom - (Dif + 1));

      Pen.Color := BlendedColor(C1, 24, 24, 24, True);
      MoveTo(R.Right - (Dif + 1), R.Bottom - Step);
      LineTo(R.Right - (Dif + 1), R.Bottom - Step - 1);

      Pen.Color := C2;
      MoveTo(R.Right - (Step + 1), R.Bottom - Dif);
      LineTo(R.Right - (Step + 2), R.Bottom - Dif);

      Inc(Dif, 2);
      Inc(Step, 2);
    end;
  end;
end;

procedure TSCControlSizer.DoDrawXPSizer(ACanvas: TCanvas);

  procedure DrawSizerPoint(C: TCanvas; R: TRect);
  begin
    with C do
    begin
      FillRect(R);

      MoveTo(R.Right - 1, R.Top);
      LineTo(R.Right - 2, R.Top);
    end;
  end;

var
  CR, R: TRect;
  Cl, C1, C2: TColor;
begin
  CR := ClientRect;
  if IsRectEmpty(CR) then
    Exit;

  Cl := GetDefaultBackColor;
  
  with ACanvas do
  begin
    Brush.Style := bsSolid;

    if BlendColor then
      Brush.Color := BlendedColor(Cl, 24, 24, 24, True)
    else
      Brush.Color := Cl;

    FillRect(CR);
    if Transparent then
      PaintParentOn(ACanvas);

    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Pen.Width := 1;

    C1 := GetBtnShadowOf(Cl);
    C1 := SCCommon.scBlendColor(C1, 32);

    C2 := Get3DDkShadowOf(Cl);
    C2 := SCCommon.scBlendColor(C2, 16);

    Pen.Color   := C2;
    Brush.Color := C1;
  end;

   R := Rect(0, 0, 2, 2);
   OffsetRect(R, CR.Right - 6, CR.Bottom - 6);
   DrawSizerPoint(ACanvas, R);

   R := Rect(0, 0, 2, 2);
   OffsetRect(R, CR.Right - 10, CR.Bottom - 6);
   DrawSizerPoint(ACanvas, R);

   R := Rect(0, 0, 2, 2);
   OffsetRect(R, CR.Right - 14, CR.Bottom - 6);
   DrawSizerPoint(ACanvas, R);

   R := Rect(0, 0, 2, 2);
   OffsetRect(R, CR.Right - 6, CR.Bottom - 10);
   DrawSizerPoint(ACanvas, R);

   R := Rect(0, 0, 2, 2);
   OffsetRect(R, CR.Right - 6, CR.Bottom - 14);
   DrawSizerPoint(ACanvas, R);

   R := Rect(0, 0, 2, 2);
   OffsetRect(R, CR.Right - 10, CR.Bottom - 10);
   
   DrawSizerPoint(ACanvas, R);
end;

procedure TSCControlSizer.DoDrawWinSizer(ACanvas: TCanvas);
var
  R: TRect;
  I, Dif: Integer;
  Cl, C1, C2: TColor;
begin
  R := ClientRect;
  if IsRectEmpty(R) then
    Exit;

  Cl := GetDefaultBackColor;

  C1 := GetBtnShadowOf(Cl);
  C2 := GetBtnHighlightOf(Cl);

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Cl;

    FillRect(R);
    if Transparent then
      PaintParentOn(ACanvas);

    Dif := 3;
    for I := 0 to 2 do
    begin
      Pen.Color := C1;
      MoveTo(R.Right - Dif, R.Bottom);
      LineTo(R.Right, R.Bottom - Dif);

      MoveTo(R.Right - (Dif + 1), R.Bottom);
      LineTo(R.Right, R.Bottom - (Dif + 1));

      Pen.Color := C2;
      MoveTo(R.Right - (Dif + 2), R.Bottom);
      LineTo(R.Right, R.Bottom - (Dif + 2));

      Inc(Dif, 4);
    end;
  end;
end;

procedure TSCControlSizer.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(Parent.Handle, WM_NCLBUTTONDOWN, HTBOTTOMRIGHT, 0);
end;

procedure TSCControlSizer.Paint;
begin
  ClientWidth := 19;
  ClientHeight := 19;

  if Parent <> nil then
  begin
    Left := Parent.ClientWidth - Width;
    Top  := Parent.ClientHeight - Height;
  end;

  case Style of
    sccsMac:
      DoDrawMacSizer(Canvas);
    sccsWindows:
      DoDrawWinSizer(Canvas);
    sccsXP:
      DoDrawXPSizer(Canvas);
  end;
end;

procedure TSCControlSizer.SetStyle(Value: TSCControlSizerStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TSCControlSizer.WMMove(var Message: TWMMove);
begin
  if HandleAllocated and (Parent <> nil) then
  begin
    Left := Parent.ClientWidth - Width;
    Top := Parent.ClientHeight - Height;
  end else
    inherited;

  Invalidate;
end;

procedure TSCControlSizer.WMSize(var Message: TWMSize);
begin
  if HandleAllocated and (Parent <> nil) then
  begin
    ClientHeight := 19;
    ClientWidth := 19;

    Left := Parent.ClientWidth - Width;
    Top := Parent.ClientHeight - Height;
  end else
    inherited;

  Invalidate;
end;

function TSCControlSizer.GetBlendValue: Word;
begin
  Result := 0;
end;

procedure TSCControlSizer.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCControlSizer then
    with TSCControlSizer(Source) do
      Self.Style := Style;
end;

{$I SCVerRec.inc}

end.

