{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCDbEdits;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DbConsts, SCConsts, SCCommon, SCDbCommon, SCControl, SCStdControls,
  SCDbCtrls, SCMaskEdit, SCAdvEdits, SCSpinEdits, SCDateTimeControls,
  SCCalculator;

type
  TSCCustomDBButtonEdit = class(TSCCustomButtonEdit)
  private
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FDataLink: TSCFieldDataLink;
    FSettingText: Integer;
    FExternalMask: Boolean;
    FSettingDataMask: Integer;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetDataField: string;
    procedure SetDataField(const Value: string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    procedure SetFocused(Value: Boolean);

    procedure SetMask(Value: String);

    procedure ResetEditMask;
    procedure ResetMaxLength;

    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  CanAlignText(var Value: TAlignment): Boolean; override;
    function  GetDbAlignment: TAlignment; dynamic;
    procedure UpdateAlignment; virtual;
    function  GetLineText(Index: Integer): String; override;

    function  IsMaskStored: Boolean; override;
    procedure MaskChanged; override;
    function  CanRaiseMaskError: Boolean; override;

    procedure UpdateFieldData; dynamic;
    procedure BeforeExit; override;

    function  GetReadOnly: Boolean; reintroduce;
    procedure SetReadOnly(Value: Boolean); reintroduce;

    function  GetButtonClass: TSCEditButtonClass; override;
    procedure UpdateBorderRect(var R: TRect); override;

    procedure DoChange; override;
    function  EditCanModify: Boolean; override;
    procedure Reset; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    function  IsValidKey(Key: Char): Boolean; override;

    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Text;    
    property Field: TField read GetField;
  end;

  TSCDBButtonEdit = class(TSCCustomDBButtonEdit)  
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoAlignment;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property Button;
    property ButtonClickKey;
    property CanDragSelection;
    property CanEdit;
    property CanSelect;
    property CharCase;
    property Checkbox;
    property Color;
    property Colors;
    property Constraints;
    property DataField;
    property DataSource;
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

  TSCCustomDBHyperlinkEdit = class(TSCCustomHyperlinkEdit)
  private
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FDataLink: TSCFieldDataLink;
    FSettingText: Integer;
    FExternalMask: Boolean;
    FSettingDataMask: Integer;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetDataField: string;
    procedure SetDataField(const Value: string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    procedure SetFocused(Value: Boolean);

    procedure SetMask(Value: String);

    procedure ResetEditMask;
    procedure ResetMaxLength;

    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  CanAlignText(var Value: TAlignment): Boolean; override;
    function  GetDbAlignment: TAlignment; dynamic;
    procedure UpdateAlignment; virtual;
    function  GetLineText(Index: Integer): String; override;

    function  IsMaskStored: Boolean; override;
    procedure MaskChanged; override;
    function  CanRaiseMaskError: Boolean; override;

    procedure UpdateFieldData; dynamic;
    procedure BeforeExit; override;

    function  GetReadOnly: Boolean; reintroduce;
    procedure SetReadOnly(Value: Boolean); reintroduce;

    procedure DoChange; override;
    function  EditCanModify: Boolean; override;
    procedure Reset; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    function  IsValidKey(Key: Char): Boolean; override;

    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Text;
    property Field: TField read GetField;
  end;

  TSCDBHyperlinkEdit = class(TSCCustomDBHyperlinkEdit)  
  published
    property ActivateCursor;
    property ActivateKey;
    property Align;
    property Alignment;
    property Anchors;
    property AutoAlignment;
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
    property DataField;
    property DataSource;
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
    property SingleClick;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseCaret;
    property UseImage;
    property UseUndo;
    property UndoLimit;
    property Visible;
    property OnCanResize;
    property OnCaretMove;
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

  TSCCustomDBIntSpinEdit = class(TSCCustomIntSpinEdit)
  private
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FInvalidText: TSCDbInvalidText;
    FDataLink: TSCFieldDataLink;
    FSettingText: Integer;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetDataField: string;
    procedure SetDataField(const Value: string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    procedure SetFocused(Value: Boolean);
    procedure SetInvalidText(Value: TSCDbInvalidText);

    procedure ResetMaxLength;

    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  CanAlignText(var Value: TAlignment): Boolean; override;
    function  GetDbAlignment: TAlignment; dynamic;
    procedure UpdateAlignment; virtual;
    function  GetLineText(Index: Integer): String; override;

    procedure UpdateFieldData; dynamic;
    procedure BeforeExit; override;

    function  GetReadOnly: Boolean; reintroduce;
    procedure SetReadOnly(Value: Boolean); reintroduce;

    function  CanDoKeySpin: Boolean; override;

    procedure DoChange; override;
    procedure Reset; override;

    procedure DoButtonClick(Btn: TSCEditButton); override;
    procedure DoPageUp(var Key: Word); override;
    procedure DoPageDown(var Key: Word); override;

    function  EditCanModify: Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function  IsValidKey(Key: Char): Boolean; override;
    function  ArrangeText(const S: String): String; override;
    procedure UpdateValueFromText; override;

    function  CanSetValue(var Value: LongInt): Boolean; override;
    function  GetUnIntValue: LongInt; override;
    function  GetIntValue: LongInt; override;

    property Alignment default taRightJustify;
    property AllowEmpty default True;
    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property InvalidText: TSCDbInvalidText read FInvalidText write SetInvalidText default scitAuto;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Text;
    property IntValue;
    property Field: TField read GetField;
  end;

  TSCDBIntSpinEdit = class(TSCCustomDBIntSpinEdit)
  published
    property Align;
    property Alignment;
    property AllowEmpty;
    property Anchors;
    property AutoAlignment;
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
    property DataField;
    property DataSource;
    property Delimeters;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EditCursor;
    property Enabled;
    property EditMode;
    property EnterAsTab;
    property FocusExpandSize;
    property Font;
    property HexMode;
    property HideSelection;
    property ImageIndex;
    property Images;
    property ImeMode;
    property ImeName;
    property InsertChangesEditMode;
    property InvalidText;
    property KeySpin;
    property LargeIncrement;
    property Layout;
    property Increment;
    property MinValue;
    property MaxLength;
    property MaxValue;
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
    property UseCaret;
    property UseDelimeters;
    property UseImage;
    property UseThousandsSeparator;
    property UseUndo;
    property UndoLimit;
    property Visible;
    property OnCanResize;
    property OnCaretMove;
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

  TSCCustomDBSpinnerEdit = class(TSCCustomSpinnerEdit)
  private
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FInvalidText: TSCDbInvalidText;
    FDataLink: TSCFieldDataLink;
    FSettingText: Integer;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetDataField: string;
    procedure SetDataField(const Value: string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    procedure SetFocused(Value: Boolean);
    procedure SetInvalidText(Value: TSCDbInvalidText);

    procedure ResetMaxLength;

    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  CanAlignText(var Value: TAlignment): Boolean; override;
    function  GetDbAlignment: TAlignment; dynamic;
    procedure UpdateAlignment; virtual;
    function  GetLineText(Index: Integer): String; override;

    procedure UpdateFieldData; dynamic;
    procedure BeforeExit; override;

    function  GetReadOnly: Boolean; reintroduce;
    procedure SetReadOnly(Value: Boolean); reintroduce;

    function  CanDoKeySpin: Boolean; override;

    procedure DoChange; override;
    function  EditCanModify: Boolean; override;
    procedure Reset; override;

    procedure DoButtonClick(Btn: TSCEditButton); override;
    procedure DoPageUp(var Key: Word); override;
    procedure DoPageDown(var Key: Word); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function  IsValidKey(Key: Char): Boolean; override;
    function  ArrangeText(const S: String): String; override;
    procedure UpdateValueFromText; override;

    function  GetUnIntValue: LongInt; override;
    function  GetIntValue: LongInt; override;

    property AllowEmpty default True;
    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property InvalidText: TSCDbInvalidText read FInvalidText write SetInvalidText default scitAuto;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Text;
    property IntValue;
    property Field: TField read GetField;
  end;

  TSCDBSpinnerEdit = class(TSCCustomDBSpinnerEdit)
  published
    property Align;
    property Alignment;
    property AllowEmpty;
    property Anchors;
    property AutoAlignment;
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
    property DataField;
    property DataSource;
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
    property HexMode;
    property HideSelection;
    property ImageIndex;
    property Images;
    property ImeMode;
    property ImeName;
    property InsertChangesEditMode;
    property InvalidText;
    property KeySpin;
    property LargeIncrement;
    property Layout;
    property Increment;
    property MinValue;
    property MaxLength;
    property MaxValue;
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
    property UseCaret;
    property UseDelimeters;
    property UseImage;
    property UseThousandsSeparator;
    property UseUndo;
    property UndoLimit;
    property Visible;
    property OnCanResize;
    property OnCaretMove;
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

  TSCCustomDBFloatSpinEdit = class(TSCCustomFloatSpinEdit)
  private
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FInvalidText: TSCDbInvalidText;
    FDataLink: TSCFieldDataLink;
    FSettingText: Integer;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetDataField: string;
    procedure SetDataField(const Value: string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    procedure SetFocused(Value: Boolean);
    procedure SetInvalidText(Value: TSCDbInvalidText);

    procedure ResetMaxLength;

    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  CanAlignText(var Value: TAlignment): Boolean; override;
    function  GetDbAlignment: TAlignment; dynamic;
    procedure UpdateAlignment; virtual;
    function  GetLineText(Index: Integer): String; override;

    procedure UpdateFieldData; dynamic;
    procedure BeforeExit; override;

    function  GetReadOnly: Boolean; reintroduce;
    procedure SetReadOnly(Value: Boolean); reintroduce;

    function  CanDoKeySpin: Boolean; override;

    procedure DoChange; override;
    function  EditCanModify: Boolean; override;
    procedure Reset; override;

    procedure DoButtonClick(Btn: TSCEditButton); override;
    procedure DoPageUp(var Key: Word); override;
    procedure DoPageDown(var Key: Word); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function  IsValidKey(Key: Char): Boolean; override;
    function  ArrangeText(const S: String): String; override;
    function  CanSetValue(var Value: Double): Boolean; override;
    procedure UpdateValueFromText; override;

    function  GetUnFloatValue: Double; override;
    function  GetFloatValue: Double; override;

    property Alignment default taRightJustify;
    property AllowEmpty default True;
    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property InvalidText: TSCDbInvalidText read FInvalidText write SetInvalidText default scitAuto;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Text;
    property FloatValue;
    property Field: TField read GetField;
  end;

  TSCDBFloatSpinEdit = class(TSCCustomDBFloatSpinEdit)
  published
    property Align;
    property Alignment;
    property AllowEmpty;
    property Anchors;
    property AutoAlignment;
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
    property DataField;
    property DataSource;
    property DecimalPlaces;
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
    property LargeIncrement;
    property Increment;
    property InvalidText;
    property Layout;
    property MinValue;
    property MaxLength;
    property MaxValue;
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
    property UseCaret;
    property UseDelimeters;
    property UseImage;
    property UseThousandsSeparator;
    property UseUndo;
    property UndoLimit;
    property Visible;
    property OnCanResize;
    property OnCaretMove;
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

  TSCCustomDBCurrencySpinEdit = class(TSCCustomCurrencyEdit)
  private
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FInvalidText: TSCDbInvalidText;
    FSettingText: Integer;
    FDataLink: TSCFieldDataLink;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetDataField: string;
    procedure SetDataField(const Value: string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    procedure SetFocused(Value: Boolean);
    procedure SetInvalidText(Value: TSCDbInvalidText);

    procedure ResetMaxLength;

    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  CanAlignText(var Value: TAlignment): Boolean; override;
    function  GetDbAlignment: TAlignment; dynamic;
    procedure UpdateAlignment; virtual;
    function  GetLineText(Index: Integer): String; override;

    procedure UpdateFieldData; dynamic;
    procedure BeforeExit; override;

    function  GetReadOnly: Boolean; reintroduce;
    procedure SetReadOnly(Value: Boolean); reintroduce;

    function  CanDoKeySpin: Boolean; override;

    procedure DoChange; override;
    function  EditCanModify: Boolean; override;
    procedure Reset; override;

    procedure DoButtonClick(Btn: TSCEditButton); override;
    procedure DoPageUp(var Key: Word); override;
    procedure DoPageDown(var Key: Word); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function  IsValidKey(Key: Char): Boolean; override;
    function  ArrangeText(const S: String): String; override;
    function  CanSetValue(var Value: Double): Boolean; override;
    procedure UpdateValueFromText; override;

    function  GetUnFloatValue: Double; override;

    property Alignment default taRightJustify;
    property AllowEmpty default True;
    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property InvalidText: TSCDbInvalidText read FInvalidText write SetInvalidText default scitAuto;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Text;
    property FloatValue;
    property Field: TField read GetField;
  end;

  TSCDBCurrencySpinEdit = class(TSCCustomDBCurrencySpinEdit)
  published
    property Align;
    property Alignment;
    property AllowEmpty;
    property Anchors;
    property AutoAlignment;
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
    property CurrencySymbol;
    property DataField;
    property DataSource;
    property DecimalPlaces;
    property Delimeters;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EditCursor;
    property EditFormat;
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
    property InvalidText;
    property KeySpin;
    property LargeIncrement;
    property Layout;
    property Increment;
    property MinValue;
    property MaxLength;
    property MaxValue;
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
    property UseCaret;
    property UseDelimeters;
    property UseImage;
    property UseUndo;
    property UseNegativeCurrency;
    property UseThousandsSeparator;
    property UndoLimit;
    property Visible;
    property OnCanResize;
    property OnCaretMove;
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

  TSCCustomDBPopupCalendar = class(TSCCustomPopupCalendar)
  private
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FSettingText: Integer;
    FDataLink: TSCFieldDataLink;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetDataField: string;
    procedure SetDataField(const Value: string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    procedure SetFocused(Value: Boolean);

    procedure ResetMaxLength;

    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  CanAlignText(var Value: TAlignment): Boolean; override;
    function  GetDbAlignment: TAlignment; dynamic;
    procedure UpdateAlignment; virtual;

    function  GetLineText(Index: Integer): String; override;
    function  GetDescriptionText: String; override;

    procedure UpdateFieldData; dynamic;
    procedure BeforeExit; override;

    function  GetReadOnly: Boolean; reintroduce;
    procedure SetReadOnly(Value: Boolean); reintroduce;

    procedure DoValidationError(var ADate: TDateTime; var ErrorText: String;
      var RaiseError: Boolean); override;

    procedure DoChange; override;
    procedure DoDateChange; override;
    function  EditCanModify: Boolean; override;
    procedure Reset; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    procedure SetText(Value: TCaption); override;
    function  IsValidKey(Key: Char): Boolean; override;
    function  ArrangeText(const S: String): String; override;

    function  CanDropDown: Boolean; override;

    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DateValidation default scdvRaiseError;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Date;
    property Field: TField read GetField;
  end;

  TSCDBPopupCalendar = class(TSCCustomDBPopupCalendar)  
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoAlignment;
    property AutoComplete;
    property AutoSelect;
    property AutoSize;
    property BorderProps;
    property ButtonStyle;
    property ButtonProps;
    property CalendarProps;
    property CanDragSelection;
    property CanEdit;
    property CanSelect;
    property Checkbox;
    property Colors;
    property Constraints;
    property DataField;
    property DataSource;
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
  
  TSCCustomDBTimeEdit = class(TSCCustomTimeEdit)
  private
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FDataLink: TSCFieldDataLink;
    FSettingText: Integer;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetDataField: string;
    procedure SetDataField(const Value: string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    procedure SetFocused(Value: Boolean);

    procedure ResetMaxLength;

    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  CanAlignText(var Value: TAlignment): Boolean; override;
    function  GetDbAlignment: TAlignment; dynamic;
    procedure UpdateAlignment; virtual;

    function  GetLineText(Index: Integer): String; override;
    function  GetDescriptionText: String; override;

    procedure UpdateFieldData; dynamic;
    procedure BeforeExit; override;

    function  GetReadOnly: Boolean; reintroduce;
    procedure SetReadOnly(Value: Boolean); reintroduce;

    procedure DoChange; override;
    function  EditCanModify: Boolean; override;
    procedure Reset; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function  IsValidKey(Key: Char): Boolean; override;
    function  ArrangeText(const S: String): String; override;

    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Time;
    property Field: TField read GetField;
  end;

  TSCDBTimeEdit = class(TSCCustomDBTimeEdit)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoAlignment;
    property AutoComplete;
    property AutoSelect;
    property AutoSize;
    property BorderProps;
    property Checkbox;
    property CanSelect;
    property Colors;
    property Constraints;
    property DataField;
    property DataSource;
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
    property FocusExpandSize;
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
    property ShowPicture;
    property Style;
    property TabOrder;
    property TabStop;
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
  
  TSCCustomDBPopupCalculator = class(TSCCustomPopupCalculator)
  private
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FInvalidText: TSCDbInvalidText;
    FDataLink: TSCFieldDataLink;
    FSettingText: Integer;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetDataField: string;
    procedure SetDataField(const Value: string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    procedure SetFocused(Value: Boolean);
    procedure SetInvalidText(Value: TSCDbInvalidText);

    procedure ResetMaxLength;

    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  CanAlignText(var Value: TAlignment): Boolean; override;
    function  GetDbAlignment: TAlignment; dynamic;
    procedure UpdateAlignment; virtual;
    function  GetLineText(Index: Integer): String; override;

    procedure UpdateFieldData; dynamic;
    procedure BeforeExit; override;

    function  GetReadOnly: Boolean; reintroduce;
    procedure SetReadOnly(Value: Boolean); reintroduce;

    procedure AfterCloseUp; override;
    procedure DoChange; override;
    function  EditCanModify: Boolean; override;
    procedure Reset; override;

    procedure DoButtonClick(Btn: TSCEditButton); override;
    function  CanDropDown: Boolean; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function  IsValidKey(Key: Char): Boolean; override;
    function  ArrangeText(const S: String): String; override;
    function  CanSetValue(var Value: Extended): Boolean; override;
    procedure UpdateValueFromText; override;

    function  GetFloatValue: Extended; override;

    property AllowEmpty default True;
    property Alignment default taRightJustify;
    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property InvalidText: TSCDbInvalidText read FInvalidText write SetInvalidText default scitAuto;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Text;
    property FloatValue;
    property Field: TField read GetField;
  end;

  TSCDBPopupCalculator = class(TSCCustomDBPopupCalculator)
  published
    property Align;
    property Alignment;
    property AllowEmpty;
    property Anchors;
    property AutoAlignment;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property ButtonProps;
    property CalculatorProps;
    property CanDragSelection;
    property CanEdit;
    property CanSelect;
    property CharCase;
    property Checkbox;
    property Color;
    property Colors;
    property Constraints;
    property DataField;
    property DataSource;
    property DecimalPlaces;
    property Delimeters;
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
    property ImeMode;
    property ImeName;
    property InsertChangesEditMode;
    property IsDropDown;
    property InvalidText;
    property Layout;
    property MaxLength;
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
    property UseCaret;
    property UseDefaultMenu;
    property UseDelimeters;
    property UseImage;
    property UseThousandsSeparator;
    property UseUndo;
    property UndoLimit;
    property Visible;
    property OnCanResize;
    property OnCaretMove;
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

  TSCCustomDBComboBoxEx = class(TSCCustomComboboxEx)
  private
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FDataLink: TSCFieldDataLink;
    FSettingText: Integer;
    FUseValues: Boolean;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetComboText: string;
    procedure SetComboText(const Value: string);
    function  GetDataField: string;
    procedure SetDataField(const Value: string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    procedure SetEditReadOnly;
    procedure SetFocused(Value: Boolean);
    procedure SetUseValues(Value: Boolean);

    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Loaded; override;
    procedure CreateWnd; override;

    function  CanAlignText(var Value: TAlignment): Boolean; override;
    function  GetDbAlignment: TAlignment; dynamic;
    procedure UpdateAlignment; virtual;
    function  GetLineText(Index: Integer): String; override;

    procedure BeforeExit; override;
    function  CanDropDown: Boolean; override;

    function  GetReadOnly: Boolean; reintroduce;
    procedure SetReadOnly(Value: Boolean); reintroduce;

    procedure DoChange; override;
    procedure DoItemChanging(Index: Integer); override;
    procedure DoListClick(Index: Integer; const Item: String); override;
    procedure SetItems(Value: TStrings); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property UseValues: Boolean read FUseValues write SetUseValues default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Text;
    property Field: TField read GetField;
  end;

  TSCDBComboBoxEx = class(TSCCustomDBComboBoxEx)
  published
    property Anchors;
    property Align;
    property Alignment;
    property AutoAlignment;
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
    property Color;
    property Colors;
    property Constraints;
    property DataField;
    property DataSource;
    property DblClickReverts;
    property Delimeters;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownKey;
    property EditCursor;
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
    property PopupProps;
    property ReadOnly;
    property Revertable;
    property ShowCheckboxes;
    property ShowHint;
    property ShowItemImages;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UndoLimit;
    property UseImage;
    property UseUndo;
    property UseValues;
    property Values;
    property Visible;
    property OnBrowseClick;
    property OnCanResize;
    property OnCaretMove;
    property OnChange;
    property OnClick;
    property OnClipCopy;
    property OnClipCut;
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

implementation

uses SCEdits;

type
  TSCDBEditButton = class(TSCEditButton);

{ TSCCustomDBButtonEdit }

procedure TSCCustomDBButtonEdit.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

constructor TSCCustomDBButtonEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];

  FAutoAlignment := True;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
end;

destructor TSCCustomDBButtonEdit.Destroy;
begin
  FreeAndNil(FDataLink);
  inherited Destroy;
end;

procedure TSCCustomDBButtonEdit.Loaded;
begin
  inherited Loaded;
  ResetMaxLength;
  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBButtonEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBButtonEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBButtonEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (FDataLink <> nil) and ((Key = VK_DELETE) or 
    ((Key = VK_INSERT) and (ssShift in Shift))) then
    FDataLink.Edit;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBButtonEdit.KeyPress(var Key: Char);
begin
  if (Key in [#32..#255]) and (FDataLink <> nil) and
    (FDataLink.Field <> nil) and not FDataLink.Field.IsValidChar(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;

  inherited KeyPress(Key);
end;

function TSCCustomDBButtonEdit.EditCanModify: Boolean;
begin
  Result := (FDataLink <> nil) and FDataLink.Edit;
end;

procedure TSCCustomDBButtonEdit.Reset;
begin
  if FDataLink <> nil then
    FDataLink.Reset;
  SelectAll;
end;

function TSCCustomDBButtonEdit.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBButtonEdit.SetDataSource(Value: TDataSource);
begin
  if (FDataLink <> nil) and
    not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;    
end;

function TSCCustomDBButtonEdit.GetDataField: string;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBButtonEdit.SetDataField(const Value: string);
begin
  if not IsDesigning then
  begin
    ResetEditMask;
    ResetMaxLength;
  end;
  
  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBButtonEdit.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBButtonEdit.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBButtonEdit.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBButtonEdit.ActiveChange(Sender: TObject);
begin
  if (FDataLink = nil) or not FDataLink.Active then
  begin
    ResetEditMask;
    ResetMaxLength;
  end;
end;

procedure TSCCustomDBButtonEdit.DataChange(Sender: TObject);
begin
  UpdateAlignment;
  Inc(FSettingText);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      SetMask(FDataLink.Field.EditMask);

      if not IsDesigning then
      begin
        if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
          MaxLength := FDataLink.Field.Size;
      end;

      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else begin
        Text := FDataLink.Field.DisplayText;
        if FDataLink.Editing and FDataLink.GetModified then
          Modified := True;
      end;
    end else
    begin
      SetMask('');

      if (EditMask = '') and IsDesigning then
        Text := Name
      else
        Text := '';
    end;
  finally
    Dec(FSettingText);
  end;
end;

procedure TSCCustomDBButtonEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := (FDataLink = nil) or not FDataLink.Editing;
end;

procedure TSCCustomDBButtonEdit.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  UpdateFieldData;
end;

procedure TSCCustomDBButtonEdit.WMUndo(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBButtonEdit.WMPaste(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBButtonEdit.WMCut(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBButtonEdit.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and (FDataLink <> nil) and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBButtonEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBButtonEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBButtonEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBButtonEdit.DoChange;
begin
  if not SettingMask and (FSettingText = 0) and (FDataLink <> nil) and
    not (IsLoading or IsDesigning) then
  begin
    FDataLink.Edit;
    FDataLink.Modified;

    if not HasFocus then
      UpdateFieldData;
  end;

  inherited DoChange;
end;

function TSCCustomDBButtonEdit.IsValidKey(Key: Char): Boolean;
begin
  Result := False;
  if EditCanModify then
    Result := inherited IsValidKey(Key);
end;

function TSCCustomDBButtonEdit.GetButtonClass: TSCEditButtonClass;
begin
  Result := TSCStyledEditButton;
end;

procedure TSCCustomDBButtonEdit.UpdateBorderRect(var R: TRect);
var
  W, RI, LI: Integer;
  Btn: TSCDBEditButton;
begin
  inherited UpdateBorderRect(R);

  RI := 0;
  LI := 0;

  Btn := TSCDBEditButton(BrowseButton);
  if (Btn <> nil) and Btn.Visible and (Btn.Width <> 0) then
  begin
    W := Btn.GetWidth;
    if Btn.Align = taLeftJustify then
      Inc(LI, W)
    else Inc(RI, W);
  end;

  Btn := TSCDBEditButton(Button);
  if (Btn <> nil) and Btn.Visible and (Btn.Width <> 0) then
  begin
    W := Btn.GetWidth;
    if Btn.Align = taLeftJustify then
      Inc(LI, W)
    else Inc(RI, W);
  end;

  Inc(R.Left,  LI);
  Inc(R.Right, RI);
end;

procedure TSCCustomDBButtonEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

procedure TSCCustomDBButtonEdit.BeforeExit;
begin
  inherited BeforeExit;
  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SelectAll;
      SetFocus;
      raise;
    end;
  end;
  SetFocused(False);
  // DoExit;
end;

procedure TSCCustomDBButtonEdit.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBButtonEdit.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

function TSCCustomDBButtonEdit.GetDbAlignment: TAlignment;
var
  ExStyle: DWORD;
begin
  Result := taLeftJustify;
  if not FFocused and (FDataLink <> nil) and (FDataLink.Field <> nil) then
    Result := FDataLink.Field.Alignment;

  if UseRightToLeftAlignment then ChangeBiDiModeAlignment(Result);

  if ((Result = taLeftJustify) or FFocused) and
    SysLocale.MiddleEast and HandleAllocated and IsRightToLeft then
  begin
    ExStyle := AlignStyle[UseRightToLeftAlignment, Result];

    Result := taLeftJustify;
    if ExStyle = WS_EX_RIGHT then
      Result := taRightJustify;
  end;
end;

function TSCCustomDBButtonEdit.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBButtonEdit.UpdateFieldData;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Field.Text := Text;
end;

procedure TSCCustomDBButtonEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBButtonEdit then
  begin
    with TSCCustomDBButtonEdit(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
    end;
  end;
end;

procedure TSCCustomDBButtonEdit.ResetEditMask;
var
  F: TField;
begin
  if Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.EditMask = EditMask) then
      SetMask('');
  end;
end;

procedure TSCCustomDBButtonEdit.SetMask(Value: String);
begin
  if not FExternalMask then
  begin
    Inc(FSettingDataMask);
    try
      EditMask := Value;
    finally
      Dec(FSettingDataMask);
    end;
  end;  
end;

procedure TSCCustomDBButtonEdit.MaskChanged;
begin
  if FSettingDataMask = 0 then
  begin
    FExternalMask := EditMask <> '';
    DataChange(nil);
  end;
end;

function TSCCustomDBButtonEdit.IsMaskStored: Boolean;
begin
  Result := FExternalMask or ((FDataLink <> nil) and (FDataLink.Field <> nil) and
    (EditMask <> FDataLink.Field.EditMask));
end;

function TSCCustomDBButtonEdit.CanRaiseMaskError: Boolean;
begin
  Result := FSettingText = 0;
end;

function TSCCustomDBButtonEdit.GetLineText(Index: Integer): String;
begin
  Result := inherited GetLineText(Index);
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    Result := '';
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      Result := ArrangeText(FDataLink.Field.Text);

      if MaxLength > 0 then
        Result := Copy(Result, 1, MaxLength);

      {$IFDEF SC_DELPHI2009_EARLY}
      if OEMConvert then
        Result := OEMConvertText(Result);
      {$ENDIF}
    end;
  end;
end;

{ TSCCustomDBHyperlinkEdit }

procedure TSCCustomDBHyperlinkEdit.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

constructor TSCCustomDBHyperlinkEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];

  FAutoAlignment := True;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
end;

destructor TSCCustomDBHyperlinkEdit.Destroy;
begin
  FreeAndNil(FDataLink);
  inherited Destroy;
end;

procedure TSCCustomDBHyperlinkEdit.Loaded;
begin
  inherited Loaded;
  ResetMaxLength;
  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBHyperlinkEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBHyperlinkEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBHyperlinkEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (FDataLink <> nil) and ((Key = VK_DELETE) or 
    ((Key = VK_INSERT) and (ssShift in Shift))) then
    FDataLink.Edit;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBHyperlinkEdit.KeyPress(var Key: Char);
begin
  if (Key in [#32..#255]) and (FDataLink <> nil) and
    (FDataLink.Field <> nil) and not FDataLink.Field.IsValidChar(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;

  inherited KeyPress(Key);
end;

function TSCCustomDBHyperlinkEdit.EditCanModify: Boolean;
begin
  Result := (FDataLink <> nil) and FDataLink.Edit;
end;

procedure TSCCustomDBHyperlinkEdit.Reset;
begin
  if FDataLink <> nil then
    FDataLink.Reset;
  SelectAll;
end;

function TSCCustomDBHyperlinkEdit.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBHyperlinkEdit.SetDataSource(Value: TDataSource);
begin
  if (FDataLink <> nil) and
    not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;    
end;

function TSCCustomDBHyperlinkEdit.GetDataField: string;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBHyperlinkEdit.SetDataField(const Value: string);
begin
  if not IsDesigning then
  begin
    ResetEditMask;
    ResetMaxLength;
  end;

  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBHyperlinkEdit.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBHyperlinkEdit.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBHyperlinkEdit.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBHyperlinkEdit.ActiveChange(Sender: TObject);
begin
  if (FDataLink = nil) or not FDataLink.Active then
  begin
    ResetEditMask;
    ResetMaxLength;
  end;
end;

procedure TSCCustomDBHyperlinkEdit.DataChange(Sender: TObject);
begin
  UpdateAlignment;
  Inc(FSettingText);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      SetMask(FDataLink.Field.EditMask);

      if not IsDesigning then
      begin
        if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
          MaxLength := FDataLink.Field.Size;
      end;

      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else begin
        Text := FDataLink.Field.DisplayText;
        if FDataLink.Editing and FDataLink.GetModified then
          Modified := True;
      end;
    end else
    begin
      SetMask('');

      if (EditMask = '') and IsDesigning then
        Text := Name
      else
        Text := '';
    end;
  finally
    Dec(FSettingText);
  end;
end;

procedure TSCCustomDBHyperlinkEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := (FDataLink = nil) or not FDataLink.Editing;
end;

procedure TSCCustomDBHyperlinkEdit.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  UpdateFieldData;
end;

procedure TSCCustomDBHyperlinkEdit.WMUndo(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBHyperlinkEdit.WMPaste(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBHyperlinkEdit.WMCut(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBHyperlinkEdit.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and (FDataLink <> nil) and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBHyperlinkEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBHyperlinkEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBHyperlinkEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBHyperlinkEdit.DoChange;
begin
  if not SettingMask and (FSettingText = 0) and (FDataLink <> nil) and
    not (IsLoading or IsDesigning) then
  begin
    FDataLink.Edit;
    FDataLink.Modified;

    if not HasFocus then
      UpdateFieldData;
  end;
  
  inherited DoChange;
end;

function TSCCustomDBHyperlinkEdit.IsValidKey(Key: Char): Boolean;
begin
  Result := False;
  if EditCanModify then
    Result := inherited IsValidKey(Key);
end;

procedure TSCCustomDBHyperlinkEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

procedure TSCCustomDBHyperlinkEdit.BeforeExit;
begin
  inherited BeforeExit;
  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SelectAll;
      SetFocus;
      raise;
    end;
  end;
  SetFocused(False);
  // DoExit;
end;

procedure TSCCustomDBHyperlinkEdit.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBHyperlinkEdit.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

function TSCCustomDBHyperlinkEdit.GetDbAlignment: TAlignment;
var
  ExStyle: DWORD;
begin
  Result := taLeftJustify;
  if not FFocused and (FDataLink <> nil) and (FDataLink.Field <> nil) then
    Result := FDataLink.Field.Alignment;

  if UseRightToLeftAlignment then ChangeBiDiModeAlignment(Result);

  if ((Result = taLeftJustify) or FFocused) and
    SysLocale.MiddleEast and HandleAllocated and IsRightToLeft then
  begin
    ExStyle := AlignStyle[UseRightToLeftAlignment, Result];

    Result := taLeftJustify;
    if ExStyle = WS_EX_RIGHT then
      Result := taRightJustify;
  end;
end;

function TSCCustomDBHyperlinkEdit.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBHyperlinkEdit.UpdateFieldData;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Field.Text := Text;
end;

procedure TSCCustomDBHyperlinkEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBHyperlinkEdit then
  begin
    with TSCCustomDBHyperlinkEdit(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
    end;
  end;
end;

procedure TSCCustomDBHyperlinkEdit.ResetEditMask;
var
  F: TField;
begin
  if Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.EditMask = EditMask) then
      SetMask('');
  end;
end;

procedure TSCCustomDBHyperlinkEdit.SetMask(Value: String);
begin
  if not FExternalMask then
  begin
    Inc(FSettingDataMask);
    try
      EditMask := Value;
    finally
      Dec(FSettingDataMask);
    end;
  end;  
end;

procedure TSCCustomDBHyperlinkEdit.MaskChanged;
begin
  if FSettingDataMask = 0 then
  begin
    FExternalMask := EditMask <> '';
    DataChange(nil);
  end;
end;

function TSCCustomDBHyperlinkEdit.IsMaskStored: Boolean;
begin
  Result := FExternalMask or ((FDataLink <> nil) and (FDataLink.Field <> nil) and
    (EditMask <> FDataLink.Field.EditMask));
end;

function TSCCustomDBHyperlinkEdit.CanRaiseMaskError: Boolean;
begin
  Result := FSettingText = 0;
end;

function TSCCustomDBHyperlinkEdit.GetLineText(Index: Integer): String;
begin
  Result := inherited GetLineText(Index);
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    Result := '';
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      Result := ArrangeText(FDataLink.Field.Text);

      if MaxLength > 0 then
        Result := Copy(Result, 1, MaxLength);

      {$IFDEF SC_DELPHI2009_EARLY}
      if OEMConvert then
        Result := OEMConvertText(Result);
      {$ENDIF}
    end;
  end;
end;

{ TSCCustomDBIntSpinEdit }

procedure TSCCustomDBIntSpinEdit.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

constructor TSCCustomDBIntSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];
  Alignment := taRightJustify;
  AllowEmpty := True;

  FAutoAlignment := True;
  FInvalidText := scitAuto;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
end;

destructor TSCCustomDBIntSpinEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCustomDBIntSpinEdit.Loaded;
begin
  inherited Loaded;

  EditMask := '';
  ResetMaxLength;

  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBIntSpinEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBIntSpinEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBIntSpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (FDataLink <> nil) and ((Key = VK_DELETE) or
    ((Key = VK_INSERT) and (ssShift in Shift))) then
    FDataLink.Edit;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBIntSpinEdit.KeyPress(var Key: Char);
begin
  if (Key in [#32..#255]) and (FDataLink <> nil) and
    (FDataLink.Field <> nil) and not FDataLink.Field.IsValidChar(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;

  inherited KeyPress(Key);
end;

function TSCCustomDBIntSpinEdit.EditCanModify: Boolean;
begin
  Result := (FDataLink <> nil) and FDataLink.Edit;
end;

procedure TSCCustomDBIntSpinEdit.Reset;
begin
  if FDataLink <> nil then
    FDataLink.Reset;
  SelectAll;
end;

function TSCCustomDBIntSpinEdit.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBIntSpinEdit.SetDataSource(Value: TDataSource);
begin
  if (FDataLink <> nil) and
    not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;    
end;

function TSCCustomDBIntSpinEdit.GetDataField: string;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBIntSpinEdit.SetDataField(const Value: string);
begin
  if not IsDesigning then
  begin
    EditMask := '';
    ResetMaxLength;
  end;

  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBIntSpinEdit.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBIntSpinEdit.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBIntSpinEdit.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBIntSpinEdit.ActiveChange(Sender: TObject);
begin
  EditMask := '';
  ResetMaxLength;
end;

procedure TSCCustomDBIntSpinEdit.DataChange(Sender: TObject);
begin
  UpdateAlignment;
  Inc(FSettingText);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      EditMask := '';

      if not IsDesigning then
      begin
        if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
          MaxLength := FDataLink.Field.Size;
      end;

      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else begin
        Text := FDataLink.Field.DisplayText;
        if FDataLink.Editing and FDataLink.GetModified then
          Modified := True;
      end;
    end else
    begin
      EditMask := '';

      if IsDesigning then
        Text := Name
      else
        Text := '';
    end;
  finally
    Dec(FSettingText);
  end;
end;

procedure TSCCustomDBIntSpinEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := (FDataLink = nil) or not FDataLink.Editing;
end;

procedure TSCCustomDBIntSpinEdit.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  UpdateFieldData;
end;

procedure TSCCustomDBIntSpinEdit.WMUndo(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBIntSpinEdit.WMPaste(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBIntSpinEdit.WMCut(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBIntSpinEdit.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and (FDataLink <> nil) and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBIntSpinEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBIntSpinEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBIntSpinEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBIntSpinEdit.DoChange;
begin
  if not SettingMask and (FSettingText = 0) and (FDataLink <> nil) and
    not (IsLoading or IsDesigning) then
  begin
    FDataLink.Edit;
    FDataLink.Modified;

    if not HasFocus then
      UpdateFieldData;
  end;

  inherited DoChange;
end;

function TSCCustomDBIntSpinEdit.ArrangeText(const S: String): String;
var
  Str: String;
begin
  Result := '';
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if (FSettingText > 0) and (S = '') then
    begin
      Result := S;
      Exit;
    end;

    Str := StringReplace(S, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);

    if not ((HexMode and scIsHex(S)) or (not HexMode and scIsInteger(Str))) then
    begin
      if not (FDataLink.Editing or ((DataSource <> nil) and (DataSource.State = dsInsert))) then
        case FInvalidText of
          scitAuto:
          begin
            if FDataLink.Field.Required then
              Result := IntToStr(MinValue);
          end;
          scitMinValue:
            Result := IntToStr(MinValue);
          scitZero:
            Result := '0';
        end;
    end else
      Result := inherited ArrangeText(S);
  end else
  if IsDesigning then
    Result := Name;
end;

function TSCCustomDBIntSpinEdit.IsValidKey(Key: Char): Boolean;
begin
  Result := False;
  if EditCanModify then
    Result := inherited IsValidKey(Key);
end;

procedure TSCCustomDBIntSpinEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

function TSCCustomDBIntSpinEdit.CanSetValue(var Value: Integer): Boolean;
begin
  Result := Enabled and not ReadOnly;
  if Result then
    Result := inherited CanSetValue(Value);
end;

procedure TSCCustomDBIntSpinEdit.DoButtonClick(Btn: TSCEditButton);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;
  inherited DoButtonClick(Btn);
end;

procedure TSCCustomDBIntSpinEdit.DoPageDown(var Key: Word);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;
  inherited DoPageDown(Key);
end;

procedure TSCCustomDBIntSpinEdit.DoPageUp(var Key: Word);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;
  inherited DoPageUp(Key);
end;


procedure TSCCustomDBIntSpinEdit.BeforeExit;
var
  S: String;
begin
  S := Text;
  if ((FDataLink <> nil) and FDataLink.GetModified) or
    (HexMode and scIsHex(S)) or (not HexMode and scIsInteger(S)) then
    inherited BeforeExit;

  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SelectAll;
      SetFocus;
      raise;
    end;
  end;
  SetFocused(False);
  // DoExit;
end;

procedure TSCCustomDBIntSpinEdit.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBIntSpinEdit.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

function TSCCustomDBIntSpinEdit.GetDbAlignment: TAlignment;
var
  ExStyle: DWORD;
begin
  Result := taLeftJustify;
  if not FFocused and (FDataLink <> nil) and (FDataLink.Field <> nil) then
    Result := FDataLink.Field.Alignment;

  if UseRightToLeftAlignment then ChangeBiDiModeAlignment(Result);

  if ((Result = taLeftJustify) or FFocused) and
    SysLocale.MiddleEast and HandleAllocated and IsRightToLeft then
  begin
    ExStyle := AlignStyle[UseRightToLeftAlignment, Result];

    Result := taLeftJustify;
    if ExStyle = WS_EX_RIGHT then
      Result := taRightJustify;
  end;
end;

function TSCCustomDBIntSpinEdit.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBIntSpinEdit.SetInvalidText(Value: TSCDbInvalidText);
begin
  if FInvalidText <> Value then
  begin
    FInvalidText := Value;
    SetText(Text);
  end;
end;

function TSCCustomDBIntSpinEdit.GetUnIntValue: LongInt;
begin
  Result := inherited GetUnIntValue;
  if FInvalidText = scitZero then Result := 0;
end;

function TSCCustomDBIntSpinEdit.GetIntValue: LongInt;
var
  S: String;
begin
  S := Trim(Text);

  Result := GetUnIntValue;
  if HexMode and scIsHex(S) then
  begin
    if S[1] <> '$' then S := '$' + S;
    Result := StrToInt(S);
  end else
  begin
    S := StringReplace(S, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);

    if not HexMode and scIsInteger(S) then
      Result := StrToInt(S);
  end;
end;

procedure TSCCustomDBIntSpinEdit.UpdateValueFromText;
var
  S: String;
begin
  S := Text;
  if (HexMode and scIsHex(S)) or (not HexMode and scIsInteger(S)) then
    inherited UpdateValueFromText
  else begin
    case FInvalidText of
      scitAuto:
      begin
        if FDataLink.Field.Required then
          IntValue := MinValue;
      end;
      scitMinValue:
        IntValue := MinValue;
      scitZero:
        IntValue := 0;
    end;
  end;
end;

procedure TSCCustomDBIntSpinEdit.UpdateFieldData;
var
  S: String;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    S := Text;
    if not ((HexMode and scIsHex(S)) or (not HexMode and scIsInteger(S))) then
    begin
      S := '';
      case FInvalidText of
        scitAuto:
        begin
          if FDataLink.Field.Required then
            S := IntToStr(MinValue);
        end;
        scitMinValue:
          S := IntToStr(MinValue);
        scitZero:
          S := '0';
      end;

      FDataLink.Field.Text := S;
    end else
    begin
      UpdateValueFromText;
      FDataLink.Field.AsInteger := IntValue;
    end;
  end;
end;

procedure TSCCustomDBIntSpinEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBIntSpinEdit then
  begin
    with TSCCustomDBIntSpinEdit(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.InvalidText := InvalidText;
    end;
  end;
end;

function TSCCustomDBIntSpinEdit.GetLineText(Index: Integer): String;
begin
  Result := inherited GetLineText(Index);
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    Result := '';
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      Result := ArrangeText(FDataLink.Field.Text);

      if MaxLength > 0 then
        Result := Copy(Result, 1, MaxLength);

      {$IFDEF SC_DELPHI2009_EARLY}
      if OEMConvert then
        Result := OEMConvertText(Result);
      {$ENDIF}
    end;
  end;
end;

function TSCCustomDBIntSpinEdit.CanDoKeySpin: Boolean;
begin
  Result := KeySpin and not GetReadOnly;
end;

{ TSCCustomDBSpinnerEdit }

procedure TSCCustomDBSpinnerEdit.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

constructor TSCCustomDBSpinnerEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];
  AllowEmpty := True;

  FInvalidText := scitAuto;
  FAutoAlignment := True;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
end;

destructor TSCCustomDBSpinnerEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCustomDBSpinnerEdit.Loaded;
begin
  inherited Loaded;

  EditMask := '';
  ResetMaxLength;

  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBSpinnerEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBSpinnerEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBSpinnerEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (FDataLink <> nil) and ((Key = VK_DELETE) or 
    ((Key = VK_INSERT) and (ssShift in Shift))) then
    FDataLink.Edit;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBSpinnerEdit.KeyPress(var Key: Char);
begin
  if (Key in [#32..#255]) and (FDataLink <> nil) and
    (FDataLink.Field <> nil) and not FDataLink.Field.IsValidChar(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;

  inherited KeyPress(Key);
end;

function TSCCustomDBSpinnerEdit.EditCanModify: Boolean;
begin
  Result := (FDataLink <> nil) and FDataLink.Edit;
end;

procedure TSCCustomDBSpinnerEdit.Reset;
begin
  if FDataLink <> nil then
    FDataLink.Reset;
  SelectAll;
end;

function TSCCustomDBSpinnerEdit.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBSpinnerEdit.SetDataSource(Value: TDataSource);
begin
  if (FDataLink <> nil) and
    not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;    
end;

function TSCCustomDBSpinnerEdit.GetDataField: string;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBSpinnerEdit.SetDataField(const Value: string);
begin
  if not IsDesigning then
  begin
    EditMask := '';
    ResetMaxLength;
  end;

  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBSpinnerEdit.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBSpinnerEdit.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBSpinnerEdit.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBSpinnerEdit.ActiveChange(Sender: TObject);
begin
  EditMask := '';
  ResetMaxLength;
end;

procedure TSCCustomDBSpinnerEdit.DataChange(Sender: TObject);
var
  S: String;
begin
  UpdateAlignment;
  Inc(FSettingText);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      EditMask := '';

      if not IsDesigning then
      begin
        if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
          MaxLength := FDataLink.Field.Size;
      end;

      if FFocused and FDataLink.CanModify then
      begin
        S := FDataLink.Field.Text;

        if (S = '') and (FDataLink.Editing or
          ((DataSource <> nil) and (DataSource.State = dsInsert))) then
          S := IntToStr(Self.MinValue);

        Text := S;
      end else
      begin
        S := FDataLink.Field.DisplayText;

        if (S = '') and (FDataLink.Editing or
          ((DataSource <> nil) and (DataSource.State = dsInsert))) then
          S := IntToStr(Self.MinValue);

        Text := S;
        if FDataLink.Editing and FDataLink.GetModified then
          Modified := True;
      end;
    end else
    begin
      EditMask := '';

      if IsDesigning then
        Text := Name
      else
        Text := '';
    end;
  finally
    Dec(FSettingText);
  end;
end;

procedure TSCCustomDBSpinnerEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := (FDataLink = nil) or not FDataLink.Editing;
end;

procedure TSCCustomDBSpinnerEdit.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  UpdateFieldData;
end;

procedure TSCCustomDBSpinnerEdit.WMUndo(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBSpinnerEdit.WMPaste(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBSpinnerEdit.WMCut(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBSpinnerEdit.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and (FDataLink <> nil) and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBSpinnerEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBSpinnerEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBSpinnerEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBSpinnerEdit.DoChange;
begin
  if not SettingMask and (FSettingText = 0) and (FDataLink <> nil) and
    not (IsLoading or IsDesigning) then
  begin
    FDataLink.Edit;
    FDataLink.Modified;

    if not HasFocus then
      UpdateFieldData;
  end;
  
  inherited DoChange;
end;

function TSCCustomDBSpinnerEdit.ArrangeText(const S: String): String;
var
  Str: String;
begin
  Result := '';
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if (FSettingText > 0) and (S = '') then
    begin
      Result := S;
      Exit;
    end;

    Str := StringReplace(S, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);

    if not ((HexMode and scIsHex(S)) or (not HexMode and scIsInteger(Str))) then
    begin
      if not (FDataLink.Editing or ((DataSource <> nil) and (DataSource.State = dsInsert))) then
        case FInvalidText of
          scitAuto:
          begin
            if FDataLink.Field.Required then
              Result := IntToStr(MinValue);
          end;
          scitMinValue:
            Result := IntToStr(MinValue);
          scitZero:
            Result := '0';
        end;
    end else
      Result := inherited ArrangeText(S);
  end else
  if IsDesigning then
    Result := Name;
end;

function TSCCustomDBSpinnerEdit.IsValidKey(Key: Char): Boolean;
begin
  Result := False;
  if EditCanModify then
    Result := inherited IsValidKey(Key);
end;

procedure TSCCustomDBSpinnerEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

procedure TSCCustomDBSpinnerEdit.DoButtonClick(Btn: TSCEditButton);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;
  inherited DoButtonClick(Btn);
end;

procedure TSCCustomDBSpinnerEdit.DoPageDown(var Key: Word);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;
  inherited DoPageDown(Key);
end;

procedure TSCCustomDBSpinnerEdit.DoPageUp(var Key: Word);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;
  inherited DoPageUp(Key);
end;

procedure TSCCustomDBSpinnerEdit.BeforeExit;
var
  S: String;
begin
  S := Text;
  if ((FDataLink <> nil) and FDataLink.GetModified) or
    (HexMode and scIsHex(S)) or (not HexMode and scIsInteger(S)) then
    inherited BeforeExit;

  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SelectAll;
      SetFocus;
      raise;
    end;
  end;
  SetFocused(False);
  // DoExit;
end;

procedure TSCCustomDBSpinnerEdit.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBSpinnerEdit.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

function TSCCustomDBSpinnerEdit.GetDbAlignment: TAlignment;
var
  ExStyle: DWORD;
begin
  Result := taLeftJustify;
  if not FFocused and (FDataLink <> nil) and (FDataLink.Field <> nil) then
    Result := FDataLink.Field.Alignment;

  if UseRightToLeftAlignment then ChangeBiDiModeAlignment(Result);

  if ((Result = taLeftJustify) or FFocused) and
    SysLocale.MiddleEast and HandleAllocated and IsRightToLeft then
  begin
    ExStyle := AlignStyle[UseRightToLeftAlignment, Result];

    Result := taLeftJustify;
    if ExStyle = WS_EX_RIGHT then
      Result := taRightJustify;
  end;
end;

function TSCCustomDBSpinnerEdit.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBSpinnerEdit.SetInvalidText(Value: TSCDbInvalidText);
begin
  if FInvalidText <> Value then
  begin
    FInvalidText := Value;
    SetText(Text);
  end;
end;

function TSCCustomDBSpinnerEdit.GetIntValue: LongInt;
var
  S: String;
begin
  S := StringReplace(Trim(Text), {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);

  Result := GetUnIntValue;
  if scIsInteger(S) then
    Result := StrToInt(S);
end;

function TSCCustomDBSpinnerEdit.GetUnIntValue: LongInt;
begin
  Result := inherited GetUnIntValue;
  if FInvalidText = scitZero then Result := 0;
end;

procedure TSCCustomDBSpinnerEdit.UpdateValueFromText;
var
  S: String;
begin
  S := Text;
  if (HexMode and scIsHex(S)) or (not HexMode and scIsInteger(S)) then
    inherited UpdateValueFromText
  else begin
    case FInvalidText of
      scitAuto:
      begin
        if FDataLink.Field.Required then
          IntValue := MinValue;
      end;
      scitMinValue:
        IntValue := MinValue;
      scitZero:
        IntValue := 0;
    end;
  end;
end;

procedure TSCCustomDBSpinnerEdit.UpdateFieldData;
var
  S: String;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    S := Text;
    if not ((HexMode and scIsHex(S)) or (not HexMode and scIsInteger(S))) then
    begin
      S := '';
      case FInvalidText of
        scitAuto:
        begin
          if FDataLink.Field.Required then
            S := IntToStr(MinValue);
        end;
        scitMinValue:
          S := IntToStr(MinValue);
        scitZero:
          S := '0';
      end;
      
      FDataLink.Field.Text := S;
    end else
    begin
      UpdateValueFromText;
      FDataLink.Field.AsInteger := IntValue;
    end;
  end;
end;

procedure TSCCustomDBSpinnerEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBSpinnerEdit then
  begin
    with TSCCustomDBSpinnerEdit(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.InvalidText := InvalidText;
    end;
  end;
end;

function TSCCustomDBSpinnerEdit.GetLineText(Index: Integer): String;
begin
  Result := inherited GetLineText(Index);
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    Result := '';
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      Result := ArrangeText(FDataLink.Field.Text);

      if MaxLength > 0 then
        Result := Copy(Result, 1, MaxLength);

      {$IFDEF SC_DELPHI2009_EARLY}
      if OEMConvert then
        Result := OEMConvertText(Result);
      {$ENDIF}
    end;
  end;
end;

function TSCCustomDBSpinnerEdit.CanDoKeySpin: Boolean;
begin
  Result := KeySpin and not GetReadOnly;
end;

{ TSCCustomDBFloatSpinEdit }

procedure TSCCustomDBFloatSpinEdit.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

constructor TSCCustomDBFloatSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];
  Alignment := taRightJustify;
  AllowEmpty := True;

  FInvalidText := scitAuto;
  FAutoAlignment := True;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
end;

destructor TSCCustomDBFloatSpinEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCustomDBFloatSpinEdit.Loaded;
begin
  inherited Loaded;

  EditMask := '';
  ResetMaxLength;

  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBFloatSpinEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBFloatSpinEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBFloatSpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (FDataLink <> nil) and ((Key = VK_DELETE) or 
    ((Key = VK_INSERT) and (ssShift in Shift))) then
    FDataLink.Edit;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBFloatSpinEdit.KeyPress(var Key: Char);
begin
  if (Key in [#32..#255]) and (FDataLink <> nil) and
    (FDataLink.Field <> nil) and not FDataLink.Field.IsValidChar(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;

  inherited KeyPress(Key);
end;

function TSCCustomDBFloatSpinEdit.EditCanModify: Boolean;
begin
  Result := (FDataLink <> nil) and FDataLink.Edit;
end;

procedure TSCCustomDBFloatSpinEdit.Reset;
begin
  if FDataLink <> nil then
    FDataLink.Reset;
  SelectAll;
end;

function TSCCustomDBFloatSpinEdit.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBFloatSpinEdit.SetDataSource(Value: TDataSource);
begin
  if (FDataLink <> nil) and
    not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;    
end;

function TSCCustomDBFloatSpinEdit.GetDataField: string;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBFloatSpinEdit.SetDataField(const Value: string);
begin
  if not IsDesigning then
  begin
    EditMask := '';
    ResetMaxLength;
  end;

  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBFloatSpinEdit.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBFloatSpinEdit.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBFloatSpinEdit.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBFloatSpinEdit.ActiveChange(Sender: TObject);
begin
  EditMask := '';
  ResetMaxLength;
end;

procedure TSCCustomDBFloatSpinEdit.DataChange(Sender: TObject);
begin
  UpdateAlignment;
  Inc(FSettingText);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      EditMask := '';

      if not IsDesigning then
      begin
        if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
          MaxLength := FDataLink.Field.Size;
      end;

      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else begin
        Text := FDataLink.Field.DisplayText;
        if FDataLink.Editing and FDataLink.GetModified then
          Modified := True;
      end;
    end else
    begin
      EditMask := '';

      if IsDesigning then
        Text := Name
      else
        Text := '';
    end;
  finally
    Dec(FSettingText);
  end;
end;

procedure TSCCustomDBFloatSpinEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := (FDataLink = nil) or not FDataLink.Editing;
end;

procedure TSCCustomDBFloatSpinEdit.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  UpdateFieldData;
end;

procedure TSCCustomDBFloatSpinEdit.WMUndo(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBFloatSpinEdit.WMPaste(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBFloatSpinEdit.WMCut(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBFloatSpinEdit.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and (FDataLink <> nil) and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBFloatSpinEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBFloatSpinEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBFloatSpinEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBFloatSpinEdit.DoChange;
begin
  if not SettingMask and (FSettingText = 0) and (FDataLink <> nil) and
    not (IsLoading or IsDesigning) then
  begin
    FDataLink.Edit;
    FDataLink.Modified;

    if not HasFocus then
      UpdateFieldData;
  end;

  inherited DoChange;
end;

function TSCCustomDBFloatSpinEdit.ArrangeText(const S: String): String;
var
  Str: String;
begin
  Result := '';
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if (FSettingText > 0) and (S = '') then
    begin
      Result := S;
      Exit;
    end;

    Str := StringReplace(S, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);

    if not scIsFloat(Str) then
    begin
      if not (FDataLink.Editing or ((DataSource <> nil) and (DataSource.State = dsInsert))) then
        case FInvalidText of
          scitAuto:
          begin
            if FDataLink.Field.Required then
              Result := FloatToStr(MinValue);
          end;
          scitMinValue:
            Result := FloatToStr(MinValue);
          scitZero:
            Result := '0';
        end;
    end else
      Result := inherited ArrangeText(S);
  end else
  if IsDesigning then
    Result := Name;
end;

function TSCCustomDBFloatSpinEdit.IsValidKey(Key: Char): Boolean;
begin
  Result := False;
  if EditCanModify then
    Result := inherited IsValidKey(Key);
end;

procedure TSCCustomDBFloatSpinEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

function TSCCustomDBFloatSpinEdit.CanSetValue(var Value: Double): Boolean;
begin
  Result := Enabled and not ReadOnly;
  if Result then
    Result := inherited CanSetValue(Value);
end;

procedure TSCCustomDBFloatSpinEdit.DoButtonClick(Btn: TSCEditButton);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;
  inherited DoButtonClick(Btn);
end;

procedure TSCCustomDBFloatSpinEdit.DoPageDown(var Key: Word);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;
  inherited DoPageDown(Key);
end;

procedure TSCCustomDBFloatSpinEdit.DoPageUp(var Key: Word);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;
  inherited DoPageUp(Key);
end;

procedure TSCCustomDBFloatSpinEdit.BeforeExit;
begin
  if ((FDataLink <> nil) and FDataLink.GetModified) or scIsFloat(Text) then
    inherited BeforeExit;

  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SelectAll;
      SetFocus;
      raise;
    end;
  end;
  SetFocused(False);
  // DoExit;
end;

procedure TSCCustomDBFloatSpinEdit.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBFloatSpinEdit.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

function TSCCustomDBFloatSpinEdit.GetDbAlignment: TAlignment;
var
  ExStyle: DWORD;
begin
  Result := taLeftJustify;
  if not FFocused and (FDataLink <> nil) and (FDataLink.Field <> nil) then
    Result := FDataLink.Field.Alignment;

  if UseRightToLeftAlignment then ChangeBiDiModeAlignment(Result);

  if ((Result = taLeftJustify) or FFocused) and
    SysLocale.MiddleEast and HandleAllocated and IsRightToLeft then
  begin
    ExStyle := AlignStyle[UseRightToLeftAlignment, Result];

    Result := taLeftJustify;
    if ExStyle = WS_EX_RIGHT then
      Result := taRightJustify;
  end;
end;

function TSCCustomDBFloatSpinEdit.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBFloatSpinEdit.SetInvalidText(Value: TSCDbInvalidText);
begin
  if FInvalidText <> Value then
  begin
    FInvalidText := Value;
    SetText(Text);
  end;
end;

function TSCCustomDBFloatSpinEdit.GetFloatValue: Double;
var
  S: String;
  E: Extended;
begin
  S := StringReplace(Trim(Text), {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);

  Result := GetUnFloatValue;
  if scIsFloat(S, E) then
    Result := E;
end;

function TSCCustomDBFloatSpinEdit.GetUnFloatValue: Double;
begin
  Result := inherited GetUnFloatValue;
  if FInvalidText = scitZero then Result := 0;
end;

procedure TSCCustomDBFloatSpinEdit.UpdateValueFromText;
var
  S: String;
begin
  S := Text;
  if scIsFloat(S) then
    inherited UpdateValueFromText
  else begin
    case FInvalidText of
      scitAuto:
      begin
        if FDataLink.Field.Required then
          FloatValue := MinValue;
      end;
      scitMinValue:
        FloatValue := MinValue;
      scitZero:
        FloatValue := 0;
    end;
  end;
end;

procedure TSCCustomDBFloatSpinEdit.UpdateFieldData;
var
  S: String;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    S := Text;
    if not scIsFloat(S) then
    begin
      S := '';
      case FInvalidText of
        scitAuto:
        begin
          if FDataLink.Field.Required then
            S := FloatToStr(MinValue);
        end;
        scitMinValue:
          S := FloatToStr(MinValue);
        scitZero:
          S := '0';
      end;

      FDataLink.Field.Text := S;
    end else
    begin
      UpdateValueFromText;
      FDataLink.Field.AsFloat := FloatValue;
    end;
  end;
end;

procedure TSCCustomDBFloatSpinEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBFloatSpinEdit then
  begin
    with TSCCustomDBFloatSpinEdit(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.InvalidText := InvalidText;
    end;
  end;
end;

function TSCCustomDBFloatSpinEdit.GetLineText(Index: Integer): String;
begin
  Result := inherited GetLineText(Index);
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    Result := '';
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      Result := ArrangeText(FDataLink.Field.Text);

      if MaxLength > 0 then
        Result := Copy(Result, 1, MaxLength);

      {$IFDEF SC_DELPHI2009_EARLY}
      if OEMConvert then
        Result := OEMConvertText(Result);
      {$ENDIF}
    end;
  end;
end;

function TSCCustomDBFloatSpinEdit.CanDoKeySpin: Boolean;
begin
  Result := KeySpin and not GetReadOnly;
end;

{ TSCCustomDBCurrencySpinEdit }

procedure TSCCustomDBCurrencySpinEdit.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

constructor TSCCustomDBCurrencySpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];
  Alignment := taRightJustify;
  AllowEmpty := True;

  FInvalidText := scitAuto;
  FAutoAlignment := True;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
end;

destructor TSCCustomDBCurrencySpinEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCustomDBCurrencySpinEdit.Loaded;
begin
  inherited Loaded;

  EditMask := '';
  ResetMaxLength;

  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBCurrencySpinEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBCurrencySpinEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBCurrencySpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (FDataLink <> nil) and ((Key = VK_DELETE) or 
    ((Key = VK_INSERT) and (ssShift in Shift))) then
    FDataLink.Edit;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBCurrencySpinEdit.KeyPress(var Key: Char);
begin
  if (Key in [#32..#255]) and (FDataLink <> nil) and
    (FDataLink.Field <> nil) and not FDataLink.Field.IsValidChar(Key) and
    not IsValidKey(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;

  inherited KeyPress(Key);
end;

function TSCCustomDBCurrencySpinEdit.EditCanModify: Boolean;
begin
  Result := (FDataLink <> nil) and FDataLink.Edit;
end;

procedure TSCCustomDBCurrencySpinEdit.Reset;
begin
  if FDataLink <> nil then
    FDataLink.Reset;
  SelectAll;
end;

function TSCCustomDBCurrencySpinEdit.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBCurrencySpinEdit.SetDataSource(Value: TDataSource);
begin
  if (FDataLink <> nil) and
    not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;    
end;

function TSCCustomDBCurrencySpinEdit.GetDataField: string;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBCurrencySpinEdit.SetDataField(const Value: string);
begin
  if not IsDesigning then
  begin
    EditMask := '';
    ResetMaxLength;
  end;

  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBCurrencySpinEdit.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBCurrencySpinEdit.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBCurrencySpinEdit.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBCurrencySpinEdit.ActiveChange(Sender: TObject);
begin
  EditMask := '';
  ResetMaxLength;
end;

procedure TSCCustomDBCurrencySpinEdit.DataChange(Sender: TObject);
begin
  UpdateAlignment;
  Inc(FSettingText);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      EditMask := '';

      if not IsDesigning then
      begin
        if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
          MaxLength := FDataLink.Field.Size;
      end;

      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else begin
        Text := FDataLink.Field.DisplayText;
        if FDataLink.Editing and FDataLink.GetModified then
          Modified := True;
      end;
    end else
    begin
      EditMask := '';

      if IsDesigning then
        Text := Name
      else
        Text := '';
    end;
  finally
    Dec(FSettingText);
  end;
end;

procedure TSCCustomDBCurrencySpinEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := (FDataLink = nil) or not FDataLink.Editing;
end;

procedure TSCCustomDBCurrencySpinEdit.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  UpdateFieldData;
end;

procedure TSCCustomDBCurrencySpinEdit.WMUndo(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBCurrencySpinEdit.WMPaste(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBCurrencySpinEdit.WMCut(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBCurrencySpinEdit.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and (FDataLink <> nil) and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBCurrencySpinEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBCurrencySpinEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBCurrencySpinEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBCurrencySpinEdit.DoChange;
begin
  if not SettingMask and (FSettingText = 0) and (FDataLink <> nil) and
    not (IsLoading or IsDesigning) then
  begin
    FDataLink.Edit;
    FDataLink.Modified;

    if not HasFocus then
      UpdateFieldData;
  end;
  
  inherited DoChange;
end;

function TSCCustomDBCurrencySpinEdit.ArrangeText(const S: String): String;
begin
  Result := '';
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if (FSettingText > 0) and (S = '') then
    begin
      Result := S;
      Exit;
    end;

    Result := inherited ArrangeText(S);
  end else
  if IsDesigning then
    Result := Name;
end;

function TSCCustomDBCurrencySpinEdit.IsValidKey(Key: Char): Boolean;
begin
  Result := False;
  if EditCanModify then
    Result := inherited IsValidKey(Key);
end;

procedure TSCCustomDBCurrencySpinEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

function TSCCustomDBCurrencySpinEdit.CanSetValue(var Value: Double): Boolean;
begin
  Result := Enabled and not ReadOnly;
  if Result then
    Result := inherited CanSetValue(Value);
end;

procedure TSCCustomDBCurrencySpinEdit.DoButtonClick(Btn: TSCEditButton);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;
  inherited DoButtonClick(Btn);
end;

procedure TSCCustomDBCurrencySpinEdit.DoPageDown(var Key: Word);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;
  inherited DoPageDown(Key);
end;

procedure TSCCustomDBCurrencySpinEdit.DoPageUp(var Key: Word);
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;
  inherited DoPageUp(Key);
end;

procedure TSCCustomDBCurrencySpinEdit.BeforeExit;
begin
  if ((FDataLink <> nil) and FDataLink.GetModified) or IsValidText then
    inherited BeforeExit;

  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SelectAll;
      SetFocus;
      raise;
    end;
  end;
  SetFocused(False);
  // DoExit;
end;

procedure TSCCustomDBCurrencySpinEdit.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBCurrencySpinEdit.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

function TSCCustomDBCurrencySpinEdit.GetDbAlignment: TAlignment;
var
  ExStyle: DWORD;
begin
  Result := taLeftJustify;
  if not FFocused and (FDataLink <> nil) and (FDataLink.Field <> nil) then
    Result := FDataLink.Field.Alignment;

  if UseRightToLeftAlignment then ChangeBiDiModeAlignment(Result);

  if ((Result = taLeftJustify) or FFocused) and
    SysLocale.MiddleEast and HandleAllocated and IsRightToLeft then
  begin
    ExStyle := AlignStyle[UseRightToLeftAlignment, Result];

    Result := taLeftJustify;
    if ExStyle = WS_EX_RIGHT then
      Result := taRightJustify;
  end;
end;

function TSCCustomDBCurrencySpinEdit.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBCurrencySpinEdit.SetInvalidText(Value: TSCDbInvalidText);
begin
  if FInvalidText <> Value then
  begin
    FInvalidText := Value;
    SetText(Text);
  end;
end;

function TSCCustomDBCurrencySpinEdit.GetUnFloatValue: Double;
begin
  Result := inherited GetUnFloatValue;
  if FInvalidText = scitZero then Result := 0;
end;

procedure TSCCustomDBCurrencySpinEdit.UpdateValueFromText;
begin
  if IsValidText then
    inherited UpdateValueFromText
  else begin
    case FInvalidText of
      scitAuto:
      begin
        if FDataLink.Field.Required then
          FloatValue := MinValue;
      end;
      scitMinValue:
        FloatValue := MinValue;
      scitZero:
        FloatValue := 0;
    end;
  end;
end;

procedure TSCCustomDBCurrencySpinEdit.UpdateFieldData;
var
  S: String;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    S := Text;

    if not IsValidText then
    begin
      S := '';
      case FInvalidText of
        scitAuto:
        begin
          if FDataLink.Field.Required then
            S := FloatToStr(MinValue);
        end;
        scitMinValue:
          S := FloatToStr(MinValue);
        scitZero:
          S := '0';
      end;

      FDataLink.Field.Text := S;
    end else
    begin
      UpdateValueFromText;
      FDataLink.Field.AsString := GetFloatText;
    end;
  end;
end;

procedure TSCCustomDBCurrencySpinEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBCurrencySpinEdit then
  begin
    with TSCCustomDBCurrencySpinEdit(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.InvalidText := InvalidText;
    end;
  end;
end;

function TSCCustomDBCurrencySpinEdit.GetLineText(Index: Integer): String;
begin
  Result := inherited GetLineText(Index);
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    Result := '';
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      Result := ArrangeText(FDataLink.Field.Text);

      if MaxLength > 0 then
        Result := Copy(Result, 1, MaxLength);

      {$IFDEF SC_DELPHI2009_EARLY}
      if OEMConvert then
        Result := OEMConvertText(Result);
      {$ENDIF}
    end;
  end;
end;

function TSCCustomDBCurrencySpinEdit.CanDoKeySpin: Boolean;
begin
  Result := KeySpin and not GetReadOnly;
end;

{ TSCCustomDBPopupCalendar }

procedure TSCCustomDBPopupCalendar.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

constructor TSCCustomDBPopupCalendar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csSetCaption, csReplicatable];
  DateValidation := scdvRaiseError;

  FAutoAlignment := True;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
end;

destructor TSCCustomDBPopupCalendar.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCustomDBPopupCalendar.Loaded;
begin
  inherited Loaded;

  EditMask := '';
  ResetMaxLength;

  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBPopupCalendar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBPopupCalendar.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBPopupCalendar.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (FDataLink <> nil) and ((Key = VK_DELETE) or 
    ((Key = VK_INSERT) and (ssShift in Shift))) then
    FDataLink.Edit;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBPopupCalendar.KeyPress(var Key: Char);
begin
  if (Key in [#32..#255]) and (FDataLink <> nil) and
    (FDataLink.Field <> nil) and not FDataLink.Field.IsValidChar(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;

  inherited KeyPress(Key);
end;

function TSCCustomDBPopupCalendar.EditCanModify: Boolean;
begin
  Result := (FDataLink <> nil) and FDataLink.Edit;
end;

procedure TSCCustomDBPopupCalendar.Reset;
begin
  if FDataLink <> nil then
    FDataLink.Reset;
  SelectAll;
end;

function TSCCustomDBPopupCalendar.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBPopupCalendar.SetDataSource(Value: TDataSource);
begin
  if (FDataLink <> nil) and
    not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;    
end;

function TSCCustomDBPopupCalendar.GetDataField: string;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBPopupCalendar.SetDataField(const Value: string);
begin
  if not IsDesigning then
  begin
    EditMask := '';
    ResetMaxLength;
  end;

  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBPopupCalendar.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBPopupCalendar.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBPopupCalendar.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBPopupCalendar.ActiveChange(Sender: TObject);
begin
  EditMask := '';
  ResetMaxLength;
end;

procedure TSCCustomDBPopupCalendar.DataChange(Sender: TObject);
begin
  UpdateAlignment;
  Inc(FSettingText);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      EditMask := '';

      if not IsDesigning then
      begin
        if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
          MaxLength := FDataLink.Field.Size;
      end;

      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else begin
        Text := FDataLink.Field.DisplayText;
        if FDataLink.Editing and FDataLink.GetModified then
          Modified := True;
      end;
    end else
    begin
      EditMask := '';

      if IsDesigning then
        Text := Name
      else
        Text := '';
    end;
  finally
    Dec(FSettingText);
  end;
end;

procedure TSCCustomDBPopupCalendar.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := (FDataLink = nil) or not FDataLink.Editing;
end;

procedure TSCCustomDBPopupCalendar.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  UpdateFieldData;
end;

procedure TSCCustomDBPopupCalendar.WMUndo(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBPopupCalendar.WMPaste(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBPopupCalendar.WMCut(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBPopupCalendar.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and (FDataLink <> nil) and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBPopupCalendar.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBPopupCalendar.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBPopupCalendar.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBPopupCalendar.DoChange;
var
  S: String;
begin
  if not SettingMask and (FSettingText = 0) and (FDataLink <> nil) and
    not (IsLoading or IsDesigning) and (DropState <> sccsDropping) then
  begin
    Inc(FSettingText);
    try
      S := Text;

      FDataLink.Edit;
      FDataLink.Modified;

      if not HasFocus then
        SetText(S);
    finally
      Dec(FSettingText);
    end;
  end;

  inherited DoChange;
end;

function TSCCustomDBPopupCalendar.ArrangeText(const S: String): String;
begin
  Result := '';
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if (FSettingText > 0) and (S = '') then
    begin
      Result := S;
      Exit;
    end;

    Result := inherited ArrangeText(S);
  end else
  if IsDesigning then
    Result := Name;
end;

function TSCCustomDBPopupCalendar.IsValidKey(Key: Char): Boolean;
begin
  Result := False;
  if EditCanModify then
    Result := inherited IsValidKey(Key);
end;

function TSCCustomDBPopupCalendar.CanDropDown: Boolean;
begin
  Result := FDataLink.Active and FDataLink.CanModify and
    inherited CanDropDown;
end;

procedure TSCCustomDBPopupCalendar.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

procedure TSCCustomDBPopupCalendar.DoDateChange;
begin
  if (FSettingText = 0) and (FDataLink <> nil) and
    not (IsLoading or IsDesigning) then
  begin
    FDataLink.Edit;
    FDataLink.Modified;

    if not HasFocus then
      UpdateFieldData;
  end;

  inherited DoDateChange;
end;

procedure TSCCustomDBPopupCalendar.DoValidationError(var ADate: TDateTime;
  var ErrorText: String; var RaiseError: Boolean);
begin
  inherited DoValidationError(ADate, ErrorText, RaiseError);
  RaiseError := FSettingText = 0;
end;

procedure TSCCustomDBPopupCalendar.BeforeExit;
begin
  inherited BeforeExit;

  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SelectAll;
      SetFocus;
      raise;
    end;
  end;
  SetFocused(False);
  // DoExit;
end;

procedure TSCCustomDBPopupCalendar.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBPopupCalendar.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

function TSCCustomDBPopupCalendar.GetDbAlignment: TAlignment;
var
  ExStyle: DWORD;
begin
  Result := taLeftJustify;
  if not FFocused and (FDataLink <> nil) and (FDataLink.Field <> nil) then
    Result := FDataLink.Field.Alignment;

  if UseRightToLeftAlignment then ChangeBiDiModeAlignment(Result);

  if ((Result = taLeftJustify) or FFocused) and
    SysLocale.MiddleEast and HandleAllocated and IsRightToLeft then
  begin
    ExStyle := AlignStyle[UseRightToLeftAlignment, Result];

    Result := taLeftJustify;
    if ExStyle = WS_EX_RIGHT then
      Result := taRightJustify;
  end;
end;

function TSCCustomDBPopupCalendar.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBPopupCalendar.UpdateFieldData;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if Text = '' then
    begin
      Date := 0;
      FDataLink.Field.Text := '';
    end else
    begin
      UpdateDateFromText;
      FDataLink.Field.AsDateTime := Date;
    end;
  end;
end;

procedure TSCCustomDBPopupCalendar.SetText(Value: TCaption);
begin
  inherited SetText(Value);
end;

procedure TSCCustomDBPopupCalendar.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBPopupCalendar then
  begin
    with TSCCustomDBPopupCalendar(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
    end;
  end;
end;

function TSCCustomDBPopupCalendar.GetLineText(Index: Integer): String;
begin
  Result := inherited GetLineText(Index);
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    Result := '';
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      Result := ArrangeText(FDataLink.Field.Text);

      if MaxLength > 0 then
        Result := Copy(Result, 1, MaxLength);

      {$IFDEF SC_DELPHI2009_EARLY}
      if OEMConvert then
        Result := OEMConvertText(Result);
      {$ENDIF}
    end;
  end;
end;

function TSCCustomDBPopupCalendar.GetDescriptionText: String;
begin
  Result := inherited GetDescriptionText;
  if not IsDesigning and (csPaintCopy in ControlState) and
    (IsDesigning or not HasFocus) and (DisplayFormat <> '') then
    Result := GetLineText(0);
end;

{ TSCCustomDBPopupCalculator }

procedure TSCCustomDBPopupCalculator.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

constructor TSCCustomDBPopupCalculator.Create(AOwner: TComponent);
begin
  AllowEmpty := True;
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];
  Alignment := taRightJustify;

  FInvalidText := scitAuto;
  FAutoAlignment := True;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
end;

destructor TSCCustomDBPopupCalculator.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCustomDBPopupCalculator.Loaded;
begin
  inherited Loaded;

  EditMask := '';
  ResetMaxLength;

  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBPopupCalculator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBPopupCalculator.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBPopupCalculator.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (FDataLink <> nil) and ((Key = VK_DELETE) or 
    ((Key = VK_INSERT) and (ssShift in Shift))) then
    FDataLink.Edit;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBPopupCalculator.KeyPress(var Key: Char);
begin
  if (Key in [#32..#255]) and (FDataLink <> nil) and
    (FDataLink.Field <> nil) and not FDataLink.Field.IsValidChar(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;

  inherited KeyPress(Key);
end;

function TSCCustomDBPopupCalculator.EditCanModify: Boolean;
begin
  Result := (FDataLink <> nil) and FDataLink.Edit;
end;

procedure TSCCustomDBPopupCalculator.Reset;
begin
  if FDataLink <> nil then
    FDataLink.Reset;
  SelectAll;
end;

function TSCCustomDBPopupCalculator.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBPopupCalculator.SetDataSource(Value: TDataSource);
begin
  if (FDataLink <> nil) and
    not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;    
end;

function TSCCustomDBPopupCalculator.GetDataField: string;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBPopupCalculator.SetDataField(const Value: string);
begin
  if not IsDesigning then
  begin
    EditMask := '';
    ResetMaxLength;
  end;

  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBPopupCalculator.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBPopupCalculator.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBPopupCalculator.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBPopupCalculator.ActiveChange(Sender: TObject);
begin
  EditMask := '';
  ResetMaxLength;
end;

procedure TSCCustomDBPopupCalculator.DataChange(Sender: TObject);
begin
  UpdateAlignment;
  Inc(FSettingText);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      EditMask := '';

      if not IsDesigning then
      begin
        if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
          MaxLength := FDataLink.Field.Size;
      end;

      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else begin
        Text := FDataLink.Field.DisplayText;
        if FDataLink.Editing and FDataLink.GetModified then
          Modified := True;
      end;
    end else
    begin
      EditMask := '';

      if IsDesigning then
        Text := Name
      else
        Text := '';
    end;
  finally
    Dec(FSettingText);
  end;
end;

procedure TSCCustomDBPopupCalculator.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := (FDataLink = nil) or not FDataLink.Editing;
end;

procedure TSCCustomDBPopupCalculator.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  UpdateFieldData;
end;

procedure TSCCustomDBPopupCalculator.WMUndo(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBPopupCalculator.WMPaste(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBPopupCalculator.WMCut(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBPopupCalculator.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and (FDataLink <> nil) and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBPopupCalculator.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBPopupCalculator.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBPopupCalculator.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBPopupCalculator.DoChange;
begin
  if not SettingMask and not GetDroppedDown and
    (FSettingText = 0) and (FDataLink <> nil) and
    not (IsLoading or IsDesigning) then
  begin
    FDataLink.Edit;
    FDataLink.Modified;

    if not HasFocus then
      UpdateFieldData;
  end;

  inherited DoChange;
end;

function TSCCustomDBPopupCalculator.ArrangeText(const S: String): String;
var
  Str: String;
begin
  Result := '';
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if (FSettingText > 0) and (S = '') then
    begin
      Result := S;
      Exit;
    end;

    Str := StringReplace(S, {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);

    if not scIsFloat(Str) then
    begin
      if not (FDataLink.Editing or ((DataSource <> nil) and (DataSource.State = dsInsert))) then
        case FInvalidText of
          scitAuto:
          begin
            if FDataLink.Field.Required then
              Result := FloatToStr(0);
          end;
          scitMinValue:
            Result := FloatToStr(0);
          scitZero:
            Result := '0';
        end;
    end else
      Result := inherited ArrangeText(S);
  end else
  if IsDesigning then
    Result := Name;
end;

function TSCCustomDBPopupCalculator.IsValidKey(Key: Char): Boolean;
begin
  Result := False;
  if EditCanModify then
    Result := inherited IsValidKey(Key);
end;

procedure TSCCustomDBPopupCalculator.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

function TSCCustomDBPopupCalculator.CanSetValue(var Value: Extended): Boolean;
begin
  Result := Enabled and not ReadOnly;
  if Result then
    Result := inherited CanSetValue(Value);
end;

procedure TSCCustomDBPopupCalculator.DoButtonClick(Btn: TSCEditButton);
begin
  {if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Edit;}
  inherited DoButtonClick(Btn);
end;

procedure TSCCustomDBPopupCalculator.BeforeExit;
begin
  if ((FDataLink <> nil) and FDataLink.GetModified) or scIsFloat(Text) then
    inherited BeforeExit;

  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SelectAll;
      SetFocus;
      raise;
    end;
  end;
  SetFocused(False);
  // DoExit;
end;

procedure TSCCustomDBPopupCalculator.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBPopupCalculator.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

function TSCCustomDBPopupCalculator.GetDbAlignment: TAlignment;
var
  ExStyle: DWORD;
begin
  Result := taLeftJustify;
  if not FFocused and (FDataLink <> nil) and (FDataLink.Field <> nil) then
    Result := FDataLink.Field.Alignment;

  if UseRightToLeftAlignment then ChangeBiDiModeAlignment(Result);

  if ((Result = taLeftJustify) or FFocused) and
    SysLocale.MiddleEast and HandleAllocated and IsRightToLeft then
  begin
    ExStyle := AlignStyle[UseRightToLeftAlignment, Result];

    Result := taLeftJustify;
    if ExStyle = WS_EX_RIGHT then
      Result := taRightJustify;
  end;
end;

function TSCCustomDBPopupCalculator.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBPopupCalculator.SetInvalidText(Value: TSCDbInvalidText);
begin
  if FInvalidText <> Value then
  begin
    FInvalidText := Value;
    SetText(Text);
  end;
end;

function TSCCustomDBPopupCalculator.GetFloatValue: Extended;
var
  S: String;
  E: Extended;
begin
  S := StringReplace(Trim(Text), {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}ThousandSeparator, '', [rfReplaceAll]);

  Result := 0;
  if scIsFloat(S, E) then
    Result := E;
end;

procedure TSCCustomDBPopupCalculator.UpdateValueFromText;
var
  S: String;
begin
  S := Text;
  if scIsFloat(S) then
    inherited UpdateValueFromText
  else begin
    case FInvalidText of
      scitAuto:
      begin
        if FDataLink.Field.Required then
          FloatValue := 0;
      end;
      scitMinValue:
        FloatValue := 0;
      scitZero:
        FloatValue := 0;
    end;
  end;
end;

procedure TSCCustomDBPopupCalculator.UpdateFieldData;
var
  S: String;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    S := Text;
    if not scIsFloat(S) then
    begin
      S := '';
      case FInvalidText of
        scitAuto:
        begin
          if FDataLink.Field.Required then
            S := FloatToStr(0);
        end;
        scitMinValue:
          S := FloatToStr(0);
        scitZero:
          S := '0';
      end;

      FDataLink.Field.Text := S;
    end else
    begin
      UpdateValueFromText;
      FDataLink.Field.AsFloat := FloatValue;
    end;
  end;
end;

procedure TSCCustomDBPopupCalculator.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBPopupCalculator then
  begin
    with TSCCustomDBPopupCalculator(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.InvalidText := InvalidText;
    end;
  end;
end;

function TSCCustomDBPopupCalculator.CanDropDown: Boolean;
begin
  Result := FDataLink.Active and FDataLink.CanModify and
    inherited CanDropDown;
end;

procedure TSCCustomDBPopupCalculator.AfterCloseUp;
var
  S: String;
  IsReturn: Boolean;
begin
  S := Self.Text;
  IsReturn := ReturnClose;
  inherited AfterCloseUp;

  if IsReturn and not (IsLoading or IsDesigning) then
  begin
    FDataLink.Edit;
    FDataLink.Modified;

    SetText(S);
  end;
end;

function TSCCustomDBPopupCalculator.GetLineText(Index: Integer): String;
begin
  Result := inherited GetLineText(Index);
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    Result := '';
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      Result := ArrangeText(FDataLink.Field.Text);

      if MaxLength > 0 then
        Result := Copy(Result, 1, MaxLength);

      {$IFDEF SC_DELPHI2009_EARLY}
      if OEMConvert then
        Result := OEMConvertText(Result);
      {$ENDIF}
    end;
  end;
end;

{ TSCCustomDBTimeEdit }

procedure TSCCustomDBTimeEdit.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

constructor TSCCustomDBTimeEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csSetCaption, csReplicatable];

  FAutoAlignment := True;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
end;

destructor TSCCustomDBTimeEdit.Destroy;
begin
  FreeAndNil(FDataLink);
  inherited Destroy;
end;

procedure TSCCustomDBTimeEdit.Loaded;
begin
  inherited Loaded;

  EditMask := '';
  ResetMaxLength;

  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBTimeEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBTimeEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBTimeEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (FDataLink <> nil) and ((Key = VK_DELETE) or 
    ((Key = VK_INSERT) and (ssShift in Shift))) then
    FDataLink.Edit;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBTimeEdit.KeyPress(var Key: Char);
begin
  if (Key in [#32..#255]) and (FDataLink <> nil) and
    (FDataLink.Field <> nil) and not FDataLink.Field.IsValidChar(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;

  inherited KeyPress(Key);
end;

function TSCCustomDBTimeEdit.EditCanModify: Boolean;
begin
  Result := (FDataLink <> nil) and FDataLink.Edit;
end;

procedure TSCCustomDBTimeEdit.Reset;
begin
  if FDataLink <> nil then
    FDataLink.Reset;
  SelectAll;
end;

function TSCCustomDBTimeEdit.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBTimeEdit.SetDataSource(Value: TDataSource);
begin
  if (FDataLink <> nil) and
    not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;    
end;

function TSCCustomDBTimeEdit.GetDataField: string;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBTimeEdit.SetDataField(const Value: string);
begin
  if not IsDesigning then
  begin
    EditMask := '';
    ResetMaxLength;
  end;

  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBTimeEdit.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBTimeEdit.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBTimeEdit.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBTimeEdit.ActiveChange(Sender: TObject);
begin
  EditMask := '';
  ResetMaxLength;
end;

procedure TSCCustomDBTimeEdit.DataChange(Sender: TObject);
begin
  UpdateAlignment;
  Inc(FSettingText);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      EditMask := '';

      if not IsDesigning then
      begin
        if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
          MaxLength := FDataLink.Field.Size;
      end;

      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else begin
        Text := FDataLink.Field.DisplayText;
        if FDataLink.Editing and FDataLink.GetModified then
          Modified := True;
      end;
    end else
    begin
      EditMask := '';

      if IsDesigning then
        Text := Name
      else
        Text := '';
    end;
  finally
    Dec(FSettingText);
  end;
end;

procedure TSCCustomDBTimeEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := (FDataLink = nil) or not FDataLink.Editing;
end;

procedure TSCCustomDBTimeEdit.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  UpdateFieldData;
end;

procedure TSCCustomDBTimeEdit.WMUndo(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBTimeEdit.WMPaste(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBTimeEdit.WMCut(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBTimeEdit.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and (FDataLink <> nil) and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBTimeEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBTimeEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBTimeEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBTimeEdit.DoChange;
begin
  if not SettingMask and (FSettingText = 0) and (FDataLink <> nil) and
    not (IsLoading or IsDesigning) then
  begin
    FDataLink.Edit;
    FDataLink.Modified;

    if not HasFocus then
      UpdateFieldData;
  end;

  inherited DoChange;
end;

function TSCCustomDBTimeEdit.IsValidKey(Key: Char): Boolean;
begin
  Result := False;
  if EditCanModify then
    Result := inherited IsValidKey(Key);
end;

function TSCCustomDBTimeEdit.ArrangeText(const S: String): String;
begin
  Result := '';
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if (FSettingText > 0) and (S = '') then
    begin
      Result := S;
      Exit;
    end;

    Result := inherited ArrangeText(S);
  end else
  if IsDesigning then
    Result := Name;
end;

procedure TSCCustomDBTimeEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

procedure TSCCustomDBTimeEdit.BeforeExit;
begin
  inherited BeforeExit;
  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SelectAll;
      SetFocus;
      raise;
    end;
  end;
  SetFocused(False);
  // DoExit;
end;

procedure TSCCustomDBTimeEdit.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBTimeEdit.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

function TSCCustomDBTimeEdit.GetDbAlignment: TAlignment;
var
  ExStyle: DWORD;
begin
  Result := taLeftJustify;
  if not FFocused and (FDataLink <> nil) and (FDataLink.Field <> nil) then
    Result := FDataLink.Field.Alignment;

  if UseRightToLeftAlignment then ChangeBiDiModeAlignment(Result);

  if ((Result = taLeftJustify) or FFocused) and
    SysLocale.MiddleEast and HandleAllocated and IsRightToLeft then
  begin
    ExStyle := AlignStyle[UseRightToLeftAlignment, Result];

    Result := taLeftJustify;
    if ExStyle = WS_EX_RIGHT then
      Result := taRightJustify;
  end;
end;

function TSCCustomDBTimeEdit.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBTimeEdit.UpdateFieldData;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if Text = '' then
      FDataLink.Field.Text := ''
    else begin
      UpdateTimeFromText;
      FDataLink.Field.AsDateTime := Time;
    end;
  end;
end;

procedure TSCCustomDBTimeEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBTimeEdit then
  begin
    with TSCCustomDBTimeEdit(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
    end;
  end;
end;

function TSCCustomDBTimeEdit.GetLineText(Index: Integer): String;
begin
  Result := inherited GetLineText(Index);
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    Result := '';
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      Result := ArrangeText(FDataLink.Field.Text);

      if MaxLength > 0 then
        Result := Copy(Result, 1, MaxLength);

      {$IFDEF SC_DELPHI2009_EARLY}
      if OEMConvert then
        Result := OEMConvertText(Result);
      {$ENDIF}
    end;
  end;
end;

function TSCCustomDBTimeEdit.GetDescriptionText: String;
begin
  Result := inherited GetDescriptionText;
  if not IsDesigning and (csPaintCopy in ControlState) and
    (IsDesigning or not HasFocus) and (DisplayFormat <> '') then
    Result := GetLineText(0);
end;

{ TSCCustomDBComboBoxEx }

constructor TSCCustomDBComboBoxEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];

  FAutoAlignment := True;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnEditingChange := EditingChange;
end;

destructor TSCCustomDBComboBoxEx.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCustomDBComboBoxEx.Loaded;
begin
  inherited Loaded;
  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBComboBoxEx.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TSCCustomDBComboBoxEx.CreateWnd;
begin
  inherited CreateWnd;
  SetEditReadOnly;
end;

procedure TSCCustomDBComboBoxEx.DataChange(Sender: TObject);
begin
  if DroppedDown then
    Exit;

  UpdateAlignment;
  Inc(FSettingText);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      EditMask := FDataLink.Field.EditMask;

      if not IsDesigning then
      begin
        if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
          MaxLength := FDataLink.Field.Size;
      end;
    
      if FFocused and FDataLink.CanModify then
        SetComboText(FDataLink.Field.Text)
      else begin
        SetComboText(FDataLink.Field.DisplayText);
        if FDataLink.Editing and FDataLink.GetModified then
          Modified := True;
      end;
    end else
    begin
      EditMask := '';

      if IsDesigning then
        SetComboText(Name)
      else
        SetComboText('');
    end;
  finally
    Dec(FSettingText);
  end;
end;

procedure TSCCustomDBComboBoxEx.UpdateData(Sender: TObject);
begin
  FDataLink.Field.Text := GetComboText;
end;

procedure TSCCustomDBComboBoxEx.SetComboText(const Value: string);
var
  S: String;
  Index: Integer;
begin
  if Value <> GetComboText then
  begin
    Inc(FSettingText);
    try
      S := Value;
      if FUseValues and (Values.Count > 0) then
      begin
        Index := Values.IndexOf(Value);
        if (Index > -1) and (Index < Items.Count) then
          S := Items[Index];
      end;

      Text := S;
    finally
      Dec(FSettingText);
      ClearUndo;
    end;
  end;
end;

function TSCCustomDBComboBoxEx.GetComboText: string;
var
  Index: Integer;
begin
  Result := Text;
  if FUseValues then
  begin
    Index := ItemIndex;
    if (Index > -1) and (Index < ItemsEx.Count) then
      Result := ItemsEx[Index].Value;
  end;
end;

function TSCCustomDBComboBoxEx.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TSCCustomDBComboBoxEx.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and IsLoading) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if FDataLink.DataSource <> nil then
      FDataLink.DataSource.RemoveFreeNotification(Self);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;
end;

function TSCCustomDBComboBoxEx.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TSCCustomDBComboBoxEx.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TSCCustomDBComboBoxEx.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TSCCustomDBComboBoxEx.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TSCCustomDBComboBoxEx.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TSCCustomDBComboBoxEx.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key in [VK_BACK, VK_DELETE, VK_UP, VK_DOWN, 32..255] then
  begin
    if not FDataLink.Edit and (Key in [VK_UP, VK_DOWN]) then
      Key := 0;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBComboBoxEx.KeyPress(var Key: Char);
begin
  if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
    not FDataLink.Field.IsValidChar(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
      end;
  end;

  inherited KeyPress(Key);
end;

procedure TSCCustomDBComboBoxEx.EditingChange(Sender: TObject);
begin
  SetEditReadOnly;
end;

procedure TSCCustomDBComboBoxEx.SetEditReadOnly;
begin
  inherited ReadOnly := (FDataLink = nil) or not FDataLink.Editing;
end;

procedure TSCCustomDBComboBoxEx.WndProc(var Message: TMessage);
begin
  if not IsDesigning then
  begin
    case Message.Msg of
      WM_COMMAND:
        if TWMCommand(Message).NotifyCode = CBN_SELCHANGE then
        begin
          if not FDataLink.Edit then
          begin
            PostMessage(Handle, CB_SHOWDROPDOWN, 0, 0);
            Exit;
          end;
        end;
      CB_SHOWDROPDOWN:
        if Message.WParam <> 0 then
          FDataLink.Edit
        else if not FDataLink.Editing then
          DataChange(Self); {Restore text}
    end;
  end;

  inherited WndProc(Message);
end;

procedure TSCCustomDBComboBoxEx.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBComboBoxEx.SetItems(Value: TStrings);
begin
  inherited SetItems(Value);
  DataChange(Self);
end;

function TSCCustomDBComboBoxEx.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBComboBoxEx.CMGetDatalink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBComboBoxEx.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBComboBoxEx.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBComboBoxEx.DoChange;
begin
  if (FSettingText > 0) or IsLoading or (DropState = sccsDropping) then
    inherited DoChange
  else begin
    FDataLink.Edit;
    inherited DoChange;
    FDataLink.Modified;
  end;  
end;

procedure TSCCustomDBComboBoxEx.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

procedure TSCCustomDBComboBoxEx.DoListClick(Index: Integer; const Item: String);
begin
  FDataLink.Edit;
  inherited DoListClick(Index, Item);
  FDataLink.Modified;
end;

procedure TSCCustomDBComboBoxEx.DoItemChanging(Index: Integer);
begin
  FDataLink.Edit;
  SetEditReadOnly;
  inherited DoItemChanging(Index);
end;

procedure TSCCustomDBComboBoxEx.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBComboBoxEx.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

function TSCCustomDBComboBoxEx.GetDbAlignment: TAlignment;
var
  ExStyle: DWORD;
begin
  Result := taLeftJustify;
  if not FFocused and (FDataLink <> nil) and (FDataLink.Field <> nil) then
    Result := FDataLink.Field.Alignment;

  if UseRightToLeftAlignment then ChangeBiDiModeAlignment(Result);

  if ((Result = taLeftJustify) or FFocused) and
    SysLocale.MiddleEast and HandleAllocated and IsRightToLeft then
  begin
    ExStyle := AlignStyle[UseRightToLeftAlignment, Result];

    Result := taLeftJustify;
    if ExStyle = WS_EX_RIGHT then
      Result := taRightJustify;
  end;
end;

procedure TSCCustomDBComboBoxEx.BeforeExit;
begin
  inherited BeforeExit;
  try
    FDataLink.UpdateRecord;
  except
    SelectAll;
    SetFocus;
    raise;
  end;
  SetFocused(False);
  // DoExit;
end;

function TSCCustomDBComboBoxEx.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBComboBoxEx.SetUseValues(Value: Boolean);
begin
  FUseValues := Value;
end;

procedure TSCCustomDBComboBoxEx.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBComboBoxEx then
  begin
    with TSCCustomDBComboBoxEx(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.UseValues := UseValues;
    end;
  end;
end;

function TSCCustomDBComboBoxEx.CanDropDown: Boolean;
begin
  Result := FDataLink.Active and FDataLink.CanModify and
    inherited CanDropDown;
end;

function TSCCustomDBComboBoxEx.GetLineText(Index: Integer): String;
begin
  Result := inherited GetLineText(Index);
  if not IsDesigning and (csPaintCopy in ControlState) then
  begin
    Result := '';
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      Result := ArrangeText(FDataLink.Field.Text);

      if MaxLength > 0 then
        Result := Copy(Result, 1, MaxLength);

      {$IFDEF SC_DELPHI2009_EARLY}
      if OEMConvert then
        Result := OEMConvertText(Result);
      {$ENDIF}
    end;
  end;
end;

{$I SCVerRec.inc}

end.

