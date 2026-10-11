{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCAdvEdits;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Clipbrd, SCCommon, SCConsts, SCControl, SCEdits, SCMaskEdit,
  SCSimpleListbox, SCVirtualListBox, ImgList, MultiMon;

type
  TSCEditStyle = (scesDefault, scesDefaultEx, scesNone, scesOfficeXP,
    scesOffice12, scesOffice2003, scesFlat, scesFlatEx, scesFlatNew,
    scesSingle, scesSingleEx, scesDouble, scesDoubleNew, scesRaised,
    scesMetal, sces3D, scesNew, scesExtreme, scesWinXP);

  TSCFrameEditBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccbNone;
    property Color default clWindow;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCCustomFrameEditColors = class(TSCEditCustomColors)
  private
    function  GetFrameColor: TColor;
    procedure SetFrameColor(Value: TColor);
    function  GetExUseColor: TColor;
    procedure SetExUseColor(Value: TColor);

    procedure ReadXPColor(Reader: TReader);
    procedure WriteXPColor(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property FrameColor: TColor read GetFrameColor write SetFrameColor default clNone;
    property ExUseColor: TColor read GetExUseColor write SetExUseColor default $00FFC7B7;
  end;

  TSCFrameEditColors = class(TSCCustomFrameEditColors)
  published
    property DescriptionColor;
    property DisabledColor;
    property DisabledTextColor;
    property DragPointerColor;
    property FocusColor;
    property FocusTextColor;
    property HideSelectionColor;
    property HideSelectionTextColor;
    property HighlightColor;
    property HighlightTextColor;
  end;

  TSCCustomFrameEdit = class;

  TSCCustomFrameEdit = class(TSCCustomMaskEdit)
  private
    FFrameColor: TColor;
    FStyle: TSCEditStyle;
    FExUseColor: TColor;
    procedure SetFrameColor(Value: TColor);
    procedure SetStyle(Value: TSCEditStyle);
    procedure SetExUseColor(Value: TColor);

    procedure ReadXPColor(Reader: TReader);
    procedure WriteXPColor(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;

    procedure PaintWindow(DC: HDC); override;
    procedure MouseInControlChanged; override;

    function  GetBorderProps: TSCFrameEditBorderProps;
    procedure SetBorderProps(Value: TSCFrameEditBorderProps);

    function  GetColors: TSCFrameEditColors;
    procedure SetColors(Value: TSCFrameEditColors);

    function  GetStyleBorderSize: Integer;
    function  GetExtraBorderSize: Integer; override;

    function  CanSetBorder(Value: TSCControlBorder): Boolean; override;
    function  CanSetInnerBorder(Value: TSCControlBorder): Boolean; override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetEditColorsClass: TSCEditCustomColorsClass; override;

    function  GetIsExtraFlat: Boolean; virtual;
    procedure DrawEditBorder(C: TCanvas); virtual;
    procedure UpdateBorderRect(var R: TRect); virtual;
    procedure StyleChanged; virtual;

    function  GetEditRect: TRect; override;
    function  GetFrameRect: TRect; virtual;

    property HideSelection default True;
    property Border default sccbNone;
    property BorderInner default sccbNone;
    property IsExtraFlat: Boolean read GetIsExtraFlat;
    property FrameColor: TColor read FFrameColor write SetFrameColor default clNone;
    property Style: TSCEditStyle read FStyle write SetStyle default scesDefault;
    property ExUseColor: TColor read FExUseColor write SetExUseColor default $00FFC7B7;
    property Colors: TSCFrameEditColors read GetColors write SetColors;
    property BorderProps: TSCFrameEditBorderProps read GetBorderProps write SetBorderProps;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    property CaretPos;
    property BlankChar;
    property SaveLiterals;
    property SelLength;
    property SelStart;
    property SelText;
  end;

  TSCFrameEdit = class(TSCCustomFrameEdit)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
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
    property EditMask;
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
    property RaiseMaskError;
    property ReadOnly;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Text;
    property Transparent;
    property UseCaret;
    property UseDelimeters;
    property UseImage;
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

  TSCCustomHyperlinkEdit = class(TSCCustomFrameEdit)
  private
    FLinkColor: TColor;
    FActivateKey: TShortCut;
    FActivateCursor: TCursor;
    FSingleClick: Boolean;
    FOnActivate: TNotifyEvent;
    procedure SetLinkColor(Value: TColor);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure UpdateLineFont(F: TFont; Index: Integer); override;
    function  GetEditCursor: TCursor; override;
    procedure DoActivate; dynamic;

    property ActivateCursor: TCursor read FActivateCursor write FActivateCursor default crHandPoint;
    property ActivateKey: TShortCut read FActivateKey write FActivateKey default VK_SPACE + scCtrl;
    property AutoSelect default False;
    property LinkColor: TColor read FLinkColor write SetLinkColor default clBlue;
    property SingleClick: Boolean read FSingleClick write FSingleClick default False;
    property OnActivate: TNotifyEvent read FOnActivate write FOnActivate;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TSCHyperlinkEdit = class(TSCCustomHyperlinkEdit)
  published
    property ActivateCursor;
    property ActivateKey;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
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
    property EditMask;
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
    property Layout;
    property LinkColor;
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
    property RaiseMaskError;
    property ReadOnly;
    property ShowHint;
    property SingleClick;
    property Style;
    property TabOrder;
    property TabStop;
    property Text;
    property Transparent;
    property UseCaret;
    property UseDelimeters;
    property UseImage;
    property UseUndo;
    property UndoLimit;
    property Visible;
    property OnActivate;
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


  TSCCustomButtonFrame = class;
  TSCCustomButtonEdit = class;

  TSCEditButtonStyle = (scebDropDown, scebBrowse, scebImage, scebCustom);

  TSCEditButton = class(TPersistent)
  private
    FOwner: TSCCustomButtonFrame;
    FAlign: TLeftRight;
    FArrowColor: TColor;
    FColor: TColor;
    FImage: TImageIndex;
    FName: String;
    FStyle: TSCEditButtonStyle;
    FVisible: Boolean;
    FWidth: Integer;
    FOnChange: TNotifyEvent;
    FChanged: Boolean;
    FUpdateCount: Integer;
    FButtonDown: Boolean;
    FButtonHot: Boolean;
    FDropUp: Boolean;
    procedure SetAlign(Value: TLeftRight);
    procedure SetArrowColor(Value: TColor);
    procedure SetColor(Value: TColor);
    procedure SetImage(Value: TImageIndex);
    procedure SetName(const Value: String);
    procedure SetStyle(Value: TSCEditButtonStyle);
    procedure SetVisible(Value: Boolean);
    procedure SetWidth(Value: Integer);
    procedure SetDropUp(Value: Boolean);
  protected
    function  GetOwner: TPersistent; override;
    procedure Changed(Full: Boolean);
    procedure DoChange; dynamic;
    function  GetImages: TCustomImageList;

    procedure BeginUpdate;
    procedure EndUpdate;
    function  InUpdate: Boolean;

    property ButtonDown: Boolean read FButtonDown write FButtonDown;
    property ButtonHot: Boolean read FButtonHot write FButtonHot;
    property DropUp: Boolean read FDropUp write SetDropUp default False;

    property Align: TLeftRight read FAlign write SetAlign default taRightJustify;
    property ArrowColor: TColor read FArrowColor write SetArrowColor default clBtnText;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Image: TImageIndex read FImage write SetImage default -1;
    property Name: String read FName write SetName;
    property Style: TSCEditButtonStyle read FStyle write SetStyle default scebImage;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Width: Integer read FWidth write SetWidth default -1;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TSCCustomButtonFrame); virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    function  GetWidth: Integer;
    
    property Owner: TSCCustomButtonFrame read FOwner;
  end;

  TSCCustomEditButtonProps = class(TPersistent)
  private
    FOwner: TSCCustomButtonFrame;
    function  GetInsideFrame: Boolean;
    procedure SetInsideFrame(Value: Boolean);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TSCCustomButtonFrame); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomButtonFrame read FOwner;
  published
    property InsideFrame: Boolean read GetInsideFrame write SetInsideFrame default True;
  end;

  TSCCustomEditButtonPropsClass = class of TSCCustomEditButtonProps;

  TSCEditButtonClass = class of TSCEditButton;

  TSCEditPaintButton = procedure(Sender: TObject; Btn: TSCEditButton; C: TCanvas;
    R: TRect; IsDown, IsHot: Boolean) of object;

  TSCCustomButtonFrame = class(TSCCustomFrameEdit)
  private
    FButtonList: TList;
    FButtonProps: TSCCustomEditButtonProps;
    FButtonInsideFrame: Boolean;
    FOnPaintButton: TSCEditPaintButton;
    procedure SetButtonProps(Value: TSCCustomEditButtonProps);
    procedure SetButtonInsideFrame(Value: Boolean);
    function  GetButton(Index: Integer): TSCEditButton;
    procedure PaintButtonGlyph(C: TCanvas; R: TRect; Btn: TSCEditButton;
      IsDown, IsHot: Boolean);
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure MouseInControlChanged; override;

    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; dynamic;

    procedure CaptureChanged(Captured: Boolean); override;
    procedure StopTracking; override;

    procedure DrawEditBorder(C: TCanvas); override;
    function  GetFrameRect: TRect; override;
    function  GetInnerEditRect: TRect;

    procedure StyleChanged; override;
    procedure ButtonChanged(Sender: TObject); dynamic;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure DoButtonClick(Btn: TSCEditButton); dynamic;
    procedure DoButtonHotChanged(Btn: TSCEditButton); dynamic;
    procedure DoButtonUp(Btn: TSCEditButton); dynamic;

    function  GetGradientShadow(AColor: TColor): TColor;
    function  GetGradientDark(AColor: TColor): TColor;
    function  GetGradientLight(AColor: TColor): TColor;
    function  GetGradientExDark(AColor: TColor): TColor;
    function  GetGradientExLight(AColor: TColor): TColor;
    function  GetGradientPeal(AColor: TColor): TColor;
    function  GetGradientPreDark(AColor: TColor): TColor;
    function  GetGradientPreLight(AColor: TColor): TColor;

    function  GetDeafultExFocus: Boolean; virtual;
    function  GetButtonClass: TSCEditButtonClass; dynamic;
    procedure PaintButton(C: TCanvas; R: TRect; Btn: TSCEditButton); virtual;
    procedure DoCustomPaintButton(C: TCanvas; R: TRect; Btn: TSCEditButton;
      IsDown, IsHot: Boolean); virtual;

    function  GetSliderHeight(R: TRect; IsUp: Boolean): Integer; dynamic;
    function  GetSliderPos(R: TRect; IsUp: Boolean): TPoint; dynamic;

    function  GetButtonRect(Btn: TSCEditButton): TRect; dynamic;
    function  GetButtonAtPos(P: TPoint): TSCEditButton; dynamic;
    function  GetDownButton: TSCEditButton; dynamic;
    function  GetHotButton: TSCEditButton; dynamic;

    procedure ReleaseButtons;
    procedure RegisterButton(Btn: TSCEditButton);
    procedure UnregisterButton(Btn: TSCEditButton);

    property Buttons[Index: Integer]: TSCEditButton read GetButton;
    property ButtonProps: TSCCustomEditButtonProps read FButtonProps write SetButtonProps;
    property ButtonInsideFrame: Boolean read FButtonInsideFrame write SetButtonInsideFrame default True;
    property OnPaintButton: TSCEditPaintButton read FOnPaintButton write FOnPaintButton;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCBrowseButton = class(TSCEditButton)
  protected
    property Style default scebBrowse;
  public
    constructor Create(AOwner: TSCCustomButtonFrame); override;
    property Visible default False;
  end;

  TSCBaseDropDownButton = class(TSCEditButton)
  protected
    property Style default scebDropDown;
  public
    constructor Create(AOwner: TSCCustomButtonFrame); override;
    property Visible default False;
  end;

  TSCEditButtonProps = class(TSCCustomEditButtonProps)
  private
    function  GetClickKey: TShortCut;
    procedure SetClickKey(Value: TShortCut);
  protected
    property ClickKey: TShortCut read GetClickKey write SetClickKey default scNone;
  public
    procedure Assign(Source: TPersistent); override;
  end;

  TSCCustomButtonEdit = class(TSCCustomButtonFrame)
  private
    FButton: TSCEditButton;
    FBrowseButton: TSCBrowseButton;
    FButtonClickKey: TShortCut;
    FOnButtonClick: TNotifyEvent;
    FOnBrowseClick: TNotifyEvent;
  protected
    procedure SetButton(Value: TSCEditButton); virtual;
    procedure SetBrowseButton(Value: TSCBrowseButton); virtual;
    function  AdjustImageTop(ImgTop: Integer): Integer; override;

    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; override;

    function  GetButtonRect(Btn: TSCEditButton): TRect; override;
    procedure DoButtonClick(Btn: TSCEditButton); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    property BrowseButton: TSCBrowseButton read FBrowseButton write SetBrowseButton;
    property Button: TSCEditButton read FButton write SetButton;
    property ButtonClickKey: TShortCut read FButtonClickKey write FButtonClickKey default scNone;
    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
    property OnBrowseClick: TNotifyEvent read FOnBrowseClick write FOnBrowseClick;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCStyledEditButton = class(TSCEditButton)
  public
    constructor Create(AOwner: TSCCustomButtonFrame); override;
  published
    property Align;
    property ArrowColor;
    property Color;
    property Image;
    property Style default scebBrowse;
    property Visible;
    property Width;
  end;

  TSCButtonEdit = class(TSCCustomButtonEdit)
  protected
    function  GetButtonClass: TSCEditButtonClass; override;
    procedure UpdateBorderRect(var R: TRect); override;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property Button;
    property ButtonClickKey;
    property ButtonInsideFrame;
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
    property EditMask;
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
    property RaiseMaskError;
    property ReadOnly;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Text;
    property Transparent;
    property UseImage;
    property UseUndo;
    property UndoLimit;
    property Visible;
    property OnButtonClick;
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

  TSCDropDownButton = class(TSCEditButton)
  protected
    property Style default scebDropDown;
  public
    constructor Create(AOwner: TSCCustomButtonFrame); override;
  end;

  TSCCustomDropButtonProps = class(TSCEditButtonProps)
  private
    function  GetArrowColor: TColor;
    procedure SetArrowColor(Value: TColor);
    function  GetColor: TColor;
    procedure SetColor(Value: TColor);
    function  GetImage: TImageIndex;
    procedure SetImage(Value: TImageIndex);
    function  GetStyle: TSCEditButtonStyle;
    procedure SetStyle(Value: TSCEditButtonStyle);
    function  GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    function  GetWidth: Integer;
    procedure SetWidth(Value: Integer);
  protected
    property ArrowColor: TColor read GetArrowColor write SetArrowColor default clBtnText;
    property Color: TColor read GetColor write SetColor default clBtnFace;
    property Image: TImageIndex read GetImage write SetImage default -1;
    property Style: TSCEditButtonStyle read GetStyle write SetStyle default scebDropDown;
    property Visible: Boolean read GetVisible write SetVisible default True;
    property Width: Integer read GetWidth write SetWidth default -1;
  public
    procedure Assign(Source: TPersistent); override;
  end;

  TSCDropDownButtonProps = class(TSCCustomDropButtonProps)
  published
    property ArrowColor;
    property Color;
    property Image;
    property Style;
    property Visible;
    property Width;
  end;

  TSCComboboxDropState = (sccsDefault, sccsDropping, sccsDropped, sccsClosing);

  TSCCustomDropDown = class(TSCCustomButtonEdit)
  private
    FDroppedDown: Boolean;
    FOnCloseUp: TNotifyEvent;
    FOnDropDown: TNotifyEvent;
    FSendChildrenStyle: Boolean;
    FIsDropDown: Boolean;
    FDropDownKey: TShortCut;
    FInMouseClose: Boolean;
    FInternalDropdown: Boolean;
    FCloseKey: Word;
    FDropState: TSCComboboxDropState;
    function  GetBrowseButtonVisible: Boolean;
    procedure SetBrowseButtonVisible(Value: Boolean);
    function  GetButtonArrowColor: TColor;
    procedure SetButtonArrowColor(Value: TColor);
    function  GetButtonColor: TColor;
    procedure SetButtonColor(Value: TColor);
    function  GetButtonImage: TImageIndex;
    procedure SetButtonImage(Value: TImageIndex);
    function  GetButtonStyle: TSCEditButtonStyle;
    procedure SetButtonStyle(Value: TSCEditButtonStyle);
    function  GetButtonVisible: Boolean;
    procedure SetButtonVisible(Value: Boolean);
    function  GetButtonWidth: Integer;
    procedure SetButtonWidth(Value: Integer);

    procedure WMKillFocus(var Message: TMessage); message WM_KILLFOCUS;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure CMDropDownPopup(var Message: TMessage); message CM_SCDROPDOWNPOPUP;
    procedure CBShowDropDown(var Message: TMessage); message CB_SHOWDROPDOWN;
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
    procedure CNChar(var Message: TWMChar); message CN_CHAR;
  protected
    function  AllowSelectionDrag: Boolean; override;
    function  GetDroppedDownFlag: Boolean;
    procedure SetDroppedDownFlag(Value: Boolean);

    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; override;
    function  GetForeColor: TColor; override;

    function  GetButtonClass: TSCEditButtonClass; override;
    function  GetEditCursor: TCursor; override;
    procedure PaintLine(C: TCanvas; Index, H, TxTop: Integer); override;

    function  IsDescription: Boolean; override;
    function  IsDropDownDescription: Boolean; virtual;
    function  GetDescriptionColor: TColor; override;

    function  GetDropDownText: String; virtual;
    function  GetDeafultExFocus: Boolean; override;

    function  GetPopupStyle: TSCEditStyle; dynamic;
    procedure ApplyPopupBorder(Control: TSCCustomControl); dynamic;

    procedure DoAutoComplete(UpdatePaint: Boolean = True); override;
    function  AutoCompleteText: String; override;
    function  GetDefaultMenu: TPopupMenu; override;

    function  GetDroppedDown: Boolean; virtual;
    procedure SetDroppedDown(Value: Boolean); virtual;
    procedure SetIsDropDown(Value: Boolean); virtual;
    function  GetMinDropDownWidth: Integer; dynamic;

    function  GetSelLength: Integer; override;
    function  GetSelText: String; override;
    procedure SetSelText(const Value: String); override;

    procedure DeleteChar(Prev: Boolean); override;
    procedure DeleteText(Prev: Boolean); override;
    procedure InsertChar(Ch: Char); override;
    procedure OverwriteChar(Ch: Char); override;
    procedure InsertText(AText: String); override;

    procedure EnsureCaretPos(var X, Y: Integer); override;
    function  GetCaretPos: TPoint; override;
    function  GetCaretPoint(P: TPoint): TPoint; override;

    function  EditCanModify: Boolean; override;
    function  CanBeepForKey(Key: Word; Shift: TShiftState): Boolean; override;

    function  GetIsDropDown: Boolean; virtual;
    procedure DoButtonClick(Btn: TSCEditButton); override;
    function  DoWantKeyDown(var Key: Word; Shift: TShiftState): Boolean; virtual;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure UpdateBorderRect(var R: TRect); override;
    function  GetDropDownHandle: HWND;
    function  GetDropDownWindow: TWinControl; virtual;

    procedure FocusNeeded;
    procedure PrepareDropWindow; virtual;
    procedure BeforePrepareDropWindow; virtual;
    procedure BeforeEnterKeyClose; virtual;
    function  DoDropDownKeys(var Key: Word; Shift: TShiftState): Boolean; virtual;
    function  DropDownWantKeys(Key: Word; Shift: TShiftState): Boolean; virtual;
    procedure CheckScreenPosition(var P: TPoint; PopupWidth, PopupHeight, EditHeight: Integer); virtual;
    procedure CalcPosition(APopupControl: TWinControl); virtual;

    procedure SetDropState(Value: TSCComboboxDropState);

    procedure DoCloseUp; dynamic;
    procedure DoDropDown; dynamic;

    function  AllowDropdown: Boolean; dynamic;
    function  CanDropDown: Boolean; dynamic;
    function  CanCloseUp: Boolean; dynamic;
    procedure DropDown;
    procedure DropDownPopupbox; dynamic;
    procedure CloseUp; overload; dynamic;
    procedure CloseUp(Accept: Boolean); overload; dynamic;
    procedure BeforeDropDown; dynamic;
    procedure AfterDropDown; dynamic;
    procedure AfterCloseUp; dynamic;

    property BrowseButtonVisible: Boolean read GetBrowseButtonVisible write SetBrowseButtonVisible default False;
    property ButtonArrowColor: TColor read GetButtonArrowColor write SetButtonArrowColor default clBtnText;
    property ButtonColor: TColor read GetButtonColor write SetButtonColor default clBtnFace;
    property ButtonImage: TImageIndex read GetButtonImage write SetButtonImage default -1;
    property ButtonStyle: TSCEditButtonStyle read GetButtonStyle write SetButtonStyle default scebDropDown;
    property ButtonVisible: Boolean read GetButtonVisible write SetButtonVisible default True;
    property ButtonWidth: Integer read GetButtonWidth write SetButtonWidth default -1;
    property DropDownWindow: TWinControl read GetDropDownWindow;
    property DropDownKey: TShortCut read FDropDownKey write FDropDownKey default scNone;
    property DroppedDown: Boolean read GetDroppedDown write SetDroppedDown;
    property DroppedDownSet: Boolean read FDroppedDown;
    property DropState: TSCComboboxDropState read FDropState;
    property HideSelection default True;
    property IsDropDown: Boolean read FIsDropDown write SetIsDropDown default False;
    property SendChildrenStyle: Boolean read FSendChildrenStyle write FSendChildrenStyle default True;
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  HasSelection: Boolean; override;
    function  CanCopy: Boolean; override;
    function  CanPaste: Boolean; override;
    function  CanCut: Boolean; override;

    procedure SetSelRect(R: TRect); override;
    procedure SelectAll; override;
    procedure SelectWord(CheckDelimeters: Boolean); override;
    procedure ClearSelection; override;
  end;

  TSCListClickType = (sclcDefault, sclcKey, sclcMouse);

  TSCCustomCombobox = class;
  
  TSCComboboxScrollbar = class(TSCControlScrollbar)
  private
    FWidth: Integer;
    FStyle: TSCScrollbarStyle;
    FButtonsLayout: TSCScrollButtonLayout;
    FThumbLines: TSCScrollThumbline;
    procedure SetWidth(Value: Integer);
  public
    constructor Create(AOwner: TSCCustomControl; AKind: TSCScrollbarKind); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Background;
    property ButtonColors;
    property ExtraButton;
    property Icons;
    property SlideLine;
    property Thumb;
    property Width: Integer read FWidth write SetWidth default -1;
    property Style: TSCScrollbarStyle read FStyle write FStyle default scssDefault;
    property ThumbLines: TSCScrollThumbline read FThumbLines write FThumbLines default sctlNone;
    property ButtonsLayout: TSCScrollButtonLayout read FButtonsLayout write FButtonsLayout default scsbDefault;
  end;

  TSCComboboxButtonProps = class(TSCCustomDropButtonProps)
  published
    property ArrowColor;
    property Color;
    property Visible;
  end;

  TSCComboboxCustomPopupProps = class(TPersistent)
  private
    FOwner: TSCCustomCombobox;
    function  GetBorderStyle: TSCEditStyle;
    procedure SetBorderStyle(Value: TSCEditStyle);
    function  GetColor: TColor;
    procedure SetColor(Value: TColor);
    function  GetFont: TFont;
    procedure SetFont(Value: TFont);
    function  GetMaxHeight: Integer;
    procedure SetMaxHeight(Value: Integer);
    function  GetMaxWidth: Integer;
    procedure SetMaxWidth(Value: Integer);
    function  GetMinHeight: Integer;
    procedure SetMinHeight(Value: Integer);
    function  GetMinWidth: Integer;
    procedure SetMinWidth(Value: Integer);
    function  GetScrollbar: TSCComboboxScrollbar;
    procedure SetScrollbar(Value: TSCComboboxScrollbar);
    function  GetShowSizeGrip: Boolean;
    procedure SetShowSizeGrip(Value: Boolean);
    function  GetShowStatusbar: Boolean;
    procedure SetShowStatusbar(Value: Boolean);
    function  GetStatusbarAlignment: TAlignment;
    procedure SetStatusbarAlignment(Value: TAlignment);
    function  GetStatusbarColor: TColor;
    procedure SetStatusbarColor(Value: TColor);
    function  GetStatusbarText: String;
    procedure SetStatusbarText(Value: String);
  protected
    function  GetOwner: TPersistent; override;

    property BorderStyle: TSCEditStyle read GetBorderStyle write SetBorderStyle default scesDefault;
    property Color: TColor read GetColor write SetColor default clWindow;
    property Font: TFont read GetFont write SetFont;
    property MaxHeight: Integer read GetMaxHeight write SetMaxHeight default 0;
    property MaxWidth: Integer read GetMaxWidth write SetMaxWidth default 0;
    property MinHeight: Integer read GetMinHeight write SetMinHeight default 0;
    property MinWidth: Integer read GetMinWidth write SetMinWidth default 0;
    property Scrollbar: TSCComboboxScrollbar read GetScrollbar write SetScrollbar;
    property ShowSizeGrip: Boolean read GetShowSizeGrip write SetShowSizeGrip default True;
    property ShowStatusbar: Boolean read GetShowStatusbar write SetShowStatusbar default False;
    property StatusbarAlignment: TAlignment read GetStatusbarAlignment write SetStatusbarAlignment default taLeftJustify;
    property StatusbarColor: TColor read GetStatusbarColor write SetStatusbarColor default clBtnFace;
    property StatusbarText: String read GetStatusbarText write SetStatusbarText;
  public
    constructor Create(AOwner: TSCCustomCombobox); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomCombobox read FOwner;
  end;

  TSCComboboxPopupPropsClass = class of TSCComboboxCustomPopupProps;

  TSCComboboxPopupProps = class(TSCComboboxCustomPopupProps)
  published
    property BorderStyle;
    property Color;
    property Font;
    property MaxHeight;
    property MaxWidth;
    property MinHeight;
    property MinWidth;
    property Scrollbar;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
  end;

  TSCCustomCombobox = class(TSCCustomDropDown)
  private
    FAllowGrayed: Boolean;
    FAutoWidth: Boolean;
    FCenterImages: Boolean;
    FCheckStyle: TSCSimpleCheckFlat;
    FContinuousKeySearch: Boolean;
    FEndEllipsis: Boolean;
    FDblClickReverts: Boolean;
    FDropDownColor: TColor;
    FDropDownCount: Integer;
    FDropDownFont: TFont;
    FDropOnAutoComplete: Boolean;
    FImmediateDropDown: Boolean;
    FImmediateSetText: Boolean;
    FItems: TStrings;
    FItemHeight: Integer;
    FListBox: TSCCustomSimpleListbox;
    FMaxPopupHeight: Integer;
    FMaxPopupWidth: Integer;
    FMinPopupHeight: Integer;
    FMinPopupWidth: Integer;
    FScrollbar: TSCComboboxScrollbar;
    FSearchText: String;
    FSearchTickCount: DWord;
    FShowCheckboxes: Boolean;
    FShowItemImages: Boolean;
    FShowSizeGrip: Boolean;
    FShowStatusbar: Boolean;
    FStatusbarAlignment: TAlignment;
    FStatusbarColor: TColor;
    FStatusbarText: String;
    FPopupBorderStyle: TSCEditStyle;
    FPopupProps: TSCComboboxCustomPopupProps;
    FRevertable: Boolean;
    FSettingText: Boolean;
    FInternalItemIndex: Integer;
    FListClickType: TSCListClickType;
    FStartHeight: Integer;
    FStartWidth: Integer;
    FStoredHeight: Integer;
    FStoredWidth: Integer;
    FValues: TStrings;
    FSorted: Boolean;
    FUpdatingCheckState: Integer;
    FOnDrawItem: TSCDrawListItemEvent;
    FOnMeasureItem: TSCMeasureListItemEvent;
    procedure SetContinuousKeySearch(Value: Boolean);
    procedure SetDropDownCount(Value: Integer);
    procedure SetDropDownFont(Value: TFont);
    procedure SetMaxPopupHeight(Value: Integer);
    procedure SetMaxPopupWidth(Value: Integer);
    procedure SetMinPopupHeight(Value: Integer);
    procedure SetMinPopupWidth(Value: Integer);
    procedure SetPopupProps(Value: TSCComboboxCustomPopupProps);
    procedure SetScrollbar(Value: TSCComboboxScrollbar);
    procedure SetSorted(Value: Boolean);
    procedure SetValues(Value: TStrings);

    procedure ListClickCheck(Control: TWinControl; Index: Integer);
    procedure ListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListDrawItem(Control: TWinControl; C: TCanvas; Index: Integer;
      Rect: TRect; State: TSCSimpleListState; UserData: Integer;
      var Done: Boolean);
    procedure ListMeasureItem(Control: TWinControl; Index: Integer;
      var AWidth, AHeight, AIndent: Integer);
    procedure ItemsChanged(Sender: TObject);

    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  protected
    procedure Loaded; override;
    procedure WndProc(var Message: TMessage); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;

    procedure ValuesChanged(Sender: TObject); virtual;
    function  GetSelectedValue: String; virtual;

    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; override;
    function  GetPopupPropsClass: TSCComboboxPopupPropsClass; dynamic;

    procedure DoCheckboxChanged; override;

    procedure DoAutoCompleted; override;
    function  CompletedText(const S: String; CaseSensitive: Boolean): String; virtual;
    function  AutoCompleteText: String; override;

    procedure DoDrawItem(Control: TWinControl; C: TCanvas; Index: Integer;
      Rect: TRect; State: TSCSimpleListState; UserData: Integer;
      var Done: Boolean); virtual;
    procedure DoMeasureItem(Control: TWinControl; Index: Integer;
      var AWidth, AHeight, AIndent: Integer); virtual;

    procedure UpdateCheckState;
    function  ItemCheckStateForCloseup(Index: Integer): TSCCheckState; dynamic;
    function  ItemCheckState(Index: Integer): TSCCheckState; dynamic;
    procedure SetItemCheckState(Index: Integer; Value: TSCCheckState); dynamic;

    procedure BeforeEnterKeyClose; override;
    function  DoWantKeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    procedure DoInternalChange; override;
    procedure DoItemChanging(Index: Integer); virtual;
    procedure DoListClick(Index: Integer; const Item: String); virtual;

    procedure ProcessSearchKey(Key: Char); virtual;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure IndentChanged; override;
    procedure ImageListChange(Sender: TObject); override;

    procedure SortItems; virtual;
    procedure AssignItemsToList; dynamic;
    procedure AssignItemsFromList; dynamic;

    procedure CreatePopupListbox; dynamic;
    procedure DestroyPopupListbox; dynamic;

    function  GetPopupStyle: TSCEditStyle; override;
    function  GetDropDownHeight: Integer; virtual;
    procedure PrepareDropWindow; override;
    procedure BeforePrepareDropWindow; override;
    procedure AfterDropDown; override;
    procedure AfterCloseUp; override;
    function  DropDownWantKeys(Key: Word; Shift: TShiftState): Boolean; override;
    function  GetListboxClass: TSCSimpleListboxClass; dynamic;

    function  AllowDropdown: Boolean; override;
    function  CanDropDown: Boolean; override;
    function  GetDroppedDown: Boolean; override;
    function  GetDropDownWindow: TWinControl; override;

    procedure SetCheckboxAllowGrayed(Value: Boolean); override;
    procedure SetCheckboxEnabled(Value: Boolean); override;
    procedure SetCheckboxVisible(Value: Boolean); override;

    procedure SetAllowGrayed(Value: Boolean); virtual;
    function  GetChecked(Index: Integer): Boolean; virtual;
    procedure SetChecked(Index: Integer; Value: Boolean); virtual;
    procedure SetDropDownColor(Value: TColor); virtual;
    function  GetIndentLevel(Index: Integer): Integer; virtual;
    procedure SetIndentLevel(Index: Integer; Value: Integer); virtual;
    function  GetItemImage(Index: Integer): Integer; virtual;
    procedure SetItemImage(Index: Integer; Value: Integer); virtual;
    function  GetItemEnabled(Index: Integer): Boolean; virtual;
    procedure SetItemEnabled(Index: Integer; Value: Boolean); virtual;
    function  GetItems: TStrings; virtual;
    procedure SetItems(Value: TStrings); virtual;
    function  GetItemIndex: Integer; virtual;
    procedure SetCenterImages(Value: Boolean); virtual;
    procedure SetCheckStyle(Value: TSCSimpleCheckFlat); virtual;
    procedure SetEndEllipsis(Value: Boolean); virtual;
    procedure SetItemHeight(Value: Integer); virtual;
    procedure SetItemIndex(Value: Integer); virtual;
    function  GetItemText(Index: Integer): String; virtual;
    procedure SetShowCheckboxes(Value: Boolean); virtual;
    procedure SetShowItemImages(Value: Boolean); virtual;

    property ListBox: TSCCustomSimpleListbox read FListBox;
    property Items: TStrings read GetItems write SetItems;
    property Checked[Index: Integer]: Boolean read GetChecked write SetChecked;
    property IndentLevel[Index: Integer]: Integer read GetIndentLevel write SetIndentLevel;
    property ItemEnabled[Index: Integer]: Boolean read GetItemEnabled write SetItemEnabled;
    property ItemImage[Index: Integer]: Integer read GetItemImage write SetItemImage;
    property ListClickType: TSCListClickType read FListClickType write FListClickType default sclcDefault;

    property AllowGrayed: Boolean read FAllowGrayed write SetAllowGrayed default False;
    property AutoWidth: Boolean read FAutoWidth write FAutoWidth default False;
    property CenterImages: Boolean read FCenterImages write SetCenterImages default False;
    property CheckboxEnabled default False;
    property CheckStyle: TSCSimpleCheckFlat read FCheckStyle write SetCheckStyle default scsfFlat;
    property ContinuousKeySearch: Boolean read FContinuousKeySearch write SetContinuousKeySearch default False;
    property DblClickReverts: Boolean read FDblClickReverts write FDblClickReverts default False;
    property DropDownColor: TColor read FDropDownColor write SetDropDownColor default clWindow;
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount default 8;
    property DropDownFont: TFont read FDropDownFont write SetDropDownFont;
    property DropOnAutoComplete: Boolean read FDropOnAutoComplete write FDropOnAutoComplete default False;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default False;
    property ImmediateDropDown: Boolean read FImmediateDropDown write FImmediateDropDown default False;
    property ImmediateSetText: Boolean read FImmediateSetText write FImmediateSetText default True;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default -1;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property MaxPopupHeight: Integer read FMaxPopupHeight write SetMaxPopupHeight default 0;
    property MaxPopupWidth: Integer read FMaxPopupWidth write SetMaxPopupWidth default 0;
    property MinPopupHeight: Integer read FMinPopupHeight write SetMinPopupHeight default 0;
    property MinPopupWidth: Integer read FMinPopupWidth write SetMinPopupWidth default 0;
    property PopupBorderStyle: TSCEditStyle read FPopupBorderStyle write FPopupBorderStyle default scesDefault;
    property PopupProps: TSCComboboxCustomPopupProps read FPopupProps write SetPopupProps;
    property Revertable: Boolean read FRevertable write FRevertable default False;
    property Scrollbar: TSCComboboxScrollbar read FScrollbar write SetScrollbar;
    property SelectedValue: String read GetSelectedValue;
    property ShowCheckboxes: Boolean read FShowCheckboxes write SetShowCheckboxes default False;
    property CheckboxVisible default False;
    property ShowItemImages: Boolean read FShowItemImages write SetShowItemImages default False;
    property ShowSizeGrip: Boolean read FShowSizeGrip write FShowSizeGrip default True;
    property ShowStatusbar: Boolean read FShowStatusbar write FShowStatusbar default False;
    property Sorted: Boolean read FSorted write SetSorted default False;
    property StatusbarAlignment: TAlignment read FStatusbarAlignment write FStatusbarAlignment default taLeftJustify;
    property StatusbarColor: TColor read FStatusbarColor write FStatusbarColor default clBtnFace;
    property StatusbarText: String read FStatusbarText write FStatusbarText;
    property Values: TStrings read FValues write SetValues;
    property OnDrawItem: TSCDrawListItemEvent read FOnDrawItem write FOnDrawItem;
    property OnMeasureItem: TSCMeasureListItemEvent read FOnMeasureItem write FOnMeasureItem;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure BeginItemUpdate; dynamic;
    procedure EndItemUpdate; dynamic;
    function  InItemUpdate: Boolean; dynamic;

    function  ItemCount: Integer; dynamic;
    function  IndexOfItem(const S: string): Integer; dynamic;
    function  FindItem(const S: String; StartPos, EndPos: Integer): Integer;

    property ItemText[Index: Integer]: String read GetItemText;
  end;

  TSCCombobox = class(TSCCustomCombobox)
  public
    property Checked;
    property IndentLevel;
    property ItemEnabled;
    property ItemImage;
    property ItemIndex;
    property SelectedValue;
    property CheckboxState;
  published
    property Align;
    property Alignment;
    property AllowGrayed;
    property Anchors;
    property AutoComplete;
    property AutoSelect;
    property AutoSize;
    property AutoWidth;
    property BiDiMode;
    property BorderProps;
    property BrowseButtonVisible;
    property ButtonProps;
    property CanDragSelection;
    property CanEdit;
    property CenterImages;
    property CharCase;
    property CheckboxEnabled;
    property CheckboxStyle;
    property CheckStyle;
    property Color;
    property Colors;
    property Constraints;
    property ContinuousKeySearch;
    property DblClickReverts;
    property Delimeters;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownKey;
    property DropOnAutoComplete;
    property EditCursor;
    property EditMask;
    property EditMode;
    property Enabled;
    property EndEllipsis;
    property EnterAsTab;
    property FocusExpandSize;
    property Font;
    property HideSelection;
    property ImageIndex;
    property Images;
    property ImeMode;
    property ImeName;
    property ImmediateDropDown;
    property ImmediateSetText;
    property Indent;
    property InsertChangesEditMode;
    property IsDropDown;
    property ItemHeight;
    property Items;
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
    property PopupProps;
    property PopupMenu;
    property RaiseMaskError;
    property ReadOnly;
    property Revertable;
    property ShowCheckboxes;
    property CheckboxVisible;
    property ShowItemImages;
    property ShowHint;
    property Sorted;
    property Style;
    property TabOrder;
    property TabStop;
    property Text;
    property Transparent;
    property UseImage;
    property UseUndo;
    property UndoLimit;
    property Values;
    property Visible;
    property OnBrowseClick;
    property OnCaretMove;
    property OnCanResize;
    property OnChange;
    property OnCheckboxChange;
    property OnClick;
    property OnClipCut;
    property OnClipCopy;
    property OnClipPaste;
    property OnCloseUp;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEditModeChange;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnFocusChanged;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomComboboxEx = class;

  TSCComboboxExItem = class(TCollectionItem)
  private
    FEnabled: Boolean;
    FImageIndex: TImageIndex;
    FIndentLevel: Integer;
    FState: TSCCheckState;
    FText: String;
    FValue: String;
    FData: TObject;
    function  GetChecked: Boolean;
    procedure SetChecked(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetIndentLevel(Value: Integer);
    procedure SetState(Value: TSCCheckState);
    procedure SetText(const Value: String);
    procedure SetValue(const Value: String);
  protected
    function  GetDisplayName: string; override;
    function  GetComboboxEx: TSCCustomComboboxEx;
    function  GetImages: TCustomImageList;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;

    property ComboboxEx: TSCCustomComboboxEx read GetComboboxEx;
    property Data: TObject read FData write FData;
  published
    property Checked: Boolean read GetChecked write SetChecked stored False default False;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property IndentLevel: Integer read FIndentLevel write SetIndentLevel default 0;
    property State: TSCCheckState read FState write SetState default sccbUnchecked;
    property Text: String read FText write SetText;
    property Value: String read FValue write SetValue;
  end;

  TSCComboboxExItems = class(TCollection)
  private
    FOwner: TSCCustomComboboxEx;
    function  GetItem(Index: Integer): TSCComboboxExItem;
    procedure SetItem(Index: Integer; Value: TSCComboboxExItem);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
    function  CompletedText(const S: String; CaseSensitive: Boolean): String;
  public
    constructor Create(AOwner: TSCCustomComboboxEx);
    function Add: TSCComboboxExItem;
    function IndexOf(const S: String; CaseSensitive: Boolean = False): Integer;
    function IndexOfValue(const S: String; CaseSensitive: Boolean = False): Integer;
    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomComboboxEx read FOwner;
    {$ENDIF}
    property Items[Index: Integer]: TSCComboboxExItem read GetItem write SetItem; default;
  end;

  TSCCustomComboboxEx = class(TSCCustomCombobox)
  private
    FInExChange: Boolean;
    FItemsEx: TSCComboboxExItems;
    procedure SetItemsEx(Value: TSCComboboxExItems);

    procedure ExItemChanged(Item: TSCComboboxExItem);
    procedure ExItemsChanged;
  protected
    procedure DoExItemChanged(Item: TSCComboboxExItem); dynamic;
    procedure DoExItemsChanged; dynamic;

    function  GetSelectedItem: TSCComboboxExItem;
    function  GetSelectedValue: String; override;
    function  GetItemText(Index: Integer): String; override;

    function  ItemCheckState(Index: Integer): TSCCheckState; override;
    procedure SetItemCheckState(Index: Integer; Value: TSCCheckState); override;
    function  CompletedText(const S: String; CaseSensitive: Boolean): String; override;

    procedure AssignItemsToList; override;
    procedure AssignItemsFromList; override;

    property ItemsEx: TSCComboboxExItems read FItemsEx write SetItemsEx;
    property ShowItemImages default True;
    property SelectedItem: TSCComboboxExItem read GetSelectedItem;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  ItemCount: Integer; override;
    function  IndexOfItem(const S: string): Integer; override;
  end;

  TSCComboboxEx = class(TSCCustomComboboxEx)
  public
    property ItemIndex;
    property Checked;
    property IndentLevel;
    property ItemEnabled;
    property ItemImage;
    property SelectedItem;
    property SelectedValue;
    property CheckboxState;
  published
    property Align;
    property Alignment;
    property AllowGrayed;
    property Anchors;
    property AutoComplete;
    property AutoSelect;
    property AutoSize;
    property AutoWidth;
    property BiDiMode;
    property BrowseButtonVisible;
    property ButtonProps;
    property CanDragSelection;
    property CanEdit;
    property CenterImages;
    property CharCase;
    property CheckboxEnabled;
    property CheckStyle;
    property CheckboxStyle;
    property Color;
    property Colors;
    property Constraints;
    property ContinuousKeySearch;
    property DblClickReverts;
    property Delimeters;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownKey;
    property DropOnAutoComplete;
    property EditCursor;
    property EditMask;
    property EditMode;
    property Enabled;
    property EndEllipsis;
    property EnterAsTab;
    property FocusExpandSize;
    property Font;
    property HideSelection;
    property ImageIndex;
    property Images;
    property ImeMode;
    property ImeName;
    property ImmediateDropDown;
    property ImmediateSetText;
    property Indent;
    property InsertChangesEditMode;
    property IsDropDown;
    property ItemHeight;
    property ItemsEx;
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
    property PopupProps;
    property RaiseMaskError;
    property ReadOnly;
    property Revertable;
    property ShowCheckboxes;
    property CheckboxVisible;
    property ShowItemImages;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Text;
    property Transparent;
    property UseImage;
    property UseUndo;
    property UndoLimit;
    property Values;
    property Visible;
    property OnBrowseClick;
    property OnCaretMove;
    property OnCanResize;
    property OnChange;
    property OnClick;
    property OnClipCut;
    property OnClipCopy;
    property OnClipPaste;
    property OnCloseUp;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEditModeChange;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnFocusChanged;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomPopupbox = class(TSCCustomDropDown)
  private
    FMaxPopupHeight: Integer;
    FMaxPopupWidth: Integer;
    FMinPopupHeight: Integer;
    FMinPopupWidth: Integer;
    FPopupBorderStyle: TSCEditStyle;
    FPopupContainer: TWinControl;
    FPopupControl: TControl;
    FPopupHeight: Integer;
    FPopupWidth: Integer;
    FShowSizeGrip: Boolean;
    FShowStatusbar: Boolean;
    FStatusbarColor: TColor;
    FStatusbarText: String;
    FStartHeight: Integer;
    FStartWidth: Integer;
    FStoredHeight: Integer;
    FStoredWidth: Integer;
    procedure SetMaxPopupHeight(Value: Integer);
    procedure SetMaxPopupWidth(Value: Integer);
    procedure SetMinPopupHeight(Value: Integer);
    procedure SetMinPopupWidth(Value: Integer);
    procedure SetPopupControl(Value: TControl);
    procedure SetPopupHeight(Value: Integer);
    procedure SetPopupWidth(Value: Integer);
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; override;

    function  GetPopupStyle: TSCEditStyle; override;
    procedure DropDownPopupbox; override;
    procedure CloseUp; override;
    procedure PrepareDropWindow; override;

    function  CanDropDown: Boolean; override;
    function  GetDroppedDown: Boolean; override;
    function  GetDropDownWindow: TWinControl; override;

    property MaxPopupHeight: Integer read FMaxPopupHeight write SetMaxPopupHeight default 0;
    property MaxPopupWidth: Integer read FMaxPopupWidth write SetMaxPopupWidth default 0;
    property MinPopupHeight: Integer read FMinPopupHeight write SetMinPopupHeight default 0;
    property MinPopupWidth: Integer read FMinPopupWidth write SetMinPopupWidth default 0;
    property PopupBorderStyle: TSCEditStyle read FPopupBorderStyle write FPopupBorderStyle default scesDefault;
    property PopupControl: TControl read FPopupControl write SetPopupControl;
    property PopupHeight: Integer read FPopupHeight write SetPopupHeight default -1;
    property PopupWidth: Integer read FPopupWidth write SetPopupWidth default -1;
    property ShowSizeGrip: Boolean read FShowSizeGrip write FShowSizeGrip default True;
    property ShowStatusbar: Boolean read FShowStatusbar write FShowStatusbar default False;
    property StatusbarColor: TColor read FStatusbarColor write FStatusbarColor default clBtnFace;
    property StatusbarText: String read FStatusbarText write FStatusbarText;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCPopupbox = class(TSCCustomPopupbox)
  published
    property Align;
    property Alignment;
    property Anchors;
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
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownKey;
    property EditCursor;
    property EditMask;
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
    property IsDropDown;
    property Layout;
    property MaxLength;
    property MaxPopupHeight;
    property MaxPopupWidth;
    property MinPopupHeight;
    property MinPopupWidth;
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
    property PopupBorderStyle;
    property PopupControl;
    property PopupHeight;
    property PopupWidth;
    property PopupMenu;
    property RaiseMaskError;
    property ReadOnly;
    property ShowHint;
    property ShowStatusbar;
    property StatusbarColor;
    property Style;
    property TabOrder;
    property TabStop;
    property Text;
    property Transparent;
    property UseImage;
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

uses
  ShellAPI;

type
  TFakeControl = class(TControl);
  TFakeSCControl = class(TSCCustomControl);

const
  SC_SPIN_REPEATTIMERID = 54321;
  CM_CANCEL = WM_USER + $9876;

type
  TSCComboStrings = class(TSCStringList);
  TSCListStrings  = class(TSCStringList);
  TSCComboListbox = class(TSCCustomSimpleListbox);

  TSCDropDownListbox = class(TSCCustomSimpleListbox)
  private
    FDroppedDown: Boolean;
    FSettingHighlight: Boolean;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure WMShowWindow(var Message: TWMShowWindow); message WM_SHOWWINDOW;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;

    function  CanShowEditor: Boolean; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ColorsChanged; override;

    property ForceDropdownClick default True;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TPopupWinControl = class(TWinControl);
  TScrollingPopupParent = class(TScrollingWinControl);

  TSCPopupControl = class(TSCCustomSizableControl)
  private
    FInPopup: Boolean;
    FPreparingPopup: Boolean;
    FCancelPopup: Boolean;
    FControl: TControl;
    FControlAlign: TAlign;
    FControlBounds: TRect;
    FPopupbox: TSCCustomPopupbox;
    FIsControlVisible: Boolean;
    FParentControl: TWinControl;
    FParentAutoScroll: Boolean;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    function  IsChildHandle(AHandle: HWND): Boolean;
    procedure Cancel;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;

    property InPopup: Boolean read FInPopup;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Popup(C: TSCCustomPopupbox);
  end;


{ TSCDropDownListbox }

function TSCDropDownListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

procedure TSCDropDownListbox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  HottrackColor := Font.Color;
end;

procedure TSCDropDownListbox.CMVisibleChanged(var Message: TMessage);
begin
  inherited;
  if not Boolean(Message.WParam) then
    FDroppedDown := False;
end;

procedure TSCDropDownListbox.ColorsChanged;
begin
  if FSettingHighlight then
    Exit;

  FSettingHighlight := True;
  try
    HideSelectionColor := HighlightColor;
    HideSelectionTextColor := HighlightTextColor;
    HottrackColor := Self.Font.Color;
  finally
    FSettingHighlight := False;
  end;
end;

constructor TSCDropDownListbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  HotTrack := True;
  Border := sccbFlat;
  FlatColor := clWindowFrame;
  ShowItemHints := False;
  ScrollbarHorizontal := False;
  ForceDropdownClick := True;

  ColorsChanged;
end;

procedure TSCDropDownListbox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  
  with Params do
  begin
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    Style := Style and not WS_BORDER;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TSCDropDownListbox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;

procedure TSCDropDownListbox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  L, R, CbxW, Indx: Integer;
begin
  if not FDroppedDown then
  begin
    FDroppedDown := True;
    Exit;
  end;

  inherited MouseMove(Shift, X, Y);

  if not Dropping and HotTrack and (HotIndex <> ItemIndex) then
  begin
    Indx := ItemAtPos(X, Y, False);

    if ShowCheckboxes and (Indx > -1) then
    begin
      CbxW := GetCheckWidth;

      if CbxW > 0 then
      begin
        L := Indent*IndentLevel[Indx];
        if L < 0 then L := 0;

        R := L + CbxW;
        if (X > L) and (X < R) then
          Exit;
      end;
    end;

    if (Indx <> -1) and (ItemIndex <> Indx) then
      ItemIndex := Indx;
  end;
end;

procedure TSCDropDownListbox.WMShowWindow(var Message: TWMShowWindow);
begin
  inherited;
  if not Message.Show then
    FDroppedDown := False;
end;

{ TSCPopupControl }

procedure TSCPopupControl.Cancel;
begin
  FCancelPopup := True;
  PostMessage(Handle, CM_CANCEL, 0, 0);
end;

constructor TSCPopupControl.Create(AOwner: TComponent);
begin
  inherited;
  BlendColor := False;
  Visible := False;
  Parent := GetParentForm(TSCCustomPopupbox(AOwner));
end;

procedure TSCPopupControl.CreateParams(var Params: TCreateParams);
begin
  inherited;

  with Params do
  begin
    Style := WS_POPUP;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
  end;
end;

function TSCPopupControl.IsChildHandle(AHandle: HWND): Boolean;
begin
  Result := False;
  while AHandle <> 0 do
  begin
    Result := AHandle = Handle;
    if Result then Exit;

    AHandle := GetParent(AHandle);
  end;
end;

procedure TSCPopupControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
  begin
    if AComponent = FControl then
    begin
      FControl := nil;
      FIsControlVisible := False;
      FParentControl := nil;

      if FInPopup then
        Cancel;
    end else
    if AComponent = FParentControl then
    begin
      FParentControl := nil;
      FIsControlVisible := False;
    end else
    if AComponent = FPopupbox then
    begin
      FPopupbox := nil;
      if FInPopup then
        Cancel;
    end;
  end;
end;

procedure TSCPopupControl.Popup(C: TSCCustomPopupbox);
var
  Msg: TMsg;
  P: TPoint;
  W, H: Integer;

  function InitiatePopup: Boolean;
  begin
    FPreparingPopup := True;
    try
      FParentControl := nil;
      FIsControlVisible := True;
      FParentAutoScroll := False;

      FControl := FPopupbox.FPopupControl;
      Result   := FControl <> nil;

      if Result then
      begin
        P := Point(0, 0);
        if FPopupbox.Parent <> nil then
        begin
          P := Point(FPopupbox.Left, FPopupbox.Top + FPopupbox.Height);
          P := Self.ScreenToClient(FPopupbox.Parent.ClientToScreen(P));
        end;

        H := FPopupbox.FPopupHeight;
        if H <= 0 then H := FControl.Height;

        W := FPopupbox.FPopupWidth;
        if W <= 0 then W := FControl.Width;

        FParentControl := FControl.Parent;
        FIsControlVisible := FControl.Visible;

        if FParentControl <> nil then
        begin
          if FParentControl is TScrollingWinControl then
            with TScrollingPopupParent(FParentControl) do
            begin
              FParentAutoScroll := AutoScroll;
              AutoScroll := False;
            end;

          FParentControl.DisableAlign;
        end;

        with FControl do
        begin
          FControlAlign  := Align;
          FControlBounds := BoundsRect;

          Visible := False;

          Align   := alClient;
          Parent  := Self;
          Visible := True;
        end;

        FControl.FreeNotification(Self);

        if FControl is TWinControl then
          Windows.SetFocus(TWinControl(FControl).Handle);
      end;
    finally
      FPreparingPopup := False;
    end;
  end;

  procedure FinalizePopup;
  begin
    FPreparingPopup := True;
    try
      SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOACTIVATE or
        SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE);

      try
        Visible := False;

        if FControl <> nil then
        begin
          {$IFDEF SC_DELPHI5_UP}
          FControl.RemoveFreeNotification(Self);
          if FParentControl <> nil then
            FParentControl.RemoveFreeNotification(Self);
          {$ENDIF}

          with FControl do
          begin
            Align := FControlAlign;

            Visible := False;
            Parent  := FParentControl;
            BoundsRect := FControlBounds;
            Visible := FIsControlVisible;
          end;
        end;

        if FParentControl <> nil then
        begin
          FParentControl.EnableAlign;

          if FParentControl is TScrollingWinControl then
            with TScrollingPopupParent(FParentControl) do
              AutoScroll := FParentAutoScroll;
        end;

        FControl := nil;
        FParentControl := nil;
        FIsControlVisible := False;
      finally
        Parent := nil;
      end;
    finally
      FPreparingPopup := False;
    end;
  end;

  procedure DoPopup;
  begin
    if FPopupbox <> nil then
      FPopupbox.FDropState := sccsDropped;

    try
      while not FCancelPopup and Visible and Application.Active and
        (FControl <> nil) and not Application.Terminated do
      begin
        if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then
        begin
          case Msg.message of
            WM_NCACTIVATE:
            if (Msg.hwnd = Self.Handle) or IsChildHandle(Msg.hwnd) then
              PeekMessage(Msg, 0, 0, 0, PM_REMOVE)
            else
              Break;
            WM_MOUSEACTIVATE:
            if (Msg.hwnd = Self.Handle) or IsChildHandle(Msg.hwnd) then
              PeekMessage(Msg, 0, 0, 0, PM_REMOVE)
            else
              Break;
            WM_SYSCOMMAND:
              if Msg.WParam = 61448 then
                inherited
              else
                Cancel;
            WM_NCLBUTTONDOWN, WM_NCRBUTTONDOWN,
            WM_NCMBUTTONDOWN, WM_LBUTTONDOWN,
            WM_MBUTTONDOWN,   WM_RBUTTONDOWN,
            WM_LBUTTONDBLCLK, WM_RBUTTONDBLCLK,
            WM_MBUTTONDBLCLK:
            if (Msg.hwnd <> Self.Handle) and not IsChildHandle(Msg.hwnd) then
            begin
              if Msg.hwnd = FPopupbox.Handle then
                PeekMessage(Msg, 0, 0, 0, PM_REMOVE);

              Break;
            end;
            WM_KEYFIRST..WM_KEYLAST:
            begin
              if (Msg.message = WM_KEYDOWN) and (Msg.wParam = VK_ESCAPE) and
                (((FControl <> nil) and (FControl is TWinControl) and
                 (Msg.hwnd = TWinControl(FControl).Handle)) or
                 (FControl = nil) or (Msg.hwnd = Self.Handle)) then
              begin
                PeekMessage(Msg, 0, Msg.message, Msg.message, PM_REMOVE);
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

          Application.HandleMessage;
        end;
      end;
    finally
      FinalizePopup;
    end;
  end;

begin
  if FInPopup or (C = nil) then
    Exit;

  FInPopup := False;

  FPopupbox := C;
  FPopupbox.FreeNotification(Self);

  if not InitiatePopup then
  begin
    {$IFDEF SC_DELPHI5_UP}
    FPopupbox.RemoveFreeNotification(Self);
    {$ENDIF}
    FPopupbox := nil;

    Exit;
  end;

  FCancelPopup := False;
  FInPopup := True;

  if FPopupbox <> nil then
    FPopupbox.FDropState := sccsDropping;

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

      if (FControl is TWinControl) and TWinControl(FControl).CanFocus then
        TWinControl(FControl).SetFocus;
    finally
      FPreparingPopup := False;
    end;

    DoPopup;

    if FPopupbox <> nil then
    begin
      FPopupbox.FDropState := sccsClosing;

      if FPopupbox.CanFocus then
        FPopupbox.SetFocus;

      with FPopupbox do
      begin
        AfterCloseUp;
        DoCloseUp;
      end;
    end;
  finally
    if FPopupbox <> nil then
      FPopupbox.FDropState := sccsDefault;

    FCancelPopup := False;
    FInPopup := False;
    FPopupbox := nil;

    Free;
  end;
end;

procedure TSCPopupControl.WMActivate(var Message: TWMActivate);
var
  F: TCustomForm;
begin
  inherited;

  if FPopupbox <> nil then
  begin
    F := GetParentForm(FPopupbox);
    if (F <> nil) and F.HandleAllocated then
      SendMessage(F.Handle, WM_NCACTIVATE, Longint(Message.Active <> WA_INACTIVE), 0);
  end;
end;

procedure TSCPopupControl.WndProc(var Message: TMessage);
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

{ TSCEditButton }

procedure TSCEditButton.Assign(Source: TPersistent);
begin
  if Source is TSCEditButton then
  begin
    BeginUpdate;
    try
      with TSCEditButton(Source) do
      begin
        Self.Align := Align;
        Self.ArrowColor := ArrowColor;
        Self.Color := Color;
        Self.Image := Image;
        Self.Style := Style;
        Self.Visible := Visible;
        Self.Width := Width;
      end;
    finally
      EndUpdate;
    end;
  end else
    inherited Assign(Source);
end;

procedure TSCEditButton.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TSCEditButton.Changed(Full: Boolean);
begin
  if InUpdate then
  begin
    FChanged := True;
    Exit;
  end;

  FChanged := False;
  if Full or (FVisible and (FWidth <> 0)) then
  begin
    if FOwner <> nil then
      FOwner.ButtonChanged(Self);

    DoChange;
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

constructor TSCEditButton.Create(AOwner: TSCCustomButtonFrame);
begin
  inherited Create;
  if AOwner <> nil then AOwner.RegisterButton(Self);

  FAlign := taRightJustify;
  FArrowColor := clBtnText;
  FColor := clBtnFace;
  FImage := -1;
  FStyle := scebImage;
  FVisible := True;
  FWidth := -1;
end;

destructor TSCEditButton.Destroy;
begin
  if FOwner <> nil then
    FOwner.UnregisterButton(Self);
  inherited Destroy;
end;

procedure TSCEditButton.DoChange;
begin
  //
end;

procedure TSCEditButton.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if (FUpdateCount = 0) and FChanged then
      Changed(True);
  end;
end;

function TSCEditButton.GetImages: TCustomImageList;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.Images;
end;

function TSCEditButton.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCEditButton.GetWidth: Integer;
begin
  Result := FWidth;
  if Result < 0 then
    Result := GetSystemMetrics(SM_CXVSCROLL);
end;

function TSCEditButton.InUpdate: Boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TSCEditButton.SetAlign(Value: TLeftRight);
begin
  if FAlign <> Value then
  begin
    FAlign := Value;
    Changed(FVisible and (FWidth <> 0));
  end;
end;

procedure TSCEditButton.SetArrowColor(Value: TColor);
begin
  if FArrowColor <> Value then
  begin
    FArrowColor := Value;
    Changed(False);
  end;
end;

procedure TSCEditButton.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed(False);
  end;
end;

procedure TSCEditButton.SetDropUp(Value: Boolean);
begin
  if FDropUp <> Value then
  begin
    FDropUp := Value;
    if FStyle = scebDropDown then
      Changed(False);
  end;
end;

procedure TSCEditButton.SetImage(Value: TImageIndex);
begin
  if FImage <> Value then
  begin
    FImage := Value;
    Changed(False);
  end;
end;

procedure TSCEditButton.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TSCEditButton.SetStyle(Value: TSCEditButtonStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Changed(False);
  end;
end;

procedure TSCEditButton.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(FWidth <> 0);
  end;
end;

procedure TSCEditButton.SetWidth(Value: Integer);
begin
  if Value < -1 then
    Value := -1;

  if FWidth <> Value then
  begin
    FWidth := Value;
    Changed(FVisible);
  end;
end;

{ TSCCustomFrameEdit }

procedure TSCCustomFrameEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomFrameEdit then
  begin
    with TSCCustomFrameEdit(Source) do
    begin
      Self.FrameColor := FrameColor;
      Self.Style := Style;
      Self.ExUseColor := ExUseColor;
      Self.Colors := Colors;
      Self.BorderProps := BorderProps;
    end;
  end;
end;

function TSCCustomFrameEdit.CanSetBorder(Value: TSCControlBorder): Boolean;
begin
  Result := True;
end;

function TSCCustomFrameEdit.CanSetInnerBorder(Value: TSCControlBorder): Boolean;
begin
  Result := True;
end;

constructor TSCCustomFrameEdit.Create(AOwner: TComponent);
begin
  FStyle := scesDefault;
  inherited Create(AOwner);
  SetBounds(Left, Top, 145, 21);
  Border := sccbNone;
  BorderInner := sccbNone;
  HideSelection := True;

  FFrameColor := clNone;
  FExUseColor := $00FFC7B7;
  StyleChanged;
end;

function TSCCustomFrameEdit.GetBorderProps: TSCFrameEditBorderProps;
begin
  Result :=  TSCFrameEditBorderProps(inherited BorderProps);
end;

function TSCCustomFrameEdit.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCFrameEditBorderProps;
end;

function TSCCustomFrameEdit.GetColors: TSCFrameEditColors;
begin
  Result := TSCFrameEditColors(inherited Colors);
end;

function TSCCustomFrameEdit.GetEditColorsClass: TSCEditCustomColorsClass;
begin
  Result := TSCFrameEditColors;
end;

function TSCCustomFrameEdit.GetEditRect: TRect;
var
  R: TRect;
begin
  Result := inherited GetEditRect;
  if (Layout = scelTop) and (Border = sccbNone) and (FStyle <> scesNone) then
    InflateRect(Result, 0, -1);

  R := Rect(0, 0, 0, 0);
  UpdateBorderRect(R);

  Inc(Result.Left,   R.Left);
  Dec(Result.Right,  R.Right);
  Inc(Result.Top,    R.Top);
  Dec(Result.Bottom, R.Bottom);
end;

function TSCCustomFrameEdit.GetExtraBorderSize: Integer;
begin
  Result := 0;
  if FStyle in [scesDouble, scesDoubleNew] then
    Result := 3
  else if FStyle <> scesNone then
    Result := 2;
end;

function TSCCustomFrameEdit.GetFrameRect: TRect;
begin
  Result := GetClientRect;
end;

function TSCCustomFrameEdit.GetIsExtraFlat: Boolean;
begin
  Result := FStyle in [scesOfficeXP, scesOffice12, scesOffice2003,
    scesSingle, scesNew, scesExtreme, scesDouble, scesDoubleNew];
end;

function TSCCustomFrameEdit.GetStyleBorderSize: Integer;
begin
  Result := 3;
  if FStyle in [scesDouble, scesDoubleNew] then
    Result := 4
  else if FStyle = scesNone then
    Result := 2;
end;

procedure TSCCustomFrameEdit.MouseInControlChanged;
begin
  Invalidate;
end;

procedure TSCCustomFrameEdit.PaintWindow(DC: HDC);
begin
  Canvas.Lock;
  try
    inherited PaintWindow(DC);
    Canvas.Handle := DC;
    try
      TControlCanvas(Canvas).UpdateTextFlags;
      DrawEditBorder(Canvas);
    finally
      Canvas.Handle := 0;
    end;
  finally
    Canvas.Unlock;
  end;
end;

procedure TSCCustomFrameEdit.SetBorderProps(
  Value: TSCFrameEditBorderProps);
begin
  inherited BorderProps := Value;
end;

procedure TSCCustomFrameEdit.SetColors(Value: TSCFrameEditColors);
begin
  inherited Colors := Value;
end;

procedure TSCCustomFrameEdit.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomFrameEdit.SetStyle(Value: TSCEditStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    StyleChanged;
  end;
end;

procedure TSCCustomFrameEdit.SetExUseColor(Value: TColor);
begin
  if FExUseColor <> Value then
  begin
    FExUseColor := Value;
    if FStyle = scesWinXP then
      Invalidate;
  end;
end;

procedure TSCCustomFrameEdit.StyleChanged;
begin
  if AutoSize then AdjustBounds;
  Invalidate;
end;

procedure TSCCustomFrameEdit.UpdateBorderRect(var R: TRect);
begin
end;

procedure TSCCustomFrameEdit.DrawEditBorder(C: TCanvas);
var
  R: TRect;
  Cl1, Cl2: TColor;
begin
  if C = nil then
    Exit;

  R := GetFrameRect;

  case FStyle of
    scesNone:
    begin
      // none
    end;
    scesDefault, scesDefaultEx:
      scDrawEdge(C, R, clNone, clNone, False, sccb3DLowered);
    scesOffice12:
    begin
      Cl1 := Self.ExUseColor;
      if Cl1 = clNone then
        Cl1 := clBtnFace;

      if MouseInControl or Focused or MouseIsDown then
        scFrame3D(C, R, Cl1, Cl1, 1, 0)
      else
        scFrame3D(C, R, clBtnFace, clBtnFace, 1, 0);
    end;
    scesOfficeXP, scesOffice2003:
    begin
      if MouseInControl or Focused or MouseIsDown then
        scFrame3D(C, R, clHighlight, clHighlight, 1, 0)
      else
        scFrame3D(C, R, clBtnFace, clBtnFace, 1, 0);
    end;
    scesFlat:
    begin
      if MouseInControl or Focused or MouseIsDown then
      begin
        Cl1 := clBtnShadow;
        Cl2 := clBtnHighlight;

        scFrame3D(C, R, Cl1, Cl2, 1, 0);

        Cl1 := cl3DDkShadow;
        Cl2 := clBtnFace;

        scFrame3D(C, R, Cl1, Cl2, 1, 0);
      end else
      begin
        Cl1 := clBtnShadow;
        Cl2 := clBtnHighlight;

        scFrame3D(C, R, Cl1, Cl2, 1, 0);

        Cl1 := clBtnFace;
        Cl2 := clBtnFace;

        scFrame3D(C, R, Cl1, Cl2, 1, 0);
      end;
    end;
    scesFlatEx:
    begin
      if MouseInControl or Focused or MouseIsDown then
      begin
        Cl1 := clBtnShadow;
        Cl2 := clBtnHighlight;

        scFrame3D(C, R, Cl1, Cl2, 1, 0);

        Cl1 := clBtnFace;
        Cl2 := clBtnFace;

        scFrame3D(C, R, Cl1, Cl2, 1, 0);
      end else
      begin
        Cl1 := clBtnFace;

        scFrame3D(C, R, Cl1, Cl1, 1, 0);
        scFrame3D(C, R, Cl1, Cl1, 1, 0);
      end;
    end;
    scesFlatNew:
    begin
      Cl1 := clBtnShadow;
      if FFrameColor <> clNone then
        Cl1 := FFrameColor;

      scFrame3D(C, R, Cl1, Cl1, 1, 0);
      scFrame3D(C, R, Cl1, Cl1, 1, 0);
    end;
    scesMetal:
    begin
      Cl1 := clBtnShadow;
      if FFrameColor <> clNone then
        Cl1 := FFrameColor;

      Inc(R.Top);
      Inc(R.Left);

      scFrame3D(C, R, GetBtnHighlightOf(Cl1), GetBtnHighlightOf(Cl1), 1, 0);
      InflateRect(R, 1, 1);

      OffsetRect(R, -1, -1);
      scFrame3D(C, R, Cl1, Cl1, 1, 0);
    end;
    scesSingle, scesSingleEx:
    begin
      Cl1 := clBtnShadow;
      if FFrameColor <> clNone then
        Cl1 := FFrameColor;

      scFrame3D(C, R, Cl1, Cl1, 1, 0);
    end;
    scesNew, scesExtreme:
    begin
      Cl1 := clBtnShadow;
      if FFrameColor <> clNone then
        Cl1 := FFrameColor;

      scFrame3D(C, R, Cl1, Cl1, 1, 0);
    end;
    scesDouble, scesDoubleNew:
    begin
      Cl1 := clBtnShadow;
      if FFrameColor <> clNone then
        Cl1 := FFrameColor;

      scFrame3D(C, R, Cl1, Cl1, 1, 0);

      Cl2 := clBtnHighlight;
      scFrame3D(C, R, Cl2, Cl2, 1, 0);

      scFrame3D(C, R, Cl1, Cl1, 1, 0);
    end;
    scesRaised:
    begin
      Cl1 := clBtnHighlight;
      Cl2 := clBtnShadow;

      scFrame3D(C, R, Cl1, Cl2, 1, 0);
    end;
    sces3D:
    begin
      Cl1 := clBtnHighlight;
      Cl2 := cl3DDkShadow;

      scFrame3D(C, R, Cl1, Cl2, 1, 0);

      Cl1 := clBtnFace;
      Cl2 := clBtnShadow;

      scFrame3D(C, R, Cl1, Cl2, 1, 0);
    end;
    scesWinXP:
    begin
      Cl1 := SCCommon.scBlendColor(FExUseColor, -32);
      scFrame3D(C, R, Cl1, Cl1, 1, 0);
    end;
    else
      scDrawEdge(C, R, clNone, clNone, False, sccb3DLowered);
  end;
end;

procedure TSCCustomFrameEdit.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('WinXPColor', ReadXPColor, WriteXPColor, False);
end;

procedure TSCCustomFrameEdit.ReadXPColor(Reader: TReader);
begin
  try
    FExUseColor := StringToColor(Reader.ReadIdent);
  except
  end;
end;

procedure TSCCustomFrameEdit.WriteXPColor(Writer: TWriter);
begin
  //
end;

{ TSCBaseDropDownButton }

constructor TSCBaseDropDownButton.Create(AOwner: TSCCustomButtonFrame);
begin
  inherited Create(AOwner);
  FStyle := scebDropDown;
  FVisible := False;
end;

{ TSCBrowseButton }

constructor TSCBrowseButton.Create(AOwner: TSCCustomButtonFrame);
begin
  inherited Create(AOwner);
  FStyle := scebBrowse;
  FVisible := False;
end;

{ TSCCustomButtonEdit }

function TSCCustomButtonEdit.AdjustImageTop(ImgTop: Integer): Integer;
begin
  Result := IndentTop;
  if Result = 0 then
    Result := 1;
end;

procedure TSCCustomButtonEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomButtonEdit then
    with TSCCustomButtonEdit(Source) do
      Self.ButtonClickKey := ButtonClickKey;
end;

constructor TSCCustomButtonEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButton := GetButtonClass.Create(Self);
  FBrowseButton := TSCBrowseButton.Create(Self);
  StyleChanged;
end;

procedure TSCCustomButtonEdit.DoButtonClick(Btn: TSCEditButton);
begin
  if Btn = FBrowseButton then
  begin
    if Assigned(FOnBrowseClick) then
      FOnBrowseClick(Self);
    Exit;
  end;

  if Assigned(FOnButtonClick) then
    FOnButtonClick(Self);
end;

function TSCCustomButtonEdit.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCEditButtonProps;
end;

function TSCCustomButtonEdit.GetButtonRect(Btn: TSCEditButton): TRect;
var
  I, W, BW: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated and (Btn <> nil) and Btn.Visible and
    ((Btn = FButton) or (Btn = FBrowseButton)) then
  begin
    Result := GetInnerEditRect;

    if IsRectEmpty(Result) then
    begin
      Result := Rect(0, 0, 0, 0);
      Exit;
    end;

    BW := 0;
    if FBrowseButton.Visible then
      BW := FBrowseButton.GetWidth;

    if Btn = FBrowseButton then
    begin
      if FButton.Align = taLeftJustify then
        Result.Right := Result.Left + BW
      else
        Result.Left := Result.Right - BW;
    end else
    begin
      if (BW > 0) and FBrowseButton.Visible then
      begin
        if FBrowseButton.Align = taLeftJustify then
          Inc(Result.Left, BW)
        else
          Dec(Result.Right, BW);
      end;

      W := FButton.GetWidth;
      if FButton.Align = taLeftJustify then
        Result.Right := Result.Left + W
      else
        Result.Left := Result.Right - W;
    end;

    if FButtonInsideFrame and not IsRectEmpty(Result) then
    begin
      I := 0;
      if FStyle in [scesSingle, scesNew, scesExtreme,
        scesWinXP, scesDoubleNew] then
        I := 1
      else
      if FStyle in [scesOfficeXP, scesOffice12, scesOffice2003] then
        I := 2;

      InflateRect(Result, 0, I);
      if FButton.Align = taLeftJustify then
        OffsetRect(Result, -I, 0)
      else
        OffsetRect(Result, I, 0);
    end;
  end;
end;

procedure TSCCustomButtonEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (FButtonClickKey <> scNone) and
    (scShortCut(Key, Shift) = FButtonClickKey) then
  begin
    Key := 0;
    scKillMessage(Handle, WM_CHAR);
    DoButtonClick(FButton);

    Exit;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomButtonEdit.SetBrowseButton(Value: TSCBrowseButton);
begin
  FBrowseButton.Assign(Value);
end;

procedure TSCCustomButtonEdit.SetButton(Value: TSCEditButton);
begin
  FButton.Assign(Value);
end;

{ TSCStyledEditButton }

constructor TSCStyledEditButton.Create(AOwner: TSCCustomButtonFrame);
begin
  inherited Create(AOwner);
  FStyle := scebBrowse;
end;

{ TSCButtonEdit }

function TSCButtonEdit.GetButtonClass: TSCEditButtonClass;
begin
  Result := TSCStyledEditButton;
end;

procedure TSCButtonEdit.UpdateBorderRect(var R: TRect);
var
  W, RI, LI: Integer;
begin
  inherited UpdateBorderRect(R);

  RI := 0;
  LI := 0;

  if (FBrowseButton <> nil) and
    FBrowseButton.Visible and (FBrowseButton.Width <> 0) then
  begin
    W := FBrowseButton.GetWidth;
    if FBrowseButton.Align = taLeftJustify then
      Inc(LI, W)
    else Inc(RI, W);
  end;

  if (FButton <> nil) and
    FButton.Visible and (FButton.Width <> 0) then
  begin
    W := FButton.GetWidth;
    if FButton.Align = taLeftJustify then
      Inc(LI, W)
    else Inc(RI, W);
  end;

  Inc(R.Left,  LI);
  Inc(R.Right, RI);
end;

{ TSCDropDownButton }

constructor TSCDropDownButton.Create(AOwner: TSCCustomButtonFrame);
begin
  inherited Create(AOwner);
  FStyle := scebDropDown;
end;

{ TSCCustomDropDown }

procedure TSCCustomDropDown.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDropDown then
  begin
    with TSCCustomDropDown(Source) do
    begin
      Self.BrowseButtonVisible := BrowseButtonVisible;
      Self.ButtonArrowColor := ButtonArrowColor;
      Self.ButtonColor := ButtonColor;
      Self.ButtonImage := ButtonImage;
      Self.ButtonStyle := ButtonStyle;
      Self.ButtonVisible := ButtonVisible;
      Self.ButtonWidth := ButtonWidth;
      Self.DropDownKey := DropDownKey;
      Self.DroppedDown := DroppedDown;
      Self.IsDropDown := IsDropDown;
      Self.SendChildrenStyle := SendChildrenStyle;
    end;
  end;
end;

procedure TSCCustomDropDown.CloseUp;
var
  H, DropHandle: HWND;
begin
  if DroppedDownSet then
  begin
    if not CanCloseUp then
      Exit;

    FDropState := sccsClosing;
    try
      H := GetCapture;
      if H <> 0 then
        SendMessage(H, WM_CANCELMODE, 0, 0);

      DropHandle := GetDropDownHandle;
      if DropHandle <> 0 then
      begin
        FocusNeeded;
        SetWindowPos(DropHandle, 0, 0, 0, 0, 0, SWP_NOZORDER or
          SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
      end;

      FDroppedDown := False;
    finally
      FDropState := sccsDefault;
      Invalidate;

      AfterCloseUp;
      DoCloseUp;
    end;
  end;
end;

constructor TSCCustomDropDown.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  HideSelection := True;

  FCloseKey := 0;
  FDropDownKey := scNone;
  FSendChildrenStyle := True;
  FDropState := sccsDefault;
end;

destructor TSCCustomDropDown.Destroy;
begin
  CloseUp;
  inherited Destroy;
end;

procedure TSCCustomDropDown.DropDownPopupbox;
var
  R: TRect;
  DropHandle: HWND;
begin
  if not (FInternalDropdown and Self.Enabled and AllowDropdown) then
    Exit;

  PrepareDropWindow;
  BeforeDropDown;

  Windows.SetFocus(Handle);
  if GetFocus <> Handle then
    Exit;

  DropHandle := GetDropDownHandle;
  if DropHandle <> 0 then
  begin
    FInternalDropdown := False;

    if not CanDropDown then
      Exit;

    FDropState := sccsDropping;
    try
      DoDropDown;

      GetWindowRect(DropHandle, R);
      SetWindowPos(DropHandle, HWND_TOP, R.Left, R.Top, 0, 0,
        SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);

      FDroppedDown := True;
      FDropState := sccsDropped;
    finally
      Invalidate;
      AfterDropDown;
    end;
  end;
end;

procedure TSCCustomDropDown.DropDown;
begin
  PostMessage(Handle, CM_SCDROPDOWNPOPUP, 0, 0);
end;

function TSCCustomDropDown.GetButtonArrowColor: TColor;
begin
  Result := clBtnText;
  if FButton <> nil then
    Result := FButton.ArrowColor;
end;

function TSCCustomDropDown.GetButtonColor: TColor;
begin
  Result := clBtnFace;
  if FButton <> nil then
    Result := FButton.Color;
end;

procedure TSCCustomDropDown.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  CR, R: TRect;
  InDrop, InDropBtn, InBrowseBtn: Boolean;
begin
  FButton.ButtonDown := False;
  FButton.ButtonHot  := False;

  try
    InDrop := GetDroppedDown;
    if InDrop then
    begin
      FInMouseClose := True;
      CloseUp;
    end;

    InDropBtn := False;
    InBrowseBtn := False;

    if Button = mbLeft then
    begin
      R := GetButtonRect(FButton);
      InDropBtn := not IsRectEmpty(R) and PtInRect(R, Point(X, Y));

      if not InDropBtn then
      begin
        R := GetButtonRect(FBrowseButton);
        InBrowseBtn := not IsRectEmpty(R) and PtInRect(R, Point(X, Y));
      end;  
    end;

    inherited MouseDown(Button, Shift, X, Y);

    if not Focused then
      Exit;

    if (Button = mbLeft) and not (InDropBtn or InBrowseBtn) and
      GetIsDropDown and not InDrop then
    begin
      CR := GetClientRect;
      InflateRect(CR, -2, -2);

      if PtInRect(CR, Point(X, Y)) then
      begin
        FButton.ButtonDown := True;
        FButton.ButtonHot  := True;

        Invalidate;
        DoButtonClick(FButton);
      end;
    end;
  finally
    FInMouseClose := False;
  end;
end;

function TSCCustomDropDown.DoWantKeyDown(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := False;
end;

procedure TSCCustomDropDown.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if not FSendChildrenStyle then
    if ((Key in [VK_UP, VK_DOWN]) and (ssAlt in Shift)) or
      ((Key = VK_F4) and not (ssAlt in Shift))then
    begin
      Key := 0;
      if GetDroppedDown then
        CloseUp(True)
      else DropDown;
    end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDropDown.SetButtonArrowColor(Value: TColor);
begin
  if FButton <> nil then
    FButton.ArrowColor := Value;
  if FBrowseButton <> nil then
    FBrowseButton.ArrowColor := Value;
end;

procedure TSCCustomDropDown.SetButtonColor(Value: TColor);
begin
  if FButton <> nil then
    FButton.Color := Value;
  if FBrowseButton <> nil then
    FBrowseButton.Color := Value;
end;

procedure TSCCustomDropDown.UpdateBorderRect(var R: TRect);
begin
  inherited UpdateBorderRect(R);

  if GetBrowseButtonVisible then
  begin
    if FBrowseButton <> nil then
      Inc(R.Right, FBrowseButton.GetWidth)
    else
      Inc(R.Right, GetSystemMetrics(SM_CXVSCROLL));

    Inc(R.Right);
  end;

  if GetButtonVisible then
  begin
    if FButton <> nil then
      Inc(R.Right, FButton.GetWidth)
    else
      Inc(R.Right, GetSystemMetrics(SM_CXVSCROLL));

    Inc(R.Right);
  end;    
end;

procedure TSCCustomDropDown.AfterCloseUp;
begin
  //
end;

procedure TSCCustomDropDown.BeforeDropDown;
begin
  //
end;

procedure TSCCustomDropDown.AfterDropDown;
begin
  //
end;

function TSCCustomDropDown.GetDropDownWindow: TWinControl;
begin
  Result := nil;
end;

function TSCCustomDropDown.GetDroppedDown: Boolean;
begin
  Result := DroppedDownSet and (DropDownWindow <> nil) and
    DropDownWindow.HandleAllocated and IsWindowVisible(DropDownWindow.Handle);
end;

procedure TSCCustomDropDown.SetDroppedDown(Value: Boolean);
var
  WasDropped: Boolean;
begin
  WasDropped := GetDroppedDown;
  if not Value and WasDropped then
    CloseUp
  else
  if Value and not WasDropped then
    DropDown;
end;

function TSCCustomDropDown.GetDropDownHandle: HWND;
begin
  Result := 0;
  if (DropDownWindow <> nil) and
    (DropDownWindow.Parent <> nil) and
    not (csDestroying in DropDownWindow.ComponentState) then
    Result := DropDownWindow.Handle;
end;

procedure TSCCustomDropDown.WMKillFocus(var Message: TMessage);
begin
  inherited;
  if GetDroppedDown then
    CloseUp;
end;

procedure TSCCustomDropDown.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if GetDroppedDown then
  begin
    CloseUp;
    Exit;
  end;

  inherited;
end;

procedure TSCCustomDropDown.CMCancelMode(var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and
    (Message.Sender <> DropDownWindow) and GetDroppedDown then
    CloseUp;
end;

procedure TSCCustomDropDown.CMDropDownPopup(var Message: TMessage);
begin
  if not (FInternalDropdown or GetDroppedDown) and AllowDropdown then
  begin
    FDropState := sccsDropping;

    FInternalDropdown := true;
    try
      DropDownPopupbox;
    finally
      FInternalDropdown := false;
    end;
  end;
end;

procedure TSCCustomDropDown.CalcPosition(APopupControl: TWinControl);
var
  R: TRect;
  P: TPoint;
  W, H: Integer;
begin
  if APopupControl <> nil then
  begin
    GetWindowRect(Handle, R);

    with R do
    begin
      W := APopupControl.Width;
      H := APopupControl.Height;
      P := Point(Left, Bottom);

      CheckScreenPosition(P, W, H, Bottom - Top);
    end;

    with APopupControl do
      SetBounds(P.X, P.Y, W, H);
  end;    
end;

procedure TSCCustomDropDown.CheckScreenPosition(var P: TPoint; PopupWidth,
  PopupHeight, EditHeight: Integer);
var
  R: TRect;
  I: Integer;
  F: TCustomForm;
  InPoint: TPoint;
  PointFound: Boolean;
  Monitor: TMonitor;
  MonitorHandle: HMONITOR;
begin
  R := Rect(0, 0, Screen.Width, Screen.Height);
  if Screen.MonitorCount > 1 then
  begin
    PointFound := False;
    InPoint := Point(0, 0);

    if HandleAllocated then
    begin
      InPoint := Point(0, 0);
      InPoint := Self.ClientToScreen(InPoint);

      PointFound := True;
    end else
    if Parent <> nil then
    begin
      InPoint := Point(Self.Left, Self.Top);
      InPoint := Parent.ClientToScreen(InPoint);

      PointFound := True;
    end else
    begin
      F := scGetParentForm(Self);
      if F <> nil then
      begin
        InPoint := Point(Self.Left, Self.Top);
        if F.Parent <> nil then
          InPoint := F.Parent.ClientToScreen(InPoint);

        PointFound := True;
      end;
    end;

    if PointFound then
    begin
      MonitorHandle := MonitorFromPoint(InPoint, MONITOR_DEFAULTTONEAREST);

      if MonitorHandle <> 0 then
        for I := 0 to Screen.MonitorCount-1 do
        begin
          Monitor := Screen.Monitors[I];

          if Monitor.Handle = MonitorHandle then
          begin
            R := Rect(Monitor.Left, Monitor.Top,
              Monitor.Left + Monitor.Width, Monitor.Top + Monitor.Height);
            Break;  
          end;
        end;
    end;
  end;

  if P.X < R.Left then
    P.X := R.Left;

  if P.X + PopupWidth > R.Right then
    P.X := R.Right - PopupWidth;

  if (P.Y + PopupHeight > R.Bottom) and
    ((R.Bottom - (P.Y + EditHeight)) < (P.Y - R.Top)) then
    P.Y := P.Y - (PopupHeight + EditHeight);

  if P.Y + PopupHeight > R.Bottom then
    P.Y := R.Bottom - PopupHeight;

  if P.X < R.Left then P.X := R.Left;
  if P.Y < R.Top then P.Y := R.Top;
end;

function TSCCustomDropDown.DoDropDownKeys(var Key: Word; Shift: TShiftState): Boolean;
var
  AKey: Word;
begin
  Result := False;
  if (FDropDownKey <> scNone) and (scShortCut(Key, Shift) = FDropDownKey) or
    ((Key = VK_F4) and not (ssAlt in Shift)) or
    ((Key in [VK_UP, VK_DOWN]) and (ssAlt in Shift)) then
  begin
    Result := True;
    Key := 0;

    if DroppedDownSet then
      CloseUp(True)
    else
      DropDown;
  end else
  if (Key in [VK_RETURN, VK_ESCAPE]) and
    DroppedDownSet and not (ssAlt in Shift) then
  begin
    Result := True;

    AKey := Key;
    Key  := 0;

    if AKey = VK_RETURN then
      BeforeEnterKeyClose;

    CloseUp(True);
    if AKey in [VK_ESCAPE, VK_RETURN] then
      scKillMessage(Handle, WM_CHAR);
  end;
end;

function TSCCustomDropDown.DropDownWantKeys(Key: Word; Shift: TShiftState): Boolean;
begin
  Result := False;
end;

procedure TSCCustomDropDown.FocusNeeded;
begin
  if not Focused and CanFocus and HandleAllocated and
    IsWindowVisible(Handle) and Application.Active then
    SetFocus;
end;

procedure TSCCustomDropDown.PrepareDropWindow;
var
  C: TWinControl;
begin
  BeforePrepareDropWindow;

  C := GetDropDownWindow;
  if C is TSCCustomControl then
    ApplyPopupBorder(TSCCustomControl(C));
end;

function TSCCustomDropDown.GetEditCursor: TCursor;
begin
  Result := inherited GetEditCursor;
  if GetIsDropDown or GetDroppedDown then
    Result := crDefault;
end;

function TSCCustomDropDown.CanCloseUp: Boolean;
begin
  Result := True;
end;

function TSCCustomDropDown.CanDropDown: Boolean;
begin
  Result := not IsDesigning;
end;

function TSCCustomDropDown.GetButtonVisible: Boolean;
begin
  Result := True;
  if FButton <> nil then
    Result := FButton.Visible;
end;

procedure TSCCustomDropDown.SetButtonVisible(Value: Boolean);
begin
  if FButton <> nil then
    FButton.Visible := Value;
end;

procedure TSCCustomDropDown.SetIsDropDown(Value: Boolean);
var
  Drop: Boolean;
begin
  if FIsDropDown <> Value then
  begin
    FIsDropDown := Value;

    Drop := GetIsDropDown;

    CanSelect := not Drop;
    UseCaret  := not Drop;
    UseUndo   := not Drop;

    if Drop then
      SetSelRect(Rect(0, 0, 0, 0));

    Invalidate;
  end;
end;

procedure TSCCustomDropDown.PaintLine(C: TCanvas; Index, H,
  TxTop: Integer);
var
  Txt: String;
  PassCh: Char;
  IsDesc, IsFocused: Boolean;
  I, L, Ln, F, ImgW: Integer;
  CR, EdR, R1, R2: TRect;
  AAlignment: TAlignment;
begin
  if (C = nil) or (H = 0) then
    Exit;

  if GetIsDropDown then
  begin
    Txt := GetDropDownText;

    IsDesc := not IsPassword and IsDescription;
    if IsDesc then
      Txt := GetDescriptionText;

    Ln := Length(Txt);

    CR := GetClientRect;
    if not IsRectEmpty(CR) then
    begin
      EdR := GetEditRect;
      R1  := EdR;

      IntersectRect(EdR, EdR, CR);
      
      if not IsRectEmpty(R1) then
      begin
        IsFocused := not Self.IsDesigning and
          Focused and not GetDroppedDown;

        if IsFocused then
          with C do
          begin
            Brush.Style := bsSolid;
            Brush.Color := Self.HighlightColor;

            FillRect(EdR);
          end;

        if TxTop < 0 then
          TxTop := 0;

        OffsetRect(R1, 0, TxTop);

        IntersectRect(R1, R1, CR);
        if IsRectEmpty(R1) then Exit;

        R2 := R1;

        if H < 0 then H := GetLineHeight;
        R1.Bottom := R1.Top + H;

        if IsRectEmpty(R1) then
          Exit;

        C.Font.Assign(Self.Font);
        if IsDesc then
          C.Font.Color := GetDescriptionColor
        else
          C.Font.Color := GetForeColor;
        
        C.Brush.Style := bsClear;

        if IsPassword then
        begin
          PassCh := PasswordChar;
          if PassCh = #0 then PassCh := '*';

          Txt := StringOfChar(PassCh, Ln);
        end;

        F := DT_EDITCONTROL or DT_SINGLELINE or DT_TOP or
          DT_LEFT or DT_NOPREFIX;

        AAlignment := GetAlignment;

        if AAlignment <> taLeftJustify then
        begin
          L := GetLineLeft(0) - 2;
          if L < 0 then L := 0;

          Inc(R1.Left, L);
          if AAlignment = taCenter then
            Dec(R1.Right, L);
        end;

        Inc(R1.Top);
        Inc(R1.Left);

        if (PasswordStyle = scpsImage) and (PasswordImage > -1) then
        begin
          if IsValidImage(PasswordImage) then
          begin
            ImgW := Images.Width;

            for I := 0 to Ln - 1 do
              Images.Draw(C, R1.Left + (I*ImgW), R1.Top, PasswordImage, Self.Enabled);
          end;
        end else
          DrawText(C.Handle, PChar(Txt), Ln, R1, F);

        if IsFocused then
          scDrawFocusRect(C, EdR, Self.HighlightColor);
      end;
    end;

    Exit;
  end;

  inherited PaintLine(C, Index, H, TxTop);
end;

function TSCCustomDropDown.GetButtonImage: TImageIndex;
begin
  Result := -1;
  if FButton <> nil then
    Result := FButton.Image;
end;

procedure TSCCustomDropDown.SetButtonImage(Value: TImageIndex);
begin
  if FButton <> nil then
    FButton.Image := Value;
end;

function TSCCustomDropDown.GetButtonWidth: Integer;
begin
  Result := -1;
  if FButton <> nil then
    Result := FButton.Width;
end;

procedure TSCCustomDropDown.SetButtonWidth(Value: Integer);
begin
  if FButton <> nil then
    FButton.Width := Value;
  if FBrowseButton <> nil then
    FBrowseButton.Width := Value;
end;

function TSCCustomDropDown.GetButtonStyle: TSCEditButtonStyle;
begin
  Result := scebDropDown;
  if FButton <> nil then
    Result := FButton.Style;
end;

procedure TSCCustomDropDown.SetButtonStyle(Value: TSCEditButtonStyle);
begin
  if FButton <> nil then
    FButton.Style := Value;
end;

function TSCCustomDropDown.GetButtonClass: TSCEditButtonClass;
begin
  Result := TSCDropDownButton;
end;

procedure TSCCustomDropDown.DoButtonClick(Btn: TSCEditButton);
begin
  if (Btn = FButton) and not (FInMouseClose or GetDroppedDown) then
    DropDown;

  inherited DoButtonClick(Btn);
end;

procedure TSCCustomDropDown.BeforePrepareDropWindow;
begin
  //
end;

function TSCCustomDropDown.GetIsDropDown: Boolean;
begin
  Result := FIsDropDown;
end;

function TSCCustomDropDown.GetBrowseButtonVisible: Boolean;
begin
  Result := False;
  if FBrowseButton <> nil then
    Result := FBrowseButton.Visible;
end;

procedure TSCCustomDropDown.SetBrowseButtonVisible(Value: Boolean);
begin
  if FBrowseButton <> nil then
    FBrowseButton.Visible := Value;
end;

function TSCCustomDropDown.CanCopy: Boolean;
begin
  Result := not FIsDropDown and inherited CanCopy;
end;

function TSCCustomDropDown.CanCut: Boolean;
begin
  Result := not FIsDropDown and inherited CanCut;
end;

function TSCCustomDropDown.CanPaste: Boolean;
begin
  Result := not FIsDropDown and inherited CanPaste;
end;

function TSCCustomDropDown.HasSelection: Boolean;
begin
  Result := not FIsDropDown and inherited HasSelection;
end;

function TSCCustomDropDown.GetCaretPoint(P: TPoint): TPoint;
begin
  if GetIsDropDown then P := Point(0, 0);
  Result := inherited GetCaretPoint(P);
end;

function TSCCustomDropDown.GetCaretPos: TPoint;
begin
  Result := Point(0, 0);
  if GetIsDropDown then
    Result := inherited GetCaretPos;
end;

function TSCCustomDropDown.GetSelLength: Integer;
begin
  Result := 0;
  if not GetIsDropDown then
    Result := inherited GetSelLength;
end;

function TSCCustomDropDown.GetSelText: String;
begin
  Result := '';
  if not GetIsDropDown then
    Result := inherited GetSelText;
end;

procedure TSCCustomDropDown.SetSelText(const Value: String);
begin
  if not GetIsDropDown then
    inherited SetSelText(Value);
end;

procedure TSCCustomDropDown.EnsureCaretPos(var X, Y: Integer);
begin
  if GetIsDropDown then
  begin
    X := 0; Y := 0;
    Exit;
  end;

  inherited EnsureCaretPos(X, Y);
end;

procedure TSCCustomDropDown.DeleteChar(Prev: Boolean);
begin
  if not GetIsDropDown then
    inherited DeleteChar(Prev);
end;

procedure TSCCustomDropDown.DeleteText(Prev: Boolean);
begin
  if not GetIsDropDown then
    inherited DeleteText(Prev);
end;

procedure TSCCustomDropDown.InsertChar(Ch: Char);
begin
  if not GetIsDropDown then
    inherited InsertChar(Ch);
end;

procedure TSCCustomDropDown.InsertText(AText: String);
begin
  if not GetIsDropDown then
    inherited InsertText(AText);
end;

procedure TSCCustomDropDown.OverwriteChar(Ch: Char);
begin
  if not GetIsDropDown then
    inherited OverwriteChar(Ch);
end;

procedure TSCCustomDropDown.ClearSelection;
begin
  if not GetIsDropDown then
    inherited ClearSelection;
end;

procedure TSCCustomDropDown.SelectAll;
begin
  if not GetIsDropDown then
    inherited SelectAll;
end;

procedure TSCCustomDropDown.SelectWord(CheckDelimeters: Boolean);
begin
  if not GetIsDropDown then
    inherited SelectWord(CheckDelimeters);
end;

procedure TSCCustomDropDown.SetSelRect(R: TRect);
begin
  if GetIsDropDown then
    R := Rect(0, 0, 0, 0);
  inherited SetSelRect(R);
end;

function TSCCustomDropDown.AutoCompleteText: String;
begin
  Result := '';
  if AutoComplete and not GetIsDropDown and (EditMask = '') then
    Result := inherited AutoCompleteText;
end;

procedure TSCCustomDropDown.DoAutoComplete(UpdatePaint: Boolean);
begin
  if not GetIsDropDown and (EditMask = '') then
    inherited DoAutoComplete(UpdatePaint);
end;

procedure TSCCustomDropDown.SetDroppedDownFlag(Value: Boolean);
begin
  FDroppedDown := Value;
end;

function TSCCustomDropDown.GetDroppedDownFlag: Boolean;
begin
  Result := FDroppedDown;
end;

function TSCCustomDropDown.GetForeColor: TColor;
begin
  Result := inherited GetForeColor;

  if Enabled and not Self.IsDesigning and
    GetIsDropDown and Focused and not GetDroppedDown then
    Result := Self.HighlightTextColor;
end;

function TSCCustomDropDown.GetDefaultMenu: TPopupMenu;
begin
  Result := nil;
  if not IsDropDown then
    Result := inherited GetDefaultMenu;
end;

procedure TSCCustomDropDown.BeforeEnterKeyClose;
begin
  //
end;

function TSCCustomDropDown.AllowSelectionDrag: Boolean;
begin
  Result := not (Readonly or IsDropDown or GetDroppedDown);
end;

function TSCCustomDropDown.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCCustomDropButtonProps;
end;

function TSCCustomDropDown.AllowDropdown: Boolean;
begin
  Result := Self.Enabled and not IsDesigning;
end;

procedure TSCCustomDropDown.SetDropState(Value: TSCComboboxDropState);
begin
  FDropState := Value;
end;

procedure TSCCustomDropDown.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if GetDroppedDown then
    Message.Result := Message.Result or DLGC_WANTALLKEYS;
end;

procedure TSCCustomDropDown.CNKeyDown(var Message: TWMKeyDown);
var
  ShiftState: TShiftState;
begin
  if GetDroppedDown and (Message.CharCode = VK_ESCAPE) then
  begin
    ShiftState := KeyDataToShiftState(Message.KeyData);
    if not DoWantKeyDown(Message.CharCode, ShiftState) then
    begin
      FCloseKey := Message.CharCode;

      CloseUp;
      Exit;
    end;  
  end;
  inherited;
end;

procedure TSCCustomDropDown.CBShowDropDown(var Message: TMessage);
begin
  if Message.WParam <> 0 then
  begin
    if GetDroppedDown and AllowDropdown then
      DropDown;
  end else
  if GetDroppedDown then
    CloseUp;
end;

function TSCCustomDropDown.GetMinDropDownWidth: Integer;
begin
  Result := 200;
end;

function TSCCustomDropDown.EditCanModify: Boolean;
begin
  Result := inherited EditCanModify and not GetIsDropDown;
end;

function TSCCustomDropDown.CanBeepForKey(Key: Word;
  Shift: TShiftState): Boolean;
begin
  Result := inherited CanBeepForKey(Key, Shift) and
    not (FCloseKey in [VK_ESCAPE, VK_RETURN]);
end;

procedure TSCCustomDropDown.CNChar(var Message: TWMChar);
begin
  try
    inherited;
  finally
    FCloseKey := 0;
  end;
end;

procedure TSCCustomDropDown.DoCloseUp;
begin
  if Assigned(FOnCloseUp) then
    FOnCloseUp(Self);
end;

procedure TSCCustomDropDown.CloseUp(Accept: Boolean);
begin
  CloseUp;
end;

procedure TSCCustomDropDown.DoDropDown;
begin
  if Assigned(FOnDropDown) then
    FOnDropDown(Self);
end;

function TSCCustomDropDown.GetDropDownText: String;
begin
  Result := Self.Text;
end;

procedure TSCCustomDropDown.ApplyPopupBorder(Control: TSCCustomControl);
var
  Cl: TColor;
  PopupBorderStyle: TSCEditStyle;
begin
  if Control <> nil then
  begin
    PopupBorderStyle := GetPopupStyle;
    if PopupBorderStyle = scesDefault then
      PopupBorderStyle := Self.FStyle;

    with TFakeSCControl(Control) do
    begin
      case PopupBorderStyle of
        scesNone, scesDefault, scesDefaultEx:
        begin
          Cl := clWindowFrame;
          if FFrameColor <> clNone then
            Cl := FFrameColor;

          Border := sccbFlat;
          BorderWidth := 0;
          BorderInner := sccbNone;
          FlatColor := Cl;
        end;
        scesOffice12:
        begin
          Cl := FExUseColor;
          
          if Cl = clNone then
          begin
            Cl := clBtnShadow;
            if FFrameColor <> clNone then
              Cl := FFrameColor;
          end;

          Border := sccbFlat;
          BorderWidth := 0;
          BorderInner := sccbFlat;
          FlatColor := Cl;
          FlatInnerColor := clBtnHighlight;
        end;
        scesOfficeXP, scesOffice2003:
        begin
          Cl := clBtnShadow;
          if FFrameColor <> clNone then
            Cl := FFrameColor;

          Border := sccbFlat;
          BorderWidth := 0;
          BorderInner := sccbFlat;
          FlatColor := Cl;
          FlatInnerColor := clBtnHighlight;
        end;
        scesFlat:
        begin
          Cl := clBtnShadow;
          if FFrameColor <> clNone then
            Cl := FFrameColor;

          Border := sccbFlat;
          BorderWidth := 0;
          BorderInner := sccbFlat;
          FlatColor := Cl;
          FlatInnerColor := Color;
        end;
        scesFlatEx:
        begin
          Border := sccbRaised;
          BorderColor := clBtnFace;
          BorderWidth := 2;
          BorderInner := sccbLowered;
        end;
        scesFlatNew:
        begin
          Cl := clBtnShadow;
          if FFrameColor <> clNone then
            Cl := FFrameColor;

          Border := sccbFlat;
          BorderColor := Cl;
          BorderWidth := 1;
          FlatColor := Cl;

          BorderInner := sccbFlat;
          FlatInnerColor := Color;
        end;
        scesMetal:
        begin
          Cl := clBtnShadow;
          if FFrameColor <> clNone then
            Cl := FFrameColor;

          Border := sccbFlat;
          BorderWidth := 0;
          BorderInner := sccbFlat;
          FlatColor := Cl;
          FlatInnerColor := Color;
        end;
        scesSingle, scesSingleEx:
        begin
          Cl := clBtnShadow;
          if FFrameColor <> clNone then
            Cl := FFrameColor;

          Border := sccbFlat;
          BorderWidth := 0;
          FlatColor := Cl;

          BorderInner := sccbFlat;
          FlatInnerColor := Color;
        end;
        scesNew, scesExtreme:
        begin
          Cl := clBtnShadow;
          if FFrameColor <> clNone then
            Cl := FFrameColor;

          Border := sccbFlat;
          BorderWidth := 0;
          FlatColor := Cl;

          BorderInner := sccbFlat;
          FlatInnerColor := Color;
        end;
        scesDouble:
        begin
          Cl := clBtnShadow;
          if FFrameColor <> clNone then
            Cl := FFrameColor;

          Border := sccbFlat;
          BorderColor := clBtnHighlight;
          BorderWidth := 1;
          FlatColor := Cl;

          BorderInner := sccbFlat;
          FlatInnerColor := Cl;
        end;
        scesDoubleNew:
        begin
          Cl := clBtnShadow;
          if FFrameColor <> clNone then
            Cl := FFrameColor;

          BorderWidth := 0;
          Border := sccbFlat;
          FlatColor := Cl;

          BorderInner := sccbFlat;
          FlatInnerColor := clBtnHighlight;
        end;
        scesRaised:
        begin
          Border := sccbRaised;
          BorderWidth := 0;

          BorderInner := sccbFlat;
          FlatInnerColor := Color;
        end;
        sces3D:
        begin
          Border := sccb3DRaised;
          BorderColor := clBtnFace;
          BorderWidth := 1;
          BorderInner := sccbNone;
        end;
        scesWinXP:
        begin
          Border := sccbFlat;
          BorderWidth := 0;
          FlatColor := FExUseColor;

          BorderInner := sccbFlat;
          FlatInnerColor := Color;
        end;
        else begin
          Cl := clWindowFrame;
          if FFrameColor <> clNone then
            Cl := FFrameColor;

          Border := sccbFlat;
          BorderWidth := 0;
          BorderInner := sccbNone;
          FlatColor := Cl;
        end;
      end;
    end;
  end;  
end;

function TSCCustomDropDown.GetPopupStyle: TSCEditStyle;
begin
  Result := Self.FStyle;
end;

function TSCCustomDropDown.GetDeafultExFocus: Boolean;
begin
  Result := inherited GetDeafultExFocus or GetDroppedDown;
end;

function TSCCustomDropDown.GetDescriptionColor: TColor;
begin
  Result := inherited GetDescriptionColor;
  if IsDropDown and Focused and not GetDroppedDown then
  begin
    Result := Self.Colors.FocusTextColor;
    if Result = clNone then
      Result := clHighlightText;
  end;
end;

function TSCCustomDropDown.IsDescription: Boolean;
begin
  Result := inherited IsDescription or IsDropDownDescription;
end;

function TSCCustomDropDown.IsDropDownDescription: Boolean;
begin
  Result := Enabled and IsDropDown and (Focused or GetDroppedDown) and
    (GetDescriptionText <> '') and ((DescriptionMode = scdmAlways) or
    ((DescriptionMode = scdmWhenEmpty) and (Self.Text = '')));
end;

{ TSCCustomCombobox }

type
  TParentForm = class(TCustomForm);

procedure TSCCustomCombobox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomCombobox then
  begin
    with TSCCustomCombobox(Source) do
    begin
      Self.AllowGrayed := AllowGrayed;
      Self.AutoWidth := AutoWidth;
      Self.CenterImages := CenterImages;
      Self.CheckStyle := CheckStyle;
      Self.ContinuousKeySearch := ContinuousKeySearch;
      Self.DblClickReverts := DblClickReverts;
      Self.DropDownCount := DropDownCount;
      Self.DropOnAutoComplete := DropOnAutoComplete;
      Self.EndEllipsis := EndEllipsis;
      Self.ImmediateDropDown := ImmediateDropDown;
      Self.ImmediateSetText := ImmediateSetText;
      Self.ItemHeight := ItemHeight;
      Self.ItemIndex := ItemIndex;
      Self.Items := Items;
      Self.PopupProps := PopupProps;
      Self.Revertable := Revertable;
      Self.ShowCheckboxes := ShowCheckboxes;
      Self.ShowItemImages := ShowItemImages;
      Self.Values := Values;
    end;
  end;
end;

function TSCCustomCombobox.CanDropDown: Boolean;
begin
  Result := (FListBox <> nil) and not IsDesigning and
    (TSCComboListbox(FListBox).Items.Count > 0);
end;

constructor TSCCustomCombobox.Create(AOwner: TComponent);
{$IFNDEF SC_CBUILDER}
var
  InitDatas: TSCStringDatas;
{$ENDIF}
begin
  inherited Create(AOwner);
  FDropDownCount := 8;

  FScrollbar := TSCComboboxScrollbar.Create(Self, scskVertical);

  FValues := TStringList.Create;
  TStringList(FValues).OnChange := ValuesChanged;

  FDropDownFont := TFont.Create;

  FStoredHeight := -1;
  FStoredWidth  := -1;

  FImmediateSetText := True;
  FInternalItemIndex := -1;
  FCheckStyle := scsfFlat;
  FDropDownColor := clWindow;
  FItemHeight := -1;
  FPopupBorderStyle := scesDefault;
  FShowSizeGrip := True;
  FStatusbarAlignment := taLeftJustify;
  FStatusbarColor := clBtnFace;

  SetCheckboxEnabled(False);

  FItems := TSCComboStrings.Create;
  with TSCComboStrings(FItems) do
  begin
    {$IFDEF SC_CBUILDER}
    InitialDatas[7] := -1;
    {$ELSE}
    InitDatas := InitialDatas;

    InitDatas[7] := -1;
    InitialDatas := InitDatas;
    {$ENDIF}

    OnChange := ItemsChanged;
    OnEndUpdate := ItemsChanged;
  end;

  // CreatePopupListbox;
  FPopupProps := GetPopupPropsClass.Create(Self);
end;

destructor TSCCustomCombobox.Destroy;
begin
  FreeAndNil(FDropDownFont);

  with TSCComboStrings(FItems) do
  begin
    OnEndUpdate := nil;
    OnChange := nil;
  end;
  FreeAndNil(FItems);

  TStringList(FValues).OnChange := nil;
  FreeAndNil(FValues);

  DestroyPopupListbox;

  FreeAndNil(FScrollbar);
  FreeAndNil(FPopupProps);
  inherited Destroy;
end;

function TSCCustomCombobox.DoWantKeyDown(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := (Key in [VK_HOME, VK_END, VK_LEFT, VK_RIGHT]) or
    ((Key in [VK_UP, VK_DOWN]) and (ListBox = nil) or not DroppedDown) or
    ((Shift = [ssShift, ssCtrl]) and (Key in [Ord('z'), Ord('Z')])) or
    ((Shift = [ssCtrl]) and (Key in [Ord('c'), Ord('C'),
      Ord('v'), Ord('V'), Ord('x'), Ord('X'), Ord('z'), Ord('Z')]));
end;

procedure TSCCustomCombobox.DoInternalChange;
var
  OldIndex: Integer;
begin
  if not FSettingText then
  begin
    OldIndex := FInternalItemIndex;
    FInternalItemIndex := -1;

    if (FListBox <> nil) and DroppedDown then
    begin
      with TSCComboListbox(FListBox) do
      begin
        FInternalItemIndex := IndexOfItem(Self.Text);
        if (OldIndex > -1) and (OldIndex < Items.Count) and
          (AnsiCompareStr(Items[OldIndex], Self.Text) = 0) then
          FInternalItemIndex := OldIndex;

        if AutoComplete then
        begin
          ItemIndex := FInternalItemIndex;
          MakeVisible(ItemIndex);

          Invalidate;
        end;
      end;
    end else
    begin
      FInternalItemIndex := IndexOfItem(Self.Text);
      if (OldIndex > -1) and (OldIndex < ItemCount) and
        (AnsiCompareStr(ItemText[OldIndex], Self.Text) = 0) then
        FInternalItemIndex := OldIndex;
    end;

    UpdateCheckState;  
  end;
end;

function TSCCustomCombobox.DropDownWantKeys(Key: Word; Shift: TShiftState): Boolean;
begin
  Result := (DroppedDownSet and (Key in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR])) or
    ((FListBox <> nil) and FIsDropDown and GetDroppedDown and (Key in [VK_LEFT, VK_RIGHT]));
end;

function TSCCustomCombobox.GetChecked(Index: Integer): Boolean;
begin
  Result := False;
  if (FListBox <> nil) and GetDroppedDown then
    Result := TSCComboListbox(FListBox).Checked[Index]
  else
  if (Index > -1) and (Index < FItems.Count) then
    Result := TSCComboStrings(FItems).Data[Index, 4] = 1;
end;

procedure TSCCustomCombobox.GetChildren(Proc: TGetChildProc;
  Root: TComponent);
begin
end;

function TSCCustomCombobox.GetDropDownWindow: TWinControl;
begin
  Result := FListBox;
end;

function TSCCustomCombobox.GetDroppedDown: Boolean;
begin
  Result := inherited GetDroppedDown and (FListbox <> nil) and
    (FListbox.Focused or FSendChildrenStyle);
end;

function TSCCustomCombobox.GetItemEnabled(Index: Integer): Boolean;
begin
  Result := True;
  if (FListBox <> nil) and GetDroppedDown then
    Result := TSCComboListbox(FListBox).ItemEnabled[Index]
  else
  if (Index > -1) and (Index < FItems.Count) then
    Result := TSCComboStrings(FItems).Data[Index, 5] = 0;
end;

function TSCCustomCombobox.GetItemIndex: Integer;
begin
  Result := FInternalItemIndex;
end;

function TSCCustomCombobox.GetItems: TStrings;
begin
  Result := FItems;
  if (FListbox <> nil) and GetDroppedDown then
    Result := TSCComboListbox(FListbox).Items;
end;

function TSCCustomCombobox.GetItemText(Index: Integer): String;
begin
  Result := '';
  if (Index > -1) and (Index < ItemCount) then
    Result := Items[Index];
end;

procedure TSCCustomCombobox.ItemsChanged(Sender: TObject);
begin
  if (FListbox <> nil) and GetDroppedDown and
    not TSCComboListbox(FListbox).InItemUpdate then
  begin
    TSCComboListbox(FListbox).Items.Assign(FItems);
    UpdateCheckState;
  end;
end;

procedure TSCCustomCombobox.ListDrawItem(Control: TWinControl;
  C: TCanvas; Index: Integer; Rect: TRect; State: TSCSimpleListState;
  UserData: Integer; var Done: Boolean);
begin
  DoDrawItem(Control, C, Index, Rect, State, UserData, Done);
  if Assigned(FOnDrawItem) then
    FOnDrawItem(Control, C, Index, Rect, State, UserData, Done);
end;

procedure TSCCustomCombobox.ListMeasureItem(Control: TWinControl;
  Index: Integer; var AWidth, AHeight, AIndent: Integer);
begin
  DoMeasureItem(Control, Index, AWidth, AHeight, AIndent);
  if Assigned(FOnMeasureItem) then
    FOnMeasureItem(Control, Index, AWidth, AHeight, AIndent);
end;

procedure TSCCustomCombobox.ListClickCheck(Control: TWinControl; Index: Integer);
begin
  if Control <> nil then Control.Invalidate;
  if FInternalItemIndex = Index then
    UpdateCheckState;
end;

procedure TSCCustomCombobox.ListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  OldIndex, Ind, Index, L, R: Integer;
begin
  if (Button = mbLeft) and (FListbox <> nil) and
    PtInRect(FListbox.ClientRect, Point(X, Y)) then
  begin
    Index := FListbox.ItemAtPos(X, Y, True);

    OldIndex := FInternalItemIndex;

    if Index = -1 then
      FInternalItemIndex := Index
    else begin
      with TSCComboListbox(FListbox) do
      begin
        L := 0; R := 0;
        if ShowCheckboxes then
          R := GetCheckWidth;

        if (Columns < 1) and (Indent > 0) then
        begin
          Ind := Indent*IndentLevel[Index];
          if Ind < 0 then Ind := 0;

          Dec(Ind, HorizontalPos);

          Inc(L, Ind);
          Inc(R, Ind);
        end;

        if (X > L) and (X < R) then
          Exit;
      end;

      if Index <> OldIndex then
        DoItemChanging(Index);

      if not ReadOnly then
      begin
        FSettingText := True;
        try
          FInternalItemIndex := Index;

          SetText(TSCComboListbox(FListbox).Items[FInternalItemIndex]);
          SelectAll;

          ClearUndo;
        finally
          FSettingText := False;
        end;

        FListClickType := sclcMouse;
        try
          DoListClick(FInternalItemIndex, Text);
        finally
          FListClickType := sclcDefault;
        end;
      end;
    end;

    CloseUp;
    UpdateCheckState;
  end;
end;

procedure TSCCustomCombobox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  R: TRect;
  Index: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if (Button = mbLeft) and FDblClickReverts and
    (ssDouble in Shift) and not GetIsDropDown and Focused then
  begin
    R := GetEditRect;
    if IsRectEmpty(R) or not PtInRect(R, Point(X, Y)) then
      Exit;
      
    Inc(FInternalItemIndex);

    if FInternalItemIndex < -1 then
      FInternalItemIndex := -1;

    if FInternalItemIndex < 0 then
      FInternalItemIndex := Items.Count-1
    else
    if FInternalItemIndex > Items.Count-1 then
      FInternalItemIndex := 0;

    if FInternalItemIndex > Items.Count-1 then
      FInternalItemIndex := Items.Count-1;

    if (FInternalItemIndex > -1) and (FInternalItemIndex < Items.Count) then
    begin
      Index := FInternalItemIndex;

      Self.SetText(ItemText[Index]);
      Self.SelectAll;

      ClearUndo;

      FListClickType := sclcMouse;
      try
        DoListClick(Index, Self.Text);
      finally
        FListClickType := sclcDefault;
      end;
    end;

    UpdateCheckState;
  end;
end;

procedure TSCCustomCombobox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ListPos: TPoint;
  MousePos: TSmallPoint;
begin
  if DroppedDownSet and (FListbox <> nil) then
  begin
    ListPos := FListbox.ScreenToClient(ClientToScreen(Point(X, Y)));

    if PtInRect(FListbox.ClientRect, ListPos) then
    begin
      StopTracking;
      MousePos := PointToSmallPoint(ListPos);

      SendMessage(FListbox.Handle, WM_LBUTTONDOWN, 0, Integer(MousePos));
      Exit;
    end;
  end;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomCombobox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FListBox) then
    FListBox := nil;
end;

function TSCCustomCombobox.GetListboxClass: TSCSimpleListboxClass;
begin
  Result := TSCDropDownListbox;
end;

procedure TSCCustomCombobox.PrepareDropWindow;
var
  W, H, CW, CH, SW: Integer;
begin
  BeforePrepareDropWindow;
  CreatePopupListbox;

  with TSCComboListbox(FListbox) do
  begin
    Dropping := True;

    Parent := Self;
    Font   := Self.DropDownFont;

    ScrollbarVertical := True;
    ScrollbarHorizontal := False;

    ScrollbarVert := Self.FScrollbar;
    ScrollbarHeight := Self.FScrollbar.Width;
    ScrollbarExtraButton := Self.FScrollbar.ExtraButton;

    ApplyPopupBorder(TSCComboListbox(FListbox));

    Items.BeginUpdate;
    try
      Sorted         := False;
      AllowEdit      := False;
      AllowGrayed    := Self.FAllowGrayed;
      CenterImages   := Self.FCenterImages;
      ShowCheckboxes := Self.FShowCheckboxes;
      Flat           := Self.FCheckStyle;
      Color          := Self.FDropDownColor;
      EndEllipsis    := Self.FEndEllipsis;
      Images         := Self.Images;
      Indent         := Self.Indent;
      ShowSizeGrip   := Self.ShowSizeGrip;
      ShowItemImages := Self.FShowItemImages;
      ShowStatusbar  := Self.FShowStatusbar;
      StatusbarText  := Self.FStatusbarText;
      StatusbarAlignment := Self.StatusbarAlignment;
      StatusbarColor := Self.FStatusbarColor;
      Revertable     := Self.Revertable;

      Office12Style := False;
      if Self.Style = scesOffice12 then
        Office12Style := True;

      with Constraints do
      begin
        MinHeight := Self.FMinPopupHeight;
        MinWidth  := Self.FMinPopupWidth;
        MaxHeight := Self.FMaxPopupHeight;
        MaxWidth  := Self.FMaxPopupWidth;
      end;

      AssignItemsToList;
      BeforePrepareDropWindow;

      if (FStoredHeight <> -1) or (FStoredWidth <> -1) then
      begin
        if FStoredHeight > -1 then
          Height := FStoredHeight;

        if FStoredWidth > -1 then
          Width := FStoredWidth;
      end else
      begin
        ItemHeight := Self.FItemHeight;
        H := GetDropDownHeight;

        if H < 0 then H := 0;
        ClientHeight := H;
        
        if not Self.FAutoWidth then
        begin
          W := Self.Width;
          if W < Self.FMinPopupWidth then
            W := Self.FMinPopupWidth;

          Width  := W;
        end else
        begin
          UpdateBounds(W, H);

          W := GetMaxWidth;
          if CanShowVertScrollBar then
            Inc(W, GetSystemMetrics(SM_CXVSCROLL));

          if ShowCheckboxes then
            Inc(W, GetCheckWidth);

          if W < Self.Width then
          begin
            SW := Self.Width;
            CW := ClientWidth;

            if CW < Width then
            begin
              Dec(SW, Width - CW);
              if SW < W then
                SW := W;
            end;

            W := SW;
          end;

          if Self.FMinPopupWidth > 0 then
          begin
            CW := Self.Width - ClientWidth;
            if CW < 0 then CW := 0;

            if W < Self.FMinPopupWidth - CW then
              W := Self.FMinPopupWidth - CW;
          end;

          ClientWidth  := W;
        end;
      end;

      FStartHeight := Height;
      FStartWidth  := Width;

      HighlightColor     := Self.HighlightColor;
      HighlightTextColor := Self.HighlightTextColor;

      if (FInternalItemIndex = -1) or (FInternalItemIndex > Items.Count-1) then
        FInternalItemIndex := IndexOfItem(Self.Text);

      ItemIndex := FInternalItemIndex;

      TopIndex  := FInternalItemIndex;

      if FInternalItemIndex > -1 then
        MakeVisible(FInternalItemIndex);

      HorizontalPos := 0;

      ScrollbarVertical := True;
      ScrollbarHorizontal := False;

      ScrollButtonsLayout := Self.FScrollbar.ButtonsLayout;
      ScrollbarStyle := Self.FScrollbar.Style;
      ScrollbarThumbLines := Self.FScrollbar.ThumbLines;
    finally
      Items.EndUpdate;
    end;

    H := ClientHeight;

    if Self.FMinPopupHeight > 0 then
    begin
      CH := Height - ClientHeight;
      if CH < 0 then CH := 0;

      if H < Self.FMinPopupHeight - CH then
        H := Self.FMinPopupHeight - CH;
    end;

    if Self.FMaxPopupHeight > 0 then
    begin
      CH := Height - ClientHeight;
      if CH < 0 then CH := 0;

      if H > Self.FMaxPopupHeight - CH then
        H := Self.FMaxPopupHeight - CH;
    end;

    W := ClientWidth;
    
    if Self.FMinPopupWidth > 0 then
    begin
      CW := Width - ClientWidth;
      if CW < 0 then CW := 0;

      if W < Self.FMinPopupWidth - CW then
        W := Self.FMinPopupWidth - CW;
    end;

    if Self.FMaxPopupWidth > 0 then
    begin
      CW := Width - ClientWidth;
      if CW < 0 then CW := 0;

      if W > Self.FMaxPopupWidth - CW then
        W := Self.FMaxPopupWidth - CW;
    end;

    ClientWidth  := W;
    ClientHeight := H;
  end;

  CalcPosition(FListbox);
end;

procedure TSCCustomCombobox.AfterDropDown;
begin
  if FListbox <> nil then
    TSCComboListbox(FListbox).Dropping := False;
end;

procedure TSCCustomCombobox.AfterCloseUp;
var
  ListChange: TNotifyEvent;
begin
  if FListbox <> nil then
  begin
    if FListbox is TSCDropDownListbox then
      TSCDropDownListbox(FListbox).FDroppedDown := False;

    with FListbox do
    begin
      if FStartHeight <> Height then
        FStoredHeight := Height;

      if FStartWidth <> Width then
        FStoredWidth  := Width;
    end;

    AssignItemsFromList;

    with TSCComboListbox(FListbox) do
    begin
      ListChange := TSCComboStrings(Items).OnChange;
      TSCComboStrings(Items).OnChange := nil;

      try
        TopIndex := 0;
        Items.Clear;
      finally
        TSCComboStrings(Items).OnChange := ListChange;
      end;
    end;

    DestroyPopupListbox;
  end;
end;

procedure TSCCustomCombobox.SetAllowGrayed(Value: Boolean);
begin
  if FAllowGrayed <> Value then
  begin
    FAllowGrayed := Value;
    SetCheckboxAllowGrayed(Value);

    if (FListBox <> nil) and GetDroppedDown then
      TSCComboListbox(FListBox).AllowGrayed := Value;
  end;
end;

procedure TSCCustomCombobox.SetChecked(Index: Integer; Value: Boolean);
begin
  if (FListBox <> nil) and GetDroppedDown then
    TSCComboListbox(FListBox).Checked[Index] := Value
  else
  if (Index > -1) and (Index < FItems.Count) then
  begin
    if Value then
      TSCComboStrings(FItems).Data[Index, 4] := 1
    else
      TSCComboStrings(FItems).Data[Index, 4] := 0;
  end;
end;

procedure TSCCustomCombobox.SetCheckStyle(Value: TSCSimpleCheckFlat);
begin
  if FCheckStyle <> Value then
  begin
    FCheckStyle := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCComboListbox(FListBox).Flat := Value;
  end;
end;

procedure TSCCustomCombobox.SetDropDownColor(Value: TColor);
begin
  if FDropDownColor <> Value then
  begin
    FDropDownColor := Value;
    if (FListBox <> nil) and GetDroppedDown then
      FListBox.Color := Value;
  end;
end;

procedure TSCCustomCombobox.SetDropDownCount(Value: Integer);
begin
  if Value < 1 then
    Value := 1;
  if Value > 100 then
    Value := 100;

  FDropDownCount := Value;
end;

procedure TSCCustomCombobox.SetDropDownFont(Value: TFont);
begin
  FDropDownFont.Assign(Value);
end;

procedure TSCCustomCombobox.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCComboListbox(FListBox).EndEllipsis := Value;
  end;
end;

procedure TSCCustomCombobox.SetItemEnabled(Index: Integer; Value: Boolean);
begin
  if (FListBox <> nil) and GetDroppedDown then
    TSCComboListbox(FListBox).ItemEnabled[Index] := Value
  else
  if (Index > -1) and (Index < FItems.Count) then
  begin
    if Value then
      TSCComboStrings(FItems).Data[Index, 5] := 1
    else
      TSCComboStrings(FItems).Data[Index, 5] := 0;
  end;
end;

procedure TSCCustomCombobox.SetItemIndex(Value: Integer);
var
  Cnt: Integer;
begin
  if Value < -1 then Value := -1;

  Cnt := ItemCount;
  if Value > Cnt - 1 then
    Value := Cnt - 1;

  if FInternalItemIndex <> Value then
  begin
    DoItemChanging(Value);

    FInternalItemIndex := Value;
    if not IsDesigning then
    begin
      SetText(ItemText[Value]);
      ClearUndo;
    end;

    if (FListBox <> nil) and GetDroppedDown then
      with TSCComboListbox(FListBox) do
      begin
        ItemIndex := Value;
        MakeVisible(ItemIndex);
      end;

    UpdateCheckState;  
  end;
end;

procedure TSCCustomCombobox.SetItems(Value: TStrings);
begin
  if (FListbox <> nil) and GetDroppedDown then
    TSCComboListbox(FListbox).Items.Assign(Value)
  else
    FItems.Assign(Value);
end;

procedure TSCCustomCombobox.SetShowCheckboxes(Value: Boolean);
begin
  if FShowCheckboxes <> Value then
  begin
    FShowCheckboxes := Value;
    if not IsLoading then
      SetCheckboxVisible(Value);

    if (FListBox <> nil) and GetDroppedDown then
      TSCComboListbox(FListBox).ShowCheckboxes := Value;
  end;
end;

procedure TSCCustomCombobox.WMMouseWheel(var Message: TWMMouseWheel);
var
  DropHandle: HWND;
  OldIndex, Index, Cnt: Integer;
begin
  if GetDroppedDown then
  begin
    DropHandle := GetDropDownHandle;
    if DropHandle <> 0 then
    begin
      if Message.WheelDelta < 0 then
        SendMessage(DropHandle, WM_VSCROLL, SB_LINEDOWN, 0)
      else
        SendMessage(DropHandle, WM_VSCROLL, SB_LINEUP, 0);

       Exit;
     end;
   end else
   begin
     FSettingText := True;
     try
       OldIndex := FInternalItemIndex;

       Cnt := ItemCount;
       if FInternalItemIndex = -1 then
         FInternalItemIndex := IndexOfItem(Self.Text);

       if Message.WheelDelta > 0 then
         Dec(FInternalItemIndex)
       else
         Inc(FInternalItemIndex);

       if FRevertable then
       begin
         if FInternalItemIndex < 0 then
           FInternalItemIndex := Cnt-1
         else
         if FInternalItemIndex > Cnt-1 then
           FInternalItemIndex := 0;
       end;

       if FInternalItemIndex < 0 then FInternalItemIndex := 0;

       if FInternalItemIndex > Cnt-1 then
         FInternalItemIndex := Cnt-1;

       if FInternalItemIndex > -1 then
       begin
         Index := FInternalItemIndex;

         if OldIndex <> FInternalItemIndex then
           DoItemChanging(Index);

         Self.SetText(ItemText[Index]);
         Self.SelectAll;

         ClearUndo;

         FListClickType := sclcMouse;
         try
           DoListClick(Index, Self.Text);
         finally
           FListClickType := sclcDefault;
         end;
       end;
     finally
       FSettingText := False;
     end;

     UpdateCheckState;

     Exit;
   end;

   inherited;
end;

procedure TSCCustomCombobox.WndProc(var Message: TMessage);
var
  Shift: TShiftState;
  Index1, Index2: Integer;
begin
  case Message.Msg of
    WM_KEYDOWN, WM_SYSKEYDOWN, WM_CHAR:
      if FSendChildrenStyle then
        with TWMKey(Message) do
        begin
          Shift := KeyDataToShiftState(KeyData);
          if Message.Msg <> WM_CHAR then
            DoDropDownKeys(CharCode, Shift);

          if (CharCode <> 0) and DroppedDownSet and
            (FListbox <> nil) and DropDownWantKeys(CharCode, Shift) then
          begin
            Index1 := -1;
            if FImmediateSetText then
              Index1 := TSCComboListbox(FListbox).ItemIndex;

            with TMessage(Message) do
              SendMessage(FListbox.Handle, Msg, WParam, LParam);

            if not FImmediateSetText or ReadOnly then
              Exit;

            Index2 := TSCComboListbox(FListbox).ItemIndex;

            if Index1 <> Index2 then
            begin
              if Index2 = -1 then
                Self.SetText('')
              else begin
                Self.SetText(TSCComboListbox(FListbox).Items[Index2]);
                Self.SelectAll;
              end;

              ClearUndo;

              FListClickType := sclcKey;
              try
                DoListClick(Index2, Text);
              finally
                FListClickType := sclcDefault;
              end;
            end;

            UpdateCheckState;
            Exit;
          end;

          if (Message.Msg = WM_CHAR) or ((Message.Msg = WM_KEYDOWN) and
            (TWMKey(Message).CharCode in [VK_DELETE, VK_BACK]))then
          begin
            inherited;

            if (CharCode <> 0) and DroppedDownSet and (FListbox <> nil) then
              with TSCComboListbox(FListBox) do
              begin
                Index1 := -1;
                if not TSCStringList(Items).Find(Self.Text, Index1, True) then
                  Index1 := -1;

                TopIndex := Index1;
                if AutoComplete or GetIsDropDown then
                  ItemIndex := Index1
                else
                  ItemIndex := -1;

                UpdateCheckState;
              end;
          end else
          if (Message.Msg = WM_KEYDOWN) and
            DoWantKeyDown(TWMKey(Message).CharCode, Shift) then
          begin
            inherited;
            Exit;
          end;

          if not ((Message.Msg = WM_SYSKEYDOWN) and (TWMKey(Message).CharCode = VK_F4)) then
            Exit;
        end;
  end;
  inherited;
end;

function TSCCustomCombobox.GetIndentLevel(Index: Integer): Integer;
begin
  Result := 0;
  if (FListBox <> nil) and GetDroppedDown then
    Result := TSCComboListbox(FListBox).IndentLevel[Index]
  else
  if (Index > -1) and (Index < FItems.Count) then
    Result := TSCComboStrings(FItems).Data[Index, 6];
end;

function TSCCustomCombobox.GetItemImage(Index: Integer): Integer;
begin
  Result := -1;
  if (FListBox <> nil) and GetDroppedDown then
    Result := TSCComboListbox(FListBox).ItemImage[Index]
  else
  if (Index > -1) and (Index < FItems.Count) then
    Result := TSCComboStrings(FItems).Data[Index, 7];
end;

procedure TSCCustomCombobox.ImageListChange(Sender: TObject);
begin
  inherited;

  if (ImageIndex > -1) or ((FListBox <> nil) and GetDroppedDown) then
  begin
    if FListBox <> nil then TSCComboListbox(FListBox).Images := Self.Images;

    if ImageIndex > -1 then
      Invalidate;
  end;
end;

procedure TSCCustomCombobox.IndentChanged;
begin
  if (FListBox <> nil) and GetDroppedDown then
    TSCComboListbox(FListBox).Indent := Self.Indent;
end;

procedure TSCCustomCombobox.SetIndentLevel(Index, Value: Integer);
begin
  if Value < 0 then Value := 0;

  if (FListBox <> nil) and GetDroppedDown then
    TSCComboListbox(FListBox).IndentLevel[Index] := Value
  else
  if (Index > -1) and (Index < FItems.Count) then
    TSCComboStrings(FItems).Data[Index, 6] := Value
end;

procedure TSCCustomCombobox.SetItemImage(Index, Value: Integer);
begin
  if Value < -1 then Value := -1;

  if (FListBox <> nil) and GetDroppedDown then
    TSCComboListbox(FListBox).ItemImage[Index] := Value
  else
  if (Index > -1) and (Index < FItems.Count) then
    TSCComboStrings(FItems).Data[Index, 7] := Value
end;

procedure TSCCustomCombobox.SetShowItemImages(Value: Boolean);
begin
  if FShowItemImages <> Value then
  begin
    FShowItemImages := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCComboListbox(FListBox).ShowItemImages := Value;
  end;
end;

procedure TSCCustomCombobox.BeginItemUpdate;
begin
  if FItems <> nil then
    FItems.BeginUpdate;

  if (FListBox <> nil) and GetDroppedDown then
    TSCComboListbox(FListBox).BeginItemUpdate;
end;

procedure TSCCustomCombobox.EndItemUpdate;
begin
  if FItems <> nil then
    FItems.EndUpdate;

  if (FListBox <> nil) and GetDroppedDown then
    TSCComboListbox(FListBox).EndItemUpdate;
end;

function TSCCustomCombobox.InItemUpdate: Boolean;
begin
  Result := (FItems <> nil) and TSCComboStrings(FItems).InUpdate;
end;

procedure TSCCustomCombobox.SetItemHeight(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FItemHeight <> Value then
  begin
    FItemHeight := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCComboListbox(FListBox).ItemHeight := Value;
  end;
end;

procedure TSCCustomCombobox.SetCenterImages(Value: Boolean);
begin
  if FCenterImages <> Value then
  begin
    FCenterImages := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCComboListbox(FListBox).CenterImages := Value;
  end;
end;

procedure TSCCustomCombobox.DoDrawItem(Control: TWinControl;
  C: TCanvas; Index: Integer; Rect: TRect; State: TSCSimpleListState;
  UserData: Integer; var Done: Boolean);
begin
  //
end;

procedure TSCCustomCombobox.DoMeasureItem(Control: TWinControl;
  Index: Integer; var AWidth, AHeight, AIndent: Integer);
begin
  //
end;

procedure TSCCustomCombobox.DoListClick(Index: Integer; const Item: String);
begin
  //
end;

function TSCCustomCombobox.GetDropDownHeight: Integer;
var
  Cnt: Integer;
begin
  with TSCComboListbox(FListbox) do
  begin
    ItemHeight := Self.FItemHeight;
    Result := GetItemHeight;

    Cnt := FDropDownCount;
    if Cnt > Items.Count then
      Cnt := Items.Count;

    Result := Result*Cnt;
    if Result <= 0 then Result := 16;
  end;  
end;

procedure TSCCustomCombobox.BeforePrepareDropWindow;
begin
  //
end;

function TSCCustomCombobox.AutoCompleteText: String;
var
  Index: Integer;
begin
  if ReadOnly then
  begin
    Result := Self.Text;
    Exit;
  end;

  Result := '';
  if AutoComplete and not GetIsDropDown and (EditMask = '') and (Text <> '') then
  begin
    if (ListBox <> nil) and DroppedDown then
    begin
      with TSCComboListbox(ListBox) do
      begin
        Index := CompletedItem(Self.Text, False);
        if (Index > -1) and (Index < Items.Count) then
          Result := Items[Index];
      end;
    end else
      Result := CompletedText(Self.Text, False);
  end;
end;

procedure TSCCustomCombobox.KeyDown(var Key: Word; Shift: TShiftState);
var
  OldIndex, Cnt, Index: Integer;
begin
  if ((Key in [VK_UP, VK_DOWN]) or ((Key in [VK_LEFT, VK_RIGHT]) and GetIsDropDown)) and
    not (ssAlt in Shift) and ((ListBox = nil) or not DroppedDown and not ReadOnly) then
  begin
    OldIndex := FInternalItemIndex;
    
    if FInternalItemIndex = -1 then
      FInternalItemIndex := IndexOfItem(Self.Text);

    if Key in [VK_DOWN, VK_RIGHT] then
      Inc(FInternalItemIndex)
    else
    if FRevertable or (ItemCount <= 0) or (FInternalItemIndex <> 0) then
      Dec(FInternalItemIndex);

    if FInternalItemIndex < -1 then
      FInternalItemIndex := -1;

    Cnt := ItemCount;

    if FRevertable then
    begin
      if FInternalItemIndex < 0 then
        FInternalItemIndex := Cnt-1
      else
      if FInternalItemIndex > Cnt-1 then
        FInternalItemIndex := 0;
    end;

    if FInternalItemIndex > Cnt-1 then
      FInternalItemIndex := Cnt-1;

    if (FInternalItemIndex > -1) and (FInternalItemIndex < Cnt) then
    begin
      Key := 0;
      scKillMessage(Handle, WM_CHAR);

      Index := FInternalItemIndex;

      if OldIndex <> FInternalItemIndex then
        DoItemChanging(Index);

      Self.SetText(ItemText[Index]);
      Self.SelectAll;

      ClearUndo;

      FListClickType := sclcMouse;
      try
        DoListClick(Index, Self.Text);
      finally
        FListClickType := sclcDefault;
      end;

      UpdateCheckState;

      Exit;
    end else
      UpdateCheckState;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomCombobox.KeyPress(var Key: Char);
var
  S: String;
  Ch, K: Char;
  Inserted: Boolean;
begin
  Ch := Key;
  inherited KeyPress(Key);

  K := Key;
  if not IsValidKey(Ch) then
    Exit;

  if FImmediateDropDown and not DroppedDown and
    (GetIsDropDown or not ReadOnly) then
  begin
    S := UpdateCharCase(Ch);
    if Length(S) <> 1 then
      Exit;

    Inserted := True;
    if not GetIsDropDown and (EditMode = scemInsert) then
      Inserted := (MaxLength = 0) or
        (Length(Text) < MaxLength) or HasSelection;

    if Inserted then
    begin
      Key := #0;
      scKillMessage(Handle, WM_CHAR);
      DoButtonClick(FButton);

      if not IsDropDown then
        Exit;
    end;
  end;

  if IsDropDown then
    ProcessSearchKey(K);
end;

procedure TSCCustomCombobox.SetMaxPopupHeight(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMaxPopupHeight <> Value then
  begin
    FMaxPopupHeight := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCComboListbox(FListBox).Constraints.MaxHeight := Value;
  end;
end;

procedure TSCCustomCombobox.SetMaxPopupWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMaxPopupWidth <> Value then
  begin
    FMaxPopupWidth := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCComboListbox(FListBox).Constraints.MaxWidth := Value;
  end;
end;

procedure TSCCustomCombobox.SetMinPopupHeight(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMinPopupHeight <> Value then
  begin
    FMinPopupHeight := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCComboListbox(FListBox).Constraints.MinHeight := Value;
  end;
end;

procedure TSCCustomCombobox.SetMinPopupWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMinPopupWidth <> Value then
  begin
    FMinPopupWidth := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCComboListbox(FListBox).Constraints.MinWidth := Value;
  end;
end;

procedure TSCCustomCombobox.AssignItemsFromList;
begin
  if FListbox <> nil then
  begin
    TSCComboStrings(FItems).OnChange := nil;
    try
      FItems.Assign(TSCComboListbox(FListbox).Items);
    finally
      TSCComboStrings(FItems).OnChange := ItemsChanged;
    end;
  end;

  UpdateCheckState;
end;

procedure TSCCustomCombobox.AssignItemsToList;
var
  OldUpdate: Boolean;
begin
  with TSCComboListbox(FListbox) do
  begin
    OldUpdate := TSCListStrings(Items).InUpdate;
    if not OldUpdate then
      Items.BeginUpdate;

    try
      Items.Assign(Self.FItems);
    finally
      if not OldUpdate then
        Items.EndUpdate;
    end;
  end;
end;

procedure TSCCustomCombobox.BeforeEnterKeyClose;
var
  Index1: Integer;
begin
  if not FImmediateSetText and DroppedDown and
    (FListBox <> nil) and not ReadOnly then
  begin
    Index1 := TSCComboListbox(FListbox).ItemIndex;
    if Index1 = -1 then
      Exit;

    Self.SetText(TSCComboListbox(FListbox).Items[Index1]);
    Self.SelectAll;

    ClearUndo;

    FListClickType := sclcKey;
    try
      DoListClick(Index1, Text);
    finally
      FListClickType := sclcDefault;
    end;
  end;
end;

procedure TSCCustomCombobox.SetCheckboxAllowGrayed(Value: Boolean);
begin
  Value := AllowGrayed;
  inherited SetCheckboxAllowGrayed(Value);
end;

procedure TSCCustomCombobox.SetCheckboxEnabled(Value: Boolean);
begin
  inherited SetCheckboxEnabled(Value);
end;

procedure TSCCustomCombobox.SetCheckboxVisible(Value: Boolean);
begin
  Value := ShowCheckboxes and Value;
  inherited SetCheckboxVisible(Value);
end;

procedure TSCCustomCombobox.UpdateCheckState;
begin
  if FShowCheckboxes and not ReadOnly and (FUpdatingCheckState = 0) then
  begin
    Inc(FUpdatingCheckState);
    try
      SetCheckboxState(ItemCheckstateForCloseup(FInternalItemIndex));
    finally
      Dec(FUpdatingCheckState);
    end;
  end;
end;

function TSCCustomCombobox.ItemCheckState(Index: Integer): TSCCheckState;
begin
  Result := sccbUnchecked;
  if (FListBox <> nil) and GetDroppedDown then
    Result := TSCComboListbox(FListBox).State[Index]
  else
  if (Index > -1) and (Index < FItems.Count) then
    Result := DataToState(TSCComboStrings(FItems).Data[Index, 4]);
end;

function TSCCustomCombobox.CompletedText(const S: String;
  CaseSensitive: Boolean): String;
var
  Index: Integer;
begin
  Result := S;

  Index := TSCComboStrings(Items).CompletedText(Self.Text, False);
  if (Index > -1) and (Index < Items.Count) then
    Result := Items[Index];
end;

procedure TSCCustomCombobox.DoAutoCompleted;
begin
  if DropOnAutoComplete then
    DropDown;
end;

function TSCCustomCombobox.IndexOfItem(const S: string): Integer;
begin
  Result := -1;
  if not TSCStringList(Items).Find(S, Result, IsDropDown) then
    Result := -1;
end;

function TSCCustomCombobox.ItemCount: Integer;
begin
  Result := Items.Count;
end;

procedure TSCCustomCombobox.SetScrollbar(Value: TSCComboboxScrollbar);
begin
  FScrollbar.Assign(Value);
end;

function TSCCustomCombobox.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCComboboxButtonProps;
end;

function TSCCustomCombobox.GetPopupPropsClass: TSCComboboxPopupPropsClass;
begin
  Result := TSCComboboxPopupProps;
end;

procedure TSCCustomCombobox.SetPopupProps(Value: TSCComboboxCustomPopupProps);
begin
  FPopupProps.Assign(Value);
end;

function TSCCustomCombobox.ItemCheckstateForCloseup(Index: Integer): TSCCheckState;
begin
  Result := ItemCheckState(Index);
end;

procedure TSCCustomCombobox.DoItemChanging(Index: Integer);
begin
  //
end;

procedure TSCCustomCombobox.SetValues(Value: TStrings);
begin
  FValues.Assign(Value);
end;

function TSCCustomCombobox.GetSelectedValue: String;
var
  Index: Integer;
begin
  Result := '';
  Index := ItemIndex;

  if Index > 0 then
  begin
    if Index < FValues.Count then
      Result := FValues[Index]
    else if Index < Items.Count then
      Result := Items[Index];
  end;
end;

procedure TSCCustomCombobox.ValuesChanged(Sender: TObject);
begin
  //
end;

procedure TSCCustomCombobox.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    SortItems;
  end;
end;

procedure TSCCustomCombobox.SortItems;
begin
  TSCStringList(FItems).Sorted := FSorted;
end;

procedure TSCCustomCombobox.SetContinuousKeySearch(Value: Boolean);
begin
  if FContinuousKeySearch <> Value then
  begin
    FContinuousKeySearch := Value;

    FSearchText := '';
    FSearchTickCount := 0;
  end;
end;

function TSCCustomCombobox.FindItem(const S: String; StartPos,
  EndPos: Integer): Integer;
var
  SubStr: String;
  I, J: Integer;
begin
  Result := -1;
  if not InItemUpdate and (Items.Count > 0) then
  begin
    if StartPos < 0 then
      StartPos := 0;

    if EndPos < 0 then
      EndPos := 0;

    if EndPos < StartPos then
    begin
      I := StartPos;
      StartPos := EndPos;
      EndPos := I;
    end;

    if StartPos > Items.Count - 1 then
      StartPos := Items.Count - 1;

    if EndPos > Items.Count - 1 then
      EndPos := Items.Count - 1;

    for I := 1 to Length(S) do
    begin
      SubStr := Copy(S, 1, I);
      for J := StartPos to EndPos do
        if AnsiSameText(SubStr, Copy(Items.Strings[J], 1, I)) then
        begin
          Result := J;
          Break;
        end;
    end;
  end;
end;

procedure TSCCustomCombobox.CreatePopupListbox;
begin
  if FListBox = nil then
  begin
    FListBox := GetListboxClass.Create(Self);

    with TSCComboListbox(FListBox) do
    begin
      Visible := False;

      ControlStyle  := ControlStyle + [csReplicatable];

      OnClickCheck  := ListClickCheck;
      OnDrawItem    := ListDrawItem;
      OnMeasureItem := ListMeasureItem;
      OnMouseUp     := ListMouseUp;
    end;
  end;  
end;

procedure TSCCustomCombobox.DestroyPopupListbox;
begin
  if (FListBox <> nil) and not FListBox.IsDestroying then
  begin
    with TSCComboListbox(FListBox) do
    begin
      OnClickCheck  := nil;
      OnDrawItem    := nil;
      OnMeasureItem := nil;
      OnMouseUp     := nil;
    end;

    FreeAndNil(FListBox);
  end;
end;

procedure TSCCustomCombobox.ProcessSearchKey(Key: Char);
var
  S: String;
  Tick: DWord;
  Index, StartPos: Integer;
begin
  if Key in [#8, #27] then
  begin
    FSearchText := '';
    FSearchTickCount := 0;
  end else
  if Key in [#32..#255] then
  begin
    if not FContinuousKeySearch then
    begin
      FSearchText := '';
      FSearchTickCount := 0;

      S := Key;
      StartPos := ItemIndex + 1;
    end else
    begin
      Tick := GetTickCount;

      S := FSearchText;
      FSearchText := Key;

      if (FSearchTickCount = 0) or (Tick - FSearchTickCount < DWord(scKeyBoardDelay)) then
        FSearchText := S + Key;

      FSearchTickCount := Tick;

      S := FSearchText;
      StartPos := ItemIndex;
    end;

    Index := FindItem(S, StartPos, Items.Count - 1);
    if (Index = -1) and (ItemIndex > -1) then
      Index := FindItem(S, 0, StartPos - 1);

    if Index > -1 then
      SetItemIndex(Index);
  end;
end;

function TSCCustomCombobox.GetPopupStyle: TSCEditStyle;
begin
  Result := FPopupBorderStyle;
end;

function TSCCustomCombobox.AllowDropdown: Boolean;
begin
  Result := inherited AllowDropdown and (ItemCount > 0);
end;

procedure TSCCustomCombobox.DoCheckboxChanged;
begin
  if not Assigned(OnCheckboxChange) and not Readonly and
    FShowCheckboxes and (FUpdatingCheckState = 0) then
  begin
    Inc(FUpdatingCheckState);
    try
      SetItemCheckState(ItemIndex, CheckboxState);
    finally
      Dec(FUpdatingCheckState);
    end;
  end;
end;

procedure TSCCustomCombobox.SetItemCheckState(Index: Integer;
  Value: TSCCheckState);
begin
  if (FListBox <> nil) and GetDroppedDown then
  begin
    if (Index > -1) and (Index < TSCComboListbox(FListBox).Items.Count) then
      TSCComboListbox(FListBox).State[Index] := Value;
  end else
  if (Index > -1) and (Index < FItems.Count) then
    TSCComboStrings(FItems).Data[Index, 4] := StateToData(Value);
end;

procedure TSCCustomCombobox.Loaded;
begin
  inherited Loaded;
  SetCheckboxVisible(FShowCheckboxes);
end;

{ TSCCustomPopupbox }

procedure TSCCustomPopupbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomPopupbox then
  begin
    with TSCCustomPopupbox(Source) do
    begin
      Self.MaxPopupHeight := MaxPopupHeight;
      Self.MaxPopupWidth := MaxPopupWidth;
      Self.MinPopupHeight := MinPopupHeight;
      Self.MinPopupWidth := MinPopupWidth;
      Self.PopupBorderStyle := PopupBorderStyle;
      Self.PopupHeight := PopupHeight;
      Self.PopupWidth := PopupWidth;
      Self.ShowSizeGrip := ShowSizeGrip;
      Self.ShowStatusbar := ShowStatusbar;
      Self.StatusbarColor := StatusbarColor;
      Self.StatusbarText := StatusbarText;
    end;
  end;
end;

function TSCCustomPopupbox.CanDropDown: Boolean;
begin
  Result := Self.Enabled and (FPopupControl <> nil) and
    not IsDesigning and ((FPopupContainer = nil) or
    not TSCPopupControl(FPopupContainer).InPopup);
end;

procedure TSCCustomPopupbox.CloseUp;
begin
  if (FPopupContainer <> nil) and TSCPopupControl(FPopupContainer).InPopup then
    with TSCPopupControl(FPopupContainer) do
    begin
      if FStartHeight <> Height then
        FStoredHeight := ClientHeight;

      if FStartWidth <> Width then
        FStoredWidth  := ClientWidth;

      Cancel;
    end;
end;

constructor TSCCustomPopupbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPopupBorderStyle := scesDefault;
  FPopupHeight  := -1;
  FPopupWidth   := -1;
  FShowSizeGrip := True;
  FStoredHeight := -1;
  FStoredWidth  := -1;
  FStatusbarColor := clBtnFace;
end;

procedure TSCCustomPopupbox.DropDownPopupbox;
begin
  if CanDropDown and AllowDropdown and Self.Enabled then
  begin
    if FPopupContainer = nil then
      FPopupContainer := TSCPopupControl.Create(Self);

    PrepareDropWindow;

    Windows.SetFocus(Handle);
    if GetFocus <> Handle then
      Exit;

    FDropState := sccsDropping;
    FDroppedDown := True;
    try
      FPopupContainer.FreeNotification(Self);
      TSCPopupControl(FPopupContainer).Popup(Self);
    finally
      FDropState := sccsDefault;
      FDroppedDown := False;

      if FPopupContainer <> nil then
      begin
        FPopupContainer.Free;
        FPopupContainer := nil;
      end;
    end;
  end;
end;

function TSCCustomPopupbox.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCDropDownButtonProps;
end;

function TSCCustomPopupbox.GetDropDownWindow: TWinControl;
begin
  Result := FPopupContainer;
end;

function TSCCustomPopupbox.GetDroppedDown: Boolean;
begin
  Result := DroppedDownSet and
   (FPopupContainer <> nil) and TSCPopupControl(FPopupContainer).InPopup;
end;

function TSCCustomPopupbox.GetPopupStyle: TSCEditStyle;
begin
  Result := FPopupBorderStyle;
end;

procedure TSCCustomPopupbox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
  begin
    if AComponent = FPopupContainer then
      FPopupContainer := nil;

    if AComponent = FPopupControl then
      FPopupControl := nil;
  end;
end;

procedure TSCCustomPopupbox.PrepareDropWindow;
var
  B, W, H, CW, CH: Integer;
begin
  if FPopupContainer = nil then
    Exit;

  BeforePrepareDropWindow;

  W := FPopupWidth;
  H := FPopupWidth;

  with FPopupControl do
  begin
    if W <= 0 then W := FPopupControl.Width;
    if FStoredWidth > -1 then W := FStoredWidth;
    
    if (Constraints.MinWidth > 0) and (W < Constraints.MinWidth) then
      W := Constraints.MinWidth;

    if (Constraints.MaxWidth > 0) and (W > Constraints.MaxWidth) then
      W := Constraints.MaxWidth;

    if H <= 0 then H := FPopupControl.Height;
    if FStoredHeight > -1 then H := FStoredHeight;

    if (Constraints.MinHeight > 0) and (H < Constraints.MinHeight) then
      H := Constraints.MinHeight;

    if (Constraints.MaxHeight > 0) and (H > Constraints.MaxHeight) then
      H := Constraints.MaxHeight;
  end;

  with TSCPopupControl(FPopupContainer) do
  begin
    Color := clBtnFace;

    with Constraints do
    begin
      MinHeight := Self.FMinPopupHeight;
      MinWidth  := Self.FMinPopupWidth;
      MaxHeight := Self.FMaxPopupHeight;
      MaxWidth  := Self.FMaxPopupWidth;
    end;

    StatusbarColor := Self.FStatusbarColor;
    ShowSizeGrip   := Self.FShowSizeGrip;
    ShowStatusbar  := Self.FShowStatusbar;
    StatusbarText  := Self.FStatusbarText;

    if ShowStatusbar then
      Inc(H, GetStatusbarHeight);

    ApplyPopupBorder(TSCPopupControl(FPopupContainer));

    B := 2*(GetBorderSize + BorderWidth + GetInnerBorderSize);

    Inc(W, B);
    Inc(H, B);

    Width  := W;
    Height := H;

    H := ClientHeight;

    if Self.FMinPopupHeight > 0 then
    begin
      CH := Height - ClientHeight;
      if CH < 0 then CH := 0;

      if H < Self.FMinPopupHeight - CH then
        H := Self.FMinPopupHeight - CH;
    end;

    if Self.FMaxPopupHeight > 0 then
    begin
      CH := Height - ClientHeight;
      if CH < 0 then CH := 0;

      if H > Self.FMaxPopupHeight - CH then
        H := Self.FMaxPopupHeight - CH;
    end;

    W := ClientWidth;

    if Self.FMinPopupWidth > 0 then
    begin
      CW := Width - ClientWidth;
      if CW < 0 then CW := 0;

      if W < Self.FMinPopupWidth - CW then
        W := Self.FMinPopupWidth - CW;
    end;

    if Self.FMaxPopupWidth > 0 then
    begin
      CW := Width - ClientWidth;
      if CW < 0 then CW := 0;

      if W > Self.FMaxPopupWidth - CW then
        W := Self.FMaxPopupWidth - CW;
    end;

    ClientWidth  := W;
    ClientHeight := H;

    FStartHeight := Height;
    FStartWidth  := Width;
  end;

  CalcPosition(FPopupContainer);
end;

procedure TSCCustomPopupbox.SetMaxPopupHeight(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMaxPopupHeight <> Value then
  begin
    FMaxPopupHeight := Value;
    if (FPopupContainer <> nil) and GetDroppedDown then
      TSCPopupControl(FPopupContainer).Constraints.MaxHeight := Value;
  end;
end;

procedure TSCCustomPopupbox.SetMaxPopupWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMaxPopupWidth <> Value then
  begin
    FMaxPopupWidth := Value;
    if (FPopupContainer <> nil) and GetDroppedDown then
      TSCPopupControl(FPopupContainer).Constraints.MaxWidth := Value;
  end;
end;

procedure TSCCustomPopupbox.SetMinPopupHeight(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMinPopupHeight <> Value then
  begin
    FMinPopupHeight := Value;
    if (FPopupContainer <> nil) and GetDroppedDown then
      TSCPopupControl(FPopupContainer).Constraints.MinHeight := Value;
  end;
end;

procedure TSCCustomPopupbox.SetMinPopupWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMinPopupWidth <> Value then
  begin
    FMinPopupWidth := Value;
    if (FPopupContainer <> nil) and GetDroppedDown then
      TSCPopupControl(FPopupContainer).Constraints.MinWidth := Value;
  end;
end;

procedure TSCCustomPopupbox.SetPopupControl(Value: TControl);
begin
  if FPopupControl <> Value then
  begin
    if (FPopupContainer <> nil) and
      TSCPopupControl(FPopupContainer).InPopup then
      TSCPopupControl(FPopupContainer).Cancel;

    FPopupControl := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;
end;

procedure TSCCustomPopupbox.SetPopupHeight(Value: Integer);
begin
  if Value < -1 then Value := -1;
  FPopupHeight := Value;
end;

procedure TSCCustomPopupbox.SetPopupWidth(Value: Integer);
begin
  if Value < -1 then Value := -1;
  FPopupWidth := Value;
end;

procedure TSCCustomPopupbox.WndProc(var Message: TMessage);
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

{ TSCCustomButtonFrame }

procedure TSCCustomButtonFrame.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomButtonFrame then
  begin
    with TSCCustomButtonFrame(Source) do
    begin
      Self.ButtonProps := ButtonProps;
      Self.ButtonInsideFrame := ButtonInsideFrame;
    end;
  end;
end;

procedure TSCCustomButtonFrame.ButtonChanged(Sender: TObject);
begin
  if (Sender <> nil) and (Sender is TSCEditButton) and
    (TSCEditButton(Sender).FOwner = Self) then
    StyleChanged;
end;

procedure TSCCustomButtonFrame.CaptureChanged(Captured: Boolean);
var
  I: Integer;
  Btn, OldHot, OldDown: TSCEditButton;
begin
  OldHot  := nil;
  OldDown := nil;

  for I := 0 to FButtonList.Count-1 do
  begin
    Btn := FButtonList.Items[I];

    if (OldHot = nil) and Btn.FButtonHot then
      OldHot := Btn;

    if (OldDown = nil) and Btn.FButtonDown then
      OldDown := Btn;

    with Btn do
    begin
      FButtonHot  := False;
      FButtonDown := False;
    end;
  end;

  if IsMouseDown then
  begin
    if (OldHot <> nil) or (OldDown <> nil) then
      Invalidate;

    inherited CaptureChanged(Captured);
  end else
  begin
    if GetCapture = Handle then
      ReleaseCapture;

    if (OldHot <> nil) or (OldDown <> nil) then
      Invalidate;

    inherited CaptureChanged(Captured);

    if OldHot <> nil then
      DoButtonHotChanged(nil);
    if OldDown <> nil then
      DoButtonUp(OldDown);
  end;    
end;

constructor TSCCustomButtonFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButtonInsideFrame := True;
  FButtonList := TList.Create;
  FButtonProps := GetButtonPropsClass.Create(Self);
end;

destructor TSCCustomButtonFrame.Destroy;
begin
  ReleaseButtons;
  FreeAndNil(FButtonList);
  FreeAndNil(FButtonProps);
  inherited Destroy;
end;

procedure TSCCustomButtonFrame.DoButtonClick(Btn: TSCEditButton);
begin
  //
end;

procedure TSCCustomButtonFrame.DoButtonHotChanged(Btn: TSCEditButton);
begin
  //
end;

procedure TSCCustomButtonFrame.DoButtonUp(Btn: TSCEditButton);
begin
  //
end;

function TSCCustomButtonFrame.GetButton(Index: Integer): TSCEditButton;
begin
  Result := nil;
  if (Index > -1) and (Index < FButtonList.Count) then
    Result := FButtonList.Items[Index];
end;

function TSCCustomButtonFrame.GetButtonAtPos(P: TPoint): TSCEditButton;
var
  CR, R: TRect;
  I: Integer;
  Btn: TSCEditButton;
begin
  Result := nil;
  if HandleAllocated and (FButtonList <> nil) and (FButtonList.Count > 0) then
  begin
    CR := GetClientRect;
    if IsRectEmpty(CR) then
      Exit;

    for I := 0 to FButtonList.Count-1 do
    begin
      Btn := FButtonList.Items[I];

      if (Btn = nil) or (Btn.Width = 0) or not Btn.Visible then
        Continue;

      R := GetButtonRect(Btn);
      IntersectRect(R, R, CR);

      if not IsRectEmpty(R) and PtInRect(R, P) then
      begin
        Result := Btn;
        Exit;
      end;
    end;
  end;
end;

function TSCCustomButtonFrame.GetButtonClass: TSCEditButtonClass;
begin
  Result := TSCEditButton;
end;

function TSCCustomButtonFrame.GetButtonRect(Btn: TSCEditButton): TRect;
begin
  Result := Rect(0, 0, 0, 0);
end;

function TSCCustomButtonFrame.GetDownButton: TSCEditButton;
var
  I: Integer;
  Btn: TSCEditButton;
begin
  Result := nil;
  if HandleAllocated and (FButtonList <> nil) then
    for I := 0 to FButtonList.Count-1 do
    begin
      Btn := FButtonList.Items[I];

      if Btn.Visible and (Btn.Width <> 0) and Btn.ButtonDown then
      begin
        Result := Btn;
        Exit;
      end;
    end;
end;

function TSCCustomButtonFrame.GetHotButton: TSCEditButton;
var
  I: Integer;
  Btn: TSCEditButton;
begin
  Result := nil;
  if HandleAllocated and (FButtonList <> nil) then
    for I := 0 to FButtonList.Count-1 do
    begin
      Btn := FButtonList.Items[I];

      if Btn.Visible and (Btn.Width <> 0) and Btn.ButtonHot then
      begin
        Result := Btn;
        Exit;
      end;
    end;
end;

function TSCCustomButtonFrame.GetSliderHeight(R: TRect; IsUp: Boolean): Integer;
var
  W: Integer;
begin
  Result := R.Bottom - R.Top;
  W := R.Right - R.Left;

  if W < Result then Result := W;

  Result := Result div 2;

  Dec(Result, 5);
  if Result < 0 then Result := 0;
  if Result > 3 then Result := 3;
end;

function TSCCustomButtonFrame.GetSliderPos(R: TRect; IsUp: Boolean): TPoint;
var
  H: Integer;
begin
  Result.x := R.Left + ((R.Right - R.Left) div 2);
  Result.y := R.Top  + ((R.Bottom - R.Top) div 2) - 1;

  if not IsUp then
  begin
    H := GetSliderHeight(R, IsUp);
    Result.y := R.Top  + ((R.Bottom - R.Top + H) div 2) - 1;
  end;
end;

procedure TSCCustomButtonFrame.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
  OldDown, OldHot, Btn, DownBtn: TSCEditButton;
begin
  inherited MouseDown(Button, Shift, X, Y);

  OldDown := nil;
  OldHot  := nil;

  for I := 0 to FButtonList.Count-1 do
  begin
    Btn := FButtonList.Items[I];

    if (OldDown = nil) and Btn.ButtonDown then
      OldDown := Btn;
    if (OldHot = nil) and Btn.ButtonHot then
      OldHot := Btn;

    Btn.FButtonDown := False;
    Btn.FButtonHot  := False;
  end;

  if CanFocus and Focused then
  begin
    DownBtn := nil;
    if (Button = mbLeft) and not IsMouseDown then
    begin
      DownBtn := GetButtonAtPos(Point(X, Y));

      if DownBtn <> nil then
        with DownBtn do
        begin
          FButtonDown := True;
          FButtonHot  := True;
        end;

      if (DownBtn <> OldDown) or (DownBtn <> OldHot) then
        Invalidate;

      if OldDown <> nil then
        DoButtonUp(OldDown);
      if DownBtn <> nil then
        DoButtonClick(DownBtn);
    end;

    if OldHot <> DownBtn then
      DoButtonHotChanged(DownBtn);
  end;    
end;

procedure TSCCustomButtonFrame.MouseInControlChanged;
var
  P: TPoint;
  I: Integer;
  OldHot, Btn: TSCEditButton;
begin
  if not (IsLoading or IsDestroying) then
  begin
    OldHot := nil;
    for I := 0 to FButtonList.Count-1 do
    begin
      Btn := FButtonList.Items[I];
      if (OldHot = nil) and Btn.FButtonHot then
        OldHot := Btn;

      Btn.FButtonHot := False;
    end;

    if IsMouseDown then
      Invalidate
    else begin
      Btn := nil;
      if MouseInControl and GetCursorPos(P) then
      begin
        P := Self.ScreenToClient(P);
        Btn := GetButtonAtPos(P);

        if Btn <> nil then
          Btn.FButtonHot := True;
      end;

      Invalidate;
      if OldHot <> Btn then
        DoButtonHotChanged(Btn);
    end;
  end;
end;

procedure TSCCustomButtonFrame.MouseMove(Shift: TShiftState;
  X, Y: Integer);
var
  I: Integer;
  OldHot, DownBtn, Btn: TSCEditButton;
begin
  inherited MouseMove(Shift, X, Y);

  OldHot := nil;
  DownBtn := nil;
  for I := 0 to FButtonList.Count-1 do
  begin
    Btn := FButtonList.Items[I];

    if (DownBtn = nil) and Btn.ButtonDown then
      DownBtn := Btn;

    if (OldHot = nil) and Btn.ButtonHot then
      OldHot := Btn;
      
    Btn.FButtonHot := False;
  end;

  if not IsMouseDown then
  begin
    Btn := GetButtonAtPos(Point(X, Y));
    if (DownBtn <> nil) and (Btn <> DownBtn) then
      Btn := nil;

    if Btn <> nil then
      Btn.FButtonHot := True;

    if OldHot <> Btn then
    begin
      Invalidate;
      DoButtonHotChanged(Btn);
    end;
  end;  
end;

procedure TSCCustomButtonFrame.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
  OldDown, OldHot, Btn: TSCEditButton;
begin
  OldDown := nil;
  OldHot  := nil;

  for I := 0 to FButtonList.Count-1 do
  begin
    Btn := FButtonList.Items[I];
    
    if (OldDown = nil) and Btn.ButtonDown then
      OldDown := Btn;
    if (OldHot = nil) and Btn.ButtonHot then
      OldHot := Btn;

    Btn.FButtonDown := False;
    Btn.FButtonHot  := False;
  end;

  Btn := GetButtonAtPos(Point(X, Y));
  if Btn <> nil then
    Btn.FButtonHot := True;

  if (OldHot <> Btn) or (OldDown <> nil) then
  begin
    Invalidate;

    if OldHot <> Btn then
      DoButtonHotChanged(Btn);
    if OldDown <> nil then
      DoButtonUp(OldDown);
  end;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomButtonFrame.Paint;
var
  R: TRect;
  I, SR: Integer;
  Btn: TSCEditButton;
begin
  inherited Paint;

  if HandleAllocated and (FButtonList.Count > 0) then
    for I := 0 to FButtonList.Count-1 do
    begin
      Btn := FButtonList.Items[I];

      if (Btn = nil) or not Btn.Visible or (Btn.Width = 0) then
        Continue;

      R := GetButtonRect(Btn);

      if not IsRectEmpty(R) then
      begin
        SR := IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
        try
          if SR <> NULLREGION then
            PaintButton(Canvas, R, Btn);
        finally
          SelectClipRgn(Canvas.Handle, 0);
        end;
      end;
    end;  
end;

procedure TSCCustomButtonFrame.PaintButtonGlyph(C: TCanvas; R: TRect;
  Btn: TSCEditButton; IsDown, IsHot: Boolean);
begin
  DoCustomPaintButton(C, R, Btn, IsDown, IsHot);
  if Assigned(FOnPaintButton) then
    FOnPaintButton(Self, Btn, C, R, IsDown, IsHot);
end;

procedure TSCCustomButtonFrame.DoCustomPaintButton(C: TCanvas; R: TRect;
  Btn: TSCEditButton; IsDown, IsHot: Boolean);
begin
  //
end;

procedure TSCCustomButtonFrame.PaintButton(C: TCanvas; R: TRect;
  Btn: TSCEditButton);

  procedure DrawButtonDots(Cl: TColor; IsDown: Boolean);
  var
    R1: TRect;
    L, T: Integer;
  begin
    L := R.Left + ((R.Right - R.Left - 10) div 2);
    T := R.Top + ((R.Bottom - R.Top - 2) div 2);

    if FButtonInsideFrame and (FStyle = sces3D) then
    begin
      if Btn.Align = taRightJustify then
        Inc(L)
      else Dec(L);
    end;

    if IsDown then
    begin
      Inc(L); Inc(T);
    end;

    if Cl = clNone then Cl := clBtnText;

    R1 := Rect(L, T, L + 2, T + 2);
    with C do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;
    end;

    C.FillRect(R1);

    OffsetRect(R1, 4, 0);
    C.FillRect(R1);

    OffsetRect(R1, 4, 0);
    C.FillRect(R1);
  end;

  procedure DrawButtonImage(Index: Integer; IsDown: Boolean);
  var
    L, T: Integer;
  begin
    if IsValidImage(Index) then
    begin
      L := R.Left + ((R.Right - R.Left - Images.Width) div 2);
      T := R.Top + ((R.Bottom - R.Top - Images.Height) div 2);

      if IsDown then
      begin
        Inc(L); Inc(T);
      end;

      Images.Draw(C, L, T, Index, Self.Enabled);
    end;  
  end;

var
  P: TPoint;
  R2: TRect;
  BtnDown: Boolean;
  Bs: TSCEditButtonStyle;
  I, H, W, L, T, Img: Integer;
  ClStart, ClEnd, Cl, Cl1,
  Cl2, BtnArrowCl, BtnCl: TColor;
begin
  if (C = nil) or (Btn = nil) or
    not Btn.Visible or IsRectEmpty(R) then
    Exit;

  if (Btn.Color <> clNone) and not ((FStyle in [sces3D, scesFlatNew]) or
    ((FStyle = scesDefaultEx) and not GetDeafultExFocus)) then
    with C do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Btn.Color;

      FillRect(R);
    end;

  H := GetSliderHeight(R, Btn.DropUp);
  P := GetSliderPos(R, Btn.DropUp);

  L := P.x;
  T := P.y;

  Img := -1;
  Bs  := Btn.Style;

  if (Images <> nil) and (Bs = scebImage) then
  begin
    Img := Btn.Image;
    if Img < 0 then Img := -1;
  end;

  BtnArrowCl := Btn.ArrowColor;
  if BtnArrowCl = clNone then BtnArrowCl := clBtnText;

  BtnCl := Btn.Color;
  if BtnCl = clNone then BtnCl := clBtnFace;

  case FStyle of
    scesNone, scesDefault, scesSingleEx:
    begin
      if Btn.FButtonDown and Btn.FButtonHot then
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, True)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, True)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        Cl1 := GetBtnShadowOf(BtnCl);
        scFrame3D(C, R, Cl1, Cl1, 1, 0);
      end else
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        Cl1 := BtnCl;
        Cl2 := Get3DDkShadowOf(BtnCl);
        scFrame3D(C, R, Cl1, Cl2, 1, 0);

        Cl1 := GetBtnHighlightOf(BtnCl);
        Cl2 := GetBtnShadowOf(BtnCl);
        scFrame3D(C, R, Cl1, Cl2, 1, 0);
      end;
    end;
    scesDefaultEx:
    begin
      if Btn.FButtonDown and Btn.FButtonHot then
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, True)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, True)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        Cl1 := GetBtnShadowOf(BtnCl);
        scFrame3D(C, R, Cl1, Cl1, 1, 0);
      end else
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        if not IsDesigning and GetDeafultExFocus then
        begin
          Cl1 := BtnCl;
          Cl2 := Get3DDkShadowOf(BtnCl);
          scFrame3D(C, R, Cl1, Cl2, 1, 0);

          Cl1 := GetBtnHighlightOf(BtnCl);
          Cl2 := GetBtnShadowOf(BtnCl);
          scFrame3D(C, R, Cl1, Cl2, 1, 0);
        end;  
      end;
    end;
    sces3D:
    begin
      if FButtonInsideFrame then
      begin
        if Btn.Align = taRightJustify then
          Inc(L)
        else Dec(L);
      end else
        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := BtnCl;

          FillRect(R);
        end;

      if Btn.FButtonDown and Btn.FButtonHot then
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, True)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, True)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        if not FButtonInsideFrame then
        begin
          Cl1 := GetBtnShadowOf(clBtnFace);
          scFrame3D(C, R, Cl1, Cl1, 1, 0);
        end;
      end else
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        if not FButtonInsideFrame then
        begin
          Cl1 := GetBtnHighlightOf(clBtnFace);
          Cl2 := Get3DDkShadowOf(clBtnFace);
          scFrame3D(C, R, Cl1, Cl2, 1, 0);

          Cl1 := clBtnFace;
          Cl2 := GetBtnShadowOf(clBtnFace);
          scFrame3D(C, R, Cl1, Cl2, 1, 0);
        end;
      end;

      if FButtonInsideFrame then
      begin
        Cl1 := clBtnShadow;
        Cl2 := clBtnHighlight;

        with C do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;

          if Btn.Align = taRightJustify then
          begin
            Pen.Color := Cl1;
            MoveTo(R.Left, R.Top);
            LineTo(R.Left, R.Bottom);

            Pen.Color := Cl2;
            MoveTo(R.Left + 1, R.Top);
            LineTo(R.Left + 1, R.Bottom);
          end else
          begin
            Pen.Color := Cl2;
            MoveTo(R.Right - 1, R.Top);
            LineTo(R.Right - 1, R.Bottom);

            Pen.Color := Cl1;
            MoveTo(R.Right - 2, R.Top);
            LineTo(R.Right - 2, R.Bottom);
          end;
        end;
      end;
    end;
    scesRaised:
    begin
      if Btn.FButtonDown and Btn.FButtonHot then
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, True)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, True)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        Cl1 := GetBtnShadowOf(BtnCl);
        Cl2 := GetBtnHighlightOf(BtnCl);

        scFrame3D(C, R, Cl1, Cl2, 1, 0);
      end else
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        if not FButtonInsideFrame or Btn.FButtonHot then
        begin
          Cl1 := GetBtnHighlightOf(BtnCl);
          Cl2 := GetBtnShadowOf(BtnCl);

          scFrame3D(C, R, Cl1, Cl2, 1, 0);
        end;  
      end;
    end;
    scesOffice12:
    begin
      if FButtonInsideFrame then
        Inc(L);

      if IsMouseDown or Btn.FButtonHot or Btn.FButtonDown or
        MouseInControl or Focused or MouseIsDown then
      begin
        Cl := FExUseColor;
        if Cl = clNone then
          Cl := clBtnFace;

        Cl1 := BlendedColor(Cl, 32, 32, 32, True);
        Cl2 := clBtnText;

        if Btn.FButtonDown and Btn.FButtonHot then
          Cl1 := BlendedColor(Cl, 16, 16, 16, True);

        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := Cl1;

          FillRect(R);
        end;

        R2 := R;
        Dec(R2.Bottom, Round((R2.Bottom - R2.Top)/4));

        ClEnd := Cl1;
        ClStart := GetGradientPeal(Cl1);

        scDrawGradient(C, R2, scgTopToBottom, ClStart, ClEnd);

        R2 := R;
        Inc(R2.Top, (R2.Bottom - R2.Top) div 2);

        if not IsRectEmpty(R2) then
        begin
          ClStart := GetGradientShadow(Cl1);
          ClEnd := GetGradientLight(Cl1);

          scDrawGradient(C, R2, scgTopToBottom, ClStart, ClEnd);
        end;

        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(Cl2, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl2, Cl2)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl2, Cl2);

        if not FButtonInsideFrame then
        begin
          Cl1 := Cl;
          scFrame3D(C, R, Cl1, Cl1, 1, 0);
        end else
        begin
          with C do
          begin
            Pen.Style := psSolid;
            Pen.Mode  := pmCopy;
            Pen.Width := 1;
            Pen.Color := Cl;

            if Btn.Align = taRightJustify then
            begin
              MoveTo(R.Left, R.Top);
              LineTo(R.Left, R.Bottom);
            end else
            begin
              MoveTo(R.Right - 1, R.Top);
              LineTo(R.Right - 1, R.Bottom);
            end;
          end;
        end;  
      end else
      begin
        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := BtnCl;

          FillRect(R);
        end;

        Cl := BtnCl;

        R2 := R;
        Dec(R2.Bottom, Round((R2.Bottom - R2.Top)/4));

        ClEnd := Cl;
        ClStart := GetGradientPeal(Cl);

        scDrawGradient(C, R2, scgTopToBottom, ClStart, ClEnd);

        R2 := R;
        Inc(R2.Top, (R2.Bottom - R2.Top) div 2);

        if not IsRectEmpty(R2) then
        begin
          ClStart := GetGradientShadow(Cl);
          ClEnd := GetGradientLight(Cl);

          scDrawGradient(C, R2, scgTopToBottom, ClStart, ClEnd);
        end;

        BtnDown := Btn.FButtonDown and Btn.FButtonHot;

        if BtnDown then
        begin
          Inc(L); Inc(T);
        end else
        begin
          R2 := R;
          R2.Bottom := R2.Top + 2*((R2.Bottom - R2.Top) div 3);

          scDrawGradient(C, R2, scgTopToBottom, GetBtnHighlightOf(BtnCl), BtnCl);
        end;

        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, BtnDown)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, BtnDown)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        if FButtonInsideFrame then
        begin
          Cl1 := Self.Color;
          scFrame3D(C, R, Cl1, Cl1, 1, 0);
        end;  
      end;
    end;
    scesOffice2003:
    begin
      if FButtonInsideFrame then
        Inc(L);

      if IsMouseDown or Btn.FButtonHot or Btn.FButtonDown or
        MouseInControl or Focused or MouseIsDown then
      begin
        Cl1 := GetOfficeXPSelColor;
        Cl2 := clBtnText;

        if Btn.FButtonDown and Btn.FButtonHot then
        begin
          Cl1 := GetOfficeXPDownedSelColor;
          Cl2 := GetBtnHighlightOf(clBtnFace);
        end;

        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := Cl1;

          FillRect(R);
        end;

        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(Cl2, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl2, Cl2)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl2, Cl2);

        if not FButtonInsideFrame then
        begin
          Cl1 := clHighlight;
          scFrame3D(C, R, Cl1, Cl1, 1, 0);
        end else
        begin
          with C do
          begin
            Pen.Style := psSolid;
            Pen.Mode  := pmCopy;
            Pen.Width := 1;
            Pen.Color := clHighlight;

            if Btn.Align = taRightJustify then
            begin
              MoveTo(R.Left, R.Top);
              LineTo(R.Left, R.Bottom);
            end else
            begin
              MoveTo(R.Right - 1, R.Top);
              LineTo(R.Right - 1, R.Bottom);
            end;
          end;
        end;  
      end else
      begin
        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := BtnCl;

          FillRect(R);
        end;

        BtnDown := Btn.FButtonDown and Btn.FButtonHot;

        if BtnDown then
        begin
          Inc(L); Inc(T);
        end else
        begin
          R2 := R;
          R2.Bottom := R2.Top + 2*((R2.Bottom - R2.Top) div 3);

          scDrawGradient(C, R2, scgTopToBottom, GetBtnHighlightOf(BtnCl), BtnCl);
        end;

        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, BtnDown)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, BtnDown)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        if FButtonInsideFrame then
        begin
          Cl1 := Self.Color;
          scFrame3D(C, R, Cl1, Cl1, 1, 0);
        end;  
      end;
    end;
    scesOfficeXP:
    begin
      if FButtonInsideFrame then
        Inc(L);

      if IsMouseDown or Btn.FButtonHot or Btn.FButtonDown or
        MouseInControl or Focused or MouseIsDown then
      begin
        Cl1 := GetOfficeXPSelColor;
        Cl2 := clBtnText;

        if Btn.FButtonDown and Btn.FButtonHot then
        begin
          Cl1 := GetOfficeXPDownedSelColor;
          Cl2 := GetBtnHighlightOf(clBtnFace);
        end;

        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := Cl1;

          FillRect(R);
        end;

        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(Cl2, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl2, Cl2)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl2, Cl2);

        if not FButtonInsideFrame then
        begin
          Cl1 := clHighlight;
          scFrame3D(C, R, Cl1, Cl1, 1, 0);
        end else
        begin
          with C do
          begin
            Pen.Style := psSolid;
            Pen.Mode  := pmCopy;
            Pen.Width := 1;
            Pen.Color := clHighlight;

            if Btn.Align = taRightJustify then
            begin
              MoveTo(R.Left, R.Top);
              LineTo(R.Left, R.Bottom);
            end else
            begin
              MoveTo(R.Right - 1, R.Top);
              LineTo(R.Right - 1, R.Bottom);
            end;
          end;
        end;  
      end else
      begin
        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := GetOfficeXPBtnColor;

          FillRect(R);
        end;

        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(clBtnText, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False, clBtnText, clBtnText)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False, clBtnText, clBtnText);

        if FButtonInsideFrame then
        begin
          Cl1 := Self.Color;
          scFrame3D(C, R, Cl1, Cl1, 1, 0);
        end;  
      end;
    end;
    scesFlat:
    begin
      if not (IsMouseDown or Btn.FButtonHot or Focused or
        (Btn.FButtonDown and Btn.FButtonHot) or MouseInControl or MouseIsDown) then
      begin
        Inc(L);
        
        if Btn.Align = taRightJustify then
          Inc(R.Right)
        else Dec(R.Left);

        Dec(R.Top);
        Inc(R.Bottom);

        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := BtnCl;

          FillRect(R);
        end;
      end;

      if Btn.FButtonDown and Btn.FButtonHot then
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, True)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, True)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        Cl1 := GetBtnShadowOf(BtnCl);
        scFrame3D(C, R, Cl1, Cl1, 1, 0);
      end else
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        if IsMouseDown or Btn.FButtonHot or
          MouseInControl or Focused or MouseIsDown then
        begin
          Cl1 := GetBtnFaceOf(BtnCl);
          Cl2 := Get3DDkShadowOf(BtnCl);

          scFrame3D(C, R, Cl1, Cl2, 1, 0);

          Cl1 := GetBtnHighlightOf(BtnCl);
          Cl2 := GetBtnShadowOf(BtnCl);

          scFrame3D(C, R, Cl1, Cl2, 1, 0);
        end else
        begin
          Cl1 := GetBtnFaceOf(BtnCl);
          Cl2 := GetBtnShadowOf(BtnCl);

          scFrame3D(C, R, Cl1, Cl2, 1, 0);

          Cl1 := GetBtnHighlightOf(BtnCl);
          // Cl2 := GetBtnFaceOf(BtnCl);
          Cl2 := GetBtnShadowOf(BtnCl);

          scFrame3D(C, R, Cl1, Cl2, 1, 0);
        end;
      end;
    end;
    scesFlatEx:
    begin
      if IsMouseDown or Btn.FButtonHot or Focused or
        (Btn.FButtonDown and Btn.FButtonHot) or MouseInControl or MouseIsDown then
      begin
        Inc(L);

        if FButtonInsideFrame then
        begin
          if Btn.Align = taRightJustify then
            Inc(R.Right)
          else Dec(R.Left);

          Dec(R.Top);
          Inc(R.Bottom);
        end;
        
        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := BtnCl;

          FillRect(R);
        end;
      end;

      if Btn.FButtonDown and Btn.FButtonHot then
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, True)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, True)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        Cl1 := GetBtnShadowOf(BtnCl);
        Cl2 := GetBtnHighlightOf(BtnCl);
        scFrame3D(C, R, Cl1, Cl2, 1, 0);
      end else
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        if IsMouseDown or Btn.FButtonHot or
          MouseInControl or Focused or MouseIsDown then
        begin
          Cl1 := GetBtnFaceOf(BtnCl);
          Cl2 := GetBtnShadowOf(BtnCl);

          scFrame3D(C, R, Cl1, Cl2, 1, 0);

          Cl1 := GetBtnHighlightOf(BtnCl);
          // Cl2 := GetBtnFaceOf(BtnCl);
          Cl2 := GetBtnShadowOf(BtnCl);

          scFrame3D(C, R, Cl1, Cl2, 1, 0);
        end else
        if FButtonInsideFrame then
          scFrame3D(C, R, Self.Color, Self.Color, 1, 0);
      end;
    end;
    scesFlatNew:
    begin
      if Btn.FButtonDown and Btn.FButtonHot then
      begin
        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := BtnCl;

          FillRect(R);
        end;

        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, True)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, True)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        Cl1 := GetBtnShadowOf(BtnCl);
        Cl2 := GetBtnHighlightOf(BtnCl);

        scFrame3D(C, R, Cl1, Cl2, 1, 0);
      end else
      begin
        if not FButtonInsideFrame or Btn.FButtonHot or Btn.FButtonDown then
          with C do
          begin
            Brush.Style := bsSolid;
            Brush.Color := BtnCl;

            FillRect(R);
          end;

        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        if Btn.FButtonHot then
        begin
          Cl1 := GetBtnHighlightOf(BtnCl);
          Cl2 := GetBtnShadowOf(BtnCl);

          scFrame3D(C, R, Cl1, Cl2, 1, 0);
        end;
      end;
    end;
    scesMetal:
    begin
      if not (Btn.FButtonDown and Btn.FButtonHot) then
      begin
        Inc(L);
        
        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := BtnCl;

          FillRect(R);
        end;
      end;

      if Btn.FButtonDown and Btn.FButtonHot then
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, True)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, True)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        Cl1 := GetBtnShadowOf(BtnCl);
        Cl2 := GetBtnShadowOf(BtnCl);

        scFrame3D(C, R, Cl1, Cl2, 1, 0);

        Cl1 := BtnCl;
        Cl2 := GetBtnHighlightOf(BtnCl);

        scFrame3D(C, R, Cl1, Cl2, 1, 0);
      end else
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        Cl1 := GetBtnShadowOf(BtnCl);
        Cl2 := GetBtnShadowOf(BtnCl);

        scFrame3D(C, R, Cl1, Cl2, 1, 0);

        Cl1 := GetBtnHighlightOf(BtnCl);
        Cl2 := BtnCl;

        scFrame3D(C, R, Cl1, Cl2, 1, 0);
      end;
    end;
    scesSingle:
    begin
      if FButtonInsideFrame then
        Inc(L);
      
      if Btn.FButtonDown and Btn.FButtonHot then
      begin
        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := Get3DDkShadowOf(BtnCl);

          FillRect(R);
        end;

        Cl1 := GetBtnHighlightOf(BtnCl);
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(Cl1, True)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, True)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl1, Cl1)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl1, Cl1);
      end else
      if Btn.FButtonHot or Btn.FButtonDown then
      begin
        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := GetBtnShadowOf(BtnCl);

          FillRect(R);
        end;

        Cl1 := GetBtnHighlightOf(BtnCl);
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(Cl1, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl1, Cl1)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl1, Cl1);
      end else
      if Bs = scebCustom then
        PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
      else
      if Bs = scebBrowse then
        DrawButtonDots(BtnArrowCl, False)
      else
      if Bs = scebImage then
        DrawButtonImage(Img, False)
      else
      if not Btn.DropUp then
        scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
          BtnArrowCl, BtnArrowCl)
      else
        scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
          BtnArrowCl, BtnArrowCl);

      if FButtonInsideFrame then
        with C do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;

          Cl1 := clBtnShadow;
          if FFrameColor <> clNone then
            Cl1 := FFrameColor;

          Pen.Color := Cl1;

          if Btn.Align = taRightJustify then
          begin
            MoveTo(R.Left, R.Top);
            LineTo(R.Left, R.Bottom);
          end else
          begin
            MoveTo(R.Right - 1, R.Top);
            LineTo(R.Right - 1, R.Bottom);
          end;
        end;
    end;
    scesNew, scesExtreme:
    begin
      if FButtonInsideFrame then
        Inc(L);

      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := BtnCl;

        FillRect(R);
      end;

      BtnDown := Btn.FButtonDown and Btn.FButtonHot;

      if BtnDown then
      begin
        Inc(T);

        if FStyle = scesNew then
          Inc(L)
        else begin
          R2 := R;
          
          R2.Top := R2.Bottom - 2*((R2.Bottom - R2.Top) div 3);
          scDrawGradient(C, R2, scgBottomToTop, GetBtnHighlightOf(BtnCl), BtnCl);
        end;
      end else
      begin
        R2 := R;

        if FStyle = scesExtreme then
        begin
          R2.Bottom := R2.Top + 2*((R2.Bottom - R2.Top) div 3);
          scDrawGradient(C, R2, scgTopToBottom, GetBtnHighlightOf(BtnCl), BtnCl);
        end else
        begin
          R2.Right := R2.Left + 2*((R2.Right - R2.Left) div 3);
          scDrawGradient(C, R2, scgLeftToRight, GetBtnHighlightOf(BtnCl), BtnCl);
        end;
      end;

      if Bs = scebCustom then
        PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
      else
      if Bs = scebBrowse then
        DrawButtonDots(BtnArrowCl, BtnDown)
      else
      if Bs = scebImage then
        DrawButtonImage(Img, BtnDown)
      else
      if not Btn.DropUp then
        scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
          BtnArrowCl, BtnArrowCl)
      else
        scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
          BtnArrowCl, BtnArrowCl);

      if (FStyle = scesExtreme) and (IsMouseDown or Btn.FButtonHot or
        Btn.FButtonDown or MouseInControl or MouseIsDown) then
      begin
        Cl1 := GetOfficeXPSelColor;

        R2 := R;
        if FButtonInsideFrame then
        begin
          if Btn.FAlign = taLeftJustify then
            Dec(R2.Right)
          else Inc(R2.Left);
        end;

        scFrame3D(C, R2, Cl1, Cl1, 1, 0);
        scFrame3D(C, R2, Cl1, Cl1, 1, 0);
      end;

      if FButtonInsideFrame then
        with C do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;

          Cl1 := BtnCl;
          if FStyle = scesExtreme then
          begin
            Cl1 := clBtnShadow;
            if FFrameColor <> clNone then
              Cl1 := FFrameColor;
          end;

          Pen.Color := Cl1;

          if Btn.FAlign = taLeftJustify then
          begin
            MoveTo(R.Right - 1, R.Top);
            LineTo(R.Right - 1, R.Bottom);
          end else
          begin
            MoveTo(R.Left, R.Top);
            LineTo(R.Left, R.Bottom);
          end;
        end;
    end;
    scesDouble, scesDoubleNew:
    begin
      if FButtonInsideFrame then
        Inc(L);

      if Btn.FButtonDown and Btn.FButtonHot then
      begin
        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := Get3DDkShadowOf(BtnCl);

          FillRect(R);
        end;

        Cl1 := GetBtnHighlightOf(BtnCl);
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(Cl1, True)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, True)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl1, Cl1)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl1, Cl1);
      end else
      if Btn.FButtonHot or Btn.FButtonDown then
      begin
        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := GetBtnShadowOf(BtnCl);

          FillRect(R);
        end;

        Cl1 := GetBtnHighlightOf(BtnCl);
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(Cl1, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl1, Cl1)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False, Cl1, Cl1);
      end else
      if Bs = scebCustom then
        PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
      else
      if Bs = scebBrowse then
        DrawButtonDots(BtnArrowCl, False)
      else
      if Bs = scebImage then
        DrawButtonImage(Img, False)
      else
      if not Btn.DropUp then
        scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
          BtnArrowCl, BtnArrowCl)
      else
        scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
          BtnArrowCl, BtnArrowCl);

      if (FStyle = scesDouble) and FButtonInsideFrame then
      begin
        Cl1 := clBtnShadow;
        if FFrameColor <> clNone then
          Cl1 := FFrameColor;

        with C do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;

          Pen.Color := Cl1;

          if Btn.Align = taRightJustify then
          begin
            MoveTo(R.Left, R.Top);
            LineTo(R.Left, R.Bottom);
          end else
          begin
            MoveTo(R.Right - 1, R.Top);
            LineTo(R.Right - 1, R.Bottom);
          end;
        end;
      end;
    end;
    scesWinXP:
    begin
      InflateRect(R, 1, 1);

      scDrawXPButton(C, R, ExUseColor, GetBackColor, Btn.FButtonDown and Btn.FButtonHot, Btn.FButtonHot);
      Cl1 := Get3DDkShadowOf(ExUseColor);

      if Bs = scebCustom then
        PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
      else
      if Bs = scebBrowse then
        DrawButtonDots(Cl1, Btn.FButtonDown and Btn.FButtonHot)
      else
      if Bs = scebImage then
        DrawButtonImage(Img, Btn.FButtonDown and Btn.FButtonHot)
      else begin
        L := R.Left + ((R.Right - R.Left) div 2);
        W := R.Bottom - R.Top;
        if R.Right - R.Left < W then
          W := R.Right - R.Left;

        Dec(W, 3);
        W := W div 2;

        if W <= 0 then Exit;

        if W > 4 then W := 4;

        T := R.Top +  ((R.Bottom - R.Top) div 2) + (W div 2);
        if Btn.DropUp then
          T := R.Top +  ((R.Bottom - R.Top) div 2) - (W div 2);

        if Btn.FButtonDown and Btn.FButtonHot then
          Inc(T);

        with C do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := Cl1;

          if not Btn.DropUp then
          begin
            Dec(T);
            for I := 0 to W - 2 do
            begin
              MoveTo(L - (W - 1), T - (W - 1));
              LineTo(L, T);
              LineTo(L + W, T - W);

              Inc(T);
            end;
          end else
          begin
            Dec(T);
            for I := 0 to W - 2 do
            begin
              MoveTo(L - (W - 1), T + (W - 1));
              LineTo(L, T);
              LineTo(L + W, T + W);

              Inc(T);
            end;
          end;
        end;
      end;
    end;
    else begin
      if Btn.FButtonDown and Btn.FButtonHot then
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, True)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, True)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L + 1, T + 1), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        Cl1 := GetBtnShadowOf(BtnCl);
        scFrame3D(C, R, Cl1, Cl1, 1, 0);
      end else
      begin
        if Bs = scebCustom then
          PaintButtonGlyph(C, R, Btn, Btn.FButtonDown, Btn.FButtonHot)
        else
        if Bs = scebBrowse then
          DrawButtonDots(BtnArrowCl, False)
        else
        if Bs = scebImage then
          DrawButtonImage(Img, False)
        else
        if not Btn.DropUp then
          scDrawUpSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl)
        else
          scDrawDownSlider(C, Point(L, T), 2*H, H, sctsMac, False,
            BtnArrowCl, BtnArrowCl);

        Cl1 := BtnCl;
        Cl2 := Get3DDkShadowOf(BtnCl);
        scFrame3D(C, R, Cl1, Cl2, 1, 0);

        Cl1 := GetBtnHighlightOf(BtnCl);
        Cl2 := GetBtnShadowOf(BtnCl);
        scFrame3D(C, R, Cl1, Cl2, 1, 0);
      end;
    end;
  end;
end;

procedure TSCCustomButtonFrame.RegisterButton(Btn: TSCEditButton);
begin
  if (Btn <> nil) and (Btn.FOwner <> Self) and
    (FButtonList <> nil) and (FButtonList.IndexOf(Btn) = -1) then
  begin
    if Btn.FOwner <> nil then
      Btn.FOwner.UnregisterButton(Btn);

    Btn.FOwner := Self;
    FButtonList.Add(Btn);

    if not IsLoading then
      StyleChanged;
  end;
end;

procedure TSCCustomButtonFrame.ReleaseButtons;
var
  I: Integer;
  Btn: TSCEditButton;
begin
  if FButtonList <> nil then
    for I := FButtonList.Count-1 downto 0 do
    begin
      Btn := TSCEditButton(FButtonList[I]);

      Btn.FOwner := nil;
      FButtonList.Delete(I);
      Btn.Free;
    end;

  if not IsDestroying then
    StyleChanged;
end;

procedure TSCCustomButtonFrame.StopTracking;
var
  I: Integer;
  Btn, OldHot, OldDown: TSCEditButton;
begin
  if not (IsLoading or IsDestroying) then
    Exit;

  OldHot  := nil;
  OldDown := nil;

  for I := 0 to FButtonList.Count-1 do
  begin
    Btn := FButtonList.Items[I];

    if (OldHot = nil) and Btn.FButtonHot then
      OldHot := Btn;
    if (OldDown = nil) and Btn.FButtonDown then
      OldDown := Btn;

    with Btn do
    begin
      FButtonHot  := False;
      FButtonDown := False;
    end;
  end;

  if IsMouseDown then
  begin
    inherited StopTracking;

    if (OldHot <> nil) or (OldDown <> nil) then
      Invalidate;
  end else
  begin
    if GetCapture = Handle then
      ReleaseCapture;

    inherited StopTracking;

    if (OldHot <> nil) or (OldDown <> nil) then
      Invalidate;

    if OldHot <> nil then
      DoButtonHotChanged(nil);
    if OldDown <> nil then
      DoButtonUp(OldDown);
  end;    
end;

procedure TSCCustomButtonFrame.StyleChanged;
var
  P: TPoint;
  I: Integer;
  OldDown, OldHot, Btn: TSCEditButton;
begin
  inherited StyleChanged;

  if HandleAllocated and not (IsDesigning or IsLoading) then
  begin
    OldDown := nil;
    OldHot  := nil;

    for I := 0 to FButtonList.Count-1 do
    begin
      Btn := FButtonList.Items[I];

      if (OldDown = nil) and Btn.ButtonDown then
        OldDown := Btn;
      if (OldHot = nil) and Btn.ButtonHot then
        OldHot := Btn;

      Btn.FButtonDown := False;
      Btn.FButtonHot  := False;
    end;

    P := Self.ScreenToClient(P);

    Btn := GetButtonAtPos(P);
    if (Btn <> nil) and not IsMouseDown then
      Btn.FButtonHot := True;
 
    if (OldHot <> Btn) or (OldDown <> nil) then
      Invalidate;
  end;
end;

procedure TSCCustomButtonFrame.UnregisterButton(Btn: TSCEditButton);
var
  Index: Integer;
begin
  if (Btn <> nil) and (Btn.FOwner = Self) and (FButtonList <> nil) then
  begin
    Btn.FOwner := nil;
    Index := FButtonList.IndexOf(Btn);

    if Index > -1 then
      FButtonList.Delete(Index);

    if not IsDestroying then
      StyleChanged;
  end;
end;

procedure TSCCustomButtonFrame.Loaded;
var
  I: Integer;
  Btn: TSCEditButton;
begin
  inherited Loaded;

  for I := 0 to FButtonList.Count-1 do
  begin
    Btn := FButtonList.Items[I];
    ButtonChanged(Btn);
  end;

  StyleChanged;
end;

procedure TSCCustomButtonFrame.SetButtonProps(Value: TSCCustomEditButtonProps);
begin
  FButtonProps.Assign(Value);
end;

function TSCCustomButtonFrame.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCCustomEditButtonProps;
end;

function TSCCustomButtonFrame.GetFrameRect: TRect;
var
  R: TRect;
  I: Integer;
  Btn: TSCEditButton;
begin
  Result := inherited GetFrameRect;

  if not FButtonInsideFrame and HandleAllocated and (FButtonList.Count > 0) then
    for I := 0 to FButtonList.Count-1 do
    begin
      if IsRectEmpty(Result) then
        Break;

      Btn := FButtonList.Items[I];

      if (Btn = nil) or not Btn.Visible or (Btn.Width = 0) then
        Continue;

      R := GetButtonRect(Btn);

      if (R.Left <= R.Right) and (R.Right > Result.Left) and
        (R.Left < Result.Right) then
      begin
        if Btn.Align = taRightJustify then
          Result.Right := R.Left
        else
          Result.Left := R.Right;
      end;
    end;

  if IsRectEmpty(Result) then
    Result := Rect(0, 0, 0, 0);
end;

function TSCCustomButtonFrame.GetInnerEditRect: TRect;
var
  B: Integer;
begin
  Result := GetClientRect;

  if FButtonInsideFrame then
  begin
    B := GetStyleBorderSize;
    if not (FStyle in [scesOfficeXP, scesOffice12, scesOffice2003]) then
      Dec(B);

    if B < 0 then B := 0;
    InflateRect(Result, -B, -B);
  end;
end;

procedure TSCCustomButtonFrame.SetButtonInsideFrame(Value: Boolean);
begin
  if FButtonInsideFrame <> Value then
  begin
    FButtonInsideFrame := Value;
    if (FButtonList <> nil) and (FButtonList.Count > 0) then
    begin
      StyleChanged;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomButtonFrame.DrawEditBorder(C: TCanvas);
var
  I: Integer;
  CR, R, Br: TRect;
  Cl1, Cl2: TColor;
  Btn: TSCEditButton;
begin
  if C = nil then
    Exit;

  if FButtonInsideFrame and (FStyle = scesDoubleNew) then
  begin
    CR := GetFrameRect;

    Cl1 := clBtnShadow;
    if FFrameColor <> clNone then
      Cl1 := FFrameColor;

    scFrame3D(C, CR, Cl1, Cl1, 1, 0);

    Cl2 := clBtnHighlight;
    scFrame3D(C, CR, Cl2, Cl2, 1, 0);

    R := CR;
    
    if FButtonList.Count > 0 then
      for I := 0 to FButtonList.Count-1 do
      begin
        if IsRectEmpty(R) then
          Break;

        Btn := FButtonList.Items[I];

        if (Btn = nil) or not Btn.Visible or (Btn.Width = 0) then
          Continue;

        Br := GetButtonRect(Btn);

        if (Br.Left <= Br.Right) and (Br.Right > R.Left) and
          (Br.Left < R.Right) then
        begin
          if Btn.Align = taRightJustify then
            R.Right := Br.Left
          else
            R.Left := Br.Right;
        end;
      end;

    if not IsRectEmpty(R) then
      scFrame3D(C, R, Cl1, Cl1, 1, 0);
  end else
    inherited DrawEditBorder(C);
end;

function TSCCustomButtonFrame.GetDeafultExFocus: Boolean;
begin
  Result := HasFocus or MouseInControl;
end;

function TSCCustomButtonFrame.GetGradientDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -32);
end;

function TSCCustomButtonFrame.GetGradientExDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -40);
end;

function TSCCustomButtonFrame.GetGradientExLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 40);
end;

function TSCCustomButtonFrame.GetGradientLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 30);
end;

function TSCCustomButtonFrame.GetGradientPeal(AColor: TColor): TColor;
begin
  Result := BlendedColor(AColor, 52, 44, 112, True);
end;

function TSCCustomButtonFrame.GetGradientPreDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -80);
end;

function TSCCustomButtonFrame.GetGradientPreLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 80);
end;

function TSCCustomButtonFrame.GetGradientShadow(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -6);
end;

{ TSCCustomHyperlinkEdit }

constructor TSCCustomHyperlinkEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSelect := False;
  
  FActivateCursor := crHandPoint;
  FActivateKey := VK_SPACE + scCtrl;
  FLinkColor := clBlue;
  FSingleClick := False;
end;

procedure TSCCustomHyperlinkEdit.DoActivate;
var
  DC: HWND;
  F: TCustomForm;
begin
  if Assigned(FOnActivate) then
    FOnActivate(Self)
  else
  if Trim(Text) <> '' then
  begin
    DC := 0;

    F  := GetParentForm(Self);
    if F <> nil then
      DC := F.Handle;

    ShellExecute(DC, 'open', PChar(Text), nil, nil, SW_SHOWMAXIMIZED);
  end;
end;

function TSCCustomHyperlinkEdit.GetEditCursor: TCursor;
begin
  Result := inherited GetEditCursor;
  if FSingleClick then
    Result := FActivateCursor;
end;

procedure TSCCustomHyperlinkEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  Sc: TShortCut;
begin
  Sc := scShortCut(Key, Shift);
  if (Sc <> 0) and (Sc = FActivateKey) then
  begin
    Key := 0;
    scKillMessage(Handle, WM_CHAR);
    DoActivate;

    Exit;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomHyperlinkEdit.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if (Button = mbLeft) and (ssDouble in Shift) then
    DoActivate;
end;

procedure TSCCustomHyperlinkEdit.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if (Button = mbLeft) and FSingleClick and PtInRect(ClientRect, Point(X, Y)) then
    DoActivate;
end;

procedure TSCCustomHyperlinkEdit.SetLinkColor(Value: TColor);
begin
  if FLinkColor <> Value then
  begin
    FLinkColor := Value;
    if Text <> '' then
      Invalidate;
  end;
end;

procedure TSCCustomHyperlinkEdit.UpdateLineFont(F: TFont; Index: Integer);
begin
  if F <> nil then
  begin
    F.Color := FLinkColor;
    F.Style := F.Style + [fsUnderline];
  end;
end;

{ TSCComboboxExItem }

procedure TSCComboboxExItem.Assign(Source: TPersistent);
begin
  if Source is TSCComboboxExItem then
  begin
    with TSCComboboxExItem(Source) do
    begin
      Self.FEnabled := Enabled;
      Self.FImageIndex  := ImageIndex;
      Self.FIndentLevel := IndentLevel;
      Self.FState := State;
      Self.FText  := Text;
      Self.FValue := Value;
      Self.FData  := Data;
    end;

    Changed(False);
  end else
    inherited Assign(Source);
end;

constructor TSCComboboxExItem.Create(Collection: TCollection);
begin
  FEnabled := True;
  FImageIndex := -1;
  FIndentLevel := 0;
  FState := sccbUnchecked;
  inherited Create(Collection);
end;

function TSCComboboxExItem.GetChecked: Boolean;
begin
  Result := FState = sccbChecked;
end;

function TSCComboboxExItem.GetComboboxEx: TSCCustomComboboxEx;
begin
  Result := nil;
  if (Collection <> nil) and (Collection is TSCComboboxExItems) then
    Result := TSCComboboxExItems(Collection).FOwner;
end;

function TSCComboboxExItem.GetDisplayName: string;
begin
  Result := Text;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

function TSCComboboxExItem.GetImages: TCustomImageList;
var
  AOwner: TSCCustomComboboxEx;
begin
  Result := nil;

  AOwner := GetComboboxEx;
  if AOwner <> nil then
    Result := AOwner.Images;
end;

procedure TSCComboboxExItem.SetChecked(Value: Boolean);
begin
  if GetChecked <> Value then
  begin
    if Value then
      State := sccbChecked
    else
      State := sccbUnchecked;
  end;
end;

procedure TSCComboboxExItem.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed(False);
  end;
end;

procedure TSCComboboxExItem.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed(False);
  end;
end;

procedure TSCComboboxExItem.SetIndentLevel(Value: Integer);
begin
  if FIndentLevel <> Value then
  begin
    FIndentLevel := Value;
    Changed(False);
  end;
end;

procedure TSCComboboxExItem.SetState(Value: TSCCheckState);
begin
  if FState <> Value then
  begin
    FState := Value;
    Changed(False);
  end;
end;

procedure TSCComboboxExItem.SetText(const Value: String);
begin
  if FText <> Value then
  begin
    FText := Value;
    Changed(False);
  end;
end;

procedure TSCComboboxExItem.SetValue(const Value: String);
begin
  if FValue <> Value then
  begin
    FValue := Value;
    Changed(False);
  end;
end;

{ TSCComboboxExItems }

function TSCComboboxExItems.Add: TSCComboboxExItem;
begin
  Result := TSCComboboxExItem(inherited Add);
end;

function TSCComboboxExItems.CompletedText(const S: String;
  CaseSensitive: Boolean): String;
var
  I, Ln: Integer;
  Str, SubStr: String;
begin
  Result := S;
  if (UpdateCount = 0) and (Count > 0) and (S <> '') then
  begin
    Str := S;
    if not CaseSensitive then
      Str := AnsiLowerCase(Str);

    Ln := Length(Str);
    for I := 0 to Count-1 do
    begin
      SubStr := Copy(Items[I].Text, 1, Ln);
      if not CaseSensitive then
        SubStr := AnsiLowerCase(SubStr);

      if Str = SubStr then
      begin
        Result := Items[I].Text;
        Exit;
      end;
    end;
  end;
end;

constructor TSCComboboxExItems.Create(AOwner: TSCCustomComboboxEx);
begin
  inherited Create(TSCComboboxExItem);
  FOwner := AOwner;
end;

function TSCComboboxExItems.GetItem(Index: Integer): TSCComboboxExItem;
begin
  Result := TSCComboboxExItem(inherited GetItem(Index));
end;

function TSCComboboxExItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCComboboxExItems.IndexOf(const S: String; CaseSensitive: Boolean): Integer;
var
  I, Ln: Integer;
  Str, SubStr: String;
begin
  Result := -1;
  if (UpdateCount = 0) and (Count > 0) and (S <> '') then
  begin
    Str := S;
    if not CaseSensitive then
      Str := AnsiLowerCase(Str);

    Ln := Length(Str);
    for I := 0 to Count-1 do
    begin
      SubStr := Copy(Items[I].Text, 1, Ln);
      if not CaseSensitive then
        SubStr := AnsiLowerCase(SubStr);

      if Str = SubStr then
      begin
        Result := I;
        Exit;
      end;
    end;
  end;
end;

function TSCComboboxExItems.IndexOfValue(const S: String;
  CaseSensitive: Boolean): Integer;
var
  I, Ln: Integer;
  Str, SubStr: String;
begin
  Result := -1;
  if (UpdateCount = 0) and (Count > 0) and (S <> '') then
  begin
    Str := S;
    if not CaseSensitive then
      Str := AnsiLowerCase(Str);

    Ln := Length(Str);
    for I := 0 to Count-1 do
    begin
      SubStr := Copy(Items[I].Value, 1, Ln);
      if not CaseSensitive then
        SubStr := AnsiLowerCase(SubStr);

      if Str = SubStr then
      begin
        Result := I;
        Exit;
      end;
    end;
  end;
end;

procedure TSCComboboxExItems.SetItem(Index: Integer;
  Value: TSCComboboxExItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCComboboxExItems.Update(Item: TCollectionItem);
begin
  if Owner <> nil then
    TSCCustomComboboxEx(Owner).ExItemChanged(TSCComboboxExItem(Item));
end;

{ TSCCustomComboboxEx }

procedure TSCCustomComboboxEx.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomComboboxEx then
    with TSCCustomComboboxEx(Source) do
      Self.ItemsEx := ItemsEx;
end;

procedure TSCCustomComboboxEx.AssignItemsFromList;
var
  I: Integer;
  OldState: Boolean;
  Item: TSCComboboxExItem;
begin
  if FListbox <> nil then
  begin
    OldState := FInExChange;
    try
      FInExChange := True;

      with TSCComboListbox(FListbox), TSCListStrings(Items) do
      begin
        for I := 0 to Items.Count-1 do
        begin
          if Self.FItemsEx.Count > I then
            Item := Self.FItemsEx[I]
          else
            Item := Self.FItemsEx.Add;

          Item.FState       := DataToState(Data[I, 4]);
          Item.FEnabled     := Data[I, 5] = 0;
          Item.FIndentLevel := Data[I, 6];
          Item.FImageIndex  := Data[I, 7];
        end;

        if Self.FItemsEx.Count > Items.Count then
          for I := Self.FItemsEx.Count-1 downto 0 do
          begin
            if Self.FItemsEx.Count = Items.Count then
              Break;

            {$IFDEF SC_DELPHI4_AND_EARLY}
            Self.FItemsEx[I].Free;
            {$ELSE}
            Self.FItemsEx.Delete(I);
            {$ENDIF}
          end;
      end;
    finally
      FInExChange := OldState;
    end;

    UpdateCheckState;
  end;
end;

procedure TSCCustomComboboxEx.AssignItemsToList;
var
  I, Index: Integer;
  OldUpdate: Boolean;
  Item: TSCComboboxExItem;
  ListChange: TNotifyEvent;
begin
  with TSCComboListbox(FListbox) do
  begin
    OldUpdate := TSCListStrings(Items).InUpdate;
    if not OldUpdate then
      Items.BeginUpdate;

    try
      ListChange := TSCListStrings(Items).OnChange;
      try
        TSCListStrings(Items).OnChange := nil;
        Items.Clear;

        for I := 0 to FItemsEx.Count-1 do
        begin
          Item  := FItemsEx.Items[I];
          Index := TSCListStrings(Items).Add(Item.Text);

          with TSCListStrings(Items) do
          begin
            Data[Index, 4] := StateToData(Item.FState);
            Data[Index, 5] := Integer(not Item.FEnabled);
            Data[Index, 6] := Item.FIndentLevel;
            Data[Index, 7] := Item.FImageIndex;
          end;
        end;
      finally
        TSCListStrings(Items).OnChange := ListChange;
      end;
    finally
      if not OldUpdate then
        Items.EndUpdate;
    end;
  end;
end;

function TSCCustomComboboxEx.CompletedText(const S: String;
  CaseSensitive: Boolean): String;
begin
  Result := FItemsEx.CompletedText(S, CaseSensitive);
end;

constructor TSCCustomComboboxEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItemsEx := TSCComboboxExItems.Create(Self);
  FInExChange := False;
  FShowItemImages := True;
end;

destructor TSCCustomComboboxEx.Destroy;
begin
  FItemsEx.Free;
  inherited Destroy;
end;

procedure TSCCustomComboboxEx.DoExItemChanged(Item: TSCComboboxExItem);
begin
  //
end;

procedure TSCCustomComboboxEx.DoExItemsChanged;
begin
  //
end;

procedure TSCCustomComboboxEx.ExItemChanged(Item: TSCComboboxExItem);
begin
  if FInExChange or ((Item <> nil) and (Item.GetComboboxEx <> Self)) then
    Exit;

  if (Item = nil) or (Item.Index > FItems.Count-1) then
    ExItemsChanged
  else begin
    UpdateCheckState;

    FInExChange := True;
    try
      DoExItemChanged(Item);
    finally
      FInExChange := False;
    end;
  end;  
end;

procedure TSCCustomComboboxEx.ExItemsChanged;
begin
  if FInExChange then
    Exit;

  UpdateCheckState;

  FInExChange := True;
  try
    DoExItemsChanged;
  finally
    FInExChange := False;
  end;
end;

function TSCCustomComboboxEx.GetItemText(Index: Integer): String;
begin
  Result := '';
  if (Index > -1) and (Index < FItemsEx.Count) then
    Result := FItemsEx[Index].FText;
end;

function TSCCustomComboboxEx.GetSelectedItem: TSCComboboxExItem;
var
  Index: Integer;
begin
  Result := nil;
  Index := ItemIndex;

  if (Index > 0) and (Index < FItemsEx.Count) then
    Result := FItemsEx[Index];
end;

function TSCCustomComboboxEx.GetSelectedValue: String;
var
  Index: Integer;
begin
  Result := '';
  Index := ItemIndex;

  if (Index > 0) and (Index < FItemsEx.Count) then
    Result := FItemsEx[Index].Value;
end;

function TSCCustomComboboxEx.IndexOfItem(const S: string): Integer;
begin
  Result := FItemsEx.IndexOf(S, IsDropDown);
end;

function TSCCustomComboboxEx.ItemCheckState(Index: Integer): TSCCheckState;
begin
  Result := sccbUnchecked;
  if (FListBox <> nil) and GetDroppedDown then
    Result := TSCComboListbox(FListBox).State[Index]
  else
  if (Index > -1) and (Index < FItemsEx.Count) then
    Result := FItemsEx[Index].State;
end;

function TSCCustomComboboxEx.ItemCount: Integer;
begin
  Result := FItemsEx.Count;
end;

procedure TSCCustomComboboxEx.SetItemCheckState(Index: Integer;
  Value: TSCCheckState);
begin
  if (FListBox <> nil) and GetDroppedDown then
  begin
    if (Index > -1) and (Index < TSCComboListbox(FListBox).Items.Count) then
      TSCComboListbox(FListBox).State[Index] := Value;
  end else
  if (Index > -1) and (Index < FItemsEx.Count) then
    FItemsEx[Index].State := Value;
end;

procedure TSCCustomComboboxEx.SetItemsEx(Value: TSCComboboxExItems);
begin
  FItemsEx.Assign(Value)
end;

{ TSCComboboxScrollbar }

procedure TSCComboboxScrollbar.Assign(Source: TPersistent);
begin
  if Source is TSCComboboxScrollbar then
    with TSCComboboxScrollbar(Source) do
    begin
      Width := Self.Width;
      Style := Self.Style;
      ThumbLines := Self.ThumbLines;
      ButtonsLayout := Self.ButtonsLayout;
    end;

  inherited Assign(Source);
end;

constructor TSCComboboxScrollbar.Create(AOwner: TSCCustomControl;
  AKind: TSCScrollbarKind);
begin
  inherited Create(AOwner, AKind);
  FWidth := -1;
  FStyle := scssDefault;
  FThumbLines := sctlNone;
  FButtonsLayout := scsbDefault;
end;

procedure TSCComboboxScrollbar.SetWidth(Value: Integer);
begin
  if Value < 0 then Value := -1
  else
  if Value < 12 then Value := 12
  else
  if Value > 36 then Value := 36;

  FWidth := Value;
end;

{ TSCFrameEditBorderProps }

constructor TSCFrameEditBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccbNone;
  Color := clWindow;
end;

{ TSCFrameEditColors }

procedure TSCCustomFrameEditColors.Assign(Source: TPersistent);
begin
  if Source is TSCCustomFrameEditColors then
    with TSCCustomFrameEditColors(Source) do
    begin
      Self.FrameColor := FrameColor;
      Self.ExUseColor := ExUseColor;
    end;

  inherited Assign(Source);
end;

function TSCCustomFrameEditColors.GetFrameColor: TColor;
begin
  Result := clNone;
  if (Owner <> nil) and (Owner is TSCCustomFrameEdit) then
    Result := TSCCustomFrameEdit(Owner).FrameColor;
end;

function TSCCustomFrameEditColors.GetExUseColor: TColor;
begin
  Result := clNone;
  if (Owner <> nil) and (Owner is TSCCustomFrameEdit) then
    Result := TSCCustomFrameEdit(Owner).ExUseColor;
end;

procedure TSCCustomFrameEditColors.SetFrameColor(Value: TColor);
begin
  if (Owner <> nil) and (Owner is TSCCustomFrameEdit) then
    TSCCustomFrameEdit(Owner).FrameColor := Value;
end;

procedure TSCCustomFrameEditColors.SetExUseColor(Value: TColor);
begin
  if (Owner <> nil) and (Owner is TSCCustomFrameEdit) then
    TSCCustomFrameEdit(Owner).ExUseColor := Value;
end;

{ TSCCustomDropButtonProps }

procedure TSCCustomDropButtonProps.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDropButtonProps then
  begin
    with TSCCustomDropButtonProps(Source) do
    begin
      ArrowColor := ArrowColor;
      Color := Color;
      Image := Image;
      Style := Style;
      Visible := Visible;
      Width := Width;
    end;
  end;
end;

function TSCCustomDropButtonProps.GetArrowColor: TColor;
begin
  Result := clBtnText;
  if (Owner <> nil) and (Owner is TSCCustomDropDown) then
    Result := TSCCustomDropDown(Owner).ButtonArrowColor;
end;

function TSCCustomDropButtonProps.GetColor: TColor;
begin
  Result := clBtnFace;
  if (Owner <> nil) and (Owner is TSCCustomDropDown) then
    Result := TSCCustomDropDown(Owner).ButtonColor;
end;

function TSCCustomDropButtonProps.GetImage: TImageIndex;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCCustomDropDown) then
    Result := TSCCustomDropDown(Owner).ButtonImage;
end;

function TSCCustomDropButtonProps.GetStyle: TSCEditButtonStyle;
begin
  Result := scebDropDown;
  if (Owner <> nil) and (Owner is TSCCustomDropDown) then
    Result := TSCCustomDropDown(Owner).ButtonStyle;
end;

function TSCCustomDropButtonProps.GetVisible: Boolean;
begin
  Result := True;
  if (Owner <> nil) and (Owner is TSCCustomDropDown) then
    Result := TSCCustomDropDown(Owner).ButtonVisible;
end;

function TSCCustomDropButtonProps.GetWidth: Integer;
begin
  Result := -1;
  if (Owner <> nil) and (Owner is TSCCustomDropDown) then
    Result := TSCCustomDropDown(Owner).ButtonWidth;
end;

procedure TSCCustomDropButtonProps.SetArrowColor(Value: TColor);
begin
  if (Owner <> nil) and (Owner is TSCCustomDropDown) then
    TSCCustomDropDown(Owner).ButtonArrowColor := Value;
end;

procedure TSCCustomDropButtonProps.SetColor(Value: TColor);
begin
  if (Owner <> nil) and (Owner is TSCCustomDropDown) then
    TSCCustomDropDown(Owner).ButtonColor := Value;
end;

procedure TSCCustomDropButtonProps.SetImage(Value: TImageIndex);
begin
  if (Owner <> nil) and (Owner is TSCCustomDropDown) then
    TSCCustomDropDown(Owner).ButtonImage := Value;
end;

procedure TSCCustomDropButtonProps.SetStyle(Value: TSCEditButtonStyle);
begin
  if (Owner <> nil) and (Owner is TSCCustomDropDown) then
    TSCCustomDropDown(Owner).ButtonStyle := Value;
end;

procedure TSCCustomDropButtonProps.SetVisible(Value: Boolean);
begin
  if (Owner <> nil) and (Owner is TSCCustomDropDown) then
    TSCCustomDropDown(Owner).ButtonVisible := Value;
end;

procedure TSCCustomDropButtonProps.SetWidth(Value: Integer);
begin
  if (Owner <> nil) and (Owner is TSCCustomDropDown) then
    TSCCustomDropDown(Owner).ButtonWidth := Value;
end;

{ TSCEditButtonProps }

procedure TSCEditButtonProps.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  
  if Source is TSCEditButtonProps then
  begin
    with TSCEditButtonProps(Source) do
      Self.ClickKey := ClickKey;
  end;
end;

function TSCEditButtonProps.GetClickKey: TShortCut;
begin
  Result := scNone;
  if (Owner <> nil) and (Owner is TSCCustomButtonEdit) then
    Result := TSCCustomButtonEdit(Owner).ButtonClickKey;
end;

procedure TSCEditButtonProps.SetClickKey(Value: TShortCut);
begin
  if (Owner <> nil) and (Owner is TSCCustomButtonEdit) then
    TSCCustomButtonEdit(Owner).ButtonClickKey := Value;
end;

{ TSCCustomEditButtonProps }

procedure TSCCustomEditButtonProps.Assign(Source: TPersistent);
begin
  if Source is TSCCustomEditButtonProps then
  begin
    with TSCCustomEditButtonProps(Source) do
      Self.InsideFrame := InsideFrame;
  end else
    inherited Assign(Source);
end;

constructor TSCCustomEditButtonProps.Create(AOwner: TSCCustomButtonFrame);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCCustomEditButtonProps.GetInsideFrame: Boolean;
begin
  Result := True;
  if FOwner <> nil then
    Result := FOwner.ButtonInsideFrame;
end;

function TSCCustomEditButtonProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCCustomEditButtonProps.SetInsideFrame(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.ButtonInsideFrame := Value;
end;

{ TSCComboboxCustomPopupProps }

procedure TSCComboboxCustomPopupProps.Assign(Source: TPersistent);
begin
  if Source is TSCComboboxCustomPopupProps then
  begin
    with TSCComboboxCustomPopupProps(Source) do
    begin
      Self.BorderStyle := BorderStyle;
      Self.Color := Color;
      Self.Font := Font;
      Self.MaxHeight := MaxHeight;
      Self.MaxWidth := MaxWidth;
      Self.MinHeight := MinHeight;
      Self.MinWidth := MinWidth;
      Self.Scrollbar := Scrollbar;
      Self.ShowSizeGrip := ShowSizeGrip;
      Self.ShowStatusbar := ShowStatusbar;
      Self.StatusbarColor := StatusbarColor;
      Self.StatusbarText := StatusbarText;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCComboboxCustomPopupProps.Create(AOwner: TSCCustomCombobox);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCComboboxCustomPopupProps.GetBorderStyle: TSCEditStyle;
begin
  Result := scesDefault;
  if FOwner <> nil then
    Result := FOwner.PopupBorderStyle;
end;

function TSCComboboxCustomPopupProps.GetColor: TColor;
begin
  Result := clWindow;
  if FOwner <> nil then
    Result := FOwner.DropDownColor;
end;

function TSCComboboxCustomPopupProps.GetFont: TFont;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.DropDownFont;
end;

function TSCComboboxCustomPopupProps.GetMaxHeight: Integer;
begin
  Result := 0;
  if FOwner <> nil then
    Result := FOwner.MaxPopupHeight;
end;

function TSCComboboxCustomPopupProps.GetMaxWidth: Integer;
begin
  Result := 0;
  if FOwner <> nil then
    Result := FOwner.MaxPopupWidth;
end;

function TSCComboboxCustomPopupProps.GetMinHeight: Integer;
begin
  Result := 0;
  if FOwner <> nil then
    Result := FOwner.MinPopupHeight;
end;

function TSCComboboxCustomPopupProps.GetMinWidth: Integer;
begin
  Result := 0;
  if FOwner <> nil then
    Result := FOwner.MinPopupWidth;
end;

function TSCComboboxCustomPopupProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCComboboxCustomPopupProps.GetScrollbar: TSCComboboxScrollbar;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.Scrollbar;
end;

function TSCComboboxCustomPopupProps.GetShowSizeGrip: Boolean;
begin
  Result := True;
  if FOwner <> nil then
    Result := FOwner.ShowSizeGrip;
end;

function TSCComboboxCustomPopupProps.GetShowStatusbar: Boolean;
begin
  Result := False;
  if FOwner <> nil then
    Result := FOwner.ShowStatusbar;
end;

function TSCComboboxCustomPopupProps.GetStatusbarAlignment: TAlignment;
begin
  Result := taLeftJustify;
  if FOwner <> nil then
    Result := FOwner.StatusbarAlignment;
end;

function TSCComboboxCustomPopupProps.GetStatusbarColor: TColor;
begin
  Result := clBtnFace;
  if FOwner <> nil then
    Result := FOwner.StatusbarColor;
end;

function TSCComboboxCustomPopupProps.GetStatusbarText: String;
begin
  Result := '';
  if FOwner <> nil then
    Result := FOwner.StatusbarText;
end;

procedure TSCComboboxCustomPopupProps.SetBorderStyle(Value: TSCEditStyle);
begin
  if FOwner <> nil then
    FOwner.PopupBorderStyle := Value;
end;

procedure TSCComboboxCustomPopupProps.SetColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.DropDownColor := Value;
end;

procedure TSCComboboxCustomPopupProps.SetFont(Value: TFont);
begin
  if FOwner <> nil then
    FOwner.DropDownFont := Value;
end;

procedure TSCComboboxCustomPopupProps.SetMaxHeight(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.MaxPopupHeight := Value;
end;

procedure TSCComboboxCustomPopupProps.SetMaxWidth(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.MaxPopupWidth := Value;
end;

procedure TSCComboboxCustomPopupProps.SetMinHeight(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.MinPopupHeight := Value;
end;

procedure TSCComboboxCustomPopupProps.SetMinWidth(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.MinPopupWidth := Value;
end;

procedure TSCComboboxCustomPopupProps.SetScrollbar(Value: TSCComboboxScrollbar);
begin
  if FOwner <> nil then
    FOwner.Scrollbar := Value;
end;

procedure TSCComboboxCustomPopupProps.SetShowSizeGrip(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.ShowSizeGrip := Value;
end;

procedure TSCComboboxCustomPopupProps.SetShowStatusbar(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.ShowStatusbar := Value;
end;

procedure TSCComboboxCustomPopupProps.SetStatusbarAlignment(
  Value: TAlignment);
begin
  if FOwner <> nil then
    FOwner.StatusbarAlignment := Value;
end;

procedure TSCComboboxCustomPopupProps.SetStatusbarColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.StatusbarColor := Value;
end;

procedure TSCComboboxCustomPopupProps.SetStatusbarText(Value: String);
begin
  if FOwner <> nil then
    FOwner.StatusbarText := Value;
end;

procedure TSCCustomFrameEditColors.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('WinXPColor', ReadXPColor, WriteXPColor, False);
end;

procedure TSCCustomFrameEditColors.ReadXPColor(Reader: TReader);
begin
  try
    Self.ExUseColor := StringToColor(Reader.ReadIdent);
  except
  end;
end;

procedure TSCCustomFrameEditColors.WriteXPColor(Writer: TWriter);
begin
  //
end;

{$I SCVerRec.inc}

end.
