{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCColorControls;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, SCConsts, SCControl, SCCommon, SCBitmap, SCResStrs;

const
  crSCCPalettePicker = -8914;

type
  TSC3DSunkenBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccb3DLowered;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCColorCells = class;
  TSCCustomColorPalette = class;

  TSCColorCell = class(TCollectionItem)
  private
    FAutoColor: Boolean;
    FColor: TColor;
    FText: string;
    FImageIndex: TImageIndex;
    FVisible: Boolean;
    FEnabled: Boolean;
    FHint: String;
    procedure SetAutoColor(Value: Boolean);
    procedure SetColor(Value: TColor);
    procedure SetEnabled(Value: Boolean);
    procedure SetImageIndex(Value: TImageIndex);
    function  GetFocused: Boolean;
    function  GetBack: Boolean;
    function  GetFore: Boolean;
    procedure SetVisible(Value: Boolean);
    procedure SetText(const Value: string);
  protected
    function  GetDisplayName: string; override;
    function  OwnerPalette: TSCCustomColorPalette;
    function  OwnerState: TComponentState;
    function  GetImages: TCustomImageList;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;

    property Focused: Boolean read GetFocused;
    property IsBack: Boolean read GetBack;
    property IsFore: Boolean read GetFore;
  published
    property AutoColor: Boolean read FAutoColor write SetAutoColor default False;
    property Color: TColor read FColor write SetColor default clNone;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Hint: String read FHint write FHint;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Text: string read FText write SetText;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TSCColorCells = class(TCollection)
  private
    FPalette: TSCCustomColorPalette;
    function  GetItem(Index: Integer): TSCColorCell;
    procedure SetItem(Index: Integer; Value: TSCColorCell);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(Palette: TSCCustomColorPalette);
    function Add: TSCColorCell;

    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomColorPalette read FPalette;
    {$ENDIF}
    property Items[Index: Integer]: TSCColorCell read GetItem write SetItem; default;
  end;

  TSCColorPalStyle = (scpsNone, scpsDefault, scpsSunkenFlat, scpsFlat, scpsExtraFlat,
    scpsRaisedFlat, scpsRaised, scpsMac, scpsMetal, scpsXP);

  TSCColorScheme = (scCustomScheme, scWin16Scheme, scGrayScheme, scWin256Scheme,
    scNetscape1Scheme, scNetscape2Scheme, scNetscape3Scheme, scIEScheme,
    scGradientScheme);

  TSCCPalScrollStyle = (scpssNone, scpssUp, scpssDown);

  TSCCPalHintStyle = (scphHex, scphRGB, scphHexAndRGB, scphRGBAndHex);

  TSCCPalClickEvent = procedure(Sender: TObject; Index: Integer) of object;
  TSCCPalMouseEvent = procedure(Sender: TObject; Index: Integer;
    Button: TMouseButton; Shift: TShiftState) of object;

  TSCCustomColorPalette = class(TSCCustomControl)
  private
    FBackColor: TColor;
    FCanSelectBackColor: Boolean;
    FCellBorderColor: TColor;
    FCells: TSCColorCells;
    FCellSpace: Integer;
    FCellWidth: Integer;
    FClickedCell: Integer;
    FCursorChange: Boolean;
    FDefaultCursor: TCursor;
    FFlatButtons: Boolean;
    FFocusedCell: Integer;
    FFocusedColor: TColor;
    FForeColor: TColor;
    FGradientStart: TColor;
    FGradientStop: TColor;
    FGradientStep: Integer;
    FHintHexCaption: String;
    FHintStyle: TSCCPalHintStyle;
    FInternalDraw: Boolean;
    FMouseIsDown: Boolean;
    FOrientation: TSCOrientation;
    FPickerCursor: TCursor;
    FScrollArrowColor: TColor;
    FScrollBtnColor: TColor;
    FScrollClick: TSCCPalScrollStyle;
    FScrolling: Boolean;
    FScrollPos: Integer;
    FScrollSize: Integer;
    FScrollTimer: Integer;
    FSelectionColor: TColor;
    FScheme: TSCColorScheme;
    FShowBackColor: Boolean;
    FShowButtons: Boolean;
    FShowFocused: Boolean;
    FShowForeColor: Boolean;
    FStyle: TSCColorPalStyle;
    FTopIndent: Integer;
    FUpdatingScheme: Boolean;
    FVisibleCount: Integer;
    // Events
    FDblClicked: Boolean;
    FOldClickedCell: Integer;
    FOnCellClick: TSCCPalClickEvent;
    FOnCellDblClick: TSCCPalClickEvent;
    FOnCellMouseDown: TSCCPalMouseEvent;
    FOnCellMouseUp: TSCCPalMouseEvent;
    FOnFocusChange: TNotifyEvent;
    FOnBkColorChange: TNotifyEvent;
    FOnForeColorChange: TNotifyEvent;
    // Private procedures
    procedure SetBackColor(Value: TColor);
    procedure SetCellBorderColor(Value: TColor);
    procedure SetCells(Value: TSCColorCells);
    procedure SetCellSpace(Value: Integer);
    procedure SetCellWidth(Value: Integer);
    procedure SetFlatButtons(Value: Boolean);
    procedure SetFocusedCell(Value: Integer);
    procedure SetFocusedColor(Value: TColor);
    procedure SetOrientation(Value: TSCOrientation);
    procedure SetPickerCursor(Value: TCursor);
    procedure SetScrollArrowColor(Value: TColor);
    procedure SetScrollBtnColor(Value: TColor);
    procedure SetForeColor(Value: TColor);
    procedure SetGradientStart(Value: TColor);
    procedure SetGradientStop(Value: TColor);
    procedure SetGradientStep(Value: Integer);
    procedure SetSelectionColor(Value: TColor);
    procedure SetScheme(Value: TSCColorScheme);
    procedure SetShowBackColor(Value: Boolean);
    procedure SetShowFocused(Value: Boolean);
    procedure SetShowForeColor(Value: Boolean);
    procedure SetShowButtons(Value: Boolean);
    procedure SetStyle(Value: TSCColorPalStyle);
    procedure SetTopIndent(Value: Integer);

    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure CMCursorChanged(var Message: TMessage); message CM_CURSORCHANGED;
    procedure CMHintShow(var Msg: TMessage); message CM_HINTSHOW;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;

    procedure ResetCursor(ACursor: TCursor);

    procedure UpdatePaletteScheme;
    function  CountVisibleCells: Integer;
    procedure UpdateVisibleCount(Value: Integer);

    procedure UpdateScrollPos(Value: Integer);
    procedure RefreshScrollSize;
    procedure StartScrolling;
    procedure ScrollPalette;
    procedure StopScrolling;

    function  GetGradientColor(Index: Integer): TColor;

    procedure DoCellClick(Index: Integer);
    procedure DoCellDblClick(Index: Integer);
    procedure DoCellMouseDown(Index: Integer; Button: TMouseButton; Shift: TShiftState);
    procedure DoCellMouseUp(Index: Integer; Button: TMouseButton; Shift: TShiftState);
  protected
    procedure Paint; override;
    procedure Loaded; override;

    procedure SetIndent(Value: Integer); override;
    procedure IndentChanged; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure UpdateCell(Index: Integer); virtual;
    procedure UpdateCells; dynamic;
    procedure UpdateFocusedCell;

    function  CanScrollVertically(UpDir: Boolean): Boolean;
    function  CanScrollHorizontally(LeftDir: Boolean): Boolean;

    function  GetBtnRect(const Up: Boolean): TRect;
    function  GetCellHint(ACell: TSCColorCell): String; virtual;

    procedure DrawScrollButtons(ACanvas: TCanvas; X, Y: Integer);
    procedure DrawFrame(C: TCanvas; Index: Integer; R: TRect;
      Cl: TColor; Selected: Boolean; IsBack: Boolean = False);
    procedure DrawOnCanvas(ACanvas: TCanvas; X, Y: Integer); virtual;

    property BackColor: TColor read FBackColor write SetBackColor default -1;
    property CanSelectBackColor: Boolean read FCanSelectBackColor write FCanSelectBackColor default False;
    property CellBorderColor: TColor read FCellBorderColor write SetCellBorderColor default clWindowFrame;
    property Cells: TSCColorCells read FCells write SetCells;
    property CellSpace: Integer read FCellSpace write SetCellSpace default 2;
    property CellWidth: Integer read FCellWidth write SetCellWidth default 16;
    property HintHexCaption: String read FHintHexCaption write FHintHexCaption;
    property HintStyle: TSCCPalHintStyle read FHintStyle write FHintStyle default scphHex;
    property FlatButtons: Boolean read FFlatButtons write SetFlatButtons default False;
    property ForeColor: TColor read FForeColor write SetForeColor default clNone;
    property GradientStart: TColor read FGradientStart write SetGradientStart default clLime;
    property GradientStop: TColor read FGradientStop write SetGradientStop default clBlue;
    property GradientStep: Integer read FGradientStep write SetGradientStep default 256;
    property Orientation: TSCOrientation read FOrientation write SetOrientation default scoVertical;
    property PickerCursor: TCursor read FPickerCursor write SetPickerCursor default crSCCPalettePicker;
    property ScrollArrowColor: TColor read FScrollArrowColor write SetScrollArrowColor default clWindowFrame;
    property ScrollBtnColor: TColor read FScrollBtnColor write SetScrollBtnColor default clBtnFace;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor default clHighlight;
    property Scheme: TSCColorScheme read FScheme write SetScheme default scCustomScheme;
    property ShowBackColor: Boolean read FShowBackColor write SetShowBackColor default False;
    property ShowButtons: Boolean read FShowButtons write SetShowButtons default True;
    property ShowFocused: Boolean read FShowFocused write SetShowFocused default True;
    property ShowForeColor: Boolean read FShowForeColor write SetShowForeColor default True;
    property Style: TSCColorPalStyle read FStyle write SetStyle default scpsDefault;
    property TopIndent: Integer read FTopIndent write SetTopIndent default 0;
    property OnBkColorChange: TNotifyEvent read FOnBkColorChange write FOnBkColorChange;
    property OnCellClick: TSCCPalClickEvent read FOnCellClick write FOnCellClick;
    property OnCellDblClick: TSCCPalClickEvent read FOnCellDblClick write FOnCellDblClick;
    property OnCellMouseDown: TSCCPalMouseEvent read FOnCellMouseDown write FOnCellMouseDown;
    property OnCellMouseUp: TSCCPalMouseEvent read FOnCellMouseUp write FOnCellMouseUp;
    property OnFocusChange: TNotifyEvent read FOnFocusChange write FOnFocusChange;
    property OnForeColorChange: TNotifyEvent read FOnForeColorChange write FOnForeColorChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    function  GetScrollStyleOf(P: TPoint): TSCCPalScrollStyle;
    function  CanScroll(AsUp: Boolean): Boolean;
    function  Scrolling: Boolean;
    function  ScrollPaused: Boolean;
    procedure PauseScrolling;
    procedure ResumeScrolling;
    procedure ArrangeScrolling;

    function  CellAtPos(P: TPoint): Integer;
    function  GetCellRect(Index: Integer): TRect;
    function  GetCellsBounds: TRect;
    function  CellsClientRect: TRect;

    property FocusedColor: TColor read FFocusedColor default -1;
    property ClickedCell: Integer read FClickedCell;
    property FocusedCell: Integer read FFocusedCell;
    property VisibleCount: Integer read FVisibleCount;
    property ScrollPos: Integer read FScrollPos write UpdateScrollPos;
    property ScrollSize: Integer read FScrollSize;
  end;

  TSCColorPalette = class(TSCCustomColorPalette)
  published
    property Align;
    property Anchors;
    property BackColor;
    property BorderProps;
    property CanSelectBackColor;
    property CellBorderColor;
    property Cells;
    property CellSpace;
    property CellWidth;
    property Color;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Height;
    property HintHexCaption;
    property HintStyle;
    property FlatButtons;
    property Font;
    property ForeColor;
    property GradientStart;
    property GradientStop;
    property GradientStep;
    property Hint;
    property Images;
    property Indent;
    property Orientation;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PickerCursor;
    property PopupMenu;
    property ScrollArrowColor;
    property ScrollBtnColor;
    property SelectionColor;
    property Scheme;
    property ShowBackColor;
    property ShowButtons;
    property ShowFocused;
    property ShowForeColor;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property TopIndent;
    property Visible;
    property Width;
    property OnBkColorChange;
    property OnCanResize;
    property OnCellClick;
    property OnCellDblClick;
    property OnCellMouseDown;
    property OnCellMouseUp;
    property OnChange;
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
    property OnFocusChange;
    property OnForeColorChange;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnMouseWheel;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TSCColorSelectorPart = (sccpNone, sccpClient, sccpBackColor, sccpForeColor);
  TSCColorSelectorLayout = (scclFrontBack, sccLeftRight, scclTopBottom);

  TSCCustomColorSelectBox = class(TSCCustomControl)
  private
    FAutoSized: Boolean;
    FBackColor: TColor;
    FCellBorderColor: TColor;
    FCellWidth: Integer;
    FClickSwaps: Boolean;
    FDblClickSwaps: Boolean;
    FForeColor: TColor;
    FLayout: TSCColorSelectorLayout;
    FNoneColor: TColor;
    FNoneDiagonal: TColor;
    FNoneStyle: TSCNoneColorStyle;
    FStyle: TSCColorPalStyle;
    procedure SetAutoSized(Value: Boolean);
    procedure SetBackColor(Value: TColor);
    procedure SetCellBorderColor(Value: TColor);
    procedure SetCellWidth(Value: Integer);
    procedure SetClickSwaps(Value: Boolean);
    procedure SetDblClickSwaps(Value: Boolean);
    procedure SetForeColor(Value: TColor);
    procedure SetLayout(Value: TSCColorSelectorLayout);
    procedure SetNoneColor(Value: TColor);
    procedure SetNoneDiagonal(Value: TColor);
    procedure SetNoneStyle(Value: TSCNoneColorStyle);
    procedure SetStyle(Value: TSCColorPalStyle);
  protected
    procedure Paint; override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetBlendValue: Word; override;

    procedure Click; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure SetSpacing(Value: Integer); override;

    function  GetForeCell: TRect;
    function  GetBackCell: TRect;
    function  GetCellWidth: Integer;
    function  GetFrameBorderSize: Integer;

    procedure DrawDiagonal(C: TCanvas; InR: TRect);
    procedure DrawFrame(C: TCanvas; R: TRect; Cl: TColor; IsFore: Boolean = True);
    procedure DrawOnCanvas(ACanvas: TCanvas; X, Y: Integer); virtual;

    property AutoSized: Boolean read FAutoSized write SetAutoSized default True;
    property BackColor: TColor read FBackColor write SetBackColor default clNone;
    property BlendColor default False;
    property CellBorderColor: TColor read FCellBorderColor write SetCellBorderColor default cl3DDkShadow;
    property CellWidth: Integer read FCellWidth write SetCellWidth default 20;
    property ClickSwaps: Boolean read FClickSwaps write SetClickSwaps default False;
    property DblClickSwaps: Boolean read FDblClickSwaps write SetDblClickSwaps default False;
    property ForeColor: TColor read FForeColor write SetForeColor default clNone;
    property Indent default 4;
    property Layout: TSCColorSelectorLayout read FLayout write SetLayout default scclFrontBack;
    property NoneColor: TColor read FNoneColor write SetNoneColor default clNone;
    property NoneDiagonal: TColor read FNoneDiagonal write SetNoneDiagonal default clRed;
    property NoneStyle: TSCNoneColorStyle read FNoneStyle write SetNoneStyle default scncNone;
    property Spacing default 4;
    property Style: TSCColorPalStyle read FStyle write SetStyle default scpsRaised;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    procedure SwapColors;
    function  PartAtPos(X, Y: Integer): TSCColorSelectorPart;
  end;

  TSCColorSelectBox = class(TSCCustomColorSelectBox)
  published
    property Align;
    property Anchors;
    property AutoSized;
    property BackColor;
    property BlendColor;
    property BorderProps;
    property CellBorderColor;
    property CellWidth;
    property Color;
    property Constraints;
    property Cursor;
    property ClickSwaps;
    property DblClickSwaps;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ForeColor;
    property Height;
    property Hint;
    property Indent;
    property Layout;
    property NoneColor;
    property NoneDiagonal;
    property NoneStyle;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Spacing;
    property Style;
    property TabOrder;
    property TabStop;
    property Visible;
    property Width;
    property OnCanResize;
    property OnChange;
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnMouseWheel;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TSCColorPointerType = (scptSquare, scptFlippedSquare, scptCircle, scptCross);

  TSCCustomGradient = class(TSCCustomControl)
  private
    FColorCount: Integer;
    FColorPointer: TSCColorPointerType;
    FGradientBmp: TSCBitmap;
    FNeedSizeUpdate: Boolean;
    FNeedUpdate: Boolean;
    FLockUpdate: Boolean;
    FSelectedColor: TColor;
    FSelectedPoint: TPoint;
    procedure SetColorPointer(Value: TSCColorPointerType);
  protected
    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;

    procedure SetSelectedPoint(X, Y: Integer); virtual;
    procedure SetColorCount(Value: Integer); virtual;
    function  GetSelectedColor: TColor; virtual;
    procedure SetSelectedColor(Value: TColor); virtual;
    function  GetGradientBmp: TSCBitmap; virtual;

    procedure UpdateGradientBmp(WithSize: Boolean = True); virtual;
    procedure DrawSelectionPointer; virtual;
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Paint; override;

    procedure BoundsChanged; dynamic;
    procedure DoUpdateChange(NeedUpdate: Boolean = True); dynamic;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property Border default sccb3DLowered;
    property ColorCount: Integer read FColorCount write SetColorCount;
    property ColorPointer: TSCColorPointerType read FColorPointer write SetColorPointer default scptSquare;
    property SelectedColor: TColor read GetSelectedColor write SetSelectedColor default -1;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    property BorderEx;
    property OnChange;
  end;

  TSCCustomCornerGradient = class(TSCCustomGradient)
  private
    FCLeftTop: TColor;
    FCLeftBottom: TColor;
    FCRightTop: TColor;
    FCRightBottom: TColor;
    procedure SetLeftTop(Value: TColor);
    procedure SetLeftBottom(Value: TColor);
    procedure SetRightTop(Value: TColor);
    procedure SetRightBottom(Value: TColor);
  protected
    procedure SetColorValues(ALeftTop, ALeftBottom, ARightTop,
      ARightBottom: TColor; AColorCount: Integer);

    procedure UpdateGradientBmp(WithSize: Boolean = True); override;
    procedure DrawSelectionPointer; override;

    property LeftTop: TColor read FCLeftTop write SetLeftTop;
    property LeftBottom: TColor read FCLeftBottom write SetLeftBottom;
    property RightTop: TColor read FCRightTop write SetRightTop;
    property RightBottom: TColor read FCRightBottom write SetRightBottom;
    property BlendColor default False;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCColorGradient = class;

  TSCGradientColors = class(TPersistent)
  private
    FOwner: TSCColorGradient;
    function  GetColorCount: Integer;
    procedure SetColorCount(Value: Integer);
    function  GetLeftTop: TColor;
    procedure SetLeftTop(Value: TColor);
    function  GetLeftBottom: TColor;
    procedure SetLeftBottom(Value: TColor);
    function  GetRightTop: TColor;
    procedure SetRightTop(Value: TColor);
    function  GetRightBottom: TColor;
    procedure SetRightBottom(Value: TColor);
  public
    constructor Create(AOwner: TSCColorGradient); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property ColorCount: Integer read GetColorCount write SetColorCount default 80;
    property LeftTop: TColor read GetLeftTop write SetLeftTop default clBlack;
    property LeftBottom: TColor read GetLeftBottom write SetLeftBottom default clGray;
    property RightTop: TColor read GetRightTop write SetRightTop default clRed;
    property RightBottom: TColor read GetRightBottom write SetRightBottom default clWhite;
  end;

  TSCColorGradient = class(TSCCustomCornerGradient)
  private
    FColors: TSCGradientColors;
    procedure SetColors(Value: TSCGradientColors);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Align;
    property Anchors;
    property BorderProps;
    property Color;
    property ColorPointer;
    property Colors: TSCGradientColors read FColors write SetColors;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Height;
    property Hint;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property Width;
    property OnCanResize;
    property OnChange;
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnMouseWheel;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TSCCustomHSVGradient = class(TSCCustomCornerGradient)
  private
    FReverse: Boolean;
    procedure SetReverse(Value: Boolean);
    procedure CalcSelectedPoint(S, V: Word);
  protected
    procedure BoundsChanged; override;

    procedure SetSelectedColor(Value: TColor); override;
    procedure SetSelectedPoint(X, Y: Integer); override;
    procedure Loaded; override;

    property BlendColor default False;
    property ColorCount default 80;
    property Reverse: Boolean read FReverse write SetReverse default False;
    property RightTop default clRed;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    property SelectedColor;
  end;

  TSCHSVGradient = class(TSCCustomHSVGradient)
  published
    property Align;
    property Anchors;
    property BlendColor;
    property BorderProps;
    property Color;
    property ColorCount;
    property ColorPointer;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Height;
    property Hint;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property Reverse;
    property RightTop;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property Width;
    property OnCanResize;
    property OnChange;
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnMouseWheel;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TSCRGBRoller = class(TSCCustomGradient)
  private
    FShowBlackWhite: Boolean;
    procedure SetShowBlackWhite(Value: Boolean);
  protected
    procedure SetSelectedPoint(X, Y: Integer); override;
    procedure UpdateGradientBmp(WithSize: Boolean = True); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    property SelectedColor default clWhite;
  published
    property Align;
    property Anchors;
    property BorderProps;
    property Constraints;
    property Cursor default crSCCPalettePicker;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Height;
    property Hint;
    property ParentShowHint;
    property PopupMenu;
    property ShowBlackWhite: Boolean read FShowBlackWhite write SetShowBlackWhite default True;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property Width;
    property OnCanResize;
    property OnChange;
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnMouseWheel;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TSCColorSliderOrientation = (scsoHorizontal, scsoVertical);

  TSCSliderThumbType = (scsttDown, scsttUp, scsttBoth);

  TSCCustomColorSlider = class(TSCCustomControl)
  private
    FMin: Integer;
    FMax: Integer;
    FOrientation: TSCColorSliderOrientation;
    FPosition: Integer;
    FProgressBorder: TSCControlBorder;
    FSelectedColor: TColor;
    FThumbStyle: TSCThumbStyle;
    FThumbType: TSCSliderThumbType;
    FTopIndent: Integer;
    FOnChange: TNotifyEvent;
    FColorBmp: TSCBitmap;
    FClearBack: Boolean;
    FNeedUpdate: Boolean;
    FNeedSizeUpdate: Boolean;
    procedure SetMin(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure SetOrientation(Value: TSCColorSliderOrientation);
    procedure SetProgressBorder(Value: TSCControlBorder);
    procedure SetThumbStyle(Value: TSCThumbStyle);
    procedure SetThumbType(Value: TSCSliderThumbType);
    procedure SetCursorPos(X, Y: Integer);

    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  protected
    procedure SetTopIndent(Value: Integer); virtual;
    procedure TopIndentChanged; dynamic;
    procedure SetIndent(Value: Integer); override;
    procedure IndentChanged; override;
    procedure Loaded; override;
    procedure CreateWnd; override;
    procedure Paint; override;

    procedure ProcessTrackKey(Key: Word);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function  GetThumbHeight: Integer; dynamic;
    function  GetThumbWidth: Integer; dynamic;
    function  GetThumbDownRect: TRect; dynamic;
    function  GetThumbUpRect: TRect; dynamic;
    function  GetProgressRect: TRect; dynamic;

    procedure SetPosition(Value: Integer); virtual;
    function  GetSelectedColor: TColor; virtual;
    procedure SetSelectedColor(Value: TColor); virtual;
    procedure DoUpdateChange(NeedUpdate, TriggerEvent: Boolean); virtual;

    procedure UpdateColorBmp(UpdateSize: Boolean = False); virtual;
    procedure DrawProgress; virtual;
    procedure DrawDownSlider(P: TPoint; W, H: Integer);
    procedure DrawUpSlider(P: TPoint; W, H: Integer);
    procedure DrawThumb; virtual;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property Min: Integer read FMin write SetMin default 0;
    property Max: Integer read FMax write SetMax default 255;
    property Orientation: TSCColorSliderOrientation read FOrientation write SetOrientation default scsoHorizontal;
    property Position: Integer read FPosition write SetPosition default 0;
    property ProgressBorder: TSCControlBorder read FProgressBorder write SetProgressBorder default sccb3DLowered;
    property SelectedColor: TColor read GetSelectedColor write SetSelectedColor default clBlack;
    property ThumbStyle: TSCThumbStyle read FThumbStyle write SetThumbStyle default sctsMac;
    property ThumbType: TSCSliderThumbType read FThumbType write SetThumbType default scsttDown;
    property TopIndent: Integer read FTopIndent write SetTopIndent default 0;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TSCHueSlider = class(TSCCustomColorSlider)
  private
    FHSVGradient: TSCCustomHSVGradient;
    procedure SetHSVGradient(Value: TSCCustomHSVGradient);
  protected
    procedure SetPosition(Value: Integer); override;
    procedure SetSelectedColor(Value: TColor); override;
    procedure UpdateColorBmp(UpdateSize: Boolean = False); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property SelectedColor default clRed;
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
    property Height;
    property Hint;
    property HSVGradient: TSCCustomHSVGradient read FHSVGradient write SetHSVGradient;
    property Indent;
    property Orientation;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property Position;
    property ProgressBorder;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property ThumbStyle;
    property ThumbType;
    property TopIndent;
    property Visible;
    property Width;
    property OnCanResize;
    property OnChange;
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnMouseWheel;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TSCLumSlider = class(TSCCustomColorSlider)
  protected
    procedure UpdateColorBmp(UpdateSize: Boolean = False); override;
  public
    constructor Create(AOwner: TComponent); override;
    property SelectedColor default clRed;
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
    property Height;
    property Hint;
    property Indent;
    property Orientation;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property Position;
    property ProgressBorder;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property ThumbStyle;
    property ThumbType;
    property TopIndent;
    property Visible;
    property Width;
    property OnCanResize;
    property OnChange;
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnMouseWheel;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TSCRGBSliderType = (scrgbRed, scrgbGreen, scrgbBlue);

  TSCRGBSlider = class(TSCCustomColorSlider)
  private
    FColorful: Boolean;
    FRGBType: TSCRGBSliderType;
    procedure SetColorful(Value: Boolean);
    procedure SetRGBType(Value: TSCRGBSliderType);
  protected
    function  GetSelectedColor: TColor; override;
    procedure SetSelectedColor(Value: TColor); override;
    procedure UpdateColorBmp(UpdateSize: Boolean = False); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    property SelectedColor default clBlack;
  published
    property Align;
    property Anchors;
    property BorderProps;
    property Color;
    property Colorful: Boolean read FColorful write SetColorful default False;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Height;
    property Hint;
    property Indent;
    property Orientation;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property Position;
    property ProgressBorder;
    property RGBType: TSCRGBSliderType read FRGBType write SetRGBType default scrgbRed;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property ThumbStyle;
    property ThumbType;
    property TopIndent;
    property Visible;
    property Width;
    property OnCanResize;
    property OnChange;
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnMouseWheel;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TSCCSelectorStyle = (scssButton, scssCombo, scssFlatCombo, scssMac,
    scssOfficeXPCombo, scssPopupButton);

  TSCCSelColorEvent = procedure(Sender: TObject; var ACaption: String) of object;

  TSCCustomColorSelector = class(TSCCustomControl)
  private
    FColorCaption: String;
    FMouseIsDown: Boolean;
    FNoneColor: TColor;
    FNoneDiagonal: TColor;
    FNoneStyle: TSCNoneColorStyle;
    FSelectedColor: TColor;
    FShowCaption: Boolean;
    FShowFocus: Boolean;
    FStyle: TSCCSelectorStyle;
    FOnGetCaption: TSCCSelColorEvent;
    procedure SetNoneColor(Value: TColor);
    procedure SetNoneDiagonal(Value: TColor);
    procedure SetNoneStyle(Value: TSCNoneColorStyle);
    procedure SetSelectedColor(Value: TColor);
    procedure SetShowCaption(Value: Boolean);
    procedure SetShowFocus(Value: Boolean);
    procedure SetStyle(Value: TSCCSelectorStyle);
  protected
    procedure StopTracking; override;
    procedure MouseInControlChanged; override;
    procedure Loaded; override;
    procedure Paint; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure DrawDiagonal(InR: TRect);

    procedure DoGetCaption; dynamic;
    procedure DrawButton; virtual;
    procedure DrawCombo; virtual;
    procedure DrawFlatCombo; virtual;
    procedure DrawMac; virtual;
    procedure DrawOfficeXPCombo; virtual;
    procedure DrawPopupButton; virtual;

    property Color default clWindow;
    property NoneColor: TColor read FNoneColor write SetNoneColor default clNone;
    property NoneDiagonal: TColor read FNoneDiagonal write SetNoneDiagonal default clRed;
    property NoneStyle: TSCNoneColorStyle read FNoneStyle write SetNoneStyle default scncNone;
    property ParentColor default False;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clBlack;
    property ShowCaption: Boolean read FShowCaption write SetShowCaption default False;
    property ShowFocus: Boolean read FShowFocus write SetShowFocus default False;
    property Style: TSCCSelectorStyle read FStyle write SetStyle default scssCombo;
    property OnGetCaption: TSCCSelColorEvent read FOnGetCaption write FOnGetCaption;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCColorSelector = class(TSCCustomColorSelector)  
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
    property Font;
    property Height;
    property Hint;
    property ImageIndex;
    property Images;
    property NoneColor;
    property NoneDiagonal;
    property NoneStyle;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property SelectedColor;
    property ShowCaption;
    property ShowFocus;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Visible;
    property Width;
    property OnCanResize;
    property OnChange;
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
    property OnGetCaption;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnMouseWheel;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation

{$R *.res}

const
  ScrollBtnSize = 16;
  SC_CPAL_SCROLLTIMERID = 111;

{ TSCColorCell }

procedure TSCColorCell.Assign(Source: TPersistent);
begin
  if Source = nil then Exit;

  if Source is TSCColorCell then
  begin
    with TSCColorCell(Source)do
    begin
      Self.FVisible := FVisible;
      Self.FAutoColor := FAutoColor;
      Self.FColor := FColor;
      Self.FEnabled := FEnabled;
      Self.FHint := FHint;
      Self.FImageIndex := FImageIndex;
      Self.FText := FText;
    end;

    Changed(False);
  end else
    inherited Assign(Source);
end;

constructor TSCColorCell.Create(Collection: TCollection);
begin
  FImageIndex := -1;
  inherited Create(Collection);

  FAutoColor := False;
  FColor := clNone;
  FVisible := True;
  FEnabled := True;
end;

function TSCColorCell.GetDisplayName: string;
begin
  Result := Text;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TSCColorCell.GetFocused: Boolean;
var
  APal: TSCCustomColorPalette;
begin
  APal := OwnerPalette;
  Result := (APal <> nil) and (APal.FocusedColor = FColor);
end;

function TSCColorCell.GetImages: TCustomImageList;
begin
  Result := nil;
  if (Collection <> nil) and (TSCColorCells(Collection).FPalette <> nil) then
    Result := TSCColorCells(Collection).FPalette.Images;
end;

function TSCColorCell.GetBack: Boolean;
var
  APal: TSCCustomColorPalette;
begin
  APal := OwnerPalette;
  Result := (APal <> nil) and (FColor = APal.BackColor);
end;

function TSCColorCell.GetFore: Boolean;
var
  APal: TSCCustomColorPalette;
begin
  APal := OwnerPalette;
  Result := (APal <> nil) and (FColor = APal.ForeColor);
end;

function TSCColorCell.OwnerPalette: TSCCustomColorPalette;
begin
  Result := nil;
  if Collection <> nil then
    Result := TSCCustomColorPalette(TSCColorCells(Collection).Owner);
end;

function TSCColorCell.OwnerState: TComponentState;
begin
  Result := [];
  if (Collection <> nil) and (TSCColorCells(Collection).FPalette <> nil) then
    Result := TSCColorCells(Collection).FPalette.ComponentState;
end;

procedure TSCColorCell.SetAutoColor(Value: Boolean);
begin
  if FAutoColor <> Value then
  begin
    FAutoColor := Value;
    if Visible then Changed(False);
  end;
end;

procedure TSCColorCell.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    if Visible then Changed(False);
  end;
end;

procedure TSCColorCell.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    if Visible then Changed(False);
  end;
end;

procedure TSCColorCell.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if Visible then Changed(False);
  end;
end;

procedure TSCColorCell.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    if Visible then Changed(False);
  end;
end;

procedure TSCColorCell.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(True);
  end;
end;

{ TSCColorCells }

function TSCColorCells.Add: TSCColorCell;
begin
  Result := TSCColorCell(inherited Add);
end;

constructor TSCColorCells.Create(Palette: TSCCustomColorPalette);
begin
  inherited Create(TSCColorCell);
  FPalette := Palette;
end;

function TSCColorCells.GetItem(Index: Integer): TSCColorCell;
begin
  Result := nil;
  if (Index > -1) and (Index < Count) then
    Result := TSCColorCell(inherited GetItem(Index));
end;

function TSCColorCells.GetOwner: TPersistent;
begin
  Result := FPalette;
end;

procedure TSCColorCells.SetItem(Index: Integer; Value: TSCColorCell);
begin
  if (Index > -1) and (Index < Count) then
    inherited SetItem(Index, Value);
end;

procedure TSCColorCells.Update(Item: TCollectionItem);
begin
  if Item <> nil then
    FPalette.UpdateCell(Item.Index) else
    FPalette.UpdateCells;
end;

{ TSCCustomColorPalette }

function TSCCustomColorPalette.CanScrollHorizontally(LeftDir: Boolean): Boolean;
begin
  Result := (FOrientation = scoHorizontal) and
    (FCells <> nil) and (FCells.Count > 0) and (FScrollSize > 0);
  if not Result then Exit;

  Result := FScrollPos > 0;
  if LeftDir then
    Result := FScrollPos < FScrollSize;
end;

function TSCCustomColorPalette.CanScrollVertically(UpDir: Boolean): Boolean;
begin
  Result := (FOrientation = scoVertical) and
    (FCells <> nil) and (FCells.Count > 0) and (FScrollSize > 0);
  if not Result then Exit;

  Result := FScrollPos > 0;
  if UpDir then
    Result := FScrollPos < FScrollSize;
end;

function TSCCustomColorPalette.CellAtPos(P: TPoint): Integer;
var
  CR, R: TRect;
  BtnSize, I: Integer;
begin
  Result := -1;
  if not (CanGetClientRect and (FCells <> nil)) then Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := Rect(0, 0, FCellWidth, FCellWidth);
  OffsetRect(R, Indent, FTopIndent);

  BtnSize := 0;
  if FShowButtons and (FScrollSize > 0) then
    BtnSize := ScrollBtnSize;

  if FOrientation = scoVertical then
  begin
    OffsetRect(R, 0, BtnSize);
    OffsetRect(R, 0, -FScrollPos);
  end else
  begin
    OffsetRect(R, BtnSize, 0);
    OffsetRect(R, -FScrollPos, 0);
  end;

  for I := 0 to FCells.Count-1 do
  begin
    if PtInRect(R, P) then
    begin
      Result := I;
      if not FCells[I].Visible then Result := -1;
      Exit;
    end;

    if not FCells[I].Visible then Continue;

    if FOrientation = scoVertical then
    begin
      OffsetRect(R, FCellSpace + FCellWidth, 0);
      if R.Right > CR.Right then
        OffsetRect(R, -R.Left + Indent, FCellSpace + FCellWidth);
    end else
    begin
      OffsetRect(R, 0, FCellSpace + FCellWidth);
      if R.Bottom > CR.Bottom then
        OffsetRect(R, FCellSpace + FCellWidth, -R.Top + FTopIndent);
    end;
  end;
end;

procedure TSCCustomColorPalette.CMCursorChanged(var Message: TMessage);
begin
  inherited;
  if not FCursorChange then
    FDefaultCursor := Cursor;
end;

procedure TSCCustomColorPalette.CMMouseLeave(var Message: TMessage);
begin
  inherited;

  if not IsDesigning then
  begin
    SetFocusedCell(-1);
    SetFocusedColor(-1);
  end;
end;

constructor TSCCustomColorPalette.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(Left, Top, 360, 240);
  BlendColor := False;
  DoubleBuffered := True;

  FCells := TSCColorCells.Create(Self);
  FCellBorderColor := clWindowFrame;
  FCellSpace := 2;
  FCellWidth := 16;

  FClickedCell := -1;
  FOldClickedCell := -1;

  FBackColor := -1;
  FCanSelectBackColor := False;
  FFlatButtons := False;
  FFocusedColor := -1;
  FFocusedCell := -1;
  FOrientation := scoVertical;
  FPickerCursor := crSCCPalettePicker;

  FGradientStart := clLime;
  FGradientStop := clBlue;
  FGradientStep := 256;

  FScrollArrowColor := clWindowFrame;
  FScrollBtnColor := clBtnFace;
  FScrollPos := 0;
  FScrollSize := 0;
  FScrolling := False;
  FScrollTimer := -1;

  FForeColor := clNone;
  FSelectionColor := clHighlight;
  FScheme := scCustomScheme;
  FShowBackColor := False;
  FShowButtons := True;
  FShowFocused := True;
  FShowForeColor := True;
  FStyle := scpsDefault;
  FTopIndent := 0;
  FHintStyle := scphHex;
end;

destructor TSCCustomColorPalette.Destroy;
begin
  FreeAndNil(FCells);
  inherited;
end;

procedure TSCCustomColorPalette.DrawFrame(C: TCanvas; Index: Integer;
  R: TRect; Cl: TColor; Selected: Boolean; IsBack: Boolean = False);
var
  CR, R2, ClntR: TRect;
  RndBy: Integer;
  AColor, BColor, CColor: TColor;
begin
  if IsRectEmpty(R) or not CanGetClientRect or
    not ((Index > -1) and (Index < FCells.Count)) then
    Exit;

  CR := ClientRect;

  ClntR := CR;
  if FShowButtons and (FScrollSize > 0) then
  begin
    if FOrientation = scoVertical then
      InflateRect(ClntR, 0, -ScrollBtnSize)
    else
      InflateRect(ClntR, -ScrollBtnSize, 0);
  end;

  OffsetRect(ClntR, Indent, FTopIndent);
  IntersectRect(ClntR, ClntR, CR);

  if IsRectEmpty(ClntR) then
    Exit;

  IntersectRect(R2, R, ClntR);
  if IsRectEmpty(R2) then
    Exit;

  if Selected then
  begin
    if IsBack then R2 := R;

    AColor := FSelectionColor;
    BColor := clWhite;
    CColor := FSelectionColor;

    if Style = scpsXP then
      BColor := BlendedColor(FSelectionColor, 172, 153, 104, True)
    else if Style = scpsMac then
      BColor := FSelectionColor
    else
    if (Style = scpsExtraFlat) and (FCellSpace = 0) then
    begin
      Dec(R.Left);
      Dec(R.Top);
    end;

    scFrame3D(C, R, AColor, AColor, 1, 0);
    scFrame3D(C, R, BColor, BColor, 1, 0);
    scFrame3D(C, R, CColor, CColor, 1, 0);

    case FCellWidth of
       0..11:
         RndBy := 0;
      12..14:
        RndBy := 6;
      15..19:
        RndBy := 10;
      20..28:
        RndBy := 14;
      else
        RndBy := 18;
    end;

    if IsBack and (RndBy > 0) then
    begin
      scFrame3D(C, R2, AColor, AColor, 1, RndBy);
      scFrame3D(C, R2, BColor, BColor, 1, RndBy);
      scFrame3D(C, R2, CColor, CColor, 1, RndBy);
    end;

    Exit;
  end;

  case Style of
    scpsDefault:
    begin
      scFrame3D(C, R, clBtnShadow, clBtnHighlight, 1, 0);
      scFrame3D(C, R, cl3DDkShadow, clBtnFace, 1, 0);
    end;
    scpsSunkenFlat:
      scFrame3D(C, R, clBtnShadow, clBtnHighlight, 1, 0);
    scpsMetal:
    begin
      scFrame3D(C, R, clBtnShadow, clBtnHighlight, 1, 0);
      scFrame3D(C, R, GetBtnFaceOf(Cl), GetBtnFaceOf(Cl), 1, 0);
    end;
    scpsFlat:
      scFrame3D(C, R, FCellBorderColor, FCellBorderColor, 1, 0);
    scpsExtraFlat:
    begin
      if FCellSpace > 0 then
        scFrame3D(C, R, FCellBorderColor, FCellBorderColor, 1, 0)
      else begin
        AColor := FCells[Index].Color;
        if AColor = clNone then
          AColor := Self.Color;

        scFrame3D(C, R, AColor, FCellBorderColor, 1, 0);
        InflateRect(R, 1, 1);

        IntersectRect(R2, R, ClntR);

        if R.Left = ClntR.Left then
          with C, Pen do
          begin
            Style := psSolid;
            Width := 1;
            Color := FCellBorderColor;

            MoveTo(R2.Left, R2.Top);
            LineTo(R2.Left, R2.Bottom);
          end;

        if R.Top = ClntR.Top then
          with C, Pen do
          begin
            Style := psSolid;
            Width := 1;
            Color := FCellBorderColor;

            MoveTo(R2.Left, R2.Top);
            LineTo(R2.Right, R2.Top);
          end;
      end;
    end;
    scpsMac:
    begin
      scFrame3D(C, R, clBtnShadow, clBtnHighlight, 1, 0);
      scFrame3D(C, R, clWindowFrame, clWindowFrame, 1, 0);
    end;
    scpsRaisedFlat:
      scFrame3D(C, R, clBtnHighlight, clBtnShadow, 1, 0);
    scpsRaised:
    begin
      scFrame3D(C, R, clBtnHighlight, cl3DDkShadow, 1, 0);
      scFrame3D(C, R, clBtnFace, clBtnShadow, 1, 0);
    end;
    scpsXP:
    begin
      scFrame3D(C, R, clBtnHighlight, clBtnHighlight, 1, 0);
      InflateRect(R, 1, 1);

      Dec(R.Right);
      Dec(R.Bottom);

      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, cl3DDkShadow, cl3DDkShadow, 1, 0);
        scFrame3D(C, R, clBtnHighlight, clBtnFace, 1, 0);
      end;
    end;
  end;
end;

procedure TSCCustomColorPalette.DrawOnCanvas(ACanvas: TCanvas; X, Y: Integer);
var
  DC: HDC;
  Cl: TColor;
  IsBack: Boolean;
  CR, R, CellR, VisR: TRect;
  SaveIndex, I, BtnSize, MinX, MinY: Integer;
begin
  if not (HandleAllocated and CanGetClientRect and (ACanvas <> nil)) then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left + X, -CR.Top + Y);
  if IsRectEmpty(CR) then Exit;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetFaceColor;

    FillRect(CR);
  end;

  if not ((FCells <> nil) and (FCells.Count > 0)) then Exit;

  SaveIndex := 0;
  DC := ACanvas.Handle;
  try
    SaveIndex := SaveDC(DC);
    IntersectClipRect(DC, CR.Left, CR.Top, CR.Right, CR.Bottom);

    CellR := CR;
    Inc(CellR.Left, Indent);
    Inc(CellR.Top, FTopIndent);

    BtnSize := 0;
    if FShowButtons and (FScrollSize > 0) then
      BtnSize := ScrollBtnSize;

    if FOrientation = scoVertical then
    begin
      Dec(CellR.Top, FScrollPos);
      Inc(CellR.Top, BtnSize);
    end else
    begin
      Dec(CellR.Left, FScrollPos);
      Inc(CellR.Left, BtnSize);
    end;

    IntersectRect(VisR, CellR, CR);
    if IsRectEmpty(VisR) then
      Exit;

    MinX := CR.Left + Indent;
    MinY := CR.Top + FTopIndent;

    if FOrientation = scoVertical then
      Inc(MinY, BtnSize)
    else
      Inc(MinX, BtnSize);

    if VisR.Left < MinX then
      VisR.Left := MinX;

    if VisR.Top < MinY then
      VisR.Top := MinY;

    if not IsRectEmpty(VisR) then
    begin
      IntersectClipRect(DC, VisR.Left, VisR.Top, VisR.Right, VisR.Bottom);

      R := Rect(CellR.Left, CellR.Top, CellR.Left + FCellWidth,
        CellR.Top + FCellWidth);

      for I := 0 to FCells.Count-1 do
      begin
        if not FCells[I].Visible then
          Continue;

        if ((R.Left < VisR.Right) and (R.Right > VisR.Left)) or
          ((R.Top < VisR.Bottom) and (R.Bottom > VisR.Top)) then
        begin
          Cl := FCells[I].FColor;
          
          if not FCells[I].Enabled or (FCells[I].FColor = clNone) then
          begin
            Cl := Self.Color;
            if Cl = clNone then Cl := clBtnFace;
          end;

          with ACanvas do
          begin
            Brush.Color := Cl;

            if FCells[I].Enabled then
            begin
              IsBack := FShowBackColor and FCells[I].IsBack;

              FillRect(R);
              DrawFrame(ACanvas, I, R, Cl, (FShowFocused and FCells[I].Focused) or
                (FShowForeColor and FCells[I].IsFore) or IsBack, IsBack);
            end;
          end;
        end;

        if FOrientation = scoVertical then
        begin
          OffsetRect(R, FCellWidth + FCellSpace, 0);

          if R.Right > CellR.Right then
          begin
            OffsetRect(R, 0, FCellSpace + FCellWidth);
            R.Left := CellR.Left;
            R.Right := R.Left + FCellWidth;
          end;

          if R.Top >= CellR.Bottom then Break;
        end else
        begin
          OffsetRect(R, 0, FCellSpace + FCellWidth);

          if R.Bottom > CellR.Bottom then
          begin
            OffsetRect(R, FCellSpace + FCellWidth, 0);
            R.Top := CellR.Top;
            R.Bottom := R.Top + FCellWidth;
          end;

          if R.Left >= CellR.Right then Break;
        end;
      end;
    end;
  finally
    if (DC <> 0) and (SaveIndex <> 0) then
      RestoreDC(DC, SaveIndex);
  end;

  DrawScrollButtons(ACanvas, X, Y);
end;

function TSCCustomColorPalette.GetCellRect(Index: Integer): TRect;
var
  CR: TRect;
  BtnSize, I: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if not (CanGetClientRect and (FCells <> nil) and
    (Index > -1) and (Index < FCells.Count) and FCells[Index].Visible) then Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  Result := Rect(0, 0, FCellWidth, FCellWidth);
  OffsetRect(Result, Indent, FTopIndent);

  BtnSize := 0;
  if FShowButtons and (FScrollSize > 0) then
    BtnSize := ScrollBtnSize;

  if FOrientation = scoVertical then
  begin
    OffsetRect(Result, 0, BtnSize);
    OffsetRect(Result, 0, -FScrollPos);
  end else
  begin
    OffsetRect(Result, BtnSize, 0);
    OffsetRect(Result, -FScrollPos, 0);
  end;

  for I := 0 to Index do
  begin
    if I = Index then Exit;
    if not FCells[I].Visible then Continue;

    if FOrientation = scoVertical then
    begin
      OffsetRect(Result, FCellSpace + FCellWidth, 0);
      if Result.Right > CR.Right then
        OffsetRect(Result, -Result.Left + Indent, FCellSpace + FCellWidth);
    end else
    begin
      OffsetRect(Result, 0, FCellSpace + FCellWidth);
      if Result.Bottom > CR.Bottom then
        OffsetRect(Result, FCellSpace + FCellWidth, -Result.Top + FTopIndent);
    end;
  end;
end;

function TSCCustomColorPalette.GetCellsBounds: TRect;
var
  CR, R: TRect;
  Found: Boolean;
  I, Cnt, W, H,
  XCnt, YCnt, BtnSize: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if not (CanGetClientRect and (FCellWidth > 0) and
    (FCells <> nil) and (FCells.Count > 0)) then Exit;

  CR := ClientRect;
  Inc(CR.Left, Indent);
  Inc(CR.Top, FTopIndent);

  if CR.Right < CR.Left then CR.Right := CR.Left;
  if CR.Bottom < CR.Top then CR.Bottom := CR.Top;

  Result := CR;
  if IsRectEmpty(CR) then Exit;

  R := CR;
  OffsetRect(R, -R.Left, -R.Top);

  Cnt := 0;
  if FOrientation = scoVertical then
  begin
    W := 0;
    XCnt := 0;

    Found := False;
    for I := 0 to FCells.Count-1 do
    begin
      if not FCells[I].Visible then Continue;

      Inc(Cnt);

      if not Found then
      begin
        Inc(W, FCellWidth + FCellSpace);
        Found := W >= R.Right;
        Inc(XCnt);

        if Found then
        begin
          Dec(W, FCellSpace);
          if W > R.Right then
          begin
            Dec(W, FCellWidth);
            Dec(XCnt);
          end;
        end;
      end;
    end;

    if XCnt = 0 then XCnt := 1;
    if W = 0 then W := R.Right;

    R.Right  := W;
    R.Bottom := (FCellWidth + FCellSpace)*(Cnt div XCnt);

    if (XCnt > 1) and (Cnt mod XCnt > 0) then
      Inc(R.Bottom, FCellWidth + FCellSpace);

    if W > 0 then Dec(R.Bottom, FCellSpace);
  end else
  begin
    H := 0;
    YCnt := 0;

    Found := False;
    for I := 0 to FCells.Count-1 do
    begin
      if not FCells[I].Visible then Continue;

      Inc(Cnt);

      if not Found then
      begin
        Inc(H, FCellWidth + FCellSpace);
        Found := H >= R.Bottom;
        Inc(YCnt);

        if Found then
        begin
          Dec(H, FCellSpace);
          if H > R.Bottom then
          begin
            Dec(H, FCellWidth);
            Dec(YCnt);
          end;
        end;
      end;
    end;

    if YCnt = 0 then YCnt := 1;
    if H = 0 then H := R.Bottom;

    R.Bottom  := H;
    R.Right := (FCellWidth + FCellSpace)*(Cnt div YCnt);

    if (YCnt > 1) and (Cnt mod YCnt > 0) then
      Inc(R.Right, FCellWidth + FCellSpace);

    if H > 0 then Dec(R.Right, FCellSpace);
  end;

  Result.Right  := Result.Left + R.Right;
  Result.Bottom := Result.Top + R.Bottom;

  BtnSize := 0;
  if FShowButtons then BtnSize := ScrollBtnSize;

  if FOrientation = scoVertical then
  begin
    OffsetRect(R, 0, -FScrollPos);
    if (BtnSize > 0) and (R.Bottom - R.Top > CR.Bottom - CR.Top) then
      OffsetRect(R, 0, BtnSize);
  end else
  begin
    OffsetRect(R, -FScrollPos, 0);
    if (BtnSize > 0) and (R.Right - R.Left > CR.Right - CR.Left) then
      OffsetRect(R, BtnSize, 0);
  end;
end;

procedure TSCCustomColorPalette.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  StopScrolling;
  if ClickFocus and CanFocus and not Focused then
    Exit;

  FMouseIsDown := True;

  FScrollClick := GetScrollStyleOf(Point(X, Y));
  if FScrollClick <> scpssNone then
  begin
    FDblClicked := False;
    FClickedCell := -1;
    FOldClickedCell := -1;

    SetFocusedCell(-1);
    SetFocusedColor(-1);

    StartScrolling;
  end else
  begin
    FClickedCell := CellAtPos(Point(X, Y));
    if not ((FClickedCell > -1) and (FClickedCell < FCells.Count) and
      FCells[FClickedCell].Enabled) then FClickedCell := -1;

    SetFocusedCell(FClickedCell);
    if FFocusedCell > -1 then
      SetFocusedColor(FCells[FFocusedCell].Color)
    else SetFocusedColor(-1);

    DoCellMouseDown(FClickedCell, Button, Shift);
  end;

  FOldClickedCell := -1;

  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TSCCustomColorPalette.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Cr: TCursor;
  SC, SCP: Boolean;
  ScStyle: TSCCPalScrollStyle;
begin
  SC  := Scrolling;
  SCP := ScrollPaused;

  if SC or SCP then
  begin
    ScStyle := GetScrollStyleOf(Point(X, Y));
    if ScStyle <> FScrollClick then
      PauseScrolling
    else ResumeScrolling;

    if (Scrolling <> SC) or (SCP <> ScrollPaused) then
      Invalidate;
  end else
  begin
    ScStyle := GetScrollStyleOf(Point(X, Y));

    if ScStyle <> scpssNone then
    begin
      SetFocusedCell(-1);
      ResetCursor(FDefaultCursor);
    end else
    begin
      FFocusedCell := -1;

      if (FMouseIsDown and (FClickedCell <> -1)) or
        (not FMouseIsDown and (FClickedCell = -1)) then
      begin
        SetFocusedCell(CellAtPos(Point(X, Y)));
        if not ((FFocusedCell > -1) and (FFocusedCell < FCells.Count) and
          FCells[FFocusedCell].Enabled) then
          SetFocusedCell(-1);
      end;

      Cr := FDefaultCursor;
      if FFocusedCell <> -1 then
        Cr := FPickerCursor;

      ResetCursor(Cr);
    end;

    if FFocusedCell <> -1 then
      SetFocusedColor(FCells[FFocusedCell].Color)
    else SetFocusedColor(-1);
  end;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomColorPalette.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FMouseIsDown then
  begin
    FMouseIsDown := False;
    if Scrolling or ScrollPaused then
    begin
      FOldClickedCell := -1;
      StopScrolling;
      
      Exit;
    end;

    FOldClickedCell := FClickedCell;

    if FClickedCell <> -1 then
    begin
      FClickedCell := CellAtPos(Point(X, Y));
      if not ((FClickedCell > -1) and (FClickedCell < FCells.Count) and
        FCells[FClickedCell].Enabled) then FClickedCell := -1;

      if FClickedCell > -1 then
      begin
        if FCanSelectBackColor and (Button = mbRight) then
          BackColor := FCells[FClickedCell].Color
        else ForeColor := FCells[FClickedCell].Color;
      end;
    end;

    if FClickedCell <> -1 then
      DoCellMouseUp(FClickedCell, Button, Shift);
  end;

  inherited MouseUp(Button, Shift, X, Y);
  FClickedCell := -1;
end;

procedure TSCCustomColorPalette.Paint;
var
  ABitmap: TSCBitmap;
  R: TRect;
begin
  if not HandleAllocated then Exit;

  ABitmap := nil;
  try
    R := ClientRect;
    if IsRectEmpty(R) then Exit;

    ABitmap := TSCBitmap.Create;
    ABitmap.SetBounds(R.Right - R.Left, R.Bottom - R.Top);

    FInternalDraw := True;
    try
      DrawOnCanvas(ABitmap.Canvas, 0, 0);
    finally
      FInternalDraw := False;
    end;
    Canvas.Draw(0, 0, ABitmap);
  finally
    if ABitmap <> nil then ABitmap.Free;
  end;
end;

procedure TSCCustomColorPalette.ArrangeScrolling;
var
  P, S: Integer;
  HasHandle: Boolean;
  CR, R: TRect;
  Pt: TPoint;
begin
  HasHandle := CanGetClientRect;
  if not (HasHandle and (FCells <> nil)) then
  begin
    FScrollPos := 0;
    FScrollSize := 0;

    Exit;
  end;

  if FScrollPos < 0 then FScrollPos := 0;
  if FScrollSize < 0 then FScrollSize := 0;

  P := FScrollPos;
  S := FScrollSize;
  try
    if FCells.Count = 0 then
    begin
      FScrollPos := 0;
      FScrollSize := 0;

      Exit;
    end;

    R := GetCellsBounds;
    OffsetRect(R, -R.Left, -R.Top);

    CR := ClientRect;
    Inc(CR.Left, Indent);
    Inc(CR.Top, FTopIndent);

    if CR.Right < CR.Left then CR.Right := CR.Left;
    if CR.Bottom < CR.Top then CR.Bottom := CR.Top;

    OffsetRect(CR, -CR.Left, -CR.Top);

    if FOrientation = scoVertical then
      FScrollSize := R.Bottom - CR.Bottom
    else
      FScrollSize := R.Right - CR.Right;

    if FScrollSize < 0 then FScrollSize := 0;
    if FShowButtons and (FScrollSize > 0) then
      Inc(FScrollSize, 2*ScrollBtnSize);

    if FScrollPos > FScrollSize then
      FScrollPos := FScrollSize;
  finally
    if (FScrollPos <> P) or (FScrollSize <> S) then
    begin
      if FScrollSize <> S then
      begin
        if Scrolling or ScrollPaused then
        begin
          FMouseIsDown := False;
          StopScrolling;
        end;

        if CanGetClientRect and GetCursorPos(Pt) then
        begin
          Pt := Self.ScreenToClient(Pt);
          if GetScrollStyleOf(Pt) <> scpssNone then
            ResetCursor(FPickerCursor)
          else ResetCursor(FDefaultCursor);
        end;
      end;

      Invalidate;
      Change;
    end;
  end;
end;

procedure TSCCustomColorPalette.ResetCursor(ACursor: TCursor);
var
  P: TPoint;
begin
  if Cursor = ACursor then Exit;

  FCursorChange := True;
  try
    if (FScrollSize > 0) and (ACursor = FPickerCursor) then
    begin
      GetCursorPos(P);
      P := ScreenToClient(P);

      if GetScrollStyleOf(P) <> scpssNone then
        ACursor := FDefaultCursor;
    end;
    Cursor := ACursor;
  finally
    FCursorChange := False;
  end;
end;

procedure TSCCustomColorPalette.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
var
  OldW, OldH: Integer;
begin
  OldW := Width;
  OldH := Height;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if (FVisibleCount > 0) and ((OldW <> Width) or (OldH <> Height)) then
    ArrangeScrolling;
end;

procedure TSCCustomColorPalette.SetCellBorderColor(Value: TColor);
begin
  if FCellBorderColor <> Value then
  begin
    FCellBorderColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomColorPalette.SetCells(Value: TSCColorCells);
begin
  FCells.Assign(Value);
end;

procedure TSCCustomColorPalette.SetCellSpace(Value: Integer);
begin
  if Value < 0 then Value := 0
  else if Value > 20 then Value := 20;

  if FCellSpace <> Value then
  begin
    FCellSpace := Value;
    RefreshScrollSize;
  end;
end;

procedure TSCCustomColorPalette.SetCellWidth(Value: Integer);
begin
  if Value < 8 then Value := 8
  else if Value > 40 then Value := 40;

  if FCellWidth <> Value then
  begin
    FCellWidth := Value;
    RefreshScrollSize;
  end;
end;

procedure TSCCustomColorPalette.SetOrientation(Value: TSCOrientation);
var
  P, S: Integer;
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;

    P := FScrollPos;
    S := FScrollSize;

    if P <> 0 then UpdateScrollPos(0)
    else if S <> 0 then ArrangeScrolling;

    if (FScrollPos = P) and (FScrollSize = S) then
    begin
      Invalidate;
      Change;
    end;  
  end;
end;

procedure TSCCustomColorPalette.SetFocusedCell(Value: Integer);
var
  Cr: TCursor;
begin
  if FFocusedCell <> Value then
  begin
    FFocusedCell := Value;

    Cr := FDefaultCursor;
    if FFocusedCell <> -1 then
      Cr := FPickerCursor;

    ResetCursor(Cr);
  end;
end;

procedure TSCCustomColorPalette.SetFocusedColor(Value: TColor);
begin
  if FFocusedColor <> Value then
  begin
    FFocusedColor := Value;
    if FShowFocused  then Invalidate;

    if Assigned(FOnFocusChange) then
      FOnFocusChange(Self);
    if (Self <> nil) and HandleAllocated then
      Change;
  end;
end;

procedure TSCCustomColorPalette.SetIndent(Value: Integer);
begin
  if Value < 0 then
    Value := 0
  else
  if Value > 100 then
    Value := 100;

  inherited SetIndent(Value);
end;

procedure TSCCustomColorPalette.SetPickerCursor(Value: TCursor);
var
  IsPickCur: Boolean;
begin
  if FPickerCursor <> Value then
  begin
    IsPickCur := (FFocusedCell > -1) and (Cursor = FPickerCursor);

    FPickerCursor := Value;
    if IsPickCur then
      ResetCursor(FPickerCursor);
  end;
end;

procedure TSCCustomColorPalette.SetForeColor(Value: TColor);
begin
  if FForeColor <> Value then
  begin
    FForeColor := Value;
    if FShowForeColor then Invalidate;

    if Assigned(FOnForeColorChange) then
      FOnForeColorChange(Self);
    if (Self <> nil) and HandleAllocated then
      Change;
  end;
end;

procedure TSCCustomColorPalette.SetScheme(Value: TSCColorScheme);
begin
  if FScheme <> Value then
  begin
    if (FScheme = scCustomScheme) and (FCells <> nil) and
      (FCells.Count > 0) and IsDesigning and not IsLoading and
      (Application.MessageBox(PChar(SSCSchemeChangeWarning), PChar(SSCWarning),
      MB_ICONWARNING + MB_YESNO + MB_DEFBUTTON1) <> IDYES) then
      Exit;

    FScheme := Value;
    UpdatePaletteScheme;
  end;
end;

procedure TSCCustomColorPalette.SetStyle(Value: TSCColorPalStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TSCCustomColorPalette.SetTopIndent(Value: Integer);
begin
  if Value < 0 then
    Value := 0
  else
  if Value > 100 then
    Value := 100;

  if FTopIndent <> Value then
  begin
    FTopIndent := Value;
    RefreshScrollSize;
  end;
end;

procedure TSCCustomColorPalette.UpdateCell(Index: Integer);
var
  DC: HDC;
  Cl: TColor;
  IsBack: Boolean;
  CR, R, IR: TRect;
begin
  if FUpdatingScheme then Exit;

  FScheme := scCustomScheme;
  if (Index > -1) and (Index < FCells.Count) and
    FCells[Index].Visible then
  begin
    R := GetCellRect(Index);
    if IsRectEmpty(R) then Exit;

    CR := CellsClientRect;
    if IsRectEmpty(CR) then Exit;

    IntersectRect(IR, R, CR);
    if IsRectEmpty(IR) then Exit;

    DC := 0;
    try
      if not EqualRect(IR, R) then
      begin
        DC := GetDC(Self.Handle);
        IntersectClipRect(DC, CR.Left, CR.Top, CR.Right, CR.Bottom);
      end;

      Cl := FCells[Index].FColor;
      if not FCells[Index].Enabled or (FCells[Index].FColor = clNone) then
      begin
        Cl := Self.Color;
        if Cl = clNone then Cl := clBtnFace;
      end;

      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R);
      end;

      if FCells[Index].Enabled then
      begin
        IsBack := FShowBackColor and FCells[Index].IsBack;
        DrawFrame(Canvas, Index, R, Cl, (FShowFocused and FCells[Index].Focused) or
          (FShowForeColor and FCells[Index].IsFore) or IsBack, IsBack);
      end;
    finally
      if DC <> 0 then
        ReleaseDC(Self.Handle, DC);
    end;

    UpdateVisibleCount(CountVisibleCells);
    Change;
  end;
end;

procedure TSCCustomColorPalette.UpdateCells;
begin
  if not FUpdatingScheme then
  begin
    FScheme := scCustomScheme;
    RefreshScrollSize;

    UpdateVisibleCount(CountVisibleCells);
    Change;
  end;
end;

function TSCCustomColorPalette.GetGradientColor(Index: Integer): TColor;
var
  Step: Integer;
  R1, G1, B1, R2, G2, B2: Byte;
begin
  Step := FGradientStep;
  Dec(Step);

  if (Step < 1) or (index >= Step) then
  begin
    Result := FGradientStop;
    Exit;
  end;

  R1 := GetRValue(FGradientStart);
  G1 := GetGValue(FGradientStart);
  B1 := GetBValue(FGradientStart);

  R2 := GetRValue(FGradientStop);
  G2 := GetGValue(FGradientStop);
  B2 := GetBValue(FGradientStop);

  R2 := R1 + Trunc(Index * (R2 - R1) div Step);
  G2 := G1 + Trunc(Index * (G2 - G1) div Step);
  B2 := B1 + Trunc(Index * (B2 - B1) div Step);

  Result := RGB(R2, G2, B2);
end;

procedure TSCCustomColorPalette.UpdatePaletteScheme;
var
  I: integer;
begin
  if (FScheme = scCustomScheme) or FUpdatingScheme then Exit;

  FUpdatingScheme := True;
  try
    with FCells do
    begin
      BeginUpdate;
      Clear;
    end;

    case FScheme of
      scGrayScheme:
        for I := Low(scGrays_C) to High(scGrays_C) do
          FCells.Add.FColor := scGrays_C[I];
      scWin16Scheme:
        for I := Low(sc16_C) to High(sc16_C) do
          FCells.Add.FColor := sc16_C[I];
      scWin256Scheme:
        for I := Low(scWin256_C) to High(scWin256_C) do
          FCells.Add.FColor := scWin256_C[I];
      scIEScheme:
        for I := Low(scIE140_C) to High(scIE140_C) do
          FCells.Add.FColor := scIE140_C[I];
      scNetscape1Scheme:
        for I := Low(scNetscape216_C_1) to High(scNetscape216_C_1) do
          FCells.Add.FColor := scNetscape216_C_1[I];
      scNetscape2Scheme:
        for I := Low(scNetscape216_C_2) to High(scNetscape216_C_2) do
          FCells.Add.FColor := scNetscape216_C_2[I];
      scNetscape3Scheme:
        for I := Low(scNetscape3_C) to High(scNetscape3_C) do
          FCells.Add.FColor := scNetscape3_C[I];
      scGradientScheme:
        for I := 0 to FGradientStep - 1 do
          FCells.Add.FColor := GetGradientColor(I);
    end;

    UpdateVisibleCount(CountVisibleCells);
  finally
    FCells.EndUpdate;
    FUpdatingScheme := False;
    
    RefreshScrollSize;
  end;
end;

procedure TSCCustomColorPalette.UpdateScrollPos(Value: Integer);
begin
  if Value < 0 then
    Value := 0
  else
  if Value > FScrollSize then
    Value := FScrollSize;

  if FScrollPos <> Value then
  begin
    FScrollPos := Value;

    ArrangeScrolling;
    if FScrollPos = Value then
    begin
      Invalidate;
      Change;
    end;

    UpdateFocusedCell;
  end;
end;

function TSCCustomColorPalette.CountVisibleCells: Integer;
var
  I: Integer;
begin
  Result := 0;
  if FCells <> nil then
    for I := 0 to FCells.Count-1 do
      if FCells[I].Visible then Inc(Result);
end;

procedure TSCCustomColorPalette.Loaded;
begin
  inherited Loaded;
  FVisibleCount := CountVisibleCells;
  if FVisibleCount > 0 then
    ArrangeScrolling;
end;

procedure TSCCustomColorPalette.UpdateVisibleCount(Value: Integer);
begin
  if FVisibleCount <> Value then
  begin
    FVisibleCount := Value;
    ArrangeScrolling;
  end;
end;

function TSCCustomColorPalette.CellsClientRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if not CanGetClientRect then Exit;

  Result := ClientRect;
  if FShowButtons and (FScrollSize <= 0) then Exit;

  if FOrientation = scoVertical then
    InflateRect(Result, 0, -2*ScrollBtnSize)
  else InflateRect(Result, -2*ScrollBtnSize, 0);

  if Result.Right < Result.Left then
    Result.Right := Result.Left;
  if Result.Bottom < Result.Top then
    Result.Bottom := Result.Top;
end;

function TSCCustomColorPalette.GetBtnRect(const Up: Boolean): TRect;
var
  CR: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if not (FShowButtons and CanGetClientRect) then Exit;

  CR := ClientRect;
  if FOrientation = scoVertical then
  begin
    if Up then
    begin
      Result := CR;
      Result.Top := Result.Bottom - ScrollBtnSize + 2;
      if Result.Top > Result.Bottom then
        Result.Top := Result.Bottom;
    end else
    begin
      Result := CR;
      Result.Bottom := Result.Top + ScrollBtnSize - 2;
      if Result.Bottom < Result.Top then
        Result.Bottom := Result.Top;
    end;
  end else
  begin
    if Up then
    begin
      Result := CR;
      Result.Left := Result.Right - ScrollBtnSize + 2;
      if Result.Left > Result.Right then
        Result.Left := Result.Right;
    end else
    begin
      Result := CR;
      Result.Right := Result.Left + ScrollBtnSize - 2;
      if Result.Right < Result.Left then
        Result.Right := Result.Left;
    end;
  end;
end;

function TSCCustomColorPalette.GetScrollStyleOf(P: TPoint): TSCCPalScrollStyle;
var
  R: TRect;
begin
  Result := scpssNone;
  if not (FShowButtons and
    (FScrollSize > 0) and CanGetClientRect) then Exit;

  R := ClientRect;
  if not PtInRect(R, P) then Exit;

  R := GetBtnRect(True);
  if PtInRect(R, P) then
  begin
    Result := scpssUp;
    Exit;
  end else
  begin
    R := GetBtnRect(False);
    if PtInRect(R, P) then Result := scpssDown;
  end;
end;

procedure TSCCustomColorPalette.StopScrolling;
begin
  FScrolling := False;
  FScrollClick := scpssNone;

  if FScrollTimer <> -1 then
  begin
    if HandleAllocated then
      KillTimer(Handle, FScrollTimer);
    FScrollTimer := -1;

    Invalidate;
    Change;
  end;
end;

procedure TSCCustomColorPalette.ScrollPalette;
begin
  if not Scrolling then Exit;

  if FScrollClick = scpssUp then
    UpdateScrollPos(FScrollPos + (FCellWidth + FCellSpace))
  else
    UpdateScrollPos(FScrollPos - (FCellWidth + FCellSpace));
end;

procedure TSCCustomColorPalette.StartScrolling;
var
  ScStyle: TSCCPalScrollStyle;
begin
  if not HandleAllocated then Exit;

  if FScrollClick <> scpssNone then
  begin
    if ScrollPaused then
    begin
      ResumeScrolling;
      Exit;
    end;

    if FScrollClick <> scpssNone then
    begin
      ScStyle := FScrollClick;
      StopScrolling;

      if CanScroll(ScStyle = scpssUp) then
      begin
        UpdateFocusedCell;

        FScrollClick := ScStyle;
        FScrollTimer := SetTimer(Handle, SC_CPAL_SCROLLTIMERID, GetDoubleClickTime, nil);
        FScrolling := FScrollTimer <> -1;

        ScrollPalette;
      end;
    end;
  end;
end;

function TSCCustomColorPalette.Scrolling: Boolean;
begin
  Result := FScrolling and (FScrollClick <> scpssNone) and
    (FScrollTimer <> -1);
end;

function TSCCustomColorPalette.ScrollPaused: Boolean;
begin
  Result := not FScrolling and (FScrollClick <> scpssNone) and
    (FScrollTimer <> -1);
end;

procedure TSCCustomColorPalette.PauseScrolling;
begin
  FScrolling := False;
end;

procedure TSCCustomColorPalette.ResumeScrolling;
begin
  FScrolling := (FScrollClick <> scpssNone) and (FScrollTimer <> -1);
end;

procedure TSCCustomColorPalette.WMTimer(var Message: TWMTimer);
begin
  inherited;
  if HandleAllocated and Scrolling and
    (Message.TimerID = SC_CPAL_SCROLLTIMERID) then
  begin
    ScrollPalette;
    if FScrollTimer <> -1 then
      KillTimer(Handle, FScrollTimer);

    FScrollTimer := SetTimer(Handle, SC_CPAL_SCROLLTIMERID, 50, nil);
    FScrolling := FScrollTimer <> -1;
  end;
end;

procedure TSCCustomColorPalette.DrawScrollButtons(ACanvas: TCanvas; X,
  Y: Integer);

  procedure DrawBtnFrame(R: TRect; IsDown: Boolean);
  begin
    if IsDown then
    begin
      if FFlatButtons then
        scFrame3D(ACanvas, R, clBtnShadow, clBtnHighlight, 1, 0)
      else
        scFrame3D(ACanvas, R, cl3DDkShadow, clBtnHighlight, 1, 0);
    end else
    begin
      if FFlatButtons then
        scFrame3D(ACanvas, R, clBtnHighlight, clBtnShadow, 1, 0)
      else begin
        scFrame3D(ACanvas, R, clBtnHighlight, cl3DDkShadow, 1, 0);
        scFrame3D(ACanvas, R, clBtnFace, clBtnShadow, 1, 0);
      end;
    end;
  end;

var
  CR, R: TRect;
  OX, OY: Integer;
  IsBtnDown, CanDoScroll: Boolean;
begin
  if not ((FScrollSize > 0) and FShowButtons and
    CanGetClientRect and HandleAllocated) then Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left + X, -CR.Top + Y);
  if IsRectEmpty(CR) then Exit;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := DefaultBlendedColor(clBtnFace);

    if FOrientation = scoVertical then
    begin
      // Up button
      R := CR;
      R.Bottom := R.Top + ScrollBtnSize;

      if not IsRectEmpty(R) then
      begin
        Brush.Color := DefaultBlendedColor(Self.Color);
        FillRect(R);

        Dec(R.Bottom, 2);
        Brush.Color := DefaultBlendedColor(FScrollBtnColor);
        FillRect(R);

        if not IsRectEmpty(R) then
        begin
          CanDoScroll := CanScrollVertically(False);
          IsBtnDown := CanDoScroll and Scrolling and (FScrollClick = scpssDown);

          OX := R.Left + ((R.Right - R.Left) div 2);
          OY := R.Top + ((R.Bottom - R.Top - 3) div 2);
          if IsBtnDown then
          begin
            Inc(OX);
            Inc(OY);
          end;

          Pen.Style := psSolid;
          if CanDoScroll then
            Pen.Color := FScrollArrowColor
          else Pen.Color := clBtnShadow;

          MoveTo(OX,   OY);
          LineTo(OX+1, OY);
          MoveTo(OX-1, OY+1);
          LineTo(OX+2, OY+1);
          MoveTo(OX-2, OY+2);
          LineTo(OX+3, OY+2);
          MoveTo(OX-3, OY+3);
          LineTo(OX+4, OY+3);

          DrawBtnFrame(R, IsBtnDown);
        end;
      end;

      // Down button
      R := CR;
      R.Top := R.Bottom - ScrollBtnSize;

      if not IsRectEmpty(R) then
      begin
        Brush.Color := DefaultBlendedColor(Self.Color);
        FillRect(R);

        Inc(R.Top, 2);
        Brush.Color := DefaultBlendedColor(FScrollBtnColor);
        FillRect(R);

        if not IsRectEmpty(R) then
        begin
          CanDoScroll := CanScrollVertically(True);
          IsBtnDown := CanDoScroll and Scrolling and (FScrollClick = scpssUp);

          OX := R.Left + ((R.Right - R.Left) div 2);
          OY := R.Top + ((R.Bottom - R.Top + 3) div 2);
          if IsBtnDown then Inc(OY);

          Pen.Style := psSolid;
          if CanDoScroll then
            Pen.Color := FScrollArrowColor
          else Pen.Color := clBtnShadow;

          MoveTo(OX,   OY);
          LineTo(OX+1, OY);
          MoveTo(OX-1, OY-1);
          LineTo(OX+2, OY-1);
          MoveTo(OX-2, OY-2);
          LineTo(OX+3, OY-2);
          MoveTo(OX-3, OY-3);
          LineTo(OX+4, OY-3);

          DrawBtnFrame(R, IsBtnDown);
        end;
      end;
    end else
    begin
      // Left button
      R := CR;
      R.Right := R.Left + ScrollBtnSize;

      if not IsRectEmpty(R) then
      begin
        Brush.Color := DefaultBlendedColor(Self.Color);
        FillRect(R);

        Dec(R.Right, 2);
        Brush.Color := DefaultBlendedColor(FScrollBtnColor);
        FillRect(R);

        if not IsRectEmpty(R) then
        begin
          CanDoScroll := CanScrollHorizontally(False);
          IsBtnDown := CanDoScroll and Scrolling and (FScrollClick = scpssDown);

          OX := R.Left + ((R.Right - R.Left - 4) div 2)-1;
          OY := R.Top + ((R.Bottom - R.Top) div 2);
          if IsBtnDown then
          begin
            Inc(OX);
            Inc(OY);
          end;

          Pen.Style := psSolid;
          if CanDoScroll then
            Pen.Color := FScrollArrowColor
          else Pen.Color := clBtnShadow;

          MoveTo(OX,   OY);
          LineTo(OX,   OY+1);
          MoveTo(OX+1, OY-1);
          LineTo(OX+1, OY+2);
          MoveTo(OX+2, OY-2);
          LineTo(OX+2, OY+3);
          MoveTo(OX+3, OY-3);
          LineTo(OX+3, OY+4);

          DrawBtnFrame(R, IsBtnDown);
        end;
      end;

      // Right button
      R := CR;
      R.Left := R.Right - ScrollBtnSize;

      if not IsRectEmpty(R) then
      begin
        Brush.Color := DefaultBlendedColor(Self.Color);
        FillRect(R);

        Inc(R.Left, 2);
        Brush.Color := DefaultBlendedColor(FScrollBtnColor);
        FillRect(R);

        if not IsRectEmpty(R) then
        begin
          CanDoScroll := CanScrollHorizontally(True);
          IsBtnDown := CanDoScroll and Scrolling and (FScrollClick = scpssUp);

          OX := R.Left + ((R.Right - R.Left + 4) div 2)-1;
          OY := R.Top + ((R.Bottom - R.Top) div 2);
          if IsBtnDown then Inc(OY);

          Pen.Style := psSolid;
          if CanDoScroll then
            Pen.Color := FScrollArrowColor
          else Pen.Color := clBtnShadow;

          MoveTo(OX,   OY);
          LineTo(OX,   OY+1);
          MoveTo(OX-1, OY-1);
          LineTo(OX-1, OY+2);
          MoveTo(OX-2, OY-2);
          LineTo(OX-2, OY+3);
          MoveTo(OX-3, OY-3);
          LineTo(OX-3, OY+4);

          DrawBtnFrame(R, IsBtnDown);
        end;
      end;
    end;
  end;
end;

function TSCCustomColorPalette.CanScroll(AsUp: Boolean): Boolean;
begin
  Result := ((FOrientation = scoVertical) and CanScrollVertically(AsUp)) or
    ((FOrientation = scoHorizontal) and CanScrollHorizontally(AsUp));
end;

procedure TSCCustomColorPalette.SetScrollArrowColor(Value: TColor);
begin
  if FScrollArrowColor <> Value then
  begin
    FScrollArrowColor := Value;
    if FShowButtons and (ScrollSize > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomColorPalette.SetScrollBtnColor(Value: TColor);
begin
  if FScrollBtnColor <> Value then
  begin
    FScrollBtnColor := Value;
    if FShowButtons and (FScrollSize > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomColorPalette.CMCancelMode(var Message: TCMCancelMode);
begin
  inherited;
  if HandleAllocated and (Message.Sender <> Self) then
  begin
    FMouseIsDown := False;
    FClickedCell := -1;
    FFocusedCell := -1;

    if Scrolling or ScrollPaused then
      StopScrolling;
  end;
end;

procedure TSCCustomColorPalette.SetShowFocused(Value: Boolean);
begin
  if FShowFocused <> Value then
  begin
    FShowFocused := Value;
    if FFocusedColor <> -1 then
      Invalidate;
  end;
end;

procedure TSCCustomColorPalette.SetShowForeColor(Value: Boolean);
begin
  if FShowForeColor <> Value then
  begin
    FShowForeColor := Value;
    if FForeColor <> -1 then
      Invalidate;
  end;
end;

procedure TSCCustomColorPalette.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    if FShowBackColor then Invalidate;

    if Assigned(FOnBkColorChange) then
      FOnBkColorChange(Self);
    if (Self <> nil) and HandleAllocated then
      Change;
  end;
end;

procedure TSCCustomColorPalette.SetShowBackColor(Value: Boolean);
begin
  if FShowBackColor <> Value then
  begin
    FShowBackColor := Value;
    if FBackColor <> -1 then
      Invalidate;
  end;
end;

procedure TSCCustomColorPalette.RefreshScrollSize;
var
  P, S: Integer;
begin
  P := FScrollPos;
  S := FScrollSize;

  ArrangeScrolling;

  if (FScrollPos = P) and (FScrollSize = S) then
  begin
    Invalidate;
    Change;
  end;
end;

procedure TSCCustomColorPalette.SetSelectionColor(Value: TColor);
begin
  if FSelectionColor <> Value then
  begin
    FSelectionColor := Value;
    if (FShowForeColor and (FForeColor <> -1)) or
      (FShowBackColor and (FBackColor <> -1)) or
      (FShowFocused and (FFocusedColor <> -1)) then Invalidate;
  end;
end;

procedure TSCCustomColorPalette.SetShowButtons(Value: Boolean);
begin
  if FShowButtons <> Value then
  begin
    FShowButtons := Value;
    if FScrollSize > 0 then
      Invalidate;
  end;
end;

procedure TSCCustomColorPalette.SetFlatButtons(Value: Boolean);
begin
  if FFlatButtons <> Value then
  begin
    FFlatButtons := Value;
    if FShowButtons and (FScrollSize > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomColorPalette.WMMouseWheel(var Message: TWMMouseWheel);
var
  ScrBy: Integer;
begin
  ScrBy := 0;
  if Message.WheelDelta < 0 then
    ScrBy := FCellWidth + FCellSpace
  else
  if Message.WheelDelta > 0 then
    ScrBy := -(FCellWidth + FCellSpace);

  ScrBy := ScrBy*MouseWheelLine;
  UpdateScrollPos(FScrollPos + ScrBy);
end;

procedure TSCCustomColorPalette.UpdateFocusedCell;
var
  P: TPoint;
  ScStyle: TSCCPalScrollStyle;
begin
  if not FShowFocused or Scrolling or ScrollPaused then
  begin
    SetFocusedCell(-1);
    SetFocusedColor(-1);

    Exit;
  end;

  if CanGetClientRect and GetCursorPos(P) then
  begin
    P := Self.ScreenToClient(P);
    if not PtInRect(ClientRect, P) then
    begin
      SetFocusedCell(-1);
      SetFocusedColor(-1);

      Exit;
    end;

    ScStyle := GetScrollStyleOf(P);

    if ScStyle <> scpssNone then
      SetFocusedCell(-1)
    else begin
      SetFocusedCell(CellAtPos(P));
      if not ((FFocusedCell > -1) and (FFocusedCell < FCells.Count) and
        FCells[FFocusedCell].Enabled) then SetFocusedCell(-1);
    end;

    if FFocusedCell <> -1 then
      SetFocusedColor(FCells[FFocusedCell].Color)
    else SetFocusedColor(-1);
  end;
end;

procedure TSCCustomColorPalette.IndentChanged;
begin
  RefreshScrollSize;
end;

procedure TSCCustomColorPalette.CMHintShow(var Msg: TMessage);
const
  EmptyHint = '';
var
  Indx: Integer;
  P: TPoint;
  R, HRect: TRect;
begin
  inherited;

  with TCMHintShow(Msg) do
  begin
    P := HintInfo.CursorPos;

    Indx := CellAtPos(P);
    if (Indx > -1) and (Indx < FCells.Count) then
    begin
      HintInfo.CursorRect := GetCellRect(Indx);

      if not (FCells[Indx].Visible and FCells[Indx].Enabled) then
      begin
        HintInfo.HintStr := EmptyHint;
        Result := 1;
      end else
      begin
        HintInfo.HintStr := GetCellHint(FCells[Indx]);
        if HintInfo.HintStr = '' then Result := 1;
      end;
    end else
    begin
      HRect := ClientRect;
      HintInfo.HintStr := EmptyHint;

      R := GetBtnRect(True);
      if PtInRect(R, P) then HRect := R
      else begin
        R := GetBtnRect(False);
        if PtInRect(R, P) then HRect := R;
      end;

      HintInfo.CursorRect := HRect;
      Result := 1;
    end;
  end;
end;

function TSCCustomColorPalette.GetCellHint(ACell: TSCColorCell): String;
var
  C: LongInt;
  R, G, B: Byte;
  AColor: TColor;
begin
  Result := '';
  if ACell = nil then Exit;

  Result := ACell.Hint;
  if Result = '' then
  begin
    AColor := ACell.Color;
    if AColor = clNone then AColor := Self.Color;

    C := ColorToRGB(AColor);

    R := GetRValue(C);
    G := GetGValue(C);
    B := GetBValue(C);

    case FHintStyle of
      scphHex:
      begin
        Result := FHintHexCaption + IntToHex(R, 2) + IntToHex(G, 2) + IntToHex(B, 2);
      end;
      scphRGB:
      begin
        Result := 'R:' + IntToStr(R) + ', G:' + IntToStr(G) +
          ', B:' + IntToStr(B);
      end;
      scphHexAndRGB:
      begin
        Result := 'R:' + IntToStr(R) + ', G:' + IntToStr(G) +
          ', B:' + IntToStr(B);
        Result := Result + ', ' +
          FHintHexCaption + IntToHex(R, 2) + IntToHex(G, 2) + IntToHex(B, 2);
      end;
      scphRGBAndHex:
      begin
        Result := FHintHexCaption + IntToHex(R, 2) + IntToHex(G, 2) + IntToHex(B, 2);
        Result := Result + ', R:' + IntToStr(R) + ', G:' + IntToStr(G) +
          ', B:' + IntToStr(B);
      end;
    end;
  end;
end;

procedure TSCCustomColorPalette.DoCellClick(Index: Integer);
begin
  if (Index > -1) and (Index < FCells.Count) then
  begin
    if not FDblClicked and Assigned(FOnCellClick) then
      FOnCellClick(Self, Index);
    FDblClicked := False;
  end;
end;

procedure TSCCustomColorPalette.DoCellDblClick(Index: Integer);
begin
  if (Index > -1) and (Index < FCells.Count) then
  begin
    FDblClicked := True;
    if Assigned(FOnCellDblClick) then
      FOnCellDblClick(Self, Index);
  end;
end;

procedure TSCCustomColorPalette.DoCellMouseDown(Index: Integer;
  Button: TMouseButton; Shift: TShiftState);
begin
  if (Index > -1) and (Index < FCells.Count) then
  begin
    if (Button = mbLeft) and (ssDouble in Shift) and
      (Index = FOldClickedCell) then
    begin
      FOldClickedCell := -1;
      DoCellDblClick(Index);
    end;

    if (Self <> nil) and HandleAllocated and Assigned(FOnCellMouseDown) then
      FOnCellMouseDown(Self, Index, Button, Shift);
  end;
end;

procedure TSCCustomColorPalette.DoCellMouseUp(Index: Integer;
  Button: TMouseButton; Shift: TShiftState);
begin
  if (Index > -1) and (Index < FCells.Count) then
  begin
    if (Button = mbLeft) and (Index = FOldClickedCell) then
      DoCellClick(Index);

    if (Self <> nil) and HandleAllocated and Assigned(FOnCellMouseUp) then
      FOnCellMouseUp(Self, Index, Button, Shift);
  end;
end;

procedure TSCCustomColorPalette.SetGradientStart(Value: TColor);
begin
  if FGradientStart <> Value then
  begin
    FGradientStart := Value;

    if FScheme = scGradientScheme then
    begin
      UpdatePaletteScheme;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomColorPalette.SetGradientStep(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if Value > 1024 then Value := 1024;

  if FGradientStep <> Value then
  begin
    FGradientStep := Value;

    if FScheme = scGradientScheme then
    begin
      UpdatePaletteScheme;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomColorPalette.SetGradientStop(Value: TColor);
begin
  if FGradientStop <> Value then
  begin
    FGradientStop := Value;

    if FScheme = scGradientScheme then
    begin
      UpdatePaletteScheme;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomColorPalette.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomColorPalette then
  begin
    with TSCCustomColorPalette(Source) do
    begin
      Self.BackColor := BackColor;
      Self.CanSelectBackColor := CanSelectBackColor;
      Self.CellBorderColor := CellBorderColor;
      Self.Cells := Cells;
      Self.CellSpace := CellSpace;
      Self.CellWidth := CellWidth;
      Self.HintHexCaption := HintHexCaption;
      Self.HintStyle := HintStyle;
      Self.FlatButtons := FlatButtons;
      Self.ForeColor := ForeColor;
      Self.GradientStart := GradientStart;
      Self.GradientStop := GradientStop;
      Self.GradientStep := GradientStep;
      Self.Orientation := Orientation;
      Self.PickerCursor := PickerCursor;
      Self.ScrollArrowColor := ScrollArrowColor;
      Self.ScrollBtnColor := ScrollBtnColor;
      Self.SelectionColor := SelectionColor;
      Self.Scheme := Scheme;
      Self.ShowBackColor := ShowBackColor;
      Self.ShowButtons := ShowButtons;
      Self.ShowFocused := ShowFocused;
      Self.ShowForeColor := ShowForeColor;
      Self.Style := Style;
      Self.TopIndent := TopIndent;
    end;
  end;
end;

{ TSCCustomColorSelectBox }

procedure TSCCustomColorSelectBox.Click;
var
  P: TPoint;
  Part: TSCColorSelectorPart;
begin
  inherited Click;

  if FClickSwaps and GetCursorPos(P) then
  begin
    P := Self.ScreenToClient(P);
    
    Part := PartAtPos(P.x, P.y);
    if Part in [sccpBackColor, sccpForeColor] then
      SwapColors;
  end;
end;

constructor TSCCustomColorSelectBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(Left, Top, 50, 50);
  Indent := 4;
  Spacing := 4;
  BlendColor := False;
  Border := sccb3DLowered;

  FAutoSized := True;
  FBackColor := clNone;
  FCellBorderColor := cl3DDkShadow;
  FCellWidth := 20;
  FForeColor := clNone;
  FLayout := scclFrontBack;
  FNoneColor := clNone;
  FNoneDiagonal := clRed;
  FNoneStyle := scncNone;
  FStyle := scpsRaised;
end;

procedure TSCCustomColorSelectBox.DrawDiagonal(C: TCanvas; InR: TRect);
var
  SR, I, Step, P: Integer;
begin
  if not IsRectEmpty(InR) and (FNoneStyle in [scncDiagonal, scncDiagonalCross]) then
    with C do
    begin
      Pen.Style := psSolid;
      Pen.Width := 1;
      Pen.Color := FNoneDiagonal;
      
      if FNoneDiagonal = clNone then
      begin
        if IsColorLight(clNone) then
          Pen.Color := clBlack
        else
          Pen.Color := clWhite;
      end;

      SR := IntersectClipRect(C.Handle, InR.Left, InR.Top,
        InR.Right, InR.Bottom);
      try
        if SR <> NULLREGION then
        begin
          Step := (InR.Right - InR.Left) div 4;

          for I := 0 to Step do
          begin
            P := InR.Left - (InR.Right - InR.Left) + I*8;

            MoveTo(P, InR.Top);
            LineTo((InR.Bottom - InR.Top) + P, InR.Bottom);
          end;

          if FNoneStyle = scncDiagonalCross then
            for I := 0 to Step do
            begin
              P := InR.Left + I*8 - 4;

              MoveTo(P, InR.Top);
              LineTo(P - (InR.Bottom - InR.Top), InR.Bottom);
            end;
        end;
      finally
        SelectClipRgn(C.Handle, 0);
      end;
    end;
end;

procedure TSCCustomColorSelectBox.DrawFrame(C: TCanvas;
  R: TRect; Cl: TColor; IsFore: Boolean = True);
begin
  case Style of
    scpsDefault:
    begin
      scFrame3D(C, R, clBtnShadow, clBtnHighlight, 1, 0);
      scFrame3D(C, R, cl3DDkShadow, clBtnFace, 1, 0);
    end;
    scpsSunkenFlat:
      scFrame3D(C, R, clBtnShadow, clBtnHighlight, 1, 0);
    scpsMetal:
    begin
      scFrame3D(C, R, clBtnShadow, clBtnHighlight, 1, 0);
      scFrame3D(C, R, GetBtnFaceOf(Cl), GetBtnFaceOf(Cl), 1, 0);
    end;
    scpsFlat:
      scFrame3D(C, R, FCellBorderColor, FCellBorderColor, 1, 0);
    scpsMac:
    begin
      scFrame3D(C, R, clBtnShadow, clBtnHighlight, 1, 0);
      scFrame3D(C, R, clWindowFrame, clWindowFrame, 1, 0);
    end;
    scpsRaisedFlat:
      scFrame3D(C, R, clBtnHighlight, clBtnShadow, 1, 0);
    scpsRaised:
    begin
      scFrame3D(C, R, clBtnHighlight, cl3DDkShadow, 1, 0);
      scFrame3D(C, R, clBtnFace, clBtnShadow, 1, 0);
    end;
    scpsXP:
    begin
      scFrame3D(C, R, clBtnHighlight, clBtnHighlight, 1, 0);
      InflateRect(R, 1, 1);

      Dec(R.Right);
      Dec(R.Bottom);
      
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, cl3DDkShadow, cl3DDkShadow, 1, 0);
        scFrame3D(C, R, clBtnHighlight, clBtnFace, 1, 0);
      end;
    end;
  end;
end;

procedure TSCCustomColorSelectBox.DrawOnCanvas(ACanvas: TCanvas; X,
  Y: Integer);
var
  R: TRect;
  C: TColor;
  Bs: Integer;
begin
  if not (CanGetClientRect and (ACanvas <> nil)) then
    Exit;

  R := ClientRect;
  OffsetRect(R, -R.Left + X, -R.Top + Y);
  if IsRectEmpty(R) then Exit;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetFaceColor;
    FillRect(R);
  end;

  Bs := GetFrameBorderSize;

  // First draw Back cell
  R := GetBackCell;
  InflateRect(R, -Bs, -Bs);

  if not IsRectEmpty(R) then
  begin
    C := FBackColor;
    if (C = clNone) and (FNoneStyle <> scncNone) then
      C := FNoneColor;

    with ACanvas do
    begin
      Brush.Color := C;
      FillRect(R);

      if (FBackColor = clNone) and (FNoneStyle in [scncDiagonal, scncDiagonalCross]) then
        DrawDiagonal(ACanvas, R);
    end;

    InflateRect(R, Bs, Bs);
    DrawFrame(ACanvas, R, C, False);
  end;

  // Then draw Fore cell
  R := GetForeCell;
  InflateRect(R, -Bs, -Bs);

  if not IsRectEmpty(R) then
  begin
    C := FForeColor;
    if (C = clNone) and (FNoneStyle <> scncNone) then
      C := FNoneColor;

    with ACanvas do
    begin
      Brush.Color := C;
      FillRect(R);

      if (FForeColor = clNone) and (FNoneStyle in [scncDiagonal, scncDiagonalCross]) then
        DrawDiagonal(ACanvas, R);
    end;

    InflateRect(R, Bs, Bs);
    DrawFrame(ACanvas, R, C, True);
  end;  
end;

function TSCCustomColorSelectBox.GetBackCell: TRect;
var
  CellW: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  CellW := GetCellWidth;

  if CellW > 0 then
  begin
    Result := ClientRect;
    InflateRect(Result, -Indent, -Indent);

    if not IsRectEmpty(Result) then
    begin
      case FLayout of
        scclFrontBack:
        begin
          Result.Right := Result.Left + CellW;
          Result.Bottom := Result.Top + CellW;

          CellW := CellW div 2;
          if CellW > 0 then OffsetRect(Result, CellW, CellW);
        end;
        sccLeftRight:
        begin
          if FAutoSized then
            Result.Left := Result.Right - CellW
          else begin
            Result.Right := Result.Left + CellW;
            OffsetRect(Result, CellW + Spacing, 0);
          end;
        end;
        scclTopBottom:
        begin
          if FAutoSized then
            Result.Top := Result.Bottom - CellW
          else begin
            Result.Bottom := Result.Top + CellW;
            OffsetRect(Result, 0, CellW + Spacing);
          end;  
        end;
      end;
    end;
  end;
end;

function TSCCustomColorSelectBox.GetBlendValue: Word;
begin
  Result := 0;
  if BlendColor then Result := 20;
end;

function TSCCustomColorSelectBox.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSC3DSunkenBorderProps;
end;

function TSCCustomColorSelectBox.GetCellWidth: Integer;
var
  R: TRect;
begin
  Result := FCellWidth;
  if FAutoSized and CanGetClientRect then
  begin
    Result := 0;

    R := ClientRect;
    InflateRect(R, -Indent, -Indent);
    if IsRectEmpty(R) then
      Exit;

    OffsetRect(R, -R.Left, -R.Top);

    case FLayout of
      scclFrontBack:
      begin
        Result := R.Right;
        if R.Bottom < R.Right then
          Result := R.Bottom;

        Result := 2*(Result div 3);
      end;
      sccLeftRight:
        Result := (R.Right - Spacing) div 2;
      scclTopBottom:
        Result := (R.Bottom - Spacing) div 2;
    end;
  end;
  
  if Result < 0 then Result := 0;
end;

function TSCCustomColorSelectBox.GetFrameBorderSize: Integer;
begin
  Result := 0;
  case FStyle of
    scpsDefault, scpsMac,
    scpsMetal, scpsRaised, scpsXP:
      Result := 2;
    scpsSunkenFlat, scpsFlat,
    scpsExtraFlat, scpsRaisedFlat:
      Result := 1;
  end;
end;

function TSCCustomColorSelectBox.GetForeCell: TRect;
var
  CellW: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  CellW := GetCellWidth;

  if CellW > 0 then
  begin
    Result := ClientRect;
    InflateRect(Result, -Indent, -Indent);

    if not IsRectEmpty(Result) then
      case FLayout of
        scclFrontBack:
        begin
          Result.Right := Result.Left + CellW;
          Result.Bottom := Result.Top + CellW;
        end;
        sccLeftRight:
          Result.Right := Result.Left + CellW;
        scclTopBottom:
          Result.Bottom := Result.Left + CellW;
      end;
  end;
end;

procedure TSCCustomColorSelectBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Part: TSCColorSelectorPart;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if FDblClickSwaps and (Button = mbLeft) and (ssDouble in Shift) then
  begin
    Part := PartAtPos(X, Y);
    if Part in [sccpBackColor, sccpForeColor] then
      SwapColors;
  end;
end;

procedure TSCCustomColorSelectBox.Paint;
var
  Bmp: TSCBitmap;
  R: TRect;
begin
  if not HandleAllocated then
    Exit;

  Bmp := nil;
  try
    R := ClientRect;
    if IsRectEmpty(R) then Exit;

    Bmp := TSCBitmap.Create;
    Bmp.SetBounds(R.Right - R.Left, R.Bottom - R.Top);

    DrawOnCanvas(Bmp.Canvas, 0, 0);
    Canvas.Draw(0, 0, Bmp);
  finally
    if Bmp <> nil then Bmp.Free;
  end;
end;

function TSCCustomColorSelectBox.PartAtPos(X, Y: Integer): TSCColorSelectorPart;
var
  P: TPoint;
  R: TRect;
  CellW: Integer;
begin
  Result := sccpNone;

  P := Point(X, Y);
  R := ClientRect;

  if PtInRect(R, P) then
  begin
    Result := sccpClient;

    InflateRect(R, -Indent, -Indent);
    if IsRectEmpty(R) then
      Exit;

    CellW := GetCellWidth;
    if CellW <= 0 then
      Exit;

    R := GetForeCell;
    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      Result := sccpForeColor;
      Exit;
    end;

    R := GetBackCell;
    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      Result := sccpBackColor;
      Exit;
    end;
  end;
end;

procedure TSCCustomColorSelectBox.SetAutoSized(Value: Boolean);
begin
  if FAutoSized <> Value then
  begin
    FAutoSized := Value;
    Invalidate;
  end;
end;

procedure TSCCustomColorSelectBox.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Invalidate;
    Change;
  end;
end;

procedure TSCCustomColorSelectBox.SetCellBorderColor(Value: TColor);
begin
  if FCellBorderColor <> Value then
  begin
    FCellBorderColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomColorSelectBox.SetCellWidth(Value: Integer);
begin
  if Value < 8 then
    Value := 8
  else
  if Value > 100 then
    Value := 100;

  if FCellWidth <> Value then
  begin
    FCellWidth := Value;
    Invalidate;
  end;
end;

procedure TSCCustomColorSelectBox.SetClickSwaps(Value: Boolean);
begin
  FClickSwaps := Value;
end;

procedure TSCCustomColorSelectBox.SetDblClickSwaps(Value: Boolean);
begin
  FDblClickSwaps := Value;
end;

procedure TSCCustomColorSelectBox.SetForeColor(Value: TColor);
begin
  if FForeColor <> Value then
  begin
    FForeColor := Value;
    Invalidate;
    Change;
  end;
end;

procedure TSCCustomColorSelectBox.SetLayout(Value: TSCColorSelectorLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TSCCustomColorSelectBox.SetNoneColor(Value: TColor);
begin
  if FNoneColor <> Value then
  begin
    FNoneColor := Value;
    if (FBackColor = clNone) or (FForeColor = clNone) then
      Invalidate;
  end;
end;

procedure TSCCustomColorSelectBox.SetNoneDiagonal(Value: TColor);
begin
  if FNoneDiagonal <> Value then
  begin
    FNoneDiagonal := Value;
    if (FBackColor = clNone) or (FForeColor = clNone) then
      Invalidate;
  end;
end;

procedure TSCCustomColorSelectBox.SetNoneStyle(Value: TSCNoneColorStyle);
begin
  if FNoneStyle <> Value then
  begin
    FNoneStyle := Value;
    if (FBackColor = clNone) or (FForeColor = clNone) then
      Invalidate;
  end;
end;

procedure TSCCustomColorSelectBox.SetSpacing(Value: Integer);
begin
  if Value < 0 then Value := 0;
  inherited SetSpacing(Value);
end;

procedure TSCCustomColorSelectBox.SetStyle(Value: TSCColorPalStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
    Change;
  end;
end;

procedure TSCCustomColorSelectBox.SwapColors;
var
  C: TColor;
begin
  if FBackColor <> FForeColor then
  begin
    C := FBackColor;
    FBackColor := FForeColor;
    FForeColor := C;

    Invalidate;
    Change;
  end;
end;

procedure TSCCustomColorSelectBox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomColorSelectBox then
  begin
    with TSCCustomColorSelectBox(Source) do
    begin
      Self.AutoSized := AutoSized;
      Self.BackColor := BackColor;
      Self.CellBorderColor := CellBorderColor;
      Self.CellWidth := CellWidth;
      Self.ClickSwaps := ClickSwaps;
      Self.DblClickSwaps := DblClickSwaps;
      Self.ForeColor := ForeColor;
      Self.Layout := Layout;
      Self.NoneColor := NoneColor;
      Self.NoneDiagonal := NoneDiagonal;
      Self.NoneStyle := NoneStyle;
      Self.Style := Style;
    end;
  end;
end;

{ TSCCustomGradient }

procedure TSCCustomGradient.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomGradient then
  begin
    with TSCCustomGradient(Source) do
    begin
      Self.ColorCount := ColorCount;
      Self.ColorPointer := ColorPointer;
      Self.SelectedColor := SelectedColor;
    end;
  end;
end;

procedure TSCCustomGradient.BoundsChanged;
begin
  //
end;

constructor TSCCustomGradient.Create(AOwner: TComponent);
begin
  FGradientBmp := TSCBitmap.Create;
  FSelectedColor := -1;
  FColorCount   := 80;

  inherited Create(AOwner);
  Border := sccb3DLowered;
  SetBounds(Left, Top, 180, 200);
  // DoubleBuffered := True;

  FColorPointer := scptSquare;
  FNeedUpdate := True;
end;

procedure TSCCustomGradient.CreateWnd;
begin
  inherited CreateWnd;
  FNeedSizeUpdate := True;
  DoUpdateChange(True);
end;

destructor TSCCustomGradient.Destroy;
begin
  FGradientBmp.Free;
  inherited Destroy;
end;

procedure TSCCustomGradient.DoUpdateChange(NeedUpdate: Boolean);
begin
  FNeedUpdate := FNeedUpdate or NeedUpdate;
  Invalidate;
  Change;
end;

procedure TSCCustomGradient.DrawSelectionPointer;
begin
  // for future use
end;

function TSCCustomGradient.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSC3DSunkenBorderProps;
end;

function TSCCustomGradient.GetGradientBmp: TSCBitmap;
begin
  Result := FGradientBmp;
end;

function TSCCustomGradient.GetSelectedColor: TColor;
begin
  Result := FSelectedColor;
end;

procedure TSCCustomGradient.Loaded;
begin
  inherited Loaded;
  FNeedUpdate := True;
  Invalidate;
end;

procedure TSCCustomGradient.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseIsDown := False;
  if ClickFocus and CanFocus and not Focused then
    Exit;

  MouseIsDown := Button = mbLeft;
  if MouseIsDown then SetSelectedPoint(X, Y);

  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TSCCustomGradient.MouseMove(Shift: TShiftState; X,
  Y: Integer);
begin
  if MouseIsDown then SetSelectedPoint(X, Y);

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomGradient.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if MouseIsDown then SetSelectedPoint(X, Y);
  MouseIsDown := False;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomGradient.Paint;
var
  R: TRect;
begin
  if not HandleAllocated then Exit;

  if FGradientBmp <> nil then
  begin
    UpdateGradientBmp(FNeedSizeUpdate);
    Canvas.Draw(0, 0, FGradientBmp);
  end else
  begin
    R := ClientRect;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Self.Color;
      FillRect(R);
    end;
  end;

  DrawSelectionPointer;
end;

procedure TSCCustomGradient.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
var
  H, W: Integer;
begin
  H := Height; W := Width;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if (Height <> H) or (Width <> W) then
  begin
    BoundsChanged;

    FNeedUpdate := True;
    FNeedSizeUpdate := True;
    Invalidate;
  end;
end;

procedure TSCCustomGradient.SetColorCount(Value: Integer);
begin
  FColorCount := Value;
end;

procedure TSCCustomGradient.SetColorPointer(
  Value: TSCColorPointerType);
begin
  if FColorPointer <> Value then
  begin
    FColorPointer := Value;
    Invalidate;
  end;
end;

procedure TSCCustomGradient.SetSelectedColor(Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;
    DoUpdateChange(FNeedUpdate);
  end;
end;

procedure TSCCustomGradient.SetSelectedPoint(X, Y: Integer);
begin
  FSelectedPoint.x := X;
  FSelectedPoint.y := Y;
end;

procedure TSCCustomGradient.UpdateGradientBmp(WithSize: Boolean);
var
  R: TRect;
begin
  if FNeedUpdate and not FLockUpdate and
    HandleAllocated and (FGradientBmp <> nil) then
  begin
    FNeedUpdate := False;
    FNeedSizeUpdate := False;

    R := ClientRect;
    OffsetRect(R, -R.Left, -R.Top);

    if WithSize then
      FGradientBmp.SetBounds(R.Right, R.Bottom);

    with FGradientBmp.Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Self.Color;
      FillRect(R);
    end;
  end;
end;

{ TSCCustomCornerGradient }

procedure TSCCustomCornerGradient.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomCornerGradient then
  begin
    with TSCCustomCornerGradient(Source) do
    begin
      Self.LeftTop := LeftTop;
      Self.LeftBottom := LeftBottom;
      Self.RightTop := RightTop;
      Self.RightBottom := RightBottom;
    end;
  end;
end;

constructor TSCCustomCornerGradient.Create(AOwner: TComponent);
begin
  FCLeftTop     := clBlack;
  FCLeftBottom  := clGray;
  FCRightTop    := clRed;
  FCRightBottom := clWhite;

  inherited Create(AOwner);
  BlendColor := False;
end;

procedure TSCCustomCornerGradient.DrawSelectionPointer;
var
  R, PointRect: TRect;
  X, Y: Integer;
  Pts: array[0..4] of TPoint;
begin
  if (FSelectedColor = -1) and (Canvas <> nil) then Exit;

  PointRect := Rect(FSelectedPoint.x - 6, FSelectedPoint.y - 6,
    FSelectedPoint.x + 6, FSelectedPoint.y + 6);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := FSelectedColor;

    Pen.Style := psSolid;
    Pen.Width := 1;
    Pen.Mode := pmCopy;
  end;

  case FColorPointer of
    scptSquare:
    begin
      R := PointRect;
      Canvas.FillRect(R);

      scFrame3D(Canvas, R, clBlack, clBlack, 1, 0);
      scFrame3D(Canvas, R, clWhite, clWhite, 1, 0);
    end;
    scptFlippedSquare:
    begin
      R := PointRect;

      Pts[0] := Point(FSelectedPoint.x, R.Top);
      Pts[1] := Point(R.Right, FSelectedPoint.y);
      Pts[2] := Point(FSelectedPoint.x, R.Bottom);
      Pts[3] := Point(R.Left, FSelectedPoint.y);
      Pts[4] := Pts[0];

      with Canvas do
      begin
        Pen.Color := clBlack;
        Polygon(Pts);

        Dec(Pts[0].y);
        Dec(Pts[1].y);
        Dec(Pts[2].y);
        Dec(Pts[3].y);
        Dec(Pts[4].y);

        Pen.Color := clWhite;
        Polygon(Pts);
      end;
    end;
    scptCircle:
    begin
      R := PointRect;
      InflateRect(R, 1, 1);

      Inc(R.Right);
      Inc(R.Bottom);

      with Canvas do
      begin
        Pen.Color := clBlack;
        Ellipse(R.Left, R.Top, R.Right, R.Bottom);

        InflateRect(R, -1, -1);

        Pen.Color := clWhite;
        Ellipse(R.Left, R.Top, R.Right, R.Bottom);
      end;
    end;
    scptCross:
    begin
      R := PointRect;
      InflateRect(R, 4, 4);

      with Canvas do
      begin
        // left part
        X := R.Left;
        Y := R.Top + ((R.Bottom - R.Top) div 2);

        Pen.Color := clBlack;
        MoveTo(X, Y);
        LineTo(X + 5, Y);

        Pen.Color := clWhite;
        MoveTo(X, Y + 1);
        LineTo(X + 5, Y + 1);

        // right part
        X := R.Right;
        Y := R.Top + ((R.Bottom - R.Top) div 2);

        Pen.Color := clBlack;
        MoveTo(X, Y);
        LineTo(X - 5, Y);

        Pen.Color := clWhite;
        MoveTo(X, Y + 1);
        LineTo(X - 5, Y + 1);

        // top part
        X := R.Left + ((R.Right - R.Left) div 2) - 1;
        Y := R.Top;

        Pen.Color := clBlack;
        MoveTo(X, Y);
        LineTo(X, Y + 5);

        Pen.Color := clWhite;
        MoveTo(X + 1, Y);
        LineTo(X + 1, Y + 5);

        // bottom part
        X := R.Left + ((R.Right - R.Left) div 2) - 1;
        Y := R.Bottom;

        Pen.Color := clBlack;
        MoveTo(X, Y);
        LineTo(X, Y - 5);

        Pen.Color := clWhite;
        MoveTo(X + 1, Y);
        LineTo(X + 1, Y - 5);
      end;

      R := PointRect;
      Canvas.FillRect(R);

      scFrame3D(Canvas, R, clBlack, clBlack, 1, 0);
      scFrame3D(Canvas, R, clWhite, clWhite, 1, 0);
    end;
  end;
end;

procedure TSCCustomCornerGradient.SetColorValues(ALeftTop, ALeftBottom,
  ARightTop, ARightBottom: TColor; AColorCount: Integer);
begin
  if AColorCount < 10 then AColorCount := 10
  else
  if AColorCount > 255 then AColorCount := 255;

  if (FCLeftTop <> ALeftTop) or (FCLeftBottom <> ALeftBottom) or
    (FCRightTop <> ARightTop) or (FCRightBottom <> ARightBottom) or
    (FColorCount <> AColorCount) then
  begin
    FCLeftTop := ALeftTop;
    FCLeftBottom := ALeftBottom;
    FCRightTop := ARightTop;
    FCRightBottom := ARightBottom;
    FColorCount := AColorCount;

    DoUpdateChange;
  end;
end;

procedure TSCCustomCornerGradient.SetLeftBottom(Value: TColor);
begin
  SetColorValues(FCLeftTop, Value, FCRightTop, FCRightBottom, FColorCount);
end;

procedure TSCCustomCornerGradient.SetLeftTop(Value: TColor);
begin
  SetColorValues(Value, FCLeftBottom, FCRightTop, FCRightBottom, FColorCount);
end;

procedure TSCCustomCornerGradient.SetRightBottom(Value: TColor);
begin
  SetColorValues(FCLeftTop, FCLeftBottom, FCRightTop, Value, FColorCount);
end;

procedure TSCCustomCornerGradient.SetRightTop(Value: TColor);
begin
  SetColorValues(FCLeftTop, FCLeftBottom, Value, FCRightBottom, FColorCount);
end;

procedure TSCCustomCornerGradient.UpdateGradientBmp(WithSize: Boolean);
var
  R: TRect;
begin
  if FNeedUpdate and not FLockUpdate and
    HandleAllocated and (FGradientBmp <> nil) then
  begin
    FNeedUpdate := False;
    FNeedSizeUpdate := False;

    R := ClientRect;
    OffsetRect(R, -R.Left, -R.Top);

    if WithSize then
      FGradientBmp.SetBounds(R.Right, R.Bottom);

    with FGradientBmp.Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := FCLeftTop;
      FillRect(R);
    end;

    scFillFourGradient(FGradientBmp.Canvas, R, FCLeftTop, FCRightTop,
      FCLeftBottom, FCRightBottom, FColorCount);
  end;
end;

{ TSCGradientColors }

procedure TSCGradientColors.Assign(Source: TPersistent);
begin
  if FOwner = nil then Exit;

  if Source is TSCGradientColors then
  begin
    with FOwner, TSCGradientColors(Source) do
    begin
      FCLeftTop     := LeftTop;
      FCLeftBottom  := LeftBottom;
      FCRightTop    := RightTop;
      FCRightBottom := RightBottom;
      FColorCount   := ColorCount;

      DoUpdateChange(True);
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCGradientColors.Create(AOwner: TSCColorGradient);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCGradientColors.GetColorCount: Integer;
begin
  Result := 125;
  if FOwner <> nil then Result := FOwner.FColorCount;
end;

function TSCGradientColors.GetLeftBottom: TColor;
begin
  Result := clGray;
  if FOwner <> nil then Result := FOwner.FCLeftBottom;
end;

function TSCGradientColors.GetLeftTop: TColor;
begin
  Result := clBlack;
  if FOwner <> nil then Result := FOwner.FCLeftTop;
end;

function TSCGradientColors.GetRightBottom: TColor;
begin
  Result := clWhite;
  if FOwner <> nil then Result := FOwner.FCRightBottom;
end;

function TSCGradientColors.GetRightTop: TColor;
begin
  Result := clRed;
  if FOwner <> nil then Result := FOwner.FCRightTop;
end;

procedure TSCGradientColors.SetColorCount(Value: Integer);
begin
  if FOwner <> nil then FOwner.SetColorCount(Value);
end;

procedure TSCGradientColors.SetLeftBottom(Value: TColor);
begin
  if FOwner <> nil then FOwner.SetLeftBottom(Value);
end;

procedure TSCGradientColors.SetLeftTop(Value: TColor);
begin
  if FOwner <> nil then FOwner.SetLeftTop(Value);
end;

procedure TSCGradientColors.SetRightBottom(Value: TColor);
begin
  if FOwner <> nil then FOwner.SetRightBottom(Value);
end;

procedure TSCGradientColors.SetRightTop(Value: TColor);
begin
  if FOwner <> nil then FOwner.SetRightTop(Value);
end;

{ TSCColorGradient }

procedure TSCColorGradient.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCColorGradient then
    with TSCColorGradient(Source) do
      Self.Colors := Colors;
end;

constructor TSCColorGradient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColors := TSCGradientColors.Create(Self);
end;

destructor TSCColorGradient.Destroy;
begin
  FColors.Free;
  inherited Destroy;
end;

procedure TSCColorGradient.SetColors(Value: TSCGradientColors);
begin
  FColors.Assign(Value);
end;

{ TSCCustomHSVGradient }

procedure TSCCustomHSVGradient.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomHSVGradient then
    with TSCCustomHSVGradient(Source) do
      Self.Reverse := Reverse;
end;

procedure TSCCustomHSVGradient.BoundsChanged;
var
  C: LongInt;
  H, S, V: Integer;
begin
  if not (IsLoading or IsReading) then
  begin
    C := ColorToRGB(FSelectedColor);
    scRGBToHSV(GetRValue(C), GetGValue(C), GetBValue(C), H, S, V);

    CalcSelectedPoint(S, V);
  end;  
end;

procedure TSCCustomHSVGradient.CalcSelectedPoint(S, V: Word);
var
  R: TRect;
begin
  if CanGetClientRect then
  begin
    if S > 255 then S := 255;
    if V > 255 then V := 255;

    R := ClientRect;
    OffsetRect(R, -R.Left, -R.Top);

    if FReverse then
    begin
      FSelectedPoint.x := Muldiv(S, R.Right, 255);
      FSelectedPoint.y := R.Bottom - Muldiv(V, R.Bottom, 255);
    end else
    begin
      FSelectedPoint.x := Muldiv(V, R.Right, 255);
      FSelectedPoint.y := R.Bottom - Muldiv(S, R.Bottom, 255);
    end;
  end;
end;

constructor TSCCustomHSVGradient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorCount    := 80;
  FCLeftTop      := clBlack;
  FCLeftBottom   := clBlack;
  FCRightTop     := clRed;
  FCRightBottom  := clWhite;
  FSelectedColor := clBlack;
  FSelectedPoint := Point(0 ,0);
  FColorPointer  := scptSquare;
  FReverse       := False;
end;

procedure TSCCustomHSVGradient.Loaded;
var
  C: LongInt;
  H, S, V: Integer;
begin
  inherited Loaded;

  C := ColorToRGB(FSelectedColor);
  scRGBToHSV(GetRValue(C), GetGValue(C), GetBValue(C), H, S, V);

  CalcSelectedPoint(S, V);
end;

procedure TSCCustomHSVGradient.SetReverse(Value: Boolean);
var
  C: LongInt;
  H, S, V: Integer;
begin
  if FReverse <> Value then
  begin
    FReverse := Value;

    if FReverse then
    begin
      FCLeftTop      := clWhite;
      FCRightBottom  := clBlack;
    end else
    begin
      FCLeftTop      := clBlack;
      FCRightBottom  := clWhite;
    end;

    C := ColorToRGB(FSelectedColor);

    scRGBToHSV(GetRValue(C), GetGValue(C), GetBValue(C), H, S, V);
    FCRightTop  := ColorToRGB(scHSVtoColor(H, 255, 255));
    CalcSelectedPoint(S, V);

    FNeedUpdate := True;
    Invalidate;
  end;
end;

procedure TSCCustomHSVGradient.SetSelectedColor(Value: TColor);
var
  C1, C2, C3: LongInt;
  H, S, V: Integer;
begin
  C1 := ColorToRGB(FSelectedColor);
  C2 := ColorToRGB(Value);
  C3 := ColorToRGB(FCRightTop);

  if C1 <> C2 then
  begin
    scRGBToHSV(GetRValue(C2), GetGValue(C2), GetBValue(C2), H, S, V);

    FCRightTop  := ColorToRGB(scHSVtoColor(H, 255, 255));
    FNeedUpdate := FNeedUpdate or (C3 <> FCRightTop);

    CalcSelectedPoint(S, V);
    inherited SetSelectedColor(Value);
  end;
end;

procedure TSCCustomHSVGradient.SetSelectedPoint(X, Y: Integer);
var
  R: TRect;
  C: LongInt;
  H, S, V: Integer;
begin
  if not CanGetClientRect then Exit;

  R := ClientRect;
  OffsetRect(R, -R.Left, -R.Top);

  if X < 0 then X := 0
  else if X > R.Right then X := R.Right;

  if Y < 0 then Y := 0
  else if Y > R.Bottom then Y := R.Bottom;

  if (FSelectedPoint.x <> X) or (FSelectedPoint.y <> Y) then
  begin
    FSelectedPoint.x := X;
    FSelectedPoint.y := Y;

    C := ColorToRGB(FCRightTop);
    scRGBToHSV(GetRValue(C), GetGValue(C), GetBValue(C), H, S, V);

    if FReverse then
    begin
      S := Muldiv(X, 255, R.Right);
      V := 255 - Muldiv(Y, 255, R.Bottom);
    end else
    begin
      V := Muldiv(X, 255, R.Right);
      S := 255 - Muldiv(Y, 255, R.Bottom);
    end;

    FSelectedColor := ColorToRGB(scHSVtoColor(H, S, V));
    DoUpdateChange(False);
  end;
end;

{ TSCRGBRoller }

procedure TSCRGBRoller.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCRGBRoller then
    with TSCRGBRoller(Source) do
      Self.ShowBlackWhite := ShowBlackWhite;
end;

constructor TSCRGBRoller.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(Left, Top, 200, 20);
  Cursor := crSCCPalettePicker;
  FSelectedColor := clWhite;
  FShowBlackWhite := True;
end;

procedure TSCRGBRoller.SetSelectedPoint(X, Y: Integer);
var
  R: TRect;
  W, H: Integer;
  C: LongInt;
begin
  if X < 0 then X := 0;
  if Y < 0 then Y := 0;

  W := Width;
  H := Height;
  if CanGetClientRect then
  begin
    R := ClientRect;
    OffsetRect(R, -R.Left, -R.Top);

    W := R.Right;
    H := R.Bottom;
  end;

  if X > W then X := W;
  if Y > H then Y := H;

  if (FSelectedPoint.x <> X) or (FSelectedPoint.y <> Y) then
  begin
    FSelectedPoint.x := X;
    FSelectedPoint.y := Y;

    C := ColorToRGB(clWhite);
    if (FGradientBmp <> nil) and
      (FGradientBmp.Width >= X) and (FGradientBmp.Height >= Y) then
      C := ColorToRGB(FGradientBmp.Canvas.Pixels[X, Y]);

    SetSelectedColor(C);  
  end;
end;

procedure TSCRGBRoller.SetShowBlackWhite(Value: Boolean);
begin
  if FShowBlackWhite <> Value then
  begin
    FShowBlackWhite := Value;
    DoUpdateChange(True);
  end;
end;

procedure TSCRGBRoller.UpdateGradientBmp(WithSize: Boolean);
var
  R, R2: TRect;
begin
  if FNeedUpdate and not FLockUpdate and
    HandleAllocated and (FGradientBmp <> nil) then
  begin
    FNeedUpdate := False;
    FNeedSizeUpdate := False;

    R := ClientRect;
    OffsetRect(R, -R.Left, -R.Top);

    if WithSize then
      FGradientBmp.SetBounds(R.Right, R.Bottom);

    with FGradientBmp.Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := clWhite;
      FillRect(R);
    end;

    if FShowBlackWhite then
      Dec(R.Right, 8);

    if not IsRectEmpty(R) then
    begin
      R2 := R;
      R2.Bottom := R2.Top + ((R2.Bottom - R2.Top) div 2) + 1;
      scFillHorizontalExRainbow(FGradientBmp.Canvas, R2, clWhite, True, False);

      R2.Top := R2.Bottom - 1;
      R2.Bottom := R.Bottom;
      scFillHorizontalExRainbow(FGradientBmp.Canvas, R2, clBlack, False, False);
    end;

    if FShowBlackWhite then
    begin
      R.Left := R.Right;
      Inc(R.Right, 8);

      with FGradientBmp.Canvas do
      begin
        R2 := R;
        R2.Bottom := R2.Top + ((R2.Bottom - R2.Top) div 2);

        Brush.Style := bsSolid;
        Brush.Color := clWhite;
        FillRect(R2);

        R2.Top := R2.Bottom;
        R2.Bottom := R.Bottom;

        Brush.Color := clBlack;
        FillRect(R2);
      end;
    end;
  end;
end;

{ TSCCustomColorSlider }

constructor TSCCustomColorSlider.Create(AOwner: TComponent);
begin
  FSelectedColor := clBlack;

  inherited Create(AOwner);
  SetBounds(Left, Top, 255, 30);
  DoubleBuffered := True;

  FMin := 0;
  FMax := 255;
  FPosition := 0;
  FProgressBorder := sccb3DLowered;
  FOrientation := scsoHorizontal;
  FThumbStyle := sctsMac;
  FThumbType := scsttDown;

  FNeedUpdate := True;
  FColorBmp := TSCBitmap.Create;
end;

procedure TSCCustomColorSlider.CreateWnd;
begin
  inherited CreateWnd;
  FNeedSizeUpdate := True;
  DoUpdateChange(True, False);
end;

destructor TSCCustomColorSlider.Destroy;
begin
  FColorBmp.Free;
  inherited Destroy;
end;

procedure TSCCustomColorSlider.DoUpdateChange(NeedUpdate, TriggerEvent: Boolean);
begin
  FNeedUpdate := FNeedUpdate or NeedUpdate;
  Invalidate;

  if TriggerEvent then
    Change;
end;

procedure TSCCustomColorSlider.DrawProgress;
var
  R: TRect;
begin
  if HandleAllocated and (Canvas <> nil) and (FColorBmp <> nil) then
  begin
    UpdateColorBmp(FNeedSizeUpdate);

    R := GetProgressRect;
    Canvas.Draw(R.Left, R.Top, FColorBmp);

    if FProgressBorder in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
      InflateRect(R, 1, 1)
    else if FProgressBorder in [sccbFlatBold, sccb3DRaised, sccb3DLowered,
      sccbBumped, sccbEtched, sccbMacLowered, sccbMacRaised, sccbMetal,
      sccbSoftLowered, sccbSoftRaised] then
      InflateRect(R, 2, 2);

    scDrawEdge(Canvas, R, FlatColor, clNone, False, FProgressBorder);
  end;
end;

procedure TSCCustomColorSlider.DrawThumb;
var
  R, BkR, CR: TRect;
  P: TPoint;
  W, H: Integer;
begin
  if HandleAllocated and (Canvas <> nil) and (FColorBmp <> nil) then
  begin
    if FThumbType in [scsttDown, scsttBoth] then
    begin
      R := GetThumbDownRect;
      if IsRectEmpty(R) then Exit;

      BkR := R;
      CR := ClientRect;

      if FOrientation = scsoHorizontal then
      begin
        W := R.Right - R.Left;
        H := R.Bottom - R.Top - 2;

        P.x := R.Left + (W div 2);
        P.y := R.Top + 1;

        BkR.Left  := CR.Left;
        BkR.Right := CR.Right;
      end else
      begin
        W := R.Bottom - R.Top;
        H := R.Right - R.Left - 2;

        P.x := R.Left + 1;
        P.y := R.Top + (W div 2);

        BkR.Top := CR.Top;
        BkR.Bottom := CR.Bottom;
      end;

      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Self.Color;

        FillRect(BkR);
      end;

      if (H <= 0) or (W <= 0) then Exit;

      DrawDownSlider(P, W, H);
    end;

    if FThumbType in [scsttUp, scsttBoth] then
    begin
      R := GetThumbUpRect;
      if IsRectEmpty(R) then Exit;

      BkR := R;
      CR := ClientRect;

      if FOrientation = scsoHorizontal then
      begin
        W := R.Right - R.Left;
        H := R.Bottom - R.Top - 2;

        P.x := R.Left + (W div 2);
        P.y := R.Bottom - 2;

        BkR.Left  := CR.Left;
        BkR.Right := CR.Right;
      end else
      begin
        W := R.Bottom - R.Top;
        H := R.Right - R.Left - 2;

        P.x := R.Right - 2;
        P.y := R.Top + (W div 2);

        BkR.Top := CR.Top;
        BkR.Bottom := CR.Bottom;
      end;

      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Self.Color;

        FillRect(BkR);
      end;

      if (H <= 0) or (W <= 0) then Exit;

      DrawUpSlider(P, W, H);
    end;
  end;
end;

function TSCCustomColorSlider.GetProgressRect: TRect;
var
  TH, TW: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if not CanGetClientRect then Exit;

  Result := ClientRect;

  TH := GetThumbHeight;
  if TH < 0 then TH := 0;

  TW := GetThumbWidth;

  if TW < 0 then TW := 0;
  if Odd(TW) then Inc(TW);

  TW := TW div 2;

  if FOrientation = scsoHorizontal then
  begin
    InflateRect(Result, -Indent - TW, -FTopIndent);

    case FThumbType of
      scsttDown:
        Dec(Result.Bottom, TH);
      scsttUp:
        Inc(Result.Top, TH);
      scsttBoth:
        InflateRect(Result, 0, -TH);
    end;
  end else
  begin
    InflateRect(Result, -FTopIndent, -Indent - TW);

    case FThumbType of
      scsttDown:
        Dec(Result.Right, TH);
      scsttUp:
        Inc(Result.Left, TH);
      scsttBoth:
        InflateRect(Result, -TH, 0);
    end;
  end;

  if FProgressBorder in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
    InflateRect(Result, -1, -1)
  else if FProgressBorder in [sccbFlatBold, sccb3DRaised, sccb3DLowered,
    sccbBumped, sccbEtched, sccbMacLowered, sccbMacRaised, sccbMetal,
    sccbSoftLowered, sccbSoftRaised] then
    InflateRect(Result, -2, -2);

  if Result.Right < Result.Left then
    Result.Right := Result.Left;
    
  if Result.Bottom < Result.Top then
    Result.Bottom := Result.Top;
end;

function TSCCustomColorSlider.GetSelectedColor: TColor;
begin
  Result := FSelectedColor;
end;

function TSCCustomColorSlider.GetThumbHeight: Integer;
begin
  Result := 12;
  case FThumbStyle of
    sctsArrow:
      Result := 10;
    sctsExArrow:
      Result := 11;
    sctsMac, sctsPS:
      Result := 7;
    sctsNew:
      Result := 18;
  end;
end;

function TSCCustomColorSlider.GetThumbDownRect: TRect;
var
  TH, TW, P, W, APos: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if not CanGetClientRect then Exit;

  Result := GetProgressRect;

  TH := GetThumbHeight;
  if TH < 0 then TH := 0;

  TW := GetThumbWidth;

  if TW < 0 then TW := 0;
  if Odd(TW) then Inc(TW);

  TW := TW div 2;

  W := FMax - FMin;
  if W < 0 then W := 0;

  APos := FPosition;
  if APos < FMin then APos := FMin
  else if APos > FMax then APos := FMax;

  Dec(APos, FMin);

  if FOrientation = scsoHorizontal then
  begin
    if FProgressBorder in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
      InflateRect(Result, 0, 1)
    else if FProgressBorder in [sccbFlatBold, sccb3DRaised, sccb3DLowered,
      sccbBumped, sccbEtched, sccbMacLowered, sccbMacRaised, sccbMetal,
      sccbSoftLowered, sccbSoftRaised] then
      InflateRect(Result, 0, 2);

    Result.Top := Result.Bottom;
    Result.Bottom := Result.Top + TH;

    P := Result.Left;
    if W > 0 then P := Result.Left + Muldiv(APos, (Result.Right - Result.Left), W);

    Result.Left  := P;
    Result.Right := P;

    InflateRect(Result, TW, 0);
  end else
  begin
    if FProgressBorder in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
      InflateRect(Result, 1, 0)
    else if FProgressBorder in [sccbFlatBold, sccb3DRaised, sccb3DLowered,
      sccbBumped, sccbEtched, sccbMacLowered, sccbMacRaised, sccbMetal,
      sccbSoftLowered, sccbSoftRaised] then
      InflateRect(Result, 2, 0);

    Result.Left := Result.Right;
    Result.Right := Result.Left + TH;

    P := Result.Top;
    if W > 0 then P := Result.Bottom - Muldiv(APos, (Result.Bottom - Result.Top), W);

    Result.Top    := P;
    Result.Bottom := P;

    InflateRect(Result, 0, TW);
  end;

  if Result.Right < Result.Left then
    Result.Right := Result.Left;
    
  if Result.Bottom < Result.Top then
    Result.Bottom := Result.Top;
end;

function TSCCustomColorSlider.GetThumbUpRect: TRect;
var
  TH, TW, P, W, APos: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if not CanGetClientRect then Exit;

  Result := GetProgressRect;

  TH := GetThumbHeight;
  if TH < 0 then TH := 0;

  TW := GetThumbWidth;

  if TW < 0 then TW := 0;
  if Odd(TW) then Inc(TW);

  TW := TW div 2;

  W := FMax - FMin;
  if W < 0 then W := 0;

  APos := FPosition;
  if APos < FMin then APos := FMin
  else if APos > FMax then APos := FMax;

  Dec(APos, FMin);

  if FOrientation = scsoHorizontal then
  begin
    if FProgressBorder in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
      InflateRect(Result, 0, 1)
    else if FProgressBorder in [sccbFlatBold, sccb3DRaised, sccb3DLowered,
      sccbBumped, sccbEtched, sccbMacLowered, sccbMacRaised, sccbMetal,
      sccbSoftLowered, sccbSoftRaised] then
      InflateRect(Result, 0, 2);

    Result.Bottom := Result.Top;
    Result.Top := Result.Bottom - TH;

    P := Result.Left;
    if W > 0 then P := Result.Left + Muldiv(APos, (Result.Right - Result.Left), W);

    Result.Left  := P;
    Result.Right := P;

    InflateRect(Result, TW, 0);
  end else
  begin
    if FProgressBorder in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
      InflateRect(Result, 1, 0)
    else if FProgressBorder in [sccbFlatBold, sccb3DRaised, sccb3DLowered,
      sccbBumped, sccbEtched, sccbMacLowered, sccbMacRaised, sccbMetal,
      sccbSoftLowered, sccbSoftRaised] then
      InflateRect(Result, 2, 0);

    Result.Right := Result.Left;
    Result.Left := Result.Right - TH;

    P := Result.Top;
    if W > 0 then P := Result.Bottom - Muldiv(APos, (Result.Bottom - Result.Top), W);

    Result.Top    := P;
    Result.Bottom := P;

    InflateRect(Result, 0, TW);
  end;

  if Result.Right < Result.Left then
    Result.Right := Result.Left;
    
  if Result.Bottom < Result.Top then
    Result.Bottom := Result.Top;
end;

function TSCCustomColorSlider.GetThumbWidth: Integer;
begin
  Result := 10;
  if FThumbStyle = sctsNew then Result := 12;
end;

procedure TSCCustomColorSlider.IndentChanged;
begin
  FNeedSizeUpdate := True;
  DoUpdateChange(True, False);
  inherited IndentChanged;
end;

procedure TSCCustomColorSlider.Loaded;
begin
  inherited Loaded;
  FNeedUpdate := True;
  Invalidate;
end;

procedure TSCCustomColorSlider.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseIsDown := False;
  if ClickFocus and CanFocus and not Focused then
    Exit;

  MouseIsDown := Button = mbLeft;
  if MouseIsDown then SetCursorPos(X, Y);

  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TSCCustomColorSlider.MouseMove(Shift: TShiftState; X,
  Y: Integer);
begin
  if MouseIsDown then SetCursorPos(X, Y);

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomColorSlider.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if MouseIsDown then SetCursorPos(X, Y);
  MouseIsDown := False;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomColorSlider.Paint;
var
  CR, PR, R: TRect;
begin
  if not HandleAllocated then Exit;

  CR := ClientRect;
  if FClearBack or FNeedSizeUpdate or (FColorBmp = nil) then
  begin
    FClearBack := False;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Self.Color;
      FillRect(CR);
    end;
  end else
  begin
    PR := GetProgressRect;
    R  := CR;

    case Orientation of
      scsoHorizontal:
      begin
        case ThumbType of
          scsttDown:
            R.Bottom := PR.Top + FColorBmp.Height;
          scsttUp:
            R.Top := PR.Bottom - FColorBmp.Height;
          scsttBoth:
          begin
            R.Top := CR.Top + ((CR.Bottom - CR.Top - FColorBmp.Height) div 2);
            R.Bottom := R.Top + FColorBmp.Height;
          end;
        end;
      end;
      scsoVertical:
      begin
        case ThumbType of
          scsttDown:
            R.Right := PR.Left + FColorBmp.Width;
          scsttUp:
            R.Left := PR.Right - FColorBmp.Height;
          scsttBoth:
          begin
            R.Left := CR.Left + ((CR.Right - CR.Left - FColorBmp.Width) div 2);
            R.Right := R.Left + FColorBmp.Width;
          end;
        end;
      end;
    end;

    if FProgressBorder in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
      InflateRect(R, 1, 1)
    else if FProgressBorder in [sccbFlatBold, sccbFlatRounded, sccbFlatBoldRounded,
      sccb3DRaised, sccb3DLowered, sccbBumped, sccbEtched, sccbMacLowered,
      sccbMacRaised, sccbMetal, sccbSoftLowered, sccbSoftRaised] then
      InflateRect(R, 2, 2);

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Self.Color;

      FillRect(R);
    end;
  end;

  if FColorBmp <> nil then
    DrawProgress;

  DrawThumb;
end;

procedure TSCCustomColorSlider.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
var
  H, W: Integer;
begin
  H := Height; W := Width;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if (Height <> H) or (Width <> W) then
  begin
    FNeedUpdate := True;
    FNeedSizeUpdate := True;
    Invalidate;
  end;
end;

procedure TSCCustomColorSlider.SetCursorPos(X, Y: Integer);
var
  R: TRect;
  APos, Range, W: Integer;
begin
  if not CanGetClientRect then Exit;

  Range := FMax - FMin;
  if Range <= 0 then Exit;

  R := GetProgressRect;
  if IsRectEmpty(R) then Exit;

  if X < R.Left then X := R.Left
  else if X > R.Right then X := R.Right;

  if Y < R.Top then Y := R.Top
  else if Y > R.Bottom then Y := R.Bottom;

  if FOrientation = scsoHorizontal then
  begin
    W := R.Right - R.Left;
    if W <= 0 then Exit;

    Dec(X, R.Left);
    APos := FMin + Muldiv(X, Range, W);
  end else
  begin
    W := R.Bottom - R.Top;
    if W <= 0 then Exit;

    Dec(Y, R.Top);
    APos := FMax - Muldiv(Y, Range, W);
  end;

  SetPosition(APos);
end;

procedure TSCCustomColorSlider.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0
  else if Value > 20 then Value := 20;

  inherited SetIndent(Value);
end;

procedure TSCCustomColorSlider.SetMax(Value: Integer);
begin
  if Value > FMin then Value := FMin;

  if FMax <> Value then
  begin
    FMax := Value;
    if FPosition > FMax then FPosition := FMax;

    FClearBack := True;
    DoUpdateChange(True, True);
  end;
end;

procedure TSCCustomColorSlider.SetMin(Value: Integer);
begin
  if Value > FMax then Value := FMax;

  if FMin <> Value then
  begin
    FMin := Value;
    if FPosition < FMin then FPosition := FMin;

    FClearBack := True;
    DoUpdateChange(True, True);
  end;
end;

procedure TSCCustomColorSlider.SetOrientation(Value: TSCColorSliderOrientation);
var
  Tmp: Integer;
  R: TRect;
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;

    FNeedUpdate := True;
    FClearBack := True;

    if HandleAllocated and CanGetClientRect then
    begin
      R := BoundsRect;

      Dec(R.Right, R.Left);
      Dec(R.Bottom, R.Top);

      Tmp := R.Right;
      R.Right := R.Bottom;
      R.Bottom := Tmp;

      Inc(R.Right, R.Left);
      Inc(R.Bottom, R.Top);

      BoundsRect := R;
    end;
  end;
end;

procedure TSCCustomColorSlider.SetPosition(Value: Integer);
begin
  if Value > FMax then Value := FMax
  else if Value < FMin then Value := FMin;

  if FPosition <> Value then
  begin
    FPosition := Value;

    DrawThumb;
    DoUpdateChange(FNeedUpdate, True);
  end;
end;

procedure TSCCustomColorSlider.SetProgressBorder(Value: TSCControlBorder);
begin
  if FProgressBorder <> Value then
  begin
    FProgressBorder := Value;
    FClearBack := True;
    Invalidate;
  end;
end;

procedure TSCCustomColorSlider.SetSelectedColor(Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;
    DoUpdateChange(FNeedUpdate, True);
  end;
end;

procedure TSCCustomColorSlider.SetThumbStyle(Value: TSCThumbStyle);
begin
  if FThumbStyle <> Value then
  begin
    FThumbStyle := Value;

    FNeedSizeUpdate := True;
    DoUpdateChange(True, False);
  end;
end;

procedure TSCCustomColorSlider.SetTopIndent(Value: Integer);
begin
  if Value < 0 then Value := 0
  else if Value > 20 then Value := 20;

  if FTopIndent <> Value then
  begin
    FTopIndent := Value;
    TopIndentChanged;
  end;
end;

procedure TSCCustomColorSlider.TopIndentChanged;
begin
  FNeedSizeUpdate := True;
  DoUpdateChange(True, False);
end;

procedure TSCCustomColorSlider.UpdateColorBmp(UpdateSize: Boolean);
var
  R: TRect;
begin
  if FNeedUpdate and
    HandleAllocated and (FColorBmp <> nil) then
  begin
    FNeedUpdate := False;
    FNeedSizeUpdate := False;

    R := GetProgressRect;
    OffsetRect(R, -R.Left, -R.Top);

    if UpdateSize then
      FColorBmp.SetBounds(R.Right, R.Bottom);

    with FColorBmp.Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Self.Color;
      FillRect(R);
    end;
  end;
end;

procedure TSCCustomColorSlider.SetThumbType(Value: TSCSliderThumbType);
begin
  if FThumbType <> Value then
  begin
    FThumbType := Value;

    FNeedSizeUpdate := True;
    DoUpdateChange(True, False);
  end;
end;

procedure TSCCustomColorSlider.DrawDownSlider(P: TPoint; W, H: Integer);
begin
  if HandleAllocated and (H > 0) and
    (W > 0) and (Canvas <> nil) and (FColorBmp <> nil) then
  begin
    if FOrientation = scsoHorizontal then
      scDrawDownSlider(Canvas, P, W, H, FThumbStyle, False)
    else
      scDrawRightSlider(Canvas, P, W, H, FThumbStyle, False);
  end;
end;

procedure TSCCustomColorSlider.DrawUpSlider(P: TPoint; W, H: Integer);
begin
  if HandleAllocated and (H > 0) and
    (W > 0) and (Canvas <> nil) and (FColorBmp <> nil) then
  begin
    if FOrientation = scsoHorizontal then
      scDrawUpSlider(Canvas, P, W, H, FThumbStyle, False)
    else
      scDrawLeftSlider(Canvas, P, W, H, FThumbStyle, False);
  end;
end;

procedure TSCCustomColorSlider.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTALLKEYS or DLGC_WANTARROWS;
end;

procedure TSCCustomColorSlider.KeyDown(var Key: Word; Shift: TShiftState);
begin
  ProcessTrackKey(Key);
  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomColorSlider.KeyPress(var Key: Char);
begin
  if not (Ord(Key) in [VK_HOME, VK_END]) then
    ProcessTrackKey(Ord(Key));
  inherited KeyPress(Key);
end;

procedure TSCCustomColorSlider.ProcessTrackKey(Key: Word);
begin
  case Key of
    VK_LEFT, VK_DOWN:
      Position := Position - 1;
    VK_RIGHT, VK_UP:
      Position := Position + 1;
    VK_PRIOR:
      Position := Position - 10;
    VK_NEXT:
      Position := Position + 10;
    VK_HOME:
      Position := FMin;
    VK_END:
      Position := FMax;
  end;
end;

procedure TSCCustomColorSlider.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomColorSlider then
  begin
    with TSCCustomColorSlider(Source) do
    begin
      Self.Min := Min;
      Self.Max := Max;
      Self.Orientation := Orientation;
      Self.Position := Position;
      Self.ProgressBorder := ProgressBorder;
      Self.SelectedColor := SelectedColor;
      Self.ThumbStyle := ThumbStyle;
      Self.ThumbType := ThumbType;
      Self.TopIndent := TopIndent;
    end;
  end;
end;

procedure TSCCustomColorSlider.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if Message.WheelDelta < 0 then
    SetPosition(Position + 1)
  else
  if Message.WheelDelta > 0 then
    SetPosition(Position - 1);
end;

{ TSCHueSlider }

procedure TSCHueSlider.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCHueSlider then
    with TSCHueSlider(Source) do
      Self.HSVGradient := HSVGradient;
end;

constructor TSCHueSlider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMax := 360;
  FSelectedColor := clRed;
end;

destructor TSCHueSlider.Destroy;
begin
  {$IFDEF SC_DELPHI5_UP}
  if FHSVGradient <> nil then
    FHSVGradient.RemoveFreeNotification(Self);
  {$ENDIF}
  inherited Destroy;
end;

procedure TSCHueSlider.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FHSVGradient) then
    FHSVGradient := nil;
end;

procedure TSCHueSlider.SetHSVGradient(Value: TSCCustomHSVGradient);
begin
  if FHSVGradient <> Value then
  begin
    FHSVGradient := Value;

    if FHSVGradient <> nil then
    begin
      FHSVGradient.FreeNotification(Self);
      FHSVGradient.SetSelectedColor(FSelectedColor);
    end;
  end;
end;

procedure TSCHueSlider.SetPosition(Value: Integer);
var
  APos: Integer;
  R, G, B: Byte;
begin
  APos := FPosition;

  if Value < FMin then Value := FMin
  else if Value > FMax then Value := FMax;

  if APos <> Value then
  begin
    scHSVtoRGB(Value, 255, 255, R, G, B);
    FSelectedColor := RGB(R, G, B);

    inherited SetPosition(Value);

    if FHSVGradient <> nil then
      FHSVGradient.SetSelectedColor(FSelectedColor);
  end;
end;

procedure TSCHueSlider.SetSelectedColor(Value: TColor);
var
  C1, C2: LongInt;
  H, S, V: Integer;
  R, G, B: Byte;
begin
  C1 := ColorToRGB(FSelectedColor);
  C2 := ColorToRGB(Value);

  if C1 <> C2 then
  begin
    scRGBToHSV(GetRValue(C2), GetGValue(C2), GetBValue(C2), H, S, V);
    FPosition := H;

    scHSVtoRGB(H, 255, 255, R, G, B);
    C2 := RGB(R, G, B);

    inherited SetSelectedColor(C2);

    if FHSVGradient <> nil then
      FHSVGradient.SetSelectedColor(Value);
  end;
end;

procedure TSCHueSlider.UpdateColorBmp(UpdateSize: Boolean);
var
  R: TRect;
begin
  if FNeedUpdate and HandleAllocated and (FColorBmp <> nil) then
  begin
    inherited UpdateColorBmp(UpdateSize);

    R := Rect(0, 0, FColorBmp.Width, FColorBmp.Height);
    if IsRectEmpty(R) then Exit;

    if FOrientation = scsoHorizontal then
      scFillHorizontalRainbow(FColorBmp.Canvas, R, False)
    else scFillVerticalRainbow(FColorBmp.Canvas, R, True);
  end;
end;

{ TSCRGBSlider }

procedure TSCRGBSlider.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCRGBSlider then
  begin
    with TSCRGBSlider(Source) do
    begin
      Self.Colorful := Colorful;
      Self.RGBType := RGBType;
    end;
  end;
end;

constructor TSCRGBSlider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorful := False;
  FMax := 255;
  FRGBType := scrgbRed;
  FSelectedColor := clBlack;
end;

function TSCRGBSlider.GetSelectedColor: TColor;
var
  C: LongInt;
  R, G, B: Byte;
begin
  C := ColorToRGB(FSelectedColor);
  Result := C;

  R := GetRValue(C);
  G := GetGValue(C);
  B := GetBValue(C);

  case FRGBType of
    scrgbRed:
      Result := RGB(FPosition, G, B);
    scrgbGreen:
      Result := RGB(R, FPosition, B);
    scrgbBlue:
      Result := RGB(R, G, FPosition);
  end;
end;

procedure TSCRGBSlider.SetColorful(Value: Boolean);
begin
  if FColorful <> Value then
  begin
    FColorful := Value;
    DoUpdateChange(True, False);
  end;
end;

procedure TSCRGBSlider.SetRGBType(Value: TSCRGBSliderType);
var
  APos: Integer;
begin
  if FRGBType <> Value then
  begin
    FRGBType := Value;

    APos := FPosition;
    if APos < FMin then APos := FMin
    else if APos > FMax then APos := FMax;

    case FRGBType of
      scrgbRed:
        FSelectedColor := RGB(APos, 0, 0);
      scrgbGreen:
        FSelectedColor := RGB(0, APos, 0);
      scrgbBlue:
        FSelectedColor := RGB(0, 0, APos);
    end;

    DoUpdateChange(True, True);
  end;
end;

procedure TSCRGBSlider.SetSelectedColor(Value: TColor);
var
  C1, C2: LongInt;
begin
  C1 := ColorToRGB(FSelectedColor);
  C2 := ColorToRGB(Value);

  if C1 <> C2 then
  begin
    case FRGBType of
      scrgbRed:
        FPosition := GetRValue(C2);
      scrgbGreen:
        FPosition := GetGValue(C2);
      scrgbBlue:
        FPosition := GetBValue(C2);
    end;

    FNeedUpdate := FNeedUpdate or FColorful;
    inherited SetSelectedColor(C2);
  end;
end;

procedure TSCRGBSlider.UpdateColorBmp(UpdateSize: Boolean);
var
  GR: TRect;
  C: LongInt;
  StartColor, EndColor: TColor;
  R, G, B: Byte;
begin
  if FNeedUpdate and
    HandleAllocated and (FColorBmp <> nil) then
  begin
    inherited UpdateColorBmp(UpdateSize);

    GR := Rect(0, 0, FColorBmp.Width, FColorBmp.Height);
    if IsRectEmpty(GR) then Exit;

    if FColorful then
    begin
      C := ColorToRGB(FSelectedColor);

      R := GetRValue(C);
      G := GetGValue(C);
      B := GetBValue(C);

      StartColor := RGB(0, G, B);
      EndColor   := RGB(255, G, B);

      case FRGBType of
        scrgbRed:
        begin
          StartColor := RGB(0, G, B);
          EndColor   := RGB(255, G, B);
        end;
        scrgbGreen:
        begin
          StartColor := RGB(R, 0, B);
          EndColor   := RGB(R, 255, B);
        end;
        scrgbBlue:
        begin
          StartColor := RGB(R, G, 0);
          EndColor   := RGB(R, G, 255);
        end;
      end;
    end else
    begin
      StartColor := clBlack;
      EndColor := RGB(255, 0, 0);

      case FRGBType of
        scrgbRed:
          EndColor := RGB(255, 0, 0);
        scrgbGreen:
          EndColor := RGB(0, 255, 0);
        scrgbBlue:
          EndColor := RGB(0, 0, 255);
      end;
    end;

    if FOrientation = scsoHorizontal then
      scFillGradientRectHorizontal(FColorBmp.Canvas, GR, StartColor, EndColor, 255, False)
    else
      scFillGradientRectVertical(FColorBmp.Canvas, GR, StartColor, EndColor, 255, True);
  end;
end;

{ TSCLumSlider }

constructor TSCLumSlider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMax := 240;
  FPosition := 0;
  FSelectedColor := clRed;
end;

procedure TSCLumSlider.UpdateColorBmp(UpdateSize: Boolean);
var
  R1, R2: TRect;
begin
  if FNeedUpdate and
    HandleAllocated and (FColorBmp <> nil) then
  begin
    inherited UpdateColorBmp(UpdateSize);

    R1 := Rect(0, 0, FColorBmp.Width, FColorBmp.Height);
    if IsRectEmpty(R1) then Exit;

    R2 := R1;
    if FOrientation = scsoHorizontal then
    begin
      R1.Right := R1.Right div 2;
      R2.Left := R1.Right;

      scFillGradientRectHorizontal(FColorBmp.Canvas, R1, clBlack, FSelectedColor, 240, False);
      scFillGradientRectHorizontal(FColorBmp.Canvas, R2, FSelectedColor, clWhite, 240, False);
    end else
    begin
      R1.Bottom := R1.Bottom div 2;
      R2.Top := R1.Bottom;

      scFillGradientRectVertical(FColorBmp.Canvas, R1, clWhite, FSelectedColor, 240, False);
      scFillGradientRectVertical(FColorBmp.Canvas, R2, FSelectedColor, clBlack, 240, False);
    end;
  end;
end;

{ TSCCustomColorSelector }

procedure TSCCustomColorSelector.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomColorSelector then
  begin
    with TSCCustomColorSelector(Source) do
    begin
      Self.NoneColor := NoneColor;
      Self.NoneDiagonal := NoneDiagonal;
      Self.NoneStyle := NoneStyle;
      Self.SelectedColor := SelectedColor;
      Self.ShowCaption := ShowCaption;
      Self.ShowFocus := ShowFocus;
      Self.Style := Style;
    end;
  end;
end;

constructor TSCCustomColorSelector.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered := True;

  SetBounds(Left, Top, 85, 23);
  ParentColor := False;
  Color := clWindow;

  FColorCaption := 'Black';
  FNoneColor := clNone;
  FNoneDiagonal := clRed;
  FNoneStyle := scncNone;
  FSelectedColor := clBlack;
  FShowCaption := False;
  FShowFocus := False;
  FStyle := scssCombo;
end;

procedure TSCCustomColorSelector.DoGetCaption;
var
  C: LongInt;
  R, G, B: Byte;
begin
  if not FShowCaption then
  begin
    FColorCaption := '';
    Exit;
  end;

  if ColorToIdent(FSelectedColor, FColorCaption) then
    Delete(FColorCaption, 1, 2)
  else begin
    C := ColorToRGB(FSelectedColor);

    R := GetRValue(C);
    G := GetGValue(C);
    B := GetBValue(C);

    FColorCaption := '#' + IntToHex(R, 2) + IntToHex(G, 2) + IntToHex(B, 2);
  end;

  if Assigned(FOnGetCaption) then FOnGetCaption(Self, FColorCaption);
end;

procedure TSCCustomColorSelector.DrawButton;
var
  C: TColor;
  CR, R, R2: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clBtnFace;

    FillRect(CR);
  end;

  R := CR;
  InflateRect(R, -5, -4);

  if FShowCaption and (FColorCaption <> '') then
  begin
    R2 := R;
    R.Right := R.Left + 32;
    IntersectRect(R, R, R2);
  end;

  if not IsRectEmpty(R) then
  begin
    if FMouseIsDown and MouseInControl then
      OffsetRect(R, 1, 1);

    C := FSelectedColor;
    if (C = clNone) and (FNoneStyle <> scncNone) then
      C := FNoneColor;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := C;

      FillRect(R);
    end;

    R2 := R;
    InflateRect(R2, -2, -2);
    DrawDiagonal(R2);

    scFrame3D(Canvas, R, cl3DDkShadow, cl3DDkShadow, 1, 0);
    scFrame3D(Canvas, R, clBtnHighlight, clBtnHighlight, 1, 0);
  end;

  if FShowCaption and (FColorCaption <> '') then
  begin
    R2 := CR;
    InflateRect(R2, -3, -3);
    R2.Left := R.Right + 6;

    if not IsRectEmpty(R2) then
      with Canvas do
      begin
        Brush.Color := clBtnFace;
        Brush.Style := bsClear;

        Font := Self.Font;
        DrawText(Handle, PChar(FColorCaption), Length(FColorCaption), R2,
          DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or DT_END_ELLIPSIS);
      end;
  end;

  R := CR;
  InflateRect(R, -2, -2);
  if FShowFocus and Focused and not IsRectEmpty(R) then
    scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);

  R := CR;
  if FMouseIsDown and MouseInControl then
  begin
    scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
    scFrame3D(Canvas, R, cl3DDkShadow, clBtnFace, 1, 0);
  end else
  begin
    scFrame3D(Canvas, R, clBtnHighlight, cl3DDkShadow, 1, 0);
    scFrame3D(Canvas, R, clBtnFace, clBtnShadow, 1, 0);
  end;
end;

procedure TSCCustomColorSelector.DrawCombo;
var
  C: TColor;
  P: TPoint;
  CR, R, R2: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;

    FillRect(CR);
  end;

  R := CR;
  InflateRect(R, -5, -5);

  Dec(R.Right, 16);
  if FShowCaption and (FColorCaption <> '') then
  begin
    R2 := R;
    R.Right := R.Left + 32;
    IntersectRect(R, R, R2);
  end;

  if not IsRectEmpty(R) then
  begin
    C := FSelectedColor;
    if (C = clNone) and (FNoneStyle <> scncNone) then
      C := FNoneColor;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := C;

      FillRect(R);
    end;

    R2 := R;
    InflateRect(R2, -2, -2);
    DrawDiagonal(R2);

    scFrame3D(Canvas, R, clWindowFrame, clWindowFrame, 1, 0);
    scFrame3D(Canvas, R, clWindow, clWindow, 1, 0);
  end;

  if FShowCaption and (FColorCaption <> '') then
  begin
    R2 := CR;
    InflateRect(R2, -3, -3);

    R2.Left := R.Right + 6;
    Dec(R2.Right, 18);

    if not IsRectEmpty(R2) then
      with Canvas do
      begin
        Brush.Color := clBtnFace;
        Brush.Style := bsClear;

        Font := Self.Font;
        DrawText(Handle, PChar(FColorCaption), Length(FColorCaption), R2,
          DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or DT_END_ELLIPSIS);
      end;
  end;

  R := CR;
  InflateRect(R, -2, -2);
  R.Left := R.Right - 16;

  if not IsRectEmpty(R) then
  begin
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := clBtnFace;

      FillRect(R);
    end;

    P.x := R.Left + ((R.Right - R.Left) div 2);
    P.y := R.Top + ((R.Bottom - R.Top) div 2) + 2;

    if FMouseIsDown and MouseInControl then
    begin
      Inc(P.x);
      Inc(P.y);
    end;

    scDrawUpSlider(Canvas, P, 6, 3, sctsMac, False);

    if FMouseIsDown and MouseInControl then
      scFrame3D(Canvas, R, cl3DDkShadow, cl3DDkShadow, 1, 0)
    else begin
      scFrame3D(Canvas, R, clBtnHighlight, cl3DDkShadow, 1, 0);
      scFrame3D(Canvas, R, clBtnFace, clBtnShadow, 1, 0);
    end;
  end;

  R := CR;
  InflateRect(R, -3, -3);
  Dec(R.Right, 16);
  if FShowFocus and Focused and not IsRectEmpty(R) then
    scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);

  R := CR;
  scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
  scFrame3D(Canvas, R, cl3DDkShadow, clBtnFace, 1, 0);
end;

procedure TSCCustomColorSelector.DrawDiagonal(InR: TRect);
var
  SR, I, Step, P: Integer;
begin
  if not IsRectEmpty(InR) and (FSelectedColor = clNone) and
    (FNoneStyle in [scncDiagonal, scncDiagonalCross]) then
    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Width := 1;
      Pen.Color := FNoneDiagonal;
      
      if FNoneDiagonal = clNone then
      begin
        if IsColorLight(clNone) then
          Pen.Color := clBlack
        else
          Pen.Color := clWhite;
      end;

      SR := IntersectClipRect(Canvas.Handle, InR.Left, InR.Top,
        InR.Right, InR.Bottom);
      try
        if SR <> NULLREGION then
        begin
          Step := (InR.Right - InR.Left) div 4;

          for I := 0 to Step do
          begin
            P := InR.Left - (InR.Right - InR.Left) + I*8;

            MoveTo(P, InR.Top);
            LineTo((InR.Bottom - InR.Top) + P, InR.Bottom);
          end;

          if FNoneStyle = scncDiagonalCross then
            for I := 0 to Step do
            begin
              P := InR.Left + I*8 - 5;

              MoveTo(P, InR.Top);
              LineTo(P - (InR.Bottom - InR.Top), InR.Bottom);
            end;
        end;
      finally
        SelectClipRgn(Canvas.Handle, 0);
      end;
    end;
end;

procedure TSCCustomColorSelector.DrawFlatCombo;
var
  C: TColor;
  P: TPoint;
  CR, R, R2: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;

    FillRect(CR);
  end;

  R := CR;
  InflateRect(R, -5, -5);

  Dec(R.Right, 14);
  if FShowCaption and (FColorCaption <> '') then
  begin
    R2 := R;
    R.Right := R.Left + 32;
    IntersectRect(R, R, R2);
  end;

  if not IsRectEmpty(R) then
  begin
    C := FSelectedColor;
    if (C = clNone) and (FNoneStyle <> scncNone) then
      C := FNoneColor;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := C;

      FillRect(R);
    end;

    R2 := R;
    InflateRect(R2, -2, -2);
    DrawDiagonal(R2);

    scFrame3D(Canvas, R, clWindowFrame, clWindowFrame, 1, 0);
    scFrame3D(Canvas, R, clWindow, clWindow, 1, 0);
  end;

  if FShowCaption and (FColorCaption <> '') then
  begin
    R2 := CR;
    InflateRect(R2, -3, -3);

    R2.Left := R.Right + 6;
    Dec(R2.Right, 16);

    if not IsRectEmpty(R2) then
      with Canvas do
      begin
        Brush.Color := clBtnFace;
        Brush.Style := bsClear;

        Font := Self.Font;
        DrawText(Handle, PChar(FColorCaption), Length(FColorCaption), R2,
          DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or DT_END_ELLIPSIS);
      end;
  end;

  R := CR;
  InflateRect(R, -1, -1);
  R.Left := R.Right - 14;

  if not IsRectEmpty(R) then
  begin
    with Canvas do
    begin
      Brush.Style := bsSolid;
      if FMouseIsDown and MouseInControl then
        Brush.Color := clWindow
      else
        Brush.Color := clBtnFace;

      FillRect(R);
    end;

    P.x := R.Left + ((R.Right - R.Left) div 2);
    P.y := R.Top + ((R.Bottom - R.Top) div 2) + 2;

    if FMouseIsDown and MouseInControl then
    begin
      Inc(P.x);
      Inc(P.y);
    end;

    scDrawUpSlider(Canvas, P, 4, 2, sctsMac, False);

    scFrame3D(Canvas, R, clWindowFrame, clWindowFrame, 1, 0);
    if FMouseIsDown then
    begin
      if MouseInControl then
        scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0)
      else
        scFrame3D(Canvas, R, clBtnHighlight, clBtnShadow, 1, 0);
    end else
    if MouseInControl then
      scFrame3D(Canvas, R, clBtnHighlight, clBtnShadow, 1, 0)
    else
      scFrame3D(Canvas, R, clBtnFace, clBtnFace, 1, 0);
  end;

  R := CR;
  InflateRect(R, -3, -3);
  Dec(R.Right, 16);
  if FShowFocus and Focused and not IsRectEmpty(R) then
    scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);

  R := CR;
  scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
  scFrame3D(Canvas, R, clWindowFrame, clWindowFrame, 1, 0);
end;

procedure TSCCustomColorSelector.DrawMac;
var
  C: TColor;
  P: TPoint;
  CR, R, R2: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clBtnFace;

    FillRect(CR);
  end;

  R := CR;
  InflateRect(R, -2, -2);

  if not IsRectEmpty(R) then
  begin
    C := FSelectedColor;
    if (C = clNone) and (FNoneStyle <> scncNone) then
      C := FNoneColor;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := C;

      FillRect(R);
    end;

    R2 := R;
    InflateRect(R2, -1, -1);
    DrawDiagonal(R2);

    scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
  end;

  if FShowCaption and (FColorCaption <> '') then
  begin
    R2 := CR;
    InflateRect(R2, -3, -3);
    Inc(R2.Left, 32);

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := clBtnFace;

      FillRect(R2);
    end;

    Inc(R2.Left, 4);
    Dec(R2.Right, 10);

    if not IsRectEmpty(R2) then
      with Canvas do
      begin
        Brush.Color := clBtnFace;
        Brush.Style := bsClear;

        Font := Self.Font;
        DrawText(Handle, PChar(FColorCaption), Length(FColorCaption), R2,
          DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or DT_END_ELLIPSIS);
      end;
  end;

  R := CR;
  R.Left := R.Right - 10;
  R.Top := R.Bottom - 8;

  P.x := R.Left + ((R.Right - R.Left) div 2);
  P.y := R.Bottom - 4;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clBtnFace;

    FillRect(R);
  end;

  scDrawUpSlider(Canvas, P, 4, 2, sctsMac, False);
  with Canvas do
  begin
    Pen.Style := psSolid;
    Pen.Color := clBtnHighlight;

    MoveTo(R.Left, R.Top);
    LineTo(R.Right - 2, R.Top);

    MoveTo(R.Left, R.Top);
    LineTo(R.Left, R.Bottom - 3);
  end;

  R := CR;
  if FMouseIsDown and MouseInControl then
    scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0)
  else
    scFrame3D(Canvas, R, clBtnHighlight, clBtnShadow, 1, 0);

  R := CR;
  InflateRect(R, -1, -1);
  if FShowFocus and Focused and not IsRectEmpty(R) then
    scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0)
end;

procedure TSCCustomColorSelector.DrawOfficeXPCombo;
var
  P: TPoint;
  CR, R, R2: TRect;
  C, ArrowColor,
  BtnColor, FrameColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clWindow;

    FillRect(CR);
  end;

  R := CR;
  InflateRect(R, -2, -2);

  Dec(R.Right, 13);
  if FShowCaption and (FColorCaption <> '') then
  begin
    R2 := R;
    R.Right := R.Left + 32;
    IntersectRect(R, R, R2);
  end;

  if not IsRectEmpty(R) then
  begin
    C := FSelectedColor;
    if (C = clNone) and (FNoneStyle <> scncNone) then
      C := FNoneColor;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := C;

      FillRect(R);
    end;

    R2 := R;
    InflateRect(R2, -1, -1);
    DrawDiagonal(R2);

    scFrame3D(Canvas, R, clBtnShadow, clBtnShadow, 1, 0);
  end;

  if FShowCaption and (FColorCaption <> '') then
  begin
    R2 := CR;
    InflateRect(R2, -3, -3);

    R2.Left := R.Right + 6;
    Dec(R2.Right, 15);

    if not IsRectEmpty(R2) then
      with Canvas do
      begin
        Brush.Color := clBtnFace;
        Brush.Style := bsClear;

        Font := Self.Font;
        DrawText(Handle, PChar(FColorCaption), Length(FColorCaption), R2,
          DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or DT_END_ELLIPSIS);
      end;
  end;

  if FMouseIsDown or MouseInControl then
    FrameColor := clHighlight
  else FrameColor := clWindow;

  R := CR;
  InflateRect(R, -1, -1);
  R.Left := R.Right - 12;

  if not IsRectEmpty(R) then
  begin
    with Canvas do
    begin
      Brush.Style := bsSolid;

      ArrowColor := clWindowText;
      if FMouseIsDown then
      begin
        if MouseInControl then
        begin
          BtnColor  := GetOfficeXPDownedSelColor;
          ArrowColor := clHighlightText;
        end else
          BtnColor  := GetOfficeXPSelColor;
      end else
      if MouseInControl then
        BtnColor  := GetOfficeXPSelColor
      else
        BtnColor  := GetOfficeXPBtnColor;

      Brush.Color := BtnColor;
      FillRect(R);
    end;

    P.x := R.Left + ((R.Right - R.Left) div 2);
    P.y := R.Top + ((R.Bottom - R.Top) div 2) + 2;

    scDrawUpSlider(Canvas, P, 4, 2, sctsMac, False, ArrowColor);

    if FMouseIsDown or MouseInControl then
    begin
      InflateRect(R, 1, 2);
      scFrame3D(Canvas, R, FrameColor, FrameColor, 1, 0);
    end else
      scFrame3D(Canvas, R, FrameColor, FrameColor, 1, 0);
  end;

  R := CR;
  if FMouseIsDown then
    scFrame3D(Canvas, R, FrameColor, FrameColor, 1, 0)
  else
  if MouseInControl then
    scFrame3D(Canvas, R, FrameColor, FrameColor, 1, 0)
  else
    scFrame3D(Canvas, R, clBtnFace, clBtnFace, 1, 0);
end;

procedure TSCCustomColorSelector.DrawPopupButton;
var
  C: TColor;
  P: TPoint;
  CR, R, R2: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clBtnFace;

    FillRect(CR);
  end;

  R := CR;
  InflateRect(R, -5, -4);

  Dec(R.Right, 14);
  if FShowCaption and (FColorCaption <> '') then
  begin
    R2 := R;
    R.Right := R.Left + 32;
    IntersectRect(R, R, R2);
  end;

  if not IsRectEmpty(R) then
  begin
    if FMouseIsDown and MouseInControl then
      OffsetRect(R, 1, 1);

    C := FSelectedColor;
    if (C = clNone) and (FNoneStyle <> scncNone) then
      C := FNoneColor;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := C;

      FillRect(R);
    end;

    R2 := R;
    InflateRect(R2, -2, -2);
    DrawDiagonal(R2);

    scFrame3D(Canvas, R, clWindowFrame, clWindowFrame, 1, 0);
    scFrame3D(Canvas, R, clWindow, clWindow, 1, 0);
  end;

  if FShowCaption and (FColorCaption <> '') then
  begin
    R2 := CR;
    InflateRect(R2, -3, -3);

    R2.Left := R.Right + 6;
    Dec(R2.Right, 16);

    if not IsRectEmpty(R2) then
      with Canvas do
      begin
        Brush.Color := clBtnFace;
        Brush.Style := bsClear;

        Font := Self.Font;
        DrawText(Handle, PChar(FColorCaption), Length(FColorCaption), R2,
          DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or DT_END_ELLIPSIS);
      end;
  end;

  R := CR;
  InflateRect(R, -2, -2);
  R.Left := R.Right - 22;

  if not IsRectEmpty(R) then
  begin
    P.x := R.Left + ((R.Right - R.Left) div 2) + 4;
    P.y := R.Top + ((R.Bottom - R.Top) div 2) + 2;

    if FMouseIsDown and MouseInControl then
    begin
      Inc(P.x);
      Inc(P.y);
    end;

    scDrawUpSlider(Canvas, P, 6, 3, sctsMac, False);
  end;

  R := CR;
  if FMouseIsDown and MouseInControl then
  begin
    scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
    scFrame3D(Canvas, R, cl3DDkShadow, clBtnFace, 1, 0);
  end else
  begin
    scFrame3D(Canvas, R, clBtnHighlight, cl3DDkShadow, 1, 0);
    scFrame3D(Canvas, R, clBtnFace, clBtnShadow, 1, 0);
  end;

  R := CR;
  InflateRect(R, -2, -2);
  if FShowFocus and Focused and not IsRectEmpty(R) then
    scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0)
end;

procedure TSCCustomColorSelector.Loaded;
begin
  inherited Loaded;
  Invalidate;
end;

procedure TSCCustomColorSelector.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseIsDown := False;
  if ClickFocus and CanFocus and not Focused then
    Exit;

  FMouseIsDown := Button = mbLeft;
  if FMouseIsDown then Invalidate;

  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TSCCustomColorSelector.MouseInControlChanged;
begin
  if FMouseIsDown or
    (FStyle in [scssFlatCombo, scssOfficeXPCombo]) then
    Invalidate;
end;

procedure TSCCustomColorSelector.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FMouseIsDown then Invalidate;
  FMouseIsDown := False;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomColorSelector.Paint;
begin
  if not HandleAllocated then Exit;

  case FStyle of
    scssButton:
      DrawButton;
    scssCombo:
      DrawCombo;
    scssFlatCombo:
      DrawFlatCombo;
    scssMac:
      DrawMac;
    scssOfficeXPCombo:
      DrawOfficeXPCombo;
    scssPopupButton:
      DrawPopupButton;
  end;
end;

procedure TSCCustomColorSelector.SetNoneColor(Value: TColor);
begin
  if FNoneColor <> Value then
  begin
    FNoneColor := Value;
    if FSelectedColor = clNone then
      Invalidate;
  end;
end;

procedure TSCCustomColorSelector.SetNoneDiagonal(Value: TColor);
begin
  if FNoneDiagonal <> Value then
  begin
    FNoneDiagonal := Value;
    if FSelectedColor = clNone then
      Invalidate;
  end;
end;

procedure TSCCustomColorSelector.SetNoneStyle(Value: TSCNoneColorStyle);
begin
  if FNoneStyle <> Value then
  begin
    FNoneStyle := Value;
    if FSelectedColor = clNone then
      Invalidate;
  end;
end;

procedure TSCCustomColorSelector.SetSelectedColor(Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;
    DoGetCaption;

    Invalidate;
    Change;
  end;
end;

procedure TSCCustomColorSelector.SetShowCaption(Value: Boolean);
begin
  if FShowCaption <> Value then
  begin
    FShowCaption := Value;
    DoGetCaption;
    Invalidate;
  end;
end;

procedure TSCCustomColorSelector.SetShowFocus(Value: Boolean);
begin
  if FShowFocus <> Value then
  begin
    FShowFocus := Value;
    Invalidate;
  end;
end;

procedure TSCCustomColorSelector.SetStyle(Value: TSCCSelectorStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TSCCustomColorSelector.StopTracking;
begin
  FMouseIsDown := False;
  inherited StopTracking;
end;

{ TSC3DSunkenBorderProps }

constructor TSC3DSunkenBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccb3DLowered;
end;

initialization
  try
    Screen.Cursors[crSCCPalettePicker] := LoadCursor(hInstance, PChar('SC_COLORPICKER_CURSOR'));
  except
  end;

end.

