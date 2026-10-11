{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCCalculator;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Math, Clipbrd, SCCommon, SCConsts, SCResStrs, SCControl, SCAdvEdits;

type
  TSCCalculatorPart = (sccpNone, sccpDisplay, sccpMC, sccpMR, sccpMS,
    sccpMPlus, sccpBack, sccpCancel, sccpClear, sccpSqrt, sccpPercent,
    sccp1X, sccpResult, sccpDivide, sccpMultiply, sccpPlus, sccpMinus,
    sccpSign, sccpDecimal, sccpNumber0, sccpNumber1, sccpNumber2,
    sccpNumber3, sccpNumber4, sccpNumber5, sccpNumber6, sccpNumber7,
    sccpNumber8, sccpNumber9);

  TSCCalculatorButton = class(TPersistent)
  private
    FAction: TSCCalculatorPart;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FCaption: String;
    FEnabled: Boolean;
    FVisible: Boolean;
    FOnChange: TNotifyEvent;
    procedure SetAction(Value: TSCCalculatorPart);
    procedure SetLeft(Value: Integer);
    procedure SetTop(Value: Integer);
    procedure SetWidth(Value: Integer);
    procedure SetHeight(Value: Integer);
    function  GetBoundsRect: TRect;
    procedure SetBoundsRect(const Value: TRect);
    procedure SetCaption(const Value: String);
    procedure SetEnabled(Value: Boolean);
    procedure SetVisible(Value: Boolean);
  protected
    procedure Changed;
  public
    constructor Create; virtual;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);

    property Action: TSCCalculatorPart read FAction write SetAction default sccpNone;
    property BoundsRect: TRect read GetBoundsRect write SetBoundsRect;
    property Left: Integer read FLeft write SetLeft default 0;
    property Top: Integer read FTop write SetTop default 0;
    property Width: Integer read FWidth write SetWidth default 0;
    property Height: Integer read FHeight write SetHeight default 0;
    property Caption: String read FCaption write SetCaption;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Visible: Boolean read FVisible write SetVisible default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TSCCalculatorColors = class(TPersistent)
  private
    FButton: TColor;
    FDisplay: TColor;
    FDisplayText: TColor;
    FDisabledButton: TColor;
    FDisabledButtonBlended: Boolean;
    FDisabledButtonText: TColor;
    FEditButton: TColor;
    FEditButtonText: TColor;
    FFunctionButton: TColor;
    FFunctionButtonText: TColor;
    FMemoryButton: TColor;
    FMemoryButtonText: TColor;
    FNumberButton: TColor;
    FNumberButtonText: TColor;
    FOperatorButton: TColor;
    FOperatorButtonText: TColor;
    FOnChange: TNotifyEvent;
    procedure SetButton(Value: TColor);
    procedure SetDisplay(Value: TColor);
    procedure SetDisplayText(Value: TColor);
    procedure SetDisabledButton(Value: TColor);
    procedure SetDisabledButtonBlended(Value: Boolean);
    procedure SetDisabledButtonText(Value: TColor);
    procedure SetEditButton(Value: TColor);
    procedure SetEditButtonText(Value: TColor);
    procedure SetFunctionButton(Value: TColor);
    procedure SetFunctionButtonText(Value: TColor);
    procedure SetMemoryButton(Value: TColor);
    procedure SetMemoryButtonText(Value: TColor);
    procedure SetNumberButton(Value: TColor);
    procedure SetNumberButtonText(Value: TColor);
    procedure SetOperatorButton(Value: TColor);
    procedure SetOperatorButtonText(Value: TColor);
  protected
    procedure Changed;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Button: TColor read FButton write SetButton default clNone;
    property Display: TColor read FDisplay write SetDisplay default clWindow;
    property DisplayText: TColor read FDisplayText write SetDisplayText default clWindowText;
    property DisabledButton: TColor read FDisabledButton write SetDisabledButton default clNone;
    property DisabledButtonBlended: Boolean read FDisabledButtonBlended write SetDisabledButtonBlended default True;
    property DisabledButtonText: TColor read FDisabledButtonText write SetDisabledButtonText default clGrayText;
    property EditButton: TColor read FEditButton write SetEditButton default clNone;
    property EditButtonText: TColor read FEditButtonText write SetEditButtonText default clPurple;
    property FunctionButton: TColor read FFunctionButton write SetFunctionButton default clNone;
    property FunctionButtonText: TColor read FFunctionButtonText write SetFunctionButtonText default clNavy;
    property MemoryButton: TColor read FMemoryButton write SetMemoryButton default clNone;
    property MemoryButtonText: TColor read FMemoryButtonText write SetMemoryButtonText default clRed;
    property NumberButton: TColor read FNumberButton write SetNumberButton default clNone;
    property NumberButtonText: TColor read FNumberButtonText write SetNumberButtonText default clBlue;
    property OperatorButton: TColor read FOperatorButton write SetOperatorButton default clNone;
    property OperatorButtonText: TColor read FOperatorButtonText write SetOperatorButtonText default clRed;
  end;

  TSCCalculatorStyle = (sccalDefault, sccalCorel, sccalFlat, sccalFlatEx,
    sccalFlatHot, sccalOfficeXP, sccalOffice2003, sccalMetal, sccalNew,
    sccalWin2k, sccalXP);

  TSCCalculatorMemory = class(TObject)
  public
    Value: Extended;
  end;

  TSCCalculatorOption = (sccoShowFocus, sccoBeepOnError, sccoShowDisplay,
    sccoShowFunctionButtons, sccoShowMemoryButtons);

  TSCCalculatorOptions = set of TSCCalculatorOption;

const
  SCDefPrecision = 13;
  SCCalculatorDefaultOptions = [sccoShowFocus, sccoBeepOnError,
    sccoShowDisplay, sccoShowFunctionButtons, sccoShowMemoryButtons];
  SCPopupCalcDefaultOptions = [sccoBeepOnError, sccoShowFunctionButtons,
    sccoShowMemoryButtons];

type
  TSCCalculatorState = (sccsFirst, sccsValid, sccsError);
  TSCCalculatorButtonEvent = procedure(Sender: TObject; Action: TSCCalculatorPart) of object;

  TSCCustomCalculator = class(TSCCustomControl)
  private
    FButtons: TList;
    FStyle: TSCCalculatorStyle;
    FColors: TSCCalculatorColors;
    FOptions: TSCCalculatorOptions;
    FDisplayBevel: TSCControlBevel;
    FMemory: Extended;
    FMemoryIsFull: Boolean;
    FEditValue: String;
    FMousePressed: Boolean;
    FDownPart: TSCCalculatorPart;
    FHotPart: TSCCalculatorPart;
    FPressedButton: TSCCalculatorPart;
    FPrecision: Byte;
    FStatus: TSCCalculatorState;
    FOperator: TSCCalculatorPart;
    FOperand: Extended;
    FOnButtonClick: TSCCalculatorButtonEvent;
    FOnError: TNotifyEvent;
    FOnResult: TNotifyEvent;
    FOnValueChange: TNotifyEvent;
    FOnEditChange: TNotifyEvent;
    FDefaultCursor: TCursor;
    FUpdatingCursor: Boolean;
    procedure SetStyle(Value: TSCCalculatorStyle);
    procedure SetColors(Value: TSCCalculatorColors);
    procedure SetEditValue(const Value: String);
    procedure SetOptions(Value: TSCCalculatorOptions);
    procedure SetDisplayBevel(Value: TSCControlBevel);
    function  GetDisplay: Extended;
    procedure SetDisplay(Value: Extended);

    function  GetButtonSpace: Integer;
    function  GetMemorySpace: Integer;
    function  GetButtonIndent: Integer;

    function  GetButtonsWidth: Integer;
    function  GetHorizontalIndent: Integer;

    function  GetDefaultWidth: Integer;
    function  GetDefaultHeight: Integer;
    function  GetDisplayHeight: Integer;
    function  GetDefaultButtonWidth: Integer;
    function  GetDefaultButtonHeight: Integer;

    function  GetDisplayRect: TRect;

    procedure AddToMemory(Value: Extended);
    procedure SetMemory(Value: Extended);
    procedure ClearMemory;

    procedure Reset;
    procedure Error;
    procedure CheckFirst;
    procedure Clear;

    procedure ClearButtons;
    procedure CreateButtons;
    procedure CreateButton(Action: TSCCalculatorPart);

    procedure RefreshHotButton;
    procedure UpdateButtons;
    procedure UpdateButtonRects;

    function  GetButtonBounds(Action: TSCCalculatorPart; W, H,
      HorzIndent, VertIndent: Integer): TRect;

    function  GetBevelSize: Integer;

    procedure DrawDisplay;
    procedure DrawButton(Button: TSCCalculatorButton);

    procedure DoButtonDown(Action: TSCCalculatorPart);
    procedure DoButtonUp(Action: TSCCalculatorPart);
    procedure DoExecuteAction(Action: TSCCalculatorPart);

    procedure ColorsChanged(Sender: TObject);

    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMCursorChanged(var Message: TMessage); message CM_CURSORCHANGED;
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
  protected
    procedure Paint; override;
    function  GetButtonCaption(Action: TSCCalculatorPart): String; virtual;
    function  GetButtonRect(Action: TSCCalculatorPart): TRect;

    procedure UpdateCursor(X, Y: Integer; UseXY: Boolean = False); virtual;

    procedure ConstrainedResize(var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer); override;
    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure AdjustBounds; override;

    procedure CancelKeyDown;

    procedure StopTracking; override;
    procedure MouseInControlChanged; override;
    procedure FocusChanged; override;
    procedure SystemColorsChanged; override;
    procedure EnabledChanged; override;
    procedure IndentChanged; override;

    procedure KeyDown(var Key : Word; Shift : TShiftState); override;
    procedure KeyPress(var Key : Char);  override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property Style: TSCCalculatorStyle read FStyle write SetStyle default sccalDefault;
    property Colors: TSCCalculatorColors read FColors write SetColors;
    property DisplayBevel: TSCControlBevel read FDisplayBevel write SetDisplayBevel default sccbFlat;
    property EditValue: String read FEditValue write SetEditValue;
    property Indent default 8;
    property Options: TSCCalculatorOptions read FOptions write SetOptions default SCCalculatorDefaultOptions;
    property Precision: Byte read FPrecision write FPrecision default SCDefPrecision;
    property Value: Extended read GetDisplay write SetDisplay;
    property Memory: Extended read FMemory;
    property OnButtonClick: TSCCalculatorButtonEvent read FOnButtonClick write FOnButtonClick;
    property OnEditChange: TNotifyEvent read FOnEditChange write FOnEditChange;
    property OnError: TNotifyEvent read FOnError write FOnError;
    property OnResult: TNotifyEvent read FOnResult write FOnResult;
    property OnValueChange: TNotifyEvent read FOnValueChange write FOnValueChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  GetActionChar(Ch : Char) : TSCCalculatorPart;
    function  GetActionKey(Key: Word; Shift: TShiftState) : TSCCalculatorPart;
    function  GetActionKeyUp(Key: Word; Shift: TShiftState) : TSCCalculatorPart;
    function  GetPartAtPos(X, Y: Integer): TSCCalculatorPart;

    procedure PasteFromClipboard;
    procedure CopyToClipboard;
  end;

  TSCCalculator = class(TSCCustomCalculator)
  public
    property Memory;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property Style;
    property ClickFocus;
    property Color;
    property Colors;
    property Constraints;
    property Cursor;
    property DisplayBevel;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Indent;
    property Options;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property Precision;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Transparent;
    property Value;
    property Visible;
    property OnButtonClick;
    property OnCanResize;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnValueChange;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnError;
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
    property OnResult;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomPopupCalculator = class;

  TSCPopupCalculatorProps = class(TPersistent)
  private
    FOwner: TSCCustomPopupCalculator;
    FBorderStyle: TSCEditStyle;
    FColor: TColor;
    FColors: TSCCalculatorColors;
    FDisplayBevel: TSCControlBevel;
    FFont: TFont;
    FOptions: TSCCalculatorOptions;
    FPrecision: Byte;
    FStyle: TSCCalculatorStyle;
    procedure SetBorderStyle(Value: TSCEditStyle);
    procedure SetStyle(Value: TSCCalculatorStyle);
    procedure SetColor(Value: TColor);
    procedure SetColors(Value: TSCCalculatorColors);
    procedure SetDisplayBevel(Value: TSCControlBevel);
    procedure SetFont(Value: TFont);
    procedure SetOptions(Value: TSCCalculatorOptions);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TSCCustomPopupCalculator); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomPopupCalculator read FOwner;
  published
    property BorderStyle: TSCEditStyle read FBorderStyle write SetBorderStyle default scesDefault;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Style: TSCCalculatorStyle read FStyle write SetStyle default sccalDefault;
    property Colors: TSCCalculatorColors read FColors write SetColors;
    property DisplayBevel: TSCControlBevel read FDisplayBevel write SetDisplayBevel default sccbFlat;
    property Font: TFont read FFont write SetFont;
    property Options: TSCCalculatorOptions read FOptions write SetOptions default SCPopupCalcDefaultOptions;
    property Precision: Byte read FPrecision write FPrecision default SCDefPrecision;
  end;

  TSCCustomPopupCalculator = class(TSCCustomDropDown)
  private
    FAllowEmpty: Boolean;
    FFloatValue: Extended;
    FCalculator: TSCCustomCalculator;
    FCalculatorProps: TSCPopupCalculatorProps;
    FDecimalPlaces: Integer;
    FDropText: String;
    FReturnClose: Boolean;
    FClosingCalc: Boolean;
    FUseThousandsSeparator: Boolean;
    FOnPopupResult: TNotifyEvent;
    procedure SetAllowEmpty(Value: Boolean);
    procedure SetCalculatorProps(Value: TSCPopupCalculatorProps);
    procedure SetDecimalPlaces(Value: Integer);
    procedure SetUseThousandsSeparator(Value: Boolean);

    function  ArrangeSeparators(const S: String; AddThousands: Boolean = True): String;
    function  RemoveNegativeSymbol(const S: String; var IsNegative: Boolean): String;
    function  AddNegativeSymbol(const S: String): String;

    procedure ResultClicked(SendeR: TObject);
    procedure EditChanged(SendeR: TObject);
  protected
    procedure Loaded; override;
    function  IsValidKey(Key: Char): Boolean; override;
    function  ArrangeText(const S: String): String; override;

    procedure WndProc(var Message: TMessage); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function  GetFloatValue: Extended; virtual;
    procedure SetFloatValue(Value: Extended); virtual;

    procedure UpdateValueFromText; virtual;

    procedure DoInternalChange; override;
    procedure BeforeExit; override;

    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; override;

    function  GetPopupStyle: TSCEditStyle; override;
    procedure DropDownPopupbox; override;
    procedure CloseUp; override;
    procedure PrepareDropWindow; override;
    procedure AfterCloseUp; override;

    procedure CheckEmpty; dynamic;
    function  CanSetValue(var Value: Extended): Boolean; dynamic;

    function  CanDropDown: Boolean; override;
    function  GetDroppedDown: Boolean; override;
    function  GetDropDownWindow: TWinControl; override;

    function  DoWantKeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    property ClosingCalc: Boolean read FClosingCalc;
    property ReturnClose: Boolean read FReturnClose;

    property AllowEmpty: Boolean read FAllowEmpty write SetAllowEmpty default False;
    property CalculatorProps: TSCPopupCalculatorProps read FCalculatorProps write SetCalculatorProps;
    property DecimalPlaces: Integer read FDecimalPlaces write SetDecimalPlaces default -1;
    property FloatValue: Extended read GetFloatValue write SetFloatValue;
    property IsDropDown default False;
    property UseThousandsSeparator: Boolean read FUseThousandsSeparator
      write SetUseThousandsSeparator default True;
    property Value: Extended read GetFloatValue write SetFloatValue;
    property OnPopupResult: TNotifyEvent read FOnPopupResult write FOnPopupResult;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  IsEmpty: Boolean; dynamic;
    procedure SetEmpty; dynamic;
  end;

  TSCPopupCalculator = class(TSCCustomPopupCalculator)
  public
    property FloatValue;
    property ShowPicture;
    property Text;
  published
    property Align;
    property Alignment;
    property AllowEmpty;
    property Anchors;
    property AutoComplete;
    property AutoSelect;
    property AutoSize;
    property BidiMode;
    property BorderProps;
    property ButtonProps;
    property CalculatorProps;
    property CanSelect;
    property Checkbox;
    property Colors;
    property Constraints;
    property DecimalPlaces;
    property Description;
    property DescriptionMode;
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
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
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
    property Transparent;
    property UndoLimit;
    property UseCaret;
    property UseDefaultMenu;
    property UseImage;
    property UseThousandsSeparator;
    property UseUndo;
    property Value;
    property Visible;
    property OnAutoComplete;
    property OnCanResize;
    property OnCaretMove;
    property OnChange;
    property OnCheckboxChange;
    property OnClick;
    property OnCloseUp;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
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
    property OnPopupResult;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

const
  SCCalcMinButtonWidth = 18;
  SCCalcMinButtonHeight = 18;

  CM_CANCEL = WM_USER + $9876;

  SCMemoryButtons = [sccpMC, sccpMR, sccpMS, sccpMPlus];
  SCFunctionButton = [sccpSqrt, sccpPercent, sccp1X];
  SCOperationButtons = [sccpResult, sccpDivide, sccpMultiply,
    sccpPlus, sccpMinus, sccpSign, sccpDecimal];
  SCEditButtons = [sccpBack, sccpCancel, sccpClear];
  SCNumberButtons = [sccpNumber0, sccpNumber1, sccpNumber2, sccpNumber3,
    sccpNumber4, sccpNumber5, sccpNumber6, sccpNumber7, sccpNumber8,
    sccpNumber9];

  SCOperatorButtons = [sccpPlus, sccpMinus, sccpDivide, sccpMultiply];
  SCResultButtons = [sccpResult, sccpPercent];
  SCRepeatButtons = [sccpBack];

  SCCalculatorCreateOptions = [sccoShowDisplay, sccoShowFunctionButtons,
    sccoShowMemoryButtons];

type
  TSCDropdownCalculator = class(TSCCustomCalculator)
  private
    FInPopup: Boolean;
    FPreparingPopup: Boolean;
    FCancelPopup: Boolean;
    FPopupbox: TSCCustomPopupCalculator;
    FOnCloseUp: TNotifyEvent;
    procedure Cancel;
    procedure CloseUp;
    procedure ActivateForm;
    function  IsChildHandle(AHandle: HWND): Boolean;
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
  protected
    procedure CreateWnd; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;

    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property InPopup: Boolean read FInPopup;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Popup(C: TSCCustomPopupCalculator);
  end;


{ TSCCalculatorButton }

procedure TSCCalculatorButton.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

constructor TSCCalculatorButton.Create;
begin
  inherited Create;
  FAction := sccpNone;
  FEnabled := True;
  FVisible := True;
end;

function TSCCalculatorButton.GetBoundsRect: TRect;
begin
  Result := Rect(FLeft, FTop, FLeft + FWidth, FTop + FHeight);
end;

procedure TSCCalculatorButton.SetAction(Value: TSCCalculatorPart);
begin
  if FAction <> Value then
  begin
    FAction := Value;
    Changed;
  end;
end;

procedure TSCCalculatorButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if ALeft < 0 then ALeft := 0;
  if ATop < 0 then ATop := 0;
  if AWidth < 0 then AWidth := 0;
  if AHeight < 0 then AHeight := 0;

  if (ALeft <> FLeft) or (ATop <> FTop) or
    (FWidth <> AWidth) or (FHeight <> AHeight) then
  begin
    FLeft := ALeft;
    FTop := ATop;
    FWidth := AWidth;
    FHeight := AHeight;

    Changed;
  end;
end;

procedure TSCCalculatorButton.SetBoundsRect(const Value: TRect);
var
  R: TRect;
begin
  R := Value;

  if R.Left < 0 then OffsetRect(R, -R.Left, 0);
  if R.Top < 0 then OffsetRect(R, -R.Top, 0);

  Dec(R.Right, R.Left);
  if R.Right < 0 then R.Right := 0;

  Dec(R.Bottom, R.Top);
  if R.Bottom < 0 then R.Bottom := 0;

  SetBounds(R.Left, R.Top, R.Right, R.Bottom);
end;

procedure TSCCalculatorButton.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    if FVisible then Changed;
  end;
end;

procedure TSCCalculatorButton.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    if FVisible then Changed;
  end;
end;

procedure TSCCalculatorButton.SetHeight(Value: Integer);
begin
  if Value < 0 then
    Value := 0;

  if FHeight <> Value then
  begin
    FHeight := Value;
    if FVisible then Changed;
  end;
end;

procedure TSCCalculatorButton.SetLeft(Value: Integer);
begin
  if Value < 0 then
    Value := 0;

  if FLeft <> Value then
  begin
    FLeft := Value;
    if FVisible then Changed;
  end;
end;

procedure TSCCalculatorButton.SetTop(Value: Integer);
begin
  if Value < 0 then
    Value := 0;

  if FTop <> Value then
  begin
    FTop := Value;
    if FVisible then Changed;
  end;
end;

procedure TSCCalculatorButton.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed;
  end;
end;

procedure TSCCalculatorButton.SetWidth(Value: Integer);
begin
  if Value < 0 then
    Value := 0;

  if FWidth <> Value then
  begin
    FWidth := Value;
    if FVisible then Changed;
  end;
end;

{ TSCCalculatorColors }

procedure TSCCalculatorColors.Assign(Source: TPersistent);
begin
  if Source is TSCCalculatorColors then
  begin
    with TSCCalculatorColors(Source) do
    begin
      Self.FButton := FButton;
      Self.FDisplay := Display;
      Self.FDisplayText := DisplayText;
      Self.FDisabledButton := DisabledButton;
      Self.FDisabledButtonBlended := DisabledButtonBlended;
      Self.FDisabledButtonText := DisabledButtonText;
      Self.FEditButton := EditButton;
      Self.FEditButtonText := EditButtonText;
      Self.FFunctionButton := FunctionButton;
      Self.FFunctionButtonText := FunctionButtonText;
      Self.FMemoryButton := MemoryButton;
      Self.FMemoryButtonText := MemoryButtonText;
      Self.FNumberButton := NumberButton;
      Self.FNumberButtonText := NumberButtonText;
      Self.FOperatorButton := OperatorButton;
      Self.FOperatorButtonText := OperatorButtonText;
    end;
    Changed;
  end else
    inherited Assign(Source);
end;

procedure TSCCalculatorColors.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

constructor TSCCalculatorColors.Create;
begin
  inherited Create;
  FButton := clNone;
  FDisplay := clWindow;
  FDisplayText := clWindowText;
  FDisabledButton := clNone;
  FDisabledButtonBlended := True;
  FDisabledButtonText := clGrayText;
  FEditButton := clNone;
  FEditButtonText := clPurple;
  FFunctionButton := clNone;
  FFunctionButtonText := clNavy;
  FMemoryButton := clNone;
  FMemoryButtonText := clRed;
  FNumberButton := clNone;
  FNumberButtonText := clBlue;
  FOperatorButton := clNone;
  FOperatorButtonText := clRed;
end;

procedure TSCCalculatorColors.SetButton(Value: TColor);
begin
  if FButton <> Value then
  begin
    FButton := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetDisabledButton(Value: TColor);
begin
  if FDisabledButton <> Value then
  begin
    FDisabledButton := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetDisabledButtonBlended(Value: Boolean);
begin
  if FDisabledButtonBlended <> Value then
  begin
    FDisabledButtonBlended := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetDisabledButtonText(Value: TColor);
begin
  if FDisabledButtonText <> Value then
  begin
    FDisabledButtonText := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetDisplay(Value: TColor);
begin
  if FDisplay <> Value then
  begin
    FDisplay := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetDisplayText(Value: TColor);
begin
  if FDisplayText <> Value then
  begin
    FDisplayText := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetEditButton(Value: TColor);
begin
  if FEditButton <> Value then
  begin
    FEditButton := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetEditButtonText(Value: TColor);
begin
  if FEditButtonText <> Value then
  begin
    FEditButtonText := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetFunctionButton(Value: TColor);
begin
  if FFunctionButton <> Value then
  begin
    FFunctionButton := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetFunctionButtonText(Value: TColor);
begin
  if FFunctionButtonText <> Value then
  begin
    FFunctionButtonText := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetMemoryButton(Value: TColor);
begin
  if FMemoryButton <> Value then
  begin
    FMemoryButton := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetMemoryButtonText(Value: TColor);
begin
  if FMemoryButtonText <> Value then
  begin
    FMemoryButtonText := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetNumberButton(Value: TColor);
begin
  if FNumberButton <> Value then
  begin
    FNumberButton := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetNumberButtonText(Value: TColor);
begin
  if FNumberButtonText <> Value then
  begin
    FNumberButtonText := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetOperatorButton(Value: TColor);
begin
  if FOperatorButton <> Value then
  begin
    FOperatorButton := Value;
    Changed;
  end;
end;

procedure TSCCalculatorColors.SetOperatorButtonText(Value: TColor);
begin
  if FOperatorButtonText <> Value then
  begin
    FOperatorButtonText := Value;
    Changed;
  end;
end;

{ TSCCustomCalculator }

procedure TSCCustomCalculator.AddToMemory(Value: Extended);
begin
  FMemoryIsFull := True;

  if Value <> 0 then
  begin
    FMemory := FMemory + Value;
    UpdateButtons;
  end;
end;

procedure TSCCustomCalculator.UpdateButtonRects;
var
  R, CR: TRect;
  Button: TSCCalculatorButton;
  I, W, H, DispHeight, Space,
  HorzIndent, VertIndent: Integer;
begin
  HorzIndent := GetButtonIndent;
  VertIndent := GetButtonIndent;

  CR := ClientRect;

  R := CR;
  InflateRect(R, -HorzIndent, -VertIndent);

  DispHeight := GetDisplayHeight;
  Inc(R.Top, DispHeight);

  OffsetRect(R, -R.Left, -R.Top);

  Dec(R.Right,  4*GetButtonSpace); // Horizontal space between buttons
  Dec(R.Bottom, 4*GetButtonSpace); // Vertical space between buttons

  if sccoShowMemoryButtons in FOptions then
  begin
    Dec(R.Right, GetMemorySpace);
    W := (R.Right - R.Left) div 6;
  end else
    W := (R.Right - R.Left) div 5;

  H := (R.Bottom - R.Top) div 5;

  if W < SCCalcMinButtonWidth then W := SCCalcMinButtonWidth;
  if H < SCCalcMinButtonHeight then H := SCCalcMinButtonHeight;

  Inc(VertIndent, DispHeight);

  Space := 5*W + 4*GetButtonSpace;
  if sccoShowMemoryButtons in FOptions then
    Inc(Space, W + GetMemorySpace);

  Space := ((CR.Right - CR.Left) - Space) div 2;

  if Space > HorzIndent then
    HorzIndent := Space;

  for I := 0 to FButtons.Count-1 do
  begin
    Button := TSCCalculatorButton(FButtons[I]);
    Button.BoundsRect := GetButtonBounds(Button.Action, W, H,
      HorzIndent, VertIndent);

    Button.Visible := True;
    if Button.Action in SCMemoryButtons then
      Button.Visible := sccoShowMemoryButtons in FOptions
    else
    if Button.Action in SCFunctionButton then
      Button.Visible := sccoShowFunctionButtons in FOptions;
  end;

  UpdateButtons;
end;

procedure TSCCustomCalculator.ClearMemory;
begin
  FMemoryIsFull := False;

  if FMemory <> 0 then
  begin
    FMemory := 0;
    UpdateButtons;
  end;
end;

procedure TSCCustomCalculator.ColorsChanged(Sender: TObject);
begin
  Invalidate;
end;

constructor TSCCustomCalculator.Create(AOwner: TComponent);
begin
  FButtons := TList.Create;
  FPrecision := SCDefPrecision;
  FOperator := sccpResult;

  FColors := TSCCalculatorColors.Create;
  FColors.OnChange := ColorsChanged;

  FOptions := SCCalculatorDefaultOptions;

  inherited Create(AOwner);
  DoubleBuffered := True;
  Indent := 8;
  SetBounds(Left, Top, GetDefaultWidth, GetDefaultHeight);
  TabStop := True;

  FDisplayBevel := sccbFlat;
  FDownPart := sccpNone;
  FHotPart := sccpNone;
  FPressedButton := sccpNone;

  FStyle := sccalDefault;

  CreateButtons;
end;

procedure TSCCustomCalculator.CreateButton(Action: TSCCalculatorPart);
var
  Button: TSCCalculatorButton;
begin
  Button := TSCCalculatorButton.Create;
  Button.Action := Action;
  Button.Caption := GetButtonCaption(Action);
  FButtons.Add(Button);
end;

procedure TSCCustomCalculator.CreateButtons;
begin
  ClearButtons;

  if sccoShowMemoryButtons in FOptions then
  begin
    CreateButton(sccpMC);
    CreateButton(sccpMR);
    CreateButton(sccpMS);
    CreateButton(sccpMPlus);
  end;

  CreateButton(sccpBack);
  CreateButton(sccpCancel);
  CreateButton(sccpClear);

  if sccoShowFunctionButtons in FOptions then
  begin
    CreateButton(sccpSqrt);
    CreateButton(sccpPercent);
    CreateButton(sccp1X);
  end;

  CreateButton(sccpResult);
  CreateButton(sccpDivide);
  CreateButton(sccpMultiply);
  CreateButton(sccpPlus);
  CreateButton(sccpMinus);
  CreateButton(sccpSign);
  CreateButton(sccpDecimal);

  CreateButton(sccpNumber0);
  CreateButton(sccpNumber1);
  CreateButton(sccpNumber2);
  CreateButton(sccpNumber3);
  CreateButton(sccpNumber4);
  CreateButton(sccpNumber5);
  CreateButton(sccpNumber6);
  CreateButton(sccpNumber7);
  CreateButton(sccpNumber8);
  CreateButton(sccpNumber9);

  Reset;

  RefreshHotButton;
  UpdateButtonRects;
end;

destructor TSCCustomCalculator.Destroy;
begin
  ClearButtons;
  FreeAndNil(FButtons);
  FreeAndNil(FColors);
  inherited Destroy;
end;

procedure TSCCustomCalculator.ClearButtons;
var
  I: Integer;
begin
  FDownPart := sccpNone;
  FHotPart := sccpNone;
  
  for I := FButtons.Count-1 downto 0 do
  begin
    TObject(FButtons[I]).Free;
    FButtons.Delete(I);
  end;

  Reset;
end;

procedure TSCCustomCalculator.DoExecuteAction(Action: TSCCalculatorPart);
begin
  if Action in [sccpNone, sccpDisplay] then
    Exit;

  if Assigned(FOnButtonClick) then
    FOnButtonClick(Self, Action);

  if (FStatus = sccsError) and not (Action in [sccpClear, sccpCancel]) then
  begin
    Error;
    Exit;
  end;

  if Action = sccpDecimal then
  begin
    CheckFirst;
    if Pos({$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DecimalSeparator, EditValue) = 0 then
      SetEditValue(EditValue + {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DecimalSeparator);

    Exit;
  end;
  
  case Action of
    sccp1X:
      if FStatus in [sccsValid, sccsFirst] then
      begin
        FStatus := sccsFirst;
        if FOperator in SCOperatorButtons then
           FStatus := sccsValid;

        if GetDisplay = 0 then Error
        else SetDisplay(1.0 / GetDisplay);
      end;
    sccpSqrt:
      if FStatus in [sccsValid, sccsFirst] then
      begin
        FStatus := sccsFirst;
        if FOperator in SCOperatorButtons then
           FStatus := sccsValid;
           
        if GetDisplay < 0 then Error
        else SetDisplay(Sqrt(GetDisplay));
      end;
    sccpNumber0..sccpNumber9:
    begin
      CheckFirst;
      if EditValue = '0' then SetEditValue('');

      if Length(EditValue) < Max(2, FPrecision) + Ord(Boolean(Pos('-', EditValue))) then
         SetEditvalue(EditValue + Char(Ord('0')+ Byte(Action) - Byte(sccpNumber0)))
      else if sccoBeepOnError in FOptions then
        Beep;
    end;
    sccpBack:
    begin
      CheckFirst;
      if (Length(EditValue) = 1) or ((Length(EditValue) = 2) and (EditValue[1] = '-')) then
        SetEditValue('0')
      else
        SetEditValue(System.Copy(EditValue, 1, Length(EditValue) - 1));
    end;
    sccpSign:
      SetDisplay(-GetDisplay);
    sccpPlus, sccpMinus, sccpMultiply,
    sccpDivide, sccpResult, sccpPercent:
    begin
      if FStatus = sccsValid then
      begin
        FStatus := sccsFirst;
        Value := GetDisplay;

        if Action = sccpPercent then
          case FOperator of
            sccpPlus, sccpMinus:
              Value := FOperand * Value / 100.0;
            sccpMultiply, sccpDivide:
              Value := Value / 100.0;
          end;

        case FOperator of
          sccpPlus:
            SetDisplay(FOperand + Value);
          sccpMinus:
            SetDisplay(FOperand - Value);
          sccpMultiply:
            SetDisplay(FOperand * Value);
          sccpDivide:
            if Value = 0 then Error
            else SetDisplay(FOperand / Value);
        end;
      end;

      FOperator := Action;
      FOperand := GetDisplay;

      if (Action in SCResultButtons) and Assigned(FOnResult) then
        FOnResult(Self);
    end;
    sccpClear, sccpCancel:
      Clear;
    sccpMPlus:
      if FStatus in [sccsValid, sccsFirst] then
      begin
        FStatus := sccsFirst;
        AddToMemory(GetDisplay);
      end;
    sccpMS:
      if FStatus in [sccsValid, sccsFirst] then
      begin
        FStatus := sccsFirst;
        SetMemory(GetDisplay);
      end;
    sccpMR:
      if FStatus in [sccsValid, sccsFirst] then
      begin
        FStatus := sccsFirst;
        CheckFirst;
        SetDisplay(FMemory);
      end;
    sccpMC:
      ClearMemory;
  end;
end;

procedure TSCCustomCalculator.DrawDisplay;
var
  R, DR: TRect;
  S: String;
  B: Integer;
  C1, Cl, FnCl: TColor;
begin
  if not (sccoShowDisplay in FOptions) then
    Exit;

  R := GetDisplayRect;

  if not IsRectEmpty(R) then
  begin
    Cl := FColors.Display;

    if Cl = clNone then Cl := Self.Color;
    if Cl = clNone then Cl := clWindow;

    FnCl := FColors.DisplayText;

    if FnCl = clNone then FnCl := Self.Font.Color;
    if FnCl = clNone then FnCl := clWindowText;

    B := GetBevelSize;

    DR := R;
    InflateRect(DR, -B, -B);

    with Canvas do
    begin
      if FColors.Display <> clNone then
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(DR);
      end;  

      C1 := Cl;
      if C1 = clNone then C1 := Self.Color;
      if C1 = clNone then C1 := clWindow;

      if FDisplayBevel in [sccbFlat, sccbFlatBold, sccbFlatBoldRounded,
        sccbFlatRounded, sccbColor] then
        C1 := GetBtnShadowOf(C1);

      scDrawBevel(Canvas, R, C1, clNone, False, FDisplayBevel, [scbeLeft..scbeBottom]);
      InflateRect(R, -4, -2);

      Font.Assign(Self.Font);
      Font.Color := FnCl;

      S := FEditValue;
      if S = '' then S := '0';

      DrawText(Handle, PChar(S), Length(S), R,
        DT_RIGHT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
    end;
  end;
end;

function TSCCustomCalculator.GetButtonCaption(Action: TSCCalculatorPart): String;
begin
  Result := '';

  case Action of
    sccpMC:
      Result := 'MC';
    sccpMR:
      Result := 'MR';
    sccpMS:
      Result := 'MS';
    sccpMPlus:
      Result := 'M+';
    sccpBack:
      Result := 'Back';
    sccpCancel:
      Result := 'CE';
    sccpClear:
      Result := 'Clear';
    sccpSqrt:
      Result := 'Sqrt';
    sccpPercent:
      Result := '%';
    sccp1X:
      Result := '1/x';
    sccpResult:
      Result := '=';
    sccpDivide:
      Result := '/';
    sccpMultiply:
      Result := '*';
    sccpPlus:
      Result := '+';
    sccpMinus:
      Result := '-';
    sccpSign:
      Result := '-/+';
    sccpDecimal:
      Result := '.';
    sccpNumber0:
      Result := '0';
    sccpNumber1:
      Result := '1';
    sccpNumber2:
      Result := '2';
    sccpNumber3:
      Result := '3';
    sccpNumber4:
      Result := '4';
    sccpNumber5:
      Result := '5';
    sccpNumber6:
      Result := '6';
    sccpNumber7:
      Result := '7';
    sccpNumber8:
      Result := '8';
    sccpNumber9:
      Result := '9';
  end;
end;

function TSCCustomCalculator.GetButtonIndent: Integer;
begin
  Result := Indent;
end;

function TSCCustomCalculator.GetMemorySpace: Integer;
begin
  Result := 6;
end;

function TSCCustomCalculator.GetButtonSpace: Integer;
begin
  Result := 3;
end;

procedure TSCCustomCalculator.Paint;
var
  Cl: TColor;
  CR, R: TRect;
  I, SR: Integer;
  Button: TSCCalculatorButton;
begin
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
      
        Brush.Color := Cl;

        FillRect(CR);
      end;

    DrawPicture(Canvas);

    for I := 0 to FButtons.Count - 1 do
    begin
      Button := TSCCalculatorButton(FButtons[I]);
      R := GetButtonRect(Button.Action);

      if not IsRectEmpty(R) then
      begin
        SR := IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
        try
          if SR <> NULLREGION then
            DrawButton(Button);
        finally
          SelectClipRgn(Canvas.Handle, 0);
        end;
      end;
    end;
  end;

  DrawDisplay;
end;

function TSCCustomCalculator.GetButtonBounds(Action: TSCCalculatorPart;
  W, H, HorzIndent, VertIndent: Integer): TRect;
var
  EditW, ARight, Spare,
  TotalEditW, ButtonSpace: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  ButtonSpace := GetButtonSpace;

  TotalEditW := 5*W + 4*ButtonSpace;
  EditW := (TotalEditW - 2*ButtonSpace) div 3;

  ARight := TotalEditW + HorzIndent;
  if sccoShowMemoryButtons in FOptions then
    Inc(ARight, W + GetMemorySpace);

  case Action of
    sccpMC:
    begin
      Result.Left := 0;
      Result.Top := H + ButtonSpace;
    end;
    sccpMR:
    begin
      Result.Left := 0;
      Result.Top := 2*(H + ButtonSpace);
    end;
    sccpMS:
    begin
      Result.Left := 0;
      Result.Top := 3*(H + ButtonSpace);
    end;
    sccpMPlus:
    begin
      Result.Left := 0;
      Result.Top := 4*(H + ButtonSpace);
    end;
    sccpBack:
    begin
      Result.Top := VertIndent;

      Result.Right := ARight - 2*(EditW + ButtonSpace);
      Result.Left := Result.Right - EditW;

      Spare := TotalEditW - (3*EditW + 2*ButtonSpace);
      if Spare > 0 then
        OffsetRect(Result, -Spare, 0);
    end;
    sccpCancel:
    begin
      Result.Top := VertIndent;

      Result.Right := ARight - (EditW + ButtonSpace);
      Result.Left := Result.Right - EditW;

      Spare := TotalEditW - (3*EditW + 2*ButtonSpace);
      if Spare > 0 then
        OffsetRect(Result, -(Spare div 2), 0);
    end;
    sccpClear:
    begin
      Result.Top := VertIndent;

      Result.Right := ARight;
      Result.Left := Result.Right - EditW;
    end;
    sccpSqrt:
    begin
      Result.Left := 4*(W + ButtonSpace);
      Result.Top := H + ButtonSpace;
    end;
    sccpPercent:
    begin
      Result.Left := 4*(W + ButtonSpace);
      Result.Top := 2*(H + ButtonSpace);
    end;
    sccp1X:
    begin
      Result.Left := 4*(W + ButtonSpace);
      Result.Top := 3*(H + ButtonSpace);
    end;
    sccpResult:
    begin
      Result.Left := 4*(W + ButtonSpace);
      Result.Top := 4*(H + ButtonSpace);

      if sccoShowFunctionButtons in FOptions then
        Result.Bottom := Result.Top + H
      else begin
        Result.Top := H + ButtonSpace;
        Result.Bottom := Result.Top + 4*H + 3*ButtonSpace;
      end;
    end;
    sccpDivide:
    begin
      Result.Left := 3*(W + ButtonSpace);
      Result.Top := H + ButtonSpace;
    end;
    sccpMultiply:
    begin
      Result.Left := 3*(W + ButtonSpace);
      Result.Top := 2*(H + ButtonSpace);
    end;
    sccpMinus:
    begin
      Result.Left := 3*(W + ButtonSpace);
      Result.Top := 3*(H + ButtonSpace);
    end;
    sccpPlus:
    begin
      Result.Left := 3*(W + ButtonSpace);
      Result.Top := 4*(H + ButtonSpace);
    end;
    sccpDecimal:
    begin
      Result.Left := 2*(W + ButtonSpace);
      Result.Top := 4*(H + ButtonSpace);
    end;
    sccpSign:
    begin
      Result.Left := W + ButtonSpace;
      Result.Top := 4*(H + ButtonSpace);
    end;
    sccpNumber0:
    begin
      Result.Left := 0;
      Result.Top := 4*(H + ButtonSpace);
    end;
    sccpNumber1:
    begin
      Result.Left := 0;
      Result.Top := 3*(H + ButtonSpace);
    end;
    sccpNumber2:
    begin
      Result.Left := W + ButtonSpace;
      Result.Top := 3*(H + ButtonSpace);
    end;
    sccpNumber3:
    begin
      Result.Left := 2*(W + ButtonSpace);
      Result.Top := 3*(H + ButtonSpace);
    end;
    sccpNumber4:
    begin
      Result.Left := 0;
      Result.Top := 2*(H + ButtonSpace);
    end;
    sccpNumber5:
    begin
      Result.Left := W + ButtonSpace;
      Result.Top := 2*(H + ButtonSpace);
    end;
    sccpNumber6:
    begin
      Result.Left := 2*(W + ButtonSpace);
      Result.Top := 2*(H + ButtonSpace);
    end;
    sccpNumber7:
    begin
      Result.Left := 0;
      Result.Top := H + ButtonSpace;
    end;
    sccpNumber8:
    begin
      Result.Left := W + ButtonSpace;
      Result.Top := H + ButtonSpace;
    end;
    sccpNumber9:
    begin
      Result.Left := 2*(W + ButtonSpace);
      Result.Top := H + ButtonSpace;
    end;
  end;

  if Action <> sccpResult then
    Result.Bottom := Result.Top + H;

  if not (Action in [sccpBack, sccpCancel, sccpClear]) then
  begin
    Result.Right := Result.Left + W;

    if (sccoShowMemoryButtons in FOptions) and
      not (Action in SCMemoryButtons) then
      OffsetRect(Result, W + GetMemorySpace, 0);

    OffsetRect(Result, HorzIndent, VertIndent);
  end;
end;

procedure TSCCustomCalculator.SetStyle(Value: TSCCalculatorStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TSCCustomCalculator.SetColors(Value: TSCCalculatorColors);
begin
  FColors.Assign(Value);
end;

procedure TSCCustomCalculator.SetDisplay(Value: Extended);
var
  S: string;
begin
  S := FloatToStrF(Value, ffGeneral, Max(2, FPrecision), 0);
  if FEditValue <> S then
  begin
    SetEditValue(S);
    if Assigned(FOnValueChange) then FOnValueChange(Self);
  end;
end;

procedure TSCCustomCalculator.SetMemory(Value: Extended);
begin
  FMemoryIsFull := True;

  if FMemory <> Value then
  begin
    FMemory := Value;
    UpdateButtons;
  end;
end;

function TSCCustomCalculator.GetPartAtPos(X, Y: Integer): TSCCalculatorPart;
var
  P: TPoint;
  I: Integer;
  R, CR: TRect;
  Button: TSCCalculatorButton;
begin
  Result := sccpNone;
  if not HandleAllocated then
    Exit;

  P := Point(X, Y);

  CR := ClientRect;
  InflateRect(CR, -GetButtonIndent, -GetButtonIndent);

  if IsRectEmpty(CR) or not PtInRect(CR, P) then
    Exit;

  for I := 0 to FButtons.Count-1 do
  begin
    Button := TSCCalculatorButton(FButtons[I]);
    
    if Button.Enabled and Button.Visible and
      PtInRect(Button.BoundsRect, P) then
    begin
      Result := Button.Action;
      Exit;
    end;
  end;

  R := GetDisplayRect;
  if not IsRectEmpty(R) and PtInRect(R, P) then
    Result := sccpDisplay;
end;

function TSCCustomCalculator.GetDefaultHeight: Integer;
var
  B: Integer;
begin
  Result := 5*GetDefaultButtonHeight + 4*GetButtonSpace +
    2*GetButtonIndent + GetDisplayHeight;

  B := GetBorderSize + BorderWidth;
  Inc(Result, 2*B);
end;

function TSCCustomCalculator.GetDefaultWidth: Integer;
var
  B: Integer;
begin
  Result := 5*GetDefaultButtonWidth + 4*GetButtonSpace + 2*GetButtonIndent;
  if sccoShowMemoryButtons in FOptions then
    Inc(Result, GetDefaultButtonWidth + GetMemorySpace);

  B := GetBorderSize + BorderWidth;
  Inc(Result, 2*B);
end;

procedure TSCCustomCalculator.SetOptions(Value: TSCCalculatorOptions);
var
  NewOptions, OldOptions: TSCCalculatorOptions;
begin
  if FOptions <> Value then
  begin
    OldOptions := FOptions - (FOptions - SCCalculatorCreateOptions);
    NewOptions := Value - (Value - SCCalculatorCreateOptions);
    
    FOptions := Value;

    if NewOptions <> OldOptions then
    begin
      CreateButtons;
      if AutoSize then AdjustBounds;
    end else
      Invalidate;
  end;
end;

function TSCCustomCalculator.GetDisplayHeight: Integer;
begin
  Result := 0;
  if sccoShowDisplay in FOptions then
  begin
    Result := 21;
    
    if HandleAllocated then
    begin
      Canvas.Font.Assign(Self.Font);
      Result := Canvas.TextHeight('0');

      Inc(Result, 8);
    end;

    Inc(Result, 8);
  end;
end;

function TSCCustomCalculator.GetDefaultButtonHeight: Integer;
begin
  Result := 24;
end;

function TSCCustomCalculator.GetDefaultButtonWidth: Integer;
begin
  Result := 28;
end;

procedure TSCCustomCalculator.DrawButton(Button: TSCCalculatorButton);
var
  S: String;
  Blend: Boolean;
  L, T: Integer;
  BR, CR, TmpR: TRect;
  IsDown, IsHot: Boolean;
  RealCl, Cl, FnCl, BkCl, Cl1, Cl2: TColor;
begin
  if (Button = nil) or not Button.Visible then
    Exit;
    
  IsDown := (FDownPart <> sccpDisplay) and
    (((FPressedButton in [sccpNone, sccpDisplay]) and
    not (FDownPart in [sccpNone, sccpDisplay]) and
    (FDownPart = Button.Action)) or ((FPressedButton = Button.Action) and
    not (FPressedButton in [sccpNone, sccpDisplay])));
    
  IsHot := (FDownPart <> sccpDisplay) and
    (((FPressedButton = Button.Action) and not (FPressedButton in [sccpNone, sccpDisplay])) or
    ((FPressedButton = sccpNone) and not (FHotPart in [sccpNone, sccpDisplay]) and
    (FHotPart = Button.Action) and ((FDownPart = sccpNone) or (FDownPart = FHotPart))));

  S := Button.Caption;
  BR := Button.BoundsRect;

  RealCl := FColors.Button;

  Cl := FColors.Button;
  if Cl = clNone then Cl := Self.Color;

  FnCl := Self.Font.Color;

  Blend := False;

  if not Button.Enabled then
  begin
    Blend := FColors.DisabledButtonBlended;
    RealCl := FColors.DisabledButton;

    Cl := FColors.DisabledButton;
    FnCl := FColors.DisabledButtonText;
  end else
  if Button.Action in SCMemoryButtons then
  begin
    RealCl := FColors.MemoryButton;

    Cl := FColors.MemoryButton;
    FnCl := FColors.MemoryButtonText;
  end else
  if Button.Action in SCFunctionButton then
  begin
    RealCl := FColors.FunctionButton;

    Cl := FColors.FunctionButton;
    FnCl := FColors.FunctionButtonText;
  end else
  if Button.Action in SCOperationButtons then
  begin
    RealCl := FColors.OperatorButton;

    Cl := FColors.OperatorButton;
    FnCl := FColors.OperatorButtonText;
  end else
  if Button.Action in SCEditButtons then
  begin
    RealCl := FColors.EditButton;

    Cl := FColors.EditButton;
    FnCl := FColors.EditButtonText;
  end else
  if Button.Action in SCNumberButtons then
  begin
    RealCl := FColors.NumberButton;

    Cl := FColors.NumberButton;
    FnCl := FColors.NumberButtonText;
  end;

  if Cl = clNone then Cl := Self.Color;

  if FnCl = clNone then
  begin
    FnCl := Self.Font.Color;
    if not Button.Enabled then
    begin
      FnCl := clGrayText;
      if Cl <> clNone then FnCl := GetBtnShadowOf(Cl);
    end;
  end;  

  if Cl = clNone then Cl := clBtnFace;
  if FnCl = clNone then FnCl := clBtnText;

  BkCl := Self.Color;
  if BkCl = clNone then BkCl := clBtnFace;

  if (FStyle in [sccalFlatEx, sccalFlatHot]) and IsDown and IsHot then
  begin
    FnCl := GetBtnHighlightOf(Cl);
    Cl := Get3DDkShadowOf(Cl);
  end else
  if (FStyle = sccalFlatHot) and IsHot then
  begin
    FnCl := GetBtnHighlightOf(Cl);
    Cl := GetBtnShadowOf(Cl);
  end else
  if FStyle = sccalOfficeXP then
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
  if FStyle = sccalOffice2003 then
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
    Font := Self.Font;
    Font.Color := FnCl;

    if not ((RealCl = clNone) and (FStyle in [sccalCorel, sccalDefault,
      sccalFlat, sccalFlatEx, sccalMetal, sccalWin2k])) then
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      if Blend then
        Brush.Color := SCCommon.scBlendColor(Cl, 24);

      FillRect(BR);
    end;

    CR := BR;
    DrawText(Handle, PChar(S), Length(S), CR,
      DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or DT_CALCRECT);

    OffsetRect(CR, -CR.Left, -CR.Top);

    if not IsRectEmpty(CR) then
    begin
      L := BR.Left + (((BR.Right - BR.Left) - CR.Right) div 2);
      T := BR.Top + (((BR.Bottom - BR.Top) - CR.Bottom) div 2);

      if IsDown and IsHot and not (FStyle in [sccalOfficeXP,
        sccalOffice2003, sccalFlatEx, sccalFlatHot]) then
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

  case FStyle of
    sccalDefault:
    begin
      if IsDown and IsHot then
      begin
        scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0);
        scFrame3D(Canvas, BR, Get3DDkShadowOf(Cl), Cl, 1, 0);
      end else
      begin
        scFrame3D(Canvas, BR, GetBtnHighlightOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
        scFrame3D(Canvas, BR, Cl, GetBtnShadowOf(Cl), 1, 0);
      end;
    end;
    sccalCorel:
    begin
      if IsDown and IsHot then
      begin
        scFrame3D(Canvas, BR, Get3DDkShadowOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
        scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
      end else
      if IsHot or IsDown then
      begin
        scFrame3D(Canvas, BR, GetBtnHighlightOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
        scFrame3D(Canvas, BR, Cl, GetBtnShadowOf(Cl), 1, 0);
      end else
        scFrame3D(Canvas, BR, GetBtnHighlightOf(Cl), GetBtnShadowOf(Cl), 1, 0);
    end;
    sccalFlat:
    begin
      if IsDown and IsHot then
        scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0)
      else
      if IsDown or IsHot then
        scFrame3D(Canvas, BR, GetBtnHighlightOf(Cl), GetBtnShadowOf(Cl), 1, 0);
    end;
    sccalFlatEx:
    begin
      scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
    end;
    sccalFlatHot:
    begin
      if not IsHot then
        scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
    end;
    sccalOfficeXP:
    begin
      if IsDown or IsHot then
        scFrame3D(Canvas, BR, clHighlight, clHighlight, 1, 0);
    end;
    sccalOffice2003:
    begin
      if not (IsDown or IsHot) then
      begin
        Cl1 := BlendedColor(Cl, 48, 48, 48, True);
        Cl2 := BlendedColor(Cl, 24, 24, 24, False);

        if Blend then
        begin
          Cl1 := SCCommon.scBlendColor(Cl1, 24);
          Cl2 := SCCommon.scBlendColor(Cl2, 24);
        end;

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
    sccalMetal:
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
    sccalNew:
    begin
      with Canvas do
      begin
        if not (IsDown and IsHot) then
        begin
          Brush.Style := bsSolid;

          if Blend then
            Cl := SCCommon.scBlendColor(Cl, 24);

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
    sccalWin2k:
    begin
      if IsDown and IsHot then
      begin
        scFrame3D(Canvas, BR, Get3DDkShadowOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
        scFrame3D(Canvas, BR, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
      end else
      begin
        scFrame3D(Canvas, BR, GetBtnHighlightOf(Cl), Get3DDkShadowOf(Cl), 1, 0);
        scFrame3D(Canvas, BR, Cl, GetBtnShadowOf(Cl), 1, 0);
      end;
    end;
    sccalXP:
    begin
      scDrawXPFace2(scskVertical, Canvas, BR, Cl, BkCl, False, IsDown, IsHot);

      with Canvas do
      begin
        Brush.Style := bsClear;

        DrawText(Handle, PChar(S), Length(S), CR,
          DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
      end;
    end;
  end;

  if HasFocus and (sccoShowFocus in FOptions) and (Button.Action = sccpResult) then
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      BR := Button.BoundsRect;
      InflateRect(BR, -3, -3);

      scDrawFocusRect(Canvas, BR, Cl);
    end;
end;

function TSCCustomCalculator.GetButtonRect(Action: TSCCalculatorPart): TRect;
var
  I: Integer;
  Button: TSCCalculatorButton;
begin
  Result := Rect(0, 0, 0, 0);
  if FButtons = nil then Exit;

  for I := 0 to FButtons.Count-1 do
  begin
    Button := TSCCalculatorButton(FButtons[I]);
    
    if Button.Action = Action then
    begin
      Result := Button.BoundsRect;
      Exit;
    end;
  end;
end;

procedure TSCCustomCalculator.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateButtonRects;
end;

procedure TSCCustomCalculator.SetDisplayBevel(Value: TSCControlBevel);
begin
  if FDisplayBevel <> Value then
  begin
    FDisplayBevel := Value;
    if sccoShowDisplay in FOptions then
      Invalidate;
  end;
end;

procedure TSCCustomCalculator.AdjustBounds;
begin
  if HandleAllocated then
  begin
    AdjustSize;
    UpdateButtonRects;
  end;
end;

function TSCCustomCalculator.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := True;
  if HandleAllocated and AutoSize and not (IsLoading or IsDestroying) then
  begin
    NewWidth  := GetDefaultWidth;
    NewHeight := GetDefaultHeight;
  end;
end;

procedure TSCCustomCalculator.ConstrainedResize(var MinWidth, MinHeight,
  MaxWidth, MaxHeight: Integer);
begin
  inherited ConstrainedResize(MinWidth, MinHeight, MaxWidth, MaxHeight);

  if AutoSize then
  begin
    MinWidth := GetDefaultWidth;
    MinHeight := GetDefaultHeight;

    MaxHeight := MinHeight;
    MaxWidth  := MinWidth;
  end;
end;

procedure TSCCustomCalculator.EnabledChanged;
begin
  FMousePressed := False;
  FPressedButton := sccpNone;
  FDownPart := sccpNone;
  FHotPart := sccpNone;

  if Enabled then RefreshHotButton;

  UpdateButtons;
  inherited EnabledChanged;
end;

procedure TSCCustomCalculator.FocusChanged;
begin
  FMousePressed := False;
  FPressedButton := sccpNone;
  FDownPart := sccpNone;
  FHotPart := sccpNone;

  inherited FocusChanged;
  if HasFocus then
    RefreshHotButton;

  Invalidate;
end;

procedure TSCCustomCalculator.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewButton, OldButton: TSCCalculatorPart;
begin
  inherited KeyDown(Key, Shift);

  OldButton := FPressedButton;
  NewButton := GetActionKey(Key, Shift);

  if Key = VK_INSERT then
  begin
    if Shift = [ssShift] then
      PasteFromClipboard
    else if (Shift = [ssCtrl]) then
      CopyToClipboard;
  end else
  if Key = VK_ESCAPE then
  begin
    if not (OldButton in [sccpNone, sccpDisplay]) then
    begin
      Key := 0;
      NewButton := sccpNone;
    end;

    if GetCapture = Handle then
      ReleaseCapture;
  end;

  if not (NewButton in [sccpNone, sccpDisplay]) and (OldButton <> NewButton) then
  begin
    DoButtonUp(OldButton);
    FPressedButton := NewButton;
    DoButtonDown(FPressedButton);
  end;
end;

procedure TSCCustomCalculator.KeyPress(var Key: Char);
var
  NewButton, OldButton: TSCCalculatorPart;
begin
  inherited KeyPress(Key);

  if Key = ^V then
    PasteFromClipboard
  else if Key = ^C then
    CopyToClipboard;

  OldButton := FPressedButton;
  NewButton := GetActionChar(Key);

  if OldButton <> NewButton then
  begin
    DoButtonUp(OldButton);
    FPressedButton := NewButton;
    DoButtonDown(FPressedButton);
  end;
  
  if not (NewButton in [sccpNone, sccpDisplay]) and (FPressedButton in SCRepeatButtons) then
    DoExecuteAction(FPressedButton);
end;

procedure TSCCustomCalculator.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDownPart := sccpNone;
  FHotPart  := sccpNone;
  
  inherited MouseDown(Button, Shift, X, Y);

  if CanFocus and not HasFocus and ClickFocus then
    SetFocus;

  FMousePressed := Button = mbLeft;
  SetCapture(Handle);

  FMousePressed := Button = mbLeft;

  UpdateCursor(X, Y, True);

  if FMousePressed then
  begin
    FDownPart := GetPartAtPos(X, Y);
    FHotPart  := FDownPart;
  end;

  Invalidate;
end;

procedure TSCCustomCalculator.MouseInControlChanged;
var
  OldHot: TSCCalculatorPart;
begin
  OldHot := FHotPart;

  if not MouseInControl then
    FHotPart := sccpNone
  else
    RefreshHotButton;

  if OldHot <> FHotPart then
    Invalidate;

  UpdateCursor(-1, -1);
  inherited MouseInControlChanged;
end;

procedure TSCCustomCalculator.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  OldHot: TSCCalculatorPart;
begin
  UpdateCursor(X, Y, True);

  OldHot := FHotPart;
  FHotPart := GetPartAtPos(X, Y);

  if (OldHot <> FHotPart) and (FPressedButton in [sccpNone, sccpDisplay]) and
    ((FDownPart in [sccpNone, sccpDisplay]) or (FDownPart in [OldHot, FHotPart])) then
    Invalidate;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomCalculator.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldHot, OldDown: TSCCalculatorPart;
begin
  UpdateCursor(X, Y, True);

  OldHot := FHotPart;
  OldDown := FDownPart;

  FDownPart := sccpNone;
  FHotPart := GetPartAtPos(X, Y);
  
  if FMousePressed then
  begin
    FMousePressed := False;
    if not (OldDown in [sccpNone, sccpDisplay]) and (OldDown = FHotPart) then
      DoExecuteAction(OldDown);
  end;

  if (OldDown <> FDownPart) or (OldHot <> FHotPart) then
    Invalidate;

  UpdateCursor(X, Y, True);
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomCalculator.SystemColorsChanged;
begin
  Invalidate;
end;

procedure TSCCustomCalculator.UpdateButtons;
var
  I: Integer;
  Vis, Enable: Boolean;
  Button: TSCCalculatorButton;
begin
  if FButtons <> nil then
    for I := 0 to FButtons.Count-1 do
    begin
      Button := TSCCalculatorButton(FButtons[I]);

      Vis := True;
      if Button.Action in SCMemoryButtons then
        Vis := sccoShowMemoryButtons in FOptions
      else
      if Button.Action in SCFunctionButton then
        Vis := sccoShowFunctionButtons in FOptions;

      Enable := Self.Enabled;
      if Button.Action in [sccpMC, sccpMR] then
        Enable := Self.Enabled and FMemoryIsFull;

      Button.Enabled := Enable;  
      Button.Visible := Vis;
    end;

  Invalidate;
end;

procedure TSCCustomCalculator.RefreshHotButton;
var
  P: TPoint;
begin
  if HandleAllocated and not (IsDesigning or IsLoading) then
  begin
    GetCursorPos(P);
    P := Self.ScreenToClient(P);

    FHotPart := GetPartAtPos(P.x, P.y);
  end;
end;

procedure TSCCustomCalculator.StopTracking;
begin
  FMousePressed := False;
  FPressedButton := sccpNone;
  FDownPart := sccpNone;
  FHotPart := sccpNone;

  Invalidate;
  inherited StopTracking;
end;

procedure TSCCustomCalculator.CopyToClipboard;
begin
  Clipboard.AsText := EditValue;
end;

function TSCCustomCalculator.GetActionChar(Ch: Char): TSCCalculatorPart;
begin
  Result := sccpNone;
  case Ch of
    '0': Result := sccpNumber0;
    '1': Result := sccpNumber1;
    '2': Result := sccpNumber2;
    '3': Result := sccpNumber3;
    '4': Result := sccpNumber4;
    '5': Result := sccpNumber5;
    '6': Result := sccpNumber6;
    '7': Result := sccpNumber7;
    '8': Result := sccpNumber8;
    '9': Result := sccpNumber9;
    '+': Result := sccpPlus;
    '-': Result := sccpMinus;
    '*': Result := sccpMultiply;
    '/': Result := sccpDivide;
    '%': Result := sccpPercent;
    '@': Result := sccpSqrt;
    #8 : Result := sccpBack;
    '=', #13, Char(VK_SPACE):
      Result := sccpResult;
    Char(VK_ESCAPE):
      Result := sccpClear;
    else
      if Ch in [{$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DecimalSeparator, ',', Char(VK_DECIMAL)] then
        Result := sccpDecimal;
  end;
end;

function TSCCustomCalculator.GetActionKey(Key: Word;
  Shift: TShiftState): TSCCalculatorPart;
begin
  Result := sccpNone;
  case Key of
    VK_RETURN:
      Result := sccpResult;
    VK_ESCAPE:
      Result := sccpClear;
    VK_F9:
      Result := sccpSign;
    VK_DELETE:
      Result := sccpCancel;
    Ord('C'):
      if not (ssCtrl in Shift) then
        Result := sccpClear;
    Ord('P'):
      if ssCtrl in Shift then
        Result := sccpMPlus;
    Ord('L'):
      if ssCtrl in Shift then
        Result := sccpMC;
    Ord('R'):
      if ssCtrl in Shift then
        Result := sccpMR
      else Result := sccp1X;
    Ord('M'):
      if ssCtrl in Shift then
        Result := sccpMS;
  end;
end;

procedure TSCCustomCalculator.KeyUp(var Key: Word; Shift: TShiftState);
var
  Button: TSCCalculatorPart;
begin
  inherited KeyUp(Key, Shift);

  Button := GetActionKeyUp(Key, Shift);
  if Button = FPressedButton then
    DoButtonUp(Button);
end;

procedure TSCCustomCalculator.PasteFromClipboard;
var
  I: Integer;
  S, S1: String;
begin
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    try
      S := Clipboard.AsText;
      S1 := '';

      repeat
        I := Pos({$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}CurrencyString, S);
        if I > 0 then
        begin
          S1 := S1 + Copy(S, 1, I - 1);
          S := Copy(S, i + Length({$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}CurrencyString), MaxInt);
        end
        else
          S1 := S1 + S;
      until I <= 0;

      SetDisplay(StrToFloat(Trim(S1)));
      FStatus := sccsValid;
    except
      SetDisplay(0.0);
    end;
  end;  
end;

procedure TSCCustomCalculator.DoButtonDown(Action: TSCCalculatorPart);
var
  OldDown: TSCCalculatorPart;
begin
  if not (Action in [sccpNone, sccpDisplay]) then
  begin
    OldDown := FDownPart;
    FDownPart := Action;

    if OldDown <> FDownPart then
      Invalidate;

    UpdateCursor(-1, -1);  
    if not (Action in SCRepeatButtons) then
      DoExecuteAction(Action);
  end;
end;

procedure TSCCustomCalculator.DoButtonUp(Action: TSCCalculatorPart);
var
  OldDown, OldPress: TSCCalculatorPart;
begin
  if not (Action in [sccpNone, sccpDisplay]) then
  begin
    OldDown := FDownPart;
    OldPress := FPressedButton;

    FPressedButton := sccpNone;
    if FDownPart = Action then
      FDownPart := sccpNone;

    if (OldDown <> FDownPart) or (OldPress <> FPressedButton) then
      Invalidate;

    UpdateCursor(-1, -1);  
  end;
end;

procedure TSCCustomCalculator.Reset;
begin
  FOperator := sccpResult;
  FStatus := sccsFirst;
  ClearMemory;
end;

procedure TSCCustomCalculator.Error;
begin
  FStatus := sccsError;
  SetEditValue(SSCCalcError);
  if sccoBeepOnError in FOptions then
    Beep;
    
  if Assigned(FOnError) then FOnError(Self);
end;

procedure TSCCustomCalculator.SetEditValue(const Value: String);
begin
  if FEditValue <> Value then
  begin
    FEditValue := Value;
    DrawDisplay;

    if Assigned(FOnEditChange) then
      FOnEditChange(Self);
  end;
end;

function TSCCustomCalculator.GetDisplay: Extended;
var
  S: string;
begin
  if FStatus = sccsError then
    Result := 0.0
  else begin
    S := Trim(FEditValue);
    if S = '' then S := '0';
    Result := StrToFloat(S);
  end;
end;

procedure TSCCustomCalculator.CheckFirst;
begin
  if FStatus = sccsFirst then
  begin
    FStatus := sccsValid;
    SetEditValue('0');
  end;
end;

procedure TSCCustomCalculator.Clear;
begin
  FStatus := sccsFirst;
  SetDisplay(0.0);
  FOperator := sccpResult;
end;

function TSCCustomCalculator.GetHorizontalIndent: Integer;
var
  R, CR: TRect;
  W, Space: Integer;
begin
  Result := GetButtonIndent;

  CR := ClientRect;

  R := CR;
  InflateRect(R, -Result, 0);
  OffsetRect(R, -R.Left, -R.Top);

  Dec(R.Right,  4*GetButtonSpace);

  if sccoShowMemoryButtons in FOptions then
  begin
    Dec(R.Right, GetMemorySpace);
    W := (R.Right - R.Left) div 6;
  end else
    W := (R.Right - R.Left) div 5;

  if W < SCCalcMinButtonWidth then W := SCCalcMinButtonWidth;

  Space := 5*W + 4*GetButtonSpace;
  if sccoShowMemoryButtons in FOptions then
    Inc(Space, W + GetMemorySpace);

  Space := ((CR.Right - CR.Left) - Space) div 2;
  if Space > Result then Result := Space;
end;

function TSCCustomCalculator.GetButtonsWidth: Integer;
var
  R: TRect;
  W: Integer;
begin
  R := ClientRect;
  InflateRect(R, -GetButtonIndent, 0);

  OffsetRect(R, -R.Left, -R.Top);
  Dec(R.Right,  4*GetButtonSpace); // Horizontal space between buttons

  if sccoShowMemoryButtons in FOptions then
  begin
    Dec(R.Right, GetMemorySpace);
    W := (R.Right - R.Left) div 6;
  end else
    W := (R.Right - R.Left) div 5;

  if W < SCCalcMinButtonWidth then W := SCCalcMinButtonWidth;

  Result := 5*W + 4*GetButtonSpace;
  if sccoShowMemoryButtons in FOptions then
    Inc(Result, W + GetMemorySpace);
end;

function TSCCustomCalculator.GetDisplayRect: TRect;
var
  H: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if not (sccoShowDisplay in FOptions) then
    Exit;

  H := GetDisplayHeight;
  Dec(H, 8);

  if H > 0 then
  begin
    Result := ClientRect;

    Inc(Result.Left, GetHorizontalIndent);
    Result.Right := Result.Left + GetButtonsWidth;

    OffsetRect(Result, 0, GetButtonIndent);

    Result.Bottom := Result.Top + H;

    if IsRectEmpty(Result) then
      Result := Rect(0, 0, 0, 0);
  end;
end;

procedure TSCCustomCalculator.CMCursorChanged(var Message: TMessage);
var
  P: TPoint;
begin
  if HandleAllocated and (GetCapture = Self.Handle) then
  begin
    GetCursorPos(P);
    if FindDragTarget(P, False) = Self then
      Perform(WM_SETCURSOR, Handle, HTCLIENT);
  end else
    inherited;

  if not FUpdatingCursor then
  begin
    FDefaultCursor := Cursor;
    if not IsLoading then
      UpdateCursor(-1, -1);
  end;
end;

procedure TSCCustomCalculator.UpdateCursor(X, Y: Integer; UseXY: Boolean);
var
  R: TRect;
  P: TPoint;
  Cr: TCursor;
begin
  if HandleAllocated and not IsDesigning then
  begin
    if not UseXY then
    begin
      GetCursorPos(P);
      P := Self.ScreenToClient(P);
    end else
      P := Point(X, Y);

    R := GetDisplayRect;
    InflateRect(R, -2, -2);

    FUpdatingCursor := True;
    try
      Cr := FDefaultCursor;
      if not IsRectEmpty(R) and PtInRect(R, P) and
        (FDownPart in [sccpNone, sccpDisplay]) then
        Cr := crIBeam;

      Cursor := Cr;
    finally
      FUpdatingCursor := True;
    end;
  end;  
end;

procedure TSCCustomCalculator.IndentChanged;
begin
  if AutoSize then AdjustBounds;
  inherited IndentChanged;
end;

procedure TSCCustomCalculator.CNKeyDown(var Message: TWMKeyDown);
begin
  if (Message.CharCode = VK_ESCAPE) and
    not (FPressedButton in [sccpNone, sccpDisplay]) then
    CancelKeyDown;

  inherited;
end;

procedure TSCCustomCalculator.CancelKeyDown;
var
  OldButton: TSCCalculatorPart;
begin
  OldButton := FPressedButton;
  FPressedButton := sccpNone;

  DoButtonUp(OldButton);
  FPressedButton := sccpNone;
  DoButtonDown(FPressedButton);
end;

procedure TSCCustomCalculator.Assign(Source: TPersistent);
begin
  if Source is TSCCustomCalculator then
    with TSCCustomCalculator(Source) do
    begin
      Self.Style := Style;
      Self.Colors := Colors;
      Self.DisplayBevel := DisplayBevel;
      Self.EditValue := EditValue;
      Self.Options := Options;
      Self.Precision := Precision;
      Self.Value := Value;
    end;

  inherited Assign(Source);
end;

function TSCCustomCalculator.GetActionKeyUp(Key: Word; Shift: TShiftState): TSCCalculatorPart;
var
  Ch: Char;
  I: Integer;
  Keys: String;
  Vk, L, H, ShiftState: Word;
begin
  Result := sccpNone;
  case Key of
    VK_RETURN, VK_SPACE:
      Result := sccpResult;
    VK_ESCAPE:
      Result := sccpClear;
    VK_F9:
      Result := sccpSign;
    VK_DELETE:
      Result := sccpCancel;
    VK_NUMPAD0:
      Result := sccpNumber0;
    VK_NUMPAD1:
      Result := sccpNumber1;
    VK_NUMPAD2:
      Result := sccpNumber2;
    VK_NUMPAD3:
      Result := sccpNumber3;
    VK_NUMPAD4:
      Result := sccpNumber4;
    VK_NUMPAD5:
      Result := sccpNumber5;
    VK_NUMPAD6:
      Result := sccpNumber6;
    VK_NUMPAD7:
      Result := sccpNumber7;
    VK_NUMPAD8:
      Result := sccpNumber8;
    VK_NUMPAD9:
      Result := sccpNumber9;
    VK_ADD:
      Result := sccpPlus;
    VK_SUBTRACT:
      Result := sccpMinus;
    VK_MULTIPLY:
      Result := sccpMultiply;
    VK_DIVIDE:
      Result := sccpDivide;
    VK_DECIMAL:
      Result := sccpDecimal;
  end;

  if Result = sccpNone then
  begin
    Keys := '0123456789+-*/%=@,' + #8#13 + {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DecimalSeparator;

    ShiftState := 0;
    if ssShift in Shift then
      ShiftState := ShiftState or 1;

    if ssCtrl in Shift then
      ShiftState := ShiftState or 2;

    if ssAlt in Shift then
      ShiftState := ShiftState or 4;

    for I := 1 to Length(Keys) do
    begin
      Ch := Keys[I];
      Vk := VkKeyScan(Ch);

      L := Lo(Vk);
      H := Hi(Vk);

      if (L = Key) and (H = ShiftState) then
      begin
        case Ch of
          '0': Result := sccpNumber0;
          '1': Result := sccpNumber1;
          '2': Result := sccpNumber2;
          '3': Result := sccpNumber3;
          '4': Result := sccpNumber4;
          '5': Result := sccpNumber5;
          '6': Result := sccpNumber6;
          '7': Result := sccpNumber7;
          '8': Result := sccpNumber8;
          '9': Result := sccpNumber9;
          '+': Result := sccpPlus;
          '-': Result := sccpMinus;
          '*': Result := sccpMultiply;
          '/': Result := sccpDivide;
          '%': Result := sccpPercent;
          '=', #13: Result := sccpResult;
          #8 : Result := sccpBack;
          '@': Result := sccpSqrt;
          else
            if Ch in [{$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DecimalSeparator, ','] then
              Result := sccpDecimal;
        end;

        Exit;
      end;
    end;
  end;
end;

function TSCCustomCalculator.GetBevelSize: Integer;
begin
  Result := 0;
  if FDisplayBevel in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
    Result := 1
  else if FDisplayBevel in [sccbFlatBold, sccbFlatRounded, sccbFlatBoldRounded,
    sccb3DRaised, sccb3DLowered, sccbBumped, sccbEtched, sccbMacLowered,
    sccbMacRaised, sccbMetal, sccbSoftLowered, sccbSoftRaised] then
    Result := 2;
end;

{ TSCDropdownCalculator }

procedure TSCDropdownCalculator.ActivateForm;
var
  F: TCustomForm;
begin
  if FPopupbox <> nil then
  begin
    F := GetParentForm(FPopupbox);
    if (F <> nil) and F.HandleAllocated then
      // SendMessage(F.Handle, WM_NCACTIVATE, Longint(Message.Active <> WA_INACTIVE), 0);
      SendMessage(F.Handle, WM_NCACTIVATE, Longint(True), 0);
  end;
end;

procedure TSCDropdownCalculator.Cancel;
begin
  PostMessage(Handle, CM_CANCEL, 0, 0);
end;

procedure TSCDropdownCalculator.CloseUp;
begin
  if Assigned(FOnCloseUp) then
    FOnCloseUp(Self);
end;

procedure TSCDropdownCalculator.CMFocusChanged(
  var Message: TCMFocusChanged);
begin
  ActivateForm;
  inherited;
end;

constructor TSCDropdownCalculator.Create(AOwner: TComponent);
begin
  inherited;
{$IFDEF WIN32}
  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable];
{$ENDIF}
  BlendColor := False;
  Visible := False;
  FCancelPopup := False;
  if AOwner is TWinControl then
    Parent := TWinControl(AOwner)
  else
    Parent := GetParentForm(TControl(AOwner));
end;

procedure TSCDropdownCalculator.CreateParams(var Params: TCreateParams);
begin
  inherited;

  with Params do
  begin
    Style := WS_POPUP or WS_CLIPCHILDREN;
  {$IFDEF WIN32}
    ExStyle := WS_EX_TOOLWINDOW;
  {$ENDIF}
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
  end;
end;

procedure TSCDropdownCalculator.CreateWnd;
begin
  inherited CreateWnd;
  if IsDesigning then SetParent(nil);
end;

function TSCDropdownCalculator.IsChildHandle(AHandle: HWND): Boolean;
begin
  Result := False;
  while AHandle <> 0 do
  begin
    Result := AHandle = Handle;
    if Result then Exit;

    AHandle := GetParent(AHandle);
  end;
end;

procedure TSCDropdownCalculator.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and not PtInRect(Self.ClientRect, Point(X, Y)) then
    CloseUp
  else
    inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCDropdownCalculator.Notification(AComponent: TComponent;
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

procedure TSCDropdownCalculator.Popup(C: TSCCustomPopupCalculator);
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

                if not (FPressedButton in [sccpNone, sccpDisplay]) then
                begin
                  CancelKeyDown;
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
          DoDropDown;
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

procedure TSCDropdownCalculator.WMActivate(var Message: TWMActivate);
begin
  inherited;
  ActivateForm;
end;

procedure TSCDropdownCalculator.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

procedure TSCDropdownCalculator.WndProc(var Message: TMessage);
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

{ TSCPopupCalculatorProps }

procedure TSCPopupCalculatorProps.Assign(Source: TPersistent);
begin
  if Source is TSCPopupCalculatorProps then
  begin
    with TSCPopupCalculatorProps(Source) do
    begin
      Self.FBorderStyle := BorderStyle;
      Self.FColor := Color;
      Self.FFont.Assign(Font);
      Self.FStyle := Style;
      Self.FColors.Assign(Colors);
      Self.FDisplayBevel := DisplayBevel;
      Self.FOptions := Options;
      Self.FPrecision := Precision;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCPopupCalculatorProps.Create(AOwner: TSCCustomPopupCalculator);
begin
  inherited Create;
  FOwner := AOwner;

  FColors := TSCCalculatorColors.Create;
  FFont := TFont.Create;

  FBorderStyle := scesDefault;
  FColor := clBtnFace;
  FDisplayBevel := sccbFlat;
  FOptions := SCPopupCalcDefaultOptions;
  FPrecision := SCDefPrecision;
  FStyle := sccalDefault;
end;

destructor TSCPopupCalculatorProps.Destroy;
begin
  FreeAndNil(FColors);
  FreeAndNil(FFont);
  inherited Destroy;
end;

function TSCPopupCalculatorProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCPopupCalculatorProps.SetBorderStyle(Value: TSCEditStyle);
begin
  FBorderStyle := Value;
end;

procedure TSCPopupCalculatorProps.SetColor(Value: TColor);
begin
  FColor := Value;
end;

procedure TSCPopupCalculatorProps.SetColors(Value: TSCCalculatorColors);
begin
  FColors.Assign(Value);
end;

procedure TSCPopupCalculatorProps.SetDisplayBevel(Value: TSCControlBevel);
begin
  FDisplayBevel := Value;
end;

procedure TSCPopupCalculatorProps.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TSCPopupCalculatorProps.SetOptions(Value: TSCCalculatorOptions);
begin
  FOptions := Value;
end;

procedure TSCPopupCalculatorProps.SetStyle(Value: TSCCalculatorStyle);
begin
  FStyle := Value;
end;

{ TSCCustomPopupCalculator }

function TSCCustomPopupCalculator.AddNegativeSymbol(
  const S: String): String;
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

procedure TSCCustomPopupCalculator.AfterCloseUp;
begin
  FClosingCalc := True;
  try
    if not FReturnClose then
      SetText(FDropText);

    FReturnClose := False;
  finally
    FClosingCalc := False;
  end;
end;

procedure TSCCustomPopupCalculator.AfterConstruction;
begin
  inherited AfterConstruction;
  CheckEmpty;
end;

function TSCCustomPopupCalculator.ArrangeSeparators(const S: String;
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

function TSCCustomPopupCalculator.ArrangeText(const S: String): String;
var
  IsNegative: Boolean;
begin
  Result := '';
  if (S = '') and FAllowEmpty then
    Exit;

  if FClosingCalc then
  begin
    Result := S;
    Exit;
  end;

  IsNegative := False;
  try
    Result := Trim(inherited ArrangeText(Trim(S)));
    if Result = '' then Result := '0';

    Result := RemoveNegativeSymbol(Result, IsNegative);
    Result := ArrangeSeparators(Result, False);

    if not scIsFloat(Result, False) then
      Result := '0';

    Result := ArrangeSeparators(Result);

    if IsNegative then
      Result := AddNegativeSymbol(Result);
  except
    Result := '0';
  end;
end;

procedure TSCCustomPopupCalculator.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomPopupCalculator then
    with TSCCustomPopupCalculator(Source) do
    begin
      Self.AllowEmpty := AllowEmpty;
      Self.CalculatorProps := CalculatorProps;
      Self.DecimalPlaces := DecimalPlaces;
      Self.UseThousandsSeparator := UseThousandsSeparator;
      Self.Value := Value;
    end;
end;

procedure TSCCustomPopupCalculator.BeforeExit;
begin
  inherited BeforeExit;
  UpdateValueFromText;
end;

function TSCCustomPopupCalculator.CanDropDown: Boolean;
begin
  Result := not IsDesigning and
    ((FCalculator = nil) or not TSCDropdownCalculator(FCalculator).InPopup);
end;

function TSCCustomPopupCalculator.CanSetValue(var Value: Extended): Boolean;
begin
  Result := IsDesigning or (Enabled and not ReadOnly);
end;

procedure TSCCustomPopupCalculator.CheckEmpty;
begin
  if not FAllowEmpty then
  begin
    if Text = '' then
      SetText('0')
    else
      SetText(scFloatToStr(FloatValue, False));
  end;
end;

procedure TSCCustomPopupCalculator.CloseUp;
begin
  if (FCalculator <> nil) and TSCDropdownCalculator(FCalculator).InPopup then
    TSCDropdownCalculator(FCalculator).Cancel;
end;

constructor TSCCustomPopupCalculator.Create(AOwner: TComponent);
begin
  FAllowEmpty := False;
  FDecimalPlaces := -1;
  FUseThousandsSeparator := True;

  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  IsDropDown := False;

  SendChildrenStyle := False;
  FCalculatorProps := TSCPopupCalculatorProps.Create(Self);
end;

destructor TSCCustomPopupCalculator.Destroy;
begin
  FCalculatorProps.Free;
  if FCalculator <> nil then
    FreeAndNil(FCalculator);

  inherited Destroy;
end;

procedure TSCCustomPopupCalculator.DoInternalChange;
begin
  // UpdateValueFromText;
  inherited;
end;

function TSCCustomPopupCalculator.DoWantKeyDown(var Key: Word;
  Shift: TShiftState): Boolean;
begin
  if (Key = VK_ESCAPE) and (FCalculator <> nil) and
    FCalculator.HandleAllocated and IsWindowVisible(FCalculator.Handle) then
  begin
    Result := FCalculator.Focused or not (TSCDropdownCalculator(FCalculator).FPressedButton in
      [sccpNone, sccpDisplay]);
    if Result then
      Exit;
  end;

  Result := inherited DoWantKeyDown(Key, Shift);
end;

procedure TSCCustomPopupCalculator.DropDownPopupbox;
begin
  FReturnClose := False;
  if CanDropDown and AllowDropDown then
  begin
    if FCalculator = nil then
      FCalculator := TSCDropdownCalculator.Create(Self);

    PrepareDropWindow;

    Windows.SetFocus(Handle);
    if GetFocus <> Handle then
      Exit;

    SetDropState(sccsDropping);
    SetDroppedDownFlag(True);
    try
      FCalculator.FreeNotification(Self);
      TSCDropdownCalculator(FCalculator).Popup(Self);
    finally
      SetDropState(sccsDefault);
      SetDroppedDownFlag(False);

      if FCalculator <> nil then
      begin
        FCalculator.OnResult := nil;
        FCalculator.OnEditChange := nil;

        FreeAndNil(FCalculator);
      end;
    end;
  end;
end;

procedure TSCCustomPopupCalculator.EditChanged(SendeR: TObject);
begin
  if GetDroppedDown then
    SetText(FCalculator.EditValue);
end;

function TSCCustomPopupCalculator.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCDropDownButtonProps;
end;

function TSCCustomPopupCalculator.GetDropDownWindow: TWinControl;
begin
  Result := FCalculator;
end;

function TSCCustomPopupCalculator.GetDroppedDown: Boolean;
begin
  Result := GetDroppedDownFlag and
   (FCalculator <> nil) and TSCDropdownCalculator(FCalculator).InPopup;
end;

function TSCCustomPopupCalculator.GetFloatValue: Extended;
var
  S: String;
  E: Extended;
  IsNegative: Boolean;
begin
  if GetDroppedDown then
    Result := FFloatValue
  else begin
    S := Trim(Text);
    if S = '' then
    begin
      Result := 0;
      Exit;
    end;

    try
      S := RemoveNegativeSymbol(S, IsNegative);

      S := ArrangeSeparators(S, False);
      if IsNegative then S := scNegativeSign + S;

      if scIsFloat(S, E) then
        Result := E
      else  
        Result := 0;
    except
      Result := 0;
    end;
  end;
end;

function TSCCustomPopupCalculator.GetPopupStyle: TSCEditStyle;
begin
  Result := FCalculatorProps.BorderStyle;
end;

function TSCCustomPopupCalculator.IsEmpty: Boolean;
begin
  Result := FAllowEmpty and (Text = '');
end;

function TSCCustomPopupCalculator.IsValidKey(Key: Char): Boolean;
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

procedure TSCCustomPopupCalculator.KeyDown(var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    UpdateValueFromText;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomPopupCalculator.Loaded;
begin
  inherited Loaded;
  CheckEmpty;
end;

procedure TSCCustomPopupCalculator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = FCalculator) then
    FCalculator := nil;
end;

procedure TSCCustomPopupCalculator.PrepareDropWindow;
begin
  if FCalculator = nil then
    Exit;

  BeforePrepareDropWindow;

  FDropText := Text;
    
  with TSCDropdownCalculator(FCalculator) do
  begin
    AutoSize := True;
    Indent := 4;
    ParentColor := False;
    Color := Self.FCalculatorProps.Color;
    Colors := Self.FCalculatorProps.Colors;
    DisplayBevel  := Self.FCalculatorProps.DisplayBevel;
    Font := Self.FCalculatorProps.Font;
    Value := Self.FloatValue;
    Options := Self.FCalculatorProps.Options;
    Style := Self.FCalculatorProps.Style;
  end;

  ApplyPopupBorder(TSCCustomControl(FCalculator));
  CalcPosition(FCalculator);

  with TSCDropdownCalculator(FCalculator) do
  begin
    OnResult := Self.ResultClicked;
    OnEditChange := Self.EditChanged;
  end;
end;

function TSCCustomPopupCalculator.RemoveNegativeSymbol(const S: String;
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

procedure TSCCustomPopupCalculator.ResultClicked(SendeR: TObject);
begin
  FReturnClose := True;

  if GetDroppedDown then
  begin
    SetFloatValue(FCalculator.Value);
    CloseUp;
    SelectAll;

    if Assigned(FOnPopupResult) then
      FOnPopupResult(Self);
  end;  
end;

procedure TSCCustomPopupCalculator.SetAllowEmpty(Value: Boolean);
begin
  if FAllowEmpty <> Value then
  begin
    FAllowEmpty := Value;
    if not Value and (Text = '') then
    begin
      SetText('0');
      FFloatValue := 0;
    end;
  end;
end;

procedure TSCCustomPopupCalculator.SetCalculatorProps(
  Value: TSCPopupCalculatorProps);
begin
  FCalculatorProps.Assign(Value);
end;

procedure TSCCustomPopupCalculator.SetDecimalPlaces(Value: Integer);
begin
  if Value < -1 then Value := -1;
  if Value > 20 then Value := 20;

  if FDecimalPlaces <> Value then
  begin
    FDecimalPlaces := Value;

    if not IsLoading and (Text <> '') then
    begin
      SetText(ArrangeText(Self.Text));
      FFloatValue := GetFloatValue;
    end;
  end;
end;

procedure TSCCustomPopupCalculator.SetEmpty;
begin
  if FAllowEmpty then
    SetText('');
end;

procedure TSCCustomPopupCalculator.SetFloatValue(Value: Extended);
begin
  if CanSetValue(Value) then
  begin
    FFloatValue := Value;
    SetText(scFloatToStr(Value, False));
  end;
end;

procedure TSCCustomPopupCalculator.SetUseThousandsSeparator(
  Value: Boolean);
begin
  if FUseThousandsSeparator <> Value then
  begin
    FUseThousandsSeparator := Value;
    if Text <> '' then
      SetText(scCurrencyToStr(FloatValue, FUseThousandsSeparator, FDecimalPlaces));
  end;
end;

procedure TSCCustomPopupCalculator.UpdateValueFromText;
var
  Val: Extended;
begin
  if not IsEmpty then
  begin
    Val := FloatValue;
    if scFloatToStr(Val, False) <> Text then
      SetFloatValue(Val);
  end;
end;

procedure TSCCustomPopupCalculator.WndProc(var Message: TMessage);
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

{$I SCVerRec.inc}

end.

