{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCPanels;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Consts, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdActns, ActnList, Menus, SCCommon, SCConsts, SCControl;

type
  TSCCustomGroup = class;
  TSCCustomAdvGroup = class;

  TSCAdvPanelPictureProps = class(TSCPictureProps);

  TSCAdvPanelStyle = (scasCustom, scasExplorerBar, scasMXBar,
    scasOfficeXP, scasOutlookBar, scasOutlookBar2k, scasOutlookBarXP,
    scasTaskList, scasAdvXPBar, scasXPBar);

  TSCCustomGroup = class(TSCCustomScrollControl)
  private
    FBevel: TSCControlBevel;
    FBevelColor: TColor;
    FBevelDotted: Boolean;
    FBevelEx: Boolean;
    FBevelWidth: Integer;
    FEndColor: TColor;
    FGradient: TSCGradient;
    FStyle: TSCAdvPanelStyle;
    FUseExGradient: Boolean;
    FAutoSizeDocking: Boolean;
    FSettingStyle: Boolean;
    FInStyleChange: Boolean;
    FIsMouseDown: Boolean;
    FIsMouseInControl: Boolean;
    procedure SetBevel(Value: TSCControlBevel);
    procedure SetBevelColor(Value: TColor);
    procedure SetBevelDotted(Value: Boolean);
    procedure SetBevelEx(Value: Boolean);
    procedure SetBevelWidth(Value: Integer);
    procedure SetEndColor(Value: TColor);
    procedure SetGradient(Value: TSCGradient);
    procedure SetStyle(Value: TSCAdvPanelStyle);
    procedure SetUseExGradient(Value: Boolean);

    procedure CMDockClient(var Message: TCMDockClient); message CM_DOCKCLIENT;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
  protected
    procedure Paint; override;
    procedure AdjustClientRect(var Rect: TRect); override;
    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;

    function  GetPicturePropsClass: TSCCustomPicturePropsClass; override;

    function  CanGetFocus: Boolean; override;
    function  GetBlendValue: Word; override;

    procedure UpdateTracking; dynamic;
    procedure ApplyStyle(S: TSCAdvPanelStyle; DoUpdate: Boolean); dynamic;

    procedure UpdateCaptionFont(F: TFont); virtual;
    function  GetPanelCaption: String; virtual;
    procedure DoDrawCaptionText(Cnv: TCanvas; var R: TRect; CalcRect: Boolean = False); virtual;

    function  IsOutlookStyle: Boolean;

    function  BevelSize: Integer; dynamic;
    function  HasGradient: Boolean;

    property InStyleChange: Boolean read FInStyleChange;
    property SettingStyle: Boolean read FSettingStyle;
    property Bevel: TSCControlBevel read FBevel write SetBevel default sccbFlat;
    property BevelColor: TColor read FBevelColor write SetBevelColor default clBtnHighlight;
    property BevelDotted: Boolean read FBevelDotted write SetBevelDotted default False;
    property BevelEx: Boolean read FBevelEx write SetBevelEx default True;
    property BevelWidth: Integer read FBevelWidth write SetBevelWidth default 0;
    property Color default clBtnFace;
    property EndColor: TColor read FEndColor write SetEndColor default clBtnHighlight;
    property Gradient: TSCGradient read FGradient write SetGradient default scgNone;
    property IsMouseInControl: Boolean read FIsMouseInControl;
    property IsMouseDown: Boolean read FIsMouseDown;
    property ParentColor default False;
    property UseExGradient: Boolean read FUseExGradient write SetUseExGradient default False;
    property Style: TSCAdvPanelStyle read FStyle write SetStyle default scasCustom;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCAdvGroupButtons = class(TPersistent)
  private
    FOwner: TSCCustomAdvGroup;
    FColor: TColor;
    FDisabledColor: TColor;
    FDownColor: TColor;
    FFrameColor: TColor;
    FHotColor: TColor;
    FIconColor: TColor;
    FIconDisabledColor: TColor;
    FIconDownColor: TColor;
    FIconHotColor: TColor;
    FOnChange: TNotifyEvent;
    procedure SetColor(Value: TColor);
    procedure SetDisabledColor(Value: TColor);
    procedure SetDownColor(Value: TColor);
    procedure SetFrameColor(Value: TColor);
    procedure SetHotColor(Value: TColor);
    procedure SetIconColor(Value: TColor);
    procedure SetIconDisabledColor(Value: TColor);
    procedure SetIconDownColor(Value: TColor);
    procedure SetIconHotColor(Value: TColor);
  protected
    procedure DoChange; dynamic;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TSCCustomAdvGroup); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomAdvGroup read FOwner;
  published
    property Color: TColor read FColor write SetColor default clWindow;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clWindow;
    property DownColor: TColor read FDownColor write SetDownColor default clWindow;
    property FrameColor: TColor read FFrameColor write SetFrameColor default clBtnShadow;
    property HotColor: TColor read FHotColor write SetHotColor default clWindow;
    property IconColor: TColor read FIconColor write SetIconColor default clHighlight;
    property IconDisabledColor: TColor read FIconDisabledColor write SetIconDisabledColor default clBtnShadow;
    property IconDownColor: TColor read FIconDownColor write SetIconDownColor default clIconDownColor;
    property IconHotColor: TColor read FIconHotColor write SetIconHotColor default clIconHotColor;
  end;

  TSCAdvGroupCaption = class(TPersistent)
  private
    FOwner: TSCCustomAdvGroup;
    FCloseButton: TImageIndex;
    FColor: TColor;
    FEndColor: TColor;
    FGradient: TSCGradient;
    FIcon: TImageIndex;
    FLineColor: TColor;
    FDownButton: TImageIndex;
    FUpButton: TImageIndex;
    FUnderline: Boolean;
    FLockChange: Boolean;
    FOnChange: TNotifyEvent;
    procedure SetCloseButton(Value: TImageIndex);
    procedure SetColor(Value: TColor);
    procedure SetEndColor(Value: TColor);
    procedure SetGradient(Value: TSCGradient);
    procedure SetIcon(Value: TImageIndex);
    procedure SetLineColor(Value: TColor);
    procedure SetDownButton(Value: TImageIndex);
    procedure SetUpButton(Value: TImageIndex);
    procedure SetUnderline(Value: Boolean);
  protected
    procedure LockChange;
    procedure UnlockChange;
    procedure DoChange; dynamic;

    function GetOwner: TPersistent; override;

    function GetImages: TCustomImageList;
    function GetIcons: TCustomImageList;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TSCCustomAdvGroup); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomAdvGroup read FOwner;
  published
    property CloseButton: TImageIndex read FCloseButton write SetCloseButton default -1;
    property Color: TColor read FColor write SetColor default clBtnHighlight;
    property EndColor: TColor read FEndColor write SetEndColor default clBtnFace;
    property Gradient: TSCGradient read FGradient write SetGradient default scgLeftToRight;
    property Icon: TImageIndex read FIcon write SetIcon default -1;
    property LineColor: TColor read FLineColor write SetLineColor default clHighlight;
    property DownButton: TImageIndex read FDownButton write SetDownButton default -1;
    property UpButton: TImageIndex read FUpButton write SetUpButton default -1;
    property Underline: Boolean read FUnderline write SetUnderline default False;
  end;

  TSCCaptionPart = (sccpNone, sccpCaption, sccpIcon, sccpClose, sccpRoll);

  TSCAdvGroupButton = (scgbClose, scgbDown, scgbUp);

  TSCGroupCaptionStyle = (scgcNone, scgcFlat, scgcRaised, scgc3DRaised,
    scgcSoft3D, scgcSoftRaised, scgcSoftFlat);

  TSCAdvGroupCaptionSettings = class(TPersistent)
  private
    FOwner: TSCCustomAdvGroup;
    function  GetButtonColors: TSCAdvGroupButtons;
    procedure SetButtonColors(Value: TSCAdvGroupButtons);
    function  GetCursor: TCursor;
    procedure SetCursor(Value: TCursor);
    function  GetDefaultButtons: Boolean;
    procedure SetDefaultButtons(Value: Boolean);
    function  GetDefaultIcon: Boolean;
    procedure SetDefaultIcon(Value: Boolean);
    function  GetDefaultProps: TSCAdvGroupCaption;
    procedure SetDefaultProps(Value: TSCAdvGroupCaption);
    function  GetDisabledFontColor: TColor;
    procedure SetDisabledFontColor(Value: TColor);
    function  GetDisabledProps: TSCAdvGroupCaption;
    procedure SetDisabledProps(Value: TSCAdvGroupCaption);
    function  GetDownFontColor: TColor;
    procedure SetDownFontColor(Value: TColor);
    function  GetFont: TFont;
    procedure SetFont(Value: TFont);
    function  GetHeight: Integer;
    procedure SetHeight(Value: Integer);
    function  GetHint: String;
    procedure SetHint(const Value: String);
    function  GetHotFontColor: TColor;
    procedure SetHotFontColor(Value: TColor);
    function  GetHotProps: TSCAdvGroupCaption;
    procedure SetHotProps(Value: TSCAdvGroupCaption);
    function  GetHottrack: Boolean;
    procedure SetHottrack(Value: Boolean);
    function  GetHottrackButtons: Boolean;
    procedure SetHottrackButtons(Value: Boolean);
    function  GetImages: TCustomImageList;
    procedure SetImages(Value: TCustomImageList);
    function  GetStyle: TSCGroupCaptionStyle;
    procedure SetStyle(Value: TSCGroupCaptionStyle);
  protected
    function  GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TSCCustomAdvGroup); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomAdvGroup read FOwner;
  published
    property ButtonColors: TSCAdvGroupButtons read GetButtonColors write SetButtonColors;
    property Cursor: TCursor read GetCursor write SetCursor default crHandPoint;
    property DefaultButtons: Boolean read GetDefaultButtons write SetDefaultButtons default True;
    property DefaultIcon: Boolean read GetDefaultIcon write SetDefaultIcon default True;
    property DefaultProps: TSCAdvGroupCaption read GetDefaultProps write SetDefaultProps;
    property DisabledFontColor: TColor read GetDisabledFontColor write SetDisabledFontColor default clPanelDisabledColor;
    property DisabledProps: TSCAdvGroupCaption read GetDisabledProps write SetDisabledProps;
    property DownFontColor: TColor read GetDownFontColor write SetDownFontColor default clPanelDownColor;
    property Font: TFont read GetFont write SetFont;
    property Height: Integer read GetHeight write SetHeight default -1;
    property Hint: String read GetHint write SetHint;
    property HotFontColor: TColor read GetHotFontColor write SetHotFontColor default clPanelHotColor;
    property HotProps: TSCAdvGroupCaption read GetHotProps write SetHotProps;
    property Hottrack: Boolean read GetHottrack write SetHottrack default True;
    property HottrackButtons: Boolean read GetHottrackButtons write SetHottrackButtons default True;
    property Images: TCustomImageList read GetImages write SetImages;
    property Style: TSCGroupCaptionStyle read GetStyle write SetStyle default scgcNone;
  end;

  TSCGroupCaptionEvent = procedure(Sender: TObject; X, Y: Integer;
    Part: TSCCaptionPart) of object;
  TSCGroupCaptionMouseEvent = procedure(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer; Part: TSCCaptionPart) of object;
  TSCGroupCaptionMouseMoveEvent = procedure(Sender: TObject;
    Shift: TShiftState; X, Y: Integer; Part: TSCCaptionPart) of object;

  TSCCustomAdvGroup = class(TSCCustomGroup)
  private
    FCanRoll: Boolean;
    FCaptionButtonColors: TSCAdvGroupButtons;
    FCaptionCursor: TCursor;
    FCaptionDisabledFontColor: TColor;
    FCaptionDownFontColor: TColor;
    FCaptionFont: TFont;
    FCaptionHint: String;
    FCaptionHeight: Integer;
    FCaptionHotFontColor: TColor;
    FCaptionProps: TSCAdvGroupCaption;
    FCaptionStyle: TSCGroupCaptionStyle;
    FCaptionSettings: TSCAdvGroupCaptionSettings;
    FDefaultButtons: Boolean;
    FDefaultIcon: Boolean;
    FDisabledCaptionProps: TSCAdvGroupCaption;
    FExpanded: Boolean;
    FExpandedHeight: Integer;
    FHotCaptionProps: TSCAdvGroupCaption;
    FHottrack: Boolean;
    FHottrackButtons: Boolean;
    FIcons: TCustomImageList;
    FIconChangeLink: TChangeLink;
    FIsCaptionHot: Boolean;
    FMxDefaultButtons: Boolean;
    FRectDefaultButtons: Boolean;
    FRounded: Boolean;
    FShowCaption: Boolean;
    FShowCaptionHint: Boolean;
    FShowCaptionLine: Boolean;
    FShowClose: Boolean;
    FShowIcon: Boolean;
    FShowRoller: Boolean;
    FShowCaptionUpLine: Boolean;
    FExpanding: Boolean;
    FDefaultCursor: TCursor;
    FUpdatingCursor: Boolean;
    FIsCaptionDown: Boolean;
    FRoundChanging: Boolean;
    FLastCaptionHeight: Integer;
    FOnExpand: TNotifyEvent;
    FOnCaptionClick: TSCGroupCaptionEvent;
    FOnCaptionMouseDown: TSCGroupCaptionMouseEvent;
    FOnCaptionMouseMove: TSCGroupCaptionMouseMoveEvent;
    FOnCaptionMouseUp: TSCGroupCaptionMouseEvent;
    procedure SetCaptionButtonColors(Value: TSCAdvGroupButtons);
    procedure SetCaptionCursor(Value: TCursor);
    procedure SetCaptionDisabledFontColor(Value: TColor);
    procedure SetCaptionDownFontColor(Value: TColor);
    procedure SetCaptionFont(Value: TFont);
    procedure SetCaptionHeight(Value: Integer);
    procedure SetCaptionHotFontColor(Value: TColor);
    procedure SetCaptionProps(Value: TSCAdvGroupCaption);
    procedure SetCaptionStyle(Value: TSCGroupCaptionStyle);
    procedure SetCaptionSettings(Value: TSCAdvGroupCaptionSettings);
    procedure SetDefaultButtons(Value: Boolean);
    procedure SetDefaultIcon(Value: Boolean);
    procedure SetDisabledCaptionProps(Value: TSCAdvGroupCaption);
    procedure SetExpanded(Value: Boolean);
    procedure SetExpandedHeight(Value: Integer);
    procedure SetHotCaptionProps(Value: TSCAdvGroupCaption);
    procedure SetHottrack(Value: Boolean);
    procedure SetHottrackButtons(Value: Boolean);
    procedure SetIcons(Value: TCustomImageList);
    procedure SetMxDefaultButtons(Value: Boolean);
    procedure SetRectDefaultButtons(Value: Boolean);
    procedure SetRounded(Value: Boolean);
    procedure SetShowCaption(Value: Boolean);
    procedure SetShowCaptionLine(Value: Boolean);
    procedure SetShowCaptionUpLine(Value: Boolean);
    procedure SetShowClose(Value: Boolean);
    procedure SetShowIcon(Value: Boolean);
    procedure SetShowRoller(Value: Boolean);

    procedure DoDrawClose(Cnv: TCanvas; C: TColor; R: TRect);
    procedure DoDrawDown(Cnv: TCanvas; C: TColor; R: TRect);
    procedure DoDrawUp(Cnv: TCanvas; C: TColor; R: TRect);
    procedure DoDrawIcon(Cnv: TCanvas; C: TColor; R: TRect);

    procedure CMCursorChanged(var Message: TMessage); message CM_CURSORCHANGED;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure CreateWnd; override;
    procedure PaintWindow(DC: HDC); override;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure AdjustClientRect(var Rect: TRect); override;

    procedure TransparentChanged; override;
    function  GetPictureRect(P: TPicture): TRect; override;
    procedure ImageListChange(Sender: TObject); override;

    procedure CaptureChanged(Captured: Boolean); override;
    procedure StopTracking; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure PaintCaption(DC: HDC); virtual;
    procedure DoDrawDefButton(Cnv: TCanvas; R: TRect; Button: TSCAdvGroupButton); virtual;
    procedure DoDrawCaption(Cnv: TCanvas); virtual;
    procedure DoDrawBevel(Cnv: TCanvas); virtual;

    procedure UpdateBorderRegion(UpdatePaint: Boolean = True);
    function  CaptionRoundation(R: TRect): Integer;
    function  CreateBorderRgn(R: TRect): HRGN;

    procedure ApplyStyle(S: TSCAdvPanelStyle; DoUpdate: Boolean); override;
    procedure UpdateCaptionFont(F: TFont); override;

    procedure TrackCaption(X, Y: Integer);
    procedure UpdateTracking; override;
    function  GetCurrentCursor: TCursor; dynamic;
    procedure UpdateCursor(UpTrack: Boolean);

    function  CanCollapse: Boolean; dynamic;
    function  CanExpand: Boolean; dynamic;

    procedure ButtonsChanged(Sender: TObject); dynamic;
    procedure CaptionChanged(Sender: TObject); dynamic;
    procedure IconsChanged(Sender: TObject); dynamic;

    function  CloseBtnHeight: Integer; dynamic;
    function  CloseBtnWidth: Integer; dynamic;
    function  IconHeight: Integer; dynamic;
    function  IconWidth: Integer; dynamic;
    function  RollBtnHeight: Integer; dynamic;
    function  RollBtnWidth: Integer; dynamic;

    function  GetIsButtonsHot: Boolean; dynamic;
    function  GetIsCaptionHot: Boolean; dynamic;

    function  CloseIndex: Integer;
    function  IconIndex: Integer;
    function  RollupIndex: Integer;
    function  RolldownIndex: Integer;
    function  IsValidIcon(Index: Integer): Boolean;

    function  RoundSize(Ch: Integer = -1): Integer; dynamic;
    function  CaptionFrameSize: Integer; dynamic;
    function  GetCaptionHeight: Integer; virtual;
    function  GetCollapsedHeight: Integer; virtual;
    function  GetExpandedHeight: Integer; virtual;

    function  GetCaptionRect(VisiblePart: Boolean): TRect; virtual;
    function  GetCaptionPart(X, Y: Integer): TSCCaptionPart; dynamic;

    property ShowCaption: Boolean read FShowCaption write SetShowCaption default True;
    property ShowCaptionLine: Boolean read FShowCaptionLine write SetShowCaptionLine default True;
    property ShowCaptionUpLine: Boolean read FShowCaptionUpLine write SetShowCaptionUpLine default False;
    property CanRoll: Boolean read FCanRoll write FCanRoll default True;
    property CaptionButtonColors: TSCAdvGroupButtons read FCaptionButtonColors write SetCaptionButtonColors;
    property CaptionCursor: TCursor read FCaptionCursor write SetCaptionCursor default crHandPoint;
    property CaptionDisabledFontColor: TColor read FCaptionDisabledFontColor write SetCaptionDisabledFontColor default clPanelDisabledColor;
    property CaptionDownFontColor: TColor read FCaptionDownFontColor write SetCaptionDownFontColor default clPanelDownColor;
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property CaptionHeight: Integer read FCaptionHeight write SetCaptionHeight default -1;
    property CaptionHint: String read FCaptionHint write FCaptionHint;
    property CaptionHotFontColor: TColor read FCaptionHotFontColor write SetCaptionHotFontColor default clPanelHotColor;
    property CaptionProps: TSCAdvGroupCaption read FCaptionProps write SetCaptionProps;
    property CaptionStyle: TSCGroupCaptionStyle read FCaptionStyle write SetCaptionStyle default scgcNone;
    property CaptionSettings: TSCAdvGroupCaptionSettings read FCaptionSettings write SetCaptionSettings;
    property DefaultButtons: Boolean read FDefaultButtons write SetDefaultButtons default True;
    property DefaultIcon: Boolean read FDefaultIcon write SetDefaultIcon default True;
    property DisabledCaptionProps: TSCAdvGroupCaption read FDisabledCaptionProps write SetDisabledCaptionProps;
    property Expanded: Boolean read FExpanded write SetExpanded default True;
    property ExpandedHeight: Integer read GetExpandedHeight write SetExpandedHeight default 165;
    property HotCaptionProps: TSCAdvGroupCaption read FHotCaptionProps write SetHotCaptionProps;
    property Hottrack: Boolean read FHottrack write SetHottrack default True;
    property HottrackButtons: Boolean read FHottrackButtons write SetHottrackButtons default True;
    property Icons: TCustomImageList read FIcons write SetIcons;
    property MxDefaultButtons: Boolean read FMxDefaultButtons write SetMxDefaultButtons default False;
    property RectDefaultButtons: Boolean read FRectDefaultButtons write SetRectDefaultButtons default False;
    property Rounded: Boolean read FRounded write SetRounded default True;
    property ShowCaptionHint: Boolean read FShowCaptionHint write FShowCaptionHint default False;
    property ShowClose: Boolean read FShowClose write SetShowClose default True;
    property ShowIcon: Boolean read FShowIcon write SetShowIcon default True;
    property ShowRoller: Boolean read FShowRoller write SetShowRoller default True;
    property LastCaptionHeight: Integer read FLastCaptionHeight;
    property OnCaptionClick: TSCGroupCaptionEvent read FOnCaptionClick write FOnCaptionClick;
    property OnCaptionMouseDown: TSCGroupCaptionMouseEvent read FOnCaptionMouseDown write FOnCaptionMouseDown;
    property OnCaptionMouseMove: TSCGroupCaptionMouseMoveEvent read FOnCaptionMouseMove write FOnCaptionMouseMove;
    property OnCaptionMouseUp: TSCGroupCaptionMouseEvent read FOnCaptionMouseUp write FOnCaptionMouseUp;
    property OnExpand: TNotifyEvent read FOnExpand write FOnExpand;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure UpdateCaption(DoRegionUpdate: Boolean);
  end;

  TSCAdvPanel = class(TSCCustomAdvGroup)
  published
    property ShowCaption;
    property ShowCaptionLine;
    property ShowCaptionUpLine;
    property Align;
    property Anchors;
    property Bevel;
    property BevelColor;
    property BevelDotted;
    property BevelEx;
    property BevelWidth;
    property BorderProps;
    property CanRoll;
    property Caption;
    property CaptionSettings;
    property Color;
    property Constraints;
    property UseDockManager;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndColor;
    property Expanded;
    property ExpandedHeight;
    property Gradient;
    property Icons;
    property IsMouseInControl;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property MxDefaultButtons;
    property RectDefaultButtons;
    property Rounded;
    property ShowCaptionHint;
    property ShowClose;
    property ShowHint;
    property ShowIcon;
    property ShowRoller;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseExGradient;
    property Style;
    property Visible;
    property OnCanResize;
    property OnCaptionClick;
    property OnCaptionMouseDown;
    property OnCaptionMouseMove;
    property OnCaptionMouseUp;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpand;
    property OnGetSiteInfo;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TSCGroupScrollBarView = (scsbShow, scsbHide);

  TSCGroupContainerScrollbar = class(TSCControlScrollbar)
  private
    function  GetWidth: Integer;
    procedure SetWidth(Value: Integer);
    function  GetStyle: TSCScrollbarStyle;
    procedure SetStyle(Value: TSCScrollbarStyle);
    function  GetButtonsLayout: TSCScrollButtonLayout;
    procedure SetButtonsLayout(Value: TSCScrollButtonLayout);
    function  GetThumbLines: TSCScrollThumbline;
    procedure SetThumbLines(Value: TSCScrollThumbline);
    function  GetType: TSCScrollbarType;
    procedure SetType(Value: TSCScrollbarType);
    function  GetShowState: TSCGroupScrollBarView;
    procedure SetShowState(Value: TSCGroupScrollBarView);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Background;
    property ButtonColors;
    property ButtonsLayout: TSCScrollButtonLayout read GetButtonsLayout write SetButtonsLayout default scsbDefault;
    property Icons;
    property Thumb;
    property ScrollbarType: TSCScrollbarType read GetType write SetType default scsbtSweet;
    property ShowState: TSCGroupScrollBarView read GetShowState write SetShowState default scsbShow;
    property SlideLine;
    property Style: TSCScrollbarStyle read GetStyle write SetStyle default scssDefault;
    property ThumbLines: TSCScrollThumbline read GetThumbLines write SetThumbLines default sctlNone;
    property Width: Integer read GetWidth write SetWidth default -1;
  end;

  TSCGroupBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccbLowered;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCGroupContainer = class(TSCCustomGroup)
  private
    FAutoScroll: Boolean;
    FExpandToTop: Boolean;
    FScrollBarView: TSCGroupScrollBarView;
    FLoaded: Boolean;
    FLockPosUpdate: Boolean;
    FScrolling: Boolean;
    FScrollPosition: Integer;
    FScrollPosChanging: Boolean;
    FScrollbarChanging: Boolean;
    function  GetScrollbar: TSCGroupContainerScrollbar;
    procedure SetScrollbar(Value: TSCGroupContainerScrollbar);
    procedure SetExpandToTop(Value: Boolean);
    procedure SetScrollBarView(Value: TSCGroupScrollBarView);

    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CMControlChange(var Message: TMessage); message CM_CONTROLCHANGE;

    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    procedure DoScrollerPositionChanged(Kind: TSCScrollbarKind); override;

    procedure ApplyStyle(S: TSCAdvPanelStyle; DoUpdate: Boolean); override;
    procedure IndentChanged; override;
    procedure SpacingChanged; override;

    procedure SetScrollPosition(Value: Integer); virtual;
    procedure ExpandChanged(P: TSCCustomAdvGroup); dynamic;
    function  GetScrollbarClass: TSCCustomControlScrollbarClass; override;
    function  GetDefaultScrollInfo(Kind: TSCScrollbarKind): TScrollInfo; override;

    function  GetGroupIndent: Integer; virtual;
    function  GetSpacing: Integer; virtual;

    function  CanShowScrollbar: Boolean; dynamic;
    function  GetScrollHeight: Integer;
    function  IsScrollBarVisible: Boolean;

    procedure ScrollInView(C: TControl);
    procedure ScrollControls(Delta: Integer);
    procedure ShowPanel(P: TSCCustomAdvGroup);

    function  NormalizeScrollPos(DoAlign: Boolean = True): Boolean; virtual;
    function  UpdateScrollBar: Boolean; virtual;
    procedure RepositionPanels(LockPos: Boolean);

    property ScrollHeight: Integer read GetScrollHeight;
    property ScrollBarView: TSCGroupScrollBarView read FScrollBarView write SetScrollBarView default scsbShow;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    function IsLastControl(C: TControl): Boolean;

    property ScrollPosition: Integer read FScrollPosition write SetScrollPosition;
  published
    property Align default alLeft;
    property Anchors;
    property AutoScroll: Boolean read FAutoScroll write FAutoScroll default True;
    property BorderProps;
    property Color default clBtnShadow;
    property Constraints;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndColor default cl3DDkShadow;
    property ExpandToTop: Boolean read FExpandToTop write SetExpandToTop default False;
    property Gradient default scgTopToBottom;
    property Indent default 8;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Scrollbar: TSCGroupContainerScrollbar read GetScrollbar write SetScrollbar;
    property ShowHint;
    property Spacing default 8;
    property TabOrder;
    property TabStop;
    property UseExGradient;
    property Style;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
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
    property OnUnDock;
  end;

  { TSCListGroup }

  TSCListGroup = class;
  TSCListGroupStyle = class;
  TSCListGroupStyleNotifier = class;

  TSCAlphaBlend = 0..255;

  TSCListGroupStyleEx = class(TPersistent)
  private
    FOwner: TSCListGroupStyle;
    FDisabledColor: TColor;
    FDisabledFontColor: TColor;
    FHotColor: TColor;
    FHotFontColor: TColor;
    FHottrack: Boolean;
    FHotUnderline: Boolean;
    procedure SetDisabledColor(Value: TColor);
    procedure SetDisabledFontColor(Value: TColor);
    procedure SetHotColor(Value: TColor);
    procedure SetHotFontColor(Value: TColor);
    procedure SetHottrack(Value: Boolean);
    procedure SetHotUnderline(Value: Boolean);
  protected
    procedure DoChange;
  public
    constructor Create(AOwner: TSCListGroupStyle); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCListGroupStyle read FOwner;
  published
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clNone;
    property DisabledFontColor: TColor read FDisabledFontColor write SetDisabledFontColor default clNone;
    property Hottrack: Boolean read FHottrack write SetHottrack default True;
    property HotColor: TColor read FHotColor write SetHotColor default clNone;
    property HotFontColor: TColor read FHotFontColor write SetHotFontColor default clBlue;
    property HotUnderline: Boolean read FHotUnderline write SetHotUnderline default True;
  end;

  TSCListGroupStyle = class(TComponent)
  private
    FAlphaBlend: TSCAlphaBlend;
    FColor: TColor;
    FEndColor: TColor;
    FExStyle: TSCListGroupStyleEx;
    FFont: TFont;
    FGradient: TSCGradient;
    FImageIndex: TImageIndex;
    FLargeImageIndex: TImageIndex;
    FImages: TCustomImageList;
    FLargeImages: TCustomImageList;
    FImageChangeLink: TChangeLink;
    FLargeImageChangeLink: TChangeLink;
    FChanged: Boolean;
    FUpdateCount: Integer;
    FNotifications: TList;
    procedure SetAlphaBlend(Value: TSCAlphaBlend);
    procedure SetColor(Value: TColor);
    procedure SetEndColor(Value: TColor);
    procedure SetExStyle(Value: TSCListGroupStyleEx);
    procedure SetFont(Value: TFont);
    procedure SetGradient(Value: TSCGradient);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetImages(Value: TCustomImageList);
    procedure SetLargeImageIndex(Value: TImageIndex);
    procedure SetLargeImages(Value: TCustomImageList);
    procedure Destroying;
  protected
    procedure Changed(Sender: TObject);

    procedure RegisterNotifier(N: TSCListGroupStyleNotifier);
    procedure UnregisterNotifier(N: TSCListGroupStyleNotifier);

    property AlphaBlend: TSCAlphaBlend read FAlphaBlend write SetAlphaBlend default 255; // for future
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure BeginUpdate;
    procedure EndUpdate;
    function  IsValidImage(Index: Integer): Boolean;
  published
    property Color: TColor read FColor write SetColor default clNone;
    property EndColor: TColor read FEndColor write SetEndColor default clNone;
    property ExStyle: TSCListGroupStyleEx read FExStyle write SetExStyle;
    property Font: TFont read FFont write SetFont;
    property Gradient: TSCGradient read FGradient write SetGradient default scgLeftToRight;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Images: TCustomImageList read FImages write SetImages;
    property LargeImageIndex: TImageIndex read FLargeImageIndex write SetLargeImageIndex default -1;
    property LargeImages: TCustomImageList read FLargeImages write SetLargeImages;
  end;

  TSCListGroupItem = class;

  TSCListGroupActionLink = class(TSCCollectionActionLink)
  protected
    FClient: TSCListGroupItem;
    procedure AssignClient(AClient: TObject); override;
    function  IsCaptionLinked: Boolean; override;
    function  IsCheckedLinked: Boolean; override;
    function  IsEnabledLinked: Boolean; override;
    function  IsHintLinked: Boolean; override;
    function  IsImageIndexLinked: Boolean; override;
    function  IsVisibleLinked: Boolean; override;
    function  IsOnExecuteLinked: Boolean; override;
    procedure SetCaption(const Value: string); override;
    procedure SetChecked(Value: Boolean); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetHint(const Value: string); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
  end;

  TSCListGroupActionLinkClass = class of TSCListGroupActionLink;

  TSCListGroupStyleNotifier = class(TObject)
  private
    FOwner: TObject;
    FStyle: TSCListGroupStyle;
    FOnChange: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
    FData: Pointer;
  public
    constructor Create(AOwner: TObject); virtual;

    property Data: Pointer read FData write FData;
    property Owner: TObject read FOwner;
    property Style: TSCListGroupStyle read FStyle;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
  end;

  TSCGroupItemViewStyle = (scvsLabel, scvsButton);

  TSCGroupItemLine = (scglNone, scglFlatLine, scglLoweredLine, scglRaisedLine);

  TSCListGroupItemStyle = class(TPersistent)
  private
    FOwner: TSCListGroupItem;
    FDisabledColor: TColor;
    FDisabledFontColor: TColor;
    FHotColor: TColor;
    FHotFontColor: TColor;
    FHottrack: Boolean;
    FHotUnderline: Boolean;
    procedure SetDisabledColor(Value: TColor);
    procedure SetDisabledFontColor(Value: TColor);
    procedure SetHotColor(Value: TColor);
    procedure SetHotFontColor(Value: TColor);
    procedure SetHottrack(Value: Boolean);
    procedure SetHotUnderline(Value: Boolean);
  protected
    procedure DoChange;
  public
    constructor Create(AOwner: TSCListGroupItem); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCListGroupItem read FOwner;
  published
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clNone;
    property DisabledFontColor: TColor read FDisabledFontColor write SetDisabledFontColor default clNone;
    property Hottrack: Boolean read FHottrack write SetHottrack default True;
    property HotColor: TColor read FHotColor write SetHotColor default clNone;
    property HotFontColor: TColor read FHotFontColor write SetHotFontColor default clBlue;
    property HotUnderline: Boolean read FHotUnderline write SetHotUnderline default True;
  end;

  TSCListGroupItem = class(TSCCollectionItem)
  private
    FAlignment: TAlignment;
    FCaption: string;
    FColor: TColor;
    FData: TObject;
    FEnabled: Boolean;
    FExStyle: TSCListGroupItemStyle;
    FHint: String;
    FImageIndex: TImageIndex;
    FIndent: Integer;
    FLine: TSCGroupItemLine;
    FLineColor: TColor;
    FLargeImageIndex: TImageIndex;
    FSelected: Boolean;
    FStyle: TSCListGroupStyle;
    FViewStyle: TSCGroupItemViewStyle;
    FVisible: Boolean;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnHottrack: TNotifyEvent;
    FOnMouseDown: TNotifyEvent;
    FOnMouseUp: TNotifyEvent;
    FOnSelect: TNotifyEvent;
    FActionLink: TSCListGroupActionLink;
    FDestroying: Boolean;
    FNotifier: TSCListGroupStyleNotifier;
    function  GetAction: TBasicAction;
    procedure SetAction(const Value: TBasicAction);
    procedure SetAlignment(Value: TAlignment);
    procedure SetCaption(const Value: string);
    procedure SetColor(Value: TColor);
    procedure SetEnabled(Value: Boolean);
    procedure SetExStyle(Value: TSCListGroupItemStyle);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetIndent(Value: Integer);
    procedure SetLine(Value: TSCGroupItemLine);
    procedure SetLineColor(Value: TColor);
    procedure SetLargeImageIndex(Value: TImageIndex);
    procedure SetSelected(Value: Boolean);
    procedure SetStyle(Value: TSCListGroupStyle);
    procedure SetViewStyle(Value: TSCGroupItemViewStyle);
    procedure SetVisible(Value: Boolean);

    procedure SelectionChanged;
    procedure RegisterTo(S: TSCListGroupStyle);
    procedure UnregisterFrom(S: TSCListGroupStyle);
  protected
    function  GetDisplayName: string; override;

    function  IsCaptionStored: Boolean;
    function  IsEnabledStored: Boolean;
    function  IsHintStored: Boolean;
    function  IsImageIndexStored: Boolean;
    function  IsOnClickStored: Boolean;
    function  IsVisibleStored: Boolean;
    procedure DoActionChange(Sender: TObject);

    function  GetListGroup: TSCListGroup;
    function  OwnerState: TComponentState;
    function  GetImages: TCustomImageList;
    function  GetLargeImages: TCustomImageList;

    function  GetActionLinkClass: TSCListGroupActionLinkClass; dynamic;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); dynamic;

    procedure DoChanged(FullRefresh: Boolean);
    procedure StyleChanged(Sender: TObject); dynamic;
    procedure StyleDestroyed(Sender: TObject); dynamic;

    property ActionLink: TSCListGroupActionLink read FActionLink write FActionLink;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify; // for future
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Destroying: Boolean read FDestroying;
    property Data: TObject read FData write FData;
  published
    property Action: TBasicAction read GetAction write SetAction;
    property Caption: string read FCaption write SetCaption stored IsCaptionStored;
    property Color: TColor read FColor write SetColor default clNone;
    property Enabled: Boolean read FEnabled write SetEnabled stored IsEnabledStored default True;
    property ExStyle: TSCListGroupItemStyle read FExStyle write SetExStyle;
    property Hint: String read FHint write FHint stored IsHintStored;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex stored IsImageIndexStored default -1;
    property Indent: Integer read FIndent write SetIndent default 0;
    property Line: TSCGroupItemLine read FLine write SetLine default scglNone;
    property LineColor: TColor read FLineColor write SetLineColor default clBlack;
    property LargeImageIndex: TImageIndex read FLargeImageIndex write SetLargeImageIndex default -1;
    property Selected: Boolean read FSelected write SetSelected default False;
    property Style: TSCListGroupStyle read FStyle write SetStyle;
    property ViewStyle: TSCGroupItemViewStyle read FViewStyle write SetViewStyle default scvsButton;
    property Visible: Boolean read FVisible write SetVisible stored IsVisibleStored default True;

    property OnClick: TNotifyEvent read FOnClick write FOnClick stored IsOnClickStored;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnHottrack: TNotifyEvent read FOnHottrack write FOnHottrack;
    property OnMouseDown: TNotifyEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TNotifyEvent read FOnMouseUp write FOnMouseUp;
    property OnSelect: TNotifyEvent read FOnSelect write FOnSelect;
  end;

  TSCListGroupItems = class(TCollection)
  private
    FOwner: TSCListGroup;
    function  GetItem(Index: Integer): TSCListGroupItem;
    procedure SetItem(Index: Integer; Value: TSCListGroupItem);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(ListGroup: TSCListGroup);
    function Add: TSCListGroupItem;
    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCListGroup read FOwner;
    {$ENDIF}
    property Items[Index: Integer]: TSCListGroupItem read GetItem write SetItem; default;
  end;

  TSCListImageStyle = (scisSmall, scisLarge);

  TSCListItemState = (scstDefault, scstUnknown, scstDisabled, scstInvisible,
    scstHotTracked, scstPressed, scstSelected, scstFocused);

  TSCGroupButtonStyle = (scbsNone, scbsButton2k, scbsButtonSp, scbsButtonEx,
    scbsButtonNew, scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew);

  TSCListGroupScrollers = class;

  TSCListGroupScroller = class(TPersistent)
  private
    FOwner: TSCListGroupScrollers;
    FEnabled: Boolean;
    FArrowDefault: TColor;
    FArrowDisabled: TColor;
    FArrowHot: TColor;
    FArrowPressed: TColor;
    FColorDefault: TColor;
    FColorDisabled: TColor;
    FColorHot: TColor;
    FColorPressed: TColor;
    FImageDefault: TImageIndex;
    FImageDisabled: TImageIndex;
    FImageHot: TImageIndex;
    FImagePressed: TImageIndex;
    procedure SetArrowDefault(Value: TColor);
    procedure SetArrowDisabled(Value: TColor);
    procedure SetArrowHot(Value: TColor);
    procedure SetArrowPressed(Value: TColor);
    procedure SetColorDefault(Value: TColor);
    procedure SetColorDisabled(Value: TColor);
    procedure SetColorHot(Value: TColor);
    procedure SetColorPressed(Value: TColor);
    procedure SetImageDefault(Value: TImageIndex);
    procedure SetImageDisabled(Value: TImageIndex);
    procedure SetImageHot(Value: TImageIndex);
    procedure SetImagePressed(Value: TImageIndex);
    procedure SetEnabled(Value: Boolean);
  protected
    procedure DoChange;
    function  GetImages: TCustomImageList;

    property Enabled: Boolean read FEnabled write SetEnabled default True;
  public
    constructor Create(AOwner: TSCListGroupScrollers); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCListGroupScrollers read FOwner;
  published
    property ArrowDefault: TColor read FArrowDefault write SetArrowDefault default clBtnText;
    property ArrowDisabled: TColor read FArrowDisabled write SetArrowDisabled default clBtnShadow;
    property ArrowHot: TColor read FArrowHot write SetArrowHot default clBtnText;
    property ArrowPressed: TColor read FArrowPressed write SetArrowPressed default clBtnText;
    property ColorDefault: TColor read FColorDefault write SetColorDefault default clBtnFace;
    property ColorDisabled: TColor read FColorDisabled write SetColorDisabled default clBtnFace;
    property ColorHot: TColor read FColorHot write SetColorHot default clBtnFace;
    property ColorPressed: TColor read FColorPressed write SetColorPressed default clBtnFace;
    property ImageDefault: TImageIndex read FImageDefault write SetImageDefault default -1;
    property ImageDisabled: TImageIndex read FImageDisabled write SetImageDisabled default -1;
    property ImageHot: TImageIndex read FImageHot write SetImageHot default -1;
    property ImagePressed: TImageIndex read FImagePressed write SetImagePressed default -1;
  end;

  TSCListGroupScrollers = class(TPersistent)
  private
    FOwner: TSCListGroup;
    FDownScroller: TSCListGroupScroller;
    FUpScroller: TSCListGroupScroller;
    FVisible: Boolean;
    procedure SetDownScroller(Value: TSCListGroupScroller);
    procedure SetUpScroller(Value: TSCListGroupScroller);
    procedure SetVisible(Value: Boolean);
  protected
    procedure DoChange(VisibleChange: Boolean);
    procedure DownEnabled(Value: Boolean);
    procedure UpEnabled(Value: Boolean);
    property  Visible: Boolean read FVisible write SetVisible default False;
  public
    constructor Create(AOwner: TSCListGroup); virtual;
    destructor Destroy; override;

    property Owner: TSCListGroup read FOwner;
  published
    property DownScroller: TSCListGroupScroller read FDownScroller write SetDownScroller;
    property UpScroller: TSCListGroupScroller read FUpScroller write SetUpScroller;
  end;

  TSCListScrollButton = (scsbNone, scsbDisabled, scsbUp, scsbDown);

  TSCGroupItemEvent = procedure(Sender: TObject; AItem: Integer) of object;

  TSCListGroup = class(TSCCustomAdvGroup)
  private
    FItems: TSCListGroupItems;
    FAllowAllUp: Boolean;
    FButtonStyle: TSCGroupButtonStyle;
    FCanSelect: Boolean;
    FCanMultiSelect: Boolean;
    FHottrackCursor: TCursor;
    FImageStyle: TSCListImageStyle;
    FItemSpace: Integer;
    FLargeImages: TCustomImageList;
    FLargeImageChangeLink: TChangeLink;
    FScrollers: TSCListGroupScrollers;
    FScrollerImages: TCustomImageList;
    FScrollerImageChangeLink: TChangeLink;
    FShowFocusRect: Boolean;
    FShowImages: Boolean;
    FShowItemHint: Boolean;
    FSmallImages: TCustomImageList;
    FSmallImageChangeLink: TChangeLink;
    FWordWrap: Boolean;
    FHotItem: Integer;
    FClickedItem: Integer;
    FMouseDownItem: Integer;
    FHotClickItem: Integer;
    FFocusedItem: Integer;
    FTopItem: Integer;
    FItemDblClicked: Boolean;
    FHotButton: TSCListScrollButton;
    FClickedButton: TSCListScrollButton;
    FScrolling: Boolean;
    FScrollTimer: Integer;
    FScrollTopItem: Integer;
    FOnScroll: TNotifyEvent;
    FOnItemClick: TSCGroupItemEvent;
    FOnItemDblClick: TSCGroupItemEvent;
    FOnItemHottrack: TSCGroupItemEvent;
    FOnItemMouseDown: TSCGroupItemEvent;
    FOnItemMouseUp: TSCGroupItemEvent;
    FOnItemSelect: TSCGroupItemEvent;
    FSpaceDown: Boolean;
    procedure SetButtonStyle(Value: TSCGroupButtonStyle);
    procedure SetCanSelect(Value: Boolean);
    procedure SetCanMultiSelect(Value: Boolean);
    procedure SetHottrackCursor(Value: TCursor);
    procedure SetImageStyle(Value: TSCListImageStyle);
    procedure SetItems(Value: TSCListGroupItems);
    procedure SetItemSpace(Value: Integer);
    procedure SetLargeImages(Value: TCustomImageList);
    procedure SetScrollers(Value: TSCListGroupScrollers);
    procedure SetScrollerImages(Value: TCustomImageList);
    procedure SetShowFocusRect(Value: Boolean);
    procedure SetShowImages(Value: Boolean);
    procedure SetSmallImages(Value: TCustomImageList);
    procedure SetTopItem(Index: Integer);
    procedure SetWordWrap(Value: Boolean);

    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;

    procedure SelectionChanged(Sender: TSCListGroupItem);
    procedure StartScrolling;
    procedure ScrollGroup;
    procedure StopScrolling;
  protected
    procedure Paint; override;
    procedure AdjustSize; override;
    procedure AdjustBounds; override;

    procedure ApplyStyle(S: TSCAdvPanelStyle; DoUpdate: Boolean); override;

    procedure DoScrolled; dynamic;
    procedure DoItemClick(AItem: Integer); dynamic;
    procedure DoItemDblClick(AItem: Integer); dynamic;
    procedure DoItemHottrack(AItem: Integer); dynamic;
    procedure DoItemMouseDown(AItem: Integer); dynamic;
    procedure DoItemMouseUp(AItem: Integer); dynamic;
    procedure DoItemSelect(AItem: Integer); dynamic;

    function  CanAdjustSize: Boolean;

    procedure ApplyMouseMove(Shift: TShiftState; X, Y: Integer); dynamic;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure ProcessGroupKey(var Key: Word; IsKeyPress: Boolean);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;

    procedure CaptureChanged(Captured: Boolean); override;
    procedure StopTracking; override;
    function  GetCurrentCursor: TCursor; override;

    procedure ValidateTopItemIndex(var Indx: Integer);
    procedure ValidateItemIndex(var Indx: Integer);

    function  GetFullHeight: Integer; dynamic;
    procedure UpdateHeight; dynamic;
    function  UpdateScrollers: Boolean; dynamic;

    function  IsValidItem(Index: Integer): Boolean;
    function  IsMultiLine: Boolean; dynamic;

    function  GetBevelSize: TImageIndex; virtual;
    function  GetImageIndex(Index: Integer): TImageIndex; reintroduce; virtual;
    function  GetImageList(Index: Integer): TCustomImageList; virtual;
    function  GetImageStyle(Index: Integer): TSCListImageStyle; virtual;

    function  SharpenRect(R: TRect; I: Integer): TRect;
    function  GetItemHeight(Index: Integer; W: Integer = -1): Integer; virtual;

    function  GetItemTextFlags(CalcRect: Boolean; Index: Integer = -1): Integer; dynamic;
    procedure DoDrawItemText(Cnv: TCanvas; Text: String;
      F: TFont; var R: TRect; CalcRect: Boolean; Index: Integer = -1); virtual;

    procedure DoDrawScrollers; virtual;
    procedure DoDrawItem(Index: Integer; var R: TRect; Calculate: Boolean = False); virtual;
    procedure DoDrawItems; virtual;

    function  CanIndent(Index: Integer): Boolean;
    function  CanDrawFocusRect: Boolean; dynamic;
    function  IsHotItem(Index: Integer): Boolean;
    procedure AdjustItemRect(var R: TRect); dynamic;

    function  CanScroll(AsUp: Boolean): Boolean;
    function  Scrolling: Boolean;
    function  ScrollPaused: Boolean;
    procedure PauseScrolling;
    procedure ResumeScrolling;

    procedure ItemChanged(Item: TSCListGroupItem); dynamic;
    procedure ItemsChanged; dynamic;
    procedure StyleChanged(S: TSCListGroupStyle); dynamic;
    procedure StylesChanged; dynamic;
    procedure StyleDestroyed(S: TSCListGroupStyle); dynamic;
    procedure LargeImagesChanged(Sender: TObject); dynamic;
    procedure SmallImagesChanged(Sender: TObject); dynamic;
    procedure ScrollerImagesChanged(Sender: TObject);
    procedure GroupScrollerChanged(Sender: TSCListGroupScrollers; FullRefresh: Boolean); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  GetItemFont(Index: Integer): TFont; virtual;
    function  GetItemState(Index: Integer): TSCListItemState; virtual;
    function  GetItemStyle(Index: Integer): TSCListGroupStyle; virtual;

    function  IsItemInView(Indx: Integer; FullView: Boolean): Boolean;
    function  GetRectAndItem(P: TPoint; var Index: Integer; Sharpen: Boolean;
      IntersectClient: Boolean = True): TRect;
    function  GetItemRect(P: TPoint; Sharpen: Boolean; IntersectClient: Boolean = True): TRect; overload;
    function  GetItemRect(Index: Integer; Sharpen: Boolean; IntersectClient: Boolean = True): TRect; overload;
    function  GetItemAtPos(P: TPoint; IntersectClient: Boolean = True): Integer;

    function  GetScrollerAtPos(P: TPoint): TSCListScrollButton;

    property HotItem: Integer read FHotItem;
    property ClickedItem: Integer read FClickedItem;
    property FocusedItem: Integer read FFocusedItem;
    property TopItem: Integer read FTopItem write SetTopItem default 0;
  published
    property ShowCaption;
    property ShowCaptionLine;
    property ShowCaptionUpLine;
    property Align;
    property AllowAllUp: Boolean read FAllowAllUp write FAllowAllUp default False;
    property Anchors;
    property AutoSize;
    property Bevel;
    property BevelColor;
    property BevelDotted;
    property BevelEx;
    property BevelWidth;
    property BorderProps;
    property ButtonStyle: TSCGroupButtonStyle read FButtonStyle write SetButtonStyle default scbsButtonSp;
    property CanRoll;
    property CanMultiSelect: Boolean read FCanMultiSelect write SetCanMultiSelect default False;
    property CanSelect: Boolean read FCanSelect write SetCanSelect default True;
    property Caption;
    property CaptionSettings;
    property Color;
    property Constraints;
    property UseDockManager;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndColor;
    property Expanded;
    property ExpandedHeight;
    property Font;
    property Gradient;
    property HottrackCursor: TCursor read FHottrackCursor write SetHottrackCursor default crHandPoint;
    property Icons;
    property ImageStyle: TSCListImageStyle read FImageStyle write SetImageStyle default scisSmall;
    property Indent;
    property IsMouseInControl;
    property Items: TSCListGroupItems read FItems write SetItems;
    property ItemSpace: Integer read FItemSpace write SetItemSpace default 8;
    property LargeImages: TCustomImageList read FLargeImages write SetLargeImages;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property MxDefaultButtons;
    property RectDefaultButtons;
    property PopupMenu;
    property Rounded;
    property Scrollers: TSCListGroupScrollers read FScrollers write SetScrollers;
    property ScrollerImages: TCustomImageList read FScrollerImages write SetScrollerImages;
    property ShowCaptionHint;
    property ShowClose;
    property ShowFocusRect: Boolean read FShowFocusRect write SetShowFocusRect default True;
    property ShowHint;
    property ShowIcon;
    property ShowImages: Boolean read FShowImages write SetShowImages default True;
    property ShowItemHint: Boolean read FShowItemHint write FShowItemHint default False;
    property ShowRoller;
    property SmallImages: TCustomImageList read FSmallImages write SetSmallImages;
    property Spacing;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseExGradient;
    property Visible;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property Style;
    property OnCanResize;
    property OnCaptionClick;
    property OnCaptionMouseDown;
    property OnCaptionMouseMove;
    property OnCaptionMouseUp;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpand;
    property OnGetSiteInfo;
    property OnItemClick: TSCGroupItemEvent read FOnItemClick write FOnItemClick;
    property OnItemDblClick: TSCGroupItemEvent read FOnItemDblClick write FOnItemDblClick;
    property OnItemHottrack: TSCGroupItemEvent read FOnItemHottrack write FOnItemHottrack;
    property OnItemMouseDown: TSCGroupItemEvent read FOnItemMouseDown write FOnItemMouseDown;
    property OnItemMouseUp: TSCGroupItemEvent read FOnItemMouseUp write FOnItemMouseUp;
    property OnItemSelect: TSCGroupItemEvent read FOnItemSelect write FOnItemSelect;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnScroll: TNotifyEvent read FOnScroll write FOnScroll;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation

const
  SC_GROUP_SCROLLTIMERID = 3210;

{ TSCCustomGroup }

procedure TSCCustomGroup.AdjustClientRect(var Rect: TRect);
var
  B: Integer;
begin
  inherited AdjustClientRect(Rect);

  B := BevelSize + BevelWidth;
  InflateRect(Rect, -B, -B);

  if Rect.Bottom < Rect.Top then
    Rect.Bottom := Rect.Top;

  if Rect.Right < Rect.Left then
    Rect.Right := Rect.Left;
end;

procedure TSCCustomGroup.ApplyStyle(S: TSCAdvPanelStyle; DoUpdate: Boolean);
begin
  if S = scasCustom then Exit;

  case S of
    scasExplorerBar:
    begin
      FBevel       := sccbFlat;
      FBevelColor  := clBtnFace;
      FBevelDotted := False;
      FBevelEx     := True;
      FBevelWidth  := 0;
      FEndColor    := clExplorerColor;
      FGradient    := scgNone;
      Color        := clExplorerColor;
    end;
    scasMXBar:
    begin
      FBevel      := sccbNone;
      FBevelWidth := 0;
      FGradient   := scgNone;
      Color       := clBtnShadow;
    end;
    scasAdvXPBar:
    begin
      FBevel       := sccbFlat;
      FBevelColor  := clBtnHighlight;
      FBevelDotted := False;
      FBevelEx     := True;
      FBevelWidth  := 0;
      FEndColor    := clAdvXPBarColor;
      FGradient    := scgNone;
      Color        := clAdvXPBarColor;
    end;
    scasXPBar:
    begin
      FBevel       := sccbFlat;
      FBevelColor  := clBtnHighlight;
      FBevelDotted := False;
      FBevelEx     := True;
      FBevelWidth  := 0;
      FEndColor    := clBtnHighlight;
      FGradient    := scgNone;
      Color        := clBtnFace;
    end;
    scasOutlookBar,
    scasOutlookBar2k, scasOfficeXP, scasOutlookBarXP:
    begin
      FBevel := sccbNone;
      FBevelWidth := 0;
      FGradient := scgNone;

      if S in [scasOfficeXP, scasOutlookBarXP] then
        Color := clSilver
      else
        Color := clBtnShadow;
    end;
    scasTaskList:
    begin
      FBevel       := sccbFlat;
      FBevelColor  := clHighlight;
      FBevelDotted := True;
      FBevelEx     := True;
      FBevelWidth  := 0;
      FEndColor    := clWindow;
      FGradient    := scgNone;
      Color        := clWindow;
    end;
  end;

  if DoUpdate then
  begin
    Realign;
    Invalidate;
  end;
end;

procedure TSCCustomGroup.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomGroup then
  begin
    with TSCCustomGroup(Source) do
    begin
      Self.Bevel := Bevel;
      Self.BevelColor := BevelColor;
      Self.BevelDotted := BevelDotted;
      Self.BevelEx := BevelEx;
      Self.BevelWidth := BevelWidth;
      Self.EndColor := EndColor;
      Self.Gradient := Gradient;
      Self.Picture := Picture;
      Self.UseExGradient := UseExGradient;
      Self.Style := Style;
    end;
  end;
end;

function TSCCustomGroup.BevelSize: Integer;
begin
  Result := 0;
  if FBevel in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
    Result := 1
  else
  if FBevel in [sccbFlatBold, sccbFlatRounded, sccbFlatBoldRounded,
    sccb3DRaised, sccb3DLowered, sccbBumped, sccbEtched, sccbMacLowered,
    sccbMacRaised, sccbMetal, sccbSoftLowered, sccbSoftRaised] then
    Result := 2;
end;

function TSCCustomGroup.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := (not FAutoSizeDocking) and inherited CanAutoSize(NewWidth, NewHeight);
end;

function TSCCustomGroup.CanGetFocus: Boolean;
{var
  H: HWND;
  W: TWinControl;}
begin
  Result := inherited CanGetFocus;

  {if Result then
  begin
    H := GetFocus;

    if (H <> 0) and (H <> Handle) then
    begin
      W := FindControl(H);
      Result := not IsOneOfParents(W, Self);
    end;
  end;}
end;

procedure TSCCustomGroup.CMDockClient(var Message: TCMDockClient);
var
  R: TRect;
  Dim: Integer;
begin
  if AutoSize then
  begin
    FAutoSizeDocking := True;
    try
      R := Message.DockSource.DockRect;
      case Align of
        alLeft: if Width = 0 then Width := R.Right - R.Left;
        alRight: if Width = 0 then
          begin
            Dim := R.Right - R.Left;
            SetBounds(Left - Dim, Top, Dim, Height);
          end;
        alTop: if Height = 0 then Height := R.Bottom - R.Top;
        alBottom: if Height = 0 then
          begin
            Dim := R.Bottom - R.Top;
            SetBounds(Left, Top - Dim, Width, Dim);
          end;
      end;
      inherited;
      Exit;
    finally
      FAutoSizeDocking := False;
    end;
  end;
  inherited;
end;

procedure TSCCustomGroup.CMMouseEnter(var Message: TMessage);
begin
  inherited;

  if not IsDesigning and not FIsMouseInControl and Enabled and
    (DragMode <> dmAutomatic) and (GetCapture = 0) then
    FIsMouseInControl := True;
end;

procedure TSCCustomGroup.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if not IsDesigning then
    FIsMouseInControl := False;
end;

constructor TSCCustomGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csOpaque, csDoubleClicks, csReplicatable];

  SetBounds(Left, Top, 185, 41);
  Color := clBtnFace;

  FBevel := sccbFlat;
  FBevelColor := clBtnHighlight;
  FBevelEx := True;
  FBevelWidth := 0;
  FEndColor := clBtnHighlight;
  FGradient := scgNone;
end;

procedure TSCCustomGroup.DoDrawCaptionText(Cnv: TCanvas; var R: TRect; CalcRect: Boolean);
var
  Text: String;
  TxtFlags: Integer;
begin
  if Cnv = nil then
    Cnv := Canvas;

  if (Cnv = nil) or IsRectEmpty(R) or
    not CanGetClientRect then Exit;

  Text := GetPanelCaption;

  if CalcRect and ((Text = '') or ((Length(Text) > 1) and
    (Text[1] = '&') and (Text[2] = #0))) then
    Text := Text + ' ';

  TxtFlags := DT_LEFT or DT_SINGLELINE or DT_EXPANDTABS;

  if CalcRect then
    TxtFlags := TxtFlags or DT_TOP or DT_CALCRECT
  else
    TxtFlags := TxtFlags or DT_END_ELLIPSIS or DT_VCENTER;

  TxtFlags := DrawTextBiDiModeFlags(TxtFlags);

  with Cnv do
  begin
    Brush.Style := bsClear;

    Font := Self.Font;
    UpdateCaptionFont(Cnv.Font);

    DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);
  end;
end;

function TSCCustomGroup.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomGroup.GetPanelCaption: String;
begin
  Result := Caption;
end;

function TSCCustomGroup.GetPicturePropsClass: TSCCustomPicturePropsClass;
begin
  Result := TSCAdvPanelPictureProps;
end;

function TSCCustomGroup.HasGradient: Boolean;
begin
  Result := (FEndColor <> clNone) and
    (FEndColor <> Color) and (FGradient <> scgNone);
end;

function TSCCustomGroup.IsOutlookStyle: Boolean;
begin
  Result := FStyle in [scasOfficeXP, scasOutlookBar,
    scasOutlookBar2k, scasOutlookBarXP];
end;

procedure TSCCustomGroup.Paint;
var
  CR: TRect;
  C1, C2: TColor;
  CCnt: Integer;
begin
  CR := GetClientRect;
  if IsRectEmpty(CR) then Exit;

  with Canvas do
  begin
    if (FGradient <> scgNone) and (FEndColor <> clNone) then
    begin
      C1 := Self.Color;
      C2 := FEndColor;

      if FUseExGradient then
        scDrawGradient(Canvas, CR, FGradient, C1, C2)
      else begin
        CCnt := CR.Right - CR.Left;
        if FGradient in [scgTopToBottom, scgBottomToTop] then
          CCnt := CR.Bottom - CR.Top;

        if CCnt <= 100 then
          CCnt := 10
        else
        if CCnt <= 300 then
          CCnt := 20
        else
        if CCnt <= 600 then
          CCnt := 30
        else
          CCnt := 40;

        scFillGradientRect(Canvas, CR, CCnt, FGradient, C1, C2)
      end;
    end else
    begin
      Brush.Style := bsSolid;
      Brush.Color := Self.Color;

      FillRect(CR);
    end;
  end;

  DrawPicture(Canvas);
end;

procedure TSCCustomGroup.SetBevel(Value: TSCControlBevel);
begin
  if FBevel <> Value then
  begin
    FBevel := Value;
    DoChange;
    Realign;
    Invalidate;
  end;
end;

procedure TSCCustomGroup.SetBevelColor(Value: TColor);
begin
  if FBevelColor <> Value then
  begin
    FBevelColor := Value;
    DoChange;
    if FBevelEx and (FBevel <> sccbNone) then
      Invalidate;
  end;
end;

procedure TSCCustomGroup.SetBevelDotted(Value: Boolean);
begin
  if FBevelDotted <> Value then
  begin
    FBevelDotted := Value;
    DoChange;
    if FBevel in [sccbFlat, sccbFlatBold, sccbFlatRounded,
      sccbFlatBoldRounded, sccbColor] then
      Invalidate;
  end;
end;

procedure TSCCustomGroup.SetBevelEx(Value: Boolean);
begin
  if FBevelEx <> Value then
  begin
    FBevelEx := Value;
    DoChange;
    if FBevel <> sccbNone then
      Invalidate;
  end;
end;

procedure TSCCustomGroup.SetBevelWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FBevelWidth <> Value then
  begin
    FBevelWidth := Value;
    DoChange;

    Realign;
    Invalidate;
  end;
end;

procedure TSCCustomGroup.SetEndColor(Value: TColor);
begin
  if FEndColor <> Value then
  begin
    FEndColor := Value;
    DoChange;
    if FGradient <> scgNone then
      Invalidate;
  end;
end;

procedure TSCCustomGroup.SetGradient(Value: TSCGradient);
begin
  if FGradient <> Value then
  begin
    FGradient := Value;
    DoChange;
    if FEndColor <> clNone then
      Invalidate;
  end;
end;

procedure TSCCustomGroup.SetStyle(Value: TSCAdvPanelStyle);
var
  P: TControl;
begin
  P := Parent;

  if (P <> nil) and (P is TSCCustomGroup) and
    (TSCCustomGroup(P).Style <> scasCustom) then
    Value := TSCCustomGroup(P).Style;

  if FStyle <> Value then
  begin
    FInStyleChange := True;
    FSettingStyle := True;

    try
      FStyle := Value;
      if not IsLoading then
        ApplyStyle(FStyle, True);
    finally
      FSettingStyle := False;
      FInStyleChange := False;
    end;
  end;
end;

procedure TSCCustomGroup.SetUseExGradient(Value: Boolean);
begin
  if FUseExGradient <> Value then
  begin
    FUseExGradient := Value;
    if (FGradient <> scgNone) and (FEndColor <> clNone) then
      Invalidate;
  end;
end;

procedure TSCCustomGroup.UpdateCaptionFont(F: TFont);
begin
  // 
end;

procedure TSCCustomGroup.UpdateTracking;
var
  P: TPoint;
begin
  if Enabled then
  begin
    GetCursorPos(P);

    FIsMouseInControl := not (FindDragTarget(P, True) = Self);
    if FIsMouseInControl then
      Perform(CM_MOUSELEAVE, 0, 0)
    else
      Perform(CM_MOUSEENTER, 0, 0);
  end;
end;

procedure TSCCustomGroup.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1;
end;

{ TSCCustomAdvGroup }

procedure TSCCustomAdvGroup.AdjustClientRect(var Rect: TRect);
var
  B, Ch: Integer;
begin
  inherited AdjustClientRect(Rect);

  if FShowCaption then
  begin
    B  := BevelSize + BevelWidth;
    Ch := GetCaptionHeight;

    if Ch > B then
      Inc(Rect.Top, Ch - B);
  end;

  if Rect.Bottom < Rect.Top then
    Rect.Bottom := Rect.Top;

  if Rect.Right < Rect.Left then
    Rect.Right := Rect.Left;
end;

procedure TSCCustomAdvGroup.AlignControls(AControl: TControl;
  var Rect: TRect);

  function ShiftValue: Integer;
  var
    C: TControl;
    I: Integer;
    R: TRect;
    InDesign: Boolean;
  begin
    Result := 0;
    if Expanded then Exit;

    InDesign := IsDesigning;

    R := Rect;

    Inc(R.Top);
    if R.Top > R.Bottom then
      R.Bottom := R.Top;

    for I := ControlCount - 1 downto 0 do
    begin
      C := Controls[I];

      if (InDesign or C.Visible) and
        (C.Top < R.Top) and (R.Top - C.Top > Result) and
        ((C.Align <> alNone) or (C.Anchors <> [akLeft, akTop])) then
        Result := R.Top - C.Top;
    end;

    if Result > 0 then Inc(Result, 2);
  end;

  procedure ShiftControls;
  var
    C: TControl;
    I, Sb: Integer;
    R: TRect;
    InDesign: Boolean;
  begin
    if Expanded then Exit;

    InDesign := IsDesigning;

    Sb := ShiftValue;
    if Sb > 0 then
      for I := ControlCount - 1 downto 0 do
      begin
        C := Controls[I];

        if (InDesign or C.Visible) and
          ((C.Align <> alNone) or (C.Anchors <> [akLeft, akTop])) then
        begin
          R := C.BoundsRect;

          OffsetRect(R, 0, Sb);
          C.BoundsRect := R;
        end;
      end;
  end;

  function AlignWork: Boolean;
  var
    I: Integer;
    InDesign: Boolean;
    C: TControl;
  begin
    Result := False;

    InDesign := IsDesigning;
    
    for I := ControlCount - 1 downto 0 do
    begin
      C := Controls[I];
      Result := (InDesign or C.Visible) and
        ((C.Align <> alNone) or (C.Anchors <> [akLeft, akTop]));

      if Result then Exit;
    end;
  end;

var
  R: TRect;
begin
  if (Parent is TSCGroupContainer) and Parent.HandleAllocated then
  begin
    R := Parent.ClientRect;
    TSCGroupContainer(Parent).AdjustClientRect(R);

    OffsetRect(R, -R.Left, -R.Top);

    if R.Right < R.Left then R.Right := R.Left;

    if (R.Right <> Rect.Right) or (R.Left <> Rect.Left) then
    begin
      Rect.Left := R.Left;
      Rect.Right := R.Right;
    end;
  end;

  inherited AlignControls(AControl, Rect);

  if AlignWork and not (Expanded or IsLoading) then
    ShiftControls;
end;

procedure TSCCustomAdvGroup.ApplyStyle(S: TSCAdvPanelStyle; DoUpdate: Boolean);
begin
  if S = scasCustom then Exit;

  inherited ApplyStyle(S, False);

  case S of
    scasExplorerBar:
    begin
      FCanRoll := True;
      FCaptionCursor := crHandPoint;
      FCaptionDisabledFontColor := clPanelDisabledColor;
      FCaptionDownFontColor := clPanelDownColor;
      FCaptionHeight := -1;
      FCaptionHotFontColor := clPanelHotColor;
      FCaptionStyle := scgcNone;
      FDefaultButtons := True;
      FHottrack := True;
      FHottrackButtons := True;
      FMxDefaultButtons := False;
      FRectDefaultButtons := True;
      FRounded := False;
      FShowCaption := True;
      FShowCaptionLine := False;
      FShowCaptionUpLine := False;
      FShowClose := False;
      FShowIcon := True;
      FShowRoller := True;

      with FCaptionButtonColors do
      begin
        FColor         := clBtnFace;
        FDisabledColor := clBtnFace;
        FDownColor     := clBtnFace;
        FFrameColor    := clBtnFace;
        FHotColor      := clBtnFace;
        FIconColor     := clBtnText;
        FIconDisabledColor := clBtnShadow;
        FIconDownColor := clBtnText;
        FIconHotColor  := clBtnText;
      end;

      with FCaptionProps do
      begin
        FColor     := clBtnFace;
        FGradient  := scgNone;
        FUnderline := False;
      end;

      with FDisabledCaptionProps do
      begin
        FColor     := clBtnFace;
        FGradient  := scgNone;
        FUnderline := False;
      end;

      with FHotCaptionProps do
      begin
        FColor     := clBtnFace;
        FGradient  := scgNone;
        FUnderline := False;
      end;

      with FCaptionFont do
      begin
        Color := clBtnText;
        Style := [fsBold];
      end;

      SetExpanded(True);
    end;
    scasMXBar:
    begin
      FCanRoll := True;
      FCaptionCursor := crHandPoint;
      FCaptionDisabledFontColor := clSilver;
      FCaptionDownFontColor := clBtnFace;
      FCaptionHeight := -1;
      FCaptionHotFontColor := clBtnFace;
      FCaptionStyle := scgcNone;
      FDefaultButtons := True;
      FHottrack := True;
      FHottrackButtons := True;
      FMxDefaultButtons := True;
      FRectDefaultButtons := False;
      FRounded := False;
      FShowCaption := True;
      FShowCaptionLine := False;
      FShowCaptionUpLine := True;
      FShowClose := False;
      FShowIcon := True;
      FShowRoller := True;

      with FCaptionButtonColors do
      begin
        FColor         := clBtnShadow;
        FDisabledColor := clBtnShadow;
        FDownColor     := clBtnShadow;
        FFrameColor    := clBtnShadow;
        FHotColor      := clBtnShadow;
        FIconColor     := clBtnHighlight;
        FIconDisabledColor := clBtnFace;
        FIconDownColor := clBtnFace;
        FIconHotColor  := clBtnFace;
      end;

      with FCaptionProps do
      begin
        FColor     := clBtnShadow;
        FEndColor  := clBtnShadow;
        FGradient  := scgNone;
        FLineColor := clBtnText;
        FUnderline := False;
      end;

      with FDisabledCaptionProps do
      begin
        FColor     := clBtnShadow;
        FEndColor  := clBtnShadow;
        FGradient  := scgNone;
        FLineColor := clBtnText;
        FUnderline := False;
      end;

      with FHotCaptionProps do
      begin
        FColor     := clBtnShadow;
        FEndColor  := clBtnShadow;
        FGradient  := scgNone;
        FLineColor := clBtnText;
        FUnderline := False;
      end;

      with FCaptionFont do
      begin
        Color := clBtnHighlight;
        Style := [fsBold];
      end;

      SetExpanded(True);
    end;
    scasAdvXPBar:
    begin
      FCanRoll := True;
      FCaptionCursor := crHandPoint;
      FCaptionDisabledFontColor := $00C6A39B;
      FCaptionDownFontColor := $00DE8640;
      FCaptionHeight := -1;
      FCaptionHotFontColor := $00DD6720;
      FCaptionStyle := scgcNone;
      FDefaultButtons := True;
      FHottrack := True;
      FHottrackButtons := True;
      FMxDefaultButtons := False;
      FRectDefaultButtons := False;
      FRounded := True;
      FShowCaption := True;
      FShowCaptionLine := True;
      FShowCaptionUpLine := False;
      FShowClose := False;
      FShowIcon := True;
      FShowRoller := True;

      with FCaptionButtonColors do
      begin
        FColor         := clWindow;
        FDisabledColor := clWindow;
        FDownColor     := clWindow;
        FFrameColor    := $00F8DED8;
        FHotColor      := clWindow;
        FIconColor     := clHighlight;
        FIconDisabledColor := clBtnShadow;
        FIconDownColor := clPanelDownColor;
        FIconHotColor  := clPanelHotColor;
      end;

      with FCaptionProps do
      begin
        FColor     := clWindow;
        FEndColor  := $00F8DED8;
        FGradient  := scgLeftToRight;
        FLineColor := $00D8D8D8;
        FUnderline := False;
      end;

      with FDisabledCaptionProps do
      begin
        FColor     := clWindow;
        FEndColor  := $00F8DED8;
        FGradient  := scgLeftToRight;
        FLineColor := $00D8D8D8;
        FUnderline := False;
      end;

      with FHotCaptionProps do
      begin
        FColor     := clWindow;
        FEndColor  := $00F8DED8;
        FGradient  := scgLeftToRight;
        FLineColor := $00D8D8D8;
        FUnderline := False;
      end;

      with FCaptionFont do
      begin
        Color := $00AA4628;
        Style := [fsBold];
      end;

      SetExpanded(True);
    end;
    scasXPBar:
    begin
      FCanRoll := True;
      FCaptionCursor := crHandPoint;
      FCaptionDisabledFontColor := clPanelDisabledColor;
      FCaptionDownFontColor := clPanelDownColor;
      FCaptionHeight := -1;
      FCaptionHotFontColor := clPanelHotColor;
      FCaptionStyle := scgcNone;
      FDefaultButtons := True;
      FHottrack := True;
      FHottrackButtons := True;
      FMxDefaultButtons := False;
      FRectDefaultButtons := False;
      FRounded := True;
      FShowCaption := True;
      FShowCaptionLine := True;
      FShowCaptionUpLine := False;
      FShowClose := False;
      FShowIcon := True;
      FShowRoller := True;

      with FCaptionButtonColors do
      begin
        FColor         := clWindow;
        FDisabledColor := clWindow;
        FDownColor     := clWindow;
        FFrameColor    := clBtnShadow;
        FHotColor      := clWindow;
        FIconColor     := clHighlight;
        FIconDisabledColor := clBtnShadow;
        FIconDownColor := clPanelDownColor;
        FIconHotColor  := clPanelHotColor;
      end;

      with FCaptionProps do
      begin
        FColor     := clBtnHighlight;
        FEndColor  := clBtnFace;
        FGradient  := scgLeftToRight;
        FLineColor := clHighlight;
        FUnderline := False;
      end;

      with FDisabledCaptionProps do
      begin
        FColor     := clBtnHighlight;
        FEndColor  := clBtnFace;
        FGradient  := scgLeftToRight;
        FLineColor := clHighlight;
        FUnderline := False;
      end;

      with FHotCaptionProps do
      begin
        FColor     := clBtnHighlight;
        FEndColor  := clBtnFace;
        FGradient  := scgLeftToRight;
        FLineColor := clHighlight;
        FUnderline := False;
      end;

      with FCaptionFont do
      begin
        Color := clHighlight;
        Style := [fsBold];
      end;

      SetExpanded(True);
    end;
    scasOutlookBar, scasOutlookBar2k,
    scasOfficeXP, scasOutlookBarXP:
    begin
      FCanRoll := True;
      FCaptionCursor := crHandPoint;
      FCaptionDisabledFontColor := clPanelDisabledColor;
      FCaptionDownFontColor := clPanelDownColor;
      FCaptionHeight := -1;
      FCaptionHotFontColor := clPanelHotColor;
      FHottrack := True;
      FMxDefaultButtons := False;
      FRectDefaultButtons := True;
      FRounded := False;
      FShowCaption := True;
      FShowCaptionLine := False;
      FShowCaptionUpLine := False;
      FShowClose := False;
      FShowIcon := True;
      FShowRoller := False;

      if S = scasOfficeXP then
        FCaptionStyle := scgcSoftFlat
      else
      if S in [scasOutlookBar2k, scasOutlookBarXP] then
        FCaptionStyle := scgcSoftRaised
      else
        FCaptionStyle := scgcSoft3D;

      if S = scasOutlookBarXP then
      begin
        with FCaptionProps do
        begin
          FColor     := BlendedColor(clHighlight, 128, 128, 128, True);
          FEndColor  := clHighlight;
          FGradient  := scgLeftToRight;
          FLineColor := clNone;
          FUnderline := False;
        end;

        with FHotCaptionProps do
        begin
          FColor     := BlendedColor(clHighlight, 128, 128, 128, True);
          FEndColor  := BlendedColor(clHighlight, 64, 64, 64, True);
          FGradient  := scgLeftToRight;
          FLineColor := clNone;
          FUnderline := False;
        end;

        with FDisabledCaptionProps do
        begin
          FColor     := clBtnFace;
          FEndColor  := clBtnShadow;
          FGradient  := scgLeftToRight;
          FUnderline := False;
        end;

        with FCaptionFont do
        begin
          Color := clHighlightText;
          Style := [];
        end;
      end else
      begin
        with FCaptionProps do
        begin
          FColor     := clBtnFace;
          FGradient  := scgNone;
          FUnderline := False;
        end;

        with FHotCaptionProps do
        begin
          FColor     := clBtnFace;
          FGradient  := scgNone;
          FUnderline := False;
        end;

        with FDisabledCaptionProps do
        begin
          FColor     := clBtnFace;
          FGradient  := scgNone;
          FUnderline := False;
        end;

        with FCaptionFont do
        begin
          Color := clWindowText;
          Style := [];
        end;
      end;

      SetExpanded(False);
    end;
    scasTaskList:
    begin
      FCanRoll := False;
      FCaptionCursor := crDefault;
      FCaptionDisabledFontColor := clPanelDisabledColor;
      FCaptionDownFontColor := clPanelDownColor;
      FCaptionHeight := -1;
      FCaptionHotFontColor := clPanelHotColor;
      FCaptionStyle := scgcNone;
      FHottrack := True;
      FMxDefaultButtons := False;
      FRectDefaultButtons := True;
      FRounded := False;
      FShowCaption := True;
      FShowCaptionLine := True;
      FShowCaptionUpLine := False;
      FShowClose := False;
      FShowIcon := True;
      FShowRoller := False;

      with FCaptionProps do
      begin
        FColor     := clWindow;
        FEndColor  := clWindow;
        FGradient  := scgNone;
        FLineColor := clHighlight;
        FUnderline := False;
      end;

      with FDisabledCaptionProps do
      begin
        FColor     := clWindow;
        FEndColor  := clWindow;
        FGradient  := scgNone;
        FLineColor := clHighlight;
        FUnderline := False;
      end;

      with FHotCaptionProps do
      begin
        FColor     := clWindow;
        FEndColor  := clWindow;
        FGradient  := scgNone;
        FLineColor := clHighlight;
        FUnderline := False;
      end;

      with FCaptionFont do
      begin
        Color := clHighlight;
        Style := [fsBold];
      end;  

      SetExpanded(True);
    end;
  end;

  if DoUpdate then
  begin
    Realign;
    UpdateBorderRegion;
    Invalidate;
  end;
end;

procedure TSCCustomAdvGroup.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomAdvGroup then
  begin
    with TSCCustomAdvGroup(Source) do
    begin
      Self.ShowCaption := ShowCaption;
      Self.ShowCaptionLine := ShowCaptionLine;
      Self.ShowCaptionUpLine := ShowCaptionUpLine;
      Self.CanRoll := CanRoll;
      Self.CaptionButtonColors := CaptionButtonColors;
      Self.CaptionCursor := CaptionCursor;
      Self.CaptionDisabledFontColor := CaptionDisabledFontColor;
      Self.CaptionDownFontColor := CaptionDownFontColor;
      Self.CaptionFont := CaptionFont;
      Self.CaptionHeight := CaptionHeight;
      Self.CaptionHint := CaptionHint;
      Self.CaptionHotFontColor := CaptionHotFontColor;
      Self.CaptionProps := CaptionProps;
      Self.CaptionStyle := CaptionStyle;
      Self.CaptionSettings := CaptionSettings;
      Self.DefaultButtons := DefaultButtons;
      Self.DefaultIcon := DefaultIcon;
      Self.DisabledCaptionProps := DisabledCaptionProps;
      Self.Expanded := Expanded;
      Self.ExpandedHeight := ExpandedHeight;
      Self.HotCaptionProps := HotCaptionProps;
      Self.Hottrack := Hottrack;
      Self.HottrackButtons := HottrackButtons;
      Self.Icons := Icons;
      Self.MxDefaultButtons := MxDefaultButtons;
      Self.RectDefaultButtons := RectDefaultButtons;
      Self.Rounded := Rounded;
      Self.ShowCaptionHint := ShowCaptionHint;
      Self.ShowClose := ShowClose;
      Self.ShowIcon := ShowIcon;
      Self.ShowRoller := ShowRoller;
    end;
  end;
end;

procedure TSCCustomAdvGroup.ButtonsChanged(Sender: TObject);
begin
  UpdateBorderRegion;

  DoChange;
  if FShowClose or FShowRoller then
    UpdateCaption(False);
end;

function TSCCustomAdvGroup.CanCollapse: Boolean;
begin
  Result := (FSettingStyle or FCanRoll) and
    not FExpanding and (Align in [alNone, alTop, alBottom]);

  if Result and
    ((FStyle = scasTaskList) or IsOutlookStyle) then
    Result := FSettingStyle;
end;

function TSCCustomAdvGroup.CanExpand: Boolean;
begin
  Result := (FSettingStyle or FCanRoll) and
    not FExpanding and (Align in [alNone, alTop, alBottom]);
end;

procedure TSCCustomAdvGroup.CaptionChanged(Sender: TObject);
begin
  UpdateBorderRegion;
  
  DoChange;
  if FCaptionHeight = -1 then
  begin
    Realign;
    Invalidate;
  end else
  if HandleAllocated and (Canvas <> nil) then
    UpdateCaption(False);

  UpdateCursor(False);
end;

function TSCCustomAdvGroup.CaptionFrameSize: Integer;
begin
  Result := 0;
  case FCaptionStyle of
    scgcFlat, scgcRaised,
    scgcSoftRaised, scgcSoftFlat:
      Result := 1;
    scgc3DRaised, scgcSoft3D:
      Result := 2;
  end;
end;

function TSCCustomAdvGroup.CaptionRoundation(R: TRect): Integer;
begin
  Result := 0;
  if not IsRectEmpty(R) then
  begin
    Result := RoundSize;
    if Result > R.Bottom - R.Top then
      Result := R.Bottom - R.Top;
    if Result > R.Right - R.Left then
      Result := R.Right - R.Left;
  end;
end;

procedure TSCCustomAdvGroup.CaptureChanged(Captured: Boolean);
var
  NeedPaint: Boolean;
begin
  NeedPaint := FIsCaptionHot or FIsCaptionDown;

  FIsCaptionHot := False;
  FIsMouseInControl := False;

  if NeedPaint then
    Invalidate;
end;

function TSCCustomAdvGroup.CloseBtnHeight: Integer;
begin
  Result := 0;
  if not FShowClose then Exit;

  if FDefaultButtons then
  begin
    Result := 16;
    if FRectDefaultButtons then
      Result := 18;
    Exit;
  end;

  if IsValidImage(CloseIndex) then
  begin
    Result := Images.Height;
    Exit;
  end;
end;

function TSCCustomAdvGroup.CloseBtnWidth: Integer;
begin
  Result := 0;
  if not FShowClose then Exit;

  if FDefaultButtons then
  begin
    Result := 16;
    if FRectDefaultButtons then
      Result := 18;
    Exit;
  end;

  if IsValidImage(CloseIndex) then
  begin
    Result := Images.Width;
    Exit;
  end;
end;

function TSCCustomAdvGroup.CloseIndex: Integer;
begin
  Result := -1;
  if (FCaptionProps <> nil) and
    (FDisabledCaptionProps <> nil) and (FHotCaptionProps <> nil) then
  begin
    if not Enabled then
    begin
      Result := FDisabledCaptionProps.CloseButton;
      if not IsValidIcon(Result) then
        Result := FCaptionProps.CloseButton;
      Exit;
    end;

    Result := FCaptionProps.CloseButton;

    if GetIsCaptionHot then
    begin
      Result := FHotCaptionProps.CloseButton;
      if not IsValidIcon(Result) then
        Result := FCaptionProps.CloseButton;
    end;
  end;
end;

procedure TSCCustomAdvGroup.CMCursorChanged(var Message: TMessage);
begin
  inherited;

  if not FUpdatingCursor then
  begin
    FDefaultCursor := Cursor;
    if not IsLoading then
      UpdateCursor(False);
  end;
end;

procedure TSCCustomAdvGroup.CMHintShow(var Message: TMessage);
const
  EmptyHint = '';
var
  R: TRect;
begin
  inherited;

  with TCMHintShow(Message) do
  begin
    if FIsCaptionHot then
    begin
      R := Rect(0, 0, 0, 0);
      if FShowCaptionHint then
        R := GetCaptionRect(False);

      HintInfo.CursorRect := R;

      if not FShowCaptionHint or
        (FCaptionHint = '') or IsRectEmpty(R) then
      begin
        HintInfo.HintStr := EmptyHint;
        Result := 1;
      end else
        HintInfo.HintStr := FCaptionHint;
    end;
  end;
end;

procedure TSCCustomAdvGroup.CMMouseEnter(var Message: TMessage);
var
  P: TPoint;
  WasHot: Boolean;
begin
  inherited;

  if not IsDesigning then
  begin
    WasHot := FIsCaptionHot;

    FIsCaptionHot := False;
    if Enabled then
    begin
      GetCursorPos(P);
      P := ScreenToClient(P);

      TrackCaption(P.x, P.y);

      if WasHot <> FIsCaptionHot then
        UpdateCaption(False);

      UpdateCursor(False);
    end;
  end;  
end;

procedure TSCCustomAdvGroup.CMMouseLeave(var Message: TMessage);
begin
  inherited;

  if FIsCaptionHot and not IsDesigning then
  begin
    FIsCaptionHot := False;
    UpdateCaption(False);

    UpdateCursor(False);
  end;
end;

constructor TSCCustomAdvGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered := True;
  ClickFocus := True;
  SetBounds(Left, Top, 145, 165);

  FCanRoll := True;
  FCaptionCursor := crHandPoint;
  FCaptionDisabledFontColor := clPanelDisabledColor;
  FCaptionDownFontColor := clPanelDownColor;
  FCaptionHeight := -1;
  FCaptionHotFontColor := clPanelHotColor;
  FCaptionStyle := scgcNone;
  FDefaultButtons := True;
  FDefaultIcon := True;
  FExpanded := True;
  FExpandedHeight := 165;
  FHottrack := True;
  FHottrackButtons := True;
  FRounded := True;
  FShowCaption := True;
  FShowCaptionLine := True;
  FShowCaptionUpLine := False;
  FShowClose := True;
  FShowIcon := True;
  FShowRoller := True;
  FLastCaptionHeight := -1;

  FCaptionButtonColors := TSCAdvGroupButtons.Create(Self);
  FCaptionFont := TFont.Create;
  FCaptionProps := TSCAdvGroupCaption.Create(Self);
  FDisabledCaptionProps := TSCAdvGroupCaption.Create(Self);
  FHotCaptionProps := TSCAdvGroupCaption.Create(Self);
  FIconChangeLink := TChangeLink.Create;

  FCaptionFont.Color := clHighlight;
  FCaptionFont.Style := [fsBold];

  FCaptionFont.OnChange := CaptionChanged;
  FIconChangeLink.OnChange := IconsChanged;

  FCaptionSettings := TSCAdvGroupCaptionSettings.Create(Self);
end;

function TSCCustomAdvGroup.CreateBorderRgn(R: TRect): HRGN;
var
  CRh: Integer;
  Pts: array[0..5] of TPoint;
begin
  CRh := CaptionRoundation(R);
  if IsRectEmpty(R) then
  begin
    if R.Right < R.Left then
      R.Right := R.Left;
    if R.Bottom < R.Top then
      R.Bottom := R.Top;
  end;

  if CRh = 0 then
    Result := CreateRectRgnIndirect(R)
  else begin
    Pts[0].x := R.Left + CRh;
    Pts[0].y := R.Top;
    Pts[1].x := R.Right - CRh;
    Pts[1].y := R.Top;
    Pts[2].x := R.Right;
    Pts[2].y := R.Top + CRh;
    Pts[3].x := R.Right;
    Pts[3].y := R.Bottom;
    Pts[4].x := R.Left;
    Pts[4].y := R.Bottom;
    Pts[5].x := R.Left;
    Pts[5].y := R.Top + CRh;

    Result := CreatePolygonRgn(Pts, 6, WINDING);
  end;
end;

procedure TSCCustomAdvGroup.CreateWnd;
begin
  inherited CreateWnd;
  UpdateBorderRegion;
end;

destructor TSCCustomAdvGroup.Destroy;
begin
  FCaptionFont.OnChange := nil;
  FIconChangeLink.OnChange := nil;

  FreeAndNil(FCaptionSettings);
  FreeAndNil(FCaptionButtonColors);
  FreeAndNil(FCaptionFont);
  FreeAndNil(FCaptionProps);
  FreeAndNil(FDisabledCaptionProps);
  FreeAndNil(FHotCaptionProps);
  FreeAndNil(FIconChangeLink);

  inherited Destroy;
end;

procedure TSCCustomAdvGroup.DoDrawBevel(Cnv: TCanvas);

  procedure DrawDottedFrame(R: TRect; C: TColor);
  begin
    if R.Right > R.Left then Dec(R.Right);
    if R.Bottom > R.Top then Dec(R.Bottom);

    with Canvas.Pen do
    begin
      Mode  := pmCopy;
      Style := psDot;
      Width := 1;
      Color := C;
    end;

    with Canvas do
    begin
      Brush.Color := Self.Color;
      Brush.Style := bsClear;

      MoveTo(R.Right, R.Top);
      LineTo(R.Left, R.Top);
      LineTo(R.Left, R.Bottom);

      MoveTo(R.Left, R.Bottom);
      LineTo(R.Right, R.Bottom);
      LineTo(R.Right, R.Top);
    end;
  end;

var
  R: TRect;
  C: TColor;
begin
  if Cnv = nil then
    Cnv := Canvas;

  if (Cnv <> nil) and (FBevel <> sccbNone) and CanGetClientRect then
  begin
    R := GetClientRect;
    InflateRect(R, -FBevelWidth, -FBevelWidth);

    if not IsRectEmpty(R) then
    begin
      C := clNone;

      if FBevelEx then
      begin
        C := Self.Color;

        if FBevel in [sccbFlat, sccbFlatBold, sccbFlatRounded,
          sccbFlatBoldRounded, sccbColor] then
        begin
          C := FBevelColor;
          if C = clNone then
          begin
            C := Self.Color;
            if C = clNone then C := clBtnFace;
          end;

          if FBevelDotted then
            DrawDottedFrame(R, C)
          else
            scDrawEdgeEx(Cnv.Handle, R, C, clNone, False, FBevel);

          Exit;
        end;
      end;

      if C <> clNone then
      begin
        if FBevel in [sccbFlat, sccbFlatBold,
          sccbFlatRounded, sccbFlatBoldRounded] then
          C := GetBtnShadowOf(C);

        scDrawBevel(Cnv, R, C, clNone, False, FBevel);
      end else
        scDrawEdgeEx(Cnv.Handle, R, C, clNone, False, FBevel);
    end;
  end;
end;

procedure TSCCustomAdvGroup.DoDrawCaption(Cnv: TCanvas);
var
  CR, R, R2, FrmR: TRect;
  G: TSCGradient;
  IC, C, EC, LC: TColor;
  Img, W, CW,
  RW, Ch, RCh: Integer;
  IsHot, ParentOutlook: Boolean;
  CpProps: TSCAdvGroupCaption;
begin
  if Cnv = nil then
    Cnv := Canvas;

  if Cnv = nil then Exit;

  CR := GetClientRect;
  if not FShowCaption or IsRectEmpty(CR) then Exit;

  IsHot := False;
  CpProps := FDisabledCaptionProps;
  if Enabled then
  begin
    CpProps := FCaptionProps;

    IsHot := GetIsCaptionHot;
    if IsHot then
      CpProps := FHotCaptionProps;
  end;

  with CpProps do
  begin
    G  := Gradient;
    C  := Color;
    EC := EndColor;
    LC := LineColor;
  end;

  if C = EC then
    G := scgNone;

  Ch := GetCaptionHeight;

  RCh := Ch;
  if RCh > CR.Bottom - CR.Top then
    RCh := CR.Bottom - CR.Top;

  if RCh <= 0 then Exit;

  with Cnv do
  begin
    R := CR;
    R.Bottom := R.Top + RCh;

    FrmR := R;

    if (G <> scgNone) and (EC <> clNone) then
      scDrawGradient(Cnv, R, G, C, EC)
    else begin
      Brush.Style := bsSolid;
      Brush.Color := C;

      FillRect(R);
    end;

    Brush.Style := bsClear;
    Brush.Color := C;

    InflateRect(R, -2, -2);
    if IsRectEmpty(R) then Exit;

    if FShowIcon then
    begin
      if FIcons <> nil then
      begin
        W := FIcons.Width;

        if W > 0 then
        begin
          Img := IconIndex;

          if IsValidIcon(Img) then
          begin
            if IsOutlookStyle then
              Inc(R.Left, 2);

            if FIcons.Height > 0 then
              FIcons.Draw(Cnv, R.Left,
                R.Top + ((R.Bottom - R.Top - FIcons.Height) div 2), Img, True);

            Inc(R.Left, W);
          end;
        end;
      end else
      if FDefaultIcon then
      begin
        W := 12;
        R2 := R;

        InflateRect(R2, -3, -1);
        if not IsRectEmpty(R2) then
        begin
          IC := C;
          if G = scgRightToLeft then
            IC := EC;

          DoDrawIcon(Cnv, IC, R2);
        end;

        Inc(R.Left, W);
      end;
    end;

    Inc(R.Left, 4);
    if IsRectEmpty(R) then Exit;

    CW := 0;
    if FShowClose then
      CW := CloseBtnWidth;

    RW := 0;
    if FShowRoller then
      RW := RollBtnWidth;

    R2 := R;
    if (CW > 0) or (RW > 0) then
      Dec(R2.Right, CW + RW + 2);

    if not IsRectEmpty(R2) then
      DoDrawCaptionText(Cnv, R2, False);

    Brush.Style := bsSolid;

    if FShowClose and (CW > 0) then
    begin
      Dec(R.Right, CW);

      R2 := R;

      R2.Left := R.Right;
      Inc(R2.Right, CW);

      Img := CloseIndex;

      if (Images <> nil) and
        IsValidImage(Img) and (Images.Height > 0) then
        Images.Draw(Cnv, R2.Left,
          R2.Top + ((R2.Bottom - R2.Top - Images.Height) div 2), Img, True)
      else
        DoDrawDefButton(Cnv, R2, scgbClose);
    end;

    if FShowRoller and (RW > 0) then
    begin
      Dec(R.Right, RW);

      R2 := R;

      R2.Left := R.Right;
      Inc(R2.Right, RW);

      if Expanded then
        Img := RollupIndex
      else
        Img := RolldownIndex;

      if (Images <> nil) and
        IsValidImage(Img) and (Images.Height > 0) then
        Images.Draw(Cnv, R2.Left,
          R2.Top + ((R2.Bottom - R2.Top - Images.Height) div 2), Img, True)
      else begin
        if Expanded then
          DoDrawDefButton(Cnv, R2, scgbUp)
        else
          DoDrawDefButton(Cnv, R2, scgbDown);
      end;
    end;

    if (C <> LC) and
      (FShowCaptionLine or FShowCaptionUpLine) then
    begin
      R2 := FrmR;
      if (G <> scgNone) and (EC <> clNone) then
      begin
        if C <> LC then
        begin
          if FShowCaptionLine then
          begin
            R2.Top := R2.Bottom - 1;
            scDrawGradient(Cnv, R2, G, LC, EC);
          end;

          R2 := FrmR;
          if FShowCaptionUpLine then
          begin
            R2.Bottom := R2.Top + 1;
            scDrawGradient(Cnv, R2, G, LC, EC);
          end;
        end;
      end else
      begin
        with Pen do
        begin
          Mode  := pmCopy;
          Style := psSolid;
          Color := LC;
          Width := 1;
        end;

        if FShowCaptionLine then
        begin
          MoveTo(R2.Left,  R2.Bottom -1);
          LineTo(R2.Right, R2.Bottom -1);
        end;

        if FShowCaptionUpLine then
        begin
          MoveTo(R2.Left,  R2.Top);
          LineTo(R2.Right, R2.Top);
        end;
      end;
    end;

    if RoundSize = 0 then
    begin
      ParentOutlook := (Parent <> nil) and
        (Parent is TSCGroupContainer) and
        TSCGroupContainer(Parent).IsOutlookStyle;

      case FCaptionStyle of
        scgcFlat:
        begin
          if ParentOutlook then
            Dec(FrmR.Top);
          scDrawBevelEx(Cnv.Handle, FrmR, GetBtnShadowOf(C), clNone, False, sccbFlat);
        end;
        scgcRaised:
          scDrawBevelEx(Cnv.Handle, FrmR, C, clNone, False, sccbRaised);
        scgc3DRaised:
          scDrawBevelEx(Cnv.Handle, FrmR, C, clNone, False, sccb3DRaised);
        scgcSoftFlat:
        begin
          if IsHot and FIsCaptionDown then
            scDrawBevelEx(Cnv.Handle, FrmR, C, clNone, False, sccbLowered)
          else
          if IsHot then
            scDrawBevelEx(Cnv.Handle, FrmR, C, clNone, False, sccbRaised)
          else begin
            if ParentOutlook then
              Dec(FrmR.Top);
            scDrawBevelEx(Cnv.Handle, FrmR, GetBtnShadowOf(C), clNone, False, sccbFlat);
          end;
        end;
        scgcSoftRaised:
        begin
          if IsHot and FIsCaptionDown then
            scDrawBevelEx(Cnv.Handle, FrmR, C, clNone, False, sccbLowered)
          else
          if IsHot then
            scDrawBevelEx(Cnv.Handle, FrmR, C, clNone, False, sccb3DRaised)
          else
            scDrawBevelEx(Cnv.Handle, FrmR, C, clNone, False, sccbRaised);
        end;
        scgcSoft3D:
        begin
          if IsHot and FIsCaptionDown then
            scDrawBevelEx(Cnv.Handle, FrmR, C, clNone, False, sccbLowered)
          else
            scDrawBevelEx(Cnv.Handle, FrmR, C, clNone, False, sccb3DRaised)
        end;
      end;
    end;
  end;
end;

procedure TSCCustomAdvGroup.DoDrawClose(Cnv: TCanvas; C: TColor; R: TRect);
var
  I: Integer;
begin
  if Cnv = nil then
    Cnv := Canvas;

  OffsetRect(R, 4, 4);

  with Cnv do
  begin
    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Pen.Width := 1;
    Pen.Color := C;

    for I := 0 to 1 do
    begin
      MoveTo(R.Left + I,     R.Top);
      LineTo(R.Left + 6 + I, R.Top + 6);

      MoveTo(R.Left + 5 + I, R.Top);
      LineTo(R.Left + I - 1, R.Top + 6);
    end;
  end;
end;

procedure TSCCustomAdvGroup.DoDrawDefButton(Cnv: TCanvas; R: TRect;
  Button: TSCAdvGroupButton);
var
  C1, C2,
  C3, C4: TColor;
  H, Rh: Integer;
  Pts: array[0..7] of TPoint;
  C: array[0..7] of TColor;
  I: Integer;
begin
  if Cnv = nil then
    Cnv := Canvas;

  H := R.Bottom - R.Top;
  if H < 0 then H := 0;

  if FRectDefaultButtons then
  begin
    R.Top := R.Top + ((H - 17) div 2);

    R.Right := R.Left + 17;
    R.Bottom := R.Top + 17;
  end else
  begin
    R.Top := R.Top + ((H - 14) div 2);

    R.Right := R.Left + 14;
    R.Bottom := R.Top + 14;
  end;

  C1 := FCaptionButtonColors.Color;
  C2 := FCaptionButtonColors.IconColor;

  if Enabled and FHottrack and FHottrackButtons then
    if FIsCaptionDown and FIsCaptionHot then
    begin
      C1 := FCaptionButtonColors.DownColor;
      C2 := FCaptionButtonColors.IconDownColor;
    end else
    if FIsCaptionHot or FIsCaptionDown then
    begin
      C1 := FCaptionButtonColors.HotColor;
      C2 := FCaptionButtonColors.IconHotColor;
    end;

  if not Enabled then
  begin
    C1 := FCaptionButtonColors.DisabledColor;
    C2 := FCaptionButtonColors.IconDisabledColor;
  end;

  if FMxDefaultButtons then
  begin
    case Button of
      scgbClose:
        DoDrawClose(Cnv, C2, R);
      scgbDown:
        DoDrawDown(Cnv, C2, R);
      scgbUp:
        DoDrawUp(Cnv, C2, R);
    end;

    Exit;
  end;

  if FRectDefaultButtons then
  begin
    if Enabled and FHottrack and FHottrackButtons and FIsCaptionHot then
      scDrawBevelEx(Cnv.Handle, R, Self.Color, clNone, False, sccbRaised);

    Inc(R.Left);
    Inc(R.Top);

    case Button of
      scgbClose:
        DoDrawClose(Cnv, C2, R);
      scgbDown:
        DoDrawDown(Cnv, C2, R);
      scgbUp:
        DoDrawUp(Cnv, C2, R);
    end;

    Exit;
  end;

  Rh := 4;

  Pts[0].x := R.Left + Rh;
  Pts[0].y := R.Top;

  Pts[1].x := R.Right - Rh;
  Pts[1].y := R.Top;

  Pts[2].x := R.Right;
  Pts[2].y := R.Top + Rh;

  Pts[3].x := R.Right;
  Pts[3].y := R.Bottom - Rh;

  Pts[4].x := R.Right - Rh;
  Pts[4].y := R.Bottom;

  Pts[5].x := R.Left + Rh;
  Pts[5].y := R.Bottom;

  Pts[6].x := R.Left;
  Pts[6].y := R.Bottom - Rh;

  Pts[7].x := R.Left;
  Pts[7].y := R.Top + Rh;

  for I := Low(Pts) to High(Pts) do
    C[I] := Canvas.Pixels[Pts[I].x, Pts[I].y];

  with Cnv do
  begin
    Brush.Style := bsSolid;
    Brush.Color := C1;

    Pen.Color := clBtnShadow;
    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Pen.Width := 1;

    Polygon(Pts);

    Pen.Color := clBtnFace;

    C3 := BlendedColor(clBtnFace, 16, 16, 16, True);
    C4 := MixColors(C3, C1, 40);

    Pen.Color := MixColors(C3, C[0], 20);
    MoveTo(Pts[0].x, Pts[0].y);
    LineTo(Pts[0].x, Pts[0].y + 1);
    Pen.Color := C4;
    LineTo(Pts[0].x, Pts[0].y + 2);

    Pen.Color := MixColors(C3, C[1], 20);
    MoveTo(Pts[1].x, Pts[1].y);
    LineTo(Pts[1].x, Pts[1].y + 1);
    Pen.Color := C4;
    LineTo(Pts[1].x, Pts[1].y + 2);

    Pen.Color := MixColors(C3, C[2], 20);
    MoveTo(Pts[2].x,     Pts[2].y);
    LineTo(Pts[2].x - 1, Pts[2].y);
    Pen.Color := C4;
    LineTo(Pts[2].x - 2, Pts[2].y);

    Pen.Color := MixColors(C3, C[3], 20);
    MoveTo(Pts[3].x,     Pts[3].y);
    LineTo(Pts[3].x - 1, Pts[3].y);
    Pen.Color := C4;
    LineTo(Pts[3].x - 2, Pts[3].y);

    Pen.Color := MixColors(C3, C[4], 20);
    MoveTo(Pts[4].x, Pts[4].y);
    LineTo(Pts[4].x, Pts[4].y - 1);
    Pen.Color := C4;
    LineTo(Pts[4].x, Pts[4].y - 2);

    Pen.Color := MixColors(C3, C[5], 20);
    MoveTo(Pts[5].x, Pts[5].y);
    LineTo(Pts[5].x, Pts[5].y - 1);
    Pen.Color := C4;
    LineTo(Pts[5].x, Pts[5].y - 2);

    Pen.Color := MixColors(C3, C[6], 20);
    MoveTo(Pts[6].x,     Pts[6].y);
    LineTo(Pts[6].x + 1, Pts[6].y);
    Pen.Color := C4;
    LineTo(Pts[6].x + 2, Pts[6].y);

    Pen.Color := MixColors(C3, C[7], 20);
    MoveTo(Pts[7].x,     Pts[7].y);
    LineTo(Pts[7].x + 1, Pts[7].y);
    Pen.Color := C4;
    LineTo(Pts[7].x + 2, Pts[7].y);
  end;

  case Button of
    scgbClose:
      DoDrawClose(Cnv, C2, R);
    scgbDown:
      DoDrawDown(Cnv, C2, R);
    scgbUp:
      DoDrawUp(Cnv, C2, R);
  end;
end;

procedure TSCCustomAdvGroup.DoDrawDown(Cnv: TCanvas; C: TColor; R: TRect);
var
  I, J: Integer;
  Pts: array[0..2] of TPoint;
begin
  if Cnv = nil then
    Cnv := Canvas;

  OffsetRect(R, 4, 4);

  if FMxDefaultButtons then
  begin
    OffsetRect(R, 0, 4);
    scDrawLeftSlider(Cnv, Point(R.Left, R.Top), 6, 3, sctsMac, False, C, C);

    Exit;
  end;

  Pts[0].x := R.Left;
  Pts[0].y := R.Top;

  Pts[1].x := R.Left + 3;
  Pts[1].y := R.Top + 3;

  Pts[2].x := R.Left + 7;
  Pts[2].y := R.Top - 1;

  with Cnv do
  begin
    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Pen.Width := 1;
    Pen.Color := C;

    for I := 0 to 1 do
    begin
      for J := 0 to 1 do
      begin
        MoveTo(Pts[0].x, Pts[0].y);
        LineTo(Pts[1].x, Pts[1].y);
        LineTo(Pts[2].x, Pts[2].y);

        Inc(Pts[0].y);
        Inc(Pts[1].y);
        Inc(Pts[2].y);
      end;

      Inc(Pts[0].y);
      Inc(Pts[1].y);
      Inc(Pts[2].y);
    end;
  end;
end;

procedure TSCCustomAdvGroup.DoDrawIcon(Cnv: TCanvas; C: TColor; R: TRect);
var
  R2: TRect;
  C1, C2: TColor;
  I, Offset: Integer;
begin
  if (Cnv = nil) or IsRectEmpty(R) then Exit;

  C1 := cl3DDkShadow;
  C2 := clBtnFace;

  if C <> clNone then
  begin
    if IsColorLight(C) then
    begin
      C1 := BlendedColor(C, 96, 96, 96, False);
      C2 := BlendedColor(C, 32, 32, 32, False);
    end else
    begin
      C1 := BlendedColor(C, 64, 64, 64, False);
      C2 := BlendedColor(C, 64, 64, 64, True);
    end;
  end;

  with Cnv do
  begin
    Brush.Style := bsSolid;

    Offset := 1;
    Brush.Color := C2;

    for I := 0 to 1 do
    begin
      R2 := R;

      R2.Right := R2.Left + 2;
      R2.Bottom := R2.Top + 2;

      OffsetRect(R2, Offset, Offset);
      FillRect(R2);

      OffsetRect(R2, 0, 8);
      FillRect(R2);

      OffsetRect(R2, 0, 8);
      FillRect(R2);

      R2 := R;

      R2.Right := R2.Left + 2;
      R2.Bottom := R2.Top + 2;

      OffsetRect(R2, 4, 4);
      OffsetRect(R2, Offset, Offset);

      FillRect(R2);

      OffsetRect(R2, 0, 8);
      FillRect(R2);

      Offset := 0;
      Brush.Color := C1;
    end;
  end;
end;

procedure TSCCustomAdvGroup.DoDrawUp(Cnv: TCanvas; C: TColor; R: TRect);
var
  I, J: Integer;
  Pts: array[0..2] of TPoint;
begin
  if Cnv = nil then
    Cnv := Canvas;

  OffsetRect(R, 4, 3);

  if FMxDefaultButtons then
  begin
    OffsetRect(R, 0, 4);
    scDrawUpSlider(Cnv, Point(R.Left, R.Top), 6, 3, sctsMac, False, C, C);

    Exit;
  end;

  Pts[0].x := R.Left;
  Pts[0].y := R.Top + 3;

  Pts[1].x := R.Left + 3;
  Pts[1].y := R.Top;

  Pts[2].x := R.Left + 7;
  Pts[2].y := R.Top + 4;

  with Cnv do
  begin
    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Pen.Width := 1;
    Pen.Color := C;

    for I := 0 to 1 do
    begin
      for J := 0 to 1 do
      begin
        MoveTo(Pts[0].x, Pts[0].y);
        LineTo(Pts[1].x, Pts[1].y);
        LineTo(Pts[2].x, Pts[2].y);

        Inc(Pts[0].y);
        Inc(Pts[1].y);
        Inc(Pts[2].y);
      end;

      Inc(Pts[0].y);
      Inc(Pts[1].y);
      Inc(Pts[2].y);
    end;
  end;
end;

function TSCCustomAdvGroup.GetCaptionHeight: Integer;
var
  Cs, H1, H2: Integer;
begin
  Result := 0;
  try
    if not FShowCaption then Exit;

    Result := FCaptionHeight;

    if (Result = -1) and (Canvas <> nil) then
    begin
      Canvas.Font := CaptionFont;

      Result := Canvas.TextHeight('W') + 2;

      H1 := CloseBtnHeight;
      H2 := RollBtnHeight;

      if H1 > Result then Result := H1;
      if H2 > Result then Result := H2;

      if FShowIcon then
      begin
        H1 := 0;
        if FIcons <> nil then
          H1 := IconHeight
        else
        if FDefaultIcon then
          H1 := 20;

        if Result < H1 then Result := H1;
      end;

      Inc(Result, 4);
    end;

    if FShowCaptionLine then
      Inc(Result);

    if FShowCaptionUpLine then
      Inc(Result);

    if Result < 0 then Result := 0;

    if RoundSize(Result) = 0 then
    begin
      Cs := CaptionFrameSize;
      if Cs > 0 then Inc(Result, 2*Cs);
    end;
  finally
    if Result < 0 then Result := 0;
    if (Result > 0) and Odd(Result) then
      Inc(Result);

    FLastCaptionHeight := Result;
  end;
end;

function TSCCustomAdvGroup.GetCaptionPart(X, Y: Integer): TSCCaptionPart;
var
  P: TPoint;
  W, Ch: Integer;
  R, R2: TRect;
begin
  Result := sccpNone;
  if (X < 0) or (Y < 0) then Exit;

  P := Point(X, Y);
  R := GetClientRect;
  if IsRectEmpty(R) or not PtInRect(R, P) then Exit;

  Ch := GetCaptionHeight;
  if Ch > 0 then
  begin
    Result := sccpCaption;

    if Ch < R.Bottom - R.Top then
      R.Bottom := R.Top + Ch;

    InflateRect(R, -2, 0);

    if FShowIcon and IsValidIcon(IconIndex) then
    begin
      R2 := R;
      R2.Right := R2.Left + IconWidth;

      if PtInRect(R, P) then
      begin
        Result := sccpIcon;
        Exit;
      end;
    end;

    if FShowClose then
    begin
      W := CloseBtnWidth;

      if W > 0 then
      begin
        Dec(R.Right, W);
        if IsRectEmpty(R) then Exit;

        R2 := R;

        R2.Left := R.Right;
        Inc(R2.Right, W);

        if PtInRect(R2, P) then
        begin
          Result := sccpClose;
          Exit;
        end;
      end;
    end;

    if FShowRoller then
    begin
      W := RollBtnWidth;

      if W > 0 then
      begin
        R2 := R;
        Dec(R2.Left, W);

        if R2.Left < R.Left then
          R2.Left := R.Left;

        if PtInRect(R2, P) then
        begin
          Result := sccpRoll;
          Exit;
        end;
      end;
    end;
  end;
end;

function TSCCustomAdvGroup.GetCaptionRect(VisiblePart: Boolean): TRect;
var
  R: TRect;
  Ch: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  R := ClientRect;
  if not IsRectEmpty(R) then
  begin
    Ch := GetCaptionHeight;
    if Ch < 0 then Ch := 0;

    if (Ch > 0) and VisiblePart and
      (R.Bottom - R.Top < Ch) then
      Ch := R.Bottom - R.Top;

    Result := R;
    Result.Bottom := Result.Top + Ch;  
  end;
end;

function TSCCustomAdvGroup.GetCollapsedHeight: Integer;
begin
  Result := GetCaptionHeight + 2*(GetBorderSize + BorderWidth + GetInnerBorderSize);
end;

function TSCCustomAdvGroup.GetCurrentCursor: TCursor;
begin
  Result := FDefaultCursor;
end;

function TSCCustomAdvGroup.GetExpandedHeight: Integer;
var
  Ch: Integer;
begin
  Result := FExpandedHeight;

  if not (IsLoading or IsReading or IsWriting) then
  begin
    Ch := GetCollapsedHeight;
    if Result < Ch then
      Result := Ch;
  end;
end;

function TSCCustomAdvGroup.GetIsButtonsHot: Boolean;
begin
  Result := FHottrackButtons and GetIsCaptionHot;
end;

function TSCCustomAdvGroup.GetIsCaptionHot: Boolean;
begin
  Result := FHottrack and FIsCaptionHot and Enabled;
end;

function TSCCustomAdvGroup.GetPictureRect(P: TPicture): TRect;
begin
  Result := inherited GetPictureRect(P);
  AdjustClientRect(Result);
end;

function TSCCustomAdvGroup.IconHeight: Integer;
begin
  Result := 0;
  if not FShowIcon then Exit;

  if IsValidIcon(IconIndex) then
  begin
    Result := Icons.Height;
    Exit;
  end;
end;

function TSCCustomAdvGroup.IconIndex: Integer;
begin
  Result := -1;
  if (FCaptionProps <> nil) and
    (FDisabledCaptionProps <> nil) and (FHotCaptionProps <> nil) then
  begin
    if not Enabled then
    begin
      Result := FDisabledCaptionProps.Icon;
      if not IsValidIcon(Result) then
        Result := FCaptionProps.Icon;
      Exit;
    end;

    Result := FCaptionProps.Icon;
    
    if GetIsCaptionHot then
    begin
      Result := FHotCaptionProps.Icon;
      if not IsValidIcon(Result) then
        Result := FCaptionProps.Icon;
    end;
  end;
end;

procedure TSCCustomAdvGroup.IconsChanged(Sender: TObject);
begin
  UpdateBorderRegion;
  Realign;
  if IsValidIcon(IconIndex) then
    Invalidate;
end;

function TSCCustomAdvGroup.IconWidth: Integer;
begin
  Result := 0;
  if not FShowIcon then Exit;

  if IsValidIcon(IconIndex) then
  begin
    Result := Icons.Width;
    Exit;
  end;
end;

procedure TSCCustomAdvGroup.ImageListChange(Sender: TObject);
begin
  UpdateBorderRegion;
  Realign;
  inherited;
end;

function TSCCustomAdvGroup.IsValidIcon(Index: Integer): Boolean;
begin
  Result := (FIcons <> nil) and (Index > -1) and
    (Index < FIcons.Count);
end;

procedure TSCCustomAdvGroup.Loaded;
var
  Ch, H: Integer;
begin
  inherited Loaded;

  if Visible and not Expanded then
  begin
    H := Height;
    Ch := GetCollapsedHeight;
    
    if H <> Ch then Height := Ch;
  end;

  UpdateBorderRegion;
end;

procedure TSCCustomAdvGroup.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  FIsMouseDown := (Button = mbLeft) and Enabled and Focused;

  if FIsMouseDown then
  begin
    TrackCaption(X, Y);

    FIsCaptionDown := FIsCaptionHot;
    if FIsCaptionDown then
    begin
      UpdateCaption(False);
      UpdateCursor(False);

      if Assigned(FOnCaptionMouseDown) then
        FOnCaptionMouseDown(Self, Button, Shift, X, Y, GetCaptionPart(X, Y));
    end;
  end;
end;

procedure TSCCustomAdvGroup.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  WasHot: Boolean;
  CpHeight: Integer;
begin
  WasHot := FIsCaptionHot;
  inherited MouseMove(Shift, X, Y);

  CpHeight := FLastCaptionHeight;

  if FIsMouseDown then
  begin
    if FIsCaptionDown then
    begin
      TrackCaption(X, Y);

      if WasHot <> FIsCaptionHot then
      begin
        UpdateCaption(False);
        UpdateCursor(CpHeight <> FLastCaptionHeight);
      end;
    end;
  end else
  begin
    if not FIsMouseInControl then
      UpdateTracking;

    TrackCaption(X, Y);
    if WasHot <> FIsCaptionHot then
      UpdateCaption(False);

    UpdateCursor(CpHeight <> FLastCaptionHeight);
  end;

  if FIsCaptionHot and Assigned(FOnCaptionMouseMove) then
    FOnCaptionMouseMove(Self, Shift, X, Y, GetCaptionPart(X, Y));
end;

procedure TSCCustomAdvGroup.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  P: TSCCaptionPart;
  WasDown: Boolean;
  IsOutlook: Boolean;
begin
  inherited MouseUp(Button, Shift, X, Y);

  if FIsMouseDown then
  begin
    FIsMouseDown := False;

    WasDown := FIsCaptionDown;
    FIsCaptionDown := False;

    UpdateTracking;
    TrackCaption(X, Y);

    if WasDown and FIsCaptionHot then
    begin
      P := GetCaptionPart(X, Y);
      if P = sccpClose then
      begin
        Parent.DisableAlign;
        try
          Visible := False;
        finally
          Parent.EnableAlign;
        end;
        Parent.Realign;
      end else
      begin
        if FCanRoll then
        begin
          IsOutlook := False;
          if (Parent <> nil) and
            (Parent is TSCGroupContainer) then
            IsOutlook := TSCGroupContainer(Parent).IsOutlookStyle;

          if IsOutlook then
          begin
            if not Expanded then
              Expanded := True;
          end else
            Expanded := not Expanded;

          UpdateCaption(False);

          UpdateCursor(False);
        end;

        if Assigned(FOnCaptionMouseUp) then
          FOnCaptionMouseUp(Self, Button, Shift, X, Y, P);

        if Assigned(FOnCaptionClick) then
          FOnCaptionClick(Self, X, Y, P);
      end;
    end else
    if WasDown <> FIsCaptionHot then
      UpdateCaption(False);

    UpdateCursor(False);
  end;
end;

procedure TSCCustomAdvGroup.Paint;
var
  CR: TRect;
  C1, C2: TColor;
  CCnt: Integer;
begin
  if not HandleAllocated then
    Exit;

  CR := GetClientRect;
  if IsRectEmpty(CR) then
    Exit;

  with Canvas do
  begin
    if (FGradient <> scgNone) and (FEndColor <> clNone) then
    begin
      C1 := Self.Color;
      C2 := FEndColor;

      if FUseExGradient then
        scDrawGradient(Canvas, CR, FGradient, C1, C2)
      else begin
        CCnt := CR.Right - CR.Left;
        if FGradient in [scgTopToBottom, scgBottomToTop] then
          CCnt := CR.Bottom - CR.Top;

        if CCnt <= 100 then
          CCnt := 10
        else
        if CCnt <= 300 then
          CCnt := 20
        else
        if CCnt <= 600 then
          CCnt := 30
        else
          CCnt := 40;

        scFillGradientRect(Canvas, CR, CCnt, FGradient, C1, C2)
      end;
    end else
    begin
      Brush.Style := bsSolid;
      Brush.Color := Self.Color;

      FillRect(CR);

      if Transparent then
        PaintParentOn(Canvas);
    end;
  end;

  DrawPicture(Canvas);
end;

procedure TSCCustomAdvGroup.PaintCaption(DC: HDC);
var
  CR, R: TRect;
  Ch, SR: Integer;
  Rgn, PrevRgn: HRGN;
begin
  Canvas.Lock;
  try
    Canvas.Handle := DC;
    try
      TControlCanvas(Canvas).UpdateTextFlags;

      CR := Rect(0, 0, 0, 0);
      R := ClientRect;

      Ch := GetCaptionHeight;
      if Ch > 0 then
      begin
        CR := R;

        Inc(R.Top, Ch);
        if R.Top > R.Bottom then
          R.Top := R.Bottom;

        CR.Bottom := R.Top;

        if not IsRectEmpty(CR) then
        begin
          PrevRgn := CreateRectRgn(0, 0, 0, 0);
          GetClipRgn(DC, PrevRgn);

          try
            Rgn := CreateBorderRgn(CR);

            SR := ExtSelectClipRgn(DC, Rgn, RGN_AND);
            DeleteObject(Rgn);

            if SR <> NULLREGION then
              DoDrawCaption(nil);
          finally
            SelectClipRgn(DC, PrevRgn);
            DeleteObject(PrevRgn);
          end;
        end;
      end;
    finally
      Canvas.Handle := 0;
    end;
  finally
    Canvas.Unlock;
  end;
end;

procedure TSCCustomAdvGroup.PaintWindow(DC: HDC);
var
  CR, R: TRect;
  Ch, SR: Integer;
  Rgn, PrevRgn: HRGN;
  Bmp: TBitmap;
begin
  Canvas.Lock;
  try
    Canvas.Handle := DC;
    try
      TControlCanvas(Canvas).UpdateTextFlags;

      CR := Rect(0, 0, 0, 0);
      R := ClientRect;

      Ch := GetCaptionHeight;
      if Ch > 0 then
      begin
        CR := R;

        Inc(R.Top, Ch);
        if R.Top > R.Bottom then
          R.Top := R.Bottom;

        CR.Bottom := R.Top;
      end;

      if not IsRectEmpty(R) then
      begin
        PrevRgn := 0;
        if not IsRectEmpty(CR) then
        begin
          PrevRgn := CreateRectRgn(0, 0, 0, 0);
          GetClipRgn(DC, PrevRgn);

          Rgn := CreateRectRgnIndirect(R);

          ExtSelectClipRgn(DC, Rgn, RGN_AND);
          DeleteObject(Rgn);
        end;

        Paint;
        DoDrawBevel(Canvas);

        if PrevRgn <> 0 then
        begin
          SelectClipRgn(DC, PrevRgn);
          DeleteObject(PrevRgn);
        end;
      end;

      if not IsRectEmpty(CR) then
      begin
        Rgn := CreateBorderRgn(CR);

        SR := SelectClipRgn(DC, Rgn);
        DeleteObject(Rgn);

        if SR <> NULLREGION then
        begin
          Bmp := TBitmap.Create;
          try
            Bmp.Width := ClientWidth;
            Bmp.Height := Ch;

            DoDrawCaption(Bmp.Canvas);
            Canvas.Draw(0, 0, Bmp);
          finally
            Bmp.Free;
          end;
        end;

        SelectClipRgn(DC, 0);
      end;
    finally
      Canvas.Handle := 0;
    end;
  finally
    Canvas.Unlock;
  end;
end;

function TSCCustomAdvGroup.RollBtnHeight: Integer;
var
  Im: Integer;
begin
  Result := 0;
  if not FShowRoller then Exit;

  if FDefaultButtons then
  begin
    Result := 16;
    if FRectDefaultButtons then
      Result := 18;
    Exit;
  end;

  Im := RollupIndex;
  if not FExpanded then
    Im := RolldownIndex;

  if IsValidImage(Im) then
  begin
    Result := Images.Height;
    Exit;
  end;
end;

function TSCCustomAdvGroup.RollBtnWidth: Integer;
var
  Im: Integer;
begin
  Result := 0;
  if not FShowRoller then Exit;

  if FDefaultButtons then
  begin
    Result := 16;
    if FRectDefaultButtons then
      Result := 18;
    Exit;
  end;

  Im := RollupIndex;
  if not FExpanded then
    Im := RolldownIndex;

  if IsValidImage(Im) then
  begin
    Result := Images.Width;
    Exit;
  end;
end;

function TSCCustomAdvGroup.RolldownIndex: Integer;
begin
  Result := -1;
  if (FCaptionProps <> nil) and
    (FDisabledCaptionProps <> nil) and (FHotCaptionProps <> nil) then
  begin
    if not Enabled then
    begin
      Result := FDisabledCaptionProps.DownButton;
      if not IsValidIcon(Result) then
        Result := FCaptionProps.DownButton;
      Exit;
    end;

    Result := FCaptionProps.DownButton;

    if GetIsCaptionHot then
    begin
      Result := FHotCaptionProps.DownButton;
      if not IsValidIcon(Result) then
        Result := FCaptionProps.DownButton;
    end;
  end;
end;

function TSCCustomAdvGroup.RollupIndex: Integer;
begin
  Result := -1;
  if (FCaptionProps <> nil) and
    (FDisabledCaptionProps <> nil) and (FHotCaptionProps <> nil) then
  begin
    if not Enabled then
    begin
      Result := FDisabledCaptionProps.UpButton;
      if not IsValidIcon(Result) then
        Result := FCaptionProps.UpButton;
      Exit;
    end;

    Result := FCaptionProps.UpButton;

    if GetIsCaptionHot then
    begin
      Result := FHotCaptionProps.UpButton;
      if not IsValidIcon(Result) then
        Result := FCaptionProps.UpButton;
    end;
  end;
end;

function TSCCustomAdvGroup.RoundSize(Ch: Integer): Integer;
var
  W: Integer;
begin
  Result := 0;

  if FRounded and FShowCaption and
    (FCaptionHeight <> 0) and (Border = sccbNone) and
    (BorderWidth = 0) and CanGetClientRect then
  begin
    Result := 2;

    W := ClientWidth;
    if Result > W then Result := W;

    if Result > 0 then
    begin
      if Ch < 0 then
        Ch := GetCaptionHeight;
      if Result > Ch then Result := Ch;
    end;
  end;
end;

procedure TSCCustomAdvGroup.SetCaptionButtonColors(Value: TSCAdvGroupButtons);
begin
  FCaptionButtonColors.Assign(Value);
end;

procedure TSCCustomAdvGroup.SetCaptionCursor(Value: TCursor);
begin
  if FCaptionCursor <> Value then
  begin
    FCaptionCursor := Value;
    UpdateCursor(False);
  end;
end;

procedure TSCCustomAdvGroup.SetCaptionDisabledFontColor(Value: TColor);
begin
  if FCaptionDisabledFontColor <> Value then
  begin
    FCaptionDisabledFontColor := Value;
    DoChange;
    if not Enabled then
      CaptionChanged(nil);
  end;
end;

procedure TSCCustomAdvGroup.SetCaptionDownFontColor(Value: TColor);
begin
  if FCaptionDownFontColor <> Value then
  begin
    FCaptionDownFontColor := Value;
    DoChange;
    if FIsCaptionDown and FIsCaptionHot then
      CaptionChanged(nil);
  end;
end;

procedure TSCCustomAdvGroup.SetCaptionFont(Value: TFont);
begin
  FCaptionFont.Assign(Value);
end;

procedure TSCCustomAdvGroup.SetCaptionHeight(Value: Integer);
begin
  if Value < -1 then Value := -1;

  if FCaptionHeight <> Value then
  begin
    FCaptionHeight := Value;
    UpdateBorderRegion;

    DoChange;
    Realign;
    Invalidate;
  end;
end;

procedure TSCCustomAdvGroup.SetCaptionHotFontColor(Value: TColor);
begin
  if FCaptionHotFontColor <> Value then
  begin
    FCaptionHotFontColor := Value;
    DoChange;
    if GetIsCaptionHot then
      CaptionChanged(nil);
  end;
end;

procedure TSCCustomAdvGroup.SetCaptionProps(Value: TSCAdvGroupCaption);
begin
  FCaptionProps.Assign(Value);
end;

procedure TSCCustomAdvGroup.SetCaptionSettings(
  Value: TSCAdvGroupCaptionSettings);
begin
  FCaptionSettings.Assign(Value);
end;

procedure TSCCustomAdvGroup.SetCaptionStyle(Value: TSCGroupCaptionStyle);
begin
  if FCaptionStyle <> Value then
  begin
    FCaptionStyle := Value;
    DoChange;
    if FShowCaption and (FCaptionHeight <> 0) then
      CaptionChanged(nil);
  end;
end;

procedure TSCCustomAdvGroup.SetDefaultButtons(Value: Boolean);
begin
  if FDefaultButtons <> Value then
  begin
    FDefaultButtons := Value;
    DoChange;
    if FShowCaption and
      (FShowClose or FShowRoller) and (FCaptionHeight <> 0) then
      CaptionChanged(nil);
  end;
end;

procedure TSCCustomAdvGroup.SetDefaultIcon(Value: Boolean);
begin
  if FDefaultIcon <> Value then
  begin
    FDefaultIcon := Value;
    DoChange;
    if FShowCaption and (FCaptionHeight <> 0) then
      CaptionChanged(nil);
  end;
end;

procedure TSCCustomAdvGroup.SetDisabledCaptionProps(
  Value: TSCAdvGroupCaption);
begin
  FDisabledCaptionProps.Assign(Value);
end;

procedure TSCCustomAdvGroup.SetExpanded(Value: Boolean);
var
  C: TControl;
  P: TSCGroupContainer;
  HasScrl, Exp: Boolean;
  I, Pos, Eh, H, OldH, Delta: Integer;
begin
  if FExpanded <> Value then
  begin
    if (Value and not CanExpand) or (not Value and not CanCollapse) then
      Exit;

    Exp := FExpanded;

    P := nil;
    HasScrl := False;

    FExpanding := True;
    try
      if (Parent <> nil) and (Parent is TSCGroupContainer) then
      begin
        P := TSCGroupContainer(Parent);
        HasScrl := P.IsScrollBarVisible;
      end;

      OldH := Height;
      FExpanded := Value;

      H := GetCollapsedHeight;
      if FExpanded then
      begin
        Eh := ExpandedHeight;
        if Eh < H then Eh := H;

        if (Parent = nil) or (P <> nil) then
        begin
          Height := Eh;
          if Height <> Eh then
            Realign;
        end else
        if Parent <> nil then
        begin
          Parent.DisableAlign;
          try
            Delta := Eh - Height;

            if (Align = alBottom) and (Delta <> 0) then
            begin
              Pos := Self.Top + Self.Height;

              for I := 0 to Parent.ControlCount-1 do
              begin
                C := Parent.Controls[I];
                if (C <> Self) and (C.Top >= Pos) then
                begin
                  if C.Align = alTop then
                    C.Top := C.Top + Delta + 1
                  else if (C.Align = alClient) and (C.Top = Pos) then
                  begin
                    C.Top := C.Top + Delta;
                    C.Height := C.Height - Delta;
                  end;
                end;
              end;

              Top := Top - Delta;
            end else
            if (Align = alTop) and (Delta <> 0)  then
            begin
              for I := 0 to Parent.ControlCount-1 do
              begin
                C := Parent.Controls[I];

                if (C <> Self) and (C.Top + C.Height <= Self.Top) then
                begin
                  if C.Align = alBottom then
                    C.Top := C.Top - Delta - 1
                  else if (C.Align = alClient) and (C.Top + C.Height = Self.Top) then
                    C.Height := C.Height - Delta;
                end;
              end;
            end;

            Height := Eh;
          finally
            Parent.EnableAlign;
          end;
        end;

        H := GetCollapsedHeight;
        if (Eh > H) and (Height <= H) then
        begin
          FExpanded := False;
          UpdateCaption(False);
        end;
      end else
      begin
        Height := H;

        H := GetCollapsedHeight;
        if Height > H then
        begin
          FExpanded := True;
          UpdateCaption(False);
        end;
      end;

      if (OldH <> Height) and (P <> nil) then
      begin
        with P do
        begin
          UpdateScrollBar;

          ShowPanel(Self);
          NormalizeScrollPos;
        end;

        if HasScrl <> P.IsScrollBarVisible then
          Realign;
      end;

      if Exp <> FExpanded then
      begin
        if (Parent <> nil) and (Parent is TSCGroupContainer) then
          TSCGroupContainer(Parent).ExpandChanged(Self);

        if Assigned(FOnExpand) then
          FOnExpand(Self);
      end;
    finally
      FExpanding := False;
    end;
  end;
end;

procedure TSCCustomAdvGroup.SetExpandedHeight(Value: Integer);
var
  Ch: Integer;
begin
  if not (IsLoading or IsReading) then
  begin
    Ch := GetCollapsedHeight;
    if Value < Ch then
      Value := Ch;
  end;

  FExpandedHeight := Value;
end;

procedure TSCCustomAdvGroup.SetHotCaptionProps(Value: TSCAdvGroupCaption);
begin
  FHotCaptionProps.Assign(Value);
end;

procedure TSCCustomAdvGroup.SetHottrack(Value: Boolean);
var
  CHot: Boolean;
begin
  if FHottrack <> Value then
  begin
    CHot := GetIsCaptionHot;
    DoChange;

    FHottrack := Value;
    if CHot then UpdateCaption(False);
  end;
end;

procedure TSCCustomAdvGroup.SetHottrackButtons(Value: Boolean);
begin
  if FHottrackButtons <> Value then
  begin
    FHottrackButtons := Value;
    if GetIsButtonsHot then
      UpdateCaption(False);
  end;
end;

procedure TSCCustomAdvGroup.SetIcons(Value: TCustomImageList);
var
  FOldIcons: TCustomImageList;
begin
  FOldIcons := FIcons;
  if FIcons <> nil then
    FIcons.UnRegisterChanges(FIconChangeLink);

  FIcons := Value;
  if FIcons <> nil then
  begin
    FIcons.RegisterChanges(FIconChangeLink);
    FIcons.FreeNotification(Self);
  end;

  if FShowIcon and (FOldIcons <> FIcons) then
  begin
    UpdateBorderRegion;
    if IsValidIcon(IconIndex) then
      IconsChanged(Self);
  end;
end;

procedure TSCCustomAdvGroup.SetMxDefaultButtons(Value: Boolean);
begin
  if FMxDefaultButtons <> Value then
  begin
    FMxDefaultButtons := Value;
    DoChange;
    UpdateCaption(False);
  end;
end;

procedure TSCCustomAdvGroup.SetRectDefaultButtons(Value: Boolean);
begin
  if FRectDefaultButtons <> Value then
  begin
    FRectDefaultButtons := Value;
    DoChange;
    UpdateCaption(False);
  end;
end;

procedure TSCCustomAdvGroup.SetRounded(Value: Boolean);
begin
  if FRounded <> Value then
  begin
    FRoundChanging := True;
    try
      FRounded := Value;
      DoChange;

      if FShowCaption then
      begin
        UpdateBorderRegion;
        CaptionChanged(nil);
      end;
    finally
      FRoundChanging := False;
      UpdateBorderRegion;
    end;
  end;
end;

procedure TSCCustomAdvGroup.SetShowCaption(Value: Boolean);
begin
  if FShowCaption <> Value then
  begin
    FShowCaption := Value;
    UpdateBorderRegion;

    DoChange;

    if FCaptionHeight <> 0 then
    begin
      Realign;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomAdvGroup.SetShowCaptionLine(Value: Boolean);
var
  Ch: Integer;
begin
  if FShowCaptionLine <> Value then
  begin
    FShowCaptionLine := Value;
    DoChange;

    if FShowCaption and (FCaptionHeight <> 0) then
    begin
      if FCaptionHeight = -1 then
      begin
        SetBounds(Left, Top, Width, Height);

        if HandleAllocated and not Expanded and not IsLoading then
        begin
          Ch := GetCollapsedHeight;
          if Height <> Ch then
            Height := Ch;
        end;
      end;

      CaptionChanged(nil);
    end;
  end;
end;

procedure TSCCustomAdvGroup.SetShowCaptionUpLine(Value: Boolean);
var
  Ch: Integer;
begin
  if FShowCaptionUpLine <> Value then
  begin
    FShowCaptionUpLine := Value;
    DoChange;

    if FShowCaption and (FCaptionHeight <> 0) then
    begin
      if FCaptionHeight = -1 then
      begin
        SetBounds(Left, Top, Width, Height);

        if HandleAllocated and not Expanded and not IsLoading then
        begin
          Ch := GetCollapsedHeight;
          if Height <> Ch then
            Height := Ch;
        end;
      end;

      CaptionChanged(nil);
    end;
  end;
end;

procedure TSCCustomAdvGroup.SetShowClose(Value: Boolean);
begin
  if FShowClose <> Value then
  begin
    FShowClose := Value;
    DoChange;
    if FShowCaption and (GetCaptionHeight <> 0) then
      CaptionChanged(nil);
  end;
end;

procedure TSCCustomAdvGroup.SetShowIcon(Value: Boolean);
begin
  if FShowIcon <> Value then
  begin
    FShowIcon := Value;
    DoChange;

    if FShowCaption and IsValidIcon(IconIndex) and
      (GetCaptionHeight > 0) then
      CaptionChanged(nil);
  end;
end;

procedure TSCCustomAdvGroup.SetShowRoller(Value: Boolean);
begin
  if FShowRoller <> Value then
  begin
    FShowRoller := Value;
    DoChange;
    if FShowCaption and (GetCaptionHeight <> 0) then
      CaptionChanged(nil);
  end;
end;

procedure TSCCustomAdvGroup.StopTracking;
begin
  FIsCaptionHot := False;
  FIsCaptionDown := False;
  FIsMouseDown := False;
  FIsMouseInControl := False;

  inherited StopTracking;
end;

procedure TSCCustomAdvGroup.TrackCaption(X, Y: Integer);
var
  R: TRect;
  CP, P: TPoint;
  Ch: Integer;
begin
  FIsCaptionHot := False;

  if Enabled then
  begin
    P := Point(X, Y);
    R := ClientRect;

    if PtInRect(R, P) then
    begin
      Ch := GetCaptionHeight;

      if Ch > 0 then
      begin
        if Ch > R.Bottom - R.Top then
          Ch := R.Bottom - R.Top;

        R.Bottom := R.Top + Ch;

        if not GetCursorPos(CP) then
          CP := ClientToScreen(P);

        FIsCaptionHot := PtInRect(R, P) and
          (FindDragTarget(CP, True) = Self);
      end;
    end;
  end;
end;

procedure TSCCustomAdvGroup.TransparentChanged;
begin
  if (FGradient = scgNone) or (FEndColor = clNone) then
    Invalidate;
end;

procedure TSCCustomAdvGroup.UpdateBorderRegion(UpdatePaint: Boolean);
var
  R: TRect;
  Rgn: HRGN;
begin
  R := Rect(0, 0, Width, Height);
  if IsRectEmpty(R) then Exit;

  if FRoundChanging or FRounded then
    Rgn := CreateBorderRgn(R)
  else
    Rgn := CreateRectRgnIndirect(R);

  try
    SetWindowRgn(Handle, Rgn, UpdatePaint);
  finally
    DeleteObject(Rgn);
  end;
end;

procedure TSCCustomAdvGroup.UpdateCaption(DoRegionUpdate: Boolean);
var
  R: TRect;
  P: TPoint;
  CpHeight, Ch: Integer;
begin
  if CanGetClientRect and HandleAllocated then
  begin
    R := GetClientRect;

    if not IsRectEmpty(R) then
    begin
      if DoRegionUpdate then
        UpdateBorderRegion;

      CpHeight := FLastCaptionHeight;
      Ch := GetCaptionHeight;

      if Ch > 0 then
      begin
        if Ch < R.Bottom - R.Top then
          R.Bottom := R.Top + Ch;

        InvalidateRect(Handle, @R, True);
      end;

      if CpHeight <> FLastCaptionHeight then
      begin
        GetCursorPos(P);
        P := ScreenToClient(P);
        
        TrackCaption(P.x, P.y);
      end;
    end;
  end;
end;

procedure TSCCustomAdvGroup.UpdateCaptionFont(F: TFont);
begin
  if F <> nil then
  begin
    F.Assign(FCaptionFont);

    if not Enabled then
    begin
      F.Color := FCaptionDisabledFontColor;
      if FDisabledCaptionProps.Underline then
        F.Style := F.Style + [fsUnderline];
    end else
    if FHottrack then
    begin
      if FIsCaptionDown and FIsCaptionHot then
      begin
        F.Color := FCaptionDownFontColor;
        if FCaptionProps.Underline then
          F.Style := F.Style + [fsUnderline];
      end else
      if FIsCaptionHot or FIsCaptionDown then
      begin
        F.Color := FCaptionHotFontColor;
        if FHotCaptionProps.Underline then
          F.Style := F.Style + [fsUnderline];
      end else
      if FCaptionProps.Underline then
        F.Style := F.Style + [fsUnderline];
    end else
    if FCaptionProps.Underline then
      F.Style := F.Style + [fsUnderline];
  end;
end;

procedure TSCCustomAdvGroup.UpdateCursor(UpTrack: Boolean);
var
  P: TPoint;
  Cr: TCursor;
begin
  if not IsDesigning then
  begin
    FUpdatingCursor := True;
    try
      if UpTrack then
      begin
        GetCursorPos(P);
        P := ScreenToClient(P);

        TrackCaption(P.x, P.y);
      end;

      Cr := GetCurrentCursor;
      if FIsCaptionHot or FIsCaptionDown then
        Cr := FCaptionCursor;

      Cursor := Cr;
    finally
      FUpdatingCursor := True;
    end;
  end;  
end;

procedure TSCCustomAdvGroup.UpdateTracking;
var
  P: TPoint;
begin
  if Enabled then
  begin
    GetCursorPos(P);

    FIsMouseInControl := not (FindDragTarget(P, True) = Self);
    if FIsMouseInControl then
      Perform(CM_MOUSELEAVE, 0, 0)
    else
      Perform(CM_MOUSEENTER, 0, 0);
  end;
end;


procedure TSCCustomAdvGroup.WMSize(var Message: TWMSize);
var
  H, Ch: Integer;
  InRead: Boolean;
  P: TControl;
begin
  InRead := (GetParentHandle = 0) or FExpanding or
    IsLoading or IsReading;

  Ch := 0;
  if not InRead then
  begin
    Ch := GetCollapsedHeight;
    if not FExpanded or (Message.Height < Ch) then
      Message.Height := Ch;
  end;

  inherited;

  if not InRead then
  begin
    H := Height;
    if (H <= Ch) or not FExpanded then
    begin
      Height := Ch;
      if CanCollapse and not IsOutlookStyle then
        FExpanded := False;
    end;

    P := Parent;
    if FExpanded and (H > Ch) and
      not (FInStyleChange or FExpanding or IsOutlookStyle) then
    begin
      if (P <> nil) and (P is TSCGroupContainer) and
        TSCGroupContainer(P).FInStyleChange then Exit;

      FExpandedHeight := H;
    end;
  end;

  UpdateBorderRegion;
end;

{ TSCAdvGroupCaption }

procedure TSCAdvGroupCaption.Assign(Source: TPersistent);
begin
  if Source is TSCAdvGroupCaption then
  begin
    with TSCAdvGroupCaption(Source) do
    begin
      Self.FCloseButton := CloseButton;
      Self.FColor := Color;
      Self.FEndColor := EndColor;
      Self.FGradient := Gradient;
      Self.FIcon := Icon;
      Self.FLineColor := LineColor;
      Self.FDownButton := DownButton;
      Self.FUpButton := UpButton;
      Self.FUnderline := Underline;
    end;

    DoChange;
  end else
    inherited Assign(Source);
end;

constructor TSCAdvGroupCaption.Create(AOwner: TSCCustomAdvGroup);
begin
  inherited Create;
  FOwner := AOwner;

  FCloseButton := -1;
  FColor := clBtnHighlight;
  FEndColor := clBtnFace;
  FGradient := scgLeftToRight;
  FIcon := -1;
  FLineColor := clHighlight;
  FDownButton := -1;
  FUpButton := -1;
  FUnderline := False;
end;

procedure TSCAdvGroupCaption.DoChange;
begin
  if FOwner <> nil then
    FOwner.CaptionChanged(Self);

  if not FLockChange and Assigned(FOnChange) then
    FOnChange(Self);
end;

function TSCAdvGroupCaption.GetIcons: TCustomImageList;
begin
  Result := nil;
  if FOwner <> nil then Result := FOwner.Icons;
end;

function TSCAdvGroupCaption.GetImages: TCustomImageList;
begin
  Result := nil;
  if FOwner <> nil then Result := FOwner.Images;
end;

function TSCAdvGroupCaption.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCAdvGroupCaption.LockChange;
begin
  FLockChange := True;
end;

procedure TSCAdvGroupCaption.SetCloseButton(Value: TImageIndex);
begin
  if Value < -1 then Value := -1;

  if FCloseButton <> Value then
  begin
    FCloseButton := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupCaption.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupCaption.SetDownButton(Value: TImageIndex);
begin
  if Value < -1 then Value := -1;

  if FDownButton <> Value then
  begin
    FDownButton := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupCaption.SetEndColor(Value: TColor);
begin
  if FEndColor <> Value then
  begin
    FEndColor := Value;
    if FGradient <> scgNone then
      DoChange;
  end;
end;

procedure TSCAdvGroupCaption.SetGradient(Value: TSCGradient);
begin
  if FGradient <> Value then
  begin
    FGradient := Value;
    if FEndColor <> clNone then
      DoChange;
  end;
end;

procedure TSCAdvGroupCaption.SetIcon(Value: TImageIndex);
begin
  if Value < -1 then Value := -1;

  if FIcon <> Value then
  begin
    FIcon := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupCaption.SetLineColor(Value: TColor);
begin
  if FLineColor <> Value then
  begin
    FLineColor := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupCaption.SetUnderline(Value: Boolean);
begin
  if FUnderline <> Value then
  begin
    FUnderline := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupCaption.SetUpButton(Value: TImageIndex);
begin
  if Value < -1 then Value := -1;

  if FUpButton <> Value then
  begin
    FUpButton := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupCaption.UnlockChange;
begin
  FLockChange := False;
end;

{ TSCGroupContainer }

procedure TSCGroupContainer.AdjustClientRect(var Rect: TRect);
var
  I: Integer;
begin
  if IsOutlookStyle then
  begin
    Rect := GetClientRect;
    Exit;
  end;

  inherited AdjustClientRect(Rect);

  I := GetGroupIndent;
  InflateRect(Rect, -I, -I);
end;

procedure TSCGroupContainer.AlignControls(AControl: TControl;
  var Rect: TRect);

  procedure CreateArrangeList(L: TList);
  var
    I: Integer;
    C: TControl;
    InDesign: Boolean;
    G: TSCCustomGroup;
  begin
    L.Clear;

    InDesign := IsDesigning;
    
    for I := 0 to ControlCount-1 do
    begin
      C := TControl(Controls[I]);

      if C is TSCCustomGroup then
      begin
        G := TSCCustomGroup(C);
        if (Style <> scasCustom) and (G.Style <> scasCustom) then
          G.FStyle := Self.Style;
      end;

      if InDesign or C.Visible then
        L.Add(C);
    end;
  end;

  function ArrangeMxList(L: TList): Boolean;
  var
    I: Integer;
    C: TControl;
    InDesign, LineSet: Boolean;
    G: TSCCustomAdvGroup;
  begin
    Result := True;
    if FStyle <> scasMXBar then Exit;

    LineSet := False;
    InDesign := IsDesigning;

    for I := L.Count-1 downto 0 do
    begin
      C := TControl(L[I]);

      if (InDesign or C.Visible) and
        (C is TSCCustomAdvGroup) then
      begin
        G := TSCCustomAdvGroup(C);
        if I <> 0 then
          G.ShowCaptionUpLine := True;

        if LineSet then
        begin
          Result := Result or G.ShowCaptionLine;
          G.ShowCaptionLine := False;
        end else
        begin
          LineSet := True;
          Result := Result or (G.ShowCaptionLine <> not G.Expanded);

          G.ShowCaptionLine := not G.Expanded;
        end;
      end;
    end;

    if L.Count > 0 then
    begin
      C := TControl(L[0]);

      if (InDesign or C.Visible) and
        (C is TSCCustomAdvGroup) then
      begin
        G := TSCCustomAdvGroup(C);
        G.ShowCaptionUpLine := False;
      end;
    end;
  end;

  procedure ArrangeAlignList(L: TList);
  var
    I: Integer;
    C1, C2: TControl;
    Changed: Boolean;
  begin
    Changed := False;
    for I := 1 to L.Count-1 do
    begin
      C1 := TControl(L[I - 1]);
      C2 := TControl(L[I]);

      if C2.Top < C1.Top then
      begin
        L.Exchange(I, I-1);
        Changed := True;
      end;
    end;

    if Changed and (L.Count > 2) then
      ArrangeAlignList(L);
  end;

  function ExpandedPanel: TSCCustomAdvGroup;
  var
    I: Integer;
    C: TControl;
    InDesign: Boolean;
  begin
    Result := nil;

    C := AControl;
    if not FSettingStyle and
      (C <> nil) and (C is TSCCustomAdvGroup) and
      TSCCustomAdvGroup(C).FExpanding and TSCCustomAdvGroup(C).Expanded then
    begin
      Result := TSCCustomAdvGroup(C);
      Exit;
    end;

    InDesign := IsDesigning;
    
    for I := 0 to ControlCount-1 do
    begin
      C := Controls[I];

      if (InDesign or C.Visible) and
        (C is TSCCustomAdvGroup) then
      begin
        if Result = nil then
          Result := TSCCustomAdvGroup(C);

        if TSCCustomAdvGroup(C).Expanded then
        begin
          Result := TSCCustomAdvGroup(C);
          Exit;
        end;
      end;
    end;
  end;

  procedure DoAlign(CR: TRect; L: TList);
  var
    Sp, W,
    Ch, H, T, I: Integer;
    C: TControl;
    P: TSCCustomAdvGroup;
  begin
    T := CR.Top - ScrollPosition;

    W := CR.Right - CR.Left;
    if W < 0 then W := 0;

    Sp := GetSpacing;
    if Sp < 0 then Sp := 0;

    for I := 0 to L.Count-1 do
    begin
      C := TControl(L[I]);

      H := C.Height;

      if InStyleChange and
        (C is TSCCustomAdvGroup) then
      begin
        P := TSCCustomAdvGroup(C);

        H  := P.ExpandedHeight;
        Ch := P.GetCollapsedHeight;

        if H < Ch then H := Ch;
      end;

      C.SetBounds(CR.Left, T, W, H);
      if C is TWinControl then
        TWinControl(C).Realign;

      Inc(T, C.Height + Sp);
    end;
  end;

  {procedure DoMxAlign(CR: TRect; L: TList);
  var
    Sp, Ch, W, H, 
    TotalH, T, I: Integer;
    C: TControl;
    P: TSCCustomAdvGroup;
  begin
    W := CR.Right - CR.Left;
    if W < 0 then W := 0;

    P := nil;
    TotalH := 0;
    for I := L.Count-1 downto 0 do
    begin
      C := TControl(L[I]);
      Inc(TotalH, C.Height);

      if (P = nil) and
        (C is TSCCustomAdvGroup) and
        TSCCustomAdvGroup(C).Expanded then
        P := TSCCustomAdvGroup(C);
    end;
  end;}

  function DoOutlookAlign(L: TList): TSCCustomAdvGroup;
  var
    Ch, H, Eh,
    W, T, I: Integer;
    C: TControl;
    EP, P: TSCCustomAdvGroup;
  begin
    Result := nil;

    W := ClientWidth;
    if W < 0 then W := 0;

    EP := ExpandedPanel;

    Eh := 0;
    if EP <> nil then Eh := EP.Height;

    H := 0;
    for I := 0 to L.Count-1 do
    begin
      C := TControl(L[I]);

      if C <> EP then
      begin
        if C is TSCCustomAdvGroup then
        begin
          P := TSCCustomAdvGroup(C);
          Ch := P.GetCollapsedHeight;

          P.FSettingStyle := True;
          try
            P.Expanded := False;
            P.Height := Ch;
          finally
            P.FSettingStyle := False;
          end;
        end;

        Inc(H, C.Height);
      end;
    end;

    H := ClientHeight - H;

    T := 0;
    for I := 0 to L.Count-1 do
    begin
      C := TControl(L[I]);
      if C = nil then Exit;

      if C = EP then
      begin
        Result := EP;
        
        Ch := EP.GetCollapsedHeight;
        if H < Ch then H := Ch;

        EP.FSettingStyle := True;
        try
          EP.Expanded := True;
          EP.Height := H;
        finally
          EP.FSettingStyle := False;
        end;
      end;

      C.SetBounds(0, T, W, C.Height);
      if C is TWinControl then
        TWinControl(C).Realign;

      Inc(T, C.Height);
    end;

    if (EP <> nil) and (Eh <> EP.Height) then
    begin
      EP.Realign;
      EP.Invalidate;
    end;
  end;

  procedure AdjustInRect(R: TRect);
  var
    L: TList;
    I: Integer;
    Op: TSCCustomAdvGroup;
  begin
    AdjustClientRect(R);

    L := TList.Create;
    try
      CreateArrangeList(L);
      ArrangeAlignList(L);

      ArrangeMxList(L);

      if IsOutlookStyle then
      begin
        Op := DoOutlookAlign(L);

        if FExpandToTop and (Op <> nil) and (L.Count > 1) then
        begin
          ArrangeAlignList(L);

          I := L.IndexOf(Op);
          if I > -1 then
          begin
            L.Move(I, 0);
            DoOutlookAlign(L);
          end;
        end;
      end else
        DoAlign(R, L);
    finally
      L.Free;
    end;
  end;

begin
  if FSettingStyle or FScrolling or IsLoading or
    ((Parent <> nil) and (csLoading in Parent.ComponentState)) then
    Exit;

  if DockSite and UseDockManager and (DockManager <> nil) then
    DockManager.ResetBounds(False);

  AdjustInRect(Rect);

  if UpdateScrollBar then
  begin
    Rect := GetClientRect;
    AlignControls(nil, Rect);
    
    Exit;
  end;

  ExpandChanged(ExpandedPanel);
  if Showing then
    AdjustSize;
end;

procedure TSCGroupContainer.ApplyStyle(S: TSCAdvPanelStyle; DoUpdate: Boolean);
var
  I: Integer;
  C: TControl;
begin
  FSettingStyle := True;
  FInStyleChange := True;

  try
    for I := 0 to ControlCount-1 do
    begin
      C := Controls[I];
      if C is TSCCustomGroup then
        TSCCustomGroup(C).Style := Self.Style;
    end;

    UpdateScrollBar;

    if FStyle = scasCustom then Exit;

    FBevel := sccbLowered;
    FBevelColor := clNone;
    FBevelDotted := False;
    FBevelEx := True;
    FBevelWidth := 0;

    case S of
      scasExplorerBar:
      begin
        FGradient := scgNone;
        Indent    := 8;
        Spacing   := 8;
        Color     := clExplorerBackColor;

        FScrollbarView := scsbShow;
      end;
      scasMXBar:
      begin
        FEndColor := clBtnShadow;
        FGradient := scgNone;
        Indent    := 0;
        Spacing   := 0;
        Color     := clBtnShadow;

        FScrollbarView := scsbShow;
      end;
      scasAdvXPBar:
      begin
        FEndColor := clAdvXPGrpEndColor;
        FGradient := scgTopToBottom;
        Indent    := 8;
        Spacing   := 8;
        Color     := clAdvXPGrpStartColor;

        FScrollbarView := scsbShow;
      end;
      scasXPBar:
      begin
        FEndColor := cl3DDkShadow;
        FGradient := scgTopToBottom;
        Indent    := 8;
        Spacing   := 8;
        Color     := clBtnFace;

        FScrollbarView := scsbShow;
      end;
      scasOutlookBar,
      scasOutlookBar2k, scasOfficeXP, scasOutlookBarXP:
      begin
        FGradient := scgNone;
        Indent    := 0;
        Spacing   := 0;

        if S in [scasOfficeXP, scasOutlookBarXP] then
          Color := clSilver
        else
          Color := clBtnShadow;

        ExpandChanged(nil);
        FScrollbarView := scsbHide;
      end;
      scasTaskList:
      begin
        FGradient := scgNone;
        Indent    := 8;
        Spacing   := 8;
        Color     := clWindow;

        FScrollbarView := scsbShow;
      end;
    end;

    FSettingStyle := False;

    Realign;
    Invalidate;

    for I := 0 to ControlCount-1 do
    begin
      C := Controls[I];
      if C is TSCCustomAdvGroup then
        TSCCustomAdvGroup(C).UpdateBorderRegion;
    end;
  finally
    FSettingStyle := False;
    FInStyleChange := False;

    UpdateScrollBar;
    NormalizeScrollPos(True);
    SetScrollPosition(0);
  end;
end;

procedure TSCGroupContainer.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCGroupContainer then
  begin
    with TSCGroupContainer(Source) do
    begin
      Self.ScrollBarView := ScrollBarView;
      Self.ExpandToTop := ExpandToTop;
      Self.Scrollbar := Scrollbar;
    end;
  end;
end;

function TSCGroupContainer.CanShowScrollbar: Boolean;
begin
  Result := (FScrollbarView = scsbShow) and not IsOutlookStyle;
end;

procedure TSCGroupContainer.CMControlChange(var Message: TMessage);
begin
  inherited;
  if Boolean(Message.LParam) and not IsLoading and
    (TObject(Message.WParam) is TSCCustomGroup) then
    TSCCustomGroup(Message.WParam).Style := Self.Style;
end;

procedure TSCGroupContainer.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
  if FAutoScroll then
    with Message do
      if (Sender <> nil) and (Parent <> nil) and ContainsControl(Sender) then
        ScrollInView(Sender);
end;

constructor TSCGroupContainer.Create(AOwner: TComponent);
begin
  FLoaded := False;
  FAutoScroll := True;

  inherited Create(AOwner);
  ClickFocus := False;
  SetBounds(Left, Top, 165, 45);

  Align := alLeft;
  Border := sccbLowered;
  Color := clBtnShadow;
  FEndColor := cl3DDkShadow;
  FGradient := scgTopToBottom;
  Indent := 8;
  Spacing := 8;
  UseDockManager := True;
  FScrollBarView := scsbShow;
end;

procedure TSCGroupContainer.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    Style := Style or WS_CLIPCHILDREN;
    ExStyle := ExStyle or WS_EX_CONTROLPARENT;
  end;
end;

procedure TSCGroupContainer.CreateWnd;
begin
  inherited CreateWnd;
  UpdateScrollBar;
end;

procedure TSCGroupContainer.DoScrollerPositionChanged(
  Kind: TSCScrollbarKind);
var
  OldState: Boolean;
  Sb: TSCGroupContainerScrollbar;
begin
  if FScrollPosChanging then
    Exit;

  OldState := FScrollbarChanging;
  FScrollbarChanging := True;
  try
    if Kind = scskVertical then
    begin
      Sb := TSCGroupContainerScrollbar(ScrollbarVert);
      SetScrollPosition(Sb.Position);
    end;
  finally
    FScrollbarChanging := OldState;
  end;
end;

procedure TSCGroupContainer.ExpandChanged(P: TSCCustomAdvGroup);
var
  I: Integer;
  C: TControl;
  InDesign: Boolean;
begin
  if not FSettingStyle and IsOutlookStyle then
  begin
    InDesign := IsDesigning;

    for I := 0 to ControlCount-1 do
    begin
      C := Controls[I];

      if (InDesign or C.Visible) and (C is TSCCustomAdvGroup) then
      begin
        if P = nil then
          P := TSCCustomAdvGroup(C);
        TSCCustomAdvGroup(C).Expanded := C = P;
      end;
    end;
  end;
end;

function TSCGroupContainer.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCGroupBorderProps;
end;

function TSCGroupContainer.GetDefaultScrollInfo(
  Kind: TSCScrollbarKind): TScrollInfo;
begin
  Result := inherited GetDefaultScrollInfo(Kind);
  if Kind = scskHorizontal then
    Result.nMax := Result.nMin;
end;

function TSCGroupContainer.GetGroupIndent: Integer;
begin
  Result := Indent;
end;

function TSCGroupContainer.GetScrollbar: TSCGroupContainerScrollbar;
begin
  Result := TSCGroupContainerScrollbar(Self.ScrollbarVert);
end;

function TSCGroupContainer.GetScrollbarClass: TSCCustomControlScrollbarClass;
begin
  Result := TSCGroupContainerScrollbar;
end;

function TSCGroupContainer.GetScrollHeight: Integer;
var
  C: TControl;
  R: TRect;
  Ch, Sp, I, Cnt: Integer;
  InDesign: Boolean;
begin
  Result := 0;

  if (FScrollbarView = scsbShow) and
    (ControlCount > 0) and CanShowScrollbar then
  begin
    InDesign := IsDesigning;

    Cnt := 0;
    for I := 0 to ControlCount-1 do
    begin
      C := Controls[I];

      if InDesign or C.Visible then
      begin
        Inc(Cnt);
        Inc(Result, C.Height);
      end;
    end;

    Dec(Cnt);
    if Cnt > 0 then
    begin
      Sp := GetSpacing;
      if Sp > 0 then Inc(Result, Cnt*Sp);
    end;

    R := GetClientRect;
    OffsetRect(R, -R.Left, -R.Top);

    AdjustClientRect(R);
    // Inc(Result, R.Top);

    Ch := R.Bottom - R.Top;
    if Ch < 0 then Ch := 0;

    Dec(Result, Ch);
    if Result < 0 then Result := 0;
  end;
end;

function TSCGroupContainer.GetSpacing: Integer;
begin
  Result := Spacing;
end;

procedure TSCGroupContainer.IndentChanged;
begin
  inherited IndentChanged;

  if not FSettingStyle and (ControlCount > 0) then
  begin
    Realign;
    Invalidate;
  end;
end;

function TSCGroupContainer.IsLastControl(C: TControl): Boolean;
var
  I: Integer;
  InDesign: Boolean;
  C2: TControl;
begin
  Result := False;
  if (C = nil) or (C.Parent <> Self) then Exit;

  InDesign := IsDesigning;
  if not (InDesign or C.Visible) then
    Exit;

  Result := True;
  for I := 0 to ControlCount-1 do
  begin
    C2 := Controls[I];

    if (C2 <> C) and (C2 <> nil) and (InDesign or C2.Visible) and
      ((C2.Top > C.Top) or ((C2.Top = C.Top) and (C2.Height > C.Height))) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

function TSCGroupContainer.IsScrollBarVisible: Boolean;
var
  R: TRect;
  // Sh: Integer;
begin
  Result := False;

  if (ControlCount > 0) and (FScrollbarView = scsbShow) then
  begin
    R := GetClientRect;
    AdjustClientRect(R);

    if not IsRectEmpty(R) then
    begin
      // Sh := GetScrollHeight;
      // Result := Sh > R.Bottom - R.Top;
      Result := GetScrollHeight > 0;
    end;  
  end;
end;

procedure TSCGroupContainer.Loaded;
begin
  inherited Loaded;
  FLoaded := True;

  Realign;
  UpdateScrollBar;

  {RepositionPanels(True);
  if not NormalizeScrollPos then
    Realign;}
end;

function TSCGroupContainer.NormalizeScrollPos(DoAlign: Boolean): Boolean;
var
  MaxPos, OldS: Integer;
  SI: TSCScrollInfo;
begin
  Result := False;
  if not (IsLoading or IsReading) then
  begin
    OldS := FScrollPosition;

    SI := Self.GetScrollbarInfo(scskVertical);

    if SI.Max = Integer(SI.Page) then
      FScrollPosition := 0
    else begin
      MaxPos := SI.Max - Integer(SI.Page) + SI.Min + 1;

      if FScrollPosition > MaxPos then
        FScrollPosition := MaxPos;
      if FScrollPosition < SI.Min then
        FScrollPosition := SI.Min;
    end;
    
    if DoAlign and (OldS <> FScrollPosition) then
    begin
      Result := True;
      Realign;
    end;
  end;
end;

procedure TSCGroupContainer.RepositionPanels(LockPos: Boolean);
begin
  FLockPosUpdate := LockPos;
  try
    Realign;
  finally
    FLockPosUpdate := False;
  end;
end;

procedure TSCGroupContainer.ScrollControls(Delta: Integer);
begin
  if IsOutlookStyle then Exit;

  FScrolling := True;
  try
    ScrollBy(0, Delta);
    ScrollPosition := ScrollPosition - Delta;

    UpdateScrollBar;
  finally
    FScrolling := False;
  end;
end;

procedure TSCGroupContainer.ScrollInView(C: TControl);
var
  I: Integer;
  P: TSCCustomAdvGroup;
  C2: TControl;
  InDesign: Boolean;
begin
  if C = nil then Exit;

  InDesign := IsDesigning;

  P := nil;
  for I := 0 to ControlCount-1 do
  begin
    C2 := Controls[I];
    if C2 = C then Exit;

    if (InDesign or C2.Visible) and
      (C2 is TSCCustomAdvGroup) and
      TSCCustomAdvGroup(C2).ContainsControl(C) then
    begin
      P := TSCCustomAdvGroup(C2);
      Break;
    end;
  end;

  if P <> nil then
  begin
    P.Expanded := True;
    ShowPanel(P);
  end;
end;

procedure TSCGroupContainer.SetExpandToTop(Value: Boolean);
begin
  if FExpandToTop <> Value then
  begin
    FExpandToTop := Value;
    if Value then
      Realign;
  end;
end;

procedure TSCGroupContainer.SetScrollbar(Value: TSCGroupContainerScrollbar);
begin
  Self.ScrollbarVert.Assign(Value);
end;

procedure TSCGroupContainer.SetScrollBarView(Value: TSCGroupScrollBarView);
begin
  if FScrollBarView <> Value then
  begin
    FScrollBarView := Value;

    if not (IsLoading or IsReading) then
    begin
      UpdateScrollBar;
      if not NormalizeScrollPos then
        Realign;
    end;
  end;
end;

procedure TSCGroupContainer.SetScrollPosition(Value: Integer);
var
  OldState: Boolean;
begin
  OldState := FScrollPosChanging;
  FScrollPosChanging := True;

  try
    if FScrollPosition <> Value then
    begin
      FScrollPosition := Value;

      if not (IsLoading or IsReading) and
        not NormalizeScrollPos then
        Realign;
    end;
  finally
    FScrollPosChanging := OldState;
  end;
end;

procedure TSCGroupContainer.ShowPanel(P: TSCCustomAdvGroup);
var
  H, T,
  Btm, Brd: Integer;
begin
  if (P <> nil) and P.Expanded and not P.IsLoading then
  begin
    T   := P.Top;
    H   := ClientHeight;
    Btm := P.BoundsRect.Bottom;

    Brd := BevelSize + BevelWidth + Indent;
    if IsLastControl(P) then
      Dec(Brd, Indent);

    if (Btm + Brd > H) and (T > 0) then
      ScrollControls(H - Btm - Brd)
    else
    if T < 0 then
      ScrollControls(-T + Brd);
  end;
end;

procedure TSCGroupContainer.SpacingChanged;
begin
  inherited SpacingChanged;

  if not FSettingStyle and (ControlCount > 0) then
  begin
    Realign;
    Invalidate;
  end;
end;

function TSCGroupContainer.UpdateScrollBar: Boolean;
var
  R: TRect;
  ScrlVisible: Boolean;
  SIOld, SINew: TSCScrollInfo;
begin
  Result := False;
  if HandleAllocated then
  begin
    SIOld := Self.GetScrollbarInfo(scskVertical);
    SINew := SIOld;

    ScrlVisible := IsVertScrollBarVisible;

    SINew.Page := 1;
    SINew.Min  := 0;
    SINew.Max  := 0;
    SINew.Pos  := 0;
    SINew.Tracking := False;

    if CanShowScrollbar then
    begin
      R := Self.ClientRect;
      OffsetRect(R, -R.Left, -R.Top);

      AdjustClientRect(R);
      OffsetRect(R, -R.Left, -R.Top);

      if R.Bottom > 0 then
      begin
        SINew.Page := R.Bottom;
        SINew.Min  := 0;
        SINew.Max  := GetScrollHeight + R.Bottom;
        SINew.Pos  := FScrollPosition;
      end;
    end;

    SiNew.TrimPageSize := True;
    SiNew.SmallChange  := 10;
    SiNew.LargeChange  := 50;

    if (SINew.Min <> SIOld.Min) or (SINew.Max <> SIOld.Max) or
      (SINew.Page <> SIOld.Page) or (SINew.Pos <> SIOld.Pos) then
    begin
      SiNew.Visible := (SiNew.Page < SiNew.Max - SiNew.Min) and
        (SiNew.Page > 0) and (SiNew.Max > 0);
        
      Self.SetScrollbarInfo(scskVertical, SINew);

      if Integer(SINew.Page) > SINew.Max then
        ScrollPosition := SINew.Min;
    end;

    Result := ScrlVisible <> IsVertScrollBarVisible;
  end;
end;

procedure TSCGroupContainer.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if Message.WheelDelta < 0 then
    ScrollPosition := ScrollPosition - 10
  else
  if Message.WheelDelta > 0 then
    ScrollPosition := ScrollPosition + 10;
end;

procedure TSCGroupContainer.WMPaint(var Message: TWMPaint);
begin
  DoubleBuffered := CanDrawPicture or HasGradient;
  inherited;
end;

procedure TSCGroupContainer.WMSize(var Message: TWMSize);
begin
  inherited;
  NormalizeScrollPos;
end;

procedure TSCGroupContainer.WMVScroll(var Message: TWMVScroll);
var
  SI: TSCScrollInfo;
begin
  SI := Self.GetScrollbarInfo(scskVertical);

  case Message.ScrollCode of
    SB_LINEUP:
      ScrollPosition := ScrollPosition - 15;
    SB_LINEDOWN:
      ScrollPosition := ScrollPosition + 15;
    SB_PAGEUP:
      ScrollPosition := ScrollPosition - Integer(SI.Page);
    SB_PAGEDOWN:
      ScrollPosition := ScrollPosition + Integer(SI.Page);
    SB_THUMBTRACK:
    begin
      if Message.Pos <= SI.Min then
        ScrollPosition := SI.Min
      else
      if Message.Pos >= SI.Max then
        ScrollPosition := SI.Max
      else
      if Message.Pos >= SI.Max - SI.Page then
        ScrollPosition := SI.Max;
    end;
    SB_THUMBPOSITION:
    begin
      if SI.Pos <= SI.Min then
        ScrollPosition := SI.Min
      else
      if SI.Pos >= SI.Max then
        ScrollPosition := SI.Max
      else
      if Message.Pos >= SI.Max - SI.Page then
        ScrollPosition := SI.Max
      else
        ScrollPosition := SI.Pos;
    end;
    SB_TOP:
      ScrollPosition := SI.Min;
    SB_BOTTOM:
      ScrollPosition := SI.Max;
  end;
end;

{ TSCAdvGroupButtons }

procedure TSCAdvGroupButtons.Assign(Source: TPersistent);
begin
  if Source is TSCAdvGroupButtons then
  begin
    with TSCAdvGroupButtons(Source) do
    begin
      Self.FColor := Color;
      Self.FDisabledColor := DisabledColor;
      Self.FDownColor := DownColor;
      Self.FFrameColor := FrameColor;
      Self.FHotColor := HotColor;
      Self.FIconColor := IconColor;
      Self.FIconDisabledColor := IconDisabledColor;
      Self.FIconDownColor := IconDownColor;
      Self.FIconHotColor := IconHotColor;
    end;

    DoChange;
  end else
    inherited Assign(Source);
end;

constructor TSCAdvGroupButtons.Create(AOwner: TSCCustomAdvGroup);
begin
  inherited Create;
  FOwner := AOwner;

  FColor := clWindow;
  FDisabledColor := clWindow;
  FDownColor := clWindow;
  FFrameColor := clBtnShadow;
  FHotColor := clWindow;
  FIconColor := clHighlight;
  FIconDisabledColor := clBtnShadow;
  FIconDownColor := clIconDownColor;
  FIconHotColor := clIconHotColor;
end;

procedure TSCAdvGroupButtons.DoChange;
begin
  if FOwner <> nil then
    FOwner.CaptionChanged(Self);

  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TSCAdvGroupButtons.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupButtons.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupButtons.SetDownColor(Value: TColor);
begin
  if FDownColor <> Value then
  begin
    FDownColor := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupButtons.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupButtons.SetHotColor(Value: TColor);
begin
  if FHotColor <> Value then
  begin
    FHotColor := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupButtons.SetIconColor(Value: TColor);
begin
  if FIconColor <> Value then
  begin
    FIconColor := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupButtons.SetIconDisabledColor(Value: TColor);
begin
  if FIconDisabledColor <> Value then
  begin
    FIconDisabledColor := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupButtons.SetIconDownColor(Value: TColor);
begin
  if FIconDownColor <> Value then
  begin
    FIconDownColor := Value;
    DoChange;
  end;
end;

procedure TSCAdvGroupButtons.SetIconHotColor(Value: TColor);
begin
  if FIconHotColor <> Value then
  begin
    FIconHotColor := Value;
    DoChange;
  end;
end;

{ TSCListGroupStyle }

procedure TSCListGroupStyle.Assign(Source: TPersistent);
begin
  if Source is TSCListGroupStyle then
  begin
    with TSCListGroupStyle(Source) do
    begin
      Self.BeginUpdate;
      try
        Self.FAlphaBlend := AlphaBlend;
        Self.Color := Color;
        Self.FEndColor := EndColor;
        Self.Font := Font;
        Self.FGradient := Gradient;
        Self.ImageIndex := ImageIndex;
      finally
        Self.EndUpdate;
      end;
    end;
  end else
    inherited Assign(Source);
end;

procedure TSCListGroupStyle.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TSCListGroupStyle.Changed(Sender: TObject);
var
  I: Integer;
  N: TSCListGroupStyleNotifier;
  L: TList;
begin
  if FUpdateCount > 0 then
  begin
    FChanged := True;
    Exit;
  end;

  FChanged := False;

  if FNotifications.Count > 0 then
  begin
    L := TList.Create;
    try
      if Sender <> Self then
        Sender := Self;

      for I := 0 to FNotifications.Count-1 do
        if L.IndexOf(FNotifications[I]) = -1 then
          L.Add(FNotifications[I]);

      for I := 0 to L.Count-1 do
      begin
        N := TSCListGroupStyleNotifier(L[I]);
        if Assigned(N) and Assigned(N.FOnChange) then
          N.FOnChange(Sender);
      end;
    finally
      L.Free;
    end;
  end;
end;

constructor TSCListGroupStyle.Create(AOwner: TComponent);
begin
  FImageIndex := -1;
  FLargeImageIndex := -1;

  inherited Create(AOwner);
  FNotifications := TList.Create;

  FAlphaBlend := 255;
  FColor := clNone;
  FEndColor := clNone;
  FGradient := scgLeftToRight;

  FExStyle := TSCListGroupStyleEx.Create(Self);

  FFont := TFont.Create;
  FImageChangeLink := TChangeLink.Create;
  FLargeImageChangeLink := TChangeLink.Create;

  FFont.OnChange := Changed;
  FImageChangeLink.OnChange := Changed;
  FLargeImageChangeLink.OnChange := Changed;
end;

destructor TSCListGroupStyle.Destroy;
begin
  Destroying;
  FNotifications.Clear;

  FFont.OnChange := nil;
  FImageChangeLink.OnChange := nil;
  FLargeImageChangeLink.OnChange := nil;

  FreeAndNil(FExStyle);
  FreeAndNil(FFont);
  FreeAndNil(FImageChangeLink);
  FreeAndNil(FLargeImageChangeLink);
  FreeAndNil(FNotifications);
  inherited Destroy;
end;

procedure TSCListGroupStyle.Destroying;
var
  I: Integer;
  N: TSCListGroupStyleNotifier;
  L: TList;
begin
  if FNotifications.Count > 0 then
  begin
    L := TList.Create;
    try
      for I := 0 to FNotifications.Count-1 do
        if L.IndexOf(FNotifications[I]) = -1 then
          L.Add(FNotifications[I]);

      for I := L.Count-1 downto 0 do
      begin
        N := TSCListGroupStyleNotifier(L[I]);
        L.Delete(I);

        if Assigned(N) and Assigned(N.FOnDestroy) then
          N.FOnDestroy(Self);
      end;
    finally
      L.Free;
    end;
  end;
end;

procedure TSCListGroupStyle.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FChanged and (FUpdateCount = 0) then
      Changed(Self);
  end;
end;

function TSCListGroupStyle.IsValidImage(Index: Integer): Boolean;
begin
  Result := (FImages <> nil) and
    (Index > -1) and (Index < FImages.Count);
end;

procedure TSCListGroupStyle.RegisterNotifier(N: TSCListGroupStyleNotifier);
begin
  if Assigned(N) then
    FNotifications.Add(N);
end;

procedure TSCListGroupStyle.SetAlphaBlend(Value: TSCAlphaBlend);
begin
  if FAlphaBlend <> Value then
  begin
    FAlphaBlend := Value;
    Changed(Self);
  end;
end;

procedure TSCListGroupStyle.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed(Self);
  end;
end;

procedure TSCListGroupStyle.SetEndColor(Value: TColor);
begin
  if FEndColor <> Value then
  begin
    FEndColor := Value;
    Changed(Self);
  end;
end;

procedure TSCListGroupStyle.SetExStyle(Value: TSCListGroupStyleEx);
begin
  FExStyle.Assign(Value);
end;

procedure TSCListGroupStyle.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TSCListGroupStyle.SetGradient(Value: TSCGradient);
begin
  if FGradient <> Value then
  begin
    FGradient := Value;
    Changed(Self);
  end;
end;

procedure TSCListGroupStyle.SetImageIndex(Value: TImageIndex);
begin
  if Value < -1 then Value := -1;

  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed(Self);
  end;
end;

procedure TSCListGroupStyle.SetImages(Value: TCustomImageList);
var
  OldImages: TCustomImageList;
begin
  OldImages := FImages;

  if FImages <> nil then
    FImages.UnRegisterChanges(FImageChangeLink);

  FImages := Value;
  if FImages <> nil then
  begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(Self);
  end;

  if OldImages <> FImages then
    Changed(Self);
end;

procedure TSCListGroupStyle.SetLargeImageIndex(Value: TImageIndex);
begin
  if Value < -1 then Value := -1;

  if FLargeImageIndex <> Value then
  begin
    FLargeImageIndex := Value;
    Changed(Self);
  end;
end;

procedure TSCListGroupStyle.SetLargeImages(Value: TCustomImageList);
var
  OldImages: TCustomImageList;
begin
  OldImages := FLargeImages;

  if FLargeImages <> nil then
    FLargeImages.UnRegisterChanges(FLargeImageChangeLink);

  FLargeImages := Value;
  if FLargeImages <> nil then
  begin
    FLargeImages.RegisterChanges(FLargeImageChangeLink);
    FLargeImages.FreeNotification(Self);
  end;

  if OldImages <> FLargeImages then
    Changed(Self);
end;

procedure TSCListGroupStyle.UnregisterNotifier(N: TSCListGroupStyleNotifier);
begin
  if Assigned(N) then
    FNotifications.Remove(N);
end;

{ TSCListGroup }

procedure TSCListGroup.AdjustBounds;
begin
  AdjustSize;
end;

procedure TSCListGroup.AdjustItemRect(var R: TRect);
begin
  InflateRect(R, -2, -4);
end;

procedure TSCListGroup.AdjustSize;
begin
  if AutoSize and CanAdjustSize then
    UpdateHeight
  else
    UpdateScrollers;
end;

function TSCListGroup.CanAdjustSize: Boolean;
begin
  Result := True;
  if (Parent <> nil) and (Parent is TSCGroupContainer) then
    Result := not TSCGroupContainer(Parent).IsOutlookStyle;
end;

function TSCListGroup.CanScroll(AsUp: Boolean): Boolean;
begin
  Result := Enabled and (FItems <> nil) and (FItems.Count > 0) and
    ((AsUp and (FTopItem > 0)) or (not AsUp and (FTopItem < FItems.Count-1)));
end;

procedure TSCListGroup.CaptureChanged(Captured: Boolean);
var
  NeedPaint: Boolean;
begin
  NeedPaint := (FHotItem <> -1) or
    ((FClickedItem <> -1) and (FHotClickItem <> -1));

  FHotItem := -1;
  FHotClickItem := -1;

  inherited CaptureChanged(Captured);

  if NeedPaint then
    Invalidate;
end;

procedure TSCListGroup.CMMouseEnter(var Message: TMessage);
var
  P: TPoint;
  I: Integer;
  HotChanged: Boolean;
begin
  if not IsDesigning then
  begin
    I := -1;

    GetCursorPos(P);
    if FindDragTarget(P, True) = Self then
    begin
      P := ScreenToClient(P);
      I := GetItemAtPos(P, True);
    end;

    if FClickedItem <> -1 then
      HotChanged := I <> FHotClickItem
    else
      HotChanged := I <> FHotItem;

    inherited;

    if FClickedItem <> -1 then
    begin
      FHotItem := -1;
      FHotClickItem := I;
    end else
    begin
      FHotItem := I;
      FHotClickItem := -1;
    end;

    if HotChanged then
      Invalidate;
  end else
    inherited;  
end;

procedure TSCListGroup.CMMouseLeave(var Message: TMessage);
var
  IsHot: Boolean;
begin
  if not IsDesigning then
  begin
    IsHot := (FHotItem <> -1) or (FHotClickItem <> -1);

    inherited;

    FHotItem := -1;
    FHotClickItem := -1;

    if IsHot then
      Invalidate;
  end else
    inherited;  
end;

constructor TSCListGroup.Create(AOwner: TComponent);
begin
  FHotItem := -1;
  FClickedItem  := -1;
  FHotClickItem := -1;
  FFocusedItem  := -1;

  FTopItem := 0;

  FHotButton := scsbNone;
  FClickedButton := scsbNone;

  FScrolling   := False;
  FScrollTimer := -1;

  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls];
  DoubleBuffered := True;

  FButtonStyle := scbsButtonSp;
  FCanSelect := True;
  FHottrackCursor := crHandPoint;
  FItemSpace := 8;
  FShowFocusRect := True;
  FShowImages := True;
  FWordWrap := False;

  FLargeImageChangeLink := TChangeLink.Create;
  FSmallImageChangeLink := TChangeLink.Create;
  FScrollerImageChangeLink := TChangeLink.Create;

  FLargeImageChangeLink.OnChange := LargeImagesChanged;
  FSmallImageChangeLink.OnChange := SmallImagesChanged;
  FScrollerImageChangeLink.OnChange := ScrollerImagesChanged;

  FImageStyle := scisSmall;
  FItems := TSCListGroupItems.Create(Self);
  FScrollers := TSCListGroupScrollers.Create(Self);
end;

destructor TSCListGroup.Destroy;
begin
  StopScrolling;
  
  FLargeImageChangeLink.OnChange := nil;
  FSmallImageChangeLink.OnChange := nil;
  FScrollerImageChangeLink.OnChange := nil;

  FreeAndNil(FItems);
  FreeAndNil(FLargeImageChangeLink);
  FreeAndNil(FSmallImageChangeLink);
  FreeAndNil(FScrollerImageChangeLink);
  FreeAndNil(FScrollers);
  inherited Destroy;
end;

procedure TSCListGroup.DoDrawItem(Index: Integer; var R: TRect; Calculate: Boolean);
var
  F: TFont;
  S: TSCListGroupStyle;
  R2, TxR, BtnR: TRect;
  BvSz, TxH,
  H, T, L, IH,
  IW, ImgIndx: Integer;
  G: TSCGradient;
  Cl, ClEnd, C1, C2: TColor;
  AItem: TSCListGroupItem;
  ImgList: TCustomImageList;
  ImgStyle: TSCListImageStyle;
begin
  R.Bottom := R.Top;
  InflateRect(R, -Indent, 0);

  if (R.Left >= R.Right) or
    not IsValidItem(Index) then Exit;

  AItem := FItems.Items[Index];
  if not AItem.Visible then Exit;

  if (AItem.Indent > 0) and CanIndent(Index) then
  begin
    Inc(R.Left, AItem.Indent);
    if R.Left >= R.Right then
      Exit;
  end;  

  ImgStyle := GetImageStyle(Index);

  BvSz := GetBevelSize;
  InflateRect(R, -BvSz, 0);
  Inc(R.Top, BvSz);

  G := scgNone;
  ClEnd := clNone;

  try
    S := GetItemStyle(Index);

    F := Self.Font;
    if S <> nil then F := S.Font;

    H := 0;
    IH := 0; IW := 0;

    ImgIndx := -1;
    ImgList := GetImageList(Index);

    if ImgList <> nil then
    begin
      ImgIndx := GetImageIndex(Index);

      if (ImgIndx > -1) and (ImgIndx < ImgList.Count) then
      begin
        IW := ImgList.Width;
        IH := ImgList.Height;

        if ImgStyle = scisSmall then
        begin
          Inc(IW, Spacing);

          if (AItem.ViewStyle = scvsButton) and
            (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew]) then
            Inc(IW, BvSz);
        end else
        begin
          Inc(IH, Spacing);

          if (AItem.ViewStyle = scvsButton) and
            (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew]) then
            Inc(IH, BvSz);
        end;

        Inc(H, IH);
      end;
    end;


    TxR := R;
    if (IW > 0) and (ImgStyle = scisSmall) then
    begin
      Inc(TxR.Left, IW);

      if TxR.Right < TxR.Left then
        TxR.Right := TxR.Left;
    end;

    DoDrawItemText(Canvas, AItem.Caption, F, TxR, True, Index);

    OffsetRect(TxR, 0, -TxR.Top);
    if TxR.Bottom < TxR.Top then
      TxR.Bottom := TxR.Top;

    TxH := TxR.Bottom - TxR.Top;

    if ImgStyle = scisLarge then
      Inc(H, TxH + 2)
    else
    if H < TxR.Bottom - TxR.Top then
      H := TxH;

    if S <> nil then
    begin
      G := S.Gradient;
      if G <> scgNone then
        ClEnd := S.EndColor;

      Cl := S.Color;
      if not (Self.Enabled and AItem.Enabled) then
        Cl := S.ExStyle.DisabledColor
      else
      if (Index = FHotItem) and S.ExStyle.FHottrack then
        Cl := S.ExStyle.HotColor;

      if Cl = clNone then
        Cl := S.Color;
    end else
    begin
      Cl := AItem.Color;
      if not (Self.Enabled and AItem.Enabled) then
        Cl := AItem.ExStyle.DisabledColor
      else
      if (Index = FHotItem) and AItem.ExStyle.FHottrack then
        Cl := AItem.ExStyle.HotColor;

      if Cl = clNone then
        Cl := AItem.Color;
    end;

    if (Cl <> clNone) or
      ((G <> scgNone) and not ((Cl = clNone) and (ClEnd = clNone))) then
    begin
      if ClEnd = clNone then
        ClEnd := Self.Color;

      if Cl = clNone then
        Cl := Self.Color;

      BtnR := R;
      BtnR.Bottom := BtnR.Top + H;

      Dec(BtnR.Top, BvSz);
      InflateRect(BtnR, BvSz, BvSz);

      if G <> scgNone then
        scDrawGradient(Canvas, BtnR, G, Cl, ClEnd)
      else begin
        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := Cl;

          FillRect(BtnR);
        end;
      end;
    end;

    if Cl = clNone then
      Cl := Self.Color;

    if not Calculate and (H > 0) and
      (AItem.ViewStyle = scvsButton) and IsHotItem(Index) then
    begin
      if FButtonStyle = scbsButtonEx then
      begin
        BtnR := R;
        BtnR.Bottom := BtnR.Top + H;

        Dec(BtnR.Top, BvSz);
        InflateRect(BtnR, BvSz, BvSz);

        if FClickedItem = Index then
          Cl := GetOfficeXPDownedSelColor
        else
          Cl := GetOfficeXPSelColor;

        with Canvas do
        begin
          Brush.Color := Cl;
          FillRect(BtnR);
        end;
      end else
      if (ImgList <> nil) and
        (ImgIndx > -1) and (IW > 0) and (IH > 0) and
        (FButtonStyle = scbsImageEx) then
      begin
        T := R.Top;
        L := R.Left;

        if ImgStyle = scisSmall then
        begin
          if not FWordWrap then
            T := R.Top + ((H - IH) div 2);
        end else
          L := R.Left + ((R.Right - R.Left - IW) div 2);

        BtnR.Left := L;
        BtnR.Top  := T;
        BtnR.Right  := L + IW;
        BtnR.Bottom := T + IH;

        InflateRect(BtnR, BvSz, BvSz);

        if ImgStyle = scisSmall then
        begin
          Dec(BtnR.Right, Spacing);

          if (AItem.ViewStyle = scvsButton) and
            (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew]) then
            Dec(BtnR.Right, BvSz);
        end else
        begin
          Dec(BtnR.Bottom, Spacing);

          if (AItem.ViewStyle = scvsButton) and
            (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew]) then
            Dec(BtnR.Bottom, BvSz);
        end;

        if FClickedItem = Index then
          Cl := GetOfficeXPDownedSelColor
        else
          Cl := GetOfficeXPSelColor;

        with Canvas do
        begin
          Brush.Color := Cl;
          FillRect(BtnR);
        end;
      end;
    end;

    BtnR := R;

    Dec(BtnR.Top,  BvSz);
    Dec(BtnR.Left, BvSz);

    BtnR.Right := BtnR.Left;
    BtnR.Bottom := BtnR.Top;

    if (ImgList <> nil) and (ImgIndx > -1) then
    begin
      T := R.Top;
      L := R.Left;

      if ImgStyle = scisSmall then
      begin
        if not FWordWrap then
          T := R.Top + ((H - IH) div 2);
      end else
        L := R.Left + ((R.Right - R.Left - IW) div 2);

      if not Calculate then
      begin
        if (ImgIndx > -1) and (ImgIndx < ImgList.Count) then
          ImgList.Draw(Canvas, L, T, ImgIndx, True);

        if (IW > 0) and (IH > 0) and
          (AItem.ViewStyle = scvsButton) and
          (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew]) then
        begin
          BtnR.Left   := L;
          BtnR.Top    := T;

          BtnR.Right  := BtnR.Left + IW;
          BtnR.Bottom := BtnR.Top +  IH;

          InflateRect(BtnR, BvSz, BvSz);

          if ImgStyle = scisSmall then
          begin
            Dec(BtnR.Right, Spacing);

            if (AItem.ViewStyle = scvsButton) and
              (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew]) then
              Dec(BtnR.Right, BvSz);
          end else
          begin
            Dec(BtnR.Bottom, Spacing);

            if (AItem.ViewStyle = scvsButton) and
              (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew]) then
              Dec(BtnR.Bottom, BvSz);
          end;
        end;
      end;  
    end;

    TxR := R;
    TxR.Bottom := TxR.Top + TxH;

    if ImgStyle = scisSmall then
      Inc(TxR.Left, IW)
    else
      OffsetRect(TxR, 0, IH);

    if not (Calculate or IsRectEmpty(TxR)) then
      DoDrawItemText(Canvas, AItem.Caption, F, TxR, False, Index);

    R.Bottom := R.Top + H;

    with AItem do
      if (FLine <> scglNone) and
        (FLineColor <> clNone) and (ViewStyle = scvsLabel) then
      begin
        Inc(R.Bottom, 2);

        if not Calculate then
        begin
          R2 := R;
          
          InflateRect(R2, BvSz, 0);
          Inc(R2.Bottom, BvSz - 2);
          R2.Top := R2.Bottom - 2;

          with Canvas do
          begin
            Pen.Style := psSolid;
            Pen.Mode  := pmCopy;
            Pen.Width := 1;
            Pen.Color := FLineColor;
          end;  

          case FLine of
            scglFlatLine:
            begin
              with Canvas do
              begin
                MoveTo(R2.Left,  R2.Bottom);
                LineTo(R2.Right, R2.Bottom);
              end;
            end;
            scglLoweredLine:
              scFrame3D(Canvas, R2, clBtnShadow, clBtnHighlight, 1, 0);
            scglRaisedLine:
              scFrame3D(Canvas, R2, clBtnHighlight, clBtnShadow, 1, 0);
          end;
        end;
      end;

    if not Calculate and IsHotItem(Index) and
      (AItem.ViewStyle = scvsButton) and (FButtonStyle <> scbsNone) then
    begin
      if FButtonStyle in [scbsButton2k,
        scbsButtonSp, scbsButtonEx, scbsButtonNew] then
      begin
        BtnR := R;

        Dec(BtnR.Top, BvSz);
        InflateRect(BtnR, BvSz, BvSz);
      end;

      if not IsRectEmpty(BtnR) then
      begin
        if FButtonStyle in [scbsButtonNew, scbsImageNew] then
        begin
          C1 := BlendedColor(Cl, 16, 16, 16, False);
          C2 := BlendedColor(Cl, 48, 48, 48, True);

          scFrame3D(Canvas, BtnR, C1, C2, 1, 0);

          C1 := BlendedColor(Cl, 144, 144, 144, False);
          C2 := BlendedColor(C1, 16, 16, 16, True);

          scFrame3D(Canvas, BtnR, C1, C2, 1, 0);

          if AItem.FSelected then
          begin
            C1 := BlendedColor(Cl, 44, 44, 44, False);
            C2 := BlendedColor(Cl, 16, 16, 16, True);

            scFrame3D(Canvas, BtnR, C1, C2, 1, 0);

            InflateRect(BtnR, 1, 0);
            C1 := BlendedColor(C1, 4, 4, 4, True);
            C2 := BlendedColor(C2, 12, 12, 12, True);

            scFrame3D(Canvas, BtnR, C1, C2, 1, 0);
          end else
          if FClickedItem <> Index then
          begin
            C1 := BlendedColor(Cl, 16, 16, 16, True);
            C2 := BlendedColor(Cl, 44, 44, 44, False);

            scFrame3D(Canvas, BtnR, C1, C2, 1, 0);

            InflateRect(BtnR, 1, 0);
            C1 := BlendedColor(C1, 12, 12, 12, True);
            C2 := BlendedColor(C2, 4, 4, 4, False);

            scFrame3D(Canvas, BtnR, C1, C2, 1, 0);
          end;
        end else
        if FButtonStyle in [scbsButton2k, scbsImage2k] then
        begin
          if AItem.FSelected then
            scFrame3D(Canvas, BtnR, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0)
          else
          if FClickedItem = Index then
          begin
            scFrame3D(Canvas, BtnR, Get3DDkShadowOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
            scFrame3D(Canvas, BtnR, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
          end else
          begin
            scFrame3D(Canvas, BtnR, GetBtnHighlightOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
            scFrame3D(Canvas, BtnR, Cl, GetBtnShadowOf(Cl), 1, 0);
          end;
        end else
        if FButtonStyle in [scbsButtonSp, scbsImageSp] then
        begin
          if (FClickedItem = Index) or AItem.FSelected then
            scDrawBevel(Canvas, BtnR, Cl, clNone, False, sccbLowered)
          else
            scDrawBevel(Canvas, BtnR, Cl, clNone, False, sccbRaised);
        end else
          scDrawEdge(Canvas, BtnR, clHighlight, clNone, False, sccbFlat);
      end;
    end;

    if not Calculate and FShowFocusRect and
      (H > 0) and (FFocusedItem = Index) and
      not IsRectEmpty(TxR) and CanDrawFocusRect then
    begin
      InflateRect(TxR, 2, 2);

      with Canvas do
      begin
        Brush.Style := bsClear;
        Brush.Color := Cl;

        scDrawFocusRect(Canvas, TxR, Cl);
      end;
      InflateRect(TxR, -2, -2);
    end;
  finally
    Dec(R.Top, BvSz);
    InflateRect(R, BvSz, BvSz);
  end;
end;

procedure TSCListGroup.DoDrawItems;
var
  I: Integer;
  R, R2, CR: TRect;
  AItem: TSCListGroupItem;
begin
  if (FItems = nil) or (FItems.Count = 0) or
    (IsLoading or IsDestroying) then
    Exit;

  CR := ClientRect;
  if IsRectEmpty(CR) then Exit;

  AdjustClientRect(CR);
  AdjustItemRect(CR);

  if IsRectEmpty(CR) then Exit;

  R := CR;

  OffsetRect(R, 0, GetBevelSize);
  R.Bottom := R.Top;

  ValidateTopItemIndex(FTopItem);

  for I := FTopItem to FItems.Count-1 do
  begin
    AItem := FItems.Items[I];
    if not AItem.Visible then Continue;

    R2 := R;
    DoDrawItem(I, R2);

    if R2.Bottom > R2.Top then
    begin
      OffsetRect(R, 0, R2.Bottom - R2.Top + FItemSpace);
      if R.Top >= CR.Bottom then
        Exit;
    end;
  end;
end;

procedure TSCListGroup.DoDrawItemText(Cnv: TCanvas; Text: String;
  F: TFont; var R: TRect; CalcRect: Boolean; Index: Integer);
var
  C1, C2: TColor;
  Flags: Integer;
  IsHot: Boolean;
  S: TSCListGroupStyle;
begin
  if Cnv = nil then Cnv := Canvas;

  if (Cnv = nil) or not CanGetClientRect or
    (not CalcRect and IsRectEmpty(R)) then Exit;

  if CalcRect and ((Text = '') or ((Length(Text) > 1) and
    (Text[1] = '&') and (Text[2] = #0))) then
    Text := Text + ' ';

  with Cnv do
  begin
    Brush.Style := bsClear;

    if F <> nil then
    begin
      Font := F;

      if IsValidItem(Index) then
      begin
        C1 := F.Color;
        C2 := clNone;

        S := GetItemStyle(Index);

        IsHot := (FHotItem = Index) or
          ((FClickedItem > -1) and (FClickedItem = Index) and
           (FClickedItem = FHotClickItem));

        IsHot := IsHot and
          (((S <> nil) and S.ExStyle.FHottrack) or
           ((S = nil) and FItems[Index].ExStyle.FHottrack));

        with FItems[Index] do
        begin
          if not (Self.Enabled and FItems[Index].Enabled) then
          begin
            C2 := ExStyle.DisabledFontColor;
            if S <> nil then
              C2 := S.ExStyle.DisabledFontColor;
          end else
          if IsHot then
          begin
            C2 := ExStyle.HotFontColor;
            if S <> nil then
            begin
              C2 := S.ExStyle.HotFontColor;
              
              if S.ExStyle.HotUnderline then
                Font.Style := Font.Style + [fsUnderline];
            end else
            if ExStyle.HotUnderline then
              Font.Style := Font.Style + [fsUnderline];
          end;
        end;

        if C2 <> clNone then
          C1 := C2;
        Font.Color := C1;
      end;
    end;
  end;

  Flags := GetItemTextFlags(CalcRect, Index);
  DrawText(Cnv.Handle, PChar(Text), Length(Text), R, Flags);
end;

procedure TSCListGroup.DoDrawScrollers;

  procedure DrawUpScroller(R: TRect);
  var
    X, Y,
    OfX, OfY, W, H, Img: Integer;
    Cl_1, Cl_2, C1, C2: TColor;
    IsClicked, IsEnabled, IsHot: Boolean;
  begin
    IsHot := (FClickedButton = scsbNone) and (FHotButton = scsbUp);
    IsEnabled := FScrollers.UpScroller.Enabled;
    IsClicked := (FClickedButton = scsbUp) and (FHotButton = scsbUp);

    W := 16; H := 16;

    Img := -1;
    if FScrollerImages <> nil then
      with FScrollerImages, FScrollers.UpScroller do
      begin
        Img := ImageDefault;
        if not IsEnabled then
          Img := ImageDisabled
        else
        if IsClicked then
          Img := ImagePressed
        else
        if IsHot then
          Img := ImageHot;

        if (Img < 0) or
          (Img > FScrollerImages.Count - 1) then
          Img := -1;

        if Img > -1 then
        begin
          W := Width;
          H := Height;
        end;
      end;

    if (W = 0) or (H = 0) then Exit;

    X := R.Right - W;
    Y := R.Top;

    if (X < R.Left) or (Y + H > R.Bottom) then Exit;

    with FScrollers.UpScroller do
    begin
      Cl_1 := ColorDefault;
      Cl_2 := ArrowDefault;

      if not FEnabled then
      begin
        Cl_1 := ColorDisabled;
        Cl_2 := ArrowDisabled;
      end else
      if IsClicked then
      begin
        Cl_1 := ColorPressed;
        Cl_2 := ArrowPressed;
      end else
      if IsHot then
      begin
        Cl_1 := ColorHot;
        Cl_2 := ArrowHot;
      end;
    end;

    if FButtonStyle in [scbsButtonEx, scbsImageEx] then
    begin
      Cl_1 := GetOfficeXPBtnColor;
      Cl_2 := clBtnText;

      if not FScrollers.UpScroller.FEnabled then
        Cl_2 := clBtnShadow
      else
      if IsClicked then
      begin
        Cl_1 := GetOfficeXPDownedSelColor;
        Cl_2 := clBtnHighlight;
      end else
      if IsHot then
      begin
        Cl_1 := GetOfficeXPSelColor;
        Cl_2 := clBtnText;
      end;
    end;

    R.Left := X;
    R.Top := Y;
    R.Right := R.Left + W;
    R.Bottom := Y + H;

    if Img = -1 then
    begin
      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl_1;

        FillRect(R);
      end;

      OfX := 0; OfY := 0;
      if IsEnabled and IsClicked and
        not (FButtonStyle in [scbsButtonEx, scbsImageEx]) then
      begin
        OfX := 1;
        OfY := 1;
      end;

      scDrawDownSlider(Canvas, Point(X + 8 + OfX, Y + 6 + OfY), 6, 3, sctsMac, False, Cl_2, Cl_2);

      if FButtonStyle in [scbsButtonNew, scbsImageNew] then
      begin
        C1 := BlendedColor(Cl_1, 144, 144, 144, False);
        C2 := BlendedColor(C1, 16, 16, 16, False);

        scFrame3D(Canvas, R, C1, C2, 1, 0);

        if IsEnabled and IsClicked then
        begin
          C1 := BlendedColor(Cl_1, 44, 44, 44, False);
          C2 := BlendedColor(Cl_1, 16, 16, 16, True);

          scFrame3D(Canvas, R, C1, C2, 1, 0);
        end else
        begin
          C1 := BlendedColor(Cl_1, 16, 16, 16, True);
          C2 := BlendedColor(Cl_1, 44, 44, 44, False);

          scFrame3D(Canvas, R, C1, C2, 1, 0);
        end;
      end else
      if FButtonStyle in [scbsButtonEx, scbsImageEx] then
      begin
        if IsEnabled and (IsHot or IsClicked) then
          scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
      end else
      if IsEnabled and IsClicked then
        scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0)
      else begin
        scFrame3D(Canvas, R, clBtnHighlight, cl3DDkShadow, 1, 0);
        if IsEnabled and IsHot then
          scFrame3D(Canvas, R, clBtnFace, clBtnShadow, 1, 0);
      end;
    end else
    if FScrollerImages <> nil then
      FScrollerImages.Draw(Canvas, X, Y, Img, True);
  end;

  procedure DrawDownScroller(R: TRect);
  var
    X, Y,
    OfX, OfY, W, H, Img: Integer;
    Cl_1, Cl_2, C1, C2: TColor;
    IsClicked, IsEnabled, IsHot: Boolean;
  begin
    IsHot := (FClickedButton = scsbNone) and (FHotButton = scsbDown);
    IsEnabled := FScrollers.DownScroller.Enabled;
    IsClicked := (FClickedButton = scsbDown) and (FHotButton = scsbDown);

    W := 16; H := 16;

    Img := -1;
    if FScrollerImages <> nil then
      with FScrollerImages, FScrollers.DownScroller do
      begin
        Img := ImageDefault;
        if not IsEnabled then
          Img := ImageDisabled
        else  
        if IsClicked then
          Img := ImagePressed
        else
        if IsHot then
          Img := ImageHot;

        if (Img < 0) or
          (Img > FScrollerImages.Count - 1) then
          Img := -1;

        if Img > -1 then
        begin
          W := Width;
          H := Height;
        end;
      end;

    if (W = 0) or (H = 0) then Exit;

    X := R.Right - W;
    Y := R.Bottom - H;

    if (X < R.Left) or (Y < R.Top) then Exit;

    with FScrollers.DownScroller do
    begin
      Cl_1 := ColorDefault;
      Cl_2 := ArrowDefault;

      if not FEnabled then
      begin
        Cl_1 := ColorDisabled;
        Cl_2 := ArrowDisabled;
      end else
      if IsClicked then
      begin
        Cl_1 := ColorPressed;
        Cl_2 := ArrowPressed;
      end else
      if IsHot then
      begin
        Cl_1 := ColorHot;
        Cl_2 := ArrowHot;
      end;
    end;

    if FButtonStyle in [scbsButtonEx, scbsImageEx] then
    begin
      Cl_1 := GetOfficeXPBtnColor;
      Cl_2 := clBtnText;

      if not FScrollers.DownScroller.FEnabled then
        Cl_2 := clBtnShadow
      else
      if IsHot then
      begin
        Cl_1 := GetOfficeXPSelColor;
        Cl_2 := clBtnText;
      end else
      if IsClicked then
      begin
        Cl_1 := GetOfficeXPDownedSelColor;
        Cl_2 := clBtnHighlight;
      end;
    end;

    R.Left := X;
    R.Top := Y;
    R.Right := R.Left + W;
    R.Bottom := Y + H;

    if Img = -1 then
    begin
      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl_1;

        FillRect(R);
      end;

      OfX := 0; OfY := 0;
      if IsEnabled and IsClicked and
        not (FButtonStyle in [scbsButtonEx, scbsImageEx]) then
      begin
        OfX := 1;
        OfY := 1;
      end;

      scDrawUpSlider(Canvas, Point(X + 8 + OfX, Y + 9 + OfY), 6, 3, sctsMac, False, Cl_2, Cl_2);

      if FButtonStyle in [scbsButtonNew, scbsImageNew] then
      begin
        C1 := BlendedColor(Cl_1, 144, 144, 144, False);
        C2 := BlendedColor(C1, 16, 16, 16, False);

        scFrame3D(Canvas, R, C1, C2, 1, 0);

        if IsEnabled and IsClicked then
        begin
          C1 := BlendedColor(Cl_1, 44, 44, 44, False);
          C2 := BlendedColor(Cl_1, 16, 16, 16, True);

          scFrame3D(Canvas, R, C1, C2, 1, 0);
        end else
        begin
          C1 := BlendedColor(Cl_1, 16, 16, 16, True);
          C2 := BlendedColor(Cl_1, 44, 44, 44, False);

          scFrame3D(Canvas, R, C1, C2, 1, 0);
        end;
      end else
      if FButtonStyle in [scbsButtonEx, scbsImageEx] then
      begin
        if IsEnabled and (IsClicked or IsHot) then
          scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
      end else
      if IsEnabled and IsClicked then
        scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0)
      else begin
        scFrame3D(Canvas, R, clBtnHighlight, cl3DDkShadow, 1, 0);
        if IsEnabled and IsHot then
          scFrame3D(Canvas, R, clBtnFace, clBtnShadow, 1, 0);
      end;
    end else
    if FScrollerImages <> nil then
      FScrollerImages.Draw(Canvas, X, Y, Img, True);
  end;

var
  R, CR: TRect;
begin
  if (IsLoading or IsDestroying) or (FItems = nil) or
    (FItems.Count = 0) or (FScrollers = nil) or not FScrollers.Visible then
    Exit;

  CR := ClientRect;
  if IsRectEmpty(CR) then Exit;

  AdjustClientRect(CR);
  AdjustItemRect(CR);

  if IsRectEmpty(CR) then Exit;

  R := CR;
  InflateRect(R, - 4, -4);

  if IsRectEmpty(R) then Exit;

  DrawUpScroller(R);
  DrawDownScroller(R);
end;

procedure TSCListGroup.DoItemClick(AItem: Integer);
var
  ClickedItem: TSCListGroupItem;
begin
  if (AItem > -1) and (AItem < FItems.Count) then
  begin
    ClickedItem := FItems[AItem];

    if Assigned(ClickedItem.OnClick) then
    begin
      if ClickedItem.Enabled then
        ClickedItem.OnClick(ClickedItem);
    end else
    if Assigned(FOnItemClick) then
      FOnItemClick(Self, AItem);
  end;
end;

procedure TSCListGroup.DoItemDblClick(AItem: Integer);
var
  ClickedItem: TSCListGroupItem;
begin
  if (AItem > -1) and (AItem < FItems.Count) then
  begin
    ClickedItem := FItems[AItem];

    if Assigned(ClickedItem.OnDblClick) then
    begin
      if ClickedItem.Enabled then
        ClickedItem.OnDblClick(ClickedItem);
    end else
    if Assigned(FOnItemDblClick) then
      FOnItemDblClick(Self, AItem);
  end;
end;

procedure TSCListGroup.DoItemHottrack(AItem: Integer);
var
  HotItem: TSCListGroupItem;
begin
  if (AItem > -1) and (AItem < FItems.Count) then
  begin
    HotItem := FItems[AItem];

    if Assigned(HotItem.OnHottrack) then
    begin
      if HotItem.Enabled then
        HotItem.OnHottrack(HotItem);
    end else
    if Assigned(FOnItemHottrack) then
      FOnItemHottrack(Self, AItem);
  end;
end;

procedure TSCListGroup.DoItemMouseDown(AItem: Integer);
var
  DownItem: TSCListGroupItem;
begin
  if (AItem > -1) and (AItem < FItems.Count) then
  begin
    DownItem := FItems[AItem];

    if Assigned(DownItem.OnMouseDown) then
    begin
      if DownItem.Enabled then
        DownItem.OnMouseDown(DownItem);
    end else
    if Assigned(FOnItemMouseDown) then
      FOnItemMouseDown(Self, AItem);
  end;
end;

procedure TSCListGroup.DoItemMouseUp(AItem: Integer);
var
  UpItem: TSCListGroupItem;
begin
  if (AItem > -1) and (AItem < FItems.Count) then
  begin
    UpItem := FItems[AItem];

    if Assigned(UpItem.OnMouseUp) then
    begin
      if UpItem.Enabled then
        UpItem.OnMouseUp(UpItem);
    end else
    if Assigned(FOnItemMouseUp) then
      FOnItemMouseUp(Self, AItem);
  end;
end;

procedure TSCListGroup.DoItemSelect(AItem: Integer);
var
  SelectedItem: TSCListGroupItem;
begin
  if (AItem > -1) and (AItem < FItems.Count) then
  begin
    SelectedItem := FItems[AItem];

    if Assigned(SelectedItem.OnSelect) then
    begin
      if SelectedItem.Enabled then
        SelectedItem.OnSelect(SelectedItem);
    end else
    if Assigned(FOnItemSelect) then
      FOnItemSelect(Self, AItem);
  end;
end;

function TSCListGroup.GetBevelSize: TImageIndex;
begin
  Result := 4;
end;

function TSCListGroup.GetCurrentCursor: TCursor;
var
  Index: Integer;
  S: TSCListGroupStyle;
  IsHot: Boolean;
begin
  Result := inherited GetCurrentCursor;

  Index := FHotItem;
  if not IsValidItem(Index) and
    IsValidItem(FClickedItem) and (FClickedItem = FHotItem) then
    Index := FClickedItem;

  if IsValidItem(Index) and FItems[Index].Enabled then
  begin
    S := GetItemStyle(Index);
    IsHot := ((S <> nil) and S.ExStyle.FHottrack) or
      ((S = nil) and FItems[Index].ExStyle.FHottrack);

    if IsHot then
      Result := FHottrackCursor;
  end;
end;

function TSCListGroup.GetFullHeight: Integer;
var
  R: TRect;
  I, W,
  H: Integer;
  AItem: TSCListGroupItem;
begin
  Result := Height;
  if (FItems = nil) or not HandleAllocated or IsLoading then
    Exit;

  R := GetClientRect;
  if R.Bottom < 100 then
    R.Bottom := 100;

  AdjustClientRect(R);
  H := R.Bottom - R.Top;

  AdjustItemRect(R);

  Result := H - (R.Bottom - R.Top);
  if Result < 0 then Result := 0;

  W := R.Right - R.Left;
  if W <= 0 then Exit;

  Result := Result + GetCollapsedHeight;
  for I := 0 to FItems.Count - 1 do
  begin
    AItem := FItems.Items[I];
    if not AItem.Visible then Continue;

    H := GetItemHeight(I, W);
    if H > 0 then
      Inc(Result, H + FItemSpace);
  end;
end;

function TSCListGroup.GetImageIndex(Index: Integer): TImageIndex;
var
  S: TSCListGroupStyle;
  AItem: TSCListGroupItem;
  ImgStyle: TSCListImageStyle;
begin
  Result := -1;
  if FShowImages and IsValidItem(Index) then
  begin
    AItem := FItems.Items[Index];
    ImgStyle := GetImageStyle(Index);

    if ImgStyle = scisSmall then
      Result := AItem.ImageIndex
    else
      Result := AItem.LargeImageIndex;

    S := GetItemStyle(Index);
    if S = nil then Exit;

    if ImgStyle = scisSmall then
      Result := S.ImageIndex
    else
      Result := S.LargeImageIndex;
  end;
end;

function TSCListGroup.GetImageList(Index: Integer): TCustomImageList;
var
  S: TSCListGroupStyle;
  ImgStyle: TSCListImageStyle;
begin
  Result := nil;
  if not FShowImages then Exit;

  ImgStyle := GetImageStyle(Index);

  if ImgStyle = scisSmall then
    Result := SmallImages
  else
    Result := FLargeImages;

  if IsValidItem(Index) then
  begin
    S := GetItemStyle(Index);
    if S = nil then Exit;

    if ImgStyle = scisSmall then
    begin
      if S.Images <> nil then
        Result := S.Images
    end else
    if S.LargeImages <> nil then
      Result := S.LargeImages;
  end;
end;

function TSCListGroup.GetImageStyle(Index: Integer): TSCListImageStyle;
begin
  Result := FImageStyle;
  if (Result = scisLarge) and IsValidItem(Index) and
    (FItems[Index].ViewStyle = scvsLabel) then
    Result := scisSmall;
end;

function TSCListGroup.GetItemAtPos(P: TPoint; IntersectClient: Boolean): Integer;
var
  CR, R, R2,
  R3, TxtR: TRect;
  I, H, L,
  IW, IH, Img, BvSz: Integer;
  AItem: TSCListGroupItem;
  OutOfClient: Boolean;
  ImgList: TCustomImageList;
  F: TFont;
  S: TSCListGroupStyle;
begin
  Result := -1;
  if (FItems = nil) or (FItems.Count = 0) then
    Exit;

  CR := GetClientRect;
  R := CR;

  AdjustClientRect(R);
  AdjustItemRect(R);

  InflateRect(R, -Indent, 0);

  if IntersectClient then
    IntersectRect(R, R, CR);

  OutOfClient := IntersectClient and (IsRectEmpty(R) or not PtInRect(R, P));

  OutOfClient := OutOfClient or (R.Right <= R.Left) or
     (P.x < R.Left) or (P.x > R.Right) or (P.y < R.Top);

  if OutOfClient then
    Exit;

  R2 := R;
  R2.Bottom := R2.Top;

  ValidateTopItemIndex(FTopItem);

  for I := FTopItem to FItems.Count-1 do
  begin
    AItem := FItems.Items[I];
    if not AItem.Visible then Continue;

    H := GetItemHeight(I);

    if H > 0 then
    begin
      Inc(R2.Bottom, H);

      if PtInRect(R2, P) then
      begin
        if (AItem.Indent > 0) and CanIndent(I) then
        begin
          Inc(R2.Left, AItem.Indent);
          if R2.Left > R2.Right then
            R2.Left := R2.Right;

          if IsRectEmpty(R2) or not PtInRect(R2, P) then
            Exit;
        end;

        Result := I;
        BvSz := GetBevelSize;

        if (FItems[I].ViewStyle = scvsLabel) or
          ((FImageStyle = scisSmall) and (FItems[I].ViewStyle = scvsButton) and
          (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew])) then
        begin
          InflateRect(R2, -BvSz, -BvSz);
          ImgList := GetImageList(I);

          R3 := R2;
          R3.Right := R3.Left;

          if ImgList <> nil then
          begin
            Img := GetImageIndex(I);

            if (Img > -1) and (Img < ImgList.Count) then
            begin
              IW := ImgList.Width;
              Inc(R3.Right,  IW + Spacing + BvSz);
            end;
          end;

          TxtR := R2;
          TxtR.Left := R3.Right;

          if not IsRectEmpty(TxtR) then
          begin
            S := GetItemStyle(I);

            F := Self.Font;
            if S <> nil then F := S.Font;

            DoDrawItemText(Canvas, FItems[I].Caption, F, TxtR, True, I);
            IntersectRect(TxtR, TxtR, R2);

            if not IsRectEmpty(TxtR) then
              Inc(R3.Right, TxtR.Right - TxtR.Left);
          end;

          InflateRect(R3, BvSz, 0);
          if IsRectEmpty(R3) or not PtInRect(R3, P) then
            Result := -1;
        end else
        if (FImageStyle = scisLarge) and
          (FItems[I].ViewStyle = scvsButton) and
          (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew]) then
        begin
          ImgList := GetImageList(I);

          if ImgList <> nil then
          begin
            Img := GetImageIndex(I);

            if (Img > -1) and (Img < ImgList.Count) then
            begin
              IW := ImgList.Width;
              IH := ImgList.Height;

              if (IW > 0) and (IH > 0) and (IW < R2.Right - R2.Left) then
              begin
                R3 := R2;

                R3.Left := R3.Left + ((R3.Right - R3.Left - IW) div 2);
                R3.Right := R3.Left + IW;

                InflateRect(R3, BvSz, 0);

                Inc(R3.Top, BvSz);
                R3.Bottom := R3.Top + IH + Spacing + 2*BvSz;

                R2.Top := R3.Bottom;

                if not IsRectEmpty(R3) and PtInRect(R3, P) then
                  Exit;
              end;
            end;
          end;

          TxtR := R2;
          if not IsRectEmpty(TxtR) then
          begin
            S := GetItemStyle(I);

            F := Self.Font;
            if S <> nil then F := S.Font;

            DoDrawItemText(Canvas, FItems[I].Caption, F, TxtR, True, I);
            IntersectRect(TxtR, TxtR, R2);

            if not IsRectEmpty(TxtR) then
            begin
              InflateRect(TxtR, BvSz, BvSz);

              L := R2.Left +
                ((R2.Right - R2.Left - (TxtR.Right - TxtR.Left)) div 2);

              OffsetRect(TxtR, -TxtR.Left, -TxtR.Top);
              OffsetRect(TxtR, L, R2.Top);
            end;
          end;

          if IsRectEmpty(TxtR) or not PtInRect(TxtR, P) then
            Result := -1;
        end;

        Exit;
      end;

      Inc(R2.Bottom, FItemSpace);
      R2.Top := R2.Bottom;

      if IntersectClient and
        (R2.Top >= R.Bottom) then Exit;
    end;
  end;
end;

function TSCListGroup.GetItemFont(Index: Integer): TFont;
var
  S: TSCListGroupStyle;
  AItem: TSCListGroupItem;
begin
  Result := nil;
  if IsValidItem(Index) then
  begin
    AItem := FItems.Items[Index];
    if not AItem.Visible then Exit;

    Result := Self.Font;

    S := GetItemStyle(Index);
    if S <> nil then
      Result := S.Font;
  end;
end;

function TSCListGroup.GetItemHeight(Index: Integer; W: Integer): Integer;
var
  F: TFont;
  S: TSCListGroupStyle;
  R, TxR: TRect;
  H, TxH, IH, IW,
  BvSz, ImgIndx: Integer;
  ImgList: TCustomImageList;
  AItem: TSCListGroupItem;
  ImgStyle: TSCListImageStyle;
begin
  Result := 0;
  if (W = 0) or (W < -1) or
    not IsValidItem(Index) then Exit;

  if W = -1 then
  begin
    R := ClientRect;

    AdjustClientRect(R);
    AdjustItemRect(R);

    W := R.Right - R.Left;
    if W <= 0 then Exit;
  end;

  R := Rect(0, 0, W, 0);
  InflateRect(R, -Indent, 0);

  AItem := FItems.Items[Index];

  if (AItem.Indent > 0) and CanIndent(Index) then
  begin
    Inc(R.Left, AItem.Indent);
    if R.Left >= R.Right then
      Exit;
  end;

  ImgStyle := GetImageStyle(Index);

  BvSz := GetBevelSize;
  InflateRect(R, -BvSz, 0);
  Inc(R.Top, BvSz);

  try
    S := GetItemStyle(Index);

    F := Self.Font;
    if S <> nil then F := S.Font;

    ImgList := GetImageList(Index);

    H := 0; IW := 0;
    if ImgList <> nil then
    begin
      ImgIndx := GetImageIndex(Index);

      if (ImgIndx > -1) and (ImgIndx < ImgList.Count) then
      begin
        IW := ImgList.Width;
        IH := ImgList.Height;

        if ImgStyle = scisSmall then
        begin
          Inc(IW, Spacing);

          if (AItem.ViewStyle = scvsButton) and
            (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew]) then
            Inc(IW, BvSz);
        end else
        begin
          Inc(IH, Spacing);

          if (AItem.ViewStyle = scvsButton) and
            (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew]) then
            Inc(IH, BvSz);
        end;

        Inc(H, IH);
      end;  
    end;

    TxR := R;
    if (IW > 0) and (ImgStyle = scisSmall) then
    begin
      Inc(TxR.Left, IW);

      if TxR.Right < TxR.Left then
        TxR.Right := TxR.Left;
    end;

    DoDrawItemText(Canvas, AItem.Caption, F, TxR, True, Index);

    OffsetRect(TxR, 0, -TxR.Top);
    if TxR.Bottom < TxR.Top then
      TxR.Bottom := TxR.Top;

    TxH := TxR.Bottom - TxR.Top;

    if ImgStyle = scisLarge then
      Inc(H, TxH + 2)
    else
    if H < TxR.Bottom - TxR.Top then
      H := TxH;

    with AItem do
      if (FLine <> scglNone) and
        (FLineColor <> clNone) and (ViewStyle = scvsLabel) then
        Inc(H, 2);

    R.Bottom := R.Top + H;
  finally
    Dec(R.Top, BvSz);
    InflateRect(R, BvSz, BvSz);

    Result := R.Bottom - R.Top;
    if Result < 0 then Result := 0;
  end;
end;

function TSCListGroup.GetItemRect(Index: Integer; Sharpen: Boolean;
  IntersectClient: Boolean): TRect;
var
  CR, R, R2: TRect;
  I, H, Tp: Integer;
  AItem: TSCListGroupItem;
begin
  Result := Rect(0, 0, 0, 0);
  if IsValidItem(Index) then Exit;

  AItem := FItems.Items[Index];
  if not AItem.Visible then Exit;

  CR := GetClientRect;

  R := CR;
  AdjustClientRect(R);
  AdjustItemRect(R);

  if (R.Right <= R.Left) or
    (IntersectClient and IsRectEmpty(R)) then Exit;

  R2 := R;
  R2.Bottom := R2.Top;

  ValidateTopItemIndex(FTopItem);

  Tp := FTopItem;
  if IntersectClient and (Index < Tp) then
    Exit;

  if (Tp > 0) and (Index < Tp) then
  begin
    R2 := CR;
    R2.Bottom := R2.Top;

    for I := Tp downto 0 do
    begin
      AItem := FItems.Items[I];
      if not AItem.Visible then Continue;

      H := GetItemHeight(I);
      Dec(R2.Top, H);

      if I = Index then
      begin
        Result := R2;
        if (AItem.Indent > 0) and CanIndent(Index) then
        begin
          Inc(Result.Left, AItem.Indent);
          if Result.Left > Result.Right then
            Result.Left := Result.Right;
        end;

        if Sharpen then
          Result := SharpenRect(Result, I);

        Exit;
      end;

      if H > 0 then
        Dec(R2.Top, FItemSpace);
      R2.Bottom := R2.Top;
    end;

    Exit;
  end;

  for I := Tp to FItems.Count-1 do
  begin
    AItem := FItems.Items[I];
    if not AItem.Visible then Continue;

    H := GetItemHeight(I);
    Inc(R2.Bottom, H);

    if I = Index then
    begin
      Result := R2;
      if (AItem.Indent > 0) and CanIndent(Index) then
      begin
        Inc(Result.Left, AItem.Indent);
        if Result.Left > Result.Right then
          Result.Left := Result.Right;
      end;

      if Sharpen then
        Result := SharpenRect(Result, I);

      Exit;
    end;

    if H > 0 then
      Inc(R2.Bottom, FItemSpace);
    R2.Top := R2.Bottom;

    if IntersectClient and
      (R2.Top >= R.Bottom) then Exit;
  end;
end;

function TSCListGroup.GetItemRect(P: TPoint; Sharpen: Boolean;
  IntersectClient: Boolean): TRect;
var
  I: Integer;
begin
  Result := GetRectAndItem(P, I, Sharpen, IntersectClient);
end;

function TSCListGroup.GetItemState(Index: Integer): TSCListItemState;
var
  AItem: TSCListGroupItem;
begin
  Result := scstUnknown;
  if IsValidItem(Index) then
  begin
    Result := scstDefault;
    AItem := FItems.Items[Index];

    if not AItem.Visible then
      Result := scstInvisible
    else
    if not AItem.Enabled then
      Result := scstDisabled
    else
    if Index = FHotItem then
      Result := scstHotTracked
    else
    if Index = FClickedItem then
      Result := scstPressed
    else
    if AItem.FSelected then
      Result := scstSelected
    else
    if Index = FFocusedItem then
      Result := scstFocused;
  end;
end;

function TSCListGroup.GetItemStyle(Index: Integer): TSCListGroupStyle;
begin
  Result := nil;
  if IsValidItem(Index) then
    Result := FItems.Items[Index].Style;
end;

function TSCListGroup.GetItemTextFlags(CalcRect: Boolean; Index: Integer): Integer;
begin
  Result := 0;

  if IsMultiLine then
  begin
    Result := Result or DT_TOP or DT_WORDBREAK;
    if GetImageStyle(Index) = scisLarge then
      Result := Result or DT_CENTER
    else  
      Result := Result or DT_LEFT;

    if not CalcRect then
      Result := Result or DT_END_ELLIPSIS;
  end else
  begin
    Result := Result or DT_LEFT or DT_SINGLELINE;

    if CalcRect then
      Result := Result or DT_TOP
    else
      Result := Result or DT_END_ELLIPSIS or DT_VCENTER;
  end;

  Result := Result or DT_EXPANDTABS;
  if CalcRect then
    Result := Result or DT_CALCRECT;
end;

function TSCListGroup.GetRectAndItem(P: TPoint; var Index: Integer;
  Sharpen: Boolean; IntersectClient: Boolean): TRect;
var
  CR, R, R2: TRect;
  I, H: Integer;
  AItem: TSCListGroupItem;
  OutOfClient: Boolean;
begin
  Index := -1;
  Result := Rect(0, 0, 0, 0);
  if (FItems = nil) or (FItems.Count = 0) then Exit;

  CR := GetClientRect;

  R := CR;
  AdjustClientRect(R);
  AdjustItemRect(R);

  if IntersectClient and
    (IsRectEmpty(R) or not PtInRect(R, P)) then Exit;

  OutOfClient := IntersectClient and
    (IsRectEmpty(R) or not PtInRect(R, P));

  OutOfClient := OutOfClient and ((R.Right <= R.Left) or
     (P.x < R.Left) or (P.x > R.Right) or (P.y < R.Top));

  if OutOfClient then Exit;

  R2 := R;
  R2.Bottom := R2.Top;

  ValidateTopItemIndex(FTopItem);

  if (FTopItem > 0) and (P.y < R.Top) then
  begin
    R2 := CR;
    R2.Bottom := R2.Top;

    for I := FTopItem-1 downto 0 do
    begin
      AItem := FItems.Items[I];
      if not AItem.Visible then Continue;

      H := GetItemHeight(I);
      Dec(R2.Top, H);

      if PtInRect(R2, P) then
      begin
        Index := I;
        Result := R2;

        if (AItem.Indent > 0) and CanIndent(Index) then
        begin
          Inc(Result.Left, AItem.Indent);
          if Result.Left > Result.Right then
            Result.Left := Result.Right;
        end;

        if not IsRectEmpty(Result) and Sharpen then
          Result := SharpenRect(Result, I);

        if IsRectEmpty(Result) then
          Index := -1;

        Exit;
      end;

      if H > 0 then
        Dec(R2.Top, FItemSpace);
      R2.Bottom := R2.Top;
    end;

    Exit;
  end;

  for I := FTopItem to FItems.Count-1 do
  begin
    AItem := FItems.Items[I];
    if not AItem.Visible then Continue;

    H := GetItemHeight(I);
    if H > 0 then
      Inc(R2.Bottom, H);

    if PtInRect(R2, P) then
    begin
      Index := I;
      Result := R2;

      if (AItem.Indent > 0) and CanIndent(Index) then
      begin
        Inc(Result.Left, AItem.Indent);
        if R.Left > R.Right then
          R.Left := R.Right;
      end;

      if not IsRectEmpty(Result) and Sharpen then
        Result := SharpenRect(Result, I);

      if IsRectEmpty(Result) then
        Index := -1;

      Exit;
    end;

    if H > 0 then
      Inc(R2.Bottom, FItemSpace);
    R2.Top := R2.Bottom;

    if IntersectClient and
      (R2.Top >= R.Bottom) then Exit;
  end;
end;

function TSCListGroup.GetScrollerAtPos(P: TPoint): TSCListScrollButton;

  function IsInUpScroller(R: TRect): Boolean;
  var
    R2: TRect;
    W, H, Img: Integer;
    IsClicked, IsEnabled, IsHot: Boolean;
  begin
    Result := False;

    IsHot := (FClickedButton = scsbNone) and (FHotButton = scsbUp);
    IsEnabled := FScrollers.UpScroller.Enabled;
    IsClicked := (FClickedButton = scsbUp) and (FHotButton = scsbUp);

    W := 16; H := 16;

    if FScrollerImages <> nil then
      with FScrollerImages, FScrollers.UpScroller do
      begin
        Img := ImageDefault;
        if not IsEnabled then
          Img := ImageDisabled
        else  
        if IsClicked then
          Img := ImagePressed
        else
        if IsHot then
          Img := ImageHot;

        if (Img < 0) or
          (Img > FScrollerImages.Count - 1) then
        begin
          W := Width;
          H := Height;
        end;  
      end;

    if (W > 0) and (H > 0) then
    begin
      R2 := R;

      R2.Left := R2.Right - W;
      if R2.Left < R.Left then
        R2.Left := R.Left;

      R2.Bottom := R2.Top + H;
      if R2.Bottom > R.Bottom then
        R2.Bottom := R.Bottom;

      Result := PtInRect(R2, P);
    end;
  end;

  function IsInDownScroller(R: TRect): Boolean;
  var
    R2: TRect;
    W, H, Img: Integer;
    IsClicked, IsEnabled, IsHot: Boolean;
  begin
    Result := False;

    IsHot := (FClickedButton = scsbNone) and (FHotButton = scsbDown);
    IsEnabled := FScrollers.DownScroller.Enabled;
    IsClicked := (FClickedButton = scsbDown) and (FHotButton = scsbDown);

    W := 16; H := 16;

    if FScrollerImages <> nil then
      with FScrollerImages, FScrollers.DownScroller do
      begin
        Img := ImageDefault;
        if not IsEnabled then
          Img := ImageDisabled
        else  
        if IsClicked then
          Img := ImagePressed
        else
        if IsHot then
          Img := ImageHot;

        if (Img < 0) or
          (Img > FScrollerImages.Count - 1) then
        begin
          W := Width;
          H := Height;
        end;
      end;

    if (W > 0) and (H > 0) then
    begin
      R2 := R;

      R2.Left := R2.Right - W;
      if R2.Left < R.Left then
        R2.Left := R.Left;

      R2.Top := R2.Bottom - H;
      if R2.Top < R.Top then
        R2.Top := R.Top;

      Result := PtInRect(R2, P);
    end;
  end;

var
  R: TRect;
begin
  Result := scsbNone;
  if (P.x < 0) or (P.y < 0) or (FItems = nil) or
    (FItems.Count = 0) or not FScrollers.Visible then
    Exit;

  R := GetClientRect;

  AdjustClientRect(R);
  AdjustItemRect(R);

  InflateRect(R, -4, -4);
  if IsRectEmpty(R) or not PtInRect(R, P) then Exit;

  if IsInDownScroller(R) then
  begin
    Result := scsbDown;
    if not FScrollers.DownScroller.Enabled then
      Result := scsbDisabled;
  end else
  if IsInUpScroller(R) then
  begin
    Result := scsbUp;
    if not FScrollers.UpScroller.Enabled then
      Result := scsbDisabled;
  end;
end;

function TSCListGroup.IsHotItem(Index: Integer): Boolean;
begin
  Result := IsValidItem(Index) and FItems[Index].Enabled and
    ((FHotItem = Index) or FItems[Index].FSelected or
     ((FClickedItem > -1) and (FHotClickItem = FClickedItem) and
      (FClickedItem = Index)));
end;

function TSCListGroup.IsMultiLine: Boolean;
begin
  Result := FWordWrap or (FImageStyle = scisLarge);
end;

function TSCListGroup.IsValidItem(Index: Integer): Boolean;
begin
  Result := (FItems <> nil) and
    (Index > -1) and (Index < FItems.Count);
end;

procedure TSCListGroup.ItemChanged(Item: TSCListGroupItem);
begin
  if IsDestroying or IsLoading then
    Exit;

  StopScrolling;
  if not Item.Visible then
  begin
    if FClickedItem = Item.Index then
    begin
      FHotItem := -1;
      FClickedItem := -1;
      FHotClickItem := -1;
    end;

    if FFocusedItem = Item.Index then
      FFocusedItem := -1;
  end;

  AdjustSize;
  Invalidate;
end;

procedure TSCListGroup.ItemsChanged;
begin
  if IsDestroying or IsLoading then
    Exit;

  StopScrolling;

  FHotItem := -1;
  FClickedItem := -1;
  FHotClickItem := -1;
  
  ValidateItemIndex(FFocusedItem);

  AdjustSize;
  Invalidate;
end;

procedure TSCListGroup.LargeImagesChanged(Sender: TObject);
begin
  if FImageStyle = scisLarge then
  begin
    AdjustSize;
    Invalidate;
  end;
end;

procedure TSCListGroup.ApplyMouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  OldIndx: Integer;
  SB: TSCListScrollButton;
begin
  P := Point(X, Y);

  if FClickedButton <> scsbNone then
  begin
    SB := GetScrollerAtPos(P);

    if SB = FClickedButton then
    begin
      if FHotButton <> FClickedButton then
        ResumeScrolling;
      FHotButton := SB;
    end else
    begin
      FHotButton := scsbNone;
      PauseScrolling;
    end;

    if SB <> FHotButton then
    begin
      Application.CancelHint;

      Invalidate;
      UpdateCursor(False);
    end;
  end else
  if FClickedItem <> -1 then
  begin
    FHotButton := scsbNone;
    FClickedButton := scsbNone;

    FHotItem := -1;
    OldIndx := FHotClickItem;

    FHotClickItem := GetItemAtPos(P, True);
    if IsValidItem(FHotClickItem) and not FItems[FHotClickItem].Enabled then
      FHotClickItem := -1;

    if FHotClickItem <> OldIndx then
    begin
      Application.CancelHint;

      Invalidate;
      UpdateCursor(False);

      if IsValidItem(FHotClickItem) and (FHotClickItem = FClickedItem) then
        DoItemHottrack(FHotClickItem);
    end;
  end else
  begin
    OldIndx := FHotItem;
    FClickedButton := scsbNone;

    FHotItem := -1;
    FClickedItem := -1;
    FHotClickItem := -1;

    SB := GetScrollerAtPos(P);
    if SB = scsbNone then
    begin
      FHotButton := scsbNone;

      FHotItem := GetItemAtPos(P, True);
      if IsValidItem(FHotItem) and not FItems[FHotItem].Enabled then
        FHotItem := -1;

      if FHotItem <> OldIndx then
      begin
        Application.CancelHint;

        Invalidate;
        UpdateCursor(False);

        if IsValidItem(FHotItem) then
          DoItemHottrack(FHotItem);
      end;

      Exit;
    end;

    if FHotButton <> SB then
    begin
      Application.CancelHint;

      FHotButton := SB;
      Invalidate;
      UpdateCursor(False);
    end;
  end;
end;

procedure TSCListGroup.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  P: TPoint;
begin
  P := Point(X, Y);
  inherited MouseDown(Button, Shift, X, Y);

  FScrollTopItem := -1;

  FHotButton := scsbNone;
  FClickedButton := scsbNone;
  FItemDblClicked := False;

  FHotItem      := -1;
  FClickedItem  := -1;
  FHotClickItem := -1;

  StopScrolling;

  if Focused and (Button = mbLeft) then
  begin
    FHotButton := GetScrollerAtPos(P);
    FClickedButton := FHotButton;

    if FClickedButton <> scsbNone then
    begin
      FMouseDownItem := -1;
      FScrollTopItem := -1;

      if FClickedButton <> scsbDisabled then
      begin
        FScrollTopItem := FTopItem;
        StartScrolling;
      end;

      Exit;
    end;

    FHotItem := GetItemAtPos(P, True);
    if IsValidItem(FHotItem) and not FItems[FHotItem].Enabled then
      FHotItem := -1;

    FClickedItem  := FHotItem;
    FHotClickItem := FClickedItem;

    if IsValidItem(FHotItem) and (FItems[FHotItem].ViewStyle = scvsButton) then
      FFocusedItem := FHotItem;

    if FClickedItem <> -1 then
      Invalidate;
  end;

  UpdateCursor(False);

  if FClickedItem > -1 then
  begin
    if(Button = mbLeft) and (ssDouble in Shift) and (FClickedItem = FMouseDownItem) then
      DoItemDblClick(FClickedItem);

    DoItemMouseDown(FClickedItem);

    FItemDblClicked := ssDouble in Shift;
  end;

  FMouseDownItem := FClickedItem;
end;

procedure TSCListGroup.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  P := Point(X, Y);
  inherited MouseMove(Shift, X, Y);

  ApplyMouseMove(Shift, X, Y);
end;

procedure TSCListGroup.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  P: TPoint;
  HotClk, ClkItem: Integer;
  NeedPaint: Boolean;
  ClkBtn, SB: TSCListScrollButton;
begin
  P := Point(X, Y);
  inherited MouseUp(Button, Shift, X, Y);

  HotClk := FHotClickItem;
  ClkItem := FClickedItem;

  FHotItem := -1;
  FClickedItem := -1;
  FHotClickItem := -1;

  SB := FHotButton;
  ClkBtn := FClickedButton;

  StopScrolling;
  FClickedButton := scsbNone;

  FHotButton := GetScrollerAtPos(P);

  NeedPaint := False;
  if FHotButton = scsbNone then
  begin
    FHotItem := GetItemAtPos(P, True);
    if IsValidItem(FHotItem) and not FItems[FHotItem].Enabled then
      FHotItem := -1;

    if (ClkItem <> -1) and (ClkItem <> HotClk) and IsValidItem(FHotItem) then
      DoItemHottrack(FHotItem);

    if FItemDblClicked then
      FMouseDownItem := -1;

    if (ClkItem <> -1) and IsValidItem(ClkItem) then
    begin
      if FHotItem = ClkItem then
      begin
        if FCanSelect and (FItems[ClkItem].ViewStyle = scvsButton) then
        begin
          NeedPaint := True;

          FItems[ClkItem].FSelected := not FItems[ClkItem].FSelected;
          SelectionChanged(FItems[ClkItem]);
        end;

        if not FItemDblClicked then
          DoItemClick(ClkItem);
      end;
      
      DoItemMouseUp(FHotItem);
    end;
  end else
  if (FHotButton <> scsbDisabled) and (FHotButton = ClkBtn) and (FScrollTopItem = FTopItem) then
  begin
    ClkItem := FTopItem;

    if FHotButton = scsbDown then
    begin
      if FTopItem < FItems.Count-1 then
        Inc(FTopItem);
    end else
    if FTopItem > 0 then
      Dec(FTopItem);

    UpdateScrollers;

    ValidateTopItemIndex(FTopItem);
    NeedPaint := ClkItem <> FTopItem;
  end;

  FItemDblClicked := False;

  FScrollTopItem := -1;
  if NeedPaint or (FHotItem <> ClkItem) or (SB <> FHotButton) then
    Invalidate;

  UpdateCursor(False);
end;

procedure TSCListGroup.Paint;
var
  CR: TRect;
  Rgn, PrevRgn: HRGN;
begin
  inherited Paint;

  CR := GetClientRect;

  AdjustClientRect(CR);
  AdjustItemRect(CR);

  if not IsRectEmpty(CR) then
  begin
    PrevRgn := CreateRectRgn(0, 0, 0, 0);
    GetClipRgn(Canvas.Handle, PrevRgn);

    try
      Rgn := CreateRectRgnIndirect(CR);
      try
        ExtSelectClipRgn(Canvas.Handle, Rgn, RGN_AND);
      finally
        DeleteObject(Rgn);
      end;

      DoDrawItems;
      DoDrawScrollers;
    finally
      SelectClipRgn(Canvas.Handle, PrevRgn);
      DeleteObject(PrevRgn);
    end;
  end;
end;

procedure TSCListGroup.PauseScrolling;
begin
  FScrolling := False;
end;

procedure TSCListGroup.ResumeScrolling;
begin
  FScrolling := not (FClickedButton in [scsbNone, scsbDisabled]) and
    (FClickedButton = FHotButton) and (FScrollTimer <> -1);
end;

procedure TSCListGroup.GroupScrollerChanged(Sender: TSCListGroupScrollers;
  FullRefresh: Boolean);
begin
  if (Sender = nil) or FullRefresh or Sender.Visible then
    Invalidate;
end;

procedure TSCListGroup.ScrollerImagesChanged(Sender: TObject);
begin
  GroupScrollerChanged(FScrollers, False);
end;

procedure TSCListGroup.ScrollGroup;
var
  Tp: Integer;
begin
  if not Scrolling then Exit;

  ValidateTopItemIndex(FTopItem);

  Tp := FTopItem;
  if FClickedButton = scsbUp then
    Dec(FTopItem)
  else
    Inc(FTopItem);

  ValidateTopItemIndex(FTopItem);
  UpdateScrollers;

  if Tp <> FTopItem then
  begin
    Invalidate;
    DoScrolled;
  end;
end;

function TSCListGroup.Scrolling: Boolean;
begin
  Result := Enabled and FScrolling and
    (FClickedButton = FHotButton) and (FScrollTimer <> -1) and
    not (FClickedButton in [scsbNone, scsbDisabled]);
end;

function TSCListGroup.ScrollPaused: Boolean;
begin
  Result := not FScrolling and (FScrollTimer <> -1) and
    not (FClickedButton in [scsbNone, scsbDisabled]);
end;

procedure TSCListGroup.SelectionChanged(Sender: TSCListGroupItem);
var
  I, Cnt: Integer;
begin
  if Sender = nil then Exit;

  if not FCanSelect and Sender.FSelected then
  begin
    Sender.FSelected := False;
    Exit;
  end;

  if not FAllowAllUp and not Sender.FSelected then
  begin
    Cnt := 0;
    for I := 0 to FItems.Count-1 do
       if FItems[I].FSelected then
         Inc(Cnt);

    Sender.FSelected := Cnt = 0;
    Invalidate;

    Exit;
  end;

  if not (FCanMultiSelect or FAllowAllUp) then
    for I := 0 to FItems.Count-1 do
      FItems[I].FSelected := Sender = FItems[I];

  Invalidate;

  DoItemSelect(Sender.Index);
end;

procedure TSCListGroup.SetButtonStyle(Value: TSCGroupButtonStyle);
begin
  if FButtonStyle <> Value then
  begin
    FButtonStyle := Value;
    DoChange;

    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCListGroup.SetCanMultiSelect(Value: Boolean);
var
  I, Indx: Integer;
begin
  if FCanMultiSelect <> Value then
  begin
    FCanMultiSelect := Value;

    if not Value and
      (FItems.Count > 0) then
    begin
      Indx := -1;
      for I := 0 to FItems.Count-1 do
        if FItems[I].FSelected then
        begin
          FItems[I].FSelected := Indx = -1;
          Indx := I;
        end;

      Invalidate;
    end;
  end;
end;

procedure TSCListGroup.SetCanSelect(Value: Boolean);
var
  I: Integer;
begin
  if FCanSelect <> Value then
  begin
    FCanSelect := Value;

    if not Value then
    begin
      for I := 0 to FItems.Count-1 do
        FItems[I].FSelected := False;

      Invalidate;
    end;
  end;
end;

procedure TSCListGroup.SetHottrackCursor(Value: TCursor);
begin
  if FHottrackCursor <> Value then
  begin
    FHottrackCursor := Value;
    UpdateCursor(True);
  end;
end;

procedure TSCListGroup.SetImageStyle(Value: TSCListImageStyle);
begin
  if FImageStyle <> Value then
  begin
    FImageStyle := Value;
    DoChange;

    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCListGroup.SetItems(Value: TSCListGroupItems);
begin
  FItems.Assign(Value);
end;

procedure TSCListGroup.SetItemSpace(Value: Integer);
begin
  if Value < 0 then Value := 0
  else
  if Value > 100 then Value := 100;

  if FItemSpace <> Value then
  begin
    FItemSpace := Value;
    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCListGroup.SetLargeImages(Value: TCustomImageList);
var
  FOldImages: TCustomImageList;
begin
  FOldImages := FLargeImages;
  if FLargeImages <> nil then
    FLargeImages.UnRegisterChanges(FLargeImageChangeLink);

  FLargeImages := Value;
  if FLargeImages <> nil then
  begin
    FLargeImages.RegisterChanges(FLargeImageChangeLink);
    FLargeImages.FreeNotification(Self);
  end;

  if FOldImages <> FLargeImages then
    Invalidate;
end;

procedure TSCListGroup.SetScrollers(Value: TSCListGroupScrollers);
begin
  FScrollers.Assign(Value);
end;

procedure TSCListGroup.SetScrollerImages(Value: TCustomImageList);
var
  FOldImages: TCustomImageList;
begin
  FOldImages := FLargeImages;
  if FScrollerImages <> nil then
    FScrollerImages.UnRegisterChanges(FScrollerImageChangeLink);

  FScrollerImages := Value;
  if FScrollerImages <> nil then
  begin
    FScrollerImages.RegisterChanges(FScrollerImageChangeLink);
    FScrollerImages.FreeNotification(Self);
  end;

  if FOldImages <> FScrollerImages then
    Invalidate;
end;

procedure TSCListGroup.SetShowImages(Value: Boolean);
begin
  if FShowImages <> Value then
  begin
    FShowImages := Value;
    Invalidate;
  end;
end;

procedure TSCListGroup.SetSmallImages(Value: TCustomImageList);
var
  FOldImages: TCustomImageList;
begin
  FOldImages := FLargeImages;
  if FSmallImages <> nil then
    FSmallImages.UnRegisterChanges(FSmallImageChangeLink);

  FSmallImages := Value;
  if FSmallImages <> nil then
  begin
    FSmallImages.RegisterChanges(FSmallImageChangeLink);
    FSmallImages.FreeNotification(Self);
  end;

  if FOldImages <> FSmallImages then
    Invalidate;
end;

procedure TSCListGroup.SetTopItem(Index: Integer);
begin
  ValidateTopItemIndex(Index);

  if FTopItem <> Index then
  begin
    FTopItem := Index;
    if (Items <> nil) and (FItems.Count > 0) then
    begin
      Invalidate;
      DoScrolled;
    end;
  end;
end;

procedure TSCListGroup.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    DoChange;

    if (FItems <> nil) and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCListGroup.SmallImagesChanged(Sender: TObject);
begin
  if FImageStyle = scisSmall then
  begin
    AdjustSize;
    Invalidate;
  end;
end;

procedure TSCListGroup.StartScrolling;
var
  ScrlBtn: TSCListScrollButton;
begin
  if not HandleAllocated then Exit;

  if not (FClickedButton in [scsbNone, scsbDisabled]) then
  begin
    if ScrollPaused then
    begin
      ResumeScrolling;
      Exit;
    end;

    if (FClickedButton = FHotButton) and
      not (FClickedButton in [scsbNone, scsbDisabled]) then
    begin
      ScrlBtn := FClickedButton;
      StopScrolling;

      if CanScroll(ScrlBtn = scsbUp) then
      begin
        ValidateTopItemIndex(FTopItem);

        FHotButton := ScrlBtn;
        FClickedButton := ScrlBtn;

        FScrollTimer := SetTimer(Handle, SC_GROUP_SCROLLTIMERID, GetDoubleClickTime, nil);
        FScrolling := FScrollTimer <> -1;

        ScrollGroup;
      end;
    end;
  end;
end;

procedure TSCListGroup.StopScrolling;
begin
  FScrolling := False;

  FHotButton := scsbNone;
  FClickedButton := scsbNone;

  if FScrollTimer <> -1 then
  begin
    if HandleAllocated then
      KillTimer(Handle, FScrollTimer);
    FScrollTimer := -1;

    Invalidate;
  end;
end;

procedure TSCListGroup.StopTracking;
var
  NeedPaint: Boolean;
begin
  NeedPaint := (FHotItem <> -1) or
    ((FClickedItem <> -1) and (FHotClickItem <> -1));

  FClickedItem := -1;
  FHotItem := -1;
  FHotClickItem := -1;

  inherited StopTracking;

  if NeedPaint then
    Invalidate;
end;

procedure TSCListGroup.StyleChanged(S: TSCListGroupStyle);
begin
  if IsDestroying or IsLoading then
    Exit;
    
  AdjustSize;
  Invalidate;
end;

procedure TSCListGroup.StyleDestroyed(S: TSCListGroupStyle);
var
  I: Integer;
begin
  if IsDestroying or IsLoading then
    Exit;

  FItems.BeginUpdate;
  try
    for I := 0 to FItems.Count-1 do
      FItems[I].StyleDestroyed(S);
  finally
    FItems.EndUpdate;
  end;
end;

procedure TSCListGroup.StylesChanged;
begin
  if IsDestroying or IsLoading then
    Exit;
    
  AdjustSize;
  Invalidate;
end;

procedure TSCListGroup.UpdateHeight;
begin
  if not AutoSize or (FItems = nil) or IsLoading then
    Exit;

  Height := GetFullHeight;
end;

function TSCListGroup.UpdateScrollers: Boolean;

  function HideScrollers: Boolean;
  begin
    with FScrollers do
    begin
      Result := Visible;
      FVisible := False;
    end;
  end;

var
  R: TRect;
  L: TList;
  I, H, H2, W, Tp, ClientH, RestH: Integer;
  IsVisible, EnableUp, EnableDown: Boolean;
begin
  Result := False;

  if (FItems <> nil) and HandleAllocated and not IsLoading then
  begin
    R := GetClientRect;

    if IsRectEmpty(R) then
    begin
      if HideScrollers then
        Invalidate;

      Exit;
    end;

    AdjustClientRect(R);
    H2 := R.Bottom - R.Top;

    AdjustItemRect(R);
    ClientH := R.Bottom - R.Top;

    H := H2 - ClientH;
    W := R.Right - R.Left;

    if (ClientH <= 0) or (H <= 0) or (W <= 0) then
    begin
      if HideScrollers then
        Invalidate;

      Exit;
    end;

    H := H + GetCollapsedHeight;
    if Height <= H then
    begin
      if HideScrollers then
        Invalidate;

      Exit;
    end;

    L := TList.Create;
    try
      for I := 0 to FItems.Count - 1 do
      begin
        if not FItems[I].Visible then
        begin
          L.Add(Pointer(0));
          Continue;
        end;

        H2 := GetItemHeight(I, W);
        if H2 > 0 then
        begin
          L.Add(Pointer(H2 + FItemSpace));
          Inc(H, H2 + FItemSpace);
        end else
          L.Add(Pointer(0));
      end;

      if Height >= H then
      begin
        if HideScrollers then
          Invalidate;

        FTopItem := 0;

        Exit;
      end else
      begin
        Tp := FTopItem;

        ValidateTopItemIndex(FTopItem);
        if FTopItem < 0 then
          FTopItem := 0;

        if FTopItem > 0 then
        begin
          RestH := 0;
          for I := FTopItem to L.Count-1 do
            Inc(RestH, Integer(L[I]));

          if RestH < ClientH then
          begin
            RestH := 0;

            for I := L.Count-1 downto 0 do
              if Integer(L[I]) > 0 then
              begin
                Inc(RestH, Integer(L[I]));

                if RestH > ClientH then
                begin
                  FTopItem := I + 1;
                  Break;
                end;
              end;
          end;
        end;

        ValidateTopItemIndex(FTopItem);

        RestH := 0;
        for I := FTopItem to L.Count-1 do
          Inc(RestH, Integer(L[I]));

        with FScrollers do
        begin
          EnableUp := UpScroller.Enabled;
          EnableDown := DownScroller.Enabled;

          UpScroller.FEnabled := FTopItem > 0;
          DownScroller.FEnabled := (RestH > ClientH) and
            (FItems.Count > 1) and (FTopItem < FItems.Count - 1);

          IsVisible := FVisible;
          FVisible  := UpScroller.FEnabled or DownScroller.FEnabled;

          if (IsVisible <> FVisible) or (EnableUp <> UpScroller.FEnabled) or
            (EnableDown <> DownScroller.FEnabled) then
            Invalidate;
        end;

        if Tp <> FTopItem then
        begin
          Result := True;
          DoScrolled;
        end;
      end;
    finally
      L.Free;
    end;
  end;
end;

procedure TSCListGroup.ValidateItemIndex(var Indx: Integer);
begin
  if Indx < -1 then Indx := -1;
  if Indx > FItems.Count-1 then Indx := FItems.Count-1;
end;

procedure TSCListGroup.ValidateTopItemIndex(var Indx: Integer);
begin
  ValidateItemIndex(Indx);
  if (FItems <> nil) and (Indx > FItems.Count-1) then
    Indx := FItems.Count-1;

  if Indx < 0 then Indx := 0;
end;

procedure TSCListGroup.WMMouseWheel(var Message: TWMMouseWheel);
var
  Tp: Integer;
  MsgDone: Boolean;
  P: TPoint;
begin
  MsgDone := False;
  Tp := FTopItem;
  if Message.WheelDelta < 0 then
  begin
    Inc(FTopItem);

    ValidateTopItemIndex(FTopItem);
    MsgDone := UpdateScrollers;
  end else
  if Message.WheelDelta > 0 then
  begin
    Dec(FTopItem);

    ValidateTopItemIndex(FTopItem);
    MsgDone := UpdateScrollers;
  end;

  ValidateTopItemIndex(FTopItem);
  if Tp <> FTopItem then
  begin
    Invalidate;

    if GetCursorPos(P) then
    begin
      P := ScreenToClient(P);
      ApplyMouseMove([], P.x, P.y);
    end;

    if not MsgDone then
      DoScrolled;
  end;
end;

procedure TSCListGroup.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateScrollers;
end;

procedure TSCListGroup.WMTimer(var Message: TWMTimer);
begin
  inherited;

  if HandleAllocated and Scrolling and
    (Message.TimerID = SC_GROUP_SCROLLTIMERID) then
  begin
    ScrollGroup;
    if FScrollTimer <> -1 then
      KillTimer(Handle, FScrollTimer);

    FScrollTimer := SetTimer(Handle, SC_GROUP_SCROLLTIMERID, 50, nil);
    FScrolling := FScrollTimer <> -1;
  end;
end;

procedure TSCListGroup.SetShowFocusRect(Value: Boolean);
begin
  if FShowFocusRect <> Value then
  begin
    FShowFocusRect := Value;
    if CanDrawFocusRect then
      Invalidate;
  end;
end;

function TSCListGroup.CanDrawFocusRect: Boolean;
begin
  Result := IsValidItem(FFocusedItem) and
    (FItems[FFocusedItem].ViewStyle = scvsButton) and Focused;
end;

procedure TSCListGroup.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTCHARS or DLGC_WANTARROWS;
end;

procedure TSCListGroup.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_SPACE then
  begin
    if FSpaceDown then
    begin
      Key := 0;
      Exit;
    end;

    FSpaceDown := True;
  end;

  ProcessGroupKey(Key, False);
  inherited KeyDown(Key, Shift);
end;

procedure TSCListGroup.KeyPress(var Key: Char);
var
  K: Word;
begin
  if not (Ord(Key) in [VK_HOME, VK_END, VK_SPACE]) then
  begin
    K := Ord(Key);

    ProcessGroupKey(K, True);
    Key := Char(K);
  end;

  inherited KeyPress(Key);
end;

procedure TSCListGroup.ProcessGroupKey(var Key: Word; IsKeyPress: Boolean);

  procedure NextItem(var Indx: Integer; IsButton: Boolean);
  var
    I: Integer;
  begin
    ValidateItemIndex(Indx);
    if FItems.Count = 0 then Exit;

    if Indx < 0 then
    begin
      Indx := 0;
      Exit;
    end else
    if Indx >= FItems.Count-1 then
    begin
      Indx := FItems.Count-1;
      Exit;
    end;

    for I := Indx + 1 to FItems.Count-1 do
      if FItems[I].Visible then
      begin
        if IsButton and (FItems[I].ViewStyle <> scvsButton) then
          Continue;

        Indx := I;
        Exit;
      end;
  end;

  procedure PrevItem(var Indx: Integer; IsButton: Boolean);
  var
    I: Integer;
  begin
    ValidateItemIndex(Indx);
    if FItems.Count = 0 then Exit;

    if Indx <= 0 then
    begin
      Indx := 0;
      Exit;
    end;

    ValidateTopItemIndex(Indx);
    for I := Indx-1 downto 0 do
      if FItems[I].Visible then
      begin
        if IsButton and (FItems[I].ViewStyle <> scvsButton) then
          Continue;

        Indx := I;
        Exit;
      end;
  end;

  procedure DoKeyScrolling(OldTop: Integer);
  var
    Tp2: Integer;
  begin
    ValidateTopItemIndex(FTopItem);
    if OldTop <> FTopItem then
    begin
      Tp2 := FTopItem;
      UpdateScrollers;

      if OldTop <> FTopItem then
      begin
        Invalidate;
        if Tp2 = FTopItem then
          DoScrolled;
      end;
    end;
  end;

var
  NewKey: Word;
  Tp, Tp2, Fc: Integer;
begin
  if (FItems = nil) or (FItems.Count = 0) or
    IsValidItem(FClickedItem) then
    Exit;

  case Key of
    VK_RETURN:
    begin
      if IsValidItem(FFocusedItem) then
        FItems[FFocusedItem].Selected := True;
    end;
    VK_SPACE:
    begin
      if IsValidItem(FFocusedItem) then
        FItems[FFocusedItem].Selected := not FItems[FFocusedItem].Selected;
    end;
    VK_UP, VK_PRIOR:
    begin
      Tp := FTopItem;

      PrevItem(FTopItem, False);
      if Key = VK_PRIOR then
      begin
        PrevItem(FTopItem, False);
        PrevItem(FTopItem, False);
      end;

      DoKeyScrolling(Tp);
      if (Tp = FTopItem) and (Tp = 0) then
      begin
        NewKey := VK_LEFT;
        ProcessGroupKey(NewKey, IsKeyPress);
      end;
    end;
    VK_DOWN, VK_NEXT:
    begin
      Tp := FTopItem;

      NextItem(FTopItem, False);
      if Key = VK_NEXT then
      begin
        NextItem(FTopItem, False);
        NextItem(FTopItem, False);
      end;

      DoKeyScrolling(Tp);
      if (Tp = FTopItem) and (Tp = 0) then
      begin
        NewKey := VK_RIGHT;
        ProcessGroupKey(NewKey, IsKeyPress);
      end;
    end;
    VK_HOME, VK_END:
    begin
      Tp := FTopItem;

      if Key = VK_HOME then
        FTopItem := 0
      else
      if Key = VK_END then
        FTopItem := FItems.Count;

      DoKeyScrolling(Tp);

      if (Tp = FTopItem) and (Tp = 0) then
      begin
        Fc := FFocusedItem;

        FFocusedItem := 0;
        if Key = VK_END then
          FFocusedItem := FItems.Count;

        ValidateItemIndex(FFocusedItem);
        if Fc <> FFocusedItem then
          Invalidate;
      end;
    end;
    VK_LEFT, VK_RIGHT:
    begin
      Fc := FFocusedItem;
      Tp := FTopItem;

      if Key = VK_LEFT then
        PrevItem(FFocusedItem, True)
      else
        NextItem(FFocusedItem, True);

      if not IsItemInView(FFocusedItem, True) then
        FTopItem := FFocusedItem;

      ValidateTopItemIndex(FTopItem);
      ValidateItemIndex(FFocusedItem);

      Tp2 := FTopItem;
      if Tp <> FTopItem then
        UpdateScrollers;

      if (Tp <> FTopItem) or (Fc <> FFocusedItem) then
      begin
        Invalidate;
        if Tp2 = FTopItem then
          DoScrolled;
      end;
    end;
  end;
end;

function TSCListGroup.IsItemInView(Indx: Integer; FullView: Boolean): Boolean;
var
  R: TRect;
  I, H, TotalH,
  First, Last: Integer;
begin
  Result := False;
  if (Indx > -1) and (Indx < FItems.Count) then
  begin
    R := GetClientRect;

    AdjustClientRect(R);
    AdjustItemRect(R);

    if IsRectEmpty(R) then Exit;

    OffsetRect(R, -R.Left, -R.Top);

    First := FTopItem;
    ValidateTopItemIndex(First);

    if First < 0 then First := 0;
    if First > FItems.Count-1 then
      First := FItems.Count-1;

    if IsValidItem(First) then
    begin
      Last := First;

      TotalH := 0;
      for I := First to FItems.Count-1 do
      begin
        if not FItems[I].Visible then Continue;

        H := GetItemHeight(I, R.Right);
        if H > 0 then
        begin
          Inc(TotalH, H + FItemSpace);

          if TotalH >= R.Bottom then
          begin
            Last := I;
            if FullView and
              (Last > First) and (TotalH > R.Bottom) then
              Dec(Last);

            Break;
          end;
        end;
      end;

      Result := (Indx >= First) and (Indx <= Last);
    end;
  end;
end;

procedure TSCListGroup.DoScrolled;
begin
  if Assigned(FOnScroll) then
    FOnScroll(Self);
end;

procedure TSCListGroup.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_SPACE then
    FSpaceDown := False;

  inherited KeyUp(Key, Shift);
end;

procedure TSCListGroup.ApplyStyle(S: TSCAdvPanelStyle; DoUpdate: Boolean);
var
  I: Integer;
  IsHot: Boolean;
begin
  if S = scasCustom then Exit;

  inherited ApplyStyle(S, False);

  case S of
    scasExplorerBar:
    begin
      FButtonStyle := scbsImageEx;
      FImageStyle := scisSmall;
      FWordWrap := True;
    end;
    scasMXBar:
    begin
      FButtonStyle := scbsButtonSp;
      FImageStyle := scisSmall;
      FWordWrap := False;
    end;
    scasAdvXPBar, scasXPBar:
    begin
      FButtonStyle := scbsImageEx;
      FImageStyle := scisSmall;
      FWordWrap := False;
    end;
    scasOutlookBar,
    scasOutlookBarXP:
    begin
      FButtonStyle := scbsButtonSp;
      FImageStyle := scisLarge;
      FWordWrap := True;
    end;
    scasOutlookBar2k:
    begin
      FButtonStyle := scbsImageEx;
      FImageStyle := scisLarge;
      FWordWrap := True;
    end;
    scasOfficeXP:
    begin
      FButtonStyle := scbsButtonEx;
      FImageStyle := scisSmall;
      FWordWrap := False;
    end;
    scasTaskList:
    begin
      FButtonStyle := scbsImageEx;
      FImageStyle := scisSmall;
      FWordWrap := True;
    end;
  end;

  IsHot := FButtonStyle in [scbsNone, scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew];
  if FItems <> nil then
  begin
    FItems.BeginUpdate;
    try
      for I := 0 to FItems.Count-1 do
        with FItems[I] do
        begin
          if ExStyle.Hottrack then
            ExStyle.HotUnderline := IsHot;
        end;
    finally
      FItems.EndUpdate;
    end;
  end;

  if DoUpdate then
  begin
    Realign;
    UpdateBorderRegion;
    Invalidate;
  end;
end;

function TSCListGroup.CanIndent(Index: Integer): Boolean;
begin
  Result := IsValidItem(Index) and
    ((FImageStyle = scisSmall) or
     ((FImageStyle = scisLarge) and (FItems[Index].ViewStyle <> scvsButton)));
end;

procedure TSCListGroup.CMHintShow(var Message: TMessage);
const
  EmptyHint = '';
var
  R: TRect;
  P: TPoint;
  Indx: Integer;
  IsHot: Boolean;
begin
  inherited;

  with TCMHintShow(Message) do
  begin
    IsHot := (FHotItem > -1) or
      ((FClickedItem > -1) and (FHotClickItem > -1));

    if not FIsCaptionHot and IsHot then
    begin
      P := HintInfo.CursorPos;
      R := GetRectAndItem(P, Indx, True);

      if not IsValidItem(Indx) or
        (FItems[Indx].Hint = '') then
      begin
        R := Rect(0, 0, 0, 0);
        HintInfo.HintStr := EmptyHint;
        Result := 1;
      end else
        HintInfo.HintStr := FItems[Indx].Hint;

      HintInfo.CursorRect := R;
    end;
  end;
end;

function TSCListGroup.SharpenRect(R: TRect; I: Integer): TRect;
var
  F: TFont;
  ImgSet: Boolean;
  S: TSCListGroupStyle;
  R2, R3, TxtR: TRect;
  L, IW, IH, Img, BvSz: Integer;
  ImgList: TCustomImageList;
begin
  Result := R;
  if not IsValidItem(I) or not FItems[I].Visible then
    Exit;

  R2 := R;
  BvSz := GetBevelSize;

  if (FItems[I].ViewStyle = scvsLabel) or
    ((FImageStyle = scisSmall) and (FItems[I].ViewStyle = scvsButton) and
    (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew])) then
  begin
    InflateRect(R2, -BvSz, -BvSz);
    ImgList := GetImageList(I);

    R3 := R2;
    R3.Right := R3.Left;

    if ImgList <> nil then
    begin
      Img := GetImageIndex(I);

      if (Img > -1) and (Img < ImgList.Count) then
      begin
        IW := ImgList.Width;
        Inc(R3.Right,  IW + Spacing + BvSz);
      end;
    end;

    TxtR := R2;
    TxtR.Left := R3.Right;

    if not IsRectEmpty(TxtR) then
    begin
      S := GetItemStyle(I);

      F := Self.Font;
      if S <> nil then F := S.Font;

      DoDrawItemText(Canvas, FItems[I].Caption, F, TxtR, True, I);
      IntersectRect(TxtR, TxtR, R2);

      if not IsRectEmpty(TxtR) then
        Inc(R3.Right, TxtR.Right - TxtR.Left);
    end;

    InflateRect(R3, BvSz, 0);
    Result := R3;
  end else
  if (FImageStyle = scisLarge) and
    (FItems[I].ViewStyle = scvsButton) and
    (FButtonStyle in [scbsImage2k, scbsImageSp, scbsImageEx, scbsImageNew]) then
  begin
    ImgList := GetImageList(I);

    ImgSet := False;

    R3 := R2;
    if ImgList <> nil then
    begin
      Img := GetImageIndex(I);

      if (Img > -1) and (Img < ImgList.Count) then
      begin
        IW := ImgList.Width;
        IH := ImgList.Height;

        if (IW > 0) and (IH > 0) and (IW < R2.Right - R2.Left) then
        begin
          ImgSet := True;

          R3.Left := R3.Left + ((R3.Right - R3.Left - IW) div 2);
          R3.Right := R3.Left + IW;

          InflateRect(R3, BvSz + 2, 0);

          Inc(R3.Top, BvSz - 2);
          R3.Bottom := R3.Top + IH + Spacing + 2*BvSz;

          R2.Top := R3.Bottom;
          IntersectRect(R3, R3, R);
        end;
      end;
    end;

    TxtR := R2;
    if not IsRectEmpty(TxtR) then
    begin
      S := GetItemStyle(I);

      F := Self.Font;
      if S <> nil then F := S.Font;

      DoDrawItemText(Canvas, FItems[I].Caption, F, TxtR, True, I);
      IntersectRect(TxtR, TxtR, R2);

      if not IsRectEmpty(TxtR) then
      begin
        InflateRect(TxtR, BvSz + 2, BvSz);
        Inc(TxtR.Bottom, BvSz);

        L := R2.Left +
          ((R2.Right - R2.Left - (TxtR.Right - TxtR.Left)) div 2);

        OffsetRect(TxtR, -TxtR.Left, -TxtR.Top);
        OffsetRect(TxtR, L, R2.Top);
      end;

      IntersectRect(TxtR, TxtR, R2);
    end;

    if not ImgSet then
      R3 := TxtR
    else begin
      if TxtR.Left < R3.Left then
        R3.Left := TxtR.Left;

      if TxtR.Right > R3.Right then
        R3.Right := TxtR.Right;

      if TxtR.Top < R3.Top then
        R3.Top := TxtR.Top;

      if TxtR.Bottom > R3.Bottom then
        R3.Bottom := TxtR.Bottom;
    end;

    IntersectRect(R3, R3, R);
    Result := R3;
  end;
end;

procedure TSCListGroup.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCListGroup then
  begin
    with TSCListGroup(Source) do
    begin
      Self.AllowAllUp := AllowAllUp;
      Self.ButtonStyle := ButtonStyle;
      Self.CanMultiSelect := CanMultiSelect;
      Self.CanSelect := CanSelect;
      Self.HottrackCursor := HottrackCursor;
      Self.ImageStyle := ImageStyle;
      Self.Items := Items;
      Self.ItemSpace := ItemSpace;
      Self.LargeImages := LargeImages;
      Self.Scrollers := Scrollers;
      Self.ScrollerImages := ScrollerImages;
      Self.ShowFocusRect := ShowFocusRect;
      Self.ShowImages := ShowImages;
      Self.ShowItemHint := ShowItemHint;
      Self.SmallImages := SmallImages;
      Self.WordWrap := WordWrap;
    end;
  end;
end;

{ TSCListGroupItem }

procedure TSCListGroupItem.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  if Action is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or (Self.Caption = '') then
        Self.Caption := Caption;
      if not CheckDefaults or (Self.Selected = False) then
        Self.Selected := Checked;
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

procedure TSCListGroupItem.Assign(Source: TPersistent);
begin
  if Source is TSCListGroupItem then
  begin
    if Collection <> nil then
      Collection.BeginUpdate;

    try
      with TSCListGroupItem(Source) do
      begin
        Self.Action     := Action;
        Self.Alignment  := Alignment;
        Self.Caption    := Caption;
        Self.Color      := Color;
        Self.Enabled    := Enabled;
        Self.Hint       := Hint;
        Self.ImageIndex := ImageIndex;
        Self.Indent     := Indent;
        Self.Line       := Line;
        Self.LineColor  := LineColor;
        Self.LargeImageIndex := LargeImageIndex;
        Self.Selected   := Selected;
        Self.Style      := Style;
        Self.ViewStyle  := ViewStyle;
        Self.Visible    := Visible;
      end;
    finally
      if Collection <> nil then
        Collection.EndUpdate;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCListGroupItem.Create(Collection: TCollection);
begin
  FImageIndex := -1;
  FLargeImageIndex := -1;
  inherited Create(Collection);

  FAlignment := taLeftJustify;
  FColor := clNone;
  FEnabled := True;
  FLine := scglNone;
  FLineColor := clBlack;
  FSelected := False;
  FViewStyle := scvsButton;
  FVisible := True;

  FExStyle := TSCListGroupItemStyle.Create(Self);
  FNotifier := TSCListGroupStyleNotifier.Create(Self);
  FNotifier.OnChange := StyleChanged;
  FNotifier.OnDestroy := StyleDestroyed;
end;

destructor TSCListGroupItem.Destroy;
begin
  FDestroying := True;

  FNotifier.OnChange := nil;
  FNotifier.OnDestroy := nil;

  SetStyle(nil);

  FreeAndNil(FExStyle);
  FreeAndNil(FNotifier);
  inherited Destroy;
end;

procedure TSCListGroupItem.DoActionChange(Sender: TObject);
begin
  Changed(False);
end;

procedure TSCListGroupItem.DoChanged(FullRefresh: Boolean);
begin
  if Visible or FullRefresh then
    Changed(FullRefresh);
end;

function TSCListGroupItem.GetAction: TBasicAction;
begin
  if FActionLink <> nil then
    Result := FActionLink.Action else
    Result := nil;
end;

function TSCListGroupItem.GetActionLinkClass: TSCListGroupActionLinkClass;
begin
  Result := TSCListGroupActionLink;
end;

function TSCListGroupItem.GetDisplayName: string;
begin
  Result := FCaption;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TSCListGroupItem.GetImages: TCustomImageList;
var
  LG: TSCListGroup;
begin
  Result := nil;
  LG := GetListGroup;
  if LG <> nil then Result := LG.SmallImages;
end;

function TSCListGroupItem.GetLargeImages: TCustomImageList;
var
  LG: TSCListGroup;
begin
  Result := nil;
  LG := GetListGroup;
  if LG <> nil then Result := LG.LargeImages;
end;

function TSCListGroupItem.GetListGroup: TSCListGroup;
begin
  Result := nil;
  if (Collection <> nil) and (Collection is TSCListGroupItems) then
    Result := TSCListGroupItems(Collection).FOwner;
end;

function TSCListGroupItem.IsCaptionStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsCaptionLinked;
end;

function TSCListGroupItem.IsEnabledStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsEnabledLinked;
end;

function TSCListGroupItem.IsHintStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsHintLinked;
end;

function TSCListGroupItem.IsImageIndexStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsImageIndexLinked;
end;

function TSCListGroupItem.IsOnClickStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsOnExecuteLinked;
end;

function TSCListGroupItem.IsVisibleStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsVisibleLinked;
end;

function TSCListGroupItem.OwnerState: TComponentState;
var
  LG: TSCListGroup;
begin
  Result := [];
  LG := GetListGroup;
  if LG <> nil then Result := LG.ComponentState;
end;

procedure TSCListGroupItem.RegisterTo(S: TSCListGroupStyle);
begin
  if S <> nil then
    S.RegisterNotifier(FNotifier);
end;

procedure TSCListGroupItem.SelectionChanged;
var
  LG: TSCListGroup;
begin
  LG := GetListGroup;
  if LG <> nil then
    LG.SelectionChanged(Self);
end;

procedure TSCListGroupItem.SetAction(const Value: TBasicAction);
begin
  if Value = nil then
  begin
    FActionLink.Free;
    FActionLink := nil;
  end else
  begin
    if FActionLink = nil then
      FActionLink := GetActionLinkClass.Create(Self);

    FActionLink.Action   := Value;
    FActionLink.OnChange := DoActionChange;
    ActionChange(Value, csLoading in Value.ComponentState);
  end;
end;

procedure TSCListGroupItem.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    DoChanged(False);
  end;
end;

procedure TSCListGroupItem.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    DoChanged(False);
  end;
end;

procedure TSCListGroupItem.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    DoChanged(False);
  end;
end;

procedure TSCListGroupItem.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    DoChanged(False);
  end;
end;

procedure TSCListGroupItem.SetExStyle(Value: TSCListGroupItemStyle);
begin
  FExStyle.Assign(Value);
end;

procedure TSCListGroupItem.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    DoChanged(False);
  end;
end;

procedure TSCListGroupItem.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FIndent <> Value then
  begin
    FIndent := Value;
    DoChanged(False);
  end;
end;

procedure TSCListGroupItem.SetLargeImageIndex(Value: TImageIndex);
begin
  if FLargeImageIndex <> Value then
  begin
    FLargeImageIndex := Value;
    DoChanged(False);
  end;
end;

procedure TSCListGroupItem.SetLine(Value: TSCGroupItemLine);
begin
  if FLine <> Value then
  begin
    FLine := Value;
    if FLineColor <> clNone then
      DoChanged(False);
  end;
end;

procedure TSCListGroupItem.SetLineColor(Value: TColor);
begin
  if FLineColor <> Value then
  begin
    FLineColor := Value;
    if FLine <> scglNone then
      DoChanged(False);
  end;
end;

procedure TSCListGroupItem.SetSelected(Value: Boolean);
begin
  if Value then
     Value := FViewStyle <> scvsLabel;

  if FSelected <> Value then
  begin
    FSelected := Value;
    SelectionChanged;
  end;
end;

procedure TSCListGroupItem.SetStyle(Value: TSCListGroupStyle);
begin
  if FStyle <> Value then
  begin
    UnregisterFrom(FStyle);
    FStyle := Value;
    RegisterTo(FStyle);

    DoChanged(False);
  end;
end;

procedure TSCListGroupItem.SetViewStyle(Value: TSCGroupItemViewStyle);
begin
  if FViewStyle <> Value then
  begin
    FViewStyle := Value;
    if FViewStyle = scvsLabel then
      FSelected := False;

    DoChanged(False);
  end;
end;

procedure TSCListGroupItem.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    DoChanged(True);
  end;
end;

procedure TSCListGroupItem.StyleChanged(Sender: TObject);
begin
  DoChanged(False);
end;

procedure TSCListGroupItem.StyleDestroyed(Sender: TObject);
begin
  if Sender = FStyle then
    Style := nil;
end;

procedure TSCListGroupItem.UnregisterFrom(S: TSCListGroupStyle);
begin
  if S <> nil then
    S.UnregisterNotifier(FNotifier);
end;

{ TSCListGroupActionLink }

procedure TSCListGroupActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  FClient := AClient as TSCListGroupItem;
end;

function TSCListGroupActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and
    AnsiSameText(FClient.Caption, (Action as TCustomAction).Caption);
end;

function TSCListGroupActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and
    (FClient.Selected = (Action as TCustomAction).Checked);
end;

function TSCListGroupActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and
    (FClient.Enabled = (Action as TCustomAction).Enabled);
end;

function TSCListGroupActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and
    AnsiSameText(FClient.Hint, (Action as TCustomAction).Hint);
end;

function TSCListGroupActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and
    (FClient.ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TSCListGroupActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and
    (@FClient.OnClick = @Action.OnExecute);
end;

function TSCListGroupActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and
    (FClient.ImageIndex = (Action as TCustomAction).ImageIndex);
end;

procedure TSCListGroupActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then FClient.Caption := Value;
end;

procedure TSCListGroupActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then FClient.Selected := Value;
end;

procedure TSCListGroupActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then FClient.Enabled := Value;
end;

procedure TSCListGroupActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then FClient.Hint := Value;
end;

procedure TSCListGroupActionLink.SetImageIndex(Value: Integer);
begin
  if IsImageIndexLinked then FClient.ImageIndex := Value;
end;

procedure TSCListGroupActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then FClient.OnClick := Value;
end;

procedure TSCListGroupActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then FClient.Visible := Value;
end;

{ TSCListGroupItems }

function TSCListGroupItems.Add: TSCListGroupItem;
begin
  Result := TSCListGroupItem(inherited Add);
end;

constructor TSCListGroupItems.Create(ListGroup: TSCListGroup);
begin
  inherited Create(TSCListGroupItem);
  FOwner := ListGroup;
end;

function TSCListGroupItems.GetItem(Index: Integer): TSCListGroupItem;
begin
  Result := TSCListGroupItem(inherited GetItem(Index));
end;

function TSCListGroupItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCListGroupItems.SetItem(Index: Integer;
  Value: TSCListGroupItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCListGroupItems.Update(Item: TCollectionItem);
begin
  if Item <> nil then
    FOwner.ItemChanged(TSCListGroupItem(Item)) else
    FOwner.ItemsChanged;
end;

{ TSCListGroupStyleNotifier }

constructor TSCListGroupStyleNotifier.Create(AOwner: TObject);
begin
  inherited Create;
  FOwner := AOwner;
end;

{ TSCAdvGroupCaptionSettings }

procedure TSCAdvGroupCaptionSettings.Assign(Source: TPersistent);
begin
  //
end;

constructor TSCAdvGroupCaptionSettings.Create(AOwner: TSCCustomAdvGroup);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCAdvGroupCaptionSettings.GetButtonColors: TSCAdvGroupButtons;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.FCaptionButtonColors;
end;

function TSCAdvGroupCaptionSettings.GetCursor: TCursor;
begin
  Result := crDefault;
  if FOwner <> nil then
    Result := FOwner.FCaptionCursor;
end;

function TSCAdvGroupCaptionSettings.GetDefaultButtons: Boolean;
begin
  Result := True;
  if FOwner <> nil then
    Result := FOwner.FDefaultButtons;
end;

function TSCAdvGroupCaptionSettings.GetDefaultIcon: Boolean;
begin
  Result := True;
  if FOwner <> nil then
    Result := FOwner.FDefaultIcon;
end;

function TSCAdvGroupCaptionSettings.GetDefaultProps: TSCAdvGroupCaption;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.FCaptionProps;
end;

function TSCAdvGroupCaptionSettings.GetDisabledFontColor: TColor;
begin
  Result := clPanelDisabledColor;
  if FOwner <> nil then
    Result := FOwner.FCaptionDisabledFontColor;
end;

function TSCAdvGroupCaptionSettings.GetDisabledProps: TSCAdvGroupCaption;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.FDisabledCaptionProps;
end;

function TSCAdvGroupCaptionSettings.GetDownFontColor: TColor;
begin
  Result := clPanelDownColor;
  if FOwner <> nil then
    Result := FOwner.FCaptionDownFontColor;
end;

function TSCAdvGroupCaptionSettings.GetFont: TFont;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.FCaptionFont;
end;

function TSCAdvGroupCaptionSettings.GetHeight: Integer;
begin
  Result := -1;
  if FOwner <> nil then
    Result := FOwner.FCaptionHeight;
end;

function TSCAdvGroupCaptionSettings.GetHint: String;
begin
  Result := '';
  if FOwner <> nil then
    Result := FOwner.FCaptionHint;
end;

function TSCAdvGroupCaptionSettings.GetHotFontColor: TColor;
begin
  Result := clPanelHotColor;
  if FOwner <> nil then
    Result := FOwner.FCaptionHotFontColor;
end;

function TSCAdvGroupCaptionSettings.GetHotProps: TSCAdvGroupCaption;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.FHotCaptionProps;
end;

function TSCAdvGroupCaptionSettings.GetHottrack: Boolean;
begin
  Result := True;
  if FOwner <> nil then
    Result := FOwner.FHottrack;
end;

function TSCAdvGroupCaptionSettings.GetHottrackButtons: Boolean;
begin
  Result := True;
  if FOwner <> nil then
    Result := FOwner.FHottrackButtons;
end;

function TSCAdvGroupCaptionSettings.GetImages: TCustomImageList;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.Images;
end;

function TSCAdvGroupCaptionSettings.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCAdvGroupCaptionSettings.GetStyle: TSCGroupCaptionStyle;
begin
  Result := scgcNone;
  if FOwner <> nil then
    Result := FOwner.FCaptionStyle;
end;

procedure TSCAdvGroupCaptionSettings.SetButtonColors(Value: TSCAdvGroupButtons);
begin
  if FOwner <> nil then
    FOwner.SetCaptionButtonColors(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetCursor(Value: TCursor);
begin
  if FOwner <> nil then
    FOwner.SetCaptionCursor(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetDefaultButtons(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.SetDefaultButtons(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetDefaultIcon(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.SetDefaultIcon(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetDefaultProps(
  Value: TSCAdvGroupCaption);
begin
  if FOwner <> nil then
    FOwner.SetCaptionProps(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetDisabledFontColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.SetCaptionDisabledFontColor(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetDisabledProps(
  Value: TSCAdvGroupCaption);
begin
  if FOwner <> nil then
    FOwner.SetDisabledCaptionProps(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetDownFontColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.SetCaptionDownFontColor(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetFont(Value: TFont);
begin
  if FOwner <> nil then
    FOwner.SetCaptionFont(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetHeight(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.SetCaptionHeight(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetHint(const Value: String);
begin
  if FOwner <> nil then
    FOwner.FCaptionHint := Value;
end;

procedure TSCAdvGroupCaptionSettings.SetHotFontColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.SetCaptionHotFontColor(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetHotProps(Value: TSCAdvGroupCaption);
begin
  if FOwner <> nil then
    FOwner.SetHotCaptionProps(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetHottrack(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.SetHottrack(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetHottrackButtons(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.SetHottrackButtons(Value);
end;

procedure TSCAdvGroupCaptionSettings.SetImages(Value: TCustomImageList);
begin
  if FOwner <> nil then
    FOwner.Images := Value;
end;

procedure TSCAdvGroupCaptionSettings.SetStyle(Value: TSCGroupCaptionStyle);
begin
  if FOwner <> nil then
    FOwner.SetCaptionStyle(Value);
end;

{ TSCListGroupScroller }

procedure TSCListGroupScroller.Assign(Source: TPersistent);
begin
  if Source is TSCListGroupScroller then
  begin
    with TSCListGroupScroller(Source) do
    begin
      Self.ArrowDefault := ArrowDefault;
      Self.ArrowDisabled := ArrowDisabled;
      Self.ArrowHot := ArrowHot;
      Self.ArrowPressed := ArrowPressed;
      Self.ColorDefault := ColorDefault;
      Self.ColorDisabled := ColorDisabled;
      Self.ColorHot := ColorHot;
      Self.ColorPressed := ColorPressed;
      Self.ImageDefault := ImageDefault;
      Self.ImageDisabled := ImageDisabled;
      Self.ImageHot := ImageHot;
      Self.ImagePressed := ImagePressed;
    end;

    DoChange;
  end else
    inherited Assign(Source);
end;

constructor TSCListGroupScroller.Create(AOwner: TSCListGroupScrollers);
begin
  inherited Create;
  FOwner := AOwner;
  FArrowDefault := clBtnText;
  FArrowDisabled := clBtnShadow;
  FArrowHot := clBtnText;
  FArrowPressed := clBtnText;
  FColorDefault := clBtnFace;
  FColorDisabled := clBtnFace;
  FColorHot := clBtnFace;
  FColorPressed := clBtnFace;
  FImageDefault := -1;
  FImageDisabled := -1;
  FImageHot := -1;
  FImagePressed := -1;
end;

procedure TSCListGroupScroller.DoChange;
begin
  if FOwner <> nil then
    FOwner.DoChange(False);
end;

function TSCListGroupScroller.GetImages: TCustomImageList;
begin
  Result := nil;
  if (FOwner <> nil) and (FOwner.FOwner <> nil) then
    Result := FOwner.FOwner.ScrollerImages;
end;

procedure TSCListGroupScroller.SetArrowDefault(Value: TColor);
begin
  if FArrowDefault <> Value then
  begin
    FArrowDefault := Value;
    DoChange;
  end;
end;

procedure TSCListGroupScroller.SetArrowDisabled(Value: TColor);
begin
  if FArrowDisabled <> Value then
  begin
    FArrowDisabled := Value;
    DoChange;
  end;
end;

procedure TSCListGroupScroller.SetArrowHot(Value: TColor);
begin
  if FArrowHot <> Value then
  begin
    FArrowHot := Value;
    DoChange;
  end;
end;

procedure TSCListGroupScroller.SetArrowPressed(Value: TColor);
begin
  if FArrowPressed <> Value then
  begin
    FArrowPressed := Value;
    DoChange;
  end;
end;

procedure TSCListGroupScroller.SetColorDefault(Value: TColor);
begin
  if FColorDefault <> Value then
  begin
    FColorDefault := Value;
    DoChange;
  end;
end;

procedure TSCListGroupScroller.SetColorDisabled(Value: TColor);
begin
  if FColorDisabled <> Value then
  begin
    FColorDisabled := Value;
    DoChange;
  end;
end;

procedure TSCListGroupScroller.SetColorHot(Value: TColor);
begin
  if FColorHot <> Value then
  begin
    FColorHot := Value;
    DoChange;
  end;
end;

procedure TSCListGroupScroller.SetColorPressed(Value: TColor);
begin
  if FColorPressed <> Value then
  begin
    FColorPressed := Value;
    DoChange;
  end;
end;

procedure TSCListGroupScroller.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    DoChange;
  end;
end;

procedure TSCListGroupScroller.SetImageDefault(Value: TImageIndex);
begin
  if FImageDefault <> Value then
  begin
    FImageDefault := Value;
    DoChange;
  end;
end;

procedure TSCListGroupScroller.SetImageDisabled(Value: TImageIndex);
begin
  if FImageDisabled <> Value then
  begin
    FImageDisabled := Value;
    DoChange;
  end;
end;

procedure TSCListGroupScroller.SetImageHot(Value: TImageIndex);
begin
  if FImageHot <> Value then
  begin
    FImageHot := Value;
    DoChange;
  end;
end;

procedure TSCListGroupScroller.SetImagePressed(Value: TImageIndex);
begin
  if FImagePressed <> Value then
  begin
    FImagePressed := Value;
    DoChange;
  end;
end;

{ TSCListGroupScrollers }

constructor TSCListGroupScrollers.Create(AOwner: TSCListGroup);
begin
  inherited Create;
  FOwner := AOwner;
  FDownScroller := TSCListGroupScroller.Create(Self);
  FUpScroller := TSCListGroupScroller.Create(Self);
end;

destructor TSCListGroupScrollers.Destroy;
begin
  FreeAndNil(FDownScroller);
  FreeAndNil(FUpScroller);
  inherited Destroy;
end;

procedure TSCListGroupScrollers.DoChange(VisibleChange: Boolean);
begin
  if (FOwner <> nil) and (FVisible or VisibleChange) then
    FOwner.GroupScrollerChanged(Self, VisibleChange);
end;

procedure TSCListGroupScrollers.DownEnabled(Value: Boolean);
begin
  FDownScroller.Enabled := Value;
end;

procedure TSCListGroupScrollers.SetDownScroller(Value: TSCListGroupScroller);
begin
  FDownScroller.Assign(Value);
end;

procedure TSCListGroupScrollers.SetUpScroller(Value: TSCListGroupScroller);
begin
  FUpScroller.Assign(Value);
end;

procedure TSCListGroupScrollers.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    DoChange(True);
  end;
end;

procedure TSCListGroupScrollers.UpEnabled(Value: Boolean);
begin
  FUpScroller.Enabled := Value;
end;

{ TSCListGroupItemStyle }

procedure TSCListGroupItemStyle.Assign(Source: TPersistent);
var
  C: TCollection;
begin
  if Source is TSCListGroupItemStyle then
  begin
    C := nil;
    if FOwner <> nil then
      C := FOwner.Collection;

    if C <> nil then C.BeginUpdate;
    try
      with TSCListGroupItemStyle(Source) do
      begin
        Self.DisabledColor := DisabledColor;
        Self.DisabledFontColor := DisabledFontColor;
        Self.Hottrack := Hottrack;
        Self.HotColor := HotColor;
        Self.HotFontColor := HotFontColor;
        Self.HotUnderline := HotUnderline;
      end;
    finally
      if C <> nil then C.EndUpdate;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCListGroupItemStyle.Create(AOwner: TSCListGroupItem);
begin
  inherited Create;
  FOwner := AOwner;

  FDisabledColor := clNone;
  FDisabledFontColor := clNone;
  FHotColor := clNone;
  FHotFontColor := clBlue;
  FHottrack := True;
  FHotUnderline := True;
end;

procedure TSCListGroupItemStyle.DoChange;
begin
  if FOwner <> nil then
    FOwner.DoChanged(False);
end;

procedure TSCListGroupItemStyle.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    if (FOwner <> nil) and not FOwner.Enabled then
      DoChange;
  end;
end;

procedure TSCListGroupItemStyle.SetDisabledFontColor(Value: TColor);
begin
  if FDisabledFontColor <> Value then
  begin
    FDisabledFontColor := Value;
    if (FOwner <> nil) and not FOwner.Enabled then
      DoChange;
  end;
end;

procedure TSCListGroupItemStyle.SetHotColor(Value: TColor);
begin
  if FHotColor <> Value then
  begin
    FHotColor := Value;
    if FHottrack and (FOwner <> nil) and FOwner.Enabled then
      DoChange;
  end;
end;

procedure TSCListGroupItemStyle.SetHotFontColor(Value: TColor);
begin
  if FHotFontColor <> Value then
  begin
    FHotFontColor := Value;
    if FHottrack and (FOwner <> nil) and FOwner.Enabled then
      DoChange;
  end;
end;

procedure TSCListGroupItemStyle.SetHottrack(Value: Boolean);
begin
  if FHottrack <> Value then
  begin
    FHottrack := Value;
    if (FOwner <> nil) and FOwner.Enabled then
      DoChange;
  end;
end;

procedure TSCListGroupItemStyle.SetHotUnderline(Value: Boolean);
begin
  if FHotUnderline <> Value then
  begin
    FHotUnderline := Value;
    if FHottrack and (FOwner <> nil) and FOwner.Enabled then
      DoChange;
  end;
end;

{ TSCListGroupStyleEx }

procedure TSCListGroupStyleEx.Assign(Source: TPersistent);
begin
  if Source is TSCListGroupStyleEx then
  begin
    if FOwner <> nil then
      FOwner.BeginUpdate;

    try
      with TSCListGroupStyleEx(Source) do
      begin
        Self.DisabledColor := DisabledColor;
        Self.DisabledFontColor := DisabledFontColor;
        Self.Hottrack := Hottrack;
        Self.HotColor := HotColor;
        Self.HotFontColor := HotFontColor;
        Self.HotUnderline := HotUnderline;
      end;
    finally
      if FOwner <> nil then
        FOwner.EndUpdate;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCListGroupStyleEx.Create(AOwner: TSCListGroupStyle);
begin
  inherited Create;

  FDisabledColor := clNone;
  FDisabledFontColor := clNone;
  FHotColor := clNone;
  FHotFontColor := clBlue;
  FHotUnderline := True;
  FHottrack := True;
end;

procedure TSCListGroupStyleEx.DoChange;
begin
  if FOwner <> nil then
    FOwner.Changed(FOwner);
end;

procedure TSCListGroupStyleEx.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    DoChange;
  end;
end;

procedure TSCListGroupStyleEx.SetDisabledFontColor(Value: TColor);
begin
  if FDisabledFontColor <> Value then
  begin
    FDisabledFontColor := Value;
    DoChange;
  end;
end;

procedure TSCListGroupStyleEx.SetHotColor(Value: TColor);
begin
  if FHotColor <> Value then
  begin
    FHotColor := Value;
    if FHottrack then
      DoChange;
  end;
end;

procedure TSCListGroupStyleEx.SetHotFontColor(Value: TColor);
begin
  if FHotFontColor <> Value then
  begin
    FHotFontColor := Value;
    if FHottrack then
      DoChange;
  end;
end;

procedure TSCListGroupStyleEx.SetHottrack(Value: Boolean);
begin
  if FHottrack <> Value then
  begin
    FHottrack := Value;
    DoChange;
  end;
end;

procedure TSCListGroupStyleEx.SetHotUnderline(Value: Boolean);
begin
  if FHotUnderline <> Value then
  begin
    FHotUnderline := Value;
    if FHottrack then
      DoChange;
  end;
end;

{ TSCGroupContainerScrollbar }

procedure TSCGroupContainerScrollbar.Assign(Source: TPersistent);
begin
  if Source is TSCGroupContainerScrollbar then
    with TSCGroupContainerScrollbar(Source) do
    begin
      Self.Width := Width;
      Self.Style := Style;
      Self.ButtonsLayout := ButtonsLayout;
      Self.ThumbLines := ThumbLines;
      Self.ScrollbarType := ScrollbarType;
      Self.ShowState := ShowState;
    end;

  inherited Assign(Source);
end;

function TSCGroupContainerScrollbar.GetButtonsLayout: TSCScrollButtonLayout;
begin
  Result := scsbDefault;
  if (Owner <> nil) and (Owner is TSCGroupContainer) then
    Result := TSCGroupContainer(Owner).ScrollButtonsLayout;
end;

function TSCGroupContainerScrollbar.GetShowState: TSCGroupScrollBarView;
begin
  Result := scsbShow;
  if (Owner <> nil) and (Owner is TSCGroupContainer) then
    Result := TSCGroupContainer(Owner).ScrollbarView;
end;

function TSCGroupContainerScrollbar.GetStyle: TSCScrollbarStyle;
begin
  Result := scssDefault;
  if (Owner <> nil) and (Owner is TSCGroupContainer) then
    Result := TSCGroupContainer(Owner).ScrollbarStyle;
end;

function TSCGroupContainerScrollbar.GetThumbLines: TSCScrollThumbline;
begin
  Result := sctlNone;
  if (Owner <> nil) and (Owner is TSCGroupContainer) then
    Result := TSCGroupContainer(Owner).ScrollbarThumbLines;
end;

function TSCGroupContainerScrollbar.GetType: TSCScrollbarType;
begin
  Result := scsbtSweet;
  if (Owner <> nil) and (Owner is TSCGroupContainer) then
    Result := TSCGroupContainer(Owner).ScrollbarType;
end;

function TSCGroupContainerScrollbar.GetWidth: Integer;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCGroupContainer) then
    Result := TSCGroupContainer(Owner).ScrollbarHeight;
end;

procedure TSCGroupContainerScrollbar.SetButtonsLayout(
  Value: TSCScrollButtonLayout);
begin
  if (Owner <> nil) and (Owner is TSCGroupContainer) then
    TSCGroupContainer(Owner).ScrollButtonsLayout := Value;
end;

procedure TSCGroupContainerScrollbar.SetShowState(
  Value: TSCGroupScrollBarView);
begin
  if (Owner <> nil) and (Owner is TSCGroupContainer) then
    TSCGroupContainer(Owner).ScrollbarView := Value;
end;

procedure TSCGroupContainerScrollbar.SetStyle(Value: TSCScrollbarStyle);
begin
  if (Owner <> nil) and (Owner is TSCGroupContainer) then
    TSCGroupContainer(Owner).ScrollbarStyle := Value;
end;

procedure TSCGroupContainerScrollbar.SetThumbLines(Value: TSCScrollThumbline);
begin
  if (Owner <> nil) and (Owner is TSCGroupContainer) then
    TSCGroupContainer(Owner).ScrollbarThumbLines := Value;
end;

procedure TSCGroupContainerScrollbar.SetType(Value: TSCScrollbarType);
begin
  if (Owner <> nil) and (Owner is TSCGroupContainer) then
    TSCGroupContainer(Owner).ScrollbarType := Value;
end;

procedure TSCGroupContainerScrollbar.SetWidth(Value: Integer);
begin
  if (Owner <> nil) and (Owner is TSCGroupContainer) then
    TSCGroupContainer(Owner).ScrollbarHeight := Value;
end;

{ TSCGroupBorderProps }

constructor TSCGroupBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccbLowered;
end;

{$I SCVerRec.inc}

end.
