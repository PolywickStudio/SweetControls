{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCEdits;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, SCConsts, SCResStrs, SCCommon, SCControl, Clipbrd, Menus;

type
  TSCCustomEdit = class;

  TSCEditCharCase = (scecNormal, scecUpperCase, scecLowerCase);

  TSCEditAction = (sceaDelete, sceaInsert, sceaCaretMove);

  TSCEditUndoRec = record
    Action  : TSCEditAction;
    GroupID : Integer;
    CaretPos: TPoint;
    StartPos: TPoint;
    DeletedText: String;
  end;
  PSCEditUndoRec = ^TSCEditUndoRec;

  TSCEditUndoStack = class(TObject)
  private
    FItems: TList;
    FGroupID: Integer;
    function  GetItem(Index: Integer): PSCEditUndoRec;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Clear;
    function  Count: Integer;
    function  Add: PSCEditUndoRec;
    procedure Insert(Index: Integer; Item: PSCEditUndoRec);
    function  Extract(Item: PSCEditUndoRec): PSCEditUndoRec;
    procedure Delete(Index: Integer);
    function  IndexOf(Item: PSCEditUndoRec): Integer;

    function  NewGroupID: Integer;

    property Items[Index: Integer]: PSCEditUndoRec read GetItem; default;
    property GroupID: Integer read FGroupID;
  end;

  TSCEditClipEvent = procedure(Sender: TObject; var ClipText: String; var Allow: Boolean) of object;
  TSCAutoCompleteEvent = procedure(Sender: TObject; var AutoText: String) of object;

  TSCEditMode = (scemInsert, scemOverwrite);

  TSCEditPasswordStyle = (scpsNone, scpsChar, scpsImage);

  TSCDescriptionMode = (scdmNever, scdmWhenEmpty, scdmAlways);

  TSCEditCheckboxStyle = (scecsNone, scecsDefault, scecsFlat, scecsFlatDouble,
    scecsFlatEx, scecsOffice2k);

  TSCEditCheckbox = class(TPersistent)
  private
    FOwner: TSCCustomEdit;
    function  GetAllowGrayed: Boolean;
    procedure SetAllowGrayed(Value: Boolean);
    function  GetChecked: Boolean;
    procedure SetChecked(Value: Boolean);
    function  GetEnabled: Boolean;
    procedure SetEnabled(Value: Boolean);
    function  GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    function  GetState: TSCCheckState;
    procedure SetState(Value: TSCCheckState);
    function  GetStyle: TSCEditCheckboxStyle;
    procedure SetStyle(Value: TSCEditCheckboxStyle);
  protected
    function  GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TSCCustomEdit); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomEdit read FOwner;
  published
    property Visible: Boolean read GetVisible write SetVisible default False;
    property AllowGrayed: Boolean read GetAllowGrayed write SetAllowGrayed default False;
    property Checked: Boolean read GetChecked write SetChecked stored False default False;
    property Enabled: Boolean read GetEnabled write SetEnabled default True;
    property State: TSCCheckState read GetState write SetState default sccbUnchecked;
    property Style: TSCEditCheckboxStyle read GetStyle write SetStyle default scecsDefault;
  end;

  TSCEditKeyAction = (sceaNone, sceaCut, sceaCopy, sceaPaste, sceaUndo, sceaRedo);

  TSCEditBorderProps = class(TSCControlBorderProps)
  public
    constructor Create(AOwner: TSCCustomControl); override;
  published
    property Border default sccb3DLowered;
    property Color default clWindow;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCEditPictureProps = class(TSCPictureProps);

  TSCEditCustomColors = class(TPersistent)
  private
    FOwner: TSCCustomEdit;
    function  GetDescriptionColor: TColor;
    procedure SetDescriptionColor(Value: TColor);
    function  GetDisabledColor: TColor;
    procedure SetDisabledColor(Value: TColor);
    function  GetDisabledTextColor: TColor;
    procedure SetDisabledTextColor(Value: TColor);
    function  GetDragPointerColor: TColor;
    procedure SetDragPointerColor(Value: TColor);
    function  GetFocusColor: TColor;
    procedure SetFocusColor(Value: TColor);
    function  GetFocusTextColor: TColor;
    procedure SetFocusTextColor(Value: TColor);
    function  GetHideSelectionColor: TColor;
    procedure SetHideSelectionColor(Value: TColor);
    function  GetHideSelectionTextColor: TColor;
    procedure SetHideSelectionTextColor(Value: TColor);
    function  GetHighlightColor: TColor;
    procedure SetHighlightColor(Value: TColor);
    function  GetHighlightTextColor: TColor;
    procedure SetHighlightTextColor(Value: TColor);
  protected
    function GetOwner: TPersistent; override;

    property DescriptionColor: TColor read GetDescriptionColor write SetDescriptionColor default clGrayText;
    property DisabledColor: TColor read GetDisabledColor write SetDisabledColor default clBtnFace;
    property DisabledTextColor: TColor read GetDisabledTextColor write SetDisabledTextColor default clGrayText;
    property DragPointerColor: TColor read GetDragPointerColor write SetDragPointerColor default clRed;
    property FocusColor: TColor read GetFocusColor write SetFocusColor default clNone;
    property FocusTextColor: TColor read GetFocusTextColor write SetFocusTextColor default clNone;
    property HideSelectionColor: TColor read GetHideSelectionColor write SetHideSelectionColor default clBtnShadow;
    property HideSelectionTextColor: TColor read GetHideSelectionTextColor write SetHideSelectionTextColor default clBtnHighlight;
    property HighlightColor: TColor read GetHighlightColor write SetHighlightColor default clHighlight;
    property HighlightTextColor: TColor read GetHighlightTextColor write SetHighlightTextColor default clHighlightText;
  public
    constructor Create(AOwner: TSCCustomEdit); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomEdit read FOwner;
  end;

  TSCEditCustomColorsClass = class of TSCEditCustomColors;

  TSCEditColors = class(TSCEditCustomColors)
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

  TSCCustomEdit = class(TSCCustomControl)
  private
    FAlignment: TAlignment;
    FAutoComplete: Boolean;
    FAutoSelect: Boolean;
    FColors: TSCEditCustomColors;
    FCanDragSelection: Boolean;
    FCanEdit: Boolean;
    FCanSelect: Boolean;
    FCharCase: TSCEditCharCase;
    FCheckbox: TSCEditCheckbox;
    FCheckboxAllowGrayed: Boolean;
    FCheckboxEnabled: Boolean;
    FCheckboxVisible: Boolean;
    FCheckboxState: TSCCheckState;
    FCheckboxStyle: TSCEditCheckboxStyle;
    FCheckboxDown: Boolean;
    FCheckboxHot: Boolean;
    FDelimeters: String;
    FDescription: String;
    FDescriptionColor: TColor;
    FDescriptionMode: TSCDescriptionMode;
    FDisabledColor: TColor;
    FDisabledTextColor: TColor;
    FDragPointerColor: TColor;
    FEditCursor: TCursor;
    FEditMode: TSCEditMode;
    FEnterAsTab: Boolean;
    FFocusColor: TColor;
    FFocusExpandSize: Integer;
    FFocusTextColor: TColor;
    FHideSelection: Boolean;
    FHideSelectionColor: TColor;
    FHideSelectionTextColor: TColor;
    FHighlightColor: TColor;
    FHighlightTextColor: TColor;
    FIndentLeft: Integer;
    FIndentRight: Integer;
    FIndentTop: Integer;
    FIndentBottom: Integer;
    FInsertChangesEditMode: Boolean;
    FLayout: TSCEditLayout;
    FLineSpace: Integer;
    FMaxLength: Integer;
    FModified: Boolean;
    {$IFDEF SC_DELPHI2009_EARLY}
    FOEMConvert: Boolean;
    {$ENDIF}
    FPasswordChar: Char;
    FPasswordImage: TImageIndex;
    FPasswordStyle: TSCEditPasswordStyle;
    FReadOnly: Boolean;
    FSelStartPos: TPoint;
    FText: TCaption;
    FTopLine: Integer;
    FUseCaret: Boolean;
    FCaretPoint: TPoint;
    FCaretPos: TPoint;
    FHorzScrollPosition: Integer;
    FInternalChange: Boolean;
    FCharList: TList;
    FCreating: Boolean;
    FIsMouseDown: Boolean;
    FDefaultCursor: TCursor;
    FUseDefaultMenu: Boolean;
    FUpdatingCursor: Boolean;
    FUndoList: TSCEditUndoStack;
    FRedoList: TSCEditUndoStack;
    FUndoLock: Integer;
    FUndoCatch: Integer;
    FUseDelimeters: Boolean;
    FUseImage: Boolean;
    FUseUndo: Boolean;
    FUndoLimit: Integer;
    FImageDown: Boolean;
    FNeedUndoGroup: Boolean;
    FConvertingText: Integer;
    FDefaultMenu: TPopupMenu;
    FSelectionRect: TRect;
    FDraggingSelection: Boolean;
    FDragClickPos: TPoint;
    FDragDropPos: TPoint;
    FOnAutoComplete: TSCAutoCompleteEvent;
    FOnCaretMove: TNotifyEvent;
    FOnInternalChange: TNotifyEvent;
    FOnCheckboxChange: TNotifyEvent;
    FOnClipCut: TSCEditClipEvent;
    FOnClipCopy: TSCEditClipEvent;
    FOnClipPaste: TSCEditClipEvent;
    FOnEditModeChange: TNotifyEvent;
    FOnFocusChanged: TNotifyEvent;
    FEditTextCount: Integer;
    procedure SetAlignment(Value: TAlignment);
    procedure SetCanDragSelection(Value: Boolean);
    procedure SetCanEdit(Value: Boolean);
    procedure SetCanSelect(Value: Boolean);
    procedure SetCharCase(Value: TSCEditCharCase);
    procedure SetCheckbox(Value: TSCEditCheckbox);
    procedure SetCheckboxStyle(Value: TSCEditCheckboxStyle);
    function  GetColors: TSCEditCustomColors;
    procedure SetColors(Value: TSCEditCustomColors);
    procedure SetDescription(const Value: String);
    procedure SetDescriptionColor(Value: TColor);
    procedure SetDescriptionMode(Value: TSCDescriptionMode);
    procedure SetDisabledColor(Value: TColor);
    procedure SetDisabledTextColor(Value: TColor);
    procedure SetDragPointerColor(Value: TColor);
    procedure SetEditCursor(Value: TCursor);
    procedure SetFocusColor(Value: TColor);
    procedure SetFocusExpandSize(Value: Integer);
    procedure SetFocusTextColor(Value: TColor);
    procedure SetHideSelection(Value: Boolean);
    procedure SetHideSelectionColor(Value: TColor);
    procedure SetHideSelectionTextColor(Value: TColor);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHighlightTextColor(Value: TColor);
    procedure SetIndentLeft(Value: Integer);
    procedure SetIndentRight(Value: Integer);
    procedure SetIndentTop(Value: Integer);
    procedure SetIndentBottom(Value: Integer);
    procedure SetLayout(Value: TSCEditLayout);
    procedure SetLineSpace(Value: Integer);
    {$IFDEF SC_DELPHI2009_EARLY}
    procedure SetOEMConvert(Value: Boolean);
    {$ENDIF}
    procedure SetPasswordChar(const Value: Char);
    procedure SetPasswordImage(Value: TImageIndex);
    procedure SetPasswordStyle(Value: TSCEditPasswordStyle);
    procedure SetTopLine(Value: Integer);
    procedure SetUseCaret(Value: Boolean);
    procedure SetUseImage(Value: Boolean);
    procedure SetUseUndo(Value: Boolean);
    procedure SetUndoLimit(Value: Integer);
    function  GetEditValue: String;
    function  GetEditingText: Boolean;

    function  GetCharList: TList;
    procedure RemoveCharList;
    procedure InitiateCharList;

    procedure CMCursorChanged(var Message: TMessage); message CM_CURSORCHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Msg: TMessage); message CM_TEXTCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CMJumpToNext(var Message: TMessage); message CM_SCJUMPTONEXT;
    procedure CNChar(var Message: TWMChar); message CN_CHAR;

    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMCopy(var Message: TMessage); message WM_COPY;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;

    procedure CaretMoved;
    procedure TriggerChange;
    procedure CheckboxChanged;
    procedure InternalSetSelStart(P: TPoint);
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CreateWnd; override;
    procedure Paint; override;
    procedure Loaded; override;
    procedure ConstrainedResize(var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer); override;
    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;

    function  CanAlignText(var Value: TAlignment): Boolean; dynamic;
    procedure ValidateEdit; virtual;
    function  CanPasteStr(var S: String): Boolean; dynamic;

    function  GetReadOnly: Boolean; virtual;
    procedure SetReadOnly(Value: Boolean); virtual;

    function  GetAlignment: TAlignment; virtual;

    procedure DoPictureListChanged; override;
    {$IFDEF SC_DELPHI5_UP}
    procedure DoContextPopup(MousePos : TPoint; var Handled : boolean); override;
    {$ENDIF}

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetPicturePropsClass: TSCCustomPicturePropsClass; override;
    function  GetEditColorsClass: TSCEditCustomColorsClass; dynamic;

    function  AllowSelectionDrag: Boolean; dynamic;
    procedure UpdateSelectionDrag(X, Y: Integer);
    procedure StartSelectionDrag;
    procedure DragDropSelectedText;
    procedure StopSelectionDrag;

    procedure DoColorsChanged; dynamic;
    procedure DoInternalChange; virtual;
    procedure DoCheckboxChanged; dynamic;
    function  AdjustImageTop(ImgTop: Integer): Integer; dynamic;

    procedure AdjustBounds; override;
    function  GetAutoHeight: Integer; dynamic;
    procedure ImageListChange(Sender: TObject); override;

    procedure DoCut(var ClipText: String; var Allow: Boolean); dynamic;
    procedure DoCopy(var ClipText: String; var Allow: Boolean); dynamic;
    procedure DoPaste(var ClipText: String; var Allow: Boolean); dynamic;

    procedure DoAutoCompleted; dynamic;
    procedure SetAutoComplete(Value: Boolean); virtual;
    procedure DoAutoComplete(UpdatePaint: Boolean = True); virtual;
    function  AutoCompleteText: String; virtual;

    function  GetCheckboxAllowGrayed: Boolean; virtual;
    procedure SetCheckboxAllowGrayed(Value: Boolean); virtual;
    function  GetCheckboxChecked: Boolean; virtual;
    procedure SetCheckboxChecked(Value: Boolean); virtual;
    function  GetCheckboxEnabled: Boolean; virtual;
    procedure SetCheckboxEnabled(Value: Boolean); virtual;
    function  GetCheckboxVisible: Boolean; virtual;
    procedure SetCheckboxVisible(Value: Boolean); virtual;
    function  GetCheckboxState: TSCCheckState; virtual;
    procedure SetCheckboxState(Value: TSCCheckState); virtual;

    function  GetCheckboxWidth: Integer; dynamic;
    function  CheckboxWidth: Integer;
    function  GetCheckboxHeight: Integer; dynamic;
    function  CheckboxHeight: Integer;
    function  GetCheckboxRect: TRect; dynamic;
    function  SwitchCheckState(S: TSCCheckState): TSCCheckState;
    procedure ToggleCheckbox;
    procedure RefreshCheckboxHot;

    function  UpdateCharCase(S: String): String;
    {$IFDEF SC_DELPHI2009_EARLY}
    function  OEMConvertText(S: String): String;
    {$ENDIF}
    function  ArrangeText(const S: String): String; virtual;
    procedure SetMaxLength(Value: Integer); virtual;
    function  GetText: TCaption; virtual;
    procedure SetText(Value: TCaption); virtual;
    function  GetLineText(Index: Integer): String; virtual;
    procedure SetEditMode(Value: TSCEditMode); virtual;

    function  SelectionVisible: Boolean; dynamic;
    function  GetSelLength: Integer; virtual;
    function  GetSelText: String; virtual;
    procedure SetSelText(const Value: String); virtual;

    function  CanGetFocus: Boolean; override;
    procedure StopTracking; override;
    procedure EnabledChanged; override;

    function  IsDescription: Boolean; virtual;
    function  GetDescriptionText: String; virtual;
    function  GetDescriptionColor: TColor; virtual;

    procedure BorderChanged; override;
    function  GetBlendValue: Word; override;
    procedure DoCaretMove; dynamic;

    procedure CheckUndoLimitBounds;
    procedure CatchUndo;
    procedure ReleaseUndoCatch;
    procedure BeginUndo;
    procedure EndUndo;
    procedure ClearRedo;
    procedure AddToUndo(Action: TSCEditAction; const Txt: String;
      Caret: TPoint; Start: TPoint; InGroup: Boolean);
    procedure MoveToUndo(Cnt: Integer);
    procedure MoveToRedo(Cnt: Integer);

    procedure UpdateCursor(X, Y: Integer; UseXY: Boolean = False); virtual;

    function  GetImageRect: TRect; override;

    procedure UpdateSelection; dynamic;

    function  GetBackColor: TColor; virtual;
    function  GetForeColor: TColor; virtual;

    procedure UpdateLineFont(F: TFont; Index: Integer); virtual;
    procedure PaintLine(C: TCanvas; Index: Integer; H: Integer = -1; TxTop: Integer = -1); virtual;
    procedure DoDrawBack(C: TCanvas); virtual;
    procedure DoDrawText(C: TCanvas); virtual;
    procedure DoDrawCheckbox(C: TCanvas; R: TRect; IsDown, IsHot: Boolean); virtual;
    function  CanPaintDragArrow: Boolean; dynamic;
    procedure PaintSelectionDrag(C: TCanvas); virtual;

    procedure PopupMenuClicked(Sender: TObject);
    procedure PrepareDefaultMenu(Menu: TPopupMenu); dynamic;
    function  GetPopupMenu: TPopupMenu; override;
    function  GetDefaultMenu: TPopupMenu; dynamic;
    function  ContextPopup(P: TPoint): Boolean; dynamic;

    procedure MouseInControlChanged; override;
    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    function  CanBeepForKey(Key: Word; Shift: TShiftState): Boolean; virtual;
    function  IsValidKey(Key: Char): Boolean; virtual;
    function  EditCanModify: Boolean; virtual;

    function  GetKeyAction(Key: Word; Shift: TShiftState): TSCEditKeyAction; dynamic;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;

    procedure DoKeyDownEvent(var Key: Word; Shift: TShiftState);
    procedure DoKeyPressEvent(var Key: Char);
    procedure DoKeyUpEvent(var Key: Word; Shift: TShiftState);

    function  GetDelimeters: String; dynamic;

    function  GetPrevWordPos(W: TPoint; CheckDelimeters, JumpDelimeters,
      CheckNextIsChar: Boolean): TPoint; dynamic;
    function  GetNextWordPos(W: TPoint; CheckDelimeters: Boolean;
      JumpDelimeters: Boolean = False): TPoint; dynamic;

    function  BeforeDeleteText: Boolean; virtual;
    function  BeforeInsertChar(var Ch: Char): Boolean; virtual;
    function  BeforeInsertText(var S: String): Boolean; virtual;

    function  CanInsertText(S: String): Boolean; virtual;
    procedure DeleteChar(Prev: Boolean); virtual;
    procedure DeleteText(Prev: Boolean); virtual;
    procedure InsertChar(Ch: Char); virtual;
    procedure OverwriteChar(Ch: Char); virtual;
    procedure InsertText(AText: String); virtual;
    procedure Clear; virtual;

    function  CheckTopLine(L: Integer): Integer; virtual;
    procedure UpdateEditArea; virtual;

    function  GetEditCursor: TCursor; virtual;
    function  GetDragCursor: TCursor; virtual;

    function  GetCaretHeight: Word; virtual;
    function  GetCaretSize: TPoint; virtual;
    procedure InitializeCaret;

    procedure ShowCaret;
    procedure HideCaret;
    procedure UpdateCaret;

    procedure EnsureCaretPos(var X, Y: Integer); virtual;
    procedure CheckCaretPos(var X, Y: Integer); virtual;
    procedure UpdateCaretPos(X, Y: Integer); virtual;
    procedure MakeCharVisible(Ch: TPoint; IsCaretPos: Boolean = True); virtual;
    procedure CheckCaretVisible; virtual;

    function  GetCaretPos: TPoint; virtual;
    function  GetCaretPoint(P: TPoint): TPoint; virtual;
    function  GetPointOfChar(Ch: TPoint): TPoint; virtual;
    function  GetCharAtPoint(P: TPoint): TPoint; virtual;

    function  GetCharSize(C: Char): TPoint;
    function  GetCharWidth(C: Char): Integer;
    function  GetCharHeight(C: Char): Integer;
    function  GetTextWidth(S: String): Integer;

    procedure EnsureLineVisible(L: Integer); dynamic;
    function  GetLineWidth(L: Integer): Integer;
    function  GetLineHeight: Integer; virtual;
    function  GetLineLeft(L: Integer): Integer;
    function  GetVisibleLineCount: Integer; dynamic;

    function  GetExtraBorderSize: Integer; virtual;
    function  GetDocumentRect: TRect; dynamic;
    function  GetEditRect: TRect; virtual;
    procedure SetEditRect(R: TRect); virtual;
    function  GetSelectionRect: TRect; virtual;

    function  IsPassword: Boolean;
    procedure NeedUndoGroup;

    property EditTextCount: Integer read FEditTextCount;
    property EditingText: Boolean read GetEditingText;

    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AutoComplete: Boolean read FAutoComplete write SetAutoComplete default False;
    property AutoSelect: Boolean read FAutoSelect write FAutoSelect default True;
    property AutoSize default True;
    property BorderProps;
    property CanDragSelection: Boolean read FCanDragSelection write SetCanDragSelection default False;
    property CanEdit: Boolean read FCanEdit write SetCanEdit default True;
    property CanSelect: Boolean read FCanSelect write SetCanSelect default True;
    property CaretPoint: TPoint read FCaretPoint;
    property CaretPos: TPoint read FCaretPos;
    property CharCase: TSCEditCharCase read FCharCase write SetCharCase default scecNormal;
    property Checkbox: TSCEditCheckbox read FCheckbox write SetCheckbox;
    property CheckboxAllowGrayed: Boolean read GetCheckboxAllowGrayed write SetCheckboxAllowGrayed default False;
    property CheckboxChecked: Boolean read GetCheckboxChecked write SetCheckboxChecked default False;
    property CheckboxEnabled: Boolean read GetCheckboxEnabled write SetCheckboxEnabled default True;
    property CheckboxVisible: Boolean read GetCheckboxVisible write SetCheckboxVisible default False;
    property CheckboxState: TSCCheckState read GetCheckboxState write SetCheckboxState default sccbUnchecked;
    property CheckboxStyle: TSCEditCheckboxStyle read FCheckboxStyle write SetCheckboxStyle default scecsDefault;
    property CheckboxDown: Boolean read FCheckboxDown;
    property CheckboxHot: Boolean read FCheckboxHot;
    property Color default clWindow;
    property Colors: TSCEditCustomColors read GetColors write SetColors;
    property Delimeters: String read FDelimeters write FDelimeters;
    property Description: String read FDescription write SetDescription;
    property DescriptionColor: TColor read FDescriptionColor write SetDescriptionColor default clGrayText;
    property DescriptionMode: TSCDescriptionMode read FDescriptionMode write SetDescriptionMode default scdmNever;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clBtnFace;
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText;
    property DragDropPos: TPoint read FDragDropPos;
    property DragPointerColor: TColor read FDragPointerColor write SetDragPointerColor default clRed;
    property DraggingSelection: Boolean read FDraggingSelection;
    property EditCursor: TCursor read FEditCursor write SetEditCursor default crIBeam;
    property EditMode: TSCEditMode read FEditMode write SetEditMode default scemInsert;
    property EnterAsTab: Boolean read FEnterAsTab write FEnterAsTab default False;
    property FocusExpandSize: Integer read FFocusExpandSize write SetFocusExpandSize default 0;
    property FocusColor: TColor read FFocusColor write SetFocusColor default clNone;
    property FocusTextColor: TColor read FFocusTextColor write SetFocusTextColor default clNone;
    property HideSelection: Boolean read FHideSelection write SetHideSelection default True;
    property HideSelectionColor: TColor read FHideSelectionColor write SetHideSelectionColor default clBtnShadow;
    property HideSelectionTextColor: TColor read FHideSelectionTextColor write SetHideSelectionTextColor default clBtnHighlight;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default clHighlight;
    property HighlightTextColor: TColor read FHighlightTextColor write SetHighlightTextColor default clHighlightText;
    property ImageDown: Boolean read FImageDown;
    property IndentLeft: Integer read FIndentLeft write SetIndentLeft default 0;
    property IndentRight: Integer read FIndentRight write SetIndentRight default 0;
    property IndentTop: Integer read FIndentTop write SetIndentTop default 0;
    property IndentBottom: Integer read FIndentBottom write SetIndentBottom default 0;
    property InsertChangesEditMode: Boolean read FInsertChangesEditMode write FInsertChangesEditMode default False;
    property IsMouseDown: Boolean read FIsMouseDown;
    property Layout: TSCEditLayout read FLayout write SetLayout default scelTop;
    property LineSpace: Integer read FLineSpace write SetLineSpace default 0;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    {$IFDEF SC_DELPHI2009_EARLY}
    property OEMConvert: Boolean read FOEMConvert write SetOEMConvert default False;
    {$ENDIF}
    property ParentColor default False;
    property PasswordChar: Char read FPasswordChar write SetPasswordChar default #0;
    property PasswordImage: TImageIndex read FPasswordImage write SetPasswordImage default -1;
    property PasswordStyle: TSCEditPasswordStyle read FPasswordStyle write SetPasswordStyle default scpsNone;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property SelLength: Integer read GetSelLength;
    property SelStart: TPoint read FSelStartPos;
    property SelText: String read GetSelText;
    property SelectionRect: TRect read FSelectionRect;
    property TabStop default True;
    property Text: TCaption read GetText write SetText;
    property TopLine: Integer read FTopLine write SetTopLine default 0;
    property UseCaret: Boolean read FUseCaret write SetUseCaret default True;
    property UseDefaultMenu: Boolean read FUseDefaultMenu write FUseDefaultMenu default True;
    property UseDelimeters: Boolean read FUseDelimeters write FUseDelimeters default True;
    property UseImage: Boolean read FUseImage write SetUseImage default False;
    property UseUndo: Boolean read FUseUndo write SetUseUndo default True;
    property UndoLimit: Integer read FUndoLimit write SetUndoLimit default 0;
    property OnAutoComplete: TSCAutoCompleteEvent read FOnAutoComplete write FOnAutoComplete;
    property OnCaretMove: TNotifyEvent read FOnCaretMove write FOnCaretMove;
    property OnCheckboxChange: TNotifyEvent read FOnCheckboxChange write FOnCheckboxChange;
    property OnClipCut: TSCEditClipEvent read FOnClipCut write FOnClipCut;
    property OnClipCopy: TSCEditClipEvent read FOnClipCopy write FOnClipCopy;
    property OnClipPaste: TSCEditClipEvent read FOnClipPaste write FOnClipPaste;
    property OnEditModeChange: TNotifyEvent read FOnEditModeChange write FOnEditModeChange;
    property OnFocusChanged: TNotifyEvent read FOnFocusChanged write FOnFocusChanged;
    property OnInternalChange: TNotifyEvent read FOnInternalChange write FOnInternalChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure SetSelRect(R: TRect); virtual;
    procedure SelectAll; dynamic;
    procedure SelectWord(CheckDelimeters: Boolean); dynamic;
    procedure ClearSelection; dynamic;

    function  HasSelection: Boolean; dynamic;
    function  CanCopy: Boolean; dynamic;
    function  CanPaste: Boolean; dynamic;
    function  CanCut: Boolean; dynamic;

    procedure CopyToClipboard; dynamic;
    procedure PasteFromClipboard; dynamic;
    procedure CutToClipboard; dynamic;

    function  CanUndo: Boolean; dynamic;
    function  CanRedo: Boolean; dynamic;
    procedure Undo; dynamic;
    procedure Redo; dynamic;
    procedure ClearUndo; dynamic;

    property ClickFocus default False;
    property Modified: Boolean read FModified write FModified default False;
    property EditValue: String read GetEditValue;
  end;

  TSCCustomEditClass = class of TSCCustomEdit;

  TSCEdit = class(TSCCustomEdit)
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

{ TSCEditBorderProps }

constructor TSCEditBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccb3DLowered;
  Color := clWindow;
end;

{ TSCEditCheckbox }

procedure TSCEditCheckbox.Assign(Source: TPersistent);
begin
  if Source is TSCEditCheckbox then
  begin
    with TSCEditCheckbox(Source) do
    begin
      Self.Visible := Visible;

      Self.AllowGrayed := AllowGrayed;
      Self.Enabled := Enabled;
      Self.State := State;
      Self.Style := Style;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCEditCheckbox.Create(AOwner: TSCCustomEdit);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCEditCheckbox.GetAllowGrayed: Boolean;
begin
  Result := False;
  if FOwner <> nil then Result := FOwner.CheckboxAllowGrayed;
end;

function TSCEditCheckbox.GetChecked: Boolean;
begin
  Result := False;
  if FOwner <> nil then Result := FOwner.CheckboxChecked;
end;

function TSCEditCheckbox.GetEnabled: Boolean;
begin
  Result := True;
  if FOwner <> nil then Result := FOwner.CheckboxEnabled;
end;

function TSCEditCheckbox.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCEditCheckbox.GetState: TSCCheckState;
begin
  Result := sccbUnchecked;
  if FOwner <> nil then Result := FOwner.CheckboxState;
end;

function TSCEditCheckbox.GetStyle: TSCEditCheckboxStyle;
begin
  Result := scecsDefault;
  if FOwner <> nil then Result := FOwner.CheckboxStyle;
end;

function TSCEditCheckbox.GetVisible: Boolean;
begin
  Result := False;
  if FOwner <> nil then Result := FOwner.CheckboxVisible;
end;

procedure TSCEditCheckbox.SetAllowGrayed(Value: Boolean);
begin
  if FOwner <> nil then FOwner.CheckboxAllowGrayed := Value;
end;

procedure TSCEditCheckbox.SetChecked(Value: Boolean);
begin
  if FOwner <> nil then FOwner.CheckboxChecked := Value;
end;

procedure TSCEditCheckbox.SetEnabled(Value: Boolean);
begin
  if FOwner <> nil then FOwner.CheckboxEnabled := Value;
end;

procedure TSCEditCheckbox.SetState(Value: TSCCheckState);
begin
  if FOwner <> nil then FOwner.CheckboxState := Value;
end;

procedure TSCEditCheckbox.SetStyle(Value: TSCEditCheckboxStyle);
begin
  if FOwner <> nil then FOwner.CheckboxStyle := Value;
end;

procedure TSCEditCheckbox.SetVisible(Value: Boolean);
begin
  if FOwner <> nil then FOwner.CheckboxVisible := Value;
end;

{ TSCEditCustomColors }

procedure TSCEditCustomColors.Assign(Source: TPersistent);
begin
  if Source is TSCEditCustomColors then
  begin
    with TSCEditCustomColors(Source) do
    begin
      Self.DescriptionColor := DescriptionColor;
      Self.DisabledColor := DisabledColor;
      Self.DisabledTextColor := DisabledTextColor;
      Self.DragPointerColor := DragPointerColor;
      Self.FocusColor := FocusColor;
      Self.FocusTextColor := FocusTextColor;
      Self.HideSelectionColor := HideSelectionColor;
      Self.HideSelectionTextColor := HideSelectionTextColor;
      Self.HighlightColor := HighlightColor;
      Self.HighlightTextColor := HighlightTextColor;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCEditCustomColors.Create(AOwner: TSCCustomEdit);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCEditCustomColors.GetDescriptionColor: TColor;
begin
  Result := clGrayText;
  if FOwner <> nil then
    Result := FOwner.DescriptionColor;
end;

function TSCEditCustomColors.GetDisabledColor: TColor;
begin
  Result := clBtnFace;
  if FOwner <> nil then
    Result := FOwner.DisabledColor;
end;

function TSCEditCustomColors.GetDisabledTextColor: TColor;
begin
  Result := clGrayText;
  if FOwner <> nil then
    Result := FOwner.DisabledTextColor;
end;

function TSCEditCustomColors.GetDragPointerColor: TColor;
begin
  Result := clRed;
  if FOwner <> nil then
    Result := FOwner.DragPointerColor;
end;

function TSCEditCustomColors.GetFocusColor: TColor;
begin
  Result := clNone;
  if FOwner <> nil then
    Result := FOwner.FocusColor;
end;

function TSCEditCustomColors.GetFocusTextColor: TColor;
begin
  Result := clNone;
  if FOwner <> nil then
    Result := FOwner.FocusTextColor;
end;

function TSCEditCustomColors.GetHideSelectionColor: TColor;
begin
  Result := clBtnShadow;
  if FOwner <> nil then
    Result := FOwner.HideSelectionColor;
end;

function TSCEditCustomColors.GetHideSelectionTextColor: TColor;
begin
  Result := clBtnHighlight;
  if FOwner <> nil then
    Result := FOwner.HideSelectionTextColor;
end;

function TSCEditCustomColors.GetHighlightColor: TColor;
begin
  Result := clHighlight;
  if FOwner <> nil then
    Result := FOwner.HighlightColor;
end;

function TSCEditCustomColors.GetHighlightTextColor: TColor;
begin
  Result := clHighlightText;
  if FOwner <> nil then
    Result := FOwner.HighlightTextColor;
end;

function TSCEditCustomColors.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCEditCustomColors.SetDescriptionColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.DescriptionColor := Value;
end;

procedure TSCEditCustomColors.SetDisabledColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.DisabledColor := Value;
end;

procedure TSCEditCustomColors.SetDisabledTextColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.DisabledTextColor := Value;
end;

procedure TSCEditCustomColors.SetDragPointerColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.DragPointerColor := Value;
end;

procedure TSCEditCustomColors.SetFocusColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.FocusColor := Value;
end;

procedure TSCEditCustomColors.SetFocusTextColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.FocusTextColor := Value;
end;

procedure TSCEditCustomColors.SetHideSelectionColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.HideSelectionColor := Value;
end;

procedure TSCEditCustomColors.SetHideSelectionTextColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.HideSelectionTextColor := Value;
end;

procedure TSCEditCustomColors.SetHighlightColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.HighlightColor := Value;
end;

procedure TSCEditCustomColors.SetHighlightTextColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.HighlightTextColor := Value;
end;

{ TSCCustomEdit }

function TSCCustomEdit.ArrangeText(const S: String): String;
var
  P: Integer;
begin
  Result := S;

  if Result <> '' then
  begin
    P := Pos(#0, Result);
    if P > 0 then
      Result := Copy(Result, 1, P-1);

    P := Pos(#10, Result);
    if P > 0 then
      Result := Copy(Result, 1, P-1);

    P := Pos(#13, Result);
    if P > 0 then
      Result := Copy(Result, 1, P-1);
  end;
end;

procedure TSCCustomEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomEdit then
  begin
    with TSCCustomEdit(Source) do
    begin
      Self.Alignment := Alignment;
      Self.AutoComplete := AutoComplete;
      Self.AutoSelect := AutoSelect;
      Self.AutoSize := AutoSize;
      Self.CanDragSelection := CanDragSelection;
      Self.CanEdit := CanEdit;
      Self.CanSelect := CanSelect;
      Self.CharCase := CharCase;
      Self.Checkbox := Checkbox;
      Self.Colors := Colors;
      Self.Delimeters := Delimeters;
      Self.Description := Description;
      Self.DescriptionMode := DescriptionMode;
      Self.EditCursor := EditCursor;
      Self.EditMode := EditMode;
      Self.EnterAsTab := EnterAsTab;
      Self.FocusExpandSize := FocusExpandSize;
      Self.HideSelection := HideSelection;
      Self.InsertChangesEditMode := InsertChangesEditMode;
      Self.Layout := Layout;
      Self.MaxLength := MaxLength;
      {$IFDEF SC_DELPHI2009_EARLY}
      Self.OEMConvert := OEMConvert;
      {$ENDIF}
      Self.PasswordChar := PasswordChar;
      Self.PasswordImage := PasswordImage;
      Self.PasswordStyle := PasswordStyle;
      Self.Picture := Picture;
      Self.PictureProps := PictureProps;
      Self.ReadOnly := ReadOnly;
      Self.UseCaret := UseCaret;
      Self.UseDefaultMenu := UseDefaultMenu;
      Self.UseDelimeters := UseDelimeters;
      Self.UseImage := UseImage;
      Self.UseUndo := UseUndo;
      Self.UndoLimit := UndoLimit;
    end;
  end;
end;

function TSCCustomEdit.CheckTopLine(L: Integer): Integer;
begin
  Result := 0;
end;

procedure TSCCustomEdit.Clear;
begin
  if not ReadOnly and (FText <> '') and BeforeDeleteText then
    Text := '';
end;

procedure TSCCustomEdit.ClearSelection;
var
  S: String;
  R: TRect;
  Ln, P: Integer;
begin
  if not ReadOnly and HasSelection and BeforeDeleteText then
  begin
    Ln := Length(FText);
    if Ln = 0 then Exit;

    if FCaretPos.X < FSelStartPos.X then
      P := FCaretPos.X + 1
    else
      P := FSelStartPos.X + 1;

    if P > Ln then
      P := Ln;

    S := '';
    if FUndoLock = 0 then
      S := Copy(FText, P, Abs(FCaretPos.X - FSelStartPos.X));

    Delete(FText, P, Abs(FCaretPos.X - FSelStartPos.X));

    if FCaretPos.X < FSelStartPos.X then
      R := Rect(FCaretPos.X, FCaretPos.Y, FCaretPos.X, FCaretPos.Y)
    else
      R := Rect(FSelStartPos.X, FSelStartPos.Y, FSelStartPos.X, FSelStartPos.Y);

    if S <> '' then
    begin
      FModified := True;
      AddToUndo(sceaDelete, S, FCaretPos, FSelStartPos, False);
    end;

    SetSelRect(R);

    CaretMoved;
    TriggerChange;
  end;
end;

procedure TSCCustomEdit.CMFontChanged(var Message: TMessage);
begin
  inherited;
  InitiateCharList;

  AdjustSize;
  Invalidate;

  UpdateCaret;
  CheckCaretVisible;
end;

procedure TSCCustomEdit.CMTextChanged(var Msg: TMessage);
begin
  if FConvertingText = 0 then
  begin
    inherited;
    SetText(Caption);
  end;

  Inc(FConvertingText);
  try
    Caption := '';
  finally
    Dec(FConvertingText);
  end;
end;

procedure TSCCustomEdit.CopyToClipboard;
var
  S: String;
  Allow: Boolean;
begin
  if CanCopy then
  begin
    S := GetSelText;

    if S <> '' then
    begin
      Allow := True;
      DoCopy(S, Allow);

      if Allow then
        Clipboard.SetTextBuf(PChar(S));
    end;
  end;
end;

constructor TSCCustomEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csSetCaption];
  SetBounds(Left, Top, 120, 21);
  Border := sccb3DLowered;
  BorderColor := clWindow;
  ParentColor := False;
  Color := clWindow;
  TabStop := True;
  AutoSize := True;
  DoubleBuffered := True;
  ClickFocus := False;

  FAlignment := taLeftJustify;

  FAutoSelect := True;
  FCanSelect := True;
  FCanEdit := True;
  FCharCase := scecNormal;
  FCheckboxAllowGrayed := False;
  FCheckboxEnabled := True;
  FCheckboxVisible := False;
  FCheckboxState := sccbUnchecked;
  FCheckboxStyle := scecsDefault;
  FDescriptionColor := clGrayText;
  FDescriptionMode  := scdmNever;
  FDisabledColor := clBtnFace;
  FDisabledTextColor := clGrayText;
  FDragPointerColor := clRed;
  FEditCursor := crIBeam;
  FEditMode := scemInsert;
  FFocusColor := clNone;
  FFocusTextColor := clNone;
  FHideSelection := True;
  FHideSelectionColor := clBtnShadow;
  FHideSelectionTextColor := clBtnHighlight;
  FHighlightColor := clHighlight;
  FHighlightTextColor := clHighlightText;
  FInternalChange := False;
  FCaretPos  := Point(0, 0);
  FLayout := scelTop;
  FLineSpace := 0;
  FSelStartPos := Point(0, 0);
  FPasswordImage := -1;
  FPasswordStyle := scpsNone;
  FTopLine   := 0;
  FUseCaret  := True;
  FUseDefaultMenu := True;
  FUseDelimeters := True;
  FUseUndo := True;
  FUndoLimit := 0;

  FSelectionRect := Rect(0, 0, 0, 0);
  FDragClickPos := Point(-1, -1);
  FDragDropPos := Point(-1, -1);

  FCheckbox := TSCEditCheckbox.Create(Self);
  FColors := GetEditColorsClass.Create(Self);
end;

procedure TSCCustomEdit.CutToClipboard;
var
  S: String;
  Allow: Boolean;
begin
  if CanCut then
  begin
    S := SelText;

    if S <> '' then
    begin
      Allow := True;
      DoCut(S, Allow);

      if Allow then
      begin
        Clipboard.SetTextBuf(PChar(S));
        ClearSelection;

        if FAutoComplete then
          DoAutoComplete(True);
      end;
    end;
  end;
end;

procedure TSCCustomEdit.DeleteChar(Prev: Boolean);
var
  P: TPoint;
  Ch: Char;
  S: String;
  Ln, St: Integer;
  Complete: Boolean;
begin
  if ReadOnly then
    Exit;

  if HasSelection and BeforeDeleteText then
  begin
    Complete := FAutoComplete;
    ClearSelection;

    Ln := Length(Text);
    if (Ln > 0) and (FCaretPos.X = Ln) then
      Complete := False;

    if Complete then
    begin
      S := '';
      if Prev then
        S := Text;

      DoAutoComplete(False);
      if Prev and (S <> Text) and
        (FSelStartPos.x = Length(Text)) and (FSelStartPos.y = 0) then
      begin
        P := FCaretPos;
        if Prev then
          Dec(P.x);

        EnsureCaretPos(P.x, P.y);
        UpdateCaretPos(P.x, P.y);

        FSelStartPos.x := Length(Text);
        FSelStartPos.y := 0;

        if FAutoComplete then
          DoAutoComplete(False);
        Invalidate;

        UpdateCaret;
        CheckCaretVisible;

        TriggerChange;
      end;
    end;
  end else
  begin
    Ln := Length(FText);
    if Ln = 0 then Exit;

    P := FCaretPos;
    EnsureCaretPos(P.x, P.y);

    if not Prev then
      Inc(P.x);

    if (P.x < 0) or (P.x > Ln) or (Prev and (P.x = 0)) then
      Exit;

    Ch := #0;
    if (FUndoLock = 0) and (P.x > 0) and (P.x < Ln + 1) then
      Ch := FText[P.x];

    if not BeforeDeleteText then Exit;  

    Delete(FText, P.x, 1);
    if Ln = Length(FText) then
      Exit;

    FModified := True;
    if (Ch <> #0) and (FUndoLock = 0) then
    begin
      St := FCaretPos.X + 1;
      if Prev then St := FCaretPos.X - 1;

      AddToUndo(sceaDelete, Ch, FCaretPos, Point(St, FCaretPos.Y), True);
    end;

    P := FCaretPos;
    if Prev then
      Dec(P.x);

    EnsureCaretPos(P.x, P.y);
    UpdateCaretPos(P.x, P.y);

    InternalSetSelStart(FCaretPos);

    if FAutoComplete and (FCaretPos.X <> Length(Text)) then
      DoAutoComplete(False);

    Invalidate;

    UpdateCaret;
    CheckCaretVisible;

    TriggerChange;
  end;
end;

procedure TSCCustomEdit.DeleteText(Prev: Boolean);
var
  P, P2: TPoint;
  S: String;
  Ln, St: Integer;
  Complete: Boolean;
begin
  if ReadOnly then
    Exit;

  if HasSelection and BeforeDeleteText then
  begin
    Complete := FAutoComplete;
    ClearSelection;

    Ln := Length(Text);
    if (Ln > 0) and (FCaretPos.X = Ln) then
      Complete := False;

    if Complete then
    begin
      S := '';
      if Prev then
        S := Text;

      DoAutoComplete(False);
      if Prev and (S <> Text) and
        (FSelStartPos.x = Length(Text)) and (FSelStartPos.y = 0) then
      begin
        P := FCaretPos;
        if Prev then
          Dec(P.x);

        EnsureCaretPos(P.x, P.y);
        UpdateCaretPos(P.x, P.y);

        FSelStartPos.x := Length(Text);
        FSelStartPos.y := 0;

        if FAutoComplete then
          DoAutoComplete(False);
        Invalidate;

        UpdateCaret;
        CheckCaretVisible;

        TriggerChange;
      end;
    end;
  end else
  begin
    Ln := Length(FText);
    if Ln = 0 then Exit;

    P := FCaretPos;
    EnsureCaretPos(P.x, P.y);

    if not Prev then
      Inc(P.x);

    if (P.x < 0) or (P.x > Ln) or (Prev and (P.x = 0)) then
      Exit;

    P2 := P;
    if Prev then
    begin
      P2 := GetPrevWordPos(P, True, True, False);
      Inc(P2.x);

      if (P.x <= P2.x) and (P.y = P2.y) then
        Exit;
    end;

    S := '';
    if (FUndoLock = 0) and (P.x > 0) and (P.x < Ln + 1) then
    begin
      if Prev then
        S := Copy(FText, P2.x, P.x - P2.x + 1)
      else
        S := Copy(FText, P.x, Length(FText) - P.x + 1);
    end;

    if not BeforeDeleteText then
      Exit;

    if Prev then
      Delete(FText, P2.x, P.x - P2.x + 1)
    else
      Delete(FText, P.x, Length(S));

    if Ln = Length(FText) then
      Exit;

    FModified := True;
    if (S <> '') and (FUndoLock = 0) then
    begin
      St := P.x + Length(S);
      if Prev then St := P2.x - 1;

      AddToUndo(sceaDelete, S, FCaretPos, Point(St, FCaretPos.Y), False);
    end;

    P := FCaretPos;
    if Prev then
    begin
      P := P2;
      Dec(P.x);
    end;

    EnsureCaretPos(P.x, P.y);
    UpdateCaretPos(P.x, P.y);

    InternalSetSelStart(FCaretPos);

    if FAutoComplete and (FCaretPos.X <> Length(Text)) then
      DoAutoComplete(False);

    Invalidate;

    UpdateCaret;
    CheckCaretVisible;

    TriggerChange;
  end;
end;

destructor TSCCustomEdit.Destroy;
begin
  ClearUndo;

  DestroyCaret;
  RemoveCharList;

  if FDefaultMenu <> nil then
    FreeAndNil(FDefaultMenu);

  FreeAndNil(FCheckbox);
  FreeAndNil(FColors);
  inherited Destroy;
end;

procedure TSCCustomEdit.DoDrawText(C: TCanvas);
var
  CR, R: TRect;
  SR: Integer;
begin
  if C = nil then
    Exit;

  CR := GetClientRect;
  if not IsRectEmpty(CR) then
  begin
    R := GetEditRect;
    IntersectRect(R, R, CR);

    if not IsRectEmpty(R) then
    begin
      SR := IntersectClipRect(C.Handle, R.Left, R.Top, R.Right, R.Bottom);
      try
        if SR <> NULLREGION then
          PaintLine(C, 0, -1, 0);
      finally
        SelectClipRgn(C.Handle, 0);
      end;
    end;
  end;
end;

procedure TSCCustomEdit.EnsureCaretPos(var X, Y: Integer);
var
  Ln: Integer;
begin
  if IsDesigning then
  begin
    X := 0;
    Y := 0;

    Exit;
  end;

  if Y < 0 then Y := 0;

  Ln := Length(FText);

  if X > Ln then
    X := Ln;
  if X < 0 then X := 0;
end;

procedure TSCCustomEdit.EnsureLineVisible(L: Integer);
begin

end;

function TSCCustomEdit.GetCaretPoint(P: TPoint): TPoint;
var
  R: TRect;
  I: Integer;
begin
  Result := Point(0, 0);

  R := GetEditRect;

  Inc(Result.x, R.Left - FHorzScrollPosition);
  Result.y := R.Top;

  EnsureCaretPos(P.x, P.y);

  if FAlignment <> taLeftJustify then
    Inc(Result.x, GetLineLeft(0));

  if IsPassword then
  begin
    Inc(Result.x, GetCharWidth(FPasswordChar)*P.x);
    Exit;
  end;

  for I := 1 to P.x do
    Inc(Result.x, GetCharWidth(FText[I]));
end;

function TSCCustomEdit.GetCaretPos: TPoint;
begin
  Result := Point(0, 0);
end;

function TSCCustomEdit.GetCaretSize: TPoint;
begin
  Result := Point(0, 0);
  if HandleAllocated then
  begin
    Result.x := 1;

    Result.y := GetCaretHeight;
    Dec(Result.y, FLineSpace);
  end;
end;

function TSCCustomEdit.GetCharHeight(C: Char): Integer;
var
  I: Integer;
  P: PPoint;
  L: TList;
begin
  Result := 0;

  if (FPasswordStyle = scpsImage) and (FPasswordImage > -1) then
  begin
    Result := 16;
    if Images <> nil then
      Result := Images.Height;
  end else
  begin
    L := GetCharList;

    I := Ord(C);
    if (L <> nil) and (I > 0) and (I < L.Count) then
    begin
      P := L.Items[I];
      Result := P^.y;
    end;
  end;
end;

function TSCCustomEdit.GetCharList: TList;
begin
  if FCharList = nil then
    InitiateCharList;
  Result := FCharList;
end;

function TSCCustomEdit.GetPointOfChar(Ch: TPoint): TPoint;
var
  R: TRect;
  I: Integer;
begin
  EnsureCaretPos(Ch.X, Ch.Y);

  R := GetEditRect;
  Dec(R.Left, FHorzScrollPosition);

  Result := R.TopLeft;

  if FAlignment <> taLeftJustify then
    Inc(Result.X, GetLineLeft(0));

  if IsPassword then
  begin
    Inc(Result.X, GetCharWidth(FPasswordChar)*Ch.x);
    Exit;
  end;

  for I := 1 to Ch.X do
    Inc(Result.X, GetCharWidth(FText[I]));
end;

function TSCCustomEdit.GetCharSize(C: Char): TPoint;
var
  I: Integer;
  P: PPoint;
  L: TList;
begin
  Result := Point(0, 0);

  if (FPasswordStyle = scpsImage) and (FPasswordImage > -1) then
  begin
    Result.x := 16;
    Result.y := 16;

    if Images <> nil then
    begin
      Result.x := Images.Width;
      Result.y := Images.Height;
    end;
  end else
  begin
    L := GetCharList;

    I := Ord(C);
    if (L <> nil) and (I > 0) and (I < L.Count) then
    begin
      P := L.Items[I];
      Result.x := P^.x;
      Result.y := P^.y;
    end;
  end;
end;

function TSCCustomEdit.GetCharWidth(C: Char): Integer;
var
  I: Integer;
  P: PPoint;
  L: TList;
begin
  Result := 0;

  if (FPasswordStyle = scpsImage) and (FPasswordImage > -1) then
  begin
    Result := 16;
    if Images <> nil then
      Result := Images.Width;
  end else
  begin
    L := GetCharList;

    I := Ord(C);
    if (L <> nil) and (I > 0) and (I < L.Count) then
    begin
      P := L.Items[I];
      Result := P^.x;
    end;
  end;
end;

function TSCCustomEdit.GetDocumentRect: TRect;
var
  L: Integer;
begin
  L := GetLineHeight;
  Result := Rect(0, 0, GetLineWidth(0), L);
end;

function TSCCustomEdit.GetEditRect: TRect;
var
  R: TRect;
  Eh, Ew, B, H, L: Integer;
begin
  R := GetClientRect;
  Result := R;

  B := 0;
  if (Border <> sccbNone) or (BorderInner <> sccbNone) then
    B := 1;

  Eh := GetExtraBorderSize;
  if Eh < 0 then Eh := 0;

  Ew := Eh;
  if Eh > 0 then Inc(Ew);

  Inc(Result.Left,  FIndentLeft);
  Dec(Result.Right, FIndentRight);

  InflateRect(Result, -(B + Ew), -Eh);

  if FUseImage and (Images <> nil) then
    Inc(Result.Left, Images.Width + 4);

  Inc(Result.Left, CheckboxWidth);

  if Result.Left < R.Left then
    Result.Left := R.Left;

  if Result.Left > R.Right then
    Result.Left := R.Right;

  if Result.Right < R.Left then
    Result.Right := R.Left;

  if Result.Right > R.Right then
    Result.Right := R.Right;

  Inc(Result.Top, FIndentTop);
  Dec(Result.Bottom, FIndentBottom);

  InflateRect(Result, 0, -B);

  case FLayout of
    scelBottom:
    begin
      L := GetLineHeight;
      Result.Top := Result.Bottom - L;
    end;
    scelCenter:
    begin
      L := GetLineHeight;

      Result.Top := Result.Top + ((Result.Bottom - Result.Top) - L) div 2;
      Result.Bottom := Result.Top + L;
    end;
  end;

  if (FLayout = scelTop) and HandleAllocated then
  begin
    H := GetCharHeight('0') - 1;
    if H < 0 then H := 0;

    if Result.Bottom - Result.Top < H then
      Dec(Result.Top);
  end;

  if Result.Top < R.Top then
    Result.Top := R.Top;

  if Result.Top > R.Bottom then
    Result.Top := R.Bottom;

  if Result.Bottom < R.Top then
    Result.Bottom := R.Top;

  if Result.Bottom > R.Bottom then
    Result.Bottom := R.Bottom;
end;

function TSCCustomEdit.GetLineHeight: Integer;
begin
  Result := 0;
  if HandleAllocated then
    Result := ((GetCharHeight('R') + GetCharHeight('q')) div 2) + 1;
end;

function TSCCustomEdit.GetLineWidth(L: Integer): Integer;
var
  Ln, I: Integer;
begin
  Result := 0;

  Ln := Length(FText);

  if IsPassword then
  begin
    Inc(Result, GetCharWidth(FPasswordChar)*Ln);
    Exit;
  end;

  for I := 1 to Ln do
    Inc(Result, GetCharWidth(FText[I]));
end;

function TSCCustomEdit.GetCharAtPoint(P: TPoint): TPoint;
var
  R: TRect;
  HasPasswd: Boolean;
  W, Cw, Ln, I: Integer;
begin
  R := GetEditRect;
  if R.Bottom <= R.Top then
    R.Bottom := R.Top + 2;

  Dec(R.Left, FHorzScrollPosition);

  if FAlignment <> taLeftJustify then
    OffsetRect(R, GetLineLeft(0), 0);

  Result := Point(0, 0);
  if P.x < R.Left then
    Exit;

  if P.y < R.Top then
    P.y := R.Top;

  if P.y > R.Bottom - 1 then
    P.y := R.Bottom - 1;

  R.Right := R.Left;

  Ln := Length(FText);
  if Ln = 0 then Exit;

  Cw := 0;

  HasPasswd := IsPassword;
  if HasPasswd then
    Cw := GetCharWidth(FPasswordChar);

  W := R.Left;
  for I := 1 to Ln do
  begin
    R.Left  := R.Right;

    if not HasPasswd then
      Cw := GetCharWidth(FText[I]);

    Inc(W, Cw);
    Inc(R.Right, Cw);

    if PtInRect(R, P) then
    begin
      Result.X := I-1;

      Inc(R.Left, Cw div 2);
      if PtInRect(R, P) then
        Result.X := I;

      Exit;
    end;
  end;

  if P.x >= W then
    Result.X := Ln;
end;

function TSCCustomEdit.GetSelLength: Integer;
var
  X1, X2, T: Integer;
begin
  Result := 0;
  if FCanSelect then
  begin
    X1 := FCaretPos.X;
    X2 := FSelStartPos.X;

    T := 0;
    EnsureCaretPos(X1, T);
    EnsureCaretPos(X2, T);

    Result := X1 - X2;
  end;  
end;

function TSCCustomEdit.GetSelText: String;
var
  Ch: Char;
  X1, X2, P: Integer;
begin
  Result := '';
  if HasSelection then
  begin
    X1 := FCaretPos.X;
    X2 := FSelStartPos.X;

    P := 0;
    EnsureCaretPos(X1, P);
    EnsureCaretPos(X2, P);

    if X1 <> X2 then
    begin
      P := X1 + 1;
      if X2 < X1 then
        P := X2 + 1;

      Result := Copy(FText, P, Abs(X1 - X2));

      if (Result <> '') and IsPassword then
      begin
        Ch := FPasswordChar;
        if Ch = #0 then Ch := '*';

        Result := StringOfChar(Ch, Length(Result));
      end;  
    end;  
  end;
end;

function TSCCustomEdit.GetText: TCaption;
begin
  Result := FText;
end;

function TSCCustomEdit.GetVisibleLineCount: Integer;
begin
  Result := 1;
end;

function TSCCustomEdit.HasSelection: Boolean;
begin
  Result := FCanSelect and not IsDesigning and
    (FSelStartPos.X <> FCaretPos.X) or (FSelStartPos.Y <> FCaretPos.Y);
end;

procedure TSCCustomEdit.HideCaret;
begin
  if HandleAllocated and not IsDesigning then
    Windows.HideCaret(Handle);
end;

procedure TSCCustomEdit.InitializeCaret;
var
  P: TPoint;
begin
  if not IsDesigning then
  begin
    HideCaret;
    DestroyCaret;

    FCaretPoint := GetCaretPoint(FCaretPos);
    if FUseCaret and not (FCanDragSelection and FDraggingSelection and
      AllowSelectionDrag) and HandleAllocated then
    begin
      P := GetCaretSize;
      if (P.x > 0) and (P.y > 0) then
        CreateCaret(Handle, 0, P.x, P.y);

      if not Self.Focused then
        HideCaret;
    end;
  end;  
end;

type
  TCharCanvas = class(TCanvas);

procedure TSCCustomEdit.InitiateCharList;
var
  S: TSize;
  P: PPoint;
  I: Integer;
begin
  RemoveCharList;
  if not HandleAllocated then
    Exit;

  if FCharList = nil then
    FCharList := TList.Create;

  Canvas.Font.Assign(Self.Font);
  
  for I := 0 to 255 do
  begin
    New(P);
    FCharList.Add(P);

    S := TCharCanvas(Canvas).TextExtent(Char(I));
    P^.x := S.cx;
    P^.y := S.cy;
  end;
end;

procedure TSCCustomEdit.InsertChar(Ch: Char);
var
  S: String;
  P, Ln: Integer;
begin
  if not ReadOnly and BeforeInsertChar(Ch) and
    IsValidKey(Ch) and CanInsertText(Ch) and (Ch <> #0) then
  begin
    S := UpdateCharCase(Ch);
    if Length(S) <> 1 then
      Exit;

    Ch := S[1];
    Ln := Length(FText);

    if (Ln > 0) and HasSelection then
    begin
      if FCaretPos.X < FSelStartPos.X then
        P := FCaretPos.X + 1
      else
        P := FSelStartPos.X + 1;

      if P > Ln then
        P := Ln;

      S := '';
      if FUndoLock = 0 then
        S := Copy(FText, P, Abs(FCaretPos.X - FSelStartPos.X));

      Delete(FText, P, Abs(FCaretPos.X - FSelStartPos.X));

      if Length(FText) <> Ln then
      begin
        Ln := Length(FText);
        
        FModified := True;
        if S <> '' then
          AddToUndo(sceaDelete, S, FCaretPos, FSelStartPos, True);

        if FCaretPos.X > FSelStartPos.X then
          FCaretPos := FSelStartPos;

        EnsureCaretPos(FCaretPos.X, FCaretPos.Y);
        InternalSetSelStart(FCaretPos);
      end;
    end;

    if (FMaxLength = 0) or (Ln < FMaxLength) then
    begin
      FModified := True;

      Insert(Ch, FText, FCaretPos.X + 1);
      if FUndoLock = 0 then
        AddToUndo(sceaInsert, S, FCaretPos, Point(FCaretPos.X + 1, FCaretPos.Y), S <> '');

      Inc(FCaretPos.X);

      {$IFDEF SC_DELPHI2009_EARLY}
      if FOEMConvert then
      begin
        S := OEMConvertText(FText);

        if FText <> S then
        begin
          FText := S;
          EnsureCaretPos(FCaretPos.X, FCaretPos.Y);
        end;
      end;
      {$ENDIF}
    end;

    InternalSetSelStart(FCaretPos);

    if FAutoComplete then
      DoAutoComplete(False);
      
    Invalidate;

    UpdateCaret;
    CheckCaretVisible;

    CaretMoved;
    TriggerChange;
  end;
end;

procedure TSCCustomEdit.OverwriteChar(Ch: Char);
var
  S: String;
  P, Ln: Integer;
  Cp, Sp: TPoint;
  HasSel: Boolean;
begin
  if not ReadOnly and BeforeInsertChar(Ch) and
    IsValidKey(Ch) and CanInsertText(Ch) and (Ch <> #0) then
  begin
    S := UpdateCharCase(Ch);
    if Length(S) <> 1 then
      Exit;

    Ch := S[1];
    Ln := Length(FText);

    Cp := FCaretPos;
    Sp := FSelStartPos;

    HasSel := HasSelection;
    if (Ln > 0) and (HasSel or (Cp.X < Ln)) then
    begin
      P := Cp.X + 1;
      if not HasSel then
      begin
        Sp := Cp;
        Inc(Sp.X);
      end else
      if Cp.X > Sp.X then
        P := Sp.X + 1;

      if P > Ln then
        P := Ln;

      S := '';
      if FUndoLock = 0 then
        S := Copy(FText, P, Abs(Cp.X - Sp.X));

      Delete(FText, P, Abs(Cp.X - Sp.X));

      if Length(FText) <> Ln then
      begin
        FModified := True;
        if S <> '' then
          AddToUndo(sceaDelete, S, Cp, Sp, True);

        if FCaretPos.X > FSelStartPos.X then
          FCaretPos := FSelStartPos;

        EnsureCaretPos(FCaretPos.X, FCaretPos.Y);
        InternalSetSelStart(FCaretPos);
      end;
    end;

    if (FMaxLength = 0) or (Length(FText) < FMaxLength) then
    begin
      FModified := True;
      
      Insert(Ch, FText, FCaretPos.X + 1);
      if FUndoLock = 0 then
        AddToUndo(sceaInsert, S, FCaretPos, Point(FCaretPos.X + 1, FCaretPos.Y), S <> '');

      Inc(FCaretPos.X);

      {$IFDEF SC_DELPHI2009_EARLY}
      if FOEMConvert then
      begin
        S := OEMConvertText(FText);

        if FText <> S then
          EnsureCaretPos(FCaretPos.X, FCaretPos.Y);
      end;
      {$ENDIF}
    end;

    InternalSetSelStart(FCaretPos);

    if FAutoComplete then
      DoAutoComplete(False);
      
    Invalidate;

    UpdateCaret;
    CheckCaretVisible;

    CaretMoved;
    TriggerChange;
  end;
end;

procedure TSCCustomEdit.InsertText(AText: String);
var
  S: String;
  Ch: Char;
  I, P, Ln: Integer;
begin
  if ReadOnly then Exit;

  AText := UpdateCharCase(ArrangeText(AText));

  if not BeforeInsertText(AText) then
    Exit;

  Ln := Length(AText);

  for I := 0 to Ln-1 do
  begin
    Ch := AText[I + 1];

    if (Ch = #0) or not IsValidKey(Ch) then
    begin
      AText := Copy(AText, 1, I);
      Break;
    end;
  end;

  if (Length(AText) > 0) and CanInsertText(AText) then
  begin
    Ln := Length(FText);

    if (Ln > 0) and HasSelection then
    begin
      if FCaretPos.X < FSelStartPos.X then
        P := FCaretPos.X + 1
      else
        P := FSelStartPos.X + 1;

      if P > Ln then
        P := Ln;

      S := '';
      if FUndoLock = 0 then
        S := Copy(FText, P, Abs(FCaretPos.X - FSelStartPos.X));

      Delete(FText, P, Abs(FCaretPos.X - FSelStartPos.X));

      if Length(FText) <> Ln then
      begin
        FModified := True;
        if S <> '' then
          AddToUndo(sceaDelete, S, FCaretPos, FSelStartPos, True);

        if FCaretPos.X > FSelStartPos.X then
          FCaretPos := FSelStartPos;

        EnsureCaretPos(FCaretPos.X, FCaretPos.Y);
        InternalSetSelStart(FCaretPos);
      end;
    end;

    if FMaxLength > 0 then
    begin
      Ln := FMaxLength - Length(FText);
      AText := Copy(AText, 1, Ln);
    end;

    Ln := Length(AText);
    if AText <> '' then
    begin
      FModified := True;
      
      Insert(AText, FText, FCaretPos.X + 1);
      if FUndoLock = 0 then
        AddToUndo(sceaInsert, S, FCaretPos, Point(FCaretPos.X + Ln, FCaretPos.Y), S <> '');

      Inc(FCaretPos.X, Ln);

      {$IFDEF SC_DELPHI2009_EARLY}
      if FOEMConvert then
      begin
        S := OEMConvertText(FText);

        if FText <> S then
          EnsureCaretPos(FCaretPos.X, FCaretPos.Y);
      end;
      {$ENDIF}
    end;

    InternalSetSelStart(FCaretPos);

    if FAutoComplete then
      DoAutoComplete(False);
    Invalidate;

    UpdateCaret;
    CheckCaretVisible;

    CaretMoved;
    TriggerChange;
  end;
end;

function TSCCustomEdit.IsValidKey(Key: Char): Boolean;
begin
  Result := (Ord(Key) >= 32) or (Key = ^H);
end;

procedure TSCCustomEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  Sl: Integer;
  Cp, P, CrPos: TPoint;
  CrMoved: Boolean;
  KeyAct: TSCEditKeyAction;
begin
  if (FIsMouseDown or MouseIsDown) then
    Exit;

  Inc(FEditTextCount);
  try
    inherited KeyDown(Key, Shift);

    if (Key = 0) or not Focused then
      Exit;

    Cp := FCaretPos;
    P  := FSelStartPos;
    Sl := GetSelLength;

    CrPos := FCaretPos;
    CrMoved := False;

    case Key of
      VK_LEFT, VK_UP:
      begin
        if ssCtrl in Shift then
          CrPos := GetPrevWordPos(CrPos, True, True, False)
        else
          Dec(CrPos.x);

        CrMoved := True;
      end;
      VK_RIGHT, VK_DOWN:
      begin
        if ssCtrl in Shift then
          CrPos := GetNextWordPos(CrPos, True, True)
        else
          Inc(CrPos.x);

        CrMoved := True;
      end;
      VK_HOME:
      begin
        CrPos.x := 0;
        CrMoved := True;
      end;
      VK_END:
      begin
        CrPos.x := Length(Text);
        CrMoved := True;
      end;
      VK_DELETE, VK_BACK:
        if FCanEdit and not ReadOnly and EditCanModify then
        begin
          if Shift = [ssCtrl] then
          begin
            if not Self.HasSelection then
              DeleteText(Key = VK_BACK);
          end else
            DeleteChar(Key = VK_BACK);
        end;
      VK_INSERT:
      begin
        if FCanEdit then
        begin
          if Shift = [ssCtrl] then
            CopyToClipboard
          else
          if (Shift = [ssShift]) then
          begin
            if EditCanModify then
              PasteFromClipboard;
          end else
          if (Shift = []) and FInsertChangesEditMode then
          begin
            if FEditMode = scemInsert then
              FEditMode := scemOverwrite
            else
              FEditMode := scemInsert;
          end;
        end;
      end;
      else begin
        KeyAct := GetKeyAction(Key, Shift);
        if (KeyAct <> sceaNone) and not (FCanEdit and EditCanModify) then
          Exit;

        case KeyAct of
          sceaCut:
            CutToClipboard;
          sceaCopy:
            CopyToClipboard;
          sceaPaste:
            PasteFromClipboard;
          sceaUndo:
            Undo;
          sceaRedo:
            Redo;
        end;
      end;
    end;

    if CrMoved then
      UpdateCaretPos(CrPos.x, CrPos.y);

    EnsureCaretPos(FCaretPos.x, FCaretPos.y);
    CheckCaretVisible;

    if Key in [VK_END, VK_HOME, VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN] then
    begin
      if not (ssShift in Shift) then
        InternalSetSelStart(FCaretPos);

      InternalSetSelStart(FSelStartPos);

      if Sl <> GetSelLength then
        Invalidate;
    end;

    UpdateCaret;

    if ((Cp.X <> FCaretPos.X) or (Cp.Y <> FCaretPos.Y) or
      (P.X <> FSelStartPos.X) or (P.Y <> FSelStartPos.Y)) then
      CaretMoved;
  finally
    Dec(FEditTextCount);
  end;
end;

procedure TSCCustomEdit.KeyPress(var Key: Char);
begin
  if (FIsMouseDown or MouseIsDown) then
    Exit;

  Inc(FEditTextCount);
  try
    inherited KeyPress(Key);

    if not (Key in [^H, #127]) and FCanEdit and
      not ReadOnly and Focused and EditCanModify then
    begin
      if FEditMode = scemOverwrite then
        OverwriteChar(Key)
      else if (FMaxLength = 0) or (Length(FText) < FMaxLength) or
        HasSelection then
        InsertChar(Key);
    end;
  finally
    Dec(FEditTextCount);
  end;
end;

procedure TSCCustomEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if not (FIsMouseDown or MouseIsDown) then
    inherited KeyUp(Key, Shift);
end;

procedure TSCCustomEdit.Loaded;
begin
  inherited Loaded;

  FModified := False;
  ClearUndo;
  ClearRedo;

  UpdateEditArea;
  if not Focused then
    HideCaret;
end;

procedure TSCCustomEdit.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  P: TPoint;
  Ch: TPoint;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if CanFocus and not Focused and not ClickFocus then
    SetFocus;

  if Focused then
  begin
    FIsMouseDown := Button = mbLeft;

    SetCapture(Handle);
    UpdateCursor(X, Y, True);

    FImageDown    := False;
    FCheckboxDown := False;
    FCheckboxHot  := False;

    if FIsMouseDown then
    begin
      P := Point(X, Y);

      R := GetEditRect;
      if (Border <> sccbNone) or (BorderInner <> sccbNone) then
        InflateRect(R, 1, 1);

      if IsRectEmpty(R) or not PtInRect(R, P) then
      begin
        FIsMouseDown := False;

        R := GetImageRect;
        FImageDown := not IsRectEmpty(R) and PtInRect(R, Point(X, Y));

        if not FImageDown and CheckboxEnabled and CheckboxVisible then
        begin
          R := GetCheckboxRect;

          FCheckboxDown := not IsRectEmpty(R) and PtInRect(R, Point(X, Y));
          FCheckboxHot  := FCheckboxDown;

          if FCheckboxDown then
            Invalidate;
        end;

        Exit;
      end;

      if FCanDragSelection and not (ssDouble in Shift) and
        FCanEdit and AllowSelectionDrag and HasSelection and
        not IsRectEmpty(FSelectionRect) and PtInRect(FSelectionRect, P) then
      begin
        StartSelectionDrag;
        Exit;
      end;

      Ch := GetCharAtPoint(P);
      EnsureCaretPos(Ch.X, Ch.Y);

      if ssShift in Shift then
        SetSelRect(Rect(FCaretPos.X, FCaretPos.Y, Ch.X, Ch.Y))
      else
        SetSelRect(Rect(Ch.X, Ch.Y, Ch.X, Ch.Y));

      if ssDouble in Shift then
      begin
        FIsMouseDown := False;
        SelectWord(True);
      end;
    end;
  end;  
end;

procedure TSCCustomEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  P, Ch: TPoint;
  OldCheckHot: Boolean;
begin
  UpdateCursor(X, Y, True);

  if FIsMouseDown then
  begin
    Ch := GetCharAtPoint(Point(X, Y));

    if FDraggingSelection and AllowSelectionDrag then
    begin
      UpdateSelectionDrag(Ch.X, Ch.Y);
      Exit;
    end;

    P := FCaretPos;
    UpdateCaretPos(Ch.X, Ch.Y);

    if (P.x <> FCaretPos.X) or (P.y <> FCaretPos.Y) then
    begin
      Invalidate;
      CaretMoved;
    end;
  end else
  if CheckboxEnabled and CheckboxVisible and
    (FCheckboxDown or (FCheckboxStyle = scecsOffice2k)) then
  begin
    P := Point(X, Y);

    R := GetCheckboxRect;

    OldCheckHot  := FCheckboxHot;
    FCheckboxHot := not IsRectEmpty(R) and PtInRect(R, Point(X, Y));

    if OldCheckHot <> FCheckboxHot then
      Invalidate;
  end;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomEdit.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  R: TRect;
  P, Ch, Dp: TPoint;
  OldCheckDown, OldCheckHot: Boolean;
begin
  UpdateCursor(X, Y, True);

  OldCheckDown := FCheckboxDown;
  OldCheckHot  := FCheckboxHot;

  if FImageDown then
  begin
    FImageDown := False;

    R := GetImageRect;
    if not IsRectEmpty(R) and PtInRect(R, Point(X, Y)) then
      SelectAll;
  end else
  if FCheckboxDown then
  begin
    FCheckboxDown := False;
    FCheckboxHot  := False;

    if CheckboxEnabled and CheckboxVisible then
    begin
      R := GetCheckboxRect;
      
      if not IsRectEmpty(R) and PtInRect(R, Point(X, Y)) then
      begin
        ToggleCheckbox;
        FCheckboxHot := True;
      end;
    end;
  end else
  if FIsMouseDown then
  begin
    FIsMouseDown := False;

    Ch := GetCharAtPoint(Point(X, Y));

    if FDraggingSelection then
    begin
      Dp := FDragClickPos;

      DragDropSelectedText;
      inherited MouseUp(Button, Shift, X, Y);
      
      Exit;
    end;

    P := FCaretPos;
    UpdateCaretPos(Ch.X, Ch.Y);

    if (P.x <> FCaretPos.X) or (P.y <> FCaretPos.Y) then
    begin
      Invalidate;
      CaretMoved;
    end;
  end;

  if not OldCheckDown then
  begin
    R := GetCheckboxRect;
    FCheckboxHot := not IsRectEmpty(R) and PtInRect(R, Point(X, Y));
  end;

  if (FCheckboxStyle = scecsOffice2k) and
    ((FCheckboxHot <> OldCheckHot) or (FCheckboxDown <> OldCheckDown)) then
    Invalidate;

  UpdateCursor(X, Y, True);
  inherited MouseUp(Button, Shift, X, Y);
end;

function TSCCustomEdit.GetNextWordPos(W: TPoint; CheckDelimeters: Boolean;
  JumpDelimeters: Boolean): TPoint;
var
  Delims: String;
  Ln, I, P: Integer;
  OnSpace, CheckNext, IsDelimeter: Boolean;
begin
  Result := W;
  EnsureCaretPos(Result.X, Result.Y);

  if IsPassword then
  begin
    Result.X := Length(FText);
    Exit;
  end;

  P := Result.X + 1;
  if P < 1 then P := 1;

  Ln := Length(FText);

  Result.X := Ln;
  if (Ln = 0) or (P > Ln) then
    Exit;

  Delims := GetDelimeters;

  CheckNext := False;
  OnSpace := Ord(FText[P]) <= 32;

  if OnSpace then
    for I := P-1 downto 1 do
      if (FText[I] in [#13, #10]) or
        (CheckDelimeters and (AnsiPos(FText[I], Delims) > 0)) then
      begin
        OnSpace := False;
        Break;
      end;

  if CheckDelimeters and (AnsiPos(FText[P], Delims) > 0) then
  begin
    Result.x := P - 1;
    if not JumpDelimeters then
      Exit;
  end;

  for I := P to Ln do
  begin
    IsDelimeter := CheckDelimeters and (AnsiPos(FText[I], Delims) > 0);

    if IsDelimeter or (FText[I] in [#13, #10]) then
    begin
      Result.x := I - 1;
      if IsDelimeter and JumpDelimeters then
      begin
        CheckNext := True;
        Continue;
      end;

      Exit;
    end;

    if Ord(FText[I]) <= 32 then
    begin
      CheckNext := True;
      Continue;
    end;

    if CheckNext then
    begin
      if not OnSpace then
      begin
        Result.x := I - 1;
        if Result.x < 0 then
          Result.x := 0;

        Exit;
      end;

      OnSpace := False;
      CheckNext := False;
    end;
  end;

  Result.x := Ln;
end;

procedure TSCCustomEdit.Paint;
var
  R: TRect;
  Tp: Integer;
begin
  if not HandleAllocated then
    Exit;

  R := GetClientRect;
  if IsRectEmpty(R) then
    Exit;

  DoDrawBack(Canvas);
  DrawPicture(Canvas);

  if FUseImage and (Images <> nil) and IsValidImage(ImageIndex) then
  begin
    Tp := AdjustImageTop(R.Top + ((R.Bottom - R.Top - Images.Height) div 2));
    Images.Draw(Canvas, FIndentLeft + 1, Tp, ImageIndex, Enabled);
  end;

  if CheckboxVisible then
  begin
    R := GetCheckboxRect;
    if not IsRectEmpty(R) then
      DoDrawCheckbox(Canvas, R, FCheckboxDown, FCheckboxHot);
  end;

  R := GetEditRect;
  if not IsRectEmpty(R) then
  begin
    DoDrawText(Canvas);
    
    if CanPaintDragArrow then
      PaintSelectionDrag(Canvas);
  end;
end;

procedure TSCCustomEdit.UpdateLineFont(F: TFont; Index: Integer);
begin
  //
end;

procedure TSCCustomEdit.PaintLine(C: TCanvas; Index, H, TxTop: Integer);
var
  PassCh: Char;
  S, LineStr: String;
  P1, P2: TPoint;
  CR, R1, R2, R3: TRect;
  IsDesc: Boolean;
  I, L, L1, L2, Ln, F, ImgW: Integer;
begin
  if (C = nil) or (H = 0) then
    Exit;

  IsDesc := IsDescription;

  LineStr := GetLineText(Index);

  Ln := Length(LineStr);
  if (Ln = 0) and not IsDesc then
    Exit;

  CR := GetClientRect;
  if not IsRectEmpty(CR) then
  begin
    R1 := GetEditRect;

    if not IsRectEmpty(R1) then
    begin
      if TxTop < 0 then
        TxTop := 0;

      OffsetRect(R1, 0, TxTop);

      IntersectRect(R1, R1, CR);
      if IsRectEmpty(R1) then Exit;

      R2 := R1;

      Dec(R1.Left, FHorzScrollPosition);

      if H < 0 then H := GetLineHeight;
      R1.Bottom := R1.Top + H;

      if IsRectEmpty(R1) then Exit;

      C.Font.Assign(Self.Font);
      C.Font.Color := GetForeColor;

      UpdateLineFont(C.Font, Index);

      C.Brush.Style := bsClear;

      if IsDesc then
      begin
        LineStr := GetDescriptionText;
        Ln  := Length(LineStr);
        C.Font.Color := GetDescriptionColor;
      end else
      if IsPassword then
      begin
        PassCh := FPasswordChar;
        if PassCh = #0 then PassCh := '*';

        LineStr := StringOfChar(PassCh, Ln);
      end;

      F := DT_EDITCONTROL or DT_SINGLELINE or DT_TOP or
        DT_LEFT or DT_NOPREFIX;

      if FAlignment <> taLeftJustify then
      begin
        if IsDesc then
        begin
          F := F and not DT_LEFT;
          if FAlignment = taRightJustify then
            F := F or DT_RIGHT
          else
            F := F or DT_CENTER;
        end else
        begin
          L := GetLineLeft(0);

          Inc(R1.Left, L);
          if FAlignment = taCenter then
            Dec(R1.Right, L);
        end;
      end;

      if not IsDesc and (FPasswordStyle = scpsImage) and (FPasswordImage > -1) then
      begin
        if IsValidImage(FPasswordImage) then
        begin
          ImgW := Images.Width;

          for I := 0 to Ln - 1 do
            Images.Draw(C, R1.Left + (I*ImgW), R1.Top, FPasswordImage, Self.Enabled);
        end;
      end else
        DrawText(C.Handle, PChar(LineStr), Ln, R1, F);

      // Draw selection
      if not IsDesc and (not FHideSelection or Focused) then
      begin
        P1 := FSelStartPos;
        EnsureCaretPos(P1.X, P1.Y);

        P2 := FCaretPos;
        EnsureCaretPos(P2.X, P2.Y);

        if P1.X <> P2.X then
        begin
          if P1.X > P2.X then
          begin
            P1.Y := P1.X;
            P1.X := P2.X;
            P2.X := P1.Y;
          end;

          S := Copy(LineStr, P1.X + 1, P2.X - P1.X);
          if S <> '' then
          begin
            L1 := 0;
            for I := 1 to P1.X do
              Inc(L1, GetCharWidth(LineStr[I]));

            L2 := 0;
            for I := P1.X + 1 to P2.X do
              Inc(L2, GetCharWidth(LineStr[I]));

            Inc(L1, R1.Left);
            Inc(L2, L1);

            R1.Left  := L1;
            R1.Right := L2;

            if not ((R1.Right <= R2.Left) or (R1.Left >= R2.Right) or IsRectEmpty(R1)) then
            begin
              C.Brush.Style := bsSolid;
              if Focused then
              begin
                C.Brush.Color := FHighlightColor;
                C.Font.Color  := FHighlightTextColor;
              end else
              begin
                C.Brush.Color := FHideSelectionColor;
                C.Font.Color  := FHideSelectionTextColor;
              end;

              IntersectRect(R3, R1, R2);
              if (C.Brush.Color <> clNone) and not IsRectEmpty(R3) then
                C.FillRect(R3);

              if (FPasswordStyle = scpsImage) and (FPasswordImage > -1) then
              begin
                if IsValidImage(FPasswordImage) then
                begin
                  ImgW := Images.Width;

                  Ln := Abs(GetSelLength);
                  for I := 0 to Ln - 1 do
                    Images.Draw(C, R1.Left + (I*ImgW), R1.Top, FPasswordImage, Self.Enabled);
                end;
              end else
              begin
                if C.Brush.Color = clNone then
                  C.Brush.Style := bsClear;

                DrawText(C.Handle, PChar(S), Length(S), R1, F);
                C.Brush.Style := bsSolid;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomEdit.PasteFromClipboard;
var
  S: String;
  Allow: Boolean;
begin
  if not ReadOnly then
  begin
    S := Clipboard.AsText;
    if S <> '' then
    begin
      Allow := True;
      DoPaste(S, Allow);

      if Allow and (S <> '') and CanPasteStr(S) then
        SetSelText(S);
    end;
  end;    
end;

function TSCCustomEdit.GetPrevWordPos(W: TPoint; CheckDelimeters,
  JumpDelimeters, CheckNextIsChar: Boolean): TPoint;
var
  Delims: String;
  OnSpace: Boolean;
  I, P, Ln, CharPos: Integer;
begin
  EnsureCaretPos(W.X, W.Y);
  Result := W;

  if IsPassword then
  begin
    Result.x := 0;
    Exit;
  end;

  P  := Result.x;
  Ln := Length(FText);

  Result.x := 0;
  if (Ln = 0) or (P < 1) then
    Exit;

  Delims  := GetDelimeters;
  OnSpace := Ord(FText[P]) <= 32;
  CharPos := -1;

  for I := P downto 1 do
  begin
    Result.x := I;

    if FText[I] in [#13, #10] then
      Exit;

    if CheckDelimeters and (AnsiPos(FText[I], Delims) > 0) then
    begin
      if not JumpDelimeters or (CharPos > -1) or
        (CheckNextIsChar and (I = P) and (P < Ln) and
        (Ord(FText[I + 1]) > 32) and (AnsiPos(FText[I], Delims) = 0)) then
        Exit;

      Continue;
    end;

    if Ord(FText[I]) <= 32 then
    begin
      if not OnSpace then
        Exit;

      Continue;
    end else
      OnSpace := False;

    CharPos := I;
  end;

  Result.x := 0;
end;

procedure TSCCustomEdit.SelectAll;
begin
  if FCanSelect then
    SetSelRect(Rect(0, 0, Length(FText), 0));
end;

function TSCCustomEdit.SelectionVisible: Boolean;
var
  CR, R: TRect;
  P1, P2: TPoint;
begin
  Result := True;
  if not HasSelection then
    Exit;

  Result := False;
  if not HandleAllocated then
    Exit;

  CR := GetClientRect;
  if not IsRectEmpty(CR) then
  begin
    R := GetEditRect;
    IntersectRect(R, R, CR);

    if not IsRectEmpty(CR) then
    begin
      P1 := GetCaretPoint(FSelStartPos);
      P2 := GetCaretPoint(FCaretPos);

      if ((P1.x < R.Left) and (P2.x < R.Left)) or
        ((P1.x > R.Right) and (P2.x > R.Right)) then
        Exit;

      Result := True;  
    end;
  end;
end;

procedure TSCCustomEdit.SelectWord(CheckDelimeters: Boolean);
var
  I, Ln: Integer;
  L, R: TPoint;
begin
  if not FCanSelect then
    Exit;

  Ln := Length(FText);
  if Ln > 0 then
  begin
    L := GetPrevWordPos(FCaretPos, CheckDelimeters, True, True);
    EnsureCaretPos(L.x, L.y);

    if (L.x = 0) and ((Ord(FText[1]) <= 32) or (AnsiPos(FText[1], FDelimeters) > 0)) then
    begin
      R := L;
      for I := 1 to Ln do
      begin
        if (Ord(FText[I]) > 32) or
          ((I > 1) and (AnsiPos(FText[I], FDelimeters) > 0)) then
        begin
          R.x := I-1;
          Break;
        end;

        R.x := I;
      end;
    end else
      R := GetNextWordPos(L, CheckDelimeters);

    EnsureCaretPos(R.x, R.y);
    SetSelRect(Rect(L.x, L.y, R.x, R.y));
  end;
end;

procedure TSCCustomEdit.SetCharCase(Value: TSCEditCharCase);
var
  S: String;
begin
  if FCharCase <> Value then
  begin
    FCharCase := Value;
    if (Length(FText) = 0) or (FCharCase = scecNormal) then
      Exit;

    S := UpdateCharCase(FText);
    if S <> FText then
    begin
      FText := Copy(S, 1, Length(S));
      Invalidate;
    end;
  end;
end;

procedure TSCCustomEdit.SetEditRect(R: TRect);
begin
  with R do
  begin
    if Left < 0   then Left   := 0;
    if Right < 0  then Right  := 0;
    if Top < 0    then Top    := 0;
    if Bottom < 0 then Bottom := 0;
  end;  

  if (FIndentLeft <> R.Left) or (FIndentRight <> R.Right) or
    (FIndentTop <> R.Top) or (FIndentBottom <> R.Bottom) then
  begin
    FIndentLeft   := R.Left;
    FIndentRight  := R.Right;
    FIndentTop    := R.Top;
    FIndentBottom := R.Bottom;

    if AutoSize then
      AdjustBounds;

    UpdateEditArea;
  end;
end;

procedure TSCCustomEdit.SetEditCursor(Value: TCursor);
begin
  if FEditCursor <> Value then
  begin
    FEditCursor := Value;
    if not (IsDesigning or IsLoading) then
      UpdateCursor(0, 0, False);
  end;
end;

procedure TSCCustomEdit.SetFocusColor(Value: TColor);
begin
  if FFocusColor <> Value then
  begin
    FFocusColor := Value;
    if Enabled and not IsDesigning and Focused then
      Invalidate;

    DoColorsChanged;
  end;
end;

procedure TSCCustomEdit.SetFocusTextColor(Value: TColor);
begin
  if FFocusTextColor <> Value then
  begin
    FFocusTextColor := Value;
    if Enabled and not IsDesigning and Focused then
      Invalidate;

    DoColorsChanged;
  end;
end;

procedure TSCCustomEdit.SetHideSelection(Value: Boolean);
begin
  if FHideSelection <> Value then
  begin
    FHideSelection := Value;
    if HasSelection and not Focused then
      UpdateSelection;
  end;
end;

procedure TSCCustomEdit.SetHideSelectionColor(Value: TColor);
begin
  if FHideSelectionColor <> Value then
  begin
    FHideSelectionColor := Value;
    if not FHideSelection and HasSelection and not Focused then
      UpdateSelection;

    DoColorsChanged;
  end;
end;

procedure TSCCustomEdit.SetHideSelectionTextColor(Value: TColor);
begin
  if FHideSelectionTextColor <> Value then
  begin
    FHideSelectionTextColor := Value;
    if not FHideSelection and HasSelection and not Focused then
      UpdateSelection;

    DoColorsChanged;
  end;
end;

procedure TSCCustomEdit.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    if not FHideSelection and HasSelection and Focused then
      UpdateSelection;

    DoColorsChanged;
  end;
end;

procedure TSCCustomEdit.SetHighlightTextColor(Value: TColor);
begin
  if FHighlightTextColor <> Value then
  begin
    FHighlightTextColor := Value;
    if not FHideSelection and HasSelection and Focused then
      UpdateSelection;

    DoColorsChanged;
  end;
end;

procedure TSCCustomEdit.SetIndentBottom(Value: Integer);
begin
  SetEditRect(Rect(FIndentLeft, FIndentTop, FIndentRight, Value));
end;

procedure TSCCustomEdit.SetIndentLeft(Value: Integer);
begin
  SetEditRect(Rect(Value, FIndentTop, FIndentRight, FIndentBottom));
end;

procedure TSCCustomEdit.SetIndentRight(Value: Integer);
begin
  SetEditRect(Rect(FIndentLeft, FIndentTop, Value, FIndentBottom));
end;

procedure TSCCustomEdit.SetIndentTop(Value: Integer);
begin
  SetEditRect(Rect(FIndentLeft, Value, FIndentRight, FIndentBottom));
end;

procedure TSCCustomEdit.SetLineSpace(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FLineSpace <> Value then
  begin
    FLineSpace := Value;
    Invalidate;
  end;
end;

procedure TSCCustomEdit.SetMaxLength(Value: Integer);
var
  S: String;
  DoTrim: Boolean;
begin
  if Value < 0 then Value := 0;

  if FMaxLength <> Value then
  begin
    DoTrim := (Value > 0) and (Value < FMaxLength);

    FMaxLength := Value;

    if DoTrim then
    begin
      S := GetText;
      S := Copy(S, 1, Value);

      SetText(S);
    end;
  end;
end;

procedure TSCCustomEdit.SetPasswordChar(const Value: Char);
begin
  if FPasswordChar <> Value then
  begin
    FPasswordChar := Value;

    if not (IsLoading or IsReading) and
      (FPasswordChar <> #0) and (FPasswordStyle = scpsNone) then
    begin
      FPasswordStyle := scpsChar;
      AdjustSize;
    end;

    if (Length(FText) > 0) and (FPasswordStyle = scpsChar) then
    begin
      Invalidate;
      UpdateCaret;
    end;
  end;
end;

procedure TSCCustomEdit.SetPasswordImage(Value: TImageIndex);
begin
  if FPasswordImage <> Value then
  begin
    FPasswordImage := Value;

    if not (IsLoading or IsReading) and
      (FPasswordImage > -1) and (FPasswordStyle = scpsNone) then
    begin
      FPasswordStyle := scpsImage;
      AdjustSize;
    end;

    if (Length(FText) > 0) and (FPasswordStyle = scpsImage) then
    begin
      Invalidate;
      UpdateCaret;
    end;
  end;
end;

procedure TSCCustomEdit.SetPasswordStyle(Value: TSCEditPasswordStyle);
begin
  if FPasswordStyle <> Value then
  begin
    FPasswordStyle := Value;

    if (Length(FText) > 0) and
      ((FPasswordChar <> #0) or (FPasswordImage > -1)) then
    begin
      AdjustSize;

      Invalidate;
      UpdateCaret;
    end;
  end;
end;

procedure TSCCustomEdit.SetReadOnly(Value: Boolean);
begin
  FReadOnly := Value;
end;

procedure TSCCustomEdit.SetSelRect(R: TRect);
begin
  EnsureCaretPos(R.Left, R.Top);
  EnsureCaretPos(R.Right, R.Bottom);

  if not FCanSelect then
    R.TopLeft := R.BottomRight;

  if (FSelStartPos.X <> R.Left) or (FSelStartPos.Y <> R.Top) or
    (FCaretPos.X <> R.Right) or (FCaretPos.Y <> R.Bottom) then
  begin
    InternalSetSelStart(R.TopLeft);
    UpdateCaretPos(R.Right, R.Bottom);

    Invalidate;

    FSelectionRect := GetSelectionRect;
    if FCanDragSelection and FCanEdit and AllowSelectionDrag and not IsDescription then
      UpdateCursor(0, 0, False);

    CaretMoved;
  end;
end;

procedure TSCCustomEdit.SetSelText(const Value: String);
begin
  if not ReadOnly then
    InsertText(ArrangeText(Value));
end;

procedure TSCCustomEdit.SetText(Value: TCaption);
var
  Ln1, Ln2: Integer;
begin
  Value := ArrangeText(Value);
  if FMaxLength > 0 then
    Value := Copy(Value, 1, FMaxLength);

  {$IFDEF SC_DELPHI2009_EARLY}
  if FOEMConvert then
    Value := OEMConvertText(Value);
  {$ENDIF}

  if FText <> Value then
  begin
    FModified := True;

    FInternalChange := True;
    CatchUndo;

    try
      Ln1 := Length(FText);
      if (FUndoLock = 0) and (Ln1 > 0) then
        AddToUndo(sceaDelete, FText, Point(0, 0), Point(Ln1, 0), False);

      FText := Value;

      Ln2 := Length(FText);
      if (FUndoLock = 0) and (Ln2 > 0) then
        AddToUndo(sceaInsert, FText, Point(0, 0), Point(Ln2, 0), False);

      InternalSetSelStart(Point(0, 0));
      UpdateCaretPos(0, 0);

      FCaretPoint := GetCaretPoint(FCaretPos);
      UpdateCaret;

      Invalidate;
      CheckCaretVisible;
    finally
      FInternalChange := False;
      ReleaseUndoCatch;
    end;

    CaretMoved;
    TriggerChange;
  end;
end;

procedure TSCCustomEdit.SetTopLine(Value: Integer);
begin
  Value := CheckTopLine(Value);

  if FTopLine <> Value then
  begin
    FTopLine := Value;
    UpdateEditArea;
  end;
end;

procedure TSCCustomEdit.SetUseCaret(Value: Boolean);
begin
  if FUseCaret <> Value then
  begin
    HideCaret;
    DestroyCaret;
    FUseCaret := Value;

    InitializeCaret;
  end;
end;

procedure TSCCustomEdit.SetUseImage(Value: Boolean);
begin
  if FUseImage <> Value then
  begin
    FUseImage := Value;

    FImageDown := False;
    if Images <> nil then
      UpdateEditArea;
  end;
end;

procedure TSCCustomEdit.SetUseUndo(Value: Boolean);
begin
  if FUseUndo <> Value then
  begin
    FUseUndo := Value;
    CheckUndoLimitBounds;
  end;
end;

procedure TSCCustomEdit.ShowCaret;
begin
  if FUseCaret and HandleAllocated and Focused and
    not ((FCanDragSelection and FDraggingSelection and
    AllowSelectionDrag and not IsDescription) or IsDesigning) then
  begin
    SetCaretPos(FCaretPoint.X, FCaretPoint.Y);
    Windows.ShowCaret(Self.Handle);
  end;
end;

procedure TSCCustomEdit.Undo;
var
  P: PSCEditUndoRec;
  ID, Cnt: Integer;
begin
  if FUndoLock > 0 then
    Exit;

  BeginUndo;
  try
    if (FUndoList <> nil) and (FUndoList.Count > 0) then
    begin
      Cnt := 0;
      ID  := -1;

      while True and (FUndoList.Count > 0) do
      begin
        P := FUndoList.Items[FUndoList.Count-1];
        if ID = -1 then
        begin
          ID := P^.GroupID;
          if Cnt > 0 then
            Break;
        end else
        if (P^.GroupID <> ID) and (Cnt > 0) then
          Break;

        Inc(Cnt);
        MoveToRedo(1);

        if P^.Action = sceaDelete then
        begin
          InternalSetSelStart(P^.StartPos);

          FCaretPos := FSelStartPos;

          InsertText(P^.DeletedText);
          P^.DeletedText := '';

          FCaretPos    := P^.CaretPos;
          EnsureCaretPos(FCaretPos.X, FCaretPos.Y);

          InternalSetSelStart(P^.StartPos);
        end else
        if P^.Action = sceaInsert then
        begin
          FCaretPos    := P^.CaretPos;
          EnsureCaretPos(FCaretPos.X, FCaretPos.Y);

          InternalSetSelStart(P^.StartPos);

          P^.DeletedText := GetSelText;

          ClearSelection;
        end;

        if ID = -1 then
          Break;
      end;

      if not FCanSelect then
        InternalSetSelStart(FCaretPos);

      EnsureCaretPos(FCaretPos.X, FCaretPos.Y);
      InternalSetSelStart(FSelStartPos);

      Invalidate;
      UpdateCaret;

      CaretMoved;
    end;
  finally
    EndUndo;
  end;
end;

procedure TSCCustomEdit.UpdateCaret;
begin
  if not IsDesigning then
  begin
    HideCaret;
    FCaretPoint := GetCaretPoint(FCaretPos);
    InitializeCaret;
    ShowCaret;
  end;
end;

procedure TSCCustomEdit.UpdateCaretPos(X, Y: Integer);
var
  P: TPoint;
begin
  EnsureCaretPos(X, Y);

  if (FCaretPos.X <> X) or (FCaretPos.Y <> Y) then
  begin
    CheckCaretPos(X, Y);
    EnsureCaretPos(X, Y);
  end;

  if (FCaretPos.X <> X) or (FCaretPos.Y <> Y) then
  begin
    FCaretPos.X := X;
    FCaretPos.Y := Y;

    P := FSelStartPos;
    if not FCanSelect then
      InternalSetSelStart(FCaretPos);

    if (P.X <> FSelStartPos.X) and (P.Y <> FSelStartPos.Y) then
      Invalidate;

    CheckCaretVisible;
    UpdateCaret;

    FSelectionRect := GetSelectionRect;
    if FCanEdit and FCanDragSelection and AllowSelectionDrag and not IsDescription then
      UpdateCursor(0, 0, False);

    CaretMoved;
  end;
end;

procedure TSCCustomEdit.UpdateEditArea;
begin
  UpdateCursor(-1, -1);
  Invalidate;
  UpdateCaret;

  FSelectionRect := GetSelectionRect;
  if FCanDragSelection and FCanEdit and AllowSelectionDrag and not IsDescription then
    UpdateCursor(0, 0, False);
end;

procedure TSCCustomEdit.UpdateSelection;
begin
  if SelectionVisible then
    Invalidate;
end;

procedure TSCCustomEdit.WMCopy(var Message: TMessage);
begin
  CopyToClipboard;
end;

procedure TSCCustomEdit.WMCut(var Message: TMessage);
begin
  CutToClipboard;
end;

procedure TSCCustomEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTCHARS or DLGC_WANTARROWS;
end;

procedure TSCCustomEdit.WMKillFocus(var Message: TWMSetFocus);
begin
  if IsDestroying then
    inherited
  else begin
    HideCaret;
    DestroyCaret;

    if FFocusExpandSize > 0 then
      SetBounds(Left, Top, Width - FFocusExpandSize, Height);

    inherited;

    if FHideSelection and HasSelection then
      UpdateSelection;
  end;    
end;

procedure TSCCustomEdit.WMPaste(var Message: TMessage);
begin
  PasteFromClipboard;
end;

procedure TSCCustomEdit.WMSetFocus(var Message: TWMSetFocus);
begin
  InitializeCaret;
  if FFocusExpandSize > 0 then
    SetBounds(Left, Top, Width + FFocusExpandSize, Height);

  inherited;

  ShowCaret;
  if not FHideSelection and HasSelection then
    UpdateSelection;
end;

procedure TSCCustomEdit.WMUndo(var Message: TMessage);
begin
  Undo;
end;

procedure TSCCustomEdit.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if FAutoSelect and not FIsMouseDown then
    SelectAll;
  UpdateCursor(-1, -1);
end;

procedure TSCCustomEdit.CheckCaretVisible;
begin
  MakeCharVisible(FCaretPos, True);
end;

function TSCCustomEdit.GetTextWidth(S: String): Integer;
var
  I: Integer;
begin
  Result := 0;
  if (FPasswordStyle = scpsImage) and (FPasswordImage > -1) then
  begin
    I := 16;
    if Images <> nil then
      I := Images.Width;

    Result := I*Length(S);  
  end else
    for I := 1 to Length(S) do
      Inc(Result, GetCharWidth(S[I]));
end;

procedure TSCCustomEdit.SetAlignment(Value: TAlignment);
begin
  if CanAlignText(Value) and (FAlignment <> Value) then
  begin
    FAlignment := Value;
    if (Length(FText) > 0) or IsDescription then
    begin
      Invalidate;

      if not IsDesigning then
      begin
        UpdateEditArea;
        UpdateCaret;
      end;
    end;
  end;
end;

procedure TSCCustomEdit.WMSize(var Message: TWMSize);
begin
  inherited;
  if HandleAllocated then
  begin
    UpdateEditArea;
    UpdateCaret;
    CheckCaretVisible;
  end;
end;

function TSCCustomEdit.GetLineLeft(L: Integer): Integer;
var
  S: String;
  W: Integer;
  CR, R: TRect;
begin
  Result := 0;
  if HandleAllocated and (FAlignment <> taLeftJustify) then
  begin
    CR := GetClientRect;
    R  := GetEditRect;

    IntersectRect(R, R, CR);
    if not IsRectEmpty(R) then
    begin
      S := GetLineText(L);

      if (FPasswordStyle = scpsChar) and (FPasswordChar <> #0) then
        S := StringOfChar(FPasswordChar, Length(S));

      W := GetTextWidth(S) + 1;

      if W < R.Right - R.Left then
      begin
        Result := R.Right - R.Left - W;
        if FAlignment = taCenter then
          Result := Result div 2;
      end;
    end;  
  end;
end;

procedure TSCCustomEdit.CMCursorChanged(var Message: TMessage);
var
  P: TPoint;
begin
  if FCanDragSelection and FDraggingSelection and
    HandleAllocated and (GetCapture = Self.Handle) then
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

procedure TSCCustomEdit.UpdateCursor(X, Y: Integer; UseXY: Boolean);
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

    R := GetEditRect;

    if (Border <> sccbNone) or (BorderInner <> sccbNone) then
      InflateRect(R, 1, 1);

    FUpdatingCursor := True;
    try
      Cr := FDefaultCursor;
      
      if not IsRectEmpty(R) and (FIsMouseDown or PtInRect(R, P)) then
      begin
        if FCanDragSelection and FCanEdit and AllowSelectionDrag and not IsDescription and
          (FDraggingSelection or PtInRect(FSelectionRect, P)) then
          Cr := GetDragCursor
        else
        if FDefaultCursor = crDefault then
          Cr := GetEditCursor;
      end;

      Cursor := Cr;
    finally
      FUpdatingCursor := True;
    end;
  end;  
end;

function TSCCustomEdit.CanGetFocus: Boolean;
begin
  Result := False;
end;

procedure TSCCustomEdit.DoMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
begin
  FIsMouseDown := Button = mbLeft;

  if FIsMouseDown then
  begin
    R := GetEditRect;
    if (Border <> sccbNone) or (BorderInner <> sccbNone) then
      InflateRect(R, 1, 1);

    if IsRectEmpty(R) or not PtInRect(R, Point(X, Y)) then
      FIsMouseDown := False;
  end;

  inherited DoMouseDown(Button, Shift, X, Y);
end;

function TSCCustomEdit.CanCopy: Boolean;
begin
  Result := HasSelection and not IsPassword;
end;

function TSCCustomEdit.CanCut: Boolean;
begin
  Result := not ReadOnly and CanCopy;
end;

function TSCCustomEdit.CanPaste: Boolean;
begin
  Result := not ReadOnly and (Clipboard.AsText <> '');
end;

function TSCCustomEdit.CanPasteStr(var S: String): Boolean;
begin
  Result := not ReadOnly and (S <> '');
end;

function TSCCustomEdit.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := True;
  if HandleAllocated then
    NewHeight := GetAutoHeight;
end;

procedure TSCCustomEdit.RemoveCharList;
var
  P: PPoint;
  I: Integer;
begin
  if FCharList <> nil then
  begin
    for I := 0 to (FCharList.Count - 1) do
    begin
      P := FCharList.Items[I];
      Dispose(P);
    end;

    FreeAndNil(FCharList);
  end;  
end;

procedure TSCCustomEdit.Redo;
var
  P: PSCEditUndoRec;
  ID, Cnt: Integer;
begin
  if FUndoLock > 0 then
    Exit;

  BeginUndo;
  try
    if (FRedoList <> nil) and (FRedoList.Count > 0) then
    begin
      ID  := -1;
      Cnt := 0;

      while True and (FRedoList.Count > 0) do
      begin
        FModified := True;

        P := FRedoList.Items[FRedoList.Count-1];
        if ID = -1 then
        begin
          ID := P^.GroupID;
          if Cnt > 0 then
            Break;
        end else
        if (P^.GroupID <> ID) and (Cnt > 0) then
          Break;

        Inc(Cnt);
        MoveToUndo(1);

        if P^.Action = sceaInsert then
        begin
          InternalSetSelStart(P^.StartPos);

          FCaretPos := FSelStartPos;

          InsertText(P^.DeletedText);
          P^.DeletedText := '';

          FCaretPos    := P^.CaretPos;
          EnsureCaretPos(FCaretPos.X, FCaretPos.Y);

          InternalSetSelStart(P^.StartPos);
        end else
        if P^.Action = sceaDelete then
        begin
          FCaretPos    := P^.CaretPos;
          EnsureCaretPos(FCaretPos.X, FCaretPos.Y);

          InternalSetSelStart(P^.StartPos);

          P^.DeletedText := GetSelText;
          ClearSelection;
        end;

        if ID = -1 then
          Break;
      end;

      EnsureCaretPos(FCaretPos.X, FCaretPos.Y);
      InternalSetSelStart(FSelStartPos);

      if not FCanSelect then
        InternalSetSelStart(FCaretPos);

      Invalidate;
      UpdateCaret;

      CaretMoved;
    end;
  finally
    EndUndo;
  end;
end;

function TSCCustomEdit.CanRedo: Boolean;
begin
  Result := (FRedoList <> nil) and (FRedoList.Count > 0);
end;

function TSCCustomEdit.CanUndo: Boolean;
begin
  Result := (FUndoList <> nil) and (FUndoList.Count > 0);
end;

procedure TSCCustomEdit.ClearUndo;
begin
  if FUndoList <> nil then
    FreeAndNil(FUndoList);
  if FRedoList <> nil then
    FreeAndNil(FRedoList);
end;

procedure TSCCustomEdit.AddToUndo(Action: TSCEditAction; const Txt: String;
  Caret, Start: TPoint; InGroup: Boolean);
var
  I, ID: Integer;
  P, P2: PSCEditUndoRec;
begin
  if not FUseUndo or (IsLoading or IsReading or IsDesigning) or
    ((Action = sceaDelete) and (Txt = '')) or
    ((Start.X = Caret.X) and (Start.Y = Caret.Y)) then
    Exit;

  if FUseUndo and (FUndoLock = 0) and
    not (IsLoading or IsReading or IsDesigning) then
  begin
    ID := -1;

    InGroup := InGroup or (FUndoCatch > 0);
    ClearRedo;

    FModified := True;

    if FUndoList = nil then
      FUndoList := TSCEditUndoStack.Create;

    if FNeedUndoGroup then
    begin
      ID := FUndoList.NewGroupID;
      FNeedUndoGroup := False;
    end;

    if Caret.y = Start.y then
    begin
      if Caret.x < Start.x then
      begin
        I := Caret.x;
        Caret.x := Start.x;
        Start.x := I;
      end;
    end else
    if Caret.y < Start.y then
    begin
      I := Caret.y;
      Caret.x := Start.y;
      Start.y := I;

      I := Caret.x;
      Caret.x := Start.x;
      Start.x := I;
    end;

    if (FUndoList.Count > 0) and (Action in [sceaDelete, sceaInsert]) then
    begin
      P2 := FUndoList.Items[FUndoList.Count-1];

      if (P2^.Action = Action) and (P2^.CaretPos.Y = Caret.Y) then
      begin
        if P2^.StartPos.X = Caret.X then
        begin
          P2^.StartPos.X  := Start.X;
          P2^.DeletedText := Txt + P2^.DeletedText;

          Exit;
        end else
        if P2^.CaretPos.X = Start.X then
        begin
          P2^.CaretPos.X  := Caret.X;
          P2^.DeletedText := P2^.DeletedText + Txt;

          Exit;
        end else
        if P2^.StartPos.X = Start.X then
        begin
          P2^.CaretPos.X  := P2^.CaretPos.X  + (Caret.X - Start.X);
          P2^.DeletedText := P2^.DeletedText + Txt;

          Exit;
        end;

        InGroup := False;
      end;

      if InGroup then
      begin
        if P2^.GroupID = -1 then
          P2^.GroupID := FUndoList.NewGroupID;

        if ID = -1 then
          ID := P2^.GroupID;
      end;
    end;

    P := FUndoList.Add;

    P^.Action   := Action;
    P^.CaretPos := Caret;
    P^.StartPos := Start;
    P^.DeletedText := Txt;
    P^.GroupID  := ID;

    CheckUndoLimitBounds;
  end;
end;

procedure TSCCustomEdit.ClearRedo;
begin
  if FRedoList <> nil then
    FreeAndNil(FRedoList);
end;

procedure TSCCustomEdit.MoveToRedo(Cnt: Integer);
var
  P: PSCEditUndoRec;
begin
  if (Cnt > 0) and
    (FUndoList <> nil) and (FUndoList.Count > 0) then
  begin
    if FRedoList = nil then
      FRedoList := TSCEditUndoStack.Create;

    while (Cnt > 0) and (FUndoList.Count > 0) do
    begin
      P := FUndoList.Items[FUndoList.Count-1];
      Dec(Cnt);

      if P <> nil then
      begin
        P := FUndoList.Extract(P);
        FRedoList.Insert(FRedoList.Count, P);
      end;  
    end;
  end;
end;

procedure TSCCustomEdit.MoveToUndo(Cnt: Integer);
var
  P: PSCEditUndoRec;
begin
  if (Cnt > 0) and
    (FRedoList <> nil) and (FRedoList.Count > 0) then
  begin
    if FUndoList = nil then
      FUndoList := TSCEditUndoStack.Create;

    while (Cnt > 0) and (FRedoList.Count > 0) do
    begin
      P := FRedoList.Items[FRedoList.Count-1];
      Dec(Cnt);

      if P <> nil then
      begin
        P := FRedoList.Extract(P);
        FUndoList.Insert(FUndoList.Count, P);
      end;  
    end;
  end;
end;

procedure TSCCustomEdit.BeginUndo;
begin
  Inc(FUndoLock);
end;

procedure TSCCustomEdit.EndUndo;
begin
  if FUndoLock > 0 then
    Dec(FUndoLock);
end;

procedure TSCCustomEdit.CatchUndo;
begin
  FNeedUndoGroup := FUndoCatch = 0;
  Inc(FUndoCatch);
end;

procedure TSCCustomEdit.ReleaseUndoCatch;
begin
  if FUndoCatch > 0 then
    Dec(FUndoCatch);
end;

procedure TSCCustomEdit.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    if not Enabled then
      Invalidate;

    DoColorsChanged;
  end;
end;

procedure TSCCustomEdit.SetDisabledTextColor(Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    if not Enabled then
      Invalidate;

    DoColorsChanged;
  end;
end;

procedure TSCCustomEdit.SetEditMode(Value: TSCEditMode);
begin
  if FEditMode <> Value then
  begin
    FEditMode := Value;
    if Assigned(FOnEditModeChange) then
      FOnEditModeChange(Self);
  end;
end;

procedure TSCCustomEdit.DoDrawBack(C: TCanvas);
var
  CR: TRect;
begin
  if C = nil then Exit;

  CR := GetClientRect;
  if not IsRectEmpty(CR) then
    with C do
    begin
      Brush.Style := bsSolid;
      Brush.Color := GetBackColor;

      FillRect(CR);
    end;

  if Transparent then
    PaintParentOn(C);
end;

procedure TSCCustomEdit.DoCaretMove;
begin
end;

procedure TSCCustomEdit.StopTracking;
begin
  FImageDown    := False;
  FIsMouseDown  := False;
  FCheckboxDown := False;
  FCheckboxHot  := False;
  StopSelectionDrag;
  inherited StopTracking;
end;

procedure TSCCustomEdit.BorderChanged;
begin
  inherited BorderChanged;
  AdjustSize;
  UpdateCaret;
  CheckCaretVisible;
end;

function TSCCustomEdit.GetBlendValue: Word;
begin
  Result := 0;
end;

procedure TSCCustomEdit.CMExit(var Message: TCMExit);
begin
  HideCaret;
  // DestroyCaret;
  ValidateEdit;
  inherited;
end;

{$IFDEF SC_DELPHI2009_EARLY}
procedure TSCCustomEdit.SetOEMConvert(Value: Boolean);
begin
  if FOEMConvert <> Value then
  begin
    FOEMConvert := Value;
    if FOEMConvert then
    begin
      FText := OEMConvertText(FText);

      UpdateCaretPos(FCaretPos.X, FCaretPos.Y);
      InternalSetSelStart(FCaretPos);

      Invalidate;
      UpdateCaret;
    end;
  end;
end;
{$ENDIF}

function TSCCustomEdit.UpdateCharCase(S: String): String;
begin
  Result := S;
  if FCharCase = scecLowerCase then
    Result := AnsiLowerCase(Result)
  else
  if FCharCase = scecUpperCase then
    Result := AnsiUpperCase(Result);
end;

{$IFDEF SC_DELPHI2009_EARLY}
function TSCCustomEdit.OEMConvertText(S: String): String;
begin
  S := ArrangeText(S);
  Result := Copy(S, 1, Length(S));

  if Result <> '' then
  begin
    if not CharToOem(PChar(Result), PChar(Result)) then
    begin
      Result := Copy(S, 1, Length(S));
      Exit;
    end;

    if not OemToChar(PChar(Result), PChar(Result)) then
      Result := Copy(S, 1, Length(S));
  end;
end;
{$ENDIF}

function TSCCustomEdit.GetEditCursor: TCursor;
begin
  Result := FEditCursor;
  if not FCanSelect then
    Result := Self.Cursor;
end;

procedure TSCCustomEdit.SetCanDragSelection(Value: Boolean);
begin
  if FCanDragSelection <> Value then
  begin
    FCanDragSelection := Value;

    if not FCanDragSelection then
      StopSelectionDrag;

    if AllowSelectionDrag and
      not (IsDescription or IsDesigning) then
      UpdateCursor(0, 0, False);
  end;
end;

procedure TSCCustomEdit.SetCanEdit(Value: Boolean);
begin
  FCanEdit := Value;
end;

procedure TSCCustomEdit.SetCanSelect(Value: Boolean);
var
  NeedPaint: Boolean;
begin
  if FCanSelect <> Value then
  begin
    NeedPaint := HasSelection and SelectionVisible;

    FCanSelect := Value;
    if not FCanSelect then
    begin
      InternalSetSelStart(FCaretPos);
      if NeedPaint then
        Invalidate;
    end;
  end;
end;

procedure TSCCustomEdit.DoColorsChanged;
begin
  //
end;

procedure TSCCustomEdit.DoInternalChange;
begin
  //
end;

procedure TSCCustomEdit.TriggerChange;
begin
  if not IsDesigning then
  begin
    DoInternalChange;
    if Assigned(FOnInternalChange) then
      FOnInternalChange(Self);

    Change;

    UpdateCaret;
    Invalidate;
    CheckCaretVisible;
  end;
end;

procedure TSCCustomEdit.DoCopy(var ClipText: String; var Allow: Boolean);
begin
  if Assigned(FOnClipCopy) then
    FOnClipCopy(Self, ClipText, Allow);
end;

procedure TSCCustomEdit.DoCut(var ClipText: String; var Allow: Boolean);
begin
  if Assigned(FOnClipCut) then
    FOnClipCut(Self, ClipText, Allow);
end;

procedure TSCCustomEdit.DoPaste(var ClipText: String; var Allow: Boolean);
begin
  if Assigned(FOnClipPaste) then
    FOnClipPaste(Self, ClipText, Allow);
end;

procedure TSCCustomEdit.ImageListChange(Sender: TObject);
begin
  if (FPasswordStyle = scpsImage) and (FPasswordImage > -1) then
    AdjustSize;

  if FUseImage then
    UpdateEditArea;

  Invalidate;
  FImageDown := False;

  RefreshCheckboxHot;
end;

function TSCCustomEdit.GetAutoHeight: Integer;
var
  Eh, H: Integer;
begin
  Result := Height;
  if HandleAllocated then
  begin
    Result := GetLineHeight + FIndentTop + FIndentBottom + 3;

    H := CheckboxHeight;
    if H > Result then Result := H;

    Eh := GetExtraBorderSize;
    Inc(Result, 2*(GetBorderSize + BorderWidth + GetInnerBorderSize + Eh));
  end;
end;

function TSCCustomEdit.AdjustImageTop(ImgTop: Integer): Integer;
begin
  Result := ImgTop;
end;

procedure TSCCustomEdit.AdjustBounds;
begin
  AdjustSize;
end;

function TSCCustomEdit.GetDelimeters: String;
begin
  Result := '.,?!:;-()';
  if FUseDelimeters then
    Result := FDelimeters;
end;

function TSCCustomEdit.GetImageRect: TRect;
var
  Ew, Eh: Integer;
  CR: TRect;
begin
  CR := GetClientRect;

  Eh := GetExtraBorderSize;
  if Eh < 0 then Eh := 0;

  Ew := Eh;
  if Eh > 0 then Inc(Ew);

  InflateRect(CR, -Ew, -Eh);

  Inc(CR.Left,  FIndentLeft);
  Dec(CR.Right, FIndentRight);

  if CR.Left > CR.Right then
    CR.Right := CR.Left;

  Result := CR;
  if IsRectEmpty(CR) then
    Exit;

  Result.Right := Result.Left;
  if FUseImage and (Images <> nil) then
    Inc(Result.Right, Images.Width + 4);

  if Result.Right > CR.Right then
    Result.Right := CR.Right;
end;

procedure TSCCustomEdit.NeedUndoGroup;
begin
  FNeedUndoGroup := True;
end;

function TSCCustomEdit.IsPassword: Boolean;
begin
  Result := ((FPasswordStyle = scpsImage) and (FPasswordImage > -1)) or
    ((FPasswordStyle = scpsChar) and (FPasswordChar <> #0));
end;

procedure TSCCustomEdit.SetDescription(const Value: String);
begin
  if FDescription <> Value then
  begin
    FDescription := Value;
    if IsDescription then
      Invalidate;
  end;
end;

procedure TSCCustomEdit.SetDescriptionColor(Value: TColor);
begin
  if FDescriptionColor <> Value then
  begin
    FDescriptionColor := Value;
    if IsDescription then
      Invalidate;
  end;
end;

procedure TSCCustomEdit.SetDescriptionMode(Value: TSCDescriptionMode);
begin
  if FDescriptionMode <> Value then
  begin
    FDescriptionMode := Value;
    if not Focused and (Trim(GetDescriptionText) <> '') then
      Invalidate;
  end;
end;

function TSCCustomEdit.GetDescriptionText: String;
begin
  Result := FDescription;
  if Result = '' then
    Result := 'Type your text here';
end;

function TSCCustomEdit.IsDescription: Boolean;
begin
  Result := Enabled and (DescriptionMode <> scdmNever) and not Focused and
    ((DescriptionMode = scdmAlways) or ((Descriptionmode = scdmWhenEmpty) and (Text = ''))) and
    (GetDescriptionText <> '');
end;

function TSCCustomEdit.AutoCompleteText: String;
begin
  Result := '';
  if FAutoComplete and Assigned(FOnAutoComplete) then
    FOnAutoComplete(Self, Result);
end;

procedure TSCCustomEdit.DoAutoComplete(UpdatePaint: Boolean);
var
  Ln1, Ln2: Integer;
  CmpStr: String;
begin
  if FAutoComplete and (FText <> '') and (FCaretPos.x = Length(FText)) then
  begin
    CmpStr := UpdateCharCase(ArrangeText(AutoCompleteText));
    {$IFDEF SC_DELPHI2009_EARLY}
    if FOEMConvert then
      CmpStr := OEMConvertText(CmpStr);
    {$ENDIF}

    if (CmpStr <> '') and (CmpStr <> FText) then
    begin
      FModified := True;

      if FUndoLock = 0 then
      begin
        Ln1 := Length(FText);
        Ln2 := Length(CmpStr);

        if Ln1 <> Ln2 then
          AddToUndo(sceaInsert, Copy(CmpStr, Ln1 + 1, Ln2 - Ln1),
            FCaretPos, Point(Ln2, FCaretPos.y), True);
      end;

      FText := Copy(CmpStr, 1, Length(CmpStr));

      InternalSetSelStart(Point(Length(FText), 0));

      if UpdatePaint then
        Invalidate;

      // DoInternalChange;

      TriggerChange;
      DoAutoCompleted;
    end;
  end;
end;

procedure TSCCustomEdit.DoAutoCompleted;
begin
  //
end;

procedure TSCCustomEdit.CheckCaretPos(var X, Y: Integer);
begin
  //
end;

procedure TSCCustomEdit.CaretMoved;
begin
  StopSelectionDrag;
  DoCaretMove;

  if Assigned(FOnCaretMove) and not IsDesigning then
  begin
    FOnCaretMove(Self);

    UpdateCaret;
    Invalidate;
    CheckCaretVisible;
  end;
end;

function TSCCustomEdit.GetBackColor: TColor;
begin
  Result := Color;
  if not Enabled then
    Result := FDisabledColor
  else
  if not IsDesigning and Focused and (FFocusColor <> clNone) then
    Result := FFocusColor;
end;

function TSCCustomEdit.GetForeColor: TColor;
begin
  Result := Font.Color;
  if not Enabled then
    Result := FDisabledTextColor
  else
  if not IsDesigning and Focused and (FFocusTextColor <> clNone) then
    Result := FFocusTextColor;
end;

procedure TSCCustomEdit.SetUndoLimit(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FUndoLimit <> Value then
  begin
    FUndoLimit := Value;
    CheckUndoLimitBounds;
  end;
end;

procedure TSCCustomEdit.CheckUndoLimitBounds;
var
  UCnt, RCnt, I: Integer;
begin
  if not FUseUndo then
    ClearUndo
  else
  if FUndoLimit > 0 then
  begin
    UCnt := 0;
    if FUndoList <> nil then
      UCnt := FUndoList.Count;

    RCnt := 0;
    if FRedoList <> nil then
      RCnt := FRedoList.Count;

    if (UCnt + RCnt) > FUndoLimit then
    begin
      if FUndoList <> nil then
        for I := 0 to FUndoList.Count-1 do
        begin
          if RCnt + FUndoList.Count <= FUndoLimit then
            Exit;

          FUndoList.Delete(I);
        end;

      if FRedoList <> nil then
        for I := 0 to FRedoList.Count-1 do
        begin
          if FRedoList.Count <= FUndoLimit then
            Exit;

          FRedoList.Delete(I);
        end;
    end;
  end;
end;

procedure TSCCustomEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = FDefaultMenu) then
    FDefaultMenu := nil;
end;

procedure TSCCustomEdit.PopupMenuClicked(Sender: TObject);
begin
  if Sender is TMenuItem then
  begin
    case TMenuItem(Sender).Tag of
      SC_MenuUndo:
      if CanUndo then
        Undo;
      SC_MenuRedo:
      if CanRedo then
        Redo;
      SC_MenuCut:
      if CanCut then
        CutToClipboard;
      SC_MenuCopy:
      if CanCopy then
        CopyToClipboard;
      SC_MenuPaste:
      if CanPaste then
        PasteFromClipboard;
      SC_MenuDelete:
      if CanCut then
        ClearSelection;
      SC_MenuSelectAll:
      if CanSelect then
        SelectAll;
    end;
  end;
end;

procedure TSCCustomEdit.PrepareDefaultMenu(Menu: TPopupMenu);
var
  {$IFDEF SC_DELPHI4_AND_EARLY}
  I: Integer;
  {$ENDIF}
  MI: TMenuItem;
begin
  if (Menu <> nil) and (Menu.Items <> nil) then
  begin
    {$IFDEF SC_DELPHI4_AND_EARLY}
    for I := Menu.Items.Count - 1 downto 0 do
      Menu.Items[I].Free;
    {$ELSE}
    Menu.Items.Clear;
    {$ENDIF}

    MI := TMenuItem.Create(Menu);
    with MI do
    begin
      Caption := SSCMenuUndo;
      OnClick := PopupMenuClicked;
      Tag     := SC_MenuUndo;
      Enabled := FCanEdit and CanUndo;
    end;
    Menu.Items.Add(MI);

    MI := TMenuItem.Create(Menu);
    with MI do
    begin
      Caption := SSCMenuRedo;
      OnClick := PopupMenuClicked;
      Tag     := SC_MenuRedo;
      Enabled := FCanEdit and CanRedo;
    end;
    Menu.Items.Add(MI);

    {$IFDEF SC_DELPHI4_AND_EARLY}
    MI := TMenuItem.Create(Menu);
    MI.Caption := '-';
    Menu.Items.Add(MI);
    {$ELSE}
    Menu.Items.InsertNewLineAfter(MI);
    {$ENDIF}

    MI := TMenuItem.Create(Menu);
    with MI do
    begin
      Caption := SSCMenuCut;
      OnClick := PopupMenuClicked;
      Tag     := SC_MenuCut;
      Enabled := FCanEdit and CanCut;
    end;
    Menu.Items.Add(MI);

    MI := TMenuItem.Create(Menu);
    with MI do
    begin
      Caption := SSCMenuCopy;
      OnClick := PopupMenuClicked;
      Tag     := SC_MenuCopy;
      Enabled := CanCopy;
    end;
    Menu.Items.Add(MI);

    MI := TMenuItem.Create(Menu);
    with MI do
    begin
      Caption := SSCMenuPaste;
      OnClick := PopupMenuClicked;
      Tag     := SC_MenuPaste;
      Enabled := FCanEdit and CanPaste;
    end;
    Menu.Items.Add(MI);

    MI := TMenuItem.Create(Menu);
    with MI do
    begin
      Caption := SSCMenuDelete;
      OnClick := PopupMenuClicked;
      Tag     := SC_MenuDelete;
      Enabled := FCanEdit and CanCut;
    end;
    Menu.Items.Add(MI);

    {$IFDEF SC_DELPHI4_AND_EARLY}
    MI := TMenuItem.Create(Menu);
    MI.Caption := '-';
    Menu.Items.Add(MI);
    {$ELSE}
    Menu.Items.InsertNewLineAfter(MI);
    {$ENDIF}

    MI := TMenuItem.Create(Menu);
    with MI do
    begin
      Caption := SSCMenuSelectAll;
      OnClick := PopupMenuClicked;
      Tag     := SC_MenuSelectAll;
      Enabled := CanSelect and not (((FSelStartPos.x = 0) and (FCaretPos.x = Length(FText))) or
        ((FSelStartPos.x = Length(FText)) and (FCaretPos.x = 0)));
    end;
    Menu.Items.Add(MI);
  end;
end;

procedure TSCCustomEdit.WMRButtonUp(var Message: TWMRButtonUp);
var
  OldMenu, DefMenu: TPopupMenu;
begin
  OldMenu := PopupMenu;
  try
    DefMenu := GetDefaultMenu;
    if DefMenu <> nil then
      PopupMenu := DefMenu;

    inherited;
  finally
    PopupMenu := OldMenu;
  end;
end;

function TSCCustomEdit.GetDefaultMenu: TPopupMenu;
begin
  Result := nil;
  if FUseDefaultMenu and (PopupMenu = nil) and
    not Self.IsDesigning then
  begin
    Result := FDefaultMenu;
    {$IFDEF SC_DELPHI4_AND_EARLY}
    if Result = nil then
    begin
      Result := TPopupMenu.Create(Self);
      Result.FreeNotification(Self);
    end;
    {$ELSE}
    if Result = nil then
      Result := TPopupMenu.Create(Self)
    else
      FDefaultMenu.RemoveFreeNotification(Self);

    Result.FreeNotification(Self);
    {$ENDIF}

    FDefaultMenu := Result;

    with Result do
    begin
      Name := 'Default_PopupMenu';

      AutoPopup := True;
      PopupComponent := Self;
    end;

    PrepareDefaultMenu(Result);
  end;
end;

procedure TSCCustomEdit.WMContextMenu(var Message: TWMContextMenu);
begin
  StopSelectionDrag;

  if ContextPopup(Point(-1, -1)) then
    Message.Result := 1;

  inherited;
end;

{$IFDEF SC_DELPHI5_UP}
procedure TSCCustomEdit.DoContextPopup(MousePos: TPoint;
  var Handled: boolean);
begin
  Handled := ContextPopup(MousePos);
  inherited DoContextPopup(MousePos, Handled);
end;
{$ENDIF}

function TSCCustomEdit.ContextPopup(P: TPoint): Boolean;
var
  DefMenu: TPopupMenu;
begin
  Result := False;

  DefMenu := GetDefaultMenu;
  if DefMenu <> nil then
  begin
    Result := True;
    HideCaret;

    try
      if (P.x = -1) and (P.y = -1) then
      begin
        P := FCaretPoint;

        if not PtInRect(ClientRect, P) then
        begin
          P := Point(0, ClientHeight);
        end else
        begin
          Inc(P.x, 4);
          P.y := 0;
        end;
      end;

      P := Self.ClientToScreen(P);

      SendCancelMode(nil);
      DefMenu.Popup(P.x, P.y);
    finally
      ShowCaret;
    end;
  end;
end;

procedure TSCCustomEdit.SetAutoComplete(Value: Boolean);
begin
  FAutoComplete := Value;
end;

function TSCCustomEdit.GetCheckboxAllowGrayed: Boolean;
begin
  Result := FCheckboxAllowGrayed;
end;

function TSCCustomEdit.GetCheckboxChecked: Boolean;
begin
  Result := FCheckboxState = sccbChecked;
end;

function TSCCustomEdit.GetCheckboxEnabled: Boolean;
begin
  Result := FCheckboxEnabled;
end;

function TSCCustomEdit.GetCheckboxVisible: Boolean;
begin
  Result := FCheckboxVisible;
end;

procedure TSCCustomEdit.SetCheckboxAllowGrayed(Value: Boolean);
begin
  if FCheckboxAllowGrayed <> Value then
  begin
    FCheckboxAllowGrayed := Value;

    if FCheckboxVisible and not Value and (FCheckboxState = sccbGrayed) then
    begin
      FCheckboxState := sccbUnchecked;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomEdit.SetCheckboxChecked(Value: Boolean);
begin
  if (Value and (FCheckboxState <> sccbChecked)) or
    (not Value and (FCheckboxState <> sccbUnchecked)) then
  begin
    FCheckboxState := sccbUnchecked;
    if Value then
      FCheckboxState := sccbChecked;

    if FCheckboxVisible then
      Invalidate;
  end;
end;

procedure TSCCustomEdit.SetCheckboxEnabled(Value: Boolean);
begin
  if FCheckboxEnabled <> Value then
  begin
    FCheckboxEnabled := Value;
    if FCheckboxVisible then
      Invalidate;
  end;
end;

procedure TSCCustomEdit.SetCheckboxVisible(Value: Boolean);
begin
  if FCheckboxVisible <> Value then
  begin
    FCheckboxDown := False;
    FCheckboxHot  := False;

    FCheckboxVisible := Value;

    AdjustSize;
    UpdateEditArea;

    Invalidate;
  end;
end;

function TSCCustomEdit.GetCheckboxState: TSCCheckState;
begin
  Result := FCheckboxState;
end;

procedure TSCCustomEdit.SetCheckboxState(Value: TSCCheckState);
begin
  if FCheckboxState <> Value then
  begin
    FCheckboxState := Value;
    if FCheckboxVisible then
      Invalidate;

    CheckboxChanged;  
  end;
end;

function TSCCustomEdit.GetCheckboxWidth: Integer;
begin
  Result := 16;
end;

function TSCCustomEdit.CheckboxWidth: Integer;
begin
  Result := 0;
  if CheckboxVisible then
  begin
    Result := GetCheckboxWidth;
    if Result < 15 then Result := 15;
  end;
end;

function TSCCustomEdit.GetCheckboxRect: TRect;
var
  CR: TRect;
  Bs, W, H: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if CheckboxVisible then
  begin
    CR := GetClientRect;

    Inc(CR.Left,  FIndentLeft);
    Dec(CR.Right, FIndentRight);

    Bs := GetExtraBorderSize;
    if Bs < 0 then Bs := 0;

    Inc(CR.Left, Bs);

    if not IsRectEmpty(CR) then
    begin
      W := CheckboxWidth;
      H := CheckboxHeight;

      if (W > 0) and (H > 0) then
      begin
        if FUseImage and (Images <> nil) then
          Inc(CR.Left, Images.Width + 4);

        if not IsRectEmpty(CR) then
        begin
          Result := CR;
          Result.Right := Result.Left + W;

          CR := GetEditRect;
          Result.Top := CR.Top;
          Result.Bottom := Result.Top + H;
        end;  
      end;
    end;
  end;
end;

procedure TSCCustomEdit.DoDrawCheckbox(C: TCanvas; R: TRect; IsDown,
  IsHot: Boolean);

  procedure DrawCheckMark(AColor: TColor; MR: TRect);
  var
    L, T, I: Integer;
    Pts: array[0..2] of TPoint;
  begin
    if (AColor = clNone) or IsRectEmpty(MR) or
      (CheckboxState = sccbUnchecked) then
      Exit;
      
    with C.Pen do
    begin
      Style := psSolid;
      Mode  := pmCopy;
      Width := 1;

      Color := AColor;
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

  function GetBoxColor: TColor;
  begin
    Result := clNone;
    if CheckboxStyle = scecsOffice2k then
    begin
      Result := clWindow;
      if not (Self.Enabled and CheckboxEnabled) then
      begin
        Result := clBtnFace;
        Exit;
      end;
        
      if FCheckboxDown and FCheckboxHot then
        Result := GetOfficeXPDownedSelColor
      else
      if FCheckboxDown or FCheckboxHot then
        Result := GetOfficeXPSelColor;
    end else
    if CheckboxStyle <> scecsNone then
    begin
      Result := clWindow;
      if not (Self.Enabled and CheckboxEnabled) or (FCheckboxDown and FCheckboxHot) then
        Result := clBtnFace;
    end;
  end;

  function GetMarkColor: TColor;
  begin
    Result := clNone;
    if CheckboxState = sccbUnchecked then
      Exit;

    if not (Self.Enabled and CheckboxEnabled) then
    begin
      Result := clBtnShadow;
      Exit;
    end;

    if FCheckboxStyle = scecsOffice2k then
    begin
      Result := clHighlight;

      if FCheckboxDown and FCheckboxHot then
        Result := clHighlightText
      else
      if CheckboxState = sccbGrayed then
        Result := clBtnShadow;
    end else
    begin
      Result := clWindowText;
      if CheckboxState = sccbGrayed then
        Result := clBtnShadow;
    end;
  end;

var
  CR: TRect;
  BackColor, MarkColor: TColor;
  BorderColors: array[0..3] of TColor;
begin
  if not CheckboxVisible or IsRectEmpty(R) then
    Exit;

  BorderColors[0] := clBtnShadow;
  BorderColors[1] := clBtnHighlight;
  BorderColors[2] := cl3DDkShadow;
  BorderColors[3] := clBtnFace;

  BackColor := GetBoxColor;
  MarkColor := GetMarkColor;

  case CheckboxStyle of
    scecsNone:
    begin
      BorderColors[0] := clNone;
      BorderColors[1] := clNone;
      BorderColors[2] := clNone;
      BorderColors[3] := clNone;
    end;
    scecsFlat:
    begin
      BorderColors[0] := clBtnShadow;
      BorderColors[1] := clBtnHighlight;
      BorderColors[2] := clNone;
      BorderColors[3] := clNone;
    end;
    scecsFlatDouble:
    begin
      BorderColors[0] := cl3DDkShadow;
      BorderColors[1] := cl3DDkShadow;
      BorderColors[2] := clBtnShadow;
      BorderColors[3] := clBtnShadow;
    end;
    scecsFlatEx:
    begin
      BorderColors[0] := cl3DDkShadow;
      BorderColors[1] := cl3DDkShadow;
      BorderColors[2] := clNone;
      BorderColors[3] := clNone;
    end;
    scecsOffice2k:
    begin
      BorderColors[0] := clHighlight;
      BorderColors[1] := clHighlight;
      BorderColors[2] := clNone;
      BorderColors[3] := clNone;
    end;
  end;

  CR.Left   := R.Left  + (R.Right - R.Left - 13) div 2;
  CR.Top    := R.Top   + (R.Bottom - R.Top - 13) div 2;
  CR.Right  := CR.Left + 13;
  CR.Bottom := CR.Top  + 13;

  with C do
  begin
    if BackColor = clNone then
      Brush.Style := bsClear
    else begin
      Brush.Style := bsSolid;
      Brush.Color := BackColor;

      FillRect(CR);
    end;  
  end;

  DrawCheckMark(MarkColor, CR);

  scFrame3D(C, CR, BorderColors[0], BorderColors[1], 1, 0, False);
  scFrame3D(C, CR, BorderColors[2], BorderColors[3], 1, 0, False);
end;

function TSCCustomEdit.SwitchCheckState(S: TSCCheckState): TSCCheckState;
begin
  Result := S;
  case Result of
    sccbChecked:
      Result := sccbUnchecked;
    sccbUnchecked:
      if FCheckboxAllowGrayed then
        Result := sccbGrayed else
        Result := sccbChecked;
    sccbGrayed:
      Result := sccbChecked;
  end;
end;

procedure TSCCustomEdit.ToggleCheckbox;
begin
  SetCheckboxState(SwitchCheckState(CheckboxState));
end;

procedure TSCCustomEdit.RefreshCheckboxHot;
var
  P: TPoint;
  R: TRect;
begin
  FCheckboxHot := False;

  if CheckboxVisible and not FImageDown and
    not (FIsMouseDown or FCheckboxDown) then
  begin
    GetCursorPos(P);
    P := Self.ScreenToClient(P);

    R := GetClientRect;
    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      R := GetEditRect;
      FCheckboxHot := not IsRectEmpty(R) and PtInRect(R, P);
    end;
  end;
end;

function TSCCustomEdit.CheckboxHeight: Integer;
begin
  Result := 0;
  if CheckboxVisible then
  begin
    Result := GetCheckboxHeight;
    if Result < 15 then Result := 15;
  end;
end;

function TSCCustomEdit.GetCheckboxHeight: Integer;
begin
  Result := 15;
end;

procedure TSCCustomEdit.SetCheckboxStyle(Value: TSCEditCheckboxStyle);
begin
  if FCheckboxStyle <> Value then
  begin
    FCheckboxStyle := Value;
    if CheckboxVisible then
      Invalidate;
  end;
end;

procedure TSCCustomEdit.MouseInControlChanged;
var
  R: TRect;
  P: TPoint;
  CanBeHot, OldCheckHot: Boolean;
begin
  CanBeHot := FCheckboxDown or (FCheckboxStyle = scecsOffice2k);
  OldCheckHot := FCheckboxHot and CanBeHot;

  if not MouseInControl then
    FCheckboxHot := False
  else
  if CanBeHot then
  begin
    GetCursorPos(P);
    P := Self.ScreenToClient(P);

    R := GetCheckboxRect;
    FCheckboxHot := not IsRectEmpty(R) and PtInRect(R, P);
  end;

  if CanBeHot and (FCheckboxHot <> OldCheckHot) then
    Invalidate;

  inherited MouseInControlChanged;
end;

procedure TSCCustomEdit.SetCheckbox(Value: TSCEditCheckbox);
begin
  FCheckbox.Assign(Value);
end;

procedure TSCCustomEdit.EnabledChanged;
begin
  FImageDown    := False;
  FIsMouseDown  := False;
  FCheckboxDown := False;
  FCheckboxHot  := False;

  Invalidate;
end;

procedure TSCCustomEdit.CheckboxChanged;
begin
  DoCheckboxChanged;
  if Assigned(FOnCheckboxChange) then
    FOnCheckboxChange(Self);
end;

procedure TSCCustomEdit.DoCheckboxChanged;
begin
  //
end;

procedure TSCCustomEdit.StopSelectionDrag;
begin
  if FDraggingSelection then
  begin
    FDraggingSelection := False;
    FDragClickPos := Point(-1, -1);
    FDragDropPos := Point(-1, -1);

    UpdateCursor(0, 0, False);
    Invalidate;
    ShowCaret;
  end;
end;

function TSCCustomEdit.GetDragCursor: TCursor;
begin
  Result := crArrow;
  if FDraggingSelection then
    Result := crDrag;
end;

function TSCCustomEdit.GetSelectionRect: TRect;
var
  Txt, S: String;
  P1, P2: TPoint;
  I, L1, L2: Integer;
  CR, ER, R1, R2: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if HasSelection and not IsDescription then
  begin
    P1 := FSelStartPos;
    EnsureCaretPos(P1.X, P1.Y);

    P2 := FCaretPos;
    EnsureCaretPos(P2.X, P2.Y);

    if P1.X <> P2.X then
    begin
      if P1.X > P2.X then
      begin
        P1.Y := P1.X;
        P1.X := P2.X;
        P2.X := P1.Y;
      end;

      Txt := FText;
      S := Copy(Txt, P1.X + 1, P2.X - P1.X);
      if S = '' then
        Exit;

      CR := GetClientRect;
      if not IsRectEmpty(CR) then
      begin
        ER := GetEditRect;
        IntersectRect(ER, ER, CR);

        if IsRectEmpty(ER) then
          Exit;

        R1 := ER;
          
        Dec(R1.Left, FHorzScrollPosition);
        R1.Bottom := R1.Top + GetLineHeight + 1;

        if FAlignment <> taLeftJustify then
        begin
          L1 := GetLineLeft(0);

          Inc(R1.Left, L1);
          if FAlignment = taCenter then
            Dec(R1.Right, L1);
        end;

        IntersectRect(R2, R1, ER);
        if not IsRectEmpty(R2) then
        begin
          L1 := 0;
          for I := 1 to P1.X do
            Inc(L1, GetCharWidth(Txt[I]));

          L2 := 0;
          for I := P1.X + 1 to P2.X do
            Inc(L2, GetCharWidth(Txt[I]));

          Inc(L1, R1.Left);
          Inc(L2, L1);

          R1.Left  := L1;
          R1.Right := L2;

          IntersectRect(R1, R1, ER);

          if not IsRectEmpty(R1) then
            Result := R1;
        end;    
      end;
    end;
  end;
end;

procedure TSCCustomEdit.StartSelectionDrag;
var
  R: TRect;
  P: TPoint;
begin
  if FDraggingSelection then
    StopSelectionDrag;

  if FCanDragSelection and FCanEdit and AllowSelectionDrag and
    not (IsDesigning or IsDescription) and GetCursorPos(P) then
  begin
    P := Self.ScreenToClient(P);
    R := GetSelectionRect;

    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      FDraggingSelection := True;
      HideCaret;
      UpdateCursor(P.x, P.y, True);
      FDragClickPos := GetCharAtPoint(P);
    end;
  end;
end;

procedure TSCCustomEdit.PaintSelectionDrag(C: TCanvas);
var
  R: TRect;
  Cl: TColor;
  P, Cp, Cs: TPoint;
begin
  if (C <> nil) and CanPaintDragArrow then
  begin
    R := GetEditRect;

    if IsRectEmpty(R) then
      Exit;

    P := FDragDropPos;
    EnsureCaretPos(P.x, P.y);

    Cp := GetCaretPoint(P);
    if not PtInRect(R, Cp) then
      Exit;

    Cl := FDragPointerColor;
    if Cl = clNone then Cl := clBlack;

    Cs := GetCaretSize;

    R.Left   := Cp.x;
    R.Right  := R.Left;
    R.Top    := Cp.y;
    R.Bottom := R.Top + Cs.y;

    with C do
    begin
      Pen.Mode := pmMergePenNot;
      try
        Pen.Width := 1;
        Pen.Style := psSolid;
        Pen.Color := Cl;

        MoveTo(R.Left - 2, R.Top);
        LineTo(R.Left + 3, R.Top);

        MoveTo(R.Left, R.Top + 1);
        LineTo(R.Left, R.Bottom - 1);

        MoveTo(R.Left - 2, R.Bottom - 1);
        LineTo(R.Left + 3, R.Bottom - 1);
      finally
        Pen.Mode := pmCopy;
      end;
    end;
  end;
end;

procedure TSCCustomEdit.UpdateSelectionDrag(X, Y: Integer);
var
  P: TPoint;
  CanDragSel: Boolean;
begin
  P := Point(X, Y);
  EnsureCaretPos(P.x, P.y);

  CanDragSel := FCanDragSelection and FCanEdit and AllowSelectionDrag and
    not IsDescription and not (IsDesigning or IsLoading);

  if not CanDragSel then
    P := Point(-1, -1);

  if (FDragDropPos.x <> P.x) or (FDragDropPos.y <> P.y) then
  begin
    FDragDropPos.x := P.x;
    FDragDropPos.y := P.y;

    if CanDragSel then
      Invalidate;

    MakeCharVisible(FDragDropPos, False);
  end;
end;

function TSCCustomEdit.AllowSelectionDrag: Boolean;
begin
  Result := FCanEdit and not ReadOnly;
end;

procedure TSCCustomEdit.InternalSetSelStart(P: TPoint);
begin
  EnsureCaretPos(P.x, P.y);
  if (FSelStartPos.x <> P.x) or (FSelStartPos.y <> P.y) then
  begin
    FSelStartPos := P;
    
    FSelectionRect := GetSelectionRect;
    if FCanDragSelection and FCanEdit and AllowSelectionDrag and not IsDescription then
      UpdateCursor(0, 0, False);
  end;
end;

function TSCCustomEdit.GetKeyAction(Key: Word; Shift: TShiftState): TSCEditKeyAction;
begin
  Result := sceaNone;
  case Key of
    Ord('c'), Ord('C'):
      if Shift = [ssCtrl] then
        Result := sceaCopy;
    Ord('v'), Ord('V'):
      if Shift = [ssCtrl] then
        Result := sceaPaste;
    Ord('x'), Ord('X'):
      if Shift = [ssCtrl] then
        Result := sceaCut;
    Ord('z'), Ord('Z'):
    begin
      if Shift = [ssCtrl] then
        Result := sceaUndo
      else
      if Shift = [ssShift, ssCtrl] then
        Result := sceaRedo;
    end;
  end;
end;

procedure TSCCustomEdit.SetDragPointerColor(Value: TColor);
begin
  if FDragPointerColor <> Value then
  begin
    FDragPointerColor := Value;
    if CanPaintDragArrow then
      Invalidate;
  end;
end;

function TSCCustomEdit.CanPaintDragArrow: Boolean;
begin
  Result := FCanDragSelection and FCanEdit and FDraggingSelection and
    not (IsDesigning or IsLoading) and AllowSelectionDrag and
    not IsDescription and (FDragDropPos.x > -1) and (FDragDropPos.y > -1)
end;

procedure TSCCustomEdit.DragDropSelectedText;
var
  S: String;
  Moved, CanDrop: Boolean;
  P1, P2, P3: TPoint;
begin
  try
    if FCanDragSelection and FCanEdit and AllowSelectionDrag and HasSelection and
      not IsDescription and not (IsDesigning or IsLoading) and
      (FDragDropPos.x > -1) and (FDragDropPos.y > -1) then
    begin
      P1 := FCaretPos;
      P2 := FSelStartPos;

      if P1.y > P2.y then
      begin
        P3 := P1;
        P1 := P2;
        P2 := P3;
      end else
      if (P1.y = P2.y) and (P1.x > P2.x) then
      begin
        P3 := P1;
        P1.x := P2.x;
        P2.x := P3.x;
      end;

      EnsureCaretPos(P1.x, P1.y);
      EnsureCaretPos(P2.x, P2.y);

      CanDrop := (FDragDropPos.y < P1.y) or (FDragDropPos.y > P2.y) or
        ((FDragDropPos.y = P1.y) and (FDragDropPos.x < P1.x)) or
        ((FDragDropPos.y = P2.y) and (FDragDropPos.x > P2.x)); // verifies multi-line text also

      // this handles only a single line move
      if not CanDrop then
      begin
        P1 := FDragDropPos;

        StopSelectionDrag;
        SetSelRect(Rect(P1.x, P1.y, P1.x, P1.y));
      end else
      begin
        S := Copy(FText, P1.x + 1, P2.x - P1.x);
        if Length(S) = 0 then
          Exit;

        CatchUndo;
        try
          Moved := False;
          if FDragDropPos.x < P1.x then // before sel-start
          begin
            Delete(FText, P1.x + 1, P2.x - P1.x);
            Insert(S, FText, FDragDropPos.x + 1);

            AddToUndo(sceaDelete, S, FCaretPos, FSelStartPos, True);

            FCaretPos := FDragDropPos;
            FSelStartPos := FCaretPos;
            Inc(FSelStartPos.x, Length(S));

            Moved := True;
          end else
          if FDragDropPos.x > P2.x then // after sel-end
          begin
            Insert(S, FText, FDragDropPos.x + 1);
            Delete(FText, P1.x + 1, P2.x - P1.x);

            AddToUndo(sceaDelete, S, FCaretPos, FSelStartPos, True);

            FSelStartPos := FDragDropPos;
            FCaretPos := FSelStartPos;
            Dec(FCaretPos.x, Length(S));

            Moved := True;
          end;

          StopSelectionDrag;

          EnsureCaretPos(FCaretPos.x, FCaretPos.y);
          EnsureCaretPos(FSelStartPos.x, FSelStartPos.y);

          FSelectionRect := GetSelectionRect;

          if Moved then
          begin
            FModified := True;
            AddToUndo(sceaInsert, S, FCaretPos, FSelStartPos, True);
          end;

          CheckCaretVisible;

          CaretMoved;
          TriggerChange;
        finally
          ReleaseUndoCatch;
        end;
      end;
    end;
  finally
    StopSelectionDrag;
  end;
end;

procedure TSCCustomEdit.MakeCharVisible(Ch: TPoint; IsCaretPos: Boolean);
var
  S: String;
  PassCh: Char;
  P, P2: TPoint;
  CR, R: TRect;
  Ln, Lp, L, I, Cw, X, W: Integer;
begin
  if not HandleAllocated or IsDesigning then
    Exit;

  EnsureCaretPos(Ch.x, Ch.y);
    
  CR := GetClientRect;
  if not IsRectEmpty(CR) then
  begin
    Ln := Length(FText);
    if Ln = 0 then
    begin
      if FHorzScrollPosition <> 0 then
      begin
        FHorzScrollPosition := 0;

        Invalidate;
        UpdateCaret;

        if IsCaretPos then
          CaretMoved;
      end;

      Exit;
    end;

    R := GetEditRect;
    IntersectRect(R, R, CR);

    if IsRectEmpty(R) then Exit;

    W  := GetLineWidth(Ch.Y);
    if W > 0 then Inc(W);

    Lp := FHorzScrollPosition;
    FHorzScrollPosition := 0;

    if W >= R.Right - R.Left then
    begin
      P  := GetCaretPoint(Ch);

      if Ch.X = Ln then
        FHorzScrollPosition := W - (R.Right - R.Left)
      else begin
        FHorzScrollPosition := Lp;

        P2 := GetCaretPoint(Ch);
        if (P2.x > R.Left) and (P2.x < R.Right) then
          Exit;

        FHorzScrollPosition := 0;
        if P.X >= R.Right then
        begin
          FHorzScrollPosition := Lp;

          S := FText;
          if IsPassword then
          begin
            PassCh := FPasswordChar;
            if PassCh = #0 then PassCh := '*';

            S := StringOfChar(PassCh, Ln);
          end;

          if Ch.x = Ln then
            FHorzScrollPosition := W - (R.Right - R.Left)
          else
          if Ch.x < Ln then
          begin
            Cw := (GetCharWidth('W') + GetCharWidth('i')) div 2;

            X  := 6*Cw; L := 0;
            for I := Ch.X + 1 to Ln do
            begin
              Inc(L, GetCharWidth(S[I]));
              if L >= X then
                Break;
            end;

            X := L;
            L  := P.x - (R.Right - R.Left) + X;

            if P.x - L <= R.Left then
              for I := 1 to 5 do
              begin
                Inc(L, Cw);
                if P.x - L > R.Left then
                  Break;
              end;

            FHorzScrollPosition := L;
          end;
        end;
      end;

      if FHorzScrollPosition < 0 then
        FHorzScrollPosition := 0;

      if FHorzScrollPosition > W - (R.Right - R.Left) then
        FHorzScrollPosition := W - (R.Right - R.Left);

      if FHorzScrollPosition <> Lp then
      begin
        Invalidate;
        UpdateCaret;

        if IsCaretPos then
          CaretMoved;
      end;
    end;
  end;
end;

function TSCCustomEdit.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCEditBorderProps;
end;

function TSCCustomEdit.GetPicturePropsClass: TSCCustomPicturePropsClass;
begin
  Result := TSCEditPictureProps;
end;

function TSCCustomEdit.GetEditColorsClass: TSCEditCustomColorsClass;
begin
  Result := TSCEditColors;
end;

procedure TSCCustomEdit.SetColors(Value: TSCEditCustomColors);
begin
  FColors.Assign(Value);
end;

procedure TSCCustomEdit.DoPictureListChanged;
begin
  if ShowPicture then
    Invalidate;
end;

function TSCCustomEdit.GetDescriptionColor: TColor;
begin
  Result := FDescriptionColor;
end;

procedure TSCCustomEdit.ConstrainedResize(var MinWidth, MinHeight,
  MaxWidth, MaxHeight: Integer);
begin
  inherited ConstrainedResize(MinWidth, MinHeight, MaxWidth, MaxHeight);
  
  if AutoSize then
  begin
    MinHeight := GetAutoHeight;
    MaxHeight := MinHeight;
  end;
end;

procedure TSCCustomEdit.CNCommand(var Message: TWMCommand);
begin
  if (Message.NotifyCode = EN_CHANGE) and not FCreating then Change;
end;

procedure TSCCustomEdit.CreateWnd;
begin
  FCreating := True;
  try
    inherited CreateWnd;
  finally
    FCreating := False;
  end;
end;

function TSCCustomEdit.EditCanModify: Boolean;
begin
  Result := True;
end;

function TSCCustomEdit.GetColors: TSCEditCustomColors;
begin
  Result := FColors;
end;

procedure TSCCustomEdit.WndProc(var Message: TMessage);
var
  P: PChar;
begin
  case Message.Msg of
    EM_GETMODIFY:
      Message.Result := Integer(FModified);
    EM_SETMODIFY:
      FModified := Boolean(Message.WParam);
    EM_GETLINECOUNT:
      Message.Result := 1;
    EM_LINELENGTH:
      Message.Result := Length(FText);
    EM_LINEINDEX:
      Message.Result := 0;
    EM_LIMITTEXT:
      SetMaxLength(Message.WParam);
    EM_CANUNDO:
      Message.Result := Integer(CanUndo);
    EM_UNDO:
      Undo;
    EM_SETPASSWORDCHAR:
      SetPasswordChar(Char(Message.WParam));
    EM_EMPTYUNDOBUFFER:
      ClearUndo;
    EM_SETREADONLY:
      SetReadOnly(Boolean(Message.WParam));
    EM_GETSEL:
    begin
      Message.WParam := SelStart.Y;
      Message.LParam := SelStart.Y + SelLength;
    end;
    EM_SETSEL:
      SetSelRect(Rect(Message.WParam, 0, Message.LParam, 0));
    EM_REPLACESEL:
    begin
      P := PChar(Message.LParam);
      InsertText(P^);
    end;
  end;
  inherited WndProc(Message);
end;

function TSCCustomEdit.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

function TSCCustomEdit.BeforeDeleteText: Boolean;
begin
  Result := True;
end;

function TSCCustomEdit.BeforeInsertChar(var Ch: Char): Boolean;
begin
  Result := True;
end;

function TSCCustomEdit.BeforeInsertText(var S: String): Boolean;
begin
  Result := True;
end;

function TSCCustomEdit.CanInsertText(S: String): Boolean;
begin
  Result := True;
end;

procedure TSCCustomEdit.DoKeyDownEvent(var Key: Word; Shift: TShiftState);
begin
  if Assigned(OnKeyDown) then OnKeyDown(Self, Key, Shift);
end;

procedure TSCCustomEdit.DoKeyPressEvent(var Key: Char);
begin
  if Assigned(OnKeyPress) then OnKeyPress(Self, Key);
end;

procedure TSCCustomEdit.DoKeyUpEvent(var Key: Word; Shift: TShiftState);
begin
  if Assigned(OnKeyUp) then OnKeyUp(Self, Key, Shift);
end;

procedure TSCCustomEdit.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
  if Assigned(FOnFocusChanged) then
    FOnFocusChanged(Self);
end;

procedure TSCCustomEdit.ValidateEdit;
begin
  //
end;

function TSCCustomEdit.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
end;

procedure TSCCustomEdit.SetLayout(Value: TSCEditLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    UpdateEditArea;
  end;
end;

function TSCCustomEdit.GetExtraBorderSize: Integer;
begin
  Result := 0;
end;

procedure TSCCustomEdit.SetFocusExpandSize(Value: Integer);
var
  OldValue: Integer;
begin
  if Value < 0 then Value := 0;

  if FFocusExpandSize <> Value then
  begin
    OldValue := FFocusExpandSize;
    FFocusExpandSize := Value;

    if HasFocus then
      SetBounds(Left, Top, Width + (FFocusExpandSize - OldValue), Height);
  end;
end;

function TSCCustomEdit.GetPopupMenu: TPopupMenu;
begin
  {$IFDEF SC_DELPHI4_AND_EARLY}
     Result := GetDefaultMenu;
     if Result = nil then
       Result := inherited GetPopupMenu;
  {$ELSE}
     Result := inherited GetPopupMenu;
  {$ENDIF}
end;

function TSCCustomEdit.GetEditValue: String;
begin
  Result := Self.Text;
end;

procedure TSCCustomEdit.CMJumpToNext(var Message: TMessage);
begin
  Message.Result := 0;
  if FEnterAsTab and (Message.WParam = VK_RETURN) then
    Message.Result := 1;
end;

function TSCCustomEdit.CanBeepForKey(Key: Word;
  Shift: TShiftState): Boolean;
begin
  Result := not IsValidKey(Char(Key));
end;

procedure TSCCustomEdit.CNChar(var Message: TWMChar);
var
  Key: Char;
  ShiftState: TShiftState;
  KeyState: TKeyboardState;
begin
  Inc(FEditTextCount);
  try
    inherited;
    if not (IsDesigning or FIsMouseDown or MouseIsDown) and
      FCanEdit and not ReadOnly and EditCanModify then
    begin
      Key := Char(Message.CharCode);
      if (Key <> ^H) and not IsValidKey(Key) then
      begin
        GetKeyboardState(KeyState);
        ShiftState := KeyboardStateToShiftState(KeyState);

        if (ShiftState = []) and CanBeepForKey(Ord(Key), ShiftState) then
          Beep;
      end;
    end;
  finally
    Dec(FEditTextCount);
  end;
end;

function TSCCustomEdit.GetAlignment: TAlignment;
begin
  Result := FAlignment;
end;

function TSCCustomEdit.GetLineText(Index: Integer): String;
begin
  Result := FText;
end;

function TSCCustomEdit.GetEditingText: Boolean;
begin
  Result := FEditTextCount > 0;
end;

function TSCCustomEdit.GetCaretHeight: Word;
var
  R: TRect;
begin
  Result := GetLineHeight;

  R := GetEditRect;
  OffsetRect(R, -R.Left, -R.Top);

  if Result > R.Bottom then
  begin
    Result := R.Bottom;
    if Result < 1 then Result := 1;
  end;
end;

{ TSCEditUndoStack }

function TSCEditUndoStack.Add: PSCEditUndoRec;
begin
  New(Result);
  with Result^ do
  begin
    GroupID  := -1;
    CaretPos := Point(0, 0);
    StartPos := Point(0, 0);
  end;

  if FItems = nil then
    FItems := TList.Create;

  FItems.Add(Result);
end;

procedure TSCEditUndoStack.Clear;
begin
  while Count > 0 do
    Delete(Count-1);
  FGroupID := -1;
end;

function TSCEditUndoStack.Count: Integer;
begin
  Result := 0;
  if FItems <> nil then
    Result := FItems.Count;
end;

constructor TSCEditUndoStack.Create;
begin
  inherited Create;
  FGroupID := -1;
end;

procedure TSCEditUndoStack.Delete(Index: Integer);
var
  R: PSCEditUndoRec;
begin
  if (FItems <> nil) and
    (Index > -1) and (Index < FItems.Count) then
  begin
    R := FItems.Items[Index];
    FItems.Delete(Index);

    Dispose(R);

    if FItems.Count = 0 then
      FreeAndNil(FItems);
  end;
end;

destructor TSCEditUndoStack.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TSCEditUndoStack.Extract(Item: PSCEditUndoRec): PSCEditUndoRec;
{$IFDEF SC_DELPHI4_AND_EARLY}
var
  I: Integer;
{$ENDIF}
begin
  Result := nil;
  if FItems <> nil then
  begin
    {$IFDEF SC_DELPHI4_AND_EARLY}
    Result := nil;
    I := FItems.IndexOf(Item);
    if I >= 0 then
    begin
      Result := Item;
      FItems.Delete(I);
    end;
    {$ELSE}
    Result := FItems.Extract(Item);
    {$ENDIF}
  end;
end;

function TSCEditUndoStack.GetItem(Index: Integer): PSCEditUndoRec;
begin
  Result := nil;
  if (FItems <> nil) and
    (Index > -1) and (Index < FItems.Count) then
    Result := FItems.Items[Index];
end;

function TSCEditUndoStack.IndexOf(Item: PSCEditUndoRec): Integer;
begin
  Result := -1;
  if (Item <> nil) and (FItems <> nil) then
    Result := FItems.IndexOf(Item);
end;

procedure TSCEditUndoStack.Insert(Index: Integer; Item: PSCEditUndoRec);
begin
  if Item <> nil then
  begin
    if FItems = nil then
      FItems := TList.Create;

    if FItems.IndexOf(Item) = -1 then
    begin
      if Index < 0 then
        Index := 0;
      if Index > FItems.Count then
        Index := FItems.Count;

      FItems.Insert(Index, Item);
    end;
  end;
end;

function TSCEditUndoStack.NewGroupID: Integer;
begin
  Inc(FGroupID);
  Result := FGroupID;
end;

{$I SCVerRec.inc}

end.