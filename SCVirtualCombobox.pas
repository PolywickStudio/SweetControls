{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCVirtualCombobox;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Clipbrd, SCConsts, SCCommon, SCControl, SCEdits, SCAdvEdits, SCVirtualListBox;

type
  TSCCustomVirtualCombobox = class;

  TSCVirtualComboboxScrollbar = class(TSCControlScrollbar)
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
    property Icons;
    property SlideLine;
    property Thumb;
    property Width: Integer read FWidth write SetWidth default -1;
    property Style: TSCScrollbarStyle read FStyle write FStyle default scssDefault;
    property ThumbLines: TSCScrollThumbline read FThumbLines write FThumbLines default sctlNone;
    property ButtonsLayout: TSCScrollButtonLayout read FButtonsLayout write FButtonsLayout default scsbDefault;
  end;

  TSCVirtualComboboxButtonProps = class(TSCCustomDropButtonProps)
  published
    property ArrowColor;
    property Color;
    property Visible;
  end;

  TSCVirtualComboboxCustomPopupProps = class(TPersistent)
  private
    FOwner: TSCCustomVirtualCombobox;
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
    function  GetScrollbar: TSCVirtualComboboxScrollbar;
    procedure SetScrollbar(Value: TSCVirtualComboboxScrollbar);
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
    property Scrollbar: TSCVirtualComboboxScrollbar read GetScrollbar write SetScrollbar;
    property ShowSizeGrip: Boolean read GetShowSizeGrip write SetShowSizeGrip default True;
    property ShowStatusbar: Boolean read GetShowStatusbar write SetShowStatusbar default False;
    property StatusbarAlignment: TAlignment read GetStatusbarAlignment write SetStatusbarAlignment default taLeftJustify;
    property StatusbarColor: TColor read GetStatusbarColor write SetStatusbarColor default clBtnFace;
    property StatusbarText: String read GetStatusbarText write SetStatusbarText;
  public
    constructor Create(AOwner: TSCCustomVirtualCombobox); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomVirtualCombobox read FOwner;
  end;

  TSCVirtualComboboxPopupPropsClass = class of TSCVirtualComboboxCustomPopupProps;

  TSCVirtualComboboxPopupProps = class(TSCVirtualComboboxCustomPopupProps)
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
    property StatusbarAlignment;
    property ShowStatusbar;
    property StatusbarColor;
    property StatusbarText;
  end;

  TSCCustomVirtualCombobox = class(TSCCustomDropDown)
  private
    FAutoWidth: Boolean;
    FEndEllipsis: Boolean;
    FDblClickReverts: Boolean;
    FDropDownColor: TColor;
    FDropDownCount: Integer;
    FDropDownFont: TFont;
    FImmediateDropDown: Boolean;
    FImmediateSetText: Boolean;
    FItemCount: Integer;
    FItemHeight: Integer;
    FListBox: TSCCustomVirtualListbox;
    FMaxPopupHeight: Integer;
    FMaxPopupWidth: Integer;
    FMinPopupHeight: Integer;
    FMinPopupWidth: Integer;
    FScrollbar: TSCVirtualComboboxScrollbar;
    FShowItemImages: Boolean;
    FShowSizeGrip: Boolean;
    FShowStatusbar: Boolean;
    FStatusbarAlignment: TAlignment;
    FStatusbarColor: TColor;
    FStatusbarText: String;
    FPopupBorderStyle: TSCEditStyle;
    FPopupProps: TSCVirtualComboboxCustomPopupProps;
    FRevertable: Boolean;
    FSettingText: Boolean;
    FInternalItemIndex: Integer;
    FListClickType: TSCListClickType;
    FStartHeight: Integer;
    FStartWidth: Integer;
    FStoredHeight: Integer;
    FStoredWidth: Integer;
    FCreatingWnd: Boolean;
    FRowHeight: Integer;
    FRowCount: Integer;
    FOnGetItem: TSCGetListItemEvent;
    FOnGetItemIndex: TSCGetListItemIndexEvent;
    procedure SetDropDownCount(Value: Integer);
    procedure SetDropDownFont(Value: TFont);
    procedure SetMaxPopupHeight(Value: Integer);
    procedure SetMaxPopupWidth(Value: Integer);
    procedure SetMinPopupHeight(Value: Integer);
    procedure SetMinPopupWidth(Value: Integer);
    procedure SetPopupProps(Value: TSCVirtualComboboxCustomPopupProps);
    procedure SetScrollbar(Value: TSCVirtualComboboxScrollbar);

    function  GetItem(Index: Integer; var S: String; var ImageIndex: Integer): Boolean;
    function  GetListItemIndex(S: String): Integer;

    function  ListGetItem(Sender: TObject; Index: Integer; var S: String;
      var ImageIndex: Integer): Boolean;
    function  ListGetItemIndex(Sender: TObject; S: String): Integer;
    procedure ListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure DropDownFontChanged(Sender: TObject);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMMouseWheel(var Message: TWMMouse); message WM_MOUSEWHEEL;
    procedure EMSetReadOnly(var Message: TMessage); message EM_SETREADONLY;
  protected
    procedure CreateWnd; override;
    procedure WndProc(var Message: TMessage); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure Loaded; override;

    function  DoGetItem(Index: Integer; var S: String; var ImageIndex: Integer): Boolean; dynamic;
    function  DoGetItemIndex(S: String; var Handled: Boolean): Integer; dynamic;

    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; override;
    function  GetPopupPropsClass: TSCVirtualComboboxPopupPropsClass; dynamic;

    procedure DoAutoCompleted; override;
    function  CompletedText(const S: String; CaseSensitive: Boolean): String; virtual;
    function  AutoCompleteText: String; override;
    procedure SetEditMode(Value: TSCEditMode); override;

    procedure BeforeEnterKeyClose; override;
    function  DoWantKeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    procedure DoInternalChange; override;
    procedure DoListClick(Index: Integer; const Item: String); virtual;

    function  GetTextCalculateFont: TFont; override;
    function  GetTextHeight: Integer; override;
    procedure CalculateRowCount;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    procedure ImageListChange(Sender: TObject); override;

    function  GetDropDownHeight: Integer; virtual;
    function  GetPopupStyle: TSCEditStyle; override;
    procedure PrepareDropWindow; override;
    procedure BeforePrepareDropWindow; override;
    procedure AfterDropDown; override;
    procedure AfterCloseUp; override;
    function  DropDownWantKeys(Key: Word; Shift: TShiftState): Boolean; override;
    function  GetListboxClass: TSCCustomVirtualListboxClass; dynamic;

    function  CanDropDown: Boolean; override;
    function  GetDroppedDown: Boolean; override;
    function  GetDropDownWindow: TWinControl; override;
    function  GetIsDropDown: Boolean; override;
    procedure SetIsDropDown(Value: Boolean); override;

    procedure SetDropDownColor(Value: TColor); virtual;
    function  GetItemIndex: Integer; virtual; 
    procedure SetEndEllipsis(Value: Boolean); virtual;
    procedure SetItemCount(Value: Integer); virtual;
    procedure SetItemHeight(Value: Integer); virtual;
    procedure SetItemIndex(Value: Integer); virtual;
    procedure SetShowItemImages(Value: Boolean); virtual;

    property ListBox: TSCCustomVirtualListbox read FListBox;
    property ListClickType: TSCListClickType read FListClickType write FListClickType default sclcDefault;

    property CreatingWnd: Boolean read FCreatingWnd;
    property AutoWidth: Boolean read FAutoWidth write FAutoWidth default False;
    property DblClickReverts: Boolean read FDblClickReverts write FDblClickReverts default False;
    property DropDownColor: TColor read FDropDownColor write SetDropDownColor default clWindow;
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount default 8;
    property DropDownFont: TFont read FDropDownFont write SetDropDownFont;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default False;
    property ImmediateDropDown: Boolean read FImmediateDropDown write FImmediateDropDown default False;
    property ImmediateSetText: Boolean read FImmediateSetText write FImmediateSetText default True;
    property ItemCount: Integer read FItemCount write SetItemCount default 0;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 0;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property IsDropDown default True;
    property MaxPopupHeight: Integer read FMaxPopupHeight write SetMaxPopupHeight default 0;
    property MaxPopupWidth: Integer read FMaxPopupWidth write SetMaxPopupWidth default 0;
    property MinPopupHeight: Integer read FMinPopupHeight write SetMinPopupHeight default 0;
    property MinPopupWidth: Integer read FMinPopupWidth write SetMinPopupWidth default 0;
    property PopupBorderStyle: TSCEditStyle read FPopupBorderStyle write FPopupBorderStyle default scesDefault;
    property PopupProps: TSCVirtualComboboxCustomPopupProps read FPopupProps write SetPopupProps;
    property Revertable: Boolean read FRevertable write FRevertable default False;
    property Scrollbar: TSCVirtualComboboxScrollbar read FScrollbar write SetScrollbar;
    property CheckboxVisible default False;
    property ShowItemImages: Boolean read FShowItemImages write SetShowItemImages default False;
    property ShowSizeGrip: Boolean read FShowSizeGrip write FShowSizeGrip default True;
    property ShowStatusbar: Boolean read FShowStatusbar write FShowStatusbar default False;
    property StatusbarAlignment: TAlignment read FStatusbarAlignment write FStatusbarAlignment default taLeftJustify;
    property StatusbarColor: TColor read FStatusbarColor write FStatusbarColor default clBtnFace;
    property StatusbarText: String read FStatusbarText write FStatusbarText;
    property OnGetItem: TSCGetListItemEvent read FOnGetItem write FOnGetItem;
    property OnGetItemIndex: TSCGetListItemIndexEvent read FOnGetItemIndex write FOnGetItemIndex;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  IndexOfItem(Str: String): Integer; virtual;
    function  ItemText(Index: Integer): String; virtual;
  end;

  TSCVirtualCombobox = class(TSCCustomVirtualCombobox)
  public
    property ItemIndex;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property AutoWidth;
    property BiDiMode;
    property BorderProps;
    property BrowseButtonVisible;
    property ButtonProps;
    property CanDragSelection;
    property CharCase;
    property CheckboxStyle;
    property Color;
    property Colors;
    property Constraints;
    property DblClickReverts;
    property Delimeters;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownKey;
    property EditMask;
    property EditMode;
    property Enabled;
    property EndEllipsis;
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
    property ItemCount;
    property ItemHeight;
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
    property OnDropDown;
    property OnEditModeChange;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetItem;
    property OnGetItemIndex;
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
  TSCVirtualListboxScrollbars = class (TSCControlCustomScrollbars);
  TSCVirtualComboListbox = class(TSCCustomVirtualListbox);

  TSCDropDownVirtualListbox = class(TSCCustomVirtualListbox)
  private
    FDroppedDown: Boolean;
    FSettingHighlight: Boolean;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure WMShowWindow(var Message: TWMShowWindow); message WM_SHOWWINDOW;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;

    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ColorsChanged; override;

    property ForceDropdownClick default True;
  public
    constructor Create(AOwner: TComponent); override;
  end;

{ TSCDropDownVirtualListbox }

procedure TSCDropDownVirtualListbox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  HottrackColor := Font.Color;
end;

procedure TSCDropDownVirtualListbox.CMVisibleChanged(var Message: TMessage);
begin
  inherited;
  if not Boolean(Message.WParam) then
    FDroppedDown := False;
end;

procedure TSCDropDownVirtualListbox.ColorsChanged;
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

constructor TSCDropDownVirtualListbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  HotTrack := True;
  Border := sccbFlat;
  FlatColor := clWindowFrame;
  ForceDropdownClick := True;

  ColorsChanged;
end;

procedure TSCDropDownVirtualListbox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  
  with Params do
  begin
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    Style := Style and not WS_BORDER;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TSCDropDownVirtualListbox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;

procedure TSCDropDownVirtualListbox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Indx: Integer;
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
    if (Indx = -Maxint) or (Indx = Maxint) then
      Indx := -1;

    if (Indx <> -1) and (ItemIndex <> Indx) then
      ItemIndex := Indx;
  end;
end;

procedure TSCDropDownVirtualListbox.WMShowWindow(var Message: TWMShowWindow);
begin
  inherited;
  if not Message.Show then
    FDroppedDown := False;
end;

{ TSCVirtualComboboxScrollbar }

procedure TSCVirtualComboboxScrollbar.Assign(Source: TPersistent);
begin
  if Source is TSCVirtualComboboxScrollbar then
    with TSCVirtualComboboxScrollbar(Source) do
    begin
      Width := Self.Width;
      Style := Self.Style;
      ThumbLines := Self.ThumbLines;
      ButtonsLayout := Self.ButtonsLayout;
    end;

  inherited Assign(Source);
end;

constructor TSCVirtualComboboxScrollbar.Create(AOwner: TSCCustomControl;
  AKind: TSCScrollbarKind);
begin
  inherited Create(AOwner, AKind);
  FWidth := -1;
  FStyle := scssDefault;
  FThumbLines := sctlNone;
  FButtonsLayout := scsbDefault;
end;

procedure TSCVirtualComboboxScrollbar.SetWidth(Value: Integer);
begin
  if Value < 0 then Value := -1
  else
  if Value < 12 then Value := 12
  else
  if Value > 36 then Value := 36;

  FWidth := Value;
end;

{ TSCVirtualComboboxCustomPopupProps }

procedure TSCVirtualComboboxCustomPopupProps.Assign(Source: TPersistent);
begin
  if Source is TSCVirtualComboboxCustomPopupProps then
  begin
    with TSCVirtualComboboxCustomPopupProps(Source) do
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

constructor TSCVirtualComboboxCustomPopupProps.Create(AOwner: TSCCustomVirtualCombobox);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCVirtualComboboxCustomPopupProps.GetBorderStyle: TSCEditStyle;
begin
  Result := scesDefault;
  if FOwner <> nil then
    Result := FOwner.PopupBorderStyle;
end;

function TSCVirtualComboboxCustomPopupProps.GetColor: TColor;
begin
  Result := clWindow;
  if FOwner <> nil then
    Result := FOwner.DropDownColor;
end;

function TSCVirtualComboboxCustomPopupProps.GetFont: TFont;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.DropDownFont;
end;

function TSCVirtualComboboxCustomPopupProps.GetMaxHeight: Integer;
begin
  Result := 0;
  if FOwner <> nil then
    Result := FOwner.MaxPopupHeight;
end;

function TSCVirtualComboboxCustomPopupProps.GetMaxWidth: Integer;
begin
  Result := 0;
  if FOwner <> nil then
    Result := FOwner.MaxPopupWidth;
end;

function TSCVirtualComboboxCustomPopupProps.GetMinHeight: Integer;
begin
  Result := 0;
  if FOwner <> nil then
    Result := FOwner.MinPopupHeight;
end;

function TSCVirtualComboboxCustomPopupProps.GetMinWidth: Integer;
begin
  Result := 0;
  if FOwner <> nil then
    Result := FOwner.MinPopupWidth;
end;

function TSCVirtualComboboxCustomPopupProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCVirtualComboboxCustomPopupProps.GetScrollbar: TSCVirtualComboboxScrollbar;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.Scrollbar;
end;

function TSCVirtualComboboxCustomPopupProps.GetShowSizeGrip: Boolean;
begin
  Result := True;
  if FOwner <> nil then
    Result := FOwner.ShowSizeGrip;
end;

function TSCVirtualComboboxCustomPopupProps.GetShowStatusbar: Boolean;
begin
  Result := False;
  if FOwner <> nil then
    Result := FOwner.ShowStatusbar;
end;

function TSCVirtualComboboxCustomPopupProps.GetStatusbarAlignment: TAlignment;
begin
  Result := taLeftJustify;
  if FOwner <> nil then
    Result := FOwner.StatusbarAlignment;
end;

function TSCVirtualComboboxCustomPopupProps.GetStatusbarColor: TColor;
begin
  Result := clBtnFace;
  if FOwner <> nil then
    Result := FOwner.StatusbarColor;
end;

function TSCVirtualComboboxCustomPopupProps.GetStatusbarText: String;
begin
  Result := '';
  if FOwner <> nil then
    Result := FOwner.StatusbarText;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetBorderStyle(Value: TSCEditStyle);
begin
  if FOwner <> nil then
    FOwner.PopupBorderStyle := Value;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.DropDownColor := Value;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetFont(Value: TFont);
begin
  if FOwner <> nil then
    FOwner.DropDownFont := Value;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetMaxHeight(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.MaxPopupHeight := Value;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetMaxWidth(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.MaxPopupWidth := Value;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetMinHeight(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.MinPopupHeight := Value;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetMinWidth(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.MinPopupWidth := Value;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetScrollbar(Value: TSCVirtualComboboxScrollbar);
begin
  if FOwner <> nil then
    FOwner.Scrollbar := Value;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetShowSizeGrip(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.ShowSizeGrip := Value;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetShowStatusbar(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.ShowStatusbar := Value;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetStatusbarAlignment(
  Value: TAlignment);
begin
  if FOwner <> nil then
    FOwner.StatusbarAlignment := Value;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetStatusbarColor(Value: TColor);
begin
  if FOwner <> nil then
    FOwner.StatusbarColor := Value;
end;

procedure TSCVirtualComboboxCustomPopupProps.SetStatusbarText(Value: String);
begin
  if FOwner <> nil then
    FOwner.StatusbarText := Value;
end;

{ TSCCustomVirtualCombobox }

type
  TParentForm = class(TCustomForm);

function TSCCustomVirtualCombobox.CanDropDown: Boolean;
begin
  Result := (FListBox <> nil) and not IsDesigning and
    (TSCVirtualComboListbox(FListBox).ItemCount > 0);
end;

constructor TSCCustomVirtualCombobox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoComplete := False;
  IsDropDown := True;
  FDropDownCount := 8;

  ControlStyle := ControlStyle - [csSetCaption];

  FScrollbar := TSCVirtualComboboxScrollbar.Create(Self, scskVertical);
  FDropDownFont := TFont.Create;
  FDropDownFont.OnChange := DropDownFontChanged;

  FRowHeight := 0;
  FRowCount  := 0;

  FStoredHeight := -1;
  FStoredWidth  := -1;

  FImmediateSetText := True;
  FInternalItemIndex := -1;
  FDropDownColor := clWindow;
  FItemHeight := 0;
  FPopupBorderStyle := scesDefault;
  FShowSizeGrip := True;
  FStatusbarAlignment := taLeftJustify;
  FStatusbarColor := clBtnFace;

  SetCheckboxEnabled(False);

  FListBox := GetListboxClass.Create(Self);
  with TSCVirtualComboListbox(FListBox) do
  begin
    Visible := False;

    ControlStyle := ControlStyle + [csReplicatable];
    OnMouseUp    := ListMouseUp;
  end;

  FPopupProps := GetPopupPropsClass.Create(Self);
end;

destructor TSCCustomVirtualCombobox.Destroy;
begin
  FDropDownFont.OnChange := nil;
  FreeAndNil(FDropDownFont);

  if (FListBox <> nil) and not FListBox.IsDestroying then
  begin
    TSCVirtualComboListbox(FListBox).OnMouseUp := nil;
    FreeAndNil(FListBox);
  end;

  FreeAndNil(FScrollbar);
  FreeAndNil(FPopupProps);
  inherited Destroy;
end;

function TSCCustomVirtualCombobox.DoWantKeyDown(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := (Key in [VK_HOME, VK_END, VK_LEFT, VK_RIGHT]) or
    ((Key in [VK_UP, VK_DOWN]) and (ListBox = nil) or not DroppedDown) or
    ((Shift = [ssShift, ssCtrl]) and (Key in [Ord('z'), Ord('Z')])) or
    ((Shift = [ssCtrl]) and (Key in [Ord('c'), Ord('C'),
      Ord('v'), Ord('V'), Ord('x'), Ord('X'), Ord('z'), Ord('Z')]));
end;

procedure TSCCustomVirtualCombobox.DoInternalChange;
begin
  if not FSettingText then
  begin
    FInternalItemIndex := -1;

    if (FListBox <> nil) and DroppedDown then
    begin
      with TSCVirtualComboListbox(FListBox) do
      begin
        FInternalItemIndex := GetListItemIndex(Self.Text); // IndexOfItem(Self.Text);

        if AutoComplete then
        begin
          ItemIndex := FInternalItemIndex;
          MakeVisible(ItemIndex);

          Invalidate;
        end;
      end;
    end else
      FInternalItemIndex := GetListItemIndex(Self.Text); // IndexOfItem(Self.Text);
  end;
end;

function TSCCustomVirtualCombobox.DropDownWantKeys(Key: Word; Shift: TShiftState): Boolean;
begin
  Result := (DroppedDownSet and (Key in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR])) or
    ((FListBox <> nil) and IsDropDown and GetDroppedDown and (Key in [VK_LEFT, VK_RIGHT]));
end;

procedure TSCCustomVirtualCombobox.GetChildren(Proc: TGetChildProc;
  Root: TComponent);
begin
end;

function TSCCustomVirtualCombobox.GetDropDownWindow: TWinControl;
begin
  Result := FListBox;
end;

function TSCCustomVirtualCombobox.GetDroppedDown: Boolean;
begin
  Result := inherited GetDroppedDown and (FListbox.Focused or SendChildrenStyle);
end;

function TSCCustomVirtualCombobox.GetItemIndex: Integer;
begin
  Result := FInternalItemIndex;
end;

procedure TSCCustomVirtualCombobox.ListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Index: Integer;
begin
  if (Button = mbLeft) and (FListbox <> nil) and
    PtInRect(FListbox.ClientRect, Point(X, Y)) then
  begin
    Index := FListbox.ItemAtPos(X, Y, True);

    if Index = -1 then
      FInternalItemIndex := Index
    else begin
      if not ReadOnly then
      begin
        FSettingText := True;
        try
          FInternalItemIndex := Index;

          SetText(ItemText(FInternalItemIndex));
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
  end;
end;

procedure TSCCustomVirtualCombobox.MouseDown(Button: TMouseButton; Shift: TShiftState;
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
      FInternalItemIndex := ItemCount-1
    else
    if FInternalItemIndex > ItemCount-1 then
      FInternalItemIndex := 0;

    if FInternalItemIndex > ItemCount-1 then
      FInternalItemIndex := ItemCount-1;

    if (FInternalItemIndex > -1) and (FInternalItemIndex < ItemCount) then
    begin
      Index := FInternalItemIndex;

      Self.SetText(ItemText(Index));
      Self.SelectAll;

      ClearUndo;

      FListClickType := sclcMouse;
      try
        DoListClick(Index, Self.Text);
      finally
        FListClickType := sclcDefault;
      end;
    end;
  end;
end;

procedure TSCCustomVirtualCombobox.MouseMove(Shift: TShiftState; X, Y: Integer);
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

procedure TSCCustomVirtualCombobox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FListBox) then
    FListBox := nil;
end;

function TSCCustomVirtualCombobox.GetListboxClass: TSCCustomVirtualListboxClass;
begin
  Result := TSCDropDownVirtualListbox;
end;

procedure TSCCustomVirtualCombobox.PrepareDropWindow;
var
  MinW, W, H, CW, CH, SW: Integer;
begin
  if FListbox = nil then
    Exit;
    
  BeforePrepareDropWindow;
  
  with TSCVirtualComboListbox(FListbox) do
  begin
    Dropping := True;
    OnGetItem := ListGetItem;
    OnGetItemIndex := ListGetItemIndex;

    Parent := Self;
    Font   := Self.DropDownFont;

    ShowScrollbar := True;
    TSCVirtualListboxScrollbars(Scrollbars).Vertical := Self.FScrollbar;

    ApplyPopupBorder(TSCVirtualComboListbox(FListbox));

    Color          := Self.FDropDownColor;
    EndEllipsis    := Self.FEndEllipsis;
    Images         := Self.Images;
    Indent         := Self.Indent;
    ItemCount      := Self.ItemCount;
    ItemHeight     := Self.ItemHeight;
    ShowSizeGrip   := Self.ShowSizeGrip;
    ShowItemImages := Self.FShowItemImages;
    ShowStatusbar  := Self.FShowStatusbar;
    StatusbarText  := Self.FStatusbarText;
    StatusbarAlignment := Self.StatusbarAlignment;
    StatusbarColor := Self.FStatusbarColor;
    Revertable     := Self.Revertable;

    with Constraints do
    begin
      MinHeight := Self.FMinPopupHeight;
      MinWidth  := Self.FMinPopupWidth;
      MaxHeight := Self.FMaxPopupHeight;
      MaxWidth  := Self.FMaxPopupWidth;
    end;

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
        MinW := Self.FMinPopupWidth;

        W := Self.Width;
        if W < MinW then W := MinW;

        Width  := W;
      end else
      begin
        MinW := GetMinDropDownWidth;
        if Self.FMinPopupWidth > MinW then
          MinW := Self.FMinPopupWidth;

        if MinW < 0 then MinW := 0;

        W := Self.Width;
        if W < MinW then W := MinW;

        if CanShowScrollbar then
          Inc(W, GetSystemMetrics(SM_CXVSCROLL));

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

        if MinW > 0 then
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

    FInternalItemIndex := GetListItemIndex(Self.Text); // IndexOfItem(Self.Text);
    ItemIndex := FInternalItemIndex;

    TopIndex  := FInternalItemIndex;

    if FInternalItemIndex > -1 then
      MakeVisible(FInternalItemIndex);

    ShowScrollbar := True;

    ScrollButtonsLayout := Self.FScrollbar.ButtonsLayout;
    ScrollbarStyle := Self.FScrollbar.Style;
    ScrollbarThumbLines := Self.FScrollbar.ThumbLines;

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

procedure TSCCustomVirtualCombobox.AfterDropDown;
begin
  if FListbox <> nil then
    TSCVirtualComboListbox(FListbox).Dropping := False;
end;

procedure TSCCustomVirtualCombobox.AfterCloseUp;
begin
  if FListbox <> nil then
  begin
    if FListbox is TSCDropDownVirtualListbox then
      with TSCDropDownVirtualListbox(FListbox) do
      begin
        FDroppedDown := False;
        OnGetItem := nil;
        OnGetItemIndex := nil;
      end;

    with FListbox do
    begin
      if FStartHeight <> Height then
        FStoredHeight := Height;

      if FStartWidth <> Width then
        FStoredWidth  := Width;
    end;
  end;
end;

procedure TSCCustomVirtualCombobox.SetDropDownColor(Value: TColor);
begin
  if FDropDownColor <> Value then
  begin
    FDropDownColor := Value;
    if (FListBox <> nil) and GetDroppedDown then
      FListBox.Color := Value;
  end;
end;

procedure TSCCustomVirtualCombobox.SetDropDownCount(Value: Integer);
begin
  if Value < 1 then
    Value := 1;
  if Value > 100 then
    Value := 100;

  FDropDownCount := Value;
end;

procedure TSCCustomVirtualCombobox.SetDropDownFont(Value: TFont);
begin
  FDropDownFont.Assign(Value);
end;

procedure TSCCustomVirtualCombobox.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCVirtualComboListbox(FListBox).EndEllipsis := Value;
  end;
end;

procedure TSCCustomVirtualCombobox.SetItemIndex(Value: Integer);
var
  Cnt: Integer;
begin
  if Value < -1 then Value := -1;

  Cnt := ItemCount;
  if Value > Cnt - 1 then
    Value := Cnt - 1;

  if FInternalItemIndex <> Value then
  begin
    FInternalItemIndex := Value;
    if not IsDesigning then
    begin
      SetText(ItemText(Value));
      ClearUndo;
    end;

    if (FListBox <> nil) and GetDroppedDown then
      with TSCVirtualComboListbox(FListBox) do
      begin
        ItemIndex := Value;
        MakeVisible(ItemIndex);
      end;
  end;
end;

procedure TSCCustomVirtualCombobox.WMMouseWheel(var Message: TWMMouse);
var
  DropHandle: HWND;
  Index, Cnt: Integer;
begin
  if GetDroppedDown then
  begin
    DropHandle := GetDropDownHandle;
    if DropHandle <> 0 then
    begin
      if SmallInt(HiWord(Message.Keys)) > 0 then
        SendMessage(DropHandle, WM_VSCROLL, SB_LINEUP, 0)
      else
        SendMessage(DropHandle, WM_VSCROLL, SB_LINEDOWN, 0);

       Exit;
     end;
   end else
   if FListBox <> nil then
   begin
     FSettingText := True;
     try
       Cnt := ItemCount;
       if FInternalItemIndex = -1 then
         FInternalItemIndex := GetListItemIndex(Self.Text); // IndexOfItem(Self.Text);

       if SmallInt(HiWord(Message.Keys)) > 0 then
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

         Self.SetText(ItemText(Index));
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

     Exit;
   end;

   inherited;
end;

procedure TSCCustomVirtualCombobox.WndProc(var Message: TMessage);
var
  Shift: TShiftState;
  Index1, Index2: Integer;
begin
  case Message.Msg of
    WM_KEYDOWN, WM_SYSKEYDOWN, WM_CHAR:
      if SendChildrenStyle then
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
              Index1 := TSCVirtualComboListbox(FListbox).ItemIndex;

            with TMessage(Message) do
              SendMessage(FListbox.Handle, Msg, WParam, LParam);

            if not FImmediateSetText or ReadOnly then
              Exit;

            Index2 := TSCVirtualComboListbox(FListbox).ItemIndex;

            if Index1 <> Index2 then
            begin
              if Index2 = -1 then
                Self.SetText('')
              else begin
                Self.SetText(ItemText(Index2));
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

            Exit;
          end;

          if (Message.Msg = WM_CHAR) or ((Message.Msg = WM_KEYDOWN) and
            (TWMKey(Message).CharCode in [VK_DELETE, VK_BACK]))then
          begin
            inherited;

            if (CharCode <> 0) and DroppedDownSet and (FListbox <> nil) then
              with TSCVirtualComboListbox(FListBox) do
              begin
                Index1 := GetListItemIndex(Self.Text); // IndexOfItem(Self.Text);

                TopIndex := Index1;
                if AutoComplete then
                  ItemIndex := Index1
                else
                  ItemIndex := -1;
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

procedure TSCCustomVirtualCombobox.ImageListChange(Sender: TObject);
begin
  inherited;

  if (ImageIndex > -1) or ((FListBox <> nil) and GetDroppedDown) then
  begin
    TSCVirtualComboListbox(FListBox).Images := Self.Images;
    if ImageIndex > -1 then
      Invalidate;
  end;
end;

procedure TSCCustomVirtualCombobox.SetShowItemImages(Value: Boolean);
begin
  if FShowItemImages <> Value then
  begin
    FShowItemImages := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCVirtualComboListbox(FListBox).ShowItemImages := Value;
  end;
end;

procedure TSCCustomVirtualCombobox.SetItemHeight(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FItemHeight <> Value then
  begin
    FItemHeight := Value;
    CalculateRowCount;

    if (FListBox <> nil) and GetDroppedDown then
      TSCVirtualComboListbox(FListBox).ItemHeight := Value;
  end;
end;

procedure TSCCustomVirtualCombobox.DoListClick(Index: Integer; const Item: String);
begin
  //
end;

function TSCCustomVirtualCombobox.GetDropDownHeight: Integer;
var
  Cnt: Integer;
begin
  Result := ItemHeight;
  if Result <= 0 then
    Result := GetTextHeight;

  if Result < 1 then Result := 1;

  Cnt := FDropDownCount;
  if Cnt > ItemCount then
    Cnt := ItemCount;

  Result := Result*Cnt;
  if Result < 16 then Result := 16;
end;

procedure TSCCustomVirtualCombobox.BeforePrepareDropWindow;
begin
  //
end;

function TSCCustomVirtualCombobox.AutoCompleteText: String;
begin
  Result := Self.Text;
end;

procedure TSCCustomVirtualCombobox.KeyDown(var Key: Word; Shift: TShiftState);
var
  Cnt, Index: Integer;
begin
  if ((Key in [VK_UP, VK_DOWN]) or ((Key in [VK_LEFT, VK_RIGHT]) and GetIsDropDown)) and
    not (ssAlt in Shift) and ((ListBox = nil) or not DroppedDown and not ReadOnly) then
  begin
    if FInternalItemIndex = -1 then
      FInternalItemIndex := GetListItemIndex(Self.Text); // IndexOfItem(Self.Text);

    if Key in [VK_DOWN, VK_RIGHT] then
      Inc(FInternalItemIndex)
    else
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

      Self.SetText(ItemText(Index));
      Self.SelectAll;

      ClearUndo;

      FListClickType := sclcMouse;
      try
        DoListClick(Index, Self.Text);
      finally
        FListClickType := sclcDefault;
      end;

      Exit;
    end;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomVirtualCombobox.KeyPress(var Key: Char);
var
  Ch: Char;
  S: String;
  Inserted: Boolean;
begin
  Ch := Key;
  inherited KeyPress(Key);

  if FImmediateDropDown and not ReadOnly and (ListBox <> nil) and
    not DroppedDown and not GetIsDropDown and IsValidKey(Ch) then
  begin
    S := UpdateCharCase(Ch);
    if Length(S) <> 1 then
      Exit;

    Inserted := True;
    if EditMode = scemInsert then
    begin
      Inserted := (MaxLength = 0) or
        (Length(Text) < MaxLength) or HasSelection;
    end;

    if Inserted then
    begin
      Key := #0;
      scKillMessage(Handle, WM_CHAR);
      DoButtonClick(Button);

      Exit;
    end;
  end;
end;

procedure TSCCustomVirtualCombobox.SetMaxPopupHeight(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMaxPopupHeight <> Value then
  begin
    FMaxPopupHeight := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCVirtualComboListbox(FListBox).Constraints.MaxHeight := Value;
  end;
end;

procedure TSCCustomVirtualCombobox.SetMaxPopupWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMaxPopupWidth <> Value then
  begin
    FMaxPopupWidth := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCVirtualComboListbox(FListBox).Constraints.MaxWidth := Value;
  end;
end;

procedure TSCCustomVirtualCombobox.SetMinPopupHeight(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMinPopupHeight <> Value then
  begin
    FMinPopupHeight := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCVirtualComboListbox(FListBox).Constraints.MinHeight := Value;
  end;
end;

procedure TSCCustomVirtualCombobox.SetMinPopupWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FMinPopupWidth <> Value then
  begin
    FMinPopupWidth := Value;
    if (FListBox <> nil) and GetDroppedDown then
      TSCVirtualComboListbox(FListBox).Constraints.MinWidth := Value;
  end;
end;

procedure TSCCustomVirtualCombobox.BeforeEnterKeyClose;
var
  Index1: Integer;
begin
  if not FImmediateSetText and DroppedDown and
    (FListBox <> nil) and not ReadOnly then
  begin
    Index1 := TSCVirtualComboListbox(FListbox).ItemIndex;
    if Index1 = -1 then
      Exit;

    Self.SetText(ItemText(Index1));
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

function TSCCustomVirtualCombobox.CompletedText(const S: String;
  CaseSensitive: Boolean): String;
begin
  Result := S;
end;

procedure TSCCustomVirtualCombobox.DoAutoCompleted;
begin
  //
end;

procedure TSCCustomVirtualCombobox.SetScrollbar(Value: TSCVirtualComboboxScrollbar);
begin
  FScrollbar.Assign(Value);
end;

function TSCCustomVirtualCombobox.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCVirtualComboboxButtonProps;
end;

function TSCCustomVirtualCombobox.GetPopupPropsClass: TSCVirtualComboboxPopupPropsClass;
begin
  Result := TSCVirtualComboboxPopupProps;
end;

procedure TSCCustomVirtualCombobox.SetPopupProps(Value: TSCVirtualComboboxCustomPopupProps);
begin
  FPopupProps.Assign(Value);
end;

procedure TSCCustomVirtualCombobox.EMSetReadOnly(var Message: TMessage);
begin
  ReadOnly := True;
end;

function TSCCustomVirtualCombobox.GetIsDropDown: Boolean;
begin
  Result := True;
end;

procedure TSCCustomVirtualCombobox.SetItemCount(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FItemCount <> Value then
  begin
    FItemCount := Value;
    CalculateRowCount;
    
    if (ListBox <> nil) and not DroppedDown then
      TSCVirtualComboListbox(ListBox).ItemCount := FItemCount;
  end;
end;

function TSCCustomVirtualCombobox.GetItem(Index: Integer; var S: String;
  var ImageIndex: Integer): Boolean;
begin
  S := '';
  Result := False;
  if Index > -1 then
  begin
    Result := DoGetItem(Index, S, ImageIndex);
    if Assigned(FOnGetItem) then
      Result := FOnGetItem(Self, Index, S, ImageIndex);
  end;
end;

function TSCCustomVirtualCombobox.GetListItemIndex(S: String): Integer;
var
  Handled: Boolean;
begin
  Handled := False;
  Result := DoGetItemIndex(S, Handled);

  if (Result > -1) or Handled then
    Exit;

  if Assigned(FOnGetItemIndex) then
    Result := FOnGetItemIndex(Self, S)
  else Result := IndexOfItem(S);
end;

function TSCCustomVirtualCombobox.DoGetItem(Index: Integer; var S: String;
  var ImageIndex: Integer): Boolean;
begin
  S := '';
  ImageIndex := -1;
  Result := False;
end;

function TSCCustomVirtualCombobox.DoGetItemIndex(S: String;
  var Handled: Boolean): Integer;
begin
  Result := -1;
  Handled := False;
end;

function TSCCustomVirtualCombobox.IndexOfItem(Str: String): Integer;
var
  S: String;
  I, Img: Integer;
begin
  Result := -1;
  if FItemCount > 0 then
    for I := 0 to FItemCount-1 do
    begin
      S := '';
      Img := -1;

      if not GetItem(I, S, Img) then
      begin
        Result := -1;
        Exit;
      end;

      if AnsiSameText(Str, S) then
      begin
        Result := I;
        Exit;
      end;
    end;
end;

function TSCCustomVirtualCombobox.ItemText(Index: Integer): String;
var
  Img: Integer;
begin
  Result := '';
  if (Index > -1) and (Index < FItemCount) then
  begin
    Img := -1;
    if not GetItem(Index, Result, Img) then
      Result := '';
  end;
end;

procedure TSCCustomVirtualCombobox.SetEditMode(Value: TSCEditMode);
begin
  inherited SetEditMode(scemInsert);
end;

function TSCCustomVirtualCombobox.ListGetItem(Sender: TObject;
  Index: Integer; var S: String; var ImageIndex: Integer): Boolean;
begin
  Result := GetItem(Index, S, ImageIndex);
end;

function TSCCustomVirtualCombobox.ListGetItemIndex(Sender: TObject; S: String): Integer;
begin
  Result := GetListItemIndex(S);
end;

procedure TSCCustomVirtualCombobox.SetIsDropDown(Value: Boolean);
begin
  inherited SetIsDropDown(True);
end;

procedure TSCCustomVirtualCombobox.CalculateRowCount;
var
  CH, H: Integer;
begin
  if not IsLoading and HandleAllocated then
  begin
    FRowHeight := GetTextHeight;
    H := FRowHeight;

    if H < 1 then
      FRowCount := 0
    else begin
      CH := ClientHeight;
      FRowCount := CH div H;

      if CH mod H > 0 then
        Inc(FRowCount);
    end;

    if FRowCount < 1 then
      FRowCount := 1;
  end;
end;

function TSCCustomVirtualCombobox.GetTextHeight: Integer;
begin
  Result := FItemHeight;
  if Result = 0 then
    Result := inherited GetTextHeight + 2;
end;

procedure TSCCustomVirtualCombobox.CreateWnd;
begin
  Inc(FCreatingWnd);
  try
    inherited CreateWnd;
  finally
    Dec(FCreatingWnd);
  end;

  CalculateRowCount;
end;

procedure TSCCustomVirtualCombobox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  CalculateRowCount;
end;

function TSCCustomVirtualCombobox.GetTextCalculateFont: TFont;
begin
  Result := FDropDownFont;
end;

procedure TSCCustomVirtualCombobox.DropDownFontChanged(Sender: TObject);
begin
  CalculateRowCount;
end;

procedure TSCCustomVirtualCombobox.Loaded;
begin
  inherited Loaded;
  CalculateRowCount;
end;

procedure TSCCustomVirtualCombobox.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomVirtualCombobox then
  begin
    with TSCCustomVirtualCombobox(Source) do
    begin
      Self.AutoWidth := AutoWidth;
      Self.DblClickReverts := DblClickReverts;
      Self.DropDownColor := DropDownColor;
      Self.DropDownCount := DropDownCount;
      Self.DropDownFont := DropDownFont;
      Self.EndEllipsis := EndEllipsis;
      Self.ImmediateDropDown := ImmediateDropDown;
      Self.ImmediateSetText := ImmediateSetText;
      Self.ItemCount := ItemCount;
      Self.ItemHeight := ItemHeight;
      Self.ItemIndex := ItemIndex;
      Self.MaxPopupHeight := MaxPopupHeight;
      Self.MaxPopupWidth := MaxPopupWidth;
      Self.MinPopupHeight := MinPopupHeight;
      Self.MinPopupWidth := MinPopupWidth;
      Self.PopupBorderStyle := PopupBorderStyle;
      Self.PopupProps := PopupProps;
      Self.Revertable := Revertable;
      Self.Scrollbar := Scrollbar;
      Self.ShowItemImages := ShowItemImages;
      Self.ShowSizeGrip := ShowSizeGrip;
      Self.ShowStatusbar := ShowStatusbar;
      Self.StatusbarColor := StatusbarColor;
      Self.StatusbarText := StatusbarText;
    end;
  end;
end;

function TSCCustomVirtualCombobox.GetPopupStyle: TSCEditStyle;
begin
  Result := FPopupBorderStyle;
end;

{$I SCVerRec.inc}

end.
