{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCInputs;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, StdActns, ActnList, Menus, SCCommon, SCControl, SCConsts,
  SCStaticEdit;

type
  TSCDefaultInputColors = class(TSCStaticEditColors)
  public
    constructor Create(AOwner: TSCCustomStaticEdit); override;
  published
    property GroupSelectionColor default clNone;
    property GroupSelectionTextColor default clNone;
  end;

  TSCCustomIPInput = class(TSCCustomStaticEdit)
  private
    FIP: String;
    FCreatingFields: Boolean;
    procedure SetIP(const Value: String);
    function  ArrangeIP(const Value: String): String;
    procedure SetText(const Value: String);
    procedure CreateInputFields;

    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  protected
    procedure Loaded; override;

    function  GetColorsClass: TSCStaticEditColorsClass; override;

    procedure DoEditValueChanged; override;
    procedure DoItemValueChanged(Index: Integer); override;
    procedure DoGetChar(var C: Char; const Index: Integer;
      var Allowed: Boolean); override;

    procedure IncIP;
    procedure DecIP;

    procedure ProcessKeyDown(var Key: Word); override;
    procedure ProcessKeyPress(var Key: Char); override;

    property IP: String read FIP write SetIP;
  public
    constructor Create(AOwner: TComponent); override;
    property Text;
  end;

  TSCIPInput = class(TSCCustomIPInput)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderProps;
    property Color;
    property Colors;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property IP;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Transparent;
    property Visible;
    property OnCanResize;
    property OnChange;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditValue;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetChar;
    property OnGetBackColor;
    property OnGetForeColor;
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

  TSCCustomTimeInput = class(TSCCustomStaticEdit)
  private
    FTime: TTime;
    FRevertable: Boolean;
    FCreatingFields: Boolean;
    procedure SetRevertable(Value: Boolean);
    procedure SetTime(Value: TTime);

    function  GetTime: TTime;
    function  ArrangeTimeText(Value: TTime): String;
    procedure SetText(const Value: String);
    procedure CreateInputFields;

    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  protected
    procedure Loaded; override;

    procedure IncTime;
    procedure DecTime;

    function  GetColorsClass: TSCStaticEditColorsClass; override;

    procedure DoEditValueChanged; override;
    procedure DoGetChar(var C: Char; const Index: Integer;
      var Allowed: Boolean); override;

    procedure ProcessKeyDown(var Key: Word); override;
    procedure ProcessKeyPress(var Key: Char); override;

    property Revertable: Boolean read FRevertable write SetRevertable default True;
    property Time: TTime read FTime write SetTime;
  public
    constructor Create(AOwner: TComponent); override;
    property Text;
  end;

  TSCTimeInput = class(TSCCustomTimeInput)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderProps;
    property Color;
    property Colors;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property Revertable;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Time;
    property Transparent;
    property Visible;
    property OnCanResize;
    property OnChange;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditValue;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetChar;
    property OnGetBackColor;
    property OnGetForeColor;
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

  TSCCustomDateInput = class(TSCCustomStaticEdit)
  private
    FDate: TDate;
    FSettingDate: Integer;
    FCreatingFields: Boolean;
    procedure SetDate(Value: TDate);

    function  GetDate: TDate;
    function  ArrangeDateText(Value: TDate): String;
    procedure SetText(const Value: String);
    procedure CreateInputFields;

    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  protected
    procedure Loaded; override;

    procedure IncDate;
    procedure DecDate;

    function  GetColorsClass: TSCStaticEditColorsClass; override;

    procedure DoEditValueChanged; override;
    procedure DoItemValueChanged(Index: Integer); override;
    procedure DoGetChar(var C: Char; const Index: Integer;
      var Allowed: Boolean); override;

    procedure ProcessKeyDown(var Key: Word); override;
    procedure ProcessKeyPress(var Key: Char); override;

    property Date: TDate read FDate write SetDate;
  public
    constructor Create(AOwner: TComponent); override;
    property Text;
  end;

  TSCDateInput = class(TSCCustomDateInput)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderProps;
    property Color;
    property Colors;
    property Constraints;
    property Date;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PictureProps;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Transparent;
    property Visible;
    property OnCanResize;
    property OnChange;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditValue;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetChar;
    property OnGetBackColor;
    property OnGetForeColor;
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

{ TSCCustomIPInput }

function TSCCustomIPInput.ArrangeIP(const Value: String): String;
var
  I: Integer;
  S: String;
begin
  S := Value;
  for I := 1 to 11 - Length(S) do
    S := '0' + S;

  S := Copy(S, 1, 11);

  for I := 1 to Length(S) do
    if not (S[I] in ['0'..'9']) then
      S[I] := '0';

  S[4] := '.';
  S[8] := '.';

  if StrToInt(Copy(S, 1, 3)) > 255 then
  begin
    S[1] := '2';
    S[2] := '5';
    S[3] := '5';
  end;

  if StrToInt(Copy(S, 5, 3)) > 255 then
  begin
    S[5] := '2';
    S[6] := '5';
    S[7] := '5';
  end;

  if StrToInt(Copy(S, 9, 3)) > 255 then
  begin
    S[9] := '2';
    S[10] := '5';
    S[11] := '5';
  end;

  Result := S;
end;

constructor TSCCustomIPInput.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIP := '000.000.000';
  CreateInputFields;
end;

procedure TSCCustomIPInput.CreateInputFields;
var
  F: TSCStaticEditItem;
begin
  FCreatingFields := True;
  try
    F := Items.Add;
    F.CharData := '0';
    F.GroupIndex := 1;

    F := Items.Add;
    F.CharData := '0';
    F.GroupIndex := 1;

    F := Items.Add;
    F.CharData := '0';
    F.GroupIndex := 1;

    F := Items.Add;
    F.CharData := '.';
    F.Editable := False;

    F := Items.Add;
    F.CharData := '0';
    F.GroupIndex := 2;

    F := Items.Add;
    F.CharData := '0';
    F.GroupIndex := 2;

    F := Items.Add;
    F.CharData := '0';
    F.GroupIndex := 2;

    F := Items.Add;
    F.CharData := '.';
    F.Editable := False;

    F := Items.Add;
    F.CharData := '0';
    F.GroupIndex := 3;

    F := Items.Add;
    F.CharData := '0';
    F.GroupIndex := 3;

    F := Items.Add;
    F.CharData := '0';
    F.GroupIndex := 3;
  finally
    FCreatingFields := False;
  end;
end;

procedure TSCCustomIPInput.DecIP;
var
  C1, C2, C3: Char;
  P, G, Index: Integer;
  T, S, S1, S2, S3: String;
begin
  if not Self.ReadOnly then
  begin
    Index := ItemIndex;

    P := Index mod 4;
    G := Index div 4;

    if (P > -1) and (P < 3) then
    begin
      T := Self.Text;

      C1 := Items[G*4].CharData;
      if not (C1 in ['0'..'9']) then
        C1 := '0';

      C2 := Items[(G*4) + 1].CharData;
      if not (C2 in ['0'..'9']) then
        C2 := '0';

      C3 := Items[(G*4) + 2].CharData;
      if not (C3 in ['0'..'9']) then
        C3 := '0';

      if P = 0 then
        C1 := Char(Ord(C1) - 1)
      else
      if P = 1 then
        C2 := Char(Ord(C2) - 1)
      else
        C3 := Char(Ord(C3) - 1);

      if Ord(C3) < Ord('0') then
      begin
        if (C1 = '0') and (C2 = '0') then
          C3 := '0'
        else begin
          C3 := '9';
          C2 := Char(Ord(C2) - 1);
        end;
      end;

      if Ord(C2) < Ord('0') then
      begin
        if C1 = '0' then
          C2 := '0'
        else begin
          C2 := '9';
          C1 := Char(Ord(C1) - 1);
        end;
      end;

      if Ord(C1) < Ord('0') then
        C1 := '0';

      S := C1 + C2 + C3;
      if StrToInt(S) < 0 then
        S := '000';

      if G = 0 then
        S1 := S
      else
        S1 := Copy(T, 1, 3);

      if G = 1 then
        S2 := S
      else
        S2 := Copy(T, 5, 3);

      if G = 2 then
        S3 := S
      else
        S3 := Copy(T, 9, 3);

      S := S1 + '.' + S2 + '.' + S3;

      if Self.Text <> S then
      begin
        BeginEdit;
        try
          SetText(S);
          FIP := Self.Text;
        finally
          EndEdit;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomIPInput.DoEditValueChanged;
begin
  if (EditCount = 0) and not (FCreatingFields or Self.Creating) then
    FIP := ArrangeIP(Self.Text);
end;

procedure TSCCustomIPInput.DoGetChar(var C: Char; const Index: Integer;
  var Allowed: Boolean);
var
  P, G: Integer;
  Ch1, Ch2: Char;
begin
  Allowed := False;

  if (EditCount > 0) or FCreatingFields then
    Allowed := True
  else
  if (Index = 3) or (Index = 7) then
  begin
    C := '.';
    Allowed := True;
  end else
  if C = #0 then
  begin
    C := '0';
    Allowed := True;
  end else
  if C in ['0'..'9'] then
  begin
    P := Index mod 4;
    G := Index div 4;

    if P = 0 then
      Allowed := C in ['0'..'2']
    else begin
      if G = 0 then
        Ch1 := Items[0].CharData
      else
      if G = 1 then
        Ch1 := Items[4].CharData
      else
        Ch1 := Items[8].CharData;

      if not (Ch1 in ['0'..'9']) then
        Ch1 := '0';

      if P = 1 then
        Allowed := (Ch1 <> '2') or (C in ['0'..'5'])
      else
      if Ch1 <> '2' then
        Allowed := True
      else begin
        if G = 0 then
          Ch2 := Items[1].CharData
        else
        if G = 1 then
          Ch2 := Items[5].CharData
        else
          Ch2 := Items[9].CharData;

        if not (Ch1 in ['0'..'9']) then
          Ch2 := '0';

        Allowed := (Ch2 <> '5') or (C in ['0'..'5'])
      end;
    end;
  end;
end;

procedure TSCCustomIPInput.DoItemValueChanged(Index: Integer);
var
  S: String;
  G, I, GS: Integer;
  C: Array[0..2] of Char;
begin
  if (EditCount = 0) and not (FCreatingFields or Self.Creating) then
  begin
    G := -1;
    GS := -1;

    if Index in [0..2] then
    begin
      G := 0;
      GS := 0;
    end else
    if Index in [4..6] then
    begin
      G := 1;
      GS := 4;
    end else
    if Index in [8..10] then
    begin
      G := 2;
      GS := 8;
    end;

    if G = -1 then
      Exit;

    for I := 0 to 2 do
    begin
      C[I] := Items[GS + I].CharData;
      if not (C[I] in ['0'..'9']) then
        C[I] := '0';
    end;

    S := C[0] + C[1] + C[2];
    if StrToInt(S) > 255 then
    begin
      C[0] := '2';
      C[1] := '5';
      C[2] := '5';

      BeginEdit;
      try
        for I := 0 to 2 do
          Items[GS + I].CharData := C[I];
      finally
        EndEdit;
      end;
    end;
  end;
end;

function TSCCustomIPInput.GetColorsClass: TSCStaticEditColorsClass;
begin
  Result := TSCDefaultInputColors;
end;

procedure TSCCustomIPInput.IncIP;
var
  C1, C2, C3: Char;
  P, G, Index: Integer;
  T, S, S1, S2, S3: String;
begin
  if not Self.ReadOnly then
  begin
    Index := ItemIndex;

    P := Index mod 4;
    G := Index div 4;

    if (P > -1) and (P < 3) then
    begin
      T := Self.Text;

      C1 := Items[G*4].CharData;
      if not (C1 in ['0'..'9']) then
        C1 := '0';

      C2 := Items[(G*4) + 1].CharData;
      if not (C2 in ['0'..'9']) then
        C2 := '0';

      C3 := Items[(G*4) + 2].CharData;
      if not (C3 in ['0'..'9']) then
        C3 := '0';

      if P = 0 then
        C1 := Char(Ord(C1) + 1)
      else
      if P = 1 then
        C2 := Char(Ord(C2) + 1)
      else
        C3 := Char(Ord(C3) + 1);

      if Ord(C3) > Ord('9') then
      begin
        C3 := '0';
        C2 := Char(Ord(C2) + 1);
      end;

      if Ord(C2) > Ord('9') then
      begin
        C2 := '0';
        C1 := Char(Ord(C1) + 1);
      end;

      if Ord(C1) > Ord('9') then
        C1 := '9';

      S := C1 + C2 + C3;
      if StrToInt(S) > 255 then
        S := '255';

      if G = 0 then
        S1 := S
      else
        S1 := Copy(T, 1, 3);

      if G = 1 then
        S2 := S
      else
        S2 := Copy(T, 5, 3);

      if G = 2 then
        S3 := S
      else
        S3 := Copy(T, 9, 3);

      S := S1 + '.' + S2 + '.' + S3;

      if Self.Text <> S then
      begin
        BeginEdit;
        try
          SetText(S);
          FIP := Self.Text;
        finally
          EndEdit;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomIPInput.Loaded;
begin
  inherited Loaded;
  FCreatingFields := False;
end;

procedure TSCCustomIPInput.ProcessKeyDown(var Key: Word);
begin
  case Key of
    VK_SPACE:
      SetItemIndex(GetNextGroup(ItemIndex));
    VK_DOWN:
      DecIP;
    VK_UP:
      IncIP;
    else
      inherited ProcessKeyDown(Key);
  end;
end;

procedure TSCCustomIPInput.ProcessKeyPress(var Key: Char);
begin
  if (Key <> Char(VK_SPACE)) then
    inherited ProcessKeyPress(Key);
end;

procedure TSCCustomIPInput.SetIP(const Value: String);
var
  S: String;
begin
  S := ArrangeIP(Value);

  if FIP <> S then
  begin
    SetText(S);
    FIP := Self.Text;
    Self.EditValueChanged;
  end;
end;

procedure TSCCustomIPInput.SetText(const Value: String);
var
  I: Integer;
begin
  if (Items <> nil) and (Items.Count = 11) then
  begin
    BeginEdit;
    try
      for I := 0 to Length(Value) - 1 do
        Items[I].CharData := Value[I + 1];
    finally
      EndEdit;
    end;
  end;
end;

procedure TSCCustomIPInput.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if Message.WheelDelta < 0 then
    IncIP
  else
  if Message.WheelDelta > 0 then
    DecIP;
end;

{ TSCCustomTimeInput }

function TSCCustomTimeInput.ArrangeTimeText(Value: TTime): String;
var
  S1: String;
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(Value, Hour, Min, Sec, MSec);

  Result := '';
  S1 := IntToStr(Hour);
  if Hour < 10 then S1 := '0' + S1;

  Result := S1;

  S1 := IntToStr(Min);
  if Min < 10 then S1 := '0' + S1;

  Result := Result + ':' + S1;

  S1 := IntToStr(Sec);
  if Sec < 10 then S1 := '0' + S1;

  Result := Result + ':' + S1;
end;

constructor TSCCustomTimeInput.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTime := 0;
  FRevertable := True;
  CreateInputFields;
end;

procedure TSCCustomTimeInput.CreateInputFields;
var
  F: TSCStaticEditItem;
begin
  FCreatingFields := True;
  try
    BeginEdit;
    try
      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 1;

      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 1;

      F := Items.Add;
      F.CharData := ':';
      F.Editable := False;

      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 2;

      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 2;

      F := Items.Add;
      F.CharData := ':';
      F.Editable := False;

      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 3;
      
      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 3;
    finally
      EndEdit;
    end;
  finally
    FCreatingFields := False;
  end;
end;

procedure TSCCustomTimeInput.DoEditValueChanged;
begin
  if (EditCount = 0) and not (FCreatingFields or Self.Creating) then
    FTime := GetTime;
end;

procedure TSCCustomTimeInput.DoGetChar(var C: Char; const Index: Integer;
  var Allowed: Boolean);
var
  Ch: Char;
  P, G: Integer;
begin
  Allowed := False;

  if (EditCount > 0) or FCreatingFields then
    Allowed := True
  else
  if (Index = 2) or (Index = 5) then
  begin
    C := ':';
    Allowed := True;
  end else
  if C = #0 then
  begin
    C := '0';
    Allowed := True;
  end else
  if C in ['0'..'9'] then
  begin
    Allowed := True;

    P := Index mod 3;
    G := Index div 3;

    if G = 0 then
    begin
      if P = 0 then
      begin
        if not (C in ['0'..'2']) then
          C := '2';
      end else
      if Ord(C) > Ord('3') then
      begin
        Ch := Items[0].CharData;
        if (Ch <> '0') and (Ch <> '1') then
          C := '3';
      end;
    end else
    if (P = 0) and not (C in ['0'..'5']) then
      C := '5';
  end;
end;

procedure TSCCustomTimeInput.ProcessKeyDown(var Key: Word);
begin
  case Key of
    VK_SPACE:
      SetItemIndex(GetNextGroup(ItemIndex));
    VK_DOWN:
      DecTime;
    VK_UP:
      IncTime;
    else
      inherited ProcessKeyDown(Key);
  end;
end;

procedure TSCCustomTimeInput.ProcessKeyPress(var Key: Char);
begin
  if (Key <> Char(VK_SPACE)) then
    inherited ProcessKeyPress(Key);
end;

procedure TSCCustomTimeInput.SetTime(Value: TTime);
begin
  if FTime <> Value then
  begin
    BeginEdit;
    try
      SetText(ArrangeTimeText(Value));
      FTime := GetTime;
    finally
      EndEdit;
    end;
  end;
end;

procedure TSCCustomTimeInput.SetText(const Value: String);
var
  I: Integer;
begin
  if (Items <> nil) and (Items.Count = 8) then
  begin
    BeginEdit;
    try
      for I := 0 to Length(Value)-1 do
        Items[I].CharData := Value[I+1];
    finally
      EndEdit;
    end;
  end;
end;

procedure TSCCustomTimeInput.DecTime;
var
  S1, S2: String;
  Hour, Min, Sec, MSec: Word;
  P, G, Index, H, M, S: Integer;
begin
  if not Self.ReadOnly then
  begin
    Index := ItemIndex;

    P := Index mod 3;
    G := Index div 3;

    if (P > -1) and (P < 2) then
    begin
      DecodeTime(FTime, Hour, Min, Sec, MSec);

      H := Hour;
      M := Min;
      S := Sec;

      if G = 0 then
      begin
        if P = 0 then
          Dec(H, 10)
        else Dec(H);
      end else
      if G = 1 then
      begin
        if P = 0 then
          Dec(M, 10)
        else Dec(M);
      end else
      begin
        if P = 0 then
          Dec(S, 10)
        else Dec(S);
      end;

      if S < 0 then
      begin
        Dec(M);

        if FRevertable then
          S := 60 + S
        else
          S := 59;
      end;

      if M < 0 then
      begin
        Dec(H);
      
        if FRevertable then
          M := 60 + M
        else
          M := 59;
      end;

      if H < 0 then
      begin
        if FRevertable then
          H := 24 + H
        else begin
          H := 0;
          M := 0;
          S := 0;
        end;
      end;

      S1 := '';
      S2 := IntToStr(H);
      if H < 10 then S2 := '0' + S2;

      S1 := S2;

      S2 := IntToStr(M);
      if M < 10 then S2 := '0' + S2;

      S1 := S1 + ':' + S2;

      S2 := IntToStr(S);
      if S < 10 then S2 := '0' + S2;

      S1 := S1 + ':' + S2;

      if Self.Text <> S1 then
      begin
        BeginEdit;
        try
          SetText(S1);
          FTime := EncodeTime(H, M, S, 0);
        finally
          EndEdit;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTimeInput.IncTime;
var
  S, S1: String;
  P, G, Index: Integer;
  Hour, Min, Sec, MSec: Word;
begin
  if not Self.ReadOnly then
  begin
    Index := ItemIndex;

    P := Index mod 3;
    G := Index div 3;

    if (P > -1) and (P < 2) then
    begin
      DecodeTime(FTime, Hour, Min, Sec, MSec);

      if G = 0 then
      begin
        if P = 0 then
          Inc(Hour, 10)
        else Inc(Hour);

        if Hour > 23 then
        begin
          if FRevertable then
            Hour := Hour - 24
          else
            Hour := 23;
        end;
      end else
      if G = 1 then
      begin
        if P = 0 then
          Inc(Min, 10)
        else Inc(Min);

        if (Hour = 23) and (Min > 59) then
        begin
          if FRevertable then
          begin
            Hour := 0;
            Min  := Min - 60;
          end else
            Min := 59;
        end;
      end else
      begin
        if P = 0 then
          Inc(Sec, 10)
        else Inc(Sec);

        if (Hour = 23) and (Min = 59) and (Sec > 59) then
        begin
          if FRevertable then
          begin
            Hour := 0;
            Min  := 0;
            Sec  := Sec - 60;
          end else
            Sec := 59;
        end;
      end;

      if Sec > 59 then
      begin
        Inc(Min);
        if FRevertable then
          Sec := Sec - 60
        else
          Sec := 0;
      end;

      if Min > 59 then
      begin
        Inc(Hour);
        if FRevertable then
          Min := Min - 60
        else
          Min := 0;
      end;

      if Hour > 23 then
      begin
        if FRevertable then
          Hour := Hour - 24
        else
          Hour := 23;
      end;

      S := '';
      S1 := IntToStr(Hour);
      if Hour < 10 then S1 := '0' + S1;

      S := S1;

      S1 := IntToStr(Min);
      if Min < 10 then S1 := '0' + S1;

      S := S + ':' + S1;

      S1 := IntToStr(Sec);
      if Sec < 10 then S1 := '0' + S1;

      S := S + ':' + S1;

      if Self.Text <> S then
      begin
        BeginEdit;
        try
          SetText(S);
          FTime := EncodeTime(Hour, Min, Sec, 0);
        finally
          EndEdit;
        end;
      end;
    end;
  end;
end;

function TSCCustomTimeInput.GetTime: TTime;
var
  S: String;
  Hour, Min, Sec: Word;
begin
  Result := FTime;
  if (EditCount = 0) and not (FCreatingFields or Self.Creating) then
  begin
    S := Items[0].CharData + Items[1].CharData;
    Hour := StrToIntDef(S, 0);

    if Hour > 23 then Hour := 00;

    S := Items[3].CharData + Items[4].CharData;
    Min := StrToIntDef(S, 0);

    if Min > 59 then Min := 59;

    S := Items[6].CharData + Items[7].CharData;
    Sec := StrToIntDef(S, 0);

    if Sec > 59 then Sec := 59;

    Result := EncodeTime(Hour, Min, Sec, 0);
  end;
end;

procedure TSCCustomTimeInput.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if Message.WheelDelta < 0 then
    IncTime
  else
  if Message.WheelDelta > 0 then
    DecTime;
end;

procedure TSCCustomTimeInput.Loaded;
begin
  inherited Loaded;
  FCreatingFields := False;
end;

function TSCCustomTimeInput.GetColorsClass: TSCStaticEditColorsClass;
begin
  Result := TSCDefaultInputColors;
end;

procedure TSCCustomTimeInput.SetRevertable(Value: Boolean);
begin
  FRevertable := Value;
end;

{ TSCCustomDateInput }

function TSCCustomDateInput.ArrangeDateText(Value: TDate): String;
var
  S1: String;
  I, Ln: Integer;
  Year, Month, Day: Word;
begin
  DecodeDate(Value, Year, Month, Day);

  if Year > 9999 then Year := 9999;

  Result := '';

  S1 := IntToStr(Day);
  if Day < 10 then S1 := '0' + S1;

  Result := S1;

  S1 := IntToStr(Month);
  if Month < 10 then S1 := '0' + S1;

  Result := Result + '.' + S1;

  S1 := IntToStr(Year);
  Ln := Length(S1);

  for I := 1 to 4 - Ln do
    S1 := '0' + S1;

  Result := Result + '.' + S1;
end;

constructor TSCCustomDateInput.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDate := 0;
  CreateInputFields;
end;

procedure TSCCustomDateInput.CreateInputFields;
var
  F: TSCStaticEditItem;
begin
  FCreatingFields := True;
  try
    BeginEdit;
    try
      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 1;

      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 1;

      F := Items.Add;
      F.CharData := '.';
      F.Editable := False;

      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 2;

      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 2;

      F := Items.Add;
      F.CharData := '.';
      F.Editable := False;

      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 3;

      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 3;

      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 3;

      F := Items.Add;
      F.CharData := '0';
      F.GroupIndex := 3;
    finally
      EndEdit;
    end;
  finally
    FCreatingFields := False;
  end;
end;

procedure TSCCustomDateInput.DoEditValueChanged;
begin
  if (EditCount = 0) and (FSettingDate = 0) and
    not (FCreatingFields or Self.Creating) then
    FDate := GetDate;
end;

procedure TSCCustomDateInput.DoGetChar(var C: Char; const Index: Integer;
  var Allowed: Boolean);
var
  Ch: Char;
  P, G: Integer;
begin
  Allowed := False;

  if (EditCount > 0) or FCreatingFields then
    Allowed := True
  else
  if (Index = 2) or (Index = 5) then
  begin
    C := ':';
    Allowed := True;
  end else
  if C = #0 then
  begin
    C := '0';
    Allowed := True;
  end else
  if C in ['0'..'9'] then
  begin
    P := -1;
    G := -1;

    if Index in [0, 1] then
    begin
      P := Index;
      G := 0;
    end else
    if Index in [3, 4] then
    begin
      P := Index - 3;
      G := 1;
    end else
    if Index in [6..9] then
    begin
      P := Index - 6;
      G := 2;
    end;

    if (P > -1) and (G > -1) then
    begin
      Allowed := C in ['0'..'9'];

      if G = 0 then
      begin
        Ch := Items[0].CharData;

        if P = 0 then
          Allowed := C in ['0'..'3']
        else
        if Ch = '3' then
          Allowed := C in ['0','1'];
      end else
      if G = 1 then
      begin
        Ch := Items[3].CharData;

        if P = 0 then
          Allowed := C in ['0'..'1']
        else
        if Ch = '1' then
          Allowed := C in ['0'..'2']
      end;
    end;
  end;
end;

procedure TSCCustomDateInput.ProcessKeyDown(var Key: Word);
begin
  case Key of
    VK_SPACE:
      SetItemIndex(GetNextGroup(ItemIndex));
    VK_DOWN:
      DecDate;
    VK_UP:
      IncDate;
    else
      inherited ProcessKeyDown(Key);
  end;
end;

procedure TSCCustomDateInput.ProcessKeyPress(var Key: Char);
begin
  if (Key <> Char(VK_SPACE)) then
    inherited ProcessKeyPress(Key);
end;

procedure TSCCustomDateInput.SetDate(Value: TDate);
begin
  if FDate <> Value then
  begin
    Inc(FSettingDate);
    try
      BeginEdit;
      try
        if Value = 0 then
        begin
          FDate := 0;
          SetText('00.00.0000');
        end else
        begin
          FDate := Value;
          SetText(ArrangeDateText(Value));
        end;
      finally
        EndEdit;
      end;
    finally
      Dec(FSettingDate);
    end;
  end;
end;

procedure TSCCustomDateInput.SetText(const Value: String);
var
  I: Integer;
begin
  if (Items <> nil) and (Items.Count = 10) then
  begin
    BeginEdit;
    try
      for I := 0 to Length(Value)-1 do
        Items[I].CharData := Value[I+1];
    finally
      EndEdit;
    end;
  end;
end;

procedure TSCCustomDateInput.DecDate;
var
  S, S1: String;
  Year, Month, Day, D1: Word;
  Index, P, G, I, Y, M, D, Ln: Integer;
begin
  if not Self.ReadOnly then
  begin
    Index := ItemIndex;

    P := -1;
    G := -1;

    if Index in [0, 1] then
    begin
      P := Index;
      G := 0;
    end else
    if Index in [3, 4] then
    begin
      P := Index - 3;
      G := 1;
    end else
    if Index in [6..9] then
    begin
      P := Index - 6;
      G := 2;
    end;

    if (FDate <> 0) and (P > -1) and (G > -1) then
    begin
      DecodeDate(FDate, Year, Month, Day);

      if Day < 1 then Day := 1;
      if Month < 1 then Month := 1;
      if Year < 1 then Year := 1;

      D := Day;
      M := Month;
      Y := Year;

      if G = 0 then
      begin
        if P = 0 then
          Dec(D, 10)
        else Dec(D);

        if D < 1 then
        begin
          if (M = 1) and (Y = 1) then
            D := 1
          else begin
            Dec(M);

            if M < 1 then
            begin
              M := 12;

              Dec(Y);
              if Y < 0 then Y := 1;
            end;

            D := scDaysPerMonth(Y, M);
          end;
        end;
      end else
      if G = 1 then
      begin
        if P = 0 then
          Dec(M, 10)
        else Dec(M);

        if M < 1 then
        begin
          if Y = 1 then
            M := 1
          else begin
            M := 12;
            Dec(Y);
          end;
        end;

        D1 := scDaysPerMonth(Y, M);
        if (D < 1) or (D > D1) then D := D1;
      end else
      begin
        if P = 0 then
          Dec(Y, 1000)
        else
        if P = 1 then
          Dec(Y, 100)
        else
        if P = 2 then
          Dec(Y, 10)
        else
          Dec(Y);

        if Y < 1 then Y := 1;

        D1 := scDaysPerMonth(Y, M);
        if (D < 1) or (D > D1) then D := D1;
      end;

      if D < 1 then D := 1;
      if M < 1 then M := 1;
      if Y < 1 then Y := 1;

      S := '';
      S1 := IntToStr(D);
      if D < 10 then S1 := '0' + S1;

      S := S1;

      S1 := IntToStr(M);
      if M < 10 then S1 := '0' + S1;

      S := S + '.' + S1;

      S1 := IntToStr(Y);
      Ln := Length(S1);

      for I := 1 to 4 - Ln do
        S1 := '0' + S1;

      S := S + '.' + S1;

      if Self.Text <> S then
      begin
        BeginEdit;
        try
          SetText(S);
          FDate := EncodeDate(Year, Month, Day);
        finally
          EndEdit;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomDateInput.IncDate;
var
  S, S1: String;
  Year, Month, Day, D: Word;
  Index, P, G, I, Ln: Integer;
begin
  if not Self.ReadOnly then
  begin
    Index := ItemIndex;

    P := -1;
    G := -1;

    if Index in [0, 1] then
    begin
      P := Index;
      G := 0;
    end else
    if Index in [3, 4] then
    begin
      P := Index - 3;
      G := 1;
    end else
    if Index in [6..9] then
    begin
      P := Index - 6;
      G := 2;
    end;

    if (P > -1) and (G > -1) then
    begin
      if Self.Text = '00.00.0000' then
      begin
        Year := 1;
        Month := 1;
        Day := 1;
      end else
      begin
        DecodeDate(FDate, Year, Month, Day);

        if Day < 1 then Day := 1;
        if Month < 1 then Month := 1;
        if Year < 1 then Year := 1;

        if G = 0 then
        begin
          if P = 0 then
            Inc(Day, 10)
          else Inc(Day);

          D := scDaysPerMonth(Year, Month);
          if Day > D then
          begin
            Day := 1;
            Inc(Month);

            if Month > 12 then
            begin
              if Year >= 9999 then
                Month := 12
              else begin
                Month := 1;
                Inc(Year);
              end;
            end;
          end;
        end else
        if G = 1 then
        begin
          if P = 0 then
            Inc(Month, 10)
          else Inc(Month);

          if Month > 12 then
          begin
            if Year >= 9999 then
              Month := 12
            else begin
              Month := 1;
              Inc(Year);
            end;
          end;

          D := scDaysPerMonth(Year, Month);
          if Day > D then Day := D;
        end else
        begin
          if P = 0 then
            Inc(Year, 1000)
          else
          if P = 1 then
            Inc(Year, 100)
          else
          if P = 2 then
            Inc(Year, 10)
          else
            Inc(Year);

          if Year > 9999 then Year := 9999;

          D := scDaysPerMonth(Year, Month);
          if Day > D then Day := D;
        end;
      end;

      if Day < 1 then Day := 1;
      if Month < 1 then Month := 1;
      if Year < 1 then Year := 1;

      S := '';
      S1 := IntToStr(Day);
      if Day < 10 then S1 := '0' + S1;

      S := S1;

      S1 := IntToStr(Month);
      if Month < 10 then S1 := '0' + S1;

      S := S + '.' + S1;

      S1 := IntToStr(Year);
      Ln := Length(S1);

      for I := 1 to 4 - Ln do
        S1 := '0' + S1;

      S := S + '.' + S1;

      if Self.Text <> S then
      begin
        BeginEdit;
        try
          SetText(S);
          FDate := EncodeDate(Year, Month, Day);
        finally
          EndEdit;
        end;
      end;
    end;
  end;
end;

function TSCCustomDateInput.GetDate: TDate;
var
  S: String;
  Year, Month, Day, D: Word;
begin
  Result := FDate;
  if (EditCount = 0) and not (FCreatingFields or Self.Creating) then
  begin
    S := Items[0].CharData + Items[1].CharData;
    Day := StrToIntDef(S, 0);

    if Day < 1 then Day := 1;
    if Day > 31 then Day := 31;

    S := Items[3].CharData + Items[4].CharData;
    Month := StrToIntDef(S, 0);

    if Month < 1 then Month := 1;
    if Month > 12 then Month := 12;

    S := Items[6].CharData + Items[7].CharData +
      Items[8].CharData + Items[9].CharData;

    Year := StrToIntDef(S, 0);

    if Year < 1 then Year := 1;
    if Year > 9999 then Year := 9999;

    D := scDaysPerMonth(Year, Month);
    if Day > D then Day := D;

    Result := EncodeDate(Year, Month, Day);
  end;
end;

procedure TSCCustomDateInput.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if Message.WheelDelta < 0 then
    IncDate
  else
  if Message.WheelDelta > 0 then
    DecDate;
end;

procedure TSCCustomDateInput.Loaded;
begin
  inherited Loaded;
  FCreatingFields := False;
end;

procedure TSCCustomDateInput.DoItemValueChanged(Index: Integer);
var
  S, S1: String;
  G, I, Ln: Integer;
  C1, C2, C3, C4: Char;
  Year, Month, Day, MD: Word;
begin
  if (EditCount = 0) and (FSettingDate = 0) and
    not (FCreatingFields or Self.Creating) then
  begin
    G := -1;
    if Index in [0, 1] then
      G := 0
    else
    if Index in [3, 4] then
      G := 1
    else
    if Index in [6..9] then
      G := 2;

    if G = -1 then
      Exit;

    DecodeDate(FDate, Year, Month, Day);

    if Day < 1 then Day := 1;
    if Month < 1 then Month := 1;
    if Year < 1 then Year := 1;

    if G = 0 then
    begin
      C1 := Items[0].CharData;
      if not (C1 in ['0'..'9']) then C1 := '0';

      C2 := Items[1].CharData;
      if not (C2 in ['0'..'9']) then C2 := '0';

      Day := StrToInt(C1 + C2);

      if Day = 0 then
        Day := 1
      else begin
        MD := scDaysPerMonth(Year, Month);
        if Day > MD then Day := MD;
      end;
    end else
    if G = 1 then
    begin
      C1 := Items[3].CharData;
      if not (C1 in ['0'..'9']) then C1 := '0';

      C2 := Items[4].CharData;
      if not (C2 in ['0'..'9']) then C2 := '0';

      Month := StrToInt(C1 + C2);

      if Month = 0 then Month := 1;
      if Month > 12 then Month := 12;

      MD := scDaysPerMonth(Year, Month);
      if Day > MD then Day := MD;
    end else
    begin
      C1 := Items[6].CharData;
      if not (C1 in ['0'..'9']) then C1 := '0';

      C2 := Items[7].CharData;
      if not (C2 in ['0'..'9']) then C2 := '0';

      C3 := Items[8].CharData;
      if not (C1 in ['0'..'9']) then C1 := '0';

      C4 := Items[9].CharData;
      if not (C2 in ['0'..'9']) then C2 := '0';

      Year := StrToInt(C1 + C2 + C3 + C4);

      if Year = 0 then Year := 1;
      if Year > 9999 then Year := 9999;

      MD := scDaysPerMonth(Year, Month);
      if Day > MD then Day := MD;
    end;

    if Day < 1 then Day := 1;
    if Month < 1 then Month := 1;
    if Year < 1 then Year := 1;

    S := '';
    S1 := IntToStr(Day);
    if Day < 10 then S1 := '0' + S1;

    S := S1;

    S1 := IntToStr(Month);
    if Month < 10 then S1 := '0' + S1;

    S := S + '.' + S1;

    S1 := IntToStr(Year);
    Ln := Length(S1);

    for I := 1 to 4 - Ln do
      S1 := '0' + S1;

    S := S + '.' + S1;

    if Self.Text <> S then
    begin
      BeginEdit;
      try
        SetText(S);
        FDate := EncodeDate(Year, Month, Day);
      finally
        EndEdit;
      end;
    end;
  end;
end;

function TSCCustomDateInput.GetColorsClass: TSCStaticEditColorsClass;
begin
  Result := TSCDefaultInputColors;
end;

{ TSCDefaultInputColors }

constructor TSCDefaultInputColors.Create(AOwner: TSCCustomStaticEdit);
begin
  inherited Create(AOwner);
  GroupSelectionColor := clNone;
  GroupSelectionTextColor := clNone;
end;

{$I SCVerRec.inc}

end.
