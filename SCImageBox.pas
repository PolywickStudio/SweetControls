{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCImageBox;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Clipbrd, SCConsts, SCCommon, SCControl;

type
  TSCImageBorderProps = class(TSCBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccb3DLowered;
  end;

  TSCImageBoxScrollbar = class(TSCControlScrollbar)
  published
    property Background;
    property ButtonColors;
    property Icons;
    property SlideLine;
    property Thumb;
  end;

  TSCImageBoxScrollbars = class(TSCControlScrollbars)
  private
    function  GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Visible: Boolean read GetVisible write SetVisible default True;
  end;

  TSCZoomRatio = 1..5000;
  TSCImageZoomMode = (sczmNone, sczmStretch, sczmStretchKeepingRatio, sczmZoom);

  TSCCustomImageBox = class(TSCCustomScrollControl)
  private
    FCenter: Boolean;
    FShowScrollbars: Boolean;
    FHideFocusRect: Boolean;
    FHorizontalPos: Integer;
    FVerticalPos: Integer;
    FZoomRatio: TSCZoomRatio;
    FZoomMode: TSCImageZoomMode;
    FDrawing: Integer;
    FQuickDraw: Boolean;
    FCreatingWnd: Integer;
    FScrollPosChanging: Integer;
    FScrollbarChanging: Integer;
    FTile: Boolean;
    FPictureTransparent: Boolean;
    procedure SetCenter(Value: Boolean);
    procedure SetHorizontalPos(Value: Integer);
    procedure SetVerticalPos(Value: Integer);
    procedure SetHideFocusRect(Value: Boolean);
    procedure SetShowScrollbars(Value: Boolean);
    procedure SetTile(Value: Boolean);
    procedure SetZoomRatio(Value: TSCZoomRatio);
    procedure SetZoomMode(Value: TSCImageZoomMode);

    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMCopy(var Message: TMessage); message WM_COPY;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Paint; override;
    procedure AdjustBounds; override;
    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    function  GetPalette: HPALETTE; override;

    function  GetGraphic: TGraphic; virtual;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;

    procedure EnsureHorizontalPos(var P: Integer);
    procedure EnsureVerticalPos(var P: Integer);

    function  UpdateHorzScrollBar: Boolean;
    function  UpdateVertScrollBar: Boolean;
    procedure UpdateScrollbars(Horz, Vert: Boolean); dynamic;
    procedure DoScrollerPositionChanged(Kind: TSCScrollbarKind); override;

    function  GetControlScrollbarsClass: TSCControlCustomScrollbarsClass; override;
    function  GetScrollbarClass: TSCCustomControlScrollbarClass; override;

    function  HasGraphic(G: TGraphic): Boolean;
    function  HasPicture(P: TPicture): Boolean; override;
    function  CanDrawGraphic(G: TGraphic): Boolean;
    function  GetPictureRect(P: TPicture): TRect; override;
    procedure PaintPicture(P: TPicture);
    procedure DoDrawPicture(G: TGraphic); virtual;

    procedure DoPictureChanged; override;

    function  CanDrawCaption: Boolean; virtual;
    function  GetPictureCaption: String; virtual;

    function  CanCopy: Boolean; dynamic;
    function  CanCut: Boolean; dynamic;
    function  CanPaste: Boolean; dynamic;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    property Border default sccb3DLowered;
    property Center: Boolean read FCenter write SetCenter default False;
    property Color default clWindow;
    property HideFocusRect: Boolean read FHideFocusRect write SetHideFocusRect default False;
    property ShowScrollbars: Boolean read FShowScrollbars write SetShowScrollbars default True;
    property ParentColor default False;
    property QuickDraw: Boolean read FQuickDraw write FQuickDraw default False;
    property HorizontalPos: Integer read FHorizontalPos write SetHorizontalPos default 0;
    property Tile: Boolean read FTile write SetTile default False;
    property VerticalPos: Integer read FVerticalPos write SetVerticalPos default 0;
    property ZoomRatio: TSCZoomRatio read FZoomRatio write SetZoomRatio default 100;
    property ZoomMode: TSCImageZoomMode read FZoomMode write SetZoomMode default sczmNone;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    procedure CopyToClipboard; dynamic;
    procedure CutToClipboard; dynamic;
    procedure PasteFromClipboard; dynamic;
  end;

  TSCImageBox = class(TSCCustomImageBox)
  public
    property HorizontalPos;
    property VerticalPos;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property Caption;
    property Center;
    property ClickFocus;
    property Color;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideFocusRect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureTransparent;
    property QuickDraw;
    property Scrollbars;
    property ShowHint;
    property ShowPicture;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
    property TabOrder;
    property TabStop;
    property Tile;
    property Transparent;
    property Visible;
    property ZoomRatio;
    property ZoomMode;
    property OnCanResize;
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

  TSCPictureListerFrame = (scpfBumped, scpfEtched, scpfSingle, scpfDouble,
    scpfLowered, scpf3DLowered, scpfRaised, scpf3DRaised, scpfRoundedDouble,
    scpfNone, scpfMetal);

  TSCPictureListerOption = (scpoAllowSelection, scpoHideSelection, scpoHottrack,
    scpoHottrackUnderline, scpoShowCaption, scpoShowDescription);

  TSCPictureListerOptions = set of TSCPictureListerOption;

const
  SCDefaultPictureListerOptions = [scpoAllowSelection, scpoHideSelection,
    scpoHottrack, scpoShowCaption, scpoShowDescription];

type
  TSCCustomPictureLister = class;

  TSCPictureListerScrollbar = class(TSCControlScrollbar)
  published
    property Background;
    property ButtonColors;
    property Icons;
    property SlideLine;
    property Thumb;
  end;

  TSCPictureListerScrollbars = class(TSCControlScrollbars)
  private
    function  GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Visible: Boolean read GetVisible write SetVisible default True;
  end;

  TSCPictureListerColors = class(TPersistent)
  private
    FOwner: TSCCustomPictureLister;
    FBackground: TColor;
    FCaption: TColor;
    FDefault: TColor;
    FDescription: TColor;
    FFrame: TColor;
    FHideSelection: TColor;
    FHideSelectionText: TColor;
    FHighlight: TColor;
    FHighlightText: TColor;
    FHottrack: TColor;
    FHottrackText: TColor;
    procedure SetBackground(Value: TColor);
    procedure SetCaption(Value: TColor);
    procedure SetDefault(Value: TColor);
    procedure SetDescription(Value: TColor);
    procedure SetFrame(Value: TColor);
    procedure SetHideSelection(Value: TColor);
    procedure SetHideSelectionText(Value: TColor);
    procedure SetHighlight(Value: TColor);
    procedure SetHighlightText(Value: TColor);
    procedure SetHottrack(Value: TColor);
    procedure SetHottrackText(Value: TColor);
  protected
    function  GetOwner: TPersistent; override;
    procedure DoChange;
  public
    constructor Create(AOwner: TSCCustomPictureLister); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Background: TColor read FBackground write SetBackground default clWindow;
    property Caption: TColor read FCaption write SetCaption default clNone;
    property Default: TColor read FDefault write SetDefault default clBtnFace;
    property Description: TColor read FDescription write SetDescription default clNone;
    property Frame: TColor read FFrame write SetFrame default clNone;
    property HideSelection: TColor read FHideSelection write SetHideSelection default clBtnShadow;
    property HideSelectionText: TColor read FHideSelectionText write SetHideSelectionText default clHighlightText;
    property Highlight: TColor read FHighlight write SetHighlight default clHighlight;
    property HighlightText: TColor read FHighlightText write SetHighlightText default clHighlightText;
    property Hottrack: TColor read FHottrack write SetHottrack default clPurple;
    property HottrackText: TColor read FHottrackText write SetHottrackText default clWhite;
  end;

  TSCCustomPictureLister = class(TSCCustomScrollControl)
  private
    FAlignment: TAlignment;
    FCaptionFont: TFont;
    FCaptionHeight: Integer;
    FColors: TSCPictureListerColors;
    FColumns: Integer;
    FDescriptionHeight: Integer;
    FDescriptions: Integer;
    FFrame: TSCPictureListerFrame;
    FFrameSize: Integer;
    FOptions: TSCPictureListerOptions;
    FHotIndex: Integer;
    FSelectedIndex: Integer;
    FPictureHeight: Integer;
    FPictureWidth: Integer;
    FSpaceHorz: Integer;
    FSpaceVert: Integer;
    FHorizontalPos: Integer;
    FVerticalPos: Integer;
    FShowScrollbars: Boolean;
    FOnHottrack: TNotifyEvent;
    FDrawing: Integer;
    FCreatingWnd: Integer;
    FScrollPosChanging: Integer;
    FScrollbarChanging: Integer;
    FMouseDownIndex: Integer;
    procedure SetAlignment(Value: TAlignment);
    procedure SetCaptionFont(Value: TFont);
    procedure SetColors(Value: TSCPictureListerColors);
    procedure SetColumns(Value: Integer);
    procedure SetDescriptions(Value: Integer);
    procedure SetFrame(Value: TSCPictureListerFrame);
    procedure SetFrameSize(Value: Integer);
    procedure SetOptions(Value: TSCPictureListerOptions);
    procedure SetPictureHeight(Value: Integer);
    procedure SetPictureWidth(Value: Integer);
    procedure SetSpaceHorz(Value: Integer);
    procedure SetSpaceVert(Value: Integer);
    procedure SetSelectedIndex(Value: Integer);
    procedure SetShowScrollbars(Value: Boolean);
    procedure SetHorizontalPos(Value: Integer);
    procedure SetVerticalPos(Value: Integer);

    function  GetCount: Integer;

    procedure ColorsChanged(Sender: TObject);
    procedure CaptionFontChanged(Sender: TObject);

    procedure DoHottrack;
    procedure UpdateHottrack(Draw: Boolean = True);

    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Paint; override;

    function  GetColumns: Integer;
    function  GetDrawRect: TRect;

    function  GetFrameSize: Integer;
    function  GetCaptionHeight: Integer;
    function  GetDescriptionHeight: Integer;

    function  GetBoxHeight: Integer;
    function  GetBoxWidth: Integer;

    procedure SetIndent(Value: Integer); override;
    procedure IndentChanged; override;
    procedure SpacingChanged; override;
    procedure StopTracking; override;
    procedure EnabledChanged; override;
    procedure MouseInControlChanged; override;

    procedure DoPictureListChanged; override;

    function  GetPicture: TPicture; override;
    procedure UpdateList;
    procedure DrawBox(C: TCanvas; Index, X, Y: Integer);

    procedure EnsureHorizontalPos(var P: Integer);
    procedure EnsureVerticalPos(var P: Integer);

    function  UpdateHorzScrollBar: Boolean;
    function  UpdateVertScrollBar: Boolean;
    procedure UpdateScrollbars(Horz, Vert: Boolean); dynamic;
    procedure DoScrollerPositionChanged(Kind: TSCScrollbarKind); override;

    function  GetControlScrollbarsClass: TSCControlCustomScrollbarsClass; override;
    function  GetScrollbarClass: TSCCustomControlScrollbarClass; override;
    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    property HotIndex: Integer read FHotIndex;
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property Border default sccb3DLowered;
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property Color default clWindow;
    property Colors: TSCPictureListerColors read FColors write SetColors;
    property Columns: Integer read FColumns write SetColumns default 0;
    property Descriptions: Integer read FDescriptions write SetDescriptions default 1;
    property Frame: TSCPictureListerFrame read FFrame write SetFrame default scpfSingle;
    property FrameSize: Integer read FFrameSize write SetFrameSize default 0;
    property Indent default 8;
    property HorizontalPos: Integer read FHorizontalPos write SetHorizontalPos default 0;
    property VerticalPos: Integer read FVerticalPos write SetVerticalPos default 0;
    property Options: TSCPictureListerOptions read FOptions write SetOptions default SCDefaultPictureListerOptions;
    property ParentColor default False;
    property PictureHeight: Integer read FPictureHeight write SetPictureHeight default 80;
    property PictureWidth: Integer read FPictureWidth write SetPictureWidth default 80;
    property SelectedIndex: Integer read FSelectedIndex write SetSelectedIndex default -1;
    property ShowScrollbars: Boolean read FShowScrollbars write SetShowScrollbars default True;
    property SpaceHorz: Integer read FSpaceHorz write SetSpaceHorz default 0;
    property SpaceVert: Integer read FSpaceVert write SetSpaceVert default 0;
    property Spacing default 8;
    property OnHottrack: TNotifyEvent read FOnHottrack write FOnHottrack;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function  GetPictureRect(Index: Integer): TRect;
    function  GetPictureAtPos(X, Y: Integer): Integer;
    procedure MakeVisible(Index: Integer);
    function  InView(Index: Integer; PartitialAllowed: Boolean = True): Boolean;

    property Count: Integer read GetCount;
  end;

  TSCPictureLister = class(TSCCustomPictureLister)
  public
    property HotIndex;
    property SelectedIndex;
  published
    property Align;
    property Alignment;
    property Anchors;
    property BorderProps;
    property CaptionFont;
    property Color;
    property Colors;
    property Columns;
    property Constraints;
    property Descriptions;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Frame;
    property FrameSize;
    property Indent;
    property Options;
    property ParentColor;
    property ParentFont;
    property Picture;    
    property PictureList;
    property PictureHeight;
    property PictureWidth;
    property PopupMenu;
    property Scrollbars;
    property SpaceHorz;
    property SpaceVert;
    property Spacing;
    property TabOrder;
    property TabStop;
    property Transparent;
    property Visible;
    property OnCanResize;
    property OnChange;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnHottrack;
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

  TSCImageListerFrame = (scifBumped, scifEtched, scifSingle, scifDouble,
    scifLowered, scif3DLowered, scifRaised, scif3DRaised, scifRoundedDouble,
    scifNone, scifMetal);

  TSCImageListerOption = (scioAllowSelection, scioHideSelection, scioHottrack,
    scioHottrackUnderline, scioShowNumbers);

  TSCImageListerOptions = set of TSCImageListerOption;

const
  SCDefaultImageListerOptions = [scioAllowSelection, scioHideSelection,
    scioHottrack, scioShowNumbers];

type
  TSCCustomImageLister = class;

  TSCImageListerScrollbar = class(TSCControlScrollbar)
  published
    property Background;
    property ButtonColors;
    property Icons;
    property SlideLine;
    property Thumb;
  end;

  TSCImageListerScrollbars = class(TSCControlScrollbars)
  private
    function  GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Visible: Boolean read GetVisible write SetVisible default True;
  end;

  TSCImageListerColors = class(TPersistent)
  private
    FOwner: TSCCustomImageLister;
    FBackground: TColor;
    FCaption: TColor;
    FDefault: TColor;
    FFrame: TColor;
    FHideSelection: TColor;
    FHideSelectionText: TColor;
    FHighlight: TColor;
    FHighlightText: TColor;
    FHottrack: TColor;
    FHottrackText: TColor;
    procedure SetBackground(Value: TColor);
    procedure SetCaption(Value: TColor);
    procedure SetDefault(Value: TColor);
    procedure SetFrame(Value: TColor);
    procedure SetHideSelection(Value: TColor);
    procedure SetHideSelectionText(Value: TColor);
    procedure SetHighlight(Value: TColor);
    procedure SetHighlightText(Value: TColor);
    procedure SetHottrack(Value: TColor);
    procedure SetHottrackText(Value: TColor);
  protected
    function  GetOwner: TPersistent; override;
    procedure DoChange;
  public
    constructor Create(AOwner: TSCCustomImageLister); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Background: TColor read FBackground write SetBackground default clNone;
    property Caption: TColor read FCaption write SetCaption default clNone;
    property Default: TColor read FDefault write SetDefault default clNone;
    property Frame: TColor read FFrame write SetFrame default clNone;
    property HideSelection: TColor read FHideSelection write SetHideSelection default clBtnShadow;
    property HideSelectionText: TColor read FHideSelectionText write SetHideSelectionText default clHighlightText;
    property Highlight: TColor read FHighlight write SetHighlight default clHighlight;
    property HighlightText: TColor read FHighlightText write SetHighlightText default clHighlightText;
    property Hottrack: TColor read FHottrack write SetHottrack default clPurple;
    property HottrackText: TColor read FHottrackText write SetHottrackText default clWhite;
  end;

  TSCCustomImageLister = class(TSCCustomScrollControl)
  private
    FAlignment: TAlignment;
    FCaptionHeight: Integer;
    FColors: TSCImageListerColors;
    FColumns: Integer;
    FFrame: TSCImageListerFrame;
    FFrameSize: Integer;
    FOptions: TSCImageListerOptions;
    FHotIndex: Integer;
    FSelectedIndex: Integer;
    FPictureHeight: Integer;
    FPictureWidth: Integer;
    FSpaceHorz: Integer;
    FSpaceVert: Integer;
    FHorizontalPos: Integer;
    FVerticalPos: Integer;
    FShowScrollbars: Boolean;
    FOnHottrack: TNotifyEvent;
    FDrawing: Integer;
    FCreatingWnd: Integer;
    FScrollPosChanging: Integer;
    FScrollbarChanging: Integer;
    FMouseDownIndex: Integer;
    procedure SetAlignment(Value: TAlignment);
    procedure SetColors(Value: TSCImageListerColors);
    procedure SetColumns(Value: Integer);
    procedure SetFrame(Value: TSCImageListerFrame);
    procedure SetFrameSize(Value: Integer);
    procedure SetOptions(Value: TSCImageListerOptions);
    procedure SetSpaceHorz(Value: Integer);
    procedure SetSpaceVert(Value: Integer);
    procedure SetSelectedIndex(Value: Integer);
    procedure SetShowScrollbars(Value: Boolean);
    procedure SetHorizontalPos(Value: Integer);
    procedure SetVerticalPos(Value: Integer);

    function  GetCount: Integer;

    procedure ColorsChanged(Sender: TObject);

    procedure DoHottrack;
    procedure UpdateHottrack(Draw: Boolean = True);

    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Paint; override;

    function  GetColumns: Integer;
    function  GetDrawRect: TRect;

    function  GetFrameSize: Integer;
    function  GetCaptionHeight: Integer;

    function  GetImageHeight: Integer;
    function  GetImageWidth: Integer;

    function  GetBoxHeight: Integer;
    function  GetBoxWidth: Integer;

    procedure SetIndent(Value: Integer); override;
    procedure IndentChanged; override;
    procedure SpacingChanged; override;
    procedure StopTracking; override;
    procedure EnabledChanged; override;
    procedure MouseInControlChanged; override;
    procedure ImageListChange(Sender: TObject); override;

    procedure UpdateList;
    procedure DrawBox(C: TCanvas; Index, X, Y: Integer);

    procedure EnsureHorizontalPos(var P: Integer);
    procedure EnsureVerticalPos(var P: Integer);

    function  UpdateHorzScrollBar: Boolean;
    function  UpdateVertScrollBar: Boolean;
    procedure UpdateScrollbars(Horz, Vert: Boolean); dynamic;
    procedure DoScrollerPositionChanged(Kind: TSCScrollbarKind); override;

    function  GetControlScrollbarsClass: TSCControlCustomScrollbarsClass; override;
    function  GetScrollbarClass: TSCCustomControlScrollbarClass; override;
    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    property HotIndex: Integer read FHotIndex;
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property Border default sccb3DLowered;
    property Color default clWindow;
    property Colors: TSCImageListerColors read FColors write SetColors;
    property Columns: Integer read FColumns write SetColumns default 0;
    property Frame: TSCImageListerFrame read FFrame write SetFrame default scifNone;
    property FrameSize: Integer read FFrameSize write SetFrameSize default 0;
    property Indent default 8;
    property HorizontalPos: Integer read FHorizontalPos write SetHorizontalPos default 0;
    property VerticalPos: Integer read FVerticalPos write SetVerticalPos default 0;
    property Options: TSCImageListerOptions read FOptions write SetOptions default SCDefaultImageListerOptions;
    property ParentColor default False;
    property SelectedIndex: Integer read FSelectedIndex write SetSelectedIndex default -1;
    property ShowScrollbars: Boolean read FShowScrollbars write SetShowScrollbars default True;
    property SpaceHorz: Integer read FSpaceHorz write SetSpaceHorz default 0;
    property SpaceVert: Integer read FSpaceVert write SetSpaceVert default 0;
    property Spacing default 8;
    property OnHottrack: TNotifyEvent read FOnHottrack write FOnHottrack;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function  GetPictureRect(Index: Integer): TRect;
    function  GetPictureAtPos(X, Y: Integer): Integer;
    procedure MakeVisible(Index: Integer);
    function  InView(Index: Integer; PartitialAllowed: Boolean = True): Boolean;

    property Count: Integer read GetCount;
  end;

  TSCImageLister = class(TSCCustomImageLister)
  public
    property HotIndex;
    property SelectedIndex;
  published
    property Align;
    property Alignment;
    property Anchors;
    property BorderProps;
    property Color;
    property Colors;
    property Columns;
    property Constraints;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Frame;
    property FrameSize;
    property Images;
    property Indent;
    property Options;
    property ParentColor;
    property ParentFont;
    property Picture;    
    property PictureProps;
    property PopupMenu;
    property Scrollbars;
    property SpaceHorz;
    property SpaceVert;
    property Spacing;
    property TabOrder;
    property TabStop;
    property Transparent;
    property Visible;
    property OnCanResize;
    property OnChange;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnHottrack;
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

{ TSCCustomImageBox }

procedure TSCCustomImageBox.AdjustBounds;
begin
  AdjustSize;
end;

function TSCCustomImageBox.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
var
  P: TPicture;
begin
  Result := True;

  P := Picture;
  
  if (P.Width > 0) and (P.Height > 0) then
  begin
    if Align in [alNone, alLeft, alRight] then
      NewWidth := P.Width;
    if Align in [alNone, alTop, alBottom] then
      NewHeight := P.Height;
  end;
end;

constructor TSCCustomImageBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csSetCaption, csOpaque, csDoubleClicks];
  ParentColor := False;
  Color := clWindow;
  Border := sccb3DLowered;
  SetBounds(Left, Top, 140, 100);

  FQuickDraw := False;
  FShowScrollbars := True;
  FHorizontalPos := 0;
  FVerticalPos := 0;
  FZoomRatio := 100;
  FZoomMode := sczmNone;
end;

procedure TSCCustomImageBox.DoDrawPicture(G: TGraphic);
var
  DrawPict: TPicture;
begin
  if CanDrawGraphic(G) then
  begin
    Inc(FDrawing);
    try
      DrawPict := TPicture.Create;
      try
        DrawPict.Assign(G);
        PaintPicture(DrawPict);
      finally
        DrawPict.Free;
      end;
    finally
      Dec(FDrawing);
    end;
  end;  
end;

procedure TSCCustomImageBox.EnsureHorizontalPos(var P: Integer);
var
  Mx: Integer;
  CR, R: TRect;
begin
  if (P < 0) or IsDesigning or not ((FZoomMode = sczmZoom) or
    ((FZoomMode = sczmNone) and not (AutoSize or Center))) then
    P := 0
  else begin
    R := GetPictureRect(Picture);
    OffsetRect(R, -R.Left, -R.Top);

    if IsRectEmpty(R) then
    begin
      P := 0;
      Exit;
    end;

    CR := GetClientRect;
    OffsetRect(CR, -CR.Left, -CR.Top);

    if IsRectEmpty(CR) then
    begin
      P := 0;
      Exit;
    end;

    Mx := R.Right - CR.Right;
    if (Mx > 0) and (P > Mx) then
      P := Mx;
  end;
end;

procedure TSCCustomImageBox.EnsureVerticalPos(var P: Integer);
var
  Mx: Integer;
  CR, R: TRect;
begin
  if (P < 0) or IsDesigning or not ((FZoomMode = sczmZoom) or
    ((FZoomMode = sczmNone) and not (AutoSize or Center))) then
    P := 0
  else begin
    R := GetPictureRect(Picture);
    OffsetRect(R, -R.Left, -R.Top);

    if IsRectEmpty(R) then
    begin
      P := 0;
      Exit;
    end;

    CR := GetClientRect;
    OffsetRect(CR, -CR.Left, -CR.Top);

    if IsRectEmpty(CR) then
    begin
      P := 0;
      Exit;
    end;

    Mx := R.Bottom - CR.Bottom;
    if (Mx > 0) and (P > Mx) then
      P := Mx;
  end;
end;

function TSCCustomImageBox.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCImageBorderProps;
end;

function TSCCustomImageBox.GetPictureRect(P: TPicture): TRect;
var
  R: TRect;
  L, T: Integer;
  Ratio, Hr: Double;
begin
  Result := Rect(0, 0, 0, 0);
  if ShowPicture then
  begin
    R := GetClientRect;
    OffsetRect(R, -R.Left, -R.Top);

    if not IsRectEmpty(R) then
    begin
      if (P <> nil) and (P.Graphic <> nil) and
        not P.Graphic.Empty and (P.Height > 0) and (P.Width > 0) then
      begin
        Result := Rect(0, 0, P.Width, P.Height);

        case FZoomMode of
          sczmStretch:
          begin
            Result := R;
          end;
          sczmStretchKeepingRatio:
          begin
            Ratio := R.Right / P.Width;
            Hr := R.Bottom / P.Height;

            if Hr < Ratio then Ratio := Hr;

            Result := Rect(0, 0, Round(Ratio * P.Width), Round(Ratio * P.Height));
          end;
          sczmZoom:
          begin
            Ratio := FZoomRatio / 100;
            Result := Rect(0, 0, Round(Ratio * P.Width), Round(Ratio * P.Height));
          end;
          sczmNone:
          begin
            if FCenter and not AutoSize then
            begin
              L := (R.Right - P.Width) div 2;
              T := (R.Bottom - P.Height) div 2;

              Result := Rect(L, T, L + P.Width, T + P.Height);
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TSCCustomImageBox.HasGraphic(G: TGraphic): Boolean;
begin
  Result := (G <> nil) and not G.Empty and (G.Height > 0) and (G.Width > 0);
end;

procedure TSCCustomImageBox.Paint;
var
  CR: TRect;
  Cl: TColor;
  Text: String;
begin
  if not HandleAllocated then
    Exit;

  Inc(FDrawing);
  try
    CR := ClientRect;
    OffsetRect(CR, -CR.Left, -CR.Top);

    if IsRectEmpty(CR) then
      Exit;

    Cl := Self.Color;
    if Cl = clNone then Cl := clWindow;

    with Canvas do
    begin
      Brush.Color := Cl;
      FillRect(CR);

      if Transparent then
        PaintParentOn(Canvas);
    end;

    DoDrawPicture(GetGraphic);

    if CanDrawCaption then
    begin
      Text := GetPictureCaption;

      with Canvas do
      begin
        Font := Self.Font;
        Brush.Style := bsClear;

        DrawText(Handle, PChar(Text), Length(Text), CR,
          DT_SINGLELINE or DT_NOPREFIX or DT_CENTER or DT_VCENTER);
      end;
    end;

    if not IsDesigning and not FHideFocusRect and Focused then
    begin
      scFrame3D(Canvas, CR, Cl, Cl, 1, 1);
      InflateRect(CR, 1, 1);

      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := clHighlight;
      end;

      scDrawFocusRect(Canvas, CR, clHighlight);
    end;
  finally
    Dec(FDrawing);
  end;
end;

procedure TSCCustomImageBox.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;

    if (FZoomMode = sczmNone) and not AutoSize and CanDrawPicture(Picture) then
    begin
      FHorizontalPos := 0;
      FVerticalPos := 0;

      if FShowScrollbars then
        UpdateScrollbars(True, True);

      Invalidate;
    end;
  end;
end;

procedure TSCCustomImageBox.SetHorizontalPos(Value: Integer);
begin
  Inc(FScrollPosChanging);
  try
    EnsureHorizontalPos(Value);

    if FHorizontalPos <> Value then
    begin
      FHorizontalPos := Value;
      if FShowScrollbars and (FZoomMode in [sczmNone, sczmZoom]) then
        UpdateScrollbars(True, True);
    end;

    if FScrollbarChanging = 0 then
      TSCImageBoxScrollbar(ScrollbarHorz).Position := FHorizontalPos;
  finally
    Dec(FScrollPosChanging);
  end;
end;

procedure TSCCustomImageBox.SetHideFocusRect(Value: Boolean);
begin
  if FHideFocusRect <> Value then
  begin
    FHideFocusRect := Value;
    if Focused then
      Invalidate;
  end;
end;

procedure TSCCustomImageBox.SetVerticalPos(Value: Integer);
begin
  Inc(FScrollPosChanging);
  try
    EnsureVerticalPos(Value);

    if FVerticalPos <> Value then
    begin
      FVerticalPos := Value;
      if FShowScrollbars and (FZoomMode in [sczmNone, sczmZoom]) then
        UpdateScrollbars(True, True);
    end;

    if FScrollbarChanging = 0 then
      TSCImageBoxScrollbar(ScrollbarVert).Position := FVerticalPos;
  finally
    Dec(FScrollPosChanging);
  end;
end;

procedure TSCCustomImageBox.SetZoomMode(Value: TSCImageZoomMode);
begin
  if FZoomMode <> Value then
  begin
    FZoomMode := Value;

    if CanDrawPicture(Picture) then
    begin
      FHorizontalPos := 0;
      FVerticalPos := 0;

      if FShowScrollbars then
        UpdateScrollbars(True, True);

      Invalidate;
    end;
  end;
end;

procedure TSCCustomImageBox.SetZoomRatio(Value: TSCZoomRatio);
begin
  if FZoomRatio <> Value then
  begin
    FZoomRatio := Value;
    
    if CanDrawPicture(Picture) and (FZoomMode = sczmZoom) then
    begin
      if FShowScrollbars then
        UpdateScrollbars(True, True);

      Invalidate;
    end;
  end;
end;

procedure TSCCustomImageBox.UpdateScrollbars(Horz, Vert: Boolean);
var
  WasHorz, IsVert, IsHorz: Boolean;
begin
  if Horz or Vert then
  begin
    if Horz then ScrollbarHorz.BeginUpdate;
    if Vert then ScrollbarVert.BeginUpdate;

    WasHorz := TSCImageBoxScrollbar(ScrollbarHorz).Visible;
    try
      if Vert then UpdateVertScrollBar;
      if Horz then UpdateHorzScrollBar;

      IsVert := TSCImageBoxScrollbar(ScrollbarVert).Visible;
      IsHorz := TSCImageBoxScrollbar(ScrollbarHorz).Visible;

      if IsVert and (WasHorz <> IsHorz) then
        UpdateVertScrollBar;
    finally
      if Horz then ScrollbarHorz.EndUpdate;
      if Vert then ScrollbarVert.EndUpdate;
    end;
  end;
end;

procedure TSCCustomImageBox.WMPaint(var Message: TWMPaint);
var
  IsDBuf: Boolean;
begin
  IsDBuf := DoubleBuffered;
  DoubleBuffered := CanDrawPicture(Picture);
  try
    inherited;
  finally
    DoubleBuffered := IsDBuf;
  end;
end;

procedure TSCCustomImageBox.WMHScroll(var Message: TWMHScroll);
var
  SI: TSCScrollInfo;
begin
  SI := Self.GetScrollbarInfo(scskHorizontal);

  case Message.ScrollCode of
    SB_LINEUP:
      SetHorizontalPos(FHorizontalPos - 15);
    SB_LINEDOWN:
      SetHorizontalPos(FHorizontalPos + 15);
    SB_PAGEUP:
      SetHorizontalPos(FHorizontalPos - Integer(SI.Page));
    SB_PAGEDOWN:
      SetHorizontalPos(FHorizontalPos + Integer(SI.Page));
    SB_THUMBPOSITION:
    begin
      if SI.Pos <= SI.Min then
        SetHorizontalPos(SI.Min)
      else
      if SI.Pos >= SI.Max then
        SetHorizontalPos(SI.Max)
      else
        SetHorizontalPos(SI.Pos);
    end;
    SB_TOP:
      SetHorizontalPos(SI.Min);
    SB_BOTTOM:
      SetHorizontalPos(SI.Max);
  end;
end;

procedure TSCCustomImageBox.WMMouseWheel(var Message: TWMMouseWheel);
var
  SbVert, SbHorz: TSCImageBoxScrollbar;
begin
  if IsDesigning or not (FZoomMode in [sczmNone, sczmZoom]) then
    Exit;

  SbHorz := TSCImageBoxScrollbar(ScrollbarHorz);
  SbVert := TSCImageBoxScrollbar(ScrollbarVert);

  if ((Message.Keys and MK_SHIFT) = MK_SHIFT) or (SbHorz.Visible and not SbVert.Visible) then
  begin
    if Message.WheelDelta < 0 then
      SetHorizontalPos(FHorizontalPos + 15)
    else
    if Message.WheelDelta > 0 then
      SetHorizontalPos(FHorizontalPos - 15);
  end else
  begin
    if Message.WheelDelta < 0 then
      SetVerticalPos(FVerticalPos + 15)
    else
    if Message.WheelDelta > 0 then
      SetVerticalPos(FVerticalPos - 15);
  end;
end;

procedure TSCCustomImageBox.WMVScroll(var Message: TWMVScroll);
var
  SI: TSCScrollInfo;
begin
  SI := Self.GetScrollbarInfo(scskVertical);

  case Message.ScrollCode of
    SB_LINEUP:
      SetVerticalPos(FVerticalPos - 15);
    SB_LINEDOWN:
      SetVerticalPos(FVerticalPos + 15);
    SB_PAGEUP:
      SetVerticalPos(FVerticalPos - Integer(SI.Page));
    SB_PAGEDOWN:
      SetVerticalPos(FVerticalPos + Integer(SI.Page));
    SB_THUMBPOSITION:
    begin
      if SI.Pos <= SI.Min then
        SetVerticalPos(SI.Min)
      else
      if SI.Pos >= SI.Max then
        SetVerticalPos(SI.Max)
      else
        SetVerticalPos(SI.Pos);
    end;
    SB_TOP:
      SetVerticalPos(SI.Min);
    SB_BOTTOM:
      SetVerticalPos(SI.Max);
  end;
end;

function TSCCustomImageBox.GetScrollbarClass: TSCCustomControlScrollbarClass;
begin
  Result := TSCImageBoxScrollbar;
end;

procedure TSCCustomImageBox.SetShowScrollbars(Value: Boolean);
begin
  if FShowScrollbars <> Value then
  begin
    FShowScrollbars := Value;
    if (FZoomMode in [sczmNone, sczmZoom]) then
      UpdateScrollbars(True, True);
  end;
end;

function TSCCustomImageBox.GetControlScrollbarsClass: TSCControlCustomScrollbarsClass;
begin
  Result := TSCImageBoxScrollbars;
end;

procedure TSCCustomImageBox.DoScrollerPositionChanged(Kind: TSCScrollbarKind);
var
  Sb: TSCImageBoxScrollbar;
begin
  if FScrollPosChanging = 0 then
  begin
    Inc(FScrollbarChanging);
    try
      if Kind = scskHorizontal then
      begin
        Sb := TSCImageBoxScrollbar(ScrollbarHorz);
        SetHorizontalPos(Sb.Position);
      end else
      begin
        Sb := TSCImageBoxScrollbar(ScrollbarVert);
        SetVerticalPos(Sb.Position);
      end;
    finally
      Dec(FScrollbarChanging);
    end;
  end;  
end;

function TSCCustomImageBox.UpdateHorzScrollBar: Boolean;
var
  R: TRect;
  P: TPicture;
  ScrlVisible: Boolean;
  SiOld, SiNew: TSCScrollInfo;
begin
  Result := False;
  if HandleAllocated and (FCreatingWnd = 0) and not IsLoading then
  begin
    SiOld := Self.GetScrollbarInfo(scskHorizontal);
    ScrlVisible := SiOld.Visible and (SiOld.Page <= SiOld.Max);

    SiNew := SiOld;

    SiNew.Page := 1;
    SiNew.Min  := 0;
    SiNew.Max  := 0;
    SiNew.Pos  := 0;

    if FShowScrollbars and ((FZoomMode = sczmZoom) or
      ((FZoomMode = sczmNone) and not (AutoSize or Center or Tile))) then
    begin
      P := GetPicture;

      if CanDrawPicture(P) then
      begin
        R := GetPictureRect(P);
        OffsetRect(R, -R.Left, -R.Top);

        SiNew.Page := Self.ClientWidth;
        SiNew.Min  := 0;
        SiNew.Max  := R.Right;

        if SiNew.Max < 0 then
          SiNew.Max := 0;

        EnsureHorizontalPos(FHorizontalPos);
        SiNew.Pos  := FHorizontalPos;
      end;
    end;

    SiNew.SmallChange := 15;
    SiNew.LargeChange := SiNew.Page;

    if (SiNew.Min <> SiOld.Min) or (SiNew.Max <> SiOld.Max) or
      (SiNew.Page <> SiOld.Page) or (SiNew.Pos <> SiOld.Pos) then
    begin
      SiNew.Visible := SiNew.Page <= SiNew.Max;
      Self.SetScrollbarInfo(scskHorizontal, SiNew);

      if Integer(SiNew.Page) > SiNew.Max then
        SetHorizontalPos(SiNew.Min);
    end;

    Invalidate;
    Result := ScrlVisible <> (Integer(SiNew.Page) <= SiNew.Max);
  end;
end;

function TSCCustomImageBox.UpdateVertScrollBar: Boolean;
var
  R: TRect;
  P: TPicture;
  ScrlVisible: Boolean;
  SiOld, SiNew: TSCScrollInfo;
begin
  Result := False;
  if HandleAllocated and (FCreatingWnd = 0) and not IsLoading then
  begin
    SiOld := Self.GetScrollbarInfo(scskVertical);
    ScrlVisible := SiOld.Visible and (SiOld.Page <= SiOld.Max);

    SiNew := SiOld;

    SiNew.Page := 1;
    SiNew.Min  := 0;
    SiNew.Max  := 0;
    SiNew.Pos  := 0;

    if FShowScrollbars and ((FZoomMode = sczmZoom) or
      ((FZoomMode = sczmNone) and not (AutoSize or Center or Tile))) then
    begin
      P := GetPicture;

      if CanDrawPicture(P) then
      begin
        R := GetPictureRect(P);
        OffsetRect(R, -R.Left, -R.Top);

        SiNew.Page := Self.ClientHeight;
        SiNew.Min  := 0;
        SiNew.Max  := R.Bottom;

        if SiNew.Max < 0 then
          SiNew.Max := 0;

        EnsureVerticalPos(FVerticalPos);
        SiNew.Pos  := FVerticalPos;
      end;
    end;

    SiNew.SmallChange := 15;
    SiNew.LargeChange := SiNew.Page;

    if (SiNew.Min <> SiOld.Min) or (SiNew.Max <> SiOld.Max) or
      (SiNew.Page <> SiOld.Page) or (SiNew.Pos <> SiOld.Pos) then
    begin
      SiNew.Visible := SiNew.Page <= SiNew.Max;
      Self.SetScrollbarInfo(scskVertical, SiNew);

      if Integer(SiNew.Page) > SiNew.Max then
        SetVerticalPos(SiNew.Min);
    end;

    Invalidate;
    Result := ScrlVisible <> (Integer(SiNew.Page) <= SiNew.Max);
  end;
end;

procedure TSCCustomImageBox.CreateWnd;
begin
  Inc(FCreatingWnd);
  try
    inherited CreateWnd;
  finally
    Dec(FCreatingWnd);
  end;
  UpdateScrollbars(True, True);
end;

procedure TSCCustomImageBox.Loaded;
begin
  inherited Loaded;
  UpdateScrollbars(True, True);
end;

procedure TSCCustomImageBox.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateScrollbars(True, True);
end;

procedure TSCCustomImageBox.SetTile(Value: Boolean);
begin
  if FTile <> Value then
  begin
    FTile := Value;
    
    if (FZoomMode = sczmNone) and not AutoSize and CanDrawPicture(Picture) then
    begin
      FHorizontalPos := 0;
      FVerticalPos := 0;

      if FShowScrollbars then
        UpdateScrollbars(True, True);

      Invalidate;
    end;
  end;
end;

function TSCCustomImageBox.GetPalette: HPALETTE;
var
  G: TGraphic;
begin
  Result := 0;

  G := GetGraphic;
  if (G <> nil) and (G is TBitmap) then
    Result := TBitmap(G).Palette;
end;

procedure TSCCustomImageBox.CopyToClipboard;
begin
  if (Picture.Graphic <> nil) and CanCopy then
    Clipboard.Assign(Picture);
end;

procedure TSCCustomImageBox.CutToClipboard;
begin
  if (Picture.Graphic <> nil) and CanCut then
  begin
    CopyToClipboard;
    Picture.Graphic := nil;
  end;
end;

procedure TSCCustomImageBox.PasteFromClipboard;
begin
  if Clipboard.HasFormat(CF_BITMAP) and CanPaste then
    Picture.Bitmap.Assign(Clipboard);
end;

function TSCCustomImageBox.CanCopy: Boolean;
begin
  Result := True;
end;

function TSCCustomImageBox.CanCut: Boolean;
begin
  Result := True;
end;

function TSCCustomImageBox.CanPaste: Boolean;
begin
  Result := True;
end;

procedure TSCCustomImageBox.WMCopy(var Message: TMessage);
begin
  CopyToClipboard;
end;

procedure TSCCustomImageBox.WMCut(var Message: TMessage);
begin
  CutToClipboard;
end;

procedure TSCCustomImageBox.WMPaste(var Message: TMessage);
begin
  PasteFromClipboard;
end;

procedure TSCCustomImageBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  case Key of
    VK_INSERT:
      if ssShift in Shift then
        PasteFromClipBoard
      else if ssCtrl in Shift then
        CopyToClipBoard;
    VK_DELETE:
      if ssShift in Shift then
        CutToClipBoard;
  end;
end;

procedure TSCCustomImageBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  case Key of
    ^X: CutToClipBoard;
    ^C: CopyToClipBoard;
    ^V: PasteFromClipBoard;
  end;
end;

function TSCCustomImageBox.GetPictureCaption: String;
begin
  Result := Caption;
end;

function TSCCustomImageBox.CanDrawCaption: Boolean;
begin
  Result := not CanDrawPicture(Picture);
end;

procedure TSCCustomImageBox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomImageBox then
  begin
    with TSCCustomImageBox(Source) do
    begin
      Self.Center := Center;
      Self.HideFocusRect := HideFocusRect;
      Self.Picture := Picture;
      Self.ShowScrollbars := ShowScrollbars;
      Self.QuickDraw := QuickDraw;
      Self.HorizontalPos := HorizontalPos;
      Self.Tile := Tile;
      Self.VerticalPos := VerticalPos;
      Self.ZoomRatio := ZoomRatio;
      Self.ZoomMode := ZoomMode;
    end;
  end;
end;

function TSCCustomImageBox.GetGraphic: TGraphic;
var
  P: TPicture;
begin
  Result := nil;

  P := GetPicture;
  if P <> nil then Result := P.Graphic;
end;

function TSCCustomImageBox.HasPicture(P: TPicture): Boolean;
begin
  Result := (P <> nil) and HasGraphic(P.Graphic);
end;

function TSCCustomImageBox.CanDrawGraphic(G: TGraphic): Boolean;
begin
  Result := ShowPicture and HasGraphic(G);
end;

procedure TSCCustomImageBox.PaintPicture(P: TPicture);
var
  CR, R: TRect;
  Pal, XCnt, YCnt, W, H, I, J: Integer;
begin
  if not CanDrawPicture(P) then Exit;

  Pal := 0;
  try
    R := GetPictureRect(P);
    if IsRectEmpty(R) then
      Exit;

    // Control has focus, so realize the bitmap palette in foreground
    if HasFocus and (P.Graphic <> nil) and (P.Graphic.Palette <> 0) then
    begin
      Pal := SelectPalette(Handle, P.Graphic.Palette, False);
      RealizePalette(Handle);
    end;

    P.Graphic.Transparent := FPictureTransparent;
    if P.Graphic is TBitmap then
      P.Bitmap.IgnorePalette := FQuickDraw;

    case FZoomMode of
      sczmNone:
      begin
        if not (AutoSize or Center) and Tile then
        begin
          CR := GetClientRect;

          if not IsRectEmpty(CR) then
          begin
            OffsetRect(R, -R.Left, -R.Top);

            W := R.Right;
            H := R.Bottom;

            XCnt := CR.Right div W;
            if XCnt mod W > 0 then Inc(XCnt);

            YCnt := CR.Bottom div H;
            if YCnt mod H > 0 then Inc(YCnt);

            for I := 1 to XCnt do
            begin
              for J := 1 to YCnt do
              begin
                Canvas.Draw(R.Left, R.Top, P.Graphic);
                OffsetRect(R, 0, H);
              end;

              OffsetRect(R, W, -R.Top);
            end;
          end;
        end else
        begin
          if not (AutoSize or FCenter) then
            OffsetRect(R, -FHorizontalPos, -FVerticalPos);

          Canvas.Draw(R.Left, R.Top, P.Graphic);
        end;
      end;
      sczmStretch,
      sczmStretchKeepingRatio:
      begin
        Canvas.StretchDraw(R, P.Graphic);
      end;
      sczmZoom:
      begin
        OffsetRect(R, -FHorizontalPos, -FVerticalPos);
        Canvas.StretchDraw(R, P.Graphic);
      end;
    end;
  finally
    if Pal <> 0 then SelectPalette(Handle, Pal, True);
  end;
end;

procedure TSCCustomImageBox.DoPictureChanged;
var
  P: TPicture;
begin
  P := GetPicture;
  
  if AutoSize and (P.Width > 0) and (P.Height > 0) then
    SetBounds(Left, Top, P.Width, P.Height)
  else
  if (FDrawing = 0) and (P <> nil) then
    UpdateScrollbars(True, True);

  if FDrawing = 0 then
    Invalidate;
end;

{ TSCImageBorderProps }

constructor TSCImageBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccb3DLowered;
end;

{ TSCImageBoxScrollbars }

procedure TSCImageBoxScrollbars.Assign(Source: TPersistent);
begin
  if Source is TSCImageBoxScrollbars then
    Self.Visible := TSCImageBoxScrollbars(Source).Visible;

  inherited Assign(Source);
end;

function TSCImageBoxScrollbars.GetVisible: Boolean;
begin
  Result := True;
  if Owner is TSCCustomImageBox then
    Result := TSCCustomImageBox(Owner).ShowScrollbars;
end;

procedure TSCImageBoxScrollbars.SetVisible(Value: Boolean);
begin
  if Owner is TSCCustomImageBox then
    TSCCustomImageBox(Owner).ShowScrollbars := Value;
end;

{ TSCPictureListerScrollbars }

procedure TSCPictureListerScrollbars.Assign(Source: TPersistent);
begin
  if Source is TSCPictureListerScrollbars then
    Self.Visible := TSCPictureListerScrollbars(Source).Visible;

  inherited Assign(Source);
end;

function TSCPictureListerScrollbars.GetVisible: Boolean;
begin
  Result := True;
  if Owner is TSCCustomPictureLister then
    Result := TSCCustomPictureLister(Owner).ShowScrollbars;
end;

procedure TSCPictureListerScrollbars.SetVisible(Value: Boolean);
begin
  if Owner is TSCCustomPictureLister then
    TSCCustomPictureLister(Owner).ShowScrollbars := Value;
end;

{ TSCPictureListerColors }

procedure TSCPictureListerColors.Assign(Source: TPersistent);
begin
  if Source is TSCPictureListerColors then
  begin
    with TSCPictureListerColors(Source) do
    begin
      Self.FBackground := FBackground;
      Self.FCaption := FCaption;
      Self.FDefault := FDefault;
      Self.FDescription := FDescription;
      Self.FFrame := FFrame;
      Self.FHideSelection := FHideSelection;
      Self.FHideSelectionText := FHideSelectionText;
      Self.FHighlight := FHighlight;
      Self.FHighlightText := FHighlightText;
      Self.FHottrack := FHottrack;
      Self.FHottrackText := FHottrackText;
    end;

    DoChange;
  end else
    inherited Assign(Source);
end;

constructor TSCPictureListerColors.Create(AOwner: TSCCustomPictureLister);
begin
  inherited Create;
  FOwner := AOwner;

  FBackground := clWindow;
  FCaption := clNone;
  FDefault := clBtnFace;
  FDescription := clNone;
  FFrame := clNone;
  FHideSelection := clBtnShadow;
  FHideSelectionText := clHighlightText;
  FHighlight := clHighlight;
  FHighlightText := clHighlightText;
  FHottrack := clPurple;
  FHottrackText := clWhite;
end;

procedure TSCPictureListerColors.DoChange;
begin
  if FOwner <> nil then
    FOwner.ColorsChanged(Self);
end;

function TSCPictureListerColors.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCPictureListerColors.SetBackground(Value: TColor);
begin
  if FBackground <> Value then
  begin
    FBackground := Value;
    DoChange;
  end;
end;

procedure TSCPictureListerColors.SetCaption(Value: TColor);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    DoChange;
  end;
end;

procedure TSCPictureListerColors.SetDefault(Value: TColor);
begin
  if FDefault <> Value then
  begin
    FDefault := Value;
    DoChange;
  end;
end;

procedure TSCPictureListerColors.SetDescription(Value: TColor);
begin
  if FDescription <> Value then
  begin
    FDescription := Value;
    DoChange;
  end;
end;

procedure TSCPictureListerColors.SetFrame(Value: TColor);
begin
  if FFrame <> Value then
  begin
    FFrame := Value;
    DoChange;
  end;
end;

procedure TSCPictureListerColors.SetHideSelection(Value: TColor);
begin
  if FHideSelection <> Value then
  begin
    FHideSelection := Value;
    DoChange;
  end;
end;

procedure TSCPictureListerColors.SetHideSelectionText(Value: TColor);
begin
  if FHideSelectionText <> Value then
  begin
    FHideSelectionText := Value;
    DoChange;
  end;
end;

procedure TSCPictureListerColors.SetHighlight(Value: TColor);
begin
  if FHighlight <> Value then
  begin
    FHighlight := Value;
    DoChange;
  end;
end;

procedure TSCPictureListerColors.SetHighlightText(Value: TColor);
begin
  if FHighlightText <> Value then
  begin
    FHighlightText := Value;
    DoChange;
  end;
end;

procedure TSCPictureListerColors.SetHottrack(Value: TColor);
begin
  if FHottrack <> Value then
  begin
    FHottrack := Value;
    DoChange;
  end;
end;

procedure TSCPictureListerColors.SetHottrackText(Value: TColor);
begin
  if FHottrackText <> Value then
  begin
    FHottrackText := Value;
    DoChange;
  end;
end;

{ TSCCustomPictureLister }

procedure TSCCustomPictureLister.CaptionFontChanged(Sender: TObject);
begin
  FCaptionHeight := -1;

  if (scpoShowCaption in FOptions) and (PictureList <> nil) and
    (PictureList.Count > 0) then
  begin
    UpdateList;
    UpdateScrollbars(True, True);
  end;
end;

procedure TSCCustomPictureLister.CMFontChanged(var Message: TMessage);
begin
  FDescriptionHeight := -1;
  inherited;

  if (scpoShowDescription in FOptions) and (PictureList <> nil) and
    (PictureList.Count > 0) then
    UpdateScrollbars(True, True);
end;

procedure TSCCustomPictureLister.ColorsChanged(Sender: TObject);
begin
  UpdateList;
end;

constructor TSCCustomPictureLister.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColors := TSCPictureListerColors.Create(Self);

  DoubleBuffered := True;
  SetBounds(Left, Top, 210, 134);
  ParentColor := False;
  Color := clWindow;
  Indent := 8;
  Spacing := 8;
  Border := sccb3DLowered;

  FHotIndex := -1;
  FSelectedIndex := -1;
  FMouseDownIndex := -1;

  FCaptionHeight := -1;
  FDescriptionHeight := -1;

  FAlignment := taCenter;
  FCaptionFont := TFont.Create;
  FCaptionFont.OnChange := CaptionFontChanged;

  FDescriptions := 1;

  FColumns := 0;
  FFrame := scpfSingle;
  FOptions := SCDefaultPictureListerOptions;
  FPictureHeight := 80;
  FPictureWidth := 80;
  FShowScrollbars := True;
end;

procedure TSCCustomPictureLister.CreateWnd;
begin
  Inc(FCreatingWnd);
  try
    inherited CreateWnd;
  finally
    Dec(FCreatingWnd);
  end;
  UpdateScrollbars(True, True);
end;

destructor TSCCustomPictureLister.Destroy;
begin
  FCaptionFont.OnChange := nil;
  FreeAndNil(FCaptionFont);
  FreeAndNil(FColors);
  inherited Destroy;
end;

procedure TSCCustomPictureLister.DoHottrack;
begin
  if Assigned(FOnHottrack) then
    FOnHottrack(Self);
end;

procedure TSCCustomPictureLister.DoPictureListChanged;
begin
  inherited DoPictureListChanged;
  UpdateScrollbars(True, True);
end;

procedure TSCCustomPictureLister.DoScrollerPositionChanged(Kind: TSCScrollbarKind);
var
  Sb: TSCImageBoxScrollbar;
begin
  if FScrollPosChanging = 0 then
  begin
    Inc(FScrollbarChanging);
    try
      if Kind = scskHorizontal then
      begin
        Sb := TSCImageBoxScrollbar(ScrollbarHorz);
        SetHorizontalPos(Sb.Position);
      end else
      begin
        Sb := TSCImageBoxScrollbar(ScrollbarVert);
        SetVerticalPos(Sb.Position);
      end;
    finally
      Dec(FScrollbarChanging);
    end;
  end;

  UpdateHottrack;
end;

procedure TSCCustomPictureLister.DrawBox(C: TCanvas; Index, X, Y: Integer);
var
  Text: String;
  R, R2: TRect;
  Cl, Cl2: TColor;
  Pi: TSCPictureListItem;
  HasCaption, HasDesc: Boolean;
  I, F, Fs, Ch, Dh, Bw, Bh: Integer;
begin
  if (Index > -1) and (PictureList <> nil) and (Index < PictureList.Count) then
  begin
    Pi := PictureList.Pictures[Index];

    Ch := GetCaptionHeight;
    Dh := GetDescriptionHeight;

    HasDesc := (scpoShowDescription in FOptions) and (Dh > 0);
    HasCaption := (scpoShowCaption in FOptions) and (Ch > 0);

    Bh := GetBoxHeight;
    Bw := GetBoxWidth;

    Cl := FColors.Default;

    if FSelectedIndex = Index then
    begin
      if HasFocus then
        Cl := FColors.Highlight
      else if scpoHideSelection in FOptions then
        Cl := FColors.HideSelection;
    end;

    if (scpoHottrack in FOptions) and (FHotIndex = Index) and
      (FColors.Hottrack <> clNone) then
    begin
      Cl2 := Cl;
      Cl := FColors.Hottrack;

      if (FSelectedIndex = Index) and (Cl2 <> clNone) then
        Cl := SCCommon.MixColors(Cl, Cl2, 50);
    end;

    Fs := GetFrameSize;

    R := Rect(X, Y, X + Bw, Y + Bh);
    InflateRect(R, -Fs, -Fs);

    if Cl <> clNone then
      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R);
      end;

    R := Rect(0, 0, FPictureWidth + 2*FSpaceHorz, FPictureHeight + 2*FSpaceVert);
    OffsetRect(R, X + Fs, Y + Fs + Ch);

    if (FSpaceHorz > 0) or (FSpaceVert > 0) then
      Cl := FColors.FBackground;

    if Cl <> clNone then
      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R);
      end;

    InflateRect(R, -FSpaceHorz, -FSpaceVert);
    
    if (Pi.Picture <> nil) and (Pi.Picture.Graphic <> nil) and
      not Pi.Picture.Graphic.Empty then
      C.StretchDraw(R, Pi.Picture.Graphic);

    if HasCaption then
    begin
      R := Rect(0, 0, Bw - 2*Fs, Ch);
      OffsetRect(R, X + Fs, Y + Fs);

      Cl := FCaptionFont.Color;
      
      if FColors.FCaption = clNone then
      begin
        if FSelectedIndex = Index then
        begin
          if HasFocus then
            Cl := FColors.HighlightText
          else if scpoHideSelection in FOptions then
            Cl := FColors.HideSelectionText;
        end;

        if (scpoHottrack in FOptions) and (FHotIndex = Index) and
          (FColors.HottrackText <> clNone) then
          Cl := FColors.HottrackText;
      end else
      begin
        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FColors.FCaption;

          FillRect(R);
        end;
      end;

      InflateRect(R, -1, 0);

      if Cl = clNone then
      begin
        Cl := FCaptionFont.Color;
        if Cl = clNone then Cl := clWindowText;
      end;

      F := DT_SINGLELINE or DT_NOPREFIX or DT_END_ELLIPSIS or DT_EXPANDTABS or
        DT_LEFT or DT_VCENTER or DT_EDITCONTROL;

      if FAlignment = taRightJustify then
        F := F or DT_RIGHT
      else if FAlignment = taCenter then
        F := F or DT_CENTER;

      Text := Pi.Caption;

      if Text <> '' then
        with Canvas do
        begin
          Brush.Style := bsClear;
          Font := Self.CaptionFont;
          Font.Color := Cl;

          DrawText(Handle, PChar(Text), Length(Text), R, F);
        end;
    end;

    if HasDesc then
    begin
      R := Rect(0, 0, Bw - 2*Fs, Dh);
      OffsetRect(R, X + Fs, Y + Fs + Ch + FPictureHeight + 2*FSpaceVert);

      Cl := Font.Color;
        
      if FColors.FDescription = clNone then
      begin
        if FSelectedIndex = Index then
        begin
          if HasFocus then
            Cl := FColors.HighlightText
          else if scpoHideSelection in FOptions then
            Cl := FColors.HideSelectionText;
        end;

        if (scpoHottrack in FOptions) and (FHotIndex = Index) and
          (FColors.HottrackText <> clNone) then
          Cl := FColors.HottrackText;
      end else
      begin
        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FColors.FDescription;

          FillRect(R);
        end;
      end;

      InflateRect(R, -1, 0);

      if Cl = clNone then
      begin
        Cl := Self.Font.Color;
        if Cl = clNone then Cl := clWindowText;
      end;

      F := DT_SINGLELINE or DT_NOPREFIX or DT_END_ELLIPSIS or DT_EXPANDTABS or
        DT_LEFT or DT_VCENTER or DT_EDITCONTROL;

      if FAlignment = taRightJustify then
        F := F or DT_RIGHT
      else if FAlignment = taCenter then
        F := F or DT_CENTER;

      if FDescriptions > 1 then
        F := F and not (DT_SINGLELINE or DT_END_ELLIPSIS) or DT_WORDBREAK;

      Text := Pi.Description.Text;

      if Text <> '' then
        with Canvas do
        begin
          Brush.Style := bsClear;
          Font := Self.Font;
          Font.Color := Cl;

          if (FHotIndex = Index) and (scpoHottrack in FOptions) and
            (scpoHottrackUnderline in FOptions) then
            Font.Style := Font.Style + [fsUnderline];

          DrawText(Handle, PChar(Text), Length(Text), R, F);
        end;
    end;

    if (FFrame <> scpfNone) or (FFrameSize > 0) then
    begin
      R := Rect(X, Y, X + Bw, Y + Bh);

      Cl := FColors.Default;
      if FSelectedIndex = Index then
      begin
        if HasFocus then
          Cl := FColors.Highlight
        else if scpoHideSelection in FOptions then
          Cl := FColors.HideSelection;
      end;

      if (scpoHottrack in FOptions) and (FHotIndex = Index) and
        (FColors.Hottrack <> clNone) then
        Cl := FColors.Hottrack;

      if (FFrameSize > 0) and (Cl <> clNone) then
      begin
        R2 := R;
        Dec(Fs, FFrameSize);
        InflateRect(R2, -Fs, -Fs);

        for I := 0 to FFrameSize - 1 do
          scFrame3D(Canvas, R2, Cl, Cl, 1, 0);
      end;

      if FFrame <> scpfNone then
      begin
        Cl2 := Cl;
        if not (FFrame in [scpfSingle, scpfDouble, scpfRoundedDouble]) then
          Cl := clBtnFace
        else
        if Cl = clNone then
        begin
          Cl := Self.Color;
          if Cl = clNone then Cl := clWindow;
        end;

        if FColors.Frame <> clNone then
        begin
          Cl := FColors.Frame;
          Cl2 := FColors.Frame;
        end;

        case FFrame of
          scpfBumped:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccbBumped);
          scpfEtched:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccbEtched);
          scpfSingle:
            if Cl2 <> clNone then
              scDrawBevel(Canvas, R, Cl, clNone, False, sccbFlat);
          scpfDouble:
            if Cl2 <> clNone then
              scDrawBevel(Canvas, R, Cl, clNone, False, sccbFlatBold);
          scpfLowered:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccbLowered);
          scpf3DLowered:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccb3DLowered);
          scpfRaised:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccbRaised);
          scpf3DRaised:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccb3DRaised);
          scpfRoundedDouble:
            if Cl2 <> clNone then
              scDrawBevel(Canvas, R, Cl, clNone, False, sccbFlatBoldRounded);
          scpfMetal:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccbSoftRaised);
        end;
      end;  
    end;
  end;
end;

procedure TSCCustomPictureLister.EnabledChanged;
begin
  UpdateHottrack;
end;

procedure TSCCustomPictureLister.EnsureHorizontalPos(var P: Integer);
var
  CR: TRect;
  Mx, Cols: Integer;
begin
  if (P < 0) or IsDesigning then
    P := 0
  else begin
    Cols := GetColumns;

    CR := ClientRect;
    OffsetRect(CR, -CR.Left, -CR.Top);

    if IsRectEmpty(CR) or (Cols = 0) then
    begin
      P := 0;
      Exit;
    end;

    Mx := Cols*GetBoxWidth + (Cols - 1)*Spacing + 2*Indent - CR.Right;

    if Mx <= 0 then P := 0
    else if (Mx > 0) and (P > Mx) then
      P := Mx;
  end;
end;

procedure TSCCustomPictureLister.EnsureVerticalPos(var P: Integer);
var
  CR: TRect;
  Mx, Cols, Rows: Integer;
begin
  if (P < 0) or IsDesigning then
    P := 0
  else begin
    Cols := GetColumns;

    CR := ClientRect;
    OffsetRect(CR, -CR.Left, -CR.Top);

    if IsRectEmpty(CR) or (Cols = 0) then
    begin
      P := 0;
      Exit;
    end;

    Rows := (Count - 1) div Cols;
    if Cols > 1 then Inc(Rows);

    Mx := Rows*GetBoxHeight + (Rows - 1)*Spacing + 2*Indent - CR.Bottom;

    if Mx <= 0 then P := 0
    else if (Mx > 0) and (P > Mx) then
      P := Mx;
  end;
end;

function TSCCustomPictureLister.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCImageBorderProps;
end;

function TSCCustomPictureLister.GetBoxHeight: Integer;
begin
  Result := 2*(GetFrameSize + FSpaceVert) + GetCaptionHeight +
    FPictureHeight + GetDescriptionHeight;
end;

function TSCCustomPictureLister.GetBoxWidth: Integer;
begin
  Result := 2*(GetFrameSize + FSpaceHorz) + FPictureWidth;
end;

function TSCCustomPictureLister.GetCaptionHeight: Integer;
begin
  Result := 0;
  if scpoShowCaption in FOptions then
  begin
    if FCaptionHeight < 0 then
    begin
      Canvas.Font := FCaptionFont;
      FCaptionHeight := Canvas.TextHeight('Wq');

      Inc(FCaptionHeight, (FCaptionHeight div 5) + 2);
    end;

    Result := FCaptionHeight;
  end;
end;

function TSCCustomPictureLister.GetColumns: Integer;
var
  CR: TRect;
  C, Fs: Integer;
begin
  Result := FColumns;
  if Result > 0 then Exit;

  CR := ClientRect;
  InflateRect(CR, -Indent, -Indent);
  
  OffsetRect(CR, -CR.Left, -CR.Top);

  C := CR.Right;
  if C < 0 then C := 0;

  Fs := GetFrameSize;

  Result := C div (2*(Fs + FSpaceHorz) + FPictureWidth);
  if Result > 1 then
    Result := (C - (Result - 1)*Spacing) div (2*(Fs + FSpaceHorz) + FPictureWidth);

  if Result = 0 then Result := 1;
end;

function TSCCustomPictureLister.GetControlScrollbarsClass: TSCControlCustomScrollbarsClass;
begin
  Result := TSCPictureListerScrollbars;
end;

function TSCCustomPictureLister.GetCount: Integer;
begin
  Result := 0;
  if PictureList <> nil then Result := PictureList.Count;
end;

function TSCCustomPictureLister.GetDescriptionHeight: Integer;
begin
  Result := 0;
  if scpoShowDescription in FOptions then
  begin
    if FDescriptionHeight < 0 then
    begin
      Canvas.Font := Self.Font;
      FDescriptionHeight := Canvas.TextHeight('Wq');
    end;

    Result := FDescriptions*FDescriptionHeight;
    if Result > 0 then Inc(Result, FDescriptionHeight div 5);
  end;
end;

function TSCCustomPictureLister.GetDrawRect: TRect;
var
  Cols, Rows, Bw, Bh: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (PictureList <> nil) and (PictureList.Count > 0) then
  begin
    Cols := GetColumns;
    Rows := (PictureList.Count - 1) div Cols;
    if Cols > 1 then Inc(Rows);

    Bw := GetBoxWidth;
    Bh := GetBoxHeight;

    Result.Right := Cols*Bw + (Cols - 1)*Spacing + Indent;
    Result.Bottom := Rows*Bh + (Rows - 1)*Spacing + Indent;

    OffsetRect(Result, Indent, Indent);
  end;
end;

function TSCCustomPictureLister.GetFrameSize: Integer;
begin
  Result := 0;
  if FFrame in [scpfSingle, scpfLowered, scpfRaised] then
    Result := 1
  else if FFrame <> scpfNone then
    Result := 2;

  Inc(Result, FFrameSize);
end;

function TSCCustomPictureLister.GetPicture: TPicture;
begin
  Result := Picture;
end;

function TSCCustomPictureLister.GetPictureAtPos(X, Y: Integer): Integer;
var
  P: TPoint;
  R, CR: TRect;
  Row, Col, Cols,
  Bw, Bh, Index: Integer;
begin
  Result := -1;
  if (PictureList <> nil) and (PictureList.Count > 0) then
  begin
    CR := ClientRect;
    P := Point(X, Y);

    if not IsRectEmpty(CR) and PtInRect(CR, P) then
    begin
      Bw := GetBoxWidth;
      Bh := GetBoxHeight;

      Col := (X + FHorizontalPos - Indent) div (Bw + Spacing);
      Row := (Y + FVerticalPos - Indent) div (Bh + Spacing);

      Cols := GetColumns;

      if Col < Cols then
      begin
        Index := Col + Row*Cols;

        if (Index > -1) and (Index < PictureList.Count) then
        begin
          R.Left := Col*(Bw + Spacing) + Indent - FHorizontalPos;
          R.Top := Row*(Bh + Spacing) + Indent - FVerticalPos;

          R.Right := R.Left + Bw;
          R.Bottom := R.Top + Bh;

          if not IsRectEmpty(R) and PtInRect(R, P) then
          begin
            Result := Index;
            Exit;
          end;
        end;
      end;
    end;  
  end;
end;

function TSCCustomPictureLister.GetPictureRect(Index: Integer): TRect;
var
  Bw, Bh, Cols, Row, Col: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (Index > -1) and (Index < Count) then
  begin
    Cols := GetColumns;

    Row := Index div Cols;
    Col := Index mod Cols;

    Bw := GetBoxWidth;
    Bh := GetBoxHeight;

    Result.Left := Indent + Col*(Bw + Spacing);
    Result.Top  := Indent + Row*(Bh + Spacing);

    Result.Right  := Result.Left + Bw;
    Result.Bottom := Result.Top + Bh;
  end;
end;

function TSCCustomPictureLister.GetScrollbarClass: TSCCustomControlScrollbarClass;
begin
  Result := TSCPictureListerScrollbar;
end;

procedure TSCCustomPictureLister.IndentChanged;
begin
  inherited IndentChanged;
  if (PictureList <> nil) and (PictureList.Count > 0) then
    UpdateScrollbars(True, True);
end;

function TSCCustomPictureLister.InView(Index: Integer;
  PartitialAllowed: Boolean): Boolean;
var
  CR, R, R1: TRect;
begin
  Result := False;
  if (Index > -1) and (PictureList <> nil) and (Index < PictureList.Count) then
  begin
    CR := ClientRect;

    if not IsRectEmpty(CR) then
    begin
      R := GetPictureRect(Index);
      OffsetRect(R, -FHorizontalPos, -FVerticalPos);
      
      Result := not IsRectEmpty(R) and IntersectRect(R1, R, CR);

      if Result and not PartitialAllowed then
        Result := EqualRect(R, R1);
    end;
  end;
end;

procedure TSCCustomPictureLister.KeyDown(var Key: Word; Shift: TShiftState);
var
  Index, Cols, Col, Row: Integer;
begin
  inherited KeyDown(Key, Shift);

  FMouseDownIndex := -1;

  if (PictureList <> nil) and (PictureList.Count > 0) then
  begin
    Index := FSelectedIndex;
    Cols := GetColumns;

    Row := Index div Cols;
    Col := Index mod Cols;

    case Key of
      VK_LEFT:
      begin
        Dec(Col);

        if Col < 0 then
        begin
          Col := Cols - 1;
          Dec(Row);
        end;
      end;
      VK_RIGHT:
      begin
        Inc(Col);

        if Col > Cols then
        begin
          Col := 0;
          Inc(Row);
        end;
      end;
      VK_UP:
        Dec(Row);
      VK_DOWN:
        Inc(Row);
      VK_PRIOR:
        Dec(Row, 3);
      VK_NEXT:
        Inc(Row, 3);
      VK_HOME:
      begin
        Col := 0;
        Row := 0;
      end;
      VK_END:
      begin
        Row := PictureList.Count div Cols;
        Col := PictureList.Count mod Cols;
      end;
    end;

    Index := Row*Cols + Col;
    if Index < 0 then Index := 0;

    if Index > PictureList.Count-1 then
      Index := PictureList.Count-1;

    if Index <> FSelectedIndex then
    begin
      MakeVisible(Index);
      SetSelectedIndex(Index);
    end;
  end;
end;

procedure TSCCustomPictureLister.Loaded;
begin
  inherited Loaded;
  if (PictureList <> nil) and (PictureList.Count > 0) then
    UpdateScrollbars(True, True);
end;

procedure TSCCustomPictureLister.MakeVisible(Index: Integer);
var
  R: TRect;
  Cols, Col, Row: Integer;
begin
  if (Index > -1) and (PictureList <> nil) and
    (Index < PictureList.Count) and not InView(Index, False) then
  begin
    Cols := GetColumns;

    Row := Index div Cols;
    Col := Index mod Cols;

    R := Rect(0, 0, 0, 0);
    if (Col > 0) or (Row > 0) then
    begin
      R := GetPictureRect(Index);

      if IsRectEmpty(R) then
        Exit;

      if Col = 0 then OffsetRect(R, -Indent, 0)
      else OffsetRect(R, -Spacing, 0);

      if Row = 0 then OffsetRect(R, 0, -Indent)
      else OffsetRect(R, 0, -Spacing);
    end;

    SetHorizontalPos(R.Left);
    SetVerticalPos(R.Top);
  end;
end;

procedure TSCCustomPictureLister.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldIndex, OldHot: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if CanFocus then
    SetFocus;

  OldHot := FHotIndex;
  FHotIndex := GetPictureAtPos(X, Y);

  OldIndex := FSelectedIndex;
  FMouseDownIndex := -1;

  if Button = mbLeft then
  begin
    FMouseDownIndex := FHotIndex;

    FSelectedIndex := FHotIndex;
    if FSelectedIndex = -1 then FSelectedIndex := OldIndex;
  end;

  if (OldHot <> FHotIndex) or (FSelectedIndex <> OldIndex) then
  begin
    UpdateList;

    if OldHot <> FHotIndex then
      DoHottrack;

    if FSelectedIndex <> OldIndex then
      Change;
  end;
end;

procedure TSCCustomPictureLister.MouseInControlChanged;
begin
  inherited MouseInControlChanged;
  UpdateHottrack;
end;

procedure TSCCustomPictureLister.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  OldIndex, OldHot: Integer;
begin
  OldHot := FHotIndex;
  FHotIndex := GetPictureAtPos(X, Y);

  OldIndex := FSelectedIndex;
  if (FMouseDownIndex > -1) and (FHotIndex > -1) then
    FSelectedIndex := FHotIndex;

  if (OldHot <> FHotIndex) or (FSelectedIndex <> OldIndex) then
  begin
    UpdateList;

    if OldHot <> FHotIndex then
      DoHottrack;

    if FSelectedIndex <> OldIndex then
      Change;
  end;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomPictureLister.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldIndex, OldHot: Integer;
begin
  OldHot := FHotIndex;
  FHotIndex := GetPictureAtPos(X, Y);

  OldIndex := FSelectedIndex;

  if FMouseDownIndex > -1 then
  begin
    FMouseDownIndex := -1;

    FSelectedIndex := FHotIndex;
    if FSelectedIndex = -1 then FSelectedIndex := OldIndex;
  end;

  if (OldHot <> FHotIndex) or (FSelectedIndex <> OldIndex) then
  begin
    UpdateList;

    if OldHot <> FHotIndex then
      DoHottrack;

    if FSelectedIndex <> OldIndex then
      Change;
  end;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomPictureLister.Paint;
var
  CR: TRect;
  Cl: TColor;
  Bw, Bh, I, Cols,
  Col, Row, X, Y: Integer;
begin
  if not HandleAllocated then
    Exit;

  Inc(FDrawing);
  try
    CR := ClientRect;
    OffsetRect(CR, -CR.Left, -CR.Top);

    if IsRectEmpty(CR) then
      Exit;

    Cl := Self.Color;
    if Cl = clNone then Cl := clWindow;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;
      FillRect(CR);

      if Transparent then
        PaintParentOn(Canvas);
    end;

    DrawPicture(Canvas);

    if PictureList <> nil then
    begin
      Bw := GetBoxWidth;
      Bh := GetBoxHeight;
      
      Cols := GetColumns;

      for I := 0 to PictureList.Count-1 do
      begin
        Row := I div Cols;
        Col := I mod Cols;

        X := Indent + Col*(Bw + Spacing) - FHorizontalPos;
        Y := Indent + Row*(Bh + Spacing) - FVerticalPos;

        DrawBox(Canvas, I, X, Y);
      end;
    end;
  finally
    Dec(FDrawing);
  end;
end;

procedure TSCCustomPictureLister.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    UpdateList;
  end;
end;

procedure TSCCustomPictureLister.SetCaptionFont(Value: TFont);
begin
  FCaptionFont.Assign(Value);
end;

procedure TSCCustomPictureLister.SetColors(Value: TSCPictureListerColors);
begin
  FColors.Assign(Value);
end;

procedure TSCCustomPictureLister.SetColumns(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FColumns <> Value then
  begin
    FColumns := Value;

    if (PictureList <> nil) and (PictureList.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomPictureLister.SetDescriptions(Value: Integer);
begin
  if FDescriptions <> Value then
  begin
    FDescriptions := Value;

    if (PictureList <> nil) and (PictureList.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomPictureLister.SetFrame(Value: TSCPictureListerFrame);
begin
  if FFrame <> Value then
  begin
    FFrame := Value;

    if (PictureList <> nil) and (PictureList.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomPictureLister.SetFrameSize(Value: Integer);
begin
  if Value < 0 then Value := 0;
  
  if FFrameSize <> Value then
  begin
    FFrameSize := Value;

    if (PictureList <> nil) and (PictureList.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomPictureLister.SetHorizontalPos(Value: Integer);
begin
  Inc(FScrollPosChanging);
  try
    EnsureHorizontalPos(Value);

    if FHorizontalPos <> Value then
    begin
      FHorizontalPos := Value;
      UpdateScrollbars(True, True);
    end;

    if FScrollbarChanging = 0 then
      TSCImageBoxScrollbar(ScrollbarHorz).Position := FHorizontalPos;
  finally
    Dec(FScrollPosChanging);
  end;
end;

procedure TSCCustomPictureLister.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;
  inherited SetIndent(Value);
end;

procedure TSCCustomPictureLister.SetOptions(Value: TSCPictureListerOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;

    if (PictureList <> nil) and (PictureList.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;

    UpdateHottrack(True);
  end;
end;

procedure TSCCustomPictureLister.SetPictureHeight(Value: Integer);
begin
  if Value < 4 then Value := 4;

  if FPictureHeight <> Value then
  begin
    FPictureHeight := Value;

    if (PictureList <> nil) and (PictureList.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomPictureLister.SetPictureWidth(Value: Integer);
begin
  if Value < 4 then Value := 4;

  if FPictureWidth <> Value then
  begin
    FPictureWidth := Value;

    if (PictureList <> nil) and (PictureList.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;  
  end;
end;

procedure TSCCustomPictureLister.SetSelectedIndex(Value: Integer);
begin
  if Value < -1 then Value := -1;

  if FSelectedIndex <> Value then
  begin
    FSelectedIndex := Value;
    
    UpdateList;
    Change;
  end;
end;

procedure TSCCustomPictureLister.SetShowScrollbars(Value: Boolean);
begin
  if FShowScrollbars <> Value then
  begin
    FShowScrollbars := Value;
    if (PictureList <> nil) and (PictureList.Count > 0) then
      UpdateScrollbars(True, True);
  end;
end;

procedure TSCCustomPictureLister.SetSpaceHorz(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FSpaceHorz <> Value then
  begin
    FSpaceHorz := Value;

    if (PictureList <> nil) and (PictureList.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomPictureLister.SetSpaceVert(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FSpaceVert <> Value then
  begin
    FSpaceVert := Value;

    if (PictureList <> nil) and (PictureList.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomPictureLister.SetVerticalPos(Value: Integer);
begin
  Inc(FScrollPosChanging);
  try
    EnsureVerticalPos(Value);

    if FVerticalPos <> Value then
    begin
      FVerticalPos := Value;
      UpdateScrollbars(True, True);
    end;

    if FScrollbarChanging = 0 then
      TSCImageBoxScrollbar(ScrollbarVert).Position := FVerticalPos;
  finally
    Dec(FScrollPosChanging);
  end;
end;

procedure TSCCustomPictureLister.SpacingChanged;
begin
  inherited SpacingChanged;
  if (PictureList <> nil) and (PictureList.Count > 0) then
    UpdateScrollbars(True, True);
end;

procedure TSCCustomPictureLister.StopTracking;
begin
  FMouseDownIndex := -1;
  UpdateHottrack;
end;

function TSCCustomPictureLister.UpdateHorzScrollBar: Boolean;
var
  R: TRect;
  ScrlVisible: Boolean;
  SiOld, SiNew: TSCScrollInfo;
begin
  Result := False;
  if HandleAllocated and (FCreatingWnd = 0) and not IsLoading then
  begin
    SiOld := Self.GetScrollbarInfo(scskHorizontal);
    ScrlVisible := SiOld.Visible and (SiOld.Page <= SiOld.Max);

    SiNew := SiOld;

    SiNew.Page := 1;
    SiNew.Min  := 0;
    SiNew.Max  := 0;
    SiNew.Pos  := 0;

    if FShowScrollbars then
    begin
      R := GetDrawRect;
      R.Left := 0;
      R.Top := 0;

      SiNew.Page := Self.ClientWidth;
      SiNew.Min  := 0;
      SiNew.Max  := R.Right;

      if SiNew.Max < 0 then
        SiNew.Max := 0;

      EnsureHorizontalPos(FHorizontalPos);
      SiNew.Pos  := FHorizontalPos;
    end;

    SiNew.SmallChange := 20;
    SiNew.LargeChange := SiNew.Page;

    if (SiNew.Min <> SiOld.Min) or (SiNew.Max <> SiOld.Max) or
      (SiNew.Page <> SiOld.Page) or (SiNew.Pos <> SiOld.Pos) then
    begin
      SiNew.Visible := SiNew.Page < SiNew.Max;
      Self.SetScrollbarInfo(scskHorizontal, SiNew);

      if Integer(SiNew.Page) > SiNew.Max then
        SetHorizontalPos(SiNew.Min);
    end;

    Invalidate;
    Result := ScrlVisible <> (Integer(SiNew.Page) <= SiNew.Max);
  end;
end;

procedure TSCCustomPictureLister.UpdateHottrack(Draw: Boolean);
var
  P: TPoint;
  OldHot: Integer;
begin
  OldHot := FHotIndex;
  FHotIndex := -1;

  if HandleAllocated and (scpoHottrack in FOptions) and
    not IsDesigning and GetCursorPos(P) then
  begin
    P := Self.ScreenToClient(P);
    FHotIndex := GetPictureAtPos(P.x, P.y);
  end;

  if Draw and (OldHot <> FHotIndex) then
    UpdateList;

  if not IsDesigning and (FHotIndex <> OldHot) then
    DoHottrack;
end;

procedure TSCCustomPictureLister.UpdateList;
begin
  if (PictureList <> nil) and (PictureList.Count > 0) then
    Invalidate;
end;

procedure TSCCustomPictureLister.UpdateScrollbars(Horz, Vert: Boolean);
var
  WasHorz, IsVert, IsHorz: Boolean;
begin
  if Horz or Vert then
  begin
    if Horz then ScrollbarHorz.BeginUpdate;
    if Vert then ScrollbarVert.BeginUpdate;

    WasHorz := TSCImageBoxScrollbar(ScrollbarHorz).Visible;
    try
      if Vert then UpdateVertScrollBar;
      if Horz then UpdateHorzScrollBar;

      IsVert := TSCImageBoxScrollbar(ScrollbarVert).Visible;
      IsHorz := TSCImageBoxScrollbar(ScrollbarHorz).Visible;

      if IsVert and (WasHorz <> IsHorz) then
        UpdateVertScrollBar;
    finally
      if Horz then ScrollbarHorz.EndUpdate;
      if Vert then ScrollbarVert.EndUpdate;
    end;
  end;
end;

function TSCCustomPictureLister.UpdateVertScrollBar: Boolean;
var
  R: TRect;
  ScrlVisible: Boolean;
  SiOld, SiNew: TSCScrollInfo;
begin
  Result := False;
  if HandleAllocated and (FCreatingWnd = 0) and not IsLoading then
  begin
    SiOld := Self.GetScrollbarInfo(scskVertical);
    ScrlVisible := SiOld.Visible and (SiOld.Page < SiOld.Max);

    SiNew := SiOld;

    SiNew.Page := 1;
    SiNew.Min  := 0;
    SiNew.Max  := 0;
    SiNew.Pos  := 0;

    if FShowScrollbars then
    begin
      R := GetDrawRect;
      R.Left := 0;
      R.Top := 0;

      SiNew.Page := Self.ClientHeight;
      SiNew.Min  := 0;
      SiNew.Max  := R.Bottom;

      if SiNew.Max < 0 then
        SiNew.Max := 0;

      EnsureVerticalPos(FVerticalPos);
      SiNew.Pos  := FVerticalPos;
    end;

    SiNew.SmallChange := 20;
    SiNew.LargeChange := SiNew.Page;

    if (SiNew.Min <> SiOld.Min) or (SiNew.Max <> SiOld.Max) or
      (SiNew.Page <> SiOld.Page) or (SiNew.Pos <> SiOld.Pos) then
    begin
      SiNew.Visible := SiNew.Page < SiNew.Max;
      Self.SetScrollbarInfo(scskVertical, SiNew);

      if Integer(SiNew.Page) > SiNew.Max then
        SetVerticalPos(SiNew.Min);
    end;

    Invalidate;
    Result := ScrlVisible <> (Integer(SiNew.Page) <= SiNew.Max);
  end;
end;

procedure TSCCustomPictureLister.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := DLGC_WANTARROWS;
end;

procedure TSCCustomPictureLister.WMHScroll(var Message: TWMHScroll);
var
  SI: TSCScrollInfo;
begin
  SI := Self.GetScrollbarInfo(scskHorizontal);

  case Message.ScrollCode of
    SB_LINEUP:
      SetHorizontalPos(FHorizontalPos - 20);
    SB_LINEDOWN:
      SetHorizontalPos(FHorizontalPos + 20);
    SB_PAGEUP:
      SetHorizontalPos(FHorizontalPos - Integer(SI.Page));
    SB_PAGEDOWN:
      SetHorizontalPos(FHorizontalPos + Integer(SI.Page));
    SB_THUMBPOSITION:
    begin
      if SI.Pos <= SI.Min then
        SetHorizontalPos(SI.Min)
      else
      if SI.Pos >= SI.Max then
        SetHorizontalPos(SI.Max)
      else
        SetHorizontalPos(SI.Pos);
    end;
    SB_TOP:
      SetHorizontalPos(SI.Min);
    SB_BOTTOM:
      SetHorizontalPos(SI.Max);
  end;
end;

procedure TSCCustomPictureLister.WMMouseWheel(var Message: TWMMouseWheel);
var
  SbVert, SbHorz: TSCImageBoxScrollbar;
begin
  if IsDesigning then
    Exit;

  SbHorz := TSCImageBoxScrollbar(ScrollbarHorz);
  SbVert := TSCImageBoxScrollbar(ScrollbarVert);

  if ((Message.Keys and MK_SHIFT) = MK_SHIFT) or (SbHorz.Visible and not SbVert.Visible) then
  begin
    if Message.WheelDelta < 0 then
      SetHorizontalPos(FHorizontalPos + 20)
    else
    if Message.WheelDelta > 0 then
      SetHorizontalPos(FHorizontalPos - 20);
  end else
  begin
    if Message.WheelDelta < 0 then
      SetVerticalPos(FVerticalPos + 20)
    else
    if Message.WheelDelta > 0 then
      SetVerticalPos(FVerticalPos - 20);
  end;
end;

procedure TSCCustomPictureLister.WMSize(var Message: TWMSize);
begin
  inherited;
  if (PictureList <> nil) and (PictureList.Count > 0) then
    UpdateScrollbars(True, True);
end;

procedure TSCCustomPictureLister.WMVScroll(var Message: TWMVScroll);
var
  SI: TSCScrollInfo;
begin
  SI := Self.GetScrollbarInfo(scskVertical);

  case Message.ScrollCode of
    SB_LINEUP:
      SetVerticalPos(FVerticalPos - 20);
    SB_LINEDOWN:
      SetVerticalPos(FVerticalPos + 20);
    SB_PAGEUP:
      SetVerticalPos(FVerticalPos - Integer(SI.Page));
    SB_PAGEDOWN:
      SetVerticalPos(FVerticalPos + Integer(SI.Page));
    SB_THUMBPOSITION:
    begin
      if SI.Pos <= SI.Min then
        SetVerticalPos(SI.Min)
      else
      if SI.Pos >= SI.Max then
        SetVerticalPos(SI.Max)
      else
        SetVerticalPos(SI.Pos);
    end;
    SB_TOP:
      SetVerticalPos(SI.Min);
    SB_BOTTOM:
      SetVerticalPos(SI.Max);
  end;
end;

{ TSCImageListerScrollbars }

procedure TSCImageListerScrollbars.Assign(Source: TPersistent);
begin
  if Source is TSCImageListerScrollbars then
    Self.Visible := TSCImageListerScrollbars(Source).Visible;

  inherited Assign(Source);
end;

function TSCImageListerScrollbars.GetVisible: Boolean;
begin
  Result := True;
  if Owner is TSCCustomImageLister then
    Result := TSCCustomImageLister(Owner).ShowScrollbars;
end;

procedure TSCImageListerScrollbars.SetVisible(Value: Boolean);
begin
  if Owner is TSCCustomImageLister then
    TSCCustomImageLister(Owner).ShowScrollbars := Value;
end;

{ TSCImageListerColors }

procedure TSCImageListerColors.Assign(Source: TPersistent);
begin
  if Source is TSCImageListerColors then
  begin
    with TSCImageListerColors(Source) do
    begin
      Self.FBackground := FBackground;
      Self.FCaption := FCaption;
      Self.FDefault := FDefault;
      Self.FFrame := FFrame;
      Self.FHideSelection := FHideSelection;
      Self.FHideSelectionText := FHideSelectionText;
      Self.FHighlight := FHighlight;
      Self.FHighlightText := FHighlightText;
      Self.FHottrack := FHottrack;
      Self.FHottrackText := FHottrackText;
    end;

    DoChange;
  end else
    inherited Assign(Source);
end;

constructor TSCImageListerColors.Create(AOwner: TSCCustomImageLister);
begin
  inherited Create;
  FOwner := AOwner;

  FBackground := clNone;
  FCaption := clNone;
  FDefault := clNone;
  FFrame := clNone;
  FHideSelection := clBtnShadow;
  FHideSelectionText := clHighlightText;
  FHighlight := clHighlight;
  FHighlightText := clHighlightText;
  FHottrack := clPurple;
  FHottrackText := clWhite;
end;

procedure TSCImageListerColors.DoChange;
begin
  if FOwner <> nil then
    FOwner.ColorsChanged(Self);
end;

function TSCImageListerColors.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCImageListerColors.SetBackground(Value: TColor);
begin
  if FBackground <> Value then
  begin
    FBackground := Value;
    DoChange;
  end;
end;

procedure TSCImageListerColors.SetCaption(Value: TColor);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    DoChange;
  end;
end;

procedure TSCImageListerColors.SetDefault(Value: TColor);
begin
  if FDefault <> Value then
  begin
    FDefault := Value;
    DoChange;
  end;
end;

procedure TSCImageListerColors.SetFrame(Value: TColor);
begin
  if FFrame <> Value then
  begin
    FFrame := Value;
    DoChange;
  end;
end;

procedure TSCImageListerColors.SetHideSelection(Value: TColor);
begin
  if FHideSelection <> Value then
  begin
    FHideSelection := Value;
    DoChange;
  end;
end;

procedure TSCImageListerColors.SetHideSelectionText(Value: TColor);
begin
  if FHideSelectionText <> Value then
  begin
    FHideSelectionText := Value;
    DoChange;
  end;
end;

procedure TSCImageListerColors.SetHighlight(Value: TColor);
begin
  if FHighlight <> Value then
  begin
    FHighlight := Value;
    DoChange;
  end;
end;

procedure TSCImageListerColors.SetHighlightText(Value: TColor);
begin
  if FHighlightText <> Value then
  begin
    FHighlightText := Value;
    DoChange;
  end;
end;

procedure TSCImageListerColors.SetHottrack(Value: TColor);
begin
  if FHottrack <> Value then
  begin
    FHottrack := Value;
    DoChange;
  end;
end;

procedure TSCImageListerColors.SetHottrackText(Value: TColor);
begin
  if FHottrackText <> Value then
  begin
    FHottrackText := Value;
    DoChange;
  end;
end;

{ TSCCustomImageLister }

procedure TSCCustomImageLister.CMFontChanged(var Message: TMessage);
begin
  FCaptionHeight := -1;
  inherited;

  if (scioShowNumbers in FOptions) and (Images <> nil) and (Images.Count > 0) then
    UpdateScrollbars(True, True);
end;

procedure TSCCustomImageLister.ColorsChanged(Sender: TObject);
begin
  UpdateList;
end;

constructor TSCCustomImageLister.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColors := TSCImageListerColors.Create(Self);

  DoubleBuffered := True;
  SetBounds(Left, Top, 185, 105);
  ParentColor := False;
  Color := clWindow;
  Indent := 8;
  Spacing := 8;
  Border := sccb3DLowered;

  FHotIndex := -1;
  FSelectedIndex := -1;
  FMouseDownIndex := -1;

  FCaptionHeight := -1;

  FAlignment := taCenter;
  FColumns := 0;
  FFrame := scifNone;
  FOptions := SCDefaultImageListerOptions;
  FPictureHeight := 80;
  FPictureWidth := 80;
  FShowScrollbars := True;
end;

procedure TSCCustomImageLister.CreateWnd;
begin
  Inc(FCreatingWnd);
  try
    inherited CreateWnd;
  finally
    Dec(FCreatingWnd);
  end;
  UpdateScrollbars(True, True);
end;

destructor TSCCustomImageLister.Destroy;
begin
  FreeAndNil(FColors);
  inherited Destroy;
end;

procedure TSCCustomImageLister.DoHottrack;
begin
  if Assigned(FOnHottrack) then
    FOnHottrack(Self);
end;

procedure TSCCustomImageLister.DoScrollerPositionChanged(Kind: TSCScrollbarKind);
var
  Sb: TSCImageBoxScrollbar;
begin
  if FScrollPosChanging = 0 then
  begin
    Inc(FScrollbarChanging);
    try
      if Kind = scskHorizontal then
      begin
        Sb := TSCImageBoxScrollbar(ScrollbarHorz);
        SetHorizontalPos(Sb.Position);
      end else
      begin
        Sb := TSCImageBoxScrollbar(ScrollbarVert);
        SetVerticalPos(Sb.Position);
      end;
    finally
      Dec(FScrollbarChanging);
    end;
  end;

  UpdateHottrack;
end;

procedure TSCCustomImageLister.DrawBox(C: TCanvas; Index, X, Y: Integer);
var
  Text: String;
  R, R2: TRect;
  Cl, Cl2: TColor;
  HasCaption: Boolean;
  ImageWidth, ImageHeight,
  I, F, Fs, Ch, Bw, Bh: Integer;
begin
  if (Index > -1) and (Images <> nil) and (Index < Images.Count) then
  begin
    Ch := GetCaptionHeight;
    HasCaption := (scioShowNumbers in FOptions) and (Ch > 0);

    Bh := GetBoxHeight;
    Bw := GetBoxWidth;

    Cl := FColors.Default;

    if FSelectedIndex = Index then
    begin
      if HasFocus then
        Cl := FColors.Highlight
      else if scioHideSelection in FOptions then
        Cl := FColors.HideSelection;
    end;

    if (scioHottrack in FOptions) and (FHotIndex = Index) and
      (FColors.Hottrack <> clNone) then
      Cl := FColors.Hottrack;

    Fs := GetFrameSize;

    R := Rect(X, Y, X + Bw, Y + Bh);
    InflateRect(R, -Fs, -Fs);

    if Cl <> clNone then
      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R);
      end;

    ImageHeight := GetImageHeight;
    ImageWidth := GetImageWidth;

    R := Rect(0, 0, ImageWidth + 2*FSpaceHorz, ImageHeight + 2*FSpaceVert);
    OffsetRect(R, X + Fs, Y + Fs);

    if (FSpaceHorz > 0) or (FSpaceVert > 0) then
      Cl := FColors.FBackground;

    if Cl <> clNone then
      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R);
      end;

    InflateRect(R, -FSpaceHorz, -FSpaceVert);

    Images.Draw(Canvas, R.Left, R.Top, Index, Self.Enabled);

    if HasCaption then
    begin
      R.Left := X + Fs;
      R.Right := R.Left + Bw - 2*Fs;

      R.Bottom := Y + Bh - Fs;
      R.Top := R.Bottom - Ch;

      Cl := Self.Font.Color;

      if FColors.FCaption = clNone then
      begin
        if FSelectedIndex = Index then
        begin
          if HasFocus then
            Cl := FColors.HighlightText
          else if scioHideSelection in FOptions then
            Cl := FColors.HideSelectionText;
        end;

        if (scioHottrack in FOptions) and (FHotIndex = Index) and
          (FColors.HottrackText <> clNone) then
          Cl := FColors.HottrackText;
      end else
      begin
        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FColors.FCaption;

          FillRect(R);
        end;
      end;

      InflateRect(R, -1, 0);

      if Cl = clNone then
      begin
        Cl := Self.Font.Color;
        if Cl = clNone then Cl := clWindowText;
      end;

      F := DT_SINGLELINE or DT_NOPREFIX or DT_END_ELLIPSIS or DT_EXPANDTABS or
        DT_LEFT or DT_VCENTER or DT_EDITCONTROL;

      if FAlignment = taRightJustify then
        F := F or DT_RIGHT
      else if FAlignment = taCenter then
        F := F or DT_CENTER;

      Text := IntToStr(Index);

      with Canvas do
      begin
        Brush.Style := bsClear;
        Font := Self.Font;
        Font.Color := Cl;

        if (scioHottrackUnderline in FOptions) and (FHotIndex = Index) then
          Font.Style := Font.Style + [fsUnderline];

        DrawText(Handle, PChar(Text), Length(Text), R, F);
      end;
    end;

    if (FFrame <> scifNone) or (FFrameSize > 0) then
    begin
      R := Rect(X, Y, X + Bw, Y + Bh);

      Cl := FColors.Default;
      if FSelectedIndex = Index then
      begin
        if HasFocus then
          Cl := FColors.Highlight
        else if scioHideSelection in FOptions then
          Cl := FColors.HideSelection;
      end;

      if (scioHottrack in FOptions) and (FHotIndex = Index) and
        (FColors.Hottrack <> clNone) then
        Cl := FColors.Hottrack;

      if (FFrameSize > 0) and (Cl <> clNone) then
      begin
        R2 := R;
        Dec(Fs, FFrameSize);
        InflateRect(R2, -Fs, -Fs);

        for I := 0 to FFrameSize - 1 do
          scFrame3D(Canvas, R2, Cl, Cl, 1, 0);
      end;

      if (FFrame <> scifNone) or (FFrameSize > 0) then
      begin
        Cl2 := Cl;
        if not (FFrame in [scifSingle, scifDouble, scifRoundedDouble]) then
          Cl := clBtnFace
        else
        if Cl = clNone then
        begin
          Cl := Self.Color;
          if Cl = clNone then Cl := clWindow;
        end;

        if FColors.Frame <> clNone then
        begin
          Cl := FColors.Frame;
          Cl2 := FColors.Frame;
        end;

        case FFrame of
          scifBumped:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccbBumped);
          scifEtched:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccbEtched);
          scifSingle:
            if Cl2 <> clNone then
              scDrawBevel(Canvas, R, Cl, clNone, False, sccbFlat);
          scifDouble:
            if Cl2 <> clNone then
              scDrawBevel(Canvas, R, Cl, clNone, False, sccbFlatBold);
          scifLowered:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccbLowered);
          scif3DLowered:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccb3DLowered);
          scifRaised:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccbRaised);
          scif3DRaised:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccb3DRaised);
          scifRoundedDouble:
            if Cl2 <> clNone then
              scDrawBevel(Canvas, R, Cl, clNone, False, sccbFlatBoldRounded);
          scifMetal:
            scDrawBevel(Canvas, R, Cl, clNone, False, sccbSoftRaised);
        end;
      end;  
    end;
  end;
end;

procedure TSCCustomImageLister.EnabledChanged;
begin
  UpdateHottrack;
end;

procedure TSCCustomImageLister.EnsureHorizontalPos(var P: Integer);
var
  CR: TRect;
  Mx, Cols: Integer;
begin
  if (P < 0) or IsDesigning then
    P := 0
  else begin
    Cols := GetColumns;

    CR := ClientRect;
    OffsetRect(CR, -CR.Left, -CR.Top);

    if IsRectEmpty(CR) or (Cols = 0) then
    begin
      P := 0;
      Exit;
    end;

    Mx := Cols*GetBoxWidth + (Cols - 1)*Spacing + 2*Indent - CR.Right;

    if Mx <= 0 then P := 0
    else if (Mx > 0) and (P > Mx) then
      P := Mx;
  end;
end;

procedure TSCCustomImageLister.EnsureVerticalPos(var P: Integer);
var
  CR: TRect;
  Mx, Cols, Rows: Integer;
begin
  if (P < 0) or IsDesigning then
    P := 0
  else begin
    Cols := GetColumns;

    CR := ClientRect;
    OffsetRect(CR, -CR.Left, -CR.Top);

    if IsRectEmpty(CR) or (Cols = 0) then
    begin
      P := 0;
      Exit;
    end;

    Rows := (Count - 1) div Cols;
    if Cols > 1 then Inc(Rows);

    Mx := Rows*GetBoxHeight + (Rows - 1)*Spacing + 2*Indent - CR.Bottom;

    if Mx <= 0 then P := 0
    else if (Mx > 0) and (P > Mx) then
      P := Mx;
  end;
end;

function TSCCustomImageLister.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCImageBorderProps;
end;

function TSCCustomImageLister.GetBoxHeight: Integer;
begin
  Result := 2*(GetFrameSize + FSpaceVert) + GetCaptionHeight +
    GetImageHeight;
end;

function TSCCustomImageLister.GetBoxWidth: Integer;
begin
  Result := 2*(GetFrameSize + FSpaceHorz) + GetImageWidth;
end;

function TSCCustomImageLister.GetCaptionHeight: Integer;
begin
  Result := 0;
  if scioShowNumbers in FOptions then
  begin
    if FCaptionHeight < 0 then
    begin
      Canvas.Font := Self.Font;
      FCaptionHeight := Canvas.TextHeight('Wq');

      Inc(FCaptionHeight, (FCaptionHeight div 5) + 2);
    end;

    Result := FCaptionHeight;
  end;
end;

function TSCCustomImageLister.GetColumns: Integer;
var
  CR: TRect;
  C, Fs, Iw: Integer;
begin
  Result := FColumns;
  if Result > 0 then Exit;

  CR := ClientRect;
  InflateRect(CR, -Indent, -Indent);
  
  OffsetRect(CR, -CR.Left, -CR.Top);

  C := CR.Right;
  if C < 0 then C := 0;

  Fs := GetFrameSize;

  Iw := GetImageWidth;

  Result := C div (2*(Fs + FSpaceHorz) + Iw);
  if Result > 1 then
    Result := (C - (Result - 1)*Spacing) div (2*(Fs + FSpaceHorz) + Iw);

  if Result = 0 then Result := 1;
end;

function TSCCustomImageLister.GetControlScrollbarsClass: TSCControlCustomScrollbarsClass;
begin
  Result := TSCImageListerScrollbars;
end;

function TSCCustomImageLister.GetCount: Integer;
begin
  Result := 0;
  if Images <> nil then Result := Images.Count;
end;

function TSCCustomImageLister.GetDrawRect: TRect;
var
  Cols, Rows, Bw, Bh: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (Images <> nil) and (Images.Count > 0) then
  begin
    Cols := GetColumns;
    Rows := (Images.Count - 1) div Cols;
    if Cols > 1 then Inc(Rows);

    Bw := GetBoxWidth;
    Bh := GetBoxHeight;

    Result.Right := Cols*Bw + (Cols - 1)*Spacing + Indent;
    Result.Bottom := Rows*Bh + (Rows - 1)*Spacing + Indent;

    OffsetRect(Result, Indent, Indent);
  end;
end;

function TSCCustomImageLister.GetFrameSize: Integer;
begin
  Result := 0;
  if FFrame in [scifSingle, scifLowered, scifRaised] then
    Result := 1
  else if FFrame <> scifNone then
    Result := 2;

  Inc(Result, FFrameSize);
end;

function TSCCustomImageLister.GetImageHeight: Integer;
begin
  Result := 16;
  if Images <> nil then Result := Images.Height;
end;

function TSCCustomImageLister.GetImageWidth: Integer;
begin
  Result := 16;
  if Images <> nil then Result := Images.Width;
end;

function TSCCustomImageLister.GetPictureAtPos(X, Y: Integer): Integer;
var
  P: TPoint;
  R, CR: TRect;
  Row, Col, Cols,
  Bw, Bh, Index: Integer;
begin
  Result := -1;
  if (Images <> nil) and (Images.Count > 0) then
  begin
    CR := ClientRect;
    P := Point(X, Y);

    if not IsRectEmpty(CR) and PtInRect(CR, P) then
    begin
      Bw := GetBoxWidth;
      Bh := GetBoxHeight;

      Col := (X + FHorizontalPos - Indent) div (Bw + Spacing);
      Row := (Y + FVerticalPos - Indent) div (Bh + Spacing);

      Cols := GetColumns;

      if Col < Cols then
      begin
        Index := Col + Row*Cols;

        if (Index > -1) and (Index < Images.Count) then
        begin
          R.Left := Col*(Bw + Spacing) + Indent - FHorizontalPos;
          R.Top := Row*(Bh + Spacing) + Indent - FVerticalPos;

          R.Right := R.Left + Bw;
          R.Bottom := R.Top + Bh;

          if not IsRectEmpty(R) and PtInRect(R, P) then
          begin
            Result := Index;
            Exit;
          end;
        end;
      end;
    end;  
  end;
end;

function TSCCustomImageLister.GetPictureRect(Index: Integer): TRect;
var
  Bw, Bh, Cols, Row, Col: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (Index > -1) and (Images <> nil) and (Index < Images.Count) then
  begin
    Cols := GetColumns;

    Row := Index div Cols;
    Col := Index mod Cols;

    Bw := GetBoxWidth;
    Bh := GetBoxHeight;

    Result.Left := Indent + Col*(Bw + Spacing);
    Result.Top  := Indent + Row*(Bh + Spacing);

    Result.Right  := Result.Left + Bw;
    Result.Bottom := Result.Top + Bh;
  end;
end;

function TSCCustomImageLister.GetScrollbarClass: TSCCustomControlScrollbarClass;
begin
  Result := TSCImageListerScrollbar;
end;

procedure TSCCustomImageLister.ImageListChange(Sender: TObject);
begin
  inherited ImageListChange(Sender);
  UpdateScrollbars(True, True);
end;

procedure TSCCustomImageLister.IndentChanged;
begin
  inherited IndentChanged;
  if (Images <> nil) and (Images.Count > 0) then
    UpdateScrollbars(True, True);
end;

function TSCCustomImageLister.InView(Index: Integer;
  PartitialAllowed: Boolean): Boolean;
var
  CR, R, R1: TRect;
begin
  Result := False;
  if (Index > -1) and (Images <> nil) and (Index < Images.Count) then
  begin
    CR := ClientRect;

    if not IsRectEmpty(CR) then
    begin
      R := GetPictureRect(Index);
      OffsetRect(R, -FHorizontalPos, -FVerticalPos);
      
      Result := not IsRectEmpty(R) and IntersectRect(R1, R, CR);

      if Result and not PartitialAllowed then
        Result := EqualRect(R, R1);
    end;
  end;
end;

procedure TSCCustomImageLister.KeyDown(var Key: Word; Shift: TShiftState);
var
  Index, Cols, Col, Row: Integer;
begin
  inherited KeyDown(Key, Shift);

  FMouseDownIndex := -1;

  if (Images <> nil) and (Images.Count > 0) then
  begin
    Index := FSelectedIndex;
    Cols := GetColumns;

    Row := Index div Cols;
    Col := Index mod Cols;

    case Key of
      VK_LEFT:
      begin
        Dec(Col);

        if Col < 0 then
        begin
          Col := Cols - 1;
          Dec(Row);
        end;
      end;
      VK_RIGHT:
      begin
        Inc(Col);

        if Col > Cols then
        begin
          Col := 0;
          Inc(Row);
        end;
      end;
      VK_UP:
        Dec(Row);
      VK_DOWN:
        Inc(Row);
      VK_PRIOR:
        Dec(Row, 3);
      VK_NEXT:
        Inc(Row, 3);
      VK_HOME:
      begin
        Col := 0;
        Row := 0;
      end;
      VK_END:
      begin
        Row := Images.Count div Cols;
        Col := Images.Count mod Cols;
      end;
    end;

    Index := Row*Cols + Col;
    if Index < 0 then Index := 0;

    if Index > Images.Count-1 then
      Index := Images.Count-1;

    if Index <> FSelectedIndex then
    begin
      MakeVisible(Index);
      SetSelectedIndex(Index);
    end;
  end;
end;

procedure TSCCustomImageLister.Loaded;
begin
  inherited Loaded;
  if (Images <> nil) and (Images.Count > 0) then
    UpdateScrollbars(True, True);
end;

procedure TSCCustomImageLister.MakeVisible(Index: Integer);
var
  R: TRect;
  Cols, Col, Row: Integer;
begin
  if (Index > -1) and (Images <> nil) and
    (Index < Images.Count) and not InView(Index, False) then
  begin
    Cols := GetColumns;

    Row := Index div Cols;
    Col := Index mod Cols;

    R := Rect(0, 0, 0, 0);
    if (Col > 0) or (Row > 0) then
    begin
      R := GetPictureRect(Index);

      if IsRectEmpty(R) then
        Exit;

      if Col = 0 then OffsetRect(R, -Indent, 0)
      else OffsetRect(R, -Spacing, 0);

      if Row = 0 then OffsetRect(R, 0, -Indent)
      else OffsetRect(R, 0, -Spacing);
    end;

    SetHorizontalPos(R.Left);
    SetVerticalPos(R.Top);
  end;
end;

procedure TSCCustomImageLister.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldIndex, OldHot: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if CanFocus then
    SetFocus;

  OldHot := FHotIndex;
  FHotIndex := GetPictureAtPos(X, Y);

  OldIndex := FSelectedIndex;
  FMouseDownIndex := -1;

  if Button = mbLeft then
  begin
    FMouseDownIndex := FHotIndex;

    FSelectedIndex := FHotIndex;
    if FSelectedIndex = -1 then FSelectedIndex := OldIndex;
  end;

  if (OldHot <> FHotIndex) or (FSelectedIndex <> OldIndex) then
  begin
    UpdateList;

    if OldHot <> FHotIndex then
      DoHottrack;

    if FSelectedIndex <> OldIndex then
      Change;
  end;
end;

procedure TSCCustomImageLister.MouseInControlChanged;
begin
  inherited MouseInControlChanged;
  UpdateHottrack;
end;

procedure TSCCustomImageLister.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  OldIndex, OldHot: Integer;
begin
  OldHot := FHotIndex;
  FHotIndex := GetPictureAtPos(X, Y);

  OldIndex := FSelectedIndex;
  if (FMouseDownIndex > -1) and (FHotIndex > -1) then
    FSelectedIndex := FHotIndex;

  if (OldHot <> FHotIndex) or (FSelectedIndex <> OldIndex) then
  begin
    UpdateList;

    if OldHot <> FHotIndex then
      DoHottrack;

    if FSelectedIndex <> OldIndex then
      Change;
  end;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomImageLister.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldIndex, OldHot: Integer;
begin
  OldHot := FHotIndex;
  FHotIndex := GetPictureAtPos(X, Y);

  OldIndex := FSelectedIndex;

  if FMouseDownIndex > -1 then
  begin
    FMouseDownIndex := -1;

    FSelectedIndex := FHotIndex;
    if FSelectedIndex = -1 then FSelectedIndex := OldIndex;
  end;

  if (OldHot <> FHotIndex) or (FSelectedIndex <> OldIndex) then
  begin
    UpdateList;

    if OldHot <> FHotIndex then
      DoHottrack;

    if FSelectedIndex <> OldIndex then
      Change;
  end;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomImageLister.Paint;
var
  CR: TRect;
  Cl: TColor;
  Bw, Bh, I, Cols,
  Col, Row, X, Y: Integer;
begin
  if not HandleAllocated then
    Exit;

  Inc(FDrawing);
  try
    CR := ClientRect;
    OffsetRect(CR, -CR.Left, -CR.Top);

    if IsRectEmpty(CR) then
      Exit;

    Cl := Self.Color;
    if Cl = clNone then Cl := clWindow;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;
      FillRect(CR);

      if Transparent then
        PaintParentOn(Canvas);
    end;

    DrawPicture(Canvas);

    if (Images <> nil) and (Images.Count > 0) then
    begin
      Bw := GetBoxWidth;
      Bh := GetBoxHeight;
      
      Cols := GetColumns;

      for I := 0 to Images.Count-1 do
      begin
        Row := I div Cols;
        Col := I mod Cols;

        X := Indent + Col*(Bw + Spacing) - FHorizontalPos;
        Y := Indent + Row*(Bh + Spacing) - FVerticalPos;

        DrawBox(Canvas, I, X, Y);
      end;
    end;
  finally
    Dec(FDrawing);
  end;
end;

procedure TSCCustomImageLister.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    UpdateList;
  end;
end;

procedure TSCCustomImageLister.SetColors(Value: TSCImageListerColors);
begin
  FColors.Assign(Value);
end;

procedure TSCCustomImageLister.SetColumns(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FColumns <> Value then
  begin
    FColumns := Value;

    if (Images <> nil) and (Images.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomImageLister.SetFrame(Value: TSCImageListerFrame);
begin
  if FFrame <> Value then
  begin
    FFrame := Value;

    if (Images <> nil) and (Images.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomImageLister.SetFrameSize(Value: Integer);
begin
  if Value < 0 then Value := 0;
  
  if FFrameSize <> Value then
  begin
    FFrameSize := Value;

    if (Images <> nil) and (Images.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomImageLister.SetHorizontalPos(Value: Integer);
begin
  Inc(FScrollPosChanging);
  try
    EnsureHorizontalPos(Value);

    if FHorizontalPos <> Value then
    begin
      FHorizontalPos := Value;
      UpdateScrollbars(True, True);
    end;

    if FScrollbarChanging = 0 then
      TSCImageBoxScrollbar(ScrollbarHorz).Position := FHorizontalPos;
  finally
    Dec(FScrollPosChanging);
  end;
end;

procedure TSCCustomImageLister.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;
  inherited SetIndent(Value);
end;

procedure TSCCustomImageLister.SetOptions(Value: TSCImageListerOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;

    if (Images <> nil) and (Images.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;

    UpdateHottrack(True);
  end;
end;

procedure TSCCustomImageLister.SetSelectedIndex(Value: Integer);
begin
  if Value < -1 then Value := -1;

  if FSelectedIndex <> Value then
  begin
    FSelectedIndex := Value;
    
    UpdateList;
    Change;
  end;
end;

procedure TSCCustomImageLister.SetShowScrollbars(Value: Boolean);
begin
  if FShowScrollbars <> Value then
  begin
    FShowScrollbars := Value;
    if (Images <> nil) and (Images.Count > 0) then
      UpdateScrollbars(True, True);
  end;
end;

procedure TSCCustomImageLister.SetSpaceHorz(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FSpaceHorz <> Value then
  begin
    FSpaceHorz := Value;

    if (Images <> nil) and (Images.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomImageLister.SetSpaceVert(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FSpaceVert <> Value then
  begin
    FSpaceVert := Value;

    if (Images <> nil) and (Images.Count > 0) then
    begin
      UpdateList;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomImageLister.SetVerticalPos(Value: Integer);
begin
  Inc(FScrollPosChanging);
  try
    EnsureVerticalPos(Value);

    if FVerticalPos <> Value then
    begin
      FVerticalPos := Value;
      UpdateScrollbars(True, True);
    end;

    if FScrollbarChanging = 0 then
      TSCImageBoxScrollbar(ScrollbarVert).Position := FVerticalPos;
  finally
    Dec(FScrollPosChanging);
  end;
end;

procedure TSCCustomImageLister.SpacingChanged;
begin
  inherited SpacingChanged;
  if (Images <> nil) and (Images.Count > 0) then
    UpdateScrollbars(True, True);
end;

procedure TSCCustomImageLister.StopTracking;
begin
  FMouseDownIndex := -1;
  UpdateHottrack;
end;

function TSCCustomImageLister.UpdateHorzScrollBar: Boolean;
var
  R: TRect;
  ScrlVisible: Boolean;
  SiOld, SiNew: TSCScrollInfo;
begin
  Result := False;
  if HandleAllocated and (FCreatingWnd = 0) and not IsLoading then
  begin
    SiOld := Self.GetScrollbarInfo(scskHorizontal);
    ScrlVisible := SiOld.Visible and (SiOld.Page <= SiOld.Max);

    SiNew := SiOld;

    SiNew.Page := 1;
    SiNew.Min  := 0;
    SiNew.Max  := 0;
    SiNew.Pos  := 0;

    if FShowScrollbars then
    begin
      R := GetDrawRect;
      R.Left := 0;
      R.Top := 0;

      SiNew.Page := Self.ClientWidth;
      SiNew.Min  := 0;
      SiNew.Max  := R.Right;

      if SiNew.Max < 0 then
        SiNew.Max := 0;

      EnsureHorizontalPos(FHorizontalPos);
      SiNew.Pos  := FHorizontalPos;
    end;

    SiNew.SmallChange := 20;
    SiNew.LargeChange := SiNew.Page;

    if (SiNew.Min <> SiOld.Min) or (SiNew.Max <> SiOld.Max) or
      (SiNew.Page <> SiOld.Page) or (SiNew.Pos <> SiOld.Pos) then
    begin
      SiNew.Visible := SiNew.Page < SiNew.Max;
      Self.SetScrollbarInfo(scskHorizontal, SiNew);

      if Integer(SiNew.Page) > SiNew.Max then
        SetHorizontalPos(SiNew.Min);
    end;

    Invalidate;
    Result := ScrlVisible <> (Integer(SiNew.Page) <= SiNew.Max);
  end;
end;

procedure TSCCustomImageLister.UpdateHottrack(Draw: Boolean);
var
  P: TPoint;
  OldHot: Integer;
begin
  OldHot := FHotIndex;
  FHotIndex := -1;

  if HandleAllocated and (scioHottrack in FOptions) and
    not IsDesigning and GetCursorPos(P) then
  begin
    P := Self.ScreenToClient(P);
    FHotIndex := GetPictureAtPos(P.x, P.y);
  end;

  if Draw and (OldHot <> FHotIndex) then
    UpdateList;

  if not IsDesigning and (FHotIndex <> OldHot) then
    DoHottrack;
end;

procedure TSCCustomImageLister.UpdateList;
begin
  if (Images <> nil) and (Images.Count > 0) then
    Invalidate;
end;

procedure TSCCustomImageLister.UpdateScrollbars(Horz, Vert: Boolean);
var
  WasHorz, IsVert, IsHorz: Boolean;
begin
  if Horz or Vert then
  begin
    if Horz then ScrollbarHorz.BeginUpdate;
    if Vert then ScrollbarVert.BeginUpdate;

    WasHorz := TSCImageBoxScrollbar(ScrollbarHorz).Visible;
    try
      if Vert then UpdateVertScrollBar;
      if Horz then UpdateHorzScrollBar;

      IsVert := TSCImageBoxScrollbar(ScrollbarVert).Visible;
      IsHorz := TSCImageBoxScrollbar(ScrollbarHorz).Visible;

      if IsVert and (WasHorz <> IsHorz) then
        UpdateVertScrollBar;
    finally
      if Horz then ScrollbarHorz.EndUpdate;
      if Vert then ScrollbarVert.EndUpdate;
    end;
  end;
end;

function TSCCustomImageLister.UpdateVertScrollBar: Boolean;
var
  R: TRect;
  ScrlVisible: Boolean;
  SiOld, SiNew: TSCScrollInfo;
begin
  Result := False;
  if HandleAllocated and (FCreatingWnd = 0) and not IsLoading then
  begin
    SiOld := Self.GetScrollbarInfo(scskVertical);
    ScrlVisible := SiOld.Visible and (SiOld.Page < SiOld.Max);

    SiNew := SiOld;

    SiNew.Page := 1;
    SiNew.Min  := 0;
    SiNew.Max  := 0;
    SiNew.Pos  := 0;

    if FShowScrollbars then
    begin
      R := GetDrawRect;
      R.Left := 0;
      R.Top := 0;

      SiNew.Page := Self.ClientHeight;
      SiNew.Min  := 0;
      SiNew.Max  := R.Bottom;

      if SiNew.Max < 0 then
        SiNew.Max := 0;

      EnsureVerticalPos(FVerticalPos);
      SiNew.Pos  := FVerticalPos;
    end;

    SiNew.SmallChange := 20;
    SiNew.LargeChange := SiNew.Page;

    if (SiNew.Min <> SiOld.Min) or (SiNew.Max <> SiOld.Max) or
      (SiNew.Page <> SiOld.Page) or (SiNew.Pos <> SiOld.Pos) then
    begin
      SiNew.Visible := SiNew.Page < SiNew.Max;
      Self.SetScrollbarInfo(scskVertical, SiNew);

      if Integer(SiNew.Page) > SiNew.Max then
        SetVerticalPos(SiNew.Min);
    end;

    Invalidate;
    Result := ScrlVisible <> (Integer(SiNew.Page) <= SiNew.Max);
  end;
end;

procedure TSCCustomImageLister.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := DLGC_WANTARROWS;
end;

procedure TSCCustomImageLister.WMHScroll(var Message: TWMHScroll);
var
  SI: TSCScrollInfo;
begin
  SI := Self.GetScrollbarInfo(scskHorizontal);

  case Message.ScrollCode of
    SB_LINEUP:
      SetHorizontalPos(FHorizontalPos - 20);
    SB_LINEDOWN:
      SetHorizontalPos(FHorizontalPos + 20);
    SB_PAGEUP:
      SetHorizontalPos(FHorizontalPos - Integer(SI.Page));
    SB_PAGEDOWN:
      SetHorizontalPos(FHorizontalPos + Integer(SI.Page));
    SB_THUMBPOSITION:
    begin
      if SI.Pos <= SI.Min then
        SetHorizontalPos(SI.Min)
      else
      if SI.Pos >= SI.Max then
        SetHorizontalPos(SI.Max)
      else
        SetHorizontalPos(SI.Pos);
    end;
    SB_TOP:
      SetHorizontalPos(SI.Min);
    SB_BOTTOM:
      SetHorizontalPos(SI.Max);
  end;
end;

procedure TSCCustomImageLister.WMMouseWheel(var Message: TWMMouseWheel);
var
  SbVert, SbHorz: TSCImageBoxScrollbar;
begin
  if IsDesigning then
    Exit;

  SbHorz := TSCImageBoxScrollbar(ScrollbarHorz);
  SbVert := TSCImageBoxScrollbar(ScrollbarVert);

  if ((Message.Keys and MK_SHIFT) = MK_SHIFT) or (SbHorz.Visible and not SbVert.Visible) then
  begin
    if Message.WheelDelta < 0 then
      SetHorizontalPos(FHorizontalPos + 20)
    else
    if Message.WheelDelta > 0 then
      SetHorizontalPos(FHorizontalPos - 20);
  end else
  begin
    if Message.WheelDelta < 0 then
      SetVerticalPos(FVerticalPos + 20)
    else
    if Message.WheelDelta > 0 then
      SetVerticalPos(FVerticalPos - 20);
  end;
end;

procedure TSCCustomImageLister.WMSize(var Message: TWMSize);
begin
  inherited;
  if (Images <> nil) and (Images.Count > 0) then
    UpdateScrollbars(True, True);
end;

procedure TSCCustomImageLister.WMVScroll(var Message: TWMVScroll);
var
  SI: TSCScrollInfo;
begin
  SI := Self.GetScrollbarInfo(scskVertical);

  case Message.ScrollCode of
    SB_LINEUP:
      SetVerticalPos(FVerticalPos - 20);
    SB_LINEDOWN:
      SetVerticalPos(FVerticalPos + 20);
    SB_PAGEUP:
      SetVerticalPos(FVerticalPos - Integer(SI.Page));
    SB_PAGEDOWN:
      SetVerticalPos(FVerticalPos + Integer(SI.Page));
    SB_THUMBPOSITION:
    begin
      if SI.Pos <= SI.Min then
        SetVerticalPos(SI.Min)
      else
      if SI.Pos >= SI.Max then
        SetVerticalPos(SI.Max)
      else
        SetVerticalPos(SI.Pos);
    end;
    SB_TOP:
      SetVerticalPos(SI.Min);
    SB_BOTTOM:
      SetVerticalPos(SI.Max);
  end;
end;

{$I SCVerRec.inc}

end.