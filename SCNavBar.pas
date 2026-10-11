{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCNavBar;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ImgList, {$IFDEF SC_DELPHI6_UP} Variants, Types, {$ENDIF}
  SCCommon, SCConsts, SCControl, SCGradient;

type
  TSCNavBarOption = (scnboShowCloseButton, scnboShowMenuButton,
    scnboShowHeader, scnboShowSplitter, scnboUseBarColors,
    scnboUseGradientHeader);

  TSCNavBarOptions = set of TSCNavBarOption;

const
  SC_DefaultNavBarOptions = [scnboShowHeader, scnboShowMenuButton,
    scnboShowSplitter, scnboUseGradientHeader];

type
  TSCNavBarData = class;
  TSCCustomNavControl = class;
  TSCCustomNavPanel = class;

  TSCNavBarStyle = (scnbOfficeXP, scnbOffice11, scnbOffice12);

  TSCNavBarPart = (scnpNowhere, scnpHeader, scnpClient, scnpCloseButton,
    scnpIcon, scnpIconBar, scnpMenuButton, scnpNavBar, scnpSplitter);

  TSCNavBarParts = set of TSCNavBarPart;

  TSCNavBarHitInfo = record
    X: Integer;
    Y: Integer;
    Index: Integer;
    Part: TSCNavBarPart;
    Clicked: Boolean;
    IsLeftBtn: Boolean;
  end;
  PSCNavBarHitInfo = ^TSCNavBarHitInfo;

  // events
  TSCNavBarAllowEvent = procedure(Sender: TObject; var AllowClose: Boolean) of object;
  TSCNavBarChangingEvent = procedure(Sender: TObject; NewIndex: Integer;
    var AllowChange: Boolean) of object;

  TSCNavBarHottrackEvent = procedure (Sender: TObject; AHotInfo: TSCNavBarHitInfo;
    var ACursor: TCursor) of object;

  TSCNavBarPaintButtonEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; ADown, AHot: Boolean; var ABackColor: TColor;
    var AForeColor: TColor; var Handled: Boolean) of object;

  TSCNavBarPaintBarEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; ADown, AHot, AActive, AExpanded: Boolean; AFont: TFont;
    var AColor: TColor; var AImage: Integer; var AText: string;
    var Handled: Boolean) of object;

  TSCNavBarPaintHeaderEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; AFont: TFont; var AColor: TColor; var AText: string;
    var Handled: Boolean) of object;

  TSCNavBarPaintIconEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; ADown, AHot, AActive: Boolean; var AColor: TColor;
    var AImage: Integer; var Handled: Boolean) of object;

  TSCNavBarPaintIconBarEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; var AColor: TColor; var Handled: Boolean) of object;

  TSCNavBarPaintSplitterEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; var AColor: TColor; var Handled: Boolean) of object;

  TSCNavBarData = class(TPersistent)
  private
    FCaption: String;
    FColor: TColor;
    FEnabled: Boolean;
    FFontColor: TColor;
    FHint: String;
    FImageIndex: TImageIndex;
    FLargeImageIndex: TImageIndex;
    FVisible: Boolean;
    FTag: Longint;
    FBarItem: TObject;
    FIndex: Integer;
    FUseSmallImages: Boolean;
  protected
    property Index: Integer read FIndex write FIndex;
    property BarItem: TObject read FBarItem write FBarItem;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;

    property Caption: String read FCaption write FCaption;
    property Color: TColor read FColor write FColor;
    property Enabled: Boolean read FEnabled write FEnabled;
    property FontColor: TColor read FFontColor write FFontColor;
    property Hint: String read FHint write FHint;
    property ImageIndex: TImageIndex read FImageIndex write FImageIndex;
    property LargeImageIndex: TImageIndex read FLargeImageIndex write FLargeImageIndex;
    property Tag: Longint read FTag write FTag;
    property UseSmallImages: Boolean read FUseSmallImages write FUseSmallImages;
    property Visible: Boolean read FVisible write FVisible;
  end;

  TSCNavBarDataList = class(TObject)
  private
    FList: TList;
    function Get(Index: Integer): TSCNavBarData;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function  Count: Integer;
    function  Add: TSCNavBarData;
    procedure Delete(Index: Integer);
    function  IndexOf(AData: TSCNavBarData): Integer;

    property Items[Index: Integer]: TSCNavBarData read Get; default;
  end;

  TSCNavBarColors = class(TPersistent)
  private
    FBarColor: TColor;
    FBarTextColor: TColor;
    FButtonIconColor: TColor;
    FFrameColor: TColor;
    FHeaderColor: TColor;
    FHighlightColor: TColor;
    FHighlightTextColor: TColor;
    FSplitterColor: TColor;
    FOwner: TSCCustomNavControl;
    procedure SetBarColor(Value: TColor);
    procedure SetBarTextColor(Value: TColor);
    procedure SetButtonIconColor(Value: TColor);
    procedure SetFrameColor(Value: TColor);
    procedure SetHeaderColor(Value: TColor);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHighlightTextColor(Value: TColor);
    procedure SetSplitterColor(Value: TColor);
  protected
    procedure DoChange;
    function  GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TSCCustomNavControl); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property BarColor: TColor read FBarColor write SetBarColor default clBtnFace;
    property BarTextColor: TColor read FBarTextColor write SetBarTextColor default clBtnText;
    property ButtonIconColor: TColor read FButtonIconColor write SetButtonIconColor default clBtnText;
    property FrameColor: TColor read FFrameColor write SetFrameColor default clBtnShadow;
    property HeaderColor: TColor read FHeaderColor write SetHeaderColor default clBtnFace;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default $003FABFF;
    property HighlightTextColor: TColor read FHighlightTextColor write SetHighlightTextColor default clBtnText;
    property SplitterColor: TColor read FSplitterColor write SetSplitterColor default clBtnShadow;
  end;

  TSCNavBackGradient = class(TSCGradientPainter)
  private
    FOwner: TSCCustomNavControl;
  protected
    function  GetColorBegin: TColor; override;
    procedure SetColorBegin(Value: TColor); override;
    function  IsColorBeginSaved: Boolean; override;
  public
    constructor Create(AOwner: TSCCustomNavControl); virtual;
  published
    property Style default scdgsNone;
  end;

  TSCNavBarBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccbFlat;
    property Color;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCCustomNavControl = class(TSCCustomControl)
  private
    FAlignment: TLeftRight;
    FBarHeight: Integer;
    FImageSpacing: Integer;
    FGradient: TSCNavBackGradient;
    FGradientPainter: TSCGradientPainter;
    FStyle: TSCNavBarStyle;
    FColors: TSCNavBarColors;
    FBarIndex: Integer;
    FDataList: TSCNavBarDataList;
    FHitInfo: TSCNavBarHitInfo;
    FHottrackInfo: TSCNavBarHitInfo;
    FSplitterDownPos: Integer;
    FBarFont: TFont;
    FHeaderFont: TFont;
    FLargeImages: TCustomImageList;
    FLargeImgChangeLink: TChangeLink;
    FBufferUpdate: Integer;
    FPaintBuffer: TBitmap;
    FDesignChange: Boolean;
    FOptions: TSCNavBarOptions;
    FOptionsMenu: TPopupMenu;
    FCurrVisibleBars: Integer;
    FVisibleBarCount: Integer;
    FControlLoaded: Boolean;
    FDefaultBarHeight: Integer;
    FDefaultHeaderHeight: Integer;
    FDefaultIndex: Integer;
    FCursorChange: Boolean;
    FDefaultCursor: TCursor;
    FOnBarClick: TNotifyEvent;
    FOnBarChange: TNotifyEvent;
    FOnBarChanging: TSCNavBarChangingEvent;
    FOnBarClose: TSCNavBarAllowEvent;
    FOnCustomDrawBar: TSCNavBarPaintBarEvent;
    FOnCustomDrawCloseButton: TSCNavBarPaintButtonEvent;
    FOnCustomDrawHeader: TSCNavBarPaintHeaderEvent;
    FOnCustomDrawIcon: TSCNavBarPaintIconEvent;
    FOnCustomDrawIconBar: TSCNavBarPaintIconBarEvent;
    FOnCustomDrawMenuButton: TSCNavBarPaintButtonEvent;
    FOnCustomDrawSplitter: TSCNavBarPaintSplitterEvent;
    FOnShowMenu: TSCNavBarAllowEvent;
    procedure SetAlignment(Value: TLeftRight);
    procedure SetBarFont(Value: TFont);
    procedure SetBarHeight(Value: Integer);
    procedure SetBarIndex(Value: Integer);
    procedure SetColors(Value: TSCNavBarColors);
    procedure SetGradient(Value: TSCNavBackGradient);
    procedure SetHeaderFont(Value: TFont);
    procedure SetImageSpacing(Value: Integer);
    procedure SetLargeImages(Value: TCustomImageList);
    procedure SetOptions(Value: TSCNavBarOptions);
    procedure SetOptionsMenu(Value: TPopupMenu);
    procedure SetStyle(Value: TSCNavBarStyle);
    procedure SetVisibleBarCount(Value: Integer);

    procedure ColorsChanged;
    procedure BarIndexChanged;

    procedure MenuClick;
    procedure CloseClick;
    procedure SizeSplitterMove;

    procedure ChangeCursor(ACursor: TCursor);

    procedure DrawGradientBack(ACanvas: TCanvas);
    procedure DrawBars(ACanvas: TCanvas);
    procedure DrawBar(ACanvas: TCanvas; AData: TSCNavBarData);
    procedure DrawHeader(ACanvas: TCanvas);
    procedure DrawSplitter(ACanvas: TCanvas);
    procedure DrawIconBar(ACanvas: TCanvas);
    procedure DrawCloseButton(ACanvas: TCanvas);
    procedure DrawMenuButton(ACanvas: TCanvas);
    procedure DrawButtonFace(ACanvas: TCanvas; ARect: TRect;
      AColor: TColor; IsDown, IsHot, IsActive: Boolean);

    procedure ReadActiveData(Reader: TReader);
    procedure WriteActiveData(Writer: TWriter);
    procedure ReadVisibleData(Reader: TReader);
    procedure WriteVisibleData(Writer: TWriter);

    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMCursorChanged(var Message: TMessage); message CM_CURSORCHANGED;
    procedure CNChar(var Message: TWMChar); message CN_CHAR;

    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure Loaded; override;
    procedure CreateWnd; override;
    procedure Paint; override;

    procedure StopTracking; override;
    procedure CancelSplitterMove;

    procedure UpdateHottrackInfo;
    procedure CheckMouseUpdate(OldHot: TSCNavBarHitInfo);
    procedure CheckCursorUpdate(AHitInfo: TSCNavBarHitInfo);

    procedure UpdateDesigner;
    procedure AdjustClientRect(var ARect: TRect); override;

    function  GetDefaultBackColor: TColor; override;
    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetLargeImages: TCustomImageList; virtual;

    function  IsShowCloseButton: Boolean;virtual;
    function  IsShowHeader: Boolean;virtual;
    function  IsShowMenuButton: Boolean; virtual;
    function  IsShowSplitter: Boolean;virtual;
    function  IsUseBarColors: Boolean;virtual;
    function  IsUseGradientHeader: Boolean; virtual;

    function  GetCurrVisibleCount: Integer; virtual;
    function  GetBarCount: Integer; virtual;
    function  GetVisibleBarCount: Integer; virtual;
    function  GetVisibleIndexOf(AData: TSCNavBarData): Integer; virtual;
    function  IsShowingCaption(AData: TSCNavBarData): Boolean; virtual;

    function  GetHeaderHeight: Integer; virtual;
    function  GetSplitterHeight: Integer; virtual;
    function  GetBorderIndent: Integer; virtual;
    function  GetMinBarHeight: Integer; virtual;
    function  GetVisibleBarsHeight: Integer;
    function  GetBarHeight: Integer; overload; virtual;
    function  GetBarHeight(AIndex: Integer): Integer; overload; virtual; 

    function  CanClose: Boolean; dynamic;
    function  CanShowMenu: Boolean; dynamic;
    procedure Changing(NewIndex: Integer; var Allowed: Boolean); virtual;

    function  GetCardRect: TRect; virtual;
    procedure GradientChanged(Sender: TObject); virtual;

    procedure DestroyActiveNavBar; virtual;
    procedure ActiveNavBarMoved(Index: Integer); virtual;

    procedure UpdateBuffer(Repaint: Boolean = True);
    function  GetDataList: TSCNavBarDataList; virtual;

    procedure InitializeHitTest(AHitInfo: PSCNavBarHitInfo);

    procedure BarFontChanged(Sender: TObject); virtual;
    procedure HeaderFontChanged(Sender: TObject); virtual;

    function  GetFrameColor: TColor; virtual;
    function  GetIconBarColor: TColor; virtual;
    function  GetSplitterColor: TColor; virtual;
    function  GetHeaderColor: TColor; virtual;
    function  GetBarColor(AData: TSCNavBarData): TColor; virtual;
    function  GetBarTextColor(AData: TSCNavBarData): TColor; virtual;
    function  GetButtonColor(IsHot, IsDown, IsActive: Boolean): TColor; virtual;
    function  GetButtonTextColor(IsHot, IsDown, IsActive: Boolean): TColor; virtual;

    procedure DoDrawBar(ACanvas: TCanvas; AData: TSCNavBarData;
      ARect: TRect; ADown, AHot, AActive, AExpanded: Boolean; AFont: TFont;
      var AColor: TColor; var AImage: Integer; var AText: string;
      var Handled: Boolean); virtual;
    procedure DoDrawHeader(ACanvas: TCanvas; ARect: TRect;
      AFont: TFont; var AColor: TColor; var AText: string;
      var Handled: Boolean); virtual;
    procedure DoDrawSplitter(ACanvas: TCanvas; ARect: TRect;
      var AColor: TColor; var Handled: Boolean); virtual;
    procedure DoDrawIcon(ACanvas: TCanvas; ARect: TRect;
      ADown, AHot, AActive: Boolean; var AColor: TColor;
      var AImage: Integer; var Handled: Boolean); virtual;
    procedure DoDrawIconBar(ACanvas: TCanvas; ARect: TRect;
      var AColor: TColor; var Handled: Boolean); virtual;
    procedure DoDrawCloseButton(ACanvas: TCanvas;
      ARect: TRect; ADown, AHot: Boolean; var ABackColor: TColor;
      var AForeColor: TColor; var Handled: Boolean); virtual;
    procedure DoDrawMenuButton(ACanvas: TCanvas;
      ARect: TRect; ADown, AHot: Boolean; var ABackColor: TColor;
      var AForeColor: TColor; var Handled: Boolean); virtual;

    function  GetGradientShadow(AColor: TColor): TColor;
    function  GetGradientDark(AColor: TColor): TColor;
    function  GetGradientLight(AColor: TColor): TColor;
    function  GetGradientExLight(AColor: TColor): TColor;
    function  GetGradientPeal(AColor: TColor): TColor;
    function  GetGradientPreLight(AColor: TColor): TColor;

    function  GetNavBarImage(AData: TSCNavBarData): TImageIndex; virtual;

    procedure SetIndent(Value: Integer); override;
    procedure IndentChanged; override;
    procedure ImageListChange(Sender: TObject); override;

    procedure DoColorsChanged; virtual;
    procedure DoBarIndexChanged; virtual;
    procedure DoOptionsChanged; dynamic;

    procedure UpdateNavBars(Realign: Boolean = False);
    procedure StoreCalcValues;
    procedure FillDataList; virtual;

    procedure DoCloseClick; virtual;
    function  DoMenuClick: Boolean; virtual;
    procedure BarClick; virtual;

    function  GetActiveIndex: Integer; dynamic;
    function  CheckVisible(Index: Integer): Integer;
    function  IsBarVisible(AData: TSCNavBarData): Boolean; virtual;

    function  GetFirstVisibleNavBar: Integer; dynamic;
    function  GetLastVisibleNavBar: Integer; dynamic;

    function  GetSplitterRect: TRect; virtual;
    function  GetIconBarRect: TRect; virtual;
    function  GetHeaderRect: TRect; virtual;
    function  GetCloseButtonRect: TRect; virtual;
    function  GetMenuButtonRect: TRect; virtual;
    function  GetBarRect(Index: Integer): TRect; overload; virtual;
    function  GetBarRect(AData: TSCNavBarData): TRect; overload; virtual;

    function  GetOptionsMenu: TPopupMenu; dynamic;
    function  GetHitInfo(const P: TPoint): TSCNavBarHitInfo; virtual;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property CardRect: TRect read GetCardRect;
    property DataList: TSCNavBarDataList read GetDataList;
    property ControlLoaded: Boolean read FControlLoaded;
    property Alignment: TLeftRight read FAlignment write SetAlignment default taLeftJustify;
    property BarCount: Integer read GetBarCount;
    property BarFont: TFont read FBarFont write SetBarFont;
    property BarHeight: Integer read FBarHeight write SetBarHeight default 32;
    property BarIndex: Integer read FBarIndex write SetBarIndex default -1;
    property Colors: TSCNavBarColors read FColors write SetColors;
    property Gradient: TSCNavBackGradient read FGradient write SetGradient;
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property ImageSpacing: Integer read FImageSpacing write SetImageSpacing default 2;
    property LargeImages: TCustomImageList read FLargeImages write SetLargeImages;
    property Options: TSCNavBarOptions read FOptions write SetOptions default SC_DefaultNavBarOptions;
    property OptionsMenu: TPopupMenu read FOptionsMenu write SetOptionsMenu;
    property Style: TSCNavBarStyle read FStyle write SetStyle default scnbOfficeXP;
    property VisibleBarCount: Integer read FVisibleBarCount write SetVisibleBarCount default 5;

    property OnBarClick: TNotifyEvent read FOnBarClick write FOnBarClick;
    property OnBarChange: TNotifyEvent read FOnBarChange write FOnBarChange;
    property OnBarChanging: TSCNavBarChangingEvent read FOnBarChanging write FOnBarChanging;
    property OnBarClose: TSCNavBarAllowEvent read FOnBarClose write FOnBarClose;
    property OnCustomDrawBar: TSCNavBarPaintBarEvent read FOnCustomDrawBar write FOnCustomDrawBar;
    property OnCustomDrawCloseButton: TSCNavBarPaintButtonEvent read FOnCustomDrawCloseButton
      write FOnCustomDrawCloseButton;
    property OnCustomDrawHeader: TSCNavBarPaintHeaderEvent read FOnCustomDrawHeader
      write FOnCustomDrawHeader;
    property OnCustomDrawIcon: TSCNavBarPaintIconEvent read FOnCustomDrawIcon
      write FOnCustomDrawIcon;
    property OnCustomDrawIconBar: TSCNavBarPaintIconBarEvent read FOnCustomDrawIconBar
      write FOnCustomDrawIconBar;
    property OnCustomDrawMenuButton: TSCNavBarPaintButtonEvent read FOnCustomDrawMenuButton
      write FOnCustomDrawMenuButton;
    property OnCustomDrawSplitter: TSCNavBarPaintSplitterEvent read FOnCustomDrawSplitter
      write FOnCustomDrawSplitter;
    property OnShowMenu: TSCNavBarAllowEvent read FOnShowMenu write FOnShowMenu;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function  BarAtPos(const P: TPoint): Integer;
    procedure CloseActiveNavBar;

    procedure HideAllBars; virtual;
    procedure ShowAllBars; virtual;

    procedure ShowMoreButtons;
    procedure ShowLessButtons;

    property Color default clWindow;
    property ParentColor default False;
  end;

  TSCNavTabItem = class(TCollectionItem)
  private
    FCaption: string;
    FColor: TColor;
    FEnabled: Boolean;
    FFontColor: TColor;
    FHint: string;
    FImageIndex: TImageIndex;
    FLargeImageIndex: TImageIndex;
    FTag: Longint;
    FUseSmallImages: Boolean;
    FVisible: Boolean;
    FData: TObject;
    procedure SetCaption(const Value: String);
    procedure SetColor(Value: TColor);
    procedure SetEnabled(Value: Boolean);
    procedure SetFontColor(Value: TColor);
    procedure SetHint(const Value: String);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetLargeImageIndex(Value: TImageIndex);
    procedure SetUseSmallImages(Value: Boolean);
    procedure SetVisible(Value: Boolean);
  protected
    function GetDisplayName: string; override;
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;

    property Data: TObject read FData write FData;
  published
    property Caption: String read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property FontColor: TColor read FFontColor write SetFontColor default clNone;
    property Hint: String read FHint write SetHint;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property LargeImageIndex: TImageIndex read FLargeImageIndex write SetLargeImageIndex default -1;
    property Tag: Longint read FTag write FTag default 0;
    property UseSmallImages: Boolean read FUseSmallImages write SetUseSmallImages default False;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TSCCustomNavTabControl = class;

  TSCNavTabItems = class(TCollection)
  private
    FOwner: TSCCustomNavTabControl;
    function  GetItem(Index: Integer): TSCNavTabItem;
    procedure SetItem(Index: Integer; Value: TSCNavTabItem);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TSCCustomNavTabControl); virtual;

    procedure Clear;
    function  Add: TSCNavTabItem;
    procedure Delete(Index: Integer);
    procedure Move(CurIndex, NewIndex: Integer);
    function  IndexOf(ATab: TSCNavTabItem): Integer;

    property Items[Index: Integer]: TSCNavTabItem read GetItem write SetItem; default;
  end;

  TSCCustomNavTabControl = class(TSCCustomNavControl)
  private
    FTabs: TSCNavTabItems;
    procedure SetTabs(Value: TSCNavTabItems);
    function  GetTabIndex: Integer;
    procedure SetTabIndex(Value: Integer);
  protected
    procedure FillDataList; override;

    function  GetFirstVisibleNavBar: Integer; override;
    function  GetLastVisibleNavBar: Integer; override;

    function  IsBarVisible(AData: TSCNavBarData): Boolean; override;
    function  IsTabVisible(ATab: TSCNavTabItem): Boolean; virtual;

    function  GetBarCount: Integer; override;
    function  GetVisibleBarCount: Integer; override;
    function  IsTabShowingCaption(ATab: TSCNavTabItem): Boolean;

    function  GetActiveIndex: Integer; override;
    procedure DoCloseClick; override;

    property Tabs: TSCNavTabItems read FTabs write SetTabs;
    property TabIndex: Integer read GetTabIndex write SetTabIndex default -1;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure HideAllBars; override;
    procedure ShowAllBars; override;

    property TabCount: Integer read GetBarCount;
  end;

  TSCNavTabControl = class(TSCCustomNavTabControl)
  published
    property Align;
    property Alignment;
    property Anchors;
    property BarFont;
    property BarHeight;
    property BorderProps;
    property ClickFocus;
    property Color;
    property Colors;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Gradient;
    property HeaderFont;
    property Images;
    property ImageSpacing;
    property Indent;
    property LargeImages;
    property Options;
    property OptionsMenu;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property ParentShowHint;
    property ShowHint;
    property Style;
    property TabIndex;
    property Tabs;
    property TabOrder;
    property TabStop;
    property Visible;
    property VisibleBarCount;
    property OnBarClick;
    property OnBarClose;
    property OnBarChange;
    property OnBarChanging;
    property OnClick;
    property OnCustomDrawBar;
    property OnCustomDrawCloseButton;
    property OnCustomDrawHeader;
    property OnCustomDrawIcon;
    property OnCustomDrawIconBar;
    property OnCustomDrawMenuButton;
    property OnCustomDrawSplitter;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
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
    property OnShowMenu;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TSCCustomNavBarControl = class;

  TSCNavBarSheet = class(TSCCustomControl)
  private
    FBarEnabled: Boolean;
    FBarVisible: Boolean;
    FFontColor: TColor;
    FImageIndex: TImageIndex;
    FLargeImageIndex: TImageIndex;
    FUseSmallImages: Boolean;
    FData: Pointer;
    FNavBarRect: TRect;
    FNavBarControl: TSCCustomNavBarControl;

    procedure Changed;
    procedure InternalSetVisible(Value: Boolean);

    function  GetBarIndex: Integer;
    procedure SetBarIndex(Value: Integer);
    procedure SetBarEnabled(Value: Boolean);
    procedure SetBarVisible(Value: Boolean);
    function  GetColor: TColor;
    procedure SetColor(Value: TColor);
    procedure SetFontColor(Value: TColor);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetLargeImageIndex(Value: TImageIndex);
    procedure SetNavBarControl(ANavBarControl: TSCCustomNavBarControl);
    procedure SetUseSmallImages(Value: Boolean);
    function  GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    procedure SetNavBarRect(Value: TRect);

    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure CreateParams(var Params: TCreateParams); override;

    procedure Paint; override;
    procedure ReadState(Reader: TReader); override;
    function  GetImages: TCustomImageList; override;

    function  GetDefaultBackColor: TColor; override;

    property NavBarRect: TRect read FNavBarRect write SetNavBarRect;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Data: Pointer read FData write FData;
    property Visible: Boolean read GetVisible write SetVisible;
    property NavBarControl: TSCCustomNavBarControl read FNavBarControl write SetNavBarControl;
  published
    property BarIndex: Integer read GetBarIndex write SetBarIndex stored False;
    property BarEnabled: Boolean read FBarEnabled write SetBarEnabled default True;
    property BarVisible: Boolean read FBarVisible write SetBarVisible default True;
    property Color: TColor read GetColor write SetColor default clBtnFace;
    property FontColor: TColor read FFontColor write SetFontColor default clNone;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property LargeImageIndex: TImageIndex read FLargeImageIndex write SetLargeImageIndex default -1;
    property UseSmallImages: Boolean read FUseSmallImages write SetUseSmallImages default False;

    property Caption;
    property Constraints;
    property Enabled;
    property Font;
    property Height stored False;
    property Left stored False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Top stored False;
    property Width stored False;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;

  TSCCustomNavBarControl = class(TSCCustomNavControl)
  private
    FSheets: TList;
    FActiveBar: TSCNavBarSheet;
    FNewDockSheet: TSCNavBarSheet;
    FUndockingBar: TSCNavBarSheet;
    FInitActiveBar: Boolean;

    procedure InsertBar(Bar: TSCNavBarSheet);
    procedure RemoveBar(Bar: TSCNavBarSheet);
    procedure ChangeActiveBar(Bar: TSCNavBarSheet);
    function  GetDockClientAt(P: TPoint): TControl;

    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDockClient(var Message: TCMDockClient); message CM_DOCKCLIENT;
    procedure CMDockNotification(var Message: TCMDockNotification); message CM_DOCKNOTIFICATION;
    procedure CMUnDockClient(var Message: TCMUnDockClient); message CM_UNDOCKCLIENT;

    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Loaded; override;

    procedure FillDataList; override;

    function  IsSheetVisible(Sheet: TSCNavBarSheet): Boolean; virtual;

    procedure Changing(NewIndex: Integer; var Allowed: Boolean); override;

    function  GetFirstVisibleNavBar: Integer; override;
    function  GetLastVisibleNavBar: Integer; override;

    function  GetActiveIndex: Integer; override;
    procedure GradientChanged(Sender: TObject); override;

    procedure DoCloseClick; override;
    procedure DoBarIndexChanged; override;

    procedure DestroyActiveNavBar; override;
    procedure ActiveNavBarMoved(Index: Integer); override;

    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure SetChildOrder(Child: TComponent; Order: Integer); override;
    procedure ShowControl(AControl: TControl); override;

    procedure DoAddDockClient(Client: TControl; const ARect: TRect); override;
    procedure DockOver(Source: TDragDockObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean); override;
    procedure DoRemoveDockClient(Client: TControl); override;
    function  GetBarFromDockClient(Client: TControl): TSCNavBarSheet;
    procedure GetSiteInfo(Client: TControl; var InfluenceRect: TRect;
      MousePos: TPoint; var CanDock: Boolean); override;

    function  GetBar(Index: Integer): TSCNavBarSheet; virtual;
    procedure SetActiveBar(Bar: TSCNavBarSheet); virtual;
    function  GetActiveBarIndex: Integer; virtual;
    procedure SetActiveBarIndex(Value: Integer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Change; override;
    function  GetBarCount: Integer; override;

    function  FindNextBar(CurBar: TSCNavBarSheet; GoForward,
      CheckBarVisible: Boolean): TSCNavBarSheet;
    function  BarForNavBar(ABarIndex: Integer): TSCNavBarSheet;
    procedure SelectNextBar(GoForward: Boolean);

    procedure HideAllBars; override;
    procedure ShowAllBars; override;

    procedure MakeControlVisible(AControl: TControl);

    property BarCount;
    property Bars[Index: Integer]: TSCNavBarSheet read GetBar;

    property ActiveBarIndex: Integer read GetActiveBarIndex write SetActiveBarIndex;
    property ActiveBar: TSCNavBarSheet read FActiveBar write SetActiveBar;
  end;

  TSCNavBarControl = class(TSCCustomNavBarControl)
  published
    property ActiveBar;
    property Align;
    property Alignment;
    property Anchors;
    property BarFont;
    property BarHeight;
    property BorderProps;
    property Color;
    property Colors;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Gradient;
    property Font;
    property HeaderFont;
    property HelpContext;
    property Hint;
    property Images;
    property ImageSpacing;
    property LargeImages;
    property Options;
    property OptionsMenu;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property ParentShowHint;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Visible;
    property VisibleBarCount;
    property OnBarClick;
    property OnBarClose;
    property OnBarChange;
    property OnBarChanging;
    property OnClick;
    property OnCustomDrawBar;
    property OnCustomDrawCloseButton;
    property OnCustomDrawHeader;
    property OnCustomDrawIcon;
    property OnCustomDrawIconBar;
    property OnCustomDrawMenuButton;
    property OnCustomDrawSplitter;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
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
    property OnShowMenu;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TSCNavPanelGradient = class(TSCGradientPainter)
  private
    FOwner: TSCCustomNavPanel;
  protected
    function  GetColorBegin: TColor; override;
    procedure SetColorBegin(Value: TColor); override;
    function  IsColorBeginSaved: Boolean; override;
  public
    constructor Create(AOwner: TSCCustomNavPanel); virtual;
  published
    property Style default scdgsNone;
  end;

  TSCNavPanelHeader = class(TPersistent)
  private
    FAlignment: TLeftRight;
    FButtonIconColor: TColor;
    FColor: TColor;
    FCloseButton: Boolean;
    FFont: TFont;
    FFrameColor: TColor;
    FHeight: Integer;
    FHighlightColor: TColor;
    FImageIndex: TImageIndex;
    FStyle: TSCNavBarStyle;
    FText: String;
    FVisible: Boolean;
    FOwner: TSCCustomNavPanel;
    procedure SetAlignment(Value: TLeftRight);
    procedure SetButtonIconColor(Value: TColor);
    procedure SetCloseButton(Value: Boolean);
    procedure SetColor(Value: TColor);
    procedure SetFont(Value: TFont);
    procedure SetFrameColor(Value: TColor);
    procedure SetHeight(Value: Integer);
    procedure SetHighlightColor(Value: TColor);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetStyle(Value: TSCNavBarStyle);
    procedure SetText(const Value: String);
    procedure SetVisible(Value: Boolean);
  protected
    function GetOwner: TPersistent; override;
    property Owner: TSCCustomNavPanel read FOwner;

    procedure Changed(Force: Boolean);
    procedure FontChanged(Sender: TObject);
  public
    constructor Create(AOwner: TSCCustomNavPanel);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Alignment: TLeftRight read FAlignment write SetAlignment default taLeftJustify;
    property ButtonIconColor: TColor read FButtonIconColor write SetButtonIconColor default clBtnText;
    property CloseButton: Boolean read FCloseButton write SetCloseButton default True;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Font: TFont read FFont write SetFont;
    property FrameColor: TColor read FFrameColor write SetFrameColor default  clBtnShadow;
    property Height: Integer read FHeight write SetHeight default -1;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default $003FABFF;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Style: TSCNavBarStyle read FStyle write SetStyle default scnbOfficeXP;
    property Text: String read FText write SetText;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TSCNavPanelBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccbNone;
    property Color;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCNavPanelPart = (scnppNowhere, scnppHeader, scnppClient,
    scnppCloseButton);

  TSCNavPanelParts = set of TSCNavPanelPart;

  TSCNavPanelHitInfo = record
    X: Integer;
    Y: Integer;
    Part: TSCNavPanelPart;
    Clicked: Boolean;
    IsLeftBtn: Boolean;
  end;
  PSCNavPanelHitInfo = ^TSCNavPanelHitInfo;

  TSCNavPanelAllowEvent = procedure(Sender: TObject; var AllowClose: Boolean) of object;

  TSCNavPanelPaintButtonEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; ADown, AHot: Boolean; var ABackColor: TColor;
    var AForeColor: TColor; var Handled: Boolean) of object;

  TSCNavPanelPaintHeaderEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; AFont: TFont; var AColor: TColor; var AImage: Integer;
    var AText: String; var Handled: Boolean) of object;

  TSCCustomNavPanel = class(TSCCustomControl)
  private
    FGradient: TSCNavPanelGradient;
    FHeader: TSCNavPanelHeader;
    FGradientPainter: TSCGradientPainter;
    FBufferUpdate: Integer;
    FPaintBuffer: TBitmap;
    FControlLoaded: Boolean;
    FDefaultHeaderHeight: Integer;
    FHitInfo: TSCNavPanelHitInfo;
    FHottrackInfo: TSCNavPanelHitInfo;
    FOnAllowClose: TSCNavPanelAllowEvent;
    FOnCloseClick: TNotifyEvent;
    FOnCustomDrawCloseButton: TSCNavPanelPaintButtonEvent;
    FOnCustomDrawHeader: TSCNavPanelPaintHeaderEvent;

    procedure SetGradient(Value: TSCNavPanelGradient);
    procedure SetHeader(Value: TSCNavPanelHeader);

    procedure HeaderChanged(Force: Boolean);
    procedure GradientChanged(Sender: TObject);

    procedure UpdateHottrackInfo;
    procedure CheckMouseUpdate(OldHot: TSCNavPanelHitInfo);

    procedure CloseClick;
    procedure InitializeHitTest(AHitInfo: PSCNavPanelHitInfo);

    procedure DrawCloseButton(ACanvas: TCanvas);
    procedure DrawGradientBack(ACanvas: TCanvas);
    procedure DrawHeader(ACanvas: TCanvas);
    procedure DrawButtonFace(ACanvas: TCanvas; ARect: TRect;
      AStyle: TSCNavBarStyle; AColor: TColor; IsDown, IsHot: Boolean);

    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;

    procedure Loaded; override;
    procedure Paint; override;

    function  CanClose: Boolean; dynamic;
    procedure DoCloseClick; virtual;

    procedure DoHeaderChanged(Force: Boolean); virtual;
    procedure DoGradientChanged(Sender: TObject); virtual;

    function  GetButtonColor(IsHot, IsDown, IsActive: Boolean): TColor; virtual;
    function  GetButtonTextColor(IsHot, IsDown, IsActive: Boolean): TColor; virtual;

    function  GetCardRect: TRect; virtual;
    function  GetHeaderRect: TRect; virtual;
    function  GetHeaderHeight: Integer; virtual;
    function  GetCloseButtonRect: TRect; virtual;

    procedure StopTracking; override;
    procedure AdjustClientRect(var ARect: TRect); override;

    function  GetDefaultBackColor: TColor; override;
    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;

    procedure UpdateBuffer(Repaint: Boolean = True);
    procedure UpdatePanel(ARealign: Boolean);

    function  GetFrameColor: TColor; virtual;
    function  GetHeaderColor: TColor; virtual;

    procedure DoDrawCloseButton(ACanvas: TCanvas;
      ARect: TRect; ADown, AHot: Boolean; var ABackColor: TColor;
      var AForeColor: TColor; var Handled: Boolean); virtual;
    procedure DoDrawHeader(ACanvas: TCanvas; ARect: TRect;
      AFont: TFont; var AColor: TColor; var AImage: Integer;
      var AText: String; var Handled: Boolean); virtual;

    function  GetGradientShadow(AColor: TColor): TColor;
    function  GetGradientDark(AColor: TColor): TColor;
    function  GetGradientLight(AColor: TColor): TColor;
    function  GetGradientExLight(AColor: TColor): TColor;
    function  GetGradientPeal(AColor: TColor): TColor;

    procedure SetIndent(Value: Integer); override;
    procedure IndentChanged; override;
    procedure ImageListChange(Sender: TObject); override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property Gradient: TSCNavPanelGradient read FGradient write SetGradient;
    property Header: TSCNavPanelHeader read FHeader write SetHeader;
    property OnAllowClose: TSCNavPanelAllowEvent read FOnAllowClose write FOnAllowClose;
    property OnCloseClick: TNotifyEvent read FOnCloseClick write FOnCloseClick;
    property OnCustomDrawCloseButton: TSCNavPanelPaintButtonEvent read FOnCustomDrawCloseButton
      write FOnCustomDrawCloseButton;
    property OnCustomDrawHeader: TSCNavPanelPaintHeaderEvent read FOnCustomDrawHeader
      write FOnCustomDrawHeader;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function  GetHitInfo(const P: TPoint): TSCNavPanelHitInfo; virtual;

    property DockManager;
    property Color default clWindow;
    property ParentColor default False;
    property UseDockManager default True;
  end;

  TSCNavPanel = class(TSCCustomNavPanel)
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderProps;
    property Color;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Gradient;
    property Header;
    property Images;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnAllowClose;
    property OnCanResize;
    property OnClick;
    property OnCloseClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnCustomDrawCloseButton;
    property OnCustomDrawHeader;
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

implementation

var
  Registered: Boolean = False;

const
  SC_NavBarVertBarSpacing    = 6;
  SC_NavBarHorzBarSpacing    = 6;
  SC_NavBarVertHeaderSpacing = 4;
  SC_NavBarHorzHeaderSpacing = 4;
  SC_NavBarSplitterHeight    = 9;
  SC_NavBarMenuButtonSize    = 20;
  SC_NavBarCloseButtonSize   = 20;
  SC_NavBarIconSize          = 22;
  SC_NavBarIconSpace         = 6;
  SC_NavPanelHorzSpacing     = 4;
  SC_NavPanelVertSpacing     = 3;
  SC_NavPanelCloseButtonSize = 16;

const
  SC_NavBarHotParts: TSCNavBarParts = [scnpCloseButton, scnpIcon,
    scnpMenuButton, scnpNavBar];

  SC_NavPanelHotParts: TSCNavPanelParts = [scnppCloseButton];

{ TSCNavTabItem }

procedure TSCNavTabItem.Assign(Source: TPersistent);
begin
  if Source is TSCNavTabItem then
  begin
    with TSCNavTabItem(Source) do
    begin
      Self.FCaption := Caption;
      Self.FColor := Color;
      Self.FEnabled := Enabled;
      Self.FFontColor := FontColor;
      Self.FHint := Hint;
      Self.FImageIndex := ImageIndex;
      Self.FLargeImageIndex := LargeImageIndex;
      Self.FTag := Tag;
      Self.FUseSmallImages := UseSmallImages;
      Self.FVisible := Visible;
    end;

    Changed(True);
  end else
  if Source is TSCNavBarData then
  begin
    with TSCNavBarData(Source) do
    begin
      Self.FCaption := Caption;
      Self.FColor := Color;
      Self.FEnabled := Enabled;
      Self.FFontColor := FontColor;
      Self.FHint := Hint;
      Self.FImageIndex := ImageIndex;
      Self.FLargeImageIndex := LargeImageIndex;
      Self.FTag := Tag;
      Self.FUseSmallImages := UseSmallImages;
      Self.FVisible := Visible;
    end;

    Changed(True);
  end else
    inherited Assign(Source);
end;

procedure TSCNavTabItem.AssignTo(Dest: TPersistent);
begin
  if Dest is TSCNavBarData then
  begin
    with TSCNavBarData(Dest) do
    begin
      FCaption := Self.Caption;
      FColor := Self.Color;
      FEnabled := Self.Enabled;
      FFontColor := Self.FontColor;
      FHint := Self.Hint;
      FImageIndex := Self.ImageIndex;
      FLargeImageIndex := Self.LargeImageIndex;
      FUseSmallImages := Self.UseSmallImages;
      FTag := Self.Tag;
      FVisible := Self.Visible;
    end;
  end else
    inherited AssignTo(Dest);
end;

constructor TSCNavTabItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FColor := clBtnFace;
  FEnabled := True;
  FFontColor := clNone;
  FImageIndex := -1;
  FLargeImageIndex := -1;
  FUseSmallImages := False;
  FVisible := True;
end;

function TSCNavTabItem.GetDisplayName: string;
begin
  Result := FCaption;
  if Result = '' then Result := inherited GetDisplayName;
end;

procedure TSCNavTabItem.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCNavTabItem.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCNavTabItem.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCNavTabItem.SetFontColor(Value: TColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCNavTabItem.SetHint(const Value: String);
begin
  if FHint <> Value then
  begin
    FHint := Value;
    if FVisible and FEnabled then
      Changed(True);
  end;
end;

procedure TSCNavTabItem.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCNavTabItem.SetLargeImageIndex(Value: TImageIndex);
begin
  if FLargeImageIndex <> Value then
  begin
    FLargeImageIndex := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCNavTabItem.SetUseSmallImages(Value: Boolean);
begin
  if FUseSmallImages <> Value then
  begin
    FUseSmallImages := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCNavTabItem.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(True);
  end;
end;

{ TSCNavTabItems }

function TSCNavTabItems.Add: TSCNavTabItem;
begin
  Result := TSCNavTabItem(inherited Add);
  if (FOwner <> nil) and (FOwner.FBarIndex = -1) then
    FOwner.BarIndex := 0;
end;

procedure TSCNavTabItems.Clear;
begin
  inherited Clear;
  if FOwner <> nil then
    FOwner.BarIndex := -1;
end;

constructor TSCNavTabItems.Create(AOwner: TSCCustomNavTabControl);
begin
  FOwner := AOwner;
  inherited Create(TSCNavTabItem);
end;

procedure TSCNavTabItems.Delete(Index: Integer);
var
  AIndex: Integer;
begin
  AIndex := 0;
  if FOwner <> nil then AIndex := FOwner.FBarIndex;

  Items[Index].Collection := nil;
  if (FOwner <> nil) and (Index <= AIndex) then
    FOwner.BarIndex := AIndex - 1;
end;

function TSCNavTabItems.GetItem(Index: Integer): TSCNavTabItem;
begin
  Result := TSCNavTabItem(inherited GetItem(Index));
end;

function TSCNavTabItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCNavTabItems.IndexOf(ATab: TSCNavTabItem): Integer;
var
  I: Integer;
begin
  Result := -1;
  if (ATab <> nil) and (ATab.Collection = Self) then
    for I := 0 to Self.Count - 1 do
      if ATab = Items[I] then
      begin
        Result := I;
        Break;
      end;
end;

procedure TSCNavTabItems.Move(CurIndex, NewIndex: Integer);
begin
  Items[CurIndex].Index := NewIndex;
end;

procedure TSCNavTabItems.SetItem(Index: Integer; Value: TSCNavTabItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCNavTabItems.Update(Item: TCollectionItem);
begin
  if FOwner <> nil then
  begin
    FOwner.UpdateNavBars(False);
    FOwner.UpdateNavBars(True);
  end;
end;

{ TSCNavBarDataList }

function TSCNavBarDataList.Add: TSCNavBarData;
begin
  Result := TSCNavBarData.Create;
  FList.Add(Result);
end;

procedure TSCNavBarDataList.Clear;
var
  I: Integer;
  Obj: TObject;
begin
  while FList.Count > 0 do
  begin
    I := FList.Count-1;
    Obj := TObject(FList[I]);

    FList.Delete(I);
    Obj.Free;
  end;
end;

function TSCNavBarDataList.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TSCNavBarDataList.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

procedure TSCNavBarDataList.Delete(Index: Integer);
var
  Obj: TObject;
begin
  Obj := TObject(FList[Index]);
  FList.Delete(Index);
  
  Obj.Free;
end;

destructor TSCNavBarDataList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TSCNavBarDataList.Get(Index: Integer): TSCNavBarData;
begin
  Result := TSCNavBarData(FList[Index]);
end;

function TSCNavBarDataList.IndexOf(AData: TSCNavBarData): Integer;
begin
  Result := FList.IndexOf(AData);
end;

{ TSCNavBarData }

procedure TSCNavBarData.Assign(Source: TPersistent);
begin
  if Source is TSCNavBarData then
  begin
    with TSCNavBarData(Source) do
    begin
      Self.FCaption := Caption;
      Self.FColor := Color;
      Self.FEnabled := Enabled;
      Self.FFontColor := FontColor;
      Self.FHint := Hint;
      Self.FImageIndex := ImageIndex;
      Self.FLargeImageIndex := LargeImageIndex;
      Self.FTag := Tag;
      Self.FUseSmallImages := UseSmallImages;
      Self.FVisible := Visible;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCNavBarData.Create;
begin
  inherited Create;
  FIndex := -1;
  FBarItem := nil;
  FColor := clBtnFace;
  FEnabled := True;
  FFontColor := clWindowText;
  FVisible := True;
  FImageIndex := -1;
  FLargeImageIndex := -1;
  FUseSmallImages := False;
end;

{ TSCNavBarColors }

procedure TSCNavBarColors.Assign(Source: TPersistent);
begin
  if Source is TSCNavBarColors then
  begin
    with TSCNavBarColors(Source) do
    begin
      Self.FBarColor := BarColor;
      Self.FBarTextColor := BarTextColor;
      Self.FButtonIconColor := ButtonIconColor;
      Self.FFrameColor := FrameColor;
      Self.FHeaderColor := HeaderColor;
      Self.FHighlightColor := HighlightColor;
      Self.FHighlightTextColor := HighlightTextColor;
      Self.FSplitterColor := SplitterColor;
    end;

    DoChange;
  end else
    inherited Assign(Source);
end;

constructor TSCNavBarColors.Create(AOwner: TSCCustomNavControl);
begin
  inherited Create;
  FOwner := AOwner;

  FBarColor := clBtnFace;
  FBarTextColor := clBtnText;
  FButtonIconColor := clBtnText;
  FFrameColor := clBtnShadow;
  FHeaderColor := clBtnFace;
  FHighlightColor := $003FABFF;
  FHighlightTextColor := clBtnText;
  FSplitterColor := clBtnShadow;
end;

procedure TSCNavBarColors.DoChange;
begin
  if FOwner <> nil then FOwner.ColorsChanged;
end;

function TSCNavBarColors.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCNavBarColors.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    DoChange;
  end;
end;

procedure TSCNavBarColors.SetHighlightTextColor(Value: TColor);
begin
  if FHighlightTextColor <> Value then
  begin
    FHighlightTextColor := Value;
    DoChange;
  end;
end;

procedure TSCNavBarColors.SetButtonIconColor(Value: TColor);
begin
  if FButtonIconColor <> Value then
  begin
    FButtonIconColor := Value;
    DoChange;
  end;
end;

procedure TSCNavBarColors.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    DoChange;
  end;
end;

procedure TSCNavBarColors.SetHeaderColor(Value: TColor);
begin
  if FHeaderColor <> Value then
  begin
    FHeaderColor := Value;
    DoChange;
  end;
end;

procedure TSCNavBarColors.SetSplitterColor(Value: TColor);
begin
  if FSplitterColor <> Value then
  begin
    FSplitterColor := Value;
    DoChange;
  end;
end;

procedure TSCNavBarColors.SetBarColor(Value: TColor);
begin
  if FBarColor <> Value then
  begin
    FBarColor := Value;
    DoChange;
  end;
end;

procedure TSCNavBarColors.SetBarTextColor(Value: TColor);
begin
  if FBarTextColor <> Value then
  begin
    FBarTextColor := Value;
    DoChange;
  end;
end;

{ TSCCustomNavControl }

procedure TSCCustomNavControl.AdjustClientRect(var ARect: TRect);
begin
  ARect := GetCardRect;
  inherited AdjustClientRect(ARect);
end;

function TSCCustomNavControl.CheckVisible(Index: Integer): Integer;
var
  I: Integer;
  AData: TSCNavBarData;
  ADataList: TSCNavBarDataList;
begin
  Result := -1;
  ADataList := GetDataList;

  if ADataList <> nil then
  begin
    if Index < -1 then Index := -1
    else if Index > ADataList.Count-1 then
      Index := ADataList.Count-1;

    Result := Index;
    if ADataList.Count > 0 then
    begin
      if Index = -1 then Index := 0;

      for I := Index to ADataList.Count-1 do
      begin
        AData := ADataList[I];

        if IsBarVisible(AData) then
        begin
          Result := I;
          Exit;
        end;
      end;

      for I := Index-1 downto 0 do
      begin
        AData := ADataList[I];

        if IsBarVisible(AData) then
        begin
          Result := I;
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomNavControl.CMColorChanged(var Message: TMessage);
begin
  inherited;
  if FGradient <> nil then
    FGradient.UpdatePattern;

  UpdateBuffer;
end;

procedure TSCCustomNavControl.CMDesignHitTest(var Message: TCMDesignHitTest);
var
  P: TPoint;
  Shift: TShiftState;
  Hit, OldHit: TSCNavBarHitInfo;
begin
  OldHit := FHitInfo;
  InitializeHitTest(@FHitInfo);

  Shift := KeysToShiftState(Message.Keys);

  if ssLeft in Shift then
  begin
    P := SmallPointToPoint(Message.Pos);
    Hit := GetHitInfo(P);

    with Hit do
    begin
      Clicked := True;
      IsLeftBtn := True;
    end;

    if (((Hit.Part in [scnpIcon, scnpNavBar]) and
      (Hit.Index > -1) and (Hit.Index <> GetActiveIndex))) or
      ((Hit.Part = scnpSplitter) or (OldHit.Part = scnpSplitter)) then
    begin
      FHitInfo := Hit;
      
      if OldHit.Part = scnpSplitter then
      begin
        FHitInfo := OldHit;
        FHottrackInfo := Hit;
      end;

      Message.Result := 1;
      FDesignChange := True;
    end;
  end else
  begin
    if FDesignChange then Message.Result := 1;
    FDesignChange := False;
  end;
end;

procedure TSCCustomNavControl.CMFontChanged(var Message: TMessage);
begin
  inherited;
  FDefaultBarHeight := -1;
  FDefaultHeaderHeight := -1;
  UpdateNavBars(False);
  UpdateNavBars(True);
end;

procedure TSCCustomNavControl.ColorsChanged;
begin
  if GetBarCount > 0 then
    UpdateNavBars(False);
    
  DoColorsChanged;
end;

constructor TSCCustomNavControl.Create(AOwner: TComponent);
begin
  FDataList := TSCNavBarDataList.Create;
  FColors := TSCNavBarColors.Create(Self);
  FControlLoaded := False;

  FDefaultIndex := -1;
  FDefaultBarHeight := -1;
  FDefaultHeaderHeight := -1;
  FCurrVisibleBars := -1;
  FSplitterDownPos := -1;
  FDesignChange := False;

  FGradient := TSCNavBackGradient.Create(Self);
  FGradient.OnChange := GradientChanged;

  FGradientPainter := TSCGradientPainter.Create(nil);
  FGradientPainter.Style := scdgsLinearV;

  inherited Create(AOwner);
  FPaintBuffer := TBitmap.Create;

  FBarFont := TFont.Create;
  FBarFont.OnChange := BarFontChanged;

  FHeaderFont := TFont.Create;
  FHeaderFont.OnChange := HeaderFontChanged;

  Color := clWindow;
  ParentColor := False;
  ClickFocus := False;
  SetBounds(Left, Top, 185, 300);

  InitializeHitTest(@FHitInfo);
  InitializeHitTest(@FHottrackInfo);

  FBarHeight := 32;
  FImageSpacing := 2;
  FAlignment := taLeftJustify;
  FStyle := scnbOfficeXP;
  FBarIndex := -1;
  FOptions := SC_DefaultNavBarOptions;
  FVisibleBarCount := 5;

  FLargeImgChangeLink := TChangeLink.Create;
  FLargeImgChangeLink.OnChange := ImageListChange;
end;

procedure TSCCustomNavControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_CLIPCHILDREN or WS_CLIPSIBLINGS;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW) or
      CS_DBLCLKS;
  end;
end;

destructor TSCCustomNavControl.Destroy;
begin
  FreeAndNil(FLargeImgChangeLink);

  FBarFont.OnChange := nil;
  FreeAndNil(FBarFont);

  FHeaderFont.OnChange := nil;
  FreeAndNil(FHeaderFont);

  FreeAndNil(FGradientPainter);

  FGradient.OnChange := nil;
  FreeAndNil(FGradient);
  
  FreeAndNil(FDataList);
  FreeAndNil(FColors);
  FreeAndNil(FPaintBuffer);
  inherited Destroy;
end;

procedure TSCCustomNavControl.DoColorsChanged;
begin
  //
end;

procedure TSCCustomNavControl.DoOptionsChanged;
begin
  //
end;

procedure TSCCustomNavControl.DrawSplitter(ACanvas: TCanvas);
var
  ARect, R: TRect;
  Handled: Boolean;
  I, L, SR: Integer;
  AColor, C1, C2, C3: TColor;
begin
  if IsShowSplitter then
  begin
    ARect := GetSplitterRect;

    if not IsRectEmpty(ARect) then
    begin
      AColor := GetSplitterColor;
      if AColor = clNone then
        AColor := clBtnShadow;

      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AColor;

        FillRect(ARect);
      end;

      FGradientPainter.ColorBegin := GetGradientExLight(AColor);
      FGradientPainter.ColorEnd := AColor;

      FGradientPainter.Paint(ACanvas, ARect);

      SR := IntersectClipRect(ACanvas.Handle,
        ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
      try
        if SR <> NULLREGION then
        begin
          Handled := False;

          if Assigned(FOnCustomDrawSplitter) then
            FOnCustomDrawSplitter(Self, ACanvas, ARect, AColor, Handled);

          if not Handled then
            DoDrawSplitter(ACanvas, ARect, AColor, Handled);

          if Handled then
            Exit;
        end;
      finally
        SelectClipRgn(ACanvas.Handle, 0);
      end;

      if AColor = clNone then
      begin
        AColor := GetSplitterColor;
        if AColor = clNone then
          AColor := clBtnShadow;
      end;

      FGradientPainter.ColorBegin := GetGradientExLight(AColor);
      FGradientPainter.ColorEnd := AColor;

      FGradientPainter.Paint(ACanvas, ARect);

      C1 := GetBtnShadowOf(AColor);
      C2 := GetBtnHighlightOf(AColor);
      C3 := MixColors(C1, C2, 20);

      L := ARect.Left + ((ARect.Right - ARect.Left) div 2) - 9*2;

      for I := 0 to 8 do
      begin
        R := ARect;

        Inc(R.Top, 3);
        R.Bottom := R.Top + 2;
        R.Left := L;
        R.Right := R.Left + 2;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C1;

          FillRect(R);
        end;

        OffsetRect(R, 1, 1);

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C2;

          FillRect(R);
        end;

        with ACanvas do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := C3;

          MoveTo(R.Left, R.Top);
          LineTo(R.Left + 1, R.Top);
        end;

        Inc(L, 4);
      end;

      C1 := GetFrameColor;

      if (C1 <> clNone) and (AColor <> C1) then
        with ACanvas do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := C1;

          MoveTo(ARect.Left, ARect.Top);
          LineTo(ARect.Right, ARect.Top);

          MoveTo(ARect.Left, ARect.Bottom - 1);
          LineTo(ARect.Right, ARect.Bottom - 1);
        end;
    end;
  end;
end;

procedure TSCCustomNavControl.DrawBar(ACanvas: TCanvas; AData: TSCNavBarData);
var
  AFont: TFont;
  AText: String;
  AColor: TColor;
  ARect, R: TRect;
  Handled: Boolean;
  AImage, SR, X, Y, F: Integer;
  ImgList: TCustomImageList;
  IsHot, IsDown, IsActive: Boolean;
begin
  if (AData <> nil) and IsBarVisible(AData) and IsShowingCaption(AData) then
  begin
    ARect := GetBarRect(AData);

    if not IsRectEmpty(ARect) then
    begin
      IsHot := False;
      IsDown := False;
      IsActive := GetActiveIndex = AData.Index;

      if not IsDesigning then
      begin
        IsDown := (FHitInfo.Part = scnpNavBar) and
          (FHitInfo.Index = AData.Index);

        IsHot := (FHottrackInfo.Part = scnpNavBar) and
          (FHottrackInfo.Index = AData.Index) and
          ((FHitInfo.Part = scnpNowhere) or IsDown);
      end;

      AColor := GetButtonColor(IsHot, IsDown, IsActive);

      if AColor = clNone then
      begin
        AColor := GetBarColor(AData);
        if AColor = clNone then
          AColor := clBtnFace;
      end;

      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AColor;

        FillRect(ARect);
      end;

      DrawButtonFace(ACanvas, ARect, AColor, IsDown, IsHot, IsActive);

      AText := AData.Caption;

      AImage := AData.LargeImageIndex;
      if AImage = -1 then
        AImage := AData.ImageIndex;

      AFont := TFont.Create;
      try
        Handled := False;

        AFont.Assign(Self.BarFont);

        AFont.Color := GetButtonTextColor(IsHot, IsDown, IsActive);
        if AFont.Color = clNone then
          AFont.Color := clBtnText;

        SR := IntersectClipRect(ACanvas.Handle,
          ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
        try
          if SR <> NULLREGION then
          begin
            if Assigned(FOnCustomDrawBar) then
              FOnCustomDrawBar(Self, ACanvas, ARect, IsDown,
                IsHot, IsActive, True, AFont, AColor, AImage,
                AText, Handled);

            if not Handled then
              DoDrawBar(ACanvas, AData, ARect, IsDown,
                IsHot, IsActive, True, AFont, AColor, AImage,
                AText, Handled);

            if Handled then
              Exit;
          end;
        finally
          SelectClipRgn(ACanvas.Handle, 0);
        end;

        if AColor = clNone then
        begin
          AColor := GetButtonColor(IsHot, IsDown, IsActive);

          if AColor = clNone then
          begin
            AColor := GetBarColor(AData);

            if AColor = clNone then
              AColor := clBtnFace;
          end;
        end;

        DrawButtonFace(ACanvas, ARect, AColor, IsDown, IsHot, IsActive);

        if AFont.Color = clNone then
        begin
          AFont.Color := GetButtonTextColor(IsHot, IsDown, IsActive);
          if AFont.Color = clNone then
            AFont.Color := clBtnText;
        end;

        R := ARect;
        InflateRect(R, -SC_NavBarHorzBarSpacing, 0);

        ImgList := GetLargeImages;
        if (ImgList <> nil) and (AImage > -1) and (AImage < ImgList.Count) then
        begin
          X := R.Left;
          Y := R.Top + ((R.Bottom - R.Top - ImgList.Height) div 2);

          ImgList.Draw(ACanvas, X, Y, AImage,
            Self.Enabled and AData.Enabled);

          Inc(R.Left, ImgList.Width + 2);
        end;

        if AText <> '' then
        begin
          F := DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or
            DT_END_ELLIPSIS or DT_LEFT;

          with ACanvas do
          begin
            Font.Assign(AFont);
            Brush.Style := bsClear;

            Windows.DrawText(ACanvas.Handle, PChar(AText),
              Length(AText), R, F);
          end;
        end;
      finally
        AFont.Free;
      end;

      AColor := GetFrameColor;

      with ACanvas do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := AColor;

        MoveTo(ARect.Left, ARect.Bottom - 1);
        LineTo(ARect.Right, ARect.Bottom - 1);
      end;
    end;
  end;
end;

procedure TSCCustomNavControl.DrawBars(ACanvas: TCanvas);
var
  I: Integer;
  AData: TSCNavBarData;
  ADataList: TSCNavBarDataList;
begin
  ADataList := GetDataList;
  if ADataList <> nil then
    for I := 0 to ADataList.Count-1 do
    begin
      AData := ADataList[I];
      if IsBarVisible(AData) and IsShowingCaption(AData) then
        DrawBar(ACanvas, AData);
    end;

  DrawIconBar(ACanvas);
  DrawMenuButton(ACanvas);
  DrawSplitter(ACanvas);
  DrawHeader(ACanvas);
  DrawCloseButton(ACanvas);
end;

procedure TSCCustomNavControl.FillDataList;
begin
  //
end;

function TSCCustomNavControl.GetActiveIndex: Integer;
var
  I: Integer;
  ADataList: TSCNavBarDataList;
begin
  Result := -1;
  ADataList := GetDataList;

  if ADataList <> nil then
  begin
    Result := FBarIndex;
    if (Result > -1) and ((Result > ADataList.Count-1) or
      not IsBarVisible(ADataList[Result])) then
      Result := -1;

    if Result = -1 then
      for I := 0 to ADataList.Count-1 do
        if IsBarVisible(ADataList[I]) then
        begin
          Result := I;
          Break;
        end;
  end;
end;

function TSCCustomNavControl.GetFrameColor: TColor;
begin
  Result := Self.FColors.FrameColor;
  if Result = clNone then
  begin
    Result := clBtnShadow;
    if Self.Color <> clNone then
      Result := GetBtnShadowOf(Self.Color);
  end;
end;

function TSCCustomNavControl.GetGradientLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 30);
end;

function TSCCustomNavControl.GetGradientExLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 40);
end;

function TSCCustomNavControl.GetBarColor(AData: TSCNavBarData): TColor;
var
  Index: Integer;
begin
  Result := Self.Color;
  if Result = clNone then Result := clBtnFace;

  if AData <> nil then
  begin
    Index := GetActiveIndex;

    if not IsUseBarColors and (AData.Index <> Index) then
    begin
      Result := FColors.BarColor;

      if Result = clNone then Result := Self.Color;
      if Result = clNone then Result := clBtnFace;
    end else
    if IsUseBarColors then
    begin
      Result := AData.Color;

      if Result = clNone then
      begin
        if AData.Index <> Index then
        begin
          Result := FColors.BarColor;
          if Result = clNone then Result := clBtnFace;
        end else
        begin
          Result := Self.Color;
          if Result = clNone then Result := clBtnFace;
        end;
      end;
    end;
  end;
end;

function TSCCustomNavControl.GetBarCount: Integer;
var
  ADataList: TSCNavBarDataList;
begin
  Result := 0;

  ADataList := GetDataList;
  if ADataList <> nil then
    Result := ADataList.Count;
end;

function TSCCustomNavControl.GetBarHeight(AIndex: Integer): Integer;
var
  AMin: Integer;
  AData: TSCNavBarData;
  AImageList: TCustomImageList;
  ADataList: TSCNavBarDataList;
begin
  Result := 0;
  if AIndex > -1 then
  begin
    ADataList := GetDataList;

    if (ADataList <> nil) and (AIndex < ADataList.Count) then
    begin
      AData := ADataList[AIndex];

      if IsBarVisible(AData) then
      begin
        Canvas.Font.Assign(Self.Font);
        Result := Canvas.TextHeight('Rq') + 2;

        AImageList := Images;
        if not AData.UseSmallImages then
          AImageList := GetLargeImages;

        if (AImageList <> nil) and (Result < AImageList.Height) then
          Result := AImageList.Height;

        Inc(Result, 2*SC_NavBarVertBarSpacing);

        AMin := GetMinBarHeight;
        if Result < AMin then Result := AMin;
      end;
    end;
  end;
end;

function TSCCustomNavControl.GetBarHeight: Integer;
var
  AMin: Integer;
begin
  Result := FBarHeight;

  AMin := GetMinBarHeight;
  if Result < AMin then Result := AMin;
end;

function TSCCustomNavControl.GetBarRect(AData: TSCNavBarData): TRect;
var
  CR: TRect;
  Data: TSCNavBarData;
  I, T, H, Cnt, VisCnt: Integer;
  ADataList: TSCNavBarDataList;
begin
  Result := Rect(0, 0, 0, 0);
  
  VisCnt := GetCurrVisibleCount;

  if HandleAllocated and (AData <> nil) and
    IsBarVisible(AData) and IsShowingCaption(AData) then
  begin
    CR := GetClientRect;
    CR.Top := CR.Bottom - GetVisibleBarsHeight;

    if IsShowSplitter then
    begin
      H := GetSplitterHeight;
      if H > 0 then Inc(CR.Top, H);
    end;

    ADataList := GetDataList;

    if ADataList <> nil then
    begin
      T := 0;
      Cnt := 0;

      for I := 0 to ADataList.Count - 1 do
      begin
        Data := ADataList[I];
        if IsBarVisible(Data) then
        begin
          Inc(Cnt);
          if Cnt > VisCnt then
            Break;
        end;

        if AData = Data then
        begin
          Result := CR;
          Inc(Result.Top, T);

          H := GetBarHeight(I);
          if H < 0 then H := 0;

          Result.Bottom := Result.Top + H;
          Break;
        end;

        if IsBarVisible(Data) then
        begin
          H := GetBarHeight(I);
          if H > 0 then Inc(T, H);
        end;
      end;
    end;
  end;
end;

function TSCCustomNavControl.GetBarRect(Index: Integer): TRect;
var
  ADataList: TSCNavBarDataList;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated and (Index > -1) then
  begin
    ADataList := GetDataList;
    if (ADataList <> nil) and (Index < ADataList.Count) then
      Result := GetBarRect(TSCNavBarData(ADataList[Index]));
  end;
end;

function TSCCustomNavControl.GetSplitterColor: TColor;
begin
  Result := FColors.SplitterColor;
  if Result = clNone then
    Result := clBtnShadow;
end;

function TSCCustomNavControl.GetSplitterHeight: Integer;
begin
  Result := SC_NavBarSplitterHeight;
end;

function TSCCustomNavControl.GetSplitterRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if HandleAllocated and IsShowSplitter then
  begin
    Result := GetClientRect;
    Result.Top := Result.Bottom - GetVisibleBarsHeight;
    Result.Bottom := Result.Top + GetSplitterHeight;
  end;
end;

function TSCCustomNavControl.GetBarTextColor(AData: TSCNavBarData): TColor;
var
  Index: Integer;
begin
  Result := Self.Font.Color;
  if Result = clNone then Result := clWindowText;

  if AData <> nil then
  begin
    Index := GetActiveIndex;

    if not IsUseBarColors and (AData.Index <> Index) then
    begin
      Result := FColors.BarTextColor;
      if Result = clNone then Result := clWindowText;
    end else
    if IsUseBarColors then
    begin
      Result := AData.FontColor;

      if Result = clNone then
      begin
        if AData.Index <> Index then
          Result := FColors.BarTextColor
        else
          Result := Self.Font.Color;

        if Result = clNone then Result := clWindowText;
      end;
    end;
  end;
end;

function TSCCustomNavControl.GetHeaderColor: TColor;
begin
  Result := FColors.HeaderColor;
  if Result = clNone then
    Result := clBtnFace;
end;

function TSCCustomNavControl.GetHeaderHeight: Integer;
begin
  Result := FDefaultHeaderHeight;
  if HandleAllocated and (Result = -1) then
  begin
    Canvas.Font.Assign(Self.HeaderFont);
    FDefaultHeaderHeight := Canvas.TextHeight('Rq');

    if (Images <> nil) and (FDefaultHeaderHeight < Images.Height) then
      FDefaultHeaderHeight := Images.Height;

    Inc(FDefaultHeaderHeight, 2*SC_NavBarVertHeaderSpacing);
    Result := FDefaultHeaderHeight;
  end;
end;

function TSCCustomNavControl.GetHeaderRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if HandleAllocated and IsShowHeader then
  begin
    Result := GetClientRect;
    Result.Bottom := Result.Top + GetHeaderHeight;
  end;
end;

function TSCCustomNavControl.GetHitInfo(const P: TPoint): TSCNavBarHitInfo;
var
  R, CR: TRect;
  AData: TSCNavBarData;
  ADataList: TSCNavBarDataList;
  I, IconSize, IconCnt, VisCnt, Cnt: Integer;
begin
  InitializeHitTest(@Result);

  with Result do
  begin
    X := P.x;
    Y := P.y;
  end;

  if FHitInfo.Clicked then
  begin
    Result.Clicked := True;
    Result.IsLeftBtn := FHitInfo.IsLeftBtn;
  end;

  CR := GetClientRect;

  if PtInRect(CR, P) then
  begin
    Result.Part := scnpClient;

    if IsShowHeader then
    begin
      R := CR;
      R.Bottom := R.Top + GetHeaderHeight;

      if not IsRectEmpty(R) and PtInRect(R, P) then
      begin
        Result.Part := scnpHeader;

        if IsShowCloseButton then
        begin
          R.Left := R.Right - SC_NavBarCloseButtonSize;
          if IntersectRect(R, R, CR) and PtInRect(R, P) then
            Result.Part := scnpCloseButton;

          Exit;
        end;
      end;
    end;

    ADataList := GetDataList;
    
    R := CR;
    R.Top := R.Bottom - GetBarHeight;

    if IntersectRect(R, R, CR) and PtInRect(R, P) then
    begin
      Result.Part := scnpIconBar;
      R.Left := R.Right;

      if IsShowMenuButton then
      begin
        Dec(R.Left, SC_NavBarMenuButtonSize);

        if PtInRect(R, P) then
        begin
          Result.Part := scnpMenuButton;
          Exit;
        end;
      end;

      if ADataList <> nil then
      begin
        Cnt := 0;
        IconCnt := 0;

        VisCnt := GetCurrVisibleCount;

        for I := 0 to ADataList.Count - 1 do
        begin
          AData := ADataList[I];

          if IsBarVisible(AData) then
          begin
            Inc(Cnt);
            if Cnt > VisCnt then
              Inc(IconCnt);
          end;
        end;

        if IconCnt > 0 then
          for I := ADataList.Count - 1 downto 0 do
          begin
            AData := ADataList[I];

            if IsBarVisible(AData) then
            begin
              Dec(IconCnt);

              if IconCnt > -1 then
              begin
                IconSize := SC_NavBarIconSize;
                if (Images <> nil) and (IconSize < Images.Width + SC_NavBarIconSpace) then
                  IconSize := Images.Width + SC_NavBarIconSpace;

                R.Right := R.Left;
                Dec(R.Left, IconSize);

                if PtInRect(R, P) then
                begin
                  Result.Part := scnpIcon;
                  Result.Index := I;

                  Exit;
                end;
              end;
            end;
          end;
      end;
    end;

    if IsShowSplitter then
    begin
      R := GetClientRect;
      R.Top := R.Bottom - GetVisibleBarsHeight;
      R.Bottom := R.Top + GetSplitterHeight;

      if IntersectRect(R, R, CR) and PtInRect(R, P) then
      begin
        Result.Part := scnpSplitter;
        Exit;
      end;
    end;

    if ADataList <> nil then
    begin
      for I := ADataList.Count-1 downto 0 do
      begin
        AData := ADataList[I];

        if IsBarVisible(AData) and IsShowingCaption(AData) then
        begin
          R := GetBarRect(I);

          if not IsRectEmpty(R) and PtInRect(R, P) then
          begin
            with Result do
            begin
              Index := I;
              Part := scnpNavBar;
            end;

            Exit;
          end;
        end;
      end;
    end;
  end;
end;

function TSCCustomNavControl.GetIconBarColor: TColor;
begin
  Result := FColors.BarColor;
  if Result = clNone then
    Result := clBtnFace;
end;

function TSCCustomNavControl.GetIconBarRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if HandleAllocated then
  begin
    Result := GetClientRect;
    Result.Top := Result.Bottom - GetBarHeight;
  end;
end;

procedure TSCCustomNavControl.IndentChanged;
begin
  if BarCount > 0 then
  begin
    UpdateNavBars(False);
    UpdateNavBars(True);
  end;
end;

procedure TSCCustomNavControl.InitializeHitTest(AHitInfo: PSCNavBarHitInfo);
begin
  with AHitInfo^ do
  begin
    X := -1;
    Y := -1;
    Index := -1;
    Clicked := False;
    IsLeftBtn := False;
    Part := scnpNowhere;
  end;
end;

function TSCCustomNavControl.IsShowCloseButton: Boolean;
begin
  Result := scnboShowCloseButton in FOptions;
end;

function TSCCustomNavControl.IsShowHeader: Boolean;
begin
  Result := scnboShowHeader in FOptions;
end;

function TSCCustomNavControl.IsShowingCaption(AData: TSCNavBarData): Boolean;
var
  Data: TSCNavBarData;
  ADataList: TSCNavBarDataList;
  VisCnt, VisibleBars, I: Integer;
begin
  Result := False;

  if (AData <> nil) and IsBarVisible(AData) then
  begin
    ADataList := GetDataList;

    if ADataList <> nil then
    begin
      VisibleBars := GetCurrVisibleCount;

      VisCnt := 0;
      if VisibleBars > 0 then
        for I := 0 to ADataList.Count - 1 do
        begin
          Data := ADataList[I];

          if IsBarVisible(Data) then
          begin
            if VisCnt = VisibleBars then
              Break;

            Inc(VisCnt);
            if AData = Data then
            begin
              Result := True;
              Break;
            end;
          end;
        end;
    end;
  end;
end;

function TSCCustomNavControl.IsShowSplitter: Boolean;
begin
  Result := scnboShowSplitter in FOptions;
end;

function TSCCustomNavControl.IsUseBarColors: Boolean;
begin
  Result := scnboUseBarColors in FOptions;
end;

function TSCCustomNavControl.IsUseGradientHeader: Boolean;
begin
  Result := scnboUseGradientHeader in FOptions;
end;

procedure TSCCustomNavControl.Loaded;
begin
  try
    inherited Loaded;

    UpdateNavBars(True);

    SetBarIndex(-1);
    if FDefaultIndex > -1 then
      SetBarIndex(FDefaultIndex);
  finally
    FControlLoaded := True;
  end;
end;

procedure TSCCustomNavControl.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Designing: Boolean;
  Index, HitNavBar: Integer;
  ADataList: TSCNavBarDataList;
  OldDown, OldHot: TSCNavBarHitInfo;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if ClickFocus and CanFocus then
    SetFocus;

  OldDown := FHitInfo;
  OldHot := FHottrackInfo;

  InitializeHitTest(@FHitInfo);
  InitializeHitTest(@FHottrackInfo);

  FSplitterDownPos := -1;
  
  FHitInfo.x := X;
  FHitInfo.y := Y;

  FHitInfo.Clicked := True;
  FHitInfo.IsLeftBtn := Button = mbLeft;

  FHottrackInfo.x := X;
  FHottrackInfo.y := Y;

  CheckCursorUpdate(FHottrackInfo);

  Designing := IsDesigning;
  
  if Enabled or Designing then
  begin
    FHottrackInfo := GetHitInfo(Point(X, Y));
    if Button = mbLeft then FHitInfo := FHottrackInfo;

    if not IsDesigning then
      UpdateBuffer;

    if Button = mbLeft then
    begin
      MouseIsDown := True;
      ADataList := GetDataList;

      if FHitInfo.Part = scnpSplitter then
        FSplitterDownPos := Y;

      if (FHitInfo.Part in [scnpIcon, scnpNavBar]) and (FHitInfo.Index > -1) and
        (ADataList <> nil) and (FHitInfo.Index < ADataList.Count) and
        (Designing or ADataList[FHitInfo.Index].Enabled) then
      begin
        Index := GetActiveIndex;
        HitNavBar := FHitInfo.Index;
        
        if IsDesigning then
        begin
          InitializeHitTest(@FHitInfo);
          InitializeHitTest(@FHottrackInfo);
        end;

        if (HitNavBar = Index) and not Designing then
          if not CaptureFocus(True) then
            Exit;

        SetBarIndex(HitNavBar);
        if HitNavBar = Index then
          BarClick;
      end;
    end;
  end;
end;

procedure TSCCustomNavControl.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  OldHot: TSCNavBarHitInfo;
begin
  inherited MouseMove(Shift, X, Y);

  if Enabled then
  begin
    OldHot := FHottrackInfo;

    InitializeHitTest(@FHottrackInfo);
    FHottrackInfo := GetHitInfo(Point(X, Y));

    if FHitInfo.Clicked and FHitInfo.IsLeftBtn and
      (FHitInfo.Part = scnpSplitter) then
    begin
      FHottrackInfo.Part := FHitInfo.Part;
      SizeSplitterMove;

      Exit;
    end;

    CheckMouseUpdate(OldHot);
    CheckCursorUpdate(FHottrackInfo);
  end;
end;

procedure TSCCustomNavControl.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldHit, OldHot: TSCNavBarHitInfo;
begin
  inherited MouseUp(Button, Shift, X, Y);

  OldHit := FHitInfo;
  OldHot := FHottrackInfo;

  FSplitterDownPos := -1;

  InitializeHitTest(@FHitInfo);
  InitializeHitTest(@FHottrackInfo);

  if Enabled then
  begin
    FHitInfo.x := X;
    FHitInfo.y := Y;

    FHottrackInfo.x := X;
    FHottrackInfo.y := Y;

    FHottrackInfo := GetHitInfo(Point(X, Y));

    CheckCursorUpdate(FHottrackInfo);

    if not IsDesigning then
      UpdateBuffer;

    if (FHottrackInfo.Part = OldHit.Part) and
      (OldHit.Part = scnpCloseButton) and CanClose then
      CloseClick;

    if (FHottrackInfo.Part = OldHit.Part) and
      (OldHit.Part = scnpMenuButton) then
      MenuClick;
  end;
end;

procedure TSCCustomNavControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = LargeImages) then
    LargeImages := nil;
  if (Operation = opRemove) and (AComponent = OptionsMenu) then
    OptionsMenu := nil
end;

procedure TSCCustomNavControl.Paint;
var
  R: TRect;
begin
  if (FBufferUpdate = 0) and (FPaintBuffer <> nil) then
    Canvas.Draw(0, 0, FPaintBuffer)
  else begin
    R := GetClientRect;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := GetDefaultBackColor;
      FillRect(R);
    end;

    DrawGradientBack(Canvas);
    DrawBars(Canvas);
  end;
end;

procedure TSCCustomNavControl.DrawIconBar(ACanvas: TCanvas);
var
  AColor: TColor;
  Handled: Boolean;
  ARect, R, CR: TRect;
  AData: TSCNavBarData;
  ADataList: TSCNavBarDataList;
  IsHot, IsDown, IsActive: Boolean;
  AImage, AIndex, IconSize,
  SR, Cnt, IconCnt, I, X, Y, VisCnt: Integer;
begin
  ARect := GetIconBarRect;

  if not IsRectEmpty(ARect) then
  begin
    AColor := GetIconBarColor;
    if AColor = clNone then
      AColor := clBtnFace;

    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := AColor;

      FillRect(ARect);
    end;

    DrawButtonFace(ACanvas, ARect, AColor, False, False, False);

    Handled := False;
    
    SR := IntersectClipRect(ACanvas.Handle,
      ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
    try
      if SR <> NULLREGION then
      begin
        if Assigned(FOnCustomDrawIconBar) then
          FOnCustomDrawIconBar(Self, ACanvas, ARect, AColor, Handled);

        if not Handled then
          DoDrawIconBar(ACanvas, ARect, AColor, Handled);
      end;
    finally
      SelectClipRgn(ACanvas.Handle, 0);
    end;

    if not Handled then
    begin
      if AColor = clNone then
      begin
        AColor := GetIconBarColor;
        if AColor = clNone then
          AColor := clBtnFace;
      end;

      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AColor;

        FillRect(ARect);
      end;

      DrawButtonFace(ACanvas, ARect, AColor, False, False, False);
    end;

    CR := GetClientRect;

    R := CR;
    R.Top := R.Bottom - GetBarHeight;

    if not IsRectEmpty(R) then
    begin
      R.Left := R.Right;

      if IsShowMenuButton then
        Dec(R.Left, SC_NavBarMenuButtonSize);

      ADataList := GetDataList;
      
      if ADataList <> nil then
      begin
        Cnt := 0;
        IconCnt := 0;
        VisCnt := GetCurrVisibleCount;

        AIndex := GetActiveIndex;

        for I := 0 to ADataList.Count - 1 do
        begin
          AData := ADataList[I];
          
          if IsBarVisible(AData) then
          begin
            Inc(Cnt);
            if Cnt > VisCnt then
              Inc(IconCnt);
          end;
        end;

        if IconCnt > 0 then
          for I := ADataList.Count - 1 downto 0 do
          begin
            AData := ADataList[I];

            if IsBarVisible(AData) then
            begin
              Dec(IconCnt);
              
              if IconCnt > -1 then
              begin
                IconSize := SC_NavBarIconSize;
                if (Images <> nil) and (IconSize < Images.Width + SC_NavBarIconSpace) then
                  IconSize := Images.Width + SC_NavBarIconSpace;

                R.Right := R.Left;
                Dec(R.Left, IconSize);

                IsHot := False;
                IsDown := False;
                IsActive := I = AIndex;

                if not IsDesigning then
                begin
                  IsDown := (FHitInfo.Part = scnpIcon) and
                    (FHitInfo.Index = I);

                  IsHot := ((FHitInfo.Part = scnpNowhere) or IsDown) and
                    (FHottrackInfo.Part = scnpIcon) and (FHottrackInfo.Index = I);
                end;

                AImage := AData.ImageIndex;
                AColor := GetButtonColor(IsHot, IsDown, IsActive);

                Handled := False;
                
                SR := IntersectClipRect(ACanvas.Handle,
                  ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
                try
                  if SR <> NULLREGION then
                  begin
                    if Assigned(FOnCustomDrawIcon) then
                      FOnCustomDrawIcon(Self, ACanvas, R, IsDown,
                        IsHot, IsActive, AColor, AImage, Handled);

                    if not Handled then
                      DoDrawIcon(ACanvas, R, IsDown, IsHot, IsActive,
                        AColor, AImage, Handled);
                  end;
                finally
                  SelectClipRgn(ACanvas.Handle, 0);
                end;

                if not Handled then
                begin
                  DrawButtonFace(ACanvas, R, AColor, IsDown, IsHot, IsActive);

                  if (Images <> nil) and (AImage > -1) and (AImage < Images.Count) then
                  begin
                    X := R.Left + ((R.Right - R.Left - Images.Width) div 2);
                    Y := R.Top + ((R.Bottom - R.Top - Images.Height) div 2);

                    Images.Draw(ACanvas, X, Y, AImage, Self.Enabled and
                      AData.Enabled);
                  end;
                end;
              end;
            end;
          end;
      end;
    end;
  end;
end;

procedure TSCCustomNavControl.DrawGradientBack(ACanvas: TCanvas);
var
  R: TRect;
  B: Integer;
begin
  if FGradient.Style <> scdgsNone then
  begin
    R := GetCardRect;
    B := GetBorderIndent;

    InflateRect(R, B, B);
    FGradient.Paint(ACanvas, R);
  end;
end;

procedure TSCCustomNavControl.DrawHeader(ACanvas: TCanvas);
var
  AFont: TFont;
  AText: String;
  AColor: TColor;
  ARect, R: TRect;
  Handled: Boolean;
  AData: TSCNavBarData;
  F, SR, AIndex: Integer;
  ADataList: TSCNavBarDataList;
begin
  if IsShowHeader then
  begin
    ARect := GetHeaderRect;

    if not IsRectEmpty(ARect) then
    begin
      AColor := GetHeaderColor;
      
      if AColor = clNone then
        AColor := clBtnFace;

      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AColor;

        FillRect(ARect);
      end;

      if IsUseGradientHeader then
      begin
        FGradientPainter.ColorBegin := GetGradientExLight(AColor);
        FGradientPainter.ColorEnd := AColor;

        FGradientPainter.Paint(ACanvas, ARect);
      end;

      R := ARect;
      Inc(R.Right);

      scFrame3D(ACanvas, R, GetBtnHighlightOf(AColor), AColor, 1, 0);

      AText := '';
      ADataList := GetDataList;

      if ADataList <> nil then
      begin
        AIndex := GetActiveIndex;

        if (AIndex > -1) and (AIndex < ADataList.Count) then
        begin
          AData := ADataList[AIndex];
          AText := AData.Caption;
        end;
      end;

      AFont := TFont.Create;
      try
        AFont.Assign(Self.HeaderFont);

        if AFont.Color = clNone then
          AFont.Color := clBtnText;

        SR := IntersectClipRect(ACanvas.Handle,
          ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
        try
          if SR <> NULLREGION then
          begin
            Handled := False;

            if Assigned(FOnCustomDrawHeader) then
              FOnCustomDrawHeader(Self, ACanvas, ARect, AFont,
                AColor, AText, Handled);

            if not Handled then
              DoDrawHeader(ACanvas, ARect, AFont, AColor, AText, Handled);

            if Handled then
              Exit;
          end;
        finally
          SelectClipRgn(ACanvas.Handle, 0);
        end;

        if AColor = clNone then
        begin
          AColor := GetHeaderColor;
          if AColor = clNone then
            AColor := clBtnFace;
        end;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := AColor;

          FillRect(ARect);
        end;

        if IsUseGradientHeader then
        begin
          FGradientPainter.ColorBegin := GetGradientExLight(AColor);
          FGradientPainter.ColorEnd := AColor;

          FGradientPainter.Paint(ACanvas, ARect);
        end;

        R := ARect;
        Inc(R.Right);

        scFrame3D(ACanvas, R, GetBtnHighlightOf(AColor), AColor, 1, 0);

        if AText <> '' then
        begin
          R := ARect;
          InflateRect(R, -SC_NavBarHorzBarSpacing, 0);

          if IsShowCloseButton then
            Dec(R.Right, SC_NavBarCloseButtonSize);

          if not IsRectEmpty(R) then
          begin
            SR := IntersectClipRect(ACanvas.Handle,
              R.Left, R.Top, R.Right, R.Bottom);
            try
              if SR <> NULLREGION then
              begin
                F := DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or
                  DT_END_ELLIPSIS or DT_LEFT;

                if AFont.Color = clNone then
                  AFont.Color := clBtnText;

                with ACanvas do
                begin
                  Font.Assign(AFont);
                  Brush.Style := bsClear;

                  Windows.DrawText(ACanvas.Handle, PChar(AText),
                    Length(AText), R, F);
                end;
              end;
            finally
              SelectClipRgn(ACanvas.Handle, 0);
            end;
          end;
        end;

        AColor := GetFrameColor;

        with ACanvas do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := AColor;

          MoveTo(ARect.Left, ARect.Bottom - 1);
          LineTo(ARect.Right, ARect.Bottom - 1);
        end;
      finally
        AFont.Free;
      end;
    end;
  end;
end;

procedure TSCCustomNavControl.SetBarFont(Value: TFont);
begin
  FBarFont.Assign(Value);
end;

procedure TSCCustomNavControl.SetBarHeight(Value: Integer);
begin
  if Value < -1 then Value := -1;

  if FBarHeight <> Value then
  begin
    FBarHeight := Value;
    if not (IsLoading or IsReading) then
      UpdateNavBars(True);
  end;
end;

procedure TSCCustomNavControl.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;
  inherited SetIndent(Value);
end;

procedure TSCCustomNavControl.SetLargeImages(Value: TCustomImageList);
var
  OldImages: TCustomImageList;
begin
  OldImages := FLargeImages;
  
  if FLargeImages <> nil then
  begin
  {$IFDEF SC_DELPHI5_UP}
    FLargeImages.RemoveFreeNotification(Self);
  {$ENDIF}
    FLargeImages.UnRegisterChanges(FLargeImgChangeLink);
  end;

  FLargeImages := Value;
  if FLargeImages <> nil then
  begin
    FLargeImages.RegisterChanges(FLargeImgChangeLink);
    FLargeImages.FreeNotification(Self);
  end;

  if OldImages <> FLargeImages then
  begin
    Invalidate;
    ImageListChange(FLargeImages);
  end;
end;

procedure TSCCustomNavControl.SetOptions(Value: TSCNavBarOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;

    if not (IsLoading or IsReading) then
    begin
      UpdateBuffer;
      UpdateNavBars(True);

      if (Parent <> nil) and not IsUseBarColors then
        Perform(CM_COLORCHANGED, 0, 0);
    end;

    DoOptionsChanged;
  end;
end;

procedure TSCCustomNavControl.SetStyle(Value: TSCNavBarStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    if not (IsLoading or IsReading) then
    begin
      UpdateHottrackInfo;
      UpdateNavBars(True);
    end;
  end;
end;

procedure TSCCustomNavControl.SetVisibleBarCount(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FVisibleBarCount <> Value then
  begin
    if FControlLoaded or IsDesigning then
      FCurrVisibleBars := -1;

    FVisibleBarCount := Value;

    UpdateBuffer;
    UpdateNavBars(True);
  end;
end;

procedure TSCCustomNavControl.SetColors(Value: TSCNavBarColors);
begin
  FColors.Assign(Value);
end;

procedure TSCCustomNavControl.SetGradient(Value: TSCNavBackGradient);
begin
  FGradient.Assign(Value);
end;

procedure TSCCustomNavControl.SetHeaderFont(Value: TFont);
begin
  FHeaderFont.Assign(Value);
end;

procedure TSCCustomNavControl.SetBarIndex(Value: Integer);
var
  Allowed: Boolean;
begin
  if IsLoading or IsReading then
  begin
    FBarIndex := Value;
    Exit;
  end;

  if Value < -1 then Value := -1;
  Value := CheckVisible(Value);

  if FBarIndex <> Value then
  begin
    Allowed := True;
    Changing(Value, Allowed);

    if Allowed then
    begin
      FBarIndex := Value;
      BarIndexChanged;

      UpdateDesigner;
    end;
  end;
end;

procedure TSCCustomNavControl.StoreCalcValues;
begin
  //
end;

function TSCCustomNavControl.BarAtPos(const P: TPoint): Integer;
var
  Hit: TSCNavBarHitInfo;
begin
  Hit := GetHitInfo(P);
  Result := Hit.Index;
end;

procedure TSCCustomNavControl.BarClick;
begin
  if Assigned(FOnBarClick) then
    FOnBarClick(Self);
end;

procedure TSCCustomNavControl.BarFontChanged(Sender: TObject);
begin
  UpdateBuffer;
  Self.Realign;
end;

procedure TSCCustomNavControl.BarIndexChanged;
begin
  UpdateNavBars;
  DoBarIndexChanged;

  Change;
  if Assigned(FOnBarChange) then
    FOnBarChange(Self);
end;

procedure TSCCustomNavControl.CheckMouseUpdate(OldHot: TSCNavBarHitInfo);
var
  IsHot, WasHot, NeedsUpdate: Boolean;
begin
  if Enabled and not IsDesigning then
  begin
    NeedsUpdate := (FHitInfo.Part in [scnpNowhere, scnpNavBar, scnpIcon]) and
      (OldHot.Index <> FHottrackInfo.Index);

    if not NeedsUpdate then
    begin
      WasHot := OldHot.Part in SC_NavBarHotParts;
      IsHot := FHottrackInfo.Part in SC_NavBarHotParts;

      NeedsUpdate := ((FHitInfo.Part = scnpNowhere) or (FHitInfo.Part in SC_NavBarHotParts)) and
        ((IsHot <> WasHot) or (IsHot and (FHottrackInfo.Part <> OldHot.Part)));

      if not NeedsUpdate then
      begin
        if IsShowMenuButton then
        begin
          WasHot := OldHot.Part = scnpMenuButton;
          IsHot := FHottrackInfo.Part = scnpMenuButton;

          NeedsUpdate := (FHitInfo.Part in [scnpNowhere, scnpMenuButton]) and
            (IsHot <> WasHot);
        end;

        if not NeedsUpdate and IsShowHeader and IsShowCloseButton then
        begin
          WasHot := OldHot.Part = scnpCloseButton;
          IsHot := FHottrackInfo.Part = scnpCloseButton;

          NeedsUpdate := (FHitInfo.Part in [scnpNowhere, scnpCloseButton]) and
            (IsHot <> WasHot);
        end;
      end;
    end;

    if NeedsUpdate then
      UpdateBuffer;
  end;
end;

procedure TSCCustomNavControl.UpdateBuffer(Repaint: Boolean);
var
  OldDC: THandle;
begin
  if FPaintBuffer <> nil then
  begin
    Inc(FBufferUpdate);
    try
      OldDC := Canvas.Handle;
      try
        Canvas.Handle := FPaintBuffer.Canvas.Handle;
        Paint;
      finally
        Canvas.Handle := OldDC;
      end;
    finally
      Dec(FBufferUpdate);
    end;

    if Repaint and (FBufferUpdate = 0) then
      Invalidate;
  end;
end;

procedure TSCCustomNavControl.UpdateNavBars(Realign: Boolean = False);
var
  ADataList: TSCNavBarDataList;
begin
  if HandleAllocated and not (IsLoading or IsDestroying) then
  begin
    StoreCalcValues;

    ADataList := GetDataList;
    if ADataList <> nil then
      ADataList.Clear;

    FillDataList;

    StoreCalcValues;
    UpdateBuffer;

    SetBarIndex(GetActiveIndex);
    if Realign then
      Self.Realign;
  end;
end;

procedure TSCCustomNavControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TSCCustomNavControl.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TSCCustomNavControl.WMNCHitTest(var Message: TWMNCHitTest);
var
  P: TPoint;
begin
  DefaultHandler(Message);

  if IsDesigning then
  begin
    P := SmallPointToPoint(Message.Pos);
    FHottrackInfo := GetHitInfo(Self.ScreenToClient(P));
  end;
end;

procedure TSCCustomNavControl.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;

  if FPaintBuffer <> nil then
  begin
    W := ClientWidth;
    if W < 0 then W := 0;

    H := ClientHeight;
    if H < 0 then H := 0;

    FPaintBuffer.Width := W;
    FPaintBuffer.Height := H;

    UpdateBuffer;
  end;

  UpdateNavBars(True);
end;

function TSCCustomNavControl.GetBorderIndent: Integer;
begin
  Result := 0;
end;

function TSCCustomNavControl.GetCardRect: TRect;
var
  AData: TSCNavBarData;
  I, B, H, VisCnt: Integer;
  ADataList: TSCNavBarDataList;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated then
  begin
    Result := GetClientRect;

    H := GetBarHeight;
    if H < 0 then H := 0;

    Dec(Result.Bottom, H);

    VisCnt := GetCurrVisibleCount;

    if VisCnt > 0 then
    begin
      ADataList := GetDataList;

      if ADataList <> nil then
        for I := 0 to ADataList.Count - 1 do
          if (I < VisCnt) then
          begin
            AData := ADataList[I];
            if IsBarVisible(AData) then
            begin
              H := GetBarHeight(I);
              if H > 0 then Dec(Result.Bottom, H);
            end;
          end;
    end;

    if IsShowSplitter then
    begin
      H := GetSplitterHeight;
      if H < 0 then H := 0;

      Dec(Result.Bottom, H);
    end;

    if IsShowHeader then
    begin
      H := GetHeaderHeight;
      if H < 0 then H := 0;

      Inc(Result.Top, H);
    end;

    B := GetBorderIndent;
    InflateRect(Result, -B, -B);
  end;
end;

function TSCCustomNavControl.GetDefaultBackColor: TColor;
begin
  Result := Self.Color;
  if Result = clNone then
    Result := clWindow;
end;

function TSCCustomNavControl.GetVisibleBarCount: Integer;
var
  VisibleBars, I: Integer;
  ADataList: TSCNavBarDataList;
begin
  Result := 0;
  VisibleBars := GetCurrVisibleCount;

  if VisibleBars > 0 then
  begin
    ADataList := GetDataList;
    
    if ADataList <> nil then
      for I := 0 to ADataList.Count - 1 do
        if IsBarVisible(ADataList[I]) then
        begin
          if Result = VisibleBars then
            Break;

          Inc(Result);
        end;
  end;
end;

function TSCCustomNavControl.GetVisibleBarsHeight: Integer;
var
  AData: TSCNavBarData;
  I, H, Cnt, VisCnt: Integer;
  ADataList: TSCNavBarDataList;
begin
  Result := 0;

  H := GetBarHeight;
  if H > 0 then Inc(Result, H);

  VisCnt := GetCurrVisibleCount;

  if VisCnt > 0 then
  begin
    ADataList := GetDataList;

    if ADataList <> nil then
    begin
      Cnt := 0;

      for I := 0 to ADataList.Count - 1 do
      begin
        AData := ADataList[I];

        if IsBarVisible(AData) then
        begin
          Inc(Cnt);
          if Cnt > VisCnt then
            Break;

          H := GetBarHeight(I);
          if H > 0 then Inc(Result, H);
        end;
      end;
    end;
  end;

  if IsShowSplitter then
  begin
    H := GetSplitterHeight;
    if H > 0 then Inc(Result, H);
  end;
end;

procedure TSCCustomNavControl.UpdateHottrackInfo;
var
  P: TPoint;
  OldHot: TSCNavBarHitInfo;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);

  OldHot := FHottrackInfo;
  InitializeHitTest(@FHottrackInfo);

  FHottrackInfo.X := P.x;
  FHottrackInfo.Y := P.y;

  if not IsDesigning then
    FHottrackInfo := GetHitInfo(P);

  CheckMouseUpdate(OldHot);
  CheckCursorUpdate(FHottrackInfo);
end;

function TSCCustomNavControl.GetFirstVisibleNavBar: Integer;
var
  I: Integer;
  AData: TSCNavBarData;
  ADataList: TSCNavBarDataList;
begin
  Result := -1;
  ADataList := GetDataList;

  if ADataList <> nil then
    for I := 0 to ADataList.Count-1 do
    begin
      AData := ADataList[I];
      if IsBarVisible(AData) and IsShowingCaption(AData) then
      begin
        Result :=  I;
        Break;
      end;
    end;
end;

function TSCCustomNavControl.GetLargeImages: TCustomImageList;
begin
  Result := FLargeImages;
  if Result = nil then Result := Images;
end;

function TSCCustomNavControl.GetLastVisibleNavBar: Integer;
var
  I: Integer;
  AData: TSCNavBarData;
  ADataList: TSCNavBarDataList;
begin
  Result := -1;
  ADataList := GetDataList;

  if ADataList <> nil then
    for I := 0 to ADataList.Count-1 do
    begin
      AData := ADataList[I];
      if IsBarVisible(AData) then
        Result := I;
    end;
end;

function TSCCustomNavControl.GetMinBarHeight: Integer;
begin
  Result := FDefaultBarHeight;
  if HandleAllocated and (Result = -1) then
  begin
    Canvas.Font.Assign(Self.Font);
    FDefaultBarHeight := Canvas.TextHeight('Rq') + 2;

    if (Images <> nil) and (FDefaultBarHeight < Images.Height) then
      FDefaultBarHeight := Images.Height;

    Inc(FDefaultBarHeight, 2*SC_NavBarVertBarSpacing);
    Result := FDefaultBarHeight;
  end;
end;

procedure TSCCustomNavControl.CloseClick;
begin
  DoCloseClick;
end;

procedure TSCCustomNavControl.DoBarIndexChanged;
begin
  //
end;

procedure TSCCustomNavControl.DoCloseClick;
begin
  //
end;

procedure TSCCustomNavControl.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  UpdateHottrackInfo;
end;

procedure TSCCustomNavControl.CMMouseLeave(var Message: TMessage);
var
  OldHot: TSCNavBarHitInfo;
begin
  inherited;

  if not IsDesigning then
  begin
    OldHot := FHottrackInfo;
    InitializeHitTest(@FHottrackInfo);

    CheckMouseUpdate(OldHot);
    CheckCursorUpdate(FHottrackInfo);
  end;
end;

procedure TSCCustomNavControl.StopTracking;
begin
  inherited StopTracking;

  CancelSplitterMove;

  InitializeHitTest(@FHitInfo);
  UpdateHottrackInfo;
end;

function TSCCustomNavControl.GetVisibleIndexOf(AData: TSCNavBarData): Integer;
var
  I, J: Integer;
  Data: TSCNavBarData;
  ADataList: TSCNavBarDataList;
begin
  Result := -1;
  if (AData <> nil) and IsBarVisible(AData) then
  begin
    ADataList := GetDataList;

    if ADataList <> nil then
    begin
      J := 0;
      for I := 0 to ADataList.Count - 1 do
      begin
        Data := ADataList[I];
        if IsBarVisible(Data) then
        begin
          if AData = Data then
          begin
            Result := J;
            Break;
          end;

          Inc(J);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomNavControl.GradientChanged(Sender: TObject);
begin
  UpdateBuffer;
end;

procedure TSCCustomNavControl.ImageListChange(Sender: TObject);
begin
  inherited ImageListChange(Sender);
  UpdateNavBars(True);
end;

procedure TSCCustomNavControl.SetImageSpacing(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if Value > 100 then Value := 100;

  if FImageSpacing <> Value then
  begin
    FImageSpacing := Value;
    
    if (BarCount > 0) and not (IsLoading or IsReading) then
    begin
      UpdateHottrackInfo;
      UpdateNavBars(True);
    end;
  end;
end;

function TSCCustomNavControl.CanClose: Boolean;
begin
  Result := True;
  if Assigned(FOnBarClose) then FOnBarClose(Self, Result);
end;

procedure TSCCustomNavControl.Changing(NewIndex: Integer;
  var Allowed: Boolean);
begin
  Allowed := True;
  if FControlLoaded and Assigned(FOnBarChanging) then
    FOnBarChanging(Self, NewIndex, Allowed);
end;

procedure TSCCustomNavControl.ActiveNavBarMoved(Index: Integer);
begin
  //
end;

procedure TSCCustomNavControl.DestroyActiveNavBar;
begin
  //
end;

procedure TSCCustomNavControl.CloseActiveNavBar;
begin
  if (FBarIndex <> -1) and CanClose then
    DestroyActiveNavBar;
end;

procedure TSCCustomNavControl.HeaderFontChanged(Sender: TObject);
begin
  FDefaultHeaderHeight := -1;

  UpdateBuffer;
  Self.Realign;
end;

procedure TSCCustomNavControl.HideAllBars;
begin
  //
end;

procedure TSCCustomNavControl.ShowAllBars;
begin
  //
end;

function TSCCustomNavControl.GetDataList: TSCNavBarDataList;
begin
  Result := FDataList;
end;

function TSCCustomNavControl.GetNavBarImage(AData: TSCNavBarData): TImageIndex;
var
  ImageList: TCustomImageList;
begin
  Result := -1;
  ImageList := GetImages;

  if (ImageList <> nil) and (ImageList.Count > 0) then
    Result := AData.ImageIndex;
end;

procedure TSCCustomNavControl.SetAlignment(Value: TLeftRight);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    if BarCount > 0 then
      UpdateBuffer;
  end;
end;

function TSCCustomNavControl.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCNavBarBorderProps;
end;

function TSCCustomNavControl.IsShowMenuButton: Boolean;
begin
  Result := scnboShowMenuButton in FOptions;
end;

function TSCCustomNavControl.GetButtonColor(IsHot, IsDown,
  IsActive: Boolean): TColor;
begin
  Result := clNone;

  if FStyle = scnbOfficeXP then
  begin
    if IsActive then
    begin
      if IsHot or (IsHot and IsDown) then
        Result := GetOfficeXPDownedSelColor
      else
        Result := GetOfficeXPDownedColor;
    end else
    if IsHot and IsDown then
      Result := GetOfficeXPDownedSelColor
    else
    if IsHot or IsDown then
      Result := GetOfficeXPSelColor;
  end else
  if FStyle = scnbOffice12 then
  begin
    Result := clNone;

    if IsDown or IsHot or IsActive then
    begin
      Result := FColors.HighlightColor;

      if IsActive then
      begin
        if IsHot or (IsHot and IsDown) then
          Result := scBlendColor(Result, -12)
        else
          Result := scBlendColor(Result, 20);
      end else
      if IsHot and IsDown then
        Result := scBlendColor(Result, -16)
      else
      if IsHot or IsDown then
        Result := scBlendColor(Result, -6);
    end;
  end else
  begin
    Result := clNone;

    if IsDown or IsHot or IsActive then
    begin
      Result := FColors.HighlightColor;

      if IsActive then
      begin
        if IsHot or (IsHot and IsDown) then
          Result := scBlendColor(Result, -24);
      end else
      if IsHot and IsDown then
        Result := scBlendColor(Result, -16)
      else
      if IsDown then
        Result := scBlendColor(Result, -8)
      else
      if IsHot then
        Result := scBlendColor(Result, 20);
    end;
  end;
end;

procedure TSCCustomNavControl.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('CurrActiveBar', ReadActiveData, WriteActiveData, True);
  Filer.DefineProperty('CurrVisibleCount', ReadVisibleData, WriteVisibleData, True);
end;

procedure TSCCustomNavControl.ReadActiveData(Reader: TReader);
begin
  FDefaultIndex := StrToIntDef(Reader.ReadString, -1);
end;

procedure TSCCustomNavControl.ReadVisibleData(Reader: TReader);
begin
  FCurrVisibleBars := StrToIntDef(Reader.ReadString, -1);
end;

procedure TSCCustomNavControl.WriteActiveData(Writer: TWriter);
begin
  Writer.WriteString(IntToStr(FBarIndex));
end;

procedure TSCCustomNavControl.WriteVisibleData(Writer: TWriter);
begin
  Writer.WriteString(IntToStr(FCurrVisibleBars));
end;

procedure TSCCustomNavControl.UpdateDesigner;
var
  AParent: TCustomForm;
begin
  if HandleAllocated and IsDesigning and not IsUpdating then
  begin
    AParent := GetParentForm(Self);
    if (AParent <> nil) and Assigned(AParent.Designer) then
      AParent.Designer.Modified;
  end;
end;

procedure TSCCustomNavControl.DrawCloseButton(ACanvas: TCanvas);
var
  ARect, R: TRect;
  Handled: Boolean;
  X, Y, SR: Integer;
  IsDown, IsHot: Boolean;
  AColor, AForeColor: TColor;
begin
  if IsShowHeader and IsShowCloseButton then
  begin
    ARect := GetCloseButtonRect;

    if not IsRectEmpty(ARect) then
    begin
      IsHot := False;
      IsDown := False;

      if not IsDesigning then
      begin
        IsHot := FHottrackInfo.Part = scnpCloseButton;
        IsDown := FHitInfo.Part = scnpCloseButton;
      end;

      AColor := GetButtonColor(IsHot, IsDown, False);
      AForeColor := GetButtonTextColor(IsHot, IsDown, False);

      if AColor <> clNone then
        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := AColor;

          FillRect(ARect);
        end;

      with ACanvas do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := GetBtnHighlightOf(AColor);

        MoveTo(ARect.Left, ARect.Top);
        LineTo(ARect.Right, ARect.Top);
      end;

      SR := IntersectClipRect(ACanvas.Handle,
        ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
      try
        if SR <> NULLREGION then
        begin
          Handled := False;

          if Assigned(FOnCustomDrawCloseButton) then
            FOnCustomDrawCloseButton(Self, ACanvas, ARect, IsDown,
              IsHot, AColor, AForeColor, Handled);

          if not Handled then
            DoDrawCloseButton(ACanvas, ARect, IsDown, IsHot,
              AColor, AForeColor, Handled);

          if Handled then
            Exit;
        end;
      finally
        SelectClipRgn(ACanvas.Handle, 0);
      end;

      DrawButtonFace(ACanvas, ARect, AColor, IsDown, IsHot, IsActive);

      with ACanvas do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := GetBtnHighlightOf(AColor);

        MoveTo(ARect.Left, ARect.Top);
        LineTo(ARect.Right, ARect.Top);
      end;

      if AForeColor <> clNone then
        with ACanvas do
        begin
          Brush.Style := bsClear;

          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Color := AForeColor;
          Pen.Width := 1;

          R := ARect;

          X := R.Left + ((R.Right - R.Left) div 2) - 3;
          Y := R.Top + ((R.Bottom - R.Top - 6) div 2);

          MoveTo(X, Y);
          LineTo(X + 6, Y + 6);

          MoveTo(X + 1, Y);
          LineTo(X + 7, Y + 6);

          MoveTo(X + 5, Y);
          LineTo(X - 1, Y + 6);

          MoveTo(X + 6, Y);
          LineTo(X, Y + 6);
        end;
    end;
  end;
end;

procedure TSCCustomNavControl.DrawMenuButton(ACanvas: TCanvas);
var
  ARect, R: TRect;
  Handled: Boolean;
  I, X, Y, SR: Integer;
  IsDown, IsHot: Boolean;
  AColor, AForeColor: TColor;
begin
  if IsShowMenuButton then
  begin
    ARect := GetMenuButtonRect;

    if not IsRectEmpty(ARect) then
    begin
      IsHot := False;
      IsDown := False;

      if not IsDesigning then
      begin
        IsHot := FHottrackInfo.Part = scnpMenuButton;
        IsDown := FHitInfo.Part = scnpMenuButton;
      end;

      AColor := GetButtonColor(IsHot, IsDown, False);
      AForeColor := GetButtonTextColor(IsHot, IsDown, False);

      if AColor <> clNone then
        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := AColor;

          FillRect(ARect);
        end;

      SR := IntersectClipRect(ACanvas.Handle,
        ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
      try
        if SR <> NULLREGION then
        begin
          Handled := False;

          if Assigned(FOnCustomDrawMenuButton) then
            FOnCustomDrawMenuButton(Self, ACanvas, ARect, IsDown,
              IsHot, AColor, AForeColor, Handled);

          if not Handled then
            DoDrawMenuButton(ACanvas, ARect, IsDown, IsHot,
              AColor, AForeColor, Handled);

          if Handled then
            Exit;
        end;
      finally
        SelectClipRgn(ACanvas.Handle, 0);
      end;

      DrawButtonFace(ACanvas, ARect, AColor, IsDown, IsHot, IsActive);

      if AForeColor <> clNone then
        with ACanvas do
        begin
          Brush.Style := bsClear;

          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Color := AForeColor;
          Pen.Width := 1;

          R := ARect;

          X := R.Left + ((R.Right - R.Left) div 2) - 3;
          Y := R.Top + ((R.Bottom - R.Top - 12) div 2);

          for I := 0 to 3 do
          begin
            MoveTo(X, Y);
            LineTo(X + 2, Y + 2);
            LineTo(X - 1, Y + 5);

            Inc(X);
            if I = 1 then
              Inc(X);
          end;

          X := R.Left + ((R.Right - R.Left) div 2) - 2;
          Y := R.Top + ((R.Bottom - R.Top - 12) div 2) + 9;

          for I := 0 to 2 do
          begin
            MoveTo(X + I, Y + I);
            LineTo(X + 5 - I, Y + I);
          end;
        end;
    end;
  end;
end;

function TSCCustomNavControl.GetCloseButtonRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if HandleAllocated and IsShowHeader and IsShowCloseButton then
  begin
    Result := GetClientRect;

    Result.Bottom := Result.Top + GetHeaderHeight - 1;
    Result.Left := Result.Right - SC_NavBarCloseButtonSize;
  end;
end;

function TSCCustomNavControl.GetMenuButtonRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if HandleAllocated and IsShowMenuButton then
  begin
    Result := GetClientRect;

    Result.Top := Result.Bottom - GetBarHeight;
    Result.Left := Result.Right - SC_NavBarMenuButtonSize;
  end;
end;

procedure TSCCustomNavControl.CMCursorChanged(var Message: TMessage);
begin
  inherited;
  if not FCursorChange then FDefaultCursor := Cursor;
end;

procedure TSCCustomNavControl.ChangeCursor(ACursor: TCursor);
begin
  FCursorChange := True;
  try
    if (Cursor <> ACursor) and not IsDesigning then
      Cursor := ACursor;
  finally
    FCursorChange := False;
  end;
end;

procedure TSCCustomNavControl.CheckCursorUpdate(AHitInfo: TSCNavBarHitInfo);
var
  ACursor: TCursor;
begin
  ACursor := FDefaultCursor;
  
  if ((FHitInfo.Part = scnpNowhere) and (AHitInfo.Part = scnpSplitter)) or
    (FHitInfo.Clicked and FHitInfo.IsLeftBtn and (FHitInfo.Part = scnpSplitter)) then
    ACursor := crSizeNS;

  ChangeCursor(ACursor);
end;

function TSCCustomNavControl.GetButtonTextColor(IsHot, IsDown,
  IsActive: Boolean): TColor;
begin
  Result := FColors.ButtonIconColor;

  if FStyle = scnbOfficeXP then
  begin
    if IsActive and IsHot then
      Result := clHighlightText
    else
    if not IsActive and IsHot and IsDown then
      Result := clHighlightText;
  end;
end;

procedure TSCCustomNavControl.CancelSplitterMove;
begin
  FSplitterDownPos := -1;

  if FHitInfo.Clicked and FHitInfo.IsLeftBtn and
    (FHitInfo.Part = scnpSplitter) then
  begin
    MouseIsDown := False;
    InitializeHitTest(@FHitInfo);

    UpdateHottrackInfo;
    CheckCursorUpdate(FHottrackInfo);
    SetCursor(Screen.Cursors[Self.Cursor]);

    UpdateBuffer;
  end;
end;

procedure TSCCustomNavControl.SizeSplitterMove;
var
  AData: TSCNavBarData;
  ADataList: TSCNavBarDataList;
  I, H, Cnt, OldCnt, NewCnt, ADif: Integer;
begin
  if FHitInfo.Clicked and FHitInfo.IsLeftBtn and
    (FHitInfo.Part = scnpSplitter) and (VisibleBarCount > 0) then
  begin
    ADif := FHottrackInfo.Y - FSplitterDownPos;

    if ADif <> 0 then
    begin
      ADataList := GetDataList;

      if ADataList <> nil then
      begin
        OldCnt := GetVisibleBarCount;
        NewCnt := OldCnt;

        if (ADif > 0) and (OldCnt > 0) then
        begin
          for I := 0 to ADataList.Count-1 do
          begin
            AData := ADataList[I];

            if IsBarVisible(AData) then
            begin
              H := GetBarHeight(I);
              Dec(ADif, H);

              if ADif >= 0 then
                Dec(NewCnt);

              if ADif <= 0 then
                Break;
            end;
          end;
        end else
        if (ADif < 0) and (OldCnt < ADataList.Count) and
          (FCurrVisibleBars > -1) and (FCurrVisibleBars < VisibleBarCount) then
        begin
          Cnt := 0;

          for I := 0 to ADataList.Count-1 do
          begin
            AData := ADataList[I];

            if IsBarVisible(AData) then
            begin
              Inc(Cnt);

              if Cnt > OldCnt then
              begin
                H := GetBarHeight(I);
                Inc(ADif, H);

                if ADif <= 0 then
                  Inc(NewCnt);

                if ADif >= 0 then
                  Break;
              end;
            end;
          end;
        end;

        if NewCnt < 0 then NewCnt := 0;

        if NewCnt > VisibleBarCount then
          NewCnt := VisibleBarCount;

        if NewCnt <> OldCnt then
        begin
          FCurrVisibleBars := NewCnt;
          FSplitterDownPos := FHottrackInfo.Y;

          UpdateBuffer;
          Self.Realign;

          UpdateHottrackInfo;
          UpdateDesigner;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomNavControl.CNChar(var Message: TWMChar);
begin
  if FHitInfo.Clicked and FHitInfo.IsLeftBtn and
    (FHitInfo.Part = scnpSplitter) then
  begin
    CancelSplitterMove;
    Exit;
  end;

  inherited;
end;

function TSCCustomNavControl.GetCurrVisibleCount: Integer;
begin
  Result := FCurrVisibleBars;
  if (Result = -1) or (Result > FVisibleBarCount) then
    Result := FVisibleBarCount;
end;

function TSCCustomNavControl.GetGradientDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -32);
end;

function TSCCustomNavControl.CanShowMenu: Boolean;
begin
  Result := True;
  if Assigned(FOnShowMenu) then FOnShowMenu(Self, Result);
end;

procedure TSCCustomNavControl.MenuClick;
var
  R: TRect;
  P: TPoint;
  APopup: TPopupMenu;
begin
  if CanShowMenu and not DoMenuClick then
  begin
    if IsShowMenuButton then
      R := GetMenuButtonRect
    else begin
      R := GetClientRect;
      R.Top := R.Bottom - GetBarHeight;
    end;

    P := Point(R.Right, R.Top + ((R.Bottom - R.Top) div 2));

    if P.x < 0 then P.x := 0;
    if P.y < 0 then P.y := 0;

    P := Self.ClientToScreen(P);

    APopup := GetOptionsMenu;
    if (APopup <> nil) and APopup.AutoPopup then
    begin
      SendCancelMode(nil);
      APopup.PopupComponent := Self;

      APopup.Popup(P.x, P.y);
      UpdateHottrackInfo;
    end;
  end;
end;

function TSCCustomNavControl.DoMenuClick: Boolean;
begin
  Result := False;
end;

procedure TSCCustomNavControl.SetOptionsMenu(Value: TPopupMenu);
begin
  FOptionsMenu := Value;
  if Value <> nil then
  begin
    Value.ParentBiDiModeChanged(Self);
    Value.FreeNotification(Self);
  end;
end;

function TSCCustomNavControl.GetOptionsMenu: TPopupMenu;
begin
  Result := FOptionsMenu;
end;

procedure TSCCustomNavControl.DoDrawBar(ACanvas: TCanvas;
  AData: TSCNavBarData; ARect: TRect; ADown, AHot, AActive,
  AExpanded: Boolean; AFont: TFont; var AColor: TColor;
  var AImage: Integer; var AText: string; var Handled: Boolean);
begin
  //
end;

procedure TSCCustomNavControl.DoDrawCloseButton(ACanvas: TCanvas;
  ARect: TRect; ADown, AHot: Boolean; var ABackColor, AForeColor: TColor;
  var Handled: Boolean);
begin
  //
end;

procedure TSCCustomNavControl.DoDrawHeader(ACanvas: TCanvas; ARect: TRect;
  AFont: TFont; var AColor: TColor; var AText: string;
  var Handled: Boolean);
begin
  //
end;

procedure TSCCustomNavControl.DoDrawIconBar(ACanvas: TCanvas; ARect: TRect;
  var AColor: TColor; var Handled: Boolean);
begin
  //
end;

procedure TSCCustomNavControl.DoDrawMenuButton(ACanvas: TCanvas;
  ARect: TRect; ADown, AHot: Boolean; var ABackColor, AForeColor: TColor;
  var Handled: Boolean);
begin
  //
end;

procedure TSCCustomNavControl.DoDrawSplitter(ACanvas: TCanvas;
  ARect: TRect; var AColor: TColor; var Handled: Boolean);
begin
  //
end;

procedure TSCCustomNavControl.DoDrawIcon(ACanvas: TCanvas; ARect: TRect;
  ADown, AHot, AActive: Boolean; var AColor: TColor; var AImage: Integer;
  var Handled: Boolean);
begin
  //
end;

function TSCCustomNavControl.IsBarVisible(AData: TSCNavBarData): Boolean;
begin
  Result := IsDesigning or ((AData <> nil) and AData.Visible);
end;

procedure TSCCustomNavControl.DrawButtonFace(ACanvas: TCanvas;
  ARect: TRect; AColor: TColor; IsDown, IsHot, IsActive: Boolean);
var
  R: TRect;
begin
  if (AColor <> clNone) and not IsRectEmpty(ARect) then
  begin
    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := AColor;

      FillRect(ARect);
    end;

    case FStyle of
      scnbOfficeXP:
      begin
        if not (IsHot or IsDown or IsActive) then
        begin
          FGradientPainter.ColorBegin := GetGradientPreLight(AColor);
          FGradientPainter.ColorEnd := GetGradientShadow(AColor);

          FGradientPainter.Paint(ACanvas, ARect);
        end;
      end;
      scnbOffice11:
      begin
        FGradientPainter.ColorBegin := GetGradientPreLight(AColor);
        FGradientPainter.ColorEnd := GetGradientShadow(AColor);

        FGradientPainter.Paint(ACanvas, ARect);
      end;
      scnbOffice12:
      begin
        FGradientPainter.ColorBegin := GetGradientPeal(AColor);
        FGradientPainter.ColorEnd := AColor;

        FGradientPainter.Paint(ACanvas, ARect);

        R := ARect;
        Inc(R.Top, Round(2*(R.Bottom - R.Top) / 5));

        if not IsRectEmpty(R) then
        begin
          FGradientPainter.ColorBegin := GetGradientShadow(AColor);
          FGradientPainter.ColorEnd := GetGradientLight(AColor);

          FGradientPainter.Paint(ACanvas, R);
        end;
      end;
    end;
  end;
end;

function TSCCustomNavControl.GetGradientShadow(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -6);
end;

function TSCCustomNavControl.GetGradientPeal(AColor: TColor): TColor;
begin
  Result := BlendedColor(AColor, 52, 44, 112, True);
end;

function TSCCustomNavControl.GetGradientPreLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 80);
end;

procedure TSCCustomNavControl.CreateWnd;
var
  Index: Integer;
begin
  inherited CreateWnd;

  if FControlLoaded and (FDefaultIndex > -1) then
  begin
    Index := FDefaultIndex;
    FDefaultIndex := -1;

    SetBarIndex(Index);
  end;
end;

procedure TSCCustomNavControl.ShowLessButtons;
begin
  if FCurrVisibleBars < 0 then
    FCurrVisibleBars := FVisibleBarCount;

  if FCurrVisibleBars > 0 then
  begin
    Dec(FCurrVisibleBars);

    UpdateBuffer;
    Self.Realign;

    UpdateHottrackInfo;
  end;
end;

procedure TSCCustomNavControl.ShowMoreButtons;
begin
  if FCurrVisibleBars < 0 then
    FCurrVisibleBars := FVisibleBarCount;

  if FCurrVisibleBars < FVisibleBarCount then
  begin
    Inc(FCurrVisibleBars);

    UpdateBuffer;
    Self.Realign;

    UpdateHottrackInfo;
  end;
end;

{ TSCCustomNavTabControl }

constructor TSCCustomNavTabControl.Create(AOwner: TComponent);
begin
  FTabs := TSCNavTabItems.Create(Self);
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls];
end;

destructor TSCCustomNavTabControl.Destroy;
begin
  FreeAndNil(FTabs);
  inherited Destroy;
end;

procedure TSCCustomNavTabControl.DoCloseClick;
var
  Index: Integer;
begin
  if FTabs <> nil then
  begin
    Index := GetActiveIndex;
    if (Index > -1) and (Index < FTabs.Count) then
      FTabs[Index].Visible := False;
  end;
end;

procedure TSCCustomNavTabControl.FillDataList;
var
  I, Index: Integer;
  Page: TSCNavTabItem;
  AData: TSCNavBarData;
  ADataList: TSCNavBarDataList;
begin
  ADataList := GetDataList;

  if ADataList <> nil then
  begin
    ADataList.Clear;

    if (FTabs <> nil) and (FTabs.Count > 0) then
    begin
      Index := GetTabIndex;
      if (Index > -1) and ((Index > FTabs.Count-1) or
        not IsTabVisible(FTabs[Index])) then
        Index := -1;

      for I := 0 to FTabs.Count-1 do
      begin
        Page := FTabs[I];
        if (Index = -1) and IsTabVisible(Page) then
          Index := I;

        AData := ADataList.Add;
        AData.Assign(Page);

        AData.Index   := I;
        AData.BarItem := Page;
      end;
    end;
  end;
end;

function TSCCustomNavTabControl.GetActiveIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FTabs <> nil then
  begin
    Result := GetTabIndex;
    if (Result > -1) and ((Result > FTabs.Count-1) or
      not IsTabVisible(FTabs[Result])) then
      Result := -1;

    if Result = -1 then
      for I := 0 to FTabs.Count-1 do
        if IsTabVisible(FTabs[I]) then
        begin
          Result := I;
          Break;
        end;
  end;
end;

function TSCCustomNavTabControl.GetBarCount: Integer;
begin
  Result := 0;
  if FTabs <> nil then Result := FTabs.Count;
end;

function TSCCustomNavTabControl.GetFirstVisibleNavBar: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FTabs <> nil then
    for I := 0 to FTabs.Count-1 do
      if IsTabVisible(FTabs[I]) then
      begin
        Result :=  I;
        Break;
      end;
end;

function TSCCustomNavTabControl.GetLastVisibleNavBar: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FTabs <> nil then
    for I := 0 to FTabs.Count-1 do
      if IsTabVisible(FTabs[I]) then
        Result := I;
end;

function TSCCustomNavTabControl.GetVisibleBarCount: Integer;
var
  VisibleBars, I: Integer;
begin
  Result := 0;
  VisibleBars := GetCurrVisibleCount;

  if (VisibleBars > 0) and (FTabs <> nil) then
    for I := 0 to FTabs.Count - 1 do
      if IsTabVisible(FTabs[I]) then
      begin
        if Result = VisibleBars then
          Break;

        Inc(Result);
      end;
end;

function TSCCustomNavTabControl.GetTabIndex: Integer;
begin
  Result := Self.BarIndex;
end;

procedure TSCCustomNavTabControl.HideAllBars;
var
  I: Integer;
begin
  if (FTabs <> nil) and (FTabs.Count > 0) then
  begin
    FTabs.BeginUpdate;
    try
      for I := 0 to FTabs.Count-1 do
        FTabs[I].Visible := False;
    finally
      FTabs.EndUpdate;
    end;
  end;
end;

function TSCCustomNavTabControl.IsTabShowingCaption(ATab: TSCNavTabItem): Boolean;
var
  I, VisibleBars, VisCnt: Integer;
begin
  Result := False;
  if (FTabs <> nil) and (ATab <> nil) and IsTabVisible(ATab) then
  begin
    VisibleBars := GetCurrVisibleCount;

    VisCnt := 0;
    if VisibleBars > 0 then
      for I := 0 to FTabs.Count - 1 do
        if IsTabVisible(FTabs[I]) then
        begin
          if VisCnt = VisibleBars then
            Break;

          Inc(VisCnt);
          if ATab = FTabs[I] then
          begin
            Result := True;
            Break;
          end;
        end;
  end;
end;

procedure TSCCustomNavTabControl.SetTabIndex(Value: Integer);
begin
  Self.BarIndex := Value;
end;

procedure TSCCustomNavTabControl.SetTabs(Value: TSCNavTabItems);
begin
  FTabs.Assign(Value);
end;

procedure TSCCustomNavTabControl.ShowAllBars;
var
  I: Integer;
begin
  if (FTabs <> nil) and (FTabs.Count > 0) then
  begin
    FTabs.BeginUpdate;
    try
      for I := 0 to FTabs.Count-1 do
        FTabs[I].Visible := True;
    finally
      FTabs.EndUpdate;
    end;
  end;
end;

function TSCCustomNavTabControl.IsTabVisible(ATab: TSCNavTabItem): Boolean;
begin
  Result := (ATab <> nil) and ATab.Visible;
end;

function TSCCustomNavTabControl.IsBarVisible(AData: TSCNavBarData): Boolean;
begin
  Result := (AData <> nil) and AData.Visible;
end;

{ TSCNavBarSheet }

procedure TSCNavBarSheet.AssignTo(Dest: TPersistent);
begin
  if Dest is TSCNavBarData then
  begin
    with TSCNavBarData(Dest) do
    begin
      Caption := Self.Caption;
      Color := Self.Color;
      Enabled := Self.BarEnabled;
      FontColor := Self.FontColor;
      Visible := Self.BarVisible;
      Hint := Self.Hint;
      ImageIndex := Self.ImageIndex;
      LargeImageIndex := Self.LargeImageIndex;
      UseSmallImages := Self.UseSmallImages;
    end;
  end else
    inherited AssignTo(Dest);
end;

procedure TSCNavBarSheet.Changed;
begin
  if FNavBarControl <> nil then
  begin
    FNavBarControl.UpdateNavBars(False);
    FNavBarControl.UpdateNavBars(True);
  end;
end;

procedure TSCNavBarSheet.CMEnabledChanged(var Message: TMessage);
begin
  if FBarVisible then
    Changed;
end;

procedure TSCNavBarSheet.CMTextChanged(var Message: TMessage);
begin
  if FBarVisible then
    Changed;
end;

constructor TSCNavBarSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  InternalSetVisible(False);
  ControlStyle := ControlStyle + [csAcceptsControls, csOpaque,
    csNoDesignVisible];

  Align := alClient;
  FFontColor := clNone;
  FImageIndex := -1;
  FLargeImageIndex := -1;
  FUseSmallImages := False;
  FBarEnabled := True;
  FBarVisible := True;
end;

procedure TSCNavBarSheet.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params.WindowClass do
    Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

destructor TSCNavBarSheet.Destroy;
begin
  if FNavBarControl <> nil then
    FNavBarControl.RemoveBar(Self);
  inherited Destroy;
end;

function TSCNavBarSheet.GetColor: TColor;
begin
  Result := inherited Color;
end;

function TSCNavBarSheet.GetImages: TCustomImageList;
begin
  Result := nil;
  if Self.NavBarControl <> nil then
    Result := Self.NavBarControl.Images;
end;

function TSCNavBarSheet.GetBarIndex: Integer;
begin
  Result := -1;
  if FNavBarControl <> nil then
    Result := FNavBarControl.FSheets.IndexOf(Self);
end;

function TSCNavBarSheet.GetVisible: Boolean;
begin
  Result := inherited Visible or IsDesigning;
end;

procedure TSCNavBarSheet.InternalSetVisible(Value: Boolean);
begin
  inherited Visible := Value;
end;

procedure TSCNavBarSheet.Paint;
var
  R: TRect;
  AColor: TColor;
begin
  R := Rect(0, 0, Width, Height);

  AColor := Self.GetDefaultBackColor;
  if (FNavBarControl <> nil) then
    AColor := FNavBarControl.GetDefaultBackColor;

  with Canvas do
  begin
    Brush.Color := AColor;
    Canvas.FillRect(R);
  end;

  if (FNavBarControl <> nil) and
    (FNavBarControl.FGradient.Style <> scdgsNone) then
    FNavBarControl.FGradient.Paint(Canvas, R);
end;

procedure TSCNavBarSheet.ReadState(Reader: TReader);
begin
  inherited;
  if Reader.Parent is TSCCustomNavBarControl then
    NavBarControl := TSCCustomNavBarControl(Reader.Parent);
end;

procedure TSCNavBarSheet.SetColor(Value: TColor);
begin
  if GetColor <> Value then
  begin
    if FNavBarControl <> nil then
    begin
      if (FNavBarControl.IsUseBarColors or ((GetColor <> FNavBarControl.Color) and
        (Value = FNavBarControl.Color))) then
      begin
        inherited Color := Value;
        if FBarVisible then
          Changed;
      end;
    end else
    begin
      inherited Color := Value;
      if FBarVisible then
        Changed;
    end;
  end;
end;

procedure TSCNavBarSheet.SetFontColor(Value: TColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    if FBarVisible then
      Changed;
  end;
end;

procedure TSCNavBarSheet.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if FBarVisible then
      Changed;
  end;
end;

procedure TSCNavBarSheet.SetLargeImageIndex(Value: TImageIndex);
begin
  if FLargeImageIndex <> Value then
  begin
    FLargeImageIndex := Value;
    if FBarVisible then
      Changed;
  end;
end;

procedure TSCNavBarSheet.SetNavBarControl(ANavBarControl: TSCCustomNavBarControl);
begin
  if FNavBarControl <> ANavBarControl then
  begin
    if FNavBarControl <> nil then
      FNavBarControl.RemoveBar(Self);

    Parent := ANavBarControl;
    if ANavBarControl <> nil then
      ANavBarControl.InsertBar(Self);
  end;
end;

procedure TSCNavBarSheet.SetBarIndex(Value: Integer);
var
  BarCount: Integer;
begin
  if FNavBarControl <> nil then
  begin
    BarCount := FNavBarControl.FSheets.Count;

    if Value < BarCount then
    begin
      FNavBarControl.FSheets.Move(GetBarIndex, Value);
      Changed;
    end;
  end;
end;

procedure TSCNavBarSheet.SetBarEnabled(Value: Boolean);
begin
  if FBarEnabled <> Value then
  begin
    FBarEnabled := Value;
    if FBarVisible then
      Changed;
  end;
end;

procedure TSCNavBarSheet.SetNavBarRect(Value: TRect);
begin
  FNavBarRect := Value;
end;

procedure TSCNavBarSheet.SetUseSmallImages(Value: Boolean);
begin
  if FUseSmallImages <> Value then
  begin
    FUseSmallImages := Value;
    Changed;
  end;
end;

procedure TSCNavBarSheet.SetBarVisible(Value: Boolean);
begin
  if FBarVisible <> Value then
  begin
    FBarVisible := Value;
    Changed;
  end;
end;

procedure TSCNavBarSheet.SetVisible(Value: Boolean);
begin
  //
end;

procedure TSCNavBarSheet.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1;
end;

function TSCNavBarSheet.GetDefaultBackColor: TColor;
begin
  Result := Self.Color;
  if Result = clNone then
    Result := clWindow;
end;

{ TSCCustomNavBarControl }

procedure TSCCustomNavBarControl.ActiveNavBarMoved(Index: Integer);
begin
  ActiveBar.BarIndex := Index;
end;

procedure TSCCustomNavBarControl.Change;
begin
  if not FInitActiveBar then
    inherited;
end;

procedure TSCCustomNavBarControl.ChangeActiveBar(Bar: TSCNavBarSheet);
var
  Form: TCustomForm;
begin
  if FActiveBar <> Bar then
  begin
    Form := GetParentForm(Self);
    if (Form <> nil) and (FActiveBar <> nil) and
      FActiveBar.ContainsControl(Form.ActiveControl) then
      Form.ActiveControl := FActiveBar;

    if Bar <> nil then
    begin
      Bar.BringToFront;
      Bar.InternalSetVisible(True);

      if (Form <> nil) and (FActiveBar <> nil) and
        (Form.ActiveControl = FActiveBar) then
      begin
        if Bar.CanFocus then
          Form.ActiveControl := Bar
        else
          Form.ActiveControl := Self;
      end;
    end;

    if FActiveBar <> nil then
      FActiveBar.InternalSetVisible(False);

    FActiveBar := Bar;
    if (Form <> nil) and (FActiveBar <> nil) and
      (Form.ActiveControl = FActiveBar) then
      FActiveBar.SelectFirst;
  end;
end;

procedure TSCCustomNavBarControl.Changing(NewIndex: Integer; var Allowed: Boolean);
begin
  if not FInitActiveBar then
    inherited Changing(NewIndex, Allowed);

  if Allowed then
    ChangeActiveBar(BarForNavBar(NewIndex));
end;

procedure TSCCustomNavBarControl.CMColorChanged(var Message: TMessage);
var
  I: Integer;
begin
  if not IsUseBarColors then
    for I := 0 to FSheets.Count-1 do
      TSCNavBarSheet(FSheets[I]).Color := Color;

  inherited;
end;

procedure TSCCustomNavBarControl.CMDialogKey(var Message: TCMDialogKey);
var
  Form: TCustomForm;
begin
  inherited;

  if Message.Result = 0 then
  begin
    Form := GetParentForm(Self);

    if (Form <> nil) and ContainsControl(Form.ActiveControl) and
      (Message.CharCode = VK_TAB) and (GetKeyState(VK_CONTROL) < 0) then
    begin
      SelectNextBar(GetKeyState(VK_SHIFT) >= 0);
      Message.Result := 1;
    end;
  end;
end;

procedure TSCCustomNavBarControl.CMDockClient(var Message: TCMDockClient);
var
  DockCtl: TControl;
  IsVisible: Boolean;
begin
  Message.Result := 0;
  FNewDockSheet := TSCNavBarSheet.Create(Self);
  try
    try
      DockCtl := Message.DockSource.Control;
      if DockCtl is TCustomForm then
        FNewDockSheet.Caption := TCustomForm(DockCtl).Caption;

      FNewDockSheet.NavBarControl := Self;
      DockCtl.Dock(Self, Message.DockSource.DockRect);
    except
      FNewDockSheet.Free;
      raise;
    end;

    IsVisible := DockCtl.Visible;
    FNewDockSheet.BarVisible := IsVisible;
    if IsVisible then
      ActiveBar := FNewDockSheet;

    DockCtl.Align := alClient;
  finally
    FNewDockSheet := nil;
  end;
end;

procedure TSCCustomNavBarControl.CMDockNotification(
  var Message: TCMDockNotification);
var
  I: Integer;
  S: string;
  Bar: TSCNavBarSheet;
begin
  Bar := GetBarFromDockClient(Message.Client);

  if Bar <> nil then
  begin
    case Message.NotifyRec.ClientMsg of
      WM_SETTEXT:
      begin
        S := PChar(Message.NotifyRec.MsgLParam);
        for I := 1 to Length(S) do
          if S[I] in [#13, #10] then
          begin
            SetLength(S, I-1);
            Break;
          end;

        Bar.Caption := S;
      end;

      CM_VISIBLECHANGED:
        Bar.BarVisible := Boolean(Message.NotifyRec.MsgWParam);
    end;
  end;
  inherited;
end;

procedure TSCCustomNavBarControl.CMUnDockClient(var Message: TCMUnDockClient);
var
  Bar: TSCNavBarSheet;
begin
  Message.Result := 0;
  Bar := GetBarFromDockClient(Message.Client);

  if Bar <> nil then
  begin
    FUndockingBar := Bar;
    Message.Client.Align := alNone;
  end;
end;

constructor TSCCustomNavBarControl.Create(AOwner: TComponent);
begin
  if not Registered then
  begin
    Classes.RegisterClasses([TSCNavBarSheet]);
    Registered := True;
  end;

  FSheets := TList.Create;
  inherited Create(AOwner);

  ControlStyle := ControlStyle - [csAcceptsControls] + [csOpaque];
  SetBounds(Left, Top, 185, 300);
  FActiveBar := nil;
end;

procedure TSCCustomNavBarControl.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or WS_CLIPCHILDREN;
end;

destructor TSCCustomNavBarControl.Destroy;
var
  I: Integer;
begin
  for I := 0 to FSheets.Count-1 do
    TSCNavBarSheet(FSheets[I]).FNavBarControl := nil;

  FreeAndNil(FSheets);
  inherited Destroy;
end;

procedure TSCCustomNavBarControl.DestroyActiveNavBar;
var
  Index: Integer;
begin
  if FActiveBar <> nil then
  begin
    Index := BarIndex;
    FActiveBar.Free;

    if Index > 0 then Dec(Index);
    SetBarIndex(Index);
  end;
end;

procedure TSCCustomNavBarControl.DoAddDockClient(Client: TControl;
  const ARect: TRect);
begin
  if FNewDockSheet <> nil then
    Client.Parent := FNewDockSheet;
end;

procedure TSCCustomNavBarControl.DockOver(Source: TDragDockObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  R: TRect;
begin
  GetWindowRect(Handle, R);
  Source.DockRect := R;
  DoDockOver(Source, X, Y, State, Accept);
end;

procedure TSCCustomNavBarControl.DoRemoveDockClient(Client: TControl);
begin
  if (FUndockingBar <> nil) and not IsDestroying then
  begin
    SelectNextBar(True);
    FUndockingBar.Free;
    FUndockingBar := nil;
  end;
end;

procedure TSCCustomNavBarControl.FillDataList;
var
  I, Index: Integer;
  AData: TSCNavBarData;
  Sheet: TSCNavBarSheet;
  ADataList: TSCNavBarDataList;
begin
  ADataList := GetDataList;

  if ADataList <> nil then
  begin
    ADataList.Clear;

    if (FSheets <> nil) and (FSheets.Count > 0) then
    begin
      Index := FBarIndex;
      if (Index > -1) and ((Index > FSheets.Count-1) or
        not IsSheetVisible(TSCNavBarSheet(FSheets[Index]))) then
        Index := -1;

      for I := 0 to FSheets.Count-1 do
      begin
        Sheet := TSCNavBarSheet(FSheets[I]);
        if (Index = -1) and IsSheetVisible(Sheet) then
          Index := I;

        AData := DataList.Add;
        Sheet.AssignTo(AData);

        AData.Index   := I;
        AData.BarItem := Sheet;
      end;
    end;
  end;
end;

function TSCCustomNavBarControl.FindNextBar(CurBar: TSCNavBarSheet; GoForward,
  CheckBarVisible: Boolean): TSCNavBarSheet;
var
  I, StartIndex: Integer;
begin
  Result := nil;
  if FSheets.Count <> 0 then
  begin
    StartIndex := FSheets.IndexOf(CurBar);

    if StartIndex = -1 then
    begin
      StartIndex := 0;
      if GoForward then
        StartIndex := FSheets.Count-1;
    end;

    I := StartIndex;
    repeat
      if GoForward then
      begin
        Inc(I);
        if I = FSheets.Count then I := 0;
      end else
      begin
        if I = 0 then I := FSheets.Count;
        Dec(I);
      end;

      Result := FSheets[I];
      if not CheckBarVisible or IsSheetVisible(Result) then
        Exit;
    until I = StartIndex;
  end;
end;

function TSCCustomNavBarControl.GetActiveBarIndex: Integer;
begin
  Result := -1;
  if ActiveBar <> nil then
    Result := ActiveBar.BarIndex;
end;

function TSCCustomNavBarControl.GetActiveIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FSheets <> nil then
  begin
    Result := FBarIndex;
    if (Result > -1) and ((Result > FSheets.Count-1) or
      not IsSheetVisible(TSCNavBarSheet(FSheets[Result]))) then
      Result := -1;

    if Result = -1 then
      for I := 0 to FSheets.Count-1 do
        if IsSheetVisible(TSCNavBarSheet(FSheets[I])) then
        begin
          Result := I;
          Break;
        end;
  end;
end;

procedure TSCCustomNavBarControl.GetChildren(Proc: TGetChildProc;
  Root: TComponent);
var
  I: Integer;
begin
  for I := 0 to FSheets.Count-1 do
    Proc(TComponent(FSheets[I]));
end;

function TSCCustomNavBarControl.GetDockClientAt(P: TPoint): TControl;
var
  I: Integer;
  Bar: TSCNavBarSheet;
  HitInfo: TSCNavBarHitInfo;
begin
  Result := nil;
  if DockSite then
  begin
    HitInfo := GetHitInfo(P);
    if HitInfo.Index >= 0 then
    begin
      Bar := nil;
      for I := 0 to HitInfo.Index do
        Bar := FindNextBar(Bar, True, True);

      if (Bar <> nil) and (Bar.ControlCount > 0) then
      begin
        Result := Bar.Controls[0];
        if Result.HostDockSite <> Self then
          Result := nil;
      end;
    end;
  end;
end;

function TSCCustomNavBarControl.GetFirstVisibleNavBar: Integer;
var
  I: Integer;
  Bar: TSCNavBarSheet;
begin
  Result := -1;
  if FSheets <> nil then
    for I := 0 to FSheets.Count-1 do
    begin
      Bar := TSCNavBarSheet(FSheets[I]);
      if IsSheetVisible(Bar) then
      begin
        Result :=  I;
        Break;
      end;
    end;
end;

function TSCCustomNavBarControl.GetLastVisibleNavBar: Integer;
var
  I: Integer;
  Bar: TSCNavBarSheet;
begin
  Result := -1;
  if FSheets <> nil then
    for I := FSheets.Count-1 downto 0 do
    begin
      Bar := TSCNavBarSheet(FSheets[I]);
      if IsSheetVisible(Bar) then
      begin
        Result :=  I;
        Break;
      end;
    end;
end;

function TSCCustomNavBarControl.GetBar(Index: Integer): TSCNavBarSheet;
begin
  Result := FSheets[Index];
end;

function TSCCustomNavBarControl.GetBarCount: Integer;
begin
  Result := FSheets.Count;
end;

function TSCCustomNavBarControl.GetBarFromDockClient(
  Client: TControl): TSCNavBarSheet;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to BarCount-1 do
    if (Client.Parent = Bars[I]) and (Client.HostDockSite = Self) then
    begin
      Result := Bars[ I ];
      Exit;
    end;
end;

procedure TSCCustomNavBarControl.GetSiteInfo(Client: TControl;
  var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
begin
  CanDock := GetBarFromDockClient(Client) = nil;
  inherited;
end;

procedure TSCCustomNavBarControl.HideAllBars;
var
  I: Integer;
begin
  for I := 0 to FSheets.Count-1 do
    Bars[I].BarVisible := False;
end;

procedure TSCCustomNavBarControl.InsertBar(Bar: TSCNavBarSheet);
begin
  HandleNeeded;

  FSheets.Add(Bar);
  Bar.FNavBarControl := Self;

  UpdateNavBars(False);
  UpdateNavBars(True);
end;

procedure TSCCustomNavBarControl.Loaded;
var
  Ctrl: TControl;
  I, Cnt: Integer;
  DefBar, Bar: TSCNavBarSheet;
begin
  inherited Loaded;

  FInitActiveBar := True;
  try
    DefBar := nil;
    if BarIndex > -1 then
    begin
      Cnt := 0;
      for I := 0 to Self.ControlCount-1 do
      begin
        Ctrl := Self.Controls[I];
        if Ctrl is TSCNavBarSheet then
        begin
          if Cnt = BarIndex then
          begin
            DefBar := TSCNavBarSheet(Ctrl);
            if not DefBar.Visible then
              DefBar := nil;

            Break;
          end;

          Inc(Cnt);
        end;
      end;
    end;

    if (DefBar <> nil) and (DefBar <> FActiveBar) then
    begin
      if FActiveBar <> nil then
        FActiveBar.InternalSetVisible(False);

      Bar := DefBar
    end else
      Bar := FActiveBar;

    FActiveBar := nil;

    UpdateNavBars(False);
    UpdateNavBars(True);

    SetActiveBar(Bar);
  finally
    FInitActiveBar := False;
  end;
end;

procedure TSCCustomNavBarControl.MakeControlVisible(AControl: TControl);
var
  Bar: TSCNavBarSheet;
  I, ControlBarIndex: Integer;

  function FindControl(Container: TWinControl): Boolean;
  var
    C: TControl;
    I: Integer;
  begin
    Result := False;
    for I := 0 to Container.ControlCount-1 do
    begin
      C := Container.Controls[I];
      Result := (C = AControl) or ((C is TWinControl) and
        FindControl(C as TWinControl));

      if Result then
        Break;
    end;
  end;

begin 
  ControlBarIndex := -1;

  for I := 0 to BarCount-1 do
  begin
    Bar := Bars[I];
    if Bar = AControl then
    begin
      ControlBarIndex := I;
      Break;
    end else
    if FindControl(Bar) then
    begin
      ControlBarIndex := I;
      Break;
    end;
  end;

  if ControlBarIndex < 0 then
    ControlBarIndex := 0;

  if ControlBarIndex <> ActiveBarIndex then
    ActiveBarIndex := ControlBarIndex;
end;

function TSCCustomNavBarControl.BarForNavBar(ABarIndex: Integer): TSCNavBarSheet;
var
  I: Integer;
  Bar: TSCNavBarSheet;
begin
  Result := nil;
  if ABarIndex > -1 then
    for I := 0 to FSheets.Count - 1 do
    begin
      Bar := TSCNavBarSheet( FSheets[ I ] );
      if Bar.BarIndex = ABarIndex then
      begin
        Result := Bar;
        Exit;
      end;
    end;
end;

procedure TSCCustomNavBarControl.RemoveBar(Bar: TSCNavBarSheet);
var
  NextSheet: TSCNavBarSheet;
begin
  if Bar <> nil then
  begin
    NextSheet := FindNextBar(Bar, True, not IsDesigning);
    if NextSheet = Bar then NextSheet := nil;

    Bar.SetBarVisible(False);
    Bar.FNavBarControl := nil;

    FSheets.Remove(Bar);

    SetActiveBar(NextSheet);

    UpdateNavBars(False);
    UpdateNavBars(True);
  end;
end;

procedure TSCCustomNavBarControl.SelectNextBar(GoForward: Boolean);
var
  Bar: TSCNavBarSheet;
begin
  Bar := FindNextBar(ActiveBar, GoForward, True);
  if Bar <> nil then
    SetActiveBar(Bar);
end;

procedure TSCCustomNavBarControl.SetActiveBar(Bar: TSCNavBarSheet);
var
  Allowed: Boolean;
  NewBarIndex: Integer;
begin
  if (Bar = nil) or (Bar.NavBarControl = Self) then
  begin
    if (Bar <> nil) and not FInitActiveBar then
    begin
      Allowed := True;
      Changing(Bar.BarIndex, Allowed);
      if not Allowed then
        Exit;
    end;

    if Bar <> nil then
      Bar.InternalSetVisible(True);

    if IsLoading or IsReading then
    begin
      FActiveBar := Bar;
      Exit;
    end;

    NewBarIndex := -1;
    if Bar <> nil then NewBarIndex := Bar.BarIndex;

    if NewBarIndex > -1 then
      ChangeActiveBar(Bar);

    SetBarIndex(NewBarIndex);
  end;
end;

procedure TSCCustomNavBarControl.SetActiveBarIndex(Value: Integer);
begin
  SetActiveBar(Bars[Value]);
end;

procedure TSCCustomNavBarControl.SetChildOrder(Child: TComponent; Order: Integer);
begin
  TSCNavBarSheet(Child).BarIndex := Order;
end;

procedure TSCCustomNavBarControl.ShowAllBars;
var
  I: Integer;
begin
  for I := 0 to FSheets.Count-1 do
    Bars[I].BarVisible := True;
end;

procedure TSCCustomNavBarControl.ShowControl(AControl: TControl);
begin
  if (AControl is TSCNavBarSheet) and
    (TSCNavBarSheet(AControl).NavBarControl = Self) then
    SetActiveBar(TSCNavBarSheet(AControl));

  inherited ShowControl(AControl);
end;

procedure TSCCustomNavBarControl.WMLButtonDblClk(var Message: TWMLButtonDblClk);
var
  DockCtl: TControl;
begin
  inherited;

  DockCtl := GetDockClientAt(SmallPointToPoint(Message.Pos));
  if DockCtl <> nil then
    DockCtl.ManualDock(nil, nil, alNone);
end;

procedure TSCCustomNavBarControl.WMLButtonDown(var Message: TWMLButtonDown);
var
  DockCtl: TControl;
begin
  inherited;
  
  DockCtl := GetDockClientAt(SmallPointToPoint(Message.Pos));
  if DockCtl <> nil then
    DockCtl.BeginDrag(False);
end;

procedure TSCCustomNavBarControl.DoCloseClick;
var
  Index: Integer;
  Sheet, NextSheet: TSCNavBarSheet;
begin
  if FSheets <> nil then
  begin
    Index := GetActiveIndex;

    if (Index > -1) and (Index < FSheets.Count) then
    begin
      Sheet := TSCNavBarSheet(FSheets[Index]);

      NextSheet := FindNextBar(Sheet, True, not IsDesigning);
      if NextSheet = Sheet then NextSheet := nil;

      with Sheet do
      begin
        InternalSetVisible(False);
        SetBarVisible(False);
      end;

      SetActiveBar(NextSheet);
      UpdateNavBars(True);
    end;
  end;
end;

procedure TSCCustomNavBarControl.DoBarIndexChanged;
var
  Bar: TSCNavBarSheet;
  Index1, Index2: Integer;
begin
  Index1 := Self.BarIndex;
  Index2 := Self.ActiveBarIndex;

  if Index1 <> Index2 then
  begin
    Bar := nil;
    if (Index1 > -1) and (Index2 < FSheets.Count) then
      Bar := TSCNavBarSheet(FSheets[Index1]);

    SetActiveBar(Bar);
  end;
end;

procedure TSCCustomNavBarControl.GradientChanged(Sender: TObject);
begin
  inherited GradientChanged(Sender);
  if FActiveBar <> nil then
    FActiveBar.Invalidate;
end;

procedure TSCCustomNavBarControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

function TSCCustomNavBarControl.IsSheetVisible(Sheet: TSCNavBarSheet): Boolean;
begin
  Result := IsDesigning or ((Sheet <> nil) and
    Sheet.Visible and Sheet.BarVisible);
end;

{ TSCNavBackGradient }

constructor TSCNavBackGradient.Create(AOwner: TSCCustomNavControl);
begin
  inherited Create(AOwner);
  FOwner := AOwner;
  Style := scdgsNone;
end;

function TSCNavBackGradient.GetColorBegin: TColor;
begin
  Result := clWindow;
  if FOwner <> nil then Result := FOwner.Color;
end;

function TSCNavBackGradient.IsColorBeginSaved: Boolean;
begin
  Result := False;
end;

procedure TSCNavBackGradient.SetColorBegin(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.Color := Value;
end;

{ TSCNavBarBorderProps }

constructor TSCNavBarBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccbFlat;
end;

{ TSCNavPanelGradient }

constructor TSCNavPanelGradient.Create(AOwner: TSCCustomNavPanel);
begin
  inherited Create(AOwner);
  FOwner := AOwner;
  Style := scdgsNone;
end;

function TSCNavPanelGradient.GetColorBegin: TColor;
begin
  Result := clWindow;
  if FOwner <> nil then Result := FOwner.Color;
end;

function TSCNavPanelGradient.IsColorBeginSaved: Boolean;
begin
  Result := False;
end;

procedure TSCNavPanelGradient.SetColorBegin(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.Color := Value;
end;

{ TSCNavPanelHeader }

procedure TSCNavPanelHeader.Assign(Source: TPersistent);
begin
  if Source is TSCNavPanelHeader then
  begin
    with TSCNavPanelHeader(Source) do
    begin
      Self.FAlignment := Alignment;
      Self.FButtonIconColor := ButtonIconColor;
      Self.FCloseButton := CloseButton;
      Self.FColor := Color;
      Self.FFrameColor := FrameColor;
      Self.FHeight := Height;
      Self.FHighlightColor := HighlightColor;
      Self.FImageIndex := ImageIndex;
      Self.FStyle := Style;
      Self.FText := Text;
      Self.FVisible := Visible;

      Self.SetFont(Font);
    end;

    Changed(True);
  end else
    inherited Assign(Source);
end;

procedure TSCNavPanelHeader.Changed(Force: Boolean);
begin
  if (FOwner <> nil) and (FVisible or Force) then
    FOwner.HeaderChanged(Force);
end;

constructor TSCNavPanelHeader.Create(AOwner: TSCCustomNavPanel);
begin
  inherited Create;
  FOwner := AOwner;

  FAlignment := taLeftJustify;
  FButtonIconColor := clBtnText;
  FCloseButton := True;
  FColor := clBtnFace;
  FFrameColor := clBtnShadow;
  FHeight := -1;
  FHighlightColor := $003FABFF;
  FImageIndex := -1;
  FStyle := scnbOfficeXP;
  FVisible := True;

  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
end;

destructor TSCNavPanelHeader.Destroy;
begin
  FreeAndNil(FFont);
  inherited Destroy;
end;

procedure TSCNavPanelHeader.FontChanged(Sender: TObject);
begin
  Changed(True);
end;

function TSCNavPanelHeader.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCNavPanelHeader.SetAlignment(Value: TLeftRight);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Changed(False);
  end;
end;

procedure TSCNavPanelHeader.SetButtonIconColor(Value: TColor);
begin
  if FButtonIconColor <> Value then
  begin
    FButtonIconColor := Value;
    Changed(False);
  end;
end;

procedure TSCNavPanelHeader.SetCloseButton(Value: Boolean);
begin
  if FCloseButton <> Value then
  begin
    FCloseButton := Value;
    Changed(True);
  end;
end;

procedure TSCNavPanelHeader.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed(False);
  end;
end;

procedure TSCNavPanelHeader.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TSCNavPanelHeader.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Changed(False);
  end;
end;

procedure TSCNavPanelHeader.SetHeight(Value: Integer);
begin
  if Value < -1 then Value := -1;
  
  if FHeight <> Value then
  begin
    FHeight := Value;
    Changed(True);
  end;
end;

procedure TSCNavPanelHeader.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    Changed(False);
  end;
end;

procedure TSCNavPanelHeader.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed(True);
  end;
end;

procedure TSCNavPanelHeader.SetStyle(Value: TSCNavBarStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Changed(False);
  end;
end;

procedure TSCNavPanelHeader.SetText(const Value: String);
begin
  if FText <> Value then
  begin
    FText := Value;
    Changed(False);
  end;
end;

procedure TSCNavPanelHeader.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(True);
  end;
end;

{ TSCCustomNavPanel }

procedure TSCCustomNavPanel.AdjustClientRect(var ARect: TRect);
begin
  ARect := GetCardRect;
  inherited AdjustClientRect(ARect);
end;

procedure TSCCustomNavPanel.CMColorChanged(var Message: TMessage);
begin
  inherited;
  if FGradient <> nil then
    FGradient.UpdatePattern;

  UpdateBuffer;
end;

constructor TSCCustomNavPanel.Create(AOwner: TComponent);
begin
  FControlLoaded := False;
  FDefaultHeaderHeight := -1;

  FGradient := TSCNavPanelGradient.Create(Self);
  FGradient.OnChange := GradientChanged;

  FGradientPainter := TSCGradientPainter.Create(nil);
  FGradientPainter.Style := scdgsLinearV;

  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse,
    csClickEvents, csOpaque, csDoubleClicks];

  FHeader := TSCNavPanelHeader.Create(Self);
  FPaintBuffer := TBitmap.Create;

  InitializeHitTest(@FHitInfo);
  InitializeHitTest(@FHottrackInfo);

  Color := clWindow;
  ParentColor := False;
  ClickFocus := False;
  SetBounds(Left, Top, 185, 130);
  UseDockManager := True;
end;

procedure TSCCustomNavPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_CLIPCHILDREN or WS_CLIPSIBLINGS;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW) or
      CS_DBLCLKS;
  end;
end;

destructor TSCCustomNavPanel.Destroy;
begin
  FreeAndNil(FGradient);
  FreeAndNil(FGradientPainter);
  FreeAndNil(FHeader);
  FreeAndNil(FPaintBuffer);

  inherited Destroy;
end;

procedure TSCCustomNavPanel.DoDrawHeader(ACanvas: TCanvas; ARect: TRect;
  AFont: TFont; var AColor: TColor; var AImage: Integer; var AText: String;
  var Handled: Boolean);
begin
  //
end;

procedure TSCCustomNavPanel.DoGradientChanged(Sender: TObject);
begin
  //
end;

procedure TSCCustomNavPanel.DoHeaderChanged(Force: Boolean);
begin
  //
end;

procedure TSCCustomNavPanel.DrawButtonFace(ACanvas: TCanvas; ARect: TRect;
  AStyle: TSCNavBarStyle; AColor: TColor; IsDown, IsHot: Boolean);
var
  R: TRect;
begin
  if (AColor <> clNone) and not IsRectEmpty(ARect) then
  begin
    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := AColor;

      FillRect(ARect);
    end;

    case AStyle of
      scnbOfficeXP:
      begin
        if not (IsHot or IsDown or IsActive) then
        begin
          FGradientPainter.ColorBegin := GetGradientExLight(AColor);
          FGradientPainter.ColorEnd := AColor;

          FGradientPainter.Paint(ACanvas, ARect);
        end;
      end;
      scnbOffice11:
      begin
        FGradientPainter.ColorBegin := GetGradientExLight(AColor);
        FGradientPainter.ColorEnd := AColor;

        FGradientPainter.Paint(ACanvas, ARect);
      end;
      scnbOffice12:
      begin
        FGradientPainter.ColorBegin := GetGradientPeal(AColor);
        FGradientPainter.ColorEnd := AColor;

        FGradientPainter.Paint(ACanvas, ARect);

        R := ARect;
        Inc(R.Top, (R.Bottom - R.Top) div 2);

        if not IsRectEmpty(R) then
        begin
          FGradientPainter.ColorBegin := GetGradientShadow(AColor);
          FGradientPainter.ColorEnd := GetGradientLight(AColor);

          FGradientPainter.Paint(ACanvas, R);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomNavPanel.DrawGradientBack(ACanvas: TCanvas);
var
  R: TRect;
begin
  if FGradient.Style <> scdgsNone then
  begin
    R := GetCardRect;
    FGradient.Paint(ACanvas, R);
  end;
end;

procedure TSCCustomNavPanel.DrawHeader(ACanvas: TCanvas);
var
  AFont: TFont;
  AText: String;
  AColor: TColor;
  ARect, R: TRect;
  Handled: Boolean;
  F, SR, X, Y, AImage: Integer;
begin
  if HandleAllocated and (FHeader <> nil) and FHeader.Visible then
  begin
    ARect := GetHeaderRect;

    if not IsRectEmpty(ARect) then
    begin
      AColor := GetHeaderColor;
      
      if AColor = clNone then
        AColor := clBtnFace;

      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AColor;

        FillRect(ARect);
      end;

      DrawButtonFace(ACanvas, ARect, FHeader.Style,
        AColor, False, False);

      R := ARect;
      Dec(R.Right);

      scFrame3D(ACanvas, R, GetBtnHighlightOf(AColor), AColor, 1, 0);

      AImage := FHeader.ImageIndex;
      AText := FHeader.Text;

      AFont := TFont.Create;
      try
        AFont.Assign(Self.FHeader.Font);

        if AFont.Color = clNone then
          AFont.Color := clBtnText;

        SR := IntersectClipRect(ACanvas.Handle,
          ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
        try
          if SR <> NULLREGION then
          begin
            Handled := False;

            if Assigned(FOnCustomDrawHeader) then
              FOnCustomDrawHeader(Self, ACanvas, ARect, AFont,
                AColor, AImage, AText, Handled);

            if not Handled then
              DoDrawHeader(ACanvas, ARect, AFont, AColor,
                AImage, AText, Handled);

            if Handled then
              Exit;
          end;
        finally
          SelectClipRgn(ACanvas.Handle, 0);
        end;

        if AColor = clNone then
        begin
          AColor := GetHeaderColor;
          if AColor = clNone then
            AColor := clBtnFace;
        end;

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := AColor;

          FillRect(ARect);
        end;

        DrawButtonFace(ACanvas, ARect, FHeader.Style,
          AColor, False, False);

        R := ARect;
        Dec(R.Right);

        scFrame3D(ACanvas, R, GetBtnHighlightOf(AColor), AColor, 1, 0);

        R := ARect;
        InflateRect(R, -SC_NavPanelHorzSpacing, 0);

        if (Images <> nil) and (AImage > -1) and (AImage < Images.Count) then
        begin
          X := R.Left;
          Y := R.Top + ((R.Bottom - R.Top - Images.Height) div 2);

          Images.Draw(ACanvas, X, Y, AImage, Self.Enabled);
          Inc(R.Left, Images.Width + 2);
        end;

        if (AText <> '') and not IsRectEmpty(R) then
        begin
          SR := IntersectClipRect(ACanvas.Handle,
            R.Left, R.Top, R.Right, R.Bottom);
          try
            if SR <> NULLREGION then
            begin
              F := DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or
                DT_END_ELLIPSIS or DT_LEFT;

              if AFont.Color = clNone then
                AFont.Color := clBtnText;

              with ACanvas do
              begin
                Font.Assign(AFont);
                Brush.Style := bsClear;

                Windows.DrawText(ACanvas.Handle, PChar(AText),
                  Length(AText), R, F);
              end;
            end;
          finally
            SelectClipRgn(ACanvas.Handle, 0);
          end;
        end;

        AColor := GetFrameColor;

        with ACanvas do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := AColor;

          MoveTo(ARect.Left, ARect.Bottom - 1);
          LineTo(ARect.Right, ARect.Bottom - 1);

          MoveTo(ARect.Right - 1, ARect.Top);
          LineTo(ARect.Right - 1, ARect.Bottom);
        end;
      finally
        AFont.Free;
      end;
    end;
  end;
end;

function TSCCustomNavPanel.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCNavPanelBorderProps;
end;

function TSCCustomNavPanel.GetCardRect: TRect;
var
  H: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated then
  begin
    Result := GetClientRect;

    H := GetHeaderHeight;
    if H < 0 then H := 0;

    Inc(Result.Top, H);
  end;
end;

function TSCCustomNavPanel.GetDefaultBackColor: TColor;
begin
  Result := Self.Color;
  if Result = clNone then
    Result := clWindow;
end;

function TSCCustomNavPanel.GetFrameColor: TColor;
begin
  Result := clNone;
  if FHeader <> nil then
    Result := FHeader.FFrameColor;

  if Result = clNone then
  begin
    Result := clBtnShadow;
    if Self.Color <> clNone then
      Result := GetBtnShadowOf(Self.Color);
  end;
end;

function TSCCustomNavPanel.GetGradientDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -20)
end;

function TSCCustomNavPanel.GetGradientLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 30)
end;

function TSCCustomNavPanel.GetGradientExLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 40)
end;

function TSCCustomNavPanel.GetGradientShadow(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -6);
end;

function TSCCustomNavPanel.GetHeaderColor: TColor;
begin
  Result := clNone;
  if FHeader <> nil then
    Result := FHeader.FColor;

  if Result = clNone then
  begin
    Result := clBtnFace;
    if Self.Color <> clNone then
      Result := GetBtnFaceOf(Self.Color);
  end;
end;

function TSCCustomNavPanel.GetHeaderHeight: Integer;
begin
  Result := FDefaultHeaderHeight;
  if HandleAllocated and (FHeader <> nil) and (Result = -1) then
  begin
    Canvas.Font.Assign(Self.FHeader.Font);
    FDefaultHeaderHeight := Canvas.TextHeight('Rq');

    if (Images <> nil) and (FDefaultHeaderHeight < Images.Height) then
      FDefaultHeaderHeight := Images.Height;

    Inc(FDefaultHeaderHeight, 2*SC_NavPanelVertSpacing);
    Result := FDefaultHeaderHeight;
  end;

  if Result < FHeader.Height then
    Result := FHeader.Height;

  if Result < 0 then Result := 0;
end;

function TSCCustomNavPanel.GetHeaderRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if HandleAllocated and (FHeader <> nil) and FHeader.Visible then
  begin
    Result := GetClientRect;
    Result.Bottom := Result.Top + GetHeaderHeight;
  end;
end;

procedure TSCCustomNavPanel.GradientChanged(Sender: TObject);
begin
  UpdateBuffer(True);
  DoGradientChanged(Sender);
end;

procedure TSCCustomNavPanel.HeaderChanged(Force: Boolean);
begin
  if Force then
    FDefaultHeaderHeight := -1;

  UpdatePanel(Force);
  UpdateHottrackInfo;

  DoHeaderChanged(Force);
end;

procedure TSCCustomNavPanel.ImageListChange(Sender: TObject);
begin
  FDefaultHeaderHeight := -1;
  if HandleAllocated and FHeader.Visible then
    UpdatePanel(True);
end;

procedure TSCCustomNavPanel.IndentChanged;
begin
  if HandleAllocated and FHeader.Visible then
    UpdateBuffer(True);
end;

procedure TSCCustomNavPanel.Loaded;
begin
  try
    inherited Loaded;
    FDefaultHeaderHeight := -1;
    UpdatePanel(True);
  finally
    FControlLoaded := True;
  end;
end;

procedure TSCCustomNavPanel.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Designing: Boolean;
  OldDown, OldHot: TSCNavPanelHitInfo;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if ClickFocus and CanFocus then
    SetFocus;

  OldDown := FHitInfo;
  OldHot := FHottrackInfo;

  InitializeHitTest(@FHitInfo);
  InitializeHitTest(@FHottrackInfo);

  FHitInfo.x := X;
  FHitInfo.y := Y;

  FHitInfo.Clicked := True;
  FHitInfo.IsLeftBtn := Button = mbLeft;

  FHottrackInfo.x := X;
  FHottrackInfo.y := Y;

  Designing := IsDesigning;
  
  if Enabled or Designing then
  begin
    FHottrackInfo := GetHitInfo(Point(X, Y));
    if Button = mbLeft then FHitInfo := FHottrackInfo;

    if not IsDesigning then
      UpdateBuffer;

    if Button = mbLeft then
      MouseIsDown := True;
  end;
end;

procedure TSCCustomNavPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  OldHot: TSCNavPanelHitInfo;
begin
  inherited MouseMove(Shift, X, Y);

  if Enabled then
  begin
    OldHot := FHottrackInfo;

    InitializeHitTest(@FHottrackInfo);
    FHottrackInfo := GetHitInfo(Point(X, Y));

    CheckMouseUpdate(OldHot);
  end;
end;

procedure TSCCustomNavPanel.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldHit, OldHot: TSCNavPanelHitInfo;
begin
  inherited MouseUp(Button, Shift, X, Y);

  OldHit := FHitInfo;
  OldHot := FHottrackInfo;

  InitializeHitTest(@FHitInfo);
  InitializeHitTest(@FHottrackInfo);

  if Enabled then
  begin
    FHitInfo.x := X;
    FHitInfo.y := Y;

    FHottrackInfo.x := X;
    FHottrackInfo.y := Y;

    FHottrackInfo := GetHitInfo(Point(X, Y));

    if not IsDesigning then
      UpdateBuffer;

    if (FHottrackInfo.Part = OldHit.Part) and
      (OldHit.Part = scnppCloseButton) then
      CloseClick;
  end;
end;

procedure TSCCustomNavPanel.Paint;
var
  R: TRect;
begin
  if (FBufferUpdate = 0) and (FPaintBuffer <> nil) then
    Canvas.Draw(0, 0, FPaintBuffer)
  else begin
    R := GetClientRect;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := GetDefaultBackColor;
      FillRect(R);
    end;

    DrawGradientBack(Canvas);
    DrawHeader(Canvas);
    DrawCloseButton(Canvas);
  end;
end;

procedure TSCCustomNavPanel.SetGradient(Value: TSCNavPanelGradient);
begin
  FGradient.Assign(Value);
end;

procedure TSCCustomNavPanel.SetHeader(Value: TSCNavPanelHeader);
begin
  FHeader.Assign(Value);
end;

procedure TSCCustomNavPanel.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;
  inherited SetIndent(Value);
end;

procedure TSCCustomNavPanel.UpdateBuffer(Repaint: Boolean);
var
  OldDC: THandle;
begin
  if FPaintBuffer <> nil then
  begin
    Inc(FBufferUpdate);
    try
      OldDC := Canvas.Handle;
      try
        Canvas.Handle := FPaintBuffer.Canvas.Handle;
        Paint;
      finally
        Canvas.Handle := OldDC;
      end;
    finally
      Dec(FBufferUpdate);
    end;

    if Repaint and (FBufferUpdate = 0) then
      Invalidate;
  end;
end;

procedure TSCCustomNavPanel.UpdatePanel(ARealign: Boolean);
begin
  if FPaintBuffer <> nil then
  begin
    FPaintBuffer.Width := ClientWidth;
    FPaintBuffer.Height := ClientHeight;

    UpdateBuffer;
  end;

  if HandleAllocated and ARealign and
    not (IsLoading or IsDestroying) then
  begin
    Self.Realign;
    UpdateBuffer;
  end;
end;

procedure TSCCustomNavPanel.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TSCCustomNavPanel.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdatePanel(True);
end;

function TSCCustomNavPanel.GetGradientPeal(AColor: TColor): TColor;
begin
  Result := BlendedColor(AColor, 52, 44, 112, True);
end;

procedure TSCCustomNavPanel.DoDrawCloseButton(ACanvas: TCanvas;
  ARect: TRect; ADown, AHot: Boolean; var ABackColor, AForeColor: TColor;
  var Handled: Boolean);
begin

end;

procedure TSCCustomNavPanel.DrawCloseButton(ACanvas: TCanvas);
var
  ARect, R: TRect;
  Handled: Boolean;
  X, Y, SR: Integer;
  IsDown, IsHot: Boolean;
  AColor, AForeColor: TColor;
begin
  if FHeader.Visible and FHeader.CloseButton then
  begin
    ARect := GetCloseButtonRect;

    if not IsRectEmpty(ARect) then
    begin
      IsHot := False;
      IsDown := False;

      if not IsDesigning then
      begin
        IsHot := FHottrackInfo.Part = scnppCloseButton;
        IsDown := FHitInfo.Part = scnppCloseButton;
      end;

      AColor := GetButtonColor(IsHot, IsDown, False);
      AForeColor := GetButtonTextColor(IsHot, IsDown, False);

      if AColor <> clNone then
        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := AColor;

          FillRect(ARect);
        end;

      with ACanvas do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := GetBtnHighlightOf(AColor);

        MoveTo(ARect.Left, ARect.Top);
        LineTo(ARect.Right, ARect.Top);
      end;

      SR := IntersectClipRect(ACanvas.Handle,
        ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
      try
        if SR <> NULLREGION then
        begin
          Handled := False;

          if Assigned(FOnCustomDrawCloseButton) then
            FOnCustomDrawCloseButton(Self, ACanvas, ARect, IsDown,
              IsHot, AColor, AForeColor, Handled);

          if not Handled then
            DoDrawCloseButton(ACanvas, ARect, IsDown, IsHot,
              AColor, AForeColor, Handled);

          if Handled then
            Exit;
        end;
      finally
        SelectClipRgn(ACanvas.Handle, 0);
      end;

      DrawButtonFace(ACanvas, ARect, FHeader.Style,
        AColor, IsDown, IsHot);

      with ACanvas do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := GetBtnHighlightOf(AColor);

        MoveTo(ARect.Left, ARect.Top);
        LineTo(ARect.Right, ARect.Top);
      end;

      if AForeColor <> clNone then
        with ACanvas do
        begin
          Brush.Style := bsClear;

          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Color := AForeColor;
          Pen.Width := 1;

          R := ARect;

          X := R.Left + ((R.Right - R.Left) div 2) - 3;
          Y := R.Top + ((R.Bottom - R.Top - 6) div 2);

          MoveTo(X, Y);
          LineTo(X + 6, Y + 6);

          MoveTo(X + 1, Y);
          LineTo(X + 7, Y + 6);

          MoveTo(X + 5, Y);
          LineTo(X - 1, Y + 6);

          MoveTo(X + 6, Y);
          LineTo(X, Y + 6);
        end;
    end;
  end;
end;

function TSCCustomNavPanel.GetCloseButtonRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if HandleAllocated and FHeader.Visible and FHeader.CloseButton then
  begin
    Result := GetClientRect;
    OffsetRect(Result, -1, 0);

    Result.Bottom := Result.Top + GetHeaderHeight - 1;
    Result.Left := Result.Right - SC_NavPanelCloseButtonSize;
  end;
end;

function TSCCustomNavPanel.CanClose: Boolean;
begin
  Result := True;
  if Assigned(FOnAllowClose) then FOnAllowClose(Self, Result);
end;

procedure TSCCustomNavPanel.CloseClick;
begin
  if CanClose then
  begin
    DoCloseClick;
    if Assigned(FOnCloseClick) then
      FOnCloseClick(Self);
  end;
end;

procedure TSCCustomNavPanel.DoCloseClick;
begin
  //
end;

procedure TSCCustomNavPanel.InitializeHitTest(AHitInfo: PSCNavPanelHitInfo);
begin
  with AHitInfo^ do
  begin
    X := -1;
    Y := -1;
    Clicked := False;
    IsLeftBtn := False;
    Part := scnppNowhere;
  end;
end;

function TSCCustomNavPanel.GetButtonColor(IsHot, IsDown,
  IsActive: Boolean): TColor;
begin
  Result := clNone;

  if FHeader.Style = scnbOfficeXP then
  begin
    if IsActive then
    begin
      if IsHot or (IsHot and IsDown) then
        Result := GetOfficeXPDownedSelColor
      else
        Result := GetOfficeXPDownedColor;
    end else
    if IsHot and IsDown then
      Result := GetOfficeXPDownedSelColor
    else
    if IsHot or IsDown then
      Result := GetOfficeXPSelColor;
  end else
  if FHeader.Style = scnbOffice12 then
  begin
    Result := clNone;

    if IsDown or IsHot or IsActive then
    begin
      Result := FHeader.HighlightColor;

      if IsActive then
      begin
        if IsHot or (IsHot and IsDown) then
          Result := scBlendColor(Result, -12)
        else
          Result := scBlendColor(Result, 20);
      end else
      if IsHot and IsDown then
        Result := scBlendColor(Result, -16)
      else
      if IsHot or IsDown then
        Result := scBlendColor(Result, -6);
    end;
  end else
  begin
    Result := clNone;

    if IsDown or IsHot or IsActive then
    begin
      Result := FHeader.HighlightColor;

      if IsActive then
      begin
        if IsHot or (IsHot and IsDown) then
          Result := scBlendColor(Result, -24);
      end else
      if IsHot and IsDown then
        Result := scBlendColor(Result, -16)
      else
      if IsDown then
        Result := scBlendColor(Result, -8)
      else
      if IsHot then
        Result := scBlendColor(Result, 20);
    end;
  end;
end;

function TSCCustomNavPanel.GetButtonTextColor(IsHot, IsDown,
  IsActive: Boolean): TColor;
begin
  Result := FHeader.ButtonIconColor;

  if FHeader.Style = scnbOfficeXP then
  begin
    if IsActive and IsHot then
      Result := clHighlightText
    else
    if not IsActive and IsHot and IsDown then
      Result := clHighlightText;
  end;
end;

procedure TSCCustomNavPanel.CheckMouseUpdate(OldHot: TSCNavPanelHitInfo);
var
  IsHot, WasHot, NeedsUpdate: Boolean;
begin
  if Enabled and not IsDesigning then
  begin
    WasHot := OldHot.Part in SC_NavPanelHotParts;
    IsHot := FHottrackInfo.Part in SC_NavPanelHotParts;

    NeedsUpdate := ((FHitInfo.Part = scnppNowhere) or (FHitInfo.Part in SC_NavPanelHotParts)) and
      ((IsHot <> WasHot) or (IsHot and (FHottrackInfo.Part <> OldHot.Part)));

    if not NeedsUpdate and FHeader.Visible and FHeader.CloseButton then
    begin
      WasHot := OldHot.Part = scnppCloseButton;
      IsHot := FHottrackInfo.Part = scnppCloseButton;

      NeedsUpdate := (FHitInfo.Part in [scnppNowhere, scnppCloseButton]) and
        (IsHot <> WasHot);
    end;

    if NeedsUpdate then
      UpdateBuffer;
  end;
end;

procedure TSCCustomNavPanel.UpdateHottrackInfo;
var
  P: TPoint;
  OldHot: TSCNavPanelHitInfo;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);

  OldHot := FHottrackInfo;
  InitializeHitTest(@FHottrackInfo);

  FHottrackInfo.X := P.x;
  FHottrackInfo.Y := P.y;

  if not IsDesigning then
    FHottrackInfo := GetHitInfo(P);

  CheckMouseUpdate(OldHot);
end;

function TSCCustomNavPanel.GetHitInfo(const P: TPoint): TSCNavPanelHitInfo;
var
  R, CR: TRect;
begin
  InitializeHitTest(@Result);

  with Result do
  begin
    X := P.x;
    Y := P.y;
  end;

  if FHitInfo.Clicked then
  begin
    Result.Clicked := True;
    Result.IsLeftBtn := FHitInfo.IsLeftBtn;
  end;

  CR := GetClientRect;

  if PtInRect(CR, P) then
  begin
    Result.Part := scnppClient;

    if FHeader.Visible then
    begin
      R := CR;
      R.Bottom := R.Top + GetHeaderHeight;

      if not IsRectEmpty(R) and PtInRect(R, P) then
      begin
        Result.Part := scnppHeader;

        if FHeader.CloseButton then
        begin
          R.Left := R.Right - SC_NavPanelCloseButtonSize;
          if IntersectRect(R, R, CR) and PtInRect(R, P) then
            Result.Part := scnppCloseButton;

          Exit;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomNavPanel.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  UpdateHottrackInfo;
end;

procedure TSCCustomNavPanel.CMMouseLeave(var Message: TMessage);
var
  OldHot: TSCNavPanelHitInfo;
begin
  inherited;

  if not IsDesigning then
  begin
    OldHot := FHottrackInfo;
    
    InitializeHitTest(@FHottrackInfo);
    CheckMouseUpdate(OldHot);
  end;
end;

procedure TSCCustomNavPanel.StopTracking;
begin
  inherited StopTracking;

  InitializeHitTest(@FHitInfo);
  UpdateHottrackInfo;
end;

{ TSCNavPanelBorderProps }

constructor TSCNavPanelBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccbNone;
end;

{$I SCVerRec.inc}

end.
