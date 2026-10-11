{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCMenu;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ImgList, {$IFDEF SC_DELPHI6_UP} Variants, Types, {$ENDIF}
  SCCommon, SCConsts, SCControl, SCGradient;

type
  TSCMenu = class;
  TSCMenuItem = class;

  TSCMenuDrawItemEvent = procedure (Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; Selected: Boolean; var Handled: Boolean) of object;
  TSCMenuMeasureItemEvent = procedure (Sender: TObject; ACanvas: TCanvas;
    var Width, Height: Integer; var Handled: Boolean) of object;

  TSCMenuItem = class(TPersistent)
  private
    FAlignment: TAlignment;
    FCaption: String;
    FChecked: Boolean;
    FEnabled: Boolean;
    FDefault: Boolean;
    FRadioItem: Boolean;
    FVisible: Boolean;
    FGroupIndex: Byte;
    FImageIndex: TImageIndex;
    FLineBefore: Boolean;
    FHint: String;
    FItems: TList;
    FShortCut: TShortCut;
    FParent: TSCMenuItem;
    FMenu: TSCMenu;
    FOnClick: TNotifyEvent;
    FOnDrawItem: TSCMenuDrawItemEvent;
    FOnMeasureItem: TSCMenuMeasureItemEvent;
    procedure SetAlignment(Value: TAlignment);
    procedure SetCaption(const Value: String);
    procedure SetChecked(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetDefault(Value: Boolean);
    procedure SetRadioItem(Value: Boolean);
    procedure SetVisible(Value: Boolean);
    procedure SetGroupIndex(Value: Byte);
    procedure SetLineBefore(Value: Boolean);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetHint(const Value: String);
    procedure SetShortCut(Value: TShortCut);
    function  GetCount: Integer;
    function  GetItem(Index: Integer): TSCMenuItem;
    function  GetIndex: Integer;
    procedure SetIndex(Value: Integer);
    procedure VerifyGroupIndex(Position: Integer; Value: Byte);
  protected
    procedure Changed(Force: Boolean = False);
    procedure TurnSiblingsOff;

    procedure DrawItem(ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure DoDrawItem(ACanvas: TCanvas; ARect: TRect; Selected: Boolean;
      var Handled: Boolean); virtual;
    procedure DoDrawText(ACanvas: TCanvas; const ACaption: string;
      var Rect: TRect; Selected: Boolean; Flags: Longint);
    procedure MeasureItem(ACanvas: TCanvas; var Width, Height: Integer);
    procedure DoMeasureItem(ACanvas: TCanvas; var Width, Height: Integer;
      var Handled: Boolean); virtual;
  public
    constructor Create(AMenu: TSCMenu); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Clear;
    procedure Click;
    procedure DoClick; virtual;

    procedure Insert(Index: Integer; Item: TSCMenuItem);
    procedure Delete(Index: Integer);
    function  IndexOf(Item: TSCMenuItem): Integer;
    procedure Add(Item: TSCMenuItem); overload;
    procedure Add(const AItems: array of TSCMenuItem); overload;
    procedure Remove(Item: TSCMenuItem);

    property Menu: TSCMenu read FMenu;
    property Parent: TSCMenuItem read FParent;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSCMenuItem read GetItem; default;
    property Index: Integer read GetIndex write SetIndex;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Caption: String read FCaption write SetCaption;
    property Checked: Boolean read FChecked write SetChecked default False;
    property Default: Boolean read FDefault write SetDefault default False;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property GroupIndex: Byte read FGroupIndex write SetGroupIndex default 0;
    property Hint: String read FHint write SetHint;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property LineBefore: Boolean read FLineBefore write SetLineBefore default False;
    property RadioItem: Boolean read FRadioItem write SetRadioItem default False;
    property ShortCut: TShortCut read FShortCut write SetShortCut default 0;
    property Visible: Boolean read FVisible write SetVisible default True;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDrawItem: TSCMenuDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnMeasureItem: TSCMenuMeasureItemEvent read FOnMeasureItem write FOnMeasureItem;
  end;

  TSCMenu = class(TComponent)
  private
    FItems: TList;
    FImages: TCustomImageList;
    FImageChangeLink: TChangeLink;
    FOnClick: TNotifyEvent;
    FOnDrawItem: TSCMenuDrawItemEvent;
    FOnMeasureItem: TSCMenuMeasureItemEvent;
    procedure SetImages(Value: TCustomImageList);
    function  GetCount: Integer;
    function  GetItem(Index: Integer): TSCMenuItem;
    procedure VerifyGroupIndex(Position: Integer; Value: Byte);
    procedure TurnSiblingsOff(Item: TSCMenuItem);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure Changed;
    procedure ImageListChange(Sender: TObject);

    procedure DrawItem(AItem: TSCMenuItem; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean; var Handled: Boolean);
    procedure DoDrawItem(AItem: TSCMenuItem; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean; var Handled: Boolean); virtual;

    procedure MeasureItem(AItem: TSCMenuItem; ACanvas: TCanvas;
      var Width, Height: Integer; var Handled: Boolean); virtual;
    procedure DoMeasureItem(AItem: TSCMenuItem; ACanvas: TCanvas;
      var Width, Height: Integer; var Handled: Boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Clear;
    procedure Click;
    procedure DoClick; virtual;

    procedure Insert(Index: Integer; Item: TSCMenuItem);
    procedure Delete(Index: Integer);
    function  IndexOf(Item: TSCMenuItem): Integer;
    procedure Add(Item: TSCMenuItem); overload;
    procedure Add(const AItems: array of TSCMenuItem); overload;
    procedure Remove(Item: TSCMenuItem);

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSCMenuItem read GetItem; default;
  published
    property Images: TCustomImageList read FImages write SetImages;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDrawItem: TSCMenuDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnMeasureItem: TSCMenuMeasureItemEvent read FOnMeasureItem write FOnMeasureItem;
  end;

  TSCCustomMenuControl = class(TSCCustomControl)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{.$I SCVerRec.inc}

{ TSCMenuItem }

procedure TSCMenuItem.Add(Item: TSCMenuItem);
begin
  Insert(GetCount, Item);
end;

procedure TSCMenuItem.Add(const AItems: array of TSCMenuItem);
var
  I: Integer;
begin
  for I := Low(AItems) to High(AItems) do
    Add(AItems[I]);
end;

procedure TSCMenuItem.Assign(Source: TPersistent);
begin
  if Source is TSCMenuItem then
  begin
    with TSCMenuItem(Source) do
    begin
      Self.FAlignment := Alignment;
      Self.FVisible := Visible;
      Self.FCaption := Caption;
      Self.FEnabled := Enabled;
      Self.FHint := Hint;
      Self.FLineBefore := LineBefore;
      Self.FShortCut := ShortCut;
      Self.FImageIndex := ImageIndex;

      Self.Default := Default;
      Self.Checked := Checked;
      Self.GroupIndex := GroupIndex;
      Self.RadioItem := RadioItem;
    end;

    Changed;
  end else
    inherited Assign(Source);
end;

procedure TSCMenuItem.Changed(Force: Boolean);
begin
  if (FMenu <> nil) and (Force or Visible) then
    FMenu.Changed;
end;

procedure TSCMenuItem.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    Items[I].Free;
end;

procedure TSCMenuItem.Click;
begin
  if Enabled then
  begin
    if FMenu <> nil then
      FMenu.Click;

    DoClick;
    if Assigned(FOnClick) then
      FOnClick(Self);
  end;
end;

constructor TSCMenuItem.Create(AMenu: TSCMenu);
begin
  inherited Create;
  FMenu := AMenu;
  FAlignment := taLeftJustify;
  FChecked := False;
  FDefault := False;
  FEnabled := True;
  FGroupIndex := 0;
  FImageIndex := -1;
  FLineBefore := False;
  FRadioItem := False;
  FShortCut := 0;
  FVisible := True;
end;

procedure TSCMenuItem.Delete(Index: Integer);
var
  AItem: TSCMenuItem;
begin
  if (Index > 0) and (FItems <> nil) or (Index < GetCount) then
  begin
    AItem := FItems[Index];
    FItems.Delete(Index);
    AItem.FParent := nil;

    Changed;
  end;
end;

destructor TSCMenuItem.Destroy;
begin
  if FParent <> nil then
  begin
    FParent.Remove(Self);
    FParent := nil;
  end;
  
  if FMenu <> nil then
  begin
    FMenu.Remove(Self);
    FMenu := nil;
  end;

  Clear;
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TSCMenuItem.DoClick;
begin

end;

procedure TSCMenuItem.DoDrawItem(ACanvas: TCanvas; ARect: TRect;
  Selected: Boolean; var Handled: Boolean);
begin

end;

procedure TSCMenuItem.DoDrawText(ACanvas: TCanvas; const ACaption: string;
  var Rect: TRect; Selected: Boolean; Flags: Integer);
begin

end;

procedure TSCMenuItem.DoMeasureItem(ACanvas: TCanvas; var Width,
  Height: Integer; var Handled: Boolean);
begin

end;

procedure TSCMenuItem.DrawItem(ACanvas: TCanvas; ARect: TRect;
  Selected: Boolean);
var
  Handled: Boolean;
begin
  Handled := False;
  DoDrawItem(ACanvas, ARect, Selected, Handled);

  if not Handled then
  begin
    if Assigned(FOnDrawItem) then
      FOnDrawItem(Self, ACanvas, ARect, Selected, Handled);

    if not Handled and (FMenu <> nil) then
      FMenu.DrawItem(Self, ACanvas, ARect, Selected, Handled);
  end;
end;

function TSCMenuItem.GetCount: Integer;
begin
  Result := 0;
  if FItems <> nil then Result := FItems.Count;
end;

function TSCMenuItem.GetIndex: Integer;
begin
  Result := -1;
  if FParent <> nil then Result := FParent.IndexOf(Self);
end;

function TSCMenuItem.GetItem(Index: Integer): TSCMenuItem;
begin
  Result := nil;
  if FItems <> nil then Result := FItems[Index];
end;

function TSCMenuItem.IndexOf(Item: TSCMenuItem): Integer;
begin
  Result := -1;
  if FItems <> nil then Result := FItems.IndexOf(Item);
end;

procedure TSCMenuItem.Insert(Index: Integer; Item: TSCMenuItem);
var
  AItem: TSCMenuItem;
begin
  if (Item <> nil) and (Item.Menu = Self.FMenu) then
  begin
    if FItems = nil then FItems := TList.Create;

    if Item.Parent <> nil then
      Item.Parent.Remove(Self)
    else if Item.Menu <> nil then
      Item.Menu.Remove(Item);

    if (Index - 1 >= 0) and (Index - 1 < FItems.Count) then
    begin
      AItem := TSCMenuItem(FItems[Index - 1]);
      if Item.GroupIndex < AItem.GroupIndex then
        Item.GroupIndex := AItem.GroupIndex;
    end;

    VerifyGroupIndex(Index, Item.GroupIndex);
    FItems.Insert(Index, Item);
    Item.FParent := Self;
    Changed;
  end;
end;

procedure TSCMenuItem.MeasureItem(ACanvas: TCanvas; var Width,
  Height: Integer);
begin

end;

procedure TSCMenuItem.Remove(Item: TSCMenuItem);
var
  AIndex: Integer;
begin
  AIndex := IndexOf(Item);
  if AIndex > -1 then Delete(AIndex);
end;

procedure TSCMenuItem.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Changed;
  end;
end;

procedure TSCMenuItem.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed;
  end;
end;

procedure TSCMenuItem.SetChecked(Value: Boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    if Value and FRadioItem then
      TurnSiblingsOff;
  end;
end;

procedure TSCMenuItem.SetDefault(Value: Boolean);
var
  I: Integer;
begin
  if FDefault <> Value then
  begin
    if Value and (FParent <> nil) then
      for I := 0 to FParent.Count - 1 do
        if FParent[I].Default then FParent[I].FDefault := False;

    FDefault := Value;
    Changed;
  end;
end;

procedure TSCMenuItem.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed;
  end;
end;

procedure TSCMenuItem.SetGroupIndex(Value: Byte);
begin
  if FGroupIndex <> Value then
  begin
    if Parent <> nil then
      Parent.VerifyGroupIndex(Parent.IndexOf(Self), Value);
      
    FGroupIndex := Value;
    if FChecked and FRadioItem then
      TurnSiblingsOff;
  end;
end;

procedure TSCMenuItem.SetHint(const Value: String);
begin
  FHint := Value;
end;

procedure TSCMenuItem.SetImageIndex(Value: TImageIndex);
begin
  if Value <> FImageIndex then
  begin
    FImageIndex := Value;
    Changed;
  end;
end;

procedure TSCMenuItem.SetIndex(Value: Integer);
var
  ACount: Integer;
  AParent: TSCMenuItem;
begin
  if FParent <> nil then
  begin
    ACount := FParent.Count;

    if Value < 0 then Value := 0;
    if Value >= ACount then Value := ACount - 1;

    if Value <> GetIndex then
    begin
      AParent := FParent;
      AParent.Remove(Self);
      AParent.Insert(Value, Self);
    end;
  end;
end;

procedure TSCMenuItem.SetLineBefore(Value: Boolean);
begin
  if FLineBefore <> Value then
  begin
    FLineBefore := Value;
    Changed;
  end;
end;

procedure TSCMenuItem.SetRadioItem(Value: Boolean);
begin
  if FRadioItem <> Value then
  begin
    FRadioItem := Value;
    if FChecked and FRadioItem then
      TurnSiblingsOff;
    Changed;
  end;
end;

procedure TSCMenuItem.SetShortCut(Value: TShortCut);
begin
  if FShortCut <> Value then
  begin
    FShortCut := Value;
    Changed;
  end;
end;

procedure TSCMenuItem.SetVisible(Value: Boolean);
begin
  if Value <> FVisible then
  begin
    FVisible := Value;
    Changed(True);
  end;
end;

procedure TSCMenuItem.TurnSiblingsOff;
var
  I: Integer;
  AItem: TSCMenuItem;
begin
  if (FParent = nil) and (FMenu <> nil) then
  begin
    I := FMenu.IndexOf(Self);
    if I > -1 then
      FMenu.TurnSiblingsOff(Self);
  end else
  if FParent <> nil then
    for I := 0 to FParent.Count - 1 do
    begin
      AItem := FParent[I];
      if (AItem <> Self) and AItem.FRadioItem and (AItem.GroupIndex = GroupIndex) then
        AItem.SetChecked(False);
    end;
end;

procedure TSCMenuItem.VerifyGroupIndex(Position: Integer; Value: Byte);
var
  I: Integer;
begin
  for I := 0 to GetCount - 1 do
    if (I >= Position) and (Items[I].GroupIndex < Value) then
      Items[I].FGroupIndex := Value;
end;

{ TSCMenu }

procedure TSCMenu.Add(const AItems: array of TSCMenuItem);
var
  I: Integer;
begin
  for I := Low(AItems) to High(AItems) do
    Add(AItems[I]);
end;

procedure TSCMenu.Add(Item: TSCMenuItem);
begin
  Insert(GetCount, Item);
end;

procedure TSCMenu.Changed;
begin

end;

procedure TSCMenu.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    Items[I].Free;
end;

procedure TSCMenu.Click;
begin

end;

constructor TSCMenu.Create(AOwner: TComponent);
begin
  FItems := TList.Create;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  inherited Create(AOwner);
end;

procedure TSCMenu.Delete(Index: Integer);
var
  AItem: TSCMenuItem;
begin
  if (Index > 0) and (FItems <> nil) or (Index < GetCount) then
  begin
    AItem := FItems[Index];
    FItems.Delete(Index);
    AItem.FParent := nil;

    Changed;
  end;
end;

destructor TSCMenu.Destroy;
begin
  Clear;
  FreeAndNil(FItems);
  FreeAndNil(FImageChangeLink);
  inherited Destroy;
end;

procedure TSCMenu.DoClick;
begin

end;

procedure TSCMenu.DoDrawItem(AItem: TSCMenuItem; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean; var Handled: Boolean);
begin

end;

procedure TSCMenu.DoMeasureItem(AItem: TSCMenuItem; ACanvas: TCanvas;
  var Width, Height: Integer; var Handled: Boolean);
begin

end;

procedure TSCMenu.DrawItem(AItem: TSCMenuItem; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean; var Handled: Boolean);
begin
  DoDrawItem(AItem, ACanvas, ARect, Selected, Handled);
  if not Handled and Assigned(FOnDrawItem) then
    FOnDrawItem(AItem, ACanvas, ARect, Selected, Handled);
end;

function TSCMenu.GetCount: Integer;
begin
  Result := 0;
  if FItems <> nil then Result := FItems.Count;
end;

function TSCMenu.GetItem(Index: Integer): TSCMenuItem;
begin
  Result := nil;
  if FItems <> nil then Result := FItems[Index];
end;

procedure TSCMenu.ImageListChange(Sender: TObject);
begin
  Changed;
end;

function TSCMenu.IndexOf(Item: TSCMenuItem): Integer;
begin
  Result := -1;
  if FItems <> nil then Result := FItems.IndexOf(Item);
end;

procedure TSCMenu.Insert(Index: Integer; Item: TSCMenuItem);
var
  AItem: TSCMenuItem;
begin
  if (Item <> nil) and (Item.Menu = Self) then
  begin
    if FItems = nil then FItems := TList.Create;

    if Item.Parent <> nil then
      Item.Parent.Remove(Item)
    else if Item.Menu <> nil then
      Item.Menu.Remove(Item);

    if (Index - 1 >= 0) and (Index - 1 < FItems.Count) then
    begin
      AItem := TSCMenuItem(FItems[Index - 1]);
      if Item.GroupIndex < AItem.GroupIndex then
        Item.GroupIndex := AItem.GroupIndex;
    end;

    VerifyGroupIndex(Index, Item.GroupIndex);
    FItems.Insert(Index, Item);

    Changed;
  end;
end;

procedure TSCMenu.MeasureItem(AItem: TSCMenuItem; ACanvas: TCanvas;
  var Width, Height: Integer; var Handled: Boolean);
begin
  DoMeasureItem(AItem, ACanvas, Width, Height, Handled);
  if not Handled and Assigned(FOnMeasureItem) then
    FOnMeasureItem(AItem, ACanvas, Width, Height, Handled);
end;

procedure TSCMenu.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = Images) and (Operation = opRemove) then
    Images := nil;
end;

procedure TSCMenu.Remove(Item: TSCMenuItem);
var
  AIndex: Integer;
begin
  AIndex := IndexOf(Item);
  if AIndex > -1 then Delete(AIndex);
end;

procedure TSCMenu.SetImages(Value: TCustomImageList);
begin
  if FImages <> nil then FImages.UnRegisterChanges(FImageChangeLink);
  FImages := Value;
  
  if FImages <> nil then
  begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(Self);
  end;
  Changed;
end;

procedure TSCMenu.TurnSiblingsOff(Item: TSCMenuItem);
var
  I: Integer;
  AItem: TSCMenuItem;
begin
  if FItems <> nil then
    for I := 0 to FItems.Count - 1 do
    begin
      AItem := FItems[I];

      if (AItem <> Item) and AItem.FRadioItem and
        (AItem.GroupIndex = Item.GroupIndex) then
        AItem.SetChecked(False);
    end;
end;

procedure TSCMenu.VerifyGroupIndex(Position: Integer; Value: Byte);
var
  I: Integer;
begin
  for I := 0 to GetCount - 1 do
    if (I >= Position) and (Items[I].GroupIndex < Value) then
      Items[I].FGroupIndex := Value;
end;

{ TSCCustomMenuControl }

constructor TSCCustomMenuControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

end.

