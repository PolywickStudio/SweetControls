{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCSimpleListbox;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, SCConsts, SCCommon, SCControl, SCEdits;

type
  TSCCustomSimpleListbox = class;

  TSCSimpleListState = set of (sclsChecked, sclsGrayed, sclsSelected, sclsFocused,
    sclsHottrack, sclsDisabled, sclsEditing);

  TSCDrawListItemEvent = procedure(Control: TWinControl; C: TCanvas;
    Index: Integer; Rect: TRect; State: TSCSimpleListState;
    UserData: Integer; var Done: Boolean) of object;

  TSCMeasureListItemEvent = procedure(Control: TWinControl; Index: Integer;
    var AWidth, AHeight, AIndent: Integer) of object;

  TSCListItemEvent = procedure(Sender: TObject; Index: Integer) of object;

  TSCValidateEditorEvent = procedure(Sender: TObject; Index: Integer;
    var Text: String; var AcceptEdit: Boolean) of object;

  TSCShowEditorEvent = procedure(Sender: TObject; Index: Integer; var AllowEdit: Boolean) of object;

  TSCPrepareEditorEvent = procedure(Sender: TObject; var ABorder: TSCControlBorder;
    var ABorderColor, AColor, AFontColor: TColor; var ATransparency: Boolean) of object;

  TSCSizeEditorEvent = procedure(Sender: TObject; Index: Integer; var EditRect: TRect) of object;

  TSCClickCheckEvent = procedure(Control: TWinControl; Index: Integer) of object;

  TSCListPaintHint = procedure(Sender: TObject; Index: Integer; C: TCanvas;
    R: TRect; HintText: String) of object;

  TSCListHintEvent = procedure(Sender: TObject; Index: Integer; var R: TRect;
    var HintText: String; var AllowShow: Boolean) of object;

  TSCListboxScrollbar = class(TSCControlScrollbar)
  published
    property Background;
    property ButtonColors;
    property Icons;
    property SlideLine;
    property Thumb;
  end;

  { ************************************************************************* }
  {                                                                           }
  {  item data map                                                            }
  {                                                                           }
  {  Data[Index, 0] is item height                                            }
  {  Data[Index, 1] is item width                                             }
  {  Data[Index, 2] is item selection flag                                    }
  {  Data[Index, 3] is item selection backup flag for mouse move with ssCtrl  }
  {  Data[Index, 4] is item check state                                       }
  {  Data[Index, 5] is item enabled state, if Data[Index, 5] = 0 then Enabled }
  {  Data[Index, 6] is item indent level                                      }
  {  Data[Index, 7] is item image index                                       }
  {  Data[Index, 9] is external item data storage                              }
  {                                                                           }
  { ************************************************************************* }


  TSCListBorderProps = class(TSCControlBorderProps)
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

  TSCListCustomColors = class(TPersistent)
  private
    FOwner: TSCCustomSimpleListbox;
    function  GetDisabledColor: TColor;
    procedure SetDisabledColor(Value: TColor);
    function  GetDisabledTextColor: TColor;
    procedure SetDisabledTextColor(Value: TColor);
    function  GetHideSelectionBorderColor: TColor;
    procedure SetHideSelectionBorderColor(Value: TColor);
    function  GetHideSelectionColor: TColor;
    procedure SetHideSelectionColor(Value: TColor);
    function  GetHideSelectionTextColor: TColor;
    procedure SetHideSelectionTextColor(Value: TColor);
    function  GetHighlightBorderColor: TColor;
    procedure SetHighlightBorderColor(Value: TColor);
    function  GetHighlightColor: TColor;
    procedure SetHighlightColor(Value: TColor);
    function  GetHighlightTextColor: TColor;
    procedure SetHighlightTextColor(Value: TColor);
    function  GetAlternateColor: TColor;
    procedure SetAlternateColor(Value: TColor);
  protected
    function GetOwner: TPersistent; override;

    property AlternateColor: TColor read GetAlternateColor write SetAlternateColor default clNone;
    property DisabledColor: TColor read GetDisabledColor write SetDisabledColor default clBtnFace;
    property DisabledTextColor: TColor read GetDisabledTextColor write SetDisabledTextColor default clGrayText;
    property HideSelectionBorderColor: TColor read GetHideSelectionBorderColor write SetHideSelectionBorderColor default clNone;
    property HideSelectionColor: TColor read GetHideSelectionColor write SetHideSelectionColor default clBtnFace;
    property HideSelectionTextColor: TColor read GetHideSelectionTextColor write SetHideSelectionTextColor default clBtnText;
    property HighlightBorderColor: TColor read GetHighlightBorderColor write SetHighlightBorderColor default clNone;
    property HighlightColor: TColor read GetHighlightColor write SetHighlightColor default clHighlight;
    property HighlightTextColor: TColor read GetHighlightTextColor write SetHighlightTextColor default clHighlightText;
  public
    constructor Create(AOwner: TSCCustomSimpleListbox); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomSimpleListbox read FOwner;
  end;

  TSCListCustomColorsClass = class of TSCListCustomColors;

  TSCListColors = class(TSCListCustomColors)
  published
    property AlternateColor;
    property DisabledColor;
    property DisabledTextColor;
    property HideSelectionBorderColor;
    property HideSelectionColor;
    property HideSelectionTextColor;
    property HighlightBorderColor;
    property HighlightColor;
    property HighlightTextColor;
  end;

  TSCListScrollbars = class(TSCControlScrollbars)
  private
    function  GetShowHorizontal: Boolean;
    procedure SetShowHorizontal(Value: Boolean);
    function  GetShowVertical: Boolean;
    procedure SetShowVertical(Value: Boolean);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property ShowHorizontal: Boolean read GetShowHorizontal write SetShowHorizontal default True;
    property ShowVertical: Boolean read GetShowVertical write SetShowVertical;
  end;

  TSCListPictureProps = class(TSCPictureProps);

  TSCCustomSimpleListbox = class(TSCCustomScrollControl)
  private
    FAllowEdit: Boolean;
    FAllowMouseEdit: Boolean;
    FAllowGrayed: Boolean;
    FAlternateColor: TColor;
    FCenterImages: Boolean;
    FColors: TSCListCustomColors;
    FColumns: Integer;
    FContinuousKeySearch: Boolean;
    FDisabledColor: TColor;
    FDisabledTextColor: TColor;
    FEndEllipsis: Boolean;
    FExtendedSelect: Boolean;
    FFlat: TSCSimpleCheckFlat;
    FHideFocusRect: Boolean;
    FHideSelection: Boolean;
    FHideSelectionBorderColor: TColor;
    FHideSelectionColor: TColor;
    FHideSelectionTextColor: TColor;
    FHighlightBorderColor: TColor;
    FHighlightColor: TColor;
    FHighlightTextColor: TColor;
    FHottrack: Boolean;
    FHottrackColor: TColor;
    FHottrackUnderline: Boolean;
    FStartIndex: Integer;
    FItems: TStrings;
    FItemHeight: Integer;
    FItemIndex: Integer;
    FLayout: TSCLayout;
    FLineSelect: Boolean;
    FMultiSelect: Boolean;
    FScrollbarHorizontal: Boolean;
    FScrollbarVertical: Boolean;
    FScrollHeight: LongInt;
    FScrollWidth: LongInt;
    FShowCheckboxes: Boolean;
    FShowItemHints: Boolean;
    FShowItemImages: Boolean;
    FShowItemOnSelect: Boolean;
    FTopIndex: Integer;
    FHotIndex: Integer;
    FDefaultHeight: Integer;
    FValues: TStrings;
    FMouseDownIndex: Integer;
    FMouseDownShift: TShiftState;
    FSelectionClears: Boolean;
    FHorizontalPos: Integer;
    FSorted: Boolean;
    FOnClickCheck: TSCClickCheckEvent;
    FOnDrawItem: TSCDrawListItemEvent;
    FOnHideEditor: TSCListItemEvent;
    FOnHottrack: TSCListItemEvent;
    FOnMeasureItem: TSCMeasureListItemEvent;
    FOnPaintHint: TSCListPaintHint;
    FOnPrepareEditor: TSCPrepareEditorEvent;
    FOnShowEditor: TSCShowEditorEvent;
    FOnShowItemHint: TSCListHintEvent;
    FOnSizeEditor: TSCSizeEditorEvent;
    FOnValidateEditor: TSCValidateEditorEvent;
    FInplaceEditor: TSCCustomEdit;
    FInplaceEditorClass: TSCCustomEditClass;
    FEditSavedText: String;
    FInplaceOldWndProc: TWndMethod;
    FHintWnd: THintWindow;
    FHintIndex: Integer;
    FHintText: String;
    FHintOldWndProc: TWndMethod;
    FRevertable: Boolean;
    FScrolling: Boolean;
    FScrollTimer: Integer;
    FItemHintLock: Integer;
    FClickedIndex: Integer;
    FClickTimer: LongInt;
    FInEditShow: Boolean;
    FBypassEditing: Boolean;
    FSearchText: String;
    FSearchTickCount: DWord;
    FForceDropdownClick: Boolean;
    FDropping: Boolean;
    FScrollPosChanging: Integer;
    FScrollbarChanging: Integer;
    FCreatingWnd: Integer;
    FOffice12Style: Boolean;
    function  GetObject(Index: Integer): TObject;
    procedure SetObject(Index: Integer; Value: TObject);
    function  GetString(Index: Integer): String;
    procedure SetString(Index: Integer; const Value: String);
    function  GetChecked(Index: Integer): Boolean;
    procedure SetChecked(Index: Integer; Value: Boolean);
    function  GetState(Index: Integer): TSCCheckState;
    procedure SetState(Index: Integer; Value: TSCCheckState);
    function  GetIndentLevel(Index: Integer): Integer;
    procedure SetIndentLevel(Index: Integer; Value: Integer);
    function  GetItemEnabled(Index: Integer): Boolean;
    procedure SetItemEnabled(Index: Integer; Value: Boolean);
    function  GetItemImage(Index: Integer): Integer;
    procedure SetItemImage(Index: Integer; Value: Integer);
    procedure SetAllowEdit(Value: Boolean);
    procedure SetAlternateColor(Value: TColor);
    procedure SetCenterImages(Value: Boolean);
    procedure SetColors(Value: TSCListCustomColors);
    procedure SetColumns(Value: Integer);
    procedure SetContinuousKeySearch(Value: Boolean);
    procedure SetDisabledColor(Value: TColor);
    procedure SetDisabledTextColor(Value: TColor);
    procedure SetEndEllipsis(Value: Boolean);
    procedure SetExtendedSelect(Value: Boolean);
    procedure SetFlat(Value: TSCSimpleCheckFlat);
    procedure SetHideFocusRect(Value: Boolean);
    procedure SetHideSelection(Value: Boolean);
    procedure SetHideSelectionBorderColor(Value: TColor);
    procedure SetHideSelectionColor(Value: TColor);
    procedure SetHideSelectionTextColor(Value: TColor);
    procedure SetHighlightBorderColor(Value: TColor);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHighlightTextColor(Value: TColor);
    procedure SetHorizontalPos(Value: Integer);
    procedure SetHottrack(Value: Boolean);
    procedure SetHottrackColor(Value: TColor);
    procedure SetHottrackUnderline(Value: Boolean);
    procedure SetItemHeight(Value: Integer);
    procedure SetItemIndex(Value: Integer);
    function  GetItems: TStrings;
    procedure SetItems(Value: TStrings);
    procedure SetLayout(Value: TSCLayout);
    procedure SetLineSelect(Value: Boolean);
    procedure SetMultiSelect(Value: Boolean);
    procedure SetScrollbarHorizontal(Value: Boolean);
    procedure SetScrollbarVertical(Value: Boolean);
    function  GetSelected(Index: Integer): Boolean;
    procedure SetSelected(Index: Integer; Value: Boolean);
    procedure SetShowCheckboxes(Value: Boolean);
    procedure SetShowItemImages(Value: Boolean);
    procedure SetSorted(Value: Boolean);
    procedure SetTopIndex(Value: Integer);
    procedure SetValues(Value: TStrings);
    procedure SetOffice12Style(Value: Boolean);

    procedure ItemsChanged(Sender: TObject);
    procedure SetScrollBounds(AWidth, AHeight: LongInt);

    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;

    procedure KillClickTimer;
    procedure InitiateClickTimer;

    procedure HintWindowProc(var Message: TMessage);
    procedure InplaceWindowProc(var Message: TMessage);
    procedure InplaceChanged(Sender: TObject);
    function  SwitchState(St: TSCCheckState): TSCCheckState;

    procedure MeasureItem(Index: Integer; var AWidth, AHeight, AIndent: Integer);
    procedure UpdateScrollbars(Horz, Vert: Boolean);
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Paint; override;
    procedure Loaded; override;
    procedure DragCanceled; override;

    procedure SortItems; virtual;
    function  GetCount: Integer; virtual;

    function  GetSelectedValue: String; virtual;
    procedure ValuesChanged(Sender: TObject); virtual;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetListColorsClass: TSCListCustomColorsClass; dynamic;
    function  GetPicturePropsClass: TSCCustomPicturePropsClass; override;
    function  GetControlScrollbarsClass: TSCControlCustomScrollbarsClass; override;

    procedure CanChangeCheckState(OldSt: TSCCheckState; var NewSt: TSCCheckState); dynamic;
    function  CanChangeItemIndex(Index: Integer): Integer; dynamic;
    function  CanEdit(Index: Integer): Boolean; dynamic;

    function  CanScrollToPos(Kind: TSCScrollbarKind; var NewValue: Integer): Boolean; override;
    procedure DoScrollerPositionChanged(Kind: TSCScrollbarKind); override;

    function  CreateItems: TStrings; dynamic;
    procedure DoSetItems; dynamic;

    procedure DoInternalDataChanged(Index: Integer); dynamic;
    procedure DoInternalItemsChanged; dynamic;

    procedure SetIndent(Value: Integer); override;
    procedure ColorsChanged; dynamic;
    procedure IndentChanged; override;
    procedure ImageListChange(Sender: TObject); override;

    procedure StopTracking; override;
    procedure MouseInControlChanged; override;
    function  GetBlendValue: Word; override;

    procedure MakeVisible(Index: Integer);

    procedure ShowHintWindow(P: TPoint; CheckHintSize: Boolean = True);
    procedure HideHintWindow;

    procedure SetHotIndex(Value: Integer; DoUpdate: Boolean = True);
    procedure DoHotChange; dynamic;
    procedure SetInplaceEditorClass(Value: TSCCustomEditClass); virtual;
    function  GetInplaceEditorClass: TSCCustomEditClass; virtual;

    function  GetEditText: String; virtual;
    procedure SetEditText(const Value: String); virtual;

    procedure PrepareEditor; dynamic;
    procedure SizeEditor; dynamic;

    function  CanShowEditor: Boolean; dynamic;
    procedure DoShowEditor(Index: Integer; var AllowEdit: Boolean); dynamic;
    procedure DoSizeEditor(Index: Integer; var EditRect: TRect); dynamic;
    procedure DoHideEditor(Index: Integer);
    procedure DoValidateEditor(Index: Integer; var Text: String; var AcceptEdit: Boolean); dynamic;
    procedure ClickCheck(Index: Integer); dynamic;
    procedure DoItemClick(Index: Integer); dynamic;

    procedure UpdateHotTrack(Draw: Boolean = True);
    procedure UpdateItem(C: TCanvas; Index: Integer);

    procedure BeforePaintItem(C: TCanvas; Index: Integer; ClientR, R: TRect;
      State: TSCSimpleListState); virtual;
    procedure AfterPaintItem(C: TCanvas; Index: Integer; ClientR, R: TRect;
      State: TSCSimpleListState); virtual;

    procedure DoPaintBack(C: TCanvas); virtual;
    procedure DoPaintItem(C: TCanvas; Index: Integer; ClientR, R: TRect);
    procedure DoDrawCheckMark(C: TCanvas; R: TRect; Cl: TColor); virtual;
    procedure DoDrawCheckbox(C: TCanvas; Index: Integer; CR, R: TRect; State: TSCSimpleListState); virtual;
    procedure DoDrawItem(C: TCanvas; Index: Integer; CR, R: TRect;
      State: TSCSimpleListState); virtual;
    procedure DrawOffice12Face(ACanvas: TCanvas; ARect: TRect;
      AColor: TColor; AFace, AFrame: Boolean);

    procedure VerifyIndex(var Index: Integer); dynamic;
    procedure VerifyTopIndex(var Index: Integer); dynamic;
    procedure VerifyHorizontalPos(var P: Integer); dynamic;

    procedure UpdateBounds(var AWidth, AHeight: LongInt);
    function  GetItemHeight: Integer;
    procedure GetItemBounds(Index: Integer; var AWidth, AHeight, AIndent: Integer); virtual;

    function  GetHorzScrollPos: Integer; dynamic;
    procedure DoScrollBoundsChanged; dynamic;
    function  GetScrollbarClass: TSCCustomControlScrollbarClass; override;

    function  GetGradientShadow(AColor: TColor): TColor;
    function  GetGradientDark(AColor: TColor): TColor;
    function  GetGradientLight(AColor: TColor): TColor;
    function  GetGradientExDark(AColor: TColor): TColor;
    function  GetGradientExLight(AColor: TColor): TColor;
    function  GetGradientPeal(AColor: TColor): TColor;
    function  GetGradientPreDark(AColor: TColor): TColor;
    function  GetGradientPreLight(AColor: TColor): TColor;

    procedure ProcessSearchKey(Key: Char); virtual;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function  GetMaxWidth: Integer; virtual;
    function  GetCheckWidth: Integer;
    function  GetColumnHeight: Integer; dynamic;
    function  GetColumnCount: Integer; dynamic;
    function  GetColumnOf(Index: Integer): Integer; dynamic;

    function  GetPageDownIndex(Index: Integer): Integer; dynamic;
    function  GetPageUpIndex(Index: Integer): Integer; dynamic;

    function  UpdateVertScrollBar: Boolean; dynamic;
    function  UpdateHorzScrollBar: Boolean; dynamic;
    function  IsVertScrollBarVisible: Boolean; override;
    function  IsHorzScrollBarVisible: Boolean; override;
    function  CanShowVertScrollBar: Boolean; dynamic;
    function  CanShowHorzScrollBar: Boolean; dynamic;

    procedure DoMeasureItem(Index: Integer; var AWidth, AHeight, AIndent: Integer); virtual;
    function  InternalGetItemData(Index: Integer): Longint; dynamic;
    procedure InternalSetItemData(Index: Integer; AData: Longint); dynamic;
    function  GetItemData(Index: Integer): LongInt; dynamic;
    procedure SetItemData(Index: Integer; AData: LongInt); dynamic;

    procedure ResetContent; dynamic;
    procedure DeleteString(Index: Integer); dynamic;

    procedure StartScrolling;
    procedure StopScrolling;
    function  Scrolling: Boolean;
    function  ScrollPaused: Boolean;
    procedure PauseScrolling;
    procedure ResumeScrolling;

    procedure LockItemHint;
    procedure UnlockItemHint;
    function  ItemHintLocked: Boolean;

    property InEditShow: Boolean read FInEditShow;
    property ScrollHeight: LongInt read FScrollHeight;
    property ScrollWidth: LongInt read FScrollWidth;
    property Count: Integer read GetCount;

    property Dropping: Boolean read FDropping write FDropping;
    property ForceDropdownClick: Boolean read FForceDropdownClick write FForceDropdownClick default False;
    property Items: TStrings read GetItems write SetItems;
    property Objects[Index: Integer]: TObject read GetObject write SetObject;
    property Strings[Index: Integer]: String read GetString write SetString;
    property Checked[Index: Integer]: Boolean read GetChecked write SetChecked;
    property State[Index: Integer]: TSCCheckState read GetState write SetState;
    property IndentLevel[Index: Integer]: Integer read GetIndentLevel write SetIndentLevel;
    property ItemEnabled[Index: Integer]: Boolean read GetItemEnabled write SetItemEnabled;
    property ItemImage[Index: Integer]: Integer read GetItemImage write SetItemImage;
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed default False;
    property AllowEdit: Boolean read FAllowEdit write SetAllowEdit default False;
    property AllowMouseEdit: Boolean read FAllowMouseEdit write FAllowMouseEdit default True;
    property AlternateColor: TColor read FAlternateColor write SetAlternateColor default clNone;
    property CenterImages: Boolean read FCenterImages write SetCenterImages default False;
    property Colors: TSCListCustomColors read FColors write SetColors;
    property Columns: Integer read FColumns write SetColumns default 0;
    property ContinuousKeySearch: Boolean read FContinuousKeySearch write SetContinuousKeySearch default False;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clBtnFace;
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText;
    property EditText: String read GetEditText write SetEditText;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default False;
    property ExtendedSelect: Boolean read FExtendedSelect write SetExtendedSelect default True;
    property Flat: TSCSimpleCheckFlat read FFlat write SetFlat default scsfFlat;
    property HideFocusRect: Boolean read FHideFocusRect write SetHideFocusRect default False;
    property HideSelection: Boolean read FHideSelection write SetHideSelection default False;
    property HideSelectionBorderColor: TColor read FHideSelectionBorderColor write SetHideSelectionBorderColor default clNone;
    property HideSelectionColor: TColor read FHideSelectionColor write SetHideSelectionColor default clBtnFace;
    property HideSelectionTextColor: TColor read FHideSelectionTextColor write SetHideSelectionTextColor default clBtnText;
    property HighlightBorderColor: TColor read FHighlightBorderColor write SetHighlightBorderColor default clNone;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default clHighlight;
    property HighlightTextColor: TColor read FHighlightTextColor write SetHighlightTextColor default clHighlightText;
    property HorizontalPos: Integer read FHorizontalPos write SetHorizontalPos default 0;
    property HotIndex: Integer read FHotIndex;
    property Hottrack: Boolean read FHottrack write SetHottrack default True;
    property HottrackColor: TColor read FHottrackColor write SetHottrackColor default clHighlight;
    property HottrackUnderline: Boolean read FHottrackUnderline write SetHottrackUnderline default False;
    property InplaceEditor: TSCCustomEdit read FInplaceEditor;
    property InplaceEditorClass: TSCCustomEditClass read GetInplaceEditorClass write SetInplaceEditorClass;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default -1;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Layout: TSCLayout read FLayout write SetLayout default sclaTop;
    property LineSelect: Boolean read FLineSelect write SetLineSelect default True;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect default False;
    property Revertable: Boolean read FRevertable write FRevertable default False;
    property ScrollbarHorizontal: Boolean read FScrollbarHorizontal write SetScrollbarHorizontal default True;
    property ScrollbarVertical: Boolean read FScrollbarVertical write SetScrollbarVertical default True;
    property Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
    property SelectedValue: String read GetSelectedValue;
    property ShowCheckboxes: Boolean read FShowCheckboxes write SetShowCheckboxes default False;
    property ShowItemHints: Boolean read FShowItemHints write FShowItemHints default False;
    property ShowItemImages: Boolean read FShowItemImages write SetShowItemImages default False;
    property ShowItemOnSelect: Boolean read FShowItemOnSelect write FShowItemOnSelect default True;
    property Sorted: Boolean read FSorted write SetSorted default False;
    property TopIndex: Integer read FTopIndex write SetTopIndex;
    property Values: TStrings read FValues write SetValues;
    property Office12Style: Boolean read FOffice12Style write SetOffice12Style default False;
    property OnClickCheck: TSCClickCheckEvent read FOnClickCheck write FOnClickCheck;
    property OnDrawItem: TSCDrawListItemEvent read FOnDrawItem write FOnDrawItem;
    property OnHideEditor: TSCListItemEvent read FOnHideEditor write FOnHideEditor;
    property OnHottrack: TSCListItemEvent read FOnHottrack write FOnHottrack;
    property OnMeasureItem: TSCMeasureListItemEvent read FOnMeasureItem write FOnMeasureItem;
    property OnPaintHint: TSCListPaintHint read FOnPaintHint write FOnPaintHint;
    property OnPrepareEditor: TSCPrepareEditorEvent read FOnPrepareEditor write FOnPrepareEditor;
    property OnShowEditor: TSCShowEditorEvent read FOnShowEditor write FOnShowEditor;
    property OnShowItemHint: TSCListHintEvent read FOnShowItemHint write FOnShowItemHint;
    property OnValidateEditor: TSCValidateEditorEvent read FOnValidateEditor write FOnValidateEditor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  IsEditing: Boolean;
    procedure ShowEditor;
    procedure HideEditor;
    procedure PostEditor;

    procedure BeginItemUpdate;
    procedure EndItemUpdate;
    function  InItemUpdate: Boolean;

    procedure Clear;
    function  ItemRect(Index: Integer; InView: Boolean): TRect;
    function  ItemAtPos(X, Y: Integer; InMouseMove: Boolean = False): Integer;
    function  ItemInView(Index: Integer; PartitialAllowed: Boolean = True): Boolean;
    function  FindItem(const S: String; StartPos, EndPos: Integer): Integer;
    function  CompletedItem(const S: String; CaseSensitive: Boolean): Integer;
    function  LastVisibleItem(PartitialAllowed: Boolean = True): Integer;

    property Color default clWindow;
    property ParentColor default False;
    property TabStop default True;
  end;

  TSCSimpleListboxClass = class of TSCCustomSimpleListbox;

  TSCSimpleListbox = class(TSCCustomSimpleListbox)
  public
    property Count;
    property Objects;
    property Checked;
    property State;
    property EditText;
    property HotIndex;
    property IndentLevel;
    property ItemEnabled;
    property ItemImage;
    property ScrollHeight;
    property ScrollWidth;
    property Strings;
    property ItemIndex;
    property Selected;
    property SelectedValue;
    property TopIndex;
  published
    property Align;
    property AllowGrayed;
    property AllowEdit;
    property AllowMouseEdit;
    property Anchors;
    property BiDiMode;
    property BorderProps;
    property CenterImages;
    property Color;
    property Colors;
    property Columns;
    property Constraints;
    property ContinuousKeySearch;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndEllipsis;
    property ExtendedSelect;
    property Flat;
    property Font;
    property HideFocusRect;
    property HideSelection;
    property Hottrack;
    property HottrackColor;
    property HottrackUnderline;
    property Images;
    property ImeMode;
    property ImeName;
    property Indent;
    property ItemHeight;
    property Items;
    property Layout;
    property LineSelect;
    property MultiSelect;
    property Office12Style;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Revertable;
    property Scrollbars;
    property ShowCheckboxes;
    property ShowItemHints;
    property ShowItemImages;
    property ShowItemOnSelect;
    property ShowHint;
    property ShowSizeGrip;
    property ShowStatusbar;
    property Sorted;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
    property TabOrder;
    property TabStop;
    property Transparent;
    property Values;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnClickCheck;
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
    property OnHideEditor;
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
    property OnPrepareEditor;
    property OnResize;
    property OnShowEditor;
    property OnShowItemHint;
    property OnStartDock;
    property OnStartDrag;
    property OnValidateEditor;
  end;

  TSCCustomListboxEx = class;

  TSCListboxExItem = class(TCollectionItem)
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
    function  GetListboxEx: TSCCustomListboxEx;
    function  GetImages: TCustomImageList;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;

    property ListboxEx: TSCCustomListboxEx read GetListboxEx;
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

  TSCListboxExItems = class(TCollection)
  private
    FOwner: TSCCustomListboxEx;
    function  GetItem(Index: Integer): TSCListboxExItem;
    procedure SetItem(Index: Integer; Value: TSCListboxExItem);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TSCCustomListboxEx); virtual;
    function Add: TSCListboxExItem;
    function IndexOf(const S: String; CaseSensitive: Boolean = False): Integer;
    function IndexOfValue(const S: String; CaseSensitive: Boolean = False): Integer;
    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomListboxEx read FOwner;
    {$ENDIF}
    property Items[Index: Integer]: TSCListboxExItem read GetItem write SetItem; default;
  end;

  TSCCustomListboxEx = class(TSCCustomSimpleListbox)
  private
    FInExChange: Integer;
    FItemsEx: TSCListboxExItems;
    procedure SetItemsEx(Value: TSCListboxExItems);

    procedure ExItemChanged(Item: TSCListboxExItem);
    procedure ExItemsChanged;
  protected
    procedure DoInternalDataChanged(Index: Integer); override;
    procedure DoInternalItemsChanged; override;

    function  GetSelectedValue: String; override;

    procedure DoExItemChanged(Item: TSCListboxExItem); dynamic;
    procedure DoExItemsChanged; dynamic;

    property ItemsEx: TSCListboxExItems read FItemsEx write SetItemsEx;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCListboxEx = class(TSCCustomListboxEx)
  public
    property Count;
    property State;
    property EditText;
    property HotIndex;
    property ScrollHeight;
    property ScrollWidth;
    property ItemIndex;
    property Selected;
    property SelectedValue;
    property TopIndex;
  published
    property Align;
    property AllowGrayed;
    property AllowEdit;
    property AllowMouseEdit;
    property Anchors;
    property BiDiMode;
    property BorderProps;
    property CenterImages;
    property Color;
    property Colors;
    property Columns;
    property Constraints;
    property ContinuousKeySearch;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndEllipsis;
    property ExtendedSelect;
    property Flat;
    property Font;
    property HideFocusRect;
    property HideSelection;
    property Hottrack;
    property HottrackColor;
    property HottrackUnderline;
    property Images;
    property ImeMode;
    property ImeName;
    property Indent;
    property ItemHeight;
    property ItemsEx;
    property Layout;
    property LineSelect;
    property MultiSelect;
    property Office12Style;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Revertable;
    property Scrollbars;
    property ShowCheckboxes;
    property ShowItemHints;
    property ShowItemImages;
    property ShowItemOnSelect;
    property ShowHint;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
    property TabOrder;
    property TabStop;
    property Transparent;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnClickCheck;
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
    property OnHideEditor;
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
    property OnPrepareEditor;
    property OnResize;
    property OnShowEditor;
    property OnShowItemHint;
    property OnStartDock;
    property OnStartDrag;
    property OnValidateEditor;
  end;

function StateToData(St: TSCCheckState): Integer;
function DataToState(Dt: Integer): TSCCheckState;

implementation

const
  SC_LISTSCROLL_TIMERID = 4334;
  SC_LIST_CLICK_TIMERID = 7037;

type
  TSCFakedControl = class(TSCCustomControl);
  
function StateToData(St: TSCCheckState): Integer;
begin
  Result := 0;
  if St = sccbChecked then
    Result := 1
  else
  if St = sccbGrayed then
    Result := 2;
end;

function DataToState(Dt: Integer): TSCCheckState;
begin
  Result := sccbUnchecked;
  if Dt = 1 then
    Result := sccbChecked
  else
  if Dt = 2 then
    Result := sccbGrayed;
end;

type
  TSCListboxEdit = class(TSCCustomEdit);
  TSCListStrings = class(TSCStringList);

{ TSCListBorderProps }

constructor TSCListBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccb3DLowered;
end;

{ TSCListCustomColors }

procedure TSCListCustomColors.Assign(Source: TPersistent);
begin
  if Source is TSCListCustomColors then
  begin
    with TSCListCustomColors(Source) do
    begin
      Self.AlternateColor := AlternateColor;
      Self.DisabledColor := DisabledColor;
      Self.DisabledTextColor := DisabledTextColor;
      Self.HideSelectionBorderColor := HideSelectionBorderColor;
      Self.HideSelectionColor := HideSelectionColor;
      Self.HideSelectionTextColor := HideSelectionTextColor;
      Self.HighlightBorderColor := HighlightBorderColor;
      Self.HighlightColor := HighlightColor;
      Self.HighlightTextColor := HighlightTextColor;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCListCustomColors.Create(AOwner: TSCCustomSimpleListbox);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCListCustomColors.GetDisabledColor: TColor;
begin
  Result := clBtnFace;
  if FOwner <> nil then
    Result := FOwner.DisabledColor;
end;

function TSCListCustomColors.GetDisabledTextColor: TColor;
begin
  Result := clGrayText;
  if FOwner <> nil then
    Result := FOwner.DisabledTextColor;
end;

function TSCListCustomColors.GetHideSelectionBorderColor: TColor;
begin
  Result := clNone;
  if FOwner <> nil then
    Result := FOwner.HideSelectionBorderColor;
end;

function TSCListCustomColors.GetHideSelectionColor: TColor;
begin
  Result := clBtnFace;
  if FOwner <> nil then
    Result := FOwner.HideSelectionColor;
end;

function TSCListCustomColors.GetHideSelectionTextColor: TColor;
begin
  Result := clBtnText;
  if FOwner <> nil then
    Result := FOwner.HideSelectionTextColor;
end;

function TSCListCustomColors.GetHighlightBorderColor: TColor;
begin
  Result := clNone;
  if FOwner <> nil then
    Result := FOwner.HighlightBorderColor;
end;

function TSCListCustomColors.GetHighlightColor: TColor;
begin
  Result := clHighlight;
  if FOwner <> nil then
    Result := FOwner.HighlightColor;
end;

function TSCListCustomColors.GetHighlightTextColor: TColor;
begin
  Result := clHighlightText;
  if FOwner <> nil then
    Result := FOwner.HighlightTextColor;
end;

function TSCListCustomColors.GetAlternateColor: TColor;
begin
  Result := clNone;
  if FOwner <> nil then
    Result := FOwner.AlternateColor;
end;

function TSCListCustomColors.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCListCustomColors.SetDisabledColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.DisabledColor := Value;
end;

procedure TSCListCustomColors.SetDisabledTextColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.DisabledTextColor := Value;
end;

procedure TSCListCustomColors.SetHideSelectionBorderColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.HideSelectionBorderColor := Value;
end;

procedure TSCListCustomColors.SetHideSelectionColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.HideSelectionColor := Value;
end;

procedure TSCListCustomColors.SetHideSelectionTextColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.HideSelectionTextColor := Value;
end;

procedure TSCListCustomColors.SetHighlightBorderColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.HighlightBorderColor := Value;
end;

procedure TSCListCustomColors.SetHighlightColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.HighlightColor := Value;
end;

procedure TSCListCustomColors.SetHighlightTextColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.HighlightTextColor := Value;
end;

procedure TSCListCustomColors.SetAlternateColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.AlternateColor := Value;
end;

{ TSCListScrollbars }

procedure TSCListScrollbars.Assign(Source: TPersistent);
begin
  if Source is TSCListScrollbars then
    with TSCListScrollbars(Source) do
    begin
      Self.ShowHorizontal := ShowHorizontal;
      Self.ShowVertical := ShowVertical;
    end;

  inherited Assign(Source);
end;

function TSCListScrollbars.GetShowHorizontal: Boolean;
begin
  Result := True;
  if Owner is TSCCustomSimpleListbox then
    Result := TSCCustomSimpleListbox(Owner).ScrollbarHorizontal;
end;

function TSCListScrollbars.GetShowVertical: Boolean;
begin
  Result := True;
  if Owner is TSCCustomSimpleListbox then
    Result := TSCCustomSimpleListbox(Owner).ScrollbarVertical;
end;

procedure TSCListScrollbars.SetShowHorizontal(Value: Boolean);
begin
  if Owner is TSCCustomSimpleListbox then
    TSCCustomSimpleListbox(Owner).ScrollbarHorizontal := Value;
end;

procedure TSCListScrollbars.SetShowVertical(Value: Boolean);
begin
  if Owner is TSCCustomSimpleListbox then
    TSCCustomSimpleListbox(Owner).ScrollbarVertical := Value;
end;

{ TSCCustomSimpleListbox }

procedure TSCCustomSimpleListbox.CMFontChanged(var Message: TMessage);
var
  W, H: LongInt;
begin
  inherited;
  Canvas.Font.Assign(Self.Font);
  FDefaultHeight := Canvas.TextHeight('Rq') + 2;
  UpdateBounds(W, H);

  UpdateHotTrack(False);

  Invalidate;
end;

constructor TSCCustomSimpleListbox.Create(AOwner: TComponent);
begin
  FScrolling   := False;
  FScrollTimer := -1;

  FClickedIndex := -1;
  FClickTimer   := -1;

  inherited Create(AOwner);
  SetBounds(Left, Top, 121, 97);
  ParentColor := False;
  Color := clWindow;
  Border := sccb3DLowered;
  DoubleBuffered := True;
  TabStop := True;

  FItems := CreateItems;

  FOffice12Style := False;
  FMouseDownIndex := -1;
  FMouseDownShift := [];
  FHotIndex := -1;
  FInplaceEditor := nil;
  FInplaceEditorClass := TSCCustomEdit;
  FHintIndex := -1;

  FAllowMouseEdit := True;
  FAlternateColor := clNone;
  FDefaultHeight := -1;
  FDisabledColor := clBtnFace;
  FDisabledTextColor := clGrayText;
  FExtendedSelect := True;
  FFlat := scsfFlat;
  FHideSelection := False;
  FHideSelectionBorderColor := clNone;
  FHideSelectionColor := clBtnFace;
  FHideSelectionTextColor := clBtnText;
  FHighlightBorderColor := clNone;
  FHighlightColor := clHighlight;
  FHighlightTextColor := clHighlightText;
  FHottrack := True;
  FHottrackColor := clHighlight;
  FItemHeight := -1;
  FItemIndex := -1;
  FLayout := sclaTop;
  FLineSelect := True;
  FMultiSelect := False;
  FScrollbarHorizontal := True;
  FScrollbarVertical := True;
  FTopIndex := 0;
  FShowItemOnSelect := True;

  FColors := GetListColorsClass.Create(Self);

  FValues := TStringList.Create;
  TStringList(FValues).OnChange := ValuesChanged;
end;

procedure TSCCustomSimpleListbox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    Style := Style and not WS_BORDER or WS_CLIPSIBLINGS or
      WS_CLIPCHILDREN;
  end;
end;

procedure TSCCustomSimpleListbox.CreateWnd;
begin
  Inc(FCreatingWnd);
  try
    inherited CreateWnd;
  finally
    Dec(FCreatingWnd);
  end;

  UpdateScrollbars(True, True);
end;

destructor TSCCustomSimpleListbox.Destroy;
begin
  Destroying;

  FreeAndNil(FColors); 

  if FInplaceEditor <> nil then
    FreeAndNil(FInplaceEditor);

  TSCListStrings(FItems).OnEndUpdate := nil;
  TSCListStrings(FItems).OnChange := nil;
  FreeAndNil(FItems);

  TStringList(FValues).OnChange := nil;
  FreeAndNil(FValues);

  HideHintWindow;
  StopScrolling;
  inherited Destroy;
end;

procedure TSCCustomSimpleListbox.DoDrawCheckMark(C: TCanvas; R: TRect; Cl: TColor);
var
  L, T, I: Integer;
  Pts: array[0..2] of TPoint;
begin
  if (C = nil) or IsRectEmpty(R) then
    Exit;

  with C.Pen do
  begin
    Style := psSolid;
    Mode  := pmCopy;
    Width := 1;
    Color := Cl;
  end;

  L := R.Left + (R.Right - R.Left - 7) div 2;
  if L < R.Left then L := R.Left;

  T := R.Top + (R.Bottom - R.Top - 7) div 2;
  if T < R.Top then T := R.Top;

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

procedure TSCCustomSimpleListbox.DoDrawCheckbox(C: TCanvas; Index: Integer;
  CR, R: TRect; State: TSCSimpleListState);
var
  IsFlat, IsEnabled: Boolean;
begin
  if not FShowCheckboxes and (C = nil) or IsRectEmpty(R) or
    (Index < 0) or (Index > FItems.Count - 1) then
    Exit;

  Inc(R.Left, 2);
  R.Right := R.Left + 13;

  Inc(R.Top, 1);
  R.Bottom := R.Top + 13;

  if (R.Right <= CR.Left) or (R.Left >= CR.Right) then
    Exit;

  IsEnabled := not (sclsDisabled in State);

  IsFlat := (FFlat = scsfFlatEx) or ((FFlat = scsfFlat) and
    (IsDesigning or not IsEnabled or IsEditing or
    not (FHotTrack and (FHotIndex = Index))));

  if IsFlat then
  begin
    InflateRect(R, -1, -1);
    if IsRectEmpty(R) then
      Exit;
  end;

  with C do
  begin
    Brush.Style := bsSolid;

    Brush.Color := clWindow;
    if not IsEnabled then
      Brush.Color := clBtnFace;

    FillRect(R);
    if IsEnabled and (sclsGrayed in State) then
      scFillWithColors(C, R, clWindow, clBtnFace);
  end;

  if not IsEnabled then
  begin
    if State*[sclsChecked, sclsGrayed] <> [] then
      DoDrawCheckMark(C, R, clBtnShadow);
  end else
  if sclsChecked in State then
    DoDrawCheckMark(C, R, clWindowText)
  else
  if sclsGrayed in State then
    DoDrawCheckMark(C, R, clBtnShadow);

  if IsFlat then
    scFrame3D(C, R, clBtnShadow, clBtnShadow, 1, 0)
  else  
  if FFlat = scsfDoubleFlat then
  begin
    scFrame3D(C, R, clWindowFrame, clWindowFrame, 1, 0);
    scFrame3D(C, R, clWindowFrame, clWindowFrame, 1, 0);
  end else
  begin
    scFrame3D(C, R, clBtnShadow, clBtnHighlight, 1, 0);
    scFrame3D(C, R, cl3DDkShadow, clBtnFace, 1, 0);
  end;
end;
  
procedure TSCCustomSimpleListbox.DoDrawItem(C: TCanvas; Index: Integer;
  CR, R: TRect; State: TSCSimpleListState);
var
  R2: TRect;
  S: String;
  F: LongInt;
  Img, T: Integer;
  Cl, FCl, BCl: TColor;
begin
  if (C = nil) or IsRectEmpty(R) or IsRectEmpty(CR) or
    (Index < 0) or (Index > Count-1) then
    Exit;

  if FShowItemImages and (Images <> nil) and (Images.Width > 0) then
  begin
    R2 := R;
    R2.Right := R2.Left + Images.Width + 2;

    R.Left := R2.Right;
    Img := ItemImage[Index];

    if IsValidImage(Img) and not IsRectEmpty(R2) and
      (R2.Right > CR.Left) and (R2.Left < CR.Right) then
    begin
      T := R2.Top;
      if FCenterImages then
        T := R2.Top + ((R2.Bottom - R2.Top - Images.Height) div 2);

      Images.Draw(C, R2.Left + 1, T, Img, Enabled and not (sclsDisabled in State));
    end;
  end;

  FCl := clNone;
  BCl := clNone;
  Cl  := Self.Color;

  with C do
  begin
    Brush.Style := bsClear;
    Font.Assign(Self.Font);

    if sclsDisabled in State then
    begin
      Brush.Style := bsSolid;

      Cl  := FDisabledColor;
      FCl := FDisabledTextColor;
      
      if Cl <> clNone then
      begin
        Brush.Color := Cl;
        FillRect(R);
      end;
    end else
    if sclsSelected in State then
    begin
      Brush.Style := bsSolid;

      Cl  := FHighlightColor;
      FCl := FHighlightTextColor;
      BCl := FHighlightBorderColor;

      if not Focused then
      begin
        Cl  := clNone;
        FCl := clNone;
        BCl := clNone;

        if not FHideSelection then
        begin
          Cl  := FHideSelectionColor;
          FCl := FHideSelectionTextColor;
          BCl := FHideSelectionBorderColor;
        end else
        if FHottrack and (sclsHottrack in State) and not IsDesigning then
        begin
          FCl := FHottrackColor;
          if FHottrackUnderline then
            Font.Style := Font.Style + [fsUnderline];
        end;
      end;

      if Cl <> clNone then
      begin
        Brush.Color := Cl;
        FillRect(R);

        if FOffice12Style and (not MultiSelect or (Index = ItemIndex)) then
          DrawOffice12Face(C, R, Cl, True, True);
      end;
    end else
    if (sclsHottrack in State) and not IsDesigning then
    begin
      FCl := FHottrackColor;
      if FHottrackUnderline then
        Font.Style := Font.Style + [fsUnderline];
    end;

    S := FItems.Strings[Index];

    if FCl <> clNone then
      Font.Color := FCl;

    if S <> '' then
    begin
      R2 := R;
      Inc(R2.Left, 2);

      F := DT_LEFT or DT_TOP or DT_NOPREFIX or DT_SINGLELINE;

      if FEndEllipsis then
        F := F or DT_END_ELLIPSIS;

      case FLayout of
        sclaTop:
        begin
          Inc(R2.Top);
        end;
        sclaMiddle:
        begin
          F := F or DT_VCENTER;
          InflateRect(R2, 0, -1);
        end;
        sclaBottom:
        begin
          Dec(R2.Bottom);
          F := F or DT_BOTTOM;
        end;
      end;

      Brush.Style := bsClear;  
      DrawText(C.Handle, PChar(S), Length(S), R2, F);
    end;  

    if BCl <> clNone then
      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode := pmCopy;
        Pen.Width := 1;
        Pen.Color := BCl;

        Brush.Style := bsClear;
        Rectangle(R.Left, R.Top, R.Right, R.Bottom);
        Brush.Style := bsSolid;
      end;

    if not IsDesigning and not FOffice12Style and
      not FHideFocusRect and (sclsFocused in State) and Focused then
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      scDrawFocusRect(C, R, Cl);
    end;
  end;
end;

procedure TSCCustomSimpleListbox.UpdateItem(C: TCanvas; Index: Integer);
var
  R, CR: TRect;
  SaveIndex: Integer;
  Rgn, SaveRgn: HRgn;
begin
  if (C = nil) or not HandleAllocated or
    (Index < 0) or (Index > FItems.Count-1) then
    Exit;

  CR := GetClientRect;
  if IsRectEmpty(CR) then
    Exit;

  R := ItemRect(Index, True);
  if not IsRectEmpty(R) then
  begin
    IntersectRect(R, R, CR);

    if not IsRectEmpty(R) then
    begin
      SaveRgn := CreateRectRgn(0,0,0,0);
      GetClipRgn(C.Handle, SaveRgn);
      
      Rgn := CreateRectRgnIndirect(R);
      try
        SaveIndex := ExtSelectClipRgn(C.Handle, Rgn, RGN_COPY);
        DeleteObject(Rgn);

        if SaveIndex <> NULLREGION then
        begin
          DoPaintBack(C);
          DoPaintItem(C, Index, CR, R);
        end;
      finally
        SelectClipRgn(C.Handle, SaveRgn);
        DeleteObject(SaveRgn);
      end;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.DoPaintBack(C: TCanvas);
var
  R: TRect;
begin
  if C = nil then
    Exit;

  if Transparent then
    PaintParentOn(C)
  else begin
    R := GetClientRect;
    if not IsRectEmpty(R) then
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Self.Color;

        FillRect(R);
      end;
  end;
end;

procedure TSCCustomSimpleListbox.BeforePaintItem(C: TCanvas; Index: Integer;
  ClientR, R: TRect; State: TSCSimpleListState);
begin
  //
end;

procedure TSCCustomSimpleListbox.AfterPaintItem(C: TCanvas; Index: Integer;
  ClientR, R: TRect; State: TSCSimpleListState);
begin
  //
end;

procedure TSCCustomSimpleListbox.DoPaintItem(C: TCanvas; Index: Integer;
  ClientR, R: TRect);
var
  R2: TRect;
  Done: Boolean;
  St: TSCCheckState;
  Item: PSCStringItem;
  Editing: Boolean;
  CbxW, W, LOffset: Integer;
  ItemState: TSCSimpleListState;
begin
  if (C = nil) or IsRectEmpty(ClientR) or IsRectEmpty(R) or
    (Index < 0) or (Index > FItems.Count-1) then
    Exit;

  W := ClientR.Right - ClientR.Left;
  if W < 0 then W := 0;

  if FColumns > 0 then
  begin
    W := W div FColumns;

    if R.Right - R.Left > W then
      R.Right := R.Left + W;
  end;

  if FLineSelect or FEndEllipsis then
  begin
    if FColumns < 1 then
    begin
      if (R.Right <> ClientR.Right) and
        (FLineSelect or (FEndEllipsis and (R.Right > ClientR.Right))) then
        R.Right := ClientR.Right;
    end else
    if R.Right - R.Left < W then
      R.Right := R.Left + W;
  end;

  IntersectRect(R2, R, ClientR);
  if IsRectEmpty(R2) then
    Exit;

  if FLineSelect or FEndEllipsis then
  begin
    if FColumns < 1 then
    begin
      if (R2.Right <> ClientR.Right) and
        (FLineSelect or (FEndEllipsis and (R2.Right > ClientR.Right))) then
        R2.Right := ClientR.Right;

      if R2.Left > ClientR.Left then
        R2.Left := ClientR.Left;
    end else
    if R2.Right - R2.Left < W then
      R2.Right := R2.Left + W;
  end;

  Item := TSCListStrings(FItems).List[Index];

  ItemState := [];
  if not Enabled or (Item^.FData[5] <> 0) then
    ItemState := ItemState + [sclsDisabled];

  if FHotTrack and (Index = FHotIndex) then
    ItemState := ItemState + [sclsHottrack];

  if FItemIndex = Index then
    ItemState := ItemState + [sclsFocused];

  if (FMultiSelect and Boolean(Item^.FData[2])) or
    ((FItemIndex = Index) and not FMultiSelect) then
    ItemState := ItemState + [sclsSelected];

  if (IsEditing or InEditShow) and (Index = FItemIndex) then
    ItemState := ItemState + [sclsEditing];

  Editing := sclsEditing in ItemState;

  BeforePaintItem(C, Index, ClientR, R, ItemState);
  try
    if IntersectClipRect(C.Handle, R2.Left,
      R2.Top, R2.Right, R2.Bottom) = NULLREGION then
      Exit;

    St := DataToState(Item^.FData[4]);
    if St = sccbChecked then
      ItemState := ItemState + [sclsChecked]
    else
    if St = sccbGrayed then
      ItemState := ItemState + [sclsGrayed];

    LOffset := 0;
    if FShowCheckboxes then
    begin
      LOffset := GetCheckWidth;
      Inc(R.Left, LOffset);
    end;

    Done := False;
    if not Editing and Assigned(FOnDrawItem) then
      FOnDrawItem(Self, C, Index, R, ItemState, 0, Done);

    if not (Done or Editing) and not IsRectEmpty(R) and
      (R.Right > ClientR.Left) and (R.Left < ClientR.Right) then
      DoDrawItem(C, Index, ClientR, R, ItemState);

    if FShowCheckboxes then
    begin
      Dec(R.Left, LOffset);

      CbxW := LOffset;
      if CbxW < 0 then CbxW := 0;

      if (R.Left < ClientR.Right) and (CbxW + R.Left > ClientR.Left) then
        DoDrawCheckbox(C, Index, ClientR, R, ItemState);
    end;
  finally
    SelectClipRgn(C.Handle, 0);
    AfterPaintItem(C, Index, ClientR, R, ItemState);
  end;
end;

procedure TSCCustomSimpleListbox.DoScrollBoundsChanged;
begin
  //
end;

function TSCCustomSimpleListbox.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomSimpleListbox.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TSCCustomSimpleListbox.GetItemHeight: Integer;
begin
  Result := FItemHeight;

  if Result = -1 then
  begin
    if FDefaultHeight = -1 then
      FDefaultHeight := Canvas.TextHeight('Wg') + 2;

    Result := FDefaultHeight;
  end;
end;

procedure TSCCustomSimpleListbox.GetItemBounds(Index: Integer;
  var AWidth, AHeight, AIndent: Integer);
var
  ImgW: Integer;
  Item: PSCStringItem;
begin
  AWidth  := 0;
  AHeight := 0;
  AIndent := 0;

  if (Index > -1) and (Index < FItems.Count) then
  begin
    Item := TSCListStrings(FItems).List[Index];

    AIndent := Item^.FData[6];
    if AIndent < 0 then AIndent := 0;

    if FColumns > 0 then
    begin
      AWidth  := ClientWidth div FColumns;
      AHeight := GetItemHeight;
    end else
    begin
      Canvas.Font.Assign(Self.Font);

      AWidth  := ClientWidth;
      AHeight := GetItemHeight;

      AWidth := Canvas.TextWidth(Item^.FString);
      if AWidth > 0 then
      begin
        ImgW := 0;
        if FShowItemImages and (Images <> nil) then
        begin
          ImgW := Images.Width;
          if ImgW > 0 then Inc(ImgW, 2);
        end;

        Inc(AWidth, 6 + ImgW);
      end;

      MeasureItem(Index, AWidth, AHeight, AIndent);
    end;

    if AWidth  < 0 then AWidth  := 0;
    if AHeight < 0 then AHeight := 0;
    if AIndent < 0 then AIndent := 0;

    Item^.FData[0] := AHeight;
    Item^.FData[1] := AWidth;
    Item^.FData[6] := AIndent;

    DoInternalDataChanged(Index);
  end;
end;

function TSCCustomSimpleListbox.GetHorzScrollPos: Integer;
begin
  Result := FHorizontalPos;
  VerifyHorizontalPos(Result);
end;

function TSCCustomSimpleListbox.GetObject(Index: Integer): TObject;
begin
  Result := FItems.Objects[Index];
end;

function TSCCustomSimpleListbox.GetPageDownIndex(Index: Integer): Integer;
var
  R, CR: TRect;
  Item: PSCStringItem;
  I, L, Cnt, Res: Integer;
begin
  Result := -1;
  if FItems.Count = 0 then
    Exit;

  Result := Index;
  if (Result >= FItems.Count-1) and (FRevertable and not FMultiSelect) then
  begin
    Result := 0;
    VerifyIndex(Result);

    Exit;
  end;

  VerifyIndex(Result);
  if Result < 0 then
    Result := 0;

  if Result = FItems.Count-1 then
    Exit;

  CR := GetClientRect;
  if IsRectEmpty(CR) then
    Exit;

  if FColumns > 0 then
  begin
    Cnt := GetColumnHeight;
    if Cnt < 0 then
      Exit;

    if Cnt = 0 then
      Cnt := 1;

    L := Index div Cnt;
    if FColumns = 1 then
      Inc(L)
    else
      Inc(L, FColumns - 1);

    I := Index mod Cnt;

    Result := I + (L*Cnt) - 1;

    if Result > FItems.Count - 1 then
      Result := FItems.Count - 1;

    if Result < 0 then
      Result := 0;
  end else
  begin
    R := CR;
    R.Bottom := R.Top;

    Res := Result;
    for I := Res to FItems.Count-1 do
    begin
      Item := TSCListStrings(FItems).List[I];
      if Item^.FData[0] < 1 then
        Continue;

      R.Bottom := R.Top + Item^.FData[0];

      if R.Bottom > CR.Bottom then
      begin
        Result := I - 1;
        if Result = FItemIndex then
          Inc(Result);

        VerifyIndex(Result);
        Exit;
      end;

      Result := I;
      R.Top := R.Bottom;
    end;

    Result := FItems.Count-1;
  end;
end;

function TSCCustomSimpleListbox.GetPageUpIndex(Index: Integer): Integer;
var
  R, CR: TRect;
  Item: PSCStringItem;
  I, L, Cnt, Res: Integer;
begin
  Result := -1;
  if FItems.Count = 0 then
    Exit;

  Result := Index;

  if (Result <= 0) and (FRevertable and not FMultiSelect) then
  begin
    Result := FItems.Count-1;
    VerifyIndex(Result);

    Exit;
  end;

  VerifyIndex(Result);
  if Result < 0 then
    Result := 0;

  if Result = 0 then
    Exit;

  CR := GetClientRect;
  if IsRectEmpty(CR) then
    Exit;

  if FColumns > 0 then
  begin
    Cnt := GetColumnHeight;
    if Cnt < 0 then
      Exit;

    if Cnt = 0 then
      Cnt := 1;

    L := Index div Cnt;
    if FColumns = 1 then
      Dec(L)
    else
      Dec(L, FColumns - 1);

    if L < 0 then
    begin
      Result := 0;
      if FRevertable and not FMultiSelect then
      begin
        Result := FItems.Count-1;
        VerifyIndex(Result);
      end;

      Exit;
    end;

    I := Index mod Cnt;

    Result := I + (L*Cnt) + 1;

    if Result > FItems.Count - 1 then
      Result := FItems.Count - 1;

    if Result < 0 then
      Result := 0;
  end else
  begin
    R := CR;
    R.Top := R.Bottom;

    Res := Result;
    for I := Res downto 0 do
    begin
      Item := TSCListStrings(FItems).List[I];
      if Item^.FData[0] < 1 then
        Continue;

      R.Top := R.Bottom - Item^.FData[0];

      if R.Top < CR.Top then
      begin
        Result := I + 1;
        if Result = FItemIndex then
          Dec(Result);

        VerifyIndex(Result);
        Exit;
      end;

      Result := I;
      R.Bottom := R.Top;
    end;

    Result := 0;
  end;
end;

function TSCCustomSimpleListbox.GetSelected(Index: Integer): Boolean;
begin
  Result := False;
  if (Index > -1) and (Index < FItems.Count) then
    Result := Boolean(TSCListStrings(FItems).Data[Index, 2]);
end;

function TSCCustomSimpleListbox.GetString(Index: Integer): String;
begin
  Result := FItems.Strings[Index];
end;

function TSCCustomSimpleListbox.CanShowHorzScrollBar: Boolean;
var
  CbxW: Integer;
begin
  if FColumns > 0 then
    Result := (FItems.Count > 0) and (GetColumnCount > FColumns)
  else begin
    Result := False;
    
    if not FEndEllipsis then
    begin
      CbxW := 0;
      if FShowCheckboxes then
      begin
        CbxW := GetCheckWidth;
        if CbxW < 0 then CbxW := 0;
      end;

      Result := (FItems.Count > 0) and (FScrollWidth + CbxW > ClientWidth);
    end;
  end;
end;

function TSCCustomSimpleListbox.IsVertScrollBarVisible: Boolean;
begin
  Result := FScrollbarVertical and inherited IsVertScrollBarVisible;
end;

function TSCCustomSimpleListbox.IsHorzScrollBarVisible: Boolean;
begin
  Result := FScrollbarHorizontal and inherited IsHorzScrollBarVisible;
end;

function TSCCustomSimpleListbox.CanShowVertScrollBar: Boolean;
begin
  Result := (FItems.Count > 1) and (FColumns < 1) and
    (FScrollHeight > ClientHeight);
end;

function TSCCustomSimpleListbox.ItemRect(Index: Integer; InView: Boolean): TRect;
var
  CR: TRect;
  Item: PSCStringItem;
  I, J, CH, W, H,
  L, T, Cnt, TopIndx: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (Index < 0) or (Index > FItems.Count-1) then
    Exit;

  CR := GetClientRect;
  
  if FColumns > 0 then
  begin
    CH := CR.Bottom - CR.Top;
    if CH < 1 then
      CH := 1;

    W := (CR.Right - CR.Left) div FColumns;
    if W < 1 then
      Exit;

    L := FHorizontalPos;
    VerifyHorizontalPos(L);

    if L < 0 then L := 0;

    H := GetItemHeight;
    if H < 1 then
      Exit;

    Cnt := CH div H;
    if Cnt = 0 then
      Cnt := 1;

    if InView then
    begin
      I := L*Cnt;
      
      J := ((L + FColumns)*Cnt) - 1;
      if J > FItems.Count-1 then
        J := FItems.Count-1;

      if (Index >= I) and (Index <= J) then
      begin
        Result := CR;
        Result.Right  := Result.Left + W;
        Result.Bottom := Result.Top  + H;

        OffsetRect(Result, W*((Index div Cnt) - L), H*(Index mod Cnt));
      end;
    end else
    begin
      Result := CR;
      Result.Right  := Result.Left + W;
      Result.Bottom := Result.Top  + H;

      OffsetRect(Result, W*((Index div Cnt) - L), H*(Index mod Cnt));
    end;
  end else
  begin
    TopIndx := FTopIndex;

    VerifyIndex(TopIndx);
    if TopIndx < 0 then
      TopIndx := 0;

    T  := CR.Top;

    if InView then
    begin
      T := CR.Top;

      for I := TopIndx to FItems.Count-1 do
      begin
        Item := TSCListStrings(FItems).List[I];

        H := Item^.FData[0];
        if H < 0 then H := 0;

        if I = Index then
        begin
          Result := Rect(CR.Left, 0, CR.Right, H);
          OffsetRect(Result, 0, T);

          Exit;
        end;

        Inc(T, H);
        if T >= CR.Bottom then
          Exit;
      end;

      Exit;
    end;

    if Index < TopIndx then
    begin
      for I := TopIndx - 1 downto 0 do
      begin
        Item := TSCListStrings(FItems).List[I];

        H := Item^.FData[0];
        if H < 0 then H := 0;

        Dec(T, H);
        if I = Index then
        begin
          Result := Rect(CR.Left, 0, CR.Right, H);
          OffsetRect(Result, 0, T);

          Exit;
        end;
      end;

      Exit;
    end;

    for I := TopIndx to FItems.Count-1 do
    begin
      Item := TSCListStrings(FItems).List[I];

      H := Item^.FData[0];
      if H < 0 then H := 0;

      if I = Index then
      begin
        Result := Rect(CR.Left, 0, CR.Right, H);
        OffsetRect(Result, 0, T);

        Exit;
      end;

      Inc(T, H);
    end;
  end;
end;

function TSCCustomSimpleListbox.ItemAtPos(X, Y: Integer; InMouseMove: Boolean): Integer;
var
  P: TPoint;
  CR, R: TRect;
  Item: PSCStringItem;
  I, J, CH, W, H, L,
  Max, Cnt, ColCnt, TopIndx: Integer;
begin
  Result := -1;
  if FItems.Count = 0 then
    Exit;

  CR := GetClientRect;

  if FColumns > 0 then
  begin
    if Y < CR.Top then
    begin
      if InMouseMove then
        Result := 0;

      Exit;
    end else
    if Y > CR.Bottom then
    begin
      Y := CR.Bottom;

      if not InMouseMove then
        Exit;
    end;

    CH := CR.Bottom - CR.Top;
    if CH < 1 then
      CH := 1;

    W := (CR.Right - CR.Left) div FColumns;
    if W < 1 then
      Exit;

    L := FHorizontalPos;
    VerifyHorizontalPos(L);

    if L < 0 then L := 0;

    H := GetItemHeight;
    if H < 1 then
      Exit;

    Cnt := CH div H;
    if Cnt = 0 then
      Cnt := 1;

    Max := H*Cnt;
    if not InMouseMove and (Y >= Max) then
    begin
      Result := -1;
      Exit;
    end;

    ColCnt := FItems.Count div Cnt;
    if FItems.Count mod Cnt = 0 then
      Dec(ColCnt);

    R := CR;
    R.Left := CR.Left - (L*W);
    R.Right := R.Left + W*(ColCnt + 1);

    if X < R.Left then
      X := R.Left;
    if X > R.Right then
      X := R.Right;

    I := L + ((X - CR.Left) div W);
    if X < 0 then
      Dec(I);

    if I < 0 then I := 0;

    J := (Y - CR.Top) div H;
    Result := J + (I*Cnt);

    if InMouseMove and (Y >= Max) then
      Result := (Cnt*(I + 1)) - 1;

    if Result > FItems.Count - 1 then
    begin
      Result := -1;
      if InMouseMove then
        Result := FItems.Count - 1;
    end;

    if Result < 0 then
      Result := -1;
  end else
  begin
    if not InMouseMove and ((Y < CR.Top) or (Y >= CR.Bottom)) then
    begin
      Result := -1;
      Exit;
    end;

    if X < CR.Left then
    begin
      X := CR.Left;
      if not InMouseMove then
        Exit;
    end else
    if X > CR.Right then
    begin
      X := CR.Right;
      if not InMouseMove then
        Exit;
    end;  

    InflateRect(CR, 1, 0);

    TopIndx := FTopIndex;

    VerifyIndex(TopIndx);
    if TopIndx < 0 then
      TopIndx := 0;

    P := Point(X, Y);

    if (TopIndx = 0) and (P.Y <= CR.Top) then
    begin
      Result := 0;
      Exit;
    end;

    R := CR;
    R.Bottom := R.Top;

    if (TopIndx > 0) and (P.Y <= CR.Top) then
    begin
      if P.Y = CR.Top then
      begin
        Result := TopIndx;
        Exit;
      end;

      for I := TopIndx - 1 downto 0 do
      begin
        Item := TSCListStrings(FItems).List[I];

        H := Item^.FData[0];
        if H < 1 then
          Continue;

        R.Top := R.Bottom - H;
        if PtInRect(R, P) then
        begin
          Result := I;
          Exit;
        end;

        R.Bottom := R.Top;
      end;

      if InMouseMove then
        Result := 0;
    end else
    begin
      for I := TopIndx to FItems.Count - 1 do
      begin
        Item := TSCListStrings(FItems).List[I];

        H := Item^.FData[0];
        if H < 1 then
          Continue;

        R.Bottom := R.Top + H;
        if PtInRect(R, P) then
        begin
          Result := I;
          Exit;
        end;

        R.Top := R.Bottom;
      end;

      if InMouseMove then
        Result := FItems.Count - 1;
    end;
  end;
end;

function TSCCustomSimpleListbox.ItemInView(Index: Integer;
  PartitialAllowed: Boolean): Boolean;
var
  R, CR: TRect;
  Item: PSCStringItem;
  I, L, Cnt, TopIndx, BtmIndx: Integer;
begin
  Result := False;
  if (Index > -1) and (Index < FItems.Count) then
  begin
    if FItems.Count < 2 then
    begin
      Result := True;
      Exit;
    end;

    if FColumns > 0 then
    begin
      L := FHorizontalPos;
      VerifyHorizontalPos(L);

      if L < 0 then L := 0;

      Cnt := GetColumnHeight;
      if Cnt < 0 then
        Exit;

      if Cnt = 0 then
        Cnt := 1;

      TopIndx := L*Cnt;

      BtmIndx := ((L + FColumns)*Cnt) - 1;
      if BtmIndx > FItems.Count-1 then
        BtmIndx := FItems.Count-1;

      Result := (Index >= TopIndx) and (Index <= BtmIndx);
    end else
    begin
      TopIndx := FTopIndex;

      VerifyIndex(TopIndx);
      if TopIndx < 0 then
        TopIndx := 0;

      if Index < TopIndx then
        Exit;

      if Index = TopIndx then
      begin
        Result := True;
        Exit;
      end;

      CR := GetClientRect;
      if not IsRectEmpty(CR) then
      begin
        R := CR;
        R.Bottom := R.Top;

        BtmIndx := TopIndx;
        for I := TopIndx to FItems.Count - 1 do
        begin
          Item := TSCListStrings(FItems).List[I];
          if Item^.FData[0] < 1 then
            Continue;

          Inc(R.Bottom, Item^.FData[0]);

          if R.Bottom >= CR.Bottom then
          begin
            BtmIndx := I;
            if not PartitialAllowed and (R.Bottom > CR.Bottom) then
            begin
              Dec(BtmIndx);
              if BtmIndx < TopIndx then
                Inc(BtmIndx);
            end;

            Break;
          end;
        end;

        if (BtmIndx = TopIndx) and (R.Bottom < CR.Bottom) then
          BtmIndx := FItems.Count - 1;

        Result := (Index >= TopIndx) and (Index <= BtmIndx);
      end;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.ItemsChanged(Sender: TObject);
var
  P: TPoint;
  TpIndx: Integer;
  W, H: LongInt;
begin
  HideEditor;
  HideHintWindow;

  if IsDestroying or not HandleAllocated or
    (Parent = nil)  or not Parent.HandleAllocated then
    Exit;

  VerifyIndex(FMouseDownIndex);
  if FMouseDownIndex = -1 then
    FMouseDownShift := [];

  VerifyIndex(FItemIndex);
  FStartIndex := FItemIndex;

  // KillClickTimer;
  FClickedIndex := FItemIndex;

  TpIndx := FTopIndex;
  VerifyTopIndex(TpIndx);

  UpdateBounds(W, H);
  UpdateHotTrack(False);

  Invalidate;

  if TpIndx <> FTopIndex then
    SetTopIndex(TpIndx);

  if GetCursorPos(P) then
  begin
    P := Self.ScreenToClient(P);
    ShowHintWindow(P);
  end;

  DoInternalItemsChanged;
end;

procedure TSCCustomSimpleListbox.KeyDown(var Key: Word; Shift: TShiftState);
var
  St: TSCCheckState;
  Item: PSCStringItem;
  StFound, ByPassKey, TriggerChange: Boolean;
  I, CheckIndx, Indx1,
  Indx2, SaveIndx, SaveStart: Integer;
  ArrowKeys: TSCArrowKeys;
  CheckList: TList;
begin
  inherited KeyDown(Key, Shift);

  HideHintWindow;

  if InItemUpdate or (FItems.Count = 0) then
    Exit;

  ArrowKeys := [VK_F2, VK_SPACE] + SCArrowKeys;

  if Key in ArrowKeys then
  begin
    TriggerChange := False;

    if Key = VK_F2 then
    begin
      if FAllowEdit and (FItems.Count > 0) and
        (FItemIndex > -1) and (FItemIndex < FItems.Count) then
      begin
        Item := TSCListStrings(FItems).List[FItemIndex];
        if Item^.FData[5] = 0 then
          ShowEditor;
      end;

      Exit;
    end;

    if Key = VK_SPACE then
    begin
      CheckIndx := -1;
      if FMultiSelect and FShowCheckboxes then
      begin
        CheckList := nil;
        try
          LockItemHint;
          FItems.BeginUpdate;
          try
            StFound := False;
            St := sccbChecked;

            for I := 0 to FItems.Count-1 do
            begin
              Item := TSCListStrings(FItems).List[I];

              if (Item^.FData[5] = 0) and Boolean(Item^.FData[2]) then
              begin
                if CheckList = nil then
                  CheckList := TList.Create;

                if not StFound then
                begin
                  if DataToState(Item^.FData[4]) = sccbChecked then
                    St := sccbUnchecked;

                  StFound := True;
                end;

                if DataToState(Item^.FData[4]) <> St then
                begin
                  CheckList.Add(Pointer(I));

                  Item^.FData[4] := StateToData(St);
                  TriggerChange := True;
                end;  
              end;
            end;
          finally
            FItems.EndUpdate;
            UnlockItemHint;
          end;

          if TriggerChange then
          begin
            Invalidate;

            for I := 0 to CheckList.Count-1 do
            begin
              CheckIndx := Integer(CheckList[I]);
              
              DoInternalDataChanged(CheckIndx);
              ClickCheck(CheckIndx);

              DoItemClick(CheckIndx);
            end;  

            Click;
          end;
        finally
          if CheckList <> nil then
            CheckList.Free;
        end;
      end else
      if (FItemIndex > -1) and (FItemIndex < FItems.Count) then
      begin
        Item := TSCListStrings(FItems).List[FItemIndex];

        LockItemHint;
        FItems.BeginUpdate;
        try
          if FShowCheckboxes and (Item^.FData[5] = 0) then
          begin
            St := SwitchState(DataToState(Item^.FData[4]));

            Item^.FData[4] := StateToData(St);
            CheckIndx := FItemIndex;

            TriggerChange := True;
          end;

          if not FExtendedSelect then
          begin
            Item^.FData[2] := Integer(not Boolean(Item^.FData[2]));
            Item^.FData[3] := Integer(False);

            TriggerChange := True;
          end;
        finally
          FItems.EndUpdate;
          UnlockItemHint;
        end;

        if not ItemInView(FItemIndex) then
        begin
          if (FStartIndex = FItemIndex) or (FItemIndex < FStartIndex) then
            SetTopIndex(FItemIndex)
          else begin
            I := GetPageUpIndex(FItemIndex);

            if (FItemIndex = FItems.Count - 1) and
              not ItemInView(FItemIndex, False) then
              Inc(I);

            SetTopIndex(I);
          end;
        end;

        Invalidate;

        if TriggerChange then
          DoInternalDataChanged(FItemIndex);

        if CheckIndx > -1 then
          ClickCheck(CheckIndx);

        DoItemClick(CheckIndx);
        Click;
      end;

      Exit;
    end;

    SaveIndx  := FItemIndex;
    SaveStart := FStartIndex;

    VerifyIndex(FStartIndex);
    VerifyIndex(FItemIndex);

    ByPassKey := False;
    if FItemIndex < 0 then
    begin
      ByPassKey := True;
      
      FItemIndex := CanChangeItemIndex(FTopIndex);
      VerifyIndex(FItemIndex);
    end;

    if FStartIndex < 0 then
      FStartIndex := FItemIndex;

    case Key of
      VK_UP, VK_LEFT:
      begin
        if (Key = VK_LEFT) and (FColumns > 0) then
        begin
          I := GetColumnHeight;

          if (I > 0) and ((FItemIndex - I >= 0) or
            (FRevertable and not FMultiSelect)) then
          begin
            Dec(FItemIndex, I);
            if FItemIndex < 0 then
              FItemIndex := CanChangeItemIndex(-1);
          end;
        end else
        if not ByPassKey then
          Dec(FItemIndex);
      end;
      VK_DOWN, VK_RIGHT:
      begin
        if (Key = VK_RIGHT) and (FColumns > 0) then
        begin
          I := GetColumnHeight;
          if (I > 0) and (FItemIndex + I > FItems.Count - 1) then
          begin
            I := FItems.Count - FItemIndex - 1;
            if FRevertable and not FMultiSelect then
              I := 1;
          end;    

          if I > 0 then
            Inc(FItemIndex, I);

          if FItemIndex > FItems.Count then
            FItemIndex := CanChangeItemIndex(FItems.Count);
        end else
        if not ByPassKey then
          Inc(FItemIndex);
      end;
      VK_PRIOR:
        FItemIndex := CanChangeItemIndex(GetPageUpIndex(FItemIndex));
      VK_NEXT:
        FItemIndex := CanChangeItemIndex(GetPageDownIndex(FItemIndex));
      VK_HOME:
        FItemIndex := CanChangeItemIndex(0);
      VK_END:
        FItemIndex := CanChangeItemIndex(FItems.Count-1);
    end;

    if (FItemIndex <> SaveIndx) and (FRevertable and not FMultiSelect) then
    begin
      if FItemIndex < 0 then
        FItemIndex := CanChangeItemIndex(FItems.Count-1)
      else
      if FItemIndex > FItems.Count-1 then
        FItemIndex := CanChangeItemIndex(0);
    end;

    VerifyIndex(FItemIndex);
    if FItemIndex < 0 then
      FItemIndex := CanChangeItemIndex(0);

    if not (FExtendedSelect and (ssShift in Shift)) then
      FStartIndex := FItemIndex;

    if FExtendedSelect then
    begin
      Indx1 := FItemIndex;
      Indx2 := FStartIndex;

      if Indx1 > Indx2 then
      begin
        I := Indx1;
        Indx1 := Indx2;
        Indx2 := I;
      end;

      LockItemHint;
      FItems.BeginUpdate;
      try
        for I := 0 to FItems.Count-1 do
        begin
          Item := TSCListStrings(FItems).List[I];
          Item^.FData[2] := Integer((I >= Indx1) and (I <= Indx2));
          Item^.FData[3] := Integer(False);
        end;
      finally
        FItems.EndUpdate;
        UnlockItemHint;
      end;
    end;

    if (SaveIndx <> FItemIndex) or (SaveStart <> FStartIndex) then
    begin
      if FColumns > 0 then
      begin
        if not ItemInView(FItemIndex, False) then
        begin
          I := GetColumnOf(FItemIndex);
          if FItemIndex > FStartIndex then
          begin
            if (FColumns > 1) and (I = GetColumnCount) then
              Inc(I);

            Dec(I, FColumns - 1);
          end;

          SetHorizontalPos(I);
        end;
      end else
      if (FItemIndex < SaveIndx) or
        ((FTopIndex > FItemIndex) and (FItemIndex = FStartIndex)) then
      begin
        if not ItemInView(FItemIndex) then
          SetTopIndex(FItemIndex);
      end else
      if (FItemIndex > SaveIndx) and
        not ItemInView(FItemIndex, False) then
      begin
        I := GetPageUpIndex(FItemIndex);

        if (FItemIndex = FItems.Count - 1) and (FItems.Count > 1) and
          not ItemInView(FItemIndex, False) then
          Inc(I);

        SetTopIndex(I);
      end;

      Invalidate;
      if SaveIndx <> FItemIndex then
      begin
        DoItemClick(FItemIndex);
        Click;
      end;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.KeyPress(var Key: Char);
begin
  ProcessSearchKey(Key);
  inherited KeyPress(Key);
end;

procedure TSCCustomSimpleListbox.Loaded;
var
  W, H: LongInt;
begin
  inherited Loaded;

  if FItems.Count > 0 then
  begin
    UpdateBounds(W, H);
    Invalidate;
  end;

  UpdateScrollbars(True, True);
end;

procedure TSCCustomSimpleListbox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  St: TSCCheckState;
  Item: PSCStringItem;
  I, Ind, Indx, OldHot, OldIndex,
  OldClick, CheckIndx, StartItem, EndItem: Integer;
begin
  KillClickTimer;
  OldClick := FClickedIndex;
  FClickedIndex := -1;

  inherited MouseDown(Button, Shift, X, Y);

  if CanFocus then
    SetFocus;

  FMouseDownIndex := -1;
  if not Focused then
  begin
    if FForceDropdownClick and (Button = mbLeft) then
    begin
      Indx := ItemAtPos(X, Y);
      FMouseDownIndex := Indx;

      if (Indx > -1) and FShowCheckboxes then
      begin
        FMouseDownIndex := -1;

        R := ItemRect(Indx, True);
        OffsetRect(R, -FHorizontalPos, 0);

        if not IsRectEmpty(R) then
        begin
          R.Right := R.Left + GetCheckWidth;

          Item := TSCListStrings(FItems).List[Indx];
          if Item <> nil then
          begin
            if FColumns < 1 then
            begin
              Ind := Indent*(Item^.FData[6]);
              if Ind < 0 then Ind := 0;

              OffsetRect(R, Ind, 0);
            end;

            if PtInRect(R, Point(X, Y)) and (Item^.FData[5] = 0) then
            begin
              FBypassEditing := True;

              LockItemHint;
              FItems.BeginUpdate;
              try
                St := SwitchState(DataToState(Item^.FData[4]));

                Item^.FData[4] := StateToData(St);
              finally
                FItems.EndUpdate;
                UnlockItemHint;
              end;

              ClickCheck(Indx);
              DoInternalDataChanged(Indx);
            end;
          end;
        end;
      end;
    end;

    Exit;
  end;

  PostEditor;
  HideHintWindow;

  OldIndex  := FItemIndex;
  OldHot    := FHotIndex;
  FHotIndex := ItemAtPos(X, Y);

  FBypassEditing := (Button <> mbLeft) or
    (Shift*[ssShift, ssAlt, ssCtrl, ssDouble] <> []);

  if Button <> mbLeft then
  begin
    Indx := FHotIndex;
    FHotIndex := OldHot;

    SetHotIndex(Indx, True);
  end else
  begin
    FSelectionClears := False;

    FMouseDownShift := Shift;
    FMouseDownIndex := FHotIndex;
    
    VerifyIndex(FMouseDownIndex);
    VerifyIndex(FItemIndex);

    if FMouseDownIndex < 0 then
    begin
      Indx := FHotIndex;
      FHotIndex := OldHot;

      SetHotIndex(Indx, True);
    end else
    begin
      CheckIndx := -1;
      
      if FShowCheckboxes then
      begin
        R := ItemRect(FMouseDownIndex, True);
        OffsetRect(R, -FHorizontalPos, 0);

        if not IsRectEmpty(R) then
        begin
          R.Right := R.Left + GetCheckWidth;

          Item := TSCListStrings(FItems).List[FMouseDownIndex];
          if Item <> nil then
          begin
            if FColumns < 1 then
            begin
              Ind := Indent*(Item^.FData[6]);
              if Ind < 0 then Ind := 0;

              OffsetRect(R, Ind, 0);
            end;

            if PtInRect(R, Point(X, Y)) and (Item^.FData[5] = 0) then
            begin
              FBypassEditing := True;

              LockItemHint;
              FItems.BeginUpdate;
              try
                St := SwitchState(DataToState(Item^.FData[4]));

                Item^.FData[4] := StateToData(St);
                CheckIndx := FMouseDownIndex;
              finally
                FItems.EndUpdate;
                UnlockItemHint;
              end;

              DoInternalDataChanged(FMouseDownIndex);
            end;
          end;
        end;
      end;

      if not FMultiSelect then
      begin
        FClickedIndex := FMouseDownIndex;

        SetItemIndex(FMouseDownIndex);
        FStartIndex := FItemIndex;
      end else
      begin
        FClickedIndex := FMouseDownIndex;
        Item := TSCListStrings(FItems).List[FMouseDownIndex];

        if not FExtendedSelect then
        begin
          FSelectionClears := False;

          SetItemIndex(FMouseDownIndex);
          FStartIndex := FItemIndex;
          
          LockItemHint;
          FItems.BeginUpdate;
          try
            Item^.FData[2] := Integer(not Boolean(Item^.FData[2]));

            for I := 0 to FItems.Count-1 do
            begin
              Item := TSCListStrings(FItems).List[I];
              Item^.FData[3] := Item^.FData[2];
            end;
          finally
            FItems.EndUpdate;
            UnlockItemHint;
          end;

          Invalidate;
          DoInternalDataChanged(FMouseDownIndex);

          Exit;
        end;

        FSelectionClears := Boolean(Item^.FData[2]);

        if ssCtrl in Shift then
        begin
          SetItemIndex(FMouseDownIndex);
          FStartIndex := FItemIndex;

          LockItemHint;
          FItems.BeginUpdate;
          try
            Item^.FData[2] := Integer(not Boolean(Item^.FData[2]));

            for I := 0 to FItems.Count-1 do
            begin
              Item := TSCListStrings(FItems).List[I];
              Item^.FData[3] := Item^.FData[2];
            end;
          finally
            FItems.EndUpdate;
            UnlockItemHint;
          end;

          DoInternalDataChanged(FMouseDownIndex);
        end else
        begin
          SetItemIndex(FMouseDownIndex);
          if not (ssShift in Shift) or
            (FStartIndex < 0) or (FStartIndex > FItems.Count-1) then
            FStartIndex := FItemIndex;

          VerifyIndex(FStartIndex);

          LockItemHint;
          FItems.BeginUpdate;
          try
            for I := 0 to FItems.Count-1 do
            begin
              Item := TSCListStrings(FItems).List[I];
              Item^.FData[2] := Integer(False);
              Item^.FData[3] := Integer(False);
            end;

            Item := TSCListStrings(FItems).List[FItemIndex];
            Item^.FData[2] := Integer(True);

            DoInternalDataChanged(FItemIndex);

            if FStartIndex <> FItemIndex then
            begin
              StartItem := FStartIndex;
              EndItem   := FItemIndex;

              if EndItem < StartItem then
              begin
                I := EndItem;
                EndItem := StartItem;
                StartItem := I;
              end;

              for I := StartItem to EndItem do
              begin
                Item := TSCListStrings(FItems).List[I];
                Item^.FData[2] := Integer(True);
              end;
            end;
          finally
            FItems.EndUpdate;
            UnlockItemHint;
          end;
        end;
      end;

      if (FColumns > 0) and not ItemInView(FItemIndex) then
      begin
        if FItemIndex < OldIndex then
          SetHorizontalPos(GetColumnOf(FItemIndex))
        else
        if FItemIndex > OldIndex then
          SetHorizontalPos(GetColumnOf(FItemIndex) - (FColumns - 1));
      end;

      Invalidate;
      if CheckIndx > -1 then
        ClickCheck(CheckIndx);

      Indx := FHotIndex;
      FHotIndex := OldHot;

      SetHotIndex(Indx, False);

      if OldIndex <> FItemIndex then
        DoItemClick(FItemIndex);
    end;

    VerifyIndex(FClickedIndex);
    if not FBypassEditing and (FClickedIndex > -1) and
      (OldClick = FClickedIndex) then
      InitiateClickTimer;
  end;
end;

procedure TSCCustomSimpleListbox.MouseInControlChanged;
var
  P: TPoint;
  Indx, OldHot: Integer;
begin
  OldHot := FHotIndex;
  FHotIndex := -1;

  if not MouseInControl then
  begin
    HideHintWindow;

    Indx := FHotIndex;
    FHotIndex := OldHot;

    SetHotIndex(Indx, True);
  end else
  begin
    if not IsEditing then
    begin
      UpdateHotTrack(False);

      HideHintWindow;
      if GetCursorPos(P) then
      begin
        P := Self.ScreenToClient(P);
        ShowHintWindow(P);
      end;
    end;

    if FHotTrack and (OldHot <> FHotIndex) and not IsEditing then
      Invalidate;
  end;
end;

procedure TSCCustomSimpleListbox.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  R: TRect;
  Item: PSCStringItem;
  OldHot, Data,
  I, AIndex, OldIndex,
  OldStart, StartItem, EndItem: Integer;
begin
  VerifyIndex(FMouseDownIndex);

  if IsEditing then
  begin
    inherited MouseMove(Shift, X, Y);
    Exit;
  end;

  if FClickedIndex = -1 then
    KillClickTimer;

  OldHot := FHotIndex;
  FHotIndex := ItemAtPos(X, Y);

  OldIndex := FItemIndex;

  if FMouseDownIndex < 0 then
  begin
    AIndex := FHotIndex;
    FHotIndex := OldHot;

    SetHotIndex(AIndex, True);
  end else
  if FItems.Count > 0 then
  begin
    AIndex := FHotIndex;
    if FColumns > 0 then
      AIndex := ItemAtPos(X, Y, FMouseDownIndex > -1);

    VerifyIndex(AIndex);

    if not FMultiSelect then
    begin
      if AIndex > -1 then
      begin
        SetItemIndex(AIndex);
        FStartIndex := AIndex;
      end;

      AIndex := FHotIndex;
      FHotIndex := OldHot;

      SetHotIndex(AIndex, True);
    end else
    begin
      if AIndex < 0 then
      begin
        AIndex := FHotIndex;
        FHotIndex := OldHot;

        SetHotIndex(AIndex, True);
      end else
      begin
        if not FExtendedSelect then
        begin
          FStartIndex := FItemIndex;
          SetItemIndex(AIndex);

          Invalidate;

          AIndex := FHotIndex;
          FHotIndex := OldHot;

          SetHotIndex(AIndex, False);
        end else
        begin
          OldStart := FStartIndex;

          SetItemIndex(AIndex);
          if (FStartIndex < 0) or (FStartIndex > FItems.Count-1) then
            FStartIndex := FItemIndex;

          VerifyIndex(FStartIndex);

          FItems.BeginUpdate;
          try
            Data := Integer(ssCtrl in Shift);
            for I := 0 to FItems.Count-1 do
            begin
              Item := TSCListStrings(FItems).List[I];
              Item^.FData[2] := Integer(Boolean(Data) and Boolean(Item^.FData[3]));
            end;

            StartItem := FStartIndex;
            EndItem   := FItemIndex;

            if EndItem < StartItem then
            begin
              I := EndItem;
              EndItem := StartItem;
              StartItem := I;
            end;

            Data := Integer(True);
            if ssCtrl in Shift then
              Data := Integer(not FSelectionClears);

            for I := StartItem to EndItem do
            begin
              Item := TSCListStrings(FItems).List[I];
              Item^.FData[2] := Data;
            end;
          finally
            FItems.EndUpdate;
          end;

          if (OldStart <> FStartIndex) or
            ((OldIndex <> FItemIndex) and (ItemInView(OldIndex) or ItemInView(FItemIndex))) or
            ((OldHot <> FHotIndex) and (ItemInView(OldHot) or ItemInView(FHotIndex))) then
            Invalidate;

          AIndex := FHotIndex;
          FHotIndex := OldHot;

          SetHotIndex(AIndex, False);
        end;
      end;
    end;

    R := GetClientRect;
    if not (IsRectEmpty(R) or PtInRect(R, Point(X, Y))) then
      StartScrolling
    else
    if Scrolling then
      PauseScrolling;
  end;

  if OldIndex <> FItemIndex then
    DoItemClick(FItemIndex);

  if (OldHot <> FHotIndex) and not Scrolling then
    ShowHintWindow(Point(X, Y));

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomSimpleListbox.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I, OldIndex: Integer;
  Item: PSCStringItem;
begin
  StopScrolling;

  FMouseDownShift  := [];
  FSelectionClears := False;

  FBypassEditing := FBypassEditing or (Button <> mbLeft) or
    (Shift*[ssShift, ssAlt, ssCtrl, ssDouble] <> []);

  OldIndex := FItemIndex;

  if FMouseDownIndex <> -1 then
  begin
    FMouseDownIndex  := -1;

    LockItemHint;
    FItems.BeginUpdate;
    try
      for I := 0 to FItems.Count-1 do
      begin
        Item := TSCListStrings(FItems).List[I];
        Item^.FData[3] := Integer(False);
      end;
    finally
      FItems.EndUpdate;
      UnlockItemHint;
    end;
  end;

  SetHotIndex(ItemAtPos(X, Y), True);

  if OldIndex <> FItemIndex then
    DoItemClick(FItemIndex);

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomSimpleListbox.Paint;
var
  BoundsOut: Boolean;
  CR, R, R2, R3: TRect;
  Item: PSCStringItem;
  TopIndx, Indx, Ind,
  L, CbxW, ColCnt, Cnt,
  CH, CW, W, H, I, J: Integer;
begin
  DoPaintBack(Canvas);
  DrawPicture(Canvas);

  if FItems.Count = 0 then
    Exit;

  CR := GetClientRect;

  if FColumns < 1 then
  begin
    CW := CR.Right - CR.Left;

    R := CR;
    R.Bottom := R.Top;

    L := GetHorzScrollPos;
    OffsetRect(R, -L, 0);

    TopIndx := FTopIndex;
    VerifyTopIndex(TopIndx);

    CbxW := 0;
    if FShowCheckboxes and not FLineSelect then
      CbxW := GetCheckWidth;

    for I := TopIndx to FItems.Count - 1 do
    begin
      if R.Top >= CR.Bottom then
        Break;

      Item := TSCListStrings(FItems).List[I];

      H := Item^.FData[0];
      W := Item^.FData[1];

      if H > 0 then
      begin
        if W < 0 then W := 0;
        Inc(W, CbxW);

        if W = 0 then
          W := 1;

        if FEndEllipsis and (W > CW) then
          W := CW;

        R.Bottom := R.Top  + H;
        R.Right  := R.Left;

        if not Odd(I) and (FAlternateColor <> clNone) then
        begin
          R3 := CR;
          R3.Top := R.Top;
          R3.Bottom := R.Bottom;

          with Canvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := FAlternateColor;

            FillRect(R3);
          end;
        end;

        Ind := Indent*Item^.FData[6];
        if Ind < 0 then
          Ind := 0;

        if W > 0 then
        begin
          R.Right := R.Left + W;

          R2 := R;
          if Ind > 0 then
          begin
            OffsetRect(R2, Ind, 0);
            if FEndEllipsis and (R2.Right > CR.Right) then
              R2.Right := CR.Right;
          end;

          if not IsRectEmpty(R2) then
          begin
            BoundsOut := not ((R2.Left < CR.Right) and (R2.Right > CR.Left));

            if BoundsOut and FLineSelect and (FColumns = 0) and
              ((FItemIndex = I) or (FMultiSelect and Boolean(Item^.FData[2]))) then
              BoundsOut := False;

            if not BoundsOut then
              DoPaintItem(Canvas, I, CR, R2);
          end;
        end;
      end;

      R.Top := R.Bottom;
    end;
  end else
  begin
    CH := CR.Bottom - CR.Top;
    if CH = 0 then
      Exit;

    W := (CR.Right - CR.Left) div FColumns;
    if W < 1 then
      Exit;

    L := FHorizontalPos;
    VerifyHorizontalPos(L);

    if L < 0 then L := 0;

    H := GetItemHeight;
    if H < 1 then
      Exit;

    Cnt := CH div H;
    if Cnt = 0 then
      Cnt := 1;

    ColCnt  := FItems.Count div Cnt;
    if FItems.Count mod Cnt = 0 then
      Dec(ColCnt);

    for I := L to ColCnt do
    begin
      R := CR;
      R.Bottom := R.Top  + H;
      R.Right  := R.Left + W;

      OffsetRect(R, W*(I - L), 0);
      if R.Left >= CR.Right then
        Break;

      for J := 1 to Cnt do
      begin
        Indx := (I*Cnt) + (J - 1);
        if Indx > FItems.Count - 1 then
          Break;

        if not IsRectEmpty(R) and
          (R.Left < CR.Right) and (R.Right > CR.Left) then
          DoPaintItem(Canvas, Indx, CR, R);

        OffsetRect(R, 0, H);
      end;
    end;
  end;  
end;

procedure TSCCustomSimpleListbox.SetHideFocusRect(Value: Boolean);
begin
  if FHideFocusRect <> Value then
  begin
    FHideFocusRect := Value;

    if not InItemUpdate and (FItems.Count > 0) and
      Focused and ItemInView(FItemIndex, True) then
      Invalidate;
  end;
end;

procedure TSCCustomSimpleListbox.SetHideSelection(Value: Boolean);
begin
  if FHideSelection <> Value then
  begin
    FHideSelection := Value;

    if not InItemUpdate and (FItems.Count > 0) and
      not Focused and ItemInView(FItemIndex) then
      Invalidate;
  end;
end;

procedure TSCCustomSimpleListbox.SetHideSelectionBorderColor(
  Value: TColor);
begin
  if FHideSelectionBorderColor <> Value then
  begin
    FHideSelectionBorderColor := Value;

    if not FHideSelection and not InItemUpdate and (FItems.Count > 0) and
      not Focused and ItemInView(FItemIndex) then
      Invalidate;

    ColorsChanged;
  end;
end;

procedure TSCCustomSimpleListbox.SetHideSelectionColor(Value: TColor);
begin
  if FHideSelectionColor <> Value then
  begin
    FHideSelectionColor := Value;

    if not FHideSelection and not InItemUpdate and (FItems.Count > 0) and
      not Focused and ItemInView(FItemIndex) then
      Invalidate;

    ColorsChanged;
  end;
end;

procedure TSCCustomSimpleListbox.SetHideSelectionTextColor(Value: TColor);
begin
  if FHideSelectionTextColor <> Value then
  begin
    FHideSelectionTextColor := Value;

    if not FHideSelection and
      not InItemUpdate and (FItems.Count > 0) and
      not Focused and ItemInView(FItemIndex) then
      Invalidate;
      
    ColorsChanged;
  end;
end;

procedure TSCCustomSimpleListbox.SetHighlightBorderColor(Value: TColor);
begin
  if FHighlightBorderColor <> Value then
  begin
    FHighlightBorderColor := Value;

    if not InItemUpdate and (FItems.Count > 0) and
      Focused and ItemInView(FItemIndex) then
      Invalidate;

    ColorsChanged;
  end;
end;

procedure TSCCustomSimpleListbox.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;

    if not InItemUpdate and (FItems.Count > 0) and
      Focused and ItemInView(FItemIndex) then
      Invalidate;

    ColorsChanged;
  end;
end;

procedure TSCCustomSimpleListbox.SetHighlightTextColor(Value: TColor);
begin
  if FHighlightTextColor <> Value then
  begin
    FHighlightTextColor := Value;
    
    if not InItemUpdate and (FItems.Count > 0) and
      Focused and ItemInView(FItemIndex) then
      Invalidate;

    ColorsChanged;
  end;
end;

procedure TSCCustomSimpleListbox.SetHorizontalPos(Value: Integer);
var
  P: TPoint;
  Indx, OldHot: Integer;
begin
  Inc(FScrollPosChanging);
  try
    if IsDesigning or ((FColumns < 1) and (FEndEllipsis or IsEditing)) then
    begin
      Value := 0;
      if IsEditing then
        Value := FHorizontalPos;
    end;

    VerifyHorizontalPos(Value);

    if FHorizontalPos <> Value then
    begin
      HideHintWindow;
      FHorizontalPos := Value;

      OldHot := FHotIndex;
      if GetCursorPos(P) and not IsEditing then
      begin
        P := Self.ScreenToClient(P);
        FHotIndex := ItemAtPos(P.X, P.Y);
      end;

      UpdateHorzScrollBar;
      if FItems.Count > 0 then
        Invalidate;

      SizeEditor;

      Indx := FHotIndex;
      FHotIndex := OldHot;

      SetHotIndex(Indx, False);

      HideHintWindow;
      if GetCursorPos(P) then
      begin
        P := Self.ScreenToClient(P);
        ShowHintWindow(P);
      end;
    end;

    if FScrollbarChanging = 0 then
      TSCListboxScrollbar(ScrollbarHorz).Position := FHorizontalPos;
  finally
    Dec(FScrollPosChanging);
  end;
end;

procedure TSCCustomSimpleListbox.SetHottrack(Value: Boolean);
begin
  if FHottrack <> Value then
  begin
    FHottrack := Value;
    if FHotIndex > -1 then
      UpdateHotTrack;

    Invalidate;
    ColorsChanged;
  end;
end;

procedure TSCCustomSimpleListbox.SetHottrackColor(Value: TColor);
begin
  if FHottrackColor <> Value then
  begin
    FHottrackColor := Value;
    if FHottrack and (FHotIndex > -1) then
      UpdateHotTrack;

    ColorsChanged;
  end;
end;

procedure TSCCustomSimpleListbox.SetHottrackUnderline(Value: Boolean);
begin
  if FHottrackUnderline <> Value then
  begin
    FHottrackUnderline := Value;
    if FHottrack and (FHotIndex > -1) then
      UpdateHotTrack;

    ColorsChanged;
  end;
end;

procedure TSCCustomSimpleListbox.SetItemHeight(Value: Integer);
var
  W, H: LongInt;
begin
  if Value < -1 then
    Value := -1;

  if FItemHeight <> Value then
  begin
    FItemHeight := Value;

    if not InItemUpdate and (FItems.Count > 0) then
    begin
      UpdateBounds(W, H);
      if not IsDesigning then
        UpdateHotTrack(False);
        
      Invalidate;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.SetItemIndex(Value: Integer);
var
  ValueInView, NeedPaint: Boolean;
begin
  VerifyIndex(Value);
  Value := CanChangeItemIndex(Value);

  if FItemIndex <> Value then
  begin
    KillClickTimer;
    FClickedIndex := Value;

    PostEditor;

    ValueInView := (FItems.Count > -1) and ItemInView(Value, False);
    NeedPaint := (FItems.Count > -1) and (ItemInView(FItemIndex) or ValueInView);

    FItemIndex := Value;

    if FShowItemOnSelect and not ValueInView then
    begin
      NeedPaint := True;
      MakeVisible(Value);
    end;

    if NeedPaint then
      Invalidate;

    DoItemClick(FItemIndex);
    Click;
  end;
end;

procedure TSCCustomSimpleListbox.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
  DoSetItems;
end;

procedure TSCCustomSimpleListbox.SetLineSelect(Value: Boolean);
begin
  if FLineSelect <> Value then
  begin
    FLineSelect := Value;

    if not InItemUpdate and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomSimpleListbox.SetMultiSelect(Value: Boolean);
var
  I: Integer;
  Item: PSCStringItem;
begin
  if FMultiSelect <> Value then
  begin
    FMultiSelect := Value;

    if not InItemUpdate and (FItems.Count > 0) then
    begin
      FItems.BeginUpdate;
      try
        for I := 0 to FItems.Count-1 do
        begin
          Item := TSCListStrings(FItems).List[I];

          Item^.FData[2] := Integer(False);
          Item^.FData[3] := Integer(False);
        end;
      finally
        FItems.EndUpdate;
      end;

      Invalidate;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.SetObject(Index: Integer; Value: TObject);
begin
  TSCListStrings(FItems).OnChange := nil;
  try
    FItems.Objects[Index] := Value;
  finally
    TSCListStrings(FItems).OnChange := ItemsChanged;
  end;
end;

procedure TSCCustomSimpleListbox.SetScrollbarHorizontal(Value: Boolean);
begin
  if FScrollbarHorizontal <> Value then
  begin
    FScrollbarHorizontal := Value;
    FHorizontalPos := 0;

    if HandleAllocated and not InItemUpdate and (FItems.Count > 0) then
    begin
      UpdateScrollbars(True, True);
      if not IsDesigning then
        UpdateHotTrack(True);
    end;
  end;
end;

procedure TSCCustomSimpleListbox.SetScrollbarVertical(Value: Boolean);
begin
  if FScrollbarVertical <> Value then
  begin
    FScrollbarVertical := Value;
    FTopIndex := 0;

    if HandleAllocated and (FColumns < 1) and
      not InItemUpdate and (FItems.Count > 0) then
    begin
      UpdateScrollbars(True, True);
      if not IsDesigning then
        UpdateHotTrack(True);
    end;
  end;
end;

procedure TSCCustomSimpleListbox.SetScrollBounds(AWidth, AHeight: LongInt);
var
  HrzPos, TpIndx: Integer;
begin
  if (AWidth <> FScrollWidth) or (AHeight <> FScrollHeight) then
  begin
    FScrollHeight := AHeight;
    FScrollWidth  := AWidth;

    TpIndx := FTopIndex;
    VerifyTopIndex(TpIndx);

    if TpIndx <> FTopIndex then
      SetTopIndex(TpIndx);

    HrzPos := FHorizontalPos;
    VerifyHorizontalPos(HrzPos);

    if HrzPos <> FHorizontalPos then
      SetHorizontalPos(HrzPos);

    { UpdateVertScrollBar;
    UpdateHorzScrollBar; }
    UpdateScrollbars(True, True);

    DoScrollBoundsChanged;
  end;
end;

procedure TSCCustomSimpleListbox.SetSelected(Index: Integer;
  Value: Boolean);
begin
  TSCListStrings(FItems).OnChange := nil;
  try
    TSCListStrings(FItems).Data[Index, 2] := Integer(Value);
    TSCListStrings(FItems).Data[Index, 3] := Integer(Value);

    if FMultiSelect and not InItemUpdate and ItemInView(Index) then
      Invalidate;
  finally
    TSCListStrings(FItems).OnChange := ItemsChanged;
  end;

  DoInternalDataChanged(Index);
end;

procedure TSCCustomSimpleListbox.SetString(Index: Integer;
  const Value: String);
var
  W, H: LongInt;
begin
  TSCListStrings(FItems).OnChange := nil;
  try
    FItems.Strings[Index] := Value;

    if not InItemUpdate then
    begin
      if not ItemInView(Index) then
        Invalidate;

      UpdateBounds(W, H);
    end;
  finally
    TSCListStrings(FItems).OnChange := ItemsChanged;
  end;

  DoInternalDataChanged(Index);
end;

procedure TSCCustomSimpleListbox.SetTopIndex(Value: Integer);
var
  P: TPoint;
  Indx, OldHot: Integer;
begin
  Inc(FScrollPosChanging);
  try
    if IsDesigning or (FColumns > 0) then
      Value := 0;

    VerifyTopIndex(Value);

    if FTopIndex <> Value then
    begin
      HideHintWindow;

      FTopIndex := Value;

      OldHot := FHotIndex;
      if GetCursorPos(P) and not IsEditing then
      begin
        P := Self.ScreenToClient(P);
        FHotIndex := ItemAtPos(P.X, P.Y);
      end;

      UpdateScrollbars(False, True);
      if not InItemUpdate and (FItems.Count > 0) then
        Invalidate;

      FTopIndex := Value;
      
      SizeEditor;

      Indx := FHotIndex;
      FHotIndex := OldHot;

      SetHotIndex(Indx, False);

      HideHintWindow;
      if GetCursorPos(P) then
      begin
        P := Self.ScreenToClient(P);
        ShowHintWindow(P);
      end;
    end;

    if FScrollbarChanging = 0 then
      TSCListboxScrollbar(ScrollbarVert).Position := FTopIndex;
  finally
    Dec(FScrollPosChanging);
  end;
end;

procedure TSCCustomSimpleListbox.StopTracking;
var
  I: Integer;
  Item: PSCStringItem;
begin
  FMouseDownShift  := [];
  FMouseDownIndex  := -1;
  FSelectionClears := False;

  FItems.BeginUpdate;
  try
    for I := 0 to FItems.Count-1 do
    begin
      Item := TSCListStrings(FItems).List[I];
      Item^.FData[3] := Integer(False);
    end;
  finally
    FItems.EndUpdate;
  end;

  StopScrolling;
  inherited StopTracking;
end;

procedure TSCCustomSimpleListbox.UpdateBounds(var AWidth, AHeight: LongInt);
var
  W, ItemH, ItemW,
  ItemInd, I, Ind: Integer;
begin
  Ind := Indent;
  if Ind < 0 then Ind := 0;

  AWidth := 0;
  AHeight := 0;
  
  for I := FItems.Count-1 downto 0 do
  begin
    GetItemBounds(I, ItemW, ItemH, ItemInd);

    if ItemW < 0 then ItemW := 0;
    if ItemH < 0 then ItemH := 0;
    if ItemInd < 0 then ItemInd := 0;

    Inc(AHeight, ItemH);

    W := ItemW + (ItemInd*Ind);
    if W > AWidth then
      AWidth := W;
  end;

  SetScrollBounds(AWidth, AHeight);
end;

function TSCCustomSimpleListbox.UpdateHorzScrollBar: Boolean;
var
  CbxW: Integer;
  ScrlVisible: Boolean;
  SiOld, SiNew: TSCScrollInfo;
begin
  Result := False;
  if HandleAllocated and (FCreatingWnd = 0) and not IsLoading then
  begin
    SiOld := Self.GetScrollbarInfo(scskHorizontal);
    ScrlVisible := SiOld.Visible and (SiOld.Page <= SiOld.Max);

    SiNew := SiOld;

    SiNew.Page := 1;
    SiNew.Min  := 0;
    SiNew.Max  := 0;
    SiNew.Pos  := 0;

    if FScrollbarHorizontal and (FItems.Count > 0) and CanShowHorzScrollBar then
    begin
      if FColumns > 0 then
      begin
        SiNew.Page := Self.FColumns;
        SiNew.Min  := 0;
        SiNew.Max  := GetColumnCount;

        if (Self.FColumns = 1) and (SiNew.Max > Self.FColumns) then
          Dec(SiNew.Max);
      end else
      if not FEndEllipsis then
      begin
        SiNew.Page := Self.ClientWidth;
        SiNew.Min  := 0;
        SiNew.Max  := FScrollWidth;

        if FShowCheckboxes then
        begin
          CbxW := GetCheckWidth;
          if CbxW > 0 then
            Inc(SiNew.Max, CbxW);
        end;
      end;

      if SiNew.Max < 0 then
        SiNew.Max := 0;

      VerifyHorizontalPos(FHorizontalPos);
      SiNew.Pos  := FHorizontalPos;
    end;

    SiNew.SmallChange := 10;
    SiNew.LargeChange := SiNew.Page div 2;

    if (SiNew.Min <> SiOld.Min) or (SiNew.Max <> SiOld.Max) or
      (SiNew.Page <> SiOld.Page) or (SiNew.Pos <> SiOld.Pos) then
    begin
      HideHintWindow;

      SiNew.Visible := SiNew.Page <= SiNew.Max;
      Self.SetScrollbarInfo(scskHorizontal, SiNew);

      if Integer(SiNew.Page) > SiNew.Max then
        SetHorizontalPos(SiNew.Min);
    end;

    Result := ScrlVisible <> (Integer(SiNew.Page) <= SiNew.Max);
  end;
end;

procedure TSCCustomSimpleListbox.UpdateHotTrack(Draw: Boolean);
var
  P: TPoint;
  Indx, OldHot: Integer;
begin
  OldHot := FHotIndex;

  if HandleAllocated then
  begin
    if not GetCursorPos(P) then
      FHotIndex := -1
    else begin
      P := Self.ScreenToClient(P);
      FHotIndex := ItemAtPos(P.x, P.y);
    end;
  end;

  if Draw and FHotTrack and (OldHot <> FHotIndex) and
    not IsEditing and (ItemInView(OldHot) or ItemInView(FHotIndex)) then
    Invalidate;

  Indx := FHotIndex;
  FHotIndex := OldHot;

  SetHotIndex(Indx, False);
end;

function TSCCustomSimpleListbox.UpdateVertScrollBar: Boolean;
var
  Dist: Integer;
  ScrlVisible: Boolean;
  SiOld, SiNew: TSCScrollInfo;
begin
  Result := False;
  if HandleAllocated and (FCreatingWnd = 0) and not IsLoading then
  begin
    SiOld := Self.GetScrollbarInfo(scskVertical);
    ScrlVisible := SiOld.Visible and (SiOld.Page <= SiOld.Max);

    SiNew := SiOld;

    SiNew.Min := 0;
    if FScrollbarVertical and (FColumns < 1) and
      CanShowVertScrollBar and (FItems.Count > 1) then
    begin
      SINew.Page := (Self.ClientHeight div (FScrollHeight div FItems.Count)) - 1;

      SINew.Min  := 0;
      SINew.Max  := FItems.Count-1;
      SINew.Pos  := FTopIndex;
    end else
    begin
      SiNew.Page := 1;
      SiNew.Min  := 0;
      SiNew.Max  := 0;
      SiNew.Pos  := 0;
    end;

    SiNew.TrimPageSize := True;
    SiNew.LargeChange  := SiNew.Page;

    Dist := SiNew.Max - SiNew.Min;
    SiNew.Visible := (SiNew.Page > -1) and (SiNew.Max > 0) and
      (Dist > 0) and (SiNew.Page < Dist);

    if (SiNew.Min <> SiOld.Min) or (SiNew.Max <> SiOld.Max) or
      (SiNew.Page <> SiOld.Page) or (SiNew.Pos <> SiOld.Pos) or
      (SiNew.Visible <> SiOld.Visible) then
    begin
      HideHintWindow;
      Self.SetScrollbarInfo(scskVertical, SiNew);

      if Integer(SiNew.Page) > SiNew.Max then
        SetTopIndex(SiNew.Min);
    end;

    Result := ScrlVisible <> (Integer(SiNew.Page) <= SiNew.Max);
  end;
end;

procedure TSCCustomSimpleListbox.VerifyIndex(var Index: Integer);
begin
  if Index < -1 then
    Index := -1;

  if IsLoading or IsReading then
    Exit;

  if Index < -1 then
    Index := -1
  else
  if Index > FItems.Count - 1 then
    Index := FItems.Count - 1;
end;

procedure TSCCustomSimpleListbox.VerifyHorizontalPos(var P: Integer);
var
  CR: TRect;
  CbxW, Max: Integer;
begin
  if P < 0 then P := 0;

  if HandleAllocated then
  begin
    Max := 0;
    
    if FColumns > 0 then
    begin
      Max := GetColumnCount - (FColumns - 1);
      if (FColumns = 1) and (Max > FColumns) then
        Dec(Max);
    end else
    if not FEndEllipsis then
    begin
      CbxW := 0;
      if FShowCheckboxes then
      begin
        CbxW := GetCheckWidth;
        if CbxW < 0 then CbxW := 0;
      end;

      CR := GetClientRect;
      Max := (FScrollWidth + CbxW) - (CR.Right - CR.Left);
    end;

    if Max < 0 then
      Max := 0;

    if P > Max then
      P := Max;
  end;
end;

procedure TSCCustomSimpleListbox.VerifyTopIndex(var Index: Integer);
var
  I, MaxTop: Integer;
  CR, R: TRect;
  Item: PSCStringItem;
begin
  if FColumns > 0 then
  begin
    Index := 0;
    Exit;
  end;

  if Index < 0 then
    Index := 0;

  if IsLoading or IsReading then
    Exit;

  if Index > FItems.Count - 1 then
    Index := FItems.Count - 1;
  if Index < 0 then
    Index := 0;

  if FItems.Count < 2 then
  begin
    Index := 0;
    Exit;
  end;

  CR := GetClientRect;
  if not IsRectEmpty(CR) then
  begin
    if (FScrollHeight > 0) and
      (CR.Bottom - CR.Top >= FScrollHeight) then
    begin
      Index := 0;
      Exit;
    end;

    R := CR;
    R.Top := R.Bottom;

    MaxTop := FItems.Count - 1;

    for I := FItems.Count - 1 downto 0 do
    begin
      Item := TSCListStrings(FItems).List[I];

      if Item^.FData[0] > 0 then
      begin
        Dec(R.Top, Item^.FData[0]);

        if R.Top = CR.Top then
        begin
          MaxTop := I;
          Break;
        end else
        if R.Top < CR.Top then
        begin
          MaxTop := I + 1;
          if MaxTop > FItems.Count - 1 then
            MaxTop := FItems.Count - 1;

          Break;  
        end;
      end;
    end;

    if Index > MaxTop then
      Index := MaxTop;
  end;
end;

procedure TSCCustomSimpleListbox.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TSCCustomSimpleListbox.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := DLGC_WANTARROWS;
end;

procedure TSCCustomSimpleListbox.WMHScroll(var Message: TWMHScroll);
var
  SI: TScrollInfo;
begin
  if not IsDesigning and not (IsEditing or InEditShow) then
  begin
    SI.cbSize := SizeOf(SI);
    SI.fMask  := SIF_ALL;

    GetScrollInfo(Self.Handle, SB_HORZ, SI);

    if FColumns > 0 then
    begin
      case Message.ScrollCode of
        SB_LINEUP:
          SetHorizontalPos(FHorizontalPos - 1);
        SB_LINEDOWN:
          SetHorizontalPos(FHorizontalPos + 1);
        SB_PAGEUP:
          SetHorizontalPos(FHorizontalPos - 3);
        SB_PAGEDOWN:
          SetHorizontalPos(FHorizontalPos + 3);
        SB_THUMBPOSITION, SB_THUMBTRACK:
        begin
          if SI.nTrackPos <= SI.nMin then
            SetHorizontalPos(SI.nMin)
          else
          if SI.nTrackPos >= SI.nMax then
            SetHorizontalPos(SI.nMax)
          else
            SetHorizontalPos(SI.nTrackPos);
        end;
        SB_TOP:
          SetHorizontalPos(SI.nMin);
        SB_BOTTOM:
          SetHorizontalPos(SI.nMax);
      end;
    end else
    begin
      case Message.ScrollCode of
        SB_LINEUP:
          SetHorizontalPos(FHorizontalPos - 10);
        SB_LINEDOWN:
          SetHorizontalPos(FHorizontalPos + 10);
        SB_PAGEUP:
          SetHorizontalPos(FHorizontalPos - 30);
        SB_PAGEDOWN:
          SetHorizontalPos(FHorizontalPos + 30);
        SB_THUMBPOSITION, SB_THUMBTRACK:
        begin
          if SI.nTrackPos <= SI.nMin then
            SetHorizontalPos(SI.nMin)
          else
          if SI.nTrackPos >= SI.nMax then
            SetHorizontalPos(SI.nMax)
          else
            SetHorizontalPos(SI.nTrackPos);
        end;
        SB_TOP:
          SetHorizontalPos(SI.nMin);
        SB_BOTTOM:
          SetHorizontalPos(SI.nMax);
      end;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if not IsDesigning and not (IsEditing or InEditShow) then
  begin
    if FColumns > 0 then
    begin
      if Message.WheelDelta < 0 then
        SetHorizontalPos(FHorizontalPos + 1)
      else
      if Message.WheelDelta > 0 then
        SetHorizontalPos(FHorizontalPos - 1);
    end else
    begin
      if Message.WheelDelta < 0 then
        SetTopIndex(TopIndex + 3)
      else
      if Message.WheelDelta > 0 then
        SetTopIndex(TopIndex - 3);
    end;
  end;
end;

procedure TSCCustomSimpleListbox.WMSize(var Message: TWMSize);
var
  P: TPoint;
  W, H: LongInt;
begin
  inherited;

  if FColumns < 1 then
    UpdateBounds(W, H);

  { UpdateVertScrollBar;
  UpdateHorzScrollBar; }

  UpdateScrollbars(True, True);

  SizeEditor;

  HideHintWindow;
  if GetCursorPos(P) then
  begin
    P := Self.ScreenToClient(P);
    ShowHintWindow(P);
  end;
end;

procedure TSCCustomSimpleListbox.WMVScroll(var Message: TWMVScroll);
var
  I: Integer;
  SI: TScrollInfo;
begin
  if not IsDesigning and not (IsEditing or InEditShow) then
  begin
    SI.cbSize := SizeOf(SI);
    SI.fMask := SIF_ALL;

    GetScrollInfo(Self.Handle, SB_VERT, SI);

    case Message.ScrollCode of
      SB_LINEUP:
        SetTopIndex(FTopIndex - 1);
      SB_LINEDOWN:
        SetTopIndex(FTopIndex + 1);
      SB_PAGEUP:
      begin
        I := GetPageUpIndex(FTopIndex);
        SetTopIndex(I);
      end;
      SB_PAGEDOWN:
      begin
        I := GetPageDownIndex(FTopIndex);
        SetTopIndex(I);
      end;
      SB_THUMBPOSITION, SB_THUMBTRACK:
      begin
        if SI.nTrackPos <= SI.nMin then
          SetTopIndex(SI.nMin)
        else
        if SI.nTrackPos >= SI.nMax then
          SetTopIndex(SI.nMax)
        else
          SetTopIndex(SI.nTrackPos);
      end;
      SB_TOP:
        SetTopIndex(SI.nMin);
      SB_BOTTOM:
        SetTopIndex(SI.nMax);
    end;
  end;
end;

function TSCCustomSimpleListbox.GetChecked(Index: Integer): Boolean;
begin
  Result := False;
  if (Index > -1) and (Index < FItems.Count) then
    Result := DataToState(TSCListStrings(FItems).Data[Index, 4]) = sccbChecked;
end;

function TSCCustomSimpleListbox.GetItemEnabled(Index: Integer): Boolean;
begin
  Result := True;
  if (Index > -1) and (Index < FItems.Count) then
    Result := TSCListStrings(FItems).Data[Index, 5] = 0;
end;

procedure TSCCustomSimpleListbox.SetChecked(Index: Integer;
  Value: Boolean);
begin
  TSCListStrings(FItems).OnChange := nil;
  try
    TSCListStrings(FItems).Data[Index, 4] := Integer(Value);
    if FShowCheckboxes and not InItemUpdate and ItemInView(Index) then
      Invalidate;
  finally
    TSCListStrings(FItems).OnChange := ItemsChanged;
  end;

  DoInternalDataChanged(Index);
  ClickCheck(Index);
end;

procedure TSCCustomSimpleListbox.SetItemEnabled(Index: Integer; Value: Boolean);
begin
  TSCListStrings(FItems).OnChange := nil;
  try
    TSCListStrings(FItems).Data[Index, 5] := Integer(not Value);

    if IsEditing and (FItemIndex = Index) then
      HideEditor;

    if not InItemUpdate and Enabled and ItemInView(Index) then
      Invalidate;
  finally
    TSCListStrings(FItems).OnChange := ItemsChanged;
  end;
  
  DoInternalDataChanged(Index);
end;

procedure TSCCustomSimpleListbox.SetShowCheckboxes(Value: Boolean);
begin
  if FShowCheckboxes <> Value then
  begin
    FShowCheckboxes := Value;

    if not InItemUpdate and (FItems.Count > 0) then
    begin
      UpdateScrollbars(True, True);
      Invalidate;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.SetShowItemImages(Value: Boolean);
var
  W, H: LongInt;
begin
  if FShowItemImages <> Value then
  begin
    FShowItemImages := Value;

    if (Images <> nil) and not InItemUpdate and (FItems.Count > 0) then
    begin
      Invalidate;
      if FColumns < 1 then
        UpdateBounds(W, H);
    end;
  end;
end;

procedure TSCCustomSimpleListbox.SetFlat(Value: TSCSimpleCheckFlat);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    if FShowCheckboxes and not InItemUpdate and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomSimpleListbox.SetExtendedSelect(Value: Boolean);
begin
  if FExtendedSelect <> Value then
  begin
    FExtendedSelect := Value;
    if FMultiSelect and not InItemUpdate and (FItems.Count > 0) then
      ItemsChanged(nil);
  end;
end;

procedure TSCCustomSimpleListbox.SetColumns(Value: Integer);
var
  OldC: Integer;
  W, H: LongInt;
begin
  if Value < 0 then
    Value := 0;

  if FColumns <> Value then
  begin
    SetTopIndex(0);
    SetHorizontalPos(0);

    OldC := FColumns;
    FColumns := Value;

    if not InItemUpdate and (FItems.Count > 0) then
    begin
      if ((OldC < 1) and (FColumns > 0)) or
        ((OldC > 0) and (FColumns < 1)) then
        UpdateBounds(W, H)
      else begin
        { UpdateHorzScrollBar;
        UpdateVertScrollBar; }
        UpdateScrollbars(True, True);
      end;

      Invalidate;
    end;
  end;
end;

function TSCCustomSimpleListbox.GetColumnHeight: Integer;
var
  CR, R: TRect;
  CH, H, SH, ScrlHeight, Cnt: Integer;
begin
  Result := -1;
  if HandleAllocated and (FColumns > 0) then
  begin
    H := GetItemHeight;
    if H < 1 then
      Exit;

    CR := GetClientRect;
    R  := CR;

    ScrlHeight := scHorzScrollbarHeight;
    SH := ScrlHeight;
    if not IsHorzScrollBarVisible then
      SH := 0;

    // decide here to show the horizontal scrollbar and
    // so find the real client height
    CH := (CR.Bottom + SH) - CR.Top;
    if CH < 1 then
      CH := 1;

    Result := CH div H;
    if Result = 0 then
      Result := 1;

    Cnt := FItems.Count div Result;
    if FItems.Count mod Result <> 0 then
      Inc(Cnt);

    if Cnt <= FColumns then // if horizontal scrollbar is not visible
      Inc(CR.Bottom, ScrlHeight);
    // here ends the decition

    if not ((SH = 0) and EqualRect(R, CR)) then // scrollbar visibility changed
    begin
      CH := CR.Bottom - CR.Top;
      if CH < 1 then
        CH := 1;

      Result := CH div H;
      if Result = 0 then
        Result := 1;
    end;
  end;
end;

function TSCCustomSimpleListbox.GetColumnCount: Integer;
var
  Cnt: Integer;
begin
  Result := -1;
  if HandleAllocated and (FColumns > 0) then
  begin
    Cnt := GetColumnHeight;
    if Cnt < 0 then
      Exit;

    {Result := FItems.Count div Cnt;
    if FItems.Count mod Cnt = 0 then
      Dec(Result);}

    Result := FItems.Count div Cnt;
    if FItems.Count mod Cnt > 0 then
      Inc(Result);
  end;
end;

function TSCCustomSimpleListbox.GetColumnOf(Index: Integer): Integer;
var
  H: Integer;
begin
  Result := -1;
  if (FItems.Count > 0) and (Index > -1) and (Index < FItems.Count) then
  begin
    H := GetColumnHeight;
    if H < 1 then
      Exit;

    Result := Index div H;
  end;
end;

procedure TSCCustomSimpleListbox.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    if not InItemUpdate and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomSimpleListbox.SetDisabledTextColor(Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;

    if not InItemUpdate and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomSimpleListbox.SetEndEllipsis(Value: Boolean);
var
  CbxW: Integer;
  W, H: LongInt;
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;

    CbxW := 0;
    if FShowCheckboxes then
    begin
      CbxW := GetCheckWidth;
      if CbxW < 0 then CbxW := 0;
    end;  

    if not InItemUpdate and (FItems.Count > 0) and
      ((FColumns > 0) or (FScrollWidth + CbxW > ClientWidth)) then
    begin
      if FColumns < 1 then
      begin
        SetHorizontalPos(0);
        UpdateHorzScrollBar;
      end;

      UpdateBounds(W, H);
      Invalidate;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.DeleteString(Index: Integer);
begin
  FItems.Delete(Index);
end;

procedure TSCCustomSimpleListbox.ResetContent;
begin
  FItems.Clear;
end;

function TSCCustomSimpleListbox.GetItemData(Index: Integer): LongInt;
begin
  Result := TSCListStrings(FItems).Data[Index, 9];
end;

procedure TSCCustomSimpleListbox.SetItemData(Index, AData: Integer);
begin
  TSCListStrings(FItems).Data[Index, 9] := AData;
end;

function TSCCustomSimpleListbox.InternalGetItemData(Index: Integer): Longint;
begin
  Result := GetItemData(Index);
end;

procedure TSCCustomSimpleListbox.InternalSetItemData(Index, AData: Integer);
begin
  SetItemData(Index, AData);
end;

procedure TSCCustomSimpleListbox.MeasureItem(Index: Integer;
  var AWidth, AHeight, AIndent: Integer);
begin
  DoMeasureItem(Index, AWidth, AHeight, AIndent);
  if Assigned(FOnMeasureItem) then
    FOnMeasureItem(Self, Index, AWidth, AHeight, AIndent);
end;

procedure TSCCustomSimpleListbox.WMLButtonDown(var Message: TWMLButtonDown);
var
  P: TPoint;
  Indx: Integer;
  ShiftState: TShiftState;
begin
  KillClickTimer;
  ShiftState := KeysToShiftState(Message.Keys);

  if (DragMode = dmAutomatic) and
    FMultiSelect and (ShiftState*[ssShift, ssCtrl] = []) then
  begin
    P := SmallPointToPoint(Message.Pos);
    Indx := ItemAtPos(P.X, P.Y);

    if (Indx > -1) and
      (Indx < FItems.Count) and (Selected[Indx]) then
    begin
      BeginDrag(False);
      Exit;
    end;
  end;

  inherited;
  
  if (DragMode = dmAutomatic) and
    not (FMultiSelect and (ShiftState*[ssShift, ssCtrl] <> [])) then
    BeginDrag(False);
end;

procedure TSCCustomSimpleListbox.WndProc(var Message: TMessage);
begin
  if (DragMode = dmAutomatic) and not IsDesigning and not Dragging and
    ((Message.Msg = WM_LBUTTONDOWN) or (Message.Msg = WM_LBUTTONDBLCLK)) then
  begin
    if IsControlMouseMsg(TWMMouse(Message)) then
      Exit;

    if not Focused and CanFocus then
      SetFocus;

    HideHintWindow;

    ControlState := ControlState + [csLButtonDown];
    Dispatch(Message);

    Exit;
  end;

  inherited WndProc(Message);
end;

procedure TSCCustomSimpleListbox.DragCanceled;
var
  P: TPoint;
  Message: TWMMouse;
begin
  with Message do
  begin
    Msg := WM_LBUTTONDOWN;
    GetCursorPos(P);
    Pos := PointToSmallPoint(ScreenToClient(P));
    Keys := 0;
    Result := 0;
  end;
  
  DefaultHandler(Message);
  Message.Msg := WM_LBUTTONUP;
  DefaultHandler(Message);
end;

procedure TSCCustomSimpleListbox.ClickCheck(Index: Integer);
begin
  if (Index > -1) and (Index < FItems.Count) and Assigned(FOnClickCheck) then
    FOnClickCheck(Self, Index);
end;

procedure TSCCustomSimpleListbox.Clear;
begin
  FItems.Clear;
end;

procedure TSCCustomSimpleListbox.SetAllowEdit(Value: Boolean);
begin
  if FAllowEdit <> Value then
  begin
    FAllowEdit := Value;
    if not Value then
      HideEditor;
  end;
end;

function TSCCustomSimpleListbox.CanShowEditor: Boolean;
begin
  Result := True;
end;

procedure TSCCustomSimpleListbox.DoMeasureItem(Index: Integer;
  var AWidth, AHeight, AIndent: Integer);
begin
  //
end;

procedure TSCCustomSimpleListbox.DoShowEditor(Index: Integer; var AllowEdit: Boolean);
begin
  if (Index > -1) and (Index < FItems.Count) and Assigned(FOnShowEditor) then
    FOnShowEditor(Self, Index, AllowEdit);
end;

procedure TSCCustomSimpleListbox.DoSizeEditor(Index: Integer; var EditRect: TRect);
begin
  if (Index > -1) and (Index < FItems.Count) and Assigned(FOnSizeEditor) then
    FOnSizeEditor(Self, Index, EditRect);
end;

procedure TSCCustomSimpleListbox.DoHideEditor(Index: Integer);
begin
  if (Index > -1) and (Index < FItems.Count) and Assigned(FOnHideEditor) then
    FOnHideEditor(Self, Index);
end;

procedure TSCCustomSimpleListbox.DoValidateEditor(Index: Integer;
  var Text: String; var AcceptEdit: Boolean);
begin
  if (Index > -1) and (Index < FItems.Count) and Assigned(FOnValidateEditor) then
    FOnValidateEditor(Self, Index, Text, AcceptEdit);
end;

procedure TSCCustomSimpleListbox.HideEditor;
var
  P: TPoint;
begin
  if IsEditing then
  begin
    KillClickTimer;

    try
      FEditSavedText := '';

      with TSCListboxEdit(FInplaceEditor) do
      begin
        OnInternalChange := nil;
        WindowProc := FInplaceOldWndProc;
      end;

      FInplaceOldWndProc := nil;
      DoHideEditor(FItemIndex);
    finally
      if FInplaceEditor <> nil then
        FreeAndNil(FInplaceEditor);
    end;

    UpdateHotTrack(True);
    if CanFocus then
      SetFocus;

    if GetCursorPos(P) then
    begin
      P := Self.ScreenToClient(P);
      ShowHintWindow(P);
    end;
  end;
end;

procedure TSCCustomSimpleListbox.PostEditor;
var
  EdText: String;
  W, H: LongInt;
  Indx: Integer;
  NeedPaint, Accept: Boolean;
begin
  if IsEditing then
  begin
    KillClickTimer;

    NeedPaint := False;
    EdText := GetEditText;

    Indx := FItemIndex;
    if EdText <> FEditSavedText then
    begin
      Accept := True;

      TSCListboxEdit(FInplaceEditor).OnInternalChange := nil;
      DoValidateEditor(Indx, EdText, Accept);

      if (Indx > -1) and (Indx < FItems.Count) and
        Accept and (FItems.Strings[Indx] <> EdText) then
      begin
        NeedPaint := True;
        Strings[Indx] := EdText;

        UpdateBounds(W, H);
      end;
    end;

    HideEditor;
    MakeVisible(Indx);

    if NeedPaint then
      Invalidate;
  end;
end;

procedure TSCCustomSimpleListbox.ShowEditor;
var
  CR, R, R2: TRect;
  AllowEdit: Boolean;
  CbW, Ind, TpIndx, OldHot, Indx: Integer;
begin
  KillClickTimer;
  FClickedIndex := -1;

  if FInEditShow then
    Exit;

  PostEditor;
  if FAllowEdit and CanShowEditor and HandleAllocated and 
    (FItems.Count > 0) and not IsDesigning then
  begin
    FInEditShow := True;
    try
      FMouseDownIndex := -1;
      HideHintWindow;

      FInplaceOldWndProc := nil;

      CR := GetClientRect;
      if IsRectEmpty(CR) then
        Exit;

      Indx := FItemIndex;

      OldHot := FHotIndex;
      FHotIndex := -1;

      VerifyIndex(FItemIndex);
      if FItemIndex < 0 then
        FItemIndex := CanChangeItemIndex(0);

      TpIndx := FTopIndex;
      MakeVisible(FItemIndex);

      if (TpIndx = FTopIndex) and ((Indx <> FItemIndex) or
        (FHotTrack and (OldHot <> FHotIndex) and not IsEditing)) then
        Invalidate;

      {$IFDEF SC_DELPHI5_UP}
      if FInplaceEditor <> nil then
        FInplaceEditor.RemoveFreeNotification(Self);
      {$ENDIF}

      FInplaceEditor := FInplaceEditorClass.Create(Self);
      if FInplaceEditor <> nil then
        FInplaceEditor.FreeNotification(Self);

      FEditSavedText := FItems.Strings[FItemIndex];
      
      with TSCListboxEdit(FInplaceEditor) do
      begin
        Text := FEditSavedText;
        ClearUndo;
      end;

      PrepareEditor;

      if FInplaceEditor <> nil then
      begin
        AllowEdit := True;

        DoShowEditor(FItemIndex, AllowEdit);
        if not AllowEdit then
        begin
          FEditSavedText := '';
          if FInplaceEditor <> nil then
            FreeAndNil(FInplaceEditor);

          Exit;
        end;

        R := ItemRect(FItemIndex, False);
        if FShowCheckboxes then
        begin
          CbW := GetCheckWidth;
          Inc(R.Left, CbW);
        end;

        if FColumns < 1 then
        begin
          Ind := Indent*IndentLevel[FItemIndex];
          if Ind < 0 then Ind := 0;

          Dec(Ind, FHorizontalPos);
          Inc(R.Left, Ind);
        end;  

        if FShowItemImages and (Images <> nil) and (Images.Width > 0) then
          Inc(R.Left, Images.Width + 2);


        if R.Left > R.Right then R.Right := R.Left;
        DoSizeEditor(FItemIndex, R);


        IntersectRect(R2, R, CR);
        if IsRectEmpty(R) or IsRectEmpty(R2) then
        begin
          FEditSavedText := '';
          if FInplaceEditor <> nil then
            FreeAndNil(FInplaceEditor);

          Exit;
        end;

        if FInplaceEditor <> nil then
          with TSCListboxEdit(FInplaceEditor) do
          begin
            OnInternalChange := InplaceChanged;

            FInplaceOldWndProc := WindowProc;
            WindowProc := InplaceWindowProc;

            BoundsRect := R;
            Parent := Self;

            if HandleAllocated and CanFocus then
              SetFocus;

            SetSelRect(Rect(0, 0, 0, 0));
          end;
      end;

      Indx := FHotIndex;
      FHotIndex := OldHot;

      SetHotIndex(Indx, False);
    finally
      KillClickTimer;
      FClickedIndex := -1;

      FInEditShow := False;
    end;
  end;
end;

function TSCCustomSimpleListbox.IsEditing: Boolean;
begin
  Result := not FInEditShow and (FInplaceEditor <> nil);
end;

function TSCCustomSimpleListbox.GetEditText: String;
begin
  Result := '';
  if FInplaceEditor <> nil then
    Result := TSCListboxEdit(FInplaceEditor).Text;
end;

procedure TSCCustomSimpleListbox.SetEditText(const Value: String);
begin
  if FInplaceEditor <> nil then
    TSCListboxEdit(FInplaceEditor).Text := Value;
end;

function TSCCustomSimpleListbox.GetInplaceEditorClass: TSCCustomEditClass;
begin
  Result := FInplaceEditorClass;
end;

procedure TSCCustomSimpleListbox.SetInplaceEditorClass(Value: TSCCustomEditClass);
var
  InEdit: Boolean;
begin
  if FInplaceEditorClass <> Value then
  begin
    InEdit := FInplaceEditor <> nil;

    FInplaceEditorClass := Value;

    if InEdit then
    begin
      PostEditor;
      ShowEditor;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.MakeVisible(Index: Integer);
var
  R, CR: TRect;
  InView: Boolean;
  Ind, Tp, Col: Integer;
begin
  if (Index > -1) and (Index < FItems.Count) then
  begin
    InView := ItemInView(Index, False);

    if FColumns > 0 then
    begin
      SetTopIndex(0);
      if InView then
        Exit;

      Tp := FHorizontalPos;
      VerifyHorizontalPos(Tp);

      Col := GetColumnOf(Index);
      if Col < Tp then
        SetHorizontalPos(Col)
      else
      if Col > Tp then
      begin
        Tp := GetPageUpIndex(Index);
        VerifyHorizontalPos(Tp);

        SetHorizontalPos(Tp);
      end;
    end else
    begin
      Ind := Indent*IndentLevel[Index];
      if Ind < 0 then Ind := 0;

      if InView then
      begin
        SetHorizontalPos(Ind);
        Exit;
      end;

      Tp := FTopIndex;
      VerifyTopIndex(Tp);

      if Index < Tp then
        SetTopIndex(Index)
      else
      if Index > Tp then
      begin
        Tp := GetPageUpIndex(Index);
        VerifyTopIndex(Tp);

        SetTopIndex(Tp);
      end;

      if Indent > 0 then
      begin
        R := ItemRect(Index, False);

        if (R.Top < CR.Bottom) and (R.Bottom > CR.Top) then
        begin
          Dec(Ind, FHorizontalPos);

          CR := ClientRect;
          if (Ind > CR.Right) or (Ind < CR.Left) then
            SetHorizontalPos(Ind + FHorizontalPos);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.HintWindowProc(var Message: TMessage);
var
  R: TRect;
  MDC, DC: HDC;
  PS: TPaintStruct;
begin
  if (Message.Msg = WM_PAINT) and (FHintIndex > -1) and
    (FHintIndex < FItems.Count) and (FHintWnd <> nil) and
    FHintWnd.HandleAllocated and Assigned(FOnPaintHint) then
  begin
    R := FHintWnd.ClientRect;

    if not IsRectEmpty(R) then
    begin
      MDC := Message.WParam;

      DC := MDC;
      if DC = 0 then
        DC := BeginPaint(FHintWnd.Handle, PS);
      try
        FHintWnd.Canvas.Lock;
        try
          FHintWnd.Canvas.Handle := DC;
          try
            TControlCanvas(FHintWnd.Canvas).UpdateTextFlags;
            FOnPaintHint(Self, FHintIndex, FHintWnd.Canvas, R, FHintText);
          finally
            FHintWnd.Canvas.Handle := 0;
          end;
        finally
          FHintWnd.Canvas.Unlock;
        end;
      finally
        if MDC = 0 then EndPaint(FHintWnd.Handle, PS);
      end;
      
      Exit;
    end;
  end;

  if Assigned(FHintOldWndProc) then
    FHintOldWndProc(Message);
end;

procedure TSCCustomSimpleListbox.InplaceWindowProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_KILLFOCUS:
    begin
      PostEditor;
      Exit;
    end;
    WM_KEYDOWN:
    begin
      case Message.WParam of
        VK_ESCAPE:
        begin
          HideEditor;
          Exit;
        end;
        VK_RETURN:
        begin
          PostEditor;
          Exit;
        end;
      end;
    end;
  end;

  if Assigned(FInplaceOldWndProc) then
    FInplaceOldWndProc(Message);
end;

procedure TSCCustomSimpleListbox.InplaceChanged(Sender: TObject);
begin
  MakeVisible(FItemIndex);
end;

procedure TSCCustomSimpleListbox.ImageListChange(Sender: TObject);
var
  W, H: LongInt;
begin
  if FShowItemImages and not InItemUpdate and (FItems.Count > 0) then
  begin
    Invalidate;
    if FColumns < 1 then
      UpdateBounds(W, H);
  end;
end;

procedure TSCCustomSimpleListbox.PrepareEditor;
var
  ABorder: TSCControlBorder;
  ATransparency: Boolean;
  ABorderColor, AColor, AFontColor: TColor;
begin
  if FInplaceEditor <> nil then
  begin
    ABorder := sccbFlat;
    ABorderColor := clBtnShadow;
    AColor := clWindow;
    AFontColor := Self.Font.Color;
    ATransparency := False;

    if Assigned(FOnPrepareEditor) then
      FOnPrepareEditor(Self, ABorder, ABorderColor, AColor, AFontColor, ATransparency);

    with TSCFakedControl(FInplaceEditor) do
    begin
      AutoSize := False;
      Border := ABorder;
      FlatColor := ABorderColor;
      BorderInner := sccbNone;
      Color := AColor;
      Transparent := ATransparency;
      Font := Self.Font;
      Font.Color := AFontColor;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.SizeEditor;
var
  CR, R: TRect;
  Ind, CbW: Integer;
begin
  if IsEditing and (FItemIndex > -1) and (FItemIndex < FItems.Count) then
  begin
    R := ItemRect(FItemIndex, False);
    if FShowCheckboxes then
    begin
      CbW := GetCheckWidth;
      Inc(R.Left, CbW);
    end;

    if FColumns < 1 then
    begin
      Ind := Indent*IndentLevel[FItemIndex];
      if Ind < 0 then Ind := 0;

      Dec(Ind, FHorizontalPos);
      Inc(R.Left, Ind);
    end;  

    if FShowItemImages and (Images <> nil) and (Images.Width > 0) then
      Inc(R.Left, Images.Width + 2);


    if R.Left > R.Right then R.Right := R.Left;
    DoSizeEditor(FItemIndex, R);

    CR := ClientRect;
    if FColumns < 1 then
    begin
      if R.Left < CR.Left then R.Left := CR.Left;
      if R.Right > CR.Right then R.Right := CR.Right;
    end else
    begin
      if R.Top < CR.Top then R.Top := CR.Top;
      if R.Bottom > CR.Bottom then R.Bottom := CR.Bottom;
    end;

    if R.Left > R.Right  then R.Right := R.Left;
    if R.Top  > R.Bottom then R.Bottom := R.Top;


    if FInplaceEditor <> nil then
      FInplaceEditor.BoundsRect := R;
  end;
end;

procedure TSCCustomSimpleListbox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (AComponent <> nil) and (Operation = opRemove) then
  begin
    if AComponent = FHintWnd then
    begin
      FHintIndex := -1;
      FHintText := '';

      FHintWnd.WindowProc := FHintOldWndProc;
      FHintOldWndProc := nil;

      FHintWnd := nil;
    end else
    if AComponent = FInplaceEditor then
    begin
      FEditSavedText := '';
      FInplaceEditor.WindowProc := FInplaceOldWndProc;
      FInplaceOldWndProc := nil;

      FInplaceEditor := nil;

      if CanFocus then
        SetFocus;
    end;
  end;
end;

function TSCCustomSimpleListbox.GetCheckWidth: Integer;
begin
  Result := 17;
end;

function TSCCustomSimpleListbox.GetState(Index: Integer): TSCCheckState;
begin
  Result := sccbUnchecked;
  if (Index > -1) and (Index < FItems.Count) then
    Result := DataToState(TSCListStrings(FItems).Data[Index, 4]);
end;

procedure TSCCustomSimpleListbox.SetState(Index: Integer; Value: TSCCheckState);
begin
  TSCListStrings(FItems).OnChange := nil;
  try
    TSCListStrings(FItems).Data[Index, 4] := StateToData(Value);

    if FShowCheckboxes and not InItemUpdate and ItemInView(Index) then
      Invalidate;
  finally
    TSCListStrings(FItems).OnChange := ItemsChanged;
  end;

  DoInternalDataChanged(Index);
  ClickCheck(Index);
end;

function TSCCustomSimpleListbox.SwitchState(St: TSCCheckState): TSCCheckState;
begin
  case St of
    sccbUnchecked:
      if FAllowGrayed then
        Result := sccbGrayed else
        Result := sccbChecked;
    sccbGrayed:
      Result := sccbChecked;
    else
      Result := sccbUnchecked;
  end;
end;

procedure TSCCustomSimpleListbox.ShowHintWindow(P: TPoint; CheckHintSize: Boolean);
var
  R, CR, HR: TRect;
  AllowShow: Boolean;
  CbxW, L, W: Integer;
  {$IFDEF SC_DELPHI4_AND_EARLY}
  NonClientMetrics: TNonClientMetrics;
  {$ENDIF}
begin
  if ItemHintLocked or IsDesigning or not (FShowItemHints and
    HandleAllocated and Visible and IsWindowVisible(Self.Handle)) then
    Exit;

  AllowShow := False;
  try
    CR := GetClientRect;
    if IsRectEmpty(CR) then
      Exit;

    FHintIndex := ItemAtPos(P.X, P.Y, False);
    if FHintIndex > -1 then
    begin
      FHintText := Strings[FHintIndex];

      if FHintText <> '' then
      begin
        R := ItemRect(FHintIndex, True);
        if R.Left < CR.Left then
          R.Left := CR.Left;

        if IsRectEmpty(R) then
          Exit;

        CbxW := 0;
        if FShowCheckboxes then
        begin
          CbxW := GetCheckWidth;
          if CbxW < 0 then CbxW := 0;
        end;

        Canvas.Font.Assign(Self.Font);
        W := Canvas.TextWidth(FHintText) + 4 + CbxW;

        L := 0;
        if FColumns < 1 then
        begin
          L := Indent*IndentLevel[FHintIndex];
          if L < 0 then L := 0;
        end;

        if FShowItemImages and (Images <> nil) and (Images.Width > 0) then
          Inc(L, Images.Width + 2);

        if (FColumns = 0) and (FHorizontalPos > 0) then
          Dec(L, FHorizontalPos);

        Inc(CR.Left, L);

        HR := CR;
        if (FColumns = 0) and (FHorizontalPos > 0) then
          OffsetRect(HR, FHorizontalPos, 0);

        if CheckHintSize and ((W > HR.Right - HR.Left) or
          ((FHorizontalPos <> 0) and (W - FHorizontalPos > 0))) then
        begin
          AllowShow := True;
          scApplicationCancelHint;

          if FHintWnd = nil then
          begin
            FHintWnd := THintWindow.Create(Self);
            FHintWnd.FreeNotification(Self);

            FHintOldWndProc := FHintWnd.WindowProc;
            FHintWnd.WindowProc := HintWindowProc;
          end;

          with FHintWnd do
          begin
            Color := Application.HintColor;
            
            {$IFDEF SC_DELPHI4_AND_EARLY}
            NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
            if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
              Canvas.Font.Handle := CreateFontIndirect(NonClientMetrics.lfStatusFont)
            else
              Canvas.Font.Size := 8;
            {$ELSE}
            Canvas.Font.Assign(Screen.HintFont);
            {$ENDIF}
          end;

          CR := FHintWnd.CalcHintRect(Screen.Width, FHintText, nil);
          OffsetRect(CR, -CR.Left, -CR.Top);

          R.TopLeft := Self.ClientToScreen(R.TopLeft);
          R.Bottom := R.Top  + CR.Bottom;
          R.Right  := R.Left + CR.Right;

          OffsetRect(R, L + CbxW, -2);

          if Assigned(FOnShowItemHint) then
          begin
            FOnShowItemHint(Self, FHintIndex, R, FHintText, AllowShow);
            if not AllowShow then
              Exit;

            if IsRectEmpty(R) then
            begin
              AllowShow := False;
              Exit;
            end;
          end;

          if R.Right > Screen.Width then
            OffsetRect(R, Screen.Width - R.Right, 0);

          if R.Left < 0 then
            OffsetRect(R, -R.Left, 0);

          if R.Bottom > Screen.Height then
            OffsetRect(R, 0, Screen.Height - R.Bottom);

          if R.Top < 0 then
            OffsetRect(R, 0, -R.Top);

          GetWindowRect(FHintWnd.Handle, CR);

          if not IsWindowVisible(FHintWnd.Handle) or
            not ((R.Left = CR.Left) and (R.Top = CR.Top)) then
            FHintWnd.ActivateHint(R, FHintText);
        end;
      end;
    end;
  finally
    if not AllowShow then
      HideHintWindow;
  end;
end;

procedure TSCCustomSimpleListbox.HideHintWindow;
begin
  if FHintWnd <> nil then
  begin
    FHintIndex := -1;
    FHintText := '';

    FHintWnd.WindowProc := FHintOldWndProc;

    FHintWnd.ReleaseHandle;
    FHintWnd := nil;
  end;
end;

procedure TSCCustomSimpleListbox.SetHotIndex(Value: Integer; DoUpdate: Boolean);
begin
  VerifyIndex(Value);

  if FHotIndex <> Value then
  begin
    FHotIndex := Value;

    if FHotTrack and DoUpdate and not IsEditing then
      Invalidate;

    DoHotChange;
    if Assigned(FOnHottrack) then
      FOnHottrack(Self, FHotIndex);
  end;
end;

procedure TSCCustomSimpleListbox.DoHotChange;
begin
  //
end;

procedure TSCCustomSimpleListbox.ColorsChanged;
begin
  //
end;

procedure TSCCustomSimpleListbox.WMTimer(var Message: TWMTimer);
var
  R: TRect;
  P: TPoint;
  Dif, AIndex, OldIndex, ScrollDelay: Integer;
begin
  inherited;

  if HandleAllocated and (Message.TimerID = SC_LIST_CLICK_TIMERID) then
  begin
    KillClickTimer;
    if not IsEditing and (FAllowEdit and FAllowMouseEdit) then
      ShowEditor;
  end else
  if HandleAllocated and Scrolling and
    (Message.TimerID = SC_LISTSCROLL_TIMERID) then
  begin
    ScrollDelay := 60;

    if (FItems.Count <= 1) or
      not (Enabled and GetCursorPos(P)) then
    begin
      StopScrolling;
      Exit;
    end;

    P := Self.ScreenToClient(P);

    Dif := 0;
    R := GetClientRect;

    if FColumns = 0 then
    begin
      if P.y > R.Bottom then
      begin
        SetTopIndex(FTopIndex + 1);
        Dif := Abs(R.Bottom - P.y);

        AIndex := LastVisibleItem(False);
        if AIndex < FItemIndex then
          AIndex := FItemIndex;

        OldIndex := FItemIndex;

        VerifyIndex(AIndex);
        SetItemIndex(AIndex);

        if (OldIndex = FItemIndex) and (FItemIndex = FItems.Count - 2) then
          SetItemIndex(FItems.Count - 1);
      end else
      if P.y < R.Top then
      begin
        SetTopIndex(FTopIndex - 1);
        Dif := Abs(R.Top - P.y);

        SetItemIndex(FTopIndex);
      end;

      if Dif >= 50 then
        ScrollDelay := 20
      else
      if Dif >= 25 then
        ScrollDelay := 40;
    end else
    begin
      if P.x > R.Right then
      begin
        SetHorizontalPos(FHorizontalPos + 1);
        Dif := Abs(R.Right - P.x);
      end else
      if P.x < R.Left then
      begin
        SetHorizontalPos(FHorizontalPos - 1);
        Dif := Abs(R.Left - P.x);
      end;

      ScrollDelay := 150;
      if Dif >= 50 then
        ScrollDelay := 50
      else
      if Dif >= 25 then
        ScrollDelay := 100;
    end;

    if FScrollTimer <> -1 then
      KillTimer(Handle, FScrollTimer);

    FScrollTimer := SetTimer(Handle, SC_LISTSCROLL_TIMERID, ScrollDelay, nil);
    FScrolling := FScrollTimer <> -1;
  end;
end;

procedure TSCCustomSimpleListbox.PauseScrolling;
begin
  FScrolling := False;
end;

procedure TSCCustomSimpleListbox.ResumeScrolling;
begin
  FScrolling := (FScrollTimer <> -1) and Enabled and (FMouseDownIndex > -1);
end;

function TSCCustomSimpleListbox.Scrolling: Boolean;
begin
  Result := Enabled and FScrolling and (FMouseDownIndex > -1) and
    (FScrollTimer <> -1);
end;

function TSCCustomSimpleListbox.ScrollPaused: Boolean;
begin
  Result := not (Enabled and FScrolling and (FMouseDownIndex > -1)) and
    (FScrollTimer <> -1);
end;

procedure TSCCustomSimpleListbox.StartScrolling;
var
  R: TRect;
  P: TPoint;
  Dif, ScrollDelay: Integer;
begin
  if HandleAllocated then
  begin
    if not Enabled then
    begin
      StopScrolling;
      Exit;
    end;

    if ScrollPaused then
    begin
      ResumeScrolling;
      Exit;
    end;

    if not Scrolling then
    begin
      ScrollDelay := 60;
      StopScrolling;

      R := GetClientRect;

      if GetCursorPos(P) then
        P := Self.ScreenToClient(P)
      else begin
        P.x := R.Left + ((R.Right - R.Left) div 2);
        P.y := R.Top  + ((R.Bottom - R.Top) div 2);
      end;

      Dif := 0;
      if FColumns = 0 then
      begin
        if P.y > R.Bottom then
        begin
          SetTopIndex(FTopIndex + 1);
          Dif := Abs(R.Bottom - P.y);
        end else
        if P.y < R.Top then
        begin
          SetTopIndex(FTopIndex - 1);
          Dif := Abs(R.Top - P.y);
        end;
      end else
      begin
        if P.x > R.Right then
        begin
          SetHorizontalPos(FHorizontalPos + 1);
          Dif := Abs(R.Right - P.x);
        end else
        if P.y < R.Top then
        begin
          SetHorizontalPos(FHorizontalPos - 1);
          Dif := Abs(R.Left - P.x);
        end;
      end;

      if Dif >= 50 then
        ScrollDelay := 20
      else
      if Dif >= 25 then
        ScrollDelay := 40;

      if FScrollTimer <> -1 then
        KillTimer(Handle, FScrollTimer);

      FScrollTimer := SetTimer(Handle, SC_LISTSCROLL_TIMERID, ScrollDelay, nil);
      FScrolling := FScrollTimer <> -1;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.StopScrolling;
begin
  FScrolling := False;
  if FScrollTimer <> -1 then
  begin
    if HandleAllocated then
      KillTimer(Handle, FScrollTimer);

    FScrollTimer := -1;
    Invalidate;
  end;
end;

function TSCCustomSimpleListbox.GetMaxWidth: Integer;
var
  W, I, Ind: Integer;
  Item: PSCStringItem;
begin
  Result := 0;

  for I := 0 to FItems.Count - 1 do
  begin
    Item := TSCListStrings(FItems).List[I];

    Ind := Indent*Item^.FData[6];
    if Ind < 0 then Ind := 0;

    W := Item^.FData[1] + Ind;
    if W > Result then
      Result := W;
  end;
end;

procedure TSCCustomSimpleListbox.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;
  inherited SetIndent(Value);
end;

procedure TSCCustomSimpleListbox.IndentChanged;
begin
  if (FColumns < 1) and (FItems.Count > 0) and not InItemUpdate then
    Invalidate;
end;

function TSCCustomSimpleListbox.GetIndentLevel(Index: Integer): Integer;
begin
  Result := 0;
  if (Index > -1) and (Index < FItems.Count) then
  begin
    Result := TSCListStrings(FItems).Data[Index, 6];
    if Result < 0 then
      Result := 0;
  end;
end;

procedure TSCCustomSimpleListbox.SetIndentLevel(Index, Value: Integer);
var
  Ind: Integer;
begin
  if Value < 0 then
    Value := 0;

  Ind := TSCListStrings(FItems).Data[Index, 6];
  if Ind <> Value then
  begin
    TSCListStrings(FItems).OnChange := nil;
    try
      TSCListStrings(FItems).Data[Index, 6] := Value;

      if not InItemUpdate and (FColumns < 1) and
        (Indent > 0) and ItemInView(Index) then
        Invalidate;
    finally
      TSCListStrings(FItems).OnChange := ItemsChanged;
    end;
  end;
  
  DoInternalDataChanged(Index);
end;

function TSCCustomSimpleListbox.GetItemImage(Index: Integer): Integer;
begin
  Result := -1;
  if (Index > -1) and (Index < FItems.Count) then
  begin
    Result := TSCListStrings(FItems).Data[Index, 7];
    if Result < -1 then
      Result := -1;
  end;
end;

procedure TSCCustomSimpleListbox.SetItemImage(Index, Value: Integer);
var
  Img: Integer;
begin
  if Value < -1 then
    Value := -1;

  Img := TSCListStrings(FItems).Data[Index, 7];
  if Img <> Value then
  begin
    TSCListStrings(FItems).OnChange := nil;
    try
      TSCListStrings(FItems).Data[Index, 7] := Value;

      if not InItemUpdate and (Images <> nil) and ItemInView(Index) then
        Invalidate;
    finally
      TSCListStrings(FItems).OnChange := ItemsChanged;
    end;
  end;
  
  DoInternalDataChanged(Index);
end;

function TSCCustomSimpleListbox.ItemHintLocked: Boolean;
begin
  Result := FItemHintLock > 0;
end;

procedure TSCCustomSimpleListbox.LockItemHint;
begin
  Inc(FItemHintLock);
end;

procedure TSCCustomSimpleListbox.UnlockItemHint;
begin
  if FItemHintLock > 0 then
    Dec(FItemHintLock);
end;

procedure TSCCustomSimpleListbox.BeginItemUpdate;
begin
  if FItems <> nil then
    FItems.BeginUpdate;
end;

procedure TSCCustomSimpleListbox.EndItemUpdate;
begin
  if FItems <> nil then
    FItems.EndUpdate;
end;

function TSCCustomSimpleListbox.InItemUpdate: Boolean;
begin
  Result := (FItems <> nil) and TSCListStrings(FItems).InUpdate;
end;

procedure TSCCustomSimpleListbox.SetCenterImages(Value: Boolean);
begin
  if FCenterImages <> Value then
  begin
    FCenterImages := Value;

    if FShowItemImages and (Images <> nil) and
      not InItemUpdate and (FItems.Count > 0) then
      Invalidate;
  end;
end;

function TSCCustomSimpleListbox.GetItems: TStrings;
begin
  Result := FItems;
end;

function TSCCustomSimpleListbox.FindItem(const S: String;
  StartPos, EndPos: Integer): Integer;
var
  SubStr: String;
  I, J: Integer;
begin
  Result := -1;
  if not InItemUpdate and (FItems.Count > 0) then
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

    if StartPos > FItems.Count - 1 then
      StartPos := FItems.Count - 1;

    if EndPos > FItems.Count - 1 then
      EndPos := FItems.Count - 1;

    for I := 1 to Length(S) do
    begin
      SubStr := Copy(S, 1, I);
      for J := StartPos to EndPos do
        if AnsiSameText(SubStr, Copy(FItems.Strings[J], 1, I)) then
        begin
          Result := J;
          Break;
        end;
    end;
  end;
end;

function TSCCustomSimpleListbox.CompletedItem(const S: String;
  CaseSensitive: Boolean): Integer;
var
  I, Ln: Integer;
  Str, SubStr: String;
begin
  Result := -1;
  if not InItemUpdate and (FItems.Count > 0) and (S <> '') then
  begin
    Str := S;
    if not CaseSensitive then
      Str := AnsiLowerCase(Str);

    Ln := Length(Str);
    for I := 0 to FItems.Count-1 do
    begin
      SubStr := Copy(FItems.Strings[I], 1, Ln);
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

procedure TSCCustomSimpleListbox.DoItemClick(Index: Integer);
begin
  //
end;

procedure TSCCustomSimpleListbox.DoInternalDataChanged(Index: Integer);
begin
  //
end;

procedure TSCCustomSimpleListbox.DoInternalItemsChanged;
begin
  //
end;

function TSCCustomSimpleListbox.GetScrollbarClass: TSCCustomControlScrollbarClass;
begin
  Result := TSCListboxScrollbar;
end;

procedure TSCCustomSimpleListbox.DoScrollerPositionChanged(
  Kind: TSCScrollbarKind);
var
  Sb: TSCListboxScrollbar;
begin
  if FScrollPosChanging = 0 then
  begin
    Inc(FScrollbarChanging);
    try
      if Kind = scskHorizontal then
      begin
        Sb := TSCListboxScrollbar(ScrollbarHorz);
        SetHorizontalPos(Sb.Position);
      end else
      begin
        Sb := TSCListboxScrollbar(ScrollbarVert);
        SetTopIndex(Sb.Position);
      end;
    finally
      Dec(FScrollbarChanging);
    end;
  end;  
end;

procedure TSCCustomSimpleListbox.UpdateScrollbars(Horz, Vert: Boolean);
var
  WasHorz, IsVert, IsHorz: Boolean;
begin
  WasHorz := TSCListboxScrollbar(ScrollbarHorz).Visible;

  if Vert then UpdateVertScrollBar;
  if Horz then UpdateHorzScrollBar;

  IsVert := TSCListboxScrollbar(ScrollbarVert).Visible;
  IsHorz := TSCListboxScrollbar(ScrollbarHorz).Visible;

  if IsVert and (WasHorz <> IsHorz) then
    UpdateVertScrollBar;
end;

function TSCCustomSimpleListbox.CanScrollToPos(Kind: TSCScrollbarKind;
  var NewValue: Integer): Boolean;
begin
  Result := not IsEditing;
end;

function TSCCustomSimpleListbox.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCListBorderProps;
end;

function TSCCustomSimpleListbox.GetPicturePropsClass: TSCCustomPicturePropsClass;
begin
  Result := TSCListPictureProps;
end;

function TSCCustomSimpleListbox.GetListColorsClass: TSCListCustomColorsClass;
begin
  Result := TSCListColors;
end;

procedure TSCCustomSimpleListbox.SetColors(Value: TSCListCustomColors);
begin
  FColors.Assign(Value);
end;

function TSCCustomSimpleListbox.GetControlScrollbarsClass: TSCControlCustomScrollbarsClass;
begin
  Result := TSCListScrollbars;
end;

function TSCCustomSimpleListbox.LastVisibleItem(PartitialAllowed: Boolean): Integer;
var
  R, CR: TRect;
  Item: PSCStringItem;
  I, L, Cnt, TopIndx: Integer;
begin
  Result := -1;
  if FItems.Count > 0 then
  begin
    if FItems.Count = 1 then
    begin
      Result := 0;
      Exit;
    end;

    Result := FTopIndex;

    if FColumns > 0 then
    begin
      L := FHorizontalPos;
      VerifyHorizontalPos(L);

      if L < 0 then L := 0;

      Cnt := GetColumnHeight;
      if Cnt < 0 then
        Exit;

      if Cnt = 0 then
        Cnt := 1;

      TopIndx := L*Cnt;

      Result := ((L + FColumns)*Cnt) - 1;
      if Result > FItems.Count-1 then
        Result := FItems.Count-1;

      if Result < TopIndx then
        Result := TopIndx;
    end else
    begin
      TopIndx := FTopIndex;

      VerifyIndex(TopIndx);
      if TopIndx < 0 then
        TopIndx := 0;

      CR := GetClientRect;
      if not IsRectEmpty(CR) then
      begin
        R := CR;
        R.Bottom := R.Top;

        Result := TopIndx;
        for I := TopIndx to FItems.Count - 1 do
        begin
          Item := TSCListStrings(FItems).List[I];
          if Item^.FData[0] < 1 then
            Continue;

          Inc(R.Bottom, Item^.FData[0]);

          if R.Bottom >= CR.Bottom then
          begin
            Result := I;

            if not PartitialAllowed and (R.Bottom > CR.Bottom) then
            begin
              Dec(Result);
              if Result < TopIndx then
                Result := TopIndx;
            end;

            Break;
          end;
        end;

        if Result < TopIndx then
          Result := TopIndx;
      end;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.CanChangeCheckState(OldSt: TSCCheckState;
  var NewSt: TSCCheckState);
begin

end;

function TSCCustomSimpleListbox.CanChangeItemIndex(
  Index: Integer): Integer;
begin
  Result := Index;
end;

function TSCCustomSimpleListbox.CanEdit(Index: Integer): Boolean;
begin
  Result := GetItemEnabled(Index);
end;

function TSCCustomSimpleListbox.CreateItems: TStrings;
{$IFNDEF SC_CBUILDER}
var
  InitDatas: TSCStringDatas;
{$ENDIF}
begin
  Result := TSCListStrings.Create;
  with TSCListStrings(Result) do
  begin
    Duplicates := scdpAccept;
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
end;

procedure TSCCustomSimpleListbox.DoSetItems;
begin
  //
end;

procedure TSCCustomSimpleListbox.SetValues(Value: TStrings);
begin
  FValues.Assign(Value);
end;

procedure TSCCustomSimpleListbox.ValuesChanged(Sender: TObject);
begin
  //
end;

function TSCCustomSimpleListbox.GetSelectedValue: String;
begin
  Result := '';
  if FItemIndex > -1 then
  begin
    if FItemIndex < FValues.Count then
      Result := FValues[FItemIndex]
    else if FItemIndex < Items.Count then
      Result := Items[FItemIndex];
  end;
end;

procedure TSCCustomSimpleListbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomSimpleListbox then
  begin
    with TSCCustomSimpleListbox(Source) do
    begin
      Self.Items := Items;
      Self.AllowGrayed := AllowGrayed;
      Self.AllowEdit := AllowEdit;
      Self.AllowMouseEdit := AllowMouseEdit;
      Self.CenterImages := CenterImages;
      Self.Colors := Colors;
      Self.Columns := Columns;
      Self.ContinuousKeySearch := ContinuousKeySearch;
      Self.DisabledColor := DisabledColor;
      Self.DisabledTextColor := DisabledTextColor;
      Self.EndEllipsis := EndEllipsis;
      Self.ExtendedSelect := ExtendedSelect;
      Self.Flat := Flat;
      Self.HideFocusRect := HideFocusRect;
      Self.HideSelection := HideSelection;
      Self.HideSelectionBorderColor := HideSelectionBorderColor;
      Self.HideSelectionColor := HideSelectionColor;
      Self.HideSelectionTextColor := HideSelectionTextColor;
      Self.HighlightBorderColor := HighlightBorderColor;
      Self.HighlightColor := HighlightColor;
      Self.HighlightTextColor := HighlightTextColor;
      Self.HorizontalPos := HorizontalPos;
      Self.Hottrack := Hottrack;
      Self.HottrackColor := HottrackColor;
      Self.HottrackUnderline := HottrackUnderline;
      Self.ItemHeight := ItemHeight;
      Self.ItemIndex := ItemIndex;
      Self.Layout := Layout;
      Self.LineSelect := LineSelect;
      Self.MultiSelect := MultiSelect;
      Self.Revertable := Revertable;
      Self.ScrollbarHorizontal := ScrollbarHorizontal;
      Self.ScrollbarVertical := ScrollbarVertical;
      Self.ShowCheckboxes := ShowCheckboxes;
      Self.ShowItemHints := ShowItemHints;
      Self.ShowItemImages := ShowItemImages;
      Self.TopIndex := TopIndex;
      Self.Values := Values;
    end;
  end;
end;

procedure TSCCustomSimpleListbox.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    SortItems;
  end;
end;

procedure TSCCustomSimpleListbox.SortItems;
begin
  TSCStringList(FItems).Sorted := FSorted;
end;

procedure TSCCustomSimpleListbox.ProcessSearchKey(Key: Char);
var
  S: String;
  Tick: DWord;
  Index, StartPos: Integer;
begin
  if FShowCheckboxes and (Ord(Key) = VK_SPACE) then
  begin
    FSearchText := '';
    FSearchTickCount := 0;

    Exit;
  end;
    
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
      StartPos := FItemIndex + 1;
    end else
    begin
      Tick := GetTickCount;

      S := FSearchText;
      FSearchText := Key;

      if (FSearchTickCount = 0) or (Tick - FSearchTickCount < DWord(scKeyBoardDelay)) then
        FSearchText := S + Key;

      FSearchTickCount := Tick;

      S := FSearchText;
      StartPos := FItemIndex;
    end;

    Index := FindItem(S, StartPos, Count - 1);
    if (Index = -1) and (FItemIndex > -1) then
      Index := FindItem(S, 0, StartPos - 1);

    if Index > -1 then
    begin
      SetItemIndex(Index);
      MakeVisible(Index);
    end;
  end;
end;

procedure TSCCustomSimpleListbox.SetContinuousKeySearch(Value: Boolean);
begin
  if FContinuousKeySearch <> Value then
  begin
    FContinuousKeySearch := Value;

    FSearchText := '';
    FSearchTickCount := 0;
  end;
end;

procedure TSCCustomSimpleListbox.SetAlternateColor(Value: TColor);
begin
  if FAlternateColor <> Value then
  begin
    FAlternateColor := Value;
    if not InItemUpdate and (FItems.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomSimpleListbox.SetLayout(Value: TSCLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    if Count > 0 then
      Invalidate;
  end;
end;

procedure TSCCustomSimpleListbox.KillClickTimer;
var
  Timer: Integer;
begin
  if FClickTimer <> -1 then
  begin
    Timer := FClickTimer;
    FClickTimer := -1;

    if HandleAllocated then
      KillTimer(Self.Handle, Timer);
  end;
end;

procedure TSCCustomSimpleListbox.InitiateClickTimer;
begin
  if HandleAllocated and (FClickTimer = -1) and (FAllowEdit and FAllowMouseEdit) then
    FClickTimer := SetTimer(Self.Handle, SC_LIST_CLICK_TIMERID,
      GetDoubleClickTime, nil);
end;

procedure TSCCustomSimpleListbox.DrawOffice12Face(ACanvas: TCanvas;
  ARect: TRect; AColor: TColor; AFace, AFrame: Boolean);
var
  R: TRect;
  ClStart, ClEnd: TColor;
begin
  if (AColor <> clNone) and not IsRectEmpty(ARect) then
  begin
    AColor := BlendedColor(AColor, 16, 16, 16, True);

    if AFace then
    begin
      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AColor;

        FillRect(ARect);
      end;

      R := ARect;
      Dec(R.Bottom, Round((R.Bottom - R.Top)/4));

      ClEnd := AColor;
      ClStart := GetGradientPeal(AColor);

      scDrawGradient(ACanvas, R, scgTopToBottom, ClStart, ClEnd);

      R := ARect;
      Inc(R.Top, (R.Bottom - R.Top) div 2);

      if not IsRectEmpty(R) then
      begin
        ClStart := GetGradientShadow(AColor);
        ClEnd := GetGradientLight(AColor);

        scDrawGradient(ACanvas, R, scgTopToBottom, ClStart, ClEnd);
      end;
    end;

    if AFrame then
    begin
      R := ARect;

      ClStart := GetGradientPreLight(AColor);
      scFrame3D(ACanvas, R, ClStart, ClStart, 1, 0);

      R := ARect;

      ClStart := GetGradientPreDark(AColor);
      scFrame3D(ACanvas, R, ClStart, ClStart, 1, 2);

      ClStart := GetGradientExLight(AColor);
      scFrame3D(ACanvas, R, ClStart, ClStart, 1, 0);
    end;
  end;
end;

function TSCCustomSimpleListbox.GetGradientDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -32);
end;

function TSCCustomSimpleListbox.GetGradientExDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -40);
end;

function TSCCustomSimpleListbox.GetGradientExLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 40);
end;

function TSCCustomSimpleListbox.GetGradientLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 30);
end;

function TSCCustomSimpleListbox.GetGradientPeal(AColor: TColor): TColor;
begin
  Result := BlendedColor(AColor, 52, 44, 112, True);
end;

function TSCCustomSimpleListbox.GetGradientPreDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -80);
end;

function TSCCustomSimpleListbox.GetGradientPreLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 80);
end;

function TSCCustomSimpleListbox.GetGradientShadow(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -6);
end;

procedure TSCCustomSimpleListbox.SetOffice12Style(Value: Boolean);
begin
  if FOffice12Style <> Value then
  begin
    FOffice12Style := Value;
    Invalidate;
  end;
end;

{ TSCListboxExItem }

procedure TSCListboxExItem.Assign(Source: TPersistent);
begin
  if Source is TSCListboxExItem then
  begin
    with TSCListboxExItem(Source) do
    begin
      Self.FEnabled := Enabled;
      Self.FImageIndex  := ImageIndex;
      Self.FIndentLevel := IndentLevel;
      Self.FState := State;
      Self.FText  := Text;
      Self.FValue := Text;
      Self.FData  := Data;
    end;

    Changed(False);
  end else
    inherited Assign(Source);
end;

constructor TSCListboxExItem.Create(Collection: TCollection);
begin
  FEnabled := True;
  FImageIndex := -1;
  FIndentLevel := 0;
  FState := sccbUnchecked;
  inherited Create(Collection);
end;

function TSCListboxExItem.GetChecked: Boolean;
begin
  Result := FState = sccbChecked;
end;

function TSCListboxExItem.GetDisplayName: string;
begin
  Result := Text;
  if Result = '' then
  begin
    Result := Value;
    if Result = '' then
      Result := inherited GetDisplayName;
  end;
end;

function TSCListboxExItem.GetImages: TCustomImageList;
var
  AOwner: TSCCustomListboxEx;
begin
  Result := nil;

  AOwner := GetListboxEx;
  if AOwner <> nil then
    Result := AOwner.Images;
end;

function TSCListboxExItem.GetListboxEx: TSCCustomListboxEx;
begin
  Result := nil;
  if (Collection <> nil) and (Collection is TSCListboxExItems) then
    Result := TSCListboxExItems(Collection).FOwner;
end;

procedure TSCListboxExItem.SetChecked(Value: Boolean);
begin
  if GetChecked <> Value then
  begin
    if Value then
      State := sccbChecked
    else
      State := sccbUnchecked;
  end;
end;

procedure TSCListboxExItem.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed(False);
  end;
end;

procedure TSCListboxExItem.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed(False);
  end;
end;

procedure TSCListboxExItem.SetIndentLevel(Value: Integer);
begin
  if FIndentLevel <> Value then
  begin
    FIndentLevel := Value;
    Changed(False);
  end;
end;

procedure TSCListboxExItem.SetState(Value: TSCCheckState);
begin
  if FState <> Value then
  begin
    FState := Value;
    Changed(False);
  end;
end;

procedure TSCListboxExItem.SetText(const Value: String);
begin
  if FText <> Value then
  begin
    FText := Value;
    Changed(False);
  end;
end;

procedure TSCListboxExItem.SetValue(const Value: String);
begin
  if FValue <> Value then
  begin
    FValue := Value;
    Changed(False);
  end;
end;

{ TSCListboxExItems }

function TSCListboxExItems.Add: TSCListboxExItem;
begin
  Result := TSCListboxExItem(inherited Add);
end;

constructor TSCListboxExItems.Create(AOwner: TSCCustomListboxEx);
begin
  inherited Create(TSCListboxExItem);
  FOwner := AOwner;
end;

function TSCListboxExItems.GetItem(Index: Integer): TSCListboxExItem;
begin
  Result := TSCListboxExItem(inherited GetItem(Index));
end;

function TSCListboxExItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCListboxExItems.IndexOf(const S: String;
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

function TSCListboxExItems.IndexOfValue(const S: String;
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

procedure TSCListboxExItems.SetItem(Index: Integer;
  Value: TSCListboxExItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCListboxExItems.Update(Item: TCollectionItem);
begin
  if Owner <> nil then
    TSCCustomListboxEx(Owner).ExItemChanged(TSCListboxExItem(Item));
end;

{ TSCCustomListboxEx }

procedure TSCCustomListboxEx.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomListboxEx then
    with TSCCustomListboxEx(Source) do
      Self.ItemsEx := ItemsEx;
end;

constructor TSCCustomListboxEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItemsEx := TSCListboxExItems.Create(Self);
end;

destructor TSCCustomListboxEx.Destroy;
begin
  FItemsEx.Free;
  inherited Destroy;
end;

procedure TSCCustomListboxEx.DoExItemChanged(Item: TSCListboxExItem);
begin
  //
end;

procedure TSCCustomListboxEx.DoExItemsChanged;
begin
  //
end;

procedure TSCCustomListboxEx.DoInternalDataChanged(Index: Integer);
var
  Item: TSCListboxExItem;
begin
  if (Index > FItemsEx.Count-1) or (FItems.Count <> FItemsEx.Count) then
    DoInternalItemsChanged
  else
  if (FInExChange = 0) and (Index > -1) then
  begin
    Inc(FInExChange);
    try
      Item := FItemsEx.Items[Index];

      with TSCListStrings(FItems) do
      begin
        Item.FText    := Strings[Index];
        Item.FState   := DataToState(Data[Index, 4]);
        Item.FEnabled := Data[Index, 5] = 0;
        Item.FImageIndex := Data[Index, 7];
        Item.FIndentLevel := Data[Index, 6];
      end;
    finally
      Dec(FInExChange);
    end;

    DoExItemChanged(Item);
  end;
end;

procedure TSCCustomListboxEx.DoInternalItemsChanged;
var
  I: Integer;
  Item: TSCListboxExItem;
begin
  if FInExChange > 0 then
    Exit;

  Inc(FInExChange);
  try
    FItemsEx.BeginUpdate;
    try
      if FItems.Count = 0 then
        FItemsEx.Clear
      else begin
        for I := 0 to FItems.Count-1 do
        begin
          if I > FItemsEx.Count-1 then
            Item := FItemsEx.Add
          else
            Item := FItemsEx[I];

          with TSCListStrings(FItems) do
          begin
            Item.FText    := Strings[I];
            Item.FState   := DataToState(Data[I, 4]);
            Item.FEnabled := Data[I, 5] = 0;
            Item.FImageIndex := Data[I, 7];
            Item.FIndentLevel := Data[I, 6];
          end;
        end;

      {$IFDEF SC_DELPHI5_AND_EARLY}
        while FItemsEx.Count > FItems.Count do
          FItemsEx[FItemsEx.Count-1].Free;
      {$ELSE}
        while FItemsEx.Count > FItems.Count do
          FItemsEx.Delete(FItemsEx.Count-1);
      {$ENDIF}
      end;
    finally
      FItemsEx.EndUpdate;
    end;
  finally
    Dec(FInExChange);
  end;

  DoExItemsChanged;
end;

procedure TSCCustomListboxEx.ExItemChanged(Item: TSCListboxExItem);
var
  W, H: LongInt;
  Index: Integer;
begin
  if (FInExChange > 0) or ((Item <> nil) and (Item.GetListboxEx <> Self)) then
    Exit;

  if (Item = nil) or (Item.Index > FItems.Count-1) then
    ExItemsChanged
  else begin
    Inc(FInExChange);
    try
      Index := Item.Index;
      if IsEditing and (FItemIndex = Index) then
        HideEditor;

      TSCListStrings(FItems).OnChange := nil;
      try
        with TSCListStrings(FItems) do
        begin
          Strings[Index] := Item.FText;
          Data[Index, 4] := StateToData(Item.FState);
          Data[Index, 5] := Integer(not Item.FEnabled);
          Data[Index, 6] := Item.FIndentLevel;
          Data[Index, 7] := Item.FImageIndex;
        end;

        if not InItemUpdate then
        begin
          if ItemInView(Index) then
            Invalidate;

          UpdateBounds(W, H);
        end;
      finally
        TSCListStrings(FItems).OnChange := ItemsChanged;
      end;

      ClickCheck(Item.Index);
    finally
      Dec(FInExChange);
    end;
    
    DoExItemChanged(Item);
  end;
end;

procedure TSCCustomListboxEx.ExItemsChanged;
var
  Item: TSCListboxExItem;
  W, H: LongInt;
  Index, I: Integer;
begin
  if FInExChange > 0 then
    Exit;

  Inc(FInExChange);
  try
    HideEditor;
    HideHintWindow;

    TSCListStrings(FItems).OnChange := nil;
    try
      FItems.BeginUpdate;
      try
        if FItemsEx.Count = 0 then
          FItems.Clear
        else begin
          for I := 0 to FItemsEx.Count-1 do
          begin
            Item := FItemsEx.Items[I];

            if I > FItems.Count-1 then
              Index := TSCListStrings(FItems).Add(Item.Text)
            else begin
              Index := I;
              TSCListStrings(FItems).Strings[Index] := Item.Text;
            end;

            with TSCListStrings(FItems) do
            begin
              Data[Index, 4] := StateToData(Item.FState);
              Data[Index, 5] := Integer(not Item.FEnabled);
              Data[Index, 6] := Item.FIndentLevel;
              Data[Index, 7] := Item.FImageIndex;
            end;
          end;

          while FItems.Count > FItemsEx.Count do
            FItems.Delete(FItems.Count-1);
        end;

        UpdateBounds(W, H);
      finally
        FItems.EndUpdate;
      end;
    finally
      TSCListStrings(FItems).OnChange := ItemsChanged;
    end;
  finally
    Dec(FInExChange);
  end;

  DoExItemsChanged;
end;

function TSCCustomListboxEx.GetSelectedValue: String;
begin
  Result := '';
  if (FItemIndex > 0) and (FItemIndex < FItemsEx.Count) then
    Result := FItemsEx[FItemIndex].Value;
end;

procedure TSCCustomListboxEx.SetItemsEx(Value: TSCListboxExItems);
begin
  FItemsEx.Assign(Value);
end;

{$I SCVerRec.inc}

end.