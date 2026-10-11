{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCSpinEdits;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Clipbrd, SCCommon, SCConsts, SCControl, SCEdits, SCMaskEdit,
  SCAdvEdits, ImgList, MultiMon;

type
  TSCCustomSpinEdit = class;
  
  TSCCustomSpinButtonProps = class(TSCCustomEditButtonProps)
  private
    function  GetArrowColor: TColor;
    procedure SetArrowColor(Value: TColor);
    function  GetColor: TColor;
    procedure SetColor(Value: TColor);
    function  GetHomeEndButtons: Boolean;
    procedure SetHomeEndButtons(Value: Boolean);
    function  GetSideBySide: Boolean;
    procedure SetSideBySide(Value: Boolean);
    function  GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
  protected
    property ArrowColor: TColor read GetArrowColor write SetArrowColor default clBtnText;
    property Color: TColor read GetColor write SetColor default clBtnFace;
    property HomeEndButtons: Boolean read GetHomeEndButtons write SetHomeEndButtons default False;
    property SideBySide: Boolean read GetSideBySide write SetSideBySide default False;
    property Visible: Boolean read GetVisible write SetVisible default True;
  public
    procedure Assign(Source: TPersistent); override;
  end;

  TSCIntSpinButtonProps = class(TSCCustomSpinButtonProps)
  published
    property ArrowColor;
    property Color;
    property SideBySide;
    property Visible;
  end;

  TSCSpinDropDownButtonProps = class(TPersistent)
  private
    FOwner: TSCCustomSpinEdit;
    function  GetArrowColor: TColor;
    procedure SetArrowColor(Value: TColor);
    function  GetColor: TColor;
    procedure SetColor(Value: TColor);
    function  GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
  protected
    function GetOwner: TPersistent; override;
    property Owner: TSCCustomSpinEdit read FOwner;
  public
    constructor Create(AOwner: TSCCustomSpinEdit);
    procedure Assign(Source: TPersistent); override;
  published
    property ArrowColor: TColor read GetArrowColor write SetArrowColor default clBtnText;
    property Color: TColor read GetColor write SetColor default clBtnFace;
    property Visible: Boolean read GetVisible write SetVisible default False;
  end;

  TSCSpinDropDownButton = class(TSCBaseDropDownButton);

  TSCCustomSpinEdit = class(TSCCustomButtonFrame)
  private
    FButtonsSideBySide: Boolean;
    FDownButton: TSCEditButton;
    FKeySpin: Boolean;
    FUpButton: TSCEditButton;
    FDropDownButton: TSCSpinDropDownButton;
    FDropDownProps: TSCSpinDropDownButtonProps;
    FSpining: Boolean;
    FSpinTimer: Integer;
    FHomeButton: TSCEditButton;
    FEndButton: TSCEditButton;
    FOnDropDownClick: TNotifyEvent;
    function  GetButtonArrowColor: TColor;
    procedure SetButtonArrowColor(Value: TColor);
    function  GetButtonColor: TColor;
    procedure SetButtonColor(Value: TColor);
    procedure SetButtonsSideBySide(Value: Boolean);
    function  GetButtonsVisible: Boolean;
    procedure SetButtonsVisible(Value: Boolean);

    function  GetDropDownArrowColor: TColor;
    procedure SetDropDownArrowColor(Value: TColor);
    function  GetDropDownColor: TColor;
    procedure SetDropDownColor(Value: TColor);
    function  GetDropDownVisible: Boolean;
    procedure SetDropDownVisible(Value: Boolean);
    procedure SetDropDownProps(Value: TSCSpinDropDownButtonProps);

    function  GetHomeEndButtons: Boolean;
    procedure SetHomeEndButtons(Value: Boolean);

    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
  protected
    procedure Loaded; override;
    function  GetButtonClass: TSCEditButtonClass; override;
    function  AdjustImageTop(ImgTop: Integer): Integer; override;

    procedure SetDropDownButton(Value: TSCSpinDropDownButton); virtual;
    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; override;

    procedure BeforeExit; override;
    procedure UpdateValueFromText; dynamic;

    procedure DoButtonClick(Btn: TSCEditButton); override;
    procedure DoButtonHotChanged(Btn: TSCEditButton); override;
    procedure DoButtonUp(Btn: TSCEditButton); override;

    procedure StopTracking; override;
    function  GetSliderHeight(R: TRect; IsUp: Boolean): Integer; override;
    function  GetSliderPos(R: TRect; IsUp: Boolean): TPoint; override;

    function  GetButtonRect(Btn: TSCEditButton): TRect; override;
    procedure UpdateBorderRect(var R: TRect); override;

    procedure StartSpining;
    procedure StopSpining;
    procedure SpinControl; dynamic;

    function  CanSpin(AsUp: Boolean): Boolean; virtual;
    function  CanExecuteHomeEndKeys: Boolean; dynamic;
    function  CanDoKeySpin: Boolean; virtual;

    function  Spining: Boolean;
    function  SpinPaused: Boolean;
    procedure PauseSpining;
    procedure ResumeSpining;

    procedure CheckEmpty; dynamic;

    procedure DoPageUp(var Key: Word); dynamic;
    procedure DoPageDown(var Key: Word); dynamic;
    
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    property ButtonArrowColor: TColor read GetButtonArrowColor write SetButtonArrowColor default clBtnText;
    property ButtonColor: TColor read GetButtonColor write SetButtonColor default clBtnFace;
    property ButtonsVisible: Boolean read GetButtonsVisible write SetButtonsVisible default True;
    property ButtonsSideBySide: Boolean read FButtonsSideBySide write SetButtonsSideBySide default False;
    property DropDownProps: TSCSpinDropDownButtonProps read FDropDownProps write SetDropDownProps;
    property HomeEndButtons: Boolean read GetHomeEndButtons write SetHomeEndButtons default False;
    property KeySpin: Boolean read FKeySpin write FKeySpin default True;
    property UseUndo default False;
    property DropDownButton: TSCSpinDropDownButton read FDropDownButton;
    property OnDropDownClick: TNotifyEvent read FOnDropDownClick write FOnDropDownClick;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure Assign(Source: TPersistent); override;

    function  IsEmpty: Boolean; dynamic;
    procedure SetEmpty; dynamic;
  end;

  TSCSpinnerButton = class(TSCEditButton)
  protected
    property Style default scebCustom;
  public
    constructor Create(AOwner: TSCCustomButtonFrame); override;
  end;

  TSCSpinnerStyle = (scssArrow, scssCustom, scssImage, scssMinusPlus);
  TSCSpinnerLayout = (scslLeft, scslLeftRight, scslRight);

  TSCCustomNavButtonProps = class(TSCCustomSpinButtonProps)
  private
    function  GetDownImage: TImageIndex;
    procedure SetDownImage(Value: TImageIndex);
    function  GetEndImage: TImageIndex;
    procedure SetEndImage(Value: TImageIndex);
    function  GetHomeEndLayout: TSCSpinnerLayout;
    procedure SetHomeEndLayout(Value: TSCSpinnerLayout);
    function  GetHomeImage: TImageIndex;
    procedure SetHomeImage(Value: TImageIndex);
    function  GetLayout: TSCSpinnerLayout;
    procedure SetLayout(Value: TSCSpinnerLayout);
    function  GetStyle: TSCSpinnerStyle;
    procedure SetStyle(Value: TSCSpinnerStyle);
    function  GetUpImage: TImageIndex;
    procedure SetUpImage(Value: TImageIndex);
    function  GetWidth: Integer;
    procedure SetWidth(Value: Integer);
  protected
    property DownImage: TImageIndex read GetDownImage write SetDownImage default -1;
    property EndImage: TImageIndex read GetEndImage write SetEndImage default -1;
    property HomeEndLayout: TSCSpinnerLayout read GetHomeEndLayout write SetHomeEndLayout default scslLeftRight;
    property HomeImage: TImageIndex read GetHomeImage write SetHomeImage default -1;
    property Layout: TSCSpinnerLayout read GetLayout write SetLayout default scslLeftRight;
    property Style: TSCSpinnerStyle read GetStyle write SetStyle default scssMinusPlus;
    property UpImage: TImageIndex read GetUpImage write SetUpImage default -1;
    property Width: Integer read GetWidth write SetWidth default -1;
  public
    procedure Assign(Source: TPersistent); override;
  end;

  TSCNavButtonProps = class(TSCCustomNavButtonProps)
  published
    property DownImage;
    property EndImage;
    property HomeEndButtons;
    property HomeEndLayout;
    property HomeImage;
    property Layout;
    property Style;
    property UpImage;
    property Width;
  end;

  TSCNavEditButton = (scnbUp, scnbDown, scnbHome, scnbEnd);

  TSCSpinEvent = procedure(Sender: TObject; AsUp: Boolean; var Result: Boolean) of object;
  TSCNavButtonEvent = procedure(Sender: TObject; Button: TSCNavEditButton) of object;
  TSCValidKeyEvent = procedure(Sender: TObject; Key: Char; var Result: Boolean) of object;

  TSCCustomNavEdit = class(TSCCustomSpinEdit)
  private
    FOnCanRepeat: TSCSpinEvent;
    FOnButtonClick: TSCNavButtonEvent;
    FOnPageUp: TNotifyEvent;
    FOnPageDown: TNotifyEvent;
    FOnIsValidKey: TSCValidKeyEvent;
    FOnRepeat: TSCSpinEvent;
    FInStyleChange: Boolean;
    FNeedRepaint: Boolean;
    FButtonLayout: TSCSpinnerLayout;
    FButtonStyle: TSCSpinnerStyle;
    FHomeEndLayout: TSCSpinnerLayout;
    procedure SetButtonLayout(Value: TSCSpinnerLayout);
    function  GetButtonDownImage: TImageIndex;
    procedure SetButtonDownImage(Value: TImageIndex);
    function  GetButtonEndImage: TImageIndex;
    procedure SetButtonEndImage(Value: TImageIndex);
    function  GetButtonHomeImage: TImageIndex;
    procedure SetButtonHomeImage(Value: TImageIndex);
    function  GetButtonUpImage: TImageIndex;
    procedure SetButtonUpImage(Value: TImageIndex);
    procedure SetButtonStyle(Value: TSCSpinnerStyle);
    function  GetButtonWidth: Integer;
    procedure SetButtonWidth(Value: Integer);
    procedure SetHomeEndLayout(Value: TSCSpinnerLayout);
  protected
    function  GetButtonClass: TSCEditButtonClass; override;
    function  GetButtonRect(Btn: TSCEditButton): TRect; override;
    procedure UpdateBorderRect(var R: TRect); override;

    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; override;

    function  GetSliderHeight(R: TRect; IsUp: Boolean): Integer; override;
    procedure ButtonChanged(Sender: TObject); override;
    procedure DoCustomPaintButton(C: TCanvas; R: TRect; Btn: TSCEditButton;
      IsDown, IsHot: Boolean); override;

    function  IsValidKey(Key: Char): Boolean; override;
    procedure CheckKeyDown(var Key: Word; Shift: TShiftState); override;

    procedure DoButtonClick(Btn: TSCEditButton); override;
    procedure DoPageUp(var Key: Word); override;
    procedure DoPageDown(var Key: Word); override;

    function  CanSpin(AsUp: Boolean): Boolean; override;
    procedure SpinControl; override;

    property Alignment default taCenter;
    property ButtonDownImage: TImageIndex read GetButtonDownImage write SetButtonDownImage default -1;
    property ButtonEndImage: TImageIndex read GetButtonEndImage write SetButtonEndImage default -1;
    property ButtonHomeImage: TImageIndex read GetButtonHomeImage write SetButtonHomeImage default -1;
    property ButtonLayout: TSCSpinnerLayout read FButtonLayout write SetButtonLayout default scslLeftRight;
    property ButtonStyle: TSCSpinnerStyle read FButtonStyle write SetButtonStyle default scssMinusPlus;
    property ButtonUpImage: TImageIndex read GetButtonUpImage write SetButtonUpImage default -1;
    property ButtonWidth: Integer read GetButtonWidth write SetButtonWidth default -1;
    property HomeEndLayout: TSCSpinnerLayout read FHomeEndLayout write SetHomeEndLayout default scslLeftRight;
    property OnCanRepeat: TSCSpinEvent read FOnCanRepeat write FOnCanRepeat;
    property OnButtonClick: TSCNavButtonEvent read FOnButtonClick write FOnButtonClick;
    property OnIsValidKey: TSCValidKeyEvent read FOnIsValidKey write FOnIsValidKey;
    property OnPageUp: TNotifyEvent read FOnPageUp write FOnPageUp;
    property OnPageDown: TNotifyEvent read FOnPageDown write FOnPageDown;
    property OnRepeat: TSCSpinEvent read FOnRepeat write FOnRepeat;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    function  IsEmpty: Boolean; override;
  end;

  TSCNavEdit = class(TSCCustomNavEdit)
  public
    property CaretPoint;
    property CaretPos;
    property SelLength;
    property SelStart;
    property SelText;
    property TopLine;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoComplete;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property ButtonProps;
    property CanDragSelection;
    property CanEdit;
    property CanSelect;
    property CharCase;
    property Checkbox;
    property Color;
    property Colors;
    property Constraints;
    property Delimeters;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EditCursor;
    property EditMode;
    property Enabled;
    property EnterAsTab;
    property FocusExpandSize;
    property Font;
    property HideSelection;
    property ImageIndex;
    property Images;
    property ImeMode;
    property ImeName;
    property InsertChangesEditMode;
    property KeySpin;
    property Layout;
    property MaxLength;
    {$IFDEF SC_DELPHI2009_EARLY}
    property OEMConvert;
    {$ENDIF}
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PasswordImage;
    property PasswordStyle;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Text;
    property Transparent;
    property UseCaret;
    property UseDefaultMenu;
    property UseDelimeters;
    property UseImage;
    property UseUndo;
    property UndoLimit;
    property Visible;
    property OnAutoComplete;
    property OnButtonClick;
    property OnCaretMove;
    property OnCanRepeat;
    property OnCanResize;
    property OnChange;
    property OnCheckboxChange;
    property OnClick;
    property OnClipCut;
    property OnClipCopy;
    property OnClipPaste;
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
    property OnFocusChanged;
    property OnIsValidKey;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaintButton;
    property OnPageDown;
    property OnPageUp;
    property OnRepeat;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomIntSpinEdit = class(TSCCustomSpinEdit)
  private
    FAllowEmpty: Boolean;
    FHexMode: Boolean;
    FIncrement: LongInt;
    FLargeIncrement: LongInt;
    FMinValue: LongInt;
    FMaxValue: LongInt;
    FUseThousandsSeparator: Boolean;
    procedure SetAllowEmpty(Value: Boolean);
    procedure SetHexMode(Value: Boolean);
    procedure SetIntValue(Value: LongInt);
    procedure SetIncrement(Value: LongInt);
    procedure SetLargeIncrement(Value: LongInt);
    procedure SetMinValue(Value: LongInt);
    procedure SetMaxValue(Value: LongInt);
    procedure SetUseThousandsSeparator(Value: Boolean);

    function  ArrangeSeparators(const S: String; AddThousands: Boolean = True): String;
    function  RemoveNegativeSymbol(const S: String; var IsNegative: Boolean): String;
    function  AddNegativeSymbol(const S: String): String;
  protected
    function  IsValidKey(Key: Char): Boolean; override;
    procedure CheckKeyDown(var Key: Word; Shift: TShiftState); override;
    function  ArrangeText(const S: String): String; override;

    function  CanPasteStr(var S: String): Boolean; override;

    procedure UpdateValueFromText; override;
    function  GetUnIntValue: LongInt; dynamic;
    function  GetIntValue: LongInt; virtual;

    function  CanSetValue(var Value: LongInt): Boolean; virtual;

    procedure DoButtonClick(Btn: TSCEditButton); override;
    procedure DoPageUp(var Key: Word); override;
    procedure DoPageDown(var Key: Word); override;

    function  CanSpin(AsUp: Boolean): Boolean; override;
    function  CanExecuteHomeEndKeys: Boolean; override;
    procedure SpinControl; override;

    procedure CheckEmpty; override;
    function  CheckValue(Value: LongInt): LongInt; dynamic;

    property AllowEmpty: Boolean read FAllowEmpty write SetAllowEmpty default False;
    property HexMode: Boolean read FHexMode write SetHexMode default False;
    property Increment: LongInt read FIncrement write SetIncrement default 1;
    property LargeIncrement: LongInt read FLargeIncrement write SetLargeIncrement default 10;
    property MinValue: LongInt read FMinValue write SetMinValue default 0;
    property MaxValue: LongInt read FMaxValue write SetMaxValue default 0;
    property IntValue: LongInt read GetIntValue write SetIntValue stored True;
    property UseThousandsSeparator: Boolean read FUseThousandsSeparator
      write SetUseThousandsSeparator default True;
    property Value: LongInt read GetIntValue write SetIntValue stored True;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    function  IsEmpty: Boolean; override;
    procedure SetEmpty; override;
  end;

  TSCCustomSpinnerButtonProps = class(TSCCustomSpinButtonProps)
  private
    function  GetDownImage: TImageIndex;
    procedure SetDownImage(Value: TImageIndex);
    function  GetEndImage: TImageIndex;
    procedure SetEndImage(Value: TImageIndex);
    function  GetHomeEndLayout: TSCSpinnerLayout;
    procedure SetHomeEndLayout(Value: TSCSpinnerLayout);
    function  GetHomeImage: TImageIndex;
    procedure SetHomeImage(Value: TImageIndex);
    function  GetLayout: TSCSpinnerLayout;
    procedure SetLayout(Value: TSCSpinnerLayout);
    function  GetStyle: TSCSpinnerStyle;
    procedure SetStyle(Value: TSCSpinnerStyle);
    function  GetUpImage: TImageIndex;
    procedure SetUpImage(Value: TImageIndex);
    function  GetWidth: Integer;
    procedure SetWidth(Value: Integer);
  protected
    property DownImage: TImageIndex read GetDownImage write SetDownImage default -1;
    property EndImage: TImageIndex read GetEndImage write SetEndImage default -1;
    property HomeEndLayout: TSCSpinnerLayout read GetHomeEndLayout write SetHomeEndLayout default scslLeftRight;
    property HomeImage: TImageIndex read GetHomeImage write SetHomeImage default -1;
    property Layout: TSCSpinnerLayout read GetLayout write SetLayout default scslLeftRight;
    property Style: TSCSpinnerStyle read GetStyle write SetStyle default scssMinusPlus;
    property UpImage: TImageIndex read GetUpImage write SetUpImage default -1;
    property Width: Integer read GetWidth write SetWidth default -1;
  public
    procedure Assign(Source: TPersistent); override;
  end;

  TSCSpinnerButtonProps = class(TSCCustomSpinnerButtonProps)
  published
    property DownImage;
    property EndImage;
    property HomeEndButtons;
    property HomeEndLayout;
    property HomeImage;
    property Layout;
    property Style;
    property UpImage;
    property Width;
  end;

  TSCCustomSpinnerEdit = class(TSCCustomIntSpinEdit)
  private
    FInStyleChange: Boolean;
    FNeedRepaint: Boolean;
    FButtonLayout: TSCSpinnerLayout;
    FButtonStyle: TSCSpinnerStyle;
    FHomeEndLayout: TSCSpinnerLayout;
    procedure SetButtonLayout(Value: TSCSpinnerLayout);
    function  GetButtonDownImage: TImageIndex;
    procedure SetButtonDownImage(Value: TImageIndex);
    function  GetButtonEndImage: TImageIndex;
    procedure SetButtonEndImage(Value: TImageIndex);
    function  GetButtonHomeImage: TImageIndex;
    procedure SetButtonHomeImage(Value: TImageIndex);
    function  GetButtonUpImage: TImageIndex;
    procedure SetButtonUpImage(Value: TImageIndex);
    procedure SetButtonStyle(Value: TSCSpinnerStyle);
    function  GetButtonWidth: Integer;
    procedure SetButtonWidth(Value: Integer);
    procedure SetHomeEndLayout(Value: TSCSpinnerLayout);
  protected
    function  GetButtonClass: TSCEditButtonClass; override;
    function  GetButtonRect(Btn: TSCEditButton): TRect; override;
    procedure UpdateBorderRect(var R: TRect); override;

    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; override;

    function  GetSliderHeight(R: TRect; IsUp: Boolean): Integer; override;
    procedure ButtonChanged(Sender: TObject); override;
    procedure DoCustomPaintButton(C: TCanvas; R: TRect; Btn: TSCEditButton;
      IsDown, IsHot: Boolean); override;

    property Alignment default taCenter;
    property ButtonDownImage: TImageIndex read GetButtonDownImage write SetButtonDownImage default -1;
    property ButtonEndImage: TImageIndex read GetButtonEndImage write SetButtonEndImage default -1;
    property ButtonHomeImage: TImageIndex read GetButtonHomeImage write SetButtonHomeImage default -1;
    property ButtonLayout: TSCSpinnerLayout read FButtonLayout write SetButtonLayout default scslLeftRight;
    property ButtonStyle: TSCSpinnerStyle read FButtonStyle write SetButtonStyle default scssMinusPlus;
    property ButtonUpImage: TImageIndex read GetButtonUpImage write SetButtonUpImage default -1;
    property ButtonWidth: Integer read GetButtonWidth write SetButtonWidth default -1;
    property HomeEndLayout: TSCSpinnerLayout read FHomeEndLayout write SetHomeEndLayout default scslLeftRight;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCSpinnerEdit = class(TSCCustomSpinnerEdit)
  published
    property Align;
    property Alignment;
    property AllowEmpty;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BorderProps;
    property ButtonProps;
    property CanEdit;
    property CanSelect;
    property CharCase;
    property Checkbox;
    property Color;
    property Colors;
    property Constraints;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EditCursor;
    property EditMode;
    property Enabled;
    property EnterAsTab;
    property FocusExpandSize;
    property Font;
    property HideSelection;
    property ImageIndex;
    property Images;
    property Increment;
    property IntValue;
    property KeySpin;
    property LargeIncrement;
    property Layout;
    property MinValue;
    property MaxLength;
    property MaxValue;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseCaret;
    property UseImage;
    property UseUndo;
    property UndoLimit;
    property UseThousandsSeparator;
    property Visible;
    property OnCaretMove;
    property OnCanResize;
    property OnChange;
    property OnCheckboxChange;
    property OnClick;
    property OnClipCut;
    property OnClipCopy;
    property OnClipPaste;
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
    property OnFocusChanged;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaintButton;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCIntSpinEdit = class(TSCCustomIntSpinEdit)
  public
    property Text;
  published
    property Align;
    property Alignment;
    property AllowEmpty;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BorderProps;
    property ButtonProps;
    property CanEdit;
    property CanSelect;
    property CharCase;
    property Checkbox;
    property Color;
    property Colors;
    property Constraints;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    // property DropDownProps;
    property EditCursor;
    property EditMode;
    property Enabled;
    property EnterAsTab;
    property FocusExpandSize;
    property Font;
    property HexMode;
    property HideSelection;
    property ImageIndex;
    property Images;
    property Increment;
    property IntValue;
    property KeySpin;
    property LargeIncrement;
    property Layout;
    property MinValue;
    property MaxLength;
    property MaxValue;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseCaret;
    property UseImage;
    property UseThousandsSeparator;
    property UseUndo;
    property UndoLimit;
    property Visible;
    property OnCaretMove;
    property OnCanResize;
    property OnChange;
    property OnCheckboxChange;
    property OnClick;
    property OnClipCut;
    property OnClipCopy;
    property OnClipPaste;
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
    property OnFocusChanged;
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

  TSCCustomFloatSpinEdit = class(TSCCustomSpinEdit)
  private
    FAllowEmpty: Boolean;
    FDecimalPlaces: Integer;
    FIncrement: Double;
    FLargeIncrement: Double;
    FMinValue: Double;
    FMaxValue: Double;
    FUseThousandsSeparator: Boolean;
    procedure SetAllowEmpty(Value: Boolean);
    procedure SetDecimalPlaces(Value: Integer);
    procedure SetFloatValue(Value: Double);
    procedure SetIncrement(Value: Double);
    procedure SetLargeIncrement(Value: Double);
    procedure SetMinValue(Value: Double);
    procedure SetMaxValue(Value: Double);
    procedure SetUseThousandsSeparator(Value: Boolean);

    function  IsIncrementStored: Boolean;
    function  IsMaxValueStored: Boolean;
    function  IsMinValueStored: Boolean;
    function  IsLargeIncrementStored: Boolean;

    function  ArrangeSeparators(const S: String; AddThousands: Boolean = True): String;
    function  RemoveNegativeSymbol(const S: String; var IsNegative: Boolean): String;
    function  AddNegativeSymbol(const S: String): String;
  protected
    function  IsValidKey(Key: Char): Boolean; override;
    function  ArrangeText(const S: String): String; override;

    procedure UpdateValueFromText; override;
    function  GetUnFloatValue: Double; dynamic;
    function  GetFloatValue: Double; virtual;

    function  CanPasteStr(var S: String): Boolean; override;

    function  IsValidText: Boolean;
    function  GetFloatText: String;

    procedure DoButtonClick(Btn: TSCEditButton); override;
    procedure DoPageUp(var Key: Word); override;
    procedure DoPageDown(var Key: Word); override;

    function  CanSpin(AsUp: Boolean): Boolean; override;
    procedure SpinControl; override;

    function  CanSetValue(var Value: Double): Boolean; dynamic;

    procedure CheckEmpty; override;
    function  CheckValue(Value: Double): Double; dynamic;

    property AllowEmpty: Boolean read FAllowEmpty write SetAllowEmpty default False;
    property DecimalPlaces: Integer read FDecimalPlaces write SetDecimalPlaces default -1;
    property MinValue: Double read FMinValue write SetMinValue stored IsMinValueStored;
    property MaxValue: Double read FMaxValue write SetMaxValue stored IsMaxValueStored;
    property Increment: Double read FIncrement write SetIncrement stored IsIncrementStored;
    property LargeIncrement: Double read FLargeIncrement write SetLargeIncrement stored IsLargeIncrementStored;
    property FloatValue: Double read GetFloatValue write SetFloatValue stored True;
    property UseThousandsSeparator: Boolean read FUseThousandsSeparator
      write SetUseThousandsSeparator default True;
    property Value: Double read GetFloatValue write SetFloatValue stored True;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    function  IsEmpty: Boolean; override;
    procedure SetEmpty; override;
  end;

  TSCFloatSpinEdit = class(TSCCustomFloatSpinEdit)
  public
    property Text;
    property FloatValue;
  published
    property Align;
    property Alignment;
    property AllowEmpty;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BorderProps;
    property ButtonProps;
    property CanEdit;
    property CanSelect;
    property CharCase;
    property Checkbox;
    property Color;
    property Colors;
    property Constraints;
    property DecimalPlaces;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EditCursor;
    property EditMode;
    property Enabled;
    property EnterAsTab;
    property FocusExpandSize;
    property Font;
    property HideSelection;
    property ImageIndex;
    property Images;
    property Increment;
    property KeySpin;
    property LargeIncrement;
    property Layout;
    property MinValue;
    property MaxLength;
    property MaxValue;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseCaret;
    property UseImage;
    property UseThousandsSeparator;
    property UseUndo;
    property UndoLimit;
    property Value;
    property Visible;
    property OnCaretMove;
    property OnCanResize;
    property OnChange;
    property OnCheckboxChange;
    property OnClick;
    property OnClipCut;
    property OnClipCopy;
    property OnClipPaste;
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
    property OnFocusChanged;
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

  TSCCurrenyEditFormat = (sccfCurrency, sccfFloat, sccfPercentageLeft,
    sccfPercentageRight);

  TSCCustomCurrencyEdit = class(TSCCustomSpinEdit)
  private
    FAllowEmpty: Boolean;
    FDecimalPlaces: Integer;
    FEditFormat: TSCCurrenyEditFormat;
    FIncrement: Double;
    FLargeIncrement: Double;
    FMinValue: Double;
    FMaxValue: Double;
    FUseNegativeCurrency: Boolean;
    FUseThousandsSeparator: Boolean;
    FCurrencySymbol: String;
    procedure SetAllowEmpty(Value: Boolean);
    procedure SetCurrencySymbol(const Value: String);
    procedure SetDecimalPlaces(Value: Integer);
    procedure SetEditFormat(Value: TSCCurrenyEditFormat);
    procedure SetIncrement(Value: Double);
    procedure SetLargeIncrement(Value: Double);
    procedure SetFloatValue(Value: Double);
    procedure SetMinValue(Value: Double);
    procedure SetMaxValue(Value: Double);
    procedure SetUseNegativeCurrency(Value: Boolean);
    procedure SetUseThousandsSeparator(Value: Boolean);

    function  IsIncrementStored: Boolean;
    function  IsMaxValueStored: Boolean;
    function  IsMinValueStored: Boolean;
    function  IsLargeIncrementStored: Boolean;

    function  GetCurrencySymbol: String;
    function  GetDecimalSeparator: Char;
    function  GetThousandSeparator: Char;

    function  ArrangeSeparators(const S: String; AddThousands: Boolean = True): String;
    function  RemoveCurrencySymbol(const S: String; UseFormat: Boolean = False): String;
    function  RemoveNegativeSymbol(const S: String; Formatting: TSCCurrenyEditFormat;
      var IsNegative: Boolean): String;
    function  AddCurrencySymbol(const S: String): String;
    function  AddNegativeSymbol(const S: String; Formatting: TSCCurrenyEditFormat): String;
  protected
    function  IsValidKey(Key: Char): Boolean; override;
    function  ArrangeText(const S: String): String; override;

    function  CanPasteStr(var S: String): Boolean; override;
    procedure FocusChanged; override;

    function  IsValidText: Boolean;
    function  GetFloatText: String;

    procedure UpdateValueFromText; override;
    function  GetUnFloatValue: Double; dynamic;
    function  GetFloatValue: Double; virtual;

    procedure InsertChar(Ch: Char); override;
    procedure OverwriteChar(Ch: Char); override;

    procedure DoButtonClick(Btn: TSCEditButton); override;
    procedure DoPageUp(var Key: Word); override;
    procedure DoPageDown(var Key: Word); override;

    function  CanSpin(AsUp: Boolean): Boolean; override;
    procedure SpinControl; override;
    function  CanSetValue(var Value: Double): Boolean; dynamic;

    procedure CheckEmpty; override;
    function  CheckValue(Value: Double): Double; dynamic;

    property AllowEmpty: Boolean read FAllowEmpty write SetAllowEmpty default False;
    property CurrencySymbol: String read FCurrencySymbol write SetCurrencySymbol;
    property DecimalPlaces: Integer read FDecimalPlaces write SetDecimalPlaces default -1;
    property EditFormat: TSCCurrenyEditFormat read FEditFormat write SetEditFormat default sccfCurrency;
    property FloatValue: Double read GetFloatValue write SetFloatValue stored True;
    property Increment: Double read FIncrement write SetIncrement stored IsIncrementStored;
    property LargeIncrement: Double read FLargeIncrement write SetLargeIncrement stored IsLargeIncrementStored;
    property MinValue: Double read FMinValue write SetMinValue stored IsMinValueStored;
    property MaxValue: Double read FMaxValue write SetMaxValue stored IsMaxValueStored;
    property UseNegativeCurrency: Boolean read FUseNegativeCurrency write SetUseNegativeCurrency default True;
    property UseThousandsSeparator: Boolean read FUseThousandsSeparator
      write SetUseThousandsSeparator default True;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    function  IsEmpty: Boolean; override;
    procedure SetEmpty; override;
  end;

  TSCCurrencySpinEdit = class(TSCCustomCurrencyEdit)
  public
    property Text;
  published
    property Align;
    property Alignment;
    property AllowEmpty;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BorderProps;
    property ButtonProps;
    property CanEdit;
    property CanSelect;
    property CharCase;
    property Checkbox;
    property Color;
    property Colors;
    property Constraints;
    property CurrencySymbol;
    property DecimalPlaces;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EditCursor;
    property EditMode;
    property Enabled;
    property EditFormat;
    property EnterAsTab;
    property FocusExpandSize;
    property Font;
    property HideSelection;
    property ImageIndex;
    property Images;
    property Increment;
    property KeySpin;
    property Layout;
    property LargeIncrement;
    property FloatValue;
    property MinValue;
    property MaxLength;
    property MaxValue;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseCaret;
    property UseImage;
    property UseUndo;
    property UseNegativeCurrency;
    property UseThousandsSeparator;
    property UndoLimit;
    property Visible;
    property OnCaretMove;
    property OnCanResize;
    property OnChange;
    property OnCheckboxChange;
    property OnClick;
    property OnClipCut;
    property OnClipCopy;
    property OnClipPaste;
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
    property OnFocusChanged;
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

type
  TSCFakeControl = class(TControl);
  TSCFakeButton = class(TSCEditButton);
  TSCSpinButton = class(TSCEditButton);

const
  SC_SPIN_REPEATTIMERID = 54321;
  CM_CANCEL = WM_USER + $9876;
  
{ TSCCustomSpinButtonProps }

procedure TSCCustomSpinButtonProps.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomSpinButtonProps then
  begin
    with TSCCustomSpinButtonProps(Source) do
    begin
      Self.ArrowColor := ArrowColor;
      Self.Color := Color;
      Self.HomeEndButtons := HomeEndButtons;
      Self.SideBySide := SideBySide;
      Self.Visible := Visible;
    end;
  end;
end;

function TSCCustomSpinButtonProps.GetArrowColor: TColor;
begin
  Result := clBtnText;
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    Result := TSCCustomSpinEdit(Owner).ButtonArrowColor;
end;

function TSCCustomSpinButtonProps.GetColor: TColor;
begin
  Result := clBtnText;
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    Result := TSCCustomSpinEdit(Owner).ButtonColor;
end;

function TSCCustomSpinButtonProps.GetHomeEndButtons: Boolean;
begin
  Result := False;
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    Result := TSCCustomSpinEdit(Owner).HomeEndButtons;
end;

function TSCCustomSpinButtonProps.GetSideBySide: Boolean;
begin
  Result := False;
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    Result := TSCCustomSpinEdit(Owner).ButtonsSideBySide;
end;

function TSCCustomSpinButtonProps.GetVisible: Boolean;
begin
  Result := True;
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    Result := TSCCustomSpinEdit(Owner).ButtonsVisible;
end;

procedure TSCCustomSpinButtonProps.SetArrowColor(Value: TColor);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    TSCCustomSpinEdit(Owner).ButtonArrowColor := Value;
end;

procedure TSCCustomSpinButtonProps.SetColor(Value: TColor);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    TSCCustomSpinEdit(Owner).ButtonColor := Value;
end;

procedure TSCCustomSpinButtonProps.SetHomeEndButtons(Value: Boolean);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    TSCCustomSpinEdit(Owner).HomeEndButtons := Value;
end;

procedure TSCCustomSpinButtonProps.SetSideBySide(Value: Boolean);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    TSCCustomSpinEdit(Owner).ButtonsSideBySide := Value;
end;

procedure TSCCustomSpinButtonProps.SetVisible(Value: Boolean);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    TSCCustomSpinEdit(Owner).ButtonsVisible := Value;
end;

{ TSCCustomSpinEdit }

function TSCCustomSpinEdit.AdjustImageTop(ImgTop: Integer): Integer;
begin
  Result := IndentTop;
  if Result = 0 then
    Result := 1;
end;

procedure TSCCustomSpinEdit.AfterConstruction;
begin
  inherited AfterConstruction;
  CheckEmpty;
end;

procedure TSCCustomSpinEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomSpinEdit then
  begin
    with TSCCustomSpinEdit(Source) do
    begin
      Self.ButtonArrowColor := ButtonArrowColor;
      Self.ButtonColor := ButtonColor;
      Self.ButtonsSideBySide := ButtonsSideBySide;
      Self.ButtonsVisible := ButtonsVisible;
      Self.HomeEndButtons := HomeEndButtons;
      Self.KeySpin := KeySpin;
      Self.DropDownProps := DropDownProps;
    end;
  end;
end;

procedure TSCCustomSpinEdit.BeforeExit;
begin
  inherited BeforeExit;
  UpdateValueFromText;
end;

function TSCCustomSpinEdit.CanDoKeySpin: Boolean;
begin
  Result := FKeySpin and not ReadOnly;
end;

function TSCCustomSpinEdit.CanExecuteHomeEndKeys: Boolean;
begin
  Result := HomeEndButtons;
end;

function TSCCustomSpinEdit.CanSpin(AsUp: Boolean): Boolean;
var
  DownBtn: TSCEditButton;
begin
  DownBtn := GetDownButton;
  Result := Enabled and (DownBtn <> nil) and not Readonly and
    ((AsUp and (DownBtn = FUpButton)) or (not AsUp and (DownBtn = FDownButton)));
end;

procedure TSCCustomSpinEdit.CheckEmpty;
begin
  //
end;

constructor TSCCustomSpinEdit.Create(AOwner: TComponent);
begin
  FSpinTimer := -1;
  FButtonsSideBySide := False;

  inherited Create(AOwner);
  SetBounds(Left, Top, 121, Height);

  UseUndo := False;

  FKeySpin := True;

  FDropDownButton := TSCSpinDropDownButton.Create(Self);
  FDropDownProps := TSCSpinDropDownButtonProps.Create(Self);

  FDownButton := GetButtonClass.Create(Self);
  TSCSpinButton(FDownButton).Name := 'down_button';

  FUpButton   := GetButtonClass.Create(Self);
  TSCSpinButton(FUpButton).Name := 'up_button';

  FHomeButton := GetButtonClass.Create(Self);
  with TSCSpinButton(FHomeButton) do
  begin
    Name := 'home_button';
    Visible := False;
  end;  

  FEndButton  := GetButtonClass.Create(Self);
  with TSCSpinButton(FEndButton) do
  begin
    Name := 'end_button';
    Visible  := False;
  end;  

  TSCSpinButton(FUpButton).DropUp := True;
  StyleChanged;
end;

destructor TSCCustomSpinEdit.Destroy;
begin
  FreeAndNil(FDropDownProps);
  inherited Destroy;
end;

procedure TSCCustomSpinEdit.DoButtonClick(Btn: TSCEditButton);
var
  DownBtn, HotBtn: TSCEditButton;
begin
  if Btn = FDropDownButton then
  begin
    if Assigned(FOnDropDownClick) then
      FOnDropDownClick(Self);
    Exit;
  end;

  DownBtn := GetDownButton;
  if DownBtn <> nil then
  begin
    HotBtn := GetHotButton;
    if DownBtn = HotBtn then
      StartSpining;
  end;
end;

procedure TSCCustomSpinEdit.DoButtonHotChanged(Btn: TSCEditButton);
var
  DownBtn, HotBtn: TSCEditButton;
begin
  DownBtn := GetDownButton;

  if (DownBtn <> nil) and (Spining or SpinPaused) then
  begin
    HotBtn := GetHotButton;
    if DownBtn = HotBtn then
      ResumeSpining
    else
      PauseSpining;
  end;
end;

procedure TSCCustomSpinEdit.DoButtonUp(Btn: TSCEditButton);
begin
  StopSpining;
end;

procedure TSCCustomSpinEdit.DoPageDown(var Key: Word);
begin
  //
end;

procedure TSCCustomSpinEdit.DoPageUp(var Key: Word);
begin
  //
end;

function TSCCustomSpinEdit.GetButtonArrowColor: TColor;
begin
  Result := clBtnText;
  if FUpButton <> nil then
    Result := TSCSpinButton(FUpButton).ArrowColor;
end;

function TSCCustomSpinEdit.GetButtonClass: TSCEditButtonClass;
begin
  Result := TSCDropDownButton;
end;

function TSCCustomSpinEdit.GetButtonColor: TColor;
begin
  Result := clBtnFace;
  if FUpButton <> nil then
    Result := TSCSpinButton(FUpButton).Color;
end;

function TSCCustomSpinEdit.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCIntSpinButtonProps;
end;

function TSCCustomSpinEdit.GetButtonRect(Btn: TSCEditButton): TRect;
var
  R: TRect;
  I, H: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated and (Btn <> nil) and TSCFakeButton(Btn).Visible then
  begin
    if Btn = FDropDownButton then
    begin
      R := GetInnerEditRect;

      if IsRectEmpty(R) then
        R.Left := R.Right
      else begin
        R.Left := R.Right - FDropDownButton.GetWidth;

        if ButtonInsideFrame and not IsRectEmpty(R) then
        begin
          I := 0;

          if Style in [scesSingle, scesNew, scesExtreme,
            scesWinXP, scesDoubleNew] then
            I := 1
          else
          if Style in [scesOfficeXP, scesOffice12, scesOffice2003] then
            I := 2;

          OffsetRect(R, I, 0);
          InflateRect(R, 0, I);
        end;
      end;

      Result := R;
    end else
    if ((Btn = FUpButton) or (Btn = FDownButton)) then
    begin
      R := GetInnerEditRect;
      
      if (FDropDownButton <> nil) and TSCFakeButton(FDropDownButton).Visible then
        Dec(R.Right, FDropDownButton.GetWidth);

      if IsRectEmpty(R) then
        R.Left := R.Right
      else begin
        R.Left := R.Right - FUpButton.GetWidth;

        if ButtonInsideFrame and not IsRectEmpty(R) then
        begin
          I := 0;

          if Style in [scesSingle, scesNew, scesExtreme,
            scesWinXP, scesDoubleNew] then
            I := 1
          else
          if Style in [scesOfficeXP, scesOffice12, scesOffice2003] then
            I := 2;

          OffsetRect(R, I, 0);
          InflateRect(R, 0, I);
        end;
      end;

      Result := R;

      if not FButtonsSideBySide then
      begin
        H := R.Bottom - R.Top;
        if H < 0 then H := 0;

        H := H div 2;

        if Btn = FUpButton then
          Result.Bottom := Result.Top + H
        else
          Inc(Result.Top, H);
      end else
      if Btn = FDownButton then
        OffsetRect(Result, -(Result.Right - Result.Left), 0);
    end;
  end;
end;

function TSCCustomSpinEdit.GetButtonsVisible: Boolean;
begin
  Result := ((FUpButton <> nil) and TSCSpinButton(FUpButton).Visible) or
    ((FDownButton <> nil) and TSCSpinButton(FDownButton).Visible);
end;

function TSCCustomSpinEdit.GetDropDownArrowColor: TColor;
begin
  Result := clBtnText;
  if FDropDownButton <> nil then
    Result := TSCSpinDropDownButton(FDropDownButton).ArrowColor;
end;

function TSCCustomSpinEdit.GetDropDownColor: TColor;
begin
  Result := clBtnFace;
  if FDropDownButton <> nil then
    Result := TSCSpinDropDownButton(FDropDownButton).Color;
end;

function TSCCustomSpinEdit.GetDropDownVisible: Boolean;
begin
  Result := False;
  if FDropDownButton <> nil then
    Result := TSCSpinDropDownButton(FDropDownButton).Visible;
end;

function TSCCustomSpinEdit.GetHomeEndButtons: Boolean;
begin
  Result := ((FHomeButton <> nil) and TSCSpinButton(FHomeButton).Visible) or
    ((FEndButton <> nil) and TSCSpinButton(FEndButton).Visible);
end;

function TSCCustomSpinEdit.GetSliderHeight(R: TRect; IsUp: Boolean): Integer;
var
  W: Integer;
begin
  InflateRect(R, -2, -2);

  Result := R.Bottom - R.Top;
  W := R.Right - R.Left;

  if W < Result then Result := W;

  Result := Result div 2;

  if Result < 0 then Result := 0;
  if Result > 2 then Result := 2;
end;

function TSCCustomSpinEdit.GetSliderPos(R: TRect; IsUp: Boolean): TPoint;
var
  H: Integer;
begin
  Result.x := R.Left + ((R.Right - R.Left) div 2);
  Result.y := R.Top  + ((R.Bottom - R.Top) div 2) - 2;

  if not IsUp then
  begin
    H := GetSliderHeight(R, IsUp);
    Result.y := R.Top  + ((R.Bottom - R.Top + H) div 2);
  end;
end;

function TSCCustomSpinEdit.IsEmpty: Boolean;
begin
  Result := Text <> '';
end;

procedure TSCCustomSpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  DoKeySpin: Boolean;
  Btn: TSCEditButton;
begin
  DoKeySpin := CanDoKeySpin;

  if DoKeySpin and (Key in [VK_UP, VK_DOWN]) then
  begin
    Btn := FUpButton;
    if Key = VK_DOWN then
      Btn := FDownButton;

    Key := 0;
    DoButtonClick(Btn);

    Exit;
  end;

  if DoKeySpin and (Key in [VK_HOME, VK_END]) and CanExecuteHomeEndKeys then
  begin
    Btn := FHomeButton;
    if Key = VK_END then
      Btn := FEndButton;

    Key := 0;
    DoButtonClick(Btn);

    Exit;
  end;

  if DoKeySpin and (Key = VK_PRIOR) then
  begin
    DoPageUp(Key);
    if Key = 0 then
      Exit;
  end else
  if DoKeySpin and (Key = VK_NEXT) then
  begin
    DoPageDown(Key);
    if Key = 0 then
      Exit;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomSpinEdit.Loaded;
begin
  inherited Loaded;
  CheckEmpty;
end;

procedure TSCCustomSpinEdit.PauseSpining;
begin
  FSpining := False;
end;

procedure TSCCustomSpinEdit.ResumeSpining;
begin
  FSpining := (FSpinTimer <> -1) and (CanSpin(True) or CanSpin(False));
end;

procedure TSCCustomSpinEdit.SetButtonArrowColor(Value: TColor);
begin
  if FUpButton <> nil then
    TSCSpinButton(FUpButton).ArrowColor := Value;
  if FDownButton <> nil then
    TSCSpinButton(FDownButton).ArrowColor := Value;
  if FDropDownButton <> nil then
    TSCFakeButton(FDropDownButton).ArrowColor := Value;
end;

procedure TSCCustomSpinEdit.SetButtonColor(Value: TColor);
begin
  if FUpButton <> nil then
    TSCSpinButton(FUpButton).Color := Value;
  if FDownButton <> nil then
    TSCSpinButton(FDownButton).Color := Value;
  if FDropDownButton <> nil then
    TSCFakeButton(FDropDownButton).Color := Value;
end;

procedure TSCCustomSpinEdit.SetButtonsSideBySide(Value: Boolean);
begin
  if FButtonsSideBySide <> Value then
  begin
    FButtonsSideBySide := Value;
    if GetButtonsVisible then
      StyleChanged;
  end;
end;

procedure TSCCustomSpinEdit.SetButtonsVisible(Value: Boolean);
begin
  if GetButtonsVisible <> Value then
  begin
    if FUpButton <> nil then
      TSCSpinButton(FUpButton).Visible := Value;
    if FDownButton <> nil then
      TSCSpinButton(FDownButton).Visible := Value;

    Invalidate;
  end;
end;

procedure TSCCustomSpinEdit.SetDropDownArrowColor(Value: TColor);
begin
  if FDropDownButton <> nil then
    TSCSpinDropDownButton(FDropDownButton).ArrowColor := Value;
end;

procedure TSCCustomSpinEdit.SetDropDownButton(Value: TSCSpinDropDownButton);
begin
  FDropDownButton.Assign(Value);
end;

procedure TSCCustomSpinEdit.SetDropDownColor(Value: TColor);
begin
  if FDropDownButton <> nil then
    TSCSpinDropDownButton(FDropDownButton).Color := Value;
end;

procedure TSCCustomSpinEdit.SetDropDownProps(
  Value: TSCSpinDropDownButtonProps);
begin
  FDropDownProps.Assign(Value);
end;

procedure TSCCustomSpinEdit.SetDropDownVisible(Value: Boolean);
begin
  if FDropDownButton <> nil then
    TSCSpinDropDownButton(FDropDownButton).Visible := Value;
end;

procedure TSCCustomSpinEdit.SetEmpty;
begin
  SetText('');
end;

procedure TSCCustomSpinEdit.SetHomeEndButtons(Value: Boolean);
begin
  if GetHomeEndButtons <> Value then
  begin
    if FHomeButton <> nil then
      TSCSpinButton(FHomeButton).Visible := Value;
    if FEndButton <> nil then
      TSCSpinButton(FEndButton).Visible := Value;

    Invalidate;
  end;
end;

procedure TSCCustomSpinEdit.SpinControl;
begin
  //
end;

function TSCCustomSpinEdit.Spining: Boolean;
begin
  Result := FSpining and MouseInControl and
    (FSpinTimer <> -1) and (CanSpin(True) or CanSpin(False));
end;

function TSCCustomSpinEdit.SpinPaused: Boolean;
begin
  Result := not (FSpining and Enabled and MouseInControl) and
    (FSpinTimer <> -1) and (CanSpin(True) or CanSpin(False));
end;

procedure TSCCustomSpinEdit.StartSpining;
var
  DownBtn: TSCEditButton;
begin
  if HandleAllocated and (CanSpin(True) or CanSpin(False)) then
  begin
    if SpinPaused then
    begin
      ResumeSpining;
      Exit;
    end;

    if not Spining then
    begin
      DownBtn := GetDownButton;
      StopSpining;

      if DownBtn <> nil then
        TSCSpinButton(DownBtn).ButtonDown := True;

      FSpinTimer := SetTimer(Handle, SC_SPIN_REPEATTIMERID, scDblClickTime, nil);
      FSpining := FSpinTimer <> -1;
    end;
  end;
end;

procedure TSCCustomSpinEdit.StopSpining;
var
  DownBtn: TSCEditButton;
begin
  DownBtn := GetDownButton;
  if DownBtn <> nil then
    TSCSpinButton(DownBtn).ButtonDown := False;

  if HandleAllocated and (FSpinTimer <> -1) then
  begin
    if HandleAllocated then
      KillTimer(Handle, FSpinTimer);

    FSpinTimer := -1;
  end;
end;

procedure TSCCustomSpinEdit.StopTracking;
begin
  StopSpining;
  inherited StopTracking;
end;

procedure TSCCustomSpinEdit.UpdateBorderRect(var R: TRect);
var
  Sw, W: Integer;
  IsDropDown: Boolean;
begin
  inherited UpdateBorderRect(R);

  IsDropDown := False;

  if (FDropDownButton <> nil) and TSCFakeButton(FDropDownButton).Visible then
  begin
    IsDropDown := True;
    Inc(R.Right, FDropDownButton.GetWidth + 1);
  end;

  if GetButtonsVisible then
  begin
    W := 0;
    Sw := GetSystemMetrics(SM_CXVSCROLL);

    if FUpButton <> nil then
      Inc(W, FUpButton.GetWidth)
    else
      Inc(W, Sw);

    if FButtonsSideBySide then
    begin
      if FDownButton <> nil then
        Inc(W, FDownButton.GetWidth)
      else
        Inc(W, Sw);
    end;
    
    Inc(R.Right, W);
    
    if not IsDropDown then
      Inc(R.Right);
  end;
end;

procedure TSCCustomSpinEdit.UpdateValueFromText;
begin
  //
end;

procedure TSCCustomSpinEdit.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if Message.WheelDelta < 0 then
    DoButtonClick(FDownButton)
  else
  if Message.WheelDelta > 0 then
    DoButtonClick(FUpButton);
end;

procedure TSCCustomSpinEdit.WMTimer(var Message: TWMTimer);
begin
  inherited;

  if HandleAllocated and Spining and
    (Message.TimerID = SC_SPIN_REPEATTIMERID) then
  begin
    if FSpinTimer <> -1 then
      KillTimer(Handle, FSpinTimer);

    FSpinTimer := SetTimer(Handle, SC_SPIN_REPEATTIMERID, 100, nil);
    FSpining   := FSpinTimer <> -1;

    SpinControl;
  end;
end;

{ TSCSpinnerButton }

constructor TSCSpinnerButton.Create(AOwner: TSCCustomButtonFrame);
begin
  inherited Create(AOwner);
  Style := scebCustom;
end;

{ TSCCustomNavButtonProps }

procedure TSCCustomNavButtonProps.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomNavButtonProps then
    with TSCCustomNavButtonProps(Source) do
    begin
      Self.DownImage := DownImage;
      Self.EndImage := EndImage;
      Self.HomeEndLayout := HomeEndLayout;
      Self.HomeImage := HomeImage;
      Self.Layout := Layout;
      Self.Style := Style;
      Self.UpImage := UpImage;
      Self.Width := Width;
    end;
end;

function TSCCustomNavButtonProps.GetDownImage: TImageIndex;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    Result := TSCCustomNavEdit(Owner).ButtonDownImage;
end;

function TSCCustomNavButtonProps.GetEndImage: TImageIndex;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    Result := TSCCustomNavEdit(Owner).ButtonEndImage;
end;

function TSCCustomNavButtonProps.GetHomeEndLayout: TSCSpinnerLayout;
begin
  Result := scslLeftRight;
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    Result := TSCCustomNavEdit(Owner).HomeEndLayout;
end;

function TSCCustomNavButtonProps.GetHomeImage: TImageIndex;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    Result := TSCCustomNavEdit(Owner).ButtonHomeImage;
end;

function TSCCustomNavButtonProps.GetLayout: TSCSpinnerLayout;
begin
  Result := scslLeftRight;
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    Result := TSCCustomNavEdit(Owner).ButtonLayout;
end;

function TSCCustomNavButtonProps.GetStyle: TSCSpinnerStyle;
begin
  Result := scssMinusPlus;
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    Result := TSCCustomNavEdit(Owner).ButtonStyle;
end;

function TSCCustomNavButtonProps.GetUpImage: TImageIndex;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    Result := TSCCustomNavEdit(Owner).ButtonUpImage;
end;

function TSCCustomNavButtonProps.GetWidth: Integer;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    Result := TSCCustomNavEdit(Owner).ButtonWidth;
end;

procedure TSCCustomNavButtonProps.SetDownImage(Value: TImageIndex);
begin
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    TSCCustomNavEdit(Owner).ButtonDownImage := Value;
end;

procedure TSCCustomNavButtonProps.SetEndImage(Value: TImageIndex);
begin
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    TSCCustomNavEdit(Owner).ButtonEndImage := Value;
end;

procedure TSCCustomNavButtonProps.SetHomeEndLayout(
  Value: TSCSpinnerLayout);
begin
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    TSCCustomNavEdit(Owner).HomeEndLayout := Value;
end;

procedure TSCCustomNavButtonProps.SetHomeImage(Value: TImageIndex);
begin
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    TSCCustomNavEdit(Owner).ButtonHomeImage := Value;
end;

procedure TSCCustomNavButtonProps.SetLayout(Value: TSCSpinnerLayout);
begin
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    TSCCustomNavEdit(Owner).ButtonLayout := Value;
end;

procedure TSCCustomNavButtonProps.SetStyle(Value: TSCSpinnerStyle);
begin
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    TSCCustomNavEdit(Owner).ButtonStyle := Value;
end;

procedure TSCCustomNavButtonProps.SetUpImage(Value: TImageIndex);
begin
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    TSCCustomNavEdit(Owner).ButtonUpImage := Value;
end;

procedure TSCCustomNavButtonProps.SetWidth(Value: Integer);
begin
  if (Owner <> nil) and (Owner is TSCCustomNavEdit) then
    TSCCustomNavEdit(Owner).ButtonWidth := Value;
end;

{ TSCCustomNavEdit }

procedure TSCCustomNavEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomNavEdit then
  begin
    with TSCCustomNavEdit(Source) do
    begin
      Self.ButtonDownImage := ButtonDownImage;
      Self.ButtonEndImage := ButtonEndImage;
      Self.ButtonHomeImage := ButtonHomeImage;
      Self.ButtonLayout := ButtonLayout;
      Self.ButtonStyle := ButtonStyle;
      Self.ButtonUpImage := ButtonUpImage;
      Self.ButtonWidth := ButtonWidth;
      Self.HomeEndLayout := HomeEndLayout;
    end;
  end;
end;

procedure TSCCustomNavEdit.ButtonChanged(Sender: TObject);
begin
  if FInStyleChange then
  begin
    FNeedRepaint := True;
    Exit;
  end;

  if (Sender <> nil) and (Sender is TSCEditButton) and
    (TSCEditButton(Sender).Owner = Self) and not IsLoading then
  begin
    FInStyleChange := True;
    try
      TSCSpinButton(Sender).Style := scebCustom;

      case FButtonLayout of
        scslLeft:
        begin
          if FUpButton <> nil then
            TSCSpinButton(FUpButton).Align   := taLeftJustify;

          if FDownButton <> nil then
            TSCSpinButton(FDownButton).Align := taLeftJustify;
        end;
        scslRight:
        begin
          if FUpButton <> nil then
            TSCSpinButton(FUpButton).Align := taRightJustify;

          if FDownButton <> nil then
            TSCSpinButton(FDownButton).Align := taRightJustify;
        end;
        scslLeftRight:
        begin
          if FUpButton <> nil then
            TSCSpinButton(FUpButton).Align := taRightJustify;

          if FDownButton <> nil then
            TSCSpinButton(FDownButton).Align := taLeftJustify;
        end;
      end;

      case FHomeEndLayout of
        scslLeft:
        begin
          if FHomeButton <> nil then
            TSCSpinButton(FHomeButton).Align := taLeftJustify;

          if FEndButton <> nil then
            TSCSpinButton(FEndButton).Align := taLeftJustify;
        end;
        scslRight:
        begin
          if FHomeButton <> nil then
            TSCSpinButton(FHomeButton).Align := taRightJustify;

          if FEndButton <> nil then
            TSCSpinButton(FEndButton).Align := taRightJustify;
        end;
        scslLeftRight:
        begin
          if FHomeButton <> nil then
            TSCSpinButton(FHomeButton).Align := taLeftJustify;

          if FEndButton <> nil then
            TSCSpinButton(FEndButton).Align := taRightJustify;
        end;
      end;

      StyleChanged;
    finally
      FInStyleChange := False;
      if FNeedRepaint then
        Invalidate;
    end;
  end;
end;

function TSCCustomNavEdit.CanSpin(AsUp: Boolean): Boolean;
begin
  Result := inherited CanSpin(AsUp);
  if Assigned(FOnCanRepeat) then
    FOnCanRepeat(Self, AsUp, Result);
end;

procedure TSCCustomNavEdit.CheckKeyDown(var Key: Word;
  Shift: TShiftState);
begin
  if not IsMasked and (Key = VK_RETURN) then
    SetText(ArrangeText(Self.Text));
end;

constructor TSCCustomNavEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Alignment := taCenter;
  SetBounds(Left, Top, 95, Height);

  FButtonLayout  := scslLeftRight;
  FButtonStyle   := scssMinusPlus;
  FHomeEndLayout := scslLeftRight;

  with TSCSpinButton(FUpButton) do
  begin
    Style := scebCustom;
    Align := taRightJustify;
  end;

  with TSCSpinButton(FDownButton) do
  begin
    Style := scebCustom;
    DropUp := False;
    Align := taLeftJustify;
  end;

  with TSCSpinButton(FEndButton) do
  begin
    Style := scebCustom;
    Align := taRightJustify;
  end;

  with TSCSpinButton(FHomeButton) do
  begin
    Style := scebCustom;
    DropUp := False;
    Align := taLeftJustify;
  end;

  StyleChanged;
end;

procedure TSCCustomNavEdit.DoButtonClick(Btn: TSCEditButton);
begin
  if Assigned(FOnButtonClick) then
  begin
    if Btn = FUpButton then
      FOnButtonClick(Self, scnbUp)
    else
    if Btn = FDownButton then
      FOnButtonClick(Self, scnbDown)
    else
    if Btn = FHomeButton then
      FOnButtonClick(Self, scnbHome)
    else
    if Btn = FEndButton then
      FOnButtonClick(Self, scnbEnd);
  end;

  inherited DoButtonClick(Btn);
end;

procedure TSCCustomNavEdit.DoPageDown(var Key: Word);
begin
  if Assigned(FOnPageDown) then
    FOnPageDown(Self);
end;

procedure TSCCustomNavEdit.DoPageUp(var Key: Word);
begin
  if Assigned(FOnPageUp) then
    FOnPageUp(Self);
end;

function TSCCustomNavEdit.IsEmpty: Boolean;
begin
  Result := Text = '';
end;

function TSCCustomNavEdit.IsValidKey(Key: Char): Boolean;
begin
  Result := inherited IsValidKey(Key);
  if Assigned(FOnIsValidKey) then
    FOnIsValidKey(Self, Key, Result);
end;

procedure TSCCustomNavEdit.SpinControl;
var
  DoSpin: Boolean;
  DownBtn: TSCEditButton;
begin
  if not Spining or SpinPaused or not Assigned(FOnRepeat) then
    Exit;

  if CanSpin(True) then
  begin
    DoSpin := True;
    FOnRepeat(Self, True, DoSpin);

    if not DoSpin then
    begin
      DownBtn := GetDownButton;
      StopSpining;

      if DownBtn <> nil then
        TSCSpinButton(DownBtn).ButtonDown := True;

      Invalidate;
    end;
  end else
  if CanSpin(False) then
  begin
    DoSpin := True;
    FOnRepeat(Self, False, DoSpin);

    if not DoSpin then
    begin
      DownBtn := GetDownButton;
      StopSpining;

      if DownBtn <> nil then
        TSCSpinButton(DownBtn).ButtonDown := True;

      Invalidate;
    end;
  end;
end;

procedure TSCCustomNavEdit.DoCustomPaintButton(C: TCanvas; R: TRect;
  Btn: TSCEditButton; IsDown, IsHot: Boolean);
var
  Cl: TColor;
  I, H, W, L, T: Integer;
begin
  if (C <> nil) and not IsRectEmpty(R) and (Btn <> nil) and
    TSCSpinButton(Btn).Visible and (TSCSpinButton(Btn).Width <> 0) and
    (FButtonStyle <> scssCustom) and ((Btn = FDownButton) or
    (Btn = FUpButton) or (Btn = FHomeButton) or (Btn = FEndButton)) then
  begin
    Cl := TSCSpinButton(Btn).ArrowColor;

    case Style of
      scesOfficeXP:
      begin
        Cl := clBtnText;
        if (IsMouseDown or MouseInControl or Focused or
          MouseIsDown) and IsDown and IsHot then
          Cl := GetBtnHighlightOf(clBtnFace);
      end;
      scesSingle, scesDouble, scesDoubleNew:
        if IsDown and IsHot then
          Cl := GetBtnHighlightOf(TSCSpinButton(Btn).Color);
      scesWinXP:
        Cl := Get3DDkShadowOf(ExUseColor);
    end;

    H := GetSliderHeight(R, False);

    case FButtonStyle of
      scssArrow:
      begin
        if H = 0 then
          Exit;

        if (Btn = FHomeButton) or (Btn = FDownButton) then
        begin
          L := R.Left + ((R.Right - R.Left - H) div 2) - 1;
          if Btn = FHomeButton then
            Inc(L);
        end else
        begin
          L := R.Left + ((R.Right - R.Left + H) div 2);
          if Btn = FEndButton then
            Dec(L);
        end;

        T := R.Top + ((R.Bottom - R.Top) div 2) + 1;

        if IsDown and IsHot and not IsExtraFlat then
        begin
          Inc(T);
          if (Btn = FUpButton) or (Btn = FEndButton) then
            Inc(L)
          else
            Dec(L);
        end;

        if (Btn = FUpButton) or (Btn = FEndButton) then
          scDrawLeftSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl, Cl)
        else
          scDrawRightSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl, Cl);

        Dec(T, H + 1);
        if (Btn = FHomeButton) or (Btn = FEndButton) then
          with C do
          begin
            Pen.Color := Cl;
            Pen.Style := PsSolid;
            Pen.Width := 1;

            for I := 0 to 1 do
            begin
              if Btn = FHomeButton then
                Dec(L)
              else
                Inc(L);

              MoveTo(L, T);
              LineTo(L, T + 2*H + 1);
            end;
          end;
      end;
      scssImage:
      begin
        if Images <> nil then
        begin
          L := R.Left + ((R.Right - R.Left - Images.Width) div 2);
          T := R.Top + ((R.Bottom - R.Top - Images.Height) div 2);

          if IsExtraFlat then
          begin
            if IsHot and not IsDown then
            begin
              Dec(L);
              Dec(T);
            end;
          end else
          if IsDown and IsHot then
          begin
            Inc(L);
            Inc(T);
          end;

          Images.Draw(C, L, T, TSCSpinButton(Btn).Image, Self.Enabled);
        end;
      end;
      scssMinusPlus:
      begin
        if H = 0 then Exit;

        if (Btn = FHomeButton) or (Btn = FEndButton) then
        begin
          if Btn = FHomeButton then
            L := R.Left + ((R.Right - R.Left - H) div 2)
          else
            L := R.Left + ((R.Right - R.Left + H) div 2) - 1;

          T := R.Top + ((R.Bottom - R.Top) div 2) + 1;

          if IsDown and IsHot and not IsExtraFlat then
          begin
            Inc(T);
            if Btn = FEndButton then
              Inc(L)
            else
              Dec(L);
          end;

          if Btn = FEndButton then
            scDrawLeftSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl, Cl)
          else
            scDrawRightSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl, Cl);

          Dec(T, H + 1);
          with C do
          begin
            Pen.Color := Cl;
            Pen.Style := PsSolid;
            Pen.Width := 1;

            for I := 0 to 1 do
            begin
              if Btn = FHomeButton then
                Dec(L)
              else
                Inc(L);

              MoveTo(L, T);
              LineTo(L, T + 2*H + 1);
            end;
          end;
        end else
        begin
          W := 2;
          if H < 3 then W := 1;

          L := R.Left + ((R.Right - R.Left - W - 2*H) div 2);
          T := R.Top + ((R.Bottom - R.Top - W) div 2);

          if IsDown and IsHot and not IsExtraFlat then
          begin
            Inc(L);
            Inc(T);
          end;

          with C do
          begin
            Pen.Style := psSolid;
            Pen.Mode  := pmCopy;
            Pen.Width := 1;
            Pen.Color := Cl;

            MoveTo(L, T);
            LineTo(L + W + 2*H, T);

            if W = 2 then
            begin
              Inc(T);

              MoveTo(L, T);
              LineTo(L + W + 2*H, T);
            end;

            if Btn = FUpButton then
            begin
              L := R.Left + ((R.Right - R.Left - W) div 2);
              T := R.Top + ((R.Bottom - R.Top - W - 2*H) div 2);

              if IsDown and IsHot and not IsExtraFlat then
              begin
                Inc(L);
                Inc(T);
              end;

              MoveTo(L, T);
              LineTo(L, T + W + 2*H);

              if W = 2 then
              begin
                Inc(L);

                MoveTo(L, T);
                LineTo(L, T + W + 2*H);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TSCCustomNavEdit.GetButtonClass: TSCEditButtonClass;
begin
  Result := TSCSpinnerButton;
end;

function TSCCustomNavEdit.GetButtonDownImage: TImageIndex;
begin
  Result := -1;
  if FDownButton <> nil then
    Result := TSCSpinButton(FDownButton).Image;
end;

function TSCCustomNavEdit.GetButtonEndImage: TImageIndex;
begin
  Result := -1;
  if FEndButton <> nil then
    Result := TSCSpinButton(FEndButton).Image;
end;

function TSCCustomNavEdit.GetButtonHomeImage: TImageIndex;
begin
  Result := -1;
  if FHomeButton <> nil then
    Result := TSCSpinButton(FHomeButton).Image;
end;

function TSCCustomNavEdit.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCNavButtonProps;
end;

function TSCCustomNavEdit.GetButtonRect(Btn: TSCEditButton): TRect;
var
  R, Cr: TRect;
  I, W: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated and (Btn <> nil) and
    (TSCSpinButton(Btn).Owner = Self) and TSCSpinButton(Btn).Visible then
  begin
    R := GetInnerEditRect;
    W := FUpButton.GetWidth;

    if CheckboxVisible then
    begin
      Cr := GetCheckboxRect;
      if Cr.Right < Cr.Left then
        Cr.Right := Cr.Left;

      Inc(R.Left, Cr.Right);  
    end;

    I := 0;
    if Style in [scesSingle, scesNew,
      scesExtreme, scesWinXP, scesDoubleNew] then
      I := 1
    else
    if Style in [scesOfficeXP, scesOffice12, scesOffice2003] then
      I := 2;

    if (Btn <> FHomeButton) and (Btn <> FEndButton) and HomeEndButtons then
    begin
      case FHomeEndLayout of
        scslLeft:
          Inc(R.Left, 2*W);
        scslRight:
          Dec(R.Right, 2*W);
        scslLeftRight:
          InflateRect(R, -W, 0);
      end;
    end;

    Result := R;

    if IsRectEmpty(Result) then
    begin
      Result.Left := Result.Right;
      Exit;
    end;

    if Btn = FHomeButton then
    begin
      if FHomeEndLayout = scslRight then
      begin
        Dec(Result.Right, W);
        Result.Left := Result.Right - W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, I, 0);
          InflateRect(Result, 0, I);
        end;
      end else
      begin
        Result.Right := Result.Left + W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, -I, 0);
          InflateRect(Result, 0, I);
        end;
      end;
    end else
    if Btn = FEndButton then
    begin
      if FHomeEndLayout = scslLeft then
      begin
        Inc(Result.Left, W);
        Result.Right := Result.Left + W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, -I, 0);
          InflateRect(Result, 0, I);
        end;
      end else
      begin
        Result.Left := Result.Right - W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, I, 0);
          InflateRect(Result, 0, I);
        end;
      end;
    end else
    if Btn = FUpButton then
    begin
      if FButtonLayout = scslLeft then
      begin
        Inc(Result.Left, W);
        Result.Right := Result.Left + W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, -I, 0);
          InflateRect(Result, 0, I);
        end;
      end else
      begin
        Result.Left := Result.Right - W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, I, 0);
          InflateRect(Result, 0, I);
        end;
      end;
    end else
    if Btn = FDownButton then
    begin
      if FButtonLayout = scslRight then
      begin
        Dec(Result.Right, W);
        Result.Left := Result.Right - W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, I, 0);
          InflateRect(Result, 0, I);
        end;
      end else
      begin
        Result.Right := Result.Left + W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, -I, 0);
          InflateRect(Result, 0, I);
        end;
      end;
    end;

    if IsRectEmpty(Result) then
      Result.Left := Result.Right;
  end;
end;

function TSCCustomNavEdit.GetButtonUpImage: TImageIndex;
begin
  Result := -1;
  if FUpButton <> nil then
    Result := TSCSpinButton(FUpButton).Image;
end;

function TSCCustomNavEdit.GetButtonWidth: Integer;
begin
  Result := -1;
  if FUpButton <> nil then
    Result := TSCSpinButton(FUpButton).Width;
end;

function TSCCustomNavEdit.GetSliderHeight(R: TRect; IsUp: Boolean): Integer;
var
  W: Integer;
begin
  InflateRect(R, -3, -3);

  Result := R.Bottom - R.Top;
  W := R.Right - R.Left;

  if W < Result then Result := W;

  Result := Result div 2;

  if Result < 0 then Result := 0;
  if Result > 4 then Result := 4;
end;

procedure TSCCustomNavEdit.SetButtonDownImage(Value: TImageIndex);
begin
  if FDownButton <> nil then
    TSCSpinButton(FDownButton).Image := Value;
end;

procedure TSCCustomNavEdit.SetButtonEndImage(Value: TImageIndex);
begin
  if FEndButton <> nil then
    TSCSpinButton(FEndButton).Image := Value;
end;

procedure TSCCustomNavEdit.SetButtonHomeImage(Value: TImageIndex);
begin
  if FHomeButton <> nil then
    TSCSpinButton(FHomeButton).Image := Value;
end;

procedure TSCCustomNavEdit.SetButtonLayout(Value: TSCSpinnerLayout);
begin
  if FButtonLayout <> Value then
  begin
    FButtonLayout := Value;

    ButtonChanged(FUpButton);
    ButtonChanged(FDownButton);
  end;
end;

procedure TSCCustomNavEdit.SetButtonStyle(Value: TSCSpinnerStyle);
begin
  if FButtonStyle <> Value then
  begin
    FButtonStyle := Value;
    StyleChanged;
  end;
end;

procedure TSCCustomNavEdit.SetButtonUpImage(Value: TImageIndex);
begin
  if FUpButton <> nil then
    TSCSpinButton(FUpButton).Image := Value;
end;

procedure TSCCustomNavEdit.SetButtonWidth(Value: Integer);
begin
  if FUpButton <> nil then
    TSCSpinButton(FUpButton).Width := Value;
  if FDownButton <> nil then
    TSCSpinButton(FDownButton).Width := Value;
end;

procedure TSCCustomNavEdit.SetHomeEndLayout(Value: TSCSpinnerLayout);
begin
  if FHomeEndLayout <> Value then
  begin
    FHomeEndLayout := Value;

    ButtonChanged(FHomeButton);
    ButtonChanged(FEndButton);
  end;
end;

procedure TSCCustomNavEdit.UpdateBorderRect(var R: TRect);
var
  W: Integer;
begin
  if ButtonsVisible or HomeEndButtons then
  begin
    if FUpButton <> nil then
      W := FUpButton.GetWidth
    else
      W := GetSystemMetrics(SM_CXVSCROLL);

    Inc(W);

    case FHomeEndLayout of
      scslLeft:
      begin
        if (FHomeButton <> nil) and TSCSpinButton(FHomeButton).Visible then
          Inc(R.Left, W);
        if (FEndButton <> nil) and TSCSpinButton(FEndButton).Visible then
          Inc(R.Left, W);
      end;
      scslRight:
      begin
        if (FHomeButton <> nil) and TSCSpinButton(FHomeButton).Visible then
          Inc(R.Right, W);
        if (FEndButton <> nil) and TSCSpinButton(FEndButton).Visible then
          Inc(R.Right, W);
      end;
      scslLeftRight:
      begin
        if (FHomeButton <> nil) and TSCSpinButton(FHomeButton).Visible then
          Inc(R.Left, W);
        if (FEndButton <> nil) and TSCSpinButton(FEndButton).Visible then
          Inc(R.Right, W);
      end;
    end;

    case FButtonLayout of
      scslLeft:
      begin
        if (FUpButton <> nil) and TSCSpinButton(FUpButton).Visible then
          Inc(R.Left, W);
        if (FDownButton <> nil) and TSCSpinButton(FDownButton).Visible then
          Inc(R.Left, W);
      end;
      scslRight:
      begin
        if (FUpButton <> nil) and TSCSpinButton(FUpButton).Visible then
          Inc(R.Right, W);
        if (FDownButton <> nil) and TSCSpinButton(FDownButton).Visible then
          Inc(R.Right, W);
      end;
      scslLeftRight:
      begin
        if (FUpButton <> nil) and TSCSpinButton(FUpButton).Visible then
          Inc(R.Right, W);
        if (FDownButton <> nil) and TSCSpinButton(FDownButton).Visible then
          Inc(R.Left, W);
      end;
    end;
  end;
end;

{ TSCCustomIntSpinEdit }

function TSCCustomIntSpinEdit.AddNegativeSymbol(const S: String): String;
begin
  Result := Trim(S);
  if (Result = '') or (Result = '0') then
    Exit;

  case scNegativeFormat of
    // (1,1)
    0: Result := Format('(%s)',  [Result]);
    // -1,1
    1: Result := Format('%s%s',  [scNegativeSign, Result]);
    // - 1,1
    2: Result := Format('%s %s', [scNegativeSign, Result]);
    // 1,1-
    3: Result := Format('%s%s',  [Result, scNegativeSign]);
    // 1,1 -
    4: Result := Format('%s %s', [Result, scNegativeSign]);
  end;
end;

function TSCCustomIntSpinEdit.ArrangeSeparators(const S: String;
  AddThousands: Boolean): String;
var
  Tmp: String;
  Len, I: Integer;
begin
  Result := Trim(S);

  Len := Length(Result);
  if (Len = 0) and FAllowEmpty then
    Exit;

  Result := StringReplace(Result, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);
  Len := Length(Result);

  for I := 1 to Len do
    if not (Result[I] in ['0'..'9']) then
    begin
      Result := Trim(Copy(Result, 1, I-1));
      Break;
    end;

  if AddThousands and (Length(Result) > 3) then
  begin
    Tmp := '';
    while Length(Result) > 3 do
    begin
      Len := Length(Result);
      Tmp := Copy(Result, Len - 2, 3) + {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator + Tmp;

      Delete(Result, Len - 2, 3);
    end;

    if Result <> '' then
      Tmp := Result + {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator + Tmp;

    Result := Tmp;
    Len := Length(Result);
    if (Result <> '') and (Result[Len] = {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator) then
      Delete(Result, Len, 1);
  end;
end;

function TSCCustomIntSpinEdit.ArrangeText(const S: String): String;
var
  I: Integer;
  IsZero: Boolean;
  IsNegative: Boolean;
begin
  Result := '';
  if FAllowEmpty and (S = '') then
    Exit;

  Result := inherited ArrangeText(S);
  IsZero := (FMaxValue = 0) and (FMinValue = 0);

  if not FHexMode then
  begin
    IsNegative := False;

    Result := RemoveNegativeSymbol(Result, IsNegative);
    Result := ArrangeSeparators(Result, False);

    if not scIsInteger(Result, I) then
    begin
      Result := '';
      if not FAllowEmpty then
        Result := IntToStr(FMinValue);
      Exit;
    end;

    Result := ArrangeSeparators(Result, FUseThousandsSeparator);
    if IsNegative then Result := AddNegativeSymbol(Result);
  end else
  begin
    Result := StringReplace(Result, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);
    Result := '$' + Result;

    if not scIsInteger(Result, I) then
    begin
      Result := '';
      if FAllowEmpty then
        Exit;
    end;

    I := StrToIntDef(Result, FMinValue);
    if not IsZero then
    begin
      if I < FMinValue then
        I := FMinValue;

      if I > FMaxValue then
        I := FMaxValue;
    end;

    Result := IntToHex(I, 8);

    while (Result <> '') and (Result[1] = '0') do
      Delete(Result, 1, 1);

    if Result = '' then
      Result := '0';
  end;
end;

procedure TSCCustomIntSpinEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomIntSpinEdit then
  begin
    with TSCCustomIntSpinEdit(Source) do
    begin
      Self.AllowEmpty := AllowEmpty;
      Self.HexMode := HexMode;
      Self.Increment := Increment;
      Self.LargeIncrement := LargeIncrement;
      Self.MinValue := MinValue;
      Self.MaxValue := MaxValue;
      Self.IntValue := IntValue;
      Self.UseThousandsSeparator := UseThousandsSeparator;
    end;
  end;
end;

function TSCCustomIntSpinEdit.CanExecuteHomeEndKeys: Boolean;
begin
  Result := inherited CanExecuteHomeEndKeys and
    (FMinValue <> 0) and (FMaxValue <> 0);
end;

function TSCCustomIntSpinEdit.CanPasteStr(var S: String): Boolean;
begin
  Result := inherited CanPasteStr(S) and scIsInteger(S);
end;

function TSCCustomIntSpinEdit.CanSetValue(var Value: Integer): Boolean;
begin
  Result := IsDesigning or (Enabled and not ReadOnly);

  if Result and ((FMinValue <> 0) or (FMaxValue <> 0)) then
  begin
    if Value < FMinValue then
      Value := FMinValue
    else if Value > FMaxValue then
      Value := FMaxValue;
  end;
end;

function TSCCustomIntSpinEdit.CanSpin(AsUp: Boolean): Boolean;
var
  IsZero: Boolean;
  DownBtn: TSCEditButton;
begin
  Result := inherited CanSpin(AsUp);
  if Result then
  begin
    DownBtn := GetDownButton;

    if DownBtn <> nil then
    begin
      IsZero := (FMaxValue = 0) and (FMinValue = 0);
      Result := (AsUp and (IsZero or (IntValue < FMaxValue))) or
        (not AsUp and (IsZero or (IntValue > FMinValue)));
    end;
  end;
end;

procedure TSCCustomIntSpinEdit.CheckEmpty;
begin
  if not FAllowEmpty then
  begin
    if Text = '' then
    begin
      if not FAllowEmpty then
        SetText(IntToStr(FMinValue));
    end else
      SetText(IntToStr(CheckValue(IntValue)));
  end;
end;

procedure TSCCustomIntSpinEdit.CheckKeyDown(var Key: Word;
  Shift: TShiftState);
begin
  if not IsMasked and (Key = VK_RETURN) and ((Text <> '') or not FAllowEmpty) then
    SetText(ArrangeText(Self.Text));
end;

function TSCCustomIntSpinEdit.CheckValue(Value: Integer): LongInt;
begin
  Result := Value;
  if (FMinValue <> 0) or (FMaxValue <> 0) then
  begin
    if Value < FMinValue then
      Result := FMinValue
    else
    if Value > FMaxValue then
      Result := FMaxValue;
  end;
end;

constructor TSCCustomIntSpinEdit.Create(AOwner: TComponent);
begin
  FAllowEmpty := False;
  FUseThousandsSeparator := True;
  inherited Create(AOwner);
  FIncrement := 1;
  FLargeIncrement := 10;
end;

procedure TSCCustomIntSpinEdit.DoButtonClick(Btn: TSCEditButton);
begin
  if Btn = FUpButton then
    SetIntValue(IntValue + FIncrement)
  else
  if Btn = FDownButton then
    SetIntValue(IntValue - FIncrement)
  else
  if (FMinValue <> 0) or (FMaxValue <> 0) then
  begin
    if Btn = FHomeButton then
      SetIntValue(FMinValue)
    else
    if Btn = FEndButton then
      SetIntValue(FMaxValue);
  end;    

  inherited DoButtonClick(Btn);
end;

procedure TSCCustomIntSpinEdit.DoPageDown(var Key: Word);
begin
  if FLargeIncrement > 0 then
  begin
    Key := 0;
    SetIntValue(IntValue - FLargeIncrement);
  end;
end;

procedure TSCCustomIntSpinEdit.DoPageUp(var Key: Word);
begin
  if FLargeIncrement > 0 then
  begin
    Key := 0;
    SetIntValue(IntValue + FLargeIncrement);
  end;
end;

function TSCCustomIntSpinEdit.GetIntValue: LongInt;
var
  S: String;
begin
  S := Trim(Text);
  S := StringReplace(S, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);
  if FHexMode then
    Result := StrToIntDef('$' + Trim(S), GetUnIntValue)
  else
    Result := StrToIntDef(Trim(S), GetUnIntValue);
end;

function TSCCustomIntSpinEdit.GetUnIntValue: LongInt;
begin
  Result := FMinValue;
end;

function TSCCustomIntSpinEdit.IsEmpty: Boolean;
begin
  Result := FAllowEmpty and (Text = '');
end;

function TSCCustomIntSpinEdit.IsValidKey(Key: Char): Boolean;
var
  ValidChars: set of Char;
begin
  ValidChars := ['0'..'9'];
  if FHexMode then
    ValidChars := ['a'..'f', 'A'..'F'] + ValidChars
  else begin
    ValidChars := ['+', scNegativeSign] + ValidChars;
    if FUseThousandsSeparator then
      ValidChars := ValidChars + [{$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator];
  end;

  Result := inherited IsValidKey(Key) and
    ((Key in ValidChars) or ((Key < #32) and (Key <> Chr(VK_RETURN))));;
end;

function TSCCustomIntSpinEdit.RemoveNegativeSymbol(const S: String;
  var IsNegative: Boolean): String;
var
  Len: Integer;
begin
  IsNegative := False;

  Result := Trim(S);
  if Result = '' then
    Exit;

  Len := Length(Result);
  case scNegativeFormat of
    0: // (1,1)
    begin
      if (Result[1] = '(') and (Result[Len] = ')') then
      begin
        IsNegative := True;

        Delete(Result, 1, 1);
        Delete(Result, Len, 1);
      end;
    end;
    1, 2: // -1,1 , - 1,1
    begin
      if Result[1] = scNegativeSign then
      begin
        IsNegative := True;
        Delete(Result, 1, 1);
      end;
    end;
    3, 4: // 1,1- , 1,1 -
    begin
      if Result[Len] = scNegativeSign then
      begin
        IsNegative := True;
        Delete(Result, Len, 1);
      end;
    end;
  end;

  Result := Trim(Result);
end;

procedure TSCCustomIntSpinEdit.SetAllowEmpty(Value: Boolean);
begin
  if FAllowEmpty <> Value then
  begin
    FAllowEmpty := Value;
    if not Value and (Text = '') then
      SetText(IntToStr(FMinValue));
  end;
end;

procedure TSCCustomIntSpinEdit.SetEmpty;
begin
  if FAllowEmpty then
    Text := '';
end;

procedure TSCCustomIntSpinEdit.SetHexMode(Value: Boolean);
var
  S: String;
begin
  if FHexMode <> Value then
  begin
    FHexMode := Value;

    if IsLoading or IsEmpty then
      Exit;

    if FHexMode then
    begin
      S := StringReplace(Text, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);
      S := IntToHex(StrToIntDef(S, FMinValue), 8);
      
      while (S <> '') and (S[1] = '0') do
        Delete(S, 1, 1);

      if S = '' then S := '0';
      Text := S;
    end else
    begin
      S := StringReplace(Text, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);
      Text := IntToStr(StrToIntDef('$' + S, FMinValue));
    end;
  end;
end;

procedure TSCCustomIntSpinEdit.SetIncrement(Value: Integer);
begin
  if Value < 1 then Value := 1;
  FIncrement := Value;
end;

procedure TSCCustomIntSpinEdit.SetIntValue(Value: Integer);
var
  S: String;
begin
  if not CanSetValue(Value) then
    Exit;

  if FHexMode then
  begin
    S := IntToHex(CheckValue(Value), 8);
    while (S <> '') and (S[1] = '0') do
      Delete(S, 1, 1);

    if S = '' then S := '0';
    Text := S;
  end else
    Text := IntToStr(CheckValue(Value));
end;

procedure TSCCustomIntSpinEdit.SetLargeIncrement(Value: Integer);
begin
  if Value < 0 then Value := 0;
  FLargeIncrement := Value;
end;

procedure TSCCustomIntSpinEdit.SetMaxValue(Value: Integer);
begin
  if FMaxValue <> Value then
  begin
    FMaxValue := Value;

    if not IsLoading then
    begin
      if FMinValue > FMaxValue then
        FMinValue := FMaxValue;
      SetIntValue(IntValue);
    end;
  end;
end;

procedure TSCCustomIntSpinEdit.SetMinValue(Value: Integer);
begin
  if FMinValue <> Value then
  begin
    FMinValue := Value;

    if not IsLoading then
    begin
      if FMaxValue < FMinValue then
        FMaxValue := FMinValue;
      SetIntValue(IntValue);
    end;
  end;
end;

procedure TSCCustomIntSpinEdit.SetUseThousandsSeparator(Value: Boolean);
var
  S: String;
begin
  if FUseThousandsSeparator <> Value then
  begin
    FUseThousandsSeparator := Value;
    if not FHexMode then
    begin
      S := StringReplace(Text, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);
      if S = '' then
        Text := ''
      else
        Text := IntToStr(StrToIntDef(S, FMinValue));
    end;
  end;
end;

procedure TSCCustomIntSpinEdit.SpinControl;
var
  Val: LongInt;
  DownBtn: TSCEditButton;
begin
  if not Spining or SpinPaused then
    Exit;

  if CanSpin(True) then
  begin
    Val := IntValue + FIncrement;
    SetIntValue(Val);

    if (Val >= FMaxValue) and ((FMinValue <> 0) or (FMaxValue <> 0)) then
    begin
      DownBtn := GetDownButton;
      StopSpining;

      if DownBtn <> nil then
        TSCSpinButton(DownBtn).ButtonDown := True;

      Invalidate;
    end;
  end else
  if CanSpin(False) then
  begin
    Val := IntValue - FIncrement;
    SetIntValue(Val);

    if (Val <= FMinValue) and ((FMinValue <> 0) or (FMaxValue <> 0)) then
    begin
      DownBtn := GetDownButton;
      StopSpining;

      if DownBtn <> nil then
        TSCSpinButton(DownBtn).ButtonDown := True;

      Invalidate;
    end;
  end;
end;

procedure TSCCustomIntSpinEdit.UpdateValueFromText;
var
  Val: LongInt;
begin
  if not IsEmpty then
  begin
    Val := IntValue;
    if IntToStr(CheckValue(Val)) <> Text then
      SetIntValue(Val);
  end;
end;

{ TSCCustomSpinnerButtonProps }

procedure TSCCustomSpinnerButtonProps.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomSpinnerButtonProps then
    with TSCCustomSpinnerButtonProps(Source) do
    begin
      Self.DownImage := DownImage;
      Self.EndImage := EndImage;
      Self.HomeEndLayout := HomeEndLayout;
      Self.HomeImage := HomeImage;
      Self.Layout := Layout;
      Self.Style := Style;
      Self.UpImage := UpImage;
      Self.Width := Width;
    end;
end;

function TSCCustomSpinnerButtonProps.GetDownImage: TImageIndex;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    Result := TSCCustomSpinnerEdit(Owner).ButtonDownImage;
end;

function TSCCustomSpinnerButtonProps.GetEndImage: TImageIndex;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    Result := TSCCustomSpinnerEdit(Owner).ButtonEndImage;
end;

function TSCCustomSpinnerButtonProps.GetHomeEndLayout: TSCSpinnerLayout;
begin
  Result := scslLeftRight;
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    Result := TSCCustomSpinnerEdit(Owner).HomeEndLayout;
end;

function TSCCustomSpinnerButtonProps.GetHomeImage: TImageIndex;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    Result := TSCCustomSpinnerEdit(Owner).ButtonHomeImage;
end;

function TSCCustomSpinnerButtonProps.GetLayout: TSCSpinnerLayout;
begin
  Result := scslLeftRight;
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    Result := TSCCustomSpinnerEdit(Owner).ButtonLayout;
end;

function TSCCustomSpinnerButtonProps.GetStyle: TSCSpinnerStyle;
begin
  Result := scssMinusPlus;
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    Result := TSCCustomSpinnerEdit(Owner).ButtonStyle;
end;

function TSCCustomSpinnerButtonProps.GetUpImage: TImageIndex;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    Result := TSCCustomSpinnerEdit(Owner).ButtonUpImage;
end;

function TSCCustomSpinnerButtonProps.GetWidth: Integer;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    Result := TSCCustomSpinnerEdit(Owner).ButtonWidth;
end;

procedure TSCCustomSpinnerButtonProps.SetDownImage(Value: TImageIndex);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    TSCCustomSpinnerEdit(Owner).ButtonDownImage := Value;
end;

procedure TSCCustomSpinnerButtonProps.SetEndImage(Value: TImageIndex);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    TSCCustomSpinnerEdit(Owner).ButtonEndImage := Value;
end;

procedure TSCCustomSpinnerButtonProps.SetHomeEndLayout(
  Value: TSCSpinnerLayout);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    TSCCustomSpinnerEdit(Owner).HomeEndLayout := Value;
end;

procedure TSCCustomSpinnerButtonProps.SetHomeImage(Value: TImageIndex);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    TSCCustomSpinnerEdit(Owner).ButtonHomeImage := Value;
end;

procedure TSCCustomSpinnerButtonProps.SetLayout(Value: TSCSpinnerLayout);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    TSCCustomSpinnerEdit(Owner).ButtonLayout := Value;
end;

procedure TSCCustomSpinnerButtonProps.SetStyle(Value: TSCSpinnerStyle);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    TSCCustomSpinnerEdit(Owner).ButtonStyle := Value;
end;

procedure TSCCustomSpinnerButtonProps.SetUpImage(Value: TImageIndex);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    TSCCustomSpinnerEdit(Owner).ButtonUpImage := Value;
end;

procedure TSCCustomSpinnerButtonProps.SetWidth(Value: Integer);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinnerEdit) then
    TSCCustomSpinnerEdit(Owner).ButtonWidth := Value;
end;

{ TSCCustomSpinnerEdit }

procedure TSCCustomSpinnerEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomSpinnerEdit then
  begin
    with TSCCustomSpinnerEdit(Source) do
    begin
      Self.ButtonDownImage := ButtonDownImage;
      Self.ButtonEndImage := ButtonEndImage;
      Self.ButtonHomeImage := ButtonHomeImage;
      Self.ButtonLayout := ButtonLayout;
      Self.ButtonStyle := ButtonStyle;
      Self.ButtonUpImage := ButtonUpImage;
      Self.ButtonWidth := ButtonWidth;
      Self.HomeEndLayout := HomeEndLayout;
    end;
  end;
end;

procedure TSCCustomSpinnerEdit.ButtonChanged(Sender: TObject);
begin
  if FInStyleChange then
  begin
    FNeedRepaint := True;
    Exit;
  end;

  if (Sender <> nil) and (Sender is TSCEditButton) and
    (TSCEditButton(Sender).Owner = Self) and not IsLoading then
  begin
    FInStyleChange := True;
    try
      TSCSpinButton(Sender).Style := scebCustom;

      case FButtonLayout of
        scslLeft:
        begin
          if FUpButton <> nil then
            TSCSpinButton(FUpButton).Align   := taLeftJustify;

          if FDownButton <> nil then
            TSCSpinButton(FDownButton).Align := taLeftJustify;
        end;
        scslRight:
        begin
          if FUpButton <> nil then
            TSCSpinButton(FUpButton).Align   := taRightJustify;

          if FDownButton <> nil then
            TSCSpinButton(FDownButton).Align := taRightJustify;
        end;
        scslLeftRight:
        begin
          if FUpButton <> nil then
            TSCSpinButton(FUpButton).Align := taRightJustify;

          if FDownButton <> nil then
            TSCSpinButton(FDownButton).Align := taLeftJustify;
        end;
      end;

      case FHomeEndLayout of
        scslLeft:
        begin
          if FHomeButton <> nil then
            TSCSpinButton(FHomeButton).Align := taLeftJustify;

          if FEndButton <> nil then
            TSCSpinButton(FEndButton).Align := taLeftJustify;
        end;
        scslRight:
        begin
          if FHomeButton <> nil then
            TSCSpinButton(FHomeButton).Align := taRightJustify;

          if FEndButton <> nil then
            TSCSpinButton(FEndButton).Align  := taRightJustify;
        end;
        scslLeftRight:
        begin
          if FHomeButton <> nil then
            TSCSpinButton(FHomeButton).Align := taLeftJustify;

          if FEndButton <> nil then
            TSCSpinButton(FEndButton).Align  := taRightJustify;
        end;
      end;

      StyleChanged;
    finally
      FInStyleChange := False;
      if FNeedRepaint then
        Invalidate;
    end;
  end;
end;

constructor TSCCustomSpinnerEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Alignment := taCenter;
  SetBounds(Left, Top, 95, Height);

  FButtonLayout  := scslLeftRight;
  FButtonStyle   := scssMinusPlus;
  FHomeEndLayout := scslLeftRight;

  with TSCSpinButton(FUpButton) do
  begin
    Style := scebCustom;
    Align := taRightJustify;
  end;

  with TSCSpinButton(FDownButton) do
  begin
    Style := scebCustom;
    DropUp := False;
    Align := taLeftJustify;
  end;

  with TSCSpinButton(FEndButton) do
  begin
    Style := scebCustom;
    Align := taRightJustify;
  end;

  with TSCSpinButton(FHomeButton) do
  begin
    Style := scebCustom;
    DropUp := False;
    Align := taLeftJustify;
  end;

  StyleChanged;
end;

procedure TSCCustomSpinnerEdit.DoCustomPaintButton(C: TCanvas; R: TRect;
  Btn: TSCEditButton; IsDown, IsHot: Boolean);
var
  Cl: TColor;
  I, H, W, L, T: Integer;
begin
  if (C <> nil) and not IsRectEmpty(R) and (Btn <> nil) and
    TSCSpinButton(Btn).Visible and (TSCSpinButton(Btn).Width <> 0) and
    (FButtonStyle <> scssCustom) and ((Btn = FDownButton) or
    (Btn = FUpButton) or (Btn = FHomeButton) or (Btn = FEndButton)) then
  begin
    Cl := TSCSpinButton(Btn).ArrowColor;

    case Style of
      scesOfficeXP:
      begin
        Cl := clBtnText;
        if (IsMouseDown or MouseInControl or Focused or
          MouseIsDown) and IsDown and IsHot then
          Cl := GetBtnHighlightOf(clBtnFace);
      end;
      scesSingle, scesDouble, scesDoubleNew:
        if IsDown and IsHot then
          Cl := GetBtnHighlightOf(TSCSpinButton(Btn).Color);
      scesWinXP:
        Cl := Get3DDkShadowOf(ExUseColor);
    end;

    H := GetSliderHeight(R, False);

    case FButtonStyle of
      scssArrow:
      begin
        if H = 0 then Exit;

        if (Btn = FHomeButton) or (Btn = FDownButton) then
        begin
          L := R.Left + ((R.Right - R.Left - H) div 2) - 1;
          if Btn = FHomeButton then
            Inc(L);
        end else
        begin
          L := R.Left + ((R.Right - R.Left + H) div 2);
          if Btn = FEndButton then
            Dec(L);
        end;

        T := R.Top + ((R.Bottom - R.Top) div 2) + 1;

        if IsDown and IsHot and not IsExtraFlat then
        begin
          Inc(T);
          if (Btn = FUpButton) or (Btn = FEndButton) then
            Inc(L)
          else
            Dec(L);
        end;

        if (Btn = FUpButton) or (Btn = FEndButton) then
          scDrawLeftSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl, Cl)
        else
          scDrawRightSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl, Cl);

        Dec(T, H + 1);
        if (Btn = FHomeButton) or (Btn = FEndButton) then
          with C do
          begin
            Pen.Color := Cl;
            Pen.Style := PsSolid;
            Pen.Width := 1;

            for I := 0 to 1 do
            begin
              if Btn = FHomeButton then
                Dec(L)
              else
                Inc(L);

              MoveTo(L, T);
              LineTo(L, T + 2*H + 1);
            end;
          end;
      end;
      scssImage:
      begin
        if Images <> nil then
        begin
          L := R.Left + ((R.Right - R.Left - Images.Width) div 2);
          T := R.Top + ((R.Bottom - R.Top - Images.Height) div 2);

          if IsExtraFlat then
          begin
            if IsHot and not IsDown then
            begin
              Dec(L);
              Dec(T);
            end;
          end else
          if IsDown and IsHot then
          begin
            Inc(L);
            Inc(T);
          end;

          Images.Draw(C, L, T, TSCSpinButton(Btn).Image, Self.Enabled);
        end;
      end;
      scssMinusPlus:
      begin
        if H = 0 then Exit;

        if (Btn = FHomeButton) or (Btn = FEndButton) then
        begin
          if Btn = FHomeButton then
            L := R.Left + ((R.Right - R.Left - H) div 2)
          else
            L := R.Left + ((R.Right - R.Left + H) div 2) - 1;

          T := R.Top + ((R.Bottom - R.Top) div 2) + 1;

          if IsDown and IsHot and not IsExtraFlat then
          begin
            Inc(T);
            if Btn = FEndButton then
              Inc(L)
            else
              Dec(L);
          end;

          if Btn = FEndButton then
            scDrawLeftSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl, Cl)
          else
            scDrawRightSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl, Cl);

          Dec(T, H + 1);
          with C do
          begin
            Pen.Color := Cl;
            Pen.Style := PsSolid;
            Pen.Width := 1;

            for I := 0 to 1 do
            begin
              if Btn = FHomeButton then
                Dec(L)
              else
                Inc(L);

              MoveTo(L, T);
              LineTo(L, T + 2*H + 1);
            end;
          end;
        end else
        begin
          W := 2;
          if H < 3 then W := 1;

          L := R.Left + ((R.Right - R.Left - W - 2*H) div 2);
          T := R.Top + ((R.Bottom - R.Top - W) div 2);

          if IsDown and IsHot and not IsExtraFlat then
          begin
            Inc(L);
            Inc(T);
          end;

          with C do
          begin
            Pen.Style := psSolid;
            Pen.Mode  := pmCopy;
            Pen.Width := 1;
            Pen.Color := Cl;

            MoveTo(L, T);
            LineTo(L + W + 2*H, T);

            if W = 2 then
            begin
              Inc(T);

              MoveTo(L, T);
              LineTo(L + W + 2*H, T);
            end;

            if Btn = FUpButton then
            begin
              L := R.Left + ((R.Right - R.Left - W) div 2);
              T := R.Top + ((R.Bottom - R.Top - W - 2*H) div 2);

              if IsDown and IsHot and not IsExtraFlat then
              begin
                Inc(L);
                Inc(T);
              end;

              MoveTo(L, T);
              LineTo(L, T + W + 2*H);

              if W = 2 then
              begin
                Inc(L);

                MoveTo(L, T);
                LineTo(L, T + W + 2*H);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TSCCustomSpinnerEdit.GetButtonClass: TSCEditButtonClass;
begin
  Result := TSCSpinnerButton;
end;

function TSCCustomSpinnerEdit.GetButtonDownImage: TImageIndex;
begin
  Result := -1;
  if FDownButton <> nil then
    Result := TSCSpinButton(FDownButton).Image;
end;

function TSCCustomSpinnerEdit.GetButtonEndImage: TImageIndex;
begin
  Result := -1;
  if FEndButton <> nil then
    Result := TSCSpinButton(FEndButton).Image;
end;

function TSCCustomSpinnerEdit.GetButtonHomeImage: TImageIndex;
begin
  Result := -1;
  if FHomeButton <> nil then
    Result := TSCSpinButton(FHomeButton).Image;
end;

function TSCCustomSpinnerEdit.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCSpinnerButtonProps;
end;

function TSCCustomSpinnerEdit.GetButtonRect(Btn: TSCEditButton): TRect;
var
  R, Cr: TRect;
  I, W: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated and (Btn <> nil) and
    (TSCSpinButton(Btn).Owner = Self) and TSCSpinButton(Btn).Visible then
  begin
    R := GetInnerEditRect;
    W := FUpButton.GetWidth;

    if CheckboxVisible then
    begin
      Cr := GetCheckboxRect;
      if Cr.Right < Cr.Left then
        Cr.Right := Cr.Left;

      Inc(R.Left, Cr.Right);  
    end;

    I := 0;
    if Style in [scesSingle, scesNew, scesExtreme, scesWinXP, scesDoubleNew] then
      I := 1
    else
    if Style in [scesOfficeXP, scesOffice12, scesOffice2003] then
      I := 2;

    if (Btn <> FHomeButton) and (Btn <> FEndButton) and HomeEndButtons then
    begin
      case FHomeEndLayout of
        scslLeft:
          Inc(R.Left, 2*W);
        scslRight:
          Dec(R.Right, 2*W);
        scslLeftRight:
          InflateRect(R, -W, 0);
      end;
    end;

    Result := R;

    if IsRectEmpty(Result) then
    begin
      Result.Left := Result.Right;
      Exit;
    end;

    if Btn = FHomeButton then
    begin
      if FHomeEndLayout = scslRight then
      begin
        Dec(Result.Right, W);
        Result.Left := Result.Right - W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, I, 0);
          InflateRect(Result, 0, I);
        end;
      end else
      begin
        Result.Right := Result.Left + W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, -I, 0);
          InflateRect(Result, 0, I);
        end;
      end;
    end else
    if Btn = FEndButton then
    begin
      if FHomeEndLayout = scslLeft then
      begin
        Inc(Result.Left, W);
        Result.Right := Result.Left + W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, -I, 0);
          InflateRect(Result, 0, I);
        end;
      end else
      begin
        Result.Left := Result.Right - W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, I, 0);
          InflateRect(Result, 0, I);
        end;
      end;
    end else
    if Btn = FUpButton then
    begin
      if FButtonLayout = scslLeft then
      begin
        Inc(Result.Left, W);
        Result.Right := Result.Left + W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, -I, 0);
          InflateRect(Result, 0, I);
        end;
      end else
      begin
        Result.Left := Result.Right - W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, I, 0);
          InflateRect(Result, 0, I);
        end;
      end;
    end else
    if Btn = FDownButton then
    begin
      if FButtonLayout = scslRight then
      begin
        Dec(Result.Right, W);
        Result.Left := Result.Right - W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, I, 0);
          InflateRect(Result, 0, I);
        end;
      end else
      begin
        Result.Right := Result.Left + W;

        if ButtonInsideFrame and not IsRectEmpty(Result) then
        begin
          OffsetRect(Result, -I, 0);
          InflateRect(Result, 0, I);
        end;
      end;
    end;

    if IsRectEmpty(Result) then
      Result.Left := Result.Right;
  end;
end;

function TSCCustomSpinnerEdit.GetButtonUpImage: TImageIndex;
begin
  Result := -1;
  if FUpButton <> nil then
    Result := TSCSpinButton(FUpButton).Image;
end;

function TSCCustomSpinnerEdit.GetButtonWidth: Integer;
begin
  Result := -1;
  if FUpButton <> nil then
    Result := TSCSpinButton(FUpButton).Width;
end;

function TSCCustomSpinnerEdit.GetSliderHeight(R: TRect; IsUp: Boolean): Integer;
var
  W: Integer;
begin
  InflateRect(R, -3, -3);

  Result := R.Bottom - R.Top;
  W := R.Right - R.Left;

  if W < Result then Result := W;

  Result := Result div 2;

  if Result < 0 then Result := 0;
  if Result > 4 then Result := 4;
end;

procedure TSCCustomSpinnerEdit.SetButtonDownImage(Value: TImageIndex);
begin
  if FDownButton <> nil then
    TSCSpinButton(FDownButton).Image := Value;
end;

procedure TSCCustomSpinnerEdit.SetButtonEndImage(Value: TImageIndex);
begin
  if FEndButton <> nil then
    TSCSpinButton(FEndButton).Image := Value;
end;

procedure TSCCustomSpinnerEdit.SetButtonHomeImage(Value: TImageIndex);
begin
  if FHomeButton <> nil then
    TSCSpinButton(FHomeButton).Image := Value;
end;

procedure TSCCustomSpinnerEdit.SetButtonLayout(Value: TSCSpinnerLayout);
begin
  if FButtonLayout <> Value then
  begin
    FButtonLayout := Value;

    ButtonChanged(FUpButton);
    ButtonChanged(FDownButton);
  end;
end;

procedure TSCCustomSpinnerEdit.SetButtonStyle(Value: TSCSpinnerStyle);
begin
  if FButtonStyle <> Value then
  begin
    FButtonStyle := Value;
    StyleChanged;
  end;
end;

procedure TSCCustomSpinnerEdit.SetButtonUpImage(Value: TImageIndex);
begin
  if FUpButton <> nil then
    TSCSpinButton(FUpButton).Image := Value;
end;

procedure TSCCustomSpinnerEdit.SetButtonWidth(Value: Integer);
begin
  if FUpButton <> nil then
    TSCSpinButton(FUpButton).Width := Value;
  if FDownButton <> nil then
    TSCSpinButton(FDownButton).Width := Value;
end;

procedure TSCCustomSpinnerEdit.SetHomeEndLayout(Value: TSCSpinnerLayout);
begin
  if FHomeEndLayout <> Value then
  begin
    FHomeEndLayout := Value;

    ButtonChanged(FHomeButton);
    ButtonChanged(FEndButton);
  end;
end;

procedure TSCCustomSpinnerEdit.UpdateBorderRect(var R: TRect);
var
  W: Integer;
begin
  if ButtonsVisible or HomeEndButtons then
  begin
    if FUpButton <> nil then
      W := FUpButton.GetWidth
    else
      W := GetSystemMetrics(SM_CXVSCROLL);

    Inc(W);

    case FHomeEndLayout of
      scslLeft:
      begin
        if (FHomeButton <> nil) and TSCSpinButton(FHomeButton).Visible then
          Inc(R.Left, W);
        if (FEndButton <> nil) and TSCSpinButton(FEndButton).Visible then
          Inc(R.Left, W);
      end;
      scslRight:
      begin
        if (FHomeButton <> nil) and TSCSpinButton(FHomeButton).Visible then
          Inc(R.Right, W);
        if (FEndButton <> nil) and TSCSpinButton(FEndButton).Visible then
          Inc(R.Right, W);
      end;
      scslLeftRight:
      begin
        if (FHomeButton <> nil) and TSCSpinButton(FHomeButton).Visible then
          Inc(R.Left, W);
        if (FEndButton <> nil) and TSCSpinButton(FEndButton).Visible then
          Inc(R.Right, W);
      end;
    end;

    case FButtonLayout of
      scslLeft:
      begin
        if (FUpButton <> nil) and TSCSpinButton(FUpButton).Visible then
          Inc(R.Left, W);
        if (FDownButton <> nil) and TSCSpinButton(FDownButton).Visible then
          Inc(R.Left, W);
      end;
      scslRight:
      begin
        if (FUpButton <> nil) and TSCSpinButton(FUpButton).Visible then
          Inc(R.Right, W);
        if (FDownButton <> nil) and TSCSpinButton(FDownButton).Visible then
          Inc(R.Right, W);
      end;
      scslLeftRight:
      begin
        if (FUpButton <> nil) and TSCSpinButton(FUpButton).Visible then
          Inc(R.Right, W);
        if (FDownButton <> nil) and TSCSpinButton(FDownButton).Visible then
          Inc(R.Left, W);
      end;
    end;
  end;
end;

{ TSCCustomFloatSpinEdit }

function TSCCustomFloatSpinEdit.AddNegativeSymbol(const S: String): String;
begin
  Result := Trim(S);
  if (Result = '') or (Result = '0') then
    Exit;

  case scNegativeFormat of
    // (1,1)
    0: Result := Format('(%s)',  [Result]);
    // -1,1
    1: Result := Format('%s%s',  [scNegativeSign, Result]);
    // - 1,1
    2: Result := Format('%s %s', [scNegativeSign, Result]);
    // 1,1-
    3: Result := Format('%s%s',  [Result, scNegativeSign]);
    // 1,1 -
    4: Result := Format('%s %s', [Result, scNegativeSign]);
  end;
end;

function TSCCustomFloatSpinEdit.ArrangeSeparators(const S: String;
  AddThousands: Boolean): String;
var
  Len, P, I: Integer;
  Decimals, Thousands, Tmp: String;
begin
  Result := Trim(S);

  Decimals := '';
  Thousands := Result;

  Len := Length(Result);
  if (Len = 0) and FAllowEmpty then
    Exit;

  P := Pos({$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DecimalSeparator, S);

  if P > 0 then
  begin
    Decimals := Trim(Copy(Result, P + 1, Len - P));
    Delete(Thousands, P, Len - P + 1);

    Thousands := Trim(Thousands);

    Len := Length(Decimals);
    if (FDecimalPlaces > -1) and (Len > FDecimalPlaces) then
      Decimals := Trim(Copy(Decimals, 1, FDecimalPlaces));

    for I := 1 to Length(Decimals) do
      if not (Decimals[I] in ['0'..'9']) then
      begin
        Decimals := Trim(Copy(Decimals, 1, I-1));
        Break;
      end;
  end;

  Thousands := StringReplace(Thousands, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);
  Len := Length(Thousands);

  for I := 1 to Len do
    if not (Thousands[I] in ['0'..'9']) then
    begin
      Thousands := Trim(Copy(Thousands, 1, I-1));
      Break;
    end;

  if AddThousands and (Length(Thousands) > 3) then
  begin
    Tmp := '';
    while Length(Thousands) > 3 do
    begin
      Len := Length(Thousands);
      Tmp := Copy(Thousands, Len - 2, 3) + {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator + Tmp;

      Delete(Thousands, Len - 2, 3);
    end;

    if Thousands <> '' then
      Tmp := Thousands + {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator + Tmp;

    Thousands := Tmp;
    Len := Length(Thousands);
    if (Thousands <> '') and (Thousands[Len] = {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator) then
      Delete(Thousands, Len, 1);
  end;

  if (Thousands = '') and (Decimals = '') then
  begin
    Result := '';
    Exit;
  end;

  Len := Length(Decimals);

  if FDecimalPlaces > -1 then
  begin
    if Len > FDecimalPlaces then
      Decimals := Trim(Copy(Decimals, 1, FDecimalPlaces))
    else if Len < FDecimalPlaces then
      Decimals := Decimals + StringOfChar('0', FDecimalPlaces - Len);
  end else
  if FDecimalPlaces = -1 then
  begin
    for I := Length(Decimals) downto 1 do
    begin
      if Decimals[I] <> '0' then
        Break;

      Delete(Decimals, I, 1);
    end;
  end;

  if Length(Decimals) > 20 then
    Decimals := Copy(Decimals, 1, 20);

  Result := Thousands;
  if Decimals <> '' then
    Result := Result + {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DecimalSeparator + Decimals;
end;

function TSCCustomFloatSpinEdit.ArrangeText(const S: String): String;
var
  IsNegative: Boolean;
begin
  Result := '';
  if (S = '') and FAllowEmpty then
    Exit;

  IsNegative := False;
  try
    Result := Trim(inherited ArrangeText(Trim(S)));
    if Result = '' then
      Result := scCurrencyToStr(FMinValue, FUseThousandsSeparator, FDecimalPlaces);

    Result := RemoveNegativeSymbol(Result, IsNegative);
    Result := ArrangeSeparators(Result, False);

    if not scIsFloat(Result, False) then
      Result := scCurrencyToStr(FMinValue, FUseThousandsSeparator, FDecimalPlaces);

    Result := ArrangeSeparators(Result, FUseThousandsSeparator);

    if IsNegative then
      Result := AddNegativeSymbol(Result);
  except
    Result := scCurrencyToStr(FMinValue, FUseThousandsSeparator, FDecimalPlaces);
  end;
end;

procedure TSCCustomFloatSpinEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomFloatSpinEdit then
  begin
    with TSCCustomFloatSpinEdit(Source) do
    begin
      Self.AllowEmpty := AllowEmpty;
      Self.MinValue := MinValue;
      Self.MaxValue := MaxValue;
      Self.Increment := Increment;
      Self.LargeIncrement := LargeIncrement;
      Self.FloatValue := FloatValue;
      Self.UseThousandsSeparator := UseThousandsSeparator;
    end;
  end;
end;

function TSCCustomFloatSpinEdit.CanPasteStr(var S: String): Boolean;
begin
  Result := inherited CanPasteStr(S) and scIsFloat(S);
end;

function TSCCustomFloatSpinEdit.CanSetValue(var Value: Double): Boolean;
begin
  Result := IsDesigning or (Enabled and not ReadOnly);

  if Result and ((FMinValue <> 0) or (FMaxValue <> 0)) then
  begin
    if Value < FMinValue then
      Value := FMinValue
    else if Value > FMaxValue then
      Value := FMaxValue;
  end;
end;

function TSCCustomFloatSpinEdit.CanSpin(AsUp: Boolean): Boolean;
var
  IsZero: Boolean;
  DownBtn: TSCEditButton;
begin
  Result := inherited CanSpin(AsUp);
  if Result then
  begin
    DownBtn := GetDownButton;

    if DownBtn <> nil then
    begin
      IsZero := (FMaxValue = 0) and (FMinValue = 0);
      Result := (AsUp and (IsZero or (FloatValue < FMaxValue))) or
        (not AsUp and (IsZero or (FloatValue > FMinValue)));
    end;
  end;
end;

procedure TSCCustomFloatSpinEdit.CheckEmpty;
begin
  if not FAllowEmpty then
  begin
    if Text = '' then
    begin
      if not FAllowEmpty then
        SetText(scFloatToStr(FMinValue, False));
    end else
      SetText(scFloatToStr(CheckValue(FloatValue), False));
  end;
end;

function TSCCustomFloatSpinEdit.CheckValue(Value: Double): Double;
begin
  Result := Value;
  if (FMinValue <> 0) or (FMaxValue <> 0) then
  begin
    if Value < FMinValue then
      Result := FMinValue
    else
    if Value > FMaxValue then
      Result := FMaxValue;
  end;
end;

constructor TSCCustomFloatSpinEdit.Create(AOwner: TComponent);
begin
  FAllowEmpty := False;
  FDecimalPlaces := -1;
  FUseThousandsSeparator := True;
  inherited Create(AOwner);
  FIncrement := 1;
  FLargeIncrement := 10;
end;

procedure TSCCustomFloatSpinEdit.DoButtonClick(Btn: TSCEditButton);
begin
  if Btn = FUpButton then
    SetFloatValue(FloatValue + FIncrement)
  else
  if Btn = FDownButton then
    SetFloatValue(FloatValue - FIncrement);

  inherited DoButtonClick(Btn);
end;

procedure TSCCustomFloatSpinEdit.DoPageDown(var Key: Word);
begin
  if FLargeIncrement > 0 then
  begin
    Key := 0;
    SetFloatValue(FloatValue - FLargeIncrement);
  end;
end;

procedure TSCCustomFloatSpinEdit.DoPageUp(var Key: Word);
begin
  if FLargeIncrement > 0 then
  begin
    Key := 0;
    SetFloatValue(FloatValue + FLargeIncrement);
  end;
end;

function TSCCustomFloatSpinEdit.GetFloatText: String;
var
  IsNegative: Boolean;
begin
  Result := Trim(Text);
  if Result = '' then
    Exit;

  Result := RemoveNegativeSymbol(Result, IsNegative);
  Result := ArrangeSeparators(Result, False);

  if (Result <> '') and not scIsFloat(Result, False) then
    Result := scCurrencyToStr(FMinValue, False, FDecimalPlaces);

  Result := ArrangeSeparators(Result, False);

  if IsNegative then
    Result := AddNegativeSymbol(Result);

  Result := StringReplace(Result, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);
end;

function TSCCustomFloatSpinEdit.GetFloatValue: Double;
var
  S: String;
  E: Extended;
  IsNegative: Boolean;
begin
  S := Trim(Text);
  if S = '' then
  begin
    Result := GetUnFloatValue;
    Exit;
  end;

  try
    S := RemoveNegativeSymbol(S, IsNegative);

    S := ArrangeSeparators(S, False);
    if IsNegative then S := scNegativeSign + S;

    if scIsFloat(S, E) then
      Result := E
    else  
      Result := GetUnFloatValue;
  except
    Result := GetUnFloatValue;
  end;
end;

function TSCCustomFloatSpinEdit.GetUnFloatValue: Double;
begin
  Result := FMinValue;
end;

function TSCCustomFloatSpinEdit.IsEmpty: Boolean;
begin
  Result := FAllowEmpty and (Text = '');
end;

function TSCCustomFloatSpinEdit.IsIncrementStored: Boolean;
begin
  Result := FIncrement <> 1;
end;

function TSCCustomFloatSpinEdit.IsLargeIncrementStored: Boolean;
begin
  Result := FLargeIncrement <> 10;
end;

function TSCCustomFloatSpinEdit.IsMaxValueStored: Boolean;
begin
  Result := FMaxValue <> 0;
end;

function TSCCustomFloatSpinEdit.IsMinValueStored: Boolean;
begin
  Result := FMinValue <> 0;
end;

function TSCCustomFloatSpinEdit.IsValidKey(Key: Char): Boolean;
var
  ValidChars: set of Char;
begin
  ValidChars := [{$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DecimalSeparator, '+', scNegativeSign, '0'..'9'];
  if FUseThousandsSeparator then
    ValidChars := ValidChars + [{$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator];

  if scNegativeFormat = 0 then
    ValidChars := ValidChars + ['(', ')'];

  Result := inherited IsValidKey(Key) and
    ((Key in ValidChars) or ((Key < #32) and (Key <> Chr(VK_RETURN))));;

  if Result and ((Key in [{$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DecimalSeparator, '+', scNegativeSign]) or
    ((scNegativeFormat = 0) and (Key in ['(', ')']))) then
    Result := (Pos(Key, Text) = 0) or (Pos(Key, SelText) > 0);
end;

function TSCCustomFloatSpinEdit.IsValidText: Boolean;
var
  S: String;
  IsNegative: Boolean;
begin
  Result := True;

  S := Trim(Text);
  if (S = '') and FAllowEmpty then
    Exit;

  S := RemoveNegativeSymbol(S, IsNegative);
  S := ArrangeSeparators(S, False);

  Result := scIsFloat(S, False);
end;

function TSCCustomFloatSpinEdit.RemoveNegativeSymbol(const S: String;
  var IsNegative: Boolean): String;
var
  Len: Integer;
begin
  IsNegative := False;

  Result := Trim(S);
  if Result = '' then
    Exit;

  Len := Length(Result);
  case scNegativeFormat of
    0: // (1,1)
    begin
      if (Result[1] = '(') and (Result[Len] = ')') then
      begin
        IsNegative := True;

        Delete(Result, 1, 1);
        Delete(Result, Len, 1);
      end;
    end;
    1, 2: // -1,1 , - 1,1
    begin
      if Result[1] = scNegativeSign then
      begin
        IsNegative := True;
        Delete(Result, 1, 1);
      end;
    end;
    3, 4: // 1,1- , 1,1 -
    begin
      if Result[Len] = scNegativeSign then
      begin
        IsNegative := True;
        Delete(Result, Len, 1);
      end;
    end;
  end;

  Result := Trim(Result);
end;

procedure TSCCustomFloatSpinEdit.SetAllowEmpty(Value: Boolean);
begin
  if FAllowEmpty <> Value then
  begin
    FAllowEmpty := Value;
    if not Value and (Text = '') then
      SetText(scFloatToStr(FMinValue, False));
  end;
end;

procedure TSCCustomFloatSpinEdit.SetDecimalPlaces(Value: Integer);
begin
  if Value < -1 then Value := -1;
  if Value > 20 then Value := 20;

  if FDecimalPlaces <> Value then
  begin
    FDecimalPlaces := Value;
    if not IsLoading and ((Text <> '') or not FAllowEmpty) then
      SetText(ArrangeText(Self.Text));
  end;
end;

procedure TSCCustomFloatSpinEdit.SetEmpty;
begin
  if FAllowEmpty then
    Text := '';
end;

procedure TSCCustomFloatSpinEdit.SetFloatValue(Value: Double);
begin
  if CanSetValue(Value) then
    Text := scFloatToStr(CheckValue(Value), False);
end;

procedure TSCCustomFloatSpinEdit.SetIncrement(Value: Double);
begin
  if Value < 0 then Value := 0;
  FIncrement := Value;
end;

procedure TSCCustomFloatSpinEdit.SetLargeIncrement(Value: Double);
begin
  if Value < 0 then Value := 0;
  FLargeIncrement := Value;
end;

procedure TSCCustomFloatSpinEdit.SetMaxValue(Value: Double);
begin
  if FMaxValue <> Value then
  begin
    FMaxValue := Value;

    if not IsLoading then
    begin
      if FMinValue > FMaxValue then
        FMinValue := FMaxValue;
      SetFloatValue(FloatValue);
    end;
  end;
end;

procedure TSCCustomFloatSpinEdit.SetMinValue(Value: Double);
begin
  if FMinValue <> Value then
  begin
    FMinValue := Value;

    if not IsLoading then
    begin
      if FMaxValue < FMinValue then
        FMaxValue := FMinValue;
      SetFloatValue(FloatValue);
    end;
  end;
end;

procedure TSCCustomFloatSpinEdit.SetUseThousandsSeparator(Value: Boolean);
begin
  if FUseThousandsSeparator <> Value then
  begin
    FUseThousandsSeparator := Value;
    Text := scCurrencyToStr(FloatValue, FUseThousandsSeparator, FDecimalPlaces);
  end;
end;

procedure TSCCustomFloatSpinEdit.SpinControl;
var
  Val: Double;
  DownBtn: TSCEditButton;
begin
  if not Spining or SpinPaused then
    Exit;

  if CanSpin(True) then
  begin
    Val := FloatValue + FIncrement;
    SetFloatValue(Val);

    if (Val >= FMaxValue) and ((FMinValue <> 0) or (FMaxValue <> 0)) then
    begin
      DownBtn := GetDownButton;
      StopSpining;

      if DownBtn <> nil then
        TSCSpinButton(DownBtn).ButtonDown := True;

      Invalidate;
    end;
  end else
  if CanSpin(False) then
  begin
    Val := FloatValue - FIncrement;
    SetFloatValue(Val);

    if (Val <= FMinValue) and ((FMinValue <> 0) or (FMaxValue <> 0)) then
    begin
      DownBtn := GetDownButton;
      StopSpining;

      if DownBtn <> nil then
        TSCSpinButton(DownBtn).ButtonDown := True;

      Invalidate;
    end;
  end;
end;

procedure TSCCustomFloatSpinEdit.UpdateValueFromText;
var
  Val: Double;
begin
  if not IsEmpty then
  begin
    Val := FloatValue;
    if scFloatToStr(CheckValue(Val), False) <> Text then
      SetFloatValue(Val);
  end;
end;

{ TSCCustomCurrencyEdit }

function TSCCustomCurrencyEdit.AddCurrencySymbol(const S: String): String;
var
  CurStr: String;
begin
  Result := Trim(S);
  if Result = '' then
    Exit;

  CurStr := GetCurrencySymbol;

  { Currency Format:
    0 = $1, 1 = 1$, 2 = $ 1, 3 = 1 $ }
  case {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}CurrencyFormat of
    0: Result := CurStr + Result;
    1: Result := Result + CurStr;
    2: Result := CurStr + ' ' + Result;
    3: Result := Result + ' ' + CurStr;
  end;
end;

function TSCCustomCurrencyEdit.AddNegativeSymbol(const S: String;
  Formatting: TSCCurrenyEditFormat): String;
var
  CurrSymbol: String;
begin
  Result := Trim(S);
  if (Result = '') or (Result = '0') then
    Exit;

  if Formatting = sccfFloat then
  begin
    case scNegativeFormat of
      // (1,1)
      0: Result := Format('(%s)',  [Result]);
      // -1,1
      1: Result := Format('%s%s',  [scNegativeSign, Result]);
      // - 1,1
      2: Result := Format('%s %s', [scNegativeSign, Result]);
      // 1,1-
      3: Result := Format('%s%s',  [Result, scNegativeSign]);
      // 1,1 -
      4: Result := Format('%s %s', [Result, scNegativeSign]);
    end;
  end else
  begin
    CurrSymbol := GetCurrencySymbol;

    case scNegativeCurFormat of
       // ($1.1)
       0:	Result := Format('(%s%s)', [CurrSymbol, Result]);
       // -$1.1
       1:	Result := Format('%s%s%s', [scNegativeSign, CurrSymbol, Result]);
       // $-1.1
       2:	Result := Format('%s%s%s', [CurrSymbol, scNegativeSign, Result]);
       // $1.1-
       3:	Result := Format('%s%s%s', [CurrSymbol, Result, scNegativeSign]);
       // (1.1$)
       4:	Result := Format('(%s%s)', [Result, CurrSymbol]);
       // -1.1$
       5:	Result := Format('%s%s%s', [scNegativeSign, Result, CurrSymbol]);
       // 1.1-$
       6:	Result := Format('%s%s%s', [Result, scNegativeSign, CurrSymbol]);
       // 1.1$-
       7:	Result := Format('%s%s%s', [Result, CurrSymbol, scNegativeSign]);
       // -1.1 $ (space before $)
       8:	Result := Format('%s%s %s', [scNegativeSign, Result, CurrSymbol]);
       // -$ 1.1 (space after $)
       9:	Result := Format('%s%s %s', [scNegativeSign, CurrSymbol, Result]);
       // 1.1 $- (space before $)
      10:	Result := Format('%s %s%s', [Result, CurrSymbol, scNegativeSign]);
      // $ 1.1- (space after $)
      11:	Result := Format('%s %s%s', [CurrSymbol, Result, scNegativeSign]);
      // $ -1.1 (space after $)
      12:	Result := Format('%s %s%s', [CurrSymbol, scNegativeSign, Result]);
      // 1.1- $ (space before $)
      13:	Result := Format('%s%s %s', [Result, scNegativeSign, CurrSymbol]);
      // ($ 1.1) (space after $)
      14:	Result := Format('(%s %s)', [CurrSymbol, Result]);
      // (1.1 $) (space before $)
      15:	Result := Format('(%s %s)', [Result, CurrSymbol]);
    end;
  end;
end;

function TSCCustomCurrencyEdit.ArrangeSeparators(const S: String;
  AddThousands: Boolean): String;
var
  Len, P, I: Integer;
  DecimalChar, ThousandChar: Char;
  Decimals, Thousands, Tmp: String;
begin
  Result := Trim(S);

  Decimals := '';
  Thousands := Result;

  Len := Length(Result);
  if (Len = 0) and FAllowEmpty then
    Exit;

  DecimalChar := GetDecimalSeparator;
  ThousandChar := GetThousandSeparator;

  P := Pos(DecimalChar, S);

  if P > 0 then
  begin
    Decimals := Trim(Copy(Result, P + 1, Len - P));
    Delete(Thousands, P, Len - P + 1);

    Thousands := Trim(Thousands);

    Len := Length(Decimals);
    if (FDecimalPlaces > -1) and (Len > FDecimalPlaces) then
      Decimals := Trim(Copy(Decimals, 1, FDecimalPlaces));

    for I := 1 to Length(Decimals) do
      if not (Decimals[I] in ['0'..'9']) then
      begin
        Decimals := Trim(Copy(Decimals, 1, I-1));
        Break;
      end;
  end;

  Thousands := StringReplace(Thousands, ThousandChar, '', [rfReplaceAll]);
  Len := Length(Thousands);

  for I := 1 to Len do
    if not (Thousands[I] in ['0'..'9']) then
    begin
      Thousands := Trim(Copy(Thousands, 1, I-1));
      Break;
    end;

  if AddThousands and (Length(Thousands) > 3) then
  begin
    Tmp := '';
    while Length(Thousands) > 3 do
    begin
      Len := Length(Thousands);
      Tmp := Copy(Thousands, Len - 2, 3) + ThousandChar + Tmp;

      Delete(Thousands, Len - 2, 3);
    end;

    if Thousands <> '' then
      Tmp := Thousands + ThousandChar + Tmp;

    Thousands := Tmp;
    Len := Length(Thousands);
    if (Thousands <> '') and (Thousands[Len] = ThousandChar) then
      Delete(Thousands, Len, 1);
  end;

  if (Thousands = '') and (Decimals = '') then
  begin
    Result := '';
    Exit;
  end;

  Len := Length(Decimals);

  if FDecimalPlaces > -1 then
  begin
    if Len > FDecimalPlaces then
      Decimals := Trim(Copy(Decimals, 1, FDecimalPlaces))
    else if Len < FDecimalPlaces then
      Decimals := Decimals + StringOfChar('0', FDecimalPlaces - Len);
  end else
  if FDecimalPlaces = -1 then
  begin
    for I := Length(Decimals) downto 1 do
    begin
      if Decimals[I] <> '0' then
        Break;

      Delete(Decimals, I, 1);
    end;
  end;

  if Length(Decimals) > 20 then
    Decimals := Copy(Decimals, 1, 20);

  Result := Thousands;
  if Decimals <> '' then
    Result := Result + DecimalChar + Decimals;
end;

function TSCCustomCurrencyEdit.ArrangeText(const S: String): String;
var
  IsNegative: Boolean;
begin
  Result := '';
  if (S = '') and FAllowEmpty then
    Exit;

  IsNegative := False;
  try
    Result := Trim(inherited ArrangeText(Trim(S)));
    if Result = '' then
      Result := scCurrencyToStr(FMinValue, FUseThousandsSeparator, FDecimalPlaces);

    if (FEditFormat = sccfPercentageLeft) and (Result[1] = '%') then
      Delete(Result, 1, 1)
    else if (FEditFormat = sccfPercentageRight) and (Result[Length(Result)] = '%') then
      Delete(Result, Length(Result), 1);

    Result := RemoveNegativeSymbol(Result, EditFormat, IsNegative);
    Result := RemoveCurrencySymbol(Result);

    Result := ArrangeSeparators(Result, False);

    if IsNegative and (FEditFormat = sccfCurrency) and not FUseNegativeCurrency then
    begin
      IsNegative := False;
      Result := '0';
    end else
    if not scIsFloat(Result, FEditFormat = sccfCurrency) then
      Result := scCurrencyToStr(FMinValue, FUseThousandsSeparator, FDecimalPlaces);

    Result := ArrangeSeparators(Result, FUseThousandsSeparator);

    if IsNegative then
      Result := AddNegativeSymbol(Result, EditFormat)
    else if FEditFormat = sccfCurrency then
      Result := AddCurrencySymbol(Result);

    if FEditFormat = sccfPercentageLeft then
      Result := '%' + Result
    else if FEditFormat = sccfPercentageRight then
      Result := Result + '%';
  except
    Result := scCurrencyToStr(FMinValue, FUseThousandsSeparator, FDecimalPlaces);
  end;
end;

procedure TSCCustomCurrencyEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomCurrencyEdit then
  begin
    with TSCCustomCurrencyEdit(Source) do
    begin
      Self.AllowEmpty := AllowEmpty;
      Self.CurrencySymbol := CurrencySymbol;
      Self.DecimalPlaces := DecimalPlaces;
      Self.EditFormat := EditFormat;
      Self.FloatValue := FloatValue;
      Self.Increment := Increment;
      Self.LargeIncrement := LargeIncrement;
      Self.MinValue := MinValue;
      Self.MaxValue := MaxValue;
      Self.UseNegativeCurrency := UseNegativeCurrency;
      Self.UseThousandsSeparator := UseThousandsSeparator;
    end;
  end;
end;

function TSCCustomCurrencyEdit.CanPasteStr(var S: String): Boolean;
begin
  Result := inherited CanPasteStr(S);
  
  if Result then
  begin
    if S[1] = '%' then
      Delete(S, 1, 1)
    else if S[Length(S)] = '%' then
      Delete(S, Length(S), 1);

    RemoveCurrencySymbol(S);

    Result := scIsFloat(S);
  end;
end;

function TSCCustomCurrencyEdit.CanSetValue(var Value: Double): Boolean;
begin
  Result := IsDesigning or (Enabled and not ReadOnly);

  if Result and ((FMinValue <> 0) or (FMaxValue <> 0)) then
  begin
    if Value < FMinValue then
      Value := FMinValue
    else if Value > FMaxValue then
      Value := FMaxValue;
  end;

  if Result and (Value < 0) and (FEditFormat = sccfCurrency) then
    Result := FUseNegativeCurrency;
end;

function TSCCustomCurrencyEdit.CanSpin(AsUp: Boolean): Boolean;
var
  F: Double;
  IsZero: Boolean;
  DownBtn: TSCEditButton;
begin
  Result := inherited CanSpin(AsUp);
  if Result then
  begin
    DownBtn := GetDownButton;

    if DownBtn <> nil then
    begin
      IsZero := (FMaxValue = 0) and (FMinValue = 0);

      F := FloatValue;
      Result := (AsUp and (IsZero or (F < FMaxValue))) or
        (not AsUp and (IsZero or (F > FMinValue)));

      if Result and (F = 0) and not AsUp and (FEditFormat = sccfCurrency) then
        Result := FUseNegativeCurrency;
    end;
  end;
end;

procedure TSCCustomCurrencyEdit.CheckEmpty;
begin
  if not FAllowEmpty then
  begin
    if Text = '' then
    begin
      if not FAllowEmpty then
         SetText(scCurrencyToStr(FMinValue, FUseThousandsSeparator, FDecimalPlaces));
    end else
      SetText(scCurrencyToStr(CheckValue(FloatValue), FUseThousandsSeparator, FDecimalPlaces));
  end;
end;

function TSCCustomCurrencyEdit.CheckValue(Value: Double): Double;
begin
  Result := Value;
  if (FMinValue <> 0) or (FMaxValue <> 0) then
  begin
    if Value < FMinValue then
      Result := FMinValue
    else
    if Value > FMaxValue then
      Result := FMaxValue;
  end;
end;

constructor TSCCustomCurrencyEdit.Create(AOwner: TComponent);
begin
  FAllowEmpty := False;
  FDecimalPlaces := -1;
  FEditFormat := sccfCurrency;
  FUseNegativeCurrency := True;
  FUseThousandsSeparator := True;
  inherited Create(AOwner);
  FIncrement := 1;
  FLargeIncrement := 10;
  FMinValue := 0;
  FMaxValue := 0;
end;

procedure TSCCustomCurrencyEdit.DoButtonClick(Btn: TSCEditButton);
begin
  if Btn = FUpButton then
    SetFloatValue(FloatValue + FIncrement)
  else
  if Btn = FDownButton then
    SetFloatValue(FloatValue - FIncrement);

  inherited DoButtonClick(Btn);
end;

procedure TSCCustomCurrencyEdit.DoPageDown(var Key: Word);
begin
  if FLargeIncrement > 0 then
  begin
    Key := 0;
    SetFloatValue(FloatValue - FLargeIncrement);
  end;
end;

procedure TSCCustomCurrencyEdit.DoPageUp(var Key: Word);
begin
  if FLargeIncrement > 0 then
  begin
    Key := 0;
    SetFloatValue(FloatValue + FLargeIncrement);
  end;
end;

procedure TSCCustomCurrencyEdit.FocusChanged;
begin
  inherited FocusChanged;
  if not HasFocus and ((Self.Text <> '') or not FAllowEmpty) then
    SetText(ArrangeText(Self.Text));
end;

function TSCCustomCurrencyEdit.GetCurrencySymbol: String;
begin
  Result := Self.CurrencySymbol;
  if Result = '' then Result := {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}CurrencyString;
end;

function TSCCustomCurrencyEdit.GetDecimalSeparator: Char;
begin
  Result := {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DecimalSeparator;
  (* if FEditFormat = sccfCurrency then
    Result := scCurDecimalSeparator; *)
end;

function TSCCustomCurrencyEdit.GetFloatText: String;
var
  IsNegative: Boolean;
begin
  Result := Trim(Text);
  if Result = '' then
    Exit;

  if (FEditFormat = sccfPercentageLeft) and (Result[1] = '%') then
    Delete(Result, 1, 1)
  else if (FEditFormat = sccfPercentageRight) and (Result[Length(Result)] = '%') then
    Delete(Result, Length(Result), 1);

  Result := RemoveNegativeSymbol(Result, EditFormat, IsNegative);
  Result := RemoveCurrencySymbol(Result);

  Result := ArrangeSeparators(Result, False);

  if (Result <> '') and not scIsFloat(Result, False) then
    Result := scCurrencyToStr(FMinValue, False, FDecimalPlaces);

  Result := ArrangeSeparators(Result, False);

  if IsNegative then
    Result := AddNegativeSymbol(Result, sccfFloat);

  Result := StringReplace(Result, GetThousandSeparator, '', [rfReplaceAll]);
end;

function TSCCustomCurrencyEdit.GetFloatValue: Double;
var
  S: String;
  E: Extended;
  IsNegative: Boolean;
begin
  S := Trim(Text);
  if S = '' then
  begin
    Result := GetUnFloatValue;
    Exit;
  end;

  try
    if (FEditFormat = sccfPercentageLeft) and (S[1] = '%') then
      Delete(S, 1, 1)
    else if (FEditFormat = sccfPercentageRight) and (S[Length(S)] = '%') then
      Delete(S, Length(S), 1);

    S := RemoveNegativeSymbol(S, EditFormat, IsNegative);
    // if not IsNegative then S := RemoveCurrencySymbol(S);
    S := RemoveCurrencySymbol(S);

    S := ArrangeSeparators(S, False);
    if IsNegative then S := scNegativeSign + S;

    if scIsFloat(S, E) then
      Result := E
    else  
      Result := GetUnFloatValue;
  except
    Result := GetUnFloatValue;
  end;
end;

function TSCCustomCurrencyEdit.GetThousandSeparator: Char;
begin
  Result := {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator;
  (* if FEditFormat = sccfCurrency then
    Result := scCurThousandSeparator; *)
end;

function TSCCustomCurrencyEdit.GetUnFloatValue: Double;
begin
  Result := FMinValue;
end;

procedure TSCCustomCurrencyEdit.InsertChar(Ch: Char);
var
  CurStr: String;
begin
  CurStr := GetCurrencySymbol;

  if (FEditFormat = sccfCurrency) and (Pos(Ch, CurStr) = 0) then
  begin
    if Pos(UpCase(Ch), CurStr) > 0 then
      Ch := UpCase(Ch)
    else
    if Pos(LowerCase(Ch), CurStr) > 0 then
      Ch := LowerCase(Ch)[1];
  end;

  inherited InsertChar(Ch);
end;

function TSCCustomCurrencyEdit.IsEmpty: Boolean;
begin
  Result := FAllowEmpty and (Text = '');
end;

function TSCCustomCurrencyEdit.IsIncrementStored: Boolean;
begin
  Result := FIncrement <> 1;
end;

function TSCCustomCurrencyEdit.IsLargeIncrementStored: Boolean;
begin
  Result := FLargeIncrement <> 10;
end;

function TSCCustomCurrencyEdit.IsMaxValueStored: Boolean;
begin
  Result := FMaxValue <> 0;
end;

function TSCCustomCurrencyEdit.IsMinValueStored: Boolean;
begin
  Result := FMaxValue <> 0;
end;

function TSCCustomCurrencyEdit.IsValidKey(Key: Char): Boolean;
var
  CurStr: String;
  DecimalChar, ThousandChar: Char;
begin
  CurStr := GetCurrencySymbol;
  DecimalChar := GetDecimalSeparator;
  ThousandChar := GetThousandSeparator;

  Result := inherited IsValidKey(Key) and
    (
     (Key in [DecimalChar, ThousandChar, '+', '0'..'9']) or
     ((Key < #32) and (Key <> Chr(VK_RETURN))) or
     ((Key = scNegativeSign) and (FUseNegativeCurrency or (FEditFormat <> sccfCurrency))) or
     ((FEditFormat = sccfCurrency) and ({$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}NegCurrFormat = 0) and FUseNegativeCurrency and (Key in ['(', ' ', ')'])) or
     ((FEditFormat = sccfFloat) and (scNegativeFormat = 0) and (Key in ['(', ')'])) or
     ((FEditFormat = sccfCurrency) and (Pos(Key, CurStr) > 0)) or
     ((FEditFormat = sccfCurrency) and (Pos(UpCase(Key), CurStr) > 0)) or
     ((FEditFormat = sccfCurrency) and (Pos(LowerCase(Key), CurStr) > 0)) or
     ((FEditFormat in [sccfPercentageLeft, sccfPercentageRight]) and (Key in ['%', ' ']))
    );

  if Result and (Key in [DecimalChar, ThousandChar, '+', scNegativeSign]) then
    Result := (Pos(Key, Text) = 0) or (Pos(Key, SelText) > 0)
end;

function TSCCustomCurrencyEdit.IsValidText: Boolean;
var
  S: String;
  IsNegative: Boolean;
begin
  Result := True;

  S := Trim(Text);
  if (S = '') and FAllowEmpty then
    Exit;

  if (FEditFormat = sccfPercentageLeft) and (S[1] = '%') then
    Delete(S, 1, 1)
  else if (FEditFormat = sccfPercentageRight) and (S[Length(S)] = '%') then
    Delete(S, Length(S), 1);

  S := RemoveNegativeSymbol(S, EditFormat, IsNegative);
  S := RemoveCurrencySymbol(S);

  S := ArrangeSeparators(S, False);

  Result := scIsFloat(S, FEditFormat = sccfCurrency);
end;

procedure TSCCustomCurrencyEdit.OverwriteChar(Ch: Char);
var
  CurStr: String;
begin
  CurStr := GetCurrencySymbol;

  if (FEditFormat = sccfCurrency) and (Pos(Ch, CurStr) = 0) then
  begin
    if Pos(UpCase(Ch), CurStr) > 0 then
      Ch := UpCase(Ch)
    else
    if Pos(LowerCase(Ch), CurStr) > 0 then
      Ch := LowerCase(Ch)[1];
  end;

  inherited OverwriteChar(Ch);
end;

function TSCCustomCurrencyEdit.RemoveCurrencySymbol(
  const S: String; UseFormat: Boolean): String;
var
  Len: Integer;
  CurStr: String;
begin
  Result := Trim(S);
  CurStr := GetCurrencySymbol;

  if Result <> '' then
  begin
    Len := Length(CurStr);

    if not UseFormat then
    begin
      if Copy(Result, 1, Len) = CurStr then
        Delete(Result, 1, Len);

      if Copy(Result, Length(Result) - Len + 1, Len) = CurStr then
        Delete(Result, Length(Result) - Len + 1, Len);
    end else
    begin
      { Currency Format:
        0 = $1, 1 = 1$, 2 = $ 1, 3 = 1 $ }
      case {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}CurrencyFormat of
        0, 2:
        begin
          if Copy(Result, 1, Len) = CurStr then
            Delete(Result, 1, Len);
        end;
        1, 3:
        begin
          if Copy(Result, Length(Result) - Len + 1, Len) = CurStr then
            Delete(Result, Length(Result) - Len + 1, Len);
        end;
      end;
    end;

    Result := Trim(Result);
  end;
end;

function TSCCustomCurrencyEdit.RemoveNegativeSymbol(const S: String;
  Formatting: TSCCurrenyEditFormat; var IsNegative: Boolean): String;
var
  P, Len: Integer;
begin
  IsNegative := False;

  Result := Trim(S);
  if Result = '' then
    Exit;

  if Formatting = sccfFloat then
  begin
    Len := Length(Result);
    case scNegativeFormat of
      0: // (1,1)
      begin
        if (Result[1] = '(') and (Result[Len] = ')') then
        begin
          IsNegative := True;

          Delete(Result, Len, 1);
          Delete(Result, 1, 1);
        end;
      end;
      1, 2: // -1,1 , - 1,1
      begin
        if Result[1] = scNegativeSign then
        begin
          IsNegative := True;
          Delete(Result, 1, 1);
        end;
      end;
      3, 4: // 1,1- , 1,1 -
      begin
        if Result[Len] = scNegativeSign then
        begin
          IsNegative := True;
          Delete(Result, Len, 1);
        end;
      end;
    end;

    Result := Trim(Result);

    Len := Length(Result);
    if not IsNegative and (Len > 0) then
    begin
      P := Pos('-', Result);

      if not ((P = 1) or (P = Len)) then
      begin
        Result := Trim(RemoveCurrencySymbol(Result));
        P := Pos('-', Result);
        Len := Length(Result);
      end;

      if (P = 1) or ((Len > 0) and (P = Len)) then
      begin
        IsNegative := True;

        Delete(Result, P, 1);
        Result := Trim(Result);

        Result := Trim(RemoveCurrencySymbol(Result));
      end;
    end;

    Exit;
  end;

  { Negative Currency Format:
    0 = ($1), 1 = -$1, 2 = $-1, 3 = $1-,
    4 = (1$), 5 = -1$, 6 = 1-$, 7 = 1$-,
    8 = -1 $, 9 = -$ 1, 10 = 1 $-, 11 = $ 1-,
    12 = $ -1, 13 = 1- $, 14 = ($ 1), 15 = (1 $)
  }
  if {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}NegCurrFormat in [0, 4, 14, 15] then
  begin
    Len := Length(Result);

    if (Result[1] = '(') and (Len > 0) and (Result[Len] = ')') then
    begin
      IsNegative := True;

      Delete(Result, Len, 1);
      Delete(Result, 1, 1);
    end;

    Result := RemoveCurrencySymbol(Result);
  end else
  if {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}NegCurrFormat in [3, 7, 10, 11] then
  begin
    Len := Length(Result);

    if Result[Len] = scNegativeSign then
    begin
      IsNegative := True;
      Delete(Result, Len, 1);
    end;

    Result := RemoveCurrencySymbol(Result);
  end else
  if {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}NegCurrFormat in [1, 5, 8, 9] then
  begin
    if Result[1] = scNegativeSign then
    begin
      IsNegative := True;
      Delete(Result, 1, 1);
    end;

    Result := RemoveCurrencySymbol(Result);
  end else
  if {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}NegCurrFormat in [2, 6, 12, 13] then
  begin
    Result := RemoveCurrencySymbol(Result);

    Len := Length(Result);
    if Len = 0 then
      Exit;

    if {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}NegCurrFormat in [2, 12] then
    begin
      if Result[1] = scNegativeSign then
      begin
        IsNegative := True;
        Delete(Result, 1, 1);
      end;
    end else
    if Result[Len] = scNegativeSign then
    begin
      IsNegative := True;
      Delete(Result, Len, 1);
    end;

    Result := Trim(Result);
  end;

  Len := Length(Result);
  if not IsNegative and (Len > 0) then
  begin
    P := Pos('-', Result);

    if not ((P = 1) or (P = Len)) then
    begin
      Result := Trim(RemoveCurrencySymbol(Result));
      P := Pos('-', Result);
      Len := Length(Result);
    end;

    if (P = 1) or ((Len > 0) and (P = Len)) then
    begin
      IsNegative := True;

      Delete(Result, P, 1);
      Result := Trim(Result);

      Result := Trim(RemoveCurrencySymbol(Result));
    end;
  end;
end;

procedure TSCCustomCurrencyEdit.SetAllowEmpty(Value: Boolean);
begin
  if FAllowEmpty <> Value then
  begin
    FAllowEmpty := Value;
    if not Value and (Text = '') then
      SetText(scCurrencyToStr(FMinValue, FUseThousandsSeparator, FDecimalPlaces));
  end;
end;

procedure TSCCustomCurrencyEdit.SetCurrencySymbol(const Value: String);
begin
  if FCurrencySymbol <> Value then
  begin
    FCurrencySymbol := Value;

    if not IsLoading and ((Self.Text <> '') or not FAllowEmpty) then
    begin
      SetFloatValue(FloatValue);
      SetText(ArrangeText(Self.Text));
    end;
  end;
end;

procedure TSCCustomCurrencyEdit.SetDecimalPlaces(Value: Integer);
begin
  if Value < -1 then Value := -1;
  if Value > 20 then Value := 20;

  if FDecimalPlaces <> Value then
  begin
    FDecimalPlaces := Value;
    if not IsLoading and ((Self.Text <> '') or not FAllowEmpty) then
      SetText(ArrangeText(Self.Text));
  end;
end;

procedure TSCCustomCurrencyEdit.SetEditFormat(Value: TSCCurrenyEditFormat);
var
  Val: Double;
begin
  if FEditFormat <> Value then
  begin
    Val := FloatValue;

    FEditFormat := Value;
    Text := scCurrencyToStr(Val, FUseThousandsSeparator, FDecimalPlaces);
  end;
end;

procedure TSCCustomCurrencyEdit.SetEmpty;
begin
  if FAllowEmpty then
    Text := '';
end;

procedure TSCCustomCurrencyEdit.SetFloatValue(Value: Double);
begin
  if CanSetValue(Value) then
    Text := ArrangeText(scCurrencyToStr(CheckValue(Value), FUseThousandsSeparator, FDecimalPlaces));
end;

procedure TSCCustomCurrencyEdit.SetIncrement(Value: Double);
begin
  if Value < 1 then Value := 1;
  FIncrement := Value;
end;

procedure TSCCustomCurrencyEdit.SetLargeIncrement(Value: Double);
begin
  if Value < 0 then Value := 0;
  FLargeIncrement := Value;
end;

procedure TSCCustomCurrencyEdit.SetMaxValue(Value: Double);
begin
  if FMaxValue <> Value then
  begin
    FMaxValue := Value;

    if not IsLoading then
    begin
      if FMinValue > FMaxValue then
        FMinValue := FMaxValue;
      SetFloatValue(FloatValue);
    end;
  end;
end;

procedure TSCCustomCurrencyEdit.SetMinValue(Value: Double);
begin
  if FMinValue <> Value then
  begin
    FMinValue := Value;

    if not IsLoading then
    begin
      if FMaxValue < FMinValue then
        FMaxValue := FMinValue;
      SetFloatValue(FloatValue);
    end;
  end;
end;

procedure TSCCustomCurrencyEdit.SetUseNegativeCurrency(Value: Boolean);
begin
  if FUseNegativeCurrency <> Value then
  begin
    FUseNegativeCurrency := Value;
    if not FUseNegativeCurrency and (FEditFormat = sccfCurrency) and (Text <> '') then
      Text := ArrangeText(Text);
  end;
end;

procedure TSCCustomCurrencyEdit.SetUseThousandsSeparator(Value: Boolean);
begin
  if FUseThousandsSeparator <> Value then
  begin
    FUseThousandsSeparator := Value;
    if (Self.Text <> '') or not FAllowEmpty  then
      SetText(scCurrencyToStr(FloatValue, FUseThousandsSeparator, FDecimalPlaces));
  end;
end;

procedure TSCCustomCurrencyEdit.SpinControl;
var
  Val: Double;
  DownBtn: TSCEditButton;
begin
  if not Spining or SpinPaused then
    Exit;

  if CanSpin(True) then
  begin
    Val := FloatValue + FIncrement;
    SetFloatValue(Val);

    if (Val >= FMaxValue) and ((FMinValue <> 0) or (FMaxValue <> 0)) then
    begin
      DownBtn := GetDownButton;
      StopSpining;

      if DownBtn <> nil then
        TSCSpinButton(DownBtn).ButtonDown := True;

      Invalidate;
    end;
  end else
  if CanSpin(False) then
  begin
    Val := FloatValue - FIncrement;
    SetFloatValue(Val);

    if (Val <= FMinValue) and ((FMinValue <> 0) or (FMaxValue <> 0)) then
    begin
      DownBtn := GetDownButton;
      StopSpining;

      if DownBtn <> nil then
        TSCSpinButton(DownBtn).ButtonDown := True;

      Invalidate;
    end;
  end;
end;

procedure TSCCustomCurrencyEdit.UpdateValueFromText;
begin
  if not IsEmpty then
    SetFloatValue(FloatValue);
end;

{ TSCSpinDropDownButtonProps }

procedure TSCSpinDropDownButtonProps.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCSpinDropDownButtonProps then
  begin
    with TSCSpinDropDownButtonProps(Source) do
    begin
      Self.ArrowColor := ArrowColor;
      Self.Color := Color;
      Self.Visible := Visible;
    end;
  end;
end;

constructor TSCSpinDropDownButtonProps.Create(AOwner: TSCCustomSpinEdit);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCSpinDropDownButtonProps.GetArrowColor: TColor;
begin
  Result := clBtnText;
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    Result := TSCCustomSpinEdit(Owner).GetDropDownArrowColor;
end;

function TSCSpinDropDownButtonProps.GetColor: TColor;
begin
  Result := clBtnFace;
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    Result := TSCCustomSpinEdit(Owner).GetDropDownColor;
end;

function TSCSpinDropDownButtonProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCSpinDropDownButtonProps.GetVisible: Boolean;
begin
  Result := False;
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    Result := TSCCustomSpinEdit(Owner).GetDropDownVisible;
end;

procedure TSCSpinDropDownButtonProps.SetArrowColor(Value: TColor);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    TSCCustomSpinEdit(Owner).SetDropDownArrowColor(Value);
end;

procedure TSCSpinDropDownButtonProps.SetColor(Value: TColor);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    TSCCustomSpinEdit(Owner).SetDropDownColor(Value);
end;

procedure TSCSpinDropDownButtonProps.SetVisible(Value: Boolean);
begin
  if (Owner <> nil) and (Owner is TSCCustomSpinEdit) then
    TSCCustomSpinEdit(Owner).SetDropDownVisible(Value);
end;

{$I SCVerRec.inc}

end.
