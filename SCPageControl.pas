{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCPageControl;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ImgList, {$IFDEF SC_DELPHI6_UP} Types, Variants, {$ENDIF}
  SCCommon, SCConsts, SCControl;

type
  TSCBaseTabControl = class;
  TSCCustomTabControl = class;

  TSCTabPoints = array of TPoint;
  PSCTabPoints = ^TSCTabPoints;

  TSCTabData = class(TPersistent)
  private
    FCaption: String;
    FColor: TColor;
    FEnabled: Boolean;
    FFontColor: TColor;
    FHint: String;
    FDisabledImage: TImageIndex;
    FHotImage: TImageIndex;
    FImageIndex: TImageIndex;
    FVisible: Boolean;
    FTag: Longint;
    FPoints: TSCTabPoints;
    FTabItem: TObject;
    FIndex: Integer;
    FTabRect: TRect;
    FRegion: HRGN;
    FShowing: Boolean;
    function  GetPoints: TSCTabPoints;
    procedure SetPoints(Value: TSCTabPoints);
    procedure SetRegion(Value: HRGN);
    procedure SetTabRect(Value: TRect);
  protected
    property Index: Integer read FIndex write FIndex;
    property Points: TSCTabPoints read GetPoints write SetPoints;
    property TabItem: TObject read FTabItem write FTabItem;
    property TabRect: TRect read FTabRect write SetTabRect;
    property Region: HRGN read FRegion write SetRegion;
    property Showing: Boolean read FShowing write FShowing;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Caption: String read FCaption write FCaption;
    property Color: TColor read FColor write FColor;
    property Enabled: Boolean read FEnabled write FEnabled;
    property FontColor: TColor read FFontColor write FFontColor;
    property Hint: String read FHint write FHint;
    property DisabledImage: TImageIndex read FDisabledImage write FDisabledImage;
    property HotImage: TImageIndex read FHotImage write FHotImage;
    property ImageIndex: TImageIndex read FImageIndex write FImageIndex;
    property Tag: Longint read FTag write FTag;
    property Visible: Boolean read FVisible write FVisible;
  end;

  TSCDataList = class(TObject)
  private
    FList: TList;
    function Get(Index: Integer): TSCTabData;
  public
    constructor Create;
    destructor Destroy; override;

    function  Count: Integer;
    function  Add: TSCTabData;
    procedure Delete(Index: Integer);
    procedure Clear;

    property Items[Index: Integer]: TSCTabData read Get; default;
  end;

  TSCTabStyle = (sctbButton, sctbEclipse, sctbWin2K, sctbDotNet,
    sctbDotNetFlat, sctbFlatButton, sctbOffice12, sctbOfficeXP, sctbNew,
    sctbNewX, sctbXP, sctbWhidbey);

  TSCTabPosition = (sctpTop, sctpBottom, sctpLeft, sctpRight);
  TSCTabOrientation = (sctoDefault, sctoHorizontal, sctoVertical);

  TSCTabHitTest = (scphNowhere, scphClient, scphCard, scphCloseButton,
    scphLeftScroll, scphRightScroll, scphTab);

  TSCTabHottrackStyle = (schsTab, schsText, schsTabAndText);

  TSCTabHitInfo = record
    X: Integer;
    Y: Integer;
    Tab: Integer;
    Clicked: Boolean;
    LeftButton: Boolean;
    HitPos: TSCTabHitTest;
  end;
  PSCTabHitInfo = ^TSCTabHitInfo;

  TSCTabColors = class(TPersistent)
  private
    FHighlightBar: TColor;
    FHottrackBar: TColor;
    FHottrackText: TColor;
    FUnselected: TColor;
    FUnselectedText: TColor;
    FOwner: TSCBaseTabControl;
    procedure SetHighlightBar(Value: TColor);
    procedure SetHottrackBar(Value: TColor);
    procedure SetHottrackText(Value: TColor);
    procedure SetUnselected(Value: TColor);
    procedure SetUnselectedText(Value: TColor);
  protected
    procedure DoChange;
    function  GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TSCBaseTabControl); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property HighlightBar: TColor read FHighlightBar write SetHighlightBar default clHighlight;
    property HottrackBar: TColor read FHottrackBar write SetHottrackBar default SC_HottrackColor;
    property HottrackText: TColor read FHottrackText write SetHottrackText default clBlue;
    property Unselected: TColor read FUnselected write SetUnselected default clNone;
    property UnselectedText: TColor read FUnselectedText write SetUnselectedText default clNone;
  end;

  TSCTabGradient = (sctgNone, sctgDefault, sctgHorizontal, sctgVertical);

  TSCTabPart = (sctpClient, sctpTab, sctpCloseBtn, sctpLeftBtn, sctpRightBtn);

  TSCTabCloseEvent = procedure(Sender: TObject; var AllowClose: Boolean) of object;
  TSCTabChangingEvent = procedure(Sender: TObject; NewIndex: Integer;
    var AllowChange: Boolean) of object;

  TSCTabEllipsisType = (scteNone, scteEndEllipsis, sctePathEllipsis);

  TSCBaseTabControl = class(TSCCustomControl)
  private
    FAlignment: TLeftRight;
    FAutoTabSize: Boolean;
    FBackgroundColor: TColor;
    FButtonColor: TColor;
    FButtonIconColor: TColor;
    FDefaultTabSize: Word;
    FEllipsisType: TSCTabEllipsisType;
    FFrameColor: TColor;
    FImageSpacing: Integer;
    FTabGradient: TSCTabGradient;
    FHottrack: Boolean;
    FHottrackStyle: TSCTabHottrackStyle;
    FTabOrientation: TSCTabOrientation;
    FTabPosition: TSCTabPosition;
    FShowCardFrame: Boolean;
    FShowCloseButton: Boolean;
    FShowFocusRect: Boolean;
    FStyle: TSCTabStyle;
    FTabColors: TSCTabColors;
    FTabIndex: Integer;
    FTabIndexDefault: Integer;
    FDataList: TSCDataList;
    FHitInfo: TSCTabHitInfo;
    FHottrackInfo: TSCTabHitInfo;
    FTabsRect: TRect;
    FScrollersVisible: Boolean;
    FVisibleTabCount: Integer;
    FTextHeight: Integer;
    FTabSize: Integer;
    FBufferUpdate: Integer;
    FPaintBuffer: TBitmap;
    FDesignChange: Boolean;
    FUseTabColors: Boolean;
    FOnTabClick: TNotifyEvent;
    FOnTabChange: TNotifyEvent;
    FOnTabChanging: TSCTabChangingEvent;
    FOnTabClose: TSCTabCloseEvent;
    FScrolling: Boolean;
    FScrollingLeft: Boolean;
    FScrollingPaused: Boolean;
    FScrollTimer: Integer;
    FFirstTab: Integer;
    FControlLoaded: Boolean;
    FMaximumWidth: Integer;
    procedure SetAlignment(Value: TLeftRight);
    procedure SetAutoTabSize(Value: Boolean);
    procedure SetBackgroundColor(Value: TColor);
    procedure SetButtonColor(Value: TColor);
    procedure SetButtonIconColor(Value: TColor);
    procedure SetDefaultTabSize(Value: Word);
    procedure SetEllipsisType(Value: TSCTabEllipsisType);
    procedure SetFrameColor(Value: TColor);
    procedure SetImageSpacing(Value: Integer);
    procedure SetHottrack(Value: Boolean);
    procedure SetHottrackStyle(Value: TSCTabHottrackStyle);
    procedure SetMaximumWidth(Value: Integer);
    procedure SetShowCardFrame(Value: Boolean);
    procedure SetShowCloseButton(Value: Boolean);
    procedure SetShowFocusRect(Value: Boolean);
    procedure SetStyle(Value: TSCTabStyle);
    procedure SetTabColors(Value: TSCTabColors);
    procedure SetTabGradient(Value: TSCTabGradient);
    procedure SetTabIndex(Value: Integer);
    procedure SetTabOrientation(Value: TSCTabOrientation);
    procedure SetTabPosition(Value: TSCTabPosition);

    function  GetBandRect: TRect;
    function  GetTabsRect: TRect;
    function  GetCardRect: TRect;

    procedure ColorsChanged;
    procedure TabIndexChanged;
    procedure UpdateFontSize;

    procedure CloseClick;

    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure AdjustClientRect(var ARect: TRect); override;

    procedure Loaded; override;
    procedure CreateWnd; override;
    procedure Paint; override;

    function  GetControlLoaded: Boolean;
    procedure SetControlLoaded(Value: Boolean);

    function  GetTabIndexDefault: Integer;
    procedure SetTabIndexDefault(Value: Integer);

    procedure UpdateDesigner;

    procedure ReadActiveTab(Reader: TReader); virtual;
    procedure WriteActiveTab(Writer: TWriter); virtual;

    function  CanClose: Boolean; dynamic;
    procedure Changing(NewIndex: Integer; var Allowed: Boolean); virtual;

    procedure SetUseTabColors(Value: Boolean); virtual;

    procedure DestroyActiveTab; virtual;
    procedure ActiveTabMoved(Index: Integer); virtual;

    procedure RedrawTabs; virtual;
    procedure UpdateBuffer(OnlyTabs: Boolean = False);
    function  GetDataList: TSCDataList;

    procedure InitializeHitTest(AHitInfo: PSCTabHitInfo);

    procedure StopTracking; override;
    procedure SpacingChanged; override;

    procedure UpdateHottrackInfo;
    procedure CheckMouseUpdate(OldHot: TSCTabHitInfo);

    function  RectFromPoints(Points: TSCTabPoints): TRect;

    function  GetFrameColor: TColor; virtual;
    function  GetTabColor(Tab: TSCTabData): TColor; virtual;
    function  GetTabTextColor(Tab: TSCTabData): TColor; virtual;

    function  GetTabFontColor(Tab: TSCTabData): TColor; virtual;
    function  GetTabImage(Tab: TSCTabData): TImageIndex; virtual;

    procedure DrawTabs; virtual;
    procedure DrawCloseButton; virtual;
    procedure DrawScrollers(Left: Boolean); virtual;

    procedure PaintTab(C: TCanvas; Tab: TSCTabData); virtual;
    procedure DrawShadow(Tab: TSCTabData; R: TRect); virtual;
    procedure DrawHottrack(Tab: TSCTabData; R: TRect); virtual;
    procedure DrawBackground(Tab: TSCTabData; R: TRect); virtual;
    procedure DrawImageAndText(Tab: TSCTabData; R: TRect); virtual;

    procedure DrawButtonTab(C: TCanvas; Tab: TSCTabData); virtual;
    procedure DrawDotNetTab(C: TCanvas; Tab: TSCTabData); virtual;
    procedure DrawDotNetFlatTab(C: TCanvas; Tab: TSCTabData); virtual;
    procedure DrawEclipseTab(C: TCanvas; Tab: TSCTabData); virtual;
    procedure DrawFlatButtonTab(C: TCanvas; Tab: TSCTabData); virtual;
    procedure DrawOffice12Tab(C: TCanvas; Tab: TSCTabData); virtual;
    procedure DrawOfficeXpTab(C: TCanvas; Tab: TSCTabData); virtual;
    procedure DrawNewTab(C: TCanvas; Tab: TSCTabData); virtual;
    procedure DrawNewXTab(C: TCanvas; Tab: TSCTabData); virtual;
    procedure DrawXpTab(C: TCanvas; Tab: TSCTabData); virtual;
    procedure DrawWhidbeyTab(C: TCanvas; Tab: TSCTabData); virtual;
    procedure DrawWin2KTab(C: TCanvas; Tab: TSCTabData); virtual;

    procedure DrawCard(R: TRect); virtual;
    procedure DrawCardBackground(R: TRect); virtual;

    procedure DrawDotNetCard(R: TRect); virtual;
    procedure DrawDotNetFlatCard(R: TRect); virtual;
    procedure DrawEclipseCard(R: TRect); virtual;
    procedure DrawNewCard(R: TRect); virtual;
    procedure DrawNewXCard(R: TRect); virtual;
    procedure DrawOffice12Card(R: TRect); virtual;
    procedure DrawXpCard(R: TRect); virtual;
    procedure DrawWhidbeyCard(R: TRect); virtual;
    procedure DrawWin2KCard(R: TRect); virtual;

    procedure ScrollTabs(Left: Boolean);
    function  CanScroll: Boolean;
    procedure PauseScroll;
    procedure ResumeScroll;
    procedure StopScroll;
    function  Scrolling: Boolean;
    function  ScrollPaused: Boolean;

    procedure FirstTabChanged; virtual;
    function  ArrangeFirstTab(Value: Integer): Integer; virtual;
    procedure SetFirstTab(Value: Integer);

    procedure MakeTabVisible(Index: Integer;
      UpdateAfter: Boolean); dynamic;

    function  GetIndent: Integer; override;
    procedure SetIndent(Value: Integer); override;
    procedure IndentChanged; override;
    procedure ImageListChange(Sender: TObject); override;

    procedure DoColorsChanged; virtual;
    procedure DoTabIndexChanged; virtual;

    procedure UpdateTabs(Realign: Boolean = False);
    procedure StoreCalcValues;
    procedure FillDataList; virtual;
    procedure UpdateTabRects; virtual;

    procedure DoCloseClick; virtual;
    procedure TabClick; virtual;

    function  GetMaximumTabSize: Integer;
    function  CheckVisible(Index: Integer): Integer;
    function  GetScrollersVisible: Boolean; virtual;
    function  GetVisibleTabCount: Integer; virtual;
    function  GetBorderIndent: Integer; virtual;

    function  GetActiveIndex: Integer; dynamic;
    function  GetVisibleIndexOf(Index: Integer): Integer; dynamic;

    function  GetFirstShowingTab: Integer; dynamic;
    function  GetLastShowingTab: Integer; dynamic;

    function  GetFirstVisibleTab: Integer; dynamic;
    function  GetLastVisibleTab: Integer; dynamic;

    function  GetPrevVisibleTab(Index: Integer): Integer; dynamic;
    function  GetNextVisibleTab(Index: Integer): Integer; dynamic;

    function  GetTabSize: Integer; dynamic;
    procedure CalculateTabSize(Index: Integer; var W, H: Integer); dynamic;

    function  GetTabSpacing: Integer; virtual;
    function  GetTabRect(Index: Integer): TRect; virtual;
    function  GetTabPoints(R: TRect; ForRegion: Boolean;
      Rounding, FrameIndex: Integer): TSCTabPoints; virtual;

    function  GetCloseButtonRect: TRect; virtual;
    function  GetScrollerRect(Left: Boolean): TRect; virtual;

    function  HitTest(const P: TPoint): TSCTabHitInfo; virtual;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property DataList: TSCDataList read FDataList;
    property TabsRect: TRect read FTabsRect;
    property ScrollersVisible: Boolean read FScrollersVisible;
    property VisibleTabCount: Integer read FVisibleTabCount;
    property TabSize: Integer read FTabSize;

    property TextHeight: Integer read FTextHeight;
    property Spacing default 0;
    property ControlLoaded: Boolean read FControlLoaded;
    property Alignment: TLeftRight read FAlignment write SetAlignment default taLeftJustify;
    property AutoTabSize: Boolean read FAutoTabSize write SetAutoTabSize default True;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor default clNone;
    property ButtonColor: TColor read FButtonColor write SetButtonColor default clBtnFace;
    property ButtonIconColor: TColor read FButtonIconColor write
      SetButtonIconColor default clWindowText;
    property DefaultTabSize: Word read FDefaultTabSize write SetDefaultTabSize default 72;
    property EllipsisType: TSCTabEllipsisType read FEllipsisType write SetEllipsisType default scteEndEllipsis;
    property FrameColor: TColor read FFrameColor write SetFrameColor default clBtnShadow;
    property Hottrack: Boolean read FHottrack write SetHottrack default True;
    property HottrackStyle: TSCTabHottrackStyle read FHottrackStyle write SetHottrackStyle default schsTabAndText;
    property ImageSpacing: Integer read FImageSpacing write SetImageSpacing default 2;
    property MaximumWidth: Integer read FMaximumWidth write SetMaximumWidth default -1;
    property ShowCardFrame: Boolean read FShowCardFrame write SetShowCardFrame default True;
    property ShowCloseButton: Boolean read FShowCloseButton write SetShowCloseButton default False;
    property ShowFocusRect: Boolean read FShowFocusRect write SetShowFocusRect default True;
    property Style: TSCTabStyle read FStyle write SetStyle default sctbWin2K;
    property TabColors: TSCTabColors read FTabColors write SetTabColors;
    property TabGradient: TSCTabGradient read FTabGradient write SetTabGradient default sctgDefault;
    property TabIndex: Integer read FTabIndex write SetTabIndex default -1;
    property TabOrientation: TSCTabOrientation read FTabOrientation write SetTabOrientation default sctoDefault;
    property TabPosition: TSCTabPosition read FTabPosition write SetTabPosition default sctpTop;
    property UseTabColors: Boolean read FUseTabColors write SetUseTabColors default False;
    property OnTabClick: TNotifyEvent read FOnTabClick write FOnTabClick;
    property OnTabChange: TNotifyEvent read FOnTabChange write FOnTabChange;
    property OnTabChanging: TSCTabChangingEvent read FOnTabChanging write FOnTabChanging;
    property OnTabClose: TSCTabCloseEvent read FOnTabClose write FOnTabClose;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function  TabAtPos(const P: TPoint): Integer;
    procedure CloseActiveTab;

    procedure HideAllTabs; virtual;
    procedure ShowAllTabs; virtual;
  end;

  TSCTabItem = class(TCollectionItem)
  private
    FCaption: string;
    FColor: TColor;
    FEnabled: Boolean;
    FFontColor: TColor;
    FHint: string;
    FDisabledImage: TImageIndex;
    FHotImage: TImageIndex;
    FImageIndex: TImageIndex;
    FVisible: Boolean;
    FShowing: Boolean;
    FTag: Longint;
    FData: TObject;
    FTabRect: TRect;
    function  GetShowing: Boolean;
    procedure SetCaption(const Value: String);
    procedure SetColor(Value: TColor);
    procedure SetEnabled(Value: Boolean);
    procedure SetFontColor(Value: TColor);
    procedure SetHint(const Value: String);
    procedure SetDisabledImage(Value: TImageIndex);
    procedure SetHotImage(Value: TImageIndex);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetVisible(Value: Boolean);
    procedure SetTabRect(Value: TRect);
  protected
    function GetDisplayName: string; override;
    procedure AssignTo(Dest: TPersistent); override;

    property TabRect: TRect read FTabRect write SetTabRect;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;

    property Showing: Boolean read GetShowing;
    property Data: TObject read FData write FData;
  published
    property Caption: String read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property FontColor: TColor read FFontColor write SetFontColor default clNone;
    property Hint: String read FHint write SetHint;
    property DisabledImage: TImageIndex read FDisabledImage write SetDisabledImage default -1;
    property HotImage: TImageIndex read FHotImage write SetHotImage default -1;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Tag: Longint read FTag write FTag default 0;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TSCTabItems = class(TCollection)
  private
    FOwner: TSCCustomTabControl;
    function  GetItem(Index: Integer): TSCTabItem;
    procedure SetItem(Index: Integer; Value: TSCTabItem);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TSCCustomTabControl); virtual;

    function  Add: TSCTabItem;
    procedure Delete(Index: Integer);
    procedure Move(CurIndex, NewIndex: Integer);
    procedure Clear;

    property Items[Index: Integer]: TSCTabItem read GetItem write SetItem; default;
  end;

  TSCCustomTabControl = class(TSCBaseTabControl)
  private
    FTabs: TSCTabItems;
    procedure SetTabs(Value: TSCTabItems);
  protected
    procedure FillDataList; override;
    procedure UpdateTabRects; override;

    function  GetFirstShowingTab: Integer; override;
    function  GetLastShowingTab: Integer; override;

    function  GetFirstVisibleTab: Integer; override;
    function  GetLastVisibleTab: Integer; override;

    function  GetTabSize: Integer; override;
    function  GetActiveIndex: Integer; override;
    procedure CalculateTabSize(Index: Integer; var W, H: Integer); override;

    function  GetScrollersVisible: Boolean; override;
    function  GetVisibleTabCount: Integer; override;

    procedure DoCloseClick; override;

    property Tabs: TSCTabItems read FTabs write SetTabs;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure HideAllTabs; override;
    procedure ShowAllTabs; override;
  end;

  TSCTabControl = class(TSCCustomTabControl)
  published
    property Align;
    property Alignment;
    property AutoTabSize;
    property BackgroundColor;
    property ButtonColor;
    property ButtonIconColor;
    property ClickFocus;
    property Color;
    property DefaultTabSize;
    property EllipsisType;
    property FrameColor;
    property Font;
    property TabGradient;
    property Hottrack;
    property HottrackStyle;
    property Images;
    property ImageSpacing;
    property Indent;
    property MaximumWidth;
    property ParentColor;
    property ParentFont;
    property ShowCardFrame;
    property ShowCloseButton;
    property ShowFocusRect;
    property Spacing;
    property Style;
    property TabColors;
    property TabIndex;
    property TabOrientation;
    property TabPosition;
    property Tabs;
    property UseTabColors;
    property Visible;
    property OnClick;
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
    property OnStartDock;
    property OnStartDrag;
    property OnTabClick;
    property OnTabClose;
    property OnTabChange;
    property OnTabChanging;
    property OnUnDock;
  end;

  TSCCustomPageControl = class;

  TSCTabSheet = class(TSCCustomControl)
  private
    FImageIndex: TImageIndex;
    FDisabledImage: TImageIndex;
    FHotImage: TImageIndex;
    FPageControl: TSCCustomPageControl;
    FTabEnabled: Boolean;
    FTabVisible: Boolean;
    FData: Pointer;
    FShowing: Boolean;
    FTabRect: TRect;
    FFontColor: TColor;

    procedure Changed;
    procedure InternalSetVisible(Value: Boolean);

    function  GetColor: TColor;
    procedure SetColor(Value: TColor);
    procedure SetFontColor(Value: TColor);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetDisabledImage(Value: TImageIndex);
    procedure SetHotImage(Value: TImageIndex);
    procedure SetPageControl(APageControl: TSCCustomPageControl);
    function  GetPageIndex: Integer;
    procedure SetPageIndex(Value: Integer);
    procedure SetTabEnabled(Value: Boolean);
    function  GetTabIndex: Integer;
    procedure SetTabVisible(Value: Boolean);
    function  GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    procedure SetTabRect(Value: TRect);
    function  GetTabVisible: Boolean;

    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure CreateParams(var Params: TCreateParams); override;

    procedure Paint; override;
    procedure ReadState(Reader: TReader); override;
    function  GetImages: TCustomImageList; override;

    property TabRect: TRect read FTabRect write SetTabRect;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Data: Pointer read FData write FData;
    property TabIndex: Integer read GetTabIndex;
    property Visible: Boolean read GetVisible write SetVisible;
    property PageControl: TSCCustomPageControl read FPageControl write SetPageControl;
  published
    property Color: TColor read GetColor write SetColor default clBtnFace;
    property FontColor: TColor read FFontColor write SetFontColor default clNone;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property HotImage: TImageIndex read FHotImage write SetHotImage default -1;
    property DisabledImage: TImageIndex read FDisabledImage write SetDisabledImage default -1;
    property PageIndex: Integer read GetPageIndex write SetPageIndex stored False;
    property TabEnabled: Boolean read FTabEnabled write SetTabEnabled default True;
    property TabVisible: Boolean read FTabVisible write SetTabVisible default True;

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

  TSCCustomPageControl = class(TSCBaseTabControl)
  private
    FPages: TList;
    FActivePage: TSCTabSheet;
    FNewDockSheet: TSCTabSheet;
    FUndockingPage: TSCTabSheet;
    FInitActivePage: Boolean;

    procedure InsertPage(Page: TSCTabSheet);
    procedure RemovePage(Page: TSCTabSheet);
    procedure ChangeActivePage(Page: TSCTabSheet);
    function  GetDockClientAt(P: TPoint): TControl;

    procedure ReadEmptyData(Reader: TReader); 
    procedure WriteEmptyData(Writer: TWriter);

    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDockClient(var Message: TCMDockClient); message CM_DOCKCLIENT;
    procedure CMDockNotification(var Message: TCMDockNotification); message CM_DOCKNOTIFICATION;
    procedure CMUnDockClient(var Message: TCMUnDockClient); message CM_UNDOCKCLIENT;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure CreateParams(var Params: TCreateParams); override;

    procedure Loaded; override;

    procedure FillDataList; override;
    procedure UpdateTabRects; override;

    procedure Changing(NewIndex: Integer; var Allowed: Boolean); override;

    function  GetFirstShowingTab: Integer; override;
    function  GetLastShowingTab: Integer; override;

    function  GetFirstVisibleTab: Integer; override;
    function  GetLastVisibleTab: Integer; override;

    function  GetTabSize: Integer; override;
    function  GetActiveIndex: Integer; override;
    procedure CalculateTabSize(Index: Integer; var W, H: Integer); override;

    function  GetScrollersVisible: Boolean; override;
    function  GetVisibleTabCount: Integer; override;

    procedure DoCloseClick; override;
    procedure DoTabIndexChanged; override;

    procedure DestroyActiveTab; override;
    procedure ActiveTabMoved(Index: Integer); override;

    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure SetChildOrder(Child: TComponent; Order: Integer); override;
    procedure ShowControl(AControl: TControl); override;

    procedure DoAddDockClient(Client: TControl; const ARect: TRect); override;
    procedure DockOver(Source: TDragDockObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean); override;
    procedure DoRemoveDockClient(Client: TControl); override;
    function  GetPageFromDockClient(Client: TControl): TSCTabSheet;
    procedure GetSiteInfo(Client: TControl; var InfluenceRect: TRect;
      MousePos: TPoint; var CanDock: Boolean); override;

    function  GetPage(Index: Integer): TSCTabSheet; virtual;
    function  GetPageCount: Integer; virtual;
    procedure SetActivePage(Page: TSCTabSheet); virtual;
    function  GetActivePageIndex: Integer; virtual;
    procedure SetActivePageIndex(Value: Integer); virtual;
    procedure SetUseTabColors(Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Change; override;

    function  FindNextPage(CurPage: TSCTabSheet; GoForward,
      CheckTabVisible: Boolean): TSCTabSheet;
    function  PageForTab(ATabIndex: Integer): TSCTabSheet;
    procedure SelectNextPage(GoForward: Boolean);

    procedure HideAllTabs; override;
    procedure ShowAllTabs; override;

    procedure MakeControlVisible(AControl: TControl);

    property PageCount: Integer read GetPageCount;
    property Pages[Index: Integer]: TSCTabSheet read GetPage;

    property ActivePageIndex: Integer read GetActivePageIndex write SetActivePageIndex;
    property ActivePage: TSCTabSheet read FActivePage write SetActivePage;
    property Color default clBtnFace;
  end;

  TSCPageControl = class(TSCCustomPageControl)
  published
    property ActivePage;
    property Align;
    property Alignment;
    property Anchors;
    property AutoTabSize;
    property BackgroundColor;
    property Color;
    property UseTabColors;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EllipsisType;
    property Enabled;
    property Font;
    property FrameColor;
    property HelpContext;
    property Hint;
    property Hottrack;
    property HottrackStyle;
    property Images;
    property ImageSpacing;
    property Indent;
    property MaximumWidth;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowCardFrame;
    property ShowCloseButton;
    property ShowFocusRect;
    property ShowHint;
    property Spacing;
    property Style;
    property TabColors;
    property TabGradient;
    property TabOrientation;
    property TabPosition;
    property TabStop;
    property Visible;
    property OnClick;
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
    property OnStartDock;
    property OnStartDrag;
    property OnTabClick;
    property OnTabClose;
    property OnTabChange;
    property OnTabChanging;
    property OnUnDock;
  end;

implementation

var
  Registered: Boolean = False;

const
  SC_TabsMinHeight = 21;

  ButtonStyles = [sctbButton, sctbEclipse, sctbFlatButton, sctbOfficeXP];
  GradientStyles = [sctbDotNetFlat, sctbEclipse, sctbOffice12, sctbOfficeXP,
    sctbNew, sctbNewX, sctbXP, sctbWhidbey];

type
  TSCFakeControl = class(TControl);

{ TSCTabItem }

procedure TSCTabItem.Assign(Source: TPersistent);
begin
  if Source is TSCTabItem then
  begin
    with TSCTabItem(Source) do
    begin
      Self.FCaption := Caption;
      Self.FColor := Color;
      Self.FEnabled := Enabled;
      Self.FFontColor := FontColor;
      Self.FVisible := Visible;
      Self.FHint := Hint;
      Self.FDisabledImage := DisabledImage;
      Self.FHotImage := HotImage;
      Self.FImageIndex := ImageIndex;
      Self.FTag := Tag;
    end;

    Changed(True);
  end else
  if Source is TSCTabData then
  begin
    with TSCTabData(Source) do
    begin
      Self.FCaption := Caption;
      Self.FColor := Color;
      Self.FEnabled := Enabled;
      Self.FFontColor := FontColor;
      Self.FVisible := Visible;
      Self.FHint := Hint;
      Self.FDisabledImage := DisabledImage;
      Self.FHotImage := HotImage;
      Self.FImageIndex := ImageIndex;
      Self.FTag := Tag;
    end;

    Changed(True);
  end else
    inherited Assign(Source);
end;

procedure TSCTabItem.AssignTo(Dest: TPersistent);
begin
  if Dest is TSCTabData then
  begin
    with TSCTabData(Dest) do
    begin
      FCaption := Self.Caption;
      FColor := Self.Color;
      FEnabled := Self.Enabled;
      FFontColor := Self.FontColor;
      FVisible := Self.Visible;
      FHint := Self.Hint;
      FDisabledImage := Self.DisabledImage;
      FHotImage := Self.HotImage;
      FImageIndex := Self.ImageIndex;
      FTag := Self.Tag;
    end;
  end else
    inherited AssignTo(Dest);
end;

constructor TSCTabItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FTabRect := Rect(0, 0, 0, 0);
  FColor := clBtnFace;
  FEnabled := True;
  FFontColor := clNone;
  FVisible := True;
  FShowing := True;
  FDisabledImage := -1;
  FHotImage := -1;
  FImageIndex := -1;
end;

function TSCTabItem.GetDisplayName: string;
begin
  Result := FCaption;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TSCTabItem.GetShowing: Boolean;
begin
  Result := FShowing and FVisible;
end;

procedure TSCTabItem.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCTabItem.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCTabItem.SetDisabledImage(Value: TImageIndex);
begin
  if FDisabledImage <> Value then
  begin
    FDisabledImage := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCTabItem.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCTabItem.SetFontColor(Value: TColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCTabItem.SetHint(const Value: String);
begin
  if FHint <> Value then
  begin
    FHint := Value;
    if FVisible and FEnabled then
      Changed(True);
  end;
end;

procedure TSCTabItem.SetHotImage(Value: TImageIndex);
begin
  if FHotImage <> Value then
  begin
    FHotImage := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCTabItem.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if FVisible then
      Changed(True);
  end;
end;

procedure TSCTabItem.SetTabRect(Value: TRect);
begin
  FTabRect := Value;
end;

procedure TSCTabItem.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(True);
  end;
end;

{ TSCTabItems }

function TSCTabItems.Add: TSCTabItem;
begin
  Result := TSCTabItem(inherited Add);
  if (FOwner <> nil) and (FOwner.FTabIndex = -1) then
    FOwner.TabIndex := 0;
end;

procedure TSCTabItems.Clear;
begin
  inherited Clear;
  if FOwner <> nil then
    FOwner.TabIndex := -1;
end;

constructor TSCTabItems.Create(AOwner: TSCCustomTabControl);
begin
  FOwner := AOwner;
  inherited Create(TSCTabItem);
end;

procedure TSCTabItems.Delete(Index: Integer);
var
  TabIndex: Integer;
begin
  TabIndex := 0;
  if FOwner <> nil then TabIndex := FOwner.FTabIndex;

  Items[Index].Collection := nil;
  if (FOwner <> nil) and (Index <= TabIndex) then
  begin
    FOwner.TabIndex := TabIndex - 1;
    FOwner.SetFirstTab(TabIndex);
  end;
end;

function TSCTabItems.GetItem(Index: Integer): TSCTabItem;
begin
  Result := TSCTabItem(inherited GetItem(Index));
end;

function TSCTabItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCTabItems.Move(CurIndex, NewIndex: Integer);
begin
  Items[CurIndex].Index := NewIndex;
end;

procedure TSCTabItems.SetItem(Index: Integer; Value: TSCTabItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCTabItems.Update(Item: TCollectionItem);
begin
  if FOwner <> nil then
  begin
    FOwner.UpdateTabs(False);
    FOwner.UpdateTabs(True);
  end;
end;

{ TSCDataList }

function TSCDataList.Add: TSCTabData;
begin
  Result := TSCTabData.Create;
  FList.Add(Result);
end;

procedure TSCDataList.Clear;
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

function TSCDataList.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TSCDataList.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

procedure TSCDataList.Delete(Index: Integer);
var
  Obj: TObject;
begin
  Obj := TObject(FList[Index]);
  FList.Delete(Index);
  
  Obj.Free;
end;

destructor TSCDataList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TSCDataList.Get(Index: Integer): TSCTabData;
begin
  Result := TSCTabData(FList[Index]);
end;

{ TSCTabData }

procedure TSCTabData.Assign(Source: TPersistent);
begin
  if Source is TSCTabData then
  begin
    with TSCTabData(Source) do
    begin
      Self.FCaption := Caption;
      Self.FColor := Color;
      Self.FEnabled := Enabled;
      Self.FFontColor := FontColor;
      Self.FVisible := Visible;
      Self.FHint := Hint;
      Self.FDisabledImage := DisabledImage;
      Self.FHotImage := HotImage;
      Self.FImageIndex := ImageIndex;
      Self.FTag := Tag;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCTabData.Create;
begin
  inherited Create;
  FIndex := -1;
  FPoints := nil;
  FTabItem := nil;
  FTabRect := Rect(0, 0, 0, 0);
  FRegion := 0;
  FColor := clBtnFace;
  FEnabled := True;
  FFontColor := clWindowText;
  FVisible := True;
  FDisabledImage := -1;
  FHotImage := -1;
  FImageIndex := -1;
end;

destructor TSCTabData.Destroy;
begin
  SetRegion(0);
  SetLength(FPoints, 0);
  inherited Destroy;
end;

function TSCTabData.GetPoints: TSCTabPoints;
var
  I: Integer;
begin
  SetLength(Result, Length(FPoints));
  for I := 0 to Length(FPoints)-1 do
    Result[I] := FPoints[I];
end;

procedure TSCTabData.SetPoints(Value: TSCTabPoints);
var
  I: Integer;
begin
  SetLength(FPoints, Length(Value));
  for I := Low(Value) to High(Value) do
    FPoints[I] := Value[I];
end;

procedure TSCTabData.SetRegion(Value: HRGN);
begin
  if FRegion <> 0 then
  begin
    DeleteObject(FRegion);
    FRegion := 0;
  end;

  FRegion := Value;
end;

procedure TSCTabData.SetTabRect(Value: TRect);
begin
  FTabRect := Value;
end;

{ TSCTabColors }

procedure TSCTabColors.Assign(Source: TPersistent);
begin
  if Source is TSCTabColors then
  begin
    with TSCTabColors(Source) do
    begin
      Self.FHighlightBar := HighlightBar;
      Self.FHottrackBar := HottrackBar;
      Self.FHottrackText := HottrackText;
      Self.FUnselected := Unselected;
      Self.FUnselectedText := UnselectedText;
    end;

    DoChange;
  end else
    inherited Assign(Source);
end;

constructor TSCTabColors.Create(AOwner: TSCBaseTabControl);
begin
  inherited Create;
  FOwner := AOwner;
  FHighlightBar := clHighlight;
  FHottrackBar := SC_HottrackColor;
  FHottrackText := clBlue;
  FUnselected := clNone;
  FUnselectedText := clNone;
end;

procedure TSCTabColors.DoChange;
begin
  if FOwner <> nil then FOwner.ColorsChanged;
end;

function TSCTabColors.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCTabColors.SetHighlightBar(Value: TColor);
begin
  if FHighlightBar <> Value then
  begin
    FHighlightBar := Value;
    DoChange;
  end;
end;

procedure TSCTabColors.SetHottrackBar(Value: TColor);
begin
  if FHottrackBar <> Value then
  begin
    FHottrackBar := Value;
    DoChange;
  end;
end;

procedure TSCTabColors.SetHottrackText(Value: TColor);
begin
  if FHottrackText <> Value then
  begin
    FHottrackText := Value;
    DoChange;
  end;
end;

procedure TSCTabColors.SetUnselected(Value: TColor);
begin
  if FUnselected <> Value then
  begin
    FUnselected := Value;
    DoChange;
  end;
end;

procedure TSCTabColors.SetUnselectedText(Value: TColor);
begin
  if FUnselectedText <> Value then
  begin
    FUnselectedText := Value;
    DoChange;
  end;
end;

{ TSCBaseTabControl }

procedure TSCBaseTabControl.AdjustClientRect(var ARect: TRect);
var
  B, H: Integer;
begin
  inherited AdjustClientRect(ARect);

  if FVisibleTabCount > 0 then
  begin
    H := FTabSize;
    B := GetBorderIndent;

    InflateRect(ARect, -B, -B);

    if H > 0 then
      case FTabPosition of
        sctpLeft:
        begin
          Inc(ARect.Left, H);
          if ARect.Left > ARect.Right then
            ARect.Left := ARect.Right;
        end;
        sctpRight:
        begin
          Dec(ARect.Right, H);
          if ARect.Right < ARect.Left then
            ARect.Right := ARect.Left;
        end;
        sctpTop:
        begin
          Inc(ARect.Top, H);
          if ARect.Top > ARect.Bottom then
            ARect.Top := ARect.Bottom;
        end;
        sctpBottom:
        begin
          Dec(ARect.Bottom, H);
          if ARect.Bottom < ARect.Top then
            ARect.Bottom := ARect.Top;
        end;
      end;
  end;
end;

function TSCBaseTabControl.CheckVisible(Index: Integer): Integer;
var
  I: Integer;
begin
  if Index < -1 then Index := -1
  else if Index > FDataList.Count-1 then
    Index := FDataList.Count-1;

  Result := Index;  
  if FDataList.Count > 0 then
  begin
    if Index = -1 then Index := 0;

    for I := Index to FDataList.Count-1 do
      if FDataList[I].Visible then
      begin
        Result := I;
        Exit;
      end;

    for I := Index-1 downto 0 do
      if FDataList[I].Visible then
      begin
        Result := I;
        Exit;
      end;
  end;
end;

procedure TSCBaseTabControl.CMColorChanged(var Message: TMessage);
begin
  inherited;
  UpdateBuffer;
end;

procedure TSCBaseTabControl.CMDesignHitTest(var Message: TCMDesignHitTest);
var
  P: TPoint;
  Shift: TShiftState;
  HotInfo: TSCTabHitInfo;
begin
  InitializeHitTest(@FHitInfo);
  Shift := KeysToShiftState(Message.Keys);
  
  if ssLeft in Shift then
  begin
    P := SmallPointToPoint(Message.Pos);

    HotInfo := HitTest(P);

    if (HotInfo.HitPos in [scphLeftScroll, scphRightScroll]) or
      ((HotInfo.HitPos = scphTab) and (HotInfo.Tab > -1) and
      (HotInfo.Tab <> GetActiveIndex)) then
    begin
      FHitInfo := HotInfo;

      Message.Result := 1;
      FDesignChange := True;
    end;
  end else
  begin
    if FDesignChange then Message.Result := 1;
    FDesignChange := False;
  end;
end;

procedure TSCBaseTabControl.CMDialogChar(var Message: TCMDialogChar);
begin

end;

procedure TSCBaseTabControl.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateFontSize;

  UpdateTabs(False);
  UpdateTabs(True);
end;

procedure TSCBaseTabControl.ColorsChanged;
begin
  if FVisibleTabCount > 0 then
    UpdateTabs(False);
    
  DoColorsChanged;
end;

constructor TSCBaseTabControl.Create(AOwner: TComponent);
begin
  FDataList := TSCDataList.Create;
  FTabColors := TSCTabColors.Create(Self);
  FControlLoaded := False;

  inherited Create(AOwner);
  FPaintBuffer := TBitmap.Create;

  ClickFocus := False;
  UpdateFontSize;
  SetBounds(Left, Top, 280, 190);
  Spacing := 0;

  InitializeHitTest(@FHitInfo);
  InitializeHitTest(@FHottrackInfo);

  FScrollTimer := -1;

  FTabSize := -1;
  FFirstTab := 0;

  FTabsRect := Rect(0, 0, 0, 0);
  FScrollersVisible := False;
  FVisibleTabCount := 0;

  FImageSpacing := 2;
  FAlignment := taLeftJustify;
  FAutoTabSize := True;
  FBackgroundColor := clNone;
  FButtonColor := clBtnFace;
  FButtonIconColor := clWindowText;
  FDefaultTabSize := 72;
  FEllipsisType := scteEndEllipsis;
  FFrameColor := clBtnShadow;
  FTabGradient := sctgDefault;
  FMaximumWidth := -1;
  FHottrack := True;
  FHottrackStyle := schsTabAndText;
  FTabOrientation := sctoDefault;
  FTabPosition := sctpTop;
  FShowCardFrame := True;
  FShowFocusRect := True;
  FStyle := sctbWin2K;
  FTabIndex := -1;
  FTabIndexDefault := -1;
end;

procedure TSCBaseTabControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_CLIPCHILDREN or WS_CLIPSIBLINGS;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW) or
      CS_DBLCLKS;
  end;
end;

destructor TSCBaseTabControl.Destroy;
begin
  FreeAndNil(FDataList);
  FreeAndNil(FTabColors);
  FreeAndNil(FPaintBuffer);
  inherited Destroy;
end;

procedure TSCBaseTabControl.DoColorsChanged;
begin
  //
end;

procedure TSCBaseTabControl.DoTabIndexChanged;
begin
  //
end;

procedure TSCBaseTabControl.DrawButtonTab(C: TCanvas; Tab: TSCTabData);
var
  R: TRect;
  Cl: TColor;
  Index: Integer;
begin
  R := Tab.TabRect;
  if (FTabPosition = sctpBottom) and (FTabOrientation = sctoVertical) then
    OffsetRect(R, 0, -1);

  if not IsRectEmpty(R) then
  begin
    Index := GetActiveIndex;
    Cl := GetTabColor(Tab);

    if Index = Tab.Index then
    begin
      scFrame3D(C, R, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0);
      scFrame3D(C, R, Get3DDkShadowOf(Cl), Cl, 1, 0);
    end else
    if FStyle = sctbButton then
    begin
      scFrame3D(C, R, GetBtnHighlightOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
      scFrame3D(C, R, Cl, GetBtnShadowOf(Cl), 1, 0);
    end else
    if (FStyle = sctbFlatButton) and ((Index = -1) or
      (GetVisibleIndexOf(Tab.Index) <> GetVisibleIndexOf(Index)-1)) then
    begin
      R.Left := R.Right - 2;
      scFrame3D(C, R, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0);
    end;
  end;
end;

procedure TSCBaseTabControl.DrawFlatButtonTab(C: TCanvas; Tab: TSCTabData);
var
  R: TRect;
  Cl: TColor;
  Index: Integer;
begin
  R := Tab.TabRect;
  if (FTabPosition = sctpBottom) and (FTabOrientation = sctoVertical) then
    OffsetRect(R, 0, -1);

  if not IsRectEmpty(R) then
  begin
    Index := GetActiveIndex;
    Cl := GetTabColor(Tab);

    if Index = Tab.Index then
    begin
      scFrame3D(C, R, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0);
      scFrame3D(C, R, Get3DDkShadowOf(Cl), Cl, 1, 0);
    end else
    if FStyle = sctbButton then
    begin
      scFrame3D(C, R, GetBtnHighlightOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
      scFrame3D(C, R, Cl, GetBtnShadowOf(Cl), 1, 0);
    end else
    if (FStyle = sctbFlatButton) and ((Index = -1) or
      (GetVisibleIndexOf(Tab.Index) <> GetVisibleIndexOf(Index)-1)) then
    begin
      R.Left := R.Right - 2;
      scFrame3D(C, R, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0);
    end;
  end;
end;

procedure TSCBaseTabControl.DrawHottrack(Tab: TSCTabData; R: TRect);
var
  R2: TRect;
  C1, C2, C3: TColor;
  IsHot, IsDown: Boolean;
  SR, Mix, I, Index: Integer;
begin
  if (Tab = nil) or IsRectEmpty(R) then
    Exit;

  Index := GetActiveIndex;

  IsHot := False;
  IsDown := False;

  if not IsDesigning then
  begin
    IsHot := FHottrackInfo.Tab = Tab.Index;
    IsDown := FHitInfo.Tab = Tab.Index;
  end;

  if (FStyle = sctbOffice12) and IsHot and not IsDown and
    (Index = Tab.Index) and (FTabColors.HottrackBar <> clNone) then
  begin
    R2 := R;
    InflateRect(R2, 3, 3);

    case FTabPosition of
      sctpTop:
        Dec(R2.Bottom, 3);
      sctpBottom:
        Inc(R2.Top, 3);
      sctpLeft:
        Dec(R2.Right, 3);
      sctpRight:
        Inc(R2.Left, 3);
    end;

    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;
    end;

    C1 := FBackgroundColor;
    if C1 = clNone then C1 := clBtnFace;

    C2 := FTabColors.HottrackBar;

    SR := IntersectClipRect(Canvas.Handle, R2.Left, R2.Top, R2.Right, R2.Bottom);
    try
      if SR <> NULLREGION then
      begin
        Inc(R.Right);
        
        Mix := 60;

        for I := 0 to 3 do
        begin
          InflateRect(R, 1, 1);

          C3 := MixColors(C1, C2, Mix);
          Dec(Mix, 15);

          scFrame3D(Canvas, R, C3, C3, 1, 2*(I + 3));
          InflateRect(R, 1, 1);
        end;
      end;
    finally
      SelectClipRgn(Canvas.Handle, 0);
    end;
  end;
end;

procedure TSCBaseTabControl.DrawCard(R: TRect);
begin
  case FStyle of
    sctbWin2K:
      DrawWin2KCard(R);
    sctbDotNet:
      DrawDotNetCard(R);
    sctbDotNetFlat:
      DrawDotNetFlatCard(R);
    sctbEclipse:
      DrawEclipseCard(R);
    sctbNew:
      DrawNewCard(R);
    sctbNewX:
      DrawNewXCard(R);
    sctbOffice12:
      DrawOffice12Card(R);
    sctbXP:
      DrawXpCard(R);
    sctbWhidbey:
      DrawWhidbeyCard(R);
  end;
end;

procedure TSCBaseTabControl.DrawCloseButton;
var
  CR, R, R2: TRect;
  IsHot, IsDown: Boolean;
  Cl, CrossCl, DarkCl, LightCl: TColor;
begin
  if FShowCloseButton and (FVisibleTabCount > 0) then
  begin
    R := GetCloseButtonRect;

    if not IsRectEmpty(R) then
    begin
      Cl := FButtonColor;
      if Cl = clNone then
      begin
        Cl := FBackgroundColor;
        if Cl = clNone then Cl := clBtnFace;
      end;

      IsHot := False;
      IsDown := False;

      if not IsDesigning then
      begin
        IsDown := FHitInfo.HitPos = scphCloseButton;
        IsHot := (FHitInfo.HitPos in [scphNowhere, scphCloseButton]) and
          (FHottrackInfo.HitPos = scphCloseButton);
      end;

      if not (IsDown or IsHot) and (FStyle in
        [sctbDotNetFlat, sctbEclipse, sctbWhidbey]) then
      begin
        Cl := FBackgroundColor;
        if Cl = clNone then Cl := clBtnFace;
      end;

      CrossCl := FButtonIconColor;
      if CrossCl = clNone then
        CrossCl := clWindowText;

      if FStyle = sctbOfficeXP then
      begin
        CrossCl := clWindowText;

        if IsHot and IsDown then
        begin
          Cl := GetOfficeXPDownedSelColor;
          CrossCl := clBtnHighlight;
        end else
        if IsHot or IsDown then
          Cl := GetOfficeXPSelColor
        else
          Cl := GetOfficeXPBtnColor;
      end;

      R2 := R;
      if FStyle = sctbOffice12 then
        InflateRect(R2, -1, -1);

      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R2);
      end;

      if FStyle = sctbOffice12 then
      begin
        if (IsHot or IsDown) and (FTabColors.HottrackBar <> clNone) then
          Cl := FTabColors.HottrackBar;

        if not (IsHot or IsDown) then
          Cl := BlendedColor(Cl, 12, 12, 12, False);

        LightCl := BlendedColor(Cl, 24, 24, 24, True);
        if IsHot and not IsDown then
          LightCl := GetBtnHighlightOf(Cl);

        if IsDown then
        begin
          Cl := BlendedColor(Cl, 48, 48, 48, False);
          LightCl := BlendedColor(Cl, 90, 90, 90, True);
        end;

        R2 := R;
        InflateRect(R2, -2, -2);
        
        scDrawGradient(Canvas, R2, scgTopToBottom, LightCl, Cl);

        LightCl := GetBtnHighlightOf(Cl);

        R2.Top := R2.Top + ((R2.Bottom - R2.Top) div 2);
        scDrawGradient(Canvas, R2, scgTopToBottom, Cl, LightCl);

        R2 := R;
        InflateRect(R2, -1, -1);

        LightCl := BlendedColor(Cl, 90, 90, 90, True);
        scFrame3D(Canvas, R2, LightCl, LightCl, 1, 2);
      end;

      if (R.Bottom - R.Top >= 7) and (R.Right - R.Left >= 7) then
      begin
        CR := R;

        CR.Left := R.Left + (R.Right - R.Left - 7) div 2;
        CR.Right := CR.Left + 7;

        CR.Top := R.Top + (R.Bottom - R.Top - 7) div 2;
        CR.Bottom := CR.Top + 7;

        if IsDown and IsHot and
          not (FStyle in [sctbOffice12, sctbOfficeXP]) then
          OffsetRect(CR, 1, 1);

        with Canvas do
        begin
          Pen.Width := 1;
          Pen.Mode  := pmCopy;
          Pen.Style := psSolid;

          Pen.Color := CrossCl;

          MoveTo(CR.Left, CR.Top);
          LineTo(CR.Right + 1, CR.Bottom + 1);

          MoveTo(CR.Right, CR.Top);
          LineTo(CR.Left - 1, CR.Bottom + 1);

          MoveTo(CR.Left + 1, CR.Top);
          LineTo(CR.Right + 1, CR.Bottom);

          MoveTo(CR.Right - 1, CR.Top);
          LineTo(CR.Left - 1, CR.Bottom);

          MoveTo(CR.Left, CR.Top + 1);
          LineTo(CR.Right, CR.Bottom + 1);

          MoveTo(CR.Right, CR.Top + 1);
          LineTo(CR.Left, CR.Bottom + 1);
        end;
      end;

      DarkCl := GetBtnShadowOf(Cl);
      LightCl := GetBtnHighlightOf(Cl);

      case FStyle of
        sctbDotNet:
        begin
          if IsHot and IsDown then
            scFrame3D(Canvas, R, DarkCl, LightCl, 1, 0)
          else
            scFrame3D(Canvas, R, LightCl, DarkCl, 1, 0);
        end;
        sctbDotNetFlat:
        begin
          if IsHot or IsDown then
            scFrame3D(Canvas, R, DarkCl, DarkCl, 1, 0);
        end;
        sctbEclipse:
        begin
          if IsHot and IsDown then
            scFrame3D(Canvas, R, DarkCl, LightCl, 1, 0)
          else
          if IsHot or IsDown then
            scFrame3D(Canvas, R, LightCl, DarkCl, 1, 0);
        end;
        sctbWin2K, sctbButton,
        sctbFlatButton:
        begin
          if IsHot and IsDown then
          begin
            scFrame3D(Canvas, R, DarkCl, LightCl, 1, 0);
            scFrame3D(Canvas, R, Get3DDkShadowOf(Cl), Cl, 1, 0);
          end else
          begin
            scFrame3D(Canvas, R, LightCl, Get3DDkShadowOf(Cl), 1, 0);
            scFrame3D(Canvas, R, Cl, DarkCl, 1, 0);
          end;
        end;
        sctbOffice12:
        begin
          DarkCl := BlendedColor(Cl, 32, 32, 32, False);
          scFrame3D(Canvas, R, DarkCl, DarkCl, 1, 2);
        end;
        sctbOfficeXP:
        begin
          if IsHot or IsDown then
            scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
        end;
        sctbWhidbey:
        begin
          if IsHot or IsDown then
            scFrame3D(Canvas, R, DarkCl, DarkCl, 1, 0);
        end;
        else begin
          scFrame3D(Canvas, R, DarkCl, DarkCl, 1, 0);
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawDotNetCard(R: TRect);
var
  Cl: TColor;
  Index: Integer;
  TempR, TR: TRect;
begin
  if not IsRectEmpty(R) then
  begin
    case FTabPosition of
      sctpBottom:
        Inc(R.Bottom);
      sctpRight:
        Inc(R.Right);
    end;

    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
    end;

    Index := GetActiveIndex;

    Cl := Self.Color;
    if (Index > -1) and (Index < FDataList.Count) and FUseTabColors then
      Cl := FDataList[Index].Color;

    if Cl = clNone then Cl := clBtnFace;

    TempR := R;
    scFrame3D(Canvas, TempR, GetBtnHighlightOf(Cl),
      GetBtnShadowOf(Cl), 1, 0);

    if (Index > -1) and (Index < FDataList.Count) and
      FDataList[Index].Visible and FDataList[Index].Showing then
    begin
      Dec(R.Bottom);
      Dec(R.Right);

      Canvas.Pen.Color := Cl;
      TR := FDataList[Index].TabRect;

      case FTabPosition of
        sctpTop:
        begin
          Inc(TR.Left);

          Canvas.MoveTo(TR.Left,  R.Top);
          Canvas.LineTo(TR.Right - 1, R.Top);
        end;
        sctpBottom:
        begin
          Inc(TR.Left);

          Canvas.MoveTo(TR.Left,  R.Bottom);
          Canvas.LineTo(TR.Right - 1, R.Bottom);
        end;
        sctpLeft:
        begin
          Inc(TR.Top);

          Canvas.MoveTo(R.Left, TR.Top);
          Canvas.LineTo(R.Left, TR.Bottom - 1);
        end;
        sctpRight:
        begin
          Inc(TR.Top);
          Dec(TR.Left);

          Canvas.MoveTo(R.Right, TR.Top);
          Canvas.LineTo(R.Right, TR.Bottom - 1);
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawDotNetFlatCard(R: TRect);
var
  TR: TRect;
  Cl: TColor;
  Index: Integer;
  Pts: array[0..4] of TPoint;
begin
  if FShowCardFrame then
  begin
    case FTabPosition of
      sctpBottom:
        Inc(R.Bottom);
      sctpRight:
        Inc(R.Right);
    end;

    Pts[0].x := R.Left;
    Pts[0].y := R.Top;
    Pts[1].x := R.Right-1;
    Pts[1].y := R.Top;
    Pts[2].x := R.Right-1;
    Pts[2].y := R.Bottom-1;
    Pts[3].x := R.Left;
    Pts[3].y := R.Bottom-1;
    Pts[4].x := R.Left;
    Pts[4].y := R.Top;

    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Color := GetFrameColor;

      Polyline(Pts);
    end;

    Index := GetActiveIndex;

    if (Index > -1) and (Index < FDataList.Count) and
      FDataList[Index].Visible and FDataList[Index].Showing then
    begin
      Dec(R.Bottom);
      Dec(R.Right);

      Cl := Self.Color;
      if (Index > -1) and FUseTabColors then
        Cl := FDataList[Index].Color;

      if Cl = clNone then Cl := clBtnFace;

      Canvas.Pen.Color := Cl;
      TR := FDataList[Index].TabRect;

      case FTabPosition of
        sctpTop:
        begin
          Inc(TR.Left);

          Canvas.MoveTo(TR.Left,  R.Top);
          Canvas.LineTo(TR.Right - 1, R.Top);
        end;
        sctpBottom:
        begin
          Inc(TR.Left);

          Canvas.MoveTo(TR.Left,  R.Bottom);
          Canvas.LineTo(TR.Right - 1, R.Bottom);
        end;
        sctpLeft:
        begin
          Inc(TR.Top);

          Canvas.MoveTo(R.Left, TR.Top);
          Canvas.LineTo(R.Left, TR.Bottom - 1);
        end;
        sctpRight:
        begin
          Inc(TR.Top);
          Dec(TR.Left);

          Canvas.MoveTo(R.Right, TR.Top);
          Canvas.LineTo(R.Right, TR.Bottom - 1);
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawDotNetTab(C: TCanvas; Tab: TSCTabData);
var
  R, TempR: TRect;
  Cl, LineCl: TColor;
  ActIndex, VisIndex: Integer;
begin
  R := Tab.TabRect;
  if (FTabPosition = sctpBottom) and (FTabOrientation = sctoVertical) then
    OffsetRect(R, 0, -1);

  TempR := R;

  if not IsRectEmpty(R) then
  begin
    Cl := GetTabColor(Tab);

    ActIndex := GetActiveIndex;

    if Tab.Index = ActIndex then
      scFrame3D(C, TempR, GetBtnHighlightOf(Cl), GetBtnShadowOf(Cl), 1, 0)
    else begin
      VisIndex := GetVisibleIndexOf(ActIndex);

      if GetVisibleIndexOf(Tab.Index) = VisIndex-1 then
        Exit;

      if IsColorLight(Cl) then
        LineCl := BlendedColor(Cl, 80, 80, 80, False)
      else
        LineCl := BlendedColor(Cl, 80, 80, 80, True);

      with C do
      begin
        Pen.Width := 1;
        Pen.Mode  := pmCopy;
        Pen.Style := psSolid;

        Pen.Color := LineCl;

        if FTabPosition in [sctpTop, sctpBottom] then
        begin
          InflateRect(R, -1, -4);

          MoveTo(R.Right, R.Top);
          LineTo(R.Right, R.Bottom);
        end else
        begin
          InflateRect(R, -4, -1);

          MoveTo(R.Left, R.Bottom);
          LineTo(R.Right, R.Bottom);
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawDotNetFlatTab(C: TCanvas; Tab: TSCTabData);
var
  R: TRect;
  Cl: TColor;
  Pts: TSCTabPoints;
begin
  if Tab.Visible and Tab.Showing then
  begin
    if Tab.Index = GetActiveIndex then
    begin
      SetLength(Pts, 0);
      Pts := Tab.Points;

      if (Pts <> nil) and (Length(Pts) > 2) then
      begin
        Cl := GetFrameColor;

        with C do
        begin
          Pen.Width := 1;
          Pen.Mode  := pmCopy;
          Pen.Style := psSolid;
          Pen.Color := Cl;

          Polyline(Pts);
        end;
      end;
    end else
    begin
      R := Tab.TabRect;
      if (FTabPosition = sctpBottom) and (FTabOrientation = sctoVertical) then
        OffsetRect(R, 0, -1);

      with C do
      begin
        Pen.Width := 1;
        Pen.Mode  := pmCopy;
        Pen.Style := psSolid;
        Pen.Color := GetFrameColor;

        if FTabPosition in [sctpTop, sctpBottom] then
        begin
          InflateRect(R, -1, -4);

          MoveTo(R.Right, R.Top);
          LineTo(R.Right, R.Bottom);
        end else
        begin
          InflateRect(R, -4, -1);

          MoveTo(R.Left, R.Bottom);
          LineTo(R.Right, R.Bottom);
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawOffice12Card(R: TRect);
var
  TR, R2: TRect;
  Index: Integer;
  Cl, FCl, BCl, PCl: TColor;
  Pts: array[0..4] of TPoint;
begin
  if FShowCardFrame then
  begin
    case FTabPosition of
      sctpBottom:
        Inc(R.Bottom);
      sctpRight:
        Inc(R.Right);
    end;

    Pts[0].x := R.Left;
    Pts[0].y := R.Top;
    Pts[1].x := R.Right-1;
    Pts[1].y := R.Top;
    Pts[2].x := R.Right-1;
    Pts[2].y := R.Bottom-1;
    Pts[3].x := R.Left;
    Pts[3].y := R.Bottom-1;
    Pts[4].x := R.Left;
    Pts[4].y := R.Top;

    FCl := GetFrameColor;

    PCl := clBtnFace;
    if Self.Parent <> nil then
    begin
      PCl := TSCFakeControl(Self.Parent).Color;
      if PCl = clNone then
        PCl := clBtnFace;
    end;
    
    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Color := FCl;

      Polyline(Pts);
    end;

    with Canvas do
    begin
      Cl := BlendedColor(FCl, 16, 16, 16, True);
      Pen.Color := Cl;

      MoveTo(R.Left, R.Top + 3);
      LineTo(R.Left + 4, R.Top - 1);

      MoveTo(R.Right - 4, R.Top);
      LineTo(R.Right, R.Top + 4);

      MoveTo(R.Right - 1, R.Bottom - 4);
      LineTo(R.Right - 5, R.Bottom);

      MoveTo(R.Left, R.Bottom - 4);
      LineTo(R.Left + 4, R.Bottom);
    end;

    BCl := GetDefaultBackColor;
    if BCl = clNone then BCl := clBtnFace;

    Cl := BlendedColor(FCl, 32, 32, 32, True);
    Cl := MixColors(Cl, BCl, 40);

    R2 := R;
    InflateRect(R2, -1, -1);

    with Canvas do
    begin
      Pen.Color := Cl;

      MoveTo(R2.Left, R2.Top + 2);
      LineTo(R2.Left + 3, R2.Top - 1);

      MoveTo(R2.Right - 3, R2.Top);
      LineTo(R2.Right, R2.Top + 3);

      MoveTo(R2.Right - 1, R2.Bottom - 3);
      LineTo(R2.Right - 4, R2.Bottom);

      MoveTo(R2.Left, R2.Bottom - 3);
      LineTo(R2.Left + 3, R2.Bottom);
    end;

    BCl := FBackgroundColor;
    if BCl = clNone then BCl := clBtnFace;

    with Canvas do
    begin
      Pen.Color := PCl;
      if FTabPosition in [sctpTop, sctpLeft] then
        Pen.Color := BCl;

      MoveTo(R.Left, R.Top + 2);
      LineTo(R.Left + 3, R.Top - 1);

      Pen.Color := PCl;
      if FTabPosition in [sctpTop, sctpRight] then
        Pen.Color := BCl;

      MoveTo(R.Right - 3, R.Top);
      LineTo(R.Right, R.Top + 3);

      Pen.Color := PCl;
      if FTabPosition in [sctpBottom, sctpRight] then
        Pen.Color := BCl;

      MoveTo(R.Right, R.Bottom - 4);
      LineTo(R.Right - 4, R.Bottom);

      Pen.Color := PCl;
      if FTabPosition in [sctpBottom, sctpLeft] then
        Pen.Color := BCl;

      MoveTo(R.Left, R.Bottom - 3);
      LineTo(R.Left + 3, R.Bottom);
    end;

    with Canvas do
    begin
      Pen.Color := PCl;
      if FTabPosition in [sctpTop, sctpLeft] then
        Pen.Color := BCl;

      MoveTo(R.Left, R.Top + 1);
      LineTo(R.Left + 2, R.Top - 1);

      Pen.Color := PCl;
      if FTabPosition in [sctpTop, sctpRight] then
        Pen.Color := BCl;

      MoveTo(R.Right - 2, R.Top);
      LineTo(R.Right, R.Top + 2);

      Pen.Color := PCl;
      if FTabPosition in [sctpBottom, sctpRight] then
        Pen.Color := BCl;

      MoveTo(R.Right, R.Bottom - 3);
      LineTo(R.Right - 3, R.Bottom);

      Pen.Color := PCl;
      if FTabPosition in [sctpBottom, sctpLeft] then
        Pen.Color := BCl;

      MoveTo(R.Left, R.Bottom - 2);
      LineTo(R.Left + 2, R.Bottom);
    end;

    with Canvas do
    begin
      Pen.Color := PCl;
      if FTabPosition in [sctpTop, sctpLeft] then
        Pen.Color := BCl;

      MoveTo(R.Left, R.Top);
      LineTo(R.Left + 1, R.Top - 1);

      Pen.Color := PCl;
      if FTabPosition in [sctpTop, sctpRight] then
        Pen.Color := BCl;

      MoveTo(R.Right - 1, R.Top);
      LineTo(R.Right, R.Top + 1);

      Pen.Color := PCl;
      if FTabPosition in [sctpBottom, sctpRight] then
        Pen.Color := BCl;

      MoveTo(R.Right, R.Bottom - 2);
      LineTo(R.Right - 2, R.Bottom);

      Pen.Color := PCl;
      if FTabPosition in [sctpBottom, sctpLeft] then
        Pen.Color := BCl;

      MoveTo(R.Left, R.Bottom - 1);
      LineTo(R.Left + 1, R.Bottom);
    end;

    Index := GetActiveIndex;

    if (Index > -1) and (Index < FDataList.Count) and
      FDataList[Index].Visible and FDataList[Index].Showing then
    begin
      Dec(R.Bottom);
      Dec(R.Right);

      Cl := Self.Color;
      if (Index > -1) and FUseTabColors then
        Cl := FDataList[Index].Color;

      if Cl = clNone then Cl := clBtnFace;

      TR := FDataList[Index].TabRect;
      InflateRect(TR, 2, 2);

      with Canvas do
      begin
        Pen.Color := Cl;

        case FTabPosition of
          sctpTop:
          begin
            Inc(TR.Left);

            MoveTo(TR.Left,  R.Top);
            LineTo(TR.Right - 1, R.Top);

            Pen.Color := FCl;
            InflateRect(TR, -2, -2);

            MoveTo(TR.Left - 1, TR.Bottom - 3);
            LineTo(TR.Left - 4, TR.Bottom);

            MoveTo(TR.Right - 1, TR.Bottom - 3);
            LineTo(TR.Right + 2, TR.Bottom);
          end;
          sctpBottom:
          begin
            Inc(TR.Left);

            MoveTo(TR.Left,  R.Bottom);
            LineTo(TR.Right - 1, R.Bottom);

            Pen.Color := FCl;
            InflateRect(TR, -2, -2);

            MoveTo(TR.Left - 1, TR.Top + 3);
            LineTo(TR.Left - 4, TR.Top);

            MoveTo(TR.Right - 1, TR.Top + 3);
            LineTo(TR.Right + 2, TR.Top);
          end;
          sctpLeft:
          begin
            Inc(TR.Top);

            MoveTo(R.Left, TR.Top);
            LineTo(R.Left, TR.Bottom - 1);

            Pen.Color := FCl;
            InflateRect(TR, -2, -2);

            MoveTo(TR.Right - 3, TR.Top - 1);
            LineTo(TR.Right,     TR.Top - 4);

            MoveTo(TR.Right - 3, TR.Bottom - 1);
            LineTo(TR.Right,     TR.Bottom + 2);
          end;
          sctpRight:
          begin
            Inc(TR.Top);
            Dec(TR.Left);

            MoveTo(R.Right, TR.Top);
            LineTo(R.Right, TR.Bottom - 1);

            Pen.Color := FCl;
            InflateRect(TR, -2, -2);

            MoveTo(TR.Left + 3, TR.Top - 1);
            LineTo(TR.Left,     TR.Top - 4);

            MoveTo(TR.Left + 3, TR.Bottom - 1);
            LineTo(TR.Left,     TR.Bottom + 2);
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawOffice12Tab(C: TCanvas; Tab: TSCTabData);
var
  R, R2: TRect;
  Cl, C1: TColor;
  Index: Integer;
  Pts: TSCTabPoints;
  IsHot, IsDown: Boolean;
begin
  if Tab.Visible and Tab.Showing then
  begin
    R := Tab.TabRect;
    if (FTabPosition = sctpBottom) and (FTabOrientation = sctoVertical) then
      OffsetRect(R, 0, -1);

    Index := GetActiveIndex;

    IsHot := False;
    IsDown := False;

    if not IsDesigning then
    begin
      IsHot := FHottrackInfo.Tab = Tab.Index;
      IsDown := FHitInfo.Tab = Tab.Index;
    end;

    if (Index = Tab.Index) or IsHot or IsDown then
    begin
      R2 := R;

      InflateRect(R2, -1, -1);
      Dec(R2.Right);
      Dec(R2.Bottom);

      case FTabPosition of
        sctpTop:
          Inc(R2.Bottom, 2);
        sctpBottom:
          Dec(R2.Top, 2);
        sctpLeft:
          Inc(R2.Right, 2);
        sctpRight:
          Dec(R2.Left, 2);
      end;

      Cl := GetTabColor(Tab);

      with Canvas do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := GetBtnHighlightOf(Cl);

        case FTabPosition of
          sctpTop:
          begin
            Dec(R2.Bottom);
            MoveTo(R2.Left, R2.Bottom);

            LineTo(R2.Left, R2.Top);
            LineTo(R2.Right, R2.Top);
            LineTo(R2.Right, R2.Bottom);
          end;
          sctpBottom:
          begin
            Inc(R2.Top, 3);
            MoveTo(R2.Left, R2.Top);

            LineTo(R2.Left, R2.Bottom);
            LineTo(R2.Right, R2.Bottom);
            LineTo(R2.Right, R2.Top - 1);
          end;
          sctpLeft:
          begin
            Dec(R2.Right);
            MoveTo(R2.Right, R2.Top);

            LineTo(R2.Left, R2.Top);
            LineTo(R2.Left, R2.Bottom);
            LineTo(R2.Right, R2.Bottom);
          end;
          sctpRight:
          begin
            Inc(R2.Left, 2);
            MoveTo(R2.Left, R2.Top);

            LineTo(R2.Right, R2.Top);
            LineTo(R2.Right, R2.Bottom);
            LineTo(R2.Left - 1, R2.Bottom);
          end;
        end;
      end;
    end;

    if (Index = Tab.Index) or IsHot or IsDown then
    begin
      SetLength(Pts, 0);
      Pts := Tab.Points;

      if (Pts <> nil) and (Length(Pts) > 2) then
      begin
        if FShowCardFrame and (Index = Tab.Index) then
          case FTabPosition of
            sctpTop:
            begin
              Pts[0].y := Pts[0].y - 3;
              Pts[5].y := Pts[5].y - 2;
            end;
            sctpBottom:
            begin
              Pts[0].y := Pts[0].y + 3;
              Pts[5].y := Pts[5].y + 2;
            end;
            sctpLeft:
            begin
              Pts[0].x := Pts[0].x - 3;
              Pts[5].x := Pts[5].x - 2;
            end;
            sctpRight:
            begin
              Pts[0].x := Pts[0].x + 3;
              Pts[5].x := Pts[5].x + 2;
            end;
          end;

        Cl := GetFrameColor;
        
        if IsHot and not IsDown then
        begin
          Cl := BlendedColor(Cl, 8, 8, 8, True);

          if Index <> Tab.Index then
            Cl := MixColors(Cl, clSilver, 40)
          else begin
            C1 := FTabColors.HottrackBar;

            if C1 <> clNone then
            begin
              C1 := BlendedColor(C1, 32, 32, 32, True);
              Cl := MixColors(Cl, C1, 30);
            end;
          end;
        end;

        with C do
        begin
          Pen.Width := 1;
          Pen.Mode  := pmCopy;
          Pen.Style := psSolid;
          Pen.Color := Cl;

          Polyline(Pts);
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawOfficeXpTab(C: TCanvas; Tab: TSCTabData);
var
  R: TRect;
  Index: Integer;
  IsHot, IsDown: Boolean;
begin
  R := Tab.TabRect;
  if (FTabPosition = sctpBottom) and (FTabOrientation = sctoVertical) then
    OffsetRect(R, 0, -1);

  if not IsRectEmpty(R) then
  begin
    Index := GetActiveIndex;

    IsHot := False;
    IsDown := False;

    if not IsDesigning then
    begin
      IsHot := FHottrackInfo.Tab = Tab.Index;
      IsDown := FHitInfo.Tab = Tab.Index;
    end;

    if (Index = Tab.Index) or IsHot or IsDown then
      scFrame3D(C, R, clHighlight, clHighlight, 1, 0);
  end;
end;

procedure TSCBaseTabControl.DrawScrollers(Left: Boolean);
var
  CR, R, R2: TRect;
  IsHot, IsDown: Boolean;
  Pts: array[0..2] of TPoint;
  Cl, CrossCl, DarkCl, LightCl: TColor;
begin
  if FScrollersVisible then
  begin
    Cl := FButtonColor;
    if Cl = clNone then
    begin
      Cl := FBackgroundColor;
      if Cl = clNone then Cl := clBtnFace;
    end;

    R := GetScrollerRect(Left);

    if not IsRectEmpty(R) then
    begin
      IsHot := False;
      IsDown := False;

      if not IsDesigning then
      begin
        if Left then
        begin
          IsDown := FHitInfo.HitPos = scphLeftScroll;
          IsHot := (FHitInfo.HitPos in [scphNowhere, scphLeftScroll]) and
            (FHottrackInfo.HitPos = scphLeftScroll);
        end else
        begin
          IsDown := FHitInfo.HitPos = scphRightScroll;
          IsHot := (FHitInfo.HitPos in [scphNowhere, scphRightScroll]) and
            (FHottrackInfo.HitPos = scphRightScroll);
        end;
      end;

      if not (IsDown or IsHot) and (FStyle in
        [sctbDotNetFlat, sctbEclipse, sctbWhidbey]) then
      begin
        Cl := FBackgroundColor;
        if Cl = clNone then Cl := clBtnFace;
      end;

      CrossCl := FButtonIconColor;
      if CrossCl = clNone then
        CrossCl := clWindowText;

      if FStyle = sctbOfficeXP then
      begin
        CrossCl := clWindowText;

        if IsHot and IsDown then
        begin
          Cl := GetOfficeXPDownedSelColor;
          CrossCl := clBtnHighlight;
        end else
        if IsHot or IsDown then
          Cl := GetOfficeXPSelColor
        else
          Cl := GetOfficeXPBtnColor;
      end;

      R2 := R;
      if FStyle = sctbOffice12 then
        InflateRect(R2, -1, -1);

      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R2);
      end;

      if FStyle = sctbOffice12 then
      begin
        if (IsHot or IsDown) and (FTabColors.HottrackBar <> clNone) then
          Cl := FTabColors.HottrackBar;

        if not (IsHot or IsDown) then
          Cl := BlendedColor(Cl, 12, 12, 12, False);

        LightCl := BlendedColor(Cl, 24, 24, 24, True);
        if IsHot and not IsDown then
          LightCl := GetBtnHighlightOf(Cl);

        if IsDown then
        begin
          Cl := BlendedColor(Cl, 48, 48, 48, False);
          LightCl := BlendedColor(Cl, 90, 90, 90, True);
        end;

        R2 := R;
        InflateRect(R2, -2, -2);
        
        scDrawGradient(Canvas, R2, scgTopToBottom, LightCl, Cl);

        LightCl := GetBtnHighlightOf(Cl);

        R2.Top := R2.Top + ((R2.Bottom - R2.Top) div 2);
        scDrawGradient(Canvas, R2, scgTopToBottom, Cl, LightCl);

        R2 := R;
        InflateRect(R2, -1, -1);

        LightCl := BlendedColor(Cl, 90, 90, 90, True);
        scFrame3D(Canvas, R2, LightCl, LightCl, 1, 2);
      end;

      if (R.Bottom - R.Top >= 7) and (R.Right - R.Left >= 7) then
      begin
        if FTabPosition in [sctpTop, sctpBottom] then
        begin
          CR.Left := R.Left + (R.Right - R.Left - 7) div 2;
          CR.Right := CR.Left + 7;

          CR.Top := R.Top + (R.Bottom - R.Top - 6) div 2;
          CR.Bottom := CR.Top + 6;
        end else
        begin
          CR.Left := R.Left + (R.Right - R.Left - 6) div 2;
          CR.Right := CR.Left + 6;

          CR.Top := R.Top + (R.Bottom - R.Top - 7) div 2;
          CR.Bottom := CR.Top + 7;
        end;

        if IsDown and IsHot and
          not (FStyle in [sctbOffice12, sctbOfficeXP]) then
          OffsetRect(CR, 1, 1);

        case FTabPosition of
          sctpTop, sctpBottom:
          begin
            InflateRect(CR, -2, 0);

            if Left then
            begin
              Pts[0].x := CR.Right;
              Pts[0].y := CR.Top;
              Pts[1].x := CR.Left;
              Pts[1].y := CR.Top + 3;
              Pts[2].x := CR.Right;
              Pts[2].y := CR.Bottom;
            end else
            begin
              Pts[0].x := CR.Left;
              Pts[0].y := CR.Top;
              Pts[1].x := CR.Right;
              Pts[1].y := CR.Top + 3;
              Pts[2].x := CR.Left;
              Pts[2].y := CR.Bottom;
            end;
          end;
          sctpLeft, sctpRight:
          begin
            InflateRect(CR, 0, -2);

            if Left then
            begin
              Pts[0].x := CR.Left;
              Pts[0].y := CR.Bottom;
              Pts[1].x := CR.Left + 3;
              Pts[1].y := CR.Top;
              Pts[2].x := CR.Right;
              Pts[2].y := CR.Bottom;
            end else
            begin
              Pts[0].x := CR.Left;
              Pts[0].y := CR.Top;
              Pts[1].x := CR.Left + 3;
              Pts[1].y := CR.Bottom;
              Pts[2].x := CR.Right;
              Pts[2].y := CR.Top;
            end;
          end;
        end;

        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := CrossCl;

          Pen.Width := 1;
          Pen.Mode  := pmCopy;
          Pen.Style := psSolid;
          Pen.Color := CrossCl;

          Polygon(Pts);
        end;
      end;

      DarkCl := GetBtnShadowOf(Cl);
      LightCl := GetBtnHighlightOf(Cl);

      case FStyle of
        sctbDotNet:
        begin
          if IsHot and IsDown then
            scFrame3D(Canvas, R, DarkCl, LightCl, 1, 0)
          else
            scFrame3D(Canvas, R, LightCl, DarkCl, 1, 0);
        end;
        sctbDotNetFlat:
        begin
          if IsHot or IsDown then
            scFrame3D(Canvas, R, DarkCl, DarkCl, 1, 0);
        end;
        sctbEclipse:
        begin
          if IsHot and IsDown then
            scFrame3D(Canvas, R, DarkCl, LightCl, 1, 0)
          else
          if IsHot or IsDown then
            scFrame3D(Canvas, R, LightCl, DarkCl, 1, 0);
        end;
        sctbWin2K, sctbButton,
        sctbFlatButton:
        begin
          if IsHot and IsDown then
          begin
            scFrame3D(Canvas, R, DarkCl, LightCl, 1, 0);
            scFrame3D(Canvas, R, Get3DDkShadowOf(Cl), Cl, 1, 0);
          end else
          begin
            scFrame3D(Canvas, R, LightCl, Get3DDkShadowOf(Cl), 1, 0);
            scFrame3D(Canvas, R, Cl, DarkCl, 1, 0);
          end;
        end;
        sctbOffice12:
        begin
          DarkCl := BlendedColor(Cl, 32, 32, 32, False);
          scFrame3D(Canvas, R, DarkCl, DarkCl, 1, 2);
        end;
        sctbOfficeXP:
        begin
          if IsHot or IsDown then
            scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
        end;
        sctbWhidbey:
        begin
          if IsHot or IsDown then
            scFrame3D(Canvas, R, DarkCl, DarkCl, 1, 0);
        end;
        else begin
          scFrame3D(Canvas, R, DarkCl, DarkCl, 1, 0);
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawShadow(Tab: TSCTabData; R: TRect);
var
  C1: TColor;
  Index: Integer;
begin
  if (Tab = nil) or IsRectEmpty(R) then
    Exit;

  Index := GetActiveIndex;

  if (FStyle = sctbOffice12) and (Index = Tab.Index) then
  begin
    case FTabPosition of
      sctpTop:
        Inc(R.Top, 2);
      sctpBottom:
        Dec(R.Bottom, 2);
      sctpLeft:
        Inc(R.Left, 2);
      sctpRight:
        Dec(R.Right, 2);
    end;

    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;
    end;

    C1 := FBackgroundColor;
    if C1 = clNone then C1 := clBtnFace;

    with Canvas do
    begin
      Pen.Color := MixColors(C1, GetBtnShadowOf(C1), 50);

      case FTabPosition of
        sctpTop:
        begin
          MoveTo(R.Right + 1, R.Top + 1);
          LineTo(R.Right + 1, R.Bottom);

          Pen.Color := MixColors(C1, GetBtnShadowOf(C1), 30);

          MoveTo(R.Right + 2, R.Top + 2);
          LineTo(R.Right + 2, R.Bottom);

          Pen.Color := MixColors(C1, GetBtnShadowOf(C1), 15);

          MoveTo(R.Right + 3, R.Top + 3);
          LineTo(R.Right + 3, R.Bottom);
        end;
        sctpBottom:
        begin
          MoveTo(R.Right + 1, R.Bottom - 1);
          LineTo(R.Right + 1, R.Top);

          Pen.Color := MixColors(C1, GetBtnShadowOf(C1), 30);

          MoveTo(R.Right + 2, R.Bottom - 2);
          LineTo(R.Right + 2, R.Top);

          Pen.Color := MixColors(C1, GetBtnShadowOf(C1), 15);

          MoveTo(R.Right + 3, R.Bottom - 3);
          LineTo(R.Right + 3, R.Top);
        end;
        sctpLeft:
        begin
          MoveTo(R.Left + 1, R.Bottom + 1);
          LineTo(R.Right, R.Bottom + 1);

          Pen.Color := MixColors(C1, GetBtnShadowOf(C1), 30);

          MoveTo(R.Left + 2, R.Bottom + 2);
          LineTo(R.Right, R.Bottom + 2);

          Pen.Color := MixColors(C1, GetBtnShadowOf(C1), 15);

          MoveTo(R.Left + 3, R.Bottom + 3);
          LineTo(R.Right, R.Bottom + 3);
        end;
        sctpRight:
        begin
          MoveTo(R.Right - 1, R.Bottom + 1);
          LineTo(R.Left, R.Bottom + 1);

          Pen.Color := MixColors(C1, GetBtnShadowOf(C1), 30);

          MoveTo(R.Right - 2, R.Bottom + 2);
          LineTo(R.Left, R.Bottom + 2);

          Pen.Color := MixColors(C1, GetBtnShadowOf(C1), 15);

          MoveTo(R.Right - 3, R.Bottom + 3);
          LineTo(R.Left, R.Bottom + 3);
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawImageAndText(Tab: TSCTabData; R: TRect);
var
  Ft: HFont;
  Text: String;
  LF: TLogFont;
  TM: TTextMetric;
  BR, TxtRect: TRect;
  ImgList: TCustomImageList;
  Rotated, ValidImage: Boolean;
  ImgCount, ImageIndex, 
  L, T, W, H, Esc, TxtFlags: Integer;
begin
  if (Tab <> nil) and not IsRectEmpty(R) and
    Tab.Visible and Tab.Showing then
  begin
    BR := R;
    InflateRect(BR, -3, -3);

    if FStyle = sctbWhidbey then
    begin
      if FTabPosition in [sctpTop, sctpBottom] then
      begin
        Inc(BR.Left, R.Bottom - R.Top);
        if TabOrientation <> sctoVertical then
          Dec(BR.Left, 3);
      end else
      begin
        Inc(BR.Top, R.Right - R.Left);
        if TabOrientation <> sctoHorizontal then
          Dec(BR.Top, 2);
      end;
    end else
    if FStyle = sctbNewX then
    begin
      if FTabPosition in [sctpTop, sctpBottom] then
      begin
        if TabOrientation <> sctoVertical then
          Dec(BR.Right, R.Bottom - R.Top);
      end else
      if TabOrientation <> sctoHorizontal then
        Dec(BR.Bottom, R.Right - R.Left);
    end else
    if FStyle = sctbNew then
    begin
      if FTabPosition in [sctpTop, sctpBottom] then
      begin
        if TabOrientation <> sctoVertical then
          Dec(BR.Right, 8);
      end else
      if TabOrientation <> sctoHorizontal then
        Dec(BR.Bottom, 8);
    end;

    if FTabPosition in [sctpTop, sctpBottom] then
    begin
      Inc(BR.Left, 2);

      if (Tab.Index = FTabIndex) and not (FStyle in
        [sctbEclipse, sctbOffice12, sctbOfficeXP, sctbWhidbey]) then
      begin
        Inc(BR.Left);
        if FTabPosition = sctpBottom then
          Inc(BR.Top);
      end;
    end else
      Inc(BR.Top, 2);

    if not IsRectEmpty(BR) then
    begin
      ValidImage := False;
      ImgList := GetImages;

      W := 0;
      H := 0;

      if ImgList <> nil then
      begin
        ImgCount := ImgList.Count;

        if ((Tab.ImageIndex > -1) and (Tab.ImageIndex < ImgCount)) or
          ((Tab.HotImage > -1) and (Tab.HotImage < ImgCount)) or
          ((Tab.DisabledImage > -1) and (Tab.DisabledImage < ImgCount)) then
        begin
          ValidImage := True;

          with ImgList do
          begin
            W := Width;
            H := Height;
          end;

          if W > 0 then Inc(W, 2);
          if H > 0 then Inc(H, 2);
        end;
      end;

      if ValidImage then
      begin
        ImageIndex := GetTabImage(Tab);

        case FTabPosition of
          sctpTop, sctpBottom:
          begin
            if FTabOrientation = sctoVertical then
            begin
              L := BR.Left;

              if FTabPosition = sctpTop then
                T := BR.Bottom - H
              else T := BR.Top;

              if (ImageIndex > -1) and (ImageIndex < ImgList.Count) then
                ImgList.Draw(Canvas, L, T, ImageIndex, Self.Enabled and
                  Tab.Enabled);

              if FTabPosition = sctpTop then
                Dec(BR.Bottom, H + FImageSpacing + 2)
              else
                Inc(BR.Top, H + FImageSpacing + 2)
            end else
            if FAlignment = taLeftJustify then
            begin
              L := BR.Left;
              T := BR.Top + (BR.Bottom - BR.Top - H) div 2;

              if (ImageIndex > -1) and (ImageIndex < ImgList.Count) then
                ImgList.Draw(Canvas, L, T, ImageIndex, Self.Enabled and
                  Tab.Enabled);

              Inc(BR.Left, W + FImageSpacing + 2);
            end else
            if FAlignment = taRightJustify then
            begin
              Dec(BR.Right, 2);

              L := BR.Right - W;
              T := BR.Top + (BR.Bottom - BR.Top - H) div 2;

              if (ImageIndex > -1) and (ImageIndex < ImgList.Count) then
                ImgList.Draw(Canvas, L, T, ImageIndex, Self.Enabled and
                  Tab.Enabled);

              Dec(BR.Right, W + FImageSpacing + 2);
            end;
          end;
          sctpLeft, sctpRight:
          begin
            if FTabOrientation = sctoHorizontal then
            begin
              L := BR.Left;
              T := BR.Top;

              if FAlignment = taRightJustify then
              begin
                Dec(BR.Right, 2);
                L := BR.Right - W;
              end;

              if (FStyle = sctbNew) and (FTabPosition = sctpLeft) then
                T := BR.Bottom - H;

              if (ImageIndex > -1) and (ImageIndex < ImgList.Count) then
                ImgList.Draw(Canvas, L, T, ImageIndex, Self.Enabled and
                  Tab.Enabled);

              if FAlignment = taLeftJustify then
                Inc(BR.Left, W + FImageSpacing + 2)
              else
                Dec(BR.Right, W + FImageSpacing + 2);
            end else
            begin
              T := BR.Top;
              L := BR.Left + (BR.Right - BR.Left - W) div 2;

              if (ImageIndex > -1) and (ImageIndex < ImgList.Count) then
                ImgList.Draw(Canvas, L, T, ImageIndex, Self.Enabled and
                  Tab.Enabled);

              Inc(BR.Top, H + FImageSpacing + 2);
            end;
          end;
        end;
      end;

      if not IsRectEmpty(BR) then
      begin
        Text := Tab.Caption;

        if Length(Text) > 0 then
        begin
          TxtFlags := DT_LEFT or DT_TOP or DT_NOPREFIX or
            DT_SINGLELINE or DT_EXPANDTABS;

          Canvas.Font := Self.Font;

          Rotated := ((FTabPosition in [sctpTop, sctpBottom]) and
            (FTabOrientation = sctoVertical)) or
            ((FTabPosition in [sctpLeft, sctpRight]) and
            (FTabOrientation in [sctoDefault, sctoVertical]));

          TxtFlags := TxtFlags or DT_CALCRECT;

          if Rotated then
          begin
            GetTextMetrics(Handle, TM);
            if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
              Canvas.Font.Name := 'Arial';
          end;

          TxtRect := BR;
          DrawText(Canvas.Handle, PChar(Text), Length(Text),
            TxtRect, TxtFlags);

          OffsetRect(TxtRect, -TxtRect.Left, -TxtRect.Top);

          with Canvas do
          begin
            Font := Self.Font;
            Font.Color := GetTabFontColor(Tab);
            Brush.Style := bsClear;

            if not Rotated then
            begin
              L := BR.Left;
              T := BR.Top;

              if (FAlignment = taRightJustify) and ((FTabPosition in [sctpTop, sctpBottom]) and
                (FTabOrientation <> sctoVertical)) or ((FTabPosition in [sctpLeft, sctpRight]) and
                (FTabOrientation = sctoHorizontal)) then
              begin
                if FTabPosition in [sctpTop, sctpBottom] then
                begin
                  T := BR.Top + ((BR.Bottom - BR.Top) -
                    (TxtRect.Bottom - TxtRect.Top)) div 2;
                end else
                if (FTabPosition = sctpLeft) and (FStyle = sctbNew) and
                  (FTabPosition = sctpLeft) then
                  T := BR.Bottom - (TxtRect.Bottom - TxtRect.Top) - 2;

                OffsetRect(TxtRect, BR.Right - TxtRect.Right, T);

                if TxtRect.Right - TxtRect.Left > BR.Right - BR.Left then
                  TxtRect.Left := TxtRect.Right - (BR.Right - BR.Left);
              end else
              begin
                if FTabPosition in [sctpTop, sctpBottom] then
                begin
                  L := BR.Left;
                  T := BR.Top + ((BR.Bottom - BR.Top) -
                    (TxtRect.Bottom - TxtRect.Top)) div 2;
                end else
                if (FTabPosition = sctpLeft) and (FStyle = sctbNew) and
                  (FTabPosition = sctpLeft) then
                  T := BR.Bottom - (TxtRect.Bottom - TxtRect.Top) - 2;

                OffsetRect(TxtRect, L, T);

                if TxtRect.Right - TxtRect.Left > BR.Right - BR.Left then
                  TxtRect.Right := TxtRect.Left + (BR.Right - BR.Left);
              end;

              if TxtRect.Bottom - TxtRect.Top > BR.Bottom - BR.Top then
                TxtRect.Bottom := TxtRect.Top + (BR.Bottom - BR.Top);

              TxtFlags := DT_TOP or DT_NOPREFIX or DT_SINGLELINE or DT_EXPANDTABS;

              if FAlignment = taLeftJustify then
                TxtFlags := TxtFlags or DT_LEFT
              else
                TxtFlags := TxtFlags or DT_RIGHT;

              if FEllipsisType = scteEndEllipsis then
                TxtFlags := TxtFlags or DT_END_ELLIPSIS
              else if FEllipsisType = sctePathEllipsis then
                TxtFlags := TxtFlags or DT_PATH_ELLIPSIS;

              DrawText(Handle, PChar(Text), Length(Text),
                TxtRect, TxtFlags);

              if FShowFocusRect and (Tab.Index = FTabIndex) and
                Self.Focused and Enabled and Tab.Enabled then
              begin
                Inc(TxtRect.Right);
                InflateRect(TxtRect, 2, 2);

                scDrawFocusRect(Canvas, TxtRect, Tab.Color);
              end;
            end else
            begin
              GetTextMetrics(Handle, TM);
              if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
                Font.Name := 'Arial';

              Esc := 2700;
              if FTabPosition = sctpTop then
              begin
                Esc := 900;

                L := BR.Left;
                T := BR.Bottom;

                TxtRect := Rect(L, T - (TxtRect.Right - TxtRect.Left),
                  L + (TxtRect.Bottom - TxtRect.Top), T);
              end else
              if FTabPosition = sctpLeft then
              begin
                Esc := 900;

                L := BR.Left;
                T := BR.Top + (TxtRect.Right - TxtRect.Left) + 1;

                if ValidImage then Dec(T, 5);

                TxtRect := Rect(L, T - (TxtRect.Right - TxtRect.Left),
                  L + (TxtRect.Bottom - TxtRect.Top), T);
              end else
              begin
                L := BR.Left + (TxtRect.Bottom - TxtRect.Top) + 1;
                T := BR.Top + 1;
              end;

              GetObject(Font.Handle, SizeOf(LF), @LF);

              LF.lfEscapement := Esc;
              Ft := CreateFontIndirect(LF);
              Font.Handle := Ft;

              SetBkMode(Handle, Windows.TRANSPARENT);
              ExtTextOut(Handle, L, T, ETO_CLIPPED, @R, PChar(Text),
                Length(Text), nil);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawBackground(Tab: TSCTabData; R: TRect);
var
  R2: TRect;
  Index: Integer;
  C1, C2, C3: TColor;
  GrOrient: TSCGradient;
  IsHot, IsDown: Boolean;
  TbGradient: TSCTabGradient;
begin
  if (Tab = nil) or IsRectEmpty(R) then
    Exit;

  Index := GetActiveIndex;

  if (FStyle = sctbDotNetFlat) and (Tab.Index <> Index) then
    Exit;

  IsHot := False;
  IsDown := False;

  if not IsDesigning then
  begin
    IsHot := FHottrackInfo.Tab = Tab.Index;
    IsDown := FHitInfo.Tab = Tab.Index;
  end;

  if FStyle = sctbOfficeXP then
  begin
    if Index = Tab.Index then
    begin
      if IsHot or (IsHot and IsDown) then
        C1 := GetOfficeXPDownedSelColor
      else
        C1 := GetOfficeXPDownedColor;
    end else
    if IsHot and IsDown then
      C1 := GetOfficeXPDownedSelColor
    else
    if IsHot or IsDown then
      C1 := GetOfficeXPSelColor
    else
      C1 := GetOfficeXPBtnColor;
  end else
  if (FStyle = sctbEclipse) and (Index = Tab.Index) then
  begin
    C1 := FTabColors.FHighlightBar;
    if C1 = clNone then
      C1 := clHighlight;
  end else
  if (FStyle = sctbEclipse) and (Tab.Index <> Index) then
  begin
    C1 := FBackgroundColor;
    if C1 = clNone then C1 := clBtnFace;
  end else
  begin
    C1 := GetTabColor(Tab);
    if (Index = Tab.Index) and (FStyle in [sctbButton, sctbFlatButton]) then
      C1 := BlendedColor(C1, 24, 24, 24, True);
  end;

  if (FStyle <> sctbOffice12) or (Index = Tab.Index) or IsHot or IsDown then
  begin
    if (FStyle = sctbOffice12) and (IsHot and not IsDown and (Index <> Tab.Index)) then
    begin
      C1 := BlendedColor(C1, 8, 8, 8, True);
      C1 := MixColors(C1, clSilver, 40);
    end;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := C1;

      FillRect(R);

      TbGradient := FTabGradient;
      if FStyle = sctbOffice12 then
        TbGradient := sctgDefault
      else if FStyle = sctbEclipse then
      begin
        TbGradient := sctgHorizontal;
        if FTabPosition in [sctpLeft, sctpRight] then
          TbGradient := sctgVertical;
      end;

      if (TbGradient <> sctgNone) and (FStyle in GradientStyles) then
      begin
        if FStyle = sctbEclipse then
        begin
          C2 := FBackgroundColor;
          if C2 = clNone then
            C2 := clBtnFace;

          C3 := C1;
          C1 := C2;
          C2 := C3;
        end else
        begin
          C2 := BlendedColor(C1, 32, 32, 32, True);
          if FStyle = sctbOffice12 then
            C2 := BlendedColor(C1, 80, 80, 80, True);
        end;

        GrOrient := scgBottomToTop;

        case TbGradient of
          sctgHorizontal:
          begin
            GrOrient := scgRightToLeft;
            if FTabPosition = sctpRight then
              GrOrient := scgLeftToRight;
          end;
          sctgVertical:
          begin
            GrOrient := scgBottomToTop;
            if FTabPosition = sctpBottom then
              GrOrient := scgTopToBottom;
          end;
          sctgDefault:
          begin
            case FTabPosition of
              sctpTop:
                GrOrient := scgBottomToTop;
              sctpBottom:
                GrOrient := scgTopToBottom;
              sctpLeft:
                GrOrient := scgRightToLeft;
              sctpRight:
                GrOrient := scgLeftToRight;
            end;
          end;
        end;

        R2 := R;
        if (FStyle = sctbOffice12) and (FTabColors.HottrackBar <> clNone) then
        begin
          case FTabPosition of
            sctpTop:
              R2.Bottom := R.Bottom - Round((R.Bottom - R.Top) / 5);
            sctpBottom:
              R2.Top := R.Top + Round((R.Bottom - R.Top) / 5);
            sctpLeft:
              R2.Right := R.Right - Round((R.Right - R.Left) / 5);
            sctpRight:
              R2.Left := R.Left + Round((R.Right - R.Left) / 5);
          end;
        end;

        scDrawGradient(Canvas, R2, GrOrient, C1, C2);

        if (FStyle = sctbOffice12) and (FTabColors.HottrackBar <> clNone) then
        begin
          R2 := R;
          case FTabPosition of
            sctpTop:
              R2.Top := R.Top + Round((R.Bottom - R.Top) / 5);
            sctpBottom:
              R2.Bottom := R.Bottom - Round((R.Bottom - R.Top) / 5);
            sctpLeft:
              R2.Left := R.Left + Round((R.Right - R.Left) / 5);
            sctpRight:
              R2.Right := R.Right - Round((R.Right - R.Left) / 5);
          end;

          C3 := FTabColors.HottrackBar;
          C2 := BlendedColor(C1, 24, 24, 24, True);

          if IsDown then
          begin
            C3 := MixColors(C1, C3, 50);
            scDrawGradient(Canvas, R2, GrOrient, C3, C2);
          end else
          if IsHot and (Index <> Tab.Index) then
          begin
            C3 := MixColors(C1, C3, 30);
            scDrawGradient(Canvas, R2, GrOrient, C3, C2);
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawTabs;
var
  Data: TSCTabData;
  I, Index: Integer;
begin
  if (FVisibleTabCount > 0) and not IsRectEmpty(FTabsRect) and
    (FFirstTab > -1) and (FFirstTab < FDataList.Count) then
  begin
    Index := GetActiveIndex;

    for I := FFirstTab to FDataList.Count-1 do
    begin
      Data := FDataList[I];
      if Data.Visible and Data.Showing and (I <> Index) then
        PaintTab(Canvas, Data);
    end;

    if (Index > -1) and (Index >= FFirstTab) then
    begin
      Data := FDataList[Index];
      if Data.Visible and Data.Showing then
        PaintTab(Canvas, Data);
    end;
  end;
end;

procedure TSCBaseTabControl.DrawWin2KCard(R: TRect);
var
  Index: Integer;
  TempR, TR: TRect;
  Cl, LightCl, DarkCl, HighCl: TColor;
begin
  if not IsRectEmpty(R) then
  begin
    case FTabPosition of
      sctpBottom:
        Inc(R.Bottom);
      sctpRight:
        Inc(R.Right);
    end;

    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
    end;

    Index := GetActiveIndex;

    Cl := Self.Color;
    if (Index > -1) and (Index < FDataList.Count) and FUseTabColors then
      Cl := FDataList[Index].Color;

    if Cl = clNone then Cl := clBtnFace;

    HighCl := Get3DDkShadowOf(Cl);
    DarkCl := GetBtnShadowOf(Cl);
    LightCl := GetBtnHighlightOf(Cl);

    TempR := R;

    scFrame3D(Canvas, R, LightCl, HighCl, 1, 0);
    scFrame3D(Canvas, R, Cl, DarkCl, 1, 0);

    Index := GetActiveIndex;

    if (Index > -1) and (Index < FDataList.Count) and
      FDataList[Index].Visible and FDataList[Index].Showing then
    begin
      R := TempR;

      Dec(R.Bottom);
      Dec(R.Right);

      TR := FDataList[Index].TabRect;

      case FTabPosition of
        sctpTop:
        begin
          InflateRect(TR, -1, 0);

          with Canvas do
          begin
            Pen.Color := Cl;
            MoveTo(TR.Left,  R.Top);
            LineTo(TR.Right - 1, R.Top);

            Pen.Color := Cl;
            MoveTo(TR.Left,  R.Top + 1);
            LineTo(TR.Right - 1, R.Top + 1);

            Pen.Color := HighCl;
            MoveTo(TR.Right, R.Top);
            LineTo(TR.Right, R.Top + 1);

            Pen.Color := DarkCl;
            MoveTo(TR.Right - 1, R.Top);
            LineTo(TR.Right - 1, R.Top + 1);
          end;
        end;
        sctpBottom:
        begin
          InflateRect(TR, -1, 0);

          with Canvas do
          begin
            Pen.Color := Cl;
            MoveTo(TR.Left,  R.Bottom);
            LineTo(TR.Right - 1, R.Bottom);

            Pen.Color := Cl;
            MoveTo(TR.Left,  R.Bottom - 1);
            LineTo(TR.Right - 1, R.Bottom - 1);

            Pen.Color := HighCl;
            MoveTo(TR.Right, R.Bottom);
            LineTo(TR.Right, R.Bottom + 1);

            Pen.Color := DarkCl;
            MoveTo(TR.Right - 1, R.Bottom);
            LineTo(TR.Right - 1, R.Bottom + 1);

            if Index = GetFirstShowingTab then
            begin
              Pen.Color := LightCl;
              MoveTo(R.Left, R.Bottom);
              LineTo(R.Left, R.Bottom + 1);
            end;
          end;
        end;
        sctpLeft:
        begin
          InflateRect(TR, 0, -1);

          with Canvas do
          begin
            Pen.Color := Cl;
            MoveTo(R.Left, TR.Top);
            LineTo(R.Left, TR.Bottom);

            Pen.Color := Cl;
            MoveTo(R.Left + 1, TR.Top);
            LineTo(R.Left + 1, TR.Bottom);

            Pen.Color := HighCl;
            MoveTo(R.Left, TR.Bottom);
            LineTo(R.Left + 1, TR.Bottom);

            Pen.Color := DarkCl;
            MoveTo(R.Left, TR.Bottom - 1);
            LineTo(R.Left + 1, TR.Bottom - 1);
          end;
        end;
        sctpRight:
        begin
          InflateRect(TR, 0, -1);

          with Canvas do
          begin
            Pen.Color := Cl;
            MoveTo(R.Right, TR.Top);
            LineTo(R.Right, TR.Bottom);

            Pen.Color := Cl;
            MoveTo(R.Right - 1, TR.Top);
            LineTo(R.Right - 1, TR.Bottom);

            Pen.Color := HighCl;
            MoveTo(R.Right, TR.Bottom);
            LineTo(R.Right - 1, TR.Bottom);

            Pen.Color := DarkCl;
            MoveTo(R.Right - 1, TR.Bottom);
            LineTo(R.Right, TR.Bottom);

            Pen.Color := DarkCl;
            MoveTo(R.Right - 1, TR.Bottom - 1);
            LineTo(R.Right + 1, TR.Bottom - 1);

            Pen.Color := LightCl;
            MoveTo(TR.Left, TR.Top - 1);
            LineTo(TR.Left + 1, TR.Top - 1);
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawWhidbeyCard(R: TRect);
var
  TR: TRect;
  Cl: TColor;
  Index: Integer;
  Pts: array[0..4] of TPoint;
begin
  if FShowCardFrame then
  begin
    case FTabPosition of
      sctpBottom:
        Inc(R.Bottom);
      sctpRight:
        Inc(R.Right);
    end;

    Pts[0].x := R.Left;
    Pts[0].y := R.Top;
    Pts[1].x := R.Right-1;
    Pts[1].y := R.Top;
    Pts[2].x := R.Right-1;
    Pts[2].y := R.Bottom-1;
    Pts[3].x := R.Left;
    Pts[3].y := R.Bottom-1;
    Pts[4].x := R.Left;
    Pts[4].y := R.Top;

    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Color := GetFrameColor;

      Polyline(Pts);
    end;

    Index := GetActiveIndex;

    if (Index > -1) and (Index < FDataList.Count) and
      FDataList[Index].Visible and FDataList[Index].Showing then
    begin
      Dec(R.Bottom);
      Dec(R.Right);

      Cl := Self.Color;
      if (Index > -1) and FUseTabColors then
        Cl := FDataList[Index].Color;

      if Cl = clNone then Cl := clBtnFace;

      Canvas.Pen.Color := Cl;
      TR := FDataList[Index].TabRect;

      case FTabPosition of
        sctpTop:
        begin
          Inc(TR.Left);
          Dec(TR.Right);

          Canvas.MoveTo(TR.Left + 1,  R.Top);
          Canvas.LineTo(TR.Right, R.Top);
        end;
        sctpBottom:
        begin
          Inc(TR.Left);

          Canvas.MoveTo(TR.Left,  R.Bottom);
          Canvas.LineTo(TR.Right - 1, R.Bottom);
        end;
        sctpLeft:
        begin
          Inc(TR.Top);
          Dec(TR.Bottom);

          Canvas.MoveTo(R.Left, TR.Top + 1);
          Canvas.LineTo(R.Left, TR.Bottom - 1);
        end;
        sctpRight:
        begin
          Inc(TR.Top);
          Dec(TR.Left);

          Canvas.MoveTo(R.Right, TR.Top + 1);
          Canvas.LineTo(R.Right, TR.Bottom - 2);
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawWhidbeyTab(C: TCanvas; Tab: TSCTabData);
var
  R: TRect;
  Cl: TColor;
  Pts: TSCTabPoints;
begin
  if Tab.Visible and Tab.Showing then
  begin
    SetLength(Pts, 0);
    Pts := Tab.Points;

    case FTabPosition of
      sctpLeft:
      begin
        R := RectFromPoints(Pts);
        Pts := GetTabPoints(R, False, 2, 0);
      end;
      sctpRight:
      begin
        R := RectFromPoints(Pts);
        Inc(R.Top);

        Pts := GetTabPoints(R, False, 2, 0);
      end;
    end;

    if (Pts <> nil) and (Length(Pts) > 2) then
      with C do
      begin
        Pen.Width := 1;
        Pen.Mode  := pmCopy;
        Pen.Style := psSolid;

        Cl := GetFrameColor;
        Pen.Color := Cl;

        Polyline(Pts);
      end;
  end;
end;

procedure TSCBaseTabControl.DrawWin2KTab(C: TCanvas; Tab: TSCTabData);
var
  Len: Integer;
  Pts: TSCTabPoints;
  Cl, LightCl, DarkCl, HighCl: TColor;
begin
  if Tab.Visible and Tab.Showing then
  begin
    SetLength(Pts, 0);
    Pts := Tab.Points;

    Cl := GetTabColor(Tab);

    with C do
    begin
      Pen.Width := 1;
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
    end;

    DarkCl := GetBtnShadowOf(Cl);
    HighCl := Get3DDkShadowOf(cl);
    LightCl := GetBtnHighlightOf(Cl);

    if (Pts <> nil) and (Length(Pts) > 2) then
    begin
      Len := Length(Pts);

      with C do
      begin
        case FTabPosition of
          sctpTop, sctpLeft:
          begin
            Pen.Color := LightCl;
            Polyline(Pts);

            Pen.Color := HighCl;

            MoveTo(Pts[Len-3].x, Pts[Len-3].y);
            LineTo(Pts[Len-2].x, Pts[Len-2].y);
            LineTo(Pts[Len-1].x, Pts[Len-1].y);

            Pen.Color := LightCl;

            MoveTo(Pts[Len-3].x, Pts[Len-3].y);
            LineTo(Pts[Len-3].x + 1, Pts[Len-3].y);
          end;
          sctpBottom, sctpRight:
          begin
            Pen.Color := HighCl;
            Polyline(Pts);

            Pen.Color := LightCl;

            MoveTo(Pts[0].x, Pts[0].y);
            LineTo(Pts[1].x, Pts[1].y);
            LineTo(Pts[2].x, Pts[2].y);

            Pen.Color := HighCl;

            MoveTo(Pts[2].x, Pts[2].y);
            LineTo(Pts[2].x, Pts[2].y + 1);
          end;
        end;
      end;
    end;

    SetLength(Pts, 0);
    Pts := GetTabPoints(Tab.TabRect, False, 2, 1);

    if (Pts <> nil) and (Length(Pts) > 2) then
    begin
      Len := Length(Pts);

      with C do
      begin
        case FTabPosition of
          sctpTop, sctpLeft:
          begin
            Pen.Color := Cl;
            Polyline(Pts);

            Pen.Color := DarkCl;

            MoveTo(Pts[Len-3].x, Pts[Len-3].y);
            LineTo(Pts[Len-2].x, Pts[Len-2].y);
            LineTo(Pts[Len-1].x, Pts[Len-1].y);

            Pen.Color := Cl;

            MoveTo(Pts[Len-3].x, Pts[Len-3].y);
            LineTo(Pts[Len-3].x + 1, Pts[Len-3].y);
          end;
          sctpBottom, sctpRight:
          begin
            Pen.Color := DarkCl;
            Polyline(Pts);

            Pen.Color := Cl;

            MoveTo(Pts[0].x, Pts[0].y);
            LineTo(Pts[1].x, Pts[1].y);
            LineTo(Pts[2].x, Pts[2].y);

            Pen.Color := DarkCl;

            MoveTo(Pts[2].x, Pts[2].y);
            LineTo(Pts[2].x, Pts[2].y + 1);
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawNewCard(R: TRect);
var
  TR: TRect;
  Cl: TColor;
  Index: Integer;
  Pts: array[0..4] of TPoint;
begin
  if FShowCardFrame then
  begin
    case FTabPosition of
      sctpBottom:
        Inc(R.Bottom);
      sctpRight:
        Inc(R.Right);
    end;

    Pts[0].x := R.Left;
    Pts[0].y := R.Top;
    Pts[1].x := R.Right-1;
    Pts[1].y := R.Top;
    Pts[2].x := R.Right-1;
    Pts[2].y := R.Bottom-1;
    Pts[3].x := R.Left;
    Pts[3].y := R.Bottom-1;
    Pts[4].x := R.Left;
    Pts[4].y := R.Top;

    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Color := GetFrameColor;

      Polyline(Pts);
    end;

    Index := GetActiveIndex;
    
    if (Index > -1) and (Index < FDataList.Count) and
      FDataList[Index].Visible and FDataList[Index].Showing then
    begin
      Dec(R.Bottom);
      Dec(R.Right);

      Cl := Self.Color;
      if (Index > -1) and FUseTabColors then
        Cl := FDataList[Index].Color;

      if Cl = clNone then Cl := clBtnFace;

      Canvas.Pen.Color := Cl;
      TR := FDataList[Index].TabRect;

      case FTabPosition of
        sctpTop:
        begin
          Inc(TR.Left);

          Canvas.MoveTo(TR.Left,  R.Top);
          Canvas.LineTo(TR.Right - 1, R.Top);
        end;
        sctpBottom:
        begin
          Inc(TR.Left);

          Canvas.MoveTo(TR.Left,  R.Bottom);
          Canvas.LineTo(TR.Right - 1, R.Bottom);
        end;
        sctpLeft:
        begin
          Inc(TR.Top);

          Canvas.MoveTo(R.Left, TR.Top);
          Canvas.LineTo(R.Left, TR.Bottom - 1);
        end;
        sctpRight:
        begin
          Inc(TR.Top);
          Dec(TR.Left);

          Canvas.MoveTo(R.Right, TR.Top);
          Canvas.LineTo(R.Right, TR.Bottom - 1);
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawNewXCard(R: TRect);
var
  TR: TRect;
  Cl: TColor;
  Index: Integer;
  Pts: array[0..4] of TPoint;
begin
  if FShowCardFrame then
  begin
    case FTabPosition of
      sctpBottom:
        Inc(R.Bottom);
      sctpRight:
        Inc(R.Right);
    end;

    Pts[0].x := R.Left;
    Pts[0].y := R.Top;
    Pts[1].x := R.Right-1;
    Pts[1].y := R.Top;
    Pts[2].x := R.Right-1;
    Pts[2].y := R.Bottom-1;
    Pts[3].x := R.Left;
    Pts[3].y := R.Bottom-1;
    Pts[4].x := R.Left;
    Pts[4].y := R.Top;

    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Color := GetFrameColor;

      Polyline(Pts);
    end;

    Index := GetActiveIndex;

    if (Index > -1) and (Index < FDataList.Count) and
      FDataList[Index].Visible and FDataList[Index].Showing then
    begin
      Dec(R.Bottom);
      Dec(R.Right);

      Cl := Self.Color;
      if (Index > -1) and FUseTabColors then
        Cl := FDataList[Index].Color;

      if Cl = clNone then Cl := clBtnFace;

      Canvas.Pen.Color := Cl;
      TR := FDataList[Index].TabRect;

      case FTabPosition of
        sctpTop:
        begin
          Inc(TR.Left);
          Dec(TR.Right);

          Canvas.MoveTo(TR.Left,  R.Top);
          Canvas.LineTo(TR.Right - 1, R.Top);
        end;
        sctpBottom:
        begin
          Inc(TR.Left);

          Canvas.MoveTo(TR.Left,  R.Bottom);
          Canvas.LineTo(TR.Right - 1, R.Bottom);
        end;
        sctpLeft:
        begin
          Inc(TR.Top);
          Dec(TR.Bottom);

          Canvas.MoveTo(R.Left, TR.Top);
          Canvas.LineTo(R.Left, TR.Bottom - 1);
        end;
        sctpRight:
        begin
          Inc(TR.Top);
          Dec(TR.Left);

          Canvas.MoveTo(R.Right, TR.Top);
          Canvas.LineTo(R.Right, TR.Bottom - 1);
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawXpCard(R: TRect);
var
  TR: TRect;
  Cl: TColor;
  Index: Integer;
  Pts: array[0..4] of TPoint;
begin
  if FShowCardFrame then
  begin
    case FTabPosition of
      sctpBottom:
        Inc(R.Bottom);
      sctpRight:
        Inc(R.Right);
    end;

    Pts[0].x := R.Left;
    Pts[0].y := R.Top;
    Pts[1].x := R.Right-1;
    Pts[1].y := R.Top;
    Pts[2].x := R.Right-1;
    Pts[2].y := R.Bottom-1;
    Pts[3].x := R.Left;
    Pts[3].y := R.Bottom-1;
    Pts[4].x := R.Left;
    Pts[4].y := R.Top;

    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Color := GetFrameColor;

      Polyline(Pts);
    end;

    Index := GetActiveIndex;

    if (Index > -1) and (Index < FDataList.Count) and
      FDataList[Index].Visible and FDataList[Index].Showing then
    begin
      Dec(R.Bottom);
      Dec(R.Right);

      Cl := Self.Color;
      if (Index > -1) and FUseTabColors then
        Cl := FDataList[Index].Color;

      if Cl = clNone then Cl := clBtnFace;

      Canvas.Pen.Color := Cl;
      TR := FDataList[Index].TabRect;

      case FTabPosition of
        sctpTop:
        begin
          Inc(TR.Left);

          Canvas.MoveTo(TR.Left,  R.Top);
          Canvas.LineTo(TR.Right - 1, R.Top);
        end;
        sctpBottom:
        begin
          Inc(TR.Left);

          Canvas.MoveTo(TR.Left,  R.Bottom);
          Canvas.LineTo(TR.Right - 1, R.Bottom);
        end;
        sctpLeft:
        begin
          Inc(TR.Top);

          Canvas.MoveTo(R.Left, TR.Top);
          Canvas.LineTo(R.Left, TR.Bottom - 1);
        end;
        sctpRight:
        begin
          Inc(TR.Top);
          Dec(TR.Left);

          Canvas.MoveTo(R.Right, TR.Top);
          Canvas.LineTo(R.Right, TR.Bottom - 1);
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.DrawNewTab(C: TCanvas; Tab: TSCTabData);
var
  Cl: TColor;
  Pts: TSCTabPoints;
begin
  if Tab.Visible and Tab.Showing then
  begin
    SetLength(Pts, 0);
    Pts := Tab.Points;

    if (Pts <> nil) and (Length(Pts) > 2) then
      with C do
      begin
        Pen.Width := 1;
        Pen.Mode  := pmCopy;
        Pen.Style := psSolid;

        Cl := GetFrameColor;
        Pen.Color := Cl;

        Polyline(Pts);
      end;
  end;
end;

procedure TSCBaseTabControl.DrawNewXTab(C: TCanvas; Tab: TSCTabData);
var
  Cl: TColor;
  Pts: TSCTabPoints;
begin
  if Tab.Visible and Tab.Showing then
  begin
    SetLength(Pts, 0);
    Pts := Tab.Points;

    if (Pts <> nil) and (Length(Pts) > 2) then
      with C do
      begin
        Pen.Width := 1;
        Pen.Mode  := pmCopy;
        Pen.Style := psSolid;

        Cl := GetFrameColor;
        Pen.Color := Cl;

        Polyline(Pts);
      end;
  end;
end;

procedure TSCBaseTabControl.DrawXpTab(C: TCanvas; Tab: TSCTabData);
var
  Cl: TColor;
  Pts: TSCTabPoints;
begin
  if Tab.Visible and Tab.Showing then
  begin
    SetLength(Pts, 0);
    Pts := Tab.Points;

    if (Pts <> nil) and (Length(Pts) > 2) then
      with C do
      begin
        Pen.Width := 1;
        Pen.Mode  := pmCopy;
        Pen.Style := psSolid;

        Cl := GetFrameColor;
        Pen.Color := Cl;

        Polyline(Pts);
      end;
  end;
end;

procedure TSCBaseTabControl.FillDataList;
begin
  //
end;

function TSCBaseTabControl.GetActiveIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FDataList <> nil then
  begin
    Result := FTabIndex;
    if (Result > -1) and ((Result > FDataList.Count-1) or
      not FDataList[Result].Visible) then
      Result := -1;

    if Result = -1 then
      for I := 0 to FDataList.Count-1 do
        if FDataList[I].Visible then
        begin
          Result := I;
          Break;
        end;
  end;
end;

function TSCBaseTabControl.GetBandRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated and (FVisibleTabCount > 0) and (FTabSize > 0) then
  begin
    Result := ClientRect;

    case FTabPosition of
      sctpTop:
        Result.Bottom := Result.Top + FTabSize;
      sctpBottom:
      begin
        Result.Top := Result.Bottom - FTabSize;
        if Result.Top < 0 then
          OffsetRect(Result, 0, -Result.Top);
      end;
      sctpLeft:
        Result.Right := Result.Left + FTabSize;
      sctpRight:
      begin
        Result.Left := Result.Right - FTabSize;
        if Result.Left < 0 then
          OffsetRect(Result, -Result.Left, 0);
      end;
    end;
  end;
end;

function TSCBaseTabControl.GetCardRect: TRect;
var
  R: TRect;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated then
  begin
    Result := ClientRect;

    if FVisibleTabCount > 0 then
    begin
      R := FTabsRect;

      case FTabPosition of
        sctpTop:
          Result.Top := R.Bottom;
        sctpBottom:
          Result.Bottom := R.Top;
        sctpLeft:
          Result.Left := R.Right;
        sctpRight:
          Result.Right := R.Left;
      end;

      if FTabPosition = sctpRight then
        Dec(Result.Right)
      else if FTabPosition = sctpBottom then
        Dec(Result.Bottom);
    end;
  end;  
end;

function TSCBaseTabControl.GetCloseButtonRect: TRect;
var
  CR: TRect;
  H: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if FShowCloseButton then
  begin
    H := 18;
    CR := ClientRect;

    case FTabPosition of
      sctpTop:
      begin
        Result.Right := CR.Right;
        Result.Left := Result.Right - H;

        Result.Bottom := CR.Top + (FTabSize - 2);
        Result.Top := Result.Bottom - H;
      end;
      sctpBottom:
      begin
        Result.Right := CR.Right;
        Result.Left := Result.Right - H;

        Result.Top := CR.Bottom - (FTabSize - 2);
        Result.Bottom := Result.Top + H;
      end;
      sctpLeft:
      begin
        Result.Right := CR.Left + (FTabSize - 2);
        Result.Left := Result.Right - H;

        Result.Bottom := CR.Bottom;
        Result.Top := Result.Bottom - H;
      end;
      sctpRight:
      begin
        Result.Left := CR.Right - (FTabSize - 2);
        Result.Right := Result.Left + H;

        Result.Bottom := CR.Bottom;
        Result.Top := Result.Bottom - H;
      end;
    end;
  end;
end;

function TSCBaseTabControl.GetFrameColor: TColor;
begin
  Result := Self.FrameColor;
  if Result = clNone then
  begin
    Result := clBtnShadow;
    if Self.Color <> clNone then
      Result := GetBtnShadowOf(Self.Color);
  end;
end;

function TSCBaseTabControl.GetScrollerRect(Left: Boolean): TRect;
var
  CR: TRect;
  H: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if FScrollersVisible then
  begin
    H := 18;
    CR := ClientRect;

    case FTabPosition of
      sctpTop:
      begin
        Result.Right := CR.Right;
        Result.Left := Result.Right - H;

        Result.Bottom := CR.Top + (FTabSize - 2);
        Result.Top := Result.Bottom - H;

        if Left then OffsetRect(Result, -H, 0);
        if FShowCloseButton then OffsetRect(Result, -(H + 2), 0);
      end;
      sctpBottom:
      begin
        Result.Right := CR.Right;
        Result.Left := Result.Right - H;

        Result.Top := CR.Bottom - (FTabSize - 2);
        Result.Bottom := Result.Top + H;

        if Left then OffsetRect(Result, -H, 0);
        if FShowCloseButton then OffsetRect(Result, -(H + 2), 0);
      end;
      sctpLeft:
      begin
        Result.Right := CR.Left + (FTabSize - 2);
        Result.Left := Result.Right - H;

        Result.Bottom := CR.Bottom;
        Result.Top := Result.Bottom - H;

        if Left then OffsetRect(Result, 0, -H);
        if FShowCloseButton then OffsetRect(Result, 0, -(H + 2));
      end;
      sctpRight:
      begin
        Result.Left := CR.Right - (FTabSize - 2);
        Result.Right := Result.Left + H;

        Result.Bottom := CR.Bottom;
        Result.Top := Result.Bottom - H;

        if Left then OffsetRect(Result, 0, -H);
        if FShowCloseButton then OffsetRect(Result, 0, -(H + 2));
      end;
    end;
  end;
end;

function TSCBaseTabControl.GetScrollersVisible: Boolean;
begin
  Result := False;
end;

function TSCBaseTabControl.GetTabColor(Tab: TSCTabData): TColor;
var
  Index: Integer;
begin
  Result := Self.Color;
  if Result = clNone then Result := clBtnFace;

  if Tab <> nil then
  begin
    Index := GetActiveIndex;

    if not FUseTabColors and (Tab.Index <> Index) then
    begin
      Result := FTabColors.Unselected;

      if Result = clNone then Result := Self.Color;
      if Result = clNone then Result := clBtnFace;
    end else
    if FUseTabColors then
    begin
      Result := Tab.Color;

      if Result = clNone then
      begin
        if Tab.Index <> Index then
        begin
          Result := FTabColors.Unselected;
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

function TSCBaseTabControl.GetTabSize: Integer;
begin
  Result := 0;
end;

function TSCBaseTabControl.GetTabSpacing: Integer;
begin
  Result := 0;
  if FStyle in [sctbButton, sctbFlatButton, sctbOffice12, sctbOfficeXP] then
  begin
    Result := Self.Spacing;
    if (Result < 4) and (FStyle = sctbOffice12) then
      Result := 4;
  end;
end;

function TSCBaseTabControl.GetTabPoints(R: TRect; ForRegion: Boolean;
  Rounding, FrameIndex: Integer): TSCTabPoints;
var
  Rnd: Integer;
  TempR: TRect;
begin
  Result := nil;
  
  if not IsRectEmpty(R) then
  begin
    if Rounding < 0 then Rounding := 0; 
    if FrameIndex < 0 then FrameIndex := 0;

    if not ForRegion then
    begin
      if FTabPosition in [sctpTop, sctpBottom, sctpRight] then
        Dec(R.Right);

      if FTabPosition in [sctpLeft, sctpRight, sctpBottom] then
        Dec(R.Bottom);
    end;

    case FStyle of
      sctbWin2K:
      begin
        Rounding := 2;
        if (R.Right - R.Left < Rounding) or (R.Bottom - R.Top < Rounding) then
          Rounding := 0;

        if FrameIndex > 0 then
        begin
          Dec(Rounding, FrameIndex);
          if Rounding < 0 then Rounding := 0;

          TempR := R;
          InflateRect(R, -FrameIndex, -FrameIndex);

          if IsRectEmpty(R) then
            Exit;

          case FTabPosition of
            sctpTop:
              R.Bottom := TempR.Bottom;
            sctpBottom:
              R.Top := TempR.Top;
            sctpLeft:
              R.Right := TempR.Right;
            sctpRight:
              R.Left := TempR.Left;
          end;
        end;

        SetLength(Result, 6);

        case FTabPosition of
          sctpTop:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Bottom;
            Result[1].x := R.Left;
            Result[1].y := R.Top + Rounding;
            Result[2].x := R.Left + Rounding;
            Result[2].y := R.Top;
            Result[3].x := R.Right - Rounding;
            Result[3].y := R.Top;
            Result[4].x := R.Right;
            Result[4].y := R.Top + Rounding;
            Result[5].x := R.Right;
            Result[5].y := R.Bottom;
          end;
          sctpBottom:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Left;
            Result[1].y := R.Bottom - Rounding;
            Result[2].x := R.Left + Rounding;
            Result[2].y := R.Bottom;
            Result[3].x := R.Right - Rounding;
            Result[3].y := R.Bottom;
            Result[4].x := R.Right;
            Result[4].y := R.Bottom - Rounding;
            Result[5].x := R.Right;
            Result[5].y := R.Top;

            if ForRegion then
            begin
              Result[1].y := R.Bottom - Rounding - 1;
              Result[2].x := R.Left + Rounding + 1;
            end;
          end;
          sctpLeft:
          begin
            Result[0].x := R.Right;
            Result[0].y := R.Top;
            Result[1].x := R.Left + Rounding;
            Result[1].y := R.Top;
            Result[2].x := R.Left;
            Result[2].y := R.Top + Rounding;
            Result[3].x := R.Left;
            Result[3].y := R.Bottom - Rounding;
            Result[4].x := R.Left + Rounding;
            Result[4].y := R.Bottom;
            Result[5].x := R.Right;
            Result[5].y := R.Bottom;

            if ForRegion then
            begin
              Result[3].y := R.Bottom - Rounding - 1;
              Result[4].x := R.Left + Rounding + 1;
            end;
          end;
          sctpRight:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Right - Rounding;
            Result[1].y := R.Top;
            Result[2].x := R.Right;
            Result[2].y := R.Top + Rounding;
            Result[3].x := R.Right;
            Result[3].y := R.Bottom - Rounding;
            Result[4].x := R.Right - Rounding;
            Result[4].y := R.Bottom;
            Result[5].x := R.Left;
            Result[5].y := R.Bottom;
          end;
        end;
      end;
      sctbOffice12:
      begin
        if Rounding < 2 then Rounding := 2;
        if (R.Right - R.Left < Rounding) or (R.Bottom - R.Top < Rounding) then
          Rounding := 0;

        SetLength(Result, 6);

        case FTabPosition of
          sctpTop:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Bottom;
            Result[1].x := R.Left;
            Result[1].y := R.Top + Rounding;
            Result[2].x := R.Left + Rounding;
            Result[2].y := R.Top;
            Result[3].x := R.Right - Rounding;
            Result[3].y := R.Top;
            Result[4].x := R.Right;
            Result[4].y := R.Top + Rounding;
            Result[5].x := R.Right;
            Result[5].y := R.Bottom;
          end;
          sctpBottom:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Left;
            Result[1].y := R.Bottom - Rounding;
            Result[2].x := R.Left + Rounding;
            Result[2].y := R.Bottom;
            Result[3].x := R.Right - Rounding;
            Result[3].y := R.Bottom;
            Result[4].x := R.Right;
            Result[4].y := R.Bottom - Rounding;
            Result[5].x := R.Right;
            Result[5].y := R.Top;

            if ForRegion then
            begin
              Result[1].y := R.Bottom - Rounding - 1;
              Result[2].x := R.Left + Rounding + 1;
            end;
          end;
          sctpLeft:
          begin
            Result[0].x := R.Right;
            Result[0].y := R.Top;
            Result[1].x := R.Left + Rounding;
            Result[1].y := R.Top;
            Result[2].x := R.Left;
            Result[2].y := R.Top + Rounding;
            Result[3].x := R.Left;
            Result[3].y := R.Bottom - Rounding;
            Result[4].x := R.Left + Rounding;
            Result[4].y := R.Bottom;
            Result[5].x := R.Right;
            Result[5].y := R.Bottom;

            if ForRegion then
            begin
              Result[3].y := R.Bottom - Rounding - 1;
              Result[4].x := R.Left + Rounding + 1;
            end;
          end;
          sctpRight:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Right - Rounding;
            Result[1].y := R.Top;
            Result[2].x := R.Right;
            Result[2].y := R.Top + Rounding;
            Result[3].x := R.Right;
            Result[3].y := R.Bottom - Rounding;
            Result[4].x := R.Right - Rounding;
            Result[4].y := R.Bottom;
            Result[5].x := R.Left;
            Result[5].y := R.Bottom;
          end;
        end;
      end;
      sctbXP:
      begin
        Rounding := 2;
        if (R.Right - R.Left < Rounding) or (R.Bottom - R.Top < Rounding) then
          Rounding := 0;

        SetLength(Result, 6);

        case FTabPosition of
          sctpTop:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Bottom;
            Result[1].x := R.Left;
            Result[1].y := R.Top + Rounding;
            Result[2].x := R.Left + Rounding;
            Result[2].y := R.Top;
            Result[3].x := R.Right - Rounding;
            Result[3].y := R.Top;
            Result[4].x := R.Right;
            Result[4].y := R.Top + Rounding;
            Result[5].x := R.Right;
            Result[5].y := R.Bottom;
          end;
          sctpBottom:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Left;
            Result[1].y := R.Bottom - Rounding;
            Result[2].x := R.Left + Rounding;
            Result[2].y := R.Bottom;
            Result[3].x := R.Right - Rounding;
            Result[3].y := R.Bottom;
            Result[4].x := R.Right;
            Result[4].y := R.Bottom - Rounding;
            Result[5].x := R.Right;
            Result[5].y := R.Top;

            if ForRegion then
            begin
              Result[1].y := R.Bottom - Rounding - 1;
              Result[2].x := R.Left + Rounding + 1;
            end;
          end;
          sctpLeft:
          begin
            Result[0].x := R.Right;
            Result[0].y := R.Top;
            Result[1].x := R.Left + Rounding;
            Result[1].y := R.Top;
            Result[2].x := R.Left;
            Result[2].y := R.Top + Rounding;
            Result[3].x := R.Left;
            Result[3].y := R.Bottom - Rounding;
            Result[4].x := R.Left + Rounding;
            Result[4].y := R.Bottom;
            Result[5].x := R.Right;
            Result[5].y := R.Bottom;

            if ForRegion then
            begin
              Result[3].y := R.Bottom - Rounding - 1;
              Result[4].x := R.Left + Rounding + 1;
            end;
          end;
          sctpRight:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Right - Rounding;
            Result[1].y := R.Top;
            Result[2].x := R.Right;
            Result[2].y := R.Top + Rounding;
            Result[3].x := R.Right;
            Result[3].y := R.Bottom - Rounding;
            Result[4].x := R.Right - Rounding;
            Result[4].y := R.Bottom;
            Result[5].x := R.Left;
            Result[5].y := R.Bottom;
          end;
        end;
      end;
      sctbDotNet:
      begin
        SetLength(Result, 4);

        case FTabPosition of
          sctpTop:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Bottom;
            Result[1] := R.TopLeft;
            Result[2].x := R.Right;
            Result[2].y := R.Top;
            Result[3].x := R.Right;
            Result[3].y := R.Bottom;
          end;
          sctpBottom:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Left;
            Result[1].y := R.Bottom;
            Result[2].x := R.Right;
            Result[2].y := R.Bottom;
            Result[3].x := R.Right;
            Result[3].y := R.Top;
          end;
          sctpLeft:
          begin
            Result[0].x := R.Right;
            Result[0].y := R.Top;
            Result[1].x := R.Left;
            Result[1].y := R.Top;
            Result[2].x := R.Left;
            Result[2].y := R.Bottom;
            Result[3].x := R.Right;
            Result[3].y := R.Bottom;
          end;
          sctpRight:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Right;
            Result[1].y := R.Top;
            Result[2].x := R.Right;
            Result[2].y := R.Bottom;
            Result[3].x := R.Left;
            Result[3].y := R.Bottom;
          end;
        end;
      end;
      sctbDotNetFlat:
      begin
        Rounding := 2;
        if (R.Right - R.Left < Rounding) or (R.Bottom - R.Top < Rounding) then
          Rounding := 0;

        SetLength(Result, 6);

        case FTabPosition of
          sctpTop:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Bottom;
            Result[1].x := R.Left;
            Result[1].y := R.Top + Rounding;
            Result[2].x := R.Left + Rounding;
            Result[2].y := R.Top;
            Result[3].x := R.Right - Rounding;
            Result[3].y := R.Top;
            Result[4].x := R.Right;
            Result[4].y := R.Top + Rounding;
            Result[5].x := R.Right;
            Result[5].y := R.Bottom;
          end;
          sctpBottom:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Left;
            Result[1].y := R.Bottom - Rounding;
            Result[2].x := R.Left + Rounding;
            Result[2].y := R.Bottom;
            Result[3].x := R.Right - Rounding;
            Result[3].y := R.Bottom;
            Result[4].x := R.Right;
            Result[4].y := R.Bottom - Rounding;
            Result[5].x := R.Right;
            Result[5].y := R.Top;

            if ForRegion then
            begin
              Result[1].y := R.Bottom - Rounding - 1;
              Result[2].x := R.Left + Rounding + 1;
            end;
          end;
          sctpLeft:
          begin
            Result[0].x := R.Right;
            Result[0].y := R.Top;
            Result[1].x := R.Left + Rounding;
            Result[1].y := R.Top;
            Result[2].x := R.Left;
            Result[2].y := R.Top + Rounding;
            Result[3].x := R.Left;
            Result[3].y := R.Bottom - Rounding;
            Result[4].x := R.Left + Rounding;
            Result[4].y := R.Bottom;
            Result[5].x := R.Right;
            Result[5].y := R.Bottom;

            if ForRegion then
            begin
              Result[3].y := R.Bottom - Rounding - 1;
              Result[4].x := R.Left + Rounding + 1;
            end;
          end;
          sctpRight:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Right - Rounding;
            Result[1].y := R.Top;
            Result[2].x := R.Right;
            Result[2].y := R.Top + Rounding;
            Result[3].x := R.Right;
            Result[3].y := R.Bottom - Rounding;
            Result[4].x := R.Right - Rounding;
            Result[4].y := R.Bottom;
            Result[5].x := R.Left;
            Result[5].y := R.Bottom;
          end;
        end;
      end;
      sctbEclipse, sctbOfficeXP,
      sctbButton, sctbFlatButton:
      begin
        SetLength(Result, 5);

        Result[0].x := R.Left;
        Result[0].y := R.Top;
        Result[1].x := R.Right;
        Result[1].y := R.Top;
        Result[2].x := R.Right;
        Result[2].y := R.Bottom;
        Result[3].x := R.Left;
        Result[3].y := R.Bottom;
        Result[4].x := R.Left;
        Result[4].y := R.Top;
      end;
      sctbNew:
      begin
        Rounding := 8;
        if (R.Right - R.Left < Rounding) or (R.Bottom - R.Top < Rounding) then
          Rounding := 0;

        SetLength(Result, 5);

        case FTabPosition of
          sctpTop:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Bottom;
            Result[1].x := R.Left;
            Result[1].y := R.Top;
            Result[2].x := R.Right - Rounding;
            Result[2].y := R.Top;
            Result[3].x := R.Right;
            Result[3].y := R.Top + Rounding;
            Result[4].x := R.Right;
            Result[4].y := R.Bottom;
          end;
          sctpBottom:
          begin
            if ForRegion and (Rounding > 0) then
              Inc(Rounding);

            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Left;
            Result[1].y := R.Bottom;
            Result[2].x := R.Right - Rounding;
            Result[2].y := R.Bottom;
            Result[3].x := R.Right;
            Result[3].y := R.Bottom - Rounding;
            Result[4].x := R.Right;
            Result[4].y := R.Top;
          end;
          sctpLeft:
          begin
            Result[0].x := R.Right;
            Result[0].y := R.Top;
            Result[1].x := R.Left + Rounding;
            Result[1].y := R.Top;
            Result[2].x := R.Left;
            Result[2].y := R.Top + Rounding;
            Result[3].x := R.Left;
            Result[3].y := R.Bottom;
            Result[4].x := R.Right;
            Result[4].y := R.Bottom;
          end;
          sctpRight:
          begin
            if ForRegion and (Rounding > 0) then
              Inc(Rounding);

            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Right;
            Result[1].y := R.Top;
            Result[2].x := R.Right;
            Result[2].y := R.Bottom - Rounding;
            Result[3].x := R.Right - Rounding;
            Result[3].y := R.Bottom;
            Result[4].x := R.Left;
            Result[4].y := R.Bottom;
          end;
        end;
      end;
      sctbNewX:
      begin
        Rounding := 2;
        SetLength(Result, 5);

        case FTabPosition of
          sctpTop:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Bottom;
            Result[1].x := R.Left;
            Result[1].y := R.Top + Rounding;
            Result[2].x := R.Left + Rounding;
            Result[2].y := R.Top;
            Result[3].x := R.Right - (R.Bottom - R.Top);
            Result[3].y := R.Top;
            Result[4].x := R.Right;
            Result[4].y := R.Bottom;
          end;
          sctpBottom:
          begin
            if ForRegion and (Rounding > 0) then
              Inc(Rounding);

            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Left;
            Result[1].y := R.Bottom - Rounding;
            Result[2].x := R.Left + Rounding;
            Result[2].y := R.Bottom;
            Result[3].x := R.Right - (R.Bottom - R.Top);
            Result[3].y := R.Bottom;
            Result[4].x := R.Right;
            Result[4].y := R.Top;
          end;
          sctpLeft:
          begin
            if ForRegion then
              Dec(R.Bottom);

            Result[0].x := R.Right;
            Result[0].y := R.Top;
            Result[1].x := R.Left + Rounding;
            Result[1].y := R.Top;
            Result[2].x := R.Left;
            Result[2].y := R.Top + Rounding;
            Result[3].x := R.Left;
            Result[3].y := R.Bottom - (R.Right - R.Left);
            Result[4].x := R.Right;
            Result[4].y := R.Bottom;
          end;
          sctpRight:
          begin
            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Right - Rounding;
            Result[1].y := R.Top;
            Result[2].x := R.Right;
            Result[2].y := R.Top + Rounding;
            Result[3].x := R.Right;
            Result[3].y := R.Bottom - (R.Right - R.Left);
            Result[4].x := R.Left;
            Result[4].y := R.Bottom;
          end;
        end;
      end;
      sctbWhidbey:
      begin
        Rounding := 2;
        SetLength(Result, 7);

        case FTabPosition of
          sctpTop:
          begin
            Rnd := 2;
            Dec(R.Right, 2);

            Result[0].x := R.Left;
            Result[0].y := R.Bottom;
            Result[1].x := R.Left + (R.Bottom - R.Top) - Rnd;
            Result[1].y := R.Top + Rnd;
            Result[2].x := R.Left + (R.Bottom - R.Top) + Rnd;
            Result[2].y := R.Top;
            Result[3].x := R.Right - Rounding;
            Result[3].y := R.Top;
            Result[4].x := R.Right;
            Result[4].y := R.Top + Rounding;
            Result[5].x := R.Right;
            Result[5].y := R.Bottom - 3;
            Result[6].x := R.Right + 3;
            Result[6].y := R.Bottom;
          end;
          sctpBottom:
          begin
            Rnd := 3;
            Dec(R.Right, 2);

            if ForRegion and (Rounding > 0) then
              Inc(Rounding);

            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Left + (R.Bottom - R.Top) - Rnd;
            Result[1].y := R.Bottom - Rnd;
            Result[2].x := R.Left + (R.Bottom - R.Top) + Rnd;
            Result[2].y := R.Bottom;
            Result[3].x := R.Right - Rounding;
            Result[3].y := R.Bottom;
            Result[4].x := R.Right;
            Result[4].y := R.Bottom - Rounding;
            Result[5].x := R.Right;
            Result[5].y := R.Top + 3;
            Result[6].x := R.Right + 3;
            Result[6].y := R.Top;
          end;
          sctpLeft:
          begin
            Rnd := 2;
            Dec(R.Bottom, 2);

            if ForRegion then
              Inc(Rounding);

            Result[0].x := R.Right;
            Result[0].y := R.Top;
            Result[1].x := R.Left + Rnd;
            Result[1].y := R.Top + (R.Right - R.Left) - Rnd;
            Result[2].x := R.Left;
            Result[2].y := R.Top + (R.Right - R.Left) + Rnd;
            Result[3].x := R.Left;
            Result[3].y := R.Bottom - Rounding;
            Result[4].x := R.Left + Rounding;
            Result[4].y := R.Bottom;
            Result[5].x := R.Right - 3;
            Result[5].y := R.Bottom;
            Result[6].x := R.Right;
            Result[6].y := R.Bottom + 3;
          end;
          sctpRight:
          begin
            Rnd := 3;
            Dec(R.Bottom, 2);

            if ForRegion then
            begin
              Rnd := 4;

              Dec(R.Bottom);
              Inc(Rounding, 2);
            end;

            Result[0].x := R.Left;
            Result[0].y := R.Top;
            Result[1].x := R.Right - Rnd;
            Result[1].y := R.Top + (R.Right - R.Left) - Rnd;
            Result[2].x := R.Right;
            Result[2].y := R.Top + (R.Right - R.Left) + Rnd;
            Result[3].x := R.Right;
            Result[3].y := R.Bottom - Rounding;
            Result[4].x := R.Right - Rounding;
            Result[4].y := R.Bottom;
            Result[5].x := R.Left + 2;
            Result[5].y := R.Bottom;
            Result[6].x := R.Left;
            Result[6].y := R.Bottom + 2;
          end;
        end;
      end;
    end;
  end;
end;

function TSCBaseTabControl.GetTabRect(Index: Integer): TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if (Index > -1) and (Index < FDataList.Count) and FDataList[Index].Visible then
    Result := FDataList[Index].TabRect;
end;

function TSCBaseTabControl.GetTabsRect: TRect;
var
  R: TRect;
  AIndent, BtnSize, Spare: Integer;
begin
  Result := GetBandRect;
  AIndent := GetIndent;

  if AIndent > 0 then
  begin
    if FTabPosition in [sctpTop, sctpBottom] then
      Inc(Result.Left, AIndent)
    else
      Inc(Result.Top, AIndent);
  end;

  BtnSize := 0;
  if FShowCloseButton then
  begin
    R := GetCloseButtonRect;

    BtnSize := R.Right - R.Left;
    if FTabPosition in [sctpLeft, sctpRight] then
      BtnSize := R.Bottom - R.Top;
  end else
  if FScrollersVisible then
  begin
    R := GetScrollerRect(False);

    BtnSize := R.Right - R.Left;
    if FTabPosition in [sctpLeft, sctpRight] then
      BtnSize := R.Bottom - R.Top;
  end;

  if BtnSize > 3 then
  begin
    Spare := 2;

    if FShowCloseButton then
      Inc(Spare, BtnSize);

    if FScrollersVisible then
    begin
      Inc(Spare, 2*BtnSize);
      if FShowCloseButton then Inc(Spare, 2);
    end;

    case FTabPosition of
      sctpTop, sctpBottom:
        Dec(Result.Right, Spare);
      sctpLeft, sctpRight:
        Dec(Result.Bottom, Spare);
    end;
  end;

  if Result.Right < Result.Left then
    Result.Right := Result.Left;

  if Result.Bottom < Result.Top then
    Result.Bottom := Result.Top;

  if FVisibleTabCount > 0 then
  begin
    case FTabPosition of
      sctpTop:
        if Result.Bottom - Result.Top < 16 then
          Result.Bottom := Result.Top + 16;
      sctpBottom:
        if Result.Bottom - Result.Top < 16 then
          Result.Top := Result.Bottom - 16;
      sctpLeft:
        if Result.Right - Result.Left < 16 then
          Result.Right := Result.Left + 16;
      sctpRight:
        if Result.Right - Result.Left < 16 then
          Result.Left := Result.Right - 16;
    end;
  end;
end;

function TSCBaseTabControl.GetTabTextColor(Tab: TSCTabData): TColor;
var
  Index: Integer;
begin
  Result := Self.Font.Color;
  if Result = clNone then Result := clWindowText;

  if Tab <> nil then
  begin
    Index := GetActiveIndex;

    if not FUseTabColors and (Tab.Index <> Index) then
    begin
      Result := FTabColors.UnselectedText;
      if Result = clNone then Result := clWindowText;
    end else
    if FUseTabColors then
    begin
      Result := Tab.FontColor;

      if Result = clNone then
      begin
        if Tab.Index <> Index then
          Result := FTabColors.UnselectedText
        else
          Result := Self.Font.Color;

        if Result = clNone then Result := clWindowText;
      end;
    end;
  end;
end;

function TSCBaseTabControl.GetVisibleTabCount: Integer;
begin
  Result := 0;
end;

function TSCBaseTabControl.HitTest(const P: TPoint): TSCTabHitInfo;
var
  Rgn: HRGN;
  R, CR: TRect;
  I, Index: Integer;
  TabData: TSCTabData;
begin
  with Result do
  begin
    X := P.x;
    Y := P.y;
    Tab := -1;
    HitPos := scphNowhere;
  end;

  CR := ClientRect;

  if PtInRect(CR, P) then
  begin
    Result.HitPos := scphClient;

    if FShowCloseButton then
    begin
      R := GetCloseButtonRect;

      if not IsRectEmpty(R) and
        IntersectRect(R, R, CR) and PtInRect(R, P) then
      begin
        Result.HitPos := scphCloseButton;
        Exit;
      end;
    end;

    if FScrollersVisible then
    begin
      R := GetScrollerRect(False);

      if not IsRectEmpty(R) and
        IntersectRect(R, R, CR) and PtInRect(R, P) then
      begin
        Result.HitPos := scphRightScroll;
        Exit;
      end;

      R := GetScrollerRect(True);

      if not IsRectEmpty(R) and
        IntersectRect(R, R, CR) and PtInRect(R, P) then
      begin
        Result.HitPos := scphLeftScroll;
        Exit;
      end;
    end;

    if FDataList <> nil then
    begin
      Index := GetActiveIndex;

      if (Index > -1) and (Index < FDataList.Count) then
      begin
        TabData := FDataList[Index];

        if TabData.Visible and TabData.Showing then
        begin
          Rgn := TabData.Region;

          if (Rgn <> 0) and PtInRegion(Rgn, P.x, P.y) then
          begin
            with Result do
            begin
              Tab := Index;
              HitPos := scphTab;
            end;

            Exit;
          end;
        end;
      end;

      for I := FDataList.Count-1 downto 0 do
      begin
        TabData := FDataList[I];

        if TabData.Visible and TabData.Showing then
        begin
          Rgn := TabData.Region;

          if (Rgn <> 0) and PtInRegion(Rgn, P.x, P.y) then
          begin
            with Result do
            begin
              Tab := I;
              HitPos := scphTab;
            end;

            Exit;
          end;
        end;
      end;
    end;

    R := GetCardRect;
    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      Result.HitPos := scphCard;
      Exit;
    end;
  end;
end;

procedure TSCBaseTabControl.IndentChanged;
begin
  if FVisibleTabCount > 0 then
  begin
    UpdateTabs(False);
    UpdateTabs(True);
  end;
end;

procedure TSCBaseTabControl.InitializeHitTest(AHitInfo: PSCTabHitInfo);
begin
  with AHitInfo^ do
  begin
    X := -1;
    Y := -1;
    Tab := -1;
    Clicked := False;
    LeftButton := False;
    HitPos := scphNowhere;
  end;
end;

procedure TSCBaseTabControl.Loaded;
var
  Index: Integer;
begin
  try
    inherited Loaded;

    UpdateFontSize;
    UpdateTabs(True);

    SetTabIndex(-1);
    if FTabIndexDefault > -1 then
    begin
      SetTabIndex(FTabIndexDefault);

      Index := TabIndex;
      if Index > -1 then MakeTabVisible(Index, True);
    end;
  finally
    FControlLoaded := True;
  end;
end;

procedure TSCBaseTabControl.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Index, HitTab: Integer;
  OldDown, OldHot: TSCTabHitInfo;
  NeedsUpdate, Designing: Boolean;
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
  FHitInfo.LeftButton := Button = mbLeft;

  FHottrackInfo.x := X;
  FHottrackInfo.y := Y;

  Designing := IsDesigning;
  
  if Enabled or Designing then
  begin
    FHottrackInfo := HitTest(Point(X, Y));
    if Button = mbLeft then FHitInfo := FHottrackInfo;

    NeedsUpdate := not IsDesigning and
      ((FHottrack or (FStyle in [sctbOffice12, sctbOfficeXP])) and
      ((OldHot.Tab <> FHottrackInfo.Tab) or (FHitInfo.Tab = FTabIndex))) or
      ((Button = mbLeft) and (FHitInfo.HitPos in [scphCloseButton,
      scphLeftScroll, scphRightScroll]));

    if NeedsUpdate then
    begin
      UpdateBuffer(True);
      // Invalidate;
    end;

    if Button = mbLeft then
    begin
      if FHitInfo.HitPos in [scphLeftScroll, scphRightScroll] then
        ScrollTabs(FHitInfo.HitPos = scphLeftScroll)
      else
      if (FHitInfo.HitPos = scphTab) and (FHitInfo.Tab > -1) and
        (FDataList <> nil) and (FHitInfo.Tab < FDataList.Count) and
        (Designing or FDataList[FHitInfo.Tab].Enabled) then
      begin
        Index := GetActiveIndex;
        HitTab := FHitInfo.Tab;
        
        if IsDesigning then
        begin
          InitializeHitTest(@FHitInfo);
          InitializeHitTest(@FHottrackInfo);
        end;

        if TabStop and (HitTab = Index) and not Designing then
        begin
          SetFocus;
          if not Focused then
            Exit;
        end;

        SetTabIndex(HitTab);
        MakeTabVisible(HitTab, True);

        if HitTab = Index then
          TabClick;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  OldHot: TSCTabHitInfo;
begin
  inherited MouseMove(Shift, X, Y);

  if Enabled then
  begin
    OldHot := FHottrackInfo;

    InitializeHitTest(@FHottrackInfo);
    FHottrackInfo := HitTest(Point(X, Y));

    CheckMouseUpdate(OldHot);

    if FHitInfo.LeftButton and (FHitInfo.HitPos in
      [scphLeftScroll, scphRightScroll]) then
    begin
      if FHitInfo.HitPos in [scphLeftScroll, scphRightScroll] then
        ResumeScroll
      else
        PauseScroll;
    end;
  end;
end;

procedure TSCBaseTabControl.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  NeedsUpdate: Boolean;
  OldHit, OldHot: TSCTabHitInfo;
begin
  inherited MouseUp(Button, Shift, X, Y);

  OldHit := FHitInfo;
  OldHot := FHottrackInfo;

  StopScroll;

  InitializeHitTest(@FHitInfo);
  InitializeHitTest(@FHottrackInfo);

  if Enabled then
  begin
    FHitInfo.x := X;
    FHitInfo.y := Y;

    FHottrackInfo.x := X;
    FHottrackInfo.y := Y;

    FHottrackInfo := HitTest(Point(X, Y));

    NeedsUpdate := not IsDesigning and
      (FHottrack or (FStyle in [sctbOffice12, sctbOfficeXP]));

    if NeedsUpdate then
    begin
      UpdateBuffer(True);
      // Invalidate;
    end;

    if (FHottrackInfo.HitPos = OldHit.HitPos) and
      (OldHit.HitPos = scphCloseButton) and CanClose then
      CloseClick;
  end;
end;

procedure TSCBaseTabControl.Paint;
var
  Cl: TColor;
  CR, R: TRect;
begin
  if (FBufferUpdate = 0) and (FPaintBuffer <> nil) then
    Canvas.Draw(0, 0, FPaintBuffer)
  else begin
    inherited Paint;

    if FVisibleTabCount > 0 then
    begin
      R := GetBandRect;

      if not IsRectEmpty(R) then
      begin
        Cl := FBackgroundColor;
        if Cl = clNone then Cl := clBtnFace;

        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := Cl;

          FillRect(R);
        end;
      end;
    end;

    CR := GetCardRect;
    if not IsRectEmpty(CR) then
      DrawCardBackground(CR);

    DrawTabs;

    DrawScrollers(True);
    DrawScrollers(False);

    DrawCloseButton;

    if not IsRectEmpty(CR) then
    begin
      if FShowCardFrame and (FStyle = sctbEclipse) then
      begin
        R := FTabsRect;

        case FTabPosition of
          sctpTop, sctpBottom:
          begin
            R.Left := CR.Left;
            R.Right := CR.Right;

            if FTabPosition = sctpBottom then
              Dec(R.Top);
          end;
          sctpLeft, sctpRight:
          begin
            R.Top := CR.Top;
            R.Bottom := CR.Bottom;

            if FTabPosition = sctpRight then
              Dec(R.Left);
          end;
        end;

        if not IsRectEmpty(R) then
        begin
          Cl := GetFrameColor;
          scFrame3D(Canvas, R, Cl, Cl, 1, 0);
        end;
      end;

      DrawCard(CR);
    end;
  end;
end;

procedure TSCBaseTabControl.PaintTab(C: TCanvas; Tab: TSCTabData);
var
  SRgn: HRGN;
  R, Tr: TRect;
begin
  if (Tab <> nil) and Tab.Visible and Tab.Showing and
    (Tab.Index >= FFirstTab) and not IsRectEmpty(FTabsRect) then
  begin
    Tr := FTabsRect;
    R  := RectFromPoints(Tab.Points);

    if IsRectEmpty(R) or
      ((FTabPosition in [sctpBottom, sctpTop]) and ((R.Left < Tr.Left) or (R.Right > Tr.Right + 4))) or
      ((FTabPosition in [sctpLeft, sctpRight]) and ((R.Top < Tr.Top) or (R.Bottom > Tr.Bottom + 4))) then
      Exit;

    DrawShadow(Tab, R);
    DrawHottrack(Tab, R);

    SRgn := Tab.Region;
    if SRgn <> 0 then SelectClipRgn(C.Handle, Tab.Region);
    try
      DrawBackground(Tab, R);
      DrawImageAndText(Tab, R);

      case FStyle of
        sctbButton:
          DrawButtonTab(C, Tab);
        sctbDotNet:
          DrawDotNetTab(C, Tab);
        sctbDotNetFlat:
          DrawDotNetFlatTab(C, Tab);
        sctbEclipse:
          DrawEclipseTab(C, Tab);
        sctbFlatButton:
          DrawFlatButtonTab(C, Tab);
        sctbOffice12:
          DrawOffice12Tab(C, Tab);
        sctbOfficeXP:
          DrawOfficeXpTab(C, Tab);
        sctbNew:
          DrawNewTab(C, Tab);
        sctbNewX:
          DrawNewXTab(C, Tab);
        sctbXP:
          DrawXpTab(C, Tab);
        sctbWhidbey:
          DrawWhidbeyTab(C, Tab);
        sctbWin2K:
          DrawWin2KTab(C, Tab);
      end;
    finally
      if SRgn <> 0 then
        SelectClipRgn(Canvas.Handle, 0);
    end;
  end;
end;

function TSCBaseTabControl.RectFromPoints(Points: TSCTabPoints): TRect;
var
  P: TPoint;
  I: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if Points <> nil then
  begin
    P := Points[0];
    Result := Rect(P.x, P.y, P.x, P.y);

    for I := 1 to Length(Points)-1 do
    begin
      P := Points[I];

      if P.x < Result.Left then Result.Left := P.x;
      if P.x > Result.Right then Result.Right := P.x;
      if P.y < Result.Top then Result.Top := P.y;
      if P.y > Result.Bottom then Result.Bottom := P.y;
    end;
  end;
end;

procedure TSCBaseTabControl.SetAutoTabSize(Value: Boolean);
begin
  if FAutoTabSize <> Value then
  begin
    FAutoTabSize := Value;
    if not (IsLoading or IsReading) then
      UpdateTabs(True);
  end;
end;

procedure TSCBaseTabControl.SetBackgroundColor(Value: TColor);
begin
  if FBackgroundColor <> Value then
  begin
    FBackgroundColor := Value;
    if FVisibleTabCount > 0 then
      UpdateBuffer;
  end;
end;

procedure TSCBaseTabControl.SetButtonColor(Value: TColor);
begin
  if FButtonColor <> Value then
  begin
    FButtonColor := Value;
    if (FVisibleTabCount > 0) and FShowCloseButton and
      FScrollersVisible then
      UpdateBuffer(True);
  end;
end;

procedure TSCBaseTabControl.SetButtonIconColor(Value: TColor);
begin
  if FButtonIconColor <> Value then
  begin
    FButtonIconColor := Value;
    if (FVisibleTabCount > 0) and FShowCloseButton and
      FScrollersVisible then
      UpdateBuffer(True);
  end;
end;

procedure TSCBaseTabControl.SetDefaultTabSize(Value: Word);
begin
  if Value < 16 then Value := 16;

  if FDefaultTabSize <> Value then
  begin
    FDefaultTabSize := Value;
    if not FAutoTabSize and not (IsLoading or IsReading) then
      UpdateTabs(True);
  end;
end;

procedure TSCBaseTabControl.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    UpdateBuffer;
  end;
end;

procedure TSCBaseTabControl.SetHottrack(Value: Boolean);
var
  OldHot: Integer;
begin
  if FHottrack <> Value then
  begin
    FHottrack := Value;

    if not (IsDesigning or IsLoading or IsReading) then
    begin
      OldHot := FHottrackInfo.Tab;
      UpdateHottrackInfo;

      if (FVisibleTabCount > 0) and (OldHot <> FHottrackInfo.Tab) then
        UpdateBuffer(True);
    end;
  end;
end;

procedure TSCBaseTabControl.SetHottrackStyle(Value: TSCTabHottrackStyle);
begin
  if FHottrackStyle <> Value then
  begin
    FHottrackStyle := Value;
    if (FVisibleTabCount > 0) and (FHottrackInfo.Tab > -1) then
      UpdateBuffer(True);
  end;
end;

procedure TSCBaseTabControl.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;
  inherited SetIndent(Value);
end;

procedure TSCBaseTabControl.SetTabOrientation(Value: TSCTabOrientation);
begin
  if FTabOrientation <> Value then
  begin
    FTabOrientation := Value;
    
    if not (IsLoading or IsReading) then
    begin
      UpdateTabs(False);
      UpdateTabs(True);

      SetFirstTab(FTabIndex);
    end;
  end;
end;

procedure TSCBaseTabControl.SetTabPosition(Value: TSCTabPosition);
begin
  if FTabPosition <> Value then
  begin
    FTabPosition := Value;
    if not (IsLoading or IsReading) then
    begin
      UpdateTabs(True);
      SetFirstTab(FTabIndex);
    end;
  end;
end;

procedure TSCBaseTabControl.SetShowCardFrame(Value: Boolean);
begin
  if FShowCardFrame <> Value then
  begin
    FShowCardFrame := Value;
    if not (IsLoading or IsReading) then
    begin
      UpdateBuffer;
      Realign;
    end;
  end;
end;

procedure TSCBaseTabControl.SetShowCloseButton(Value: Boolean);
begin
  if FShowCloseButton <> Value then
  begin
    FShowCloseButton := Value;
    if not (IsLoading or IsReading) then
      UpdateTabs(False);
  end;
end;

procedure TSCBaseTabControl.SetShowFocusRect(Value: Boolean);
begin
  if FShowFocusRect <> Value then
  begin
    FShowFocusRect := Value;
    if HasFocus and (FTabIndex > -1) and (FVisibleTabCount > 0) then
      UpdateBuffer(True);
  end;
end;

procedure TSCBaseTabControl.SetStyle(Value: TSCTabStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    if not (IsLoading or IsReading) then
    begin
      UpdateHottrackInfo;
      UpdateTabs(True);

      SetFirstTab(FTabIndex);
    end;
  end;
end;

procedure TSCBaseTabControl.SetTabColors(Value: TSCTabColors);
begin
  FTabColors.Assign(Value);
end;

procedure TSCBaseTabControl.SetTabGradient(Value: TSCTabGradient);
begin
  if FTabGradient <> Value then
  begin
    FTabGradient := Value;
    if FVisibleTabCount > 0 then
      UpdateBuffer(True);
  end;
end;

procedure TSCBaseTabControl.SetTabIndex(Value: Integer);
var
  Allowed: Boolean;
begin
  if IsLoading or IsReading then
  begin
    FTabIndex := Value;
    Exit;
  end;

  if Value < -1 then Value := -1;
  Value := CheckVisible(Value);

  if FTabIndex <> Value then
  begin
    Allowed := True;
    Changing(Value, Allowed);

    if Allowed then
    begin
      FTabIndex := Value;
      
      TabIndexChanged;
      UpdateDesigner;
    end;
  end;
end;

procedure TSCBaseTabControl.SetUseTabColors(Value: Boolean);
begin
  if FUseTabColors <> Value then
  begin
    FUseTabColors := Value;
    if FVisibleTabCount > 0 then
      UpdateBuffer;
  end;
end;

procedure TSCBaseTabControl.StoreCalcValues;
begin
  FVisibleTabCount := GetVisibleTabCount;
  FTabSize := GetTabSize;

  if (FVisibleTabCount > 0) and (FTabSize < SC_TabsMinHeight) then
    FTabSize := SC_TabsMinHeight;

  UpdateTabRects;

  FScrollersVisible := GetScrollersVisible;
  FTabsRect := GetTabsRect;
end;

function TSCBaseTabControl.TabAtPos(const P: TPoint): Integer;
var
  Hit: TSCTabHitInfo;
begin
  Hit := HitTest(P);
  Result := Hit.Tab;
end;

procedure TSCBaseTabControl.TabClick;
begin
  if Assigned(FOnTabClick) then
    FOnTabClick(Self);
end;

procedure TSCBaseTabControl.TabIndexChanged;
begin
  UpdateTabs(False);
  DoTabIndexChanged;

  Change;
  if Assigned(FOnTabChange) then
    FOnTabChange(Self);
end;

procedure TSCBaseTabControl.CheckMouseUpdate(OldHot: TSCTabHitInfo);
var
  NeedsUpdate: Boolean;
begin
  if Enabled and not IsDesigning then
  begin
    NeedsUpdate := (FHottrack or (FStyle in [sctbOffice12, sctbOfficeXP])) and
      (OldHot.Tab <> FHottrackInfo.Tab);

    NeedsUpdate := NeedsUpdate or
      ((FHitInfo.HitPos = scphNowhere) and (OldHot.HitPos <> FHottrackInfo.HitPos) and
       ((OldHot.HitPos in [scphCloseButton, scphLeftScroll, scphRightScroll]) or
       (FHottrackInfo.HitPos in [scphCloseButton, scphLeftScroll, scphRightScroll])));

    NeedsUpdate := NeedsUpdate or
      ((FHitInfo.HitPos in [scphCloseButton, scphLeftScroll, scphRightScroll]) and
       ((OldHot.HitPos <> FHitInfo.HitPos) and (FHottrackInfo.HitPos = FHitInfo.HitPos)) or
       ((OldHot.HitPos = FHitInfo.HitPos) and (FHottrackInfo.HitPos <> FHitInfo.HitPos)));

    if NeedsUpdate then
    begin
      UpdateBuffer(True);
      // Invalidate;
    end;
  end;
end;

procedure TSCBaseTabControl.UpdateBuffer(OnlyTabs: Boolean);
var
  SR: Integer;
  BR, R: TRect;
  OldDC, Hnd: THandle;
begin
  if HandleAllocated and (FPaintBuffer <> nil) then
  begin
    if OnlyTabs then
    begin
      R := GetBandRect;
      BR := GetClientRect;

      case FTabPosition of
        sctpTop:
          BR.Bottom := R.Bottom;
        sctpBottom:
          BR.Top := R.Top;
        sctpLeft:
          BR.Right := R.Right;
        sctpRight:
          BR.Left := R.Left;
      end;

      R := BR;
      
      Inc(FBufferUpdate);
      try
        Hnd := FPaintBuffer.Canvas.Handle;
        OldDC := Canvas.Handle;
        try
          Canvas.Handle := Hnd;

          SR := IntersectClipRect(Hnd, R.Left, R.Top, R.Right, R.Bottom);
          try
            if SR <> NULLREGION then
              RedrawTabs;
          finally
            SelectClipRgn(Hnd, 0);
          end;
        finally
          Canvas.Handle := OldDC;
        end;
      finally
        Dec(FBufferUpdate);
      end;

      if FBufferUpdate = 0 then
        InvalidateRect(Self.Handle, @R, False);
    end else
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

      if FBufferUpdate = 0 then
        Invalidate;
    end;
  end;
end;

procedure TSCBaseTabControl.UpdateFontSize;
begin
  FTextHeight := 8;
  if HandleAllocated then
    with Canvas do
    begin
      Font := Self.Font;
      FTextHeight := TextHeight('WQ');
      if FTextHeight < 8 then FTextHeight := 8;
    end;
end;

procedure TSCBaseTabControl.UpdateTabRects;
begin
  //
end;

procedure TSCBaseTabControl.UpdateTabs(Realign: Boolean = False);
begin
  if not IsDestroying then
  begin
    StoreCalcValues;

    FDataList.Clear;
    FillDataList;

    StoreCalcValues;
    UpdateBuffer;

    // Invalidate;

    SetTabIndex(GetActiveIndex);
    if Realign then
      Self.Realign;
  end;
end;

procedure TSCBaseTabControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TSCBaseTabControl.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TSCBaseTabControl.WMNCHitTest(var Message: TWMNCHitTest);
var
  P: TPoint;
begin
  DefaultHandler(Message);

  if IsDesigning then
  begin
    P := SmallPointToPoint(Message.Pos);
    FHottrackInfo := HitTest(Self.ScreenToClient(P));
  end;
end;

procedure TSCBaseTabControl.WMSize(var Message: TWMSize);
begin
  inherited;

  if FPaintBuffer <> nil then
  begin
    FPaintBuffer.Width := ClientWidth;
    FPaintBuffer.Height := ClientHeight;

    UpdateBuffer;
  end;

  UpdateTabs(True);
end;

procedure TSCBaseTabControl.WMTimer(var Message: TWMTimer);
var
  Index: Integer;
begin
  inherited;

  if HandleAllocated and not IsDesigning and
    Scrolling and (Message.TimerID = SC_TAB_REPEATTIMERID) then
  begin
    if FScrollTimer <> -1 then
      KillTimer(Handle, FScrollTimer);

    if Enabled then
    begin
      FScrollTimer := SetTimer(Handle, SC_TAB_REPEATTIMERID,
        SC_TAB_REPEATTIME, nil);
      FScrolling := FScrollTimer <> -1;

      Index := FFirstTab;
      if FScrollingLeft then
        Dec(Index)
      else Inc(Index);

      SetFirstTab(Index);
    end;
  end;
end;

procedure TSCBaseTabControl.CalculateTabSize(Index: Integer;
  var W, H: Integer);
begin
  W := 0; H := 0;
end;

function TSCBaseTabControl.GetBorderIndent: Integer;
begin
  Result := 2;
  if FShowCardFrame then
  begin
    if FStyle = sctbWin2K then
      Result := 4
    else
    if FStyle in [sctbDotNet, sctbDotNetFlat, sctbNew,
      sctbNewX, sctbOffice12, sctbXP, sctbWhidbey] then
      Result := 3;
  end;
end;

procedure TSCBaseTabControl.DrawCardBackground(R: TRect);
var
  Cl, C2: TColor;
  Index: Integer;
begin
  Index := GetActiveIndex;

  if Index > -1 then
  begin
    Cl := GetDefaultBackColor;

    if (Index > -1) and (Index < FDataList.Count) and FUseTabColors then
    begin
      Cl := FDataList[Index].Color;
      if Cl = clNone then
        Cl := GetDefaultBackColor;
    end;

    if Cl = clNone then Cl := clBtnFace;

    if Cl <> Self.Color then
    begin
      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R);
      end;
    end;

    if FStyle = sctbOffice12 then
    begin
      if FShowCardFrame then
        InflateRect(R, -1, -1);

      C2 := BlendedColor(Cl, 12, 12, 12, True);
      scDrawGradient(Canvas, R, scgTopToBottom, Cl, C2);
    end;
  end;
end;

procedure TSCBaseTabControl.UpdateHottrackInfo;
var
  P: TPoint;
  OldHot: TSCTabHitInfo;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);

  OldHot := FHottrackInfo;
  InitializeHitTest(@FHottrackInfo);

  FHottrackInfo.X := P.x;
  FHottrackInfo.Y := P.y;

  if not IsDesigning then
    FHottrackInfo := HitTest(P);

  CheckMouseUpdate(OldHot);
end;

function TSCBaseTabControl.GetFirstShowingTab: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FDataList <> nil then
    for I := 0 to FDataList.Count-1 do
      if FDataList[I].Visible and FDataList[I].Showing then
      begin
        Result :=  I;
        Break;
      end;
end;

function TSCBaseTabControl.GetFirstVisibleTab: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FDataList <> nil then
    for I := 0 to FDataList.Count-1 do
      if FDataList[I].Visible and FDataList[I].Showing then
      begin
        Result :=  I;
        Break;
      end;
end;

function TSCBaseTabControl.GetLastShowingTab: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FDataList <> nil then
    for I := 0 to FDataList.Count-1 do
      if FDataList[I].Visible and FDataList[I].Showing then
        Result := I;
end;

function TSCBaseTabControl.GetLastVisibleTab: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FDataList <> nil then
    for I := 0 to FDataList.Count-1 do
      if FDataList[I].Visible then
        Result := I;
end;

procedure TSCBaseTabControl.MakeTabVisible(Index: Integer;
  UpdateAfter: Boolean);
var
  CR, TR: TRect;
  TabData: TSCTabData;
  I, NewIndex, L, R, T, B: Integer;
begin
  CR := FTabsRect;
  if not IsRectEmpty(CR) and (Index > -1) and
    (FDataList <> nil) and (Index < FDataList.Count) then
  begin
    TabData := FDataList[Index];

    if TabData.Visible and not TabData.Showing then
    begin
      NewIndex := Index;
      TR := TabData.TabRect;

      L := TR.Left;
      R := TR.Right;

      T := TR.Top;
      B := TR.Bottom;

      for I := Index-1 downto 0 do
      begin
        TabData := FDataList[I];
        if not TabData.Visible then
          Continue;

        TR := TabData.TabRect;
        
        if FTabPosition in [sctpTop, sctpBottom] then
        begin
          if R - L >= CR.Right - CR.Left then
            Break;

          NewIndex := I + 1;
          L := TR.Left;
        end else
        begin
          if B - T >= CR.Bottom - CR.Top then
            Break;

          NewIndex := I + 1;
          T := TR.Top;
        end;
      end;

      NewIndex := ArrangeFirstTab(NewIndex);

      if NewIndex <> FFirstTab then
      begin
        FFirstTab := NewIndex;
        if UpdateAfter then UpdateTabs(False);
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.PauseScroll;
begin
  if FScrolling and (FScrollTimer <> -1) and CanScroll then
    FScrollingPaused := True;
end;

procedure TSCBaseTabControl.ResumeScroll;
begin
  FScrollingPaused := False;
end;

procedure TSCBaseTabControl.StopScroll;
begin
  FScrolling := False;
  FScrollingLeft := False;
  FScrollingPaused := False;

  if HandleAllocated and (FScrollTimer <> -1) then
  begin
    if HandleAllocated then
      KillTimer(Handle, FScrollTimer);

    FScrollTimer := -1;
    UpdateBuffer(True);
  end;
end;

procedure TSCBaseTabControl.ScrollTabs(Left: Boolean);
var
  Index: Integer;
begin
  if HandleAllocated and CanScroll and
    not FScrolling or FScrollingPaused then
  begin
    FScrollingLeft := Left;

    if ScrollPaused then
    begin
      ResumeScroll;
      Exit;
    end;

    if not Scrolling then
    begin
      StopScroll;

      if Enabled then
      begin
        FScrollingLeft := Left;

        Index := FFirstTab;
        if FScrollingLeft then
          Dec(Index)
        else Inc(Index);

        SetFirstTab(Index);

        if HandleAllocated and not IsDesigning then
        begin
          FScrollTimer := SetTimer(Handle, SC_TAB_REPEATTIMERID,
            GetDoubleClickTime, nil);
          FScrolling := FScrollTimer <> -1;
        end;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.CloseClick;
begin
  DoCloseClick;
end;

procedure TSCBaseTabControl.DoCloseClick;
begin
  //
end;

procedure TSCBaseTabControl.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  UpdateHottrackInfo;
  ResumeScroll;
end;

procedure TSCBaseTabControl.CMMouseLeave(var Message: TMessage);
var
  OldHot: TSCTabHitInfo;
begin
  inherited;

  if not IsDesigning then
  begin
    OldHot := FHottrackInfo;
    InitializeHitTest(@FHottrackInfo);

    CheckMouseUpdate(OldHot);

    PauseScroll;
  end;
end;

procedure TSCBaseTabControl.StopTracking;
begin
  inherited StopTracking;

  InitializeHitTest(@FHitInfo);
  UpdateHottrackInfo;
end;

function TSCBaseTabControl.GetVisibleIndexOf(Index: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  if (FDataList <> nil) and (Index > -1) and (Index < FDataList.Count) and
    FDataList[Index].Visible and FDataList[Index].Showing then
    for I := 0 to FDataList.Count-1 do
    begin
      if FDataList[I].Visible and FDataList[I].Showing then
        Inc(Result);

      if I = Index then
        Exit;
    end;
end;

function TSCBaseTabControl.GetMaximumTabSize: Integer;
var
  BR, R: TRect;
  AIndent, BtnSize: Integer;
begin
  BR := GetBandRect;
  AIndent := GetIndent;

  if AIndent > 0 then
  begin
    if FTabPosition in [sctpTop, sctpBottom] then
      Inc(BR.Left, AIndent)
    else
      Inc(BR.Top, AIndent);
  end;

  if FTabPosition in [sctpTop, sctpBottom] then
    Inc(BR.Left, 2)
  else
    Inc(BR.Top, 2);

  if FShowCloseButton then
  begin
    R := GetCloseButtonRect;

    BtnSize := R.Right - R.Left;
    if FTabPosition in [sctpLeft, sctpRight] then
      BtnSize := R.Bottom - R.Top;

    if BtnSize > 3 then
    begin
      if FTabPosition in [sctpTop, sctpBottom] then
        Dec(BR.Right, BtnSize + 2)
      else
        Dec(BR.Bottom, BtnSize + 2);
    end;
  end;

  if FScrollersVisible then
  begin
    R := GetScrollerRect(False);

    BtnSize := R.Right - R.Left;
    if FTabPosition in [sctpLeft, sctpRight] then
      BtnSize := R.Bottom - R.Top;

    if BtnSize > 3 then
    begin
      if FTabPosition in [sctpTop, sctpBottom] then
        Dec(BR.Right, 2*BtnSize + 2)
      else
        Dec(BR.Bottom, 2*BtnSize + 2);
    end;
  end;

  if FTabPosition in [sctpTop, sctpBottom] then
    Result := BR.Right - BR.Left
  else
    Result := BR.Bottom - BR.Top;

  if Result < 0 then Result := 0;
end;

procedure TSCBaseTabControl.ImageListChange(Sender: TObject);
begin
  inherited ImageListChange(Sender);
  UpdateTabs(True);
end;

procedure TSCBaseTabControl.SetFirstTab(Value: Integer);
begin
  Value := ArrangeFirstTab(Value);

  if FFirstTab <> Value then
  begin
    FFirstTab := Value;
    UpdateTabs(False);

    FirstTabChanged;
  end;
end;

procedure TSCBaseTabControl.FirstTabChanged;
begin
  //
end;

function TSCBaseTabControl.ArrangeFirstTab(Value: Integer): Integer;
var
  R, BR: TRect;
  TabData: TSCTabData;
  TabRectEmpty: Boolean;
  TabMin, TabMax, I, AIndent,
  Offset, LastIndex, FirstVisible: Integer;
begin
  Result := Value;
  LastIndex := 0;

  BR := GetTabsRect;
  OffsetRect(BR, -BR.Left, -BR.Top);

  TabRectEmpty := IsRectEmpty(BR);

  AIndent := GetIndent;

  Offset := 0;
  if (FFirstTab > 0) and (FFirstTab < FDataList.Count) then
  begin
    R := FDataList[FFirstTab].TabRect;

    FirstVisible := GetFirstVisibleTab;
    if FTabPosition in [sctpTop, sctpBottom] then
      Offset := R.Left - FDataList[FirstVisible].TabRect.Left
    else
      Offset := R.Top - FDataList[FirstVisible].TabRect.Top;

    if (FTabIndex <> FirstVisible) and not (FStyle in ButtonStyles) then
      Inc(Offset, 2);

    Inc(Offset, AIndent);
  end;

  TabMin := MaxInt;
  TabMax := MaxInt;

  for I := FDataList.Count-1 downto 0 do
  begin
    TabData := FDataList[I];

    R := TabData.TabRect;
    if not TabData.Visible then
      Continue;

    if not TabRectEmpty then
    begin
      if FTabPosition in [sctpTop, sctpBottom] then
      begin
        if R.Right - R.Left < 1 then
          Continue;

        OffsetRect(R, Offset, 0);

        if TabMax = MaxInt then TabMax := R.Right;
        if R.Left < TabMin then TabMin := R.Left;

        if TabMax - TabMin > BR.Right then
          Break;
      end else
      if R.Bottom - R.Top > 0 then
      begin
        OffsetRect(R, 0, Offset);

        if TabMax = MaxInt then TabMax := R.Bottom;
        if R.Top < TabMin then TabMin := R.Top;

        if TabMax - TabMin > BR.Bottom then
          Break;
      end;
    end;

    LastIndex := I;
  end;

  if Result > LastIndex then
    Result := LastIndex;

  if Result < 0 then Result := 0;
end;

procedure TSCBaseTabControl.SetImageSpacing(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if Value > 100 then Value := 100;

  if FImageSpacing <> Value then
  begin
    FImageSpacing := Value;
    
    if (FVisibleTabCount > 0) and not (IsLoading or IsReading) then
    begin
      UpdateHottrackInfo;
      UpdateTabs(True);
    end;
  end;
end;

function TSCBaseTabControl.Scrolling: Boolean;
begin
  Result := FScrolling and (FScrollTimer <> -1) and
    CanScroll and MouseInControl;
end;

function TSCBaseTabControl.CanScroll: Boolean;
begin
  Result := Enabled;
end;

function TSCBaseTabControl.ScrollPaused: Boolean;
begin
  Result := not (FScrolling and Enabled and MouseInControl) and
    (FScrollTimer <> -1) and CanScroll;
end;

procedure TSCBaseTabControl.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
  if FShowFocusRect and (FVisibleTabCount > 0) then
    UpdateBuffer(True);
end;

function TSCBaseTabControl.CanClose: Boolean;
begin
  Result := True;
  if Assigned(FOnTabClose) then FOnTabClose(Self, Result);
end;

procedure TSCBaseTabControl.Changing(NewIndex: Integer;
  var Allowed: Boolean);
begin
  Allowed := True;
  if FControlLoaded and Assigned(FOnTabChanging) then
    FOnTabChanging(Self, NewIndex, Allowed);
end;

procedure TSCBaseTabControl.ActiveTabMoved(Index: Integer);
begin
  //
end;

procedure TSCBaseTabControl.DestroyActiveTab;
begin
  //
end;

procedure TSCBaseTabControl.CloseActiveTab;
begin
  if (FTabIndex <> -1) and CanClose then
    DestroyActiveTab;
end;

procedure TSCBaseTabControl.HideAllTabs;
begin
  //
end;

procedure TSCBaseTabControl.ShowAllTabs;
begin
  //
end;

procedure TSCBaseTabControl.SpacingChanged;
begin
  inherited SpacingChanged;
  if HandleAllocated and not (IsLoading or IsReading) then
  begin
    UpdateHottrackInfo;
    UpdateTabs(True);

    SetFirstTab(FTabIndex);
  end;
end;

function TSCBaseTabControl.GetDataList: TSCDataList;
begin
  Result := FDataList;
end;

function TSCBaseTabControl.GetTabImage(Tab: TSCTabData): TImageIndex;
var
  ImgList: TCustomImageList;
begin
  Result := -1;
  ImgList := GetImages;

  if (ImgList <> nil) and (ImgList.Count > 0) then
  begin
    Result := Tab.ImageIndex;
    if not (Enabled and Tab.Enabled) then
    begin
      Result := Tab.DisabledImage;
      if (Result < 0) or (Result > ImgList.Count-1) then
        Result := Tab.ImageIndex;
    end else
    if not IsDesigning and FHottrack and (Tab.Index = FHottrackInfo.Tab) and
      (not FHitInfo.Clicked or ((FHitInfo.Tab = Tab.Index) and
      (FHitInfo.HitPos in [scphNowhere, scphTab]))) then
    begin
      Result := Tab.HotImage;
      if (Result < 0) or (Result > ImgList.Count-1) then
        Result := Tab.ImageIndex;
    end;
  end;
end;

function TSCBaseTabControl.GetTabFontColor(Tab: TSCTabData): TColor;
var
  Index: Integer;
  HotCl, Cl: TColor;
begin
  Result := Tab.FontColor;
  if Result = clNone then
  begin
    Result := Self.Font.Color;
    if Result = clNone then Result := clWindowText;
  end;

  if not (Enabled and Tab.Enabled) then
    Result := clGrayText
  else begin
    Index := GetActiveIndex;

    if (FStyle = sctbEclipse) and (Tab.Index = Index) then
    begin
      Cl := clHighlightText;
      Result := GetBtnHighlightOf(Cl);
    end else
    if IsDesigning then
    begin
      if FStyle = sctbOfficeXP then
        Result := clWindowText;
    end else
    if FStyle = sctbOfficeXP then
    begin
      Result := clWindowText;
      if (FHottrackInfo.Tab = Tab.Index) or
        ((FHitInfo.Tab = Tab.Index) and (FHottrackInfo.Tab = Tab.Index)) then
        Result := clHighlightText;
    end else
    begin
      if Index <> Tab.Index then
      begin
        Result := Self.FTabColors.UnselectedText;

        if Result = clNone then
        begin
          Result := Self.Font.Color;
          if Result = clNone then Result := clWindowText;
        end;
      end;

      if FHottrack and (Tab.Index = FHottrackInfo.Tab) and
        (FHottrackStyle in [schsText, schsTabAndText]) and
        (not FHitInfo.Clicked or ((FHitInfo.Tab = Tab.Index) and
        (FHitInfo.HitPos = scphTab))) then
      begin
        HotCl := Self.FTabColors.HottrackText;
        if HotCl = clNone then
          HotCl := Result;

        Result := HotCl;
      end;
    end;
  end;
end;

procedure TSCBaseTabControl.SetMaximumWidth(Value: Integer);
begin
  if Value < -1 then Value := -1;

  if FMaximumWidth <> Value then
  begin
    FMaximumWidth := Value;

    UpdateTabs(False);
    UpdateTabs(True);
  end;
end;

procedure TSCBaseTabControl.SetEllipsisType(Value: TSCTabEllipsisType);
begin
  if FEllipsisType <> Value then
  begin
    FEllipsisType := Value;
    if FVisibleTabCount > 0 then
      UpdateBuffer(True);
  end;
end;

procedure TSCBaseTabControl.SetAlignment(Value: TLeftRight);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    if FVisibleTabCount > 0 then
      UpdateBuffer(True);
  end;
end;

function TSCBaseTabControl.GetIndent: Integer;
begin
  Result := Self.Indent;
  if Result < 0 then Result := 0;

  if FStyle = sctbOffice12 then
    Inc(Result, 3)
  else
  if FStyle = sctbWhidbey then
    Inc(Result, 8);
end;

procedure TSCBaseTabControl.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('TabIndexDefault', ReadActiveTab, WriteActiveTab, True);
end;

procedure TSCBaseTabControl.ReadActiveTab(Reader: TReader);
begin
  FTabIndexDefault := StrToIntDef(Reader.ReadString, -1);
end;

procedure TSCBaseTabControl.WriteActiveTab(Writer: TWriter);
begin
  Writer.WriteString(IntToStr(FTabIndex));
end;

procedure TSCBaseTabControl.CreateWnd;
var
  Index: Integer;
begin
  inherited CreateWnd;

  if FControlLoaded and (FTabIndexDefault > -1) then
  begin
    Index := FTabIndexDefault;
    FTabIndexDefault := -1;

    SetTabIndex(Index);
  end;
end;

procedure TSCBaseTabControl.UpdateDesigner;
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

function TSCBaseTabControl.GetTabIndexDefault: Integer;
begin
  Result := FTabIndexDefault;
end;

procedure TSCBaseTabControl.SetTabIndexDefault(Value: Integer);
begin
  if Value < -1 then Value := -1;
  FTabIndexDefault := Value;
end;

function TSCBaseTabControl.GetControlLoaded: Boolean;
begin
  Result := FControlLoaded;
end;

procedure TSCBaseTabControl.SetControlLoaded(Value: Boolean);
begin
  FControlLoaded := Value;
end;

procedure TSCBaseTabControl.DrawEclipseTab(C: TCanvas; Tab: TSCTabData);
var
  Cl, C1: TColor;
  ARect, R2, R3: TRect;
  L, R, T, B, Index: Integer;
begin
  ARect := Tab.TabRect;
  if (FTabPosition = sctpBottom) and (FTabOrientation = sctoVertical) then
    OffsetRect(ARect, 0, -1);

  if not IsRectEmpty(ARect) then
  begin
    Index := GetActiveIndex;
    Cl := GetFrameColor;

    R2 := ARect;

    case FTabPosition of
      sctpTop, sctpBottom:
      begin
        Dec(R2.Left);
        if Tab.Index = FFirstTab then
          Inc(R2.Left);

        if FTabPosition = sctpBottom then
        begin
          OffsetRect(R2, 0, -1);
          Inc(R2.Bottom);
        end;
      end;
      sctpLeft, sctpRight:
      begin
        Dec(R2.Top);
        if Tab.Index = FFirstTab then
          Inc(R2.Top);

        if FTabPosition = sctpRight then
        begin
          OffsetRect(R2, -1, 0);
          Inc(R2.Right);
        end;
      end;
    end;

    if Index = Tab.Index then
    begin
      R3 := R2;
      InflateRect(R3, -1, -1);

      C1 := GetBtnHighlightOf(Cl);
      scFrame3D(C, R3, C1, C1, 1, 0);

      R3 := R2;
      scFrame3D(C, R3, Cl, Cl, 1, 0);

      if Tab.Index = FFirstTab then
      begin
        with C do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := Cl;
        end;

        case FTabPosition of
          sctpTop, sctpBottom:
          begin
            C.MoveTo(R2.Left, R2.Top);
            C.LineTo(R2.Left, R2.Bottom);
          end;
          sctpLeft, sctpRight:
          begin
            C.MoveTo(R2.Left, R2.Top);
            C.LineTo(R2.Right, R2.Top);
          end;
        end;
      end;
    end else
    if Tab.Index <> GetLastVisibleTab then
    begin
      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := Cl;
      end;

      case FTabPosition of
        sctpTop, sctpBottom:
        begin
          Dec(R2.Right);

          if FTabPosition = sctpTop then
          begin
            T := R2.Top;

            B := R2.Top + Round((R2.Bottom - R2.Top) / 2);
            if Tab.Index = GetPrevVisibleTab(TabIndex) then
              B := R2.Bottom;
          end else
          begin
            B := R2.Bottom;

            T := R2.Top + Round((R2.Bottom - R2.Top) / 2);
            if Tab.Index = GetPrevVisibleTab(TabIndex) then
              T := R2.Top;
          end;

          C.MoveTo(R2.Right, T);
          C.LineTo(R2.Right, B);
        end;
        sctpLeft, sctpRight:
        begin
          Dec(R2.Bottom);
          
          if FTabPosition = sctpLeft then
          begin
            L := R2.Left;

            R := R2.Left + Round((R2.Right - R2.Left) / 2);
            if Tab.Index = GetPrevVisibleTab(TabIndex) then
              R := R2.Right;
          end else
          begin
            R := R2.Right;

            L := R2.Left + Round((R2.Right - R2.Left) / 2);
            if Tab.Index = GetPrevVisibleTab(TabIndex) then
              L := R2.Left;
          end;

          C.MoveTo(L, R2.Bottom);
          C.LineTo(R, R2.Bottom);
        end;
      end;
    end;
  end;
end;

function TSCBaseTabControl.GetNextVisibleTab(Index: Integer): Integer;
var
  I: Integer;
  AData: TSCTabData;
  ADataList: TSCDataList;
begin
  Result := -1;

  if Index > -1 then
  begin
    ADataList := GetDataList;

    if (ADataList <> nil) and (Index < ADataList.Count) then
      for I := Index + 1 to ADataList.Count-1 do
      begin
        AData := ADataList[I];
        if AData.Visible then
        begin
          Result := I;
          Break;
        end;
      end;
  end;
end;

function TSCBaseTabControl.GetPrevVisibleTab(Index: Integer): Integer;
var
  I: Integer;
  AData: TSCTabData;
  ADataList: TSCDataList;
begin
  Result := -1;

  if Index > 0 then
  begin
    ADataList := GetDataList;

    if (ADataList <> nil) and (Index < ADataList.Count) then
      for I := Index - 1 downto 0 do
      begin
        AData := ADataList[I];
        if AData.Visible then
        begin
          Result := I;
          Break;
        end;
      end;
  end;
end;

procedure TSCBaseTabControl.DrawEclipseCard(R: TRect);
var
  Pts: array[0..3] of TPoint;
begin
  if FShowCardFrame then
  begin
    case FTabPosition of
      sctpTop:
      begin
        Pts[0].x := R.Left;
        Pts[0].y := R.Top;
        Pts[1].x := R.Left;
        Pts[1].y := R.Bottom-1;
        Pts[2].x := R.Right-1;
        Pts[2].y := R.Bottom-1;
        Pts[3].x := R.Right-1;
        Pts[3].y := R.Top-1;
      end;
      sctpBottom:
      begin
        Pts[0].x := R.Left;
        Pts[0].y := R.Bottom;
        Pts[1].x := R.Left;
        Pts[1].y := R.Top;
        Pts[2].x := R.Right-1;
        Pts[2].y := R.Top;
        Pts[3].x := R.Right-1;
        Pts[3].y := R.Bottom;
      end;
      sctpLeft:
      begin
        Pts[0].x := R.Left;
        Pts[0].y := R.Top;
        Pts[1].x := R.Right-1;
        Pts[1].y := R.Top;
        Pts[2].x := R.Right-1;
        Pts[2].y := R.Bottom-1;
        Pts[3].x := R.Left-1;
        Pts[3].y := R.Bottom-1;
      end;
      sctpRight:
      begin
        Pts[0].x := R.Right;
        Pts[0].y := R.Top;
        Pts[1].x := R.Left;
        Pts[1].y := R.Top;
        Pts[2].x := R.Left;
        Pts[2].y := R.Bottom-1;
        Pts[3].x := R.Right;
        Pts[3].y := R.Bottom-1;
      end;
    end;

    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Color := GetFrameColor;

      Polyline(Pts);
    end;
  end;
end;

procedure TSCBaseTabControl.RedrawTabs;
var
  Cl: TColor;
  CR, BR, R: TRect;
begin
  if HandleAllocated then
  begin
    BR := GetBandRect;
    R := GetClientRect;

    case FTabPosition of
      sctpTop:
        R.Bottom := BR.Bottom;
      sctpBottom:
        R.Top := BR.Top;
      sctpLeft:
        R.Right := BR.Right;
      sctpRight:
        R.Left := BR.Left;
    end;

    if not IsRectEmpty(R) then
      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := GetDefaultBackColor;
        FillRect(R);
      end;

    if FVisibleTabCount > 0 then
    begin
      if not IsRectEmpty(BR) then
      begin
        Cl := FBackgroundColor;
        if Cl = clNone then Cl := clBtnFace;

        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := Cl;

          FillRect(BR);
        end;
      end;
    end;

    DrawTabs;

    DrawScrollers(True);
    DrawScrollers(False);

    DrawCloseButton;

    CR := GetCardRect;
    if not IsRectEmpty(CR) then
    begin
      if FShowCardFrame and (FStyle = sctbEclipse) then
      begin
        R := FTabsRect;

        case FTabPosition of
          sctpTop, sctpBottom:
          begin
            R.Left := CR.Left;
            R.Right := CR.Right;

            if FTabPosition = sctpBottom then
              Dec(R.Top);
          end;
          sctpLeft, sctpRight:
          begin
            R.Top := CR.Top;
            R.Bottom := CR.Bottom;

            if FTabPosition = sctpRight then
              Dec(R.Left);
          end;
        end;

        if not IsRectEmpty(R) then
        begin
          Cl := GetFrameColor;
          scFrame3D(Canvas, R, Cl, Cl, 1, 0);
        end;
      end;

      DrawCard(CR);
    end;
  end;
end;

{ TSCCustomTabControl }

procedure TSCCustomTabControl.CalculateTabSize(Index: Integer; var W,
  H: Integer);
var
  TextH, TbSize,
  ImageCount, ImageW, ImageH: Integer;
  TabData: TSCTabItem;
  ValidImage: Boolean;
  ImgList: TCustomImageList;
begin
  W := 0;
  H := 0;

  if (Index > -1) and (FTabs <> nil) and (Index < FTabs.Count) then
  begin
    TabData := FTabs[Index];

    if TabData.Visible then
    begin
      ImageW := 0;
      ImageH := 0;

      ValidImage := False;
      ImgList := GetImages;

      if ImgList <> nil then
      begin
        ImageCount := ImgList.Count;

        if ((TabData.ImageIndex > -1) and (TabData.ImageIndex < ImageCount)) or
          ((TabData.HotImage > -1) and (TabData.HotImage < ImageCount)) or
          ((TabData.DisabledImage > -1) and (TabData.DisabledImage < ImageCount)) then
        begin
          ValidImage := True;

          with ImgList do
          begin
            ImageW := Width;
            ImageH := Height;
          end;

          if ImageW > 0 then Inc(ImageW, 2);
          if ImageH > 0 then Inc(ImageH, 2);
        end;
      end;

      TextH := FTextHeight + 8;

      TbSize := FDefaultTabSize;
      if FAutoTabSize then
        TbSize := Canvas.TextWidth(TabData.Caption) + 8;

      if FTabPosition in [sctpTop, sctpBottom] then
      begin
        if FTabOrientation in [sctoDefault, sctoHorizontal] then
        begin
          H := TextH;
          if ValidImage then
            Inc(TbSize, ImageW + 4);

          W := TbSize;
          if W < 24 then W := 24;

          if ImageW > 0 then
            Inc(W, FImageSpacing);

          if (MaximumWidth > -1) and (W > MaximumWidth) then
            W := MaximumWidth;
        end else
        begin
          W := TextH;
          if ValidImage then
            Inc(TbSize, ImageW + 4);

          H := TbSize;
          if H < 24 then H := 24;

          if ImageH > 0 then
            Inc(H, FImageSpacing);

          if (MaximumWidth > -1) and (H > MaximumWidth) then
            H := MaximumWidth;
        end;

        Inc(W, 4);
        if FStyle = sctbNew then
          Inc(W, 8)
        else
        if FStyle = sctbNewX then
          Inc(W, H)
        else
        if FStyle = sctbWhidbey then
          Inc(W, H + 2);

        if H < SC_TabsMinHeight then
          H := SC_TabsMinHeight;
      end else
      begin
        if FTabOrientation in [sctoDefault, sctoVertical] then
        begin
          W := TextH;
          if ValidImage then
            Inc(TbSize, ImageH + 4);

          H := TbSize;
          if H < 24 then H := 24;

          if ImageH > 0 then
            Inc(H, FImageSpacing);

          if (MaximumWidth > -1) and (H > MaximumWidth) then
            H := MaximumWidth;
        end else
        begin
          H := TextH;
          if ValidImage then
            Inc(TbSize, ImageW + 4);

          W := TbSize;
          if W < 24 then W := 24;

          if ImageW > 0 then
            Inc(W, FImageSpacing);

          if (MaximumWidth > -1) and (W > MaximumWidth) then
            W := MaximumWidth;
        end;

        Inc(H, 4);
        if FStyle = sctbNew then
          Inc(H, 8)
        else
        if FStyle = sctbNewX then
          Inc(H, W)
        else
        if FStyle = sctbWhidbey then
          Inc(H, W + 2);

        if W < SC_TabsMinHeight then
          W := SC_TabsMinHeight;
      end;
    end;
  end;
end;

constructor TSCCustomTabControl.Create(AOwner: TComponent);
begin
  FTabs := TSCTabItems.Create(Self);
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls];
end;

destructor TSCCustomTabControl.Destroy;
begin
  FreeAndNil(FTabs);
  inherited Destroy;
end;

procedure TSCCustomTabControl.DoCloseClick;
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

procedure TSCCustomTabControl.FillDataList;
var
  R, Tr: TRect;
  Page: TSCTabItem;
  Pts1: TSCTabPoints;
  RectEmpty: Boolean;
  TabData: TSCTabData;
  I, J, Index: Integer;
  DataList: TSCDataList;
  Pts2: array[0..9] of TPoint;
begin
  DataList := GetDataList;

  if DataList <> nil then
  begin
    DataList.Clear;

    if (FTabs <> nil) and (FTabs.Count > 0) then
    begin
      UpdateTabRects;

      Tr := FTabsRect;

      Index := FTabIndex;
      if (Index > -1) and ((Index > FTabs.Count-1) or
        not FTabs[Index].Visible) then
        Index := -1;

      for I := 0 to FTabs.Count-1 do
      begin
        Page := FTabs[I];
        if (Index = -1) and Page.Visible then
          Index := I;

        R := Page.FTabRect;

        TabData := DataList.Add;
        TabData.Assign(Page);
        TabData.TabRect := R;

        FTabs[I].FShowing := True;

        TabData.Showing := True;
        TabData.Index   := I;
        TabData.TabItem := Page;
      end;

      UpdateTabRects;

      for I := 0 to FTabs.Count-1 do
      begin
        Page := FTabs[I];
        Page.FShowing := False;

        R := Page.FTabRect;
        TabData := DataList[I];

        TabData.Showing := False;
        TabData.TabRect := R;

        TabData.SetRegion(0);
        TabData.SetPoints(GetTabPoints(R, False, 2, 0));

        SetLength(Pts1, 0);
        Pts1 := GetTabPoints(R, True, 2, 0);

        if Length(Pts1) > 2 then
        begin
          for J := 0 to Length(Pts1)-1 do
            Pts2[J] := Pts1[J];

          TabData.SetRegion(CreatePolygonRgn(Pts2, Length(Pts1), WINDING));
        end;
      end;

      R := FTabsRect;

      RectEmpty := True;
      if FTabPosition in [sctpTop, sctpBottom] then
        RectEmpty := R.Right - R.Left <= 0
      else if FTabPosition in [sctpLeft, sctpRight] then
        RectEmpty := R.Bottom - R.Top <= 0;

      if not RectEmpty then
      begin
        if FTabPosition in [sctpTop, sctpBottom] then
          Inc(R.Right, 4)
        else Inc(R.Bottom, 4);

        for I := 0 to DataList.Count-1 do
        begin
          TabData := DataList[I];
          if not TabData.Visible or (I < FFirstTab) then
            Continue;

          Tr := TabData.TabRect;
          if IsRectEmpty(Tr) then
            Continue;

          if ((FTabPosition in [sctpTop, sctpBottom]) and (Tr.Right > R.Right)) or
            ((FTabPosition in [sctpLeft, sctpRight]) and (Tr.Bottom > R.Bottom)) then
            Break;

          TabData.Showing := True;
          FTabs[I].FShowing := True;
        end;
      end;
    end;
  end;
end;

function TSCCustomTabControl.GetActiveIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FTabs <> nil then
  begin
    Result := FTabIndex;
    if (Result > -1) and ((Result > FTabs.Count-1) or
      not FTabs[Result].Visible) then
      Result := -1;

    if Result = -1 then
      for I := 0 to FTabs.Count-1 do
        if FTabs[I].Visible then
        begin
          Result := I;
          Break;
        end;
  end;
end;

function TSCCustomTabControl.GetFirstShowingTab: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FTabs <> nil then
    for I := 0 to FTabs.Count-1 do
      if FTabs[I].Visible and FTabs[I].Showing then
      begin
        Result :=  I;
        Break;
      end;
end;

function TSCCustomTabControl.GetFirstVisibleTab: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FTabs <> nil then
    for I := 0 to FTabs.Count-1 do
      if FTabs[I].Visible then
      begin
        Result :=  I;
        Break;
      end;
end;

function TSCCustomTabControl.GetLastShowingTab: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FTabs <> nil then
    for I := 0 to FTabs.Count-1 do
      if FTabs[I].Visible and FTabs[I].Showing then
        Result := I;
end;

function TSCCustomTabControl.GetLastVisibleTab: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FTabs <> nil then
    for I := 0 to FTabs.Count-1 do
      if FTabs[I].Visible then
        Result := I;
end;

function TSCCustomTabControl.GetScrollersVisible: Boolean;
var
  BR, R: TRect;
  I, BtnSize, TabMin,
  AIndent, TabMax,
  BandWidth, Spare: Integer;
begin
  Result := False;
  if (FTabs <> nil) and (FVisibleTabCount > 1) then
  begin
    BR := GetBandRect;
    AIndent := GetIndent;

    if AIndent > 0 then
    begin
      if FTabPosition in [sctpTop, sctpBottom] then
        Inc(BR.Left, AIndent)
      else
        Inc(BR.Top, AIndent);
    end;

    Spare := 2;

    if FShowCloseButton then
    begin
      R := GetCloseButtonRect;

      BtnSize := R.Right - R.Left;
      if FTabPosition in [sctpLeft, sctpRight] then
        BtnSize := R.Bottom - R.Top;

      if BtnSize > 3 then
      begin
        if FTabPosition in [sctpTop, sctpBottom] then
          Dec(BR.Right, BtnSize + Spare)
        else
          Dec(BR.Bottom, BtnSize + Spare);
      end;
    end;

    if FTabPosition in [sctpTop, sctpBottom] then
      BandWidth := BR.Right - BR.Left
    else BandWidth := BR.Bottom - BR.Top;

    TabMin := -1;
    TabMax := -1;

    if BandWidth > 0 then
      for I := 0 to FTabs.Count-1 do
        if FTabs[I].Visible then
        begin
          R := FTabs[I].FTabRect;

          if FTabPosition in [sctpTop, sctpBottom] then
          begin
            if FTabIndex = I then InflateRect(R, -2, 0);

            if TabMin = -1 then TabMin := R.Left;
            if R.Right > TabMax then
              TabMax := R.Right;
          end else
          begin
            if FTabIndex = I then InflateRect(R, 0, -2);

            if TabMin = -1 then TabMin := R.Top;
            if R.Bottom > TabMax then
              TabMax := R.Bottom;
          end;

          Result := (TabMax - TabMin + 4) > BandWidth;
          if Result then
            Exit;
        end;
  end;
end;

function TSCCustomTabControl.GetTabSize: Integer;
var
  I, H, W: Integer;
begin
  Result := 0;
  if FTabs <> nil then
  begin
    for I := 0 to FTabs.Count-1 do
      if FTabs[I].Visible then
      begin
        CalculateTabSize(I, W, H);

        if FTabPosition in [sctpTop, sctpBottom] then
        begin
          if Result < H then
            Result := H;
        end else
        if Result < W then
          Result := W;
      end;

    Dec(Result);
    if FStyle = sctbWin2K then Dec(Result);

    if (Result > 0) and not (FStyle in ButtonStyles) then
      Inc(Result, 2);

    if Result < SC_TabsMinHeight then
      Result := SC_TabsMinHeight;
  end;
end;

function TSCCustomTabControl.GetVisibleTabCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  if FTabs <> nil then
    for I := 0 to FTabs.Count-1 do
      if FTabs[I].Visible then
        Inc(Result);
end;

procedure TSCCustomTabControl.HideAllTabs;
var
  I: Integer;
begin
  if (FTabs <> nil) and (FTabs.Count > 0) then
  begin
    FTabs.BeginUpdate;
    try
      FFirstTab := 0;
      for I := 0 to FTabs.Count-1 do
        FTabs[I].Visible := False;
    finally
      FTabs.EndUpdate;
    end;
  end;
end;

procedure TSCCustomTabControl.SetTabs(Value: TSCTabItems);
begin
  FTabs.Assign(Value);
end;

procedure TSCCustomTabControl.ShowAllTabs;
var
  I: Integer;
begin
  if (FTabs <> nil) and (FTabs.Count > 0) then
  begin
    FTabs.BeginUpdate;
    try
      SetFirstTab(FFirstTab);
      for I := 0 to FTabs.Count-1 do
        FTabs[I].Visible := True;
    finally
      FTabs.EndUpdate;
    end;
  end;
end;

procedure TSCCustomTabControl.UpdateTabRects;
var
  Page: TSCTabItem;
  R, TR, CR: TRect;
  I, W, H, TS, Index,
  Offset, VisibleCnt,
  PrevH,MaxSize, Cnt,
  Space, CurPos, AIndent,
  FirstVisible: Integer;
begin
  if not HandleAllocated then
  begin
    for I := 0 to FTabs.Count-1 do
    begin
      Page := FTabs[I];
      Page.FTabRect := Rect(0, 0, 0, 0);
    end;

    Exit;
  end;

  if FTabs <> nil then
  begin
    CurPos := 0;
    if not (FStyle in ButtonStyles) then
      CurPos := 2;

    AIndent := GetIndent;
    Inc(CurPos, AIndent);

    TS := 0;
    VisibleCnt := 0;
    TR := FTabsRect;

    Index := GetActiveIndex;
    MaxSize := GetMaximumTabSize;

    PrevH := 0;

    for I := 0 to FTabs.Count-1 do
    begin
      Page := FTabs[I];
      if Page.Visible then
      begin
        Inc(VisibleCnt);

        CalculateTabSize(I, W, H);
        R := Rect(0, 0, W, H);

        if FTabPosition in [sctpTop, sctpBottom] then
        begin
          if TS < H then TS := H;
          if W > MaxSize then W := MaxSize;

          OffsetRect(R, CurPos, 0);
          Inc(CurPos, W);

          if FStyle in [sctbNewX, sctbWhidbey] then
          begin
            Dec(CurPos, H div 2);

            if W < 2*(PrevH div 3) then
            begin
              PrevH := PrevH div 3;

              Inc(CurPos, PrevH);
              OffsetRect(R, PrevH, 0);
            end;
          end;

          PrevH := H;
        end else
        begin
          if TS < W then TS := W;
          if H > MaxSize then H := MaxSize;

          OffsetRect(R, 0, CurPos);
          Inc(CurPos, H);

          if FStyle in [sctbNewX, sctbWhidbey] then
          begin
            Dec(CurPos, W div 2);

            if H < 2*(PrevH div 3) then
            begin
              PrevH := PrevH div 3;

              Inc(CurPos, PrevH);
              OffsetRect(R, 0, PrevH);
            end;
          end;

          PrevH := W;
        end;

        Page.TabRect := R;
      end;
    end;

    if VisibleCnt > 0 then
    begin
      if (TS > 0) and not (FStyle in ButtonStyles) then
        Inc(TS, 2);

      if (Index > -1) and (Index < FTabs.Count) and
        not (FStyle in [sctbOffice12, sctbWhidbey]) and
        not (FStyle in ButtonStyles) then
      begin
        R := FTabs[Index].TabRect;

        if FTabPosition in [sctpTop, sctpBottom] then
        begin
          Inc(R.Bottom, 2);
          InflateRect(R, 2, 0);
        end else
        begin
          Inc(R.Right, 2);
          InflateRect(R, 0, 2);
        end;

        FTabs[Index].TabRect := R;
      end;

      CR := ClientRect;

      if FTabPosition = sctpTop then
        Inc(CR.Top, TS)
      else
      if FTabPosition = sctpBottom then
        Dec(CR.Bottom, TS)
      else
      if FTabPosition = sctpLeft then
        Inc(CR.Left, TS)
      else
      if FTabPosition = sctpRight then
        Dec(CR.Right, TS);

      Cnt := 0;
      if FStyle = sctbOffice12 then
        Cnt := 1;

      Space := GetTabSpacing;
      
      for I := 0 to FTabs.Count-1 do
      begin
        Page := FTabs[I];

        if Page.Visible then
        begin
          Inc(Cnt);
          R := Page.TabRect;

          case FTabPosition of
            sctpTop:
            begin
              if R.Right - R.Left > MaxSize then
                R.Right := R.Left + MaxSize;

              OffsetRect(R, 0, TS - (R.Bottom - R.Top));
              if FStyle in [sctbOffice12, sctbXP, sctbNew] then
                Inc(R.Right);

              OffsetRect(R, Space*(Cnt-1), 0);
            end;
            sctpBottom:
            begin
              if R.Right - R.Left > MaxSize then
                R.Right := R.Left + MaxSize;

              OffsetRect(R, 0, CR.Bottom - CR.Top);
              if FStyle in [sctbOffice12, sctbXP, sctbNew] then
                Inc(R.Right);

              OffsetRect(R, Space*(Cnt-1), 0);
            end;
            sctpLeft:
            begin
              if R.Bottom - R.Top > MaxSize then
                R.Bottom := R.Top + MaxSize;

              OffsetRect(R, TS - (R.Right - R.Left), 0);
              if FStyle in [sctbOffice12, sctbXP, sctbNew] then
                Inc(R.Bottom);

              OffsetRect(R, 0, Space*(Cnt-1));
            end;
            sctpRight:
            begin
              if R.Bottom - R.Top > MaxSize then
                R.Bottom := R.Top + MaxSize;

              OffsetRect(R, CR.Right - CR.Left, 0);
              if FStyle in [sctbOffice12, sctbXP, sctbNew] then
                Inc(R.Bottom);

              OffsetRect(R, 0, Space*(Cnt-1));
            end;
          end;

          Page.TabRect := R;
        end;
      end;

      if (FFirstTab > 0) and (FFirstTab < FTabs.Count) then
      begin
        Tr := FTabs[FFirstTab].TabRect;

        FirstVisible := GetFirstVisibleTab;
        if FTabPosition in [sctpTop, sctpBottom] then
          Offset := Tr.Left - FTabs[FirstVisible].TabRect.Left
        else
          Offset := Tr.Top - FTabs[FirstVisible].TabRect.Top;

        if not (FStyle in ButtonStyles) then
        begin
          if Index = FFirstTab then
            Inc(Offset, 2)
          else if Index = FirstVisible then
            Dec(Offset, 2);
        end;

        if Offset > 0 then
          for I := 0 to FTabs.Count-1 do
          begin
            Page := FTabs[I];
            
            if Page.Visible then
            begin
              Tr := Page.TabRect;

              if FTabPosition in [sctpTop, sctpBottom] then
                OffsetRect(Tr, -Offset, 0)
              else OffsetRect(Tr, 0, -Offset);

              Page.TabRect := Tr;
            end;
          end;
      end;
    end;
  end;
end;

{ TSCTabSheet }

procedure TSCTabSheet.AssignTo(Dest: TPersistent);
begin
  if Dest is TSCTabData then
  begin
    with TSCTabData(Dest) do
    begin
      Caption := Self.Caption;
      Color := Self.Color;
      Enabled := Self.TabEnabled;
      FontColor := Self.FontColor;
      Visible := Self.TabVisible;
      Hint := Self.Hint;
      ImageIndex := Self.ImageIndex;
      DisabledImage := Self.DisabledImage;
      HotImage := Self.HotImage;
    end;
  end else
    inherited AssignTo(Dest);
end;

procedure TSCTabSheet.Changed;
begin
  if FPageControl <> nil then
  begin
    FPageControl.UpdateTabs(False);
    FPageControl.UpdateTabs(True);
  end;
end;

procedure TSCTabSheet.CMEnabledChanged(var Message: TMessage);
begin
  if FTabVisible then
    Changed;
end;

procedure TSCTabSheet.CMShowingChanged(var Message: TMessage);
begin
  inherited;
end;

procedure TSCTabSheet.CMTextChanged(var Message: TMessage);
begin
  if FTabVisible then
    Changed;
end;

constructor TSCTabSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  InternalSetVisible(False);
  ControlStyle := ControlStyle + [csAcceptsControls, csOpaque,
    csNoDesignVisible];

  Align := alClient;
  InternalSetVisible(False);
  FShowing := True;
  FFontColor := clNone;
  FImageIndex := -1;
  FHotImage := -1;
  FDisabledImage := -1;
  FTabEnabled := True;
  FTabVisible := True;
end;

procedure TSCTabSheet.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params.WindowClass do
    Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

destructor TSCTabSheet.Destroy;
begin
  if FPageControl <> nil then
    FPageControl.RemovePage(Self);
  inherited;
end;

function TSCTabSheet.GetColor: TColor;
begin
  Result := inherited Color;
end;

function TSCTabSheet.GetImages: TCustomImageList;
begin
  Result := nil;
  if Self.PageControl <> nil then
    Result := Self.PageControl.Images;
end;

function TSCTabSheet.GetPageIndex: Integer;
begin
  Result := -1;
  if FPageControl <> nil then
    Result := FPageControl.FPages.IndexOf(Self);
end;

function TSCTabSheet.GetTabIndex: Integer;
var
  I: Integer;
begin
  Result := 0;
  if not GetTabVisible then
    Dec(Result)
  else begin
    for I := 0 to PageIndex - 1 do
      if FPageControl.Pages[I].TabVisible then
        Inc(Result);
  end;
end;

function TSCTabSheet.GetTabVisible: Boolean;
begin
  Result := FTabVisible or IsDesigning;
end;

function TSCTabSheet.GetVisible: Boolean;
begin
  Result := inherited Visible or IsDesigning;
end;

procedure TSCTabSheet.InternalSetVisible(Value: Boolean);
begin
  inherited Visible := Value;
end;

procedure TSCTabSheet.Paint;
var
  R: TRect;
  Cl, C2: TColor;
begin
  R := Rect(0, 0, Width, Height);
  Cl := Self.Color;

  with Canvas do
  begin
    Brush.Color := Cl;
    Canvas.FillRect(R);
  end;

  if (FPageControl <> nil) and (FPageControl.FStyle = sctbOffice12) then
  begin
    C2 := BlendedColor(Cl, 12, 12, 12, True);
    scDrawGradient(Canvas, R, scgTopToBottom, Cl, C2);
  end;
end;

procedure TSCTabSheet.ReadState(Reader: TReader);
begin
  inherited;
  if Reader.Parent is TSCCustomPageControl then
    PageControl := TSCCustomPageControl(Reader.Parent);
end;

procedure TSCTabSheet.SetColor(Value: TColor);
begin
  if GetColor <> Value then
  begin
    if FPageControl <> nil then
    begin
      if not FPageControl.UseTabColors and (Value <> FPageControl.Color) then
        FPageControl.UseTabColors := True;

      if (FPageControl.UseTabColors or ((GetColor <> FPageControl.Color) and
        (Value = FPageControl.Color))) then
      begin
        inherited Color := Value;
        if FTabVisible then
          Changed;
      end;
    end else
    begin
      inherited Color := Value;
      if FTabVisible then
        Changed;
    end;
  end;
end;

procedure TSCTabSheet.SetDisabledImage(Value: TImageIndex);
begin
  if FDisabledImage <> Value then
  begin
    FDisabledImage := Value;
    if FTabVisible then
      Changed;
  end;
end;

procedure TSCTabSheet.SetFontColor(Value: TColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    if FTabVisible then
      Changed;
  end;
end;

procedure TSCTabSheet.SetHotImage(Value: TImageIndex);
begin
  if FHotImage <> Value then
  begin
    FHotImage := Value;
    if FTabVisible then
      Changed;
  end;
end;

procedure TSCTabSheet.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if FTabVisible then
      Changed;
  end;
end;

procedure TSCTabSheet.SetPageControl(APageControl: TSCCustomPageControl);
begin
  if FPageControl <> APageControl then
  begin
    if FPageControl <> nil then
      FPageControl.RemovePage(Self);

    Parent := APageControl;
    if APageControl <> nil then
      APageControl.InsertPage(Self);
  end;
end;

procedure TSCTabSheet.SetPageIndex(Value: Integer);
var
  PageCount: Integer;
begin
  if FPageControl <> nil then
  begin
    PageCount := FPageControl.FPages.Count;

    if Value < PageCount then
    begin
      FPageControl.FPages.Move(PageIndex, Value);
      Changed;
    end;
  end;
end;

procedure TSCTabSheet.SetTabEnabled(Value: Boolean);
begin
  if FTabEnabled <> Value then
  begin
    FTabEnabled := Value;
    if FTabVisible then
      Changed;
  end;
end;

procedure TSCTabSheet.SetTabRect(Value: TRect);
begin
  FTabRect := Value;
end;

procedure TSCTabSheet.SetTabVisible(Value: Boolean);
begin
  if FTabVisible <> Value then
  begin
    FTabVisible := Value;
    Changed;
  end;
end;

procedure TSCTabSheet.SetVisible(Value: Boolean);
begin
  //
end;

procedure TSCTabSheet.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1;
end;

{ TSCCustomPageControl }

procedure TSCCustomPageControl.ActiveTabMoved(Index: Integer);
begin
  ActivePage.PageIndex := Index;
end;

procedure TSCCustomPageControl.CalculateTabSize(Index: Integer; var W,
  H: Integer);
var
  Page: TSCTabSheet;
  ValidImage: Boolean;
  ImgList: TCustomImageList;
  TextH, TbSize, ImageW,
  ImageH, ImageCount: Integer;
begin
  W := 0;
  H := 0;

  if (Index > -1) and (FPages <> nil) and (Index < FPages.Count) then
  begin
    Page := TSCTabSheet(FPages[Index]);
    if not Page.TabVisible then
      Exit;

    ImageW := 0;
    ImageH := 0;

    ValidImage := False;

    ImgList := GetImages;
    if ImgList <> nil then
    begin
      ImageCount := ImgList.Count;

      if ((Page.ImageIndex > -1) and (Page.ImageIndex < ImageCount)) or
        ((Page.DisabledImage > -1) and (Page.DisabledImage < ImageCount)) or
        ((Page.HotImage > -1) and (Page.HotImage < ImageCount)) then
      begin
        ValidImage := True;
        
        with ImgList do
        begin
          ImageW := Width;
          ImageH := Height;
        end;

        if ImageW > 0 then Inc(ImageW, 2);
        if ImageH > 0 then Inc(ImageH, 2);
      end;
    end;

    TextH := FTextHeight + 8;

    TbSize := FDefaultTabSize;
    if FAutoTabSize then
      TbSize := Canvas.TextWidth(Page.Caption) + 8;

    if FTabPosition in [sctpTop, sctpBottom] then
    begin
      if FTabOrientation in [sctoDefault, sctoHorizontal] then
      begin
        H := TextH;
        if ValidImage then
          Inc(TbSize, ImageW + 4);

        W := TbSize;
        if W < 24 then W := 24;

        if ImageW > 0 then
          Inc(W, FImageSpacing);
      end else
      begin
        W := TextH;
        if ValidImage then
          Inc(TbSize, ImageW + 4);

        H := TbSize;
        if H < 24 then H := 24;

        if ImageH > 0 then
          Inc(H, FImageSpacing);
      end;

      Inc(W, 4);
      if FStyle = sctbNew then
        Inc(W, 8)
      else
      if FStyle = sctbNewX then
        Inc(W, H)
      else
      if FStyle = sctbWhidbey then
        Inc(W, H + 2);

      if H < SC_TabsMinHeight then
        H := SC_TabsMinHeight;
    end else
    begin
      if FTabOrientation in [sctoDefault, sctoVertical] then
      begin
        W := TextH;
        if ValidImage then
          Inc(TbSize, ImageH + 4);

        H := TbSize;
        if H < 24 then H := 24;

        if ImageH > 0 then
          Inc(H, FImageSpacing);
      end else
      begin
        H := TextH;
        if ValidImage then
          Inc(TbSize, ImageW + 4);

        W := TbSize;
        if W < 24 then W := 24;

        if ImageW > 0 then
          Inc(W, FImageSpacing);
      end;

      Inc(H, 4);
      if FStyle = sctbNew then
        Inc(H, 8)
      else
      if FStyle = sctbNewX then
        Inc(H, W)
      else
      if FStyle = sctbWhidbey then
        Inc(H, W + 2);

      if W < SC_TabsMinHeight then
        W := SC_TabsMinHeight;
    end;
  end;
end;

procedure TSCCustomPageControl.Change;
begin
  if not FInitActivePage then
    inherited;
end;

procedure TSCCustomPageControl.ChangeActivePage(Page: TSCTabSheet);
var
  Form: TCustomForm;
begin
  if FActivePage <> Page then
  begin
    Form := GetParentForm(Self);
    if (Form <> nil) and (FActivePage <> nil) and
      FActivePage.ContainsControl(Form.ActiveControl) then
      Form.ActiveControl := FActivePage;

    if Page <> nil then
    begin
      Page.BringToFront;
      Page.InternalSetVisible(True);

      if (Form <> nil) and (FActivePage <> nil) and
        (Form.ActiveControl = FActivePage) then
      begin
        if Page.CanFocus then
          Form.ActiveControl := Page
        else
          Form.ActiveControl := Self;
      end;
    end;

    if FActivePage <> nil then
      FActivePage.InternalSetVisible(False);

    FActivePage := Page;
    if (Form <> nil) and (FActivePage <> nil) and
      (Form.ActiveControl = FActivePage) then
      FActivePage.SelectFirst;
  end;
end;

procedure TSCCustomPageControl.Changing(NewIndex: Integer; var Allowed: Boolean);
begin
  if not FInitActivePage then
    inherited Changing(NewIndex, Allowed);

  if Allowed then
    ChangeActivePage(PageForTab(NewIndex));
end;

procedure TSCCustomPageControl.CMColorChanged(var Message: TMessage);
var
  I: Integer;
begin
  if not UseTabColors then
    for I := 0 to FPages.Count-1 do
      TSCTabSheet(FPages[I]).Color := Color;

  inherited;
end;

procedure TSCCustomPageControl.CMDialogKey(var Message: TCMDialogKey);
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
      SelectNextPage(GetKeyState(VK_SHIFT) >= 0);
      Message.Result := 1;
    end;
  end;
end;

procedure TSCCustomPageControl.CMDockClient(var Message: TCMDockClient);
var
  DockCtl: TControl;
  IsVisible: Boolean;
begin
  Message.Result := 0;
  FNewDockSheet := TSCTabSheet.Create(Self);
  try
    try
      DockCtl := Message.DockSource.Control;
      if DockCtl is TCustomForm then
        FNewDockSheet.Caption := TCustomForm(DockCtl).Caption;

      FNewDockSheet.PageControl := Self;
      DockCtl.Dock(Self, Message.DockSource.DockRect);
    except
      FNewDockSheet.Free;
      raise;
    end;

    IsVisible := DockCtl.Visible;
    FNewDockSheet.TabVisible := IsVisible;
    if IsVisible then
      ActivePage := FNewDockSheet;

    DockCtl.Align := alClient;
  finally
    FNewDockSheet := nil;
  end;
end;

procedure TSCCustomPageControl.CMDockNotification(
  var Message: TCMDockNotification);
var
  I: Integer;
  S: string;
  Page: TSCTabSheet;
begin
  Page := GetPageFromDockClient(Message.Client);

  if Page <> nil then
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

        Page.Caption := S;
      end;

      CM_VISIBLECHANGED:
        Page.TabVisible := Boolean(Message.NotifyRec.MsgWParam);
    end;
  end;
  inherited;
end;

procedure TSCCustomPageControl.CMUnDockClient(var Message: TCMUnDockClient);
var
  Page: TSCTabSheet;
begin
  Message.Result := 0;
  Page := GetPageFromDockClient(Message.Client);

  if Page <> nil then
  begin
    FUndockingPage := Page;
    Message.Client.Align := alNone;
  end;
end;

constructor TSCCustomPageControl.Create(AOwner: TComponent);
begin
  if not Registered then
  begin
    Classes.RegisterClasses([TSCTabSheet]);
    Registered := True;
  end;

  FPages := TList.Create;
  inherited Create(AOwner);

  ControlStyle := ControlStyle - [csAcceptsControls] + [csOpaque];
  Height := 150;
  UseTabColors := False;
  FActivePage := nil;
end;

procedure TSCCustomPageControl.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or WS_CLIPCHILDREN;
end;

destructor TSCCustomPageControl.Destroy;
var
  I: Integer;
begin
  for I := 0 to FPages.Count-1 do
    TSCTabSheet(FPages[I]).FPageControl := nil;

  FreeAndNil(FPages);
  inherited Destroy;
end;

procedure TSCCustomPageControl.DestroyActiveTab;
var
  Index: Integer;
begin
  if FActivePage <> nil then
  begin
    Index := TabIndex;
    FActivePage.Free;

    if Index > 0 then Dec(Index);
    SetTabIndex(Index);
  end;
end;

procedure TSCCustomPageControl.DoAddDockClient(Client: TControl;
  const ARect: TRect);
begin
  if FNewDockSheet <> nil then
    Client.Parent := FNewDockSheet;
end;

procedure TSCCustomPageControl.DockOver(Source: TDragDockObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  R: TRect;
begin
  GetWindowRect(Handle, R);
  Source.DockRect := R;
  DoDockOver(Source, X, Y, State, Accept);
end;

procedure TSCCustomPageControl.DoRemoveDockClient(Client: TControl);
begin
  if (FUndockingPage <> nil) and not IsDestroying then
  begin
    SelectNextPage(True);
    FUndockingPage.Free;
    FUndockingPage := nil;
  end;
end;

procedure TSCCustomPageControl.FillDataList;
var
  R, Tr: TRect;
  Page: TSCTabSheet;
  Pts1: TSCTabPoints;
  TabData: TSCTabData;
  I, J, Index: Integer;
  DataList: TSCDataList;
  Pts2: array[0..9] of TPoint;
begin
  DataList := GetDataList;

  if DataList <> nil then
  begin
    DataList.Clear;

    if (FPages <> nil) and (FPages.Count > 0) then
    begin
      UpdateTabRects;

      Tr := FTabsRect;

      Index := FTabIndex;
      if (Index > -1) and ((Index > FPages.Count-1) or
        not TSCTabSheet(FPages[Index]).TabVisible) then
        Index := -1;

      for I := 0 to FPages.Count-1 do
      begin
        Page := TSCTabSheet(FPages[I]);
        if (Index = -1) and Page.TabVisible then
          Index := I;

        R := Page.FTabRect;

        TabData := DataList.Add;
        Page.AssignTo(TabData);
        TabData.TabRect := R;

        Page.FShowing := True;

        TabData.Showing := True;
        TabData.Index   := I;
        TabData.TabItem := Page;
      end;

      UpdateTabRects;

      for I := 0 to FPages.Count-1 do
      begin
        Page := TSCTabSheet(FPages[I]);
        Page.FShowing := False;

        R := Page.FTabRect;
        TabData := DataList[I];

        TabData.Showing := False;
        TabData.TabRect := R;

        TabData.SetRegion(0);
        TabData.SetPoints(GetTabPoints(R, False, 2, 0));

        SetLength(Pts1, 0);
        Pts1 := GetTabPoints(R, True, 2, 0);

        if Length(Pts1) > 2 then
        begin
          for J := 0 to Length(Pts1)-1 do
            Pts2[J] := Pts1[J];

          TabData.SetRegion(CreatePolygonRgn(Pts2, Length(Pts1), WINDING));
        end;
      end;

      R := FTabsRect;
      if not IsRectEmpty(R) then
      begin
        if FTabPosition in [sctpTop, sctpBottom] then
          Inc(R.Right, 4)
        else Inc(R.Bottom, 4);

        for I := 0 to DataList.Count-1 do
        begin
          TabData := DataList[I];
          if not TabData.Visible or (I < FFirstTab) then
            Continue;

          Tr := TabData.TabRect;
          if IsRectEmpty(Tr) then
            Continue;

          if ((FTabPosition in [sctpTop, sctpBottom]) and (Tr.Right > R.Right)) or
            ((FTabPosition in [sctpLeft, sctpRight]) and (Tr.Bottom > R.Bottom)) then
            Break;

          TabData.Showing := True;
          TSCTabSheet(FPages[I]).FShowing := True;
        end;
      end;
    end;
  end;
end;

function TSCCustomPageControl.FindNextPage(CurPage: TSCTabSheet; GoForward,
  CheckTabVisible: Boolean): TSCTabSheet;
var
  I, StartIndex: Integer;
begin
  Result := nil;
  if FPages.Count <> 0 then
  begin
    StartIndex := FPages.IndexOf(CurPage);

    if StartIndex = -1 then
    begin
      StartIndex := 0;
      if GoForward then
        StartIndex := FPages.Count-1;
    end;

    I := StartIndex;
    repeat
      if GoForward then
      begin
        Inc(I);
        if I = FPages.Count then I := 0;
      end else
      begin
        if I = 0 then I := FPages.Count;
        Dec(I);
      end;

      Result := FPages[I];
      if not CheckTabVisible or Result.TabVisible then
        Exit;
    until I = StartIndex;
  end;
end;

function TSCCustomPageControl.GetActivePageIndex: Integer;
begin
  Result := -1;
  if ActivePage <> nil then
    Result := ActivePage.PageIndex;
end;

function TSCCustomPageControl.GetActiveIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  if FPages <> nil then
  begin
    Result := FTabIndex;
    if (Result > -1) and ((Result > FPages.Count-1) or
      not TSCTabSheet(FPages[Result]).TabVisible) then
      Result := -1;

    if Result = -1 then
      for I := 0 to FPages.Count-1 do
        if TSCTabSheet(FPages[I]).TabVisible then
        begin
          Result := I;
          Break;
        end;
  end;
end;

procedure TSCCustomPageControl.GetChildren(Proc: TGetChildProc;
  Root: TComponent);
var
  I: Integer;
begin
  for I := 0 to FPages.Count-1 do
    Proc(TComponent(FPages[I]));
end;

function TSCCustomPageControl.GetDockClientAt(P: TPoint): TControl;
var
  I: Integer;
  Page: TSCTabSheet;
  HitInfo: TSCTabHitInfo;
begin
  Result := nil;
  if DockSite then
  begin
    HitInfo := HitTest(P);
    if HitInfo.Tab >= 0 then
    begin
      Page := nil;
      for I := 0 to HitInfo.Tab do
        Page := FindNextPage(Page, True, True);

      if (Page <> nil) and (Page.ControlCount > 0) then
      begin
        Result := Page.Controls[0];
        if Result.HostDockSite <> Self then
          Result := nil;
      end;
    end;
  end;
end;

function TSCCustomPageControl.GetFirstShowingTab: Integer;
var
  I: Integer;
  Page: TSCTabSheet;
begin
  Result := -1;
  if FPages <> nil then
    for I := 0 to FPages.Count-1 do
    begin
      Page := TSCTabSheet(FPages[I]);
      if Page.TabVisible and Page.Showing then
      begin
        Result :=  I;
        Break;
      end;
    end;
end;

function TSCCustomPageControl.GetFirstVisibleTab: Integer;
var
  I: Integer;
  Page: TSCTabSheet;
begin
  Result := -1;
  if FPages <> nil then
    for I := 0 to FPages.Count-1 do
    begin
      Page := TSCTabSheet(FPages[I]);
      if Page.TabVisible then
      begin
        Result :=  I;
        Break;
      end;
    end;
end;

function TSCCustomPageControl.GetLastShowingTab: Integer;
var
  I: Integer;
  Page: TSCTabSheet;
begin
  Result := -1;
  if FPages <> nil then
    for I := FPages.Count-1 downto 0 do
    begin
      Page := TSCTabSheet(FPages[I]);
      if Page.TabVisible and Page.Showing then
      begin
        Result :=  I;
        Break;
      end;
    end;
end;

function TSCCustomPageControl.GetLastVisibleTab: Integer;
var
  I: Integer;
  Page: TSCTabSheet;
begin
  Result := -1;
  if FPages <> nil then
    for I := FPages.Count-1 downto 0 do
    begin
      Page := TSCTabSheet(FPages[I]);
      if Page.TabVisible then
      begin
        Result :=  I;
        Break;
      end;
    end;
end;

function TSCCustomPageControl.GetPage(Index: Integer): TSCTabSheet;
begin
  Result := FPages[Index];
end;

function TSCCustomPageControl.GetPageCount: Integer;
begin
  Result := FPages.Count;
end;

function TSCCustomPageControl.GetPageFromDockClient(
  Client: TControl): TSCTabSheet;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to PageCount-1 do
    if (Client.Parent = Pages[I]) and (Client.HostDockSite = Self) then
    begin
      Result := Pages[ I ];
      Exit;
    end;
end;

function TSCCustomPageControl.GetScrollersVisible: Boolean;
var
  BR, R: TRect;
  Page: TSCTabSheet;
  I, BtnSize, TabMin,
  TabMax, BandWidth,
  AIndent, Spare: Integer;
begin
  Result := False;
  if (FPages <> nil) and (FVisibleTabCount > 1) then
  begin
    BR := GetBandRect;
    AIndent := GetIndent;

    if AIndent > 0 then
    begin
      if FTabPosition in [sctpTop, sctpBottom] then
        Inc(BR.Left, AIndent)
      else
        Inc(BR.Top, AIndent);
    end;

    Spare := 2;

    if FShowCloseButton then
    begin
      R := GetCloseButtonRect;

      BtnSize := R.Right - R.Left;
      if FTabPosition in [sctpLeft, sctpRight] then
        BtnSize := R.Bottom - R.Top;

      if BtnSize > 3 then
      begin
        if FTabPosition in [sctpTop, sctpBottom] then
          Dec(BR.Right, BtnSize + Spare)
        else
          Dec(BR.Bottom, BtnSize + Spare);
      end;
    end;

    if FTabPosition in [sctpTop, sctpBottom] then
      BandWidth := BR.Right - BR.Left
    else BandWidth := BR.Bottom - BR.Top;

    TabMin := -1;
    TabMax := -1;

    if BandWidth > 0 then
      for I := 0 to FPages.Count-1 do
      begin
        Page := TSCTabSheet(FPages[I]);

        if Page.TabVisible then
        begin
          R := Page.FTabRect;

          if FTabPosition in [sctpTop, sctpBottom] then
          begin
            if FTabIndex = I then InflateRect(R, -2, 0);

            if TabMin = -1 then TabMin := R.Left;
            if R.Right > TabMax then
              TabMax := R.Right;
          end else
          begin
            if FTabIndex = I then InflateRect(R, 0, -2);

            if TabMin = -1 then TabMin := R.Top;
            if R.Bottom > TabMax then
              TabMax := R.Bottom;
          end;

          Result := (TabMax - TabMin + 4) > BandWidth;
          if Result then
            Exit;
        end;
      end;
  end;
end;

procedure TSCCustomPageControl.GetSiteInfo(Client: TControl;
  var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
begin
  CanDock := GetPageFromDockClient(Client) = nil;
  inherited;
end;

function TSCCustomPageControl.GetTabSize: Integer;
var
  I, H, W: Integer;
begin
  Result := 0;
  if FPages <> nil then
  begin
    for I := 0 to FPages.Count-1 do
      if TSCTabSheet(FPages[I]).TabVisible then
      begin
        CalculateTabSize(I, W, H);

        if FTabPosition in [sctpTop, sctpBottom] then
        begin
          if Result < H then
            Result := H;
        end else
        if Result < W then
          Result := W;
      end;

    Dec(Result);
    if FStyle = sctbWin2K then Dec(Result);

    if (Result > 0) and not (FStyle in ButtonStyles) then
      Inc(Result, 2);

    if Result < SC_TabsMinHeight then
      Result := SC_TabsMinHeight;
  end;
end;

function TSCCustomPageControl.GetVisibleTabCount: Integer;
var
  I: Integer;
  Sheet: TSCTabSheet;
begin
  Result := 0;
  if FPages <> nil then
    for I := 0 to FPages.Count-1 do
    begin
      Sheet := TSCTabSheet(FPages[I]);
      if Sheet.TabVisible and not Sheet.IsDestroying then
        Inc(Result);
    end;
end;

procedure TSCCustomPageControl.HideAllTabs;
var
  I: Integer;
begin
  for I := 0 to FPages.Count-1 do
    Pages[I].TabVisible := False;
end;

procedure TSCCustomPageControl.InsertPage(Page: TSCTabSheet);
begin
  HandleNeeded;

  FPages.Add(Page);
  Page.FPageControl := Self;

  UpdateTabs(False);
  UpdateTabs(True);
end;

procedure TSCCustomPageControl.MakeControlVisible(AControl: TControl);
var
  Page: TSCTabSheet;
  I, ControlPageIndex: Integer;

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
  ControlPageIndex := -1;

  for I := 0 to PageCount-1 do
  begin
    Page := Pages[I];
    if Page = AControl then
    begin
      ControlPageIndex := I;
      Break;
    end else
    if FindControl(Page) then
    begin
      ControlPageIndex := I;
      Break;
    end;
  end;

  if ControlPageIndex < 0 then
    ControlPageIndex := 0;

  if ControlPageIndex <> ActivePageIndex then
    ActivePageIndex := ControlPageIndex;
end;

function TSCCustomPageControl.PageForTab(ATabIndex: Integer): TSCTabSheet;
var
  I: Integer;
  Page: TSCTabSheet;
begin
  Result := nil;
  if ATabIndex > -1 then
    for I := 0 to FPages.Count - 1 do
    begin
      Page := TSCTabSheet( FPages[ I ] );
      if Page.TabIndex = ATabIndex then
      begin
        Result := Page;
        Exit;
      end;
    end;
end;

procedure TSCCustomPageControl.RemovePage(Page: TSCTabSheet);
var
  Active: Boolean;
begin
  if Page <> nil then
  begin
    Active := FActivePage = Page;
    if Active then SetActivePage(nil);

    Page.SetTabVisible(False);
    Page.FPageControl := nil;

    FPages.Remove(Page);

    UpdateTabs(False);
    UpdateTabs(True);

    if Active and (ActivePageIndex > -1) then
      MakeTabVisible(ActivePageIndex, True);
  end;
end;

procedure TSCCustomPageControl.SelectNextPage(GoForward: Boolean);
var
  Page: TSCTabSheet;
begin
  Page := FindNextPage(ActivePage, GoForward, True);
  if Page <> nil then
    SetActivePage(Page);
end;

procedure TSCCustomPageControl.SetActivePage(Page: TSCTabSheet);
var
  Allowed: Boolean;
  NewTabIndex: Integer;
begin
  if (Page = nil) or (Page.PageControl = Self) then
  begin
    if (Page <> nil) and not FInitActivePage then
    begin
      Allowed := True;
      Changing(Page.PageIndex, Allowed);
      if not Allowed then
        Exit;
    end;

    if Page <> nil then
      Page.InternalSetVisible(True);

    if IsLoading or IsReading then
    begin
      FActivePage := Page;
      Exit;
    end;

    NewTabIndex := -1;
    if Page <> nil then NewTabIndex := Page.TabIndex;

    if NewTabIndex > -1 then
      ChangeActivePage(Page);

    SetTabIndex(NewTabIndex);
  end;
end;

procedure TSCCustomPageControl.SetActivePageIndex(Value: Integer);
begin
  SetActivePage(Pages[Value]);
end;

procedure TSCCustomPageControl.SetChildOrder(Child: TComponent; Order: Integer);
begin
  TSCTabSheet(Child).PageIndex := Order;
end;

procedure TSCCustomPageControl.SetUseTabColors(Value: Boolean);
begin
  inherited;
  if (Parent <> nil) and not UseTabColors then
    Perform(CM_COLORCHANGED, 0, 0);
end;

procedure TSCCustomPageControl.ShowAllTabs;
var
  I: Integer;
begin
  for I := 0 to FPages.Count-1 do
    Pages[I].TabVisible := True;
end;

procedure TSCCustomPageControl.ShowControl(AControl: TControl);
begin
  if (AControl is TSCTabSheet) and
    (TSCTabSheet(AControl).PageControl = Self) then
    SetActivePage(TSCTabSheet(AControl));

  inherited ShowControl(AControl);
end;

procedure TSCCustomPageControl.UpdateTabRects;
var
  Page: TSCTabSheet;
  R, TR, CR: TRect;
  I, W, H, TS, Index,
  Offset, VisibleCnt,
  PrevH, Cnt, Space,
  MaxSize, CurPos,
  AIndent, FirstVisible: Integer;
begin
  if not HandleAllocated then
  begin
    if FPages <> nil then
      for I := 0 to FPages.Count-1 do
      begin
        Page := TSCTabSheet(FPages[I]);
        Page.FTabRect := Rect(0, 0, 0, 0);
      end;

    Exit;
  end;

  if FPages <> nil then
  begin
    CurPos := 0;
    if not (FStyle in ButtonStyles) then
      CurPos := 2;

    AIndent := GetIndent;
    Inc(CurPos, AIndent);

    TS := 0;
    VisibleCnt := 0;
    TR := FTabsRect;

    Index := GetActiveIndex;
    MaxSize := GetMaximumTabSize;

    PrevH := 0;

    for I := 0 to FPages.Count-1 do
    begin
      Page := TSCTabSheet(FPages[I]);
      
      if Page.TabVisible then
      begin
        Inc(VisibleCnt);

        CalculateTabSize(I, W, H);
        R := Rect(0, 0, W, H);

        if FTabPosition in [sctpTop, sctpBottom] then
        begin
          if TS < H then TS := H;
          if W > MaxSize then W := MaxSize;

          OffsetRect(R, CurPos, 0);
          Inc(CurPos, W);

          if FStyle in [sctbNewX, sctbWhidbey] then
          begin
            Dec(CurPos, H div 2);

            if W < 2*(PrevH div 3) then
            begin
              PrevH := PrevH div 3;

              Inc(CurPos, PrevH);
              OffsetRect(R, PrevH, 0);
            end;
          end;

          PrevH := H;
        end else
        begin
          if TS < W then TS := W;
          if H > MaxSize then H := MaxSize;

          OffsetRect(R, 0, CurPos);
          Inc(CurPos, H);

          if FStyle in [sctbNewX, sctbWhidbey] then
          begin
            Dec(CurPos, W div 2);

            if H < 2*(PrevH div 3) then
            begin
              PrevH := PrevH div 3;

              Inc(CurPos, PrevH);
              OffsetRect(R, 0, PrevH);
            end;
          end;

          PrevH := W;
        end;

        Page.TabRect := R;
      end;
    end;

    if VisibleCnt > 0 then
    begin
      if (TS > 0) and not (FStyle in ButtonStyles) then
        Inc(TS, 2);

      if (Index > -1) and (Index < FPages.Count) and
        not (FStyle in [sctbOffice12, sctbWhidbey]) and
        not (FStyle in ButtonStyles) then
      begin
        Page := TSCTabSheet(FPages[Index]);
        R := Page.TabRect;

        if FTabPosition in [sctpTop, sctpBottom] then
        begin
          Inc(R.Bottom, 2);
          InflateRect(R, 2, 0);
        end else
        begin
          Inc(R.Right, 2);
          InflateRect(R, 0, 2);
        end;

        Page.FTabRect := R;
      end;

      CR := ClientRect;

      if FTabPosition = sctpTop then
        Inc(CR.Top, TS)
      else
      if FTabPosition = sctpBottom then
        Dec(CR.Bottom, TS)
      else
      if FTabPosition = sctpLeft then
        Inc(CR.Left, TS)
      else
      if FTabPosition = sctpRight then
        Dec(CR.Right, TS);

      Cnt := 0;
      if FStyle = sctbOffice12 then
        Cnt := 1;

      Space := GetTabSpacing;

      for I := 0 to FPages.Count-1 do
      begin
        Page := TSCTabSheet(FPages[I]);
        
        if Page.TabVisible then
        begin
          Inc(Cnt);
          R := Page.TabRect;

          case FTabPosition of
            sctpTop:
            begin
              if R.Right - R.Left > MaxSize then
                R.Right := R.Left + MaxSize;

              OffsetRect(R, 0, TS - (R.Bottom - R.Top));
              if FStyle in [sctbOffice12, sctbXP, sctbNew] then
                Inc(R.Right);

              OffsetRect(R, Space*(Cnt-1), 0);
            end;
            sctpBottom:
            begin
              if R.Right - R.Left > MaxSize then
                R.Right := R.Left + MaxSize;

              OffsetRect(R, 0, CR.Bottom - CR.Top);
              if FStyle in [sctbOffice12, sctbXP, sctbNew] then
                Inc(R.Right);

              OffsetRect(R, Space*(Cnt-1), 0);
            end;
            sctpLeft:
            begin
              if R.Bottom - R.Top > MaxSize then
                R.Bottom := R.Top + MaxSize;

              OffsetRect(R, TS - (R.Right - R.Left), 0);
              if FStyle in [sctbOffice12, sctbXP, sctbNew] then
                Inc(R.Bottom);

              OffsetRect(R, 0, Space*(Cnt-1));
            end;
            sctpRight:
            begin
              if R.Bottom - R.Top > MaxSize then
                R.Bottom := R.Top + MaxSize;

              OffsetRect(R, CR.Right - CR.Left, 0);
              if FStyle in [sctbOffice12, sctbXP, sctbNew] then
                Inc(R.Bottom);

              OffsetRect(R, 0, Space*(Cnt-1));
            end;
          end;

          Page.TabRect := R;
        end;
      end;

      if (FFirstTab > 0) and (FFirstTab < FPages.Count) then
      begin
        Tr := TSCTabSheet(FPages[FFirstTab]).TabRect;

        FirstVisible := GetFirstVisibleTab;

        Page := TSCTabSheet(FPages[FirstVisible]);
        if FTabPosition in [sctpTop, sctpBottom] then
          Offset := Tr.Left - Page.TabRect.Left
        else
          Offset := Tr.Top - Page.TabRect.Top;

        if not (FStyle in [sctbOffice12, sctbWhidbey]) and
          not (FStyle in ButtonStyles) then
        begin
          if Index = FFirstTab then
            Inc(Offset, 2)
          else if Index = FirstVisible then
            Dec(Offset, 2);
        end;

        if Offset > 0 then
          for I := 0 to FPages.Count-1 do
          begin
            Page := TSCTabSheet(FPages[I]);

            if Page.TabVisible then
            begin
              Tr := Page.TabRect;

              if FTabPosition in [sctpTop, sctpBottom] then
                OffsetRect(Tr, -Offset, 0)
              else OffsetRect(Tr, 0, -Offset);

              Page.TabRect := Tr;
            end;
          end;
      end;
    end;
  end;
end;

procedure TSCCustomPageControl.WMLButtonDblClk(var Message: TWMLButtonDblClk);
var
  DockCtl: TControl;
begin
  inherited;

  DockCtl := GetDockClientAt(SmallPointToPoint(Message.Pos));
  if DockCtl <> nil then
    DockCtl.ManualDock(nil, nil, alNone);
end;

procedure TSCCustomPageControl.WMLButtonDown(var Message: TWMLButtonDown);
var
  DockCtl: TControl;
begin
  inherited;
  
  DockCtl := GetDockClientAt(SmallPointToPoint(Message.Pos));
  if DockCtl <> nil then
    DockCtl.BeginDrag(False);
end;

procedure TSCCustomPageControl.DoCloseClick;
var
  Index: Integer;
begin
  if FPages <> nil then
  begin
    Index := GetActiveIndex;
    if (Index > -1) and (Index < FPages.Count) then
    begin
      with TSCTabSheet(FPages[Index]) do
      begin
        InternalSetVisible(False);
        SetTabVisible(False);
      end;

      UpdateTabs(True);
    end;
  end;
end;

procedure TSCCustomPageControl.DoTabIndexChanged;
var
  Page: TSCTabSheet;
  Index1, Index2: Integer;
begin
  Index1 := Self.TabIndex;
  Index2 := Self.ActivePageIndex;

  if Index1 <> Index2 then
  begin
    Page := nil;
    if (Index1 > -1) and (Index2 < FPages.Count) then
      Page := TSCTabSheet(FPages[Index1]);

    SetActivePage(Page);
  end;
end;

procedure TSCCustomPageControl.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('ActivePageDefault', ReadEmptyData, WriteEmptyData, False);
end;

procedure TSCCustomPageControl.ReadEmptyData(Reader: TReader);
begin
  //
end;

procedure TSCCustomPageControl.WriteEmptyData(Writer: TWriter);
begin
  //
end;

procedure TSCCustomPageControl.Loaded;
var
  Index: Integer;
  Page: TSCTabSheet;
begin
  Index := GetTabIndexDefault;
  inherited Loaded;

  if GetControlLoaded and (Index > -1) then
  begin
    FInitActivePage := True;
    try
      Page := FActivePage;
      FActivePage := nil;

      UpdateTabs(False);
      UpdateTabs(True);

      SetActivePage(Page);
      if Page <> nil then
        MakeTabVisible(Page.PageIndex, True);
    finally
      FInitActivePage := False;
    end;
  end;
end;

{$I SCVerRec.inc}

end.
