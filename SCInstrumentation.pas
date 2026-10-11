{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCInstrumentation;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCommon, SCConsts, SCControl;

type
  TSCMeterStyle = (scmsClassic, scmsGradient, scmsMetal, scmsRaised, scmsXP);

  TSCCustomMeter = class;

  TSCMeterSegment = class(TCollectionItem)
  private
    FActiveColor: TColor;
    FColor: TColor;
    FCount: Integer;
    procedure SetActiveColor(Value: TColor);
    procedure SetColor(Value: TColor);
    procedure SetCount(Value: Integer);
  protected
    function  GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property ActiveColor: TColor read FActiveColor write SetActiveColor default clLime;
    property Color: TColor read FColor write SetColor default clGreen;
    property Count: Integer read FCount write SetCount default 2;
  end;

  TSCMeterSegments = class(TCollection)
  private
    FOwner: TSCCustomMeter;
    function  GetItem(Index: Integer): TSCMeterSegment;
    procedure SetItem(Index: Integer; Value: TSCMeterSegment);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TSCCustomMeter);
    function Add: TSCMeterSegment;
    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomMeter read FOwner;
    {$ENDIF}
    property Items[Index: Integer]: TSCMeterSegment read GetItem write SetItem; default;
  end;

  TSCMeterBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccbLowered;
    property Color;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCCustomMeter = class(TSCCustomControl)
  private
    FMin: Integer;
    FMax: Integer;
    FOrientation: TSCOrientation;
    FPosition: Integer;
    FSegments: TSCMeterSegments;
    FStyle: TSCMeterStyle;
    FSegmentPos: Integer;
    FSegmentCount: Integer;
    FSegmentSize: Integer;
    FShowInactive: Boolean;
    FSegmentBuffer: TList;
    FSingleActive: Boolean;
    procedure SetOrientation(Value: TSCOrientation);
    procedure SetMin(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure SetPosition(Value: Integer);
    procedure SetSegments(Value: TSCMeterSegments);
    procedure SetShowInactive(Value: Boolean);
    procedure SetSingleActive(Value: Boolean);
    procedure SetStyle(Value: TSCMeterStyle);

    procedure ClearSegmentBuffer;
    procedure PrepareSegmentBuffer(UpdateAll: Boolean);
    function  GetSegmentBitmap(C: TColor): TBitmap;

    procedure SegmentChanged(Item: TCollectionItem);

    function  UpdateSegmentValues(Full: Boolean = True): Boolean;
    procedure CalculateSegments(Full: Boolean = True);

    procedure DrawSegment(Canvas: TCanvas; R: TRect; C: TColor);
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Paint; override;
    procedure Resize; override;

    procedure SetIndent(Value: Integer); override;

    procedure SpacingChanged; override;
    procedure IndentChanged; override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetBlendValue: Word; override;

    property Color default clBlack;
    property ParentColor default False;
    property Indent default 2;
    property Orientation: TSCOrientation read FOrientation write SetOrientation default scoHorizontal;
    property Min: Integer read FMin write SetMin default 0;
    property Max: Integer read FMax write SetMax default 100;
    property Position: Integer read FPosition write SetPosition default 0;
    property Segments: TSCMeterSegments read FSegments write SetSegments;
    property ShowInactive: Boolean read FShowInactive write SetShowInactive default True;
    property SingleActive: Boolean read FSingleActive write SetSingleActive default False;
    property Spacing default 2;
    property Style: TSCMeterStyle read FStyle write SetStyle default scmsClassic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCMeter = class(TSCCustomMeter)
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
    property Indent;
    property Max;
    property Min;
    property Orientation;
    property ParentColor;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Position;
    property Segments;
    property ShowHint;
    property ShowInactive;
    property SingleActive;
    property Spacing;
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
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCMatrixBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccbLowered;
    property Color;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCMatrixScrollType = (scstLeftToRight, scstRightToLeft);

  TSCCustomMarixDisplay = class(TSCCustomControl)
  private
    FColorOn: TColor;
    FColorOff: TColor;
    FCellSize: Integer;
    FTopIndent: Integer;
    FOffsetX: Integer;
    FScrollTimer: Integer;
    FScrollDelay: Integer;
    FScrollEnabled: Boolean;
    FScrollType: TSCMatrixScrollType;
    FScrolling: Boolean;
    FPauseScroll: Integer;
    procedure SetColorOn(Value: TColor);
    procedure SetColorOff(Value: TColor);
    procedure SetScrollDelay(Value: Integer);
    procedure SetScrollEnabled(Value: Boolean);
    procedure SetScrollType(Value: TSCMatrixScrollType);

    procedure UpdateCellSize;

    procedure StopScrolling;
    procedure StartScrolling(Offset: Integer);

    procedure DrawCells;
    procedure PaintRow(X, Y: Integer; S: String);

    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Paint; override;
    procedure Resize; override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetBlendValue: Word; override;

    property Color default clBlack;
    property ParentColor default False;
    property ColorOn: TColor read FColorOn write SetColorOn default clLime;
    property ColorOff: TColor read FColorOff write SetColorOff default $00004000;
    property ScrollDelay: Integer read FScrollDelay write SetScrollDelay default 50;
    property ScrollEnabled: Boolean read FScrollEnabled write SetScrollEnabled default False;
    property ScrollType: TSCMatrixScrollType read FScrollType write SetScrollType default scstRightToLeft;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCMarixDisplay = class(TSCCustomMarixDisplay)
  published
    property Align;
    property Anchors;
    property BorderProps;
    property Caption;
    property Color;
    property ColorOff;
    property ColorOn;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentColor;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ScrollDelay;
    property ScrollEnabled;
    property ScrollType;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Tag;
    property Transparent;
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
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCSegmentBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccbLowered;
    property Color;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCCustomSevenSegment = class(TSCCustomControl)
  private
    FAlignment: TLeftRight;
    FDigitCount: Integer;
    FColorOff: TColor;
    FColorOn: TColor;
    FSegmentSpacing: Integer;
    FSegmentThickness: Integer;
    FDigitHeight: Integer;
    FDigitWidth: Integer;
    FTopIndent: Integer;
    FC: array[0..5] of TPoint;
    FT, FLT, FLB, FB, FRT, FRB: array[0..3] of TPoint;
    procedure SetAlignment(Value: TLeftRight);
    procedure SetDigitCount(Value: Integer);
    procedure SetColorOff(Value: TColor);
    procedure SetColorOn(Value: TColor);
    procedure SetSegmentSpacing(Value: Integer);
    procedure SetSegmentThickness(Value: Integer);

    function  GetCharWidth(Ch: Char): Integer;

    procedure CalculatePolygons;
    procedure CalculateSize;

    procedure DrawSegment(Ch: Char; R: TRect);
    procedure DrawSegments;

    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Paint; override;
    procedure Resize; override;

    procedure SetIndent(Value: Integer); override;

    procedure SpacingChanged; override;
    procedure IndentChanged; override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetBlendValue: Word; override;

    property Color default clBlack;
    property ParentColor default False;
    property Indent default 2;
    property Spacing default 4;
    property Alignment: TLeftRight read FAlignment write SetAlignment default taRightJustify;
    property DigitCount: Integer read FDigitCount write SetDigitCount default 0;
    property ColorOff: TColor read FColorOff write SetColorOff default $001E401E;
    property ColorOn: TColor read FColorOn write SetColorOn default clLime;
    property SegmentSpacing: Integer read FSegmentSpacing write SetSegmentSpacing default 1;
    property SegmentThickness: Integer read FSegmentThickness write SetSegmentThickness default 3;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCSevenSegment = class(TSCCustomSevenSegment)
  published
    property Align;
    property Alignment;
    property Anchors;
    property BorderProps;
    property Caption;
    property Color;
    property ColorOff;
    property ColorOn;
    property Constraints;
    property Cursor;
    property DigitCount;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Indent;
    property ParentColor;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property SegmentSpacing;
    property SegmentThickness;
    property ShowHint;
    property Spacing;
    property TabOrder;
    property TabStop;
    property Tag;
    property Transparent;
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
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCHistGraphBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccb3DLowered;
    property Color;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCCustomHistoryGraph = class(TSCCustomControl)
  private
    FList: TList;
    FCacheSize: Integer;
    FGridColor: TColor;
    FGridStep: Integer;
    FLineColor: TColor;
    FMax: Integer;
    FMin: Integer;
    FScrollGrid: Boolean;
    FShowGrid: Boolean;
    FStepSize: Integer;
    procedure SetGridColor(Value: TColor);
    procedure SetGridStep(Value: Integer);
    procedure SetLineColor(Value: TColor);
    procedure SetMax(Value: Integer);
    procedure SetMin(Value: Integer);
    procedure SetShowGrid(Value: Boolean);
    procedure SetScrollGrid(Value: Boolean);
    procedure SetStepSize(Value: Integer);

    function  GetCount: Integer;
    function  GetItem(Index: Integer): Integer;

    function  TrimList: Boolean;
    procedure UpdateCacheSize;

    procedure DrawGrid;
    procedure DrawGraph;
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Paint; override;
    procedure Resize; override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetBlendValue: Word; override;

    property Color default clBlack;
    property ParentColor default False;
    property Count: Integer read GetCount;
    property GridColor: TColor read FGridColor write SetGridColor default $00004000;
    property GridStep: Integer read FGridStep write SetGridStep default 6;
    property Items[Index: Integer]: Integer read GetItem;
    property LineColor: TColor read FLineColor write SetLineColor default clLime;
    property Max: Integer read FMax write SetMax default 100;
    property Min: Integer read FMin write SetMin default 0;
    property ScrollGrid: Boolean read FScrollGrid write SetScrollGrid default True;
    property ShowGrid: Boolean read FShowGrid write SetShowGrid default True;
    property StepSize: Integer read FStepSize write SetStepSize default 2;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Clear;
    procedure Add(Value: Integer);
  end;

  TSCHistoryGraph = class(TSCCustomHistoryGraph)
  public
    property Count;
    property Items;
  published
    property Align;
    property Anchors;
    property BorderProps;
    property Caption;
    property Color;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property GridColor;
    property GridStep;
    property LineColor;
    property Max;
    property Min;
    property ParentColor;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ScrollGrid;
    property ShowGrid;
    property ShowHint;
    property StepSize;
    property TabOrder;
    property TabStop;
    property Tag;
    property Transparent;
    property Visible;
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
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCSwitchBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccb3DLowered;
    property Color;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCCustomSwitch = class(TSCCustomControl)
  private
    FButtonColor: TColor;
    FColorOn: TColor;
    FColorOff: TColor;
    FLightIndent: Integer;
    FMax: Integer;
    FMin: Integer;
    FOrientation: TSCOrientation;
    FShowLights: Boolean;
    FShowLines: Boolean;
    FValue: Integer;
    FLeftClicked: Boolean;
    FSliderClicked: Boolean;
    FSliderIsHot: Boolean;
    procedure SetButtonColor(Value: TColor);
    procedure SetColorOn(Value: TColor);
    procedure SetColorOff(Value: TColor);
    procedure SetLightIndent(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure SetMin(Value: Integer);
    procedure SetOrientation(Value: TSCOrientation);
    procedure SetShowLights(Value: Boolean);
    procedure SetShowLines(Value: Boolean);
    procedure SetValue(Value: Integer);

    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  protected
    procedure Paint; override;

    procedure SetIndent(Value: Integer); override;
    procedure StopTracking; override;

    function  NormalizeValue(Value: Integer): Integer;
    function  CanSetValue(var Value: Integer): Boolean; virtual;
    function  CanSetUserValue(var Value: LongInt): Boolean; virtual;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure ProcessTrackKey(Key: Word);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetBlendValue: Word; override;

    property Color default clBlack;
    property ParentColor default False;
    property Indent default 1;
    property ButtonColor: TColor read FButtonColor write SetButtonColor default clBtnFace;
    property ColorOn: TColor read FColorOn write SetColorOn default clLime;
    property ColorOff: TColor read FColorOff write SetColorOff default $00004000;
    property LightIndent: Integer read FLightIndent write SetLightIndent default 0;
    property Orientation: TSCOrientation read FOrientation write SetOrientation default scoVertical;
    property Min: Integer read FMin write SetMin default 0;
    property Max: Integer read FMax write SetMax default 1;
    property Value: Integer read FValue write SetValue default 0;
    property Spacing default 1;
    property ShowLines: Boolean read FShowLines write SetShowLines default True;
    property ShowLights: Boolean read FShowLights write SetShowLights default True;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    function  PtOnSlider(P: TPoint): Boolean;
    function  ValueAtPos(X, Y: Integer): Integer;
  end;

  TSCSwitch = class(TSCCustomSwitch)
  published
    property Align;
    property Anchors;
    property BorderProps;
    property ButtonColor;
    property Color;
    property ColorOn;
    property ColorOff;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Indent;
    property LightIndent;
    property Max;
    property Min;
    property Orientation;
    property ParentColor;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ShowHint;
    property ShowLights;
    property ShowLines;
    property Spacing;
    property TabOrder;
    property TabStop;
    property Tag;
    property Transparent;
    property Value;
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
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCRunningLedsStyle = (scrl3D, scrlClassic, scrlGradient3D, scrlMetal,
    scrlRaised, scrlSliced, scrlXP);

  TSCRunningLedsBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccbLowered;
    property Color;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCCustomRunningLeds = class(TSCCustomControl)
  private
    FForeColor: TColor;
    FInterval: Integer;
    FPercentage: Integer;
    FRunning: Boolean;
    FRunningTimer: Integer;
    FRunningEnabled: Boolean;
    FStyle: TSCRunningLedsStyle;
    FSlice: Integer;
    FStep: Integer;
    FOffsetX: Integer;
    procedure SetForeColor(Value: TColor);
    procedure SetInterval(Value: Integer);
    procedure SetPercentage(Value: Integer);
    procedure SetRunningEnabled(Value: Boolean);
    procedure SetStep(Value: Integer);
    procedure SetSlice(Value: Integer);
    procedure SetStyle(Value: TSCRunningLedsStyle);

    procedure StopRun;
    procedure StartRun(Offset: Integer);
    procedure ResetInterval;

    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Paint; override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetBlendValue: Word; override;

    property Color default clWindow;
    property ParentColor default False;
    property ForeColor: TColor read FForeColor write SetForeColor default clGreen;
    property Interval: Integer read FInterval write SetInterval default 100;
    property Percentage: Integer read FPercentage write SetPercentage default 30;
    property RunningEnabled: Boolean read FRunningEnabled write SetRunningEnabled default False;
    property Slice: Integer read FSlice write SetSlice default 10;
    property Step: Integer read FStep write SetStep default 8;
    property Style: TSCRunningLedsStyle read FStyle write SetStyle default scrlMetal;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCRunningLeds = class(TSCCustomRunningLeds)
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
    property ForeColor;
    property Interval;
    property ParentColor;
    property ParentShowHint;
    property Percentage;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property RunningEnabled;
    property ShowHint;
    property Slice;
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

type
  TSegmentRec = record
    Color: TColor;
    Bitmap: TBitmap;
  end;
  PSegmentRec = ^TSegmentRec;

  TSCMatrixRow = record
    Ch: Char;
    Row0: String;
    Row1: String;
    Row2: String;
    Row3: String;
    Row4: String;
    Row5: String;
    Row6: String;
    Row7: String;
    Row8: String;
    Row9: String;
  end;

  TSCSevenRec = record
    Ch: Char;
    Pattern: String;
  end;

const
  SC_MATRIX_TIMERID = 5544;
  SC_RUNNING_TIMERID = 5545;

  SCMatrixChars: array[0..95] of TSCMatrixRow = (
    (Ch: ' '; Row0: '00000'; Row1: '00000'; Row2: '00000'; Row3: '00000'; Row4: '00000'; Row5: '00000'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '!'; Row0: '00100'; Row1: '00100'; Row2: '00100'; Row3: '00100'; Row4: '00100'; Row5: '00000'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '"'; Row0: '01010'; Row1: '01010'; Row2: '00000'; Row3: '00000'; Row4: '00000'; Row5: '00000'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '#'; Row0: '00000'; Row1: '01010'; Row2: '11111'; Row3: '01010'; Row4: '11111'; Row5: '01010'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '$'; Row0: '00100'; Row1: '01111'; Row2: '10100'; Row3: '01110'; Row4: '00101'; Row5: '11110'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '%'; Row0: '00000'; Row1: '11001'; Row2: '11010'; Row3: '00100'; Row4: '01011'; Row5: '10011'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '&'; Row0: '01100'; Row1: '10010'; Row2: '10100'; Row3: '01000'; Row4: '10101'; Row5: '10010'; Row6: '01101'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: ''''; Row0: '00100'; Row1: '00100'; Row2: '00000'; Row3: '00000'; Row4: '00000'; Row5: '00000'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '('; Row0: '00100'; Row1: '01000'; Row2: '01000'; Row3: '01000'; Row4: '01000'; Row5: '01000'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: ')'; Row0: '00100'; Row1: '00010'; Row2: '00010'; Row3: '00010'; Row4: '00010'; Row5: '00010'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '*'; Row0: '00100'; Row1: '10101'; Row2: '01110'; Row3: '11111'; Row4: '01110'; Row5: '10101'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '+'; Row0: '00000'; Row1: '00100'; Row2: '00100'; Row3: '11111'; Row4: '00100'; Row5: '00100'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: ','; Row0: '00000'; Row1: '00000'; Row2: '00000'; Row3: '00000'; Row4: '00000'; Row5: '00100'; Row6: '01000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '-'; Row0: '00000'; Row1: '00000'; Row2: '00000'; Row3: '11111'; Row4: '00000'; Row5: '00000'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '.'; Row0: '00000'; Row1: '00000'; Row2: '00000'; Row3: '00000'; Row4: '00000'; Row5: '00000'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '/'; Row0: '00000'; Row1: '00001'; Row2: '00010'; Row3: '00100'; Row4: '01000'; Row5: '10000'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '0'; Row0: '01110'; Row1: '10001'; Row2: '10011'; Row3: '10101'; Row4: '11001'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '1'; Row0: '00100'; Row1: '01100'; Row2: '00100'; Row3: '00100'; Row4: '00100'; Row5: '00100'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '2'; Row0: '01110'; Row1: '10001'; Row2: '00001'; Row3: '00110'; Row4: '01000'; Row5: '10000'; Row6: '11111'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '3'; Row0: '01110'; Row1: '10001'; Row2: '00001'; Row3: '01110'; Row4: '00001'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '4'; Row0: '00010'; Row1: '00110'; Row2: '01010'; Row3: '10010'; Row4: '11111'; Row5: '00010'; Row6: '00010'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '5'; Row0: '11111'; Row1: '10000'; Row2: '11110'; Row3: '00001'; Row4: '00001'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '6'; Row0: '01110'; Row1: '10000'; Row2: '11110'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '7'; Row0: '11111'; Row1: '10001'; Row2: '00001'; Row3: '00010'; Row4: '00100'; Row5: '00100'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '8'; Row0: '01110'; Row1: '10001'; Row2: '10001'; Row3: '01110'; Row4: '10001'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '9'; Row0: '01110'; Row1: '10001'; Row2: '10001'; Row3: '01111'; Row4: '00001'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: ':'; Row0: '00000'; Row1: '00000'; Row2: '00100'; Row3: '00000'; Row4: '00000'; Row5: '00100'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: ';'; Row0: '00000'; Row1: '00000'; Row2: '00100'; Row3: '00000'; Row4: '00000'; Row5: '00100'; Row6: '01000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '<'; Row0: '00010'; Row1: '00100'; Row2: '01000'; Row3: '10000'; Row4: '01000'; Row5: '00100'; Row6: '00010'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '='; Row0: '00000'; Row1: '00000'; Row2: '11111'; Row3: '00000'; Row4: '11111'; Row5: '00000'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '>'; Row0: '01000'; Row1: '00100'; Row2: '00010'; Row3: '00001'; Row4: '00010'; Row5: '00100'; Row6: '01000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '?'; Row0: '01110'; Row1: '10001'; Row2: '00001'; Row3: '00110'; Row4: '00100'; Row5: '00000'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '@'; Row0: '01110'; Row1: '10001'; Row2: '10111'; Row3: '11011'; Row4: '10110'; Row5: '10000'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'A'; Row0: '01110'; Row1: '10001'; Row2: '10001'; Row3: '11111'; Row4: '10001'; Row5: '10001'; Row6: '10001'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'B'; Row0: '11110'; Row1: '10001'; Row2: '10001'; Row3: '11110'; Row4: '10001'; Row5: '10001'; Row6: '11110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'C'; Row0: '01110'; Row1: '10001'; Row2: '10000'; Row3: '10000'; Row4: '10000'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'D'; Row0: '11110'; Row1: '10001'; Row2: '10001'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '11110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'E'; Row0: '11111'; Row1: '10000'; Row2: '10000'; Row3: '11110'; Row4: '10000'; Row5: '10000'; Row6: '11111'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'F'; Row0: '11111'; Row1: '10000'; Row2: '10000'; Row3: '11110'; Row4: '10000'; Row5: '10000'; Row6: '10000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'G'; Row0: '01110'; Row1: '10001'; Row2: '10000'; Row3: '10111'; Row4: '10001'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'H'; Row0: '10001'; Row1: '10001'; Row2: '10001'; Row3: '11111'; Row4: '10001'; Row5: '10001'; Row6: '10001'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'I'; Row0: '01110'; Row1: '00100'; Row2: '00100'; Row3: '00100'; Row4: '00100'; Row5: '00100'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'J'; Row0: '00111'; Row1: '00010'; Row2: '00010'; Row3: '00010'; Row4: '00010'; Row5: '10010'; Row6: '01100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'K'; Row0: '10001'; Row1: '10010'; Row2: '10100'; Row3: '11000'; Row4: '10100'; Row5: '10010'; Row6: '10001'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'L'; Row0: '10000'; Row1: '10000'; Row2: '10000'; Row3: '10000'; Row4: '10000'; Row5: '10000'; Row6: '11111'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'M'; Row0: '10001'; Row1: '11011'; Row2: '10101'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '10001'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'N'; Row0: '10001'; Row1: '10001'; Row2: '11001'; Row3: '10101'; Row4: '10011'; Row5: '10001'; Row6: '10001'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'O'; Row0: '01110'; Row1: '10001'; Row2: '10001'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'P'; Row0: '11110'; Row1: '10001'; Row2: '10001'; Row3: '11110'; Row4: '10000'; Row5: '10000'; Row6: '10000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'Q'; Row0: '01110'; Row1: '10001'; Row2: '10001'; Row3: '10001'; Row4: '10001'; Row5: '10011'; Row6: '01111'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'R'; Row0: '11110'; Row1: '10001'; Row2: '10001'; Row3: '11110'; Row4: '10001'; Row5: '10001'; Row6: '10001'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'S'; Row0: '01110'; Row1: '10001'; Row2: '10000'; Row3: '01110'; Row4: '00001'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'T'; Row0: '11111'; Row1: '00100'; Row2: '00100'; Row3: '00100'; Row4: '00100'; Row5: '00100'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'U'; Row0: '10001'; Row1: '10001'; Row2: '10001'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'V'; Row0: '10001'; Row1: '10001'; Row2: '10001'; Row3: '01010'; Row4: '01010'; Row5: '00100'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'W'; Row0: '10001'; Row1: '10001'; Row2: '10001'; Row3: '10001'; Row4: '10101'; Row5: '10101'; Row6: '01010'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'X'; Row0: '10001'; Row1: '10001'; Row2: '01010'; Row3: '00100'; Row4: '01010'; Row5: '10001'; Row6: '10001'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'Y'; Row0: '10001'; Row1: '10001'; Row2: '01010'; Row3: '00100'; Row4: '00100'; Row5: '00100'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'Z'; Row0: '11111'; Row1: '00001'; Row2: '00010'; Row3: '00100'; Row4: '01000'; Row5: '10000'; Row6: '11111'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '['; Row0: '01110'; Row1: '01000'; Row2: '01000'; Row3: '01000'; Row4: '01000'; Row5: '01000'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '\'; Row0: '00000'; Row1: '10000'; Row2: '01000'; Row3: '00100'; Row4: '00010'; Row5: '00001'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: ']'; Row0: '01110'; Row1: '00010'; Row2: '00010'; Row3: '00010'; Row4: '00010'; Row5: '00010'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '^'; Row0: '00100'; Row1: '01010'; Row2: '10001'; Row3: '00000'; Row4: '00000'; Row5: '00000'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '_'; Row0: '00000'; Row1: '00000'; Row2: '00000'; Row3: '00000'; Row4: '00000'; Row5: '00000'; Row6: '11111'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '`'; Row0: '01000'; Row1: '01000'; Row2: '00100'; Row3: '00000'; Row4: '00000'; Row5: '00000'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'a'; Row0: '00000'; Row1: '00000'; Row2: '01110'; Row3: '00001'; Row4: '01111'; Row5: '10001'; Row6: '01111'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'b'; Row0: '10000'; Row1: '10000'; Row2: '11110'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '11110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'c'; Row0: '00000'; Row1: '00000'; Row2: '01110'; Row3: '10001'; Row4: '10000'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'd'; Row0: '00001'; Row1: '00001'; Row2: '01111'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '01111'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'e'; Row0: '00000'; Row1: '00000'; Row2: '01110'; Row3: '10001'; Row4: '11111'; Row5: '10000'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'f'; Row0: '00110'; Row1: '01001'; Row2: '01000'; Row3: '11110'; Row4: '01000'; Row5: '01000'; Row6: '01000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'g'; Row0: '00000'; Row1: '00000'; Row2: '01110'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '01111'; Row7: '00001'; Row8: '00001'; Row9: '01110'),
    (Ch: 'h'; Row0: '10000'; Row1: '10000'; Row2: '11110'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '10001'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'i'; Row0: '00100'; Row1: '00000'; Row2: '01100'; Row3: '00100'; Row4: '00100'; Row5: '00100'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'j'; Row0: '00100'; Row1: '00000'; Row2: '01110'; Row3: '00100'; Row4: '00100'; Row5: '00100'; Row6: '00100'; Row7: '00100'; Row8: '11000'; Row9: '00000'),
    (Ch: 'k'; Row0: '10000'; Row1: '10000'; Row2: '10001'; Row3: '10010'; Row4: '11100'; Row5: '10010'; Row6: '10001'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'l'; Row0: '01100'; Row1: '00100'; Row2: '00100'; Row3: '00100'; Row4: '00100'; Row5: '00100'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'm'; Row0: '00000'; Row1: '00000'; Row2: '11110'; Row3: '10101'; Row4: '10101'; Row5: '10101'; Row6: '10101'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'n'; Row0: '00000'; Row1: '00000'; Row2: '11110'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '10001'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'o'; Row0: '00000'; Row1: '00000'; Row2: '01110'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '01110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'p'; Row0: '00000'; Row1: '00000'; Row2: '11110'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '11110'; Row7: '10000'; Row8: '10000'; Row9: '10000'),
    (Ch: 'q'; Row0: '00000'; Row1: '00000'; Row2: '01111'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '01111'; Row7: '00001'; Row8: '00001'; Row9: '00001'),
    (Ch: 'r'; Row0: '00000'; Row1: '00000'; Row2: '11110'; Row3: '10001'; Row4: '10000'; Row5: '10000'; Row6: '10000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 's'; Row0: '00000'; Row1: '00000'; Row2: '01111'; Row3: '10000'; Row4: '01110'; Row5: '00001'; Row6: '11110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 't'; Row0: '01000'; Row1: '01000'; Row2: '11110'; Row3: '01000'; Row4: '01000'; Row5: '01000'; Row6: '00110'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'u'; Row0: '00000'; Row1: '00000'; Row2: '10001'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '01111'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'v'; Row0: '00000'; Row1: '00000'; Row2: '10001'; Row3: '10001'; Row4: '10001'; Row5: '01010'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'w'; Row0: '00000'; Row1: '00000'; Row2: '10001'; Row3: '10001'; Row4: '10101'; Row5: '10101'; Row6: '01010'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'x'; Row0: '00000'; Row1: '00000'; Row2: '10001'; Row3: '01010'; Row4: '00100'; Row5: '01010'; Row6: '10001'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: 'y'; Row0: '00000'; Row1: '00000'; Row2: '10001'; Row3: '10001'; Row4: '10001'; Row5: '10001'; Row6: '01111'; Row7: '00001'; Row8: '00001'; Row9: '01110'),
    (Ch: 'z'; Row0: '00000'; Row1: '00000'; Row2: '11111'; Row3: '00010'; Row4: '00100'; Row5: '01000'; Row6: '11111'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '{'; Row0: '00010'; Row1: '00100'; Row2: '00100'; Row3: '01000'; Row4: '00100'; Row5: '00100'; Row6: '00010'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '|'; Row0: '00100'; Row1: '00100'; Row2: '00100'; Row3: '00000'; Row4: '00100'; Row5: '00100'; Row6: '00100'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '}'; Row0: '01000'; Row1: '00100'; Row2: '00100'; Row3: '00010'; Row4: '00100'; Row5: '00100'; Row6: '01000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: '~'; Row0: '01000'; Row1: '10101'; Row2: '00010'; Row3: '00000'; Row4: '00000'; Row5: '00000'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000'),
    (Ch: ''; Row0: '00000'; Row1: '01110'; Row2: '01110'; Row3: '01110'; Row4: '01110'; Row5: '01110'; Row6: '00000'; Row7: '00000'; Row8: '00000'; Row9: '00000')
    );

  SCSevenSegChars: array[0..15] of TSCSevenRec = (
    (Ch: '0'; Pattern: '1110111'),
    (Ch: '1'; Pattern: '0000110'),
    (Ch: '2'; Pattern: '1011101'),
    (Ch: '3'; Pattern: '1001111'),
    (Ch: '4'; Pattern: '0101110'),
    (Ch: '5'; Pattern: '1101011'),
    (Ch: '6'; Pattern: '1111011'),
    (Ch: '7'; Pattern: '1000110'),
    (Ch: '8'; Pattern: '1111111'),
    (Ch: '9'; Pattern: '1101111'),
    (Ch: 'A'; Pattern: '1111110'),
    (Ch: 'B'; Pattern: '1111111'),
    (Ch: 'C'; Pattern: '1110001'),
    (Ch: 'D'; Pattern: '1110111'),
    (Ch: 'E'; Pattern: '1111001'),
    (Ch: 'F'; Pattern: '1111000')
    );

{ TSCMeterSegment }

procedure TSCMeterSegment.Assign(Source: TPersistent);
begin
  if Source is TSCMeterSegment then
  begin
    with TSCMeterSegment(Source) do
    begin
      Self.FActiveColor := ActiveColor;
      Self.FColor := Color;
      Self.FCount := Count;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCMeterSegment.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FActiveColor := clLime;
  FColor := clGreen;
  FCount := 2;
end;

function TSCMeterSegment.GetDisplayName: string;
begin
  Result := ColorToString(FActiveColor) + ', ' +
    ColorToString(FColor) + ', ' + IntToStr(FCount);
end;

procedure TSCMeterSegment.SetActiveColor(Value: TColor);
begin
  if FActiveColor <> Value then
  begin
    FActiveColor := Value;
    if Count > 0 then Changed(True);
  end;
end;

procedure TSCMeterSegment.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    if Count > 0 then Changed(True);
  end;
end;

procedure TSCMeterSegment.SetCount(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FCount <> Value then
  begin
    FCount := Value;
    Changed(True);
  end;
end;

{ TSCMeterSegments }

function TSCMeterSegments.Add: TSCMeterSegment;
begin
  Result := TSCMeterSegment(inherited Add);
end;

constructor TSCMeterSegments.Create(AOwner: TSCCustomMeter);
begin
  inherited Create(TSCMeterSegment);
  FOwner := AOwner;
end;

function TSCMeterSegments.GetItem(Index: Integer): TSCMeterSegment;
begin
  Result := TSCMeterSegment(inherited GetItem(Index));
end;

function TSCMeterSegments.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCMeterSegments.SetItem(Index: Integer; Value: TSCMeterSegment);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCMeterSegments.Update(Item: TCollectionItem);
begin
  if FOwner <> nil then FOwner.SegmentChanged(Item);
end;

{ TSCMeterBorderProps }

constructor TSCMeterBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccbLowered;
end;

{ TSCCustomMeter }

procedure TSCCustomMeter.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomMeter then
  begin
    with TSCCustomMeter(Source) do
    begin
      Self.Max := Max;
      Self.Min := Min;
      Self.Orientation := Orientation;
      Self.Position := Position;
      Self.Segments := Segments;
      Self.ShowInactive := ShowInactive;
      Self.SingleActive := SingleActive;
      Self.Spacing := Spacing;
      Self.Style := Style;
      Self.Indent := Indent;
    end;
  end;
end;

procedure TSCCustomMeter.CalculateSegments(Full: Boolean);
var
  I, S, Range, P: Integer;
begin
  Range := FMax - FMin;
  if Range < 0 then Range := 0;

  if Full or (Range = 0) then
  begin
    FSegmentCount := 0;
    FSegmentPos := 0;
  end;

  if Range > 0 then
  begin
    P := FPosition - FMin;
    if P < 0 then P := 0;

    if not Full then
      FSegmentPos := (P*FSegmentCount) div Range
    else begin
      for I := 0 to FSegments.Count-1 do
        Inc(FSegmentCount, FSegments[I].Count);

      FSegmentSize := 0;
      if FSegmentCount > 0 then
      begin
        if FOrientation = scoHorizontal then
          S := ClientWidth
        else S := ClientHeight;

        Dec(S, 2*Indent + Spacing*(FSegmentCount - 1));

        if S > 0 then
        begin
          FSegmentSize := S div FSegmentCount;
          if FSegmentSize > 0 then
            FSegmentPos := (P*FSegmentCount) div Range;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomMeter.ClearSegmentBuffer;
var
  O: TObject;
  Rec: PSegmentRec;
begin
  while FSegmentBuffer.Count > 0 do
  begin
    Rec := FSegmentBuffer[0];
    FSegmentBuffer.Delete(0);

    O := Rec^.Bitmap;
    Dispose(Rec);

    if O <> nil then O.Free;
  end;
end;

constructor TSCCustomMeter.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
  FSegments := TSCMeterSegments.Create(Self);

  ControlStyle := [csCaptureMouse, csClickEvents, csOpaque, csReplicatable];
  SetBounds(Left, Top, 150, 20);
  DoubleBuffered := True;

  FSegmentBuffer := TList.Create;

  Border := sccbLowered;
  BlendColor := False;
  ParentColor := False;
  Color := clBlack;
  ClickFocus := False;
  Indent := 2;
  Spacing := 2;

  FOrientation := scoHorizontal;
  FMin := 0;
  FMax := 100;
  FPosition := 0;
  FShowInactive := True;
  FStyle := scmsClassic;

  CalculateSegments;
  PrepareSegmentBuffer(True);
end;

procedure TSCCustomMeter.CreateWnd;
begin
  inherited CreateWnd;
  UpdateSegmentValues;
  PrepareSegmentBuffer(True);
  Invalidate;
end;

destructor TSCCustomMeter.Destroy;
begin
  ClearSegmentBuffer;
  FreeAndNil(FSegmentBuffer);
  FreeAndNil(FSegments);
  inherited Destroy;
end;

procedure TSCCustomMeter.DrawSegment(Canvas: TCanvas; R: TRect; C: TColor);
var
  R2: TRect;
  C1, C2: TColor;
begin
  if (C = clNone) or IsRectEmpty(R) then
    Exit;

  if FOrientation = scoHorizontal then
  begin
    case FStyle of
      scmsClassic, scmsRaised:
      begin
        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C;

          FillRect(R);
        end;

        if FStyle = scmsRaised then
        begin
          C1 := SCCommon.scBlendColor(C, 64);
          C2 := SCCommon.scBlendColor(C, -64);

          R2 := R;
          scFrame3D(Canvas, R2, C1, C2, 1, 0);
        end;
      end;
      scmsGradient:
      begin
        R2 := R;
        R2.Bottom := R2.Top + Round((R2.Bottom - R2.Top) / 2);

        if not IsRectEmpty(R2) then
        begin
          C1 := SCCommon.scBlendColor(C, 64);
          scDrawGradient(Canvas, R2, scgTopToBottom, C1, C);

          R2.Top := R2.Bottom;
          R2.Bottom := R.Bottom;

          C1 := SCCommon.scBlendColor(C, -64);
          scDrawGradient(Canvas, R2, scgTopToBottom, C, C1);
        end;
      end;
      scmsMetal, scmsXP:
      begin
        R2 := R;
        R2.Bottom := R2.Top + ((R2.Bottom - R2.Top) div 2);

        if not IsRectEmpty(R2) then
        begin
          C1 := SCCommon.scBlendColor(C, 128);
          scDrawGradient(Canvas, R2, scgTopToBottom, C1, C);

          R2.Top := R2.Bottom;
          R2.Bottom := R.Bottom;

          scDrawGradient(Canvas, R2, scgTopToBottom, C, C1);
        end;

        R2 := R;
        if FStyle = scmsMetal then scFrame3D(Canvas, R2, C, C, 1, 0);
      end;
    end;
  end else
  begin
    case FStyle of
      scmsClassic, scmsRaised:
      begin
        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C;

          FillRect(R);
        end;

        if FStyle = scmsRaised then
        begin
          C1 := SCCommon.scBlendColor(C, 64);
          C2 := SCCommon.scBlendColor(C, -64);

          R2 := R;
          scFrame3D(Canvas, R2, C1, C2, 1, 0);
        end;
      end;
      scmsGradient:
      begin
        R2 := R;
        R2.Right := R2.Left + Round((R2.Right - R2.Left) / 2);

        if not IsRectEmpty(R2) then
        begin
          C1 := SCCommon.scBlendColor(C, 64);
          scDrawGradient(Canvas, R2, scgLeftToRight, C1, C);

          R2.Left := R2.Right;
          R2.Right := R.Right;

          C1 := SCCommon.scBlendColor(C, -64);
          scDrawGradient(Canvas, R2, scgLeftToRight, C, C1);
        end;
      end;
      scmsMetal, scmsXP:
      begin
        R2 := R;
        R2.Right := R2.Left + ((R2.Right - R2.Left) div 2);

        if not IsRectEmpty(R2) then
        begin
          C1 := SCCommon.scBlendColor(C, 128);
          scDrawGradient(Canvas, R2, scgLeftToRight, C1, C);

          R2.Left := R2.Right;
          R2.Right := R.Right;

          scDrawGradient(Canvas, R2, scgLeftToRight, C, C1);
        end;

        R2 := R;
        if FStyle = scmsMetal then scFrame3D(Canvas, R2, C, C, 1, 0);
      end;
    end;
  end;
end;

function TSCCustomMeter.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomMeter.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCMeterBorderProps;
end;

function TSCCustomMeter.GetSegmentBitmap(C: TColor): TBitmap;
var
  I: Integer;
  Rec: PSegmentRec;
begin
  Result := nil;
  if C <> clNone then
    for I := 0 to FSegmentBuffer.Count-1 do
    begin
      Rec := FSegmentBuffer[I];
      if Rec^.Color = C then
      begin
        Result := Rec^.Bitmap;
        Exit;
      end;
    end;
end;

procedure TSCCustomMeter.IndentChanged;
begin
  UpdateSegmentValues;
  PrepareSegmentBuffer(True);
  Invalidate;
end;

procedure TSCCustomMeter.Loaded;
begin
  inherited Loaded;
  UpdateSegmentValues;
  PrepareSegmentBuffer(True);
  Invalidate;
end;

procedure TSCCustomMeter.Paint;
var
  CR, R: TRect;
  C: TColor;
  SegBmp: TBitmap;
  I, J, Cnt, SR: Integer;
begin
  C := Self.Color;
  if C = clNone then C := clBlack;

  CR := ClientRect;
  
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := C;

    FillRect(CR);
  end;

  if Transparent then PaintParentOn(Canvas);
  DrawPicture(Canvas);

  if (FSegmentCount > 0) and (FSegmentSize > 0) and
    (FShowInactive or (FSegmentPos > 0)) then
  begin
    InflateRect(CR, -Indent, -Indent);

    if not IsRectEmpty(CR) then
    begin
      SR := IntersectClipRect(Canvas.Handle, CR.Left, CR.Top, CR.Right, CR.Bottom);
      try
        if SR <> NULLREGION then
        begin
          R := CR;

          if FOrientation = scoHorizontal then
            R.Right := R.Left + FSegmentSize
          else  
            R.Top := R.Bottom - FSegmentSize;

          Cnt := 0;
          for I := 0 to FSegments.Count-1 do
            for J := 0 to FSegments[I].Count-1 do
            begin
              if not IntersectRect(R, R, CR) then
                Exit;

              if not FShowInactive and (Cnt >= FSegmentPos) then
                Continue;

              C := FSegments[I].Color;
              if not FSingleActive and (Cnt < FSegmentPos) then
                C := FSegments[I].ActiveColor
              else if FSingleActive and (Cnt = FSegmentPos - 1) then
                C := FSegments[I].ActiveColor;

              if C <> clNone then
              begin
                SegBmp := GetSegmentBitmap(C);
                if SegBmp <> nil then Canvas.Draw(R.Left, R.Top, SegBmp);
              end;

              Inc(Cnt);
              if FOrientation = scoHorizontal then
                OffsetRect(R, FSegmentSize + Spacing, 0)
              else
                OffsetRect(R, 0, -(FSegmentSize + Spacing));
            end;
        end;
      finally
        SelectClipRgn(Canvas.Handle, 0);
      end;
    end;  
  end;
end;

procedure TSCCustomMeter.PrepareSegmentBuffer(UpdateAll: Boolean);
var
  L: TList;
  C: TColor;
  Bmp: TBitmap;
  CR, R: TRect;
  NeedC: Boolean;
  Rec: PSegmentRec;
  I, J: Integer;
begin
  CR := ClientRect;
  
  InflateRect(CR, -Indent, -Indent);
  OffsetRect(CR, -CR.Left, -CR.Top);

  if (FSegmentCount = 0) or (FSegmentSize = 0) or
    IsRectEmpty(CR) or ((FSegmentPos = 0) and not FShowInactive) then
  begin
    ClearSegmentBuffer;
    Exit;
  end;

  L := TList.Create;
  try
    for I := 0 to FSegments.Count-1 do
    begin
      C := FSegments[I].FActiveColor;
      if (C <> clNone) and (L.IndexOf(Pointer(C)) = -1) then
        L.Add(Pointer(C));

      C := FSegments[I].FColor;
      if FShowInactive and (C <> clNone) and (L.IndexOf(Pointer(C)) = -1) then
        L.Add(Pointer(C));
    end;

    if UpdateAll then
      ClearSegmentBuffer
    else begin
      for I := FSegmentBuffer.Count-1 downto 0 do
      begin
        Rec := FSegmentBuffer[I];
        if L.IndexOf(Pointer(Rec^.Color)) = -1 then
        begin
          FSegmentBuffer.Delete(I);

          if Rec^.Bitmap <> nil then
          begin
            Bmp := Rec^.Bitmap;
            Rec^.Bitmap := nil;

            Bmp.Free;
          end;

          Dispose(Rec);
        end;
      end;
    end;  

    R := CR;

    if FOrientation = scoHorizontal then
      R.Right := FSegmentSize
    else
      R.Bottom := FSegmentSize;

    OffsetRect(R, -R.Left, -R.Top);

    for I := 0 to L.Count-1 do
    begin
      C := TColor(L[I]);
      if C = clNone then Continue;

      NeedC := True;

      for J := 0 to FSegmentBuffer.Count-1 do
      begin
        Rec := FSegmentBuffer[J];
        if Rec^.Color = C then
        begin
          NeedC := False;
          Break;
        end;
      end;

      if NeedC then
      begin
        New(Rec);
        FSegmentBuffer.Add(Rec);

        Rec^.Color := C;
        Bmp := TBitmap.Create;

        Bmp.Width := R.Right;
        Bmp.Height := R.Bottom;

        DrawSegment(Bmp.Canvas, R, C);

        Rec^.Bitmap := Bmp;
      end;
    end;
  finally
    L.Free;
  end;
end;

procedure TSCCustomMeter.Resize;
begin
  UpdateSegmentValues;
  PrepareSegmentBuffer(True);
  Invalidate;
  inherited Resize;
end;

procedure TSCCustomMeter.SegmentChanged(Item: TCollectionItem);
begin
  UpdateSegmentValues;
  PrepareSegmentBuffer(True);
  Invalidate;
end;

procedure TSCCustomMeter.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;
  inherited SetIndent(Value);
end;

procedure TSCCustomMeter.SetMax(Value: Integer);
begin
  if FMax <> Value then
  begin
    FMax := Value;
    if FMin > FMax then FMin := FMax;
    if FMax < FPosition then SetPosition(FMax);

    if UpdateSegmentValues then
      Invalidate;
  end;
end;

procedure TSCCustomMeter.SetMin(Value: Integer);
begin
  if FMin <> Value then
  begin
    FMin := Value;
    if FMax < FMin then FMax := FMin;
    if FMin > FPosition then SetPosition(FMin);

    if UpdateSegmentValues then
      Invalidate;
  end;
end;

procedure TSCCustomMeter.SetOrientation(Value: TSCOrientation);
var
  R: TRect;
  H: Integer;
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;

    if HandleAllocated and not (IsLoading or IsReading) then
    begin
      R := BoundsRect;

      Dec(R.Right, R.Left);
      Dec(R.Bottom, R.Top);

      H := R.Bottom;
      R.Bottom := R.Right;
      R.Right := H;

      SetBounds(R.Left, R.Top, R.Right, R.Bottom);
    end;

    UpdateSegmentValues;
    PrepareSegmentBuffer(True);
    Invalidate;
  end;
end;

procedure TSCCustomMeter.SetPosition(Value: Integer);
begin
  if Value < FMin then Value := FMin;
  if Value > FMax then Value := FMax;

  if FPosition <> Value then
  begin
    FPosition := Value;

    if UpdateSegmentValues(False) then
      Invalidate;

    Change;
  end;
end;

procedure TSCCustomMeter.SetSegments(Value: TSCMeterSegments);
begin
  FSegments.Assign(Value);
end;

procedure TSCCustomMeter.SetShowInactive(Value: Boolean);
begin
  if FShowInactive <> Value then
  begin
    FShowInactive := Value;
    PrepareSegmentBuffer(False);
    Invalidate;
  end;
end;

procedure TSCCustomMeter.SetSingleActive(Value: Boolean);
begin
  if FSingleActive <> Value then
  begin
    FSingleActive := Value;
    Invalidate;
  end;
end;

procedure TSCCustomMeter.SetStyle(Value: TSCMeterStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    PrepareSegmentBuffer(True);
    Invalidate;
  end;
end;

procedure TSCCustomMeter.SpacingChanged;
begin
  UpdateSegmentValues;
  PrepareSegmentBuffer(True);
  Invalidate;
end;

function TSCCustomMeter.UpdateSegmentValues(Full: Boolean): Boolean;
var
  SP, SC, SS: Integer;
begin
  SP := FSegmentPos;
  SC := FSegmentCount;
  SS := FSegmentSize;

  CalculateSegments(Full);

  Result := (SP <> FSegmentPos) or (SC <> FSegmentCount) or
    (SS <> FSegmentSize);
end;

{ TSCCustomMarixDisplay }

procedure TSCCustomMarixDisplay.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomMarixDisplay then
  begin
    with TSCCustomMarixDisplay(Source) do
    begin
      Self.ColorOn := ColorOn;
      Self.ColorOff := ColorOff;
      Self.ScrollDelay := ScrollDelay;
      Self.ScrollEnabled := ScrollEnabled;
      Self.ScrollType := ScrollType;
    end;
  end;
end;

procedure TSCCustomMarixDisplay.CMTextChanged(var Message: TMessage);
var
  P: Integer;
begin
  inherited;
  if FScrolling and (FScrollType = scstLeftToRight) then
  begin
    Inc(FPauseScroll);
    try
      P := FOffsetX + 6*Length(Caption);
      if P < 0 then
      begin
        FOffsetX := -6*Length(Caption);
        Invalidate;
      end;
    finally
      Dec(FPauseScroll);
    end;
  end;
  Change;
end;

constructor TSCCustomMarixDisplay.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csOpaque, csReplicatable];
  SetBounds(Left, Top, 280, 40);
  DoubleBuffered := True;

  Border := sccbLowered;
  BlendColor := False;
  ParentColor := False;
  Color := clBlack;
  ClickFocus := False;

  FScrollTimer := -1;
  FScrollDelay := 50;
  FScrollEnabled := False;
  FScrollType := scstRightToLeft;

  FColorOn := clLime;
  FColorOff := $00004000;
end;

procedure TSCCustomMarixDisplay.CreateWnd;
var
  Offset: Integer;
  Scrolling: Boolean;
begin
  Scrolling := FScrollEnabled;

  inherited CreateWnd;
  UpdateCellSize;
  Invalidate;

  Offset := FOffsetX;

  if Scrolling and (not FScrolling or not FScrollEnabled) then
  begin
    FScrollEnabled := True;
    StartScrolling(Offset);
  end;
end;

destructor TSCCustomMarixDisplay.Destroy;
begin
  StopScrolling;
  inherited Destroy;
end;

procedure TSCCustomMarixDisplay.DrawCells;
var
  CR, R: TRect;
  I, J, W, K: Integer;
begin
  CR := ClientRect;
  if not IsRectEmpty(CR) and (FCellSize > 0) and (FColorOff <> clNone) then
  begin
    R := Rect(0, 0, FCellSize, FCellSize);
    OffsetRect(R, 1, FTopIndent);

    W := (CR.Right - CR.Left) - 2;
    if W > 0 then
    begin
      K := W div (FCellSize + 1);
      
      if K >= 0 then
      begin
        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FColorOff;
        end;

        for I := 0 to K do
        begin
          for J := 0 to 9 do
          begin
            Canvas.FillRect(R);
            OffsetRect(R, 0, FCellSize + 1);
          end;

          OffsetRect(R, FCellSize + 1, -R.Top + FTopIndent);
        end;
      end;
    end;  
  end;
end;

function TSCCustomMarixDisplay.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomMarixDisplay.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCMatrixBorderProps;
end;

procedure TSCCustomMarixDisplay.Loaded;
begin
  inherited Loaded;
  UpdateCellSize;
  Invalidate;

  if FScrollEnabled then StartScrolling(0);
end;

procedure TSCCustomMarixDisplay.Paint;
var
  C: TColor;
  CR, R: TRect;
  Col: TSCMatrixRow;
  S: String;
  I, OrdCh: Integer;
begin
  C := Self.Color;
  if C = clNone then C := clBlack;

  CR := ClientRect;
  
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := C;

    FillRect(CR);
  end;

  if Transparent then PaintParentOn(Canvas);
  DrawPicture(Canvas);

  DrawCells;

  S := Caption;

  if (FColorOn <> clNone) and (FColorOn <> FColorOff) and
    (Length(S) > 0) and (FCellSize > 0) then
  begin
    R := Rect(0, 0, FCellSize, FCellSize);

    OffsetRect(R, 1, FTopIndent);
    OffsetRect(R, FOffsetX*(FCellSize + 1), 0);

    for I := 1 to Length(S) do
    begin
      OrdCh := Ord(S[I]) - Ord(' ');

      if (OrdCh < 0) or (OrdCh > 94) then
        Col := SCMatrixChars[95]
      else
        Col := SCMatrixChars[OrdCh];

      PaintRow(R.Left, R.Top, Col.Row0);
      OffsetRect(R, 0, FCellSize + 1);

      PaintRow(R.Left, R.Top, Col.Row1);
      OffsetRect(R, 0, FCellSize + 1);

      PaintRow(R.Left, R.Top, Col.Row2);
      OffsetRect(R, 0, FCellSize + 1);

      PaintRow(R.Left, R.Top, Col.Row3);
      OffsetRect(R, 0, FCellSize + 1);

      PaintRow(R.Left, R.Top, Col.Row4);
      OffsetRect(R, 0, FCellSize + 1);

      PaintRow(R.Left, R.Top, Col.Row5);
      OffsetRect(R, 0, FCellSize + 1);

      PaintRow(R.Left, R.Top, Col.Row6);
      OffsetRect(R, 0, FCellSize + 1);

      PaintRow(R.Left, R.Top, Col.Row7);
      OffsetRect(R, 0, FCellSize + 1);

      PaintRow(R.Left, R.Top, Col.Row8);
      OffsetRect(R, 0, FCellSize + 1);

      PaintRow(R.Left, R.Top, Col.Row9);
      OffsetRect(R, 0, FCellSize + 1);

      OffsetRect(R, 6*(FCellSize + 1), -R.Top + FTopIndent);
    end;
  end;
end;

procedure TSCCustomMarixDisplay.PaintRow(X, Y: Integer; S: String);
var
  R: TRect;
  I: Integer;
begin
  if S = '00000' then
    Exit;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := FColorOn;
  end;

  R := Rect(X, Y, X + FCellSize, Y + FCellSize);

  for I := 1 to 5 do
  begin
    if S[I] = '1' then Canvas.FillRect(R);
    OffsetRect(R, FCellSize + 1, 0);
  end;
end;

procedure TSCCustomMarixDisplay.Resize;
begin
  inherited Resize;
  UpdateCellSize;
  Invalidate;
end;

procedure TSCCustomMarixDisplay.SetColorOff(Value: TColor);
begin
  if FColorOff <> Value then
  begin
    FColorOff := Value;
    Invalidate;
  end;
end;

procedure TSCCustomMarixDisplay.SetColorOn(Value: TColor);
begin
  if FColorOn <> Value then
  begin
    FColorOn := Value;
    Invalidate;
  end;
end;

procedure TSCCustomMarixDisplay.SetScrollDelay(Value: Integer);
var
  Offset: Integer;
  Scrolling: Boolean;
begin
  if FScrollDelay <> Value then
  begin
    FScrollDelay := Value;

    Offset := FOffsetX;
    Scrolling := FScrollEnabled;

    StopScrolling;

    if Scrolling then
    begin
      FScrollEnabled := Scrolling;
      StartScrolling(Offset);
    end;
  end;
end;

procedure TSCCustomMarixDisplay.SetScrollEnabled(Value: Boolean);
begin
  if FScrollEnabled <> Value then
  begin
    StopScrolling;
    
    FScrollEnabled := Value;
    if FScrollEnabled then StartScrolling(0);
  end;
end;

procedure TSCCustomMarixDisplay.SetScrollType(Value: TSCMatrixScrollType);
var
  Offset: Integer;
  Scrolling: Boolean;
begin
  if FScrollType <> Value then
  begin
    FScrollType := Value;

    Offset := FOffsetX;
    Scrolling := FScrollEnabled;
    
    StopScrolling;

    if Scrolling then
    begin
      FScrollEnabled := Scrolling;
      StartScrolling(Offset);
    end;
  end;
end;

procedure TSCCustomMarixDisplay.StartScrolling(Offset: Integer);
var
  CR: TRect;
  W: Integer;
begin
  if HandleAllocated and FScrollEnabled then
  begin
    FOffsetX := 0;

    {$IFDEF SC_DELPHI6_UP}
    if IsDesigning then
      Exit;
    {$ENDIF}

    if not Enabled then
    begin
      StopScrolling;
      Exit;
    end;

    if Offset <> 0 then
      FOffsetX := Offset
    else begin
      CR := ClientRect;
      W := (CR.Right - CR.Left) - 2;

      if W > 0 then
      begin
        if FScrollType = scstRightToLeft then
        begin
          FOffsetX := W div (FCellSize + 1);

          Inc(FOffsetX);
          if FOffsetX < 0 then FOffsetX := 0;
        end else
          FOffsetX := -6*Length(Caption);
      end;
    end;  

    if FScrollTimer <> -1 then KillTimer(Handle, FScrollTimer);

    FScrollTimer := SetTimer(Handle, SC_MATRIX_TIMERID, FScrollDelay, nil);
    FScrollEnabled := FScrollTimer <> -1;

    FScrolling := FScrollTimer <> -1;

    Invalidate;
  end;
end;

procedure TSCCustomMarixDisplay.StopScrolling;
begin
  FScrolling := False;
  FScrollEnabled := False;
  FPauseScroll := 0;

  FOffsetX := 0;
  if FScrollTimer <> -1 then
  begin
    if HandleAllocated then KillTimer(Handle, FScrollTimer);
    
    FScrollTimer := -1;
    Invalidate;
  end;
end;

procedure TSCCustomMarixDisplay.UpdateCellSize;
var
  H: Integer;
begin
  H := ClientHeight - 2;

  FCellSize := (H - 9) div 10;
  if FCellSize < 0 then FCellSize := 0;

  FTopIndent := (H + 2 - (9 + (10*FCellSize))) div 2;
  if FTopIndent < 0 then FTopIndent := 0;
end;

procedure TSCCustomMarixDisplay.WMTimer(var Message: TWMTimer);
var
  CR: TRect;
  W: Integer;
begin
  inherited;

  if HandleAllocated and FScrollEnabled and (Message.TimerID = SC_MATRIX_TIMERID) then
  begin
    if not Enabled then
    begin
      StopScrolling;
      Exit;
    end;

    if FPauseScroll = 0 then
    begin
      CR := ClientRect;
      W := (CR.Right - CR.Left) - 2;

      if FScrollType = scstRightToLeft then
      begin
        Dec(FOffsetX);

        if FOffsetX < -6*Length(Caption) then
        begin
          FOffsetX := W div (FCellSize + 1);

          Inc(FOffsetX);
          if FOffsetX < 0 then FOffsetX := 0;
        end;
      end else
      begin
        Inc(FOffsetX);
        if FOffsetX > W div (FCellSize + 1) then
          FOffsetX := -6*Length(Caption);
      end;
    end;  

    if FScrollTimer <> -1 then KillTimer(Handle, FScrollTimer);

    FScrollTimer := SetTimer(Handle, SC_MATRIX_TIMERID, FScrollDelay, nil);
    FScrollEnabled := FScrollTimer <> -1;

    FScrolling := FScrollTimer <> -1;

    if FPauseScroll = 0 then Invalidate;
  end;
end;

{ TSCMatrixBorderProps }

constructor TSCMatrixBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccbLowered;
end;

{ TSCSegmentBorderProps }

constructor TSCSegmentBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccbLowered;
end;

{ TSCCustomSevenSegment }

procedure TSCCustomSevenSegment.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomSevenSegment then
    with TSCCustomSevenSegment(Source) do
    begin
      Self.Alignment := Alignment;
      Self.DigitCount := DigitCount;
      Self.ColorOff := ColorOff;
      Self.ColorOn := ColorOn;
      Self.SegmentSpacing := SegmentSpacing;
      Self.SegmentThickness := SegmentThickness;
    end;
end;

procedure TSCCustomSevenSegment.CalculatePolygons;
var
  R, SR: TRect;
  H, H2: Integer;
begin
  R := Rect(0, 0, FDigitWidth, FDigitHeight);

  // Top
  SR := R;
  Dec(SR.Right);
  InflateRect(SR, -FSegmentSpacing, 0);
  SR.Bottom := SR.Top + (FSegmentThickness - 1);

  FT[0] := SR.TopLeft;
  FT[1] := Point(SR.Left + (FSegmentThickness - 1), SR.Bottom);
  FT[2] := Point(SR.Right - (FSegmentThickness - 1), SR.Bottom);
  FT[3] := Point(SR.Right, SR.Top);

  H := (R.Bottom - R.Top - 3*FSegmentSpacing) div 2;


  // Left top
  SR := R;
  SR.Right := SR.Left + (FSegmentThickness - 1);
  Inc(SR.Top, FSegmentSpacing);
  SR.Bottom := SR.Top + H;

  FLT[0] := SR.TopLeft;
  FLT[1] := Point(SR.Left, SR.Bottom);
  FLT[2] := Point(SR.Right, SR.Bottom - (FSegmentThickness - 1));
  FLT[3] := Point(SR.Right, SR.Top + (FSegmentThickness - 1));


  // Left bottom
  SR := R;
  SR.Right := SR.Left + (FSegmentThickness - 1);
  SR.Top := FLT[1].Y;
  if Odd(FSegmentSpacing) then Inc(SR.Top);
  Dec(SR.Bottom);
  InflateRect(SR, 0, -FSegmentSpacing);

  FLB[0] := SR.TopLeft;
  FLB[1] := Point(SR.Left, SR.Bottom);
  FLB[2] := Point(SR.Right, SR.Bottom - (FSegmentThickness - 1));
  FLB[3] := Point(SR.Right, SR.Top + (FSegmentThickness - 1));


  // Bottom
  SR := R;
  OffsetRect(SR, 0, -1);
  Dec(SR.Right);
  InflateRect(SR, -FSegmentSpacing, 0);
  SR.Top := SR.Bottom - (FSegmentThickness - 1);

  FB[0] := Point(SR.Left, SR.Bottom);
  FB[1] := Point(SR.Right, SR.Bottom);
  FB[2] := Point(SR.Right - (FSegmentThickness - 1), SR.Top);
  FB[3] := Point(SR.Left + (FSegmentThickness - 1), SR.Top);


  // Right top
  SR := R;
  Dec(SR.Right);
  SR.Left := SR.Right - (FSegmentThickness - 1);
  Inc(SR.Top, FSegmentSpacing);
  SR.Bottom := SR.Top + H;

  FRT[0] := Point(SR.Right, SR.Top);
  FRT[1] := Point(SR.Right, SR.Bottom);
  FRT[2] := Point(SR.Left, SR.Bottom - FSegmentThickness + 1);
  FRT[3] := Point(SR.Left, SR.Top + FSegmentThickness - 1);


  // Right bottom
  SR := R;
  Dec(SR.Right);
  SR.Left := SR.Right - (FSegmentThickness - 1);
  SR.Top := FRT[1].Y;
  if Odd(FSegmentSpacing) then Inc(SR.Top);
  Dec(SR.Bottom);
  InflateRect(SR, 0, -FSegmentSpacing);

  FRB[0] := Point(SR.Right, SR.Top);
  FRB[1] := Point(SR.Right, SR.Bottom);
  FRB[2] := Point(SR.Left, SR.Bottom - FSegmentThickness + 1);
  FRB[3] := Point(SR.Left, SR.Top + FSegmentThickness - 1);


  // Center
  SR := R;
  Dec(SR.Right);
  InflateRect(SR, -FSegmentSpacing, 0);
  Inc(SR.Top, H + FSegmentSpacing + (FSegmentSpacing div 2));
  if Odd(FSegmentSpacing) then Inc(SR.Top);
  SR.Bottom := SR.Top;

  H2 := FSegmentThickness div 2;
  if H2 = 0 then H2 := 1;

  Dec(SR.Top, H2);
  Inc(SR.Bottom, H2);

  FC[0] := Point(SR.Left, SR.Top + H2);
  FC[1] := Point(SR.Left + H2, SR.Top);
  FC[2] := Point(SR.Right - H2, SR.Top);
  FC[3] := Point(SR.Right, SR.Top + H2);
  FC[4] := Point(SR.Right - H2, SR.Bottom);
  FC[5] := Point(SR.Left + H2, SR.Bottom);
end;

procedure TSCCustomSevenSegment.CalculateSize;
var
  H: Integer;
  CR, R: TRect;
begin
  CR := ClientRect;
  R := CR;

  InflateRect(R, -Indent, -Indent);
  OffsetRect(R, -R.Left, -R.Top);

  if IsRectEmpty(R) then
  begin
    FDigitHeight := 0;
    FDigitWidth := 0;
    FTopIndent := 0;
  end else
  begin
    FDigitHeight := R.Bottom;

    H := 3*FSegmentSpacing + 4*FSegmentThickness;
    if FDigitHeight < H then FDigitHeight := H;

    FDigitWidth := 2*(FDigitHeight div 3);
    FTopIndent := (CR.Bottom - FDigitHeight) div 2;
  end;

  CalculatePolygons;
end;

procedure TSCCustomSevenSegment.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Change;
end;

constructor TSCCustomSevenSegment.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csOpaque, csReplicatable];
  SetBounds(Left, Top, 280, 40);
  DoubleBuffered := True;

  Border := sccbLowered;
  BlendColor := False;
  ParentColor := False;
  Color := clBlack;
  ClickFocus := False;

  Indent := 2;
  Spacing := 4;

  FAlignment := taRightJustify;
  FColorOff := $001E401E;
  FColorOn := clLime;
  FSegmentSpacing := 1;
  FSegmentThickness := 3;

  CalculateSize;
end;

procedure TSCCustomSevenSegment.CreateWnd;
begin
  inherited CreateWnd;
  CalculateSize;
  Invalidate;
end;

procedure TSCCustomSevenSegment.DrawSegment(Ch: Char; R: TRect);
var
  S: String;
  R2: TRect;
  W, I, H: Integer;
  Cl, C1, C2: TColor;
  D: array[0..7] of TPoint;
  C: array[0..5] of TPoint;
  Cm: array[0..2] of TPoint;
  L: array[0..3] of TPoint;
  T, LT, LB, B, RT, RB: array[0..3] of TPoint;
begin
  if not (Ch in [#0, '*', '.', ':', ',', '-',
    '_', '%', '/', ' ', 'A'..'F', '0'..'9']) then
    Exit;

  C1 := FColorOn;
  if C1 = clNone then C1 := clLime;

  C2 := FColorOff;

  with Canvas do
  begin
    Pen.Style := psSolid;
    Pen.Width := 1;
    Pen.Color := C1;

    Brush.Style := bsSolid;
    Brush.Color := C1;
  end;

  if Ch = '*' then
  begin
    // Do nothing, only give an half space
  end
  else if Ch = '/' then
  begin
    W := FSegmentThickness;
    if W < 3 then W := 3;

    H := R.Right - R.Left - W;

    L[0] := Point(R.Right, R.Top + ((R.Bottom - R.Top) - H) div 2);
    L[1] := Point(R.Right - H, L[0].y + H);
    L[2] := Point(L[1].x - W, L[1].y);
    L[3] := Point(L[0].x - W, L[0].y);

    with Canvas do
    begin
      Brush.Color := C1;
      Pen.Color := C1;

      Polygon(L);
    end;
  end
  else if Ch = '%' then
  begin
    W := FSegmentThickness;
    if W < 3 then W := 3;

    H := R.Right - R.Left - W;

    L[0] := Point(R.Right, R.Top + ((R.Bottom - R.Top) - H) div 2);
    L[1] := Point(R.Right - H, L[0].y + H);
    L[2] := Point(L[1].x - W, L[1].y);
    L[3] := Point(L[0].x - W, L[0].y);

    with Canvas do
    begin
      Brush.Color := C1;
      Pen.Color := C1;

      Polygon(L);
    end;

    R2 := R;

    R2.Right := R2.Left + ((R2.Right - R2.Left) div 2);
    R2.Bottom := R2.Top + ((R2.Bottom - R2.Top) div 2);

    R2.Left := R2.Right - (W + 1);
    R2.Top := R2.Bottom - (W + 1);

    OffsetRect(R2, -((W div 2) + 2), -((W div 2) + 3));

    D[0] := Point(R2.Left + 1, R2.Top);
    D[1] := Point(R2.Right - 1, R2.Top);
    D[2] := Point(R2.Right, R2.Top + 1);
    D[3] := Point(R2.Right, R2.Bottom - 1);
    D[4] := Point(R2.Right - 1, R2.Bottom);
    D[5] := Point(R2.Left + 1, R2.Bottom);
    D[6] := Point(R2.Left, R2.Bottom - 1);
    D[7] := Point(R2.Left, R2.Top + 1);

    with Canvas do
    begin
      Brush.Color := C1;
      Pen.Color := C1;

      Polygon(D);
    end;

    R2 := R;

    Inc(R2.Left, (R2.Right - R2.Left) div 2);
    Inc(R2.Top, (R2.Bottom - R2.Top) div 2);

    R2.Right := R2.Left + (W + 1);
    R2.Bottom := R2.Top + (W + 1);

    OffsetRect(R2, (W div 2) + 2, (W div 2) + 4);

    D[0] := Point(R2.Left + 1, R2.Top);
    D[1] := Point(R2.Right - 1, R2.Top);
    D[2] := Point(R2.Right, R2.Top + 1);
    D[3] := Point(R2.Right, R2.Bottom - 1);
    D[4] := Point(R2.Right - 1, R2.Bottom);
    D[5] := Point(R2.Left + 1, R2.Bottom);
    D[6] := Point(R2.Left, R2.Bottom - 1);
    D[7] := Point(R2.Left, R2.Top + 1);

    with Canvas do
    begin
      Brush.Color := C1;
      Pen.Color := C1;

      Polygon(D);
    end;
  end
  else if Ch = ',' then
  begin
    W := FSegmentThickness + 1;
    if W < 3 then W := 3;

    Inc(R.Left, (R.Right - R.Left - W) div 2);
    R.Right := R.Left + W + 1;

    R.Top := R.Bottom - W;
    Dec(R.Top);

    OffsetRect(R, 0, -1);

    Cm[0] := Point(R.Left, R.Top);
    Cm[1] := Point(R.Right, R.Top);
    Cm[2] := Point(R.Left, R.Bottom);

    with Canvas do
    begin
      Brush.Color := C1;
      Pen.Color := C1;

      Polygon(Cm);
    end;
  end
  else if Ch = '.' then
  begin
    W := FSegmentThickness;
    if W < 2 then W := 2;

    Inc(R.Left, (R.Right - R.Left - W) div 2);
    R.Right := R.Left + W + 1;

    R.Top := R.Bottom - W;
    Dec(R.Top);

    OffsetRect(R, 0, -1);

    D[0] := Point(R.Left + 1, R.Top);
    D[1] := Point(R.Right - 1, R.Top);
    D[2] := Point(R.Right, R.Top + 1);
    D[3] := Point(R.Right, R.Bottom - 1);
    D[4] := Point(R.Right - 1, R.Bottom);
    D[5] := Point(R.Left + 1, R.Bottom);
    D[6] := Point(R.Left, R.Bottom - 1);
    D[7] := Point(R.Left, R.Top + 1);

    with Canvas do
    begin
      Brush.Color := C1;
      Pen.Color := C1;

      Polygon(D);
    end;
  end
  else if Ch = ':' then
  begin
    W := FSegmentThickness;
    if W < 2 then W := 2;

    Inc(R.Left, (R.Right - R.Left - W) div 2);
    R.Right := R.Left + W + 1;

    Inc(R.Top, (R.Bottom - R.Top - 3*W) div 2);
    R.Bottom := R.Top + W;

    Dec(R.Top);

    OffsetRect(R, 0, -(W div 2));
    
    D[0] := Point(R.Left + 1, R.Top);
    D[1] := Point(R.Right - 1, R.Top);
    D[2] := Point(R.Right, R.Top + 1);
    D[3] := Point(R.Right, R.Bottom - 1);
    D[4] := Point(R.Right - 1, R.Bottom);
    D[5] := Point(R.Left + 1, R.Bottom);
    D[6] := Point(R.Left, R.Bottom - 1);
    D[7] := Point(R.Left, R.Top + 1);

    with Canvas do
    begin
      Brush.Color := C1;
      Pen.Color := C1;

      Polygon(D);
    end;

    W := 3*W;

    Inc(D[0].y, W);
    Inc(D[1].y, W);
    Inc(D[2].y, W);
    Inc(D[3].y, W);
    Inc(D[4].y, W);
    Inc(D[5].y, W);
    Inc(D[6].y, W);
    Inc(D[7].y, W);

    with Canvas do
    begin
      Brush.Color := C1;
      Pen.Color := C1;

      Polygon(D);
    end;
  end else
  begin
    S := '0000000';

    if Ch = '-' then
      S := '0001000'
    else if Ch = '_' then
      S := '0000001'
    else begin
      for I := Low(SCSevenSegChars) to High(SCSevenSegChars) do
        if SCSevenSegChars[I].Ch = Ch then
          S := SCSevenSegChars[I].Pattern;
    end;

    T[0].x := FT[0].x + R.Left;
    T[0].y := FT[0].y + R.Top;

    T[1].x := FT[1].x + R.Left;
    T[1].y := FT[1].y + R.Top;

    T[2].x := FT[2].x + R.Left;
    T[2].y := FT[2].y + R.Top;

    T[3].x := FT[3].x + R.Left;
    T[3].y := FT[3].y + R.Top;

    Cl := C2;
    if S[1] = '1' then Cl := C1;

    if Cl <> clNone then
      with Canvas do
      begin
        Brush.Color := Cl;
        Pen.Color := Cl;

        Polygon(T);
      end;

    LT[0].x := FLT[0].x + R.Left;
    LT[0].y := FLT[0].y + R.Top;

    LT[1].x := FLT[1].x + R.Left;
    LT[1].y := FLT[1].y + R.Top;

    LT[2].x := FLT[2].x + R.Left;
    LT[2].y := FLT[2].y + R.Top;

    LT[3].x := FLT[3].x + R.Left;
    LT[3].y := FLT[3].y + R.Top;

    Cl := C2;
    if S[2] = '1' then Cl := C1;

    if Cl <> clNone then
      with Canvas do
      begin
        Brush.Color := Cl;
        Pen.Color := Cl;

        Polygon(LT);
      end;

    LB[0].x := FLB[0].x + R.Left;
    LB[0].y := FLB[0].y + R.Top;

    LB[1].x := FLB[1].x + R.Left;
    LB[1].y := FLB[1].y + R.Top;

    LB[2].x := FLB[2].x + R.Left;
    LB[2].y := FLB[2].y + R.Top;

    LB[3].x := FLB[3].x + R.Left;
    LB[3].y := FLB[3].y + R.Top;

    Cl := C2;
    if S[3] = '1' then Cl := C1;

    if Cl <> clNone then
      with Canvas do
      begin
        Brush.Color := Cl;
        Pen.Color := Cl;

        Polygon(LB);
      end;

    B[0].x := FB[0].x + R.Left;
    B[0].y := FB[0].y + R.Top;

    B[1].x := FB[1].x + R.Left;
    B[1].y := FB[1].y + R.Top;

    B[2].x := FB[2].x + R.Left;
    B[2].y := FB[2].y + R.Top;

    B[3].x := FB[3].x + R.Left;
    B[3].y := FB[3].y + R.Top;

    Cl := C2;
    if S[7] = '1' then Cl := C1;

    if Cl <> clNone then
      with Canvas do
      begin
        Brush.Color := Cl;
        Pen.Color := Cl;

        Polygon(B);
      end;

    RT[0].x := FRT[0].x + R.Left;
    RT[0].y := FRT[0].y + R.Top;

    RT[1].x := FRT[1].x + R.Left;
    RT[1].y := FRT[1].y + R.Top;

    RT[2].x := FRT[2].x + R.Left;
    RT[2].y := FRT[2].y + R.Top;

    RT[3].x := FRT[3].x + R.Left;
    RT[3].y := FRT[3].y + R.Top;

    Cl := C2;
    if S[5] = '1' then Cl := C1;

    if Cl <> clNone then
      with Canvas do
      begin
        Brush.Color := Cl;
        Pen.Color := Cl;

        Polygon(RT);
      end;

    RB[0].x := FRB[0].x + R.Left;
    RB[0].y := FRB[0].y + R.Top;

    RB[1].x := FRB[1].x + R.Left;
    RB[1].y := FRB[1].y + R.Top;

    RB[2].x := FRB[2].x + R.Left;
    RB[2].y := FRB[2].y + R.Top;

    RB[3].x := FRB[3].x + R.Left;
    RB[3].y := FRB[3].y + R.Top;

    Cl := C2;
    if S[6] = '1' then Cl := C1;

    if Cl <> clNone then
      with Canvas do
      begin
        Brush.Color := Cl;
        Pen.Color := Cl;

        Polygon(RB);
      end;

    C[0].x := FC[0].x + R.Left;
    C[0].y := FC[0].y + R.Top;

    C[1].x := FC[1].x + R.Left;
    C[1].y := FC[1].y + R.Top;

    C[2].x := FC[2].x + R.Left;
    C[2].y := FC[2].y + R.Top;

    C[3].x := FC[3].x + R.Left;
    C[3].y := FC[3].y + R.Top;

    C[4].x := FC[4].x + R.Left;
    C[4].y := FC[4].y + R.Top;

    C[5].x := FC[5].x + R.Left;
    C[5].y := FC[5].y + R.Top;

    Cl := C2;
    if S[4] = '1' then Cl := C1;

    if Cl <> clNone then
      with Canvas do
      begin
        Brush.Color := Cl;
        Pen.Color := Cl;

        Polygon(C);
      end;
  end;
end;

procedure TSCCustomSevenSegment.DrawSegments;
var
  S: String;
  I: Integer;
  CR, R: TRect;
begin
  CR := ClientRect;
  InflateRect(CR, -Indent, -FTopIndent);

  S := Caption;

  for I := Length(S) downto 1 do
    if not (S[I] in ['*', '.', ':', ',', '-',
      '_', '%', '/', ' ', #0, 'A'..'F', '0'..'9']) then
      Delete(S, I, 1);

  R := CR;
  if FAlignment = taLeftJustify then
  begin
    R.Right := R.Left;

    if FDigitCount > 0 then
    begin
      if Length(S) > FDigitCount then
        Delete(S, FDigitCount + 1, Length(S) - FDigitCount)
      else if Length(S) < FDigitCount then
        for I := 1 to FDigitCount - Length(S) do
          S := #0 + S;
    end;
    
    for I := 1 to Length(S) do
    begin
      Inc(R.Right, GetCharWidth(S[I]));
      if IsRectEmpty(R) then
        Continue;

      DrawSegment(S[I], R);

      R.Left := R.Right + Spacing;
      R.Right := R.Left;

      if R.Right >= CR.Right then
        Exit;
    end;
  end else
  begin
    R.Left := R.Right;

    if FDigitCount > 0 then
    begin
      if Length(S) > FDigitCount then
        Delete(S, 1, Length(S) - FDigitCount)
      else if Length(S) < FDigitCount then
        for I := 1 to FDigitCount - Length(S) do
          S := #0 + S;
    end;

    for I := Length(S) downto 1 do
    begin
      Dec(R.Left, GetCharWidth(S[I]));
      if IsRectEmpty(R) then
        Continue;

      DrawSegment(S[I], R);

      R.Right := R.Left - Spacing;
      R.Left := R.Right;  

      if R.Left <= 0 then
        Exit;
    end;
  end;
end;

function TSCCustomSevenSegment.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomSevenSegment.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCSegmentBorderProps;
end;

function TSCCustomSevenSegment.GetCharWidth(Ch: Char): Integer;
var
  W: Integer;
begin
  Result := 0;
  if Ch in [#0, ' ', '-', '_', '/', 'A'..'F', '0'..'9'] then
    Result := FDigitWidth
  else if Ch in ['*', ',', '.', ':'] then
    Result := FDigitWidth div 2
  else if Ch = '%' then
  begin
    W := FSegmentThickness + 2;
    if W < 3 then W := 3;

    Result := 3*W;
    if FDigitWidth > Result then
      Result := FDigitWidth;
  end;
end;

procedure TSCCustomSevenSegment.IndentChanged;
begin
  inherited IndentChanged;
  CalculateSize;
  Invalidate;
end;

procedure TSCCustomSevenSegment.Loaded;
begin
  inherited Loaded;
  CalculateSize;
  Invalidate;
end;

procedure TSCCustomSevenSegment.Paint;
var
  C: TColor;
  CR: TRect;
begin
  C := Self.Color;
  if C = clNone then C := clBlack;

  CR := ClientRect;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := C;

    FillRect(CR);
  end;

  if Transparent then PaintParentOn(Canvas);
  DrawPicture(Canvas);

  DrawSegments;
end;

procedure TSCCustomSevenSegment.Resize;
begin
  CalculateSize;
  Invalidate;
  inherited Resize;
end;

procedure TSCCustomSevenSegment.SetAlignment(Value: TLeftRight);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TSCCustomSevenSegment.SetColorOff(Value: TColor);
begin
  if FColorOff <> Value then
  begin
    FColorOff := Value;
    Invalidate;
  end;
end;

procedure TSCCustomSevenSegment.SetColorOn(Value: TColor);
begin
  if FColorOn <> Value then
  begin
    FColorOn := Value;
    Invalidate;
  end;
end;

procedure TSCCustomSevenSegment.SetDigitCount(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if FDigitCount <> Value then
  begin
    FDigitCount := Value;
    Invalidate;
  end;
end;

procedure TSCCustomSevenSegment.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;
  inherited SetIndent(Value);
end;

procedure TSCCustomSevenSegment.SetSegmentSpacing(Value: Integer);
begin
  if Value < 1 then Value := 1;

  if FSegmentSpacing <> Value then
  begin
    FSegmentSpacing := Value;
    CalculateSize;
    Invalidate;
  end;
end;

procedure TSCCustomSevenSegment.SetSegmentThickness(Value: Integer);
begin
  if Value < 3 then Value := 3;

  if FSegmentThickness <> Value then
  begin
    FSegmentThickness := Value;
    CalculateSize;
    Invalidate;
  end;
end;

procedure TSCCustomSevenSegment.SpacingChanged;
begin
  inherited SpacingChanged;
  CalculateSize;
  Invalidate;
end;

{ TSCHistGraphBorderProps }

constructor TSCHistGraphBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccb3DLowered;
end;

{ TSCCustomHistoryGraph }

procedure TSCCustomHistoryGraph.Add(Value: Integer);
begin
  FList.Add(Pointer(Value));
  if not TrimList then
    Invalidate;
end;

procedure TSCCustomHistoryGraph.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomHistoryGraph then
    with TSCCustomHistoryGraph(Source) do
    begin
      Self.GridColor := GridColor;
      Self.GridStep := GridStep;
      Self.LineColor := LineColor;
      Self.Max := Max;
      Self.Min := Min;
      Self.ScrollGrid := ScrollGrid;
      Self.ShowGrid := ShowGrid;
      Self.StepSize := StepSize;
    end;
end;

procedure TSCCustomHistoryGraph.Clear;
begin
  FList.Clear;
  Invalidate;
end;

constructor TSCCustomHistoryGraph.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csOpaque, csReplicatable];
  SetBounds(Left, Top, 244, 64);
  DoubleBuffered := True;

  BlendColor := False;
  Border := sccb3DLowered;
  ParentColor := False;
  Color := clBlack;
  ClickFocus := False;

  FList := TList.Create;

  FCacheSize := 0;
  FGridColor := $00004000;
  FGridStep := 6;
  FLineColor := clLime;
  FMax := 100;
  FMin := 0;
  FScrollGrid := True;
  FShowGrid := True;
  FStepSize := 2;

  UpdateCacheSize;
end;

procedure TSCCustomHistoryGraph.CreateWnd;
begin
  inherited CreateWnd;
  UpdateCacheSize;
end;

destructor TSCCustomHistoryGraph.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TSCCustomHistoryGraph.DrawGraph;
var
  CR: TRect;
  C: TColor;
  Sp, P: TPoint;
  I, H, Range: Integer;
begin
  if FList.Count > 2 then
  begin
    CR := ClientRect;

    H := CR.Bottom - CR.Top;
    Range := FMax - FMin;

    if (Range > 0) and (H > 0) then
    begin
      C := FLineColor;
      if C = clNone then C := clLime;

      with Canvas do
      begin
        Pen.Style := psSolid;
        Pen.Width := 1;
        Pen.Color := C;
      end;

      Sp := CR.BottomRight;

      for I := FList.Count-1 downto 0 do
      begin
        P.x := CR.Right - (FList.Count-1 - I)*FStepSize;
        P.y := Integer(FList[I]);

        if P.y < FMin then
          P.y := FMin
        else if P.y > FMax then
          P.y := FMax;

        P.y := Round(H*(P.y / Range));

        if I < FList.Count-1 then
          with Canvas do
          begin
            MoveTo(Sp.x, Sp.y);
            LineTo(P.x, P.y);
          end;

        Sp := P;
        if P.x < CR.Left then
          Exit;

        if I = 0 then
          with Canvas do
          begin
            MoveTo(P.x, P.y);
            LineTo(P.x, CR.Bottom);
          end;
      end;
    end;
  end;  
end;

procedure TSCCustomHistoryGraph.DrawGrid;
var
  CR: TRect;
  C: TColor;
  Offset, I, Gs, K: Integer;
begin
  if FShowGrid then
  begin
    CR := ClientRect;

    C := FGridColor;
    if C = clNone then C := $00004000;

    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Width := 1;
      Pen.Color := C;
    end;

    Gs := FGridStep*FStepSize;

    Offset := 0;
    if FScrollGrid and (FList.Count > 0) then
    begin
      Offset := (FList.Count - 1)*FStepSize;
      Offset := Offset mod Gs;

      if Offset < 0 then Offset := 0;
    end;

    K := ((CR.Right - CR.Left) div Gs) + 1;
    for I := 0 to K do
      with Canvas do
      begin
        MoveTo(CR.Right - I*Gs - Offset, CR.Top);
        LineTo(CR.Right - I*Gs - Offset, CR.Bottom);
      end;

    K := ((CR.Bottom - CR.Top) div Gs) + 1;
    for I := 1 to K do
      with Canvas do
      begin
        MoveTo(CR.Left, CR.Bottom - I*Gs);
        LineTo(CR.Right, CR.Bottom - I*Gs);
      end;
  end;    
end;

function TSCCustomHistoryGraph.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomHistoryGraph.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCHistGraphBorderProps;
end;

function TSCCustomHistoryGraph.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSCCustomHistoryGraph.GetItem(Index: Integer): Integer;
begin
  Result := Integer(FList[Index]);
end;

procedure TSCCustomHistoryGraph.Loaded;
begin
  inherited Loaded;
  UpdateCacheSize;
end;

procedure TSCCustomHistoryGraph.Paint;
var
  C: TColor;
  CR: TRect;
begin
  C := Self.Color;
  if C = clNone then C := clBlack;

  CR := ClientRect;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := C;

    FillRect(CR);
  end;

  if Transparent then PaintParentOn(Canvas);
  DrawPicture(Canvas);

  DrawGrid;
  DrawGraph;
end;

procedure TSCCustomHistoryGraph.Resize;
begin
  UpdateCacheSize;
  inherited Resize;
end;

procedure TSCCustomHistoryGraph.SetGridColor(Value: TColor);
begin
  if FGridColor <> Value then
  begin
    FGridColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomHistoryGraph.SetGridStep(Value: Integer);
begin
  if FGridStep <> Value then
  begin
    FGridStep := Value;
    Invalidate;
  end;
end;

procedure TSCCustomHistoryGraph.SetLineColor(Value: TColor);
begin
  if FLineColor <> Value then
  begin
    FLineColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomHistoryGraph.SetMax(Value: Integer);
begin
  if FMax <> Value then
  begin
    FMax := Value;
    if FMin < FMax then FMin := FMax;

    Invalidate;
  end;
end;

procedure TSCCustomHistoryGraph.SetMin(Value: Integer);
begin
  if FMin <> Value then
  begin
    FMin := Value;
    if FMax < FMin then FMax := FMin;

    Invalidate;
  end;
end;

procedure TSCCustomHistoryGraph.SetScrollGrid(Value: Boolean);
begin
  if FScrollGrid <> Value then
  begin
    FScrollGrid := Value;
    Invalidate;
  end;
end;

procedure TSCCustomHistoryGraph.SetShowGrid(Value: Boolean);
begin
  if FShowGrid <> Value then
  begin
    FShowGrid := Value;
    Invalidate;
  end;
end;

procedure TSCCustomHistoryGraph.SetStepSize(Value: Integer);
begin
  if Value < 1 then Value := 1;

  if FStepSize <> Value then
  begin
    FStepSize := Value;
    UpdateCacheSize;
    Invalidate;
  end;
end;

function TSCCustomHistoryGraph.TrimList: Boolean;
var
  Cs, Cnt: Integer;
begin
  Cs := FCacheSize;
  if Cs < 10 then Cs := 10;

  Cnt := FList.Count;
  while FList.Count > Cs do
    FList.Delete(0);

  Result := Cnt <> FList.Count;  
  if Result then Invalidate;
end;

procedure TSCCustomHistoryGraph.UpdateCacheSize;
var
  CR: TRect;
begin
  CR := ClientRect;
  FCacheSize := ((CR.Right - CR.Left) div FStepSize) + 5;
end;

{ TSCSwitchBorderProps }

constructor TSCSwitchBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccb3DLowered;
end;

{ TSCCustomSwitch }

procedure TSCCustomSwitch.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomSwitch then
    with TSCCustomSwitch(Source) do
    begin
      Self.ButtonColor := ButtonColor;
      Self.ColorOn := ColorOn;
      Self.ColorOff := ColorOff;
      Self.LightIndent := LightIndent;
      Self.Orientation := Orientation;
      Self.Min := Min;
      Self.Max := Max;
      Self.Value := Value;
      Self.ShowLines := ShowLines;
      Self.ShowLights := ShowLights;
    end;
end;

function TSCCustomSwitch.CanSetUserValue(var Value: Integer): Boolean;
begin
  Result := True;
end;

function TSCCustomSwitch.CanSetValue(var Value: Integer): Boolean;
begin
  Result := True;
  if Value < FMin then
    Value := FMin
  else if Value > FMax then
    Value := FMax;
end;

procedure TSCCustomSwitch.CMMouseEnter(var Message: TMessage);
var
  CR: TRect;
  P: TPoint;
  Hot: Boolean;
begin
  if FLeftClicked and FSliderClicked and not IsDesigning then
  begin
    GetCursorPos(P);
    P := ScreenToClient(P);

    Hot := FSliderIsHot;

    CR := ClientRect;
    FSliderIsHot := PtOnSlider(P) or
      (FLeftClicked and FSliderClicked and PtInRect(CR, P));

    if Hot <> FSliderIsHot then
      Invalidate;
  end;

  inherited;
end;

procedure TSCCustomSwitch.CMMouseLeave(var Message: TMessage);
var
  Hot: Boolean;
begin
  if FLeftClicked and FSliderClicked and not IsDesigning then
  begin
    Hot := FSliderIsHot;
    FSliderIsHot := False;

    if Hot <> FSliderIsHot then
      Invalidate;
  end;
  
  inherited;
end;

constructor TSCCustomSwitch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csOpaque, csReplicatable];
  SetBounds(Left, Top, 28, 60);
  DoubleBuffered := True;

  Border := sccb3DLowered;
  BlendColor := False;
  ParentColor := False;
  Color := clBlack;

  Indent := 1;
  Spacing := 1;

  FButtonColor := clBtnFace;
  FColorOn := clLime;
  FColorOff := $00004000;
  FOrientation := scoVertical;
  FMin := 0;
  FMax := 1;
  FValue := 0;
  FShowLines := True;
  FShowLights := True;
end;

function TSCCustomSwitch.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomSwitch.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCSwitchBorderProps;
end;

procedure TSCCustomSwitch.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  ProcessTrackKey(Key);
end;

procedure TSCCustomSwitch.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if not (Ord(Key) in [VK_HOME, VK_END]) then
    ProcessTrackKey(Ord(Key));
end;

procedure TSCCustomSwitch.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Ps, P1, P2: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if CanGetFocus and Focused then
  begin
    P1 := NormalizeValue(FValue);

    FSliderIsHot := False;
    FLeftClicked := Button = mbLeft;

    FSliderIsHot := PtOnSlider(Point(X, Y));
    FSliderClicked := FSliderIsHot;

    P2 := ValueAtPos(X, Y);
    if CanSetUserValue(P2) then
      SetValue(P2);

    Ps := NormalizeValue(FValue);

    if (P1 <> Ps) or (FLeftClicked and FSliderClicked) then
      Invalidate;
  end;
end;

procedure TSCCustomSwitch.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  CR: TRect;
  Hot: Boolean;
  Ps, P1, P2: Integer;
begin
  Hot := FSliderIsHot;

  CR := ClientRect;
  FSliderIsHot := PtOnSlider(Point(X, Y)) or
    (FLeftClicked and FSliderClicked and PtInRect(CR, Point(X, Y)));

  P1 := NormalizeValue(FValue);
  if FLeftClicked then
  begin
    P2 := ValueAtPos(X, Y);
    if CanSetUserValue(P2) then
      SetValue(P2);
  end;

  Ps := NormalizeValue(FValue);

  if (P1 <> Ps) or (FLeftClicked and
    FSliderClicked and (Hot <> FSliderIsHot)) then
    Invalidate;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomSwitch.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Clicked: Boolean;
  Ps, P1, P2: Integer;
begin
  Clicked := FLeftClicked and FSliderClicked;

  FSliderClicked := False;
  FSliderIsHot := PtOnSlider(Point(X, Y));

  P1 := NormalizeValue(FValue);
  if FLeftClicked then
  begin
    FLeftClicked := False;

    P2 := ValueAtPos(X, Y);
    if CanSetUserValue(P2) then
      SetValue(P2);
  end;

  Ps := NormalizeValue(FValue);

  if (P1 <> Ps) or Clicked then
    Invalidate;

  inherited MouseUp(Button, Shift, X, Y);
end;

function TSCCustomSwitch.NormalizeValue(Value: Integer): Integer;
begin
  Result := Value;
  if Result < FMin then Result := FMin;
  if Result > FMax then Result := FMax;
end;

procedure TSCCustomSwitch.Paint;
var
  Cl: TColor;
  CR, R, R2: TRect;
  I, J, Range, S, C, W, V, Lc: Integer;
begin
  Cl := Self.Color;
  if Cl = clNone then Cl := clBlack;

  CR := ClientRect;
  
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Cl;

    FillRect(CR);
  end;

  if Transparent then PaintParentOn(Canvas);
  DrawPicture(Canvas);

  InflateRect(CR, -Indent, -Indent);
  if IsRectEmpty(CR) then Exit;

  Range := FMax - FMin;
  if Range <= 0 then
  begin
    Cl := FButtonColor;
    if Cl = clNone then Cl := clBtnFace;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      FillRect(CR);
    end;

    if FShowLines then
    begin
      R2 := R;
      InflateRect(R2, -4, -4);

      if not IsRectEmpty(R2) then
      begin
        if FOrientation = scoHorizontal then
        begin
          if R2.Bottom - R2.Top > 2 then
          begin
            Lc := (R2.Right - R2.Left) div 3;
            if Lc > 4 then Lc := 4;

            Inc(R2.Left, (R2.Right - R2.Left - (3*Lc - 1)) div 2);
            R2.Right := R2.Left + 2;

            for I := 1 to Lc do
            begin
              scFrame3D(Canvas, R2, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0);

              InflateRect(R2, 1, 1);
              OffsetRect(R2, 3, 0);
            end;
          end;
        end else
        if R2.Right - R2.Left > 2 then
        begin
          Lc := (R2.Bottom - R2.Top) div 3;
          if Lc > 4 then Lc := 4;

          Inc(R2.Top, (R2.Bottom - R2.Top - (3*Lc - 1)) div 2);
          R2.Bottom := R2.Top + 2;

          for I := 1 to Lc do
          begin
            scFrame3D(Canvas, R2, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0);

            InflateRect(R2, 1, 1);
            OffsetRect(R2, 0, 3);
          end;
        end;
      end;
    end;

    R2 := CR;
    scFrame3D(Canvas, R2, GetBtnHighlightOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
    scFrame3D(Canvas, R2, Cl, GetBtnShadowOf(Cl), 1, 0);

    Exit;
  end;

  V := FValue - FMin;
  if V < 0 then Exit;

  if FOrientation = scoHorizontal then
  begin
    W := CR.Right - CR.Left - Range*Spacing;
    if W <= 0 then Exit;

    S := W div (Range + 1);
    C := W - S*(Range + 1);

    if (S = 0) and (C = 0) then
      Exit;

    R := CR;
    R.Right := R.Left;

    for I := 0 to Range do
    begin
      R.Right := R.Left + S;
      if C > 0 then
      begin
        Dec(C);
        Inc(R.Right);
      end;

      if not IsRectEmpty(R) then
      begin
        if I = V then
        begin
          Cl := FButtonColor;
          if Cl = clNone then Cl := clBtnFace;

          with Canvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := Cl;

            FillRect(R);
          end;

          if FShowLines then
          begin
            R2 := R;
            InflateRect(R2, -4, -4);

            if not IsRectEmpty(R2) and (R2.Bottom - R2.Top > 2) then
            begin
              if FLeftClicked and FSliderClicked and FSliderIsHot then
                OffsetRect(R2, 1, 1);

              Lc := (R2.Right - R2.Left) div 3;
              if Lc > 4 then Lc := 4;

              Inc(R2.Left, (R2.Right - R2.Left - (3*Lc - 1)) div 2);
              R2.Right := R2.Left + 2;

              for J := 1 to Lc do
              begin
                scFrame3D(Canvas, R2, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0);

                InflateRect(R2, 1, 1);
                OffsetRect(R2, 3, 0);
              end;
            end;
          end;

          R2 := R;
          if FLeftClicked and FSliderClicked and FSliderIsHot then
            scFrame3D(Canvas, R2, Get3DDkShadowOf(Cl), Get3DDkShadowOf(Cl), 1, 0)
          else begin
            scFrame3D(Canvas, R2, GetBtnHighlightOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
            scFrame3D(Canvas, R2, Cl, GetBtnShadowOf(Cl), 1, 0);
          end;
        end else
        if FShowLights then
        begin
          Cl := FColorOn;
          if I > V then Cl := FColorOff;

          R2 := R;
          InflateRect(R2, -FLightIndent, -FLightIndent);

          if (Cl <> clNone) and not IsRectEmpty(R2) then
            with Canvas do
            begin
              Brush.Style := bsSolid;
              Brush.Color := Cl;

              FillRect(R2);
            end;
        end;
      end;

      Inc(R.Right, Spacing);
      R.Left := R.Right;
    end;
  end else
  begin
    W := CR.Bottom - CR.Top - Range*Spacing;
    if W <= 0 then Exit;

    S := W div (Range + 1);
    C := W - S*(Range + 1);

    if (S = 0) and (C = 0) then
      Exit;

    R := CR;
    R.Top := R.Bottom;

    for I := 0 to Range do
    begin
      R.Top := R.Bottom - S;
      if C > 0 then
      begin
        Dec(C);
        Dec(R.Top);
      end;

      if not IsRectEmpty(R) then
      begin
        if I = V then
        begin
          Cl := FButtonColor;
          if Cl = clNone then Cl := clBtnFace;

          with Canvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := Cl;

            FillRect(R);
          end;

          if FShowLines then
          begin
            R2 := R;
            InflateRect(R2, -4, -4);

            if not IsRectEmpty(R2) and (R2.Right - R2.Left > 2) then
            begin
              if FLeftClicked and FSliderClicked and FSliderIsHot then
                OffsetRect(R2, 1, 1);

              Lc := (R2.Bottom - R2.Top) div 3;
              if Lc > 4 then Lc := 4;

              Inc(R2.Top, (R2.Bottom - R2.Top - (3*Lc - 1)) div 2);
              R2.Bottom := R2.Top + 2;

              for J := 1 to Lc do
              begin
                scFrame3D(Canvas, R2, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0);

                InflateRect(R2, 1, 1);
                OffsetRect(R2, 0, 3);
              end;
            end;
          end;

          R2 := R;
          if FLeftClicked and FSliderClicked and FSliderIsHot then
            scFrame3D(Canvas, R2, Get3DDkShadowOf(Cl), Get3DDkShadowOf(Cl), 1, 0)
          else begin
            scFrame3D(Canvas, R2, GetBtnHighlightOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
            scFrame3D(Canvas, R2, Cl, GetBtnShadowOf(Cl), 1, 0);
          end;  
        end else
        if FShowLights then
        begin
          Cl := FColorOn;
          if I > V then Cl := FColorOff;

          R2 := R;
          InflateRect(R2, -FLightIndent, -FLightIndent);

          if (Cl <> clNone) and not IsRectEmpty(R2) then
            with Canvas do
            begin
              Brush.Style := bsSolid;
              Brush.Color := Cl;

              FillRect(R2);
            end;
        end;
      end;

      Dec(R.Top, Spacing);
      R.Bottom := R.Top;
    end;
  end;
end;

procedure TSCCustomSwitch.ProcessTrackKey(Key: Word);
var
  P1, P2: Integer;
begin
  P1 := NormalizeValue(FValue);
  P2 := P1;

  case Key of
    VK_LEFT, VK_DOWN,
    VK_PRIOR, Ord('-'):
      Dec(P2);
    VK_RIGHT, VK_UP,
    VK_NEXT, Ord('+'):
      Inc(P2);
    VK_HOME:
      P2 := FMin;
    VK_END:
      P2 := FMax;
  end;

  if CanSetUserValue(P2) and (P1 <> P2) then
    SetValue(P2);
end;

function TSCCustomSwitch.PtOnSlider(P: TPoint): Boolean;
var
  CR, R: TRect;
  I, Range, S, C, W, V: Integer;
begin
  Result := False;
  
  Range := FMax - FMin;
  if Range <= 0 then Exit;

  V := FValue - FMin;
  if V < 0 then Exit;

  CR := ClientRect;
  InflateRect(CR, -Indent, -Indent);

  if IsRectEmpty(CR) then Exit;

  if FOrientation = scoHorizontal then
  begin
    W := CR.Right - CR.Left - Range*Spacing;
    if W <= 0 then Exit;

    S := W div (Range + 1);
    C := W - S*(Range + 1);

    if (S = 0) and (C = 0) then
      Exit;

    R := CR;
    R.Right := R.Left;

    for I := 0 to V do
    begin
      R.Right := R.Left + S;
      if C > 0 then
      begin
        Dec(C);
        Inc(R.Right);
      end;

      if (I = V) and not IsRectEmpty(R) then
      begin
        Result := PtInRect(R, P);
        Exit;
      end;

      Inc(R.Right, Spacing);
      R.Left := R.Right;
    end;
  end else
  begin
    W := CR.Bottom - CR.Top - Range*Spacing;
    if W <= 0 then Exit;

    S := W div (Range + 1);
    C := W - S*(Range + 1);

    if (S = 0) and (C = 0) then
      Exit;

    R := CR;
    R.Top := R.Bottom;

    for I := 0 to Range do
    begin
      R.Top := R.Bottom - S;
      if C > 0 then
      begin
        Dec(C);
        Dec(R.Top);
      end;

      if (I = V) and not IsRectEmpty(R) then
      begin
        Result := PtInRect(R, P);
        Exit;
      end;

      Dec(R.Top, Spacing);
      R.Bottom := R.Top;
    end;
  end;
end;

procedure TSCCustomSwitch.SetButtonColor(Value: TColor);
begin
  if FButtonColor <> Value then
  begin
    FButtonColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomSwitch.SetColorOff(Value: TColor);
begin
  if FColorOff <> Value then
  begin
    FColorOff := Value;
    Invalidate;
  end;
end;

procedure TSCCustomSwitch.SetColorOn(Value: TColor);
begin
  if FColorOn <> Value then
  begin
    FColorOn := Value;
    Invalidate;
  end;
end;

procedure TSCCustomSwitch.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;
  inherited SetIndent(Value);
end;

procedure TSCCustomSwitch.SetLightIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if FLightIndent <> Value then
  begin
    FLightIndent := Value;
    Invalidate;
  end;
end;

procedure TSCCustomSwitch.SetMax(Value: Integer);
begin
  if FMax <> Value then
  begin
    FMax := Value;
    if FMin > FMax then FMin := FMax;
    if FValue > FMax then SetValue(FMax);

    Invalidate;
  end;
end;

procedure TSCCustomSwitch.SetMin(Value: Integer);
begin
  if FMin <> Value then
  begin
    FMin := Value;
    if FMax < FMin then FMax := FMin;
    if FValue < FMin then SetValue(FMin);

    Invalidate;
  end;
end;

procedure TSCCustomSwitch.SetOrientation(Value: TSCOrientation);
var
  R: TRect;
  H: Integer;
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;

    if HandleAllocated and not (IsLoading or IsReading) then
    begin
      R := BoundsRect;

      Dec(R.Right, R.Left);
      Dec(R.Bottom, R.Top);

      H := R.Bottom;
      R.Bottom := R.Right;
      R.Right := H;

      SetBounds(R.Left, R.Top, R.Right, R.Bottom);
    end;

    Invalidate;
  end;
end;

procedure TSCCustomSwitch.SetShowLights(Value: Boolean);
begin
  if FShowLights <> Value then
  begin
    FShowLights := Value;
    Invalidate;
  end;
end;

procedure TSCCustomSwitch.SetShowLines(Value: Boolean);
begin
  if FShowLines <> Value then
  begin
    FShowLines := Value;
    Invalidate;
  end;
end;

procedure TSCCustomSwitch.SetValue(Value: Integer);
begin
  Value := NormalizeValue(Value);

  if FValue <> Value then
  begin
    FValue := Value;
    Invalidate;

    Change;
  end;
end;

procedure TSCCustomSwitch.StopTracking;
begin
  inherited StopTracking;

  if HandleAllocated and (GetCapture <> Handle) then
  begin
    FLeftClicked := False;
    FSliderClicked := False;
    FSliderIsHot := False;

    Invalidate;
  end;
end;

function TSCCustomSwitch.ValueAtPos(X, Y: Integer): Integer;
var
  CR: TRect;
  I, Range, S, C, L, W: Integer;
begin
  Result := FValue;

  CR := ClientRect;

  Range := FMax - FMin;
  if Range <= 0 then
  begin
    Result := FMin;
    Exit;
  end;

  InflateRect(CR, -Indent, -Indent);
  if IsRectEmpty(CR) then
  begin
    Result := FMin;
    Exit;
  end;

  if FOrientation = scoHorizontal then
  begin
    W := CR.Right - CR.Left - Range*Spacing;

    if W <= 0 then
      Result := FMin
    else if X < CR.Left then
      Result := FMin
    else if X >= CR.Right then
      Result := FMax
    else begin
      S := W div (Range + 1);
      C := W - S*(Range + 1);

      if (S = 0) and (C = 0) then
        Result := FMin
      else begin
        L := CR.Left;
        for I := 0 to Range do
        begin
          Inc(L, S);

          if X < L then
          begin
            Result := FMin + I;
            Exit;
          end;

          Inc(L, Spacing);

          if C > 0 then
          begin
            Dec(C);
            Inc(L);
          end;
        end;
      end;
    end;
  end else
  begin
    W := CR.Bottom - CR.Top - Range*Spacing;

    if W <= 0 then
      Result := FMin
    else if Y > CR.Bottom then
      Result := FMin
    else if Y <= CR.Top then
      Result := FMax
    else begin
      S := W div (Range + 1);
      C := W - S*(Range + 1);

      if (S = 0) and (C = 0) then
        Result := FMin
      else begin
        L := CR.Bottom;

        for I := 0 to Range do
        begin
          Dec(L, S);

          if Y > L then
          begin
            Result := FMin + I;
            Exit;
          end;

          Dec(L, Spacing);

          if C > 0 then
          begin
            Dec(C);
            Dec(L);
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomSwitch.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTALLKEYS or DLGC_WANTARROWS;
end;

procedure TSCCustomSwitch.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if Message.WheelDelta < 0 then
    SetValue(FValue + 1)
  else
  if Message.WheelDelta > 0 then
    SetValue(FValue - 1);
end;

{ TSCCustomRunningLeds }

procedure TSCCustomRunningLeds.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomRunningLeds then
  begin
    with TSCCustomRunningLeds(Source) do
    begin
      Self.ForeColor := ForeColor;
      Self.Interval := Interval;
      Self.Percentage := Percentage;
      Self.RunningEnabled := RunningEnabled;
      Self.Slice := Slice;
      Self.Step := Step;
      Self.Style := Style;
    end;
  end;
end;

constructor TSCCustomRunningLeds.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(Left, Top, 146, 18);
  ControlStyle := [csCaptureMouse, csClickEvents, csOpaque,
    csReplicatable];

  Border := sccbLowered;
  BlendColor := False;
  ParentColor := False;
  Color := clWindow;
  ClickFocus := False;

  FForeColor := clGreen;
  FPercentage := 30;
  FSlice := 10;
  FStep := 8;
  FStyle := scrlMetal;
  FInterval := 100;
end;

procedure TSCCustomRunningLeds.CreateWnd;
var
  Offset: Integer;
  Running: Boolean;
begin
  Running := FRunningEnabled;

  inherited CreateWnd;
  Invalidate;

  Offset := FOffsetX;

  if Running and (not FRunning or not FRunningEnabled) then
  begin
    FRunningEnabled := True;
    StartRun(Offset);
  end;
end;

function TSCCustomRunningLeds.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomRunningLeds.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCRunningLedsBorderProps;
end;

procedure TSCCustomRunningLeds.Loaded;
begin
  inherited Loaded;
  Invalidate;

  if FRunning then StartRun(0);
end;

procedure TSCCustomRunningLeds.Paint;
var
  CR, R, MaxR, R2, R3: TRect;
  DoSlicing: Boolean;
  C, C1, C2, C3: TColor;
  I, St, P, Ps, P2, W: Integer;
begin
  CR := GetClientRect;
  if IsRectEmpty(CR) then Exit;

  C := Self.Color;
  if C = clNone then C := clWindow;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := C;

    FillRect(CR);
  end;

  if Transparent then PaintParentOn(Canvas);
  DrawPicture(Canvas);

  MaxR := CR;
  InflateRect(MaxR, -Indent, -Indent);

  if IsRectEmpty(MaxR) then Exit;

  R := MaxR;

  C3 := FForeColor;
  if C3 = clNone then C3 := C;

  W := R.Right - R.Left;

  Ps := Round((W * FPercentage) / 100);

  case FStyle of
    scrlClassic, scrlRaised:
    begin
      R := MaxR;
      R.Right := R.Left + Ps;

      OffsetRect(R, FOffsetX, 0);

      if R.Right > MaxR.Right then
        R.Right := MaxR.Right;

      if not IsRectEmpty(R) then
      begin
        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C3;

          FillRect(R);
        end;

        if FStyle = scrlRaised then
        begin
          C1 := SCCommon.scBlendColor(C3, 64);
          C2 := SCCommon.scBlendColor(C3, -64);

          scFrame3D(Canvas, R, C1, C2, 1, 0);
        end;
      end;
    end;
    scrl3D, scrlGradient3D:
    begin
      R := MaxR;
      R.Right := R.Left + Ps;

      OffsetRect(R, FOffsetX, 0);

      if R.Right > MaxR.Right then
        R.Right := MaxR.Right;

      if not IsRectEmpty(R) then
      begin
        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C3;

          FillRect(R);
        end;

        R2 := R;
        R2.Bottom := R2.Top + Round((R2.Bottom - R2.Top) / 2);

        if not IsRectEmpty(R2) then
        begin
          C1 := SCCommon.scBlendColor(C3, 64);
          scDrawGradient(Canvas, R2, scgTopToBottom, C1, C3);

          R2 := R;
          R2.Top := R2.Bottom - Round((R2.Bottom - R2.Top) / 2);

          C2 := SCCommon.scBlendColor(C3, -64);
          scDrawGradient(Canvas, R2, scgTopToBottom, C3, C2);

          if FStyle = scrl3D then
          begin
            R2 := R;
            scFrame3D(Canvas, R2, C1, C2, 1, 0);

            C1 := SCCommon.scBlendColor(C3, 48);
            C2 := SCCommon.scBlendColor(C3, -48);

            scFrame3D(Canvas, R2, C1, C2, 1, 0);
          end;
        end;
      end;
    end;
    scrlSliced:
    begin
      P := Ps;

      DoSlicing := (FSlice > 0) and (FSlice < P);

      if DoSlicing and (Ps < W) then
      begin
        P2 := P mod (FSlice + 2);
        if P2 > 0 then
        begin
          Dec(P, P2);
          if Round(P2/(FSlice + 2)) = 1 then
            Inc(P, (FSlice + 2));
        end;
      end;

      if P <= 0 then Exit;

      R := MaxR;
      R.Right := R.Left + P;

      OffsetRect(R, FOffsetX, 0);

      if R.Right > MaxR.Right then
        R.Right := MaxR.Right;

      if not IsRectEmpty(R) then
      begin
        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C3;

          FillRect(R);

          Brush.Color := C;
          if DoSlicing then
          begin
            R2 := R;
            R2.Right := R2.Left + 2;

            St := P div (FSlice + 2);
            for I := 0 to St-1 do
            begin
              OffsetRect(R2, FSlice, 0);
              FillRect(R2);
              OffsetRect(R2, R2.Right - R2.Left, 0);
            end;
          end;
        end;
      end;
    end;
    scrlXP, scrlMetal:
    begin
      R := MaxR;
      InflateRect(R, -2, -1);

      W := R.Right - R.Left;
      if W <= 0 then Exit;

      Ps := Round((W * FPercentage) / 100);
      P := Ps;

      DoSlicing := (FSlice > 0) and (FSlice < P);

      if DoSlicing and (Ps < W) then
      begin
        P2 := P mod (FSlice + 2);
        if P2 > 0 then
        begin
          Dec(P, P2);
          if Round(P2/(FSlice + 2)) = 1 then
            Inc(P, (FSlice + 2));
        end;
      end;

      if P <= 0 then Exit;

      R := MaxR;
      InflateRect(R, -2, -1);

      R.Right := R.Left + P;

      OffsetRect(R, FOffsetX, 0);

      if R.Right > MaxR.Right then
        R.Right := MaxR.Right;

      if not IsRectEmpty(R) then
      begin
        with Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C3;

          FillRect(R);
        end;

        R2 := R;
        R2.Bottom := R2.Top + ((R2.Bottom - R2.Top) div 2);

        if not IsRectEmpty(R2) then
        begin
          C := SCCommon.scBlendColor(C3, 128);
          scDrawGradient(Canvas, R2, scgTopToBottom, C, C3);

          R2 := R;
          R2.Top := R2.Bottom - ((R2.Bottom - R2.Top) div 2);

          scDrawGradient(Canvas, R2, scgTopToBottom, C3, C);
        end;

        with Canvas do
        begin
          C := Self.Color;
          if C = clNone then C := clWindow;

          Brush.Color := C;

          if DoSlicing then
          begin
            Pen.Width := 1;
            Pen.Style := psSolid;
            Pen.Mode  := pmCopy;
            Pen.Color := C3;

            R2 := R;
            R2.Right := R2.Left + 2;

            R3 := R;
            R3.Right := R3.Left + FSlice;

            St := P div (FSlice + 2);
            for I := 0 to St-1 do
            begin
              OffsetRect(R2, FSlice, 0);

              Brush.Style := bsSolid;
              FillRect(R2);
              OffsetRect(R2, R2.Right - R2.Left, 0);

              if FStyle = scrlMetal then
              begin
                Brush.Style := bsClear;
                Rectangle(R3.Left, R3.Top, R3.Right, R3.Bottom);

                OffsetRect(R3, FSlice + 2, 0);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomRunningLeds.ResetInterval;
var
  Offset: Integer;
  Running: Boolean;
begin
  Offset := FOffsetX;
  Running := FRunningEnabled;

  StopRun;

  if Running then
  begin
    FRunningEnabled := True;
    StartRun(Offset);
  end;
end;

procedure TSCCustomRunningLeds.SetForeColor(Value: TColor);
begin
  if FForeColor <> Value then
  begin
    FForeColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomRunningLeds.SetInterval(Value: Integer);
begin
  if Value < 10 then Value := 10;
  if FInterval <> Value then
  begin
    FInterval := Value;
    ResetInterval;
  end;
end;

procedure TSCCustomRunningLeds.SetPercentage(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if Value > 80 then Value := 80;

  if FPercentage <> Value then
  begin
    FPercentage := Value;

    if FRunningEnabled then
    begin
      StopRun;
      StartRun(FOffsetX);
    end;  

    Invalidate;
  end;
end;

procedure TSCCustomRunningLeds.SetRunningEnabled(Value: Boolean);
begin
  if FRunningEnabled <> Value then
  begin
    FRunningEnabled := Value;

    if FRunningEnabled then
      StartRun(0)
    else StopRun;
  end;
end;

procedure TSCCustomRunningLeds.SetSlice(Value: Integer);
begin
  if Value < 2 then Value := 2;
  if FSlice <> Value then
  begin
    FSlice := Value;
    Invalidate;
  end;
end;

procedure TSCCustomRunningLeds.SetStep(Value: Integer);
begin
  if Value < 2 then Value := 2;
  if FStep <> Value then
  begin
    FStep := Value;
    Invalidate;
  end;
end;

procedure TSCCustomRunningLeds.SetStyle(Value: TSCRunningLedsStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TSCCustomRunningLeds.StartRun(Offset: Integer);
var
  CR: TRect;
  W: Integer;
begin
  if HandleAllocated and FRunningEnabled then
  begin
    FOffsetX := 0;

    {$IFDEF SC_DELPHI6_UP}
    if IsDesigning then
      Exit;
    {$ENDIF}

    if not Enabled then
    begin
      StopRun;
      Exit;
    end;

    FOffsetX := Offset;
    
    if FOffsetX > 0 then
    begin
      CR := ClientRect;
      W := (CR.Right - CR.Left) - 2;

      if (W > 0) and (FOffsetX > W) then
        FOffsetX := 0;
    end;

    if FOffsetX < 0 then FOffsetX := 0;

    if FRunningTimer <> -1 then KillTimer(Handle, FRunningTimer);

    FRunningTimer := SetTimer(Handle, SC_RUNNING_TIMERID, FInterval, nil);
    FRunningEnabled := FRunningTimer <> -1;

    FRunning := FRunningTimer <> -1;

    Invalidate;
  end;
end;

procedure TSCCustomRunningLeds.StopRun;
begin
  FRunning := False;
  FRunningEnabled := False;

  FOffsetX := 0;
  if FRunningTimer <> -1 then
  begin
    if HandleAllocated then KillTimer(Handle, FRunningTimer);

    FRunningTimer := -1;
    Invalidate;
  end;
end;

procedure TSCCustomRunningLeds.WMTimer(var Message: TWMTimer);
var
  CR: TRect;
  W: Integer;
begin
  inherited;

  if HandleAllocated and FRunningEnabled and (Message.TimerID = SC_RUNNING_TIMERID) then
  begin
    if not Enabled then
    begin
      StopRun;
      Exit;
    end;

    Inc(FOffsetX, FStep);

    if FOffsetX > 0 then
    begin
      CR := ClientRect;
      W := (CR.Right - CR.Left) - 2;

      if (W > 0) and (FOffsetX > W) then
        FOffsetX := 0;
    end;

    if FOffsetX < 0 then FOffsetX := 0;

    if FRunningTimer <> -1 then KillTimer(Handle, FRunningTimer);

    FRunningTimer := SetTimer(Handle, SC_RUNNING_TIMERID, FInterval, nil);
    FRunningEnabled := FRunningTimer <> -1;

    FRunning := FRunningTimer <> -1;
    Invalidate;
  end;
end;

{ TSCRunningLedsBorderProps }

constructor TSCRunningLedsBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccbLowered;
end;

{$I SCVerRec.inc}

end.
