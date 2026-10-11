{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCFontsAndColors;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCommon, SCConsts, SCControl, SCSimpleListbox, SCEdits, SCAdvEdits;

type
  TSCFontType = (scftTrueType, scftDevice, scftRaster);
  TSCFontTypes = set of TSCFontType;

  TSCFontDisplayStyle = (scdsFontName, scdsFontStyle, scdsFontNameAndStyle);

  TSCCustomFontListbox = class(TSCCustomSimpleListbox)
  private
    FSampleText: String;
    FFontCharSet: TFontCharset;
    FFontCharsetActive: Boolean;
    FFontTypes: TSCFontTypes;
    FDisplayStyle: TSCFontDisplayStyle;
    FShowImages: Boolean;
    FTrueTypeBmp: TBitmap;
    procedure SetDisplayStyle(Value: TSCFontDisplayStyle);
    procedure SetFontCharSet(Value: TFontCharset);
    procedure SetFontCharsetActive(Value: Boolean);
    function  GetFontName: TFontName;
    procedure SetFontName(const Value: TFontName);
    function  GetFontNames(Index: Integer): String;
    procedure SetFontTypes(Value: TSCFontTypes);
    procedure SetSampleText(const Value: String);
    procedure SetShowImages(Value: Boolean);
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure RefreshFontNames; dynamic;
    procedure LoadFontImages; dynamic;

    function  GetMaxWidth: Integer; override;
    procedure DoDrawItem(C: TCanvas; Index: Integer; CR, R: TRect; State: TSCSimpleListState); override;

    procedure VerifyHorizontalPos(var P: Integer); override;
    function  CanShowEditor: Boolean; override;
    procedure BeforePaintItem(C: TCanvas; Index: Integer; ClientR, R: TRect;
      State: TSCSimpleListState); override;

    property AllowEdit default False;
    property DisplayStyle: TSCFontDisplayStyle read FDisplayStyle write SetDisplayStyle default scdsFontName;
    property FontCharSet: TFontCharset read FFontCharSet write SetFontCharSet default DEFAULT_CHARSET;
    property FontCharsetActive: Boolean read FFontCharsetActive write SetFontCharsetActive default True;
    property FontName: TFontName read GetFontName write SetFontName;
    property FontNames[Index: Integer]: String read GetFontNames;
    property FontTypes: TSCFontTypes read FFontTypes write SetFontTypes default [scftTrueType, scftDevice, scftRaster];
    property Indent default 20;
    property SampleText: String read FSampleText write SetSampleText;
    property ScrollbarHorizontal default False;
    property ScrollbarVertical default True;
    property ShowImages: Boolean read FShowImages write SetShowImages default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCFontListbox = class(TSCCustomFontListbox)
  public
    property Count;
    property Objects;
    property Checked;
    property State;
    property HotIndex;
    property ItemIndex;
    property Selected;
    property TopIndex;
    property FontNames;
  published
    property Align;
    property AllowGrayed;
    property Anchors;
    property BorderProps;
    property CenterImages;
    property Color;
    property Colors;
    property Constraints;
    property DisplayStyle;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Flat;
    property Font;
    property FontCharSet;
    property FontCharsetActive;
    property FontName;
    property FontTypes;
    property HideFocusRect;
    property HideSelection;
    property Hottrack;
    property HottrackColor;
    property HottrackUnderline;
    property ItemHeight;
    property MultiSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property SampleText;
    property Scrollbars;
    property ShowCheckboxes;
    property ShowItemHints;
    property ShowHint;
    property ShowImages;
    property ShowSizeGrip;
    property StatusbarAlignment;
    property ShowStatusbar;
    property StatusbarColor;
    property StatusbarText;
    property TabOrder;
    property TabStop;
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
    property OnResize;
    property OnShowItemHint;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCFontComboEditColors = class(TSCCustomFrameEditColors)
  published
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

  TSCCustomFontCombobox = class(TSCCustomCombobox)
  private
    FFontMemory: String;
    FSampleText: String;
    FFontCharSet: TFontCharset;
    FFontCharsetActive: Boolean;
    FFontTypes: TSCFontTypes;
    FDisplayStyle: TSCFontDisplayStyle;
    FMRUCount: Integer;
    FShowImages: Boolean;
    FTrueTypeBmp: TBitmap;
    procedure SetFontCharSet(Value: TFontCharset);
    procedure SetFontCharsetActive(Value: Boolean);
    function  GetFontName: TFontName;
    procedure SetFontName(const Value: TFontName);
    procedure SetFontTypes(Value: TSCFontTypes);
    procedure SetMRUCount(Value: Integer);
    procedure SetSampleText(const Value: String);
    procedure SetShowImages(Value: Boolean);
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure RefreshFontNames; dynamic;
    procedure LoadFontImages; dynamic;

    procedure DoDrawBack(C: TCanvas); override;
    function  GetListboxClass: TSCSimpleListboxClass; override;
    function  GetEditColorsClass: TSCEditCustomColorsClass; override;

    procedure UpdateBorderRect(var R: TRect); override;
    function  GetDropDownHeight: Integer; override;
    procedure PrepareDropWindow; override;
    procedure BeforePrepareDropWindow; override;
    procedure AfterCloseUp; override;
    function  ItemCheckStateForCloseup(Index: Integer): TSCCheckState; override;

    property AutoComplete default True;
    property DisplayStyle: TSCFontDisplayStyle read FDisplayStyle write FDisplayStyle default scdsFontName;
    property DropDownCount default 12;
    property FontCharSet: TFontCharset read FFontCharSet write SetFontCharSet default DEFAULT_CHARSET;
    property FontCharsetActive: Boolean read FFontCharsetActive write SetFontCharsetActive default True;
    property FontName: TFontName read GetFontName write SetFontName;
    property FontTypes: TSCFontTypes read FFontTypes write SetFontTypes default [scftTrueType, scftDevice, scftRaster];
    property MRUCount: Integer read FMRUCount write SetMRUCount default 5;
    property SampleText: String read FSampleText write SetSampleText;
    property ShowImages: Boolean read FShowImages write SetShowImages default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCFontCombobox = class(TSCCustomFontCombobox)
  public
    property Checked;
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
    property ButtonProps;
    property CanEdit;
    property CharCase;
    property CheckStyle;
    property Color;
    property Colors;
    property Constraints;
    property DblClickReverts;
    property DisplayStyle;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownKey;
    property EditCursor;
    property EditMode;
    property Enabled;
    property EndEllipsis;
    property EnterAsTab;
    property FocusExpandSize;
    property Font;
    property FontCharSet;
    property FontCharsetActive;
    property FontName;
    property FontTypes;
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
    property Layout;
    property MaxLength;
    property MRUCount;
    {$IFDEF SC_DELPHI2009_EARLY}
    property OEMConvert;
    {$ENDIF}
    property PopupProps;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property Revertable;
    property SampleText;
    property ShowCheckboxes;
    property ShowHint;
    property ShowImages;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseImage;
    property Visible;
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

  TSCColorItem = class(TCollectionItem)
  private
    FCaption: String;
    FColor: TColor;
    FID: Integer;
    FChanged: Byte;
    FUpdateCount: Integer;
    procedure SetCaption(const Value: String);
    procedure SetColor(Value: TColor);
  protected
    procedure DoChanged(AllItems: Boolean); dynamic;
    function  GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;

    procedure BeginUpdate;
    procedure EndUpdate;
    function  InUpdate: Boolean;

    property ID: Integer read FID write FID;
  published
    property Caption: String read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor default clNone;
  end;

  TSCColorItems = class;

  TSCColorUpdateEvent = procedure(Sender: TSCColorItems; Item: TCollectionItem) of object;

  TSCColorItems = class(TCollection)
  private
    FOwner: TSCCustomControl;
    FOnUpdate: TSCColorUpdateEvent;
    function  GetItem(Index: Integer): TSCColorItem;
    procedure SetItem(Index: Integer; Value: TSCColorItem);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;

    property OnUpdate: TSCColorUpdateEvent read FOnUpdate write FOnUpdate;
  public
    constructor Create(AOwner: TSCCustomControl); virtual;
    function Add: TSCColorItem;
    property Items[Index: Integer]: TSCColorItem read GetItem write SetItem; default;

    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomControl read FOwner;
    {$ENDIF}
  end;

  TSCColorOption = (sccoShowAutoColor, sccoShowColorNone, sccoShowStandardColors,
    sccoShowSystemColors, sccoShowWebSafeColors, sccoShowCustomColors);
  TSCColorOptions = set of TSCColorOption;

  TSCGetColorEvent = procedure(Sender: TObject; Color: TColor; var Caption: String) of object;

  TSCColorDisplayType = (scdtColors, scdtNames, scdtColorsAndNames);

  TSCCustomColorListbox = class(TSCCustomSimpleListbox)
  private
    FAutoCaption: String;
    FAutoColor: TColor;
    FColorWidth: Integer;
    FCustomColors: TSCColorItems;
    FDisplayType: TSCColorDisplayType;
    FOptions: TSCColorOptions;
    FSelectedColor: TColor;
    FOnGetColor: TSCGetColorEvent;
    FOnSetColor: TNotifyEvent;
    procedure SetAutoCaption(Value: String);
    procedure SetAutoColor(Value: TColor);
    procedure SetColorWidth(Value: Integer);
    procedure SetCustomColors(Value: TSCColorItems);
    procedure SetDisplayType(Value: TSCColorDisplayType);
    procedure SetOptions(Value: TSCColorOptions);
    procedure SetSelectedColor(Value: TColor);
    procedure CustomColorsChanged(Sender: TSCColorItems; Item: TCollectionItem);
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure IndentChanged; override;
    procedure RefreshColors; dynamic;

    procedure SystemColorsChanged; override;

    function  GetAutoCaption: String; virtual;
    function  GetMaxWidth: Integer; override;

    procedure DoItemClick(Index: Integer); override;
    procedure VerifyHorizontalPos(var P: Integer); override;
    function  CanShowEditor: Boolean; override;

    procedure BeforePaintItem(C: TCanvas; Index: Integer; ClientR, R: TRect;
      State: TSCSimpleListState); override;
    procedure DoDrawItem(C: TCanvas; Index: Integer; CR, R: TRect; State: TSCSimpleListState); override;

    property AllowEdit default False;
    property AutoCaption: String read FAutoCaption write SetAutoCaption;
    property AutoColor: TColor read FAutoColor write SetAutoColor default clNone;
    property ColorWidth: Integer read FColorWidth write SetColorWidth default 24;
    property CustomColors: TSCColorItems read FCustomColors write SetCustomColors;
    property DisplayType: TSCColorDisplayType read FDisplayType write SetDisplayType default scdtColorsAndNames;
    property EndEllipsis default True;
    property Indent default 24;
    property Options: TSCColorOptions read FOptions write SetOptions default [sccoShowStandardColors];
    property ScrollbarHorizontal default False;
    property ScrollbarVertical default True;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clNone;
    property OnGetColor: TSCGetColorEvent read FOnGetColor write FOnGetColor;
    property OnSetColor: TNotifyEvent read FOnSetColor write FOnSetColor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCColorListbox = class(TSCCustomColorListbox)
  public
    property Count;
    property Objects;
    property Checked;
    property State;
    property HotIndex;
    property ItemIndex;
    property Selected;
    property TopIndex;
  published
    property Align;
    property AllowGrayed;
    property Anchors;
    property AutoCaption;
    property AutoColor;
    property BorderProps;
    property CenterImages;
    property Color;
    property Colors;
    property ColorWidth;
    property Constraints;
    property CustomColors;
    property DisplayType;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Flat;
    property Font;
    property HideFocusRect;
    property HideSelection;
    property Hottrack;
    property HottrackColor;
    property HottrackUnderline;
    property ItemHeight;
    property MultiSelect;
    property Options;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Scrollbars;
    property SelectedColor;
    property ShowCheckboxes;
    property ShowItemHints;
    property ShowHint;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
    property TabOrder;
    property TabStop;
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
    property OnGetColor;
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
    property OnResize;
    property OnSetColor;
    property OnShowItemHint;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCModeStyleComboEditColors = class(TSCCustomFrameEditColors)
  published
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

  TSCCustomColorCombobox = class(TSCCustomCombobox)
  private
    FAutoCaption: String;
    FAutoColor: TColor;
    FColorWidth: Integer;
    FCustomColors: TSCColorItems;
    FDisplayType: TSCColorDisplayType;
    FOptions: TSCColorOptions;
    FSelectedColor: TColor;
    FOnGetColor: TSCGetColorEvent;
    FOnSetColor: TNotifyEvent;
    procedure SetAutoCaption(const Value: String);
    procedure SetAutoColor(Value: TColor);
    procedure SetColorWidth(Value: Integer);
    procedure SetCustomColors(Value: TSCColorItems);
    procedure SetDisplayType(Value: TSCColorDisplayType);
    procedure SetOptions(Value: TSCColorOptions);
    procedure SetSelectedColor(Value: TColor);
    procedure CustomColorsChanged(Sender: TSCColorItems;
       Item: TCollectionItem);
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure RefreshColors; dynamic;

    procedure SystemColorsChanged; override;

    function  GetIsDropDown: Boolean; override;
    procedure PaintLine(C: TCanvas; Index, H, TxTop: Integer); override;

    procedure DoDrawBack(C: TCanvas); override;
    procedure DoInternalChange; override;
    procedure DoListClick(Index: Integer; const Item: String); override;

    function  GetListboxClass: TSCSimpleListboxClass; override;
    function  GetEditColorsClass: TSCEditCustomColorsClass; override;

    procedure UpdateBorderRect(var R: TRect); override;
    function  GetAutoCaption: String; virtual;
    procedure PrepareDropWindow; override;
    procedure AfterCloseUp; override;
    procedure UpdateColorText;

    property AutoCaption: String read FAutoCaption write SetAutoCaption;
    property AutoColor: TColor read FAutoColor write SetAutoColor default clNone;
    property AutoComplete default True;
    property ColorWidth: Integer read FColorWidth write SetColorWidth default 24;
    property CustomColors: TSCColorItems read FCustomColors write SetCustomColors;
    property DisplayType: TSCColorDisplayType read FDisplayType write SetDisplayType default scdtColorsAndNames;
    property DropDownCount default 12;
    property ImmediateDropDown default True;
    property IsDropDown default True;
    property Options: TSCColorOptions read FOptions write SetOptions default [sccoShowStandardColors];
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clNone;
    property OnGetColor: TSCGetColorEvent read FOnGetColor write FOnGetColor;
    property OnSetColor: TNotifyEvent read FOnSetColor write FOnSetColor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCColorCombobox = class(TSCCustomColorCombobox)
  public
    property Checked;
  published
    property Align;
    property Alignment;
    property AllowGrayed;
    property Anchors;
    property AutoCaption;
    property AutoColor;
    property AutoComplete;
    property AutoSelect;
    property AutoSize;
    property AutoWidth;
    property BiDiMode;
    property BorderProps;
    property BrowseButtonVisible;
    property ButtonProps;
    property CanEdit;
    property CharCase;
    property CheckStyle;
    property Color;
    property Colors;
    property ColorWidth;
    property Constraints;
    property CustomColors;
    property DblClickReverts;
    property DisplayType;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownKey;
    property EditCursor;
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
    property Layout;
    property MaxLength;
    {$IFDEF SC_DELPHI2009_EARLY}
    property OEMConvert;
    {$ENDIF}
    property Options;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property PopupProps;
    property ReadOnly;
    property Revertable;
    property SelectedColor;
    property ShowCheckboxes;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseImage;
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
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetColor;
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
    property OnSetColor;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomFontSizeListbox = class(TSCCustomSimpleListbox)
  private
    FPixelsPerInch: Integer;
    FFontName: TFontName;
    FFontSize: Integer;
    function  GetFontSizes(Index: Integer): Integer;
    procedure SetFontSize(Value: Integer);
    procedure SetFontName(const Value: TFontName);
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;

    procedure RefreshFont; dynamic;
    procedure UpdateSelection;

    procedure DoItemClick(Index: Integer); override;
    procedure VerifyHorizontalPos(var P: Integer); override;
    function  CanShowEditor: Boolean; override;

    property AllowEdit default False;
    property EndEllipsis default True;
    property FontName: TFontName read FFontName write SetFontName;
    property FontSize: Integer read FFontSize write SetFontSize default 8;
    property FontSizes[Index: Integer]: Integer read GetFontSizes;
    property ScrollbarHorizontal default False;
    property ScrollbarVertical default True;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCFontSizeListbox = class(TSCCustomFontSizeListbox)
  public
    property Count;
    property Objects;
    property Checked;
    property State;
    property HotIndex;
    property ItemIndex;
    property Selected;
    property TopIndex;
    property FontSizes;
  published
    property Align;
    property AllowGrayed;
    property Anchors;
    property BorderProps;
    property CenterImages;
    property Color;
    property Colors;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Flat;
    property Font;
    property FontName;
    property FontSize;
    property HideFocusRect;
    property HideSelection;
    property Hottrack;
    property HottrackColor;
    property HottrackUnderline;
    property ItemHeight;
    property MultiSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Scrollbars;
    property ShowCheckboxes;
    property ShowItemHints;
    property ShowHint;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
    property TabOrder;
    property TabStop;
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
    property OnResize;
    property OnShowItemHint;
    property OnStartDock;
    property OnStartDrag;
  end;


  TSCCustomFontSizeCombobox = class(TSCCustomCombobox)
  private
    FPixelsPerInch: Integer;
    FFontName: TFontName;
    FFontSize: Integer;
    function  GetFontSizes(Index: Integer): Integer;
    procedure SetFontSize(Value: Integer);
    procedure SetFontName(const Value: TFontName);
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;

    procedure RefreshFont; dynamic;
    procedure UpdateSizeSelection;

    procedure DoInternalChange; override;
    procedure DoListClick(Index: Integer; const Item: String); override;
    procedure PrepareDropWindow; override;

    function  GetEditColorsClass: TSCEditCustomColorsClass; override;

    property AutoComplete default True;
    property DropDownCount default 8;
    property IsDropDown default True;
    property FontName: TFontName read FFontName write SetFontName;
    property FontSize: Integer read FFontSize write SetFontSize default 8;
    property FontSizes[Index: Integer]: Integer read GetFontSizes;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCFontSizeCombobox = class(TSCCustomFontSizeCombobox)
  public
    property FontSizes;
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
    property ButtonProps;
    property CanEdit;
    property CharCase;
    property CheckStyle;
    property Color;
    property Colors;
    property Constraints;
    property DblClickReverts;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownKey;
    property EditCursor;
    property EditMode;
    property Enabled;
    property EndEllipsis;
    property EnterAsTab;
    property FocusExpandSize;
    property Font;
    property FontName;
    property FontSize;
    property HideSelection;
    property ImageIndex;
    property Images;
    property ImeMode;
    property ImeName;
    property ImmediateSetText;
    property Indent;
    property InsertChangesEditMode;
    property IsDropDown;
    property ItemHeight;
    property Layout;
    property MaxLength;
    {$IFDEF SC_DELPHI2009_EARLY}
    property OEMConvert;
    {$ENDIF}
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property PopupProps;
    property ReadOnly;
    property Revertable;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseImage;
    property Visible;
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

  TSCCustomFontCharsetListbox = class(TSCCustomSimpleListbox)
  private
    FAddDefaultCharset: Boolean;
    FDefaultCharsetCaption: String;
    FFontCharSet: TFontCharset;
    FFontName: TFontName;
    procedure SetAddDefaultCharset(Value: Boolean);
    procedure SetDefaultCharsetCaption(const Value: String);
    procedure SetFontCharSet(Value: TFontCharset);
    procedure SetFontName(const Value: TFontName);
    function  GetFontCharsets(Index: Integer): TFontCharset;
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;

    procedure RefreshFont; dynamic;
    procedure UpdateSelection;
    function  GetDefaultCharsetCaption: String; dynamic;

    procedure DoItemClick(Index: Integer); override;
    procedure VerifyHorizontalPos(var P: Integer); override;
    function  CanShowEditor: Boolean; override;

    property AddDefaultCharset: Boolean read FAddDefaultCharset write SetAddDefaultCharset default False;
    property AllowEdit default False;
    property DefaultCharsetCaption: String read FDefaultCharsetCaption write SetDefaultCharsetCaption;
    property EndEllipsis default True;
    property FontCharsets[Index: Integer]: TFontCharset read GetFontCharsets;
    property FontCharSet: TFontCharset read FFontCharSet write SetFontCharSet default 0;
    property FontName: TFontName read FFontName write SetFontName;
    property ScrollbarHorizontal default False;
    property ScrollbarVertical default True;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCFontCharsetListbox = class(TSCCustomFontCharsetListbox)
  public
    property Count;
    property Objects;
    property Checked;
    property State;
    property HotIndex;
    property ItemIndex;
    property Selected;
    property TopIndex;
    property FontCharsets;
  published
    property AddDefaultCharset;
    property Align;
    property AllowGrayed;
    property Anchors;
    property BorderProps;
    property CenterImages;
    property Color;
    property Colors;
    property Constraints;
    property DefaultCharsetCaption;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Flat;
    property Font;
    property FontCharSet;
    property FontName;
    property HideFocusRect;
    property HideSelection;
    property Hottrack;
    property HottrackColor;
    property HottrackUnderline;
    property ItemHeight;
    property MultiSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Scrollbars;
    property ShowCheckboxes;
    property ShowItemHints;
    property ShowHint;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
    property TabOrder;
    property TabStop;
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
    property OnResize;
    property OnShowItemHint;
    property OnStartDock;
    property OnStartDrag;
  end;


  TSCCustomFontCharsetCombobox = class(TSCCustomCombobox)
  private
    FAddDefaultCharset: Boolean;
    FDefaultCharsetCaption: String;
    FFontCharSet: TFontCharset;
    FFontName: TFontName;
    procedure SetAddDefaultCharset(Value: Boolean);
    procedure SetDefaultCharsetCaption(const Value: String);
    procedure SetFontCharSet(Value: TFontCharset);
    procedure SetFontName(const Value: TFontName);
    function  GetFontCharsets(Index: Integer): TFontCharset;
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure UpdateCharsetSelection;

    procedure RefreshFont; dynamic;
    function  GetDefaultCharsetCaption: String; dynamic;

    procedure DoInternalChange; override;
    procedure DoListClick(Index: Integer; const Item: String); override;
    procedure PrepareDropWindow; override;

    function  GetEditColorsClass: TSCEditCustomColorsClass; override;

    property AddDefaultCharset: Boolean read FAddDefaultCharset write SetAddDefaultCharset default False;
    property AutoComplete default True;
    property DefaultCharsetCaption: String read FDefaultCharsetCaption write SetDefaultCharsetCaption;
    property DropDownCount default 2;
    property IsDropDown default True;
    property FontCharsets[Index: Integer]: TFontCharset read GetFontCharsets;
    property FontCharSet: TFontCharset read FFontCharSet write SetFontCharSet default 0;
    property FontName: TFontName read FFontName write SetFontName;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCFontCharsetCombobox = class(TSCCustomFontCharsetCombobox)
  public
    property FontCharsets;
  published
    property AddDefaultCharset;
    property Align;
    property Alignment;
    property AllowGrayed;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property AutoWidth;
    property BiDiMode;
    property BorderProps;
    property ButtonProps;
    property CanEdit;
    property CharCase;
    property CheckStyle;
    property Color;
    property Colors;
    property Constraints;
    property DefaultCharsetCaption;
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
    property FontCharSet;
    property FontName;
    property HideSelection;
    property ImageIndex;
    property Images;
    property ImeMode;
    property ImeName;
    property ImmediateSetText;
    property Indent;
    property ItemHeight;
    property Layout;
    {$IFDEF SC_DELPHI2009_EARLY}
    property OEMConvert;
    {$ENDIF}
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property PopupProps;
    property ReadOnly;
    property Revertable;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseImage;
    property Visible;
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


  TSCGetCaptionEvent = procedure(Sender: TObject; UserData: Integer; var Caption: String) of object;
  TSCBrushStyleDisplayType = (scbdBrushes, scbdNames, scbdBrushesAndNames);

  TSCCustomBrushStyleListbox = class(TSCCustomSimpleListbox)
  private
    FBrushColor: TColor;
    FStyleWidth: Integer;
    FDisplayType: TSCBrushStyleDisplayType;
    FSelectedStyle: TBrushStyle;
    FOnGetCaption: TSCGetCaptionEvent;
    FOnSetStyle: TNotifyEvent;
    procedure SetBrushColor(Value: TColor);
    procedure SetStyleWidth(Value: Integer);
    procedure SetSelectedStyle(Value: TBrushStyle);
    procedure SetDisplayType(Value: TSCBrushStyleDisplayType);
  protected
    procedure Loaded; override;
    procedure IndentChanged; override;
    procedure RefreshStyles; dynamic;

    procedure SystemColorsChanged; override;

    procedure DoItemClick(Index: Integer); override;
    procedure VerifyHorizontalPos(var P: Integer); override;
    function  CanShowEditor: Boolean; override;

    procedure BeforePaintItem(C: TCanvas; Index: Integer; ClientR, R: TRect;
      State: TSCSimpleListState); override;
    procedure DoDrawItem(C: TCanvas; Index: Integer; CR, R: TRect; State: TSCSimpleListState); override;

    property AllowEdit default False;
    property BrushColor: TColor read FBrushColor write SetBrushColor default clWindowText;
    property StyleWidth: Integer read FStyleWidth write SetStyleWidth default 24;
    property DisplayType: TSCBrushStyleDisplayType read FDisplayType write SetDisplayType default scbdBrushesAndNames;
    property EndEllipsis default False;
    property Indent default 24;
    property ScrollbarHorizontal default True;
    property ScrollbarVertical default True;
    property SelectedStyle: TBrushStyle read FSelectedStyle write SetSelectedStyle default bsSolid;
    property OnGetCaption: TSCGetCaptionEvent read FOnGetCaption write FOnGetCaption;
    property OnSetStyle: TNotifyEvent read FOnSetStyle write FOnSetStyle;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCBrushStyleListbox = class(TSCCustomBrushStyleListbox)
  public
    property Count;
    property Objects;
    property Checked;
    property State;
    property HotIndex;
    property ItemIndex;
    property Selected;
    property TopIndex;
  published
    property Align;
    property AllowGrayed;
    property Anchors;
    property BorderProps;
    property BrushColor;
    property CenterImages;
    property Color;
    property Colors;
    property Constraints;
    property DisplayType;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Flat;
    property Font;
    property HideFocusRect;
    property HideSelection;
    property Hottrack;
    property HottrackColor;
    property HottrackUnderline;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Scrollbars;
    property SelectedStyle;
    property ShowCheckboxes;
    property ShowItemHints;
    property ShowHint;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
    property StyleWidth;
    property TabOrder;
    property TabStop;
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
    property OnGetCaption;
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
    property OnResize;
    property OnSetStyle;
    property OnShowItemHint;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomBrushStyleCombobox = class(TSCCustomCombobox)
  private
    FBrushColor: TColor;
    FStyleWidth: Integer;
    FDisplayType: TSCBrushStyleDisplayType;
    FSelectedStyle: TBrushStyle;
    FOnGetCaption: TSCGetCaptionEvent;
    FOnSetStyle: TNotifyEvent;
    procedure SetBrushColor(Value: TColor);
    procedure SetStyleWidth(Value: Integer);
    procedure SetSelectedStyle(Value: TBrushStyle);
    procedure SetDisplayType(Value: TSCBrushStyleDisplayType);
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure RefreshStyles; dynamic;

    function  GetIsDropDown: Boolean; override;
    procedure PaintLine(C: TCanvas; Index, H, TxTop: Integer); override;

    procedure DoDrawBack(C: TCanvas); override;
    procedure DoInternalChange; override;
    procedure DoListClick(Index: Integer; const Item: String); override;

    function  GetListboxClass: TSCSimpleListboxClass; override;
    function  GetEditColorsClass: TSCEditCustomColorsClass; override;

    procedure UpdateBorderRect(var R: TRect); override;
    procedure PrepareDropWindow; override;
    procedure AfterCloseUp; override;
    procedure UpdateBrushText;

    property AutoComplete default True;
    property BrushColor: TColor read FBrushColor write SetBrushColor default clWindowText;
    property StyleWidth: Integer read FStyleWidth write SetStyleWidth default 24;
    property DisplayType: TSCBrushStyleDisplayType read FDisplayType write SetDisplayType default scbdBrushesAndNames;
    property DropDownCount default 12;
    property ImmediateDropDown default True;
    property IsDropDown default True;
    property SelectedStyle: TBrushStyle read FSelectedStyle write SetSelectedStyle default bsSolid;
    property OnGetCaption: TSCGetCaptionEvent read FOnGetCaption write FOnGetCaption;
    property OnSetStyle: TNotifyEvent read FOnSetStyle write FOnSetStyle;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCBrushStyleCombobox = class(TSCCustomBrushStyleCombobox)
  public
    property Checked;
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
    property BrushColor;
    property ButtonProps;
    property CanEdit;
    property CharCase;
    property CheckStyle;
    property Color;
    property Colors;
    property Constraints;
    property DblClickReverts;
    property DisplayType;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownKey;
    property EditCursor;
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
    property Layout;
    property MaxLength;
    {$IFDEF SC_DELPHI2009_EARLY}
    property OEMConvert;
    {$ENDIF}
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property PopupProps;
    property ReadOnly;
    property Revertable;
    property SelectedStyle;
    property ShowCheckboxes;
    property ShowHint;
    property Style;
    property StyleWidth;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseImage;
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
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetCaption;
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
    property OnSetStyle;
    property OnStartDock;
    property OnStartDrag;
  end;


  TSCPenDisplayType = (scpdPens, scpdNames, scpdPensAndNames);

  TSCCustomPenStyleListbox = class(TSCCustomSimpleListbox)
  private
    FPenColor: TColor;
    FStyleWidth: Integer;
    FDisplayType: TSCPenDisplayType;
    FSelectedStyle: TPenStyle;
    FOnGetCaption: TSCGetCaptionEvent;
    FOnSetStyle: TNotifyEvent;
    procedure SetPenColor(Value: TColor);
    procedure SetStyleWidth(Value: Integer);
    procedure SetSelectedStyle(Value: TPenStyle);
    procedure SetDisplayType(Value: TSCPenDisplayType);
  protected
    procedure Loaded; override;
    procedure IndentChanged; override;
    procedure RefreshStyles; dynamic;

    procedure SystemColorsChanged; override;

    procedure DoItemClick(Index: Integer); override;
    procedure VerifyHorizontalPos(var P: Integer); override;
    function  CanShowEditor: Boolean; override;

    procedure BeforePaintItem(C: TCanvas; Index: Integer; ClientR, R: TRect;
      State: TSCSimpleListState); override;
    procedure DoDrawItem(C: TCanvas; Index: Integer; CR, R: TRect; State: TSCSimpleListState); override;

    property AllowEdit default False;
    property PenColor: TColor read FPenColor write SetPenColor default clWindowText;
    property StyleWidth: Integer read FStyleWidth write SetStyleWidth default 50;
    property DisplayType: TSCPenDisplayType read FDisplayType write SetDisplayType default scpdPensAndNames;
    property EndEllipsis default False;
    property Indent default 50;
    property ScrollbarHorizontal default True;
    property ScrollbarVertical default True;
    property SelectedStyle: TPenStyle read FSelectedStyle write SetSelectedStyle default psSolid;
    property OnGetCaption: TSCGetCaptionEvent read FOnGetCaption write FOnGetCaption;
    property OnSetStyle: TNotifyEvent read FOnSetStyle write FOnSetStyle;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCPenStyleListbox = class(TSCCustomPenStyleListbox)
  public
    property Count;
    property Objects;
    property Checked;
    property State;
    property HotIndex;
    property ItemIndex;
    property Selected;
    property TopIndex;
  published
    property Align;
    property AllowGrayed;
    property Anchors;
    property BorderProps;
    property CenterImages;
    property Color;
    property Colors;
    property Constraints;
    property DisplayType;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Flat;
    property Font;
    property HideFocusRect;
    property HideSelection;
    property Hottrack;
    property HottrackColor;
    property HottrackUnderline;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PenColor;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Scrollbars;
    property SelectedStyle;
    property ShowCheckboxes;
    property ShowItemHints;
    property ShowHint;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
    property StyleWidth;
    property TabOrder;
    property TabStop;
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
    property OnGetCaption;
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
    property OnResize;
    property OnSetStyle;
    property OnShowItemHint;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomPenStyleCombobox = class(TSCCustomCombobox)
  private
    FPenColor: TColor;
    FStyleWidth: Integer;
    FDisplayType: TSCPenDisplayType;
    FSelectedStyle: TPenStyle;
    FOnGetCaption: TSCGetCaptionEvent;
    FOnSetStyle: TNotifyEvent;
    procedure SetPenColor(Value: TColor);
    procedure SetStyleWidth(Value: Integer);
    procedure SetSelectedStyle(Value: TPenStyle);
    procedure SetDisplayType(Value: TSCPenDisplayType);
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure RefreshStyles; dynamic;

    function  GetIsDropDown: Boolean; override;
    procedure PaintLine(C: TCanvas; Index, H, TxTop: Integer); override;

    procedure DoDrawBack(C: TCanvas); override;
    procedure DoInternalChange; override;
    procedure DoListClick(Index: Integer; const Item: String); override;

    function  GetListboxClass: TSCSimpleListboxClass; override;
    function  GetEditColorsClass: TSCEditCustomColorsClass; override;

    procedure UpdateBorderRect(var R: TRect); override;
    procedure PrepareDropWindow; override;
    procedure AfterCloseUp; override;
    procedure UpdatePenText;

    property AutoComplete default True;
    property PenColor: TColor read FPenColor write SetPenColor default clWindowText;
    property StyleWidth: Integer read FStyleWidth write SetStyleWidth default 50;
    property DisplayType: TSCPenDisplayType read FDisplayType write SetDisplayType default scpdPensAndNames;
    property DropDownCount default 12;
    property ImmediateDropDown default True;
    property IsDropDown default True;
    property SelectedStyle: TPenStyle read FSelectedStyle write SetSelectedStyle default psSolid;
    property OnGetCaption: TSCGetCaptionEvent read FOnGetCaption write FOnGetCaption;
    property OnSetStyle: TNotifyEvent read FOnSetStyle write FOnSetStyle;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCPenStyleCombobox = class(TSCCustomPenStyleCombobox)
  public
    property Checked;
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
    property CanEdit;
    property CharCase;
    property CheckStyle;
    property Color;
    property Colors;
    property Constraints;
    property DblClickReverts;
    property DisplayType;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownKey;
    property EditCursor;
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
    property Layout;
    property MaxLength;
    {$IFDEF SC_DELPHI2009_EARLY}
    property OEMConvert;
    {$ENDIF}
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PenColor;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property PopupProps;
    property ReadOnly;
    property Revertable;
    property SelectedStyle;
    property ShowCheckboxes;
    property ShowHint;
    property Style;
    property StyleWidth;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseImage;
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
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetCaption;
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
    property OnSetStyle;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomPenModeListbox = class(TSCCustomSimpleListbox)
  private
    FModeWidth: Integer;
    FBackColor: TColor;
    FDisplayType: TSCPenDisplayType;
    FPenColor: TColor;
    FSelectedMode: TPenMode;
    FOnGetCaption: TSCGetCaptionEvent;
    FOnSetMode: TNotifyEvent;
    procedure SetBackColor(Value: TColor);
    procedure SetPenColor(Value: TColor);
    procedure SetModeWidth(Value: Integer);
    procedure SetSelectedMode(Value: TPenMode);
    procedure SetDisplayType(Value: TSCPenDisplayType);
  protected
    procedure Loaded; override;
    procedure IndentChanged; override;
    procedure RefreshModes; dynamic;

    procedure SystemColorsChanged; override;

    procedure DoItemClick(Index: Integer); override;
    procedure VerifyHorizontalPos(var P: Integer); override;
    function  CanShowEditor: Boolean; override;

    procedure BeforePaintItem(C: TCanvas; Index: Integer; ClientR, R: TRect;
      State: TSCSimpleListState); override;
    procedure DoDrawItem(C: TCanvas; Index: Integer; CR, R: TRect; State: TSCSimpleListState); override;

    property AllowEdit default False;
    property BackColor: TColor read FBackColor write SetBackColor default clGreen;
    property PenColor: TColor read FPenColor write SetPenColor default clRed;
    property ModeWidth: Integer read FModeWidth write SetModeWidth default 24;
    property DisplayType: TSCPenDisplayType read FDisplayType write SetDisplayType default scpdPensAndNames;
    property EndEllipsis default False;
    property Indent default 24;
    property ScrollbarHorizontal default True;
    property ScrollbarVertical default True;
    property SelectedMode: TPenMode read FSelectedMode write SetSelectedMode default pmCopy;
    property OnGetCaption: TSCGetCaptionEvent read FOnGetCaption write FOnGetCaption;
    property OnSetMode: TNotifyEvent read FOnSetMode write FOnSetMode;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCPenModeListbox = class(TSCCustomPenModeListbox)
  public
    property Count;
    property Objects;
    property Checked;
    property State;
    property HotIndex;
    property ItemIndex;
    property Selected;
    property TopIndex;
  published
    property Align;
    property AllowGrayed;
    property Anchors;
    property BackColor;
    property BorderProps;
    property CenterImages;
    property Color;
    property Colors;
    property Constraints;
    property DisplayType;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Flat;
    property Font;
    property HideFocusRect;
    property HideSelection;
    property Hottrack;
    property HottrackColor;
    property HottrackUnderline;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PenColor;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property Scrollbars;
    property SelectedMode;
    property ShowCheckboxes;
    property ShowItemHints;
    property ShowHint;
    property ShowSizeGrip;
    property ShowStatusbar;
    property StatusbarAlignment;
    property StatusbarColor;
    property StatusbarText;
    property ModeWidth;
    property TabOrder;
    property TabStop;
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
    property OnGetCaption;
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
    property OnResize;
    property OnSetMode;
    property OnShowItemHint;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSCCustomPenModeCombobox = class(TSCCustomCombobox)
  private
    FBackColor: TColor;
    FPenColor: TColor;
    FModeWidth: Integer;
    FDisplayType: TSCPenDisplayType;
    FSelectedMode: TPenMode;
    FOnGetCaption: TSCGetCaptionEvent;
    FOnSetMode: TNotifyEvent;
    procedure SetBackColor(Value: TColor);
    procedure SetPenColor(Value: TColor);
    procedure SetModeWidth(Value: Integer);
    procedure SetSelectedMode(Value: TPenMode);
    procedure SetDisplayType(Value: TSCPenDisplayType);
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure RefreshModes; dynamic;

    function  GetIsDropDown: Boolean; override;
    procedure PaintLine(C: TCanvas; Index, H, TxTop: Integer); override;

    procedure DoDrawBack(C: TCanvas); override;
    procedure DoInternalChange; override;
    procedure DoListClick(Index: Integer; const Item: String); override;

    function  GetListboxClass: TSCSimpleListboxClass; override;
    function  GetEditColorsClass: TSCEditCustomColorsClass; override;

    procedure UpdateBorderRect(var R: TRect); override;
    procedure PrepareDropWindow; override;
    procedure AfterCloseUp; override;
    procedure UpdatePenText;

    property AutoComplete default True;
    property BackColor: TColor read FBackColor write SetBackColor default clGreen;
    property PenColor: TColor read FPenColor write SetPenColor default clRed;
    property ModeWidth: Integer read FModeWidth write SetModeWidth default 24;
    property DisplayType: TSCPenDisplayType read FDisplayType write SetDisplayType default scpdPensAndNames;
    property DropDownCount default 12;
    property ImmediateDropDown default True;
    property IsDropDown default True;
    property SelectedMode: TPenMode read FSelectedMode write SetSelectedMode default pmCopy;
    property OnGetCaption: TSCGetCaptionEvent read FOnGetCaption write FOnGetCaption;
    property OnSetMode: TNotifyEvent read FOnSetMode write FOnSetMode;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCPenModeCombobox = class(TSCCustomPenModeCombobox)
  public
    property Checked;
  published
    property Align;
    property Alignment;
    property AllowGrayed;
    property Anchors;
    property AutoComplete;
    property AutoSelect;
    property AutoSize;
    property AutoWidth;
    property BackColor;
    property BiDiMode;
    property BorderProps;
    property BrowseButtonVisible;
    property ButtonProps;
    property CanEdit;
    property CharCase;
    property CheckStyle;
    property Color;
    property Colors;
    property Constraints;
    property DblClickReverts;
    property DisplayType;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownKey;
    property EditCursor;
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
    property Layout;
    property MaxLength;
    property ModeWidth;
    {$IFDEF SC_DELPHI2009_EARLY}
    property OEMConvert;
    {$ENDIF}
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PenColor;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property PopupProps;
    property ReadOnly;
    property Revertable;
    property SelectedMode;
    property ShowCheckboxes;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseImage;
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
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetCaption;
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
    property OnSetMode;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

{$R *.res}

type
  TSCFontStrings = class(TSCStringList);
  TSCColorStrings = class(TSCStringList);
  TSCBrushStrings = class(TSCStringList);
  TSCPenStrings = class(TSCStringList);
  

  TSCFontSizeRec = record
    Items: TStrings;
    PixelsPerInch: Integer;
  end;
  PSCFontSizeRec = ^TSCFontSizeRec;

  TSCCustomDropDownListbox = class(TSCSimpleListbox);

  TSCDropDownFontListbox = class(TSCCustomFontListbox)
  private
    FMRUCount: Integer;
    FMRUList: TStrings;
    FMRUsAdded: Boolean;
    FDroppedDown: Boolean;
    FSettingHighlight: Boolean;
    procedure SetMRUCount(Value: Integer);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure WMShowWindow(var Message: TWMShowWindow); message WM_SHOWWINDOW;

    procedure UpdateMRUList;
    procedure AddMRUItem(Index: Integer; const FontName: String; ExItems: TSCStringList = nil);
    procedure InsertMRUs;
    procedure RemoveMRUs;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure RefreshFontNames; override;
    procedure CreateWnd; override;

    function  CanShowEditor: Boolean; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ColorsChanged; override;
    procedure AfterPaintItem(C: TCanvas; Index: Integer; ClientR, R: TRect;
      State: TSCSimpleListState); override;
    procedure DoMeasureItem(Index: Integer; var AWidth, AHeight, AIndent: Integer); override;

    property MRUCount: Integer read FMRUCount write SetMRUCount default 0;
    property ForceDropdownClick default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TSCDropDownColorListbox = class(TSCCustomColorListbox)
  private
    FDroppedDown: Boolean;
    FSettingHighlight: Boolean;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure WMShowWindow(var Message: TWMShowWindow); message WM_SHOWWINDOW;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure RefreshColors; override;
    procedure CreateWnd; override;

    function  CanShowEditor: Boolean; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ColorsChanged; override;

    property ForceDropdownClick default True;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TSCDropDownBrushStyleListbox = class(TSCCustomBrushStyleListbox)
  private
    FDroppedDown: Boolean;
    FSettingHighlight: Boolean;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure WMShowWindow(var Message: TWMShowWindow); message WM_SHOWWINDOW;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure RefreshStyles; override;
    procedure CreateWnd; override;

    function  CanShowEditor: Boolean; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ColorsChanged; override;

    property ForceDropdownClick default True;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TSCDropDownPenStyleListbox = class(TSCCustomPenStyleListbox)
  private
    FDroppedDown: Boolean;
    FSettingHighlight: Boolean;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure WMShowWindow(var Message: TWMShowWindow); message WM_SHOWWINDOW;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure RefreshStyles; override;
    procedure CreateWnd; override;

    function  CanShowEditor: Boolean; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ColorsChanged; override;

    property ForceDropdownClick default True;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TSCDropDownPenModeListbox = class(TSCCustomPenModeListbox)
  private
    FDroppedDown: Boolean;
    FSettingHighlight: Boolean;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure WMShowWindow(var Message: TWMShowWindow); message WM_SHOWWINDOW;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure RefreshModes; override;
    procedure CreateWnd; override;

    function  CanShowEditor: Boolean; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ColorsChanged; override;

    property ForceDropdownClick default True;
  public
    constructor Create(AOwner: TComponent); override;
  end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
var
  S: TSCFontStrings;
  Fn: String;
begin
  Result := 1;
  S := TSCFontStrings(Data);

  Fn := LogFont.lfFaceName;
  if (S.Count = 0) or (AnsiCompareText(S[S.Count-1], Fn) <> 0) then
  begin
    S.Add(Fn);
    S.Data[S.Count-1, 9] := FontType;
  end;  
end;

function EnumFontSizes(var EnumLogFont: TEnumLogFont; PTextMetric: PNewTextMetric;
  FontType: Integer; Data: LPARAM): Integer; export; stdcall;
var
  S: String;
  I, V, V2: Integer;
  P: PSCFontSizeRec;
begin
  P := PSCFontSizeRec(Data);

  if (FontType and TRUETYPE_FONTTYPE) <> 0 then
  begin
    with TSCFontStrings(P^.Items) do
    begin
      BeginUpdate;
      try
        Clear;

        Add('8');
        Data[0, 9] := 8;
        Add('9');
        Data[1, 9] := 9;
        Add('10');
        Data[2, 9] := 10;
        Add('11');
        Data[3, 9] := 11;
        Add('12');
        Data[4, 9] := 12;
        Add('14');
        Data[5, 9] := 14;
        Add('16');
        Data[6, 9] := 16;
        Add('18');
        Data[7, 9] := 18;
        Add('20');
        Data[8, 9] := 20;
        Add('22');
        Data[9, 9] := 22;
        Add('24');
        Data[10, 9] := 24;
        Add('26');
        Data[11, 9] := 26;
        Add('28');
        Data[12, 9] := 28;
        Add('36');
        Data[13, 9] := 36;
        Add('48');
        Data[14, 9] := 48;
        Add('72');
        Data[15, 9] := 72;
      finally
        EndUpdate;
      end;
    end;
    Result := 0;
  end else
  begin
    V := Round((EnumLogFont.elfLogFont.lfHeight - PTextMetric.tmInternalLeading)*72 /
      P^.PixelsPerInch);

    S := IntToStr(V);
    Result := 1;

    with TSCFontStrings(P^.Items) do
    begin
      BeginUpdate;
      try
        for I := 0 to Count - 1 do 
        begin
          V2 := StrToIntDef(Strings[I], -1);
          Data[I, 9] := V2;

          if V2 = V then
            Exit;

          if V2 > V then
          begin
            Insert(I, S);
            Data[I, 9] := V2;

            Exit;
          end;
        end;

        Add(S);
        Data[Count-1, 9] := V;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

function EnumFontCharsets(var EnumLogFont: TEnumLogFontEx; PTextMetric: PNewTextMetricEx;
  FontType: Integer; Data: LPARAM): Integer; export; stdcall;
var
  S: String;
  I, Ln, Cs: Integer;
begin
  Result := 1;
  Cs := EnumLogFont.elfLogFont.lfCharSet;

  if Cs <> MAC_CHARSET then
  begin
    Ln := StrLen(EnumLogFont.elfScript);
    SetLength(S, Ln);
    Move(EnumLogFont.elfScript, PChar(S)^, Ln);

    with TSCFontStrings(Data) do
    begin
      BeginUpdate;
      try
        for I := 0 to Count-1 do
        begin
          if Data[I, 9] = Cs then
            Exit;

          if AnsiCompareText(Strings[I], S) > 0 then
          begin
            Insert(I, S);
            Data[I, 9] := Cs;

            Exit;
          end;
        end;

        Add(S);
        Data[Count-1, 9] := Cs;
      finally
        EndUpdate;
      end;
    end;
  end;
end;


{ TSCDropDownFontListbox }

procedure TSCDropDownFontListbox.AddMRUItem(Index: Integer; const FontName: String;
  ExItems: TSCStringList);
var
  Cnt, I, J: Integer;
begin
  if not ((FMRUCount > 0) and (Index > -1) and (FontName <> '')) then
    Exit;

  if ExItems <> nil then
  begin
    if Index < ExItems.Count then
    begin
      I := FMRUList.IndexOf(FontName);
      
      if I > -1 then
        FMRUList.Move(I, 0)
      else begin
        FMRUList.Insert(0, ExItems[Index]);
        for I := Low(TSCStringDatas) to High(TSCStringDatas) do
          TSCFontStrings(FMRUList).Data[0, I] := TSCFontStrings(ExItems).Data[Index, I];

        UpdateMRUList;
      end;
    end;
  end else
  if Index < Items.Count then
  begin
    I := FMRUList.IndexOf(FontName);
    if I > -1 then
    begin
      FMRUList.Move(I, 0);
      if FMRUsAdded then
        Items.Move(I, 0);
    end else
    begin
      FMRUList.Insert(0, FontName);
      Cnt := FMRUList.Count;

      with TSCFontStrings(Items) do
      begin
        for I := Low(TSCStringDatas) to High(TSCStringDatas) do
          TSCFontStrings(FMRUList).Data[0, I] := Data[Index, I];

        UpdateMRUList;

        BeginUpdate;
        try
          Insert(0, FontName);
          for I := Low(TSCStringDatas) to High(TSCStringDatas) do
            Data[0, I] := TSCFontStrings(FMRUList).Data[0, I];

          if (FMRUList <> nil) and (FMRUCount < Cnt) then
            while (Count > 0) and (Cnt > FMRUCount) do
            begin
              Delete(Cnt-1);
              Dec(Cnt);
            end;

          for I := 0 to FMRUList.Count-1 do
          begin
            Strings[I] := FMRUList.Strings[I];
            for J := Low(TSCStringDatas) to High(TSCStringDatas) do
              Data[I, J] := TSCFontStrings(FMRUList).Data[I, J];
          end;
        finally
          EndUpdate;
        end;
      end;
    end;
  end;
end;

procedure TSCDropDownFontListbox.AfterPaintItem(C: TCanvas; Index: Integer;
  ClientR, R: TRect; State: TSCSimpleListState);
begin
  if (FMRUCount > 0) and (C = nil) or (Index <> FMRUList.Count-1) or
    (Index < 0) and (Index > Items.Count-1) or IsRectEmpty(ClientR) then
    Exit;

  R.Left  := ClientR.Left;
  R.Right := ClientR.Right;
  Dec(R.Bottom);

  with C do
  begin
    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Pen.Width := 1;
    Pen.Color := clWindowFrame;

    MoveTo(R.Left,  R.Bottom);
    LineTo(R.Right, R.Bottom);

    MoveTo(R.Left,  R.Bottom - 2);
    LineTo(R.Right, R.Bottom - 2);

    Pen.Color := clWindow;
    MoveTo(R.Left,  R.Bottom - 1);
    LineTo(R.Right, R.Bottom - 1);
  end;
end;

function TSCDropDownFontListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

procedure TSCDropDownFontListbox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  HottrackColor := Font.Color;
end;

procedure TSCDropDownFontListbox.CMVisibleChanged(var Message: TMessage);
begin
  inherited;
  if not Boolean(Message.WParam) then
    FDroppedDown := False;
end;

procedure TSCDropDownFontListbox.ColorsChanged;
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

constructor TSCDropDownFontListbox.Create(AOwner: TComponent);
begin
  FMRUList := TSCFontStrings.Create;

  inherited Create(AOwner);
  HotTrack := True;
  Border := sccbFlat;
  FlatColor := clWindowFrame;
  ShowItemHints := False;
  ScrollbarHorizontal := False;
  ForceDropdownClick := True;

  ColorsChanged;
end;

procedure TSCDropDownFontListbox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    Style := Style and not WS_BORDER;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TSCDropDownFontListbox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;

destructor TSCDropDownFontListbox.Destroy;
begin
  FreeAndNil(FMRUList);
  inherited Destroy;
end;

procedure TSCDropDownFontListbox.DoMeasureItem(Index: Integer; var AWidth,
  AHeight, AIndent: Integer);
begin
  inherited DoMeasureItem(Index, AWidth, AHeight, AIndent);

  if (FMRUCount > 0) and (Index > -1) and (Index = FMRUList.Count-1) then
    Inc(AHeight, 3);
end;

procedure TSCDropDownFontListbox.InsertMRUs;
var
  I, J: Integer;
begin
  if FMRUsAdded then
    RemoveMRUs;

  for I := FMRUList.Count-1 downto 0 do
  begin
    Items.Insert(0, FMRUList.Strings[I]);

    for J := Low(TSCStringDatas) to High(TSCStringDatas) do
      TSCFontStrings(Items).Data[0, J] := TSCFontStrings(FMRUList).Data[I, J];
  end;

  FMRUsAdded := True;
end;

procedure TSCDropDownFontListbox.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  L, R, CbxW, Indx: Integer;
begin
  if not FDroppedDown then
  begin
    FDroppedDown := True;
    Exit;
  end;

  inherited MouseMove(Shift, X, Y);

  if HotTrack and (HotIndex <> ItemIndex) then
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

procedure TSCDropDownFontListbox.RefreshFontNames;
begin
  //
end;

procedure TSCDropDownFontListbox.RemoveMRUs;
var
  I, J: Integer;
begin
  if FMRUsAdded then
  begin
    Items.BeginUpdate;
    try
      for I := 0 to FMRUList.Count-1 do
        for J := Low(TSCStringDatas) to High(TSCStringDatas) do
          TSCFontStrings(FMRUList).Data[I, J] := TSCFontStrings(Self.Items).Data[I, J];

      for I := FMRUList.Count-1 downto 0 do
      begin
        if Items.Count = 0 then
          Break;

        Items.Delete(0);
      end;
    finally
      FMRUsAdded := False;
      Items.EndUpdate;
    end;
  end;
end;

procedure TSCDropDownFontListbox.SetMRUCount(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMRUCount <> Value then
  begin
    if FMRUsAdded then
      RemoveMRUs;

    FMRUCount := Value;
    if FMRUCount = 0 then
    begin
      FMRUList.Clear;
      Exit;
    end;

    UpdateMRUList;
  end;
end;

procedure TSCDropDownFontListbox.UpdateMRUList;
begin
  if (FMRUList <> nil) and (FMRUCount < FMRUList.Count) then
    while (FMRUList.Count > 0) and (FMRUList.Count > FMRUCount) do
      FMRUList.Delete(FMRUList.Count-1);
end;

procedure TSCDropDownFontListbox.WMShowWindow(var Message: TWMShowWindow);
begin
  inherited;
  if not Message.Show then
    FDroppedDown := False;
end;

{ TSCDropDownColorListbox }

function TSCDropDownColorListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

procedure TSCDropDownColorListbox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  HottrackColor := Font.Color;
end;

procedure TSCDropDownColorListbox.CMVisibleChanged(var Message: TMessage);
begin
  inherited;
  if not Boolean(Message.WParam) then
    FDroppedDown := False;
end;

procedure TSCDropDownColorListbox.ColorsChanged;
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

constructor TSCDropDownColorListbox.Create(AOwner: TComponent);
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

procedure TSCDropDownColorListbox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    Style := Style and not WS_BORDER;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TSCDropDownColorListbox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;

procedure TSCDropDownColorListbox.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  L, R, CbxW, Indx: Integer;
begin
  if not FDroppedDown then
  begin
    FDroppedDown := True;
    Exit;
  end;

  inherited MouseMove(Shift, X, Y);

  if HotTrack and (HotIndex <> ItemIndex) then
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

procedure TSCDropDownColorListbox.RefreshColors;
begin
  //
end;

procedure TSCDropDownColorListbox.WMShowWindow(var Message: TWMShowWindow);
begin
  inherited;
  if not Message.Show then
    FDroppedDown := False;
end;

{ TSCDropDownBrushStyleListbox }

function TSCDropDownBrushStyleListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

procedure TSCDropDownBrushStyleListbox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  HottrackColor := Font.Color;
end;

procedure TSCDropDownBrushStyleListbox.CMVisibleChanged(var Message: TMessage);
begin
  inherited;
  if not Boolean(Message.WParam) then
    FDroppedDown := False;
end;

procedure TSCDropDownBrushStyleListbox.ColorsChanged;
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

constructor TSCDropDownBrushStyleListbox.Create(AOwner: TComponent);
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

procedure TSCDropDownBrushStyleListbox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    Style := Style and not WS_BORDER;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TSCDropDownBrushStyleListbox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;

procedure TSCDropDownBrushStyleListbox.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  L, R, CbxW, Indx: Integer;
begin
  if not FDroppedDown then
  begin
    FDroppedDown := True;
    Exit;
  end;

  inherited MouseMove(Shift, X, Y);

  if HotTrack and (HotIndex <> ItemIndex) then
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

procedure TSCDropDownBrushStyleListbox.RefreshStyles;
begin
  //
end;

procedure TSCDropDownBrushStyleListbox.WMShowWindow(var Message: TWMShowWindow);
begin
  inherited;
  if not Message.Show then
    FDroppedDown := False;
end;

{ TSCDropDownPenStyleListbox }

function TSCDropDownPenStyleListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

procedure TSCDropDownPenStyleListbox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  HottrackColor := Font.Color;
end;

procedure TSCDropDownPenStyleListbox.CMVisibleChanged(var Message: TMessage);
begin
  inherited;
  if not Boolean(Message.WParam) then
    FDroppedDown := False;
end;

procedure TSCDropDownPenStyleListbox.ColorsChanged;
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

constructor TSCDropDownPenStyleListbox.Create(AOwner: TComponent);
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

procedure TSCDropDownPenStyleListbox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    Style := Style and not WS_BORDER;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TSCDropDownPenStyleListbox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;

procedure TSCDropDownPenStyleListbox.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  L, R, CbxW, Indx: Integer;
begin
  if not FDroppedDown then
  begin
    FDroppedDown := True;
    Exit;
  end;

  inherited MouseMove(Shift, X, Y);

  if HotTrack and (HotIndex <> ItemIndex) then
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

procedure TSCDropDownPenStyleListbox.RefreshStyles;
begin
  //
end;

procedure TSCDropDownPenStyleListbox.WMShowWindow(var Message: TWMShowWindow);
begin
  inherited;
  if not Message.Show then
    FDroppedDown := False;
end;

{ TSCDropDownPenModeListbox }

function TSCDropDownPenModeListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

procedure TSCDropDownPenModeListbox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  HottrackColor := Font.Color;
end;

procedure TSCDropDownPenModeListbox.CMVisibleChanged(var Message: TMessage);
begin
  inherited;
  if not Boolean(Message.WParam) then
    FDroppedDown := False;
end;

procedure TSCDropDownPenModeListbox.ColorsChanged;
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

constructor TSCDropDownPenModeListbox.Create(AOwner: TComponent);
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

procedure TSCDropDownPenModeListbox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    Style := Style and not WS_BORDER;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TSCDropDownPenModeListbox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;

procedure TSCDropDownPenModeListbox.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  L, R, CbxW, Indx: Integer;
begin
  if not FDroppedDown then
  begin
    FDroppedDown := True;
    Exit;
  end;

  inherited MouseMove(Shift, X, Y);

  if HotTrack and (HotIndex <> ItemIndex) then
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

procedure TSCDropDownPenModeListbox.RefreshModes;
begin
  //
end;

procedure TSCDropDownPenModeListbox.WMShowWindow(var Message: TWMShowWindow);
begin
  inherited;
  if not Message.Show then
    FDroppedDown := False;
end;

{ TSCCustomFontListbox }

procedure TSCCustomFontListbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomFontListbox then
  begin
    with TSCCustomFontListbox(Source) do
    begin
      Self.DisplayStyle := DisplayStyle;
      Self.FontCharSet := FontCharSet;
      Self.FontCharsetActive := FontCharsetActive;
      Self.FontName := FontName;
      Self.FontTypes := FontTypes;
      Self.SampleText := SampleText;
      Self.ShowImages := ShowImages;
    end;
  end;
end;

procedure TSCCustomFontListbox.BeforePaintItem(C: TCanvas; Index: Integer;
  ClientR, R: TRect; State: TSCSimpleListState);
var
  Dt, Ind, T: Integer;
begin
  if FShowImages and (C = nil) or (Index < 0) and
    (Index > Items.Count-1) or IsRectEmpty(ClientR) then
    Exit;

  Dt := TSCFontStrings(Items).Data[Index, 9];

  Ind := Indent*TSCFontStrings(Items).Data[Index, 6];
  if Ind < 0 then Ind := 0;

  if (Ind > 0) and (scftTrueType in FFontTypes) and
    (FTrueTypeBmp <> nil) and (Dt = Integer(scftTrueType)) then
  begin
    if Ind > 18 then Ind := 18;

    R.Right := R.Left - 2;
    Dec(R.Left, Ind);
    
    T := R.Top + ((R.Bottom - R.Top - FTrueTypeBmp.Height) div 2);
    try
      if IntersectClipRect(C.Handle,
        R.Left, R.Top, R.Right, R.Bottom) = NULLREGION then
        Exit;

      C.Draw(R.Left, T, FTrueTypeBmp);
    finally
      SelectClipRgn(C.Handle, 0);
    end;
  end;
end;

function TSCCustomFontListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

constructor TSCCustomFontListbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  SetBounds(Left, Top, 165, 140);
  AllowEdit := False;
  Indent := 20;
  ScrollbarHorizontal := False;
  FDisplayStyle := scdsFontName;
  FontCharSet := DEFAULT_CHARSET;
  FFontCharsetActive := True;
  FFontTypes := [scftTrueType, scftDevice, scftRaster];
  FShowImages := True;

  LoadFontImages;
end;

procedure TSCCustomFontListbox.CreateWnd;
begin
  inherited CreateWnd;
  LoadFontImages;
  RefreshFontNames;
end;

destructor TSCCustomFontListbox.Destroy;
begin
  if FTrueTypeBmp <> nil then
    FreeAndNil(FTrueTypeBmp);
  inherited Destroy;
end;

procedure TSCCustomFontListbox.DoDrawItem(C: TCanvas; Index: Integer; CR,
  R: TRect; State: TSCSimpleListState);
var
  R2: TRect;
  S, FontSample: String;
  Cl, Fcl: TColor;
  F: LongInt;
begin
  if (C = nil) or IsRectEmpty(R) or IsRectEmpty(CR) or
    (Index < 0) or (Index > Count-1) then
    Exit;

  with C do
  begin
    Brush.Style := bsClear;
    Font.Assign(Self.Font);

    Cl := Self.Color;
    if sclsDisabled in State then
    begin
      Brush.Style := bsSolid;

      Cl := DisabledColor;
      if Cl <> clNone then
      begin
        Brush.Color := Cl;
        Font.Color := DisabledTextColor;

        FillRect(R);
      end;  
    end else
    if sclsSelected in State then
    begin
      Brush.Style := bsSolid;

      Cl  := HighlightColor;
      Fcl := HighlightTextColor;

      if not Focused then
      begin
        Cl  := HideSelectionColor;
        Fcl := HideSelectionTextColor;

        if HottrackUnderline and not IsDesigning and
          not (sclsDisabled in State) and (sclsHottrack in State) then
          Font.Style := Font.Style + [fsUnderline];
      end;

      if Cl <> clNone then
      begin
        Brush.Color := Cl;
        Font.Color := Fcl;

        FillRect(R);
      end;
    end else
    if (sclsHottrack in State) and not IsDesigning then
    begin
      Font.Color := HottrackColor;
      if HottrackUnderline then
        Font.Style := Font.Style + [fsUnderline];
    end;


    F := DT_LEFT or DT_TOP or DT_NOPREFIX or DT_SINGLELINE;

    R2 := R;
    S := Items.Strings[Index];

    if FDisplayStyle in [scdsFontName, scdsFontNameAndStyle] then
    begin
      if S <> '' then
      begin
        Inc(R2.Left, 2); Inc(R2.Top);

        Brush.Style := bsClear;
        DrawText(C.Handle, PChar(S), Length(S), R2, F);

        R2 := R;
        Inc(R2.Left, TextWidth(S) + 10);
      end;
    end;

    FontSample := SampleText;
    if FontSample = '' then
      FontSample := S;

    if not IsRectEmpty(R) and (FontSample <> '') and
      (FDisplayStyle in [scdsFontStyle, scdsFontNameAndStyle]) then
    begin
      Inc(R2.Left, 2); Inc(R2.Top);

      Font.Name := S;
      Brush.Style := bsClear;

      DrawText(C.Handle, PChar(FontSample), Length(FontSample), R2, F);
    end;

    if not IsDesigning and not HideFocusRect and
      (sclsFocused in State) and Focused then
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      scDrawFocusRect(C, R, Cl);
    end;
  end;
end;

function TSCCustomFontListbox.GetFontName: TFontName;
begin
  Result := '';
  if (ItemIndex > -1) and (ItemIndex < Items.Count) then
    Result := Items[ItemIndex];
end;

function TSCCustomFontListbox.GetFontNames(Index: Integer): String;
begin
  Result := '';
  if (Index > -1) and (Index < Items.Count) then
    Result := Strings[Index];
end;

function TSCCustomFontListbox.GetMaxWidth: Integer;
var
  S, FontSample: String;
  W, I, Index, Ind: Integer;
begin
  Result := 0;
  if Items.Count = 0 then Exit;

  Ind := 0;
  if FShowImages then Ind := 20;

  Index := -1;
  for I := 0 to Items.Count - 1 do
  begin
    W := TSCFontStrings(Items).Data[I, 1] + Ind;

    if W > Result then
    begin
      Result := W;
      Index  := I;
    end;
  end;

  if Index < 0 then Exit;
  S := Items[Index];

  if FDisplayStyle = scdsFontStyle then
  begin
    Canvas.Font.Name := S;
    Result := Canvas.TextWidth(S) + Ind + 20;
  end else
  if FDisplayStyle = scdsFontNameAndStyle then
  begin
    FontSample := SampleText;
    if FontSample = '' then
      FontSample := S;

    Canvas.Font.Name := S;
    Inc(Result, Canvas.TextWidth(FontSample) + 12);
  end;
end;

procedure TSCCustomFontListbox.Loaded;
begin
  inherited Loaded;
  RefreshFontNames;
end;

procedure TSCCustomFontListbox.LoadFontImages;
begin
  if FTrueTypeBmp <> nil then
    FreeAndNil(FTrueTypeBmp);

  FTrueTypeBmp := TBitmap.Create;
  with FTrueTypeBmp do
  begin
    Handle := LoadBitmap(HInstance, 'SC_TRUE_FONT');
    TransparentMode := tmAuto;
    Transparent := True;
  end;

  if FTrueTypeBmp.Handle = 0 then
    FreeAndNil(FTrueTypeBmp);
end;

procedure TSCCustomFontListbox.RefreshFontNames;
var
  DC: HDC;
  LFont: TLogFont;
  I, FontData, Fn: Integer;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  Items.BeginUpdate;
  try
    Items.Clear;
    if FFontTypes = [] then
      Exit;

    DC := GetDC(0);
    try
      if FFontCharsetActive then
      begin
        FillChar(LFont, SizeOf(LFont), 0);
        LFont.lfCharset := FFontCharSet;
        EnumFontFamiliesEx(DC, LFont, @EnumFontsProc, Longint(Items), 0);
      end else
        EnumFontFamilies(DC, nil, @EnumFontsProc, Longint(Items));
    finally
      ReleaseDC(0, DC);
    end;

    for I := Items.Count - 1 downto 0 do
    begin
      FontData := -1;
      Self.IndentLevel[I] := 1;

      Fn := TSCFontStrings(Items).Data[I, 9];
      case Fn of
        DEVICE_FONTTYPE:
          if scftDevice in FFontTypes then
            FontData := Integer(scftDevice);
        RASTER_FONTTYPE:
          if scftRaster in FFontTypes then
            FontData := Integer(scftRaster);
        TRUETYPE_FONTTYPE:
          if scftTrueType in FFontTypes then
            FontData := Integer(scftTrueType);
      end;

      if FontData > -1 then
        TSCFontStrings(Items).Data[I, 9] := FontData
      else
        Items.Delete(I);
    end;

    TSCFontStrings(Items).Sort;
  finally
    Items.EndUpdate;
  end;
end;

procedure TSCCustomFontListbox.SetDisplayStyle(Value: TSCFontDisplayStyle);
begin
  if FDisplayStyle <> Value then
  begin
    FDisplayStyle := Value;
    if not InItemUpdate and (Items.Count > 0) and
      (FSampleText = '') or (Trim(FSampleText) <> '') then
      Invalidate;
  end;
end;

procedure TSCCustomFontListbox.SetFontCharSet(Value: TFontCharset);
begin
  if FFontCharSet <> Value then
  begin
    FFontCharSet := Value;
    if FFontCharsetActive then
      RefreshFontNames;
  end;
end;

procedure TSCCustomFontListbox.SetFontCharsetActive(Value: Boolean);
begin
  if FFontCharsetActive <> Value then
  begin
    FFontCharsetActive := Value;
    RefreshFontNames;
  end;
end;

procedure TSCCustomFontListbox.SetFontName(const Value: TFontName);
begin
  ItemIndex := Items.IndexOf(Value);
end;

procedure TSCCustomFontListbox.SetFontTypes(Value: TSCFontTypes);
begin
  if FFontTypes <> Value then
  begin
    FFontTypes := Value;
    RefreshFontNames;
  end;
end;

procedure TSCCustomFontListbox.SetSampleText(const Value: String);
begin
  if FSampleText <> Value then
  begin
    FSampleText := Value;
    if not InItemUpdate and (Items.Count > 0) and
      (FDisplayStyle in [scdsFontStyle, scdsFontNameAndStyle]) then
      Invalidate;
  end;
end;

procedure TSCCustomFontListbox.SetShowImages(Value: Boolean);
var
  Ind: Integer;
begin
  if FShowImages <> Value then
  begin
    FShowImages := Value;

    Ind := 0;
    if FShowImages then Ind := 20;

    Indent := Ind;
    if not InItemUpdate and (Items.Count > 0) then
      Invalidate;
  end;
end;

procedure TSCCustomFontListbox.VerifyHorizontalPos(var P: Integer);
begin
  P := 0;
end;

{ TSCCustomFontCombobox }

procedure TSCCustomFontCombobox.AfterCloseUp;
var
  S: String;
begin
  if Listbox is TSCDropDownFontListbox then
    with TSCDropDownFontListbox(ListBox) do
    begin
      FDroppedDown := False;

      S := Self.Text;
      if FFontMemory <> S then
        AddMRUItem(Items.IndexOf(S), S);

      RemoveMRUs;
    end;

  inherited AfterCloseUp;
end;

procedure TSCCustomFontCombobox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomFontCombobox then
  begin
    with TSCCustomFontCombobox(Source) do
    begin
      Self.DisplayStyle := DisplayStyle;
      Self.FontCharSet := FontCharSet;
      Self.FontCharsetActive := FontCharsetActive;
      Self.FontName := FontName;
      Self.FontTypes := FontTypes;
      Self.MRUCount := MRUCount;
      Self.SampleText := SampleText;
      Self.ShowImages := ShowImages;
    end;
  end;
end;

procedure TSCCustomFontCombobox.BeforePrepareDropWindow;
var
  Ind: Integer;
begin
  FFontMemory := Self.Text;
  if ListBox <> nil then
    with TSCDropDownFontListbox(ListBox) do
    begin
      FFontCharSet  := Self.FFontCharSet;
      FFontCharsetActive := Self.FFontCharsetActive;
      FFontTypes    := Self.FFontTypes;
      FSampleText   := Self.FSampleText;
      ShowImages    := Self.FShowImages;
      FDisplayStyle := Self.FDisplayStyle;

      Office12Style := False;
      if Self.Style = scesOffice12 then
        Office12Style := True;

      Ind := 0;
      if FShowImages then Ind := 20;
      Indent := Ind;
    end;
end;

constructor TSCCustomFontCombobox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  AutoComplete := True;
  DropDownCount := 12;

  FDisplayStyle := scdsFontName;
  FontCharSet := DEFAULT_CHARSET;
  FFontCharsetActive := True;
  FFontTypes := [scftTrueType, scftDevice, scftRaster];
  FMRUCount := 5;
  FShowImages := True;

  StyleChanged;
end;

procedure TSCCustomFontCombobox.CreateWnd;
begin
  inherited CreateWnd;
  LoadFontImages;
  RefreshFontNames;
  StyleChanged;
end;

destructor TSCCustomFontCombobox.Destroy;
begin
  if FTrueTypeBmp <> nil then
    FreeAndNil(FTrueTypeBmp);
  inherited Destroy;
end;

procedure TSCCustomFontCombobox.DoDrawBack(C: TCanvas);
var
  Rgn: HRGN;
  IsTrueType: Boolean;
  CR, R: TRect;
  W, SR, Index, Bs: Integer;
begin
  inherited DoDrawBack(C);

  if (C <> nil) and FShowImages and
    (FTrueTypeBmp <> nil) and (scftTrueType in FFontTypes) then
  begin
    IsTrueType := False;

    Index := Items.IndexOf(Text);
    if Index > -1 then
      IsTrueType := TSCFontStrings(Items).Data[Index, 9] = Integer(scftTrueType);

    if not IsTrueType then
      Exit;

    CR := GetClientRect;
    if IsRectEmpty(CR) then
      Exit;

    Bs := GetStyleBorderSize + 2;
    InflateRect(CR, -Bs, -Bs);

    if not IsRectEmpty(CR) then
    begin
      R := CR;
      R.Right := R.Left + 20;

      W := CheckboxWidth;
      OffsetRect(R, W, 0);

      IntersectRect(R, R, CR);
      if not IsRectEmpty(R) then
      begin
        Rgn := CreateRectRgnIndirect(R);
        try
          SR := ExtSelectClipRgn(C.Handle, Rgn, RGN_COPY);
          DeleteObject(Rgn);
          Rgn := 0;

          if SR <> NULLREGION then
            C.Draw(R.Left, R.Top + ((R.Bottom - R.Top - FTrueTypeBmp.Height) div 2),
              FTrueTypeBmp);
        finally
          SelectClipRgn(C.Handle, 0);
          if Rgn <> 0 then
            DeleteObject(Rgn);
        end;
      end;
    end;
  end;
end;

function TSCCustomFontCombobox.GetDropDownHeight: Integer;
begin
  Result := inherited GetDropDownHeight;
  
  if (ListBox <> nil) and (FMRUCount > 0) and
    (TSCDropDownFontListbox(ListBox).FMRUList.Count > 0) then
    Inc(Result, 3);
end;

function TSCCustomFontCombobox.GetEditColorsClass: TSCEditCustomColorsClass;
begin
  Result := TSCFontComboEditColors;
end;

function TSCCustomFontCombobox.GetFontName: TFontName;
begin
  Result := GetText;
end;

function TSCCustomFontCombobox.GetListboxClass: TSCSimpleListboxClass;
begin
  Result := TSCDropDownFontListbox;
end;

function TSCCustomFontCombobox.ItemCheckStateForCloseup(Index: Integer): TSCCheckState;
begin
  Result := inherited ItemCheckstateForCloseup(Index);
  
  if (ListBox is TSCDropDownFontListbox) and not GetDroppedDown and (FMRUCount > 0) then
    with TSCDropDownFontListbox(Listbox) do
      if FMRUList.Count > 0 then
        Result := DataToState(TSCFontStrings(FMRUList).Data[0, 4]);
end;

procedure TSCCustomFontCombobox.Loaded;
begin
  inherited Loaded;
  LoadFontImages;
  RefreshFontNames;
  StyleChanged;
end;

procedure TSCCustomFontCombobox.LoadFontImages;
begin
  if FTrueTypeBmp <> nil then
    FreeAndNil(FTrueTypeBmp);

  FTrueTypeBmp := TBitmap.Create;
  with FTrueTypeBmp do
  begin
    Handle := LoadBitmap(HInstance, 'SC_TRUE_FONT');
    TransparentMode := tmAuto;
    Transparent := True;
  end;

  if FTrueTypeBmp.Handle = 0 then
    FreeAndNil(FTrueTypeBmp);
end;

procedure TSCCustomFontCombobox.PrepareDropWindow;
var
  Ind: Integer;
begin
  if ListBox <> nil then
    with TSCDropDownFontListbox(ListBox) do
      Items.BeginUpdate;

  try
    inherited PrepareDropWindow;

    Ind := 0;
    if FShowImages then Ind := 20;

    if ListBox <> nil then
      with TSCDropDownFontListbox(ListBox) do
      begin
        FontTypes    := Self.FFontTypes;
        MRUCount     := Self.MRUCount;

        InsertMRUs;

        ItemIndex := Items.IndexOf(Self.Text);
        TopIndex  := ItemIndex;

        if ItemIndex > -1 then
          MakeVisible(ItemIndex);

        Indent := Ind;
        FontName := Self.FontName;
      end;
    finally
      if ListBox <> nil then
        TSCDropDownFontListbox(ListBox).Items.EndUpdate;
    end;
end;

procedure TSCCustomFontCombobox.RefreshFontNames;
var
  DC: HDC;
  I, FontData: Integer;
  LFont: TLogFont;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  Items.BeginUpdate;
  try
    Items.Clear;
    if FFontTypes = [] then
      Exit;

    DC := GetDC(0);
    try
      if FFontCharsetActive then
      begin
        FillChar(LFont, SizeOf(LFont), 0);
        LFont.lfCharset := FFontCharSet;
        EnumFontFamiliesEx(DC, LFont, @EnumFontsProc, Longint(Items), 0);
      end else
        EnumFontFamilies(DC, nil, @EnumFontsProc, Longint(Items));
    finally
      ReleaseDC(0, DC);
    end;

    for I := Items.Count - 1 downto 0 do
    begin
      FontData := -1;
      Self.IndentLevel[I] := 1;

      case TSCFontStrings(Items).Data[I, 9] of
        DEVICE_FONTTYPE:
          if scftDevice in FFontTypes then
            FontData := Integer(scftDevice);
        RASTER_FONTTYPE:
          if scftRaster in FFontTypes then
            FontData := Integer(scftRaster);
        TRUETYPE_FONTTYPE:
          if scftTrueType in FFontTypes then
            FontData := Integer(scftTrueType);
      end;

      if FontData > -1 then
        TSCFontStrings(Items).Data[I, 9] := FontData
      else
        Items.Delete(I);
    end;

    TSCFontStrings(Items).Sort;
  finally
    Items.EndUpdate;
  end;
end;

procedure TSCCustomFontCombobox.SetFontCharSet(Value: TFontCharset);
begin
  if FFontCharSet <> Value then
  begin
    FFontCharSet := Value;
    if FFontCharsetActive then
      RefreshFontNames;
  end;
end;

procedure TSCCustomFontCombobox.SetFontCharsetActive(Value: Boolean);
begin
  if FFontCharsetActive <> Value then
  begin
    FFontCharsetActive := Value;
    RefreshFontNames;
  end;
end;

procedure TSCCustomFontCombobox.SetFontName(const Value: TFontName);
begin
  SetText(Value);
  if (ListBox <> nil) and DroppedDown then
    TSCDropDownFontListbox(ListBox).FontName := Value;
end;

procedure TSCCustomFontCombobox.SetFontTypes(Value: TSCFontTypes);
begin
  if FFontTypes <> Value then
  begin
    FFontTypes := Value;
    RefreshFontNames;
  end;
end;

procedure TSCCustomFontCombobox.SetMRUCount(Value: Integer);
begin
  if Value < 0 then Value := 0;
  
  FMRUCount := Value;
  if (ListBox <> nil) and DroppedDown then
    TSCDropDownFontListbox(ListBox).MRUCount := Value;
end;

procedure TSCCustomFontCombobox.SetSampleText(const Value: String);
begin
  FSampleText := Value;
end;

procedure TSCCustomFontCombobox.SetShowImages(Value: Boolean);
begin
  if FShowImages <> Value then
  begin
    FShowImages := Value;
    if not (IsLoading or IsReading) then
      StyleChanged;
  end;
end;

procedure TSCCustomFontCombobox.UpdateBorderRect(var R: TRect);
begin
  inherited UpdateBorderRect(R);

  if FShowImages then
    Inc(R.Left, 20);
end;

{ TSCCustomColorListbox }

procedure TSCCustomColorListbox.BeforePaintItem(C: TCanvas; Index: Integer;
  ClientR, R: TRect; State: TSCSimpleListState);
var
  Cl: TColor;
  Ind: Integer;
begin
  if (FDisplayType = scdtColorsAndNames) and (C = nil) or (Index < 0) and
    (Index > Items.Count-1) or IsRectEmpty(ClientR) then
    Exit;

  Ind := Indent*TSCColorStrings(Items).Data[Index, 6];
  if Ind > 0 then
  begin
    R.Right := R.Left;
    Dec(R.Left, Ind);

    InflateRect(R, -2, -2);
    try
      if IsRectEmpty(R) or (IntersectClipRect(C.Handle,
        R.Left, R.Top, R.Right, R.Bottom) = NULLREGION) then
        Exit;

      Cl := TSCFontStrings(Items).Data[Index, 9];
      
      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := clWindowFrame;

        Brush.Color := Cl;
        Brush.Style := bsSolid;

        Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      end;
    finally
      SelectClipRgn(C.Handle, 0);
    end;
  end;
end;

function TSCCustomColorListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

procedure TSCCustomColorListbox.CustomColorsChanged(Sender: TSCColorItems;
  Item: TCollectionItem);
begin
  if sccoShowCustomColors in FOptions then
    RefreshColors;
end;

constructor TSCCustomColorListbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCustomColors := TSCColorItems.Create(Self);
  FCustomColors.OnUpdate := CustomColorsChanged;

  ControlStyle := ControlStyle - [csSetCaption];
  SetBounds(Left, Top, 135, 125);

  AllowEdit := False;
  EndEllipsis := True;
  Indent := 24;
  ScrollbarHorizontal := False;

  FAutoColor := clNone;
  FColorWidth := 24;
  FDisplayType := scdtColorsAndNames;
  FOptions := [sccoShowStandardColors];
  FSelectedColor := clNone;
end;

destructor TSCCustomColorListbox.Destroy;
begin
  FCustomColors.OnUpdate := nil;
  FreeAndNil(FCustomColors);
  inherited Destroy;
end;

function TSCCustomColorListbox.GetMaxWidth: Integer;
begin
  Result := inherited GetMaxWidth;
end;

procedure TSCCustomColorListbox.RefreshColors;
var
  C: TColor;
  S: String;
  L: TList;
  I: Integer;
  Cl: LongInt;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  with TSCColorStrings(Items) do
  begin
    L := TList.Create;
    try
      BeginUpdate;
      try
        Clear;
      
        if sccoShowAutoColor in FOptions then
        begin
          C := FAutoColor;
          S := GetAutoCaption;

          L.Add(Pointer(C));
          if Assigned(FOnGetColor) then
            FOnGetColor(Self, C, S);

          Add(S);
          Data[Count-1, 9] := C;
          Data[Count-1, 6] := 1;
        end;

        if sccoShowStandardColors in FOptions then
          for I := Low(scColors) to Low(scColors) + 15 do
          begin
            C := scColors[I].Value;
            if ((C = clNone) and (sccoShowColorNone in FOptions)) or (L.IndexOf(Pointer(C)) > -1) or
              ((sccoShowAutoColor in FOptions) and (C = FAutoColor)) then
              Continue;

            L.Add(Pointer(C));

            S := scColors[I].Name;
            if SameText(Copy(S, 1, 2), 'cl') then
              System.Delete(S, 1, 2);

            if Assigned(FOnGetColor) then
              FOnGetColor(Self, C, S);

            Add(S);
            Data[Count-1, 9] := C;
            Data[Count-1, 6] := 1;
          end;

        if (sccoShowColorNone in FOptions) and
          not ((sccoShowAutoColor in FOptions) and (FAutoColor = clNone)) then
        begin
          C := clNone;
          L.Add(Pointer(C));

          S := 'None';
          if Assigned(FOnGetColor) then
            FOnGetColor(Self, C, S);

          Add(S);
          Data[Count-1, 9] := C;
          Data[Count-1, 6] := 1;
        end;

        if sccoShowSystemColors in FOptions then
          for I := Low(scColors) + 16 to High(scColors) - 1 do
          begin
            C := scColors[I].Value;
            if ((C = clNone) and (sccoShowColorNone in FOptions)) or (L.IndexOf(Pointer(C)) > -1) or
              ((sccoShowAutoColor in FOptions) and (C = FAutoColor)) then
              Continue;

            L.Add(Pointer(C));

            S := scColors[I].Name;
            if SameText(Copy(S, 1, 2), 'cl') then
              System.Delete(S, 1, 2);

            if Assigned(FOnGetColor) then
              FOnGetColor(Self, C, S);

            Add(S);
            Data[Count-1, 9] := C;
            Data[Count-1, 6] := 1;
          end;

        if sccoShowWebSafeColors in FOptions then
          for I := Low(scWebSafeColors) to High(scWebSafeColors) do
          begin
            C := scWebSafeColors[I].Value;
            if ((C = clNone) and (sccoShowColorNone in FOptions)) or (L.IndexOf(Pointer(C)) > -1) or
              ((sccoShowAutoColor in FOptions) and (C = FAutoColor)) then
              Continue;

            L.Add(Pointer(C));

            S := scWebSafeColors[I].Name;
            if SameText(Copy(S, 1, 2), 'cl') then
              System.Delete(S, 1, 2);

            if Assigned(FOnGetColor) then
              FOnGetColor(Self, C, S);

            Add(S);
            Data[Count-1, 9] := C;
            Data[Count-1, 6] := 1;
          end;

        if sccoShowCustomColors in FOptions then
          for I := 0 to FCustomColors.Count-1 do
          begin
            C := FCustomColors[I].Color;
            if ((C = clNone) and (sccoShowColorNone in FOptions)) or (L.IndexOf(Pointer(C)) > -1) or
              ((sccoShowAutoColor in FOptions) and (C = FAutoColor)) then
              Continue;

            L.Add(Pointer(C));
            S := FCustomColors[I].Caption;

            if S = '' then
            begin
              if ColorToIdent(C, S) then
              begin
                if SameText(Copy(S, 1, 2), 'cl') then
                  System.Delete(S, 1, 2);
              end else
              begin
                Cl := ColorToRGB(C);

                S := IntToHex(GetRValue(Cl), 2) + ', ' +
                  IntToHex(GetGValue(Cl), 2) + ', ' + IntToHex(GetBValue(Cl), 2);
              end;
            end;

            if Assigned(FOnGetColor) then
              FOnGetColor(Self, C, S);

            Add(S);
            Data[Count-1, 9] := C;
            Data[Count-1, 6] := 1;
          end;

        for I := 0 to Count-1 do
          if Data[Count-1, 9] = FSelectedColor then
          begin
            ItemIndex := I;
            Break;
          end;
      finally
        EndUpdate;
      end;
    finally
      L.Free;
    end;
  end;
end;

procedure TSCCustomColorListbox.SetCustomColors(Value: TSCColorItems);
begin
  FCustomColors.Assign(Value);
end;

procedure TSCCustomColorListbox.SetOptions(Value: TSCColorOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    if not InItemUpdate and not (IsLoading or IsReading) then
      RefreshColors;
  end;
end;

procedure TSCCustomColorListbox.VerifyHorizontalPos(var P: Integer);
begin
  P := 0;
end;

procedure TSCCustomColorListbox.CreateWnd;
begin
  inherited CreateWnd;
  // RefreshColors;
end;

procedure TSCCustomColorListbox.SetDisplayType(Value: TSCColorDisplayType);
var
  Ind: Integer;
begin
  if FDisplayType <> Value then
  begin
    FDisplayType := Value;

    Ind := 0;
    if FDisplayType = scdtColorsAndNames then
      Ind := FColorWidth;

    Indent := Ind;
    if not InItemUpdate then
      Invalidate;
  end;
end;

procedure TSCCustomColorListbox.SetAutoCaption(Value: String);
begin
  if FAutoCaption <> Value then
  begin
    FAutoCaption := Value;
    if not InItemUpdate and (Items.Count > 0) and
      (sccoShowAutoColor in FOptions) then
      Items[0] := GetAutoCaption;
  end;
end;

procedure TSCCustomColorListbox.SetAutoColor(Value: TColor);
begin
  if FAutoColor <> Value then
  begin
    FAutoColor := Value;
    if not InItemUpdate and (Items.Count > 0) and
      (sccoShowAutoColor in FOptions) then
      TSCColorStrings(Items).Data[0, 9] := FAutoColor;
  end;
end;

procedure TSCCustomColorListbox.SetSelectedColor(Value: TColor);
var
  I, Index: Integer;
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;

    if not InItemUpdate then
    begin
      Index := -1;

      with TSCColorStrings(Items) do
        for I := 0 to Count-1 do
          if Data[I, 9] = FSelectedColor then
          begin
            Index := I;
            Break;
          end;

      ItemIndex := Index;
      if ItemIndex > -1 then
        MakeVisible(ItemIndex);
    end;

    if Assigned(FOnSetColor) then
      FOnSetColor(Self);
  end;
end;

function TSCCustomColorListbox.GetAutoCaption: String;
begin
  Result := 'Auto';
  if FAutoCaption <> '' then
    Result := FAutoCaption;
end;

procedure TSCCustomColorListbox.DoItemClick(Index: Integer);
var
  Cl: TColor;
begin
  if (Index > -1) and (Index < Items.Count) then
  begin
    Cl := TSCFontStrings(Items).Data[Index, 9];

    if Cl <> FSelectedColor then
    begin
      FSelectedColor := Cl;
      if Assigned(FOnSetColor) then
        FOnSetColor(Self);
    end;
  end;
end;

procedure TSCCustomColorListbox.DoDrawItem(C: TCanvas; Index: Integer; CR,
  R: TRect; State: TSCSimpleListState);
var
  Cl: TColor;
begin
  if (C = nil) or IsRectEmpty(R) or IsRectEmpty(CR) or
    (Index < 0) or (Index > Count-1) then
    Exit;

  if FDisplayType <> scdtColors then
    inherited DoDrawItem(C, Index, CR, R, State)
  else begin
    Cl := clNone;
    if sclsDisabled in State then
      Cl := DisabledColor
    else
    if sclsSelected in State then
    begin
      Cl  := HighlightColor;
      if not Focused then
        Cl  := HideSelectionColor;
    end;

    with C do
    begin
      Brush.Style := bsSolid;
      if Cl <> clNone then
      begin
        Brush.Color := Cl;
        FillRect(R);
      end;

      InflateRect(R, -2, -2);
      if not IsRectEmpty(R) then
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := clWindowFrame;

        Brush.Color := TSCColorStrings(Items).Data[Index, 9];

        Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      end;
      
      InflateRect(R, 2, 2);  
    end;

    if not IsDesigning and not HideFocusRect and
      (sclsFocused in State) and Focused then
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      scDrawFocusRect(C, R, Cl);
    end;
  end;
end;

procedure TSCCustomColorListbox.Loaded;
begin
  inherited Loaded;

  RefreshColors;
  if Assigned(FOnSetColor) then
    FOnSetColor(Self);
end;

procedure TSCCustomColorListbox.SetColorWidth(Value: Integer);
begin
  if FColorWidth <> Value then
  begin
    FColorWidth := Value;
    if FDisplayType = scdtColorsAndNames then
      Indent := Value;
  end;
end;

procedure TSCCustomColorListbox.IndentChanged;
begin
  if FDisplayType = scdtColorsAndNames then
    inherited IndentChanged;
end;

procedure TSCCustomColorListbox.SystemColorsChanged;
begin
  RefreshColors;
  inherited SystemColorsChanged;
end;

procedure TSCCustomColorListbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomColorListbox then
  begin
    with TSCCustomColorListbox(Source) do
    begin
      Self.AutoCaption := AutoCaption;
      Self.AutoColor := AutoColor;
      Self.ColorWidth := ColorWidth;
      Self.CustomColors := CustomColors;
      Self.DisplayType := DisplayType;
      Self.Options := Options;
      Self.SelectedColor := SelectedColor;
    end;
  end;
end;

procedure TSCCustomColorListbox.AfterConstruction;
begin
  inherited AfterConstruction;
  RefreshColors;
end;

{ TSCColorItem }

procedure TSCColorItem.Assign(Source: TPersistent);
begin
  if Source is TSCColorItem then
  begin
    BeginUpdate;
    try
      with TSCColorItem(Source) do
      begin
        Self.Caption := Caption;
        Self.Color   := Color;
        Self.ID      := ID;
      end;
    finally
      EndUpdate;
    end;
  end else
    inherited Assign(Source);
end;

procedure TSCColorItem.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

constructor TSCColorItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FColor := clNone;
end;

procedure TSCColorItem.DoChanged(AllItems: Boolean);
var
  C: Byte;
begin
  if FUpdateCount > 0 then
  begin
    if AllItems then
      FChanged := 2
    else
    if FChanged = 0 then
      FChanged := 1;

    Exit;
  end;

  C := FChanged;
  FChanged := 0;

  Changed(AllItems or (C > 1));
end;

procedure TSCColorItem.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if (FUpdateCount = 0) and (FChanged > 0) then
      Changed(FChanged > 1);
  end;
end;

function TSCColorItem.GetDisplayName: string;
var
  C: LongInt;
begin
  if FCaption <> '' then
    Result := FCaption
  else begin
    if ColorToIdent(FColor, Result) then
    begin
      if SameText(Copy(Result, 1, 2), 'cl') then
        System.Delete(Result, 1, 2);
    end else
    begin
      C := ColorToRGB(FColor);
      Result := 'RGB : ' + IntToHex(GetRValue(C), 2) + ', ' +
        IntToHex(GetGValue(C), 2) + ', ' + IntToHex(GetBValue(C), 2);
    end;
  end;
end;

function TSCColorItem.InUpdate: Boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TSCColorItem.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    DoChanged(False);
  end;
end;

procedure TSCColorItem.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    DoChanged(False);
  end;
end;

{ TSCColorItems }

function TSCColorItems.Add: TSCColorItem;
begin
  Result := TSCColorItem(inherited Add);
end;

constructor TSCColorItems.Create(AOwner: TSCCustomControl);
begin
  inherited Create(TSCColorItem);
  FOwner := AOwner;
end;

function TSCColorItems.GetItem(Index: Integer): TSCColorItem;
begin
  Result := TSCColorItem(inherited GetItem(Index));
end;

function TSCColorItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCColorItems.SetItem(Index: Integer; Value: TSCColorItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCColorItems.Update(Item: TCollectionItem);
begin
  if Assigned(FOnUpdate) then
    FOnUpdate(Self, Item);
end;

{ TSCCustomColorCombobox }

procedure TSCCustomColorCombobox.AfterCloseUp;
begin
  if Listbox is TSCDropDownColorListbox then
    TSCDropDownColorListbox(Listbox).FDroppedDown := False;

  inherited AfterCloseUp;
end;

procedure TSCCustomColorCombobox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomColorCombobox then
  begin
    with TSCCustomColorCombobox(Source) do
    begin
      Self.AutoCaption := AutoCaption;
      Self.AutoColor := AutoColor;
      Self.ColorWidth := ColorWidth;
      Self.CustomColors := CustomColors;
      Self.DisplayType := DisplayType;
      Self.Options := Options;
      Self.SelectedColor := SelectedColor;
    end;
  end;
end;

constructor TSCCustomColorCombobox.Create(AOwner: TComponent);
begin
  FAutoColor := clNone;
  FColorWidth := 24;
  FDisplayType := scdtColorsAndNames;
  FOptions := [sccoShowStandardColors];
  FSelectedColor := clNone;

  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  DropDownCount := 12;
  AutoComplete := True;
  ImmediateDropDown := True;
  IsDropDown := True;

  FCustomColors := TSCColorItems.Create(Self);
  FCustomColors.OnUpdate := CustomColorsChanged;
end;

procedure TSCCustomColorCombobox.CreateWnd;
begin
  inherited CreateWnd;
  RefreshColors;
end;

procedure TSCCustomColorCombobox.CustomColorsChanged(Sender: TSCColorItems;
  Item: TCollectionItem);
begin
  if sccoShowCustomColors in FOptions then
    RefreshColors;
end;

destructor TSCCustomColorCombobox.Destroy;
begin
  FCustomColors.OnUpdate := nil;
  FreeAndNil(FCustomColors);
  inherited Destroy;
end;

procedure TSCCustomColorCombobox.DoDrawBack(C: TCanvas);
var
  W, Bs: Integer;
  CR, R, R2: TRect;
begin
  inherited DoDrawBack(C);

  if (C <> nil) and (FDisplayType = scdtColorsAndNames) then
  begin
    CR := GetClientRect;

    Bs := GetStyleBorderSize;
    InflateRect(CR, -Bs, -Bs);

    if not IsRectEmpty(CR) then
    begin
      R := Rect(0, 0, 0, 0);
      inherited UpdateBorderRect(R);

      R2 := R;
      if FColorWidth > 0 then
        Inc(R2.Left, FColorWidth + 4);

      with R2 do
      begin
        Top    := CR.Top;
        Bottom := CR.Bottom;
        Right  := Bs + Left;
        Left   := Bs + R.Left;
      end;

      InflateRect(R2, -2, -2);

      W := CheckboxWidth;
      OffsetRect(R2, W, 0);

      if not IsRectEmpty(R2) then
        with C do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := clWindowFrame;

          Brush.Color := FSelectedColor;
          Brush.Style := bsSolid;

          Rectangle(R2.Left, R2.Top, R2.Right, R2.Bottom);
        end;
    end;
  end;  
end;

procedure TSCCustomColorCombobox.DoInternalChange;
var
  Cl: TColor;
  Index: Integer;
begin
  Cl := FSelectedColor;
  Index := TSCFontStrings(Items).IndexOf(Self.Text);
  if Index > -1 then
    Cl := TSCFontStrings(Items).Data[Index, 9];

  if Cl <> FSelectedColor then
  begin
    FSelectedColor := Cl;
    if Assigned(FOnSetColor) then
      FOnSetColor(Self);
  end;
end;

procedure TSCCustomColorCombobox.DoListClick(Index: Integer; const Item: String);
begin
  if Index > -1 then
  begin
    if (ListBox <> nil) and DroppedDown then
    begin
      with TSCDropDownFontListbox(ListBox), TSCColorStrings(Items) do
        if Index < Count then
        begin
          FSelectedColor := Data[Index, 9];
          if Assigned(FOnSetColor) then
            FOnSetColor(Self);
        end;
    end else
    if Index < Items.Count then
      with TSCColorStrings(Items) do
      begin
        FSelectedColor := Data[Index, 9];
        if Assigned(FOnSetColor) then
          FOnSetColor(Self);
      end;
  end;
end;

function TSCCustomColorCombobox.GetAutoCaption: String;
begin
  Result := 'Auto';
  if FAutoCaption <> '' then
    Result := FAutoCaption;
end;

function TSCCustomColorCombobox.GetEditColorsClass: TSCEditCustomColorsClass;
begin
  Result := TSCFontComboEditColors;
end;

function TSCCustomColorCombobox.GetIsDropDown: Boolean;
begin
  Result := inherited GetIsDropDown or (FDisplayType = scdtColors);
end;

function TSCCustomColorCombobox.GetListboxClass: TSCSimpleListboxClass;
begin
  Result := TSCDropDownColorListbox;
end;

procedure TSCCustomColorCombobox.Loaded;
begin
  inherited Loaded;
  StyleChanged;
  UpdateColorText;
end;

procedure TSCCustomColorCombobox.PaintLine(C: TCanvas; Index, H,
  TxTop: Integer);
var
  Bs: Integer;
  CR, R, R1: TRect;
  IsFocused: Boolean;
begin
  if FDisplayType <> scdtColors then
    inherited PaintLine(C, Index, H, TxTop)
  else begin
    if (C = nil) or (H = 0) then
      Exit;

    CR := GetClientRect;
    if IsRectEmpty(CR) then
      Exit;

    R := Rect(0, 0, 0, 0);
    UpdateBorderRect(R);

    R1 := CR;

    Inc(R1.Left,   R.Left);
    Dec(R1.Right,  R.Right);
    Inc(R1.Top,    R.Top);
    Dec(R1.Bottom, R.Bottom);

    if IsRectEmpty(R1) then Exit;

    Bs := GetStyleBorderSize;
    InflateRect(R1, -Bs, -Bs);

    Inc(R1.Left);
    
    if not IsRectEmpty(R1) then
    begin
      IsFocused := not Self.IsDesigning and
        Focused and not GetDroppedDown;

      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := clWindowFrame;

        Brush.Style := bsSolid;
        Brush.Color := FSelectedColor;

        Rectangle(R1.Left, R1.Top, R1.Right, R1.Bottom);
      end;

      if IsFocused then
        scDrawFocusRect(C, R1, FSelectedColor);
    end;
  end;
end;

procedure TSCCustomColorCombobox.PrepareDropWindow;
var
  Ind: Integer;
begin
  if ListBox <> nil then
    with TSCDropDownColorListbox(ListBox) do
      Items.BeginUpdate;

  try
    RefreshColors;
    inherited PrepareDropWindow;

    if ListBox <> nil then
      with TSCDropDownColorListbox(ListBox) do
      begin
        AutoCaption   := Self.AutoCaption;
        AutoColor     := Self.AutoColor;
        ColorWidth    := Self.ColorWidth;
        CustomColors  := Self.CustomColors;
        DisplayType   := Self.DisplayType;
        Options       := Self.Options;
        SelectedColor := Self.SelectedColor;

        Office12Style := False;
        if Self.Style = scesOffice12 then
          Office12Style := True;

        ItemIndex := Items.IndexOf(Self.Text);
        TopIndex  := ItemIndex;

        Ind := 0;
        if FDisplayType = scdtColorsAndNames then
          Ind := Self.ColorWidth;

        Indent := Ind;

        if ItemIndex > -1 then
          MakeVisible(ItemIndex);
      end;
    finally
      if ListBox <> nil then
        TSCDropDownColorListbox(ListBox).Items.EndUpdate;
    end;
end;

procedure TSCCustomColorCombobox.RefreshColors;
var
  C: TColor;
  S: String;
  L: TList;
  Cl: LongInt;
  I, Cnt: Integer;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  with TSCColorStrings(Items) do
  begin
    L := TList.Create;
    try
      BeginUpdate;
      try
        Clear;
      
        if sccoShowAutoColor in FOptions then
        begin
          C := FAutoColor;
          S := GetAutoCaption;

          L.Add(Pointer(C));
          if Assigned(FOnGetColor) then
            FOnGetColor(Self, C, S);

          Cnt := Add(S);
          Data[Cnt, 9] := C;
          Data[Cnt, 6] := 1;
        end;

        if sccoShowStandardColors in FOptions then
          for I := Low(scColors) to Low(scColors) + 15 do
          begin
            C := scColors[I].Value;
            if ((C = clNone) and (sccoShowColorNone in FOptions)) or (L.IndexOf(Pointer(C)) > -1) or
              ((sccoShowAutoColor in FOptions) and (C = FAutoColor)) then
              Continue;

            L.Add(Pointer(C));

            S := scColors[I].Name;
            if SameText(Copy(S, 1, 2), 'cl') then
              System.Delete(S, 1, 2);

            if Assigned(FOnGetColor) then
              FOnGetColor(Self, C, S);

            Cnt := Add(S);
            Data[Cnt, 9] := C;
            Data[Cnt, 6] := 1;
          end;

        if (sccoShowColorNone in FOptions) and
          not ((sccoShowAutoColor in FOptions) and (FAutoColor = clNone)) then
        begin
          C := clNone;
          L.Add(Pointer(C));

          S := 'None';
          if Assigned(FOnGetColor) then
            FOnGetColor(Self, C, S);

          Add(S);
          Data[Count-1, 9] := C;
          Data[Count-1, 6] := 1;
        end;

        if sccoShowSystemColors in FOptions then
          for I := Low(scColors) + 16 to High(scColors) - 1 do
          begin
            C := scColors[I].Value;
            if ((C = clNone) and (sccoShowColorNone in FOptions)) or (L.IndexOf(Pointer(C)) > -1) or
              ((sccoShowAutoColor in FOptions) and (C = FAutoColor)) then
              Continue;

            L.Add(Pointer(C));

            S := scColors[I].Name;
            if SameText(Copy(S, 1, 2), 'cl') then
              System.Delete(S, 1, 2);

            if Assigned(FOnGetColor) then
              FOnGetColor(Self, C, S);

            Cnt := Add(S);
            Data[Cnt, 9] := C;
            Data[Cnt, 6] := 1;
          end;

        if sccoShowWebSafeColors in FOptions then
          for I := Low(scWebSafeColors) to High(scWebSafeColors) do
          begin
            C := scWebSafeColors[I].Value;
            if ((C = clNone) and (sccoShowColorNone in FOptions)) or (L.IndexOf(Pointer(C)) > -1) or
              ((sccoShowAutoColor in FOptions) and (C = FAutoColor)) then
              Continue;

            L.Add(Pointer(C));

            S := scWebSafeColors[I].Name;
            if SameText(Copy(S, 1, 2), 'cl') then
              System.Delete(S, 1, 2);

            if Assigned(FOnGetColor) then
              FOnGetColor(Self, C, S);

            Add(S);
            Data[Count-1, 9] := C;
            Data[Count-1, 6] := 1;
          end;

        if (sccoShowCustomColors in FOptions) and (FCustomColors <> nil) then
          for I := 0 to FCustomColors.Count-1 do
          begin
            C := FCustomColors[I].Color;
            if ((C = clNone) and (sccoShowColorNone in FOptions)) or (L.IndexOf(Pointer(C)) > -1) or
              ((sccoShowAutoColor in FOptions) and (C = FAutoColor)) then
              Continue;

            L.Add(Pointer(C));
            S := FCustomColors[I].Caption;
            if S = '' then
            begin
              if ColorToIdent(C, S) then
              begin
                if SameText(Copy(S, 1, 2), 'cl') then
                  System.Delete(S, 1, 2);
              end else
              begin
                Cl := ColorToRGB(C);

                S := IntToHex(GetRValue(Cl), 2) + ', ' +
                  IntToHex(GetGValue(Cl), 2) + ', ' + IntToHex(GetBValue(Cl), 2);
              end;
            end;

            if Assigned(FOnGetColor) then
              FOnGetColor(Self, C, S);

            Cnt := Add(S);
            Data[Cnt, 9] := C;
            Data[Cnt, 6] := 1;
          end;

        for I := 0 to Count-1 do
          if Data[I, 9] = FSelectedColor then
          begin
            ItemIndex := I;
            Break;
          end;
      finally
        EndUpdate;
      end;
    finally
      L.Free;
    end;
  end;

  UpdateColorText;
end;

procedure TSCCustomColorCombobox.SetAutoCaption(const Value: String);
var
  S: String;
begin
  if FAutoCaption <> Value then
  begin
    FAutoCaption := Value;

    S := GetAutoCaption;
    if (FSelectedColor = FAutoColor) and (sccoShowAutoColor in FOptions) then
      SetText(S);

    if not InItemUpdate and (Items.Count > 0) and
      (sccoShowAutoColor in FOptions) then
      Items[0] := S;
  end;
end;

procedure TSCCustomColorCombobox.SetAutoColor(Value: TColor);
var
  NeedsUpdate: Boolean;
begin
  if FAutoColor <> Value then
  begin
    NeedsUpdate := (FSelectedColor = FAutoColor) or (FSelectedColor = Value);
    FAutoColor := Value;

    if not InItemUpdate and (Items.Count > 0) and
      (sccoShowAutoColor in FOptions) then
      TSCColorStrings(Items).Data[0, 9] := FAutoColor;

    if NeedsUpdate and (sccoShowAutoColor in FOptions) then
    begin
      UpdateColorText;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomColorCombobox.SetColorWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FColorWidth <> Value then
  begin
    FColorWidth := Value;
    if FDisplayType = scdtColorsAndNames then
      StyleChanged;
  end;
end;

procedure TSCCustomColorCombobox.SetCustomColors(Value: TSCColorItems);
begin
  FCustomColors.Assign(Value);
end;

procedure TSCCustomColorCombobox.SetDisplayType(Value: TSCColorDisplayType);
begin
  if FDisplayType <> Value then
  begin
    FDisplayType := Value;

    CanSelect := not (IsDropDown or (FDisplayType = scdtColors));
    UseCaret  := not (IsDropDown or (FDisplayType = scdtColors));
    UseUndo   := not (IsDropDown or (FDisplayType = scdtColors));

    if not InItemUpdate and not (IsLoading or IsReading) then
      StyleChanged;
  end;
end;

procedure TSCCustomColorCombobox.SetOptions(Value: TSCColorOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    RefreshColors;

    if not InItemUpdate and not (IsLoading or IsReading) then
      StyleChanged;
  end;
end;

procedure TSCCustomColorCombobox.SetSelectedColor(Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;

    UpdateColorText;
    Invalidate;

    if Assigned(FOnSetColor) then
      FOnSetColor(Self);
  end;
end;

procedure TSCCustomColorCombobox.SystemColorsChanged;
begin
  RefreshColors;
  inherited SystemColorsChanged;
end;

procedure TSCCustomColorCombobox.UpdateBorderRect(var R: TRect);
begin
  inherited UpdateBorderRect(R);

  if FDisplayType = scdtColors then
  begin
    R.Top := 2;
    R.Bottom := 2;
  end else
  if (FDisplayType = scdtColorsAndNames) and (FColorWidth > 0) then
    Inc(R.Left, FColorWidth + 4);
end;

procedure TSCCustomColorCombobox.UpdateColorText;
var
  S: String;
  I: Integer;
  C: LongInt;
begin
  if (sccoShowAutoColor in FOptions) and (FSelectedColor = FAutoColor) then
    SetText(GetAutoCaption)
  else begin
    with TSCColorStrings(Items) do
      for I := 0 to Count-1 do
        if FSelectedColor = Data[I, 9] then
        begin
          Self.SetText(Strings[I]);
          Exit;
        end;

    if ColorToIdent(FSelectedColor, S) then
    begin
      if SameText(Copy(S, 1, 2), 'cl') then
        System.Delete(S, 1, 2);
    end else
    begin
      C := ColorToRGB(FSelectedColor);
      S := IntToHex(GetRValue(C), 2) + ', ' +
        IntToHex(GetGValue(C), 2) + ', ' + IntToHex(GetBValue(C), 2);
    end;

    if Assigned(FOnGetColor) then
      FOnGetColor(Self, FSelectedColor, S);

    SetText(S);
  end;
end;

{ TSCCustomBrushStyleCombobox }

procedure TSCCustomBrushStyleCombobox.AfterCloseUp;
begin
  if Listbox is TSCDropDownColorListbox then
    TSCDropDownColorListbox(Listbox).FDroppedDown := False;

  inherited AfterCloseUp;
end;

procedure TSCCustomBrushStyleCombobox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomBrushStyleCombobox then
  begin
    with TSCCustomBrushStyleCombobox(Source) do
    begin
      Self.BrushColor := BrushColor;
      Self.StyleWidth := StyleWidth;
      Self.DisplayType := DisplayType;
      Self.SelectedStyle := SelectedStyle;
    end;
  end;
end;

constructor TSCCustomBrushStyleCombobox.Create(AOwner: TComponent);
begin
  FStyleWidth := 24;
  FBrushColor := clWindowText;
  FDisplayType := scbdBrushesAndNames;
  FSelectedStyle := bsSolid;

  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  DropDownCount := 12;
  AutoComplete := True;
  ImmediateDropDown := True;
  IsDropDown := True;
end;

procedure TSCCustomBrushStyleCombobox.CreateWnd;
begin
  inherited CreateWnd;
  RefreshStyles;
end;

procedure TSCCustomBrushStyleCombobox.DoDrawBack(C: TCanvas);
var
  W, Bs: Integer;
  CR, R, R2: TRect;
begin
  inherited DoDrawBack(C);

  if (C <> nil) and (FDisplayType = scbdBrushesAndNames) then
  begin
    CR := GetClientRect;

    Bs := GetStyleBorderSize;
    InflateRect(CR, -Bs, -Bs);

    if not IsRectEmpty(CR) then
    begin
      R := Rect(0, 0, 0, 0);
      inherited UpdateBorderRect(R);

      R2 := R;
      if FStyleWidth > 0 then
        Inc(R2.Left, FStyleWidth + 4);

      with R2 do
      begin
        Top    := CR.Top;
        Bottom := CR.Bottom;
        Right  := Bs + Left;
        Left   := Bs + R.Left;
      end;

      InflateRect(R2, -2, -2);

      W := CheckboxWidth;
      OffsetRect(R2, W, 0);

      if not IsRectEmpty(R2) then
        with C do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := clWindowFrame;

          Brush.Color := FBrushColor;
          Brush.Style := FSelectedStyle;

          Rectangle(R2.Left, R2.Top, R2.Right, R2.Bottom);
        end;
    end;
  end;  
end;

procedure TSCCustomBrushStyleCombobox.DoInternalChange;
var
  Index: Integer;
  Bs: TBrushStyle;
begin
  Bs := FSelectedStyle;
  Index := TSCBrushStrings(Items).IndexOf(Self.Text);
  if Index > -1 then Bs := TBrushStyle(TSCBrushStrings(Items).Data[Index, 9]);

  if Bs <> FSelectedStyle then
  begin
    FSelectedStyle := Bs;
    if Assigned(FOnSetStyle) then
      FOnSetStyle(Self);
  end;
end;

procedure TSCCustomBrushStyleCombobox.DoListClick(Index: Integer; const Item: String);
begin
  if Index > -1 then
  begin
    if (ListBox <> nil) and DroppedDown then
    begin
      with TSCDropDownBrushStyleListbox(ListBox), TSCBrushStrings(Items) do
        if Index < Count then
        begin
          FSelectedStyle := TBrushStyle(Data[Index, 9]);
          if Assigned(FOnSetStyle) then
            FOnSetStyle(Self);
        end;
    end else
    if Index < Items.Count then
      with TSCBrushStrings(Items) do
      begin
        FSelectedStyle := TBrushStyle(Data[Index, 9]);
        if Assigned(FOnSetStyle) then
          FOnSetStyle(Self);
      end;
  end;
end;

function TSCCustomBrushStyleCombobox.GetEditColorsClass: TSCEditCustomColorsClass;
begin
  Result := TSCModeStyleComboEditColors;
end;

function TSCCustomBrushStyleCombobox.GetIsDropDown: Boolean;
begin
  Result := inherited GetIsDropDown or (FDisplayType = scbdBrushes);
end;

function TSCCustomBrushStyleCombobox.GetListboxClass: TSCSimpleListboxClass;
begin
  Result := TSCDropDownBrushStyleListbox;
end;

procedure TSCCustomBrushStyleCombobox.Loaded;
begin
  inherited Loaded;
  StyleChanged;
  UpdateBrushText;
end;

procedure TSCCustomBrushStyleCombobox.PaintLine(C: TCanvas; Index, H,
  TxTop: Integer);
var
  Bs: Integer;
  CR, R, R1: TRect;
  IsFocused: Boolean;
begin
  if FDisplayType <> scbdBrushes then
    inherited PaintLine(C, Index, H, TxTop)
  else begin
    if (C = nil) or (H = 0) then
      Exit;

    CR := GetClientRect;
    if IsRectEmpty(CR) then
      Exit;

    R := Rect(0, 0, 0, 0);
    UpdateBorderRect(R);

    R1 := CR;

    Inc(R1.Left,   R.Left);
    Dec(R1.Right,  R.Right);
    Inc(R1.Top,    R.Top);
    Dec(R1.Bottom, R.Bottom);

    if IsRectEmpty(R1) then Exit;

    Bs := GetStyleBorderSize;
    InflateRect(R1, -Bs, -Bs);

    Inc(R1.Left);
    
    if not IsRectEmpty(R1) then
    begin
      IsFocused := not Self.IsDesigning and
        Focused and not GetDroppedDown;

      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := clWindowFrame;

        Brush.Color := Self.Color;
        Brush.Style := FSelectedStyle;

        Rectangle(R1.Left, R1.Top, R1.Right, R1.Bottom);
      end;

      if IsFocused then
        scDrawFocusRect(C, R1, Self.Color);
    end;
  end;
end;

procedure TSCCustomBrushStyleCombobox.PrepareDropWindow;
var
  Ind: Integer;
begin
  if ListBox <> nil then
    with TSCDropDownBrushStyleListbox(ListBox) do
      Items.BeginUpdate;

  try
    RefreshStyles;
    inherited PrepareDropWindow;

    if ListBox <> nil then
      with TSCDropDownBrushStyleListbox(ListBox) do
      begin
        BrushColor    := Self.BrushColor;
        StyleWidth    := Self.StyleWidth;
        DisplayType   := Self.DisplayType;
        SelectedStyle := Self.SelectedStyle;

        Office12Style := False;
        if Self.Style = scesOffice12 then
          Office12Style := True;

        ItemIndex := Items.IndexOf(Self.Text);
        TopIndex  := ItemIndex;

        Ind := 0;
        if FDisplayType = scbdBrushesAndNames then
          Ind := Self.StyleWidth;

        Indent := Ind;

        if ItemIndex > -1 then
          MakeVisible(ItemIndex);
      end;
    finally
      if ListBox <> nil then
        TSCDropDownBrushStyleListbox(ListBox).Items.EndUpdate;
    end;
end;

procedure TSCCustomBrushStyleCombobox.RefreshStyles;
var
  L: TList;
  S: String;
  I, Bs, Cnt: Integer;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  with TSCBrushStrings(Items) do
  begin
    L := TList.Create;
    try
      BeginUpdate;
      try
        Clear;
      
        for I := Low(scBrushStyleMap) to High(scBrushStyleMap) do
        begin
          Bs := scBrushStyleMap[I].Value;

          L.Add(Pointer(Bs));
          S := scBrushStyleMap[I].Name;

          if Assigned(FOnGetCaption) then
            FOnGetCaption(Self, Bs, S);

          Cnt := Add(S);
          Data[Cnt, 9] := Bs;
          Data[Cnt, 6] := 1;
        end;

        for I := 0 to Count-1 do
          if Data[Count-1, 9] = Integer(FSelectedStyle) then
          begin
            ItemIndex := I;
            Break;
          end;
      finally
        EndUpdate;
      end;
    finally
      L.Free;
    end;
  end;

  UpdateBrushText;
end;

procedure TSCCustomBrushStyleCombobox.SetBrushColor(Value: TColor);
begin
  if FBrushColor <> Value then
  begin
    FBrushColor := Value;
    if FDisplayType <> scbdNames then
      StyleChanged;
  end;
end;

procedure TSCCustomBrushStyleCombobox.SetStyleWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FStyleWidth <> Value then
  begin
    FStyleWidth := Value;
    if FDisplayType = scbdBrushesAndNames then
      StyleChanged;
  end;
end;

procedure TSCCustomBrushStyleCombobox.SetDisplayType(Value: TSCBrushStyleDisplayType);
begin
  if FDisplayType <> Value then
  begin
    FDisplayType := Value;

    CanSelect := not (IsDropDown or (FDisplayType = scbdNames));
    UseCaret  := not (IsDropDown or (FDisplayType = scbdNames));
    UseUndo   := not (IsDropDown or (FDisplayType = scbdNames));

    if not InItemUpdate and not (IsLoading or IsReading) then
      StyleChanged;
  end;
end;

procedure TSCCustomBrushStyleCombobox.SetSelectedStyle(Value: TBrushStyle);
begin
  if FSelectedStyle <> Value then
  begin
    FSelectedStyle := Value;

    UpdateBrushText;
    Invalidate;

    if Assigned(FOnSetStyle) then
      FOnSetStyle(Self);
  end;
end;

procedure TSCCustomBrushStyleCombobox.UpdateBorderRect(var R: TRect);
begin
  inherited UpdateBorderRect(R);

  if FDisplayType = scbdNames then
  begin
    R.Top := 2;
    R.Bottom := 2;
  end else
  if (FDisplayType = scbdBrushesAndNames) and (FStyleWidth > 0) then
    Inc(R.Left, FStyleWidth + 4);
end;

procedure TSCCustomBrushStyleCombobox.UpdateBrushText;
var
  S: String;
  I, Bs: LongInt;
begin
  Bs := Integer(FSelectedStyle);

  with TSCBrushStrings(Items) do
    for I := 0 to Count-1 do
      if Bs = Data[I, 9] then
      begin
        Self.SetText(Strings[I]);
        Exit;
      end;

  S := '';
  for I := Low(scBrushStyleMap) to High(scBrushStyleMap) do
    if Bs = scBrushStyleMap[I].Value then
    begin
      S := scBrushStyleMap[I].Name;
      Break;
    end;

  if Assigned(FOnGetCaption) then
    FOnGetCaption(Self, Bs, S);

  SetText(S);
end;

{ TSCCustomFontSizeListbox }

procedure TSCCustomFontSizeListbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomFontSizeListbox then
  begin
    with TSCCustomFontSizeListbox(Source) do
    begin
      Self.FontName := FontName;
      Self.FontSize := FontSize;
    end;
  end;
end;

function TSCCustomFontSizeListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

constructor TSCCustomFontSizeListbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  SetBounds(Left, Top, 120, 125);

  AllowEdit := False;
  EndEllipsis := True;
  ScrollbarHorizontal := False;

  FFontSize := 8;
end;

procedure TSCCustomFontSizeListbox.CreateWnd;
begin
  inherited CreateWnd;
  RefreshFont;
end;

procedure TSCCustomFontSizeListbox.DoItemClick(Index: Integer);
begin
  //
end;

function TSCCustomFontSizeListbox.GetFontSizes(Index: Integer): Integer;
begin
  Result := 0;
  if (Index > -1) and (Index < Items.Count) then
  begin
    Result := TSCFontStrings(Items).Data[Index, 9];
    if Result = 0 then
      StrToIntDef(Items.Strings[Index], 0);
  end;
end;

procedure TSCCustomFontSizeListbox.Loaded;
begin
  inherited Loaded;
  RefreshFont;
end;

procedure TSCCustomFontSizeListbox.RefreshFont;
var
  DC: HDC;
  P: PSCFontSizeRec;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  DC := GetDC(0);
  Items.BeginUpdate;
  try
    Items.Clear;
    if FFontName <> '' then
    begin
      FPixelsPerInch := GetDeviceCaps(DC, LOGPIXELSY);
      New(P);
      try
        P^.Items := Self.Items;
        P^.PixelsPerInch := FPixelsPerInch;

        EnumFontFamilies(DC, PChar(FFontName), @EnumFontSizes, Longint(P));
      finally
        Dispose(P);
      end;
    end;
  finally
    Items.EndUpdate;
    ReleaseDC(0, DC);
  end;
  UpdateSelection;
end;

procedure TSCCustomFontSizeListbox.SetFontName(const Value: TFontName);
begin
  if FFontName <> Value then
  begin
    FFontName := Value;
    RefreshFont;
  end;
end;

procedure TSCCustomFontSizeListbox.SetFontSize(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FFontSize <> Value then
  begin
    FFontSize := Value;
    UpdateSelection;
  end;
end;

procedure TSCCustomFontSizeListbox.UpdateSelection;
var
  I, Index: Integer;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  Index := -1;
  for I := 0 to Items.Count-1 do
    if TSCFontStrings(Items).Data[I, 9] = FFontSize then
    begin
      Index := I;
      Break;
    end;

  ItemIndex := Index;
end;

procedure TSCCustomFontSizeListbox.VerifyHorizontalPos(var P: Integer);
begin
  P := 0;
end;

{ TSCCustomFontSizeCombobox }

procedure TSCCustomFontSizeCombobox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomFontSizeCombobox then
  begin
    with TSCCustomFontSizeCombobox(Source) do
    begin
      Self.FontName := FontName;
      Self.FontSize := FontSize;
    end;
  end;
end;

constructor TSCCustomFontSizeCombobox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  SetBounds(Left, Top, 65, Height);
  AutoComplete := True;
  DropDownCount := 8;
  IsDropDown := True;
end;

procedure TSCCustomFontSizeCombobox.CreateWnd;
begin
  inherited CreateWnd;
  RefreshFont;
end;

procedure TSCCustomFontSizeCombobox.DoInternalChange;
begin
  FFontSize := StrToIntDef(Self.Text, FFontSize);
end;

procedure TSCCustomFontSizeCombobox.DoListClick(Index: Integer;
  const Item: String);
var
  Fs: Integer;
begin
  Fs := FFontSize;
  if ListBox <> nil then
    with TSCCustomDropDownListbox(ListBox) do
      if (Index > -1) and (Index < Items.Count) then
        Fs := TSCFontStrings(Items).Data[Index, 9];

  FFontSize := Fs;
end;

function TSCCustomFontSizeCombobox.GetEditColorsClass: TSCEditCustomColorsClass;
begin
  Result := TSCFontComboEditColors;
end;

function TSCCustomFontSizeCombobox.GetFontSizes(Index: Integer): Integer;
begin
  Result := 0;
  if (Listbox <> nil) and DroppedDown then
  begin
    with TSCCustomDropDownListbox(ListBox) do
    begin
      if (Index > -1) and (Index < Items.Count) then
        Result := TSCFontStrings(Items).Data[Index, 9];
        
      if Result = 0 then
        StrToIntDef(Items.Strings[Index], 0);
    end;
  end else
  if (Index > -1) and (Index < Items.Count) then
  begin
    Result := TSCFontStrings(Items).Data[Index, 9];
    if Result = 0 then
      StrToIntDef(Items.Strings[Index], 0);
  end;
end;

procedure TSCCustomFontSizeCombobox.Loaded;
begin
  inherited Loaded;
  RefreshFont;
end;

procedure TSCCustomFontSizeCombobox.PrepareDropWindow;
var
  I, Index: Integer;
begin
  if ListBox <> nil then
    with TSCCustomDropDownListbox(ListBox) do
      Items.BeginUpdate;

  try
    RefreshFont;
    inherited PrepareDropWindow;

    if ListBox <> nil then
      with TSCCustomDropDownListbox(ListBox) do
      begin
        Office12Style := False;
        if Self.Style = scesOffice12 then
          Office12Style := True;

        Index := -1;
        for I := 0 to Items.Count-1 do
          if TSCFontStrings(Items).Data[I, 9] = FFontSize then
          begin
            Index := I;
            Break;
          end;

        ItemIndex := Index;
        TopIndex  := ItemIndex;

        if ItemIndex > -1 then
          MakeVisible(ItemIndex);
      end;
  finally
    if ListBox <> nil then
      TSCCustomDropDownListbox(ListBox).Items.EndUpdate;
  end;
end;

procedure TSCCustomFontSizeCombobox.RefreshFont;
var
  DC: HDC;
  P: PSCFontSizeRec;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  DC := GetDC(0);
  Items.BeginUpdate;
  try
    Items.Clear;
    if FFontName <> '' then
    begin
      FPixelsPerInch := GetDeviceCaps(DC, LOGPIXELSY);
      New(P);
      try
        P^.Items := Self.Items;
        P^.PixelsPerInch := FPixelsPerInch;

        EnumFontFamilies(DC, PChar(FFontName), @EnumFontSizes, Longint(P));
      finally
        Dispose(P);
      end;
    end;
  finally
    Items.EndUpdate;
    ReleaseDC(0, DC);
  end;
  
  UpdateSizeSelection;
end;

procedure TSCCustomFontSizeCombobox.SetFontName(const Value: TFontName);
begin
  if FFontName <> Value then
  begin
    FFontName := Value;
    RefreshFont;
  end;
end;

procedure TSCCustomFontSizeCombobox.SetFontSize(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FFontSize <> Value then
  begin
    FFontSize := Value;
    UpdateSizeSelection;
  end;
end;

procedure TSCCustomFontSizeCombobox.UpdateSizeSelection;
var
  I, Index: Integer;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  if (ListBox <> nil) and DroppedDown then
  begin
    with TSCCustomDropDownListbox(ListBox) do
    begin
      Index := 0;
      for I := 0 to Items.Count-1 do
        if TSCFontStrings(Items).Data[I, 9] = FFontSize then
        begin
          Index := I;
          Break;
        end;

      ItemIndex := Index;
      TopIndex  := ItemIndex;

      if ItemIndex > -1 then
      begin
        MakeVisible(ItemIndex);

        FFontSize := TSCFontStrings(Items).Data[I, 9];
        SetText(Items.Strings[ItemIndex]);
      end else
      begin
        FFontSize := 0;
        SetText('');
      end;
    end;
  end else
  begin
    Index := 0;
    with TSCFontStrings(Items) do
      for I := 0 to Items.Count-1 do
        if Data[I, 9] = FFontSize then
        begin
          Index := I;
          Break;
        end;

    if (Index > -1) and (Index < Items.Count) then
    begin
      FFontSize := TSCFontStrings(Items).Data[Index, 9];
      SetText(Items.Strings[Index]);
    end else
    begin
      FFontSize := 0;
      SetText('');
    end;
  end;
end;

{ TSCCustomFontCharsetListbox }

procedure TSCCustomFontCharsetListbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomFontCharsetListbox then
  begin
    with TSCCustomFontCharsetListbox(Source) do
    begin
      Self.AddDefaultCharset := AddDefaultCharset;
      Self.DefaultCharsetCaption := DefaultCharsetCaption;
      Self.FontCharSet := FontCharSet;
      Self.FontName := FontName;
    end;
  end;
end;

function TSCCustomFontCharsetListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

constructor TSCCustomFontCharsetListbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  SetBounds(Left, Top, 120, 125);

  AllowEdit := False;
  EndEllipsis := True;
  ScrollbarHorizontal := False;
end;

procedure TSCCustomFontCharsetListbox.CreateWnd;
begin
  inherited CreateWnd;
  RefreshFont;
end;

procedure TSCCustomFontCharsetListbox.DoItemClick(Index: Integer);
begin
  //
end;

function TSCCustomFontCharsetListbox.GetDefaultCharsetCaption: String;
begin
  Result := '( Default )';
  if FDefaultCharsetCaption <> '' then
    Result := FDefaultCharsetCaption;
end;

function TSCCustomFontCharsetListbox.GetFontCharsets(Index: Integer): TFontCharset;
begin
  Result := 0;
  if (Index > -1) and (Index < Items.Count) then
    Result :=  TFontCharset(TSCFontStrings(Items).Data[Index, 9]);
end;

procedure TSCCustomFontCharsetListbox.Loaded;
begin
  inherited Loaded;
  RefreshFont;
end;

procedure TSCCustomFontCharsetListbox.RefreshFont;
var
  DC: HDC;
  lf: TLogFont;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  DC := GetDC(0);
  Items.BeginUpdate;
  try
    Items.Clear;
    if FontName <> '' then
    begin
      FillChar(lf, SizeOf(lf), 0);

      lf.lfCharset := DEFAULT_CHARSET;
      Move(PChar(FontName)^, lf.lfFaceName, Length(FontName));

      EnumFontFamiliesEx(DC, lf, @EnumFontCharsets, Longint(Items), 0);

      if AddDefaultCharset then
      begin
        Items.Insert(0, GetDefaultCharsetCaption);
        TSCFontStrings(Items).Data[0, 9] := DEFAULT_CHARSET;
      end;
    end;
  finally
    Items.EndUpdate;
    ReleaseDC(0, DC);
  end;

  UpdateSelection;
end;

procedure TSCCustomFontCharsetListbox.SetAddDefaultCharset(Value: Boolean);
begin
  if FAddDefaultCharset <> Value then
  begin
    FAddDefaultCharset := Value;
    RefreshFont;
  end;
end;

procedure TSCCustomFontCharsetListbox.SetDefaultCharsetCaption(const Value: String);
begin
  if FDefaultCharsetCaption <> Value then
  begin
    FDefaultCharsetCaption := Value;
    if FAddDefaultCharset then
      RefreshFont;
  end;
end;

procedure TSCCustomFontCharsetListbox.SetFontCharSet(Value: TFontCharset);
begin
  if FFontCharSet <> Value then
  begin
    FFontCharSet := Value;
    UpdateSelection;
  end;
end;

procedure TSCCustomFontCharsetListbox.SetFontName(const Value: TFontName);
begin
  if FFontName <> Value then
  begin
    FFontName := Value;
    RefreshFont;
  end;
end;

procedure TSCCustomFontCharsetListbox.UpdateSelection;
var
  I, Index: Integer;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  Index := -1;
  for I := 0 to Items.Count-1 do
    if TSCFontStrings(Items).Data[I, 9] = FFontCharSet then
    begin
      Index := I;
      Break;
    end;

  ItemIndex := Index;
end;

procedure TSCCustomFontCharsetListbox.VerifyHorizontalPos(var P: Integer);
begin
  P := 0;
end;

{ TSCCustomFontCharsetCombobox }

procedure TSCCustomFontCharsetCombobox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomFontCharsetCombobox then
  begin
    with TSCCustomFontCharsetCombobox(Source) do
    begin
      Self.AddDefaultCharset := AddDefaultCharset;
      Self.DefaultCharsetCaption := DefaultCharsetCaption;
      Self.FontCharSet := FontCharSet;
      Self.FontName := FontName;
    end;
  end;
end;

constructor TSCCustomFontCharsetCombobox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  AutoComplete := True;
  DropDownCount := 2;
  IsDropDown := True;
end;

procedure TSCCustomFontCharsetCombobox.CreateWnd;
begin
  inherited CreateWnd;
  RefreshFont;
end;

procedure TSCCustomFontCharsetCombobox.DoInternalChange;
var
  Index, Ch: Integer;
begin
  Ch := FFontCharSet;

  if (ListBox <> nil) and DroppedDown then
  begin
    with TSCCustomDropDownListbox(ListBox) do
    begin
      Index := Items.IndexOf(Self.Text);
      if (Index > -1) and (Index < Items.Count) then
        Ch := TSCFontStrings(Items).Data[Index, 9];
    end;
  end else
  begin
    Index := Items.IndexOf(Self.Text);
    if (Index > -1) and (Index < Items.Count) then
      Ch := TSCFontStrings(Items).Data[Index, 9];
  end;

  FFontCharSet := Ch;
end;

procedure TSCCustomFontCharsetCombobox.DoListClick(Index: Integer; const Item: String);
var
  Ch: Integer;
begin
  Ch := FFontCharSet;
  if ListBox <> nil then
    with TSCCustomDropDownListbox(ListBox) do
      if (Index > -1) and (Index < Items.Count) then
        Ch := TSCFontStrings(Items).Data[Index, 9];

  FFontCharSet := Ch;
end;

function TSCCustomFontCharsetCombobox.GetDefaultCharsetCaption: String;
begin
  Result := '( Default )';
  if FDefaultCharsetCaption <> '' then
    Result := FDefaultCharsetCaption;
end;

function TSCCustomFontCharsetCombobox.GetEditColorsClass: TSCEditCustomColorsClass;
begin
  Result := TSCFontComboEditColors;
end;

function TSCCustomFontCharsetCombobox.GetFontCharsets(Index: Integer): TFontCharset;
begin
  Result := 0;
  if (Listbox <> nil) and DroppedDown then
  begin
    with TSCCustomDropDownListbox(ListBox) do
      if (Index > -1) and (Index < Items.Count) then
        Result :=  TFontCharset(TSCFontStrings(Items).Data[Index, 9]);
  end else
  if (Index > -1) and (Index < Items.Count) then
    Result :=  TFontCharset(TSCFontStrings(Items).Data[Index, 9]);
end;

procedure TSCCustomFontCharsetCombobox.Loaded;
begin
  inherited Loaded;
  RefreshFont;
end;

procedure TSCCustomFontCharsetCombobox.PrepareDropWindow;
var
  I, Index: Integer;
begin
  if ListBox <> nil then
    with TSCCustomDropDownListbox(ListBox) do
      Items.BeginUpdate;

  try
    RefreshFont;
    inherited PrepareDropWindow;

    if ListBox <> nil then
      with TSCCustomDropDownListbox(ListBox) do
      begin
        Office12Style := False;
        if Self.Style = scesOffice12 then
          Office12Style := True;

        Index := -1;
        for I := 0 to Items.Count-1 do
          if TSCFontStrings(Items).Data[I, 9] = FFontCharSet then
          begin
            Index := I;
            Break;
          end;

        ItemIndex := Index;
        TopIndex  := ItemIndex;

        if ItemIndex > -1 then
          MakeVisible(ItemIndex);
      end;
  finally
    if ListBox <> nil then
      TSCCustomDropDownListbox(ListBox).Items.EndUpdate;
  end;
end;

procedure TSCCustomFontCharsetCombobox.RefreshFont;
var
  DC: HDC;
  lf: TLogFont;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  DC := GetDC(0);
  Items.BeginUpdate;
  try
    Items.Clear;
    
    if FontName <> '' then
    begin
      FillChar(lf, SizeOf(lf), 0);

      lf.lfCharset := DEFAULT_CHARSET;
      Move(PChar(FontName)^, lf.lfFaceName, Length(FontName));

      EnumFontFamiliesEx(DC, lf, @EnumFontCharsets, Longint(Items), 0);

      if AddDefaultCharset then
      begin
        Items.Insert(0, GetDefaultCharsetCaption);
        TSCFontStrings(Items).Data[0, 9] := DEFAULT_CHARSET;
      end;
    end;
  finally
    Items.EndUpdate;
    ReleaseDC(0, DC);
  end;

  UpdateCharsetSelection;
end;

procedure TSCCustomFontCharsetCombobox.SetAddDefaultCharset(Value: Boolean);
begin
  if FAddDefaultCharset <> Value then
  begin
    FAddDefaultCharset := Value;
    RefreshFont;
  end;
end;

procedure TSCCustomFontCharsetCombobox.SetDefaultCharsetCaption(const Value: String);
begin
  if FDefaultCharsetCaption <> Value then
  begin
    FDefaultCharsetCaption := Value;
    if FAddDefaultCharset then
      RefreshFont;
  end;
end;

procedure TSCCustomFontCharsetCombobox.SetFontCharSet(Value: TFontCharset);
begin
  if FFontCharSet <> Value then
  begin
    FFontCharSet := Value;
    UpdateCharsetSelection;
  end;
end;

procedure TSCCustomFontCharsetCombobox.SetFontName(const Value: TFontName);
begin
  if FFontName <> Value then
  begin
    FFontName := Value;
    if DroppedDown then
      CloseUp;

    RefreshFont;
  end;
end;

procedure TSCCustomFontCharsetCombobox.UpdateCharsetSelection;
var
  I, Index: Integer;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  if (ListBox <> nil) and DroppedDown then
  begin
    with TSCCustomDropDownListbox(ListBox) do
    begin
      Index := 0;
      for I := 0 to Items.Count-1 do
        if TSCFontStrings(Items).Data[I, 9] = FFontCharSet then
        begin
          Index := I;
          Break;
        end;

      ItemIndex := Index;
      TopIndex  := ItemIndex;

      if ItemIndex > -1 then
      begin
        MakeVisible(ItemIndex);

        FFontCharSet := TSCFontStrings(Items).Data[I, 9];
        SetText(Items.Strings[ItemIndex]);
      end else
      begin
        FFontCharSet := 0;
        SetText('');
      end;
    end;
  end else
  begin
    Index := 0;
    with TSCFontStrings(Items) do
      for I := 0 to Items.Count-1 do
        if Data[I, 9] = FFontCharSet then
        begin
          Index := I;
          Break;
        end;

    if (Index > -1) and (Index < Items.Count) then
    begin
      FFontCharSet := TSCFontStrings(Items).Data[Index, 9];
      SetText(Items.Strings[Index]);
    end else
    begin
      FFontCharSet := 0;
      SetText('');
    end;
  end;
end;

{ TSCCustomBrushStyleListbox }

procedure TSCCustomBrushStyleListbox.AfterConstruction;
begin
  inherited AfterConstruction;
  RefreshStyles;
end;

procedure TSCCustomBrushStyleListbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomBrushStyleListbox then
  begin
    with TSCCustomBrushStyleListbox(Source) do
    begin
      Self.BrushColor := BrushColor;
      Self.StyleWidth := StyleWidth;
      Self.DisplayType := DisplayType;
      Self.SelectedStyle := SelectedStyle;
    end;
  end;
end;

procedure TSCCustomBrushStyleListbox.BeforePaintItem(C: TCanvas;
  Index: Integer; ClientR, R: TRect; State: TSCSimpleListState);
var
  Ind: Integer;
  Bs: TBrushStyle;
begin
  if (FDisplayType = scbdBrushesAndNames) and (C = nil) or (Index < 0) and
    (Index > Items.Count-1) or IsRectEmpty(ClientR) then
    Exit;

  Ind := Indent*TSCBrushStrings(Items).Data[Index, 6];
  
  if Ind > 0 then
  begin
    R.Right := R.Left;
    Dec(R.Left, Ind);

    InflateRect(R, -2, -2);
    try
      if IsRectEmpty(R) or (IntersectClipRect(C.Handle,
        R.Left, R.Top, R.Right, R.Bottom) = NULLREGION) then
        Exit;

      Bs := TBrushStyle(TSCBrushStrings(Items).Data[Index, 9]);
      
      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := clWindowFrame;

        Brush.Color := FBrushColor;
        Brush.Style := Bs;

        Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      end;
    finally
      SelectClipRgn(C.Handle, 0);
    end;
  end;
end;

function TSCCustomBrushStyleListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

constructor TSCCustomBrushStyleListbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  SetBounds(Left, Top, 135, 125);

  AllowEdit := False;
  EndEllipsis := False;
  Indent := 24;
  ScrollbarHorizontal := True;

  FBrushColor := clWindowText;
  FStyleWidth := 24;
  FDisplayType := scbdBrushesAndNames;
  FSelectedStyle := bsSolid;
end;

procedure TSCCustomBrushStyleListbox.DoDrawItem(C: TCanvas; Index: Integer;
  CR, R: TRect; State: TSCSimpleListState);
var
  Cl: TColor;
begin
  if (C = nil) or IsRectEmpty(R) or IsRectEmpty(CR) or
    (Index < 0) or (Index > Count-1) then
    Exit;

  if FDisplayType <> scbdBrushes then
    inherited DoDrawItem(C, Index, CR, R, State)
  else begin
    Cl := clNone;
    if sclsDisabled in State then
      Cl := DisabledColor
    else
    if sclsSelected in State then
    begin
      Cl  := HighlightColor;
      if not Focused then
        Cl  := HideSelectionColor;
    end;

    with C do
    begin
      Brush.Style := bsSolid;
      if Cl <> clNone then
      begin
        Brush.Color := Cl;
        FillRect(R);
      end;

      InflateRect(R, -2, -2);
      if not IsRectEmpty(R) then
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := clWindowFrame;

        Brush.Color := FBrushColor;
        Brush.Style := TBrushStyle(TSCBrushStrings(Items).Data[Index, 9]);

        Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      end;
      
      InflateRect(R, 2, 2);  
    end;

    if not IsDesigning and not HideFocusRect and
      (sclsFocused in State) and Focused then
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      scDrawFocusRect(C, R, Cl);
    end;
  end;
end;

procedure TSCCustomBrushStyleListbox.DoItemClick(Index: Integer);
var
  Bs: TBrushStyle;
begin
  if (Index > -1) and (Index < Items.Count) then
  begin
    Bs := TBrushStyle(TSCBrushStrings(Items).Data[Index, 9]);

    if Bs <> FSelectedStyle then
    begin
      FSelectedStyle := Bs;
      if Assigned(FOnSetStyle) then
        FOnSetStyle(Self);
    end;
  end;
end;

procedure TSCCustomBrushStyleListbox.IndentChanged;
begin
  if FDisplayType = scbdBrushesAndNames then
    inherited IndentChanged;
end;

procedure TSCCustomBrushStyleListbox.Loaded;
begin
  inherited Loaded;

  RefreshStyles;
  if Assigned(FOnSetStyle) then
    FOnSetStyle(Self);
end;

procedure TSCCustomBrushStyleListbox.RefreshStyles;
var
  L: TList;
  S: String;
  I, Bs: Integer;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  with TSCBrushStrings(Items) do
  begin
    L := TList.Create;
    try
      BeginUpdate;
      try
        Clear;
      
        for I := Low(scBrushStyleMap) to High(scBrushStyleMap) do
        begin
          Bs := scBrushStyleMap[I].Value;

          L.Add(Pointer(Bs));
          S := scBrushStyleMap[I].Name;

          if Assigned(FOnGetCaption) then
            FOnGetCaption(Self, Bs, S);

          Add(S);
          Data[Count-1, 9] := Bs;
          Data[Count-1, 6] := 1;
        end;

        for I := 0 to Count-1 do
          if Data[Count-1, 9] = Integer(FSelectedStyle) then
          begin
            ItemIndex := I;
            Break;
          end;
      finally
        EndUpdate;
      end;
    finally
      L.Free;
    end;
  end;
end;

procedure TSCCustomBrushStyleListbox.SetBrushColor(Value: TColor);
begin
  if FBrushColor <> Value then
  begin
    FBrushColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomBrushStyleListbox.SetDisplayType(
  Value: TSCBrushStyleDisplayType);
var
  Ind: Integer;
begin
  if FDisplayType <> Value then
  begin
    FDisplayType := Value;

    Ind := 0;
    if FDisplayType = scbdBrushesAndNames then
      Ind := FStyleWidth;

    Indent := Ind;
    if not InItemUpdate then
      Invalidate;
  end;
end;

procedure TSCCustomBrushStyleListbox.SetSelectedStyle(Value: TBrushStyle);
var
  I, Index: Integer;
begin
  if FSelectedStyle <> Value then
  begin
    FSelectedStyle := Value;

    if not InItemUpdate then
    begin
      Index := -1;

      with TSCBrushStrings(Items) do
        for I := 0 to Count-1 do
          if Data[I, 9] = Integer(FSelectedStyle) then
          begin
            Index := I;
            Break;
          end;

      ItemIndex := Index;
      if ItemIndex > -1 then
        MakeVisible(ItemIndex);
    end;

    if Assigned(FOnSetStyle) then
      FOnSetStyle(Self);
  end;
end;

procedure TSCCustomBrushStyleListbox.SetStyleWidth(Value: Integer);
begin
  if FStyleWidth <> Value then
  begin
    FStyleWidth := Value;
    Indent := Value;
  end;
end;

procedure TSCCustomBrushStyleListbox.SystemColorsChanged;
begin
  RefreshStyles;
  inherited SystemColorsChanged;
end;

procedure TSCCustomBrushStyleListbox.VerifyHorizontalPos(var P: Integer);
begin
  // P := 0;
  inherited VerifyHorizontalPos(P);
end;

{ TSCCustomPenStyleListbox }

procedure TSCCustomPenStyleListbox.AfterConstruction;
begin
  inherited AfterConstruction;
  RefreshStyles;
end;

procedure TSCCustomPenStyleListbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomPenStyleListbox then
  begin
    with TSCCustomPenStyleListbox(Source) do
    begin
      Self.PenColor := PenColor;
      Self.StyleWidth := StyleWidth;
      Self.DisplayType := DisplayType;
      Self.SelectedStyle := SelectedStyle;
    end;
  end;
end;

procedure TSCCustomPenStyleListbox.BeforePaintItem(C: TCanvas;
  Index: Integer; ClientR, R: TRect; State: TSCSimpleListState);
var
  Ps: TPenStyle;
  Cl, TxCl: TColor;
  Ind, T, I: Integer;
begin
  if (FDisplayType = scpdPensAndNames) and (C = nil) or (Index < 0) and
    (Index > Items.Count-1) or IsRectEmpty(ClientR) then
    Exit;

  Ind := Indent*TSCPenStrings(Items).Data[Index, 6];

  if Ind > 0 then
  begin
    R.Right := R.Left;
    Dec(R.Left, Ind);

    try
      if IsRectEmpty(R) or (IntersectClipRect(C.Handle,
        R.Left, R.Top, R.Right, R.Bottom) = NULLREGION) then
        Exit;

      Cl := clNone;
      TxCl := clNone;

      if sclsDisabled in State then
      begin
        Cl := DisabledColor;
        TxCl := DisabledTextColor;
      end else
      if sclsSelected in State then
      begin
        Cl := HighlightColor;
        TxCl := HighlightTextColor;

        if not Focused then
        begin
          Cl := HideSelectionColor;
          TxCl := HideSelectionTextColor;
        end;
      end;

      if Cl = clNone then Cl := clWindow;
      if TxCl = clNone then TxCl := FPenColor;

      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R);
      end;

      InflateRect(R, -2, 0);

      if not IsRectEmpty(R) then
      begin
        Ps := TPenStyle(TSCPenStrings(Items).Data[Index, 9]);

        with C do
        begin
          Pen.Style := Ps;
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := TxCl;

          T := R.Top + ((R.Bottom - R.Top) div 2) - 1;

          for I := 0 to 1 do
          begin
            MoveTo(R.Left, T + I);
            LineTo(R.Right, T + I);
          end;
        end;
      end;
    finally
      SelectClipRgn(C.Handle, 0);
    end;
  end;
end;

function TSCCustomPenStyleListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

constructor TSCCustomPenStyleListbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  SetBounds(Left, Top, 135, 125);

  AllowEdit := False;
  EndEllipsis := False;
  Indent := 50;
  ScrollbarHorizontal := True;

  FPenColor := clWindowText;
  FStyleWidth := 50;
  FDisplayType := scpdPensAndNames;
  FSelectedStyle := psSolid;
end;

procedure TSCCustomPenStyleListbox.DoDrawItem(C: TCanvas; Index: Integer;
  CR, R: TRect; State: TSCSimpleListState);
var
  T, I: Integer; 
  Cl, TxCl: TColor;
begin
  if (C = nil) or IsRectEmpty(R) or IsRectEmpty(CR) or
    (Index < 0) or (Index > Count-1) then
    Exit;

  if FDisplayType <> scpdPens then
    inherited DoDrawItem(C, Index, CR, R, State)
  else begin
    Cl := clNone;
    TxCl := clNone;

    if sclsDisabled in State then
    begin
      Cl := DisabledColor;
      TxCl := DisabledTextColor;
    end else
    if sclsSelected in State then
    begin
      Cl := HighlightColor;
      TxCl := HighlightTextColor;

      if not Focused then
      begin
        Cl := HideSelectionColor;
        TxCl := HideSelectionTextColor;
      end;
    end;

    if Cl = clNone then Cl := clWindow;
    if TxCl = clNone then TxCl := FPenColor;

    with C do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      InflateRect(R, 0, 2);
      FillRect(R);

      InflateRect(R, -4, -2);

      if not IsRectEmpty(R) then
      begin
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := TxCl;
        Pen.Style := TPenStyle(TSCPenStrings(Items).Data[Index, 9]);

        T := R.Top + ((R.Bottom - R.Top) div 2) - 1;

        for I := 0 to 1 do
        begin
          MoveTo(R.Left, T + I);
          LineTo(R.Right, T + I);
        end;
      end;

      Pen.Width := 1;
      InflateRect(R, 4, 0);
    end;

    if not IsDesigning and
      not HideFocusRect and (sclsFocused in State) and Focused then
    begin
      C.Brush.Style := bsSolid;
      C.Brush.Color := Cl;

      scDrawFocusRect(C, R, Cl);
    end;
  end;
end;

procedure TSCCustomPenStyleListbox.DoItemClick(Index: Integer);
var
  Ps: TPenStyle;
begin
  if (Index > -1) and (Index < Items.Count) then
  begin
    Ps := TPenStyle(TSCPenStrings(Items).Data[Index, 9]);

    if Ps <> FSelectedStyle then
    begin
      FSelectedStyle := Ps;
      if Assigned(FOnSetStyle) then
        FOnSetStyle(Self);
    end;
  end;
end;

procedure TSCCustomPenStyleListbox.IndentChanged;
begin
  if FDisplayType = scpdPensAndNames then
    inherited IndentChanged;
end;

procedure TSCCustomPenStyleListbox.Loaded;
begin
  inherited Loaded;

  RefreshStyles;
  if Assigned(FOnSetStyle) then
    FOnSetStyle(Self);
end;

procedure TSCCustomPenStyleListbox.RefreshStyles;
var
  L: TList;
  S: String;
  I, Bs: Integer;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  with TSCPenStrings(Items) do
  begin
    L := TList.Create;
    try
      BeginUpdate;
      try
        Clear;
      
        for I := Low(scPenStyleMap) to High(scPenStyleMap) do
        begin
          Bs := scPenStyleMap[I].Value;

          L.Add(Pointer(Bs));
          S := scPenStyleMap[I].Name;

          if Assigned(FOnGetCaption) then
            FOnGetCaption(Self, Bs, S);

          Add(S);
          Data[Count-1, 9] := Bs;
          Data[Count-1, 6] := 1;
        end;

        for I := 0 to Count-1 do
          if Data[Count-1, 9] = Integer(FSelectedStyle) then
          begin
            ItemIndex := I;
            Break;
          end;
      finally
        EndUpdate;
      end;
    finally
      L.Free;
    end;
  end;
end;

procedure TSCCustomPenStyleListbox.SetPenColor(Value: TColor);
begin
  if FPenColor <> Value then
  begin
    FPenColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomPenStyleListbox.SetDisplayType(Value: TSCPenDisplayType);
var
  Ind: Integer;
begin
  if FDisplayType <> Value then
  begin
    FDisplayType := Value;

    Ind := 0;
    if FDisplayType = scpdPensAndNames then
      Ind := FStyleWidth;

    Indent := Ind;
    if not InItemUpdate then
      Invalidate;
  end;
end;

procedure TSCCustomPenStyleListbox.SetSelectedStyle(Value: TPenStyle);
var
  I, Index: Integer;
begin
  if FSelectedStyle <> Value then
  begin
    FSelectedStyle := Value;

    if not InItemUpdate then
    begin
      Index := -1;

      with TSCPenStrings(Items) do
        for I := 0 to Count-1 do
          if Data[I, 9] = Integer(FSelectedStyle) then
          begin
            Index := I;
            Break;
          end;

      ItemIndex := Index;
      if ItemIndex > -1 then
        MakeVisible(ItemIndex);
    end;

    if Assigned(FOnSetStyle) then
      FOnSetStyle(Self);
  end;
end;

procedure TSCCustomPenStyleListbox.SetStyleWidth(Value: Integer);
begin
  if FStyleWidth <> Value then
  begin
    FStyleWidth := Value;
    Indent := Value;
  end;
end;

procedure TSCCustomPenStyleListbox.SystemColorsChanged;
begin
  RefreshStyles;
  inherited SystemColorsChanged;
end;

procedure TSCCustomPenStyleListbox.VerifyHorizontalPos(var P: Integer);
begin
  // P := 0;
  inherited VerifyHorizontalPos(P);
end;

{ TSCCustomPenStyleCombobox }

procedure TSCCustomPenStyleCombobox.AfterCloseUp;
begin
  if Listbox is TSCDropDownPenStyleListbox then
    TSCDropDownPenStyleListbox(Listbox).FDroppedDown := False;

  inherited AfterCloseUp;
end;

procedure TSCCustomPenStyleCombobox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomPenStyleCombobox then
  begin
    with TSCCustomPenStyleCombobox(Source) do
    begin
      Self.PenColor := PenColor;
      Self.StyleWidth := StyleWidth;
      Self.DisplayType := DisplayType;
      Self.SelectedStyle := SelectedStyle;
    end;
  end;
end;

constructor TSCCustomPenStyleCombobox.Create(AOwner: TComponent);
begin
  FStyleWidth := 50;
  FPenColor := clWindowText;
  FDisplayType := scpdPensAndNames;
  FSelectedStyle := psSolid;

  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  DropDownCount := 12;
  AutoComplete := True;
  ImmediateDropDown := True;
  IsDropDown := True;
end;

procedure TSCCustomPenStyleCombobox.CreateWnd;
begin
  inherited CreateWnd;
  RefreshStyles;
end;

procedure TSCCustomPenStyleCombobox.DoDrawBack(C: TCanvas);
var
  CR, R, R2: TRect;
  W, Bs, I, T: Integer;
begin
  inherited DoDrawBack(C);

  if (C <> nil) and (FDisplayType = scpdPensAndNames) then
  begin
    CR := GetClientRect;

    Bs := GetStyleBorderSize;
    InflateRect(CR, -Bs, -Bs);

    if not IsRectEmpty(CR) then
    begin
      R := Rect(0, 0, 0, 0);
      inherited UpdateBorderRect(R);

      R2 := R;
      if FStyleWidth > 0 then
        Inc(R2.Left, FStyleWidth + 4);

      with R2 do
      begin
        Top    := CR.Top;
        Bottom := CR.Bottom;
        Right  := Bs + Left;
        Left   := Bs + R.Left;
      end;

      InflateRect(R2, -2, -2);

      W := CheckboxWidth;
      OffsetRect(R2, W, 0);

      if not IsRectEmpty(R2) then
        with C do
        begin
          Pen.Mode  := pmCopy;
          Pen.Width := 1;
          Pen.Color := FPenColor;
          Pen.Style := FSelectedStyle;

          T := R2.Top + ((R2.Bottom - R2.Top) div 2) - 1;

          for I := 0 to 1 do
          begin
            MoveTo(R2.Left, T + I);
            LineTo(R2.Right, T + I);
          end;
        end;
    end;
  end;  
end;

procedure TSCCustomPenStyleCombobox.DoInternalChange;
var
  Index: Integer;
  Ps: TPenStyle;
begin
  Ps := FSelectedStyle;
  Index := TSCPenStrings(Items).IndexOf(Self.Text);
  if Index > -1 then Ps := TPenStyle(TSCPenStrings(Items).Data[Index, 9]);

  if Ps <> FSelectedStyle then
  begin
    FSelectedStyle := Ps;
    if Assigned(FOnSetStyle) then
      FOnSetStyle(Self);
  end;
end;

procedure TSCCustomPenStyleCombobox.DoListClick(Index: Integer; const Item: String);
begin
  if Index > -1 then
  begin
    if (ListBox <> nil) and DroppedDown then
    begin
      with TSCDropDownPenStyleListbox(ListBox), TSCPenStrings(Items) do
        if Index < Count then
        begin
          FSelectedStyle := TPenStyle(Data[Index, 9]);
          if Assigned(FOnSetStyle) then
            FOnSetStyle(Self);
        end;
    end else
    if Index < Items.Count then
      with TSCPenStrings(Items) do
      begin
        FSelectedStyle := TPenStyle(Data[Index, 9]);
        if Assigned(FOnSetStyle) then
          FOnSetStyle(Self);
      end;
  end;
end;

function TSCCustomPenStyleCombobox.GetEditColorsClass: TSCEditCustomColorsClass;
begin
  Result := TSCModeStyleComboEditColors;
end;

function TSCCustomPenStyleCombobox.GetIsDropDown: Boolean;
begin
  Result := inherited GetIsDropDown or (FDisplayType = scpdPens);
end;

function TSCCustomPenStyleCombobox.GetListboxClass: TSCSimpleListboxClass;
begin
  Result := TSCDropDownPenStyleListbox;
end;

procedure TSCCustomPenStyleCombobox.Loaded;
begin
  inherited Loaded;
  StyleChanged;
  UpdatePenText;
end;

procedure TSCCustomPenStyleCombobox.PaintLine(C: TCanvas; Index, H,
  TxTop: Integer);
var
  CR, R, R1: TRect;
  Bs, I, T: Integer;
  IsFocused: Boolean;
begin
  if FDisplayType <> scpdPens then
    inherited PaintLine(C, Index, H, TxTop)
  else begin
    if (C = nil) or (H = 0) then
      Exit;

    CR := GetClientRect;
    if IsRectEmpty(CR) then
      Exit;

    R := Rect(0, 0, 0, 0);
    UpdateBorderRect(R);

    R1 := CR;

    Inc(R1.Left,   R.Left);
    Dec(R1.Right,  R.Right);
    Inc(R1.Top,    R.Top);
    Dec(R1.Bottom, R.Bottom);

    if IsRectEmpty(R1) then Exit;

    Bs := GetStyleBorderSize;
    InflateRect(R1, -Bs, -Bs);

    Inc(R1.Left);
    
    if not IsRectEmpty(R1) then
    begin
      IsFocused := not Self.IsDesigning and
        Focused and not GetDroppedDown;

      with C do
      begin
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := FPenColor;
        Pen.Style := FSelectedStyle;

        T := R1.Top + ((R1.Bottom - R1.Top) div 2) - 1;

        for I := 0 to 1 do
        begin
          MoveTo(R1.Left, T + I);
          LineTo(R1.Right, T + I);
        end;
      end;

      if IsFocused then
        scDrawFocusRect(C, R1, Self.Color);
    end;
  end;
end;

procedure TSCCustomPenStyleCombobox.PrepareDropWindow;
var
  Ind: Integer;
begin
  if ListBox <> nil then
    with TSCDropDownPenStyleListbox(ListBox) do
      Items.BeginUpdate;

  try
    RefreshStyles;
    inherited PrepareDropWindow;

    if ListBox <> nil then
      with TSCDropDownPenStyleListbox(ListBox) do
      begin
        PenColor      := Self.PenColor;
        StyleWidth    := Self.StyleWidth;
        DisplayType   := Self.DisplayType;
        SelectedStyle := Self.SelectedStyle;

        Office12Style := False;
        if Self.Style = scesOffice12 then
          Office12Style := True;

        ItemIndex := Items.IndexOf(Self.Text);
        TopIndex  := ItemIndex;

        Ind := 0;
        if FDisplayType = scpdPensAndNames then
          Ind := Self.StyleWidth;

        Indent := Ind;

        if ItemIndex > -1 then
          MakeVisible(ItemIndex);
      end;
    finally
      if ListBox <> nil then
        TSCDropDownPenStyleListbox(ListBox).Items.EndUpdate;
    end;
end;

procedure TSCCustomPenStyleCombobox.RefreshStyles;
var
  L: TList;
  S: String;
  I, Bs, Cnt: Integer;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  with TSCPenStrings(Items) do
  begin
    L := TList.Create;
    try
      BeginUpdate;
      try
        Clear;
      
        for I := Low(scPenStyleMap) to High(scPenStyleMap) do
        begin
          Bs := scPenStyleMap[I].Value;

          L.Add(Pointer(Bs));
          S := scPenStyleMap[I].Name;

          if Assigned(FOnGetCaption) then
            FOnGetCaption(Self, Bs, S);

          Cnt := Add(S);
          Data[Cnt, 9] := Bs;
          Data[Cnt, 6] := 1;
        end;

        for I := 0 to Count-1 do
          if Data[Count-1, 9] = Integer(FSelectedStyle) then
          begin
            ItemIndex := I;
            Break;
          end;
      finally
        EndUpdate;
      end;
    finally
      L.Free;
    end;
  end;

  UpdatePenText;
end;

procedure TSCCustomPenStyleCombobox.SetPenColor(Value: TColor);
begin
  if FPenColor <> Value then
  begin
    FPenColor := Value;
    if FDisplayType <> scpdNames then
      StyleChanged;
  end;
end;

procedure TSCCustomPenStyleCombobox.SetStyleWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FStyleWidth <> Value then
  begin
    FStyleWidth := Value;
    if FDisplayType = scpdPensAndNames then
      StyleChanged;
  end;
end;

procedure TSCCustomPenStyleCombobox.SetDisplayType(Value: TSCPenDisplayType);
begin
  if FDisplayType <> Value then
  begin
    FDisplayType := Value;

    CanSelect := not (IsDropDown or (FDisplayType = scpdNames));
    UseCaret  := not (IsDropDown or (FDisplayType = scpdNames));
    UseUndo   := not (IsDropDown or (FDisplayType = scpdNames));

    if not InItemUpdate and not (IsLoading or IsReading) then
      StyleChanged;
  end;
end;

procedure TSCCustomPenStyleCombobox.SetSelectedStyle(Value: TPenStyle);
begin
  if FSelectedStyle <> Value then
  begin
    FSelectedStyle := Value;

    UpdatePenText;
    Invalidate;

    if Assigned(FOnSetStyle) then
      FOnSetStyle(Self);
  end;
end;

procedure TSCCustomPenStyleCombobox.UpdateBorderRect(var R: TRect);
begin
  inherited UpdateBorderRect(R);

  if FDisplayType = scpdNames then
  begin
    R.Top := 2;
    R.Bottom := 2;
  end else
  if (FDisplayType = scpdPensAndNames) and (FStyleWidth > 0) then
    Inc(R.Left, FStyleWidth + 4);
end;

procedure TSCCustomPenStyleCombobox.UpdatePenText;
var
  S: String;
  I, Ps: LongInt;
begin
  Ps := Integer(FSelectedStyle);

  with TSCPenStrings(Items) do
    for I := 0 to Count-1 do
      if Ps = Data[I, 9] then
      begin
        Self.SetText(Strings[I]);
        Exit;
      end;

  S := '';
  for I := Low(scPenStyleMap) to High(scPenStyleMap) do
    if Ps = scPenStyleMap[I].Value then
    begin
      S := scPenStyleMap[I].Name;
      Break;
    end;

  if Assigned(FOnGetCaption) then
    FOnGetCaption(Self, Ps, S);

  SetText(S);
end;

{ TSCCustomPenModeListbox }

procedure TSCCustomPenModeListbox.AfterConstruction;
begin
  inherited AfterConstruction;
  RefreshModes;
end;

procedure TSCCustomPenModeListbox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomPenModeListbox then
  begin
    with TSCCustomPenModeListbox(Source) do
    begin
      Self.BackColor := BackColor;
      Self.PenColor := PenColor;
      Self.ModeWidth := ModeWidth;
      Self.DisplayType := DisplayType;
      Self.SelectedMode := SelectedMode;
    end;
  end;
end;

procedure TSCCustomPenModeListbox.BeforePaintItem(C: TCanvas;
  Index: Integer; ClientR, R: TRect; State: TSCSimpleListState);
var
  Pm: TPenMode;
  Cl, LnCl: TColor;
  Ind, T, I: Integer;
begin
  if (FDisplayType = scpdPensAndNames) and (C = nil) or (Index < 0) and
    (Index > Items.Count-1) or IsRectEmpty(ClientR) then
    Exit;

  Ind := Indent*TSCPenStrings(Items).Data[Index, 6];
  
  if Ind > 0 then
  begin
    R.Right := R.Left;
    Dec(R.Left, Ind);

    InflateRect(R, -1, -1);
    try
      if IsRectEmpty(R) or (IntersectClipRect(C.Handle,
        R.Left, R.Top, R.Right, R.Bottom) = NULLREGION) then
        Exit;

      Cl := FBackColor;
      LnCl := FPenColor;

      if Cl = clNone then Cl := clWindow;
      if LnCl = clNone then LnCl := clWindowText;

      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R);
      end;

      InflateRect(R, -2, 0);

      if not IsRectEmpty(R) then
      begin
        Pm := TPenMode(TSCPenStrings(Items).Data[Index, 9]);

        with C do
        begin
          Pen.Style := psSolid;
          Pen.Mode  := Pm;
          Pen.Width := 1;
          Pen.Color := LnCl;

          T := R.Top + ((R.Bottom - R.Top) div 2) - 1;

          for I := 0 to 2 do
          begin
            MoveTo(R.Left, T + I);
            LineTo(R.Right, T + I);
          end;
        end;
      end;
    finally
      SelectClipRgn(C.Handle, 0);
    end;
  end;
end;

function TSCCustomPenModeListbox.CanShowEditor: Boolean;
begin
  Result := False;
end;

constructor TSCCustomPenModeListbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  SetBounds(Left, Top, 135, 125);

  AllowEdit := False;
  EndEllipsis := False;
  Indent := 24;
  ScrollbarHorizontal := True;

  FBackColor := clGreen;
  FPenColor := clRed;
  FModeWidth := 24;
  FDisplayType := scpdPensAndNames;
  FSelectedMode := pmCopy;
end;

procedure TSCCustomPenModeListbox.DoDrawItem(C: TCanvas; Index: Integer;
  CR, R: TRect; State: TSCSimpleListState);
var
  T, I: Integer; 
  Cl, LnCl: TColor;
begin
  if (C = nil) or IsRectEmpty(R) or IsRectEmpty(CR) or
    (Index < 0) or (Index > Count-1) then
    Exit;

  if FDisplayType <> scpdPens then
    inherited DoDrawItem(C, Index, CR, R, State)
  else begin
    Cl := FBackColor;
    LnCl := FPenColor;

    if Cl = clNone then Cl := clWindow;
    if LnCl = clNone then LnCl := clWindowText;

    with C do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      InflateRect(R, -2, -1);
      FillRect(R);

      InflateRect(R, -2, 0);

      if not IsRectEmpty(R) then
      begin
        Pen.Mode  := TPenMode(TSCPenStrings(Items).Data[Index, 9]);
        Pen.Width := 1;
        Pen.Color := LnCl;
        Pen.Style := psSolid;

        T := R.Top + ((R.Bottom - R.Top) div 2) - 1;

        for I := 0 to 2 do
        begin
          MoveTo(R.Left, T + I);
          LineTo(R.Right, T + I);
        end;
      end;

      Pen.Width := 1;
      InflateRect(R, 2, 0);
    end;

    if not IsDesigning and not HideFocusRect and
      (sclsFocused in State) and Focused then
    begin
      C.Brush.Style := bsSolid;
      C.Brush.Color := Cl;

      scDrawFocusRect(C, R, Cl);
    end;
  end;
end;

procedure TSCCustomPenModeListbox.DoItemClick(Index: Integer);
var
  Pm: TPenMode;
begin
  if (Index > -1) and (Index < Items.Count) then
  begin
    Pm := TPenMode(TSCPenStrings(Items).Data[Index, 9]);

    if Pm <> FSelectedMode then
    begin
      FSelectedMode := Pm;
      if Assigned(FOnSetMode) then
        FOnSetMode(Self);
    end;
  end;
end;

procedure TSCCustomPenModeListbox.IndentChanged;
begin
  if FDisplayType = scpdPensAndNames then
    inherited IndentChanged;
end;

procedure TSCCustomPenModeListbox.Loaded;
begin
  inherited Loaded;

  RefreshModes;
  if Assigned(FOnSetMode) then
    FOnSetMode(Self);
end;

procedure TSCCustomPenModeListbox.RefreshModes;
var
  L: TList;
  S: String;
  I, Bs: Integer;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  with TSCPenStrings(Items) do
  begin
    L := TList.Create;
    try
      BeginUpdate;
      try
        Clear;
      
        for I := Low(scPenModeMap) to High(scPenModeMap) do
        begin
          Bs := scPenModeMap[I].Value;

          L.Add(Pointer(Bs));
          S := scPenModeMap[I].Name;

          if Assigned(FOnGetCaption) then
            FOnGetCaption(Self, Bs, S);

          Add(S);
          Data[Count-1, 9] := Bs;
          Data[Count-1, 6] := 1;
        end;

        for I := 0 to Count-1 do
          if Data[Count-1, 9] = Integer(FSelectedMode) then
          begin
            ItemIndex := I;
            Break;
          end;
      finally
        EndUpdate;
      end;
    finally
      L.Free;
    end;
  end;
end;

procedure TSCCustomPenModeListbox.SetPenColor(Value: TColor);
begin
  if FPenColor <> Value then
  begin
    FPenColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomPenModeListbox.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomPenModeListbox.SetDisplayType(Value: TSCPenDisplayType);
var
  Ind: Integer;
begin
  if FDisplayType <> Value then
  begin
    FDisplayType := Value;

    Ind := 0;
    if FDisplayType = scpdPensAndNames then
      Ind := FModeWidth;

    Indent := Ind;
    if not InItemUpdate then
      Invalidate;
  end;
end;

procedure TSCCustomPenModeListbox.SetModeWidth(Value: Integer);
begin
  if FModeWidth <> Value then
  begin
    FModeWidth := Value;
    Indent := Value;
  end;
end;

procedure TSCCustomPenModeListbox.SetSelectedMode(Value: TPenMode);
var
  I, Index: Integer;
begin
  if FSelectedMode <> Value then
  begin
    FSelectedMode := Value;

    if not InItemUpdate then
    begin
      Index := -1;

      with TSCPenStrings(Items) do
        for I := 0 to Count-1 do
          if Data[I, 9] = Integer(FSelectedMode) then
          begin
            Index := I;
            Break;
          end;

      ItemIndex := Index;
      if ItemIndex > -1 then
        MakeVisible(ItemIndex);
    end;

    if Assigned(FOnSetMode) then
      FOnSetMode(Self);
  end;
end;

procedure TSCCustomPenModeListbox.SystemColorsChanged;
begin
  RefreshModes;
  inherited SystemColorsChanged;
end;

procedure TSCCustomPenModeListbox.VerifyHorizontalPos(var P: Integer);
begin
  // P := 0;
  inherited VerifyHorizontalPos(P);
end;

{ TSCCustomPenModeCombobox }

procedure TSCCustomPenModeCombobox.AfterCloseUp;
begin
  if Listbox is TSCDropDownPenModeListbox then
    TSCDropDownPenModeListbox(Listbox).FDroppedDown := False;

  inherited AfterCloseUp;
end;

procedure TSCCustomPenModeCombobox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomPenModeCombobox then
  begin
    with TSCCustomPenModeCombobox(Source) do
    begin
      Self.BackColor := BackColor;
      Self.PenColor := PenColor;
      Self.ModeWidth := ModeWidth;
      Self.DisplayType := DisplayType;
      Self.SelectedMode := SelectedMode;
    end;
  end;
end;

constructor TSCCustomPenModeCombobox.Create(AOwner: TComponent);
begin
  FModeWidth := 24;
  FBackColor := clGreen;
  FPenColor := clRed;
  FDisplayType := scpdPensAndNames;
  FSelectedMode := pmCopy;

  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  DropDownCount := 12;
  AutoComplete := True;
  ImmediateDropDown := True;
  IsDropDown := True;
end;

procedure TSCCustomPenModeCombobox.CreateWnd;
begin
  inherited CreateWnd;
  RefreshModes;
end;

procedure TSCCustomPenModeCombobox.DoDrawBack(C: TCanvas);
var
  CR, R, R2: TRect;
  W, Bs, I, T: Integer;
begin
  inherited DoDrawBack(C);

  if (C <> nil) and (FDisplayType = scpdPensAndNames) then
  begin
    CR := GetClientRect;

    Bs := GetStyleBorderSize;
    InflateRect(CR, -Bs, -Bs);

    if not IsRectEmpty(CR) then
    begin
      R := Rect(0, 0, 0, 0);
      inherited UpdateBorderRect(R);

      R2 := R;
      if FModeWidth > 0 then
        Inc(R2.Left, FModeWidth + 4);

      with R2 do
      begin
        Top    := CR.Top;
        Bottom := CR.Bottom;
        Right  := Bs + Left;
        Left   := Bs + R.Left;
      end;

      InflateRect(R2, -1, -1);

      if not IsRectEmpty(R2) and (FBackColor <> clNone) then
        with C do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FBackColor;

          FillRect(R2);
        end;

      InflateRect(R2, -2, 0);

      W := CheckboxWidth;
      OffsetRect(R2, W, 0);

      if not IsRectEmpty(R2) then
        with C do
        begin
          Pen.Mode  := FSelectedMode;
          Pen.Width := 1;
          Pen.Color := FPenColor;
          Pen.Style := psSolid;

          T := R2.Top + ((R2.Bottom - R2.Top) div 2) - 1;

          for I := 0 to 2 do
          begin
            MoveTo(R2.Left, T + I);
            LineTo(R2.Right, T + I);
          end;
        end;
    end;
  end;  
end;

procedure TSCCustomPenModeCombobox.DoInternalChange;
var
  Pm: TPenMode;
  Index: Integer;
begin
  Pm := FSelectedMode;
  Index := TSCPenStrings(Items).IndexOf(Self.Text);
  if Index > -1 then Pm := TPenMode(TSCPenStrings(Items).Data[Index, 9]);

  if Pm <> FSelectedMode then
  begin
    FSelectedMode := Pm;
    if Assigned(FOnSetMode) then
      FOnSetMode(Self);
  end;
end;

procedure TSCCustomPenModeCombobox.DoListClick(Index: Integer; const Item: String);
begin
  if Index > -1 then
  begin
    if (ListBox <> nil) and DroppedDown then
    begin
      with TSCDropDownPenModeListbox(ListBox), TSCPenStrings(Items) do
        if Index < Count then
        begin
          FSelectedMode := TPenMode(Data[Index, 9]);
          if Assigned(FOnSetMode) then
            FOnSetMode(Self);
        end;
    end else
    if Index < Items.Count then
      with TSCPenStrings(Items) do
      begin
        FSelectedMode := TPenMode(Data[Index, 9]);
        if Assigned(FOnSetMode) then
          FOnSetMode(Self);
      end;
  end;
end;

function TSCCustomPenModeCombobox.GetEditColorsClass: TSCEditCustomColorsClass;
begin
  Result := TSCModeStyleComboEditColors;
end;

function TSCCustomPenModeCombobox.GetIsDropDown: Boolean;
begin
  Result := inherited GetIsDropDown or (FDisplayType = scpdPens);
end;

function TSCCustomPenModeCombobox.GetListboxClass: TSCSimpleListboxClass;
begin
  Result := TSCDropDownPenModeListbox;
end;

procedure TSCCustomPenModeCombobox.Loaded;
begin
  inherited Loaded;
  StyleChanged;
  UpdatePenText;
end;

procedure TSCCustomPenModeCombobox.PaintLine(C: TCanvas; Index, H,
  TxTop: Integer);
var
  CR, R, R1: TRect;
  Bs, I, T: Integer;
  IsFocused: Boolean;
begin
  if FDisplayType <> scpdPens then
    inherited PaintLine(C, Index, H, TxTop)
  else begin
    if (C = nil) or (H = 0) then
      Exit;

    CR := GetClientRect;
    if IsRectEmpty(CR) then
      Exit;

    R := Rect(0, 0, 0, 0);
    UpdateBorderRect(R);

    R1 := CR;

    if not IsRectEmpty(R1) and (FBackColor <> clNone) then
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := FBackColor;

        FillRect(R1);
      end;

    Inc(R1.Left,   R.Left);
    Dec(R1.Right,  R.Right);
    Inc(R1.Top,    R.Top);
    Dec(R1.Bottom, R.Bottom);

    if IsRectEmpty(R1) then Exit;

    Bs := GetStyleBorderSize;
    InflateRect(R1, -Bs, -Bs);

    Inc(R1.Left);

    if not IsRectEmpty(R1) then
    begin
      IsFocused := not Self.IsDesigning and
        Focused and not GetDroppedDown;

      InflateRect(R1, -2, 0);
      with C do
      begin
        Pen.Width := 1;
        Pen.Color := FPenColor;
        Pen.Mode  := FSelectedMode;
        Pen.Style := psSolid;

        T := R1.Top + ((R1.Bottom - R1.Top) div 2) - 1;

        for I := 0 to 2 do
        begin
          MoveTo(R1.Left, T + I);
          LineTo(R1.Right, T + I);
        end;
      end;

      InflateRect(R1, 2, 0);
      if IsFocused then
        scDrawFocusRect(C, R1, Self.Color);
    end;
  end;
end;

procedure TSCCustomPenModeCombobox.PrepareDropWindow;
var
  Ind: Integer;
begin
  if ListBox <> nil then
    with TSCDropDownPenModeListbox(ListBox) do
      Items.BeginUpdate;

  try
    RefreshModes;
    inherited PrepareDropWindow;

    if ListBox <> nil then
      with TSCDropDownPenModeListbox(ListBox) do
      begin
        BackColor     := Self.BackColor;
        PenColor      := Self.PenColor;
        ModeWidth     := Self.ModeWidth;
        DisplayType   := Self.DisplayType;
        SelectedMode := Self.SelectedMode;

        Office12Style := False;
        if Self.Style = scesOffice12 then
          Office12Style := True;

        ItemIndex := Items.IndexOf(Self.Text);
        TopIndex  := ItemIndex;

        Ind := 0;
        if FDisplayType = scpdPensAndNames then
          Ind := Self.ModeWidth;

        Indent := Ind;

        if ItemIndex > -1 then
          MakeVisible(ItemIndex);
      end;
    finally
      if ListBox <> nil then
        TSCDropDownPenModeListbox(ListBox).Items.EndUpdate;
    end;
end;

procedure TSCCustomPenModeCombobox.RefreshModes;
var
  L: TList;
  S: String;
  I, Pm, Cnt: Integer;
begin
  if InItemUpdate or (IsLoading or IsReading) or
    (ControlState*[csCreating, csReadingState, csDestroyingHandle] <> []) then
    Exit;

  with TSCPenStrings(Items) do
  begin
    L := TList.Create;
    try
      BeginUpdate;
      try
        Clear;
      
        for I := Low(scPenModeMap) to High(scPenModeMap) do
        begin
          Pm := scPenModeMap[I].Value;

          L.Add(Pointer(Pm));
          S := scPenModeMap[I].Name;

          if Assigned(FOnGetCaption) then
            FOnGetCaption(Self, Pm, S);

          Cnt := Add(S);
          Data[Cnt, 9] := Pm;
          Data[Cnt, 6] := 1;
        end;

        for I := 0 to Count-1 do
          if Data[Count-1, 9] = Integer(FSelectedMode) then
          begin
            ItemIndex := I;
            Break;
          end;
      finally
        EndUpdate;
      end;
    finally
      L.Free;
    end;
  end;

  UpdatePenText;
end;

procedure TSCCustomPenModeCombobox.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    if FDisplayType <> scpdNames then
      StyleChanged;
  end;
end;

procedure TSCCustomPenModeCombobox.SetPenColor(Value: TColor);
begin
  if FPenColor <> Value then
  begin
    FPenColor := Value;
    if FDisplayType <> scpdNames then
      StyleChanged;
  end;
end;

procedure TSCCustomPenModeCombobox.SetModeWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FModeWidth <> Value then
  begin
    FModeWidth := Value;
    if FDisplayType = scpdPensAndNames then
      StyleChanged;
  end;
end;

procedure TSCCustomPenModeCombobox.SetDisplayType(Value: TSCPenDisplayType);
begin
  if FDisplayType <> Value then
  begin
    FDisplayType := Value;

    CanSelect := not (IsDropDown or (FDisplayType = scpdNames));
    UseCaret  := not (IsDropDown or (FDisplayType = scpdNames));
    UseUndo   := not (IsDropDown or (FDisplayType = scpdNames));

    if not InItemUpdate and not (IsLoading or IsReading) then
      StyleChanged;
  end;
end;

procedure TSCCustomPenModeCombobox.SetSelectedMode(Value: TPenMode);
begin
  if FSelectedMode <> Value then
  begin
    FSelectedMode := Value;

    UpdatePenText;
    Invalidate;

    if Assigned(FOnSetMode) then
      FOnSetMode(Self);
  end;
end;

procedure TSCCustomPenModeCombobox.UpdateBorderRect(var R: TRect);
begin
  inherited UpdateBorderRect(R);

  if FDisplayType = scpdNames then
  begin
    R.Top := 2;
    R.Bottom := 2;
  end else
  if (FDisplayType = scpdPensAndNames) and (FModeWidth > 0) then
    Inc(R.Left, FModeWidth + 4);
end;

procedure TSCCustomPenModeCombobox.UpdatePenText;
var
  S: String;
  I, Ps: LongInt;
begin
  Ps := Integer(FSelectedMode);

  with TSCPenStrings(Items) do
    for I := 0 to Count-1 do
      if Ps = Data[I, 9] then
      begin
        Self.SetText(Strings[I]);
        Exit;
      end;

  S := '';
  for I := Low(scPenModeMap) to High(scPenModeMap) do
    if Ps = scPenModeMap[I].Value then
    begin
      S := scPenModeMap[I].Name;
      Break;
    end;

  if Assigned(FOnGetCaption) then
    FOnGetCaption(Self, Ps, S);

  SetText(S);
end;

{$I SCVerRec.inc}

end.
