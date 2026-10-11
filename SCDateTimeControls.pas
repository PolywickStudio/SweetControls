{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCDateTimeControls;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Extctrls, ImgList, StdActns, ActnList, Menus, SCCommon, SCConsts, SCResStrs,
  SCControl, SCAdvEdits;

type
  TSCCalendarOption = (sccoDayCaptions, sccoWeekNumbers, sccoWeekendDays,
    sccoHolidays, sccoSpecialDays, sccoPastDays, sccoPastDaysGrayed, sccoMonthPopup,
    sccoNavigator, sccoNavButtons, sccoNavYear, sccoNavMonth, sccoFocusRect,
    sccoTodayBtn, sccoClearBtn, sccoTodayRect, sccoHighlight);

  TSCCalendarOptions = set of TSCCalendarOption;

  TSCWeekDayName = (scwdMonday, scwdTuesday, scwdWednesday, scwdThursday,
    scwdFriday, scwdSaturday, scwdSunday);

  TSCWeekDayNames = set of TSCWeekDayName;

const
  SCCalendarDefOptions = [sccoDayCaptions, sccoWeekendDays, sccoHolidays,
    sccoSpecialDays, sccoPastDays, sccoPastDaysGrayed, sccoNavigator, sccoMonthPopup,
    sccoNavButtons, sccoNavMonth, sccoNavYear, sccoFocusRect, sccoTodayBtn,
    sccoClearBtn, sccoTodayRect, sccoHighlight];

  SCWeekendDays = [scwdSaturday, scwdSunday];

type
  TSCCustomCalendar = class;

  TSCHoliday = class(TCollectionItem)
  private
    FDay: Integer;
    FMonth: TSCMonth;
    FYear: Integer;
    FName: String;
    FBackColor: TColor;
    FFontColor: TColor;
    FFontStyles: TFontStyles;
    procedure SetBackColor(Value: TColor);
    procedure SetFontColor(Value: TColor);
    procedure SetFontStyles(Value: TFontStyles);
    procedure SetDay(Value: Integer);
    procedure SetYear(Value: Integer);
    procedure SetMonth(Value: TSCMonth);
    procedure SetName(const Value: String);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Day: Integer read FDay write SetDay default 1;
    property Month: TSCMonth read FMonth write SetMonth default scmJanuary;
    property Year: Integer read FYear write SetYear default -1;
    property Name: String read FName write SetName;
    property BackColor: TColor read FBackColor write SetBackColor default clNone;
    property FontColor: TColor read FFontColor write SetFontColor default clNone;
    property FontStyles: TFontStyles read FFontStyles write SetFontStyles default [];
  end;

  TSCHolidays = class(TCollection)
  private
    FOwner: TSCCustomControl;
    function  GetItem(Index: Integer): TSCHoliday;
    procedure SetItem(Index: Integer; Value: TSCHoliday);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TSCCustomControl);
    function Add: TSCHoliday;
    property Items[Index: Integer]: TSCHoliday read GetItem write SetItem; default;

    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomControl read FOwner;
    {$ENDIF}
  end;

  TSCSpecialDay = class(TCollectionItem)
  private
    FDay: Integer;
    FMonth: TSCMonth;
    FYear: Integer;
    FName: String;
    FBackColor: TColor;
    FFontColor: TColor;
    FFontStyles: TFontStyles;
    procedure SetBackColor(Value: TColor);
    procedure SetFontColor(Value: TColor);
    procedure SetFontStyles(Value: TFontStyles);
    procedure SetDay(Value: Integer);
    procedure SetMonth(Value: TSCMonth);
    procedure SetYear(Value: Integer);
    procedure SetName(const Value: String);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Day: Integer read FDay write SetDay default 1;
    property Month: TSCMonth read FMonth write SetMonth default scmJanuary;
    property Year: Integer read FYear write SetYear default -1;
    property Name: String read FName write SetName;
    property BackColor: TColor read FBackColor write SetBackColor default clNone;
    property FontColor: TColor read FFontColor write SetFontColor default clNone;
    property FontStyles: TFontStyles read FFontStyles write SetFontStyles default [];
  end;

  TSCSpecialDays = class(TCollection)
  private
    FOwner: TSCCustomControl;
    function  GetItem(Index: Integer): TSCSpecialDay;
    procedure SetItem(Index: Integer; Value: TSCSpecialDay);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TSCCustomControl);
    function Add: TSCSpecialDay;
    property Items[Index: Integer]: TSCSpecialDay read GetItem write SetItem; default;

    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomControl read FOwner;
    {$ENDIF}
  end;

  TSCGetDateStyleEvent = procedure(Sender: TObject; Day, Month: Word; Year: Integer;
       var BkColor, ForeColor: TColor; var FontStyle: TFontStyles) of object;

  TSCCalendarColors = class(TPersistent)
  private
    FOwner: TControl;
    FDayCaptions: TColor;
    FDaysBackground: TColor;
    FGrayedText: TColor;
    FGrayed: TColor;
    FHideSelection: TColor;
    FHideSelectionText: TColor;
    FHighlight: TColor;
    FHighlightText: TColor;
    FHolidays: TColor;
    FHolidaysText: TColor;
    FLines: TColor;
    FNavigator: TColor;
    FNavigatorEnd: TColor;
    FNavigatorButtons: TColor;
    FNavigatorLine: TColor;
    FPopup: TColor;
    FPopupHighlight: TColor;
    FPopupHighlightText: TColor;
    FSelection: TColor;
    FSelectionText: TColor;
    FSpecialDay: TColor;
    FSpecialDayText: TColor;
    FTodayClearBtn: TColor;
    FTodayRect: TColor;
    FWeekendDays: TColor;
    FWeekendDaysText: TColor;
    FWeekNumbers: TColor;
    FOnChange: TNotifyEvent;
    procedure SetDayCaptions(Value: TColor);
    procedure SetDaysBackground(Value: TColor);
    procedure SetGrayed(Value: TColor);
    procedure SetGrayedText(Value: TColor);
    procedure SetHideSelection(Value: TColor);
    procedure SetHideSelectionText(Value: TColor);
    procedure SetHighlight(Value: TColor);
    procedure SetHighlightText(Value: TColor);
    procedure SetHolidays(Value: TColor);
    procedure SetHolidaysText(Value: TColor);
    procedure SetLines(Value: TColor);
    procedure SetNavigator(Value: TColor);
    procedure SetNavigatorEnd(Value: TColor);
    procedure SetNavigatorButtons(Value: TColor);
    procedure SetNavigatorLine(Value: TColor);
    procedure SetSelection(Value: TColor);
    procedure SetSelectionText(Value: TColor);
    procedure SetSpecialDay(Value: TColor);
    procedure SetSpecialDayText(Value: TColor);
    procedure SetTodayClearBtn(Value: TColor);
    procedure SetTodayRect(Value: TColor);
    procedure SetWeekendDays(Value: TColor);
    procedure SetWeekendDaysText(Value: TColor);
    procedure SetWeekNumbers(Value: TColor);

    procedure DoChange;
  protected
    function GetOwner: TPersistent; override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TControl); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TControl read FOwner;
  published
    property DayCaptions: TColor read FDayCaptions write SetDayCaptions default clNone;
    property DaysBackground: TColor read FDaysBackground write SetDaysBackground default clNone;
    property Grayed: TColor read FGrayed write SetGrayed default clNone;
    property GrayedText: TColor read FGrayedText write SetGrayedText default clGrayText;
    property HideSelection: TColor read FHideSelection write SetHideSelection default clInactiveCaption;
    property HideSelectionText: TColor read FHideSelectionText write SetHideSelectionText default clInactiveCaptionText;
    property Highlight: TColor read FHighlight write SetHighlight default clHighlight;
    property HighlightText: TColor read FHighlightText write SetHighlightText default clHighlightText;
    property Holidays: TColor read FHolidays write SetHolidays default clNone;
    property HolidaysText: TColor read FHolidaysText write SetHolidaysText default clRed;
    property Lines: TColor read FLines write SetLines default clBtnShadow;
    property Navigator: TColor read FNavigator write SetNavigator default clBtnFace;
    property NavigatorEnd: TColor read FNavigatorEnd write SetNavigatorEnd default clBtnHighlight;
    property NavigatorButtons: TColor read FNavigatorButtons write SetNavigatorButtons default clWindowText;
    property NavigatorLine: TColor read FNavigatorLine write SetNavigatorLine default clNone;
    property Popup: TColor read FPopup write FPopup default clWindow;
    property PopupHighlight: TColor read FPopupHighlight write FPopupHighlight default clWindowText;
    property PopupHighlightText: TColor read FPopupHighlightText write FPopupHighlightText default clWindow;
    property Selection: TColor read FSelection write SetSelection default clPurple;
    property SelectionText: TColor read FSelectionText write SetSelectionText default clWhite;
    property SpecialDay: TColor read FSpecialDay write SetSpecialDay default clNone;
    property SpecialDayText: TColor read FSpecialDayText write SetSpecialDayText default clBlue;
    property TodayClearBtn: TColor read FTodayClearBtn write SetTodayClearBtn default clBtnFace;
    property TodayRect: TColor read FTodayRect write SetTodayRect default clMaroon;
    property WeekendDays: TColor read FWeekendDays write SetWeekendDays default clNone;
    property WeekendDaysText: TColor read FWeekendDaysText write SetWeekendDaysText default clHighlight;
    property WeekNumbers: TColor read FWeekNumbers write SetWeekNumbers default clNone;
  end;

  TSCStartOfWeek = (scswMonday, scswTuesday, scswWednesday, scswThursday,
    scswFriday, scswSaturday, scswSunday, scswLocaleDefault);

  TSCCalendarCell = record
    Day: Word;
    Month: Word;
    Year: Word;
    Visible: Boolean;
    ARect: TRect;
    IsHoliday: Boolean;
    IsSpecial: Boolean;
    Color: TColor;
    FontColor: TColor;
    FontStyles: TFontStyles;
    DayName: TSCWeekDayName;
  end;
  PSCCalendarCell = ^TSCCalendarCell;

  TSCNavigatorStyle = (scnFlat, scnFlatEx, scnFlatWithLine, scnMetal,
    scnRaised, scnGradient, scnGradientEx);

  TSCCalendarPart = (sccpNowhere, sccpClient, sccpDays, sccpDayCaptions,
    sccpWeekNumbers, sccpTodayBtn, sccpClearBtn, sccpNavigator, sccpNavLeftBtn,
    sccpNavRightBtn, sccpNavMonthYear);

  TSCCalendarBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccbFlat;
    property Color default clWindow;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCCalButtonType = (scbtToday, scbtClear);

  TSCCalButtonStyle = (sccbsWin2k, sccbsCorel, sccbsFlat, sccbsFlatEx,
    sccbsFlatHot, sccbsOfficeXP, sccbsOffice2003, sccbsMetal, sccbsNew,
    sccbsXP);

  TSCCalendarDayCaptions = (scdcFirst, scdcTwo, scdcThree, scdcShort, scdcLong);

  TSCCalendarNavigateStyle = (sccnMonth, sccnYear, sccnBoth);

  TSCCalendarNavigateEvent = procedure(Sender: TObject; Month, Year: Word;
    NavStyle: TSCCalendarNavigateStyle) of object;

  TSCCalendarPopupType = (sccpMonthYear, sccpYear);

  TSCCustomCalendar = class(TSCCustomControl)
  private
    FAlignPopupText: Boolean;
    FDaysList: TList;
    FDayCaptionsList: TList;
    FWeekNumbersList: TList;
    FButtonFont: TFont;
    FButtonClear: TCaption;
    FButtonStyle: TSCCalButtonStyle;
    FButtonToday: TCaption;
    FCalColors: TSCCalendarColors;
    FDate: TDateTime;
    FDayCaptions: TSCCalendarDayCaptions;
    FDayCaptionsFont: TFont;
    FDisplayMonth: Word;
    FDisplayYear: Word;
    FHolidays: TSCHolidays;
    FImageHighlight: TImageIndex;
    FImageSelection: TImageIndex;
    FImageToday: TImageIndex;
    FNavigatorLeft: TImageIndex;
    FNavigatorRight: TImageIndex;
    FNavigatorFont: TFont;
    FNavigatorGradient: TSCGradient;
    FNavigatorHeight: Integer;
    FNavigatorStyle: TSCNavigatorStyle;
    FPopupBorder: TSCControlBorder;
    FPopupType: TSCCalendarPopupType;
    FSpecialDays: TSCSpecialDays;
    FStartOfWeek: TSCStartOfWeek;
    FWeekNumbersFont: TFont;
    FWeekendDays: TSCWeekDayNames;
    FOptions: TSCCalendarOptions;
    FPopupFont: TFont;
    FMonthOffset: Integer;
    FFirstDate: TDateTime;
    FForceDateChange: Boolean;
    FFocusedDate: TDate;
    FDownPart: TSCCalendarPart;
    FHotPart: TSCCalendarPart;
    FMousePressed: Boolean;
    FTimer: LongInt;
    FMonthPopup: TWinControl;
    FOnClearClick: TNotifyEvent;
    FOnGetDateStyle: TSCGetDateStyleEvent;
    FOnDateClick: TNotifyEvent;
    FOnNavigate: TSCCalendarNavigateEvent;
    FDateClick: Boolean;
    FScrollCount: Integer;
    procedure SetAlignPopupText(Value: Boolean);
    procedure SetButtonFont(Value: TFont);
    procedure SetButtonClear(const Value: TCaption);
    procedure SetButtonStyle(Value: TSCCalButtonStyle);
    procedure SetButtonToday(const Value: TCaption);
    procedure SetCalColors(Value: TSCCalendarColors);
    procedure SetDate(Value: TDateTime);
    procedure SetDayCaptions(Value: TSCCalendarDayCaptions);
    procedure SetDayCaptionsFont(Value: TFont);
    procedure SetHolidays(Value: TSCHolidays);
    procedure SetImageHighlight(Value: TImageIndex);
    procedure SetImageSelection(Value: TImageIndex);
    procedure SetImageToday(Value: TImageIndex);
    procedure SetNavigatorLeft(Value: TImageIndex);
    procedure SetNavigatorRight(Value: TImageIndex);
    procedure SetNavigatorFont(Value: TFont);
    procedure SetNavigatorGradient(Value: TSCGradient);
    procedure SetNavigatorHeight(Value: Integer);
    procedure SetNavigatorStyle(Value: TSCNavigatorStyle);
    procedure SetPopupBorder(Value: TSCControlBorder);
    procedure SetPopupType(Value: TSCCalendarPopupType);
    procedure SetSpecialDays(Value: TSCSpecialDays);
    procedure SetWeekendDays(Value: TSCWeekDayNames);
    procedure SetWeekNumbersFont(Value: TFont);
    procedure SetOptions(Value: TSCCalendarOptions);
    procedure SetPopupFont(Value: TFont);
    procedure SetStartOfWeek(Value: TSCStartOfWeek);

    procedure SetDisplayDate(Value: TDateTime);
    procedure DisplayParameters(D: TDateTime; var MOffset: Integer;
      var FirstDay: TDateTime; var DispYear, DispMonth: Word);

    procedure UpdateDayRects;
    procedure UpdateFontAndColors;
    procedure UpdateHolidays;
    procedure UpdateSpecialDays;

    procedure FontsChanged(Sender: TObject);
    procedure ColorsChanged(Sender: TObject);
    procedure HolidaysChanged(Sender: TObject);
    procedure SpecialDaysChanged(Sender: TObject);

    procedure UpdateFocusDate(X, Y: Integer);

    procedure ClearDays;
    procedure UpdateDays;

    procedure StartTimer;
    procedure StopTimer;
    procedure ScrollMonth;

    procedure ClearDayCaptions;
    procedure UpdateDayCaptions;

    procedure ClearWeekNumbers;
    procedure UpdateWeekNumbers;

    procedure ClearClick;
    procedure GetDateStyle(Day, Month: Word; Year: Integer;
       var BkColor, ForeColor: TColor; var FontStyle: TFontStyles);

    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMBorderChanged(var Message: TMessage); message CM_BORDERCHANGED;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMDestroy(var Message: TMessage); message WM_DESTROY;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Paint; override;

    procedure ShowMonthPopup;
    procedure HideMonthPopup;
    function  IsMonthPopupShowing: Boolean;

    procedure SetIndent(Value: Integer); override;

    procedure MouseInControlChanged; override;
    procedure FocusChanged; override;
    procedure StopTracking; override;
    procedure IndentChanged; override;
    procedure SystemColorsChanged; override;
    procedure EnabledChanged; override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;

    function  GetPictureRect(P: TPicture): TRect; override;

    procedure ConstrainedResize(var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer); override;
    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure AdjustBounds; override;

    procedure DrawDayCaptions(R: TRect); virtual;
    procedure DrawDays(R: TRect); virtual;
    procedure DrawNavigator(R: TRect); virtual;
    procedure DrawWeekNumbers(R: TRect); virtual;
    procedure DrawButtons(R: TRect); virtual;

    function  GetDayCaption(Index: Integer): String;
    function  GetClearCaption: String;
    function  GetTodayCaption: String;

    function  GetButtonsHeight: Integer;
    procedure GetButtonSizeFor(S: String; var W, H: Integer);
    procedure GetDaysSize(var H, W: Integer);
    procedure GetDayCaptionsSize(var H, W: Integer);
    function  GetNavigatorHeight(Auto: Boolean = False): Integer;
    procedure GetWeekNumbersSize(var H, W: Integer);
    procedure GetMinBounds(var W, H: Integer);
    function  GetGridRect: TRect;
    procedure GetButtonRects(var TodayR, ClearR: TRect);
    function  GetButtonRect(Btn: TSCCalButtonType): TRect;
    function  GetYearMonthRect(Auto: Boolean = False): TRect;

    procedure FullUpdate;

    function  MonthPopupVisible: Boolean;

    procedure DoClearClick; dynamic;
    procedure DoDateClick; dynamic;
    procedure DoGetDateStyle(Day, Month: Word; Year: Integer;
       var BkColor, ForeColor: TColor; var FontStyle: TFontStyles); virtual;

    function  WeekNumberOf(D: TDateTime): Word;
    procedure FirstRowColOfMonth(D: TDateTime; var Col, Row: Word);
    function  StartOfWeekAsInt: Integer;
    function  PosToDateTime(P: TPoint): TDateTime; virtual;

    function  DaysThisMonth: Integer; virtual;
    function  GetCellDate(ACol, ARow: Integer): TDateTime;
    function  GetCellRect(ACol, ARow: Integer): TRect;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    property DownPart: TSCCalendarPart read FDownPart;
    property HotPart: TSCCalendarPart read FHotPart;
    property AutoSize default True;
    property AlignPopupText: Boolean read FAlignPopupText write SetAlignPopupText default False;
    property BlendColor default False;
    property Border default sccbFlat;
    property ButtonFont: TFont read FButtonFont write SetButtonFont;
    property ButtonClear: TCaption read FButtonClear write SetButtonClear;
    property ButtonStyle: TSCCalButtonStyle read FButtonStyle write SetButtonStyle default sccbsWin2k;
    property ButtonToday: TCaption read FButtonToday write SetButtonToday;
    property Color default clWindow;
    property CalColors: TSCCalendarColors read FCalColors write SetCalColors;
    property DayCaptions: TSCCalendarDayCaptions read FDayCaptions write SetDayCaptions default scdcFirst;
    property DayCaptionsFont: TFont read FDayCaptionsFont write SetDayCaptionsFont;
    property Holidays: TSCHolidays read FHolidays write SetHolidays;
    property ImageHighlight: TImageIndex read FImageHighlight write SetImageHighlight default -1;
    property ImageSelection: TImageIndex read FImageSelection write SetImageSelection default -1;
    property ImageToday: TImageIndex read FImageToday write SetImageToday default -1;
    property NavigatorLeft: TImageIndex read FNavigatorLeft write SetNavigatorLeft default -1;
    property NavigatorRight: TImageIndex read FNavigatorRight write SetNavigatorRight default -1;
    property NavigatorFont: TFont read FNavigatorFont write SetNavigatorFont;
    property NavigatorGradient: TSCGradient read FNavigatorGradient write SetNavigatorGradient default scgBottomToTop;
    property NavigatorHeight: Integer read FNavigatorHeight write SetNavigatorHeight default -1;
    property NavigatorStyle: TSCNavigatorStyle read FNavigatorStyle write SetNavigatorStyle default scnFlat;
    property Options: TSCCalendarOptions read FOptions write SetOptions default SCCalendarDefOptions;
    property ParentColor default False;
    property PopupBorder: TSCControlBorder read FPopupBorder write SetPopupBorder default sccbFlat;
    property PopupFont: TFont read FPopupFont write SetPopupFont;
    property PopupType: TSCCalendarPopupType read FPopupType write SetPopupType default sccpMonthYear;
    property SpecialDays: TSCSpecialDays read FSpecialDays write SetSpecialDays;
    property StartOfWeek: TSCStartOfWeek read FStartOfWeek write SetStartOfWeek default scswLocaleDefault;
    property WeekendDays: TSCWeekDayNames read FWeekendDays write SetWeekendDays default SCWeekendDays;
    property WeekNumbersFont: TFont read FWeekNumbersFont write SetWeekNumbersFont;
    property OnClearClick: TNotifyEvent read FOnClearClick write FOnClearClick;
    property OnDateClick: TNotifyEvent read FOnDateClick write FOnDateClick;
    property OnGetDateStyle: TSCGetDateStyleEvent read FOnGetDateStyle write FOnGetDateStyle;
    property OnNavigate: TSCCalendarNavigateEvent read FOnNavigate write FOnNavigate;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    function GetDateAtPos(X, Y: Integer): TDateTime;
    function GetDateIndexAtPos(X, Y: Integer): Integer;
    function GetIndexOfDate(D: TDateTime): Integer;
    function GetPartAtPos(X, Y: Integer): TSCCalendarPart;

    property Date: TDateTime read FDate write SetDate;
    property FirstDate: TDateTime read FFirstDate;
    property FocusedDate: TDate read FFocusedDate;
    property DisplayMonth: Word read FDisplayMonth;
    property DisplayYear: Word read FDisplayYear;
  end;

  TSCCalendar = class(TSCCustomCalendar)
  published
    property Align;
    property AlignPopupText;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property ButtonFont;
    property ButtonClear;
    property ButtonStyle;
    property ButtonToday;
    property CalColors;
    property Color default clWindow;
    property ClickFocus;
    property Constraints;
    property Cursor;
    property Date;
    property DayCaptions;
    property DayCaptionsFont;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatColor;
    property Font;
    property Holidays;
    property ImageHighlight;
    property ImageSelection;
    property ImageToday;
    property Images;
    property Indent;
    property NavigatorLeft;
    property NavigatorRight;
    property NavigatorFont;
    property NavigatorGradient;
    property NavigatorHeight;
    property NavigatorStyle;
    property Options;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupBorder;
    property PopupFont;
    property PopupType;
    property ShowHint;
    property SpecialDays;
    property StartOfWeek;
    property TabOrder;
    property TabStop default True;
    property Transparent;
    property Visible;
    property WeekendDays;
    property WeekNumbersFont;
    property OnCanResize;
    property OnChange;
    property OnClearClick;
    property OnClick;
    property OnContextPopup;
    property OnDateClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetDateStyle;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnNavigate;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomPopupCalendar = class;

  TSCPopupCalendarProps = class(TPersistent)
  private
    FOwner: TSCCustomPopupCalendar;
    FAlignPopupText: Boolean;
    FBorderStyle: TSCEditStyle;
    FButtonFont: TFont;
    FButtonClear: TCaption;
    FButtonStyle: TSCCalButtonStyle;
    FButtonToday: TCaption;
    FCalColors: TSCCalendarColors;
    FDayCaptions: TSCCalendarDayCaptions;
    FDayCaptionsFont: TFont;
    FFont: TFont;
    FHolidays: TSCHolidays;
    FImageHighlight: TImageIndex;
    FImageSelection: TImageIndex;
    FImageToday: TImageIndex;
    FIndent: Integer;
    FNavigatorFont: TFont;
    FNavigatorLeft: TImageIndex;
    FNavigatorRight: TImageIndex;
    FNavigatorGradient: TSCGradient;
    FNavigatorHeight: Integer;
    FNavigatorStyle: TSCNavigatorStyle;
    FOptions: TSCCalendarOptions;
    FPopupBorder: TSCControlBorder;
    FPopupFont: TFont;
    FPopupType: TSCCalendarPopupType;
    FSpecialDays: TSCSpecialDays;
    FStartOfWeek: TSCStartOfWeek;
    FWeekendDays: TSCWeekDayNames;
    FWeekNumbersFont: TFont;
    procedure SetAlignPopupText(Value: Boolean);
    procedure SetButtonFont(Value: TFont);
    procedure SetCalColors(Value: TSCCalendarColors);
    procedure SetDayCaptionsFont(Value: TFont);
    procedure SetFont(Value: TFont);
    procedure SetHolidays(Value: TSCHolidays);
    procedure SetImageHighlight(Value: TImageIndex);
    procedure SetImageSelection(Value: TImageIndex);
    procedure SetImageToday(Value: TImageIndex);
    procedure SetIndent(Value: Integer);
    procedure SetNavigatorFont(Value: TFont);
    procedure SetNavigatorLeft(Value: TImageIndex);
    procedure SetNavigatorRight(Value: TImageIndex);
    procedure SetNavigatorHeight(Value: Integer);
    procedure SetPopupBorder(Value: TSCControlBorder);
    procedure SetPopupFont(Value: TFont);
    procedure SetPopupType(Value: TSCCalendarPopupType);
    procedure SetSpecialDays(Value: TSCSpecialDays);
    procedure SetWeekNumbersFont(Value: TFont);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TSCCustomPopupCalendar); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomPopupCalendar read FOwner;
  published
    property AlignPopupText: Boolean read FAlignPopupText write SetAlignPopupText default False;
    property BorderStyle: TSCEditStyle read FBorderStyle write FBorderStyle default scesDefault;
    property ButtonFont: TFont read FButtonFont write SetButtonFont;
    property ButtonClear: TCaption read FButtonClear write FButtonClear;
    property ButtonStyle: TSCCalButtonStyle read FButtonStyle write FButtonStyle default sccbsWin2k;
    property ButtonToday: TCaption read FButtonToday write FButtonToday;
    property CalColors: TSCCalendarColors read FCalColors write SetCalColors;
    property DayCaptions: TSCCalendarDayCaptions read FDayCaptions write FDayCaptions default scdcFirst;
    property DayCaptionsFont: TFont read FDayCaptionsFont write SetDayCaptionsFont;
    property Font: TFont read FFont write SetFont;
    property Holidays: TSCHolidays read FHolidays write SetHolidays;
    property ImageHighlight: TImageIndex read FImageHighlight write SetImageHighlight default -1;
    property ImageSelection: TImageIndex read FImageSelection write SetImageSelection default -1;
    property ImageToday: TImageIndex read FImageToday write SetImageToday default -1;
    property Indent: Integer read FIndent write SetIndent default 0;
    property NavigatorFont: TFont read FNavigatorFont write SetNavigatorFont;
    property NavigatorLeft: TImageIndex read FNavigatorLeft write SetNavigatorLeft default -1;
    property NavigatorRight: TImageIndex read FNavigatorRight write SetNavigatorRight default -1;
    property NavigatorGradient: TSCGradient read FNavigatorGradient write FNavigatorGradient default scgBottomToTop;
    property NavigatorHeight: Integer read FNavigatorHeight write SetNavigatorHeight default -1;
    property NavigatorStyle: TSCNavigatorStyle read FNavigatorStyle write FNavigatorStyle default scnFlat;
    property Options: TSCCalendarOptions read FOptions write FOptions default SCCalendarDefOptions;
    property PopupBorder: TSCControlBorder read FPopupBorder write SetPopupBorder default sccbFlat;
    property PopupFont: TFont read FPopupFont write SetPopupFont;
    property PopupType: TSCCalendarPopupType read FPopupType write SetPopupType default sccpMonthYear;
    property SpecialDays: TSCSpecialDays read FSpecialDays write SetSpecialDays;
    property StartOfWeek: TSCStartOfWeek read FStartOfWeek write FStartOfWeek default scswLocaleDefault;
    property WeekendDays: TSCWeekDayNames read FWeekendDays write FWeekendDays default SCWeekendDays;
    property WeekNumbersFont: TFont read FWeekNumbersFont write SetWeekNumbersFont;
  end;

  TSCDTValidationErrorEvent = procedure(Sender: TObject; var ADateTime: TDateTime; var ErrorText: String;
    var RaiseError: Boolean) of object;

  TSCCustomPopupCalendar = class(TSCCustomDropDown)
  private
    FCalendar: TSCCustomCalendar;
    FCalendarProps: TSCPopupCalendarProps;
    FDate: TDateTime;
    FDateValidation: TSCDateValidation;
    FDisplayFormat: TCaption;
    FSaveTime: Boolean;
    FTime: TDateTime;
    FOnDateChange: TNotifyEvent;
    FOnClearClick: TNotifyEvent;
    FOnGetDateStyle: TSCGetDateStyleEvent;
    FOnValidationError: TSCDTValidationErrorEvent;
    procedure SetDate(Value: TDateTime);
    procedure SetDisplayFormat(Value: TCaption);
    procedure SetCalendarProps(Value: TSCPopupCalendarProps);

    procedure DateChanged;
    procedure PopupDateChanged(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure GetDateStyle(Sender: TObject; Day, Month: Word; Year: Integer;
       var BkColor, ForeColor: TColor; var FontStyle: TFontStyles);

    procedure ValidationError(ErrorTxt: String);

    procedure CMWinIniChange(var Message: TWMWinIniChange); message CM_WININICHANGE;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure DoInternalChange; override;
    procedure BeforeExit; override;

    function  IsDescription: Boolean; override;
    function  GetDescriptionText: String; override;
    function  GetDescriptionColor: TColor; override;

    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; override;

    procedure UpdateDateFromText; dynamic;
    procedure DoValidationError(var ADate: TDateTime; var ErrorText: String;
      var RaiseError: Boolean); dynamic;

    function  GetPopupStyle: TSCEditStyle; override;
    procedure DropDownPopupbox; override;
    procedure CloseUp; override;
    procedure PrepareDropWindow; override;

    function  CanDropDown: Boolean; override;
    function  GetDroppedDown: Boolean; override;
    function  GetDropDownWindow: TWinControl; override;

    procedure DoDateChange; dynamic;

    function  DoWantKeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    property CalendarProps: TSCPopupCalendarProps read FCalendarProps write SetCalendarProps;
    property Date: TDateTime read FDate write SetDate;
    property DateValidation: TSCDateValidation read FDateValidation write FDateValidation default scdvSetToNull;
    property DisplayFormat: TCaption read FDisplayFormat write SetDisplayFormat;
    property IsDropDown default False;
    property SaveTime: Boolean read FSaveTime write FSaveTime default True;
    property OnDateChange: TNotifyEvent read FOnDateChange write FOnDateChange;
    property OnClearClick: TNotifyEvent read FOnClearClick write FOnClearClick;
    property OnGetDateStyle: TSCGetDateStyleEvent read FOnGetDateStyle write FOnGetDateStyle;
    property OnValidationError: TSCDTValidationErrorEvent read FOnValidationError write FOnValidationError;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCPopupCalendar = class(TSCCustomPopupCalendar)
  public
    property ShowPicture;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoComplete;
    property AutoSelect;
    property AutoSize;
    property BorderProps;
    property ButtonStyle;
    property ButtonProps;
    property CalendarProps;
    property CanDragSelection;
    property CanSelect;
    property Checkbox;
    property Colors;
    property Constraints;
    property Date;
    property DateValidation;
    property Description;
    property DescriptionMode;
    property DisplayFormat;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownKey;
    property EditCursor;
    property EditMode;
    property Enabled;
    property EnterAsTab;
    property FocusExpandSize;
    property Font;
    property HideSelection;
    property ImageIndex;
    property Images;
    property InsertChangesEditMode;
    property IsDropDown;
    property Layout;
    property Picture;
    property PictureProps;
    property ReadOnly;
    property SaveTime;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UndoLimit;
    property UseCaret;
    property UseDefaultMenu;
    property UseImage;
    property UseUndo;
    property Visible;
    property OnAutoComplete;
    property OnCanResize;
    property OnCaretMove;
    property OnChange;
    property OnCheckboxChange;
    property OnClearClick;
    property OnClick;
    property OnCloseUp;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDateChange;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEditModeChange;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetDateStyle;
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
    property OnValidationError;
  end;

  TSCCustomTimeEdit = class(TSCCustomFrameEdit)
  private
    FTime: TTime;
    FTimeValidation: TSCTimeValidation;
    FDisplayFormat: TCaption;
    FOnTimeChange: TNotifyEvent;
    FOnValidationError: TSCDTValidationErrorEvent;
    procedure SetDisplayFormat(Value: TCaption);
    procedure SetTime(Value: TTime);

    procedure TimeChanged;
    procedure ValidationError(ErrorTxt: String);

    procedure CMWinIniChange(var Message: TWMWinIniChange); message CM_WININICHANGE;
  protected
    procedure Loaded; override;
    procedure BeforeExit; override;

    function  IsDescription: Boolean; override;
    function  GetDescriptionText: String; override;
    function  GetDescriptionColor: TColor; override;

    procedure UpdateTimeFromText; dynamic;
    procedure DoValidationError(var ATime: TTime; var ErrorText: String;
      var RaiseError: Boolean); dynamic;

    procedure DoTimeChange; dynamic;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    property DisplayFormat: TCaption read FDisplayFormat write SetDisplayFormat;
    property Time: TTime read FTime write SetTime;
    property TimeValidation: TSCTimeValidation read FTimeValidation write FTimeValidation default sctvSetToNow;
    property OnTimeChange: TNotifyEvent read FOnTimeChange write FOnTimeChange;
    property OnValidationError: TSCDTValidationErrorEvent read FOnValidationError write FOnValidationError;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCTimeEdit = class(TSCCustomTimeEdit)
  public
    property ShowPicture;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoComplete;
    property AutoSelect;
    property AutoSize;
    property BorderProps;
    property Checkbox;
    property CanSelect;
    property Colors;
    property Constraints;
    property Description;
    property DescriptionMode;
    property DisplayFormat;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EditCursor;
    property EditMode;
    property Enabled;
    property EnterAsTab;
    property Font;
    property HideSelection;
    property ImageIndex;
    property Images;
    property InsertChangesEditMode;
    property Layout;
    property Picture;
    property PictureProps;
    property ReadOnly;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Time;
    property TimeValidation;
    property Transparent;
    property UndoLimit;
    property UseCaret;
    property UseDefaultMenu;
    property UseImage;
    property UseUndo;
    property Visible;
    property OnAutoComplete;
    property OnCanResize;
    property OnCaretMove;
    property OnChange;
    property OnCheckboxChange;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditModeChange;
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
    property OnTimeChange;
    property OnValidationError;
  end;

implementation

const
  SC_NullDate = -100000;
  SC_MONTH_TIMERID = 5434;
  CM_CANCEL = WM_USER + $9876;
  CM_CANCEL_POPUP = WM_USER + $8765;

type
  TSCCalItemRec = record
    S: String;
    R: TRect;
  end;
  PSCCalItemRec = ^TSCCalItemRec;

  TSCMonthListPopup = class(TSCCustomControl)
  private
    FAlignText: Boolean;
    FDisplayType: TSCCalendarPopupType;
    FItemHeight: Integer;
    FItemIndex: Integer;
    FItems: TStrings;
    FTimer: LongInt;
    FTimerId: LongInt;
    FHighlight: TColor;
    FHighlightText: TColor;
    FStartDate: TDateTime;
    function  GetDate: TDateTime;
    procedure SetAlignText(Value: Boolean);
    procedure SetDisplayType(Value: TSCCalendarPopupType);
    procedure SetItemIndex(Value: Integer);
    procedure SetStartDate(Value: TDateTime);

    procedure StopTimer;
    procedure StartTimer;
    procedure ScrollMonths;
    procedure ScrollYears;

    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    procedure WMDestroy(var Message: TMessage); message WM_DESTROY;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;

    property AlignText: Boolean read FAlignText write SetAlignText default False;
    property DisplayType: TSCCalendarPopupType read FDisplayType write SetDisplayType default sccpMonthYear;
    property ItemHeight: Integer read FItemHeight;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property Items: TStrings read FItems;
    property StartDate: TDateTime read FStartDate write SetStartDate;
    property Highlight: TColor read FHighlight write FHighlight default clWindowText;
    property HighlightText: TColor read FHighlightText write FHighlightText default clWindow;
  public
    constructor Create(AOwner: TComponent); override;
    property Date: TDateTime read GetDate;
  end;


  TSCDropdownCalendar = class(TSCCustomCalendar)
  private
    FInPopup: Boolean;
    FPreparingPopup: Boolean;
    FCancelPopup: Boolean;
    FPopupbox: TSCCustomPopupCalendar;
    procedure Cancel;
    procedure ActivateForm;
    function  IsChildHandle(AHandle: HWND): Boolean;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;

    property InPopup: Boolean read FInPopup;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Popup(C: TSCCustomPopupCalendar);
  end;

procedure DecMonth(var Year, Month: Word);
begin
  if Month <= 1 then
  begin
    Dec(Year);
    Month := 12;

    if Year < 1 then
    begin
      Year := 1;
      Month := 1;
    end;
  end else
    Dec(Month);
end;

procedure IncMonth(var Year, Month: Word);
begin
  if Month >= 12 then
  begin
    Inc(Year);
    Month := 1;
  end else
    Inc(Month);
end;

procedure IterateMonth(var AYear, AMonth: Word; Delta: Integer);
var
  Month: Integer;
begin
  Inc(AYear, Delta div 12);
  Month := AMonth;
  Inc(Month, Delta mod 12);

  if Month < 1 then
  begin
    Dec(AYear);
    Month := 12 + Month;
  end;

  if Month > 12 then
  begin
    Inc(AYear);
    Month := Month - 12;
  end;

  AMonth := Month;
end;

function DateToDayName(ADate: TDateTime): TSCWeekDayName;
const
  DayNames: array[1..7] of TSCWeekDayName = (scwdMonday, scwdTuesday,
    scwdWednesday, scwdThursday, scwdFriday, scwdSaturday, scwdSunday);
var
  I: Integer;
begin
  I := (DayOfWeek(ADate) + 6) mod 7;
  if I = 0 then I := 7;

  Result := DayNames[I];
end;


{ TSCCustomCalendar }

procedure TSCCustomCalendar.AdjustBounds;
begin
  if HandleAllocated then
  begin
    AdjustSize;

    UpdateDayRects;
    UpdateDayCaptions;
    UpdateWeekNumbers;
  end;
end;

function TSCCustomCalendar.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
var
  W, H: Integer;
begin
  Result := True;

  if HandleAllocated and AutoSize and not (IsLoading or IsDestroying) then
  begin
    GetMinBounds(W, H);

    NewWidth  := W;
    NewHeight := H;
  end;
end;

procedure TSCCustomCalendar.ClearDays;
var
  I: Integer;
  PC: PSCCalendarCell;
begin
  for I := FDaysList.Count - 1 downto 0 do
  begin
    PC := FDaysList.Items[I];
    FDaysList.Delete(I);

    Dispose(PC);
  end;
end;

procedure TSCCustomCalendar.CMBorderChanged(var Message: TMessage);
begin
  inherited;
  AdjustBounds;
end;

procedure TSCCustomCalendar.CMFontChanged(var Message: TMessage);
begin
  inherited;
  FontsChanged(Font);
end;

procedure TSCCustomCalendar.ColorsChanged(Sender: TObject);
begin
  UpdateFontAndColors;
  Invalidate;
end;

procedure TSCCustomCalendar.ConstrainedResize(var MinWidth, MinHeight,
  MaxWidth, MaxHeight: Integer);
begin
  inherited ConstrainedResize(MinWidth, MinHeight, MaxWidth, MaxHeight);

  GetMinBounds(MinWidth, MinHeight);
  if AutoSize then
  begin
    MaxHeight := MinHeight;
    MaxWidth  := MinWidth;
  end;
end;

constructor TSCCustomCalendar.Create(AOwner: TComponent);
begin
  FDaysList := TList.Create;
  FDayCaptionsList := TList.Create;
  FWeekNumbersList := TList.Create;

  FHolidays := TSCHolidays.Create(Self);
  FSpecialDays := TSCSpecialDays.Create(Self);

  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csDoubleClicks] - [csAcceptsControls];
  AutoSize := True;
  DoubleBuffered := True;
  AutoSize := True;
  BlendColor := False;
  Border := sccbFlat;
  ParentColor := False;
  Color := clWindow;
  SetBounds(Left, Top, 150, 160);

  FDownPart := sccpNowhere;
  FHotPart := sccpNowhere;

  FButtonStyle := sccbsWin2k;
  FDate := 0;
  FFocusedDate := 0;

  FPopupBorder := sccbFlat;
  FPopupType := sccpMonthYear;

  FDisplayMonth := 1;
  FDisplayYear  := 0;
  FMonthOffset  := 0;
  FFirstDate    := 1;

  DisplayParameters(SysUtils.Date, FMonthOffset, FFirstDate,
    FDisplayYear, FDisplayMonth);

  FDayCaptions := scdcFirst;
  FStartOfWeek := scswLocaleDefault;

  FImageHighlight := -1;
  FImageSelection := -1;
  FImageToday := -1;

  FNavigatorLeft := -1;
  FNavigatorRight := -1;
  FNavigatorGradient := scgBottomToTop;
  FNavigatorHeight := -1;
  FNavigatorStyle := scnFlat;
  FWeekendDays := SCWeekendDays;

  FOptions := SCCalendarDefOptions;

  FCalColors := TSCCalendarColors.Create(Self);
  FCalColors.OnChange := ColorsChanged;

  FButtonFont := TFont.Create;
  FButtonFont.OnChange := FontsChanged;

  FDayCaptionsFont := TFont.Create;
  FDayCaptionsFont.OnChange := FontsChanged;

  FNavigatorFont := TFont.Create;
  FNavigatorFont.OnChange := FontsChanged;

  FWeekNumbersFont := TFont.Create;
  FWeekNumbersFont.OnChange := FontsChanged;

  FPopupFont := TFont.Create;
end;

procedure TSCCustomCalendar.CreateWnd;
begin
  FForceDateChange := True;
  try
    inherited CreateWnd;
    SetDate(FDate);
  finally
    FForceDateChange := False;
  end;
end;

function TSCCustomCalendar.DaysThisMonth: Integer;
begin
  Result := scDaysPerMonth(FDisplayYear, FDisplayMonth);
end;

destructor TSCCustomCalendar.Destroy;
begin
  FCalColors.OnChange := nil;
  FreeAndNil(FCalColors);

  FButtonFont.OnChange := nil;
  FreeAndNil(FButtonFont);

  FDayCaptionsFont.OnChange := nil;
  FreeAndNil(FDayCaptionsFont);

  FNavigatorFont.OnChange := nil;
  FreeAndNil(FNavigatorFont);

  FWeekNumbersFont.OnChange := nil;
  FreeAndNil(FWeekNumbersFont);

  FreeAndNil(FPopupFont);

  FreeAndNil(FHolidays);
  FreeAndNil(FSpecialDays);

  ClearDays;
  FreeAndNil(FDaysList);

  ClearDayCaptions;
  FreeAndNil(FDayCaptionsList);

  ClearWeekNumbers;
  FreeAndNil(FWeekNumbersList);

  inherited Destroy;
end;

procedure TSCCustomCalendar.DrawButtons(R: TRect);

  procedure DrawButton(S: String; BR: TRect; IsDown, IsHot: Boolean);
  var
    CR, TmpR: TRect;
    L, T: Integer;
    Cl, FnCl, BkCl, Cl1, Cl2: TColor;
  begin
    Cl := FCalColors.TodayClearBtn;
    if Cl = clNone then Cl := clBtnFace;

    FnCl := FButtonFont.Color;
    if FnCl = clNone then FnCl := clBtnText;

    BkCl := Self.Color;
    if BkCl = clNone then BkCl := clWindow;

    if (FButtonStyle in [sccbsFlatEx, sccbsFlatHot]) and IsDown and IsHot then
    begin
      FnCl := GetBtnHighlightOf(Cl);
      Cl := Get3DDkShadowOf(Cl);
    end else
    if (FButtonStyle = sccbsFlatHot) and IsHot then
    begin
      FnCl := GetBtnHighlightOf(Cl);
      Cl := GetBtnShadowOf(Cl);
    end else
    if FButtonStyle = sccbsOfficeXP then
    begin
      Cl := GetOfficeXPBtnColor;
      FnCl := clBtnText;

      if IsDown and IsHot then
      begin
        Cl := GetOfficeXPDownedSelColor;
        FnCl := clHighlightText;
      end else
      if IsDown or IsHot then
        Cl := GetOfficeXPSelColor;
    end else
    if FButtonStyle = sccbsOffice2003 then
    begin
      if IsDown and IsHot then
      begin
        Cl := GetOfficeXPDownedSelColor;
        FnCl := clHighlightText;
      end else
      if IsDown or IsHot then
        Cl := GetOfficeXPSelColor;
    end;

    with Canvas do
    begin
      Font := FButtonFont;
      Font.Color := FnCl;

      Brush.Style := bsSolid;
      Brush.Color := Cl;

      FillRect(BR);

      CR := BR;
      DrawText(Handle, PChar(S), Length(S), CR,
        DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or DT_CALCRECT);

      OffsetRect(CR, -CR.Left, -CR.Top);

      if not IsRectEmpty(CR) then
      begin
        L := BR.Left + (((BR.Right - BR.Left) - CR.Right) div 2);
        T := BR.Top + (((BR.Bottom - BR.Top) - CR.Bottom) div 2);

        if IsDown and IsHot and not (FButtonStyle in [sccbsOfficeXP,
          sccbsOffice2003, sccbsFlatEx, sccbsFlatHot]) then
        begin
          Inc(L);
          Inc(T);
        end;

        OffsetRect(CR, L, T);

        Brush.Style := bsClear;

        DrawText(Handle, PChar(S), Length(S), CR,
          DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
      end;
    end;

    case FButtonStyle of
      sccbsWin2k:
      begin
        if IsDown and IsHot then
        begin
          scFrame3D(Canvas, BR, Get3DDkShadowOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
          scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
        end else
        begin
          scFrame3D(Canvas, BR, Cl, Get3DDkShadowOf(Cl), 1, 0);
          scFrame3D(Canvas, BR, GetBtnHighlightOf(Cl), GetBtnShadowOf(Cl), 1, 0);
        end;
      end;
      sccbsCorel:
      begin
        if IsDown and IsHot then
        begin
          scFrame3D(Canvas, BR, Get3DDkShadowOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
          scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
        end else
        if IsHot or IsDown then
        begin
          scFrame3D(Canvas, BR, Cl, Get3DDkShadowOf(Cl), 1, 0);
          scFrame3D(Canvas, BR, GetBtnHighlightOf(Cl), GetBtnShadowOf(Cl), 1, 0);
        end else
          scFrame3D(Canvas, BR, GetBtnHighlightOf(Cl), GetBtnShadowOf(Cl), 1, 0);
      end;
      sccbsMetal:
      begin
        if IsDown and IsHot then
        begin
          scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
          scFrame3D(Canvas, BR, Cl, GetBtnHighlightOf(Cl), 1, 0);
        end else
        begin
          scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
          scFrame3D(Canvas, BR, GetBtnHighlightOf(Cl), Cl, 1, 0);
        end;
      end;
      sccbsFlat:
      begin
        if IsDown and IsHot then
          scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0)
        else
        if IsDown or IsHot then
          scFrame3D(Canvas, BR, GetBtnHighlightOf(Cl), GetBtnShadowOf(Cl), 1, 0);
      end;
      sccbsFlatEx:
      begin
        scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
      end;
      sccbsFlatHot:
      begin
        if not IsHot then
          scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
      end;
      sccbsOfficeXP:
      begin
        if IsDown or IsHot then
          scFrame3D(Canvas, BR, clHighlight, clHighlight, 1, 0);
      end;
      sccbsOffice2003:
      begin
        if not (IsDown or IsHot) then
        begin
          Cl1 := BlendedColor(Cl, 48, 48, 48, True);
          Cl2 := BlendedColor(Cl, 24, 24, 24, False);

          scDrawGradient(Canvas, BR, scgTopToBottom, Cl1, Cl2);

          with Canvas do
          begin
            Brush.Style := bsClear;

            DrawText(Handle, PChar(S), Length(S), CR,
              DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
          end;

          Cl1 := GetBtnShadowOf(Cl);
          scFrame3D(Canvas, BR, Cl1, Cl1, 1, 0);
        end else
          scFrame3D(Canvas, BR, clHighlight, clHighlight, 1, 0);
      end;
      sccbsXP:
      begin
        scDrawXPFace2(scskVertical, Canvas, BR, Cl, BkCl, False, IsDown, IsHot);

        with Canvas do
        begin
          Brush.Style := bsClear;

          DrawText(Handle, PChar(S), Length(S), CR,
            DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
        end;
      end;
      sccbsNew:
      begin
        with Canvas do
        begin
          if not (IsDown and IsHot) then
          begin
            Brush.Style := bsSolid;
            Brush.Color := Cl;

            FillRect(BR);

            TmpR := BR;
            InflateRect(TmpR, 0, -2);

            Cl1 := BlendedColor(Cl, 24, 24, 24, True);
            Cl2 := BlendedColor(Cl, 24, 24, 24, False);
            scFrame3D(Canvas, TmpR, Cl1, Cl2, 1, 0);

            InflateRect(TmpR, 1, 0);
            Cl1 := BlendedColor(Cl, 16, 16, 16, True);
            Cl2 := BlendedColor(Cl, 16, 16, 16, False);
            scFrame3D(Canvas, TmpR, Cl1, Cl2, 1, 0);

            InflateRect(TmpR, 1, 0);
            Cl1 := BlendedColor(Cl, 8, 8, 8, True);
            Cl2 := BlendedColor(Cl, 8, 8, 8, False);
            scFrame3D(Canvas, TmpR, Cl1, Cl2, 1, 0);

            with Canvas do
            begin
              Brush.Style := bsClear;

              DrawText(Handle, PChar(S), Length(S), CR,
                DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
            end;
          end;

          // outter frame
          Cl1 := BlendedColor(Cl, 12, 12, 12, False);
          Cl2 := BlendedColor(Cl, 48, 48, 48, True);

          scFrame3D(Canvas, BR, Cl1, Cl2, 1, 0);

          Cl1 := BlendedColor(Cl, 128, 128, 128, False);
          Cl2 := BlendedColor(Cl1, 16, 16, 16, True);

          scFrame3D(Canvas, BR, Cl1, Cl2, 1, 0);
        end;
      end;
    end;
  end;

var
  S: String;
  IsDown, IsHot: Boolean;
  ClearR, TodayR: TRect;
begin
  if HandleAllocated and (FOptions*[sccoClearBtn, sccoTodayBtn] <> []) and
    not IsRectEmpty(R) and (FButtonFont <> nil) then
  begin
    GetButtonRects(TodayR, ClearR);

    if (sccoClearBtn in FOptions) and not IsRectEmpty(ClearR) then
    begin
      S := ButtonClear;
      if S = '' then S := SSCCalClear;

      IsDown := FDownPart = sccpClearBtn;
      IsHot  := (FHotPart = sccpClearBtn) and (IsDown or (FDownPart = sccpNowhere));

      DrawButton(S, ClearR, IsDown, IsHot);
    end;

    if (sccoTodayBtn in FOptions) and not IsRectEmpty(TodayR) then
    begin
      S := ButtonToday;
      if S = '' then S := SSCCalToday;

      IsDown := FDownPart = sccpTodayBtn;
      IsHot  := (FHotPart = sccpTodayBtn) and (IsDown or (FDownPart = sccpNowhere));

      DrawButton(S, TodayR, IsDown, IsHot);
    end;
  end;
end;

procedure TSCCustomCalendar.DrawDayCaptions(R: TRect);
var
  LR: TRect;
  I: Integer;
  P: PSCCalItemRec;
  Cl, FnCl: TColor;
begin
  if HandleAllocated and (sccoDayCaptions in FOptions) and
    (FDayCaptionsFont <> nil) and not IsRectEmpty(R) and
    (FDayCaptionsList <> nil) and (FDayCaptionsList.Count > 0) then
  begin
    Cl := FCalColors.DayCaptions;

    FnCl := DayCaptionsFont.Color;
    if FnCl = clNone then FnCl := clWindowText;

    for I := 0 to FDayCaptionsList.Count-1 do
    begin
      P := FDayCaptionsList[I];
      if IsRectEmpty(P^.R) then
        Continue;

      with Canvas do
      begin
        if Cl <> clNone then
        begin
          Brush.Style := bsSolid;
          Brush.Color := Cl;
          FillRect(P^.R);
        end;  

        if P^.S <> '' then
        begin
          Brush.Style := bsClear;

          Font := FDayCaptionsFont;
          Font.Color := FnCl;

          DrawText(Handle, PChar(P^.S), Length(P^.S), P^.R,
            DT_CENTER or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
        end;
      end;
    end;

    if FDayCaptionsList.Count > 0 then
    begin
      P := FDayCaptionsList[0];
      LR := P^.R;

      if FDayCaptionsList.Count > 1 then
      begin
        P := FDayCaptionsList[FDayCaptionsList.Count-1];
        LR.Right := P^.R.Right;
      end;

      with Canvas do
      begin
        Pen.Width := 1;
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Color := FCalColors.Lines;

        MoveTo(LR.Left - 2, R.Bottom - 1);
        LineTo(LR.Right + 1, R.Bottom - 1);
      end;
    end;
  end;
end;

procedure TSCCustomCalendar.DrawDays(R: TRect);
var
  Cr, LR: TRect;
  Text: String;
  D: TDateTime;
  Flags: LongInt;
  I, X, Y: Integer;
  P: PSCCalendarCell;
  Cl, SelCl, SelFnCl: TColor;
  Year, Month, Day, TdYear,
  TdMonth, TdDay, FdYear, FdMonth, FdDay: Word;
  IsFocused, IsSelected, IsImaged, IsDate: Boolean;
begin
  if HandleAllocated and (FDaysList <> nil) and
    (FDaysList.Count > 0) and not IsRectEmpty(R) then
  begin
    Year := 0;
    Month := 0;
    Day := 0;

    if FDate <> 0 then
      DecodeDate(FDate, Year, Month, Day);

    FdYear := 0;
    FdMonth := 0;
    FdDay := 0;

    if FFocusedDate <> 0 then
      DecodeDate(FFocusedDate, FdYear, FdMonth, FdDay);

    D := SysUtils.Date;
    DecodeDate(D, TdYear, TdMonth, TdDay);

    SelCl := FCalColors.Selection;
    SelFnCl := FCalColors.SelectionText;

    IsImaged := False;

    with Canvas do
    begin
      Font := Self.Font;

      Flags := DT_CENTER or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE;

      for I := 0 to FDaysList.Count-1 do
      begin
        P := FDaysList[I];
        if not P^.Visible then
          Continue;

        Cr := P^.ARect;
        if IsRectEmpty(Cr) then Continue;

        IsDate := (FDate <> 0) and (P^.Day = Day) and
          (P^.Month = Month) and (P^.Year = Year);

        IsFocused := (FFocusedDate <> 0) and (P^.Day = FdDay) and
          (P^.Month = FdMonth) and (P^.Year = FdYear);

        IsSelected := IsFocused and FMousePressed and (FDownPart = sccpDays) and
          ((FFocusedDate <> 0) or (FHotPart = sccpDays)) and Focused;

        Cl := P^.Color;
        if IsSelected and (SelCl <> clNone) then
          Cl := SelCl;

        if IsSelected and IsValidImage(FImageSelection) then
        begin
          IsImaged := True;

          X := Cr.Left + ((Cr.Right - Cr.Left) - Images.Width) div 2;
          Y := Cr.Top + ((Cr.Bottom - Cr.Top) - Images.Height) div 2;

          Images.Draw(Canvas, X, Y, FImageSelection, Self.Enabled);
        end else
        if (sccoHighlight in FOptions) and IsDate and
          not IsSelected and IsValidImage(FImageHighlight) then
        begin
          IsImaged := True;

          X := Cr.Left + ((Cr.Right - Cr.Left) - Images.Width) div 2;
          Y := Cr.Top + ((Cr.Bottom - Cr.Top) - Images.Height) div 2;

          Images.Draw(Canvas, X, Y, FImageHighlight, Self.Enabled);
        end else
        if not IsImaged and (Cl <> clNone) then
        begin
          Brush.Style := bsSolid;
          Brush.Color := Cl;
          FillRect(Cr);
        end;  

        if (sccoTodayRect in FOptions) and IsValidImage(FImageToday) and
          (P^.Day = TdDay) and (P^.Month = TdMonth) and (P^.Year = TdYear) then
        begin
          X := Cr.Left + ((Cr.Right - Cr.Left) - Images.Width) div 2;
          Y := Cr.Top + ((Cr.Bottom - Cr.Top) - Images.Height) div 2;

          Images.Draw(Canvas, X, Y, FImageToday, Self.Enabled);
        end;

        Brush.Style := bsClear;
        if IsSelected and (SelFnCl <> clNone) then
          Font.Color := SelFnCl
        else
          Font.Color := P^.FontColor;

        Font.Style := P^.FontStyles;

        Text := IntToStr(P^.Day);

        DrawText(Handle, PChar(Text), Length(Text), Cr, Flags);

        if not IsImaged and IsFocused and not IsSelected and
          (SelCl <> clNone) and ((sccoFocusRect in FOptions) or
          (FMousePressed and (FDownPart = sccpDays))) and
          (IsDesigning or Focused) then
        begin
          Brush.Style := bsSolid;
          Brush.Color := Cl;

          scDrawFocusRect(Canvas, Cr, Cl);
        end;

        if (sccoTodayRect in FOptions) and (FCalColors.TodayRect <> clNone) and
          not IsValidImage(FImageToday) and (P^.Day = TdDay) and
          (P^.Month = TdMonth) and (P^.Year = TdYear) then
          scFrame3D(Canvas, Cr, FCalColors.TodayRect, FCalColors.TodayRect, 1, 1);
      end;
    end;

    if FOptions*[sccoClearBtn, sccoTodayBtn] <> [] then
    begin
      LR := R;

      Cl := FCalColors.Lines;
      if Cl = clNone then Cl := clBtnShadow;

      with Canvas do
      begin
        Pen.Width := 1;
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Color := Cl;

        MoveTo(LR.Left, LR.Bottom - 6);
        LineTo(LR.Right, LR.Bottom - 6);
      end;
    end;
  end;
end;

procedure TSCCustomCalendar.DrawNavigator(R: TRect);
var
  P: TPoint;
  D: TDateTime;
  Text, Fmt: String;
  R2, ARect: TRect;
  SR, W, H: Integer;
  Cl, Cl2, Cl3, FnCl: TColor;
begin
  if HandleAllocated and (sccoNavigator in FOptions) and not IsRectEmpty(R) then
  begin
    Cl := FCalColors.Navigator;
    if (Cl = clNone) and (FNavigatorStyle in [scnGradient, scnGradientEx]) then
    begin
      Cl := Self.Color;
      if Cl = clNone then Cl := clBtnFace;
    end;

    FnCl := FNavigatorFont.Color;
    if FnCl = clNone then FnCl := clBtnText;

    ARect := R;

    with Canvas do
    begin
      if Cl <> clNone then
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R);
      end;  

      if FNavigatorStyle in [scnGradient, scnGradientEx] then
      begin
        Cl2 := FCalColors.NavigatorEnd;
        if Cl2 = clNone then Cl2 := clBtnHighlight;

        scDrawGradient(Canvas, R, FNavigatorGradient, Cl, Cl2);
      end;
    end;

    if sccoNavButtons in FOptions then
    begin
      InflateRect(ARect, -22, 0);

      Cl3 := FCalColors.NavigatorButtons;
      if Cl3 = clNone then Cl3 := clWindowText;

      W := 6;
      H := 3;

      if IsValidImage(FNavigatorLeft) then
      begin
        P.x := R.Left + 3;
        if FNavigatorStyle = scnRaised then Inc(P.x);
        P.y := R.Top + ((R.Bottom - R.Top) - Images.Height) div 2;

        Images.Draw(Canvas, P.x, P.y, FNavigatorLeft, Self.Enabled);
      end else
      begin
        R2 := R;
        R2.Right := R2.Left + 22;

        if not IsRectEmpty(R2) then
        begin
          P.x := R2.Left + ((R2.Right - R2.Left - W) div 2);
          P.y := R2.Top +  ((R2.Bottom - R2.Top + H - 2) div 2);

          scDrawRightSlider(Canvas, P, W, H, sctsMac, False, Cl3, Cl3);
        end;
      end;

      if IsValidImage(FNavigatorRight) then
      begin
        P.x := R.Right - Images.Width - 3;
        if FNavigatorStyle = scnRaised then Dec(P.x);
        P.y := R.Top + ((R.Bottom - R.Top) - Images.Height) div 2;

        Images.Draw(Canvas, P.x, P.y, FNavigatorRight, Self.Enabled);
      end else
      begin
        R2 := R;
        R2.Left := R2.Right - 22;

        if not IsRectEmpty(R2) then
        begin
          P.x := R2.Left + ((R2.Right - R2.Left + W - 2) div 2);
          P.y := R2.Top +  ((R2.Bottom - R2.Top + H - 2) div 2);

          scDrawLeftSlider(Canvas, P, W, H, sctsMac, False, Cl3, Cl3);
        end;
      end;
    end;

    R2 := R;
    InflateRect(R2, -22, 0);

    if (FOptions*[sccoNavMonth, sccoNavYear] <> []) and not IsRectEmpty(R2) then
    begin
      SR := IntersectClipRect(Canvas.Handle, R2.Left, R2.Top, R2.Right, R2.Bottom);
      try
        if SR <> NULLREGION then
          with Canvas do
          begin
            Brush.Style := bsClear;

            Font := FNavigatorFont;
            Font.Color := FnCl;

            D := EncodeDate(FDisplayYear, FDisplayMonth, 1);
            if D = 0 then D := SysUtils.Date;

            Fmt := '';
            if sccoNavMonth in FOptions then
              Fmt := 'mmmm';

            if sccoNavYear in FOptions then
              Fmt := Fmt + ' yyyy';

            Text := FormatDateTime(Fmt, D);

            DrawText(Handle, PChar(Text), Length(Text), R2,
              DT_CENTER or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
          end;
      finally
        SelectClipRgn(Canvas.Handle, 0);
      end;
    end;

    case FNavigatorStyle of
      scnFlatWithLine:
      begin
        Cl := FCalColors.FNavigatorLine;
        if Cl = clNone then Cl := GetBtnShadowOf(Cl);
        
        with Canvas do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := Cl;

          MoveTo(R.Left, R.Bottom);
          LineTo(R.Right, R.Bottom);
        end;
      end;
      scnFlat, scnGradientEx:
      begin
        scFrame3D(Canvas, R, GetBtnHighlightOf(Cl), GetBtnShadowOf(Cl), 1, 1);
      end;
      scnRaised:
      begin
        scFrame3D(Canvas, R, GetBtnHighlightOf(Cl), Get3DDkShadowOf(Cl), 1, 1);
        scFrame3D(Canvas, R, Cl, GetBtnShadowOf(Cl), 1, 1);
      end;
      scnMetal:
      begin
        scFrame3D(Canvas, R, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 1);
        scFrame3D(Canvas, R, Cl, GetBtnHighlightOf(Cl), 1, 1);
      end;
    end;
  end;
end;

procedure TSCCustomCalendar.DrawWeekNumbers(R: TRect);
var
  LR: TRect;
  I: Integer;
  P: PSCCalItemRec;
  Cl, FnCl: TColor;
begin
  if HandleAllocated and (sccoWeekNumbers in FOptions) and
    (FWeekNumbersFont <> nil) and not IsRectEmpty(R) and
    (FWeekNumbersList <> nil) and (FWeekNumbersList.Count > 0) then
  begin
    Cl := FCalColors.WeekNumbers;

    FnCl := WeekNumbersFont.Color;
    if FnCl = clNone then FnCl := clWindowText;

    for I := 0 to FWeekNumbersList.Count-1 do
    begin
      P := FWeekNumbersList[I];
      if IsRectEmpty(P^.R) then
        Continue;

      with Canvas do
      begin
        if Cl <> clNone then
        begin
          Brush.Style := bsSolid;
          Brush.Color := Cl;

          FillRect(P^.R);
        end;  

        if P^.S <> '' then
        begin
          Brush.Style := bsClear;

          Font := FWeekNumbersFont;
          Font.Color := FnCl;

          DrawText(Handle, PChar(P^.S), Length(P^.S), P^.R,
            DT_CENTER or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
        end;
      end;
    end;

    if FWeekNumbersList.Count > 0 then
    begin
      P := FWeekNumbersList[0];
      LR := P^.R;

      if FWeekNumbersList.Count > 1 then
      begin
        P := FWeekNumbersList[FWeekNumbersList.Count-1];
        LR.Bottom := P^.R.Bottom;
      end;

      Cl := FCalColors.Lines;
      if Cl = clNone then Cl := clBtnShadow;

      with Canvas do
      begin
        Pen.Width := 1;
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Color := Cl;

        MoveTo(LR.Right - 1, R.Top);
        LineTo(LR.Right - 1, LR.Bottom + 3);
      end;
    end;
  end;
end;

procedure TSCCustomCalendar.FocusChanged;
begin
  FMousePressed := False;
  FFocusedDate  := FDate;
  FDownPart := sccpNowhere;
  FHotPart  := sccpNowhere;

  StopTimer;

  UpdateFontAndColors;
  Invalidate;
end;

procedure TSCCustomCalendar.FontsChanged(Sender: TObject);
begin
  FullUpdate;
end;

function TSCCustomCalendar.GetButtonsHeight: Integer;
var
  F: TFont;
begin
  Result := 0;
  if HandleAllocated and (FButtonFont <> nil) and (Canvas <> nil) then
  begin
    F := TFont.Create;
    try
      F.Assign(Canvas.Font);
      try
        Canvas.Font := FButtonFont;
        Result := Canvas.TextHeight('0q') + 16;
      finally
        Canvas.Font := F;
      end;
    finally
      F.Free;
    end;
  end;
end;

function TSCCustomCalendar.GetCellDate(ACol, ARow: Integer): TDateTime;
var
  AYear, AMonth: Word;
  ADay, DayCount: Integer;
begin
  Result := 0;

  if (ACol > -1) and (ARow > -1) and (ACol < 7) and (ARow < 6) then
  begin
    ADay := FMonthOffset + ACol + ((ARow - 1) * 7);

    AMonth := FDisplayMonth;
    AYear  := FDisplayYear;

    if ADay < 1 then
    begin
      DecMonth(AYear, AMonth);

      DayCount := scDaysPerMonth(AYear, AMonth);
      Inc(ADay, DayCount);
    end else
    if ADay > DaysThisMonth then
    begin
      DayCount := scDaysPerMonth(AYear, AMonth);

      IncMonth(AYear, AMonth);
      Dec(ADay, DayCount);
    end;

    Result := EncodeDate(AYear, AMonth, ADay);
  end;
end;

function TSCCustomCalendar.GetCellRect(ACol, ARow: Integer): TRect;
var
  R: TRect;
  W, H: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (ARow > -1) and (ARow < 6) and (ACol > -1) and (ACol < 7) then
  begin
    R := GetGridRect;

    W := (R.Right - R.Left) div 7;
    H := (R.Bottom - R.Top) div 6;

    if (W <= 0) or (H <= 0) then
      Exit;

    Result.Left := ACol*W;
    Result.Right := Result.Left + W;

    Result.Top := ARow*H;
    Result.Bottom := Result.Top + H;

    OffsetRect(Result, R.Left, R.Top);
  end;
end;

function TSCCustomCalendar.GetClearCaption: String;
begin
  Result := FButtonClear;
  if Result = '' then Result := SSCCalClear;
end;

function TSCCustomCalendar.GetDateAtPos(X, Y: Integer): TDateTime;
var
  I: Integer;
  P: PSCCalendarCell;
begin
  Result := 0;

  I := GetDateIndexAtPos(X, Y);
  if (I > -1) and (I < FDaysList.Count) then
  begin
    P := FDaysList[I];
    Result := EncodeDate(P^.Year, P^.Month, P^.Day);
  end;
end;

function TSCCustomCalendar.GetDateIndexAtPos(X, Y: Integer): Integer;
var
  I: Integer;
  Pt: TPoint;
  P: PSCCalendarCell;
begin
  Result := -1;

  Pt := Point(X, Y);
  for I := 0 to FDaysList.Count-1 do
  begin
    P := FDaysList[I];
    if PtInRect(P^.ARect, Pt) and (P^.Visible or (sccoPastDays in FOptions)) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function TSCCustomCalendar.GetDayCaption(Index: Integer): String;
begin
  if Index < 1 then Index := 1;
  if Index > 7 then Index := 7;

  if FDayCaptions in [scdcThree, scdcLong] then
  begin
    Result := {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}LongDayNames[Index];
    if FDayCaptions = scdcThree then
      Result := Copy(Result, 1, 3);
  end else
  begin
    Result := {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ShortDayNames[Index];
    if FDayCaptions = scdcFirst then
      Result := Result[1]
    else
    if FDayCaptions = scdcTwo then
      Result := Copy(Result, 1, 2);
  end;
end;

procedure TSCCustomCalendar.GetDayCaptionsSize(var H, W: Integer);
var
  F: TFont;
  I, Cw, Mw: Integer;
begin
  H := 0;
  W := 0;

  if HandleAllocated and (FDayCaptionsFont <> nil) and (Canvas <> nil) then
  begin
    F := TFont.Create;
    try
      F.Assign(Canvas.Font);
      try
        Canvas.Font := FDayCaptionsFont;

        H := Canvas.TextHeight('0q') + 4;

        Mw := 0;
        for I := 1 to 7 do
        begin
          Cw := Canvas.TextWidth(GetDayCaption(I));
          if Cw > Mw then Mw := Cw; 
        end;

        W := 7*(Mw + 4);
      finally
        Canvas.Font := F;
      end;
    finally
      F.Free;
    end;
  end;
end;

procedure TSCCustomCalendar.GetDaysSize(var H, W: Integer);
var
  F: TFont;
begin
  H := 0;
  W := 0;

  if HandleAllocated and (Self.Font <> nil) and (Canvas <> nil) then
  begin
    F := TFont.Create;
    try
      F.Assign(Canvas.Font);
      try
        Canvas.Font := Self.Font;

        H := Canvas.TextHeight('0q') + 2;
        W := Canvas.TextWidth('00') + 7;

        W := 7*W;
        H := 6*H;
      finally
        Canvas.Font := F;
      end;
    finally
      F.Free;
    end;
  end;
end;

function TSCCustomCalendar.GetGridRect: TRect;
var
  NH, DcH, DcW,
  WnH, WnW, BH: Integer;
begin
  Result := GetClientRect;

  if HandleAllocated then
  begin
    InflateRect(Result, -(4 + Indent), 0);
    if IsRectEmpty(Result) then
      Exit;
      
    NH := 0;
    if sccoNavigator in FOptions then
      NH := GetNavigatorHeight;

    DcH := 0; DcW := 0;
    if sccoDayCaptions in FOptions then
      GetDayCaptionsSize(DcH, DcW);

    WnH := 0; WnW := 0;
    if sccoWeekNumbers in FOptions then
      GetWeekNumbersSize(WnH, WnW);

    BH := 0;
    if FOptions*[sccoClearBtn, sccoTodayBtn] <> [] then
      BH := GetButtonsHeight;

    Inc(Result.Top, NH + DcH + 2);
    Inc(Result.Left, WnW);
    Dec(Result.Bottom, BH + 4);

    if Result.Bottom < Result.Top then
      Result.Bottom := Result.Top;

    if Result.Right < Result.Left then
      Result.Right := Result.Left;
  end;
end;

function TSCCustomCalendar.GetIndexOfDate(D: TDateTime): Integer;
var
  I: Integer;
  P: PSCCalendarCell;
  Year, Month, Day: Word;
begin
  Result := -1;
  if D = 0 then D := SysUtils.Date;

  DecodeDate(D, Year, Month, Day);
  for I := 0 to FDaysList.Count-1 do
  begin
    P := FDaysList[I];
    if (P^.Day = Day) and (P^.Month = Month) and (P^.Year = Year) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

procedure TSCCustomCalendar.GetMinBounds(var W, H: Integer);
var
  S: String;
  R, CR: TRect;
  WnW, WnH, DW, DH,
  DcW, DcH, NH, BH,
  BW, BtH, BtW: Integer;
begin
  W := Width;
  H := Height;

  if HandleAllocated and not (IsLoading or IsDestroying) then
  begin
    GetDaysSize(DH, DW);

    NH := 0;
    if sccoNavigator in FOptions then
      NH := GetNavigatorHeight;

    DcH := 0; DcW := 0;
    if sccoDayCaptions in FOptions then
      GetDayCaptionsSize(DcH, DcW);

    WnH := 0; WnW := 0;
    if sccoWeekNumbers in FOptions then
    begin
      GetWeekNumbersSize(WnH, WnW);
      if WnH > DH then DH := WnH;
    end;

    BH := 0;
    BW := 0;
    BtH := 0;
    BtW := 0;

    if FOptions*[sccoClearBtn, sccoTodayBtn] <> [] then
    begin
      BH := GetButtonsHeight;
      if BH < 0 then BH := 0;

      if BH > 0 then
      begin
        if sccoClearBtn in FOptions then
        begin
          S := ButtonClear;
          if S = '' then S := SSCCalClear;

          GetButtonSizeFor(S, BtW, BtH);
          if BtW > 0 then Inc(BW, BtW);
        end;

        if sccoTodayBtn in FOptions then
        begin
          S := ButtonToday;
          if S = '' then S := SSCCalToday;

          GetButtonSizeFor(S, BtW, BtH);
          if BtW > 0 then
          begin
            if (sccoClearBtn in FOptions) and (BW > 0) then
              Inc(BW, 16);

            Inc(BW, BtW);
          end;
        end;

        if BW > 0 then Inc(BW, 16);
      end;
    end;

    Inc(DH, DcH + NH + BH);

    if DcW > DW then DW := DcW;
    Inc(DW, WnW);

    R := Rect(0, 0, W, H);

    CR := R;
    CalculateBorder(CR);
    InflateRect(CR, -BorderWidth, -BorderWidth);

    OffsetRect(CR, -CR.Left, -CR.Top);

    H := DH + 4 + (R.Bottom - CR.Bottom) + 6;
    W := DW;

    if BW > W then W := BW;
    Inc(W, 2*(4 + Indent) + (R.Right - CR.Right));
  end;
end;

function TSCCustomCalendar.GetNavigatorHeight(Auto: Boolean): Integer;
var
  F: TFont;
begin
  Result := FNavigatorHeight;
  if ((Result = -1) or Auto) and HandleAllocated and
    (FNavigatorFont <> nil) and (Canvas <> nil) then
  begin
    F := TFont.Create;
    try
      F.Assign(Canvas.Font);
      try
        Canvas.Font := FNavigatorFont;
        Result := Canvas.TextHeight('Oq') + 6;
      finally
        Canvas.Font := F;
      end;
    finally
      F.Free;
    end;
  end;
end;

function TSCCustomCalendar.GetTodayCaption: String;
begin
  Result := FButtonClear;
  if Result = '' then Result := SSCCalToday;
end;

procedure TSCCustomCalendar.GetWeekNumbersSize(var H, W: Integer);
var
  F: TFont;
begin
  H := 0;
  W := 0;

  if HandleAllocated and (FWeekNumbersFont <> nil) and (Canvas <> nil) then
  begin
    F := TFont.Create;
    try
      F.Assign(Canvas.Font);
      try
        Canvas.Font := FWeekNumbersFont;

        H := 6*(Canvas.TextHeight('0q') + 2);
        W := 2*Canvas.TextWidth('00') + 4;
      finally
        Canvas.Font := F;
      end;
    finally
      F.Free;
    end;
  end;
end;

procedure TSCCustomCalendar.HolidaysChanged(Sender: TObject);
begin
  UpdateHolidays;
  UpdateFontAndColors;

  Invalidate;
end;

procedure TSCCustomCalendar.KeyDown(var Key: Word; Shift: TShiftState);
var
  D: TDateTime;
  DayCount, Day: Integer;
  Year, Month, TmpDay: Word;
begin
  if (FMousePressed or MouseIsDown) then
  begin
    if Key = VK_ESCAPE then
    begin
      Key := 0;

      if FMonthPopup <> nil then
        HideMonthPopup
      else begin
        StopTracking;
        if GetCapture = Handle then ReleaseCapture;
      end;
    end;

    Exit;
  end;

  inherited KeyDown(Key, Shift);

  if Key = 0 then
    Exit;

  D := FDate;
  if D = 0 then D := SysUtils.Date;

  DecodeDate(D, Year, Month, TmpDay);
  Day := TmpDay;

  case Key of
    VK_ESCAPE:
    begin
      if FMonthPopup <> nil then
        HideMonthPopup
      else begin
        StopTracking;
        if GetCapture = Handle then ReleaseCapture;
      end;
    end;
    VK_HOME:
    begin
      Day := 1;
    end;
    VK_END:
    begin
      Day := scDaysPerMonth(Year, Month);
    end;
    VK_PRIOR:
    begin
      if (ssCtrl in Shift) and (Year > 0) then
        Dec(Year)
      else
      if (Month > 1) or (Year > 0) then
        DecMonth(Year, Month);

      DayCount := scDaysPerMonth(Year, Month);
      if Day > DayCount then Day := DayCount;
    end;
    VK_NEXT:
    begin
      if (ssCtrl in Shift) and (Year < High(Word)) then
        Inc(Year)
      else
      if (Month < 12) or (Year < High(Word)) then
        IncMonth(Year, Month);

      DayCount := scDaysPerMonth(Year, Month);
      if Day > DayCount then Day := DayCount;
    end;
    VK_LEFT, VK_UP:
    begin
      if Key = VK_LEFT then
        Dec(Day)
      else
        Dec(Day, 7);

      if Day < 1 then
      begin
        DecMonth(Year, Month);

        DayCount := scDaysPerMonth(Year, Month);
        Inc(Day, DayCount);
      end;
    end;
    VK_RIGHT, VK_DOWN:
    begin
      if Key = VK_RIGHT then
        Inc(Day)
      else
        Inc(Day, 7);

      if Day > DaysThisMonth then
      begin
        DayCount := scDaysPerMonth(Year, Month);

        IncMonth(Year, Month);
        Dec(Day, DayCount);
      end;
    end;
    VK_RETURN:
    begin
      if FDate <> D then
      begin
        FDateClick := True;
        SetDate(EncodeDate(Year, Month, Day));
        FDateClick := False;
      end else
        DoDateClick;

      Exit;
    end;
  end;

  SetDate(EncodeDate(Year, Month, Day));
end;

procedure TSCCustomCalendar.Loaded;
begin
  inherited Loaded;
  SetDisplayDate(FDate);
  if Assigned(FOnNavigate) then
    FOnNavigate(Self, FDisplayMonth, FDisplayYear, sccnBoth);
end;

procedure TSCCustomCalendar.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  StopTimer;
  HideMonthPopup;

  FDownPart := sccpNoWhere;
  FHotPart  := sccpNoWhere;
  
  inherited MouseDown(Button, Shift, X, Y);

  if CanFocus and not HasFocus and ClickFocus then
    SetFocus;

  // if Focused then
  begin
    FMousePressed := Button = mbLeft;
    SetCapture(Handle);

    FMousePressed := Button = mbLeft;

    if FMousePressed then
    begin
      FDownPart := GetPartAtPos(X, Y);
      FHotPart  := FDownPart;

      if FDownPart = sccpDays then
        UpdateFocusDate(X, Y)
      else
      if FDownPart = sccpNavMonthYear then
        ShowMonthPopup
      else
      if FDownPart in [sccpNavLeftBtn, sccpNavRightBtn] then
        StartTimer;
    end;

    Invalidate;
  end;
end;

procedure TSCCustomCalendar.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  OldHot: TSCCalendarPart;
begin
  if FMonthPopup <> nil then
  begin
    P := Point(X, Y);
    
    MapWindowPoints(Handle, FMonthPopup.Handle, P, 1);
    TSCMonthListPopup(FMonthPopup).MouseMove(Shift, P.X, P.Y);

    Exit;
  end;

  OldHot   := FHotPart;
  FHotPart := GetPartAtPos(X, Y);

  if FMousePressed then
  begin
    if (FDownPart = sccpDays) then
      UpdateFocusDate(X, Y)
    else
    if (OldHot <> FHotPart) and (FDownPart in [sccpNavLeftBtn, sccpNavRightBtn]) then
    begin
      if FHotPart = FDownPart then
        StartTimer
      else
        StopTimer;
    end else
    if (FDownPart in [sccpTodayBtn, sccpClearBtn]) and (OldHot <> FHotPart) and
      ((FHotPart = FDownPart) or (OldHot = FDownPart)) then
      Invalidate;
  end else
  if (OldHot <> FHotPart) and ((FHotPart in [sccpTodayBtn, sccpClearBtn]) or
    (OldHot in [sccpTodayBtn, sccpClearBtn])) then
    Invalidate;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomCalendar.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  D: TDateTime;
  Year, Month, Day: Word;
  OldHot, OldDown: TSCCalendarPart;
begin
  StopTimer;

  OldHot  := FHotPart;
  OldDown := FDownPart;

  FDownPart := sccpNoWhere;
  FHotPart  := GetPartAtPos(X, Y);
  
  if FMousePressed then
  begin
    if OldDown = sccpDays then
      UpdateFocusDate(X, Y);

    FMousePressed := False;

    if (OldDown = sccpDays) and (FFocusedDate <> 0) then
    begin
      DecodeDate(FFocusedDate, Year, Month, Day);
      if (sccoPastDays in FOptions) or (Month = FDisplayMonth) then
      begin
        FDateClick := True;
        SetDate(FFocusedDate);
        FDateClick := False;
      end;
    end else
    if OldDown = sccpNavMonthYear then
    begin
      if FMonthPopup <> nil then
      begin
        D := TSCMonthListPopup(FMonthPopup).Date;
        HideMonthPopup;

        if D <> SC_NullDate then
          SetDisplayDate(D);

        Exit;
      end;
    end else
    if OldDown in [sccpTodayBtn, sccpClearBtn] then
    begin
      if OldHot <> FHotPart then
        Invalidate;

      if OldDown = FHotPart then
      begin
        if OldDown = sccpTodayBtn then
        begin
          D := SysUtils.Date;
          
          SetDisplayDate(D);

          FDateClick := True;
          SetDate(D);
          FDateClick := False;
        end else
        if OldDown = sccpClearBtn then
          ClearClick;
      end;    
    end;

    Invalidate;
  end;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomCalendar.Paint;
var
  Cl: TColor;
  CR, R: TRect;
  WeekNoW, WeekNoH,
  DayW, DayH, DayCapW,
  DayCapH, SR, NavH, BtnH: Integer;
begin
  if not HandleAllocated then
    Exit;

  CR := GetClientRect;
  if not IsRectEmpty(CR) then
  begin
    if Transparent then
      PaintParentOn(Canvas)
    else
      with Canvas do
      begin
        Brush.Style := bsSolid;

        Cl := Self.Color;
        if Cl = clNone then Cl := clWindow;
      
        Brush.Color := DefaultBlendedColor(Cl);

        FillRect(CR);
      end;

    DrawPicture(Canvas);

    GetDaysSize(DayH, DayW);

    DayCapH := 0; DayCapW := 0;
    if sccoDayCaptions in FOptions then
      GetDayCaptionsSize(DayCapH, DayCapW);

    NavH := 0;
    if sccoNavigator in FOptions then
      NavH := GetNavigatorHeight;

    WeekNoH := 0; WeekNoW := 0;
    if sccoWeekNumbers in FOptions then
      GetWeekNumbersSize(WeekNoH, WeekNoW);

    BtnH := 0;
    if FOptions*[sccoClearBtn, sccoTodayBtn] <> [] then
      BtnH := GetButtonsHeight;

    // Days
    R := CR;
    Inc(R.Left, WeekNoW);
    Inc(R.Top, NavH + DayCapH);
    Dec(R.Bottom, BtnH);

    InflateRect(R, -(4 + Indent), 0);
    IntersectRect(R, R, CR);

    if not IsRectEmpty(R) then
    begin
      SR := IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
      try
        if SR <> NULLREGION then
          DrawDays(R);
      finally
        SelectClipRgn(Canvas.Handle, 0);
      end;
    end;

    // Day Captions
    R := CR;
    Inc(R.Left, WeekNoW - 1);
    Inc(R.Top, NavH);

    InflateRect(R, -(4 + Indent), 0);
    R.Bottom := R.Top + DayCapH;

    if not IsRectEmpty(R) then
    begin
      SR := IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
      try
        if SR <> NULLREGION then
          DrawDayCaptions(R);
      finally
        SelectClipRgn(Canvas.Handle, 0);
      end;
    end;

    // Week Numbers
    R := CR;
    InflateRect(R, -(4 + Indent), 0);
    Inc(R.Top, NavH + DayCapH);
    R.Right := R.Left + DayCapW;

    if not IsRectEmpty(R) then
    begin
      SR := IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
      try
        if SR <> NULLREGION then
          DrawWeekNumbers(R);
      finally
        SelectClipRgn(Canvas.Handle, 0);
      end;
    end;

    // DayNavigator
    R := CR;
    R.Bottom := R.Top + NavH;

    if not IsRectEmpty(R) then
    begin
      SR := IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
      try
        if SR <> NULLREGION then
          DrawNavigator(R);
      finally
        SelectClipRgn(Canvas.Handle, 0);
      end;
    end;

    // Buttons
    R := CR;
    InflateRect(R, -(4 + Indent), 0);
    R.Top := R.Bottom - BtnH;

    if not IsRectEmpty(R) then
    begin
      SR := IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
      try
        if SR <> NULLREGION then
          DrawButtons(R);
      finally
        SelectClipRgn(Canvas.Handle, 0);
      end;
    end;
  end;
end;

function TSCCustomCalendar.PosToDateTime(P: TPoint): TDateTime;
begin
  Result := 0;
end;

procedure TSCCustomCalendar.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
var
  W, H: Integer;
begin
  if HandleAllocated and not (AutoSize or
    IsLoading or IsDestroying) then
  begin
    GetMinBounds(W, H);

    if AWidth < W then AWidth := W;
    if AHeight < H then AHeight := H;
  end;

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TSCCustomCalendar.SetButtonClear(const Value: TCaption);
begin
  if FButtonClear <> Value then
  begin
    FButtonClear := Value;
    if sccoClearBtn in FOptions then
      FullUpdate;
  end;
end;

procedure TSCCustomCalendar.SetButtonFont(Value: TFont);
begin
  FButtonFont.Assign(Value);
end;

procedure TSCCustomCalendar.SetButtonToday(const Value: TCaption);
begin
  if FButtonToday <> Value then
  begin
    FButtonToday := Value;
    if sccoTodayBtn in FOptions then
      FullUpdate;
  end;
end;

procedure TSCCustomCalendar.SetCalColors(Value: TSCCalendarColors);
begin
  FCalColors.Assign(Value);
end;

procedure TSCCustomCalendar.SetDate(Value: TDateTime);
begin
  if (Trunc(FDate) <> Trunc(Value)) or FForceDateChange then
  begin
    FDate := Value;
    FFocusedDate := FDate;

    SetDisplayDate(FDate);
    Invalidate;

    if FDateClick then
    begin
      FDateClick := False;
      DoDateClick;
    end;

    Change;
  end;
end;

procedure TSCCustomCalendar.SetDayCaptions(Value: TSCCalendarDayCaptions);
begin
  if FDayCaptions <> Value then
  begin
    FDayCaptions := Value;

    if sccoDayCaptions in FOptions then
      FullUpdate;
  end;
end;

procedure TSCCustomCalendar.SetDayCaptionsFont(Value: TFont);
begin
  FDayCaptionsFont.Assign(Value);
end;

procedure TSCCustomCalendar.SetDisplayDate(Value: TDateTime);
var
  NavStyle: TSCCalendarNavigateStyle;
  OldMonth, OldYear, AYear, AMonth, ADay: Word;
begin
  if Value = 0 then
    Value := SysUtils.Date;

  OldMonth := FDisplayMonth;
  OldYear  := FDisplayYear;

  DecodeDate(Value, AYear, AMonth, ADay);

  if FForceDateChange or (FDisplayMonth <> AMonth) or (FDisplayYear <> AYear) then
    DisplayParameters(Value, FMonthOffset, FFirstDate, FDisplayYear, FDisplayMonth);

  UpdateDays;
  UpdateDayCaptions;
  UpdateWeekNumbers;

  if ((OldMonth <> FDisplayMonth) or (OldYear <> FDisplayYear)) and Assigned(FOnNavigate) then
  begin
    NavStyle := sccnMonth;
    if (OldMonth <> FDisplayMonth) and (OldYear <> FDisplayYear) then
      NavStyle := sccnBoth
    else if OldYear <> FDisplayYear then
      NavStyle := sccnYear;
      
    FOnNavigate(Self, FDisplayMonth, FDisplayYear, NavStyle);
  end;
end;

procedure TSCCustomCalendar.SetHolidays(Value: TSCHolidays);
begin
  FHolidays.Assign(Value);
end;

procedure TSCCustomCalendar.SetNavigatorHeight(Value: Integer);
begin
  if Value <= -1 then
    Value := -1
  else
  if Value < 16 then
    Value := 16;

  if FNavigatorHeight <> Value then
  begin
    FNavigatorHeight := Value;
    if sccoNavigator in FOptions then
      FullUpdate;
  end;
end;

procedure TSCCustomCalendar.SetNavigatorFont(Value: TFont);
begin
  FNavigatorFont.Assign(Value);
end;

procedure TSCCustomCalendar.SetNavigatorStyle(Value: TSCNavigatorStyle);
begin
  if FNavigatorStyle <> Value then
  begin
    FNavigatorStyle := Value;
    if sccoNavigator in FOptions then
      Invalidate;
  end;
end;

procedure TSCCustomCalendar.SetOptions(Value: TSCCalendarOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    FullUpdate;
  end;
end;

procedure TSCCustomCalendar.SetStartOfWeek(Value: TSCStartOfWeek);
begin
  if FStartOfWeek <> Value then
  begin
    FStartOfWeek := Value;

    FForceDateChange := True;
    try
      SetDate(FDate);
    finally
      FForceDateChange := False;
    end;
  end;
end;

procedure TSCCustomCalendar.SetWeekNumbersFont(Value: TFont);
begin
  FWeekNumbersFont.Assign(Value);
end;

function TSCCustomCalendar.StartOfWeekAsInt: Integer;
var
  A: array[0..1] of Char;
begin
  Result := Ord(FStartOfWeek) + 1;

  if FStartOfWeek = scswLocaleDefault then
  begin
    GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_IFIRSTDAYOFWEEK, A, SizeOf(A));
    Result := Ord(A[0]) - Ord('0') + 1;
  end;
end;

procedure TSCCustomCalendar.UpdateFontAndColors;
var
  I, J: Integer;
  D: TDateTime;
  P: PSCCalendarCell;
  Year, Month, Day: Word;
  WeCl, WeFnCl, GrCl, GrFnCl,
  Cl, FnCl, HdCl, HdFnCl, SpCl, SpFnCl: TColor;
begin
  D := FDate;
  if D = 0 then
  begin
    Year := 0;
    Month := 0;
    Day := 0;
  end else
    DecodeDate(D, Year, Month, Day);

  {Cl := Self.Color;
  if Cl = clNone then Cl := clWindow;

  if FCalColors.DaysBackground <> clNone then
    Cl := FCalColors.DaysBackground;}

  Cl := FCalColors.DaysBackground;
    
  FnCl := Self.Font.Color;
  if FnCl = clNone then FnCl := clWindowText;

  HdCl := Cl;
  HdFnCl := FnCl;

  SpCl := Cl;
  SpFnCl := FnCl;

  if sccoHolidays in FOptions then
  begin
    if FCalColors.Holidays <> clNone then
      HdCl := FCalColors.Holidays;

    if FCalColors.HolidaysText <> clNone then
      HdFnCl := FCalColors.HolidaysText;
  end;

  if sccoSpecialDays in FOptions then
  begin
    if FCalColors.SpecialDay <> clNone then
      SpCl := FCalColors.SpecialDay;

    if FCalColors.SpecialDayText <> clNone then
      SpFnCl := FCalColors.SpecialDayText;
  end;

  GrCl := Cl;
  GrFnCl := FnCl;

  if sccoPastDaysGrayed in FOptions then
  begin
    GrCl := FCalColors.Grayed;
    GrFnCl := FCalColors.GrayedText;
  end;

  WeCl := Cl;
  WeFnCl := FnCl;

  if sccoWeekendDays in FOptions then
  begin
    if FCalColors.WeekendDays <> clNone then
      WeCl := FCalColors.WeekendDays;

    if FCalColors.WeekendDaysText <> clNone then
      WeFnCl := FCalColors.WeekendDaysText;
  end;

  for I := 0 to FDaysList.Count-1 do
  begin
    P := FDaysList[I];

    P^.Color := Cl;
    P^.FontColor := FnCl;
    P^.FontStyles := [];

    if (sccoHighlight in FOptions) and
      (P^.Day = Day) and (P^.Month = Month) and (P^.Year = Year) then
    begin
      if IsDesigning or Focused then
      begin
        if FCalColors.Highlight <> clNone then
          P^.Color := FCalColors.Highlight;

        if FCalColors.HighlightText <> clNone then
          P^.FontColor := FCalColors.HighlightText;
      end else
      begin
        if FCalColors.HideSelection <> clNone then
          P^.Color := FCalColors.HideSelection;

        if FCalColors.HideSelectionText <> clNone then
          P^.FontColor := FCalColors.HideSelectionText;
      end;
    end else
    if P^.IsSpecial and (FSpecialDays <> nil) and (sccoSpecialDays in FOptions) then
    begin
      P^.Color := SpCl;
      P^.FontColor := SpFnCl;

      for J := 0 to FSpecialDays.Count-1 do
        if (scGetMonthIndex(FSpecialDays[J].Month) = P^.Month) and
          (FSpecialDays[J].Day = P^.Day) then
        begin
          P^.FontStyles := FSpecialDays[J].FFontStyles;

          if FSpecialDays[J].FBackColor <> clNone then
            P^.Color := FSpecialDays[J].FBackColor;

          if FSpecialDays[J].FFontColor <> clNone then
            P^.FontColor := FSpecialDays[J].FFontColor;

          Break;
        end;
    end else
    if P^.IsHoliday and (FHolidays <> nil) and (sccoHolidays in FOptions) then
    begin
      P^.Color := HdCl;
      P^.FontColor := HdFnCl;

      for J := 0 to FHolidays.Count-1 do
        if (scGetMonthIndex(FHolidays[J].Month) = P^.Month) and
          (FHolidays[J].Day = P^.Day) then
        begin
          P^.FontStyles := FHolidays[J].FFontStyles;

          if FHolidays[J].FBackColor <> clNone then
            P^.Color := FHolidays[J].FBackColor;

          if FHolidays[J].FFontColor <> clNone then
            P^.FontColor := FHolidays[J].FFontColor;

          Break;
        end;
    end else
    if (sccoWeekendDays in FOptions) and (P^.Month = FDisplayMonth) and
      (P^.DayName in FWeekendDays) then
    begin
      P^.Color := WeCl;
      P^.FontColor := WeFnCl;
    end else
    if P^.Month <> FDisplayMonth then
    begin
      P^.Color := GrCl;
      P^.FontColor := GrFnCl;

      if (sccoWeekendDays in FOptions) and (P^.DayName in FWeekendDays) then
      begin
        if GrCl = clNone then
          P^.Color := WeCl;

        if GrFnCl = clNone then
          P^.FontColor := WeFnCl;
      end;

      if P^.Color = clNone then
        P^.Color := Cl;

      if P^.FontColor = clNone then
        P^.FontColor := FnCl;
    end;

    GetDateStyle(P^.Day, P^.Month, Integer(P^.Year), P^.Color,
      P^.FontColor, P^.FontStyles);
  end;
end;

procedure TSCCustomCalendar.UpdateDayRects;
var
  R: TRect;
  P, P2: PSCCalendarCell;
  Spare, I, ARow, ACol, W, H: Integer;
begin
  R := GetGridRect;

  W := (R.Right - R.Left) div 7;
  H := (R.Bottom - R.Top) div 6;

  if W < 0 then W := 0;
  if H < 0 then H := 0;

  Spare := 0;
  if W > 0 then
    Spare := (R.Right - R.Left) mod 7;

  for I := 0 to FDaysList.Count-1 do
  begin
    P := FDaysList[I];

    P^.ARect := Rect(0, 0, 0, 0);

    ARow := I div 7;
    ACol := I mod 7;

    if (W > 0) and (H > 0) then
    begin
      with P^.ARect do
      begin
        Left  := ACol*W;
        Right := Left + W;

        Top := ARow*H;
        Bottom := Top + H;

        if Spare > 0 then
        begin
          if (I > 0) and (ACol > 0) then
          begin
            P2 := FDaysList[I-1];
            if P2 <> nil then Left := P2^.ARect.Right;
          end;

          if ACol < Spare then
            Inc(Right);
        end;

        OffsetRect(P^.ARect, R.Left, R.Top);
      end;
    end;
  end;
end;

procedure TSCCustomCalendar.UpdateDays;
var
  Dt: TDateTime;
  I, J: Integer;
  P: PSCCalendarCell;
begin
  ClearDays;

  for I := 0 to 5 do
    for J := 0 to 6 do
    begin
      Dt := GetCellDate(J, I);
      New(P);

      P^.IsHoliday := False;
      P^.IsSpecial := False;
      P^.DayName := DateToDayName(Dt);

      DecodeDate(Dt, P^.Year, P^.Month, P^.Day);

      P^.Visible := (P^.Month = FDisplayMonth) or (sccoPastDays in FOptions);
      P^.ARect := Rect(0, 0, 0, 0);

      FDaysList.Add(P);
    end;

  UpdateHolidays;
  UpdateSpecialDays;
  UpdateFontAndColors;
  UpdateDayRects;

  Invalidate;
end;

procedure TSCCustomCalendar.UpdateFocusDate(X, Y: Integer);
var
  I, Fi: Integer;
begin
  if FMousePressed then
  begin
    I := GetDateIndexAtPos(X, Y);

    Fi := -1;
    if FFocusedDate <> 0 then
      Fi := GetIndexOfDate(FFocusedDate);

    if Fi <> I then
    begin
      FFocusedDate := FDate;
      if I > -1 then
        FFocusedDate := GetDateAtPos(X, Y);

      Invalidate;
    end;
  end;
end;

procedure TSCCustomCalendar.UpdateHolidays;
var
  I, J: Integer;
  PC: PSCCalendarCell;
begin
  if (FDaysList <> nil) and (FHolidays <> nil) then
    for I := 0 to FDaysList.Count-1 do
    begin
      PC := FDaysList[I];

      PC^.IsHoliday := False;

      for J := 0 to FHolidays.Count-1 do
        if (scGetMonthIndex(FHolidays[J].Month) = PC^.Month) and
          (FHolidays[J].Day = PC^.Day) and ((FHolidays[J].Year = -1) or
          (FHolidays[J].Year = PC^.Year)) then
        begin
          PC^.IsHoliday := True;
          Break;
        end;
    end;
end;

procedure TSCCustomCalendar.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTCHARS or DLGC_WANTARROWS;
end;

procedure TSCCustomCalendar.WMMouseWheel(var Message: TWMMouseWheel);
var
  D: TDateTime;
  DayCount, Day: Integer;
  Year, Month, TmpDay: Word;
begin
  if IsDesigning then
    Exit;

  D := EncodeDate(FDisplayYear, FDisplayMonth, 1);
  if D = 0 then D := SysUtils.Date;

  DecodeDate(D, Year, Month, TmpDay);
  Day := TmpDay;

  if Message.WheelDelta < 0 then
  begin
    IncMonth(Year, Month);

    DayCount := scDaysPerMonth(Year, Month);
    if Day > DayCount then Day := DayCount;
  end else
  begin
    DecMonth(Year, Month);

    DayCount := scDaysPerMonth(Year, Month);
    if Day > DayCount then Day := DayCount;
  end;

  SetDisplayDate(EncodeDate(Year, Month, Day));
end;

procedure TSCCustomCalendar.WMSize(var Message: TWMSize);
begin
  inherited;
  if HandleAllocated and not (IsLoading or IsDestroying) then
  begin
    UpdateDayRects;
    UpdateDayCaptions;
    UpdateWeekNumbers;
  end;
end;

procedure TSCCustomCalendar.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;
  if HandleAllocated and not (IsLoading or IsDestroying) then
  begin
    UpdateDayRects;
    UpdateDayCaptions;
    UpdateWeekNumbers;
  end;  
end;

procedure TSCCustomCalendar.SetNavigatorGradient(Value: TSCGradient);
begin
  if FNavigatorGradient <> Value then
  begin
    FNavigatorGradient := Value;
    if (sccoNavigator in FOptions) and
      (FNavigatorStyle in [scnGradient, scnGradientEx]) then
      Invalidate;
  end;
end;

function TSCCustomCalendar.GetPartAtPos(X, Y: Integer): TSCCalendarPart;
var
  P: TPoint;
  H, W: Integer;
  CR, R, R2: TRect;
begin
  Result := sccpNoWhere;

  P := Point(X, Y);

  CR := GetClientRect;
  if not IsRectEmpty(CR) and PtInRect(CR, P) then
  begin
    Result := sccpClient;
    
    if sccoNavigator in FOptions then
    begin
      H := GetNavigatorHeight;

      if H > 0 then
      begin
        R := CR;

        if H > CR.Bottom then
          H := CR.Bottom;

        R.Bottom := R.Top + H;
        Inc(CR.Top, H);

        if not IsRectEmpty(R) and PtInRect(R, P) then
        begin
          Result := sccpNavigator;

          case FNavigatorStyle of
            scnGradientEx, scnFlat:
              InflateRect(R, -1, -1);
            scnRaised, scnMetal:
              InflateRect(R, -2, -2);
          end;

          if IsRectEmpty(R) then
            Exit;

          if sccoNavButtons in FOptions then
          begin
            W := 22;

            R2 := R;
            R2.Right := R.Left + W;

            if R2.Right > R.Right then
              R2.Right := R.Right;

            R.Left := R2.Right;
            if PtInRect(R2, P) then
            begin
              Result := sccpNavLeftBtn;
              Exit;
            end;

            if IsRectEmpty(R) then
              Exit;

            R2 := R;
            R2.Left := R2.Right - W;

            if R2.Left < R.Left then
              R2.Left := R.Left;

            R.Right := R2.Left;
            if PtInRect(R2, P) then
            begin
              Result := sccpNavRightBtn;
              Exit;
            end;

            if IsRectEmpty(R) then
              Exit;
          end;

          if PtInRect(R, P) and
            (FOptions*[sccoNavYear, sccoNavMonth] <> []) then
          begin
            Result := sccpNavMonthYear;
            Exit;
          end;

          Exit;
        end;

        if IsRectEmpty(CR) then
          Exit;
      end;
    end;

    InflateRect(CR, -(4 + Indent), -2);
    Dec(CR.Bottom, 8);
    if IsRectEmpty(CR) then
      Exit;

    if sccoDayCaptions in FOptions then
    begin
      H := 0; W := 0;

      GetDayCaptionsSize(H, W);

      if (H > 0) and (W > 0) then
      begin
        R := CR;

        if H > CR.Bottom then
          H := CR.Bottom;

        R.Bottom := R.Top + H;
        Inc(CR.Top, H);

        if PtInRect(R, P) then
        begin
          R.Left := R.Right - W;
          if R.Left < CR.Left then
            R.Left := CR.Left;

          if PtInRect(R, P) then
            Result := sccpDayCaptions;

          Exit;
        end;

        if IsRectEmpty(CR) then
          Exit;
      end;
    end;

    if sccoWeekNumbers in FOptions then
    begin
      GetWeekNumbersSize(H, W);

      if (H > 0) and (W > 0) then
      begin
        R := CR;

        if H > CR.Bottom then
          H := CR.Bottom;

        if W > CR.Right then
          W := CR.Right;

        R.Right := R.Left + W;
        CR.Left := R.Right;

        if PtInRect(R, P) then
        begin
          R.Bottom := R.Top + H;

          if PtInRect(R, P) then
            Result := sccpWeekNumbers;
            
          Exit;
        end;

        if IsRectEmpty(CR) then
          Exit;
      end;
    end;

    if FOptions*[sccoTodayBtn, sccoClearBtn] <> [] then
    begin
      H := GetButtonsHeight;

      if H > 0 then
      begin
        R := CR;
        R.Top := R.Bottom - H;

        if R.Top < CR.Top then
          R.Top := CR.Top;

        CR.Bottom := R.Top;

        if IsRectEmpty(CR) then
          Exit;

        GetButtonRects(R, R2);

        if (sccoTodayBtn in FOptions) and not IsRectEmpty(R) and
          PtInRect(R, P) then
        begin
          Result := sccpTodayBtn;
          Exit;
        end;

        if (sccoClearBtn in FOptions) and not IsRectEmpty(R2) and
          PtInRect(R2, P) then
        begin
          Result := sccpClearBtn;
          Exit;
        end;
      end;
    end;

    if not IsRectEmpty(CR) and PtInRect(CR, P) then
      Result := sccpDays;
  end;
end;

procedure TSCCustomCalendar.StopTracking;
begin
  FMousePressed := False;
  FFocusedDate  := FDate;
  FDownPart := sccpNowhere;
  FHotPart  := sccpNowhere;

  StopTimer;
  HideMonthPopup;

  UpdateFontAndColors;
  Invalidate;
  inherited StopTracking;
end;

function TSCCustomCalendar.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCCalendarBorderProps;
end;

procedure TSCCustomCalendar.ClearDayCaptions;
var
  I: Integer;
  P: PSCCalItemRec;
begin
  for I := FDayCaptionsList.Count-1 downto 0 do
  begin
    P := FDayCaptionsList[I];
    FDayCaptionsList.Delete(I);

    Dispose(P);
  end;
end;

procedure TSCCustomCalendar.ClearWeekNumbers;
var
  I: Integer;
  P: PSCCalItemRec;
begin
  for I := FWeekNumbersList.Count-1 downto 0 do
  begin
    P := FWeekNumbersList[I];
    FWeekNumbersList.Delete(I);

    Dispose(P);
  end;
end;

procedure TSCCustomCalendar.UpdateDayCaptions;
var
  CR, R, R2: TRect;
  P, P2: PSCCalItemRec;
  I, Spare, WS, H, W,
  DW, NH, WnH, WnW: Integer;
begin
  ClearDayCaptions;

  if HandleAllocated and (sccoDayCaptions in FOptions) then
  begin
    CR := GetClientRect;

    InflateRect(CR, -(4 + Indent), 0);
    Dec(CR.Bottom, 4);

    if IsRectEmpty(CR) then
      Exit;

    GetDayCaptionsSize(H, W);
    if (W = 0) or (H = 0) then
      Exit;

    if sccoNavigator in FOptions then
    begin
      NH := GetNavigatorHeight;
      if NH > 0 then
      begin
        Inc(CR.Top, NH);
        if IsRectEmpty(CR) then
          Exit;
      end;
    end;

    if sccoWeekNumbers in FOptions then
    begin
      GetWeekNumbersSize(WnH, WnW);

      Inc(CR.Left, WnW);
      if IsRectEmpty(CR) then
        Exit;
    end;

    R := CR;
    R.Bottom := R.Top + H;
    if IsRectEmpty(R) then
      Exit;

    IntersectRect(R2, R, CR);
    if IsRectEmpty(R2) then
      Exit;

    DW := (CR.Right - CR.Left) div 7;

    Spare := 0;

    W := W div 7;
    if DW > W then
    begin
      W := DW;
      Spare := (CR.Right - CR.Left) mod 7;
    end;

    if W = 0 then
      Exit;

    WS := StartOfWeekAsInt;

    for I := 0 to 6 do
    begin
      New(P);

      P^.R := Rect(R.Left + (W*I), R.Top, R.Left + (W*(I + 1)), R.Bottom);
      P^.S := GetDayCaption(((I + WS) mod 7) + 1);

      if Spare > 0 then
      begin
        if I > 0 then
        begin
          P2 := FDayCaptionsList[I-1];
          if P2 <> nil then P^.R.Left := P2^.R.Right;
        end;

        if I < Spare then
          Inc(P^.R.Right);
      end;

      FDayCaptionsList.Add(P);
    end;
  end;
end;

procedure TSCCustomCalendar.UpdateWeekNumbers;
var
  D, D2: TDateTime;
  Row, Col: Word;
  CR, R, R2: TRect;
  P: PSCCalItemRec;
  PrevMonth: Boolean;
  Year, Month, Day: Word;
  I, WeekNo, Ch, W,
  H, NH, BH, DcH, DcW: Integer;
begin
  ClearWeekNumbers;

  if HandleAllocated and (sccoWeekNumbers in FOptions) then
  begin
    CR := GetClientRect;
    InflateRect(CR, -(4 + Indent), 0);
    Inc(CR.Top, 2);
    Dec(CR.Bottom, 4);

    if IsRectEmpty(CR) then
      Exit;

    GetWeekNumbersSize(H, W);
    if (W = 0) or (H = 0) then
      Exit;

    if sccoNavigator in FOptions then
    begin
      NH := GetNavigatorHeight;
      if NH > 0 then
      begin
        Inc(CR.Top, NH);
        if IsRectEmpty(CR) then
          Exit;
      end;
    end;

    if sccoDayCaptions in FOptions then
    begin
      GetDayCaptionsSize(DcH, DcW);

      if DcH > 0 then
      begin
        Inc(CR.Top, DcH);
        if IsRectEmpty(CR) then
          Exit;
      end;
    end;

    if FOptions*[sccoClearBtn, sccoTodayBtn] <> [] then
    begin
      BH := GetButtonsHeight;
      if BH > 0 then
      begin
        Dec(CR.Bottom, BH);
        if IsRectEmpty(CR) then
          Exit;
      end;
    end;

    R := CR;
    R.Right := R.Left + W;

    IntersectRect(R2, R, CR);
    if IsRectEmpty(R2) then
      Exit;

    Ch := (CR.Bottom - CR.Top) div 6;
    H := H div 6;

    if H < Ch then H := Ch;

    if H = 0 then
      Exit;

    D := EncodeDate(FDisplayYear, FDisplayMonth, 1);

    FirstRowColOfMonth(D, Col, Row);
    PrevMonth := Row > 0;

    for I := 0 to 5 do
    begin
      New(P);

      P^.R := Rect(R.Left, R.Top + (H*I), R.Right, R.Top + (H*(I + 1)));

      if (I = 0) and PrevMonth then
      begin
        if FDisplayMonth = 1 then
        begin
          WeekNo := 52;
          if FDisplayYear > 0 then
          begin
            D2 := EncodeDate(FDisplayYear - 1, 12, scDaysPerMonth(FDisplayYear - 1, 12));
            WeekNo := WeekNumberOf(D2);
          end;
        end else
        begin
          D2 := EncodeDate(FDisplayYear, FDisplayMonth - 1,
            scDaysPerMonth(FDisplayYear, FDisplayMonth - 1));
          WeekNo := WeekNumberOf(D2);
        end;
      end else
      begin
        D2 := D + (7*I);
        WeekNo := WeekNumberOf(D2);

        DecodeDate(D2, Year, Month, Day);
        if Year > FDisplayYear then
        begin
          D2 := EncodeDate(FDisplayYear, 12, scDaysPerMonth(FDisplayYear, 12));
          WeekNo := WeekNumberOf(D2);
        end;

        if PrevMonth then
          Dec(WeekNo);
      end;

      P^.S := IntToStr(WeekNo);

      FWeekNumbersList.Add(P);
    end;
  end;
end;

function TSCCustomCalendar.WeekNumberOf(D: TDateTime): Word;
var
  Year, Month, Day: Word;
  I, SW, DayCount, FirstDayOfYear: Integer;
begin
  if D = 0 then D := SysUtils.Date;

  DecodeDate(D, Year, Month, Day);

  SW := StartOfWeekAsInt;
  FirstDayOfYear := scFirstDayOfWeek(EncodeDate(Year, 1, 1)) - SW;

  if FirstDayOfYear < 0 then
    Inc(FirstDayOfYear, 7);

  DayCount := FirstDayOfYear;
  if Month > 1 then
    for I := 1 to Month-1 do
      Inc(DayCount, scDaysPerMonth(Year, I));

  Inc(DayCount, Day);

  Result := DayCount div 7;
  if DayCount mod 7 > 0 then
    Inc(Result);
end;

procedure TSCCustomCalendar.DisplayParameters(D: TDateTime; var MOffset: Integer;
  var FirstDay: TDateTime; var DispYear, DispMonth: Word);
var
  Day: Word;
  Dy: Integer;
begin
  if D = 0 then D := SysUtils.Date;

  DecodeDate(D, DispYear, DispMonth, Day);

  FirstDay := EncodeDate(DispYear, DispMonth, 1);
  MOffset := 2 - ((DayOfWeek(FirstDay) - StartOfWeekAsInt + 7) mod 7);

  if MOffset = 2 then MOffset := -5;

  Dy := MOffset - 7;
  if Dy <= -7 then Inc(MOffset, 7);
end;

procedure TSCCustomCalendar.FirstRowColOfMonth(D: TDateTime; var Col, Row: Word);
var
  FirstDay: TDateTime;
  I, J, Day, MOffset: Integer;
  DispYear, DispMonth: Word;
begin
  if D = 0 then D := SysUtils.Date;

  Col := 0;
  Row := 0;

  DisplayParameters(D, MOffset, FirstDay, DispYear, DispMonth);

  for I := 0 to 5 do
    for J := 0 to 6 do
    begin
      Day := MOffset + J + ((I - 1) * 7);

      if Day = 1 then
      begin
        Row := I;
        Col := J;

        Break;
      end;
    end;
end;

procedure TSCCustomCalendar.FullUpdate;
begin
  if not AutoSize then
    SetBounds(Left, Top, Width, Height)
  else
    AdjustBounds;

  UpdateDays;
  UpdateDayCaptions;
  UpdateWeekNumbers;

  Invalidate;
end;

procedure TSCCustomCalendar.GetButtonSizeFor(S: String; var W, H: Integer);
var
  F: TFont;
begin
  W := 0;
  H := 0;

  if HandleAllocated and (FButtonFont <> nil) and (Canvas <> nil) then
  begin
    F := TFont.Create;
    try
      F.Assign(Canvas.Font);
      try
        Canvas.Font := FButtonFont;

        H := Canvas.TextHeight('0q') + 8;
        W := Canvas.TextWidth(S) + 16;
      finally
        Canvas.Font := F;
      end;
    finally
      F.Free;
    end;
  end;
end;

procedure TSCCustomCalendar.GetButtonRects(var TodayR, ClearR: TRect);
var
  F: TFont;
  R: TRect;
  S: String;
  L, W, H: Integer;
begin
  ClearR := Rect(0, 0, 0, 0);
  TodayR := Rect(0, 0, 0, 0);

  if HandleAllocated and (FButtonFont <> nil) and
    (FOptions*[sccoClearBtn, sccoTodayBtn] <> []) then
  begin
    R := GetClientRect;
    InflateRect(R, -(4 + Indent), 0);

    if IsRectEmpty(R) then
      Exit;

    F := TFont.Create;
    try
      F.Assign(Canvas.Font);
      try
        Canvas.Font := FButtonFont;
        H := Canvas.TextHeight('0q') + 16;

        if H = 0 then
          Exit;

        R.Top := R.Bottom - H;

        if sccoClearBtn in FOptions then
        begin
          S := ButtonClear;
          if S = '' then S := SSCCalClear;

          H := Canvas.TextHeight('0q') + 8;
          W := Canvas.TextWidth(S) + 16;

          if W < 0 then W := 0;
          if H < 0 then H := 0;

          ClearR := Rect(0, 0, W, H);
          OffsetRect(ClearR, 0, R.Top);
        end;

        if sccoTodayBtn in FOptions then
        begin
          S := ButtonToday;
          if S = '' then S := SSCCalToday;

          H := Canvas.TextHeight('0q') + 8;
          W := Canvas.TextWidth(S) + 16;

          if W < 0 then W := 0;
          if H < 0 then H := 0;

          TodayR := Rect(0, 0, W, H);
          OffsetRect(TodayR, 0, R.Top);
        end;

        L := R.Left + (((R.Right - R.Left) - (ClearR.Right + TodayR.Right)) div 2);
        if (sccoTodayBtn in FOptions) and (sccoClearBtn in FOptions) then
          Dec(L, 8);

        OffsetRect(TodayR, L, 0);

        OffsetRect(ClearR, L + (TodayR.Right - TodayR.Left), 0);
        if (sccoTodayBtn in FOptions) and (sccoClearBtn in FOptions) then
          OffsetRect(ClearR, 16, 0);
      finally
        Canvas.Font := F;
      end;
    finally
      F.Free;
    end;
  end;
end;

function TSCCustomCalendar.GetButtonRect(Btn: TSCCalButtonType): TRect;
var
  TodayR, ClearR: TRect;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated and (FButtonFont <> nil) and
    (((Btn = scbtToday) and (sccoTodayBtn in FOptions)) or
    ((Btn = scbtClear) and (sccoClearBtn in FOptions))) then
  begin
    GetButtonRects(TodayR, ClearR);

    Result := TodayR;
    if Btn = scbtClear then
      Result := ClearR;
  end;
end;

procedure TSCCustomCalendar.SetButtonStyle(Value: TSCCalButtonStyle);
begin
  if FButtonStyle <> Value then
  begin
    FButtonStyle := Value;
    if FOptions*[sccoTodayBtn, sccoClearBtn] <> [] then
      Invalidate;
  end;
end;

function TSCCustomCalendar.GetYearMonthRect(Auto: Boolean): TRect;
var
  H: Integer;
  CR: TRect;
begin
  Result := Rect(0, 0, 0, 0);

  if (sccoNavigator in FOptions) and (FOptions*[sccoNavYear, sccoNavMonth] <> []) and
    HandleAllocated and (FNavigatorFont <> nil) and (Canvas <> nil) then
  begin
    CR := GetClientRect;
    if IsRectEmpty(CR) then
      Exit;

    H := GetNavigatorHeight(Auto);
    if H < 1 then
      Exit;

    Result := CR;
    Result.Bottom := Result.Top + H;

    if sccoNavButtons in FOptions then
      InflateRect(Result, -22, 0);
  end;
end;

procedure TSCCustomCalendar.HideMonthPopup;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
    if GetCapture = Handle then ReleaseCapture;

    if FMonthPopup <> nil then
    begin
      FMonthPopup.Free;
      FMonthPopup := nil;
    end;
  end;
end;

procedure TSCCustomCalendar.ShowMonthPopup;
var
  R: TRect;
  Year, Month: Word;
begin
  HideMonthPopup;

  if sccoNavigator in FOptions then
  begin
    FMonthPopup := TSCMonthListPopup.Create(Self);
    FMonthPopup.Visible := False;
    FMonthPopup.Parent := Self;

    Year := FDisplayYear;
    Month := FDisplayMonth;

    if FPopupType = sccpMonthYear then
      IterateMonth(Year, Month, -3)
    else
      Dec(Year, 3);

    R := GetYearMonthRect(False);

    MapWindowPoints(Handle, 0, R, 2);

    with TSCMonthListPopup(FMonthPopup) do
    begin
      AlignText := Self.FAlignPopupText;
      Border := Self.FPopupBorder;
      Color := FCalColors.Popup;
      DisplayType := Self.FPopupType;
      Highlight := FCalColors.PopupHighlight;
      HighlightText := FCalColors.PopupHighlightText;

      Font.Assign(FPopupFont);
      SendMessage(Handle, CM_FONTCHANGED, 0, 0);

      StartDate := EncodeDate(Year, Month, 1);

      Left := (R.Left + R.Right - Width) div 2;
      Top := (R.Top + R.Bottom) div 2 - Height div 2;
      ShowWindow(Handle, SW_SHOWNOACTIVATE);

      if GetCapture <> Self.Handle then
        SetCapture(Self.Handle);
    end;
  end;
end;

procedure TSCCustomCalendar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_CLIPCHILDREN;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
  end;
end;

procedure TSCCustomCalendar.WMDestroy(var Message: TMessage);
begin
  StopTimer;
  HideMonthPopup;
  inherited;
end;

procedure TSCCustomCalendar.SetPopupFont(Value: TFont);
begin
  FPopupFont.Assign(Value);
end;

procedure TSCCustomCalendar.ScrollMonth;
var
  Year, Month: Word;
begin
  Year := FDisplayYear;
  Month := FDisplayMonth;

  if FDownPart = sccpNavLeftBtn then
    DecMonth(Year, Month)
  else
  if FDownPart = sccpNavRightBtn then
    IncMonth(Year, Month);
    
  SetDisplayDate(EncodeDate(Year, Month, 1));
end;

procedure TSCCustomCalendar.StartTimer;
var
  Sc, Tm: Integer;
begin
  if HandleAllocated then
  begin
    Inc(FScrollCount);
    if FScrollCount > 30 then FScrollCount := 30;

    Sc := FScrollCount;
    try
      StopTimer;
    finally
      FScrollCount := Sc;
    end;

    if Enabled then
    begin
      Tm := 300;
      if FScrollCount = 30 then
        Tm := 50
      else if FScrollCount > 14 then
        Tm := 100
      else if FScrollCount > 6 then
        Tm := 200;

      FTimer := SetTimer(Handle, SC_MONTH_TIMERID, Tm, nil);
      ScrollMonth;
    end;
  end;
end;

procedure TSCCustomCalendar.StopTimer;
begin
  if FTimer > 0 then
  begin
    FScrollCount := 0;
    KillTimer(Handle, SC_MONTH_TIMERID);
    FTimer := 0;
  end;
end;

procedure TSCCustomCalendar.WMTimer(var Message: TWMTimer);
begin
  inherited;
  if HandleAllocated then
  begin
    if not Enabled or not FMousePressed or
      not (FDownPart in [sccpNavLeftBtn, sccpNavRightBtn]) then
      StopTimer
    else
    if (FTimer > 0) and (Message.TimerID = SC_MONTH_TIMERID) then
      StartTimer;
  end;
end;

procedure TSCCustomCalendar.MouseInControlChanged;
begin
  if not MouseInControl then
    StopTimer
  else
  if (FHotPart = FDownPart) and (FDownPart in [sccpNavLeftBtn, sccpNavRightBtn]) then
    StartTimer;

  inherited MouseInControlChanged;
end;

procedure TSCCustomCalendar.ClearClick;
begin
  SetDate(0);
  SetDisplayDate(0);

  if Assigned(FOnClearClick) then FOnClearClick(Self);
  DoClearClick;
end;

procedure TSCCustomCalendar.DoClearClick;
begin
  //
end;

procedure TSCCustomCalendar.DoGetDateStyle(Day, Month: Word; Year: Integer;
  var BkColor, ForeColor: TColor; var FontStyle: TFontStyles);
begin
  //
end;

procedure TSCCustomCalendar.GetDateStyle(Day, Month: Word; Year: Integer;
  var BkColor, ForeColor: TColor; var FontStyle: TFontStyles);
begin
  if Assigned(FOnGetDateStyle) then
    FOnGetDateStyle(Self, Day, Month, Year, BkColor,
      ForeColor, FontStyle);

  DoGetDateStyle(Day, Month, Year, BkColor, ForeColor, FontStyle);
end;

procedure TSCCustomCalendar.IndentChanged;
begin
  FullUpdate;
end;

procedure TSCCustomCalendar.SetIndent(Value: Integer);
begin
  if Value < 0 then
    Value := 0
  else
  if Value > 100 then
    Value := 100;

  inherited SetIndent(Value);
end;

procedure TSCCustomCalendar.SetWeekendDays(Value: TSCWeekDayNames);
begin
  if FWeekendDays <> Value then
  begin
    FWeekendDays := Value;

    if sccoWeekendDays in FOptions then
    begin
      UpdateFontAndColors;
      Invalidate;
    end;  
  end;
end;

procedure TSCCustomCalendar.DoDateClick;
begin
  if Assigned(FOnDateClick) then
    FOnDateClick(Self);
end;

function TSCCustomCalendar.MonthPopupVisible: Boolean;
begin
  Result := (sccoNavigator in FOptions) and (FMonthPopup <> nil) and
    FMonthPopup.HandleAllocated and IsWindowVisible(FMonthPopup.Handle);
end;

procedure TSCCustomCalendar.SystemColorsChanged;
begin
  UpdateFontAndColors;
end;

procedure TSCCustomCalendar.CNKeyDown(var Message: TWMKeyDown);
begin
  if IsMonthPopupShowing and (Message.CharCode = VK_ESCAPE) then
  begin
    HideMonthPopup;
    Exit;
  end;
  inherited;
end;

function TSCCustomCalendar.IsMonthPopupShowing: Boolean;
begin
  Result := (FMonthPopup <> nil) and FMonthPopup.HandleAllocated and
    IsWindowVisible(FMonthPopup.Handle);
end;

procedure TSCCustomCalendar.SpecialDaysChanged(Sender: TObject);
begin
  UpdateSpecialDays;
  UpdateFontAndColors;

  Invalidate;
end;

procedure TSCCustomCalendar.UpdateSpecialDays;
var
  I, J: Integer;
  PC: PSCCalendarCell;
begin
  if (FDaysList <> nil) and (FSpecialDays <> nil) then
    for I := 0 to FDaysList.Count-1 do
    begin
      PC := FDaysList[I];

      PC^.IsSpecial := False;

      for J := 0 to FSpecialDays.Count-1 do
        if (scGetMonthIndex(FSpecialDays[J].Month) = PC^.Month) and
          (FSpecialDays[J].Day = PC^.Day) and ((FSpecialDays[J].Year = -1) or
          (FSpecialDays[J].Year = PC^.Year)) then
        begin
          PC^.IsSpecial := True;
          Break;
        end;
    end;
end;

procedure TSCCustomCalendar.SetSpecialDays(Value: TSCSpecialDays);
begin
  // FSpecialDays.Assign(Value);
end;

procedure TSCCustomCalendar.EnabledChanged;
begin
  FMousePressed := False;
  FFocusedDate  := FDate;
  FDownPart := sccpNowhere;
  FHotPart  := sccpNowhere;

  StopTimer;
  HideMonthPopup;

  UpdateFontAndColors;
  Invalidate;
  inherited EnabledChanged;
end;

procedure TSCCustomCalendar.SetAlignPopupText(Value: Boolean);
begin
  if FAlignPopupText <> Value then
  begin
    FAlignPopupText := Value;
    if FMonthPopup <> nil then
      TSCMonthListPopup(FMonthPopup).AlignText := Value;
  end;
end;

procedure TSCCustomCalendar.SetPopupType(Value: TSCCalendarPopupType);
begin
  if FPopupType <> Value then
  begin
    FPopupType := Value;
    if FMonthPopup <> nil then
      TSCMonthListPopup(FMonthPopup).DisplayType := Value;
  end;
end;

procedure TSCCustomCalendar.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomCalendar then
  begin
    with TSCCustomCalendar(Source) do
    begin
      Self.AlignPopupText := AlignPopupText;
      Self.ButtonFont := ButtonFont;
      Self.ButtonClear := ButtonClear;
      Self.ButtonStyle := ButtonStyle;
      Self.ButtonToday := ButtonToday;
      Self.CalColors := CalColors;
      Self.Date := Date;
      Self.DayCaptions := DayCaptions;
      Self.DayCaptionsFont := DayCaptionsFont;
      Self.Holidays := Holidays;
      Self.ImageHighlight := ImageHighlight;
      Self.ImageSelection := ImageSelection;
      Self.ImageToday := ImageToday;
      Self.Images := Images;
      Self.NavigatorLeft := NavigatorLeft;
      Self.NavigatorRight := NavigatorRight;
      Self.NavigatorFont := NavigatorFont;
      Self.NavigatorGradient := NavigatorGradient;
      Self.NavigatorHeight := NavigatorHeight;
      Self.NavigatorStyle := NavigatorStyle;
      Self.Options := Options;
      Self.PopupBorder := PopupBorder;
      Self.PopupFont := PopupFont;
      Self.PopupType := PopupType;
      Self.SpecialDays := SpecialDays;
      Self.StartOfWeek := StartOfWeek;
      Self.WeekendDays := WeekendDays;
      Self.WeekNumbersFont := WeekNumbersFont;
    end;
  end;
end;

procedure TSCCustomCalendar.SetPopupBorder(Value: TSCControlBorder);
begin
  if FPopupBorder <> Value then
  begin
    FPopupBorder := Value;
    if FMonthPopup <> nil then
      TSCMonthListPopup(FMonthPopup).Border := Value;
  end;
end;

procedure TSCCustomCalendar.CMColorChanged(var Message: TMessage);
begin
  UpdateFontAndColors;
  inherited;
end;

function TSCCustomCalendar.GetPictureRect(P: TPicture): TRect;
var
  H: Integer;
begin
  Result := inherited GetPictureRect(P);
  
  if ShowPicture and (sccoNavigator in FOptions) then
  begin
    H := GetNavigatorHeight;
    if H < 0 then H := 0
    else if FNavigatorStyle = scnFlatWithLine then
      Inc(H);

    Inc(Result.Top, H);
  end;
end;

procedure TSCCustomCalendar.SetNavigatorLeft(Value: TImageIndex);
begin
  if FNavigatorLeft <> Value then
  begin
    FNavigatorLeft := Value;
    if Images <> nil then
      Invalidate;
  end;
end;

procedure TSCCustomCalendar.SetNavigatorRight(Value: TImageIndex);
begin
  if FNavigatorRight <> Value then
  begin
    FNavigatorRight := Value;
    if Images <> nil then
      Invalidate;
  end;
end;

procedure TSCCustomCalendar.SetImageHighlight(Value: TImageIndex);
begin
  if FImageHighlight <> Value then
  begin
    FImageHighlight := Value;
    if Images <> nil then
      Invalidate;
  end;
end;

procedure TSCCustomCalendar.SetImageToday(Value: TImageIndex);
begin
  if FImageToday <> Value then
  begin
    FImageToday := Value;
    if Images <> nil then
      Invalidate;
  end;
end;

procedure TSCCustomCalendar.SetImageSelection(Value: TImageIndex);
begin
  if FImageSelection <> Value then
  begin
    FImageSelection := Value;
    if Images <> nil then
      Invalidate;
  end;
end;

{ TSCCalendarColors }

procedure TSCCalendarColors.Assign(Source: TPersistent);
begin
  if Source is TSCCalendarColors then
  begin
    with TSCCalendarColors(Source) do
    begin
      Self.FDayCaptions := DayCaptions;
      Self.FDaysBackground := DaysBackground;
      Self.FGrayedText := GrayedText;
      Self.FGrayed := Grayed;
      Self.FHideSelection := HideSelection;
      Self.FHideSelectionText := HideSelectionText;
      Self.FHighlight := Highlight;
      Self.FHighlightText := HighlightText;
      Self.FHolidays := Holidays;
      Self.FHolidaysText := HolidaysText;
      Self.FLines := Lines;
      Self.FNavigator := Navigator;
      Self.FNavigatorButtons := NavigatorButtons;
      Self.FNavigatorEnd := NavigatorEnd;
      Self.FNavigatorLine := FNavigatorLine;
      Self.FPopup := FPopup;
      Self.FPopupHighlight := FPopupHighlight;
      Self.FPopupHighlightText := FPopupHighlightText;
      Self.FSelection := FSelection;
      Self.FSelectionText := FSelectionText;
      Self.FSpecialDay := FSpecialDay;
      Self.FSpecialDayText := FSpecialDayText;
      Self.FTodayClearBtn := FTodayClearBtn;
      Self.FTodayRect := TodayRect;
      Self.FWeekendDays := FWeekendDays;
      Self.FWeekendDaysText := FWeekendDaysText;
      Self.FWeekNumbers := WeekNumbers;
    end;

    DoChange;
  end else
    inherited Assign(Source);
end;

constructor TSCCalendarColors.Create(AOwner: TControl);
begin
  inherited Create;
  FOwner := AOwner;

  FDayCaptions := clNone;
  FDaysBackground := clNone;
  FGrayed := clNone;
  FGrayedText := clGrayText;
  FHideSelection := clInactiveCaption;
  FHideSelectionText := clInactiveCaptionText;
  FHighlight := clHighlight;
  FHighlightText := clHighlightText;
  FHolidays := clNone;
  FHolidaysText := clRed;
  FLines := clBtnShadow;
  FNavigator := clBtnFace;
  FNavigatorButtons := clWindowText;
  FNavigatorEnd := clBtnHighlight;
  FNavigatorLine := clNone;
  FPopup := clWindow;
  FPopupHighlight := clWindowText;
  FPopupHighlightText := clWindow;
  FSelection := clPurple;
  FSelectionText := clWhite;
  FSpecialDay := clNone;
  FSpecialDayText := clBlue;
  FTodayClearBtn := clBtnFace;
  FTodayRect := clMaroon;
  FWeekendDays := clNone;
  FWeekendDaysText := clHighlight;
  FWeekNumbers := clNone;
end;

procedure TSCCalendarColors.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TSCCalendarColors.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCCalendarColors.SetDayCaptions(Value: TColor);
begin
  if FDayCaptions <> Value then
  begin
    FDayCaptions := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetDaysBackground(Value: TColor);
begin
  if FDaysBackground <> Value then
  begin
    FDaysBackground := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetGrayed(Value: TColor);
begin
  if FGrayed <> Value then
  begin
    FGrayed := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetGrayedText(Value: TColor);
begin
  if FGrayedText <> Value then
  begin
    FGrayedText := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetHideSelection(Value: TColor);
begin
  if FHideSelection <> Value then
  begin
    FHideSelection := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetHideSelectionText(Value: TColor);
begin
  if FHideSelectionText <> Value then
  begin
    FHideSelectionText := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetHighlight(Value: TColor);
begin
  if FHighlight <> Value then
  begin
    FHighlight := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetHighlightText(Value: TColor);
begin
  if FHighlightText <> Value then
  begin
    FHighlightText := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetHolidays(Value: TColor);
begin
  if FHolidays <> Value then
  begin
    FHolidays := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetHolidaysText(Value: TColor);
begin
  if FHolidaysText <> Value then
  begin
    FHolidaysText := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetLines(Value: TColor);
begin
  if FLines <> Value then
  begin
    FLines := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetNavigator(Value: TColor);
begin
  if FNavigator <> Value then
  begin
    FNavigator := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetNavigatorButtons(Value: TColor);
begin
  if FNavigatorButtons <> Value then
  begin
    FNavigatorButtons := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetNavigatorEnd(Value: TColor);
begin
  if FNavigatorEnd <> Value then
  begin
    FNavigatorEnd := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetNavigatorLine(Value: TColor);
begin
  if FNavigatorLine <> Value then
  begin
    FNavigatorLine := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetSelection(Value: TColor);
begin
  if FSelection <> Value then
  begin
    FSelection := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetSelectionText(Value: TColor);
begin
  if FSelectionText <> Value then
  begin
    FSelectionText := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetSpecialDay(Value: TColor);
begin
  if FSpecialDay <> Value then
  begin
    FSpecialDay := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetSpecialDayText(Value: TColor);
begin
  if FSpecialDayText <> Value then
  begin
    FSpecialDayText := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetTodayClearBtn(Value: TColor);
begin
  if FTodayClearBtn <> Value then
  begin
    FTodayClearBtn := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetTodayRect(Value: TColor);
begin
  if FTodayRect <> Value then
  begin
    FTodayRect := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetWeekendDays(Value: TColor);
begin
  if FWeekendDays <> Value then
  begin
    FWeekendDays := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetWeekendDaysText(Value: TColor);
begin
  if FWeekendDaysText <> Value then
  begin
    FWeekendDaysText := Value;
    DoChange;
  end;
end;

procedure TSCCalendarColors.SetWeekNumbers(Value: TColor);
begin
  if FWeekNumbers <> Value then
  begin
    FWeekNumbers := Value;
    DoChange;
  end;
end;

{ TSCHoliday }

procedure TSCHoliday.Assign(Source: TPersistent);
begin
  if Source is TSCHoliday then
  begin
    with TSCHoliday(Source) do
    begin
      Self.FDay := Day;
      Self.FMonth := Month;
      Self.FYear := Year; 
      Self.FName := Name;
      Self.FBackColor := BackColor;
      Self.FFontColor := FontColor;
      Self.FFontStyles := FontStyles;
    end;

    Changed(True);
  end else
    inherited Assign(Source);
end;

constructor TSCHoliday.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FDay := 1;
  FMonth := scmJanuary;
  FYear := -1;
  FBackColor := clNone;
  FFontColor := clNone;
  FFontStyles := [];
end;

function TSCHoliday.GetDisplayName: string;
begin
  Result := FName;
  if Result = '' then Result := inherited GetDisplayName;
end;

procedure TSCHoliday.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Changed(True);
  end;
end;

procedure TSCHoliday.SetDay(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 31 then Value := 31;

  if FDay <> Value then
  begin
    FDay := Value;
    Changed(True);
  end;
end;

procedure TSCHoliday.SetFontColor(Value: TColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    Changed(True);
  end;
end;

procedure TSCHoliday.SetFontStyles(Value: TFontStyles);
begin
  if FFontStyles <> Value then
  begin
    FFontStyles := Value;
    Changed(True);
  end;
end;

procedure TSCHoliday.SetMonth(Value: TSCMonth);
begin
  if FMonth <> Value then
  begin
    FMonth := Value;
    Changed(True);
  end;
end;

procedure TSCHoliday.SetName(const Value: String);
begin
  if FName <> Value then
  begin
    FName := Value;
    Changed(True);
  end;
end;

procedure TSCHoliday.SetYear(Value: Integer);
begin
  if Value < -1 then Value := -1;
  if Value > 65536 then Value := 65536;

  if FYear <> Value then
  begin
    FYear := Value;
    Changed(True);
  end;
end;

{ TSCHolidays }

function TSCHolidays.Add: TSCHoliday;
begin
  Result := TSCHoliday(inherited Add);
end;

constructor TSCHolidays.Create(AOwner: TSCCustomControl);
begin
  inherited Create(TSCHoliday);
  FOwner := AOwner;
end;

function TSCHolidays.GetItem(Index: Integer): TSCHoliday;
begin
  Result := TSCHoliday(inherited GetItem(Index));
end;

function TSCHolidays.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCHolidays.SetItem(Index: Integer; Value: TSCHoliday);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCHolidays.Update(Item: TCollectionItem);
begin
  if FOwner is TSCCustomCalendar then
    TSCCustomCalendar(FOwner).HolidaysChanged(Self);
end;

{ TSCSpecialDay }

procedure TSCSpecialDay.Assign(Source: TPersistent);
begin
  if Source is TSCSpecialDay then
  begin
    with TSCSpecialDay(Source) do
    begin
      Self.FDay := Day;
      Self.FMonth := Month;
      Self.FYear := Year;
      Self.FName := Name;
      Self.FBackColor := BackColor;
      Self.FFontColor := FontColor;
      Self.FFontStyles := FontStyles;
    end;

    Changed(True);
  end else
    inherited Assign(Source);
end;

constructor TSCSpecialDay.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FDay := 1;
  FMonth := scmJanuary;
  FYear := -1;
  FBackColor := clNone;
  FFontColor := clNone;
  FFontStyles := [];
end;

function TSCSpecialDay.GetDisplayName: string;
begin
  Result := FName;
  if Result = '' then Result := inherited GetDisplayName;
end;

procedure TSCSpecialDay.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Changed(True);
  end;
end;

procedure TSCSpecialDay.SetDay(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 31 then Value := 31;

  if FDay <> Value then
  begin
    FDay := Value;
    Changed(True);
  end;
end;

procedure TSCSpecialDay.SetFontColor(Value: TColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    Changed(True);
  end;
end;

procedure TSCSpecialDay.SetFontStyles(Value: TFontStyles);
begin
  if FFontStyles <> Value then
  begin
    FFontStyles := Value;
    Changed(True);
  end;
end;

procedure TSCSpecialDay.SetMonth(Value: TSCMonth);
begin
  if FMonth <> Value then
  begin
    FMonth := Value;
    Changed(True);
  end;
end;

procedure TSCSpecialDay.SetName(const Value: String);
begin
  if FName <> Value then
  begin
    FName := Value;
    Changed(True);
  end;
end;

procedure TSCSpecialDay.SetYear(Value: Integer);
begin
  if Value < -1 then Value := -1;
  if Value > 65536 then Value := 65536;

  if FYear <> Value then
  begin
    FYear := Value;
    Changed(True);
  end;
end;

{ TSCSpecialDays }

function TSCSpecialDays.Add: TSCSpecialDay;
begin
  Result := TSCSpecialDay(inherited Add);
end;

constructor TSCSpecialDays.Create(AOwner: TSCCustomControl);
begin
  inherited Create(TSCSpecialDay);
  FOwner := AOwner;
end;

function TSCSpecialDays.GetItem(Index: Integer): TSCSpecialDay;
begin
  Result := TSCSpecialDay(inherited GetItem(Index));
end;

function TSCSpecialDays.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCSpecialDays.SetItem(Index: Integer; Value: TSCSpecialDay);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCSpecialDays.Update(Item: TCollectionItem);
begin
  if FOwner is TSCCustomCalendar then
    TSCCustomCalendar(FOwner).SpecialDaysChanged(Self);
end;

{ TSCCalendarBorderProps }

constructor TSCCalendarBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccbFlat;
  Color := clWindow;
end;

{ TSCMonthListPopup }

procedure TSCMonthListPopup.CMFontChanged(var Message: TMessage);
var
  R: TRect;
  B: Integer;
begin
  inherited;
  Canvas.Font.Assign(Font);

  with TSCCustomCalendar(Parent) do
  begin
    R := GetYearMonthRect(True);

    FItemHeight := Self.Canvas.TextHeight('Oq') + 4;
    if FItemHeight < 0 then FItemHeight := 0;

    B := 2*(GetBorderSize + BorderWidth);

    Self.Width := B + (R.Right - R.Left);
    Self.Height := B + (7*FItemHeight);
  end;
end;

constructor TSCMonthListPopup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlignText := False;
  FDisplayType := sccpMonthYear;
  FStartDate := SC_NullDate;
  FHighlight := clWindowText;
  FHighlightText := clWindow;
end;

procedure TSCMonthListPopup.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP and not WS_BORDER;
    ExStyle := WS_EX_TOPMOST;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
  end;
end;

function TSCMonthListPopup.GetDate: TDateTime;
var
  Year, Month, Day: Word;
begin
  if ItemIndex = -1 then
    Result := SC_NullDate
  else begin
    DecodeDate(StartDate, Year, Month, Day);

    if FDisplayType = sccpMonthYear then
      IterateMonth(Year, Month, ItemIndex)
    else
      Inc(Year, ItemIndex);

    Result := EncodeDate(Year, Month, 1);
  end;  
end;

procedure TSCMonthListPopup.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewTimerId: LongInt;
  Delta, Sign: Integer;
begin
  if PtInRect(ClientRect, Point(X, Y)) then
  begin
    StopTimer;
    ItemIndex := Y div ItemHeight;
  end else
  begin
    ItemIndex := -1;

    if Y < 0 then Delta := Y
    else
    if Y >= ClientHeight then
      Delta := 1 + Y - ClientHeight
    else begin
      StopTimer;
      Exit;
    end;

    Sign := Delta div Abs(Delta);
    if FDisplayType = sccpMonthYear then
      NewTimerId := Sign + Delta div 12
    else
      NewTimerId := Sign + Delta;

    if Abs(NewTimerId) > 4 then NewTimerId := Sign * 4;

    NewTimerId := NewTimerId + 5;

    if (FTimer = 0) or (NewTimerId <> FTimerId) then
    begin
      FTimerId := NewTimerId;
      StartTimer;
    end;
  end;
end;

procedure TSCMonthListPopup.Paint;
var
  I: Integer;
  S: string;
  R, R2: TRect;
  Cl, FnCl: TColor;
  Year, Month, Day: Word;
begin
  R := ClientRect;
  with Canvas do
  begin
    Brush.Color := Self.Color;
    FillRect(R);
  end;

  DecodeDate(StartDate, Year, Month, Day);
  with R do
  begin
    Left := 0;
    Top := 0;
    Right := ClientWidth;
    Bottom := ItemHeight;
  end;

  for I := 0 to 6 do
  begin
    Cl := Self.Color;
    FnCl := Self.Font.Color;

    if I = ItemIndex then
    begin
      Cl := Highlight;
      FnCl := HighlightText;
    end;

    with Canvas do
    begin
      Font.Color := FnCl;
      Brush.Color := Cl;

      FillRect(R);

      if FDisplayType = sccpYear then
      begin
        S := IntToStr(Year);
        DrawText(Handle, PChar(S), Length(S), R,
          DT_SINGLELINE or DT_NOCLIP or DT_CENTER or DT_VCENTER);
      end else
      if not FAlignText then
      begin
        S := {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}LongMonthNames[Month] + ' ' + IntToStr(Year);
        DrawText(Handle, PChar(S), Length(S), R,
          DT_SINGLELINE or DT_NOCLIP or DT_CENTER or DT_VCENTER);
      end else
      begin
        R2 := R;
        R2.Right := R2.Left + 3*((R2.Right - R2.Left) div 5) - (TextWidth(' ') div 2);
        if not IsRectEmpty(R2) then
        begin
          S := {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}LongMonthNames[Month];
          DrawText(Handle, PChar(S), Length(S), R2,
            DT_SINGLELINE or DT_NOCLIP or DT_RIGHT or DT_VCENTER);
        end;

        R2 := R;
        R2.Left := R2.Right - 2*((R2.Right - R2.Left) div 5) + (TextWidth(' ') div 2);
        if not IsRectEmpty(R2) then
        begin
          S := IntToStr(Year);
          DrawText(Handle, PChar(S), Length(S), R2,
            DT_SINGLELINE or DT_NOCLIP or DT_LEFT or DT_VCENTER);
        end;
      end;
    end;

    if FDisplayType = sccpMonthYear then
      IncMonth(Year, Month)
    else
      Inc(Year);

    OffsetRect(R, 0, ItemHeight);
  end;
end;

procedure TSCMonthListPopup.ScrollMonths;
var
  Year, Month, Day: Word;
begin
  DecodeDate(StartDate, Year, Month, Day);
  IterateMonth(Year, Month, 2 * Integer(FTimerId > 5) - 1);
  StartDate := EncodeDate(Year, Month, 1);
end;

procedure TSCMonthListPopup.ScrollYears;
var
  Year, Month, Day: Word;
begin
  DecodeDate(StartDate, Year, Month, Day);
  Inc(Year, 2 * Integer(FTimerId > 5) - 1);
  StartDate := EncodeDate(Year, Month, 1);
end;

procedure TSCMonthListPopup.SetAlignText(Value: Boolean);
begin
  if FAlignText <> Value then
  begin
    FAlignText := Value;
    Invalidate;
  end;
end;

procedure TSCMonthListPopup.SetDisplayType(Value: TSCCalendarPopupType);
begin
  if FDisplayType <> Value then
  begin
    FDisplayType := Value;
    Invalidate;
  end;
end;

procedure TSCMonthListPopup.SetItemIndex(Value: Integer);
var
  PrevItemIndex: Integer;

  procedure InvalidateItemRect(Index: Integer);
  var
    R: TRect;
  begin
    if Index = -1 then Exit;
    with R do
    begin
      Left := 0;
      Top  := Index * ItemHeight;
      Right := ClientWidth;
      Bottom := Top + ItemHeight;
    end;
    InvalidateRect(Handle, @R, False);
  end;

begin
  if FItemIndex <> Value then
  begin
    PrevItemIndex := FItemIndex;
    FItemIndex := Value;
    InvalidateItemRect(PrevItemIndex);
    InvalidateItemRect(FItemIndex);
  end;
end;

procedure TSCMonthListPopup.SetStartDate(Value: TDateTime);
begin
  if FStartDate <> Value then
  begin
    FStartDate := Value;
    Repaint;
  end;
end;

procedure TSCMonthListPopup.StartTimer;
const
  ScrollIntervals: array[1..4] of LongInt = (500, 250, 100, 50);
begin
  if HandleAllocated then
  begin
    StopTimer;
    FTimer := SetTimer(Handle, FTimerId, ScrollIntervals[Abs(FTimerId - 5)], nil);

    if FDisplayType = sccpMonthYear then
      ScrollMonths
    else
      ScrollYears;
  end;
end;

procedure TSCMonthListPopup.StopTimer;
begin
  if FTimer > 0 then
  begin
    KillTimer(Handle, FTimerId);
    FTimer := 0;
  end;
end;

procedure TSCMonthListPopup.WMDestroy(var Message: TMessage);
begin
  StopTimer;
  inherited;
end;

procedure TSCMonthListPopup.WMTimer(var Message: TWMTimer);
begin
  inherited;
  if HandleAllocated and (FTimer > 0) and (Message.TimerID = FTimerID) then
  begin
    StartTimer;
    if FDisplayType = sccpMonthYear then
      ScrollMonths
    else
      ScrollYears;
  end;
end;

{ TSCDropdownCalendar }

procedure TSCDropdownCalendar.ActivateForm;
var
  F: TCustomForm;
begin
  if FPopupbox <> nil then
  begin
    F := GetParentForm(FPopupbox);
    if (F <> nil) and F.HandleAllocated then
      SendMessage(F.Handle, WM_NCACTIVATE, Longint(True), 0);
  end;
end;

procedure TSCDropdownCalendar.Cancel;
begin
  PostMessage(Handle, CM_CANCEL, 0, 0);
end;

procedure TSCDropdownCalendar.CMFocusChanged(var Message: TCMFocusChanged);
begin
  ActivateForm;
  inherited;
end;

constructor TSCDropdownCalendar.Create(AOwner: TComponent);
begin
  inherited;
  BlendColor := False;
  Visible := False;
  FCancelPopup := False;
  Parent := GetParentForm(TControl(AOwner));
end;

procedure TSCDropdownCalendar.CreateParams(var Params: TCreateParams);
begin
  inherited;

  with Params do
  begin
    Style := WS_POPUP;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
  end;
end;

function TSCDropdownCalendar.IsChildHandle(AHandle: HWND): Boolean;
begin
  Result := False;
  while AHandle <> 0 do
  begin
    Result := AHandle = Handle;
    if Result then Exit;

    AHandle := GetParent(AHandle);
  end;
end;

procedure TSCDropdownCalendar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = FPopupbox) then
  begin
    FPopupbox := nil;
    if FInPopup then
      Cancel;
  end;
end;

procedure TSCDropdownCalendar.Popup(C: TSCCustomPopupCalendar);
var
  Msg: TMsg;
  P: TPoint;
  W, H: Integer;

  procedure InitiatePopup;
  begin
    FPreparingPopup := True;
    try
      Visible := False;
      
      P := Point(0, 0);
      if FPopupbox.Parent <> nil then
      begin
        P := Point(FPopupbox.Left, FPopupbox.Top + FPopupbox.Height);
        P := Self.ScreenToClient(FPopupbox.Parent.ClientToScreen(P));
      end;

      H := Self.Height;
      W := Self.Width;

      Parent := FPopupbox;
      Windows.SetFocus(Handle);
    finally
      FPreparingPopup := False;
    end;
  end;

  procedure FinalizePopup;
  begin
    FPreparingPopup := True;
    try
      try
        SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOACTIVATE or
          SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE);

        Visible := False;
      finally
        Parent := nil;
      end;
    finally
      FPreparingPopup := False;
    end;
  end;

  procedure DoPopup;
  begin
    FPopupbox.SetDropState(sccsDropped);

    try
      while not FCancelPopup and Visible and
        Application.Active and not Application.Terminated do
      begin
        if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then
        begin
          case Msg.message of
            WM_NCACTIVATE:
            begin
              if (Msg.hwnd = Self.Handle) or IsChildHandle(Msg.hwnd) then
                PeekMessage(Msg, 0, 0, 0, PM_REMOVE)
              else
                Break;
            end;
            WM_MOUSEACTIVATE:
            begin
              if (Msg.hwnd = Self.Handle) or IsChildHandle(Msg.hwnd) then
                PeekMessage(Msg, 0, 0, 0, PM_REMOVE)
              else
                Break;
            end;
            WM_SYSCOMMAND:
            begin
              if Msg.WParam = 61448 then
                inherited
              else
                Cancel;
            end;
            WM_NCLBUTTONDOWN, WM_NCRBUTTONDOWN,
            WM_NCMBUTTONDOWN, WM_LBUTTONDOWN,
            WM_MBUTTONDOWN,   WM_RBUTTONDOWN,
            WM_LBUTTONDBLCLK, WM_RBUTTONDBLCLK,
            WM_MBUTTONDBLCLK:
            begin
              if (Msg.hwnd <> Self.Handle) and not IsChildHandle(Msg.hwnd) then
              begin
                if Msg.hwnd = FPopupbox.Handle then
                  PeekMessage(Msg, 0, 0, 0, PM_REMOVE);

                Break;
              end;
            end;
            WM_KEYFIRST..WM_KEYLAST:
            begin
              if (Msg.message = WM_KEYDOWN) and (Msg.wParam = VK_ESCAPE) and
                 (Msg.hwnd = Self.Handle) then
              begin
                PeekMessage(Msg, 0, Msg.message, Msg.message, PM_REMOVE);

                if IsMonthPopupShowing then
                begin
                  HideMonthPopup;
                  Continue;
                end;

                Exit;
              end;

              if (Msg.message = WM_SYSKEYDOWN) and (Msg.wParam = VK_RETURN) then
                PeekMessage(Msg, 0, Msg.message, Msg.message, PM_REMOVE);
            end;
            WM_KILLFOCUS, CM_CANCEL:
              Exit;
            CM_DEACTIVATE, WM_ACTIVATEAPP:
              Break;
          end;
        end;

        Application.HandleMessage;
      end;
    finally
      FinalizePopup;
    end;
  end;

begin
  if FInPopup or (C = nil) then
    Exit;

  FCancelPopup := False;

  FPopupbox := C;
  if FPopupbox <> nil then
    FPopupbox.FreeNotification(Self);

  InitiatePopup;

  FInPopup := True;
  try
    FPreparingPopup := True;
    try
      SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or
        SWP_NOACTIVATE or SWP_SHOWWINDOW);

      Visible := True;

      if FPopupbox <> nil then
        with FPopupbox do
        begin
          AfterDropDown;
          if Assigned(OnDropDown) then
            OnDropDown(FPopupbox);
        end;

      if CanFocus then
        SetFocus;
    finally
      FPreparingPopup := False;
    end;

    DoPopup;

    if FPopupbox <> nil then
      with FPopupbox do
      begin
        FPopupbox.SetDropState(sccsClosing);
        SetFocus;

        AfterCloseUp;
        DoCloseUp;
      end;
  finally
    if FPopupbox <> nil then
      FPopupbox.SetDropState(sccsDefault);

    FCancelPopup := False;
    FInPopup := False;
    FPopupbox := nil;

    Free;
  end;
end;

procedure TSCDropdownCalendar.WMActivate(var Message: TWMActivate);
begin
  inherited;
  ActivateForm;
end;

procedure TSCDropdownCalendar.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    CM_CANCEL:
    begin
      Message.Result := 1;

      FCancelPopup := True;
      Hide;
    end;
    WM_NCACTIVATE:
    begin
      if FPreparingPopup then
        Message.Result := 0
      else
        inherited;
    end;
    WM_MOUSEACTIVATE:
    begin
      if FPreparingPopup then
        Message.Result := MA_NOACTIVATE
      else
        inherited;
    end;
    else
      inherited;
  end;    
end;

{ TSCCustomPopupCalendar }

procedure TSCCustomPopupCalendar.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomPopupCalendar then
  begin
    with TSCCustomPopupCalendar(Source) do
    begin
      Self.CalendarProps := CalendarProps;
      Self.Date := Date;
      Self.DateValidation := DateValidation;
      Self.DisplayFormat := DisplayFormat;
      Self.SaveTime := SaveTime;
    end;
  end;
end;

procedure TSCCustomPopupCalendar.BeforeExit;
begin
  inherited BeforeExit;
  UpdateDateFromText;
end;

function TSCCustomPopupCalendar.CanDropDown: Boolean;
begin
  Result := not IsDesigning and
    ((FCalendar = nil) or not TSCDropdownCalendar(FCalendar).InPopup);
end;

procedure TSCCustomPopupCalendar.ClearButtonClick(Sender: TObject);
begin
  CloseUp;

  SetDate(0);

  Application.ProcessMessages;
  if Assigned(FOnClearClick) then
    FOnClearClick(Self);
end;

procedure TSCCustomPopupCalendar.CloseUp;
begin
  if (FCalendar <> nil) and TSCDropdownCalendar(FCalendar).InPopup then
    TSCDropdownCalendar(FCalendar).Cancel;
end;

procedure TSCCustomPopupCalendar.CMWinIniChange(var Message: TWMWinIniChange);
begin
  inherited;
  if FDate <> 0 then SetText(DateTimeToStr(FDate));
end;

constructor TSCCustomPopupCalendar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  IsDropDown := False;

  FDate := 0;
  FTime := 0;
  FDateValidation := scdvSetToNull;
  FSaveTime := True;

  FCalendarProps := TSCPopupCalendarProps.Create(Self);
end;

procedure TSCCustomPopupCalendar.DateChanged;
begin
  DoDateChange;
  if Assigned(FOnDateChange) then
    FOnDateChange(Self);
end;

destructor TSCCustomPopupCalendar.Destroy;
begin
  FCalendarProps.Free;
  if FCalendar <> nil then
  begin
    FCalendar.Free;
    FCalendar := nil;
  end;

  inherited Destroy;
end;

procedure TSCCustomPopupCalendar.DoDateChange;
begin
  Change;
end;

procedure TSCCustomPopupCalendar.DoInternalChange;
begin
  if not EditingText then
    UpdateDateFromText;
end;

procedure TSCCustomPopupCalendar.DoValidationError(var ADate: TDateTime;
  var ErrorText: String; var RaiseError: Boolean);
begin
  //
end;

function TSCCustomPopupCalendar.DoWantKeyDown(var Key: Word;
  Shift: TShiftState): Boolean;
begin
  if (Key = VK_ESCAPE) and (FCalendar <> nil) and
    FCalendar.HandleAllocated and IsWindowVisible(FCalendar.Handle) then
  begin
    Result := FCalendar.Focused or TSCDropdownCalendar(FCalendar).IsMonthPopupShowing;
    if Result then
      Exit;
  end;

  Result := inherited DoWantKeyDown(Key, Shift);
end;

procedure TSCCustomPopupCalendar.DropDownPopupbox;
begin
  if CanDropDown and AllowDropDown then
  begin
    UpdateDateFromText;

    if FCalendar = nil then
      FCalendar := TSCDropdownCalendar.Create(Self);

    PrepareDropWindow;

    Windows.SetFocus(Handle);
    if GetFocus <> Handle then
      Exit;

    SetDropState(sccsDropping);
    SetDroppedDownFlag(True);
    try
      FCalendar.FreeNotification(Self);
      TSCDropdownCalendar(FCalendar).Popup(Self);
    finally
      SetDropState(sccsDefault);
      SetDroppedDownFlag(False);

      if FCalendar <> nil then
      begin
        FCalendar.OnClearClick := nil;
        FCalendar.OnDateClick := nil;
        FCalendar.OnGetDateStyle := nil;

        FreeAndNil(FCalendar);
      end;
    end;
  end;
end;

function TSCCustomPopupCalendar.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCDropDownButtonProps;
end;

procedure TSCCustomPopupCalendar.GetDateStyle(Sender: TObject; Day, Month: Word;
  Year: Integer; var BkColor, ForeColor: TColor; var FontStyle: TFontStyles);
begin
  if Assigned(FOnGetDateStyle) then
    FOnGetDateStyle(Self, Day, Month, Year, BkColor,
      ForeColor, FontStyle);
end;

function TSCCustomPopupCalendar.GetDescriptionColor: TColor;
begin
  Result := inherited GetDescriptionColor;
  if (IsDesigning or not Focused) and (FDisplayFormat <> '') then
    Result := Self.Font.Color;
end;

function TSCCustomPopupCalendar.GetDescriptionText: String;
var
  D: TDateTime;
begin
  if (IsDesigning or not HasFocus) and (FDisplayFormat <> '') then
  begin
    D := FDate;
    if D = 0 then
    begin
      Result := Text;
      if Result <> '' then
        D := scStrToDateTime(Result, D, scdvDontUpdate);

      if D = 0 then
        Exit;
    end;

    try
      Result := FormatDateTime(FDisplayFormat, D);
    except
      Result := '';
    end;
  end else
    Result := inherited GetDescriptionText;
end;

function TSCCustomPopupCalendar.GetDropDownWindow: TWinControl;
begin
  Result := FCalendar;
end;

function TSCCustomPopupCalendar.GetDroppedDown: Boolean;
begin
  Result := GetDroppedDownFlag and
   (FCalendar <> nil) and TSCDropdownCalendar(FCalendar).InPopup;
end;

function TSCCustomPopupCalendar.GetPopupStyle: TSCEditStyle;
begin
  Result := FCalendarProps.BorderStyle;
end;

function TSCCustomPopupCalendar.IsDescription: Boolean;
begin
  Result := inherited IsDescription or
    ((FDisplayFormat <> '') and (IsDesigning or not Focused));
end;

procedure TSCCustomPopupCalendar.KeyDown(var Key: Word; Shift: TShiftState);
var
  D: TDateTime;
begin
  case Key of
    VK_RETURN:
    begin
      Key := 0;
      UpdateDateFromText;
    end;
    VK_PRIOR:
    begin
      Key := 0;
      UpdateDateFromText;

      D := FDate;
      if D = 0 then D := SysUtils.Date;

      if ssShift in Shift then
        SetDate(scAdjustDate(D, 1, 0, 0))
      else
        SetDate(scAdjustDate(D, 0, 1, 0));
    end;
    VK_NEXT:
    begin
      Key := 0;
      UpdateDateFromText;

      D := FDate;
      if D = 0 then D := SysUtils.Date;

      if ssShift in Shift then
        SetDate(scAdjustDate(D, -1, 0, 0))
      else
        SetDate(scAdjustDate(D, 0, -1, 0));
    end;
    VK_UP:
    begin
      Key := 0;
      UpdateDateFromText;

      D := FDate;
      if D = 0 then D := SysUtils.Date;

      SetDate(scAdjustDate(D, 0, 0, 1));
    end;
    VK_DOWN:
    begin
      Key := 0;
      UpdateDateFromText;

      D := FDate;
      if D = 0 then D := SysUtils.Date;

      SetDate(scAdjustDate(D, 0, 0, -1));
    end;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomPopupCalendar.KeyPress(var Key: Char);
var
  D: TDateTime;
begin
  if Key <> {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DateSeparator then
  begin
    D := FDate;
    if D = 0 then D := SysUtils.Date;

    case Key of
      '+':
      begin
        Key := #0;
        SetDate(scAdjustDate(D, 0, 0, 1));
      end;
      '-':
      begin
        Key := #0;
        SetDate(scAdjustDate(D, 0, 0, -1));
      end;
    end;
  end;

  inherited KeyPress(Key);
end;

procedure TSCCustomPopupCalendar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = FCalendar) then
    FCalendar := nil;
end;

procedure TSCCustomPopupCalendar.PopupDateChanged(Sender: TObject);
var
  D: TDateTime;
begin
  if FCalendar <> nil then
  begin
    D := Trunc(FCalendar.Date);
    if FSaveTime then D := Trunc(D) + FTime;

    CloseUp;
    SetDate(D);
  end;
end;

procedure TSCCustomPopupCalendar.PrepareDropWindow;
begin
  if FCalendar = nil then
    Exit;

  BeforePrepareDropWindow;

  with TSCDropdownCalendar(FCalendar) do
  begin
    Date := Self.FDate;
    AlignPopupText := Self.FCalendarProps.AlignPopupText;
    ButtonFont  := Self.FCalendarProps.ButtonFont;
    ButtonClear := Self.FCalendarProps.ButtonClear;
    ButtonStyle := Self.FCalendarProps.ButtonStyle;
    ButtonToday := Self.FCalendarProps.ButtonToday;
    CalColors := Self.FCalendarProps.CalColors;
    DayCaptions := Self.FCalendarProps.DayCaptions;
    DayCaptionsFont := Self.FCalendarProps.DayCaptionsFont;
    Holidays := Self.FCalendarProps.Holidays;
    Images := Self.Images;
    ImageHighlight := Self.FCalendarProps.ImageHighlight;
    ImageSelection := Self.FCalendarProps.ImageSelection;
    ImageToday := Self.FCalendarProps.ImageToday;
    Indent := Self.FCalendarProps.Indent;
    NavigatorFont := Self.FCalendarProps.NavigatorFont;
    NavigatorLeft := Self.FCalendarProps.NavigatorLeft;
    NavigatorRight := Self.FCalendarProps.NavigatorRight;
    NavigatorGradient := Self.FCalendarProps.NavigatorGradient;
    NavigatorHeight := Self.FCalendarProps.NavigatorHeight;
    NavigatorStyle := Self.FCalendarProps.NavigatorStyle;
    Options := Self.FCalendarProps.Options;
    PopupBorder := Self.FCalendarProps.PopupBorder;
    PopupFont := Self.FCalendarProps.PopupFont;
    PopupType := Self.FCalendarProps.PopupType;
    StartOfWeek := Self.FCalendarProps.StartOfWeek;
    WeekendDays := Self.FCalendarProps.WeekendDays;
    WeekNumbersFont := Self.FCalendarProps.WeekNumbersFont;
  end;

  ApplyPopupBorder(TSCCustomControl(FCalendar));
  CalcPosition(FCalendar);

  with TSCDropdownCalendar(FCalendar) do
  begin
    OnClearClick := Self.ClearButtonClick;
    OnDateClick := Self.PopupDateChanged;
    OnGetDateStyle := Self.GetDateStyle;
  end;
end;

procedure TSCCustomPopupCalendar.SetCalendarProps(Value: TSCPopupCalendarProps);
begin
  FCalendarProps.Assign(Value);
end;

procedure TSCCustomPopupCalendar.SetDate(Value: TDateTime);
begin
  if FDate <> Value then
  begin
    FDate := Value;
    FTime := FDate - Trunc(FDate);

    if FDate = 0 then
      SetText('')
    else
      SetText(DateTimeToStr(FDate));

    DateChanged;
  end;
end;

procedure TSCCustomPopupCalendar.SetDisplayFormat(Value: TCaption);
begin
  if FDisplayFormat <> Value then
  begin
    FDisplayFormat := Value;
    if IsDesigning or not Focused then
      Invalidate;
  end;
end;

procedure TSCCustomPopupCalendar.UpdateDateFromText;
var
  S: String;
begin
  S := '';
  if FDate <> 0 then S := DateTimeToStr(FDate);

  if S <> Text then
  begin
    try
      SetDate(scStrToDateTime(Text, FDate, DateValidation));

      if DateValidation = scdvDontUpdate then
      begin
        S := '';
        if FDate <> 0 then S := DateTimeToStr(FDate);
        SetText(S);
      end;
    except
      on E: Exception do
      begin
        if (DateValidation = scdvRaiseError) and not IsDesigning then
          SetFocus;

        ValidationError(E.Message);
      end;
    end;
  end;
end;

procedure TSCCustomPopupCalendar.ValidationError(ErrorTxt: String);
var
  S: String;
  ADate: TDateTime;
  RaiseError: Boolean;
begin
  ADate := FDate;
  RaiseError := True;

  S := Copy(ErrorTxt, 1, Length(ErrorTxt));
  DoValidationError(ADate, S, RaiseError);

  if RaiseError then
  begin
    if S = '' then S := ErrorTxt;
    raise Exception.Create(S);
  end else
  begin
    if FDate <> ADate then
      SetDate(ADate)
    else begin
      if ADate = 0 then
        SetText('')
      else
        SetText(DateTimeToStr(ADate));
    end;
  end;
end;

procedure TSCCustomPopupCalendar.WndProc(var Message: TMessage);
var
  Shift: TShiftState;
begin
  case Message.Msg of
    WM_KEYDOWN, WM_SYSKEYDOWN, WM_CHAR:
    begin
      with TWMKey(Message) do
      begin
        Shift := KeyDataToShiftState(KeyData);
        if (Message.Msg <> WM_CHAR) and DoDropDownKeys(CharCode, Shift) then
          Exit;
      end;
    end;
  end;

  inherited;
end;

{ TSCPopupCalendarProps }

procedure TSCPopupCalendarProps.Assign(Source: TPersistent);
begin
  if Source is TSCPopupCalendarProps then
  begin
    with TSCPopupCalendarProps(Source) do
    begin
      Self.AlignPopupText := AlignPopupText;
      Self.BorderStyle := BorderStyle;
      Self.ButtonFont  := ButtonFont;
      Self.ButtonClear := ButtonClear;
      Self.ButtonStyle := ButtonStyle;
      Self.ButtonToday := ButtonToday;
      Self.CalColors   := CalColors;
      Self.DayCaptions := DayCaptions;
      Self.DayCaptionsFont := DayCaptionsFont;
      Self.Font := Font;
      Self.Holidays := Holidays;
      Self.Indent := Indent;
      Self.ImageHighlight := ImageHighlight;
      Self.ImageSelection := ImageSelection;
      Self.ImageToday := ImageToday;
      Self.NavigatorFont := NavigatorFont;
      Self.NavigatorLeft := NavigatorLeft;
      Self.NavigatorRight := NavigatorRight;
      Self.NavigatorGradient := NavigatorGradient;
      Self.NavigatorHeight := NavigatorHeight;
      Self.NavigatorStyle := NavigatorStyle;
      Self.Options := Options;
      Self.PopupBorder := PopupBorder;
      Self.PopupFont := PopupFont;
      Self.PopupType := PopupType;
      Self.SpecialDays := SpecialDays;
      Self.StartOfWeek := StartOfWeek;
      Self.WeekendDays := WeekendDays;
      Self.WeekNumbersFont := FWeekNumbersFont;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCPopupCalendarProps.Create(AOwner: TSCCustomPopupCalendar);
begin
  inherited Create;
  FOwner := AOwner;

  FBorderStyle := scesDefault;
  FButtonStyle := sccbsWin2k;
  FDayCaptions := scdcFirst;
  FStartOfWeek := scswLocaleDefault;

  FPopupBorder := sccbFlat;
  FPopupType := sccpMonthYear;

  FImageHighlight := -1;
  FImageSelection := -1;
  FImageToday := -1;

  FNavigatorLeft := -1;
  FNavigatorRight := -1;
  FNavigatorGradient := scgBottomToTop;
  FNavigatorHeight := -1;
  FNavigatorStyle := scnFlat;
  FWeekendDays := SCWeekendDays;

  FOptions := SCCalendarDefOptions;

  FCalColors := TSCCalendarColors.Create(FOwner);
  FButtonFont := TFont.Create;
  FDayCaptionsFont := TFont.Create;
  FFont := TFont.Create;
  FNavigatorFont := TFont.Create;
  FWeekNumbersFont := TFont.Create;
  FPopupFont := TFont.Create;
  FHolidays := TSCHolidays.Create(FOwner);
  FSpecialDays := TSCSpecialDays.Create(FOwner);
end;

destructor TSCPopupCalendarProps.Destroy;
begin
  FreeAndNil(FCalColors);
  FreeAndNil(FButtonFont);
  FreeAndNil(FDayCaptionsFont);
  FreeAndNil(FFont);
  FreeAndNil(FNavigatorFont);
  FreeAndNil(FWeekNumbersFont);
  FreeAndNil(FPopupFont);
  FreeAndNil(FHolidays);
  FreeAndNil(FSpecialDays);
  inherited Destroy;
end;

function TSCPopupCalendarProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCPopupCalendarProps.SetAlignPopupText(Value: Boolean);
begin
  FAlignPopupText := Value;
end;

procedure TSCPopupCalendarProps.SetButtonFont(Value: TFont);
begin
  FButtonFont.Assign(Value);
end;

procedure TSCPopupCalendarProps.SetCalColors(Value: TSCCalendarColors);
begin
  FCalColors.Assign(Value);
end;

procedure TSCPopupCalendarProps.SetDayCaptionsFont(Value: TFont);
begin
  FDayCaptionsFont.Assign(Value);
end;

procedure TSCPopupCalendarProps.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TSCPopupCalendarProps.SetHolidays(Value: TSCHolidays);
begin
  FHolidays.Assign(Value);
end;

procedure TSCPopupCalendarProps.SetImageHighlight(Value: TImageIndex);
begin
  FImageHighlight := Value;
end;

procedure TSCPopupCalendarProps.SetImageSelection(Value: TImageIndex);
begin
  FImageSelection := Value;
end;

procedure TSCPopupCalendarProps.SetImageToday(Value: TImageIndex);
begin
  FImageToday := Value;
end;

procedure TSCPopupCalendarProps.SetIndent(Value: Integer);
begin
  if Value < 0 then
    Value := 0
  else
  if Value > 100 then
    Value := 100;

  FIndent := Value;
end;

procedure TSCPopupCalendarProps.SetNavigatorFont(Value: TFont);
begin
  FNavigatorFont.Assign(Value);
end;

procedure TSCPopupCalendarProps.SetNavigatorHeight(Value: Integer);
begin
  if Value <= -1 then
    Value := -1
  else
  if Value < 16 then
    Value := 16;

  FNavigatorHeight := Value;
end;

procedure TSCPopupCalendarProps.SetNavigatorLeft(Value: TImageIndex);
begin
  FNavigatorLeft := Value;
end;

procedure TSCPopupCalendarProps.SetNavigatorRight(Value: TImageIndex);
begin
  FNavigatorRight := Value;
end;

procedure TSCPopupCalendarProps.SetPopupBorder(Value: TSCControlBorder);
begin
  FPopupBorder := Value;
end;

procedure TSCPopupCalendarProps.SetPopupFont(Value: TFont);
begin
  FPopupFont.Assign(Value);
end;

procedure TSCPopupCalendarProps.SetPopupType(Value: TSCCalendarPopupType);
begin
  FPopupType := Value;
end;

procedure TSCPopupCalendarProps.SetSpecialDays(Value: TSCSpecialDays);
begin
  FSpecialDays.Assign(Value);
end;

procedure TSCPopupCalendarProps.SetWeekNumbersFont(Value: TFont);
begin
  FWeekNumbersFont.Assign(Value);
end;

{ TSCCustomTimeEdit }

procedure TSCCustomTimeEdit.AfterConstruction;
begin
  inherited AfterConstruction;
  SetText(TimeToStr(FTime));
end;

procedure TSCCustomTimeEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomTimeEdit then
  begin
    with TSCCustomTimeEdit(Source) do
    begin
      Self.DisplayFormat := DisplayFormat;
      Self.Time := Time;
      Self.TimeValidation := TimeValidation;
    end;
  end;
end;

procedure TSCCustomTimeEdit.BeforeExit;
begin
  inherited BeforeExit;
  UpdateTimeFromText;
end;

procedure TSCCustomTimeEdit.CMWinIniChange(var Message: TWMWinIniChange);
begin
  inherited;
  SetText(TimeToStr(FTime));
end;

constructor TSCCustomTimeEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];

  FTime := 0;
  FTimeValidation := sctvSetToNow;
end;

procedure TSCCustomTimeEdit.DoTimeChange;
begin
  //
end;

procedure TSCCustomTimeEdit.DoValidationError(var ATime: TTime;
  var ErrorText: String; var RaiseError: Boolean);
begin
  //
end;

function TSCCustomTimeEdit.GetDescriptionColor: TColor;
begin
  Result := inherited GetDescriptionColor;
  if (IsDesigning or not Focused) and (FDisplayFormat <> '') then
    Result := Self.Font.Color;
end;

function TSCCustomTimeEdit.GetDescriptionText: String;
var
  T: TTime;
begin
  if (IsDesigning or not Focused) and (FDisplayFormat <> '') then
  begin
    T := FTime;
    if T = -1 then
    begin
      Result := Text;
      if Result <> '' then
        T := scStrToTime(Result, 0, sctvDontUpdate);

      if T = 0 then
        Exit;
    end;

    try
      Result := FormatDateTime(FDisplayFormat, T);
    except
      Result := '';
    end;
  end else
    Result := inherited GetDescriptionText;
end;

function TSCCustomTimeEdit.IsDescription: Boolean;
begin
  Result := inherited IsDescription or
    ((FDisplayFormat <> '') and (IsDesigning or not Focused));
end;

procedure TSCCustomTimeEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  T: TTime;
begin
  case Key of
    VK_RETURN:
    begin
      Key := 0;
      UpdateTimeFromText;
    end;
    VK_PRIOR:
    begin
      Key := 0;

      UpdateTimeFromText;
      T := FTime - Trunc(FTime);

      if ssShift in Shift then
        SetTime(scAdjustTime(T, 1, 0, 0))
      else
        SetTime(scAdjustTime(T, 0, 1, 0));
    end;
    VK_NEXT:
    begin
      Key := 0;

      UpdateTimeFromText;
      T := FTime - Trunc(FTime);

      if ssShift in Shift then
        SetTime(scAdjustTime(T, -1, 0, 0))
      else
        SetTime(scAdjustTime(T, 0, -1, 0));
    end;
    VK_UP:
    begin
      Key := 0;

      UpdateTimeFromText;
      T := FTime - Trunc(FTime);

      SetTime(scAdjustTime(T, 0, 0, 1));
    end;
    VK_DOWN:
    begin
      Key := 0;

      UpdateTimeFromText;
      T := FTime - Trunc(FTime);

      SetTime(scAdjustTime(T, 0, 0, -1));
    end;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomTimeEdit.KeyPress(var Key: Char);
var
  T: TTime;
begin
  if Key <> {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}TimeSeparator then
  begin
    T := FTime - Trunc(FTime);

    case Key of
      '+':
      begin
        Key := #0;
        SetTime(scAdjustTime(T, 0, 0, 1));
      end;
      '-':
      begin
        Key := #0;
        SetTime(scAdjustTime(T, 0, 0, -1));
      end;
    end;
  end;

  inherited KeyPress(Key);
end;

procedure TSCCustomTimeEdit.Loaded;
begin
  inherited Loaded;
  SetText(TimeToStr(FTime));
end;

procedure TSCCustomTimeEdit.SetDisplayFormat(Value: TCaption);
begin
  if FDisplayFormat <> Value then
  begin
    FDisplayFormat := Value;
    if IsDesigning or not Focused then
      Invalidate;
  end;
end;

procedure TSCCustomTimeEdit.SetTime(Value: TTime);
begin
  if FTime <> Value then
  begin
    FTime := Value;

    SetText(TimeToStr(FTime));
    TimeChanged;
  end;
end;

procedure TSCCustomTimeEdit.TimeChanged;
begin
  DoTimeChange;
  if Assigned(FOnTimeChange) then
    FOnTimeChange(Self);
end;

procedure TSCCustomTimeEdit.UpdateTimeFromText;
begin
  if TimeToStr(FTime) <> Text then
  begin
    try
      SetTime(scStrToTime(Text, FTime, TimeValidation));

      if TimeValidation = sctvDontUpdate then
        SetText(TimeToStr(FTime));
    except
      on E: Exception do
      begin
        if (TimeValidation = sctvRaiseError) and not IsDesigning then
          SetFocus;

        ValidationError(E.Message);
      end;
    end;
  end;
end;

procedure TSCCustomTimeEdit.ValidationError(ErrorTxt: String);
var
  S: String;
  ATime: TTime;
  RaiseError: Boolean;
begin
  ATime := FTime;
  RaiseError := True;

  S := Copy(ErrorTxt, 1, Length(ErrorTxt));
  DoValidationError(ATime, S, RaiseError);

  if RaiseError then
  begin
    if S = '' then S := ErrorTxt;
    raise Exception.Create(S);
  end else
  begin
    if FTime <> ATime then
      SetTime(ATime)
    else
      SetText(TimeToStr(ATime));
  end;
end;

{$I SCVerRec.inc}

end.
