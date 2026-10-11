{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCSplitter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCConsts, SCCommon, SCControl;

type
  TSCSplitterAlign = (scsaLeft, scsaRight, scsaTop, scsaBottom);
  TSCSplitterPart = (scspNone, scspClient, scspHotZone);

  TSCSplitterResizeStyle = (scrsNone, scrsUpdate, scrsLine, scrsPattern);

  TSCSplitterHotZoneStyle = (scshNone, scshMediaPlayer, scshMediaPlayer9, 
    scshOfficeXP, scshMetal, scshSimple, scshXPTaskbar, scshOutlook2003,
    scshMacromedia);

  TSCCustomSplitter = class;

  TSCSplitterHotZone = class(TPersistent)
  private
    FArrowColor: TColor;
    FArrowDownColor: TColor;
    FArrowHotColor: TColor;
    FColor: TColor;
    FDownColor: TColor;
    FHotColor: TColor;
    FSize: Integer;
    FStyle: TSCSplitterHotZoneStyle;
    FOwner: TSCCustomSplitter;
    procedure SetArrowColor(Value: TColor);
    procedure SetArrowDownColor(Value: TColor);
    procedure SetArrowHotColor(Value: TColor);
    procedure SetColor(Value: TColor);
    procedure SetDownColor(Value: TColor);
    procedure SetHotColor(Value: TColor);
    procedure SetSize(Value: Integer);
    procedure SetStyle(Value: TSCSplitterHotZoneStyle);
  protected
    procedure DoDrawArrow(Canvas: TCanvas; X, Y: Integer; Cl: TColor;
      Align: TSCSplitterAlign);
    procedure DoDrawMediaPlayer(Canvas: TCanvas; R: TRect; Cl, ACl: TColor;
      Align: TSCSplitterAlign); virtual;
    procedure DoDrawMediaPlayer9(Canvas: TCanvas; R: TRect; Cl, ACl: TColor;
      Align: TSCSplitterAlign); virtual;
    procedure DoDrawOfficeXP(Canvas: TCanvas; R: TRect; Cl, ACl: TColor;
      Align: TSCSplitterAlign); virtual;
    procedure DoDrawMetal(Canvas: TCanvas; R: TRect; Cl, ACl: TColor;
      Align: TSCSplitterAlign); virtual;
    procedure DoDrawSimple(Canvas: TCanvas; R: TRect; Cl, ACl: TColor;
      Align: TSCSplitterAlign); virtual;
    procedure DoDrawXPTaskbar(Canvas: TCanvas; R: TRect; Cl, ACl: TColor;
      Align: TSCSplitterAlign); virtual;
    procedure DoDrawOutlook2003(Canvas: TCanvas; R: TRect; Cl, ACl: TColor;
      Align: TSCSplitterAlign); virtual;
    procedure DoDrawMacromedia(Canvas: TCanvas; R: TRect; Cl, ACl: TColor;
      Align: TSCSplitterAlign); virtual;

    function  GetOwner: TPersistent; override;
    procedure Paint(Canvas: TCanvas; R: TRect; Align: TSCSplitterAlign); virtual;

    function  IsDown: Boolean;
    function  IsHot: Boolean;
    function  IsClientDown: Boolean;

    procedure DoColorChanged;
    procedure DoChanged(Force: Boolean = False);
  public
    constructor Create(AOwner: TSCCustomSplitter); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property ArrowColor: TColor read FArrowColor write SetArrowColor default clWindowText;
    property ArrowDownColor: TColor read FArrowDownColor write SetArrowDownColor default clNone;
    property ArrowHotColor: TColor read FArrowHotColor write SetArrowHotColor default clNone;
    property Color: TColor read FColor write SetColor default clNone;
    property DownColor: TColor read FDownColor write SetDownColor default clNone;
    property HotColor: TColor read FHotColor write SetHotColor default clNone;
    property Size: Integer read FSize write SetSize default 120;
    property Style: TSCSplitterHotZoneStyle read FStyle write SetStyle default scshSimple;
  end;

  TSCSplitterBevel = (scsbNone, scsbLineLowered, scsbLineRaised, scsbFullLowered,
    scsbFullRaised);

  TSCCanResizeControlEvent = procedure(Sender: TObject; var NewSize: Integer;
    var Accept: Boolean) of object;

  TSCCustomSplitter = class(TSCCustomControl)
  private
    FAlignSplitter: TSCSplitterAlign;
    FAutoSnap: Boolean;
    FBevel: TSCSplitterBevel;
    FCanHotZoneDrag: Boolean;
    FControl: TControl;
    FDragThreshold: Integer;
    FHotZone: TSCSplitterHotZone;
    FHottrack: Boolean;
    FHottrackColor: TColor;
    FMinSize: Integer;
    FResizeStyle: TSCSplitterResizeStyle;
    FDownPart: TSCSplitterPart;
    FHotPart: TSCSplitterPart;
    FClickPos: TPoint;
    FControlBounds: TRect;
    FInSize: Boolean;
    FSplit: Integer;
    FMaxSize: Integer;
    FNewSize: Integer;
    FOldSize: Integer;
    FCollapseBounds: TRect;
    FCollapsed: Boolean;
    FInternalAlign: Boolean;
    FDefaultCursor: TCursor;
    FGradient: Boolean;
    FUpdatingCursor: Boolean;
    FForceCursor: Boolean;
    FLineDC: HDC;
    FBrush: TBrush;
    FPrevBrush: HBrush;
    FLineVisible: Boolean;
    FSvShowHint: Boolean;
    FSvParentShowHint: Boolean;
    FZeroExpandSize: Cardinal;
    FOnCanResizeControl: TSCCanResizeControlEvent;
    FOnMoved: TNotifyEvent;
    procedure SetAlignSplitter(Value: TSCSplitterAlign);
    procedure SetBevel(Value: TSCSplitterBevel);
    procedure SetControl(Value: TControl);
    procedure SetDragThreshold(Value: Integer);
    procedure SetHotZone(Value: TSCSplitterHotZone);
    procedure SetHottrack(Value: Boolean);
    procedure SetHottrackColor(Value: TColor);
    procedure SetGradient(Value: Boolean);
    procedure SetMinSize(Value: Integer);
    procedure SetResizeStyle(Value: TSCSplitterResizeStyle);

    procedure CMChildKey(var Message: TMessage); message CM_CHILDKEY;
    procedure CMCursorChanged(var Message: TMessage); message CM_CURSORCHANGED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMTabStopChanged(var Message: TMessage); message CM_TABSTOPCHANGED;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;

    procedure UpdateCursor(Force: Boolean = False);
    function  UpdateControlPos(Force: Boolean = False): Boolean;

    procedure AllocateLineDC;
    procedure ReleaseLineDC;
    procedure DoDrawSizeLine(Force: Boolean = False);

    procedure DoControlMoved;
    function  DoCanResizeControl(var NewSize: Integer): Boolean;

    procedure CalcSplitSize(X, Y: Integer; ClickPos: TPoint; var NewSize, Split: Integer);
    procedure UpdateSizing(X, Y: Integer; ClickPos: TPoint);
    procedure StartSizing;
    procedure StopSizing;

    procedure HotZoneChanged;
    procedure HotZoneColorChanged;
  protected
    procedure RequestAlign; override;
    procedure Notification(ACOmponent: TComponent; Operation: TOperation); override;
    procedure ConstrainedResize(var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer); override;
    procedure Paint; override;

    procedure StopTracking; override;
    procedure MouseInControlChanged; override;

    function  CanResizeControl(var NewSize: Integer): Boolean; virtual;
    procedure ControlMoved; virtual;
    procedure CancelSizing;

    function  SplitterAlignToAlign: TAlign;
    procedure DoDrawHotZone;

    function  GetMinWidthHeight: Integer; dynamic;
    function  GetHotZoneRect: TRect; virtual;
    procedure ArrangeSize(var AWidth, AHeight: Integer); dynamic;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    property DownPart: TSCSplitterPart read FDownPart;
    property HotPart: TSCSplitterPart read FHotPart;
    property Collapsed: Boolean read FCollapsed;
    property Align default alNone;
    property AlignSplitter: TSCSplitterAlign read FAlignSplitter write SetAlignSplitter default scsaLeft;
    property AutoSnap: Boolean read FAutoSnap write FAutoSnap default True;
    property Bevel: TSCSplitterBevel read FBevel write SetBevel default scsbNone;
    property CanHotZoneDrag: Boolean read FCanHotZoneDrag write FCanHotZoneDrag default True;
    property Control: TControl read FControl write SetControl;
    property DragThreshold: Integer read FDragThreshold write SetDragThreshold default 3;
    property Gradient: Boolean read FGradient write SetGradient default False;
    property HotZone: TSCSplitterHotZone read FHotZone write SetHotZone;
    property Hottrack: Boolean read FHottrack write SetHottrack default True;
    property HottrackColor: TColor read FHottrackColor write SetHottrackColor default clInfoBk;
    property MinSize: Integer read FMinSize write SetMinSize default 30;
    property ResizeStyle: TSCSplitterResizeStyle read FResizeStyle write SetResizeStyle default scrsLine;
    property ZeroExpandSize: Cardinal read FZeroExpandSize write FZeroExpandSize default 0;
    property OnCanResizeControl: TSCCanResizeControlEvent read FOnCanResizeControl write FOnCanResizeControl;
    property OnMoved: TNotifyEvent read FOnMoved write FOnMoved;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    function  GetPartAtPos(X, Y: Integer): TSCSplitterPart;

    function  IsCollapsed: Boolean;
    procedure CollapseControl;
    procedure ExpandControl;
  end;

  TSCSplitter = class(TSCCustomSplitter)
  public
    property DownPart;
    property HotPart;
  published
    property AlignSplitter;
    property AutoSnap;
    property Bevel;
    property CanHotZoneDrag;
    property Color;
    property Constraints;
    property Control;
    property Cursor;
    property DragThreshold;
    property Enabled;
    property Gradient;
    property HotZone;
    property Hottrack;
    property HottrackColor;
    property MinSize;
    property ParentColor;
    property ParentShowHint;
    property ResizeStyle;
    property ShowHint;
    property Visible;
    property ZeroExpandSize;
    property OnCanResizeControl;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMoved;
    property OnResize;
  end;

implementation

const
  clMediaPlayer9 = $00F5E6CD;
  clMediaPlayer9Hot = $00AFF5C3;
  clMediaPlayer9HotArrow = clBlue;

{ TSCCustomSplitter }

procedure TSCCustomSplitter.AllocateLineDC;
begin
  if FLineDC <> 0 then
    ReleaseLineDC;

  FLineDC := GetDCEx(Parent.Handle, 0, DCX_CACHE or DCX_CLIPSIBLINGS
    or DCX_LOCKWINDOWUPDATE);

  if ResizeStyle = scrsPattern then
  begin
    if FBrush = nil then
    begin
      FBrush := TBrush.Create;
      FBrush.Bitmap := AllocPatternBitmap(clBlack, clWhite);
    end;

    FPrevBrush := SelectObject(FLineDC, FBrush.Handle);
  end;
end;

procedure TSCCustomSplitter.ArrangeSize(var AWidth, AHeight: Integer);
var
  Min: Integer;
begin
  Min := GetMinWidthHeight;
  if Min > 1 then
  begin
    if FAlignSplitter in [scsaLeft, scsaRight] then
      AWidth := Min
    else
      AHeight := Min;
  end;    
end;

procedure TSCCustomSplitter.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomSplitter then
  begin
    with TSCCustomSplitter(Source) do
    begin
      Self.AlignSplitter := AlignSplitter;
      Self.AutoSnap := AutoSnap;
      Self.Bevel := Bevel;
      Self.CanHotZoneDrag := CanHotZoneDrag;
      Self.DragThreshold := DragThreshold;
      Self.Gradient := Gradient;
      Self.HotZone := HotZone;
      Self.Hottrack := Hottrack;
      Self.HottrackColor := HottrackColor;
      Self.MinSize := MinSize;
      Self.ResizeStyle := ResizeStyle;
      Self.ZeroExpandSize := ZeroExpandSize;
    end;
  end;
end;

procedure TSCCustomSplitter.CalcSplitSize(X, Y: Integer; ClickPos: TPoint;
  var NewSize, Split: Integer);
var
  S: Integer;
begin
  NewSize := -1;
  Split := -1;

  if (FControl <> nil) and (ClickPos.X > -1) and (ClickPos.Y > -1) then
  begin
    if AlignSplitter in [scsaLeft, scsaRight] then
      Split := X - ClickPos.X
    else
      Split := Y - ClickPos.Y;

    S := 0;
    case AlignSplitter of
      scsaLeft:
        S := FControl.Width + Split;
      scsaRight:
        S := FControl.Width - Split;
      scsaTop:
        S := FControl.Height + Split;
      scsaBottom:
        S := FControl.Height - Split;
    end;

    NewSize := S;
    if S < FMinSize then
      NewSize := FMinSize
    else
    if S > FMaxSize then
      NewSize := FMaxSize;

    if S <> NewSize then
    begin
      if AlignSplitter in [scsaRight, scsaBottom] then
        S := S - NewSize
      else
        S := NewSize - S;
      
      Inc(Split, S);
    end;
  end;  
end;

procedure TSCCustomSplitter.CancelSizing;
var
  IsInSize: Boolean;
begin
  if HandleAllocated then
  begin
    IsInSize := FInSize;

    if IsInSize then
    begin
      FInSize := False;
      if FLineVisible then
        DoDrawSizeLine(True);

      if not IsRectEmpty(FControlBounds) and (FControl <> nil) then
        FControl.BoundsRect := FControlBounds;
    end;

    FLineVisible := False;
    FDownPart    := scspNone;
    FHotPart     := scspNone;
    FMaxSize     := 0;

    ReleaseLineDC;

    if IsInSize then
    begin
      Self.ParentShowHint := FSvParentShowHint;
      Self.ShowHint := FSvShowHint;

      Invalidate;
    end;

    if GetCapture = Handle then
      ReleaseCapture;

    UpdateCursor;
  end;
end;

function TSCCustomSplitter.CanResizeControl(var NewSize: Integer): Boolean;
begin
  Result := True;
end;

procedure TSCCustomSplitter.CMChildKey(var Message: TMessage);
begin
  if (FControl <> nil) and Enabled and
    FInSize and (Message.WParam = VK_ESCAPE) then
  begin
    Message.Result := 1;
    CancelSizing;

    Invalidate;
  end;
end;

procedure TSCCustomSplitter.CMCursorChanged(var Message: TMessage);
var
  DoInherited: Boolean;
begin
  DoInherited := True;
  if FInSize and (FForceCursor or (HandleAllocated and (GetCapture = Self.Handle))) then
  begin
    DoInherited := False;
    Perform(WM_SETCURSOR, Handle, HTCLIENT);
  end;

  if DoInherited then
    inherited;

  if not FUpdatingCursor then
  begin
    FDefaultCursor := Cursor;
    if not IsLoading then
      UpdateCursor;
  end;
end;

procedure TSCCustomSplitter.CMDialogChar(var Message: TCMDialogChar);
begin
  if (FControl <> nil) and Enabled and (Message.CharCode = VK_ESCAPE) and
    (FInSize or (FDownPart = scspHotZone)) then
  begin
    Message.Result := 1;
    if FInSize then
      CancelSizing
    else
      FDownPart := scspNone;

    Invalidate;
  end;
end;

procedure TSCCustomSplitter.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  CancelSizing;
end;

procedure TSCCustomSplitter.CMTabStopChanged(var Message: TMessage);
begin
  inherited;
  TabStop := False;
end;

procedure TSCCustomSplitter.CMVisibleChanged(var Message: TMessage);
begin
  inherited;
  CancelSizing;
end;

procedure TSCCustomSplitter.CollapseControl;
var
  OldBounds: TRect;
begin
  if (FControl <> nil) and not FCollapsed then
  begin
    if FInSize then
    begin
      FInSize := False;
      DoDrawSizeLine(True);
    end;

    FDownPart   := scspNone;
    FHotPart    := scspNone;

    FCollapseBounds := Rect(0, 0, -1, -1);
    OldBounds := FControl.BoundsRect;

    Application.ProcessMessages;
    with FControl do
    begin
      Parent.DisableAlign;
      try
        if FAlignSplitter in [scsaLeft, scsaRight] then
          Width := 0
        else
          Height := 0;
      finally
        Parent.EnableAlign;
      end;
    end;
    Application.ProcessMessages;

    FCollapsed := FControl.Height = FControl.Constraints.MinHeight;
    if FAlignSplitter in [scsaLeft, scsaRight] then
      FCollapsed := FControl.Width = FControl.Constraints.MinWidth;

    if FCollapsed then
      FCollapseBounds := OldBounds;

    Invalidate;

    if GetCapture = Handle then
      ReleaseCapture;

    UpdateCursor;
    DoControlMoved;
  end;
end;

procedure TSCCustomSplitter.ConstrainedResize(var MinWidth, MinHeight,
  MaxWidth, MaxHeight: Integer);
var
  Min: Integer;
begin
  inherited ConstrainedResize(MinWidth, MinHeight, MaxWidth, MaxHeight);

  Min := GetMinWidthHeight;
  if Min > 0 then
    if FAlignSplitter in [scsaLeft, scsaRight] then
    begin
      if (MinWidth > 0) or (MaxWidth > 0) then
      begin
        MinWidth := Min;
        MaxWidth := Min;
      end;
    end else
    if (MinHeight > 0) or (MinHeight > 0) then
    begin
      MinHeight := Min;
      MaxHeight := Min;
    end;
end;

procedure TSCCustomSplitter.ControlMoved;
begin
  //
end;

constructor TSCCustomSplitter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption];
  SetBounds(Left, Top, 8, 140);
  DoubleBuffered := True;

  Align := alNone;
  ClickFocus := False;

  FAlignSplitter := scsaLeft;
  FAutoSnap := True;
  FBevel := scsbNone;
  FCanHotZoneDrag := True;
  FDragThreshold := 3;
  FHottrack := True;
  FHottrackColor := clInfoBk;
  FMinSize := 30;
  FResizeStyle := scrsLine;
  FDownPart := scspNone;
  FHotPart := scspNone;
  FControlBounds := Rect(0, 0, 0, 0);
  FCollapseBounds := Rect(0, 0, -1, -1);
  FZeroExpandSize := 0;

  FHotZone := TSCSplitterHotZone.Create(Self);
end;

destructor TSCCustomSplitter.Destroy;
begin
  SetControl(nil);
  FreeAndNil(FHotZone);
  if FBrush <> nil then FreeAndNil(FBrush);
  inherited Destroy;
end;

function TSCCustomSplitter.DoCanResizeControl(var NewSize: Integer): Boolean;
begin
  Result := CanResizeControl(NewSize);
  if Result and (NewSize <= MinSize) and FAutoSnap then
    NewSize := 0;

  if Result and Assigned(FOnCanResizeControl) then
    FOnCanResizeControl(Self, NewSize, Result);
end;

procedure TSCCustomSplitter.DoControlMoved;
begin
  ControlMoved;
  if Assigned(FOnMoved) then FOnMoved(Self);
end;

procedure TSCCustomSplitter.DoDrawHotZone;
var
  R: TRect;
  SR: Integer;
  SplitAlign: TSCSplitterAlign;
begin
  if HandleAllocated and (FHotZone <> nil) then
  begin
    R := GetHotZoneRect;
    if not IsRectEmpty(R) then
    begin
      SR := IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
      try
        if SR <> NULLREGION then
        begin
          SplitAlign := FAlignSplitter;

          if IsCollapsed and (FHotZone.Style <> scshXPTaskbar) then
            case SplitAlign of
              scsaLeft:
                SplitAlign := scsaRight;
              scsaRight:
                SplitAlign := scsaLeft;
              scsaTop:
                SplitAlign := scsaBottom;
              scsaBottom:
                SplitAlign := scsaTop;
            end;

          FHotZone.Paint(Canvas, R, SplitAlign);
        end;
      finally
        SelectClipRgn(Canvas.Handle, 0);
      end;
    end;
  end;
end;

procedure TSCCustomSplitter.DoDrawSizeLine(Force: Boolean);
var
  P: TPoint;
begin
  if (Force or FInSize) and (FResizeStyle in [scrsLine, scrsPattern]) and
    (FControl <> nil) and (Parent <> nil) then
  begin
    FLineVisible := not FLineVisible;

    P := Point(Self.Left, Self.Top);
    if FAlignSplitter in [scsaLeft, scsaRight] then
      P.X := Left + FSplit
    else
      P.Y := Top + FSplit;

    PatBlt(FLineDC, P.X, P.Y, Self.Width, Self.Height, PATINVERT);
  end;
end;

procedure TSCCustomSplitter.ExpandControl;
var
  C: TControl;
  I, P, MoveBy: Integer;
begin
  if (FControl <> nil) and IsCollapsed and
    (FCollapseBounds.Right > -1) and (FCollapseBounds.Bottom > -1) then
  begin
    FDownPart := scspNone;
    FHotPart  := scspNone;

    Application.ProcessMessages;

    if FAlignSplitter = scsaLeft then
    begin
      MoveBy := FCollapseBounds.Right;

      if MoveBy <= 0 then
      begin
        MoveBy := FZeroExpandSize;
        if AutoSnap and (MoveBy = 0) then
          MoveBy := MinSize;
      end;

      FControl.Parent.DisableAlign;
      try
        P := Self.Left + Self.Width;
        for I := 0 to FControl.Parent.ControlCount-1 do
        begin
          C := FControl.Parent.Controls[I];
          if (C <> Self) and (C <> FControl) and
            (C.Align = alLeft) and (C.Left >= P) then
            C.Left := C.Left + MoveBy + 1;
        end;

        FControl.Width := MoveBy;

        if Self.Left <> FControl.Left + FControl.Width then
        begin
          Self.Parent.DisableAlign;
          try
            Self.Left := FControl.Left + FControl.Width;
          finally
            Self.Parent.EnableAlign;
          end;
        end;
      finally
        FControl.Parent.EnableAlign;
      end;
    end else
    if FAlignSplitter = scsaRight then
    begin
      MoveBy := FCollapseBounds.Right - FCollapseBounds.Left;

      if MoveBy <= 0 then
      begin
        MoveBy := FZeroExpandSize;
        if AutoSnap and (MoveBy = 0) then
          MoveBy := MinSize;
      end;

      FControl.Parent.DisableAlign;
      try
        for I := 0 to FControl.Parent.ControlCount-1 do
        begin
          C := FControl.Parent.Controls[I];
          if (C <> Self) and (C <> FControl) and
            (C.Align = alRight) and (C.Left + C.Width <= Self.Left) then
            C.Left := C.Left - MoveBy - 1;
        end;

        FControl.Width := MoveBy;
        FControl.Left := FControl.Left - MoveBy;

        if Self.Left + Self.Width <> FControl.Left then
        begin
          Self.Parent.DisableAlign;
          try
            Self.Left := FControl.Left - Self.Width;
          finally
            Self.Parent.EnableAlign;
          end;
        end;
      finally
        FControl.Parent.EnableAlign;
      end;
    end else
    if FAlignSplitter = scsaTop then
    begin
      MoveBy := FCollapseBounds.Bottom;

      if MoveBy <= 0 then
      begin
        MoveBy := FZeroExpandSize;
        if AutoSnap and (MoveBy = 0) then
          MoveBy := MinSize;
      end;

      P := Self.Top + Self.Height;

      FControl.Parent.DisableAlign;
      try
        for I := 0 to FControl.Parent.ControlCount-1 do
        begin
          C := FControl.Parent.Controls[I];
          if (C <> Self) and (C <> FControl) and (C.Top >= P) then
          begin
            if C.Align = alTop then
              C.Top := C.Top + MoveBy + 1
            else if (C.Align = alClient) and (C.Top = P) then
            begin
              C.Top := C.Top + MoveBy;
              C.Height := C.Height - MoveBy;
            end;
          end;
        end;

        FControl.Height := MoveBy;

        if Self.Top <> FControl.Top + FControl.Height then
        begin
          Self.Parent.DisableAlign;
          try
            Self.Top := FControl.Top + FControl.Height;
          finally
            Self.Parent.EnableAlign;
          end;
        end;
      finally
        FControl.Parent.EnableAlign;
      end;
    end else
    begin
      MoveBy := FCollapseBounds.Bottom - FCollapseBounds.Top;

      if MoveBy <= 0 then
      begin
        MoveBy := FZeroExpandSize;
        if AutoSnap and (MoveBy = 0) then
          MoveBy := MinSize;
      end;

      FControl.Parent.DisableAlign;
      try
        for I := 0 to FControl.Parent.ControlCount-1 do
        begin
          C := FControl.Parent.Controls[I];
          
          if (C <> Self) and (C <> FControl) and (C.Top + C.Height <= Self.Top) then
          begin
            if C.Align = alBottom then
              C.Top := C.Top - MoveBy - 1
            else if (C.Align = alClient) and (C.Top + C.Height = Self.Top) then
              C.Height := C.Height - MoveBy;
          end;    
        end;

        FControl.Height := MoveBy;
        FControl.Top := FControl.Top - MoveBy;

        if Self.Top + Self.Height <> FControl.Top then
        begin
          Self.Parent.DisableAlign;
          try
            Self.Top := FControl.Top - Self.Height;
          finally
            Self.Parent.EnableAlign;
          end;
        end;
      finally
        FControl.Parent.EnableAlign;
      end;
    end;

    Application.ProcessMessages;

    FCollapsed := False;
    FCollapseBounds := Rect(0, 0, -1, -1);

    Invalidate;

    if GetCapture = Handle then
      ReleaseCapture;

    UpdateCursor;
    DoControlMoved;
  end;
end;

function TSCCustomSplitter.GetHotZoneRect: TRect;
var
  CR: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if HandleAllocated and (FHotZone <> nil) and (FHotZone.Style <> scshNone) then
  begin
    CR := GetClientRect;

    Result := CR;
    if FAlignSplitter in [scsaLeft, scsaRight] then
    begin
      Inc(Result.Top, (Result.Bottom - (Result.Top + FHotZone.Size)) div 2);
      Result.Bottom := Result.Top + FHotZone.Size;
    end else
    begin
      Inc(Result.Left, (Result.Right - (Result.Left + FHotZone.Size)) div 2);
      Result.Right := Result.Left + FHotZone.Size;
    end;

    IntersectRect(Result, Result, CR);
  end;
end;

function TSCCustomSplitter.GetMinWidthHeight: Integer;
begin
  Result := 8 + 2*(GetBorderSize + BorderWidth);
end;

function TSCCustomSplitter.GetPartAtPos(X, Y: Integer): TSCSplitterPart;
var
  R: TRect;
  P: TPoint;
begin
  Result := scspNone;

  if HandleAllocated then
  begin
    P := Point(X, Y);
    R := GetClientRect;

    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      Result := scspClient;

      if not (FHotZone.Style in [scshNone, scshOutlook2003]) then
      begin
        R := GetHotZoneRect;
        if not IsRectEmpty(R) and PtInRect(R, P) then
          Result := scspHotZone;
      end;
    end;
  end;
end;

procedure TSCCustomSplitter.HotZoneChanged;
begin
  CancelSizing;
  Invalidate;
end;

procedure TSCCustomSplitter.HotZoneColorChanged;
begin
  Invalidate;
end;

function TSCCustomSplitter.IsCollapsed: Boolean;
begin
  Result := False;
  if FControl <> nil then
  begin
    Result := FCollapsed;
    if not Result then
    begin
      if FAlignSplitter in [scsaLeft, scsaRight] then
        Result := FControl.Width = FControl.Constraints.MinWidth
      else
        Result := FControl.Height = FControl.Constraints.MinHeight;
    end;
  end;
end;

procedure TSCCustomSplitter.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if FInSize and (Key = VK_ESCAPE) then
  begin
    Key := 0;
    
    CancelSizing;
    Invalidate;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TSCCustomSplitter.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FClickPos := Point(X, Y);
  
  inherited MouseDown(Button, Shift, X, Y);

  FDownPart := scspNone;
  FHotPart  := GetPartAtPos(X, Y);

  UpdateCursor;

  if Button = mbLeft then
  begin
    FDownPart := FHotPart;

    if FControl <> nil then
    begin
      if FDownPart = scspClient then
      begin
        AllocateLineDC;
        StartSizing;
      end else
      if FDownPart = scspHotZone then
        Invalidate;

      Exit;
    end;
  end;

  if FDownPart = scspHotZone then
    Invalidate;
end;

procedure TSCCustomSplitter.MouseInControlChanged;
var
  P: TPoint;
  OldHot: TSCSplitterPart;
begin
  OldHot := FHotPart;
  FHotPart := scspNone;

  if MouseInControl and GetCursorPos(P) then
  begin
    P := Self.ScreenToClient(P);
    FHotPart := GetPartAtPos(P.x, P.y);
  end;

  if (FHotPart <> OldHot) and (FHottrack or
    ((FDownPart in [scspNone, scspHotZone]) and not FInSize and
    ((OldHot = scspHotZone) or (FHotPart = scspHotZone)))) then
    Invalidate;

  UpdateCursor;
end;

procedure TSCCustomSplitter.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  OldHot: TSCSplitterPart;
begin
  inherited MouseMove(Shift, X, Y);

  OldHot := FHotPart;
  FHotPart := GetPartAtPos(X, Y);

  UpdateCursor;

  if (FDownPart in [scspNone, scspHotZone]) and (OldHot <> FHotPart) and
    ((OldHot = scspHotZone) or (FHotPart = scspHotZone)) then
    Invalidate;

  if (ssLeft in Shift) and (FControl <> nil) then
  begin
    if not FInSize and (FDownPart = scspHotZone) then
    begin
      if FCanHotZoneDrag and ((Abs(FClickPos.X - X) >= FDragThreshold) or
        (Abs(FClickPos.Y - Y) >= FDragThreshold)) then
      begin
        FDownPart := scspClient;

        Repaint;

        AllocateLineDC;
        StartSizing;
      end;
    end else
    if FInSize and (FDownPart = scspClient) then
      UpdateSizing(X, Y, FClickPos);
  end;
end;

procedure TSCCustomSplitter.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  OldDown, OldHot: TSCSplitterPart;
begin
  P := FClickPos;
  FClickPos := Point(-1, -1);

  OldDown := FDownPart;
  OldHot  := FHotPart;

  inherited MouseUp(Button, Shift, X, Y);

  FDownPart := scspNone;
  FHotPart  := GetPartAtPos(X, Y);

  UpdateCursor(True);

  if FControl <> nil then
  begin
    if OldDown = scspHotZone then
    begin
      if FHotPart = scspHotZone then
      begin
        if not IsCollapsed then
          CollapseControl
        else
          ExpandControl;
          
        UpdateCursor;
      end;
    end else
    if FInSize and (OldDown = scspClient) then
    begin
      UpdateSizing(X, Y, P);
      StopSizing;
    end;
  end;

  if (OldDown = scspHotZone) or (OldHot = scspHotZone) or
    (FHotPart = scspHotZone) or FHottrack then
    Invalidate;
end;

procedure TSCCustomSplitter.Notification(ACOmponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FControl) then
    FControl := nil;
end;

procedure TSCCustomSplitter.Paint;
var
  CR, R: TRect;
  Cl, C1, C2: TColor;
begin
  if not HandleAllocated then
    Exit;

  CR := GetClientRect;
  OffsetRect(CR, -CR.Left, -CR.Top);

  Cl := Self.Color;
  if Cl = clNone then Cl := clBtnFace;

  if FHottrack and (FHottrackColor <> clNone) and
    ((FDownPart <> scspNone) or (FHotPart <> scspNone)) then
    Cl := FHottrackColor;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Cl;

    FillRect(CR);

    if FGradient then
    begin
      C1 := BlendedColor(Cl, 40, 40, 40, True);
      C2 := BlendedColor(Cl, 40, 40, 40, False);

      if FAlignSplitter in [scsaLeft, scsaRight] then
      begin
        R := CR;
        R.Right := R.Left + ((R.Right - R.Left) div 2);

        scDrawGradient(Canvas, R, scgLeftToRight, C1, Cl);

        R := CR;
        R.Left := R.Right - ((R.Right - R.Left) div 2);

        scDrawGradient(Canvas, R, scgLeftToRight, Cl, C2);
      end else
      begin
        R := CR;
        R.Bottom := R.Top + ((R.Bottom - R.Top) div 2);

        scDrawGradient(Canvas, R, scgTopToBottom, C1, Cl);

        R := CR;
        R.Top := R.Bottom - ((R.Bottom - R.Top) div 2);

        scDrawGradient(Canvas, R, scgTopToBottom, Cl, C2);
      end;
    end;
  end;

  if FBevel <> scsbNone then
  begin
    R := Rect(0, 0, 0, 0);
    if (FHotZone <> nil) and (FHotZone.Style <> scshNone) then
    begin
      R := GetHotZoneRect;
      if FHotZone.Style = scshXPTaskbar then
        InflateRect(R, 2, 2);
    end;

    if FAlignSplitter in [scsaLeft, scsaRight] then
      Dec(CR.Right)
    else Dec(CR.Bottom);

    if FBevel in [scsbLineLowered, scsbLineRaised] then
    begin
      if FAlignSplitter in [scsaLeft, scsaRight] then
      begin
        Inc(CR.Left, (CR.Right - CR.Left - 1) div 2);
        CR.Right := CR.Left + 1;
      end else
      begin
        Inc(CR.Top, (CR.Bottom - CR.Top - 1) div 2);
        CR.Bottom := CR.Top + 1;
      end;
    end;

    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;

      C1 := GetBtnHighlightOf(Cl);
      C2 := GetBtnShadowOf(Cl);

      if FBevel in [scsbLineLowered, scsbFullLowered] then
      begin
        C1 := GetBtnShadowOf(Cl);
        C2 := GetBtnHighlightOf(Cl);
      end;

      if FAlignSplitter in [scsaLeft, scsaRight] then
      begin
        if not IsRectEmpty(R) then
        begin
          Pen.Color := C1;

          MoveTo(CR.Left, CR.Top);
          LineTo(CR.Left, R.Top);

          MoveTo(CR.Left, R.Bottom);
          LineTo(CR.Left, CR.Bottom);

          Pen.Color := C2;

          MoveTo(CR.Right, CR.Top);
          LineTo(CR.Right, R.Top);

          MoveTo(CR.Right, R.Bottom);
          LineTo(CR.Right, CR.Bottom);
        end else
        begin
          Pen.Color := C1;
          MoveTo(CR.Left, CR.Top);
          LineTo(CR.Left, CR.Bottom);

          Pen.Color := C2;
          MoveTo(CR.Right, CR.Top);
          LineTo(CR.Right, CR.Bottom);
        end;  
      end else
      if not IsRectEmpty(R) then
      begin
        Pen.Color := C1;

        MoveTo(CR.Left, CR.Top);
        LineTo(R.Left, CR.Top);

        MoveTo(R.Right, CR.Top);
        LineTo(CR.Right, CR.Top);

        Pen.Color := C2;

        MoveTo(CR.Left, CR.Bottom);
        LineTo(R.Left, CR.Bottom);

        MoveTo(R.Right, CR.Bottom);
        LineTo(CR.Right, CR.Bottom);
      end else
      begin
        Pen.Color := C1;
        MoveTo(CR.Left, CR.Top);
        LineTo(CR.Right, CR.Top);

        Pen.Color := C2;
        MoveTo(CR.Left, CR.Bottom);
        LineTo(CR.Right, CR.Bottom);
      end;
    end;
  end;

  DoDrawHotZone;
end;

procedure TSCCustomSplitter.ReleaseLineDC;
begin
  if FLineDC <> 0 then
  begin
    if FPrevBrush <> 0 then
    begin
      SelectObject(FLineDC, FPrevBrush);
      FPrevBrush := 0;
    end;

    if (Parent <> nil) and Parent.HandleAllocated then
      ReleaseDC(Parent.Handle, FLineDC);

    FLineDC := 0;
  end;

  if FBrush <> nil then
  begin
    FBrush.Free;
    FBrush := nil;
  end;
end;

procedure TSCCustomSplitter.RequestAlign;
var
  Al: TAlign;
begin
  inherited RequestAlign;

  Al := SplitterAlignToAlign;
  if not (FInternalAlign or (Align = Al)) then
  begin
    FInternalAlign := True;
    try
      Align := Al;
    finally
      FInternalAlign := False;
    end;
  end;
end;

procedure TSCCustomSplitter.SetAlignSplitter(Value: TSCSplitterAlign);
begin
  if FAlignSplitter <> Value then
  begin
    FAlignSplitter := Value;

    FInternalAlign := True;
    try
      FOldSize := 0;
      Align := SplitterAlignToAlign;
    finally
      FInternalAlign := False;

      if FControl <> nil then
      begin
        FOldSize := FControl.Height;
        if AlignSplitter in [scsaLeft, scsaRight] then
          FOldSize := FControl.Width;
      end;
    end;
  end;
end;

procedure TSCCustomSplitter.SetBevel(Value: TSCSplitterBevel);
begin
  if FBevel <> Value then
  begin
    FBevel := Value;
    if not FInSize then
      Invalidate;
  end;
end;

procedure TSCCustomSplitter.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
begin
  ArrangeSize(AWidth, AHeight);
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TSCCustomSplitter.SetControl(Value: TControl);
begin
  if (Value <> Self) and ((Value = nil) or
    ((Value.Parent = Self.Parent) and ((Value.Align = Self.Align) or
     IsLoading))) then
  begin
    CancelSizing;

    FCollapsed := False;
    FCollapseBounds := Rect(0, 0, -1, -1);

    {$IFDEF SC_DELPHI5_UP}
    if FControl <> nil then
      FControl.RemoveFreeNotification(Self);
    {$ENDIF}

    FControl := Value;

    if FControl <> nil then
    begin
      FControl.FreeNotification(Self);

      FOldSize := FControl.Height;
      if AlignSplitter in [scsaLeft, scsaRight] then
        FOldSize := FControl.Width;
    end;

    UpdateCursor(True);  
  end;
end;

procedure TSCCustomSplitter.SetDragThreshold(Value: Integer);
begin
  if Value < 1 then Value := 1;
  FDragThreshold := Value;
end;

procedure TSCCustomSplitter.SetGradient(Value: Boolean);
begin
  if FGradient <> Value then
  begin
    FGradient := Value;
    if not FInSize then
      Invalidate;
  end;
end;

procedure TSCCustomSplitter.SetHottrack(Value: Boolean);
begin
  if FHottrack <> Value then
  begin
    FHottrack := Value;
    if FHotPart <> scspNone then
    begin
      CancelSizing;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomSplitter.SetHottrackColor(Value: TColor);
begin
  if FHottrackColor <> Value then
  begin
    FHottrackColor := Value;
    if FHotPart <> scspNone then
    begin
      CancelSizing;
      Invalidate;
    end;
  end;
end;

procedure TSCCustomSplitter.SetHotZone(Value: TSCSplitterHotZone);
begin
  FHotZone.Assign(Value);
end;

procedure TSCCustomSplitter.SetMinSize(Value: Integer);
begin
  if Value < 0 then Value := 0;
  FMinSize := Value;
end;

procedure TSCCustomSplitter.SetResizeStyle(Value: TSCSplitterResizeStyle);
begin
  if FResizeStyle <> Value then
  begin
    CancelSizing;
    FResizeStyle := Value;
  end;
end;

function TSCCustomSplitter.SplitterAlignToAlign: TAlign;
begin
  Result := alLeft;

  case FAlignSplitter of
    scsaLeft:
      Result := alLeft;
    scsaRight:
      Result := alRight;
    scsaTop:
      Result := alTop;
    scsaBottom:
      Result := alBottom;
  end;
end;

procedure TSCCustomSplitter.StartSizing;
var
  I: Integer;
  C: TControl;
begin
  if HandleAllocated and (FResizeStyle <> scrsNone) and (FControl <> nil) then
  begin
    FControlBounds := FControl.BoundsRect;
    FInSize := True;

    FSvShowHint := Self.ShowHint;
    FSvParentShowHint := Self.ParentShowHint;

    Self.ShowHint := False;

    if (FClickPos.X < 0) or (FClickPos.Y < 0) then
    begin
      GetCursorPos(FClickPos);
      FClickPos := Self.ScreenToClient(FClickPos);
    end;

    if AlignSplitter in [scsaLeft, scsaRight] then
    begin
      FMaxSize := FControl.Parent.ClientWidth;

      for I := 0 to FControl.Parent.ControlCount - 1 do
      begin
        C := FControl.Parent.Controls[I];
        if (C <> FControl) and (C.Align in [alLeft, alRight]) then
          Dec(FMaxSize, C.Width);
      end;
    end else
    begin
      FMaxSize := FControl.Parent.ClientHeight;

      for I := 0 to FControl.Parent.ControlCount - 1 do
      begin
        C := FControl.Parent.Controls[I];
        if (C <> FControl) and (C.Align in [alTop, alBottom]) then
          Dec(FMaxSize, C.Height);
      end;
    end;

    CalcSplitSize(FClickPos.X, FClickPos.Y, FClickPos, FNewSize, FSplit);

    UpdateCursor;
    DoDrawSizeLine;
  end;
end;

procedure TSCCustomSplitter.StopSizing;
var
  Cs, NewCs: Integer;
  IsInSize, EventFired: Boolean;
begin
  if HandleAllocated then
  begin
    IsInSize := FInSize;

    Cs := -1;
    if FControl <> nil then
    begin
      Cs := FControl.Height;
      if AlignSplitter in [scsaLeft, scsaRight] then
        Cs := FControl.Width;
    end;

    EventFired := False;

    if IsInSize then
    begin
      FInSize := False;
      if FLineVisible then
        DoDrawSizeLine(True);

      EventFired := UpdateControlPos(True);
    end;

    FLineVisible := False;
    FDownPart    := scspNone;
    FHotPart     := scspNone;
    FMaxSize     := 0;
    FNewSize     := 0;
    FOldSize     := 0;

    if (FControl <> nil) then
    begin
      FOldSize := FControl.Height;
      if AlignSplitter in [scsaLeft, scsaRight] then
        FOldSize := FControl.Width;
    end;

    ReleaseLineDC;

    if IsInSize then
    begin
      Self.ShowHint := FSvShowHint;
      Self.ParentShowHint := FSvParentShowHint;

      Invalidate;
    end;

    if GetCapture = Handle then
      ReleaseCapture;

    Invalidate;
    UpdateCursor;

    if not EventFired and IsInSize and
      (Cs > -1) and (FControl <> nil) then
    begin
      NewCs := FControl.Height;
      if AlignSplitter in [scsaLeft, scsaRight] then
        NewCs := FControl.Width;

      if NewCs <> Cs then DoControlMoved;
    end;
  end;
end;

procedure TSCCustomSplitter.StopTracking;
begin
  CancelSizing;
  inherited StopTracking;
end;

function TSCCustomSplitter.UpdateControlPos(Force: Boolean): Boolean;
var
  C: TControl;
  I, MoveBy: Integer;
begin
  Result := False;

  if (FControl <> nil) and ((FNewSize <> FOldSize) or
    ((FNewSize = 0) and not IsCollapsed)) and
    (Force or (FInSize and (FResizeStyle <> scrsNone))) then
  begin
    Application.ProcessMessages;
    case FAlignSplitter of
      scsaLeft:
      begin
        FControl.Width := FNewSize;

        if Left <> FControl.Left + FControl.Width then
        begin
          Parent.DisableAlign;
          try
            Left := FControl.Left + FControl.Width;
          finally
            Parent.EnableAlign;
          end;
        end;
      end;
      scsaTop:
      begin
        FControl.Height := FNewSize;

        if Top <> FControl.Top + FControl.Height then
        begin
          Parent.DisableAlign;
          try
            Top := FControl.Top + FControl.Height;
          finally
            Parent.EnableAlign;
          end;
        end;
      end;
      scsaRight:
      begin
        FControl.Parent.DisableAlign;
        try
          MoveBy := FNewSize - FControl.Width;
          if MoveBy = 0 then
            Exit;

          for I := 0 to Parent.ControlCount-1 do
          begin
            C := Parent.Controls[I];
            if (C <> Self) and (C <> FControl) and
              (C.Align = alRight) and (C.Left + C.Width <= Self.Left) then
              C.Left := C.Left - MoveBy - 1;
          end;

          FControl.Left  := FControl.Left - MoveBy;
          FControl.Width := FNewSize;

          if Left + Width <> FControl.Left then
          begin
            Parent.DisableAlign;
            try
              Left := FControl.Left - Width;
            finally
              Parent.EnableAlign;
            end;
          end;
        finally
          FControl.Parent.EnableAlign;
        end;
      end;
      scsaBottom:
      begin
        FControl.Parent.DisableAlign;
        try
          MoveBy := FNewSize - FControl.Height;
          if MoveBy = 0 then
            Exit;

          for I := 0 to Parent.ControlCount-1 do
          begin
            C := Parent.Controls[I];
            if (C <> Self) and (C <> FControl) and
              (C.Align = alBottom) and (C.Top + C.Height <= Self.Top) then
              C.Top := C.Top - MoveBy - 1;
          end;

          FControl.Top := FControl.Top - MoveBy;
          FControl.Height := FNewSize;

          if Top + Height <> FControl.Top then
          begin
            Parent.DisableAlign;
            try
              Top := FControl.Top - Height;
            finally
              Parent.EnableAlign;
            end;
          end;
        finally
          FControl.Parent.EnableAlign;
        end;
      end;
    end;
    Application.ProcessMessages;

    Result := True;
    DoControlMoved;

    Update;
    FOldSize := FNewSize;

    FCollapsed := False;
    FCollapseBounds := Rect(0, 0, -1, -1);

    if FAutoSnap then
    begin
      if FAlignSplitter in [scsaLeft, scsaRight] then
      begin
        if FControl.Width <= FMinSize then
          CollapseControl;
      end else
      if FControl.Height <= FMinSize then
        CollapseControl;

      if (FResizeStyle = scrsUpdate) and FCollapsed then
        FCollapseBounds := FControlBounds;
    end;
  end;
end;

procedure TSCCustomSplitter.UpdateCursor(Force: Boolean);
var
  Cr: TCursor;
begin
  if HandleAllocated and not IsDesigning then
  begin
    FUpdatingCursor := True;
    FForceCursor := Force;
    try
      Cr := FDefaultCursor;

      if (FControl <> nil) and ((FDownPart = scspClient) or
        ((FDownPart = scspNone) and (FHotPart <> scspHotZone))) then
      begin
        Cr := crVSplit;
        if FAlignSplitter in [scsaLeft, scsaRight] then
          Cr := crHSplit;
      end;

      Cursor := Cr;
    finally
      FUpdatingCursor := False;
      FForceCursor := False;
    end;
  end;
end;

procedure TSCCustomSplitter.UpdateSizing(X, Y: Integer; ClickPos: TPoint);
var
  DoLine: Boolean;
  NewSize, Split: Integer;
begin
  if FInSize and (FControl <> nil) and (FResizeStyle <> scrsNone) and
    (ClickPos.X > -1) and (ClickPos.Y > -1) then
  begin
    CalcSplitSize(X, Y, ClickPos, NewSize, Split);

    if DoCanResizeControl(NewSize) then
    begin
      DoLine := FResizeStyle in [scrsLine, scrsPattern];
      if DoLine then DoDrawSizeLine;

      FSplit := Split;
      FNewSize := NewSize;

      if DoLine then DoDrawSizeLine
      else UpdateControlPos;
    end;    
  end;
end;

procedure TSCCustomSplitter.WMMove(var Message: TWMMove);
begin
  inherited;
  if not FInSize then
    Invalidate;
end;

procedure TSCCustomSplitter.WMSize(var Message: TWMSize);
begin
  inherited;
  if not FInSize then
    Invalidate;
end;

{ TSCSplitterHotZone }

procedure TSCSplitterHotZone.Assign(Source: TPersistent);
begin
  if Source is TSCSplitterHotZone then
  begin
    with TSCSplitterHotZone(Source) do
    begin
      Self.FArrowColor := FArrowColor;
      Self.FArrowDownColor := FArrowDownColor;
      Self.FArrowHotColor := FArrowHotColor;
      Self.FColor := FColor;
      Self.FDownColor := FDownColor;
      Self.FHotColor := FHotColor;
      Self.FSize := FSize;
      Self.FStyle := FStyle;
    end;

    DoChanged(True);
  end else
    inherited Assign(Source);
end;

constructor TSCSplitterHotZone.Create(AOwner: TSCCustomSplitter);
begin
  inherited Create;
  FOwner := AOWner;

  FArrowColor := clWindowText;
  FArrowDownColor := clNone;
  FArrowHotColor := clNone;
  FColor := clNone;
  FDownColor := clNone;
  FHotColor := clNone;
  FSize := 120;
  FStyle := scshSimple;
end;

procedure TSCSplitterHotZone.DoChanged(Force: Boolean);
begin
  if (FOwner <> nil) and (Force or (FStyle <> scshNone)) then
    FOwner.HotZoneChanged;
end;

procedure TSCSplitterHotZone.DoColorChanged;
begin
  if (FOwner <> nil) and (FStyle <> scshNone) then
    FOwner.HotZoneColorChanged;
end;

procedure TSCSplitterHotZone.DoDrawArrow(Canvas: TCanvas; X, Y: Integer;
  Cl: TColor; Align: TSCSplitterAlign);
var
  I, Leg: Integer;
begin
  if Canvas = nil then
    Exit;

  with Canvas.Pen do
  begin
    Style := psSolid;
    Mode  := pmCopy;
    Width := 1;
    Color := Cl;
  end;

  Leg := 4;
  case Align of
    scsaLeft:
    begin
      for I := 0 to 1 do
      begin
        Canvas.MoveTo(X, Y);
        Canvas.LineTo(X + Leg, Y + Leg);

        Canvas.MoveTo(X, Y);
        Canvas.LineTo(X + Leg, Y - Leg);

        Inc(X);
        Dec(Leg);
      end;
    end;
    scsaRight:
    begin
      for I := 0 to 1 do
      begin
        Canvas.MoveTo(X, Y);
        Canvas.LineTo(X - Leg, Y + Leg);

        Canvas.MoveTo(X, Y);
        Canvas.LineTo(X - Leg, Y - Leg);

        Dec(X);
        Dec(Leg);
      end;
    end;
    scsaTop:
    begin
      for I := 0 to 1 do
      begin
        Canvas.MoveTo(X, Y);
        Canvas.LineTo(X - Leg, Y + Leg);

        Canvas.MoveTo(X, Y);
        Canvas.LineTo(X + Leg, Y + Leg);

        Inc(Y);
        Dec(Leg);
      end;
    end;
    scsaBottom:
    begin
      for I := 0 to 1 do
      begin
        Canvas.MoveTo(X, Y);
        Canvas.LineTo(X - Leg, Y - Leg);

        Canvas.MoveTo(X, Y);
        Canvas.LineTo(X + Leg, Y - Leg);

        Dec(Y);
        Dec(Leg);
      end;
    end;
  end;
end;

procedure TSCSplitterHotZone.DoDrawMacromedia(Canvas: TCanvas;
  R: TRect; Cl, ACl: TColor; Align: TSCSplitterAlign);
var
  CR: TRect;
  X, Y: Integer;
begin
  if (Canvas = nil) or IsRectEmpty(R) then
    Exit;

  if IsDown or IsHot then
  begin
    ACl := BlendedColor(Cl, 160, 160, 160, False);
    Cl := BlendedColor(Cl, 32, 32, 32, True);
  end else
  begin
    ACl := BlendedColor(Cl, 160, 160, 160, True);
    Cl := BlendedColor(Cl, 40, 40, 40, False);
  end;

  if Align in [scsaLeft, scsaRight] then
  begin
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      FillRect(R);
    end;

    if Align = scsaRight then
    begin
      CR := R;
      CR.Left := CR.Left + Round((CR.Right - CR.Left) / 3);

      scDrawGradient(Canvas, CR, scgLeftToRight, Cl,
        BlendedColor(Cl, 40, 40, 40, False));
    end else
    begin
      CR := R;
      CR.Right := CR.Left + Round((CR.Right - CR.Left) / 3);

      scDrawGradient(Canvas, CR, scgLeftToRight,
        BlendedColor(Cl, 40, 40, 40, False), Cl);
    end;

    X := R.Left + 2;
    if Align = scsaRight then
      X := R.Right - 3;

    Y := R.Top + ((R.Bottom - R.Top) div 2);
    DoDrawArrow(Canvas, X, Y, ACl, Align);

    CR := R;
    InflateRect(CR, 4, 0);

    scFrame3D(Canvas, CR, BlendedColor(Cl, 16, 16, 16, True),
      GetBtnShadowOf(Cl), 1, 0);
  end else
  begin
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      FillRect(R);
    end;

    if Align = scsaBottom then
    begin
      CR := R;
      CR.Top := CR.Top + ((CR.Bottom - CR.Top) div 2);

      scDrawGradient(Canvas, CR, scgTopToBottom, Cl,
        BlendedColor(Cl, 40, 40, 40, False));
    end else
    begin
      CR := R;
      CR.Bottom := CR.Top + ((CR.Bottom - CR.Top) div 2);

      scDrawGradient(Canvas, CR, scgTopToBottom,
        BlendedColor(Cl, 40, 40, 40, False), Cl);
    end;

    Y := R.Top + 2;
    if Align = scsaBottom then
      Y := R.Bottom - 3;

    X := R.Left + ((R.Right - R.Left) div 2);
    DoDrawArrow(Canvas, X, Y, ACl, Align);

    CR := R;
    InflateRect(CR, 0, 4);

    scFrame3D(Canvas, CR, BlendedColor(Cl, 16, 16, 16, True),
      GetBtnShadowOf(Cl), 1, 0);
  end;
end;

procedure TSCSplitterHotZone.DoDrawMediaPlayer(Canvas: TCanvas; R: TRect;
  Cl, ACl: TColor; Align: TSCSplitterAlign);

  procedure DrawDots(X, Y, Cnt: Integer; Horizontal: Boolean; Cl: TColor);
  var
    Pr: TRect;
    I: Integer;
  begin
    Pr := Rect(X, Y, X + 2, Y + 2);

    with Canvas.Brush do
    begin
      Style := bsSolid;
      Color := Cl;
    end;

    for I := 0 to Cnt-1 do
    begin
      Canvas.FillRect(Pr);
      if Horizontal then
        OffsetRect(Pr, 5, 0)
      else
        OffsetRect(Pr, 0, 5);
    end;
  end;

var
  CR: TRect;
  DownAndHot: Boolean;
  Mid, W, X, Y, Cnt: Integer;
begin
  if (Canvas = nil) or IsRectEmpty(R) then
    Exit;

  DownAndHot := IsDown and IsHot;

  if Align in [scsaLeft, scsaRight] then
  begin
    if R.Bottom - R.Top < 40 then
    begin
      Inc(R.Top, (40 - (R.Bottom - R.Top)) div 2);
      R.Bottom := R.Top + 40;
    end;

    Mid := R.Left + ((R.Right - R.Left) div 2);

    R.Left := Mid - 4;
    R.Right := R.Left + 8;

    CR := R;

    X := Mid - 1;
    Y := R.Top + 6;

    W := (R.Bottom - R.Top - 40) div 2;
    Cnt := W div 5;

    if Cnt > 0 then
    begin
      if DownAndHot then
        Dec(X);

      DrawDots(X, Y, Cnt, False, GetBtnHighlightOf(Cl));
      DrawDots(X + 1, Y + 1, Cnt, False, GetBtnShadowOf(Cl));
    end;

    W := R.Bottom - R.Top - 40 - W;
    Cnt := W div 5;

    X := Mid - 1;
    Y := R.Bottom - W - 6;

    if Cnt > 0 then
    begin
      if DownAndHot then
        Dec(X);

      DrawDots(X, Y, Cnt, False, GetBtnHighlightOf(Cl));
      DrawDots(X + 1, Y + 1, Cnt, False, GetBtnShadowOf(Cl));
    end;

    Inc(R.Top, (R.Bottom - R.Top - 20) div 2);
    R.Bottom := R.Top + 20;

    Mid := R.Top + 10;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      FillRect(R);
    end;

    X := R.Left + 2;
    if Align = scsaRight then
      X := R.Right - 3;

    Y := Mid;
    DoDrawArrow(Canvas, X, Y, ACl, Align);
  end else
  begin
    if R.Right - R.Left < 40 then
    begin
      Inc(R.Left, (40 - (R.Right - R.Left)) div 2);
      R.Right := R.Left + 40;
    end;

    Mid := R.Top + ((R.Bottom - R.Top) div 2);

    R.Top := Mid - 4;
    R.Bottom := R.Top + 8;

    CR := R;

    Y := Mid - 1;
    X := R.Left + 6;

    W := (R.Right - R.Left - 40) div 2;
    Cnt := W div 5;

    if Cnt > 0 then
    begin
      if DownAndHot then
        Dec(Y);

      DrawDots(X, Y, Cnt, True, GetBtnHighlightOf(Cl));
      DrawDots(X + 1, Y + 1, Cnt, True, GetBtnShadowOf(Cl));
    end;

    W := R.Right - R.Left - 40 - W;
    Cnt := W div 5;

    Y := Mid - 1;
    X := R.Right - W - 6;

    if Cnt > 0 then
    begin
      if DownAndHot then
        Dec(Y);

      DrawDots(X, Y, Cnt, True, GetBtnHighlightOf(Cl));
      DrawDots(X + 1, Y + 1, Cnt, True, GetBtnShadowOf(Cl));
    end;

    Inc(R.Left, (R.Right - R.Left - 20) div 2);
    R.Right := R.Left + 20;

    Mid := R.Left + 10;

    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Cl;

      FillRect(R);
    end;

    Y := R.Top + 2;
    if Align = scsaBottom then
      Y := R.Bottom - 3;

    X := Mid;
    DoDrawArrow(Canvas, X, Y, ACl, Align);
  end;

  R := CR;
  scFrame3D(Canvas, R, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
  if DownAndHot then
    scFrame3D(Canvas, R, Cl, GetBtnHighlightOf(Cl), 1, 0)
  else
    scFrame3D(Canvas, R, GetBtnHighlightOf(Cl), Cl, 1, 0);

  R := CR;

  if Align in [scsaLeft, scsaRight] then
  begin
    Inc(R.Top, (R.Bottom - R.Top - 20) div 2);
    R.Bottom := R.Top + 20;
  end else
  begin
    Inc(R.Left, (R.Right - R.Left - 20) div 2);
    R.Right := R.Left + 20;
  end;

  if DownAndHot then
    scFrame3D(Canvas, R, GetBtnHighlightOf(Cl), GetBtnShadowOf(Cl), 1, 0)
  else  
    scFrame3D(Canvas, R, GetBtnShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0);
  scFrame3D(Canvas, R, Cl, Cl, 1, 0);
end;

procedure TSCSplitterHotZone.DoDrawMediaPlayer9(Canvas: TCanvas; R: TRect;
  Cl, ACl: TColor; Align: TSCSplitterAlign);
var
  CR: TRect;
  X, Y: Integer;
  DownOrHot: Boolean;
begin
  if (Canvas = nil) or IsRectEmpty(R) then
    Exit;

  DownOrHot := not IsClientDown and (IsHot or IsDown);

  if Cl = clNone then
  begin
    Cl := clMediaPlayer9;
    if DownOrHot then
      Cl := clMediaPlayer9Hot;
  end;

  if ACl = clNone then
  begin
    ACl := clWindowText;
    if DownOrHot then
      ACl := clMediaPlayer9HotArrow;
  end;

  CR := R;
  InflateRect(CR, -1, -1);

  if not IsRectEmpty(CR) then
    with Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := GetBtnHighlightOf(Cl);

      FillRect(CR);

      if Align in [scsaLeft, scsaRight] then
      begin
        if IsDown and IsHot then
        begin
          Dec(CR.Right, (CR.Right - CR.Left) div 2);
          scDrawGradient(Canvas, CR, scgLeftToRight, BlendedColor(Cl, 64, 64, 64, False), Cl);
        end else
        begin
          Inc(CR.Left, (CR.Right - CR.Left) div 2);
          scDrawGradient(Canvas, CR, scgLeftToRight, Cl, BlendedColor(Cl, 64, 64, 64, False));
        end;

        X := R.Left + 2;
        if Align = scsaRight then
          X := R.Right - 3;

        Y := R.Top + ((R.Bottom - R.Top) div 2);
        DoDrawArrow(Canvas, X, Y, ACl, Align);
      end else
      begin
        if IsDown and IsHot then
        begin
          Dec(CR.Bottom, (CR.Bottom - CR.Top) div 2);
          scDrawGradient(Canvas, CR, scgTopToBottom, BlendedColor(Cl, 64, 64, 64, False), Cl);
        end else
        begin
          Inc(CR.Top, (CR.Bottom - CR.Top) div 2);
          scDrawGradient(Canvas, CR, scgTopToBottom, Cl, BlendedColor(Cl, 64, 64, 64, False));
        end;

        Y := R.Top + 2;
        if Align = scsaBottom then
          Y := R.Bottom - 3;

        X := R.Left + ((R.Right - R.Left) div 2);
        DoDrawArrow(Canvas, X, Y, ACl, Align);
      end;

      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Width := 1;
      Pen.Color := clBtnShadow;

      CR := R;

      Dec(CR.Right);
      Dec(CR.Bottom);

      MoveTo(CR.Left + 1, CR.Top);
      LineTo(CR.Right, CR.Top);

      MoveTo(CR.Left + 1, CR.Bottom);
      LineTo(CR.Right, CR.Bottom);

      MoveTo(CR.Right, CR.Top + 1);
      LineTo(CR.Right, CR.Bottom);

      MoveTo(CR.Left, CR.Top + 1);
      LineTo(CR.Left, CR.Bottom);

      InflateRect(CR, -1, -1);

      MoveTo(CR.Left, CR.Top);
      LineTo(CR.Left, CR.Top + 1);

      MoveTo(CR.Right, CR.Top);
      LineTo(CR.Right, CR.Top + 1);

      MoveTo(CR.Left, CR.Bottom);
      LineTo(CR.Left, CR.Bottom - 1);

      MoveTo(CR.Right, CR.Bottom);
      LineTo(CR.Right, CR.Bottom - 1);
    end;
end;

procedure TSCSplitterHotZone.DoDrawMetal(Canvas: TCanvas; R: TRect; Cl,
  ACl: TColor; Align: TSCSplitterAlign);

  procedure DrawDots(X, Y, Cnt: Integer; Horizontal: Boolean; Cl: TColor);
  var
    I: Integer;
  begin
    with Canvas.Pen do
    begin
      Style := psSolid;
      Mode  := pmCopy;
      Width := 1;
      Color := Cl;
    end;

    for I := 0 to Cnt-1 do
    begin
      Canvas.MoveTo(X, Y);
      if Horizontal then
      begin
        Canvas.LineTo(X + 1, Y);
        Inc(X, 3);
      end else
      begin
        Canvas.LineTo(X, Y + 1);
        Inc(Y, 3);
      end;
    end;
  end;

var
  CR: TRect;
  Mid, X, Y, Cnt: Integer;
begin
  if (Canvas = nil) or IsRectEmpty(R) then
    Exit;

  if Align in [scsaLeft, scsaRight] then
  begin
    if R.Bottom - R.Top < 30 then
    begin
      Inc(R.Top, (30 - (R.Bottom - R.Top)) div 2);
      R.Bottom := R.Top + 30;
    end;

    Mid := R.Left + ((R.Right - R.Left) div 2);

    R.Left := Mid - 4;
    R.Right := R.Left + 8;

    CR := R;

    X := Mid - 1;
    Y := R.Top + 15;

    Cnt := (R.Bottom - R.Top - 30) div 3;

    if Cnt > 0 then
    begin
      Inc(Y, ((R.Bottom - R.Top - 30) mod 3) div 2);

      DrawDots(X, Y, Cnt, False, GetBtnHighlightOf(Cl));
      DrawDots(X + 1, Y + 1, Cnt, False, GetBtnShadowOf(Cl));
    end;

    X := R.Left + 2;
    if Align = scsaRight then
      X := R.Right - 3;

    Y := R.Top + 10;
    DoDrawArrow(Canvas, X, Y, ACl, Align);

    Y := R.Bottom - 10;
    DoDrawArrow(Canvas, X, Y, ACl, Align);
  end else
  begin
    if R.Right - R.Left < 30 then
    begin
      Inc(R.Left, (30 - (R.Right - R.Left)) div 2);
      R.Right := R.Left + 30;
    end;

    Mid := R.Top + ((R.Bottom - R.Top) div 2);

    R.Top := Mid - 4;
    R.Bottom := R.Top + 8;

    CR := R;

    Y := Mid - 1;
    X := R.Left + 15;

    Cnt := (R.Right - R.Left - 30) div 3;

    if Cnt > 0 then
    begin
      Inc(X, ((R.Right - R.Left - 30) mod 3) div 2);

      DrawDots(X, Y, Cnt, True, GetBtnHighlightOf(Cl));
      DrawDots(X + 1, Y + 1, Cnt, True, GetBtnShadowOf(Cl));
    end;

    Y := R.Top + 2;
    if Align = scsaBottom then
      Y := R.Bottom - 3;

    X := R.Left + 10;
    DoDrawArrow(Canvas, X, Y, ACl, Align);

    X := R.Right - 10;
    DoDrawArrow(Canvas, X, Y, ACl, Align);
  end;
end;

procedure TSCSplitterHotZone.DoDrawOfficeXP(Canvas: TCanvas; R: TRect;
  Cl, ACl: TColor; Align: TSCSplitterAlign);
var
  CR: TRect;
  Mid, X, Y: Integer;
begin
  if (Canvas = nil) or IsRectEmpty(R) then
    Exit;

  if Align in [scsaLeft, scsaRight] then
  begin
    if R.Bottom - R.Top < 40 then
    begin
      Inc(R.Top, (40 - (R.Bottom - R.Top)) div 2);
      R.Bottom := R.Top + 40;
    end;

    Mid := R.Left + ((R.Right - R.Left) div 2);

    R.Left := Mid - 4;
    R.Right := R.Left + 8;

    X := R.Left + 2;
    Y := R.Top + ((R.Bottom - R.Top) div 2);
    if Align = scsaRight then
      X := R.Right - 3;
  end else
  begin
    if R.Right - R.Left < 40 then
    begin
      Inc(R.Left, (40 - (R.Right - R.Left)) div 2);
      R.Right := R.Left + 40;
    end;

    Mid := R.Top + ((R.Bottom - R.Top) div 2);

    R.Top := Mid - 4;
    R.Bottom := R.Top + 8;

    Y := R.Top + 2;
    X := R.Left + ((R.Right - R.Left) div 2);
    if Align = scsaBottom then
      Y := R.Bottom - 3;
  end;

  ACl := clBtnText;
  Cl := GetOfficeXPBtnColor;

  if IsDown and IsHot then
  begin
    ACl := clHighlightText;
    Cl := GetOfficeXPDownedSelColor;
  end else
  if IsDown or (IsHot and not IsClientDown) then
    Cl := GetOfficeXPSelColor;

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Cl;

    FillRect(R);
  end;

  DoDrawArrow(Canvas, X, Y, ACl, Align);

  CR := R;

  scFrame3D(Canvas, R, Cl, Cl, 1, 0);
  scFrame3D(Canvas, R, Cl, Cl, 1, 0);

  if IsDown or (IsHot and not IsClientDown) then
  begin
    R := CR;
    scFrame3D(Canvas, R, clHighlight, clHighlight, 1, 0);
  end;
end;

procedure TSCSplitterHotZone.DoDrawOutlook2003(Canvas: TCanvas; R: TRect;
  Cl, ACl: TColor; Align: TSCSplitterAlign);

  procedure DrawDots(X, Y, Cnt: Integer; Horizontal: Boolean; Cl: TColor);
  var
    Pr: TRect;
    I: Integer;
  begin
    Pr := Rect(X, Y, X + 2, Y + 2);

    with Canvas.Brush do
    begin
      Style := bsSolid;
      Color := Cl;
    end;

    for I := 0 to Cnt-1 do
    begin
      Canvas.FillRect(Pr);
      if Horizontal then
        OffsetRect(Pr, 6, 0)
      else
        OffsetRect(Pr, 0, 6);
    end;
  end;

var
  CR: TRect;
  Cnt, X, Y: Integer;
begin
  if (Canvas = nil) or IsRectEmpty(R) then
    Exit;

  CR := R;
  if Align in [scsaLeft, scsaRight] then
  begin
    Cnt := (R.Bottom - R.Top) div 6;

    Y := R.Top + (((R.Bottom - R.Top) mod 6) div 2);
    X := R.Left + ((R.Right - R.Left - 6) div 2) + 1;

    DrawDots(X + 1, Y + 1, Cnt, False, GetBtnHighlightOf(Cl));
    DrawDots(X, Y, Cnt, False, GetBtnShadowOf(Cl));
  end else
  begin
    Cnt := (R.Right - R.Left - 6) div 6;

    X := R.Left + (((R.Right - R.Left) mod 6) div 2);
    Y := R.Top + ((R.Bottom - R.Top - 6) div 2) + 1;

    DrawDots(X + 1, Y + 1, Cnt, True, GetBtnHighlightOf(Cl));
    DrawDots(X, Y, Cnt, True, GetBtnShadowOf(Cl));
  end;
end;

procedure TSCSplitterHotZone.DoDrawSimple(Canvas: TCanvas; R: TRect;
  Cl, ACl: TColor; Align: TSCSplitterAlign);

  procedure DrawDots(X, Y, Cnt: Integer; Horizontal: Boolean; Cl: TColor);
  var
    I: Integer;
  begin
    with Canvas.Pen do
    begin
      Style := psSolid;
      Mode  := pmCopy;
      Width := 1;
      Color := Cl;
    end;

    for I := 0 to Cnt-1 do
    begin
      Canvas.MoveTo(X, Y);
      if Horizontal then
      begin
        Canvas.LineTo(X + 1, Y);
        Inc(X, 3);
      end else
      begin
        Canvas.LineTo(X, Y + 1);
        Inc(Y, 3);
      end;
    end;
  end;

var
  CR: TRect;
  DownAndHot: Boolean;
  Mid, X, Y, Cnt: Integer;
begin
  if (Canvas = nil) or IsRectEmpty(R) then
    Exit;

  DownAndHot := IsDown and IsHot;

  if Align in [scsaLeft, scsaRight] then
  begin
    if R.Bottom - R.Top < 30 then
    begin
      Inc(R.Top, (30 - (R.Bottom - R.Top)) div 2);
      R.Bottom := R.Top + 30;
    end;

    Mid := R.Left + ((R.Right - R.Left) div 2);

    R.Left := Mid - 4;
    R.Right := R.Left + 8;

    CR := R;

    X := Mid - 1;
    Y := R.Top + 15;

    Cnt := (R.Bottom - R.Top - 30) div 3;

    if Cnt > 0 then
    begin
      Inc(Y, ((R.Bottom - R.Top - 30) mod 3) div 2);
      if DownAndHot then
        Dec(X);

      DrawDots(X, Y, Cnt, False, GetBtnHighlightOf(Cl));
      DrawDots(X + 1, Y + 1, Cnt, False, GetBtnShadowOf(Cl));
    end;

    X := R.Left + 2;
    if Align = scsaRight then
      X := R.Right - 3;

    Y := R.Top + 10;
    DoDrawArrow(Canvas, X, Y, ACl, Align);

    Y := R.Bottom - 10;
    DoDrawArrow(Canvas, X, Y, ACl, Align);
  end else
  begin
    if R.Right - R.Left < 30 then
    begin
      Inc(R.Left, (30 - (R.Right - R.Left)) div 2);
      R.Right := R.Left + 30;
    end;

    Mid := R.Top + ((R.Bottom - R.Top) div 2);

    R.Top := Mid - 4;
    R.Bottom := R.Top + 8;

    CR := R;

    Y := Mid - 1;
    X := R.Left + 15;

    Cnt := (R.Right - R.Left - 30) div 3;

    if Cnt > 0 then
    begin
      Inc(X, ((R.Right - R.Left - 30) mod 3) div 2);
      if DownAndHot then
        Dec(Y);

      DrawDots(X, Y, Cnt, True, GetBtnHighlightOf(Cl));
      DrawDots(X + 1, Y + 1, Cnt, True, GetBtnShadowOf(Cl));
    end;

    Y := R.Top + 2;
    if Align = scsaBottom then
      Y := R.Bottom - 3;

    X := R.Left + 10;
    DoDrawArrow(Canvas, X, Y, ACl, Align);

    X := R.Right - 10;
    DoDrawArrow(Canvas, X, Y, ACl, Align);
  end;

  scFrame3D(Canvas, R, GetBtnShadowOf(Cl), GetBtnShadowOf(Cl), 1, 0);
  if DownAndHot then
    scFrame3D(Canvas, R, Cl, GetBtnHighlightOf(Cl), 1, 0)
  else
    scFrame3D(Canvas, R, GetBtnHighlightOf(Cl), Cl, 1, 0);
end;

procedure TSCSplitterHotZone.DoDrawXPTaskbar(Canvas: TCanvas; R: TRect;
  Cl, ACl: TColor; Align: TSCSplitterAlign);

  procedure DrawDots(X, Y, Cnt: Integer; Horizontal: Boolean; Cl: TColor);
  var
    Pr: TRect;
    I: Integer;
  begin
    Pr := Rect(X, Y, X + 2, Y + 2);

    with Canvas.Brush do
    begin
      Style := bsSolid;
      Color := Cl;
    end;

    for I := 0 to Cnt-1 do
    begin
      Canvas.FillRect(Pr);
      if Horizontal then
        OffsetRect(Pr, 6, 0)
      else
        OffsetRect(Pr, 0, 6);
    end;
  end;

var
  CR: TRect;
  Cnt, X, Y: Integer;
begin
  if (Canvas = nil) or IsRectEmpty(R) then
    Exit;

  CR := R;
  if Align in [scsaLeft, scsaRight] then
  begin
    Cnt := (R.Bottom - R.Top) div 6;

    Y := R.Top + (((R.Bottom - R.Top) mod 6) div 2);

    if Align = scsaLeft then
      X := R.Left + ((R.Right - R.Left - 6) div 2)
    else
      X := R.Right - 3 - ((R.Right - R.Left - 6) div 2);

    DrawDots(X + 1, Y + 1, Cnt, False, GetBtnHighlightOf(Cl));
    DrawDots(X, Y, Cnt, False, GetBtnShadowOf(Cl));

    Dec(Cnt);
    if Cnt > 0 then
    begin
      Inc(Y, 3);

      if Align = scsaLeft then
        Inc(X, 3)
      else
        Dec(X, 3);

      DrawDots(X + 1, Y + 1, Cnt, False, GetBtnHighlightOf(Cl));
      DrawDots(X, Y, Cnt, False, GetBtnShadowOf(Cl));
    end;
  end else
  begin
    Cnt := (R.Right - R.Left - 6) div 6;

    X := R.Left + (((R.Right - R.Left) mod 6) div 2);

    if Align = scsaTop then
      Y := R.Top + ((R.Bottom - R.Top - 6) div 2)
    else
      Y := R.Bottom - 3 - ((R.Bottom - R.Top - 6) div 2);

    DrawDots(X + 1, Y + 1, Cnt, True, GetBtnHighlightOf(Cl));
    DrawDots(X, Y, Cnt, True, GetBtnShadowOf(Cl));

    Dec(Cnt);
    if Cnt > 0 then
    begin
      Inc(X, 3);

      if Align = scsaTop then
        Inc(Y, 3)
      else
        Dec(Y, 3);

      DrawDots(X + 1, Y + 1, Cnt, True, GetBtnHighlightOf(Cl));
      DrawDots(X, Y, Cnt, True, GetBtnShadowOf(Cl));
    end;
  end;
end;

function TSCSplitterHotZone.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCSplitterHotZone.IsClientDown: Boolean;
begin
  Result := (FOwner <> nil) and (FOwner.FDownPart = scspClient);
end;

function TSCSplitterHotZone.IsDown: Boolean;
begin
  Result := (FOwner <> nil) and (FOwner.FDownPart = scspHotZone);
end;

function TSCSplitterHotZone.IsHot: Boolean;
begin
  Result := (FOwner <> nil) and (FOwner.FHotPart = scspHotZone);
end;

procedure TSCSplitterHotZone.Paint(Canvas: TCanvas; R: TRect; Align: TSCSplitterAlign);
var
  Cl, ACl: TColor;
  IsMedia9: Boolean;
begin
  if (Canvas <> nil) and not IsRectEmpty(R) and (FStyle <> scshNone) then
  begin
    IsMedia9 := FStyle = scshMediaPlayer9;

    Cl := FColor;
    if IsDown then
    begin
      Cl := FDownColor;
      if (Cl = clNone) and not IsMedia9 then
        Cl := FColor;
    end else
    if IsHot and not IsClientDown then
    begin
      Cl := FHotColor;
      if (Cl = clNone) and not IsMedia9 then
        Cl := FColor;
    end;

    if (Cl <> clNone) and not IsMedia9 then
      with Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := Cl;

        FillRect(R);
      end;

    if (Cl = clNone) and not IsMedia9 then
    begin
      Cl := clBtnFace;
      if FOwner <> nil then
      begin
        Cl := FOwner.Color;
        if Cl = clNone then
          Cl := clBtnFace;
      end;
    end;

    ACl := FArrowColor;
    if IsDown then
    begin
      ACl := FArrowDownColor;
      if (ACl = clNone) and not IsMedia9 then
        ACl := FArrowColor;
    end else
    if IsHot and not IsClientDown then
    begin
      ACl := FArrowHotColor;
      if (ACl = clNone) and not IsMedia9 then
        ACl := FArrowColor;
    end;

    if (ACl = clNone) and not IsMedia9 then
      ACl := clWindowText;

    case FStyle of
      scshMediaPlayer:
        DoDrawMediaPlayer(Canvas, R, Cl, ACl, Align);
      scshMediaPlayer9:
        DoDrawMediaPlayer9(Canvas, R, Cl, ACl, Align);
      scshOfficeXP:
        DoDrawOfficeXP(Canvas, R, Cl, ACl, Align);
      scshSimple:
        DoDrawSimple(Canvas, R, Cl, ACl, Align);
      scshMetal:
        DoDrawMetal(Canvas, R, Cl, ACl, Align);
      scshXPTaskbar:
        DoDrawXPTaskbar(Canvas, R, Cl, ACl, Align);
      scshOutlook2003:
        DoDrawOutlook2003(Canvas, R, Cl, ACl, Align);
      scshMacromedia:
        DoDrawMacromedia(Canvas, R, Cl, ACl, Align);
    end;
  end;
end;

procedure TSCSplitterHotZone.SetArrowColor(Value: TColor);
begin
  if FArrowColor <> Value then
  begin
    FArrowColor := Value;
    DoColorChanged;
  end;
end;

procedure TSCSplitterHotZone.SetArrowDownColor(Value: TColor);
begin
  if FArrowDownColor <> Value then
  begin
    FArrowDownColor := Value;
    DoColorChanged;
  end;
end;

procedure TSCSplitterHotZone.SetArrowHotColor(Value: TColor);
begin
  if FArrowHotColor <> Value then
  begin
    FArrowHotColor := Value;
    DoColorChanged;
  end;
end;

procedure TSCSplitterHotZone.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    DoColorChanged;
  end;
end;

procedure TSCSplitterHotZone.SetDownColor(Value: TColor);
begin
  if FDownColor <> Value then
  begin
    FDownColor := Value;
    DoColorChanged;
  end;
end;

procedure TSCSplitterHotZone.SetHotColor(Value: TColor);
begin
  if FHotColor <> Value then
  begin
    FHotColor := Value;
    DoColorChanged;
  end;
end;

procedure TSCSplitterHotZone.SetSize(Value: Integer);
begin
  if Value < 40 then
    Value := 40;

  if FSize <> Value then
  begin
    FSize := Value;
    DoChanged;
  end;
end;

procedure TSCSplitterHotZone.SetStyle(Value: TSCSplitterHotZoneStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    DoChanged(True);
  end;
end;

{$I SCVerRec.inc}

end.
