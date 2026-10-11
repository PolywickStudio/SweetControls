{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCStdControls;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, SCConsts, SCResStrs, SCCommon, SCControl, Clipbrd, Menus;

type
  TSCButtonBase = class;

  TSCButtonActionLink = class(TWinControlActionLink)
  protected
    FClient: TSCButtonBase;
    procedure AssignClient(AClient: TObject); override;
    function  IsCheckedLinked: Boolean; override;
    procedure SetChecked(Value: Boolean); override;
  end;

  TSCButtonActionLinkClass = class of TSCButtonActionLink;

  TSCButtonBase = class(TSCCustomControl)
  private
    FDblClicked: Boolean;
    FEndEllipsis: Boolean;
    procedure SetEndEllipsis(Value: Boolean);
    function  IsCheckedStored: Boolean;
  protected
    procedure CaptureChanged(Captured: Boolean); override;

    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    function  GetActionLinkClass: TControlActionLinkClass; override;

    function  GetChecked: Boolean; virtual;
    procedure SetChecked(Value: Boolean); virtual;

    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property DblClicked: Boolean read FDblClicked;
    property Checked: Boolean read GetChecked write SetChecked stored IsCheckedStored default False;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default True;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TSCCustomButton = class(TSCButtonBase)
  private
    FAllowAllUp: Boolean;
    FArrowColor: TColor;
    FCancel: Boolean;
    FCenter: Boolean;
    FDefault: Boolean;
    FDown: Boolean;
    FDropdownMenu: TPopupMenu;
    FGradient: TSCButtonGradient;
    FGroupIndex: Integer;
    FHighlightColor: TColor;
    FHottrackColor: TColor;
    FLayout: TSCButtonLayout;
    FPopupArrow: Boolean;
    FRepeatClick: Boolean;
    FRepeatInterval: Integer;
    FRoundColor: TColor;
    FRounded: Boolean;
    FRoundWithParentColor: Boolean;
    FShowCaption: Boolean;
    FShowFocus: Boolean;
    FStyle: TSCButtonStyle;
    FModalResult: TModalResult;
    FMultiline: Boolean;
    FFontColor: TColor;
    FPopArrowColor: TColor;
    FInnerRect: TRect;
    FImgOffset: TPoint;
    FTxtOffset: TPoint;
    FPopOffset: TPoint;
    FSpaceDown: Boolean;
    FMousePressed: Boolean;
    FRepeating: Boolean;
    FRepeatTimer: Integer;
    FOnStateChange: TNotifyEvent;
    procedure SetAllowAllUp(Value: Boolean);
    procedure SetArrowColor(Value: TColor);
    procedure SetCenter(Value: Boolean);
    procedure SetDefault(Value: Boolean);
    procedure SetDown(Value: Boolean);
    procedure SetDropdownMenu(Value: TPopupMenu);
    procedure SetGradient(Value: TSCButtonGradient);
    procedure SetGroupIndex(Value: Integer);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHottrackColor(Value: TColor);
    procedure SetLayout(Value: TSCButtonLayout);
    procedure SetPopupArrow(Value: Boolean);
    procedure SetRepeatClick(Value: Boolean);
    procedure SetRepeatInterval(Value: Integer);
    procedure SetRoundColor(Value: TColor);
    procedure SetRounded(Value: Boolean);
    procedure SetRoundWithParentColor(Value: Boolean);
    procedure SetShowCaption(Value: Boolean);
    procedure SetShowFocus(Value: Boolean);
    procedure SetStyle(Value: TSCButtonStyle);
    procedure SetMultiline(Value: Boolean);

    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;

    procedure CMButtonPressed(var Message: TMessage); message CM_BUTTONPRESSED;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;

    procedure CMParentColorChanged(var Message: TMessage); message CM_PARENTCOLORCHANGED;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;

    function  CanDoUp: Boolean;
    procedure UpdateGroupDown;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CreateWnd; override;
    procedure Paint; override;

    function  PopupDropdownMenu: Boolean;
    function  CheckMenuDropdown: Boolean;

    procedure StopTracking; override;
    procedure MouseInControlChanged; override;
    procedure SpacingChanged; override;
    procedure EnabledChanged; override;

    procedure StartRepeat;
    procedure StopRepeat;

    function  CanRepeat: Boolean;
    function  Repeating: Boolean;
    function  RepeatPaused: Boolean;
    procedure PauseRepeat;
    procedure ResumeRepeat;

    function  GetGradientShadow(AColor: TColor): TColor;
    function  GetGradientDark(AColor: TColor): TColor;
    function  GetGradientLight(AColor: TColor): TColor;
    function  GetGradientExDark(AColor: TColor): TColor;
    function  GetGradientExLight(AColor: TColor): TColor;
    function  GetGradientPeal(AColor: TColor): TColor;
    function  GetGradientPreDark(AColor: TColor): TColor;
    function  GetGradientPreLight(AColor: TColor): TColor;
    function  GetGradientHighLight(AColor: TColor): TColor;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;

    procedure DrawPopupArrow(R: TRect; AColor: TColor = clNone);
    procedure DrawImageAndText(var R: TRect; CR: TRect; FontColor: TColor = clNone);

    procedure DoDrawCorel;
    procedure DoDrawFlatMacSpeed;
    procedure DoDrawHower;
    procedure DoDrawMacSpeed;
    procedure DoDrawNew;
    procedure DoDrawOfficeXP;
    procedure DoDrawRaisedShadow;
    procedure DoDrawSpeed;
    procedure DoDrawWin2k;
    procedure DoDrawXP;
    procedure DoDrawOffice12;
    procedure DoDrawOffice2003;
    procedure DoDrawDarkling;
    procedure DoDrawMetal;

    property AllowAllUp: Boolean read FAllowAllUp write SetAllowAllUp default False;
    property ArrowColor: TColor read FArrowColor write SetArrowColor default clBtnText;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Center: Boolean read FCenter write SetCenter default True;
    property Color default clBtnFace;
    property Default: Boolean read FDefault write SetDefault default False;
    property Gradient: TSCButtonGradient read FGradient write SetGradient default scbgTopToBottom;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property Down: Boolean read FDown write SetDown default False;
    property DropdownMenu: TPopupMenu read FDropdownMenu write SetDropdownMenu;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default SC_HighlightColor;
    property HottrackColor: TColor read FHottrackColor write SetHottrackColor default SC_HottrackColor;
    property Layout: TSCButtonLayout read FLayout write SetLayout default scblLeft;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property Multiline: Boolean read FMultiline write SetMultiline default False;
    property ParentColor default False;
    property PopupArrow: Boolean read FPopupArrow write SetPopupArrow default False;
    property RepeatClick: Boolean read FRepeatClick write SetRepeatClick default False;
    property RepeatInterval: Integer read FRepeatInterval write SetRepeatInterval default 50;
    property RoundColor: TColor read FRoundColor write SetRoundColor default clBtnFace;
    property Rounded: Boolean read FRounded write SetRounded default True;
    property RoundWithParentColor: Boolean read FRoundWithParentColor write SetRoundWithParentColor default True;
    property ShowCaption: Boolean read FShowCaption write SetShowCaption default True;
    property ShowFocus: Boolean read FShowFocus write SetShowFocus default True;
    property Style: TSCButtonStyle read FStyle write SetStyle default scbsWin2k;
    property TabStop default True;
    property OnStateChange: TNotifyEvent read FOnStateChange write FOnStateChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Click; override;
    function  UseRightToLeftAlignment: Boolean; override;
  end;

  TSCButton = class(TSCCustomButton)
  published
    property Action;
    property Align;
    property AllowAllUp;
    property Anchors;
    property ArrowColor;
    property BiDiMode;
    property Cancel;
    property Caption;
    property Center;
    property Color;
    property Constraints;
    property Cursor;
    property Default;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropdownMenu;
    property Enabled;
    property EndEllipsis;
    property Font;
    property Gradient;
    property GroupIndex;
    property Down;
    property HighlightColor;
    property HottrackColor;
    property Images;
    property ImageIndex;
    property Indent;
    property Layout;
    property ModalResult;
    property Multiline;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupArrow;
    property RepeatClick;
    property RepeatInterval;
    property RoundColor;
    property Rounded;
    property RoundWithParentColor;
    property ShowCaption;
    property ShowFocus;
    property ShowHint;
    property Spacing;
    property Style;
    property TabOrder;
    property TabStop;
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
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnStateChange;
  end;

  TSCCustomSpinButton = class;

  TSCSpinButtonColors = class(TPersistent)
  private
    FOwner: TSCCustomSpinButton;
    FActiveColor: TColor;
    FDefaultColor: TColor;
    FDisabledColor: TColor;
    FDownColor: TColor;
    FHotColor: TColor;
    procedure SetActiveColor(Value: TColor);
    procedure SetDefaultColor(Value: TColor);
    procedure SetDisabledColor(Value: TColor);
    procedure SetDownColor(Value: TColor);
    procedure SetHotColor(Value: TColor);
  protected
    function  GetOwner: TPersistent; override;
    procedure DoChange;
  public
    constructor Create(AOwner: TSCCustomSpinButton); virtual;
    procedure Assign(Source: TPersistent); override;
    property Owner: TSCCustomSpinButton read FOwner;
  published
    property ActiveColor: TColor read FActiveColor write SetActiveColor default clBtnFace;
    property DefaultColor: TColor read FDefaultColor write SetDefaultColor default clBtnFace;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clBtnFace;
    property DownColor: TColor read FDownColor write SetDownColor default clBtnFace;
    property HotColor: TColor read FHotColor write SetHotColor default clBtnFace;
  end;

  TSCSpinButtonIconColors = class(TSCSpinButtonColors)
  public
    constructor Create(AOwner: TSCCustomSpinButton); override;
  published
    property ActiveColor default clBtnText;
    property DefaultColor default clBtnText;
    property DisabledColor default clBtnShadow;
    property DownColor default clBtnText;
    property HotColor default clBtnText;
  end;

  TSCSpinButtonOrient = (scsoHorizontal, scsoVertical);

  TSCSpinButtonPart = (scsbpNone, scsbpUpButton, scsbpDownButton);

  TSCSpinDirection = (scsdUpDown, scsdLeftRight);

  TSCSpinButtonStyle = (scsbsOfficeXP, scsbsWindows, scsbsWindowsEx,
    scsbsWindowsFlat, scsbsWindowsFlatEx, scsbsMac, scsbsMetal, scsbsWindowsXP);

  TSCCustomSpinButton = class(TSCButtonBase)
  private
    FButtonColors: TSCSpinButtonColors;
    FDirection: TSCSpinDirection;
    FIconColors: TSCSpinButtonColors;
    FIncrement: Integer;
    FInterval: Integer;
    FMax: Integer;
    FMin: Integer;
    FOrientation: TSCSpinButtonOrient;
    FPosition: Integer;
    FStyle: TSCSpinButtonStyle;
    FPressedPart: TSCSpinButtonPart;
    FHotPart: TSCSpinButtonPart;
    FScrolling: Boolean;
    FScrollTimer: Integer;
    FWrap: Boolean;
    procedure SetButtonColors(Value: TSCSpinButtonColors);
    procedure SetDirection(Value: TSCSpinDirection);
    procedure SetIconColors(Value: TSCSpinButtonColors);
    procedure SetIncrement(Value: Integer);
    procedure SetInterval(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure SetMin(Value: Integer);
    procedure SetOrientation(Value: TSCSpinButtonOrient);
    procedure SetPosition(Value: Integer);
    procedure SetStyle(Value: TSCSpinButtonStyle);

    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;

    procedure StartScrolling;
    procedure ScrollControl;
    procedure StopScrolling;
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure Click; override;
    procedure DblClick; override;

    procedure StopTracking; override;
    procedure MouseInControlChanged; override;
    function  GetBlendValue: Word; override;
    procedure EnabledChanged; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure ProcessScrollKey(var Key: Word; IsKeyPress: Boolean);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    function  GetUpBtnColor: TColor;
    function  GetUpBtnIconColor: TColor;
    function  GetDownBtnColor: TColor;
    function  GetDownBtnIconColor: TColor;

    function  IsUpButtonDefault: Boolean;
    function  IsDownButtonDefault: Boolean;

    procedure DoDrawXPBtn(C: TCanvas; R: TRect; Cl: TColor; IsDown, IsHot: Boolean); virtual;
    procedure DoDrawUpButton(C: TCanvas; R: TRect); virtual;
    procedure DoDrawDownButton(C: TCanvas; R: TRect); virtual;

    function  GetUpButtonRect: TRect; dynamic;
    function  GetDownButtonRect: TRect; dynamic;

    property ButtonColors: TSCSpinButtonColors read FButtonColors write SetButtonColors;
    property ClickFocus default False;
    property Direction: TSCSpinDirection read FDirection write SetDirection default scsdUpDown;
    property IconColors: TSCSpinButtonColors read FIconColors write SetIconColors;
    property Increment: Integer read FIncrement write SetIncrement default 1;
    property Interval: Integer read FInterval write SetInterval default 100;
    property Max: Integer read FMax write SetMax default 100;
    property Min: Integer read FMin write SetMin default 0;
    property Orientation: TSCSpinButtonOrient read FOrientation write SetOrientation default scsoVertical;
    property Position: Integer read FPosition write SetPosition default 0;
    property Style: TSCSpinButtonStyle read FStyle write SetStyle default scsbsWindows;
    property Wrap: Boolean read FWrap write FWrap default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  CanScroll(AsUp: Boolean): Boolean;
    function  Scrolling: Boolean;
    function  ScrollPaused: Boolean;
    procedure PauseScrolling;
    procedure ResumeScrolling;

    function  GetPartAtPos(X, Y: Integer): TSCSpinButtonPart;
  end;

  TSCSpinButton = class(TSCCustomSpinButton)
  published
    property Align;
    property Anchors;
    property BorderProps;
    property ButtonColors;
    property ClickFocus;
    property Constraints;
    property Cursor;
    property Direction;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property IconColors;
    property Increment;
    property Interval;
    property Max;
    property Min;
    property Orientation;
    property ParentShowHint;
    property Position;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property Visible;
    property Wrap;
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

  TSCCheckboxStyle = (sccsCorel, sccsFlat, sccsFlatFrame, sccsFlatEx,
    sccsFlatDouble, sccsImage, sccsMac, sccsMetal, sccsOfficeXP, sccsWin2k, sccsXP);

  TSCCheckboxLayout = (scclBottom, scclMiddle, scclTop);

  TSCCustomCheckbox = class(TSCButtonBase)
  private
    FAlignment: TLeftRight;
    FAllowGrayed: Boolean;
    FBoxCheckedColor: TColor;
    FBoxDisabledColor: TColor;
    FBoxFrameColor: TColor;
    FBoxGrayedColor: TColor;
    FBoxToggleColor: TColor;
    FBoxUncheckedColor: TColor;
    FGradient: TSCGradient;
    FGradientEnd: TColor;
    FHighlightColor: TColor;
    FHottrackColor: TColor;
    FImageChecked: TImageIndex;
    FImageDisabled: TImageIndex;
    FImageGrayed: TImageIndex;
    FImageToggle: TImageIndex;
    FImageUnchecked: TImageIndex;
    FImageMark: TImageIndex;
    FImageMarkDisabled: TImageIndex;
    FImageMarkGrayed: TImageIndex;
    FLayout: TSCCheckboxLayout;
    FMarkColor: TColor;
    FMarkDisabledColor: TColor;
    FMarkGrayedColor: TColor;
    FMultiline: Boolean;
    FShowCheckMark: Boolean;
    FShowFocus: Boolean;
    FState: TSCCheckState;
    FStyle: TSCCheckboxStyle;
    FInnerRect: TRect;
    FOfficeMarkColor: TColor;
    FSpaceDown: Boolean;
    FStateChanging: Integer;
    FMousePressed: Boolean;
    procedure SetAlignment(Value: TLeftRight);
    procedure SetAllowGrayed(Value: Boolean);
    procedure SetBoxCheckedColor(Value: TColor);
    procedure SetBoxDisabledColor(Value: TColor);
    procedure SetBoxFrameColor(Value: TColor);
    procedure SetBoxGrayedColor(Value: TColor);
    procedure SetBoxToggleColor(Value: TColor);
    procedure SetBoxUncheckedColor(Value: TColor);
    procedure SetGradient(Value: TSCGradient);
    procedure SetGradientEnd(Value: TColor);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHottrackColor(Value: TColor);
    procedure SetImageChecked(Value: TImageIndex);
    procedure SetImageDisabled(Value: TImageIndex);
    procedure SetImageGrayed(Value: TImageIndex);
    procedure SetImageToggle(Value: TImageIndex);
    procedure SetImageUnchecked(Value: TImageIndex);
    procedure SetImageMark(Value: TImageIndex);
    procedure SetImageMarkDisabled(Value: TImageIndex);
    procedure SetImageMarkGrayed(Value: TImageIndex);
    procedure SetLayout(Value: TSCCheckboxLayout);
    procedure SetMarkColor(Value: TColor);
    procedure SetMarkDisabledColor(Value: TColor);
    procedure SetMarkGrayedColor(Value: TColor);
    procedure SetMultiline(Value: Boolean);
    procedure SetShowCheckMark(Value: Boolean);
    procedure SetShowFocus(Value: Boolean);
    procedure SetState(Value: TSCCheckState);
    procedure SetStyle(Value: TSCCheckboxStyle);

    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;

    function  GetBoxWidth: Integer;
    function  GetBoxHeight: Integer;
    function  GetBoxFaceColor: TColor;
    function  SwitchGrayed: Boolean;
  protected
    procedure Paint; override;
    procedure Click; override;

    procedure TransparentChanged; override;
    procedure StopTracking; override;
    procedure FocusChanged; override;
    procedure MouseInControlChanged; override;
    procedure SpacingChanged; override;
    procedure EnabledChanged; override;

    function  GetAdjustedRect(NewWidth, NewHeight: Integer): TRect; override;
    procedure AdjustBounds; override;
    function  GetBlendValue: Word; override;

    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;

    function  CanUpdateState(Value: TSCCheckState): TSCCheckState; virtual;
    function  GetChecked: Boolean; override;
    procedure SetChecked(Value: Boolean); override;

    function  InToggle: Boolean; virtual;
    procedure Toggle; virtual;
    function  SwitchState(S: TSCCheckState): TSCCheckState; virtual;
    function  GetDrawState: TSCCheckState; virtual;
    procedure StateChanged; virtual;

    procedure DoDrawMark(R: TRect; AColor: TColor = clNone);
    procedure DoDrawText(var R: TRect; CalcRect: Boolean = False);

    procedure DoDrawCorelCb;
    procedure DoDrawFlatCb;
    procedure DoDrawImageCb;
    procedure DoDrawMacCb;
    procedure DoDrawOfficeXPCb;
    procedure DoDrawWin2kCb;
    procedure DoDrawXPCb;
    procedure DoDrawMetalCb;

    property Alignment: TLeftRight read FAlignment write SetAlignment default taRightJustify;
    property AllowGrayed: Boolean read FAllowGrayed write SetAllowGrayed default False;
    property State: TSCCheckState read FState write SetState default sccbUnchecked;
    property BoxCheckedColor: TColor read FBoxCheckedColor write SetBoxCheckedColor default clWindow;
    property BoxDisabledColor: TColor read FBoxDisabledColor write SetBoxDisabledColor default clBtnFace;
    property BoxFrameColor: TColor read FBoxFrameColor write SetBoxFrameColor default clBtnShadow;
    property BoxGrayedColor: TColor read FBoxGrayedColor write SetBoxGrayedColor default clBtnFace;
    property BoxToggleColor: TColor read FBoxToggleColor write SetBoxToggleColor default clBtnFace;
    property BoxUncheckedColor: TColor read FBoxUncheckedColor write SetBoxUncheckedColor default clWindow;
    property Checked default False;
    property Color nodefault;
    property Gradient: TSCGradient read FGradient write SetGradient default scgNone;
    property GradientEnd: TColor read FGradientEnd write SetGradientEnd default clBlue;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default SC_HighlightColor;
    property HottrackColor: TColor read FHottrackColor write SetHottrackColor default SC_HottrackColor;
    property ImageChecked: TImageIndex read FImageChecked write SetImageChecked default -1;
    property ImageDisabled: TImageIndex read FImageDisabled write SetImageDisabled default -1;
    property ImageGrayed: TImageIndex read FImageGrayed write SetImageGrayed default -1;
    property ImageToggle: TImageIndex read FImageToggle write SetImageToggle default -1;
    property ImageUnchecked: TImageIndex read FImageUnchecked write SetImageUnchecked default -1;
    property ImageMark: TImageIndex read FImageMark write SetImageMark default -1;
    property ImageMarkDisabled: TImageIndex read FImageMarkDisabled write SetImageMarkDisabled default -1;
    property ImageMarkGrayed: TImageIndex read FImageMarkGrayed write SetImageMarkGrayed default -1;
    property Layout: TSCCheckboxLayout read FLayout write SetLayout default scclMiddle;
    property MarkColor: TColor read FMarkColor write SetMarkColor default clWindowText;
    property MarkDisabledColor: TColor read FMarkDisabledColor write SetMarkDisabledColor default clGrayText;
    property MarkGrayedColor: TColor read FMarkGrayedColor write SetMarkGrayedColor default clGrayText;
    property Multiline: Boolean read FMultiline write SetMultiline default False;
    property ParentColor default True;
    property ShowCheckMark: Boolean read FShowCheckMark write SetShowCheckMark default True;
    property ShowFocus: Boolean read FShowFocus write SetShowFocus default True;
    property Style: TSCCheckboxStyle read FStyle write SetStyle default sccsWin2k;
    property TabStop default True;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCCheckbox = class(TSCCustomCheckbox)
  published
    property Action;
    property Align;
    property Alignment;
    property AllowGrayed;
    property Anchors;
    property AutoSize;
    property State;
    property BiDiMode;
    property BorderProps;
    property BoxCheckedColor;
    property BoxDisabledColor;
    property BoxFrameColor;
    property BoxGrayedColor;
    property BoxToggleColor;
    property BoxUncheckedColor;
    property Caption;
    property Checked;
    property Color;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndEllipsis;
    property Font;
    property Gradient;
    property GradientEnd;
    property HighlightColor;
    property HottrackColor;
    property Images;
    property ImageChecked;
    property ImageDisabled;
    property ImageGrayed;
    property ImageToggle;
    property ImageUnchecked;
    property ImageMark;
    property ImageMarkGrayed;
    property Indent;
    property Layout;
    property MarkColor;
    property MarkDisabledColor;
    property MarkGrayedColor;
    property Multiline;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property ShowCheckMark;
    property ShowFocus;
    property ShowHint;
    property Spacing;
    property Style;
    property TabOrder;
    property TabStop;
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
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCRadioStyle = (scrsCorel, scrsFlat, scrsFlatFrame, scrsImage, scrsMac,
    scrsMetal, scrsOfficeXP, scrsWin2k, scrsXP);

  TSCRadioLayout = (scrlBottom, scrlMiddle, scrlTop);

  TSCCustomRadioButton = class(TSCButtonBase)
  private
    FAlignment: TLeftRight;
    FAsCheckbox: Boolean;
    FBoxCheckedColor: TColor;
    FBoxDisabledColor: TColor;
    FBoxFrameColor: TColor;
    FBoxToggleColor: TColor;
    FBoxUncheckedColor: TColor;
    FChecked: Boolean;
    FGradient: TSCGradient;
    FGradientEnd: TColor;
    FHighlightColor: TColor;
    FHottrackColor: TColor;
    FImageChecked: TImageIndex;
    FImageDisabled: TImageIndex;
    FImageToggle: TImageIndex;
    FImageUnchecked: TImageIndex;
    FImageMark: TImageIndex;
    FImageMarkDisabled: TImageIndex;
    FLayout: TSCRadioLayout;
    FMarkColor: TColor;
    FMarkDisabledColor: TColor;
    FMultiline: Boolean;
    FShowCheckMark: Boolean;
    FShowFocus: Boolean;
    FStyle: TSCRadioStyle;
    FMouseKeysDown: Boolean;
    FInnerRect: TRect;
    FOfficeMarkColor: TColor;
    FSpaceDown: Boolean;
    FMousePressed: Boolean;
    procedure SetAlignment(Value: TLeftRight);
    procedure SetAsCheckbox(Value: Boolean);
    procedure SetBoxCheckedColor(Value: TColor);
    procedure SetBoxDisabledColor(Value: TColor);
    procedure SetBoxFrameColor(Value: TColor);
    procedure SetBoxToggleColor(Value: TColor);
    procedure SetBoxUncheckedColor(Value: TColor);
    procedure SetGradient(Value: TSCGradient);
    procedure SetGradientEnd(Value: TColor);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHottrackColor(Value: TColor);
    procedure SetImageChecked(Value: TImageIndex);
    procedure SetImageDisabled(Value: TImageIndex);
    procedure SetImageToggle(Value: TImageIndex);
    procedure SetImageUnchecked(Value: TImageIndex);
    procedure SetImageMark(Value: TImageIndex);
    procedure SetImageMarkDisabled(Value: TImageIndex);
    procedure SetLayout(Value: TSCRadioLayout);
    procedure SetMarkColor(Value: TColor);
    procedure SetMarkDisabledColor(Value: TColor);
    procedure SetMultiline(Value: Boolean);
    procedure SetShowCheckMark(Value: Boolean);
    procedure SetShowFocus(Value: Boolean);
    procedure SetStyle(Value: TSCRadioStyle);

    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;

    function  GetBoxWidth: Integer;
    function  GetBoxHeight: Integer;
    function  GetBoxFaceColor: TColor;
  protected
    procedure Paint; override;

    procedure FocusChanged; override;
    procedure TransparentChanged; override;
    procedure StopTracking; override;
    procedure MouseInControlChanged; override;
    procedure SpacingChanged; override;
    procedure EnabledChanged; override;

    function  GetChecked: Boolean; override;
    procedure SetChecked(Value: Boolean); override;

    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;

    function  GetAdjustedRect(NewWidth, NewHeight: Integer): TRect; override;
    procedure AdjustBounds; override;
    function  GetBlendValue: Word; override;

    function  InToggle: Boolean; virtual;
    procedure Toggle; virtual;

    procedure GenerateOctPoints(Rc: TRect; RoundBy: Integer; var Pts: array of TPoint);
    procedure DrawXPRb(X, Y: Integer; FrmColor, InnerColor, OutterColor, TrackColor,
      CheckColor: TColor);
    procedure DrawWin2kRb(X, Y: Integer; InnerColor, CheckColor: TColor);
    procedure DrawFlatRb(X, Y: Integer; FrmColor, InnerColor, CheckColor: TColor);
    procedure DrawFlatFrameRb(X, Y: Integer; InnerColor, CheckColor: TColor);
    procedure DrawMacRb(X, Y: Integer; FrmColor, InnerColor, OutterColor,
      CheckColor: TColor; Pressed: Boolean);

    procedure DoDrawMark(R: TRect; AColor: TColor = clNone);
    procedure DoDrawText(var R: TRect; CalcRect: Boolean = False);
    procedure DoDrawAsRadio;

    procedure DoDrawCorelCb;
    procedure DoDrawFlatCb;
    procedure DoDrawImageCb;
    procedure DoDrawMacCb;
    procedure DoDrawOfficeXPCb;
    procedure DoDrawWin2kCb;
    procedure DoDrawXPCb;
    procedure DoDrawMetalCb;

    property Alignment: TLeftRight read FAlignment write SetAlignment default taRightJustify;
    property AsCheckbox: Boolean read FAsCheckbox write SetAsCheckbox default False;
    property BoxCheckedColor: TColor read FBoxCheckedColor write SetBoxCheckedColor default clWindow;
    property BoxDisabledColor: TColor read FBoxDisabledColor write SetBoxDisabledColor default clBtnFace;
    property BoxFrameColor: TColor read FBoxFrameColor write SetBoxFrameColor default clBtnShadow;
    property BoxToggleColor: TColor read FBoxToggleColor write SetBoxToggleColor default clBtnFace;
    property BoxUncheckedColor: TColor read FBoxUncheckedColor write SetBoxUncheckedColor default clWindow;
    property Checked default False;
    property Color nodefault;
    property Gradient: TSCGradient read FGradient write SetGradient default scgNone;
    property GradientEnd: TColor read FGradientEnd write SetGradientEnd default clBlue;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default SC_HighlightColor;
    property HottrackColor: TColor read FHottrackColor write SetHottrackColor default SC_HottrackColor;
    property ImageChecked: TImageIndex read FImageChecked write SetImageChecked default -1;
    property ImageDisabled: TImageIndex read FImageDisabled write SetImageDisabled default -1;
    property ImageToggle: TImageIndex read FImageToggle write SetImageToggle default -1;
    property ImageUnchecked: TImageIndex read FImageUnchecked write SetImageUnchecked default -1;
    property ImageMark: TImageIndex read FImageMark write SetImageMark default -1;
    property ImageMarkDisabled: TImageIndex read FImageMarkDisabled write SetImageMarkDisabled default -1;
    property Layout: TSCRadioLayout read FLayout write SetLayout default scrlMiddle;
    property MarkColor: TColor read FMarkColor write SetMarkColor default clWindowText;
    property MarkDisabledColor: TColor read FMarkDisabledColor write SetMarkDisabledColor default clGrayText;
    property Multiline: Boolean read FMultiline write SetMultiline default False;
    property ParentBiDiMode;
    property ParentColor default True;
    property ShowCheckMark: Boolean read FShowCheckMark write SetShowCheckMark default True;
    property ShowFocus: Boolean read FShowFocus write SetShowFocus default True;
    property Style: TSCRadioStyle read FStyle write SetStyle default scrsWin2k;
    property TabStop default False;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCRadioButton = class(TSCCustomRadioButton)
  published
    property Action;
    property Align;
    property Alignment;
    property Anchors;
    property AsCheckbox;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property BoxCheckedColor;
    property BoxDisabledColor;
    property BoxFrameColor;
    property BoxToggleColor;
    property BoxUncheckedColor;
    property Caption;
    property Checked;
    property Color;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndEllipsis;
    property Font;
    property Gradient;
    property GradientEnd;
    property HighlightColor;
    property HottrackColor;
    property Images;
    property ImageChecked;
    property ImageDisabled;
    property ImageToggle;
    property ImageUnchecked;
    property ImageMark;
    property ImageMarkDisabled;
    property Indent;
    property Layout;
    property MarkColor;
    property MarkDisabledColor;
    property Multiline;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property ShowCheckMark;
    property ShowFocus;
    property ShowHint;
    property Spacing;
    property Style;
    property TabOrder;
    property TabStop;
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
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomLabel = class(TSCCustomControl)
  private
    FAlignment: TAlignment;
    FEllipsisMode: TSCEllipsis;
    FFocusControl: TWinControl;
    FGradient: TSCGradient;
    FGradientEnd: TColor;
    FGradientMid: TColor;
    FGradientUsesMid: Boolean;
    FHighlightColor: TColor;
    FHotImage: TImageIndex;
    FHottrack: Boolean;
    FHottrackColor: TColor;
    FHotUnderline: Boolean;
    FImageLayout: TSCImageLayout;
    FLayout: TSCLayout;
    FMultiline: Boolean;
    FRotation: TSCRotation;
    FShowAccelChar: Boolean;
    FShowFocus: Boolean;
    FMousePressed: Boolean;
    FIndentVert: Integer;
    procedure SetAlignment(Value: TAlignment);
    procedure SetEllipsisMode(Value: TSCEllipsis);
    procedure SetFocusControl(Value: TWinControl);
    procedure SetGradient(Value: TSCGradient);
    procedure SetGradientEnd(Value: TColor);
    procedure SetGradientMid(Value: TColor);
    procedure SetGradientUsesMid(Value: Boolean);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHotImage(Value: TImageIndex);
    procedure SetHottrack(Value: Boolean);
    procedure SetHottrackColor(Value: TColor);
    procedure SetHotUnderline(Value: Boolean);
    procedure SetImageLayout(Value: TSCImageLayout);
    function  GetIndentHorz: Integer;
    procedure SetIndentHorz(Value: Integer);
    procedure SetIndentVert(Value: Integer);
    procedure SetLayout(Value: TSCLayout);
    procedure SetMultiline(Value: Boolean);
    procedure SetRotation(Value: TSCRotation);
    procedure SetShowAccelChar(Value: Boolean);
    procedure SetShowFocus(Value: Boolean);
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  protected
    procedure Paint; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function  CanAlignText(var Value: TAlignment): Boolean; dynamic;

    procedure FocusChanged; override;
    procedure TransparentChanged; override;
    procedure StopTracking; override;
    procedure MouseInControlChanged; override;

    function  GetBlendValue: Word; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    function  GetAdjustedRect(NewWidth, NewHeight: Integer): TRect; override;
    procedure AdjustBounds; override;

    function  GetAlignment: TAlignment; virtual;
    function  GetLabelText: string; virtual;

    function  GetImageRect: TRect; override;
    function  GetTextRect: TRect; override;

    procedure DoDrawText(var R: TRect; CalcRect: Boolean = False);

    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Color nodefault;
    property EllipsisMode: TSCEllipsis read FEllipsisMode write SetEllipsisMode default scelNone;
    property FocusControl: TWinControl read FFocusControl write SetFocusControl;
    property Gradient: TSCGradient read FGradient write SetGradient default scgNone;
    property GradientEnd: TColor read FGradientEnd write SetGradientEnd default clBlue;
    property GradientMid: TColor read FGradientMid write SetGradientMid default clNavy;
    property GradientUsesMid: Boolean read FGradientUsesMid write SetGradientUsesMid default False;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default clPurple;
    property HotImage: TImageIndex read FHotImage write SetHotImage default -1;
    property Hottrack: Boolean read FHottrack write SetHottrack default True;
    property HottrackColor: TColor read FHottrackColor write SetHottrackColor default clRed;
    property HotUnderline: Boolean read FHotUnderline write SetHotUnderline default True;
    property ImageLayout: TSCImageLayout read FImageLayout write SetImageLayout default scilLeft;
    property IndentHorz: Integer read GetIndentHorz write SetIndentHorz default 0;
    property IndentVert: Integer read FIndentVert write SetIndentVert default 0;
    property Layout: TSCLayout read FLayout write SetLayout default sclaMiddle;
    property Multiline: Boolean read FMultiline write SetMultiline default False;
    property ParentColor default True;
    property Rotation: TSCRotation read FRotation write SetRotation default scroTop;
    property ShowAccelChar: Boolean read FShowAccelChar write SetShowAccelChar default True;
    property ShowFocus: Boolean read FShowFocus write SetShowFocus default True;
    property TabStop default False;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCLabel = class(TSCCustomLabel)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property Caption;
    property ClickFocus;
    property Color;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EllipsisMode;
    property Enabled;
    property FocusControl;
    property Font;
    property HighlightColor;
    property HotImage;
    property Hottrack;
    property HottrackColor;
    property HotUnderline;
    property Gradient;
    property GradientEnd;
    property GradientMid;
    property GradientUsesMid;
    property ImageIndex;
    property ImageLayout;
    property Images;
    property IndentHorz;
    property IndentVert;
    property Layout;
    property Multiline;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property Rotation;
    property ShowAccelChar;
    property ShowFocus;
    property ShowHint;
    property Spacing;
    property TabOrder;
    property TabStop;
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
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCPanelPictureProps = class(TSCPictureProps);

  TSCCustomPanel = class(TSCCustomSizableControl)
  private
    FAlignment: TAlignment;
    FAutoSizeDocking: Boolean;
    FBevel: TSCControlBevel;
    FBevelColor: TColor;
    FBevelEdges: TSCBorderEdges;
    FBevelWidth: TSCBevelWidth;
    FGradient: TSCGradient;
    FGradientEnd: TColor;
    FGradientMid: TColor;
    FGradientUsesMid: Boolean;
    FLayout: TSCLayout;
    FMultiline: Boolean;
    FRotation: TSCRotation;
    FImageLayout: TSCImageLayout;
    FIndentVert: Integer;
    FEllipsisMode: TSCEllipsis;
    procedure SetAlignment(Value: TAlignment);
    procedure SetBevel(Value: TSCControlBevel);
    procedure SetBevelColor(Value: TColor);
    procedure SetBevelEdges(Value: TSCBorderEdges);
    procedure SetBevelWidth(Value: TSCBevelWidth);
    procedure SetEllipsisMode(Value: TSCEllipsis);
    procedure SetGradient(Value: TSCGradient);
    procedure SetGradientEnd(Value: TColor);
    procedure SetGradientMid(Value: TColor);
    procedure SetGradientUsesMid(Value: Boolean);
    procedure SetImageLayout(Value: TSCImageLayout);
    function  GetIndentHorz: Integer;
    procedure SetIndentHorz(Value: Integer);
    procedure SetIndentVert(Value: Integer);
    procedure SetLayout(Value: TSCLayout);
    procedure SetMultiline(Value: Boolean);
    procedure SetRotation(Value: TSCRotation);

    procedure CMDockClient(var Message: TCMDockClient); message CM_DOCKCLIENT;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure AdjustBevelRect(var Rect: TRect); virtual;
    procedure AdjustClientRect(var Rect: TRect); override;

    procedure AdjustBounds; override;
    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;

    function  HasGradient: Boolean;

    procedure TransparentChanged; override;
    function  GetBlendValue: Word; override;

    function  GetBevelSize: Integer;
    function  GetPicturePropsClass: TSCCustomPicturePropsClass; override;

    function  GetAlignment: TAlignment; virtual;
    function  GetPanelText: string; virtual;

    function  GetImageRect: TRect; override;
    function  GetTextRect: TRect; override;

    procedure DoDrawText(var R: TRect; CalcRect: Boolean = False);

    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Bevel: TSCControlBevel read FBevel write SetBevel default sccbNone;
    property BevelColor: TColor read FBevelColor write SetBevelColor default clNone;
    property BevelEdges: TSCBorderEdges read FBevelEdges write SetBevelEdges default SCAllBorderEdges;
    property BevelWidth: TSCBevelWidth read FBevelWidth write SetBevelWidth default 0;
    property EllipsisMode: TSCEllipsis read FEllipsisMode write SetEllipsisMode default scelNone;
    property Gradient: TSCGradient read FGradient write SetGradient default scgNone;
    property GradientEnd: TColor read FGradientEnd write SetGradientEnd default clNavy;
    property GradientMid: TColor read FGradientMid write SetGradientMid default clBlue;
    property GradientUsesMid: Boolean read FGradientUsesMid write SetGradientUsesMid default False;
    property ImageLayout: TSCImageLayout read FImageLayout write SetImageLayout default scilLeft;
    property IndentHorz: Integer read GetIndentHorz write SetIndentHorz default 0;
    property IndentVert: Integer read FIndentVert write SetIndentVert default 0;
    property Layout: TSCLayout read FLayout write SetLayout default sclaMiddle;
    property Multiline: Boolean read FMultiline write SetMultiline default False;
    property Rotation: TSCRotation read FRotation write SetRotation default scroTop;
    property TabStop default False;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCPanel = class(TSCCustomPanel)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property Bevel;
    property BevelColor;
    property BevelEdges;
    property BevelWidth;
    property BiDiMode;
    property BorderProps;
    property Caption;
    property ClickFocus;
    property Color;
    property Constraints;
    property Cursor;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Gradient;
    property GradientEnd;
    property GradientMid;
    property GradientUsesMid;
    property ImageIndex;
    property ImageLayout;
    property Images;
    property IndentHorz;
    property IndentVert;
    property Layout;
    property Multiline;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property Rotation;
    property ShowHint;
    property ShowSizeGrip;
    property StatusbarAlignment;
    property ShowStatusbar;
    property StatusbarColor;
    property StatusbarText;
    property Spacing;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseDockManager;
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
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCProgressStyle = (scps3D, scpsClassic, scpsGradient3D, scpsGradientFull,
    scpsGradientComplementary, scpsMetal, scpsOffice12, scpsRaised, scpsSliced,
    scpsSlicedGradient, scpsXP);

  TSCProgressBorderProps = class(TSCControlBorderProps)
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

  TSCCustomProgress = class(TSCCustomControl)
  private
    FMax: Integer;
    FMin: Integer;
    FPosition: Integer;
    FPercentage: Integer;
    FPositionColor: TColor;
    FPositionEndColor: TColor;
    FOrientation: TSCOrientation;
    FStyle: TSCProgressStyle;
    FSlice: Integer;
    FStep: Integer;
    procedure SetMax(Value: Integer);
    procedure SetMin(Value: Integer);
    procedure SetOrientation(Value: TSCOrientation);
    procedure SetPositionColor(Value: TColor);
    procedure SetPositionEndColor(Value: TColor);
    procedure SetPercentage(Value: Integer);
    procedure SetSlice(Value: Integer);
    procedure SetStyle(Value: TSCProgressStyle);
    function  CalculatePercentage: Boolean;
    function  CalculatePosition: Boolean;
  protected
    procedure CreateWnd; override;
    procedure Paint; override;
    procedure Loaded; override;

    function  NormalizePosition(Value: Integer): Integer;
    function  GetPosition: Integer; virtual;
    procedure SetPosition(Value: Integer); virtual;

    procedure DoChange; override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetBlendValue: Word; override;

    function  CanSetValue(var Value: LongInt): Boolean; virtual;

    procedure DoCustomDraw(ACanvas: TCanvas); virtual;
    procedure DoDrawHorizontal; virtual;
    procedure DoDrawVertical; virtual;

    function  GetGradientShadow(AColor: TColor): TColor;
    function  GetGradientDark(AColor: TColor): TColor;
    function  GetGradientLight(AColor: TColor): TColor;
    function  GetGradientExDark(AColor: TColor): TColor;
    function  GetGradientExLight(AColor: TColor): TColor;
    function  GetGradientPeal(AColor: TColor): TColor;
    function  GetGradientPreDark(AColor: TColor): TColor;
    function  GetGradientPreLight(AColor: TColor): TColor;
    function  GetGradientHighLight(AColor: TColor): TColor;

    property Color default clWindow;
    property Max: Integer read FMax write SetMax default 100;
    property Min: Integer read FMin write SetMin default 0;
    property Orientation: TSCOrientation read FOrientation write SetOrientation default scoHorizontal;
    property ParentColor default False;
    property Percentage: Integer read FPercentage write SetPercentage default 0;
    property Position: Integer read GetPosition write SetPosition default 0;
    property PositionColor: TColor read FPositionColor write SetPositionColor default clGreen;
    property PositionEndColor: TColor read FPositionEndColor write SetPositionEndColor default clAqua;
    property Slice: Integer read FSlice write SetSlice default 10;
    property Step: Integer read FStep write FStep default 10;
    property Style: TSCProgressStyle read FStyle write SetStyle default scpsClassic;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    procedure StepIt;
    procedure StepBy(Delta: Integer);
  end;

  TSCProgress = class(TSCCustomProgress)
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

  TSCCustomSlider = class;

  TSCSliderStyle = (scssMetal, scssNew, scssPSNew, scssWindows);

  TSCSliderProps = class(TPersistent)
  private
    FOwner: TSCCustomSlider;
    FColor: TColor;
    FFrameColor: TColor;
    FSize: Integer;
    FStyle: TSCSliderStyle;
    FVisible: Boolean;
    procedure SetColor(Value: TColor);
    procedure SetFrameColor(Value: TColor);
    procedure SetSize(Value: Integer);
    procedure SetStyle(Value: TSCSliderStyle);
    procedure SetVisible(Value: Boolean);
  protected
    procedure Changed;

    function GetOwner: TPersistent; override;
    property Slider: TSCCustomSlider read FOwner;
  public
    constructor Create(AOwner: TSCCustomSlider);
    procedure Assign(Source: TPersistent); override;
  published
    property Color: TColor read FColor write SetColor default clBtnFace;
    property FrameColor: TColor read FFrameColor write SetFrameColor default clGreen;
    property Size: Integer read FSize write SetSize default 8;
    property Style: TSCSliderStyle read FStyle write SetStyle default scssWindows;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TSCCustomSlider = class(TSCCustomProgress)
  private
    FPageSize: Integer;
    FSlider: TSCSliderProps;
    procedure SetSlider(Value: TSCSliderProps);

    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  protected
    procedure DoCustomDraw(ACanvas: TCanvas); override;
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
    property PositionColor default clHighlight;
    property Slider: TSCSliderProps read FSlider write SetSlider;
    property TabStop default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  end;

  TSCSlider = class(TSCCustomSlider)
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
    property PageSize;
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

  TSCGroupBoxBorderProps = class(TSCBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccbNone;
  end;

  TSCCustomGroupBox = class(TSCCustomControl)
  private
    FAlignment: TSCGroupBoxAlignment;
    FBevel: TSCControlBevel;
    FBevelColor: TColor;
    FBevelEdges: TSCBorderEdges;
    FBevelWidth: TSCBevelWidth;
    FCaptionBkColor: TColor;
    FCaptionBevel: TSCControlBevel;
    FCaptionBevelColor: TColor;
    FCaptionFont: TFont;
    FSpareColor: TColor;
    procedure SetAlignment(Value: TSCGroupBoxAlignment);
    procedure SetBevel(Value: TSCControlBevel);
    procedure SetBevelColor(Value: TColor);
    procedure SetBevelEdges(Value: TSCBorderEdges);
    procedure SetBevelWidth(Value: TSCBevelWidth);
    procedure SetCaptionBevel(Value: TSCControlBevel);
    procedure SetCaptionBevelColor(Value: TColor);
    procedure SetCaptionBkColor(Value: TColor);
    procedure SetCaptionFont(Value: TFont);
    procedure SetSpareColor(Value: TColor);

    procedure CaptionFontChanged(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;

    procedure AdjustBounds; override;

    procedure DoDrawBevel; virtual;
    procedure SetIndent(Value: Integer); override;

    function  GetBevelLineSize(Value: TSCControlBevel): Integer;
    function  GetBevelSize(IncludeLines: Boolean = True): Integer;
    procedure AdjustBevelRect(var Rect: TRect; IncludeLines: Boolean = True); virtual;
    procedure AdjustClientRect(var Rect: TRect); override;

    function  GetBevelRect: TRect;
    function  GetCaptionRect: TRect;
    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;

    property Alignment: TSCGroupBoxAlignment read FAlignment write SetAlignment default scgaTopLeft;
    property Bevel: TSCControlBevel read FBevel write SetBevel default sccbFlat;
    property BevelEdges: TSCBorderEdges read FBevelEdges write SetBevelEdges default SCAllBorderEdges;
    property BevelColor: TColor read FBevelColor write SetBevelColor default clNone;
    property BevelWidth: TSCBevelWidth read FBevelWidth write SetBevelWidth default 0;
    property Border default sccbNone;
    property CaptionBkColor: TColor read FCaptionBkColor write SetCaptionBkColor default clNone;
    property CaptionBevel: TSCControlBevel read FCaptionBevel write SetCaptionBevel default sccbNone;
    property CaptionBevelColor: TColor read FCaptionBevelColor write SetCaptionBevelColor default clNone;
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property ClickFocus default False;
    property Indent default 6;
    property SpareColor: TColor read FSpareColor write SetSpareColor default clNone;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCGroupBox = class(TSCCustomGroupBox)
  published
    property Align;
    property Alignment;
    property Anchors;
    property Bevel;
    property BevelEdges;
    property BevelColor;
    property BevelWidth;
    property BiDiMode;
    property BorderProps;
    property Caption;
    property CaptionBevel;
    property CaptionBevelColor;
    property CaptionBkColor;
    property CaptionFont;
    property ClickFocus;
    property Color;
    property Constraints;
    property Cursor;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Indent;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property ShowHint;
    property Spacing;
    property SpareColor;
    property TabOrder;
    property TabStop default False;
    property Transparent;
    property UseDockManager;
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

uses Consts, ActnList;

{ TSCCustomButton }

type
  TColoredControl = class(TControl);
  TSCFakeControl = class(TControl);

procedure TSCCustomButton.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomButton then
  begin
    with TSCCustomButton(Source) do
    begin
      Self.AllowAllUp := AllowAllUp;
      Self.ArrowColor := ArrowColor;
      Self.Cancel := Cancel;
      Self.Center := Center;
      Self.Default := Default;
      Self.Gradient := Gradient;
      Self.GroupIndex := GroupIndex;
      Self.Down := Down;
      Self.DropdownMenu := DropdownMenu;
      Self.HighlightColor := HighlightColor;
      Self.HottrackColor := HottrackColor;
      Self.Layout := Layout;
      Self.ModalResult := ModalResult;
      Self.Multiline := Multiline;
      Self.PopupArrow := PopupArrow;
      Self.RepeatClick := RepeatClick;
      Self.RepeatInterval := RepeatInterval;
      Self.RoundColor := RoundColor;
      Self.Rounded := Rounded;
      Self.RoundWithParentColor := RoundWithParentColor;
      Self.ShowCaption := ShowCaption;
      Self.ShowFocus := ShowFocus;
      Self.Style := Style;
    end;
  end;
end;

function TSCCustomButton.CanDoUp: Boolean;
var
  I: Integer;
  Control: TControl;
begin
  Result := FAllowAllUp or (FGroupIndex = 0);

  if not Result and (Parent <> nil) then
    with Parent do
      for I := 0 to ControlCount - 1 do
      begin
        Control := Controls[I];
        if (Control <> Self) and (Control is TSCCustomButton) then
          with TSCCustomButton(Control) do
            if FGroupIndex = Self.FGroupIndex then
            begin
              Result := Down;
              if Result then Exit;
            end;
      end;
end;

procedure TSCCustomButton.Click;
var
  Form: TCustomForm;
begin
  if HandleAllocated then
  begin
    Form := GetParentForm(Self);
    if Form <> nil then
      Form.ModalResult := ModalResult;
  end;
  inherited Click;
end;

procedure TSCCustomButton.CMButtonPressed(var Message: TMessage);
var
  Sender: TSCCustomButton;
begin
  if Message.WParam = FGroupIndex then
  begin
    Sender := TSCCustomButton(Message.LParam);

    if Sender <> Self then
    begin
      if Sender.Down and FDown then
      begin
        FDown := False;
        Invalidate;
      end;

      FAllowAllUp := Sender.AllowAllUp;
    end;
  end;
end;

procedure TSCCustomButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
    begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TSCCustomButton.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
    if  (((CharCode = VK_RETURN) and Active) or
      ((CharCode = VK_ESCAPE) and FCancel)) and
      (KeyDataToShiftState(Message.KeyData) = []) and CanFocus then
    begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TSCCustomButton.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
  with Message do
    if Sender is TSCCustomButton then
      Active := Sender = Self
    else
      Active := FDefault;
  Invalidate;
end;

procedure TSCCustomButton.CMParentColorChanged(var Message: TMessage);
begin
  inherited;

  if FRoundWithParentColor then
  begin
    if Message.wParam <> 0 then
      SetRoundColor(TColor(Message.lParam)) else
      SetRoundColor(TColoredControl(Parent).Color);
    FRoundWithParentColor := True;
  end;
end;

constructor TSCCustomButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csSetCaption, csOpaque, csDoubleClicks];
  SetBounds(Left, Top, 72, 25);
  DoubleBuffered := True;
  ParentColor := False;
  Color := clBtnFace;
  TabStop := True;

  FRepeatTimer := -1;

  FAllowAllUp := False;
  FArrowColor := clBtnText;
  FCenter := True;
  FDown := False;
  FGradient := scbgTopToBottom;
  FGroupIndex := 0;
  FHighlightColor := SC_HighlightColor;
  FHottrackColor := SC_HottrackColor;
  FLayout := scblLeft;
  FPopupArrow := False;
  FRepeatInterval := 50;
  FRoundColor := clBtnFace;
  FRounded := True;
  FRoundWithParentColor := True;
  FShowCaption := True;
  FShowFocus := True;
  FStyle := scbsWin2k;
end;

procedure TSCCustomButton.CreateWnd;
begin
  inherited CreateWnd;
  Active := FDefault;
end;

procedure TSCCustomButton.DoDrawCorel;
var
  CR, R: TRect;
  TopColor, BtmColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  if Transparent then
    PaintParentOn(Canvas)
  else begin
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if not FDown then
        Brush.Color := Self.Color
      else begin
        if IsColorLight(Self.Color) then
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
        else
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);
      end;

      FillRect(R);
    end;
  end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -2, -2);

  if not FDown and (FGroupIndex = 0) and
    (Active or FMousePressed or FSpaceDown) then
    InflateRect(FInnerRect, -1, -1);

  if FDown or FSpaceDown or
    (FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  R := CR;
  if (FDown and (FMousePressed or MouseInControl)) or
    (FMousePressed and MouseInControl) or FSpaceDown then
  begin
    if not FDown and (FGroupIndex = 0) and (Active or FMousePressed) then
    begin
      TopColor := Get3DDkShadowOf(Self.Color);
      BtmColor := TopColor;

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);

      TopColor := GetBtnShadowOf(Self.Color);
      BtmColor := GetBtnHighlightOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    end else
    begin
      TopColor := GetBtnShadowOf(Self.Color);
      BtmColor := GetBtnHighlightOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);

      TopColor := Get3DDkShadowOf(Self.Color);
      BtmColor := BlendedColor(Self.Color, 16, 16, 16, True);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    end;
  end else
  if FDown and not (FMousePressed or
    MouseInControl or FSpaceDown) then
  begin
    TopColor := GetBtnShadowOf(Self.Color);
    BtmColor := GetBtnHighlightOf(Self.Color);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
  end else
  begin
    if (FGroupIndex = 0) and (Active or FMousePressed or FSpaceDown) then
    begin
      TopColor := Get3DDkShadowOf(Self.Color);
      BtmColor := TopColor;

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    end;

    if (FMousePressed and not MouseInControl) or
      (not FMousePressed and MouseInControl) then
    begin
      TopColor := GetBtnHighlightOf(Self.Color);
      BtmColor := Get3DDkShadowOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);

      TopColor := BlendedColor(Self.Color, 16, 16, 16, True);
      BtmColor := GetBtnShadowOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    end else
    begin
      TopColor := GetBtnHighlightOf(Self.Color);
      BtmColor := GetBtnShadowOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    end;
  end;
end;

procedure TSCCustomButton.DoDrawFlatMacSpeed;
var
  CR, R: TRect;
  RoundBy: Integer;
  TopColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  if Transparent then
    PaintParentOn(Canvas)
  else begin
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if not FDown then
      begin
        if not (FSpaceDown or (FMousePressed and MouseInControl)) then
          Brush.Color := Self.Color
        else
        if IsColorLight(Self.Color) then
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
        else
          Brush.Color := BlendedColor(Self.Color, 96, 96, 96, True);
      end else
      begin
        if IsColorLight(Self.Color) then
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
        else
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);
      end;

      FillRect(R);
    end;
  end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -2, -2);

  if FDown or FSpaceDown or (FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  RoundBy := 0;
  if FRounded then RoundBy := 4;

  if IsDesigning or FDown or FSpaceDown or
    FMousePressed or MouseInControl then
  begin
    R := CR;
    TopColor := GetBtnShadowOf(Self.Color);
    scFrame3D(Canvas, R, TopColor, TopColor, 1, RoundBy);
  end;

  if FRounded and not Transparent then
  begin
    R := CR;
    SCFillCorners(Canvas, R, FRoundColor, RoundBy);
  end;
end;

procedure TSCCustomButton.DoDrawHower;
var
  CR, R: TRect;
  FC, C: TColor;
  Rd, I: Integer;
  RoundBy: Integer;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  FInnerRect := CR;
  InflateRect(FInnerRect, -6, -6);

  if FDown  or FSpaceDown or
    (FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  c := Self.Color;
  if not (FMousePressed or FSpaceDown) and MouseInControl then
    C := FHottrackColor
  else
  if FSpaceDown or (FMousePressed and not MouseInControl) or
    (HasFocus and not (FMousePressed or MouseInControl)) then
    C := FHighlightColor;

  if FDown then
  begin
    if IsColorLight(Self.Color) then
      C := BlendedColor(C, 24, 24, 24, False)
    else
      C := BlendedColor(C, 24, 24, 24, True);
  end;

  R := CR;
  if Transparent then
  begin
    PaintParentOn(Canvas);
    InflateRect(R, -4, -4);
  end else
  begin
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if FRounded and not Transparent then
      begin
        Brush.Color := FRoundColor;
        FillRect(R);
      end;

      InflateRect(R, -4, -4);

      Brush.Color := C;
      FillRect(R);
    end;
  end;

  RoundBy := 0; Rd := 0;
  if FRounded then
  begin
    RoundBy := 2;
    Rd := RoundBy + 2;
  end;

  FC := BlendedColor(C, 16, 16, 16, True);
  for I := 0 to 3 do
  begin
    R := CR;
    InflateRect(R, I - 3, I - 3);

    scFrame3D(Canvas, R, FC, FC, 1, Rd);

    if FRounded then
    begin
      InflateRect(R, 1, 1);
      scFrame3D(Canvas, R, FC, FC, 1, Rd + 2);
    end;

    FC := BlendedColor(FC, 12, 12, 12, True);
  end;

  R := CR;
  InflateRect(R, -4, -4);

  FC := BlendedColor(C, 64, 64, 64, False);
  scFrame3D(Canvas, R, FC, FC, 1, RoundBy);
end;

procedure TSCCustomButton.DoDrawMacSpeed;
var
  CR, R: TRect;
  RoundBy: Integer;
  TopColor, BtmColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  if Transparent then
    PaintParentOn(Canvas)
  else begin
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if not FDown then
      begin
        if not (FMousePressed and MouseInControl) then
          Brush.Color := Self.Color
        else
        if IsColorLight(Self.Color) then
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
        else
          Brush.Color := BlendedColor(Self.Color, 96, 96, 96, True);
      end else
      begin
        if IsColorLight(Self.Color) then
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
        else
          Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);
      end;

      FillRect(R);
    end;
  end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -2, -2);

  if FDown or FSpaceDown or (FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  RoundBy := 0;
  if FRounded then RoundBy := 4;

  R := CR;
  if FDown or FSpaceDown
    or (FMousePressed and MouseInControl) then
  begin
    TopColor := GetBtnShadowOf(Self.Color);
    BtmColor := GetBtnHighlightOf(Self.Color);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, RoundBy);
  end else
  begin
    TopColor := GetBtnHighlightOf(Self.Color);
    BtmColor := GetBtnShadowOf(Self.Color);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, RoundBy);
  end;

  if FRounded and not Transparent then
  begin
    R := CR;
    SCFillCorners(Canvas, R, FRoundColor, RoundBy);
  end;
end;

procedure TSCCustomButton.DoDrawNew;
var
  CR, R: TRect;
  Round1, Round2, Round3: Integer;
  DownState, Track: Boolean;
  BtmColor, TopColor,
  FrameColor, FaceColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;

  FInnerRect := CR;
  InflateRect(FInnerRect, -3, -3);

  if FDown or FSpaceDown or (FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  Round1 := 0; Round2 := 0; Round3 := 0;
  if FRounded then
  begin
    Round1 := 4;
    Round2 := 2;
    Round3 := 0;
  end;

  // face
  FaceColor := Self.Color;
  if FDown then
    FaceColor := BlendedColor(Self.Color, 24, 24, 24, True)
  else
  if FSpaceDown or (FMousePressed and MouseInControl) then
    FaceColor := BlendedColor(Self.Color, 8, 8, 8, False);

  if Transparent then
    PaintParentOn(Canvas)
  else begin
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := FaceColor;

      FillRect(R);
    end;
  end;

  // outter sunken frame
  TopColor := BlendedColor(clBtnFace, 16, 16, 16, False);
  BtmColor := BlendedColor(clBtnFace, 48, 48, 48, True);

  scFrame3D(Canvas, R, TopColor, BtmColor, 1, Round1);

  // outter frame
  TopColor := BlendedColor(Self.Color, 144, 144, 144, False);
  BtmColor := BlendedColor(TopColor, 16, 16, 16, True);

  scFrame3D(Canvas, R, TopColor, BtmColor, 1, Round1);

  // highligh or hottrack frame
  Track := False;
  FrameColor := Self.Color;

  if not (FMousePressed or FSpaceDown) and MouseInControl then
  begin
    Track := True;
    FrameColor := FHottrackColor;
  end else
  if HasFocus or Active or FMousePressed or FSpaceDown then
  begin
    Track := True;
    FrameColor := FHighlightColor;
  end;

  DownState := FDown or (not FDown and
    (FSpaceDown or (FMousePressed and MouseInControl)));

  TopColor := BlendedColor(FrameColor, 16, 16, 16, True);
  if DownState and Track then
    BtmColor := TopColor
  else
    BtmColor := BlendedColor(FrameColor, 40, 40, 40, False);

  if Track then
  begin
    TopColor := BlendedColor(TopColor, 32, 32, 32, True);
    BtmColor := BlendedColor(BtmColor, 32, 32, 32, True);
  end;

  scFrame3D(Canvas, R, TopColor, BtmColor, 1, Round2);
  if Track then
    scFrame3D(Canvas, R, TopColor, BtmColor, 1, Round3)
  else
  if not DownState then
  begin
    TopColor := BlendedColor(TopColor, 4, 4, 4, False);
    BtmColor := BlendedColor(BtmColor, 12, 12, 12, True);

    InflateRect(R, 1, 0);
    scFrame3D(Canvas, R, TopColor, BtmColor, 1, Round3);

    TopColor := BlendedColor(TopColor, 4, 4, 4, False);
    BtmColor := BlendedColor(BtmColor, 12, 12, 12, True);

    InflateRect(R, 1, 0);
    scFrame3D(Canvas, R, TopColor, BtmColor, 1, Round3);
  end;  

  if FRounded and not Transparent then
  begin
    R := CR;
    SCFillCorners(Canvas, R, FRoundColor, Round1);
  end;
end;

procedure TSCCustomButton.DoDrawOfficeXP;
var
  CR, R: TRect;
  IsDefaultColor: Boolean;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  FFontColor := clBtnText;
  FPopArrowColor := clBtnText;

  IsDefaultColor := False;

  R := CR;
  with Canvas do
  begin
    Brush.Style := bsSolid;

    if FDown then
    begin
      if FMousePressed or MouseInControl then
      begin
        Brush.Color := GetOfficeXPDownedSelColor;

        FFontColor := clHighlightText;
        FPopArrowColor := clHighlightText;
      end else
        Brush.Color := GetOfficeXPDownedColor;
    end else
    if FSpaceDown or (FMousePressed and MouseInControl) then
    begin
      Brush.Color := GetOfficeXPDownedSelColor;

      FFontColor := clHighlightText;
      FPopArrowColor := clHighlightText;
    end else
    if FMousePressed or MouseInControl then
      Brush.Color := GetOfficeXPSelColor
    else begin
      Brush.Color := GetOfficeXPBtnColor;
      IsDefaultColor := True;
    end;

    FillRect(R);
  end;

  if Transparent and IsDefaultColor then
    PaintParentOn(Canvas);

  FInnerRect := CR;
  InflateRect(FInnerRect, -2, -2);

  if (MouseInControl and not FMousePressed) or
    (FMousePressed and not MouseInControl) then
  begin
    FImgOffset := Point(-1, -1);
    FTxtOffset := Point(0, 0);
    FPopOffset := Point(0, 0);
  end;

  R := CR;
  if FDown or Active or FMousePressed or MouseInControl or FSpaceDown then
    scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
end;

procedure TSCCustomButton.DoDrawRaisedShadow;
var
  CR, R, MainR: TRect;
  FaceColor, TopColor: TColor;
  UpMode: Boolean;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  MainR := CR;

  if Transparent then
    PaintParentOn(Canvas)
  else begin
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := FRoundColor;

      FillRect(MainR);
    end;
  end;

  Dec(MainR.Right, 2);
  Dec(MainR.Bottom, 2);

  if IsRectEmpty(MainR) then
    Exit;

  UpMode := not (FDown or FSpaceDown) and ((not FMousePressed and MouseInControl) or
     (FMousePressed and not MouseInControl));

  if not UpMode then
    OffsetRect(MainR, 2, 2);

  R := MainR;
  with Canvas do
  begin
    Brush.Style := bsSolid;

    if not (FDown or FSpaceDown or FMousePressed or MouseInControl) then
      FaceColor := Self.Color
    else begin
      UpMode := True;
      if IsColorLight(Self.Color) then
        FaceColor := BlendedColor(Self.Color, 32, 32, 32, False)
      else
        FaceColor := BlendedColor(Self.Color, 48, 48, 48, True);
    end;

    Brush.Color := FaceColor;
    if UpMode or not Transparent then
      FillRect(R);
  end;

  FInnerRect := MainR;
  InflateRect(FInnerRect, -2, -2);

  if MouseInControl or (FMousePressed and not MouseInControl) then
  begin
    FImgOffset := Point(0, 0);
    FTxtOffset := Point(0, 0);
    FPopOffset := Point(0, 0);
  end;

  if UpMode then
  begin
    R := CR;

    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Width := 1;
      Pen.Color := GetBtnShadowOf(clBtnFace);

      MoveTo(R.Left  + 2, R.Bottom - 2);
      LineTo(R.Right - 2, R.Bottom - 2);
      LineTo(R.Right - 2, R.Top);

      MoveTo(R.Left  + 2, R.Bottom - 1);
      LineTo(R.Right - 1, R.Bottom - 1);
      LineTo(R.Right - 1, R.Top);
    end;
  end;

  R := MainR;
  TopColor := GetBtnShadowOf(FaceColor);
  scFrame3D(Canvas, R, TopColor, TopColor, 1, 0);
end;

procedure TSCCustomButton.DoDrawSpeed;
var
  CR, R: TRect;
  RoundBy: Integer;
  TopColor, BtmColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  if Transparent then
    PaintParentOn(Canvas)
  else begin
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if not FDown then
        Brush.Color := Self.Color
      else
      if IsColorLight(Self.Color) then
        Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
      else
        Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);

      FillRect(R);
    end;
  end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -2, -2);

  if FDown or FSpaceDown or (FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  RoundBy := 0;
  if FRounded then RoundBy := 4;

  R := CR;
  if FDown or FSpaceDown or (FMousePressed and MouseInControl) then
  begin
    TopColor := GetBtnShadowOf(Self.Color);
    BtmColor := GetBtnHighlightOf(Self.Color);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, RoundBy);
  end else
  if IsDesigning or (Enabled and MouseInControl) then
  begin
    TopColor := GetBtnHighlightOf(Self.Color);
    BtmColor := GetBtnShadowOf(Self.Color);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, RoundBy);
  end;

  if FRounded and not Transparent then
  begin
    R := CR;
    SCFillCorners(Canvas, R, FRoundColor, RoundBy);
  end;
end;

procedure TSCCustomButton.DoDrawWin2k;
var
  CR, R: TRect;
  FrameDrawn: Boolean;
  TopColor, BtmColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  if Transparent then
    PaintParentOn(Canvas)
  else begin
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if not FDown then
        Brush.Color := Self.Color
      else
      if IsColorLight(Self.Color) then
        Brush.Color := BlendedColor(Self.Color, 24, 24, 24, False)
      else
        Brush.Color := BlendedColor(Self.Color, 24, 24, 24, True);

      FillRect(R);
    end;
  end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -2, -2);

  if not (FDown or FSpaceDown) and (FGroupIndex = 0) and
    (Active or FMousePressed) then
    InflateRect(FInnerRect, -1, -1);

  if FDown or FSpaceDown or (FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  R := CR;
  if FDown or ((FGroupIndex <> 0) and FMousePressed and MouseInControl) then
  begin
    TopColor := GetBtnShadowOf(Self.Color);
    BtmColor := GetBtnHighlightOf(Self.Color);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);

    TopColor := Get3DDkShadowOf(Self.Color);
    BtmColor := BlendedColor(Self.Color, 16, 16, 16, True);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
  end else
  begin
    FrameDrawn := False;
    if (FGroupIndex = 0) and (Active or FSpaceDown or FMousePressed) then
    begin
      FrameDrawn := True;
      scFrame3D(Canvas, R, clWindowFrame, clWindowFrame, 1, 0);
    end;

    if FSpaceDown or (FMousePressed and MouseInControl) then
    begin
      if not FrameDrawn then
      begin
        TopColor := Get3DDkShadowOf(Self.Color);
        scFrame3D(Canvas, R, TopColor, TopColor, 1, 0);
      end;  

      BtmColor := GetBtnShadowOf(Self.Color);
      scFrame3D(Canvas, R, BtmColor, BtmColor, 1, 0);
    end else
    begin
      TopColor := GetBtnHighlightOf(Self.Color);
      BtmColor := Get3DDkShadowOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);

      // TopColor := BlendedColor(Self.Color, 16, 16, 16, True);
      TopColor := Self.Color;
      BtmColor := GetBtnShadowOf(Self.Color);

      scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
    end;
  end;
end;

procedure TSCCustomButton.DoDrawXP;
var
  CR, R: TRect;
  Track: Boolean;
  GradOrient: TSCGradient;
  BtmColor, TopColor,
  TrackColor, CornerColor1, CornerColor2: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;

  FInnerRect := CR;
  InflateRect(FInnerRect, -3, -3);

  if FDown or FSpaceDown or (FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  GradOrient := scgTopToBottom;
  if FGradient = scbgLeftToRight then GradOrient := scgLeftToRight;

  // outter sunken frame
  TopColor := BlendedColor(clBtnFace, 16, 16, 16, False);
  BtmColor := BlendedColor(clBtnFace, 48, 48, 48, True);

  scDrawGradient(Canvas, R, GradOrient, TopColor, BtmColor);

  if FRounded and not IsRectEmpty(R) then
    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := FRoundColor;

      MoveTo(R.Left, R.Top);
      LineTo(R.Left + 1, R.Top);
      MoveTo(R.Right - 1, R.Top);
      LineTo(R.Right, R.Top);

      MoveTo(R.Left, R.Bottom - 1);
      LineTo(R.Left + 1, R.Bottom - 1);
      MoveTo(R.Right - 1, R.Bottom - 1);
      LineTo(R.Right, R.Bottom - 1);
    end;

  InflateRect(R, -1, -1);

  CornerColor1 := TopColor;
  CornerColor2 := BtmColor;

  // outter frame
  TopColor := BlendedColor(Self.Color, 144, 144, 144, False);
  BtmColor := BlendedColor(TopColor, 16, 16, 16, True);

  scDrawGradient(Canvas, R, GradOrient, TopColor, BtmColor);

  if FRounded and not IsRectEmpty(R) then
    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := CornerColor1;

      MoveTo(R.Left, R.Top);
      LineTo(R.Left + 1, R.Top);
      MoveTo(R.Right - 1, R.Top);
      LineTo(R.Right, R.Top);

      Pen.Color := CornerColor2;

      MoveTo(R.Left, R.Bottom - 1);
      LineTo(R.Left + 1, R.Bottom - 1);
      MoveTo(R.Right - 1, R.Bottom - 1);
      LineTo(R.Right, R.Bottom - 1);
    end;

  InflateRect(R, -1, -1);

  CornerColor1 := BlendedColor(TopColor, 64, 64, 64, True);
  CornerColor2 := BlendedColor(BtmColor, 64, 64, 64, True);

  // highligh or hottrack frame
  Track := False;
  TrackColor := clNone;

  if not (FMousePressed or FSpaceDown) and MouseInControl then
  begin
    Track := True;
    TrackColor := FHottrackColor;
  end else
  if FSpaceDown or (FMousePressed and not MouseInControl) or
    ((HasFocus or Active) and not (FMousePressed or MouseInControl)) then
  begin
    Track := True;
    TrackColor := FHighlightColor
  end;

  if Track then
  begin
    if FDown or FSpaceDown or
      (FMousePressed and MouseInControl) then
    begin
      TopColor := BlendedColor(TrackColor, 16, 16, 16, False);
      BtmColor := BlendedColor(TrackColor, 16, 16, 16, True);
    end else
    begin
      TopColor := BlendedColor(TrackColor, 64, 64, 64, True);
      BtmColor := BlendedColor(TrackColor, 16, 16, 16, False);
    end;

    scDrawGradient(Canvas, R, GradOrient, TopColor, BtmColor);
    InflateRect(R, -2, -2);
  end;

  // face
  if FDown or FSpaceDown or
    (FMousePressed and MouseInControl) then
  begin
    TopColor := BlendedColor(Self.Color, 24, 24, 24, True);
    BtmColor := BlendedColor(Self.Color, 48, 48, 48, True);
  end else
  begin
    TopColor := BlendedColor(Self.Color, 48, 48, 48, True);
    BtmColor := BlendedColor(Self.Color, 24, 24, 24, False);
  end;

  scDrawGradient(Canvas, R, GradOrient, TopColor, BtmColor);

  if not Track and not IsRectEmpty(R) then
    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Color := TopColor;

      MoveTo(R.Left, R.Top);
      LineTo(R.Left, R.Bottom);

      MoveTo(R.Right - 1, R.Top);
      LineTo(R.Right - 1, R.Bottom);
    end;

  if FRounded then
  begin
    R := CR;
    InflateRect(R, -1, -1);

    if not IsRectEmpty(R) then
      with Canvas do
      begin
        Pen.Style := psSolid;
        Pen.Width := 1;

        Pen.Color := CornerColor1;

        MoveTo(R.Left + 1, R.Top);
        LineTo(R.Left - 1, R.Top + 2);
        MoveTo(R.Right - 2, R.Top);
        LineTo(R.Right, R.Top + 2);

        Pen.Color := CornerColor2;

        MoveTo(R.Left, R.Bottom - 2);
        LineTo(R.Left + 2, R.Bottom);
        MoveTo(R.Right - 1, R.Bottom - 2);
        LineTo(R.Right - 3, R.Bottom);

        InflateRect(R, -1, -1);

        CornerColor1 := BlendedColor(CornerColor1, 32, 32, 32, False);
        CornerColor2 := BlendedColor(CornerColor2, 32, 32, 32, False);

        Pen.Color := CornerColor1;

        MoveTo(R.Left, R.Top);
        LineTo(R.Left + 1, R.Top);
        MoveTo(R.Right - 1, R.Top);
        LineTo(R.Right, R.Top);

        Pen.Color := CornerColor2;

        MoveTo(R.Left, R.Bottom - 1);
        LineTo(R.Left + 1, R.Bottom - 1);
        MoveTo(R.Right - 1, R.Bottom - 1);
        LineTo(R.Right, R.Bottom - 1);
      end;
  end;
end;

procedure TSCCustomButton.DrawImageAndText(var R: TRect; CR: TRect;
  FontColor: TColor);
var
  Text: String;
  ImgR, TxtR: TRect;
  ImageValid: Boolean;
  SR, ImgW, ImgH, Img,
  X, Y, TxtW, TxtH, TxtFlags: Integer;
  AImageList: TCustomImageList;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  Canvas.Font.Assign(Self.Font);

  if FontColor = clNone then
    FontColor := FFontColor;

  if FLayout = scblRight then
  begin
    Dec(R.Right, Indent);
    TxtFlags := DT_RIGHT;
  end else
  begin
    Inc(R.Left, Indent);
    TxtFlags := DT_LEFT;
  end;

  if not (IsRectEmpty(R) or IsRectEmpty(CR)) then
  begin
    SR := IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
    try
      if SR <> NULLREGION then
      begin
        ImgW := 0;
        ImgH := 0;

        Img := GetImageIndex;
        AImageList := GetImages;

        ImageValid := (AImageList <> nil) and IsValidImage(Img);
        
        if ImageValid then
        begin
          ImgW := Images.Width;
          ImgH := Images.Height;

          if FShowCaption then
          begin
            if FLayout in [scblLeft, scblRight] then
              Inc(ImgW, Spacing)
            else
              Inc(ImgH, Spacing);
          end;    
        end;

        Text := '';
        TxtFlags := TxtFlags or DT_TOP;

        if FEndEllipsis then
          TxtFlags := TxtFlags or DT_END_ELLIPSIS;

        TxtFlags := DrawTextBiDiModeFlags(TxtFlags);

        TxtR := Rect(0, 0, 0, 0);

        if FShowCaption then
        begin
          Text := Caption;
          
          TxtR := R;
          if FLayout = scblLeft then
            Inc(TxtR.Left, ImgW)
          else
          if FLayout = scblRight then
            Dec(TxtR.Right, ImgW)
          else
            Inc(TxtR.Top, ImgH);
    
          OffsetRect(TxtR, -TxtR.Left, -TxtR.Top);

          if IsRectEmpty(TxtR) then
          begin
            TxtR.Left := TxtR.Right;
            TxtR.Top  := TxtR.Bottom;
          end else
          begin
            if not FMultiline then
              TxtFlags := TxtFlags or DT_SINGLELINE
            else
              TxtFlags := TxtFlags or DT_WORDBREAK;

            DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, DT_CALCRECT or TxtFlags);
          end;
        end;

        OffsetRect(TxtR, -TxtR.Left, -TxtR.Top);

        TxtW := TxtR.Right;
        TxtH := TxtR.Bottom;

        case FLayout of
          scblLeft:
          begin
            ImgR := R;
            if FCenter then
            begin
              ImgR.Left := R.Left + ((R.Right - R.Left) - ImgW - TxtW) div 2;
              if (FShowCaption or not FCenter) and (ImgR.Left < R.Left) then
                ImgR.Left := R.Left;
            end;

            if ImageValid then
            begin
              ImgR.Top := R.Top + ((R.Bottom - R.Top) - ImgH) div 2;

              X := FImgOffset.x + ImgR.Left;
              Y := FImgOffset.y + ImgR.Top;

              Images.Draw(Canvas, X, Y, Img, Enabled);
            end;
            ImgR.Right := ImgR.Left + ImgW;

            OffsetRect(TxtR, ImgR.Right, 0);

            if TxtR.Left < ImgR.Left then TxtR.Left := ImgR.Right;
            if TxtR.Right > R.Right then TxtR.Right := R.Right;

            if FShowCaption then
            begin
              if not FMultiline then
              begin
                TxtR.Top := CR.Top + ((CR.Bottom - CR.Top) - TxtH) div 2;
                TxtR.Bottom := CR.Bottom;

                IntersectRect(TxtR, TxtR, CR);
              end else
              begin
                TxtR.Top := R.Top + ((R.Bottom - R.Top) - TxtH) div 2;
                TxtR.Bottom := R.Bottom;

                IntersectRect(TxtR, TxtR, R);
              end;

              OffsetRect(TxtR, FTxtOffset.x, FTxtOffset.y);

              if not IsRectEmpty(TxtR) then
              begin
                with Canvas do
                begin
                  Brush.Style := bsClear;

                  Font := Self.Font;
                  Font.Color := FontColor;
                end;

                if not Enabled then
                begin
                  OffsetRect(TxtR, 1, 1);
                  Canvas.Font.Color := clBtnHighlight;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);

                  OffsetRect(TxtR, -1, -1);
                  Canvas.Font.Color := clBtnShadow;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
                end else
                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
              end;
            end;

            R.Right := TxtR.Right;
          end;
          scblTop:
          begin
            ImgR := R;
            if FCenter then
            begin
              ImgR.Left := R.Left + ((R.Right - R.Left) - ImgW) div 2;
              if (FShowCaption or not FCenter) and (ImgR.Left < R.Left) then
                ImgR.Left := R.Left;
            end;

            if ImageValid then
            begin
              ImgR.Top := R.Top + ((R.Bottom - R.Top) - ImgH - TxtH) div 2;

              X := FImgOffset.x + ImgR.Left;
              Y := FImgOffset.y + ImgR.Top;
              
              Images.Draw(Canvas, X, Y, Img, Enabled);

              ImgR.Bottom := ImgR.Top + ImgH;
            end else
            begin
              ImgR.Top := R.Top + ((R.Bottom - R.Top) - TxtH) div 2;
              ImgR.Bottom := ImgR.Top;
            end;
              
            ImgR.Right := ImgR.Left + ImgW;

            OffsetRect(TxtR, R.Left, 0);

            if FCenter then
            begin
              OffsetRect(TxtR, ((R.Right - R.Left) - TxtW) div 2, 0);
              if TxtR.Left < R.Left then TxtR.Left := R.Left;
            end;

            if TxtR.Right > R.Right then TxtR.Right := R.Right;

            if FShowCaption then
            begin
              OffsetRect(TxtR, 0, ImgR.Bottom);
              if TxtR.Bottom > R.Bottom then
                TxtR.Bottom := R.Bottom;

              IntersectRect(TxtR, TxtR, R);
              OffsetRect(TxtR, FTxtOffset.x, FTxtOffset.y);

              if not IsRectEmpty(TxtR) then
              begin
                with Canvas do
                begin
                  Brush.Style := bsClear;

                  Font := Self.Font;
                  Font.Color := FontColor;
                end;

                if FCenter then TxtFlags := TxtFlags or DT_CENTER;
          
                if not Enabled then
                begin
                  OffsetRect(TxtR, 1, 1);
                  Canvas.Font.Color := clBtnHighlight;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);

                  OffsetRect(TxtR, -1, -1);
                  Canvas.Font.Color := clBtnShadow;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
                end else
                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
              end;
            end;

            R := ImgR;
          end;
          scblRight:
          begin
            ImgR := R;
            if FCenter then
            begin
              ImgR.Right := R.Right - ((R.Right - R.Left) - ImgW - TxtW) div 2;
              if (FShowCaption or not FCenter) and (ImgR.Right > R.Right) then
                ImgR.Right := R.Right;

              ImgR.Left := ImgR.Right - ImgW;
            end;

            ImgR.Left := ImgR.Right - ImgW;
            if ImageValid then
            begin
              ImgR.Top := R.Top + ((R.Bottom - R.Top) - ImgH) div 2;

              X := FImgOffset.x + ImgR.Left;
              if FShowCaption then Inc(X, Spacing);

              Y := FImgOffset.y + ImgR.Top;

              Images.Draw(Canvas, X, Y, Img, Enabled);
            end;

            TxtR.Left := R.Left;
            TxtR.Right := ImgR.Left;
            if FShowCaption then Inc(TxtR.Right, Spacing);

            if TxtR.Right > ImgR.Left then TxtR.Right := ImgR.Left;
            if TxtR.Left < R.Left then TxtR.Left  := R.Left;

            if FShowCaption then
            begin
              TxtR.Top := R.Top + ((R.Bottom - R.Top) - TxtH) div 2;
              TxtR.Bottom := R.Bottom;

              IntersectRect(TxtR, TxtR, R);
              OffsetRect(TxtR, FTxtOffset.x, FTxtOffset.y);

              if not IsRectEmpty(TxtR) then
              begin
                with Canvas do
                begin
                  Brush.Style := bsClear;

                  Font := Self.Font;
                  Font.Color := FontColor;
                end;

                if not Enabled then
                begin
                  OffsetRect(TxtR, 1, 1);
                  Canvas.Font.Color := clBtnHighlight;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);

                  OffsetRect(TxtR, -1, -1);
                  Canvas.Font.Color := clBtnShadow;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
                end else
                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
              end;
            end;

            R.Left := TxtR.Left;
          end;
          scblBottom:
          begin
            ImgR := R;
            if FCenter then
            begin
              ImgR.Left := R.Left + ((R.Right - R.Left) - ImgW) div 2;
              if (FShowCaption or not FCenter) and (ImgR.Left < R.Left) then
                ImgR.Left := R.Left;
            end;

            if ImageValid then
            begin
              ImgR.Bottom := R.Bottom - ((R.Bottom - R.Top) - ImgH - TxtH) div 2;
              ImgR.Top := ImgR.Bottom - ImgH;

              X := FImgOffset.x + ImgR.Left;
              Y := FImgOffset.y + ImgR.Top;
              if FShowCaption then Inc(Y, Spacing);

              Images.Draw(Canvas, X, Y, Img, Enabled);
            end else
            begin
              ImgR.Bottom := R.Bottom - ((R.Bottom - R.Top) - TxtH) div 2;
              ImgR.Top := ImgR.Bottom;
            end;

            ImgR.Right := ImgR.Left + ImgW;

            OffsetRect(TxtR, R.Left, 0);

            if FCenter then
            begin
              OffsetRect(TxtR, ((R.Right - R.Left) - TxtW) div 2, 0);
              if TxtR.Left < R.Left then TxtR.Left := R.Left;
            end;

            if TxtR.Right > R.Right then TxtR.Right := R.Right;

            if FShowCaption then
            begin
              TxtR.Bottom := ImgR.Top;
              TxtR.Top := TxtR.Bottom - TxtH;

              if TxtR.Bottom > R.Bottom then
                TxtR.Bottom := R.Bottom;

              IntersectRect(TxtR, TxtR, R);
              OffsetRect(TxtR, FTxtOffset.x, FTxtOffset.y);

              if not IsRectEmpty(TxtR) then
              begin
                with Canvas do
                begin
                  Brush.Style := bsClear;

                  Font := Self.Font;
                  Font.Color := FontColor;
                end;

                if FCenter then TxtFlags := TxtFlags or DT_CENTER;

                if not Enabled then
                begin
                  OffsetRect(TxtR, 1, 1);
                  Canvas.Font.Color := clBtnHighlight;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);

                  OffsetRect(TxtR, -1, -1);
                  Canvas.Font.Color := clBtnShadow;

                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
                end else
                  DrawText(Canvas.Handle, PChar(Text), Length(Text), TxtR, TxtFlags);
              end;
            end;

            R := ImgR;
          end;
        end;
      end;
    finally
      SelectClipRgn(Canvas.Handle, 0);
    end;
  end;
end;

procedure TSCCustomButton.DrawPopupArrow(R: TRect; AColor: TColor);
var
  P: TPoint;
  Rgn: HRGN;
begin
  if (Canvas = nil) or IsRectEmpty(R) or
    not CanGetClientRect then Exit;

  if AColor = clNone then
    AColor := FPopArrowColor;

  Rgn := CreateRectRgnIndirect(R);
  try
    SelectClipRgn(Canvas.Handle, Rgn);

    if FLayout = scblRight then
      P.x := R.Left + 4 + FPopOffset.x
    else
      P.x := R.Right - 4 + FPopOffset.x;

    P.y := R.Top + ((R.Bottom - R.Top) div 2) + 2 + FPopOffset.y;

    SCDrawUpSlider(Canvas, P, 4, 2, sctsMac, False, AColor);
  finally
    SelectClipRgn(Canvas.Handle, 0);
    DeleteObject(Rgn);
  end;
end;

procedure TSCCustomButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if not ClickFocus and CanGetFocus then
    SetFocus;

  if GetCapture <> Self.Handle then
    SetCapture(Self.Handle);

  if HandleAllocated and CanGetFocus and
    HasFocus and (GetCapture = Self.Handle) then
  begin
    FMousePressed := Button = mbLeft;

    if FMousePressed then
    begin
      if not FSpaceDown then
        Invalidate;

      StartRepeat;
    end;
  end;  
end;

procedure TSCCustomButton.MouseInControlChanged;
begin
  if MouseInControl then
    ResumeRepeat
  else
    PauseRepeat;

  if not FSpaceDown and
    (FMousePressed or (FStyle <> scbsWin2k)) then
    Invalidate;
end;

procedure TSCCustomButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  WasDown: Boolean;
begin
  StopRepeat;

  if FMousePressed or MouseIsDown then
  begin
    FMousePressed := False;

    if not FSpaceDown then
    begin
      if (FGroupIndex = 0) or not MouseInControl then
      begin
        Invalidate;
        if MouseInControl and PopupDropdownMenu then
          Exit;
      end else
      begin
        WasDown := Down;
        Down := not WasDown;
        if WasDown = Down then
          Invalidate;
      end;
    end;
  end;

  inherited MouseUp(Button, Shift, X, Y);

  if GetCapture = Handle then
    ReleaseCapture;
end;

procedure TSCCustomButton.Paint;
var
  CR, R: TRect;
begin
  if not HandleAllocated then
    Exit;

  CR := ClientRect;

  FFontColor := Font.Color;
  FPopArrowColor := FArrowColor;

  FInnerRect := CR;

  FImgOffset := Point(0, 0);
  FTxtOffset := Point(0, 0);
  FPopOffset := Point(0, 0);

  case FStyle of
    scbsCorel:
      DoDrawCorel;
    scbsFlatMacSpeed:
      DoDrawFlatMacSpeed;
    scbsHower:
      DoDrawHower;
    scbsMacSpeed:
      DoDrawMacSpeed;
    scbsNew:
      DoDrawNew;
    scbsOfficeXP:
      DoDrawOfficeXP;
    scbsRaisedShadow:
      DoDrawRaisedShadow;
    scbsSpeed:
      DoDrawSpeed;
    scbsWin2k:
      DoDrawWin2k;
    scbsXP:
      DoDrawXP;
    scbsOffice12:
      DoDrawOffice12;
    scbsOffice2003:
      DoDrawOffice2003;
    scbsDarkling:
      DoDrawDarkling;
    scbsMetal:
      DoDrawMetal;
    else
      DoDrawWin2k;
  end;

  R := FInnerRect;
  if not FShowCaption and FCenter then R := CR;

  DrawImageAndText(R, CR);

  if FPopupArrow then
  begin
    InflateRect(R, 12, 12);
    IntersectRect(R, R, FInnerRect);

    DrawPopupArrow(R);
  end;

  R := ClientRect;
  if not (FStyle in [scbsNew, scbsXP, scbsCorel, scbsWin2k, scbsOffice2003]) then
    InflateRect(R, -2, -2)
  else begin
    InflateRect(R, -3, -3);

    if (FStyle in [scbsCorel, scbsWin2k]) and
      not FDown and (FGroupIndex = 0) and (Active or FMousePressed) then
      InflateRect(R, -1, -1);
  end;

  if FShowFocus and HasFocus and not IsRectEmpty(R) then
  begin
    IntersectRect(R, R, CR);

    if not IsRectEmpty(R) then
      with Canvas do
      begin
        Brush.Color := Self.Color;
        Brush.Style := bsSolid;

        scDrawFocusRect(Canvas, R, Self.Color);
      end;
  end;
end;

procedure TSCCustomButton.SetAllowAllUp(Value: Boolean);
begin
  if FAllowAllUp <> Value then
  begin
    FAllowAllUp := Value;
    UpdateGroupDown;
  end;
end;

procedure TSCCustomButton.SetArrowColor(Value: TColor);
begin
  if FArrowColor <> Value then
  begin
    FArrowColor := Value;
    if FPopupArrow then Invalidate;
  end;
end;

procedure TSCCustomButton.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    Invalidate;
  end;
end;

type
  TFakeFocusControl = class(TWinControl);

procedure TSCCustomButton.SetDefault(Value: Boolean);
var
  Form: TCustomForm;
begin
  if FDefault <> Value then
  begin
    FDefault := Value;
    if HandleAllocated then
    begin
      Form := GetParentForm(Self);
      if Form <> nil then
        Form.Perform(CM_FOCUSCHANGED, 0, Longint(Form.ActiveControl));
    end;
  end;
end;

procedure TSCCustomButton.SetDown(Value: Boolean);
begin
  if Value then
    Value := FGroupIndex <> 0
  else
  if FDown and not Value then
    Value := not CanDoUp;

  if FDown <> Value then
  begin
    FDown := Value;
    Invalidate;

    UpdateGroupDown;

    if Assigned(FOnStateChange) then
      FOnStateChange(Self);
  end;
end;

procedure TSCCustomButton.SetGradient(Value: TSCButtonGradient);
begin
  if FGradient <> Value then
  begin
    FGradient := Value;
    if FStyle in [scbsXP, scbsOffice2003] then
      Invalidate;
  end;
end;

procedure TSCCustomButton.SetGroupIndex(Value: Integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    Invalidate;

    UpdateGroupDown;
  end;
end;

procedure TSCCustomButton.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    if FStyle in [scbsXP, scbsOffice12, scbsOffice2003] then
      Invalidate;
  end;
end;

procedure TSCCustomButton.SetHottrackColor(Value: TColor);
begin
  if FHottrackColor <> Value then
  begin
    FHottrackColor := Value;
    if FStyle in [scbsXP, scbsOffice12, scbsOffice2003] then
      Invalidate;
  end;
end;

procedure TSCCustomButton.SetLayout(Value: TSCButtonLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TSCCustomButton.SetMultiline(Value: Boolean);
begin
  if FMultiline <> Value then
  begin
    FMultiline := Value;
    Invalidate;
  end;
end;

procedure TSCCustomButton.SetPopupArrow(Value: Boolean);
begin
  if FPopupArrow <> Value then
  begin
    FPopupArrow := Value;
    Invalidate;
  end;
end;

procedure TSCCustomButton.SetRoundColor(Value: TColor);
begin
  if FRoundColor <> Value then
  begin
    FRoundColor := Value;
    FRoundWithParentColor := False;
    if FRounded then
      Invalidate;
  end;
end;

procedure TSCCustomButton.SetRounded(Value: Boolean);
begin
  if FRounded <> Value then
  begin
    FRounded := Value;
    Invalidate;
  end;
end;

procedure TSCCustomButton.SetRoundWithParentColor(Value: Boolean);
begin
  if FRoundWithParentColor <> Value then
  begin
    FRoundWithParentColor := Value;
    if Value and FRounded and (Parent <> nil) then
      Perform(CM_PARENTCOLORCHANGED, 0, 0);
  end;
end;

procedure TSCCustomButton.SetShowCaption(Value: Boolean);
begin
  if FShowCaption <> Value then
  begin
    FShowCaption := Value;
    Invalidate;
  end;
end;

procedure TSCCustomButton.SetShowFocus(Value: Boolean);
begin
  if FShowFocus <> Value then
  begin
    FShowFocus := Value;
    if HandleAllocated and HasFocus then
      Invalidate;
  end;
end;

procedure TSCCustomButton.SetStyle(Value: TSCButtonStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TSCCustomButton.StopTracking;
begin
  if GetCapture = Handle then
  begin
    FMousePressed := False;
    FSpaceDown := False;

    Invalidate;
  end;

  StopRepeat;
  inherited StopTracking;
end;

procedure TSCCustomButton.UpdateGroupDown;
var
  Msg: TMessage;
begin
  if (FGroupIndex <> 0) and (Parent <> nil) then
  begin
    Msg.Msg := CM_BUTTONPRESSED;
    Msg.WParam := FGroupIndex;
    Msg.LParam := Longint(Self);
    Msg.Result := 0;
    Parent.Broadcast(Msg);
  end;
end;

function TSCCustomButton.UseRightToLeftAlignment: Boolean;
begin
  Result := False;
end;

procedure TSCCustomButton.SpacingChanged;
begin
  Invalidate;
end;

procedure TSCCustomButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_SPACE) and not FMousePressed then
  begin
    if FSpaceDown then
    begin
      Key := 0;
      Exit;
    end;

    FSpaceDown := True;
    if not FMousePressed then
      Invalidate;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomButton.KeyUp(var Key: Word; Shift: TShiftState);
var
  WasDown: Boolean;
begin
  if FSpaceDown and (Key in [VK_SPACE, VK_ESCAPE]) then
  begin
    FSpaceDown := False;
    Invalidate;

    if not FMousePressed then
    begin
      if Key = VK_ESCAPE then
        Exit;

      if FGroupIndex = 0 then
      begin
        if PopupDropdownMenu then
          Exit;
      end else
      begin
        WasDown := Down;
        Down := not WasDown;

        if WasDown = Down then
          Invalidate;
      end;

      Click;
    end;
  end;

  inherited KeyUp(Key, Shift);
end;

procedure TSCCustomButton.SetRepeatClick(Value: Boolean);
begin
  if FRepeatClick <> Value then
  begin
    FRepeatClick := Value;

    if Repeating or RepeatPaused then
    begin
      PauseRepeat;
      ResumeRepeat;
    end;
  end;
end;

procedure TSCCustomButton.SetRepeatInterval(Value: Integer);
begin
  if Value < 10 then
    Value := 10;

  if FRepeatInterval <> Value then
  begin
    FRepeatInterval := Value;

    if Repeating or RepeatPaused then
    begin
      PauseRepeat;
      ResumeRepeat;
    end;
  end;
end;

procedure TSCCustomButton.PauseRepeat;
begin
  FRepeating := False;
end;

function TSCCustomButton.Repeating: Boolean;
begin
  Result := FRepeating and
    (FRepeatTimer <> -1) and CanRepeat and MouseInControl;
end;

function TSCCustomButton.RepeatPaused: Boolean;
begin
  Result := not (FRepeating and Enabled and MouseInControl) and
    (FRepeatTimer <> -1) and CanRepeat;
end;

procedure TSCCustomButton.ResumeRepeat;
begin
  FRepeating := (FRepeatTimer <> -1) and CanRepeat;
end;

procedure TSCCustomButton.StartRepeat;
begin
  if HandleAllocated and CanRepeat then
  begin
    if RepeatPaused then
    begin
      ResumeRepeat;
      Exit;
    end;

    if not Repeating then
    begin
      StopRepeat;
      if Enabled then
      begin
        FRepeatTimer := SetTimer(Handle, SC_BUTTON_REPEATTIMERID,
          GetDoubleClickTime, nil);
        FRepeating := FRepeatTimer <> -1;
      end;  
    end;
  end;
end;

procedure TSCCustomButton.StopRepeat;
begin
  FRepeating   := False;

  if HandleAllocated and (FRepeatTimer <> -1) then
  begin
    if HandleAllocated then
      KillTimer(Handle, FRepeatTimer);

    FRepeatTimer := -1;
    Invalidate;
  end;
end;

procedure TSCCustomButton.WMTimer(var Message: TWMTimer);
begin
  inherited;

  if HandleAllocated and Repeating and
    (Message.TimerID = SC_BUTTON_REPEATTIMERID) then
  begin
    if FRepeatTimer <> -1 then
      KillTimer(Handle, FRepeatTimer);

    if Enabled then
    begin
      FRepeatTimer := SetTimer(Handle, SC_BUTTON_REPEATTIMERID,
        FRepeatInterval, nil);
      FRepeating := FRepeatTimer <> -1;

      Click;
    end;
  end;
end;

function TSCCustomButton.CanRepeat: Boolean;
begin
  Result := Enabled and FRepeatClick and FMousePressed;
end;

destructor TSCCustomButton.Destroy;
begin
  StopRepeat;
  inherited Destroy;
end;

procedure TSCCustomButton.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TSCCustomButton.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then Click;
end;

procedure TSCCustomButton.SetDropdownMenu(Value: TPopupMenu);
begin
  if FDropdownMenu <> Value then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDropdownMenu <> nil then
      FDropdownMenu.RemoveFreeNotification(Self);
    {$ENDIF}

    FDropdownMenu := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;
end;

procedure TSCCustomButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DropdownMenu) then
    DropdownMenu := nil;
end;

function TSCCustomButton.CheckMenuDropdown: Boolean;
begin
  Result := not IsDesigning and not RepeatClick and
    (DropdownMenu <> nil) and (DropdownMenu.Items.Count > 0);
end;

function TSCCustomButton.PopupDropdownMenu: Boolean;
var
  P: TPoint;
  Bs: Integer;
begin
  Result := CheckMenuDropdown;
  if not Result then
    Exit;

  Bs := GetBorderSize + BorderWidth + GetInnerBorderSize;
  if Bs < 0 then Bs := 0;

  P := Point(-Bs, ClientHeight + Bs);
  P := Self.ClientToScreen(P);

  DropdownMenu.Popup(P.x, P.y);
end;

procedure TSCCustomButton.EnabledChanged;
begin
  FMousePressed := False;
  FSpaceDown := False;
  Invalidate;
  StopRepeat;
  inherited EnabledChanged;
end;

procedure TSCCustomButton.DoDrawOffice12;
var
  CR, R, ARect: TRect;
  AColor, ClStart, ClEnd: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  ARect := CR;

  AColor := GetDefaultBackColor;
  FFontColor := GetDefaultForeColor;
  FPopArrowColor := clBtnText;

  if FDown or FSpaceDown or FMousePressed or MouseInControl then
  begin
    AColor := FHottrackColor;
    if MouseInControl and (FMousePressed or FSpaceDown) then
      AColor := FHighlightColor;

    if AColor = clNone then
      AColor := GetDefaultBackColor
    else AColor := BlendedColor(AColor, 24, 24, 24, True);

    if FDown then
    begin
      if MouseInControl or (MouseInControl and FMousePressed) then
        AColor := scBlendColor(AColor, -12)
      else
        AColor := scBlendColor(AColor, 20);
    end else
    if FSpaceDown or (MouseInControl and FMousePressed) then
      AColor := scBlendColor(AColor, -16)
    else
    if MouseInControl or FMousePressed then
      AColor := scBlendColor(AColor, -6);
  end;

  with Canvas do
  begin
    Brush.Color := AColor;
    Brush.Style := bsSolid;

    FillRect(ARect);
  end;

  R := ARect;
  Dec(R.Bottom, Round((R.Bottom - R.Top)/4));

  ClEnd := AColor;
  ClStart := GetGradientPreLight(AColor);

  scDrawGradient(Canvas, R, scgTopToBottom, ClStart, ClEnd);

  R := ARect;
  Inc(R.Top, (R.Bottom - R.Top) div 2);

  if not IsRectEmpty(R) then
  begin
    ClStart := GetGradientDark(AColor);
    ClEnd := GetGradientLight(AColor);

    scDrawGradient(Canvas, R, scgTopToBottom, ClStart, ClEnd);
  end;

  if FDefault or Active then
    AColor := GetGradientExDark(AColor);

  R := ARect;
  InflateRect(R, -1, -1);

  ClStart := GetGradientPreLight(AColor);
  scFrame3D(Canvas, R, ClStart, ClStart, 1, 0);

  R := ARect;

  ClStart := GetGradientPreDark(AColor);
  scFrame3D(Canvas, R, ClStart, ClStart, 1, 0);

  FInnerRect := CR;
  InflateRect(FInnerRect, -3, -3);

  if (MouseInControl and not FMousePressed) or
    (FMousePressed and not MouseInControl) then
  begin
    FImgOffset := Point(0, 0);
    FTxtOffset := Point(0, 0);
    FPopOffset := Point(0, 0);
  end;
end;

procedure TSCCustomButton.DoDrawOffice2003;
var
  CR, R: TRect;
  IsDefault: Boolean;
  GradOrient: TSCGradient;
  Cl, BtmColor, TopColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;

  FFontColor := clBtnText;
  FPopArrowColor := clBtnText;

  IsDefault := False;

  with Canvas do
  begin
    Brush.Style := bsSolid;

    if FDown then
    begin
      if FMousePressed or MouseInControl then
      begin
        Brush.Color := GetOfficeXPDownedSelColor;

        FFontColor := clHighlightText;
        FPopArrowColor := clHighlightText;
      end else
        Brush.Color := GetOfficeXPDownedColor;
    end else
    if FSpaceDown or (FMousePressed and MouseInControl) then
    begin
      Brush.Color := GetOfficeXPDownedSelColor;

      FFontColor := clHighlightText;
      FPopArrowColor := clHighlightText;
    end else
    if FMousePressed or MouseInControl then
      Brush.Color := GetOfficeXPSelColor
    else begin
      Brush.Color := GetOfficeXPBtnColor;
      IsDefault := True;
    end;

    FillRect(R);
  end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -3, -3);
  
  if IsDefault then
  begin
    GradOrient := scgTopToBottom;
    if FGradient = scbgLeftToRight then GradOrient := scgLeftToRight;

    TopColor := BlendedColor(Self.Color, 48, 48, 48, True);
    BtmColor := BlendedColor(Self.Color, 24, 24, 24, False);

    scDrawGradient(Canvas, R, GradOrient, TopColor, BtmColor);
  end;

  if (MouseInControl and not FMousePressed) or
    (FMousePressed and not MouseInControl) then
  begin
    FImgOffset := Point(0, 0);
    FTxtOffset := Point(0, 0);
    FPopOffset := Point(0, 0);
  end;

  R := CR;
  if IsDefault and Active then
  begin
    Cl := GetBtnShadowOf(Self.Color);
    scFrame3D(Canvas, R, Cl, Cl, 1, 0);
  end else
  if not IsDefault and (FDown or Active or FMousePressed or
    MouseInControl or FSpaceDown) then
    scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
end;

procedure TSCCustomButton.DoDrawDarkling;
var
  C: TColor;
  CR, R: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  FInnerRect := CR;
  InflateRect(FInnerRect, -1, -1);

  if FDown  or FSpaceDown or
    (FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  C := Self.Color;
  if not (FMousePressed or FSpaceDown) and MouseInControl then
    C := FHottrackColor
  else
  if FSpaceDown or (FMousePressed and not MouseInControl) or
    (HasFocus and not (FMousePressed or MouseInControl)) then
    C := FHighlightColor;

  if FDown then
  begin
    if IsColorLight(Self.Color) then
      C := BlendedColor(C, 24, 24, 24, False)
    else
      C := BlendedColor(C, 24, 24, 24, True);
  end;

  R := CR;
  if Transparent then
  begin
    PaintParentOn(Canvas);
    InflateRect(R, -1, -1);
  end else
  begin
    with Canvas do
    begin
      Brush.Style := bsSolid;
      InflateRect(R, -1, -1);

      Brush.Color := C;
      FillRect(R);
    end;
  end;

  R := CR;

  C := BlendedColor(C, 64, 64, 64, False);
  scFrame3D(Canvas, R, C, C, 1, 0);
end;

procedure TSCCustomButton.DoDrawMetal;
var
  CR, R: TRect;
  FaceColor, TopColor, BtmColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  FaceColor := Self.Color;

  R := CR;
  if Transparent then
    PaintParentOn(Canvas)
  else begin
    with Canvas do
    begin
      Brush.Style := bsSolid;

      if not FDown then
        FaceColor := Self.Color
      else
      if IsColorLight(Self.Color) then
        FaceColor := BlendedColor(Self.Color, 24, 24, 24, False)
      else
        FaceColor := BlendedColor(Self.Color, 24, 24, 24, True);

      Brush.Color := FaceColor;  
      FillRect(R);
    end;
  end;

  FInnerRect := CR;
  InflateRect(FInnerRect, -2, -2);

  if not (FDown or FSpaceDown) and (FGroupIndex = 0) and
    (Active or FMousePressed) then
    InflateRect(FInnerRect, -1, -1);

  if FDown or FSpaceDown or (FMousePressed and MouseInControl) then
  begin
    FImgOffset := Point(1, 1);
    FTxtOffset := Point(1, 1);
    FPopOffset := Point(1, 1);
  end;

  R := CR;

  TopColor := GetBtnShadowOf(Self.Color);
  scFrame3D(Canvas, R, TopColor, TopColor, 1, 0);

  if FDown or ((FGroupIndex <> 0) and FMousePressed and MouseInControl) then
  begin
    TopColor := FaceColor;
    BtmColor := SCCommon.scBlendColor(FaceColor, 64);

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
  end else
  begin
    if (FGroupIndex = 0) and (Active or FSpaceDown or FMousePressed) then
    begin
      InflateRect(R, 1, 1);

      TopColor := Get3DDkShadowOf(FaceColor);
      scFrame3D(Canvas, R, TopColor, TopColor, 1, 0);
    end;

    if Enabled and (FSpaceDown or (FMousePressed and MouseInControl)) then
    begin
      TopColor := Self.Color;
      BtmColor := SCCommon.scBlendColor(FaceColor, 64);
    end else
    begin
      TopColor := SCCommon.scBlendColor(FaceColor, 64);
      BtmColor := Self.Color;
    end;

    scFrame3D(Canvas, R, TopColor, BtmColor, 1, 0);
  end;
end;

function TSCCustomButton.GetGradientDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -16);
end;

function TSCCustomButton.GetGradientExDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -40);
end;

function TSCCustomButton.GetGradientExLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 40);
end;

function TSCCustomButton.GetGradientLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 30);
end;

function TSCCustomButton.GetGradientPeal(AColor: TColor): TColor;
begin
  Result := BlendedColor(AColor, 52, 44, 112, True);
end;

function TSCCustomButton.GetGradientPreDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -80);
end;

function TSCCustomButton.GetGradientPreLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 100);
end;

function TSCCustomButton.GetGradientShadow(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -6);
end;

function TSCCustomButton.GetGradientHighLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 120);
end;

{ TSCCustomCheckbox }

procedure TSCCustomCheckbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomCheckbox then
  begin
    with TSCCustomCheckbox(Source) do
    begin
      Self.Alignment := Alignment;
      Self.AllowGrayed := AllowGrayed;
      Self.State := State;
      Self.BoxCheckedColor := BoxCheckedColor;
      Self.BoxDisabledColor := BoxDisabledColor;
      Self.BoxFrameColor := BoxFrameColor;
      Self.BoxGrayedColor := BoxGrayedColor;
      Self.BoxToggleColor := BoxToggleColor;
      Self.BoxUncheckedColor := BoxUncheckedColor;
      Self.Gradient := Gradient;
      Self.GradientEnd := GradientEnd;
      Self.HighlightColor := HighlightColor;
      Self.HottrackColor := HottrackColor;
      Self.ImageChecked := ImageChecked;
      Self.ImageGrayed := ImageGrayed;
      Self.ImageToggle := ImageToggle;
      Self.ImageUnchecked := ImageUnchecked;
      Self.ImageMark := ImageMark;
      Self.ImageMarkDisabled := ImageMarkDisabled;
      Self.ImageMarkGrayed := ImageMarkGrayed;
      Self.Layout := Layout;
      Self.MarkColor := MarkColor;
      Self.MarkDisabledColor := MarkDisabledColor;
      Self.MarkGrayedColor := MarkGrayedColor;
      Self.Multiline := Multiline;
      Self.ShowCheckMark := ShowCheckMark;
      Self.ShowFocus := ShowFocus;
      Self.Style := Style;
    end;
  end;
end;

procedure TSCCustomCheckbox.Click;
begin
  if FStateChanging = 0 then
  begin
    inherited Changed;
    inherited Click;
  end;  
end;

procedure TSCCustomCheckbox.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
    begin
      SetFocus;
      if HasFocus then Toggle;
      Result := 1;
    end else
      inherited;
end;

procedure TSCCustomCheckbox.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then Toggle;
end;

constructor TSCCustomCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csSetCaption, csOpaque, csDoubleClicks];
  SetBounds(Left, Top, 115, 17);
  DoubleBuffered := True;
  TabStop := True;
  ParentColor := True;

  FAlignment := taRightJustify;
  FAllowGrayed := False;
  FBoxCheckedColor := clWindow;
  FBoxDisabledColor := clBtnFace;
  FBoxFrameColor := clBtnShadow;
  FBoxGrayedColor := clBtnFace;
  FBoxToggleColor := clBtnFace;
  FBoxUncheckedColor := clWindow;
  FGradient := scgNone;
  FGradientEnd := clBlue;
  FHighlightColor := SC_HighlightColor;
  FHottrackColor := SC_HottrackColor;
  FImageChecked := -1;
  FImageDisabled := -1;
  FImageGrayed := -1;
  FImageToggle := -1;
  FImageUnchecked := -1;
  FImageMark := -1;
  FImageMarkDisabled := -1;
  FImageMarkGrayed := -1;
  FLayout := scclMiddle;
  FMarkColor := clWindowText;
  FMarkDisabledColor := clGrayText;
  FMarkGrayedColor := clGrayText;
  FShowCheckMark := True;
  FShowFocus := True;
  FState := sccbUnchecked;
  FStyle := sccsWin2k;
end;

procedure TSCCustomCheckbox.DoDrawCorelCb;
var
  CR, R: TRect;
  W, H: Integer;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scclBottom:
    begin
      R.Top := R.Bottom - H;
    end;
    scclMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scclTop:
    begin
      R.Bottom := R.Top + H;
    end;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor;

    if Brush.Color <> clNone then
      FillRect(R);
  end;

  DoDrawMark(R);

  scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
  if HasFocus or FMousePressed or MouseInControl then
    scFrame3D(Canvas, R, cl3DDkShadow, clBtnFace, 1, 0);
end;

procedure TSCCustomCheckbox.DoDrawFlatCb;
var
  W, H: Integer;
  CR, R: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scclBottom:
    begin
      R.Top := R.Bottom - H;
    end;
    scclMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scclTop:
    begin
      R.Bottom := R.Top + H;
    end;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor;

    if Brush.Color <> clNone then
      FillRect(R);
  end;

  DoDrawMark(R);

  case FStyle of
    sccsFlat:
    begin
      if HasFocus or FMousePressed or MouseInControl then
        scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
    end;
    sccsFlatFrame:
    begin
      scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
      if HasFocus or FMousePressed or MouseInControl then
        scFrame3D(Canvas, R, cl3DDkShadow, clBtnFace, 1, 0)
      else
        scFrame3D(Canvas, R, clBtnFace, clBtnFace, 1, 0)
    end;
    sccsFlatEx:
    begin
      scFrame3D(Canvas, R, FBoxFrameColor, FBoxFrameColor, 1, 0);
    end;
    sccsFlatDouble:
    begin
      scFrame3D(Canvas, R, FBoxFrameColor, FBoxFrameColor, 1, 0);
      scFrame3D(Canvas, R, FBoxFrameColor, FBoxFrameColor, 1, 0);
    end;
  end;  
end;

procedure TSCCustomCheckbox.DoDrawImageCb;
var
  CR, R: TRect;
  Img: TImageIndex;
  ImgW, ImgH: Integer;
  St: TSCCheckState;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  St := GetDrawState;

  ImgW := 0; ImgH := 0;
  if Images <> nil then
  begin
    ImgW := Images.Width;
    ImgH := Images.Height;
  end;

  R := CR;
  R.Right := R.Left + ImgW;

  case FLayout of
    scclBottom:
      R.Top := R.Bottom - ImgH;
    scclMiddle:
    begin
      R.Top := (R.Bottom - R.Top - ImgH) div 2;
      R.Bottom := R.Top + ImgH;
    end;
    scclTop:
      R.Bottom := R.Top + ImgH;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - ImgW;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  Img := -1;

  if not Enabled then
    Img := FImageDisabled
  else if InToggle then
    Img := FImageToggle
  else begin
    case St of
      sccbChecked:
      begin
        Img := FImageChecked;
      end;
      sccbUnchecked:
        Img := FImageUnchecked;
      sccbGrayed:
        Img := FImageGrayed;
    end;
  end;

  if IsValidImage(Img) then
    Images.Draw(Canvas, R.Left, R.Top, Img, True);

  DoDrawMark(R);  
end;

procedure TSCCustomCheckbox.DoDrawMacCb;
var
  W, H: Integer;
  CR, R, R2: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scclBottom:
      R.Top := R.Bottom - H;
    scclMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scclTop:
      R.Bottom := R.Top + H;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor;

    if Brush.Color <> clNone then
      FillRect(R);
  end;

  R2 := R;
  scFrame3D(Canvas, R2, clWindowFrame, clWindowFrame, 1, 0);
  scFrame3D(Canvas, R2, clBtnHighlight, clBtnShadow, 1, 0);

  DoDrawMark(R);
end;

procedure TSCCustomCheckbox.DoDrawOfficeXPCb;
var
  W, H: Integer;
  CR, R: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scclBottom:
      R.Top := R.Bottom - H;
    scclMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scclTop:
      R.Bottom := R.Top + H;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - H;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor;

    FillRect(R);
  end;

  DoDrawMark(R, FOfficeMarkColor);
  scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
end;

procedure TSCCustomCheckbox.DoDrawText(var R: TRect; CalcRect: Boolean);
var
  Text: String;
  TxtFlags: Integer;
begin
  if (Canvas = nil) or not (CanGetClientRect and
    (CalcRect or not IsRectEmpty(R))) then
    Exit;

  TxtFlags := DT_LEFT or DT_EXPANDTABS;
  if FAlignment = taLeftJustify then
    TxtFlags := DT_RIGHT or DT_EXPANDTABS;

  if not CalcRect then
    IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);

  Text := Caption;
  if CalcRect and ((Text = '') or
    ((Length(Text) > 1) and (Text[1] = '&') and (Text[2] = #0))) then Text := Text + ' ';

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

    if not CalcRect and not Enabled then
    begin
      OffsetRect(R, 1, 1);
      Font.Color := clBtnHighlight;

      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);

      OffsetRect(R, -1, -1);
      Font.Color := clBtnShadow;

      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);
    end else
      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);

    if not CalcRect then
      SelectClipRgn(Handle, 0);
  end;
end;

procedure TSCCustomCheckbox.DoDrawWin2kCb;
var
  CR, R: TRect;
  W, H: Integer;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scclBottom:
      R.Top := R.Bottom - H;
    scclMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scclTop:
    begin
      R.Bottom := R.Top + H;
    end;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor;

    if Brush.Color <> clNone then
      FillRect(R);
  end;

  DoDrawMark(R);

  scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
  scFrame3D(Canvas, R, cl3DDkShadow, clBtnFace, 1, 0);
end;

procedure TSCCustomCheckbox.DoDrawXPCb;
var
  CR, R: TRect;
  W, H: Integer;
  Track: Boolean;
  TrackColor, TopColor, BtmColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scclBottom:
      R.Top := R.Bottom - H;
    scclMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scclTop:
      R.Bottom := R.Top + H;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - H;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor;

    if Brush.Color <> clNone then
      FillRect(R);
  end;

  DoDrawMark(R);

  // highligh or hottrack frame
  Track := False;
  TrackColor := clNone;

  if not FMousePressed and MouseInControl then
  begin
    Track := True;
    TrackColor := FHottrackColor;
  end else
  if (FMousePressed and not MouseInControl) or
    (HasFocus and not (FMousePressed or MouseInControl)) then
  begin
    Track := True;
    TrackColor := FHighlightColor
  end;

  InflateRect(R, -1, -1);

  if Track and not IsRectEmpty(R) then
  begin
    if InToggle then
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

    InflateRect(R, 2, 2);
  end;

  InflateRect(R, 1, 1);
  scFrame3D(Canvas, R, FBoxFrameColor, FBoxFrameColor, 1, 0);
end;

function TSCCustomCheckbox.GetChecked: Boolean;
begin
  Result := FState = sccbChecked;
end;

function TSCCustomCheckbox.GetBoxFaceColor: TColor;
var
  St: TSCCheckState;
begin
  if FStyle = sccsOfficeXP then
  begin
    Result := GetOfficeXPBtnColor;
    FOfficeMarkColor := clBtnText;

    if Checked then
    begin
      if FSpaceDown or FMousePressed or MouseInControl then
      begin
        Result := GetOfficeXPDownedSelColor;
        FOfficeMarkColor := clHighlightText;
      end else
        Result := GetOfficeXPDownedColor;
    end else
    if FSpaceDown or (FMousePressed and MouseInControl) then
    begin
      Result := GetOfficeXPDownedSelColor;
      FOfficeMarkColor := clHighlightText;
    end else
    if FMousePressed or MouseInControl then
      Result := GetOfficeXPSelColor;
  end else
  begin
    Result := FBoxUncheckedColor;

    St := GetDrawState;

    if not Enabled then
      Result := FBoxDisabledColor
    else if InToggle then
      Result := FBoxToggleColor
    else
    if St = sccbGrayed then
      Result := FBoxGrayedColor
    else
    if St = sccbChecked then
      Result := FBoxCheckedColor;
  end;    
end;

procedure TSCCustomCheckbox.DoMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMousePressed := Button = mbLeft;

  if FMousePressed and not FSpaceDown then
    Invalidate;

  inherited DoMouseDown(Button, Shift, X, Y);
end;

procedure TSCCustomCheckbox.MouseInControlChanged;
begin
  if FMousePressed or (FStyle <> sccsWin2k) then
    Invalidate;
end;

procedure TSCCustomCheckbox.DoMouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  AState: TSCCheckState;
begin
  if FMousePressed or MouseIsDown then
  begin
    FMousePressed := False;

    if MouseInControl then
    begin
      AState := FState;
      Toggle;
      
      if AState = FState then
        Invalidate;
    end else
      Invalidate;
  end;

  inherited DoMouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomCheckbox.Paint;
var
  CR, R, Tr: TRect;
  TopColor, BtmColor: TColor;
begin
  if not HandleAllocated then
    Exit;

  CR := ClientRect;

  R := CR;
  with Canvas do
  begin
    Brush.Style := bsSolid;

    if (FGradient = scgNone) or
      (FGradientEnd = Self.Color) or (FGradientEnd = clNone) then
    begin
      Brush.Color := Self.Color;
      FillRect(R);

      if Transparent then
        PaintParentOn(Canvas);
    end else
    begin
      TopColor := Self.Color;
      BtmColor := FGradientEnd;

      scDrawGradient(Canvas, R, FGradient, TopColor, BtmColor);
    end;
  end;

  DrawPicture(Canvas);

  FInnerRect := CR;

  case FStyle of
    sccsCorel:
      DoDrawCorelCb;
    sccsFlat, sccsFlatFrame,
    sccsFlatEx, sccsFlatDouble:
      DoDrawFlatCb;
    sccsImage:
      DoDrawImageCb;
    sccsMac:
      DoDrawMacCb;
    sccsMetal:
      DoDrawMetalCb;
    sccsOfficeXP:
      DoDrawOfficeXPCb;
    sccsXP:
      DoDrawXPCb;
    else
      DoDrawWin2kCb;
  end;

  R := FInnerRect;
  if FAlignment = taRightJustify then
    OffsetRect(R, 2, 0)
  else
    OffsetRect(R, -2, 0);

  Tr := R;
  if FMultiline or (FLayout <> scclMiddle) or (FShowFocus and Active) then
  begin
    Tr := R;
    DoDrawText(Tr, True);

    OffsetRect(Tr, -Tr.Left, -Tr.Top);
    if FAlignment = taRightJustify then
      OffsetRect(Tr, R.Left, 0)
    else
      OffsetRect(Tr, R.Right - Tr.Right, 0);

    case FLayout of
      scclTop:
        OffsetRect(Tr, 0, 0);
      scclMiddle:
        OffsetRect(Tr, 0, R.Top + ((R.Bottom - R.Top) - (Tr.Bottom - Tr.Top)) div 2);
      scclBottom:
        OffsetRect(Tr, 0, R.Bottom - Tr.Bottom);
    end;

    R := Tr;
  end;

  DoDrawText(R);

  if FShowFocus and Active and not IsRectEmpty(R) then
  begin
    DoDrawText(R, True);
    InflateRect(R, 2, 1);
    Inc(R.Bottom);

    IntersectRect(R, R, CR);

    OffsetRect(R, 0, -R.Top);
    
    case FLayout of
      scclTop:
        OffsetRect(R, 0, CR.Top);
      scclMiddle:
        OffsetRect(R, 0, CR.Top + (CR.Bottom - CR.Top - (R.Bottom - R.Top)) div 2);
      scclBottom:
        OffsetRect(R, 0, CR.Bottom - (R.Bottom - R.Top));
    end;

    IntersectRect(R, R, CR);

    if not IsRectEmpty(R) then
      with Canvas do
      begin
        Brush.Color := Self.Color;
        Brush.Style := bsSolid;

        scDrawFocusRect(Canvas, R, Self.Color);
      end;
  end;
end;

procedure TSCCustomCheckbox.SetAlignment(Value: TLeftRight);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetAllowGrayed(Value: Boolean);
begin
  if FAllowGrayed <> Value then
  begin
    FAllowGrayed := Value;
    if not FAllowGrayed then
      SwitchGrayed;
  end;
end;

procedure TSCCustomCheckbox.SetBoxCheckedColor(Value: TColor);
begin
  if FBoxCheckedColor <> Value then
  begin
    FBoxCheckedColor := Value;
    if FStyle <> sccsImage then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetBoxGrayedColor(Value: TColor);
begin
  if FBoxGrayedColor <> Value then
  begin
    FBoxGrayedColor := Value;

    if (FStyle <> sccsImage) and (FState = sccbGrayed) and
      not (FMousePressed and MouseInControl) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetMarkColor(Value: TColor);
begin
  if FMarkColor <> Value then
  begin
    FMarkColor := Value;
    if (FStyle <> sccsImage) and (FState = sccbChecked) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetChecked(Value: Boolean);
begin
  if GetChecked <> Value then
  begin
    if FState = sccbChecked then
      SetState(sccbUnchecked)
    else
      SetState(sccbChecked);

    Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    if FStyle = sccsXP then Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetHottrackColor(Value: TColor);
begin
  if FHottrackColor <> Value then
  begin
    FHottrackColor := Value;
    if FStyle = sccsXP then Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetImageChecked(Value: TImageIndex);
begin
  if FImageChecked <> Value then
  begin
    FImageChecked := Value;
    if (FStyle = sccsImage) and (FState = sccbChecked) and
      (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetImageGrayed(Value: TImageIndex);
begin
  if FImageGrayed <> Value then
  begin
    FImageGrayed := Value;
    if (FStyle = sccsImage) and (FState = sccbGrayed) and
      (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetImageToggle(Value: TImageIndex);
begin
  if FImageToggle <> Value then
  begin
    FImageToggle := Value;
    if (FStyle = sccsImage) and
      InToggle and (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetImageUnchecked(Value: TImageIndex);
begin
  if FImageUnchecked <> Value then
  begin
    FImageUnchecked := Value;
    if (FStyle = sccsImage) and (FState = sccbUnchecked) and (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetLayout(Value: TSCCheckboxLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetShowFocus(Value: Boolean);
begin
  if FShowFocus <> Value then
  begin
    FShowFocus := Value;
    if Active then Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetState(Value: TSCCheckState);
begin
  if FState <> Value then
  begin
    Value := CanUpdateState(Value);

    if FState <> Value then
    begin
      FState := Value;
      SwitchGrayed;
      Invalidate;
      StateChanged;

      Inc(FStateChanging);
      try
        // inherited Changed;
        Click;
      finally
        Dec(FStateChanging);
      end;
    end;
  end;  
end;

procedure TSCCustomCheckbox.SetStyle(Value: TSCCheckboxStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
    AdjustBounds;
  end;
end;

procedure TSCCustomCheckbox.StopTracking;
begin
  FSpaceDown := False;
  FMousePressed := False;
  inherited StopTracking;
end;

function TSCCustomCheckbox.SwitchGrayed: Boolean;
begin
  Result := not FAllowGrayed and (FState = sccbGrayed);

  if Result then
  begin
    FState := sccbChecked;
    Invalidate;
  end;
end;

function TSCCustomCheckbox.SwitchState(S: TSCCheckState): TSCCheckState;
begin
  Result := S;
  case Result of
    sccbChecked:
      Result := sccbUnchecked;
    sccbUnchecked:
      if FAllowGrayed then
        Result := sccbGrayed else
        Result := sccbChecked;
    sccbGrayed:
      Result := sccbChecked;
  end;
end;

procedure TSCCustomCheckbox.Toggle;
begin
  SetState(SwitchState(FState));
end;

procedure TSCCustomCheckbox.SetBoxToggleColor(Value: TColor);
begin
  if FBoxToggleColor <> Value then
  begin
    FBoxToggleColor := Value;
    if (FStyle <> sccsImage) and
      (FMousePressed and MouseInControl) then Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetBoxUncheckedColor(Value: TColor);
begin
  if FBoxUncheckedColor <> Value then
  begin
    FBoxUncheckedColor := Value;
    if (FStyle <> sccsImage) and (FState = sccbUnchecked) and
      not (FMousePressed and MouseInControl) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetShowCheckMark(Value: Boolean);
begin
  if FShowCheckMark <> Value then
  begin
    FShowCheckMark := Value;
    if (FStyle <> sccsImage) and (FState in [sccbChecked, sccbGrayed]) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetMarkGrayedColor(Value: TColor);
begin
  if FMarkGrayedColor <> Value then
  begin
    FMarkGrayedColor := Value;
    if (FStyle <> sccsImage) and (FState = sccbGrayed) then
      Invalidate;
  end;
end;

function TSCCustomCheckbox.InToggle: Boolean;
begin
  Result := FSpaceDown or (MouseInControl and (FMousePressed or MouseIsDown));
end;

procedure TSCCustomCheckbox.DoDrawMark(R: TRect; AColor: TColor);
var
  MR: TRect;
  Cl: TColor;
  L, T, I: Integer;
  St: TSCCheckState;
  Pts: array[0..2] of TPoint;
begin
  St := GetDrawState;

  if (Canvas = nil) or not FShowCheckMark or
    (St = sccbUnchecked) or not CanGetClientRect then
    Exit;

  Cl := AColor;
  if Cl = clNone then
  begin
    if not Self.Enabled then
      Cl := FMarkDisabledColor
    else if St = sccbGrayed then
      Cl := FMarkGrayedColor
    else
      Cl := FMarkColor;
  end;

  MR := R;
  if FStyle = sccsMac then
  begin
    with Canvas.Pen do
    begin
      Style := psSolid;
      Mode  := pmCopy;
      Width := 1;
      Color := Cl;
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
  if FStyle = sccsImage then
  begin
    if St = sccbGrayed then
    begin
      if IsValidImage(FImageGrayed) then
        Images.Draw(Canvas, R.Left, R.Top, FImageMarkGrayed, True);
    end else
    if St = sccbChecked then
    begin
      if not Enabled and IsValidImage(FImageMarkDisabled) then
        Images.Draw(Canvas, R.Left, R.Top, FImageMarkDisabled, True)
      else if IsValidImage(FImageMark) then
        Images.Draw(Canvas, R.Left, R.Top, FImageMark, True);
    end;
  end else
  begin
    with Canvas.Pen do
    begin
      Style := psSolid;
      Mode  := pmCopy;
      Width := 1;
      Color := Cl;
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

procedure TSCCustomCheckbox.SetImageMark(Value: TImageIndex);
begin
  if FImageMark <> Value then
  begin
    FImageMark := Value;
    if (FStyle = sccsImage) and (FState = sccbChecked) and (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetImageMarkGrayed(Value: TImageIndex);
begin
  if FImageMarkGrayed <> Value then
  begin
    FImageMarkGrayed := Value;
    if (FStyle = sccsImage) and (FState = sccbGrayed) and (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetBoxFrameColor(Value: TColor);
begin
  if FBoxFrameColor <> Value then
  begin
    FBoxFrameColor := Value;
    if FStyle in [sccsXP, sccsFlatEx, sccsFlatDouble] then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetMultiline(Value: Boolean);
begin
  if FMultiline <> Value then
  begin
    FMultiline := Value;
    AdjustBounds;
    Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetGradient(Value: TSCGradient);
begin
  if FGradient <> Value then
  begin
    FGradient := Value;
    if (FGradientEnd <> Color) and
      (FGradientEnd <> clNone) then Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetGradientEnd(Value: TColor);
begin
  if FGradientEnd <> Value then
  begin
    FGradientEnd := Value;
    if (FGradient <> scgNone) and
      (Value <> Color) and (Value <> clNone) then Invalidate;
  end;
end;

procedure TSCCustomCheckbox.AdjustBounds;
var
  R: TRect;
  X: Integer;
  AAlignment: TAlignment;
begin
  if not IsReading and AutoSize then
  begin
    R := GetAdjustedRect(Width, Height);
    OffsetRect(R, -R.Left, -R.Top);

    AAlignment := taRightJustify;
    if FAlignment = taRightJustify then
      AAlignment := taLeftJustify;

    if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);

    X := Left;
    if AAlignment = taRightJustify then Inc(X, Width - R.Right);
    SetBounds(X, Top, R.Right, R.Bottom);
  end;
end;

function TSCCustomCheckbox.GetBoxHeight: Integer;
begin
  Result := 13;
  if FStyle = sccsMac then
    Result := 12
  else
  if (FStyle = sccsMac) and (Images <> nil) then
    Result := Images.Height;
end;

function TSCCustomCheckbox.GetBoxWidth: Integer;
begin
  Result := 13;
  if FStyle = sccsMac then
    Result := 12
  else
  if (FStyle = sccsImage) and (Images <> nil) then
    Result := Images.Width;
end;

procedure TSCCustomCheckbox.SpacingChanged;
begin
  Invalidate;
end;

procedure TSCCustomCheckbox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_SPACE) and not FMousePressed then
  begin
    if FSpaceDown then
    begin
      Key := 0;
      Exit;
    end;

    FSpaceDown := True;
    if not FMousePressed then
      Invalidate;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomCheckbox.KeyUp(var Key: Word; Shift: TShiftState);
var
  AState: TSCCheckState;
begin
  if FSpaceDown and (Key in [VK_SPACE, VK_ESCAPE]) then
  begin
    FSpaceDown := False;
    if Key = VK_ESCAPE then
      Invalidate
    else begin
      AState := FState;
      Toggle;

      if AState = FState then
        Invalidate;
    end;
  end;

  inherited KeyUp(Key, Shift);
end;

function TSCCustomCheckbox.GetBlendValue: Word;
begin
  Result := 0;
end;

procedure TSCCustomCheckbox.TransparentChanged;
begin
  if (FGradient = scgNone) or (FGradientEnd = Self.Color) or
    (FGradientEnd = clNone) then
    Invalidate;
end;

function TSCCustomCheckbox.CanUpdateState(
  Value: TSCCheckState): TSCCheckState;
begin
  Result := Value;
end;

function TSCCustomCheckbox.GetDrawState: TSCCheckState;
begin
  Result := FState;
end;

procedure TSCCustomCheckbox.StateChanged;
begin
  //
end;

function TSCCustomCheckbox.GetAdjustedRect(NewWidth, NewHeight: Integer): TRect;
var
  DC: HDC;
  W, H, Bs: Integer;
begin
  Result := BoundsRect;
  if not CanGetClientRect then Exit;

  Result := ClientRect;

  DC := GetDC(0);
  try
    Canvas.Handle := DC;
    DoDrawText(Result, True);
    Canvas.Handle := 0;
  finally
    ReleaseDC(0, DC);
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  Inc(Result.Right, W + Indent + Spacing);
  if Result.Bottom < H then Result.Bottom := H;

  Bs := GetBorderSize + BorderWidth + GetInnerBorderSize;
  Bs := 2*Bs;

  InflateRect(Result, Bs + 2, Bs + 2);
end;

procedure TSCCustomCheckbox.FocusChanged;
begin
  FSpaceDown := False;
  FMousePressed := False;
  Invalidate;
end;

procedure TSCCustomCheckbox.EnabledChanged;
begin
  FSpaceDown := False;
  FMousePressed := False;
  inherited EnabledChanged;
end;

procedure TSCCustomCheckbox.SetBoxDisabledColor(Value: TColor);
begin
  if FBoxDisabledColor <> Value then
  begin
    FBoxDisabledColor := Value;
    if (FStyle <> sccsImage) and not Enabled then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetImageDisabled(Value: TImageIndex);
begin
  if FImageDisabled <> Value then
  begin
    FImageDisabled := Value;
    if (FStyle = sccsImage) and not Enabled and (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetMarkDisabledColor(Value: TColor);
begin
  if FMarkDisabledColor <> Value then
  begin
    FMarkDisabledColor := Value;
    if (FStyle <> sccsImage) and not Enabled then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.SetImageMarkDisabled(Value: TImageIndex);
begin
  if FImageMarkDisabled <> Value then
  begin
    FImageMarkDisabled := Value;
    if (FStyle = sccsImage) and not Enabled and
      (FState = sccbChecked) and (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomCheckbox.DoDrawMetalCb;
var
  Cl: TColor;
  CR, R: TRect;
  W, H: Integer;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scclBottom:
      R.Top := R.Bottom - H;
    scclMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scclTop:
    begin
      R.Bottom := R.Top + H;
    end;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  Cl := GetBoxFaceColor;
  
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Cl;

    if Brush.Color <> clNone then
      FillRect(R);
  end;

  DoDrawMark(R);

  scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
  scFrame3D(Canvas, R, Cl, clBtnFace, 1, 0);
end;

{ TSCCustomRadioButton }

procedure TSCCustomRadioButton.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomRadioButton then
  begin
    with TSCCustomRadioButton(Source) do
    begin
      Self.Alignment := Alignment;
      Self.AsCheckbox := AsCheckbox;
      Self.BoxCheckedColor := BoxCheckedColor;
      Self.BoxDisabledColor := BoxDisabledColor;
      Self.BoxFrameColor := BoxFrameColor;
      Self.BoxToggleColor := BoxToggleColor;
      Self.BoxUncheckedColor := BoxUncheckedColor;
      Self.Checked := Checked;
      Self.Gradient := Gradient;
      Self.GradientEnd := GradientEnd;
      Self.HighlightColor := HighlightColor;
      Self.HottrackColor := HottrackColor;
      Self.ImageChecked := ImageChecked;
      Self.ImageDisabled := ImageDisabled;
      Self.ImageToggle := ImageToggle;
      Self.ImageUnchecked := ImageUnchecked;
      Self.ImageMark := ImageMark;
      Self.ImageMarkDisabled := ImageMarkDisabled;
      Self.Layout := Layout;
      Self.MarkColor := MarkColor;
      Self.MarkDisabledColor := MarkDisabledColor;
      Self.Multiline := Multiline;
      Self.ShowCheckMark := ShowCheckMark;
      Self.ShowFocus := ShowFocus;
      Self.Style := Style;
    end;
  end;
end;

procedure TSCCustomRadioButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
    begin
      SetFocus;
      if HasFocus then Toggle;
      Result := 1;
    end else
      inherited;
end;

procedure TSCCustomRadioButton.CNCommand(var Message: TWMCommand);
begin
  case Message.NotifyCode of
    BN_CLICKED: SetChecked(True);
    BN_DOUBLECLICKED: DblClick;
  end;
end;

constructor TSCCustomRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csSetCaption, csOpaque, csDoubleClicks];
  SetBounds(Left, Top, 115, 17);
  DoubleBuffered := True;
  TabStop := False;
  ParentColor := True;

  FAlignment := taRightJustify;
  FBoxCheckedColor := clWindow;
  FBoxDisabledColor := clBtnFace;
  FBoxFrameColor := clBtnShadow;
  FBoxToggleColor := clBtnFace;
  FBoxUncheckedColor := clWindow;
  FGradient := scgNone;
  FGradientEnd := clBlue;
  FHighlightColor := SC_HighlightColor;
  FHottrackColor := SC_HottrackColor;
  FImageChecked := -1;
  FImageToggle := -1;
  FImageUnchecked := -1;
  FImageMark := -1;
  FImageMarkDisabled := -1;
  FLayout := scrlMiddle;
  FMarkColor := clWindowText;
  FMarkDisabledColor := clGrayText;
  FShowCheckMark := True;
  FShowFocus := True;
  FStyle := scrsWin2k;
end;

procedure TSCCustomRadioButton.DoDrawCorelCb;
var
  CR, R: TRect;
  W, H: Integer;
begin
  if (Canvas = nil) or not CanGetClientRect then Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scrlBottom:
      R.Top := R.Bottom - H;
    scrlMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scrlTop:
      R.Bottom := R.Top + H;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor;

    if Brush.Color <> clNone then
      FillRect(R);
  end;

  DoDrawMark(R);

  scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
  if HasFocus or FMousePressed or MouseInControl then
    scFrame3D(Canvas, R, cl3DDkShadow, clBtnFace, 1, 0);
end;

procedure TSCCustomRadioButton.DoDrawFlatCb;
var
  W, H: Integer;
  CR, R: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scrlBottom:
      R.Top := R.Bottom - H;
    scrlMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scrlTop:
      R.Bottom := R.Top + H;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor;

    if Brush.Color <> clNone then
      FillRect(R);
  end;

  DoDrawMark(R);

  case FStyle of
    scrsFlat:
    begin
      if HasFocus or FMousePressed or MouseInControl then
        scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
    end;
    scrsFlatFrame:
    begin
      scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
      if HasFocus or FMousePressed or MouseInControl then
        scFrame3D(Canvas, R, cl3DDkShadow, clBtnFace, 1, 0)
      else
        scFrame3D(Canvas, R, clBtnFace, clBtnFace, 1, 0)
    end;
  end;  
end;

procedure TSCCustomRadioButton.DoDrawImageCb;
var
  CR, R: TRect;
  Img: TImageIndex;
  ImgW, ImgH: Integer;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  ImgW := 0; ImgH := 0;
  if Images <> nil then
  begin
    ImgW := Images.Width;
    ImgH := Images.Height;
  end;

  R := CR;
  R.Right := R.Left + ImgW;

  case FLayout of
    scrlBottom:
      R.Top := R.Bottom - ImgH;
    scrlMiddle:
    begin
      R.Top := (R.Bottom - R.Top - ImgH) div 2;
      R.Bottom := R.Top + ImgH;
    end;
    scrlTop:
      R.Bottom := R.Top + ImgH;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - ImgW;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  Img := FImageUnchecked;

  if not Enabled then
    Img := FImageDisabled
  else if InToggle then
    Img := FImageToggle
  else
  if FChecked then
    Img := FImageChecked;

  if IsValidImage(Img) then
    Images.Draw(Canvas, R.Left, R.Top, Img, True);

  DoDrawMark(R);
end;

procedure TSCCustomRadioButton.DoDrawMacCb;
var
  W, H: Integer;
  CR, R, R2: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scrlBottom:
      R.Top := R.Bottom - H;
    scrlMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scrlTop:
      R.Bottom := R.Top + H;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor;

    if Brush.Color <> clNone then
      FillRect(R);
  end;

  R2 := R;
  scFrame3D(Canvas, R2, clWindowFrame, clWindowFrame, 1, 0);
  scFrame3D(Canvas, R2, clBtnHighlight, clBtnShadow, 1, 0);

  DoDrawMark(R);
end;

procedure TSCCustomRadioButton.DoDrawOfficeXPCb;
var
  W, H: Integer;
  CR, R, R2: TRect;
  Pts: array[0..8] of TPoint;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scrlBottom:
      R.Top := R.Bottom - H;
    scrlMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scrlTop:
      R.Bottom := R.Top + H;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor;

    FillRect(R);
  end;

  if FChecked then
  begin
    R2 := R;
    
    if FAsCheckBox then
      DoDrawMark(R2, FOfficeMarkColor)
    else begin
      InflateRect(R2, -4, -4);

      Dec(R2.Right);
      Dec(R2.Bottom);

      GenerateOctPoints(R2, 1, Pts);

      with Canvas do
      begin
        Brush.Color := FOfficeMarkColor;
        Pen.Style := psSolid;
        Pen.Color := FOfficeMarkColor;

        Polygon(Pts);
      end;
    end;
  end;

  scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
end;

procedure TSCCustomRadioButton.DoDrawText(var R: TRect; CalcRect: Boolean);
var
  Text: String;
  TxtFlags: Integer;
begin
  if (Canvas = nil) or not (CanGetClientRect and
    (CalcRect or not IsRectEmpty(R))) then
    Exit;

  TxtFlags := DT_LEFT or DT_EXPANDTABS;
  if FAlignment = taLeftJustify then
    TxtFlags := DT_RIGHT or DT_EXPANDTABS;

  if not CalcRect then
    IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);

  Text := Caption;
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

    if not CalcRect and not Enabled then
    begin
      OffsetRect(R, 1, 1);
      Font.Color := clBtnHighlight;

      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);

      OffsetRect(R, -1, -1);
      Font.Color := clBtnShadow;

      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);
    end else
      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);

    if not CalcRect then
      SelectClipRgn(Handle, 0);
  end;
end;

procedure TSCCustomRadioButton.DoDrawWin2kCb;
var
  CR, R: TRect;
  W, H: Integer;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scrlBottom:
      R.Top := R.Bottom - H;
    scrlMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scrlTop:
      R.Bottom := R.Top + H;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor;

    if Brush.Color <> clNone then
      FillRect(R);
  end;

  DoDrawMark(R);

  scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
  scFrame3D(Canvas, R, cl3DDkShadow, clBtnFace, 1, 0);
end;

procedure TSCCustomRadioButton.DoDrawXPCb;
var
  CR, R: TRect;
  W, H: Integer;
  Track: Boolean;
  TrackColor, TopColor, BtmColor: TColor;
begin
  if (Canvas = nil) or not CanGetClientRect then Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scrlBottom:
      R.Top := R.Bottom - H;
    scrlMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scrlTop:
      R.Bottom := R.Top + H;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetBoxFaceColor;

    if Brush.Color <> clNone then
      FillRect(R);
  end;

  DoDrawMark(R);

  // highligh or hottrack frame
  Track := False;
  TrackColor := clNone;

  if not FMousePressed and MouseInControl then
  begin
    Track := True;
    TrackColor := FHottrackColor;
  end else
  if (FMousePressed and not MouseInControl) or
    (HasFocus and not (FMousePressed or MouseInControl)) then
  begin
    Track := True;
    TrackColor := FHighlightColor
  end;

  InflateRect(R, -1, -1);

  if Track and not IsRectEmpty(R) then
  begin
    if InToggle then
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

    InflateRect(R, 2, 2);
  end;

  InflateRect(R, 1, 1);
  scFrame3D(Canvas, R, FBoxFrameColor, FBoxFrameColor, 1, 0);
end;

function TSCCustomRadioButton.GetBoxFaceColor: TColor;
begin
  if FStyle = scrsOfficeXP then
  begin
    Result := GetOfficeXPBtnColor;
    FOfficeMarkColor := clBtnText;

    if Checked then
    begin
      if FSpaceDown or
        FMousePressed or MouseInControl then
      begin
        Result := GetOfficeXPDownedSelColor;
        FOfficeMarkColor := clHighlightText;
      end else
        Result := GetOfficeXPDownedColor;
    end else
    if FSpaceDown or
      (FMousePressed and MouseInControl) then
    begin
      Result := GetOfficeXPDownedSelColor;
      FOfficeMarkColor := clHighlightText;
    end else
    if FMousePressed or MouseInControl then
      Result := GetOfficeXPSelColor;
  end else
  begin
    Result := FBoxUncheckedColor;

    if not Enabled then
      Result := FBoxDisabledColor
    else if InToggle then
      Result := FBoxToggleColor
    else
    if FChecked then
      Result := FBoxCheckedColor;
  end;    
end;

procedure TSCCustomRadioButton.MouseInControlChanged;
begin
  if FMousePressed or (FStyle <> scrsWin2k) then
    Invalidate;
end;

procedure TSCCustomRadioButton.Paint;
var
  CR, R, Tr: TRect;
  TopColor, BtmColor: TColor;
begin
  if not HandleAllocated then
    Exit;

  CR := ClientRect;

  R := CR;
  with Canvas do
  begin
    Brush.Style := bsSolid;

    if (FGradient = scgNone) or
      (FGradientEnd = Self.Color) or (FGradientEnd = clNone) then
    begin
      Brush.Color := Self.Color;
      FillRect(R);

      if Transparent then
        PaintParentOn(Canvas);
    end else
    begin
      TopColor := Self.Color;
      BtmColor := FGradientEnd;

      scDrawGradient(Canvas, R, FGradient, TopColor, BtmColor);
    end;
  end;

  DrawPicture(Canvas);

  FInnerRect := CR;

  if not FAsCheckbox then
    DoDrawAsRadio
  else begin
    case FStyle of
      scrsCorel:
        DoDrawCorelCb;
      scrsFlat, scrsFlatFrame:
        DoDrawFlatCb;
      scrsImage:
        DoDrawImageCb;
      scrsMac:
        DoDrawMacCb;
      scrsMetal:
        DoDrawMetalCb;
      scrsOfficeXP:
        DoDrawOfficeXPCb;
      scrsXP:
        DoDrawXPCb;
      else
        DoDrawWin2kCb;
    end;
  end;

  R := FInnerRect;
  if FAlignment = taRightJustify then
    OffsetRect(R, 2, 0)
  else
    OffsetRect(R, -2, 0);

  Tr := R;
  if FMultiline or (FShowFocus and Active) then
  begin
    Tr := R;
    DoDrawText(Tr, True);

    OffsetRect(Tr, -Tr.Left, -Tr.Top);
    if FAlignment = taRightJustify then
      OffsetRect(Tr, R.Left, 0)
    else
      OffsetRect(Tr, R.Right - Tr.Right, 0);

    case FLayout of
      scrlTop:
        OffsetRect(Tr, 0, 0);
      scrlMiddle:
        OffsetRect(Tr, 0, R.Top + ((R.Bottom - R.Top) - (Tr.Bottom - Tr.Top)) div 2);
      scrlBottom:
        OffsetRect(Tr, 0, R.Bottom - Tr.Bottom);
    end;

    R := Tr;
  end;

  DoDrawText(R);

  if FShowFocus and Active and not IsRectEmpty(R) then
  begin
    DoDrawText(R, True);
    InflateRect(R, 2, 1);
    Inc(R.Bottom);

    IntersectRect(R, R, CR);

    OffsetRect(Tr, -Tr.Left, -Tr.Top);
    if FAlignment = taRightJustify then
      OffsetRect(Tr, R.Left, 0)
    else
      OffsetRect(Tr, R.Right - Tr.Right, 0);

    case FLayout of
      scrlTop:
        OffsetRect(Tr, 0, 0);
      scrlMiddle:
        OffsetRect(Tr, 0, R.Top + ((R.Bottom - R.Top) - (Tr.Bottom - Tr.Top)) div 2);
      scrlBottom:
        OffsetRect(Tr, 0, R.Bottom - Tr.Bottom);
    end;

    IntersectRect(R, R, CR);

    if not IsRectEmpty(R) then
      with Canvas do
      begin
        Brush.Color := Self.Color;
        Brush.Style := bsSolid;

        scDrawFocusRect(Canvas, R, Self.Color);
      end;
  end;
end;

procedure TSCCustomRadioButton.SetAlignment(Value: TLeftRight);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetBoxCheckedColor(Value: TColor);
begin
  if FBoxCheckedColor <> Value then
  begin
    FBoxCheckedColor := Value;
    if FStyle <> scrsImage then
      Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetMarkColor(Value: TColor);
begin
  if FMarkColor <> Value then
  begin
    FMarkColor := Value;
    if (FStyle <> scrsImage) and FChecked then
      Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetChecked(Value: Boolean);

  procedure SwitchNeighboursOff;
  var
    I: Integer;
    Control: TControl;
  begin
    if Parent <> nil then
      with Parent do
        for I := 0 to ControlCount - 1 do
        begin
          Control := Controls[I];
          if (Control <> Self) and (Control is TSCCustomRadioButton) then
            TSCCustomRadioButton(Control).SetChecked(False);
        end;
  end;

begin
  if GetChecked <> Value then
  begin
    FChecked := Value;
    TabStop := Value;

    Invalidate;

    if Value then
    begin
      SwitchNeighboursOff;
      inherited Changed;
      Click;

      Invalidate;
    end;
  end;
end;

procedure TSCCustomRadioButton.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    if FStyle = scrsXP then Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetHottrackColor(Value: TColor);
begin
  if FHottrackColor <> Value then
  begin
    FHottrackColor := Value;
    if FStyle = scrsXP then Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetImageChecked(Value: TImageIndex);
begin
  if FImageChecked <> Value then
  begin
    FImageChecked := Value;
    if (FStyle = scrsImage) and FChecked and (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetImageToggle(Value: TImageIndex);
begin
  if FImageToggle <> Value then
  begin
    FImageToggle := Value;
    if (FStyle = scrsImage) and
      InToggle and (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetImageUnchecked(Value: TImageIndex);
begin
  if FImageUnchecked <> Value then
  begin
    FImageUnchecked := Value;
    if (FStyle = scrsImage) and
      not FChecked and (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetLayout(Value: TSCRadioLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetShowFocus(Value: Boolean);
begin
  if FShowFocus <> Value then
  begin
    FShowFocus := Value;
    if Active then Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetStyle(Value: TSCRadioStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
    AdjustBounds;
  end;
end;

procedure TSCCustomRadioButton.StopTracking;
begin
  FMouseKeysDown := False;
  FMousePressed := False;
  inherited StopTracking;
end;

procedure TSCCustomRadioButton.Toggle;
begin
  if IsDesigning or IsLoading then
    SetChecked(not Checked)
  else
    SetChecked(True);
end;

procedure TSCCustomRadioButton.SetBoxToggleColor(Value: TColor);
begin
  if FBoxToggleColor <> Value then
  begin
    FBoxToggleColor := Value;
    if (FStyle <> scrsImage) and
      (FMousePressed and MouseInControl) then Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetBoxUncheckedColor(Value: TColor);
begin
  if FBoxUncheckedColor <> Value then
  begin
    FBoxUncheckedColor := Value;
    if (FStyle <> scrsImage) and not FChecked and
      not (FMousePressed and MouseInControl) then Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetShowCheckMark(Value: Boolean);
begin
  if FShowCheckMark <> Value then
  begin
    FShowCheckMark := Value;
    if (FStyle <> scrsImage) and FChecked then
      Invalidate;
  end;
end;

function TSCCustomRadioButton.InToggle: Boolean;
begin
  Result := FSpaceDown or (MouseInControl and (FMousePressed or MouseIsDown));
end;

procedure TSCCustomRadioButton.DoDrawMark(R: TRect; AColor: TColor);
var
  MR: TRect;
  Cl: TColor;
  L, T, I: Integer;
  Pts: array[0..2] of TPoint;
begin
  if (Canvas = nil) or not FShowCheckMark or
    not FChecked or not CanGetClientRect then
    Exit;

  Cl := AColor;
  if Cl = clNone then
  begin
    if not Self.Enabled then
      Cl := FMarkDisabledColor
    else
      Cl := FMarkColor;
  end;

  MR := R;
  if FStyle = scrsMac then
  begin
    with Canvas.Pen do
    begin
      Style := psSolid;
      Mode  := pmCopy;
      Width := 1;
      Color := Cl;
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
    if FChecked then
    begin
      if not Enabled and IsValidImage(FImageMarkDisabled) then
        Images.Draw(Canvas, R.Left, R.Top, FImageMarkDisabled, True)
      else if IsValidImage(FImageMark) then
        Images.Draw(Canvas, R.Left, R.Top, FImageMark, True);
    end else
    if IsValidImage(FImageChecked) then
      Images.Draw(Canvas, R.Left, R.Top, FImageChecked, True)
  end else
  begin
    with Canvas.Pen do
    begin
      Style := psSolid;
      Mode  := pmCopy;
      Width := 1;
      Color := Cl;
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

procedure TSCCustomRadioButton.SetImageMark(Value: TImageIndex);
begin
  if FImageMark <> Value then
  begin
    FImageMark := Value;
    if (FStyle = scrsImage) and
      FChecked and (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetBoxFrameColor(Value: TColor);
begin
  if FBoxFrameColor <> Value then
  begin
    FBoxFrameColor := Value;
    if FStyle = scrsXP then Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetMultiline(Value: Boolean);
begin
  if FMultiline <> Value then
  begin
    FMultiline := Value;
    AdjustBounds;
    Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetGradient(Value: TSCGradient);
begin
  if FGradient <> Value then
  begin
    FGradient := Value;
    if (FGradientEnd <> Color) and
      (FGradientEnd <> clNone) then Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetGradientEnd(Value: TColor);
begin
  if FGradientEnd <> Value then
  begin
    FGradientEnd := Value;
    if (FGradient <> scgNone) and
      (Value <> Color) and (Value <> clNone) then Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetAsCheckbox(Value: Boolean);
begin
  if FAsCheckbox <> Value then
  begin
    FAsCheckbox := Value;
    Invalidate;
  end;
end;

procedure TSCCustomRadioButton.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
    if (CharCode = VK_DOWN) and
      (KeyDataToShiftState(KeyData) = []) and CanFocus then
    begin
      SetChecked(True);
      Result := 1;
    end else
      inherited;
end;

procedure TSCCustomRadioButton.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if not FMouseKeysDown then
    Toggle;
end;

procedure TSCCustomRadioButton.AdjustBounds;
const
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  X: Integer;
  R: TRect;
  AAlignment: TAlignment;
begin
  if not IsReading and AutoSize then
  begin
    R := GetAdjustedRect(Width, Height);
    OffsetRect(R, -R.Left, -R.Top);

    AAlignment := taRightJustify;
    if FAlignment = taRightJustify then
      AAlignment := taLeftJustify;

    if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);

    X := Left;
    if AAlignment = taRightJustify then Inc(X, Width - R.Right);
    SetBounds(X, Top, R.Right, R.Bottom);
  end;
end;

function TSCCustomRadioButton.GetBoxHeight: Integer;
begin
  Result := 13;
  if FStyle = scrsMac then Result := 12;

  if not FAsCheckbox and (FStyle <> scrsOfficeXP) then
    Dec(Result);

  if (FStyle = scrsImage) and (Images <> nil) then
    Result := Images.Height;
end;

function TSCCustomRadioButton.GetBoxWidth: Integer;
begin
  Result := 13;
  if FStyle = scrsMac then Result := 12;

  if not FAsCheckbox and (FStyle <> scrsOfficeXP) then
    Dec(Result);

  if (FStyle = scrsImage) and (Images <> nil) then
    Result := Images.Width;
end;

procedure TSCCustomRadioButton.GenerateOctPoints(Rc: TRect; RoundBy: Integer;
  var Pts: array of TPoint);
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

procedure TSCCustomRadioButton.DrawFlatRb(X, Y: Integer; FrmColor, InnerColor,
  CheckColor: TColor);

  function GetBoxRect(Inflate: Integer): TRect;
  begin
    Result := Rect(0, 0, GetBoxWidth, GetBoxHeight);
    OffsetRect(Result, X, Y);

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

procedure TSCCustomRadioButton.DrawMacRb(X, Y: Integer; FrmColor, InnerColor,
  OutterColor, CheckColor: TColor; Pressed: Boolean);

  function GetBoxRect(Inflate: Integer): TRect;
  begin
    Result := Rect(0, 0, GetBoxWidth, GetBoxHeight);
    OffsetRect(Result, X, Y);

    if Inflate > 11 then Inflate := 11;
    InflateRect(Result, Inflate, Inflate);
  end;

var
  R: TRect;
  I, J, Mix: Integer;
  Pts: array[0..8] of TPoint;
  C: TColor;
begin
  if FAlignment = taLeftJustify then Dec(X);

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

procedure TSCCustomRadioButton.DrawWin2kRb(X, Y: Integer; InnerColor, CheckColor: TColor);

  function GetBoxRect(Inflate: Integer): TRect;
  begin
    Result := Rect(0, 0, GetBoxWidth, GetBoxHeight);
    OffsetRect(Result, X, Y);

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

procedure TSCCustomRadioButton.DrawXPRb(X, Y: Integer; FrmColor, InnerColor,
  OutterColor, TrackColor, CheckColor: TColor);

  function GetBoxRect(Inflate: Integer): TRect;
  begin
    Result := Rect(0, 0, GetBoxWidth, GetBoxHeight);
    OffsetRect(Result, X, Y);

    if Inflate > 12 then Inflate := 12;
    InflateRect(Result, Inflate, Inflate);
  end;

var
  R: TRect;
  I, Mid: Integer;
  Pts: array[0..8] of TPoint;
  TrackTopColor, TrackBtmColor: TColor;
begin
  if FAlignment = taLeftJustify then Dec(X);

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

procedure TSCCustomRadioButton.SpacingChanged;
begin
  Invalidate;
end;

procedure TSCCustomRadioButton.DoDrawAsRadio;
var
  C, TCl: TColor;
  W, H: Integer;
  CR, R: TRect;
begin
  if (Canvas = nil) or not CanGetClientRect then Exit;

  if FStyle = scrsImage then
  begin
    DoDrawImageCb;
    Exit;
  end;
  
  if FStyle = scrsOfficeXP then
  begin
    DoDrawOfficeXPCb;
    Exit;
  end;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scrlBottom:
      R.Top := R.Bottom - H;
    scrlMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scrlTop:
      R.Bottom := R.Top + H;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  C := clNone;
  if FChecked then
  begin
    C := FMarkColor;
    if not Self.Enabled then
      C := FMarkDisabledColor;
  end;

  case FStyle of
    scrsCorel:
    begin
      if HasFocus or FMousePressed or MouseInControl then
        DrawWin2kRb(R.Left, R.Top, GetBoxFaceColor, C)
      else
        DrawFlatRb(R.Left, R.Top, clNone, GetBoxFaceColor, C);
    end;
    scrsFlat:
      DrawFlatRb(R.Left, R.Top, clNone, GetBoxFaceColor, C);
    scrsFlatFrame:
    begin
      if HasFocus or FMousePressed or MouseInControl then
        DrawWin2kRb(R.Left, R.Top, GetBoxFaceColor, C)
      else
        DrawFlatFrameRb(R.Left, R.Top, GetBoxFaceColor, C)
    end;
    scrsMetal:
      DrawFlatFrameRb(R.Left, R.Top, GetBoxFaceColor, C);
    scrsImage:
      DoDrawImageCb;
    scrsMac:
      DrawMacRb(R.Left, R.Top, clWindowFrame, clWindow, Self.Color,
        C, FChecked or InToggle);
    scrsOfficeXP:
      DoDrawOfficeXPCb;
    scrsWin2k:
      DrawWin2kRb(R.Left, R.Top, GetBoxFaceColor, C);
    scrsXP:
    begin
      TCl := clNone;
      if not FMousePressed and MouseInControl then
        TCl := FHottrackColor
      else
      if (FMousePressed and not MouseInControl) or
        (HasFocus and not (FMousePressed or MouseInControl)) then
        TCl := FHighlightColor;

      DrawXPRb(R.Left, R.Top, FBoxFrameColor, GetBoxFaceColor,
        Self.Color, TCl, C);
    end;
  end;
end;

procedure TSCCustomRadioButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_SPACE) and not FMousePressed then
  begin
    if FSpaceDown then
    begin
      Key := 0;
      Exit;
    end;

    FSpaceDown := True;
    if not FMousePressed then
      Invalidate;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomRadioButton.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if FSpaceDown and (Key in [VK_SPACE, VK_ESCAPE]) then
  begin
    FSpaceDown := False;
    if Key = VK_ESCAPE then
      Invalidate
    else
      Toggle;
  end;

  inherited KeyUp(Key, Shift);
end;

procedure TSCCustomRadioButton.DoMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseKeysDown := True;

  FMousePressed := Button = mbLeft;
  if FMousePressed and not FSpaceDown then
    Invalidate;

  inherited DoMouseDown(Button, Shift, X, Y);
end;

procedure TSCCustomRadioButton.DoMouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseKeysDown := False;

  if FMousePressed or MouseIsDown then
  begin
    FMousePressed := False;
    if MouseInControl then
      Toggle;

    Invalidate;
  end;

  inherited DoMouseUp(Button, Shift, X, Y);
end;

function TSCCustomRadioButton.GetBlendValue: Word;
begin
  Result := 0;
end;

procedure TSCCustomRadioButton.TransparentChanged;
begin
  if (FGradient = scgNone) or (FGradientEnd = Self.Color) or
    (FGradientEnd = clNone) then
    Invalidate;
end;

function TSCCustomRadioButton.GetAdjustedRect(NewWidth, NewHeight: Integer): TRect;
const
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  DC: HDC;
  W, H, Bs: Integer;
begin
  Result := BoundsRect;
  if not CanGetClientRect then Exit;

  Result := ClientRect;

  DC := GetDC(0);
  try
    Canvas.Handle := DC;
    DoDrawText(Result, True);
    Canvas.Handle := 0;
  finally
    ReleaseDC(0, DC);
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  Inc(Result.Right, W + Indent + Spacing);
  if Result.Bottom < H then Result.Bottom := H;

  Bs := GetBorderSize + BorderWidth + GetInnerBorderSize;
  Bs := 2*Bs;

  InflateRect(Result, Bs + 2, Bs + 2);
end;

procedure TSCCustomRadioButton.FocusChanged;
begin
  FSpaceDown := False;
  FMousePressed := False;
  Invalidate;
end;

procedure TSCCustomRadioButton.EnabledChanged;
begin
  FMouseKeysDown := False;
  FMousePressed := False;
  inherited EnabledChanged;
end;

procedure TSCCustomRadioButton.DrawFlatFrameRb(X, Y: Integer; InnerColor,
  CheckColor: TColor);

  function GetBoxRect(Inflate: Integer): TRect;
  begin
    Result := Rect(0, 0, GetBoxWidth, GetBoxHeight);
    OffsetRect(Result, X, Y);

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

function TSCCustomRadioButton.GetChecked: Boolean;
begin
  Result := FChecked;
end;

procedure TSCCustomRadioButton.SetBoxDisabledColor(Value: TColor);
begin
  if FBoxCheckedColor <> Value then
  begin
    FBoxCheckedColor := Value;
    if (FStyle <> scrsImage) and not Enabled then
      Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetImageDisabled(Value: TImageIndex);
begin
  if FImageChecked <> Value then
  begin
    FImageChecked := Value;
    if (FStyle = scrsImage) and not Enabled and (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetMarkDisabledColor(Value: TColor);
begin
  if FMarkColor <> Value then
  begin
    FMarkColor := Value;
    if (FStyle <> scrsImage) and not Enabled then
      Invalidate;
  end;
end;

procedure TSCCustomRadioButton.SetImageMarkDisabled(Value: TImageIndex);
begin
  if FImageMarkDisabled <> Value then
  begin
    FImageMarkDisabled := Value;
    if (FStyle = scrsImage) and not Enabled and
      FChecked and (Images <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomRadioButton.DoDrawMetalCb;
var
  Cl: TColor;
  CR, R: TRect;
  W, H: Integer;
begin
  if (Canvas = nil) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  W := GetBoxWidth;
  H := GetBoxHeight;

  R := CR;
  R.Right := R.Left + W;

  case FLayout of
    scrlBottom:
      R.Top := R.Bottom - H;
    scrlMiddle:
    begin
      R.Top := (R.Bottom - R.Top - H) div 2;
      R.Bottom := R.Top + H;
    end;
    scrlTop:
      R.Bottom := R.Top + H;
  end;

  if FAlignment = taRightJustify then
  begin
    OffsetRect(R, Indent, 0);
    Inc(FInnerRect.Left, R.Right + Spacing);
  end else
  begin
    R.Right := CR.Right;
    R.Left  := R.Right - W;

    OffsetRect(R, -Indent, 0);

    FInnerRect.Right := R.Left - Spacing;
    if FInnerRect.Right < FInnerRect.Left then
      FInnerRect.Right := FInnerRect.Left;
  end;

  Cl := GetBoxFaceColor;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Cl;

    if Brush.Color <> clNone then
      FillRect(R);
  end;

  DoDrawMark(R);

  scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
  scFrame3D(Canvas, R, Cl, clBtnFace, 1, 0);
end;

{ TSCCustomProgress }

procedure TSCCustomProgress.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomProgress then
    with TSCCustomProgress(Source) do
    begin
      Self.Max := Max;
      Self.Min := Min;
      Self.Orientation := Orientation;
      Self.Percentage := Percentage;
      Self.Position := Position;
      Self.PositionColor := PositionColor;
      Self.PositionEndColor := PositionEndColor;
      Self.Slice := Slice;
      Self.Step := Step;
      Self.Style := Style;
    end;
end;

function TSCCustomProgress.CalculatePercentage: Boolean;
var
  P: Integer;
begin
  P := FPercentage;
  FPercentage := 0;
  if FMax <> FMin then
    FPercentage := Round((NormalizePosition(Position) / (FMax - FMin))*100);

  Result := P <> FPercentage;
end;

function TSCCustomProgress.CalculatePosition: Boolean;
var
  P1, P2: Integer;
begin
  P1 := FPosition;
  P2 := Round(((FMax - FMin) * FPercentage) / 100) + FMin;

  Result := P1 <> P2;
  if Result then SetPosition(P2);
end;

function TSCCustomProgress.CanSetValue(var Value: Integer): Boolean;
begin
  Result := True;
  if Value < FMin then
    Value := FMin
  else if Value > FMax then
    Value := FMax;
end;

constructor TSCCustomProgress.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(Left, Top, 146, 18);
  ControlStyle := [csCaptureMouse, csClickEvents, csOpaque,
    csReplicatable];

  Border := sccb3DLowered;
  BlendColor := False;
  ParentColor := False;
  Color := clWindow;
  ClickFocus := False;

  FMax := 100;
  FMin := 0;
  FOrientation := scoHorizontal;
  FPositionColor := clGreen;
  FPositionEndColor := clAqua;
  FSlice := 10;
  FStyle := scpsClassic;
  FStep := 10;
end;

procedure TSCCustomProgress.CreateWnd;
begin
  inherited CreateWnd;

  CalculatePosition;
  Invalidate;
end;

procedure TSCCustomProgress.DoChange;
begin
   //
end;

procedure TSCCustomProgress.DoCustomDraw(ACanvas: TCanvas);
begin
  //
end;

procedure TSCCustomProgress.DoDrawHorizontal;
var
  Bmp: TBitmap;
  DoSlicing: Boolean;
  CR, R, R2, R3: TRect;
  I, St, P, Ps, P2, W, H: Integer;
  C, C1, C2, C3, ClEnd, ClStart: TColor;
begin
  CR := GetClientRect;
  if IsRectEmpty(CR) then Exit;

  OffsetRect(CR, -CR.Left, -CR.Top);

  Bmp := nil;
  try
    H := CR.Bottom - CR.Top;
    W := CR.Right - CR.Left;

    Bmp := TBitmap.Create;
    with Bmp do
    begin
      Height := H;
      Width  := W;
    end;

    C := Self.Color;
    if C = clNone then C := clWindow;

    with Bmp.Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := C;

      FillRect(CR);
    end;

    if not (FStyle in [scpsGradientComplementary, scpsSliced,
      scpsSlicedGradient, scpsXP, scpsMetal]) then
    begin
      if Transparent then
        PaintParentOn(Bmp.Canvas);

      DrawPicture(Bmp.Canvas);
    end;

    C3 := FPositionColor;
    if C3 = clNone then C3 := C;

    Ps := NormalizePosition(Position);

    case FStyle of
      scpsClassic, scpsRaised:
      begin
        P := MulDiv(Ps, W, (FMax - FMin));
        if P <= 0 then Exit;

        R := CR;
        R.Right := P;

        with Bmp.Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C3;

          FillRect(R);
        end;

        if FStyle = scpsRaised then
        begin
          C1 := SCCommon.scBlendColor(C3, 64);
          C2 := SCCommon.scBlendColor(C3, -64);

          scFrame3D(Bmp.Canvas, R, C1, C2, 1, 0);
        end;
      end;
      scpsOffice12:
      begin
        P := MulDiv(Ps, W, (FMax - FMin));
        if P <= 0 then Exit;

        R := CR;
        R.Right := P;

        InflateRect(R, -1, -1);

        if not IsRectEmpty(R) then
        begin
          with Bmp.Canvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := C3;

            FillRect(R);
          end;

          ClEnd := C3;
          ClStart := GetGradientPreLight(C3);

          R2 := R;
          Dec(R2.Bottom, Round((R2.Bottom - R2.Top)/4));

          scDrawGradient(Bmp.Canvas, R2, scgTopToBottom, ClStart, ClEnd);

          R2 := R;
          Inc(R2.Top, (R2.Bottom - R2.Top) div 2);

          if not IsRectEmpty(R2) then
          begin
            ClStart := GetGradientDark(C3);
            ClEnd := GetGradientLight(C3);

            scDrawGradient(Bmp.Canvas, R2, scgTopToBottom, ClStart, ClEnd);
          end;

          R2 := R;
          InflateRect(R2, -1, -1);

          ClStart := GetGradientPreLight(C3);
          scFrame3D(Bmp.Canvas, R2, ClStart, ClStart, 1, 0);

          R2 := R;

          ClStart := GetGradientPreDark(C3);
          scFrame3D(Bmp.Canvas, R2, ClStart, ClStart, 1, 0);
        end;
      end;
      scpsGradientFull:
      begin
        P := MulDiv(Ps, W, (FMax - FMin));
        if P <= 0 then Exit;

        R := CR;
        R.Right := P;

        with Bmp.Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C3;

          FillRect(R);
        end;

        C1 := C3;

        C2 := FPositionEndColor;
        if C2 = clNone then C2 := C;

        if C1 <> C2 then
          scDrawGradient(Bmp.Canvas, R, scgLeftToRight, C1, C2);
      end;
      scps3D, scpsGradient3D:
      begin
        P := MulDiv(Ps, W, (FMax - FMin));
        if P <= 0 then Exit;

        R := CR;
        R.Right := P;

        with Bmp.Canvas do
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
          scDrawGradient(Bmp.Canvas, R2, scgTopToBottom, C1, C3);

          R2 := R;
          R2.Top := R2.Bottom - Round((R2.Bottom - R2.Top) / 2);

          C2 := SCCommon.scBlendColor(C3, -64);
          scDrawGradient(Bmp.Canvas, R2, scgTopToBottom, C3, C2);

          if FStyle = scps3D then
          begin
            R2 := R;
            scFrame3D(Bmp.Canvas, R2, C1, C2, 1, 0);

            C1 := SCCommon.scBlendColor(C3, 48);
            C2 := SCCommon.scBlendColor(C3, -48);

            scFrame3D(Bmp.Canvas, R2, C1, C2, 1, 0);
          end;
        end;
      end;
      scpsSliced:
      begin
        P := MulDiv(Ps, W, (FMax - FMin));

        DoSlicing := (FSlice > 0) and (Ps > FMin) and
          (FSlice < P);

        if DoSlicing and (Ps < FMax) then
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

        R := CR;
        R.Right := P;

        with Bmp.Canvas do
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
      scpsSlicedGradient,
      scpsGradientComplementary:
      begin
        P := MulDiv(Ps, W, (FMax - FMin));

        DoSlicing := (FSlice > 0) and (Ps > FMin) and
          (FSlice < P);

        if DoSlicing and (Ps < FMax) then
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

        R := CR;
        R.Right := P;

        C1 := C3;

        C2 := FPositionEndColor;
        if C2 = clNone then C2 := C;

        if C1 <> C2 then
        begin
          scDrawGradient(Bmp.Canvas, CR, scgLeftToRight, C1, C2);

          with Bmp.Canvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := C;

            R2 := CR;
            R2.Left := R.Right;

            FillRect(R2);

            Brush.Color := C;
            if DoSlicing and
              (FStyle = scpsSlicedGradient) then
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
      scpsXP, scpsMetal:
      begin
        R := CR;
        InflateRect(R, -2, -1);

        W := R.Right - R.Left;
        if W <= 0 then Exit;

        P := MulDiv(Ps, W, (FMax - FMin));

        DoSlicing := (FSlice > 0) and (Ps > FMin) and
          (FSlice < P);

        if DoSlicing and (Ps < FMax) then
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

        R := CR;
        InflateRect(R, -2, -1);
        R.Right := R.Left + P;

        with Bmp.Canvas do
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
          scDrawGradient(Bmp.Canvas, R2, scgTopToBottom, C, C3);

          R2 := R;
          R2.Top := R2.Bottom - ((R2.Bottom - R2.Top) div 2);

          scDrawGradient(Bmp.Canvas, R2, scgTopToBottom, C3, C);
        end;

        with Bmp.Canvas do
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

              if (FStyle = scpsMetal) and not IsRectEmpty(R3) then
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
  finally
    DoCustomDraw(Bmp.Canvas);
    Canvas.Draw(0, 0, Bmp);

    if Bmp <> nil then Bmp.Free;
  end;
end;

procedure TSCCustomProgress.DoDrawVertical;
var
  Bmp: TBitmap;
  DoSlicing: Boolean;
  CR, R, R2, R3: TRect;
  I, St, P, Ps, P2, W, H: Integer;
  C, C1, C2, C3, ClEnd, ClStart: TColor;
begin
  CR := GetClientRect;
  if IsRectEmpty(CR) then Exit;

  OffsetRect(CR, -CR.Left, -CR.Top);

  Bmp := nil;
  try
    H := CR.Bottom - CR.Top;
    W := CR.Right - CR.Left;

    Bmp := TBitmap.Create;
    with Bmp do
    begin
      Height := H;
      Width  := W;
    end;

    C := Self.Color;
    if C = clNone then C := clWindow;

    with Bmp.Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := C;

      FillRect(CR);
    end;

    if not (FStyle in [scpsGradientComplementary, scpsSliced,
      scpsSlicedGradient, scpsXP, scpsMetal]) then
    begin
      if Transparent then
        PaintParentOn(Bmp.Canvas);

      DrawPicture(Bmp.Canvas);
    end;

    C3 := FPositionColor;
    if C3 = clNone then C3 := C;

    Ps := NormalizePosition(Position);

    case FStyle of
      scpsClassic, scpsRaised:
      begin
        P := MulDiv(Ps, H, (FMax - FMin));
        if P <= 0 then Exit;

        R := CR;
        R.Top := R.Bottom - P;

        with Bmp.Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C3;

          FillRect(R);
        end;

        if FStyle = scpsRaised then
        begin
          C1 := SCCommon.scBlendColor(C3, 64);
          C2 := SCCommon.scBlendColor(C3, -64);

          scFrame3D(Bmp.Canvas, R, C1, C2, 1, 0);
        end;
      end;
      scpsOffice12:
      begin
        P := MulDiv(Ps, H, (FMax - FMin));
        if P <= 0 then Exit;

        R := CR;
        R.Top := R.Bottom - P;

        InflateRect(R, -1, -1);

        if not IsRectEmpty(R) then
        begin
          with Bmp.Canvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := C3;

            FillRect(R);
          end;

          ClEnd := C3;
          ClStart := GetGradientPreLight(C3);

          R2 := R;
          Dec(R2.Right, Round((R2.Right - R2.Left)/4));

          scDrawGradient(Bmp.Canvas, R2, scgLeftToRight, ClStart, ClEnd);

          R2 := R;
          Inc(R2.Left, (R2.Right - R2.Left) div 2);

          if not IsRectEmpty(R2) then
          begin
            ClStart := GetGradientDark(C3);
            ClEnd := GetGradientLight(C3);

            scDrawGradient(Bmp.Canvas, R2, scgLeftToRight, ClStart, ClEnd);
          end;

          R2 := R;
          InflateRect(R2, -1, -1);

          ClStart := GetGradientPreLight(C3);
          scFrame3D(Bmp.Canvas, R2, ClStart, ClStart, 1, 0);

          R2 := R;

          ClStart := GetGradientPreDark(C3);
          scFrame3D(Bmp.Canvas, R2, ClStart, ClStart, 1, 0);
        end;
      end;
      scpsGradientFull:
      begin
        P := MulDiv(Ps, H, (FMax - FMin));
        if P <= 0 then Exit;

        R := CR;
        R.Top := R.Bottom - P;

        with Bmp.Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C3;

          FillRect(R);
        end;

        C1 := C3;

        C2 := FPositionEndColor;
        if C2 = clNone then C2 := C;

        if C1 <> C2 then
          scDrawGradient(Bmp.Canvas, R, scgTopToBottom, C2, C1);
      end;
      scps3D, scpsGradient3D:
      begin
        P := MulDiv(Ps, H, (FMax - FMin));
        if P <= 0 then Exit;

        R := CR;
        R.Top := R.Bottom - P;

        with Bmp.Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C3;

          FillRect(R);
        end;

        R2 := R;
        R2.Right := R2.Left + ((R2.Right - R2.Left) div 2);

        if not IsRectEmpty(R2) then
        begin
          C1 := SCCommon.scBlendColor(C3, 64);
          scDrawGradient(Bmp.Canvas, R2, scgLeftToRight, C1, C3);

          R2 := R;
          R2.Left := R2.Right - ((R2.Right - R2.Left) div 2);

          C2 := SCCommon.scBlendColor(C3, -64);
          scDrawGradient(Bmp.Canvas, R2, scgLeftToRight, C3, C2);

          if FStyle = scps3D then
          begin
            R2 := R;
            scFrame3D(Bmp.Canvas, R2, C1, C2, 1, 0);

            C1 := SCCommon.scBlendColor(C3, 48);
            C2 := SCCommon.scBlendColor(C3, -48);

            scFrame3D(Bmp.Canvas, R2, C1, C2, 1, 0);
          end;  
        end;
      end;
      scpsSliced:
      begin
        P := MulDiv(Ps, H, (FMax - FMin));

        DoSlicing := (FSlice > 0) and (Ps > FMin) and
          (FSlice < P);

        if DoSlicing and (Ps < FMax) then
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

        R := CR;
        R.Top := R.Bottom - P;

        with Bmp.Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C3;

          FillRect(R);

          Brush.Color := C;
          if DoSlicing then
          begin
            R2 := R;
            R2.Top := R2.Bottom - 2;

            St := P div (FSlice + 2);
            for I := 0 to St-1 do
            begin
              OffsetRect(R2, 0, -FSlice);
              FillRect(R2);
              OffsetRect(R2, 0, -(R2.Bottom - R2.Top));
            end;
          end;
        end;
      end;
      scpsSlicedGradient,
      scpsGradientComplementary:
      begin
        P := MulDiv(Ps, H, (FMax - FMin));

        DoSlicing := (FSlice > 0) and (Ps > FMin) and
          (FSlice < P);

        if DoSlicing and (Ps < FMax) then
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

        R := CR;
        R.Top := R.Bottom - P;

        C1 := C3;

        C2 := FPositionEndColor;
        if C2 = clNone then C2 := C;

        if C1 <> C2 then
        begin
          scDrawGradient(Bmp.Canvas, CR, scgTopToBottom, C2, C1);

          with Bmp.Canvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := C;

            R2 := CR;
            R2.Bottom := R.Top;

            FillRect(R2);

            Brush.Color := C;
            if DoSlicing and (FStyle = scpsSlicedGradient) then
            begin
              R2 := R;
              R2.Top := R2.Bottom - 2;

              St := P div (FSlice + 2);
              for I := 0 to St-1 do
              begin
                OffsetRect(R2, 0, -FSlice);
                FillRect(R2);
                OffsetRect(R2, 0, -(R2.Bottom - R2.Top));
              end;
            end;
          end;
        end;  
      end;
      scpsXP, scpsMetal:
      begin
        R := CR;
        InflateRect(R, -1, -2);

        if IsRectEmpty(R) then Exit;

        H := R.Bottom - R.Top;

        P := MulDiv(Ps, H, (FMax - FMin));

        DoSlicing := (FSlice > 0) and (Ps > FMin) and
          (FSlice < P);

        if DoSlicing and (Ps < FMax) then
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

        R := CR;
        InflateRect(R, -1, -2);
        R.Top := R.Bottom - P;

        with Bmp.Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := C3;

          FillRect(R);
        end;

        R2 := R;
        R2.Right := R2.Left + ((R2.Right - R2.Left) div 2);

        if not IsRectEmpty(R2) then
        begin
          C := SCCommon.scBlendColor(C3, 128);
          scDrawGradient(Bmp.Canvas, R2, scgLeftToRight, C, C3);

          R2 := R;
          R2.Left := R2.Right - ((R2.Right - R2.Left) div 2);

          scDrawGradient(Bmp.Canvas, R2, scgLeftToRight, C3, C);
        end;

        with Bmp.Canvas do
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
            R2.Top := R2.Bottom - 2;

            R3 := R;
            R3.Top := R3.Bottom + FSlice;

            St := P div (FSlice + 2);
            for I := 0 to St do
            begin
              OffsetRect(R2, 0, -FSlice);

              Brush.Style := bsSolid;
              FillRect(R2);
              OffsetRect(R2, 0, -(R2.Bottom - R2.Top));

              if (FStyle = scpsMetal) and not IsRectEmpty(R3) then
              begin
                Brush.Style := bsClear;
                Rectangle(R3.Left, R3.Top, R3.Right, R3.Bottom);

                OffsetRect(R3, 0, FSlice + 2);
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    DoCustomDraw(Bmp.Canvas);
    Canvas.Draw(0, 0, Bmp);

    if Bmp <> nil then Bmp.Free;
  end;
end;

function TSCCustomProgress.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomProgress.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCProgressBorderProps;
end;

function TSCCustomProgress.GetGradientDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -16);
end;

function TSCCustomProgress.GetGradientExDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -40);
end;

function TSCCustomProgress.GetGradientExLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 40);
end;

function TSCCustomProgress.GetGradientHighLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 120);
end;

function TSCCustomProgress.GetGradientLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 30);
end;

function TSCCustomProgress.GetGradientPeal(AColor: TColor): TColor;
begin
  Result := BlendedColor(AColor, 52, 44, 112, True);
end;

function TSCCustomProgress.GetGradientPreDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -80);
end;

function TSCCustomProgress.GetGradientPreLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 100);
end;

function TSCCustomProgress.GetGradientShadow(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -6);
end;

function TSCCustomProgress.GetPosition: Integer;
begin
  Result := FPosition;
end;

procedure TSCCustomProgress.Loaded;
begin
  inherited Loaded;
  Invalidate;
end;

function TSCCustomProgress.NormalizePosition(Value: Integer): Integer;
begin
  Result := Value;
  if Result < FMin then Result := FMin;
  if Result > FMax then Result := FMax;
end;

procedure TSCCustomProgress.Paint;
begin
  if FOrientation = scoHorizontal then
    DoDrawHorizontal
  else
    DoDrawVertical;
end;

procedure TSCCustomProgress.SetMax(Value: Integer);
begin
  if (FMax <> Value) and (Value > FMin) and (Value >= 0) then
  begin
    FMax := Value;
    if FMax < FPosition then
      SetPosition(FMax);

    if CalculatePercentage then
      Invalidate;

    Change;
  end;
end;

procedure TSCCustomProgress.SetMin(Value: Integer);
begin
  if (FMin <> Value) and (Value < FMax) and (Value >= 0) then
  begin
    FMin := Value;
    if FMin > FPosition then
      SetPosition(FMin);

    if CalculatePercentage then
      Invalidate;

    Change;
  end;
end;

procedure TSCCustomProgress.SetOrientation(Value: TSCOrientation);
var
  H: Integer;
  R: TRect;
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

procedure TSCCustomProgress.SetPercentage(Value: Integer);
begin
  if Value > 100 then
    Value := 100
  else
  if Value < 0 then
    Value := 0;

  if FPercentage <> Value then
  begin
    FPercentage := Value;
    if CalculatePosition then
      Invalidate;

    Change;
  end;
end;

procedure TSCCustomProgress.SetPosition(Value: Integer);
begin
  if not CanSetValue(Value) then
    Exit;

  if Value > FMax then
    Value := FMax
  else if Value < FMin then
    Value := FMin;

  if FPosition <> Value then
  begin
    FPosition := Value;
    CalculatePercentage;

    Invalidate;
    Change;
  end;
end;

procedure TSCCustomProgress.SetPositionColor(Value: TColor);
begin
  if FPositionColor <> Value then
  begin
    FPositionColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomProgress.SetPositionEndColor(Value: TColor);
begin
  if FPositionEndColor <> Value then
  begin
    FPositionEndColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomProgress.SetSlice(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FSlice <> Value then
  begin
    FSlice := Value;
    if FPosition > FMin then
      Invalidate;
  end;
end;

procedure TSCCustomProgress.SetStyle(Value: TSCProgressStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TSCCustomProgress.StepBy(Delta: Integer);
begin
  if Delta <> 0 then
    SetPosition(FPosition + Delta);
end;

procedure TSCCustomProgress.StepIt;
begin
  if FStep <> 0 then
    SetPosition(FPosition + FStep);
end;

{ TSCCustomLabel }

procedure TSCCustomLabel.AdjustBounds;
var
  R: TRect;
  X: Integer;
  AAlignment: TAlignment;
begin
  if not IsReading and AutoSize then
  begin
    R := GetAdjustedRect(Width, Height);
    OffsetRect(R, -R.Left, -R.Top);

    AAlignment := FAlignment;
    if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);

    X := Left;
    if AAlignment = taRightJustify then Inc(X, Width - R.Right);
    SetBounds(X, Top, R.Right, R.Bottom);
  end;
end;

procedure TSCCustomLabel.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomLabel then
  begin
    with TSCCustomLabel(Source) do
    begin
      Self.Alignment := Alignment;
      Self.EllipsisMode := EllipsisMode;
      Self.FocusControl := FocusControl;
      Self.Gradient := Gradient;
      Self.GradientEnd := GradientEnd;
      Self.GradientMid := GradientMid;
      Self.GradientUsesMid := GradientUsesMid;
      Self.HighlightColor := HighlightColor;
      Self.HotImage := HotImage;
      Self.Hottrack := Hottrack;
      Self.HottrackColor := HottrackColor;
      Self.HotUnderline := HotUnderline;
      Self.ImageLayout := ImageLayout;
      Self.IndentHorz := IndentHorz;
      Self.IndentVert := IndentVert;
      Self.Layout := Layout;
      Self.Multiline := Multiline;
      Self.Rotation := Rotation;
      Self.ShowAccelChar := ShowAccelChar;
      Self.ShowFocus := ShowFocus;
    end;
  end;
end;

procedure TSCCustomLabel.CMDialogChar(var Message: TCMDialogChar);
begin
  if (FFocusControl <> nil) and Enabled and ShowAccelChar and
    IsAccel(Message.CharCode, Caption) then
    with FFocusControl do
      if CanFocus then
      begin
        SetFocus;
        Message.Result := 1;
      end;
end;

constructor TSCCustomLabel.Create(AOwner: TComponent);
begin
  FEllipsisMode := scelNone;
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csSetCaption, csOpaque, csDoubleClicks];
  SetBounds(Left, Top, 115, 17);
  DoubleBuffered := True;
  ParentColor := True;
  TabStop := False;

  FAlignment := taLeftJustify;
  FGradient := scgNone;
  FGradientEnd := clBlue;
  FGradientMid := clNavy;
  FGradientUsesMid := False;
  FHotImage := -1;
  FHottrack := True;
  FHighlightColor := clPurple;
  FHottrackColor := clRed;
  FHotUnderline := True;
  FImageLayout := scilLeft;
  FLayout := sclaMiddle;
  FMultiline := False;
  FRotation := scroTop;
  FShowAccelChar := True;
  FShowFocus := True;
end;

procedure TSCCustomLabel.DoDrawText(var R: TRect; CalcRect: Boolean);
var
  SR: TRect;
  Ft: HFont;
  LF: TLogFont;
  TM: TTextMetric;
  Text: String;
  FontColor: TColor;
  Underline: Boolean;
  Algn: TAlignment;
  X, Y, Esc, TxtFlags: Integer;
begin
  if (Canvas = nil) or not (CanGetClientRect and
    (CalcRect or not IsRectEmpty(R))) then
    Exit;

  SR := R;
  Text := GetLabelText;

  if CalcRect and ((Text = '') or (FShowAccelChar and
    (Length(Text) > 1) and (Text[1] = '&') and (Text[2] = #0))) then
    Text := Text + ' ';

  TxtFlags := DT_LEFT or DT_TOP;

  if not FShowAccelChar then
    TxtFlags := TxtFlags or DT_NOPREFIX;

  if not CalcRect then
  begin
    Algn := GetAlignment;

    case Algn of
      taRightJustify:
        TxtFlags := DT_RIGHT;
      taCenter:
        TxtFlags := DT_CENTER;
    end;

    TxtFlags := TxtFlags or DT_TOP;

    case FLayout of
      sclaBottom:
        TxtFlags := TxtFlags or DT_BOTTOM;
      sclaMiddle:
        TxtFlags := TxtFlags or DT_VCENTER;
    end;
  end;

  TxtFlags := TxtFlags or DT_EXPANDTABS;

  if not AutoSize and FMultiline and (FRotation = scroTop) then
  begin
    TxtFlags := TxtFlags or DT_WORDBREAK;
    if not CalcRect then
      TxtFlags := TxtFlags or DT_EDITCONTROL;
  end else
    TxtFlags := TxtFlags or DT_SINGLELINE;

  if not AutoSize and (FRotation = scroTop) then
  begin
    if FEllipsisMode = scelEndEllipsis then
      TxtFlags := TxtFlags or DT_END_ELLIPSIS
    else
    if FEllipsisMode = scelPathEllipsis then
      TxtFlags := TxtFlags or DT_PATH_ELLIPSIS;
  end;    

  if CalcRect then
    TxtFlags := TxtFlags or DT_CALCRECT
  else
    IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);

  TxtFlags := DrawTextBiDiModeFlags(TxtFlags);

  with Canvas do
  begin
    Brush.Style := bsClear;
    Font := Self.Font;

    if CalcRect then
    begin
      if FRotation <> scroTop then
      begin
        GetTextMetrics(Handle, TM);
        if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
          Font.Name := 'Arial';
      end;

      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);
    end else
    if FRotation <> scroTop then
    begin
      GetTextMetrics(Handle, TM);
      if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
        Font.Name := 'Arial';

      if not Enabled then
        Font.Color := clBtnHighlight
      else if FHottrack then
      begin
        Underline := False;
        FontColor := Self.Font.Color;

        if (FMousePressed and not MouseInControl) or
          (HasFocus and not (FMousePressed or MouseInControl)) then
        begin
          Underline := True;
          FontColor := FHighlightColor;
        end else
        if MouseInControl then
        begin
          Underline := True;
          FontColor := FHottrackColor;
        end;

        Font.Color := FontColor;
        if FHotUnderline and Underline then
          Font.Style := Font.Style + [fsUnderline];
      end;

      GetObject(Font.Handle, SizeOf(LF), @LF);

      Esc := 2700;
      if FRotation = scroLeft then
        Esc := 900;

      LF.lfEscapement := Esc;
      Ft := CreateFontIndirect(LF);
      Font.Handle := Ft;

      if not Enabled then
      begin
        if FRotation = scroLeft then
        begin
          X := R.Left + 1;
          Y := R.Bottom - 1;
        end else
        begin
          X := R.Right - 1;
          Y := R.Top + 1;
        end;
      end else
      if FRotation = scroLeft then
      begin
        X := R.Left;
        Y := R.Bottom;
      end else
      begin
        X := R.Right;
        Y := R.Top;
      end;

      SetBkMode(Handle, Windows.TRANSPARENT);
      ExtTextOut(Handle, X, Y, ETO_CLIPPED, @R, PChar(Text), Length(Text), nil);

      if not Enabled then
      begin
        Font.Color := clBtnShadow;
        GetObject(Font.Handle, SizeOf(LF), @LF);

        Esc := 2700;
        if FRotation = scroLeft then
          Esc := 900;

        LF.lfEscapement := Esc;
        Ft := CreateFontIndirect(LF);
        Font.Handle := Ft;

        if FRotation = scroLeft then
        begin
          X := R.Left;
          Y := R.Bottom;
        end else
        begin
          X := R.Right;
          Y := R.Top;
        end;

        SetBkMode(Handle, Windows.TRANSPARENT);
        ExtTextOut(Handle, X, Y, ETO_CLIPPED, @R, PChar(Text), Length(Text), nil);
      end;
    end else
    if not Enabled then
    begin
      OffsetRect(R, 1, 1);
      Font.Color := clBtnHighlight;

      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);

      OffsetRect(R, -1, -1);
      Font.Color := clBtnShadow;

      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);
    end else
    begin
      if FHottrack then
      begin
        Underline := False;
        FontColor := Self.Font.Color;

        if (FMousePressed and not MouseInControl) or
          (HasFocus and not (FMousePressed or MouseInControl)) then
        begin
          Underline := True;
          FontColor := FHighlightColor;
        end else
        if MouseInControl then
        begin
          Underline := True;
          FontColor := FHottrackColor;
        end;

        Font.Color := FontColor;
        if FHotUnderline and Underline then
          Font.Style := Font.Style + [fsUnderline];
      end;

      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);
    end;

    if not CalcRect then
      SelectClipRgn(Handle, 0);
  end;
end;

function TSCCustomLabel.GetLabelText: string;
begin
  Result := Caption;
end;

procedure TSCCustomLabel.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if ClickFocus and CanGetFocus and HasFocus then
  begin
    FMousePressed := Button = mbLeft;
    if FMousePressed then
      Invalidate;
  end;    
end;

procedure TSCCustomLabel.MouseInControlChanged;
begin
  Invalidate;
  inherited;
end;

procedure TSCCustomLabel.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  FMousePressed := False;
  Invalidate;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomLabel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFocusControl) then
    FFocusControl := nil;
end;

procedure TSCCustomLabel.Paint;
var
  Image: TImageIndex;
  UseMidGrad: Boolean;
  GradOrient: TSCGradient;
  CR, R, ImageR, TextR: TRect;
  SC, C, TopColor, BtmColor: TColor;
begin
  if not HandleAllocated then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  SC := Self.Color;
  if SC = clNone then SC := clWindow;

  R := CR;
  with Canvas do
  begin
    Brush.Style := bsSolid;

    if (FGradient = scgNone) or (FGradientEnd = SC) or (FGradientEnd = clNone) then
    begin
      Brush.Color := SC;
      FillRect(R);

      if Transparent then
        PaintParentOn(Canvas);
    end else
    begin
      TopColor := SC;
      BtmColor := FGradientEnd;

      UseMidGrad := FGradientUsesMid and (FGradientMid <> clNone);

      GradOrient := FGradient;

      if UseMidGrad then
      begin
        case FGradient of
          scgRightToLeft:
            GradOrient := scgLeftToRight;
          scgBottomToTop:
            GradOrient := scgTopToBottom;
        end;
      end;

      if not UseMidGrad then
        scDrawGradient(Canvas, R, GradOrient, TopColor, BtmColor)
      else begin
        if FGradient in [scgRightToLeft, scgBottomToTop] then
        begin
          C := TopColor;
          TopColor := BtmColor;
          BtmColor := C;
        end;

        case FGradient of
          scgLeftToRight, scgRightToLeft:
          begin
            R.Right := R.Left + ((R.Right - R.Left) div 2);
            scDrawGradient(Canvas, R, GradOrient, TopColor, FGradientMid);

            R.Left := R.Right;
            R.Right := CR.Right;

            scDrawGradient(Canvas, R, GradOrient, FGradientMid, BtmColor);
          end;
          scgTopToBottom, scgBottomToTop:
          begin
            R.Bottom := R.Top + ((R.Bottom - R.Top) div 2);
            scDrawGradient(Canvas, R, GradOrient, TopColor, FGradientMid);

            R.Top := R.Bottom;
            R.Bottom := CR.Bottom;

            scDrawGradient(Canvas, R, GradOrient, FGradientMid, BtmColor);
          end;
        end;
      end;
    end;
  end;

  DrawPicture(Canvas);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := SC;
  end;

  Image := ImageIndex;
  if Active or FMousePressed or MouseInControl then
    Image := FHotImage;

  ImageR := Rect(0, 0, 0, 0);
  if IsValidImage(Image) then
  begin
    ImageR := GetImageRect;
    Images.Draw(Canvas, ImageR.Left, ImageR.Top, Image, Enabled);
  end;  

  TextR := GetTextRect;

  R := TextR;
  DoDrawText(R, False);

  if FShowFocus and Active and not IsRectEmpty(R) then
  begin
    InflateRect(R, 2, 2);
    IntersectRect(R, R, CR);

    if not IsRectEmpty(R) then
      with Canvas do
      begin
        Brush.Color := SC;
        Brush.Style := bsSolid;

        scDrawFocusRect(Canvas, R, SC);
      end;
  end;
end;

procedure TSCCustomLabel.SetAlignment(Value: TAlignment);
begin
  if CanAlignText(Value) and (FAlignment <> Value) then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TSCCustomLabel.SetFocusControl(Value: TWinControl);
begin
  if Value <> Self then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FFocusControl <> nil then
      FFocusControl.RemoveFreeNotification(Self);
    {$ENDIF}

    FFocusControl := Value;

    if FFocusControl <> nil then
      FFocusControl.FreeNotification(Self);
  end;
end;

procedure TSCCustomLabel.SetGradient(Value: TSCGradient);
begin
  if FGradient <> Value then
  begin
    FGradient := Value;
    if (FGradientEnd <> Color) and
      (FGradientEnd <> clNone) then Invalidate;
  end;
end;

procedure TSCCustomLabel.SetGradientEnd(Value: TColor);
begin
  if FGradientEnd <> Value then
  begin
    FGradientEnd := Value;
    if (FGradient <> scgNone) and
      (Value <> Color) and (Value <> clNone) then Invalidate;
  end;
end;

procedure TSCCustomLabel.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    if FHottrack then Invalidate;
  end;
end;

procedure TSCCustomLabel.SetHotImage(Value: TImageIndex);
begin
  if FHotImage <> Value then
  begin
    FHotImage := Value;
    if FHottrack then Invalidate;
  end;
end;

procedure TSCCustomLabel.SetHottrack(Value: Boolean);
begin
  if FHottrack <> Value then
  begin
    FHottrack := Value;
    Invalidate;
  end;
end;

procedure TSCCustomLabel.SetHottrackColor(Value: TColor);
begin
  if FHottrackColor <> Value then
  begin
    FHottrackColor := Value;
    if FHottrack then Invalidate;
  end;
end;

procedure TSCCustomLabel.SetHotUnderline(Value: Boolean);
begin
  if FHotUnderline <> Value then
  begin
    FHotUnderline := Value;
    if FHottrack then Invalidate;
  end;
end;

procedure TSCCustomLabel.SetLayout(Value: TSCLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TSCCustomLabel.SetMultiline(Value: Boolean);
begin
  if FMultiline <> Value then
  begin
    FMultiline := Value;
    AdjustBounds;
    Invalidate;
  end;
end;

procedure TSCCustomLabel.SetShowAccelChar(Value: Boolean);
begin
  if FShowAccelChar <> Value then
  begin
    FShowAccelChar := Value;
    Invalidate;
  end;
end;

procedure TSCCustomLabel.SetShowFocus(Value: Boolean);
begin
  if FShowFocus <> Value then
  begin
    FShowFocus := Value;
    if HasFocus then Invalidate;
  end;
end;

procedure TSCCustomLabel.StopTracking;
begin
  FMousePressed := False;
  inherited StopTracking;
end;

procedure TSCCustomLabel.SetGradientMid(Value: TColor);
begin
  if FGradientMid <> Value then
  begin
    FGradientMid := Value;
    if FGradientUsesMid and (FGradient <> scgNone) and
      (Value <> Color) and (Value <> clNone) then Invalidate;
  end;
end;

procedure TSCCustomLabel.SetGradientUsesMid(Value: Boolean);
begin
  if FGradientUsesMid <> Value then
  begin
    FGradientUsesMid := Value;
    if (FGradient <> scgNone) and
      (FGradientMid <> clNone) then Invalidate;
  end;
end;

function TSCCustomLabel.GetBlendValue: Word;
begin
  Result := 0;
end;

procedure TSCCustomLabel.TransparentChanged;
begin
  if (FGradient = scgNone) or (FGradientEnd = Self.Color) or
    (FGradientEnd = clNone) then
    Invalidate;
end;

procedure TSCCustomLabel.SetEllipsisMode(Value: TSCEllipsis);
begin
  if FEllipsisMode <> Value then
  begin
    FEllipsisMode := Value;
    if (Value = scelNone) and AutoSize then
      AdjustBounds;
    Invalidate;
  end;
end;

function TSCCustomLabel.GetAdjustedRect(NewWidth, NewHeight: Integer): TRect;
const
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  DC: HDC;
  Bs: Integer;
begin
  Result := BoundsRect;
  if not CanGetClientRect then Exit;

  Result := GetClientRect;

  DC := GetDC(0);
  try
    Canvas.Handle := DC;
    DoDrawText(Result, True);
    Canvas.Handle := 0;
  finally
    ReleaseDC(0, DC);
  end;  

  if FRotation = scroTop then
  begin
    if Images <> nil then
    begin
      Inc(Result.Right, Images.Width);
      if Result.Bottom < Images.Height then
        Result.Bottom := Images.Height;
    end;

    Inc(Result.Right, Indent + Spacing);
  end else
  if FRotation = scroLeft then
  begin
    if Images <> nil then
    begin
      Dec(Result.Top, Images.Height);
      if Result.Right < Images.Width then
        Result.Right := Images.Width;
    end;

    Dec(Result.Top, Indent + Spacing);
  end else
  if FRotation = scroRight then
  begin
    if Images <> nil then
    begin
      Inc(Result.Bottom, Images.Height);
      if Result.Right < Images.Width then
        Result.Right := Images.Width;
    end;

    Inc(Result.Bottom, Indent + Spacing);
  end;

  Bs := GetBorderSize + BorderWidth + GetInnerBorderSize;
  Bs := 2*Bs;

  InflateRect(Result, Bs + 2, Bs + 2);
end;

procedure TSCCustomLabel.FocusChanged;
begin
  FMousePressed := False;
  Invalidate;
end;

function TSCCustomLabel.GetAlignment: TAlignment;
begin
  Result := FAlignment;
end;

function TSCCustomLabel.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
end;

procedure TSCCustomLabel.SetRotation(Value: TSCRotation);
begin
  if FRotation <> Value then
  begin
    FRotation := Value;
    if Caption <> '' then
      Invalidate;

    if AutoSize then AdjustBounds;
  end;
end;

function TSCCustomLabel.GetImageRect: TRect;
var
  HasImage: Boolean;
  Algn: TAlignment;
  CR, SaveR, TempR: TRect;
  I, ImageWidth, ImageHeight: Integer;
begin
  HasImage := ImageIndex > -1;

  if Active or FMousePressed or MouseInControl then
    HasImage := HasImage or (FHotImage > -1);

  Result := Rect(0, 0, 0, 0);

  if HasImage and (Images <> nil) then
  begin
    CR := GetClientRect;
    SaveR := CR;

    Result := GetTextRect;
    
    ImageWidth := Images.Width;
    ImageHeight := Images.Height;

    if FRotation in [scroLeft, scroRight] then
    begin
      I := ImageWidth;
      ImageWidth := ImageHeight;
      ImageHeight := I;

      TempR := Rect(0, 0, 0, 0);

      if FRotation = scroLeft then
      begin
        TempR := Result;

        Result.Top := Result.Left;
        Result.Bottom := Result.Right;

        Result.Left := CR.Bottom - TempR.Bottom;
        Result.Right := Result.Left + (TempR.Bottom - TempR.Top);
      end else
      if FRotation = scroRight then
      begin
        TempR := Result;

        Result.Left := Result.Top;
        Result.Right := Result.Bottom;

        Result.Top := CR.Right - TempR.Right;
        Result.Bottom := Result.Top + (TempR.Right - TempR.Left);
      end;
    end;

    case FImageLayout of
      scilLeft:
      begin
        Dec(Result.Left, ImageWidth + Spacing + 2);
        Result.Right := Result.Left + ImageWidth;
      end;
      scilRight:
      begin
        Inc(Result.Right, ImageWidth + Spacing + 2);
        Result.Left := Result.Right - ImageWidth;
      end;
      scilTop:
      begin
        Dec(Result.Top, ImageHeight + Spacing + 2);
        Result.Bottom := Result.Top + ImageHeight;
      end;
      scilBottom:
      begin
        Inc(Result.Bottom, ImageHeight + Spacing + 2);
        Result.Top := Result.Bottom - ImageHeight;
      end;
    end;

    CR := SaveR;

    if FRotation in [scroLeft, scroRight] then
    begin
      TempR := CR;
      CR.Right := CR.Bottom;
      CR.Bottom := TempR.Right;
    end;

    InflateRect(CR, -2, -2);

    if FImageLayout in [scilLeft, scilRight] then
    begin
      case FLayout of
        sclaTop:
        begin
          Result.Top := CR.Top + FIndentVert;
          Result.Bottom := Result.Top + ImageHeight;
        end;
        sclaMiddle:
        begin
          Result.Top := CR.Top + (CR.Bottom - CR.Top - ImageHeight) div 2;
          Result.Bottom := Result.Top + ImageHeight;
        end;
        sclaBottom:
        begin
          Result.Bottom := CR.Bottom - FIndentVert;
          Result.Top := Result.Bottom - ImageHeight;
        end;
      end;
    end else
    begin
      Algn := GetAlignment;

      case Algn of
        taLeftJustify:
        begin
          Result.Left := CR.Left;
          Result.Right := Result.Left + ImageWidth;
        end;
        taCenter:
        begin
          Result.Left := CR.Left + (CR.Right - CR.Left - ImageWidth) div 2;
          Result.Right := Result.Left + ImageWidth;
        end;
        taRightJustify:
        begin
          Result.Right := CR.Right;
          Result.Left := Result.Right - ImageWidth;
        end;
      end;
    end;

    CR := SaveR;

    if FRotation = scroLeft then
    begin
      TempR := Result;

      Result.Left := TempR.Top;
      Result.Right := TempR.Bottom;

      Result.Bottom := CR.Bottom - TempR.Left;
      Result.Top := Result.Bottom - (TempR.Right - TempR.Left);
    end else
    if FRotation = scroRight then
    begin
      TempR := Result;

      Result.Right := CR.Right - TempR.Top;
      Result.Left := Result.Right - (TempR.Bottom - TempR.Top);
    
      Result.Top := TempR.Left;
      Result.Bottom := TempR.Right;
    end;
  end;
end;

function TSCCustomLabel.GetTextRect: TRect;
var
  HasImage: Boolean;
  Algn: TAlignment;
  CR, SR, R, IndentR, TempR: TRect;
  I, ImageWidth, ImageHeight: Integer;
begin
  CR := ClientRect;
  SR := CR;

  InflateRect(CR, -2, -2);
  OffsetRect(CR, -CR.Left, -CR.Top);

  if FRotation in [scroLeft, scroRight] then
  begin
    TempR := CR;

    CR.Right := TempR.Bottom;
    CR.Bottom := TempR.Right;
  end;

  Result := CR;

  HasImage := ImageIndex > -1;

  if Active or FMousePressed or MouseInControl then
    HasImage := HasImage or (FHotImage > -1);

  HasImage := HasImage and (Images <> nil);  

  Algn := GetAlignment;

  case Algn of
    taLeftJustify:
      Inc(Result.Left, Indent);
    taRightJustify:
      Dec(Result.Right, Indent);
  end;

  case FLayout of
    sclaTop:
      Inc(Result.Top, FIndentVert);
    sclaBottom:
      Dec(Result.Bottom, FIndentVert);
  end;

  ImageWidth := 0;
  ImageHeight := 0;

  if HasImage then
  begin
    ImageWidth := Images.Width;
    ImageHeight := Images.Height;

    if FRotation in [scroLeft, scroRight] then
    begin
      I := ImageWidth;
      ImageWidth := ImageHeight;
      ImageHeight := I;
    end;
    
    case FImageLayout of
      scilLeft:
        Inc(Result.Left, ImageWidth + Spacing + 2);
      scilRight:
        Dec(Result.Right, ImageWidth + Spacing + 2);
      scilTop:
        Inc(Result.Top, ImageHeight + Spacing + 2);
      scilBottom:
        Dec(Result.Bottom, ImageHeight + Spacing + 2);
    end;
  end;

  IndentR := Result;

  R := Result;
  DoDrawText(R, True);

  Result := R;
  OffsetRect(Result, -Result.Left, -Result.Top);

  case Algn of
    taLeftJustify:
    begin
      Result.Left := CR.Left;
      Result.Right := Result.Left + (R.Right - R.Left);

      OffsetRect(Result, IndentR.Left + 2, 0);
    end;
    taRightJustify:
    begin
      Result.Right := CR.Right;
      Result.Left := Result.Right - (R.Right - R.Left);

      OffsetRect(Result, -(CR.Right - IndentR.Right - 2), 0);
    end;
    taCenter:
    begin
      Result.Left := CR.Left + 2 + (((CR.Right - CR.Left) - (R.Right - R.Left)) div 2);
      Result.Right := Result.Left + (R.Right - R.Left);

      if HasImage then
        case FImageLayout of
          scilLeft:
            OffsetRect(Result, (ImageWidth + Spacing + 2) div 2, 0);
          scilRight:
            OffsetRect(Result, -(ImageWidth + Spacing + 2) div 2, 0);
        end;
    end;
  end;

  case FLayout of
    sclaTop:
    begin
      Result.Top := CR.Top;
      Result.Bottom := Result.Top + (R.Bottom - R.Top);

      OffsetRect(Result, 0, IndentR.Top + 2);
    end;
    sclaBottom:
    begin
      Result.Bottom := CR.Bottom;
      Result.Top := Result.Bottom - (R.Bottom - R.Top);

      OffsetRect(Result, 0, -(CR.Bottom - IndentR.Bottom - 2));
    end;
    sclaMiddle:
    begin
      Result.Top := CR.Top + 2 + (((CR.Bottom - CR.Top) - (R.Bottom - R.Top)) div 2);
      Result.Bottom := Result.Top + (R.Bottom - R.Top);

      if HasImage then
        case FImageLayout of
          scilTop:
            OffsetRect(Result, 0, (ImageHeight + Spacing + 2) div 2);
          scilBottom:
            OffsetRect(Result, 0, -(ImageHeight + Spacing + 2) div 2);
        end;
    end;
  end;

  CR := SR;

  if FRotation in [scroLeft, scroRight] then
    case FAlignment of
      taLeftJustify:
        Inc(Result.Right, 2);
      taRightJustify:
        Dec(Result.Left, 2);
      taCenter:
      begin
        Inc(Result.Right);
        Dec(Result.Left);
      end;
    end;

  if FRotation = scroLeft then
  begin
    TempR := Result;

    Result.Left := TempR.Top;
    Result.Right := TempR.Bottom;

    Result.Bottom := CR.Bottom - TempR.Left;
    Result.Top := Result.Bottom - (TempR.Right - TempR.Left);
  end else
  if FRotation = scroRight then
  begin
    TempR := Result;

    Result.Right := CR.Right - TempR.Top;
    Result.Left := Result.Right - (TempR.Bottom - TempR.Top);

    Result.Top := TempR.Left;
    Result.Bottom := TempR.Right;
  end;
end;

procedure TSCCustomLabel.SetImageLayout(Value: TSCImageLayout);
begin
  if FImageLayout <> Value then
  begin
    FImageLayout := Value;
    Invalidate;
  end;
end;

function TSCCustomLabel.GetIndentHorz: Integer;
begin
  Result := Indent;
end;

procedure TSCCustomLabel.SetIndentHorz(Value: Integer);
begin
  SetIndent(Value);
end;

procedure TSCCustomLabel.SetIndentVert(Value: Integer);
begin
  if FIndentVert <> Value then
  begin
    FIndentVert := Value;
    Invalidate;
  end;
end;

{ TSCCustomPanel }

procedure TSCCustomPanel.AdjustBevelRect(var Rect: TRect);
var
  B: Integer;
begin
  if (FBevel <> sccbNone) and (FBevelEdges <> []) then
  begin
    B := GetBevelSize;

    if scbeLeft in FBevelEdges then
      Inc(Rect.Left, B);

    if scbeTop in FBevelEdges then
      Inc(Rect.Top, B);

    if scbeRight in FBevelEdges then
      Dec(Rect.Right, B);

    if scbeBottom in FBevelEdges then
      Dec(Rect.Bottom, B);
  end;
end;

procedure TSCCustomPanel.AdjustBounds;
var
  R: TRect;
  X: Integer;
  AAlignment: TAlignment;
begin
  if not IsReading and AutoSize then
  begin
    if ControlCount = 0 then
    begin
      R := GetAdjustedRect(Width, Height);
      OffsetRect(R, -R.Left, -R.Top);

      AAlignment := taRightJustify;
      if FAlignment = taRightJustify then
        AAlignment := taLeftJustify;

      if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);

      X := Left;
      if AAlignment = taRightJustify then Inc(X, Width - R.Right);
      SetBounds(X, Top, R.Right, R.Bottom);
    end else
    begin

    end;  
  end;
end;

procedure TSCCustomPanel.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  AdjustBevelRect(Rect);
end;

procedure TSCCustomPanel.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomPanel then
  begin
    with TSCCustomPanel(Source) do
    begin
      Self.Alignment := Alignment;
      Self.Bevel := Bevel;
      Self.BevelColor := BevelColor;
      Self.BevelEdges := BevelEdges;
      Self.BevelWidth := BevelWidth;
      Self.EllipsisMode := EllipsisMode;
      Self.Gradient := Gradient;
      Self.GradientEnd := GradientEnd;
      Self.GradientMid := GradientMid;
      Self.GradientUsesMid := GradientUsesMid;
      Self.ImageLayout := ImageLayout;
      Self.IndentHorz := IndentHorz;
      Self.IndentVert := IndentVert;
      Self.Layout := Layout;
      Self.Multiline := Multiline;
      Self.Picture := Picture;
      Self.PictureProps := PictureProps;
      Self.Rotation := Rotation;
      Self.ShowSizeGrip := ShowSizeGrip;
      Self.ShowStatusbar := ShowStatusbar;
      Self.StatusbarColor := StatusbarColor;
      Self.StatusbarText := StatusbarText;
    end;
  end;
end;

function TSCCustomPanel.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := (not FAutoSizeDocking) and inherited CanAutoSize(NewWidth, NewHeight);
end;

procedure TSCCustomPanel.CMDockClient(var Message: TCMDockClient);
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

constructor TSCCustomPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls, csSetCaption, csOpaque,
    csDoubleClicks, csReplicatable];
  SetBounds(Left, Top, 185, 41);
  DoubleBuffered := True;
  TabStop := False;

  FAlignment := taLeftJustify;
  FBevel := sccbNone;
  FBevelColor := clNone;
  FBevelEdges := SCAllBorderEdges;
  FBevelWidth := 0;
  FEllipsisMode := scelNone;
  FGradient := scgNone;
  FGradientEnd := clNavy;
  FGradientMid := clBlue;
  FGradientUsesMid := False;
  FLayout := sclaMiddle;
  FRotation := scroTop;
  FMultiline := False;
  FImageLayout := scilLeft;
end;

procedure TSCCustomPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params.WindowClass do
    style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TSCCustomPanel.DoDrawText(var R: TRect; CalcRect: Boolean);
var
  SR: TRect;
  Ft: HFont;
  LF: TLogFont;
  TM: TTextMetric;
  Text: String;
  Algn: TAlignment;
  X, Y, Esc, TxtFlags: Integer;
begin
  if (Canvas = nil) or not (CanGetClientRect and
    (CalcRect or not IsRectEmpty(R))) then
    Exit;

  SR := R;
  Text := GetPanelText;

  if CalcRect and (Text = '') then
    Text := Text + ' ';

  TxtFlags := DT_LEFT or DT_TOP;

  if not CalcRect then
  begin
    Algn := GetAlignment;

    case Algn of
      taRightJustify:
        TxtFlags := DT_RIGHT;
      taCenter:
        TxtFlags := DT_CENTER;
    end;

    TxtFlags := TxtFlags or DT_TOP;

    case FLayout of
      sclaBottom:
        TxtFlags := TxtFlags or DT_BOTTOM;
      sclaMiddle:
        TxtFlags := TxtFlags or DT_VCENTER;
    end;
  end;

  TxtFlags := TxtFlags or DT_EXPANDTABS;

  if not AutoSize and FMultiline and (FRotation = scroTop) then
  begin
    TxtFlags := TxtFlags or DT_WORDBREAK;
    if not CalcRect then
      TxtFlags := TxtFlags or DT_EDITCONTROL;
  end else
    TxtFlags := TxtFlags or DT_SINGLELINE;

  if not AutoSize and (FRotation = scroTop) then
  begin
    if FEllipsisMode = scelEndEllipsis then
      TxtFlags := TxtFlags or DT_END_ELLIPSIS
    else
    if FEllipsisMode = scelPathEllipsis then
      TxtFlags := TxtFlags or DT_PATH_ELLIPSIS;
  end;    

  if CalcRect then
    TxtFlags := TxtFlags or DT_CALCRECT
  else
    IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);

  TxtFlags := DrawTextBiDiModeFlags(TxtFlags);

  with Canvas do
  begin
    Brush.Style := bsClear;
    Font := Self.Font;

    if CalcRect then
    begin
      if FRotation <> scroTop then
      begin
        GetTextMetrics(Handle, TM);
        if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
          Font.Name := 'Arial';
      end;

      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);
    end else
    if FRotation <> scroTop then
    begin
      GetTextMetrics(Handle, TM);
      if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
        Font.Name := 'Arial';

      if not Enabled then
        Font.Color := clBtnHighlight;

      GetObject(Font.Handle, SizeOf(LF), @LF);

      Esc := 2700;
      if FRotation = scroLeft then
        Esc := 900;

      LF.lfEscapement := Esc;
      Ft := CreateFontIndirect(LF);
      Font.Handle := Ft;

      if not Enabled then
      begin
        if FRotation = scroLeft then
        begin
          X := R.Left + 1;
          Y := R.Bottom - 1;
        end else
        begin
          X := R.Right - 1;
          Y := R.Top + 1;
        end;
      end else
      if FRotation = scroLeft then
      begin
        X := R.Left;
        Y := R.Bottom;
      end else
      begin
        X := R.Right;
        Y := R.Top;
      end;

      SetBkMode(Handle, Windows.TRANSPARENT);
      ExtTextOut(Handle, X, Y, ETO_CLIPPED, @R, PChar(Text), Length(Text), nil);

      if not Enabled then
      begin
        Font.Color := clBtnShadow;
        GetObject(Font.Handle, SizeOf(LF), @LF);

        Esc := 2700;
        if FRotation = scroLeft then
          Esc := 900;

        LF.lfEscapement := Esc;
        Ft := CreateFontIndirect(LF);
        Font.Handle := Ft;

        if FRotation = scroLeft then
        begin
          X := R.Left;
          Y := R.Bottom;
        end else
        begin
          X := R.Right;
          Y := R.Top;
        end;

        SetBkMode(Handle, Windows.TRANSPARENT);
        ExtTextOut(Handle, X, Y, ETO_CLIPPED, @R, PChar(Text), Length(Text), nil);
      end;
    end else
    if not Enabled then
    begin
      OffsetRect(R, 1, 1);
      Font.Color := clBtnHighlight;

      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);

      OffsetRect(R, -1, -1);
      Font.Color := clBtnShadow;

      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);
    end else
      DrawText(Handle, PChar(Text), Length(Text), R, TxtFlags);

    if not CalcRect then
      SelectClipRgn(Handle, 0);
  end;
end;

function TSCCustomPanel.GetAlignment: TAlignment;
begin
  Result := FAlignment;
end;

function TSCCustomPanel.GetBevelSize: Integer;
begin
  Result := 0;
  if FBevel <> sccbNone then
  begin
    Inc(Result, FBevelWidth);
    if FBevel in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
      Inc(Result)
    else
      Inc(Result, 2);
  end;
end;

function TSCCustomPanel.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomPanel.GetImageRect: TRect;
var
  Algn: TAlignment;
  CR, SaveR, TempR: TRect;
  I, Bs, ImageWidth, ImageHeight: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if (ImageIndex > -1) and (Images <> nil) then
  begin
    CR := GetClientRect;
    SaveR := CR;

    Bs := 0;
    if (FBevel <> sccbNone) and (FBevelEdges <> []) then
      Bs := GetBevelSize;

    Result := GetTextRect;
    
    ImageWidth := Images.Width;
    ImageHeight := Images.Height;

    if FRotation in [scroLeft, scroRight] then
    begin
      I := ImageWidth;
      ImageWidth := ImageHeight;
      ImageHeight := I;

      TempR := Rect(0, 0, 0, 0);

      if FRotation = scroLeft then
      begin
        TempR := Result;

        Result.Top := Result.Left;
        Result.Bottom := Result.Right;

        Result.Left := CR.Bottom - TempR.Bottom;
        Result.Right := Result.Left + (TempR.Bottom - TempR.Top);
      end else
      if FRotation = scroRight then
      begin
        TempR := Result;

        Result.Left := Result.Top;
        Result.Right := Result.Bottom;

        Result.Top := CR.Right - TempR.Right;
        Result.Bottom := Result.Top + (TempR.Right - TempR.Left);
      end;
    end;

    case FImageLayout of
      scilLeft:
      begin
        Dec(Result.Left, ImageWidth + Spacing + 2);
        Result.Right := Result.Left + ImageWidth;
      end;
      scilRight:
      begin
        Inc(Result.Right, ImageWidth + Spacing + 2);
        Result.Left := Result.Right - ImageWidth;
      end;
      scilTop:
      begin
        Dec(Result.Top, ImageHeight + Spacing + 2);
        Result.Bottom := Result.Top + ImageHeight;
      end;
      scilBottom:
      begin
        Inc(Result.Bottom, ImageHeight + Spacing + 2);
        Result.Top := Result.Bottom - ImageHeight;
      end;
    end;

    CR := SaveR;

    if FRotation in [scroLeft, scroRight] then
    begin
      TempR := CR;
      CR.Right := CR.Bottom;
      CR.Bottom := TempR.Right;
    end;

    InflateRect(CR, -2, -2);

    if FImageLayout in [scilLeft, scilRight] then
    begin
      case FLayout of
        sclaTop:
        begin
          Result.Top := CR.Top + FIndentVert + Bs;
          Result.Bottom := Result.Top + ImageHeight;
        end;
        sclaMiddle:
        begin
          Result.Top := CR.Top + (CR.Bottom - CR.Top - ImageHeight) div 2;
          Result.Bottom := Result.Top + ImageHeight;
        end;
        sclaBottom:
        begin
          Result.Bottom := CR.Bottom - FIndentVert - Bs;
          Result.Top := Result.Bottom - ImageHeight;
        end;
      end;
    end else
    begin
      Algn := GetAlignment;

      case Algn of
        taLeftJustify:
        begin
          Result.Left := CR.Left;
          Result.Right := Result.Left + ImageWidth;
        end;
        taCenter:
        begin
          Result.Left := CR.Left + (CR.Right - CR.Left - ImageWidth) div 2;
          Result.Right := Result.Left + ImageWidth;
        end;
        taRightJustify:
        begin
          Result.Right := CR.Right;
          Result.Left := Result.Right - ImageWidth;
        end;
      end;
    end;

    CR := SaveR;

    if FRotation = scroLeft then
    begin
      TempR := Result;

      Result.Left := TempR.Top;
      Result.Right := TempR.Bottom;

      Result.Bottom := CR.Bottom - TempR.Left;
      Result.Top := Result.Bottom - (TempR.Right - TempR.Left);
    end else
    if FRotation = scroRight then
    begin
      TempR := Result;

      Result.Right := CR.Right - TempR.Top;
      Result.Left := Result.Right - (TempR.Bottom - TempR.Top);
    
      Result.Top := TempR.Left;
      Result.Bottom := TempR.Right;
    end;
  end;
end;

function TSCCustomPanel.GetIndentHorz: Integer;
begin
  Result := Indent;
end;

function TSCCustomPanel.GetPanelText: string;
begin
  Result := Caption;
end;

function TSCCustomPanel.GetPicturePropsClass: TSCCustomPicturePropsClass;
begin
  Result := TSCPanelPictureProps;
end;

function TSCCustomPanel.GetTextRect: TRect;
var
  HasImage: Boolean;
  Algn: TAlignment;
  CR, SR, R, IndentR, TempR: TRect;
  I, Bs, ImageWidth, ImageHeight: Integer;
begin
  CR := ClientRect;
  SR := CR;

  Bs := 0;
  if (FBevel <> sccbNone) and (FBevelEdges <> []) then
    Bs := GetBevelSize;

  InflateRect(CR, -2, -2);
  OffsetRect(CR, -CR.Left, -CR.Top);

  if FRotation in [scroLeft, scroRight] then
  begin
    TempR := CR;

    CR.Right := TempR.Bottom;
    CR.Bottom := TempR.Right;
  end;

  Result := CR;

  HasImage := (ImageIndex > -1) and (Images <> nil);

  Algn := GetAlignment;

  case Algn of
    taLeftJustify:
      Inc(Result.Left, Indent + Bs);
    taRightJustify:
      Dec(Result.Right, Indent + Bs);
  end;

  case FLayout of
    sclaTop:
      Inc(Result.Top, FIndentVert + Bs);
    sclaBottom:
      Dec(Result.Bottom, FIndentVert + Bs);
  end;

  ImageWidth := 0;
  ImageHeight := 0;

  if HasImage then
  begin
    ImageWidth := Images.Width;
    ImageHeight := Images.Height;

    if FRotation in [scroLeft, scroRight] then
    begin
      I := ImageWidth;
      ImageWidth := ImageHeight;
      ImageHeight := I;
    end;
    
    case FImageLayout of
      scilLeft:
        Inc(Result.Left, ImageWidth + Spacing + 2);
      scilRight:
        Dec(Result.Right, ImageWidth + Spacing + 2);
      scilTop:
        Inc(Result.Top, ImageHeight + Spacing + 2);
      scilBottom:
        Dec(Result.Bottom, ImageHeight + Spacing + 2);
    end;
  end;

  IndentR := Result;

  R := Result;
  DoDrawText(R, True);

  Result := R;
  OffsetRect(Result, -Result.Left, -Result.Top);

  case Algn of
    taLeftJustify:
    begin
      Result.Left := CR.Left;
      Result.Right := Result.Left + (R.Right - R.Left);

      OffsetRect(Result, IndentR.Left + 2, 0);
    end;
    taRightJustify:
    begin
      Result.Right := CR.Right;
      Result.Left := Result.Right - (R.Right - R.Left);

      OffsetRect(Result, -(CR.Right - IndentR.Right - 2), 0);
    end;
    taCenter:
    begin
      Result.Left := CR.Left + 2 + (((CR.Right - CR.Left) - (R.Right - R.Left)) div 2);
      Result.Right := Result.Left + (R.Right - R.Left);

      if HasImage then
        case FImageLayout of
          scilLeft:
            OffsetRect(Result, (ImageWidth + Spacing + 2) div 2, 0);
          scilRight:
            OffsetRect(Result, -(ImageWidth + Spacing + 2) div 2, 0);
        end;
    end;
  end;

  case FLayout of
    sclaTop:
    begin
      Result.Top := CR.Top;
      Result.Bottom := Result.Top + (R.Bottom - R.Top);

      OffsetRect(Result, 0, IndentR.Top + 2);
    end;
    sclaBottom:
    begin
      Result.Bottom := CR.Bottom;
      Result.Top := Result.Bottom - (R.Bottom - R.Top);

      OffsetRect(Result, 0, -(CR.Bottom - IndentR.Bottom - 2));
    end;
    sclaMiddle:
    begin
      Result.Top := CR.Top + 2 + (((CR.Bottom - CR.Top) - (R.Bottom - R.Top)) div 2);
      Result.Bottom := Result.Top + (R.Bottom - R.Top);

      if HasImage then
        case FImageLayout of
          scilTop:
            OffsetRect(Result, 0, (ImageHeight + Spacing + 2) div 2);
          scilBottom:
            OffsetRect(Result, 0, -(ImageHeight + Spacing + 2) div 2);
        end;
    end;
  end;

  CR := SR;

  if FRotation in [scroLeft, scroRight] then
    case FAlignment of
      taLeftJustify:
        Inc(Result.Right, 2);
      taRightJustify:
        Dec(Result.Left, 2);
      taCenter:
      begin
        Inc(Result.Right);
        Dec(Result.Left);
      end;
    end;

  if FRotation = scroLeft then
  begin
    TempR := Result;

    Result.Left := TempR.Top;
    Result.Right := TempR.Bottom;

    Result.Bottom := CR.Bottom - TempR.Left;
    Result.Top := Result.Bottom - (TempR.Right - TempR.Left);
  end else
  if FRotation = scroRight then
  begin
    TempR := Result;

    Result.Right := CR.Right - TempR.Top;
    Result.Left := Result.Right - (TempR.Bottom - TempR.Top);

    Result.Top := TempR.Left;
    Result.Bottom := TempR.Right;
  end;
end;

function TSCCustomPanel.HasGradient: Boolean;

  function IsGradientColor(C: TColor): Boolean;
  begin
    Result := (FGradientEnd = C);
    if Result and FGradientUsesMid then
      Result := (FGradientMid = C);
  end;

begin
  Result := (FGradient <> scgNone) and
    not (IsGradientColor(clNone) or IsGradientColor(Self.Color));
end;

procedure TSCCustomPanel.Paint;
var
  GradOrient: TSCGradient;
  CR, R, ImageR, TextR: TRect;
  FillCorner, UseMidGrad: Boolean;
  C, TopColor, BtmColor, BkColor: TColor;
begin
  if not HandleAllocated then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  R := CR;
  with Canvas do
  begin
    Brush.Style := bsSolid;

    if not HasGradient then
    begin
      Brush.Color := Self.Color;
      FillRect(R);

      if Transparent then
        PaintParentOn(Canvas);
    end else
    begin
      TopColor := Self.Color;
      BtmColor := FGradientEnd;

      UseMidGrad := FGradientUsesMid and (FGradientMid <> clNone);

      GradOrient := FGradient;

      if UseMidGrad then
      begin
        case FGradient of
          scgRightToLeft:
            GradOrient := scgLeftToRight;
          scgBottomToTop:
            GradOrient := scgTopToBottom;
        end;
      end;

      if not UseMidGrad then
        scDrawGradient(Canvas, R, GradOrient, TopColor, BtmColor)
      else begin
        if FGradient in [scgRightToLeft, scgBottomToTop] then
        begin
          C := TopColor;
          TopColor := BtmColor;
          BtmColor := C;
        end;

        case FGradient of
          scgLeftToRight, scgRightToLeft:
          begin
            R.Right := R.Left + ((R.Right - R.Left) div 2);
            scDrawGradient(Canvas, R, GradOrient, TopColor, FGradientMid);

            R.Left := R.Right;
            R.Right := CR.Right;

            scDrawGradient(Canvas, R, GradOrient, FGradientMid, BtmColor);
          end;
          scgTopToBottom, scgBottomToTop:
          begin
            R.Bottom := R.Top + ((R.Bottom - R.Top) div 2);
            scDrawGradient(Canvas, R, GradOrient, TopColor, FGradientMid);

            R.Top := R.Bottom;
            R.Bottom := CR.Bottom;

            scDrawGradient(Canvas, R, GradOrient, FGradientMid, BtmColor);
          end;
        end;
      end;
    end;
  end;

  DrawPicture(Canvas);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
  end;

  ImageR := Rect(0, 0, 0, 0);
  if IsValidImage(ImageIndex) then
  begin
    ImageR := GetImageRect;
    Images.Draw(Canvas, ImageR.Left, ImageR.Top, ImageIndex, Enabled);
  end;  

  TextR := GetTextRect;

  R := TextR;
  DoDrawText(R, False);

  if (FBevel <> sccbNone) and (FBevelEdges <> []) then
  begin
    R := CR;
    InflateRect(R, -FBevelWidth, -FBevelWidth);

    C := FBevelColor;
    if C = clNone then
    begin
      C := Self.Color;
      if C = clNone then C := clBtnFace;

      if FBevel in [sccbFlat, sccbFlatBold,
        sccbFlatRounded, sccbFlatBoldRounded] then
        C := GetBtnShadowOf(C);
    end;

    BkColor := TSCFakeControl(Parent).Color;
    if Self.BorderWidth > 0 then
      BkColor := Self.BorderColor
    else
    if (Self.Border <> sccbNone) or (Self.BorderInner <> sccbNone) then
      BkColor := Self.Color;

    FillCorner := (Self.Border = sccbNone) and (Self.BorderInner = sccbNone) and
      (Self.BorderWidth = 0) and (Self.BevelWidth = 0);

    scDrawBevel(Canvas, R, C, BkColor, FillCorner, FBevel, FBevelEdges);
  end;
end;

procedure TSCCustomPanel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TSCCustomPanel.SetBevel(Value: TSCControlBevel);
begin
  if FBevel <> Value then
  begin
    FBevel := Value;
    if FBevelEdges <> [] then
    begin
      Realign;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomPanel.SetBevelColor(Value: TColor);
begin
  if FBevelColor <> Value then
  begin
    FBevelColor := Value;
    if (FBevel <> sccbNone) and (FBevelEdges <> []) then
      Invalidate;
  end;
end;

procedure TSCCustomPanel.SetBevelEdges(Value: TSCBorderEdges);
begin
  if FBevelEdges <> Value then
  begin
    FBevelEdges := Value;
    if FBevel <> sccbNone then
    begin
      Realign;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomPanel.SetBevelWidth(Value: TSCBevelWidth);
begin
  if FBevelWidth <> Value then
  begin
    FBevelWidth := Value;
    if (FBevel <> sccbNone) and (FBevelEdges <> []) then
    begin
      Realign;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomPanel.SetEllipsisMode(Value: TSCEllipsis);
begin
  if FEllipsisMode <> Value then
  begin
    FEllipsisMode := Value;
    Invalidate;
  end;
end;

procedure TSCCustomPanel.SetGradient(Value: TSCGradient);
begin
  if FGradient <> Value then
  begin
    FGradient := Value;
    Invalidate;
  end;
end;

procedure TSCCustomPanel.SetGradientEnd(Value: TColor);
begin
  if FGradientEnd <> Value then
  begin
    FGradientEnd := Value;
    if FGradient <> scgNone then Invalidate;
  end;
end;

procedure TSCCustomPanel.SetGradientMid(Value: TColor);
begin
  if FGradientMid <> Value then
  begin
    FGradientMid := Value;
    if FGradientUsesMid and
      (FGradient <> scgNone) then Invalidate;
  end;
end;

procedure TSCCustomPanel.SetGradientUsesMid(Value: Boolean);
begin
  if FGradientUsesMid <> Value then
  begin
    FGradientUsesMid := Value;
    if (FGradient <> scgNone) and
      (FGradientMid <> clNone) then Invalidate;
  end;
end;

procedure TSCCustomPanel.SetImageLayout(Value: TSCImageLayout);
begin
  if FImageLayout <> Value then
  begin
    FImageLayout := Value;
    Invalidate;
  end;
end;

procedure TSCCustomPanel.SetIndentHorz(Value: Integer);
begin
  SetIndent(Value);
end;

procedure TSCCustomPanel.SetIndentVert(Value: Integer);
begin
  if FIndentVert <> Value then
  begin
    FIndentVert := Value;
    Invalidate;
  end;
end;

procedure TSCCustomPanel.SetLayout(Value: TSCLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TSCCustomPanel.SetMultiline(Value: Boolean);
begin
  if FMultiline <> Value then
  begin
    FMultiline := Value;
    Invalidate;
  end;
end;

procedure TSCCustomPanel.SetRotation(Value: TSCRotation);
begin
  if FRotation <> Value then
  begin
    FRotation := Value;
    Invalidate;
  end;
end;

procedure TSCCustomPanel.TransparentChanged;
begin
  if not HasGradient then
    Invalidate;
end;

{ TSCCustomSpinButton }

procedure TSCCustomSpinButton.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomSpinButton then
  begin
    with TSCCustomSpinButton(Source) do
    begin
      Self.ButtonColors := ButtonColors;
      Self.Direction := Direction;
      Self.IconColors := IconColors;
      Self.Increment := Increment;
      Self.Interval := Interval;
      Self.Max := Max;
      Self.Min := Min;
      Self.Orientation := Orientation;
      Self.Position := Position;
      Self.Style := Style;
      Self.Wrap := Wrap;
    end;
  end;
end;

function TSCCustomSpinButton.CanScroll(AsUp: Boolean): Boolean;
var
  IsUpBtn: Boolean;
begin
  Result := Enabled and (FPressedPart = FHotPart) and
    (FPressedPart <> scsbpNone);

  if Result then
  begin
    if FOrientation = scsoVertical then
      IsUpBtn := FPressedPart = scsbpUpButton
    else
      IsUpBtn := FPressedPart = scsbpDownButton;

    if AsUp then
      Result := (FWrap or (FPosition < FMax)) and IsUpBtn
    else
      Result := (FWrap or (FPosition > FMin)) and not IsUpBtn;
  end;
end;

constructor TSCCustomSpinButton.Create(AOwner: TComponent);
begin
  FScrollTimer := -1;
  inherited Create(AOwner);
  SetBounds(Left, Top, 18, 28);
  DoubleBuffered := True;

  ClickFocus := False;
  FDirection := scsdUpDown;
  FIncrement := 1;
  FInterval := 100;
  FMax := 100;
  FMin := 0;
  FOrientation := scsoVertical;
  FPosition := 0;
  FStyle := scsbsWindows;

  FButtonColors := TSCSpinButtonColors.Create(Self);
  FIconColors := TSCSpinButtonIconColors.Create(Self);
end;

destructor TSCCustomSpinButton.Destroy;
begin
  FreeAndNil(FButtonColors);
  FreeAndNil(FIconColors);

  inherited Destroy;
end;

procedure TSCCustomSpinButton.DoDrawDownButton(C: TCanvas; R: TRect);
var
  W, H, I: Integer;
  OffP, P: TPoint;
  C1, C2, C3, C4: TColor;
  IsDefault: Boolean;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  C1 := GetDownBtnColor;
  C2 := GetDownBtnIconColor;

  IsDefault := IsDownButtonDefault;

  if not Transparent or (FStyle = scsbsWindowsXP) or
    ((FStyle = scsbsOfficeXP) and not IsDownButtonDefault) then
    with C do
    begin
      Brush.Color := C1;
      FillRect(R);
    end;

  OffP := Point(0, 0);
  if not (FStyle in [scsbsWindowsXP, scsbsOfficeXP]) and
    (FPressedPart = FHotPart) and (FPressedPart = scsbpDownButton) then
  begin
    OffP := Point(1, 1);

    if FStyle in [scsbsMac, scsbsMetal] then
    begin
      if FOrientation = scsoHorizontal then
        OffP := Point(1, 0)
      else
        OffP := Point(0, 1);
    end;
  end;

  if C2 <> C1 then
  begin
    W := 6; H := 3;

    I := R.Right - R.Left;
    if I > R.Bottom - R.Top then
      I := R.Bottom - R.Top;

    if I < 16 then
    begin
      W := 4; H := 2;
      if I < 12 then
      begin
        W := 2;
        H := 1;
      end;
    end;

    if FOrientation = scsoHorizontal then
    begin
      P.x := R.Left + ((R.Right - R.Left + W - 2) div 2) + OffP.X;
      P.y := R.Top +  ((R.Bottom - R.Top + H - 2) div 2) + OffP.y;

      scDrawLeftSlider(C, P, W, H, sctsMac, False, C2, C2);
    end else
    begin
      P.x := R.Left + ((R.Right - R.Left + H) div 2) + OffP.x;
      P.y := R.Top +  ((R.Bottom - R.Top + H) div 2) + OffP.y;

      scDrawUpSlider(C, P, W, H, sctsMac, False, C2, C2);
    end;
  end;

  case FStyle of
    scsbsMetal:
    begin
      if (FHotPart = FPressedPart) and (FPressedPart = scsbpDownButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);

        scFrame3D(C, R, C1, GetBtnHighlightOf(C1), 1, 0);
      end else
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);

        scFrame3D(C, R, GetBtnHighlightOf(C1), C1, 1, 0);
      end;
    end;
    scsbsWindows, scsbsWindowsEx:
    begin
      if (FHotPart = FPressedPart) and (FPressedPart = scsbpDownButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scsbsWindowsFlat:
    begin
      if (FHotPart = FPressedPart) and (FPressedPart = scsbpDownButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scsbsWindowsFlatEx:
    begin
      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scsbsWindowsXP:
    begin
      DoDrawXPBtn(C, R, C1, FPressedPart = scsbpDownButton,
        (FHotPart = scsbpDownButton) and (FPressedPart = scsbpNone));

      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C2;

        W := 4;

        I := R.Right - R.Left;
        if I > R.Bottom - R.Top then
          I := R.Bottom - R.Top;

        if I < 14 then
        begin
          W := 3;
          if I < 8 then
            W := 2;
        end;

        if FOrientation = scsoHorizontal then
        begin
          Dec(P.x);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x - (W - 1), P.y - (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x - W, P.y + W);

            Inc(P.x);
          end;
        end else
        begin
          Dec(P.y);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x - (W - 1), P.y - (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y - W);

            Inc(P.y);
          end;
        end;
      end;
    end;
    scsbsOfficeXP:
    begin
      if (FStyle = scsbsOfficeXP) and not IsDefault then
        scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
    end;
    scsbsMac:
    begin
      if (FHotPart = FPressedPart) and (FPressedPart = scsbpDownButton) then
      begin
        C2 := SCCommon.scBlendColor(C1, -48);
        C3 := SCCommon.scBlendColor(C1, 48);
      end else
      begin
        C2 := SCCommon.scBlendColor(C1, 48);
        C3 := SCCommon.scBlendColor(C1, -48);
      end;

      InflateRect(R, -1, -1);
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C2, C3, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);
      scFrame3D(C, R, clWindowFrame, clWindowFrame, 1, 0);
    end;
  end;
end;

procedure TSCCustomSpinButton.DoDrawUpButton(C: TCanvas; R: TRect);
var
  W, H, I: Integer;
  OffP, P: TPoint;
  C1, C2, C3, C4: TColor;
  IsDefault: Boolean;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  C1 := GetUpBtnColor;
  C2 := GetUpBtnIconColor;

  IsDefault := IsUpButtonDefault;

  if not Transparent or (FStyle = scsbsWindowsXP) or
    ((FStyle = scsbsOfficeXP) and not IsDefault) then
    with C do
    begin
      Brush.Color := C1;
      FillRect(R);
    end;

  OffP := Point(0, 0);
  if not (FStyle in [scsbsWindowsXP, scsbsOfficeXP]) and
    (FPressedPart = FHotPart) and (FPressedPart = scsbpUpButton) then
  begin
    OffP := Point(1, 1);

    if FStyle in [scsbsMac, scsbsMetal] then
    begin
      if FOrientation = scsoHorizontal then
        OffP := Point(-1, 0)
      else
        OffP := Point(0, -1);
    end;
  end;

  if C2 <> C1 then
  begin
    W := 6; H := 3;

    I := R.Right - R.Left;
    if I > R.Bottom - R.Top then
      I := R.Bottom - R.Top;

    if I < 16 then
    begin
      W := 4; H := 2;
      if I < 12 then
      begin
        W := 2;
        H := 1;
      end;
    end;

    if FOrientation = scsoHorizontal then
    begin
      P.x := R.Left + ((R.Right - R.Left - W) div 2) + OffP.x;
      P.y := R.Top +  ((R.Bottom - R.Top + H - 2) div 2) + OffP.y;

      scDrawRightSlider(C, P, W, H, sctsMac, False, C2, C2);
    end else
    begin
      P.x := R.Left + ((R.Right - R.Left + H) div 2) + OffP.x;
      P.y := R.Top +  ((R.Bottom - R.Top - H) div 2) + OffP.y;

      scDrawDownSlider(C, P, W, H, sctsMac, False, C2, C2);
    end;
  end;

  case FStyle of
    scsbsMetal:
    begin
      if (FHotPart = FPressedPart) and (FPressedPart = scsbpUpButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);

        scFrame3D(C, R, C1, GetBtnHighlightOf(C1), 1, 0);
      end else
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);

        scFrame3D(C, R, GetBtnHighlightOf(C1), C1, 1, 0);
      end;
    end;
    scsbsWindows, scsbsWindowsEx:
    begin
      if (FHotPart = FPressedPart) and (FPressedPart = scsbpUpButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scsbsWindowsFlat:
    begin
      if (FHotPart = FPressedPart) and (FPressedPart = scsbpUpButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scsbsWindowsFlatEx:
    begin
      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scsbsWindowsXP:
    begin
      DoDrawXPBtn(C, R, C1, FPressedPart = scsbpUpButton,
        (FHotPart = scsbpUpButton) and (FPressedPart = scsbpNone));

      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C2;

        W := 4;

        I := R.Right - R.Left;
        if I > R.Bottom - R.Top then
          I := R.Bottom - R.Top;

        if I < 14 then
        begin
          W := 3;
          if I < 8 then
            W := 2;
        end;

        if FOrientation = scsoHorizontal then
        begin
          Dec(P.x);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x + W - 1, P.y - (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y + W);

            Inc(P.x);
          end;
        end else
        begin
          Dec(P.y);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x - (W - 1), P.y + (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y + W);

            Inc(P.y);
          end;
        end;
      end;
    end;
    scsbsOfficeXP:
    begin
      if (FStyle = scsbsOfficeXP) and not IsDefault then
        scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
    end;
    scsbsMac:
    begin
      if (FHotPart = FPressedPart) and (FPressedPart = scsbpUpButton) then
      begin
        C2 := SCCommon.scBlendColor(C1, -48);
        C3 := SCCommon.scBlendColor(C1, 48);
      end else
      begin
        C2 := SCCommon.scBlendColor(C1, 48);
        C3 := SCCommon.scBlendColor(C1, -48);
      end;

      InflateRect(R, -1, -1);
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C2, C3, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);
      scFrame3D(C, R, clWindowFrame, clWindowFrame, 1, 0);
    end;
  end;
end;

function TSCCustomSpinButton.GetDownBtnColor: TColor;
begin
  Result := FButtonColors.DefaultColor;
  if not Enabled then
    Result := FButtonColors.DisabledColor
  else
  if FStyle = scsbsOfficeXP then
  begin
    if (FPressedPart = scsbpDownButton) and (FHotPart = scsbpDownButton) then
      Result := GetOfficeXPDownedSelColor
    else
    if ((FPressedPart = scsbpNone) and (FHotPart = scsbpDownButton)) or
      ((FPressedPart = scsbpDownButton) and (FHotPart <> scsbpDownButton)) then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;
  end else
  if FPressedPart = scsbpDownButton then
    Result := FButtonColors.DownColor
  else
  if (FPressedPart = scsbpNone) and
    (FHotPart = scsbpDownButton) then
    Result := FButtonColors.HotColor
  else
  if HasFocus then
    Result := FButtonColors.ActiveColor;
end;

function TSCCustomSpinButton.GetDownBtnIconColor: TColor;
begin
  Result := FIconColors.DefaultColor;
  if not Enabled then
    Result := FIconColors.DisabledColor
  else
  if FStyle = scsbsOfficeXP then
  begin
    Result := clBtnText;
    if (FPressedPart = scsbpDownButton) and (FHotPart = scsbpDownButton) then
      Result := clHighlightText;
  end else
  if FPressedPart = scsbpDownButton then
    Result := FIconColors.DownColor
  else
  if (FPressedPart = scsbpNone) and
    (FHotPart = scsbpDownButton) then
    Result := FIconColors.HotColor
  else
  if HasFocus then
    Result := FIconColors.ActiveColor;
end;

function TSCCustomSpinButton.GetDownButtonRect: TRect;
var
  CR: TRect;
begin
  Result := Rect(0, 0, 0, 0);

  CR := GetClientRect;
  if IsRectEmpty(CR) then
    Exit;

  if ((FOrientation = scsoVertical) and (FDirection = scsdUpDown)) or
    ((FOrientation = scsoHorizontal) and (FDirection = scsdLeftRight)) then
  begin
    Result := CR;
    Result.Top := Result.Bottom - ((Result.Bottom - Result.Top) div 2);
  end else
  begin
    Result := CR;
    Result.Left := Result.Right - ((Result.Right - Result.Left) div 2);
  end;
end;

function TSCCustomSpinButton.GetPartAtPos(X, Y: Integer): TSCSpinButtonPart;
var
  P: TPoint;
  R: TRect;
begin
  Result := scsbpNone;

  P := Point(X, Y);
  R := GetClientRect;

  if not IsRectEmpty(R) and PtInRect(R, P) then
  begin
    R := GetUpButtonRect;
    if PtInRect(R, P) then
    begin
      Result := scsbpUpButton;
      Exit;
    end;

    R := GetDownButtonRect;
    if PtInRect(R, P) then
    begin
      Result := scsbpDownButton;
      Exit;
    end;
  end;
end;

function TSCCustomSpinButton.GetUpBtnColor: TColor;
begin
  Result := FButtonColors.DefaultColor;
  
  if not Enabled then
    Result := FButtonColors.DisabledColor
  else
  if FStyle = scsbsOfficeXP then
  begin
    if (FPressedPart = scsbpUpButton) and (FHotPart = scsbpUpButton) then
      Result := GetOfficeXPDownedSelColor
    else
    if ((FPressedPart = scsbpNone) and (FHotPart = scsbpUpButton)) or
      ((FPressedPart = scsbpUpButton) and (FHotPart <> scsbpUpButton)) then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;
  end else
  if FPressedPart = scsbpUpButton then
    Result := FButtonColors.DownColor
  else
  if (FPressedPart = scsbpNone) and (FHotPart = scsbpUpButton) then
    Result := FButtonColors.HotColor
  else
  if HasFocus then
    Result := FButtonColors.ActiveColor;
end;

function TSCCustomSpinButton.GetUpBtnIconColor: TColor;
begin
  Result := FIconColors.DefaultColor;
  if not Enabled then
    Result := FIconColors.DisabledColor
  else
  if FStyle = scsbsOfficeXP then
  begin
    Result := clBtnText;
    if (FPressedPart = scsbpUpButton) and (FHotPart = scsbpUpButton) then
      Result := clHighlightText;
  end else
  if FPressedPart = scsbpUpButton then
    Result := FIconColors.DownColor
  else
  if (FPressedPart = scsbpNone) and
    (FHotPart = scsbpUpButton) then
    Result := FIconColors.HotColor
  else
  if HasFocus then
    Result := FIconColors.ActiveColor;
end;

function TSCCustomSpinButton.GetUpButtonRect: TRect;
var
  CR: TRect;
begin
  Result := Rect(0, 0, 0, 0);

  CR := GetClientRect;
  if IsRectEmpty(CR) then
    Exit;

  if ((FOrientation = scsoVertical) and (FDirection = scsdUpDown)) or
    ((FOrientation = scsoHorizontal) and (FDirection = scsdLeftRight)) then
  begin
    Result := CR;
    Result.Bottom := Result.Top + ((Result.Bottom - Result.Top) div 2);
  end else
  begin
    Result := CR;
    Result.Right := Result.Left + ((Result.Right - Result.Left) div 2);
  end;
end;

procedure TSCCustomSpinButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  ProcessScrollKey(Key, False);
  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomSpinButton.Loaded;
begin
  inherited Loaded;
  Invalidate;
end;

procedure TSCCustomSpinButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  StopScrolling;

  if ClickFocus and CanGetFocus and not HasFocus then
    Exit;

  FPressedPart := scsbpNone;
  FHotPart := GetPartAtPos(X, Y);

  if Button = mbLeft then
  begin
    FPressedPart := FHotPart;
    Invalidate;

    if FPressedPart <> scsbpNone then
      StartScrolling;
  end;
end;

procedure TSCCustomSpinButton.MouseInControlChanged;
var
  P: TPoint;
begin
  if not MouseInControl then
    FHotPart := scsbpNone
  else
  if GetCursorPos(P) then
  begin
    P := Self.ScreenToClient(P);
    FHotPart := GetPartAtPos(P.x, P.y);
  end;

  Invalidate;

  if MouseInControl then
    ResumeScrolling
  else
    PauseScrolling;
end;

procedure TSCCustomSpinButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  OldHot: TSCSpinButtonPart;
begin
  OldHot := FHotPart;
  FHotPart := GetPartAtPos(X, Y);

  if OldHot <> FHotPart then
    Invalidate;

  if (FPressedPart <> scsbpNone) and (Scrolling or ScrollPaused) then
  begin
    if OldHot <> FHotPart then
      PauseScrolling
    else
    if ScrollPaused then
      ResumeScrolling;
  end;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomSpinButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  OldHot, OldPressed: TSCSpinButtonPart;
begin
  OldPressed := FPressedPart;
  OldHot := FHotPart;

  StopScrolling;

  FPressedPart := scsbpNone;
  FHotPart := scsbpNone;

  if (OldHot <> scsbpNone) or (OldPressed <> scsbpNone) then
    Invalidate;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomSpinButton.Paint;
var
  R: TRect;
  Cl: TColor;
begin
  R := GetClientRect;

  if Transparent and (FStyle <> scsbsWindowsXP) then
    PaintParentOn(Canvas)
  else begin
    with Canvas do
    begin
      Cl := Self.Color;
      if FStyle = scsbsWindowsXP then
        Cl := GetBtnHighlightOf(Cl);

      Brush.Style := bsSolid;
      Brush.Color := Cl;

      FillRect(R);
    end;
  end;

  R := GetUpButtonRect;
  DoDrawUpButton(Canvas, R);

  R := GetDownButtonRect;
  DoDrawDownButton(Canvas, R);
end;

procedure TSCCustomSpinButton.PauseScrolling;
begin
  FScrolling := False;
end;

procedure TSCCustomSpinButton.ProcessScrollKey(var Key: Word;
  IsKeyPress: Boolean);
begin
  case Key of
    VK_UP,
    VK_NEXT, VK_RIGHT:
      SetPosition(Position + Increment);
    VK_DOWN,
    VK_PRIOR, VK_LEFT:
      SetPosition(Position - Increment);
    VK_HOME:
      SetPosition(FMin);
    VK_END:
      SetPosition(FMax);
  end;
end;

procedure TSCCustomSpinButton.ResumeScrolling;
begin
  FScrolling := (FScrollTimer <> -1) and (CanScroll(True) or CanScroll(False));
end;

function TSCCustomSpinButton.Scrolling: Boolean;
begin
  Result := FScrolling and MouseInControl and
    (FScrollTimer <> -1) and (CanScroll(True) or CanScroll(False));
end;

function TSCCustomSpinButton.ScrollPaused: Boolean;
begin
  Result := not (FScrolling and Enabled and MouseInControl) and
    (FScrollTimer <> -1) and (CanScroll(True) or CanScroll(False));
end;

procedure TSCCustomSpinButton.SetButtonColors(Value: TSCSpinButtonColors);
begin
  FButtonColors.Assign(Value);
end;

procedure TSCCustomSpinButton.SetIconColors(Value: TSCSpinButtonColors);
begin
  FIconColors.Assign(Value);
end;

procedure TSCCustomSpinButton.SetIncrement(Value: Integer);
begin
  FIncrement := Value;
end;

procedure TSCCustomSpinButton.SetInterval(Value: Integer);
begin
  if Value < 10 then
    Value := 10;

  if FInterval <> Value then
  begin
    FInterval := Value;

    if Scrolling or ScrollPaused then
    begin
      PauseScrolling;
      ResumeScrolling;
    end;
  end;
end;

procedure TSCCustomSpinButton.SetMax(Value: Integer);
begin
  if Value < FMin then
    Value := FMin;

  if FMax <> Value then
  begin
    StopScrolling;

    FMax := Value;
    if FPosition > FMax then
      FPosition := Value;

    Change;
  end;
end;

procedure TSCCustomSpinButton.SetMin(Value: Integer);
begin
  if Value > FMax then
    Value := FMax;

  if FMin <> Value then
  begin
    StopScrolling;

    FMin := Value;
    if FPosition < FMin then
      FPosition := Value;

    Change;
  end;
end;

procedure TSCCustomSpinButton.SetOrientation(Value: TSCSpinButtonOrient);
var
  H: Integer;
  R: TRect;
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

procedure TSCCustomSpinButton.SetPosition(Value: Integer);
begin
  if Value > FMax then
  begin
    if FWrap then
      Value := FMin
    else
      Value := FMax;
  end else
  if Value < FMin then
  begin
    if FWrap then
      Value := FMax
    else
      Value := FMin;
  end;

  if FPosition <> Value then
  begin
    FPosition := Value;
    Click;
  end;
end;

procedure TSCCustomSpinButton.SetStyle(Value: TSCSpinButtonStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TSCCustomSpinButton.StartScrolling;
var
  OldPressed: TSCSpinButtonPart;
begin
  if HandleAllocated and (CanScroll(True) or CanScroll(False)) then
  begin
    if ScrollPaused then
    begin
      ResumeScrolling;
      Exit;
    end;

    if not Scrolling then
    begin
      OldPressed := FPressedPart;
      StopScrolling;

      if Enabled then
      begin
        FPressedPart := OldPressed;

        FScrollTimer := SetTimer(Handle, SC_BUTTON_REPEATTIMERID, scDblClickTime, nil);
        FScrolling := FScrollTimer <> -1;

        ScrollControl;
      end;  
    end;
  end;
end;

procedure TSCCustomSpinButton.StopScrolling;
begin
  FPressedPart := scsbpNone;
  FScrolling   := False;

  if HandleAllocated and (FScrollTimer <> -1) then
  begin
    if HandleAllocated then
      KillTimer(Handle, FScrollTimer);

    FScrollTimer := -1;
  end;
end;

procedure TSCCustomSpinButton.StopTracking;
begin
  FPressedPart := scsbpNone;
  FHotPart := scsbpNone;

  StopScrolling;
  inherited StopTracking;
end;

procedure TSCCustomSpinButton.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TSCCustomSpinButton.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if Message.WheelDelta < 0 then
    SetPosition(Position + Increment)
  else
  if Message.WheelDelta > 0 then
    SetPosition(Position - Increment);
end;

procedure TSCCustomSpinButton.WMTimer(var Message: TWMTimer);
begin
  inherited;

  if HandleAllocated and Scrolling and
    (Message.TimerID = SC_BUTTON_REPEATTIMERID) then
  begin
    if FScrollTimer <> -1 then
      KillTimer(Handle, FScrollTimer);

    if Enabled then
    begin
      FScrollTimer := SetTimer(Handle, SC_BUTTON_REPEATTIMERID, FInterval, nil);
      FScrolling := FScrollTimer <> -1;

      ScrollControl;
    end;
  end;
end;

procedure TSCCustomSpinButton.DoDrawXPBtn(C: TCanvas; R: TRect; Cl: TColor;
  IsDown, IsHot: Boolean);
var
  X, I: Integer;
  R1: TRect;
  FCl, C1: TColor;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  FCl := Cl;
  if IsDown then
    FCl := SCCommon.scBlendColor(FCl, -24)
  else
  if IsHot then
    FCl := SCCommon.scBlendColor(FCl, 16);

  R1 := R;
  with C do
  begin
    Brush.Style := bsSolid;
    Brush.Color := FCl;
    FillRect(R1);

    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
    Pen.Width := 1;

    C1 := GetBtnHighlightOf(Cl);
    scFrame3D(C, R1, C1, C1, 1, 0);

    C1 := SCCommon.scBlendColor(Cl, 32);
    scFrame3D(C, R1, C1, C1, 1, 0);
    InflateRect(R1, 1, 1);

    C1 := SCCommon.scBlendColor(Cl, -16);
    scFrame3D(C, R1, C1, C1, 1, 2);

    if IsDown then
      C1 := SCCommon.scBlendColor(FCl, -24)
    else
      C1 := SCCommon.scBlendColor(FCl, 16);

    Pen.Color := C1;
    MoveTo(R1.Left,  R1.Top);
    LineTo(R1.Right - 2, R1.Top);

    if IsDown then
    begin
      Pen.Color := SCCommon.scBlendColor(C1, 12);

      if R1.Top + 1 < R1.Bottom then
      begin
        MoveTo(R1.Left,  R1.Top + 1);
        LineTo(R1.Right - 2, R1.Top + 1);

        MoveTo(R1.Left,  R1.Top + 2);
        LineTo(R1.Right - 2, R1.Top + 2);
      end;  
    end;

    for I := 0 to 2 do
    begin
      Pen.Color := SCCommon.scBlendColor(FCl, -12 + 4*I);

      X := R1.Right - 2*I;
      if X < R1.Left then Break;

      MoveTo(X, R1.Top + 1);
      LineTo(X, R1.Bottom);

      Dec(X);
      if X < R1.Left then Break;

      MoveTo(X, R1.Top + 1);
      LineTo(X, R1.Bottom);
    end;

    if IsDown then
      for I := 0 to 2 do
      begin
        Pen.Color := SCCommon.scBlendColor(FCl, -18 + 6*I);

        X := R1.Left + 3*I;
        if X > R1.Right then Break;

        MoveTo(X, R1.Top + 1);
        LineTo(X, R1.Bottom);

        Inc(X);
        if X > R1.Right then Break;

        MoveTo(X, R1.Top + 1);
        LineTo(X, R1.Bottom);

        Inc(X);
        if X > R1.Right then Break;

        MoveTo(X, R1.Top + 1);
        LineTo(X, R1.Bottom);
      end;
  end;

  C1 := GetBtnHighlightOf(Cl);
  C1 := SCCommon.scBlendColor(C1, -16);

  R1 := R;
  scFrame3D(C, R1, C1, C1, 1, 4);
end;

procedure TSCCustomSpinButton.SetDirection(Value: TSCSpinDirection);
begin
  if FDirection <> Value then
  begin
    FDirection := Value;
    Invalidate;
  end;
end;

procedure TSCCustomSpinButton.Click;
begin
  Change;
  inherited Click;
end;

procedure TSCCustomSpinButton.ScrollControl;
var
  Btn: TSCSpinButtonPart;
begin
  if not Scrolling or ScrollPaused then
    Exit;

  if CanScroll(True) then
  begin
    SetPosition(Position + FIncrement);

    if not FWrap and (FPosition >= FMax) then
    begin
      Btn := FPressedPart;
      StopScrolling;

      FPressedPart := Btn;
      Invalidate;
    end;
  end else
  if CanScroll(False) then
  begin
    SetPosition(Position - FIncrement);

    if not FWrap and (FPosition <= FMin) then
    begin
      Btn := FPressedPart;
      StopScrolling;

      FPressedPart := Btn;
      Invalidate;
    end;
  end;
end;

function TSCCustomSpinButton.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomSpinButton.IsDownButtonDefault: Boolean;
begin
  Result := not (((FPressedPart = scsbpDownButton) and (FHotPart = scsbpDownButton)) or
    ((FPressedPart = scsbpNone) and (FHotPart = scsbpDownButton)) or
    ((FPressedPart = scsbpDownButton) and (FHotPart <> scsbpDownButton)));
end;

function TSCCustomSpinButton.IsUpButtonDefault: Boolean;
begin
  Result := not (((FPressedPart = scsbpUpButton) and (FHotPart = scsbpUpButton)) or
    ((FPressedPart = scsbpNone) and (FHotPart = scsbpUpButton)) or
    ((FPressedPart = scsbpUpButton) and (FHotPart <> scsbpUpButton)));
end;

procedure TSCCustomSpinButton.DblClick;
begin
  // Change;
  inherited DblClick;
end;

procedure TSCCustomSpinButton.EnabledChanged;
begin
  FPressedPart := scsbpNone;
  FHotPart := scsbpNone;

  StopScrolling;
  inherited EnabledChanged;
end;

{ TSCSpinButtonColors }

procedure TSCSpinButtonColors.Assign(Source: TPersistent);
begin
  if Source is TSCSpinButtonColors then
  begin
    with TSCSpinButtonColors(Source) do
    begin
      Self.FActiveColor := FActiveColor;
      Self.FDefaultColor := FDefaultColor;
      Self.FDisabledColor := FDisabledColor;
      Self.FDownColor := FDownColor;
      Self.FHotColor := FHotColor;
    end;

    DoChange;
  end else
    inherited Assign(Source);
end;

constructor TSCSpinButtonColors.Create(AOwner: TSCCustomSpinButton);
begin
  inherited Create;
  FOwner := AOwner;

  FActiveColor := clBtnFace;
  FDefaultColor := clBtnFace;
  FDisabledColor := clBtnFace;
  FDownColor := clBtnFace;
  FHotColor := clBtnFace;
end;

procedure TSCSpinButtonColors.DoChange;
begin
  if FOwner <> nil then
    FOwner.Invalidate;
end;

function TSCSpinButtonColors.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCSpinButtonColors.SetActiveColor(Value: TColor);
begin
  if FActiveColor <> Value then
  begin
    FActiveColor := Value;
    DoChange;
  end;
end;

procedure TSCSpinButtonColors.SetDefaultColor(Value: TColor);
begin
  if FDefaultColor <> Value then
  begin
    FDefaultColor := Value;
    DoChange;
  end;
end;

procedure TSCSpinButtonColors.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    DoChange;
  end;
end;

procedure TSCSpinButtonColors.SetDownColor(Value: TColor);
begin
  if FDownColor <> Value then
  begin
    FDownColor := Value;
    DoChange;
  end;
end;

procedure TSCSpinButtonColors.SetHotColor(Value: TColor);
begin
  if FHotColor <> Value then
  begin
    FHotColor := Value;
    DoChange;
  end;
end;

{ TSCSpinButtonIconColors }

constructor TSCSpinButtonIconColors.Create(AOwner: TSCCustomSpinButton);
begin
  inherited Create(AOwner);
  FActiveColor := clBtnText;
  FDefaultColor := clBtnText;
  FDisabledColor := clBtnShadow;
  FDownColor := clBtnText;
  FHotColor := clBtnText;
end;

{ TSCButtonBase }

procedure TSCButtonBase.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or (Self.Checked = False) then
        Self.Checked := Checked;
    end;
end;

procedure TSCButtonBase.CaptureChanged(Captured: Boolean);
begin
  inherited CaptureChanged(Captured);
  if not Captured then
  begin
    FDblClicked := False;
    StopTracking;
  end;
end;

constructor TSCButtonBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEndEllipsis := True;
end;

procedure TSCButtonBase.DoMouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  FDblClicked := ssDouble in Shift;
  inherited DoMouseDown(Button, Shift, X, Y);
end;

procedure TSCButtonBase.DoMouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if FDblClicked then
  begin
    FDblClicked := False;
    Click;
  end;

  inherited DoMouseUp(Button, Shift, X, Y);
end;

function TSCButtonBase.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TSCButtonActionLink;
end;

function TSCButtonBase.GetChecked: Boolean;
begin
  Result := False;
end;

function TSCButtonBase.IsCheckedStored: Boolean;
begin
  Result := (ActionLink = nil) or not TSCButtonActionLink(ActionLink).IsCheckedLinked;
end;

procedure TSCButtonBase.SetChecked(Value: Boolean);
begin
  //
end;

procedure TSCButtonBase.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    Invalidate;
  end;
end;

{ TSCProgressBorderProps }

constructor TSCProgressBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccb3DLowered;
end;

{ TSCCustomSlider }

procedure TSCCustomSlider.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomSlider then
    Slider.Assign(TSCCustomSlider(Source).Slider);
end;

constructor TSCCustomSlider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TabStop := True;
  ClickFocus := True;
  PositionColor := clHighlight;

  FPageSize := 2;
  FSlider := TSCSliderProps.Create(Self);
end;

destructor TSCCustomSlider.Destroy;
begin
  FreeAndNil(FSlider);
  inherited Destroy;
end;

procedure TSCCustomSlider.DoCustomDraw(ACanvas: TCanvas);
var
  R: TRect;
  P: TPoint;
  W, H: Integer;
  C1, C2: TColor;
begin
  if GetSliderVisible then
  begin
    R := GetSliderRect;

    if not IsRectEmpty(R) then
    begin
      if FSlider.Style <> scssNew then
        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FSlider.Color;

          FillRect(R);
        end;

      case FSlider.Style of
        scssMetal:
        begin
          C1 := GetBtnShadowOf(FSlider.Color);
          C2 := C1;

          scFrame3D(ACanvas, R, C1, C2, 1, 0);

          C1 := GetBtnHighlightOf(FSlider.Color);
          C2 := FSlider.Color;

          scFrame3D(ACanvas, R, C1, C2, 1, 0);
        end;
        scssNew:
        begin
          if Orientation = scoHorizontal then
          begin
            W := R.Right - R.Left;
            H := R.Bottom - R.Top;

            P.x := R.Left + ((R.Right - R.Left) div 2);
            P.y := R.Bottom;

            C1 := FSlider.Color;
            C2 := FSlider.FrameColor;

            scDrawUpSlider(ACanvas, P, W, H, sctsNew, True, C2, C1);
          end else
          begin
            W := R.Bottom - R.Top;
            H := R.Right - R.Left;

            P.x := R.Right;
            P.y := R.Top + ((R.Bottom - R.Top) div 2);

            C1 := FSlider.Color;
            C2 := FSlider.FrameColor;

            scDrawLeftSlider(ACanvas, P, W, H, sctsNew, True, C2, C1);
          end;
        end;
        scssPSNew:
        begin
          C1 := Get3DDkShadowOf(FSlider.Color);
          C2 := C1;

          scFrame3D(ACanvas, R, C1, C2, 1, 0);

          C1 := GetBtnHighlightOf(FSlider.Color);
          C2 := FSlider.Color;

          scFrame3D(ACanvas, R, C1, C2, 1, 0);
        end;
        scssWindows:
        begin
          C1 := GetBtnHighlightOf(FSlider.Color);
          C2 := Get3DDkShadowOf(FSlider.Color);

          scFrame3D(ACanvas, R, C1, C2, 1, 0);

          C1 := FSlider.Color;
          C2 := GetBtnShadowOf(FSlider.Color);

          scFrame3D(ACanvas, R, C1, C2, 1, 0);
        end;
      end;
    end;
  end;
end;

function TSCCustomSlider.GetSliderRect: TRect;
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
        RectSize := R.Right - R.Left
      else
        RectSize := R.Bottom - R.Top;

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
      Dec(Result.Bottom, P - Dif);
      Result.Top := Result.Bottom - FSlider.Size;
    end;
  end;
end;

function TSCCustomSlider.GetSliderVisible: Boolean;
begin
  Result := FSlider.Visible and (FSlider.Color <> clNone);
end;

procedure TSCCustomSlider.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  ProcessTrackKey(Key);
end;

procedure TSCCustomSlider.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if not (Ord(Key) in [VK_HOME, VK_END]) then
    ProcessTrackKey(Ord(Key));
end;

procedure TSCCustomSlider.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if CanGetFocus and not Focused then
    Self.SetFocus;

  if Focused and MouseIsDown then
    SetPosition(PositionAtPos(Point(X, Y)));
end;

procedure TSCCustomSlider.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if MouseIsDown then
    SetPosition(PositionAtPos(Point(X, Y)));

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomSlider.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if MouseIsDown then
    SetPosition(PositionAtPos(Point(X, Y)));

  inherited MouseUp(Button, Shift, X, Y);
end;

function TSCCustomSlider.OnSlider(P: TPoint): Boolean;
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

function TSCCustomSlider.PositionAtPos(P: TPoint): Integer;
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
        Result := Max;
        Exit;
      end;

      if P.y > R.Bottom then
      begin
        Result := Min;
        Exit;
      end;

      Result := Max - Muldiv(Count, P.y, R.Bottom);
    end;
  end;

  if Result < Min then
    Result := Min;

  if Result > Max then
    Result := Max;
end;

procedure TSCCustomSlider.ProcessTrackKey(Key: Word);
var
  P1, P2: Integer;
begin
  P1 := NormalizePosition(Position);
  P2 := P1;

  case Key of
    VK_LEFT, VK_UP:
      Dec(P2);
    VK_RIGHT, VK_DOWN:
      Inc(P2);
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

procedure TSCCustomSlider.SetSlider(Value: TSCSliderProps);
begin
  FSlider.Assign(Value);
end;

procedure TSCCustomSlider.SliderChanged;
begin
  Invalidate;
end;

procedure TSCCustomSlider.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTALLKEYS or DLGC_WANTARROWS;
end;

procedure TSCCustomSlider.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if Message.WheelDelta < 0 then
    SetPosition(Position + PageSize)
  else
  if Message.WheelDelta > 0 then
    SetPosition(Position - PageSize);
end;

{ TSCSliderProps }

procedure TSCSliderProps.Assign(Source: TPersistent);
begin
  if Source is TSCSliderProps then
  begin
    with TSCSliderProps(Source) do
    begin
      Self.FColor := Color;
      Self.FFrameColor := FrameColor;
      Self.FSize := Size;
      Self.FStyle := Style;
      Self.FVisible := Visible;
    end;

    Changed;
  end else
    inherited Assign(Source);
end;

procedure TSCSliderProps.Changed;
begin
  if FOwner <> nil then FOwner.SliderChanged;
end;

constructor TSCSliderProps.Create(AOwner: TSCCustomSlider);
begin
  inherited Create;
  FOwner := AOwner;
  FColor := clBtnFace;
  FFrameColor := clGreen;
  FSize := 8;
  FStyle := scssWindows;
  FVisible := True;
end;

function TSCSliderProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCSliderProps.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed;
  end;
end;

procedure TSCSliderProps.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    if FStyle = scssNew then
      Changed;
  end;
end;

procedure TSCSliderProps.SetSize(Value: Integer);
begin
  if Value < 2 then
    Value := 2;

  if FSize <> Value then
  begin
    FSize := Value;
    Changed;
  end;
end;

procedure TSCSliderProps.SetStyle(Value: TSCSliderStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Changed;
  end;
end;

procedure TSCSliderProps.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed;
  end;
end;

{ TSCGroupBoxBorderProps }

constructor TSCGroupBoxBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccbNone;
end;

{ TSCCustomGroupBox }

procedure TSCCustomGroupBox.AdjustBevelRect(var Rect: TRect; IncludeLines: Boolean);
var
  W: Integer;
begin
  if (Bevel <> sccbNone) and (FBevelEdges <> []) then
  begin
    W := GetBevelSize(IncludeLines);

    if scbeLeft in FBevelEdges then
      Inc(Rect.Left, W);

    if scbeTop in FBevelEdges then
      Inc(Rect.Top, W);

    if scbeRight in FBevelEdges then
      Dec(Rect.Right, W);

    if scbeBottom in FBevelEdges then
      Dec(Rect.Bottom, W);
  end;
end;

procedure TSCCustomGroupBox.AdjustBounds;
begin
  Realign;
end;

procedure TSCCustomGroupBox.AdjustClientRect(var Rect: TRect);
var
  F: TFont;
  L, H: Integer;
  TM: TTextMetric;
begin
  inherited AdjustClientRect(Rect);

  AdjustBevelRect(Rect);

  if HandleAllocated and (Canvas <> nil) then
  begin
    L := 0;
    if FCaptionBevel <> sccbNone then L := 4;

    F := TFont.Create;
    try
      F.Assign(Canvas.Font);
      try
        Canvas.Font := Self.FCaptionFont;

        if FAlignment in [scgaLeftTop, scgaLeftCenter, scgaLeftBottom,
          scgaRightTop, scgaRightCenter, scgaRightBottom] then
        begin
          GetTextMetrics(Canvas.Handle, TM);
          if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
            Canvas.Font.Name := 'Arial';
        end;

        H := Canvas.TextHeight('0q') + 2;
        Inc(H, L);

        if FAlignment in [scgaTopLeft, scgaTopCenter, scgaTopRight] then
          Inc(Rect.Top, H)
        else
        if FAlignment in [scgaBottomLeft, scgaBottomCenter, scgaBottomRight] then
          Dec(Rect.Bottom, H)
        else
        if FAlignment in [scgaLeftTop, scgaLeftCenter, scgaLeftBottom] then
          Inc(Rect.Left, H)
        else
        if FAlignment in [scgaRightTop, scgaRightCenter, scgaRightBottom] then
          Dec(Rect.Right, H);
      finally
        Canvas.Font := F;
      end;
    finally
      F.Free;
    end;
  end;
end;

procedure TSCCustomGroupBox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomGroupBox then
  begin
    with TSCCustomGroupBox(Source) do
    begin
      Self.Alignment := Alignment;
      Self.Bevel := Bevel;
      Self.BevelEdges := BevelEdges;
      Self.BevelColor := BevelColor;
      Self.BevelWidth := BevelWidth;
      Self.CaptionBkColor := CaptionBkColor;
      Self.CaptionBevel := CaptionBevel;
      Self.CaptionBevelColor := CaptionBevelColor;
      Self.CaptionFont := CaptionFont;
      Self.SpareColor := SpareColor;
    end;
  end;
end;

procedure TSCCustomGroupBox.CaptionFontChanged(Sender: TObject);
begin
  if not IsLoading then
  begin
    Realign;
    Invalidate;
  end;  
end;

constructor TSCCustomGroupBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls, csSetCaption, csOpaque,
    csDoubleClicks];
  SetBounds(Left, Top, 185, 105);
  Border := sccbNone;
  TabStop := False;
  Indent := 6;
  ClickFocus := False;

  FCaptionFont := TFont.Create;
  FCaptionFont.OnChange := CaptionFontChanged;

  FAlignment := scgaTopLeft;
  FBevel := sccbFlat;
  FBevelEdges := SCAllBorderEdges;
  FBevelColor := clNone;
  FBevelWidth := 0;
  FCaptionBkColor := clNone;
  FCaptionBevel := sccbNone;
  FCaptionBevelColor := clNone;
  FSpareColor := clNone;
end;

procedure TSCCustomGroupBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params.WindowClass do
    style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

destructor TSCCustomGroupBox.Destroy;
begin
  FCaptionFont.OnChange := nil;
  FreeAndNil(FCaptionFont);

  inherited Destroy;
end;

procedure TSCCustomGroupBox.DoDrawBevel;
var
  Ft: hFont;
  LF: TLogFont;
  TM: TTextMetric;
  FillCorner: Boolean;
  R, BvR, CapR, CR: TRect;
  SR, Esc, L, X, Y: Integer;
  Cl, FnCl, BvCl, CpCl, CpBvCl, BkColor: TColor;
begin
  if not HandleAllocated then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  if IsRectEmpty(CR) then
    Exit;

  Cl := Self.Color;
  if Cl = clNone then Cl := clBtnFace;

  FnCl := Self.FCaptionFont.Color;
  if FnCl = clNone then FnCl := clBtnText;

  CapR := GetCaptionRect;
  if (FBevel <> sccbNone) and (FBevelEdges <> []) then
  begin
    BvR := GetBevelRect;

    if not IsRectEmpty(BvR) then
    begin
      if not Transparent and (FSpareColor <> clNone) then
      begin
        R := BvR;

        L := GetBevelLineSize(FBevel) div 2;
        if L > 0 then
        begin
          if FAlignment in [scgaTopLeft, scgaTopCenter, scgaTopRight] then
            Inc(R.Top, L)
          else
          if FAlignment in [scgaBottomLeft, scgaBottomCenter, scgaBottomRight] then
            Dec(R.Bottom, L)
          else
          if FAlignment in [scgaLeftTop, scgaLeftCenter, scgaLeftBottom] then
            Inc(R.Left, L)
          else
          if FAlignment in [scgaRightTop, scgaRightCenter, scgaRightBottom] then
            Dec(R.Right, L);
        end;

        SR := ExcludeClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
        try
          if SR <> NULLREGION then
            with Canvas do
            begin
              Brush.Style := bsSolid;
              Brush.Color := FSpareColor;

              FillRect(CR);
            end;
        finally
          SelectClipRgn(Canvas.Handle, 0);
        end;
      end;

      BvCl := FBevelColor;
      if BvCl = clNone then
      begin
        BvCl := Cl;

        if FBevel in [sccbFlat, sccbFlatBold,
          sccbFlatRounded, sccbFlatBoldRounded] then
          BvCl := GetBtnShadowOf(BvCl);
      end;    

      BkColor := TSCFakeControl(Parent).Color;
      if Self.BorderWidth > 0 then
        BkColor := Self.BorderColor
      else
      if (Self.Border <> sccbNone) or (Self.BorderInner <> sccbNone) then
        BkColor := Self.Color;

      FillCorner := (Self.Border = sccbNone) and (Self.BorderInner = sccbNone) and
        (Self.BorderWidth = 0) and (Self.BevelWidth = 0);

      if IsRectEmpty(CapR) then
        scDrawBevel(Canvas, BvR, BvCl, BkColor, FillCorner, FBevel, FBevelEdges)
      else begin
        SR := ExcludeClipRect(Canvas.Handle, CapR.Left, CapR.Top, CapR.Right,
          CapR.Bottom);

        try
          if SR <> NULLREGION then
            scDrawBevel(Canvas, BvR, BvCl, BkColor, FillCorner, FBevel, FBevelEdges);
        finally
          SelectClipRgn(Canvas.Handle, 0);
        end;
      end;
    end;
  end;

  if (Caption <> '') and not IsRectEmpty(CapR) then
  begin
    CpCl := FCaptionBkColor;
    if CpCl = clNone then CpCl := Cl;

    if FCaptionBkColor <> clNone then
      with Canvas do
      begin
        Brush.Color := CpCl;
        Brush.Style := bsSolid;

        FillRect(CapR);
      end;

    L := 0;
    if FCaptionBevel <> sccbNone then L := 2;

    with Canvas do
    begin
      Brush.Color := Self.Color;
      Brush.Style := bsClear;

      Font := Self.FCaptionFont;
      Font.Color := FnCl;

      R := CapR;

      if FAlignment in [scgaTopLeft, scgaTopCenter, scgaTopRight,
        scgaBottomLeft, scgaBottomCenter, scgaBottomRight, scgaCenter] then
      begin
        InflateRect(R, -(L + 2), -(L + 1));

        DrawText(Handle, PChar(Caption), Length(Caption), R,
          DT_CENTER or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
      end else
      begin
        InflateRect(R, -(L + 1), -(L + 2));

        GetTextMetrics(Handle, TM);
        if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
          Font.Name := 'Arial';

        GetObject(Font.Handle, SizeOf(LF), @LF);

        Esc := 2700;
        if FAlignment in [scgaLeftTop, scgaLeftCenter, scgaLeftBottom] then
          Esc := 900;

        LF.lfEscapement := Esc;  
        Ft := CreateFontIndirect(LF);
        Font.Handle := Ft;

        if FAlignment in [scgaLeftTop, scgaLeftCenter, scgaLeftBottom] then
        begin
          X := R.Left;
          Y := R.Bottom - Spacing;
        end else
        begin
          X := R.Right;
          Y := R.Top + Spacing;
        end;

        SetBkMode(Handle, Windows.TRANSPARENT);
        ExtTextOut(Handle, X, Y, ETO_CLIPPED, @R, PChar(Caption),
          Length(Caption), nil)
      end;
    end;

    if FCaptionBevel <> sccbNone then
    begin
      R := CapR;

      CpBvCl := FCaptionBevelColor;
      if CpBvCl = clNone then
      begin
        CpBvCl := CpCl;

        if FCaptionBevel in [sccbFlat, sccbFlatBold,
          sccbFlatRounded, sccbFlatBoldRounded] then
          CpBvCl := GetBtnShadowOf(CpBvCl);
      end;    

      scDrawBevel(Canvas, R, CpBvCl, clNone, False, FCaptionBevel, [scbeLeft, scbeRight, scbeTop, scbeBottom]);
    end;
  end;
end;

function TSCCustomGroupBox.GetBevelLineSize(Value: TSCControlBevel): Integer;
begin
  Result := 0;

  if Value in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
    Result := 1
  else
  if Value in [sccbFlatBold, sccbFlatRounded, sccbFlatBoldRounded,
    sccb3DRaised, sccb3DLowered, sccbBumped, sccbEtched, sccbMacLowered,
    sccbMacRaised, sccbMetal, sccbSoftLowered, sccbSoftRaised] then
    Result := 2;
end;

function TSCCustomGroupBox.GetBevelRect: TRect;
var
  F: TFont;
  H, L: Integer;
  TM: TTextMetric;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated and (Canvas <> nil) then
  begin
    Result := GetClientRect;
    AdjustBevelRect(Result, False);

    F := TFont.Create;
    try
      F.Assign(Canvas.Font);
      try
        Canvas.Font := Self.Font;

        if FAlignment in [scgaLeftTop, scgaLeftCenter, scgaLeftBottom,
          scgaRightTop, scgaRightCenter, scgaRightBottom] then
        begin
          GetTextMetrics(Canvas.Handle, TM);
          if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
            Canvas.Font.Name := 'Arial';
        end;

        H := Canvas.TextHeight('0q') + 2;

        L := 0;
        if FCaptionBevel <> sccbNone then L := 2;

        Inc(H, 2*L);

        L := 0;
        if (FBevel <> sccbNone) and (FBevelEdges <> []) then
          L := GetBevelLineSize(FBevel);

        if FAlignment in [scgaTopLeft, scgaTopCenter, scgaTopRight] then
        begin
          Inc(Result.Top, H div 2);
          if (Bevel <> sccbNone) and (scbeTop in FBevelEdges) then
            Dec(Result.Top, L);
        end else
        if FAlignment in [scgaBottomLeft, scgaBottomCenter, scgaBottomRight] then
        begin
          Dec(Result.Bottom, H div 2);
          if (Bevel <> sccbNone) and (scbeBottom in FBevelEdges) then
            Inc(Result.Bottom, L);
        end else
        if FAlignment in [scgaLeftTop, scgaLeftCenter, scgaLeftBottom] then
        begin
          Inc(Result.Left, H div 2);
          if (Bevel <> sccbNone) and (scbeLeft in FBevelEdges) then
            Dec(Result.Left, L);
        end else
        if FAlignment in [scgaRightTop, scgaRightCenter, scgaRightBottom] then
        begin
          Dec(Result.Right, H div 2);
          if (Bevel <> sccbNone) and (scbeRight in FBevelEdges) then
            Inc(Result.Right, L);
        end;
      finally
        Canvas.Font := F;
      end;
    finally
      F.Free;
    end;
  end;  
end;

function TSCCustomGroupBox.GetBevelSize(IncludeLines: Boolean): Integer;
begin
  Result := 0;
  if (Bevel <> sccbNone) and (FBevelEdges <> []) then
  begin
    Inc(Result, BevelWidth);
    if IncludeLines then Inc(Result, GetBevelLineSize(FBevel));
  end;
end;

function TSCCustomGroupBox.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCGroupBoxBorderProps;
end;

function TSCCustomGroupBox.GetCaptionRect: TRect;
var
  F: TFont;
  TM: TTextMetric;
  W, H, L, Cb: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated and (Canvas <> nil) and (Caption <> '') then
  begin
    Result := GetClientRect;
    AdjustBevelRect(Result);

    Cb := 0;
    if FCaptionBevel <> sccbNone then Cb := 4;

    F := TFont.Create;
    try
      F.Assign(Canvas.Font);
      try
        Canvas.Font := Self.FCaptionFont;

        if FAlignment in [scgaLeftTop, scgaLeftCenter, scgaLeftBottom,
          scgaRightTop, scgaRightCenter, scgaRightBottom] then
        begin
          GetTextMetrics(Canvas.Handle, TM);
          if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
            Canvas.Font.Name := 'Arial';
        end;

        H := Canvas.TextHeight('0q') + 2 + Cb;
        W := Canvas.TextWidth(Caption) + 4 + Cb;

        L := 0;
        if (FBevel <> sccbNone) and (FBevelEdges <> []) then
          L := GetBevelLineSize(FBevel);

        case FAlignment of
          scgaCenter:
          begin
            Inc(Result.Left, ((Result.Right - Result.Left) - W) div 2);
            Result.Right := Result.Left + W;

            Inc(Result.Top, ((Result.Bottom - Result.Top) - H) div 2);
            Result.Bottom := Result.Top + H;
          end;
          scgaTopLeft:
          begin
            Inc(Result.Left, Indent);
            Result.Right := Result.Left + W;
            Result.Bottom := Result.Top + H;

            if (Bevel <> sccbNone) and (scbeTop in FBevelEdges) then
              OffsetRect(Result, 0, -L);

            InflateRect(Result, Spacing, 0);
            OffsetRect(Result, Spacing, 0);
          end;
          scgaTopCenter:
          begin
            Inc(Result.Left, ((Result.Right - Result.Left) - W) div 2);
            Result.Right := Result.Left + W;
            Result.Bottom := Result.Top + H;

            if (Bevel <> sccbNone) and (scbeTop in FBevelEdges) then
              OffsetRect(Result, 0, -L);

            InflateRect(Result, Spacing, 0);
          end;
          scgaTopRight:
          begin
            Dec(Result.Right, Indent);
            Result.Left := Result.Right - W;
            Result.Bottom := Result.Top + H;

            if (Bevel <> sccbNone) and (scbeTop in FBevelEdges) then
              OffsetRect(Result, 0, -L);

            InflateRect(Result, Spacing, 0);
            OffsetRect(Result, -Spacing, 0);
          end;
          scgaBottomLeft:
          begin
            Inc(Result.Left, Indent);
            Result.Right := Result.Left + W;
            Result.Top := Result.Bottom - H;

            if (Bevel <> sccbNone) and (scbeBottom in FBevelEdges) then
              OffsetRect(Result, 0, L);

            InflateRect(Result, Spacing, 0);
            OffsetRect(Result, Spacing, 0);
          end;
          scgaBottomCenter:
          begin
            Inc(Result.Left, ((Result.Right - Result.Left) - W) div 2);
            Result.Right := Result.Left + W;
            Result.Top := Result.Bottom - H;

            if (Bevel <> sccbNone) and (scbeBottom in FBevelEdges) then
              OffsetRect(Result, 0, L);

            InflateRect(Result, Spacing, 0);
          end;
          scgaBottomRight:
          begin
            Dec(Result.Right, Indent);
            Result.Left := Result.Right - W;
            Result.Top := Result.Bottom - H;

            if (Bevel <> sccbNone) and (scbeBottom in FBevelEdges) then
              OffsetRect(Result, 0, L);

            InflateRect(Result, Spacing, 0);
            OffsetRect(Result, -Spacing, 0);
          end;
          scgaLeftTop:
          begin
            Inc(Result.Top, Indent);
            Result.Bottom := Result.Top + W;
            Result.Right := Result.Left + H;

            if (Bevel <> sccbNone) and (scbeLeft in FBevelEdges) then
              OffsetRect(Result, -L, 0);

            InflateRect(Result, 0, Spacing);
            OffsetRect(Result, 0, Spacing);
          end;
          scgaLeftCenter:
          begin
            Inc(Result.Top, ((Result.Bottom - Result.Top) - W) div 2);
            Result.Bottom := Result.Top + W;
            Result.Right := Result.Left + H;

            if (Bevel <> sccbNone) and (scbeLeft in FBevelEdges) then
              OffsetRect(Result, -L, 0);

            InflateRect(Result, 0, Spacing);
          end;
          scgaLeftBottom:
          begin
            Dec(Result.Bottom, Indent);
            Result.Top := Result.Bottom - W;
            Result.Right := Result.Left + H;

            if (Bevel <> sccbNone) and (scbeLeft in FBevelEdges) then
              OffsetRect(Result, -L, 0);

            InflateRect(Result, 0, Spacing);
            OffsetRect(Result, 0, -Spacing);
          end;
          scgaRightTop:
          begin
            Inc(Result.Top, Indent);
            Result.Bottom := Result.Top + W;
            Result.Left := Result.Right - H;

            if (Bevel <> sccbNone) and (scbeRight in FBevelEdges) then
              OffsetRect(Result, L, 0);

            InflateRect(Result, 0, Spacing);
            OffsetRect(Result, 0, Spacing);
          end;
          scgaRightCenter:
          begin
            Inc(Result.Top, ((Result.Bottom - Result.Top) - W) div 2);
            Result.Bottom := Result.Top + W;
            Result.Left := Result.Right - H;

            if (Bevel <> sccbNone) and (scbeRight in FBevelEdges) then
              OffsetRect(Result, L, 0);

            InflateRect(Result, 0, Spacing);
          end;
          scgaRightBottom:
          begin
            Dec(Result.Bottom, Indent);
            Result.Top := Result.Bottom - W;
            Result.Left := Result.Right - H;

            if (Bevel <> sccbNone) and (scbeRight in FBevelEdges) then
              OffsetRect(Result, L, 0);

            InflateRect(Result, 0, Spacing);
            OffsetRect(Result, 0, -Spacing);
          end;
        end;
      finally
        Canvas.Font := F;
      end;
    finally
      F.Free;
    end;
  end;
end;

procedure TSCCustomGroupBox.Paint;
var
  CR: TRect;
  Cl: TColor;
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
  DoDrawBevel;
end;

procedure TSCCustomGroupBox.SetAlignment(Value: TSCGroupBoxAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Realign;
    Invalidate;
  end;
end;

procedure TSCCustomGroupBox.SetBevel(Value: TSCControlBevel);
begin
  if FBevel <> Value then
  begin
    FBevel := Value;
    Realign;
    Invalidate;
  end;
end;

procedure TSCCustomGroupBox.SetBevelColor(Value: TColor);
begin
  if FBevelColor <> Value then
  begin
    FBevelColor := Value;
    if (FBevel <> sccbNone) and (FBevelEdges <> []) then
      Invalidate;
  end;
end;

procedure TSCCustomGroupBox.SetBevelEdges(Value: TSCBorderEdges);
begin
  if FBevelEdges <> Value then
  begin
    FBevelEdges := Value;
    Realign;
    Invalidate;
  end;
end;

procedure TSCCustomGroupBox.SetBevelWidth(Value: TSCBevelWidth);
begin
  if FBevelWidth <> Value then
  begin
    FBevelWidth := Value;
    Realign;
    Invalidate;
  end;
end;

procedure TSCCustomGroupBox.SetCaptionBevel(Value: TSCControlBevel);
begin
  if FCaptionBevel <> Value then
  begin
    FCaptionBevel := Value;
    if Caption <> '' then
    begin
      Realign;
      Invalidate;
    end;  
  end;
end;

procedure TSCCustomGroupBox.SetCaptionBevelColor(Value: TColor);
begin
  if FCaptionBevelColor <> Value then
  begin
    FCaptionBevelColor := Value;
    if (FCaptionBevel <> sccbNone) and (Caption <> '') then
      Invalidate;
  end;
end;

procedure TSCCustomGroupBox.SetCaptionBkColor(Value: TColor);
begin
  if FCaptionBkColor <> Value then
  begin
    FCaptionBkColor := Value;
    if Caption <> '' then
      Invalidate;
  end;
end;

procedure TSCCustomGroupBox.SetCaptionFont(Value: TFont);
begin
  FCaptionFont.Assign(Value);
end;

procedure TSCCustomGroupBox.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;
  inherited SetIndent(Value);
end;

procedure TSCCustomGroupBox.SetSpareColor(Value: TColor);
begin
  if FSpareColor <> Value then
  begin
    FSpareColor := Value;
    Invalidate;
  end;
end;

{ TSCButtonActionLink }

procedure TSCButtonActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  FClient := AClient as TSCButtonBase;
end;

function TSCButtonActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and
    (FClient.Checked = (Action as TCustomAction).Checked);
end;

procedure TSCButtonActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then FClient.Checked := Value;
end;

{$I SCVerRec.inc}

end.
