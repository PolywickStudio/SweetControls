{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCMaskEdit;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCConsts, SCResStrs, SCCommon, SCControl, SCEdits, ImgList, Clipbrd;

type
  TSCMaskType = (scmtNone, scmtLiteral, scmtAnyChar, scmtAnyCharOpt,
    scmtAlpha, scmtAlphaOpt, scmtAlphaNumber, scmtAlphaNumberOpt,
    scmtNumeric, scmtNumericOpt, scmtNumericOrSignOpt, scmtDateSeparator,
    scmtTimeSeparator, scmtFieldSeparator, scmtReverse, scmtUpperCase,
    scmtLowerCase);

  TSCMaskCase = (scmcAny, scmcUpperCase, scmcLowerCase);

  ESCMaskEditError = class(Exception);

  TSCMaskSheme = record
    MaskType: TSCMaskType;
    MaskCase: TSCMaskCase;
    Literal : Char;
    LeadingBlanks: Boolean;
  end;
  PSCMaskSheme = ^TSCMaskSheme;

  TSCCustomMaskEdit = class(TSCCustomEdit)
  private
    FEditMask: String;
    FShemeList: TList;
    FInUndo: Boolean;
    FSettingMask: Integer;
    FRaiseMaskError: Boolean;
    function  GetBlankChar: Char;
    procedure SetBlankChar(Value: Char);
    procedure SetEditMask(const Value: String);
    function  GetMasked: Boolean;
    function  GetSaveLiterals: Boolean;
    procedure SetSaveLiterals(Value: Boolean);
    function  GetSettingMask: Boolean;
    procedure SwitchPos(var P1, P2: Integer);
    procedure CMWantSpecialKey(var Message: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure SetText(Value: TCaption); override;
    procedure SetMaxLength(Value: Integer); override;

    function  AllowSelectionDrag: Boolean; override;

    procedure CheckKeyDown(var Key: Word; Shift: TShiftState); dynamic;
    procedure SetCursorPos(Pt: Integer; Prev: Boolean = False); dynamic;
    procedure DoArrowMove(var Key: Word; Shift: TShiftState); dynamic;

    procedure DeleteChar(Prev: Boolean); override;
    procedure DeleteText(Prev: Boolean); override;
    procedure InsertChar(Ch: Char); override;
    procedure OverwriteChar(Ch: Char); override;
    procedure InsertText(AText: String); override;

    function  AutoCompleteText: String; override;
    procedure Reset; virtual;

    procedure ValidateEdit; override;
    function  CanRaiseMaskError: Boolean; virtual;

    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function  FocusInvalidChar: Boolean;
    procedure ValidateError; virtual;

    procedure MaskChanged; dynamic;
    function  IsMaskStored: Boolean; virtual;

    property AutoComplete default False;
    property HideSelection default True;
    property EditMask: String read FEditMask write SetEditMask stored IsMaskStored;
    property BlankChar: Char read GetBlankChar write SetBlankChar;
    property SaveLiterals: Boolean read GetSaveLiterals write SetSaveLiterals;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Undo; override;
    procedure Redo; override;

    procedure ClearSelection; override;
    function  ShemeCount: Integer;
    function  GetSheme(Index: Integer): TSCMaskSheme;

    function  ConvertToValidChar(C: Char; Index: Integer): Char;
    function  IsValidText(S: string; AcceptBlank: Boolean = True): Boolean;
    function  IsValidChar(C: Char; Index: Integer; AcceptBlank: Boolean = True): Boolean;

    property IsMasked: Boolean read GetMasked;
    property Text;
    property RaiseMaskError: Boolean read FRaiseMaskError write FRaiseMaskError default True;
    property SettingMask: Boolean read GetSettingMask;
  end;

  TSCMaskEdit = class(TSCCustomMaskEdit)
  public
    property CaretPos;
    property SelLength;
    property SelStart;
    property SelText;
    property BlankChar;
    property SaveLiterals;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderProps;
    property CanSelect;
    property CharCase;
    property Checkbox;
    property Color;
    property Constraints;
    property Description;
    property DescriptionColor;
    property DescriptionMode;
    property DisabledColor;
    property DisabledTextColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EditCursor;
    property EditMask;
    property Enabled;
    property EnterAsTab;
    property FocusColor;
    property FocusTextColor;
    property Font;
    property HideSelection;
    property HideSelectionColor;
    property HideSelectionTextColor;
    property HighlightColor;
    property HighlightTextColor;
    property ImageIndex;
    property Images;
    property ImeMode;
    property ImeName;
    property LineSpace;
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
    property PictureOrient;
    property PictureIndent;
    property PictureTopIndent;
    property PictureTransparent;
    property PopupMenu;
    property RaiseMaskError;
    property ReadOnly;
    property ShowHint;
    property ShowPicture;
    property TabOrder;
    property TabStop;
    property Text;
    property Transparent;
    property UseCaret;
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

  TSCShemeList = class(TList)
  private
    FMask: String;
    FMaskText: String;
    FBlankChar: Char;
    FSaveLiterals: Boolean;
    procedure SetBlankChar(const Value: Char);
    procedure SetMask(const Value: String);
    function  GetSheme(Index: Integer): PSCMaskSheme;
    procedure SetSaveLiterals(Value: Boolean);

    function  AddSheme: PSCMaskSheme;
    procedure RefreshMask;
    function  CheckSaveLiteralsAndBlankChar(const S: string;
      var DoSaveLiterals: Boolean; var ABlankChar: Char): string;
    procedure ResetSheme(P: PSCMaskSheme);
    function  ShemeToMaskText: string;
  public
    constructor Create; virtual;
    procedure Clear; override;

    function  ConvertToValidChar(C: Char; ShemePos: Integer): Char;
    function  IsValidText(S: string; AcceptBlank: Boolean = True): Boolean;
    function  IsValidChar(C: Char; ShemePos: Integer; AcceptBlank: Boolean = True): Boolean;
    function  MaskTypeToStr(M: TSCMaskType; C: Char): string;
    function  CharToMaskType(C: Char): TSCMaskType;

    function  MaskLength: Integer;
    function  ArrangeMaskedText(S: string): string;
    function  ApplyMaskToText(S: string): string;
    function  GetEditMask(DefBlank: Boolean): string;

    property BlankChar: Char read FBlankChar write SetBlankChar;
    property Mask: string read FMask write SetMask;
    property MaskText: string read FMaskText;
    property Sheme[Index: Integer]: PSCMaskSheme read GetSheme;
    property SaveLiterals: Boolean read FSaveLiterals write SetSaveLiterals;
  end;
  
const
  scMskDefaultBlank = '_';
  scMskFieldSeparator = ';';
  scMskLitNoSave = '0';

  scMskReverse = '!';         { removes leading blanks if true, else trailing blanks}
  scMskUpperCase = '>';       { all chars that follow to upper case }
  scMskLowerCase = '<';       { all chars that follow to lower case }
                              { '<>' means remove casing directive }
  scMskLiteral = '\';         { char that immediately follows is a literal }

  scMskAlpha = 'L';           { in US = A-Z,a-z }
  scMskAlphaOpt = 'l';
  scMskAlphaNum = 'A';        { in US = A-Z,a-z,0-9 }
  scMskAlphaNumOpt  = 'a';
  scMskAscii = 'C';           { any character}
  scMskAsciiOpt = 'c';
  scMskNumeric = '0';         { 0-9, no plus or minus }
  scMskNumericOpt = '9';
  scMskNumOrSign = '#';       { 0-9, plus and minus }

   { intl literals }
  scMskTimeSeparator = ':';
  scMskDateSeparator = '/';

implementation

{ TSCShemeList }

function TSCShemeList.AddSheme: PSCMaskSheme;
begin
  New(Result);
  Add(Result);

  ResetSheme(Result);
end;

function TSCShemeList.ArrangeMaskedText(S: string): string;
var
  C: Char;
  I: Integer;
begin
  if Count = 0 then
    Result := S
  else begin
    if S = '' then
    begin
      Result := FMaskText;
      Exit;
    end;

    Result := '';
    for I := 0 to Count - 1 do
    begin
      C := #0;
      if I + 1 <= Length(S) then
        C := S[I + 1];

      Result := Result + ConvertToValidChar(C, I);
    end;
  end;
end;

function TSCShemeList.CharToMaskType(C: Char): TSCMaskType;
begin
  Result := scmtNone;
  if C = scMskFieldSeparator then // ';'
    Result := scmtFieldSeparator
  else if C = scMskReverse then  // '!'
    Result := scmtReverse
  else if C = scMskUpperCase then  // '>'
    Result := scmtUpperCase
  else if C = scMskLowerCase then  // '<'
    Result := scmtLowerCase
  else if C = scMskLiteral then  // '\'
    Result := scmtLiteral
  else if C = scMskAlpha then  // 'L'
    Result := scmtAlpha
  else if C = scMskAlphaOpt then  // 'l'
    Result := scmtAlphaOpt
  else if C = scMskAlphaNum then  // 'A'
    Result := scmtAlphaNumber
  else if C = scMskAlphaNumOpt then  // 'a'
    Result := scmtAlphaNumberOpt
  else if C = scMskAscii then  // 'C'
    Result := scmtAnyChar
  else if C = scMskAsciiOpt then  // 'c'
    Result := scmtAnyCharOpt
  else if C = scMskNumeric then  // '0'
    Result := scmtNumeric
  else if C = scMskNumericOpt then  // '9'
    Result := scmtNumericOpt
  else if C = scMskNumOrSign then  // '#'
    Result := scmtNumericOrSignOpt
  else if C = scMskTimeSeparator then  // ':'
    Result := scmtTimeSeparator
  else if C = scMskDateSeparator then  // ':'
    Result := scmtDateSeparator;
end;

procedure TSCShemeList.Clear;
var
  I: Integer;
  P: PSCMaskSheme;
begin
  for I := 0 to Count-1 do
  begin
    P := Items[I];
    Dispose(P);
  end;

  inherited Clear;
end;

constructor TSCShemeList.Create;
begin
  inherited Create;
  FBlankChar := scMskDefaultBlank;
  FSaveLiterals := True;
  FMaskText := '';
end;

function TSCShemeList.CheckSaveLiteralsAndBlankChar(const S: string;
  var DoSaveLiterals: Boolean; var ABlankChar: Char): string;
var
  I: Integer;
  BlankPos, LitPos: Integer;
begin
  ABlankChar := scMskDefaultBlank;
  DoSaveLiterals := True;

  Result := S;

  if Length(Result) >= 4 then
  begin
    BlankPos := -1;
    LitPos   := -1;

    I := Length(Result);
    while I > 0 do
    begin
      if CharToMaskType(Result[I]) = scmtFieldSeparator then
      begin
        if BlankPos < 0 then
          BlankPos := I
        else
          LitPos := I;
      end;

      Dec(I);
    end;

    if LitPos < 0 then
    begin
      LitPos  := BlankPos;
      BlankPos := -1;
    end;

    if LitPos > 0 then
    begin
      DoSaveLiterals := not ((LitPos < Length(Result)) and
        (Result[LitPos + 1] = scMskLitNoSave));

      System.Delete(Result, LitPos, 2);
      Dec(BlankPos, 2);

      if (BlankPos > 0) and (BlankPos <= Length(Result)) then
      begin
        ABlankChar := #0;
        if BlankPos < Length(Result) then
          ABlankChar := Result[BlankPos + 1];

        if ABlankChar = #0 then
          ABlankChar := scMskDefaultBlank;

        System.Delete(Result, BlankPos, 2);
      end;
    end;
  end;
end;

function TSCShemeList.GetSheme(Index: Integer): PSCMaskSheme;
begin
  Result := nil;
  if (Index > -1) and (Index < Count) then
    Result := Items[Index];
end;

function TSCShemeList.MaskLength: Integer;
begin
  Result := Length(FMaskText);
end;

procedure TSCShemeList.ResetSheme(P: PSCMaskSheme);
begin
  if P <> nil then
  begin
    P^.MaskType := scmtNone;
    P^.MaskCase := scmcAny;
    P^.Literal  := #0;
    P^.LeadingBlanks := False;
  end;
end;

procedure TSCShemeList.SetBlankChar(const Value: Char);
begin
  FBlankChar := Value;
  RefreshMask;
end;

procedure TSCShemeList.SetMask(const Value: String);
var
  I: Integer;
  P: PSCMaskSheme;
  S: String;
  LeadingBlanks: Boolean;
  OldMask, MaskType: TSCMaskType;
  MaskCase: TSCMaskCase;
begin
  if Value = FMask then
    Exit;

  FMask := Value;
  Clear;

  FMaskText  := '';
  FBlankChar := scMskDefaultBlank;
  FSaveLiterals := True;

  if Value = '' then
    Exit;

  S := CheckSaveLiteralsAndBlankChar(Value, FSaveLiterals, FBlankChar);

  LeadingBlanks := False;
  MaskType := scmtNone;
  MaskCase := scmcAny;

  P := nil;
  I := 0;

  while I < Length(S) do
  begin
    Inc(I);

    if MaskType = scmtLiteral then
    begin
      MaskType := scmtNone;

      P := AddSheme;

      P^.MaskType := scmtLiteral;
      P^.MaskCase := MaskCase;
      P^.Literal  := S[I];
      P^.LeadingBlanks := LeadingBlanks;

      LeadingBlanks:= False;

      Continue;
    end;

    OldMask  := MaskType;
    MaskType := CharToMaskType(S[I]);

    case MaskType of
      scmtReverse:  // '!'
      begin
        LeadingBlanks := True;
      end;
      scmtUpperCase: // '>'
      begin
        MaskCase := scmcUpperCase;
        if OldMask = scmtLowerCase then
          MaskCase := scmcAny;
      end;
      scmtLowerCase: // '<'
      begin
        MaskCase := scmcLowerCase;
      end;
      scmtLiteral: // '\'
      begin
        MaskType := scmtNone;
        if (P = nil) or (P^.MaskType <> scmtLiteral) or
          (P^.Literal <> scMskLiteral) then
          MaskType := scmtLiteral;
      end;
      else begin
        P := AddSheme;

        P^.MaskType := MaskType;
        P^.MaskCase := MaskCase;
        P^.LeadingBlanks := LeadingBlanks;

        LeadingBlanks:= False;

        if MaskType in [scmtNone, scmtFieldSeparator] then
          P^.Literal  := S[I]
        else if MaskType = scmtDateSeparator then
          P^.Literal  := {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DateSeparator
        else if MaskType = scmtTimeSeparator then
          P^.Literal  := {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}TimeSeparator;
      end;
    end;
  end;

  FMaskText := ShemeToMaskText;
end;

procedure TSCShemeList.SetSaveLiterals(Value: Boolean);
begin
  FSaveLiterals := Value;
  RefreshMask;
end;

procedure TSCShemeList.RefreshMask;
var
  Bc: Char;
  Sl: Boolean;
begin
  FMask := CheckSaveLiteralsAndBlankChar(FMask, Sl, Bc);

  FMask := FMask + ';' + IntToStr(Integer(FSaveLiterals));
  if FBlankChar <> #0 then
    FMask := FMask + ';' + FBlankChar;
end;

function TSCShemeList.ShemeToMaskText: string;
var
  I: Integer;
  P: PSCMaskSheme;
  C, Blank: Char;
begin
  Result := '';

  Blank := BlankChar;
  for I := 0 to Count-1 do
  begin
    P := Items[I];

    C := #0;
    if P^.MaskType in [scmtNone, scmtFieldSeparator,
      scmtLiteral, scmtDateSeparator, scmtTimeSeparator] then
      C := P^.Literal;

    if C = #0 then
      C := Blank;

    Result := Result + C;
  end;
end;

function TSCShemeList.IsValidChar(C: Char; ShemePos: Integer;
  AcceptBlank: Boolean): Boolean;
var
  P: PSCMaskSheme;
begin
  Result := False;
  if (ShemePos > -1) and (ShemePos < Count) then
  begin
    P := Items[ShemePos];

    case P^.MaskType of
      scmtNone, scmtLiteral:
        Result := C = P^.Literal;
      scmtAlpha, scmtAlphaOpt:
        Result := (AcceptBlank and (C = BlankChar)) or
          (C in ['A'..'Z']) or (C in ['a'..'z']);
      scmtAlphaNumber, scmtAlphaNumberOpt:
        Result := (AcceptBlank and (C = BlankChar)) or
          (C in ['A'..'Z']) or (C in ['a'..'z']) or (C in ['0'..'9']);
      scmtNumeric, scmtNumericOpt:
        Result := (AcceptBlank and (C = BlankChar)) or
          (C in ['0'..'9']);
      scmtNumericOrSignOpt:
        Result := (AcceptBlank and (C = BlankChar)) or
          (C = '-') or (C = '+') or (C in ['0'..'9']);
      scmtDateSeparator:
        Result := C = {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DateSeparator;
      scmtTimeSeparator:
        Result := C = {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}TimeSeparator;
    end;
  end;
end;

function TSCShemeList.ConvertToValidChar(C: Char; ShemePos: Integer): Char;
var
  P: PSCMaskSheme;
begin
  Result := #0;
  if (ShemePos > -1) and (ShemePos < Count) then
  begin
    P := Items[ShemePos];

    Result := C;

    case P^.MaskType of
      scmtNone, scmtLiteral:
        Result := P^.Literal;
      scmtFieldSeparator:
        Result := scMskFieldSeparator;
      scmtAlpha, scmtAlphaOpt:
      if not ((C = BlankChar) or (C in ['A'..'Z']) or (C in ['a'..'z'])) then
        Result := #0;
      scmtAlphaNumber, scmtAlphaNumberOpt:
      if not ((C = BlankChar) or (C in ['A'..'Z']) or (C in ['a'..'z']) or (C in ['0'..'9'])) then
        Result := #0;
      scmtNumeric, scmtNumericOpt:
      if not ((C = BlankChar) or (C in ['0'..'9'])) then
        Result := #0;
      scmtNumericOrSignOpt:
      if not ((C = BlankChar) or (C = '-') or (C = '+') or (C in ['0'..'9'])) then
        Result := #0;
      scmtDateSeparator:
        Result := {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}DateSeparator;
      scmtTimeSeparator:
        Result := {$IFDEF SC_DELPHI10_0_UP}FormatSettings.{$ENDIF}TimeSeparator;
    end;

    if Result = #0 then
      Result := BlankChar;

    if P^.MaskCase = scmcUpperCase then
      Result := UpCase(Result)
    else if (P^.MaskCase = scmcLowerCase) and
      (Result >= 'A') and (Result <= 'Z') then
      Result := Char(Ord(Result) + 32);
  end;
end;

function TSCShemeList.IsValidText(S: string; AcceptBlank: Boolean): Boolean;
var
  I: Integer;
begin
  Result := False;

  if (S = '') or (Count = 0) then
    Result := True
  else
  if Length(S) = Count then
  begin
    if S <> FMaskText then
      for I := 0 to Count-1 do
        if not IsValidChar(S[I + 1], I, AcceptBlank) then
          Exit;

    Result := True;
  end;
end;

function TSCShemeList.GetEditMask(DefBlank: Boolean): string;
var
  I: Integer;
  P: PSCMaskSheme;
begin
  Result := '';
  for I := 0 to Count-1 do
  begin
    P := Items[I];
    if P^.LeadingBlanks then
      Result := Result + '!';

    Result := Result + MaskTypeToStr(P^.MaskType, P^.Literal);
  end;

  if FSaveLiterals then
    Result := Result + ';1'
  else if (FBlankChar <> #0) or DefBlank then
    Result := Result + ';0';

  if FBlankChar <> #0 then
    Result := Result + ';' + FBlankChar
  else if DefBlank then
    Result := Result + ';' + scMskDefaultBlank;
end;

function TSCShemeList.MaskTypeToStr(M: TSCMaskType; C: Char): string;
begin
  Result := C;
  if M = scmtFieldSeparator then // ';'
    Result := scMskFieldSeparator
  else if M = scmtReverse then  // '!'
    Result := scMskReverse
  else if M = scmtUpperCase then  // '>'
    Result := scMskUpperCase
  else if M = scmtLowerCase then  // '<'
    Result := scMskLowerCase
  else if M = scmtLiteral then  // '\'
    Result := scMskLiteral + C
  else if M = scmtAlpha then  // 'L'
    Result := scMskAlpha
  else if M = scmtAlphaOpt then  // 'l'
    Result := scMskAlphaOpt
  else if M = scmtAlphaNumber then  // 'A'
    Result := scMskAlphaNum
  else if M = scmtAlphaNumberOpt then  // 'a'
    Result := scMskAlphaNumOpt
  else if M = scmtAnyChar then  // 'C'
    Result := scMskAscii
  else if M = scmtAnyCharOpt then  // 'c'
    Result := scMskAsciiOpt
  else if M = scmtNumeric then  // '0'
    Result := scMskNumeric
  else if M = scmtNumericOpt then  // '9'
    Result := scMskNumericOpt
  else if M = scmtNumericOrSignOpt then  // '#'
    Result := scMskNumOrSign
  else if M = scmtTimeSeparator then  // ':'
    Result := scMskTimeSeparator
  else if M = scmtDateSeparator then  // ':'
    Result := scMskDateSeparator;
end;

function TSCShemeList.ApplyMaskToText(S: string): string;
var
  C: Char;
  I, J: Integer;
  P: PSCMaskSheme;
begin
  Result := '';

  I := 0; J := 1;
  while I < Count do
  begin
    P := Items[I];
    Inc(I);

    C := #0;
    if P^.MaskType in [scmtNone, scmtFieldSeparator,
      scmtLiteral, scmtDateSeparator, scmtTimeSeparator] then
      C := P^.Literal;

    if (C = #0) and (J <= Length(S)) then
    begin
      C := S[J];
      Inc(J);
    end;

    if C <> #0 then
      Result := Result + C;
  end;
end;

{ TSCCustomMaskEdit }

function TSCCustomMaskEdit.AllowSelectionDrag: Boolean;
begin
  Result := FEditMask = '';
end;

procedure TSCCustomMaskEdit.Assign(Source: TPersistent);
begin
  if Source is TSCCustomMaskEdit then
  begin
    with TSCCustomMaskEdit(Source) do
    begin
      Self.EditMask := EditMask;
    end;
  end;
  inherited Assign(Source);
end;

function TSCCustomMaskEdit.AutoCompleteText: String;
begin
  Result := '';
end;

function TSCCustomMaskEdit.CanRaiseMaskError: Boolean;
begin
  Result := True;
end;

procedure TSCCustomMaskEdit.CheckKeyDown(var Key: Word;
  Shift: TShiftState);
begin
  if IsMasked and (Key <> 0) then
  begin
    //
  end;
end;

procedure TSCCustomMaskEdit.ClearSelection;
var
  S: String;
  C, Blank: Char;
  P: PSCMaskSheme;
  I, Start, Stop: Integer;
begin
  if FInUndo or not IsMasked then
    inherited ClearSelection
  else
  if HasSelection then
  begin
    Stop  := CaretPos.x;
    Start := SelStart.x;

    if Start > Stop then
      SwitchPos(Start, Stop);

    S := '';
    Blank := TSCShemeList(FShemeList).BlankChar;

    if Stop > FShemeList.Count-1 then
      Stop := FShemeList.Count-1;

    for I := Start to Stop do
    begin
      C := Blank;

      P := TSCShemeList(FShemeList).GetSheme(I);
      if (P <> nil) and (P^.Literal <> #0) and
        (P^.MaskType in [scmtNone, scmtLiteral,
        scmtFieldSeparator, scmtDateSeparator, scmtTimeSeparator]) then
        C := P^.Literal;

      S := S + C;  
    end;

    CatchUndo;
    try
      inherited ClearSelection;

      inherited InsertText(S);
      SetCursorPos(Start);
    finally
      ReleaseUndoCatch;
    end;
  end;
end;

procedure TSCCustomMaskEdit.CMWantSpecialKey(var Message: TCMWantSpecialKey);
begin
  inherited;
  if (Message.CharCode = VK_ESCAPE) and IsMasked and Modified then
    Message.Result := 1;
end;

function TSCCustomMaskEdit.ConvertToValidChar(C: Char; Index: Integer): Char;
begin
  Result := C;
  if IsMasked then
    Result := TSCShemeList(FShemeList).ConvertToValidChar(C, Index);
end;

constructor TSCCustomMaskEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoComplete := False;
  FShemeList := TSCShemeList.Create;
  HideSelection := True;
  FRaiseMaskError := True;
end;

procedure TSCCustomMaskEdit.DeleteChar(Prev: Boolean);
var
  C: Char;
  P: PSCMaskSheme;
  SelLen, Start, Stop: Integer;
begin
  if ReadOnly then
    Exit;

  SelLen := SelLength;

  if FInUndo or not IsMasked or (SelLen > 1) then
    inherited DeleteChar(Prev)
  else begin
    Start := SelStart.X;
    Stop  := CaretPos.X;

    if Start > Stop then
      SwitchPos(Start, Stop);

    if (SelLen = 0) and (Prev and (Start = 0)) or
      ((Start = MaxLength) and not Prev) then
      Exit;

    if Prev and (SelLen = 0) then
      Dec(Start);

    with TSCShemeList(FShemeList) do
    begin
      C := BlankChar;
      P := Items[Start];
    end;

    if (P <> nil) and (P^.Literal <> #0) and
      (P^.MaskType in [scmtNone, scmtLiteral,
       scmtFieldSeparator, scmtDateSeparator, scmtTimeSeparator]) then
      C := P^.Literal;

    CatchUndo;
    try
      inherited DeleteChar(Prev);

      if SelLen = 0 then
        inherited InsertChar(C)
      else
      if Prev then
        Dec(Start);

      SetCursorPos(Start, Prev);
    finally
      ReleaseUndoCatch;
    end;
  end;
end;

procedure TSCCustomMaskEdit.DeleteText(Prev: Boolean);
begin
  if not (SettingMask or IsMasked) then
    inherited DeleteText(Prev)
  else
    DeleteChar(Prev);
end;

destructor TSCCustomMaskEdit.Destroy;
begin
  FShemeList.Free;
  inherited Destroy;
end;

procedure TSCCustomMaskEdit.DoArrowMove(var Key: Word; Shift: TShiftState);
var
  P: PSCMaskSheme;
  Start, Stop: Integer;
begin
  if IsMasked and (Key <> 0) and not (ssAlt in Shift) then
  begin
    Stop  := CaretPos.X;
    Start := SelStart.X;

    case Key of
      VK_LEFT, VK_RIGHT:
      begin
        if Stop = MaxLength then
        begin
          if Start = Stop - 1 then
          begin
            P := TSCShemeList(FShemeList).Items[Start];
            if (P <> nil) and (P^.Literal <> #0) and
              (P^.MaskType in [scmtNone, scmtLiteral,
              scmtFieldSeparator, scmtDateSeparator, scmtTimeSeparator]) then
              Inc(Start);
          end;
        end else
        if Start = Stop then
        begin
          if Key = VK_LEFT then
          begin
            if not (ssShift in Shift) then
            begin
              while (Start > -1) and (Start < FShemeList.Count) do
              begin
                P := TSCShemeList(FShemeList).Items[Start];

                if (P <> nil) and (P^.Literal <> #0) and (P^.MaskType in
                  [scmtNone, scmtLiteral, scmtFieldSeparator,
                   scmtDateSeparator, scmtTimeSeparator]) then
                begin
                  Dec(Start);
                  Continue;
                end;

                Break;
              end;

              if Start < 0 then
              begin
                Start := 0;
                while Start < FShemeList.Count  do
                begin
                  P := TSCShemeList(FShemeList).Items[Start];

                  if (P <> nil) and (P^.Literal <> #0) and (P^.MaskType in
                    [scmtNone, scmtLiteral, scmtFieldSeparator,
                     scmtDateSeparator, scmtTimeSeparator]) then
                  begin
                    Inc(Start);
                    Continue;
                  end;

                  Break;
                end;

                Stop := Start;
              end;
            end;

            if (Stop = CaretPos.X) and (ssShift in Shift) then
            begin
              Dec(Stop);
              Start := Stop + 2;
            end else
            begin
              if not (ssShift in Shift) and (Stop > Start) and
                ((Start = 0) or (Start = -1)) then
                Start := Stop + 1;

              SwitchPos(Start, Stop);
              Start := Stop + 1;
            end;
          end else
          begin
            if ssShift in Shift then
            begin
              if Start = Stop then
                Dec(Start)
              else
              if Start > Stop then
                SwitchPos(Start, Stop);

              Inc(Stop);
            end else
            begin
              while Stop < FShemeList.Count do
              begin
                P := TSCShemeList(FShemeList).Items[Stop];

                if (P <> nil) and (P^.Literal <> #0) and (P^.MaskType in
                  [scmtNone, scmtLiteral, scmtFieldSeparator,
                   scmtDateSeparator, scmtTimeSeparator]) then
                begin
                  Inc(Stop);
                  Continue;
                end;

                Break;
              end;

              Start := Stop + 1;
            end;
          end;
        end;

        Key := 0;
        SetSelRect(Rect(Start, 0, Stop, 0));

        Exit;
      end;
      VK_UP, VK_DOWN:
      begin
        Key := 0;
        Exit;
      end;
      VK_HOME, VK_END:
      begin
        if (Key = VK_HOME) and not (ssShift in Shift) then
        begin
          Stop  := 0;
          Start := 1;

          if FShemeList.Count > 0 then
          begin
            P := TSCShemeList(FShemeList).Items[0];

            if (P <> nil) and (P^.Literal <> #0) and (P^.MaskType in
              [scmtNone, scmtLiteral, scmtFieldSeparator,
               scmtDateSeparator, scmtTimeSeparator]) then
              Dec(Start);
          end;    
        end;

        Key := 0;
        SetSelRect(Rect(Start, 0, Stop, 0));

        Exit;
      end;
    end;
  end;
end;

function TSCCustomMaskEdit.FocusInvalidChar: Boolean;
var
  I: Integer;
begin
  Result := False;
  if IsMasked and not IsDesigning then
    for I := 1 to Length(Text) do
      if not IsValidChar(Text[I], I - 1, False) then
      begin
        Result := True;

        SetCursorPos(I - 1);
        Exit;
      end;
end;

function TSCCustomMaskEdit.GetBlankChar: Char;
begin
  Result := #0;
  if IsMasked then
    Result := TSCShemeList(FShemeList).BlankChar;
end;

function TSCCustomMaskEdit.GetMasked: Boolean;
begin
  Result := FEditMask <> '';
end;

function TSCCustomMaskEdit.GetSaveLiterals: Boolean;
begin
  Result := False;
  if IsMasked then
    Result := TSCShemeList(FShemeList).SaveLiterals;
end;

function TSCCustomMaskEdit.GetSettingMask: Boolean;
begin
  Result := FSettingMask > 0;
end;

function TSCCustomMaskEdit.GetSheme(Index: Integer): TSCMaskSheme;
var
  P: PSCMaskSheme;
begin
  TSCShemeList(FShemeList).ResetSheme(@Result);

  if IsMasked then
  begin
    P := TSCShemeList(FShemeList).GetSheme(Index);

    if P <> nil then
    begin
      Result.MaskType := P^.MaskType;
      Result.MaskCase := P^.MaskCase;
      Result.Literal  := P^.Literal;
      Result.LeadingBlanks := P^.LeadingBlanks;
    end;
  end;
end;

procedure TSCCustomMaskEdit.InsertChar(Ch: Char);
var
  C: Char;
  S: String;
  I, Start, Stop: Integer;
begin
  if ReadOnly or not IsValidKey(Ch) then
    Exit;

  if FInUndo or not IsMasked then
    inherited InsertChar(Ch)
  else
  if HasSelection then
  begin
    Stop  := CaretPos.x;
    Start := SelStart.x;

    if Start > Stop then
      SwitchPos(Start, Stop);

    if (Start + 1 <= Length(Text)) and not IsValidChar(Ch, Start) then
    begin
      MessageBeep(0);
      Exit;
    end;

    CatchUndo;
    try
      Ch := ConvertToValidChar(Ch, Start);

      if Stop - Start > 1 then
      begin
        S := Text;
        
        S[Start + 1] := Ch;
        for I := Start + 2 to Stop do
          S[I] := TSCShemeList(FShemeList).BlankChar;

        SetText(TSCShemeList(FShemeList).ArrangeMaskedText(S));
      end else
      begin
        inherited InsertChar(Ch);
        SetText(Text);
      end;

      Inc(Start);

      Ch := UpCase(Ch);
      if Start <= Length(Text) then
      begin
        C := Text[Start];

        if not ((C = Ch) or (C = Char(Ord(Ch) + 32))) then
        begin
          MessageBeep(0);
          Dec(Start);
        end;
      end;

      SetCursorPos(Start);
    finally
      ReleaseUndoCatch;
    end;
  end;
end;

procedure TSCCustomMaskEdit.InsertText(AText: String);
var
  Ch: Char;
  S: String;
  I, Ln, Start, Stop: Integer;
begin
  if ReadOnly then
    Exit;

  if FInUndo or not IsMasked then
    inherited InsertText(AText)
  else
  if HasSelection then
  begin
    Stop  := CaretPos.x;
    Start := SelStart.x;

    if Start > Stop then
      SwitchPos(Start, Stop);

    CatchUndo;
    try
      if Stop - Start > 1 then
      begin
        S := Text;

        Ln := Length(AText);

        if Ln < Stop - Start then
        begin
          Ch := TSCShemeList(FShemeList).BlankChar;
          
          Ln := (Stop - Start) - Ln;
          for I := 0 to Ln - 1 do
            AText := AText + Ch;
        end;

        Delete(S, Start + 1, Stop - Start);
        Insert(AText, S, Start + 1);

        SetText(TSCShemeList(FShemeList).ArrangeMaskedText(S));
      end else
      begin
        AText[1] := ConvertToValidChar(AText[1], Start);

        inherited InsertText(AText);
        SetText(Text);
      end;

      SetCursorPos(Start + Length(AText) + 1);
    finally
      ReleaseUndoCatch;
    end;
  end;
end;

function TSCCustomMaskEdit.IsMaskStored: Boolean;
begin
  Result := FEditMask <> '';
end;

function TSCCustomMaskEdit.IsValidChar(C: Char; Index: Integer;
  AcceptBlank: Boolean): Boolean;
begin
  Result := True;
  if IsMasked then
    Result := TSCShemeList(FShemeList).IsValidChar(C, Index, AcceptBlank);
end;

function TSCCustomMaskEdit.IsValidText(S: string; AcceptBlank: Boolean): Boolean;
begin
  Result := True;
  if IsMasked then
    Result := TSCShemeList(FShemeList).IsValidText(S, AcceptBlank);
end;

procedure TSCCustomMaskEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  CheckKeyDown(Key, Shift);
  inherited KeyDown(Key, Shift);

  if IsMasked and (Key <> 0) and not (ssCtrl in Shift) then
  begin
    DoArrowMove(Key, Shift);
    if Key = 0 then
      Exit;
  end;    
end;

procedure TSCCustomMaskEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);

  if IsMasked and (Word(Key) = VK_ESCAPE) then
  begin
    Key := #0;
    Reset;
  end;
end;

procedure TSCCustomMaskEdit.MaskChanged;
begin
  //
end;

procedure TSCCustomMaskEdit.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Start, Stop: Integer;
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Ismasked then
  begin
    Start := CaretPos.X;
    Stop  := SelStart.X;

    if Start = Stop then
    begin
      if Start < MaxLength then
        SetCursorPos(CaretPos.X);
    end else
    if Abs(Start - Stop) = 1 then
    begin
      if Stop < Start then
        Start := Stop;

      SetCursorPos(Start);
    end;
  end;
end;

procedure TSCCustomMaskEdit.OverwriteChar(Ch: Char);
var
  C: Char;
  S: String;
  I, Start, Stop: Integer;
begin
  if ReadOnly or not IsValidKey(Ch) then
    Exit;

  if FInUndo or not IsMasked then
    inherited OverwriteChar(Ch)
  else
  if HasSelection then
  begin
    Stop  := CaretPos.x;
    Start := SelStart.x;

    if Start > Stop then
      SwitchPos(Start, Stop);

    if (Start + 1 <= Length(Text)) and not IsValidChar(Ch, Start) then
    begin
      MessageBeep(0);
      Exit;
    end;

    CatchUndo;
    try
      Ch := ConvertToValidChar(Ch, Start);

      if Stop - Start > 1 then
      begin
        S := Text;
        
        S[Start + 1] := Ch;
        for I := Start + 2 to Stop do
          S[I] := TSCShemeList(FShemeList).BlankChar;

        SetText(TSCShemeList(FShemeList).ArrangeMaskedText(S));
      end else
      begin
        inherited OverwriteChar(Ch);
        SetText(Text);
      end;

      Inc(Start);

      Ch := UpCase(Ch);
      if Start <= Length(Text) then
      begin
        C := Text[Start];

        if not ((C = Ch) or (C = Char(Ord(Ch) + 32))) then
        begin
          MessageBeep(0);
          Dec(Start);
        end;
      end;

      SetCursorPos(Start);
    finally
      ReleaseUndoCatch;
    end;
  end;
end;

procedure TSCCustomMaskEdit.Redo;
begin
  FInUndo := True;
  try
    inherited Redo;
  finally
    FInUndo := False;
  end;
end;

procedure TSCCustomMaskEdit.Reset;
var
  S: String;
begin
  if Modified then
  begin
    S := FEditMask;
    while CanUndo do
      Undo;

    FEditMask := '';
    SetEditMask(S);

    ClearUndo;
    ClearRedo;
    Modified := False;
  end;
end;

procedure TSCCustomMaskEdit.SetBlankChar(Value: Char);
begin
  if IsMasked then
  begin
    TSCShemeList(FShemeList).SetBlankChar(Value);
    FEditMask := TSCShemeList(FShemeList).Mask;
  end;  
end;

procedure TSCCustomMaskEdit.SetCursorPos(Pt: Integer; Prev: Boolean);
var
  P: PSCMaskSheme;
  I, Start, Stop: Integer;
begin
  if Pt < 0 then
    Pt := 0;

  if Pt > MaxLength then
    Pt := MaxLength;

  if not IsMasked then
  begin
    Stop  := Pt;
    Start := Pt;
  end else
  if Pt = MaxLength then
  begin
    Start := MaxLength;
    Stop  := Start;
    // Stop  := Start - 1;
  end else
  begin
    Start := Pt + 1;
    Stop  := Pt;
  end;

  if Stop > -1 then
  begin
    if Prev then
    begin
      for I := Stop downto 0 do
      begin
        P := TSCShemeList(FShemeList).Items[I];
        if P = nil then
          Break;

        if (P^.Literal <> #0) and (P^.MaskType in
          [scmtNone, scmtLiteral, scmtFieldSeparator,
           scmtDateSeparator, scmtTimeSeparator]) then
          Dec(Stop)
        else
          Break;
      end;
    end else
    for I := Stop to FShemeList.Count-1 do
    begin
      P := TSCShemeList(FShemeList).Items[I];
      if P = nil then
        Break;

      if (P^.Literal <> #0) and (P^.MaskType in
        [scmtNone, scmtLiteral, scmtFieldSeparator,
         scmtDateSeparator, scmtTimeSeparator]) then
        Inc(Stop)
      else
        Break;
    end;

    Start := Stop + 1;
  end;

  SetSelRect(Rect(Start, 0, Stop, 0));
end;

procedure TSCCustomMaskEdit.SetEditMask(const Value: String);
var
  ShemeList: TSCShemeList;
begin
  if FEditMask <> Value then
  begin
    Inc(FSettingMask);
    try
      FEditMask := Value;
      ShemeList := TSCShemeList(FShemeList);

      ShemeList.Mask := FEditMask;

      if IsMasked then
      begin
        SetMaxLength(ShemeList.MaskLength);
        SetText(ShemeList.MaskText);
      end else
      begin
        SetMaxLength(0);
        SetText(Value);
      end;
    finally
      Dec(FSettingMask);

      ClearUndo;
      Modified := False;

      MaskChanged;
    end;
  end;
end;

procedure TSCCustomMaskEdit.SetMaxLength(Value: Integer);
begin
  if IsMasked then
    Value := TSCShemeList(FShemeList).MaskLength;
  inherited SetMaxLength(Value);
end;

procedure TSCCustomMaskEdit.SetSaveLiterals(Value: Boolean);
begin
  if IsMasked then
    TSCShemeList(FShemeList).SetSaveLiterals(Value);
end;

procedure TSCCustomMaskEdit.SetText(Value: TCaption);
begin
  if FInUndo or not IsMasked then
    inherited SetText(Value)
  else begin
     if not IsLoading and FRaiseMaskError and
       not (SettingMask or IsValidText(Value, HasFocus)) then
       raise ESCMaskEditError.CreateFmt(SSCMaskErr, [Value]);

    inherited SetText(TSCShemeList(FShemeList).ArrangeMaskedText(Value));
  end;
end;

function TSCCustomMaskEdit.ShemeCount: Integer;
begin
  Result := 0;
  if IsMasked then
    Result := FShemeList.Count;
end;

procedure TSCCustomMaskEdit.SwitchPos(var P1, P2: Integer);
var
  I: Integer;
begin
  I  := P1;
  P1 := P2;
  P2 := I;
end;

procedure TSCCustomMaskEdit.Undo;
begin
  FInUndo := True;
  try
    inherited Undo;
  finally
    FInUndo := False;
  end;
end;

procedure TSCCustomMaskEdit.ValidateEdit;
begin
  if FRaiseMaskError and not SettingMask and Modified and
    IsMasked and not IsLoading and not IsValidText(Text, False) and
    CanRaiseMaskError then
  begin
    if not IsDesigning then
      SetFocus;
    ValidateError;
  end;
end;

procedure TSCCustomMaskEdit.ValidateError;
begin
  MessageBeep(0);
  if RaiseMaskError then
    raise ESCMaskEditError.CreateFmt(SSCMaskEditErr, [EditMask]);
    // raise ESCMaskEditError.CreateResFmt(Integer(@SSCMaskEditErr), [EditMask]);
end;

procedure TSCCustomMaskEdit.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if IsMasked and not IsDesigning and not FocusInvalidChar then
    SetCursorPos(0);
end;

{$I SCVerRec.inc}

end.
