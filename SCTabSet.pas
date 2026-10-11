{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCTabSet;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, StdActns, ActnList, Menus, SCCommon, SCConsts, SCControl;

type
  TSCCustomTabset = class;
  TSCTabsetPanel = class;

  TSCTabsetPanelActionLink = class(TSCCollectionActionLink)
  protected
    FClient: TSCTabsetPanel;
    procedure AssignClient(AClient: TObject); override;
    function  IsCaptionLinked: Boolean; override;
    function  IsEnabledLinked: Boolean; override;
    function  IsHintLinked: Boolean; override;
    function  IsImageIndexLinked: Boolean; override;
    function  IsVisibleLinked: Boolean; override;
    function  IsOnExecuteLinked: Boolean; override;
    procedure SetCaption(const Value: string); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetHint(const Value: string); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
  end;

  TSCTabsetPanel = class(TSCCollectionItem)
  private
    FText: string;
    FWidth: Integer;
    FAlignment: TLeftRight;
    FColor: TColor;
    FData: TObject;
    FParentColor: Boolean;
    FImageIndex: TImageIndex;
    FVisible: Boolean;
    FEnabled: Boolean;
    FFontColor: TColor;
    FActionLink: TSCTabsetPanelActionLink;
    FEndEllipsis: Boolean;
    FHint: String;
    FSelected: Boolean;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseUp: TMouseEvent;
    procedure SetAlignment(Value: TLeftRight);
    procedure SetColor(Value: TColor);
    procedure SetEndEllipsis(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetFontColor(Value: TColor);
    procedure SetParentColor(Value: Boolean);
    procedure SetSelected(Value: Boolean);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetText(const Value: string);
    procedure SetVisible(Value: Boolean);
    procedure SetWidth(Value: Integer);
    function  GetAction: TBasicAction;
    procedure SetAction(const Value: TBasicAction);
    function  GetTabset: TSCCustomTabset;
  protected
    function  GetDisplayName: string; override;
    function  GetParentColor: TColor; virtual;
    function  IsAutoSized: Boolean;
    function  IsCaptionStored: Boolean;
    function  IsEnabledStored: Boolean;
    function  IsHintStored: Boolean;
    function  IsImageIndexStored: Boolean;
    function  IsOnClickStored: Boolean;
    function  IsVisibleStored: Boolean;
    procedure DoActionChange(Sender: TObject);
    function  OwnerState: TComponentState;
    function  GetDefaultColor: TColor;
    function  GetImages: TCustomImageList;
    procedure UpdateTabSelection; virtual;
    function  GetActionLinkClass: TSCCollectionActionLinkClass; dynamic;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); dynamic;

    property ActionLink: TSCTabsetPanelActionLink read FActionLink write FActionLink;
    property Tabset: TSCCustomTabset read GetTabset;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Data: TObject read FData write FData;
  published
    property Action: TBasicAction read GetAction write SetAction;
    property Alignment: TLeftRight read FAlignment write SetAlignment default taLeftJustify;
    property Color: TColor read FColor write SetColor stored True;
    property Enabled: Boolean read FEnabled write SetEnabled stored IsEnabledStored default True;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default True;
    property FontColor: TColor read FFontColor write SetFontColor default clNone;
    property Hint: String read FHint write FHint;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex
      stored IsImageIndexStored default -1;
    property ParentColor: Boolean read FParentColor write SetParentColor stored True default False;
    property Selected: Boolean read FSelected write SetSelected default False;
    property Text: string read FText write SetText stored IsCaptionStored;
    property Visible: Boolean read FVisible write SetVisible stored IsVisibleStored default True;
    property Width: Integer read FWidth write SetWidth default 50;
    property OnClick: TNotifyEvent read FOnClick write FOnClick stored IsOnClickStored;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
  end;

  TSCTabsetPanels = class(TCollection)
  private
    FTabset: TSCCustomTabset;
    FOldCount: Integer;
    function  GetItem(Index: Integer): TSCTabsetPanel;
    procedure SetItem(Index: Integer; Value: TSCTabsetPanel);
    function  GetComponentState: TComponentState;
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
    property ComponentState: TComponentState read GetComponentState;
  public
    constructor Create(AOwner: TSCCustomTabset);
    function Add: TSCTabsetPanel;
    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomTabset read FTabset;
    {$ENDIF}
    property Items[Index: Integer]: TSCTabsetPanel read GetItem write SetItem; default;
  end;

  TSCTabChangeEvent = procedure(Sender: TObject; NewTab: Integer; var AllowChange: Boolean) of object;
  TSCDrawTabEvent = procedure(Sender: TObject; ATab: TSCTabsetPanel;
    ACanvas: TCanvas; const ARect: TRect) of object;
  TSCOwnerDrawEvent = procedure(Sender: TObject; ACanvas: TCanvas; const ARect: TRect) of object;
  TSCOwnerDrawScrollerEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    const ARect: TRect; const IsLeft: Boolean) of object;

  TSCTabsetStyle = (sctsDotNet, sctsMac, sctsWindows, sctsWinXP, sctsOfficeXP,
    sctsOwnerDraw);

  TSCTabsetPosition = (sctpTop, sctpBottom);

  TSCCustomTabset = class(TSCCustomControl)
  private
    FAutoSizeTabs: Boolean;
    FAutoShowButton: Boolean;
    FAutoShowScrollers: Boolean;
    FIsButtonVisible: Boolean;
    FButtonColor: TColor;
    FButtonVisible: Boolean;
    FDefaultTabColor: TColor;
    FDrawBorder: Boolean;
    FFlatButton: Boolean;
    FFirstTabIndex: Integer;
    FScrollersVisible: Boolean;
    FScrollButtons: Boolean;
    FScrollerColor: TColor;
    FScrollArrowColor: TColor;
    FSelectedColor: TColor;
    FSelectedFontColor: TColor;
    FStyle: TSCTabsetStyle;
    FTabPosition: TSCTabsetPosition;
    FTabs: TSCTabsetPanels;
    FUseSystemFont: Boolean;
    FUseDefaultColor: Boolean;
    FXPHotColor: TColor;
    FOnButton: Boolean;
    FMouseDownTab: Integer;
    FTabDblClicked: Boolean;
    FOldCursor: TCursor;
    FBtnPressed: Boolean;
    FScrollPressed: Boolean;
    FScrollerIsHot: Boolean;
    FIsLeftScroller: Boolean;
    FLeftScrollEnabled: Boolean;
    FRightScrollEnabled: Boolean;
    FChanging: Boolean;
    FOnBtnClick: TNotifyEvent;
    FOnBtnMouseUp: TMouseEvent;
    FOnChange: TSCTabChangeEvent;
    FOnBtnMouseDown: TMouseEvent;
    FOnDrawBkground: TSCOwnerDrawEvent;
    FOnDrawButton: TSCOwnerDrawEvent;
    FOnDrawScroller: TSCOwnerDrawScrollerEvent;
    FOnDrawTab: TSCDrawTabEvent;
    FOnHint: TNotifyEvent;
    procedure SetAutoSizeTabs(Value: Boolean);
    procedure SetAutoShowButton(Value: Boolean);
    procedure SetAutoShowScrollers(Value: Boolean);
    procedure SetButtonColor(Value: TColor);
    procedure SetDefaultTabColor(Value: TColor);
    procedure SetTabPosition(Value: TSCTabsetPosition);
    procedure SetFlatButton(Value: Boolean);
    procedure SetFirstTabIndex(Value: Integer);
    procedure SetDrawBorder(Value: Boolean);
    procedure SetStyle(Value: TSCTabsetStyle);
    procedure SetSelectedFontColor(Value: TColor);
    procedure SetButtonVisible(Value: Boolean);
    procedure SetScrollArrowColor(Value: TColor);
    procedure SetScrollButtons(Value: Boolean);
    procedure SetScrollerColor(Value: TColor);
    function  GetSelected: Integer;
    procedure SetSelected(Value: Integer);
    procedure SetSelectedColor(Value: TColor);
    procedure SetTabs(Value: TSCTabsetPanels);
    procedure SetUseSystemFont(const Value: Boolean);
    procedure SetUseDefaultColor(Value: Boolean);
    procedure SetXPHotColor(Value: TColor);
    function  GetSelectedPanel: TSCTabsetPanel;

    procedure UpdateButtonAndScrollers(X, Y: Integer);
    procedure DoDrawTab(ATab: TSCTabsetPanel; ACanvas: TCanvas; const ARect: TRect);
    procedure DoDrawBackground(ACanvas: TCanvas; const ARect: TRect);
    procedure DoDrawButton(ACanvas: TCanvas; const ARect: TRect);
    procedure DoDrawScrollerEvent(ACanvas: TCanvas; const ARect: TRect; const IsLeft: Boolean);

    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMHintShow(var Msg: TMessage); message CM_HINTSHOW;
    procedure CMParentColorChanged(var Message: TMessage); message CM_PARENTCOLORCHANGED;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMWinIniChange(var Message: TMessage); message CM_WININICHANGE;
    procedure CMSysFontChanged(var Message: TMessage); message CM_SYSFONTCHANGED;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
  protected
    procedure Loaded; override;
    procedure Paint; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function  CheckScrollersEnabled: Boolean;
    function  CheckScrollersVisible(var StateChanged: Boolean): Boolean;
    function  CheckButtonIsVisible(var StateChanged: Boolean): Boolean;
    procedure CheckFirstTab(var Value: Integer);
    function  GetBlendValue: Word; override;

    procedure MouseInControlChanged; override;
    procedure SetIndent(Value: Integer); override;
    function  CanChange(NewIndex: Integer): Boolean;
    function  DoHint: Boolean; virtual;
    procedure DoSelectionChange; virtual;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    function  IsFontStored: Boolean;
    procedure SyncToSystemFont;

    function  GetTabFontColor(ATab: TSCTabsetPanel): TColor;
    procedure UpdateTabColors(OldColor: TColor);
    procedure UpdateTab(Index: Integer; Repaint: Boolean); virtual;
    procedure RedrawTab(Index: Integer);
    procedure UpdateTabs; dynamic;

    function  GetTopIndent: Integer; dynamic;
    function  GetLeftIndent: Integer; dynamic;
    function  GetRightIndent(IsBtnVisible, IsScrollerVisible: Boolean): Integer; dynamic;
    function  GetTabsRect: TRect; virtual;

    function  GetButtonRect(IsVisible: Boolean): TRect; virtual;
    function  GetScrollerWidth: Integer; virtual;
    function  GetScrollersRect(IsVisible: Boolean): TRect; virtual;

    function  ActiveTab: TSCTabsetPanel;
    function  IsValidTab(ATab: Integer): Boolean;
    function  GetTabTextRect(ACanvas: TCanvas; ATab: TSCTabsetPanel): TRect; virtual;
    function  GetTabImageRect(ATab: TSCTabsetPanel): TRect; virtual;

    procedure UpdateBorder(ACanvas: TCanvas);
    procedure UpdateScrollersOn(ACanvas: TCanvas);
    function  GetTabColor(ATab: TSCTabsetPanel): TColor;
    procedure DrawTab(Tab: TSCTabsetPanel; TabCanvas: TCanvas; const ARect: TRect);
    procedure DrawTabEdge(ATab: TSCTabsetPanel; TabCanvas: TCanvas; const ARect: TRect);
    procedure DrawScrollers(ACanvas: TCanvas; X, Y: Integer);
    procedure DrawButton(ACanvas: TCanvas);

    property SelectedPanel: TSCTabsetPanel read GetSelectedPanel;
    property AutoShowButton: Boolean read FAutoShowButton write SetAutoShowButton default False;
    property AutoShowScrollers: Boolean read FAutoShowScrollers write SetAutoShowScrollers default False;
    property AutoSizeTabs: Boolean read FAutoSizeTabs write SetAutoSizeTabs default False;
    property ButtonColor: TColor read FButtonColor write SetButtonColor default clBtnFace;
    property ButtonVisible: Boolean read FButtonVisible write SetButtonVisible default True;
    property Color default clBtnFace;
    property DefaultTabColor: TColor read FDefaultTabColor write SetDefaultTabColor default clBtnFace;
    property DrawBorder: Boolean read FDrawBorder write SetDrawBorder default True;
    property FlatButton: Boolean read FFlatButton write SetFlatButton default False;
    property Font stored IsFontStored;
    property ParentColor default False;
    property ParentFont default False;
    property ScrollButtons: Boolean read FScrollButtons write SetScrollButtons default False;
    property ScrollArrowColor: TColor read FScrollArrowColor write SetScrollArrowColor default clWindowFrame;
    property ScrollerColor: TColor read FScrollerColor write SetScrollerColor default clBtnface;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clBtnface;
    property SelectedFontColor: TColor read FSelectedFontColor write SetSelectedFontColor default clWindowText;
    property Tabs: TSCTabsetPanels read FTabs write SetTabs;
    property TabPosition: TSCTabsetPosition read FTabPosition write SetTabPosition default sctpBottom;
    property Style: TSCTabsetStyle read FStyle write SetStyle default sctsMac;
    property UseSystemFont: Boolean read FUseSystemFont write SetUseSystemFont default True;
    property UseDefaultColor: Boolean read FUseDefaultColor write SetUseDefaultColor default False;
    property XPHotColor: TColor read FXPHotColor write SetXPHotColor default SC_HottrackColor;
    { These properties must be written after Tabs to be applied
      on load of the component after Tabs are created }
    property Selected: Integer read GetSelected write SetSelected stored False;
    property OnBtnClick: TNotifyEvent read FOnBtnClick write FOnBtnClick;
    property OnBtnMouseUp: TMouseEvent read FOnBtnMouseUp write FOnBtnMouseUp;
    property OnBtnMouseDown: TMouseEvent read FOnBtnMouseDown write FOnBtnMouseDown;
    property OnChange: TSCTabChangeEvent read FOnChange write FOnChange;
    property OnDrawBkground: TSCOwnerDrawEvent read FOnDrawBkground write FOnDrawBkground;
    property OnDrawButton: TSCOwnerDrawEvent read FOnDrawButton write FOnDrawButton;
    property OnDrawScroller: TSCOwnerDrawScrollerEvent read FOnDrawScroller write FOnDrawScroller;
    property OnDrawTab: TSCDrawTabEvent read FOnDrawTab write FOnDrawTab;
    property OnHint: TNotifyEvent read FOnHint write FOnHint;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function  ExecuteAction(Action: TBasicAction): Boolean; override;

    procedure ArrangeForWindows(ATab: TSCTabsetPanel; var ARect: TRect);
    function  GetFirstVisibleTab: Integer;
    function  GetLastVisibleTab: Integer;
    function  AllTabsInView: Boolean;

    function  GetTabWidth(ATab: TSCTabsetPanel): Integer; virtual;
    function  GetTabRect(ATab: TSCTabsetPanel): TRect; dynamic;

    function  IsLeftScrollerPos(X, Y: Integer): Boolean; virtual;
    function  IsCursorOverLeftScroller: Boolean;
    function  IsRightScrollerPos(X, Y: Integer): Boolean; virtual;
    function  IsCursorOverRightScroller: Boolean;

    function  IsButtonPos(X, Y: Integer): Boolean; virtual;
    function  IsCursorOverButton: Boolean;
    function  GetClickedTab: Integer; dynamic;
    function  TabAtPos(P: TPoint): Integer; dynamic;
    function  ClientToTab(P: TPoint): TPoint;

    function  GetLeftSpareRect: TRect; virtual;
    function  GetRightSpareRect: TRect; virtual;

    procedure ScrollToNext(FromTab: Integer);
    procedure ScrollToPrev(FromTab: Integer);

    property LeftScrollEnabled: Boolean read FLeftScrollEnabled;
    property RightScrollEnabled: Boolean read FRightScrollEnabled;
    property ScrollPressed: Boolean read FScrollPressed;
    property BtnPressed: Boolean read FBtnPressed;
    property IsLeftScroller: Boolean read FIsLeftScroller;
    property FirstTabIndex: Integer read FFirstTabIndex;
  end;

  TSCTabset = class(TSCCustomTabset)
  public
    property SelectedPanel;
  published
    property Align;
    property Anchors;
    property AutoShowButton;
    property AutoShowScrollers;
    property AutoSizeTabs;
    property BlendColor;
    property ButtonColor;
    property ButtonVisible;
    property Color;
    property Constraints;
    property Cursor;
    property DefaultTabColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DrawBorder;
    property Enabled;
    property FlatButton;
    property Font;
    property Hint;
    property Images;
    property Indent;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ScrollButtons;
    property ScrollArrowColor;
    property ScrollerColor;
    property SelectedColor;
    property SelectedFontColor;
    property Tabs;
    property TabPosition;
    property ShowHint;
    property Style;
    property Tag;
    property UseSystemFont;
    property UseDefaultColor;
    property XPHotColor;
    { These properties must be written after Tabs to be applied
      on load of the component after Tabs are created }
    property Selected;
    property OnBtnClick;
    property OnBtnMouseUp;
    property OnBtnMouseDown;
    property OnCanResize;
    property OnClick;
    property OnChange;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawBkground;
    property OnDrawButton;
    property OnDrawScroller;
    property OnDrawTab;
    property OnDblClick;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnHint;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses
  SCExtControls;

{ TSCTabsetPanelActionLink }

procedure TSCTabsetPanelActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  FClient := AClient as TSCTabsetPanel;
end;

function TSCTabsetPanelActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and
    AnsiSameText(FClient.Text, (Action as TCustomAction).Caption);
end;

function TSCTabsetPanelActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and
    (FClient.Enabled = (Action as TCustomAction).Enabled);
end;

function TSCTabsetPanelActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and
    (FClient.Hint = (Action as TCustomAction).Hint);
end;

function TSCTabsetPanelActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and
    (FClient.ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TSCTabsetPanelActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and
    (@FClient.OnClick = @Action.OnExecute);
end;

function TSCTabsetPanelActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and
    (FClient.Visible = (Action as TCustomAction).Visible);
end;

procedure TSCTabsetPanelActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then FClient.Text := Value;
end;

procedure TSCTabsetPanelActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then FClient.Enabled := Value;
end;

procedure TSCTabsetPanelActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then FClient.Hint := Value;
end;

procedure TSCTabsetPanelActionLink.SetImageIndex(Value: Integer);
begin
  if IsImageIndexLinked then FClient.ImageIndex := Value;
end;

procedure TSCTabsetPanelActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then FClient.OnClick := Value;
end;

procedure TSCTabsetPanelActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then FClient.Visible := Value;
end;

{ TSCTabsetPanel }

procedure TSCTabsetPanel.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  if Action is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or (Self.Text = '') then
        Self.Text := Caption;
      if not CheckDefaults or (Self.Enabled = True) then
        Self.Enabled := Enabled;
      if not CheckDefaults or (Self.ImageIndex = -1) then
        Self.ImageIndex := ImageIndex;
      if not CheckDefaults or (Self.Visible = True) then
        Self.Visible := Visible;
      if not CheckDefaults or not Assigned(Self.OnClick) then
        Self.OnClick := OnExecute;
    end;
end;

procedure TSCTabsetPanel.Assign(Source: TPersistent);
begin
  if Source is TSCTabsetPanel then
  begin
    try
      if Collection <> nil then
        Collection.BeginUpdate;

      with TSCTabsetPanel(Source) do
      begin
        Self.Alignment := Alignment;
        Self.Color := Color;
        Self.Enabled := Enabled;
        Self.EndEllipsis := EndEllipsis;
        Self.FontColor := FontColor;
        Self.Hint := Hint;
        Self.ImageIndex := ImageIndex;
        Self.ParentColor := ParentColor;
        Self.Selected := Selected;
        Self.Text := Text;
        Self.Visible := Visible;
        Self.Width := Width;
      end;
    finally
      if Collection <> nil then
        Collection.EndUpdate;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCTabsetPanel.Create(Collection: TCollection);
begin
  FWidth := 50;
  FImageIndex := -1;
  inherited Create(Collection);

  FFontColor := clNone;
  FSelected := False;
  FParentColor := False;

  FColor := clBtnFace;
  if csDesigning in OwnerState then
    FColor := GetDefaultColor;

  FVisible := True;
  FEnabled := True;
  FEndEllipsis := True;
end;

destructor TSCTabsetPanel.Destroy;
begin
  FreeAndNil(FActionLink);
  inherited Destroy;
end;

procedure TSCTabsetPanel.DoActionChange(Sender: TObject);
begin
  if Sender = Action then ActionChange(Sender, False);
end;

function TSCTabsetPanel.GetAction: TBasicAction;
begin
  Result := nil;
  if FActionLink <> nil then Result := FActionLink.Action;
end;

function TSCTabsetPanel.GetActionLinkClass: TSCCollectionActionLinkClass;
begin
  Result := TSCTabsetPanelActionLink;
end;

function TSCTabsetPanel.GetDefaultColor: TColor;
begin
  Result := clBtnShadow;
  if Tabset <> nil then Result := Tabset.DefaultTabColor;
end;

function TSCTabsetPanel.GetDisplayName: string;
begin
  Result := Text;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TSCTabsetPanel.GetImages: TCustomImageList;
begin
  Result := nil;
  if Tabset <> nil then Result := Tabset.Images;
end;

function TSCTabsetPanel.GetParentColor: TColor;
var
  AOwner: TPersistent;
begin
  AOwner := TSCTabsetPanels(Collection).Owner;
  if (AOwner <> nil) and (AOwner is TSCCustomTabset) then
    Result := TSCCustomTabset(AOwner).Color
  else Result := clBtnFace;
end;

function TSCTabsetPanel.GetTabset: TSCCustomTabset;
begin
  Result := nil;
  if TSCTabsetPanels(Collection) <> nil then
    Result := TSCTabsetPanels(Collection).FTabset;
end;

function TSCTabsetPanel.IsAutoSized: Boolean;
begin
  Result := True;
  if Tabset <> nil then Result := Tabset.AutoSizeTabs;
end;

function TSCTabsetPanel.IsCaptionStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsCaptionLinked;
end;

function TSCTabsetPanel.IsEnabledStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsEnabledLinked;
end;

function TSCTabsetPanel.IsHintStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsHintLinked;
end;

function TSCTabsetPanel.IsImageIndexStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsImageIndexLinked;
end;

function TSCTabsetPanel.IsOnClickStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsOnExecuteLinked;
end;

function TSCTabsetPanel.IsVisibleStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsVisibleLinked;
end;

function TSCTabsetPanel.OwnerState: TComponentState;
begin
  Result := [csLoading];
  if Tabset <> nil then Result := Tabset.ComponentState;
end;

procedure TSCTabsetPanel.SetAction(const Value: TBasicAction);
begin
  if Value = nil then
  begin
    FActionLink.Free;
    FActionLink := nil;
  end
  else
  begin
    if FActionLink = nil then
      FActionLink := TSCTabsetPanelActionLink(GetActionLinkClass.Create(Self));
    FActionLink.Action := Value;
    FActionLink.OnChange := DoActionChange;
    ActionChange(Value, csLoading in Value.ComponentState);
  end;
end;

procedure TSCTabsetPanel.SetAlignment(Value: TLeftRight);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Changed(False);
  end;
end;

procedure TSCTabsetPanel.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    if FParentColor and
      (Value <> GetParentColor) then
        FParentColor := False;
    Changed(True);
  end;
end;

procedure TSCTabsetPanel.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed(False);
  end;
end;

procedure TSCTabsetPanel.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    if Text <> '' then
      Changed(False);
  end;
end;

procedure TSCTabsetPanel.SetFontColor(Value: TColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    if Visible then
      Changed(False);
  end;
end;

procedure TSCTabsetPanel.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if Visible then
      if IsAutoSized then Changed(True)
      else Changed(False);
  end;
end;

procedure TSCTabsetPanel.SetParentColor(Value: Boolean);
begin
  if FParentColor <> Value then
  begin
    FParentColor := Value;
    if Value then Color := GetParentColor;
  end;
end;

procedure TSCTabsetPanel.SetSelected(Value: Boolean);
begin
  if not FEnabled and Value then
    Value := False;

  if FSelected <> Value then
  begin
    FSelected := Value;
    if Value then UpdateTabSelection;

    Changed(True);

    if Value and (Tabset <> nil) then
      Tabset.DoSelectionChange;
  end;
end;

procedure TSCTabsetPanel.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    if Visible then
      if IsAutoSized then Changed(True)
      else Changed(False);
  end;
end;

procedure TSCTabsetPanel.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(True);
  end;
end;

procedure TSCTabsetPanel.SetWidth(Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    if Visible then
      if not IsAutoSized then
        Changed(True);
  end;
end;

procedure TSCTabsetPanel.UpdateTabSelection;
var
  I: Integer;
  P: TSCTabsetPanel;
begin
  for I := 0 to Collection.Count-1 do
  begin
    P := TSCTabsetPanels(Collection).Items[I];
    P.SetSelected(P = Self);
  end;
end;

{ TSCTabsetPanels }

function TSCTabsetPanels.Add: TSCTabsetPanel;
begin
  Result := TSCTabsetPanel(inherited Add);
end;

constructor TSCTabsetPanels.Create(AOwner: TSCCustomTabset);
begin
  inherited Create(TSCTabsetPanel);
  FTabset := AOwner;
  FOldCount := 0;
end;

function TSCTabsetPanels.GetItem(Index: Integer): TSCTabsetPanel;
begin
  Result := TSCTabsetPanel(inherited GetItem(Index));
end;

function TSCTabsetPanels.GetOwner: TPersistent;
begin
  Result := FTabset;
end;

function TSCTabsetPanels.GetComponentState: TComponentState;
begin
  Result := [csLoading];
  if FTabset <> nil then Result := FTabset.ComponentState;
end;

procedure TSCTabsetPanels.SetItem(Index: Integer; Value: TSCTabsetPanel);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCTabsetPanels.Update(Item: TCollectionItem);
var
  Cnt, FI: Integer;
  Sp: TSCTabsetPanel;
  Cs: TComponentState;
begin
  if FTabset = nil then Exit;

  Cnt := Count;
  Cs := ComponentState;
  if (Item = nil) and (FOldCount <> Cnt) then
  begin
    FOldCount := Cnt;

    if not (csLoading in Cs) then
    begin
      FI := 0;
      if not (csDesigning in Cs) then
        FI := FTabset.FirstTabIndex;

      if Cnt > 0 then
      begin
        Sp := FTabset.SelectedPanel;
        if (Sp = nil) or (csDesigning in Cs) then
          Items[Cnt-1].Selected := True;
      end;  

      FTabset.SetFirstTabIndex(FI);
      if FTabset.FirstTabIndex <> FI then
        Exit;
    end;
  end;

  if Item <> nil then
    FTabset.UpdateTab(Item.Index, False) else
    FTabset.UpdateTabs;
end;

{ TSCCustomTabset }

function TSCCustomTabset.ActiveTab: TSCTabsetPanel;
var
  Indx: Integer;
begin
  Result := nil;
  if FTabs <> nil then
  begin
    Indx := GetSelected;
    if IsValidTab(Indx) then Result := FTabs[Indx];
  end;
end;

function TSCCustomTabset.AllTabsInView: Boolean;
var
  I, FrstTab: Integer;
  CR, R, R2: TRect;
begin
  Result := True;
  if not (CanGetClientRect and
    (FTabs <> nil) and (FTabs.Count > 0)) then Exit;

  FrstTab := FirstTabIndex;
  CheckFirstTab(FrstTab);

  if FrstTab > 0 then
  begin
    Result := False;
    Exit;
  end;

  CR := ClientRect;
  Inc(CR.Left,  GetLeftIndent);
  Dec(CR.Right, GetRightIndent(False, False));

  if IsRectEmpty(CR) then
  begin
    Result := False;
    Exit;
  end;

  R := CR;
  R.Right := R.Left;
  if FrstTab = 0 then
  begin
    Inc(R.Right, GetTabWidth(FTabs[FrstTab]));

    IntersectRect(R2, R, CR);
    if not EqualRect(R2, R) then
    begin
      Result := False;
      Exit;
    end;
  end;

  for I := FrstTab + 1 to FTabs.Count-1 do
  begin
    if not FTabs[I].Visible then Continue;
    OffsetRect(R, GetTabWidth(FTabs[I]), 0);

    IntersectRect(R2, R, CR);
    if not EqualRect(R2, R) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

procedure TSCCustomTabset.ArrangeForWindows(ATab: TSCTabsetPanel;
  var ARect: TRect);
var
  SIndx: Integer;
begin
  if (FStyle = sctsWindows) and ATab.Visible then
  begin
    SIndx := -1;
    if ATab.Selected then SIndx := Selected;

    if IsValidTab(SIndx) and (ATab.Index = SIndx) then
      InflateRect(ARect, 2, 0)
    else
    if FTabPosition = sctpBottom then
      Inc(ARect.Top, 2)
    else
      Dec(ARect.Bottom, 2);
  end;
end;

function TSCCustomTabset.CanChange(NewIndex: Integer): Boolean;
begin
  try
    FChanging := True;

    Result := IsValidTab(NewIndex) and Tabs[NewIndex].Enabled;
    if Assigned(FOnChange) then FOnChange(Self, NewIndex, Result);
  finally
    FChanging := False;
  end;
end;

function TSCCustomTabset.CheckButtonIsVisible(var StateChanged: Boolean): Boolean;
begin
  Result := FButtonVisible;
  if Result and FAutoShowButton then Result := not AllTabsInView;

  StateChanged := FIsButtonVisible <> Result;
  StateChanged := CheckScrollersEnabled or StateChanged;
  if StateChanged then
  begin
    FIsButtonVisible := Result;
    Invalidate;
  end;
end;

procedure TSCCustomTabset.CheckFirstTab(var Value: Integer);
begin
  if FTabs.Count = 0 then
    Value := 0
  else
  if Value > FTabs.Count-1 then
    Value := FTabs.Count-1
  else
  if Value < 0 then
    Value := 0;
end;

function TSCCustomTabset.ClientToTab(P: TPoint): TPoint;
var
  Pnl: Integer;
  R: TRect;
begin
  Result := P;
  if not (CanGetClientRect and
    (FTabs <> nil) and (FTabs.Count > 0)) then Exit;

  Pnl := TabAtPos(P);
  if (Pnl > -1) and (Pnl < FTabs.Count) then
  begin
    R := GetTabRect(FTabs[Pnl]);
    if (FStyle = sctsWindows) and FTabs[Pnl].Selected then
      ArrangeForWindows(FTabs[Pnl], R);

    Result.X := P.X - R.Left;
    Result.Y := P.Y - R.Top;
  end;
end;

procedure TSCCustomTabset.CMColorChanged(var Message: TMessage);
begin
  inherited;
  UpdateTabColors(Canvas.Brush.Color);
  Invalidate;
end;

procedure TSCCustomTabset.CMDesignHitTest(var Message: TCMDesignHitTest);
var
  HitIndex: Integer;
  P: TPoint;
  SChanged: Boolean;
begin
  P := SmallPointToPoint(Message.Pos);
  SChanged := False;
  if PtInRect(ClientRect, P) then
  begin
    HitIndex := TabAtPos(P);
    if (Message.Keys = MK_LBUTTON) and (HitIndex > -1) and
      (HitIndex < FTabs.Count) and (HitIndex <> Selected) then
    begin
      Selected := HitIndex;
      SChanged := True;
      Message.Result := 1;
    end;
  end;
  if not SChanged then inherited;
end;

procedure TSCCustomTabset.CMHintShow(var Msg: TMessage);
const
  EmptyHint = '';
var
  Indx: Integer;
  P: TPoint;
  HRect: TRect;
begin
  inherited;

  with TCMHintShow(Msg) do
  begin
    P := HintInfo.CursorPos;
    Indx := TabAtPos(P);
    if (Indx > -1) and (Indx < FTabs.Count) then
    begin
      HintInfo.CursorRect := GetTabRect(Tabs[Indx]);
      if (Tabs[Indx].Hint = '') or
        not (Tabs[Indx].Visible and Tabs[Indx].Enabled) then
      begin
        HintInfo.HintStr := EmptyHint;
        Result := 1;
      end else
        HintInfo.HintStr := Tabs[Indx].Hint;
    end else if IsButtonPos(P.X, P.Y) then
      Result := 1
    else begin
      Indx := TabAtPos(Point(P.X+1, P.Y));
      if (Indx > -1) and (Indx < FTabs.Count) then
      begin
        HRect := ClientRect;
        HRect.Left := P.X-1;
        HRect.Right := P.X+1;
        HintInfo.CursorRect := HRect;
      end else
      begin
        Indx := TabAtPos(Point(P.X-1, P.Y));
        if (Indx > -1) and (Indx < FTabs.Count) then
        begin
          HRect := ClientRect;
          HRect.Left := P.X;
          HRect.Right := P.X+2;
          HintInfo.CursorRect := HRect;
        end else
        begin
          HRect := GetLeftSpareRect;
          if PtInRect(HRect, P) then
            HintInfo.CursorRect := HRect
          else begin
            HRect := GetRightSpareRect;
            if PtInRect(HRect, P) then
              HintInfo.CursorRect := HRect
            else begin
              HRect := GetTabsRect;
              HRect.Bottom := HRect.Top;
              HRect.Top := ClientRect.Top;
              if (HRect.Right > HRect.Left) and PtInRect(HRect, P) then
                HintInfo.CursorRect := HRect;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTabset.CMParentColorChanged(var Message: TMessage);
begin
  inherited;
  if ParentColor then
  begin
    UpdateTabColors(Canvas.Brush.Color);
    Invalidate;
  end;
end;

procedure TSCCustomTabset.CMParentFontChanged(var Message: TMessage);
begin
  inherited;
  if FUseSystemFont and ParentFont then
    FUseSystemFont := False;
end;

procedure TSCCustomTabset.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  UpdateTabColors(Canvas.Brush.Color);
  Invalidate;
end;

procedure TSCCustomTabset.CMSysFontChanged(var Message: TMessage);
begin
  inherited;
  SyncToSystemFont;
end;

procedure TSCCustomTabset.CMWinIniChange(var Message: TMessage);
begin
  inherited;
  if (Message.WParam = 0) or (Message.WParam = SPI_SETNONCLIENTMETRICS) then
    SyncToSystemFont;
end;

constructor TSCCustomTabset.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(Left, Top, 280, 25);
  ControlStyle := [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  Color := clBtnFace;
  ParentColor := False;
  ParentFont := False;
  ClickFocus := False;
  Indent := 3;

  FAutoShowButton := False;
  FAutoShowScrollers := False;
  FAutoSizeTabs := False;
  FIsButtonVisible := True;
  FButtonColor := clBtnFace;
  FButtonVisible := True;
  FDefaultTabColor := clBtnFace;
  FDrawBorder := True;
  FFirstTabIndex := 0;
  FMouseDownTab := -1;
  FOldCursor := Cursor;
  FScrollArrowColor := clWindowFrame;
  FScrollersVisible := False;
  FScrollButtons := False;
  FScrollerColor := clBtnface;
  FSelectedColor := clBtnface;
  FSelectedFontColor := clWindowText;
  FStyle := sctsMac;
  FTabs := TSCTabsetPanels.Create(Self);
  FTabPosition := sctpBottom;
  FUseSystemFont := True;
  FXPHotColor := SC_HottrackColor;
  SyncToSystemFont;
end;

destructor TSCCustomTabset.Destroy;
begin
  FreeAndNil(FTabs);
  inherited Destroy;
end;

function TSCCustomTabset.DoHint: Boolean;
begin
  if Assigned(FOnHint) then
  begin
    FOnHint(Self);
    Result := True;
  end else
    Result := False;
end;

procedure TSCCustomTabset.DoSelectionChange;
begin
  Click;
end;

procedure TSCCustomTabset.DrawButton(ACanvas: TCanvas);
var
  X, Y, I: Integer;
  ARect, BRect: TRect;
  FcColor, AColor, BColor: TColor;
begin
  if not FIsButtonVisible or (ACanvas = nil) then
    Exit;

  ARect := GetButtonRect(FIsButtonVisible);

  if not IsRectEmpty(ARect) then
  begin
    BRect := ARect;

    AColor := FButtonColor;
    if Style = sctsOfficeXP then
    begin
      if BtnPressed and FOnButton then
        AColor := GetOfficeXPDownedSelColor
      else
      if BtnPressed or (FOnButton and (FMouseDownTab = -1) and not FScrollPressed) then
        AColor := GetOfficeXPSelColor
      else
        AColor := GetOfficeXPBtnColor;
    end;

    if BlendColor and FlatButton then
      AColor := DefaultBlendedColor(AColor);

    FcColor := AColor;

    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := AColor;
      
      FillRect(BRect);
    end;

    if FStyle = sctsOwnerDraw then
    begin
      scFrame3D(ACanvas, BRect, GetBtnShadowOf(FcColor), GetBtnShadowOf(FcColor), 1, 0);
      DoDrawButton(ACanvas, BRect);
    end else
    if Style = sctsMac then
    begin
      X := BRect.Left + (((BRect.Right - BRect.Left) - 4) div 2);
      Y := BRect.Top + (((BRect.Bottom - BRect.Top) - 8) div 2);

      if BtnPressed and FOnButton then
      begin
        Inc(X);
        Inc(Y);
      end;

      with ACanvas do
      begin
        Pen.Color := DefaultBlendedColor(clWindowFrame);

        MoveTo(X, Y);
        LineTo(X, Y + 8);

        MoveTo(X + 1, Y + 1);
        LineTo(X + 1, Y + 7);

        MoveTo(X + 2, Y + 2);
        LineTo(X + 2, Y + 6);

        MoveTo(X + 3, Y + 3);
        LineTo(X + 3, Y + 5);
      end;

      scFrame3D(ACanvas, BRect, clWindowFrame, clWindowFrame, 1, 0);

      if not FFlatButton then
      begin
        BColor := BlendedColor(AColor, 80, 80, 80, True);
        AColor := BlendedColor(AColor, 80, 80, 80, False);

        if BtnPressed and FOnButton then
          scFrame3D(ACanvas, BRect, AColor, BColor, 1, 0)
        else scFrame3D(ACanvas, BRect, BColor, AColor, 1, 0);
      end;
    end else
    begin
      X := BRect.Left + (((BRect.Right - BRect.Left) - 8) div 2);
      Y := BRect.Top + (((BRect.Bottom - BRect.Top) - 5) div 2);

      if BtnPressed and FOnButton and (Style <> sctsOfficeXP) then
      begin
        Inc(X);
        Inc(Y);
      end;

      with ACanvas do
      begin
        AColor := clWindowFrame;

        if Style = sctsWinXP then
          Pen.Color := cl3DDkShadow
        else
        if (Style = sctsOfficeXP) and BtnPressed and FOnButton then
          AColor := clHighlightText;

        Pen.Color := DefaultBlendedColor(AColor);

        for I := 0 to 1 do
        begin
          MoveTo(X, Y);
          LineTo(X + 2, Y + 2);
          LineTo(X - 1, Y + 5);

          Inc(X);
        end;

        Inc(X, 2);
        for I := 0 to 1 do
        begin
          MoveTo(X, Y);
          LineTo(X + 2, Y + 2);
          LineTo(X - 1, Y + 5);

          Inc(X);
        end;
      end;

      case Style of
        sctsOfficeXP:
        begin
          if BtnPressed or (FOnButton and (FMouseDownTab = -1) and not FScrollPressed) then
            scFrame3D(ACanvas, BRect, clHighlight, clHighlight, 1, 0);
        end;
        sctsWindows:
        begin
          if FFlatButton then
          begin
            if BtnPressed and FOnButton then
              scFrame3D(ACanvas, BRect, GetBtnShadowOf(FcColor), GetBtnHighlightOf(FcColor), 1, 0)
            else
              scFrame3D(ACanvas, BRect, GetBtnHighlightOf(FcColor), GetBtnShadowOf(FcColor), 1, 0);
          end else
          if BtnPressed and FOnButton then
          begin
            scFrame3D(ACanvas, BRect, GetBtnShadowOf(FcColor), GetBtnHighlightOf(FcColor), 1, 0);
            scFrame3D(ACanvas, BRect, Get3DDkShadowOf(FcColor), FcColor, 1, 0);
          end else
          begin
            scFrame3D(ACanvas, BRect, GetBtnShadowOf(FcColor), Get3DDkShadowOf(FcColor), 1, 0);
            scFrame3D(ACanvas, BRect, GetBtnHighlightOf(FcColor), GetBtnShadowOf(FcColor), 1, 0);
          end;
        end;
        sctsDotNet:
        begin
          if not FFlatButton then
          begin
            if BtnPressed and FOnButton then
            begin
              scFrame3D(ACanvas, BRect, FcColor, FcColor, 1, 0);
              scFrame3D(ACanvas, BRect, GetBtnHighlightOf(FcColor), GetBtnHighlightOf(FcColor), 1, 0);
            end else
            begin
              scFrame3D(ACanvas, BRect, FcColor, Get3DDkShadowOf(FcColor), 1, 0);
              scFrame3D(ACanvas, BRect, GetBtnHighlightOf(FcColor), FcColor, 1, 0);
            end;
          end;
        end;
        sctsWinXP:
        begin
          if FFlatButton then
          begin
            if BtnPressed and FOnButton then
              scFrame3D(ACanvas, BRect, GetBtnShadowOf(FcColor), GetBtnHighlightOf(FcColor), 1, 0);
          end else
          if BtnPressed and FOnButton then
            scFrame3D(ACanvas, BRect, GetBtnShadowOf(FcColor), GetBtnHighlightOf(FcColor), 1, 0)
          else
            scFrame3D(ACanvas, BRect, GetBtnHighlightOf(FcColor), GetBtnShadowOf(FcColor), 1, 0);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTabset.DrawTab(Tab: TSCTabsetPanel; TabCanvas: TCanvas;
  const ARect: TRect);
const
  EllipsisFlags: array[Boolean] of Integer = (0, DT_END_ELLIPSIS);
  SCenterFlags: array[Boolean] of Integer = (0, DT_CENTER);
var
  Cl: TColor;
  HasImage: Boolean;
  BRect, CRect: TRect;
  {$IFDEF SC_DELPHI4_AND_EARLY}
  NonClientMetrics: TNonClientMetrics;
  {$ENDIF}
begin
  if (Tab = nil) or not IsValidTab(Tab.Index) then
    Exit;

  UpdateBorder(Canvas);

  with TabCanvas do
  begin
    Brush.Style := bsSolid;
    BRect := ARect;
    OffsetRect(BRect, -BRect.Left, -BRect.Top);

    Cl := GetTabColor(Tab);
    if not Tab.Selected then Cl := DefaultBlendedColor(Cl);

    Brush.Color := Cl;
    FillRect(BRect);

    if FUseSystemFont then
    begin
      {$IFDEF SC_DELPHI4_AND_EARLY}
      NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
      if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
        Font.Handle := CreateFontIndirect(NonClientMetrics.lfStatusFont)
      else
        Font.Size := 8;
      {$ELSE}
      Font.Assign(Screen.HintFont);
      {$ENDIF}
    end else
      Font.Assign(Self.Font);

    if Tab.FFontColor <> clNone then
      Font.Color := Tab.FFontColor;

    case Style of
      sctsOwnerDraw:
      begin
        DoDrawTab(Tab, TabCanvas, BRect);
        Exit;
      end;
      sctsMac, sctsWindows,
      sctsDotNet, sctsWinXP, sctsOfficeXP:
      begin
        HasImage := False;
        if (Images <> nil) and (Tab.ImageIndex > -1) and
          (Tab.ImageIndex < Images.Count) then
        begin
          CRect := GetTabImageRect(Tab);
          Images.Draw(TabCanvas, CRect.Left, CRect.Top, Tab.ImageIndex, Tab.Enabled);
            
          HasImage := True;
        end;

        if Tab.Text <> '' then
        begin
          CRect := GetTabTextRect(TabCanvas, Tab);
          Font.Color := GetTabFontColor(Tab);

          Brush.Style := bsClear;
          DrawText(TabCanvas.Handle, PChar(Tab.Text), Length(Tab.Text),
            CRect, SCenterFlags[not HasImage] or EllipsisFlags[Tab.EndEllipsis]);
        end;

        DrawTabEdge(Tab, TabCanvas, ARect);
      end;
    end;
  end;
end;

procedure TSCCustomTabset.DrawTabEdge(ATab: TSCTabsetPanel; TabCanvas: TCanvas;
  const ARect: TRect);
var
  Cl, TCl: TColor;
  BRect: TRect;
  Indx: Integer;
begin
  if not IsValidTab(ATab.Index) then
    Exit;

  with TabCanvas do
  begin
    BRect := ARect;
    OffsetRect(BRect, -BRect.Left, -BRect.Top);

    TCl := GetTabColor(ATab);
    
    case TabPosition of
      sctpBottom:
      begin
        case FStyle of
          sctsOwnerDraw:
          begin
          end;
          sctsOfficeXP:
            if ATab.Selected then
              scFrame3D(TabCanvas, BRect, clHighlight, clHighlight, 1, 0);
          sctsMac:
          begin
            Pen.Color := GetFaceColor;
            MoveTo(ARect.Left, ARect.Bottom);
            LineTo(ARect.Left, ARect.Top);
            LineTo(ARect.Right - 1, ARect.Top);
            LineTo(ARect.Right - 1, ARect.Bottom);

            Pen.Color := clWindowFrame;
            MoveTo(ARect.Left, ARect.Bottom - 1);
            LineTo(ARect.Left, ARect.Top + 2);
            LineTo(ARect.Left  + 2, ARect.Top);
            LineTo(ARect.Right - 3, ARect.Top);
            LineTo(ARect.Right - 1, ARect.Top + 2);
            LineTo(ARect.Right - 1, ARect.Bottom - 1);

            if ATab.Selected then
            begin
              Pen.Color := BlendedColor(FSelectedColor, 80, 80, 80, True);
              MoveTo(ARect.Left  + 1, ARect.Bottom - 1);
              LineTo(ARect.Left  + 1, ARect.Top + 2);
              LineTo(ARect.Left  + 2, ARect.Top + 1);
              LineTo(ARect.Right - 3, ARect.Top + 1);
              LineTo(ARect.Right - 2, ARect.Top + 2);

              Pen.Color := BlendedColor(FSelectedColor, 64, 64, 64, False);
              LineTo(ARect.Right - 2, ARect.Bottom - 1);

              Pen.Color := FSelectedColor;

              MoveTo(ARect.Left, ARect.Bottom - 1);
              LineTo(ARect.Right, ARect.Bottom - 1);
            end else
            begin
              Pen.Color := GetTabColor(ATab);
              Pen.Color := BlendedColor(Pen.Color, 48, 48, 48, True);

              MoveTo(ARect.Left + 1, ARect.Bottom);
              LineTo(ARect.Left + 1, ARect.Top + 1);

              Cl := TCl;
              if BlendColor then Cl := DefaultBlendedColor(Cl);
              
              Pen.Color := Cl;

              MoveTo(ARect.Left  + 2, ARect.Top + 1);
              LineTo(ARect.Left  + 2, ARect.Top + 1);
              LineTo(ARect.Right - 3, ARect.Top + 1);
              LineTo(ARect.Right - 2, ARect.Top + 2);
              LineTo(ARect.Right - 2, ARect.Bottom);

              Pen.Color := clWindowFrame;
              MoveTo(ARect.Left, ARect.Bottom - 1);
              LineTo(ARect.Right, ARect.Bottom - 1);
            end;
          end;
          sctsWindows:
          begin
            Pen.Color := GetFaceColor;
            MoveTo(ARect.Left, ARect.Bottom);
            LineTo(ARect.Left, ARect.Top);
            LineTo(ARect.Right - 1, ARect.Top);
            LineTo(ARect.Right - 1, ARect.Bottom);

            Pen.Color := clBtnHighlight;
            MoveTo(ARect.Left, ARect.Bottom);
            LineTo(ARect.Left, ARect.Top + 2);
            LineTo(ARect.Left  + 2, ARect.Top);
            LineTo(ARect.Right - 3, ARect.Top);

            Pen.Color := cl3DDkShadow;
            MoveTo(ARect.Right - 2, ARect.Top + 1);
            LineTo(ARect.Right - 1, ARect.Top + 2);
            LineTo(ARect.Right - 1, ARect.Bottom);

            Cl := GetTabColor(ATab);
            if BlendColor and not ATab.Selected then
              Cl := DefaultBlendedColor(Cl);

            Pen.Color := Cl;

            MoveTo(ARect.Left  + 1, ARect.Bottom);
            LineTo(ARect.Left  + 1, ARect.Top + 2);
            LineTo(ARect.Left  + 2, ARect.Top + 1);
            LineTo(ARect.Right - 3, ARect.Top + 1);
            LineTo(ARect.Right - 2, ARect.Top + 2);

            Pen.Color := BlendedColor(TCl, 64, 64, 64, False);

            LineTo(ARect.Right - 2, ARect.Bottom);

            if not ATab.Selected then
            begin
              Pen.Color := clBtnHighlight;
              MoveTo(ARect.Left, ARect.Bottom - 1);
              LineTo(ARect.Right, ARect.Bottom - 1);
            end;
          end;
          sctsWinXP:
          begin
            Pen.Color := GetFaceColor;
            MoveTo(ARect.Left, ARect.Bottom);
            LineTo(ARect.Left, ARect.Top);
            LineTo(ARect.Right - 1, ARect.Top);
            LineTo(ARect.Right - 1, ARect.Bottom);

            Pen.Color := clBtnShadow;
            MoveTo(ARect.Left, ARect.Bottom);
            LineTo(ARect.Left, ARect.Top + 2);
            LineTo(ARect.Left  + 2, ARect.Top);
            LineTo(ARect.Right - 3, ARect.Top);
            LineTo(ARect.Right - 1, ARect.Top + 2);
            LineTo(ARect.Right - 1, ARect.Bottom);

            Cl := TCl;
            if BlendColor and not ATab.Selected then
              Cl := DefaultBlendedColor(Cl);

            Pen.Color := Cl;  

            MoveTo(ARect.Left  + 1, ARect.Bottom);
            LineTo(ARect.Left  + 1, ARect.Top + 2);
            LineTo(ARect.Left  + 2, ARect.Top + 1);
            LineTo(ARect.Right - 3, ARect.Top + 1);
            LineTo(ARect.Right - 2, ARect.Top + 2);

            Cl := TCl;
            if ATab.Selected then
              Cl := DefaultBlendedColor(Cl)
            else
              Cl := BlendedColor(Cl, 8, 8, 8, False);

            Pen.Color := Cl;

            LineTo(ARect.Right - 2, ARect.Bottom);

            if not ATab.Selected then
            begin
              Pen.Color := clBtnShadow;
              MoveTo(ARect.Left, ARect.Bottom - 1);
              LineTo(ARect.Right, ARect.Bottom - 1);
            end else
            begin
              Pen.Color := FXPHotColor;
              MoveTo(ARect.Left, ARect.Top + 2);
              LineTo(ARect.Left  + 2, ARect.Top);
              LineTo(ARect.Right - 3 , ARect.Top);
              LineTo(ARect.Right, ARect.Top + 3);

              Pen.Color := BlendedColor(FXPHotColor, 48, 48, 48, True);
              MoveTo(ARect.Left  + 1, ARect.Top + 2);
              LineTo(ARect.Right - 1, ARect.Top + 2);
              MoveTo(ARect.Left  + 2, ARect.Top + 1);
              LineTo(ARect.Right - 2, ARect.Top + 1);
            end;
          end;
          sctsDotNet:
          begin
            if ATab.Selected then
            begin
              Pen.Color := FSelectedColor;

              MoveTo(ARect.Left, ARect.Bottom - 1);
              LineTo(ARect.Right, ARect.Bottom - 1);

              Pen.Color := FSelectedColor;

              MoveTo(ARect.Left, ARect.Bottom - 1);
              LineTo(ARect.Left, ARect.Top);
              LineTo(ARect.Right - 1, ARect.Top);

              Pen.Color := BlendedColor(FSelectedColor, 160, 160, 160, False);
              LineTo(ARect.Right - 1, ARect.Bottom - 1);

              Pen.Color := BlendedColor(FSelectedColor, 128, 128, 128, True);
              MoveTo(ARect.Left  + 1, ARect.Bottom - 1);
              LineTo(ARect.Left  + 1, ARect.Top + 1);
              LineTo(ARect.Right - 2, ARect.Top + 1);

              Pen.Color := BlendedColor(FSelectedColor, 64, 64, 64, False);
              LineTo(ARect.Right - 2, ARect.Bottom - 1);
            end else
            begin
              Indx := Selected;
              if (Indx > -1) and (ATab.Index <> Indx-1) then
              begin
                BRect := ARect;
                Inc(BRect.Top, 3);
                Dec(BRect.Bottom, 4);
                
                if BRect.Top < BRect.Bottom then
                begin
                  Cl := BlendedColor(Self.Color, 40, 40, 40, False);
                  if not BlendColor then
                    Cl := BlendedColor(Self.Color, 60, 60, 60, False);

                  Pen.Color := Cl;

                  MoveTo(BRect.Right - 1, BRect.Top);
                  LineTo(BRect.Right - 1, BRect.Bottom - 1);
                end;
              end;

              Pen.Color := clBtnHighlight;
              MoveTo(ARect.Left, ARect.Bottom - 1);
              LineTo(ARect.Right, ARect.Bottom - 1);
            end;
          end;
        end;
      end;
      sctpTop:
      begin
        case FStyle of
          sctsOwnerDraw:
          begin
          end;
          sctsOfficeXP:
            if ATab.Selected then
              scFrame3D(TabCanvas, BRect, clHighlight, clHighlight, 1, 0);
          sctsMac:
          begin
            Pen.Color := GetFaceColor;
            MoveTo(ARect.Left, ARect.Top);
            LineTo(ARect.Left, ARect.Bottom - 1);
            LineTo(ARect.Right - 1, ARect.Bottom - 1);
            LineTo(ARect.Right - 1, ARect.Top);

            Pen.Color := clWindowFrame;
            MoveTo(ARect.Left, ARect.Top);
            LineTo(ARect.Left, ARect.Bottom - 3);
            LineTo(ARect.Left  + 2, ARect.Bottom - 1);
            LineTo(ARect.Right - 3, ARect.Bottom - 1);
            LineTo(ARect.Right - 1, ARect.Bottom - 3);
            LineTo(ARect.Right - 1, ARect.Top - 1);

            if ATab.Selected then
            begin
              Pen.Color := BlendedColor(FSelectedColor, 80, 80, 80, True);
              MoveTo(ARect.Left + 1, ARect.Top);
              LineTo(ARect.Left + 1, ARect.Bottom - 3);

              Pen.Color := BlendedColor(FSelectedColor, 64, 64, 64, False);
              LineTo(ARect.Left  + 2, ARect.Bottom - 2);
              LineTo(ARect.Right - 3, ARect.Bottom - 2);
              LineTo(ARect.Right - 2, ARect.Bottom - 3);
              LineTo(ARect.Right - 2, ARect.Top - 1);
            end else
            begin
              Pen.Color := GetTabColor(ATab);
              Pen.Color := BlendedColor(Pen.Color, 48, 48, 48, True);

              MoveTo(ARect.Left + 1, ARect.Top);
              LineTo(ARect.Left + 1, ARect.Bottom - 2);

              Pen.Color := GetTabColor(ATab);
              if BlendColor then
                Pen.Color := DefaultBlendedColor(Pen.Color);

              MoveTo(ARect.Left  + 2, ARect.Bottom - 2);
              LineTo(ARect.Left  + 2, ARect.Bottom - 2);
              LineTo(ARect.Right - 3, ARect.Bottom - 2);
              LineTo(ARect.Right - 2, ARect.Bottom - 3);
              LineTo(ARect.Right - 2, ARect.Top);

              Pen.Color := clWindowFrame;
              MoveTo(ARect.Left, ARect.Top);
              LineTo(ARect.Right, ARect.Top);
            end;
          end;
          sctsWindows:
          begin
            Pen.Color := GetFaceColor;
            MoveTo(ARect.Left, ARect.Top);
            LineTo(ARect.Left, ARect.Bottom - 1);
            LineTo(ARect.Right - 1, ARect.Bottom - 1);
            LineTo(ARect.Right - 1, ARect.Top);

            Pen.Color := clBtnHighlight;
            MoveTo(ARect.Left, ARect.Top);
            LineTo(ARect.Left, ARect.Bottom - 3);
            LineTo(ARect.Left + 2, ARect.Bottom - 1);

            Pen.Color := cl3DDkShadow;
            LineTo(ARect.Right - 3, ARect.Bottom - 1);
            LineTo(ARect.Right - 2, ARect.Bottom - 2);
            LineTo(ARect.Right - 1, ARect.Bottom - 3);
            LineTo(ARect.Right - 1, ARect.Top - 1);

            Pen.Color := GetTabColor(ATab);
            if BlendColor then
              Pen.Color := DefaultBlendedColor(Pen.Color);

            MoveTo(ARect.Left + 1, ARect.Top);
            LineTo(ARect.Left + 1, ARect.Bottom - 3);
            LineTo(ARect.Left + 2, ARect.Bottom - 2);

            Pen.Color := clBtnShadow;
            LineTo(ARect.Right - 3, ARect.Bottom - 2);
            LineTo(ARect.Right - 2, ARect.Bottom - 3);
            LineTo(ARect.Right - 2, ARect.Top - 1);

            if not ATab.Selected then
            begin
              Pen.Color := cl3DDkShadow;
              MoveTo(ARect.Left, ARect.Top);
              LineTo(ARect.Right, ARect.Top);
            end;
          end;
          sctsWinXP:
          begin
            Pen.Color := GetFaceColor;
            MoveTo(ARect.Left, ARect.Top);
            LineTo(ARect.Left, ARect.Bottom - 1);
            LineTo(ARect.Right - 1, ARect.Bottom - 1);
            LineTo(ARect.Right - 1, ARect.Top);

            Pen.Color := clBtnShadow;
            MoveTo(ARect.Left, ARect.Top);
            LineTo(ARect.Left, ARect.Bottom - 3);
            LineTo(ARect.Left + 2, ARect.Bottom - 1);

            // Pen.Color :=
            LineTo(ARect.Right - 3, ARect.Bottom - 1);
            LineTo(ARect.Right - 2, ARect.Bottom - 2);
            LineTo(ARect.Right - 1, ARect.Bottom - 3);
            LineTo(ARect.Right - 1, ARect.Top - 1);

            Pen.Color := GetTabColor(ATab);
            Pen.Color := BlendedColor(Pen.Color, 8, 8 ,8, True);

            MoveTo(ARect.Left + 1, ARect.Top);
            LineTo(ARect.Left + 1, ARect.Bottom - 3);
            LineTo(ARect.Left + 2, ARect.Bottom - 2);

            Pen.Color := GetTabColor(ATab);
            Pen.Color := BlendedColor(Pen.Color, 8, 8 ,8, False);

            LineTo(ARect.Right - 3, ARect.Bottom - 2);
            LineTo(ARect.Right - 2, ARect.Bottom - 3);
            LineTo(ARect.Right - 2, ARect.Top - 1);

            if not ATab.Selected then
            begin
              Pen.Color := clBtnShadow;
              MoveTo(ARect.Left, ARect.Top);
              LineTo(ARect.Right, ARect.Top);
            end else
            begin
              Pen.Color := FXPHotColor;
              MoveTo(ARect.Left, ARect.Bottom - 3);
              LineTo(ARect.Left + 2, ARect.Bottom - 1);
              LineTo(ARect.Right - 3 , ARect.Bottom - 1);
              LineTo(ARect.Right, ARect.Bottom - 3);

              Pen.Color := BlendedColor(FXPHotColor, 48, 48, 48, True);
              MoveTo(ARect.Left  + 1, ARect.Bottom - 3);
              LineTo(ARect.Right - 1, ARect.Bottom - 3);
              MoveTo(ARect.Left  + 2, ARect.Bottom - 2);
              LineTo(ARect.Right - 2, ARect.Bottom - 2);
            end;
          end;
          sctsDotNet:
          begin
            if ATab.Selected then
            begin
              Pen.Color := FSelectedColor;
              if BlendColor then
                Pen.Color := DefaultBlendedColor(Pen.Color);
              MoveTo(ARect.Left, ARect.Top);
              LineTo(ARect.Right, ARect.Top);

              Pen.Color := FSelectedColor;
              if BlendColor then
                Pen.Color := DefaultBlendedColor(Pen.Color);
              MoveTo(ARect.Left, ARect.Top);
              LineTo(ARect.Left, ARect.Bottom - 1);

              Pen.Color := BlendedColor(FSelectedColor, 160, 160, 160, False);
              LineTo(ARect.Right - 1, ARect.Bottom - 1);
              LineTo(ARect.Right - 1, ARect.Top - 1);

              Pen.Color := BlendedColor(FSelectedColor, 128, 128, 128, True);
              MoveTo(ARect.Left + 1, ARect.Top);
              LineTo(ARect.Left + 1, ARect.Bottom - 2);

              Pen.Color := BlendedColor(FSelectedColor, 64, 64, 64, False);
              LineTo(ARect.Right - 2, ARect.Bottom - 2);
              LineTo(ARect.Right - 2, ARect.Top - 1);
            end else
            begin
              Indx := Selected;
              if (Indx > -1) and (ATab.Index <> Indx-1) then
              begin
                BRect := ARect;
                Inc(BRect.Top, 4);
                Dec(BRect.Bottom, 3);
                if BRect.Top < BRect.Bottom then
                begin
                  if FUseDefaultColor then
                  begin
                    if IsColorLight(ATab.Color) then
                      Pen.Color := BlendedColor(FSelectedColor, 80, 80, 80, False)
                    else
                      Pen.Color := BlendedColor(FSelectedColor, 80, 80, 80, True);
                  end else
                  begin
                    if IsColorLight(FDefaultTabColor) then
                      Pen.Color := BlendedColor(FSelectedColor, 80, 80, 80, False)
                    else
                      Pen.Color := BlendedColor(FSelectedColor, 80, 80, 80, True);
                  end;

                  MoveTo(BRect.Right - 1, BRect.Bottom - 1);
                  LineTo(BRect.Right - 1, BRect.Top);
                end;
              end;

              Pen.Color := cl3DDkShadow;
              MoveTo(ARect.Left, ARect.Top);
              LineTo(ARect.Right, ARect.Top);
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TSCCustomTabset.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action);
end;

function TSCCustomTabset.GetBlendValue: Word;
begin
  if FStyle = sctsOfficeXP then
    Result := 0
  else begin
    Result := inherited GetBlendValue;
    if Result > 0 then Result := 16;
  end;  
end;

function TSCCustomTabset.GetButtonRect(IsVisible: Boolean): TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if not CanGetClientRect then Exit;

  Result := ClientRect;
  with Result do
  begin
    if IsVisible then
      Left := Right - 16
    else Left := Right;

    if Style in [sctsWindows, sctsWinXP, sctsDotNet] then
    begin
      InflateRect(Result, 0, -1);

      Dec(Right);
      Dec(Left);
    end;

    if Bottom < Top then Bottom := Top;
    if Right < Left then Right := Left;
  end;
end;

function TSCCustomTabset.GetClickedTab: Integer;
var
  P: TPoint;
begin
  Result := -1;
  if not GetCursorPos(P) then Exit;

  P := ScreenToClient(P);
  Result := TabAtPos(P);

  if (Result < 0) and
    IsButtonPos(P.X, P.Y) then Result := -2
  else if (Result > -1) and
    not Tabs[Result].Enabled then Result := -3;
end;

function TSCCustomTabset.GetFirstVisibleTab: Integer;
var
  I, FrstTab: Integer;
begin
  Result := -1;
  if (FTabs <> nil) and (FTabs.Count > 0) then
  begin
    FrstTab := FirstTabIndex;
    CheckFirstTab(FrstTab);

    if FrstTab < 0 then FrstTab := 0;

    for I := FrstTab to FTabs.Count-1 do
      if FTabs[I].Visible then
      begin
        Result := I;
        Exit;
      end;
  end;
end;

function TSCCustomTabset.GetLastVisibleTab: Integer;
var
  I, FrstTab: Integer;
begin
  Result := -1;
  if FTabs <> nil then
  begin
    FrstTab := GetFirstVisibleTab;
    if FrstTab = -1 then Exit;

    for I := FrstTab to FTabs.Count-1 do
      if FTabs[I].Visible then Result := I;
  end;
end;

function TSCCustomTabset.GetLeftSpareRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if not CanGetClientRect then Exit;

  Result := ClientRect;
  Result.Right := Result.Left + GetLeftIndent;
end;

function TSCCustomTabset.GetRightSpareRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if not CanGetClientRect then Exit;

  Result := ClientRect;
  Result.Left := Result.Right - GetRightIndent(FIsButtonVisible, FScrollersVisible);
end;

function TSCCustomTabset.GetSelected: Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FTabs.Count-1 do
    if Tabs[I].Selected then
    begin
      Result := I;
      Exit;
    end;  
end;

function TSCCustomTabset.GetTabColor(ATab: TSCTabsetPanel): TColor;
begin
  Result := ATab.Color;

  if Style = sctsOfficeXP then
  begin
    if ATab.Selected then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;
  end else
  if ATab.Selected then
    Result := FSelectedColor
  else
  if FUseDefaultColor then
    Result := FDefaultTabColor;
end;

function TSCCustomTabset.GetTabFontColor(ATab: TSCTabsetPanel): TColor;
begin
  Result := clWindowText;
  if ATab = nil then Exit;

  if not (ATab.Enabled and Self.Enabled) then
    Result := clGrayText
  else if ATab.Index = Selected then
    Result := FSelectedFontColor
  else Result := Self.Font.Color;
end;

function TSCCustomTabset.GetTabImageRect(ATab: TSCTabsetPanel): TRect;
var
  R: TRect;
begin
  if (ATab = nil) or not CanGetClientRect then Exit;

  R := GetTabRect(ATab);
  OffsetRect(R, -R.Left, -R.Top);

  Result := Rect(0, 0, 0, 0);
  if IsValidImage(ATab.ImageIndex) then
    Result := Rect(0, 0, Images.Width, Images.Height);

  OffsetRect(Result, 0,
    R.Top + ((R.Bottom - R.Top) - (Result.Bottom - Result.Top)) div 2);

  if ATab.Text = '' then
    OffsetRect(Result,
      ((R.Right - R.Left) - (Result.Right - Result.Left)) div 2, 0)
  else OffsetRect(Result, 4, 0);
end;

function TSCCustomTabset.GetTabsRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if not CanGetClientRect then Exit;

  Result := ClientRect;
  with Result do
  begin
    Inc(Left,  GetLeftIndent);
    if Left > Right then Left := Right;

    Dec(Right, GetRightIndent(FIsButtonVisible, FScrollersVisible));
    if Right < Left then Right := Left;

    if TabPosition = sctpBottom then
    begin
      Inc(Top, GetTopIndent);
      if Top > Bottom then Top := Bottom;

      if Top > Bottom then Top := Bottom;
    end else
    begin
      Dec(Bottom, GetTopIndent);
      if Bottom < Top then Bottom := Top;

      if Bottom < Top then Bottom := Top;
    end;
  end;
end;

function TSCCustomTabset.GetTabTextRect(ACanvas: TCanvas;
  ATab: TSCTabsetPanel): TRect;
const
  EllipsisFlags: array [Boolean] of Integer = (0, DT_END_ELLIPSIS);
var
  R, CRect: TRect;
  Text: String;
begin
  if (ATab = nil) or
    not CanGetClientRect or (FTabs = nil) then Exit;

  R := GetTabRect(ATab);
  OffsetRect(R, -R.Left, -R.Top);

  if (Images <> nil) and (ATab.ImageIndex > -1) and
    (ATab.ImageIndex < Images.Count) then
      CRect := GetTabImageRect(ATab)
  else CRect := Rect(2, R.Top, 2, R.Bottom);

  Result := Rect(CRect.Right + 2, R.Top, (R.Right - R.Left) - 4, R.Top);

  if Result.Right < Result.Left then Result.Right := Result.Left;
  if Result.Bottom < Result.Top then Result.Bottom := Result.Top;

  Text := ATab.Text;
  if Text <> '' then
  begin
    ACanvas.Font := Self.Font;

    DrawText(ACanvas.Handle, PChar(Text), Length(Text),
      Result, DT_CALCRECT or EllipsisFlags[ATab.EndEllipsis]);
  end;

  Result.Right := (R.Right - R.Left) - 4;

  OffsetRect(Result, 0,
    R.Top + ((R.Bottom - R.Top) - (Result.Bottom - Result.Top)) div 2);
end;

function TSCCustomTabset.IsFontStored: Boolean;
begin
  Result := not FUseSystemFont and not ParentFont and not DesktopFont;
end;

function TSCCustomTabset.IsCursorOverButton: Boolean;
var
  P: TPoint;
begin
  Result := False;
  if not GetCursorPos(P) then
    Exit;

  P := ScreenToClient(P);
  Result := IsButtonPos(P.X, P.Y);
end;

function TSCCustomTabset.IsButtonPos(X, Y: Integer): Boolean;
begin
  Result := False;
  if not FIsButtonVisible then
    Exit;

  Result := PtInRect(GetButtonRect(FIsButtonVisible), Point(X, Y));
end;

function TSCCustomTabset.IsValidTab(ATab: Integer): Boolean;
begin
  Result := (ATab > -1) and (FTabs <> nil) and
    (ATab < FTabs.Count) and FTabs[ATab].Visible;
end;

procedure TSCCustomTabset.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  P: TPoint;
  ClickedTab: Integer;
begin
  FOnButton       := False;
  FBtnPressed     := False;
  FScrollPressed  := False;
  FScrollerIsHot  := False;
  FIsLeftScroller := False;

  P := Point(X, Y);

  if FScrollersVisible and (FLeftScrollEnabled or FRightScrollEnabled) then
  begin
    if IsLeftScrollerPos(X, Y) then
    begin
      FScrollPressed  := True;
      FIsLeftScroller := True;
    end else
    if IsRightScrollerPos(X, Y) then
    begin
      FScrollPressed  := True;
      FIsLeftScroller := False;
    end;

    if FScrollPressed then
    begin
      FTabDblClicked := False;
      FMouseDownTab  := -1;

      UpdateScrollersOn(Self.Canvas);

      inherited MouseDown(Button, Shift, X, Y);
      Exit;
    end;
  end;

  ClickedTab := TabAtPos(P);
  if not IsValidTab(ClickedTab) then
    ClickedTab := -1;

  if (ClickedTab > -1) and not FTabs[ClickedTab].Enabled then
  begin
    FTabDblClicked := False;
    FMouseDownTab  := -1;

    Exit;
  end;

  if ClickedTab < 0 then
  begin
    if ClickFocus then
      SetFocus;

    FTabDblClicked := False;
    if FIsButtonVisible and IsButtonPos(X, Y) then
    begin
      FBtnPressed := True;
      FOnButton   := True;
      
      DrawButton(Self.Canvas);

      if Assigned(FOnBtnMouseDown) then
        FOnBtnMouseDown(Self, Button, Shift, X, Y);
    end else
      inherited MouseDown(Button, Shift, X, Y);
  end else
  begin
    if (Button = mbLeft) and (ssDouble in Shift) and (ClickedTab = FMouseDownTab) then
    begin
      FTabDblClicked := True;

      if Assigned(Tabs[ClickedTab].OnDblClick) then
        Tabs[ClickedTab].OnDblClick(Tabs[ClickedTab]);
    end else
      FTabDblClicked := False;

    if Assigned(Tabs[ClickedTab].OnMouseDown) then
    begin
      P := ClientToTab(P);
      Tabs[ClickedTab].OnMouseDown(Tabs[ClickedTab],
        Button, Shift, P.X, P.Y);
    end;

    if (Button = mbLeft) and IsValidTab(ClickedTab) then
      Selected := ClickedTab;
  end;

  if (Self <> nil) and HandleAllocated then
    FMouseDownTab := ClickedTab;
end;

procedure TSCCustomTabset.MouseInControlChanged;
var
  P: TPoint;
begin
  if GetCursorPos(P) then
  begin
    P := Self.ScreenToClient(P);
    UpdateButtonAndScrollers(P.x, P.y);
  end;
end;

procedure TSCCustomTabset.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  MsMovedTab: Integer;
  WasHot, WasLeft, WasOnButton: Boolean;
begin
  P := Point(X, Y);
  
  WasOnButton := FOnButton;
  FOnButton   := IsButtonPos(X, Y);

  if FScrollersVisible and FScrollPressed then
  begin
    if FIsLeftScroller then
    begin
      if not IsLeftScrollerPos(X, Y) then
        UpdateScrollersOn(Self.Canvas);
    end else
    if not IsRightScrollerPos(X, Y) then
      UpdateScrollersOn(Self.Canvas);

    inherited MouseMove(Shift, X, Y);
  end else
  if FMouseDownTab < 0 then
  begin
    if WasOnButton <> FOnButton then
      DrawButton(Self.Canvas);

    if not FBtnPressed then
    begin
      MsMovedTab := TabAtPos(P);

      if (MsMovedTab > -1) and (MsMovedTab < FTabs.Count) then
      begin
        if Assigned(Tabs[MsMovedTab].OnMouseMove) then
        begin
          P := ClientToTab(P);
          Tabs[MsMovedTab].OnMouseMove(Tabs[MsMovedTab],
            Shift, P.X, P.Y);
        end;
      end else
      begin
        WasHot  := FScrollerIsHot;
        WasLeft := FIsLeftScroller;

        FScrollerIsHot := IsLeftScrollerPos(X, Y);
        if FScrollerIsHot then
          FIsLeftScroller := True
        else
        if IsRightScrollerPos(X, Y) then
        begin
          FScrollerIsHot := True;
          FIsLeftScroller := False;
        end;

        if (WasHot <> FScrollerIsHot) or
          (FScrollerIsHot and (WasLeft <> FIsLeftScroller)) then
          UpdateScrollersOn(Self.Canvas);

        inherited MouseMove(Shift, X, Y);
      end;
    end;
  end else
  if (FMouseDownTab > -1) and (FMouseDownTab < FTabs.Count) and
    Tabs[FMouseDownTab].Enabled and Assigned(Tabs[FMouseDownTab].OnMouseMove) then
  begin
    P := ClientToTab(P);
    Tabs[FMouseDownTab].OnMouseMove(Tabs[FMouseDownTab],
      Shift, X, Y);
  end;
end;

procedure TSCCustomTabset.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  P: TPoint;
  ClickedTab: Integer;
begin
  if FScrollersVisible and FScrollPressed then
  begin
    if FIsLeftScroller then
      ScrollToPrev(FFirstTabIndex)
    else ScrollToNext(FFirstTabIndex);

    inherited MouseUp(Button, Shift, X, Y);
  end else
  if FMouseDownTab < 0 then
  begin
    FTabDblClicked := False;
    if FIsButtonVisible and FBtnPressed then
    begin
      FBtnPressed := False;
      DrawButton(Self.Canvas);

      if IsButtonPos(X, Y) and Assigned(FOnBtnClick) then
        FOnBtnClick(Self);

      if Assigned(FOnBtnMouseUp) then
        FOnBtnMouseUp(Self, Button, Shift, X, Y);
    end else
      inherited MouseUp(Button, Shift, X, Y);
  end else
  if FMouseDownTab < FTabs.Count then
  begin
    if not Tabs[FMouseDownTab].Enabled then
    begin
      FTabDblClicked := False;
      FMouseDownTab := -1;

      Exit;
    end;

    P := Point(X, Y);
    ClickedTab := TabAtPos(P);
    if ClickedTab > FTabs.Count then
      ClickedTab := -1;

    if (ClickedTab > -1) and (ClickedTab = FMouseDownTab) then
    begin
      FMouseDownTab := -1;

      if Button = mbLeft then
      begin
        if FTabDblClicked then
        begin
          FMouseDownTab := -1;
          FTabDblClicked := False;
        end else
        if Assigned(Tabs[ClickedTab].OnClick) then
          Tabs[ClickedTab].OnClick(Tabs[ClickedTab]);
      end;

      if Assigned(Tabs[ClickedTab].OnMouseUp) then
      begin
        P := ClientToTab(Point(X, Y));
        Tabs[ClickedTab].OnMouseUp(Tabs[ClickedTab],
          Button, Shift, P.X, P.Y);
      end;
    end;
  end;

  if (Self <> nil) and (Canvas <> nil) and HandleAllocated then
  begin
    FMouseDownTab := -1;
    FIsLeftScroller := False;
    FBtnPressed := False;

    FOnButton := FIsButtonVisible and
      not IsDesigning and IsButtonPos(X, Y);
      
    DrawButton(Self.Canvas);

    if FScrollPressed then
    begin
      FScrollPressed := False;
      UpdateScrollersOn(Self.Canvas);
    end;

    FScrollerIsHot := False;
  end;
end;

procedure TSCCustomTabset.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = Images) then
    Images := nil;
end;

procedure TSCCustomTabset.Paint;
var
  CR, TabR, R, R2: TRect;
  ATab: TSCTabsetPanel;
  ABitmap, TabBmp: TBitmap;
  I, FirstTab, SIndx: Integer;
  {$IFDEF SC_DELPHI4_AND_EARLY}
  NonClientMetrics: TNonClientMetrics;
  {$ENDIF}
begin
  if not HandleAllocated then
    Exit;

  CR := ClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  ABitmap := TBitmap.Create;
  try
    with ABitmap, ABitmap.Canvas do
    begin
      Width  := CR.Right;
      Height := CR.Bottom;

      Brush.Color := GetFaceColor;
      FillRect(CR);
    end;

    if FStyle = sctsOwnerDraw then
      DoDrawBackground(ABitmap.Canvas, CR);

    TabR := GetTabsRect;
    if IsRectEmpty(TabR) then
      Exit;

    if FStyle = sctsWindows then
      Dec(TabR.Left, 2);

    IntersectRect(TabR, TabR, CR);

    FirstTab := FirstTabIndex;
    CheckFirstTab(FirstTab);

    if (FirstTab > -1) and (FirstTab < FTabs.Count) then
    begin
      TabBmp := TBitmap.Create;
      try
        with TabBmp.Canvas do
        begin
          if FUseSystemFont then
          begin
            {$IFDEF SC_DELPHI4_AND_EARLY}
            NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
            if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
              Font.Handle := CreateFontIndirect(NonClientMetrics.lfStatusFont)
            else
              Font.Size := 8;
            {$ELSE}
            Font.Assign(Screen.HintFont);
            {$ENDIF}
          end else
            Font.Assign(Self.Font);

          if FUseDefaultColor then
            Brush.Color := DefaultBlendedColor(FDefaultTabColor);
        end;

        for I := FirstTab to FTabs.Count-1 do
        begin
          ATab := FTabs[I];
          if not ATab.Visible then
            Continue;

          R := GetTabRect(ATab);
          if FStyle = sctsWindows then
            ArrangeForWindows(ATab, R);

          if IsRectEmpty(R) then
            Continue;

          IntersectRect(R2, R, TabR);
          if not EqualRect(R, R2) then
            Break;

          OffsetRect(R2, -R2.Left, -R2.Top);
          with TabBmp, TabBmp.Canvas do
          begin
            Width  := R2.Right;
            Height := R2.Bottom;

            if not FUseDefaultColor or (Style = sctsOfficeXP) then
              Brush.Color := DefaultBlendedColor(ATab.Color);

            FillRect(R);
          end;

          DrawTab(ATab, TabBmp.Canvas, R2);
          ABitmap.Canvas.Draw(R.Left, R.Top, TabBmp);
        end;

        if FStyle = sctsWindows then
        begin
          SIndx := Selected;

          if IsValidTab(SIndx) then
          begin
            ATab := FTabs[SIndx];
            if not ATab.Visible then
              Exit;

            R := GetTabRect(ATab);
            if IsRectEmpty(R) then
              Exit;

            IntersectRect(R2, R, TabR);
            if EqualRect(R, R2) then
            begin
              OffsetRect(R2, -R2.Left, -R2.Top);
              ArrangeForWindows(ATab, R2);

              with TabBmp, TabBmp.Canvas do
              begin
                Width  := R2.Right;
                Height := R2.Bottom;

                if not FUseDefaultColor then
                  Brush.Color := DefaultBlendedColor(ATab.Color);

                FillRect(R);
              end;

              DrawTab(ATab, TabBmp.Canvas, R2);
              ABitmap.Canvas.Draw(R.Left, R.Top, TabBmp);
            end;
          end;
        end;
      finally
        TabBmp.Free;
      end;
    end;
  finally
    if FIsButtonVisible then
      DrawButton(ABitmap.Canvas);

    DrawScrollers(ABitmap.Canvas, 0, 0);

    UpdateBorder(ABitmap.Canvas);
    Canvas.Draw(0, 0, ABitmap);

    ABitmap.Free;
  end;
end;

procedure TSCCustomTabset.RedrawTab(Index: Integer);
var
  ARect, BRect: TRect;
  TabBmp: TBitmap;
begin
  if not (HandleAllocated and IsValidTab(Index)) then Exit;

  TabBmp := TBitmap.Create;
  try
    ARect := GetTabRect(Tabs[Index]);
    
    BRect := ARect;
    BRect.Top := ClientRect.Top;

    with Canvas do
    begin
      Brush.Color := GetFaceColor;
      FillRect(BRect);

      if DrawBorder and (Style <> sctsOwnerDraw) then
      begin
        if Style = sctsWindows then
          Pen.Color := clWindowFrame
        else begin
          if TabPosition = sctpBottom then
            Pen.Color := cl3DDkShadow
          else Pen.Color := clBtnHighlight;
        end;

        if TabPosition = sctpBottom then
        begin
          MoveTo(BRect.Left, BRect.Top);
          LineTo(BRect.Right, BRect.Top);
        end else
        begin
          MoveTo(BRect.Left, BRect.Bottom - 1);
          LineTo(BRect.Right, BRect.Bottom - 1);
        end;
      end;
    end;

    with TabBmp do
    begin
      BRect := ARect;
      OffsetRect(BRect, -BRect.Left, -BRect.Top);

      Height := BRect.Bottom;
      Width := BRect.Right;

      DrawTab(Tabs[Index], Canvas, BRect);
    end;

    Canvas.Draw(ARect.Left, ARect.Top, TabBmp);
  finally
    TabBmp.Free;
  end;
end;

procedure TSCCustomTabset.SetAutoShowButton(Value: Boolean);
var
  SC: Boolean;
begin
  if FAutoShowButton <> Value then
  begin
    FAutoShowButton := Value;
    CheckButtonIsVisible(SC);
    CheckScrollersVisible(SC);
  end;
end;

procedure TSCCustomTabset.SetAutoSizeTabs(Value: Boolean);
begin
  if FAutoSizeTabs <> Value then
  begin
    FAutoSizeTabs := Value;
    if FTabs.Count > 0 then Invalidate;
  end;
end;

procedure TSCCustomTabset.SetButtonColor(Value: TColor);
begin
  if FButtonColor <> Value then
  begin
    FButtonColor := Value;
    if FIsButtonVisible then DrawButton(Self.Canvas);
  end;
end;

procedure TSCCustomTabset.SetButtonVisible(Value: Boolean);
var
  SC, SS: Boolean;
begin
  if FButtonVisible <> Value then
  begin
    FButtonVisible := Value;
    
    CheckButtonIsVisible(SC);
    CheckScrollersVisible(SS);
    if not (SC or SS) then Invalidate;
  end;
end;

procedure TSCCustomTabset.SetDefaultTabColor(Value: TColor);
begin
  if FDefaultTabColor <> Value then
  begin
    FDefaultTabColor := Value;
    if FUseDefaultColor then Invalidate;
  end;
end;

procedure TSCCustomTabset.SetDrawBorder(Value: Boolean);
begin
  if FDrawBorder <> Value then
  begin
    FDrawBorder := Value;
    Invalidate;
  end;
end;

procedure TSCCustomTabset.SetFirstTabIndex(Value: Integer);
begin
  CheckFirstTab(Value);

  if FFirstTabIndex <> Value then
  begin
    FFirstTabIndex := Value;

    CheckScrollersEnabled;
    if FTabs.Count > 0 then Invalidate;
  end;
end;

procedure TSCCustomTabset.SetFlatButton(Value: Boolean);
begin
  if FFlatButton <> Value then
  begin
    FFlatButton := Value;
    if FIsButtonVisible or FScrollersVisible then Invalidate;
  end;
end;

procedure TSCCustomTabset.SetIndent(Value: Integer);
begin
  if Value < 0 then Value := 0
  else if Value > 100 then Value := 100;

  inherited SetIndent(Value);
end;

procedure TSCCustomTabset.SetSelected(Value: Integer);
var
  SIndx: Integer;
begin
  if FChanging then Exit;

  if (FTabs.Count = 0) or (Value < 0) then
    Value := -1
  else if Value > FTabs.Count-1 then
    Value := FTabs.Count-1;

  SIndx := GetSelected;
  if SIndx < 0 then SIndx := -1
  else if SIndx > FTabs.Count-1 then
    SIndx := FTabs.Count-1;

  if SIndx <> Value then
  begin
    if not CanChange(Value) then Exit;

    if (Value = -1) and (SIndx <> -1) then
      Tabs[SIndx].Selected := False
    else if Value > -1 then
      Tabs[Value].Selected := True;
  end;
end;

procedure TSCCustomTabset.SetSelectedColor(Value: TColor);
var
  ASelected: Integer;
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;
    ASelected := GetSelected;
    
    if IsValidTab(ASelected) then UpdateTab(ASelected, True);
  end;
end;

procedure TSCCustomTabset.SetSelectedFontColor(Value: TColor);
var
  ASelected: Integer;
begin
  if FSelectedFontColor <> Value then
  begin
    FSelectedFontColor := Value;
    ASelected := GetSelected;

    if IsValidTab(ASelected) then UpdateTab(ASelected, True);
  end;
end;

procedure TSCCustomTabset.SetStyle(Value: TSCTabsetStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TSCCustomTabset.SetTabPosition(Value: TSCTabsetPosition);
begin
  if FTabPosition <> Value then
  begin
    FTabPosition := Value;
    Invalidate;
  end;
end;

procedure TSCCustomTabset.SetTabs(Value: TSCTabsetPanels);
begin
  FTabs.Assign(Value);
end;

procedure TSCCustomTabset.SetUseDefaultColor(Value: Boolean);
begin
  if FUseDefaultColor <> Value then
  begin
    FUseDefaultColor := Value;
    if FTabs.Count > 0 then Invalidate;
  end;
end;

procedure TSCCustomTabset.SetUseSystemFont(const Value: Boolean);
begin
  if FUseSystemFont <> Value then
  begin
    FUseSystemFont := Value;
    if Value then
    begin
      if ParentFont then ParentFont := False;
      SyncToSystemFont;
    end;
  end;
end;

procedure TSCCustomTabset.SetXPHotColor(Value: TColor);
begin
  if FXPHotColor <> Value then
  begin
    FXPHotColor := Value;
    if Style = sctsWinXP then Invalidate;
  end;
end;

procedure TSCCustomTabset.SyncToSystemFont;
{$IFDEF SC_DELPHI4_AND_EARLY}
var
  NonClientMetrics: TNonClientMetrics;
{$ENDIF}
begin
  if FUseSystemFont then
  begin
    {$IFDEF SC_DELPHI4_AND_EARLY}
    NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
    if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
      Font.Handle := CreateFontIndirect(NonClientMetrics.lfStatusFont)
    else
      Font.Size := 8;
    {$ELSE}
    Font.Assign(Screen.HintFont);
    {$ENDIF}
  end;
end;

function TSCCustomTabset.TabAtPos(P: TPoint): Integer;
var
  I, FrstTab,
  LastTab, SIndx: Integer;
  CR, R, R2: TRect;
begin
  Result := -1;
  if not (CanGetClientRect and
    (FTabs <> nil) and (FTabs.Count > 0)) then Exit;

  CR := GetTabsRect;
  if IsRectEmpty(CR) or not PtInRect(CR, P) then Exit;

  SIndx := Selected;
  if IsValidTab(SIndx) then
  begin
    R := GetTabRect(Tabs[SIndx]);
    if FStyle = sctsWindows then
      ArrangeForWindows(FTabs[SIndx], R);

    if PtInRect(R, P) then
    begin
      Result := SIndx;
      Exit;
    end;
  end;

  FrstTab := GetFirstVisibleTab;
  LastTab := GetLastVisibleTab;

  if FrstTab < 0 then FrstTab := 0;

  for I := FrstTab to LastTab do
  begin
    if not FTabs[I].Visible then Continue;

    R := GetTabRect(FTabs[I]);
    if P.x < R.Left then Exit;

    IntersectRect(R2, R, CR);
    if IsRectEmpty(R2) or not EqualRect(R, R2) then Exit;

    if PtInRect(R2, P) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TSCCustomTabset.GetTabRect(ATab: TSCTabsetPanel): TRect;
var
  I, Indx, FrstTab: Integer;
  CR: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if not (CanGetClientRect and (ATab <> nil) and
    (FTabs.Count > 0) and IsValidTab(ATab.Index)) then Exit;

  Indx := ATab.Index;

  FrstTab := FirstTabIndex;
  CheckFirstTab(FrstTab);
  if (FrstTab < 0) or (Indx < FrstTab) then Exit;

  CR := ClientRect;
  if IsRectEmpty(CR) then Exit;

  with CR do
  begin
    Inc(Left, GetLeftIndent);

    if TabPosition = sctpBottom then
    begin
      Inc(Top, GetTopIndent);
      if Top > Bottom then Top := Bottom;
    end else
    begin
      Dec(Bottom, GetTopIndent);
      if Bottom < Top then Bottom := Top;
    end;
  end;

  Result := CR;
  Result.Right := Result.Left;
  if ATab.Visible then Inc(Result.Right, GetTabWidth(ATab));

  for I := FrstTab to Indx-1 do
  begin
    if not FTabs[I].Visible then Continue;
    OffsetRect(Result, GetTabWidth(FTabs[I]), 0);
  end;
end;

function TSCCustomTabset.GetTabWidth(ATab: TSCTabsetPanel): Integer;
const
  EllipsisFlags: array [Boolean] of Integer = (0, DT_END_ELLIPSIS);
var
  R: TRect;
  HasImage, HasText: Boolean;
  Text: String;
begin
  Result := 0;
  if not CanGetClientRect or
    (FTabs.Count < 0) or (ATab = nil) then Exit;

  if not FAutoSizeTabs then
  begin
    Result := ATab.Width;
    Exit;
  end;

  Result := 8;

  HasImage := False;
  if (Images <> nil) and (ATab.ImageIndex > -1) and
    (ATab.ImageIndex < Images.Count) then
  begin
    Inc(Result, Images.Width);
    HasImage := True;
  end;

  Text := ATab.Text;
  HasText := Text <> '';

  if HasText then
  begin
    Canvas.Font := Self.Font;

    R := Rect(0, 0, 0, 0);
    DrawText(Canvas.Handle, PChar(Text), Length(Text), R,
      DT_CALCRECT or DT_LEFT or DT_SINGLELINE);

    Inc(Result, R.Right - R.Left);
  end;

  if not (HasImage or HasText) then Inc(Result, 20)
  else if HasImage and HasText then Inc(Result, 2);

  if Result < 28 then Result := 28;
end;

procedure TSCCustomTabset.UpdateBorder(ACanvas: TCanvas);
var
  AColor: TColor;
  Offset: Integer;
  ATab: TSCTabsetPanel;
  R, R2, CR: TRect;
begin
  if (ACanvas = nil) or
    (Style = sctsOfficeXP) or not CanGetClientRect then
    Exit;

  CR := ClientRect;
  R := CR;

  if FDrawBorder then
  begin
    case Style of
      sctsMac:
        scFrame3D(ACanvas, R, clWindowFrame, clWindowFrame, 1, 0);
      sctsWinXP:
        scFrame3D(ACanvas, R, clBtnShadow, clBtnShadow, 1, 0);
      else
        scFrame3D(ACanvas, R, cl3DDkShadow, clBtnHighlight, 1, 0);
    end;
  end else
  begin
    with ACanvas do
    begin
      case Style of
        sctsMac:
          Pen.Color := clWindowFrame;
        sctsWinXP:
          Pen.Color := clBtnShadow;
        else begin
          if TabPosition = sctpBottom then
            Pen.Color := clBtnHighlight
          else Pen.Color := cl3DDkShadow;
        end;
      end;

      if TabPosition = sctpBottom then
      begin
        MoveTo(R.Left, R.Bottom - 1);
        LineTo(R.Right, R.Bottom - 1);
      end else
      begin
        MoveTo(R.Left, R.Top);
        LineTo(R.Right, R.Top);
      end;
    end;
  end;

  ATab := ActiveTab;

  if ATab <> nil then
  begin
    R2 := GetTabRect(ATab);

    CR := GetTabsRect;
    IntersectRect(R, R2, CR);

    if not IsRectEmpty(R) and EqualRect(R2, R) then
    begin
      if FStyle <> sctsWindows then InflateRect(R2, -1, 0);

      AColor := GetTabColor(ATab);
      // if BlendColor then AColor := DefaultBlendedColor(AColor);

      with ACanvas do
      begin
        Pen.Color := AColor;

        Offset := 0;
        case FStyle of
          sctsDotNet:
            Offset := 2;
          sctsWindows:
            Offset := -1;
        end;

        if TabPosition = sctpTop then
        begin
          MoveTo(R.Left + Offset, R.Top);
          LineTo(R.Right, R.Top);
        end else
        begin
          MoveTo(R.Left + Offset, R.Bottom - 1);
          LineTo(R.Right, R.Bottom - 1);
        end;
      end;
    end;
  end;
end;

procedure TSCCustomTabset.UpdateTab(Index: Integer; Repaint: Boolean);
var
  SIndx: Integer;
  SC, SS: Boolean;
begin
  CheckButtonIsVisible(SC);
  CheckScrollersVisible(SS);

  if not (SC or SS) then
  begin
    RedrawTab(Index);
    if Style = sctsWindows then
    begin
      SIndx := Selected;
      if IsValidTab(SIndx) and
        ((Index = Selected - 1) or (Index = Selected + 1)) then
          RedrawTab(SIndx);
    end;
  end;
end;

procedure TSCCustomTabset.UpdateTabColors(OldColor: TColor);
var
  I: Integer;
begin
  if not HandleAllocated then Exit;

  for I := 0 to FTabs.Count-1 do
    if Tabs[I].ParentColor then
        Tabs[I].Color := Self.Color;
end;

procedure TSCCustomTabset.UpdateTabs;
var
  SC, SS: Boolean;
begin
  CheckButtonIsVisible(SC);
  CheckScrollersVisible(SS);
  if not (SC or SS) then Invalidate;
end;

procedure TSCCustomTabset.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTALLKEYS;
end;

procedure TSCCustomTabset.WMKillFocus(var Message: TWMKillFocus);
begin
  if BtnPressed then
  begin
    FBtnPressed := False;
    DrawButton(Self.Canvas);
  end;
  inherited;
end;

procedure TSCCustomTabset.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if not IsDesigning then
    inherited
  else MouseCapture := False;
end;

procedure TSCCustomTabset.WMSize(var Message: TWMSize);
var
  SC, SS: Boolean;
begin
  inherited;
  CheckButtonIsVisible(SC);
  CheckScrollersVisible(SS);
  if not (SC or SS) then Invalidate;
end;

function TSCCustomTabset.GetLeftIndent: Integer;
begin
  Result := Indent + 2;
  if FDrawBorder then Inc(Result, 1);
end;

function TSCCustomTabset.GetRightIndent(IsBtnVisible, IsScrollerVisible: Boolean): Integer;
begin
  Result := 3;
  if IsBtnVisible then
  begin
    Result := 8;
    if Style = sctsMac then
      Result := 20;
  end;

  if IsScrollerVisible then
  begin
    Inc(Result, 3);
    Inc(Result, 2*GetScrollerWidth);
  end;
end;

function TSCCustomTabset.GetTopIndent: Integer;
begin
  Result := 0;
  case Style of
    sctsMac, sctsDotNet:
      Result := 3;
    sctsWindows, sctsWinXP:
    begin
      Result := 2;
      if FDrawBorder then Inc(Result, 1);
    end;
    else
    begin
      if FDrawBorder then Inc(Result, 1);
    end;
  end;
end;

procedure TSCCustomTabset.SetScrollButtons(Value: Boolean);
var
  SC, SS: Boolean;
begin
  if FScrollButtons <> Value then
  begin
    FScrollButtons := Value;

    FScrollPressed  := False;
    FIsLeftScroller := False;

    CheckButtonIsVisible(SC);
    CheckScrollersVisible(SS);
    if not (SC or SC) then Invalidate;
  end;
end;

function TSCCustomTabset.GetScrollersRect(IsVisible: Boolean): TRect;
begin
  Result := GetButtonRect(FIsButtonVisible);

  with Result do
  begin
    Right := Left;

    InflateRect(Result, 0, -3);
    if Bottom < Top then Bottom := Top;

    OffsetRect(Result, -3, 0);
    if IsVisible then Dec(Left, 2*GetScrollerWidth);
  end;
end;

function TSCCustomTabset.GetScrollerWidth: Integer;
begin
  Result := 16;
end;

procedure TSCCustomTabset.DrawScrollers(ACanvas: TCanvas; X, Y: Integer);

  procedure DrawScrollerFrame(R: TRect; IsLeft: Boolean; AColor: TColor);
  var
    BColor: TColor;
    IsDown, IsHot, IsEnabled: Boolean;
  begin
    IsEnabled := (IsLeft and FLeftScrollEnabled) or
      (not IsLeft and FRightScrollEnabled);

    IsHot := False;
    IsDown := FScrollPressed and IsEnabled and (IsLeft = FIsLeftScroller);

    if not IsDown and IsEnabled then
      IsHot := FScrollerIsHot and (IsLeft = FIsLeftScroller);

    case Style of
      sctsWindows, sctsDotNet:
      begin
        if FFlatButton then
        begin
          if IsDown then
            scFrame3D(ACanvas, R, GetBtnShadowOf(AColor), GetBtnHighlightOf(AColor), 1, 0)
          else
          if IsHot then
            scFrame3D(ACanvas, R, GetBtnHighlightOf(AColor), GetBtnShadowOf(AColor), 1, 0);
        end else
        if IsDown then
        begin
          scFrame3D(ACanvas, R, Get3DDkShadowOf(AColor), Get3DDkShadowOf(AColor), 1, 0);
          scFrame3D(ACanvas, R, GetBtnShadowOf(AColor), GetBtnShadowOf(AColor), 1, 0);
        end else
        begin
          scFrame3D(ACanvas, R, AColor, Get3DDkShadowOf(AColor), 1, 0);
          scFrame3D(ACanvas, R, GetBtnHighlightOf(AColor), GetBtnShadowOf(AColor), 1, 0);
        end;
      end;
      sctsWinXP:
      begin
        if FFlatButton then
        begin
          if IsDown then
            scFrame3D(ACanvas, R, GetBtnShadowOf(AColor), GetBtnHighlightOf(AColor), 1, 0)
          else
          if IsHot then
            scFrame3D(ACanvas, R, GetBtnHighlightOf(AColor), GetBtnShadowOf(AColor), 1, 0);
        end else
        if IsDown then
        begin
          scFrame3D(ACanvas, R, GetBtnShadowOf(AColor), GetBtnShadowOf(AColor), 1, 0);
          scFrame3D(ACanvas, R, AColor, GetBtnHighlightOf(AColor), 1, 0);
        end else
        begin
          scFrame3D(ACanvas, R, GetBtnShadowOf(AColor), GetBtnShadowOf(AColor), 1, 0);
          scFrame3D(ACanvas, R, GetBtnHighlightOf(AColor), AColor, 1, 0);
        end;
      end;
      sctsMac:
      begin
        BColor := BlendedColor(AColor, 80, 80, 80, False);
        AColor := BlendedColor(AColor, 80, 80, 80, True);

        if FFlatButton then
        begin
          if IsDown then
            scFrame3D(ACanvas, R, clWindowFrame, clWindowFrame, 1, 0)
          else
          if IsHot then
          begin
            scFrame3D(ACanvas, R, clWindowFrame, clWindowFrame, 1, 0);
            scFrame3D(ACanvas, R, AColor, BColor, 1, 0);
          end;
        end else
        if IsDown then
        begin
          scFrame3D(ACanvas, R, clWindowFrame, clWindowFrame, 1, 0);
          scFrame3D(ACanvas, R, BColor, AColor, 1, 0);
        end else
        begin
          scFrame3D(ACanvas, R, clWindowFrame, clWindowFrame, 1, 0);
          scFrame3D(ACanvas, R, AColor, BColor, 1, 0);
        end;
      end;
    end;
  end;

const
  ArrowWidth = 5;
var
  R, BR: TRect;
  Pts: array[0..2] of TPoint;
  AColor, BColor, SColor: TColor;
  SW, ArrowHeight, ArrowSpare, ArrowShift: Integer;
begin
  if not FScrollersVisible or (ACanvas = nil) then
    Exit;

  R := GetScrollersRect(FScrollersVisible);
  OffsetRect(R, X, Y);

  ArrowHeight := 2*ArrowWidth;
  if not IsRectEmpty(R) and (R.Bottom - R.Top >= ArrowHeight) then
  begin
    BR := R;

    SColor := FScrollerColor;
    if BlendColor then SColor := DefaultBlendedColor(SColor);

    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := SColor;
      FillRect(BR);
    end;

    SW := GetScrollerWidth;
    if FStyle = sctsOwnerDraw then
    begin
      BR := R;
      Dec(BR.Right, SW);
      
      scFrame3D(ACanvas, BR, GetBtnShadowOf(SColor), GetBtnShadowOf(SColor), 1, 0);
      DoDrawScrollerEvent(ACanvas, BR, True);

      BR := R;
      Inc(BR.Left, SW);
      scFrame3D(ACanvas, BR, clBtnShadow, clBtnShadow, 1, 0);
      DoDrawScrollerEvent(ACanvas, BR, False);

      Exit;
    end else
    begin
      // Draw left scroller arrow
      Dec(BR.Right, SW);
      ArrowSpare := ((BR.Bottom - BR.Top) - ArrowHeight) div 2;

      ArrowShift := 0;
      if FLeftScrollEnabled and FScrollPressed and FIsLeftScroller then
        ArrowShift := 1;

      // left mid
      Pts[0].x := BR.Left + ((SW - ArrowWidth) div 2) - ArrowShift;
      Pts[0].y := BR.Top + ArrowSpare + ArrowWidth + ArrowShift;
      // right top
      Pts[1].x := Pts[0].x + ArrowWidth;
      Pts[1].y := BR.Top + ArrowSpare + ArrowShift;
      // right bottom
      Pts[2].x := Pts[1].x;
      Pts[2].y := Pts[1].y + ArrowHeight;

      AColor := FScrollArrowColor;
      BColor := FScrollArrowColor;

      if not FLeftScrollEnabled then
      begin
        AColor := FScrollerColor;

        if FStyle = sctsWindows then
        begin
          AColor := clBtnShadow;
          BColor := clBtnShadow;
        end;
      end;

      if BlendColor then
      begin
        BColor := DefaultBlendedColor(BColor);
        AColor := DefaultBlendedColor(AColor);
      end;

      with ACanvas do
      begin
        Brush.Color := AColor;
        Pen.Color := BColor;
        Polygon(Pts);
      end;

      DrawScrollerFrame(BR, True, SColor);

      // Draw right scroller arrow
      OffsetRect(BR, SW, 0);
      ArrowSpare := ((BR.Bottom - BR.Top) - ArrowHeight) div 2;

      ArrowShift := 0;
      if FRightScrollEnabled and FScrollPressed and not FIsLeftScroller then
        ArrowShift := 1;

      // left mid
      Pts[0].x := BR.Right - ((SW - ArrowWidth) div 2) + ArrowShift;
      Pts[0].y := BR.Top + ArrowSpare + ArrowWidth + ArrowShift;
      // right top
      Pts[1].x := Pts[0].x - ArrowWidth;
      Pts[1].y := BR.Top + ArrowSpare + ArrowShift;
      // right bottom
      Pts[2].x := Pts[1].x;
      Pts[2].y := Pts[1].y + ArrowHeight;

      AColor := FScrollArrowColor;
      BColor := FScrollArrowColor;

      if not FRightScrollEnabled then
      begin
        AColor := FScrollerColor;

        if FStyle = sctsWindows then
        begin
          AColor := clBtnShadow;
          BColor := clBtnShadow;
        end;
      end;

      if BlendColor then
      begin
        BColor := DefaultBlendedColor(BColor);
        AColor := DefaultBlendedColor(AColor);
      end;

      with ACanvas do
      begin
        Brush.Color := AColor;
        Pen.Color := BColor;
        Polygon(Pts);
      end;

      DrawScrollerFrame(BR, False, SColor);
    end;
  end;
end;

procedure TSCCustomTabset.DoDrawBackground(ACanvas: TCanvas;
  const ARect: TRect);
begin
  if Assigned(FOnDrawBkground) then FOnDrawBkground(Self, ACanvas, ARect);
end;

procedure TSCCustomTabset.DoDrawScrollerEvent(ACanvas: TCanvas;
  const ARect: TRect; const IsLeft: Boolean);
begin
  if Assigned(FOnDrawScroller) then FOnDrawScroller(Self, ACanvas, ARect, IsLeft);
end;

procedure TSCCustomTabset.DoDrawTab(ATab: TSCTabsetPanel; ACanvas: TCanvas;
  const ARect: TRect);
begin
  if Assigned(FOnDrawTab) then FOnDrawTab(Self, ATab, ACanvas, ARect);
end;

procedure TSCCustomTabset.DoDrawButton(ACanvas: TCanvas; const ARect: TRect);
begin
  if Assigned(FOnDrawButton) then FOnDrawButton(Self, ACanvas, ARect);
end;

procedure TSCCustomTabset.Loaded;
var
  SC: Boolean;
begin
  inherited Loaded;
  CheckButtonIsVisible(SC);
  CheckScrollersVisible(SC);
end;

function TSCCustomTabset.IsCursorOverLeftScroller: Boolean;
var
  P: TPoint;
begin
  Result := False;
  if not GetCursorPos(P) then Exit;

  P := ScreenToClient(P);
  Result := IsLeftScrollerPos(P.X, P.Y);
end;

function TSCCustomTabset.IsCursorOverRightScroller: Boolean;
var
  P: TPoint;
begin
  Result := False;
  if not GetCursorPos(P) then Exit;

  P := ScreenToClient(P);
  Result := IsRightScrollerPos(P.X, P.Y);
end;

function TSCCustomTabset.IsLeftScrollerPos(X, Y: Integer): Boolean;
var
  R: TRect;
begin
  Result := False;
  if not FScrollersVisible then Exit;

  R := GetScrollersRect(True);
  Dec(R.Right, GetScrollerWidth);
  Result := PtInRect(R, Point(X, Y));
end;

function TSCCustomTabset.IsRightScrollerPos(X, Y: Integer): Boolean;
var
  R: TRect;
begin
  Result := False;
  if not FScrollersVisible then Exit;

  R := GetScrollersRect(True);
  Inc(R.Left, GetScrollerWidth);
  Result := PtInRect(R, Point(X, Y));
end;

procedure TSCCustomTabset.SetScrollerColor(Value: TColor);
begin
  if FScrollerColor <> Value then
  begin
    FScrollerColor := Value;
    if FScrollersVisible then DrawScrollers(Self.Canvas, 0, 0);
  end;
end;

procedure TSCCustomTabset.SetScrollArrowColor(Value: TColor);
begin
  if FScrollArrowColor <> Value then
  begin
    FScrollArrowColor := Value;
    if FScrollersVisible then DrawScrollers(Self.Canvas, 0, 0);
  end;
end;

function TSCCustomTabset.CheckScrollersEnabled: Boolean;
var
  I: Integer;
  ATab: TSCTabsetPanel;
  R, CR: TRect;
  OldLeft, OldRight: Boolean;
begin
  Result := False;
  if not CanGetClientRect then Exit;

  OldLeft  := FLeftScrollEnabled;
  OldRight := FRightScrollEnabled;
  try
    if not (FScrollersVisible and
      (FTabs <> nil) and (FTabs.Count > 0)) then Exit;

    FLeftScrollEnabled := False;
    FRightScrollEnabled := False;

    CR := GetTabsRect;
    for I := 0 to FTabs.Count-1 do
    begin
      ATab := FTabs[I];
      if not ATab.Visible then Continue;

      R := GetTabRect(ATab);

      FLeftScrollEnabled  := FLeftScrollEnabled or
        (R.Right <= CR.Left) or (R.Left < CR.Left);
      FRightScrollEnabled := FRightScrollEnabled or
        (R.Left >= CR.Right) or (R.Right > CR.Right);

      if FLeftScrollEnabled and FRightScrollEnabled then Exit; 
    end;
  finally
    Result := (OldLeft <> FLeftScrollEnabled) or
      (OldRight <> FRightScrollEnabled);
  end;
end;

procedure TSCCustomTabset.ScrollToNext(FromTab: Integer);
var
  CR: TRect;
  I, W, FrstTab: Integer;
  ATab: TSCTabsetPanel;
begin
  if not (CanGetClientRect and
    (FTabs <> nil) and (FTabs.Count > 0)) then
  begin
    SetFirstTabIndex(-1);
    Exit;
  end;

  FrstTab := FromTab;
  CheckFirstTab(FrstTab);

  if FrstTab < 0 then FrstTab := -1;

  for I := FrstTab + 1 to FTabs.Count-1 do
    if FTabs[I].Visible then
    begin
      FrstTab := I;
      Break;
    end;

  CR := GetTabsRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  if FrstTab < -1 then FrstTab := 0;

  W := 0;
  for I := FrstTab to FTabs.Count-1 do
  begin
    ATab := FTabs[I];
    if not ATab.Visible then Continue;

    Inc(W, GetTabWidth(ATab));
    if W >= CR.Right then Break;
  end;

  if W < CR.Right then
  begin
    W := 0;

    for I := FTabs.Count-1 downto 0 do
    begin
      ATab := FTabs[I];
      if not ATab.Visible then Continue;

      Inc(W, GetTabWidth(ATab));
      if W >= CR.Right then
      begin
        FrstTab := I+1;
        Break;
      end;
    end;
  end;

  if not IsValidTab(FrstTab) then
  begin
    if FrstTab < 0 then FrstTab := 0;

    for I := FrstTab to FTabs.Count-1 do
      if FTabs[I].Visible then
      begin
        FrstTab := I;
        Break;
      end;
  end;

  SetFirstTabIndex(FrstTab);
end;

procedure TSCCustomTabset.ScrollToPrev(FromTab: Integer);
var
  I, FrstTab: Integer;
begin
  if not (CanGetClientRect and
    (FTabs <> nil) and (FTabs.Count > 0)) then
  begin
    SetFirstTabIndex(-1);
    Exit;
  end;

  FrstTab := FromTab;
  CheckFirstTab(FrstTab);

  if FrstTab < 0 then FrstTab := 0;

  for I := FrstTab - 1 downto 0 do
    if FTabs[I].Visible then
    begin
      FrstTab := I;
      Break;
    end;

  if not IsValidTab(FrstTab) then
    for I := 0 to FTabs.Count - 1 do
      if FTabs[I].Visible then
      begin
        FrstTab := I;
        Break;
      end;

  SetFirstTabIndex(FrstTab);     
end;

procedure TSCCustomTabset.UpdateScrollersOn(ACanvas: TCanvas);
var
  CR, R, R2: TRect;
  ABitmap: TBitmap;
begin
  if not (FScrollersVisible and
    (ACanvas <> nil) and CanGetClientRect) then Exit;

  ABitmap := nil;
  try
    CR := ClientRect;
    R2 := GetScrollersRect(True);

    IntersectRect(R, R2, CR);
    if IsRectEmpty(R) then Exit;

    ABitmap := TBitmap.Create;
    with ABitmap do
    begin
      Width  := R.Right - R.Left;
      Height := R.Bottom - R.Top;
    end;

    DrawScrollers(ABitmap.Canvas, -R.Left, -R.Top);
    ACanvas.Draw(R.Left, R.Top, ABitmap);

    if FDrawBorder and not EqualRect(R, R2) then
      UpdateBorder(Self.Canvas);
  finally
    if ABitmap <> nil then ABitmap.Free;
  end;
end;

procedure TSCCustomTabset.UpdateButtonAndScrollers(X, Y: Integer);
var
  P: TPoint;
  MsMovedTab: Integer;
  WasHot, WasLeft, WasOnButton: Boolean;
begin
  P := Point(X, Y);

  WasOnButton := FOnButton;
  FOnButton   := FButtonVisible and
    not IsDesigning and IsButtonPos(X, Y);

  if FScrollersVisible and FScrollPressed then
  begin
    if FIsLeftScroller then
    begin
      if not IsLeftScrollerPos(X, Y) then
        UpdateScrollersOn(Self.Canvas);
    end else
    begin
      if not IsRightScrollerPos(X, Y) then
        UpdateScrollersOn(Self.Canvas);
    end;
  end else
  if FMouseDownTab < 0 then
  begin
    if WasOnButton <> FOnButton then
      DrawButton(Self.Canvas);

    if not FBtnPressed then
    begin
      MsMovedTab := TabAtPos(P);
      
      if MsMovedTab = -1 then
      begin
        WasHot  := FScrollerIsHot;
        WasLeft := FIsLeftScroller;

        FScrollerIsHot := IsLeftScrollerPos(X, Y);
        if FScrollerIsHot then
          FIsLeftScroller := True
        else if IsRightScrollerPos(X, Y) then
        begin
          FScrollerIsHot := True;
          FIsLeftScroller := False;
        end;

        if (WasHot <> FScrollerIsHot) or
          (FScrollerIsHot and (WasLeft <> FIsLeftScroller)) then
          UpdateScrollersOn(Self.Canvas);
      end;
    end;
  end;
end;

function TSCCustomTabset.CheckScrollersVisible(var StateChanged: Boolean): Boolean;
begin
  Result := FScrollButtons;
  if Result and FAutoShowScrollers then Result := FIsButtonVisible or not AllTabsInView;

  StateChanged := FScrollersVisible <> Result;
  StateChanged := CheckScrollersEnabled or StateChanged;

  if StateChanged then
  begin
    FScrollersVisible := Result;
    CheckScrollersEnabled;

    if not FScrollersVisible and (FTabs <> nil) and
      (FTabs.Count > 0) and (FFirstTabIndex <> 0) then
    begin
      SetFirstTabIndex(0);
      Exit;
    end;

    Invalidate;
  end;
end;

procedure TSCCustomTabset.SetAutoShowScrollers(Value: Boolean);
var
  SC: Boolean;
begin
  if FAutoShowScrollers <> Value then
  begin
    FAutoShowScrollers := Value;
    CheckButtonIsVisible(SC);
    CheckScrollersVisible(SC);
  end;
end;

procedure TSCCustomTabset.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomTabset then
  begin
    with TSCCustomTabset(Source) do
    begin
      Self.AutoShowButton := AutoShowButton;
      Self.AutoShowScrollers := AutoShowScrollers;
      Self.AutoSizeTabs := AutoSizeTabs;
      Self.ButtonColor := ButtonColor;
      Self.ButtonVisible := ButtonVisible;
      Self.DefaultTabColor := DefaultTabColor;
      Self.DrawBorder := DrawBorder;
      Self.FlatButton := FlatButton;
      Self.ScrollButtons := ScrollButtons;
      Self.ScrollArrowColor := ScrollArrowColor;
      Self.ScrollerColor := ScrollerColor;
      Self.SelectedColor := SelectedColor;
      Self.SelectedFontColor := SelectedFontColor;
      Self.Tabs := Tabs;
      Self.TabPosition := TabPosition;
      Self.Style := Style;
      Self.UseSystemFont := UseSystemFont;
      Self.UseDefaultColor := UseDefaultColor;
      Self.XPHotColor := XPHotColor;
      Self.Selected := Selected;
    end;
  end;
end;

function TSCCustomTabset.GetSelectedPanel: TSCTabsetPanel;
var
  I: Integer;
begin
  Result := nil;
  if FTabs <> nil then
    for I := 0 to FTabs.Count-1 do
      if FTabs[I].Selected then
      begin
        Result := FTabs[I];
        Exit;
      end;
end;

{$I SCVerRec.inc}

end.
