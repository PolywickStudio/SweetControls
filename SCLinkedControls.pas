{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCLinkedControls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, SCCommon, SCConsts, SCControl, SCScrollbars;

type
  TSCMemoScrollbar = class(TSCControlScrollbar)
  protected
    property Visible default True;
  public
    constructor Create(AOwner: TSCCustomControl; AKind: TSCScrollbarKind); override;
  published
    property Background;
    property ButtonColors;
    property ExtraButton;
    property Icons;
    property SlideLine;
    property Style default scssFlatEx;
    property Thumb;
    property ThumbLines;
  end;

  TSCCustomMemo = class;

  TSCLinkedMemo = class(TCustomMemo)
  private
    FContainer: TSCCustomMemo;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    function GetPopupMenu: TPopupMenu; override;

    property Container: TSCCustomMemo read FContainer;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TSCMemoEditorClass = class of TSCLinkedMemo;

  TSCCustomMemo = class(TSCCustomControl)
  private
    FMemo: TCustomMemo;
    FMemoChanged: Integer;
    FEnterAsTab: Boolean;
    FUpdatingBars: Boolean;
    FScrollBars: TScrollStyle;
    FScrollbarStyles: TSCMemoScrollbar;
    FScrollbarHorz: TSCScrollbar;
    FScrollbarVert: TSCScrollbar;
    FOldWindowProc: TWndMethod;
    function  GetAlignment: TAlignment;
    function  GetBiDiMode: TBiDiMode;
    function  GetHideSelection: Boolean;
    procedure SetHideSelection(const Value: Boolean);
    function  GetImeMode: TImeMode;
    procedure SetImeMode(Value: TImeMode);
    function  GetImeName: TImeName;
    procedure SetImeName(Value: TImeName);
    function  GetLines: TStrings;
    function  GetMaxLength: Integer;
    procedure SetMaxLength(Value: Integer);
    function  GetOEMConvert: Boolean;
    procedure SetOEMConvert(Value: Boolean);
    function  GetParentBiDiMode: Boolean;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    procedure SetScrollBars(Value: TScrollStyle);
    procedure SetScrollbarStyles(Value: TSCMemoScrollbar);
    function  GetWantReturns: Boolean;
    procedure SetWantReturns(Value: Boolean);
    function  GetWantTabs: Boolean;
    procedure SetWantTabs(Value: Boolean);
    function  GetWordWrap: Boolean;
    procedure SetWordWrap(Value: Boolean);

    procedure MemoWindowProc(var Message: TMessage);
    procedure UpdateScrollbars;
    procedure ScrollbarChanged(Sender: TObject);

    procedure ConvertMemoPos(var X, Y: Integer);
    function  IsCaptionStored: Boolean;

    function  GetCanUndo: Boolean;
    function  GetModified: Boolean;
    procedure SetModified(Value: Boolean);
    procedure SetSelText(const Value: string);

    function  GetMemoChanged: Boolean;
    procedure MemoChange(Sender: TObject);
    procedure MemoClick(Sender: TObject);
    procedure MemoDblClick(Sender: TObject);
    procedure MemoDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure MemoDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure MemoEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure MemoEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure MemoEnter(Sender: TObject);
    procedure MemoExit(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MemoKeyPress(Sender: TObject; var Key: Char);
    procedure MemoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MemoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MemoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MemoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MemoStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure MemoStartDrag(Sender: TObject; var DragObject: TDragObject);

    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMParentColorChanged(var Message: TWMNoParams); message CM_PARENTCOLORCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMJumpToNext(var Message: TMessage); message CM_SCJUMPTONEXT;
    procedure CMWinIniChange(var Message: TWMWinIniChange); message CM_WININICHANGE;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;

    procedure WMCommand(var Message: TWMCommand); message WM_COMMAND;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMClear(var Message: TMessage); message WM_CLEAR;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure WMMouseWheel(var Message: TMessage); message WM_MOUSEWHEEL;
    procedure WMSetText(var Message:TWMSetText); message WM_SETTEXT;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure SetAlignment(Value: TAlignment);
    function  GetCaretPos: TPoint; virtual;
    procedure SetBiDiMode(Value: TBiDiMode); override;
    procedure SetLines(Value: TStrings);
    procedure SetParentBiDiMode(Value: Boolean); override;

    function  GetMemoEditorClass: TSCMemoEditorClass; dynamic;
    function  IsVisibleChild(C: TControl): Boolean; override;
    function  CanAlignText(var Value: TAlignment): Boolean; virtual;

    procedure Change; override;

    procedure DoSetMaxLength(Value: Integer); virtual;
    function  GetSelLength: Integer; virtual;
    function  GetSelStart: Integer; virtual;
    function  GetSelText: string; virtual;
    procedure SetSelLength(Value: Integer); virtual;
    procedure SetSelStart(Value: Integer); virtual;

    procedure ScrollerChanged(Sender: TSCCustomControlScrollbar); override;
    function  GetText: TCaption;
    procedure SetText(const Value: TCaption);

    property Memo: TCustomMemo read FMemo;
    property MemoChanged: Boolean read GetMemoChanged;
    property Alignment: TAlignment read GetAlignment write SetAlignment;
    property BiDiMode: TBiDiMode read GetBiDiMode write SetBiDiMode default bdLeftToRight;
    property Border default sccbFlat;
    property Caption: TCaption read GetText write SetText stored IsCaptionStored;
    property Color default clWindow;
    property EnterAsTab: Boolean read FEnterAsTab write FEnterAsTab default False;
    property HideSelection: Boolean read GetHideSelection write SetHideSelection default True;
    property ImeMode: TImeMode read GetImeMode write SetImeMode default imDontCare;
    property ImeName: TImeName read GetImeName write SetImeName;
    property MaxLength: Integer read GetMaxLength write SetMaxLength default 0;
    property OEMConvert: Boolean read GetOEMConvert write SetOEMConvert default False;
    property ParentBiDiMode: Boolean read GetParentBiDiMode write SetParentBiDiMode default True;
    property ParentColor default False;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars default ssNone;
    property ScrollbarStyles: TSCMemoScrollbar read FScrollbarStyles write SetScrollbarStyles;
    property Text: TCaption read GetText write SetText;
    property WantReturns: Boolean read GetWantReturns write SetWantReturns default True;
    property WantTabs: Boolean read GetWantTabs write SetWantTabs default False;
    property WordWrap: Boolean read GetWordWrap write SetWordWrap default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    function  GetControlsAlignment: TAlignment; override;
    procedure Clear; virtual;
    procedure ClearSelection;
    procedure CopyToClipboard;
    procedure CutToClipboard;
    procedure DefaultHandler(var Message); override;
    procedure PasteFromClipboard;
    procedure Undo;
    procedure ClearUndo;
    function  GetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer; virtual;
    procedure SelectAll;
    procedure SetSelTextBuf(Buffer: PChar);

    property CanUndo: Boolean read GetCanUndo;
    property CaretPos: TPoint read GetCaretPos;
    property Lines: TStrings read GetLines write SetLines;
    property Modified: Boolean read GetModified write SetModified;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelText: string read GetSelText write SetSelText;
  end;

  TSCMemo = class(TSCCustomMemo)
  public
    property Text;
  published
    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property BorderProps;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EnterAsTab;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property Lines;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
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
    property WantReturns;
    property WantTabs;
    property WordWrap;
    property OnChange;
    property OnClick;
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

implementation

type
  TFakeScrollbar = class(TSCControlScrollbar);
  TFakeScrollbarPart = class(TSCScrollbarPart);
  TFakeActionLink = class(TControlActionLink);

{ TSCLinkedMemo }

constructor TSCLinkedMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
end;

procedure TSCLinkedMemo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params.WindowClass do
  begin
    Style := Style and not CS_VREDRAW;
    if (ScrollBars in [ssHorizontal, ssBoth]) or not WordWrap then
      Style := Style and not CS_HREDRAW;
  end;
end;

function TSCLinkedMemo.GetPopupMenu: TPopupMenu;
begin
  Result := nil;
  if FContainer <> nil then
    Result := FContainer.PopupMenu;
end;

{ TSCCustomMemo }

procedure TSCCustomMemo.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomMemo then
  begin
    with TSCCustomMemo(Source) do
    begin
      Self.Alignment := Alignment;
      Self.EnterAsTab := EnterAsTab;
      Self.HideSelection := HideSelection;
      Self.MaxLength := MaxLength;
      Self.OEMConvert := OEMConvert;
      Self.ReadOnly := ReadOnly;
      Self.ScrollBars := ScrollBars;
      Self.ScrollbarStyles := ScrollbarStyles;
      Self.Text := Text;
      Self.WantReturns := WantReturns;
      Self.WantTabs := WantTabs;
      Self.WordWrap := WordWrap;
    end;
  end;    
end;

function TSCCustomMemo.CanAlignText(var Value: TAlignment): Boolean;
begin
  Result := True;
end;

procedure TSCCustomMemo.Change;
begin
  if FMemoChanged > 0 then
    inherited Change;
end;

procedure TSCCustomMemo.Clear;
begin
  if FMemo <> nil then
    FMemo.Clear;
end;

procedure TSCCustomMemo.ClearSelection;
begin
  if FMemo <> nil then
    FMemo.ClearSelection;
end;

procedure TSCCustomMemo.ClearUndo;
begin
  if FMemo <> nil then
    FMemo.ClearUndo;
end;

procedure TSCCustomMemo.CMColorChanged(var Message: TMessage);
begin
  inherited;
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).Color := Self.Color;
end;

procedure TSCCustomMemo.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).Enabled := Self.Enabled;
end;

procedure TSCCustomMemo.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
end;

procedure TSCCustomMemo.CMFontChanged(var Message: TMessage);
begin
  inherited;
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).Font := Self.Font;
end;

procedure TSCCustomMemo.CMJumpToNext(var Message: TMessage);
begin
  Message.Result := 0;
  if FEnterAsTab and (Message.WParam = VK_RETURN) then
    Message.Result := 1;
end;

procedure TSCCustomMemo.CMParentColorChanged(var Message: TWMNoParams);
begin
  inherited;
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).Color := Self.Color;
end;

procedure TSCCustomMemo.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).Color := Self.Color;
end;

procedure TSCCustomMemo.CMWinIniChange(var Message: TWMWinIniChange);
begin
  inherited;
  UpdateScrollbars;
end;

procedure TSCCustomMemo.ConvertMemoPos(var X, Y: Integer);
var
  Bs: Integer;
begin
  Bs := GetBorderSize + GetInnerBorderSize + BorderWidth;
  if Bs < 0 then Bs := 0;

  Inc(X, Bs);
  Inc(Y, Bs);
end;

procedure TSCCustomMemo.CopyToClipboard;
begin

end;

constructor TSCCustomMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];

  Border := sccbFlat;
  Color := clWindow;
  ParentColor := False;
  FScrollBars := ssNone;
  ClickFocus := True;

  FMemo := GetMemoEditorClass.Create(Self);
  FMemo.Parent := Self;

  with TSCLinkedMemo(FMemo) do
  begin
    FContainer := Self;

    FOldWindowProc := WindowProc;
    WindowProc := MemoWindowProc;

    ParentColor := True;
    BorderStyle := bsNone;
    Align := alClient;

    OnChange := MemoChange;
    OnClick := MemoClick;
    OnDblClick := MemoDblClick;
    OnDragDrop := MemoDragDrop;
    OnDragOver := MemoDragOver;
    OnEndDock := MemoEndDock;
    OnEndDrag := MemoEndDrag;
    OnEnter := MemoEnter;
    OnExit := MemoExit;
    OnKeyDown := MemoKeyDown;
    OnKeyPress := MemoKeyPress;
    OnKeyUp := MemoKeyUp;
    OnMouseDown := MemoMouseDown;
    OnMouseMove := MemoMouseMove;
    OnMouseUp := MemoMouseUp;
    OnStartDock := MemoStartDock;
    OnStartDrag := MemoStartDrag;
  end;

  FScrollbarStyles := TSCMemoScrollbar.Create(Self, scskVertical);

  FScrollbarHorz := TSCScrollbar.Create(Self);
  with FScrollbarHorz do
  begin
    Parent := Self;
    Kind := scskHorizontal;
    Visible := False;
    TabStop := False;
    ClickFocus := False;
    Style := scssFlatEx;
    OnChange := ScrollbarChanged;
    SetBounds(0, 0, 0, 0);
  end;

  FScrollbarVert := TSCScrollbar.Create(Self);
  with FScrollbarVert do
  begin
    Parent := Self;
    Kind := scskVertical;
    Visible := False;
    TabStop := False;
    ClickFocus := False;
    Style := scssFlatEx;
    OnChange := ScrollbarChanged;
    SetBounds(0, 0, 0, 0);
  end;

  SetBounds(Left, Top, 185, 89);
end;

procedure TSCCustomMemo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_CLIPCHILDREN;
  with Params.WindowClass do
  begin
    Style := Style and not CS_VREDRAW;
    if (FScrollBars in [ssHorizontal, ssBoth]) or WordWrap then
      Style := Style and not CS_HREDRAW;
  end;
end;

procedure TSCCustomMemo.CutToClipboard;
begin

end;

procedure TSCCustomMemo.DefaultHandler(var Message);
begin
  inherited;

end;

destructor TSCCustomMemo.Destroy;
begin
  Destroying;

  FreeAndNil(FScrollbarHorz);
  FreeAndNil(FScrollbarVert);

  with TSCLinkedMemo(FMemo) do
  begin
    OnChange := nil;
    OnClick := nil;
    OnDblClick := nil;
    OnDragDrop := nil;
    OnDragOver := nil;
    OnEndDock := nil;
    OnEndDrag := nil;
    OnEnter := nil;
    OnExit := nil;
    OnKeyDown := nil;
    OnKeyPress := nil;
    OnKeyUp := nil;
    OnMouseDown := nil;
    OnMouseMove := nil;
    OnMouseUp := nil;
    OnStartDock := nil;
    OnStartDrag := nil;

    FContainer := nil;
    WindowProc := FOldWindowProc;
  end;
  FreeAndNil(FMemo);

  FreeAndNil(FScrollbarStyles);
  inherited Destroy;
end;

procedure TSCCustomMemo.DoSetMaxLength(Value: Integer);
begin
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).DoSetMaxLength(Value);
end;

function TSCCustomMemo.GetAlignment: TAlignment;
begin
  Result := taLeftJustify;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).Alignment;
end;

function TSCCustomMemo.GetBiDiMode: TBiDiMode;
begin
  Result := inherited BiDiMode;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).BiDiMode;
end;

function TSCCustomMemo.GetCanUndo: Boolean;
begin
  Result := False;
  if FMemo <> nil then Result := FMemo.CanUndo;
end;

function TSCCustomMemo.GetCaretPos: TPoint;
begin
  Result := Point(0, 0);
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).GetCaretPos;
end;

procedure TSCCustomMemo.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

function TSCCustomMemo.GetControlsAlignment: TAlignment;
begin
  Result := GetAlignment;
end;

function TSCCustomMemo.GetHideSelection: Boolean;
begin
  Result := True;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).HideSelection;
end;

function TSCCustomMemo.GetImeMode: TImeMode;
begin
  Result := inherited ImeMode;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).ImeMode;
end;

function TSCCustomMemo.GetImeName: TImeName;
begin
  Result := inherited ImeName;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).ImeName;
end;

function TSCCustomMemo.GetLines: TStrings;
begin
  Result := nil;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).Lines;
end;

function TSCCustomMemo.GetMaxLength: Integer;
begin
  Result := 0;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).MaxLength;
end;

function TSCCustomMemo.GetMemoChanged: Boolean;
begin
  Result := FMemoChanged > 0;
end;

function TSCCustomMemo.GetMemoEditorClass: TSCMemoEditorClass;
begin
  Result := TSCLinkedMemo;
end;

function TSCCustomMemo.GetModified: Boolean;
begin
  Result := False;
  if FMemo <> nil then Result := FMemo.Modified;
end;

function TSCCustomMemo.GetOEMConvert: Boolean;
begin
  Result := False;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).OEMConvert;
end;

function TSCCustomMemo.GetParentBiDiMode: Boolean;
begin
  Result := inherited ParentBiDiMode;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).ParentBiDiMode;
end;

function TSCCustomMemo.GetReadOnly: Boolean;
begin
  Result := False;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).ReadOnly;
end;

function TSCCustomMemo.GetSelLength: Integer;
begin
  Result := 0;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).GetSelLength;
end;

function TSCCustomMemo.GetSelStart: Integer;
begin
  Result := 0;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).GetSelStart;
end;

function TSCCustomMemo.GetSelText: string;
begin
  Result := '';
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).GetSelText;
end;

function TSCCustomMemo.GetSelTextBuf(Buffer: PChar;
  BufSize: Integer): Integer;
begin
  Result := 0;
  if FMemo <> nil then
    FMemo.GetSelTextBuf(Buffer, BufSize);
end;

function TSCCustomMemo.GetText: TCaption;
begin
  Result := '';
  if FMemo <> nil then Result := FMemo.Text;
end;

function TSCCustomMemo.GetWantReturns: Boolean;
begin
  Result := True;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).WantReturns;
end;

function TSCCustomMemo.GetWantTabs: Boolean;
begin
  Result := False;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).WantTabs;
end;

function TSCCustomMemo.GetWordWrap: Boolean;
begin
  Result := True;
  if FMemo <> nil then
    Result := TSCLinkedMemo(FMemo).WordWrap;
end;

function TSCCustomMemo.IsCaptionStored: Boolean;
begin
  Result := (ActionLink = nil) or not TFakeActionLink(ActionLink).IsCaptionLinked;
end;

function TSCCustomMemo.IsVisibleChild(C: TControl): Boolean;
begin
  Result := (C <> nil) and (C <> FMemo) and (C <> FScrollbarHorz) and
    (C <> FScrollbarVert);
end;

procedure TSCCustomMemo.Loaded;
begin
  inherited Loaded;
  UpdateScrollbars;
end;

procedure TSCCustomMemo.MemoChange(Sender: TObject);
begin
  Inc(FMemoChanged);
  try
    UpdateScrollbars;
    Change;
  finally
    Dec(FMemoChanged);
  end;
end;

procedure TSCCustomMemo.MemoClick(Sender: TObject);
begin
  Click;
end;

procedure TSCCustomMemo.MemoDblClick(Sender: TObject);
begin
  DblClick;
end;

procedure TSCCustomMemo.MemoDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  ConvertMemoPos(X, Y);
  DragDrop(Source, X, Y);
end;

procedure TSCCustomMemo.MemoDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  ConvertMemoPos(X, Y);
  DragOver(Source, X, Y, State, Accept);
end;

procedure TSCCustomMemo.MemoEndDock(Sender, Target: TObject; X,
  Y: Integer);
begin
  ConvertMemoPos(X, Y);
  DoEndDock(Target, X, Y);
end;

procedure TSCCustomMemo.MemoEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  ConvertMemoPos(X, Y);
  DoEndDrag(Target, X, Y);
end;

procedure TSCCustomMemo.MemoEnter(Sender: TObject);
begin
  DoEnter;
end;

procedure TSCCustomMemo.MemoExit(Sender: TObject);
begin
  DoExit;
end;

procedure TSCCustomMemo.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not DoNextControl(Key, Shift) then
    KeyDown(Key, Shift);
end;

procedure TSCCustomMemo.MemoKeyPress(Sender: TObject; var Key: Char);
begin
  KeyPress(Key);
end;

procedure TSCCustomMemo.MemoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  KeyUp(Key, Shift);
end;

procedure TSCCustomMemo.MemoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ConvertMemoPos(X, Y);
  MouseDown(Button, Shift, X, Y);
end;

procedure TSCCustomMemo.MemoMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ConvertMemoPos(X, Y);
  MouseMove(Shift, X, Y);
end;

procedure TSCCustomMemo.MemoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ConvertMemoPos(X, Y);
  MouseUp(Button, Shift, X, Y);
end;

procedure TSCCustomMemo.MemoStartDock(Sender: TObject;
  var DragObject: TDragDockObject);
begin
  DoStartDock(TDragObject(DragObject));
end;

procedure TSCCustomMemo.MemoStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  DoStartDrag(DragObject);
end;

procedure TSCCustomMemo.MemoWindowProc(var Message: TMessage);
begin
  if FMemo <> nil then
  begin
    FOldWindowProc(Message);

    case Message.Msg of
      WM_NCCALCSIZE, WM_WINDOWPOSCHANGED,
      WM_CUT, WM_PASTE, WM_CLEAR, WM_UNDO,
      WM_SETTEXT, WM_KEYDOWN, WM_SIZE,
      CM_ENABLEDCHANGED, CM_WININICHANGE:
        UpdateScrollbars;
    end;
  end;
end;

procedure TSCCustomMemo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FMemo <> nil) and
    (AComponent = FMemo) then FMemo := nil;
end;

procedure TSCCustomMemo.PasteFromClipboard;
begin

end;

procedure TSCCustomMemo.ScrollbarChanged(Sender: TObject);
var
  WParam, LParam: LongInt;
  Scrollbar: TSCScrollbar;
begin
  if not FUpdatingBars and (FMemo <> nil) and (Sender is TSCScrollbar) then
  begin
    Scrollbar := TSCScrollbar(Sender);

    LParam := WM_HSCROLL;
    if Scrollbar.Kind = scskVertical then LParam := WM_VSCROLL;
    WParam := MakeWParam(SB_THUMBPOSITION, Scrollbar.Position);

    SendMessage(FMemo.Handle, LParam, WParam, 0);
  end;
end;

procedure TSCCustomMemo.ScrollerChanged(Sender: TSCCustomControlScrollbar);

  procedure UpdateColors(Barcolors: TSCScrollbarColors; Part: TFakeScrollbarPart);
  begin
    with BarColors do
    begin
      ActiveColor := Part.DownColor;
      DefaultColor := Part.Color;
      HotColor := Part.HotColor;
      DisabledColor := Part.DisabledColor;
    end;
  end;

  procedure UpdateScrollbar(Scrollbar: TSCScrollbar; Barinfo: TSCMemoScrollbar);
  var
    Part: TFakeScrollbarPart;
  begin
    if Scrollbar <> nil then
    begin
      Scrollbar.Style := Barinfo.Style;
      
      Part := TFakeScrollbarPart(Barinfo.Background);
      Scrollbar.BackColors.BlendColors := Part.Blend;

      UpdateColors(Scrollbar.BackColors, Part);

      Part := TFakeScrollbarPart(Barinfo.ButtonColors);
      UpdateColors(Scrollbar.ButtonColors, Part);

      Part := TFakeScrollbarPart(Barinfo.Icons);
      UpdateColors(Scrollbar.ButtonIconColors, Part);

      Part := TFakeScrollbarPart(Barinfo.Thumb);
      UpdateColors(Scrollbar.ThumbColors, Part);

      Scrollbar.ShowExtraButton := Barinfo.ExtraButton;
      Scrollbar.ThumbLines := Barinfo.ThumbLines;
      Scrollbar.ShowSlideLine := Barinfo.SlideLine;
    end;
  end;

var
  Barinfo: TSCMemoScrollbar;
begin
  if Sender is TSCMemoScrollbar then
  begin
    Barinfo := TSCMemoScrollbar(Sender);

    UpdateScrollbar(FScrollbarHorz, Barinfo);
    UpdateScrollbar(FScrollbarVert, Barinfo);
  end;
end;

procedure TSCCustomMemo.SelectAll;
begin
  if FMemo <> nil then
    FMemo.SelectAll;
end;

procedure TSCCustomMemo.SetAlignment(Value: TAlignment);
begin
  if (FMemo <> nil) and CanAlignText(Value) then
    TSCLinkedMemo(FMemo).Alignment := Value;
end;

procedure TSCCustomMemo.SetBiDiMode(Value: TBiDiMode);
begin
  inherited SetBiDiMode(Value);
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).BiDiMode := Value;
end;

procedure TSCCustomMemo.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  UpdateScrollbars;
end;

procedure TSCCustomMemo.SetHideSelection(const Value: Boolean);
begin
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).HideSelection := Value;
end;

procedure TSCCustomMemo.SetImeMode(Value: TImeMode);
begin
  inherited ImeMode := Value;
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).ImeMode := Value;
end;

procedure TSCCustomMemo.SetImeName(Value: TImeName);
begin
  inherited ImeName := Value;
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).ImeName := Value;
end;

procedure TSCCustomMemo.SetLines(Value: TStrings);
begin
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).Lines := Value;
end;

procedure TSCCustomMemo.SetMaxLength(Value: Integer);
begin
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).MaxLength := Value;
end;

procedure TSCCustomMemo.SetModified(Value: Boolean);
begin
  if FMemo <> nil then FMemo.Modified := Value;
end;

procedure TSCCustomMemo.SetOEMConvert(Value: Boolean);
begin
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).OEMConvert := Value;
end;

procedure TSCCustomMemo.SetParentBiDiMode(Value: Boolean);
begin
  inherited SetParentBiDiMode(Value);
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).ParentBiDiMode := Value;
end;

procedure TSCCustomMemo.SetReadOnly(Value: Boolean);
begin
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).ReadOnly := Value;
end;

procedure TSCCustomMemo.SetScrollBars(Value: TScrollStyle);
begin
  if FScrollBars <> Value then
  begin
    FScrollBars := Value;
    if FMemo <> nil then
      TSCLinkedMemo(FMemo).ScrollBars := Value;

    UpdateScrollbars;
  end;
end;

procedure TSCCustomMemo.SetScrollbarStyles(Value: TSCMemoScrollbar);
begin
  FScrollbarStyles.Assign(Value);
end;

procedure TSCCustomMemo.SetSelLength(Value: Integer);
begin
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).SetSelLength(Value);
end;

procedure TSCCustomMemo.SetSelStart(Value: Integer);
begin
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).SetSelStart(Value);
end;

procedure TSCCustomMemo.SetSelText(const Value: string);
begin
  if FMemo <> nil then FMemo.SelText := Value;
end;

procedure TSCCustomMemo.SetSelTextBuf(Buffer: PChar);
begin
  if FMemo <> nil then
    FMemo.SetSelTextBuf(Buffer);
end;

procedure TSCCustomMemo.SetText(const Value: TCaption);
begin
  if FMemo <> nil then FMemo.Text := Value;
end;

procedure TSCCustomMemo.SetWantReturns(Value: Boolean);
begin
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).WantReturns := Value;
end;

procedure TSCCustomMemo.SetWantTabs(Value: Boolean);
begin
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).WantTabs := Value;
end;

procedure TSCCustomMemo.SetWordWrap(Value: Boolean);
begin
  if FMemo <> nil then
    TSCLinkedMemo(FMemo).WordWrap := Value;
end;

procedure TSCCustomMemo.Undo;
begin

end;

procedure TSCCustomMemo.UpdateScrollbars;

  procedure UpdateScrollbar(Scrollbar: TSCScrollbar);
  var
    R: TRect;
    ScrollbarState: DWORD;
    ScrollInfo: TScrollInfo;
    ScrollbarVisible: Boolean;
    ScrollbarInfo: TScrollBarInfo;
  begin
    ScrollbarVisible := False;
    repeat
      if IsDestroying or (Parent = nil) or (Scrollbar = nil) or
        not HandleAllocated or not FMemo.HandleAllocated then
        Break;

      ScrollbarInfo.cbSize := SizeOf(ScrollbarInfo);
      if Scrollbar.Kind = scskHorizontal then
      begin
        if not Windows.GetScrollBarInfo(FMemo.Handle, Integer(OBJID_HSCROLL),
          ScrollbarInfo) then
          Break;
      end else
      if not Windows.GetScrollBarInfo(FMemo.Handle, Integer(OBJID_VSCROLL),
        ScrollbarInfo) then
        Break;

      ScrollbarState := ScrollbarInfo.rgstate[0];
      if ScrollbarState and (STATE_SYSTEM_INVISIBLE or STATE_SYSTEM_OFFSCREEN) <> 0 then
        Break;

      ScrollbarVisible := True;
      Scrollbar.Enabled := ScrollbarState and STATE_SYSTEM_UNAVAILABLE = 0;

      with ScrollbarInfo.rcScrollBar do
      begin
        R.TopLeft := ScreenToClient(TopLeft);
        R.Right := Right - Left;
        R.Bottom := Bottom - Top;
      end;

      with R do
      begin
        if (Left < 0) or (Right > Width) or (Top < 0) or (Bottom > Height) then
        begin
          ScrollbarVisible := False;
          Scrollbar.SetBounds(0, 0, 0, 0);
        end
        else
          Scrollbar.SetBounds(Left, Top, Right, Bottom);
      end;
    until True;

    Scrollbar.Visible := ScrollbarVisible;
    if not ScrollbarVisible then
    begin
      Scrollbar.Visible := False;
      Scrollbar.SetBounds(0, 0, 0, 0);
      Exit;
    end;

    ScrollInfo.cbSize := SizeOf(ScrollInfo);
    ScrollInfo.fMask := SIF_ALL;

    if Scrollbar.Kind = scskHorizontal then
      GetScrollInfo(FMemo.Handle, SB_HORZ, ScrollInfo)
    else
      GetScrollInfo(FMemo.Handle, SB_VERT, ScrollInfo);

    with ScrollInfo do
    begin
      if Integer(nPage) > nMax then
        Integer(nPage) := nMax;

      Scrollbar.Min := nMin;
      Scrollbar.Max := nMax;
      Scrollbar.Position := nPos;
      Scrollbar.PageSize := nPage;
    end;

    if ScrollbarVisible then
      ScrollBar.BringToFront;
  end;

begin
  if not FUpdatingBars and (FMemo <> nil) and FMemo.HandleAllocated then
  begin
    FUpdatingBars := True;
    try
      UpdateScrollbar(FScrollbarHorz);
      UpdateScrollbar(FScrollbarVert);
    finally
      FUpdatingBars := False;
    end;
  end;
end;

procedure TSCCustomMemo.WMClear(var Message: TMessage);
begin
  inherited;
  if FMemo <> nil then
    FMemo.DefaultHandler(Message);
end;

procedure TSCCustomMemo.WMCommand(var Message: TWMCommand);
begin
  inherited;
  if (Message.NotifyCode = EN_VSCROLL) or (Message.NotifyCode = EN_HSCROLL) then
    UpdateScrollbars;
end;

procedure TSCCustomMemo.WMCut(var Message: TMessage);
begin
  inherited;
  if FMemo <> nil then
    FMemo.DefaultHandler(Message);
end;

procedure TSCCustomMemo.WMHScroll(var Message: TWMHScroll);
begin
  inherited;
  if FMemo <> nil then
    FMemo.DefaultHandler(Message);
end;

procedure TSCCustomMemo.WMMouseWheel(var Message: TMessage);
begin
  inherited;
  if FMemo <> nil then
    FMemo.DefaultHandler(Message);
end;

procedure TSCCustomMemo.WMPaste(var Message: TMessage);
begin
  inherited;
  if FMemo <> nil then
    FMemo.DefaultHandler(Message);
end;

procedure TSCCustomMemo.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if (FMemo <> nil) and FMemo.CanFocus then
    FMemo.SetFocus;
end;

procedure TSCCustomMemo.WMSetText(var Message: TWMSetText);
begin
  // inherited;
  if FMemo <> nil then
    FMemo.DefaultHandler(Message);
end;

procedure TSCCustomMemo.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateScrollbars;
end;

procedure TSCCustomMemo.WMUndo(var Message: TMessage);
begin
  inherited;
  if FMemo <> nil then
    FMemo.DefaultHandler(Message);
end;

procedure TSCCustomMemo.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
  if FMemo <> nil then
    FMemo.DefaultHandler(Message);
end;

{ TSCMemoScrollbar }

constructor TSCMemoScrollbar.Create(AOwner: TSCCustomControl;
  AKind: TSCScrollbarKind);
begin
  inherited Create(AOwner, AKind);
  Visible := True;
  Style := scssFlatEx;
end;

{$I SCVerRec.inc}

end.
