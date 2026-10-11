{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCDbCtrls;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DbConsts, {$IFDEF SC_DELPHI6_UP} VDBConsts, Variants, {$ENDIF} SCConsts,
  SCCommon, SCDbCommon, SCControl, SCStdControls, SCMaskEdit, SCAdvEdits,
  SCSimpleListbox, SCImageBox, SCLinkedControls;
  
type
  TSCCustomDBLabel = class(TSCCustomLabel)
  private
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FDataLink: TSCFieldDataLink;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetDataField: String;
    procedure SetDataField(const Value: String);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    function  GetFieldText: String;
    procedure SetFocused(Value: Boolean);
    procedure DataChange(Sender: TObject);
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    function  CanAlignText(var Value: TAlignment): Boolean; override;
    function  GetDbAlignment: TAlignment; dynamic;
    procedure UpdateAlignment; virtual;

    function  GetLabelText: String; override;
    procedure SetAutoSize(Value: Boolean); override;

    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property AutoSize default False;
    property DataField: String read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Caption stored False;
    property Field: TField read GetField;
  end;

  TSCDBLabel = class(TSCCustomDBLabel)
  published
    property AutoAlignment;
    property AutoSize;
    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property BorderProps;
    property ClickFocus;
    property Color;
    property Constraints;
    property Cursor;
    property DataField;
    property DataSource;
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
    property Images;
    property Indent;
    property Layout;
    property Multiline;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
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

  TSCCustomDBEdit = class(TSCCustomFrameEdit)
  private
    FFocused: Boolean;
    FDataLink: TSCFieldDataLink;
    FAutoAlignment: Boolean;
    FSettingText: Integer;
    FExternalMask: Boolean;
    FSettingDataMask: Integer;
    procedure SetAutoAlignment(Value: Boolean);
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

    function  CanRaiseMaskError: Boolean; override;
    function  IsMaskStored: Boolean; override;
    procedure MaskChanged; override;
    procedure BeforeExit; override;

    function  GetReadOnly: Boolean; reintroduce;
    procedure SetReadOnly(Value: Boolean); reintroduce;

    procedure UpdateFieldData; dynamic;

    procedure DoChange; override;
    function  EditCanModify: Boolean; override;
    procedure Reset; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    function  IsValidKey(Key: Char): Boolean; override;

    function  GetDataField: String; virtual;
    function  GetDataSource: TDataSource; virtual;
    procedure SetDataField(const Value: String); virtual;
    procedure SetDataSource(Value: TDataSource); virtual;

    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property DataField: String read GetDataField write SetDataField;
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

  TSCDBEdit = class(TSCCustomDBEdit)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoAlignment;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property CanEdit;
    property CanDragSelection;
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

  TSCDBLinkedMemo = class(TSCLinkedMemo)
  private
    FPaintControl: TSCPaintControl;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected  
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TSCCustomDBMemo = class(TSCCustomMemo)
  private
    FDataLink: TSCFieldDataLink;
    FAutoDisplay: Boolean;
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FMemoLoaded: Boolean;
    FSettingText: Integer;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetDataField: String;
    procedure SetDataField(const Value: String);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    procedure SetAutoDisplay(Value: Boolean);
    procedure SetFocused(Value: Boolean);

    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;

    function  GetMemoEditorClass: TSCMemoEditorClass; override;

    procedure UpdateFieldData; dynamic;
    procedure DoChange; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function  CanAlignText(var Value: TAlignment): Boolean; override;
    function  GetDbAlignment: TAlignment; dynamic;
    procedure UpdateAlignment; virtual;

    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property AutoDisplay: Boolean read FAutoDisplay write SetAutoDisplay default True;
    property DataField: String read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure LoadMemo; virtual;
    function  UpdateAction(Action: TBasicAction): Boolean; override;
    function  UseRightToLeftAlignment: Boolean; override;

    property Field: TField read GetField;
  end;

  TSCDBMemo = class(TSCCustomDBMemo)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoAlignment;
    property AutoDisplay;
    property BiDiMode;
    property BorderProps;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EnterAsTab;
    property Font;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ScrollbarStyles;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property WantTabs;
    property WordWrap;
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
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomDBCheckBox = class(TSCCustomCheckbox)
  private
    FDataLink: TSCFieldDataLink;
    FValueCheck: String;
    FValueUncheck: String;
    FNullIsUnchecked: Boolean;
    FChangingData: Integer;
    function  GetDataField: String;
    procedure SetDataField(const Value: String);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    function  GetFieldState: TSCCheckState;
    procedure SetNullIsUnchecked(Value: Boolean);
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    procedure SetValueCheck(const Value: String);
    procedure SetValueUncheck(const Value: String);

    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    function  ValueMatch(const ValueList, Value: String): Boolean;

    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function  GetDrawState: TSCCheckState; override;
    procedure StateChanged; override;
    procedure Toggle; override;

    procedure KeyPress(var Key: Char); override;

    property AllowGrayed default False;
    property DataField: String read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property NullIsUnchecked: Boolean read FNullIsUnchecked write SetNullIsUnchecked default False;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ValueChecked: String read FValueCheck write SetValueCheck;
    property ValueUnchecked: String read FValueUncheck write SetValueUncheck;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Checked;
    property Field: TField read GetField;
    property State;
  end;

  TSCDBCheckBox = class(TSCCustomDBCheckBox)  
  published
    property Action;
    property Align;
    property Alignment;
    property AllowGrayed;
    property Anchors;
    property BiDiMode;
    property BorderProps;
    property BoxCheckedColor;
    property BoxFrameColor;
    property BoxGrayedColor;
    property BoxToggleColor;
    property BoxUncheckedColor;
    property Caption;
    property Color;
    property Constraints;
    property DataField;
    property DataSource;
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
    property ImageChecked;
    property ImageGrayed;
    property ImageMark;
    property ImageMarkGrayed;
    property Images;
    property ImageToggle;
    property ImageUnchecked;
    property Indent;
    property Layout;
    property MarkColor;
    property MarkGrayedColor;
    property Multiline;
    property NullIsUnchecked;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property ShowFocus;
    property ShowHint;
    property Spacing;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property ValueChecked;
    property ValueUnchecked;
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

  TSCCustomDBComboBox = class(TSCCustomComboBox)
  private
    FAutoAlignment: Boolean;
    FFocused: Boolean;
    FDataLink: TSCFieldDataLink;
    FSettingText: Integer;
    FUseValues: Boolean;
    FExternalMask: Boolean;
    FSettingDataMask: Integer;
    procedure SetAutoAlignment(Value: Boolean);
    function  GetComboText: String;
    procedure SetComboText(const Value: String);
    function  GetDataField: String;
    procedure SetDataField(const Value: String);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    procedure SetEditReadOnly;
    procedure SetFocused(Value: Boolean);
    procedure SetUseValues(Value: Boolean);

    procedure SetMask(Value: String);

    procedure ResetEditMask;
    procedure ResetMaxLength;

    procedure ActiveChange(Sender: TObject);
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

    function  IsMaskStored: Boolean; override;
    procedure MaskChanged; override;
    procedure BeforeExit; override;

    function  GetReadOnly: Boolean; reintroduce;
    procedure SetReadOnly(Value: Boolean); reintroduce;

    procedure UpdateFieldData; dynamic;
    procedure DoChange; override;
    function  CanDropDown: Boolean; override;

    procedure DoItemChanging(Index: Integer); override;
    procedure DoListClick(Index: Integer; const Item: String); override;
    procedure SetItems(Value: TStrings); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    property AutoAlignment: Boolean read FAutoAlignment write SetAutoAlignment default True;
    property DataField: String read GetDataField write SetDataField;
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
    property SelectedValue;
  end;

  TSCDBComboBox = class(TSCCustomDBComboBox)  
  published
    property Anchors;
    property Align;
    property Alignment;
    property AutoAlignment;
    property AutoComplete;
    property AutoSelect;
    property AutoSize;
    property AutoWidth;
    property BorderProps;
    property BrowseButtonVisible;
    property ButtonProps;
    property CanDragSelection;
    property CanEdit;
    property BiDiMode;
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
    property EditMask;
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

  TSCCusromDBListBox = class(TSCCustomSimpleListbox)
  private
    FChangingData: Integer;
    FDataLink: TSCFieldDataLink;
    FUseValues: Boolean;
    function  GetDataField: String;
    procedure SetDataField(const Value: String);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    procedure SetUseValues(Value: Boolean);

    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Click; override;

    procedure DoSetItems; override;

    procedure CanChangeCheckState(OldSt: TSCCheckState; var NewSt: TSCCheckState); override;
    function  CanChangeItemIndex(Index: Integer): Integer; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    property DataField: String read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property UseValues: Boolean read FUseValues write SetUseValues default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property ItemIndex;
    property Field: TField read GetField;
    property SelectedValue;
  end;

  TSCDBListBox = class(TSCCusromDBListBox)  
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderProps;
    property CenterImages;
    property Color;
    property Colors;
    property Columns;
    property Constraints;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndEllipsis;
    property Font;
    property HideFocusRect;
    property HideSelection;
    property Hottrack;
    property HottrackColor;
    property HottrackUnderline;
    property Images;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property Items;
    property LineSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property Revertable;
    property ShowItemHints;
    property ShowItemImages;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseValues;
    property Values;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnHottrack;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaintHint;
    property OnPictureChange;
    property OnResize;
    property OnShowItemHint;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomDBImage = class(TSCCustomImageBox)
  private
    FDataLink: TSCFieldDataLink;
    FAutoDisplay: Boolean;
    FPictureLoaded: Boolean;
    procedure SetAutoDisplay(Value: Boolean);
    function  GetDataField: String;
    procedure SetDataField(const Value: String);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function  GetField: TField;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);

    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
  protected
    procedure DoDrawPicture(G: TGraphic); override;
    procedure DoPictureChanged; override;

    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure KeyPress(var Key: Char); override;

    function  CanDrawCaption: Boolean; override;
    function  GetPictureCaption: String; override;

    property AutoDisplay: Boolean read FAutoDisplay write SetAutoDisplay default True;
    property DataField: String read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property QuickDraw default True;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property TabStop default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure LoadPicture;
    function  UpdateAction(Action: TBasicAction): Boolean; override;

    property Field: TField read GetField;
    property Picture;
  end;

  TSCDBImage = class(TSCCustomDBImage)  
  published
    property Align;
    property Anchors;
    property AutoDisplay;
    property AutoSize;
    property BorderProps;
    property Center;
    property ClickFocus;
    property Color;
    property Constraints;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideFocusRect;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PictureTransparent;
    property PopupMenu;
    property QuickDraw;
    property ReadOnly;
    property Scrollbars;
    property ShowHint;
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
    property ZoomMode;
    property ZoomRatio;
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

type
  TFakeControl = class(TControl);
  TFakeWinControl = class(TWinControl);

{ TSCCustomDBEdit }

procedure TSCCustomDBEdit.ResetMaxLength;
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

constructor TSCCustomDBEdit.Create(AOwner: TComponent);
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

destructor TSCCustomDBEdit.Destroy;
begin
  FreeAndNil(FDataLink);
  inherited Destroy;
end;

procedure TSCCustomDBEdit.Loaded;
begin
  inherited Loaded;
  ResetMaxLength;
  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (FDataLink <> nil) and ((Key = VK_DELETE) or 
    ((Key = VK_INSERT) and (ssShift in Shift))) then
    FDataLink.Edit;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBEdit.KeyPress(var Key: Char);
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

function TSCCustomDBEdit.EditCanModify: Boolean;
begin
  Result := (FDataLink <> nil) and FDataLink.Edit;
end;

procedure TSCCustomDBEdit.Reset;
begin
  if FDataLink <> nil then
    FDataLink.Reset;
  SelectAll;
end;

function TSCCustomDBEdit.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBEdit.SetDataSource(Value: TDataSource);
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

function TSCCustomDBEdit.GetDataField: String;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBEdit.SetDataField(const Value: String);
begin
  if not IsDesigning then
  begin
    ResetEditMask;
    ResetMaxLength;
  end;

  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBEdit.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBEdit.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBEdit.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBEdit.ActiveChange(Sender: TObject);
begin
  if (FDataLink = nil) or not FDataLink.Active then
  begin
    ResetEditMask;
    ResetMaxLength;
  end;
end;

procedure TSCCustomDBEdit.DataChange(Sender: TObject);
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

procedure TSCCustomDBEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := (FDataLink = nil) or not FDataLink.Editing;
end;

procedure TSCCustomDBEdit.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  UpdateFieldData;
end;

procedure TSCCustomDBEdit.WMUndo(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBEdit.WMPaste(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBEdit.WMCut(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBEdit.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and (FDataLink <> nil) and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBEdit.DoChange;
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

function TSCCustomDBEdit.IsValidKey(Key: Char): Boolean;
begin
  Result := False;
  if EditCanModify then
    Result := inherited IsValidKey(Key);
end;

procedure TSCCustomDBEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

procedure TSCCustomDBEdit.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

procedure TSCCustomDBEdit.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

function TSCCustomDBEdit.GetDbAlignment: TAlignment;
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

procedure TSCCustomDBEdit.BeforeExit;
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

function TSCCustomDBEdit.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBEdit then
  begin
    with TSCCustomDBEdit(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
    end;
  end;
end;

procedure TSCCustomDBEdit.ResetEditMask;
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

procedure TSCCustomDBEdit.SetMask(Value: String);
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

procedure TSCCustomDBEdit.MaskChanged;
begin
  if FSettingDataMask = 0 then
  begin
    FExternalMask := EditMask <> '';
    DataChange(nil);
  end;
end;

function TSCCustomDBEdit.IsMaskStored: Boolean;
begin
  Result := FExternalMask or ((FDataLink <> nil) and (FDataLink.Field <> nil) and
    (EditMask <> FDataLink.Field.EditMask));
end;

procedure TSCCustomDBEdit.UpdateFieldData;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Field.Text := Text;
end;

function TSCCustomDBEdit.CanRaiseMaskError: Boolean;
begin
  Result := FSettingText = 0;
end;

function TSCCustomDBEdit.GetLineText(Index: Integer): String;
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

{ TSCCustomDBMemo }

constructor TSCCustomDBMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];
  TFakeWinControl(Self.Memo).ControlStyle :=
    TFakeWinControl(Self.Memo).ControlStyle + [csReplicatable];

  FAutoAlignment := True;
  FAutoDisplay := True;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
end;

destructor TSCCustomDBMemo.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCustomDBMemo.Loaded;
begin
  inherited Loaded;
  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBMemo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBMemo.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBMemo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if FMemoLoaded and (FDataLink <> nil) then
  begin
    if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
      FDataLink.Edit;
  end;
end;

procedure TSCCustomDBMemo.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);

  if FMemoLoaded and (FDataLink <> nil) then
  begin
    if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
      not FDataLink.Field.IsValidChar(Key) then
    begin
      MessageBeep(0);
      Key := #0;
    end;

    case Key of
      ^H, ^I, ^J, ^M, ^V, ^X, #32..#255:
        FDataLink.Edit;
      #27:
        FDataLink.Reset;
    end;
  end else
  begin
    if Key = #13 then LoadMemo;
    Key := #0;
  end;
end;

procedure TSCCustomDBMemo.DoChange;
begin
  if (FSettingText = 0) and (FDataLink <> nil) and
    FMemoLoaded and MemoChanged and not (IsLoading or IsDesigning) then
  begin
    FDataLink.Edit;
    FDataLink.Modified;

    if not HasFocus then
      UpdateFieldData;
  end;

  FMemoLoaded := True;
  inherited DoChange;
end;

function TSCCustomDBMemo.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBMemo.SetDataSource(Value: TDataSource);
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

function TSCCustomDBMemo.GetDataField: String;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBMemo.SetDataField(const Value: String);
begin
  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBMemo.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBMemo.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBMemo.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBMemo.LoadMemo;
begin
  if not FMemoLoaded and Assigned(FDataLink) and
    Assigned(FDataLink.Field) and FDataLink.Field.IsBlob then
  begin
    try
      Lines.Text := FDataLink.Field.AsString;
      FMemoLoaded := True;
    except
      { Memo too large }
      on E: EInvalidOperation do
        Lines.Text := Format('(%s)', [E.Message]);
    end;

    EditingChange(Self);
  end;
end;

procedure TSCCustomDBMemo.DataChange(Sender: TObject);
begin
  UpdateAlignment;
  Inc(FSettingText);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      if FDataLink.Field.IsBlob then
      begin
        if FAutoDisplay or (FDataLink.Editing and FMemoLoaded) then
        begin
          FMemoLoaded := False;
          LoadMemo;
        end else
        begin
          Text := Format('(%s)', [FDataLink.Field.DisplayLabel]);
          FMemoLoaded := False;
        end;
      end else
      begin
        if FFocused and FDataLink.CanModify then
          Text := FDataLink.Field.Text
        else
          Text := FDataLink.Field.DisplayText;

        FMemoLoaded := True;
      end;
    end else
    begin
      if IsDesigning then
        Text := Name
      else
        Text := '';

      FMemoLoaded := False;
    end;
  finally
    Dec(FSettingText);
  end;

  if (Memo <> nil) and Memo.HandleAllocated then
    RedrawWindow(Memo.Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_FRAME);
end;

procedure TSCCustomDBMemo.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not (FDataLink.Editing and FMemoLoaded);
end;

procedure TSCCustomDBMemo.UpdateData(Sender: TObject);
begin
  UpdateFieldData;
end;

procedure TSCCustomDBMemo.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if (FDataLink <> nil) and (not Assigned(FDataLink.Field) or not FDataLink.Field.IsBlob) then
      FDataLink.Reset;
  end;
end;

procedure TSCCustomDBMemo.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and (FDataLink <> nil) and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBMemo.CMExit(var Message: TCMExit);
begin
  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SetFocus;
      raise;
    end;
  end;

  SetFocused(False);
  inherited;
end;

procedure TSCCustomDBMemo.SetAutoDisplay(Value: Boolean);
begin
  if FAutoDisplay <> Value then
  begin
    FAutoDisplay := Value;
    if Value then LoadMemo;
  end;
end;

procedure TSCCustomDBMemo.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if not FMemoLoaded then
    LoadMemo
  else
    inherited;
end;

procedure TSCCustomDBMemo.WMCut(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBMemo.WMUndo(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBMemo.WMPaste(var Message: TMessage);
begin
  if FDataLink <> nil then
    FDataLink.Edit;
  inherited;
end;

procedure TSCCustomDBMemo.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBMemo.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBMemo.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBMemo.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBMemo.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

function TSCCustomDBMemo.GetDbAlignment: TAlignment;
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

function TSCCustomDBMemo.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBMemo.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBMemo then
  begin
    with TSCCustomDBMemo(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.AutoDisplay := AutoDisplay;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
    end;
  end;
end;

procedure TSCCustomDBMemo.UpdateFieldData;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Field.AsString := Text;
end;

function TSCCustomDBMemo.GetMemoEditorClass: TSCMemoEditorClass;
begin
  Result := TSCDBLinkedMemo;
end;

{ TSCCustomDBCheckBox }

constructor TSCCustomDBCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  AllowGrayed := False;
  State := sccbUnchecked;
  FNullIsUnchecked := True;
  FValueCheck := STextTrue;
  FValueUncheck := STextFalse;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
end;

destructor TSCCustomDBCheckBox.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCustomDBCheckBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCustomDBCheckBox.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

function TSCCustomDBCheckBox.GetFieldState: TSCCheckState;
var
  Text: String;
begin
  if (FDatalink <> nil) and (FDatalink.Field <> nil) then
  begin
    if FDataLink.Field.IsNull then
      Result := sccbGrayed
    else
    if FDataLink.Field.DataType = ftBoolean then
    begin
      if FDataLink.Field.AsBoolean then
        Result := sccbChecked
      else
        Result := sccbUnchecked
    end else
    begin
      Result := sccbGrayed;
      Text := FDataLink.Field.Text;

      if ValueMatch(FValueCheck, Text) then
        Result := sccbChecked
      else if ValueMatch(FValueUncheck, Text) then
        Result := sccbUnchecked;
    end
  end else
    Result := sccbUnchecked;
end;

procedure TSCCustomDBCheckBox.DataChange(Sender: TObject);
begin
  Inc(FChangingData);
  try
    State := GetFieldState;
  finally
    Dec(FChangingData);
  end;
end;

procedure TSCCustomDBCheckBox.UpdateData(Sender: TObject);
var
  Pos: Integer;
  S: String;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if State = sccbGrayed then
      FDataLink.Field.Clear
    else
    if FDataLink.Field.DataType = ftBoolean then
      FDataLink.Field.AsBoolean := Checked
    else begin
      if Checked then
        S := FValueCheck
      else
        S := FValueUncheck;

      Pos := 1;
      FDataLink.Field.Text := ExtractFieldName(S, Pos);
    end;
  end;  
end;

function TSCCustomDBCheckBox.ValueMatch(const ValueList, Value: String): Boolean;
var
  Pos: Integer;
begin
  Result := False;
  Pos := 1;
  while Pos <= Length(ValueList) do
    if AnsiCompareText(ExtractFieldName(ValueList, Pos), Value) = 0 then
    begin
      Result := True;
      Break;
    end;
end;

procedure TSCCustomDBCheckBox.StateChanged;
begin
  if not (IsLoading or IsDesigning) and
    (FChangingData = 0) and (FDataLink <> nil) and FDataLink.Edit then
  begin
    inherited StateChanged;
    FDataLink.Modified;
  end;
end;

function TSCCustomDBCheckBox.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCustomDBCheckBox.SetDataSource(Value: TDataSource);
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

function TSCCustomDBCheckBox.GetDataField: String;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCustomDBCheckBox.SetDataField(const Value: String);
begin
  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBCheckBox.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCustomDBCheckBox.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCustomDBCheckBox.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCustomDBCheckBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if FDataLink <> nil then
  begin
    case Key of
      #8, ' ':
        FDataLink.Edit;
      #27:
        FDataLink.Reset;
    end;
  end;
end;

procedure TSCCustomDBCheckBox.SetValueCheck(const Value: String);
begin
  FValueCheck := Value;
  DataChange(Self);
end;

procedure TSCCustomDBCheckBox.SetValueUncheck(const Value: String);
begin
  FValueUncheck := Value;
  DataChange(Self);
end;

procedure TSCCustomDBCheckBox.CMExit(var Message: TCMExit);
begin
  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SetFocus;
      raise;
    end;
  end;
  inherited;
end;

procedure TSCCustomDBCheckBox.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBCheckBox.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or ((FDataLink <> nil) and
    FDataLink.ExecuteAction(Action));
end;

function TSCCustomDBCheckBox.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or ((FDataLink <> nil) and
    FDataLink.UpdateAction(Action));
end;

procedure TSCCustomDBCheckBox.SetNullIsUnchecked(Value: Boolean);
begin
  if FNullIsUnchecked <> Value then
  begin
    FNullIsUnchecked := Value;
    Invalidate;
  end;
end;

function TSCCustomDBCheckBox.GetDrawState: TSCCheckState;
begin
  Result := inherited GetDrawState;
  if FNullIsUnchecked and (Result = sccbGrayed) and not AllowGrayed then
    Result := sccbUnchecked;
end;

procedure TSCCustomDBCheckBox.Toggle;
begin
  if FDataLink.Edit then
  begin
    inherited Toggle;
    FDataLink.Modified;
  end;
end;

procedure TSCCustomDBCheckBox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBCheckBox then
  begin
    with TSCCustomDBCheckBox(Source) do
    begin
      Self.DataSource := DataSource;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.NullIsUnchecked := NullIsUnchecked;
      Self.ValueChecked := ValueChecked;
      Self.ValueUnchecked := ValueUnchecked;
    end;
  end;
end;

{ TSCCustomDBComboBox }

constructor TSCCustomDBComboBox.Create(AOwner: TComponent);
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
  FDataLink.OnActiveChange := ActiveChange;
end;

destructor TSCCustomDBComboBox.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCustomDBComboBox.Loaded;
begin
  inherited Loaded;
  ResetMaxLength;
  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TSCCustomDBComboBox.CreateWnd;
begin
  inherited CreateWnd;
  SetEditReadOnly;
end;

procedure TSCCustomDBComboBox.DataChange(Sender: TObject);
begin
  if DroppedDown then
    Exit;

  UpdateAlignment;
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    SetMask(FDataLink.Field.EditMask);

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
    SetMask('');

    if (EditMask = '') and IsDesigning then
      SetComboText(Name)
    else
      SetComboText('');
  end;
end;

procedure TSCCustomDBComboBox.UpdateData(Sender: TObject);
begin
  UpdateFieldData;
end;

procedure TSCCustomDBComboBox.SetComboText(const Value: String);
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

function TSCCustomDBComboBox.GetComboText: String;
var
  Index: Integer;
begin
  Result := Text;
  if FUseValues then
  begin
    Index := ItemIndex;
    if (Index > -1) and (Index < Values.Count) then
      Result := Values[Index];
  end;
end;

function TSCCustomDBComboBox.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TSCCustomDBComboBox.SetDataSource(Value: TDataSource);
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

function TSCCustomDBComboBox.GetDataField: String;
begin
  Result := FDataLink.FieldName;
end;

procedure TSCCustomDBComboBox.SetDataField(const Value: String);
begin
  if not IsDesigning then
  begin
    ResetEditMask;
    ResetMaxLength;
  end;

  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCustomDBComboBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TSCCustomDBComboBox.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TSCCustomDBComboBox.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TSCCustomDBComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key in [VK_BACK, VK_DELETE, VK_UP, VK_DOWN, 32..255] then
  begin
    if not FDataLink.Edit and (Key in [VK_UP, VK_DOWN]) then
      Key := 0;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomDBComboBox.KeyPress(var Key: Char);
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

procedure TSCCustomDBComboBox.EditingChange(Sender: TObject);
begin
  SetEditReadOnly;
end;

procedure TSCCustomDBComboBox.SetEditReadOnly;
begin
  inherited ReadOnly := (FDataLink = nil) or not FDataLink.Editing;
end;

procedure TSCCustomDBComboBox.WndProc(var Message: TMessage);
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

procedure TSCCustomDBComboBox.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TSCCustomDBComboBox.SetItems(Value: TStrings);
begin
  inherited SetItems(Value);
  DataChange(Self);
end;

function TSCCustomDBComboBox.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCustomDBComboBox.CMGetDatalink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TSCCustomDBComboBox.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBComboBox.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCustomDBComboBox.DoChange;
begin
  if not SettingMask and (FSettingText = 0) and (FDataLink <> nil) and
    not (IsLoading or IsDesigning) then
  begin
    FDataLink.Edit;
    inherited DoChange;
    FDataLink.Modified;

    if not HasFocus then
      UpdateFieldData;
  end else
    inherited DoChange;
end;

procedure TSCCustomDBComboBox.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

procedure TSCCustomDBComboBox.DoListClick(Index: Integer; const Item: String);
begin
  FDataLink.Edit;
  inherited DoListClick(Index, Item);
  FDataLink.Modified;
end;

procedure TSCCustomDBComboBox.DoItemChanging(Index: Integer);
begin
  FDataLink.Edit;
  SetEditReadOnly;
  inherited DoItemChanging(Index);
end;

procedure TSCCustomDBComboBox.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBComboBox.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

function TSCCustomDBComboBox.GetDbAlignment: TAlignment;
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

procedure TSCCustomDBComboBox.BeforeExit;
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

function TSCCustomDBComboBox.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBComboBox.SetUseValues(Value: Boolean);
begin
  FUseValues := Value;
end;

procedure TSCCustomDBComboBox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBComboBox then
  begin
    with TSCCustomDBComboBox(Source) do
    begin
      Self.AutoAlignment := AutoAlignment;
      Self.DataSource := DataSource;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.UseValues := UseValues;
    end;
  end;
end;

procedure TSCCustomDBComboBox.ResetEditMask;
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

procedure TSCCustomDBComboBox.ResetMaxLength;
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

procedure TSCCustomDBComboBox.ActiveChange(Sender: TObject);
begin
  if (FDataLink = nil) or not FDataLink.Active then
  begin
    ResetEditMask;
    ResetMaxLength;
  end;
end;

procedure TSCCustomDBComboBox.SetMask(Value: String);
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

procedure TSCCustomDBComboBox.MaskChanged;
begin
  if FSettingDataMask = 0 then
  begin
    FExternalMask := EditMask <> '';
    DataChange(nil);
  end;
end;

function TSCCustomDBComboBox.IsMaskStored: Boolean;
begin
  Result := FExternalMask or ((FDataLink <> nil) and (FDataLink.Field <> nil) and
    (EditMask <> FDataLink.Field.EditMask));
end;

procedure TSCCustomDBComboBox.UpdateFieldData;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    FDataLink.Field.Text := GetComboText;
end;

function TSCCustomDBComboBox.CanDropDown: Boolean;
begin
  Result := FDataLink.Active and FDataLink.CanModify and
    inherited CanDropDown;
end;

function TSCCustomDBComboBox.GetLineText(Index: Integer): String;
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

{ TSCCusromDBListBox }

constructor TSCCusromDBListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csReplicatable];
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
end;

destructor TSCCusromDBListBox.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TSCCusromDBListBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TSCCusromDBListBox.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TSCCusromDBListBox.DataChange(Sender: TObject);
var
  S: String;
begin
  Inc(FChangingData);
  try
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
    begin
      S := FDataLink.Field.Text;
      if FUseValues and (Values.Count > 0) then
        ItemIndex := Values.IndexOf(S)
      else
        ItemIndex := Items.IndexOf(S);
    end else
      ItemIndex := -1;
  finally
    Dec(FChangingData);
  end;
end;

procedure TSCCusromDBListBox.UpdateData(Sender: TObject);
var
  S: String;
  Index: Integer;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if ItemIndex >= 0 then
    begin
      Index := ItemIndex;
      S := Items[Index];

      if FUseValues and (Index > -1) and (Index < Values.Count) then
        S := Values[Index];

      FDataLink.Field.Text := S;
    end else
      FDataLink.Field.Text := '';
  end;
end;

procedure TSCCusromDBListBox.Click;
begin
  if not (IsLoading or IsDesigning) and
    (FChangingData = 0) and (FDataLink <> nil) and FDataLink.Edit then
  begin
    inherited Click;
    FDataLink.Modified;
  end;
end;

function TSCCusromDBListBox.GetDataSource: TDataSource;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.DataSource;
end;

procedure TSCCusromDBListBox.SetDataSource(Value: TDataSource);
begin
  if FDataLink <> nil then
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

function TSCCusromDBListBox.GetDataField: String;
begin
  Result := '';
  if FDataLink <> nil then
    Result := FDataLink.FieldName;
end;

procedure TSCCusromDBListBox.SetDataField(const Value: String);
begin
  if FDataLink <> nil then
    FDataLink.FieldName := Value;
end;

function TSCCusromDBListBox.GetReadOnly: Boolean;
begin
  Result := (FDataLink = nil) or FDataLink.ReadOnly;
end;

procedure TSCCusromDBListBox.SetReadOnly(Value: Boolean);
begin
  if FDataLink <> nil then
    FDataLink.ReadOnly := Value;
end;

function TSCCusromDBListBox.GetField: TField;
begin
  Result := nil;
  if FDataLink <> nil then
    Result := FDataLink.Field;
end;

procedure TSCCusromDBListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key in [VK_PRIOR, VK_NEXT, VK_END, VK_HOME, VK_LEFT, VK_UP,
    VK_RIGHT, VK_DOWN]) and ((FDataLink = nil) or not FDataLink.Edit) then
    Key := 0;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCusromDBListBox.KeyPress(var Key: Char);
begin
  case Key of
    #32..#255:
      if (FDataLink = nil) or not FDataLink.Edit then
        Key := #0;
    #27:
    if FDataLink <> nil then
      FDataLink.Reset;
  end;

  inherited KeyPress(Key);
end;

procedure TSCCusromDBListBox.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if (FDataLink <> nil) and FDataLink.Edit then
    inherited
  else begin
    SetFocus;
    with Message do
      MouseDown(mbLeft, KeysToShiftState(Keys), XPos, YPos);
  end;
end;

procedure TSCCusromDBListBox.CMExit(var Message: TCMExit);
begin
  if FDataLink <> nil then
  begin
    try
      FDataLink.UpdateRecord;
    except
      SetFocus;
      raise;
    end;
  end;
  inherited;
end;

procedure TSCCusromDBListBox.DoSetItems;
begin
  DataChange(Self);
end;

function TSCCusromDBListBox.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCusromDBListBox.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TSCCusromDBListBox.CanChangeCheckState(OldSt: TSCCheckState;
  var NewSt: TSCCheckState);
begin
  if ReadOnly then
    NewSt := OldSt;
end;

function TSCCusromDBListBox.CanChangeItemIndex(Index: Integer): Integer;
begin
  Result := -1;
  if FDataLink.Field <> nil then
    Result := Index;
end;

procedure TSCCusromDBListBox.SetUseValues(Value: Boolean);
begin
  FUseValues := Value;
end;

procedure TSCCusromDBListBox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCusromDBListBox then
  begin
    with TSCCusromDBListBox(Source) do
    begin
      Self.DataSource := DataSource;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
      Self.UseValues := UseValues;
    end;
  end;
end;

{ TSCCustomDBImage }

constructor TSCCustomDBImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 105;
  Height := 105;
  TabStop := True;
  QuickDraw := True;
  FAutoDisplay := True;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
end;

destructor TSCCustomDBImage.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

function TSCCustomDBImage.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TSCCustomDBImage.SetDataSource(Value: TDataSource);
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

function TSCCustomDBImage.GetDataField: String;
begin
  Result := FDataLink.FieldName;
end;

procedure TSCCustomDBImage.SetDataField(const Value: String);
begin
  FDataLink.FieldName := Value;
end;

function TSCCustomDBImage.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TSCCustomDBImage.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TSCCustomDBImage.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TSCCustomDBImage.SetAutoDisplay(Value: Boolean);
begin
  if FAutoDisplay <> Value then
  begin
    FAutoDisplay := Value;
    if Value then LoadPicture;
  end;
end;

procedure TSCCustomDBImage.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TSCCustomDBImage.LoadPicture;
begin
  if not FPictureLoaded and (not Assigned(FDataLink.Field) or
    FDataLink.Field.IsBlob) then
    Picture.Assign(FDataLink.Field);
end;

procedure TSCCustomDBImage.DataChange(Sender: TObject);
begin
  Picture.Graphic := nil;
  FPictureLoaded := False;
  if FAutoDisplay then LoadPicture;
end;

procedure TSCCustomDBImage.UpdateData(Sender: TObject);
begin
  if Picture.Graphic is TBitmap then
     FDataLink.Field.Assign(Picture.Graphic)
  else
     FDataLink.Field.Clear;
end;

procedure TSCCustomDBImage.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  case Key of
    #13: LoadPicture;
    #27: FDataLink.Reset;
  end;
end;

procedure TSCCustomDBImage.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

procedure TSCCustomDBImage.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TSCCustomDBImage.CMTextChanged(var Message: TMessage);
begin
  inherited;
  if not FPictureLoaded then
    Invalidate;
end;

procedure TSCCustomDBImage.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  LoadPicture;
  inherited;
end;

function TSCCustomDBImage.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TSCCustomDBImage.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

function TSCCustomDBImage.CanDrawCaption: Boolean;
begin
  Result := not (FPictureLoaded or (csPaintCopy in ControlState));
end;

function TSCCustomDBImage.GetPictureCaption: String;
begin
  if FDataLink.Field <> nil then
    Result := FDataLink.Field.DisplayLabel
  else Result := Name;
  Result := '(' + Result + ')';
end;

procedure TSCCustomDBImage.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBImage then
  begin
    with TSCCustomDBImage(Source) do
    begin
      Self.AutoDisplay := AutoDisplay;
      Self.DataSource := DataSource;
      Self.DataField := DataField;
      Self.ReadOnly := ReadOnly;
    end;
  end;
end;

procedure TSCCustomDBImage.DoDrawPicture(G: TGraphic);
var
  DrawPict: TPicture;
begin
  if FPictureLoaded or (csPaintCopy in ControlState) then
  begin
    if (csPaintCopy in ControlState) and Assigned(FDataLink.Field) and
      FDataLink.Field.IsBlob then
    begin
      DrawPict := TPicture.Create;
      try
        DrawPict.Assign(FDataLink.Field);
        if DrawPict.Graphic is TBitmap then
          DrawPict.Bitmap.IgnorePalette := QuickDraw;

        PaintPicture(DrawPict);
      finally
        DrawPict.Free;
      end;
    end else
      inherited DoDrawPicture(G);
  end;
end;

procedure TSCCustomDBImage.DoPictureChanged;
begin
  if FPictureLoaded then FDataLink.Modified;
  FPictureLoaded := True;
  inherited DoPictureChanged;
end;

{ TSCCustomDBLabel }

procedure TSCCustomDBLabel.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomDBLabel then
  begin
    with TSCCustomDBLabel(Source) do
    begin
      Self.DataSource := DataSource;
      Self.AutoAlignment := AutoAlignment;
      Self.DataField := DataField;
    end;
  end;
end;

function TSCCustomDBLabel.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
  if FAutoAlignment and not IsLoading then
    Value := GetDbAlignment;
end;

procedure TSCCustomDBLabel.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
end;

procedure TSCCustomDBLabel.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  SetFocused(False);
  // DoExit;
  inherited;
end;

procedure TSCCustomDBLabel.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

constructor TSCCustomDBLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FAutoAlignment := True;
  AutoSize := False;
  ShowAccelChar := False;
  FDataLink := TSCFieldDataLink.Create;
  FDataLink.OnDataChange := DataChange;
end;

procedure TSCCustomDBLabel.DataChange(Sender: TObject);
begin
  UpdateAlignment;
  if (FDataLink <> nil) and (FDataLink.Field <> nil) then
  begin
    if FFocused and FDataLink.CanModify then
      Caption := FDataLink.Field.Text
    else
      Caption := FDataLink.Field.DisplayText;
  end else
  begin
    if IsDesigning then
      Caption := Name
    else
      Caption := '';
  end;
end;

destructor TSCCustomDBLabel.Destroy;
begin
  FreeAndNil(FDataLink);
  inherited Destroy;
end;

function TSCCustomDBLabel.GetDataField: String;
begin
  Result := FDataLink.FieldName;
end;

function TSCCustomDBLabel.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TSCCustomDBLabel.GetDbAlignment: TAlignment;
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

function TSCCustomDBLabel.GetField: TField;
begin
  Result := FDataLink.Field;
end;

function TSCCustomDBLabel.GetFieldText: String;
begin
  Result := '';
  if FDataLink.Field <> nil then
    Result := FDataLink.Field.DisplayText
  else if IsDesigning then
    Result := Name;
end;

function TSCCustomDBLabel.GetLabelText: String;
begin
  Result := Caption;
  if csPaintCopy in ControlState then
    Result := GetFieldText;
end;

procedure TSCCustomDBLabel.Loaded;
begin
  inherited;
  if IsDesigning then
    DataChange(Self);
end;

procedure TSCCustomDBLabel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TSCCustomDBLabel.SetAutoAlignment(Value: Boolean);
begin
  if FAutoAlignment <> Value then
  begin
    FAutoAlignment := Value;
    UpdateAlignment;
  end;
end;

procedure TSCCustomDBLabel.SetAutoSize(Value: Boolean);
begin
  if AutoSize <> Value then
  begin
    if Value and FDataLink.DataSourceFixed then
      DatabaseError(SDataSourceFixed);

    inherited SetAutoSize(Value);
  end;
end;

procedure TSCCustomDBLabel.SetDataField(const Value: String);
begin
  FDataLink.FieldName := Value;
end;

procedure TSCCustomDBLabel.SetDataSource(Value: TDataSource);
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

procedure TSCCustomDBLabel.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if FDataLink <> nil then
      FDataLink.Reset;
  end;
end;

procedure TSCCustomDBLabel.UpdateAlignment;
begin
  if FAutoAlignment then
    Alignment := GetDbAlignment;
end;

{ TSCDBLinkedMemo }

constructor TSCDBLinkedMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPaintControl := TSCPaintControl.Create(Self, 'EDIT');
end;

destructor TSCDBLinkedMemo.Destroy;
begin
  FPaintControl.Free;
  inherited Destroy;
end;

procedure TSCDBLinkedMemo.WMPaint(var Message: TWMPaint);
var
  S: string;
  C: TSCCustomDBMemo;
begin
  if not (csPaintCopy in ControlState) or (Container = nil) then
    inherited
  else begin
    C := TSCCustomDBMemo(Container);

    S := '';
    if C.FDataLink.Field <> nil then
      if C.FDataLink.Field.IsBlob then
      begin
        if C.FAutoDisplay then
          S := AdjustLineBreaks(C.FDataLink.Field.AsString) else
          S := Format('(%s)', [C.FDataLink.Field.DisplayLabel]);
      end else
        S := C.FDataLink.Field.DisplayText;
        
    SendMessage(FPaintControl.Handle, WM_SETTEXT, 0, Integer(PChar(S)));
    SendMessage(FPaintControl.Handle, WM_ERASEBKGND, Message.DC, 0);
    SendMessage(FPaintControl.Handle, WM_PAINT, Message.DC, 0);
  end;
end;

procedure TSCDBLinkedMemo.WndProc(var Message: TMessage);
begin
  with Message do
    if (Msg = WM_CREATE) or (Msg = WM_WINDOWPOSCHANGED) or
      (Msg = CM_FONTCHANGED) then
      FPaintControl.DestroyHandle;
  inherited;
end;

{$I SCVerRec.inc}

end.

