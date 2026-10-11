{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCPopupColors;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCommon, SCConsts, SCControl, SCAdvEdits, SCColorbox;

type
  TSCCustomPopupColors = class(TSCCustomDropDown)
  private
    FAutoColor: TColor;
    FAutoCaption: String;
    FBasicColorType: TSCBasicColorType;
    FCellSize: Integer;
    FColumnCount: Integer;
    FCustomColors: TSCColorboxItems;
    FMoreColor: TColor;
    FMoreCaption: String;
    FOptions: TSCColorboxOptions;
    FSelectedColor: TColor;
    FShowColorHints: Boolean;
    FPopupAutoSize: Boolean;
    FPopupColor: TColor;
    FPopupHeight: Integer;
    FPopupWidth: Integer;
    FPopupBorderStyle: TSCEditStyle;
    FPopupStyle: TSCColorBoxStyle;
    FOnMoreButtonClick: TNotifyEvent;
    FOnSelectedColorChange: TNotifyEvent;
    FOnShowColorHintEvent: TSCOnShowColorHintEvent;
    FColorbox: TSCCustomColorbox;
    procedure SetCustomColors(Value: TSCColorboxItems);
    procedure SetPopupHeight(Value: Integer);
    procedure SetPopupWidth(Value: Integer);
    procedure SetSelectedColor(const Value: TColor);

    procedure ColorboxMoreButtonClick(Sender: TObject);
    procedure ColorboxShowColorHintEvent(Sender: TObject; C: TColor;
      var H: String);
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function  GetButtonPropsClass: TSCCustomEditButtonPropsClass; override;

    procedure PaintLine(C: TCanvas; Index, H, TxTop: Integer); override;
    procedure DoDrawBack(C: TCanvas); override;

    function  GetPopupStyle: TSCEditStyle; override;
    function  GetIsDropDown: Boolean; override;
    procedure DropDownPopupbox; override;
    procedure CloseUp; override;
    procedure PrepareDropWindow; override;

    function  CanDropDown: Boolean; override;
    function  GetDroppedDown: Boolean; override;
    function  GetDropDownWindow: TWinControl; override;

    procedure DoSelectedColorChange; dynamic;

    property AutoColor: TColor read FAutoColor write FAutoColor default clNone;
    property AutoCaption: String read FAutoCaption write FAutoCaption;
    property BasicColorType: TSCBasicColorType read FBasicColorType write FBasicColorType default scbtWordFont;
    property CellSize: Integer read FCellSize write FCellSize default 12;
    property ColumnCount: Integer read FColumnCount write FColumnCount default 8;
    property CustomColors: TSCColorboxItems read FCustomColors write SetCustomColors;
    property MoreColor: TColor read FMoreColor write FMoreColor default clNone;
    property MoreCaption: String read FMoreCaption write FMoreCaption;
    property Options: TSCColorboxOptions read FOptions write FOptions default DefaultColorboxOptions;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clNone;
    property ShowColorHints: Boolean read FShowColorHints write FShowColorHints default True;
    property PopupAutoSize: Boolean read FPopupAutoSize write FPopupAutoSize default True;
    property PopupBorderStyle: TSCEditStyle read FPopupBorderStyle write FPopupBorderStyle default scesDefault;
    property PopupColor: TColor read FPopupColor write FPopupColor default clWindow;
    property PopupHeight: Integer read FPopupHeight write SetPopupHeight default -1;
    property PopupWidth: Integer read FPopupWidth write SetPopupWidth default -1;
    property PopupStyle: TSCColorBoxStyle read FPopupStyle write FPopupStyle default sccbOfficeXPbox;
    property OnMoreButtonClick: TNotifyEvent read FOnMoreButtonClick write FOnMoreButtonClick;
    property OnSelectedColorChange: TNotifyEvent read FOnSelectedColorChange write FOnSelectedColorChange;
    property OnShowColorHintEvent: TSCOnShowColorHintEvent read FOnShowColorHintEvent write FOnShowColorHintEvent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCPopupColors = class(TSCCustomPopupColors)
  public
    property ShowPicture;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoColor;
    property AutoCaption;
    property AutoSize;
    property BasicColorType;
    property BorderProps;
    property ButtonProps;
    property Checkbox;
    property CellSize;
    property ColumnCount;
    property Constraints;
    property CustomColors;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownKey;
    property Enabled;
    property EnterAsTab;
    property FrameColor;
    property FocusColor;
    property FocusTextColor;
    property FocusExpandSize;
    property Font;
    property ImageIndex;
    property Images;
    property MoreColor;
    property MoreCaption;
    property Options;
    property Picture;
    property PictureProps;
    property SelectedColor;
    property ShowColorHints;
    property ShowHint;
    property PopupAutoSize;
    property PopupBorderStyle;
    property PopupColor;
    property PopupHeight;
    property PopupWidth;
    property PopupStyle;
    property Style;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseImage;
    property Visible;
    property ExUseColor;
    property OnCanResize;
    property OnCheckboxChange;
    property OnClick;
    property OnCloseUp;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMoreButtonClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnSelectedColorChange;
    property OnShowColorHintEvent;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

const
  CM_CANCEL = WM_USER + $9876;
  CM_CANCEL_POPUP = WM_USER + $8765;

type
  TSCPopupColorbox = class(TSCCustomColorbox)
  private
    FInPopup: Boolean;
    FPreparingPopup: Boolean;
    FCancelPopup: Boolean;
    FPopupbox: TSCCustomPopupColors;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    function  IsChildHandle(AHandle: HWND): Boolean;
    procedure Cancel;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;

    procedure DoBoxClick; override;

    property InPopup: Boolean read FInPopup;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Popup(C: TSCCustomPopupColors);
  end;

{ TSCPopupColorbox }

procedure TSCPopupColorbox.Cancel;
begin
  PostMessage(Handle, CM_CANCEL, 0, 0);
end;

constructor TSCPopupColorbox.Create(AOwner: TComponent);
begin
  inherited;
  BlendColor := False;
  Visible := False;
  FCancelPopup := False;
  Parent := GetParentForm(TControl(AOwner));
end;

procedure TSCPopupColorbox.CreateParams(var Params: TCreateParams);
begin
  inherited;

  with Params do
  begin
    Style := WS_POPUP;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
  end;
end;

procedure TSCPopupColorbox.DoBoxClick;
begin
  if FPopupbox <> nil then
    FPopupbox.SetSelectedColor(Self.SelectedColor);
  Cancel;
end;

function TSCPopupColorbox.IsChildHandle(AHandle: HWND): Boolean;
begin
  Result := False;
  while AHandle <> 0 do
  begin
    Result := AHandle = Handle;
    if Result then Exit;

    AHandle := GetParent(AHandle);
  end;
end;

procedure TSCPopupColorbox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = FPopupbox) then
  begin
    FPopupbox := nil;
    if FInPopup then
      Cancel;
  end;
end;

procedure TSCPopupColorbox.Popup(C: TSCCustomPopupColors);
var
  Msg: TMsg;
  P: TPoint;
  W, H: Integer;

  procedure InitiatePopup;
  begin
    FPreparingPopup := True;
    try
      Visible := False;
      
      P := Point(0, 0);
      if FPopupbox.Parent <> nil then
      begin
        P := Point(FPopupbox.Left, FPopupbox.Top + FPopupbox.Height);
        P := Self.ScreenToClient(FPopupbox.Parent.ClientToScreen(P));
      end;

      H := FPopupbox.FPopupHeight;
      if H <= 0 then H := Self.Height;

      W := FPopupbox.FPopupWidth;
      if W <= 0 then W := Self.Width;

      Parent := FPopupbox;
      Windows.SetFocus(Handle);
    finally
      FPreparingPopup := False;
    end;
  end;

  procedure FinalizePopup;
  begin
    FPreparingPopup := True;
    try
      try
        SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOACTIVATE or
          SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE);

        Visible := False;
      finally
        Parent := nil;
      end;
    finally
      FPreparingPopup := False;
    end;
  end;

  procedure DoPopup;
  begin
    try
      while not FCancelPopup and Visible and
        Application.Active and not Application.Terminated do
      begin
        if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then
        begin
          case Msg.message of
            WM_NCACTIVATE:
            begin
              if (Msg.hwnd = Self.Handle) or IsChildHandle(Msg.hwnd) then
                PeekMessage(Msg, 0, 0, 0, PM_REMOVE)
              else
                Break;
            end;
            WM_MOUSEACTIVATE:
            begin
              if (Msg.hwnd = Self.Handle) or IsChildHandle(Msg.hwnd) then
                PeekMessage(Msg, 0, 0, 0, PM_REMOVE)
              else
                Break;
            end;
            WM_SYSCOMMAND:
            begin
              if Msg.WParam = 61448 then
                inherited
              else
                Cancel;
            end;
            WM_NCLBUTTONDOWN, WM_NCRBUTTONDOWN,
            WM_NCMBUTTONDOWN, WM_LBUTTONDOWN,
            WM_MBUTTONDOWN,   WM_RBUTTONDOWN,
            WM_LBUTTONDBLCLK, WM_RBUTTONDBLCLK,
            WM_MBUTTONDBLCLK:
            begin
              if (Msg.hwnd <> Self.Handle) and not IsChildHandle(Msg.hwnd) then
              begin
                if Msg.hwnd = FPopupbox.Handle then
                  PeekMessage(Msg, 0, 0, 0, PM_REMOVE);

                Break;
              end;
            end;
            WM_KEYFIRST..WM_KEYLAST:
            begin
              if (Msg.message = WM_KEYDOWN) and (Msg.wParam = VK_ESCAPE) and
                 (Msg.hwnd = Self.Handle) then
              begin
                PeekMessage(Msg, 0, Msg.message, Msg.message, PM_REMOVE);
                Exit;
              end;

              if (Msg.message = WM_SYSKEYDOWN) and (Msg.wParam = VK_RETURN) then
                PeekMessage(Msg, 0, Msg.message, Msg.message, PM_REMOVE);
            end;
            WM_KILLFOCUS, CM_CANCEL:
              Exit;
            CM_DEACTIVATE, WM_ACTIVATEAPP:
              Break;
          end;
        end;

        Application.HandleMessage;
      end;
    finally
      FinalizePopup;
    end;
  end;

begin
  if FInPopup or (C = nil) then
    Exit;

  FCancelPopup := False;

  FPopupbox := C;
  FPopupbox.FreeNotification(Self);

  InitiatePopup;

  FInPopup := True;
  try
    FPreparingPopup := True;
    try
      SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or
        SWP_NOACTIVATE or SWP_SHOWWINDOW);

      Visible := True;

      if FPopupbox <> nil then
        with FPopupbox do
        begin
          AfterDropDown;
          if Assigned(OnDropDown) then
            OnDropDown(FPopupbox);
        end;

      if CanFocus then
        SetFocus;
    finally
      FPreparingPopup := False;
    end;

    DoPopup;

    if FPopupbox <> nil then
      with FPopupbox do
      begin
        SetFocus;

        AfterCloseUp;
        DoCloseUp;
      end;
  finally
    FCancelPopup := False;
    FInPopup := False;
    FPopupbox := nil;

    Free;
  end;
end;

procedure TSCPopupColorbox.WMActivate(var Message: TWMActivate);
var
  F: TCustomForm;
begin
  inherited;

  if FPopupbox <> nil then
  begin
    F := GetParentForm(FPopupbox);
    if (F <> nil) and F.HandleAllocated then
      SendMessage(F.Handle, WM_NCACTIVATE, Longint(Message.Active <> WA_INACTIVE), 0);
  end;
end;

procedure TSCPopupColorbox.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    CM_CANCEL:
    begin
      Message.Result := 1;

      FCancelPopup := True;
      Hide;
    end;
    WM_NCACTIVATE:
    begin
      if FPreparingPopup then
        Message.Result := 0
      else
        inherited;
    end;
    WM_MOUSEACTIVATE:
    begin
      if FPreparingPopup then
        Message.Result := MA_NOACTIVATE
      else
        inherited;
    end;
    else
      inherited;
  end;    
end;

{ TSCCustomPopupColors }

procedure TSCCustomPopupColors.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomPopupColors then
  begin
    with TSCCustomPopupColors(Source) do
    begin
      Self.AutoColor := AutoColor;
      Self.AutoCaption := AutoCaption;
      Self.BasicColorType := BasicColorType;
      Self.CellSize := CellSize;
      Self.ColumnCount := ColumnCount;
      Self.CustomColors := CustomColors;
      Self.MoreColor := MoreColor;
      Self.MoreCaption := MoreCaption;
      Self.Options := Options;
      Self.SelectedColor := SelectedColor;
      Self.ShowColorHints := ShowColorHints;
      Self.PopupAutoSize := PopupAutoSize;
      Self.PopupBorderStyle := PopupBorderStyle;
      Self.PopupColor := PopupColor;
      Self.PopupHeight := PopupHeight;
      Self.PopupWidth := PopupWidth;
      Self.PopupStyle := PopupStyle;
    end;
  end;
end;

function TSCCustomPopupColors.CanDropDown: Boolean;
begin
  Result := not (csDesigning in ComponentState) and
    ((FColorbox = nil) or not TSCPopupColorbox(FColorbox).InPopup);
end;

procedure TSCCustomPopupColors.CloseUp;
begin
  if (FColorbox <> nil) and TSCPopupColorbox(FColorbox).InPopup then
    TSCPopupColorbox(FColorbox).Cancel;
end;

procedure TSCCustomPopupColors.ColorboxMoreButtonClick(Sender: TObject);
begin
  CloseUp;

  Application.ProcessMessages;
  if Assigned(FOnMoreButtonClick) then
    FOnMoreButtonClick(Self);
end;

procedure TSCCustomPopupColors.ColorboxShowColorHintEvent(Sender: TObject;
  C: TColor; var H: String);
begin
  if Assigned(FOnShowColorHintEvent) then
    FOnShowColorHintEvent(Self, C, H);
end;

constructor TSCCustomPopupColors.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCustomColors := TSCColorboxItems.Create(Self);

  ControlStyle := ControlStyle - [csSetCaption];
  IsDropDown := True;

  FAutoColor := clNone;
  FBasicColorType := scbtWordFont;
  FCellSize := 12;
  FColumnCount := 8;
  FMoreColor := clNone;
  FOptions := DefaultColorboxOptions;
  FSelectedColor := clNone;
  FShowColorHints := True;
  FPopupAutoSize := True;
  FPopupBorderStyle := scesDefault;
  FPopupColor := clWindow;
  FPopupHeight := -1;
  FPopupWidth := -1;
  FPopupStyle := sccbOfficeXPbox;
end;

destructor TSCCustomPopupColors.Destroy;
begin
  FCustomColors.Free;
  inherited Destroy;
end;

procedure TSCCustomPopupColors.DoDrawBack(C: TCanvas);
begin
  inherited DoDrawBack(C);
end;

procedure TSCCustomPopupColors.DoSelectedColorChange;
begin
  if Assigned(FOnSelectedColorChange) then
    FOnSelectedColorChange(Self);
end;

procedure TSCCustomPopupColors.DropDownPopupbox;
begin
  if CanDropDown and AllowDropdown then
  begin
    if FColorbox = nil then
      FColorbox := TSCPopupColorbox.Create(Self);

    PrepareDropWindow;

    Windows.SetFocus(Handle);
    if GetFocus <> Handle then
      Exit;

    SetDroppedDownFlag(True);
    try
      FColorbox.FreeNotification(Self);
      TSCPopupColorbox(FColorbox).Popup(Self);
    finally
      SetDroppedDownFlag(False);

      if FColorbox <> nil then
      begin
        with TSCPopupColorbox(FColorbox) do
        begin
          OnMoreButtonClick := nil;
          OnShowColorHintEvent := nil;
        end;  

        FColorbox.Free;
        FColorbox := nil;
      end;
    end;
  end;
end;

function TSCCustomPopupColors.GetButtonPropsClass: TSCCustomEditButtonPropsClass;
begin
  Result := TSCDropDownButtonProps;
end;

function TSCCustomPopupColors.GetDropDownWindow: TWinControl;
begin
  Result := FColorbox;
end;

function TSCCustomPopupColors.GetDroppedDown: Boolean;
begin
  Result := GetDroppedDownFlag and
   (FColorbox <> nil) and TSCPopupColorbox(FColorbox).InPopup;
end;

function TSCCustomPopupColors.GetIsDropDown: Boolean;
begin
  Result := True;
end;

function TSCCustomPopupColors.GetPopupStyle: TSCEditStyle;
begin
  Result := FPopupBorderStyle;
end;

procedure TSCCustomPopupColors.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = FColorbox) then
    FColorbox := nil;
end;

procedure TSCCustomPopupColors.PaintLine(C: TCanvas; Index, H,
  TxTop: Integer);
var
  CR, R: TRect;
  IsFocused: Boolean;
begin
  if (C = nil) or (H = 0) then
    Exit;

  CR := GetClientRect;
  if IsRectEmpty(CR) then
    Exit;

  R := GetEditRect;

  Inc(R.Left);
  InflateRect(R, 0, -1);

  if not IsRectEmpty(R) then
  begin
    IsFocused := not (csDesigning in Self.ComponentState) and
      Focused and not GetDroppedDown;

    with C do
    begin
      Brush.Style := bsSolid;
      Brush.Color := FSelectedColor;
      Dec(R.Right);

      FillRect(R);
    end;

    if IsFocused then
    begin
      R := GetEditRect;

      Inc(R.Left);
      InflateRect(R, 0, -1);

      scDrawFocusRect(C, R, FSelectedColor);

      InflateRect(R, -1, -1);
      scDrawFocusRect(C, R, FSelectedColor);
    end;
  end;
end;

procedure TSCCustomPopupColors.PrepareDropWindow;
begin
  if FColorbox = nil then
    Exit;

  BeforePrepareDropWindow;
  
  with TSCPopupColorbox(FColorbox) do
  begin
    AutoColor      := Self.AutoColor;
    AutoCaption    := Self.AutoCaption;
    AutoSize       := Self.PopupAutoSize;
    BasicColorType := Self.BasicColorType;
    CellSize       := Self.CellSize;
    Color          := Self.PopupColor;
    ColumnCount    := Self.ColumnCount;
    CustomColors   := Self.CustomColors;
    Font           := Self.Font;
    MoreColor      := Self.MoreColor;
    MoreCaption    := Self.MoreCaption;
    Options        := Self.Options;
    SelectedColor  := Self.SelectedColor;
    ShowColorHints := Self.ShowColorHints;
    Style          := Self.PopupStyle;

    ApplyPopupBorder(TSCPopupColorbox(FColorbox));

    if FPopupHeight > 0 then
      Height := FPopupHeight;

    if FPopupWidth > 0 then
      Width := FPopupWidth;
  end;

  CalcPosition(FColorbox);

  with TSCPopupColorbox(FColorbox) do
  begin
    OnMoreButtonClick := Self.ColorboxMoreButtonClick;
    OnShowColorHintEvent := Self.ColorboxShowColorHintEvent;
  end;  
end;

procedure TSCCustomPopupColors.SetCustomColors(Value: TSCColorboxItems);
begin
  FCustomColors.Assign(Value);
end;

procedure TSCCustomPopupColors.SetPopupHeight(Value: Integer);
begin
  if Value < -1 then Value := -1;
  FPopupHeight := Value;
end;

procedure TSCCustomPopupColors.SetPopupWidth(Value: Integer);
begin
  if Value < -1 then Value := -1;
  FPopupWidth := Value;
end;

procedure TSCCustomPopupColors.SetSelectedColor(const Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;
    Invalidate;

    DoSelectedColorChange;
  end;
end;

procedure TSCCustomPopupColors.WndProc(var Message: TMessage);
var
  Shift: TShiftState;
begin
  case Message.Msg of
    WM_KEYDOWN, WM_SYSKEYDOWN, WM_CHAR:
    begin
      with TWMKey(Message) do
      begin
        Shift := KeyDataToShiftState(KeyData);
        if (Message.Msg <> WM_CHAR) and DoDropDownKeys(CharCode, Shift) then
          Exit;
      end;
    end;
  end;

  inherited;
end;

{$I SCVerRec.inc}

end.
