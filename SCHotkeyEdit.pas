{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCHotkeyEdit;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Clipbrd, SCCommon, SCConsts, SCControl, SCAdvEdits;

type
  TSCHKModifier = (schkShift, schkCtrl, schkAlt, schkExt);
  TSCHKModifiers = set of TSCHKModifier;
  TSCHKInvalidKey = (schcNone, schcShift, schcCtrl, schcAlt,
    schcShiftCtrl, schcShiftAlt, schcCtrlAlt, schcShiftCtrlAlt);
  TSCHKInvalidKeys = set of TSCHKInvalidKey;

const
  scDefaultModifiers = [schkAlt];
  scDefaultInvalidKeys = [schcNone, schcShift];

type
  TSCCustomHotkeyEdit = class(TSCCustomFrameEdit)
  private
    FHotKey: Word;
    FModifiers: TSCHKModifiers;
    FHotModifiers: TSCHKModifiers;
    FInvalidKeys: TSCHKInvalidKeys;
    FOnHotkeyChange: TNotifyEvent;
    FHotkeyUpdate: Integer;
    FInternalUpdate: Integer;
    function  GetHotKey: TShortCut;
    procedure SetHotKey(Value: TShortCut);
    procedure SetInvalidKeys(Value: TSCHKInvalidKeys);
    procedure SetModifiers(Value: TSCHKModifiers);

    procedure ShortCutToHotKey(Value: TShortCut);
    procedure UpdateHotText;

    procedure UpdateHotKey(Value: TShortCut);

    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure Loaded; override;

    function  GetEditCursor: TCursor; override;
    procedure EnsureCaretPos(var X, Y: Integer); override;
    procedure SetText(Value: TCaption); override;
    function  ArrangeText(const S: String): String; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;

    property CanDragSelection default False;
    property CanSelect default False;
    property HotKey: TShortCut read GetHotKey write SetHotKey;
    property InvalidKeys: TSCHKInvalidKeys read FInvalidKeys write SetInvalidKeys default scDefaultInvalidKeys;
    property InsertChangesEditMode default False;
    property Modifiers: TSCHKModifiers read FModifiers write SetModifiers default scDefaultModifiers;
    property RaiseMaskError default False;
    property ReadOnly default True;
    property TabStop default True;
    property UseDefaultMenu default False;
    property UseUndo default False;
    property UndoLimit default 1;
    property OnHotkeyChange: TNotifyEvent read FOnHotkeyChange write FOnHotkeyChange;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    procedure CutToClipboard; override;
    procedure PasteFromClipboard; override;

    property Text;
  end;

  TSCHotkeyEdit = class(TSCCustomHotkeyEdit)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property Checkbox;
    property Color;
    property Colors;
    property Constraints;
    property Description;
    property DescriptionMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HotKey;
    property InvalidKeys;
    property ImageIndex;
    property Images;
    property ImeMode;
    property ImeName;
    property Modifiers;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseCaret;
    property UseImage;
    property Visible;
    property OnCanResize;
    property OnCheckboxChange;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnFocusChanged;
    property OnHotkeyChange;
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

{ TSCCustomHotkeyEdit }

function TSCCustomHotkeyEdit.ArrangeText(const S: String): String;
begin
  Result := inherited ArrangeText(S);
  if Result = '' then Result := scskNone;
  Result := StringReplace(Result, '+', ' + ', [rfReplaceAll]);
end;

procedure TSCCustomHotkeyEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomHotkeyEdit then
  begin
    with TSCCustomHotkeyEdit(Source) do
    begin
      Self.HotKey := HotKey;
      Self.InvalidKeys := InvalidKeys;
      Self.Modifiers := Modifiers;
    end;
  end;
end;

constructor TSCCustomHotkeyEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CanDragSelection := False;
  CanSelect := False;
  InsertChangesEditMode := False;
  RaiseMaskError := False;
  ReadOnly := True;
  TabStop := True;
  UndoLimit := 1;
  UseDefaultMenu := False;
  UseUndo := False;

  FInvalidKeys := scDefaultInvalidKeys;
  FModifiers := scDefaultModifiers;
  FHotModifiers := scDefaultModifiers;
  FHotKey := $0041;     // default - 'Alt+A'

  UpdateHotText;
end;

procedure TSCCustomHotkeyEdit.CutToClipboard;
begin
  CopyToClipboard;
end;

procedure TSCCustomHotkeyEdit.EnsureCaretPos(var X, Y: Integer);
begin
  Y := 0;
  if IsDesigning then
  begin
    X := 0;
    Exit;
  end;

  X := Length(Text);
end;

function TSCCustomHotkeyEdit.GetEditCursor: TCursor;
begin
  Result := crDefault;
end;

function TSCCustomHotkeyEdit.GetHotKey: TShortCut;
var
  Shift: TShiftState;
begin
  Shift := [];

  if schkShift in FHotModifiers then Include(Shift, ssShift);
  if schkCtrl in FHotModifiers then Include(Shift, ssCtrl);
  if schkAlt in FHotModifiers then Include(Shift, ssAlt);

  if (Shift = []) then // and not (schcNone in FInvalidKeys) then
  begin
    if schkShift in FModifiers then Include(Shift, ssShift);
    if schkCtrl in FModifiers then Include(Shift, ssCtrl);
    if schkAlt in FModifiers then Include(Shift, ssAlt);
  end;  

  Result := scShortCut(FHotKey, Shift);
end;

procedure TSCCustomHotkeyEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  K: Word;
begin
  K := Key;
  Key := 0;
  FHotModifiers := [];

  if K in [VK_SHIFT, VK_CONTROL, VK_MENU] then
    K := 0;

  UpdateHotKey(scShortCut(K, Shift));
end;

procedure TSCCustomHotkeyEdit.KeyPress(var Key: Char);
begin
  Key := #0;
  inherited KeyPress(Key);
end;

procedure TSCCustomHotkeyEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  Key := 0;
  if FHotKey = 0 then
  begin
    FHotModifiers := [];
    UpdateHotText;
  end;
end;

procedure TSCCustomHotkeyEdit.Loaded;
begin
  inherited Loaded;
  UpdateHotText;
end;

procedure TSCCustomHotkeyEdit.PasteFromClipboard;
var
  S: String;
begin
  S := Clipboard.AsText;
  if S <> '' then
    SetHotKey(scTextToShortCut(S));
end;

procedure TSCCustomHotkeyEdit.SetHotKey(Value: TShortCut);
var
  Sc: TShortCut;
  M: TSCHKModifiers;
begin
  if IsDesigning and (FHotkeyUpdate = 0) then
  begin
    M := [];

    if Value and scShift <> 0 then Include(M, schkShift);
    if Value and scCtrl <> 0 then Include(M, schkCtrl);
    if Value and scAlt <> 0 then Include(M, schkAlt);
    if schkExt in FModifiers then Include(M, schkExt);

    SetModifiers(M);
  end;

  Sc := GetHotKey;

  ShortCutToHotKey(Value);
  UpdateHotText;

  if Assigned(FOnHotkeyChange) and (Sc <> GetHotKey) then
    FOnHotkeyChange(Self);
end;

procedure TSCCustomHotkeyEdit.SetInvalidKeys(Value: TSCHKInvalidKeys);
begin
  if Value <> FInvalidKeys then
  begin
    FHotModifiers := [];
    FInvalidKeys := Value;
  end;
end;

procedure TSCCustomHotkeyEdit.SetModifiers(Value: TSCHKModifiers);
begin
  if Value <> FModifiers then
  begin
    FHotModifiers := [];
    FModifiers := Value;

    UpdateHotKey(GetHotKey);
  end;
end;

procedure TSCCustomHotkeyEdit.SetText(Value: TCaption);
begin
  if FInternalUpdate > 0 then
  begin
    inherited SetText(Value);
    UpdateCaretPos(Length(Text), 0);
  end;
end;

procedure TSCCustomHotkeyEdit.ShortCutToHotKey(Value: TShortCut);
var
  M: TSCHKModifiers;
begin
  FHotKey := Value and not (scShift + scCtrl + scAlt);
  FHotModifiers := [];

  if Value and scShift <> 0 then Include(FHotModifiers, schkShift);
  if Value and scCtrl <> 0 then Include(FHotModifiers, schkCtrl);
  if Value and scAlt <> 0 then Include(FHotModifiers, schkAlt);

  M := FHotModifiers;

  if (schcShiftCtrlAlt in FInvalidKeys) and (FHotModifiers = [schkShift, schkCtrl, schkAlt]) then
    FHotModifiers := [];

  if (schcCtrlAlt in FInvalidKeys) and (FHotModifiers = [schkCtrl, schkAlt]) then
    FHotModifiers := [];

  if (schcShiftAlt in FInvalidKeys) and (FHotModifiers = [schkShift, schkAlt]) then
    FHotModifiers := [];

  if (schcShiftCtrl in FInvalidKeys) and (FHotModifiers = [schkShift, schkCtrl]) then
    FHotModifiers := [];

  if (schcAlt in FInvalidKeys) and (FHotModifiers = [schkAlt]) then
    FHotModifiers := [];

  if (schcCtrl in FInvalidKeys) and (FHotModifiers = [schkCtrl]) then
    FHotModifiers := [];

  if (schcShift in FInvalidKeys) and (FHotModifiers = [schkShift]) then
    FHotModifiers := [];

  if (schcNone in FInvalidKeys) and (FHotModifiers = []) then
    FHotModifiers := [];

  if (FHotModifiers = []) then // and not (schcNone in FInvalidKeys) then
  begin
    if schkShift in FModifiers then Include(FHotModifiers, schkShift);
    if schkCtrl in FModifiers then Include(FHotModifiers, schkCtrl);
    if schkAlt in FModifiers then Include(FHotModifiers, schkAlt);
  end;
end;

procedure TSCCustomHotkeyEdit.UpdateHotKey(Value: TShortCut);
begin
  if FHotkeyUpdate = 0 then
  begin
    Inc(FHotkeyUpdate);
    try
      SetHotKey(Value);
    finally
      Dec(FHotkeyUpdate);
    end;
  end;
end;

procedure TSCCustomHotkeyEdit.UpdateHotText;
var
  S: String;
begin
  Inc(FInternalUpdate);
  try
    if FHotKey <> 0 then
      S := scShortCutToText(GetHotKey)
    else begin
      if schkCtrl in FHotModifiers then S := S + scskCtrl;
      if schkShift in FHotModifiers then S := S + scskShift;
      if schkAlt in FHotModifiers then S := S + scskAlt;
    end;

    SetText(S);
  finally
    Dec(FInternalUpdate);
  end;
end;

procedure TSCCustomHotkeyEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTALLKEYS;
end;

{$I SCVerRec.inc}

end.