{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCTreeList;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ImgList,
  Forms, {$IFDEF SC_DELPHI6_UP} Variants, Types, {$ENDIF} SCCommon,
  SCControl, SCConsts, SCEdits;

type
  TSCTreeBehaviourOption = (sctboAllowEditing, sctboAllowSorting, sctboAnsiSort,
    sctboAutoDragMove, sctboAutoSort, sctboCellSelect, sctboClearColumnOnRemove,
    sctboColumnMoving, sctboColumnSizing, sctboCycleCells, sctboDblClickExpand,
    sctboDragCollapse, sctboDragExpand, sctboDragScroll, sctboGoToNextCellOnEnter,
    sctboGoToNextCellOnTab, sctboImmediateEditor, sctboMouseScroll, sctboMultiSelect,
    sctboRightClickSelect, sctboRowAutoHeight, sctboRowSelect, sctboRowSizing,
    sctboShowEditorOnEnter);

  TSCTreeBehaviourOptions = set of TSCTreeBehaviourOption;

  TSCTreeViewOption = (sctvoDrawEndEllipsis, sctvoGrouping,
    sctvoGroupOnlyFirstLevel, sctvoHideFocusRect, sctvoHideSelection,
    sctvoHottrack, sctvoShowButtons, sctvoShowCheckButtons,
    sctvoShowChildIndicator, sctvoShowEmptyButtons, sctvoShowFlagImages,
    sctvoShowHeader, sctvoShowHighlightFrame, sctvoShowHotImages,
    sctvoShowHourGlassOnAction, sctvoShowIndicator, sctvoShowLineHorizontal,
    sctvoShowLineVertical, sctvoShowNodeHints, sctvoShowPreview, sctvoShowRoot,
    sctvoShowSelectedImages, sctvoShowStateImages, sctvoShowTreeLine);

  TSCTreeViewOptions = set of TSCTreeViewOption;

const
  SCWaitForExpandTime = 500;

  SCDefaultBehaviourOptions = [sctboAllowEditing, sctboAllowSorting,
    sctboAutoDragMove, sctboClearColumnOnRemove, sctboDblClickExpand,
    sctboDragExpand, sctboDragScroll, sctboMouseScroll, sctboRowAutoHeight];

  SCDefaultViewOptions = [sctvoHottrack, sctvoShowButtons,
    sctvoShowCheckButtons, sctvoShowFlagImages, sctvoShowHotImages,
    sctvoShowNodeHints, sctvoShowRoot, sctvoShowSelectedImages,
    sctvoShowStateImages, sctvoShowTreeLine];

type
  TSCTreeNode = class;
  TSCTreeColumn = class;
  TSCCustomTreeList = class;
  TSCTreeEditorClass = TSCCustomEditClass;

  TSCTreeNodeArray = array of TSCTreeNode;

  TSCTreeNodeState = (sctnsNone, sctnsCut, sctnsCopy, sctnsFocused,
    sctnsHighlighted, sctnsSelected);

  TSCTreeNodeStates = set of TSCTreeNodeState;

  TSCTreePart = (sctpNowhere, sctpButton, sctpCheckButton, sctpColumn,
    sctpColumnSizer, sctpFlag, sctpHeader, sctpIcon, sctpIndent, sctpIndicator,
    sctpLabel, sctpLevelIndent, sctpPreview, sctpRowSizer, sctpStateIcon);

  TSCTreeParts = set of TSCTreePart;

  TSCTreeCell = record
    Node: TSCTreeNode;
    Column: TSCTreeColumn;
  end;

  TSCTreeHitInfo = record
    Pos: TPoint;
    Part: TSCTreePart;
    Node: TSCTreeNode;
    Column: TSCTreeColumn;
  end;

  TSCTreeListState = (sctlsIdle, sctlsColumnDown, sctlsColumnSizing,
    sctlsStartingDrag, sctlsColumnDragging, sctlsEditing, sctlsRowSizing,
    sctlsNodeDragging, sctlsNodeDown);

  TSCTreePaintStyle = (sctpsDefault, sctpsInspector, sctpsInspectorNet,
    sctpsInspectorSharp, sctpsOffice12, sctpsOutlook);

  TSCTreeCheckButton = (sctcbNone, sctcbCheckbox, sctcbRadioButton);

  TSCTreeCheckButtonState = (sctcsChecked, sctcsGrayed, sctcsUnchecked);

  TSCTreeCheckButtonStyle = (sctcsDefault, sctcsDouble, sctcsFlat, sctcsFlatEx,
    sctcsFlatFrame, sctcsMetal, sctcsNew);

  TSCTreeLookAndFeel = (sctlfDefault, sctlfFlat, sctlfFlatEx, sctlfGradient,
        sctlfOffice12);

  TSCTreeUpdatePart = (sctupNode, sctupAbove, sctupBelow);

  TSCTreeFlashPart = (sctfpButton, sctfpText, sctfpParent, sctfpUnderline);
  TSCTreeFlashParts = set of TSCTreeFlashPart;

  TSCTreeLineStyle = (sctlsDot, sctlsSolid);

  TSCTreeUnderlineStyle = (sctusDot, sctusDash, sctusSaw, sctusSolid,
    sctusTilda);

  TSCTreeSearchDirection = (sctsdAbove, sctsdBelow, sctsdAll);

  TSCTreeButtonStyle = (sctbs3D, sctbsDefault, sctbsFlat, sctbsXP,
    sctbsMac, sctbsOffice12);

  TSCTreeSortDirection = (sctsdNone, sctsdUp, sctsdDown);

  // events
  TSCTreeNodeEvent = procedure(Sender: TObject; ANode: TSCTreeNode) of object;
  TSCTreeCellEvent = procedure(Sender: TObject; ACell: TSCTreeCell) of object;

  TSCTreeNodeAcceptEvent = procedure(Sender: TObject; ANode: TSCTreeNode;
    var Allow: Boolean) of object;
  TSCTreeCellAcceptEvent = procedure(Sender: TObject; ACell: TSCTreeCell;
    var Allow: Boolean) of object;

  TSCTreeColumnEvent = procedure(Sender: TObject; AColumn: TSCTreeColumn) of object;

  TSCTreeColumnAcceptEvent = procedure(Sender: TObject; AColumn: TSCTreeColumn;
    var Allow: Boolean) of object;

  TSCTreeNodeCompareEvent = procedure(Sender: TObject; ANode1, ANode2: TSCTreeNode;
    var Compare: Integer) of object;

  TSCTreeHottrackEvent = procedure (Sender: TObject; AHotInfo: TSCTreeHitInfo;
    var ACursor: TCursor) of object;

  TSCTreeColumnMoveEvent = procedure(Sender: TObject; AColumn: TSCTreeColumn;
    FromIndex, ToIndex: Integer) of object;
  TSCTreeStartColumnDraggingEvent = procedure(Sender: TObject; AColumn: TSCTreeColumn) of object;
  TSCTreeDragAcceptColumnEvent = procedure(Sender: TObject; AColumn: TSCTreeColumn; P: TPoint; var Accept: Boolean) of object;
  TSCTreeEndDragColumnEvent = procedure(Sender : TObject; X, Y: Integer;
    Column: TSCTreeColumn; var NewPosition: Integer) of object;

  TSCTreeButtonStateEvent = procedure(Sender: TObject; ANode: TSCTreeNode;
    var AState: TSCTreeCheckButtonState; var Allow: Boolean) of object;

  TSCTreeNodeLevelEvent = procedure(Sender: TObject; ANode: TSCTreeNode;
    var ALevel: Integer) of object;

  TSCTreeValidateEditorEvent = procedure(Sender: TObject; ACell: TSCTreeCell;
    var Text: String; var AcceptEdit: Boolean) of object;

  TSCTreeGetEditorEvent = procedure(Sender: TObject; ACell: TSCTreeCell;
    var EditorClass: TSCTreeEditorClass) of object;

  TSCTreePrepareEditorEvent = procedure(Sender: TObject; ACell: TSCTreeCell;
    var AAlignment: TAlignment; var ABorder: TSCControlBorder;
    var ABorderColor, AColor, AFontColor: TColor) of object;

  TSCTreeSizeEditorEvent = procedure(Sender: TObject; ACell: TSCTreeCell;
    var EditRect: TRect) of object;

  TSCTreePaintHint = procedure(Sender: TObject; ACell: TSCTreeCell;
    ACanvas: TCanvas; ARect: TRect; HintText: String; var Handled: Boolean) of object;

  TSCTreeHintEvent = procedure(Sender: TObject; ACell: TSCTreeCell;
    var ARect: TRect; var HintText: String; var AllowShow: Boolean) of object;

  TSCTreePaintHeaderEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; var AColor: TColor; var Handled: Boolean) of object;

  TSCTreePaintColumnEvent = procedure(Sender: TObject; AColumn: TSCTreeColumn;
    ACanvas: TCanvas; ARect: TRect; var AColor, ASortArrow: TColor;
    var SortDir: TSCTReeSortDirection; var Handled: Boolean) of object;

  TSCTreePaintBackEvent = procedure(Sender: TObject; ANode: TSCTreeNode;
    ACanvas: TCanvas; ARect: TRect; var AColor: TColor;
    var Handled: Boolean) of object;

  TSCTreePaintFaceEvent = procedure(Sender: TObject; ANode: TSCTreeNode;
    ACanvas: TCanvas; ARect: TRect; var ABackColor: TColor;
    var AForeColor: TColor; var Handled: Boolean) of object;

  TSCTreePaintButtonEvent = procedure(Sender: TObject; ANode: TSCTreeNode;
    ACanvas: TCanvas; ARect: TRect; ASelected, AFocused: Boolean;
    var ABackColor: TColor; var AFrameColor: TColor; var AForeColor: TColor;
    var Handled: Boolean) of object;

  TSCTreePaintCheckButtonEvent = procedure(Sender: TObject; ANode: TSCTreeNode;
    ACanvas: TCanvas; ARect: TRect; var ABackColor: TColor; var AFaceColor: TColor;
    var AFrameColor: TColor; var AForeColor: TColor; var AHotColor: TColor;
    var AFocusColor: TColor; var Handled: Boolean) of object;

  TSCTreePaintImageEvent = procedure(Sender: TObject; ANode: TSCTreeNode;
    ACanvas: TCanvas; ARect: TRect; ASelected, AFocused, AHot: Boolean;
    var ABackColor: TColor; AImage: TImageIndex; var Handled: Boolean) of object;

  TSCTreePaintCellEvent = procedure(Sender: TObject; ACell: TSCTreeCell;
    ACanvas: TCanvas; ARect: TRect; ASelected, AFocused, AHot: Boolean;
    AFont: TFont; var AColor: TColor; var AText: string;
    var Handled: Boolean) of object;

  TSCTreePaintSelectionEvent = procedure(Sender: TObject; ACell: TSCTreeCell;
    ACanvas: TCanvas; ARect: TRect; ASelected, AFocused, AHot: Boolean;
    var AColor: TColor; var Handled: Boolean) of object;

  TSCTreePreviewEvent = procedure(Sender: TObject; ANode: TSCTreeNode;
    var Allow: Boolean) of object;

  TSCTreePaintPreviewEvent = procedure(Sender: TObject; ANode: TSCTreeNode;
    ACanvas: TCanvas; ARect: TRect; ASelected, AFocused, AHot: Boolean;
    AFont: TFont; var AColor: TColor; var AText: string;
    var Handled: Boolean) of object;

  TSCTreeNode = class(TPersistent)
  private
    FList: TList;
    FNodeList: TList;
    FIndexList: TList;
    FStrings: TList;
    FColor: TColor;
    FEnabled: Boolean;
    FExpanded: Boolean;
    FGroupHeader: Boolean;
    FTag: Integer;
    FHeight: Integer;
    FWidth: Integer;
    FRootNode: Boolean;
    FImageIndex: Integer;
    FHotIndex: TImageIndex;
    FFlagIndex: TImageIndex;
    FSelectedIndex: TImageIndex;
    FStateIndex: TImageIndex;
    FUnderline: Boolean;
    FUpdateCount: Integer;
    FDestroying: Boolean;
    FDeleting: Boolean;
    FParent: TSCTreeNode;
    FUseIndexList: Boolean;
    FAllowGrayed: Boolean;
    FSorting: Integer;
    FPreview: Boolean;
    FPreviewText: String;
    FButtonType: TSCTreeCheckButton;
    FButtonState: TSCTreeCheckButtonState;
    FOwner: TSCCustomTreeList;
    function  GetCount: Integer;
    function  GetIndex: Integer;
    function  GetChild(Index: Integer): TSCTreeNode;
    procedure SetColor(Value: TColor);
    procedure SetEnabled(Value: Boolean);
    procedure SetExpanded(Value: Boolean);
    function  GetFocused: Boolean;
    procedure SetFocused(Value: Boolean);
    procedure SetGroupHeader(Value: Boolean);
    procedure SetHeight(Value: Integer);
    procedure SetHotIndex(Value: TImageIndex);
    function  GetImageIndex: TImageIndex;
    procedure SetImageIndex(Value: TImageIndex);
    function  GetSelected: Boolean;
    procedure SetFlagIndex(Value: TImageIndex);
    procedure SetSelectedIndex(Value: TImageIndex);
    procedure SetStateIndex(Value: TImageIndex);
    procedure SetUnderline(Value: Boolean);
    procedure SetUseIndexList(Value: Boolean);
    procedure SetAllowGrayed(Value: Boolean);
    function  GetButtonState: TSCTreeCheckButtonState;
    procedure SetButtonState(Value: TSCTreeCheckButtonState);
    procedure SetButtonType(Value: TSCTreeCheckButton);
    function  GetSorting: Boolean;
    function  GetText: String;
    procedure SetText(const Value: String);
    function  GetString(Index: Integer): String;
    procedure SetString(Index: Integer; const Value: String);
    function  GetObject(Index: Integer): TObject;
    procedure SetObject(Index: Integer; const Value: TObject);
    function  GetData(Index: Integer): Integer;
    procedure SetData(Index: Integer; Value: Integer);
    procedure SetPreview(Value: Boolean);
    function  GetPreviewText: String;
    procedure SetPreviewText(const Value: String);

    function  GetUpdating: Boolean;

    function  GetLevel: Integer;
    function  CreateChildList: TList;

    procedure InsertingChild(ANode: TSCTreeNode);
    procedure RemovingChild(ANode: TSCTreeNode);

    procedure InsertChild(ANode: TSCTreeNode; Index: Integer); overload;
    procedure RemoveChild(ANode: TSCTreeNode);
    procedure SetOwner(AOwner: TSCCustomTreeList);

    procedure ChildInserted(ANode: TSCTreeNode);
    procedure ChildRemoved(ANode: TSCTreeNode);
    procedure ChildMoved(OldIndex, NewIndex: Integer);
    procedure ChildExchanged(Index1, Index2: Integer);

    function  GetHasChildren: Boolean;
    function  CreateNode: TSCTreeNode;

    procedure ExpandStrings(ACount: Integer);

    procedure ExpandNode(Expand: Boolean);
    function  CanExpand(Expand: Boolean): Boolean;
  protected
    procedure Destroying;
    function  GetOwner: TPersistent; override;

    procedure Paint(ACol: TSCTreeColumn; ACanvas: TCanvas; ARect: TRect;
      ASelected, AFocused, AHot: Boolean; AFont: TFont; var AColor: TColor;
      var AText: string; var Handled: Boolean); virtual;
    procedure PaintPreview(ACanvas: TCanvas; ARect: TRect; ASelected, AFocused,
      AHot: Boolean; AFont: TFont; var AColor: TColor; var AText: string;
      var Handled: Boolean); virtual;

    procedure ReadData1(AStream: TStream);
    procedure ReadData2(AStream: TStream);
    procedure ReadData3(AStream: TStream);

    procedure ReadData(AStream: TStream); virtual;
    procedure WriteData(AStream: TStream); virtual;

    procedure ArrangeNodeList;
    function  SearchNodeList(ANode: TSCTreeNode): Integer;

    procedure VerifyButtonState(var AState: TSCTreeCheckButtonState);

    procedure Changed;
    procedure HeightChanged;
    procedure TextChanged;
    procedure EnabledChanged;
    procedure ButtonTypeChanged;

    function  GetWidth: Integer;
    function  GetImages: TCustomImageList;
    function  GetFlagImages: TCustomImageList;
    function  GetStateImages: TCustomImageList;

    procedure DoChanged; virtual;
    procedure DoEnabledChanged; virtual;
    procedure DoHeightChanged; virtual;
    procedure DoTextChanged; virtual;
    procedure DoCheckButtonChanged; virtual;

    procedure Initialize; dynamic;
    procedure ResetNode(Recursive: Boolean);
    procedure MoveNodeValues(FromIndex, ToIndex: Integer);

    function  GetStringsCount: Integer;
    function  GetChildCount(All: Boolean = False): LongInt; virtual;
  public
    constructor Create(AOwner: TSCCustomTreeList); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Delete;
    procedure ClearData;

    procedure DeleteChildren;
    function  AddChild: TSCTreeNode;
    function  AddChildFirst: TSCTreeNode;
    function  IndexOf(ANode: TSCTreeNode): Integer;
    function  InsertChild(Index: Integer): TSCTreeNode; overload;
    procedure InsertChild(Index: Integer; ANode: TSCTreeNode); overload;
    function  InsertChild(BeforeNode: TSCTreeNode): TSCTreeNode; overload;
    procedure DeleteChild(Index: Integer); overload;
    function  Remove(ANode: TSCTreeNode): Integer;
    function  Extract(Index: Integer): TSCTreeNode;
    procedure Exchange(Index1, Index2: Integer);
    procedure Move(CurIndex, NewIndex: Integer);

    function  GetFirstChild: TSCTreeNode;
    function  GetLastChild: TSCTreeNode;
    function  GetNext: TSCTreeNode;
    function  GetNextVisible: TSCTreeNode;
    function  GetNextChild(ANode: TSCTreeNode): TSCTreeNode;
    function  GetNextSibling: TSCTreeNode;
    function  GetPrev: TSCTreeNode;
    function  GetPrevVisible: TSCTreeNode;
    function  GetPrevSibling: TSCTreeNode;
    function  GetPrevChild(ANode: TSCTreeNode): TSCTreeNode;
    function  GetPrevParentNode: TSCTreeNode;
    function  HasAsParent(Value: TSCTreeNode): Boolean;

    procedure MakeVisible;
    procedure Collapse(Recursive: Boolean);
    procedure Expand(Recursive: Boolean);

    function  EditText: Boolean;
    procedure EndEdit(Cancel: Boolean);

    procedure RemoveString(Index: Integer; Recursive: Boolean);
    procedure InsertString(Index: Integer; const S: String; Recursive: Boolean);

    function  GetNodeRect(TextOnly: Boolean): TRect;

    procedure BeginUpdate;
    procedure EndUpdate;

    property Sorting: Boolean read GetSorting;
    property Width: Integer read GetWidth;
    property RootNode: Boolean read FRootNode;
    property Owner: TSCCustomTreeList read FOwner;
    property Count: Integer read GetCount;
    property HasChildren: Boolean read GetHasChildren;
    property Parent: TSCTreeNode read FParent;
    property Index: Integer read GetIndex;
    property StringsCount: Integer read GetStringsCount;
    property Strings[Index: Integer]: String read GetString write SetString;
    property Objects[Index: Integer]: TObject read GetObject write SetObject;
    property Items[Index: Integer]: TSCTreeNode read GetChild; default;
    property Data[Index: Integer]: Integer read GetData write SetData;
    property Deleting: Boolean read FDeleting;
    property Level: Integer read GetLevel;
    property Updating: Boolean read GetUpdating;
    property InDestroy: Boolean read FDestroying;
    property Selected: Boolean read GetSelected;
    property Height: Integer read FHeight write SetHeight default -1;
    property UseIndexList: Boolean read FUseIndexList write SetUseIndexList default False;
  published
    property AllowGrayed: Boolean read FAllowGrayed write SetAllowGrayed default False;
    property ButtonState: TSCTreeCheckButtonState read GetButtonState write SetButtonState default sctcsUnchecked;
    property ButtonType: TSCTreeCheckButton read FButtonType write SetButtonType default sctcbNone;
    property Color: TColor read FColor write SetColor default clNone;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Expanded: Boolean read FExpanded write SetExpanded default False;
    property FlagIndex: TImageIndex read FFlagIndex write SetFlagIndex default -1;
    property Focused: Boolean read GetFocused write SetFocused stored False;
    property GroupHeader: Boolean read FGroupHeader write SetGroupHeader default False;
    property HotIndex: TImageIndex read FHotIndex write SetHotIndex default -1;
    property ImageIndex: TImageIndex read GetImageIndex write SetImageIndex default -1;
    property Preview: Boolean read FPreview write SetPreview default True;
    property PreviewText: String read FPreviewText write SetPreviewText;
    property SelectedIndex: TImageIndex read FSelectedIndex write SetSelectedIndex default -1;
    property StateIndex: TImageIndex read FStateIndex write SetStateIndex default -1;
    property Tag: Integer read FTag write FTag;
    property Text: String read GetText write SetText;
    property Underline: Boolean read FUnderline write SetUnderline default False;
  end;

  TSCTreeNodeClass = class of TSCTreeNode;

  TSCTreeScrollbar = class(TSCControlScrollbar)
  published
    property Background;
    property ButtonColors;
    property Icons;
    property SlideLine;
    property Thumb;
  end;

  TSCTreeScrollbars = class(TSCControlScrollbars);

  TSCTreeBorderProps = class(TSCControlBorderProps)
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

  TSCTreeColors = class(TPersistent)
  private
    FOwner: TSCCustomTreeList;
    FArrowColor: TColor;
    FArrowFrameColor: TColor;
    FCellFocusColor: TColor;
    FCellFocusTextColor: TColor;
    FChildIndicatorColor: TColor;
    FDisabledColor: TColor;
    FDisabledTextColor: TColor;
    FFlashColor: TColor;
    FFlashTextColor: TColor;
    FGridLineColor: TColor;
    FGroupColor: TColor;
    FGroupTextColor: TColor;
    FHeaderColor: TColor;
    FHideSelectionColor: TColor;
    FHideSelectionTextColor: TColor;
    FHighlightColor: TColor;
    FHighlightTextColor: TColor;
    FLineColor: TColor;
    FIndentColor: TColor;
    FIndicatorColor: TColor;
    FIndicatorForeColor: TColor;
    FOutlookColor: TColor;
    FOutlookTextColor: TColor;
    FSortArrowColor: TColor;
    FUnderlineColor: TColor;
    procedure SetArrowColor(Value: TColor);
    procedure SetArrowFrameColor(Value: TColor);
    procedure SetCellFocusColor(Value: TColor);
    procedure SetCellFocusTextColor(Value: TColor);
    procedure SetChildIndicatorColor(Value: TColor);
    procedure SetDisabledColor(Value: TColor);
    procedure SetDisabledTextColor(Value: TColor);
    procedure SetFlashColor(Value: TColor);
    procedure SetFlashTextColor(Value: TColor);
    procedure SetGridLineColor(Value: TColor);
    procedure SetGroupColor(Value: TColor);
    procedure SetGroupTextColor(Value: TColor);
    procedure SetHeaderColor(Value: TColor);
    procedure SetHideSelectionColor(Value: TColor);
    procedure SetHideSelectionTextColor(Value: TColor);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHighlightTextColor(Value: TColor);
    procedure SetIndentColor(Value: TColor);
    procedure SetIndicatorColor(Value: TColor);
    procedure SetIndicatorForeColor(Value: TColor);
    procedure SetLineColor(Value: TColor);
    procedure SetOutlookColor(Value: TColor);
    procedure SetOutlookTextColor(Value: TColor);
    procedure SetSortArrowColor(Value: TColor);
    procedure SetUnderlineColor(Value: TColor);
  protected
    function GetOwner: TPersistent; override;
    procedure Changed;
  public
    constructor Create(AOwner: TSCCustomTreeList); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property ArrowColor: TColor read FArrowColor write SetArrowColor default clLime;
    property ArrowFrameColor: TColor read FArrowFrameColor write SetArrowFrameColor default clGreen;
    property CellFocusColor: TColor read FCellFocusColor write SetCellFocusColor default clWindow;
    property CellFocusTextColor: TColor read FCellFocusTextColor write SetCellFocusTextColor default clWindowText;
    property ChildIndicatorColor: TColor read FChildIndicatorColor write SetChildIndicatorColor default clBtnText;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clBtnFace;
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText;
    property FlashColor: TColor read FFlashColor write SetFlashColor default clRed;
    property FlashTextColor: TColor read FFlashTextColor write SetFlashTextColor default clWhite;
    property GridLineColor: TColor read FGridLineColor write SetGridLineColor default clBtnFace;
    property GroupColor: TColor read FGroupColor write SetGroupColor default clBtnFace;
    property GroupTextColor: TColor read FGroupTextColor write SetGroupTextColor default clBtnText;
    property HeaderColor: TColor read FHeaderColor write SetHeaderColor default clBtnFace;
    property HideSelectionColor: TColor read FHideSelectionColor write SetHideSelectionColor default clBtnFace;
    property HideSelectionTextColor: TColor read FHideSelectionTextColor write SetHideSelectionTextColor default clBtnText;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default clHighlight;
    property HighlightTextColor: TColor read FHighlightTextColor write SetHighlightTextColor default clHighlightText;
    property IndentColor: TColor read FIndentColor write SetIndentColor default clNone;
    property IndicatorColor: TColor read FIndicatorColor write SetIndicatorColor default clBtnFace;
    property IndicatorForeColor: TColor read FIndicatorForeColor write SetIndicatorForeColor default clBtnText;
    property LineColor: TColor read FLineColor write SetLineColor default clGrayText;
    property OutlookColor: TColor read FOutlookColor write SetOutlookColor default clBtnFace;
    property OutlookTextColor: TColor read FOutlookTextColor write SetOutlookTextColor default clBtnText;
    property SortArrowColor: TColor read FSortArrowColor write SetSortArrowColor default clBtnText;
    property UnderlineColor: TColor read FUnderlineColor write SetUnderlineColor default clRed;
  end;

  TSCTreeHottrack = class(TPersistent)
  private
    FOwner: TSCCustomTreeList;
    FColor: TColor;
    FTextColor: TColor;
    FUnderline: Boolean;
    procedure SetColor(Value: TColor);
    procedure SetTextColor(Value: TColor);
    procedure SetUnderline(Value: Boolean);
  protected
    function GetOwner: TPersistent; override;
    procedure Changed;
  public
    constructor Create(AOwner: TSCCustomTreeList); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Color: TColor read FColor write SetColor default clNone;
    property TextColor: TColor read FTextColor write SetTextColor default clBlue;
    property Underline: Boolean read FUnderline write SetUnderline default False;
  end;

  TSCTreeButton = class(TPersistent)
  private
    FBackColor: TColor;
    FFrameColor: TColor;
    FForeColor: TColor;
    FStyle: TSCTreeButtonStyle;
    FWidth: Integer;
    FOwner: TSCCustomTreeList;
    procedure SetBackColor(Value: TColor);
    procedure SetForeColor(Value: TColor);
    procedure SetFrameColor(Value: TColor);
    procedure SetStyle(Value: TSCTreeButtonStyle);
    procedure SetWidth(Value: Integer);
  protected
    function GetOwner: TPersistent; override;
    procedure Changed;
  public
    constructor Create(AOwner: TSCCustomTreeList); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property BackColor: TColor read FBackColor write SetBackColor default clWindow;
    property ForeColor: TColor read FForeColor write SetForeColor default clBtnText;
    property FrameColor: TColor read FFrameColor write SetFrameColor default clGrayText;
    property Style: TSCTreeButtonStyle read FStyle write SetStyle default sctbsDefault;
    property Width: Integer read FWidth write SetWidth default -1;
  end;

  TSCTreeColumn = class(TPersistent)
  private
    FAlignment: TLeftRight;
    FCaption: string;
    FColor: TColor;
    FData: Pointer;
    FDeleting: Boolean;
    FDisableCaption: Boolean;
    FDisableDragging: Boolean;
    FDisableEditor: Boolean;
    FDisableSizing: Boolean;
    FDisableSorting: Boolean;
    FEnabled: Boolean;
    FHeaderAlignment: TLeftRight;
    FImageIndex: TImageIndex;
    FMinWidth: Integer;
    FSortDirection: TSCTreeSortDirection;
    FTag: Integer;
    FVisible: Boolean;
    FWidth: Integer;
    FScaledWidth: Integer;
    FOwner: TSCCustomTreeList;
    FOnChange: TNotifyEvent;
    FOnChangeCaption: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
    procedure SetAlignment(Value: TLeftRight);
    procedure SetCaption(const Value: String);
    procedure SetColor(Value: TColor);
    procedure SetDisableCaption(Value: Boolean);
    procedure SetDisableDragging(Value: Boolean);
    procedure SetDisableEditor(Value: Boolean);
    procedure SetDisableSizing(Value: Boolean);
    procedure SetDisableSorting(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetHeaderAlignment(Value: TLeftRight);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetMinWidth(Value: Integer);
    procedure SetSortDirection(Value: TSCTreeSortDirection);
    procedure SetVisible(Value: Boolean);
    procedure SetWidth(Value: Integer);
    function  GetVisibleIndex: Integer;
  protected
    function  GetOwner: TPersistent; override;
    function  GetDisplayText: String; virtual;

    procedure ReadData(AStream: TStream); virtual;
    procedure WriteData(AStream: TStream); virtual;

    procedure SetScaledWidth(Value: Integer);

    function  GetIndex: Integer;
    function  GetTreeList: TSCCustomTreeList;
    function  GetImageList: TCustomImageList;

    procedure Initialize; dynamic;
    procedure Changed(Forced: Boolean);
    procedure VerifyColWidth(var AWidth: Integer);

    property ScaledWidth: Integer read FScaledWidth;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChangeCaption: TNotifyEvent read FOnChangeCaption write FOnChangeCaption;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
  public
    constructor Create(AOwner: TSCCustomTreeList); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Index: Integer read GetIndex;
    property Data: Pointer read FData write FData;
    property Owner: TSCCustomTreeList read GetTreeList;
    property DisplayText: String read GetDisplayText;
    property ImageList: TCustomImageList read GetImageList;
    property Deleting: Boolean read FDeleting;
    property VisibleIndex: Integer read GetVisibleIndex;
  published
    property Alignment: TLeftRight read FAlignment write SetAlignment default taLeftJustify;
    property Caption: string read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor default clNone;
    property DisableCaption: Boolean read FDisableCaption write SetDisableCaption default False;
    property DisableDragging: Boolean read FDisableDragging write SetDisableDragging default False;
    property DisableEditor: Boolean read FDisableEditor write SetDisableEditor default False;
    property DisableSizing: Boolean read FDisableSizing write SetDisableSizing default False;
    property DisableSorting: Boolean read FDisableSorting write SetDisableSorting default False;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property HeaderAlignment: TLeftRight read FHeaderAlignment write SetHeaderAlignment default taLeftJustify;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property MinWidth: Integer read FMinWidth write SetMinWidth default 20;
    property SortDirection: TSCTreeSortDirection read FSortDirection write SetSortDirection default sctsdNone;
    property Tag: Integer read FTag write FTag default 0;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Width: Integer read FWidth write SetWidth default 100;
  end;

  TSCCustomTreeList = class(TSCCustomScrollControl)
  private
    FList: TList;
    FRealList: TList;
    FNodeList: TList;
    FIndexList: TList;
    FButtons: TSCTreeButton;
    FColors: TSCTreeColors;
    FHottrack: TSCTreeHottrack;
    FRowHeight: Integer;
    FClickTimer: Integer;
    FClickedNode: TSCTreeNode;
    FClickedColumn: TSCTreeColumn;
    FHotNode: TSCTreeNode;
    FHotPart: TSCTreePart;
    FHotColumn: TSCTreeColumn;
    FFocusedNode: TSCTreeNode;
    FFocusedColumn: TSCTreeColumn;
    FTopVisibleNode: TSCTreeNode;
    FOptionsBehaviour: TSCTreeBehaviourOptions;
    FOptionsView: TSCTreeViewOptions;
    FState: TSCTreeListState;
    FFlagImages: TCustomImageList;
    FFlagChangeLink: TChangeLink;
    FColumnImages: TCustomImageList;
    FColumnChangeLink: TChangeLink;
    FStateImages: TCustomImageList;
    FStateChangeLink: TChangeLink;
    FHeaderHeight: Integer;
    FDefaultHeaderHeight: Integer;
    FPreviewHeight: Integer;
    FMinRowHeight: Integer;
    FDefaultHeight: Integer;
    FSizedRowHeight: Integer;
    FRowWidth: Integer;
    FHintWnd: THintWindow;
    FHintNode: TSCTreeNode;
    FHintColumn: TSCTreeColumn;
    FHintText: String;
    FHintOldNode: TSCTreeNode;
    FHintOldColumn: TSCTreeColumn;
    FHintOldWndProc: TWndMethod;
    FHintTimer: Integer;
    FEditInShow: Boolean;
    FEditNode: TSCTreeNode;
    FEditColumn: TSCTreeColumn;
    FHorizontalPos: Integer;
    FHintLock: Integer;
    FSelectionList: TList;
    FInplaceEditor: TSCCustomEdit;
    FInplaceEditorClass: TSCTreeEditorClass;
    FScrollPosChanging: Integer;
    FScrollbarChanging: Integer;
    FBypassEditing: Boolean;
    FMouseDownNode: TSCTreeNode;
    FEditSavedText: String;
    FInplaceOldWndProc: TWndMethod;
    FNodeIndent: Integer;
    FIndicator: Integer;
    FHeaderFont: TFont;
    FPreviewFont: TFont;
    FColumns: TList;
    FPreviewAlignment: TLeftRight;
    FLineStyle: TSCTreeLineStyle;
    FLookAndFeel: TSCTreeLookAndFeel;
    FPaintStyle: TSCTreePaintStyle;
    FDragExpandNode: TSCTreeNode;
    FDragExpandTimer: Integer;
    FDragScrollTimer: Integer;
    FDragImageList: TImageList;
    FDragOverNode: TSCTreeNode;
    FDragNode: TSCTreeNode;
    FDragObject: TDragObject;
    FDragNodeList: TList;
    FShowDragImage: Boolean;
    FHideDragImagesLock: Integer;
    FDragPoint: TPoint;
    FCtrlFlag: Boolean;
    FUnderlineStyle: TSCTreeUnderlineStyle;
    FWaitForExpandTime: Integer;
    FFlashOn: Boolean;
    FFlashParts: TSCTreeFlashParts;
    FFlashNode: TSCTreeNode;
    FFlashTimer: Integer;
    FFlashStart: LongInt;
    FFlashPeriod: DWord;
    FFlashOnTime: DWord;
    FFlashOffTime: DWord;
    FStreamVersion: Integer;
    FSorting: Integer;
    FSortNeeded: Integer;
    FCursorChange: Boolean;
    FDefaultCursor: TCursor;
    FSizingPos: Integer;
    FSizingStartDif: Integer;
    FSizingStartPos: Integer;
    FPrevSizingPos: Integer;
    FHitTest: TPoint;
    FArrowsPos: Integer;
    FSizingNode: TSCTreeNode;
    FSizingColumn: TSCTreeColumn;
    FColumnDown: Boolean;
    FDownColumn: TSCTreeColumn;
    FDragColumn: TSCTreeColumn;
    FInRowCalculation: Integer;
    FSaveBitmap: TBitmap;
    FArrowsBitmap: TBitmap;
    FStopSetFocused: Boolean;
    FNeedsArrangement: Boolean;
    FDesignChange: Boolean;
    FCheckButtonStyle: TSCTreeCheckButtonStyle;
    FOnBeginDragNode: TSCTreeNodeEvent;
    FOnButtonStateChanging: TSCTreeButtonStateEvent;
    FOnButtonStateChanged: TSCTreeNodeEvent;
    FOnCanFocusColumn: TSCTreeColumnAcceptEvent;
    FOnCanFocusNode: TSCTreeNodeAcceptEvent;
    FOnCanSelectNode: TSCTreeNodeAcceptEvent;
    FOnCanUnselectNode: TSCTreeNodeAcceptEvent;
    FOnCollapsing: TSCTreeNodeAcceptEvent;
    FOnCollapsed: TSCTreeNodeEvent;
    FOnCompare: TSCTreeNodeCompareEvent;
    FOnCustomDrawButton: TSCTreePaintButtonEvent;
    FOnCustomDrawBack: TSCTreePaintBackEvent;
    FOnCustomDrawCheckButton: TSCTreePaintCheckButtonEvent;
    FOnCustomDrawColumn: TSCTreePaintColumnEvent;
    FOnCustomDrawFlag: TSCTreePaintImageEvent;
    FOnCustomDrawHeader: TSCTreePaintHeaderEvent;
    FOnCustomDrawImage: TSCTreePaintImageEvent;
    FOnCustomDrawState: TSCTreePaintImageEvent;
    FOnCustomDrawIndent: TSCTreePaintBackEvent;
    FOnCustomDrawIndicator: TSCTreePaintFaceEvent;
    FOnCustomDrawCell: TSCTreePaintCellEvent;
    FOnCustomDrawPreview: TSCTreePaintPreviewEvent;
    FOnCustomDrawSelection: TSCTreePaintSelectionEvent;
    FOnCanDragColumn: TSCTreeColumnAcceptEvent;
    FOnColumnMoved: TSCTreeColumnMoveEvent;
    FOnDrawUnderline: TSCTreeCellAcceptEvent;
    FOnStartColumnDragging: TSCTreeStartColumnDraggingEvent;
    FOnDragEndColumn: TSCTreeDragAcceptColumnEvent;
    FOnDragOverColumn: TSCTreeDragAcceptColumnEvent;
    FOnEndDragColumn: TSCTreeEndDragColumnEvent;
    FOnExpanding: TSCTreeNodeAcceptEvent;
    FOnExpanded: TSCTreeNodeEvent;
    FOnFocusedNodeChanging: TNotifyEvent;
    FOnFocusedNodeChange: TNotifyEvent;
    FOnFocusedColumnChanging: TNotifyEvent;
    FOnFocusedColumnChange: TNotifyEvent;
    FOnGetEditorClass: TSCTreeGetEditorEvent;
    FOnGetGroup: TSCTreeNodeAcceptEvent;
    FOnGetNodeLevel: TSCTreeNodeLevelEvent;
    FOnHideEditor: TSCTreeCellEvent;
    FOnHottrack: TSCTreeHottrackEvent;
    FOnPaintHint: TSCTreePaintHint;
    FOnPrepareEditor: TSCTreePrepareEditorEvent;
    FOnPreviewEvent: TSCTreePreviewEvent;
    FOnSelectionChanging: TNotifyEvent;
    FOnSelectionChange: TNotifyEvent;
    FOnShowEditor: TSCTreeCellAcceptEvent;
    FOnShowItemHint: TSCTreeHintEvent;
    FOnSizeEditor: TSCTreeSizeEditorEvent;
    FOnValidateEditor: TSCTreeValidateEditorEvent;
    procedure SetButtons(Value: TSCTreeButton);
    procedure SetColors(Value: TSCTreeColors);
    procedure SetHottrack(Value: TSCTreeHottrack);
    procedure SetRowHeight(Value: Integer);
    procedure SetFlagImages(Value: TCustomImageList);
    procedure SetFocusedNode(Value: TSCTreeNode);
    procedure SetFocusedColumn(Value: TSCTreeColumn);
    procedure SetHeaderFont(Value: TFont);
    procedure SetPreviewFont(Value: TFont);
    procedure SetHeaderHeight(Value: Integer);
    procedure SetColumnImages(Value: TCustomImageList);
    procedure SetIndicator(Value: Integer);
    procedure SetOptionsBehaviour(Value: TSCTreeBehaviourOptions);
    procedure SetOptionsView(Value: TSCTreeViewOptions);
    procedure SetStateImages(Value: TCustomImageList);
    procedure SetNodeIndent(Value: Integer);
    procedure SetHorizontalPos(Value: Integer);
    procedure SetLineStyle(Value: TSCTreeLineStyle);
    procedure SetLookAndFeel(Value: TSCTreeLookAndFeel);
    procedure SetPaintStyle(Value: TSCTreePaintStyle);
    procedure SetUnderlineStyle(Value: TSCTreeUnderlineStyle);
    procedure SetWaitForExpandTime(Value: Integer);
    procedure SetCheckButtonStyle(Value: TSCTreeCheckButtonStyle);
    function  GetChild(Index: Integer): TSCTreeNode;
    function  GetSelection(Index: Integer): TSCTreeNode;
    function  GetSelectionCount: Integer;
    function  GetCount: Integer;
    function  GetSorting: Boolean;
    function  GetLevelIndent: Integer;
    function  GetColumnCount: Integer;
    function  GetColumn(Index: Integer): TSCTreeColumn;
    procedure SetPreviewAlignment(Value: TLeftRight);

    procedure InsertingChild(AParent: TSCTreeNode; ANode: TSCTreeNode);
    procedure RemovingChild(AParent: TSCTreeNode; ANode: TSCTreeNode);

    procedure ChildChanged(ANode: TSCTreeNode);
    procedure ChildButtonTypeChanged(ANode: TSCTreeNode);
    procedure ChildEnabledChanged(ANode: TSCTreeNode);
    procedure ChildHeightChanged(ANode: TSCTreeNode);
    procedure ChildTextChanged(ANode: TSCTreeNode);
    procedure ChildInserted(AParent: TSCTreeNode; ANode: TSCTreeNode);
    procedure ChildDeleted(ANode: TSCTreeNode);
    procedure ChildRemoved(AParent: TSCTreeNode; ANode: TSCTreeNode);
    procedure ChildMoved(AParent: TSCTreeNode; OldIndex, NewIndex: Integer);
    procedure ChildExchanged(AParent: TSCTreeNode; Index1, Index2: Integer);

    procedure InsertChild(ANode: TSCTreeNode; Index: Integer);
    procedure RemoveChild(ANode: TSCTreeNode);

    procedure HeaderFontChanged(Sender: TObject);
    procedure PreviewFontChanged(Sender: TObject);
    procedure ColumnInserted(AColumn: TSCTreeColumn);
    procedure ColumnRemoving(AColumn: TSCTreeColumn);
    procedure ColumnRemoved(AColumn: TSCTreeColumn);
    procedure ColumnChanged(AColumn: TSCTreeColumn; Forced: Boolean);
    procedure ColumnMoved(OldIndex, NewIndex: Integer);
    procedure ColumnSortChanged(AColumn: TSCTreeColumn;
      var SortDir: TSCTreeSortDirection);

    procedure RemoveColumn(AColumn: TSCTreeColumn);
    procedure InsertColumn(AColumn: TSCTreeColumn); overload;
    procedure InsertColumn(AColumn: TSCTreeColumn; Index: Integer); overload;

    procedure ButtonChanged;
    procedure ColorsChanged;
    procedure HottrackChanged;

    procedure HintWindowProc(var Message: TMessage);
    procedure InplaceWindowProc(var Message: TMessage);
    procedure InplaceChanged(Sender: TObject);

    procedure ArrangeNodeList(ANode: TSCTreeNode; AList: TList); overload;
    procedure CalculateRowWidth(ANode: TSCTreeNode); overload;

    procedure FocusedNodeChanging;
    procedure FocusedNodeChanged;
    procedure SelectionChanging;
    procedure SelectionChanged;
    procedure FocusedColumnChanging;
    procedure FocusedColumnChanged;

    procedure GetCellColors(ACell: TSCTreeCell; var ABackColor,
      AForeColor, AHotColor: TColor);
    procedure GetPreviewColors(ANode: TSCTreeNode;
      var AForeColor, AHotColor: TColor);

    procedure DrawRowSizingLine;
    procedure DrawColumnSizingLine;

    function  GetArrowsRect(APos: Integer): TRect;
    procedure DrawDragArrows(HideDrag: Boolean);
    procedure UpdateArrowsPos(P: TPoint; HideDrag: Boolean);
    procedure StoreArrowsBack(APos: Integer; HideDrag: Boolean);
    procedure RestoreArrowsBack(APos: Integer; HideDrag: Boolean);

    procedure DrawButton(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawBack(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawCheckButton(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawIndent(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawIndicator(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; AColor: TColor);
    procedure DrawImages(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect;
      ASelected, AFocused, AHot: Boolean);
    procedure DrawColumn(ACanvas: TCanvas; AColumn: TSCTreeColumn;
      ARect: TRect; AColor: TColor; IsDown: Boolean);
    procedure DrawCells(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawNode(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawNodeBack(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawSelection(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawPreview(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawUnderline(ACanvas: TCanvas; ACell: TSCTreeCell;
      ARect: TRect; IsFlash: Boolean);
    procedure DrawHorizontalLine(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawVerticalLine(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawOffice12Cell(ACanvas: TCanvas; ARect: TRect;
      AColor: TColor; Invert: Boolean; AFrame: Boolean = False);
    procedure DrawOffice12Face(ACanvas: TCanvas; ARect: TRect;
      AColor: TColor; AFace, AFrame: Boolean);

    procedure DrawDefaultStyle(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawInspectorStyle(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawInspectorNetStyle(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawInspectorSharpStyle(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);
    procedure DrawOffice12Style(ACanvas: TCanvas; ANode: TSCTreeNode; ARect: TRect);

    procedure DrawTreeLine(ACanvas: TCanvas; ANode: TSCTreeNode;
      VisibleList, AList: TList; ARect: TRect);

    function  SearchNodeList(ANode: TSCTreeNode): Integer;

    function  GroupedNode(ANode: TSCTreeNode): Boolean;
    function  GetNodeWidth(ACanvas: TCanvas; AFont: TFont;
      ANode: TSCTreeNode): Integer; overload;

    function  GetEditorClass(ACell: TSCTreeCell): TSCTreeEditorClass;
    procedure ValidateEditor(ACell: TSCTreeCell; var Text: String;
      var AcceptEdit: Boolean);

    procedure ChangeCursor(ACursor: TCursor);
    procedure BeginDragNode(ANode: TSCTreeNode);
    procedure HottrackNode(HitInfo: TSCTreeHitInfo);

    procedure InitiateHintTimer;
    procedure InitiateClickTimer;
    procedure InitiateFlashTimer;
    procedure InitiateDragExpandTimer;
    procedure InitiateDragScrollTimer(ADelay: Integer);

    procedure KillAllTimers;
    procedure KillHintTimer;
    procedure KillClickTimer;
    procedure KillFlashTimer;
    procedure KillDragExpandTimer;
    procedure KillDragScrollTimer;

    procedure StartDragScrolling;
    procedure StopDragScrolling;
    function  DragScrolling: Boolean;

    function  GetFlashTime: Integer;
    procedure UpdateFlashNode(ANode: TSCTreeNode; Parts: TSCTreeFlashParts);

    procedure GenerateOctPoints(ARect: TRect; RoundBy: Integer;
      var Pts: array of TPoint);

    function  GetSortingColumn: Integer;
    function  GetSortedColumn: TSCTreeColumn;
    procedure SortNode(ANode: TSCTreeNode); overload;
    function  CompareNodes(N1, N2: TSCTreeNode): Integer;
    {$IFDEF SC_DELPHIXE2_UP}
    procedure QuickSort(AList: TPointerList; L, R: Integer);
    {$ELSE}
    procedure QuickSort(AList: PPointerList; L, R: Integer);
    {$ENDIF}

    procedure CMCancelMode(var Message: TMessage); message CM_CANCELMODE;
    procedure CMCursorChanged(var Message: TMessage); message CM_CURSORCHANGED;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMDrag(var Message: TCMDrag); message CM_DRAG;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;

    procedure WMCancelMode(var Msg: TMessage); message WM_CANCELMODE;
    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
    procedure WMDestroy(var Message: TWMDestroy); message WM_DESTROY;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMIMEStartComp(var Message: TMessage); message WM_IME_STARTCOMPOSITION;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMRButtonDown(var Message: TWMLButtonDown); message WM_RBUTTONDOWN;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure WndProc(var Message: TMessage); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;

    procedure Paint; override;
    procedure Loaded; override;
    procedure DragCanceled; override;
    procedure FocusChanged; override;

    procedure StopTracking; override;
    procedure MouseInControlChanged; override;
    procedure NCMouseEnter(var HitTest: LongInt; X, Y: Integer); override;

    function  CanMenuPopup(const Pos: TSmallPoint): Boolean; override;

    procedure SetIndent(Value: Integer); override;
    procedure IndentChanged; override;

    procedure ReadData(AStream: TStream); virtual;
    procedure WriteData(AStream: TStream); virtual;

    procedure SetTransparent(Value: Boolean); override;

    procedure ImageListChange(Sender: TObject); override;
    procedure FlagImageListChange(Sender: TObject); dynamic;
    procedure StateImageListChange(Sender: TObject); dynamic;
    procedure HeaderImageListChange(Sender: TObject); dynamic;

    function  GetBlendValue: Word; override;
    function  GetFaceColor: TColor; override;

    function  GetGradientShadow(AColor: TColor): TColor;
    function  GetGradientDark(AColor: TColor): TColor;
    function  GetGradientLight(AColor: TColor): TColor;
    function  GetGradientExDark(AColor: TColor): TColor;
    function  GetGradientExLight(AColor: TColor): TColor;
    function  GetGradientPeal(AColor: TColor): TColor;
    function  GetGradientPreDark(AColor: TColor): TColor;
    function  GetGradientPreLight(AColor: TColor): TColor;

    function  AsCell(ANode: TSCTreeNode; ACol: TSCTreeColumn): TSCTreeCell;

    procedure CancelDragSize;
    procedure EndRowSizing;
    procedure EndColumnSizing;
    procedure EndColumnDragging;
    function  GetDragOverColumn(P: TPoint): Integer;

    procedure UpdateDesigner;
    procedure SetState(Value: TSCTreeListState);

    function  IsDefaultStyle: Boolean;
    function  IsInspectorStyle: Boolean;
    function  IsInspectorNetStyle: Boolean;
    function  IsInspectorSharpStyle: Boolean;
    function  IsOffice12Style: Boolean;
    function  IsOutlookStyle: Boolean;

    function  CanAllowEditing: Boolean; virtual;
    function  CanAllowSorting: Boolean; virtual;
    function  CanAnsiSort: Boolean; virtual;
    function  CanAutoDragMove: Boolean; virtual;
    function  CanAutoSort: Boolean; virtual;
    function  CanCellSelect: Boolean; virtual;
    function  CanClearColumnOnRemove: Boolean; virtual;
    function  CanColumnMoving: Boolean; virtual;
    function  CanColumnSizing: Boolean; virtual;
    function  CanCycleCells: Boolean; virtual;
    function  CanDblClickExpand: Boolean; virtual;
    function  CanDragCollapse: Boolean; virtual;
    function  CanDragExpand: Boolean; virtual;
    function  CanDragScroll: Boolean; virtual;
    function  CanGoToNextCellOnEnter: Boolean; virtual;
    function  CanGoToNextCellOnTab: Boolean; virtual;
    function  CanImmediateEditor: Boolean; virtual;
    function  CanMouseScroll: Boolean; virtual;
    function  CanMultiSelect: Boolean; virtual;
    function  CanRightClickSelect: Boolean; virtual;
    function  CanRowAutoHeight: Boolean; virtual;
    function  CanRowSelect: Boolean; virtual;
    function  CanRowSizing: Boolean; virtual;
    function  CanShowEditorOnEnter: Boolean; virtual;

    function  IsDrawEndEllipsis: Boolean; virtual;
    function  IsGrouping: Boolean; virtual;
    function  IsGroupOnlyFirstLevel: Boolean; virtual;
    function  IsHideFocusRect: Boolean; virtual;
    function  IsHideSelection: Boolean; virtual;
    function  IsHottrack: Boolean; virtual;
    function  IsShowButtons: Boolean; virtual;
    function  IsShowCheckButtons: Boolean; virtual;
    function  IsShowChildIndicator: Boolean; virtual;
    function  IsShowEmptyButtons: Boolean; virtual;
    function  IsShowFlagImages: Boolean; virtual;
    function  IsShowHotImages: Boolean; virtual;
    function  IsShowHourGlassOnAction: Boolean; virtual;
    function  IsShowHeader: Boolean; virtual;
    function  IsShowHighlightFrame: Boolean; virtual;
    function  IsShowIndicator: Boolean; virtual;
    function  IsShowLineHorizontal: Boolean; virtual;
    function  IsShowLineVertical: Boolean; virtual;
    function  IsShowNodeHints: Boolean; virtual;
    function  IsShowPreview: Boolean; virtual;
    function  IsShowRoot: Boolean; virtual;
    function  IsShowSelectedImages: Boolean; virtual;
    function  IsShowStateImages: Boolean; virtual;
    function  IsShowTreeLine: Boolean; virtual;

    procedure UpdateDragging;
    procedure SetDragObject(Value: TDragObject);

    procedure BeginAutoDrag; override;
    procedure DoBeginDragNode(ANode: TSCTreeNode); virtual;
    procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
    procedure DoStartDrag(var DragObject: TDragObject); override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
    function  GetDragImages: TDragImageList; override;
    procedure PrepareNodeToDrag(ANode: TSCTreeNode); virtual;

    procedure ShowDragImages;
    procedure HideDragImages;

    procedure DoColumnDragging;
    procedure DoColumnClick(AColumn: TSCTreeColumn);
    procedure PrepareColumnToDrag(AColumn: TSCTreeColumn); virtual;
    procedure GetDraggingCursor(P: TPoint; var ACursor: TCursor); virtual;
    function  CanDragColumn(Index: Integer): Boolean; overload; dynamic;
    procedure StartDragColumn(AColumn: TSCTreeColumn); dynamic;
    procedure DoBeginDragColumn(AColumn: TSCTreeColumn); virtual;
    procedure DoDragOverColumn(P: TPoint; Index: Integer; var Accept: Boolean); dynamic;
    procedure DoEndDragColumn(P: TPoint; Index: Integer;
      var NewPos: Integer; var Accept: Boolean); dynamic;

    procedure DoInsertingColumn(AColumn: TSCTreeColumn); dynamic;
    procedure DoRemovingColumn(AColumn: TSCTreeColumn); dynamic;

    function  IsRowStyle: Boolean;
    procedure DoGroupedNode(ANode: TSCTreeNode; var IsGroup: Boolean); virtual;
    procedure DoGetNodeLevel(ANode: TSCTreeNode; var ALevel: Integer); virtual;

    procedure DrawNodes(ACanvas: TCanvas);
    procedure DrawHeader(ACanvas: TCanvas);
    procedure DoPaintBack(ACanvas: TCanvas); virtual;
    procedure DrawDragOverArrows(ACanvas: TCanvas; P: TPoint);

    procedure DoDrawHeader(ACanvas: TCanvas; ARect: TRect;
      var AColor: TColor; var Handled: Boolean); virtual;
    procedure DoDrawColumn(ACanvas: TCanvas; AColumn: TSCTreeColumn;
      ARect: TRect; var AColor, ASortArrow: TColor; var SortDir: TSCTreeSortDirection;
      var Handled: Boolean); virtual;
    procedure DoDrawHint(ACanvas: TCanvas; ACell: TSCTreeCell;
      ARect: TRect; HintText: String); virtual;
    procedure DoDrawBack(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; var AColor: TColor; var Handled: Boolean); virtual;
    procedure DoDrawIndent(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; var AColor: TColor; var Handled: Boolean); virtual;
    procedure DoDrawIndicator(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; var ABackColor, AForeColor: TColor;
      var Handled: Boolean); virtual;
    procedure DoDrawButton(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; var ABackColor, AFrameColor, AForeColor: TColor;
      var Handled: Boolean); virtual;
    procedure DoDrawCheckButton(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; var ABackColor, AFaceColor, AFrameColor, AForeColor,
      AHotColor, AFocusColor: TColor; var Handled: Boolean); virtual;
    procedure DoDrawFlag(ANode: TSCTreeNode; ACanvas: TCanvas;
      ARect: TRect; ASelected, AFocused, AHot: Boolean;
      var ABackColor: TColor; AImage: TImageIndex;
      var Handled: Boolean); virtual;
    procedure DoDrawImage(ANode: TSCTreeNode; ACanvas: TCanvas;
      ARect: TRect; ASelected, AFocused, AHot: Boolean;
      var ABackColor: TColor; AImage: TImageIndex;
      var Handled: Boolean); virtual;
    procedure DoDrawState(ANode: TSCTreeNode; ACanvas: TCanvas;
      ARect: TRect; ASelected, AFocused, AHot: Boolean;
      var ABackColor: TColor; AImage: TImageIndex;
      var Handled: Boolean); virtual;
    procedure DoDrawCell(ACell: TSCTreeCell; ACanvas: TCanvas;
      ARect: TRect; ASelected, AFocused, AHot: Boolean; AFont: TFont;
      var AColor: TColor; var AText: string; var Handled: Boolean); virtual;
    procedure DoDrawPreview(ANode: TSCTreeNode; ACanvas: TCanvas;
      ARect: TRect; ASelected, AFocused, AHot: Boolean; AFont: TFont;
      var AColor: TColor; var AText: string; var Handled: Boolean); virtual;
    procedure DoDrawSelection(ACell: TSCTreeCell; ACanvas: TCanvas;
      ARect: TRect; ASelected, AFocused, AHot: Boolean;
      var AColor: TColor; var Handled: Boolean); virtual;

    procedure DrawMarkCheckbox(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;

    procedure DrawDefaultCheckbox(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;
    procedure DrawDoubleCheckbox(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;
    procedure DrawFlatCheckbox(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;
    procedure DrawFlatExCheckbox(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;
    procedure DrawFlatFrameCheckbox(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;
    procedure DrawMetalCheckbox(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;
    procedure DrawNewCheckbox(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor,
      AHotColor, AFocusColor: TColor); virtual;

    procedure DrawDefaultRadioButton(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;
    procedure DrawDoubleRadioButton(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;
    procedure DrawFlatRadioButton(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;
    procedure DrawFlatExRadioButton(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;
    procedure DrawFlatFrameRadioButton(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;
    procedure DrawMetalRadioButton(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor: TColor); virtual;
    procedure DrawNewRadioButton(ACanvas: TCanvas; ANode: TSCTreeNode;
      ARect: TRect; ABackColor, AFaceColor, AFrameColor, AForeColor,
      AHotColor, AFocusColor: TColor); virtual;

    function  GetTopVisibleIndex: Integer;
    function  GetTopVisibleNode: TSCTreeNode;
    procedure SetTopVisibleNode(ANode: TSCTreeNode);
    function  GetLastVisibleNode: TSCTreeNode;

    function  GetScrollCount: Integer;
    function  GetScrollPageCount: Integer;
    function  GetVisibleNodes(AllowPartitial: Boolean): TSCTreeNodeArray;
    function  VisibleNodeCount(AllowPartitial: Boolean): Integer;

    procedure NodesChanged;
    procedure DoNodesChanged; virtual;

    function  CanTrackMouse: Boolean;
    function  ChangeHottrack(HitInfo: TSCTreeHitInfo): Boolean;

    procedure UpdateColumns(Resized: Boolean);
    function  CanDragColumn(AColumn: TSCTreeColumn): Boolean; overload;
    function  CanSizeColumn(AColumn: TSCTreeColumn): Boolean;

    procedure ArrangeNodeList; overload;
    procedure CalculateRowWidth; overload;
    function  CanChangeItemIndex(AIndex: Integer): Integer; dynamic;

    procedure LockHint;
    procedure UnlockHint;
    function  IsHintLocked: Boolean;

    procedure UpdateLocked; override;
    procedure UpdateUnlocked; override;

    function  GetDefaultNodeClass: TSCTreeNodeClass; virtual;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetPicturePropsClass: TSCCustomPicturePropsClass; override;
    function  GetControlScrollbarsClass: TSCControlCustomScrollbarsClass; override;
    function  GetScrollbarClass: TSCCustomControlScrollbarClass; override;

    procedure UpdateScrollbars(Horizontal, Vertical: Boolean); virtual;

    function  CanScrollToPos(Kind: TSCScrollbarKind; var NewValue: Integer): Boolean; override;
    procedure DoScrollerPositionChanged(Kind: TSCScrollbarKind); override;

    function  GetLastTopVisibleNode: TSCTreeNode;
    procedure VerifyIndex(var AIndex: Integer); dynamic;
    procedure VerifyTopIndex(var AIndex: Integer); dynamic;
    procedure VerifyHorizontalPos(var APos: Integer); dynamic;

    function  GetPageDownIndex(AIndex: Integer): Integer; dynamic;
    function  GetPageUpIndex(AIndex: Integer): Integer; dynamic;

    function  UpdateVertScrollBar: Boolean; dynamic;
    function  UpdateHorzScrollBar: Boolean; dynamic;
    function  IsVertScrollBarVisible: Boolean; override;
    function  IsHorzScrollBarVisible: Boolean; override;
    function  CanShowVertScrollBar: Boolean; dynamic;
    function  CanShowHorzScrollBar: Boolean; dynamic;

    function  DoCanSelect(ANode: TSCTreeNode): Boolean; virtual;
    function  DoCanUnselect(ANode: TSCTreeNode): Boolean;
    function  DoCanFocusNode(ANode: TSCTreeNode): Boolean; virtual;
    function  DoCanFocusColumn(AColumn: TSCTreeColumn): Boolean; virtual;

    function  CanCollapse(ANode: TSCTreeNode): Boolean; dynamic;
    function  CanExpand(ANode: TSCTreeNode): Boolean; dynamic;
    function  CanSetButtonState(ANode: TSCTreeNode;
      var AState: TSCTreeCheckButtonState): Boolean; dynamic;

    function  HasAnyNode: Boolean;
    function  HasAnyColumn: Boolean;

    procedure Collapse(ANode: TSCTreeNode);
    procedure Expand(ANode: TSCTreeNode);
    procedure SetButtonState(ANode: TSCTreeNode;
      AState: TSCTreeCheckButtonState);

    function  GetEditingText: String; virtual;
    procedure SetEditingText(const Value: String); virtual;

    procedure UpdateHottrack;

    procedure PrepareEditor;
    procedure SizeEditor; dynamic;
    function  GetEditorRect(ACell: TSCTreeCell): TRect; dynamic;

    function  GetButtonSize: Integer;

    procedure SwitchState(AllowGrayed: Boolean; AType: TSCTreeCheckButton;
      var AState: TSCTreeCheckButtonState);

    procedure ResetFlash;
    function  FlashOn: Boolean;
    function  Flashing: Boolean;
    function  FlashingParts: TSCTreeFlashParts;
    function  CanFlashNode(ANode: TSCTreeNode): Boolean;

    function  CanShowEditor: Boolean; dynamic;
    procedure DoGetEditorClass(ACell: TSCTreeCell;
      var EditorClass: TSCTreeEditorClass); dynamic;
    procedure DoShowEditor(ACell: TSCTreeCell; var AllowEdit: Boolean); dynamic;
    procedure DoSizeEditor(ACell: TSCTreeCell; var EditRect: TRect); dynamic;
    procedure DoHideEditor(ACell: TSCTreeCell);
    procedure DoValidateEditor(ACell: TSCTreeCell; var Text: String;
      var AcceptEdit: Boolean); dynamic;
    procedure DoPrepareEditor(ACell: TSCTreeCell; var AAlignment: TAlignment;
      var ABorder: TSCControlBorder; var ABorderColor, AColor,
      AFontColor: TColor); dynamic;
    procedure DoHottrackNode(AHotInfo: TSCTreeHitInfo; var ACursor: TCursor); virtual;

    function  ExtractColumn(Index: Integer): TSCTreeColumn;
    function  ToggleSort(SortDir: TSCTreeSortDirection): TSCTreeSortDirection;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Invalidate; override;

    function  CaptureFocus(ProcessEvents: Boolean): Boolean; override;

    function  IsHot(ACell: TSCTreeCell): Boolean;
    function  IsFocused(ACell: TSCTreeCell): Boolean;
    function  IsFocusedNode(ANode: TSCTreeNode): Boolean;
    function  IsSelected(ANode: TSCTreeNode): Boolean;

    procedure GoToPriorCell(Key: Word = VK_LEFT);
    procedure GoToNextCell(Key: Word = VK_RIGHT);

    procedure SelectAll;
    procedure ClearSelection;
    procedure DeleteSelection;
    procedure Select(ANode: TSCTreeNode);
    procedure Unselect(ANode: TSCTreeNode);

    function  CanSelect(ANode: TSCTreeNode): Boolean;
    function  CanUnselect(ANode: TSCTreeNode): Boolean;
    function  CanFocusNode(ANode: TSCTreeNode): Boolean;
    function  CanFocusColumn(AColumn: TSCTreeColumn): Boolean;

    procedure UpdateHintWindow;
    procedure ShowHintWindow(P: TPoint; CheckHintSize: Boolean = True);
    procedure HideHintWindow;

    procedure UpdateNodes(Nodes: TSCTreeNodeArray);
    procedure UpdateNode(ANode: TSCTreeNode; Scrollbars: Boolean;
      Part: TSCTreeUpdatePart);

    procedure UpdateHeader;
    procedure UpdateColumn(AColumn: TSCTreeColumn);

    function  Editing: Boolean;
    procedure ShowEditor;
    procedure HideEditor;
    procedure PostEditor;

    function  GetTopParentNode(ANode: TSCTreeNode): TSCTreeNode;
    function  IsParentNodeOf(ANode, AParent: TSCTreeNode): Boolean;
    function  ParentExpanded(ANode: TSCTreeNode): Boolean;
    function  IsNodePartitial(ANode: TSCTreeNode): Boolean;
    function  IsNodeVisible(ANode: TSCTreeNode; AllowPartitial: Boolean): Boolean;
    procedure MakeNodeVisible(ANode: TSCTreeNode; AllowPartitial: Boolean);

    function  IsColumnVisible(Index: Integer): Boolean; overload;
    function  IsColumnVisible(AColumn: TSCTreeColumn;
      AllowPartitial: Boolean): Boolean; overload;
    procedure MakeColumnVisible(AColumn: TSCTreeColumn; AllowPartitial: Boolean);

    function  GetAbsoluteCount: Integer;
    function  GetAbsoluteNode(AIndex: Integer; InExpandeds: Boolean): TSCTreeNode;
    function  GetAbsoluteIndex(ANode: TSCTreeNode; InExpandeds: Boolean): Integer;

    function  IsLastNode(ANode: TSCTreeNode): Boolean; virtual;
    function  IsTopVisibleNode(ANode: TSCTreeNode): Boolean; virtual;

    function  GetHeaderRect: TRect;
    function  GetHeaderHeight: Integer; virtual;
    function  GetPreviewHeight: Integer; overload; virtual;
    function  GetPreviewHeight(ANode: TSCTreeNode): Integer; overload;
    function  GetColumnRect(AColumn: TSCTreeColumn): TRect;
    function  GetColumnWidth(AColumn: TSCTreeColumn): Integer; dynamic;

    function  GetNodesRect: TRect;
    function  GetCellRect(ACell: TSCTreeCell; TextOnly: Boolean): TRect;
    function  GetNodeRect(ANode: TSCTreeNode; TextOnly: Boolean): TRect;

    function  GetCellHeight: Integer;
    function  GetMinNodeHeight: Integer; overload;
    function  GetMinNodeHeight(ANode: TSCTreeNode): Integer; overload; 

    function  GetNodeHeight: Integer; overload;
    function  GetNodeHeight(ANode: TSCTreeNode): Integer; overload; dynamic;
    function  GetNodeWidth(ANode: TSCTreeNode): Integer; overload; dynamic;
    function  GetNodeLevel(ANode: TSCTreeNode): Integer;

    procedure FullExpand;
    procedure FullCollapse;

    procedure FlashNode(ANode: TSCTreeNode; Parts: TSCTreeFlashParts;
      Period, OnTime, OffTime: DWord);

    procedure ClearNodes;
    procedure AssignNodes(Source: TPersistent);
    function  Add: TSCTreeNode; overload;
    function  AddFirst: TSCTreeNode;
    procedure Add(ANode: TSCTreeNode); overload;
    function  IndexOf(ANode: TSCTreeNode): Integer;
    function  Insert(Index: Integer): TSCTreeNode; overload;
    procedure Insert(Index: Integer; ANode: TSCTreeNode); overload;
    function  Insert(BeforeNode: TSCTreeNode): TSCTreeNode; overload;
    procedure Delete(Index: Integer); overload;
    function  Remove(ANode: TSCTreeNode): Integer;
    function  Extract(Index: Integer): TSCTreeNode;
    procedure Exchange(Index1, Index2: Integer);
    procedure Move(CurIndex, NewIndex: Integer);

    procedure ClearColumns;
    function  IndexOfColumn(AColumn: TSCTreeColumn): Integer;
    procedure DeleteColumn(Index: Integer); overload;
    procedure MoveColumn(CurIndex, NewIndex: Integer);

    function  HasAnyVisibleColumn: Boolean;
    function  GetVisibleColumnCount: Integer;
    function  FirstVisibleColumn: TSCTreeColumn;
    function  LastVisibleColumn: TSCTreeColumn;
    function  IsFirstVisibleColumn(AColumn: TSCTreeColumn): Boolean;
    function  IsLastVisibleColumn(AColumn: TSCTreeColumn): Boolean;
    function  NextVisibleColumn(AColumn: TSCTreeColumn): TSCTreeColumn;
    function  PriorVisibleColumn(AColumn: TSCTreeColumn): TSCTreeColumn;
    function  GetVisibleColumn(Index: Integer): TSCTreeColumn;
    function  GetVisibleIndexOf(AColumn: TSCTreeColumn): Integer;

    function  Edit(ACell: TSCTreeCell): Boolean;
    procedure EndEdit(Cancel: Boolean);

    function  FindData(StartIndex: Integer; Value: Pointer;
      AColumn: Integer; Inclusive, Wrap: Boolean): TSCTreeNode;
    function  FindCaption(StartIndex: Integer; Value: string; Partial,
      Inclusive, Wrap, CaseSensitive: Boolean): TSCTreeNode;
    function  GetHitInfo(X, Y: Integer): TSCTreeHitInfo;
    function  GetNodeAt(X, Y: Integer): TSCTreeNode;

    procedure LoadFromFile(const FileName: string); override;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: string); override;
    procedure SaveToStream(Stream: TStream);

    procedure SortNodes(Recursive: Boolean);
    procedure SortNode(ANode: TSCTreeNode; Recursive: Boolean); overload;

    procedure AutoSizeColumn(AColumn: TSCTreeColumn);

    property Color default clWindow;
    property ParentColor default False;
    property TabStop default True;

    property Sorting: Boolean read GetSorting;
    property SortedColumn: TSCTreeColumn read GetSortedColumn;
    property ActiveEditor: TSCCustomEdit read FInplaceEditor;
    property Count: Integer read GetCount;
    property DragNode: TSCTreeNode read FDragNode;
    property State: TSCTreeListState read FState;
    property TopIndex: Integer read GetTopVisibleIndex;
    property LevelIndent: Integer read GetLevelIndent;
    property ColumnCount: Integer read GetColumnCount;
    property Columns[Index: Integer]: TSCTreeColumn read GetColumn;
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property PreviewFont: TFont read FPreviewFont write SetPreviewFont;
    property HeaderHeight: Integer read FHeaderHeight write SetHeaderHeight default -1;
    property ColumnImages: TCustomImageList read FColumnImages write SetColumnImages;
    property Selection[Index: Integer]: TSCTreeNode read GetSelection;
    property SelectionCount: Integer read GetSelectionCount;
    property Items[Index: Integer]: TSCTreeNode read GetChild;
    property EditInShow: Boolean read FEditInShow;
    property Buttons: TSCTreeButton read FButtons write SetButtons;
    property Colors: TSCTreeColors read FColors write SetColors;
    property CheckButtonStyle: TSCTreeCheckButtonStyle read FCheckButtonStyle
      write SetCheckButtonStyle default sctcsDefault;
    property EditingText: String read GetEditingText write SetEditingText;
    property FlagImages: TCustomImageList read FFlagImages write SetFlagImages;
    property FocusedNode: TSCTreeNode read FFocusedNode write SetFocusedNode;
    property FocusedColumn: TSCTreeColumn read FFocusedColumn write SetFocusedColumn;
    property PreviewAlignment: TLeftRight read FPreviewAlignment write SetPreviewAlignment default taLeftJustify;
    property HotNode: TSCTreeNode read FHotNode;
    property HotColumn: TSCTreeColumn read FHotColumn;
    property HotPart: TSCTreePart read FHotPart;
    property Hottrack: TSCTreeHottrack read FHottrack write SetHottrack;
    property Indicator: Integer read FIndicator write SetIndicator default 12;
    property OptionsBehaviour: TSCTreeBehaviourOptions read FOptionsBehaviour
      write SetOptionsBehaviour default SCDefaultBehaviourOptions;
    property OptionsView: TSCTreeViewOptions read FOptionsView write SetOptionsView default SCDefaultViewOptions;
    property LineStyle: TSCTreeLineStyle read FLineStyle write SetLineStyle default sctlsDot;
    property LookAndFeel: TSCTreeLookAndFeel read FLookAndFeel write SetLookAndFeel default sctlfDefault;
    property PaintStyle: TSCTreePaintStyle read FPaintStyle write SetPaintStyle default sctpsDefault;
    property RowHeight: Integer read FRowHeight write SetRowHeight default -1;
    property StateImages: TCustomImageList read FStateImages write SetStateImages;
    property TopVisibleNode: TSCTreeNode read GetTopVisibleNode;
    property NodeIndent: Integer read FNodeIndent write SetNodeIndent default 0;
    property ShowDragImage: Boolean read FShowDragImage write FShowDragImage default True;
    property UnderlineStyle: TSCTreeUnderlineStyle read FUnderlineStyle write SetUnderlineStyle default sctusTilda;
    property WaitForExpandTime: Integer read FWaitForExpandTime write SetWaitForExpandTime default SCWaitForExpandTime;
    
    property OnBeginDragNode: TSCTreeNodeEvent read FOnBeginDragNode write FOnBeginDragNode;
    property OnButtonStateChanging: TSCTreeButtonStateEvent read FOnButtonStateChanging write FOnButtonStateChanging;
    property OnButtonStateChanged: TSCTreeNodeEvent read FOnButtonStateChanged write FOnButtonStateChanged;
    property OnCanFocusColumn: TSCTreeColumnAcceptEvent read FOnCanFocusColumn write FOnCanFocusColumn;
    property OnCanFocusNode: TSCTreeNodeAcceptEvent read FOnCanFocusNode write FOnCanFocusNode;
    property OnCanSelectNode: TSCTreeNodeAcceptEvent read FOnCanSelectNode write FOnCanSelectNode;
    property OnCanUnselectNode: TSCTreeNodeAcceptEvent read FOnCanUnselectNode write FOnCanUnselectNode;
    property OnCollapsing: TSCTreeNodeAcceptEvent read FOnCollapsing write FOnCollapsing;
    property OnCollapsed: TSCTreeNodeEvent read FOnCollapsed write FOnCollapsed;
    property OnCompare: TSCTreeNodeCompareEvent read FOnCompare write FOnCompare;
    property OnCustomDrawBack: TSCTreePaintBackEvent read FOnCustomDrawBack write FOnCustomDrawBack;
    property OnCustomDrawButton: TSCTreePaintButtonEvent read FOnCustomDrawButton write FOnCustomDrawButton;
    property OnCustomDrawCheckButton: TSCTreePaintCheckButtonEvent read FOnCustomDrawCheckButton
      write FOnCustomDrawCheckButton;
    property OnCustomDrawColumn: TSCTreePaintColumnEvent read FOnCustomDrawColumn write FOnCustomDrawColumn;
    property OnCustomDrawFlag: TSCTreePaintImageEvent read FOnCustomDrawFlag write FOnCustomDrawFlag;
    property OnCustomDrawHeader: TSCTreePaintHeaderEvent read FOnCustomDrawHeader write FOnCustomDrawHeader;
    property OnCustomDrawImage: TSCTreePaintImageEvent read FOnCustomDrawImage write FOnCustomDrawImage;
    property OnCustomDrawIndent: TSCTreePaintBackEvent read FOnCustomDrawIndent write FOnCustomDrawIndent;
    property OnCustomDrawIndicator: TSCTreePaintFaceEvent read FOnCustomDrawIndicator write FOnCustomDrawIndicator;
    property OnCustomDrawCell: TSCTreePaintCellEvent read FOnCustomDrawCell write FOnCustomDrawCell;
    property OnCustomDrawPreview: TSCTreePaintPreviewEvent read FOnCustomDrawPreview write FOnCustomDrawPreview;
    property OnCustomDrawSelection: TSCTreePaintSelectionEvent read FOnCustomDrawSelection write FOnCustomDrawSelection;
    property OnCustomDrawState: TSCTreePaintImageEvent read FOnCustomDrawState write FOnCustomDrawState;
    property OnCanDragColumn: TSCTreeColumnAcceptEvent read FOnCanDragColumn write FOnCanDragColumn;
    property OnColumnMoved: TSCTreeColumnMoveEvent read FOnColumnMoved write FOnColumnMoved;
    property OnDrawUnderline: TSCTreeCellAcceptEvent read FOnDrawUnderline write FOnDrawUnderline;
    property OnStartColumnDragging: TSCTreeStartColumnDraggingEvent read FOnStartColumnDragging;
    property OnDragEndColumn: TSCTreeDragAcceptColumnEvent read FOnDragEndColumn write FOnDragEndColumn;
    property OnDragOverColumn: TSCTreeDragAcceptColumnEvent read FOnDragOverColumn write FOnDragOverColumn;
    property OnEndDragColumn: TSCTreeEndDragColumnEvent read FOnEndDragColumn write FOnEndDragColumn;
    property OnExpanded: TSCTreeNodeEvent read FOnExpanded write FOnExpanded;
    property OnExpanding: TSCTreeNodeAcceptEvent read FOnExpanding write FOnExpanding;
    property OnFocusedColumnChange: TNotifyEvent read FOnFocusedColumnChange write FOnFocusedColumnChange;
    property OnFocusedColumnChanging: TNotifyEvent read FOnFocusedColumnChanging write FOnFocusedColumnChanging;
    property OnFocusedNodeChange: TNotifyEvent read FOnFocusedNodeChange write FOnFocusedNodeChange;
    property OnFocusedNodeChanging: TNotifyEvent read FOnFocusedNodeChanging write FOnFocusedNodeChanging;
    property OnGetEditorClass: TSCTreeGetEditorEvent read FOnGetEditorClass write FOnGetEditorClass;
    property OnGetGroup: TSCTreeNodeAcceptEvent read FOnGetGroup write FOnGetGroup;
    property OnGetNodeLevel: TSCTreeNodeLevelEvent read FOnGetNodeLevel write FOnGetNodeLevel;
    property OnHideEditor: TSCTreeCellEvent read FOnHideEditor write FOnHideEditor;
    property OnHottrack: TSCTreeHottrackEvent read FOnHottrack write FOnHottrack;
    property OnPaintHint: TSCTreePaintHint read FOnPaintHint write FOnPaintHint;
    property OnPrepareEditor: TSCTreePrepareEditorEvent read FOnPrepareEditor write FOnPrepareEditor;
    property OnPreviewEvent: TSCTreePreviewEvent read FOnPreviewEvent write FOnPreviewEvent;
    property OnSelectionChange: TNotifyEvent read FOnSelectionChange write FOnSelectionChange;
    property OnSelectionChanging: TNotifyEvent read FOnSelectionChanging write FOnSelectionChanging;
    property OnShowEditor: TSCTreeCellAcceptEvent read FOnShowEditor write FOnShowEditor;
    property OnShowItemHint: TSCTreeHintEvent read FOnShowItemHint write FOnShowItemHint;
    property OnValidateEditor: TSCTreeValidateEditorEvent read FOnValidateEditor write FOnValidateEditor;
  end;

  TSCTreeList = class(TSCCustomTreeList)
  published
    property Align;
    property Anchors;
    property BorderProps;
    property Buttons;
    property CheckButtonStyle;
    property Color;
    property Colors;
    property Constraints;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FlagImages;
    property Font;
    property ColumnImages;
    property HeaderFont;
    property Hottrack;
    property Images;
    property Indent;
    property Indicator;
    property LineStyle;
    property LookAndFeel;
    property NodeIndent;
    property OptionsBehaviour;
    property OptionsView;
    property PaintStyle;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property PreviewAlignment;
    property PreviewFont;
    property RowHeight;
    property Scrollbars;
    property ShowHint;
    property StateImages;
    property TabOrder;
    property TabStop;
    property UnderlineStyle;
    property Visible;
    property WaitForExpandTime;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;

    property OnBeginDragNode;
    property OnButtonStateChanging;
    property OnButtonStateChanged;
    property OnCanFocusNode;
    property OnCanSelectNode;
    property OnCanUnselectNode;
    property OnCollapsing;
    property OnCollapsed;
    property OnCompare;
    property OnCustomDrawButton;
    property OnCustomDrawBack;
    property OnCustomDrawCheckButton;
    property OnCustomDrawColumn;
    property OnCustomDrawFlag;
    property OnCustomDrawHeader;
    property OnCustomDrawImage;
    property OnCustomDrawIndent;
    property OnCustomDrawIndicator;
    property OnCustomDrawCell;
    property OnCustomDrawPreview;
    property OnCustomDrawSelection;
    property OnCustomDrawState;
    property OnCanDragColumn;
    property OnDrawUnderline;
    property OnStartColumnDragging;
    property OnDragOverColumn;
    property OnEndDragColumn;
    property OnExpanded;
    property OnExpanding;
    property OnFocusedColumnChange;
    property OnFocusedColumnChanging;
    property OnFocusedNodeChange;
    property OnFocusedNodeChanging;
    property OnGetEditorClass;
    property OnGetGroup;
    property OnGetNodeLevel;
    property OnHideEditor;
    property OnHottrack;
    property OnPaintHint;
    property OnPrepareEditor;
    property OnPreviewEvent;
    property OnSelectionChange;
    property OnSelectionChanging;
    property OnShowEditor;
    property OnShowItemHint;
    property OnValidateEditor;
  end;

{$R *.RES}

implementation

const
  // Timer IDs
  SC_TreeHintTimerID       = 5643;
  SC_TreeFlashTimerID      = 2896;
  SC_TreeClickTimerID      = 2734;
  SC_TreeDragExpandTimerID = 7645;
  SC_TreeDragScrollTimerID = 8153;

  // Cursors
  SC_TreeDragCopy      = -1503;
  SC_TreeMultiDragCopy = -1504;
  SC_TreeUpScroll      = -1505;
  SC_TreeDownScroll    = -1506;
  SC_TreeFullScroll    = -1507;
  SC_TreeHSize         = -1508;
  SC_TreeVSize         = -1509;

  SC_CurrentStreamVersion = 3;

  SC_DragIndent           = 20;
  SC_DragNodeScrollTime   = 100;
  SC_TreeNodeVertSpacing  = 6;
  SC_TreeNodeHorzSpacing  = 4;
  SC_TreeCheckButtonSize  = 19;
  SC_TreeLevelIndent      = 19;
  SC_TreeCheckboxSize     = 13;
  SC_TreeRadioButtonSize  = 12;
  SC_TreeRowSizerHeight   = 5;
  SC_TreeHeaderHeight     = 19;
  SC_TreeHeaderHorzSpace  = 4;
  SC_TreeHeaderImageSpace = 4;
  SC_TreeHeaderVertSpace  = 6;
  SC_TreePreviewSpace     = 6;
  SC_TreeColumnSizerWidth = 5;
  SC_TreeArrowsWidth      = 24;
  SC_TreeArrowsHeight     = 20;
  SC_TreeArrowsHidePos    = -100;
  SC_TreeColHorzSpacing   = 2;
  SC_TreeColVertSpacing   = 2;
  SC_TreeSortArrowSize    = 18;
  SC_TreeSortArrowWidth   = 8;
  SC_TreeSortArrowHeight  = 4;


  SC_DragCursors: array [Boolean, Boolean] of Integer =
    ((crDrag, SC_TreeDragCopy), (crMultiDrag, SC_TreeMultiDragCopy));


const
  SC_DragExpandHitParts: TSCTreeParts = [sctpButton];
  SC_NodeHitParts: TSCTreeParts = [sctpCheckButton, sctpIcon, sctpStateIcon,
    sctpLabel, sctpPreview];
  SC_DragHitParts: TSCTreeParts = [sctpIcon, sctpStateIcon, sctpLabel,
    sctpIndicator, sctpFlag, sctpPreview];
  SC_NodeHotParts: TSCTreeParts = [sctpCheckButton, sctpIcon, sctpStateIcon,
    sctpLabel, sctpPreview];

type
  TSCTreeNodeInfo = record
    AllowGrayed: Boolean;
    ButtonState: Word;
    ButtonType: Word;
    Color: TColor;
    Enabled: Boolean;
    Height: Integer;
    GroupHeader: Boolean;
    HotIndex: Integer;
    ImageIndex: Integer;
    FlagIndex: Integer;
    SelectedIndex: Integer;
    StateIndex: Integer;
    Underline: Boolean;
    Count: Integer;
    StrCount: Integer;
    Str: record end;
  end;
  PSCTreeNodeInfo = ^TSCTreeNodeInfo;

  TSCTreeNodeInfo2 = record
    AllowGrayed: Boolean;
    ButtonState: Word;
    ButtonType: Word;
    Color: TColor;
    Enabled: Boolean;
    Height: Integer;
    GroupHeader: Boolean;
    HotIndex: Integer;
    ImageIndex: Integer;
    FlagIndex: Integer;
    SelectedIndex: Integer;
    StateIndex: Integer;
    Underline: Boolean;
    Count: Integer;
    Preview: Boolean;
    StrCount: Integer;
    PreviewText: record end;
    Str: record end;
  end;
  PSCTreeNodeInfo2 = ^TSCTreeNodeInfo2;

  TSCTreeNodeInfo3 = record
    AllowGrayed: Boolean;
    ButtonState: Word;
    ButtonType: Word;
    Color: TColor;
    Enabled: Boolean;
    Expanded: Boolean;
    Height: Integer;
    GroupHeader: Boolean;
    HotIndex: Integer;
    ImageIndex: Integer;
    FlagIndex: Integer;
    SelectedIndex: Integer;
    StateIndex: Integer;
    Underline: Boolean;
    Count: Integer;
    Preview: Boolean;
    StrCount: Integer;
    PreviewText: record end;
    Str: record end;
  end;
  PSCTreeNodeInfo3 = ^TSCTreeNodeInfo3;

  TSCTreeColumnInfo = record
    Alignment: Integer;
    Color: TColor;
    DisableCaption: Boolean;
    DisableDragging: Boolean;
    DisableEditor: Boolean;
    DisableSizing: Boolean;
    Enabled: Boolean;
    HeaderAlignment: Integer;
    ImageIndex: Integer;
    MinWidth: Integer;
    SortDirection: Integer;
    Tag: Integer;
    Visible: Boolean;
    Width: Integer;
    Caption: record end;
  end;
  PSCTreeColumnInfo = ^TSCTreeColumnInfo;

  TSCTreeNodeStr = record
    Text: String;
    Image: Integer;
    Obj: TObject;
    Column: Word;
  end;
  PSCTreeNodeStr = ^TSCTreeNodeStr;

  TSCNodeInfo = record
    Node: TSCTreeNode;
    Index: Integer;
  end;
  PSCNodeInfo = ^TSCNodeInfo;

  TSCTreeListEdit = class(TSCCustomEdit);

  TSCTreeListItem = record
    Text: String;
    Image: Integer;
    Obj: TObject;
  end;
  PSCTreeListItem = ^TSCTreeListItem;


function CompareItems(Item1, Item2: Pointer): Integer;
begin
  Result := Integer(PSCNodeInfo(Item1)^.Node) - Integer(PSCNodeInfo(Item2)^.Node);
end;

{ TSCTreeColumn }

procedure TSCTreeColumn.Assign(Source: TPersistent);
var
  OldSort: TSCTreeSortDirection;
begin
  if Source is TSCTreeColumn then
  begin
    OldSort := FSortDirection;

    with TSCTreeColumn(Source) do
    begin
      Self.FAlignment := Alignment;
      Self.FCaption := Caption;
      Self.FColor := Color;
      Self.FDisableCaption := DisableCaption;
      Self.FDisableDragging := DisableDragging;
      Self.FDisableEditor := DisableEditor;
      Self.FDisableSizing := DisableSizing;
      Self.FDisableSorting := DisableSorting;
      Self.FEnabled := Enabled;
      Self.FHeaderAlignment := HeaderAlignment;
      Self.FImageIndex := ImageIndex;
      Self.FMinWidth := MinWidth;
      Self.FSortDirection := SortDirection;
      Self.FTag := Tag;
      Self.FVisible := Visible;
      Self.FWidth := Width;
    end;

    if FDisableSorting then
      Self.FSortDirection := sctsdNone;

    if (FSortDirection <> sctsdNone) and
      (OldSort <> FSortDirection) and (FOwner <> nil) then
      FOwner.ColumnSortChanged(Self, FSortDirection);

    Changed(True);
  end else
    inherited Assign(Source);
end;

procedure TSCTreeColumn.Changed(Forced: Boolean);
begin
  if FOwner <> nil then FOwner.ColumnChanged(Self, Forced);
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

constructor TSCTreeColumn.Create(AOwner: TSCCustomTreeList);
begin
  inherited Create;
  Initialize;
  if AOwner <> nil then AOwner.InsertColumn(Self);
end;

destructor TSCTreeColumn.Destroy;
begin
  if Assigned(FOnDestroy) then FOnDestroy(Self);
  if FOwner <> nil then FOwner.RemoveColumn(Self);
  inherited Destroy;
end;

function TSCTreeColumn.GetDisplayText: String;
begin
  Result := FCaption;
  if (Result = '') and (FOwner <> nil) then
    Result := 'TSCTreeColumn ' + IntToStr(FOwner.IndexOfColumn(Self));
end;

function TSCTreeColumn.GetImageList: TCustomImageList;
begin
  Result := nil;
  if FOwner <> nil then Result := FOwner.ColumnImages;
end;

function TSCTreeColumn.GetIndex: Integer;
begin
  Result := -1;
  if FOwner <> nil then Result := FOwner.IndexOfColumn(Self);
end;

function TSCTreeColumn.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCTreeColumn.GetTreeList: TSCCustomTreeList;
begin
  Result := FOwner;
end;

function TSCTreeColumn.GetVisibleIndex: Integer;
begin
  Result := -1;
  if FOwner <> nil then Result := FOwner.GetVisibleIndexOf(Self);
end;

procedure TSCTreeColumn.Initialize;
begin
  FAlignment := taLeftJustify;
  FColor := clNone;
  FDeleting := False;
  FDisableCaption := False;
  FDisableDragging := False;
  FDisableEditor := False;
  FDisableSizing := False;
  FDisableSorting := False;
  FEnabled := True;
  FHeaderAlignment := taLeftJustify;
  FImageIndex := -1;
  FMinWidth := 20;
  FSortDirection := sctsdNone;
  FVisible := True;
  FWidth := 100;
  FScaledWidth := -1;
end;

procedure TSCTreeColumn.ReadData(AStream: TStream);
var
  S: string;
  L, Size: Integer;
  AInfo: PSCTreeColumnInfo;
begin
  AStream.ReadBuffer(Size, SizeOf(Size));
  GetMem(AInfo, Size);
  try
    AStream.ReadBuffer(AInfo^, Size);

    Alignment := TLeftRight(AInfo^.Alignment);
    Color := AInfo^.Color;
    DisableCaption := AInfo^.DisableCaption;
    DisableDragging := AInfo^.DisableDragging;
    DisableEditor := AInfo^.DisableEditor;
    DisableSizing := AInfo^.DisableSizing;
    Enabled := AInfo^.Enabled;
    HeaderAlignment := TLeftRight(AInfo^.HeaderAlignment);
    ImageIndex := AInfo^.ImageIndex;
    MinWidth := AInfo^.MinWidth;
    SortDirection := TSCTreeSortDirection(AInfo^.SortDirection);
    Tag := AInfo^.Tag;
    Visible := AInfo^.Visible;
    Width := AInfo^.Width;

    AStream.ReadBuffer(L, SizeOf(L));

    SetLength(S, L);
    AStream.ReadBuffer(S[1], L);
    SetCaption(S);
  finally
    FreeMem(AInfo, Size);
  end;
end;

procedure TSCTreeColumn.SetAlignment(Value: TLeftRight);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Changed(False);
  end;
end;

procedure TSCTreeColumn.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(True);

    if Assigned(FOnChangeCaption) then
      FOnChangeCaption(Self);
  end;
end;

procedure TSCTreeColumn.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed(False);
  end;
end;

procedure TSCTreeColumn.SetDisableCaption(Value: Boolean);
begin
  if FDisableCaption <> Value then
  begin
    FDisableCaption := Value;
    Changed(False);
  end;
end;

procedure TSCTreeColumn.SetDisableDragging(Value: Boolean);
begin
  if FDisableDragging <> Value then
  begin
    FDisableDragging := Value;
    Changed(False);
  end;
end;

procedure TSCTreeColumn.SetDisableEditor(Value: Boolean);
begin
  if FDisableEditor <> Value then
  begin
    FDisableEditor := Value;
    Changed(False);
  end;
end;

procedure TSCTreeColumn.SetDisableSizing(Value: Boolean);
begin
  if FDisableSizing <> Value then
  begin
    FDisableSizing := Value;
    Changed(False);
  end;
end;

procedure TSCTreeColumn.SetDisableSorting(Value: Boolean);
begin
  if FDisableSorting <> Value then
  begin
    FDisableSorting := Value;
    if Value then FSortDirection := sctsdNone;
    Changed(True);
  end;
end;

procedure TSCTreeColumn.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed(False);
  end;
end;

procedure TSCTreeColumn.SetHeaderAlignment(Value: TLeftRight);
begin
  if FHeaderAlignment <> Value then
  begin
    FHeaderAlignment := Value;
    Changed(False);
  end;
end;

procedure TSCTreeColumn.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed(False);
  end;
end;

procedure TSCTreeColumn.SetMinWidth(Value: Integer);
var
  OldWidth: Integer;
begin
  if Value < 0 then Value := 0;

  if FMinWidth <> Value then
  begin
    FMinWidth := Value;

    OldWidth := FWidth;
    VerifyColWidth(FWidth);

    Changed(OldWidth <> FWidth);
  end;
end;

procedure TSCTreeColumn.SetScaledWidth(Value: Integer);
begin
  FScaledWidth := Value;
  if FScaledWidth < 0 then FScaledWidth := -1;
end;

procedure TSCTreeColumn.SetSortDirection(Value: TSCTreeSortDirection);
begin
  if FSortDirection <> Value then
  begin
    if (Value <> sctsdNone) and (FOwner <> nil) then
      FOwner.ColumnSortChanged(Self, Value);

    if FSortDirection <> Value then
    begin
      FSortDirection := Value;
      Changed(True);
    end;
  end;
end;

procedure TSCTreeColumn.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(True);
  end;
end;

procedure TSCTreeColumn.SetWidth(Value: Integer);
begin
  VerifyColWidth(Value);

  if FWidth <> Value then
  begin
    FWidth := Value;
    Changed(FVisible);
  end;
end;

procedure TSCTreeColumn.VerifyColWidth(var AWidth: Integer);
begin
  if AWidth < 0 then AWidth := 0;
  if (FMinWidth > 0) and (AWidth < FMinWidth) then
    AWidth := FMinWidth;
end;

procedure TSCTreeColumn.WriteData(AStream: TStream);
var
  S: String;
  L, Size: Integer;
  AInfo: PSCTreeColumnInfo;
begin
  Size := SizeOf(TSCTreeColumnInfo);

  GetMem(AInfo, Size);
  try
    AInfo^.Alignment := Integer(Alignment);
    AInfo^.Color := Color;
    AInfo^.DisableCaption := DisableCaption;
    AInfo^.DisableDragging := DisableDragging;
    AInfo^.DisableEditor := DisableEditor;
    AInfo^.DisableSizing := DisableSizing;
    AInfo^.Enabled := Enabled;
    AInfo^.HeaderAlignment := Integer(HeaderAlignment);
    AInfo^.ImageIndex := ImageIndex;
    AInfo^.MinWidth := MinWidth;
    AInfo^.SortDirection := Integer(SortDirection);
    AInfo^.Tag := Tag;
    AInfo^.Visible := Visible;
    AInfo^.Width := Width;

    AStream.WriteBuffer(Size, SizeOf(Size));
    AStream.WriteBuffer(AInfo^, Size);

    S := FCaption;
    L := Length(S);

    AStream.WriteBuffer(L, SizeOf(L));
    AStream.WriteBuffer(S[1], L);
  finally
    FreeMem(AInfo, Size);
  end;
end;

{ TSCTreeNode }

procedure TSCTreeNode.Assign(Source: TPersistent);
begin
  if Source is TSCTreeNode then
  begin
    BeginUpdate;
    try
      FWidth := -1;

      with TSCTreeNode(Source) do
      begin
        Self.FColor := Color;
        Self.FButtonState := ButtonState;
        Self.FEnabled := Enabled;
        Self.FFlagIndex := FlagIndex;
        Self.FHotIndex := ImageIndex;
        Self.FSelectedIndex := SelectedIndex;
        Self.FStateIndex := StateIndex;
        Self.FGroupHeader := GroupHeader;
        Self.FImageIndex := ImageIndex;
        Self.FUnderline := Underline;
        Self.FPreview := Preview;

        Self.SetString(0, GetString(0));
        Self.SetPreviewText(PreviewText);

        Self.SetAllowGrayed(AllowGrayed);
        Self.SetButtonType(ButtonType);
        Self.SetButtonState(ButtonState);
        Self.SetExpanded(Expanded);
      end;
    finally
      EndUpdate;
    end;
  end else
    inherited Assign(Source);
end;

procedure TSCTreeNode.Collapse(Recursive: Boolean);
var
  I: Integer;
begin
  if not Recursive then
    SetExpanded(False)
  else 
  if GetHasChildren then
  begin
    BeginUpdate;
    try
      SetExpanded(False);
      if FList <> nil then
        for I := 0 to FList.Count-1 do
          TSCTreeNode(FList[I]).Collapse(Recursive);
    finally
      EndUpdate;
    end;  
  end;
end;

constructor TSCTreeNode.Create(AOwner: TSCCustomTreeList);
begin
  inherited Create;
  FOwner := AOwner;
  FRootNode := False;
  Initialize;
end;

destructor TSCTreeNode.Destroy;
begin
  FDeleting := True;
  Destroying;

  DeleteChildren;
  ClearData;

  if FParent <> nil then
    FParent.RemoveChild(Self)
  else
  if (FOwner <> nil) and Self.FRootNode then
    FOwner.RemoveChild(Self);

  FreeAndNil(FList);
  FreeAndNil(FStrings);

  inherited Destroy;
end;

function TSCTreeNode.CanExpand(Expand: Boolean): Boolean;
begin
  Result := False;
  if FOwner <> nil then
  begin
    if Expand then
      Result := FOwner.CanExpand(Self)
    else
      Result := FOwner.CanCollapse(Self);
  end;
end;

procedure TSCTreeNode.Changed;
begin
  DoChanged;
  if (FUpdateCount = 0) and (FOwner <> nil) then
    FOwner.ChildChanged(Self);
end;

procedure TSCTreeNode.ExpandNode(Expand: Boolean);
begin
  if (FOwner <> nil) and CanExpand(Expand) then
  begin
    if Expand then
      FOwner.Expand(Self)
    else
      FOwner.Collapse(Self);
  end;
end;

procedure TSCTreeNode.Expand(Recursive: Boolean);
var
  I: Integer;
begin
  if not Recursive then
    SetExpanded(True)
  else
  if GetHasChildren then
  begin
    BeginUpdate;
    try
      SetExpanded(True);
      if FList <> nil then
        for I := 0 to FList.Count-1 do
          TSCTreeNode(FList[I]).Expand(Recursive);
    finally
      EndUpdate;
    end;  
  end;
end;

function TSCTreeNode.GetChildCount(All: Boolean): LongInt;
var
  I: Integer;
begin
  Result := 0;
  if (FExpanded or All) and (FList <> nil) then
  begin
    Result := FList.Count;
    for I := 0 to FList.Count-1 do
      Inc(Result, TSCTreeNode(FList[I]).GetChildCount(All));
  end;
end;

function TSCTreeNode.GetCount: Integer;
begin
  Result := 0;
  if FList <> nil then Result := FList.Count;
end;

function TSCTreeNode.GetFocused: Boolean;
begin
  Result := (FOwner <> nil) and (FOwner.FocusedNode = Self);
end;

function TSCTreeNode.GetText: String;
begin
  Result := GetString(0);
end;

procedure TSCTreeNode.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    EnabledChanged;
  end;
end;

procedure TSCTreeNode.SetExpanded(Value: Boolean);
begin
  if GetHasChildren and (FExpanded <> Value) then
    ExpandNode(Value);
end;

procedure TSCTreeNode.SetFocused(Value: Boolean);
begin
  if FOwner <> nil then
  begin
    if Value then
      FOwner.SetFocusedNode(Self)
    else
    if FOwner.FocusedNode = Self then
      FOwner.SetFocusedNode(nil);
  end;
end;

procedure TSCTreeNode.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed;
  end;
end;

procedure TSCTreeNode.SetSelectedIndex(Value: TImageIndex);
begin
  if FSelectedIndex <> Value then
  begin
    FSelectedIndex := Value;
    Changed;
  end;
end;

procedure TSCTreeNode.SetStateIndex(Value: TImageIndex);
begin
  if FStateIndex <> Value then
  begin
    FStateIndex := Value;
    Changed;
  end;
end;

procedure TSCTreeNode.SetText(const Value: String);
begin
  if GetString(0) <> Value then
  begin
    FWidth := -1;
    SetString(0, Value);
  end;
end;

procedure TSCTreeNode.BeginUpdate;
begin
  Inc(FUpdateCount);

  if FUpdateCount = 1 then
  begin
    FreeAndNil(FNodeList);
    FreeAndNil(FIndexList);
  end;
end;

procedure TSCTreeNode.DeleteChild(Index: Integer);
var
  ANode: TSCTreeNode;
begin
  if FList <> nil then
  begin
    ANode := TSCTreeNode(FList[Index]);
    RemoveChild(ANode);
    ANode.Free;
  end;
end;

procedure TSCTreeNode.Destroying;
begin
  FDestroying := True;
end;

procedure TSCTreeNode.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);

    if FUpdateCount = 0 then
    begin
      ArrangeNodeList;
      Changed;
    end;
  end;
end;

procedure TSCTreeNode.Exchange(Index1, Index2: Integer);
begin
  if (FList <> nil) and (Index1 <> Index2) then
  begin
    FList.Exchange(Index1, Index2);
    ChildExchanged(Index1, Index2);
  end;
end;

function TSCTreeNode.Extract(Index: Integer): TSCTreeNode;
begin
  Result := nil;
  if FList <> nil then
  begin
    Result := TSCTreeNode(FList[Index]);
    RemoveChild(Result);
  end;  
end;

function TSCTreeNode.GetFirstChild: TSCTreeNode;
begin
  Result := nil;
  if (FList <> nil) and (FList.Count > 0) then
    Result := TSCTreeNode(FList[0]);
end;

function TSCTreeNode.GetHasChildren: Boolean;
begin
  Result := (FList <> nil) and (FList.Count > 0);
end;

function TSCTreeNode.GetIndex: Integer;
begin
  Result := -1;
  if FParent <> nil then
    Result := FParent.IndexOf(Self)
  else if FOwner <> nil then
    Result := FOwner.IndexOf(Self);
end;

function TSCTreeNode.GetChild(Index: Integer): TSCTreeNode;
begin
  Result := nil;
  if (FList <> nil) and (Index > -1) and (Index < FList.Count) then
    Result := TSCTreeNode(FList[Index]);
end;

function TSCTreeNode.GetLastChild: TSCTreeNode;
begin
  Result := nil;
  if (FList <> nil) and (FList.Count > 0) then
    Result := TSCTreeNode(FList[FList.Count-1]);
end;

function TSCTreeNode.GetNext: TSCTreeNode;
var
  ANode: TSCTreeNode;
begin
  Result := GetFirstChild;

  if Result = nil then
  begin
    Result := GetNextSibling;

    if (Result = nil) and (Parent <> nil) then
    begin
      Result := Parent;
      repeat
        ANode := Result.GetNextSibling;
        Result := Result.Parent;
      until (ANode <> nil) or (Result = nil);
      Result := ANode;
    end;
  end;
end;

function TSCTreeNode.GetNextChild(ANode: TSCTreeNode): TSCTreeNode;
var
  I: Integer;
begin
  Result := nil;
  if (ANode <> nil) and (FList <> nil) and
    (ANode.FParent = Self) then
  begin
    I := Self.Index + 1;
    if I < Count then
      Result := TSCTreeNode(FList[I]);
  end;
end;

function TSCTreeNode.GetNextSibling: TSCTreeNode;
var
  I: Integer;
begin
  Result := nil;
  if Parent <> nil then
  begin
    I := Self.Index + 1;
    if I < Parent.Count then
      Result := Parent.Items[I];
  end else
  if FOwner <> nil then
  begin
    I := Self.Index + 1;
    if I < FOwner.Count then
      Result := FOwner.Items[I];
  end;
end;

function TSCTreeNode.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCTreeNode.GetPrev: TSCTreeNode;
var
  ANode: TSCTreeNode;
begin
  Result := GetPrevSibling;
  if Result <> nil then
  begin
    ANode := Result;
    repeat
      Result := ANode;
      ANode := Result.GetLastChild;
    until ANode = nil;
  end else
    Result := Parent
end;

function TSCTreeNode.GetPrevSibling: TSCTreeNode;
var
  I: Integer;
begin
  Result := nil;
  if Parent <> nil then
  begin
    I := Self.Index - 1;
    if I > -1 then
      Result := Parent.Items[I];
  end else
  if FOwner <> nil then
  begin
    I := Self.Index - 1;
    if I > -1 then
      Result := FOwner.Items[I];
  end;
end;

function TSCTreeNode.GetPrevChild(ANode: TSCTreeNode): TSCTreeNode;
var
  I: Integer;
begin
  Result := nil;
  if (ANode <> nil) and (FList <> nil) and
    (ANode.FParent = Self) then
  begin
    I := Self.Index - 1;
    if I > -1 then
      Result := TSCTreeNode(FList[I]);
  end;
end;

function TSCTreeNode.GetPrevParentNode: TSCTreeNode;
var
  I: Integer;
begin
  Result := nil;
  if Parent <> nil then
  begin
    I := Self.Index - 1;
    if I > -1 then
      Result := Parent.Items[I]
    else
      Result := Parent;
  end;
end;

function TSCTreeNode.HasAsParent(Value: TSCTreeNode): Boolean;
var
  ANode: TSCTreeNode;
begin
  Result := False;
  ANode := Parent;

  while ANode <> nil do
  begin
    if ANode = Value then
    begin
      Result := True;
      Break;
    end;
    ANode := ANode.Parent;
  end;
end;

procedure TSCTreeNode.HeightChanged;
begin
  DoHeightChanged;
  if (FUpdateCount = 0) and (FOwner <> nil) then
    FOwner.ChildHeightChanged(Self);
end;

function TSCTreeNode.IndexOf(ANode: TSCTreeNode): Integer;
var
  AIndex: Integer;
begin
  Result := -1;
  if (ANode <> nil) and (ANode.FParent = Self) and (FList <> nil) then
  begin
    if FUpdateCount > 0 then
      Result := FList.IndexOf(ANode)
    else begin
      AIndex := SearchNodeList(ANode);
      if (AIndex > -1) and (AIndex < FIndexList.Count) then
        Result := Integer(FIndexList[AIndex])
      else
        Result := FList.IndexOf(ANode);
    end;
  end;
end;

function TSCTreeNode.InsertChild(Index: Integer): TSCTreeNode;
begin
  Result := nil;
  if (Index > -1) and (((FList = nil) and (Index = 0)) or
    ((FList <> nil) and (Index <= FList.Count))) then
  begin
    Result := CreateNode;
    InsertChild(Result, Index);
  end;
end;

procedure TSCTreeNode.InsertChild(Index: Integer; ANode: TSCTreeNode);
begin
  if (Index > -1) and (((FList = nil) and (Index = 0)) or
    ((FList <> nil) and (Index <= FList.Count))) and (ANode <> nil) and
    (ANode.FOwner = Self.FOwner) and (ANode.FParent <> Self) then
    InsertChild(ANode, Index);
end;

procedure TSCTreeNode.InsertChild(ANode: TSCTreeNode; Index: Integer);
var
  AList: TList;
  AParent: TSCTreeNode;
begin
  if (ANode <> nil) and (ANode.FParent <> Self) and (Index > -1) then
  begin
    AList := CreateChildList;

    if Index <= AList.Count then
    begin
      AParent := ANode.Parent;

      if AParent <> nil then
        AParent.RemoveChild(ANode)
      else
      if (FOwner <> nil) and ANode.RootNode then
        FOwner.RemoveChild(ANode);

      InsertingChild(ANode);
      AList.Insert(Index, ANode);

      ANode.FParent := Self;
      ANode.SetOwner(Self.FOwner);
      ANode.FRootNode := False;

      ArrangeNodeList;
      ChildInserted(ANode);
    end;
  end;
end;

function TSCTreeNode.GetUpdating: Boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TSCTreeNode.ChildInserted(ANode: TSCTreeNode);
begin
  if FOwner <> nil then
    FOwner.ChildInserted(Self, ANode);
end;

procedure TSCTreeNode.ChildMoved(OldIndex, NewIndex: Integer);
begin
  if FOwner <> nil then
    FOwner.ChildMoved(Self, OldIndex, NewIndex);
end;

procedure TSCTreeNode.ChildRemoved(ANode: TSCTreeNode);
begin
  if FOwner <> nil then
    FOwner.ChildRemoved(Self, ANode);
end;

procedure TSCTreeNode.Move(CurIndex, NewIndex: Integer);
begin
  if (FList <> nil) and (CurIndex <> NewIndex) then
  begin
    FList.Move(CurIndex, NewIndex);
    ChildMoved(CurIndex, NewIndex);
  end;
end;

function TSCTreeNode.Remove(ANode: TSCTreeNode): Integer;
begin
  Result := IndexOf(ANode);
  if Result > -1 then
    Extract(Result);
end;

procedure TSCTreeNode.RemoveChild(ANode: TSCTreeNode);
var
  AIndex: Integer;
begin
  if (ANode <> nil) and (ANode.FParent = Self) then
  begin
    RemovingChild(ANode);

    if FList <> nil then
    begin
      AIndex := Self.IndexOf(ANode);

      if AIndex > -1 then
      begin
        FList.Delete(AIndex);

        if FUseIndexList then
        begin
          AIndex := SearchNodeList(ANode);
          if AIndex > -1 then
          begin
            FNodeList.Delete(AIndex);
            if AIndex < FIndexList.Count then
              FIndexList.Delete(AIndex);
          end;
        end;
      end;

      if FList.Count = 0 then
      begin
        FreeAndNil(FList);

        FreeAndNil(FNodeList);
        FreeAndNil(FIndexList);
      end;
    end;

    ANode.FParent := nil;

    ANode.ResetNode(True);
    ANode.SetOwner(nil);

    ArrangeNodeList;
    ChildRemoved(ANode);
  end;
end;

function TSCTreeNode.InsertChild(BeforeNode: TSCTreeNode): TSCTreeNode;
var
  I: Integer;
begin
  Result := nil;
  if BeforeNode = nil then
    Result := AddChild
  else
  if BeforeNode.FParent = Self then
  begin
    I := BeforeNode.Index + 1;
    Result := InsertChild(I);
  end;
end;

procedure TSCTreeNode.MakeVisible;
begin
  if FOwner <> nil then FOwner.MakeNodeVisible(Self, False);
end;

function TSCTreeNode.GetNodeRect(TextOnly: Boolean): TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if FOwner <> nil then
    Result := FOwner.GetNodeRect(Self, TextOnly);
end;

function TSCTreeNode.EditText: Boolean;
begin
  Result := False;
  if FOwner <> nil then Result := FOwner.Edit(FOwner.AsCell(Self, nil));
end;

procedure TSCTreeNode.EndEdit(Cancel: Boolean);
begin
  if FOwner <> nil then FOwner.EndEdit(Cancel);
end;

procedure TSCTreeNode.Delete;
begin
  if not Deleting then
    Self.Free;
end;

procedure TSCTreeNode.ChildExchanged(Index1, Index2: Integer);
begin
  if FOwner <> nil then
    FOwner.ChildExchanged(Self, Index1, Index2);
end;

function TSCTreeNode.GetLevel: Integer;
var
  AParent: TSCTreeNode;
begin
  Result := 0;

  AParent := FParent;
  while AParent <> nil do
  begin
    Inc(Result);
    AParent := AParent.Parent;
  end;
end;

function TSCTreeNode.CreateNode: TSCTreeNode;
var
  ANodeClass: TSCTreeNodeClass;
begin
  ANodeClass := TSCTreeNodeClass(Self.ClassType);
  Result := TSCTreeNode(ANodeClass.Create(nil));

  Result.FOwner := Self.FOwner;
end;

procedure TSCTreeNode.DoChanged;
begin
  //
end;

procedure TSCTreeNode.DoHeightChanged;
begin
  //
end;

procedure TSCTreeNode.Paint(ACol: TSCTreeColumn; ACanvas: TCanvas;
  ARect: TRect; ASelected, AFocused, AHot: Boolean; AFont: TFont;
  var AColor: TColor; var AText: string; var Handled: Boolean);
begin
  //
end;

procedure TSCTreeNode.PaintPreview(ACanvas: TCanvas; ARect: TRect; ASelected,
  AFocused, AHot: Boolean; AFont: TFont; var AColor: TColor; var AText: string;
  var Handled: Boolean);
begin
  //
end;

procedure TSCTreeNode.SetHeight(Value: Integer);
begin
  if Value < -1 then Value := -1;
  
  if FHeight <> Value then
  begin
    FHeight := Value;
    HeightChanged;
  end;
end;

procedure TSCTreeNode.SetHotIndex(Value: TImageIndex);
begin
  if FHotIndex <> Value then
  begin
    FHotIndex := Value;
    Changed;
  end;
end;

function TSCTreeNode.GetNextVisible: TSCTreeNode;
var
  ANode: TSCTreeNode;
begin
  Result := nil;
  if Expanded then Result := GetFirstChild;

  if Result = nil then
  begin
    Result := GetNextSibling;

    if (Result = nil) and (Parent <> nil) then
    begin
      Result := Parent;
      repeat
        ANode := Result.GetNextSibling;
        Result := Result.Parent;
      until (ANode <> nil) or (Result = nil);
      Result := ANode;
    end;
  end;
end;

function TSCTreeNode.GetPrevVisible: TSCTreeNode;
var
  ANode: TSCTreeNode;
begin
  Result := GetPrevSibling;
  if Result <> nil then
  begin
    ANode := Result;
    repeat
      Result := ANode;
      if not Result.Expanded then
        Break;

      ANode := Result.GetLastChild;
    until ANode = nil;
  end else
    Result := Parent;
end;

procedure TSCTreeNode.ResetNode(Recursive: Boolean);
var
  I: Integer;
  Child: TSCTreeNode;
begin
  FWidth := -1;
  if Recursive and (FList <> nil) then
    for I := 0 to FList.Count-1 do
    begin
      Child := TSCTreeNode(FList[I]);
      Child.ResetNode(Recursive);
    end;
end;

procedure TSCTreeNode.DoTextChanged;
begin
  //
end;

procedure TSCTreeNode.TextChanged;
begin
  DoTextChanged;
  if (FUpdateCount = 0) and (FOwner <> nil) then
    FOwner.ChildTextChanged(Self);
end;

function TSCTreeNode.GetSelected: Boolean;
begin
  Result := False;
  if FOwner <> nil then
    Result := FOwner.IsSelected(Self);
end;

procedure TSCTreeNode.SetOwner(AOwner: TSCCustomTreeList);
var
  I: Integer;
  Child: TSCTreeNode;
begin
  if (FOwner <> nil) and (AOwner <> FOwner) then
    FOwner.ChildDeleted(Self);

  FOwner := AOwner;

  if FList <> nil then
    for I := 0 to FList.Count-1 do
    begin
      Child := TSCTreeNode(FList[I]);
      Child.SetOwner(AOwner);
    end;
end;

function TSCTreeNode.CreateChildList: TList;
begin
  if FList = nil then
  begin
    FList := TList.Create;

    FNodeList := TList.Create;
    FIndexList := TList.Create;
  end;

  Result := FList;
end;

procedure TSCTreeNode.InsertingChild(ANode: TSCTreeNode);
begin
  if FOwner <> nil then
    FOwner.InsertingChild(Self, ANode);
end;

procedure TSCTreeNode.RemovingChild(ANode: TSCTreeNode);
begin
  if FOwner <> nil then
    FOwner.RemovingChild(Self, ANode);
end;

function TSCTreeNode.GetImages: TCustomImageList;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.Images;
end;

function TSCTreeNode.GetStateImages: TCustomImageList;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.StateImages;
end;

procedure TSCTreeNode.Initialize;
begin
  FSorting := 0;
  FRootNode := False;
  FAllowGrayed := False;
  FButtonState := sctcsUnchecked;
  FButtonType := sctcbNone;
  FWidth := -1;
  FColor := clNone;
  FDeleting := False;
  FEnabled := True;
  FHeight := -1;
  FImageIndex := -1;
  FHotIndex := -1;
  FFlagIndex := -1;
  FSelectedIndex := -1;
  FStateIndex := -1;
  FGroupHeader := False;
  FPreview := True;
  FUnderline := False;
  FUseIndexList := False;
end;

function TSCTreeNode.GetWidth: Integer;
begin
  Result := -1;
  if FOwner <> nil then
  begin
    Result := FWidth;
    if Result < 0 then
    begin
      FWidth := FOwner.GetNodeWidth(Self);
      Result := FWidth;
    end;
  end;
end;

procedure TSCTreeNode.EnabledChanged;
begin
  DoEnabledChanged;
  if (FUpdateCount = 0) and (FOwner <> nil) then
    FOwner.ChildEnabledChanged(Self);
end;

function TSCTreeNode.GetObject(Index: Integer): TObject;
var
  P: PSCTreeNodeStr;
begin
  Result := nil;
  if (Index > -1) and (FStrings <> nil) and (Index < FStrings.Count) then
  begin
    P := FStrings[Index];
    Result := P^.Obj;
  end;
end;

function TSCTreeNode.GetString(Index: Integer): String;
var
  P: PSCTreeNodeStr;
begin
  Result := '';
  if (Index > -1) and (FStrings <> nil) and (Index < FStrings.Count) then
  begin
    P := FStrings[Index];
    Result := P^.Text;
  end;
end;

procedure TSCTreeNode.SetObject(Index: Integer; const Value: TObject);
var
  P: PSCTreeNodeStr;
begin
  if Index > -1 then
  begin
    ExpandStrings(Index + 1);
    if (FStrings <> nil) and (Index < FStrings.Count) then
    begin
      P := FStrings[Index];
      P^.Obj := Value;
    end;
  end;
end;

procedure TSCTreeNode.SetString(Index: Integer; const Value: String);
var
  P: PSCTreeNodeStr;
begin
  if Index > -1 then
  begin
    ExpandStrings(Index + 1);

    if (FStrings <> nil) and (Index < FStrings.Count) then
    begin
      P := FStrings[Index];

      if P^.Text <> Value then
      begin
        P^.Text := Value;
        if (FOwner = nil) or ((FOwner.ColumnCount = 0) and (Index > 0)) then
          Changed
        else TextChanged;
      end;
    end;
  end;
end;

function TSCTreeNode.GetData(Index: Integer): Integer;
var
  P: PSCTreeNodeStr;
begin
  Result := -1;
  if (Index > -1) and (FStrings <> nil) and (Index < FStrings.Count) then
  begin
    P := FStrings[Index];
    Result := P^.Image;
  end;
end;

procedure TSCTreeNode.SetData(Index: Integer; Value: Integer);
var
  P: PSCTreeNodeStr;
begin
  if Index > -1 then
  begin
    ExpandStrings(Index + 1);
    if (FStrings <> nil) and (Index < FStrings.Count) then
    begin
      P := FStrings[Index];
      if P^.Image <> Value then
      begin
        P^.Image := Value;
        DoChanged;
      end;
    end;
  end;  
end;

function TSCTreeNode.GetImageIndex: TImageIndex;
begin
  Result := FImageIndex;
end;

procedure TSCTreeNode.ClearData;
var
  I: Integer;
  P: PSCTreeNodeStr;
begin
  if FStrings <> nil then
  begin
    for I := FStrings.Count-1 downto 0 do
    begin
      P := FStrings[I];
      Dispose(P);
      FStrings.Delete(I);
    end;

    FreeAndNil(FStrings);
    TextChanged;
  end;
end;

procedure TSCTreeNode.ExpandStrings(ACount: Integer);
var
  P: PSCTreeNodeStr;
begin
  if ACount > 0 then
  begin
    if FStrings = nil then
      FStrings := TList.Create;

    while FStrings.Count < ACount do
    begin
      New(P);
      FStrings.Add(P);
    end;
  end;
end;

procedure TSCTreeNode.SetGroupHeader(Value: Boolean);
begin
  if FGroupHeader <> Value then
  begin
    FGroupHeader := Value;
    Changed;
  end;
end;

procedure TSCTreeNode.SetUnderline(Value: Boolean);
begin
  if FUnderline <> Value then
  begin
    FUnderline := Value;
    Changed;
  end;
end;

procedure TSCTreeNode.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed;
  end;
end;

procedure TSCTreeNode.ArrangeNodeList;

  procedure AppendNode(ANode: TSCTreeNode; AList: TList);
  var
    Index: Integer;
    PNode: PSCNodeInfo;
  begin
    New(PNode);
    Index := AList.Add(PNode);

    PNode^.Node := ANode;
    PNode^.Index := Index;
  end;

var
  I: Integer;
  AList: TList;
  PNode: PSCNodeInfo;
  Child: TSCTreeNode;
begin
  if not (FDeleting or FDestroying) and FUseIndexList and (FUpdateCount = 0) then
  begin
    if FNodeList = nil then
      FNodeList := TList.Create;

    if FIndexList = nil then
      FIndexList := TList.Create;

    AList := TList.Create;
    try
      AList.Capacity := FList.Count;

      for I := 0 to FList.Count-1 do
      begin
        Child := TSCTreeNode(FList[I]);
        AppendNode(Child, AList);
      end;

      AList.Sort(CompareItems);

      FIndexList.Clear;
      FIndexList.Capacity := AList.Count;

      FNodeList.Clear;
      FNodeList.Capacity := AList.Count;

      for I := 0 to AList.Count - 1 do
      begin
        PNode := PSCNodeInfo(AList[I]);

        FNodeList.Add(Pointer(PNode^.Node));
        FIndexList.Add(Pointer(PNode^.Index));

        Dispose(PNode);
      end;
    finally
      AList.Free;
    end;
  end;
end;

function TSCTreeNode.SearchNodeList(ANode: TSCTreeNode): Integer;
var
  L, H, I, C, IntNode: Integer;
begin
  Result := -1;
  if (FNodeList <> nil) and (FIndexList <> nil) then
  begin
    L := 0;
    H := FNodeList.Count - 1;
    IntNode := Integer(ANode);

    while L <= H do
    begin
      I := (L + H) shr 1;
      {$IFDEF SC_DELPHIXE2_UP}
      C := Integer(FNodeList.List[I]) - IntNode;
      {$ELSE}
      C := Integer(FNodeList.List^[I]) - IntNode;
      {$ENDIF}

      if C = 0 then
      begin
        Result := I;
        Break;
      end
      else
      if (C < 0) then
        L := I + 1
      else H := I - 1;
    end;
  end;
end;

procedure TSCTreeNode.SetUseIndexList(Value: Boolean);
begin
  if FUseIndexList <> Value then
  begin
    FUseIndexList := Value;

    if Value then
      ArrangeNodeList
    else begin
      FreeAndNil(FNodeList);
      FreeAndNil(FIndexList);
    end;
  end;
end;

function TSCTreeNode.GetFlagImages: TCustomImageList;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.FlagImages;
end;

procedure TSCTreeNode.SetFlagIndex(Value: TImageIndex);
begin
  if FFlagIndex <> Value then
  begin
    FFlagIndex := Value;
    Changed;
  end;
end;

procedure TSCTreeNode.SetButtonState(Value: TSCTreeCheckButtonState);
begin
  VerifyButtonState(Value);

  if GetButtonState <> Value then
  begin
    if FOwner = nil then
      FButtonState := Value
    else FOwner.SetButtonState(Self, Value);
  end;
end;

procedure TSCTreeNode.SetAllowGrayed(Value: Boolean);
begin
  if FAllowGrayed <> Value then
  begin
    FAllowGrayed := Value;
    if not FAllowGrayed and (FButtonState = sctcsGrayed) then
    begin
      if FOwner = nil then
        FButtonState := sctcsChecked
      else FOwner.SetButtonState(Self, sctcsUnchecked);
    end;
  end;
end;

procedure TSCTreeNode.ButtonTypeChanged;
begin
  DoCheckButtonChanged;
  if (FUpdateCount = 0) and (FOwner <> nil) then
    FOwner.ChildButtonTypeChanged(Self);
end;

procedure TSCTreeNode.DoCheckButtonChanged;
begin
  //
end;

procedure TSCTreeNode.SetButtonType(Value: TSCTreeCheckButton);
begin
  if FButtonType <> Value then
  begin
    FButtonType := Value;
    if (FOwner <> nil) and FOwner.IsShowCheckButtons then
      ButtonTypeChanged;
  end;
end;

function TSCTreeNode.GetButtonState: TSCTreeCheckButtonState;
begin
  Result := FButtonState;
  VerifyButtonState(Result);
end;

procedure TSCTreeNode.VerifyButtonState(var AState: TSCTreeCheckButtonState);
begin
  if FButtonType = sctcbNone then
    AState := sctcsUnchecked
  else
  if (AState = sctcsGrayed) and (not FAllowGrayed or
    (FButtonType = sctcbRadioButton)) then
    AState := sctcsChecked;
end;

procedure TSCTreeNode.ReadData1(AStream: TStream);
var
  S: string;
  AInfo: PSCTreeNodeInfo;
  I, L, Size, ChildCount: Integer;
begin
  AStream.ReadBuffer(Size, SizeOf(Size));
  GetMem(AInfo, Size);
  try
    AStream.ReadBuffer(AInfo^, Size);

    AllowGrayed := AInfo^.AllowGrayed;
    ButtonState := TSCTreeCheckButtonState(AInfo^.ButtonState);
    ButtonType := TSCTreeCheckButton(AInfo^.ButtonType);
    Color := AInfo^.Color;
    Enabled := AInfo^.Enabled;
    GroupHeader := AInfo^.GroupHeader;
    Underline := AInfo^.Underline;
    Height := AInfo^.Height;

    StateIndex := AInfo^.FlagIndex;
    HotIndex := AInfo^.HotIndex;
    ImageIndex := AInfo^.ImageIndex;
    SelectedIndex := AInfo^.SelectedIndex;
    StateIndex := AInfo^.StateIndex;

    ChildCount := AInfo^.Count;

    for I := 0 to AInfo^.StrCount - 1 do
    begin
      AStream.ReadBuffer(L, SizeOf(L));

      SetLength(S, L);
      AStream.ReadBuffer(S[1], L);
      SetString(I, S);
    end;
  finally
    FreeMem(AInfo, Size);
  end;

  for I := 0 to ChildCount - 1 do
    with TSCTreeNode(AddChild) do
      ReadData(AStream);
end;

procedure TSCTreeNode.ReadData2(AStream: TStream);
var
  S: string;
  AInfo: PSCTreeNodeInfo2;
  I, L, Size, ChildCount: Integer;
begin
  AStream.ReadBuffer(Size, SizeOf(Size));
  GetMem(AInfo, Size);
  try
    AStream.ReadBuffer(AInfo^, Size);

    AllowGrayed := AInfo^.AllowGrayed;
    ButtonState := TSCTreeCheckButtonState(AInfo^.ButtonState);
    ButtonType := TSCTreeCheckButton(AInfo^.ButtonType);
    Color := AInfo^.Color;
    Enabled := AInfo^.Enabled;
    GroupHeader := AInfo^.GroupHeader;
    Underline := AInfo^.Underline;
    Height := AInfo^.Height;

    StateIndex := AInfo^.FlagIndex;
    HotIndex := AInfo^.HotIndex;
    ImageIndex := AInfo^.ImageIndex;
    SelectedIndex := AInfo^.SelectedIndex;
    StateIndex := AInfo^.StateIndex;
    Preview := AInfo^.Preview;

    ChildCount := AInfo^.Count;

    // Read preview string
    AStream.ReadBuffer(L, SizeOf(L));

    SetLength(S, L);
    AStream.ReadBuffer(S[1], L);
    SetPreviewText(S);

    // Read strings
    for I := 0 to AInfo^.StrCount - 1 do
    begin
      AStream.ReadBuffer(L, SizeOf(L));

      SetLength(S, L);
      AStream.ReadBuffer(S[1], L);
      SetString(I, S);
    end;
  finally
    FreeMem(AInfo, Size);
  end;

  for I := 0 to ChildCount - 1 do
    with TSCTreeNode(AddChild) do
      ReadData(AStream);
end;

procedure TSCTreeNode.ReadData3(AStream: TStream);
var
  S: string;
  AInfo: PSCTreeNodeInfo3;
  I, L, Size, ChildCount: Integer;
begin
  AStream.ReadBuffer(Size, SizeOf(Size));
  GetMem(AInfo, Size);
  try
    AStream.ReadBuffer(AInfo^, Size);

    AllowGrayed := AInfo^.AllowGrayed;
    ButtonState := TSCTreeCheckButtonState(AInfo^.ButtonState);
    ButtonType := TSCTreeCheckButton(AInfo^.ButtonType);
    Color := AInfo^.Color;
    Enabled := AInfo^.Enabled;
    ExpandNode(AInfo^.Expanded);
    GroupHeader := AInfo^.GroupHeader;
    Underline := AInfo^.Underline;
    Height := AInfo^.Height;

    StateIndex := AInfo^.FlagIndex;
    HotIndex := AInfo^.HotIndex;
    ImageIndex := AInfo^.ImageIndex;
    SelectedIndex := AInfo^.SelectedIndex;
    StateIndex := AInfo^.StateIndex;
    Preview := AInfo^.Preview;

    ChildCount := AInfo^.Count;

    // Read preview string
    AStream.ReadBuffer(L, SizeOf(L));

    SetLength(S, L);
    AStream.ReadBuffer(S[1], L);
    SetPreviewText(S);

    // Read strings
    for I := 0 to AInfo^.StrCount - 1 do
    begin
      AStream.ReadBuffer(L, SizeOf(L));

      SetLength(S, L);
      AStream.ReadBuffer(S[1], L);
      SetString(I, S);
    end;
  finally
    FreeMem(AInfo, Size);
  end;

  for I := 0 to ChildCount - 1 do
    with TSCTreeNode(AddChild) do
      ReadData(AStream);
end;

procedure TSCTreeNode.ReadData(AStream: TStream);
begin
  if FOwner.FStreamVersion = 1 then
    ReadData1(AStream)
  else if FOwner.FStreamVersion = 2 then
    ReadData2(AStream)
  else if FOwner.FStreamVersion = 3 then
    ReadData3(AStream);
end;

procedure TSCTreeNode.WriteData(AStream: TStream);
var
  S: String;
  AInfo: PSCTreeNodeInfo3;
  I, L, Size, ChildCount: Integer;
begin
  ChildCount := Count;
  Size := SizeOf(TSCTreeNodeInfo2);

  GetMem(AInfo, Size);
  try
    AInfo^.AllowGrayed := AllowGrayed;
    AInfo^.ButtonState := Word(ButtonState);
    AInfo^.ButtonType := Word(ButtonType);
    AInfo^.Color := Color;
    AInfo^.Enabled := Enabled;
    AInfo^.Expanded := Expanded;
    AInfo^.GroupHeader := GroupHeader;
    AInfo^.Underline := Underline;
    AInfo^.Height := Height;

    AInfo^.StateIndex := FlagIndex;
    AInfo^.HotIndex := HotIndex;
    AInfo^.ImageIndex := ImageIndex;
    AInfo^.SelectedIndex := SelectedIndex;
    AInfo^.StateIndex := StateIndex;
    AInfo^.Preview := Preview;

    AInfo^.Count := Self.Count;

    AInfo^.StrCount := 0;
    if FStrings <> nil then
      AInfo^.StrCount := FStrings.Count;

    AStream.WriteBuffer(Size, SizeOf(Size));
    AStream.WriteBuffer(AInfo^, Size);

    // Write preview string
    S := GetPreviewText;
    L := Length(S);

    AStream.WriteBuffer(L, SizeOf(L));
    AStream.WriteBuffer(S[1], L);

    // Write strings
    if FStrings <> nil then
      for I := 0 to AInfo^.StrCount - 1 do
      begin
        S := GetString(I);
        L := Length(S);

        AStream.WriteBuffer(L, SizeOf(L));
        AStream.WriteBuffer(S[1], L);
      end;
  finally
    FreeMem(AInfo, Size);
  end;

  if FList <> nil then
    for I := 0 to ChildCount - 1 do
      TSCTreeNode(FList[I]).WriteData(AStream);
end;

procedure TSCTreeNode.DeleteChildren;
begin
  if FList <> nil then
  begin
    FreeAndNil(FNodeList);
    FreeAndNil(FIndexList);

    if FList.Count = 0 then
      FreeAndNil(FList)
    else begin
      BeginUpdate;
      try
        while (FList <> nil) and (FList.Count > 0) do
          TObject(FList.Last).Free;

        FreeAndNil(FList);
      finally
        EndUpdate;
      end;
    end;
  end;
end;

function TSCTreeNode.AddChild: TSCTreeNode;
var
  LastChild: Integer;
begin
  LastChild := 0;
  if FList <> nil then
    LastChild := FList.Count;

  Result := CreateNode;
  InsertChild(Result, LastChild);
end;

function TSCTreeNode.AddChildFirst: TSCTreeNode;
begin
  Result := InsertChild(0);
end;

function TSCTreeNode.GetSorting: Boolean;
begin
  Result := FSorting > 0;
end;

function TSCTreeNode.GetStringsCount: Integer;
begin
  Result := 0;
  if FStrings <> nil then Result := FStrings.Count;
end;

procedure TSCTreeNode.MoveNodeValues(FromIndex, ToIndex: Integer);
var
  I: Integer;
begin
  ExpandStrings(ToIndex + 1);
  ExpandStrings(FromIndex + 1);

  if FStrings <> nil then
    FStrings.Move(FromIndex, ToIndex);

  if FList <> nil then
    for I := 0 to FList.Count-1 do
      TSCTreeNode(FList[I]).MoveNodeValues(FromIndex, ToIndex);
end;

procedure TSCTreeNode.InsertString(Index: Integer; const S: String;
  Recursive: Boolean);
var
  I: Integer;
  P: PSCTreeNodeStr;
begin
  BeginUpdate;
  try
    if (FStrings <> nil) and (Index > -1) and
      (Index <= FStrings.Count) then
    begin
      New(P);
      P^.Text := S;

      FStrings.Insert(Index, P);
    end;

    if FList <> nil then
      for I := 0 to FList.Count-1 do
        TSCTreeNode(FList[I]).InsertString(Index, S, True);
  finally
    EndUpdate;
  end;
end;

procedure TSCTreeNode.RemoveString(Index: Integer; Recursive: Boolean);
var
  I: Integer;
  P: PSCTreeNodeStr;
begin
  BeginUpdate;
  try
    if (FStrings <> nil) and (Index > -1) and
      (Index < FStrings.Count) then
    begin
      P := FStrings[Index];
      FStrings.Delete(Index);
      Dispose(P);
    end;

    if FList <> nil then
      for I := 0 to FList.Count-1 do
        TSCTreeNode(FList[I]).RemoveString(Index, True);
  finally
    EndUpdate;
  end;
end;

procedure TSCTreeNode.DoEnabledChanged;
begin
  //
end;

function TSCTreeNode.GetPreviewText: String;
begin
  Result := FPreviewText;
end;

procedure TSCTreeNode.SetPreviewText(const Value: String);
begin
  if FPreviewText <> Value then
  begin
    FPreviewText := Value;
    if FPreview then
      Changed;
  end;
end;

procedure TSCTreeNode.SetPreview(Value: Boolean);
begin
  if FPreview <> Value then
  begin
    FPreview := Value;
    Changed;
  end;
end;

{ TSCCustomTreeList }

procedure TSCCustomTreeList.Add(ANode: TSCTreeNode);
var
  AIndex: Integer;
begin
  if (ANode <> nil) and (ANode.FOwner = Self) then
  begin
    AIndex := -1;
    if ANode.FParent = nil then
      AIndex := FList.IndexOf(ANode);

    if AIndex = -1 then
      InsertChild(ANode, FList.Count);
  end;
end;

function TSCCustomTreeList.AddFirst: TSCTreeNode;
begin
  Result := GetDefaultNodeClass.Create(Self);
  InsertChild(Result, 0);
end;

function TSCCustomTreeList.Add: TSCTreeNode;
begin
  Result := GetDefaultNodeClass.Create(Self);
  InsertChild(Result, FList.Count);
end;

function TSCCustomTreeList.CanCollapse(ANode: TSCTreeNode): Boolean;
begin
  Result := True;
end;

function TSCCustomTreeList.CanExpand(ANode: TSCTreeNode): Boolean;
begin
  Result := True;
end;

function TSCCustomTreeList.CanFocusNode(ANode: TSCTreeNode): Boolean;
begin
  Result := False;
  if (ANode = nil) or (ANode.Owner = Self) then
  begin
    Result := DoCanFocusNode(ANode);
    if Result and Assigned(FOnCanFocusNode) then
      FOnCanFocusNode(Self, ANode, Result);
  end;
end;

procedure TSCCustomTreeList.ClearColumns;
var
  AIndex: Integer;
  AColumn: TSCTreeColumn;
begin
  if FColumns.Count > 0 then
  begin
    BeginUpdate;
    try
      while FColumns.Count > 0 do
      begin
        AIndex := FColumns.Count-1;
        AColumn := TSCTreeColumn(FColumns.Last);

        ColumnRemoving(AColumn);

        FColumns.Delete(AIndex);
        AColumn.FOwner := nil;

        ColumnRemoved(AColumn);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TSCCustomTreeList.ClearNodes;
var
  AIndex: Integer;
  ANode: TSCTreeNode;
begin
  if FList.Count > 0 then
  begin
    BeginUpdate;
    try
      FTopVisibleNode := nil;
      FFocusedNode := nil;
      FHotNode := nil;
      FHotPart := sctpNowhere;
      FHotColumn := nil;
      FMouseDownNode := nil;
      FHintNode := nil;
      FHintColumn := nil;
      FClickedNode := nil;
      FClickedColumn := nil;

      ResetFlash;

      if DragScrolling then
        StopDragScrolling;

      if Dragging then
        EndDrag(False);

      KillClickTimer;
      KillHintTimer;
      KillDragExpandTimer;
      KillDragScrollTimer;

      FRealList.Clear;
      FNodeList.Clear;
      FIndexList.Clear;

      while FList.Count > 0 do
      begin
        AIndex := FList.Count-1;
        ANode := TSCTreeNode(FList.Last);

        RemovingChild(nil, ANode);

        ANode.ResetNode(True);
        ANode.SetOwner(nil);

        FList.Delete(AIndex);

        ANode.FOwner := nil;
        ANode.FParent := nil;

        ChildRemoved(nil, ANode);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TSCCustomTreeList.CMFontChanged(var Message: TMessage);
var
  I: Integer;
  N: TSCTreeNode;
begin
  inherited;
  Canvas.Font.Assign(Self.Font);

  FMinRowHeight := Canvas.TextHeight('Rq');
  FDefaultHeight := FMinRowHeight + SC_TreeNodeVertSpacing;

  if (FList <> nil) and (FList.Count > 0) then
  begin
    for I := 0 to FList.Count-1 do
    begin
      N := TSCTreeNode(FList[I]);
      N.ResetNode(True);
    end;

    CalculateRowWidth;
    Invalidate;
  end;
end;

procedure TSCCustomTreeList.Collapse(ANode: TSCTreeNode);
var
  Allow: Boolean;
  TopNode: TSCTreeNode;
begin
  if (ANode <> nil) and ANode.Expanded and (ANode.FOwner = Self) then
  begin
    Allow := CanCollapse(ANode);
    if Allow and Assigned(FOnCollapsing) then
      FOnCollapsing(Self, ANode, Allow);

    if Allow then
    begin
      ANode.FExpanded := False;

      TopNode := GetTopVisibleNode;
      if IsParentNodeOf(TopNode, ANode) then
        SetTopVisibleNode(GetTopParentNode(TopNode));

      if (ANode.Count > 0) and ParentExpanded(ANode) then
      begin
        ArrangeNodeList;
        CalculateRowWidth;
      end;

      UpdateNode(ANode, True, sctupBelow);

      if Assigned(FOnCollapsed) then
        FOnCollapsed(Self, ANode);
    end;
  end;
end;

constructor TSCCustomTreeList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csCaptureMouse, csDoubleClicks,
    csDisplayDragImage]; 

  SetBounds(Left, Top, 200, 145);
  ParentColor := False;
  Color := clWindow;
  Border := sccb3DLowered;
  DoubleBuffered := True;
  TabStop := True;
  BlendColor := False;

  FSizingNode   := nil;
  FSizingColumn := nil;
  FDownColumn   := nil;
  FDragColumn   := nil;
  FColumnDown   := False;
  FNeedsArrangement := False;
  FDesignChange := False;
  FPreviewAlignment := taLeftJustify;

  FStopSetFocused := False;
  FArrowsPos := SC_TreeArrowsHidePos;
  FSizingPos := -1;
  FPrevSizingPos  := -1;
  FSizingStartPos := -1;
  FSizedRowHeight := -1;
  FSizingStartDif := 0;

  FSorting := 0;
  FSortNeeded := 0;
  FInRowCalculation := 0;
  FStreamVersion := SC_CurrentStreamVersion;
  FState := sctlsIdle;
  FLineStyle := sctlsDot;
  FLookAndFeel := sctlfDefault;
  FPaintStyle := sctpsDefault;
  FCheckButtonStyle := sctcsDefault;
  FOptionsBehaviour := SCDefaultBehaviourOptions;
  FOptionsView := SCDefaultViewOptions;
  FUnderlineStyle := sctusTilda;

  FHintTimer := -1;
  FClickTimer := -1;
  FDragExpandTimer := -1;
  FDragScrollTimer := -1;
  FDragPoint := Point(-1, -1);
  FFlashTimer := -1;
  FFlashStart := 0;
  FFlashParts := [];

  FMouseDownNode := nil;
  FHotNode := nil;
  FHotPart := sctpNowhere;
  FHotColumn := nil;
  FHintNode := nil;
  FHintColumn := nil;
  FHintOldNode := nil;
  FHintOldColumn := nil;
  FClickedNode := nil;
  FClickedColumn := nil;
  FDragNode := nil;
  FDragOverNode := nil;
  FFlashNode := nil;

  FCtrlFlag := False;
  FIndicator := 12;
  FRowHeight := -1;
  FMinRowHeight := -1;
  FDefaultHeight := -1;
  FShowDragImage := True;
  FWaitForExpandTime := SCWaitForExpandTime;

  FRealList := TList.Create;
  FNodeList := TList.Create;
  FIndexList := TList.Create;

  FHeaderHeight := -1;
  FDefaultHeaderHeight := -1;
  FPreviewHeight := -1;

  FHeaderFont := TFont.Create;
  FHeaderFont.OnChange := HeaderFontChanged;

  FPreviewFont := TFont.Create;
  FPreviewFont.OnChange := PreviewFontChanged;

  FInplaceEditor := nil;
  FInplaceEditorClass := TSCCustomEdit;

  FList := TList.Create;
  FColumns := TList.Create;

  FDragNodeList := TList.Create;
  FSelectionList := TList.Create;

  FButtons := TSCTreeButton.Create(Self);
  FColors := TSCTreeColors.Create(Self);
  FHottrack := TSCTreeHottrack.Create(Self);

  FFlagChangeLink := TChangeLink.Create;
  FFlagChangeLink.OnChange := FlagImageListChange;

  FStateChangeLink := TChangeLink.Create;
  FStateChangeLink.OnChange := StateImageListChange;

  FColumnChangeLink := TChangeLink.Create;
  FColumnChangeLink.OnChange := HeaderImageListChange;
end;

procedure TSCCustomTreeList.Delete(Index: Integer);
var
  ANode: TSCTreeNode;
begin
  ANode := TSCTreeNode(FList[Index]);
  RemoveChild(ANode);
  ANode.Free;
end;

procedure TSCCustomTreeList.DeleteColumn(Index: Integer);
begin
  Self.RemoveColumn(TSCTreeColumn(FColumns[Index]));
end;

destructor TSCCustomTreeList.Destroy;
begin
  Destroying;

  CancelDragSize;
  PostEditor;

  FreeAndNil(FArrowsBitmap);
  FreeAndNil(FSaveBitmap);

  FColumnChangeLink.OnChange := nil;
  FreeAndNil(FColumnChangeLink);

  FStateChangeLink.OnChange := nil;
  FreeAndNil(FStateChangeLink);

  FFlagChangeLink.OnChange := nil;
  FreeAndNil(FFlagChangeLink);

  FreeAndNil(FFlagImages);
  FreeAndNil(FStateImages);

  FreeAndNil(FList);
  FreeAndNil(FDragNodeList);
  FreeAndNil(FRealList);
  FreeAndNil(FNodeList);
  FreeAndNil(FIndexList);
  FreeAndNil(FSelectionList);
  FreeAndNil(FButtons);
  FreeAndNil(FColors);
  FreeAndNil(FHottrack);

  ClearColumns;
  FreeAndNil(FColumns);

  FHeaderFont.OnChange := nil;
  FreeAndNil(FHeaderFont);

  FPreviewFont.OnChange := nil;
  FreeAndNil(FPreviewFont);

  HideHintWindow;
  StopDragScrolling;
  inherited Destroy;
end;

function TSCCustomTreeList.GetNodeRect(ANode: TSCTreeNode;
  TextOnly: Boolean): TRect;
var
  CR: TRect;
  ATopNode, Node2: TSCTreeNode;
  I, AImage, ImgOffset, NdIndent,
  ALevel, AIndex, ATopIndex: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated and HasAnyNode and (ANode <> nil) and
    (ANode.Owner = Self) and ParentExpanded(ANode) then
  begin
    CR := GetNodesRect;
    Result := Rect(CR.Left, CR.Top, CR.Right - CR.Left,
      CR.Top + GetNodeHeight(ANode));

    OffsetRect(Result, -FHorizontalPos, 0);
    Result.Right := CR.Right;

    if TextOnly then
    begin
      NdIndent := 0;
      Result.Right := Result.Left + GetNodeWidth(ANode);

      if IsShowIndicator then
        Inc(NdIndent, FIndicator);

      Inc(NdIndent, Self.Indent);
      if IsShowFlagImages and (FFlagImages <> nil) then
        Inc(NdIndent, FFlagImages.Width);

      ALevel := GetNodeLevel(ANode);
      Inc(NdIndent, ALevel*GetLevelIndent);

      if IsShowCheckButtons and (ANode.ButtonType <> sctcbNone) then
        Inc(NdIndent, SC_TreeCheckButtonSize);

      OffsetRect(Result, NdIndent, 0);

      ImgOffset := 0;
      if Self.Images <> nil then
      begin
        Inc(ImgOffset, Images.Width);
        Inc(Result.Right, Images.Width);

        if IsShowStateImages and (FStateImages <> nil) then
        begin
          AImage := ANode.StateIndex;
          if (AImage > -1) and (AImage < FStateImages.Count) then
          begin
            Inc(ImgOffset, FStateImages.Width);
            Inc(Result.Right, FStateImages.Width);
          end;
        end;
      end;

      Inc(Result.Left, ImgOffset);
    end;

    if (Result.Right > CR.Right) and IsDrawEndEllipsis then
      Result.Right := CR.Right;

    if (IsRowStyle or IsShowPreview) and (Result.Right < CR.Right) then
      Result.Right := CR.Right;

    ATopNode := GetTopVisibleNode;

    if ANode <> ATopNode then
    begin
      AIndex := GetAbsoluteIndex(ANode, True);
      ATopIndex := GetAbsoluteIndex(ATopNode, True);

      if AIndex > ATopIndex then
      begin
        for I := ATopIndex to AIndex - 1 do
        begin
          Node2 := TSCTreeNode(FRealList[I]);
          OffsetRect(Result, 0, GetNodeHeight(Node2));
        end;
      end else
        for I := ATopIndex - 1 downto AIndex do
        begin
          Node2 := TSCTreeNode(FRealList[I]);
          OffsetRect(Result, 0, -GetNodeHeight(Node2));
        end;
    end;
  end;
end;

function TSCCustomTreeList.Edit(ACell: TSCTreeCell): Boolean;
begin
  Result := False;
  if (ACell.Node <> nil) and (ACell.Node.FOwner = Self) then
  begin
    SetFocusedNode(ACell.Node);
    if (ACell.Column <> nil) then
      SetFocusedColumn(ACell.Column);

    ShowEditor;
    Result := (FFocusedNode = ACell.Node) and
      (Editing or Dragging or DragScrolling);
  end;
end;

procedure TSCCustomTreeList.EndEdit(Cancel: Boolean);
begin
  if Editing then
  begin
    if Cancel then
      HideEditor
    else PostEditor;
  end;
end;

procedure TSCCustomTreeList.Exchange(Index1, Index2: Integer);
begin
  if Index1 <> Index2 then
  begin
    FList.Exchange(Index1, Index2);
    ChildExchanged(nil, Index1, Index2);
  end;
end;

procedure TSCCustomTreeList.Expand(ANode: TSCTreeNode);
var
  Allow: Boolean;
begin
  if (ANode <> nil) and not ANode.Expanded and (ANode.FOwner = Self) then
  begin
    Allow := CanExpand(ANode);
    if Allow and Assigned(FOnExpanding) then
      FOnExpanding(Self, ANode, Allow);

    if Allow then
    begin
      ANode.FExpanded := True;

      if (ANode.Count > 0) and ParentExpanded(ANode) then
      begin
        ArrangeNodeList;
        CalculateRowWidth;
      end;

      UpdateNode(ANode, True, sctupBelow);

      if Assigned(FOnExpanded) then
        FOnExpanded(Self, ANode);
    end;
  end;
end;

function TSCCustomTreeList.Extract(Index: Integer): TSCTreeNode;
begin
  Result := nil;
  if (Index > -1) and (Index < FList.Count) then
  begin
    Result := TSCTreeNode(FList[Index]);
    RemoveChild(Result);
  end;
end;

function TSCCustomTreeList.ExtractColumn(Index: Integer): TSCTreeColumn;
begin
  Result := TSCTreeColumn(FColumns[Index]);
  Self.RemoveColumn(Result);
end;

function TSCCustomTreeList.FindCaption(StartIndex: Integer; Value: string;
  Partial, Inclusive, Wrap, CaseSensitive: Boolean): TSCTreeNode;
var
  I: Integer;
  S: String;
begin
  if StartIndex < 0 then
    StartIndex := 0;

  if not Inclusive then
    Inc(StartIndex);

  if not CaseSensitive then
    Value := AnsiLowerCase(Value);

  Result := nil;
  for I := StartIndex to FList.Count-1 do
  begin
    S := TSCTreeNode(FList[I]).Text;
    if not CaseSensitive then
      S := AnsiLowerCase(S);

    if (S = Value) or (Partial and (AnsiPos(Value, S) = 0)) then
    begin
      Result := TSCTreeNode(FList[I]);
      Exit;
    end;
  end;

  if Wrap and (StartIndex > 0) then
    for I := 0 to StartIndex - 1 do
    begin
      S := TSCTreeNode(FList[I]).Text;
      if not CaseSensitive then
        S := AnsiLowerCase(S);

      if (S = Value) or (Partial and (AnsiPos(Value, S) = 0)) then
      begin
        Result := TSCTreeNode(FList[I]);
        Exit;
      end;
    end;
end;

function TSCCustomTreeList.FindData(StartIndex: Integer; Value: Pointer;
  AColumn: Integer; Inclusive, Wrap: Boolean): TSCTreeNode;
var
  I: Integer;
begin
  if StartIndex < 0 then
    StartIndex := 0;

  if not Inclusive then
    Inc(StartIndex);

  Result := nil;
  for I := StartIndex to FList.Count-1 do
    if TSCTreeNode(FList[I]).Data[AColumn] = Integer(Value) then
    begin
      Result := TSCTreeNode(FList[I]);
      Exit;
    end;

  if Wrap and (StartIndex > 0) then
    for I := 0 to StartIndex - 1 do
      if TSCTreeNode(FList[I]).Data[AColumn] = Integer(Value) then
      begin
        Result := TSCTreeNode(FList[I]);
        Exit;
      end;
end;

procedure TSCCustomTreeList.FocusedNodeChanged;
begin
  MakeNodeVisible(FFocusedNode, False);
  if Assigned(FOnFocusedNodeChange) then
    FOnFocusedNodeChange(Self);
end;

procedure TSCCustomTreeList.FocusedNodeChanging;
begin
  if Assigned(FOnFocusedNodeChanging) then
    FOnFocusedNodeChanging(Self);
end;

function TSCCustomTreeList.GetAbsoluteIndex(ANode: TSCTreeNode;
  InExpandeds: Boolean): Integer;
var
  Ret, I, AIndex: Integer;
  CurNode: TSCTreeNode;

  function FindNode(AParent, ANode: TSCTreeNode): Boolean;
  var
    I: Integer;
    CurNode: TSCTreeNode;
  begin
    Result := False;
    for I := 0 to AParent.Count - 1 do
    begin
      CurNode := AParent[I];

      Inc(Ret);
      if CurNode = ANode then
      begin
        Result := True;
        Exit;
      end;

      if FindNode(CurNode, ANode) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

begin
  Result := -1;

  if (ANode <> nil) and (ANode.Owner = Self ) and HasAnyNode then
  begin
    if InExpandeds then
    begin
      AIndex := SearchNodeList(ANode);
      if (AIndex > -1) and (AIndex < FIndexList.Count) then
        Result := Integer(FIndexList[AIndex]);

      Exit;
    end;

    Ret := -1;
    if (FList <> nil) and (FList.Count > 0) then
      for I := 0 to FList.Count - 1 do
      begin
        CurNode := TSCTreeNode(FList[I]);

        Inc(Ret);
        if CurNode = ANode then
        begin
          Result := Ret;
          Exit;
        end;

        if FindNode(CurNode, ANode) then
        begin
          Result := Ret;
          Exit;
        end
      end;
  end;
end;

function TSCCustomTreeList.GetNodeHeight: Integer;
var
  AMin: Integer;
begin
  Result := FRowHeight;

  if HandleAllocated then
  begin
    AMin := GetMinNodeHeight;
    if Result < AMin then Result := AMin;
  end;
end;

function TSCCustomTreeList.GetDefaultNodeClass: TSCTreeNodeClass;
begin
  Result := TSCTreeNode;
end;

function TSCCustomTreeList.GetHitInfo(X, Y: Integer): TSCTreeHitInfo;
var
  P: TPoint;
  ANode: TSCTreeNode;
  ACol: TSCTreeColumn;
  Nodes: TSCTreeNodeArray;
  CellR, R, R2, CR: TRect;
  I, J, H, L, TopOfRow,
  AImage, AIndex, ALevel,
  NdHeight, LvIndent, ColWidth: Integer;
begin
  with Result do
  begin
    Pos    := Point(X, Y);
    Part   := sctpNowhere;
    Node   := nil;
    Column := nil;
  end;

  if (FState = sctlsRowSizing) and CanRowSizing then
  begin
    Result.Node := FSizingNode;
    Result.Part := sctpRowSizer;
    Exit;
  end;

  if (FState = sctlsColumnSizing) and CanSizeColumn(FSizingColumn) then
  begin
    Result.Column := FSizingColumn;
    Result.Part := sctpColumnSizer;
    Exit;
  end;

  P := Point(X, Y);
  CR := GetClientRect;

  if not IsRectEmpty(CR) and PtInRect(CR, P) then
  begin
    if IsShowHeader then
    begin
      H := GetHeaderHeight;

      if H > 0 then
      begin
        R := CR;
        R.Bottom := R.Top + H;

        Inc(CR.Top, H);

        if PtInRect(R, P) then
        begin
          Result.Part := sctpHeader;

          if HasAnyColumn then
          begin
            R.Right := R.Left;

            if IsShowIndicator then
            begin
              Inc(R.Right, FIndicator);
              if PtInRect(R, P) then
                Exit;

              R.Left := R.Right;
            end;

            OffsetRect(R, -FHorizontalPos, 0);

            for I := 0 to FColumns.Count-1 do
            begin
              if R.Left >= CR.Right then
                Break;

              R.Right := R.Left;
              ACol := TSCTreeColumn(FColumns[I]);

              if ACol.Visible and (ACol.Width > 0) then
              begin
                ColWidth := GetColumnWidth(ACol);
                Inc(R.Right, ColWidth);

                if PtInRect(R, P) then
                begin
                  Result.Part := sctpColumn;
                  Result.Column := ACol;

                  if CanColumnSizing and (FState = sctlsIdle) then
                  begin
                    R2 := R;

                    R2.Left := R2.Right;
                    InflateRect(R2, SC_TreeColumnSizerWidth, 0);

                    if PtInRect(R2, P) and CanSizeColumn(ACol) then
                      Result.Part := sctpColumnSizer
                    else begin
                      AIndex := FColumns.IndexOf(ACol);

                      if AIndex > 0 then
                      begin
                        R2 := R;

                        R2.Right := R2.Left;
                        InflateRect(R2, SC_TreeColumnSizerWidth, 0);

                        ACol := TSCTreeColumn(FColumns[AIndex-1]);

                        if PtInRect(R2, P) and CanSizeColumn(ACol) then
                        begin
                          Result.Column := ACol;
                          Result.Part := sctpColumnSizer;
                        end;
                      end;
                    end;
                  end;

                  Break;
                end;

                R.Left := R.Right;
              end;
            end;
          end;

          Exit;
        end;
      end;
    end;

    SetLength(Nodes, 0);
    Nodes := GetVisibleNodes(True);

    if (Nodes <> nil) and (Length(Nodes) > 0) then
    begin
      TopOfRow := 0;
      H := CR.Bottom - CR.Top;

      for I := 0 to Length(Nodes) - 1 do
      begin
        if TopOfRow >= H then
          Exit;

        ANode := Nodes[I];
        if ANode = nil then
          Continue;

        NdHeight := GetNodeHeight(ANode);
        if NdHeight <= 0 then
          Continue;

        R := CR;

        Inc(R.Top, TopOfRow);
        R.Bottom := R.Top + NdHeight;

        Inc(TopOfRow, NdHeight);

        if PtInRect(R, P) then  // if in row rect
        begin
          Result.Node := ANode;
          Result.Part := sctpNowhere;

          R.Right := R.Left;

          if IsShowIndicator then
          begin
            R.Left := R.Right;
            Inc(R.Right, FIndicator);

            if PtInRect(R, P) then
            begin
              Result.Part := sctpIndicator;

              if CanRowSizing then
              begin
                R2 := R;
                R2.Top := R2.Bottom - SC_TreeRowSizerHeight;

                if PtInRect(R2, P) then
                  Result.Part := sctpRowSizer
                else
                if (ANode <> GetTopVisibleNode) then 
                begin
                  R2 := R;
                  R2.Bottom := R2.Top + SC_TreeRowSizerHeight;

                  if PtInRect(R2, P) then
                  begin
                    Result.Part := sctpRowSizer;
                    Result.Node := ANode.GetPrevVisible;
                  end;
                end;
              end;

              Exit;
            end;

            R.Left := R.Right;
          end;

          OffsetRect(R, -FHorizontalPos, 0);

          if FColumns.Count > 0 then
          begin
            R2 := R;
            R2.Right := R2.Left + FRowWidth;

            if IsShowIndicator then
              Dec(R2.Right, FIndicator);

            if not PtInRect(R2, P) then
            begin
              if not IsShowPreview then
                Exit;

              R2.Right := CR.Right;
              
              R2.Top := R2.Bottom - GetPreviewHeight(ANode);
              if R2.Top < R.Top then R2.Top := R.Top;

              if not PtInRect(R2, P) then
                Exit;
            end;
          end;

          if Self.Indent > 0 then
          begin
            R.Left := R.Right;
            Inc(R.Right, Self.Indent);

            if PtInRect(R, P) then
            begin
              Result.Part := sctpIndent;
              Exit;
            end;

            R.Left := R.Right;
          end;

          if IsShowFlagImages and (FFlagImages <> nil) then
          begin
            R.Left := R.Right;
            Inc(R.Right, FFlagImages.Width);

            if PtInRect(R, P) then
            begin
              Result.Part := sctpFlag;
              Exit;
            end;

            R.Left := R.Right;
          end;

          ALevel := GetNodeLevel(ANode);
          LvIndent := GetLevelIndent;

          if (ALevel > 0) and (LvIndent > 0) then
          begin
            R.Left := R.Right;
            Inc(R.Right, ALevel*LvIndent);

            if PtInRect(R, P) then
            begin
              Result.Part := sctpLevelIndent;

              R.Left := R.Right - LvIndent;
              if PtInRect(R, P) then
                Result.Part := sctpButton;

              Exit;
            end;

            R.Left := R.Right;
          end;

          if IsShowCheckButtons and (ANode.ButtonType <> sctcbNone) then
          begin
            R.Left := R.Right;
            Inc(R.Right, SC_TreeCheckButtonSize);

            if PtInRect(R, P) then
            begin
              Result.Part := sctpCheckButton;
              Exit;
            end;

            R.Left := R.Right;
          end;

          if Self.Images <> nil then
          begin
            if IsShowStateImages and (FStateImages <> nil) then
            begin
              AImage := ANode.StateIndex;

              if (AImage > -1) and (AImage < FStateImages.Count) then
              begin
                R.Left := R.Right;
                Inc(R.Right, FStateImages.Width);

                if PtInRect(R, P) then
                begin
                  Result.Part := sctpStateIcon;
                  Exit;
                end;
              end;
            end;

            R.Left := R.Right;
            Inc(R.Right, Self.Images.Width);

            if PtInRect(R, P) then
            begin
              Result.Part := sctpIcon;
              Exit;
            end;

            R.Left := R.Right;
          end;

          if IsShowPreview then
          begin
            R2 := R;
            R2.Right := CR.Right;

            R2.Top := R2.Bottom - GetPreviewHeight(ANode);
            if R2.Top < R.Top then R2.Top := R.Top;

            if PtInRect(R2, P) then
            begin
              Result.Part := sctpPreview;
              Result.Column := nil;

              Exit;
            end;
          end;

          if FColumns.Count > 0 then
          begin
            R2 := CR;

            Inc(R2.Left, FIndicator);
            R2.Right := R2.Left + FRowWidth;

            if IsShowIndicator then
              Dec(R2.Right, FIndicator);

            OffsetRect(R2, -FHorizontalPos, 0);

            if PtInRect(R2, P) then
            begin
              L := 0;
              if IsShowIndicator then
                Inc(L, FIndicator);

              Dec(L, FHorizontalPos);

              for J := 0 to FColumns.Count-1 do
              begin
                ACol := TSCTreeColumn(FColumns[J]);

                if ACol.Visible and (ACol.Width > 0) then
                begin
                  ColWidth := GetColumnWidth(ACol);

                  CellR := R;

                  CellR.Left := L;
                  CellR.Right := L + ColWidth;

                  if L < R.Left then CellR.Left := R.Left;

                  Inc(L, ColWidth);

                  if (CellR.Right > CellR.Left) and PtInRect(CellR, P) then
                  begin
                    Result.Part := sctpLabel;
                    Result.Column := ACol;

                    Break;
                  end;
                end;
              end;
            end;
          end else
          begin
            R.Right := R.Left + ANode.GetWidth;

            if IsDrawEndEllipsis and (R.Right > CR.Right) then
              R.Right := CR.Right;

            if (IsRowStyle or IsShowPreview) and (R.Right < CR.Right) then
              R.Right := CR.Right;

            if PtInRect(R, P) then
              Result.Part := sctpLabel;
          end;

          Exit;
        end;
      end;
    end;
  end;
end;

function TSCCustomTreeList.GetChild(Index: Integer): TSCTreeNode;
begin
  Result := nil;
  if (Index > -1) and (Index < FList.Count) then
    Result := TSCTreeNode(FList[Index]);
end;

function TSCCustomTreeList.GetNodesRect: TRect;
var
  CR: TRect;
  I, R: Integer;
  ACol: TSCTreeColumn;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated then
  begin
    CR := GetClientRect;
    Result := CR;

    if IsShowHeader then
    begin
      Inc(Result.Top, GetHeaderHeight);
      IntersectRect(Result, Result, CR);
    end;

    R := -1;
    for I := 0 to FColumns.Count-1 do
    begin
      ACol := TSCTreeColumn(FColumns[I]);

      if ACol.Visible then
      begin
        if R < 0 then R := 0;
        Inc(R, GetColumnWidth(ACol));
      end;
    end;

    if R > -1 then
    begin
      if IsShowIndicator then
        Inc(R, FIndicator);

      Inc(R, CR.Left);
      if R > CR.Right then R := CR.Right;

      CR.Right := R;
    end;
  end;
end;

function TSCCustomTreeList.GetNodeAt(X, Y: Integer): TSCTreeNode;
var
  HitInfo: TSCTreeHitInfo;
begin
  Result := nil;

  HitInfo := GetHitInfo(X, Y);
  if HitInfo.Part in SC_NodeHitParts then
    Result := HitInfo.Node;
end;

function TSCCustomTreeList.GetTopVisibleIndex: Integer;
begin
  Result := Self.GetAbsoluteIndex(GetTopVisibleNode, True);
  if (Result = -1) and HasAnyNode then
    Result := 0;
end;

function TSCCustomTreeList.IndexOf(ANode: TSCTreeNode): Integer;
begin
  Result := -1;
  if (ANode <> nil) and (ANode.FOwner = Self) and (ANode.FParent = nil) then
    Result := FList.IndexOf(ANode);
end;

function TSCCustomTreeList.IndexOfColumn(AColumn: TSCTreeColumn): Integer;
begin
  Result := FColumns.IndexOf(AColumn);
end;

function TSCCustomTreeList.Insert(Index: Integer): TSCTreeNode;
begin
  Result := nil;
  if (Index > -1) and (Index <= FList.Count) then
  begin
    Result := GetDefaultNodeClass.Create(Self);
    InsertChild(Result, Index);
  end;
end;

procedure TSCCustomTreeList.Insert(Index: Integer; ANode: TSCTreeNode);
var
  AIndex: Integer;
begin
  if (Index > -1) and (Index <= FList.Count) and
    (ANode <> nil) and (ANode.FOwner = Self) then
  begin
    AIndex := -1;
    if ANode.FParent = nil then
      AIndex := FList.IndexOf(ANode);

    if AIndex = -1 then
      InsertChild(ANode, Index);
  end;
end;

function TSCCustomTreeList.Insert(BeforeNode: TSCTreeNode): TSCTreeNode;
var
  AIndex: Integer;
begin
  Result := nil;
  if (BeforeNode = nil) or (BeforeNode.FOwner = Self) then
  begin
    AIndex := -1;
    if (BeforeNode <> nil) and (BeforeNode.FParent = nil) then
      AIndex := FList.IndexOf(BeforeNode);

    if AIndex = -1 then
      Result := Add
    else begin
      Inc(AIndex);
      Result := Insert(AIndex);
    end;
  end;  
end;

procedure TSCCustomTreeList.InsertChild(ANode: TSCTreeNode; Index: Integer);
var
  AParent: TSCTreeNode;
begin
  if (ANode <> nil) and (Index > -1) and (Index <= FList.Count) then
  begin
    AParent := ANode.Parent;

    if AParent <> nil then
      AParent.RemoveChild(ANode)
    else
    if ANode.RootNode then
      Self.RemoveChild(ANode);

    FList.Insert(Index, ANode);

    ANode.SetOwner(Self);
    ANode.FParent := nil;
    ANode.FRootNode := True;

    ChildInserted(nil, ANode);
  end;
end;

procedure TSCCustomTreeList.InsertColumn(AColumn: TSCTreeColumn);
begin
  Self.InsertColumn(AColumn, FColumns.Count);
end;

procedure TSCCustomTreeList.InsertColumn(AColumn: TSCTreeColumn;
  Index: Integer);
begin
  if (AColumn <> nil) and (Index > -1) and (Index <= FColumns.Count) then
  begin
    if AColumn.FOwner <> nil then
      AColumn.FOwner.RemoveColumn(AColumn);

    DoInsertingColumn(AColumn);

    FColumns.Insert(Index, AColumn);
    AColumn.FOwner := Self;

    ColumnInserted(AColumn);
  end;
end;

function TSCCustomTreeList.Editing: Boolean;
begin
  Result := FEditInShow or (FInplaceEditor <> nil);
end;

procedure TSCCustomTreeList.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  R: TRect;
  IsLeft: Boolean;
  HitInfo: TSCTreeHitInfo;
  ANode, OldClick: TSCTreeNode;
  ACol, OldColumn: TSCTreeColumn;
  AState: TSCTreeCheckButtonState;
  CanSelect, MultiSelect, CanEditNode,
  CanEditCol: Boolean;
begin
  KillClickTimer;
  OldClick := FClickedNode;
  FClickedNode := nil;

  OldColumn := FClickedColumn;
  FClickedColumn := nil;

  FDragPoint := Point(-1, -1);
  MouseDownPoint := Point(X, Y);

  FCtrlFlag := (Button = mbLeft) and (Shift*[ssShift, ssAlt, ssCtrl] = [ssCtrl]);
  FBypassEditing := (Button <> mbLeft) or (Shift*[ssShift, ssAlt, ssCtrl, ssDouble] <> []);

  if not (IsDesigning or CaptureFocus(True)) then
    Exit;

  PostEditor;
  HideHintWindow;

  HitInfo := GetHitInfo(X, Y);

  ACol := nil;
  ANode := nil;

  if HitInfo.Part in SC_NodeHitParts then
  begin
    ANode := HitInfo.Node;
    ACol := HitInfo.Column;
  end;

  if not FBypassEditing then
  begin
    CanEditNode := (ANode = FFocusedNode) or
      ((ANode <> nil) and CanImmediateEditor);

    CanEditCol := (FColumns.Count = 0) or (((ACol = FFocusedColumn) or
      ((ACol <> nil) and CanImmediateEditor)) and
      (not CanRowSelect or CanCellSelect));

    FBypassEditing := not (CanEditNode and CanEditCol);
  end;

  IsLeft := (Button = mbLeft) or (CanRightClickSelect and (Button = mbRight));

  if not IsLeft then
  begin
    HottrackNode(HitInfo);
    CancelDragSize;

    inherited MouseDown(Button, Shift, X, Y);
    Exit;
  end;

  MouseIsDown := True;

  FMouseDownNode := ANode;
  HottrackNode(HitInfo);

  if HitInfo.Part = sctpButton then
  begin
    ANode := HitInfo.Node;

    if ANode <> nil then
    begin
      if ANode.Expanded then
        Collapse(ANode)
      else Expand(ANode);

      MakeNodeVisible(ANode, False);
      UpdateDesigner;
    end;

    inherited MouseDown(Button, Shift, X, Y);
    Exit;
  end;

  if HitInfo.Part = sctpCheckButton then
  begin
    ANode := HitInfo.Node;

    if ANode <> nil then
    begin
      AState := ANode.ButtonState;
      SwitchState(ANode.AllowGrayed, ANode.ButtonType, AState);

      SetFocusedNode(ANode);
      if FColumns.Count > 0 then
        SetFocusedColumn(FirstVisibleColumn);

      SetButtonState(ANode, AState);
      MakeNodeVisible(ANode, False);

      UpdateDesigner;
    end;

    inherited MouseDown(Button, Shift, X, Y);
    Exit;
  end;

  if HitInfo.Part = sctpRowSizer then
  begin
    if ssDouble in Shift then
    begin
      if CanRowAutoHeight then
        SetRowHeight(-1)
      else begin
        ANode := HitInfo.Node;
        if ANode <> nil then
          ANode.Height := -1;
      end;

      UpdateDesigner;
    end else
    if CanRowSizing then
    begin
      FSizingPos := Y;
      FSizingStartPos := Y;
      FPrevSizingPos := -1;
      FSizingNode := HitInfo.Node;

      R := GetNodeRect(HitInfo.Node, False);
      FSizingStartDif := Y - R.Bottom;

      SetState(sctlsRowSizing);
      DrawRowSizingLine;
    end;

    inherited MouseDown(Button, Shift, X, Y);
    Exit;
  end;

  if HitInfo.Part = sctpColumnSizer then
  begin
    if ssDouble in Shift then
    begin
      AutoSizeColumn(HitInfo.Column);
      UpdateDesigner;
    end else
    if CanSizeColumn(HitInfo.Column) then
    begin
      FSizingPos := X;
      FSizingStartPos := X;
      FPrevSizingPos := -1;
      FSizingColumn := HitInfo.Column;

      R := GetColumnRect(HitInfo.Column);
      FSizingStartDif := X - R.Right;

      SetState(sctlsColumnSizing);
      DrawColumnSizingLine;
    end;

    inherited MouseDown(Button, Shift, X, Y);
    Exit;
  end;

  if HitInfo.Part = sctpColumn then
  begin
    SetState(sctlsColumnDown);

    FColumnDown := True;
    FDownColumn := HitInfo.Column;
    FDragPoint  := Point(X, Y);

    UpdateColumn(HitInfo.Column);

    inherited MouseDown(Button, Shift, X, Y);
    Exit;
  end;

  if (HitInfo.Part in SC_DragHitParts) then
  begin
    FDragPoint := Point(X, Y);
    FDragNode  := HitInfo.Node;
  end;

  if ANode = nil then
  begin
    if (HitInfo.Node <> nil) and (HitInfo.Part in [sctpIndicator, sctpFlag]) then
    begin
      FClickedNode := HitInfo.Node;
      FClickedColumn := HitInfo.Column;
      
      KillClickTimer;

      SetFocusedNode(HitInfo.Node);
      if (FColumns.Count > 0) and (FFocusedColumn = nil) then
        SetFocusedColumn(FirstVisibleColumn);

      if (FSelectionList.Count <> 1) or (FSelectionList[0] <> FFocusedNode) then
      begin
        ClearSelection;
        Select(FFocusedNode);
      end;

      MakeNodeVisible(HitInfo.Node, False);
    end;
  end else
  begin
    SetState(sctlsIdle);
    CanSelect := CanRowSelect or (HitInfo.Part in SC_NodeHitParts);

    if not CanSelect then
    begin
      if HitInfo.Part in [sctpIndicator, sctpFlag] then
      begin
        SetState(sctlsNodeDown);
        
        SetFocusedNode(ANode);
        if (FColumns.Count > 0) and (FFocusedColumn = nil) then
          SetFocusedColumn(FirstVisibleColumn);

        MakeNodeVisible(HitInfo.Node, False);
      end;
    end else
    if HitInfo.Part in SC_NodeHitParts then
    begin
      SetState(sctlsNodeDown);
      SetFocusedNode(ANode);

      if (ACol <> nil) then
        SetFocusedColumn(ACol)
      else
      if (FColumns.Count > 0) and (FFocusedColumn = nil) then
        SetFocusedColumn(FirstVisibleColumn);

      if ssDouble in Shift then
      begin
        KillClickTimer;
        FClickedNode := ANode;
        FClickedColumn := ACol;

        if CanDblClickExpand then
        begin
          if ANode.Expanded then
            Collapse(ANode)
          else Expand(ANode);
        end;

        MakeNodeVisible(HitInfo.Node, False);
        UpdateDesigner;

        inherited MouseDown(Button, Shift, X, Y);
        Exit;
      end;

      MultiSelect := CanMultiSelect and (ssCtrl in Shift);

      if not MultiSelect then
      begin
        if not (Editing or Dragging) then
        begin
          FClickedNode := ANode;
          FClickedColumn := ACol;
        end;

        if (FSelectionList.Count <> 1) or (FSelectionList[0] <> FFocusedNode) then
        begin
          ClearSelection;
          Select(FFocusedNode);
        end;
      end else
      begin
        FClickedNode := ANode;
        FClickedColumn := ACol;

        if IsSelected(ANode) then
          Unselect(ANode)
        else
          Select(ANode);
      end;

      MakeNodeVisible(HitInfo.Node, False);
    end;
  end;

  CanEditNode := (FClickedNode <> nil) and (CanImmediateEditor or
    (OldClick = FClickedNode));

  CanEditCol := (FColumns.Count = 0) or ((CanCellSelect or not CanRowSelect) and
    (FClickedColumn <> nil) and (CanImmediateEditor or
    (OldColumn = FClickedColumn)));

  if (HitInfo.Part in SC_NodeHitParts) and
    CanEditNode and CanEditCol then
    InitiateClickTimer;

  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TSCCustomTreeList.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  CR: TRect;
  HitInfo: TSCTreeHitInfo;
  ANode, OldHot: TSCTreeNode;
  ACol, OldCol: TSCTreeColumn;
  CheckHint, PrevDown: Boolean;
  Trashold, XDist, YDist: Integer;
begin
  HitInfo := GetHitInfo(X, Y);

  if (FClickedNode = nil) or ((FColumns.Count > 0) and (FClickedColumn = nil)) then
    KillClickTimer;

  if (FState = sctlsRowSizing) then
  begin
    FSizingPos := Y;
    DrawRowSizingLine;

    inherited MouseMove(Shift, X, Y);
    Exit;
  end;

  if (FState = sctlsColumnSizing) then
  begin
    FSizingPos := X;
    DrawColumnSizingLine;

    inherited MouseMove(Shift, X, Y);
    Exit;
  end;

  if (FState = sctlsStartingDrag) then
  begin
    inherited MouseMove(Shift, X, Y);
    Exit;
  end;

  if (FState = sctlsColumnDragging) then
    DoColumnDragging;

  if (State = sctlsColumnDown) and (FDownColumn <> nil) then
  begin
    if CanDragColumn(FDownColumn) then
    begin
      XDist := Abs(X - FDragPoint.X);
      YDist := Abs(Y - FDragPoint.Y);

      Trashold := Mouse.DragThreshold;

      if (XDist >= Trashold) or (YDist >= Trashold) then
      begin
        FDragPoint  := Point(X, Y);
        FDragColumn := FDownColumn;
        StartDragColumn(FDragColumn);

        inherited MouseMove(Shift, X, Y);
        Exit;
      end;
    end;

    PrevDown := FColumnDown;
    FColumnDown := False;

    if (HitInfo.Part = sctpColumn) and (HitInfo.Column = FDownColumn) then
       FColumnDown := True;

    if FColumnDown <> PrevDown then
      UpdateColumn(FDownColumn);
  end;

  if (FState = sctlsNodeDown) and not ((ssLeft in Shift) or
    (CanRightClickSelect and (ssRight in Shift))) then
    SetState(sctlsIdle);

  if not (Editing or MouseIsDown) then
  begin
    OldHot  := FHotNode;
    OldCol  := FHotColumn;

    CheckHint := False;

    if not (Editing or Dragging or DragScrolling or IsDesigning) then
    begin
      HottrackNode(HitInfo);

      if not (Dragging or DragScrolling) then
      begin
        CheckHint := OldHot <> FHotNode;

        if not CheckHint and (FColumns.Count > 0) and
          (CanCellSelect or not CanRowSelect) then
          CheckHint := (OldCol <> FHotColumn);

        if not CheckHint then
        begin
          ANode := HitInfo.Node;
          ACol := HitInfo.Column;

          if HitInfo.Part <> sctpLabel then
          begin
            ACol := nil;
            ANode := nil;
          end;

          CheckHint := ANode <> FHintNode;

          if not CheckHint and (FColumns.Count > 0) and
            (CanCellSelect or not CanRowSelect) then
            CheckHint := ACol <> FHintColumn;
        end;
      end;

      if CheckHint then
        ShowHintWindow(Point(X, Y));
    end;
  end;

  if FState = sctlsNodeDown then
  begin
    Trashold := Mouse.DragThreshold;

    if (DragMode = dmAutomatic) then
    begin
      XDist := Abs(X - FDragPoint.X);
      YDist := Abs(Y - FDragPoint.Y);

      if (XDist >= Trashold) or (YDist >= Trashold) then
      begin
        ANode := FDragNode;
        if ANode = nil then ANode := HitInfo.Node;

        ACol := nil;
        if FColumns.Count > 0 then
        begin
          ACol := FFocusedColumn;
          if ACol = nil then ACol := HitInfo.Column;
        end;

        if ANode <> nil then
        begin
          if ANode <> FocusedNode then
          begin
            if not FCtrlFlag then
              ClearSelection;

            SetFocusedNode(ANode);
            if (ACol <> nil) and (FFocusedColumn = nil) then
              SetFocusedColumn(ACol);
          end;

          HitInfo.Node := nil;
          HitInfo.Part := sctpNowhere;

          HottrackNode(HitInfo);

          SetFocusedNode(ANode);
          if (ACol <> nil) and (FFocusedColumn = nil) then
            SetFocusedColumn(ACol);

          FCtrlFlag := False;
          BeginDrag(False);
        end;
      end;
    end else
    if CanMouseScroll and (FList.Count > 0) then
    begin
      CR := GetNodesRect;

      if (Y < CR.Top) or (Y > CR.Bottom) then
      begin
        if not DragScrolling then
          StartDragScrolling;
      end else
      begin
        StopDragScrolling;

        if HitInfo.Node <> nil then
        begin
          ACol := nil;
          if FColumns.Count > 0 then
          begin
            ACol := FFocusedColumn;
            if ACol = nil then ACol := HitInfo.Column;
          end;

          SetFocusedNode(HitInfo.Node);
          if (ACol <> nil) and (FFocusedColumn = nil) then
            SetFocusedColumn(ACol);

          if CanMultiSelect and ((FSelectionList.Count <> 1) or
            (FSelectionList[0] <> FFocusedNode)) then
          begin
            ClearSelection;
            if FFocusedNode <> nil then
              Select(FocusedNode);
          end;
        end;
      end;
    end;
  end;

  inherited MouseMove(Shift, X, Y);
end;

procedure TSCCustomTreeList.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  P: TPoint;
  HitInfo: TSCTreeHitInfo;
  OldDown: TSCTreeColumn;
  SortDir: TSCTreeSortDirection;
begin
  P := FDragPoint;
  FDragPoint := Point(-1, -1);
  HitInfo := GetHitInfo(X, Y);

  if FState = sctlsRowSizing then
  begin
    FSizingPos := Y;
    EndRowSizing;
  end;
  
  if FState = sctlsColumnSizing then
  begin
    FSizingPos := X;
    EndColumnSizing;
  end;

  if FState = sctlsColumnDown then
  begin
    OldDown := FDownColumn;
    
    FDownColumn := nil;
    FColumnDown := False;
    
    CancelDragSize;
    UpdateColumn(OldDown);

    if (OldDown <> nil) and (HitInfo.Part = sctpColumn) and
      (HitInfo.Column = OldDown) then
    begin
      if not OldDown.DisableSorting then
      begin
        SortDir := ToggleSort(OldDown.SortDirection);
        if ssCtrl in Shift then SortDir := sctsdNone;

        OldDown.SortDirection := SortDir;
      end;

      DoColumnClick(OldDown);
      UpdateDesigner;
    end;
  end;

  if (State = sctlsColumnDragging) then
    EndColumnDragging;

  StopDragScrolling;
  HideHintWindow;

  FMouseDownNode := nil;
  HottrackNode(HitInfo);

  if FState = sctlsNodeDown then
    SetState(sctlsIdle);

  StopDragScrolling;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomTreeList.Move(CurIndex, NewIndex: Integer);
begin
  if CurIndex <> NewIndex then
  begin
    FList.Move(CurIndex, NewIndex);
    ChildMoved(nil, CurIndex, NewIndex);
  end;
end;

procedure TSCCustomTreeList.MoveColumn(CurIndex, NewIndex: Integer);
begin
  if CurIndex <> NewIndex then
  begin
    FColumns.Move(CurIndex, NewIndex);
    ColumnMoved(CurIndex, NewIndex);
  end;
end;

procedure TSCCustomTreeList.ChildChanged(ANode: TSCTreeNode);
begin
  if ANode <> nil then
    UpdateNode(ANode, False, sctupNode)
  else Invalidate;
end;

procedure TSCCustomTreeList.ChildExchanged(AParent: TSCTreeNode;
  Index1, Index2: Integer);
var
  Redraw: Boolean;
begin
  if not InUpdate then
  begin
    if Parent = nil then
      Redraw := IsNodeVisible(TSCTreeNode(FList[Index1]), True) or
        IsNodeVisible(TSCTreeNode(FList[Index2]), True)
    else
      Redraw := IsNodeVisible(AParent.Items[Index1], True) or
        IsNodeVisible(AParent.Items[Index2], True);

    if Redraw then
      Invalidate;
  end;
end;

procedure TSCCustomTreeList.ChildHeightChanged(ANode: TSCTreeNode);
var
  ATopNode: TSCTreeNode;
  OldIndex, AIndex: Integer;
begin
  if (ANode <> nil) and not ANode.FDestroying and
    not (IsLoading or IsDestroying) and
    not (InUpdate or CanRowAutoHeight) and ParentExpanded(ANode) then
  begin
    ATopNode := GetTopVisibleNode;
    if ATopNode <> nil then
    begin
      AIndex := GetAbsoluteIndex(ATopNode, True);
      OldIndex := AIndex;

      VerifyTopIndex(AIndex);
      
      if OldIndex <> AIndex then
      begin
        ATopNode := GetAbsoluteNode(AIndex, True);
        SetTopVisibleNode(ATopNode);
      end;
    end;

    if IsNodeVisible(ANode, True) then
    begin
      Invalidate;
      UpdateHintWindow;
    end;

    UpdateScrollbars(False, True);
  end;
end;

procedure TSCCustomTreeList.ChildInserted(AParent: TSCTreeNode;
  ANode: TSCTreeNode);
begin
  if (ANode <> nil) and not (IsLoading or IsDestroying) then
  begin
    if not InUpdate then
    begin
      ArrangeNodeList;
      CalculateRowWidth;

      if CanAutoSort then
      begin
        SortNode(ANode, True);
        if AParent = nil then
          Self.SortNodes(False)
        else SortNode(AParent, False);
      end;

      NodesChanged;
    end else
    if CanAutoSort then
      Inc(FSortNeeded);
  end;
end;

procedure TSCCustomTreeList.ChildMoved(AParent: TSCTreeNode;
  OldIndex, NewIndex: Integer);
var
  Redraw: Boolean;
begin
  if not InUpdate then
  begin
    if Parent = nil then
      Redraw := IsNodeVisible(TSCTreeNode(FList[OldIndex]), True) or
        IsNodeVisible(TSCTreeNode(FList[NewIndex]), True)
    else
      Redraw := IsNodeVisible(AParent.Items[OldIndex], True) or
        IsNodeVisible(AParent.Items[NewIndex], True);

    if Redraw then
      Invalidate;
  end;
end;

procedure TSCCustomTreeList.ChildRemoved(AParent: TSCTreeNode;
  ANode: TSCTreeNode);
var
  AIndex: Integer;
begin
  if ANode <> nil then
  begin
    if ANode = FFocusedNode then
    begin
      FFocusedNode := nil;
      KillClickTimer;
    end;

    if ANode = FClickedNode then
    begin
      FClickedNode := nil;
      KillClickTimer;
    end;

    if ANode = FTopVisibleNode then
      FTopVisibleNode := nil;

    if ANode = FHotNode then
    begin
      FHotNode := nil;
      FHotColumn := nil;
      FHotPart := sctpNowhere;

      KillHintTimer;
    end;

    if ANode = FMouseDownNode then
      FMouseDownNode := nil;

    if ANode = FHintNode then
    begin
      FHintNode := nil;
      KillHintTimer;
    end;

    if ANode = FFlashNode then
      ResetFlash;

    AIndex := FSelectionList.IndexOf(ANode);
    if AIndex > -1 then
      FSelectionList.Delete(AIndex);

    if not InUpdate and not (IsLoading or IsDestroying) and
      ((AParent = nil) or (AParent.Expanded and ParentExpanded(AParent))) then
    begin
      ArrangeNodeList;
      CalculateRowWidth;

      NodesChanged;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomTreeList.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFlagImages) then
    FlagImages := nil;
  if (Operation = opRemove) and (AComponent = FStateImages) then
    StateImages := nil;
end;

procedure TSCCustomTreeList.Paint;
begin
  HideDragImages;
  try
    DoPaintBack(Self.Canvas);
    DrawPicture(Self.Canvas);

    if FList.Count > 0 then
      DrawNodes(Self.Canvas);

    DrawHeader(Self.Canvas);

    FPrevSizingPos := -1;
    DrawRowSizingLine;
  finally
    ShowDragImages;
  end;
end;

function TSCCustomTreeList.Remove(ANode: TSCTreeNode): Integer;
begin
  Result := -1;
  if (ANode <> nil) and (ANode.FOwner = Self) and
    (ANode.FParent = nil) and ANode.RootNode then
  begin
    Result := FList.IndexOf(ANode);
    if Result > -1 then
      RemoveChild(ANode);
  end;
end;

procedure TSCCustomTreeList.RemoveChild(ANode: TSCTreeNode);
var
  AIndex: Integer;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    (ANode.FParent = nil) and ANode.RootNode then
  begin
    RemovingChild(nil, ANode);

    ANode.ResetNode(True);
    ANode.SetOwner(nil);

    AIndex := FList.IndexOf(ANode);

    if AIndex > -1 then
    begin
      FList.Delete(AIndex);

      ANode.FOwner := nil;
      ANode.FParent := nil;

      ChildRemoved(nil, ANode);
    end;  
  end;
end;

procedure TSCCustomTreeList.RemoveColumn(AColumn: TSCTreeColumn);
var
  AIndex: Integer;
begin
  if (AColumn <> nil) and (AColumn.FOwner = Self) then
  begin
    ColumnRemoving(AColumn);
    AIndex := FColumns.IndexOf(AColumn);

    if AIndex > -1 then
    begin
      FColumns.Delete(AIndex);
      AColumn.FOwner := nil;

      ColumnRemoved(AColumn);
    end;  
  end;
end;

procedure TSCCustomTreeList.SetRowHeight(Value: Integer);
var
  AMin: Integer;
begin
  if Value < -1 then Value := -1;

  if Value > -1 then
  begin
    AMin := GetMinNodeHeight;
    if Value < AMin then Value := AMin;
  end;

  if FRowHeight <> Value then
  begin
    FRowHeight := Value;

    if FList.Count > 0 then
    begin
      Invalidate;
      UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomTreeList.SetFocusedNode(Value: TSCTreeNode);
var
  OldNode: TSCTreeNode;
begin
  if (Value <> FFocusedNode) and CanFocusNode(Value) then
  begin
    OldNode := FFocusedNode;
    FocusedNodeChanging;
    try
      FFocusedNode := Value;
      if not CanMultiSelect then
        ClearSelection;

      UpdateNode(OldNode, False, sctupNode);
      UpdateNode(FFocusedNode, False, sctupNode);
    finally
      FocusedNodeChanged;
    end;
  end;
end;

procedure TSCCustomTreeList.SetOptionsView(Value: TSCTreeViewOptions);
begin
  if FOptionsView <> Value then
  begin
    FOptionsView := Value;

    if CanTrackMouse then
      UpdateHottrack;

    if not IsShowNodeHints then
      HideHintWindow;

    if HasAnyColumn or HasAnyNode then
    begin
      CalculateRowWidth;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomTreeList.SetStateImages(Value: TCustomImageList);
var
  OldImages: TCustomImageList;
begin
  OldImages := FStateImages;
  
  if FStateImages <> nil then
  begin
  {$IFDEF SC_DELPHI5_UP}
    FStateImages.RemoveFreeNotification(Self);
  {$ENDIF}
    FStateImages.UnRegisterChanges(FStateChangeLink);
  end;

  FStateImages := Value;
  if FStateImages <> nil then
  begin
    FStateImages.RegisterChanges(FStateChangeLink);
    FStateImages.FreeNotification(Self);
  end;

  if OldImages <> FStateImages then
  begin
    Invalidate;
    StateImageListChange(FStateImages);
  end;
end;

procedure TSCCustomTreeList.SetTopVisibleNode(ANode: TSCTreeNode);
var
  AIndex, LastIndex: Integer;
  OldNode, AParent, LastNode: TSCTreeNode;
begin
  if ((ANode = nil) or (ANode.FOwner = Self)) and (FTopVisibleNode <> ANode) then
  begin
    if not HasAnyNode then
    begin
      FTopVisibleNode := nil;
      UpdateScrollbars(True, True);
      
      Exit;
    end;

    OldNode := GetTopVisibleNode;
    FTopVisibleNode := ANode;

    if (ANode = nil) then
      FTopVisibleNode := FRealList[0];

    if FTopVisibleNode <> nil then
    begin
      AParent := FTopVisibleNode.Parent;

      while AParent <> nil do
      begin
        Expand(AParent);
        AParent := AParent.Parent;
      end;
    end;

    if (ANode.Parent <> nil) and not ParentExpanded(ANode) then
      FTopVisibleNode := OldNode;

    if (FTopVisibleNode <> nil) then
    begin
      AIndex := GetAbsoluteIndex(FTopVisibleNode, True);

      if (AIndex = -1) then
        FTopVisibleNode := FRealList[0]
      else begin
        LastNode := GetLastTopVisibleNode;

        if LastNode = nil then
          FTopVisibleNode := FRealList[0]
        else begin
          LastIndex := GetAbsoluteIndex(LastNode, True);
          if AIndex > LastIndex then
            FTopVisibleNode := LastNode;
        end;
      end;
    end;

    if (FTopVisibleNode = nil) then
      FTopVisibleNode := FRealList[0];

    UpdateScrollbars(True, True);

    if FTopVisibleNode <> nil then
      UpdateNode(FTopVisibleNode, True, sctupBelow)
    else Invalidate;
  end;
end;

procedure TSCCustomTreeList.ArrangeNodeList;

  procedure AppendNode(ANode: TSCTreeNode; AList: TList);
  var
    Index: Integer;
    PNode: PSCNodeInfo;
  begin
    New(PNode);
    Index := AList.Add(PNode);

    PNode^.Node := ANode;
    PNode^.Index := Index;
  end;

var
  AList: TList;
  PNode: PSCNodeInfo;
  Child: TSCTreeNode;
  I, OldCount: Integer;
begin
  if (FInRowCalculation = 0) and
    not (InUpdate or IsDestroying or IsLoading) then
  begin
    Inc(FInRowCalculation);
    try
      OldCount := FNodeList.Count;

      AList := TList.Create;
      try
        AList.Capacity := FList.Count;

        for I := 0 to FList.Count-1 do
        begin
          Child := TSCTreeNode(FList[I]);
          AppendNode(Child, AList);

          if Child.Expanded and (Child.Count > 0) then
            Self.ArrangeNodeList(Child, AList);
        end;

        FRealList.Clear;
        FRealList.Capacity := AList.Count;

        for I := 0 to AList.Count - 1 do
        begin
          PNode := PSCNodeInfo(AList[I]);
          FRealList.Add(Pointer(PNode^.Node));
        end;

        AList.Sort(CompareItems);

        FIndexList.Clear;
        FIndexList.Capacity := AList.Count;

        FNodeList.Clear;
        FNodeList.Capacity := AList.Count;

        for I := 0 to AList.Count - 1 do
        begin
          PNode := PSCNodeInfo(AList[I]);

          FNodeList.Add(Pointer(PNode^.Node));
          FIndexList.Add(Pointer(PNode^.Index));

          Dispose(PNode);
        end;
      finally
        AList.Free;
        if OldCount <> FNodeList.Count then
          UpdateScrollbars(True, True);
      end;
    finally
      Dec(FInRowCalculation);
    end;
  end;
end;

procedure TSCCustomTreeList.UpdateScrollbars(Horizontal,
  Vertical: Boolean);
var
  OldHorizontal, NewVertical, NewHorizontal: Boolean;
begin
  HideDragImages;
  try
    OldHorizontal := TSCTreeScrollbar(ScrollbarHorz).Visible;

    if Vertical then UpdateVertScrollBar;
    if Horizontal then UpdateHorzScrollBar;

    NewVertical := TSCTreeScrollbar(ScrollbarVert).Visible;
    NewHorizontal := TSCTreeScrollbar(ScrollbarHorz).Visible;

    if NewVertical and (OldHorizontal <> NewHorizontal) then
      UpdateVertScrollBar;

    UpdateHottrack;
  finally
    ShowDragImages;
  end;
end;

procedure TSCCustomTreeList.UpdateUnlocked;
var
  OldIndex, AIndex: Integer;
begin
  if FNeedsArrangement then
    ArrangeNodeList;

  CalculateRowWidth;

  if FSortNeeded > 0 then
  begin
    FSortNeeded := 0;
    Self.SortNodes(True);
  end;

  if FTopVisibleNode <> nil then
  begin
    AIndex := GetAbsoluteIndex(FTopVisibleNode, True);
    if AIndex = -1 then
      FTopVisibleNode := nil
    else begin
      OldIndex := AIndex;
      VerifyTopIndex(AIndex);

      if OldIndex <> AIndex then
        FTopVisibleNode := GetAbsoluteNode(AIndex, True);
    end;
  end;

  NodesChanged;
  UpdateScrollbars(True, True);

  Invalidate;
end;

procedure TSCCustomTreeList.ColorsChanged;
begin
  if (FList <> nil) and (FList.Count > 0) then
    Invalidate;
end;

procedure TSCCustomTreeList.SetColors(Value: TSCTreeColors);
begin
  FColors.Assign(Value);
end;

procedure TSCCustomTreeList.ButtonChanged;
begin
  if (FList <> nil) and (FList.Count > 0) then
    Invalidate;
end;

procedure TSCCustomTreeList.SetButtons(Value: TSCTreeButton);
begin
  FButtons.Assign(Value);
end;

function TSCCustomTreeList.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCTreeBorderProps;
end;

function TSCCustomTreeList.GetPicturePropsClass: TSCCustomPicturePropsClass;
begin
  Result := TSCPictureProps;
end;

function TSCCustomTreeList.GetNodeHeight(ANode: TSCTreeNode): Integer;
var
  Ph, AMin: Integer;
begin
  Result := 0;
  if (ANode <> nil) and (ANode.Owner = Self) then
  begin
    Result := ANode.Height;

    if (Result < 0) or CanRowAutoHeight then
    begin
      Result := GetNodeHeight;

      if IsShowPreview then
      begin
        Ph := GetPreviewHeight;
        if Ph < 0 then Ph := 0;

        Ph := GetPreviewHeight(ANode) - Ph;
        Inc(Result, Ph);
      end;
    end;

    if Images <> nil then
    begin
      if Result < Images.Height then
        Result := Images.Height;

      if (FStateImages <> nil) and (Result < FStateImages.Height) then
        Result := FStateImages.Height;
    end;

    if (FFlagImages <> nil) and (Result < FFlagImages.Height) then
      Result := FFlagImages.Height;

    if Result < 0 then Result := 0;

    AMin := GetMinNodeHeight(ANode);
    if Result < AMin then
      Result := AMin;
  end;
end;

function TSCCustomTreeList.GetColumn(Index: Integer): TSCTreeColumn;
begin
  Result := TSCTreeColumn(FColumns[Index]);
end;

function TSCCustomTreeList.GetColumnCount: Integer;
begin
  Result := FColumns.Count;
end;

function TSCCustomTreeList.GetControlScrollbarsClass: TSCControlCustomScrollbarsClass;
begin
  Result := TSCTreeScrollbars;
end;

function TSCCustomTreeList.GetScrollbarClass: TSCCustomControlScrollbarClass;
begin
  Result := TSCTreeScrollbar;
end;

procedure TSCCustomTreeList.ArrangeNodeList(ANode: TSCTreeNode; AList: TList);

  procedure AppendNode(ANode: TSCTreeNode);
  var
    Index: Integer;
    PNode: PSCNodeInfo;
  begin
    New(PNode);
    Index := AList.Add(PNode);

    PNode^.Node := ANode;
    PNode^.Index := Index;
  end;

var
  I: Integer;
  Child: TSCTreeNode;
begin
  for I := 0 to ANode.Count-1 do
  begin
    Child := TSCTreeNode(ANode.FList[I]);
    AppendNode(Child);

    if Child.Expanded and (Child.Count > 0) then
      Self.ArrangeNodeList(Child, AList);
  end;
end;

procedure TSCCustomTreeList.Loaded;
begin
  inherited Loaded;
  
  ArrangeNodeList;
  CalculateRowWidth;
  NodesChanged;

  UpdateScrollbars(True, True);
end;

procedure TSCCustomTreeList.CalculateRowWidth(ANode: TSCTreeNode);
var
  S: String;
  Child: TSCTreeNode;
  I, AWidth, AImage: Integer;
begin
  S := ANode.Text;
  AWidth := Canvas.TextWidth(S) + SC_TreeNodeHorzSpacing;

  Inc(AWidth, GetLevelIndent*GetNodeLevel(ANode));

  if IsShowCheckButtons and (ANode.ButtonType <> sctcbNone) then
    Inc(AWidth, SC_TreeCheckButtonSize);

  if Images <> nil then
  begin
    Inc(AWidth, Images.Width);

    if IsShowStateImages and (FStateImages <> nil) then
    begin
      AImage := ANode.StateIndex;
      if (AImage > -1) and (AImage < FStateImages.Count) then
        Inc(AWidth, FStateImages.Width);
    end;
  end;

  if AWidth > FRowWidth then
    FRowWidth := AWidth;

  if ANode.Expanded and (ANode.Count > 0) then
    for I := 0 to ANode.Count-1 do
    begin
      Child := TSCTreeNode(ANode.FList[I]);
      Self.CalculateRowWidth(Child);
    end;
end;

procedure TSCCustomTreeList.CalculateRowWidth;
var
  Child: TSCTreeNode;
  ACol: TSCTreeColumn;
  I, OldWidth: Integer;
begin
  if (FInRowCalculation = 0) and
    not (InUpdate or IsDestroying or IsLoading) then
  begin
    Inc(FInRowCalculation);
    try
      OldWidth := FRowWidth;
      FRowWidth := 0;

      try
        Canvas.Font.Assign(Self.Font);

        if FColumns.Count = 0 then
        begin
          for I := 0 to FList.Count-1 do
          begin
            Child := TSCTreeNode(FList[I]);
            Self.CalculateRowWidth(Child);
          end;
        end else
        begin
          for I := 0 to FColumns.Count-1 do
          begin
            ACol := TSCTreeColumn(FColumns[I]);
            if ACol.Visible and (ACol.Width > 0) then
              Inc(FRowWidth, GetColumnWidth(ACol));
          end;
        end;

        if IsShowIndicator then
          Inc(FRowWidth, FIndicator);

        Inc(FRowWidth, Self.Indent);

        if IsShowFlagImages and (FFlagImages <> nil) then
          Inc(FRowWidth, FFlagImages.Width);
      finally
        if OldWidth <> FRowWidth then
          UpdateScrollbars(True, False);
      end;

      UpdateHintWindow;
    finally
      Dec(FInRowCalculation);
    end;
  end;
end;

procedure TSCCustomTreeList.ChildTextChanged(ANode: TSCTreeNode);
var
  AParent: TSCTreeNode;
begin
  if ANode = FHintOldNode then
    FHintOldNode := nil;

  if (ANode <> nil) and not ANode.FDestroying and
    not InUpdate and not (IsLoading or IsDestroying) then
  begin
    if CanAutoSort then
    begin
      AParent := ANode.Parent;

      if AParent <> nil then
        SortNode(AParent, False)
      else SortNodes(False);
    end;

    if ParentExpanded(ANode) then
    begin
      CalculateRowWidth;
      NodesChanged;

      if CanAutoSort then
      begin
        Invalidate;
        
        if FHintNode = ANode then
        begin
          FHintOldNode := nil;
          FHintOldColumn := nil;
        end;

        UpdateHintWindow;
      end else
      if IsNodeVisible(ANode, True) then
      begin
        UpdateNode(ANode, False, sctupNode);

        if FHintNode = ANode then
        begin
          FHintOldNode := nil;
          FHintOldColumn := nil;
        end;

        UpdateHintWindow;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.CreateWnd;
begin
  inherited CreateWnd;
  UpdateScrollbars(True, True);
end;

procedure TSCCustomTreeList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    Style := Style or WS_TABSTOP or WS_CLIPCHILDREN;
    WindowClass.Style := CS_DBLCLKS or CS_VREDRAW or CS_HREDRAW or CS_SAVEBITS;
    Style := Style and not WS_BORDER or WS_CLIPSIBLINGS or
      WS_CLIPCHILDREN;
  end;
end;

procedure TSCCustomTreeList.DragCanceled;
var
  P: TPoint;
  Message: TWMMouse;
begin
  with Message do
  begin
    Msg := WM_LBUTTONDOWN;
    GetCursorPos(P);
    Pos := PointToSmallPoint(Self.ScreenToClient(P));
    Keys := 0;
    Result := 0;
  end;
  
  DefaultHandler(Message);
  Message.Msg := WM_LBUTTONUP;
  DefaultHandler(Message);
end;

procedure TSCCustomTreeList.WndProc(var Message: TMessage);
var
  P: TPoint;
  ANode: TSCTreeNode;
  DoInherit: Boolean;
  CState: TControlState;
begin
  if (Message.Msg = WM_MOUSEMOVE) and (FState = sctlsColumnDragging) then
  begin
    DoColumnDragging;
    Exit;
  end;

  if not Dragging and (DragMode = dmAutomatic) and
    not (IsDesigning or IsLocked) and ((Message.Msg = WM_LBUTTONDOWN) or
    (Message.Msg = WM_LBUTTONDBLCLK)) then
  begin
    CState := Self.ControlState;
    Include(CState, csLButtonDown);

    Self.ControlState := CState;

    Dispatch(Message);
    Exit;
  end;

  DoInherit := True;

  if (DragMode = dmAutomatic) and not IsDesigning then
  begin
    if Dragging and (Message.Msg = WM_KEYDOWN) and
      (Message.wParam = VK_ESCAPE) then
      EndDrag(False);

    if (Message.Msg = WM_KEYDOWN) and
       (Message.wParam in [VK_ADD, VK_SUBTRACT]) then
    begin
      GetCursorPos(P);
      P := Self.ScreenToClient(P);

      ANode := GetNodeAt(P.X, P.Y);
      if (ANode <> nil) and (ANode.Count > 0) then
        if (Message.wParam = VK_ADD) then
           Expand(ANode)
        else
        if (Message.wParam = VK_SUBTRACT) then
          Collapse(ANode);
    end;

    if not Dragging and ((Message.Msg = WM_LBUTTONDOWN) or
      (Message.Msg = WM_LBUTTONDBLCLK) or (CanRightClickSelect and
      (Message.Msg = WM_RBUTTONDOWN) or (Message.Msg = WM_RBUTTONDBLCLK))) and
      not IsControlMouseMsg(TWMMouse(Message)) then
    begin
      DoInherit := False;
      HideHintWindow;

      if not Self.HasFocus then
        CaptureFocus(True);

      ControlState := ControlState + [csLButtonDown];
      Dispatch(Message);
    end;
  end;

  if DoInherit then
    inherited WndProc(Message);
end;

procedure TSCCustomTreeList.HideHintWindow;
begin
  KillHintTimer;

  if FHintWnd <> nil then
  begin
    FHintNode := nil;
    FHintText := '';

    FHintWnd.WindowProc := FHintOldWndProc;

    FHintWnd.ReleaseHandle;
    FHintWnd := nil;
  end;
end;

procedure TSCCustomTreeList.HottrackChanged;
begin
  if IsHottrack and (FHotNode <> nil) and not (Editing or Dragging) then
    UpdateNode(FHotNode, False, sctupNode);
end;

procedure TSCCustomTreeList.ShowHintWindow(P: TPoint;
  CheckHintSize: Boolean);
var
  AHeight: Integer;
  ACell: TSCTreeCell;
  HitInfo: TSCTreeHitInfo;
  CellR, R, CR, HintR: TRect;
  AllowShow, InClient: Boolean;
begin
  if IsHintLocked or Dragging or IsDesigning or
    MouseIsDown or not (HandleAllocated and IsShowNodeHints and
    Self.Visible and IsWindowVisible(Self.Handle)) then
    Exit;

  AllowShow := False;
  try
    KillHintTimer;

    if (Editing or EditInShow) then
    begin
      HideHintWindow;
      Exit;
    end;

    CR := GetNodesRect;
    if IsRectEmpty(CR) then
      Exit;

    HitInfo := GetHitInfo(P.x, P.y);

    FHintNode := nil;
    FHintColumn := nil;

    if HitInfo.Part = sctpLabel then
    begin
      FHintNode := HitInfo.Node;
      FHintColumn := HitInfo.Column;
    end;

    if (FHintOldNode = FHintNode) and
      (FHintOldColumn = FHintColumn) then
    begin
      FHintNode := nil;
      FHintColumn := nil;
    end;

    if (FHintNode <> nil) and ((FColumns.Count = 0) or (FHintColumn <> nil)) then
    begin
      FHintText := FHintNode.Text;
      if FHintColumn <> nil then
        FHintText := FHintNode.GetString(FColumns.IndexOf(FHintColumn));

      FHintOldNode := FHintNode;
      FHintOldColumn := FHintColumn;

      if FHintText <> '' then
      begin
        ACell := AsCell(FHintNode, FHintColumn);

        if FColumns.Count > 0 then
          R := GetCellRect(ACell, True)
        else R := GetNodeRect(FHintNode, True);

        if R.Right < CR.Left then
          Exit;

        if IsRectEmpty(R) then
          Exit;

        InClient := (R.Left >= CR.Left) and (R.Right <= CR.Right);

        if InClient and (FColumns.Count > 0) then
        begin
          CellR := GetCellRect(ACell, False);
          InflateRect(CellR, -2, 0);

          InClient := (R.Right - R.Left) <= (CellR.Right - CellR.Left);
        end;

        if CheckHintSize and not InClient then
        begin
          InflateRect(R, 1, 0);
          AHeight := R.Bottom - R.Top;

          if R.Left < CR.Left then
            OffsetRect(R, CR.Left - R.Left, 0);

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
            Canvas.Font.Assign(Self.Font);
          end;

          InitiateHintTimer;

          HintR := FHintWnd.CalcHintRect(Screen.Width, FHintText, nil);
          OffsetRect(HintR, -HintR.Left, -HintR.Top);

          if AHeight < HintR.Bottom then
            AHeight := HintR.Bottom;

          OffsetRect(R, 0, -2);

          R.TopLeft := Self.ClientToScreen(R.TopLeft);
          R.Right   := R.Left + HintR.Right;
          R.Bottom  := R.Top + AHeight;

          if Assigned(FOnShowItemHint) then
          begin
            FOnShowItemHint(Self, ACell, R, FHintText, AllowShow);

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

          GetWindowRect(FHintWnd.Handle, HintR);

          if not IsWindowVisible(FHintWnd.Handle) or
            not ((R.Left = HintR.Left) and (R.Top = HintR.Top)) then
          begin
            Dec(R.Bottom, 4);
            OffsetRect(R, 0, 2);

            FHintWnd.ActivateHint(R, FHintText);
          end;
        end;
      end;
    end;
  finally
    if not AllowShow then
      HideHintWindow;
  end;
end;

procedure TSCCustomTreeList.DoPaintBack(ACanvas: TCanvas);
var
  R: TRect;
begin
  if ACanvas <> nil then
  begin
    if Transparent then
      PaintParentOn(ACanvas)
    else begin
      R := GetClientRect;

      if not IsRectEmpty(R) then
        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := GetFaceColor;

          FillRect(R);
        end;
    end;

    if Self.HasPicture then
      DrawPicture(ACanvas);
  end;
end;

procedure TSCCustomTreeList.WMDestroy(var Message: TWMDestroy);
begin
  HideHintWindow;
  KillAllTimers;
  inherited;
end;

procedure TSCCustomTreeList.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TSCCustomTreeList.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
  if CanGoToNextCellOnTab then
    Message.Result := Message.Result or DLGC_WANTTAB;
  if FState <> sctlsIdle then
    Message.Result := Message.Result or DLGC_WANTCHARS;
end;

procedure TSCCustomTreeList.WMHScroll(var Message: TWMHScroll);
var
  SI: TScrollInfo;
begin
  if not (IsDesigning or Editing) then
  begin
    HideHintWindow;

    SI.cbSize := SizeOf(SI);
    SI.fMask  := SIF_ALL;

    GetScrollInfo(Self.Handle, SB_HORZ, SI);

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

procedure TSCCustomTreeList.WMLButtonDown(var Message: TWMLButtonDown);
begin
  KillClickTimer;
  inherited;
end;

procedure TSCCustomTreeList.WMMouseWheel(var Message: TWMMouseWheel);
var
  ANode, OldNode: TSCTreeNode;
  Dif, OldIndex, NewIndex: Integer;
begin
  if not IsDesigning and HasAnyNode and
    CanMouseScroll and not Editing then
  begin
    HideHintWindow;

    NewIndex := -MaxInt;
    OldIndex := GetTopVisibleIndex;

    if Message.WheelDelta < 0 then
    begin
      NewIndex := OldIndex + 3;
      VerifyTopIndex(NewIndex);
    end else
    if Message.WheelDelta > 0 then
    begin
      NewIndex := OldIndex - 3;
      VerifyTopIndex(NewIndex);
    end;

    if NewIndex <> -MaxInt then
    begin
      Dif := NewIndex - OldIndex;

      if Dif > 0 then
      begin
        ANode := GetTopVisibleNode;

        repeat
          OldNode := ANode;
          ANode := ANode.GetNextVisible;
          Dec(Dif);
        until (ANode = nil) or (Dif = 0);

        if ANode = nil then
          ANode := OldNode;

        SetTopVisibleNode(ANode);
      end else
      if Dif < 0 then
      begin
        ANode := GetTopVisibleNode;

        repeat
          OldNode := ANode;
          ANode := ANode.GetPrevVisible;
          Inc(Dif);
        until (ANode = nil) or (Dif = 0);

        if ANode = nil then
          ANode := OldNode;

        SetTopVisibleNode(ANode);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.WMSize(var Message: TWMSize);
begin
  inherited;

  CalculateRowWidth;
  UpdateScrollbars(True, True);

  SizeEditor;
  HideHintWindow;

  UpdateHintWindow;
end;

procedure TSCCustomTreeList.WMTimer(var Message: TWMTimer);
var
  P: TPoint;
  InScroll: Boolean;
  ANode: TSCTreeNode;
  HitInfo: TSCTreeHitInfo;
begin
  inherited;

  if not HandleAllocated then
    Exit;

  if (Message.TimerID = SC_TreeHintTimerID) then
  begin
    KillHintTimer;
    HideHintWindow;
  end else
  if (Message.TimerID = SC_TreeFlashTimerID) then
  begin
    KillFlashTimer;
    InitiateFlashTimer;
  end else
  if (Message.TimerID = SC_TreeClickTimerID) then
  begin
    KillClickTimer;
    if not Editing and (FState = sctlsIdle) and CanAllowEditing then
      ShowEditor;
  end else
  if (Message.TimerID = SC_TreeDragExpandTimerID) then
  begin
    KillDragExpandTimer;

    GetCursorPos(P);
    P := Self.ScreenToClient(P);

    HitInfo := GetHitInfo(P.x, P.y);
    if HitInfo.Part in SC_DragExpandHitParts then
    begin
      ANode := HitInfo.Node;

      if (ANode <> nil) and (ANode.Count > 0) and
        (ANode = FDragExpandNode) then
      begin
        if CanDragCollapse then
        begin
          if ANode.Expanded then
            Collapse(ANode)
          else
            Expand(ANode);

          InitiateDragExpandTimer;
        end else
          Expand(ANode);
      end;
    end;
  end else
  if (Message.TimerID = SC_TreeDragScrollTimerID) then
  begin
    InScroll := DragScrolling;

    StopDragScrolling;
    if InScroll then StartDragScrolling;
  end;
end;

procedure TSCCustomTreeList.WMVScroll(var Message: TWMVScroll);
var
  SI: TScrollInfo;
  ANode: TSCTreeNode;
  OldIndex, NewIndex: Integer;
begin
  if not (IsDesigning or Editing) then
  begin
    HideHintWindow;

    SI.cbSize := SizeOf(SI);
    SI.fMask := SIF_ALL;

    GetScrollInfo(Self.Handle, SB_VERT, SI);

    NewIndex := -1;
    OldIndex := GetTopVisibleIndex;

    case Message.ScrollCode of
      SB_LINEUP:
        NewIndex := OldIndex - 1;
      SB_LINEDOWN:
        NewIndex := OldIndex + 1;
      SB_PAGEUP:
      begin
        NewIndex := GetPageUpIndex(OldIndex);
      end;
      SB_PAGEDOWN:
      begin
        NewIndex := GetPageDownIndex(OldIndex);
      end;
      SB_THUMBPOSITION, SB_THUMBTRACK:
      begin
        if SI.nTrackPos <= SI.nMin then
          NewIndex := SI.nMin
        else
        if SI.nTrackPos >= SI.nMax then
          NewIndex := SI.nMax
        else
          NewIndex := SI.nTrackPos;
      end;
      SB_TOP:
        NewIndex := SI.nMin;
      SB_BOTTOM:
        NewIndex := SI.nMax;
    end;

    if NewIndex > -1 then
    begin
      VerifyTopIndex(NewIndex);

      if (NewIndex > -1) and (OldIndex <> NewIndex) then
      begin
        ANode := GetAbsoluteNode(NewIndex, True);
        if ANode <> nil then
          SetTopVisibleNode(ANode);
      end;
    end;
  end;
end;

function TSCCustomTreeList.CanShowEditor: Boolean;
begin
  Result := CanAllowEditing and not IsDesigning;
end;

procedure TSCCustomTreeList.DoHideEditor(ACell: TSCTreeCell);
begin
  if (ACell.Node <> nil) and (ACell.Node.Owner = Self) and
    Assigned(FOnHideEditor) then
    FOnHideEditor(Self, ACell);
end;

procedure TSCCustomTreeList.DoShowEditor(ACell: TSCTreeCell;
  var AllowEdit: Boolean);
begin
  AllowEdit := True;
  if (ACell.Node <> nil) and (ACell.Node.Owner = Self) and
    Assigned(FOnShowEditor) then
    FOnShowEditor(Self, ACell, AllowEdit);
end;

procedure TSCCustomTreeList.DoSizeEditor(ACell: TSCTreeCell;
  var EditRect: TRect);
begin
  if (ACell.Node <> nil) and (ACell.Node.Owner = Self) and
    Assigned(FOnSizeEditor) then
    FOnSizeEditor(Self, ACell, EditRect);
end;

procedure TSCCustomTreeList.DoValidateEditor(ACell: TSCTreeCell;
  var Text: String; var AcceptEdit: Boolean);
begin
  //
end;

function TSCCustomTreeList.GetEditingText: String;
begin
  Result := '';
  if FInplaceEditor <> nil then
    Result := TSCTreeListEdit(FInplaceEditor).Text;
end;

procedure TSCCustomTreeList.PrepareEditor;
var
  ACell: TSCTreeCell;
  AAlignment: TAlignment;
  ABorder: TSCControlBorder;
  ABorderColor, AColor, AFontColor: TColor;
begin
  if FInplaceEditor <> nil then
  begin
    ABorder := sccbFlat;
    ABorderColor := clBtnShadow;
    AColor := clWindow;
    AFontColor := Self.Font.Color;
    AAlignment := taLeftJustify;

    if (FEditColumn <> nil) and (FEditColumn.Alignment = taRightJustify) then
      AAlignment := taRightJustify;

    if (FLookAndFeel = sctlfDefault) and
      IsShowLineHorizontal and IsShowLineVertical then
    begin
      ABorder := sccbNone;
      ABorderColor := GetDefaultBackColor;
    end;

    with TSCTreeListEdit(FInplaceEditor) do
    begin
      AutoSize := False;
      Border := ABorder;
      FlatColor := ABorderColor;
      BorderInner := sccbNone;
      Color := AColor;
      Font := Self.Font;
      Layout := scelCenter;
      Alignment := AAlignment;
    end;

    ACell := AsCell(FEditNode, FEditColumn);

    DoPrepareEditor(ACell, AAlignment, ABorder,
      ABorderColor, AColor, AFontColor);

    if Assigned(FOnPrepareEditor) then
      FOnPrepareEditor(Self, ACell, AAlignment, ABorder,
        ABorderColor, AColor, AFontColor);

    with TSCTreeListEdit(FInplaceEditor) do
    begin
      AutoSize := False;
      Border := ABorder;
      FlatColor := ABorderColor;
      BorderInner := sccbNone;
      Color := AColor;
      Transparent := False;
      Font := Self.Font;
      Font.Color := AFontColor;
      Alignment := AAlignment;
    end;
  end;
end;

procedure TSCCustomTreeList.SetEditingText(const Value: String);
begin
  if FInplaceEditor <> nil then
    TSCTreeListEdit(FInplaceEditor).Text := Value;
end;

procedure TSCCustomTreeList.SizeEditor;
var
  CR, R: TRect;
begin
  if Editing and (FEditNode <> nil) and (FInplaceEditor <> nil) then
  begin
    R := GetEditorRect(AsCell(FEditNode, FEditColumn));

    CR := GetNodesRect;
    if IsShowIndicator then
      Inc(CR.Left, FIndicator);

    if R.Left < CR.Left then R.Left := CR.Left;
    if R.Right > CR.Right then R.Right := CR.Right;

    if R.Left > R.Right  then R.Right := R.Left;
    if R.Top  > R.Bottom then R.Bottom := R.Top;

    if FInplaceEditor <> nil then
      FInplaceEditor.BoundsRect := R;
  end;
end;

procedure TSCCustomTreeList.HideEditor;
var
  ANode: TSCTreeNode;
  ACol: TSCTreeColumn;
begin
  ANode := FEditNode;
  FEditNode := nil;

  ACol := FEditColumn;
  FEditColumn := nil;

  if Editing then
  begin
    KillClickTimer;
    FClickedNode := nil;
    FClickedColumn := nil;

    SetState(sctlsIdle);
    try
      FEditSavedText := '';

      with TSCTreeListEdit(FInplaceEditor) do
      begin
        OnInternalChange := nil;
        WindowProc := FInplaceOldWndProc;
      end;

      FInplaceOldWndProc := nil;
      DoHideEditor(AsCell(ANode, ACol));
    finally
      if FInplaceEditor <> nil then
        FreeAndNil(FInplaceEditor);
    end;

    if not IsDestroying then
    begin
      UpdateHottrack;
      if not Self.HasFocus then
        Self.CaptureFocus(True);

      UpdateHintWindow;
    end;
  end;
end;

procedure TSCCustomTreeList.PostEditor;
var
  AText, EdText: String;
  ACell: TSCTreeCell;
  ANode: TSCTreeNode;
  ACol: TSCTreeColumn;
  NeedPaint, Accept: Boolean;
begin
  ANode := FEditNode;
  FEditNode := nil;

  ACol := FEditColumn;
  FEditColumn := nil;

  if Editing and (ANode <> nil) then
  begin
    ACell := AsCell(ANode, ACol);

    KillClickTimer;
    FClickedNode := nil;
    FClickedColumn := nil;

    SetState(sctlsIdle);

    NeedPaint := False;
    EdText := GetEditingText;

    if EdText <> FEditSavedText then
    begin
      Accept := True;

      TSCTreeListEdit(FInplaceEditor).OnInternalChange := nil;
      ValidateEditor(ACell, EdText, Accept);

      AText := '';
      if FColumns.Count = 0 then
        AText := ANode.Text
      else if ACol <> nil then
        AText := ANode.GetString(FColumns.IndexOf(ACol));

      if Accept and (AText <> EdText) then
      begin
        NeedPaint := True;

        if FColumns.Count = 0 then
          ANode.Text := EdText
        else if ACol <> nil then
          ANode.SetString(FColumns.IndexOf(ACol), EdText);

        CalculateRowWidth;
        NodesChanged;
      end;
    end;

    HideEditor;
    MakeNodeVisible(ANode, False);

    if NeedPaint then
      UpdateNode(ANode, False, sctupNode);
  end;
end;

procedure TSCCustomTreeList.ShowEditor;
var
  CR, R: TRect;
  ACell: TSCTreeCell;
  AllowEdit: Boolean;
  ACol: TSCTreeColumn;
  EditorClass: TSCTreeEditorClass;
  OldFocus, OldTop: TSCTreeNode;
begin
  HideHintWindow;

  KillClickTimer;
  if FEditInShow then
    Exit;

  FClickedNode := nil;
  FClickedColumn := nil;
  FMouseDownNode := nil;

  PostEditor;

  ACol := nil;
  if FColumns.Count > 0 then
  begin
    ACol := FFocusedColumn;
    
    if (ACol = nil) or not ACol.Visible or
      (CanRowSelect and not CanCellSelect) then
      ACol := FirstVisibleColumn;

    if (ACol <> nil) and (ACol.Width = 0) then
      ACol := nil;
  end;

  if HandleAllocated and not (IsDesigning or Dragging or DragScrolling) and
    CanAllowEditing and HasAnyNode and (FFocusedNode <> nil) and
    CanShowEditor and ((FColumns.Count = 0) or (ACol <> nil)) then
  begin
    MakeColumnVisible(ACol, False);
    
    FEditInShow := True;
    try
      HideHintWindow;
      FMouseDownNode := nil;

      FInplaceOldWndProc := nil;

      CR := GetNodesRect;
      if IsShowIndicator then
        Inc(CR.Left, FIndicator);

      if IsRectEmpty(CR) then
        Exit;

      FEditColumn := ACol;
      FEditNode := FFocusedNode;
      OldFocus := FFocusedNode;

      OldTop := GetTopVisibleNode;
      MakeNodeVisible(FEditNode, False);

      if (OldTop = GetTopVisibleNode) and (OldFocus <> FFocusedNode) then
      begin
        UpdateNode(OldFocus, False, sctupNode);
        UpdateNode(FFocusedNode, False, sctupNode);
      end;

      {$IFDEF SC_DELPHI5_UP}
      if FInplaceEditor <> nil then
        FInplaceEditor.RemoveFreeNotification(Self);
      {$ENDIF}

      ACell := AsCell(FEditNode, ACol);
      EditorClass := GetEditorClass(ACell);

      if EditorClass = nil then
        Exit;

      FInplaceEditor := EditorClass.Create(Self);
      if FInplaceEditor <> nil then
        FInplaceEditor.FreeNotification(Self);

      FEditSavedText := '';
      if FColumns.Count = 0 then
        FEditSavedText := FEditNode.Text
      else if ACol <> nil then
        FEditSavedText := FEditNode.GetString(FColumns.IndexOf(ACol));

      with TSCTreeListEdit(FInplaceEditor) do
      begin
        Text := FEditSavedText;
        ClearUndo;
      end;

      PrepareEditor;

      if FInplaceEditor <> nil then
      begin
        AllowEdit := True;

        DoShowEditor(ACell, AllowEdit);
        if not AllowEdit then
        begin
          FEditSavedText := '';
          if FInplaceEditor <> nil then
            FreeAndNil(FInplaceEditor);

          Exit;
        end;

        R := GetEditorRect(ACell);

        if IsRectEmpty(R) then
        begin
          FEditSavedText := '';
          if FInplaceEditor <> nil then
            FreeAndNil(FInplaceEditor);

          Exit;
        end;

        if FInplaceEditor <> nil then
          with TSCTreeListEdit(FInplaceEditor) do
          begin
            OnInternalChange := InplaceChanged;

            FInplaceOldWndProc := WindowProc;
            WindowProc := InplaceWindowProc;

            BoundsRect := R;
            Parent := Self;

            if HandleAllocated and CanFocus then
              FInplaceEditor.SetFocus;
          end;
      end;
    finally
      KillClickTimer;
      FClickedNode := nil;
      FClickedColumn := nil;

      FEditInShow := False;

      if Editing then
        SetState(sctlsEditing)
      else SetState(sctlsIdle);

      UpdateHottrack;
    end;
  end;
end;

function TSCCustomTreeList.IsHintLocked: Boolean;
begin
  Result := FHintLock > 0;
end;

procedure TSCCustomTreeList.KeyDown(var Key: Word; Shift: TShiftState);
var
  ANode: TSCTreeNode;
  ByPassKey, CanEditCol: Boolean;
  AState: TSCTreeCheckButtonState;
  I, AIndex, ANextIndex, SaveIndex: Integer;
begin
  inherited KeyDown(Key, Shift);

  HideHintWindow;

  if InUpdate or not HasAnyNode then
    Exit;

  case Key of
    VK_F2:
    begin
      if CanAllowEditing and (FFocusedNode <> nil) then
      begin
        CanEditCol := (FColumns.Count = 0) or ((FFocusedColumn <> nil) and
          (not CanRowSelect or CanCellSelect));

        if CanEditCol then
          ShowEditor;
      end;

      Exit;
    end;
    VK_SPACE:
    begin
      ANode := FFocusedNode;

      if IsShowCheckButtons and (ANode <> nil) and
        (ANode.ButtonType <> sctcbNone) then
      begin
        AState := ANode.ButtonState;
        SwitchState(ANode.AllowGrayed, ANode.ButtonType, AState);

        SetButtonState(ANode, AState);
        MakeNodeVisible(ANode, False);
      end;
    end;
    VK_ESCAPE:
      CancelDragSize;
    VK_TAB:
    begin
      GoToNextCell(Key);
      Exit;
    end;
    VK_RETURN:
    begin
      GoToNextCell(Key);
      if CanShowEditorOnEnter then
        ShowEditor;

      Exit;
    end;
    VK_LEFT:
    begin
      if not (ssCtrl in Shift) and (FColumns.Count > 0) then
        GoToPriorCell
      else begin
        ANode := FFocusedNode;
        if (ANode <> nil) and (ANode.Count > 0) and ANode.Expanded then
        begin
          Collapse(ANode);
          MakeNodeVisible(ANode, False);
        end;
      end;

      Exit;
    end;
    VK_RIGHT:
    begin
      if not (ssCtrl in Shift) and (FColumns.Count > 0) then
        GoToNextCell(Key)
      else begin
        ANode := FFocusedNode;
        if (ANode <> nil) and (ANode.Count > 0) and not ANode.Expanded then
        begin
          Expand(ANode);
          MakeNodeVisible(ANode, False);
        end;
      end;

      Exit;
    end;
    VK_ADD, Ord('+'):
    begin
      ANode := FFocusedNode;
      if (ANode <> nil) and (ANode.Count > 0) and not ANode.Expanded then
      begin
        Expand(ANode);
        MakeNodeVisible(ANode, False);
      end;

      Exit;
    end;
    VK_SUBTRACT, Ord('-'):
    begin
      ANode := FFocusedNode;
      if (ANode <> nil) and (ANode.Count > 0) and ANode.Expanded then
      begin
        Collapse(ANode);
        MakeNodeVisible(ANode, False);
      end;

      Exit;
    end;
  end;

  if Key in SCArrowKeys then
  begin
    AIndex := GetAbsoluteIndex(FFocusedNode, True);
    VerifyIndex(AIndex);

    SaveIndex := AIndex;

    ByPassKey := False;
    if AIndex < 0 then
    begin
      ByPassKey := True;

      AIndex := CanChangeItemIndex(GetAbsoluteIndex(GetTopVisibleNode, True));
      VerifyIndex(AIndex);
    end;

    case Key of
      VK_UP, VK_PRIOR:
      begin
        ANextIndex := AIndex;

        if Key = VK_PRIOR then
          ANextIndex := CanChangeItemIndex(GetPageUpIndex(AIndex))
        else
        if not ByPassKey then
          Dec(ANextIndex);

        for I := ANextIndex downto 0 do
          if CanFocusNode(GetAbsoluteNode(I, True)) then
          begin
            AIndex := I;
            Break;
          end;
      end;
      VK_DOWN, VK_NEXT:
      begin
        ANextIndex := AIndex;

        if Key = VK_NEXT then
          ANextIndex := CanChangeItemIndex(GetPageDownIndex(AIndex))
        else
        if not ByPassKey then
          Inc(ANextIndex);

        for I := ANextIndex to FRealList.Count-1 do
          if CanFocusNode(GetAbsoluteNode(I, True)) then
          begin
            AIndex := I;
            Break;
          end;
      end;
      VK_HOME:
        AIndex := CanChangeItemIndex(0);
      VK_END:
        AIndex := CanChangeItemIndex(FRealList.Count-1);
    end;

    VerifyIndex(AIndex);
    if AIndex < 0 then
      AIndex := CanChangeItemIndex(0);

    if (SaveIndex <> AIndex) then
    begin
      ANode := GetAbsoluteNode(AIndex, True);
      
      if (ANode <> nil) and (ANode <> FFocusedNode) then
      begin
        SetFocusedNode(ANode);
        if (FColumns.Count > 0) and (FFocusedColumn = nil) then
          SetFocusedColumn(FirstVisibleColumn);

        MakeNodeVisible(ANode, False);

        if not (ssCtrl in Shift) and (CanMultiSelect or (FColumns.Count = 0)) and
          ((FSelectionList.Count <> 1) or (FSelectionList[0] <> ANode)) then
        begin
          ClearSelection;
          Select(ANode);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.LockHint;
begin
  Inc(FHintLock);
end;

function TSCCustomTreeList.DragScrolling: Boolean;
begin
  Result := FDragScrollTimer <> -1;
end;

procedure TSCCustomTreeList.StartDragScrolling;
var
  P: TPoint;
  CR: TRect;
  ANode: TSCTreeNode;
  AIndex, ADistance, ADelay: Integer;
begin
  if HandleAllocated then
  begin
    StopDragScrolling;

    if Enabled and CanDragScroll and not DragScrolling and
      GetCursorPos(P) and HasAnyNode then
    begin
      CR := GetNodesRect;
      P := Self.ScreenToClient(P);

      ADistance := 0;
      if P.y > CR.Bottom then
      begin
        AIndex := GetTopVisibleIndex;
        ANode := GetAbsoluteNode(AIndex + 1, True);

        if ANode <> nil then
        begin
          SetTopVisibleNode(ANode);
          ADistance := Abs(CR.Bottom - P.y);

          ANode := GetLastVisibleNode;
          if ANode <> nil then
          begin
            if FFocusedNode <> ANode then
              SetFocusedNode(ANode)
            else begin
              AIndex := GetAbsoluteIndex(ANode, True) + 1;
              if AIndex < FRealList.Count then
                SetFocusedNode(ANode);
            end;

            if (FColumns.Count > 0) and (FFocusedColumn = nil) then
              SetFocusedColumn(FirstVisibleColumn);
          end;
        end;
      end else
      if P.y < CR.Top then
      begin
        AIndex := GetTopVisibleIndex;
        ANode := GetAbsoluteNode(AIndex - 1, True);

        if ANode <> nil then
        begin
          SetTopVisibleNode(ANode);
          ADistance := Abs(CR.Top - P.y);

          ANode := GetTopVisibleNode;
          
          if ANode <> FRealList[0] then
          begin
            AIndex := GetAbsoluteIndex(ANode, True) - 1;
            ANode := GetAbsoluteNode(AIndex, True);

            if ANode <> nil then
            begin
              SetFocusedNode(ANode);
              if (FColumns.Count > 0) and (FFocusedColumn = nil) then
                SetFocusedColumn(FirstVisibleColumn);
            end;
          end;
        end;
      end;

      if ADistance > 0 then
      begin
        ADelay := 100;

        if ADistance >= 250 then
          ADelay := 20
        else
        if ADistance >= 150 then
          ADelay := 40
        else
        if ADistance >= 50 then
          ADelay := 60
        else
        if ADistance >= 25 then
          ADelay := 80;

        KillDragScrollTimer;
        InitiateDragScrollTimer(ADelay);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.StopDragScrolling;
begin
  if FDragScrollTimer <> -1 then
  begin
    KillDragScrollTimer;
    Invalidate;
  end;
end;

procedure TSCCustomTreeList.UnlockHint;
begin
  if FHintLock > 0 then
    Dec(FHintLock);
end;

procedure TSCCustomTreeList.DrawNodes(ACanvas: TCanvas);
var
  ANode: TSCTreeNode;
  ACol: TSCTreeColumn;
  CR, R, R2, R3: TRect;
  Nodes: TSCTreeNodeArray;
  AList, VisibleList: TList;
  ASelected, AFocused, AHot: Boolean;
  I, J, H, Ph, SR, TopOfRow,
  AImage, Len, NdHeight, NdIndent,
  NdSpace, ALevel, LvIndent: Integer;
begin
  CR := Self.GetNodesRect;

  if not IsRectEmpty(CR) then
  begin
    SetLength(Nodes, 0);
    Nodes := GetVisibleNodes(True);

    if Nodes <> nil then
    begin
      Len := Length(Nodes);

      if Len > 0 then
      begin
        NdSpace := 0;
        NdIndent := 0;

        LvIndent := GetLevelIndent;

        if IsShowIndicator then
          Inc(NdIndent, FIndicator);

        Inc(NdSpace, Self.Indent);
        Inc(NdIndent, Self.Indent);

        if IsShowFlagImages and (FFlagImages <> nil) then
        begin
          Inc(NdSpace, FFlagImages.Width);
          Inc(NdIndent, FFlagImages.Width);
        end;

        Dec(NdIndent, FHorizontalPos);

        AList := TList.Create;
        try
          H := CR.Bottom - CR.Top;
          TopOfRow := 0;

          for I := 0 to Len - 1 do
          begin
            if TopOfRow >= H then
              Exit;

            ANode := Nodes[I];
            if ANode = nil then
              Continue;

            NdHeight := GetNodeHeight(ANode);
            if NdHeight <= 0 then
              Continue;

            R := CR;

            Inc(R.Top, TopOfRow);
            R.Bottom := R.Top + NdHeight;

            Inc(TopOfRow, NdHeight);

            ALevel := GetNodeLevel(ANode);

            Inc(R.Left, NdIndent);
            Inc(R.Left, ALevel*LvIndent);

            // Drag background
            R2 := R;
            Dec(R2.Left, ALevel*LvIndent);

            SR := IntersectClipRect(ACanvas.Handle,
              R2.Left, R2.Top, R2.Right, R2.Bottom);
            try
              if SR <> NULLREGION then
                DrawBack(ACanvas, ANode, R2);

              if IsInspectorStyle then
                DrawInspectorStyle(ACanvas, ANode, R);
            finally
              SelectClipRgn(ACanvas.Handle, 0);
            end;

            // Draw node
            R2 := R;
            if IsInspectorSharpStyle then
              Inc(R2.Top)
            else
            if IsOutlookStyle then
              Inc(R2.Top)
            else
            if IsInspectorNetStyle then
              Inc(R2.Left, 2);

            if IsShowCheckButtons and (ANode.ButtonType <> sctcbNone) then
              Inc(R2.Left, SC_TreeCheckButtonSize);

            AFocused := ANode = FFocusedNode;
            ASelected := FSelectionList.IndexOf(ANode) > -1;

            AHot := (FHotNode = ANode) and not (Editing or Dragging);
            if AHot and (FColumns.Count > 0) then
              AHot := (FHotColumn <> nil) or (IsShowPreview and (FHotPart = sctpPreview));

            if Images <> nil then
            begin
              R3 := R2;
              R3.Right := R3.Left;

              Inc(R3.Right, Images.Width);

              if IsShowStateImages and (FStateImages <> nil) then
              begin
                AImage := ANode.StateIndex;
                if (AImage > -1) and (AImage < FStateImages.Count) then
                  Inc(R3.Right, FStateImages.Width);
              end;

              Inc(R2.Left, R3.Right - R2.Left);

              DrawImages(ACanvas, ANode, R3, ASelected, AFocused, AHot);
            end;

            DrawNodeBack(ACanvas, ANode, R2);

            R3 := R2;
            if (FColumns.Count = 0) and not (IsRowStyle or IsShowPreview) then
              R3.Right := R3.Left + ANode.Width;

            Ph := 0;
            if IsShowPreview then
              Ph := GetPreviewHeight(ANode);

            if not IsRectEmpty(R3) then
            begin
              DrawSelection(ACanvas, ANode, R3);

              if IsShowPreview and (Ph > 0) then
              begin
                Dec(R3.Bottom, Ph);
                if R3.Bottom < R3.Top then
                  R3.Bottom := R3.Top;
              end;

              if not IsRectEmpty(R3) then
              begin
                if FColumns.Count = 0 then
                  DrawNode(ACanvas, ANode, R3)
                else DrawCells(ACanvas, ANode, R3);
              end;
            end;

            if IsShowPreview then
            begin
              R3 := R2;

              R3.Top := R3.Bottom - Ph;
              if R3.Top < R2.Top then R3.Top := R2.Top;

              if FColumns.Count > 0 then
              begin
                R3.Right := CR.Left;
                if IsShowIndicator then
                  Inc(R3.Right, FIndicator);

                Dec(R3.Right, FHorizontalPos);

                for J := 0 to FColumns.Count-1 do
                begin
                  ACol := TSCTreeColumn(FColumns[J]);
                  if ACol.Visible and (ACol.Width > 0) then
                    Inc(R3.Right, ACol.Width);
                end;
              end;

              if not IsRectEmpty(R3) then
                DrawPreview(ACanvas, ANode, R3);
            end;

            // Draw indent
            if (ALevel > 0) or (NdSpace > 0) then
            begin
              R2 := R;
              R2.Right := R2.Left;

              Dec(R2.Left, NdSpace);

              if ALevel > 0 then
                Dec(R2.Left, ALevel*LvIndent);

              if IsInspectorNetStyle then
                Dec(R2.Right)
              else
              if IsInspectorSharpStyle then
              begin
                Dec(R2.Right);
                if ALevel > 0 then
                  Dec(R2.Right, LvIndent*(ALevel-1));
              end;

              if R2.Right > CR.Left then
              begin
                SR := IntersectClipRect(ACanvas.Handle,
                  R2.Left, R2.Top, R2.Right, R2.Bottom);
                try
                  if SR <> NULLREGION then
                    DrawIndent(ACanvas, ANode, R2);
                finally
                  SelectClipRgn(ACanvas.Handle, 0);
                end;

                if (R2.Bottom < CR.Bottom) and (ANode = FRealList[FRealList.Count-1]) then
                begin
                  R2.Top := R2.Bottom;
                  R2.Bottom := CR.Bottom;

                  if not IsRectEmpty(R2) then
                  begin
                    SR := IntersectClipRect(ACanvas.Handle,
                      R2.Left, R2.Top, R2.Right, R2.Bottom);
                    try
                      if SR <> NULLREGION then
                        DrawIndent(ACanvas, nil, R2);
                    finally
                      SelectClipRgn(ACanvas.Handle, 0);
                    end;
                  end;
                end;
              end;
            end;

            if IsDefaultStyle then
              DrawDefaultStyle(ACanvas, ANode, R);

            if IsInspectorNetStyle then
              DrawInspectorNetStyle(ACanvas, ANode, R);

            if IsInspectorSharpStyle then
              DrawInspectorSharpStyle(ACanvas, ANode, R);

            if IsOffice12Style then
              DrawOffice12Style(ACanvas, ANode, R);
          end;

          VisibleList := TList.Create;
          try
            for I := 0 to Len - 1 do
            begin
              ANode := Nodes[I];
              if ANode <> nil then
                VisibleList.Add(ANode);
            end;

            TopOfRow := 0;
            for I := 0 to Len - 1 do
            begin
              if TopOfRow >= H then
                Exit;

              ANode := Nodes[I];
              if ANode = nil then
                Continue;

              NdHeight := GetNodeHeight(ANode);
              if NdHeight <= 0 then
                Continue;

              R := CR;

              Inc(R.Top, TopOfRow);
              R.Bottom := R.Top + NdHeight;

              Inc(TopOfRow, NdHeight);

              ALevel := GetNodeLevel(ANode);

              Inc(R.Left, NdIndent);
              Inc(R.Left, ALevel*LvIndent);

              // Draw tree lines and expand-collapse button
              if (ALevel > 0) and IsShowTreeLine and
                (IsDefaultStyle or IsOffice12Style) then
              begin
                R2 := R;
                R2.Right := R2.Left;

                Dec(R2.Left, NdIndent);
                Dec(R2.Left, ALevel*LvIndent);

                DrawTreeLine(ACanvas, ANode, VisibleList, AList, R2);
              end;

              // Draw button
              if (ALevel > 0) and IsShowButtons and
                ((ANode.Count > 0) or (IsShowEmptyButtons and not IsOutlookStyle)) then
              begin
                R2 := R;
                R2.Right := R2.Left;
                Dec(R2.Left, LvIndent);

                if R2.Right > CR.Left then
                begin
                  SR := IntersectClipRect(ACanvas.Handle,
                    R2.Left, R2.Top, R2.Right, R2.Bottom);
                  try
                    if SR <> NULLREGION then
                      DrawButton(ACanvas, ANode, R2);
                  finally
                    SelectClipRgn(ACanvas.Handle, 0);
                  end;
                end;
              end;

              // Draw check buttons
              if IsShowCheckButtons and (ANode.ButtonType <> sctcbNone) then
              begin
                R2 := R;
                R2.Right := R2.Left;
                Dec(R2.Left, LvIndent - NodeIndent);
                OffsetRect(R2, SC_TreeCheckButtonSize, 0);

                if R2.Right > CR.Left then
                begin
                  SR := IntersectClipRect(ACanvas.Handle,
                    R2.Left, R2.Top, R2.Right, R2.Bottom);
                  try
                    if SR <> NULLREGION then
                      DrawCheckButton(ACanvas, ANode, R2);
                  finally
                    SelectClipRgn(ACanvas.Handle, 0);
                  end;
                end;
              end;

              // Draw indicator
              if IsShowIndicator then
              begin
                R2 := R;

                R2.Left := CR.Left;
                R2.Right := R2.Left + FIndicator;

                if not IsRectEmpty(R2) then
                begin
                  SR := IntersectClipRect(ACanvas.Handle,
                    R2.Left, R2.Top, R2.Right, R2.Bottom);
                  try
                    if SR <> NULLREGION then
                      DrawIndicator(ACanvas, ANode, R2, clNone);
                  finally
                    SelectClipRgn(ACanvas.Handle, 0);
                  end;
                end;
              end;
            end;
          finally
            VisibleList.Free;
          end;
        finally
          AList.Free;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.ClearSelection;
var
  L: TList;
  I: Integer;
  ANode: TSCTreeNode;
  Nodes: TSCTreeNodeArray;
begin
  if FSelectionList.Count > 0 then
  begin
    SelectionChanging;
    try
      L := TList.Create;
      try
        for I := FSelectionList.Count-1 downto 0 do
        begin
          ANode := TSCTreeNode(FSelectionList[I]);

          if CanUnselect(ANode) then
          begin
            L.Add(ANode);
            FSelectionList.Delete(I);
          end;
        end;

        if L.Count > 0 then
        begin
          SetLength(Nodes, L.Count);
          
          for I := 0 to L.Count-1 do
            Nodes[I] := TSCTreeNode(L[I]);

          UpdateNodes(Nodes);
        end;
      finally
        L.Free;
      end;
    finally
      SelectionChanged;
    end;
  end;
end;

procedure TSCCustomTreeList.DoDrawCell(ACell: TSCTreeCell;
  ACanvas: TCanvas; ARect: TRect; ASelected, AFocused, AHot: Boolean;
  AFont: TFont; var AColor: TColor; var AText: string;
  var Handled: Boolean);
begin
  //
end;

procedure TSCCustomTreeList.DoDrawPreview(ANode: TSCTreeNode;
  ACanvas: TCanvas; ARect: TRect; ASelected, AFocused, AHot: Boolean;
  AFont: TFont; var AColor: TColor; var AText: string;
  var Handled: Boolean);
begin
  //
end;

procedure TSCCustomTreeList.DoDrawSelection(ACell: TSCTreeCell;
  ACanvas: TCanvas; ARect: TRect; ASelected, AFocused, AHot: Boolean;
  var AColor: TColor; var Handled: Boolean); 
begin
  //
end;

procedure TSCCustomTreeList.Select(ANode: TSCTreeNode);
begin
  if CanSelect(ANode) then
  begin
    SelectionChanging;
    try
      FSelectionList.Add(ANode);
      UpdateNode(ANode, False, sctupNode);
    finally
      SelectionChanged;
    end;
  end;
end;

procedure TSCCustomTreeList.Unselect(ANode: TSCTreeNode);
var
  AIndex: Integer;
begin
  if CanUnselect(ANode) then
  begin
    AIndex := FSelectionList.IndexOf(ANode);

    if AIndex > -1 then
    begin
      SelectionChanging;
      try
        FSelectionList.Delete(AIndex);
        UpdateNode(ANode, False, sctupNode);
      finally
        SelectionChanged;
      end;
    end;
  end;
end;

function TSCCustomTreeList.GetSelection(Index: Integer): TSCTreeNode;
begin
  Result := TSCTreeNode(FSelectionList[Index]);
end;

function TSCCustomTreeList.GetSelectionCount: Integer;
begin
  Result := FSelectionList.Count;
end;

procedure TSCCustomTreeList.SelectionChanged;
begin
  if Assigned(FOnSelectionChange) then
    FOnSelectionChange(Self);
end;

procedure TSCCustomTreeList.SelectionChanging;
begin
  if Assigned(FOnSelectionChanging) then
    FOnSelectionChanging(Self);
end;

procedure TSCCustomTreeList.Invalidate;
begin
  if not InUpdate then
    inherited Invalidate;
end;

function TSCCustomTreeList.VisibleNodeCount(AllowPartitial: Boolean): Integer;
var
  H: Integer;
  CR: TRect;
  ANode: TSCTreeNode;
begin
  Result := 0;

  if HandleAllocated and HasAnyNode then
  begin
    CR := Self.GetNodesRect;
    H := CR.Bottom - CR.Top;

    if H > 0 then
    begin
      ANode := GetTopVisibleNode;

      while ANode <> nil do
      begin
        Inc(Result);
        Dec(H, GetNodeHeight(ANode));

        if H <= 0 then
        begin
          if not AllowPartitial and
            (H < 0) and (Result > 1) then
            Dec(Result);

          Break;
        end;

        ANode := ANode.GetNextVisible;
      end;
    end;
  end;
end;

function TSCCustomTreeList.GetAbsoluteNode(AIndex: Integer;
  InExpandeds: Boolean): TSCTreeNode;
var
  I, J: Integer;
  CurNode: TSCTreeNode;

  function GetNextNodes(ANode: TSCTreeNode) : TSCTreeNode;
  var
    K: Integer;
  begin
    Result := nil;
    for K := 0 to ANode.Count-1 do
    begin
      Inc(I);

      if I = AIndex then
      begin
        Result := ANode[K];
        Exit;
      end;

      if not InExpandeds or ANode[K].Expanded then
         Result := GetNextNodes(ANode[K]);

      if Result <> nil then
        Exit;
    end;
  end;

begin
  Result := nil;
  if (AIndex > -1) and HasAnyNode then
  begin
    if InExpandeds then
    begin
      if AIndex < FRealList.Count then
        Result := TSCTreeNode(FRealList[AIndex]);

      Exit;
    end;

    I := -1;
    for J := 0 to FList.Count - 1 do
    begin
      Inc(I);

      CurNode := TSCTreeNode(FList[J]);
      if I = AIndex then
      begin
        Result := CurNode;
        Exit;
      end;

      if not InExpandeds or CurNode.Expanded then
        Result := GetNextNodes(CurNode);

      if Result <> nil then
        Exit;
    end;
  end;
end;

procedure TSCCustomTreeList.ChildDeleted(ANode: TSCTreeNode);
begin
  //
end;

function TSCCustomTreeList.IsNodeVisible(ANode: TSCTreeNode;
  AllowPartitial: Boolean): Boolean;
var
  I: Integer;
  Expanded: Boolean;
  AParent: TSCTreeNode;
  Nodes: TSCTreeNodeArray;
begin
  Result := False;
  if (ANode <> nil) and (ANode.FOwner = Self) then
  begin
    Expanded := True;

    AParent := ANode.Parent;
    while AParent <> nil do
    begin
      Expanded := AParent.Expanded;
      if not Expanded then
        Break;

      AParent := AParent.Parent;
    end;

    if Expanded then
    begin
      SetLength(Nodes, 0);
      Nodes := GetVisibleNodes(AllowPartitial);

      if (Nodes <> nil) and (Length(Nodes) > 0) then
        for I := 0 to Length(Nodes) - 1 do
          if Nodes[I] = ANode then
          begin
            Result := True;
            Break;
          end;
    end;
  end;
end;

procedure TSCCustomTreeList.MakeNodeVisible(ANode: TSCTreeNode;
  AllowPartitial: Boolean);
var
  CR: TRect;
  H, Th: Integer;
  PrevN, N: TSCTreeNode;
  Nodes: TSCTreeNodeArray;
  ATop, ABottom, AIndex: Integer;
begin
  if (ANode <> nil) and (ANode.FOwner = Self) and
    not IsNodeVisible(ANode, AllowPartitial) then
  begin
    SetLength(Nodes, 0);
    Nodes := GetVisibleNodes(AllowPartitial);

    if (Nodes = nil) or (Length(Nodes) <= 1) then
      SetTopVisibleNode(ANode)
    else
    if not ParentExpanded(ANode) then
      SetTopVisibleNode(ANode)
    else begin
      AIndex := GetAbsoluteIndex(ANode, True);
      ATop := GetAbsoluteIndex(Nodes[0], True);

      if AIndex < ATop then
        SetTopVisibleNode(ANode)
      else begin
        ABottom := GetAbsoluteIndex(Nodes[Length(Nodes)-1], True);

        if AIndex > ABottom then
        begin
          CR := GetNodesRect;
          Th := CR.Bottom - CR.Top;

          if Th <= 0 then
          begin
            ATop := AIndex - (Length(Nodes) - 1);
            VerifyIndex(ATop);

            ANode := GetAbsoluteNode(ATop, True);
            if ANode <> nil then
              SetTopVisibleNode(ANode);
          end else
          begin
            N := ANode;
            PrevN := ANode;

            while (N <> nil) do
            begin
              if not N.InDestroy then
              begin
                H := GetNodeHeight(N);

                if H > 0 then
                begin
                  ANode := N;
                  Dec(Th, H);

                  if Th <= 0 then
                  begin
                    if Th < 0 then
                      ANode := PrevN;

                    Break;
                  end;
                end;
              end;

              PrevN := N;
              N := N.GetPrevSibling;
            end;

            if ANode <> nil then
              SetTopVisibleNode(ANode);
          end;
        end;
      end;
    end;
  end;
end;

function TSCCustomTreeList.GetVisibleNodes(AllowPartitial: Boolean): TSCTreeNodeArray;
var
  L: TList;
  I, H: Integer;
  CR: TRect;
  ANode: TSCTreeNode;
begin
  SetLength(Result, 0);

  CR := GetNodesRect;
  H := CR.Bottom - CR.Top;
  
  if H > 0 then
  begin
    ANode := GetTopVisibleNode;

    L := TList.Create;
    try
      while ANode <> nil do
      begin
        L.Add(ANode);
        Dec(H, GetNodeHeight(ANode));

        if H <= 0 then
        begin
          if not AllowPartitial and
            (H < 0) and (L.Count > 1) then
            L.Delete(L.Count-1);

          Break;
        end;

        ANode := ANode.GetNextVisible;
      end;

      SetLength(Result, L.Count);
      for I := 0 to L.Count-1 do
        Result[I] := TSCTreeNode(L[I]);
    finally
      L.Free;
    end;
  end;
end;

function TSCCustomTreeList.GetLevelIndent: Integer;
begin
  Result := SC_TreeLevelIndent + FNodeIndent;
end;

function TSCCustomTreeList.DoCanFocusNode(ANode: TSCTreeNode): Boolean;
begin
  Result := True;
end;

function TSCCustomTreeList.DoCanSelect(ANode: TSCTreeNode): Boolean;
begin
  Result := True;
end;

function TSCCustomTreeList.DoCanUnselect(ANode: TSCTreeNode): Boolean;
begin
  Result := True;
end;

procedure TSCCustomTreeList.DoDrawButton(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; var ABackColor: TColor;
  var AFrameColor: TColor; var AForeColor: TColor; var Handled: Boolean);
begin
  //
end;

procedure TSCCustomTreeList.DrawButton(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  R, R2: TRect;
  Handled: Boolean;
  L, T, BtnSize: Integer;
  C1, C2, ABackColor,
  AFrameColor, AForeColor: TColor;
begin
  if (ANode <> nil) and (FButtons <> nil) and not IsRectEmpty(ARect) and
    ((ANode.Count > 0) or (IsShowEmptyButtons and not IsOutlookStyle)) then
  begin
    with FButtons do
    begin
      ABackColor := BackColor;
      AFrameColor := FrameColor;
      AForeColor := ForeColor;
    end;

    if (sctfpButton in FFlashParts) and FFlashOn and CanFlashNode(ANode) then
    begin
      case FButtons.Style of
        sctbsDefault:
        begin
          if FColors.FlashTextColor <> clNone then
          begin
            AFrameColor := FColors.FlashTextColor;
            AForeColor := FColors.FlashTextColor;
          end;

          if FColors.FlashColor <> clNone then
          begin
            AFrameColor := FColors.FlashColor;
            ABackColor := FColors.FlashColor;
          end;
        end;
        sctbsXP:
        begin
          if FColors.FlashColor <> clNone then
            AFrameColor := FColors.FlashColor
          else
          if FColors.FlashTextColor <> clNone then
            AFrameColor := FColors.FlashTextColor;

          if FColors.FlashTextColor <> clNone then
            AForeColor := FColors.FlashTextColor;
        end;
        sctbsOffice12:
        begin
          if FColors.FlashColor <> clNone then
            AFrameColor := FColors.FlashColor
          else
          if FColors.FlashTextColor <> clNone then
            AFrameColor := FColors.FlashTextColor;

          if FColors.FlashTextColor <> clNone then
            AForeColor := FColors.FlashTextColor;
        end;
        sctbs3D, sctbsFlat:
        begin
          if FColors.FlashColor <> clNone then
          begin
            ABackColor := FColors.FlashColor;
            AFrameColor := FColors.FlashColor;
          end;

          if FColors.FlashTextColor <> clNone then
            AForeColor := FColors.FlashTextColor;
        end;
        sctbsMac:
        begin
          if FColors.FlashTextColor <> clNone then
          begin
            AFrameColor := FColors.FlashTextColor;
            AForeColor := FColors.FlashTextColor;
          end;

          if FColors.FlashColor <> clNone then
          begin
            AFrameColor := FColors.FlashColor;
            ABackColor := FColors.FlashColor;
          end;
        end;
      end;
    end;

    BtnSize := GetButtonSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - FNodeIndent - BtnSize) div 2);
    R.Right := R.Left + BtnSize;

    Inc(R.Top, (ARect.Bottom - ARect.Top) div 2);
    Dec(R.Top, BtnSize div 2);
    R.Bottom := R.Top + BtnSize;

    Handled := False;

    if Assigned(FOnCustomDrawButton) then
      FOnCustomDrawButton(Self, ANode, ACanvas, R, ANode.Selected,
        ANode.Focused, ABackColor, AFrameColor, AForeColor, Handled);

    if not Handled then
      DoDrawButton(ACanvas, ANode, R, ABackColor, AFrameColor,
        AForeColor, Handled);

    if Handled then
      Exit;

    if FButtons.Style = sctbsMac then
    begin
      if AFrameColor = clNone then AFrameColor := clBtnText;
      if AForeColor = clNone then AForeColor := clBtnText;

      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AForeColor;

        Pen.Mode  := pmCopy;
        Pen.Color := AFrameColor;
        Pen.Style := psSolid;
        Pen.Width := 1;

        if ANode.Expanded then
          Polygon([Point(R.Left + 1, R.Top + 2),
            Point(R.Left + 9, R.Top + 2), Point(R.Left + 5, R.Top + 6)])
        else
          Polygon([Point(R.Left + 3, R.Top), Point(R.Left + 7, R.Top + 4),
            Point(R.Left + 3, R.Top + 8)]);
      end;
    end else
    begin
      if ABackColor = clNone then
      begin
        ABackColor := GetFaceColor;
        if ABackColor = clNone then
          ABackColor := clWindow;
      end;

      if AFrameColor = clNone then AFrameColor := clGrayText;
      if AForeColor = clNone then AForeColor := clBtnText;

      if FButtons.Style = sctbsOffice12 then
      begin
        R2 := R;
        InflateRect(R2, -1, -1);

        DrawOffice12Cell(ACanvas, R2, ABackColor, False);
      end else
      if FButtons.Style = sctbsXP then
      begin
        R2 := R;
        InflateRect(R2, -1, -1);

        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := ABackColor;

          FillRect(R2);

          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := GetBtnShadowOf(ABackColor);

          MoveTo(R2.Right, R2.Top);
          LineTo(R2.Right, R2.Bottom);

          Pen.Color := GetBtnHighlightOf(ABackColor);

          MoveTo(R2.Left, R2.Top);
          LineTo(R2.Left, R2.Bottom);
        end;

        R2 := R;
        InflateRect(R2, -2, -1);
        R2.Bottom := R2.Top + Round(2*((R2.Bottom - R2.Top) / 3));

        scDrawGradient(ACanvas, R2, scgBottomToTop, ABackColor,
          GetBtnHighlightOf(ABackColor));

        R2 := R;
        InflateRect(R2, -2, -1);
        R2.Top := R2.Bottom - Round((R2.Bottom - R2.Top) / 3);

        scDrawGradient(ACanvas, R2, scgTopToBottom, ABackColor,
          GetBtnShadowOf(ABackColor));
      end else
        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := ABackColor;

          FillRect(R);
        end;

      // Draw Plus or Minus
      R2 := R;

      InflateRect(R2, -2, -2);
      if FButtons.Style <> sctbsDefault then
        InflateRect(R2, -1, -1);

      if FButtons.Style = sctbs3D then
      begin
        Dec(R2.Right);
        Dec(R2.Bottom);
      end;

      if not IsRectEmpty(R2) then
      begin
        T := R2.Top + ((R2.Bottom - R2.Top) div 2);
        L := R2.Left + ((R2.Right - R2.Left) div 2);

        with ACanvas do
        begin
          Brush.Style := bsClear;

          Pen.Style := psSolid;
          Pen.Mode := pmCopy;
          Pen.Width := 1;
          Pen.Color := AForeColor;

          if ANode.Count = 0 then
          begin
            MoveTo(L, T);
            LineTo(L, T + 1);
          end else
          begin
            MoveTo(R2.Left, T);
            LineTo(R2.Right, T);

            if not ANode.Expanded then
            begin
              MoveTo(L, R2.Top);
              LineTo(L, R2.Bottom);
            end;
          end;
        end;
      end;

      case FButtons.Style of
        sctbs3D:
        begin
          C1 := GetBtnHighlightOf(ABackColor);
          C2 := Get3DDkShadowOf(ABackColor);

          scFrame3D(ACanvas, R, C1, C2, 1, 0);

          C1 := ABackColor;
          C2 := GetBtnShadowOf(ABackColor);

          scFrame3D(ACanvas, R, C1, C2, 1, 0);
        end;
        sctbsDefault:
        begin
          scFrame3D(ACanvas, R, AFrameColor, AFrameColor, 1, 0);
          scFrame3D(ACanvas, R, ABackColor, ABackColor, 1, 0);
        end;
        sctbsFlat:
        begin
          C1 := GetBtnHighlightOf(ABackColor);
          C2 := GetBtnShadowOf(ABackColor);

          scFrame3D(ACanvas, R, C1, C2, 1, 0);
        end;
        sctbsXP:
        begin
          scFrame3D(ACanvas, R, AFrameColor, AFrameColor, 1, 2);
        end;
        sctbsOffice12:
        begin
          scFrame3D(ACanvas, R, AFrameColor, AFrameColor, 1, 2);
        end;
      end;
    end;
  end;
end;

function TSCCustomTreeList.GetTopVisibleNode: TSCTreeNode;
begin
  Result := FTopVisibleNode;
  if (Result = nil) and HasAnyNode then
    Result := TSCTreeNode(FRealList[0]);
end;

function TSCCustomTreeList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSCCustomTreeList.CanScrollToPos(Kind: TSCScrollbarKind;
  var NewValue: Integer): Boolean;
begin
  Result := True; // not Editing;
end;

function TSCCustomTreeList.CanSelect(ANode: TSCTreeNode): Boolean;
begin
  Result := False;
  if (ANode <> nil) and (ANode.Owner = Self) and
    CanMultiSelect and (FSelectionList.IndexOf(ANode) = -1) then
  begin
    Result := DoCanSelect(ANode);
    if Result and Assigned(FOnCanSelectNode) then
      FOnCanSelectNode(Self, ANode, Result);
  end;
end;

procedure TSCCustomTreeList.DoScrollerPositionChanged(
  Kind: TSCScrollbarKind);
var
  AIndex: Integer;
  Sb: TSCTreeScrollbar;
  ANode: TSCTreeNode;
begin
  if FScrollPosChanging = 0 then
  begin
    HideHintWindow;
    HideEditor;

    HideDragImages;
    Inc(FScrollbarChanging);
    try
      if Kind = scskHorizontal then
      begin
        Sb := TSCTreeScrollbar(ScrollbarHorz);
        SetHorizontalPos(Sb.Position);
      end else
      begin
        Sb := TSCTreeScrollbar(ScrollbarVert);

        AIndex := Sb.Position;
        VerifyTopIndex(AIndex);

        if AIndex <> GetTopVisibleIndex then
        begin
          ANode := GetAbsoluteNode(AIndex, True);
          if ANode <> nil then
            SetTopVisibleNode(ANode);
        end;
      end;
    finally
      Dec(FScrollbarChanging);
      ShowDragImages;
    end;
  end;
end;

procedure TSCCustomTreeList.InsertingChild(AParent, ANode: TSCTreeNode);
begin
  //
end;

procedure TSCCustomTreeList.DoInsertingColumn(AColumn: TSCTreeColumn);
begin
  //
end;

procedure TSCCustomTreeList.RemovingChild(AParent, ANode: TSCTreeNode);
var
  ATopVisibleNode: TSCTreeNode;
begin
  if (ANode <> nil) and (ANode = FTopVisibleNode) then
  begin
    ATopVisibleNode := ANode.GetPrevVisible;

    if ATopVisibleNode = nil then
    begin
      ATopVisibleNode := AParent;
      if (ATopVisibleNode = nil) and (FList <> nil) and (FList.Count > 0) then
        ATopVisibleNode := TSCTreeNode(FList[0]);
    end;

    SetTopVisibleNode(ATopVisibleNode);
  end;
end;

procedure TSCCustomTreeList.DoRemovingColumn(AColumn: TSCTreeColumn);
begin
  //
end;

function TSCCustomTreeList.CanShowHorzScrollBar: Boolean;
begin
  Result := HandleAllocated and (FRowWidth > Self.ClientWidth);
end;

function TSCCustomTreeList.CanShowVertScrollBar: Boolean;
begin
  Result := HasAnyNode and (FRealList.Count > 1) and
    (GetScrollCount > 0);
end;

function TSCCustomTreeList.CanUnselect(ANode: TSCTreeNode): Boolean;
begin
  Result := False;
  if (ANode <> nil) and (ANode.Owner = Self) and
    (FSelectionList.IndexOf(ANode) > -1) then
  begin
    Result := DoCanUnselect(ANode);
    if Result and Assigned(FOnCanUnselectNode) then
      FOnCanUnselectNode(Self, ANode, Result);
  end;
end;

function TSCCustomTreeList.IsHorzScrollBarVisible: Boolean;
begin
  Result := inherited IsHorzScrollBarVisible;
end;

function TSCCustomTreeList.UpdateHorzScrollBar: Boolean;
var
  ScrlVisible: Boolean;
  SiOld, SiNew: TSCScrollInfo;
begin
  Result := False;
  if HandleAllocated and not (IsCreatingWnd or IsLoading) then
  begin
    HideDragImages;
    try
      SiOld := Self.GetScrollbarInfo(scskHorizontal);
      ScrlVisible := SiOld.Visible and (SiOld.Page <= SiOld.Max);

      SiNew := SiOld;

      SiNew.Page := 1;
      SiNew.Min  := 0;
      SiNew.Max  := 0;
      SiNew.Pos  := 0;

      if (HasAnyNode or (FColumns.Count > 0)) and CanShowHorzScrollBar then
      begin
        if not ((FColumns.Count = 0) and IsDrawEndEllipsis) then
        begin
          SiNew.Page := Self.ClientWidth;
          SiNew.Min  := 0;
          SiNew.Max  := FRowWidth;
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
    finally
      ShowDragImages;
    end;
  end;
end;

function TSCCustomTreeList.UpdateVertScrollBar: Boolean;
var
  ANode: TSCTreeNode;
  Dist, AIndex: Integer;
  ScrlVisible: Boolean;
  SiOld, SiNew: TSCScrollInfo;
begin
  Result := False;
  if HandleAllocated and not (IsCreatingWnd or IsLoading) then
  begin
    HideDragImages;
    try
      SiOld := Self.GetScrollbarInfo(scskVertical);
      ScrlVisible := SiOld.Visible and (SiOld.Page <= SiOld.Max);

      SiNew := SiOld;

      SiNew.Min := 0;
      if HasAnyNode and (FRealList.Count > 1) and CanShowVertScrollBar then
      begin
        SINew.Page := Self.GetScrollPageCount;

        SINew.Min  := 0;
        SINew.Max  := FRealList.Count;
        SINew.Pos  := GetTopVisibleIndex;
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
        begin
          AIndex := SiNew.Min;
          VerifyTopIndex(AIndex);

          ANode := GetAbsoluteNode(AIndex, True);
          if ANode <> nil then
            SetTopVisibleNode(ANode);
        end;
      end;

      Result := ScrlVisible <> (Integer(SiNew.Page) <= SiNew.Max);
    finally
      ShowDragImages;
    end;
  end;
end;

function TSCCustomTreeList.IsVertScrollBarVisible: Boolean;
begin
  Result := inherited IsVertScrollBarVisible;
end;

procedure TSCCustomTreeList.SetHorizontalPos(Value: Integer);
begin
  Inc(FScrollPosChanging);
  try
    if IsDesigning or Editing or
      ((FColumns.Count = 0) and IsDrawEndEllipsis) then
    begin
      Value := 0;
      if Editing then
        Value := FHorizontalPos;
    end;

    VerifyHorizontalPos(Value);

    if FHorizontalPos <> Value then
    begin
      HideHintWindow;
      FHorizontalPos := Value;

      UpdateHorzScrollBar;
      if HasAnyNode or (FColumns.Count > 0) then
        Invalidate;

      SizeEditor;

      UpdateHottrack;

      HideHintWindow;
      UpdateHintWindow;
    end;

    if FScrollbarChanging = 0 then
      TSCTreeScrollbar(ScrollbarHorz).SetPosition(FHorizontalPos);
  finally
    Dec(FScrollPosChanging);
  end;
end;

procedure TSCCustomTreeList.SetHottrack(Value: TSCTreeHottrack);
begin
  FHottrack.Assign(Value);
end;

procedure TSCCustomTreeList.VerifyHorizontalPos(var APos: Integer);
var
  NewPos, MaxValue: Integer;
begin
  NewPos := APos;
  APos := 0;

  if HandleAllocated and (FRowWidth > -1) and
    (HasAnyNode or (FColumns.Count > 0)) then
  begin
    MaxValue := 0;
    if not ((FColumns.Count = 0) and IsDrawEndEllipsis) then
    begin
      MaxValue := FRowWidth - Self.ClientWidth;
      if MaxValue < 0 then
        MaxValue := 0;
    end;

    if NewPos > MaxValue then
      NewPos := MaxValue;

    APos := NewPos;
  end;
end;

function TSCCustomTreeList.GetPageDownIndex(AIndex: Integer): Integer;
var
  ScrCount: Integer;
begin
  Result := -1;
  if HasAnyNode then
  begin
    Result := AIndex;
    VerifyIndex(Result);

    if Result < 0 then
      Result := 0;

    if Result = FNodeList.Count-1 then
      Exit;

    ScrCount := Self.VisibleNodeCount(False);
    if ScrCount < 1 then
      ScrCount := 1;

    Inc(Result, ScrCount);
    VerifyIndex(Result);
  end;
end;

function TSCCustomTreeList.GetPageUpIndex(AIndex: Integer): Integer;
var
  ScrCount: Integer;
begin
  Result := -1;
  if HasAnyNode then
  begin
    Result := AIndex;

    VerifyIndex(Result);
    if Result < 0 then
      Result := 0;

    if Result = 0 then
      Exit;

    ScrCount := Self.VisibleNodeCount(False);
    if ScrCount < 1 then
      ScrCount := 1;

    Dec(Result, ScrCount);
    VerifyIndex(Result);

    if Result < 0 then
      Result := 0;
  end;
end;

procedure TSCCustomTreeList.VerifyTopIndex(var AIndex: Integer);
var
  ANode: TSCTreeNode;
  NewIndex, LastIndex: Integer;
begin
  NewIndex := AIndex;
  AIndex := 0;

  if HandleAllocated and HasAnyNode and (FRealList.Count > 1) and
    not (IsLoading or IsReading) then
  begin
    if NewIndex > FRealList.Count - 1 then
      NewIndex := FRealList.Count - 1;

    if NewIndex < 0 then AIndex := 0;

    if NewIndex > 0 then
    begin
      ANode := GetLastTopVisibleNode;
      if ANode = nil then
        NewIndex := 0
      else begin
        LastIndex := GetAbsoluteIndex(ANode, True);

        if NewIndex > LastIndex then
          NewIndex := LastIndex;
      end;
    end;

    AIndex := NewIndex;
  end;
end;

procedure TSCCustomTreeList.VerifyIndex(var AIndex: Integer);
var
  NewIndex: Integer;
begin
  NewIndex := AIndex;
  AIndex := -1;

  if HasAnyNode and not (IsLoading or IsReading) then
  begin
    if NewIndex < -1 then
      NewIndex := -1
    else
    if NewIndex > FNodeList.Count - 1 then
      NewIndex := FNodeList.Count - 1;

    AIndex := NewIndex;
  end;
end;

function TSCCustomTreeList.SearchNodeList(ANode: TSCTreeNode): Integer;
var
  L, H, I, C, IntNode: Integer;
begin
  Result := -1;

  if (FNodeList <> nil) then
  begin
    L := 0;
    H := FNodeList.Count - 1;
    IntNode := Integer(ANode);

    while L <= H do
    begin
      I := (L + H) shr 1;
      {$IFDEF SC_DELPHIXE2_UP}
      C := Integer(FNodeList.List[I]) - IntNode;
      {$ELSE}
      C := Integer(FNodeList.List^[I]) - IntNode;
      {$ENDIF}

      if C = 0 then
      begin
        Result := I;
        Break;
      end
      else
      if (C < 0) then
        L := I + 1
      else H := I - 1;
    end;
  end;
end;

function TSCCustomTreeList.CanChangeItemIndex(AIndex: Integer): Integer;
begin
  Result := AIndex;
  VerifyIndex(Result);
end;

function TSCCustomTreeList.ParentExpanded(ANode: TSCTreeNode): Boolean;
var
  P: TSCTreeNode;
begin
  Result := False;
  if (ANode <> nil) and (ANode.FOwner = Self) then
  begin
    Result := True;

    P := ANode.Parent;
    while P <> nil do
    begin
      Result := P.Expanded;
      if not Result then
        Break;

      P := P.Parent;
    end;
  end;
end;

function TSCCustomTreeList.GetNodeWidth(ANode: TSCTreeNode): Integer;
begin
  Result := GetNodeWidth(Canvas, Self.Font, ANode);
end;

function TSCCustomTreeList.GetNodeWidth(ACanvas: TCanvas;
  AFont: TFont; ANode: TSCTreeNode): Integer;
begin
  Result := -1;
  if HandleAllocated and (ANode <> nil) and (ANode.FOwner = Self) then
  begin
    ACanvas.Font.Assign(AFont);
    Result := Canvas.TextWidth(ANode.Text) + SC_TreeNodeHorzSpacing;
  end;
end;

procedure TSCCustomTreeList.UpdateHottrack;
var
  P: TPoint;
  HitInfo: TSCTreeHitInfo;
begin
  if HandleAllocated then
  begin
    HitInfo.Node := nil;
    HitInfo.Part := sctpNowhere;

    GetCursorPos(P);
    P := Self.ScreenToClient(P);

    HitInfo.Pos := P;

    if CanTrackMouse then
      HitInfo := GetHitInfo(P.x, P.y);

    HottrackNode(HitInfo);
  end;
end;

procedure TSCCustomTreeList.HintWindowProc(var Message: TMessage);
var
  R: TRect;
  MDC, DC: HDC;
  PS: TPaintStruct;
  Handled: Boolean;
  ACell: TSCTreeCell;
begin
  if (Message.Msg = WM_PAINT) and (FHintWnd <> nil) and
    FHintWnd.HandleAllocated and (FHintNode <> nil) and
    ((FColumns.Count = 0) or (FHintColumn <> nil)) then
  begin
    R := FHintWnd.ClientRect;
    ACell := AsCell(FHintNode, FHintColumn);

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

            Handled := False;
            if Assigned(FOnPaintHint) then
              FOnPaintHint(Self, ACell, FHintWnd.Canvas,
                R, FHintText, Handled);

            if not Handled then
              DoDrawHint(FHintWnd.Canvas, ACell, R, FHintText);
          finally
            FHintWnd.Canvas.Handle := 0;
          end;
        finally
          FHintWnd.Canvas.Unlock;
        end;
      finally
        if MDC = 0 then EndPaint(FHintWnd.Handle, PS);
      end;
    end;

    Exit;
  end;

  if Assigned(FHintOldWndProc) then
    FHintOldWndProc(Message);
end;

procedure TSCCustomTreeList.InplaceChanged(Sender: TObject);
begin
  MakeNodeVisible(FFocusedNode, False);
end;

procedure TSCCustomTreeList.InplaceWindowProc(var Message: TMessage);
var
  Key: Word;
  ANode: TSCTreeNode;
  ACol: TSCTreeColumn;
begin
  case Message.Msg of
    WM_KILLFOCUS:
    begin
      PostEditor;
      Exit;
    end;
    WM_KEYDOWN:
    begin
      Key := Message.WParam;
      if Key in [VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT] then
      begin
        HideEditor;
        Self.KeyDown(Key, []);
        
        Exit;
      end;

      case Message.WParam of
        VK_ESCAPE:
        begin
          HideEditor;
          Exit;
        end;
        VK_RETURN:
        begin
          PostEditor;

          ANode := FFocusedNode;
          ACol := FFocusedColumn;

          GoToNextCell(VK_RETURN);
          if (CanShowEditorOnEnter and ((FFocusedNode <> ANode) or
            (FFocusedColumn <> ACol))) then
            ShowEditor;

          Exit;
        end;
      end;
    end;
  end;

  if Assigned(FInplaceOldWndProc) then
    FInplaceOldWndProc(Message);
end;

procedure TSCCustomTreeList.MouseInControlChanged;
begin
  UpdateHottrack;

  HideHintWindow;
  KillHintTimer;

  if MouseInControl and not (Editing or Dragging or DragScrolling) then
    UpdateHintWindow;
end;

procedure TSCCustomTreeList.StopTracking;
begin
  FHintOldNode := nil;
  FHintOldColumn := nil;
  FMouseDownNode := nil;
  FDragPoint := Point(-1, -1);

  CancelDragSize;

  HideHintWindow;
  StopDragScrolling;

  if FState = sctlsNodeDown then
    SetState(sctlsIdle);

  inherited StopTracking;
end;

function TSCCustomTreeList.GetNodeLevel(ANode: TSCTreeNode): Integer;
var
  PrevLevel, MinLevel: Integer;
begin
  Result := 0;
  if (ANode <> nil) and (ANode.FOwner = Self) then
  begin
    Result := ANode.GetLevel;

    if IsOutlookStyle then
    begin
      if ANode.Count > 0 then
        Inc(Result);
    end else
    if IsGrouping then
    begin
      if GroupedNode(ANode) then
        Inc(Result);
    end else
    if IsShowRoot then
      Inc(Result);

    PrevLevel := Result;

    if Assigned(FOnGetNodeLevel) then
      FOnGetNodeLevel(Self, ANode, Result);

    DoGetNodeLevel(ANode, Result);

    if Result <> PrevLevel then
    begin
      MinLevel := 0;
      if ANode.Parent <> nil then
        MinLevel := GetNodeLevel(ANode.Parent);

      if Result < MinLevel then
        Result := MinLevel;
    end;
  end;
end;

procedure TSCCustomTreeList.SetNodeIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FNodeIndent <> Value then
  begin
    FNodeIndent := Value;

    if HasAnyNode then
    begin
      CalculateRowWidth;
      NodesChanged;

      Invalidate;
    end;
  end;
end;

procedure TSCCustomTreeList.NodesChanged;
begin
  HideEditor;
  HideHintWindow;

  if IsDestroying or not HandleAllocated or
    (Parent = nil) or not Parent.HandleAllocated then
    Exit;

  UpdateHottrack;
  UpdateHintWindow;
end;

procedure TSCCustomTreeList.DoNodesChanged;
begin
  //
end;

procedure TSCCustomTreeList.ChildEnabledChanged(ANode: TSCTreeNode);
begin
  if not InUpdate and (FEditNode = ANode) then
  begin
    NodesChanged;
    if IsNodeVisible(ANode, True) then
      UpdateNode(ANode, False, sctupNode);
  end;
end;

function TSCCustomTreeList.GetLastTopVisibleNode: TSCTreeNode;
var
  CR: TRect;
  ANode: TSCTreeNode;
  I, H, LastTop: Integer;
begin
  Result := nil;
  if HandleAllocated and HasAnyNode and
    not (IsLoading or IsReading) then
  begin
    if FRealList.Count = 1 then
    begin
      Result := TSCTreeNode(FRealList[0]);
      Exit;
    end;

    CR := GetNodesRect;
    H := CR.Bottom - CR.Top;

    LastTop := 0;
    if H > 0 then
    begin
      for I := FRealList.Count-1 downto 0 do
      begin
        ANode := TSCTreeNode(FRealList[I]);
        Dec(H, GetNodeHeight(ANode));

        if H <= 0 then
        begin
          LastTop := I;
          if H < 0 then LastTop := I + 1;

          Break;
        end;
      end;

      if LastTop > FRealList.Count-1 then
        LastTop := FRealList.Count-1;
    end;

    if LastTop > -1 then
      Result := TSCTreeNode(FRealList[LastTop]);
  end;
end;

function TSCCustomTreeList.GetLastVisibleNode: TSCTreeNode;
var
  Nodes: TSCTreeNodeArray;
begin
  Result := nil;

  SetLength(Nodes, 0);
  Nodes := GetVisibleNodes(True);

  if (Nodes <> nil) and (Length(Nodes) > 0) then
    Result := Nodes[Length(Nodes)-1];
end;

procedure TSCCustomTreeList.SetIndicator(Value: Integer);
begin
  if Value < 10 then Value := 10;

  if FIndicator <> Value then
  begin
    FIndicator := Value;
    
    if IsShowIndicator and HasAnyNode then
    begin
      CalculateRowWidth;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomTreeList.SetLineStyle(Value: TSCTreeLineStyle);
begin
  if FLineStyle <> Value then
  begin
    FLineStyle := Value;

    if IsShowTreeLine and HasAnyNode and
      (IsDefaultStyle or IsOffice12Style) then
      Invalidate;
  end;
end;

procedure TSCCustomTreeList.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0;
  inherited SetIndent(Value);
end;

procedure TSCCustomTreeList.IndentChanged;
begin
  if HasAnyNode then
  begin
    CalculateRowWidth;
    Invalidate;
  end;
end;

procedure TSCCustomTreeList.DrawIndicator(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; AColor: TColor);
var
  I, L, T: Integer;
  Handled: Boolean;
  LightCl, ABackColor,
  AForeColor: TColor;
begin
  if not IsRectEmpty(ARect) then
  begin
    ABackColor := AColor;

    if ABackColor = clNone then
    begin
      ABackColor := FColors.IndicatorColor;
      if ABackColor = clNone then
        ABackColor := clBtnFace;
    end;

    AForeColor := FColors.IndicatorForeColor;
    if AForeColor = clNone then
      AForeColor := clBtnText;

    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := ABackColor;

      FillRect(ARect);
    end;

    Handled := False;

    if Assigned(FOnCustomDrawIndicator) then
      FOnCustomDrawIndicator(Self, ANode, ACanvas, ARect,
        ABackColor, AForeColor, Handled);

    if not Handled then
      DoDrawIndicator(ACanvas, ANode, ARect, ABackColor,
        AForeColor, Handled);

    if Handled then
      Exit;

    if ABackColor = clNone then ABackColor := clBtnFace;
    if AForeColor = clNone then AForeColor := clBtnText;

    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := ABackColor;

      FillRect(ARect);

      if FLookAndFeel = sctlfOffice12 then
        DrawOffice12Cell(ACanvas, ARect, ABackColor, False)
      else
      if FLookAndFeel = sctlfGradient then
      begin
        LightCl := BlendedColor(ABackColor, 24, 24, 24, True);
        scDrawGradient(ACanvas, ARect, scgTopToBottom, LightCl, ABackColor);
      end;

      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;
      Pen.Color := AForeColor;

      if (ANode <> nil) and (FFocusedNode = ANode) then
      begin
        L := ARect.Left + ((ARect.Right - ARect.Left - 5) div 2);
        T := ARect.Top + ((ARect.Bottom - ARect.Top - 9) div 2);

        for I := 0 to 4 do
        begin
          MoveTo(L + I, T + I);
          LineTo(L + I, T + 9 - I);
        end;
      end;

      case FLookAndFeel of
        sctlfDefault:
        begin
          scFrame3D(ACanvas, ARect, GetBtnHighlightOf(ABackColor),
            Get3DDkShadowOf(ABackColor), 1, 0);

          Dec(ARect.Top);
          Dec(ARect.Left);
          
          scFrame3D(ACanvas, ARect, GetBtnHighlightOf(ABackColor),
            GetBtnShadowOf(ABackColor), 1, 0);
        end;
        sctlfFlat:
        begin
          scFrame3D(ACanvas, ARect, GetBtnHighlightOf(ABackColor),
            GetBtnShadowOf(ABackColor), 1, 0);
        end;
        sctlfFlatEx:
        begin
          with ACanvas do
          begin
            Pen.Mode  := pmCopy;
            Pen.Style := psSolid;
            Pen.Width := 1;
            Pen.Color := Get3DDkShadowOf(ABackColor);

            with ARect do
            begin
              MoveTo(Right-1, Top);
              LineTo(Right-1, Bottom-1);
              LineTo(Left-1,  Bottom-1);
            end;
          end;

          InflateRect(ARect, -1, -1);
        end;
        sctlfGradient:
        begin
          with ACanvas do
          begin
            Pen.Mode  := pmCopy;
            Pen.Style := psSolid;
            Pen.Width := 1;
            Pen.Color := GetBtnShadowOf(ABackColor);

            with ARect do
            begin
              MoveTo(Right-1, Top);
              LineTo(Right-1, Bottom-1);
              LineTo(Left-1,  Bottom-1);
            end;
          end;

          InflateRect(ARect, -1, -1);
        end;
        sctlfOffice12:
        begin
          with ACanvas do
          begin
            Pen.Mode  := pmCopy;
            Pen.Style := psSolid;
            Pen.Width := 1;
            Pen.Color := GetBtnShadowOf(ABackColor);

            with ARect do
            begin
              MoveTo(Right-1, Top);
              LineTo(Right-1, Bottom-1);
              LineTo(Left-1,  Bottom-1);
            end;
          end;

          InflateRect(ARect, -1, -1);
        end;
      end;

      if not (FLookAndFeel in [sctlfGradient, sctlfOffice12]) then
        scFrame3D(ACanvas, ARect, ABackColor, ABackColor, 1, 0);
    end;
  end;
end;

procedure TSCCustomTreeList.DoDrawIndicator(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; var ABackColor, AForeColor: TColor;
  var Handled: Boolean);
begin
  //
end;

function TSCCustomTreeList.IsNodePartitial(ANode: TSCTreeNode): Boolean;
var
  AParent: TSCTreeNode;
  Expanded: Boolean;
  FullNodes, Nodes: TSCTreeNodeArray;
begin
  Result := False;
  if (ANode <> nil) and (ANode.FOwner = Self) then
  begin
    Expanded := True;

    AParent := ANode.Parent;
    while AParent <> nil do
    begin
      Expanded := AParent.Expanded;
      if not Expanded then
        Break;

      AParent := AParent.Parent;
    end;

    if Expanded then
    begin
      SetLength(Nodes, 0);
      Nodes := GetVisibleNodes(True);

      if (Nodes <> nil) and (Length(Nodes) > 0) and
        (Nodes[Length(Nodes)-1] = ANode) then
      begin
        SetLength(FullNodes, 0);
        FullNodes := GetVisibleNodes(False);

        Result := (FullNodes = nil) or (Length(FullNodes) = 0) or
          (FullNodes[Length(FullNodes)-1] <> ANode);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.ColumnChanged(AColumn: TSCTreeColumn;
  Forced: Boolean);
begin
  UpdateColumns(Forced);
end;

procedure TSCCustomTreeList.UpdateColumns(Resized: Boolean);
begin
  if HasAnyNode or HasAnyColumn then
  begin
    if Resized then CalculateRowWidth;
    Invalidate;
  end;
end;

procedure TSCCustomTreeList.HeaderFontChanged(Sender: TObject);
begin
  Canvas.Font.Assign(Self.HeaderFont);
  FDefaultHeaderHeight := Canvas.TextHeight('Rq') + SC_TreeHeaderVertSpace;

  if IsShowHeader and (FColumns <> nil) and (FColumns.Count > 0) then
  begin
    Invalidate;
    if (FList <> nil) and (FList.Count > 0) then
      UpdateScrollbars(True, True);
  end;
end;

procedure TSCCustomTreeList.ColumnInserted(AColumn: TSCTreeColumn);
begin
  AColumn.FSortDirection := sctsdNone;
  UpdateColumns(True);
end;

procedure TSCCustomTreeList.ColumnMoved(OldIndex, NewIndex: Integer);
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to FList.Count-1 do
      TSCTreeNode(FList[I]).MoveNodeValues(OldIndex, NewIndex);

    UpdateColumns(False);

    if Assigned(FOnColumnMoved) then
      FOnColumnMoved(Self, TSCTreeColumn(FColumns[NewIndex]),
        OldIndex, NewIndex);
  finally
    EndUpdate;
    UpdateDesigner;
  end;
end;

procedure TSCCustomTreeList.ColumnRemoved(AColumn: TSCTreeColumn);
begin
  if AColumn <> nil then
  begin
    AColumn.FSortDirection := sctsdNone;

    if AColumn = FFocusedColumn then
    begin
      FFocusedColumn := nil;
      KillClickTimer;
    end;

    if AColumn = FClickedColumn then
    begin
      FClickedColumn := nil;
      KillClickTimer;
    end;

    if AColumn = FHotColumn then
    begin
      FHotColumn := nil;
      KillHintTimer;
    end;

    if AColumn = FHintColumn then
    begin
      FHintColumn := nil;
      KillHintTimer;
    end;
  end;

  UpdateColumns(True);
end;

procedure TSCCustomTreeList.SetHeaderFont(Value: TFont);
begin
  FHeaderFont.Assign(Value);
end;

procedure TSCCustomTreeList.ValidateEditor(ACell: TSCTreeCell;
  var Text: String; var AcceptEdit: Boolean);
begin
  DoValidateEditor(ACell, Text, AcceptEdit);

  if not AcceptEdit and (ACell.Node <> nil) and
    (ACell.Node.Owner = Self) and Assigned(FOnValidateEditor) then
    FOnValidateEditor(Self, ACell, Text, AcceptEdit);
end;

procedure TSCCustomTreeList.FullCollapse;
var
  I: Integer;
  TopNode: TSCTreeNode;
begin
  if (FList <> nil) and (FList.Count > 0) then
  begin
    BeginUpdate;
    try
      for I := 0 to FList.Count-1 do
        TSCTreeNode(FList[I]).Collapse(True);

      TopNode := GetTopParentNode(GetTopVisibleNode);
      SetTopVisibleNode(TopNode);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TSCCustomTreeList.FullExpand;
var
  I: Integer;
begin
  if (FList <> nil) and (FList.Count > 0) then
  begin
    BeginUpdate;
    try
      for I := 0 to FList.Count-1 do
        TSCTreeNode(FList[I]).Expand(True);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawIndent(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  R: TRect;
  AColor: TColor;
  Handled: Boolean;
  I, T, AImage, ALevel, LvIndent: Integer;
begin
  if not IsRectEmpty(ARect) then
  begin
    Handled := False;

    AColor := FColors.IndentColor;
    if IsOutlookStyle then
    begin
      AColor := FColors.OutlookColor;
      if AColor = clNone then
        AColor := clBtnFace;
    end else
    if IsInspectorSharpStyle and (AColor = clNone) then
      AColor := clBtnFace;

    if Assigned(FOnCustomDrawIndent) then
      FOnCustomDrawIndent(Self, ANode, ACanvas, ARect, AColor,
        Handled);

    if not Handled then
      DoDrawIndent(ACanvas, ANode, ARect, AColor,
        Handled);

    if Handled then
      Exit;

    if (AColor <> clNone) and not IsInspectorStyle then
    begin
      if (ANode <> nil) and IsOutlookStyle then
      begin
        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := AColor;
        end;

        ALevel := GetNodeLevel(ANode);
        LvIndent := GetLevelIndent;

        for I := 0 to ALevel-1 do
        begin
          R := ARect;
          if (I = 0) and (ANode.Count > 0) then
            Inc(R.Top);

          R.Right := R.Right - LvIndent*I;
          R.Left := R.Right - LvIndent;

          if (I > 0) or (ANode.Count = 0) then
            Dec(R.Right);

          ACanvas.FillRect(R);
        end;
      end else
      if not IsOutlookStyle then
        with ACanvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := AColor;

          FillRect(ARect);
        end;
    end;

    if (ANode <> nil) and IsShowFlagImages and (FFlagImages <> nil) then
    begin
      AImage := ANode.FlagIndex;

      if (AImage > -1) and (AImage < FFlagImages.Count) then
      begin
        R := ARect;
        Inc(R.Left, Self.Indent);

        T := R.Top + (R.Bottom - R.Top - FFlagImages.Height) div 2;
        FFlagImages.Draw(ACanvas, R.Left, T, AImage, Self.Enabled);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DoDrawIndent(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; var AColor: TColor;
  var Handled: Boolean);
begin
  //
end;

procedure TSCCustomTreeList.DrawVerticalLine(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  I, L: Integer;
  AColor: TColor;
begin
  if IsDefaultStyle or IsOffice12Style then
  begin
    AColor := FColors.LineColor;

    if AColor <> clNone then
    begin
      with ACanvas do
      begin
        Brush.Style := bsClear;

        Pen.Style := psSolid;
        Pen.Color := AColor;
        Pen.Mode := pmCopy;
        Pen.Width := 1;
      end;

      L := ARect.Left + ((ARect.Right - ARect.Left - FNodeIndent) div 2);

      if FLineStyle = sctlsSolid then
      begin
        with ACanvas do
        begin
          MoveTo(L, ARect.Top);
          LineTo(L, ARect.Bottom + 1);
        end;
      end else
        for I := ARect.Top to ARect.Bottom do
          if not Odd(I) then
            with ACanvas do
            begin
              MoveTo(L, I);
              LineTo(L, I + 1);
            end;
    end;
  end;
end;

procedure TSCCustomTreeList.SetPaintStyle(Value: TSCTreePaintStyle);
begin
  if FPaintStyle <> Value then
  begin
    FPaintStyle := Value;

    if HasAnyNode then
    begin
      CalculateRowWidth;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomTreeList.UpdateHintWindow;
var
  P: TPoint;
begin
  if HandleAllocated and not IsDesigning and
    GetCursorPos(P) and IsWindowVisible(Self.Handle) then
  begin
    P := Self.ScreenToClient(P);
    ShowHintWindow(P);
  end;
end;

procedure TSCCustomTreeList.DrawBack(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  AColor: TColor;
  Handled: Boolean;
begin
  if not IsRectEmpty(ARect) then
  begin
    AColor := clNone;
    if GroupedNode(ANode) then
      AColor := FColors.GroupColor;

    Handled := False;

    if Assigned(FOnCustomDrawBack) then
      FOnCustomDrawBack(Self, ANode, ACanvas, ARect,
        AColor, Handled);

    if not Handled then
      DoDrawBack(ACanvas, ANode, ARect, AColor, Handled);

    if Handled then
      Exit;

    if AColor <> clNone then
      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AColor;

        FillRect(ARect);
      end;
  end;
end;

function TSCCustomTreeList.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomTreeList.GetFaceColor: TColor;
begin
  Result := Self.Color;
  if Result = clNone then Result := clWindow;
end;

procedure TSCCustomTreeList.DoDrawBack(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; var AColor: TColor;
  var Handled: Boolean);
begin
  //
end;

function TSCCustomTreeList.GroupedNode(ANode: TSCTreeNode): Boolean;
var
  ALevel: Integer;
begin
  Result := False;
  if (ANode <> nil) and (ANode.FOwner = Self) then
  begin
    if ANode.GroupHeader then
    begin
      ALevel := ANode.GetLevel;

      Result := (ALevel >= 0) and (ANode.Count > 0);
      if IsGroupOnlyFirstLevel then
        Result := ALevel = 0;
    end;

    DoGroupedNode(ANode, Result);
    if Assigned(FOnGetGroup) then
      FOnGetGroup(Self, ANode, Result);
  end;
end;

function TSCCustomTreeList.IsRowStyle: Boolean;
begin
  Result := CanRowSelect or IsGrouping or
    (IsInspectorStyle or IsInspectorSharpStyle or
    IsInspectorNetStyle or IsOutlookStyle);
end;

procedure TSCCustomTreeList.DoGetNodeLevel(ANode: TSCTreeNode;
  var ALevel: Integer);
begin
  //
end;

function TSCCustomTreeList.CanAllowEditing: Boolean;
begin
  Result := sctboAllowEditing in FOptionsBehaviour;
end;

function TSCCustomTreeList.CanAnsiSort: Boolean;
begin
  Result := sctboAnsiSort in FOptionsBehaviour;
end;

function TSCCustomTreeList.CanAutoSort: Boolean;
begin
  Result := sctboAutoSort in FOptionsBehaviour;
end;

function TSCCustomTreeList.CanDblClickExpand: Boolean;
begin
  Result := sctboDblClickExpand in FOptionsBehaviour;
end;

function TSCCustomTreeList.CanDragExpand: Boolean;
begin
  Result := sctboDragExpand in FOptionsBehaviour;
end;

function TSCCustomTreeList.CanDragScroll: Boolean;
begin
  Result := sctboDragScroll in FOptionsBehaviour;
end;

function TSCCustomTreeList.IsDrawEndEllipsis: Boolean;
begin
  Result := sctvoDrawEndEllipsis in FOptionsView;
end;

function TSCCustomTreeList.IsGroupOnlyFirstLevel: Boolean;
begin
  Result := sctvoGroupOnlyFirstLevel in FOptionsView;
end;

function TSCCustomTreeList.IsHideFocusRect: Boolean;
begin
  Result := sctvoHideFocusRect in FOptionsView;
end;

function TSCCustomTreeList.IsHideSelection: Boolean;
begin
  Result := sctvoHideSelection in FOptionsView;
end;

function TSCCustomTreeList.IsHottrack: Boolean;
begin
  Result := sctvoHottrack in FOptionsView;
end;

function TSCCustomTreeList.CanImmediateEditor: Boolean;
begin
  Result := sctboImmediateEditor in FOptionsBehaviour;
end;

function TSCCustomTreeList.CanMouseScroll: Boolean;
begin
  Result := (sctboMouseScroll in FOptionsBehaviour) and not Editing;
end;

function TSCCustomTreeList.CanMultiSelect: Boolean;
begin
  Result := sctboMultiSelect in FOptionsBehaviour;
end;

function TSCCustomTreeList.CanRightClickSelect: Boolean;
begin
  Result := sctboRightClickSelect in FOptionsBehaviour;
end;

function TSCCustomTreeList.CanRowAutoHeight: Boolean;
begin
  Result := sctboRowAutoHeight in FOptionsBehaviour;
end;

function TSCCustomTreeList.CanRowSelect: Boolean;
begin
  Result := sctboRowSelect in FOptionsBehaviour;
end;

function TSCCustomTreeList.IsShowButtons: Boolean;
begin
  Result := sctvoShowButtons in FOptionsView;
end;

function TSCCustomTreeList.IsShowHeader: Boolean;
begin
  Result := sctvoShowHeader in FOptionsView;
end;

function TSCCustomTreeList.IsShowHighlightFrame: Boolean;
begin
  Result := sctvoShowHighlightFrame in FOptionsView;
end;

function TSCCustomTreeList.IsShowIndicator: Boolean;
begin
  Result := sctvoShowIndicator in FOptionsView;
end;

function TSCCustomTreeList.IsShowLineHorizontal: Boolean;
begin
  Result := sctvoShowLineHorizontal in FOptionsView;
end;

function TSCCustomTreeList.IsShowLineVertical: Boolean;
begin
  Result := sctvoShowLineVertical in FOptionsView;
end;

function TSCCustomTreeList.IsShowNodeHints: Boolean;
begin
  Result := sctvoShowNodeHints in FOptionsView;
end;

function TSCCustomTreeList.IsShowRoot: Boolean;
begin
  Result := sctvoShowRoot in FOptionsView;
end;

function TSCCustomTreeList.IsShowStateImages: Boolean;
begin
  Result := sctvoShowStateImages in FOptionsView;
end;

function TSCCustomTreeList.IsShowTreeLine: Boolean;
begin
  Result := sctvoShowTreeLine in FOptionsView;
end;

function TSCCustomTreeList.IsDefaultStyle: Boolean;
begin
  Result := FPaintStyle = sctpsDefault;
end;

function TSCCustomTreeList.IsInspectorStyle: Boolean;
begin
  Result := FPaintStyle = sctpsInspector;
end;

function TSCCustomTreeList.IsInspectorNetStyle: Boolean;
begin
  Result := FPaintStyle = sctpsInspectorNet;
end;

function TSCCustomTreeList.IsOutlookStyle: Boolean;
begin
  Result := FPaintStyle = sctpsOutlook;
end;

function TSCCustomTreeList.GetAbsoluteCount: Integer;
begin
  Result := 0;
  if FRealList <> nil then
    Result := FRealList.Count;
end;

procedure TSCCustomTreeList.DoBeginDragNode(ANode: TSCTreeNode);
begin
  //
end;

procedure TSCCustomTreeList.DoEndDrag(Target: TObject; X, Y: Integer);
var
  HitInfo: TSCTreeHitInfo;
  ANode, HitNode: TSCTreeNode;
begin
  inherited DoEndDrag(Target, X, Y);
  ANode := FDragNode;
  FDragNode := nil;
  FDragOverNode := nil;
  SetDragObject(nil);
  SetState(sctlsIdle);
  FreeAndNil(FDragImageList);

  if (ANode <> nil) and (Target = Self) and CanAutoDragMove then
  begin
    HitInfo := GetHitInfo(X, Y);
    HitNode := HitInfo.Node;

    if (ANode <> HitNode) and (ANode.Parent <> HitNode) and
      not IsParentNodeOf(HitNode, ANode) then
    begin
      if HitNode = nil then
        Self.InsertChild(ANode, FList.Count)
      else begin
        HitNode.InsertChild(ANode, HitNode.Count);
        Self.Expand(HitNode);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DoStartDrag(var DragObject: TDragObject);
var
  P: TPoint;
begin
  HideHintWindow;
  if Editing then
    HideEditor;

  inherited DoStartDrag(DragObject);

  if FDragNode = nil then
  begin
    GetCursorPos(P);
    P := Self.ScreenToClient(P);

    FDragNode := GetNodeAt(P.x, P.y);
  end;

  FDragOverNode := FDragNode;

  if (FDragNode <> nil) then
  begin
    BeginDragNode(FDragNode);
    PrepareNodeToDrag(FDragNode);
    SetState(sctlsNodeDragging);
  end;

  SetDragObject(nil);
end;

procedure TSCCustomTreeList.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  ANode: TSCTreeNode;
  HitInfo: TSCTreeHitInfo;
begin
  if IsDesigning then
  begin
    Accept := False;
    Exit;
  end;

  inherited DragOver(Source, X, Y, State, Accept);

  if not (Dragging or (FDragObject <> nil)) then
    Exit;

  KillDragScrollTimer;

  HitInfo := GetHitInfo(X, Y);
  FDragOverNode := HitInfo.Node;

  if (FDragNode <> nil) and (Source = Self) and CanAutoDragMove then
  begin
    ANode := HitInfo.Node;
    Accept := (FDragNode <> ANode) and (FDragNode.Parent <> ANode) and
      not IsParentNodeOf(ANode, FDragNode);
  end;

  if CanDragExpand and (HitInfo.Part in SC_DragExpandHitParts) then
  begin
    FDragExpandNode := HitInfo.Node;

    KillDragExpandTimer;
    InitiateDragExpandTimer;
  end;

  if CanDragScroll then
    StartDragScrolling;
end;

function TSCCustomTreeList.GetDragImages: TDragImageList; 
begin
  Result := nil;
  if ShowDragImage then Result := FDragImageList;
end;

procedure TSCCustomTreeList.PrepareNodeToDrag(ANode: TSCTreeNode);
var
  AText: String;
  CellR, R: TRect;
  DragBitmap: TBitmap;
  ACol: TSCTreeColumn;
  AWidth, AImage, I,
  L, F, Frm, T, ColWidth: Integer;
begin
  DragBitmap := TBitmap.Create;
  try
    AWidth := 0;
    if FColumns.Count = 0 then
      AWidth := GetNodeWidth(ANode)
    else begin
      for I := 0 to FColumns.Count-1 do
      begin
        ACol := TSCTreeColumn(FColumns[I]);
        if ACol.Visible then
          Inc(AWidth, GetColumnWidth(ACol));
      end;

      if (AWidth = 0) and (Images <> nil) then
      begin
        Inc(AWidth, Images.Width);

        AImage := ANode.StateIndex;
        if (StateImages <> nil) and (AImage > -1) and
          (AImage < StateImages.Count) then
          Inc(AWidth, StateImages.Width);
      end;
    end;

    Inc(AWidth, 2*(SC_DragIndent + 6));

    if AWidth > Screen.Width then
      AWidth := Screen.Width;

    R := Rect(0, 0, AWidth, GetNodeHeight(ANode));
    if FDragImageList = nil then
      FDragImageList := TImageList.CreateSize(R.Right, R.Bottom);

    Inc(R.Right, SC_DragIndent + 6);

    if Self.Images <> nil then
    begin
      Inc(R.Right, Images.Width);

      if IsShowStateImages and (FStateImages <> nil) then
      begin
        AImage := ANode.StateIndex;

        if (AImage > -1) and (AImage < FStateImages.Count) then
          Inc(R.Right, FStateImages.Width);
      end;
    end;

    with DragBitmap do
    begin
      Width := R.Right - R.Left;
      Height := R.Bottom - R.Top;
    end;

    with DragBitmap.Canvas do
    begin
      Font.Assign(Self.Font);
      Brush.Color := GetFaceColor;

      FillRect(R);
    end;

    Inc(R.Left, SC_DragIndent + 6);

    if Images <> nil then
    begin
      if IsShowStateImages and (FStateImages <> nil) then
      begin
        AImage := ANode.StateIndex;

        if (AImage > -1) and (AImage < FStateImages.Count) then
        begin
          T := R.Top + (R.Bottom - R.Top - FStateImages.Height) div 2;
          FStateImages.Draw(DragBitmap.Canvas, R.Left, T, AImage, True);

          Inc(R.Left, FStateImages.Width);
        end;
      end;

      AImage := ANode.ImageIndex;
      if (AImage > -1) and (AImage < Images.Count) then
      begin
        T := R.Top + (R.Bottom - R.Top - Images.Height) div 2;
        Images.Draw(DragBitmap.Canvas, R.Left, T, AImage, True);
      end;

      Inc(R.Left, Images.Width);
    end;

    if FColumns.Count = 0 then
    begin
      AText := ANode.GetText;
      if AText <> '' then
      begin
        Inc(R.Left, 2);

        with DragBitmap.Canvas do
        begin
          Brush.Style := bsClear;

          DrawText(Handle, PChar(AText), Length(AText), R, DT_LEFT or
            DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or DT_EXPANDTABS or
            DT_END_ELLIPSIS);
        end;
      end;
    end else
    begin
      L := 0;

      F := DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or
        DT_EXPANDTABS or DT_END_ELLIPSIS;

      for I := 0 to FColumns.Count-1 do
      begin
        ACol := TSCTreeColumn(FColumns[I]);

        if ACol.Visible and (ACol.Width > 0) then
        begin
          ColWidth := GetColumnWidth(ACol);
          
          CellR := R;
          CellR.Left := L;
          CellR.Right := L + ColWidth;

          if CellR.Left < R.Left then
            CellR.Left := R.Left;

          Inc(L, ColWidth);

          if not IsRectEmpty(CellR) then
          begin
            AText := ANode.GetString(I);
            if AText <> '' then
            begin
              Inc(CellR.Left, 2);

              if ACol.Alignment = taLeftJustify then
                Frm := F or DT_LEFT
              else Frm := F or DT_RIGHT;

              with DragBitmap.Canvas do
              begin
                Brush.Style := bsClear;
                DrawText(Handle, PChar(AText), Length(AText),
                  CellR, Frm);
              end;
            end;
          end;
        end;
      end;
    end;

    FDragImageList.AddMasked(DragBitmap, GetFaceColor);
  finally
    DragBitmap.Free;
  end;
end;

procedure TSCCustomTreeList.DrawCells(ACanvas: TCanvas; ANode: TSCTreeNode;
  ARect: TRect);
var
  AFont: TFont;
  AText: String;
  ACell: TSCTreeCell;
  ACol: TSCTreeColumn;
  R, R2, CellR, CR: TRect;
  AColor, AFontColor, AHotColor: TColor;
  I, F, Frm, T, L, UL, SR, ColWidth, Ph: Integer;
  Handled, CanFlash, ASelected, AFocused, AHot: Boolean;
begin
  if (FColumns.Count > 0) and (ANode <> nil) and not IsRectEmpty(ARect) then
  begin
    F := DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE;
    if IsDrawEndEllipsis then
      F := F or DT_END_ELLIPSIS;

    CanFlash := (sctfpUnderline in FFlashParts) and
      FFlashOn and CanFlashNode(ANode);

    CR := GetNodesRect;

    L := CR.Left;
    if IsShowIndicator then
      L := FIndicator;

    Dec(L, FHorizontalPos);

    Ph := 0;
    if IsShowPreview then
      Ph := GetPreviewHeight(ANode);

    for I := 0 to FColumns.Count-1 do
    begin
      if L >= CR.Right then
        Break;

      ACol := TSCTreeColumn(FColumns[I]);
      ColWidth := GetColumnWidth(ACol);

      if ColWidth < 1 then
        Continue;

      CellR := ARect;
      CellR.Left := L;
      CellR.Right := L + ColWidth;

      Dec(R.Bottom, Ph);

      if CellR.Left < ARect.Left then
        CellR.Left := ARect.Left;

      Inc(L, ColWidth);

      if IsRectEmpty(CellR) or (CellR.Right <= CR.Left) then
        Continue;

      R := CellR;
      SR := IntersectClipRect(ACanvas.Handle, R.Left, R.Top,
        R.Right, R.Bottom);
      try
        if SR <> NULLREGION then
        begin
          ACell := AsCell(ANode, ACol);
          
          AHot := IsHot(ACell);
          AFocused := IsFocused(ACell);
          ASelected := IsSelected(ANode);

          AColor := clNone;
          AHotColor := clNone;
          AFontColor := Self.Font.Color;

          GetCellColors(ACell, AColor, AFontColor, AHotColor);

          AFont := TFont.Create;
          try
            AFont.Assign(Self.Font);
            AFont.Color := AFontColor;

            ACanvas.Font.Assign(AFont);

            Handled := False;
            AText := ANode.GetString(I);

            if AHot and FHottrack.Underline and
              ((AHotColor <> clNone) or not ASelected) then
              AFont.Style := AFont.Style + [fsUnderline];

            if Assigned(FOnCustomDrawCell) then
              FOnCustomDrawCell(Self, ACell, ACanvas, R, ASelected,
                AFocused, AHot, AFont, AColor, AText, Handled);

            if Handled then
              Continue;

            DoDrawCell(ACell, ACanvas, R, ASelected, AFocused,
              AHot, AFont, AColor, AText, Handled);

            if Handled then
              Continue;

            ANode.Paint(ACol, ACanvas, R, ASelected, AFocused,
              AHot, AFont, AColor, AText, Handled);

            if AFont.Color = clNone then
              AFont.Color := GetDefaultForeColor;

            ACanvas.Font.Assign(AFont);
          finally
            AFont.Free;
          end;

          if not Handled and (AText <> '') then
          begin
            InflateRect(R, -2, 0);
            ACanvas.Brush.Style := bsClear;

            Frm := F;
            if ACol.Alignment = taLeftJustify then
              Frm := Frm or DT_LEFT
            else begin
              Dec(R.Right);
              Frm := Frm or DT_RIGHT;
            end;

            if AText <> '' then
            begin
              Windows.DrawText(ACanvas.Handle, PChar(AText),
                Length(AText), R, Frm);

              if ANode.Underline or CanFlash then
              begin
                R2 := R;

                Frm := Frm or DT_CALCRECT;
                Frm := Frm and not DT_VCENTER;

                Windows.DrawText(ACanvas.Handle, PChar(AText),
                  Length(AText), R2, Frm);

                OffsetRect(R2, -R2.Left, -R2.Top);

                T := R.Top + ((R.Bottom - R.Top - R2.Bottom) div 2);

                UL := R.Left;
                if ACol.Alignment = taRightJustify then
                  Inc(UL, (R.Right - R.Left) - R2.Right);

                OffsetRect(R2, UL, T);

                if ANode.Underline or CanFlash then
                  DrawUnderline(ACanvas, ACell, R2, CanFlash);
              end;
            end;
          end;
        end;
      finally
        SelectClipRgn(ACanvas.Handle, 0);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawNode(ACanvas: TCanvas; ANode: TSCTreeNode;
  ARect: TRect);
var
  AFont: TFont;
  AText: String;
  R, R2, CR: TRect;
  ACell: TSCTreeCell;
  I, F, T, SR: Integer;
  AChildIndicator, Handled, AHot,
  ASelected, AFocused, CanFlash: Boolean;
  AColor, AFontColor, AHotColor: TColor;
begin
  if (FColumns.Count = 0) and (ANode <> nil) and not IsRectEmpty(ARect) then
  begin
    ACell := AsCell(ANode, nil);

    AHot := IsHot(ACell);
    AFocused := IsFocused(ACell);
    ASelected := IsSelected(ANode);

    R := ARect;
    SR := IntersectClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
    try
      if SR <> NULLREGION then
      begin
        AColor := clNone;
        AHotColor := clNone;
        AFontColor := Self.Font.Color;

        GetCellColors(ACell, AColor, AFontColor, AHotColor);

        AFont := TFont.Create;
        try
          AFont.Assign(Self.Font);
          AFont.Color := AFontColor;

          ACanvas.Font.Assign(AFont);

          Handled := False;
          AText := ANode.Text;

          if AHot and FHottrack.Underline and
            ((AHotColor <> clNone) or not ASelected) then
            AFont.Style := AFont.Style + [fsUnderline];

          if Assigned(FOnCustomDrawCell) then
            FOnCustomDrawCell(Self, ACell, ACanvas, R, ASelected,
              AFocused, AHot, AFont, AColor, AText, Handled);

          if not Handled then
            DoDrawCell(ACell, ACanvas, R, ASelected, AFocused,
              AHot, AFont, AColor, AText, Handled);

          if not Handled then
            ANode.Paint(nil, ACanvas, R, ASelected, AFocused, AHot,
              AFont, AColor, AText, Handled);

          if Handled then
            Exit;

          if AFont.Color = clNone then
            AFont.Color := GetDefaultForeColor;

          ACanvas.Font.Assign(AFont);
        finally
          AFont.Free;
        end;

        CR := GetNodesRect;

        R.Right := R.Left + ACanvas.TextWidth(AText) + SC_TreeNodeHorzSpacing;

        if (R.Right > CR.Right) and IsDrawEndEllipsis then
          R.Right := CR.Right;

        if (IsRowStyle or IsShowPreview) and (R.Right < CR.Right) then
          R.Right := CR.Right;

        if (AColor <> clNone) and not IsOffice12Style then
          with ACanvas do
          begin
            Brush.Color := AColor;
            Brush.Style := bsSolid;

            FillRect(R);
          end;

        AChildIndicator := IsShowChildIndicator and (ANode.Count > 0) and
          (FColors.ChildIndicatorColor <> clNone);

        if (AText <> '') or AChildIndicator then
        begin
          InflateRect(R, -2, 0);
          ACanvas.Brush.Style := bsClear;

          F := DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE;
          if IsDrawEndEllipsis then
            F := F or DT_END_ELLIPSIS;

          if AText <> '' then
            DrawText(ACanvas.Handle, PChar(AText), Length(AText), R, F);

          CanFlash := (sctfpUnderline in FFlashParts) and
            FFlashOn and CanFlashNode(ANode);

          if ((AText <> '') and (ANode.Underline or CanFlash)) or AChildIndicator then
          begin
            R2 := R;

            F := F or DT_CALCRECT;
            F := F and not DT_VCENTER;

            if AText = '' then AText := 'A';
            DrawText(ACanvas.Handle, PChar(AText), Length(AText), R2, F);

            OffsetRect(R2, -R2.Left, -R2.Top);

            T := R.Top + ((R.Bottom - R.Top - R2.Bottom) div 2);
            OffsetRect(R2, R.Left, T);

            if ANode.Underline or CanFlash then
              DrawUnderline(ACanvas, AsCell(ANode, nil), R2, CanFlash);

            if AChildIndicator then
            begin
              Inc(R2.Right, 8);
              Inc(R2.Bottom, 2);

              if R2.Right > CR.Right then
                R2.Right := CR.Right;

              if R2.Bottom > ARect.Bottom then
                R2.Bottom := ARect.Bottom;

              with ACanvas do
              begin
                Brush.Style := bsClear;

                Pen.Mode  := pmCopy;
                Pen.Style := psSolid;
                Pen.Width := 1;
                Pen.Color := FColors.ChildIndicatorColor;
              end;

              for I := 0 to 4 do
                with ACanvas do
                begin
                  MoveTo(R2.Right, R2.Bottom - 4 + I);
                  LineTo(R2.Right - 4 + I, R2.Bottom);
                end;
            end;
          end;
        end;
      end;
    finally
      SelectClipRgn(ACanvas.Handle, 0);
    end;
  end;
end;

procedure TSCCustomTreeList.DrawNodeBack(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  AColor: TColor;
begin
  if (ANode <> nil) and not IsRectEmpty(ARect) then
  begin
    if IsOutlookStyle and (ANode.Count > 0) then
    begin
      AColor := FColors.OutlookColor;
      if AColor = clNone then
        AColor := clBtnFace;

      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AColor;

        FillRect(ARect);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawSelection(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  ACell: TSCTreeCell;
  ACol: TSCTreeColumn;
  SR, I, Ph, ColW: Integer;
  CR, R, R2, CellR: TRect;
  Handled, ADrawFocusRect,
  ADrawHighlightFrame, AHot,
  ASelected, AFocused, CellSelected: Boolean;
  AColor, AFontColor, AHotColor: TColor;
begin
  if not IsDesigning then
  begin
    ACell := AsCell(ANode, nil);
    if FColumns.Count > 0 then
      ACell := AsCell(ANode, FFocusedColumn);

    AHot := IsHot(ACell);
    AFocused := IsFocused(ACell);
    ASelected := IsSelected(ANode);

    if not CanMultiSelect then
    begin
      AFocused := AFocused or ASelected;
      ASelected := False;
    end;

    if AFocused or ASelected or AHot then
    begin
      R := ARect;
      CR := GetNodesRect;

      CellR := ARect;
      CellR.Right := CellR.Left;

      CellSelected := False;

      if FColumns.Count = 0 then
      begin
        if IsDrawEndEllipsis and (R.Right > CR.Right) then
          R.Right := CR.Right;

        if (IsRowStyle or IsShowPreview) and (R.Right < CR.Right) then
          R.Right := CR.Right;
      end else
      begin
        R.Right := CR.Left;
        if IsShowIndicator then
          Inc(R.Right, FIndicator);

        Dec(R.Right, FHorizontalPos);

        for I := 0 to FColumns.Count-1 do
        begin
          ACol := TSCTreeColumn(FColumns[I]);

          ColW := GetColumnWidth(ACol);
          Inc(R.Right, ColW);

          // Cell selection
          if ((AFocused and (ACol = FFocusedColumn)) or (AHot and (ACol = FHotColumn))) and
            not CellSelected and (CanCellSelect or not CanRowSelect) then
          begin
            CellR := R;
            CellSelected := True;

            CellR.Left := CellR.Right - ColW;
            if CellR.Left < ARect.Left then
              CellR.Left := ARect.Left;

            if IsShowPreview then
            begin
              Ph := GetPreviewHeight(ANode);

              if Ph > 0 then
              begin
                Dec(CellR.Bottom, Ph);
                if CellR.Bottom < CellR.Top then
                  CellR.Bottom := CellR.Top;
              end;
            end;

            if IsOffice12Style or not CanRowSelect then
            begin
              R := CellR;
              CellSelected := False;

              Break;
            end;
          end;
        end;
      end;

      if not IsRectEmpty(R) then
      begin
        if not CellSelected or IsOffice12Style then
        begin
          SR := IntersectClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
          try
            if SR <> NULLREGION then
            begin
              AColor := clNone;
              AHotColor := clNone;
              AFontColor := clNone;

              GetCellColors(ACell, AColor, AFontColor, AHotColor);

              Handled := False;

              if Assigned(FOnCustomDrawSelection) then
                FOnCustomDrawSelection(Self, ACell, ACanvas, R, ASelected,
                  AFocused, AHot, AColor, Handled);

              if not Handled then
                DoDrawSelection(ACell, ACanvas, R, ASelected, AFocused,
                  AHot, AColor, Handled);

              if Handled then
                Exit;

              ADrawFocusRect := AFocused and Self.HasFocus and
                not ((AHot and (AHotColor <> clNone)) or
                IsHideFocusRect or IsOffice12Style);

              ADrawHighlightFrame := (AFocused or ASelected) and
                Self.HasFocus and not (IsOffice12Style or
                (AHot and (AHotColor <> clNone)));

              if AColor <> clNone then
              begin
                with ACanvas do
                begin
                  Brush.Style := bsSolid;
                  Brush.Color := AColor;

                  FillRect(R);
                end;

                if IsOffice12Style then
                  DrawOffice12Face(ACanvas, R, AColor, True, True)
                else
                if ADrawHighlightFrame then
                begin
                  R2 := R;
                  scFrame3D(ACanvas, R2, GetBtnShadowOf(AColor),
                    GetBtnShadowOf(AColor), 1, 0);
                end;
              end;

              if ADrawFocusRect then
              begin
                if AColor = clNone then
                  AColor := Self.GetFaceColor;

                R2 := R;
                if ADrawHighlightFrame then
                  InflateRect(R2, -1, -1);

                scDrawFocusRect(ACanvas, R2, AColor);
              end;
            end;
          finally
            SelectClipRgn(ACanvas.Handle, 0);
          end;
        end else
        begin
          SR := IntersectClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
          try
            if SR <> NULLREGION then
            begin
              AColor := clNone;
              AHotColor := clNone;
              AFontColor := clNone;

              ACell := AsCell(ANode, nil);
              GetCellColors(ACell, AColor, AFontColor, AHotColor);

              Handled := False;

              if Assigned(FOnCustomDrawSelection) then
                FOnCustomDrawSelection(Self, ACell, ACanvas, R, ASelected,
                  AFocused, AHot, AColor, Handled);

              if not Handled then
                DoDrawSelection(ACell, ACanvas, R, ASelected, AFocused,
                  AHot, AColor, Handled);

              if not Handled and (AColor <> clNone) then
              begin
                with ACanvas do
                begin
                  Brush.Style := bsSolid;
                  Brush.Color := AColor;

                  FillRect(R);
                end;

                ADrawHighlightFrame := (AFocused or ASelected) and
                  Self.HasFocus and not (AHot and (AHotColor <> clNone));

                if ADrawHighlightFrame then
                begin
                  R2 := R;
                  scFrame3D(ACanvas, R2, GetBtnShadowOf(AColor),
                    GetBtnShadowOf(AColor), 1, 0);
                end;
              end;
            end;
          finally
            SelectClipRgn(ACanvas.Handle, 0);
          end;

          // Draw selected cell
          if not IsRectEmpty(CellR) then
          begin
            R := CellR;
            ACell := AsCell(ANode, FFocusedColumn);

            SR := IntersectClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
            try
              if SR <> NULLREGION then
              begin
                AColor := clNone;
                AHotColor := clNone;
                AFontColor := clNone;

                GetCellColors(ACell, AColor, AFontColor, AHotColor);

                Handled := False;

                if Assigned(FOnCustomDrawSelection) then
                  FOnCustomDrawSelection(Self, ACell, ACanvas, R, ASelected,
                    AFocused, AHot, AColor, Handled);

                if not Handled then
                  DoDrawSelection(ACell, ACanvas, R, ASelected, AFocused,
                    AHot, AColor, Handled);

                if Handled then
                  Exit;

                ADrawFocusRect := AFocused and Self.HasFocus and
                  not ((AHot and (AHotColor <> clNone)) or
                  IsHideFocusRect or IsOffice12Style);

                if (AColor <> clNone) and not IsOffice12Style then
                  with ACanvas do
                  begin
                    Brush.Style := bsSolid;
                    Brush.Color := AColor;

                    FillRect(R);
                  end;

                if ADrawFocusRect then
                begin
                  if AColor = clNone then
                    AColor := Self.GetFaceColor;

                  R2 := R;
                  scDrawFocusRect(ACanvas, R2, AColor);
                end;
              end;
            finally
              SelectClipRgn(ACanvas.Handle, 0);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawPreview(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  R, CR: TRect;
  AFont: TFont;
  AText: String;
  F, SR: Integer;
  Allow: Boolean;
  ACell: TSCTreeCell;
  AColor, AFontColor, AHotColor: TColor;
  Handled, ASelected, AFocused, AHot: Boolean;
begin
  if IsShowPreview and (ANode <> nil) and
    not IsRectEmpty(ARect) then
  begin
    Allow := ANode.Preview;
    if Assigned(FOnPreviewEvent) then
      FOnPreviewEvent(Self, ANode, Allow);

    if not Allow then
      Exit;

    ACell := AsCell(ANode, nil);

    AHot := IsHot(ACell);
    AFocused := IsFocused(ACell);
    ASelected := IsSelected(ANode);

    R := ARect;

    SR := IntersectClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
    try
      if SR <> NULLREGION then
      begin
        CR := GetNodesRect;

        AColor := clNone;
        AHotColor := clNone;
        AFontColor := Self.Font.Color;

        GetPreviewColors(ANode, AFontColor, AHotColor);

        AFont := TFont.Create;
        try
          AFont.Assign(Self.PreviewFont);
          AFont.Color := AFontColor;

          ACanvas.Font.Assign(AFont);

          Handled := False;
          AText := ANode.PreviewText;

          if AHot and FHottrack.Underline and
            ((AHotColor <> clNone) or not ASelected) then
            AFont.Style := AFont.Style + [fsUnderline];

          if Assigned(FOnCustomDrawPreview) then
            FOnCustomDrawPreview(Self, ANode, ACanvas, R, ASelected,
              AFocused, AHot, AFont, AColor, AText, Handled);

          if not Handled then
            DoDrawPreview(ANode, ACanvas, R, ASelected,
              AFocused, AHot, AFont, AColor, AText, Handled);

          if not Handled then
            ANode.PaintPreview(ACanvas, R, ASelected, AFocused, AHot,
              AFont, AColor, AText, Handled);

          if Handled then
            Exit;

          if AFont.Color = clNone then
            AFont.Color := GetDefaultForeColor;

          ACanvas.Font.Assign(AFont);
        finally
          AFont.Free;
        end;

        if R.Right > CR.Right then
          R.Right := CR.Right;

        if (FColumns.Count = 0) and
          IsRowStyle and (R.Right < CR.Right) then
          R.Right := CR.Right;

        if (AColor <> clNone) and not (IsOffice12Style and
          (ASelected or AFocused)) then
          with ACanvas do
          begin
            Brush.Color := AColor;
            Brush.Style := bsSolid;

            FillRect(R);
          end;

        if AText <> '' then
        begin
          InflateRect(R, -2, 0);
          ACanvas.Brush.Style := bsClear;

          F := DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or
            DT_END_ELLIPSIS;

          if FPreviewAlignment = taLeftJustify then
            F := F or DT_LEFT
          else F := F or DT_RIGHT;

          DrawText(ACanvas.Handle, PChar(AText), Length(AText), R, F);
        end;
      end;
    finally
      SelectClipRgn(ACanvas.Handle, 0);
    end;
  end;
end;

procedure TSCCustomTreeList.ShowDragImages;
begin
  Dec(FHideDragImagesLock);
  
  if FHideDragImagesLock = 0 then
  begin
    if State = sctlsColumnSizing then
      DrawColumnSizingLine
    else
    if State = sctlsRowSizing then
      DrawRowSizingLine
    else
    if State = sctlsColumnDragging then
      DrawDragArrows(False);

    if (FDragImageList <> nil) and FDragImageList.Dragging then
      FDragImageList.ShowDragImage;

    if (FDragObject <> nil) then
      FDragObject.ShowDragImage;
  end;
end;

procedure TSCCustomTreeList.HideDragImages;
begin
  if FHideDragImagesLock = 0 then
  begin
    if State = sctlsColumnSizing then
      DrawColumnSizingLine
    else
    if State = sctlsRowSizing then
      DrawRowSizingLine;

    if (FDragImageList <> nil) and FDragImageList.Dragging then
      FDragImageList.HideDragImage;

    if State = sctlsColumnDragging then
      DrawDragArrows(False);

    if (FDragObject <> nil) then
      FDragObject.HideDragImage;
  end;

  Inc(FHideDragImagesLock);
end;

procedure TSCCustomTreeList.DrawRowSizingLine;
var
  R, ClientR: TRect;
  AMin, APrevSizing, AHeight: Integer;
begin
  APrevSizing := FPrevSizingPos;
  FPrevSizingPos := FSizingPos;

  ClientR := GetNodesRect;

  if (APrevSizing > -1) and (APrevSizing > ClientR.Top) and
    (APrevSizing < ClientR.Bottom) then
    with Canvas do
    begin
      Brush.Style := bsClear;

      Pen.Color := clBlack;
      Pen.Style := psSolid;
      Pen.Mode  := pmNotXor;

      MoveTo(ClientR.Left, APrevSizing);
      LineTo(ClientR.Right, APrevSizing);
    end;

  if (FState = sctlsRowSizing) and (FSizingNode <> nil) then
  begin
    if FSizingPos < FSizingStartPos then
    begin
      AHeight := GetNodeHeight(FSizingNode);
      if AHeight < 0 then AHeight := 0;

      Inc(AHeight, FSizingPos - FSizingStartPos);

      AMin := GetMinNodeHeight(FSizingNode);

      if AHeight < AMin then
      begin
        R := GetNodeRect(FSizingNode, False);

        FSizingPos := R.Top + AMin;
        FPrevSizingPos := FSizingPos;
      end;
    end;

    with Canvas do
    begin
      Brush.Style := bsClear;

      Pen.Color := clBlack;
      Pen.Style := psSolid;
      Pen.Mode  := pmNotXor;

      MoveTo(ClientR.Left, FSizingPos);
      LineTo(ClientR.Right, FSizingPos);
    end;
  end;
end;

procedure TSCCustomTreeList.DrawDragArrows(HideDrag: Boolean);
var
  DC: HDC;
  R: TRect;
  W, H: Integer;
  AHandle: THandle;
begin
  if FArrowsBitmap <> nil then
  begin
    R := GetArrowsRect(FArrowsPos);

    if not IsRectEmpty(R) then
    begin
      W := R.Right - R.Left;
      H := R.Right - R.Left;

      if HideDrag and (FDragImageList <> nil) and FDragImageList.Dragging then
        FDragImageList.HideDragImage;

      if HideDrag then
        StoreArrowsBack(FArrowsPos, False);

      DC := GetDC(0);
      try
        AHandle := FArrowsBitmap.Canvas.Handle;

        BitBlt(AHandle, 0, 0, W, H, DC, R.Left, R.Top, SRCCOPY);
        DrawDragOverArrows(FArrowsBitmap.Canvas, Point(W div 2, H div 2));

        BitBlt(DC, R.Left, R.Top, W, H, AHandle, 0, 0, SRCCOPY);
      finally
        ReleaseDC(0, DC);
      end;

      if HideDrag and (FDragImageList <> nil) and FDragImageList.Dragging then
        FDragImageList.ShowDragImage;
    end;
  end;
end;

procedure TSCCustomTreeList.BeginDragNode(ANode: TSCTreeNode);
begin
  DoBeginDragNode(ANode);
  if Assigned(FOnBeginDragNode) then
    FOnBeginDragNode(Self, ANode);
end;

procedure TSCCustomTreeList.SetDragObject(Value: TDragObject);
var
  APrevObject: TDragObject;
begin
  if FDragObject <> Value then
  begin
    APrevObject := FDragObject;
    FDragObject := Value;

    if (FDragObject = nil) and (APrevObject <> nil) then
      APrevObject.HideDragImage;

    if FFocusedNode <> nil then
      Invalidate;

    UpdateDragging;
    if (FDragObject = nil) and (APrevObject <> nil) then
      APrevObject.ShowDragImage;

    if FDragObject = nil then
      FDragExpandNode := nil;
  end;
end;

procedure TSCCustomTreeList.UpdateDragging;
begin
  UpdateWindow(Handle);
end;

procedure TSCCustomTreeList.UpdateFlashNode(ANode: TSCTreeNode;
  Parts: TSCTreeFlashParts);
var
  AParent: TSCTreeNode;
begin
  if ANode <> nil then
  begin
    if IsNodeVisible(ANode, True) then
      UpdateNode(ANode, False, sctupNode);

    if sctfpParent in Parts then
    begin
      AParent := ANode.Parent;
      while (AParent <> nil) and IsNodeVisible(AParent, True) do
      begin
        UpdateNode(AParent, False, sctupNode);
        AParent := AParent.Parent;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.SetState(Value: TSCTreeListState);
begin
  FState := Value;
end;

procedure TSCCustomTreeList.KillDragExpandTimer;
var
  Timer: Integer;
begin
  if FDragExpandTimer <> -1 then
  begin
    Timer := FDragExpandTimer;
    FDragExpandTimer := -1;

    if HandleAllocated then
      KillTimer(Self.Handle, Timer);
  end;
end;

procedure TSCCustomTreeList.KillDragScrollTimer;
var
  Timer: Integer;
begin
  if FDragScrollTimer <> -1 then
  begin
    Timer := FDragScrollTimer;
    FDragScrollTimer := -1;

    if HandleAllocated then
      KillTimer(Self.Handle, Timer);
  end;
end;

procedure TSCCustomTreeList.KillAllTimers;
begin
  KillHintTimer;
  KillClickTimer;
  KillFlashTimer;
  KillDragExpandTimer;
  KillDragScrollTimer;
end;

procedure TSCCustomTreeList.KillHintTimer;
var
  Timer: Integer;
begin
  if FHintTimer <> -1 then
  begin
    Timer := FHintTimer;
    FHintTimer := -1;

    if HandleAllocated then
      KillTimer(Self.Handle, Timer);
  end;
end;

function TSCCustomTreeList.IsLastNode(ANode: TSCTreeNode): Boolean;
begin
  Result := False;
  if (ANode <> nil) and (ANode.Owner = Self) then
    Result := ANode = GetAbsoluteNode(GetAbsoluteCount-1, True);
end;

function TSCCustomTreeList.IsTopVisibleNode(ANode: TSCTreeNode): Boolean;
begin
  Result := False;
  if (ANode <> nil) and (ANode.Owner = Self) then
    Result := ANode = GetTopVisibleNode;
end;

procedure TSCCustomTreeList.KillClickTimer;
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

procedure TSCCustomTreeList.InitiateClickTimer;
begin
  if HandleAllocated and (FClickTimer = -1) and CanAllowEditing  then
    FClickTimer := SetTimer(Self.Handle, SC_TreeClickTimerID,
      GetDoubleClickTime, nil);
end;

procedure TSCCustomTreeList.InitiateHintTimer;
begin
  if HandleAllocated and (FHintTimer = -1) then
    FHintTimer := SetTimer(Self.Handle, SC_TreeHintTimerID,
      Application.HintHidePause, nil);
end;

procedure TSCCustomTreeList.InitiateDragExpandTimer;
begin
  if HandleAllocated and (FDragExpandTimer = -1) then
    FDragExpandTimer := SetTimer(Self.Handle, SC_TreeDragExpandTimerID,
      FWaitForExpandTime, nil);
end;

procedure TSCCustomTreeList.InitiateDragScrollTimer(ADelay: Integer);
begin
  if HandleAllocated and (FDragScrollTimer = -1) then
    FDragScrollTimer := SetTimer(Self.Handle, SC_TreeDragScrollTimerID,
      ADelay, nil);
end;

procedure TSCCustomTreeList.UpdateLocked;
begin
  HideEditor;
  HideHintWindow;
  SetState(sctlsIdle);
  FNeedsArrangement := True;
end;

function TSCCustomTreeList.IsInspectorSharpStyle: Boolean;
begin
  Result := FPaintStyle = sctpsInspectorSharp;
end;

procedure TSCCustomTreeList.CMDrag(var Message: TCMDrag);
begin
  DragCursor := SC_DragCursors[FSelectionList.Count > 1,
    CanAutoDragMove and (GetAsyncKeyState(VK_CONTROL) < 0)];

  inherited;

  if (FState <> sctlsNodeDragging) and not Dragging then
    with Message, DragRec^ do
      case DragMessage of
        dmDragEnter:
          if Assigned(OnDragOver) then
            SetDragObject(TDragObject(Source));
        dmDragLeave, dmDragDrop:
          SetDragObject(nil);
      end;
end;

function TSCCustomTreeList.CanAutoDragMove: Boolean;
begin
  Result := sctboAutoDragMove in FOptionsBehaviour;
end;

procedure TSCCustomTreeList.CMCancelMode(var Message: TMessage);
begin
  if Assigned(FInplaceEditor) then
    TSCTreeListEdit(FInplaceEditor).WndProc(Message);
  inherited;
end;

procedure TSCCustomTreeList.WMIMEStartComp(var Message: TMessage);
begin
  inherited;
  ShowEditor;
end;

procedure TSCCustomTreeList.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  if Editing and FInplaceEditor.HandleAllocated and
    (Message.FocusedWnd = FInplaceEditor.Handle) then
    Exit;

  if FState = sctlsNodeDown then
    SetState(sctlsIdle);
end;

function TSCCustomTreeList.CanDragCollapse: Boolean;
begin
  Result := sctboDragCollapse in FOptionsBehaviour;
end;

procedure TSCCustomTreeList.SetWaitForExpandTime(Value: Integer);
begin
  if Value < 10 then Value := 10;
  FWaitForExpandTime := Value;
end;

procedure TSCCustomTreeList.UpdateNode(ANode: TSCTreeNode;
  Scrollbars: Boolean; Part: TSCTreeUpdatePart);
var
  CR, R: TRect;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    not (ANode.Deleting or IsDestroying or InUpdate) and
    ((Part <> sctupNode) or IsNodeVisible(ANode, True)) then
  begin
    if Scrollbars then
      UpdateScrollBars(True, True);

    R := GetNodeRect(ANode, False);
    CR := GetClientRect;

    R.Left := CR.Left;
    R.Right := CR.Right;

    if Part = sctupAbove then
      R.Top := CR.Top
    else
    if Part = sctupBelow then
      R.Bottom := CR.Bottom;

    if R.Top < CR.Top then
      R.Top := CR.Top;

    if R.Bottom > CR.Bottom then
      R.Bottom := CR.Bottom;

    if HandleAllocated and not IsRectEmpty(R) then
    begin
      if (R.Top <= CR.Top) and (R.Bottom >= CR.Bottom) then
      begin
        Invalidate;
        Exit;
      end;

      InvalidateRect(Self.Handle, @R, False);
    end;
  end;
end;

procedure TSCCustomTreeList.SetTransparent(Value: Boolean);
begin
  inherited SetTransparent(False);
end;

procedure TSCCustomTreeList.WMPaint(var Message: TWMPaint);
begin
  if Dragging and not DragScrolling then
  begin
    DoubleBuffered := False;
    try
      inherited;
    finally
      DoubleBuffered := True;
    end;
  end else
    inherited;
end;

procedure TSCCustomTreeList.WMRButtonDown(var Message: TWMLButtonDown);
begin
  KillClickTimer;
  inherited;
end;

procedure TSCCustomTreeList.DoGroupedNode(ANode: TSCTreeNode;
  var IsGroup: Boolean);
begin
  //
end;

function TSCCustomTreeList.IsParentNodeOf(ANode, AParent: TSCTreeNode): Boolean;
var
  P: TSCTreeNode;
begin
  Result := False;

  if (ANode <> nil) and (AParent <> nil) and (ANode.FOwner = Self) then
  begin
    P := ANode.Parent;
    while P <> nil do
    begin
      Result := P = AParent;
      if Result then
        Break;

      P := P.Parent;
    end;
  end;
end;

procedure TSCCustomTreeList.SetLookAndFeel(Value: TSCTreeLookAndFeel);
begin
  if FLookAndFeel <> Value then
  begin
    FLookAndFeel := Value;

    if HasAnyNode then
    begin
      CalculateRowWidth;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomTreeList.DoGetEditorClass(ACell: TSCTreeCell;
  var EditorClass: TSCTreeEditorClass);
begin
  //
end;

function TSCCustomTreeList.GetEditorClass(ACell: TSCTreeCell): TSCTreeEditorClass;
begin
  Result := FInplaceEditorClass;

  DoGetEditorClass(ACell, Result);
  if Assigned(FOnGetEditorClass) then
    FOnGetEditorClass(Self, ACell, Result);
end;

procedure TSCCustomTreeList.DoPrepareEditor(ACell: TSCTreeCell;
  var AAlignment: TAlignment; var ABorder: TSCControlBorder;
  var ABorderColor, AColor, AFontColor: TColor);
begin
  //
end;

function TSCCustomTreeList.GetTopParentNode(ANode: TSCTreeNode): TSCTreeNode;
var
  P: TSCTreeNode;
begin
  Result := ANode;
  if (ANode <> nil) and (ANode.FOwner = Self) then
  begin
    P := ANode.Parent;

    while P <> nil do
    begin
      Result := P;
      P := P.Parent;
    end;
  end;
end;

procedure TSCCustomTreeList.SetUnderlineStyle(Value: TSCTreeUnderlineStyle);
begin
  if FUnderlineStyle <> Value then
  begin
    FUnderlineStyle := Value;
    if HasAnyNode then
      Invalidate;
  end;
end;

procedure TSCCustomTreeList.DrawUnderline(ACanvas: TCanvas;
  ACell: TSCTreeCell; ARect: TRect; IsFlash: Boolean);
var
  R: TRect;
  B, Allow: Boolean;
  I, L, ACount: Integer;
  ASelected, AHot: Boolean;
  AColor, AHotColor: TColor;
begin
  if not IsRectEmpty(ARect) then
  begin
    Allow := True;
    if Assigned(FOnDrawUnderline) then
      FOnDrawUnderline(Self, ACell, Allow);

    if not Allow then
      Exit;
      
    AColor := FColors.UnderlineColor;
    if IsFlash then
      AColor := FColors.FlashTextColor
    else
    if ACell.Node <> nil then
    begin
      AHot := IsHot(ACell);
      ASelected := IsSelected(ACell.Node);

      if ASelected and (Self.HasFocus or Editing or not IsHideSelection) then
      begin
        AColor := FColors.HighlightTextColor;
        if not (Self.HasFocus or Editing) then
          AColor := FColors.HideSelectionTextColor;
      end;

      if AHot then
      begin
        AHotColor := clNone;
        if FHottrack.TextColor <> clNone then
          AHotColor := FHottrack.TextColor;

        if not ASelected and (AHotColor <> clNone) then
          AColor := AHotColor;
      end;
    end;

    if AColor = clNone then
      Exit;

    with ACanvas do
    begin
      Brush.Style := bsClear;

      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Width := 1;
      Pen.Color := AColor;
    end;

    R := ARect;
    case FUnderlineStyle of
      sctusDot:
      begin
        B := True;
        for I := R.Left to R.Right do
        begin
          if B then
            with ACanvas do
            begin
              MoveTo(I, R.Bottom);
              LineTo(I + 1, R.Bottom);
            end;

          B := not B;
        end;
      end;
      sctusDash:
      begin
        ACount := (R.Right - R.Left) div 5;
        if (R.Right - R.Left) mod 5 <> 0 then
          Inc(ACount);

        for I := 0 to ACount-1 do
        begin
          L := R.Left + I*5;

          with ACanvas do
          begin
            MoveTo(L, R.Bottom);
            LineTo(L + 3, R.Bottom);
          end;
        end;
      end;
      sctusSaw:
      begin
        ACount := ((R.Right - R.Left) div 3) - 1;
        if (R.Right - R.Left) mod 3 <> 0 then
          Inc(ACount);

        for I := 0 to ACount do
        begin
          L := R.Left + I*3;

          with ACanvas do
          begin
            MoveTo(L, R.Bottom - 1);
            LineTo(L + 3, R.Bottom + 2);

            if I < ACount then
              LineTo(L + 3, R.Bottom - 1);
          end;
        end;
      end;
      sctusSolid:
      begin
        with ACanvas do
        begin
          MoveTo(R.Left, R.Bottom);
          LineTo(R.Right + 2, R.Bottom);
        end;
      end;
      sctusTilda:
      begin
        ACount := (R.Right - R.Left) div 2;
        if (R.Right - R.Left) mod 2 <> 0 then
          Inc(ACount);

        B := True;
        for I := 0 to ACount do
        begin
          L := R.Left + I*2;

          if B then
            with ACanvas do
            begin
              MoveTo(L, R.Bottom - 1);
              LineTo(L + 2, R.Bottom + 1);
            end;

          if not B then
            with ACanvas do
            begin
              MoveTo(L, R.Bottom + 1);
              LineTo(L + 2, R.Bottom - 1);
            end;

          B := not B;
        end;
      end;
    end;
  end;
end;

function TSCCustomTreeList.IsGrouping: Boolean;
begin
  Result := sctvoGrouping in FOptionsView;
end;

procedure TSCCustomTreeList.InitiateFlashTimer;
begin
  if not Flashing then
  begin
    ResetFlash;
    Exit;
  end;

  if FFlashTimer = -1 then
  begin
    FFlashOn := not FFlashOn;
    FFlashTimer := SetTimer(Self.Handle, SC_TreeFlashTimerID,
      GetFlashTime, nil);

    UpdateFlashNode(FFlashNode, FFlashParts);
  end;
end;

procedure TSCCustomTreeList.KillFlashTimer;
var
  Timer: Integer;
begin
  if FFlashTimer <> -1 then
  begin
    Timer := FFlashTimer;
    FFlashTimer := -1;

    if HandleAllocated then
      KillTimer(Self.Handle, Timer);
  end;
end;

function TSCCustomTreeList.Flashing: Boolean;
var
  PassedTime, RemainingTime: Integer;
begin
  Result := HandleAllocated and not (Editing or Dragging) and
    (FFlashNode <> nil) and (FFlashStart > 0) and (FFlashPeriod > 0) and
    (FFlashOnTime > 0) and (FFlashParts <> []);

  if Result then
  begin
    PassedTime := Integer(GetTickCount) - Integer(FFlashStart);
    RemainingTime := Integer(FFlashPeriod) - PassedTime;

    Result := (RemainingTime > -1) and (FFlashOn or
      (RemainingTime >= Integer(FFlashOnTime)));
  end;
end;

procedure TSCCustomTreeList.FlashNode(ANode: TSCTreeNode;
  Parts: TSCTreeFlashParts; Period, OnTime, OffTime: DWord);
begin
  ResetFlash;

  if (Parts <> []) and not (Dragging or Editing) and
    (ANode <> nil) and (ANode.Owner = Self) then
  begin
    MakeNodeVisible(ANode, False);

    FFlashNode    := ANode;
    FFlashPeriod  := Period;
    FFlashOnTime  := OnTime;
    FFlashOffTime := OffTime;
    FFlashOn      := False;
    FFlashStart   := GetTickCount;
    FFlashParts   := Parts;

    InitiateFlashTimer;
    UpdateFlashNode(FFlashNode, FFlashParts);
  end;
end;

procedure TSCCustomTreeList.ResetFlash;
var
  ANode: TSCTreeNode;
  Parts: TSCTreeFlashParts;
begin
  KillFlashTimer;
  FFlashOn := False;
  FFlashStart := 0;

  Parts := FFlashParts;
  FFlashParts := [];

  ANode := FFlashNode;
  FFlashNode := nil;

  if ANode <> nil then
    UpdateFlashNode(ANode, Parts);
end;

function TSCCustomTreeList.GetFlashTime: Integer;
begin
  Result := 0;
  if Flashing then
  begin
    Result := FFlashOnTime;
    if not FFlashOn then Result := FFlashOffTime;
  end;
end;

procedure TSCCustomTreeList.SetOptionsBehaviour(Value: TSCTreeBehaviourOptions);
var
  I: Integer;
begin
  if FOptionsBehaviour <> Value then
  begin
    FOptionsBehaviour := Value;

    if not CanAllowSorting and (FColumns <> nil) then
      for I := 0 to FColumns.Count-1 do
        TSCTreeColumn(FColumns[I]).FSortDirection := sctsdNone;

    if not CanMultiSelect then
      ClearSelection;

    if not CanAllowEditing then
      HideEditor;

    if not IsShowNodeHints then
      HideHintWindow;

    for I := 0 to FColumns.Count-1 do
      TSCTreeColumn(FColumns[I]).SetScaledWidth(-1);

    if HasAnyNode or HasAnyColumn then
      Invalidate;
  end;
end;

function TSCCustomTreeList.GetButtonSize: Integer;
var
  NdHeight, LvIndent: Integer;
begin
  Result := 0;
  if IsShowButtons and (FButtons.Width <> 0) then
  begin
    if FButtons.Style = sctbsMac then
      Result := 10
    else begin
      Result := 9;
      if FButtons.Style <> sctbsDefault then
      begin
        Inc(Result, 2);
        if FButtons.Style = sctbs3D then
          Inc(Result);
      end;

      if FButtons.Width > Result then
      begin
        Result := FButtons.Width;

        NdHeight := GetNodeHeight;
        LvIndent := GetLevelIndent;

        if NdHeight < LvIndent then
        begin
          if Result > NdHeight then
            Result := NdHeight;
        end else
        if Result > LvIndent then
          Result := LvIndent;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawTreeLine(ACanvas: TCanvas;
  ANode: TSCTreeNode; VisibleList, AList: TList; ARect: TRect);
var
  CR, R: TRect;
  AColor: TColor;
  I, L, ALevel, NdIndent, AIndex,
  Index2, NdHeight, LvDist: Integer;
  AParent, Node2, APrev, ASibling: TSCTreeNode;
begin
  if HasAnyNode and (AList.IndexOf(ANode) = -1) then
  begin
    AList.Add(ANode);

    AColor := FColors.LineColor;
    if AColor <> clNone then
    begin
      CR := GetNodesRect;

      L := CR.Left;
      if IsShowIndicator then
        Inc(L, FIndicator);

      if ARect.Right > L then
      begin
        ALevel := GetNodeLevel(ANode);

        if ALevel > 0 then
        begin
          NdIndent := GetLevelIndent;

          NdHeight := GetNodeHeight(ANode);
          AIndex := GetAbsoluteIndex(ANode, True);

          R := ARect;
          R.Left := R.Right - NdIndent;

          DrawHorizontalLine(ACanvas, ANode, R);

          APrev := ANode.GetPrevSibling;
          if (APrev <> nil) or (AIndex = 0) then
            Inc(R.Top, NdHeight div 2);

          if (ANode.Parent <> nil) and (ANode.Parent.Count = 1) then
          begin
            R.Bottom := R.Top + (NdHeight div 2);
            DrawVerticalLine(ACanvas, ANode, R);
          end else
          begin
            ASibling := ANode.GetNextSibling;
            if ASibling <> nil then
            begin
              Index2 := GetAbsoluteIndex(ASibling, True);

              for I := AIndex + 1 to Index2 do
              begin
                Node2 := TSCTreeNode(FRealList[I]);
                NdHeight := GetNodeHeight(Node2);

                if I = Index2 then
                  Inc(R.Bottom, NdHeight div 2)
                else
                  Inc(R.Bottom, NdHeight);

                if R.Bottom >= CR.Bottom then
                  Break;
              end;

              if R.Bottom > CR.Bottom then
                R.Bottom := CR.Bottom;

              DrawVerticalLine(ACanvas, ANode, R);
            end;
          end;

          if (APrev <> nil) and (AList.IndexOf(APrev) = -1) and
            (VisibleList.IndexOf(ANode) > -1) and
            (VisibleList.IndexOf(APrev) = -1) then
          begin
            R := GetNodeRect(APrev, False);
            R.Left := ARect.Left;
            R.Right := ARect.Right;

            DrawTreeLine(ACanvas, APrev, VisibleList, AList, R);
          end;

          AParent := ANode.FParent;
          if (AParent <> nil) and (AList.IndexOf(AParent) = -1) and
            (VisibleList.IndexOf(AParent) = -1) then
          begin
            LvDist := ALevel - GetNodeLevel(AParent);

            R := GetNodeRect(AParent, False);

            R.Left := ARect.Left;
            R.Right := ARect.Right;
            OffsetRect(R, -NdIndent*LvDist, 0);

            DrawTreeLine(ACanvas, AParent, VisibleList, AList, R);
          end;
        end;
      end;
    end;
  end;
end;

// Draw grid lines if paint_style = sctpsDefault
procedure TSCCustomTreeList.DrawDefaultStyle(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  ACol: TSCTreeColumn;
  ASibling: TSCTreeNode;
  CR, R, R2, CellR: TRect;
  I, L, AImage, ColWidth: Integer;
begin
  if (FColors.GridLineColor <> clNone) and
    (IsDefaultStyle or IsOffice12Style) then
  begin
    CR := GetNodesRect;
    
    with ACanvas do
    begin
      Brush.Style := bsClear;

      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;
      Pen.Color := FColors.GridLineColor;
    end;

    if IsShowLineVertical then
    begin
      R := ARect;
      Dec(R.Left);
      R.Right := CR.Right;

      if IsShowLineHorizontal then
        with ACanvas do
        begin
          MoveTo(R.Left, R.Top);
          LineTo(R.Left, R.Bottom);
        end;

      if (FColumns.Count > 0) and (ANode <> nil) and not IsShowPreview then
      begin
        R2 := R;

        if IsShowCheckButtons and (ANode.ButtonType <> sctcbNone) then
          Inc(R2.Left, SC_TreeCheckButtonSize);

        if Self.Images <> nil then
        begin
          Inc(R2.Left, Images.Width);

          if IsShowStateImages and (FStateImages <> nil) then
          begin
            AImage := ANode.StateIndex;
            if (AImage > -1) and (AImage < FStateImages.Count) then
              Inc(R2.Left, FStateImages.Width);
          end;
        end;

        L := 0;
        if IsShowIndicator then
          Inc(L, FIndicator);

        Dec(L, FHorizontalPos);

        for I := 0 to FColumns.Count - 1 do
        begin
          ACol := TSCTreeColumn(FColumns[I]);

          if ACol.Visible and (ACol.Width > 0) then
          begin
            ColWidth := GetColumnWidth(ACol);

            CellR := R;
            CellR.Left := L;
            CellR.Right := L + ColWidth - 1;

            Inc(L, ColWidth);

            if CellR.Left < R.Left then
              CellR.Left := R.Left;

            if (CellR.Left < CellR.Right) and (CellR.Right > R2.Left) then
              with ACanvas, CellR do
              begin
                MoveTo(Right, Top);
                LineTo(Right, Bottom);
              end;
          end;
        end;
      end;
    end;

    if IsShowLineHorizontal then
    begin
      R := ARect;
      Dec(R.Left);
      R.Right := CR.Right;

      with ACanvas do
      begin
        MoveTo(R.Left, R.Bottom);
        LineTo(R.Right, R.Bottom);

        MoveTo(R.Left, R.Top);
        LineTo(R.Right, R.Top);
      end;

      ASibling := ANode.GetPrevSibling;
      if (ASibling <> nil) and ASibling.Expanded then
        with ACanvas do
        begin
          MoveTo(R.Left, R.Top);
          LineTo(R.Right, R.Top);
        end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawOffice12Style(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  ACol: TSCTreeColumn;
  ASibling: TSCTreeNode;
  CR, R, R2, CellR: TRect;
  I, L, AImage, ColWidth: Integer;
begin
  if IsOffice12Style and (FColors.GridLineColor <> clNone) then
  begin
    CR := GetNodesRect;
    
    with ACanvas do
    begin
      Brush.Style := bsClear;

      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;
      Pen.Color := FColors.GridLineColor;
    end;

    if IsShowLineVertical then
    begin
      R := ARect;
      Dec(R.Left);
      R.Right := CR.Right;

      if IsShowLineHorizontal then
        with ACanvas do
        begin
          MoveTo(R.Left, R.Top);
          LineTo(R.Left, R.Bottom);
        end;

      if (FColumns.Count > 0) and (ANode <> nil) and not IsShowPreview then
      begin
        R2 := R;

        if IsShowCheckButtons and (ANode.ButtonType <> sctcbNone) then
          Inc(R2.Left, SC_TreeCheckButtonSize);

        if Self.Images <> nil then
        begin
          Inc(R2.Left, Images.Width);

          if IsShowStateImages and (FStateImages <> nil) then
          begin
            AImage := ANode.StateIndex;
            if (AImage > -1) and (AImage < FStateImages.Count) then
              Inc(R2.Left, FStateImages.Width);
          end;
        end;

        L := 0;
        if IsShowIndicator then
          Inc(L, FIndicator);

        Dec(L, FHorizontalPos);

        for I := 0 to FColumns.Count - 1 do
        begin
          ACol := TSCTreeColumn(FColumns[I]);

          if ACol.Visible and (ACol.Width > 0) then
          begin
            ColWidth := GetColumnWidth(ACol);

            CellR := R;
            CellR.Left := L;
            CellR.Right := L + ColWidth - 1;

            Inc(L, ColWidth);

            if CellR.Left < R.Left then
              CellR.Left := R.Left;

            if (CellR.Left < CellR.Right) and (CellR.Right > R2.Left) then
              with ACanvas, CellR do
              begin
                MoveTo(Right, Top);
                LineTo(Right, Bottom);
              end;
          end;
        end;
      end;
    end;

    if IsShowLineHorizontal then
    begin
      R := ARect;
      Dec(R.Left);
      R.Right := CR.Right;

      with ACanvas do
      begin
        MoveTo(R.Left, R.Bottom);
        LineTo(R.Right, R.Bottom);

        MoveTo(R.Left, R.Top);
        LineTo(R.Right, R.Top);
      end;

      ASibling := ANode.GetPrevSibling;
      if (ASibling <> nil) and ASibling.Expanded then
        with ACanvas do
        begin
          MoveTo(R.Left, R.Top);
          LineTo(R.Right, R.Top);
        end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawInspectorNetStyle(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  AColor: TColor;
  ASibling: TSCTreeNode;
  CR, R, R2, CellR: TRect;
  ACol, LastCol: TSCTreeColumn;
  ALevel, Level2, AImage,
  LvDist, LvIndent, I, L, ColWidth: Integer;
begin
  // Draw grid lines if paint_style = sctpsInspectorNet
  if IsInspectorNetStyle then
  begin
    AColor := FColors.GridLineColor;
    if AColor = clNone then
      AColor := clBtnShadow;

    with ACanvas do
    begin
      Brush.Style := bsClear;

      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;
      Pen.Color := AColor;
    end;

    CR := GetNodesRect;
    ALevel := GetNodeLevel(ANode);
    LvIndent := GetLevelIndent;

    if IsShowLineVertical and not IsShowPreview and
      (FColumns.Count > 0) and (ANode <> nil) then
    begin
      R := ARect;
      Dec(R.Left);
      R.Right := CR.Right;

      LastCol := LastVisibleColumn;
      ASibling := ANode.GetNextVisible;

      if LastCol <> nil then
      begin
        R2 := R;

        if IsShowCheckButtons and (ANode.ButtonType <> sctcbNone) then
          Inc(R2.Left, SC_TreeCheckButtonSize);

        if Self.Images <> nil then
        begin
          Inc(R2.Left, Images.Width);

          if IsShowStateImages and (FStateImages <> nil) then
          begin
            AImage := ANode.StateIndex;
            if (AImage > -1) and (AImage < FStateImages.Count) then
              Inc(R2.Left, FStateImages.Width);
          end;
        end;

        L := 0;
        if IsShowIndicator then
          Inc(L, FIndicator);

        Dec(L, FHorizontalPos);

        for I := 0 to FColumns.Count - 1 do
        begin
          ACol := TSCTreeColumn(FColumns[I]);

          if ACol = LastCol then
            Break;

          if ACol.Visible and (ACol.Width > 0) then
          begin
            ColWidth := GetColumnWidth(ACol);

            CellR := R;
            CellR.Left := L;
            CellR.Right := L + ColWidth - 1;

            Inc(L, ColWidth);

            if CellR.Left < R.Left then
              CellR.Left := R.Left;

            if (CellR.Left < CellR.Right) and (CellR.Right > R2.Left) then
            begin
              with ACanvas, CellR do
              begin
                MoveTo(Right, Top);
                LineTo(Right, Bottom);
              end;

              if ASibling = nil then
                with ACanvas do
                begin
                  MoveTo(CellR.Right, CellR.Bottom);
                  LineTo(CellR.Right, CR.Bottom);
                end;
            end;
          end;
        end;
      end;
    end;

    R := ARect;
    Dec(R.Left);
    R.Right := R.Left + LvIndent;

    // previous visible
    ASibling := ANode.GetPrevVisible;

    if ASibling <> nil then
    begin
      Level2 := GetNodeLevel(ASibling);

      if Level2 <> ALevel then
      begin
        LvDist := ALevel - Level2;

        if Level2 < ALevel then { \ }
        begin
          with ACanvas do
          begin
            MoveTo(R.Left - 2, R.Top);
            LineTo(R.Left, R.Top + 2);

            MoveTo(R.Left - 2, R.Top);
            LineTo(R.Left - LvDist*LvIndent + 2, R.Top);
          end;
        end else { / }
        begin
          with ACanvas do
          begin
            MoveTo(R.Left + 2, R.Top);
            LineTo(R.Left, R.Top + 2);

            MoveTo(R.Left + 2, R.Top);
            LineTo(R.Left + Abs(LvDist*LvIndent) - 2, R.Top);
          end;
        end;

        Inc(R.Top, 2);
      end;
    end;

    // next visible
    ASibling := ANode.GetNextVisible;

    if ASibling = nil then
      R.Bottom := CR.Bottom
    else begin
      Level2 := GetNodeLevel(ASibling);

      if Level2 <> ALevel then
      begin
        LvDist := ALevel - Level2;
                  
        if Level2 < ALevel then { / }
        begin
          with ACanvas do
          begin
            MoveTo(R.Left, R.Bottom - 2);
            LineTo(R.Left - 2, R.Bottom);
            LineTo(R.Left - LvDist*LvIndent + 2, R.Bottom);
          end;
        end else { \ }
        begin
          with ACanvas do
          begin
            MoveTo(R.Left, R.Bottom - 2);
            LineTo(R.Left + 2, R.Bottom);
            LineTo(R.Left + Abs(LvDist*LvIndent) - 2, R.Bottom);
          end;
        end;

        Dec(R.Bottom, 2);
      end;
    end;

    with ACanvas do
    begin
      MoveTo(R.Left, R.Top);
      LineTo(R.Left, R.Bottom);
    end;
  end;
end;

// Draw grid lines if paint_style = sctpsInspectorSharp
procedure TSCCustomTreeList.DrawInspectorSharpStyle(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  AColor: TColor;
  CR, R, R2, CellR: TRect;
  ACol, LastCol: TSCTreeColumn;
  I, L, AImage, ALevel,
  LvIndent, ColWidth: Integer;
begin
  if HasAnyNode and IsInspectorSharpStyle then
  begin
    AColor := FColors.GridLineColor;
    if AColor = clNone then
      AColor := clBtnFace;

    with ACanvas do
    begin
      Brush.Style := bsClear;

      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;
      Pen.Color := AColor;
    end;

    CR := GetNodesRect;
    ALevel := GetNodeLevel(ANode);
    LvIndent := GetLevelIndent;

    if IsShowLineVertical and not IsShowPreview and
      (FColumns.Count > 0) and (ANode <> nil) then
    begin
      R := ARect;
      Dec(R.Left);
      R.Right := CR.Right;

      LastCol := LastVisibleColumn;

      if LastCol <> nil then
      begin
        R2 := R;

        if IsShowCheckButtons and (ANode.ButtonType <> sctcbNone) then
          Inc(R2.Left, SC_TreeCheckButtonSize);

        if Self.Images <> nil then
        begin
          Inc(R2.Left, Images.Width);

          if IsShowStateImages and (FStateImages <> nil) then
          begin
            AImage := ANode.StateIndex;
            if (AImage > -1) and (AImage < FStateImages.Count) then
              Inc(R2.Left, FStateImages.Width);
          end;
        end;

        L := 0;
        if IsShowIndicator then
          Inc(L, FIndicator);

        Dec(L, FHorizontalPos);

        for I := 0 to FColumns.Count - 1 do
        begin
          ACol := TSCTreeColumn(FColumns[I]);

          if ACol = LastCol then
            Break;

          if ACol.Visible and (ACol.Width > 0) then
          begin
            ColWidth := GetColumnWidth(ACol);
            
            CellR := R;
            CellR.Left := L;
            CellR.Right := L + ColWidth - 1;

            Inc(L, ColWidth);

            if CellR.Left < R.Left then
              CellR.Left := R.Left;

            if (CellR.Left < CellR.Right) and (CellR.Right > R2.Left) then
              with ACanvas, CellR do
              begin
                MoveTo(Right, Top);
                LineTo(Right, Bottom);
              end;
          end;
        end;
      end;
    end;

    if IsShowRoot then
    begin
      R := ARect;
      Dec(R.Left, 1 + (ALevel - 1)*LvIndent);

      // if is the last item in tree
      if IsLastNode(ANode) then
        R.Bottom := CR.Bottom;

      with ACanvas do
      begin
        MoveTo(R.Left, R.Top);
        LineTo(R.Left, R.Bottom);
      end;
    end;

    R := ARect;
    R.Right := CR.Right;

    if IsShowRoot then
      Dec(R.Left, LvIndent*(ALevel - 1));

    if HasAnyNode and (ANode <> FRealList[0]) then
      with ACanvas do
      begin
        MoveTo(R.Left, R.Top);
        LineTo(R.Right, R.Top);
      end;

    with ACanvas do
    begin
      MoveTo(R.Left, R.Bottom);
      LineTo(R.Right, R.Bottom);
    end;
  end;
end;

// Draw grid lines if paint_style = sctpsInspector
procedure TSCCustomTreeList.DrawInspectorStyle(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  B: Boolean;
  AColor: TColor;
  CR, R, R2, CellR: TRect;
  ACol, LastCol: TSCTreeColumn;
  I, L, AImage, ColWidth: Integer;
begin
  if IsInspectorStyle then
  begin
    CR := GetNodesRect;
    Dec(ARect.Bottom);
    
    AColor := FColors.GridLineColor;
    if AColor = clNone then
      AColor := clBtnShadow;

    with ACanvas do
    begin
      Brush.Style := bsClear;

      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;
      Pen.Color := AColor;
    end;

    R := ARect;
    R.Left := CR.Left;
    R.Right := CR.Right;

    if IsShowIndicator then
      Inc(R.Left, FIndicator);
      
    B := True;
    for I := R.Left to R.Right do
    begin
      if B then
        with ACanvas do
        begin
          MoveTo(I, R.Bottom);
          LineTo(I + 1, R.Bottom);
        end;

      B := not B;
    end;

    if IsShowLineVertical and not IsShowPreview and
      (FColumns.Count > 0) and (ANode <> nil) then
    begin
      R := ARect;
      Dec(R.Left);
      R.Right := CR.Right;

      LastCol := LastVisibleColumn;

      if LastCol <> nil then
      begin
        R2 := R;

        if IsShowCheckButtons and (ANode.ButtonType <> sctcbNone) then
          Inc(R2.Left, SC_TreeCheckButtonSize);

        if Self.Images <> nil then
        begin
          Inc(R2.Left, Images.Width);

          if IsShowStateImages and (FStateImages <> nil) then
          begin
            AImage := ANode.StateIndex;
            if (AImage > -1) and (AImage < FStateImages.Count) then
              Inc(R2.Left, FStateImages.Width);
          end;
        end;

        L := 0;
        if IsShowIndicator then
          Inc(L, FIndicator);

        Dec(L, FHorizontalPos);

        for I := 0 to FColumns.Count - 1 do
        begin
          ACol := TSCTreeColumn(FColumns[I]);

          if ACol = LastCol then
            Break;

          if ACol.Visible and (ACol.Width > 0) then
          begin
            ColWidth := GetColumnWidth(ACol);
            
            CellR := R;
            CellR.Left := L;
            CellR.Right := L + ColWidth - 1;

            Inc(L, ColWidth);

            if CellR.Left < R.Left then
              CellR.Left := R.Left;

            if (CellR.Left < CellR.Right) and (CellR.Right > R2.Left) then
              with ACanvas, CellR do
              begin
                MoveTo(Right, Top);
                LineTo(Right, Bottom);
              end;
          end;
        end;
      end;
    end;
  end;
end;

function TSCCustomTreeList.GetScrollCount: Integer;
var
  CR: TRect;
  ANode: TSCTreeNode;
  H, Count, AIndex: Integer;
begin
  Result := 0;
  if HandleAllocated and HasAnyNode and (FRealList.Count > 1) then
  begin
    CR := Self.GetNodesRect;
    H := CR.Bottom - CR.Top;

    if H > 0 then
    begin
      Count := 0;

      Result := FRealList.Count;
      AIndex := FRealList.Count-1;

      while AIndex > -1 do
      begin
        ANode := TSCTreeNode(FRealList[AIndex]);

        Inc(Count);
        Dec(Result);
        Dec(AIndex);

        Dec(H, GetNodeHeight(ANode));

        if H <= 0 then
        begin
          if (H < 0) and (Count > 1) then
            Inc(Result);

          Break;
        end;
      end;
    end;
  end;
end;

function TSCCustomTreeList.GetScrollPageCount: Integer;
var
  CR: TRect;
  AIndex, H: Integer;
  ANode: TSCTreeNode;
begin
  Result := 0;
  if HandleAllocated and HasAnyNode and (FRealList.Count > 1) then
  begin
    CR := Self.GetNodesRect;
    H := CR.Bottom - CR.Top;

    if H > 0 then
    begin
      AIndex := FRealList.Count-1;

      while AIndex > -1 do
      begin
        ANode := TSCTreeNode(FRealList[AIndex]);

        Inc(Result);
        Dec(AIndex);

        Dec(H, GetNodeHeight(ANode));

        if H <= 0 then
          Break;
      end;

      if Result > 0 then
        Dec(Result); 
    end;
  end;
end;

procedure TSCCustomTreeList.DrawHorizontalLine(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  B: Boolean;
  AColor: TColor;
  I, L, T: Integer;
begin
  if IsDefaultStyle or IsOffice12Style then
  begin
    AColor := FColors.LineColor;

    if AColor <> clNone then
    begin
      with ACanvas do
      begin
        Brush.Style := bsClear;

        Pen.Style := psSolid;
        Pen.Color := AColor;
        Pen.Width := 1;
        Pen.Mode := pmCopy;
      end;

      L := ARect.Left + ((ARect.Right - ARect.Left - FNodeIndent) div 2);
      T := ARect.Top + ((ARect.Bottom - ARect.Top) div 2);

      if FLineStyle = sctlsSolid then
      begin
        with ACanvas do
        begin
          MoveTo(L, T);
          LineTo(ARect.Right, T);
        end;
      end else
      begin
        B := True;
        for I := L + 1 to ARect.Right do
        begin
          if B then
            with ACanvas do
            begin
              MoveTo(I, T);
              LineTo(I + 1, T);
            end;

          B := not B;
        end;
      end;
    end;
  end;
end;

function TSCCustomTreeList.HasAnyNode: Boolean;
begin
  Result := (FRealList <> nil) and (FRealList.Count > 0);
end;

procedure TSCCustomTreeList.SetFlagImages(Value: TCustomImageList);
var
  OldImages: TCustomImageList;
begin
  OldImages := FFlagImages;
  
  if FFlagImages <> nil then
  begin
  {$IFDEF SC_DELPHI5_UP}
    FFlagImages.RemoveFreeNotification(Self);
  {$ENDIF}
    FFlagImages.UnRegisterChanges(FFlagChangeLink);
  end;

  FFlagImages := Value;
  if FFlagImages <> nil then
  begin
    FFlagImages.RegisterChanges(FFlagChangeLink);
    FFlagImages.FreeNotification(Self);
  end;

  if OldImages <> FFlagImages then
  begin
    Invalidate;
    FlagImageListChange(FFlagImages);
  end;
end;

function TSCCustomTreeList.IsShowFlagImages: Boolean;
begin
  Result := sctvoShowFlagImages in FOptionsView;
end;

function TSCCustomTreeList.IsShowChildIndicator: Boolean;
begin
  Result := sctvoShowChildIndicator in FOptionsView;
end;

function TSCCustomTreeList.FlashOn: Boolean;
begin
  Result := FFlashOn and Flashing;
end;

function TSCCustomTreeList.FlashingParts: TSCTreeFlashParts;
begin
  Result := FFlashParts;
end;

function TSCCustomTreeList.CanFlashNode(ANode: TSCTreeNode): Boolean;
begin
  Result := Flashing and
    ((FFlashNode = ANode) or ((sctfpParent in FFlashParts) and
    IsParentNodeOf(FFlashNode, ANode)));
end;

procedure TSCCustomTreeList.GetCellColors(ACell: TSCTreeCell;
  var ABackColor, AForeColor, AHotColor: TColor);
var
  AFocusedNode, AFocused,
  ASelected, AHot: Boolean;
begin
  ABackColor := clNone;
  AHotColor  := clNone;
  AForeColor := Self.Font.Color;

  if (ACell.Node <> nil) and (ACell.Node.Owner = Self) then
  begin
    AHot := IsHot(ACell);
    AFocused := IsFocused(ACell);
    ASelected := IsSelected(ACell.Node);

    AFocusedNode := (FColumns.Count > 0) and (ACell.Column = nil) and
      (CanCellSelect and CanRowSelect) and IsFocusedNode(ACell.Node);

    if IsOutlookStyle and (ACell.Node.Count > 0) then
    begin
      ABackColor := FColors.OutlookColor;
      AForeColor := FColors.OutlookTextColor;

      if ABackColor = clNone then
        ABackColor := clBtnFace;

      if AForeColor = clNone then
        AForeColor := clBtnText;
    end;

    if IsGrouping and GroupedNode(ACell.Node) then
    begin
      ABackColor := clNone;
      AForeColor := FColors.GroupTextColor;

      if AForeColor = clNone then
        AForeColor := clBtnText;
    end;

    if ACell.Node.Color <> clNone then
      AForeColor := ACell.Node.Color;

    if (AFocused or ASelected or AFocusedNode) and
      (Self.HasFocus or Editing or not IsHideSelection) then
    begin
      ABackColor := FColors.HighlightColor;
      AForeColor := FColors.HighlightTextColor;

      if (FColumns.Count > 0) and AFocused and
        (CanRowSelect and CanCellSelect) then
      begin
        ABackColor := FColors.CellFocusColor;
        AForeColor := FColors.CellFocusTextColor;

        if AForeColor = clNone then
          AForeColor := GetDefaultForeColor;

        if IsOffice12Style and (ABackColor = clNone) then
        begin
          ABackColor := FColors.HighlightColor;
          AForeColor := FColors.HighlightTextColor;
        end;
      end;

      if not (Self.HasFocus or Editing) then
      begin
        ABackColor := FColors.HideSelectionColor;
        AForeColor := FColors.HideSelectionTextColor;
      end;
    end;

    AHotColor := clNone;
    if AHot then
    begin
      if FHottrack.Color <> clNone then
      begin
        AHotColor := FHottrack.Color;
        ABackColor := AHotColor;
      end;

      if not (AFocused or ASelected) or (AHotColor <> clNone) and
        (FHottrack.TextColor <> clNone) then
        AForeColor := FHottrack.TextColor;
    end;

    if (sctfpText in FFlashParts) and FFlashOn and CanFlashNode(ACell.Node) then
    begin
      if FColors.FlashColor <> clNone then
        ABackColor := FColors.FlashColor;

      if FColors.FlashTextColor <> clNone then
        AForeColor := FColors.FlashTextColor;
    end;

    if (sctfpText in FFlashParts) and FFlashOn and CanFlashNode(ACell.Node) then
    begin
      if FColors.FlashColor <> clNone then
        ABackColor := FColors.FlashColor;

      if FColors.FlashTextColor <> clNone then
        AForeColor := FColors.FlashTextColor;
    end;
  end;

  if AForeColor = clNone then
    AForeColor := GetDefaultForeColor;
end;

procedure TSCCustomTreeList.GetPreviewColors(ANode: TSCTreeNode;
  var AForeColor, AHotColor: TColor);
var
  ACell: TSCTreeCell;
  AFocused, ASelected, AHot: Boolean;
begin
  AHotColor  := clNone;
  AForeColor := Self.PreviewFont.Color;

  if (ANode <> nil) and (ANode.Owner = Self) then
  begin
    ACell := AsCell(ANode, nil);
    
    AHot := IsHot(ACell);
    AFocused := IsFocused(ACell);
    ASelected := IsSelected(ACell.Node);

    if IsOutlookStyle and (ANode.Count > 0) then
    begin
      AForeColor := FColors.OutlookTextColor;

      if AForeColor = clNone then
        AForeColor := clBtnText;
    end;

    if IsGrouping and GroupedNode(ANode) then
    begin
      AForeColor := FColors.GroupTextColor;

      if AForeColor = clNone then
        AForeColor := clBtnText;
    end;

    if (AFocused or ASelected) and (Self.HasFocus or
      Editing or not IsHideSelection) then
    begin
      AForeColor := FColors.HighlightTextColor;

      if (FColumns.Count > 0) and AFocused and
        (CanRowSelect and CanCellSelect) then
      begin
        AForeColor := FColors.CellFocusTextColor;

        if AForeColor = clNone then
          AForeColor := GetDefaultForeColor;
      end;

      if not (Self.HasFocus or Editing) then
        AForeColor := FColors.HideSelectionTextColor;
    end;

    AHotColor := clNone;
    if AHot then
    begin
      if FHottrack.Color <> clNone then
        AHotColor := FHottrack.Color;

      if not (AFocused or ASelected) or (AHotColor <> clNone) and
        (FHottrack.TextColor <> clNone) then
        AForeColor := FHottrack.TextColor;
    end;

    if (sctfpText in FFlashParts) and FFlashOn and
      CanFlashNode(ANode) and (FColors.FlashTextColor <> clNone) then
      AForeColor := FColors.FlashTextColor;
  end;

  if AForeColor = clNone then
    AForeColor := GetDefaultForeColor;
end;

function TSCCustomTreeList.IsShowCheckButtons: Boolean;
begin
  Result := sctvoShowCheckButtons in FOptionsView;
end;

function TSCCustomTreeList.IsShowEmptyButtons: Boolean;
begin
  Result := sctvoShowEmptyButtons in FOptionsView;
end;

procedure TSCCustomTreeList.SetButtonState(ANode: TSCTreeNode;
  AState: TSCTreeCheckButtonState);
var
  I: Integer;
  AList: TList;
  Allow: Boolean;
  Child: TSCTreeNode;
begin
  if (ANode <> nil) and (ANode.FOwner = Self) and
    (AState <> ANode.ButtonState) then
  begin
    Allow := CanSetButtonState(ANode, AState);
    if Allow and Assigned(FOnButtonStateChanging) then
      FOnButtonStateChanging(Self, ANode, AState, Allow);

    ANode.VerifyButtonState(AState);

    if Allow and (AState <> ANode.ButtonState) then
    begin
      ANode.FButtonState := AState;
      UpdateNode(ANode, False, sctupNode);

      if (AState = sctcsChecked) and
        (ANode.ButtonType = sctcbRadioButton) then
      begin
        AList := FList;
        if ANode.Parent <> nil then
          AList := ANode.Parent.FList;

        if AList <> nil then
          for I := 0 to AList.Count-1 do
          begin
            Child := TSCTreeNode(AList[I]);
            if (Child <> ANode) and (Child.ButtonType = sctcbRadioButton) and
              (Child.ButtonState <> sctcsUnchecked) then
            begin
              Child.FButtonState := sctcsUnchecked;
              if IsNodeVisible(Child, True) then
                UpdateNode(Child, False, sctupNode);
            end;
          end;
      end;

      if Assigned(FOnButtonStateChanged) then
        FOnButtonStateChanged(Self, ANode);
    end;
  end;
end;

function TSCCustomTreeList.CanSetButtonState(ANode: TSCTreeNode;
  var AState: TSCTreeCheckButtonState): Boolean;
begin
  Result := True;
end;

procedure TSCCustomTreeList.SwitchState(AllowGrayed: Boolean;
  AType: TSCTreeCheckButton; var AState: TSCTreeCheckButtonState);
begin
  if AType = sctcbNone then
    Exit;

  case AState of
    sctcsChecked:
      if AType = sctcbCheckbox then
        AState := sctcsUnchecked;
    sctcsUnchecked:
      if AllowGrayed and (AType = sctcbCheckbox) then
        AState := sctcsGrayed else
        AState := sctcsChecked;
    sctcsGrayed:
      AState := sctcsChecked;
  end;
end;

procedure TSCCustomTreeList.DrawCheckButton(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect);
var
  Handled: Boolean;
  ABackColor, AFaceColor,
  AFrameColor, AForeColor,
  AHotColor, AFocusColor: TColor;
  AState: TSCTreeCheckButtonState;
begin
  if (ANode <> nil) and (ANode.ButtonType <> sctcbNone) and
    IsShowCheckButtons and not IsRectEmpty(ARect) then
  begin
    ABackColor := FColors.IndentColor;

    if IsOutlookStyle then
    begin
      ABackColor := clNone;
      if (ANode <> nil) and (ANode.Count > 0) then
      begin
        ABackColor := FColors.OutlookColor;
        if ABackColor = clNone then
          ABackColor := clBtnFace;
      end;

      Inc(ARect.Top);
    end;

    AState := sctcsUnchecked;
    if ANode <> nil then
      AState := ANode.ButtonState;

    AFaceColor  := clWindow;
    AFrameColor := clNone;
    AHotColor   := SC_HottrackColor;
    AFocusColor := SC_HighlightColor;
    AForeColor  := clWindowText;

    if AState = sctcsGrayed then
      AForeColor := clBtnShadow;

    Handled := False;

    if Assigned(FOnCustomDrawCheckButton) then
      FOnCustomDrawCheckButton(Self, ANode, ACanvas, ARect, ABackColor,
        AFaceColor, AFrameColor, AForeColor, AHotColor, AFocusColor,
        Handled);

    if not Handled then
      DoDrawCheckButton(ACanvas, ANode, ARect, ABackColor, AFaceColor,
        AFrameColor, AForeColor, AHotColor, AFocusColor, Handled);

    if Handled then
      Exit;

    if IsOutlookStyle and (ABackColor = clNone) and
      (ANode <> nil) and (ANode.Count > 0) then
    begin
      ABackColor := FColors.OutlookColor;
      if ABackColor = clNone then
        ABackColor := clBtnFace;
    end;

    if AFaceColor = clNone then
      AFaceColor := clWindow;

    if AFrameColor = clNone then
      AFrameColor := clBtnShadow;

    if AForeColor = clNone then
      AForeColor := clWindowText;

    if ABackColor <> clNone then
      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := ABackColor;

        FillRect(ARect);
      end;

    if ANode.ButtonType = sctcbCheckbox then
    begin
      case FCheckButtonStyle of
        sctcsDefault:
          DrawDefaultCheckbox(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor);
        sctcsDouble:
          DrawDoubleCheckbox(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor);
        sctcsFlat:
          DrawFlatCheckbox(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor);
        sctcsFlatEx:
          DrawFlatExCheckbox(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor);
        sctcsFlatFrame:
          DrawFlatFrameCheckbox(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor);
        sctcsMetal:
          DrawMetalCheckbox(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor);
        sctcsNew:
          DrawNewCheckbox(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor, AHotColor,
            AFocusColor);
      end;
    end else
    if ANode.ButtonType = sctcbRadioButton then
    begin
      case FCheckButtonStyle of
        sctcsDefault:
          DrawDefaultRadioButton(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor);
        sctcsDouble:
          DrawDoubleRadioButton(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor);
        sctcsFlat:
          DrawFlatRadioButton(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor);
        sctcsFlatEx:
          DrawFlatExRadioButton(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor);
        sctcsFlatFrame:
          DrawFlatFrameRadioButton(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor);
        sctcsMetal:
          DrawMetalRadioButton(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor);
        sctcsNew:
          DrawNewRadioButton(ACanvas, ANode, ARect, ABackColor,
            AFaceColor, AFrameColor, AForeColor, AHotColor,
            AFocusColor);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DoDrawCheckButton(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; var ABackColor, AFaceColor,
  AFrameColor, AForeColor, AHotColor, AFocusColor: TColor;
  var Handled: Boolean);
begin
  //
end;

procedure TSCCustomTreeList.ChildButtonTypeChanged(ANode: TSCTreeNode);
begin
  if ANode = FHintOldNode then
  begin
    FHintOldNode := nil;
    FHintOldColumn := nil;
  end;

  if (ANode <> nil) and not ANode.FDestroying and
    not (IsLoading or IsDestroying) and
    not InUpdate and ParentExpanded(ANode) then
  begin
    CalculateRowWidth;
    NodesChanged;

    if IsNodeVisible(ANode, True) then
    begin
      UpdateNode(ANode, False, sctupNode);

      if FHintNode = ANode then
      begin
        FHintOldNode := nil;
        FHintOldColumn := nil;
      end;

      UpdateHintWindow;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawDefaultCheckbox(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
var
  R: TRect;
  BtnSize: Integer;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbCheckbox) then
  begin
    BtnSize := SC_TreeCheckboxSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    if AFaceColor <> clNone then
      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AFaceColor;

        FillRect(R);
      end;

    DrawMarkCheckbox(ACanvas, ANode, R, ABackColor, AFaceColor,
      AFrameColor, AForeColor);

    if AFrameColor = clNone then
    begin
      scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
      scFrame3D(Canvas, R, cl3DDkShadow, clBtnFace, 1, 0);
    end else
    begin
      scFrame3D(Canvas, R, GetBtnShadowOf(AFrameColor),
        GetBtnHighlightOf(AFrameColor), 1, 0);
      scFrame3D(Canvas, R, Get3DDkShadowOf(AFrameColor),
        GetBtnFaceOf(AFrameColor), 1, 0);
    end;
  end;
end;

procedure TSCCustomTreeList.DrawDefaultRadioButton(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
var
  R, R2: TRect;
  I, J, BtnSize: Integer;
  TopColors: array[0..2] of TColor;
  BtmColors: array[0..2] of TColor;
  AState: TSCTreeCheckButtonState;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbRadioButton) then
  begin
    AState := sctcsUnchecked;
    if ANode <> nil then
    begin
      AState := ANode.ButtonState;
      if (AState = sctcsGrayed) and (not ANode.AllowGrayed or
        (ANode.ButtonType = sctcbRadioButton)) then
        AState := sctcsChecked;
    end;

    BtnSize := SC_TreeRadioButtonSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    if AFrameColor = clNone then
    begin
      TopColors[0] := clBtnShadow;
      TopColors[1] := cl3DDkShadow;
      TopColors[2] := clWindow;

      BtmColors[0] := clBtnHighlight;
      BtmColors[1] := clBtnFace;
      BtmColors[2] := clWindow;
    end else
    begin
      TopColors[0] := GetBtnShadowOf(AFrameColor);
      TopColors[1] := Get3DDkShadowOf(AFrameColor);
      TopColors[2] := GetBtnHighlightOf(AFrameColor);

      BtmColors[0] := GetBtnHighlightOf(AFrameColor);
      BtmColors[1] := GetBtnFaceOf(AFrameColor);
      BtmColors[2] := GetBtnHighlightOf(AFrameColor);
    end;

    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := AFaceColor;
      Brush.Color := AFaceColor;

      TopColors[High(TopColors)] := AFaceColor;
      BtmColors[High(BtmColors)] := AFaceColor;

      Ellipse(R.Left, R.Top, R.Right, R.Bottom);

      if (AState = sctcsChecked) and (AForeColor <> clNone) then
      begin
        Pen.Color := AForeColor;
        Brush.Color := AForeColor;

        R2 := R;
        InflateRect(R2, -4, -4);

        Ellipse(R2.Left, R2.Top, R2.Right, R2.Bottom);

        Pen.Color := AForeColor;
        Brush.Color := AForeColor;
      end;

      for I := 0 to 2 do
      begin
        R2 := R;
        InflateRect(R2, -I, -I);

        Pen.Color := TopColors[I];

        Dec(R2.Right);
        Dec(R2.Bottom);

        for J := 0 to 2 do
        begin
          Arc(R2.Left, R2.Top, R2.Right, R2.Bottom, R2.Right - 1,
            R2.Top, R2.Left, R2.Bottom - 1);

          Inc(R2.Right);
          Inc(R2.Bottom);
        end;
      end;

      for I := 0 to 2 do
      begin
        R2 := R;
        InflateRect(R2, -I, -I);

        Pen.Color := BtmColors[I];

        Inc(R2.Left);
        Inc(R2.Top);

        for J := 0 to 2 do
        begin
          Arc(R2.Left, R2.Top, R2.Right, R2.Bottom, R2.Left + 1,
            R2.Bottom, R2.Right, R2.Top + 1);

          Dec(R2.Left);
          Dec(R2.Top);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawDoubleCheckbox(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
var
  R: TRect;
  BtnSize: Integer;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbCheckbox) then
  begin
    BtnSize := SC_TreeCheckboxSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    if AFaceColor <> clNone then
      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AFaceColor;

        FillRect(R);
      end;

    DrawMarkCheckbox(ACanvas, ANode, R, ABackColor, AFaceColor,
      AFrameColor, AForeColor);

    if AFrameColor = clNone then
    begin
      scFrame3D(Canvas, R, clBtnShadow, clBtnShadow, 1, 0);
      scFrame3D(Canvas, R, clBtnShadow, clBtnShadow, 1, 0);
    end else
    begin
      scFrame3D(Canvas, R, GetBtnShadowOf(AFrameColor),
        GetBtnShadowOf(AFrameColor), 1, 0);
      scFrame3D(Canvas, R, GetBtnShadowOf(AFrameColor),
        GetBtnShadowOf(AFrameColor), 1, 0);
    end;
  end;
end;

procedure TSCCustomTreeList.DrawDoubleRadioButton(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
var
  R, R2: TRect;
  BtnSize: Integer;
  TopColors: array[0..1] of TColor;
  BtmColors: array[0..1] of TColor;
  AState: TSCTreeCheckButtonState;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbRadioButton) then
  begin
    AState := sctcsUnchecked;
    if ANode <> nil then
    begin
      AState := ANode.ButtonState;
      if (AState = sctcsGrayed) and not ANode.AllowGrayed then
        AState := sctcsChecked;
    end;

    BtnSize := SC_TreeRadioButtonSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    if AFrameColor = clNone then
    begin
      TopColors[0] := clBtnShadow;
      TopColors[1] := clWindow;

      BtmColors[0] := clBtnShadow;
      BtmColors[1] := clWindow;
    end else
    begin
      TopColors[0] := GetBtnShadowOf(AFrameColor);
      TopColors[1] := GetBtnHighlightOf(AFrameColor);

      BtmColors[0] := GetBtnShadowOf(AFrameColor);
      BtmColors[1] := GetBtnHighlightOf(AFrameColor);
    end;

    if AFrameColor <> clNone then
    begin
      TopColors[Low(TopColors)] := AFrameColor;
      BtmColors[Low(BtmColors)] := AFrameColor;
    end;

    TopColors[High(TopColors)] := AFaceColor;
    BtmColors[High(BtmColors)] := AFaceColor;

    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := AFaceColor;
      Brush.Color := AFaceColor;

      Ellipse(R.Left, R.Top, R.Right, R.Bottom);

      Brush.Style := bsClear;
      Pen.Color := AFrameColor;

      R2 := R;
      Dec(R2.Right);
      Dec(R2.Bottom);

      OffsetRect(R2, 1, 0);
      Ellipse(R2.Left, R2.Top, R2.Right, R2.Bottom);

      OffsetRect(R2, -1, 0);
      Ellipse(R2.Left, R2.Top, R2.Right, R2.Bottom);

      OffsetRect(R2, 0, 1);
      Ellipse(R2.Left, R2.Top, R2.Right, R2.Bottom);

      OffsetRect(R2, 1, 0);
      Ellipse(R2.Left, R2.Top, R2.Right, R2.Bottom);

      Pen.Color := AFaceColor;

      R2 := R;
      InflateRect(R2, -4, -4);

      OffsetRect(R2, -2, 0);
      Rectangle(R2.Left, R2.Top, R2.Right, R2.Bottom);

      OffsetRect(R2, 4, 0);
      Rectangle(R2.Left, R2.Top, R2.Right, R2.Bottom);

      OffsetRect(R2, -2, -2);
      Rectangle(R2.Left, R2.Top, R2.Right, R2.Bottom);

      OffsetRect(R2, 0, 4);
      Rectangle(R2.Left, R2.Top, R2.Right, R2.Bottom);

      if (AState = sctcsChecked) and (AForeColor <> clNone) then
      begin
        Pen.Color := AForeColor;
        Brush.Color := AForeColor;

        R2 := R;
        InflateRect(R2, -4, -4);

        Ellipse(R2.Left, R2.Top, R2.Right, R2.Bottom);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawFlatCheckbox(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
var
  R: TRect;
  BtnSize: Integer;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbCheckbox) then
  begin
    BtnSize := SC_TreeCheckboxSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    if AFaceColor <> clNone then
      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AFaceColor;

        FillRect(R);
      end;

    DrawMarkCheckbox(ACanvas, ANode, R, ABackColor, AFaceColor,
      AFrameColor, AForeColor);
  end;
end;

procedure TSCCustomTreeList.DrawFlatExCheckbox(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
var
  R: TRect;
  BtnSize: Integer;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbCheckbox) then
  begin
    BtnSize := SC_TreeCheckboxSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    if AFaceColor <> clNone then
      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AFaceColor;

        FillRect(R);
      end;

    DrawMarkCheckbox(ACanvas, ANode, R, ABackColor, AFaceColor,
      AFrameColor, AForeColor);

    if AFrameColor = clNone then
      scFrame3D(Canvas, R, clBtnShadow, clBtnShadow, 1, 0)
    else
      scFrame3D(Canvas, R, GetBtnShadowOf(AFrameColor),
        GetBtnShadowOf(AFrameColor), 1, 0);
  end;
end;

procedure TSCCustomTreeList.DrawFlatExRadioButton(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
var
  R, R2: TRect;
  I, J, BtnSize: Integer;
  TopColors: array[0..1] of TColor;
  BtmColors: array[0..1] of TColor;
  AState: TSCTreeCheckButtonState;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbRadioButton) then
  begin
    AState := sctcsUnchecked;
    if ANode <> nil then
    begin
      AState := ANode.ButtonState;
      if (AState = sctcsGrayed) and not ANode.AllowGrayed then
        AState := sctcsChecked;
    end;

    BtnSize := SC_TreeRadioButtonSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    if AFrameColor = clNone then
    begin
      TopColors[0] := clBtnShadow;
      TopColors[1] := clWindow;

      BtmColors[0] := clBtnShadow;
      BtmColors[1] := clWindow;
    end else
    begin
      TopColors[0] := GetBtnShadowOf(AFrameColor);
      TopColors[1] := GetBtnHighlightOf(AFrameColor);

      BtmColors[0] := GetBtnShadowOf(AFrameColor);
      BtmColors[1] := GetBtnHighlightOf(AFrameColor);
    end;

    if AFrameColor <> clNone then
    begin
      TopColors[Low(TopColors)] := AFrameColor;
      BtmColors[Low(BtmColors)] := AFrameColor;
    end;

    TopColors[High(TopColors)] := AFaceColor;
    BtmColors[High(BtmColors)] := AFaceColor;

    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := AFaceColor;
      Brush.Color := AFaceColor;

      Ellipse(R.Left, R.Top, R.Right, R.Bottom);

      if (AState = sctcsChecked) and (AForeColor <> clNone) then
      begin
        Pen.Color := AForeColor;
        Brush.Color := AForeColor;

        R2 := R;
        InflateRect(R2, -4, -4);

        Ellipse(R2.Left, R2.Top, R2.Right, R2.Bottom);
      end;

      Pen.Color := AFaceColor;
      Brush.Color := AFaceColor;

      for I := 0 to 1 do
      begin
        R2 := R;
        InflateRect(R2, -I, -I);

        Pen.Color := TopColors[I];

        Dec(R2.Right);
        Dec(R2.Bottom);

        for J := 0 to 2 do
        begin
          Arc(R2.Left, R2.Top, R2.Right, R2.Bottom,
            R2.Right - 1, R2.Top, R2.Left, R2.Bottom - 1);

          Inc(R2.Right);
          Inc(R2.Bottom);
        end;
      end;

      for I := 0 to 1 do
      begin
        R2 := R;
        InflateRect(R2, -I, -I);

        Pen.Color := BtmColors[I];

        Inc(R2.Left);
        Inc(R2.Top);

        for J := 0 to 2 do
        begin
          Arc(R2.Left, R2.Top, R2.Right, R2.Bottom, R2.Left + 1,
            R2.Bottom, R2.Right, R2.Top + 1);

          Dec(R2.Left);
          Dec(R2.Top);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawFlatFrameCheckbox(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
var
  R: TRect;
  BtnSize: Integer;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbCheckbox) then
  begin
    BtnSize := SC_TreeCheckboxSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    if AFaceColor <> clNone then
      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AFaceColor;

        FillRect(R);
      end;

    DrawMarkCheckbox(ACanvas, ANode, R, ABackColor, AFaceColor,
      AFrameColor, AForeColor);

    if AFrameColor = clNone then
    begin
      scFrame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1, 0);
      scFrame3D(Canvas, R, clBtnShadow, clBtnFace, 1, 0);
    end else
    begin
      scFrame3D(Canvas, R, GetBtnShadowOf(AFrameColor),
        GetBtnHighlightOf(AFrameColor), 1, 0);
      scFrame3D(Canvas, R, GetBtnShadowOf(AFrameColor),
        GetBtnFaceOf(AFrameColor), 1, 0);
    end;
  end;
end;

procedure TSCCustomTreeList.DrawFlatFrameRadioButton(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
var
  R, R2: TRect;
  I, J, BtnSize: Integer;
  TopColors: array[0..2] of TColor;
  BtmColors: array[0..2] of TColor;
  AState: TSCTreeCheckButtonState;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbRadioButton) then
  begin
    AState := sctcsUnchecked;
    if ANode <> nil then
    begin
      AState := ANode.ButtonState;
      if (AState = sctcsGrayed) and not ANode.AllowGrayed then
        AState := sctcsChecked;
    end;

    BtnSize := SC_TreeRadioButtonSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    if AFrameColor = clNone then
    begin
      TopColors[0] := clBtnShadow;
      TopColors[1] := clBtnFace;
      TopColors[2] := clWindow;

      BtmColors[0] := clBtnHighlight;
      BtmColors[1] := clBtnFace;
      BtmColors[2] := clWindow;
    end else
    begin
      TopColors[0] := GetBtnShadowOf(AFrameColor);
      TopColors[1] := GetBtnFaceOf(AFrameColor);
      TopColors[2] := GetBtnHighlightOf(AFrameColor);

      BtmColors[0] := GetBtnHighlightOf(AFrameColor);
      BtmColors[1] := GetBtnFaceOf(AFrameColor);
      BtmColors[2] := GetBtnHighlightOf(AFrameColor);
    end;

    TopColors[High(TopColors)] := AFaceColor;
    BtmColors[High(BtmColors)] := AFaceColor;

    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := AFaceColor;

      Pen.Style := psSolid;
      Pen.Width := 1;
      Pen.Color := AFaceColor;

      Ellipse(R.Left, R.Top, R.Right, R.Bottom);

      if (AState = sctcsChecked) and (AForeColor <> clNone) then
      begin
        Pen.Color := AForeColor;
        Brush.Color := AForeColor;

        R2 := R;
        InflateRect(R2, -4, -4);

        Ellipse(R2.Left, R2.Top, R2.Right, R2.Bottom);
      end;

      Pen.Color := AFaceColor;
      Brush.Color := AFaceColor;

      for I := 0 to 2 do
      begin
        R2 := R;
        InflateRect(R2, -I, -I);

        Pen.Color := TopColors[I];

        Dec(R2.Right);
        Dec(R2.Bottom);

        for J := 0 to 2 do
        begin
          Arc(R2.Left, R2.Top, R2.Right, R2.Bottom,
            R2.Right - 1, R2.Top, R2.Left, R2.Bottom - 1);

          Inc(R2.Right);
          Inc(R2.Bottom);
        end;
      end;

      for I := 0 to 2 do
      begin
        R2 := R;
        InflateRect(R2, -I, -I);

        Pen.Color := BtmColors[I];

        Inc(R2.Left);
        Inc(R2.Top);

        for J := 0 to 2 do
        begin
          Arc(R2.Left, R2.Top, R2.Right, R2.Bottom,
            R2.Left + 1, R2.Bottom, R2.Right, R2.Top + 1);

          Dec(R2.Left);
          Dec(R2.Top);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawFlatRadioButton(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
var
  R, R2: TRect;
  BtnSize: Integer;
  AState: TSCTreeCheckButtonState;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbRadioButton) then
  begin
    AState := sctcsUnchecked;
    if ANode <> nil then
    begin
      AState := ANode.ButtonState;
      if (AState = sctcsGrayed) and not ANode.AllowGrayed then
        AState := sctcsChecked;
    end;

    BtnSize := SC_TreeRadioButtonSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := AFaceColor;
      Brush.Color := AFaceColor;

      Ellipse(R.Left, R.Top, R.Right, R.Bottom);

      if (AState = sctcsChecked) and (AForeColor <> clNone) then
      begin
        Pen.Color := AForeColor;
        Brush.Color := AForeColor;

        R2 := R;
        InflateRect(R2, -4, -4);

        Ellipse(R2.Left, R2.Top, R2.Right, R2.Bottom);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawMetalCheckbox(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
var
  R: TRect;
  BtnSize: Integer;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbCheckbox) then
  begin
    BtnSize := SC_TreeCheckboxSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    if AFaceColor <> clNone then
      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AFaceColor;

        FillRect(R);
      end;

    DrawMarkCheckbox(ACanvas, ANode, R, ABackColor, AFaceColor,
      AFrameColor, AForeColor);

    if AFrameColor = clNone then
    begin
      scFrame3D(Canvas, R, clBtnFace, clBtnHighlight, 1, 0);
      scFrame3D(Canvas, R, clBtnShadow, clBtnFace, 1, 0);
    end else
    begin
      scFrame3D(Canvas, R, GetBtnFaceOf(AFrameColor),
        GetBtnHighlightOf(AFrameColor), 1, 0);
      scFrame3D(Canvas, R, GetBtnShadowOf(AFrameColor),
        GetBtnFaceOf(AFrameColor), 1, 0);
    end;
  end;
end;

procedure TSCCustomTreeList.DrawMetalRadioButton(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
begin
  DrawFlatFrameRadioButton(ACanvas, ANode, ARect, ABackColor,
    AFaceColor, AFrameColor, AForeColor);
end;

procedure TSCCustomTreeList.DrawNewCheckbox(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor, AHotColor, AFocusColor: TColor);
var
  R, R2: TRect;
  BtnSize: Integer;
  IsHot, IsFocused: Boolean;
  TopColor, BottomColor, TrackColor: TColor;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbCheckbox) then
  begin
    BtnSize := SC_TreeCheckboxSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    if AFaceColor <> clNone then
    begin
      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AFaceColor;

        FillRect(R);
      end;

      R2 := R;
      R2.Bottom := R2.Top + Round((R2.Bottom - R2.Top) / 3);

      scDrawGradient(ACanvas, R2, scgTopToBottom,
        GetBtnHighlightOf(ABackColor), AFaceColor);
    end;

    IsHot := (ANode = FHotNode) and IsHottrack and
      (AHotColor <> clNone) and not (Editing or Dragging);
    IsFocused := (ANode = FFocusedNode) and (AFocusColor <> clNone) and
      (Self.HasFocus or Editing or not IsHideSelection);

    if IsHot or IsFocused then
    begin
      if IsHot then
        TrackColor := AHotColor
      else TrackColor := AFocusColor;

      TopColor := MixColors(TrackColor, AFaceColor, 40);
      BottomColor := MixColors(TrackColor, AFaceColor, -20);

      R2 := R;
      InflateRect(R2, -1, -1);

      scFrame3D(ACanvas, R2, TopColor, BottomColor, 1, 0);
      scFrame3D(ACanvas, R2, TopColor, BottomColor, 1, 0);
    end;

    DrawMarkCheckbox(ACanvas, ANode, R, ABackColor, AFaceColor,
      AFrameColor, AForeColor);

    if AFrameColor = clNone then
      scFrame3D(Canvas, R, clBtnShadow, clBtnShadow, 1, 0)
    else
      scFrame3D(Canvas, R, GetBtnShadowOf(AFrameColor),
        GetBtnShadowOf(AFrameColor), 1, 0);
  end;
end;

procedure TSCCustomTreeList.DrawNewRadioButton(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor, AHotColor, AFocusColor: TColor);
var
  R, R2: TRect;
  I, BtnSize: Integer;
  Pts: array[0..8] of TPoint;
  IsHot, IsFocused: Boolean;
  AState: TSCTreeCheckButtonState;
  TopColor, BottomColor, TrackColor: TColor;
begin
  if (ANode <> nil) and (ANode.Owner = Self) and
    IsShowCheckButtons and (ANode.ButtonType = sctcbRadioButton) then
  begin
    AState := sctcsUnchecked;
    if ANode <> nil then
    begin
      AState := ANode.ButtonState;
      if (AState = sctcsGrayed) and not ANode.AllowGrayed then
        AState := sctcsChecked;
    end;

    BtnSize := SC_TreeRadioButtonSize;

    R := ARect;

    R.Left := R.Left + ((R.Right - R.Left - BtnSize) div 2);
    R.Top := R.Top + ((R.Bottom - R.Top - BtnSize) div 2);

    R.Right := R.Left + BtnSize;
    R.Bottom := R.Top + BtnSize;

    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := AFaceColor;

      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;
      Pen.Color := AFaceColor;

      Ellipse(R.Left, R.Top, R.Right, R.Bottom);

      if (AState = sctcsChecked) and (AForeColor <> clNone) then
      begin
        Brush.Color := MixColors(AForeColor, AFaceColor, 40);
        Pen.Color := Brush.Color;

        R2 := R;
        InflateRect(R2, -4, -4);

        GenerateOctPoints(R2, 1, Pts);
        Polygon(Pts);

        Brush.Color := AForeColor;
        Pen.Color := AForeColor;

        GenerateOctPoints(R2, 2, Pts);
        Polygon(Pts);
      end;

      IsHot := (ANode = FHotNode) and IsHottrack and
        (AHotColor <> clNone) and not (Editing or Dragging);
      IsFocused := (ANode = FFocusedNode) and (AFocusColor <> clNone) and
        (Self.HasFocus or Editing or not IsHideSelection);

      if IsHot or IsFocused then
      begin
        if IsHot then
          TrackColor := AHotColor
        else TrackColor := AFocusColor;

        TopColor := MixColors(TrackColor, AFaceColor, 40);
        BottomColor := MixColors(TrackColor, AFaceColor, -20);

        Pen.Color := BottomColor;

        R2 := R;
        InflateRect(R2, -1, -1);
        GenerateOctPoints(R2, 3, Pts);
        PolyLine(Pts);

        R2 := R;
        InflateRect(R2, -2, -2);
        GenerateOctPoints(R2, 2, Pts);
        PolyLine(Pts);

        R2 := R;
        InflateRect(R2, -2, -2);
        GenerateOctPoints(R2, 3, Pts);
        PolyLine(Pts);

        Pen.Color := TopColor;

        R2 := R;
        InflateRect(R2, -1, -1);
        GenerateOctPoints(R2, 3, Pts);

        MoveTo(Pts[6].x, Pts[6].y);
        LineTo(Pts[7].x, Pts[7].y);
        LineTo(Pts[0].x, Pts[0].y);
        LineTo(Pts[1].x, Pts[1].y);
        LineTo(Pts[2].x, Pts[2].y);

        R2 := R;
        InflateRect(R2, -2, -2);
        GenerateOctPoints(R2, 2, Pts);

        MoveTo(Pts[6].x, Pts[6].y);
        LineTo(Pts[7].x, Pts[7].y);
        LineTo(Pts[0].x, Pts[0].y);
        LineTo(Pts[1].x, Pts[1].y);
        LineTo(Pts[2].x, Pts[2].y);

        R2 := R;
        InflateRect(R2, -2, -2);
        GenerateOctPoints(R2, 3, Pts);

        MoveTo(Pts[6].x, Pts[6].y);
        LineTo(Pts[7].x, Pts[7].y);
        LineTo(Pts[0].x, Pts[0].y);
        LineTo(Pts[1].x, Pts[1].y);
        LineTo(Pts[2].x, Pts[2].y);

        Pen.Color := MixColors(TrackColor, AFaceColor, 70);

        R2 := R;
        InflateRect(R2, -3, -3);
        GenerateOctPoints(R2, 2, Pts);

        for I := Low(Pts) to High(Pts) do
        begin
          MoveTo(Pts[I].x, Pts[I].y);
          LineTo(Pts[I].x, Pts[I].y + 1);
        end;
      end;

      Brush.Color := AFaceColor;
      Pen.Color := AFaceColor;

      Pen.Color := AFrameColor;
      GenerateOctPoints(R, 4, Pts);
      PolyLine(Pts);

      Pen.Color := MixColors(AFrameColor, GetFaceColor, 50);
      GenerateOctPoints(R, 3, Pts);

      MoveTo(Pts[1].x + 1, Pts[1].y + 1);
      LineTo(Pts[2].x, Pts[2].y);

      MoveTo(Pts[3].x - 1, Pts[3].y + 1);
      LineTo(Pts[4].x, Pts[4].y);

      MoveTo(Pts[5].x - 1, Pts[5].y - 1);
      LineTo(Pts[6].x, Pts[6].y);

      MoveTo(Pts[7].x + 1, Pts[7].y - 1);
      LineTo(Pts[0].x, Pts[0].y);

      GenerateOctPoints(R, 4, Pts);

      for I := Low(Pts) to High(Pts) do
      begin
        MoveTo(Pts[I].x, Pts[I].y);
        LineTo(Pts[I].x, Pts[I].y + 1);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawMarkCheckbox(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ABackColor, AFaceColor,
  AFrameColor, AForeColor: TColor);
var
  R: TRect;
  L, T, I: Integer;
  Pts: array[0..2] of TPoint;
  AState: TSCTreeCheckButtonState;
begin
  if AForeColor <> clNone then
  begin
    AState := sctcsUnchecked;
    if ANode <> nil then
      AState := ANode.ButtonState;

    if AState <> sctcsUnchecked then
    begin
      with ACanvas do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := AForeColor;
      end;

      R := ARect;

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
        ACanvas.Polyline(Pts);

        Inc(Pts[0].y);
        Inc(Pts[1].y);
        Inc(Pts[2].y);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.SetCheckButtonStyle(
  Value: TSCTreeCheckButtonStyle);
begin
  if FCheckButtonStyle <> Value then
  begin
    FCheckButtonStyle := Value;
    if IsShowCheckButtons and HasAnyNode then
      Invalidate;
  end;
end;

procedure TSCCustomTreeList.GenerateOctPoints(ARect: TRect;
  RoundBy: Integer; var Pts: array of TPoint);
var
  Mid, I, L, H: Integer;
begin
  if Length(Pts) > 0 then
  begin
    Mid := (ARect.Right - ARect.Left) div 2;
    if RoundBy > Mid then RoundBy := Mid;

    Mid := (ARect.Bottom - ARect.Top) div 2;
    if RoundBy > Mid then RoundBy := Mid;

    L := Low(Pts);
    H := High(Pts);

    Pts[L].x := ARect.Left + RoundBy;
    Pts[L].y := ARect.Top;

    Inc(L);
    if L > H then Exit;

    Pts[L].x := ARect.Right - RoundBy;
    Pts[L].y := ARect.Top;

    Inc(L);
    if L > H then Exit;

    Pts[L].x := ARect.Right;
    Pts[L].y := ARect.Top + RoundBy;

    Inc(L);
    if L > H then Exit;

    Pts[L].x := ARect.Right;
    Pts[L].y := ARect.Bottom - RoundBy;

    Inc(L);
    if L > H then Exit;

    Pts[L].x := ARect.Right - RoundBy;
    Pts[L].y := ARect.Bottom;

    Inc(L);
    if L > H then Exit;

    Pts[L].x := ARect.Left + RoundBy;
    Pts[L].y := ARect.Bottom;

    Inc(L);
    if L > H then Exit;

    Pts[L].x := ARect.Left;
    Pts[L].y := ARect.Bottom - RoundBy;

    Inc(L);
    if L > H then Exit;

    Pts[L].x := ARect.Left;
    Pts[L].y := ARect.Top + RoundBy;

    Inc(L);
    if L > H then Exit;

    Pts[L].x := ARect.Left + RoundBy;
    Pts[L].y := ARect.Top;

    Inc(L);
    for I := L to H do
    begin
      Pts[I].x := -1;
      Pts[I].y := -1;
    end;
  end;
end;

procedure TSCCustomTreeList.FlagImageListChange(Sender: TObject);
begin
  if not (IsLoading or IsDestroying) and
    (FList <> nil) and (FList.Count > 0) and IsShowFlagImages then
  begin
    CalculateRowWidth;
    Invalidate;
  end;
end;

procedure TSCCustomTreeList.ImageListChange(Sender: TObject);
begin
  if not (IsLoading or IsDestroying) and
    (FList <> nil) and (FList.Count > 0) then
  begin
    CalculateRowWidth;
    Invalidate;
  end;
end;

procedure TSCCustomTreeList.StateImageListChange(Sender: TObject);
begin
  if not (IsLoading or IsDestroying) and
    (FList <> nil) and (FList.Count > 0) and IsShowStateImages then
  begin
    CalculateRowWidth;
    Invalidate;
  end;
end;

procedure TSCCustomTreeList.ReadData(AStream: TStream);
var
  Col: TSCTreeColumn;
  I, StrVersion, Cnt: Integer;
begin
  BeginUpdate;
  try
    ClearColumns;
    ClearNodes;

    AStream.ReadBuffer(StrVersion, SizeOf(StrVersion));
    FStreamVersion := StrVersion;

    // Read columns
    AStream.ReadBuffer(Cnt, SizeOf(Cnt));
    for I := 0 to Cnt - 1 do
    begin
      Col := TSCTreeColumn.Create(Self);
      Col.ReadData(AStream);
    end;

    // Read nodes
    AStream.ReadBuffer(Cnt, SizeOf(Cnt));
    for I := 0 to Cnt - 1 do
      TSCTreeNode(Self.Add).ReadData(AStream);
  finally
    EndUpdate;
  end;
end;

procedure TSCCustomTreeList.WriteData(AStream: TStream);
var
  Cnt, I, StrVersion: Integer;
begin
  StrVersion := SC_CurrentStreamVersion;
  AStream.WriteBuffer(StrVersion, SizeOf(StrVersion));

  // Write columns
  Cnt := Self.ColumnCount;
  AStream.WriteBuffer(Cnt, SizeOf(I));

  for I := 0 to Cnt - 1 do
    TSCTreeColumn(FColumns[I]).WriteData(AStream);

  // Write nodes
  Cnt := Self.Count;
  AStream.WriteBuffer(Cnt, SizeOf(I));

  for I := 0 to Cnt - 1 do
    TSCTreeNode(FList[I]).WriteData(AStream);
end;

procedure TSCCustomTreeList.AssignNodes(Source: TPersistent);
var
  MemStream: TMemoryStream;
  ATreeList: TSCCustomTreeList;
begin
  if Source is TSCCustomTreeList then
  begin
    ATreeList := TSCCustomTreeList(Source);

    BeginUpdate;
    try
      ClearNodes;
      MemStream := TMemoryStream.Create;
      try
        ATreeList.WriteData(MemStream);
        MemStream.Position := 0;

        ReadData(MemStream);
      finally
        MemStream.Free;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TSCCustomTreeList.LoadFromFile(const FileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TSCCustomTreeList.LoadFromStream(Stream: TStream);
begin
  BeginUpdate;
  try
    Self.ClearNodes;
    Self.ReadData(Stream);
  finally
    EndUpdate;
  end;
end;

procedure TSCCustomTreeList.SaveToFile(const FileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TSCCustomTreeList.SaveToStream(Stream: TStream);
begin
  Self.WriteData(Stream);
end;

procedure TSCCustomTreeList.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data', ReadData, WriteData,
    HasAnyColumn or HasAnyNode);
end;

function TSCCustomTreeList.IsShowHotImages: Boolean;
begin
  Result := sctvoShowHotImages in FOptionsView;
end;

function TSCCustomTreeList.IsShowSelectedImages: Boolean;
begin
  Result := sctvoShowSelectedImages in FOptionsView;
end;

procedure TSCCustomTreeList.DeleteSelection;
begin
  if CanMultiSelect and (SelectionCount > 0) then
  begin
    SelectionChanging;
    try
      BeginUpdate;
      try
        while SelectionCount > 0 do
          Selection[0].Free;
        FSelectionList.Clear;
      finally
        EndUpdate;
      end;
    finally
      SelectionChanged;
    end;
  end else
  if FFocusedNode <> nil then
    FFocusedNode.Free;
end;

procedure TSCCustomTreeList.SelectAll;
var
  I: Integer;
  ANode, AParent: TSCTreeNode;
begin
  if CanMultiSelect and (Count > 0) then
  begin
    SelectionChanging;
    try
      BeginUpdate;
      try
        ClearSelection;

        if (FFocusedNode = nil) or (FFocusedNode.Parent = nil) then
        begin
          FSelectionList.Capacity := FList.Count;

          for I := 0 to FList.Count-1 do
          begin
            ANode := TSCTreeNode(FList[I]);
            if CanSelect(ANode) then
              FSelectionList.Add(ANode);
          end;
        end else
        begin
          AParent := FFocusedNode.Parent;
          FSelectionList.Capacity := AParent.Count;

          for I := 0 to AParent.Count-1 do
          begin
            ANode := AParent[I];
            if CanSelect(ANode) then
              FSelectionList.Add(ANode);
          end;
        end;
      finally
        EndUpdate;
      end;
    finally
      SelectionChanged;
    end;
  end;
end;

procedure TSCCustomTreeList.UpdateNodes(Nodes: TSCTreeNodeArray);
var
  L: TList;
  I: Integer;
  ScrNodes: TSCTreeNodeArray;
begin
  if (Nodes <> nil) and (Length(Nodes) > 0) then
  begin
    SetLength(ScrNodes, 0);

    ScrNodes := GetVisibleNodes(True);
    if (ScrNodes <> nil) and (Length(ScrNodes) > 0) then
    begin
      L := TList.Create;
      try
        for I := Low(ScrNodes) to High(ScrNodes) do
          L.Add(ScrNodes[I]);

        for I := Low(Nodes) to High(Nodes) do
          if (Nodes[I] <> nil) and (L.IndexOf(Nodes[I]) > -1) then
            UpdateNode(Nodes[I], False, sctupNode);
      finally
        L.Free;
      end;
    end;
  end;
end;

function TSCCustomTreeList.IsShowHourGlassOnAction: Boolean;
begin
  Result := sctvoShowHourGlassOnAction in FOptionsView;
end;

procedure TSCCustomTreeList.SortNode(ANode: TSCTreeNode; Recursive: Boolean);
var
  L: TList;
  I: Integer;
  OldCursor: TCursor;
  IsExpanded: Boolean;
begin
  if (ANode <> nil) and (ANode.FOwner = Self) and
    not (Sorting or ANode.Sorting) then
  begin
    L := ANode.FList;

    if (L <> nil) and (L.Count > 0) then
    begin
      IsExpanded := ParentExpanded(ANode);

      if IsExpanded then
        BeginUpdate;

      Inc(FSorting);
      Inc(ANode.FSorting);
      try
        OldCursor := Screen.Cursor;
        if IsShowHourGlassOnAction then
          Screen.Cursor := crHourglass;

        try
          QuickSort(L.List, 0, L.Count-1);
          if Recursive then
            for I := 0 to L.Count-1 do
              SortNode(TSCTreeNode(L[I]));
        finally
          Screen.Cursor := OldCursor;
        end;
      finally
        Dec(FSorting);
        Dec(ANode.FSorting);

        if IsExpanded then
          EndUpdate;

        if IsExpanded and ((FTopVisibleNode = ANode) or
          IsParentNodeOf(FTopVisibleNode, ANode)) then
        begin
          FNeedsArrangement := False;

          if FFocusedNode <> nil then
            MakeNodeVisible(FFocusedNode, True)
          else begin
            FTopVisibleNode := nil;
            SetTopVisibleNode(FTopVisibleNode);
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.SortNodes(Recursive: Boolean);
var
  L: TList;
  I: Integer;
  OldCursor: TCursor;
begin
  L := FList;
  if not Sorting and (L <> nil) and (L.Count > 0) then
  begin
    Inc(FSorting);
    BeginUpdate;
    try
      OldCursor := Screen.Cursor;
      if IsShowHourGlassOnAction then
        Screen.Cursor := crHourglass;

      try
        QuickSort(L.List, 0, L.Count-1);
        if Recursive then
          for I := 0 to L.Count-1 do
            SortNode(TSCTreeNode(L[I]));
      finally
        Screen.Cursor := OldCursor;
      end;
    finally
      Dec(FSorting);
      EndUpdate;

      if FFocusedNode <> nil then
        MakeNodeVisible(FFocusedNode, True)
      else SetTopVisibleNode(FTopVisibleNode);
    end;
  end;
end;

procedure TSCCustomTreeList.DoHottrackNode(AHotInfo: TSCTreeHitInfo;
  var ACursor: TCursor);
begin
  //
end;

procedure TSCCustomTreeList.HottrackNode(HitInfo: TSCTreeHitInfo);
var
  IsHot: Boolean;
  ACursor: TCursor;
  OldHotNode: TSCTreeNode;
begin
  if not (HitInfo.Part in SC_NodeHotParts) then
    HitInfo.Node := nil;

  IsHot := not (Editing or Dragging) and (HitInfo.Node <> nil) and
    ((FColumns.Count = 0) or (HitInfo.Column <> nil) or
    (IsShowPreview and (HitInfo.Part = sctpPreview)));

  if ChangeHottrack(HitInfo) then
  begin
    ACursor := FDefaultCursor;

    if IsHot then
    begin
      DoHottrackNode(HitInfo, ACursor);
      if Assigned(FOnHottrack) then
        FOnHottrack(Self, HitInfo, ACursor);
    end;

    ChangeCursor(ACursor);

    OldHotNode := FHotNode;

    FHotNode := HitInfo.Node;
    FHotColumn := HitInfo.Column;
    FHotPart := HitInfo.Part;

    UpdateNode(OldHotNode, False, sctupNode);
    UpdateNode(FHotNode, False, sctupNode);
  end else
  if not IsHot then
    ChangeCursor(FDefaultCursor);
end;

function TSCCustomTreeList.ChangeHottrack(HitInfo: TSCTreeHitInfo): Boolean;
begin
  Result := False;

  if HandleAllocated and IsHottrack then
  begin
    // is different node
    Result := FHotNode <> HitInfo.Node;

    // is different column
    if not Result and (FHotNode <> nil) then
    begin
      Result := (HitInfo.Part in SC_NodeHotParts) and
        (FColumns.Count > 0) and (FHotColumn <> HitInfo.Column);

      // is different part
      if not Result then
      begin
        Result := (FHotPart in SC_NodeHotParts) <> (HitInfo.Part in SC_NodeHotParts);

        if not Result and (FHotPart <> HitInfo.Part) then
          Result := (FColumns.Count > 0) and ((FHotPart = sctpPreview) or
            (HitInfo.Part = sctpPreview));
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.CMCursorChanged(var Message: TMessage);
begin
  inherited;
  if not FCursorChange then FDefaultCursor := Cursor;
end;

function TSCCustomTreeList.CanTrackMouse: Boolean;
begin
  Result := HandleAllocated and IsHottrack and (FMouseDownNode = nil) and
    not (Editing or Dragging or DragScrolling) and
    not (IsDesigning or IsLoading);
end;

function TSCCustomTreeList.CanRowSizing: Boolean;
begin
  Result := IsShowIndicator and (sctboRowSizing in FOptionsBehaviour);
end;

procedure TSCCustomTreeList.EndRowSizing;
var
  Allow: Boolean;
  ANode: TSCTreeNode;
  Ph, AMin, ARowHeight, ADif,
  AStartPos, AEndPos: Integer;
begin
  if FState = sctlsRowSizing then
  begin
    ANode := FSizingNode;
    AStartPos := FSizingStartPos;
    AEndPos := FSizingPos;
    ADif := FSizingStartDif;

    FSizingNode := nil;
    FSizingPos := -1;
    FSizingStartPos := -1;
    FSizingStartDif := 0;

    DrawRowSizingLine;
    SetState(sctlsIdle);

    if CanRowSizing and (ANode <> nil) and (AStartPos <> AEndPos) then
    begin
      ARowHeight := GetNodeHeight(ANode);

      if IsShowPreview and CanRowAutoHeight then
      begin
        Allow := ANode.Preview;
        if Assigned(FOnPreviewEvent) then
          FOnPreviewEvent(Self, ANode, Allow);

        if not Allow then
        begin
          Ph := GetPreviewHeight;
          if Ph > 0 then
            Inc(ARowHeight, Ph);
        end;
      end;

      Inc(ARowHeight, AEndPos - AStartPos + ADif);

      if ARowHeight < 0 then ARowHeight := 0;

      if CanRowAutoHeight then
        SetRowHeight(ARowHeight)
      else begin
        AMin := GetMinNodeHeight(ANode);
        if ARowHeight < AMin then
          ARowHeight := AMin;

        ANode.Height := ARowHeight;
      end;

      UpdateDesigner;
    end;
  end;
end;

procedure TSCCustomTreeList.WMSetCursor(var Message: TWMSetCursor);
var
  ACursor: HCURSOR;
  HitInfo: TSCTreeHitInfo;
  State: TSCTreeListState;
begin
  ACursor := 0;
  with Message do
  begin
    if HitTest = HTCLIENT then
    begin
      State := sctlsIdle;

      if FState in [sctlsIdle, sctlsEditing] then
      begin
        FHitTest := ScreenToClient(FHitTest);
        HitInfo := GetHitInfo(FHitTest.x, FHitTest.y);

        if HitInfo.Part = sctpRowSizer then
          State := sctlsRowSizing
        else
        if HitInfo.Part = sctpColumnSizer then
          State := sctlsColumnSizing;
      end else
        State := FState;

      if State = sctlsRowSizing then
        ACursor := Screen.Cursors[SC_TreeVSize] // [crVSplit]
      else
      if State = sctlsColumnSizing then
        ACursor := Screen.Cursors[SC_TreeHSize]; // [crHSplit];
    end;
  end;

  if ACursor <> 0 then
    SetCursor(ACursor)
  else inherited;
end;

procedure TSCCustomTreeList.WMNCHitTest(var Message: TWMNCHitTest);
begin
  if IsDesigning then
    DefaultHandler(Message)
  else inherited;

  FHitTest := SmallPointToPoint(Message.Pos);
end;

function TSCCustomTreeList.GetMinNodeHeight: Integer;
var
  ImgHeight: Integer;
begin
  Result := 0;
  if HandleAllocated then
  begin
    Result := FDefaultHeight;
    if Result = -1 then
    begin
      Canvas.Font.Assign(Self.Font);

      FMinRowHeight := Canvas.TextHeight('Rq');
      FDefaultHeight := FMinRowHeight + SC_TreeNodeVertSpacing;

      Result := FDefaultHeight;
    end;

    if Images <> nil then
    begin
      ImgHeight := Images.Height;
      if ImgHeight > Result then
        Result := ImgHeight;

      if IsShowStateImages and (FStateImages <> nil) then
      begin
        ImgHeight := FStateImages.Height;
        if ImgHeight > Result then
          Result := ImgHeight;
      end;
    end;

    if IsShowPreview then
      Inc(Result, GetPreviewHeight);
  end;

  if (FMinRowHeight > -1) and (Result < FMinRowHeight) then
    Result := FMinRowHeight;
end;

function TSCCustomTreeList.GetMinNodeHeight(ANode: TSCTreeNode): Integer;
var
  Ph: Integer;
  Allow: Boolean;
begin
  Result := GetMinNodeHeight;

  if (ANode <> nil) and IsShowPreview then
  begin
    Allow := False;

    if CanRowAutoHeight then
    begin
      Allow := ANode.Preview;
      if Assigned(FOnPreviewEvent) then
        FOnPreviewEvent(Self, ANode, Allow);
    end;

    if not Allow then
    begin
      Ph := GetPreviewHeight;

      if Ph > 0 then
      begin
        Dec(Result, Ph);
        if Result < 0 then
          Result := 0;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.CMDesignHitTest(var Message: TCMDesignHitTest);
var
  Shift: TShiftState;
  HitInfo: TSCTreeHitInfo;
begin
  inherited;
  
  if (Message.Result = 0) and not (Self.IsLocked or Self.Dragging) and
    (FState <> sctlsNodeDragging) then
  begin
    Shift := KeysToShiftState(Message.Keys);

    if ssLeft in Shift then
    begin
      HitInfo := GetHitInfo(Message.Pos.X, Message.Pos.Y);

      if (HitInfo.Part in [sctpButton, sctpCheckButton, sctpColumn,
        sctpColumnSizer, sctpRowSizer]) or (FState in [sctlsColumnDown,
        sctlsColumnSizing, sctlsColumnDragging, sctlsRowSizing]) then
      begin
        Message.Result := 1;
        FDesignChange := True;
      end;
    end else
    begin
      if FDesignChange then
        Message.Result := 1;
      FDesignChange := False;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawImages(ACanvas: TCanvas;
  ANode: TSCTreeNode; ARect: TRect; ASelected, AFocused,
  AHot: Boolean);
var
  R: TRect;
  AColor, OldColor: TColor;
  Handled, NodeSelected: Boolean;
  SR, T, AImage, AIndent: Integer;
begin
  if (ANode <> nil) and not IsRectEmpty(ARect) then
  begin
    AColor := clNone;

    if IsOutlookStyle and (ANode.Count > 0) then
    begin
      AColor := FColors.OutlookColor;
      if AColor = clNone then
        AColor := clBtnFace;

      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AColor;

        FillRect(ARect);
      end;
    end;

    OldColor := AColor;

    if Images <> nil then
    begin
      AIndent := 0;

      if IsShowStateImages and (FStateImages <> nil) then
      begin
        AImage := ANode.StateIndex;

        if (AImage > -1) and (AImage < FStateImages.Count) then
        begin
          Inc(AIndent, FStateImages.Width);

          R := ARect;
          R.Right := ARect.Left + AIndent;

          SR := IntersectClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
          try
            if SR <> NULLREGION then
            begin
              Handled := False;

              if Assigned(FOnCustomDrawState) then
                FOnCustomDrawState(Self, ANode, ACanvas, R, ASelected,
                  AFocused, AHot, AColor, AImage, Handled);

              if not Handled then
                DoDrawState(ANode, ACanvas, R, ASelected, AFocused,
                  AHot, AColor, AImage, Handled);

              if not Handled then
              begin
                if (AColor <> clNone) and (AColor <> OldColor) then
                  with ACanvas do
                  begin
                    Brush.Style := bsSolid;
                    Brush.Color := AColor;

                    FillRect(ARect);
                  end;

                T := R.Top + (R.Bottom - R.Top - FStateImages.Height) div 2;
                FStateImages.Draw(ACanvas, R.Left, T, AImage, Self.Enabled);
              end;
            end;
          finally
            SelectClipRgn(ACanvas.Handle, 0);
          end;
        end;
      end;

      NodeSelected := ASelected or (AFocused and not CanMultiSelect);

      Inc(AIndent, Images.Width);

      AImage := ANode.ImageIndex;
      if NodeSelected and IsShowSelectedImages then
        AImage := ANode.SelectedIndex;

      if AHot and IsShowHotImages and not (Dragging or DragScrolling or Editing) and
        (ANode.HotIndex > -1) and (ANode.HotIndex < Images.Count) then
        AImage := ANode.HotIndex;

      if (AImage > -1) and (AImage < Images.Count) then
      begin
        R := ARect;
        R.Right := ARect.Left + AIndent;
        R.Left := R.Right - Images.Width;

        SR := IntersectClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
        try
          if SR <> NULLREGION then
          begin
            AColor := OldColor;
            Handled := False;

            if Assigned(FOnCustomDrawImage) then
              FOnCustomDrawImage(Self, ANode, ACanvas, R, ASelected,
                AFocused, AHot, AColor, AImage, Handled);

            if not Handled then
              DoDrawImage(ANode, ACanvas, R, ASelected, AFocused,
                AHot, AColor, AImage, Handled);

            if not Handled then
            begin
              if (AColor <> clNone) and (AColor <> OldColor) then
                with ACanvas do
                begin
                  Brush.Style := bsSolid;
                  Brush.Color := AColor;

                  FillRect(ARect);
                end;

              T := R.Top + (R.Bottom - R.Top - Images.Height) div 2;
              Images.Draw(ACanvas, R.Left, T, AImage, Self.Enabled and ANode.Enabled);
            end;
          end;
        finally
          SelectClipRgn(ACanvas.Handle, 0);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DoDrawFlag(ANode: TSCTreeNode;
  ACanvas: TCanvas; ARect: TRect; ASelected, AFocused, AHot: Boolean;
  var ABackColor: TColor; AImage: TImageIndex; var Handled: Boolean);
begin
  //
end;

procedure TSCCustomTreeList.DoDrawImage(ANode: TSCTreeNode;
  ACanvas: TCanvas; ARect: TRect; ASelected, AFocused, AHot: Boolean;
  var ABackColor: TColor; AImage: TImageIndex; var Handled: Boolean);
begin
  //
end;

procedure TSCCustomTreeList.DoDrawState(ANode: TSCTreeNode;
  ACanvas: TCanvas; ARect: TRect; ASelected, AFocused, AHot: Boolean;
  var ABackColor: TColor; AImage: TImageIndex; var Handled: Boolean);
begin
  //
end;

function TSCCustomTreeList.GetSorting: Boolean;
begin
  Result := FSorting > 0;
end;

procedure TSCCustomTreeList.DoDrawHint(ACanvas: TCanvas;
  ACell: TSCTreeCell; ARect: TRect; HintText: String);
var
  R: TRect;
begin
  R := ARect;
  InflateRect(R, -2, -2);

  ACanvas.Font.Color := clInfoText;
  Windows.DrawText(ACanvas.Handle, PChar(HintText), -1, R,
    DT_LEFT or DT_NOPREFIX or DT_WORDBREAK or DT_SINGLELINE or DT_VCENTER or
    DrawTextBiDiModeFlagsReadingOnly);
end;

function TSCCustomTreeList.GetHeaderHeight: Integer;
var
  AMin, ImageHeight: Integer;
begin
  Result := FHeaderHeight;

  if HandleAllocated then
  begin
    if (FDefaultHeaderHeight = -1) and (FHeaderFont <> nil) then
    begin
      Canvas.Font.Assign(FHeaderFont);
      FDefaultHeaderHeight := Canvas.TextHeight('Rq') +
        SC_TreeHeaderVertSpace;
    end;

    AMin := FDefaultHeaderHeight;
    if FColumnImages <> nil then
    begin
      ImageHeight := FColumnImages.Height + SC_TreeHeaderImageSpace;
      if AMin < ImageHeight then
        AMin := ImageHeight;
    end;

    if Result < AMin then Result := AMin;
  end;

  if Result < 0 then Result := 0;
end;

procedure TSCCustomTreeList.SetHeaderHeight(Value: Integer);
begin
  if Value < -1 then Value := -1;

  if FHeaderHeight <> Value then
  begin
    FHeaderHeight := Value;

    if IsShowHeader then
    begin
      Invalidate;
      if FList.Count > 0 then
        UpdateScrollbars(True, True);
    end;
  end;
end;

procedure TSCCustomTreeList.UpdateDesigner;
var
  AParent: TCustomForm;
begin
  if IsDesigning and HandleAllocated and not IsUpdating then
  begin
    AParent := GetParentForm(Self);
    if (AParent <> nil) and Assigned(AParent.Designer) then
      AParent.Designer.Modified;
  end;
end;

procedure TSCCustomTreeList.SetColumnImages(Value: TCustomImageList);
var
  OldImages: TCustomImageList;
begin
  OldImages := FColumnImages;
  
  if FColumnImages <> nil then
  begin
  {$IFDEF SC_DELPHI5_UP}
    FColumnImages.RemoveFreeNotification(Self);
  {$ENDIF}
    FColumnImages.UnRegisterChanges(FColumnChangeLink);
  end;

  FColumnImages := Value;
  if FColumnImages <> nil then
  begin
    FColumnImages.RegisterChanges(FColumnChangeLink);
    FColumnImages.FreeNotification(Self);
  end;

  if OldImages <> FColumnImages then
  begin
    Invalidate;
    HeaderImageListChange(FColumnImages);
  end;
end;

procedure TSCCustomTreeList.HeaderImageListChange(Sender: TObject);
begin
  if not (IsLoading or IsDestroying) and IsShowHeader and
    (FColumns <> nil) and (FColumns.Count > 0) then
  begin
    CalculateRowWidth;
    Invalidate;
  end;
end;

function TSCCustomTreeList.GetColumnRect(AColumn: TSCTreeColumn): TRect;
var
  CR: TRect;
  ACol: TSCTreeColumn;
  I, ColWidth: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if HandleAllocated and (AColumn <> nil) and
    (AColumn.Owner = Self) and AColumn.Visible then
  begin
    CR := GetClientRect;

    Result := CR;
    Result.Bottom := Result.Top + GetHeaderHeight;

    if IsShowIndicator then
      Inc(Result.Left, FIndicator);

    ColWidth := GetColumnWidth(AColumn);
    
    for I := 0 to FColumns.Count-1 do
    begin
      ACol := TSCTreeColumn(FColumns[I]);

      if ACol = AColumn then
      begin
        Result.Right := Result.Left + ColWidth;
        Break;
      end;

      if ACol.Visible and (ACol.Width > 0) then
        Inc(Result.Left, GetColumnWidth(ACol));
    end;

    OffsetRect(Result, -FHorizontalPos, 0);
  end;
end;

function TSCCustomTreeList.GetHeaderRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if HandleAllocated and IsShowHeader then
  begin
    Result := GetClientRect;
    Result.Bottom := Result.Top + GetHeaderHeight;
  end;
end;

function TSCCustomTreeList.GetVisibleIndexOf(AColumn: TSCTreeColumn): Integer;
var
  I, AIndex: Integer;
  ACol: TSCTreeColumn;
begin
  Result := -1;
  if (FColumns <> nil) and (FColumns.Count > 0) and
    (AColumn <> nil) and (AColumn.Owner = Self) and AColumn.Visible then
  begin
    AIndex := 0;

    for I := 0 to FColumns.Count-1 do
    begin
      ACol := TSCTreeColumn(FColumns[I]);

      if ACol.Visible then
      begin
        Result := AIndex;
        if ACol = AColumn then
          Break;

        Inc(AIndex);
      end;
    end;
  end;
end;

function TSCCustomTreeList.HasAnyColumn: Boolean;
begin
  Result := (FColumns <> nil) and (FColumns.Count > 0);
end;

procedure TSCCustomTreeList.DrawHeader(ACanvas: TCanvas);
var
  Handled: Boolean;
  R, CR, ARect: TRect;
  AColumn: TSCTreeColumn;
  I, SR, ColWidth: Integer;
  AColor, BColor, LightCl: TColor;
begin
  ARect := Self.GetHeaderRect;
  Dec(ARect.Bottom);

  if not IsRectEmpty(ARect) then
  begin
    CR := GetClientRect;
    
    AColor := FColors.HeaderColor;
    if AColor = clNone then
      AColor := clBtnFace;

    R := ARect;
    Handled := False;

    SR := IntersectClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
    try
      if SR <> NULLREGION then
      begin
        if Assigned(FOnCustomDrawHeader) then
          FOnCustomDrawHeader(Self, ACanvas, ARect, AColor, Handled);

        if not Handled then
          DoDrawHeader(ACanvas, ARect, AColor, Handled);
      end;
    finally
      SelectClipRgn(ACanvas.Handle, 0);
    end;

    if AColor = clNone then
      AColor := clBtnFace;

    if not Handled then
    begin
      with ACanvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := AColor;

        FillRect(ARect);
      end;

      R := ARect;
      with ACanvas do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;

        case FLookAndFeel of
          sctlfDefault:
          begin
            Pen.Color := Get3DDkShadowOf(AColor);

            MoveTo(R.Left, R.Bottom);
            LineTo(R.Right, R.Bottom);

            Pen.Color := GetBtnShadowOf(AColor);

            MoveTo(R.Left, R.Bottom-1);
            LineTo(R.Right, R.Bottom-1);

            Pen.Color := GetBtnHighlightOf(AColor);

            MoveTo(R.Left, R.Top);
            LineTo(R.Right, R.Top);
          end;
          sctlfFlat:
          begin
            Pen.Color := GetBtnShadowOf(AColor);

            MoveTo(R.Left, R.Bottom);
            LineTo(R.Right, R.Bottom);

            Pen.Color := GetBtnHighlightOf(AColor);

            MoveTo(R.Left, R.Top);
            LineTo(R.Right, R.Top);
          end;
          sctlfFlatEx:
          begin
            Pen.Color := Get3DDkShadowOf(AColor);

            MoveTo(R.Left, R.Bottom);
            LineTo(R.Right, R.Bottom);
          end;
          sctlfGradient:
          begin
            LightCl := BlendedColor(AColor, 24, 24, 24, True);
            scDrawGradient(ACanvas, R, scgTopToBottom, LightCl, AColor);

            Pen.Color := GetBtnShadowOf(AColor);

            MoveTo(R.Left, R.Bottom);
            LineTo(R.Right, R.Bottom);
          end;
          sctlfOffice12:
          begin
            DrawOffice12Cell(ACanvas, R, AColor, False);
            Pen.Color := GetBtnShadowOf(AColor);

            MoveTo(R.Left, R.Bottom);
            LineTo(R.Right, R.Bottom);
          end;
        end;
      end;

      R := ARect;
      Inc(R.Top);

      if IsShowIndicator then
        Inc(R.Left, FIndicator);

      with ACanvas do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;

        case FLookAndFeel of
          sctlfDefault:
          begin
            Dec(R.Bottom);

            Pen.Color := GetBtnHighlightOf(AColor);

            MoveTo(R.Left, R.Top);
            LineTo(R.Left, R.Bottom);
          end;
          sctlfFlat:
          begin
            Pen.Color := GetBtnHighlightOf(AColor);

            MoveTo(R.Left, R.Top);
            LineTo(R.Left, R.Bottom);
          end;
        end;
      end;
    end;

    if HasAnyColumn then
    begin
      R := ARect;

      Inc(R.Bottom);
      Dec(R.Left, FHorizontalPos);

      if IsShowIndicator then
        Inc(R.Left, FIndicator);

      R.Right := R.Left;

      for I := 0 to FColumns.Count-1 do
      begin
        if R.Left >= CR.Right then
          Break;

        AColumn := TSCTreeColumn(FColumns[I]);

        if AColumn.Visible and (AColumn.Width > 0) then
        begin
          ColWidth := GetColumnWidth(AColumn);
          
          R.Left := R.Right;
          Inc(R.Right, ColWidth);

          SR := IntersectClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
          try
            if SR <> NULLREGION then
            begin
              BColor := AColumn.Color;
              if (BColor = clNone) then
                BColor := AColor;

              DrawColumn(ACanvas, AColumn, R, BColor, FColumnDown and
                (FState = sctlsColumnDown) and (AColumn = FDownColumn));
            end;
          finally
            SelectClipRgn(ACanvas.Handle, 0);
          end;

          if IsLastVisibleColumn(AColumn) then
          begin
            InflateRect(R, 0, -1);

            with ACanvas do
            begin
              Pen.Style := psSolid;
              Pen.Mode  := pmCopy;
              Pen.Width := 1;

              case FLookAndFeel of
                sctlfDefault:
                begin
                  Pen.Color := GetBtnHighlightOf(AColor);

                  MoveTo(R.Right, R.Top);
                  LineTo(R.Right, R.Bottom);
                end;
                sctlfFlat:
                begin
                  Pen.Color := GetBtnHighlightOf(AColor);

                  MoveTo(R.Right, R.Top);
                  LineTo(R.Right, R.Bottom);
                end;
              end;
            end;
          end;
        end;
      end;
    end;

    if IsShowIndicator then
    begin
      R := ARect;

      Inc(R.Bottom);
      R.Right := R.Left + FIndicator;

      if not IsRectEmpty(R) then
      begin
        SR := IntersectClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
        try
          if SR <> NULLREGION then
            DrawIndicator(ACanvas, nil, R, AColor);
        finally
          SelectClipRgn(ACanvas.Handle, 0);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DoDrawColumn(ACanvas: TCanvas;
  AColumn: TSCTreeColumn; ARect: TRect; var AColor, ASortArrow: TColor;
  var SortDir: TSCTreeSortDirection; var Handled: Boolean);
begin
  //
end;

procedure TSCCustomTreeList.DoDrawHeader(ACanvas: TCanvas; ARect: TRect;
  var AColor: TColor; var Handled: Boolean);
begin
  //
end;

procedure TSCCustomTreeList.DrawColumn(ACanvas: TCanvas;
  AColumn: TSCTreeColumn; ARect: TRect; AColor: TColor;
  IsDown: Boolean);
var
  R, R2: TRect;
  AText: String;
  Handled: Boolean;
  AImage, X, Y, F, M: Integer;
  SortDir: TSCTreeSortDirection;
  Points: array [0..2] of TPoint;
  BColor, SArColor, LightCl: TColor;
begin
  if not IsRectEmpty(ARect) then
  begin
    if AColor = clNone then
    begin
      AColor := AColumn.Color;
      if AColor = clNone then
      begin
        AColor := FColors.HeaderColor;
        if AColor = clNone then
          AColor := clBtnFace;
      end;
    end;

    BColor := AColor;

    SortDir := AColumn.SortDirection;
    SArColor := FColors.SortArrowColor;

    Handled := False;
    if Assigned(FOnCustomDrawColumn) then
      FOnCustomDrawColumn(Self, AColumn, ACanvas, ARect,
        BColor, SArColor, SortDir, Handled);

    if BColor = clNone then
      BColor := AColor;

    if not Handled then
      DoDrawColumn(ACanvas, AColumn, ARect, BColor,
        SArColor, SortDir, Handled);

    if Handled then
      Exit;

    if BColor = clNone then
      BColor := AColor;

    AColor := BColor;

    if IsDown and (FLookAndFeel = sctlfFlatEx) then
      BColor := Get3DDkShadowOf(BColor);

    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := BColor;

      FillRect(ARect);

      if FLookAndFeel = sctlfOffice12 then
        DrawOffice12Cell(ACanvas, ARect, BColor, IsDown)
      else
      if FLookAndFeel = sctlfGradient then
      begin
        R := ARect;

        LightCl := BlendedColor(BColor, 24, 24, 24, True);
        scDrawGradient(ACanvas, R, scgTopToBottom, LightCl, BColor);
      end;

      R := ARect;

      InflateRect(R, -SC_TreeColHorzSpacing, -SC_TreeColVertSpacing);
      Dec(R.Right);

      if FLookAndFeel = sctlfDefault then
        OffsetRect(R, 0, -1);

      if IsDown and (FLookAndFeel <> sctlfFlatEx) then
      begin
        Inc(R.Top, 2);

        if AColumn.HeaderAlignment = taLeftJustify then
          Inc(R.Left)
        else Inc(R.Right);
      end;

      if FColumnImages <> nil then
      begin
        AImage := AColumn.ImageIndex;
        
        if (AImage > -1) and (AImage < FColumnImages.Count) then
        begin
          Y := R.Top + ((R.Bottom - R.Top - FColumnImages.Height) div 2);

          if AColumn.HeaderAlignment = taLeftJustify then
          begin
            X := R.Left;
            Inc(R.Left, FColumnImages.Width + 2);
          end else
          begin
            X := R.Right - FColumnImages.Width;
            Dec(R.Right, FColumnImages.Width + 2);
          end;

          FColumnImages.Draw(ACanvas, X, Y, AImage,
            Self.Enabled and AColumn.Enabled);
        end;
      end;

      if (SArColor <> clNone) and (SortDir <> sctsdNone) then
      begin
        if AColumn.HeaderAlignment = taLeftJustify then
          Dec(R.Right, SC_TreeSortArrowSize)
        else Inc(R.Left, SC_TreeSortArrowSize);
      end;

      if not IsRectEmpty(R) then
      begin
        AText := AColumn.Caption;

        if AText <> '' then
        begin
          ACanvas.Font.Assign(FHeaderFont);

          if IsDown and (FLookAndFeel = sctlfFlatEx) then
            ACanvas.Font.Color := GetBtnHighlightOf(ACanvas.Font.Color);

          F := DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or
            DT_EXPANDTABS or DT_END_ELLIPSIS;

          if AColumn.HeaderAlignment = taLeftJustify then
            F := F or DT_LEFT
          else F := F or DT_RIGHT;

          ACanvas.Brush.Style := bsClear;
          
          Windows.DrawText(ACanvas.Handle, PChar(AText),
            Length(AText), R, F);
        end;
      end;

      if (SArColor <> clNone) and (SortDir <> sctsdNone) then
      begin
        R := ARect;
        if AColumn.HeaderAlignment = taLeftJustify then
        begin
          Dec(R.Right, 7);
          R.Left := R.Right - SC_TreeSortArrowWidth;

          if FLookAndFeel <> sctlfDefault then
            OffsetRect(R, 1, 0);
        end else
        begin
          Inc(R.Left, 7);
          R.Right := R.Left + SC_TreeSortArrowWidth;

          if FLookAndFeel <> sctlfDefault then
            OffsetRect(R, -1, 0);
        end;

        Inc(R.Top, (R.Bottom - R.Top - SC_TreeSortArrowHeight) div 2);
        R.Bottom := R.Top + SC_TreeSortArrowHeight;

        if IsDown and (FLookAndFeel <> sctlfFlatEx) then
          OffsetRect(R, 2, 1);

        if AColor <> clNone then
        begin
          R2 := ARect;

          if AColumn.HeaderAlignment = taLeftJustify then
            R2.Left := R2.Right - SC_TreeSortArrowSize
          else R2.Right := R2.Left + SC_TreeSortArrowSize;

          IntersectRect(R2, R2, ARect);

          if not IsRectEmpty(R2) then
          begin
            Brush.Style := bsSolid;
            Brush.Color := AColor;

            FillRect(R2);

            if FLookAndFeel = sctlfOffice12 then
              DrawOffice12Cell(ACanvas, R2, AColor, False)
            else
            if FLookAndFeel = sctlfGradient then
            begin
              LightCl := BlendedColor(AColor, 24, 24, 24, True);
              scDrawGradient(ACanvas, R2, scgTopToBottom, LightCl, AColor);
            end;
          end;
        end;

        M := SC_TreeSortArrowWidth div 2;

        if SortDir = sctsdDown then
        begin
          Points[0] := Point(R.Right, R.Top);
          Points[1] := Point(R.Left, R.Top);
          Points[2] := Point(R.Left + M, R.Bottom);
        end else
        begin
          Points[0] := Point(R.Right, R.Bottom);
          Points[1] := Point(R.Left, R.Bottom);
          Points[2] := Point(R.Left + M, R.Top);
        end;

        with ACanvas do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := SArColor;

          Brush.Color := SArColor;
          Brush.Style := bsSolid;

          Polygon(Points);
        end;
      end;

      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;

      R := ARect;

      case FLookAndFeel of
        sctlfDefault:
        begin
          if IsDown then
            scFrame3D(ACanvas, R, GetBtnShadowOf(BColor),
              Get3DDkShadowOf(BColor), 1, 0)
          else begin
            scFrame3D(ACanvas, R, GetBtnHighlightOf(BColor),
              Get3DDkShadowOf(BColor), 1, 0);

            Dec(R.Top);
            Dec(R.Left);

            scFrame3D(ACanvas, R, GetBtnHighlightOf(BColor),
              GetBtnShadowOf(BColor), 1, 0);
          end;
        end;
        sctlfFlat:
        begin
          if IsDown then
            scFrame3D(ACanvas, R, GetBtnShadowOf(BColor),
              Get3DDkShadowOf(BColor), 1, 0)
          else
            scFrame3D(ACanvas, R, GetBtnHighlightOf(BColor),
              GetBtnShadowOf(BColor), 1, 0);
        end;
        sctlfFlatEx:
        begin
          Dec(R.Right);
          Dec(R.Bottom);

          Pen.Color := Get3DDkShadowOf(BColor);

          MoveTo(R.Right, R.Top);
          LineTo(R.Right, R.Bottom);

          MoveTo(R.Left, R.Bottom);
          LineTo(R.Right, R.Bottom);
        end;
        sctlfGradient:
        begin
          Dec(R.Right);
          Dec(R.Bottom);

          Pen.Color := GetBtnShadowOf(BColor);

          MoveTo(R.Right, R.Top);
          LineTo(R.Right, R.Bottom);

          MoveTo(R.Left, R.Bottom);
          LineTo(R.Right, R.Bottom);
        end;
        sctlfOffice12:
        begin
          Dec(R.Right);
          Dec(R.Bottom);

          Pen.Color := GetBtnShadowOf(BColor);

          MoveTo(R.Right, R.Top);
          LineTo(R.Right, R.Bottom);

          MoveTo(R.Left, R.Bottom);
          LineTo(R.Right, R.Bottom);
        end;
      end;
    end;
  end;
end;

function TSCCustomTreeList.CanColumnSizing: Boolean;
begin
  Result := IsShowHeader and (sctboColumnSizing in FOptionsBehaviour);
end;

procedure TSCCustomTreeList.DrawColumnSizingLine;
var
  R, ClientR: TRect;
  AMin, APrevSizing, AWidth: Integer;
begin
  APrevSizing := FPrevSizingPos;
  FPrevSizingPos := FSizingPos;

  ClientR := GetClientRect;

  if (APrevSizing > -1) and (APrevSizing > ClientR.Left) and
    (APrevSizing < ClientR.Right) then
    with Canvas do
    begin
      Brush.Style := bsClear;

      Pen.Color := clBlack;
      Pen.Style := psSolid;
      Pen.Mode  := pmNotXor;

      MoveTo(APrevSizing, ClientR.Top);
      LineTo(APrevSizing, ClientR.Bottom);
    end;

  if (FState = sctlsColumnSizing) and (FSizingColumn <> nil) then
  begin
    if FSizingPos < FSizingStartPos then
    begin
      AWidth := GetColumnWidth(FSizingColumn);

      if AWidth < FSizingColumn.MinWidth then
        AWidth := FSizingColumn.MinWidth;

      if AWidth < 0 then AWidth := 0;

      Inc(AWidth, FSizingPos - FSizingStartPos);

      AMin := FSizingColumn.MinWidth;
      if AMin < 0 then AMin := 0;

      if AWidth < AMin then
      begin
        R := GetColumnRect(FSizingColumn);

        FSizingPos := R.Left + AMin;
        FPrevSizingPos := FSizingPos;
      end;
    end;

    with Canvas do
    begin
      Brush.Style := bsClear;

      Pen.Color := clBlack;
      Pen.Style := psSolid;
      Pen.Mode  := pmNotXor;

      MoveTo(FSizingPos, ClientR.Top);
      LineTo(FSizingPos, ClientR.Bottom);
    end;
  end;
end;

procedure TSCCustomTreeList.EndColumnSizing;
var
  AColumn: TSCTreeColumn;
  AColWidth, AStartPos, ADif, AEndPos: Integer;
begin
  if FState = sctlsColumnSizing then
  begin
    AColumn := FSizingColumn;
    AStartPos := FSizingStartPos;
    AEndPos := FSizingPos;
    ADif := FSizingStartDif;

    FSizingColumn := nil;
    FSizingPos := -1;
    FSizingStartPos := -1;
    FSizingStartDif := 0;

    DrawColumnSizingLine;
    SetState(sctlsIdle);

    if CanSizeColumn(AColumn) and (AStartPos <> AEndPos) then
    begin
      AColWidth := GetColumnWidth(AColumn);
      Inc(AColWidth, AEndPos - AStartPos + ADif);

      if AColWidth < AColumn.MinWidth then
        AColWidth := AColumn.MinWidth;

      if AColWidth < 0 then AColWidth := 0;

      AColumn.Width := AColWidth;

      UpdateDesigner;
    end;
  end;
end;

function TSCCustomTreeList.GetColumnWidth(AColumn: TSCTreeColumn): Integer;
begin
  Result := 0;
  if (AColumn <> nil) and (AColumn.Owner = Self) and AColumn.Visible then
  begin
    Result := AColumn.Width;
    if Result < 0 then Result := 0;
  end;
end;

function TSCCustomTreeList.CanDragColumn(AColumn: TSCTreeColumn): Boolean;
begin
  Result := False;
  if CanColumnMoving and (AColumn <> nil) and (AColumn.Owner = Self) then
    Result := AColumn.Visible and not AColumn.DisableDragging;
end;

function TSCCustomTreeList.CanSizeColumn(AColumn: TSCTreeColumn): Boolean;
begin
  Result := False;
  if CanColumnSizing and (AColumn <> nil) and (AColumn.Owner = Self) then
    Result := not AColumn.DisableSizing;
end;

function TSCCustomTreeList.CanColumnMoving: Boolean;
begin
  Result := IsShowHeader and HasAnyVisibleColumn and
    (sctboColumnMoving in FOptionsBehaviour);
end;

function TSCCustomTreeList.CanDragColumn(Index: Integer): Boolean;
var
  AColumn: TSCTreeColumn;
begin
  Result := False;

  if (Index > -1) and (Index < FColumns.Count) and
    IsShowHeader and CanColumnMoving then
  begin
    AColumn := TSCTreeColumn(FColumns[Index]);

    Result := AColumn.Visible and not AColumn.DisableDragging;
    if Result and Assigned(FOnCanDragColumn) then
      FOnCanDragColumn(Self, AColumn, Result);
  end;
end;

procedure TSCCustomTreeList.DoDragOverColumn(P: TPoint; Index: Integer;
  var Accept: Boolean);
var
  AColumn: TSCTreeColumn;
begin
  AColumn := TSCTreeColumn(FColumns[Index]);
  if Assigned(FOnDragOverColumn) then
    FOnDragOverColumn(Self, AColumn, P, Accept);
end;

procedure TSCCustomTreeList.DoEndDragColumn(P: TPoint; Index: Integer;
  var NewPos: Integer; var Accept: Boolean);
var
  AColumn: TSCTreeColumn;
begin
  AColumn := TSCTreeColumn(FColumns[Index]);

  if Assigned(FOnDragEndColumn) then
    FOnDragEndColumn(Self, AColumn, P, Accept);

  if Assigned(FOnEndDragColumn) then
    FOnEndDragColumn(Self, P.X, P.Y, AColumn, NewPos);
end;

function TSCCustomTreeList.IsColumnVisible(Index: Integer): Boolean;
var
  AColumn: TSCTreeColumn;
begin
  Result := False;
  if (Index > -1) and (Index < FColumns.Count) then
  begin
    AColumn := TSCTreeColumn(FColumns[Index]);
    Result := IsColumnVisible(AColumn, True);
  end;
end;

procedure TSCCustomTreeList.StartDragColumn(AColumn: TSCTreeColumn);
var
  P: TPoint;
begin
  if FState = sctlsStartingDrag then
    Exit;

  SetState(sctlsStartingDrag);
  try
    HideHintWindow;
    Application.CancelHint;

    FColumnDown := False;
    FDownColumn := nil;

    SetState(sctlsIdle);

    UpdateHeader;
    Application.ProcessMessages;

    GetCursorPos(P);

    PrepareColumnToDrag(AColumn);
    FDragImageList.SetDragImage(0, FDragImageList.Width div 2,
      FDragImageList.Height div 2);

    FArrowsPos := SC_TreeArrowsHidePos;
    UpdateArrowsPos(Self.ScreenToClient(P), False);

    FDragImageList.BeginDrag(GetDeskTopWindow, P.x, P.y);
  finally
    SetState(sctlsColumnDragging);
  end;

  if Assigned(FOnStartColumnDragging) then
    FOnStartColumnDragging(Self, AColumn);
end;

procedure TSCCustomTreeList.UpdateColumn(AColumn: TSCTreeColumn);
var
  R, CR: TRect;
begin
  if IsShowHeader and (AColumn <> nil) and (AColumn.Owner = Self) and
    not (AColumn.Deleting or IsDestroying or InUpdate) and
    IsColumnVisible(AColumn, True) then
  begin
    R := GetColumnRect(AColumn);

    if HandleAllocated and not IsRectEmpty(R) then
    begin
      CR := GetClientRect;
      if IsShowIndicator then Inc(CR.Left, FIndicator);

      IntersectRect(R, R, CR);
      InvalidateRect(Self.Handle, @R, False);
    end;
  end;
end;

function TSCCustomTreeList.IsColumnVisible(AColumn: TSCTreeColumn;
  AllowPartitial: Boolean): Boolean;
var
  R, R2, CR: TRect;
begin
  Result := False;
  if (AColumn <> nil) and (AColumn.Owner = Self) and
    AColumn.Visible and (AColumn.Width > 0) then
  begin
    R := GetColumnRect(AColumn);

    if not IsRectEmpty(R) then
    begin
      CR := GetClientRect;
      if IsShowIndicator then
        Inc(CR.Left, FIndicator);

      if IntersectRect(R2, R, CR) then
        Result := AllowPartitial or EqualRect(R2, R);
    end;
  end;
end;

procedure TSCCustomTreeList.UpdateHeader;
var
  R: TRect;
begin
  if IsShowHeader and not (InUpdate or IsDestroying) then
  begin
    R := GetHeaderRect;
    if HandleAllocated and not IsRectEmpty(R) then
      InvalidateRect(Self.Handle, @R, False);
  end;
end;

procedure TSCCustomTreeList.DoBeginDragColumn(AColumn: TSCTreeColumn);
begin
  //
end;

procedure TSCCustomTreeList.PrepareColumnToDrag(AColumn: TSCTreeColumn);
var
  R: TRect;
  W: Integer;
  DragBitmap: TBitmap;
begin
  if FArrowsBitmap = nil then
    FArrowsBitmap := TBitmap.Create;

  with FArrowsBitmap, Canvas do
  begin
    Width  := SC_TreeArrowsWidth;
    Height := SC_TreeArrowsHeight;

    Brush.Color := clNone;
    Brush.Style := bsSolid;

    FillRect(Rect(0, 0, Width, Height));
  end;

  if FSaveBitmap = nil then
    FSaveBitmap := TBitmap.Create;

  with FSaveBitmap, Canvas do
  begin
    Width  := SC_TreeArrowsWidth;
    Height := SC_TreeArrowsHeight;

    Brush.Color := clNone;
    Brush.Style := bsSolid;

    FillRect(Rect(0, 0, Width, Height));
  end;

  DragBitmap := TBitmap.Create;
  try
    W := GetColumnWidth(AColumn);

    if W <= 0 then W := 24;
    if W > Screen.Width then W := Screen.Width;

    R := Rect(0, 0, W, GetHeaderHeight);

    with DragBitmap do
    begin
      Width := R.Right;
      Height := R.Bottom;
    end;

    with DragBitmap.Canvas do
    begin
      Brush.Color := clNone;
      Brush.Style := bsSolid;

      FillRect(Rect(0, 0, R.Right, R.Bottom));
    end;

    DrawColumn(DragBitmap.Canvas, AColumn, R, clNone, False);

    if FDragImageList = nil then
      FDragImageList := TImageList.CreateSize(R.Right, R.Bottom);

    FDragImageList.AddMasked(DragBitmap, clNone);
  finally
    DragBitmap.Free;
  end;
end;

procedure TSCCustomTreeList.SetFocusedColumn(Value: TSCTreeColumn);
begin
  if (Value <> FFocusedColumn) and CanFocusColumn(Value) then
  begin
    FocusedColumnChanging;
    try
      FFocusedColumn := Value;
      
      if FFocusedNode <> nil then
        UpdateNode(FFocusedNode, False, sctupNode);
    finally
      FocusedColumnChanged;
    end;
  end;
end;

function TSCCustomTreeList.CanFocusColumn(AColumn: TSCTreeColumn): Boolean;
begin
  Result := False;
  if (AColumn = nil) or ((AColumn.Owner = Self) and AColumn.Visible) then
  begin
    Result := DoCanFocusColumn(AColumn);
    if Result and Assigned(FOnCanFocusColumn) then
      FOnCanFocusColumn(Self, AColumn, Result);
  end;
end;

function TSCCustomTreeList.DoCanFocusColumn(AColumn: TSCTreeColumn): Boolean;
begin
  Result := True;
end;

procedure TSCCustomTreeList.FocusedColumnChanged;
begin
  MakeColumnVisible(FFocusedColumn, False);
  if Assigned(FOnFocusedColumnChange) then
    FOnFocusedColumnChange(Self);
end;

procedure TSCCustomTreeList.FocusedColumnChanging;
begin
  if Assigned(FOnFocusedColumnChanging) then
    FOnFocusedColumnChanging(Self);
end;

procedure TSCCustomTreeList.MakeColumnVisible(AColumn: TSCTreeColumn;
  AllowPartitial: Boolean);
var
  CR, R: TRect;
begin
  if (AColumn <> nil) and (AColumn.FOwner = Self) and
    (FColumns.Count > 0) and not IsColumnVisible(AColumn, AllowPartitial) then
  begin
    CR := GetNodesRect;
    if IsShowIndicator then
      Inc(CR.Left, FIndicator);

    R := GetColumnRect(AColumn);

    if (R.Left < CR.Left) or ((R.Left > CR.Left) and (R.Right > CR.Right)) then
    begin
      OffsetRect(R, FHorizontalPos, 0);
      if IsShowIndicator then
        OffsetRect(R, -FIndicator, 0);

      SetHorizontalPos(R.Left);
    end;
  end;
end;

procedure TSCCustomTreeList.AutoSizeColumn(AColumn: TSCTreeColumn);
var
  AText: String;
  IsFirst: Boolean;
  ANode: TSCTreeNode;
  I, AWidth, ColWidth,
  AIndex, ALevelInd, AImage: Integer;
begin
  if (AColumn <> nil) and (FInRowCalculation = 0) and not InUpdate and
    (AColumn.Owner = Self) and AColumn.Visible and (FRealList.Count > 0) then
  begin
    Inc(FInRowCalculation);
    try
      ColWidth := 0;

      if AColumn = GetSortedColumn then
        Inc(ColWidth, SC_TreeSortArrowSize);

      AIndex := FColumns.IndexOf(AColumn);
      IsFirst := AColumn = FirstVisibleColumn;

      // Add column image width
      if FColumnImages <> nil then
      begin
        AImage := AColumn.ImageIndex;
        if (AImage > -1) and (AImage < FColumnImages.Count) then
          Inc(ColWidth, FColumnImages.Width + 2);
      end;

      // Calculate Caption Width
      Canvas.Font.Assign(Self.HeaderFont);

      AText := AColumn.Caption;
      if AText = '' then
        Inc(ColWidth, 10)
      else Inc(ColWidth, Canvas.TextWidth(AText));

      Inc(ColWidth, SC_TreeColHorzSpacing + 2);

      // Calculate Nodes Width
      ALevelInd := GetLevelIndent;
      Canvas.Font.Assign(Self.Font);

      for I := 0 to FRealList.Count - 1 do
      begin
        ANode := TSCTreeNode(FRealList[I]);

        if not ANode.Deleting then
        begin
          AWidth := 0;

          // Calculate Node's text width
          AText := ANode.GetString(AIndex);
          if AText = '' then
            Inc(AWidth, 10)
          else Inc(AWidth, Canvas.TextWidth(AText));

          Inc(AWidth, SC_TreeNodeHorzSpacing + 4);

          // If is first visible column, include spare parts
          if IsFirst then
          begin
            Inc(AWidth, Self.Indent);
            Inc(AWidth, ALevelInd*GetNodeLevel(ANode));
              
            if IsShowFlagImages and (FFlagImages <> nil) then
              Inc(AWidth, FFlagImages.Width);

            if IsShowCheckButtons and (ANode.ButtonType <> sctcbNone) then
              Inc(AWidth, SC_TreeCheckButtonSize);

            if Self.Images <> nil then
            begin
              Inc(AWidth, Images.Width);

              if IsShowStateImages and (FStateImages <> nil) then
              begin
                AImage := ANode.StateIndex;
                if (AImage > -1) and (AImage < FStateImages.Count) then
                  Inc(AWidth, FStateImages.Width);
              end;
            end;
          end;

          if AWidth > ColWidth then
            ColWidth := AWidth;
        end;
      end;

      AColumn.Width := ColWidth;
    finally
      Dec(FInRowCalculation);
      CalculateRowWidth;
    end;
  end;
end;

procedure TSCCustomTreeList.DoColumnDragging;
var
  R: TRect;
  P, P1: TPoint;
  DragCur: TCursor;
  AIndex, X, Y: Integer;
  CurChanged, Accept: Boolean;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);

  UpdateArrowsPos(P, True);

  Accept := False;
  DragCur := crNoDrop;

  if FArrowsPos > SC_TreeArrowsHidePos then
  begin
    R := GetClientRect;
    R.Bottom := R.Top + GetHeaderHeight;

    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      Accept := True;
      DragCur := Self.Cursor;
    end;
  end;

  GetDraggingCursor(P, DragCur);

  AIndex := FColumns.IndexOf(FDragColumn);
  DoDragOverColumn(P, AIndex, Accept);

  if not Accept then
    DragCur := crNoDrop
  else DragCur := Self.Cursor;

  CurChanged := (FDragImageList.DragCursor <> DragCur);
  if CurChanged then FDragImageList.HideDragImage;

  FDragImageList.DragCursor := DragCur;
  if CurChanged then FDragImageList.ShowDragImage;

  P1 := FDragImageList.GetHotSpot;

  X := FDragImageList.Width div 2;
  Y := FDragImageList.Height div 2;

  if FDragImageList.Dragging and ((P1.x <> X) or (P1.y <> Y)) then
  begin
    P1 := ClientToScreen(Point(P.x, P.y));

    FDragImageList.EndDrag;
    FDragImageList.SetDragImage(0, X, Y);
    FDragImageList.BeginDrag(GetDeskTopWindow, P1.x, P1.y)
  end else
    P1 := ClientToScreen(Point(P.x, P.y));
    
  if not FDragImageList.Dragging then
    FDragImageList.BeginDrag(GetDeskTopWindow, P1.x, P1.y)
  else FDragImageList.DragMove(P1.x, P1.y);
end;

procedure TSCCustomTreeList.UpdateArrowsPos(P: TPoint; HideDrag: Boolean);
var
  CR, R: TRect;
  AColumn: TSCTreeColumn;
  ADragIndex, FirstColumn,
  AIndex, W, I, APos, ColWidth: Integer;
begin
  APos := SC_TreeArrowsHidePos;

  if IsShowHeader and CanDragColumn(FDragColumn) then
  begin
    CR := GetClientRect;
    if IsShowIndicator then Inc(CR.Left, FIndicator);

    R := CR;
    R.Bottom := R.Top + GetHeaderHeight;

    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      AIndex := -1;
      OffsetRect(R, -FHorizontalPos, 0);

      W := 0;
      R.Right := R.Left;
      FirstColumn := -1;

      for I := 0 to FColumns.Count-1 do
      begin
        R.Left := R.Right;
        AColumn := TSCTreeColumn(FColumns[I]);

        if AColumn.Visible and (AColumn.Width > 0) then
        begin
          ColWidth := GetColumnWidth(AColumn);

          Inc(W, ColWidth);
          R.Right := R.Left + ColWidth;

          if R.Right > CR.Left then
          begin
            if FirstColumn = -1 then
              FirstColumn := I;

            if PtInRect(R, P) then
            begin
              APos := R.Left;
              AIndex := I;

              Inc(R.Left, ColWidth div 2);

              if PtInRect(R, P) then
              begin
                Inc(AIndex);
                APos := R.Right;
              end;

              Break;
            end;
          end;
        end;
      end;

      if APos = SC_TreeArrowsHidePos then
      begin
        if FirstColumn > -1 then
        begin
          R := CR;

          R.Right := R.Left;
          Dec(R.Left, 40);

          if not IsRectEmpty(R) and PtInRect(R, P) then
          begin
            AIndex := 0;
            APos := R.Right;
          end;
        end;

        if APos = SC_TreeArrowsHidePos then
        begin
          R := CR;

          R.Right := R.Left + W;
          OffsetRect(R, -FHorizontalPos, 0);

          R.Left := R.Right;
          R.Right := CR.Right + 40;

          if not IsRectEmpty(R) and PtInRect(R, P) then
          begin
            AIndex := FColumns.Count;
            APos := R.Left;
          end;
        end;
      end;

      ADragIndex := FColumns.IndexOf(FDragColumn);
      if (AIndex = ADragIndex) or (AIndex = ADragIndex + 1) then
        APos := SC_TreeArrowsHidePos;
    end;
  end;

  if FArrowsPos <> APos then
  begin
    if HideDrag and (FDragImageList <> nil) and FDragImageList.Dragging then
      FDragImageList.HideDragImage;

    try
      RestoreArrowsBack(FArrowsPos, False);

      FArrowsPos := APos;
      StoreArrowsBack(FArrowsPos, False);

      DrawDragArrows(False);
    finally
      if HideDrag and (FDragImageList <> nil) and FDragImageList.Dragging then
        FDragImageList.ShowDragImage;
    end;
  end;
end;

procedure TSCCustomTreeList.GetDraggingCursor(P: TPoint;
  var ACursor: TCursor);
begin
  //
end;

procedure TSCCustomTreeList.EndColumnDragging;
var
  P: TPoint;
  Accept: Boolean;
  AColumn: TSCTreeColumn;
  OldIndex, NewIndex: Integer;
begin
  SetState(sctlsIdle);

  if FDragImageList <> nil then
  begin
    FDragImageList.EndDrag;
    FreeAndNil(FDragImageList);
  end;

  RestoreArrowsBack(FArrowsPos, False);

  FreeAndNil(FSaveBitmap);
  FreeAndNil(FArrowsBitmap);

  AColumn := FDragColumn;

  FArrowsPos  := -1;
  FDragColumn := nil;
  FDownColumn := nil;
  FColumnDown := False;

  UpdateHeader;

  if IsShowHeader and CanDragColumn(AColumn) then
  begin
    GetCursorPos(P);
    P := ScreenToClient(P);

    OldIndex := FColumns.IndexOf(AColumn);

    NewIndex := GetDragOverColumn(P);
    if NewIndex > OldIndex then Dec(NewIndex);

    if (OldIndex <> NewIndex) and (NewIndex > -1) and
      (NewIndex < FColumns.Count) then
    begin
      Accept := True;
      DoEndDragColumn(P, OldIndex, NewIndex, Accept);

      if Accept and IsColumnVisible(AColumn, True) and
        (NewIndex <> OldIndex) and (NewIndex > -1) and
        (NewIndex < FColumns.Count) then
      begin
        MoveColumn(OldIndex, NewIndex);
        MakeColumnVisible(AColumn, True);
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DoColumnClick(AColumn: TSCTreeColumn);
begin
  //
end;

function TSCCustomTreeList.GetDragOverColumn(P: TPoint): Integer;
var
  CR, R: TRect;
  AColumn: TSCTreeColumn;
  FirstVisible, W, I, ColWidth: Integer;
begin
  Result := -1;

  if IsShowHeader and HasAnyVisibleColumn then
  begin
    CR := GetClientRect;
    if IsShowIndicator then Inc(CR.Left, FIndicator);

    R := CR;
    R.Bottom := R.Top + GetHeaderHeight;

    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      OffsetRect(R, -FHorizontalPos, 0);

      W := 0;
      R.Right := R.Left;
      FirstVisible := -1;

      for I := 0 to FColumns.Count-1 do
      begin
        R.Left := R.Right;
        AColumn := TSCTreeColumn(FColumns[I]);

        if AColumn.Visible and (AColumn.Width > 0) then
        begin
          ColWidth := GetColumnWidth(AColumn);
          
          Inc(W, ColWidth);
          R.Right := R.Left + ColWidth;

          if R.Right > CR.Left then
          begin
            if FirstVisible = -1 then
              FirstVisible := I;

            if PtInRect(R, P) then
            begin
              Result := I;

              Inc(R.Left, ColWidth div 2);
              if PtInRect(R, P) then
                Inc(Result);

              Break;
            end;
          end;
        end;
      end;

      if Result = -1 then
      begin
        if IsShowIndicator and (FirstVisible > -1) then
        begin
          R := CR;

          R.Right := R.Left;
          Dec(R.Left, FIndicator);

          if not IsRectEmpty(R) and PtInRect(R, P) then
            Result := FirstVisible;
        end;

        if Result = -1 then
        begin
          R := CR;

          R.Right := R.Left + W;
          OffsetRect(R, -FHorizontalPos, 0);

          R.Left := R.Right;
          R.Right := CR.Right;

          if not IsRectEmpty(R) and PtInRect(R, P) then
            Result := GetVisibleColumnCount;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTreeList.DrawDragOverArrows(ACanvas: TCanvas; P: TPoint);
var
  Points: array [0..6] of TPoint;
  ABackColor, AFrameColor: TColor;
begin
  ABackColor := FColors.ArrowColor;
  if ABackColor = clNone then
    ABackColor := clWindow;

  AFrameColor := FColors.ArrowFrameColor;
  if AFrameColor = clNone then
    AFrameColor := clWindowFrame;

  with ACanvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := ABackColor;

    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;
    Pen.Width := 1;
    Pen.Color := AFrameColor;

    Points[0] := Point(P.x,      P.y);
    Points[1] := Point(P.x - 7,  P.y + 7);
    Points[2] := Point(P.x - 7,  P.y + 3);
    Points[3] := Point(P.x - 10, P.y + 3);
    Points[4] := Point(P.x - 10, P.y - 3);
    Points[5] := Point(P.x - 7,  P.y - 3);
    Points[6] := Point(P.x - 7,  P.y - 7);
    Polygon(Points);

    Points[0] := Point(P.x,      P.y);
    Points[1] := Point(P.x + 7,  P.y + 7);
    Points[2] := Point(P.x + 7,  P.y + 3);
    Points[3] := Point(P.x + 10, P.y + 3);
    Points[4] := Point(P.x + 10, P.y - 3);
    Points[5] := Point(P.x + 7,  P.y - 3);
    Points[6] := Point(P.x + 7,  P.y - 7);
    Polygon(Points);
  end;
end;

function TSCCustomTreeList.GetArrowsRect(APos: Integer): TRect;
var
  P, P1: TPoint;
  W, H: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated and (APos <> SC_TreeArrowsHidePos) then
  begin
    W := SC_TreeArrowsWidth;
    H := SC_TreeArrowsHeight;

    Result := GetClientRect;
    Result.Bottom := Result.Top + GetHeaderHeight;

    P := Point(APos, Result.Top + ((Result.Bottom - Result.Top) div 2));

    Result.Left := P.x - (W div 2);
    Result.Right := Result.Left + W;

    Result.Top := P.y - (H div 2);
    Result.Bottom := Result.Top + H;

    P1 := Self.ClientToScreen(P);
    OffsetRect(Result, P1.x - P.x - 1, P1.y - P.y - 3);
  end;
end;

procedure TSCCustomTreeList.StoreArrowsBack(APos: Integer; HideDrag: Boolean);
var
  DC: HDC;
  R: TRect;
  W, H: Integer;
begin
  if FSaveBitmap <> nil then
  begin
    R := GetArrowsRect(APos);

    if not IsRectEmpty(R) then
    begin
      W := R.Right - R.Left;
      H := R.Right - R.Left;

      if HideDrag and (FDragImageList <> nil) and FDragImageList.Dragging then
        FDragImageList.HideDragImage;

      DC := GetDC(0);
      try
        BitBlt(FSaveBitmap.Canvas.Handle, 0, 0, W, H, DC, R.Left, R.Top, SRCCOPY);
      finally
        ReleaseDC(0, DC);
      end;

      if HideDrag and (FDragImageList <> nil) and FDragImageList.Dragging then
        FDragImageList.ShowDragImage;
    end;
  end;
end;

procedure TSCCustomTreeList.RestoreArrowsBack(APos: Integer;
  HideDrag: Boolean);
var
  DC: HDC;
  R: TRect;
  W, H: Integer;
begin
  if FSaveBitmap <> nil then
  begin
    R := GetArrowsRect(APos);

    if not IsRectEmpty(R) then
    begin
      W := R.Right - R.Left;
      H := R.Right - R.Left;

      if HideDrag and (FDragImageList <> nil) and FDragImageList.Dragging then
        FDragImageList.HideDragImage;

      DC := GetDC(0);
      try
        BitBlt(DC, R.Left, R.Top, W, H, FSaveBitmap.Canvas.Handle, 0, 0, SRCCOPY);
      finally
        ReleaseDC(0, DC);
      end;

      if HideDrag and (FDragImageList <> nil) and FDragImageList.Dragging then
        FDragImageList.ShowDragImage;
    end;
  end;
end;

procedure TSCCustomTreeList.CancelDragSize;
begin
  case FState of
    sctlsRowSizing:
    begin
      FSizingPos := -1;
      FSizingStartPos := -1;
      FSizingStartDif := 0;

      DrawRowSizingLine;
      SetState(sctlsIdle);

      SetCursor(Screen.Cursors[Self.Cursor]);
    end;
    sctlsColumnSizing:
    begin
      FSizingPos := -1;
      FSizingStartPos := -1;
      FSizingStartDif := 0;

      DrawColumnSizingLine;
      SetState(sctlsIdle);

      SetCursor(Screen.Cursors[Self.Cursor]);
    end;
    sctlsColumnDown:
    begin
      FDragColumn := nil;
      FDownColumn := nil;
      FColumnDown := False;
      FArrowsPos  := SC_TreeArrowsHidePos;

      if FDragImageList <> nil then
      begin
        FDragImageList.EndDrag;
        FreeAndNil(FDragImageList);
      end;

      SetState(sctlsIdle);
      UpdateHeader;
    end;
    sctlsColumnDragging:
    begin
      if FDragImageList <> nil then
      begin
        FDragImageList.EndDrag;
        FreeAndNil(FDragImageList);
      end;

      RestoreArrowsBack(FArrowsPos, False);

      FreeAndNil(FSaveBitmap);
      FreeAndNil(FArrowsBitmap);

      FDragColumn := nil;
      FDownColumn := nil;
      FColumnDown := False;
      FArrowsPos  := SC_TreeArrowsHidePos;

      SetState(sctlsIdle);
      UpdateHeader;
    end;
  end;
end;

function TSCCustomTreeList.IsLastVisibleColumn(AColumn: TSCTreeColumn): Boolean;
var
  I: Integer;
  ACol: TSCTreeColumn;
begin
  Result := False;
  if (FColumns <> nil) and (FColumns.Count > 0) and
    (AColumn <> nil) and (AColumn.Owner = Self) and AColumn.Visible then
    for I := FColumns.Count-1 downto 0 do
    begin
      ACol := TSCTreeColumn(FColumns[I]);
      if ACol.Visible then
      begin
        Result := ACol = AColumn;
        Break;
      end;
    end;
end;

function TSCCustomTreeList.HasAnyVisibleColumn: Boolean;
var
  I: Integer;
  AColumn: TSCTreeColumn;
begin
  Result := False;
  if (FColumns <> nil) and (FColumns.Count > 0) then
    for I := FColumns.Count-1 downto 0 do
    begin
      AColumn := TSCTreeColumn(FColumns[I]);
      if AColumn.Visible then
      begin
        Result := True;
        Break;
      end;
    end;
end;

function TSCCustomTreeList.GetVisibleColumnCount: Integer;
var
  I: Integer;
  AColumn: TSCTreeColumn;
begin
  Result := 0;
  if (FColumns <> nil) and (FColumns.Count > 0) then
    for I := FColumns.Count-1 downto 0 do
    begin
      AColumn := TSCTreeColumn(FColumns[I]);
      if AColumn.Visible then
        Inc(Result);
    end;
end;

function TSCCustomTreeList.GetVisibleColumn(Index: Integer): TSCTreeColumn;
var
  I, AIndex: Integer;
  AColumn: TSCTreeColumn;
begin
  Result := nil;
  if (FColumns <> nil) and (FColumns.Count > 0) and
    (Index > -1) and (Index < FColumns.Count) then
  begin
    AIndex := 0;

    for I := FColumns.Count-1 downto 0 do
    begin
      AColumn := TSCTreeColumn(FColumns[I]);
      if AColumn.Visible then
      begin
        if AIndex = Index then
        begin
          Result := AColumn;
          Break;
        end;

        Inc(AIndex);
      end;
    end;
  end;
end;

function TSCCustomTreeList.AsCell(ANode: TSCTreeNode; ACol: TSCTreeColumn): TSCTreeCell;
begin
  Result.Node := ANode;
  Result.Column := ACol;
end;

function TSCCustomTreeList.IsHot(ACell: TSCTreeCell): Boolean;
begin
  Result := (ACell.Node <> nil) and (ACell.Node = FHotNode) and
    not (Editing or Dragging);

  if Result and (FColumns.Count > 0) and (CanCellSelect or not CanRowSelect) then
    Result := (ACell.Column <> nil) and (ACell.Column = FHotColumn);

  if not Result and IsShowPreview then
    Result := (ACell.Column = nil) and (ACell.Node = FHotNode) and
      (FHotPart = sctpPreview);
end;

function TSCCustomTreeList.IsFocused(ACell: TSCTreeCell): Boolean;
begin
  Result := (ACell.Node <> nil) and (ACell.Node = FFocusedNode) and
    ((CanRowSelect and not CanCellSelect) or ((FColumns <> nil) and
    (FColumns.Count = 0)) or (ACell.Column = FFocusedColumn));
end;

function TSCCustomTreeList.IsFocusedNode(ANode: TSCTreeNode): Boolean;
begin
  Result := (ANode <> nil) and (ANode = FFocusedNode);
end;

function TSCCustomTreeList.IsSelected(ANode: TSCTreeNode): Boolean;
begin
  Result := False;
  if (ANode <> nil) and (ANode.Owner = Self) then
  begin
    if CanMultiSelect then
      Result := FSelectionList.IndexOf(ANode) > -1
    else
    if (FColumns.Count = 0) or CanRowSelect then
      Result := ANode = FFocusedNode;
  end;
end;

function TSCCustomTreeList.GetCellRect(ACell: TSCTreeCell;
  TextOnly: Boolean): TRect;
var
  ARect: TRect;
  AText: String;
  ACol: TSCTreeColumn;
  I, L, ColWidth: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if (FColumns <> nil) and (FNodeList <> nil) and
    (ACell.Node <> nil) and (ACell.Node.Owner = Self) then
  begin
    if FColumns.Count = 0 then
      Result := GetNodeRect(ACell.Node, False)
    else
    if ACell.Column <> nil then
    begin
      ARect := GetNodeRect(ACell.Node, True);
      if IsShowPreview then
        Dec(ARect.Bottom, GetPreviewHeight(ACell.Node));

      L := 0;
      if IsShowIndicator then
        L := FIndicator;

      Dec(L, FHorizontalPos);

      for I := 0 to FColumns.Count-1 do
      begin
        ACol := TSCTreeColumn(FColumns[I]);

        if ACol.Visible and (ACol.Width > 0) then
        begin
          ColWidth := GetColumnWidth(ACol);

          if ACol = ACell.Column then
          begin
            Result := ARect;

            Result.Left := L;
            Result.Right := L + ColWidth;

            if Result.Left < ARect.Left then
            begin
              Result.Left := ARect.Left;
              if Result.Right < Result.Left then
                Result.Right := Result.Left;
            end;

            if TextOnly then
            begin
              Result.Right := Result.Left;
              AText := ACell.Node.GetString(I);

              if AText <> '' then
                with Self.Canvas do
                begin
                  Font.Assign(Self.Font);
                  Inc(Result.Right, TextWidth(AText));
                end;
            end;

            Break;
          end;

          Inc(L, ColWidth);
        end;
      end;
    end;
  end;
end;

function TSCCustomTreeList.FirstVisibleColumn: TSCTreeColumn;
var
  I: Integer;
  ACol: TSCTreeColumn;
begin
  Result := nil;
  if (FColumns <> nil) and (FColumns.Count > 0) then
    for I := 0 to FColumns.Count-1 do
    begin
      ACol := TSCTreeColumn(FColumns[I]);
      if ACol.Visible then
      begin
        Result := ACol;
        Break;
      end;
    end;
end;

function TSCCustomTreeList.IsFirstVisibleColumn(AColumn: TSCTreeColumn): Boolean;
var
  I: Integer;
  ACol: TSCTreeColumn;
begin
  Result := False;
  if (FColumns <> nil) and (FColumns.Count > 0) and
    (AColumn <> nil) and (AColumn.Owner = Self) and AColumn.Visible then
    for I := 0 to FColumns.Count-1 do
    begin
      ACol := TSCTreeColumn(FColumns[I]);
      if ACol.Visible then
      begin
        Result := ACol = AColumn;
        Break;
      end;
    end;
end;

function TSCCustomTreeList.LastVisibleColumn: TSCTreeColumn;
var
  I: Integer;
  ACol: TSCTreeColumn;
begin
  Result := nil;
  if (FColumns <> nil) and (FColumns.Count > 0) then
    for I := FColumns.Count-1 downto 0 do
    begin
      ACol := TSCTreeColumn(FColumns[I]);
      if ACol.Visible then
      begin
        Result := ACol;
        Break;
      end;
    end;
end;

function TSCCustomTreeList.NextVisibleColumn(AColumn: TSCTreeColumn): TSCTreeColumn;
var
  I, AIndex: Integer;
  ACol: TSCTreeColumn;
begin
  Result := nil;
  if (FColumns <> nil) and (FColumns.Count > 0) and
    ((AColumn = nil) or ((AColumn <> nil) and (AColumn.Owner = Self))) then
  begin
    AIndex := FColumns.IndexOf(AColumn);

    for I := AIndex + 1 to FColumns.Count-1 do
    begin
      ACol := TSCTreeColumn(FColumns[I]);
      if ACol.Visible then
      begin
        Result := ACol;
        Break;
      end;
    end;
  end;
end;

function TSCCustomTreeList.PriorVisibleColumn(AColumn: TSCTreeColumn): TSCTreeColumn;
var
  I, AIndex: Integer;
  ACol: TSCTreeColumn;
begin
  Result := nil;
  if (FColumns <> nil) and (FColumns.Count > 0) and
    (AColumn <> nil) and (AColumn.Owner = Self) then
  begin
    AIndex := FColumns.IndexOf(AColumn);

    for I := AIndex - 1 downto 0 do
    begin
      ACol := TSCTreeColumn(FColumns[I]);
      if ACol.Visible then
      begin
        Result := ACol;
        Break;
      end;
    end;
  end;
end;

function TSCCustomTreeList.CanCellSelect: Boolean;
begin
  Result := (sctboCellSelect in FOptionsBehaviour) or not CanRowSelect;
end;

function TSCCustomTreeList.CanCycleCells: Boolean;
begin
  Result := sctboCycleCells in FOptionsBehaviour;
end;

function TSCCustomTreeList.CanGoToNextCellOnEnter: Boolean;
begin
  Result := sctboGoToNextCellOnEnter in FOptionsBehaviour;
end;

function TSCCustomTreeList.CanGoToNextCellOnTab: Boolean;
begin
  Result := sctboGoToNextCellOnTab in FOptionsBehaviour;
end;

procedure TSCCustomTreeList.FocusChanged;
var
  ANode: TSCTreeNode;
  ACol: TSCTreeColumn;
begin
  inherited FocusChanged;

  if HandleAllocated and Self.Focused and
    (FRealList <> nil) and (FRealList.Count > 0) and
    not FStopSetFocused then
  begin
    ANode := FFocusedNode;
    if ANode = nil then
      SetFocusedNode(GetAbsoluteNode(0, True));

    if FColumns.Count > 0 then
    begin
      ACol := FFocusedColumn;
      if ACol = nil then
        SetFocusedColumn(FirstVisibleColumn);
    end;
  end;
end;

function TSCCustomTreeList.CanShowEditorOnEnter: Boolean;
begin
  Result := sctboShowEditorOnEnter in FOptionsBehaviour;
end;

procedure TSCCustomTreeList.GoToPriorCell(Key: Word);
var
  AKey: Word;
  ANode: TSCTreeNode;
  ACol: TSCTreeColumn;
  I, AIndex, ANextIndex: Integer;
begin
  if FFocusedNode = nil then
  begin
    if FRealList.Count > 0 then
    begin
      SetFocusedNode(GetAbsoluteNode(0, True));
      if FColumns.Count > 0 then
        SetFocusedColumn(FirstVisibleColumn);
    end;

    Exit;
  end;

  AKey := Key;

  ANode := FFocusedNode;
  ACol := FFocusedColumn;

  if (AKey = VK_LEFT) and ((FColumns.Count = 0) or
    (CanRowSelect and not CanCellSelect)) then
  begin
    Collapse(ANode);
    MakeNodeVisible(ANode, False);

    Exit;
  end;

  if FColumns.Count > 0 then
  begin
    ACol := PriorVisibleColumn(ACol);
    if (ACol = nil) and (FFocusedColumn = nil) then
      ACol := FirstVisibleColumn;

    if (ACol = nil) and CanCycleCells then
    begin
      AIndex := GetAbsoluteIndex(ANode, True);

      if AIndex > 0 then
      begin
        ANextIndex := AIndex;

        for I := AIndex - 1 downto 0 do
          if CanFocusNode(GetAbsoluteNode(I, True)) then
          begin
            ANextIndex := I;
            Break;
          end;

        if ANextIndex <> AIndex then
        begin
          ANode := GetAbsoluteNode(ANextIndex, True);

          if ANode <> nil then
          begin
            ACol := LastVisibleColumn;
            SetFocusedNode(ANode);
          end;
        end;
      end;
    end;

    if ACol <> nil then
      SetFocusedColumn(ACol);
  end;
end;

procedure TSCCustomTreeList.GoToNextCell(Key: Word);
var
  AKey: Word;
  ANode: TSCTreeNode;
  ACol: TSCTreeColumn;
  I, AIndex, ANextIndex: Integer;
begin
  if FFocusedNode = nil then
  begin
    if FRealList.Count > 0 then
    begin
      SetFocusedNode(GetAbsoluteNode(0, True));
      if FColumns.Count > 0 then
        SetFocusedColumn(FirstVisibleColumn);
    end;

    Exit;
  end;

  AKey := Key;
  if (AKey = VK_TAB) and not CanGoToNextCellOnTab then
    AKey := 0;

  if (AKey = VK_RETURN) and not CanGoToNextCellOnEnter then
    AKey := 0;

  if AKey = 0 then
    Exit;

  ANode := FFocusedNode;
  ACol := FFocusedColumn;

  if (AKey = VK_RIGHT) and ((FColumns.Count = 0) or
    (CanRowSelect and not CanCellSelect)) then
  begin
    Expand(ANode);
    MakeNodeVisible(ANode, False);

    Exit;
  end;

  if (FColumns.Count > 0) and (CanCellSelect or not CanRowSelect) then
  begin
    ACol := NextVisibleColumn(ACol);
    if (ACol = nil) and (FFocusedColumn = nil) then
      ACol := FirstVisibleColumn;

    if (ACol = nil) and CanCycleCells then
    begin
      AIndex := GetAbsoluteIndex(ANode, True);

      if AIndex < FRealList.Count-1 then
      begin
        ANextIndex := AIndex;

        for I := AIndex + 1 to FRealList.Count-1 do
          if CanFocusNode(GetAbsoluteNode(I, True)) then
          begin
            ANextIndex := I;
            Break;
          end;

        if ANextIndex <> AIndex then
        begin
          ANode := GetAbsoluteNode(ANextIndex, True);

          if ANode <> nil then
          begin
            ACol := FirstVisibleColumn;
            SetFocusedNode(ANode);
          end;
        end;
      end;
    end;

    if ACol <> nil then
      SetFocusedColumn(ACol);
  end else
  begin
    AIndex := GetAbsoluteIndex(ANode, True);

    if ANode = nil then
    begin
      ANode := GetAbsoluteNode(0, True);

      if CanFocusNode(ANode) then
      begin
        AIndex := 0;
        ANode := nil;
      end;
    end;

    if ANode <> nil then
    begin
      ANextIndex := AIndex;

      for I := AIndex + 1 to FRealList.Count-1 do
        if CanFocusNode(GetAbsoluteNode(I, True)) then
        begin
          ANextIndex := I;
          Break;
        end;

      if ANextIndex <> AIndex then
      begin
        ANode := GetAbsoluteNode(ANextIndex, True);
        if ANode <> nil then
          SetFocusedNode(ANode);
      end;
    end;
  end;
end;

function TSCCustomTreeList.CanMenuPopup(const Pos: TSmallPoint): Boolean;
begin
  Result := (FState in [sctlsIdle, sctlsNodeDown]) and
    inherited CanMenuPopup(Pos);
end;

procedure TSCCustomTreeList.WMContextMenu(var Message: TWMContextMenu);
begin
  if FState in [sctlsIdle, sctlsNodeDown] then
  begin
    inherited;
    Exit;
  end;

  DefaultHandler(Message);
end;

function TSCCustomTreeList.CanClearColumnOnRemove: Boolean;
begin
  Result := sctboClearColumnOnRemove in FOptionsBehaviour;
end;

procedure TSCCustomTreeList.ColumnRemoving(AColumn: TSCTreeColumn);
var
  I, AIndex: Integer;
  ANode: TSCTreeNode;
begin
  if HandleAllocated and (AColumn <> nil) and IsDestroying then
  begin
    if (FList <> nil) and CanClearColumnOnRemove then
    begin
      AIndex := FColumns.IndexOf(AColumn);

      if AIndex > -1 then
        for I := FList.Count-1 downto 0 do
        begin
          ANode := TSCTreeNode(FList[I]);
          ANode.RemoveString(AIndex, True);
        end;
    end;

    DoRemovingColumn(AColumn);
  end;
end;

{$IFDEF SC_DELPHIXE2_UP}
procedure TSCCustomTreeList.QuickSort(AList: TPointerList;
{$ELSE}
procedure TSCCustomTreeList.QuickSort(AList: PPointerList;
{$ENDIF}
  L, R: Integer);
var
  P, T: Pointer;
  I, J: Integer;
  N: TSCTreeNode;
begin
  repeat
    I := L;
    J := R;

    {$IFDEF SC_DELPHIXE2_UP}
    P := AList[(L + R) shr 1];
    {$ELSE}
    P := AList^[(L + R) shr 1];
    {$ENDIF}
    N := TSCTreeNode(P);

    repeat
      {$IFDEF SC_DELPHIXE2_UP}
      while CompareNodes(TSCTreeNode(AList[I]), N) < 0 do
      {$ELSE}
      while CompareNodes(TSCTreeNode(AList^[I]), N) < 0 do
      {$ENDIF}
        Inc(I);
        
      {$IFDEF SC_DELPHIXE2_UP}
      while CompareNodes(TSCTreeNode(AList[J]), N) > 0 do
      {$ELSE}
      while CompareNodes(TSCTreeNode(AList^[J]), N) > 0 do
      {$ENDIF}
        Dec(J);

      if I <= J then
      begin
        {$IFDEF SC_DELPHIXE2_UP}
        if CompareNodes(TSCTreeNode(AList[I]),
          TSCTreeNode(AList[J])) <> 0 then
        {$ELSE}
        if CompareNodes(TSCTreeNode(AList^[I]),
          TSCTreeNode(AList^[J])) <> 0 then
        {$ENDIF}
        begin
          {$IFDEF SC_DELPHIXE2_UP}
          T := AList[I];
          AList[I] := AList[J];
          AList[J] := T;
          {$ELSE}
          T := AList^[I];
          AList^[I] := AList^[J];
          AList^[J] := T;
          {$ENDIF}
        end;

        Inc(I);
        Dec(J);
      end;
    until I > J;

    if L < J then
      QuickSort(AList, L, J);

    L := I;
  until I >= R;
end;

function TSCCustomTreeList.CompareNodes(N1, N2: TSCTreeNode): Integer;
var
  S1, S2: String;
  Index: Integer;
  SortDir: TSCTreeSortDirection;
begin
  Result := 0;
  if Assigned(FOnCompare) then
    FOnCompare(Self, N1, N2, Result)
  else
  if N1 <> N2 then
  begin
    Index := GetSortingColumn;
    if (FColumns.Count > 0) and (Index = -1) then
      Exit;

    SortDir := sctsdDown;
    if Index > -1 then
      SortDir := TSCTreeColumn(FColumns[Index]).SortDirection;

    S1 := N1.GetString(0);
    S2 := N2.GetString(0);

    if Index > 0 then
    begin
      S1 := N1.GetString(Index);
      S2 := N2.GetString(Index);
    end;
    
    if Self.CanAnsiSort then
      Result := AnsiCompareStr(S1, S2)
    else Result := CompareStr(S1, S2);

    if SortDir = sctsdUp then
      Result := -Result;
  end;
end;

procedure TSCCustomTreeList.SortNode(ANode: TSCTreeNode);
var
  L: TList;
  I: Integer;
begin
  L := ANode.FList;
  if (L <> nil) and (L.Count > 0) then
  begin
    QuickSort(L.List, 0, L.Count-1);
    for I := 0 to L.Count-1 do
      SortNode(ANode[I]);
  end;
end;

function TSCCustomTreeList.GetSortedColumn: TSCTreeColumn;
var
  Index: Integer;
begin
  Result := nil;

  Index := GetSortingColumn;
  if (FColumns <> nil) and (Index > -1) and (Index < FColumns.Count) then
    Result := TSCTreeColumn(FColumns[Index]);
end;

function TSCCustomTreeList.GetSortingColumn: Integer;
var
  I: Integer;
  ACol: TSCTreeColumn;
begin
  Result := -1;
  if (FColumns <> nil) and (FColumns.Count > 0) then
    for I := 0 to FColumns.Count-1 do
    begin
      ACol := TSCTreeColumn(FColumns[I]);
      if ACol.SortDirection <> sctsdNone then
      begin
        Result := I;
        Break;
      end;
    end;
end;

procedure TSCCustomTreeList.ColumnSortChanged(AColumn: TSCTreeColumn;
  var SortDir: TSCTreeSortDirection);
var
  I: Integer;
  Col: TSCTreeColumn;
begin
  if AColumn <> nil then
  begin
    if AColumn.DisableSorting or not CanAllowSorting then
    begin
      SortDir := sctsdNone;
      Exit;
    end;

    AColumn.FSortDirection := SortDir;

    for I := 0 to FColumns.Count-1 do
    begin
      Col := TSCTreeColumn(FColumns[I]);
      if Col <> AColumn then
        Col.FSortDirection := sctsdNone;
    end;

    UpdateHeader;
    if SortDir <> sctsdNone then
      SortNodes(True);
  end;
end;

function TSCCustomTreeList.ToggleSort(
  SortDir: TSCTreeSortDirection): TSCTreeSortDirection;
begin
  Result := sctsdUp;
  if SortDir in [sctsdNone, sctsdUp] then
    Result := sctsdDown;
end;

function TSCCustomTreeList.CanAllowSorting: Boolean;
begin
  Result := sctboAllowSorting in FOptionsBehaviour;
end;

procedure TSCCustomTreeList.ChangeCursor(ACursor: TCursor);
begin
  FCursorChange := True;
  try
    if Cursor <> ACursor then Cursor := ACursor;
  finally
    FCursorChange := False;
  end;
end;

function TSCCustomTreeList.CaptureFocus(ProcessEvents: Boolean): Boolean;
begin
  FStopSetFocused := True;
  try
    Result := inherited CaptureFocus(ProcessEvents);
  finally
    FStopSetFocused := False;
  end;
end;

function TSCCustomTreeList.GetEditorRect(ACell: TSCTreeCell): TRect;
var
  CR: TRect;
  Ph: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  if HandleAllocated and (ACell.Node <> nil) then
  begin
    CR := GetNodesRect;
    if IsShowIndicator then
      Inc(CR.Left, FIndicator);

    if not IsRectEmpty(CR) then
    begin
      if FColumns.Count > 0 then
        Result := GetCellRect(ACell, False)
      else begin
        Result := GetNodeRect(ACell.Node, True);

        Inc(Result.Right, 10);

        if IsInspectorNetStyle then
          Inc(Result.Left, 2);

        if IsShowPreview then
        begin
          Ph := GetPreviewHeight(ACell.Node);

          if Ph > 0 then
          begin
            Dec(Result.Bottom, Ph);
            if Result.Bottom < Result.Top then
              Result.Bottom := Result.Top;
          end;
        end;
      end;

      if IsShowLineHorizontal and IsShowLineVertical and
        (FColumns.Count > 0) and (FLookAndFeel = sctlfDefault) then
      begin
        Inc(Result.Top);
        Dec(Result.Right);
      end;

      if IsOutlookStyle then
        Inc(Result.Bottom);

      IntersectRect(Result, Result, CR);

      if Result.Left > Result.Right then
        Result.Right := Result.Left;

      DoSizeEditor(ACell, Result);

      if Result.Left < CR.Left then
        Result.Left := CR.Left;

      if Result.Right > CR.Right then
        Result.Right := CR.Right;

      if Result.Left > Result.Right  then
        Result.Right := Result.Left;
        
      if Result.Top  > Result.Bottom then
        Result.Bottom := Result.Top;
    end;
  end;
end;

procedure TSCCustomTreeList.WMCancelMode(var Msg: TMessage);
begin
  CancelDragSize;
  inherited;
end;

function TSCCustomTreeList.IsOffice12Style: Boolean;
begin
  Result := FPaintStyle = sctpsOffice12;
end;

procedure TSCCustomTreeList.DrawOffice12Cell(ACanvas: TCanvas;
  ARect: TRect; AColor: TColor; Invert: Boolean; AFrame: Boolean);
var
  R: TRect;
  ClStart, ClEnd: TColor;
begin
  if (AColor <> clNone) and not IsRectEmpty(ARect) then
  begin
    AColor := BlendedColor(AColor, 16, 16, 16, True);

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

    if AFrame then
    begin
      R := ARect;
      InflateRect(R, -1, -1);

      ClStart := GetGradientPreLight(AColor);
      scFrame3D(Canvas, R, ClStart, ClStart, 1, 0);

      R := ARect;

      ClStart := GetGradientPreDark(AColor);
      scFrame3D(Canvas, R, ClStart, ClStart, 1, 0);
    end;
  end;
end;

procedure TSCCustomTreeList.DrawOffice12Face(ACanvas: TCanvas;
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

function TSCCustomTreeList.GetGradientDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -32);
end;

function TSCCustomTreeList.GetGradientExDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -40);
end;

function TSCCustomTreeList.GetGradientExLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 40);
end;

function TSCCustomTreeList.GetGradientLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 30);
end;

function TSCCustomTreeList.GetGradientPeal(AColor: TColor): TColor;
begin
  Result := BlendedColor(AColor, 52, 44, 112, True);
end;

function TSCCustomTreeList.GetGradientPreDark(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -80);
end;

function TSCCustomTreeList.GetGradientPreLight(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, 80);
end;

function TSCCustomTreeList.GetGradientShadow(AColor: TColor): TColor;
begin
  Result := scBlendColor(AColor, -6);
end;

procedure TSCCustomTreeList.PreviewFontChanged(Sender: TObject);
begin
  Canvas.Font.Assign(Self.HeaderFont);
  FPreviewHeight := Canvas.TextHeight('Rq') + SC_TreePreviewSpace;

  if IsShowPreview then
  begin
    Invalidate;
    if (FList <> nil) and (FList.Count > 0) then
      UpdateScrollbars(True, True);
  end;
end;

procedure TSCCustomTreeList.SetPreviewFont(Value: TFont);
begin
  FPreviewFont.Assign(Value);
end;

function TSCCustomTreeList.GetPreviewHeight: Integer;
begin
  Result := 0;

  if HandleAllocated and IsShowPreview then
  begin
    if (FPreviewHeight = -1) and (FPreviewFont <> nil) then
    begin
      Canvas.Font.Assign(FPreviewFont);
      FPreviewHeight := Canvas.TextHeight('Rq') + SC_TreePreviewSpace;
    end;

    Result := FPreviewHeight;
    if Result < 0 then Result := 0;
  end;
end;

function TSCCustomTreeList.GetPreviewHeight(ANode: TSCTreeNode): Integer;
var
  Allow: Boolean;
begin
  Result := 0;

  if HandleAllocated and IsShowPreview and (ANode <> nil) then
  begin
    Allow := ANode.Preview;
    if Assigned(FOnPreviewEvent) then
      FOnPreviewEvent(Self, ANode, Allow);

    if Allow then
    begin
      Result := Self.GetPreviewHeight;
      if Result < 0 then Result := 0;
    end;
  end;
end;

function TSCCustomTreeList.IsShowPreview: Boolean;
begin
  Result := sctvoShowPreview in FOptionsView;
end;

function TSCCustomTreeList.GetCellHeight: Integer;
begin
  Result := GetNodeHeight;

  if HandleAllocated and IsShowPreview then
  begin
    Dec(Result, GetPreviewHeight);
    if Result < 0 then Result := 0;
  end;
end;

procedure TSCCustomTreeList.SetPreviewAlignment(Value: TLeftRight);
begin
  if FPreviewAlignment <> Value then
  begin
    FPreviewAlignment := Value;
    if IsShowPreview then
      Invalidate;
  end;
end;

procedure TSCCustomTreeList.NCMouseEnter(var HitTest: Integer; X,
  Y: Integer);
begin
  inherited NCMouseEnter(HitTest, X, Y);
  if not NCIsDown then
    MouseInControlChanged;
end;

procedure TSCCustomTreeList.BeginAutoDrag;
begin
  if not IsDesigning then
    inherited BeginAutoDrag;
end;

{ TSCTreeBorderProps }

constructor TSCTreeBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccb3DLowered;
end;

{ TSCTreeColors }

procedure TSCTreeColors.Assign(Source: TPersistent);
begin
  if Source is TSCTreeColors then
  begin
    with TSCTreeColors(Source) do
    begin
      Self.FArrowColor := ArrowColor;
      Self.FArrowFrameColor := ArrowFrameColor;
      Self.FCellFocusColor := CellFocusColor;
      Self.FCellFocusTextColor := CellFocusTextColor;
      Self.FChildIndicatorColor := ChildIndicatorColor;
      Self.FDisabledColor := DisabledColor;
      Self.FDisabledTextColor := DisabledTextColor;
      Self.FFlashColor := FlashColor;
      Self.FFlashTextColor := FlashTextColor;
      Self.FGridLineColor := GridLineColor;
      Self.FGroupColor := GroupColor;
      Self.FGroupTextColor := GroupTextColor;
      Self.FHeaderColor := HeaderColor;
      Self.FHideSelectionColor := HideSelectionColor;
      Self.FHideSelectionTextColor := HideSelectionTextColor;
      Self.FHighlightColor := HighlightColor;
      Self.FHighlightTextColor := HighlightTextColor;
      Self.FIndentColor := IndentColor;
      Self.FIndicatorColor := IndicatorColor;
      Self.FLineColor := LineColor;
      Self.FOutlookColor := OutlookColor;
      Self.FOutlookTextColor := OutlookTextColor;
      Self.FSortArrowColor := SortArrowColor;
      Self.FUnderlineColor := UnderlineColor;
    end;

    Changed;
  end else
    inherited Assign(Source);
end;

procedure TSCTreeColors.Changed;
begin
  if FOwner <> nil then
    FOwner.ColorsChanged;
end;

constructor TSCTreeColors.Create(AOwner: TSCCustomTreeList);
begin
  inherited Create;
  FOwner := AOwner;

  FArrowColor := clLime;
  FArrowFrameColor := clGreen;
  FCellFocusColor := clWindow;
  FCellFocusTextColor := clWindowText;
  FChildIndicatorColor := clBtnText;
  FDisabledColor := clBtnFace;
  FDisabledTextColor := clGrayText;
  FFlashColor := clRed;
  FFlashTextColor := clWhite;
  FGridLineColor := clBtnFace;
  FGroupColor := clBtnFace;
  FGroupTextColor := clBtnText;
  FHeaderColor := clBtnFace;
  FHideSelectionColor := clBtnFace;
  FHideSelectionTextColor := clBtnText;
  FHighlightColor := clHighlight;
  FHighlightTextColor := clHighlightText;
  FIndentColor := clNone;
  FIndicatorColor := clBtnFace;
  FIndicatorForeColor := clBtnText;
  FLineColor := clGrayText;
  FOutlookColor := clBtnFace;
  FOutlookTextColor := clBtnText;
  FSortArrowColor := clBtnText;
  FUnderlineColor := clRed;
end;

function TSCTreeColors.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCTreeColors.SetArrowColor(Value: TColor);
begin
  if FArrowColor <> Value then
  begin
    FArrowColor := Value;
    if (FOwner <> nil) and FOwner.IsShowHeader then
      Changed;
  end;
end;

procedure TSCTreeColors.SetArrowFrameColor(Value: TColor);
begin
  if FArrowFrameColor <> Value then
  begin
    FArrowFrameColor := Value;
    if (FOwner <> nil) and FOwner.IsShowHeader then
      Changed;
  end;
end;

procedure TSCTreeColors.SetCellFocusColor(Value: TColor);
begin
  if FCellFocusColor <> Value then
  begin
    FCellFocusColor := Value;
    Changed;
  end;
end;

procedure TSCTreeColors.SetCellFocusTextColor(Value: TColor);
begin
  if FCellFocusTextColor <> Value then
  begin
    FCellFocusTextColor := Value;
    Changed;
  end;
end;

procedure TSCTreeColors.SetChildIndicatorColor(Value: TColor);
begin
  if FChildIndicatorColor <> Value then
  begin
    FChildIndicatorColor := Value;
    if (FOwner <> nil) and FOwner.IsShowChildIndicator then
      Changed;
  end;
end;

procedure TSCTreeColors.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    Changed;
  end;
end;

procedure TSCTreeColors.SetDisabledTextColor(Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    Changed;
  end;
end;

procedure TSCTreeColors.SetFlashColor(Value: TColor);
begin
  if FFlashColor <> Value then
  begin
    FFlashColor := Value;
    if (FOwner <> nil) and FOwner.Flashing then
      Changed;
  end;
end;

procedure TSCTreeColors.SetFlashTextColor(Value: TColor);
begin
  if FFlashTextColor <> Value then
  begin
    FFlashTextColor := Value;
    if (FOwner <> nil) and FOwner.Flashing then
      Changed;
  end;
end;

procedure TSCTreeColors.SetGridLineColor(Value: TColor);
begin
  if FGridLineColor <> Value then
  begin
    FGridLineColor := Value;
    if (FOwner <> nil) and FOwner.IsOutlookStyle then
      Changed;
  end;
end;

procedure TSCTreeColors.SetGroupColor(Value: TColor);
begin
  if FGroupColor <> Value then
  begin
    FGroupColor := Value;
    if (FOwner <> nil) and FOwner.IsGrouping then
      Changed;
  end;
end;

procedure TSCTreeColors.SetGroupTextColor(Value: TColor);
begin
  if FGroupTextColor <> Value then
  begin
    FGroupTextColor := Value;
    if (FOwner <> nil) and FOwner.IsGrouping then
      Changed;
  end;
end;

procedure TSCTreeColors.SetHeaderColor(Value: TColor);
begin
  if FHeaderColor <> Value then
  begin
    FHeaderColor := Value;
    if (FOwner <> nil) and FOwner.IsShowHeader then
      Changed;
  end;
end;

procedure TSCTreeColors.SetHideSelectionColor(Value: TColor);
begin
  if FHideSelectionColor <> Value then
  begin
    FHideSelectionColor := Value;
    Changed;
  end;
end;

procedure TSCTreeColors.SetHideSelectionTextColor(Value: TColor);
begin
  if FHideSelectionTextColor <> Value then
  begin
    FHideSelectionTextColor := Value;
    Changed;
  end;
end;

procedure TSCTreeColors.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    Changed;
  end;
end;

procedure TSCTreeColors.SetHighlightTextColor(Value: TColor);
begin
  if FHighlightTextColor <> Value then
  begin
    FHighlightTextColor := Value;
    Changed;
  end;
end;

procedure TSCTreeColors.SetIndentColor(Value: TColor);
begin
  if FIndentColor <> Value then
  begin
    FIndentColor := Value;
    if (FOwner <> nil) and FOwner.IsOutlookStyle then
      Changed;
  end;
end;

procedure TSCTreeColors.SetIndicatorColor(Value: TColor);
begin
  if FIndicatorColor <> Value then
  begin
    FIndicatorColor := Value;
    if (FOwner <> nil) and FOwner.IsShowIndicator then
      Changed;
  end;
end;

procedure TSCTreeColors.SetIndicatorForeColor(Value: TColor);
begin
  if FIndicatorForeColor <> Value then
  begin
    FIndicatorForeColor := Value;
    if (FOwner <> nil) and FOwner.IsShowIndicator then
      Changed;
  end;
end;

procedure TSCTreeColors.SetLineColor(Value: TColor);
begin
  if FLineColor <> Value then
  begin
    FLineColor := Value;
    if (FOwner <> nil) and FOwner.IsShowTreeLine then
      Changed;
  end;
end;

procedure TSCTreeColors.SetOutlookColor(Value: TColor);
begin
  if FOutlookColor <> Value then
  begin
    FOutlookColor := Value;
    if (FOwner <> nil) and FOwner.IsOutlookStyle then
      Changed;
  end;
end;

procedure TSCTreeColors.SetOutlookTextColor(Value: TColor);
begin
  if FOutlookTextColor <> Value then
  begin
    FOutlookTextColor := Value;
    if (FOwner <> nil) and FOwner.IsOutlookStyle then
      Changed;
  end;
end;

procedure TSCTreeColors.SetSortArrowColor(Value: TColor);
begin
  if FSortArrowColor <> Value then
  begin
    FSortArrowColor := Value;
    Changed;
  end;
end;

procedure TSCTreeColors.SetUnderlineColor(Value: TColor);
begin
  if FUnderlineColor <> Value then
  begin
    FUnderlineColor := Value;
    Changed;
  end;
end;

{ TSCTreeButton }

procedure TSCTreeButton.Assign(Source: TPersistent);
begin
  if Source is TSCTreeButton then
  begin
    with TSCTreeButton(Source) do
    begin
      Self.FBackColor := BackColor;
      Self.FFrameColor := FrameColor;
      Self.FForeColor := ForeColor;
      Self.FStyle := Style;
      Self.FWidth := Width;
    end;

    Changed;
  end else
    inherited Assign(Source);
end;

procedure TSCTreeButton.Changed;
begin
  if FOwner <> nil then
    FOwner.ButtonChanged;
end;

constructor TSCTreeButton.Create(AOwner: TSCCustomTreeList);
begin
  inherited Create;
  FOwner := AOwner;
  FBackColor := clWindow;
  FFrameColor := clGrayText;
  FForeColor := clBtnText;
  FStyle := sctbsDefault;
  FWidth := -1;
end;

function TSCTreeButton.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCTreeButton.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Changed;
  end;
end;

procedure TSCTreeButton.SetForeColor(Value: TColor);
begin
  if FForeColor <> Value then
  begin
    FForeColor := Value;
    Changed;
  end;
end;

procedure TSCTreeButton.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Changed;
  end;
end;

procedure TSCTreeButton.SetStyle(Value: TSCTreeButtonStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Changed;
  end;
end;

procedure TSCTreeButton.SetWidth(Value: Integer);
begin
  if Value < -1 then Value := -1;

  if FWidth <> Value then
  begin
    FWidth := Value;
    Changed;
  end;
end;

{ TSCTreeHottrack }

procedure TSCTreeHottrack.Assign(Source: TPersistent);
begin
  if Source is TSCTreeHottrack then
  begin
    with TSCTreeHottrack(Source) do
    begin
      Self.FColor := Color;
      Self.FTextColor := TextColor;
      Self.FUnderline := Underline;
    end;

    Changed;
  end else
    inherited Assign(Source);
end;

procedure TSCTreeHottrack.Changed;
begin
  if FOwner <> nil then FOwner.HottrackChanged;
end;

constructor TSCTreeHottrack.Create(AOwner: TSCCustomTreeList);
begin
  inherited Create;
  FOwner := AOwner;

  FColor := clNone;
  FTextColor := clBlue;
  FUnderline := False;
end;

function TSCTreeHottrack.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCTreeHottrack.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed;
  end;
end;

procedure TSCTreeHottrack.SetTextColor(Value: TColor);
begin
  if FTextColor <> Value then
  begin
    FTextColor := Value;
    Changed;
  end;
end;

procedure TSCTreeHottrack.SetUnderline(Value: Boolean);
begin
  if FUnderline <> Value then
  begin
    FUnderline := Value;
    Changed;
  end;
end;

initialization
  Screen.Cursors[SC_TreeDragCopy] := LoadCursor(HInstance, 'SC_TREELIST_DRAGCOPY');
  Screen.Cursors[SC_TreeMultiDragCopy] := LoadCursor(HInstance, 'SC_TREELIST_MULTIDRAGCOPY');
  Screen.Cursors[SC_TreeUpScroll] := LoadCursor(HInstance, 'SC_TREELIST_UPSCROLL');
  Screen.Cursors[SC_TreeDownScroll] := LoadCursor(HInstance, 'SC_TREELIST_DOWNSCROLL');
  Screen.Cursors[SC_TreeFullScroll] := LoadCursor(HInstance, 'SC_TREELIST_FULLSCROLL');
  Screen.Cursors[SC_TreeHSize] := LoadCursor(HInstance, 'SC_TREELIST_HSIZE');
  Screen.Cursors[SC_TreeVSize] := LoadCursor(HInstance, 'SC_TREELIST_VSIZE');

end.
