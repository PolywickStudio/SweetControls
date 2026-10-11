{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCStaticEdit;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, StdActns, ActnList, Menus, SCCommon, SCConsts, SCControl;

type
  TSCCharChangeEvent = procedure(Sender: TObject; const Index: Integer) of object;
  TSCGetCharEvent = procedure(Sender: TObject; var C: Char;
    const Index: Integer; var Allowed: Boolean) of object;
  TSCCharColorEvent = procedure(Sender: TObject; const Index: Integer;
    var C: TColor) of object;

  TSCCustomStaticEdit = class;

  TSCStaticEditBorderProps = class(TSCControlBorderProps)
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

  TSCStaticEditPictureProps = class(TSCPictureProps);

  TSCStaticEditColors = class(TPersistent)
  private
    FOwner: TSCCustomStaticEdit;
    FDisabledColor: TColor;
    FDisabledTextColor: TColor;
    FHideSelectionColor: TColor;
    FHideSelectionTextColor: TColor;
    FHighlightColor: TColor;
    FHighlightTextColor: TColor;
    FGroupSelectionColor: TColor;
    FGroupSelectionTextColor: TColor;
    procedure SetDisabledColor(Value: TColor);
    procedure SetDisabledTextColor(Value: TColor);
    procedure SetHideSelectionColor(Value: TColor);
    procedure SetHideSelectionTextColor(Value: TColor);
    procedure SetHighlightColor(Value: TColor);
    procedure SetHighlightTextColor(Value: TColor);
    procedure SetGroupSelectionColor(Value: TColor);
    procedure SetGroupSelectionTextColor(Value: TColor);
  protected
    procedure Changed;

    function GetOwner: TPersistent; override;
    property Owner: TSCCustomStaticEdit read FOwner;
  public
    constructor Create(AOwner: TSCCustomStaticEdit); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clBtnFace;
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText;
    property GroupSelectionColor: TColor read FGroupSelectionColor write SetGroupSelectionColor default clHighlight;
    property GroupSelectionTextColor: TColor read FGroupSelectionTextColor write SetGroupSelectionTextColor default clHighlightText;
    property HideSelectionColor: TColor read FHideSelectionColor write SetHideSelectionColor default clBtnShadow;
    property HideSelectionTextColor: TColor read FHideSelectionTextColor write SetHideSelectionTextColor default clBtnHighlight;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default clHighlight;
    property HighlightTextColor: TColor read FHighlightTextColor write SetHighlightTextColor default clHighlightText;
  end;

  TSCStaticEditColorsClass = class of TSCStaticEditColors;

  TSCStaticEditItem = class(TCollectionItem)
  private
    FCharData: Char;
    FColor: TColor;
    FEditable: Boolean;
    FGroupIndex: Integer;
    FTag: Integer;
    procedure SetCharData(const Value: Char);
    procedure SetColor(Value: TColor);
    procedure SetEditable(Value: Boolean);
    procedure SetGroupIndex(Value: Integer);
    procedure SetTag(Value: Integer);
  protected
    function  GetRangedValue(C: Char; var Allowed: Boolean): Char;

    function  GetDisplayName: string; override;
    function  GetStaticEdit: TSCCustomStaticEdit;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;

    property StaticEdit: TSCCustomStaticEdit read GetStaticEdit;
  published
    property CharData: Char read FCharData write SetCharData default '0';
    property Color: TColor read FColor write SetColor default clNone;
    property Editable: Boolean read FEditable write SetEditable default True;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property Tag: Integer read FTag write SetTag default 0;
  end;

  TSCStaticEditItems = class(TCollection)
  private
    FOwner: TSCCustomStaticEdit;
    function  GetItem(Index: Integer): TSCStaticEditItem;
    procedure SetItem(Index: Integer; Value: TSCStaticEditItem);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TSCCustomStaticEdit); virtual;
    procedure Assign(Source: TPersistent); override;

    function Add: TSCStaticEditItem;
    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomStaticEdit read FOwner;
    {$ENDIF}
    property Items[Index: Integer]: TSCStaticEditItem read GetItem write SetItem; default;
  end;

  TSCCustomStaticEdit = class(TSCCustomControl)
  private
    FAlignment: TLeftRight;
    FColors: TSCStaticEditColors;
    FReadonly: Boolean;
    FCreating: Boolean;
    FItemIndex: Integer;
    FIsMouseDown: Boolean;
    FHideSelection: Boolean;
    FUpdateCount: Integer;
    FEditCount: Integer;
    FCharList: TList;
    FIndentLeft: Integer;
    FIndentRight: Integer;
    FItems: TSCStaticEditItems;
    FOnGetChar: TSCGetCharEvent;
    FOnCharChange: TSCCharChangeEvent;
    FOnEditValue: TNotifyEvent;
    FOnGetBackColor: TSCCharColorEvent;
    FOnGetForeColor: TSCCharColorEvent;
    procedure SetAlignment(Value: TLeftRight);
    procedure SetColors(Value: TSCStaticEditColors);
    procedure SetReadonly(Value: Boolean);
    procedure SetHideSelection(Value: Boolean);
    function  GetCaption: TCaption;
    function  GetEditingText: Boolean;
    procedure SetItems(Value: TSCStaticEditItems);

    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CNChar(var Message: TWMChar); message CN_CHAR;

    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure CreateWnd; override;
    procedure Paint; override;
    procedure Loaded; override;
    procedure UpdateView;

    procedure EditValueChanged;
    procedure DoEditValueChanged; virtual;

    function  GetColorsClass: TSCStaticEditColorsClass; dynamic;

    procedure ItemValueChanged(Index: Integer);
    procedure DoItemValueChanged(Index: Integer); virtual;

    procedure GetChar(var C: Char; Index: Integer; var Allowed: Boolean);
    procedure DoGetChar(var C: Char; const Index: Integer;
      var Allowed: Boolean); virtual;

    procedure SetItemIndex(Value: Integer);
    function  GetRealIndex(const Value: Integer): Integer;

    function  GetDefaultBackColor: TColor; override;
    function  GetDefaultForeColor: TColor; override;

    function  GetBackColor(const Index: Integer): TColor;
    function  GetForeColor(const Index: Integer): TColor;
    procedure DoGetBackColor(const Index: Integer; var C: TColor); virtual;
    procedure DoGetForeColor(const Index: Integer; var C: TColor); virtual;

    procedure PaintText(C: TCanvas); virtual;
    procedure DoDrawBack(C: TCanvas); virtual;
    procedure DoDrawText(C: TCanvas); virtual;

    procedure ConstrainedResize(var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer); override;
    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;

    procedure DoPictureListChanged; override;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; override;
    function  GetPicturePropsClass: TSCCustomPicturePropsClass; override;

    procedure DoColorsChanged; dynamic;

    function  GetCharList: TList;
    procedure RemoveCharList;
    procedure InitiateCharList;

    function  GetCharSize(C: Char): TPoint;
    function  GetCharWidth(C: Char): Integer;
    function  GetCharHeight(C: Char): Integer;
    function  GetTextWidth(S: String): Integer;

    function  GetLineWidth(L: Integer): Integer;
    function  GetLineHeight: Integer; virtual;
    function  GetEditRect: TRect; virtual;

    procedure AdjustBounds; override;
    function  GetAutoHeight: Integer; dynamic;
    function  GetExtraBorderSize: Integer; virtual;

    function  CanGetFocus: Boolean; override;
    procedure StopTracking; override;
    procedure EnabledChanged; override;

    procedure BorderChanged; override;
    function  GetBlendValue: Word; override;

    procedure ItemChanged(Item: TSCStaticEditItem);

    function  CanBeepForKey(Key: Word; Shift: TShiftState): Boolean; virtual;
    function  IsValidKey(Key: Char): Boolean; virtual;
    function  UpdateKey(Key: Char): Char; virtual;

    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure ProcessKeyDown(var Key: Word); virtual;
    procedure ProcessKeyPress(var Key: Char); virtual;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;

    procedure Clear; virtual;

    property Alignment: TLeftRight read FAlignment write SetAlignment default taLeftJustify;
    property Creating: Boolean read FCreating;
    property AutoSize default True;
    property BorderProps;
    property Color default clWindow;
    property ClickFocus default True;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Colors: TSCStaticEditColors read FColors write SetColors;
    property HideSelection: Boolean read FHideSelection write SetHideSelection default True;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property TabStop default True;
    property Items: TSCStaticEditItems read FItems write SetItems;
    property IsMouseDown: Boolean read FIsMouseDown;
    property Text: TCaption read GetCaption;

    property OnGetChar: TSCGetCharEvent read FOnGetChar write FOnGetChar;
    property OnEditValue: TNotifyEvent read FOnEditValue write FOnEditValue;
    property OnCharChange: TSCCharChangeEvent read FOnCharChange write FOnCharChange;
    property OnGetBackColor: TSCCharColorEvent read FOnGetBackColor write FOnGetBackColor;
    property OnGetForeColor: TSCCharColorEvent read FOnGetForeColor write FOnGetForeColor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure BeginUpdate;
    procedure EndUpdate;

    procedure BeginEdit;
    procedure EndEdit;

    function  SetChar(C: Char): Boolean;

    function  GetFirstJump: Integer;
    function  GetLastJump: Integer;

    function  GetPrevJump(const Value: Integer): Integer;
    function  GetNextJump(const Value: Integer): Integer;

    function  GetPrevGroup(const Value: Integer): Integer;
    function  GetNextGroup(const Value: Integer): Integer;

    function  ItemAtPos(P: TPoint): Integer;

    function  ItemFocused(Index: Integer): Boolean;
    function  ItemSelected(Index: Integer): Boolean;

    property UpdateCount: Integer read FUpdateCount;
    property EditCount: Integer read FEditCount;
    property EditingText: Boolean read GetEditingText;
  end;

  TSCStaticEdit = class(TSCCustomStaticEdit)
  public
    property ItemIndex;
    property Text;
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
    property Items;
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
    property OnCharChange;
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

{ TSCStaticEditBorderProps }

constructor TSCStaticEditBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create(AOwner);
  Border := sccb3DLowered;
  Color := clWindow;
end;

{ TSCStaticEditColors }

procedure TSCStaticEditColors.Assign(Source: TPersistent);
begin
  if Source is TSCStaticEditColors then
  begin
    if FOwner <> nil then FOwner.BeginUpdate;
    try
      with TSCStaticEditColors(Source) do
      begin
        Self.DisabledColor := DisabledColor;
        Self.DisabledTextColor := DisabledTextColor;
        Self.HideSelectionColor := HideSelectionColor;
        Self.HideSelectionTextColor := HideSelectionTextColor;
        Self.HighlightColor := HighlightColor;
        Self.HighlightTextColor := HighlightTextColor;
        Self.GroupSelectionColor := GroupSelectionColor;
        Self.GroupSelectionTextColor := GroupSelectionTextColor; 
      end;
    finally
      if FOwner <> nil then
        FOwner.EndUpdate;
    end;
  end else
    inherited Assign(Source);
end;

procedure TSCStaticEditColors.Changed;
begin
  if FOwner <> nil then FOwner.DoColorsChanged;
end;

constructor TSCStaticEditColors.Create(AOwner: TSCCustomStaticEdit);
begin
  inherited Create;
  FOwner := AOwner;
  FDisabledColor := clBtnFace;
  FDisabledTextColor := clGrayText;
  FHideSelectionColor := clBtnShadow;
  FHideSelectionTextColor := clBtnHighlight;
  FHighlightColor := clHighlight;
  FHighlightTextColor := clHighlightText;
  FGroupSelectionColor := clHighlight;
  FGroupSelectionTextColor := clHighlightText;
end;

function TSCStaticEditColors.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCStaticEditColors.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    Changed;
  end;
end;

procedure TSCStaticEditColors.SetDisabledTextColor(Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    Changed;
  end;
end;

procedure TSCStaticEditColors.SetHideSelectionColor(Value: TColor);
begin
  if FHideSelectionColor <> Value then
  begin
    FHideSelectionColor := Value;
    Changed;
  end;
end;

procedure TSCStaticEditColors.SetHideSelectionTextColor(Value: TColor);
begin
  if FHideSelectionTextColor <> Value then
  begin
    FHideSelectionTextColor := Value;
    Changed;
  end;
end;

procedure TSCStaticEditColors.SetHighlightColor(Value: TColor);
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    Changed;
  end;
end;

procedure TSCStaticEditColors.SetHighlightTextColor(Value: TColor);
begin
  if FHighlightTextColor <> Value then
  begin
    FHighlightTextColor := Value;
    Changed;
  end;
end;

procedure TSCStaticEditColors.SetGroupSelectionColor(Value: TColor);
begin
  if FGroupSelectionColor <> Value then
  begin
    FGroupSelectionColor := Value;
    Changed;
  end;
end;

procedure TSCStaticEditColors.SetGroupSelectionTextColor(Value: TColor);
begin
  if FGroupSelectionTextColor <> Value then
  begin
    FGroupSelectionTextColor := Value;
    Changed;
  end;
end;

{ TSCCustomStaticEdit }

procedure TSCCustomStaticEdit.AdjustBounds;
begin
  AdjustSize;
end;

procedure TSCCustomStaticEdit.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomStaticEdit then
  begin
    with TSCCustomStaticEdit(Source) do
    begin
      Self.AutoSize := AutoSize;
      Self.Colors := Colors;
      Self.HideSelection := HideSelection;
      Self.Picture := Picture;
      Self.PictureProps := PictureProps;
      Self.ReadOnly := ReadOnly;
    end;
  end;
end;

procedure TSCCustomStaticEdit.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TSCCustomStaticEdit.BorderChanged;
begin
  inherited BorderChanged;
  AdjustSize;
end;

function TSCCustomStaticEdit.CanAutoSize(var NewWidth,
  NewHeight: Integer): Boolean;
begin
  Result := True;
  if HandleAllocated then NewHeight := GetAutoHeight;
end;

function TSCCustomStaticEdit.CanBeepForKey(Key: Word;
  Shift: TShiftState): Boolean;
begin
  Result := not IsValidKey(Char(Key));
end;

function TSCCustomStaticEdit.CanGetFocus: Boolean;
begin
  Result := False;
end;

procedure TSCCustomStaticEdit.Clear;
begin

end;

procedure TSCCustomStaticEdit.CMFontChanged(var Message: TMessage);
begin
  inherited;
  InitiateCharList;

  AdjustSize;
  Invalidate;
end;

procedure TSCCustomStaticEdit.CNChar(var Message: TWMChar);
var
  Key: Char;
  ShiftState: TShiftState;
  KeyState: TKeyboardState;
begin
  Inc(FEditCount);
  try
    inherited;
    if not (IsDesigning or FIsMouseDown or MouseIsDown) and not ReadOnly then
    begin
      Key := Char(Message.CharCode);
      if (Key <> ^H) and not IsValidKey(Key) then
      begin
        GetKeyboardState(KeyState);
        ShiftState := KeyboardStateToShiftState(KeyState);

        if CanBeepForKey(Ord(Key), ShiftState) then
          Beep;
      end;
    end;
  finally
    Dec(FEditCount);
  end;
end;

procedure TSCCustomStaticEdit.ConstrainedResize(var MinWidth, MinHeight,
  MaxWidth, MaxHeight: Integer);
begin
  inherited ConstrainedResize(MinWidth, MinHeight, MaxWidth, MaxHeight);
  
  if AutoSize then
  begin
    MinHeight := GetAutoHeight;
    MaxHeight := MinHeight;
  end;
end;

constructor TSCCustomStaticEdit.Create(AOwner: TComponent);
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
  ClickFocus := True;

  FHideSelection := True;
  FItemIndex := -1;

  FIndentLeft := 0;
  FIndentRight := 0;

  FColors := GetColorsClass.Create(Self);
  FItems := TSCStaticEditItems.Create(Self);
end;

procedure TSCCustomStaticEdit.CreateWnd;
begin
  FCreating := True;
  try
    inherited CreateWnd;
  finally
    FCreating := False;
  end;
end;

destructor TSCCustomStaticEdit.Destroy;
begin
  RemoveCharList;
  FreeAndNil(FColors);
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TSCCustomStaticEdit.DoColorsChanged;
begin
  UpdateView;
end;

procedure TSCCustomStaticEdit.DoDrawBack(C: TCanvas);
var
  CR: TRect;
begin
  if C <> nil then
  begin
    CR := GetClientRect;

    if not IsRectEmpty(CR) then
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := GetBackColor(-1);

        FillRect(CR);
      end;

    if Transparent then
      PaintParentOn(C);
  end;
end;

procedure TSCCustomStaticEdit.DoDrawText(C: TCanvas);
var
  CR, R: TRect;
  SR: Integer;
begin
  if C <> nil then
  begin
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
            PaintText(C);
        finally
          SelectClipRgn(C.Handle, 0);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomStaticEdit.DoMouseDown(Button: TMouseButton;
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

procedure TSCCustomStaticEdit.DoPictureListChanged;
begin
  if ShowPicture then
    UpdateView;
end;

procedure TSCCustomStaticEdit.EnabledChanged;
begin
  FIsMouseDown := False;
  Invalidate;
end;

procedure TSCCustomStaticEdit.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    UpdateView;
  end;
end;

function TSCCustomStaticEdit.GetAutoHeight: Integer;
var
  Eh: Integer;
begin
  Result := Height;
  if HandleAllocated then
  begin
    Result := GetLineHeight + 3;

    Eh := GetExtraBorderSize;
    Inc(Result, 2*(GetBorderSize + BorderWidth + GetInnerBorderSize + Eh));
  end;
end;

function TSCCustomStaticEdit.GetBackColor(const Index: Integer): TColor;
var
  IsSelected, IsFocused: Boolean;
begin
  Result := clNone;
  if not Enabled then
  begin
    if FColors <> nil then
      Result := FColors.DisabledColor;

    if Result = clNone then
      Result := GetDefaultBackColor;
  end else
  begin
    if Index < 0 then
      Result := GetDefaultBackColor;

    if not IsDesigning then
    begin
      IsFocused := ItemFocused(Index);
      IsSelected := ItemSelected(Index);

      if IsFocused or IsSelected then
      begin
        Result := clNone;

        if (FColors <> nil) then
        begin
          if HasFocus then
          begin
            Result := FColors.GroupSelectionColor;
            if IsFocused then
              Result := FColors.HighlightColor;
          end else
          if not Self.HideSelection then
            Result := FColors.HideSelectionColor;
        end;
      end;
    end;
  end;

  DoGetBackColor(Index, Result);
  if Assigned(FOnGetBackColor) then
    FOnGetBackColor(Self, Index, Result);
end;

function TSCCustomStaticEdit.GetBlendValue: Word;
begin
  Result := 0;
end;

function TSCCustomStaticEdit.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCStaticEditBorderProps;
end;

function TSCCustomStaticEdit.GetCaption: TCaption;
var
  C: Char;
  I: Integer;
begin
  Result := '';
  if (FItems <> nil) and (FItems.Count > 0) then
    for I := 0 to FItems.Count-1 do
    begin
      C := FItems[I].CharData;
      if Ord(C) < 32 then C := ' ';

      Result := Result + C;
    end;
end;

function TSCCustomStaticEdit.GetCharHeight(C: Char): Integer;
var
  I: Integer;
  P: PPoint;
  L: TList;
begin
  Result := 0;

  L := GetCharList;

  I := Ord(C);
  if (L <> nil) and (I > 0) and (I < L.Count) then
  begin
    P := L.Items[I];
    Result := P^.y;
  end;
end;

function TSCCustomStaticEdit.GetCharList: TList;
begin
  if FCharList = nil then
    InitiateCharList;

  Result := FCharList;
end;

function TSCCustomStaticEdit.GetCharSize(C: Char): TPoint;
var
  I: Integer;
  P: PPoint;
  L: TList;
begin
  Result := Point(0, 0);

  L := GetCharList;

  I := Ord(C);
  if (L <> nil) and (I > 0) and (I < L.Count) then
  begin
    P := L.Items[I];
    Result.x := P^.x;
    Result.y := P^.y;
  end;
end;

function TSCCustomStaticEdit.GetCharWidth(C: Char): Integer;
var
  I: Integer;
  P: PPoint;
  L: TList;
begin
  Result := 0;

  L := GetCharList;

  I := Ord(C);
  if (L <> nil) and (I > 0) and (I < L.Count) then
  begin
    P := L.Items[I];
    Result := P^.x;
  end;
end;

function TSCCustomStaticEdit.GetEditingText: Boolean;
begin
  Result := FEditCount > 0;
end;

function TSCCustomStaticEdit.GetExtraBorderSize: Integer;
begin
  Result := 0;
end;

function TSCCustomStaticEdit.GetForeColor(const Index: Integer): TColor;
var
  IsSelected, IsFocused: Boolean;
begin
  Result := clNone;
  if not Enabled then
  begin
    if FColors <> nil then
      Result := FColors.DisabledTextColor;

    if Result = clNone then
      Result := GetDefaultForeColor;
  end else
  begin
    if Index < 0 then
      Result := GetDefaultForeColor;

    if (FItems <> nil) and (Index > -1) and (Index < FItems.Count) then
    begin
      Result := FItems[Index].Color;

      if not IsDesigning then
      begin
        IsFocused := ItemFocused(Index);
        IsSelected := ItemSelected(Index);

        if (IsFocused or IsSelected) then
        begin
          Result := clNone;

          if (FColors <> nil) then
          begin
            if HasFocus then
            begin
              Result := FColors.GroupSelectionTextColor;
              if IsFocused then
                Result := FColors.HighlightTextColor;
            end else
            if not Self.HideSelection then
              Result := FColors.HideSelectionTextColor;
          end;
        end;
      end;
    end;
  end;

  DoGetForeColor(Index, Result);
  if Assigned(FOnGetForeColor) then
    FOnGetForeColor(Self, Index, Result);
end;

function TSCCustomStaticEdit.GetLineHeight: Integer;
begin
  Result := 0;
  if HandleAllocated then
    Result := ((GetCharHeight('R') + GetCharHeight('q')) div 2) + 1;
end;

function TSCCustomStaticEdit.GetLineWidth(L: Integer): Integer;
var
  S: String;
  Ln, I: Integer;
begin
  Result := 0;

  S := GetCaption;
  Ln := Length(S);

  for I := 1 to Ln do
    Inc(Result, GetCharWidth(S[I]));
end;

function TSCCustomStaticEdit.GetPicturePropsClass: TSCCustomPicturePropsClass;
begin
  Result := TSCStaticEditPictureProps;
end;

function TSCCustomStaticEdit.GetTextWidth(S: String): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
    Inc(Result, GetCharWidth(S[I]));
end;

type
  TCharCanvas = class(TCanvas);

procedure TSCCustomStaticEdit.InitiateCharList;
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

function TSCCustomStaticEdit.IsValidKey(Key: Char): Boolean;
begin
  Result := (Ord(Key) >= 32) or (Key = ^H);
end;

procedure TSCCustomStaticEdit.ItemChanged(Item: TSCStaticEditItem);
begin
  SetItemIndex(GetRealIndex(FItemIndex));
  UpdateView;
end;

procedure TSCCustomStaticEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (FIsMouseDown or MouseIsDown) then
    Exit;

  inherited KeyDown(Key, Shift);

  if (Key <> 0) and Focused then
    ProcessKeyDown(Key);
end;

procedure TSCCustomStaticEdit.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  P: TPoint;
  Index: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if CanFocus and not HasFocus and ClickFocus then
    SetFocus;

  if HasFocus then
  begin
    FIsMouseDown := Button = mbLeft;
    SetCapture(Handle);

    if FIsMouseDown then
    begin
      R := GetEditRect;
      if (Border <> sccbNone) or (BorderInner <> sccbNone) then
        InflateRect(R, 1, 1);

      P := Point(X, Y);
      
      if IsRectEmpty(R) or not PtInRect(R, P) then
        FIsMouseDown := False
      else begin
        if ssDouble in Shift then
          FIsMouseDown := False;

        Index := ItemAtPos(Point(X, Y));
        if (Index > -1) and FItems[Index].Editable then
          SetItemIndex(Index);
      end;
    end;
  end;
end;

procedure TSCCustomStaticEdit.Paint;
var
  R: TRect;
begin
  if HandleAllocated then
  begin
    R := GetClientRect;

    if not IsRectEmpty(R) then
    begin
      DoDrawBack(Canvas);
      DrawPicture(Canvas);

      R := GetEditRect;
      if not IsRectEmpty(R) then
        DoDrawText(Canvas);
    end;
  end;
end;

procedure TSCCustomStaticEdit.PaintText(C: TCanvas);
var
  Ch: Char;
  S: String;
  BCl: TColor;
  CR, R1, R2: TRect;
  I, H, L, R, F, CPos, W: Integer;
begin
  if (C <> nil) and (FItems <> nil) and (FItems.Count > 0) then
  begin
    CR := GetClientRect;

    if not IsRectEmpty(CR) then
    begin
      R1 := GetEditRect;

      if not IsRectEmpty(R1) then
      begin
        IntersectRect(R1, R1, CR);
        if IsRectEmpty(R1) then
          Exit;
    
        H := GetLineHeight;
        if H < 0 then H := 0;
      
        R1.Bottom := R1.Top + H;

        if IsRectEmpty(R1) then Exit;

        C.Font.Assign(Self.Font);
        C.Font.Color := GetForeColor(-1);

        C.Brush.Style := bsClear;

        L := R1.Left;
        R := R1.Right;

        F := DT_EDITCONTROL or DT_SINGLELINE or DT_TOP or
          DT_LEFT or DT_NOPREFIX;

        for I := 0 to FItems.Count-1 do
        begin
          CPos := I;
          if FAlignment = taRightJustify then
            CPos := FItems.Count - (I + 1);

          Ch := FItems[CPos].CharData;
          if Ord(Ch) < 32 then Ch := ' ';

          W := GetCharWidth(Ch);

          if W > 0 then
          begin
            R2 := R1;

            if FAlignment = taLeftJustify then
            begin
              R2.Left := L;
              R2.Right := R2.Left + W;

              if R2.Left >= R1.Right then
                Exit;

              Inc(L, W);
            end else
            begin
              R2.Right := R;
              R2.Left := R2.Right - W;

              if R2.Right <= R1.Left then
                Exit;

              Dec(R, W);
            end;

            C.Font.Color := GetForeColor(CPos);

            BCl := GetBackColor(CPos);
            C.Brush.Color := BCl;

            if BCl = clNone then
              C.Brush.Style := bsClear
            else
              C.Brush.Style := bsSolid;

            S := Ch;
            DrawText(C.Handle, PChar(S), 1, R2, F);
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomStaticEdit.RemoveCharList;
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

procedure TSCCustomStaticEdit.SetItemIndex(Value: Integer);
begin
  Value := GetRealIndex(Value);

  if FItemIndex <> Value then
  begin
    FItemIndex := Value;
    UpdateView;
  end;
end;

procedure TSCCustomStaticEdit.SetColors(Value: TSCStaticEditColors);
begin
  FColors.Assign(Value);
end;

procedure TSCCustomStaticEdit.SetHideSelection(Value: Boolean);
begin
  if FHideSelection <> Value then
  begin
    FHideSelection := Value;
    if not Focused then
      UpdateView;
  end;
end;

procedure TSCCustomStaticEdit.SetItems(Value: TSCStaticEditItems);
begin
  FItems.Assign(Value);
end;

procedure TSCCustomStaticEdit.SetReadonly(Value: Boolean);
begin
  if FReadonly <> Value then
  begin
    FReadonly := Value;
    UpdateView;
  end;
end;

procedure TSCCustomStaticEdit.StopTracking;
begin
  FIsMouseDown  := False;
  inherited StopTracking;
end;

function TSCCustomStaticEdit.UpdateKey(Key: Char): Char;
begin
  Result := Key;
  if not IsValidKey(Key) then
    Result := #0;
end;

procedure TSCCustomStaticEdit.UpdateView;
begin
  if FUpdateCount = 0 then
    Invalidate;
end;

procedure TSCCustomStaticEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTCHARS or DLGC_WANTARROWS;
end;

function TSCCustomStaticEdit.GetRealIndex(const Value: Integer): Integer;
var
  Found: Boolean;
  I, Cnt: Integer;
begin
  Result := Value;
  if Result < 0 then Result := 0;

  Cnt := 0;
  if FItems <> nil then Cnt := FItems.Count;
  if Result > Cnt-1 then Result := Cnt-1;

  if (Result > -1) and (FItems <> nil) and (FItems.Count > -1) then
  begin
    Found := False;
    for I := Result to FItems.Count-1 do
      if FItems[I].Editable then
      begin
        Found := True;

        Result := I;
        Break;
      end;

    if not Found then
      for I := Result-1 downto 0 do
        if FItems[I].Editable then
        begin
          Found := True;

          Result := I;
          Break;
        end;

    if not Found then
      Result := -1;
  end;
end;

function TSCCustomStaticEdit.GetEditRect: TRect;
var
  R: TRect;
  Eh, Ew, B: Integer;
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

  if Result.Left < R.Left then Result.Left := R.Left;
  if Result.Left > R.Right then Result.Left := R.Right;
  if Result.Right < R.Left then Result.Right := R.Left;
  if Result.Right > R.Right then Result.Right := R.Right;

  InflateRect(Result, 0, -B);

  if Result.Top < R.Top then Result.Top := R.Top;
  if Result.Top > R.Bottom then Result.Top := R.Bottom;
  if Result.Bottom < R.Top then Result.Bottom := R.Top;
  if Result.Bottom > R.Bottom then Result.Bottom := R.Bottom;
end;

procedure TSCCustomStaticEdit.Loaded;
begin
  inherited Loaded;
  SetItemIndex(GetRealIndex(FItemIndex));
end;

function TSCCustomStaticEdit.ItemAtPos(P: TPoint): Integer;
var
  Ch: Char;
  CR, R1, R2: TRect;
  I, H, L, R, CPos, W: Integer;
begin
  Result := -1;
  if (FItems <> nil) and (FItems.Count > 0) then
  begin
    CR := GetClientRect;

    if not IsRectEmpty(CR) then
    begin
      R1 := GetEditRect;

      if not IsRectEmpty(R1) then
      begin
        IntersectRect(R1, R1, CR);
        if IsRectEmpty(R1) then Exit;
    
        H := GetLineHeight;
        if H < 0 then H := 0;
      
        R1.Bottom := R1.Top + H;

        if IsRectEmpty(R1) then Exit;

        L := R1.Left;
        R := R1.Right;
        
        for I := 0 to FItems.Count-1 do
        begin
          CPos := I;
          if FAlignment = taRightJustify then
            CPos := FItems.Count - (I + 1);

          Ch := FItems[CPos].CharData;
          if Ord(Ch) < 32 then Ch := ' ';

          W := GetCharWidth(Ch);

          if W > 0 then
          begin
            R2 := R1;

            if FAlignment = taLeftJustify then
            begin
              R2.Left := L;
              R2.Right := R2.Left + W;

              if PtInRect(R2, P) then
              begin
                Result := CPos;
                Break;
              end;

              if R2.Left >= R1.Right then
                Exit;

              Inc(L, W);
            end else
            begin
              R2.Right := R;
              R2.Left := R2.Right - W;

              if PtInRect(R2, P) then
              begin
                Result := CPos;
                Break;
              end;

              if R2.Right <= R1.Left then
                Exit;

              Dec(R, W);
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TSCCustomStaticEdit.GetNextJump(const Value: Integer): Integer;
var
  Found: Boolean;
  I, Cnt: Integer;
begin
  Result := Value + 1;
  if Result < 0 then Result := 0;

  Cnt := 0;
  if FItems <> nil then Cnt := FItems.Count;
  if Result > Cnt-1 then Result := Cnt-1;

  if (Result > -1) and (FItems <> nil) and (FItems.Count > -1) then
  begin
    Found := False;
    for I := Result to FItems.Count-1 do
      if FItems[I].Editable then
      begin
        Found := True;

        Result := I;
        Break;
      end;

    if not Found then
      for I := Result-1 downto 0 do
        if FItems[I].Editable then
        begin
          Found := True;

          Result := I;
          Break;
        end;

    if not Found then
      Result := -1;
  end;
end;

function TSCCustomStaticEdit.GetPrevJump(const Value: Integer): Integer;
var
  Found: Boolean;
  I, Cnt: Integer;
begin
  Result := Value - 1;
  if Result < 0 then Result := 0;

  Cnt := 0;
  if FItems <> nil then Cnt := FItems.Count;
  if Result > Cnt-1 then Result := Cnt-1;

  if (Result > -1) and (FItems <> nil) and (FItems.Count > -1) then
  begin
    Found := False;
    for I := Result downto 0 do
      if FItems[I].Editable then
      begin
        Found := True;

        Result := I;
        Break;
      end;

    if not Found then
      for I := Result+1 to FItems.Count-1 do
        if FItems[I].Editable then
        begin
          Found := True;

          Result := I;
          Break;
        end;

    if not Found then
      Result := -1;
  end;
end;

function TSCCustomStaticEdit.GetFirstJump: Integer;
var
  I: Integer;
begin
  Result := -1;
  if (FItems <> nil) and (FItems.Count > -1) then
    for I := 0 to FItems.Count-1 do
      if FItems[I].Editable then
      begin
        Result := I;
        Break;
      end;
end;

function TSCCustomStaticEdit.GetLastJump: Integer;
var
  I: Integer;
begin
  Result := -1;
  if (FItems <> nil) and (FItems.Count > -1) then
    for I := FItems.Count-1 downto 0 do
      if FItems[I].Editable then
      begin
        Result := I;
        Break;
      end;
end;

procedure TSCCustomStaticEdit.DoGetChar(var C: Char; const Index: Integer;
  var Allowed: Boolean);
begin
  //
end;

procedure TSCCustomStaticEdit.GetChar(var C: Char; Index: Integer;
  var Allowed: Boolean);
begin
  Allowed := not FReadonly;

  if Allowed then
  begin
    if Assigned(FOnGetChar) then
      FOnGetChar(Self, C, Index, Allowed);

    DoGetChar(C, Index, Allowed);
  end;
end;

function TSCCustomStaticEdit.SetChar(C: Char): Boolean;
var
  Ch: Char;
begin
  Result := False;
  if not FReadonly and (FItems <> nil) and (FItemIndex > -1) and
    (FItemIndex < FItems.Count) and FItems[FItemIndex].Editable then
  begin
    Ch := C;
    Result := True;

    DoGetChar(Ch, FItemIndex, Result);

    if Result then
      FItems[FItemIndex].CharData := C;
  end;
end;

procedure TSCCustomStaticEdit.ProcessKeyDown(var Key: Word);
begin
  case Key of
    VK_LEFT, VK_UP:
      SetItemIndex(GetPrevJump(FItemIndex));
    VK_RIGHT, VK_DOWN:
      SetItemIndex(GetNextJump(FItemIndex));
    VK_HOME:
      SetItemIndex(GetFirstJump);
    VK_END:
      SetItemIndex(GetLastJump);
    VK_DELETE:
    begin
      if (FItemIndex > -1) and (FItemIndex < FItems.Count) and
        not FReadonly and FItems[FItemIndex].Editable then
      begin
        SetChar(#0);
        SetItemIndex(GetNextJump(FItemIndex));
      end;
    end;
    VK_BACK:
    begin
      if (FItemIndex > -1) and (FItemIndex < FItems.Count) and
        not FReadonly and FItems[FItemIndex].Editable then
      begin
        SetChar(#0);
        SetItemIndex(GetPrevJump(FItemIndex));
      end;
    end;
  end;
end;

procedure TSCCustomStaticEdit.ProcessKeyPress(var Key: Char);
begin
  if not FReadonly and (FItemIndex > -1) and (FItemIndex < FItems.Count) and
    FItems[FItemIndex].Editable and SetChar(Key) then
    SetItemIndex(GetNextJump(FItemIndex));
end;

procedure TSCCustomStaticEdit.KeyPress(var Key: Char);
begin
  if (FIsMouseDown or MouseIsDown) then
    Exit;

  inherited KeyPress(Key);

  if not ReadOnly and Focused and
    not (Key in [^H, #127]) and IsValidKey(Key) then
    ProcessKeyPress(Key);
end;

procedure TSCCustomStaticEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if not (FIsMouseDown or MouseIsDown) then
    inherited KeyUp(Key, Shift);
end;

procedure TSCCustomStaticEdit.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FIsMouseDown := False;
  inherited MouseUp(Button, Shift, X, Y);
end;

function TSCCustomStaticEdit.GetNextGroup(const Value: Integer): Integer;
var
  I, Cnt: Integer;
  Found, SepFound: Boolean;
begin
  Result := Value + 1;
  if Result < 0 then Result := 0;

  Cnt := 0;
  if FItems <> nil then Cnt := FItems.Count;
  if Result > Cnt-1 then Result := Cnt-1;

  if (Result > -1) and (FItems <> nil) and (FItems.Count > -1) then
  begin
    Found := False;
    SepFound := False;
    
    for I := Result to FItems.Count-1 do
    begin
      if FItems[I].Editable then
        SepFound := True
      else
      if SepFound then
      begin
        Found := True;

        Result := I;
        Break;
      end;
    end;

    if not Found then
      for I := FItems.Count-1 downto 0 do
        if FItems[I].Editable then
        begin
          Found := True;

          Result := I;
          Break;
        end;

    if not Found then
      Result := -1;
  end;
end;

function TSCCustomStaticEdit.GetPrevGroup(const Value: Integer): Integer;
var
  I, Cnt: Integer;
  Found, SepFound: Boolean;
begin
  Result := Value + 1;
  if Result < 0 then Result := 0;

  Cnt := 0;
  if FItems <> nil then Cnt := FItems.Count;
  if Result > Cnt-1 then Result := Cnt-1;

  if (Result > -1) and (FItems <> nil) and (FItems.Count > -1) then
  begin
    Found := False;
    SepFound := False;
    
    for I := Result-1 downto 0 do
    begin
      if FItems[I].Editable then
        SepFound := True
      else
      if SepFound then
      begin
        Found := True;

        Result := I;
        Break;
      end;
    end;

    if not Found then
      for I := 0 to FItems.Count-1 do
        if FItems[I].Editable then
        begin
          Found := True;

          Result := I;
          Break;
        end;

    if not Found then
      Result := -1;
  end;
end;

procedure TSCCustomStaticEdit.DoEditValueChanged;
begin
  //
end;

procedure TSCCustomStaticEdit.EditValueChanged;
begin
  if FEditCount = 0 then
  begin
    Change;
    
    DoEditValueChanged;
    if Assigned(FOnEditValue) then
      FOnEditValue(Self);
  end;
end;

procedure TSCCustomStaticEdit.ItemValueChanged(Index: Integer);
begin
  DoItemValueChanged(Index);
  if Assigned(FOnCharChange) then
    FOnCharChange(Self, Index);
end;

procedure TSCCustomStaticEdit.DoItemValueChanged(Index: Integer);
begin
  //
end;

procedure TSCCustomStaticEdit.BeginEdit;
begin
  Inc(FEditCount);
end;

procedure TSCCustomStaticEdit.EndEdit;
begin
  if FEditCount > 0 then
  begin
    Dec(FEditCount);
    if FEditCount = 0 then
      EditValueChanged;
  end;
end;

procedure TSCCustomStaticEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  P: TPoint;
  Index: Integer;
begin
  if FIsMouseDown and HasFocus and MouseCapture then
  begin
    R := GetEditRect;
    if (Border <> sccbNone) or (BorderInner <> sccbNone) then
      InflateRect(R, 1, 1);

    P := Point(X, Y);

    if not IsRectEmpty(R) then
    begin
      if (P.y <= R.Top) or (P.y >= R.Bottom) then
        P.y := R.Top + 2;

      Index := ItemAtPos(P);
      if (Index > -1) and FItems[Index].Editable then
        SetItemIndex(Index);
    end;
  end;

  inherited MouseMove(Shift, X, Y);
end;

function TSCCustomStaticEdit.ItemFocused(Index: Integer): Boolean;
begin
  Result := (FItems <> nil) and (Index = FItemIndex) and
    (Index > -1) and (Index < FItems.Count) and
    FItems[Index].Editable;
end;

function TSCCustomStaticEdit.ItemSelected(Index: Integer): Boolean;
var
  Fi, Ci: TSCStaticEditItem;
begin
  Result := False;
  if (FItems <> nil) and (Index > -1) and
    (Index < FItems.Count) and FItems[Index].Editable then
  begin
     Result := Index = FItemIndex;

     if not Result and (Index <> FItemIndex) and
       (FItemIndex > -1) and (FItemIndex < FItems.Count) then
     begin
       Ci := FItems[Index];
       Fi := FItems[FItemIndex];

       Result := Fi.Editable and (Fi.GroupIndex <> 0) and
         (Ci.GroupIndex = Fi.GroupIndex);
     end;
  end;
end;

function TSCCustomStaticEdit.GetColorsClass: TSCStaticEditColorsClass;
begin
  Result := TSCStaticEditColors;
end;

function TSCCustomStaticEdit.GetDefaultBackColor: TColor;
begin
  Result := clBtnFace;
  if Enabled then
  begin
    Result := Self.Color;
    if Result = clNone then
      Result := clWindow;
  end;
end;

function TSCCustomStaticEdit.GetDefaultForeColor: TColor;
begin
  Result := clNone;

  if HandleAllocated then
  begin
    Result := clGrayText;

    if Enabled then
    begin
      Result := clWindowText;
      if Self.Font <> nil then
        Result := Self.Font.Color;
    end;
  end;

  if Result = clNone then
    Result := clWindowText;
end;

procedure TSCCustomStaticEdit.DoGetBackColor(const Index: Integer;
  var C: TColor);
begin
  //
end;

procedure TSCCustomStaticEdit.DoGetForeColor(const Index: Integer;
  var C: TColor);
begin
  if C = clNone then
  begin
    C := GetDefaultForeColor;
    if HandleAllocated and (Self.Font <> nil) then
      C := Self.Font.Color;
  end;
end;

procedure TSCCustomStaticEdit.SetAlignment(Value: TLeftRight);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    if FItems.Count > 0 then
      Invalidate;
  end;
end;

{ TSCStaticEditItem }

procedure TSCStaticEditItem.Assign(Source: TPersistent);
begin
  if Source is TSCStaticEditItem then
  begin
    with TSCStaticEditItem(Source) do
    begin
      Self.FCharData := CharData;
      Self.FColor := Color;
      Self.FEditable := Editable;
      Self.FGroupIndex := GroupIndex;
      Self.FTag := Tag;
    end;

    Changed(True);
  end else
    inherited Assign(Source);
end;

constructor TSCStaticEditItem.Create(Collection: TCollection);
begin
  FCharData := '0';
  FColor := clNone;
  FEditable := True;
  FGroupIndex := 0;
  FTag := 0;
  inherited Create(Collection);
end;

function TSCStaticEditItem.GetDisplayName: String;
begin
  Result := FCharData;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

function TSCStaticEditItem.GetRangedValue(C: Char; var Allowed: Boolean): Char;
var
  E: TSCCustomStaticEdit;
begin
  Result := C;
  Allowed := False;

  E := StaticEdit;
  if E <> nil then
  begin
    Allowed := True;
    E.GetChar(Result, Self.Index, Allowed);
  end;
end;

function TSCStaticEditItem.GetStaticEdit: TSCCustomStaticEdit;
begin
  Result := nil;
  if (Collection <> nil) and (Collection is TSCStaticEditItems) then
    Result := TSCStaticEditItems(Collection).FOwner;
end;

procedure TSCStaticEditItem.SetCharData(const Value: Char);
var
  C: Char;
  Allowed: Boolean;
  E: TSCCustomStaticEdit;
begin
  Allowed := True;
  C := GetRangedValue(Value, Allowed);

  if Allowed and (FCharData <> C) then
  begin
    FCharData := C;
    Changed(True);

    E := StaticEdit;
    if E <> nil then
    begin
      Allowed := True;
      
      E.ItemValueChanged(Self.Index);
      E.EditValueChanged;
    end;
  end;
end;

procedure TSCStaticEditItem.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed(True);
  end;
end;

procedure TSCStaticEditItem.SetEditable(Value: Boolean);
begin
  if FEditable <> Value then
  begin
    FEditable := Value;
    Changed(True);
  end;
end;

procedure TSCStaticEditItem.SetGroupIndex(Value: Integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    Changed(True);
  end;
end;

procedure TSCStaticEditItem.SetTag(Value: Integer);
begin
  FTag := Value;
end;

{ TSCStaticEditItems }

function TSCStaticEditItems.Add: TSCStaticEditItem;
begin
  Result := TSCStaticEditItem(inherited Add);
end;

procedure TSCStaticEditItems.Assign(Source: TPersistent);
begin
  if FOwner <> nil then FOwner.BeginUpdate;
  try
    inherited Assign(Source);
  finally
    if FOwner <> nil then FOwner.EndUpdate;
  end;
end;

constructor TSCStaticEditItems.Create(AOwner: TSCCustomStaticEdit);
begin
  inherited Create(TSCStaticEditItem);
  FOwner := AOwner;
end;

function TSCStaticEditItems.GetItem(Index: Integer): TSCStaticEditItem;
begin
  Result := TSCStaticEditItem(inherited GetItem(Index));
end;

function TSCStaticEditItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCStaticEditItems.SetItem(Index: Integer;
  Value: TSCStaticEditItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCStaticEditItems.Update(Item: TCollectionItem);
begin
  if FOwner <> nil then
  begin
    if Item = nil then
      FOwner.ItemChanged(nil)
    else FOwner.ItemChanged(TSCStaticEditItem(Item));
  end;
end;

{$I SCVerRec.inc}

end.
