{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCControl;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, StdActns, ActnList, Menus, SCCommon, SCConsts;

type
  TSCPictureList = class;
  TSCPictureNotifier = class;
  
  TSCPictureListItem = class(TCollectionItem)
  private
    FPicture: TPicture;
    FCaption: String;
    FDescription: TStrings;
    FName: String;
    FData: TObject;
    FUpdateCount: Integer;
    procedure SetPicture(Value: TPicture);
    procedure SetCaption(const Value: String);
    procedure SetDescription(Value: TStrings);
    procedure SetName(const Value: String);

    procedure DescriptionChanged(Sender: TObject);
    procedure PictureChanged(Sender: TObject);
  protected
    function  GetDisplayName: string; override;
    procedure DoChanged;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Data: TObject read FData write FData;
  published
    procedure BeginUpdate;
    procedure EndUpdate;
    function  InUpdate: Boolean;

    property Picture: TPicture read FPicture write SetPicture;
    property Caption: String read FCaption write SetCaption;
    property Description: TStrings read FDescription write SetDescription;
    property Name: String read FName write SetName;
  end;

  TSCPictureListItems = class(TCollection)
  private
    FOwner: TSCPictureList;
    function  GetItem(Index: Integer): TSCPictureListItem;
    procedure SetItem(Index: Integer; Value: TSCPictureListItem);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TSCPictureList); virtual;
    function Add: TSCPictureListItem;
    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCPictureList read FOwner;
    {$ENDIF}
    property Items[Index: Integer]: TSCPictureListItem read GetItem write SetItem; default;
  end;

  TSCPictureChangeAction = (scpcaChanged, scpcaDestroyed);

  TSCPictureChangedEvent = procedure(Sender: TSCPictureList; Action: TSCPictureChangeAction) of object;

  TSCPictureNotifier = class(TObject)
  private
    FOnChange: TSCPictureChangedEvent;
  protected
    procedure DoChange(Sender: TSCPictureList; Action: TSCPictureChangeAction); dynamic;
  public
    property OnChange: TSCPictureChangedEvent read FOnChange write FOnChange;
  end;

  TSCPictureList = class(TComponent)
  private
    FNotifyList: TList;
    FPictures: TSCPictureListItems;
    FUpdateCount: Integer;
    procedure SetPictures(Value: TSCPictureListItems);
    procedure ItemsChanged(Action: TSCPictureChangeAction);
    function  GetCount: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure RegisterNotifier(Sender: TSCPictureNotifier);
    procedure UnregisterNotifier(Sender: TSCPictureNotifier);

    procedure NotifyAll;
    procedure BeginUpdate;
    procedure EndUpdate;
    function  InUpdate: Boolean;

    function  GetPicture(Index: Integer): TPicture; overload;
    function  GetPicture(AName: String): TPicture; overload;

    property Count: Integer read GetCount;
  published
    property Pictures: TSCPictureListItems read FPictures write SetPictures;
  end;

  TSCScrollbarDrawKind = (scsdkHorizontal, scsdkVertical, scsdkAll);
  TSCOrientation = (scoHorizontal, scoVertical);

  TSCCustomControl = class;
  TSCCustomScrollControl = class;
  TSCCustomControlScrollbar = class;

  TSCCollectionItem = class(TCollectionItem);
  TSCCollectionActionLink = class(TActionLink);

  TSCCollectionActionLinkClass = class of TSCCollectionActionLink;

  TSCControlActionLink = class(TControlActionLink)
  protected
    FClient: TSCCustomControl;
    procedure AssignClient(AClient: TObject); override;
    function  IsCaptionLinked: Boolean; override;
    function  IsEnabledLinked: Boolean; override;
    function  IsHintLinked: Boolean; override;
    function  IsImageIndexLinked: Boolean; override;
    function  IsShortCutLinked: Boolean; override;
    function  IsVisibleLinked: Boolean; override;
    function  IsOnExecuteLinked: Boolean; override;
    procedure SetCaption(const Value: string); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetHint(const Value: string); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetShortCut(Value: TShortCut); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
  end;

{ TSCControlActionLink }

  TSCControlActionLinkClass = class of TSCControlActionLink;

  TSCImageLayout = (scilBottom, scilLeft, scilRight, scilTop);

{ TSCCustomControl }

  TSCControlBorderProps = class(TPersistent)
  private
    FOwner: TSCCustomControl;
    function  GetBorder: TSCControlBorder;
    procedure SetBorder(Value: TSCControlBorder);
    function  GetBorderColor: TColor;
    procedure SetBorderColor(Value: TColor);
    function  GetBorderEx: Boolean;
    procedure SetBorderEx(Value: Boolean);
    function  GetBorderInner: TSCControlBorder;
    procedure SetBorderInner(Value: TSCControlBorder);
    function  GetBorderWidth: TBorderWidth;
    procedure SetBorderWidth(Value: TBorderWidth);
    function  GetFlatColor: TColor;
    procedure SetFlatColor(Value: TColor);
    function  GetFlatInnerColor: TColor;
    procedure SetFlatInnerColor(Value: TColor);
    function  GetFocusColor: TColor;
    procedure SetFocusColor(Value: TColor);
  protected
    function GetOwner: TPersistent; override;
    property FlatInnerColor: TColor read GetFlatInnerColor write SetFlatInnerColor default clBtnShadow;
    property InnerBorder: TSCControlBorder read GetBorderInner write SetBorderInner default sccbNone;
  public
    constructor Create(AOwner: TSCCustomControl); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomControl read FOwner;
    property Border: TSCControlBorder read GetBorder write SetBorder default sccbNone;
    property Color: TColor read GetBorderColor write SetBorderColor default clBtnFace;
    property ExDraw: Boolean read GetBorderEx write SetBorderEx default False;
    property FlatColor: TColor read GetFlatColor write SetFlatColor default clBtnShadow;
    property FocusColor: TColor read GetFocusColor write SetFocusColor default clNone;
    property Width: TBorderWidth read GetBorderWidth write SetBorderWidth default 0;
  end;

  TSCControlBorderPropsClass = class of TSCControlBorderProps;

  TSCBorderProps = class(TSCControlBorderProps)
  published
    property Border;
    property Color;
    property ExDraw;
    property FlatColor;
    property FlatInnerColor;
    property InnerBorder;
    property Width;
  end;

  TSCCustomStyleProps = class;
  TSCStyleBorderProps = class;

  TSCCustomStyleController = class(TComponent)
  private
    FControls: TList;
    FBorderProps: TSCStyleBorderProps;
    procedure SetBorderProps(Value: TSCStyleBorderProps);
  protected
    procedure Changed(Props: TSCCustomStyleProps);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RegisterChanges(Control: TSCCustomControl);
    procedure UnregisterChanges(Control: TSCCustomControl);
  published
    property BorderProps: TSCStyleBorderProps read FBorderProps write SetBorderProps;
  end;

  TSCCustomStyleProps = class(TPersistent)
  private
    FOwner: TSCCustomStyleController;
    FUpdateCount: Integer;
  protected
    function  GetOwner: TPersistent; override;
    procedure Changed;
  public
    constructor Create(AOwner: TSCCustomStyleController); virtual;
    procedure BeginUpdate;
    procedure EndUpdate;
    property  UpdateCount: Integer read FUpdateCount;

    property Owner: TSCCustomStyleController read FOwner;
  end;

  TSCStyleBorderProps = class(TSCCustomStyleProps)
  private
    FBorder: TSCControlBorder;
    FBorderColor: TColor;
    FBorderEx: Boolean;
    FBorderInner: TSCControlBorder;
    FBorderWidth: TBorderWidth;
    FFlatColor: TColor;
    FFlatInnerColor: TColor;
    procedure SetBorder(Value: TSCControlBorder);
    procedure SetBorderColor(Value: TColor);
    procedure SetBorderEx(Value: Boolean);
    procedure SetBorderInner(Value: TSCControlBorder);
    procedure SetBorderWidth(Value: TBorderWidth);
    procedure SetFlatColor(Value: TColor);
    procedure SetFlatInnerColor(Value: TColor);
  public
    constructor Create(AOwner: TSCCustomStyleController); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Border: TSCControlBorder read FBorder write SetBorder default sccbNone;
    property Color: TColor read FBorderColor write SetBorderColor default clBtnFace;
    property ExDraw: Boolean read FBorderEx write SetBorderEx default False;
    property FlatColor: TColor read FFlatColor write SetFlatColor default clBtnShadow;
    property FlatInnerColor: TColor read FFlatInnerColor write SetFlatInnerColor default clBtnShadow;
    property InnerBorder: TSCControlBorder read FBorderInner write SetBorderInner default sccbNone;
    property Width: TBorderWidth read FBorderWidth write SetBorderWidth default 0;
  end;

{$IFDEF SC_DELPHI4_AND_EARLY}
  TContextPopupEvent = procedure(Sender: TObject; MousePos: TPoint; var Handled: Boolean) of object;
{$ENDIF}

  TSCNotificationEvent = procedure (Sender: TObject; AComponent: TComponent;
    Operation: TOperation) of object;

  TSCNotifier = class(TObject)
  private
    FOnNotification: TSCNotificationEvent;
  protected
    procedure Notification(Sender: TObject; AComponent: TComponent;
      Operation: TOperation);
  published
    property OnNotification: TSCNotificationEvent read FOnNotification write FOnNotification;
  end;

  TSCCustomPictureProps = class(TPersistent)
  private
    FOwner: TSCCustomControl;
    function  GetIndent: Integer;
    procedure SetIndent(Value: Integer);
    function  GetOrient: TSCPictureOrient;
    procedure SetOrient(Value: TSCPictureOrient);
    function  GetPictureIndex: Integer;
    procedure SetPictureIndex(Value: Integer);
    function  GetPictureList: TSCPictureList;
    procedure SetPictureList(Value: TSCPictureList);
    function  GetTopIndent: Integer;
    procedure SetTopIndent(Value: Integer);
    function  GetTransparent: Boolean;
    procedure SetTransparent(Value: Boolean);
    function  GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
  protected
    function GetOwner: TPersistent; override;

    property Indent: Integer read GetIndent write SetIndent default 0;
    property Orient: TSCPictureOrient read GetOrient write SetOrient default scpoTiled;
    property PictureIndex: Integer read GetPictureIndex write SetPictureIndex default -1;
    property PictureList: TSCPictureList read GetPictureList write SetPictureList;
    property TopIndent: Integer read GetTopIndent write SetTopIndent default 0;
    property Transparent: Boolean read GetTransparent write SetTransparent default False;
    property Visible: Boolean read GetVisible write SetVisible default True;
  public
    constructor Create(AOwner: TSCCustomControl); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomControl read FOwner;
  end;

  TSCCustomPicturePropsClass = class of TSCCustomPictureProps;

  TSCPictureProps = class(TSCCustomPictureProps)
  published
    property Indent;
    property Orient;
    property PictureIndex;
    property PictureList;
    property TopIndent;
    property Transparent;
    property Visible;
  end;

  TSCCustomControl = class(TCustomControl)
  private
    FActive: Boolean;
    FAutoSize: Boolean;
    FBlendColor: Boolean;
    FBorder: TSCControlBorder;
    FBorderColor: TColor;
    FBorderEx: Boolean;
    FBorderInner: TSCControlBorder;
    FBorderProps: TSCControlBorderProps;
    FClickFocus: Boolean;
    FFlatColor: TColor;
    FFlatInnerColor: TColor;
    FBorderFocusColor: TColor;
    FImageIndex: TImageIndex;
    FImages: TCustomImageList;
    FImageLayout: TSCImageLayout;
    FImageChangeLink: TChangeLink;
    FIndent: Integer;
    FPicture: TPicture;
    FPictureProps: TSCCustomPictureProps;
    FPictureOrient: TSCPictureOrient;
    FPictureIndent: Integer;
    FPictureTopIndent: Integer;
    FPictureTransparent: Boolean;
    FPictureIndex: Integer;
    FPictureList: TSCPictureList;
    FPictureNotifier: TSCPictureNotifier;
    FSpacing: Integer;
    FTransparent: Boolean;
    FUpdateCount: Integer;
    FMouseInControl: Boolean;
    FMouseIsDown: Boolean;
    FMouseDownPoint: TPoint;
    FCreatingControl: Boolean;
    FShowPicture: Boolean;
    FDrawingPicture: Boolean;
    FOnChange: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnPictureChange: TNotifyEvent;
    FHotNCArea: LongInt;
    FNCIsDown: Boolean;
    FHasFocus: Boolean;
    FInChange: Integer;
    FCreatingWnd: Integer;
    FNotificationList: TList;
    FStyleController: TSCCustomStyleController;
    {$IFDEF SC_DELPHI4_AND_EARLY}
    FOnContextPopup: TContextPopupEvent;
    {$ENDIF}
    FOnFocusChange: TNotifyEvent;
    function  GetAbout: TSCAboutString;
    procedure SetAbout(Value: TSCAboutString);
    procedure SetBorder(Value: TSCControlBorder);
    procedure SetBorderColor(Value: TColor);
    procedure SetBorderEx(Value: Boolean);
    procedure SetBorderInner(Value: TSCControlBorder);
    function  GetBorderProps: TSCControlBorderProps;
    procedure SetBorderProps(Value: TSCControlBorderProps);
    procedure SetBlendColor(Value: Boolean);
    procedure SetBorderFocusColor(Value: TColor);
    procedure SetFlatColor(Value: TColor);
    procedure SetFlatInnerColor(Value: TColor);
    procedure SetImageLayout(Value: TSCImageLayout);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetImages(Value: TCustomImageList);
    procedure SetPicture(Value: TPicture);
    procedure SetPictureProps(Value: TSCCustomPictureProps);
    procedure SetPictureOrient(Value: TSCPictureOrient);
    procedure SetPictureIndent(Value: Integer);
    procedure SetPictureTopIndent(Value: Integer);
    procedure SetPictureTransparent(Value: Boolean);
    procedure SetPictureIndex(Value: Integer);
    procedure SetPictureList(Value: TSCPictureList);
    procedure SetShowPicture(Value: Boolean);
    procedure SetStyleController(Value: TSCCustomStyleController);
    function  GetInUpdate: Boolean;

    procedure TranslateMouseDown(var Message: TWMMouse; Button: TMouseButton; Shift: TShiftState);
    procedure TranslateMouseMove(var Message: TWMMouse);
    procedure TranslateMouseUp(var Message: TWMMouse; Button: TMouseButton);

    procedure CMChanged(var Message: TMessage); message CM_CHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMParentColorChanged(var Message: TWMNoParams); message CM_PARENTCOLORCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMJumpToNext(var Message: TMessage); message CM_SCJUMPTONEXT;
    procedure CMIsVisibleChild(var Message: TMessage); message CM_SCISVISIBLECHILD;
    procedure CNChar(var Message: TWMChar); message CN_CHAR;

    procedure WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure WMCaptureChanged(var Message: TMessage); message WM_CAPTURECHANGED;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMSettingChange(var Message: TWMSettingChange); message WM_SETTINGCHANGE;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMPrint(var Message: TMessage); message WM_PRINT;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMWindowPosChanged(var Message: TMessage); message WM_WINDOWPOSCHANGED;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMSysKeyDown(var Message: TWMKeyDown); message WM_SYSKEYDOWN;
    procedure WMChar(var Message: TWMChar); message WM_CHAR;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMMButtonDown(var Message: TWMMButtonDown); message WM_MBUTTONDOWN;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMMButtonUp(var Message: TWMMButtonUp); message WM_MBUTTONUP;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMRButtonDblClk(var Message: TWMRButtonDblClk); message WM_RBUTTONDBLCLK;
    procedure WMMButtonDblClk(var Message: TWMMButtonDblClk); message WM_MBUTTONDBLCLK;
    procedure WMNCLButtonDown(var Message: TWMNCHitMessage); message WM_NCLBUTTONDOWN;
    procedure WMNCRButtonDown(var Message: TWMNCHitMessage); message WM_NCRBUTTONDOWN;
    procedure WMNCMButtonDown(var Message: TWMNCHitMessage); message WM_NCMBUTTONDOWN;
    procedure WMNCLButtonDblClk(var Message: TWMNCHitMessage); message WM_NCLBUTTONDBLCLK;
    procedure WMNCRButtonDblClk(var Message: TWMNCHitMessage); message WM_NCRBUTTONDBLCLK;
    procedure WMNCMButtonDblClk(var Message: TWMNCHitMessage); message WM_NCMBUTTONDBLCLK;
    procedure WMNCMouseMove(var Message: TWMNCHitMessage); message WM_NCMOUSEMOVE;
    procedure WMNCLButtonUp(var Message: TWMNCHitMessage); message WM_NCLBUTTONUP;
    procedure WMNCRButtonUp(var Message: TWMNCHitMessage); message WM_NCRBUTTONUP;
    procedure WMNCMButtonUp(var Message: TWMNCHitMessage); message WM_NCMBUTTONUP;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;

    procedure DoBorderChanged;
    procedure DoFocusChanged;

    procedure DoFakeMouseDown(Message: TWMMouse; Button: TMouseButton; Shift: TShiftState);
    procedure DoFakeMouseMove(Message: TWMMouse);
    procedure DoFakeMouseUp(Message: TWMMouse; Button: TMouseButton);

    procedure DoNCMouseDown(var Message: TWMNCHitMessage; Button: TMouseButton; Shift: TShiftState);
    procedure DoNCMouseUp(var Message: TWMNCHitMessage; Button: TMouseButton);

    procedure PictureListChanged(Sender: TSCPictureList; Action: TSCPictureChangeAction);
    procedure PictureChanged(Sender: TObject);
  protected
    procedure CreateWnd; override;

    procedure Paint; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure NotifyAll(AComponent: TComponent; Operation: TOperation);

    function  GetClientRect: TRect; override;
    procedure SetTransparent(Value: Boolean); virtual;

    procedure BeginCreatingWnd;
    procedure EndCreatingWnd;
    function  IsCreatingWnd: Boolean;

    function  IsVisibleChild(C: TControl): Boolean; dynamic;
    function  CanDoNextControl(CharCode: Word; Shift: TShiftState): Boolean;
    function  DoNextControl(CharCode: Word; Shift: TShiftState): Boolean;
    function  CanMenuPopup(const Pos: TSmallPoint): Boolean; virtual;

    procedure BeforeEnter; virtual;
    procedure AfterEnter; virtual;
    procedure BeforeExit; virtual;
    procedure AfterExit; virtual;

    function  GetDefaultBackColor: TColor; virtual;
    function  GetDefaultForeColor: TColor; virtual;

    function  GetImages: TCustomImageList; virtual;
    function  GetImageIndex: TImageIndex; virtual;

    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;

    function  CanSetBorder(Value: TSCControlBorder): Boolean; dynamic;
    function  CanSetInnerBorder(Value: TSCControlBorder): Boolean; dynamic;

    procedure AlignControls(AControl: TControl; var Rect: TRect); override;

    function  CanUpdateStyle(Props: TSCCustomStyleProps): Boolean; dynamic;
    procedure AssignProps(Props: TSCCustomStyleProps); dynamic;

    procedure NotifyStyleChange; overload;
    procedure NotifyStyleChange(Props: TSCCustomStyleProps); overload;

    procedure DoPictureListChanged; dynamic;
    procedure DoPictureChanged; dynamic;

    function  HasPicture: Boolean; overload;
    function  HasPicture(P: TPicture): Boolean; overload; virtual;
    function  GetPicture: TPicture; virtual;
    function  GetPictureRect: TRect; overload;
    function  GetPictureRect(P: TPicture): TRect; overload; virtual;
    function  CanDrawPicture: Boolean; overload;
    function  CanDrawPicture(P: TPicture): Boolean; overload; virtual;
    procedure DrawPicture(C: TCanvas); virtual;

    function  GetBorderPropsClass: TSCControlBorderPropsClass; dynamic;
    function  GetPicturePropsClass: TSCCustomPicturePropsClass; dynamic;

    procedure Change; dynamic;
    procedure DoChange; dynamic;
    procedure FocusChanged; dynamic;
    procedure TransparentChanged; dynamic;
    procedure EnabledChanged; dynamic;
    procedure SystemColorsChanged; dynamic;

    procedure ScrollerDestroyed(Sender: TSCCustomControlScrollbar); dynamic;
    procedure ScrollerChanged(Sender: TSCCustomControlScrollbar); dynamic;
    procedure ScrollerPositionChanged(Sender: TSCCustomControlScrollbar); overload; dynamic;
    procedure ScrollerPositionChanged(Sender: TSCCustomControlScrollbar; OldPos, NewPos: Integer); overload; dynamic;
    procedure ScrollerPositionChanging(Sender: TSCCustomControlScrollbar;
      var ScrollPos: Integer; var CanScroll: Boolean); dynamic;
    procedure ScrollerRangeChanged(Sender: TSCCustomControlScrollbar); dynamic;
    procedure ScrollerSizeChanged(Sender: TSCCustomControlScrollbar); dynamic;
    procedure ScrollerVisibleChanged(Sender: TSCCustomControlScrollbar); dynamic;

    function  GetHorzScrollbarRect: TRect; dynamic;
    function  GetVertScrollbarRect: TRect; dynamic;

    function  GetNCAreaAtPos(P: TPoint): LongInt;
    function  GetInheritedNCArea(P: TPoint): LongInt; dynamic;
    function  CanCaptureMouseOnNC(P: TPoint): Boolean; dynamic;

    procedure NCMouseLeave; dynamic;
    procedure NCMouseEnter(var HitTest: LongInt; X, Y: Integer); dynamic;
    procedure NCMouseDown(Button: TMouseButton; HitTest: LongInt; DblClk: Boolean; X, Y: Integer); dynamic;
    procedure NCMouseMove(HitTest: LongInt; X, Y: Integer); dynamic;
    procedure NCMouseUp(Button: TMouseButton; HitTest: LongInt; X, Y: Integer); dynamic;

    function  CanGetFocus: Boolean; virtual;

    function  GetBorderSize: Integer; virtual;
    function  GetInnerBorderSize: Integer; virtual;
    procedure CalculateBorder(var R: TRect); virtual;

    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;

    procedure UpdateTracking;
    function  IsActiveParent: Boolean;

    procedure DoFillScrollBarsCorner(OnDC: HDC = 0); virtual;
    procedure RedrawBorder(const Clip: HRGN; OnDC: HDC = 0); virtual;
    procedure RedrawScrollbars(Kind: TSCScrollbarDrawKind = scsdkAll; OnDC: HDC = 0); virtual;

    procedure BorderChanged; virtual;
    function  GetBorderExColor: TColor; dynamic;
    procedure PaintParentOn(C: TCanvas); virtual;

    procedure AutoSizeChanged; dynamic;
    procedure DoAutoSize(Value: Boolean);
    procedure SetAutoSize(Value: Boolean); {$IFDEF SC_DELPHI6_UP} override; {$ELSE} virtual; {$ENDIF}
    procedure AdjustBounds; dynamic;
    function  GetAdjustedRect(NewWidth, NewHeight: Integer): TRect; virtual;

    procedure SetIndent(Value: Integer); virtual;
    procedure IndentChanged; dynamic;

    procedure SetSpacing(Value: Integer); virtual;
    procedure SpacingChanged; dynamic;

    procedure CaptureChanged(Captured: Boolean); virtual;
    procedure StopTracking; virtual;
    procedure MouseInControlChanged; virtual;
    function  IsInClientRect(X, Y: Integer): Boolean; dynamic;

    function  IsActive: Boolean; virtual;
    procedure ImageListChange(Sender: TObject); dynamic;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    function  GetActionLinkClass: TControlActionLinkClass; override;

    function  GetFaceColor: TColor; virtual;
    function  GetIndent: Integer; virtual;
    function  GetImageRect: TRect; virtual;
    function  GetTextRect: TRect; virtual;
    function  GetTextCalculateFont: TFont; virtual;
    function  GetTextHeight: Integer; virtual;
    function  CalculateImageRect: TRect; virtual;
    function  CalculateTextRect: TRect; virtual;
    function  GetBlendValue: Word; virtual;
    function  CurrentBlendedColor(AColor: TColor): TColor; dynamic;
    function  DefaultBlendedColor(AColor: TColor): TColor; dynamic;
    procedure UpdateLocked; dynamic;
    procedure UpdateUnlocked; dynamic;

    function  IsVertScrollBarVisible: Boolean; dynamic;
    function  IsHorzScrollBarVisible: Boolean; dynamic;

    procedure DoBeginUpdate; virtual;
    procedure DoEndUpdate; virtual;

    property HotNCArea: LongInt read FHotNCArea;
    property NCIsDown: Boolean read FNCIsDown;

    property Active: Boolean read FActive write FActive default False;
    {$IFDEF SC_DELPHI4_UP}
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    {$ELSE}
    property AutoSize default False;
    {$ENDIF}
    property BlendColor: Boolean read FBlendColor write SetBlendColor default False;
    property Border: TSCControlBorder read FBorder write SetBorder default sccbNone;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clBtnFace;
    property BorderEx: Boolean read FBorderEx write SetBorderEx default False;
    property BorderInner: TSCControlBorder read FBorderInner write SetBorderInner default sccbNone;
    property BorderProps: TSCControlBorderProps read GetBorderProps write SetBorderProps;
    property Caption;
    property Color nodefault;
    property FlatColor: TColor read FFlatColor write SetFlatColor default clBtnShadow;
    property BorderFocusColor: TColor read FBorderFocusColor write SetBorderFocusColor default clNone;
    property FlatInnerColor: TColor read FFlatInnerColor write SetFlatInnerColor default clBtnShadow;
    property Font;
    property MouseInControl: Boolean read FMouseInControl write FMouseInControl;
    property MouseIsDown: Boolean read FMouseIsDown write FMouseIsDown;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property ImageLayout: TSCImageLayout read FImageLayout write SetImageLayout default scilLeft;
    property Images: TCustomImageList read FImages write SetImages;
    property Indent: Integer read FIndent write SetIndent default 0;
    property MouseDownPoint: TPoint read FMouseDownPoint write FMouseDownPoint;
    property Picture: TPicture read FPicture write SetPicture;
    property PictureProps: TSCCustomPictureProps read FPictureProps write SetPictureProps;
    property PictureOrient: TSCPictureOrient read FPictureOrient write SetPictureOrient default scpoTiled;
    property PictureIndent: Integer read FPictureIndent write SetPictureIndent default 0;
    property PictureTopIndent: Integer read FPictureTopIndent write SetPictureTopIndent default 0;
    property PictureTransparent: Boolean read FPictureTransparent write SetPictureTransparent default False;
    property PictureIndex: Integer read FPictureIndex write SetPictureIndex default -1;
    property PictureList: TSCPictureList read FPictureList write SetPictureList;
    property ShowPicture: Boolean read FShowPicture write SetShowPicture default True;
    property Spacing: Integer read FSpacing write SetSpacing default 4;
    property StyleController: TSCCustomStyleController read FStyleController write SetStyleController;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property Height;
    property Width;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    {$IFDEF SC_DELPHI4_AND_EARLY}
    property OnContextPopup: TContextPopupEvent read FOnContextPopup write FOnContextPopup;
    {$ENDIF}
    property OnFocusChange: TNotifyEvent read FOnFocusChange write FOnFocusChange;
    property OnPictureChange: TNotifyEvent read FOnPictureChange write FOnPictureChange;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  CanGetClientRect: Boolean;
    function  ScreenToNC(P: TPoint): TPoint; virtual;
    function  IsValidImage(Indx: Integer): Boolean; virtual;

    procedure BeginUpdate;
    procedure EndUpdate;

    function  IsLocked: Boolean; virtual;
    function  IsLoading: Boolean; 
    function  IsDestroying: Boolean;
    function  IsDesigning: Boolean;
    function  IsUpdating: Boolean;
    function  IsReading: Boolean;
    function  IsWriting: Boolean;

    function  CaptureFocus(ProcessEvents: Boolean): Boolean; dynamic;
    function  IsActiveControl: Boolean; dynamic;

    procedure RegisterNotifier(ANotifier: TSCNotifier);
    procedure UnregisterNotifier(ANotifier: TSCNotifier);

    procedure SaveToFile(const FileName: String); dynamic;
    procedure LoadFromFile(const FileName: String); dynamic;

    property HasFocus: Boolean read FHasFocus;
    property InUpdate: Boolean read GetInUpdate;
    property UpdateCount: Integer read FUpdateCount;
    property ClickFocus: Boolean read FClickFocus write FClickFocus default True;
  published
    property About: TSCAboutString read GetAbout write SetAbout stored False;
  end;

  TSCCustomSizableControl = class(TSCCustomControl)
  private
    FShowSizeGrip: Boolean;
    FShowStatusbar: Boolean;
    FStatusbarColor: TColor;
    FStatusbarText: TCaption;
    FStatusbarAlignment: TAlignment;
    procedure SetShowSizeGrip(Value: Boolean);
    procedure SetShowStatusbar(Value: Boolean);
    procedure SetStatusbarAlignment(Value: TAlignment);
    procedure SetStatusbarColor(Value: TColor);
    procedure SetStatusbarText(const Value: TCaption);
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    function  GetStatusbarHeight: Integer;
    procedure CalculateBorder(var R: TRect); override;
    procedure RedrawBorder(const Clip: HRGN; OnDC: HDC = 0); override;

    procedure StatusbarChanged; dynamic;

    function  GetStatusbarPartAtPos(P: TPoint): LongInt;
    function  GetInheritedNCArea(P: TPoint): LongInt; override;

    property ShowSizeGrip: Boolean read FShowSizeGrip write SetShowSizeGrip default True;
    property ShowStatusbar: Boolean read FShowStatusbar write SetShowStatusbar default False;
    property StatusbarAlignment: TAlignment read FStatusbarAlignment write SetStatusbarAlignment default taLeftJustify;
    property StatusbarColor: TColor read FStatusbarColor write SetStatusbarColor default clBtnFace;
    property StatusbarText: TCaption read FStatusbarText write SetStatusbarText;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCScrollbarPart = class(TPersistent)
  private
    FBlend: Boolean;
    FColor: TColor;
    FDisabledColor: TColor;
    FDownColor: TColor;
    FEnabled: Boolean;
    FHotColor: TColor;
    FVisible: Boolean;
    FOwner: TSCCustomControlScrollbar;
    procedure SetBlend(Value: Boolean);
    procedure SetColor(Value: TColor);
    procedure SetDisabledColor(Value: TColor);
    procedure SetDownColor(Value: TColor);
    procedure SetEnabled(Value: Boolean);
    procedure SetHotColor(Value: TColor);
    procedure SetVisible(Value: Boolean);

    procedure DoChanged;
  protected
    function GetOwner: TPersistent; override;

    property Blend: Boolean read FBlend write SetBlend default False;
    property Color: TColor read FColor write SetColor default clScrollBar;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clScrollBar;
    property DownColor: TColor read FDownColor write SetDownColor default clScrollBar;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property HotColor: TColor read FHotColor write SetHotColor default clScrollBar;
    property Visible: Boolean read FVisible write SetVisible default True;
  public
    constructor Create(AOwner: TSCCustomControlScrollbar); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomControlScrollbar read FOwner;
  end;

  TSCScrollbarBkground = class(TSCScrollbarPart)
  public
    constructor Create(AOwner: TSCCustomControlScrollbar); override;
  published
    property Blend default True;
    property Color;
    property DisabledColor;
    property HotColor;
    property DownColor default cl3DDkShadow;
  end;

  TSCScrollbarButtonColors = class(TSCScrollbarPart)
  published
    property Color;
    property DisabledColor;
    property DownColor;
    property HotColor;
  end;

  TSCScrollbarButton = class(TSCScrollbarPart)
  published
    property Enabled;
    property Visible;
  end;

  TSCScrollbarIcons = class(TSCScrollbarPart)
  public
    constructor Create(AOwner: TSCCustomControlScrollbar); override;
  published
    property Color default clWindowText;
    property DisabledColor default clGrayText;
    property DownColor default clWindowText;
    property HotColor default clWindowText;
  end;

  TSCScrollbarThumb = class(TSCScrollbarPart)
  public
    property Visible;
  published
    property Color;
    property DisabledColor;
    property DownColor;
    property HotColor;
  end;

  TSCScrollbarPartClass = class of TSCScrollbarPart;

  TSCScrollerPart = (scsbpBkground, scsbpIcon, scsbpButtons, scsbpExtraButton,
    scsbpLeftButton, scsbpRightButton, scsbpThumb);

  TSCCustomControlScrollbar = class(TPersistent)
  private
    FBackground: TSCScrollbarPart;
    FBorderColor: TColor;
    FButtonColors: TSCScrollbarPart;
    FButtonLayout: TSCScrollButtonLayout;
    FButtonExtra: TSCScrollbarPart;
    FButtonLeft: TSCScrollbarPart;
    FButtonRight: TSCScrollbarPart;
    FButtonSize: Integer;
    FEnabled: Boolean;
    FIcons: TSCScrollbarPart;
    FKind: TSCScrollbarKind;
    FLargeChange: TSCScrollbarInc;
    FMax: Integer;
    FMin: Integer;
    FPageSize: Integer;
    FPosition: Integer;
    FSensitivity: Integer;
    FSlideLine: Boolean;
    FSmallChange: TSCScrollbarInc;
    FStyle: TSCScrollbarStyle;
    FThumb: TSCScrollbarPart;
    FThumbLines: TSCScrollThumbline;
    FThumbSize: Integer;
    FTrack: Boolean;
    FTrimPageSize: Boolean;
    FVisible: Boolean;
    FOwner: TSCCustomControl;
    FUpdateCount: Integer;
    FPosChangeLock: Integer;
    FWasVisible: Boolean;
    FDefH_ButtonSize: Integer;
    FDefV_ButtonSize: Integer;
    FUpdatePos: Integer;
    FLineDiv: Integer;
    FPageDiv: Integer;
    FDelay: Integer;
    FSmooth: Boolean;
    procedure SetBackground(Value: TSCScrollbarPart);
    procedure SetBorderColor(Value: TColor);
    procedure SetButtonColors(Value: TSCScrollbarPart);
    procedure SetButtonExtra(Value: TSCScrollbarPart);
    procedure SetButtonLeft(Value: TSCScrollbarPart);
    procedure SetButtonRight(Value: TSCScrollbarPart);
    procedure SetButtonSize(Value: Integer);
    procedure SetEnabled(Value: Boolean);
    function  GetExtraButton: Boolean;
    procedure SetExtraButton(Value: Boolean);
    procedure SetIcons(Value: TSCScrollbarPart);
    procedure SetLargeChange(Value: TSCScrollbarInc);
    procedure SetPageSize(Value: Integer);
    function  GetRange: Integer;
    procedure SetSensitivity(Value: Integer);
    procedure SetSlideLine(Value: Boolean);
    procedure SetSmallChange(Value: TSCScrollbarInc);
    procedure SetStyle(Value: TSCScrollbarStyle);
    procedure SetThumb(Value: TSCScrollbarPart);
    procedure SetThumbLines(Value: TSCScrollThumbline);
    procedure SetThumbSize(Value: Integer);
    procedure SetTrack(Value: Boolean);
    procedure SetTrimPageSize(Value: Boolean);
    procedure SetVisible(Value: Boolean);

    function  GetHovered: Boolean;
    function  GetFocused: Boolean;
    function  GetDownPoint: TPoint;
    function  GetHotPart: TSCScrollerHitPart;
    function  GetPressedPart: TSCScrollerHitPart;
    function  GetThumbMoving: Boolean;

    procedure RearrangeDefaults;

    procedure BufferedPaint(DC: HDC; R: TRect);
    procedure PaintOn(DC: HDC; R: TRect);
    procedure PartChanged(Sender: TSCScrollbarPart);
  protected
    function  GetOwner: TPersistent; override;
    procedure Paint(Canvas: TCanvas; R: TRect); virtual;

    procedure SetMax(Value: Integer); virtual;
    procedure SetMin(Value: Integer); virtual;
    procedure SetRange(Value: Integer); virtual;
    procedure SetPosition(Value: Integer); virtual;

    procedure ScrollMessage(var Msg: TWMScroll); virtual;
    function  GetCalcRange: Integer; dynamic;
    function  GetSensitivity: Integer; virtual;

    procedure DoChange;
    procedure DoPositionChanged; overload;
    procedure DoPositionChanged(OldPos, NewPos: Integer); overload;
    procedure DoPositionChanging(var ScrollPos: Integer; var CanScroll: Boolean);
    procedure DoRangeChanged;
    procedure DoSizeChanged;
    procedure DoVisibleChanged;

    function  CanScrollToPos(var NewValue: Integer): Boolean; dynamic;
    function  GetScrollbarPartClass(Part: TSCScrollerPart): TSCScrollbarPartClass; dynamic;

    function  GetPageUpDownSize: Integer; virtual;

    function  GetBackColor: TColor; virtual;
    function  GetExtraBtnColor: TColor; virtual;
    function  GetExtraBtnIconColor: TColor; virtual;
    function  GetLeftBtnColor: TColor; virtual;
    function  GetLeftBtnIconColor: TColor; virtual;
    function  GetRightBtnColor: TColor; virtual;
    function  GetRightBtnIconColor: TColor; virtual;
    function  GetThumbColor: TColor; virtual;

    function  GetButtonSize(R: TRect): Integer;
    function  GetThumbOffset(R: TRect): Integer;
    function  GetThumbSize(R: TRect): Integer;
    function  GetDefaultThumbSize(R: TRect; Pg: Integer): Integer;
    function  GetPositionPos(R: TRect; P: Integer): Integer;

    function  GetBackRect(R: TRect): TRect;
    function  GetExtraButtonRect(R: TRect): TRect; dynamic;
    function  GetLeftButtonRect(R: TRect): TRect; dynamic;
    function  GetRightButtonRect(R: TRect): TRect; dynamic;
    function  GetThumbRect(R: TRect): TRect; dynamic;

    property Focused: Boolean read GetFocused;
    property Hovered: Boolean read GetHovered;
    property DownPoint: TPoint read GetDownPoint;
    property HotPart: TSCScrollerHitPart read GetHotPart;
    property PressedPart: TSCScrollerHitPart read GetPressedPart;

    property Background: TSCScrollbarPart read FBackground write SetBackground;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clWindowFrame;
    property ButtonColors: TSCScrollbarPart read FButtonColors write SetButtonColors;
    property ButtonLayout: TSCScrollButtonLayout read FButtonLayout;
    property ButtonExtra: TSCScrollbarPart read FButtonExtra write SetButtonExtra;
    property ButtonLeft: TSCScrollbarPart read FButtonLeft write SetButtonLeft;
    property ButtonRight: TSCScrollbarPart read FButtonRight write SetButtonRight;
    property ButtonSize: Integer read FButtonSize write SetButtonSize default -1;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property ExtraButton: Boolean read GetExtraButton write SetExtraButton default False;
    property Icons: TSCScrollbarPart read FIcons write SetIcons;
    property Kind: TSCScrollbarKind read FKind;
    property LargeChange: TSCScrollbarInc read FLargeChange write SetLargeChange default 1;
    property Max: Integer read FMax write SetMax default 100;
    property Min: Integer read FMin write SetMin default 0;
    property PageSize: Integer read FPageSize write SetPageSize default 0;
    property Position: Integer read FPosition write SetPosition default 0;
    property Range: Integer read GetRange write SetRange stored False default 100; 
    property Sensitivity: Integer read FSensitivity write SetSensitivity default -1;
    property SlideLine: Boolean read FSlideLine write SetSlideLine default False;
    property SmallChange: TSCScrollbarInc read FSmallChange write SetSmallChange default 1;
    property Smooth: Boolean read FSmooth write FSmooth default False;
    property Style: TSCScrollbarStyle read FStyle write SetStyle default scssDefault;
    property Thumb: TSCScrollbarPart read FThumb write SetThumb;
    property ThumbLines: TSCScrollThumbline read FThumbLines write SetThumbLines default sctlNone;
    property ThumbSize: Integer read FThumbSize write SetThumbSize default -1;
    property Track: Boolean read FTrack write SetTrack default True;
    property TrimPageSize: Boolean read FTrimPageSize write SetTrimPageSize default True;
    property Visible: Boolean read FVisible write SetVisible default True;
  public
    constructor Create(AOwner: TSCCustomControl; AKind: TSCScrollbarKind); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Invalidate;
    function  GetClientRect: TRect;
    function  GetMaximumValue: Integer; virtual;

    procedure BeginUpdate;
    procedure EndUpdate;
    function  InUpdate: Boolean;

    procedure LockPosChange;
    procedure UnlockPosChange;
    function  PosChangeLocked: Boolean;

    property Owner: TSCCustomControl read FOwner;
  end;

  TSCCustomControlScrollbarClass = class of TSCCustomControlScrollbar;

  TSCControlScrollbar = class(TSCCustomControlScrollbar)
  protected
    procedure Paint(Canvas: TCanvas; R: TRect); override;

    procedure DrawBack(C: TCanvas; InRect: TRect); dynamic;
    procedure DrawScrollBack(C: TCanvas; InRect: TRect); dynamic;
    procedure DrawExtraButton(C: TCanvas; InRect: TRect); dynamic;
    procedure DrawLeftButton(C: TCanvas; InRect: TRect); dynamic;
    procedure DrawRightButton(C: TCanvas; InRect: TRect); dynamic;
    procedure DrawThumb(C: TCanvas; InRect: TRect); dynamic;
    procedure DrawThumbLines(C: TCanvas; R: TRect; Cl: TColor); dynamic;
    procedure DrawBorder(C: TCanvas; R: TRect); dynamic;
    procedure DrawXPFace(C: TCanvas; R: TRect; Cl, BkCl: TColor; IsThumb,
      IsDown, IsHot: Boolean); dynamic;
    procedure DrawOffice12Border(C: TCanvas; R: TRect); dynamic;

    property Visible default False;
    property TrimPageSize;
  public
    constructor Create(AOwner: TSCCustomControl; AKind: TSCScrollbarKind); override;
  end;

  TSCScrollInfo = record
    Min: Integer;
    Max: Integer;
    Page: Integer;
    Pos: Integer;
    Range: Integer;
    ButtonSize: Integer;
    ThumbSize: Integer;
    LargeChange: Integer;
    SmallChange: Integer;
    Visible: Boolean;
    Enabled: Boolean;
    Smooth: Boolean;
    LeftButtonEnabled: Boolean;
    LeftButtonVisible: Boolean;
    RightButtonEnabled: Boolean;
    RightButtonVisible: Boolean;
    Tracking: Boolean;
    ThumbEnabled: Boolean;
    ThumbVisible: Boolean;
    TrimPageSize: Boolean;
  end;
  PSCScrollInfo = ^TSCScrollInfo;

  TSCScrollbarHittest = record
    Kind: TSCScrollbarHitKind;
    HitPart: TSCScrollerHitPart;
    Enabled: Boolean;
    X: Integer;
    Y: Integer;
  end;
  PSCScrollbarHittest = ^TSCScrollbarHittest;

  TSCControlCustomScrollbars = class(TPersistent)
  private
    FSmooth: Boolean;
    FOwner: TSCCustomScrollControl;
    function  GetExtraButton: Boolean;
    procedure SetExtraButton(Value: Boolean);
    function  GetHeight: Integer;
    procedure SetHeight(Value: Integer);
    function  GetHorizontal: TSCCustomControlScrollbar;
    procedure SetHorizontal(Value: TSCCustomControlScrollbar);
    function  GetLayout: TSCScrollButtonLayout;
    procedure SetLayout(Value: TSCScrollButtonLayout);
    procedure SetSmooth(Value: Boolean);
    function  GetStyle: TSCScrollbarStyle;
    procedure SetStyle(Value: TSCScrollbarStyle);
    function  GetThumbLines: TSCScrollThumbline;
    procedure SetThumbLines(Value: TSCScrollThumbline);
    function  GetType: TSCScrollbarType;
    procedure SetType(Value: TSCScrollbarType);
    function  GetVertical: TSCCustomControlScrollbar;
    procedure SetVertical(Value: TSCCustomControlScrollbar);
  protected
    function GetOwner: TPersistent; override;

    property ExtraButton: Boolean read GetExtraButton write SetExtraButton default False;
    property Height: Integer read GetHeight write SetHeight default -1;
    property Horizontal: TSCCustomControlScrollbar read GetHorizontal write SetHorizontal;
    property Layout: TSCScrollButtonLayout read GetLayout write SetLayout default scsbDefault;
    property Smooth: Boolean read FSmooth write SetSmooth default False;
    property ScrollbarType: TSCScrollbarType read GetType write SetType default scsbtSweet;
    property Style: TSCScrollbarStyle read GetStyle write SetStyle default scssDefault;
    property ThumbLines: TSCScrollThumbline read GetThumbLines write SetThumbLines default sctlNone;
    property Vertical: TSCCustomControlScrollbar read GetVertical write SetVertical;
  public
    constructor Create(AOwner: TSCCustomScrollControl); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCCustomScrollControl read FOwner;
  end;

  TSCControlCustomScrollbarsClass = class of TSCControlCustomScrollbars;

  TSCControlScrollbars = class(TSCControlCustomScrollbars)
  published
    property ExtraButton;
    property Height;
    property Horizontal;
    property Layout;
    property Style;
    property ScrollbarType;
    property ThumbLines;
    property Vertical;
  end;

  TSCScrollChangeEvent = procedure (Sender: TSCCustomScrollControl;
    Kind: TSCScrollbarKind) of object;

  TSCCustomScrollControl = class(TSCCustomSizableControl)
  private
    FUpdatingScrollbar: Integer;
    FScrollbars: TSCControlCustomScrollbars;
    FScrollbarHeight: Integer;
    FScrollbarExtraButton: Boolean;
    FScrollbarHorz: TSCCustomControlScrollbar;
    FScrollbarVert: TSCCustomControlScrollbar;
    FScrollbarStyle: TSCScrollbarStyle;
    FScrollButtonsLayout: TSCScrollButtonLayout;
    FScrollbarThumbLines: TSCScrollThumbline;
    FScrollbarType: TSCScrollbarType;
    FHotTest: TSCScrollbarHittest;
    FDownTest: TSCScrollbarHittest;
    FDownPoint: TPoint;
    FMovePoint: TPoint;
    FDownPosition: Integer;
    FMovingThumb: Boolean;
    FScrolling: Boolean;
    FScrollTimer: Integer;
    FKeyboardSpeed: Integer;
    FOnScroll: TSCScrollEvent;
    FOnScrollChangeEvent: TSCScrollChangeEvent;
    procedure SetScrollbars(Value: TSCControlCustomScrollbars);
    procedure SetScrollbarExtraButton(Value: Boolean);
    procedure SetScrollbarHeight(Value: Integer);
    procedure SetScrollbarHorz(Value: TSCCustomControlScrollbar);
    procedure SetScrollbarVert(Value: TSCCustomControlScrollbar);
    procedure SetScrollbarStyle(Value: TSCScrollbarStyle);
    procedure SetScrollbarType(Value: TSCScrollbarType);
    procedure SetScrollbarThumbLines(Value: TSCScrollThumbline);
    procedure SetScrollButtonsLayout(Value: TSCScrollButtonLayout);

    procedure FillScrollbarBack(DC: HDC; R: TRect);
    procedure FillScrollbarHittest(P: TPoint; Ht: PSCScrollbarHittest);
    procedure AssignHittest(FromHt, ToHt: PSCScrollbarHittest);

    function  IsScrollingReady: Boolean;
    function  CanScrollBars(AsLeft: Boolean): Boolean;
    function  ScrollingBars: Boolean;
    function  ScrollingPaused: Boolean;
    procedure ResumeScrollingBars;
    procedure StartScrollingBars;
    procedure PauseScrollingBars;
    procedure StopScrollingBars;
    procedure ScrollControl;
    function  IsScrollPart(HitPart: TSCScrollerHitPart): Boolean;
    procedure ResetScrollbarInfo(Si: PSCScrollInfo);

    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSettingChange(var Message: TMessage);message WM_SETTINGCHANGE;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  protected
    procedure CreateWnd; override;

    procedure CalculateBorder(var R: TRect); override;
    procedure StopTracking; override;
    procedure EnabledChanged; override;

    procedure ScrollerDestroyed(Sender: TSCCustomControlScrollbar); override;
    procedure ScrollerChanged(Sender: TSCCustomControlScrollbar); override;
    procedure ScrollerVisibleChanged(Sender: TSCCustomControlScrollbar); override;
    procedure ScrollerPositionChanged(Sender: TSCCustomControlScrollbar); overload; override;
    procedure ScrollerPositionChanged(Sender: TSCCustomControlScrollbar; OldPos, NewPos: Integer); overload; override;
    procedure ScrollerPositionChanging(Sender: TSCCustomControlScrollbar;
      var ScrollPos: Integer; var CanScroll: Boolean); override;

    function  IsVertScrollBarVisible: Boolean; override;
    function  IsHorzScrollBarVisible: Boolean; override;

    procedure ScrollbarTypeChanged; dynamic;
    function  GetDefaultScrollInfo(Kind: TSCScrollbarKind): TScrollInfo; virtual;
    procedure UpdateDefaultScrollbar(Sender: TSCCustomControlScrollbar); 

    procedure RedrawScrollbars(Kind: TSCScrollbarDrawKind = scsdkAll; OnDC: HDC = 0); override;
    function  CanScrollToPos(Kind: TSCScrollbarKind; var NewValue: Integer): Boolean; dynamic;
    procedure DoScrollerPositionChanged(Kind: TSCScrollbarKind); overload; dynamic;
    procedure DoScrollerPositionChanged(Kind: TSCScrollbarKind; OldPos, NewPos: Integer); overload; dynamic;
    procedure DoScrollerPositionChanging(Kind: TSCScrollbarKind; CurPos: Integer;
      var ScrollPos: Integer; var CanScroll: Boolean); dynamic;

    function  GetHorzScrollbarRect: TRect; override;
    function  GetVertScrollbarRect: TRect; override;

    procedure ResetHittest(Ht: PSCScrollbarHittest);
    function  SameHittests(Ht1, Ht2: PSCScrollbarHittest; CheckPos: Boolean = False): Boolean;
    function  GetScrollbarHittest(P: TPoint): TSCScrollbarHittest; dynamic;
    function  GetInheritedNCArea(P: TPoint): LongInt; override;
    function  CanCaptureMouseOnNC(P: TPoint): Boolean; override;

    function  GetDistanceIncrement(Kind: TSCScrollbarKind; Dist: Integer): Integer;
    function  GetPositionAtPos(Kind: TSCScrollbarKind; X, Y: Integer; IncParts: Boolean): Integer;

    function  GetHorzScrollbarHeight: Integer; dynamic;
    function  GetVertScrollbarWidth: Integer; dynamic;

    function  GetBackgroundColor: TColor; virtual;
    function  GetControlScrollbarsClass: TSCControlCustomScrollbarsClass; dynamic;
    function  GetScrollbarClass: TSCCustomControlScrollbarClass; dynamic;

    function  GetScrollbarInfo(Kind: TSCScrollbarKind): TSCScrollInfo;
    procedure SetScrollbarInfo(Kind: TSCScrollbarKind; Info: TSCScrollInfo);

    procedure NCMouseLeave; override;
    procedure NCMouseEnter(var HitTest: LongInt; X, Y: Integer); override;
    procedure NCMouseDown(Button: TMouseButton; HitTest: LongInt; DblClk: Boolean; X, Y: Integer); override;
    procedure NCMouseMove(HitTest: LongInt; X, Y: Integer); override;
    procedure NCMouseUp(Button: TMouseButton; HitTest: LongInt; X, Y: Integer); override;

    property HotTest: TSCScrollbarHittest read FHotTest;
    property DownTest: TSCScrollbarHittest read FDownTest;
    property Scrollbars: TSCControlCustomScrollbars read FScrollbars write SetScrollbars;
    property ScrollbarExtraButton: Boolean read FScrollbarExtraButton write SetScrollbarExtraButton default False;
    property ScrollbarHeight: Integer read FScrollbarHeight write SetScrollbarHeight default -1;
    property ScrollbarHorz: TSCCustomControlScrollbar read FScrollbarHorz write SetScrollbarHorz;
    property ScrollbarVert: TSCCustomControlScrollbar read FScrollbarVert write SetScrollbarVert;
    property ScrollbarStyle: TSCScrollbarStyle read FScrollbarStyle write SetScrollbarStyle default scssDefault;
    property ScrollbarType: TSCScrollbarType read FScrollbarType write SetScrollbarType default scsbtDefault;
    property ScrollbarThumbLines: TSCScrollThumbline read FScrollbarThumbLines write SetScrollbarThumbLines default sctlNone;
    property ScrollButtonsLayout: TSCScrollButtonLayout read FScrollButtonsLayout write SetScrollButtonsLayout default scsbDefault;
    property OnScroll: TSCScrollEvent read FOnScroll write FOnScroll;
    property OnScrollChangeEvent: TSCScrollChangeEvent read FOnScrollChangeEvent write FOnScrollChangeEvent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TSCGraphicControl = class;

  TSCGraphicBorderProps = class(TPersistent)
  private
    FOwner: TSCGraphicControl;
    FBorder: TSCControlBorder;
    FColor: TColor;
    FExDraw: Boolean;
    FInnerBorder: TSCControlBorder;
    FWidth: TBorderWidth;
    FFlatColor: TColor;
    FFlatInnerColor: TColor;
    procedure SetBorder(Value: TSCControlBorder);
    procedure SetColor(Value: TColor);
    procedure SetExDraw(Value: Boolean);
    procedure SetInnerBorder(Value: TSCControlBorder);
    procedure SetWidth(Value: TBorderWidth);
    procedure SetFlatColor(Value: TColor);
    procedure SetFlatInnerColor(Value: TColor);
    procedure DoChange;
  protected
    function GetOwner: TPersistent; override;

    property Border: TSCControlBorder read FBorder write SetBorder default sccbNone;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property ExDraw: Boolean read FExDraw write SetExDraw default False;
    property FlatColor: TColor read FFlatColor write SetFlatColor default clBtnShadow;
    property FlatInnerColor: TColor read FFlatInnerColor write SetFlatInnerColor default clBtnShadow;
    property InnerBorder: TSCControlBorder read FInnerBorder write SetInnerBorder default sccbNone;
    property Width: TBorderWidth read FWidth write SetWidth default 0;
  public
    constructor Create(AOwner: TSCGraphicControl); virtual;
    procedure Assign(Source: TPersistent); override;

    property Owner: TSCGraphicControl read FOwner;
  end;

  TSCGraphicBorderPropsClass = class of TSCGraphicBorderProps;

  TSCGraphicControlActionLink = class(TControlActionLink)
  protected
    FClient: TSCGraphicControl;
    procedure AssignClient(AClient: TObject); override;
    function  IsCaptionLinked: Boolean; override;
    function  IsEnabledLinked: Boolean; override;
    function  IsHintLinked: Boolean; override;
    function  IsImageIndexLinked: Boolean; override;
    function  IsShortCutLinked: Boolean; override;
    function  IsVisibleLinked: Boolean; override;
    function  IsOnExecuteLinked: Boolean; override;
    procedure SetCaption(const Value: string); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetHint(const Value: string); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetShortCut(Value: TShortCut); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
  end;

  TSCGraphicControl = class(TControl)
  private
    FCanvas: TCanvas;
    FBorderProps: TSCGraphicBorderProps;
    FDoubleBuffered: Boolean;
    FTransparent: Boolean;
    FInChange: Integer;
    FAutoSize: Boolean;
    FIndent: Integer;
    FImageIndex: TImageIndex;
    FImages: TCustomImageList;
    FImageLayout: TSCImageLayout;
    FImageChangeLink: TChangeLink;
    FPictureIndex: Integer;
    FPictureList: TSCPictureList;
    FPictureNotifier: TSCPictureNotifier;
    FSpacing: Integer;
    FUpdateCount: Integer;
    FMouseInControl: Boolean;
    FMouseIsDown: Boolean;
    FMouseDownPoint: TPoint;
    FCreatingControl: Boolean;
    FOnChange: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    function  GetAbout: TSCAboutString;
    procedure SetAbout(const Value: TSCAboutString);
    procedure SetBorderProps(Value: TSCGraphicBorderProps);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetImageLayout(const Value: TSCImageLayout);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetPictureIndex(Value: Integer);
    procedure SetPictureList(const Value: TSCPictureList);

    procedure DrawBorder;
    procedure DoBorderChanged;
    procedure ProcessPaint(DC: HDC);
    procedure PictureListChanged(Sender: TSCPictureList; Action: TSCPictureChangeAction);

    procedure TranslateMouseDown(var Message: TWMMouse; Button: TMouseButton; Shift: TShiftState);
    procedure TranslateMouseMove(var Message: TWMMouse);
    procedure TranslateMouseUp(var Message: TWMMouse; Button: TMouseButton);

    procedure CMChanged(var Message: TMessage); message CM_CHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMParentColorChanged(var Message: TWMNoParams); message CM_PARENTCOLORCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;

    procedure WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure WMSettingChange(var Message: TWMSettingChange); message WM_SETTINGCHANGE;
    procedure WMPrint(var Message: TMessage); message WM_PRINT;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;

    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMMButtonDown(var Message: TWMMButtonDown); message WM_MBUTTONDOWN;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMMButtonUp(var Message: TWMMButtonUp); message WM_MBUTTONUP;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMRButtonDblClk(var Message: TWMRButtonDblClk); message WM_RBUTTONDBLCLK;
    procedure WMMButtonDblClk(var Message: TWMMButtonDblClk); message WM_MBUTTONDBLCLK;
  protected
    procedure Loaded; override;
    procedure Change;

    function  IsLocked: Boolean; virtual;
    function  IsLoading: Boolean;
    function  IsDestroying: Boolean;
    function  IsDesigning: Boolean;
    function  IsUpdating: Boolean;

    function  GetClientRect: TRect; override;

    procedure BeforePaint; virtual;
    procedure Paint; virtual;
    procedure AfterPaint; virtual;

    function  IsTransparent: Boolean; virtual;
    procedure PaintParentOn(DC: HDC);

    function  GetDefaultBackColor: TColor; virtual;
    function  GetDefaultForeColor: TColor; virtual;

    function  GetImages: TCustomImageList; virtual;
    function  GetImageIndex: TImageIndex; virtual;

    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;

    procedure AutoSizeChanged; dynamic;
    procedure DoAutoSize(Value: Boolean);
    procedure SetAutoSize(Value: Boolean); {$IFDEF SC_DELPHI6_UP} override; {$ELSE} virtual; {$ENDIF}
    procedure AdjustBounds; dynamic;
    function  GetAdjustedRect(NewWidth, NewHeight: Integer): TRect; virtual;
    procedure AdjustClientRect(var Rect: TRect); virtual;

    procedure DoChange; dynamic;
    procedure EnabledChanged; dynamic;
    procedure BorderChanged; virtual;
    procedure StopTracking; virtual;
    procedure MouseInControlChanged; virtual;
    procedure SystemColorsChanged; dynamic;
    procedure DoPictureListChanged; dynamic;

    procedure UpdateTracking;

    function  CanGetClientRect: Boolean; virtual;
    function  GetBorderPropsClass: TSCGraphicBorderPropsClass; dynamic;

    function  GetBorderSize: Integer; virtual;
    function  GetInnerBorderSize: Integer; virtual;
    function  GetBorderExColor: TColor; dynamic;
    procedure CalculateBorder(var R: TRect); virtual;

    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;

    function  CanSetBorder(Value: TSCControlBorder): Boolean; dynamic;
    function  CanSetInnerBorder(Value: TSCControlBorder): Boolean; dynamic;

    function  GetTransparent: Boolean; virtual;
    procedure SetTransparent(Value: Boolean); virtual;

    procedure SetIndent(Value: Integer); virtual;
    procedure IndentChanged; dynamic;

    procedure SetSpacing(Value: Integer); virtual;
    procedure SpacingChanged; dynamic;

    procedure ImageListChange(Sender: TObject); dynamic;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    function  GetActionLinkClass: TControlActionLinkClass; override;

    function  GetIndent: Integer; virtual;
    function  GetImageRect: TRect; virtual;
    function  GetTextRect: TRect; virtual;
    function  GetTextCalculateFont: TFont; virtual;
    function  GetTextHeight: Integer; virtual;
    function  CalculateImageRect: TRect; virtual;
    function  CalculateTextRect: TRect; virtual;
    procedure UpdateLocked; dynamic;
    procedure UpdateUnlocked; dynamic;

    function IsActive: Boolean; virtual;
    function IsInClientRect(X, Y: Integer): Boolean; virtual;

    property Canvas: TCanvas read FCanvas;
    {$IFDEF SC_DELPHI6_UP}
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    {$ELSE}
    property AutoSize default False;
    {$ENDIF}
    property DoubleBuffered: Boolean read FDoubleBuffered write FDoubleBuffered;
    property BorderProps: TSCGraphicBorderProps read FBorderProps write SetBorderProps;
    property Caption;
    property Color nodefault;
    property Font;
    property MouseInControl: Boolean read FMouseInControl write FMouseInControl;
    property MouseIsDown: Boolean read FMouseIsDown write FMouseIsDown;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property ImageLayout: TSCImageLayout read FImageLayout write SetImageLayout default scilLeft;
    property Images: TCustomImageList read FImages write SetImages;
    property Indent: Integer read FIndent write SetIndent default 0;
    property MouseDownPoint: TPoint read FMouseDownPoint write FMouseDownPoint;
    property PictureIndex: Integer read FPictureIndex write SetPictureIndex default -1;
    property PictureList: TSCPictureList read FPictureList write SetPictureList;
    property Spacing: Integer read FSpacing write SetSpacing default 4;
    property Transparent: Boolean read GetTransparent write SetTransparent default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  public
    constructor Create(AOwner: TComponent); override;
    procedure  AfterConstruction; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function  IsValidImage(Indx: Integer): Boolean; virtual;
    procedure BeginUpdate;
    procedure EndUpdate;
    function  InUpdate: Boolean;
  published
    property About: TSCAboutString read GetAbout write SetAbout stored False;
  end;

var
  DbCnt: Integer = 0;

implementation

type
  TSCFakeControl = class(TControl);
  TSCParentControl = class(TWinControl);

const
  SC_SCRLBAR_SCROLLTIMERID = 13210;

{ TSCControlActionLink }

procedure TSCControlActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  FClient := AClient as TSCCustomControl;
end;

function TSCControlActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and
    AnsiSameText(FClient.Caption, (Action as TCustomAction).Caption);
end;

function TSCControlActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and
    (FClient.Enabled = (Action as TCustomAction).Enabled);
end;

function TSCControlActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and
    (FClient.Hint = (Action as TCustomAction).Hint);
end;

function TSCControlActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and
    (FClient.ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TSCControlActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and
    (@FClient.OnClick = @Action.OnExecute);
end;

function TSCControlActionLink.IsShortCutLinked: Boolean;
begin
  Result := False;
end;

function TSCControlActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and
    (FClient.Visible = (Action as TCustomAction).Visible);
end;

procedure TSCControlActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then FClient.Caption := Value;
end;

procedure TSCControlActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then FClient.Enabled := Value;
end;

procedure TSCControlActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then FClient.Hint := Value;
end;

procedure TSCControlActionLink.SetImageIndex(Value: Integer);
begin
  if IsImageIndexLinked then FClient.ImageIndex := Value;
end;

procedure TSCControlActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then FClient.OnClick := Value;
end;

procedure TSCControlActionLink.SetShortCut(Value: TShortCut);
begin
  inherited;
end;

procedure TSCControlActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then FClient.Visible := Value;
end;

{ TSCNotifier }

procedure TSCNotifier.Notification(Sender: TObject; AComponent: TComponent;
  Operation: TOperation);
begin
  if Assigned(FOnNotification) then
    FOnNotification(Sender, AComponent, Operation);
end;

{ TSCCustomPictureProps }

procedure TSCCustomPictureProps.Assign(Source: TPersistent);
begin
  if Source is TSCCustomPictureProps then
  begin
    with TSCCustomPictureProps(Source) do
    begin
      Self.Visible := Visible;
      Self.Indent  := Indent;
      Self.PictureList := PictureList;
      Self.PictureIndex := PictureIndex;
      Self.Orient  := Orient;
      Self.TopIndent := TopIndent;
      Self.Transparent := Transparent;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCCustomPictureProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCCustomPictureProps.GetIndent: Integer;
begin
  Result := 0;
  if FOwner <> nil then
    Result := FOwner.PictureIndent;
end;

function TSCCustomPictureProps.GetOrient: TSCPictureOrient;
begin
  Result := scpoTiled;
  if FOwner <> nil then
    Result := FOwner.PictureOrient;
end;

function TSCCustomPictureProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCCustomPictureProps.GetPictureIndex: Integer;
begin
  Result := -1;
  if FOwner <> nil then
    Result := FOwner.PictureIndex;
end;

function TSCCustomPictureProps.GetPictureList: TSCPictureList;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.PictureList;
end;

function TSCCustomPictureProps.GetTopIndent: Integer;
begin
  Result := 0;
  if FOwner <> nil then
    Result := FOwner.PictureTopIndent;
end;

function TSCCustomPictureProps.GetTransparent: Boolean;
begin
  Result := False;
  if FOwner <> nil then
    Result := FOwner.PictureTransparent;
end;

function TSCCustomPictureProps.GetVisible: Boolean;
begin
  Result := True;
  if FOwner <> nil then
    Result := FOwner.ShowPicture;
end;

procedure TSCCustomPictureProps.SetIndent(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.PictureIndent := Value;
end;

procedure TSCCustomPictureProps.SetOrient(Value: TSCPictureOrient);
begin
  if FOwner <> nil then
    FOwner.PictureOrient := Value;
end;

procedure TSCCustomPictureProps.SetPictureIndex(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.PictureIndex := Value;
end;

procedure TSCCustomPictureProps.SetPictureList(Value: TSCPictureList);
begin
  if FOwner <> nil then
    FOwner.PictureList := Value;
end;

procedure TSCCustomPictureProps.SetTopIndent(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.PictureTopIndent := Value;
end;

procedure TSCCustomPictureProps.SetTransparent(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.PictureTransparent := Value;
end;

procedure TSCCustomPictureProps.SetVisible(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.ShowPicture := Value;
end;

{ TSCCustomControl }

procedure TSCCustomControl.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
      if not CheckDefaults or (Self.ImageIndex = -1) then
        Self.ImageIndex := ImageIndex;
end;

procedure TSCCustomControl.AdjustBounds;
begin
  //
end;

procedure TSCCustomControl.BeginUpdate;
begin
  Inc(FUpdateCount);
  if FUpdateCount = 1 then
    UpdateLocked;

  DoBeginUpdate;
end;

procedure TSCCustomControl.CalculateBorder(var R: TRect);
var
  B: Integer;
begin
  B := GetBorderSize + GetInnerBorderSize;
  InflateRect(R, -B, -B);
end;

function TSCCustomControl.CalculateImageRect: TRect;
var
  ARect: TRect;
begin
  Result := GetImageRect;
  if FImages = nil then
    Exit;

  OffsetRect(Result, (ClientWidth - Images.Width) div 2,
    (ClientHeight - Images.Height) div 2);

  ARect := GetTextRect;
  if (ARect.Right <= ARect.Left) or
    (ARect.Bottom <= ARect.Top) then Exit;

  case ImageLayout of
    scilBottom:
      OffsetRect(Result, 0, (((ARect.Bottom - ARect.Top) + 2) div 2));
    scilLeft:
      OffsetRect(Result, -(((ARect.Right - ARect.Left) + 2) div 2) - GetIndent, 0);
    scilRight:
      OffsetRect(Result, (((ARect.Right - ARect.Left) + 2) div 2) + GetIndent, 0);
    scilTop:
      OffsetRect(Result, 0, -(((ARect.Bottom - ARect.Top) + 2) div 2));
  end;
end;

function TSCCustomControl.CalculateTextRect: TRect;
var
  ARect: TRect;
  TW, TH: Integer;
begin
  Result := GetTextRect;

  TW := Result.Right - Result.Left;
  TH := Result.Bottom - Result.Top;
  OffsetRect(Result, (ClientWidth - TW) div 2,
    (ClientHeight - TH) div 2);

  if (Images = nil) or (ImageIndex = -1) or
    ((Images <> nil) and (ImageIndex > Images.Count-1)) then Exit;

  ARect := GetImageRect;
  if (ARect.Right <= ARect.Left) or
    (ARect.Bottom <= ARect.Top) then Exit;

  case ImageLayout of
    scilBottom:
      OffsetRect(Result, 0, -(((ARect.Bottom - ARect.Top) + 2) div 2));
    scilLeft:
      OffsetRect(Result, (((ARect.Right - ARect.Left) + 2) div 2) + GetIndent, 0);
    scilRight:
      OffsetRect(Result, -(((ARect.Right - ARect.Left) + 2) div 2) - GetIndent, 0);
    scilTop:
      OffsetRect(Result, 0, (((ARect.Bottom - ARect.Top) + 2) div 2));
  end;
end;

function TSCCustomControl.CanGetClientRect: Boolean;
begin
  Result := (Self <> nil) and (HandleAllocated or (Parent <> nil));
end;

function TSCCustomControl.CanGetFocus: Boolean;
begin
  Result := not IsDesigning and Self.Enabled;
end;

procedure TSCCustomControl.CaptureChanged(Captured: Boolean);
begin
  //
end;

procedure TSCCustomControl.Change;
begin
  Inc(FInChange);
  try
    Changed;
  finally
    Dec(FInChange);
  end;

  DoChange;
  if Assigned(FOnChange) and not IsLoading then
    FOnChange(Self);
end;

procedure TSCCustomControl.CMChanged(var Message: TMessage);
begin
  inherited;
  if FInChange = 0 then
    Change;
end;

procedure TSCCustomControl.CMColorChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TSCCustomControl.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
  EnabledChanged;

  FMouseIsDown := False;
  FMouseDownPoint := Point(-1, -1);
  FMouseInControl := False;

  if Enabled and not IsDesigning then
    UpdateTracking;

  MouseInControlChanged;
end;

procedure TSCCustomControl.CMFocusChanged(var Message: TCMFocusChanged);
begin
  FActive := Message.Sender = Self;
  if FBorderFocusColor <> clNone then
    RedrawBorder(0);
    
  StopTracking;
  inherited;
end;

procedure TSCCustomControl.CMFontChanged(var Message: TMessage);
begin
  inherited;
  AdjustBounds;
  Invalidate;
end;

procedure TSCCustomControl.CMMouseEnter(var Message: TMessage);
begin
  if Enabled and not IsDesigning then
  begin
    FMouseInControl := True;
    inherited;
    MouseInControlChanged;

    if Assigned(FOnMouseEnter) then
      FOnMouseEnter(Self);
  end else
    inherited;
end;

procedure TSCCustomControl.CMMouseLeave(var Message: TMessage);
begin
  if Enabled and not IsDesigning then
  begin
    FMouseInControl := False;
    inherited;
    MouseInControlChanged;

    NCMouseLeave;

    if Assigned(FOnMouseLeave) then
      FOnMouseLeave(Self);
  end else
    inherited;  
end;

procedure TSCCustomControl.CMParentColorChanged(var Message: TWMNoParams);
begin
  inherited;
  Invalidate;
end;

procedure TSCCustomControl.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  SystemColorsChanged;
  Invalidate;
end;

procedure TSCCustomControl.CMTextChanged(var Message: TMessage);
begin
  inherited;
  AdjustBounds;
  Invalidate;
end;

constructor TSCCustomControl.Create(AOwner: TComponent);
begin
  FNotificationList := nil;
  FHotNCArea := SC_HTNONE;

  FCreatingControl := True;
  FImageIndex := -1;
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csCaptureMouse, csClickEvents, csDoubleClicks,
    csOpaque, csReplicatable];

  FAutoSize   := False;
  {$IFDEF SC_DELPHI6_UP}
  AutoSize    := False;
  {$ENDIF}

  FBorder      := sccbNone;
  FBorderColor := clBtnFace;
  FBorderInner := sccbNone;
  FBlendColor  := False;
  FClickFocus  := True;
  FFlatColor   := clBtnShadow;
  FBorderFocusColor := clNone;
  FFlatInnerColor := clBtnShadow;
  FMouseDownPoint := Point(-1, -1);
  FImageLayout := scilLeft;
  FSpacing     := 4;

  FBorderProps := GetBorderPropsClass.Create(Self);

  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;

  FPictureIndex := -1;
  FPictureNotifier := TSCPictureNotifier.Create;
  FPictureNotifier.OnChange := PictureListChanged;

  FShowPicture := True;
  FPictureOrient := scpoTiled;

  FPictureProps := GetPicturePropsClass.Create(Self);

  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;

  AdjustBounds;
end;

function TSCCustomControl.CurrentBlendedColor(AColor: TColor): TColor;
begin
  Result := AColor;
  if FBlendColor then
    Result := DefaultBlendedColor(AColor);
end;

function TSCCustomControl.DefaultBlendedColor(AColor: TColor): TColor;
begin
  Result := BlendedColor(AColor, GetBlendValue, GetBlendValue,
    GetBlendValue, True);
end;

destructor TSCCustomControl.Destroy;
begin
  FPicture.OnChange := nil;
  FreeAndNil(FPicture);

  FPictureNotifier.OnChange := nil;
  if FPictureList <> nil then
    FPictureList.UnregisterNotifier(FPictureNotifier);

  FreeAndNil(FPictureNotifier);
  FreeAndNil(FPictureProps);

  NotifyAll(Self, opRemove);
  FreeAndNil(FNotificationList);

  FreeAndNil(FImageChangeLink);
  FreeAndNil(FBorderProps);
  inherited Destroy;
end;

procedure TSCCustomControl.DoAutoSize(Value: Boolean);
begin
  if (FAutoSize <> Value) or (inherited AutoSize <> Value) then
  begin
    FAutoSize := Value;

    AutoSizeChanged;

    {$IFDEF SC_DELPHI6_UP}
    inherited SetAutoSize(Value);
    {$ELSE}
    inherited AutoSize := Value;
    {$ENDIF}
    AdjustBounds;
  end;
end;

procedure TSCCustomControl.DoBorderChanged;
begin
  // RecreateWnd;
  Perform(CM_BORDERCHANGED, 0, 0);
  {if HandleAllocated then SetWindowPos(Handle, 0, 0,0,0,0, SWP_NOACTIVATE or
    SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE or SWP_FRAMECHANGED);}

  if HandleAllocated then
  begin
    RedrawScrollbars;
    RedrawBorder(0);
  end;

  BorderChanged;
end;

procedure TSCCustomControl.DoChange;
begin
  //
end;

procedure TSCCustomControl.DoMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not Enabled then
    Exit;

  if FClickFocus then
    CaptureFocus(True);

  if (Button = mbLeft) and IsActive and IsInClientRect(X, Y) and
    ((ssLeft in Shift) or (ssDouble in Shift)) then
  begin
    SetCapture(Handle);

    FMouseIsDown := True;
    FMouseDownPoint := Point(X, Y);
  end;
end;

procedure TSCCustomControl.DoMouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if not (FMouseIsDown or FMouseInControl) then
    UpdateTracking;
end;

procedure TSCCustomControl.DoMouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseIsDown := False;
  FMouseDownPoint := Point(-1, -1);
end;

procedure TSCCustomControl.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      UpdateUnlocked;

    DoEndUpdate;
  end;
end;

function TSCCustomControl.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TSCControlActionLink;
end;

function TSCCustomControl.GetBlendValue: Word;
begin
  Result := 0;
  if FBlendColor then Result := 35;
end;

function TSCCustomControl.GetBorderExColor: TColor;
begin
  Result := Self.Color;
end;

function TSCCustomControl.GetBorderSize: Integer;
begin
  Result := 0;
  if FBorder in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
    Result := 1
  else if FBorder in [sccbFlatBold, sccbFlatRounded, sccbFlatBoldRounded,
    sccb3DRaised, sccb3DLowered, sccbBumped, sccbEtched, sccbMacLowered,
    sccbMacRaised, sccbMetal, sccbSoftLowered, sccbSoftRaised] then
    Result := 2;
end;

function TSCCustomControl.GetFaceColor: TColor;
var
  B: Integer;
begin
  Result := Self.Color;
  if Result = clNone then Result := clBtnFace;

  if FBlendColor then
  begin
    B := GetBlendValue;
    Result := BlendedColor(Self.Color, B, B, B, True);
  end;
end;

function TSCCustomControl.GetImageRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if FImages <> nil then
    Result := Rect(0, 0, Images.Width, Images.Height);
end;

function TSCCustomControl.GetIndent: Integer;
begin
  Result := 0;
  if (ImageLayout in [scilLeft, scilRight]) and 
    IsValidImage(FImageIndex) and (Caption <> '') then
    Result := FIndent;
end;

function TSCCustomControl.GetInnerBorderSize: Integer;
begin
  Result := 0;
  if FBorderInner in [sccbRaised, sccbLowered, sccbFlat, sccbColor] then
    Result := 1
  else if FBorderInner in [sccbFlatBold, sccbFlatRounded, sccbFlatBoldRounded,
    sccb3DRaised, sccb3DLowered, sccbBumped, sccbEtched, sccbMacLowered,
    sccbMacRaised, sccbMetal, sccbSoftLowered, sccbSoftRaised] then
    Result := 2;
end;

function TSCCustomControl.GetTextRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if Caption <> '' then
  begin
    Canvas.Font.Assign(Self.Font);
    Result := Rect(0, 0, ClientWidth, 0);
    DrawText(Canvas.Handle, PChar(Caption), Length(Caption),
      Result, DT_CALCRECT);
  end;
end;

procedure TSCCustomControl.ImageListChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TSCCustomControl.IndentChanged;
begin
  Invalidate;
end;

function TSCCustomControl.GetInUpdate: Boolean;
begin
  Result := FUpdateCount > 0;
end;

function TSCCustomControl.IsActive: Boolean;
begin
  Result := True;
end;

function TSCCustomControl.IsActiveParent: Boolean;
var
  C: TControl;
  P: TWinControl;
begin
  Result := HasFocus;
  if not Result then
  begin
    C := Screen.ActiveControl;
    while C <> nil do
    begin
      P := C.Parent;

      if P = Self then
      begin
        Result := True;
        Break;
      end;

      C := P;
    end;
  end;
end;

function TSCCustomControl.IsInClientRect(X, Y: Integer): Boolean;
begin
  Result := True;
end;

function TSCCustomControl.IsValidImage(Indx: Integer): Boolean;
begin
  Result := (Indx > -1) and (Images <> nil) and
    (Images.Count > 0) and (Indx < Images.Count);
end;

procedure TSCCustomControl.Loaded;
begin
  inherited Loaded;
  if FStyleController <> nil then
    NotifyStyleChange;

  AdjustBounds;
end;

procedure TSCCustomControl.MouseInControlChanged;
begin
  //
end;

procedure TSCCustomControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = Images) then
    Images := nil;
end;

procedure TSCCustomControl.DoFillScrollBarsCorner(OnDC: HDC);
var
  DC: HDC;
  R, RW, RC: TRect;
begin
  if HandleAllocated and ((GetWindowLong(Handle, GWL_STYLE) and
    (WS_HSCROLL or WS_VSCROLL)) = (WS_HSCROLL or WS_VSCROLL)) then
  begin
    DC := OnDC;
    if OnDc = 0 then
      DC := GetWindowDC(Handle);

    try
      GetWindowRect(Handle, RW);
      R := RW;

      MapWindowPoints(0, Handle, RW, 2);

      OffsetRect(R, -R.Left, -R.Top);
      InflateRect(R, RW.Left, RW.Top);

      Windows.GetClientRect(Handle, RC);
      OffsetRect(RC, -RW.Left, -RW.Top);
      ExcludeClipRect(DC, RC.Left, RC.Top, RC.Right, RC.Bottom);

      R.Top := RC.Bottom;
      R.Bottom := R.Top + scHorzScrollbarHeight;
      
      if UseRightToLeftScrollBar then  // vertical scrollbar is on left
      begin
        R.Right := RC.Left;
        R.Left  := R.Right - scVertScrollbarWidth
      end else
      begin
        R.Left  := RC.Right;
        R.Right := R.Left + scVertScrollbarWidth;
      end;

      if not IsRectEmpty(R) then
        FillRect(DC, R, GetSysColorBrush(COLOR_BTNFACE));
    finally
      if OnDC = 0 then
        ReleaseDC(Handle, DC);
    end;
  end;
end;

procedure TSCCustomControl.RedrawBorder(const Clip: HRGN; OnDC: HDC);
var
  DC: HDC;
  R, BRect: TRect;
  OldDCPen: HPen;
  FramePen: TPen;
  C1, Cl: TColor;
  Bs, Offset: Integer;
  Points: array[0..4] of TPoint;
begin
  if not HandleAllocated or IsIconic(Handle) or IsDestroying then
    Exit;

  DC := OnDC;
  if OnDC = 0 then
    DC := GetWindowDC(Handle);

  Cl := BorderColor;
  if Cl = clNone then
  begin
    Cl := Self.Color;
    if Cl = clNone then Cl := clWindow;
  end;  

  if BlendColor then
    Cl := DefaultBlendedColor(Cl);

  FramePen := TPen.Create;
  with FramePen do
  begin
    Style := psInsideFrame;
    Color := Cl;
  end;

  OldDCPen := 0;
  try
    Offset := BorderWidth div 2;

    GetWindowRect(Handle, R);
    OffsetRect(R, -R.Left, -R.Top);

    BRect := R;
    InflateRect(R, -Offset, -Offset);

    if Odd(BorderWidth) then
    begin
      Dec(R.Right);
      if R.Right < R.Left then
        R.Right := R.Left;

      Dec(R.Bottom);
      if R.Bottom < R.Top then
        R.Bottom := R.Top;
    end;

    if BorderWidth > 0 then
      FramePen.Width := BorderWidth;

    OldDCPen := SelectObject(DC, FramePen.Handle);
    SetROP2(DC, SCPenModes[FramePen.Mode]);

    Bs := GetBorderSize;

    if BorderWidth > 0 then
    begin
      InflateRect(R, -Bs, -Bs);

      Points[0] := Point(R.Left, R.Top);
      Points[1] := Point(R.Right, R.Top);
      Points[2] := Point(R.Right, R.Bottom);
      Points[3] := Point(R.Left, R.Bottom);
      Points[4] := Point(R.Left, R.Top);

      Windows.MoveToEx(DC, Points[0].X - Offset, Points[0].Y, nil);
      Windows.LineTo(DC, Points[1].X + Offset, Points[1].Y);

      Windows.MoveToEx(DC, Points[1].X, Points[1].Y - Offset, nil);
      Windows.LineTo(DC, Points[2].X, Points[2].Y + Offset);

      Windows.MoveToEx(DC, Points[2].X + Offset, Points[2].Y, nil);
      Windows.LineTo(DC, Points[3].X - Offset, Points[3].Y);

      Windows.MoveToEx(DC, Points[3].X, Points[3].Y + Offset, nil);
      Windows.LineTo(DC, Points[4].X, Points[4].Y - Offset);
    end;

    R := BRect;
    if not IsRectEmpty(R) and (FBorder <> sccbNone) then
    begin
      if FBorderEx then
      begin
        C1 := GetBorderExColor;
        if C1 = clNone then C1 := Self.Color;
        if C1 = clNone then C1 := clWindow;

        if FBorder in [sccbFlat, sccbFlatBold] then
          C1 := GetBtnShadowOf(C1);

        scDrawBevelEx(DC, R, C1, TSCFakeControl(Parent).Color, True, FBorder);
      end else
      begin
        C1 := FFlatColor;
        if (FBorderFocusColor <> clNone) and (HasFocus or IsActiveParent) then
          C1 := FBorderFocusColor;

        if C1 = clNone then C1 := Self.Color;
        if C1 = clNone then C1 := clWindow;

        scDrawEdgeEx(DC, R, C1, TSCFakeControl(Parent).Color, True, FBorder);
      end;

      InflateRect(BRect, -Bs, -Bs);
    end;

    R := BRect;
    InflateRect(R, -BorderWidth, -BorderWidth);

    if not IsRectEmpty(BRect) and (FBorderInner <> sccbNone) then
    begin
      if FBorderEx then
      begin
        C1 := GetBorderExColor;
        if C1 = clNone then C1 := Self.Color;
        if C1 = clNone then C1 := clWindow;

        if FBorder in [sccbFlat, sccbFlatBold] then
          C1 := GetBtnShadowOf(C1);

        scDrawBevelEx(DC, R, C1, TSCFakeControl(Parent).Color, False, FBorderInner);
      end else
      begin
        C1 := FFlatInnerColor;
        if C1 = clNone then C1 := Self.Color;
        if C1 = clNone then C1 := clWindow;

        scDrawEdgeEx(DC, R, C1, TSCFakeControl(Parent).Color, False, FBorderInner);
      end;
    end;
  finally
    if OldDCPen <> 0 then
      SelectObject(DC, OldDCPen);

    if (DC <> 0) and (OnDC = 0) then
      ReleaseDC(Handle, DC);

    FramePen.Free;
  end;
end;

function TSCCustomControl.ScreenToNC(P: TPoint): TPoint;
var
  R: TRect;
begin
  Result := P;

  {if HandleAllocated and GetWindowRect(Self.Handle, R) then
  begin
    OffsetRect(R, -R.Left, -R.Top);
    CalculateBorder(R);

    InflateRect(R, -BorderWidth, -BorderWidth);

    MapWindowPoints(0, Self.Handle, Result, 1);

    Inc(Result.x, R.Left);
    Inc(Result.y, R.Top);
  end;}

  if HandleAllocated and GetWindowRect(Self.Handle, R) then
  begin
    MapWindowPoints(0, Self.Handle, R, 2);
    MapWindowPoints(0, Self.Handle, Result, 1);

    Dec(Result.x, R.Left);
    Dec(Result.y, R.Top);
  end;
end;

procedure TSCCustomControl.SetAutoSize(Value: Boolean);
begin
  DoAutoSize(Value);
end;

procedure TSCCustomControl.SetBlendColor(Value: Boolean);
begin
  if FBlendColor <> Value then
  begin
    FBlendColor := Value;
    Invalidate;
  end;
end;

procedure TSCCustomControl.SetBorder(Value: TSCControlBorder);
begin
  if CanSetBorder(Value) and (FBorder <> Value) then
  begin
    FBorder := Value;
    DoBorderChanged;
  end;
end;

procedure TSCCustomControl.SetBorderColor(Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    RedrawBorder(0);
  end;
end;

procedure TSCCustomControl.SetBorderEx(Value: Boolean);
begin
  if FBorderEx <> Value then
  begin
    FBorderEx := Value;
    if FBorder <> sccbNone then
      DoBorderChanged;
  end;
end;

procedure TSCCustomControl.SetBorderFocusColor(Value: TColor);
begin
  if FBorderFocusColor <> Value then
  begin
    FBorderFocusColor := Value;
    if FBorder <> sccbNone then
      RedrawBorder(0);
  end;
end;

procedure TSCCustomControl.SetBorderInner(Value: TSCControlBorder);
begin
  if CanSetInnerBorder(Value) and (FBorderInner <> Value) then
  begin
    FBorderInner := Value;
    DoBorderChanged;
  end;
end;

procedure TSCCustomControl.SetFlatColor(Value: TColor);
begin
  if FFlatColor <> Value then
  begin
    FFlatColor := Value;
    if FBorder <> sccbNone then
      RedrawBorder(0);
  end;
end;

procedure TSCCustomControl.SetFlatInnerColor(Value: TColor);
begin
  if FFlatInnerColor <> Value then
  begin
    FFlatInnerColor := Value;
    if FBorderInner <> sccbNone then
      RedrawBorder(0);
  end;
end;

procedure TSCCustomControl.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if FImages <> nil then
      Invalidate;
  end;
end;

procedure TSCCustomControl.SetImageLayout(Value: TSCImageLayout);
begin
  if FImageLayout <> Value then
  begin
    FImageLayout := Value;
    if FImages <> nil then
      Invalidate;
  end;
end;

procedure TSCCustomControl.SetImages(Value: TCustomImageList);
var
  OldImages: TCustomImageList;
begin
  OldImages := FImages;
  
  if FImages <> nil then
  begin
  {$IFDEF SC_DELPHI5_UP}
    FImages.RemoveFreeNotification(Self);
  {$ENDIF}
    FImages.UnRegisterChanges(FImageChangeLink);
  end;

  FImages := Value;
  if FImages <> nil then
  begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(Self);
  end;

  if OldImages <> FImages then
  begin
    Invalidate;
    ImageListChange(FImages);
  end;
end;

procedure TSCCustomControl.SetIndent(Value: Integer);
begin
  if FIndent <> Value then
  begin
    FIndent := Value;

    AdjustBounds;
    IndentChanged;
  end;
end;

procedure TSCCustomControl.SetSpacing(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FSpacing <> Value then
  begin
    FSpacing := Value;

    AdjustBounds;
    SpacingChanged;
  end;
end;

procedure TSCCustomControl.SpacingChanged;
begin
  Invalidate;
end;

procedure TSCCustomControl.StopTracking;
var
  WasDown, WasInside: Boolean;
  AForm: TCustomForm;
  P: TPoint;
  R: TRect;
begin
  if not HandleAllocated then
    Exit;

  WasDown := FMouseIsDown;
  WasInside := FMouseInControl;

  if GetCapture = Handle then
  begin
    ReleaseCapture;

    FMouseIsDown := False;
    FMouseDownPoint := Point(-1, -1);
  end;

  AForm := GetParentForm(Self);
  GetCursorPos(P);
  P := ScreenToNC(P);
  GetWindowRect(Handle, R);
  OffsetRect(R, -R.Left, -R.Top);

  FMouseInControl := (Screen.ActiveCustomForm = AForm) and PtInRect(R, P);

  if (WasDown <> FMouseIsDown) or (WasInside <> FMouseInControl) then
    Invalidate;
end;

procedure TSCCustomControl.TranslateMouseDown(var Message: TWMMouse;
  Button: TMouseButton; Shift: TShiftState);
begin
  if not (csNoStdEvents in ControlStyle) then
    with Message do
      DoMouseDown(Button, KeysToShiftState(Keys) + Shift, XPos, YPos);
end;

procedure TSCCustomControl.TranslateMouseMove(var Message: TWMMouse);
begin
  if not (csNoStdEvents in ControlStyle) then
    with Message do
      DoMouseMove(KeysToShiftState(Keys), XPos, YPos);
end;

procedure TSCCustomControl.TranslateMouseUp(var Message: TWMMouse;
  Button: TMouseButton);
begin
  if not (csNoStdEvents in ControlStyle) then
    with Message do
      DoMouseUp(Button, KeysToShiftState(Keys), XPos, YPos);
end;

procedure TSCCustomControl.UpdateLocked;
begin
  //
end;

procedure TSCCustomControl.UpdateTracking;
var
  P: TPoint;
begin
  FMouseInControl := False;
  if Enabled and not IsDesigning then
  begin
    GetCursorPos(P);
    FMouseInControl := not (FindDragTarget(P, True) = Self);
    
    if FMouseInControl then
      Perform(CM_MOUSELEAVE, 0, 0)
    else
      Perform(CM_MOUSEENTER, 0, 0);
  end;
end;

procedure TSCCustomControl.UpdateUnlocked;
begin
  //
end;

procedure TSCCustomControl.WMCancelMode(var Message: TMessage);
begin
  StopTracking;
  inherited;
end;

procedure TSCCustomControl.WMCaptureChanged(var Message: TMessage);
begin
  inherited;
  if not IsDesigning then
    CaptureChanged(HandleAllocated and (HWND(Message.LParam) = Self.Handle));
end;

procedure TSCCustomControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
var
  SaveIndex: Integer;
begin
  Message.Result := 0;
  if HandleAllocated and (Message.DC <> 0) and (csPaintCopy in ControlState) then
  begin
    SaveIndex := SaveDC(Message.DC);
    try
      DoFillScrollBarsCorner(Message.DC);
      RedrawScrollbars(scsdkAll, Message.DC);
      RedrawBorder(0, Message.DC);
    finally
      RestoreDC(Message.DC, SaveIndex);
    end;
  end;
end;

procedure TSCCustomControl.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  // Message.Result := DLGC_WANTARROWS;
end;

procedure TSCCustomControl.WMKillFocus(var Message: TWMKillFocus);
var
  P: TPoint;
  InCtrl: Boolean;
begin
  FHasFocus := False;
  if FBorderFocusColor <> clNone then
    RedrawBorder(0);

  StopTracking;

  FMouseIsDown := False;
  FMouseDownPoint := Point(-1, -1);

  GetCursorPos(P);
  P := Self.ScreenToClient(P);

  InCtrl := FMouseInControl;
  FMouseInControl := Enabled and not IsDesigning and
    (FindDragTarget(P, True) = Self);

  if Enabled and not IsDesigning and (InCtrl <> FMouseInControl) then
  begin
    if not FMouseInControl then
      Perform(CM_MOUSELEAVE, 0, 0)
    else Perform(CM_MOUSEENTER, 0, 0);
  end;

  Invalidate;
  inherited;
  
  DoFocusChanged;
end;

procedure TSCCustomControl.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if not IsDesigning then
  begin
    SendCancelMode(Self);
    TranslateMouseDown(Message, mbLeft, []);
  end;
  inherited;
end;

procedure TSCCustomControl.WMLButtonUp(var Message: TWMLButtonUp);
begin
  if not IsDesigning then
  begin
    if FNCIsDown then
    begin
      FNCIsDown := False;
      DoFakeMouseUp(Message, mbLeft);

      DefaultHandler(Message);
      Exit;
    end;

    TranslateMouseUp(Message, mbLeft);
  end;

  inherited;
end;

procedure TSCCustomControl.WMMButtonDown(var Message: TWMMButtonDown);
begin
  if not IsDesigning then
    TranslateMouseDown(Message, mbMiddle, []);
  inherited;
end;

procedure TSCCustomControl.WMMButtonUp(var Message: TWMMButtonUp);
begin
  if not IsDesigning then
  begin
    if FNCIsDown then
    begin
      FNCIsDown := False;
      DoFakeMouseUp(Message, mbMiddle);

      DefaultHandler(Message);
      Exit;
    end;

    TranslateMouseUp(Message, mbMiddle);
  end;

  inherited;
end;

procedure TSCCustomControl.WMMouseMove(var Message: TWMMouseMove);
begin
  if not IsDesigning then
  begin
    if FNCIsDown then
    begin
      DoFakeMouseMove(Message);
      DefaultHandler(Message);
      Exit;
    end;

    TranslateMouseMove(Message);
  end;

  inherited;
end;

procedure TSCCustomControl.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  inherited;
  with Message.CalcSize_Params^ do
    CalculateBorder(Rgrc[0]);
end;

procedure TSCCustomControl.WMPrint(var Message: TMessage);
var
  DC: HDC;
  SaveIndex: Integer;
begin
  inherited;

  if HandleAllocated then
  begin
    if ((Message.LParam and PRF_CHECKVISIBLE) <> PRF_CHECKVISIBLE) and
      not IsWindowVisible(Handle) then
      Exit;

    DC := HDC(Message.WParam);
    SaveIndex := SaveDC(DC);
    try
      RedrawScrollbars(scsdkAll, DC);
      DoFillScrollBarsCorner(DC);
      RedrawBorder(0, DC);
    finally
      RestoreDC(DC, SaveIndex);
    end;
  end;
end;

procedure TSCCustomControl.WMNCPaint(var Message: TMessage);
begin
  DefaultHandler(Message);
  DoFillScrollBarsCorner;
  RedrawScrollbars;
  RedrawBorder(HRGN(Message.WParam));
end;

procedure TSCCustomControl.WMRButtonDown(var Message: TWMRButtonDown);
begin
  if not IsDesigning then
    TranslateMouseDown(Message, mbRight, []);
  inherited;
end;

procedure TSCCustomControl.WMRButtonUp(var Message: TWMRButtonUp);
{$IFDEF SC_DELPHI4_AND_EARLY}
var
  Handled: Boolean;
{$ENDIF}
begin
  if not IsDesigning then
  begin
    if FNCIsDown then
    begin
      FNCIsDown := False;
      DoFakeMouseUp(Message, mbRight);

      DefaultHandler(Message);
      Exit;
    end;

    TranslateMouseUp(Message, mbRight);

    {$IFDEF SC_DELPHI4_AND_EARLY}
    if (Message.Result = 0) and CanMenuPopup(Message.Pos) and
      Assigned(FOnContextPopup) then
    begin
      Handled := False;
      FOnContextPopup(Self, SmallPointToPoint(Message.Pos), Handled);
    end;
    {$ENDIF}
  end;

  inherited;
end;

procedure TSCCustomControl.WMSetFocus(var Message: TWMSetFocus);
var
  CapC: HWND;
begin
  FHasFocus := Self.Enabled;
  inherited;

  if FBorderFocusColor <> clNone then
    RedrawBorder(0);

  if HandleAllocated and not Focused then
  begin
    CapC := GetCapture;
    if (CapC <> 0) and (CapC <> Self.Handle) then
      SetCapture(Self.Handle);
  end;

  Invalidate;
  DoFocusChanged;
end;

procedure TSCCustomControl.WMSettingChange(var Message: TWMSettingChange);
begin
  inherited;
  Invalidate;
end;

procedure TSCCustomControl.WMWindowPosChanged(var Message: TMessage);
begin
  Invalidate;
  inherited;
end;

procedure TSCCustomControl.PaintParentOn(C: TCanvas);
var
  DC: Cardinal;
  InDesign: Boolean;
  Ctrl: TControl;
  R, R2, CR,
  SelfR, CtlR, ParentR: TRect;
  I, X, Y, Cnt, SaveIndex: Integer;
begin
  if (Parent = nil) or (C = nil) or (C.Handle = 0) then
    Exit;

  ParentR := Parent.ClientRect;
  if IsRectEmpty(ParentR) then
    Exit;

  SelfR := GetClientRect;
  with SelfR do
  begin
    TopLeft := Self.ClientToScreen(TopLeft);
    BottomRight := Self.ClientToScreen(BottomRight);

    TopLeft := Parent.ScreenToClient(TopLeft);
    BottomRight := Parent.ScreenToClient(BottomRight);
  end;

  X := -SelfR.Left;
  Y := -SelfR.Top;

  IntersectRect(SelfR, SelfR, ParentR);
  if IsRectEmpty(SelfR) then
    Exit;

  DC := C.Handle;

  // Copy parent control image
  SaveIndex := SaveDC(DC);
  try
    SetViewportOrgEx(DC, X, Y, nil);
    IntersectClipRect(DC, 0, 0, ParentR.Right - ParentR.Left, ParentR.Bottom - ParentR.Top);
    Self.Parent.Perform(WM_ERASEBKGND, WParam(DC), 0);
    TSCParentControl(Self.Parent).PaintWindow(DC);
  finally
    RestoreDC(DC, SaveIndex);
  end;  

  //Copy images of parent controls
  InDesign := IsDesigning;

  Cnt := Parent.ControlCount;
  for I := 0 to Cnt - 1 do begin
    if Parent.Controls[I] <> nil then
    begin
      Ctrl := Parent.Controls[I];
      if Ctrl = Self then
        Break;

      with Ctrl do
      begin
        CtlR := Bounds(Ctrl.Left, Ctrl.Top, Ctrl.Width, Ctrl.Height);

        if Bool(IntersectRect(R, SelfR, CtlR)) and (Visible or InDesign) then
        begin
          CR := ClientRect;
          R2 := CR;

          with R2 do
          begin
            TopLeft := ClientToScreen(TopLeft);
            BottomRight := ClientToScreen(BottomRight);

            TopLeft := Parent.ScreenToClient(TopLeft);
            BottomRight := Parent.ScreenToClient(BottomRight);
          end;

          SaveIndex := SaveDC(DC);
          try
            SetViewportOrgEx(DC, Left + X, Top + Y, nil);
            IntersectClipRect(DC, 0, 0, Width, Height);

            Perform(WM_PRINT, DC, PRF_NONCLIENT or PRF_CLIENT or
              PRF_ERASEBKGND or PRF_CHILDREN);

            SetViewportOrgEx(DC, R2.Left + X, R2.Top + Y, nil);
            IntersectClipRect(DC, CR.Left, CR.Top, CR.Right, CR.Bottom);
            Perform(WM_PAINT, DC, 0);
          finally
            RestoreDC(DC, SaveIndex);
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomControl.SetTransparent(Value: Boolean);
var
  CS: TControlStyle;
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;

    CS := ControlStyle - [csOpaque];
    if not Value then
      CS := CS + [csOpaque];

    ControlStyle := CS;  
    TransparentChanged;
  end;
end;

procedure TSCCustomControl.TransparentChanged;
begin
  Invalidate;
end;

function TSCCustomControl.IsHorzScrollBarVisible: Boolean;
begin
  Result := HandleAllocated and
    (GetWindowLong(Handle, GWL_STYLE) and WS_HSCROLL <> 0);
end;

function TSCCustomControl.IsVertScrollBarVisible: Boolean;
begin
  Result := HandleAllocated and
    (GetWindowLong(Handle, GWL_STYLE) and WS_VSCROLL <> 0);
end;

procedure TSCCustomControl.AfterConstruction;
begin
  FCreatingControl := False;
  inherited AfterConstruction;
end;

procedure TSCCustomControl.Assign(Source: TPersistent);
begin
  if Source is TControl then
  begin
    with TControl(Source) do
    begin
      Self.Align := Align;
      Self.Anchors := Anchors;
      Self.BiDiMode := BiDiMode;
      Self.Caption := Caption;
      Self.Color := Color;
      Self.Constraints := Constraints;
      Self.Cursor := Cursor;
      Self.DockSite := DockSite;
      Self.DragCursor := DragCursor;
      Self.DragKind := DragKind;
      Self.DragMode := DragMode;
      Self.Enabled := Enabled;
      Self.Font := Font;
      Self.Hint := Hint;
      Self.ImeMode := ImeMode;
      Self.ImeName := ImeName;
      Self.ParentBiDiMode := ParentBiDiMode;
      Self.ParentColor := ParentColor;
      Self.ParentFont := ParentFont;
      Self.ShowHint := ShowHint;
      Self.UseDockManager := UseDockManager;
      Self.Visible := Visible;
      Self.TabStop := TabStop;
      Self.Width := Width;
      Self.Height := Height;
    end;

    if Self is TSCCustomControl then
    begin
      with TSCCustomControl(Source) do
      begin
        Self.BorderProps := BorderProps;
        Self.ClickFocus := ClickFocus;
        Self.ImageIndex := ImageIndex;
        Self.ImageLayout := ImageLayout;
        Self.Indent := Indent;
        Self.Picture := Picture;
        Self.PictureOrient := PictureOrient;
        Self.PictureIndent := PictureIndent;
        Self.PictureTopIndent := PictureTopIndent;
        Self.PictureTransparent := PictureTransparent;
        Self.PictureIndex := PictureIndex;
        Self.ShowPicture := ShowPicture;
        Self.Spacing := Spacing;
        Self.Transparent := Transparent;
      end;
    end;
  end else
    inherited Assign(Source);
end;

function TSCCustomControl.GetClientRect: TRect;
var
  B: Integer;
begin
  if not HandleAllocated then
  begin
    Result := Rect(0, 0, Width, Height);

    B := GetBorderSize + BorderWidth + GetInnerBorderSize;
    if B < 0 then B := 0;

    InflateRect(Result, -B, -B);

    if Result.Right < Result.Left then
    begin
      Result.Left := Result.Left - ((Result.Left - Result.Right) div 2);
      Result.Right := Result.Left;
    end;

    if Result.Bottom < Result.Top then
    begin
      Result.Top := Result.Top - ((Result.Top - Result.Bottom) div 2);
      Result.Bottom := Result.Top;
    end;
  end else
    Result := inherited GetClientRect;
end;

procedure TSCCustomControl.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if not IsDesigning then
  begin
    SendCancelMode(Self);
    if csCaptureMouse in ControlStyle then MouseCapture := True;

    if FNCIsDown then
    begin
      FNCIsDown := False;
      DoFakeMouseDown(Message, mbLeft, [ssDouble]);

      DefaultHandler(Message);
      Exit;
    end;

    TranslateMouseDown(Message, mbLeft, [ssDouble]);
  end;

  inherited;
end;

procedure TSCCustomControl.WMMButtonDblClk(var Message: TWMMButtonDblClk);
begin
  if not IsDesigning then
  begin
    if FNCIsDown then
    begin
      FNCIsDown := False;
      DoFakeMouseDown(Message, mbMiddle, [ssDouble]);

      DefaultHandler(Message);
      Exit;
    end;

    TranslateMouseDown(Message, mbMiddle, [ssDouble]);
  end;

  inherited;
end;

procedure TSCCustomControl.WMRButtonDblClk(var Message: TWMRButtonDblClk);
begin
  if not IsDesigning then
  begin
    if FNCIsDown then
    begin
      FNCIsDown := False;
      DoFakeMouseDown(Message, mbRight, [ssDouble]);

      DefaultHandler(Message);
      Exit;
    end;

    TranslateMouseDown(Message, mbRight, [ssDouble]);
  end;

  inherited;
end;

procedure TSCCustomControl.AutoSizeChanged;
begin
  //
end;

procedure TSCCustomControl.EnabledChanged;
begin
  //
end;

function TSCCustomControl.GetAbout: TSCAboutString;
begin
  Result := SC_VersionStr;
end;

procedure TSCCustomControl.SetAbout(Value: TSCAboutString);
begin
  //
end;

procedure TSCCustomControl.RedrawScrollbars(Kind: TSCScrollbarDrawKind;
  OnDC: HDC);
begin
  //
end;

procedure TSCCustomControl.DoNCMouseDown(var Message: TWMNCHitMessage;
  Button: TMouseButton; Shift: TShiftState);
var
  P: TPoint;
begin
  with Message do
  begin
    P := ScreenToNC(Point(XCursor, YCursor));
    NCMouseDown(Button, HitTest, ssDouble in Shift, P.x, P.y);
  end;
end;

procedure TSCCustomControl.DoNCMouseUp(var Message: TWMNCHitMessage;
  Button: TMouseButton);
var
  P: TPoint;
begin
  with Message do
  begin
    P := ScreenToNC(Point(XCursor, YCursor));
    NCMouseUp(Button, HitTest, P.x, P.y);
  end;
end;

procedure TSCCustomControl.WMNCLButtonDblClk(var Message: TWMNCHitMessage);
begin
  if IsDesigning then
    inherited
  else begin
    SendCancelMode(Self);
    inherited;
    FNCIsDown := GetCapture = Self.Handle;
    DoNCMouseDown(Message, mbLeft, [ssDouble]);
  end;
end;

procedure TSCCustomControl.WMNCLButtonDown(var Message: TWMNCHitMessage);
begin
  if not IsDesigning then
  begin
    SendCancelMode(Self);

    if CanCaptureMouseOnNC(Point(Message.XCursor, Message.YCursor)) then
      SetCapture(Handle);

    inherited;
    FNCIsDown := GetCapture = Self.Handle;
    DoNCMouseDown(Message, mbLeft, []);
  end else
    inherited;
end;

procedure TSCCustomControl.WMNCLButtonUp(var Message: TWMNCHitMessage);
begin
  inherited;
  if not IsDesigning then
    DoNCMouseUp(Message, mbLeft);
end;

procedure TSCCustomControl.WMNCMButtonDblClk(var Message: TWMNCHitMessage);
begin
  inherited;
  if not IsDesigning then
  begin
    FNCIsDown := GetCapture = Self.Handle;
    DoNCMouseDown(Message, mbMiddle, [ssDouble]);
  end;  
end;

procedure TSCCustomControl.WMNCMButtonDown(var Message: TWMNCHitMessage);
begin
  inherited;
  if not IsDesigning then
  begin
    FNCIsDown := GetCapture = Self.Handle;
    DoNCMouseDown(Message, mbMiddle, []);
  end;
end;

procedure TSCCustomControl.WMNCMButtonUp(var Message: TWMNCHitMessage);
begin
  inherited;
  if not IsDesigning then
    DoNCMouseUp(Message, mbRight);
end;

procedure TSCCustomControl.WMNCMouseMove(var Message: TWMNCHitMessage);
var
  P: TPoint;
begin
  inherited;
  if not IsDesigning then
    with Message do
    begin
      P := ScreenToNC(Point(XCursor, YCursor));
      NCMouseMove(Message.HitTest, P.x, P.y);
    end;
end;

procedure TSCCustomControl.WMNCRButtonDblClk(var Message: TWMNCHitMessage);
begin
  inherited;
  if not IsDesigning then
  begin
    FNCIsDown := GetCapture = Self.Handle;
    DoNCMouseDown(Message, mbRight, [ssDouble]);
  end;  
end;

procedure TSCCustomControl.WMNCRButtonDown(var Message: TWMNCHitMessage);
begin
  inherited;
  if not IsDesigning then
  begin
    FNCIsDown := GetCapture = Self.Handle;
    DoNCMouseDown(Message, mbRight, []);
  end;  
end;

procedure TSCCustomControl.WMNCRButtonUp(var Message: TWMNCHitMessage);
begin
  inherited;
  if not IsDesigning then
    DoNCMouseUp(Message, mbRight);
end;

procedure TSCCustomControl.NCMouseDown(Button: TMouseButton;
  HitTest: Integer; DblClk: Boolean; X, Y: Integer);
begin
  //
end;

procedure TSCCustomControl.NCMouseMove(HitTest, X, Y: Integer);
begin
  //
end;

procedure TSCCustomControl.NCMouseUp(Button: TMouseButton; HitTest, X,
  Y: Integer);
begin
  //
end;

procedure TSCCustomControl.NCMouseEnter(var HitTest: Integer; X, Y: Integer);
begin
  //
end;

procedure TSCCustomControl.NCMouseLeave;
begin
  //
end;

procedure TSCCustomControl.WMNCHitTest(var Message: TWMNCHitTest);
var
  P: TPoint;
  OldNC: LongInt;
  CapHnd: HWND;
begin
  CapHnd := GetCapture;
  if IsDesigning or ((CapHnd <> 0) and
    not (HandleAllocated and (CapHnd = Self.Handle))) then
    inherited
  else begin
    OldNC := FHotNCArea;
    inherited;

    P := SmallPointToPoint(Message.Pos);
    FHotNCArea := GetNCAreaAtPos(P);

    if OldNC <> FHotNCArea then
    begin
      P := ScreenToNC(P);

      Message.Result := HTBORDER;
      NCMouseEnter(Message.Result, P.x, P.y);
    end;
  end;  
end;

function TSCCustomControl.GetNCAreaAtPos(P: TPoint): LongInt;
var
  B: Integer;
  R, CR: TRect;
begin
  Result := SC_HTNONE;
  if HandleAllocated and Windows.GetWindowRect(Handle, R) and
    Windows.GetClientRect(Handle, CR) then
  begin
    MapWindowPoints(Handle, 0, CR, 2);

    if PtInRect(R, P) and (IsRectEmpty(CR) or not PtInRect(CR, P)) then
    begin
      B := GetBorderSize;
      if B > 0 then
      begin
        InflateRect(R, -B, -B);

        if IsRectEmpty(R) or not PtInRect(R, P) then
        begin
          Result := SC_HTOUTTERBORDER;
          Exit;
        end;
      end;

      B := BorderWidth;
      if B > 0 then
      begin
        InflateRect(R, -B, -B);

        if IsRectEmpty(R) or not PtInRect(R, P) then
        begin
          Result := SC_HTBORDER;
          Exit;
        end;
      end;

      B := GetInnerBorderSize;
      if B > 0 then
      begin
        InflateRect(R, -B, -B);

        if IsRectEmpty(R) or not PtInRect(R, P) then
        begin
          Result := SC_HTOUTTERBORDER;
          Exit;
        end;
      end;

      Result := GetInheritedNCArea(P);
    end;
  end;
end;

function TSCCustomControl.GetInheritedNCArea(P: TPoint): LongInt;
begin
  Result := SC_HTNONE;
end;

procedure TSCCustomControl.DoFakeMouseUp(Message: TWMMouse;
  Button: TMouseButton);
var
  P: TPoint;
  Msg: TWMNCHitMessage;
begin
  P := Self.ClientToScreen(Point(Message.XPos, Message.YPos));

  Msg.Msg     := Message.Msg;
  Msg.Result  := HTCLIENT;
  Msg.HitTest := HTCLIENT;
  Msg.XCursor := P.x;
  Msg.YCursor := P.y;

  if csCaptureMouse in ControlStyle then MouseCapture := False;
  DoNCMouseUp(Msg, Button);
end;

procedure TSCCustomControl.DoFakeMouseDown(Message: TWMMouse;
  Button: TMouseButton; Shift: TShiftState);
var
  P: TPoint;
  Msg: TWMNCHitMessage;
begin
  P := Self.ClientToScreen(Point(Message.XPos, Message.YPos));

  Msg.Msg     := Message.Msg;
  Msg.Result  := HTCLIENT;
  Msg.HitTest := HTCLIENT;
  Msg.XCursor := P.x;
  Msg.YCursor := P.y;

  // if csCaptureMouse in ControlStyle then MouseCapture := True;
  SetCapture(Self.Handle);
  DoNCMouseDown(Msg, Button, Shift);
end;

procedure TSCCustomControl.DoFakeMouseMove(Message: TWMMouse);
var
  P: TPoint;
begin
  P := Self.ClientToScreen(Point(Message.XPos, Message.YPos));
  P := ScreenToNC(P);

  NCMouseMove(HTCLIENT, P.x, P.y);
end;

function TSCCustomControl.CanCaptureMouseOnNC(P: TPoint): Boolean;
begin
  Result := False;
end;

procedure TSCCustomControl.ScrollerChanged(Sender: TSCCustomControlScrollbar);
begin
  //
end;

procedure TSCCustomControl.ScrollerDestroyed(
  Sender: TSCCustomControlScrollbar);
begin
  //
end;

procedure TSCCustomControl.ScrollerPositionChanged(
  Sender: TSCCustomControlScrollbar);
begin
  //
end;

procedure TSCCustomControl.ScrollerPositionChanging(
  Sender: TSCCustomControlScrollbar; var ScrollPos: Integer;
  var CanScroll: Boolean);
begin
  //
end;

procedure TSCCustomControl.ScrollerRangeChanged(
  Sender: TSCCustomControlScrollbar);
begin
  //
end;

procedure TSCCustomControl.ScrollerSizeChanged(
  Sender: TSCCustomControlScrollbar);
begin
  //
end;

procedure TSCCustomControl.ScrollerVisibleChanged(
  Sender: TSCCustomControlScrollbar);
begin
  //
end;

function TSCCustomControl.GetHorzScrollbarRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
end;

function TSCCustomControl.GetVertScrollbarRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
end;

function TSCCustomControl.GetBorderPropsClass: TSCControlBorderPropsClass;
begin
  Result := TSCBorderProps;
end;

procedure TSCCustomControl.SetBorderProps(Value: TSCControlBorderProps);
begin
  FBorderProps.Assign(Value);
end;

procedure TSCCustomControl.DoPictureListChanged;
begin
  //
end;

procedure TSCCustomControl.SetPictureList(Value: TSCPictureList);
begin
  if FPictureList <> Value then
  begin
    if FPictureList <> nil then
      FPictureList.UnregisterNotifier(FPictureNotifier);

    FPictureList := Value;
    if FPictureList <> nil then
      FPictureList.RegisterNotifier(FPictureNotifier);

    PictureListChanged(FPictureList, scpcaChanged);
  end;
end;

procedure TSCCustomControl.PictureListChanged(Sender: TSCPictureList;
  Action: TSCPictureChangeAction);
begin
  if (Action = scpcaDestroyed) and (Sender <> nil) and (Sender = FPictureList) then
  begin
    FPictureList.UnregisterNotifier(FPictureNotifier);
    FPictureList := nil;
  end;

  if FShowPicture and not FDrawingPicture then
    Invalidate;

  DoPictureListChanged;
end;

procedure TSCCustomControl.SetPictureIndex(Value: Integer);
begin
  if Value < -1 then Value := -1;

  if FPictureIndex <> Value then
  begin
    FPictureIndex := Value;
    if FPictureList <> nil then
      PictureListChanged(nil, scpcaChanged);
  end;
end;

procedure TSCCustomControl.FocusChanged;
begin
  //
end;

procedure TSCCustomControl.SystemColorsChanged;
begin
  Invalidate;
end;

procedure TSCCustomControl.Paint;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := GetDefaultBackColor;
    FillRect(ClientRect);
  end;  
end;

procedure TSCCustomControl.NotifyStyleChange(Props: TSCCustomStyleProps);
begin
  if Props <> nil then
    AssignProps(Props);
end;

procedure TSCCustomControl.SetStyleController(Value: TSCCustomStyleController);
begin
  if FStyleController <> Value then
  begin
    if FStyleController <> nil then
    begin
      {$IFDEF SC_DELPHI5_UP}
      FStyleController.RemoveFreeNotification(Self);
      {$ENDIF}
      FStyleController.UnregisterChanges(Self);
    end;

    FStyleController := Value;

    if FStyleController <> nil then
    begin
      FStyleController.FreeNotification(Self);
      FStyleController.RegisterChanges(Self);
    end;
  end;
end;

procedure TSCCustomControl.NotifyStyleChange;
begin
  if FStyleController <> nil then
    AssignProps(FStyleController.BorderProps);
end;

function TSCCustomControl.CanUpdateStyle(Props: TSCCustomStyleProps): Boolean;
begin
  Result := Props <> nil;
end;

procedure TSCCustomControl.AssignProps(Props: TSCCustomStyleProps);
begin
  if Props is TSCStyleBorderProps then
    Self.BorderProps.Assign(Props);
end;

function TSCCustomControl.CanSetBorder(Value: TSCControlBorder): Boolean;
begin
  Result := True;
end;

function TSCCustomControl.CanSetInnerBorder(Value: TSCControlBorder): Boolean;
begin
  Result := True;
end;

function TSCCustomControl.GetTextHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  try
    SaveFont := SelectObject(DC, GetTextCalculateFont.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
  finally
    ReleaseDC(0, DC);
  end;

  Result := Metrics.tmHeight;
end;

function TSCCustomControl.GetTextCalculateFont: TFont;
begin
  Result := Self.Font;
end;

function TSCCustomControl.GetBorderProps: TSCControlBorderProps;
begin
  Result := FBorderProps;
end;

function TSCCustomControl.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
var
  R: TRect;
begin
  Result := AutoSize and inherited CanAutoSize(NewWidth, NewHeight);
  if Result then
  begin
    R := GetAdjustedRect(NewWidth, NewHeight);

    NewWidth := R.Right - R.Left;
    if NewWidth < 0 then NewWidth := 0;

    NewHeight := R.Bottom - R.Top;
    if NewHeight < 0 then NewHeight := 0;
  end;
end;

function TSCCustomControl.GetAdjustedRect(NewWidth, NewHeight: Integer): TRect;
var
  B: Integer;
begin
  Result := Rect(Left, Top, Left + NewWidth, Top + NewHeight);

  B := 2*(GetBorderSize + BorderWidth + GetInnerBorderSize);
  
  Inc(Result.Right, B);
  Inc(Result.Bottom, B);
end;

procedure TSCCustomControl.CMEnter(var Message: TCMEnter);
begin
  FHasFocus := True;

  BeforeEnter;
  inherited;
  AfterEnter;
end;

procedure TSCCustomControl.CMExit(var Message: TCMExit);
begin
  FHasFocus := False;

  BeforeExit;
  inherited;
  AfterExit;
end;

procedure TSCCustomControl.AfterEnter;
begin
  //
end;

procedure TSCCustomControl.AfterExit;
begin
  //
end;

procedure TSCCustomControl.BeforeEnter;
begin
  //
end;

procedure TSCCustomControl.BeforeExit;
begin
  //
end;

function TSCCustomControl.GetImageIndex: TImageIndex;
begin
  Result := FImageIndex;
end;

function TSCCustomControl.GetImages: TCustomImageList;
begin
  Result := FImages;
end;

function TSCCustomControl.CanMenuPopup(const Pos: TSmallPoint): Boolean;
var
  Control: TControl;
  PopupMenu: TPopupMenu;
begin
  Result := False;
  if IsDesigning then Exit;

  Control := Self;
  while Control <> nil do
  begin
    PopupMenu := TSCFakeControl(Control).GetPopupMenu;
    if (PopupMenu <> nil) then
    begin
      if not PopupMenu.AutoPopup then Exit;
      Result := True;
      Exit;
    end;
    Control := Control.Parent;
  end;
end;

procedure TSCCustomControl.CMJumpToNext(var Message: TMessage);
begin
  Message.Result := 0;
end;

procedure TSCCustomControl.WMKeyDown(var Message: TWMKeyDown);
begin
  if DoNextControl(Message.CharCode, scKeyDataToShiftState(Message.KeyData)) then
  begin
    Message.Result := 0;
    Message.CharCode := VK_TAB;
  end else
    inherited;
end;

procedure TSCCustomControl.WMSysKeyDown(var Message: TWMKeyDown);
begin
  if not DoNextControl(Message.CharCode, scKeyDataToShiftState(Message.KeyData)) then
    inherited;
end;

function TSCCustomControl.DoNextControl(CharCode: Word; Shift: TShiftState): Boolean;
begin
  Result := False;
  if Self.HandleAllocated then
  begin
    Result := CanDoNextControl(CharCode, Shift);
    if Result then PostMessage(Self.Handle, WM_KEYDOWN, VK_TAB, 0);
  end;  
end;

procedure TSCCustomControl.CMIsVisibleChild(var Message: TMessage);
var
  C: TControl;
  I: Integer;
begin
  Message.Result := 0;
  C := TControl(Message.WParam);

  if C <> nil then
    for I := 0 to Self.ControlCount-1 do
      if Self.Controls[I] = C then
      begin
        if not IsVisibleChild(C) then
          Message.Result := 1;

        Break;
      end;
end;

function TSCCustomControl.IsVisibleChild(C: TControl): Boolean;
begin
  Result := True;
end;

procedure TSCCustomControl.LoadFromFile(const FileName: String);
var
  C: TComponent;
  Sl: TStringList;
begin
  if FileExists(FileName) then
  begin
    Sl := TStringList.Create;
    try
      Sl.LoadFromFile(FileName);

      C := scStringToComponent(Sl.Text);
      if C is TSCCustomControl then
        Self.Assign(C);
    finally
      Sl.Free;
    end;
  end;
end;

procedure TSCCustomControl.SaveToFile(const FileName: String);
var
  Sl: TStringList;
begin
  Sl := TStringList.Create;
  try
    Sl.Text := scComponentToString(Self);
    Sl.SaveToFile(FileName);
  finally
    Sl.Free;
  end;
end;

procedure TSCCustomControl.DoFocusChanged;
begin
  FocusChanged;
  if Assigned(FOnFocusChange) then
    FOnFocusChange(Self);
end;

procedure TSCCustomControl.NotifyAll(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
begin
  if FNotificationList <> nil then
    for I := 0 to FNotificationList.Count-1 do
      TSCNotifier(FNotificationList[I]).Notification(Self, AComponent, Operation);
end;

procedure TSCCustomControl.RegisterNotifier(ANotifier: TSCNotifier);
begin
  if (ANotifier <> nil) and ((FNotificationList = nil) or
    (FNotificationList.IndexOf(ANotifier) = -1)) then
  begin
    FNotificationList := TList.Create;
    FNotificationList.Add(ANotifier);
  end;
end;

procedure TSCCustomControl.UnregisterNotifier(ANotifier: TSCNotifier);
var
  Index: Integer;
begin
  if (ANotifier <> nil) and (FNotificationList <> nil) then
  begin
    Index := FNotificationList.IndexOf(ANotifier);
    if Index > -1 then
    begin
      FNotificationList.Delete(Index);
      if FNotificationList.Count = 0 then
        FreeAndNil(FNotificationList);
    end;
  end;
end;

procedure TSCCustomControl.BorderChanged;
begin
  //
end;

procedure TSCCustomControl.ScrollerPositionChanged(
  Sender: TSCCustomControlScrollbar; OldPos, NewPos: Integer);
begin
  //
end;

procedure TSCCustomControl.WMPaint(var Message: TWMPaint);
var
  CR, R: TRect;
begin
  if HandleAllocated and (Message.DC <> 0) and (csPaintCopy in ControlState) then
  begin
    Windows.GetWindowRect(Handle, R);
    Windows.GetClientRect(Handle, CR);

    CR.TopLeft := ClientToScreen(CR.TopLeft);
    CR.BottomRight := ClientToScreen(CR.BottomRight);

    OffsetRect(CR, -R.Left, -R.Top);
    MoveWindowOrg(Message.DC, CR.Left, CR.Top);

    OffsetRect(CR, -CR.Left, -CR.Top);
    IntersectClipRect(Message.DC, 0, 0, CR.Right, CR.Bottom);

    inherited;

    MoveWindowOrg(Message.DC, -CR.Left, -CR.Top);
  end else
    inherited;
end;

function TSCCustomControl.GetPicturePropsClass: TSCCustomPicturePropsClass;
begin
  Result := TSCPictureProps;
end;

procedure TSCCustomControl.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TSCCustomControl.SetPictureIndent(Value: Integer);
begin
  if FPictureIndent <> Value then
  begin
    FPictureIndent := Value;
    if HasPicture then
      PictureChanged(nil);
  end;
end;

procedure TSCCustomControl.SetPictureOrient(Value: TSCPictureOrient);
begin
  if FPictureOrient <> Value then
  begin
    FPictureOrient := Value;
    if HasPicture then
      PictureChanged(nil);
  end;
end;

procedure TSCCustomControl.SetPictureProps(Value: TSCCustomPictureProps);
begin

end;

procedure TSCCustomControl.SetPictureTopIndent(Value: Integer);
begin
  if FPictureTopIndent <> Value then
  begin
    FPictureTopIndent := Value;
    if HasPicture then
      PictureChanged(nil);
  end;
end;

procedure TSCCustomControl.SetPictureTransparent(Value: Boolean);
begin
  if FPictureTransparent <> Value then
  begin
    FPictureTransparent := Value;
    if HasPicture then
      PictureChanged(nil);
  end;
end;

procedure TSCCustomControl.SetShowPicture(Value: Boolean);
begin
  if FShowPicture <> Value then
  begin
    FShowPicture := Value;
    PictureChanged(nil);
  end;
end;

procedure TSCCustomControl.PictureChanged(Sender: TObject);
begin
  if not FDrawingPicture then Invalidate;
  DoPictureChanged;
  if Assigned(FOnPictureChange) then
    FOnPictureChange(Self);
end;

procedure TSCCustomControl.DoPictureChanged;
begin
  //
end;

function TSCCustomControl.GetPicture: TPicture;
begin
  Result := FPicture;
  if PictureList <> nil then
    Result := PictureList.GetPicture(PictureIndex);
end;

function TSCCustomControl.HasPicture(P: TPicture): Boolean;
begin
  Result := FShowPicture and (P <> nil) and (P.Graphic <> nil) and
    not P.Graphic.Empty and (P.Height > 0) and (P.Width > 0);
end;

function TSCCustomControl.GetPictureRect: TRect;
begin
  Result := GetPictureRect(GetPicture);
end;

procedure TSCCustomControl.DrawPicture(C: TCanvas);
var
  R: TRect;
  P: TPicture;
  DrawPict: TPicture;
  SR, I, J, X, Y, L, T: Integer;
begin
  P := GetPicture;
  if (P = nil) or FDrawingPicture or (C = nil) or
    not CanDrawPicture(P) then
    Exit;

  FDrawingPicture := True;
  try
    R := GetPictureRect;
    if IsRectEmpty(R) then
      Exit;

    SR := IntersectClipRect(C.Handle, R.Left, R.Top, R.Right, R.Bottom);
    try
      if SR <> NULLREGION then
      begin
        DrawPict := TPicture.Create;
        try
          DrawPict.Assign(P);

          P := DrawPict;
          P.Graphic.Transparent := FPictureTransparent;

          case FPictureOrient of
            scpoTopLeft:
              C.Draw(R.Left, R.Top, P.Graphic);
            scpoTopRight:
            begin
              L := R.Right - P.Width;
              C.Draw(L, R.Top, P.Graphic);
            end;
            scpoBottomLeft:
            begin
              T := R.Bottom - P.Height;
              C.Draw(R.Left, T, P.Graphic);
            end;
            scpoBottomRight:
            begin
              L := R.Right - P.Width;
              T := R.Bottom - P.Height;

              C.Draw(L, T, P.Graphic);
            end;
            scpoCenter:
            begin
              L := R.Left + ((R.Right - R.Left - P.Width) div 2);
              T := R.Top + ((R.Bottom - R.Top - P.Height) div 2);

              C.Draw(L, T, P.Graphic);
            end;
            scpoTiled:
            begin
              X := (R.Right - R.Left) div P.Width;
              if (R.Right - R.Left) mod P.Width <> 0 then
                Inc(X);

              Y := (R.Bottom - R.Top) div P.Height;
              if (R.Bottom - R.Top) mod P.Height <> 0 then
                Inc(Y);

              L := R.Left;
              for I := 1 to X do
              begin
                T := R.Top;

                for J := 1 to Y do
                begin
                  C.Draw(L, T, P.Graphic);
                  Inc(T, P.Height);
                end;

                Inc(L, P.Width);
              end;
            end;
          end;
        finally
          DrawPict.Free;
        end;
      end;
    finally
      SelectClipRgn(C.Handle, 0);
    end;
  finally
    FDrawingPicture := False;
  end;
end;

function TSCCustomControl.CanDrawPicture(P: TPicture): Boolean;
begin
  Result := FShowPicture and not FDrawingPicture and HasPicture(P);
end;

function TSCCustomControl.HasPicture: Boolean;
begin
  Result := HasPicture(GetPicture);
end;

function TSCCustomControl.CanDrawPicture: Boolean;
begin
  Result := CanDrawPicture(GetPicture);
end;

function TSCCustomControl.GetPictureRect(P: TPicture): TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if FShowPicture then
  begin
    Result := GetClientRect;
    InflateRect(Result, -FPictureIndent, -FPictureTopIndent);
  end;
end;

procedure TSCCustomControl.WMChar(var Message: TWMChar);
var
  Shift: TShiftState;
  KeyState: TKeyboardState;
begin
  GetKeyboardState(KeyState);
  Shift := KeyboardStateToShiftState(KeyState);

  if CanDoNextControl(Message.CharCode, Shift) then
  begin
    Message.Result := 0;
    Message.CharCode := VK_TAB;
  end else
    inherited;
end;

function TSCCustomControl.CanDoNextControl(CharCode: Word; Shift: TShiftState): Boolean;
begin
  Result := SendMessage(Self.Handle, CM_SCJUMPTONEXT,
    CharCode, scShiftStateToKeys(Shift)) = 1;
end;

procedure TSCCustomControl.CNChar(var Message: TWMChar);
var
  Shift: TShiftState;
  KeyState: TKeyboardState;
begin
  GetKeyboardState(KeyState);
  Shift := KeyboardStateToShiftState(KeyState);

  if CanDoNextControl(Message.CharCode, Shift) then
  begin
    Message.Result := 0;
    Message.CharCode := VK_TAB;
  end else
    inherited;
end;

procedure TSCCustomControl.AlignControls(AControl: TControl; var Rect: TRect);
begin
  inherited AlignControls(AControl, Rect);
  if AControl = nil then
    Invalidate;
end;

function TSCCustomControl.GetDefaultBackColor: TColor;
begin
  Result := Self.Color;
  if Result = clNone then
    Result := clBtnFace;
end;

function TSCCustomControl.GetDefaultForeColor: TColor;
begin
  Result := Self.Font.Color;
  if Result = clNone then
    Result := clBtnText;
end;

procedure TSCCustomControl.DoBeginUpdate;
begin
  //
end;

procedure TSCCustomControl.DoEndUpdate;
begin
  //
end;

function TSCCustomControl.CaptureFocus(ProcessEvents: Boolean): Boolean;
begin
  Result := False;
  if CanGetFocus and (CanFocus or (GetParentForm(Self) = nil)) then
  begin
    Windows.SetFocus(Self.Handle);
    if ProcessEvents then
      Application.ProcessMessages;

    Result := IsActiveControl;
    if not Result then
      MouseCapture := False;
  end;
end;

function TSCCustomControl.IsActiveControl: Boolean;
var
  H: Hwnd;
begin
  Result := False;

  H := GetFocus;
  while IsWindow(H) do
  begin
    if H = WindowHandle then
    begin
      Result := True;
      Break;
    end;

    H := GetParent(H);
  end;
end;

function TSCCustomControl.IsDesigning: Boolean;
begin
  Result := csDesigning in ComponentState;
end;

function TSCCustomControl.IsDestroying: Boolean;
begin
  Result := csDestroying in ComponentState;
end;

function TSCCustomControl.IsLoading: Boolean;
begin
  Result := csLoading in ComponentState;
end;

function TSCCustomControl.IsLocked: Boolean;
begin
  Result := InUpdate or IsLoading or IsDestroying or
    IsCreatingWnd or not HandleAllocated;
end;

function TSCCustomControl.IsUpdating: Boolean;
begin
  Result := csUpdating in ComponentState;
end;

function TSCCustomControl.IsCreatingWnd: Boolean;
begin
  Result := FCreatingWnd > 0;
end;

procedure TSCCustomControl.BeginCreatingWnd;
begin
  Inc(FCreatingWnd);
end;

procedure TSCCustomControl.EndCreatingWnd;
begin
  if FCreatingWnd > 0 then
    Dec(FCreatingWnd);
end;

procedure TSCCustomControl.CreateWnd;
begin
  Inc(FCreatingWnd);
  try
    inherited CreateWnd;
  finally
    Dec(FCreatingWnd);
  end;
end;

function TSCCustomControl.IsReading: Boolean;
begin
  Result := csReading in ComponentState;
end;

function TSCCustomControl.IsWriting: Boolean;
begin
  Result := csWriting in ComponentState;
end;

{ TSCCustomSizableControl }

procedure TSCCustomSizableControl.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomSizableControl then
  begin
    with TSCCustomSizableControl(Source) do
    begin
      Self.ShowSizeGrip := ShowSizeGrip;
      Self.ShowStatusbar := ShowStatusbar;
      Self.StatusbarAlignment := StatusbarAlignment;
      Self.StatusbarColor := StatusbarColor;
      Self.StatusbarText := StatusbarText;
    end;
  end;
end;

procedure TSCCustomSizableControl.CalculateBorder(var R: TRect);
var
  SH: Integer;
begin
  inherited CalculateBorder(R);

  if FShowStatusbar then
  begin
    SH := GetStatusbarHeight;
    if SH < 0 then SH := 0;

    Dec(R.Bottom, SH);
  end;
end;

constructor TSCCustomSizableControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowSizeGrip := True;
  FStatusbarAlignment := taLeftJustify;
  FStatusbarColor := clBtnFace;
end;

function TSCCustomSizableControl.GetInheritedNCArea(P: TPoint): LongInt;
begin
  Result := inherited GetInheritedNCArea(P);

  if FShowStatusbar and (Result = SC_HTNONE) then
    Result := GetStatusbarPartAtPos(P);
end;

function TSCCustomSizableControl.GetStatusbarHeight: Integer;
begin
  Result := 16;
end;

function TSCCustomSizableControl.GetStatusbarPartAtPos(P: TPoint): LongInt;
var
  R, CR: TRect;
  B, SH: Integer;
begin
  Result := SC_HTNONE;

  if FShowStatusbar and (Result = SC_HTNONE) and
    HandleAllocated and GetWindowRect(Handle, R) then
  begin
    SH := GetStatusbarHeight;

    if SH > 0 then
    begin
      B := GetBorderSize + GetInnerBorderSize + BorderWidth;

      CR := R;
      if B > 0 then
      begin
        InflateRect(CR, -B, -B);
        if IsRectEmpty(CR) then
          Exit;
      end;

      CR.Top := CR.Bottom - SH;
      IntersectRect(CR, CR, R);

      if not IsRectEmpty(CR) and PtInRect(CR, P) then
      begin
        Result := SC_HTSTATUSBAR;

        if FShowSizeGrip then
        begin
          CR.Left := CR.Right - SH;
          IntersectRect(CR, CR, R);

          if not IsRectEmpty(CR) and PtInRect(CR, P) then
            Result := SC_HTSIZEGRIP;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomSizableControl.RedrawBorder(const Clip: HRGN; OnDC: HDC);
var
  DC: HDC;
  R, TxR: TRect;
  I, SH, TxtFormat: Integer;
  FrameCanvas: TCanvas;
begin
  inherited RedrawBorder(Clip, OnDC);

  if not (FShowStatusbar and HandleAllocated) or
    IsIconic(Handle) or IsDestroying then
    Exit;

  DC := OnDC;
  if OnDC = 0 then
    DC := GetWindowDC(Handle);

  try
    SH := GetStatusbarHeight;
    if SH < 0 then SH := 0;

    if SH > 0 then
    begin
      R := Rect(0, 0, Width, Height);
      inherited CalculateBorder(R);

      InflateRect(R, -BorderWidth, -BorderWidth);

      if not IsRectEmpty(R) then
      begin
        if R.Bottom - R.Top < SH then
          SH := R.Bottom - R.Top;

        R.Top := R.Bottom - SH;
        if IsRectEmpty(R) then
          Exit;

        IntersectClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
        try
          FrameCanvas := TCanvas.Create;
          try
            with FrameCanvas do
            begin
              Handle := DC;
              Brush.Color := FStatusbarColor;

              FillRect(R);

              TxR := R;
              InflateRect(TxR, -2, -1);

              if FShowSizeGrip then
                Dec(TxR.Right, GetStatusbarHeight);

              if not IsRectEmpty(TxR) then
              begin
                TxtFormat := DT_SINGLELINE or DT_EXPANDTABS or DT_LEFT or
                  DT_VCENTER or DT_NOPREFIX or DT_END_ELLIPSIS;

                if FStatusbarAlignment = taRightJustify then
                  TxtFormat := TxtFormat and not DT_LEFT or DT_RIGHT
                else
                if FStatusbarAlignment = taCenter then
                  TxtFormat := TxtFormat and not DT_LEFT or DT_CENTER;

                DrawText(Handle, PChar(FStatusbarText), Length(FStatusbarText),
                  TxR, TxtFormat);
              end;

              InflateRect(R, -2, -1);

              if FShowSizeGrip then
              begin
                I := 10;

                while I > 0 do
                begin
                  Pen.Color := FStatusbarColor;
                  if Odd(I div 2) then
                    Pen.Color := GetBtnShadowOf(FStatusbarColor);

                  MoveTo(R.Right, R.Bottom - I);
                  LineTo(R.Right - I, R.Bottom);
                  
                  MoveTo(R.Right, R.Bottom - (I - 1));
                  LineTo(R.Right - (I - 1), R.Bottom);

                  Dec(I, 2);
                end;
              end;

              (*
              Pen.Color := GetBtnShadowOf(FStatusbarColor);

              InflateRect(R, 2, 1);
              MoveTo(R.Left, R.Top);
              LineTo(R.Right, R.Top);
              *)
            end;
          finally
            FrameCanvas.Free;
          end;
        finally
          SelectClipRgn(DC, 0);
        end;
      end;
    end;
  finally
    if (DC <> 0) and (OnDC = 0) then
      ReleaseDC(Handle, DC);
  end;
end;

procedure TSCCustomSizableControl.SetShowSizeGrip(Value: Boolean);
begin
  if FShowSizeGrip <> Value then
  begin
    FShowSizeGrip := Value;

    if FShowStatusbar then
    begin
      RedrawScrollbars;
      RedrawBorder(0);
    end;
  end;
end;

procedure TSCCustomSizableControl.SetShowStatusbar(Value: Boolean);
begin
  if FShowStatusbar <> Value then
  begin
    FShowStatusbar := Value;
    if HandleAllocated then
      SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOZORDER or
        SWP_NOMOVE or SWP_NOSIZE or SWP_FRAMECHANGED);

     StatusbarChanged;   
  end;
end;

procedure TSCCustomSizableControl.SetStatusbarAlignment(Value: TAlignment);
begin
  if FStatusbarAlignment <> Value then
  begin
    FStatusbarAlignment := Value;
    if FShowStatusbar then
      RedrawBorder(0);
  end;
end;

procedure TSCCustomSizableControl.SetStatusbarColor(Value: TColor);
begin
  if FStatusbarColor <> Value then
  begin
    FStatusbarColor := Value;
    if FShowStatusbar then
      RedrawBorder(0);
  end;
end;

procedure TSCCustomSizableControl.SetStatusbarText(const Value: TCaption);
begin
  if FStatusbarText <> Value then
  begin
    FStatusbarText := Value;
    if FShowStatusbar then
      RedrawBorder(0);
  end;
end;

procedure TSCCustomSizableControl.StatusbarChanged;
begin
  //
end;

procedure TSCCustomSizableControl.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
var
  R1, R2: TRect;
  SH, W, H: Integer;
begin
  inherited;

  if FShowStatusbar then
  begin
    R1 := Rect(0, 0, Width, Height);

    R2 := R1;
    inherited CalculateBorder(R2);

    InflateRect(R2, -BorderWidth, -BorderWidth);

    OffsetRect(R2, -R2.Left, -R2.Top);

    SH := GetStatusbarHeight;
    if SH < 0 then SH := 0;

    W := R1.Right - R2.Right;

    if W < 0 then W := 0;
    Inc(W, SH);

    H := R1.Bottom - R2.Bottom;

    if H < 0 then H := 0;
    Inc(H, SH);

    with Message.MinMaxInfo^ do
    begin
      // min sizing
      if Constraints.MinWidth > W then
        W := Constraints.MinWidth;

      if Constraints.MinHeight > H then
        H := Constraints.MinHeight;

      if ptMinTrackSize.x > W then
        W := ptMinTrackSize.x;
        
      if ptMinTrackSize.y > H then
        H := ptMinTrackSize.y;

      ptMinTrackSize := Point(W, H);

      // max sizing
      H := Constraints.MaxHeight;
      if ptMaxTrackSize.y > H then
        H := ptMaxTrackSize.y;

      W := Constraints.MaxWidth;
      if ptMaxTrackSize.x > W then
        W := ptMaxTrackSize.x;

      ptMaxTrackSize := Point(W, H);
    end;
  end;
end;

procedure TSCCustomSizableControl.WMNCHitTest(var Message: TWMNCHitTest);
var
  P: TPoint;
begin
  inherited;

  if not IsDesigning and
    FShowStatusbar and FShowSizeGrip then
  begin
    if Message.Result = HTBOTTOMRIGHT then
      Message.Result := HTCLIENT;

    P := SmallPointToPoint(Message.Pos);
    if GetStatusbarPartAtPos(P) = SC_HTSIZEGRIP then
       Message.Result := HTBOTTOMRIGHT;
  end;
end;

procedure TSCCustomSizableControl.WMSize(var Message: TWMSize);
begin
  inherited;
  if FShowStatusbar then
  begin
    RedrawScrollbars;
    RedrawBorder(0);
  end;
end;

{ TSCCustomControlScrollbar }

procedure TSCCustomControlScrollbar.Assign(Source: TPersistent);
begin
  if Source is TSCCustomControlScrollbar then
  begin
    BeginUpdate;
    try
      with TSCCustomControlScrollbar(Source) do
      begin
        Self.Visible := Visible;

        Self.Background := Background;
        Self.ButtonColors := ButtonColors;
        Self.ButtonExtra := ButtonExtra;
        Self.ButtonLeft := ButtonLeft;
        Self.ButtonRight := ButtonRight;
        Self.ButtonSize := ButtonSize;
        Self.Enabled := Enabled;
        Self.Icons := Icons;
        Self.LargeChange := LargeChange;
        Self.Max := Max;
        Self.Min := Min;
        Self.PageSize := PageSize;
        Self.Position := Position;
        Self.SmallChange := SmallChange;
        Self.Style := Style;
        Self.Thumb := Thumb;
        Self.ThumbSize := ThumbSize;
        Self.Track := Track;
      end;
    finally
      EndUpdate;
    end;
  end else
    inherited Assign(Source);
end;

procedure TSCCustomControlScrollbar.BeginUpdate;
begin
  if FUpdateCount = 0 then
  begin
    FWasVisible := FVisible;
    FUpdatePos := FPosition;
  end;

  Inc(FUpdateCount);
end;

procedure TSCCustomControlScrollbar.BufferedPaint(DC: HDC; R: TRect);
var
  CR: TRect;
  MemDC: HDC;
  W, H: Integer;
  MemBitmap, OldBitmap: HBITMAP;
begin
  if (DC = 0) or IsRectEmpty(R) then
    Exit;

  W := R.Right - R.Left;
  H := R.Bottom - R.Top;

  MemDC := CreateCompatibleDC(DC);
  try
    MemBitmap := CreateCompatibleBitmap(DC, W, H);
    try
      OldBitmap := SelectObject(MemDC, MemBitmap);
      try
        CR := R;
        OffsetRect(CR, -CR.Left, -CR.Top);

        PaintOn(MemDC, CR);
        BitBlt(DC, R.Left, R.Top, W, H, MemDC, 0, 0, SRCCOPY);
      finally
        SelectObject(MemDC, OldBitmap);
      end;
    finally
      DeleteObject(MemBitmap);
    end;
  finally
    DeleteDC(MemDC);
  end;
end;

constructor TSCCustomControlScrollbar.Create(AOwner: TSCCustomControl;
  AKind: TSCScrollbarKind);
begin
  inherited Create;
  FOwner := AOwner;
  FKind  := AKind;

  FBorderColor := clWindowFrame;
  FButtonSize := -1;
  FButtonLayout := scsbDefault;
  FEnabled := True;
  FLineDiv := 4;
  FPageDiv := 12;
  FDelay := 10;
  FLargeChange := 1;
  FMax := 100;
  FMin := 0;
  FPageSize := 0;
  FPosition := 0;
  FSensitivity := -1;
  FSmallChange := 1;
  FStyle := scssDefault;
  FThumbLines := sctlNone;
  FThumbSize := -1;
  FTrack := True;
  FTrimPageSize := True;
  FVisible := True;

  FBackground   := GetScrollbarPartClass(scsbpBkground).Create(Self);
  FButtonColors := GetScrollbarPartClass(scsbpButtons).Create(Self);
  FButtonExtra  := GetScrollbarPartClass(scsbpExtraButton).Create(Self);
  FButtonLeft   := GetScrollbarPartClass(scsbpLeftButton).Create(Self);
  FButtonRight  := GetScrollbarPartClass(scsbpRightButton).Create(Self);
  FIcons := GetScrollbarPartClass(scsbpIcon).Create(Self);
  FThumb := GetScrollbarPartClass(scsbpThumb).Create(Self);

  FButtonExtra.Visible := False;
  RearrangeDefaults;
end;

destructor TSCCustomControlScrollbar.Destroy;
begin
  if FOwner <> nil then
    FOwner.ScrollerDestroyed(Self);

  FBackground.Free;
  FButtonColors.Free;
  FButtonLeft.Free;
  FButtonExtra.Free;
  FButtonRight.Free;
  FIcons.Free;
  FThumb.Free;

  inherited Destroy;
end;

procedure TSCCustomControlScrollbar.DoChange;
begin
  if not InUpdate and (FOwner <> nil) then
    FOwner.ScrollerChanged(Self);
end;

procedure TSCCustomControlScrollbar.DoPositionChanged;
begin
  if not (InUpdate or PosChangeLocked) and (FOwner <> nil) then
    FOwner.ScrollerPositionChanged(Self);
end;

procedure TSCCustomControlScrollbar.DoPositionChanging(
  var ScrollPos: Integer; var CanScroll: Boolean);
var
  Mx: Integer;
begin
  if (FPosition <> ScrollPos) and (FOwner <> nil) and
    not (InUpdate or PosChangeLocked) then
  begin
    FOwner.ScrollerPositionChanging(Self, ScrollPos, CanScroll);
    
    if CanScroll then
    begin
      Mx := GetMaximumValue;

      if ScrollPos > Mx then ScrollPos := Mx;
      if ScrollPos < FMin then ScrollPos := FMin;
    end;
  end;
end;

procedure TSCCustomControlScrollbar.DoVisibleChanged;
begin
  if not InUpdate and (FOwner <> nil) then
    FOwner.ScrollerVisibleChanged(Self);
end;

procedure TSCCustomControlScrollbar.EndUpdate;
var
  P: Integer;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);

    if FUpdateCount = 0 then
    begin
      if FWasVisible <> FVisible then
        DoVisibleChanged;

      FWasVisible := FVisible;

      DoChange;
      DoRangeChanged;

      P := FUpdatePos;
      FUpdatePos := FPosition;

      DoPositionChanged;
      DoPositionChanged(P, FPosition);
    end;
  end;
end;

function TSCCustomControlScrollbar.GetBackColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    if PressedPart in [scspLeftSpare, scspRightSpare] then
    begin
      if HotPart <> scspNone then
        Result := GetOfficeXPSelColor
      else
        Result := GetOfficeXPDownedSelColor;
    end else
    if (PressedPart = scspNone) and
      (HotPart in [scspLeftSpare, scspRightSpare]) then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;

    if FBackground.FBlend then
      Result := BlendedColor(Result, 24, 24, 24, True);
  end else
  begin
    Result := FBackground.FColor;
    if not Enabled then
      Result := FBackground.FDisabledColor
    else
    if (PressedPart = scspNone) and
      (HotPart in [scspLeftSpare, scspRightSpare]) then
      Result := FBackground.FHotColor;

    if Result = clNone then
      Result := clScrollBar;

    if FBackground.FBlend then
      Result := BlendedColor(GetOfficeXPBtnColorOf(Result), 24, 24, 24, True);  
  end;
end;

function TSCCustomControlScrollbar.GetBackRect(R: TRect): TRect;
var
  Rr, Rl, Re: TRect;
  REmpty, LEmpty, EEmpty: Boolean;
begin
  Result := Rect(0, 0, 0, 0);
  if IsRectEmpty(R) then
    Exit;

  Result := R;
  if (FButtonSize <> 0) and (FButtonLeft.Visible or
    FButtonRight.Visible or FButtonExtra.Visible) then
  begin
    Rl := GetLeftButtonRect(R);
    Rr := GetRightButtonRect(R);
    Re := GetExtraButtonRect(R);

    LEmpty := IsRectEmpty(Rl);
    REmpty := IsRectEmpty(Rr);
    EEmpty := IsRectEmpty(Re);

    if FKind = scskHorizontal then
    begin
      case FButtonLayout of
        scsbDefault:
        begin
          if not LEmpty and (Rl.Right > Result.Left) then
            Result.Left := Rl.Right;

          if not REmpty and (Rr.Left < Result.Right) then
            Result.Right := Rr.Left;

          if not EEmpty and (Re.Left < Result.Right) then
            Result.Right := Re.Left;
        end;
        scsbLeftTop:
        begin
          if not LEmpty and (Rl.Right > Result.Left) then
            Result.Left := Rl.Right;

          if not REmpty and (Rr.Right > Result.Left) then
            Result.Left := Rr.Right;

          if not EEmpty and (Re.Left < Result.Right) then
            Result.Right := Re.Left;
        end;
        scsbRightBottom:
        begin
          if not FButtonExtra.Visible then
          begin
            if not LEmpty and (Rl.Left < Result.Right) then
              Result.Right := Rl.Left;
          end else
          begin
            if not LEmpty and (Rl.Right > Result.Left) then
              Result.Left := Rl.Right;

            if not EEmpty and (Re.Left < Result.Right) then
              Result.Right := Re.Left;
          end;

          if not REmpty and (Rr.Left < Result.Right) then
            Result.Right := Rr.Left;
        end;
      end;
    end else
    begin
      case FButtonLayout of
        scsbDefault:
        begin
          if not LEmpty and (Rl.Bottom > Result.Top) then
            Result.Top := Rl.Bottom;

          if not REmpty and (Rr.Top < Result.Bottom) then
            Result.Bottom := Rr.Top;

          if not EEmpty and (Re.Top < Result.Bottom) then
            Result.Bottom := Re.Top;
        end;
        scsbLeftTop:
        begin
          if not LEmpty and (Rl.Bottom > Result.Top) then
            Result.Top := Rl.Bottom;

          if not REmpty and (Rr.Bottom > Result.Top) then
            Result.Top := Rr.Bottom;

          if not EEmpty and (Re.Top < Result.Bottom) then
            Result.Bottom := Re.Top;
        end;
        scsbRightBottom:
        begin
          if not FButtonExtra.Visible then
          begin
            if not LEmpty and (Rl.Top < Result.Bottom) then
              Result.Bottom := Rl.Top;
          end else
          begin
            if not LEmpty and (Rl.Bottom > Result.Top) then
              Result.Top := Rl.Bottom;

            if not EEmpty and (Re.Top < Result.Bottom) then
              Result.Bottom := Re.Top;
          end;

          if not REmpty and (Rr.Top < Result.Bottom) then
            Result.Bottom := Rr.Top;
        end;
      end;
    end;

    if IsRectEmpty(Result) then
      Result := Rect(0, 0, 0, 0);
  end;
end;

function TSCCustomControlScrollbar.GetButtonSize(R: TRect): Integer;
var
  W, H, M: Integer;
begin
  Result := 0;
  if IsRectEmpty(R) then
    Exit;

  Result := FButtonSize;

  M := 0;
  if ButtonLeft.Visible then Inc(M);
  if ButtonRight.Visible then Inc(M);
  if ButtonExtra.Visible then Inc(M);

  if M = 0 then
  begin
    Result := 0;
    Exit;
  end;

  if Result = -1 then
  begin
    if FKind = scskHorizontal then
      Result := scHorzScrollButtonWidth
    else
      Result := scVertScrollButtonHeight;
  end;

  if Result < 0 then Result := 0;

  if FKind = scskHorizontal then
  begin
    W := (R.Right - R.Left) div M;
    if W < Result then Result := W;
  end else
  begin
    H := (R.Bottom - R.Top) div M;
    if H < Result then Result := H;
  end;

  if Result < 3 then Result := 0;
end;

function TSCCustomControlScrollbar.GetClientRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  
  if FOwner <> nil then
  begin
    if FKind = scskHorizontal then
      Result := FOwner.GetHorzScrollbarRect
    else
      Result := FOwner.GetVertScrollbarRect;
  end;
end;

function TSCCustomControlScrollbar.GetDefaultThumbSize(R: TRect;
  Pg: Integer): Integer;
var
  Bh, Bs, M: Integer;
begin
  Result := 0;
  if IsRectEmpty(R) then
    Exit;

  if Pg <= 0 then
  begin
    if FKind = scskHorizontal then
      Result := FDefV_ButtonSize
    else
      Result := FDefH_ButtonSize;
  end else
  begin
    Bh := 0;
    M  := 0;

    if ButtonLeft.Visible then Inc(M);
    if ButtonRight.Visible then Inc(M);
    if ButtonExtra.Visible then Inc(M);

    if M > 0 then
    begin
      Bh := GetButtonSize(R);
      if Bh < 0 then Bh := 0;

      Bh := M*Bh;
    end;

    if FKind = scskHorizontal then
      Bs := R.Right - R.Left
    else
      Bs := R.Bottom - R.Top;

    Dec(Bs, Bh);   

    if Bs <= 0 then
    begin
      Result := 0;
      Exit;
    end;

    M := Max - Min + 1;
    if M = 0 then Result := 0
    else Result := MulDiv(Pg, Bs, M);

    if FKind = scskHorizontal then
      Bs := Muldiv(2, FDefV_ButtonSize, 3)
    else
      Bs := Muldiv(2, FDefH_ButtonSize, 3);

    if Result < Bs then
      Result := Bs;
  end;

  if Result < 3 then Result := 3;
end;

function TSCCustomControlScrollbar.GetDownPoint: TPoint;
begin
  Result := Point(0, 0);
  if FOwner is TSCCustomScrollControl then
    Result := TSCCustomScrollControl(FOwner).FDownPoint;
end;

function TSCCustomControlScrollbar.GetHotPart: TSCScrollerHitPart;
var
  P1, P2: PSCScrollbarHittest;
  AOwner: TSCCustomScrollControl;
begin
  Result := scspNone;
  if FOwner is TSCCustomScrollControl then
  begin
    AOwner := TSCCustomScrollControl(FOwner);

    P1 := @(AOwner.FHotTest);
    P2 := @(AOwner.FDownTest);

    if ((P2^.Kind in [scshkNone, scshkVertical]) and (Kind = scskVertical) and
      (P1^.Kind = scshkVertical)) or ((P2^.Kind in [scshkNone, scshkHorizontal]) and
      (Kind = scskHorizontal) and (P1^.Kind = scshkHorizontal)) then
      Result := P1^.HitPart;
  end;
end;

function TSCCustomControlScrollbar.GetLeftBtnColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    if PressedPart = scspLeftButton then
    begin
      if HotPart = scspLeftButton then
        Result := GetOfficeXPDownedSelColor
      else
        Result := GetOfficeXPSelColor;
    end else
    if (PressedPart = scspNone) and (HotPart = scspLeftButton) then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;
  end else
  begin
    Result := FButtonColors.FColor;
    if not Enabled then
      Result := FButtonColors.FDisabledColor
    else
    if PressedPart = scspLeftButton then
      Result := FButtonColors.FDownColor
    else
    if (PressedPart = scspNone) and (HotPart = scspLeftButton) then
      Result := FButtonColors.FHotColor;

    if Result = clNone then
      Result := clScrollBar;
  end;

  if FButtonColors.FBlend then
    Result := BlendedColor(Result, 24, 24, 24, True);
end;

function TSCCustomControlScrollbar.GetLeftBtnIconColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    Result := clBtnText;
    if (PressedPart = scspLeftButton) and (HotPart = PressedPart) then
      Result := clHighlightText;
  end else
  begin
    Result := FIcons.FColor;
    if not Enabled then
      Result := FIcons.FDisabledColor
    else
    if PressedPart = scspLeftButton then
      Result := FIcons.FDownColor
    else
    if (PressedPart = scspNone) and (HotPart = scspLeftButton) then
      Result := FIcons.FHotColor;

    if Result = clNone then
      Result := clWindowText;
  end;    

  if FIcons.FBlend then
    Result := BlendedColor(Result, 24, 24, 24, True);
end;

function TSCCustomControlScrollbar.GetLeftButtonRect(R: TRect): TRect;
var
  Bs: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (FButtonSize = 0) or not FButtonLeft.Visible or IsRectEmpty(R) then
    Exit;

  Result := R;
  Bs := GetButtonSize(R);

  if FKind = scskHorizontal then
  begin
    if (FButtonLayout in [scsbDefault, scsbLeftTop]) or FButtonExtra.Visible then
      Result.Right := Result.Left + Bs
    else begin
      Dec(Result.Right, Bs);
      Result.Left := Result.Right - Bs;
    end;
  end else
  begin
    if (FButtonLayout in [scsbDefault, scsbLeftTop]) or FButtonExtra.Visible then
      Result.Bottom := Result.Top + Bs
    else begin
      Dec(Result.Bottom, Bs);
      Result.Top := Result.Bottom - Bs;
    end;
  end;
end;

function TSCCustomControlScrollbar.GetPositionPos(R: TRect; P: Integer): Integer;
var
  W, ThS, Mx: Integer;
begin
  Result := 0;
  if IsRectEmpty(R) then
    Exit;

  Mx := GetMaximumValue;

  if FKind = scskHorizontal then
  begin
    if P <= FMin then
      Result := R.Left
    else begin
      ThS := GetThumbSize(R);
      if ThS < 0 then ThS := 0;

      W := R.Right - R.Left - ThS;

      if P >= FMin then
      begin
        Result := R.Left + W;
        Exit;
      end;

      P := Muldiv(W, P, Mx - FMin);
      Result := R.Left + P;
    end;
  end else
  begin
    if P <= FMin then
      Result := R.Top
    else begin
      ThS := GetThumbSize(R);
      if ThS < 0 then ThS := 0;

      W := R.Bottom - R.Top - ThS;

      if P >= FMin then
      begin
        Result := R.Top + W;
        Exit;
      end;

      P := Muldiv(W, P, Mx - FMin);
      Result := R.Top + P;
    end;
  end;
end;

function TSCCustomControlScrollbar.GetPressedPart: TSCScrollerHitPart;
var
  P: PSCScrollbarHittest;
  AOwner: TSCCustomScrollControl;
begin
  Result := scspNone;
  if FOwner is TSCCustomScrollControl then
  begin
    AOwner := TSCCustomScrollControl(FOwner);

    P := @(AOwner.FDownTest);

    if ((Kind = scskVertical) and (P^.Kind = scshkVertical)) or
      ((Kind = scskHorizontal) and (P^.Kind = scshkHorizontal)) then
      Result := P^.HitPart;
  end;
end;

function TSCCustomControlScrollbar.GetRightBtnColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    if PressedPart = scspRightButton then
    begin
      if HotPart = scspRightButton then
        Result := GetOfficeXPDownedSelColor
      else
        Result := GetOfficeXPSelColor;
    end else
    if (PressedPart = scspNone) and (HotPart = scspRightButton) then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;
  end else
  begin
    Result := FButtonColors.FColor;
    if not Enabled then
      Result := FButtonColors.FDisabledColor
    else
    if PressedPart = scspRightButton then
      Result := FButtonColors.FDownColor
    else
    if (PressedPart = scspNone) and (HotPart = scspRightButton) then
      Result := FButtonColors.FHotColor;

    if Result = clNone then
      Result := clScrollBar;
  end;

  if FButtonColors.FBlend then
    Result := BlendedColor(Result, 24, 24, 24, True);
end;

function TSCCustomControlScrollbar.GetRightBtnIconColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    Result := clBtnText;
    if (PressedPart = scspRightButton) and (HotPart = PressedPart) then
      Result := clHighlightText;
  end else
  begin
    Result := FIcons.FColor;
    if not Enabled then
      Result := FIcons.FDisabledColor
    else
    if PressedPart = scspRightButton then
      Result := FIcons.FDownColor
    else
    if (PressedPart = scspNone) and (HotPart = scspRightButton) then
      Result := FIcons.FHotColor;

    if Result = clNone then
      Result := clWindowText;
  end;    

  if FIcons.FBlend then
    Result := BlendedColor(Result, 24, 24, 24, True);
end;

function TSCCustomControlScrollbar.GetRightButtonRect(R: TRect): TRect;
var
  Bs: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (FButtonSize = 0) or not FButtonLeft.Visible or IsRectEmpty(R) then
    Exit;

  Result := R;
  Bs := GetButtonSize(R);

  if FKind = scskHorizontal then
  begin
    if FButtonLayout in [scsbDefault, scsbRightBottom] then
      Result.Left := Result.Right - Bs
    else begin
      Inc(Result.Left, Bs);
      Result.Right := Result.Left + Bs;
    end;
  end else
  begin
    if FButtonLayout in [scsbDefault, scsbRightBottom] then
      Result.Top := Result.Bottom - Bs
    else begin
      Inc(Result.Top, Bs);
      Result.Bottom := Result.Top + Bs;
    end;
  end;
end;

function TSCCustomControlScrollbar.GetScrollbarPartClass(
  Part: TSCScrollerPart): TSCScrollbarPartClass;
begin
  Result := nil;
  case Part of
    scsbpBkground:
      Result := TSCScrollbarBkground;
    scsbpIcon:
      Result := TSCScrollbarIcons;
    scsbpButtons:
      Result := TSCScrollbarButtonColors;
    scsbpExtraButton,
    scsbpLeftButton,
    scsbpRightButton:
      Result := TSCScrollbarButton;
    scsbpThumb:
      Result := TSCScrollbarThumb;
  end;
end;

function TSCCustomControlScrollbar.GetThumbColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    if PressedPart = scspThumb then
    begin
      if HotPart = scspThumb then
        Result := GetOfficeXPDownedSelColor
      else
        Result := GetOfficeXPSelColor;
    end else
    if (PressedPart = scspNone) and (HotPart = scspThumb) then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;
  end else
  begin
    Result := FThumb.FColor;
    if not Enabled then
      Result := FThumb.FDisabledColor
    else
    if PressedPart = scspThumb then
      Result := FThumb.FDownColor
    else
    if (PressedPart = scspNone) and (HotPart = scspThumb) then
      Result := FThumb.FHotColor;

    if Result = clNone then
      Result := clScrollBar;
  end;    

  if FThumb.FBlend then
    Result := BlendedColor(Result, 24, 24, 24, True);
end;

function TSCCustomControlScrollbar.GetThumbMoving: Boolean;
var
  AOwner: TSCCustomScrollControl;
begin
  Result := False;
  if FOwner is TSCCustomScrollControl then
  begin
    AOwner := TSCCustomScrollControl(FOwner);

    Result := FEnabled and (FMin < GetMaximumValue) and (FThumbSize <> 0) and
      (AOwner.FDownPoint.x > -1) and (AOwner.FDownPoint.y > -1) and
      AOwner.Enabled and AOwner.FMovingThumb and (GetPressedPart = scspThumb);
  end;
end;

function TSCCustomControlScrollbar.GetThumbOffset(R: TRect): Integer;
var
  ThS: Integer;
begin
  Result := 0;
  if not IsRectEmpty(R) and ((FThumbSize > 0) or (PageSize > 0)) then
  begin
    ThS := GetDefaultThumbSize(R, PageSize);
    if ThS < 0 then ThS := 0;

    if FThumbSize > 0 then
      Result := FThumbSize - ThS
    else
      Result := ThS - GetDefaultThumbSize(R, 0);

    Result := Round(Result / 2);  
    if Result < 0 then Result := 0;
  end;
end;

function TSCCustomControlScrollbar.GetThumbRect(R: TRect): TRect;
var
  R1, R2: TRect;
  W, P, S, Ts, Mx: Integer;
  ThumbMoving: Boolean;
  AOwner: TSCCustomScrollControl;
begin
  Result := Rect(0, 0, 0, 0);
  if IsRectEmpty(R) or not (Enabled and FThumb.Visible) then
    Exit;

  R1 := GetBackRect(R);

  Mx := GetMaximumValue;

  S := Mx - FMin;
  if S <= 0 then Exit;

  Ts := GetThumbSize(R);
  P  := FPosition - FMin;

  ThumbMoving := GetThumbMoving;

  AOwner := nil;
  if FOwner is TSCCustomScrollControl then
    AOwner := TSCCustomScrollControl(FOwner);

  if ThumbMoving and (AOwner <> nil) then
    P := AOwner.FDownPosition - FMin;

  R2 := R1;
  if FKind = scskHorizontal then
  begin
    OffsetRect(R2, -R2.Left, 0);

    if Ts < R2.Right then
    begin
      W := R2.Right - Ts;
      R2.Right := Ts;

      P := Muldiv(W, P, S);

      if ThumbMoving and (AOwner <> nil) then
        Inc(P, AOwner.FMovePoint.x - AOwner.FDownPoint.x);

      OffsetRect(R2, P, 0);
    end;

    OffsetRect(R2, R1.Left, 0);
    if R2.Right > R1.Right then
      OffsetRect(R2, R1.Right - R2.Right, 0);

    if R2.Left < R1.Left then
      OffsetRect(R2, R1.Left - R2.Left, 0);
  end else
  begin
    OffsetRect(R2, 0, -R2.Top);

    if Ts < R2.Bottom then
    begin
      W := R2.Bottom - Ts;
      R2.Bottom := Ts;

      P := Muldiv(W, P, S);

      if ThumbMoving and (AOwner <> nil) then
        Inc(P, AOwner.FMovePoint.y - AOwner.FDownPoint.y);

      OffsetRect(R2, 0, P);
    end;

    OffsetRect(R2, 0, R1.Top);
    if R2.Bottom > R1.Bottom then
      OffsetRect(R2, 0, R1.Bottom - R2.Bottom);

    if R2.Top < R1.Top then
      OffsetRect(R2, 0, R1.Top - R2.Top);
  end;

  Result := R2;
  IntersectRect(Result, Result, R1);
end;

function TSCCustomControlScrollbar.GetThumbSize(R: TRect): Integer;
begin
  Result := 0;
  if not (Enabled and FThumb.Visible) or IsRectEmpty(R) then
    Exit;

  Result := FThumbSize;
  if Result = -1 then
    Result := GetDefaultThumbSize(R, PageSize);

  if Result < 3 then
    Result := 0;
end;

function TSCCustomControlScrollbar.InUpdate: Boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TSCCustomControlScrollbar.Invalidate;
begin
  DoChange;
end;

procedure TSCCustomControlScrollbar.LockPosChange;
begin
  Inc(FPosChangeLock);
end;

function TSCCustomControlScrollbar.PosChangeLocked: Boolean;
begin
  Result := FPosChangeLock > 0;
end;

procedure TSCCustomControlScrollbar.Paint(Canvas: TCanvas; R: TRect);
begin
  //
end;

procedure TSCCustomControlScrollbar.PaintOn(DC: HDC; R: TRect);
var
  C: TCanvas;
begin
  if (DC = 0) or IsRectEmpty(R) then
    Exit;

  C := TCanvas.Create;
  try
    C.Lock;
    try
      C.Handle := DC;
      try
        Paint(C, R);
      finally
        C.Handle := 0;
      end;
    finally
      C.Unlock;
    end;
  finally
    C.Free;
  end;
end;

procedure TSCCustomControlScrollbar.PartChanged(Sender: TSCScrollbarPart);
begin
  DoChange;
end;

procedure TSCCustomControlScrollbar.RearrangeDefaults;
begin
  FDefH_ButtonSize := GetSystemMetrics(SM_CYVTHUMB);
  FDefV_ButtonSize := GetSystemMetrics(SM_CXHTHUMB);
end;

procedure TSCCustomControlScrollbar.SetBackground(Value: TSCScrollbarPart);
begin
  FBackground.Assign(Value);
end;

procedure TSCCustomControlScrollbar.SetBorderColor(Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    if FVisible then DoChange;
  end;
end;

procedure TSCCustomControlScrollbar.SetButtonColors(
  Value: TSCScrollbarPart);
begin
  FButtonColors.Assign(Value);
end;

procedure TSCCustomControlScrollbar.SetButtonLeft(Value: TSCScrollbarPart);
begin
  FButtonLeft.Assign(Value);
end;

procedure TSCCustomControlScrollbar.SetButtonRight(Value: TSCScrollbarPart);
begin
  FButtonRight.Assign(Value);
end;

procedure TSCCustomControlScrollbar.SetButtonSize(Value: Integer);
begin
  if Value < 0 then
    Value := -1
  else
  if (Value > 0) and (Value < 12) then
    Value := 12;

  if FButtonSize <> Value then
  begin
    FButtonSize := Value;

    DoSizeChanged;
    if FVisible then DoChange;
  end;
end;

procedure TSCCustomControlScrollbar.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    if FVisible then DoChange;
  end;
end;

procedure TSCCustomControlScrollbar.SetIcons(Value: TSCScrollbarPart);
begin
  FIcons.Assign(Value);
end;

procedure TSCCustomControlScrollbar.SetLargeChange(Value: TSCScrollbarInc);
begin
  if FLargeChange <> Value then
  begin
    FLargeChange := Value;
    if FVisible then DoChange;
  end;
end;

procedure TSCCustomControlScrollbar.SetMax(Value: Integer);
var
  P1, P2, Mx: Integer;
begin
  if Value < FMin then
    Value := FMin;

  if FMax <> Value then
  begin
    FMax := Value;

    P1 := FPosition;
    Mx := GetMaximumValue;
    if FPosition > Mx then
      FPosition := Mx;

    P2 := FPosition;

    DoRangeChanged;
    DoPositionChanged;
    if P1 <> P2 then DoPositionChanged(P1, P2);
  end;
end;

procedure TSCCustomControlScrollbar.SetMin(Value: Integer);
var
  P1, P2: Integer;
begin
  if Value > FMax then
    Value := FMax;

  if FMin <> Value then
  begin
    FMin := Value;

    P1 := FPosition;
    if FPosition < FMin then
      FPosition := FMin;

    P2 := FPosition;

    DoRangeChanged;
    DoPositionChanged;
    if P1 <> P2 then DoPositionChanged(P1, P2);
  end;
end;

procedure TSCCustomControlScrollbar.SetPageSize(Value: Integer);
begin
  if FPageSize <> Value then
  begin
    FPageSize := Value;
    if FVisible then DoChange;
  end;
end;

procedure TSCCustomControlScrollbar.SetPosition(Value: Integer);
var
  P1, P2, Mx: Integer;
  CanScroll: Boolean;
begin
  Mx := GetMaximumValue;
  if Value > Mx then Value := Mx;
  if Value < FMin then Value := FMin;

  if CanScrollToPos(Value) then
  begin
    CanScroll := True;
    DoPositionChanging(Value, CanScroll);

    if CanScroll and CanScrollToPos(Value) and (FPosition <> Value) then
    begin
      P1 := FPosition;
      FPosition := Value;

      P2 := FPosition;

      DoPositionChanged;
      if P1 <> P2 then DoPositionChanged(P1, P2);
    end;
  end;
end;

procedure TSCCustomControlScrollbar.SetSensitivity(Value: Integer);
begin
  if Value < -1 then Value := -1;
  FSensitivity := Value;
end;

procedure TSCCustomControlScrollbar.SetSmallChange(Value: TSCScrollbarInc);
begin
  if FSmallChange <> Value then
  begin
    FSmallChange := Value;
    if FVisible then DoChange;
  end;
end;

procedure TSCCustomControlScrollbar.SetStyle(
  Value: TSCScrollbarStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    if FVisible then DoChange;
  end;
end;

procedure TSCCustomControlScrollbar.SetThumb(Value: TSCScrollbarPart);
begin
  FThumb.Assign(Value);
end;

procedure TSCCustomControlScrollbar.SetThumbSize(Value: Integer);
begin
  if Value < -1 then
    Value := -1;

  if FThumbSize <> Value then
  begin
    FThumbSize := Value;
    if FVisible then DoChange;
  end;
end;

procedure TSCCustomControlScrollbar.SetTrack(Value: Boolean);
begin
  if FTrack <> Value then
  begin
    FTrack := Value;
    if FVisible then DoChange;
  end;
end;

procedure TSCCustomControlScrollbar.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    DoVisibleChanged;
  end;
end;

procedure TSCCustomControlScrollbar.UnlockPosChange;
begin
  if FPosChangeLock > 0 then
    Dec(FPosChangeLock);
end;

procedure TSCCustomControlScrollbar.SetTrimPageSize(Value: Boolean);
var
  Mx: Integer;
begin
  if FTrimPageSize <> Value then
  begin
    FTrimPageSize := Value;

    Mx := GetMaximumValue;
    if FTrimPageSize and (FPosition > Mx) then
      SetPosition(Mx);
  end;
end;

function TSCCustomControlScrollbar.GetMaximumValue: Integer;
begin
  Result := FMax;
  if FTrimPageSize and (FPageSize > 0) then
  begin
    Result := FMax - FPageSize;
    if Result < FMin then
      Result := FMin;
  end;
end;

procedure TSCCustomControlScrollbar.SetSlideLine(Value: Boolean);
begin
  if FSlideLine <> Value then
  begin
    FSlideLine := Value;
    if FVisible then DoChange;
  end;
end;

function TSCCustomControlScrollbar.CanScrollToPos(var NewValue: Integer): Boolean;
begin
  Result := True;
  if FOwner is TSCCustomScrollControl then
    Result := TSCCustomScrollControl(FOwner).CanScrollToPos(FKind, NewValue);
end;

function TSCCustomControlScrollbar.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCCustomControlScrollbar.SetThumbLines(Value: TSCScrollThumbline);
begin
  if FThumbLines <> Value then
  begin
    FThumbLines := Value;
    if FVisible then DoChange;
  end;
end;

procedure TSCCustomControlScrollbar.DoRangeChanged;
begin
  if not (InUpdate or PosChangeLocked) and (FOwner <> nil) then
    FOwner.ScrollerRangeChanged(Self);
end;

procedure TSCCustomControlScrollbar.DoSizeChanged;
begin
  if not InUpdate and (FOwner <> nil) then
    FOwner.ScrollerSizeChanged(Self);
end;

procedure TSCCustomControlScrollbar.DoPositionChanged(OldPos,
  NewPos: Integer);
begin
  if not (InUpdate or PosChangeLocked) and (FOwner <> nil) then
    FOwner.ScrollerPositionChanged(Self, OldPos, NewPos);
end;

function TSCCustomControlScrollbar.GetFocused: Boolean;
begin
  Result := False;
  if FOwner is TSCCustomScrollControl then
    Result := TSCCustomScrollControl(FOwner).HasFocus;
end;

function TSCCustomControlScrollbar.GetHovered: Boolean;
begin
  Result := False;
  if FOwner is TSCCustomScrollControl then
    Result := TSCCustomScrollControl(FOwner).MouseInControl;
end;

procedure TSCCustomControlScrollbar.SetButtonExtra(Value: TSCScrollbarPart);
begin
  FButtonExtra.Assign(Value);
end;

function TSCCustomControlScrollbar.GetExtraBtnColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    if PressedPart = scspExtraButton then
    begin
      if HotPart = scspExtraButton then
        Result := GetOfficeXPDownedSelColor
      else
        Result := GetOfficeXPSelColor;
    end else
    if (PressedPart = scspNone) and (HotPart = scspExtraButton) then
      Result := GetOfficeXPSelColor
    else
      Result := GetOfficeXPBtnColor;
  end else
  begin
    Result := FButtonColors.FColor;
    if not Enabled then
      Result := FButtonColors.FDisabledColor
    else
    if PressedPart = scspExtraButton then
      Result := FButtonColors.FDownColor
    else
    if (PressedPart = scspNone) and (HotPart = scspExtraButton) then
      Result := FButtonColors.FHotColor;

    if Result = clNone then
      Result := clScrollBar;
  end;

  if FButtonColors.FBlend then
    Result := BlendedColor(Result, 24, 24, 24, True);
end;

function TSCCustomControlScrollbar.GetExtraBtnIconColor: TColor;
begin
  if FStyle = scssOffice2k then
  begin
    Result := clBtnText;
    if (PressedPart = scspExtraButton) and (HotPart = PressedPart) then
      Result := clHighlightText;
  end else
  begin
    Result := FIcons.FColor;
    if not Enabled then
      Result := FIcons.FDisabledColor
    else
    if PressedPart = scspExtraButton then
      Result := FIcons.FDownColor
    else
    if (PressedPart = scspNone) and (HotPart = scspExtraButton) then
      Result := FIcons.FHotColor;

    if Result = clNone then
      Result := clWindowText;
  end;    

  if FIcons.FBlend then
    Result := BlendedColor(Result, 24, 24, 24, True);
end;

function TSCCustomControlScrollbar.GetExtraButtonRect(R: TRect): TRect;
var
  Bs: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (FButtonSize = 0) or not FButtonExtra.Visible or IsRectEmpty(R) then
    Exit;

  Result := R;
  Bs := GetButtonSize(R);

  if FKind = scskHorizontal then
  begin
    if FButtonLayout in [scsbDefault, scsbRightBottom] then
      Dec(Result.Right, Bs);

    Result.Left := Result.Right - Bs;
  end else
  begin
    if FButtonLayout in [scsbDefault, scsbRightBottom] then
      Dec(Result.Bottom, Bs);

    Result.Top := Result.Bottom - Bs;
  end;
end;

function TSCCustomControlScrollbar.GetExtraButton: Boolean;
begin
  Result := FButtonExtra.Visible;
end;

procedure TSCCustomControlScrollbar.SetExtraButton(Value: Boolean);
begin
  FButtonExtra.Visible := Value;
end;

procedure TSCCustomControlScrollbar.ScrollMessage(var Msg: TWMScroll);
var
  Incr, FinalIncr, Count, CalcRange: Integer;
  CurrentTime, StartTime, ElapsedTime: Longint;
begin
  if FSmooth and (Msg.ScrollCode in [SB_LINEUP, SB_LINEDOWN, SB_PAGEUP,
    SB_PAGEDOWN, SB_THUMBPOSITION]) then
  begin
    case Msg.ScrollCode of
      SB_LINEUP, SB_LINEDOWN:
      begin
        Incr := FSmallChange div FLineDiv;
        FinalIncr := FSmallChange mod FLineDiv;
        Count := FLineDiv;
      end;
      SB_PAGEUP, SB_PAGEDOWN:
      begin
        Incr := GetPageUpDownSize;
          
        FinalIncr := Incr mod FPageDiv;
        Incr := Incr div FPageDiv;
        Count := FPageDiv;
      end;
      else begin
        Count := 0;
        Incr := 0;
        FinalIncr := 0;
      end;
    end;

    CurrentTime := 0;
    while Count > 0 do
    begin
      StartTime := GetCurrentTime;
      ElapsedTime := StartTime - CurrentTime;

      if ElapsedTime < FDelay then
        Sleep(FDelay - ElapsedTime);

      CurrentTime := StartTime;
        
      case Msg.ScrollCode of
        SB_LINEUP:
          SetPosition(FPosition - Incr);
        SB_LINEDOWN:
          SetPosition(FPosition + Incr);
        SB_PAGEUP:
          SetPosition(FPosition - Incr);
        SB_PAGEDOWN:
          SetPosition(FPosition + Incr);
      end;

      if FOwner <> nil then
        FOwner.Update;
          
      Dec(Count);
    end;
      
    if FinalIncr > 0 then
    begin
      case Msg.ScrollCode of
        SB_LINEUP:
          SetPosition(FPosition - FinalIncr);
        SB_LINEDOWN:
          SetPosition(FPosition + FinalIncr);
        SB_PAGEUP:
          SetPosition(FPosition - FinalIncr);
        SB_PAGEDOWN:
          SetPosition(FPosition + FinalIncr);
      end;
    end;
  end else
  begin
    CalcRange := GetCalcRange;
    if CalcRange < 0 then CalcRange := 0;

    case Msg.ScrollCode of
      SB_LINEUP:
        SetPosition(FPosition - FSmallChange);
      SB_LINEDOWN:
        SetPosition(FPosition + FSmallChange);
      SB_PAGEUP:
        SetPosition(FPosition - GetPageUpDownSize);
      SB_PAGEDOWN:
        SetPosition(FPosition + GetPageUpDownSize);
      SB_TOP: SetPosition(0);
      SB_BOTTOM:
        SetPosition(CalcRange);
      SB_THUMBTRACK:
      begin
        if Msg.Pos <= Self.Min then
          SetPosition(Self.Min)
        else
        if Msg.Pos >= Self.Max then
          SetPosition(Self.Max)
        else
        if Msg.Pos >= Self.Max - Self.PageSize then
          SetPosition(Self.Max);
      end;
      SB_THUMBPOSITION:
      begin
        if Msg.Pos <= Self.Min then
          SetPosition(Self.Min)
        else
        if Msg.Pos >= Self.Max then
          SetPosition(Self.Max)
        else
        if Msg.Pos >= Self.Max - Self.PageSize then
          SetPosition(Self.Max)
        else
          SetPosition(Msg.Pos);
      end;
    end;
  end;
end;

function TSCCustomControlScrollbar.GetPageUpDownSize: Integer;
begin
  Result := FLargeChange;
end;

function TSCCustomControlScrollbar.GetRange: Integer;
begin
  Result := GetMaximumValue - FMin;
  if Result < 0 then Result := 0;
end;

procedure TSCCustomControlScrollbar.SetRange(Value: Integer);
var
  P1, P2, Mx, Rg: Integer;
begin
  if Value < 0 then Value := 0;

  Rg := GetRange;
  if Rg <> Value then
  begin
    FMin := 0;
    FMax := Value;

    P1 := FPosition;
    Mx := GetMaximumValue;
    if FPosition > Mx then
      FPosition := Mx;

    P2 := FPosition;

    DoRangeChanged;
    DoPositionChanged;
    if P1 <> P2 then DoPositionChanged(P1, P2);
  end;
end;

function TSCCustomControlScrollbar.GetCalcRange: Integer;
begin
  Result := GetMaximumValue - FMin;
  if Result < 0 then Result := 0;
end;

function TSCCustomControlScrollbar.GetSensitivity: Integer;
begin
  Result := FSensitivity;
end;

{ TSCCustomScrollControl }

procedure TSCCustomScrollControl.AssignHittest(FromHt,
  ToHt: PSCScrollbarHittest);
begin
  if (FromHt = nil) or (ToHt = nil) then
    Exit;

  with ToHt^ do
  begin
    Kind := FromHt^.Kind;
    HitPart := FromHt^.HitPart;
    Enabled := FromHt^.Enabled;
    X := FromHt^.X;
    Y := FromHt^.Y;
  end;
end;

procedure TSCCustomScrollControl.CalculateBorder(var R: TRect);
var
  H, W: Integer;
begin
  inherited CalculateBorder(R);

  H := 0;
  if (FScrollbarHorz <> nil) and FScrollbarHorz.Visible and
    (FScrollbarType = scsbtSweet) then
  begin
    H := GetHorzScrollbarHeight;
    if H < 0 then H := 0;
  end;

  W := 0;
  if (FScrollbarVert <> nil) and FScrollbarVert.Visible and
    (FScrollbarType = scsbtSweet) then
  begin
    W := GetVertScrollbarWidth;
    if W < 0 then W := 0;
  end;

  Dec(R.Right, W);
  Dec(R.Bottom, H);
end;

function TSCCustomScrollControl.CanCaptureMouseOnNC(P: TPoint): Boolean;
var
  Ret: LongInt;
begin
  Ret := GetNCAreaAtPos(P);
  Result := (Ret >= SC_HTHSCROLLBAR) and (Ret <= SC_HTVSB_RIGHTSPARE);
end;

function TSCCustomScrollControl.CanScrollBars(AsLeft: Boolean): Boolean;
var
  Mx: Integer;
  Sb: TSCCustomControlScrollbar;
begin
  Result := False;

  if IsScrollingReady then
  begin
    Sb := FScrollbarHorz;
    if FDownTest.Kind = scshkVertical then
      Sb := FScrollbarVert;

    Mx := Sb.GetMaximumValue;

    with Sb do
      if FMin < Mx then
      begin
        if AsLeft then
          Result := (FPosition > FMin) and
            (FDownTest.HitPart in [scspExtraButton, scspLeftSpare, scspLeftButton])
        else
          Result := (FPosition < Mx) and
            (FDownTest.HitPart in [scspRightSpare, scspRightButton]);
      end;
  end;  
end;

constructor TSCCustomScrollControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUpdatingScrollbar := 0;
  FScrollbarHeight := -1;
  FScrollButtonsLayout := scsbDefault;
  FScrollbarStyle := scssDefault;
  FScrollbarType := scsbtSweet;
  FScrollbarThumbLines := sctlNone;
  FScrollbarHorz := GetScrollbarClass.Create(Self, scskHorizontal);
  FScrollbarVert := GetScrollbarClass.Create(Self, scskVertical);

  ResetHittest(@FHotTest);
  ResetHittest(@FDownTest);

  FScrollbars := GetControlScrollbarsClass.Create(Self);
end;

procedure TSCCustomScrollControl.CreateWnd;
begin
  inherited CreateWnd;

  if HandleAllocated then
  begin
    UpdateDefaultScrollbar(FScrollbarHorz);
    UpdateDefaultScrollbar(FScrollbarVert);
  end;
end;

destructor TSCCustomScrollControl.Destroy;
begin
  FreeAndNil(FScrollbarHorz);
  FreeAndNil(FScrollbarVert);
  FreeAndNil(FScrollbars);
  inherited Destroy;
end;

procedure TSCCustomScrollControl.DoScrollerPositionChanged(
  Kind: TSCScrollbarKind);
begin
  //
end;

procedure TSCCustomScrollControl.DoScrollerPositionChanging(
  Kind: TSCScrollbarKind; CurPos: Integer; var ScrollPos: Integer;
  var CanScroll: Boolean); 
begin
  //
end;

procedure TSCCustomScrollControl.FillScrollbarBack(DC: HDC; R: TRect);
var
  CR: TRect;
  MemDC: HDC;
  W, H: Integer;
  MemBitmap, OldBitmap: HBITMAP;
  NewBrush, LastBrush: HBRUSH;
begin
  if (DC = 0) or IsRectEmpty(R) then
    Exit;

  W := R.Right - R.Left;
  H := R.Bottom - R.Top;

  MemDC := CreateCompatibleDC(DC);
  try
    MemBitmap := CreateCompatibleBitmap(DC, W, H);
    try
      OldBitmap := SelectObject(MemDC, MemBitmap);
      try
        CR := R;
        OffsetRect(CR, -CR.Left, -CR.Top);

        NewBrush := CreateSolidBrush(ColorToRGB(GetBackgroundColor));
        LastBrush := SelectObject(MemDC, NewBrush);
        try
          FillRect(MemDC, CR, NewBrush);
        finally
          SelectObject(MemDC, LastBrush);
          DeleteObject(NewBrush);
        end;

        BitBlt(DC, R.Left, R.Top, W, H, MemDC, 0, 0, SRCCOPY);
      finally
        SelectObject(MemDC, OldBitmap);
      end;
    finally
      DeleteObject(MemBitmap);
    end;
  finally
    DeleteDC(MemDC);
  end;
end;

procedure TSCCustomScrollControl.FillScrollbarHittest(P: TPoint;
  Ht: PSCScrollbarHittest);
var
  R, Br, Pr, Tr: TRect;
begin
  if Ht = nil then
    Exit;

  ResetHittest(Ht);

  if (FScrollbarHorz <> nil) and FScrollbarHorz.Visible then
  begin
    R := GetHorzScrollbarRect;
    
    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      Ht^.Kind := scshkHorizontal;
      Ht^.Enabled := Self.Enabled and FScrollbarHorz.Enabled;

      Ht^.X := P.x;
      Ht^.Y := P.y;

      Pr := FScrollbarHorz.GetLeftButtonRect(R);
      if not IsRectEmpty(Pr) and PtInRect(Pr, P) then
      begin
        Ht^.HitPart := scspLeftButton;
        Ht^.Enabled := Ht^.Enabled and FScrollbarHorz.FButtonLeft.Enabled;

        Exit;
      end;

      Pr := FScrollbarHorz.GetRightButtonRect(R);
      if not IsRectEmpty(Pr) and PtInRect(Pr, P) then
      begin
        Ht^.HitPart := scspRightButton;
        Ht^.Enabled := Ht^.Enabled and FScrollbarHorz.FButtonRight.Enabled;

        Exit;
      end;

      Pr := FScrollbarHorz.GetExtraButtonRect(R);
      if not IsRectEmpty(Pr) and PtInRect(Pr, P) then
      begin
        Ht^.HitPart := scspExtraButton;
        Ht^.Enabled := Ht^.Enabled and FScrollbarHorz.FButtonExtra.Enabled;

        Exit;
      end;

      Br := FScrollbarHorz.GetBackRect(R);
      if not IsRectEmpty(Br) and PtInRect(Br, P) then
      begin
        Tr := FScrollbarHorz.GetThumbRect(R);
        if IsRectEmpty(Tr) then
          Exit;

        if PtInRect(Tr, P) then
        begin
          Ht^.HitPart := scspThumb;
          Exit;
        end;

        Pr := Br;
        Pr.Right := Tr.Left;

        if not IsRectEmpty(Pr) and PtInRect(Pr, P) then
        begin
          Ht^.HitPart := scspLeftSpare;
          Exit;
        end;

        Pr := Br;
        Pr.Left := Tr.Right;

        if not IsRectEmpty(Pr) and PtInRect(Pr, P) then
        begin
          Ht^.HitPart := scspRightSpare;
          Exit;
        end;
      end;

      Exit;
    end;
  end;

  if (FScrollbarVert <> nil) and FScrollbarVert.Visible then
  begin
    R := GetVertScrollbarRect;

    if not IsRectEmpty(R) and PtInRect(R, P) then
    begin
      Ht^.Enabled := Self.Enabled and FScrollbarVert.Enabled;
      Ht^.Kind := scshkVertical;

      Ht^.X := P.x;
      Ht^.Y := P.y;

      Pr := FScrollbarVert.GetLeftButtonRect(R);
      if not IsRectEmpty(Pr) and PtInRect(Pr, P) then
      begin
        Ht^.HitPart := scspLeftButton;
        Ht^.Enabled := Ht^.Enabled and FScrollbarVert.FButtonLeft.Enabled;

        Exit;
      end;

      Pr := FScrollbarVert.GetRightButtonRect(R);
      if not IsRectEmpty(Pr) and PtInRect(Pr, P) then
      begin
        Ht^.HitPart := scspRightButton;
        Ht^.Enabled := Ht^.Enabled and FScrollbarVert.FButtonRight.Enabled;

        Exit;
      end;

      Pr := FScrollbarVert.GetExtraButtonRect(R);
      if not IsRectEmpty(Pr) and PtInRect(Pr, P) then
      begin
        Ht^.HitPart := scspExtraButton;
        Ht^.Enabled := Ht^.Enabled and FScrollbarVert.FButtonExtra.Enabled;

        Exit;
      end;

      Br := FScrollbarVert.GetBackRect(R);
      if not IsRectEmpty(Br) and PtInRect(Br, P) then
      begin
        Tr := FScrollbarVert.GetThumbRect(R);
        if IsRectEmpty(Tr) then
          Exit;

        if PtInRect(Tr, P) then
        begin
          Ht^.HitPart := scspThumb;
          Exit;
        end;

        Pr := Br;
        Pr.Bottom := Tr.Top;

        if not IsRectEmpty(Pr) and PtInRect(Pr, P) then
        begin
          Ht^.HitPart := scspLeftSpare;
          Exit;
        end;

        Pr := Br;
        Pr.Top := Tr.Bottom;

        if not IsRectEmpty(Pr) and PtInRect(Pr, P) then
        begin
          Ht^.HitPart := scspRightSpare;
          Exit;
        end;
      end;

      Exit;
    end;
  end;
end;

function TSCCustomScrollControl.GetBackgroundColor: TColor;
begin
  Result := clScrollBar;
end;

function TSCCustomScrollControl.GetDistanceIncrement(
  Kind: TSCScrollbarKind; Dist: Integer): Integer;
var
  W, P, Mx: Integer;
  R, R1, R2: TRect;
  Sb: TSCCustomControlScrollbar;
begin
  Result := 0;

  Sb := FScrollbarHorz;
  if Kind = scskVertical then
    Sb := FScrollbarVert;

  Mx := Sb.GetMaximumValue;

  if (Dist = 0) or (Sb.FMin >= Mx) then
    Exit;

  if Kind = scskHorizontal then
    R := GetHorzScrollbarRect
  else R := GetVertScrollbarRect;

  if IsRectEmpty(R) then Exit;

  R1 := Sb.GetBackRect(R);
  if IsRectEmpty(R1) then Exit;

  R2 := Sb.GetThumbRect(R);
  OffsetRect(R2, R1.Left - R2.Left, R1.Top - R2.Top);

  if EqualRect(R1, R2) then Exit;

  if Kind = scskHorizontal then
  begin
    R1.Left := R2.Right;
    W := R1.Right - R1.Left;
  end else
  begin
    R1.Top := R2.Bottom;
    W := R1.Bottom - R1.Top;
  end;

  if W <= 0 then Exit;

  P := Abs(Dist);
  if P > W then
  begin
    Result := Mx - Sb.FMin;
    if Dist < 0 then
      Result := -Result;

    Exit;
  end;

  Result := Muldiv(Mx - Sb.FMin, P, W);
  if Dist < 0 then
    Result := -Result;
end;

function TSCCustomScrollControl.GetHorzScrollbarHeight: Integer;
begin
  Result := FScrollbarHeight;
  if Result < 0 then
    Result := scHorzScrollbarHeight;
end;

function TSCCustomScrollControl.GetHorzScrollbarRect: TRect;
var
  B, H: Integer;
  WR, CR: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if not (HandleAllocated and (FScrollbarHorz <> nil) and FScrollbarHorz.Visible and
    GetWindowRect(Handle, WR) and not IsRectEmpty(WR)) then
    Exit;

  OffsetRect(WR, -WR.Left, -WR.Top);

  CR := WR;
  CalculateBorder(CR);

  B := BorderWidth;
  if B > 0 then InflateRect(CR, -B, -B);

  H := GetHorzScrollbarHeight;
  if H > 0 then
  begin
    Result := CR;
    Result.Top := Result.Bottom;
    Inc(Result.Bottom, H);

    IntersectRect(Result, Result, WR);
  end;  
end;

function TSCCustomScrollControl.GetInheritedNCArea(P: TPoint): LongInt;
var
  Ht: TSCScrollbarHittest;
begin
  Result := inherited GetInheritedNCArea(P);

  if (Result = SC_HTNONE) and
    (((FScrollbarHorz <> nil) and FScrollbarHorz.Visible) or
     ((FScrollbarVert <> nil) and FScrollbarVert.Visible)) then
  begin
    P := ScreenToNC(P);
    Ht := GetScrollbarHittest(P);

    if Ht.Kind <> scshkNone then
      case Ht.HitPart of
        scspLeftButton:
        begin
          Result := SC_HTHSB_LEFTBTN;
          if Ht.Kind = scshkVertical then
            Result := SC_HTVSB_LEFTBTN;
        end;
        scspRightButton:
        begin
          Result := SC_HTHSB_RIGHTBTN;
          if Ht.Kind = scshkVertical then
            Result := SC_HTVSB_RIGHTBTN;
        end;
        scspExtraButton:
        begin
          Result := SC_HTHSB_EXTRABTN;
          if Ht.Kind = scshkVertical then
            Result := SC_HTVSB_EXTRABTN;
        end;
        scspThumb:
        begin
          Result := SC_HTHSB_THUMB;
          if Ht.Kind = scshkVertical then
            Result := SC_HTVSB_THUMB;
        end;
        scspLeftSpare:
        begin
          Result := SC_HTHSB_LEFTSPARE;
          if Ht.Kind = scshkVertical then
            Result := SC_HTVSB_LEFTSPARE;
        end;
        scspRightSpare:
        begin
          Result := SC_HTHSB_RIGHTSPARE;
          if Ht.Kind = scshkVertical then
            Result := SC_HTVSB_RIGHTSPARE;
        end;
        else
        begin
          Result := SC_HTHSCROLLBAR;
          if Ht.Kind = scshkVertical then
            Result := SC_HTVSCROLLBAR;
        end;
      end;
  end;
end;

function TSCCustomScrollControl.GetPositionAtPos(Kind: TSCScrollbarKind; X,
  Y: Integer; IncParts: Boolean): Integer;
var
  P: TPoint;
  R, CR, R2: TRect;
  I, M, W, Mx: Integer;
  Sb: TSCCustomControlScrollbar;
begin
  Sb := FScrollbarHorz;
  if Kind = scskVertical then
    Sb := FScrollbarVert;

  Mx := Sb.GetMaximumValue;  

  Result := Sb.FMin;
  if Sb.FMin >= Mx then Exit;

  Result := Sb.FPosition;

  if Kind = scskHorizontal then
    CR := GetHorzScrollbarRect
  else
    CR := GetVertScrollbarRect;

  if IsRectEmpty(CR) then Exit;

  R := Sb.GetBackRect(CR);
  if IsRectEmpty(R) then Exit;

  R2 := R;
  if Kind = scskHorizontal then
    R2.Right := R2.Left
  else
    R2.Bottom := R2.Top;

  P := Point(X, Y);

  if not IncParts then
  begin
    if not PtInRect(R, P) then
      Exit;

    if Sb.FThumb.Visible and (Sb.FThumbSize <> 0) then
    begin
      R2 := Sb.GetThumbRect(CR);
      if not IsRectEmpty(R2) and PtInRect(R2, P) then
        Exit;
    end;
  end;

  if Kind = scskHorizontal then
  begin
    if X <= R.Left then
    begin
      if not IncParts and (X < R.Left) then
        Exit;

      Result := Sb.FMin;
    end else
    if X >= R.Right then
    begin
      if not IncParts then
        Exit;

      Result := Mx;
    end else
    begin
      W := R.Right - R.Left;
      M := Mx - Sb.FMin;

      if M = 1 then
      begin
        R.Right := W div 2;

        if PtInRect(R, P) then
          Result := Sb.FMin
        else
          Result := Mx;

        Exit;
      end;

      Dec(X, R.Left);
      OffsetRect(R, -R.Left, 0);

      for I := 0 to M-1 do
      begin
        R.Left  := Muldiv(I, W, M);
        R.Right := Muldiv(I + 1, W, M);

        if (X >= R.Left) and (X < R.Right) then
        begin
          Result := Sb.FMin + I;
          Exit;
        end;
      end;
    end;
  end else
  begin
    if Y <= R.Top then
    begin
      if not IncParts and (Y < R.Top) then
        Exit;

      Result := Sb.FMin;
    end else
    if Y >= R.Bottom then
    begin
      if not IncParts then
        Exit;

      Result := Mx;
    end else
    begin
      W := R.Bottom - R.Top;
      M := Mx - Sb.FMin;

      if M = 1 then
      begin
        R.Bottom := W div 2;

        if PtInRect(R, P) then
          Result := Sb.FMin
        else
          Result := Mx;

        Exit;
      end;

      Dec(Y, R.Top);
      OffsetRect(R, 0, -R.Top);

      for I := 0 to M-1 do
      begin
        R.Left  := Muldiv(I, W, M);
        R.Right := Muldiv(I + 1, W, M);

        if (Y >= R.Top) and (Y < R.Bottom) then
        begin
          Result := Sb.FMin + I;
          Exit;
        end;
      end;
    end;
  end;
end;

function TSCCustomScrollControl.GetScrollbarClass: TSCCustomControlScrollbarClass;
begin
  Result := TSCControlScrollbar;
end;

function TSCCustomScrollControl.GetScrollbarHittest(P: TPoint): TSCScrollbarHittest;
begin
  FillScrollbarHittest(P, @Result);
end;

function TSCCustomScrollControl.GetScrollbarInfo(Kind: TSCScrollbarKind): TSCScrollInfo;
var
  Sb: TSCCustomControlScrollbar;
begin
  Sb := FScrollbarHorz;
  if Kind = scskVertical then
    Sb := FScrollbarVert;

  ResetScrollbarInfo(@Result);

  with Result do
  begin
    Min  := Sb.Min;
    Max  := Sb.Max;
    Page := Sb.PageSize;
    Pos  := Sb.Position;
    Range := Sb.Max - Sb.Min;
    ButtonSize  := Sb.ButtonSize;
    ThumbSize   := Sb.ThumbSize;
    LargeChange := Sb.LargeChange;
    SmallChange := Sb.SmallChange;
    Visible     := Sb.Visible;
    Enabled     := Sb.Enabled;
    Smooth      := Sb.Smooth;
    LeftButtonEnabled  := Sb.ButtonLeft.Enabled;
    LeftButtonVisible  := Sb.ButtonLeft.Visible;
    RightButtonEnabled := Sb.ButtonRight.Enabled;
    RightButtonVisible := Sb.ButtonRight.Visible;
    Tracking           := Sb.Track;
    ThumbEnabled       := Sb.Thumb.Enabled;
    ThumbVisible       := Sb.Thumb.Visible;
    TrimPageSize       := Sb.TrimPageSize;
  end;
end;

function TSCCustomScrollControl.GetVertScrollbarRect: TRect;
var
  B, W: Integer;
  WR, CR: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if not (HandleAllocated and (FScrollbarVert <> nil) and FScrollbarVert.Visible and
    GetWindowRect(Handle, WR) and not IsRectEmpty(WR)) then
    Exit;

  OffsetRect(WR, -WR.Left, -WR.Top);

  CR := WR;
  CalculateBorder(CR);

  B := BorderWidth;
  if B > 0 then InflateRect(CR, -B, -B);

  W := GetVertScrollbarWidth;
  if W > 0 then
  begin
    Result := CR;
    Result.Left := Result.Right;
    Inc(Result.Right, W);

    IntersectRect(Result, Result, WR);
  end;
end;

function TSCCustomScrollControl.GetVertScrollbarWidth: Integer;
begin
  Result := FScrollbarHeight;
  if Result < 0 then
    Result := scVertScrollbarWidth;
end;

function TSCCustomScrollControl.IsScrollingReady: Boolean;
begin
  Result := Enabled and FDownTest.Enabled and (FScrollbarType <> scsbtDefault) and
    (FDownTest.Kind <> scshkNone) and (FDownTest.Kind = FHotTest.Kind) and
    (FDownTest.HitPart <> scspNone) and (FDownTest.HitPart = FHotTest.HitPart)
end;

function TSCCustomScrollControl.IsScrollPart(HitPart: TSCScrollerHitPart): Boolean;
begin
  Result := HitPart in [scspExtraButton, scspLeftButton, scspLeftSpare,
    scspRightButton, scspRightSpare];
end;

procedure TSCCustomScrollControl.NCMouseDown(Button: TMouseButton;
  HitTest: LongInt; DblClk: Boolean; X, Y: Integer);
var
  OldHot, OldDown: TSCScrollbarHittest;
  Sb: TSCCustomControlScrollbar;
begin
  FMovingThumb  := True;
  FDownPoint    := Point(X, Y);
  FMovePoint    := Point(X, Y);
  FDownPosition := 0;

  OldHot  := FHotTest;
  OldDown := FDownTest;

  ResetHittest(@FDownTest);
  ResetHittest(@FHotTest);

  if HitTest = HTBORDER then
    FillScrollbarHittest(Point(X, Y), @FHotTest);

  StopScrollingBars;

  if FScrollbarType = scsbtSweet then
  begin
    if (HitTest = HTBORDER) and (Button = mbLeft) then
    begin
      AssignHittest(@FHotTest, @FDownTest);

      Sb := FScrollbarHorz;
      if FDownTest.Kind = scshkVertical then
        Sb := FScrollbarVert;

      if FDownTest.Kind <> scshkNone then
        FDownPosition := Sb.FPosition;

      if FHotTest.Enabled and IsScrollPart(FHotTest.HitPart) and
        CanScrollBars(FHotTest.HitPart in [scspExtraButton, scspLeftButton, scspLeftSpare]) then
        StartScrollingBars;
    end;

    if not (OldHot.Enabled and (OldHot.Enabled = FHotTest.Enabled) and
      OldDown.Enabled and (OldDown.Enabled = FDownTest.Enabled) and
      SameHittests(@OldHot, @FHotTest) and SameHittests(@OldDown, @FDownTest)) then
      RedrawScrollbars;
  end;
end;

procedure TSCCustomScrollControl.NCMouseEnter(var HitTest: Integer; X, Y: Integer);
var
  OldTest: TSCScrollbarHittest;
begin
  if FScrollbarType = scsbtSweet then
  begin
    OldTest := FHotTest;
    FillScrollbarHittest(Point(X, Y), @FHotTest);

    if (OldTest.Kind <> FHotTest.Kind) or
      (FHotTest.Kind <> scshkNone) and (OldTest.HitPart <> FHotTest.HitPart) then
    begin
      if OldTest.Kind <> FHotTest.Kind then
      begin
        if OldTest.Kind = scshkHorizontal then
          RedrawScrollbars(scsdkHorizontal)
        else
        if OldTest.Kind = scshkVertical then
          RedrawScrollbars(scsdkVertical);
      end;

      if FHotTest.Kind = scshkHorizontal then
        RedrawScrollbars(scsdkHorizontal)
      else
      if FHotTest.Kind = scshkVertical then
        RedrawScrollbars(scsdkVertical);
    end;

    if FHotTest.Kind in [scshkHorizontal, scshkVertical] then
      ResumeScrollingBars;
  end;
end;

procedure TSCCustomScrollControl.NCMouseLeave;
var
  OldTest: TSCScrollbarHittest;
begin
  if FScrollbarType = scsbtSweet then
  begin
    OldTest := FHotTest;

    ResetHittest(@FHotTest);
    PauseScrollingBars;

    if OldTest.Kind = scshkHorizontal then
      RedrawScrollbars(scsdkHorizontal)
    else
    if OldTest.Kind = scshkVertical then
      RedrawScrollbars(scsdkVertical);
  end;
end;

procedure TSCCustomScrollControl.NCMouseMove(HitTest: LongInt; X, Y: Integer);
var
  R, BkR, ThR: TRect;
  OldPoint: TPoint;
  P, OldP, Sense, Mx: Integer;
  OldHot: TSCScrollbarHittest;
  Sb: TSCCustomControlScrollbar;
begin
  if FScrollbarType = scsbtSweet then
  begin
    FMovingThumb := True;

    OldHot := FHotTest;
    FillScrollbarHittest(Point(X, Y), @FHotTest);

    if (FDownTest.Kind <> scshkNone) and (FDownTest.HitPart <> scspNone) then
    begin
      OldPoint := FMovePoint;
      FMovePoint := Point(X, Y);

      Sb := FScrollbarHorz;
      if FDownTest.Kind = scshkVertical then
        Sb := FScrollbarVert;

      Mx := Sb.GetMaximumValue;
      
      if Sb.FMin >= Mx then Exit;

      if FDownTest.Kind = scshkVertical then
        R := GetVertScrollbarRect
      else
        R := GetHorzScrollbarRect;

      BkR := Sb.GetBackRect(R);

      ThR := Rect(0, 0, 0, 0);
      if not IsRectEmpty(BkR) then
        ThR := Sb.GetThumbRect(R);

      if IsRectEmpty(BkR) or EqualRect(BkR, ThR) then
        Exit;

      Sense := Sb.GetSensitivity;

      case FDownTest.HitPart of
        scspThumb:
        begin
          OldP := Sb.FPosition;

          if FDownTest.Kind = scshkHorizontal then
          begin
            P := FDownPosition + GetDistanceIncrement(scskHorizontal,
              FMovePoint.x - FDownPoint.x);

            if (Sense > -1) and ((FMovePoint.y < R.Top - Sense) or
              (FMovePoint.y > R.Bottom + Sense)) then
            begin
              FMovePoint := FDownPoint;
            
              FMovingThumb := False;
              if Sb.FTrack then
                Sb.SetPosition(FDownPosition);

              if not Sb.FTrack or ((OldP <> Sb.FPosition) and
                (OldPoint.x <> FDownPoint.x) and (OldPoint.y <> FDownPoint.y)) then
                RedrawScrollbars(scsdkHorizontal);

              Exit;
            end;
          end else
          begin
            P := FDownPosition + GetDistanceIncrement(scskVertical,
              FMovePoint.y - FDownPoint.y);

            if (Sense > -1) and ((FMovePoint.x < R.Left - Sense) or
              (FMovePoint.x > R.Right + Sense)) then
            begin
              FMovePoint := FDownPoint;

              FMovingThumb := False;
              if Sb.FTrack then
                Sb.SetPosition(FDownPosition);

              if not Sb.FTrack or ((OldP <> Sb.FPosition) and
                (OldPoint.x <> FDownPoint.x) and (OldPoint.y <> FDownPoint.y)) then
                RedrawScrollbars(scsdkVertical);

              Exit;
            end;
          end;

          if P < Sb.FMin then P := Sb.FMin;
          if P > Mx then P := Mx;

          if Sb.FTrack then
            Sb.SetPosition(P);

          if (Sb.FPosition = OldP) and
            (((FDownTest.Kind = scshkHorizontal) and (FMovePoint.x <> OldPoint.x)) or
             ((FDownTest.Kind = scshkVertical) and (FMovePoint.y <> OldPoint.y))) then
            RedrawScrollbars;
        end;
        scspExtraButton, scspLeftButton,
        scspRightButton, scspLeftSpare, scspRightSpare:
        begin
          if OldHot.HitPart <> FHotTest.HitPart then
            RedrawScrollbars;
        end;
      end;
    end else
    begin
      FMovePoint := Point(X, Y);

      if OldHot.Kind <> FHotTest.Kind then
      begin
        if OldHot.Kind = scshkHorizontal then
          RedrawScrollbars(scsdkHorizontal)
        else
        if OldHot.Kind = scshkVertical then
          RedrawScrollbars(scsdkVertical);

        if FHotTest.Kind = scshkHorizontal then
          RedrawScrollbars(scsdkHorizontal)
        else
        if FHotTest.Kind = scshkVertical then
          RedrawScrollbars(scsdkVertical);
      end else
      if (OldHot.Kind <> scshkNone) and (OldHot.HitPart <> FHotTest.HitPart) then
      begin
        if FHotTest.Kind = scshkHorizontal then
          RedrawScrollbars(scsdkHorizontal)
        else
        if FHotTest.Kind = scshkVertical then
          RedrawScrollbars(scsdkVertical);
      end;
    end;
  end;
end;

procedure TSCCustomScrollControl.NCMouseUp(Button: TMouseButton;
  HitTest: LongInt; X, Y: Integer);
var
  P: Integer;
  OldHot, OldDown: TSCScrollbarHittest;
begin
  if FScrollbarType = scsbtSweet then
  begin
    FMovingThumb := False;

    P := 0;
    if FDownTest.Kind = scshkHorizontal then
      P := FDownPosition + GetDistanceIncrement(scskHorizontal, FMovePoint.x - FDownPoint.x)
    else
    if FDownTest.Kind = scshkVertical then
      P := FDownPosition + GetDistanceIncrement(scskVertical, FMovePoint.y - FDownPoint.y);

    FDownPoint := Point(-1, -1);
    FMovePoint := Point(-1, -1);

    FDownPosition := 0;

    OldHot  := FHotTest;
    OldDown := FDownTest;

    FHotTest  := GetScrollbarHittest(Point(X, Y));
    ResetHittest(@FDownTest);

    StopScrollingBars;
    if not ScrollingBars and (OldDown.HitPart = scspThumb) then
    begin
      if OldDown.Kind = scshkHorizontal then
        FScrollbarHorz.SetPosition(P)
      else
      if OldDown.Kind = scshkVertical then
        FScrollbarVert.SetPosition(P);
    end;

    if not SameHittests(@OldHot, @FHotTest) or
      not SameHittests(@FDownTest, @OldDown) then
      RedrawScrollbars;
  end;
end;

procedure TSCCustomScrollControl.PauseScrollingBars;
begin
  FScrolling := False;
end;

procedure TSCCustomScrollControl.RedrawScrollbars(Kind: TSCScrollbarDrawKind; OnDC: HDC);
var
  DC: HDC;
  WR, CR, R: TRect;
  B, H, W: Integer;
begin
  if not (HandleAllocated and GetWindowRect(Handle, WR) and
    not IsRectEmpty(WR) and (FScrollbarType = scsbtSweet)) then
    Exit;

  OffsetRect(WR, -WR.Left, -WR.Top);

  CR := WR;
  CalculateBorder(CR);

  B := BorderWidth;
  if B > 0 then InflateRect(CR, -B, -B);

  DC := OnDC;
  if OnDC = 0 then
    DC := GetWindowDC(Handle);

  try
    H := 0;
    if (FScrollbarHorz <> nil) and FScrollbarHorz.Visible then
    begin
      H := GetHorzScrollbarHeight;
      if H < 0 then H := 0;
    end;

    W := 0;
    if (FScrollbarVert <> nil) and FScrollbarVert.Visible then
    begin
      W := GetVertScrollbarWidth;
      if W < 0 then W := 0;
    end;

    if (W > 0) and (H > 0) then
    begin
      R := CR;

      R.Top := R.Bottom;
      Inc(R.Bottom, H);

      R.Left := R.Right;
      Inc(R.Right, W);

      FillScrollbarBack(DC, R);
    end;

    if (H > 0) and (Kind in [scsdkHorizontal, scsdkAll]) then
    begin
      R := CR;
      R.Top := R.Bottom;
      Inc(R.Bottom, H);

      IntersectRect(R, R, WR);
      FScrollbarHorz.BufferedPaint(DC, R);
    end;

    if (W > 0) and (Kind in [scsdkVertical, scsdkAll]) then
    begin
      R := CR;
      R.Left := R.Right;
      Inc(R.Right, W);

      IntersectRect(R, R, WR);
      FScrollbarVert.BufferedPaint(DC, R);
    end;
  finally
    if (DC <> 0) and (OnDC = 0) then
      ReleaseDC(Handle, DC);
  end;
end;

procedure TSCCustomScrollControl.ResetHittest(Ht: PSCScrollbarHittest);
begin
  if Ht <> nil then
    with Ht^ do
    begin
      Kind := scshkNone;
      HitPart := scspNone;
      Enabled := True;
      X := 0;
      Y := 0;
    end;
end;

procedure TSCCustomScrollControl.ResetScrollbarInfo(Si: PSCScrollInfo);
begin
  if Si <> nil then
    with Si^ do
    begin
      Min  := 0;
      Max  := 0;
      Page := 0;
      Pos  := 0;
      ButtonSize  := 0;
      ThumbSize   := 0;
      LargeChange := 0;
      SmallChange := 0;
      Visible     := False;
      Enabled     := False;
      LeftButtonEnabled  := True;
      LeftButtonVisible  := True;
      RightButtonEnabled := True;
      RightButtonVisible := True;
      Tracking           := True;
      ThumbEnabled       := True;
      ThumbVisible       := True;
      TrimPageSize       := True;
    end;
end;

procedure TSCCustomScrollControl.ResumeScrollingBars;
begin
  FScrolling := (FScrollTimer <> -1) and (FScrollbarType = scsbtSweet) and
    (CanScrollBars(True) or CanScrollBars(False));
end;

function TSCCustomScrollControl.SameHittests(Ht1, Ht2: PSCScrollbarHittest;
  CheckPos: Boolean): Boolean;
begin
  Result := False;
  if (Ht1 = nil) or (Ht2 = nil) then
    Exit;

  Result := (Ht1^.Kind = Ht2^.Kind) and (Ht1^.HitPart = Ht2^.HitPart) and
    (Ht1^.Enabled = Ht2^.Enabled);

  if Result and CheckPos then
    Result := (Ht1^.X = Ht2^.X) and (Ht1^.Y = Ht2^.Y);
end;

procedure TSCCustomScrollControl.ScrollbarTypeChanged;
begin
  //
end;

procedure TSCCustomScrollControl.ScrollControl;
var
  DrawKind: TSCScrollbarDrawKind;
  SbTest: TSCScrollbarHittest;
  Sb: TSCCustomControlScrollbar;
begin
  if (FScrollbarType = scsbtDefault) or
    not ScrollingBars or ScrollingPaused then
    Exit;

  Sb := FScrollbarHorz;
  DrawKind := scsdkHorizontal;

  if FDownTest.Kind = scshkVertical then
  begin
    Sb := FScrollbarVert;
    DrawKind := scsdkVertical;
  end;

  with Sb do
  begin
    if CanScrollBars(True) then
    begin
      if FDownTest.HitPart in [scspExtraButton, scspLeftButton] then
        SetPosition(Position - FSmallChange)
      else
        SetPosition(Position - FLargeChange);

      if FPosition <= FMin then
      begin
        SbTest := FDownTest;
        StopScrollingBars;

        FDownTest := SbTest;
        RedrawScrollbars(DrawKind);
      end;
    end else
    if CanScrollBars(False) then
    begin
      if PressedPart = scspRightButton then
        SetPosition(Position + FSmallChange)
      else
        SetPosition(Position + FLargeChange);

      if FPosition >= Sb.GetMaximumValue then
      begin
        SbTest := FDownTest;
        StopScrollingBars;

        FDownTest := SbTest;
        RedrawScrollbars(DrawKind);
      end;
    end;
  end;  
end;

procedure TSCCustomScrollControl.ScrollerChanged(Sender: TSCCustomControlScrollbar);
var
  ScrollCode: Integer;
  EnableCode: Integer;
begin
  if HandleAllocated and (Sender <> nil) then
  begin
    if (FScrollbarType = scsbtSweet) then
      RedrawScrollbars;

    if (FScrollbarType = scsbtDefault) then
    begin
      ScrollCode := SB_VERT;
      if Sender.Kind = scskHorizontal then ScrollCode := SB_HORZ;

      EnableCode := ESB_ENABLE_BOTH;
      if not Sender.Enabled then
        EnableCode := ESB_DISABLE_BOTH
      else begin
        if not Sender.FButtonLeft.FEnabled then
          EnableCode := EnableCode or ESB_DISABLE_LTUP;

        if not Sender.FButtonRight.FEnabled then
          EnableCode := EnableCode or ESB_DISABLE_RTDN;
      end;

      EnableScrollBar(Self.Handle, ScrollCode, EnableCode);
    end;
  end;
end;

procedure TSCCustomScrollControl.ScrollerDestroyed(Sender: TSCCustomControlScrollbar);
begin
  if not IsDestroying then
  begin
    if Sender = FScrollbarHorz then
      FScrollbarHorz := nil;
    if Sender = FScrollbarVert then
      FScrollBarVert := nil;

    DoBorderChanged;
  end;
end;

procedure TSCCustomScrollControl.ScrollerPositionChanged(
  Sender: TSCCustomControlScrollbar);
var
  R: TRect;
  P: TPoint;
  Message: TWMSetCursor;
begin
  if Sender <> nil then
  begin
    RedrawScrollbars;
    UpdateDefaultScrollbar(Sender);

    if HandleAllocated and GetCursorPos(P) then
    begin
      P := ScreenToClient(P);
      R := GetClientRect;

      if PtInRect(R, P) then
      begin
        with Message do
        begin
          Msg := WM_SETCURSOR;
          CursorWnd := Self.Handle;
          HitTest := HTCLIENT;
          MouseMsg := WM_MOUSEMOVE;
        end;

        PostMessage(Self.Handle, Message.Msg, TMessage(Message).WParam,
          TMessage(Message).LParam);
      end;
    end;

    DoScrollerPositionChanged(Sender.Kind);

    if Assigned(FOnScrollChangeEvent) then
      FOnScrollChangeEvent(Self, Sender.Kind);
  end;
end;

procedure TSCCustomScrollControl.ScrollerPositionChanging(
  Sender: TSCCustomControlScrollbar; var ScrollPos: Integer;
  var CanScroll: Boolean);
begin
  if Sender <> nil then
  begin
    DoScrollerPositionChanging(Sender.Kind, Sender.Position,
      ScrollPos, CanScroll);

    if Assigned(FOnScroll) then
      FOnScroll(Self, Sender.Kind, Sender.Position, ScrollPos, CanScroll);
  end;
end;

procedure TSCCustomScrollControl.ScrollerVisibleChanged(Sender: TSCCustomControlScrollbar);
begin
  if HandleAllocated and (Sender <> nil) then
  begin
    Perform(CM_BORDERCHANGED, 0, 0);

    if FScrollbarType = scsbtDefault then
    begin
      UpdateDefaultScrollbar(FScrollbarHorz);
      UpdateDefaultScrollbar(FScrollbarVert);

      Realign;
    end;
  end;
end;

function TSCCustomScrollControl.ScrollingBars: Boolean;
begin
  Result := FScrolling and (FScrollTimer <> -1) and
    (FScrollbarType = scsbtSweet) and (CanScrollBars(True) or
    CanScrollBars(False));
end;

function TSCCustomScrollControl.ScrollingPaused: Boolean;
begin
  Result := not FScrolling and (FScrollTimer <> -1) and
    (FScrollbarType = scsbtSweet) and (CanScrollBars(True) or
    CanScrollBars(False));
end;

procedure TSCCustomScrollControl.SetScrollbarHeight(Value: Integer);
begin
  if Value < 0 then Value := -1
  else
  if Value < 12 then Value := 12
  else
  if Value > 36 then Value := 36;

  if FScrollbarHeight <> Value then
  begin
    if FScrollbarHorz.FButtonSize = Value then
       FScrollbarHorz.FButtonSize := Value;

    if FScrollbarVert.FButtonSize = Value then
       FScrollbarVert.FButtonSize := Value;

    FScrollbarHeight := Value;

    if HandleAllocated and (FScrollbarType = scsbtSweet) and
      (FScrollbarHorz.Visible or FScrollbarVert.Visible) then
      DoBorderChanged;
  end;
end;

procedure TSCCustomScrollControl.SetScrollbarHorz(Value: TSCCustomControlScrollbar);
begin
  FScrollbarHorz.Assign(Value);
end;

procedure TSCCustomScrollControl.SetScrollbarStyle(Value: TSCScrollbarStyle);
begin
  FScrollbarHorz.FStyle := Value;
  FScrollbarVert.FStyle := Value;

  if FScrollbarStyle <> Value then
  begin
    FScrollbarStyle := Value;
    RedrawScrollbars;
  end;
end;

procedure TSCCustomScrollControl.SetScrollbarType(Value: TSCScrollbarType);
begin
  if FScrollbarType <> Value then
  begin
    FScrollbarType := Value;

    StopScrollingBars;
    ScrollbarTypeChanged;

    if HandleAllocated then
    begin
      RecreateWnd;
      Realign;
    end;
  end;
end;

procedure TSCCustomScrollControl.SetScrollbarThumbLines(Value: TSCScrollThumbline);
begin
  FScrollbarHorz.FThumbLines := Value;
  FScrollbarVert.FThumbLines := Value;

  if FScrollbarThumbLines <> Value then
  begin
    FScrollbarThumbLines := Value;
    RedrawScrollbars;
  end;
end;

procedure TSCCustomScrollControl.SetScrollbarVert(
  Value: TSCCustomControlScrollbar);
begin
  FScrollbarVert.Assign(Value);
end;

procedure TSCCustomScrollControl.SetScrollButtonsLayout(
  Value: TSCScrollButtonLayout);
begin
  FScrollbarHorz.FButtonLayout := Value;
  FScrollbarVert.FButtonLayout := Value;

  if FScrollButtonsLayout <> Value then
  begin
    FScrollButtonsLayout := Value;
    RedrawScrollbars;
  end;
end;

procedure TSCCustomScrollControl.SetScrollbarInfo(Kind: TSCScrollbarKind;
  Info: TSCScrollInfo);
var
  Si: TSCScrollInfo;
  Sb: TSCCustomControlScrollbar;
begin
  Si := GetScrollbarInfo(Kind);
  if (Info.Min <> Si.Min) or (Info.Max <> Si.Max) or (Info.Page <> Si.Page) or
    (Info.Pos <> Si.Pos) or (Info.Visible <> Si.Visible) or (Info.Tracking <> Si.Tracking) or
    (Info.Enabled <> Si.Enabled) or (Info.ButtonSize <> Si.ButtonSize) or
    (Info.ThumbSize <> Si.ThumbSize) or (Info.LargeChange <> Si.LargeChange) or
    (Info.SmallChange <> Si.SmallChange) or (Info.LeftButtonEnabled <> Si.LeftButtonEnabled) or
    (Info.LeftButtonVisible <> Si.LeftButtonVisible) or (Info.RightButtonEnabled <> Si.RightButtonEnabled) or
    (Info.RightButtonVisible <> Si.RightButtonEnabled) or (Info.ThumbEnabled <> Si.ThumbEnabled) or
    (Info.ThumbVisible <> Si.ThumbVisible) and (Info.TrimPageSize <> Si.TrimPageSize) then
  begin
    Sb := FScrollbarHorz;
    if Kind = scskVertical then
      Sb := FScrollbarVert;

    if Info.LargeChange < Low(TSCScrollbarInc) then
      Info.LargeChange := Low(TSCScrollbarInc);

    if Info.LargeChange > High(TSCScrollbarInc) then
      Info.LargeChange := High(TSCScrollbarInc);

    if Info.SmallChange < Low(TSCScrollbarInc) then
      Info.SmallChange := Low(TSCScrollbarInc);

    if Info.SmallChange > High(TSCScrollbarInc) then
      Info.SmallChange := High(TSCScrollbarInc);

    Sb.BeginUpdate;
    try
      with Sb do
      begin
        Min  := Info.Min;
        Max  := Info.Max;
        PageSize := Info.Page;
        Position := Info.Pos;
        ButtonSize  := Info.ButtonSize;
        ThumbSize   := Info.ThumbSize;
        LargeChange := Info.LargeChange;
        SmallChange := Info.SmallChange;
        Visible     := Info.Visible;
        Enabled     := Info.Enabled;
        Smooth      := Info.Smooth;
        ButtonLeft.Enabled  := Info.LeftButtonEnabled;
        ButtonLeft.Visible  := Info.LeftButtonVisible;
        ButtonRight.Enabled := Info.RightButtonEnabled;
        ButtonRight.Visible := Info.RightButtonVisible;
        Track         := Info.Tracking;
        Thumb.Enabled := Info.ThumbEnabled;
        Thumb.Visible := Info.ThumbVisible;
        TrimPageSize  := Info.TrimPageSize;
      end;
    finally
      Sb.EndUpdate;
    end;
  end;
end;

procedure TSCCustomScrollControl.StartScrollingBars;
var
  P: TPoint;
  SbTest: TSCScrollbarHittest;
begin
  if HandleAllocated and (CanScrollBars(False) or CanScrollBars(True)) then
  begin
    FKeyboardSpeed := scKeyBoardSpeed;

    if not Enabled then
    begin
      StopScrollingBars;
      Exit;
    end;

    if ScrollingPaused then
    begin
      ResumeScrollingBars;
      Exit;
    end;

    if not ScrollingBars then
    begin
      SbTest := FDownTest;

      StopScrollingBars;
      FDownTest := SbTest;

      FScrollTimer := SetTimer(Handle, SC_SCRLBAR_SCROLLTIMERID, scKeyBoardDelay, nil);
      FScrolling   := FScrollTimer <> -1;

      ScrollControl;
      if not GetCursorPos(P) then
        StopScrollingBars
      else begin
        P := Self.ScreenToNC(P);
        FHotTest := GetScrollbarHittest(P);
      end;
    end;
  end;
end;

procedure TSCCustomScrollControl.StopScrollingBars;
var
  HitPart: TSCScrollerHitPart;
  DrawKind: TSCScrollbarDrawKind;
begin
  FScrolling := False;

  DrawKind := scsdkAll;
  if FDownTest.Kind = scshkHorizontal then
    DrawKind := scsdkHorizontal
  else
  if FDownTest.Kind = scshkVertical then
    DrawKind := scsdkVertical;

  HitPart := scspNone;
  if FDownTest.Kind = scshkNone then
    HitPart := FDownTest.HitPart;
    
  ResetHittest(@FDownTest);

  if FScrollTimer <> -1 then
  begin
    FKeyboardSpeed := 0;

    if HandleAllocated then
      KillTimer(Handle, FScrollTimer);

    FScrollTimer := -1;
    if HitPart <> scspNone then
      RedrawScrollbars(DrawKind);
  end;
end;

procedure TSCCustomScrollControl.StopTracking;
begin
  StopScrollingBars;
  inherited StopTracking;
end;

procedure TSCCustomScrollControl.UpdateDefaultScrollbar(
  Sender: TSCCustomControlScrollbar);
var
  ScrollCode: Integer;
  SINew: TScrollInfo;
begin
  if HandleAllocated and (FUpdatingScrollbar = 0) and
    (Sender <> nil) and (FScrollbarType = scsbtDefault) then
  begin
    Inc(FUpdatingScrollbar);
    try
      ScrollCode := SB_VERT;
      if Sender.Kind = scskHorizontal then ScrollCode := SB_HORZ;

      // update scrollbar
      SINew := GetDefaultScrollInfo(Sender.Kind);

      ShowScrollBar(Self.Handle, ScrollCode,
        Sender.Visible and (SINew.nMax > SINew.nMin) and
        (SINew.nMax - Integer(SINew.nPage) > SINew.nMin));

      if Sender.Visible then
        SetScrollInfo(Self.Handle, ScrollCode, SINew, True);
    finally
      Dec(FUpdatingScrollbar);
    end;
  end;
end;

procedure TSCCustomScrollControl.WMNCHitTest(var Message: TWMNCHitTest);
var
  R: TRect;
  P: TPoint;
begin
  inherited;

  if not IsDesigning then
  begin
    P := ScreenToNC(SmallPointToPoint(Message.Pos));

    if (Message.Result = HTNOWHERE) and HandleAllocated then
    begin
      if FDownTest.Kind <> scshkNone then
      begin
        Message.Result := HTBORDER;
        Exit;
      end;

      if (FScrollbarType = scsbtSweet) then
      begin
        if (FScrollbarHorz <> nil) and FScrollbarHorz.Visible then
        begin
          R := GetHorzScrollbarRect;

          if not IsRectEmpty(R) and PtInRect(R, P) then
          begin
            Message.Result := HTBORDER;
            Exit;
          end;
        end;

        if (FScrollbarVert <> nil) and FScrollbarVert.Visible then
        begin
          R := GetVertScrollbarRect;

          if not IsRectEmpty(R) and PtInRect(R, P) then
          begin
            Message.Result := HTBORDER;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSCCustomScrollControl.WMSettingChange(var Message: TMessage);
begin
  inherited;

  if HandleAllocated then
  begin
    FScrollbarHorz.RearrangeDefaults;
    FScrollbarVert.RearrangeDefaults;

    if FScrollbarType = scsbtSweet then
      RecreateWnd;
  end;
end;

procedure TSCCustomScrollControl.WMTimer(var Message: TWMTimer);
var
  P: TPoint;
  Ps, Mx: Integer;
  DrawKind: TSCScrollbarDrawKind;
  Sb: TSCCustomControlScrollbar;
begin
  inherited;

  if HandleAllocated and ScrollingBars and
    (Message.TimerID = SC_SCRLBAR_SCROLLTIMERID) then
  begin
    if FKeyboardSpeed = 0 then
      FKeyboardSpeed := scKeyBoardSpeed;

    if FKeyboardSpeed = 0 then
      FKeyboardSpeed := 30;

    if (FScrollbarType = scsbtDefault) or
      not (Enabled and GetCursorPos(P)) then
    begin
      StopScrollingBars;
      Exit;
    end;

    if IsScrollingReady then
    begin
      Sb := FScrollbarHorz;
      DrawKind := scsdkHorizontal;

      if FDownTest.Kind = scshkVertical then
      begin
        Sb := FScrollbarVert;
        DrawKind := scsdkVertical;
      end;

      Ps := Sb.Position;

      P := Self.ScreenToNC(P);
      FHotTest := GetScrollbarHittest(P);

      ScrollControl;

      if FScrollTimer <> -1 then
        KillTimer(Handle, FScrollTimer);

      Mx := Sb.GetMaximumValue;

      if (Ps = Sb.Position) and (Sb.FMin < Mx) and (Ps > Sb.FMin) and
        (Ps < Mx) and not SameHittests(@FDownTest, @FHotTest) then
        RedrawScrollbars(DrawKind, 0);

      FScrollTimer := SetTimer(Handle, SC_SCRLBAR_SCROLLTIMERID, FKeyboardSpeed, nil);
      FScrolling := FScrollTimer <> -1;
    end;  
  end;
end;

function TSCCustomScrollControl.IsHorzScrollBarVisible: Boolean;
begin
  Result := HandleAllocated and FScrollbarHorz.Visible and
    (FScrollbarType = scsbtSweet);
end;

function TSCCustomScrollControl.IsVertScrollBarVisible: Boolean;
begin
  Result := HandleAllocated and FScrollbarVert.Visible and
    (FScrollbarType = scsbtSweet);
end;

function TSCCustomScrollControl.CanScrollToPos(Kind: TSCScrollbarKind;
  var NewValue: Integer): Boolean;
begin
  Result := True;
end;

function TSCCustomScrollControl.GetControlScrollbarsClass: TSCControlCustomScrollbarsClass;
begin
  Result := TSCControlScrollbars;
end;

procedure TSCCustomScrollControl.SetScrollbars(Value: TSCControlCustomScrollbars);
begin
  FScrollbars.Assign(Value);
end;

procedure TSCCustomScrollControl.EnabledChanged;
begin
  StopScrollingBars;
  inherited EnabledChanged;
end;

procedure TSCCustomScrollControl.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCCustomScrollControl then
  begin
    with TSCCustomScrollControl(Source) do
    begin
      Self.Scrollbars := Scrollbars;
      Self.ScrollbarHeight := ScrollbarHeight;
      Self.ScrollbarHorz := ScrollbarHorz;
      Self.ScrollbarVert := ScrollbarVert;
      Self.ScrollbarStyle := ScrollbarStyle;
      Self.ScrollbarThumbLines := ScrollbarThumbLines;
      Self.ScrollButtonsLayout := ScrollButtonsLayout;
    end;
  end;
end;

procedure TSCCustomScrollControl.ScrollerPositionChanged(
  Sender: TSCCustomControlScrollbar; OldPos, NewPos: Integer);
begin
  if Sender <> nil then
    DoScrollerPositionChanged(Sender.Kind, OldPos, NewPos);
end;

procedure TSCCustomScrollControl.DoScrollerPositionChanged(
  Kind: TSCScrollbarKind; OldPos, NewPos: Integer);
begin
  //
end;

procedure TSCCustomScrollControl.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if HandleAllocated and (FScrollbarType = scsbtSweet) and
    ((FScrollbarHorz.Style = scssFlatHover) or (FScrollbarVert.Style = scssFlatHover)) then
    RedrawScrollbars;
end;

procedure TSCCustomScrollControl.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if HandleAllocated and (FScrollbarType = scsbtSweet) and
    ((FScrollbarHorz.Style = scssFlatHover) or (FScrollbarVert.Style = scssFlatHover)) then
    RedrawScrollbars;
end;

procedure TSCCustomScrollControl.CMFocusChanged(
  var Message: TCMFocusChanged);
begin
  inherited;
  if HandleAllocated and (FScrollbarType = scsbtSweet) and
    ((FScrollbarHorz.Style = scssFlatHover) or (FScrollbarVert.Style = scssFlatHover)) then
    RedrawScrollbars;
end;

procedure TSCCustomScrollControl.SetScrollbarExtraButton(Value: Boolean);
begin
  if FScrollbarExtraButton <> Value then
  begin
    FScrollbarExtraButton := Value;

    FScrollbarHorz.FButtonExtra.Visible := Value;
    FScrollbarVert.FButtonExtra.Visible := Value;
  end;
end;

procedure TSCCustomScrollControl.WMHScroll(var Message: TWMHScroll);
begin
  if (Message.ScrollBar = 0) and FScrollbarHorz.Visible then
    FScrollbarHorz.ScrollMessage(Message) else
    inherited;
end;

procedure TSCCustomScrollControl.WMVScroll(var Message: TWMVScroll);
begin
  if (Message.ScrollBar = 0) and FScrollBarVert.Visible then
    FScrollBarVert.ScrollMessage(Message) else
    inherited;
end;

function TSCCustomScrollControl.GetDefaultScrollInfo(
  Kind: TSCScrollbarKind): TScrollInfo;
var
  Scrollbar: TSCCustomControlScrollbar;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.cbSize := SizeOf(Result);

  Result.fMask := SIF_ALL;
  Result.nMin  := 0;
  Result.nMax  := 0;
  Result.nPage := 0;
  Result.nPos  := 0;

  Scrollbar := FScrollbarHorz;
  if Kind = scskVertical then Scrollbar := FScrollbarVert;

  if (Scrollbar <> nil) and Scrollbar.Visible then
  begin
    Result.nMin  := Scrollbar.Min;
    Result.nMax  := Scrollbar.Max - 1;
    Result.nPage := Scrollbar.PageSize;
    Result.nPos  := Scrollbar.Position;

    if (Kind = scskVertical) and (FScrollbarHorz <> nil) and
      FScrollbarHorz.Visible then
      Result.nMax := Result.nMax - 1;
  end;
end;

{ TSCScrollbarPart }

procedure TSCScrollbarPart.Assign(Source: TPersistent);
begin
  if Source is TSCScrollbarPart then
  begin
    with TSCScrollbarPart(Source) do
    begin
      Self.FBlend := Blend;
      Self.FColor := Color;
      Self.FDisabledColor := DisabledColor;
      Self.FDownColor := DownColor;
      Self.FEnabled := Enabled;
      Self.FHotColor := HotColor;
      Self.FVisible := Visible;
    end;
    DoChanged;
  end else
    inherited Assign(Source);
end;

constructor TSCScrollbarPart.Create(AOwner: TSCCustomControlScrollbar);
begin
  inherited Create;
  FOwner := AOwner;
  FColor := clScrollBar;
  FDisabledColor := clScrollBar;
  FDownColor := clScrollBar;
  FEnabled := True;
  FHotColor := clScrollBar;
  FVisible := True;
end;

procedure TSCScrollbarPart.DoChanged;
begin
  if FOwner is TSCCustomControlScrollbar then
    TSCCustomControlScrollbar(FOwner).PartChanged(Self);
end;

function TSCScrollbarPart.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCScrollbarPart.SetBlend(Value: Boolean);
begin
  if FBlend <> Value then
  begin
    FBlend := Value;
    DoChanged;
  end;
end;

procedure TSCScrollbarPart.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    DoChanged;
  end;
end;

procedure TSCScrollbarPart.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    DoChanged;
  end;
end;

procedure TSCScrollbarPart.SetDownColor(Value: TColor);
begin
  if FDownColor <> Value then
  begin
    FDownColor := Value;
    DoChanged;
  end;
end;

procedure TSCScrollbarPart.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    DoChanged;
  end;
end;

procedure TSCScrollbarPart.SetHotColor(Value: TColor);
begin
  if FHotColor <> Value then
  begin
    FHotColor := Value;
    DoChanged;
  end;
end;

procedure TSCScrollbarPart.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    DoChanged;
  end;
end;

{ TSCScrollbarIcons }

constructor TSCScrollbarIcons.Create(AOwner: TSCCustomControlScrollbar);
begin
  inherited Create(AOwner);
  FColor := clWindowText;
  FDisabledColor := clGrayText;
  FDownColor := clWindowText;
  FHotColor := clWindowText;
end;

{ TSCControlScrollbar }

constructor TSCControlScrollbar.Create(AOwner: TSCCustomControl;
  AKind: TSCScrollbarKind);
begin
  inherited Create(AOwner, AKind);
  FVisible := False;
end;

procedure TSCControlScrollbar.DrawBack(C: TCanvas; InRect: TRect);
var
  Cl, C1: TColor;
  BR, R, R1: TRect;
begin
  if (C = nil) or IsRectEmpty(InRect) then
    Exit;

  R  := InRect;
  Cl := GetBackColor;
  if FStyle = scssOffice12 then
  begin
    Cl := Background.Color;
    if Cl = clNone then
      Cl := clScrollBar;

    Cl := SCCommon.scBlendColor(Cl, 12);
  end;

  with C do
  begin
    Brush.Color := Cl;
    FillRect(R);
  end;

  BR := GetBackRect(R);

  if FStyle = scssOffice12 then
  begin
    C1 := SCCommon.scBlendColor(Cl, 36);

    if FKind = scskHorizontal then
    begin
      R1 := InRect;
      R1.Bottom := R1.Top + ((R1.Bottom - R1.Top) div 5);

      if not IsRectEmpty(R1) then
        scDrawGradient(C, R1, scgTopToBottom, C1, Cl);
    end else
    begin
      R1 := InRect;
      R1.Right := R1.Left + ((R1.Right - R1.Left) div 5);

      if not IsRectEmpty(R1) then
        scDrawGradient(C, R1, scgLeftToRight, C1, Cl);
    end;
  end;
end;

procedure TSCControlScrollbar.DrawBorder(C: TCanvas; R: TRect);
var
  Cl: TColor;
begin
  if (C = nil) or IsRectEmpty(R) then Exit;

  if FStyle = scssOffice12 then
    DrawOffice12Border(C, R)
  else
  if FStyle = scssMac then
  begin
    Cl := Get3DDkShadowOf(GetBackColor);
    scFrame3D(C, R, Cl, Cl, 1, 0);
  end else
  if FStyle = scssMetal then
  begin
    Cl := GetBtnShadowOf(GetBackColor);
    scFrame3D(C, R, Cl, Cl, 1, 0);
  end;
end;

procedure TSCControlScrollbar.DrawExtraButton(C: TCanvas; InRect: TRect);
var
  R: TRect;
  W, H, I: Integer;
  OffP, P: TPoint;
  C1, C2, C3, C4: TColor;

  procedure DrawButtonIcon;
  begin
    OffP := Point(0, 0);
    if (PressedPart = scspExtraButton) and (HotPart = PressedPart) and
      not (FStyle in [scssOffice2k, scssXP, scssXP2, scssFlatEx])  then
    begin
      OffP := Point(1, 1);

      if FStyle = scssMac then
      begin
        if FKind = scskHorizontal then
          OffP := Point(-1, 0)
        else
          OffP := Point(0, -1);
      end;
    end;

    if C2 <> C1 then
    begin
      W := 6; H := 3;

      I := R.Right - R.Left;
      if I > R.Bottom - R.Top then
        I := R.Bottom - R.Top;

      if I < 16 then
      begin
        W := 4; H := 2;
        if I < 12 then
        begin
          W := 2; H := 1;
        end;
      end;

      if FKind = scskHorizontal then
      begin
        P.x := R.Left + ((R.Right - R.Left) div 2) - 2 + OffP.x;
        P.y := R.Top +  ((R.Bottom - R.Top) div 2) + OffP.y;

        scDrawRightSlider(C, P, W, H, sctsMac, False, C2, C2);
      end else
      begin
        P.x := R.Left + ((R.Right - R.Left) div 2) + OffP.x;
        P.y := R.Top +  ((R.Bottom - R.Top) div 2) - 2 + OffP.y;

        scDrawDownSlider(C, P, W, H, sctsMac, False, C2, C2);
      end;
    end;
  end;

begin
  if (C = nil) or IsRectEmpty(InRect) or
    not FButtonLeft.Visible then
    Exit;

  R := GetExtraButtonRect(InRect);
  if IsRectEmpty(R) then
    Exit;

  C1 := GetExtraBtnColor;
  C2 := GetExtraBtnIconColor;

  with C do
  begin
    Brush.Style := bsSolid;
    Brush.Color := C1;

    FillRect(R);
  end;

  DrawButtonIcon;

  case FStyle of
    scssDefault, scssDefaultEx:
    begin
      if (HotPart = PressedPart) and (PressedPart = scspExtraButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssFlat:
    begin
      if (HotPart = PressedPart) and (PressedPart = scspExtraButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssFlatEx:
    begin
      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssFlatHover:
    begin
      if (HotPart = PressedPart) and (PressedPart = scspExtraButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      if Focused or Hovered then
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssMetal:
    begin
      InflateRect(R, -1, -1);

      if (HotPart = PressedPart) and
        (PressedPart = scspExtraButton) then
      begin
        C3 := C1;
        // C4 := GetBtnHighlightOf(C1);
        C4 := SCCommon.scBlendColor(C1, 48);
      end else
      begin
        C3 := SCCommon.scBlendColor(C1, 48);
        // C3 := GetBtnHighlightOf(C1);
        C4 := C1;
      end;

      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C3, C4, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssOffice2k:
    begin
      C3 := clHighlight;
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssOffice12:
    begin
      DrawBack(C, R);
      DrawOffice12Border(C, R);

      if HotPart <> scspNone then
        scDrawOffice12Face(Kind, C, R, C1, GetBackColor, True,
          PressedPart = scspExtraButton, HotPart = scspExtraButton,
          True, False);

      DrawButtonIcon;
    end;
    scss3D, scss3DX:
    begin
      scDraw3DFace(Kind, C, R, C1, GetBackColor, FStyle = scss3DX,
        PressedPart = scspExtraButton, HotPart = scspExtraButton);

      DrawButtonIcon;
    end;
    scssNew, scssNewX:
    begin
      scDrawNewFace(Kind, C, R, C1, GetBackColor, FStyle = scssNewX,
        PressedPart = scspExtraButton, HotPart = scspExtraButton);

      DrawButtonIcon;
    end;
    scssXP, scssXP2:
    begin
      DrawXPFace(C, R, C1, GetBackColor, False, PressedPart = scspExtraButton,
        HotPart = scspExtraButton);

      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C2;

        W := 4;

        I := R.Right - R.Left;
        if I > R.Bottom - R.Top then
          I := R.Bottom - R.Top;

        if I < 14 then
        begin
          W := 3;
          if I < 8 then
            W := 2;
        end;

        if FKind = scskHorizontal then
        begin
          Dec(P.x);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x + (W - 1), P.y - (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y + W);

            Inc(P.x);
          end;
        end else
        begin
          Dec(P.y);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x - (W - 1), P.y + (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y + W);

            Inc(P.y);
          end;
        end;
      end;
    end;
    scssMac:
    begin
      if (HotPart = PressedPart) and (PressedPart = scspExtraButton) then
      begin
        C2 := SCCommon.scBlendColor(C1, -48);
        C3 := SCCommon.scBlendColor(C1, 48);
      end else
      begin
        C2 := SCCommon.scBlendColor(C1, 48);
        C3 := SCCommon.scBlendColor(C1, -48);
      end;

      InflateRect(R, -1, -1);
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C2, C3, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := Get3DDkShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
  end;
end;

procedure TSCControlScrollbar.DrawLeftButton(C: TCanvas; InRect: TRect);
var
  R: TRect;
  W, H, I: Integer;
  OffP, P: TPoint;
  C1, C2, C3, C4: TColor;

  procedure DrawButtonIcon;
  begin
    OffP := Point(0, 0);
    if (PressedPart = scspLeftButton) and (HotPart = PressedPart) and
      not (FStyle in [scssOffice2k, scssXP, scssXP2, scssFlatEx])  then
    begin
      OffP := Point(1, 1);

      if FStyle = scssMac then
      begin
        if FKind = scskHorizontal then
          OffP := Point(-1, 0)
        else
          OffP := Point(0, -1);
      end;
    end;

    if C2 <> C1 then
    begin
      W := 6; H := 3;

      I := R.Right - R.Left;
      if I > R.Bottom - R.Top then
        I := R.Bottom - R.Top;

      if I < 16 then
      begin
        W := 4; H := 2;
        if I < 12 then
        begin
          W := 2; H := 1;
        end;
      end;

      if FKind = scskHorizontal then
      begin
        P.x := R.Left + ((R.Right - R.Left) div 2) - 2 + OffP.x;
        P.y := R.Top +  ((R.Bottom - R.Top) div 2) + OffP.y;

        scDrawRightSlider(C, P, W, H, sctsMac, False, C2, C2);
      end else
      begin
        P.x := R.Left + ((R.Right - R.Left) div 2) + OffP.x;
        P.y := R.Top +  ((R.Bottom - R.Top) div 2) - 2 + OffP.y;

        scDrawDownSlider(C, P, W, H, sctsMac, False, C2, C2);
      end;
    end;
  end;

begin
  if (C = nil) or IsRectEmpty(InRect) or
    not FButtonLeft.Visible then
    Exit;

  R := GetLeftButtonRect(InRect);
  if IsRectEmpty(R) then
    Exit;

  C1 := GetLeftBtnColor;
  C2 := GetLeftBtnIconColor;

  with C do
  begin
    Brush.Style := bsSolid;
    Brush.Color := C1;

    FillRect(R);
  end;

  DrawButtonIcon;

  case FStyle of
    scssDefault, scssDefaultEx:
    begin
      if (HotPart = PressedPart) and (PressedPart = scspLeftButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssFlat:
    begin
      if (HotPart = PressedPart) and (PressedPart = scspLeftButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssFlatEx:
    begin
      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssFlatHover:
    begin
      if (HotPart = PressedPart) and (PressedPart = scspLeftButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      if Focused or Hovered then
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssMetal:
    begin
      InflateRect(R, -1, -1);

      if (HotPart = PressedPart) and
        (PressedPart = scspLeftButton) then
      begin
        C3 := C1;
        // C4 := GetBtnHighlightOf(C1);
        C4 := SCCommon.scBlendColor(C1, 48);
      end else
      begin
        C3 := SCCommon.scBlendColor(C1, 48);
        // C3 := GetBtnHighlightOf(C1);
        C4 := C1;
      end;

      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C3, C4, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssOffice2k:
    begin
      C3 := clHighlight;
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssOffice12:
    begin
      DrawBack(C, R);
      DrawOffice12Border(C, R);

      if HotPart <> scspNone then
        scDrawOffice12Face(Kind, C, R, C1, GetBackColor, True,
          PressedPart = scspLeftButton, HotPart = scspLeftButton,
          True, False);

      DrawButtonIcon;
    end;
    scss3D, scss3DX:
    begin
      scDraw3DFace(Kind, C, R, C1, GetBackColor, FStyle = scss3DX,
        PressedPart = scspLeftButton, HotPart = scspLeftButton);

      DrawButtonIcon;
    end;
    scssNew, scssNewX:
    begin
      scDrawNewFace(Kind, C, R, C1, GetBackColor, FStyle = scssNewX,
        PressedPart = scspLeftButton, HotPart = scspLeftButton);

      DrawButtonIcon;
    end;
    scssXP, scssXP2:
    begin
      DrawXPFace(C, R, C1, GetBackColor, False, PressedPart = scspLeftButton,
        HotPart = scspLeftButton);

      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C2;

        W := 4;

        I := R.Right - R.Left;
        if I > R.Bottom - R.Top then
          I := R.Bottom - R.Top;

        if I < 14 then
        begin
          W := 3;
          if I < 8 then
            W := 2;
        end;

        if FKind = scskHorizontal then
        begin
          Dec(P.x);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x + (W - 1), P.y - (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y + W);

            Inc(P.x);
          end;
        end else
        begin
          Dec(P.y);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x - (W - 1), P.y + (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y + W);

            Inc(P.y);
          end;
        end;
      end;
    end;
    scssMac:
    begin
      if (HotPart = PressedPart) and (PressedPart = scspLeftButton) then
      begin
        C2 := SCCommon.scBlendColor(C1, -48);
        C3 := SCCommon.scBlendColor(C1, 48);
      end else
      begin
        C2 := SCCommon.scBlendColor(C1, 48);
        C3 := SCCommon.scBlendColor(C1, -48);
      end;

      InflateRect(R, -1, -1);
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C2, C3, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := Get3DDkShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
  end;
end;

procedure TSCControlScrollbar.DrawOffice12Border(C: TCanvas; R: TRect);
var
  Cl: TColor;
begin
  if (FStyle = scssOffice12) and (C <> nil) and not IsRectEmpty(R) then
  begin
    Cl := FBackground.FColor;
    if not Enabled then
      Cl := FBackground.FDisabledColor;

    if Cl = clNone then
      Cl := clScrollBar;

    Cl := SCCommon.scBlendColor(Cl, 12);

    with C do
    begin
      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Pen.Color := Cl;
      Pen.Width := 1;
    end;

    if FKind = scskHorizontal then
    begin
      C.MoveTo(R.Left, R.Top);
      C.LineTo(R.Right, R.Top);

      // C.MoveTo(R.Left, R.Bottom - 1);
      // C.LineTo(R.Right, R.Bottom - 1);
    end else
    begin
      C.MoveTo(R.Left, R.Top);
      C.LineTo(R.Left, R.Bottom);

      // C.MoveTo(R.Right - 1, R.Top);
      // C.LineTo(R.Right - 1, R.Bottom);
    end;
  end;
end;

procedure TSCControlScrollbar.DrawRightButton(C: TCanvas; InRect: TRect);
var
  R: TRect;
  W, H, I: Integer;
  OffP, P: TPoint;
  C1, C2, C3, C4: TColor;

  procedure DrawButtonIcon;
  begin
    OffP := Point(0, 0);
    if (PressedPart = scspRightButton) and (HotPart = PressedPart) and
      not (FStyle in [scssOffice2k, scssXP, scssXP2, scssFlatEx]) then
    begin
      OffP := Point(1, 1);

      if FStyle = scssMac then
      begin
        if FKind = scskHorizontal then
          OffP := Point(1, 0)
        else
          OffP := Point(0, 1);
      end;
    end;

    if C2 <> C1 then
    begin
      W := 6; H := 3;

      I := R.Right - R.Left;
      if I > R.Bottom - R.Top then
        I := R.Bottom - R.Top;

      if I < 16 then
      begin
        W := 4; H := 2;
        if I < 12 then
        begin
          W := 2; H := 1;
        end;
      end;

      if FKind = scskHorizontal then
      begin
        P.x := R.Left + ((R.Right - R.Left) div 2) + 1 + OffP.X;
        P.y := R.Top +  ((R.Bottom - R.Top) div 2) + OffP.y;

        scDrawLeftSlider(C, P, W, H, sctsMac, False, C2, C2);
      end else
      begin
        P.x := R.Left + ((R.Right - R.Left) div 2) + OffP.x;
        P.y := R.Top +  ((R.Bottom - R.Top) div 2) + 1 + OffP.y;

        scDrawUpSlider(C, P, W, H, sctsMac, False, C2, C2);
      end;
    end;
  end;

begin
  if (C = nil) or IsRectEmpty(InRect) or
    not FButtonRight.Visible then
    Exit;

  R := GetRightButtonRect(InRect);
  if IsRectEmpty(R) then
    Exit;

  C1 := GetRightBtnColor;
  C2 := GetRightBtnIconColor;

  with C do
  begin
    Brush.Style := bsSolid;
    Brush.Color := C1;

    FillRect(R);
  end;

  DrawButtonIcon;

  case FStyle of
    scssDefault, scssDefaultEx:
    begin
      if (HotPart = PressedPart) and (PressedPart = scspRightButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssFlat:
    begin
      if (HotPart = PressedPart) and (PressedPart = scspRightButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssFlatEx:
    begin
      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssFlatHover:
    begin
      if (HotPart = PressedPart) and (PressedPart = scspRightButton) then
      begin
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C3, 1, 0);
      end else
      if Focused or Hovered then
      begin
        C3 := C1;
        C4 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);

        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end else
      begin
        C3 := GetBtnHighlightOf(C1);
        C4 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C3, C4, 1, 0);
      end;
    end;
    scssMetal:
    begin
      InflateRect(R, -1, -1);

      if (HotPart = PressedPart) and
        (PressedPart = scspRightButton) then
      begin
        C3 := C1;
        // C4 := GetBtnHighlightOf(C1);
        C4 := SCCommon.scBlendColor(C1, 48);
      end else
      begin
        C3 := SCCommon.scBlendColor(C1, 48);
        // C3 := GetBtnHighlightOf(C1);
        C4 := C1;
      end;

      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C3, C4, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssOffice2k:
    begin
      C3 := clHighlight;
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssOffice12:
    begin
      DrawBack(C, R);
      DrawOffice12Border(C, R);

      if HotPart <> scspNone then
        scDrawOffice12Face(Kind, C, R, C1, GetBackColor, True,
          PressedPart = scspRightButton, HotPart = scspRightButton,
          True, False);

      DrawButtonIcon;
    end;
    scss3D, scss3DX:
    begin
      scDraw3DFace(Kind, C, R, C1, GetBackColor, FStyle = scss3DX,
        PressedPart = scspRightButton, HotPart = scspRightButton);

      DrawButtonIcon;
    end;
    scssNew, scssNewX:
    begin
      scDrawNewFace(Kind, C, R, C1, GetBackColor, FStyle = scssNewX,
        PressedPart = scspRightButton, HotPart = scspRightButton);

      DrawButtonIcon;
    end;
    scssXP, scssXP2:
    begin
      DrawXPFace(C, R, C1, GetBackColor, False, PressedPart = scspRightButton,
        HotPart = scspRightButton);

      with C do
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C2;

        W := 4;

        I := R.Right - R.Left;
        if I > R.Bottom - R.Top then
          I := R.Bottom - R.Top;

        if I < 14 then
        begin
          W := 3;
          if I < 8 then
            W := 2;
        end;

        if FKind = scskHorizontal then
        begin
          Dec(P.x);

          for I := 0 to W - 2 do
          begin
            MoveTo(P.x - (W - 1), P.y - (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x - W, P.y + W);

            Inc(P.x);
          end;
        end else
        begin
          Dec(P.y);
          for I := 0 to W - 2 do
          begin
            MoveTo(P.x - (W - 1), P.y - (W - 1));
            LineTo(P.x, P.y);
            LineTo(P.x + W, P.y - W);

            Inc(P.y);
          end;
        end;
      end;
    end;
    scssMac:
    begin
      if (HotPart = PressedPart) and (PressedPart = scspRightButton) then
      begin
        C2 := SCCommon.scBlendColor(C1, -48);
        C3 := SCCommon.scBlendColor(C1, 48);
      end else
      begin
        C2 := SCCommon.scBlendColor(C1, 48);
        C3 := SCCommon.scBlendColor(C1, -48);
      end;

      InflateRect(R, -1, -1);
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C2, C3, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := Get3DDkShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
  end;
end;

procedure TSCControlScrollbar.DrawScrollBack(C: TCanvas; InRect: TRect);
var
  Cl, C1: TColor;
  BR, R, R1, R2: TRect;
begin
  if (C = nil) or IsRectEmpty(InRect) then
    Exit;

  R  := InRect;
  Cl := GetBackColor;

  DrawBack(C, R);

  BR := GetBackRect(R);

  if FStyle = scssSports then
  begin
    R1 := BR;

    if not IsRectEmpty(R1) then
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := GetBtnShadowOf(Cl);

        FillRect(R1);

        scFrame3D(C, R1, Get3DDkShadowOf(Cl), GetBtnHighlightOf(Cl), 1, 0);
      end;
  end else
  if (HotPart = PressedPart) and (PressedPart in [scspLeftSpare, scspRightSpare]) then
  begin
    R2 := GetThumbRect(R);
    R1 := R;

    if not IsRectEmpty(R2) then
    begin
      if FKind = scskHorizontal then
      begin
        if PressedPart = scspLeftSpare then
        begin
          if R2.Left >= R.Left then
            R1.Right := R2.Left;
        end else
        if R2.Right <= R.Right then
          R1.Left := R2.Right;
      end else
      begin
        if PressedPart = scspLeftSpare then
        begin
          if R2.Top >= R.Top then
            R1.Bottom := R2.Top;
        end else
        if R2.Bottom <= R.Bottom then
          R1.Top := R2.Bottom;
      end;
    end;

    if FStyle <> scssMetal then
    begin
      Cl := FBackground.FDownColor;
      if FStyle = scssOffice2k then
        Cl := GetOfficeXPDownedSelColor
      else
      if FBackground.FBlend then
        Cl := BlendedColor(GetOfficeXPBtnColorOf(FBackground.FDownColor), 24, 24, 24, True);

      with C do
      begin
        Brush.Color := Cl;
        FillRect(R1);
      end;

      if FStyle = scssOffice12 then
      begin
        C1 := SCCommon.scBlendColor(Cl, 36);

        if FKind = scskHorizontal then
        begin
          R2 := R1;
          R2.Bottom := R2.Top + ((R2.Bottom - R2.Top) div 5);

          if not IsRectEmpty(R2) then
            scDrawGradient(C, R2, scgTopToBottom, C1, Cl);

          R2 := R1;
          R2.Top := R2.Bottom - ((R2.Bottom - R2.Top) div 5);

          if not IsRectEmpty(R2) then
            scDrawGradient(C, R2, scgTopToBottom, Cl, C1);
        end else
        begin
          R2 := R1;
          R2.Right := R2.Left + ((R2.Right - R2.Left) div 5);

          if not IsRectEmpty(R2) then
            scDrawGradient(C, R2, scgLeftToRight, C1, Cl);

          R2 := R1;
          R2.Left := R2.Right - ((R2.Right - R2.Left) div 5);

          if not IsRectEmpty(R2) then
            scDrawGradient(C, R2, scgLeftToRight, Cl, C1);
        end;
      end;
    end;
  end;

  if FSlideLine then
  begin
    R1 := BR;

    if FKind = scskHorizontal then
    begin
      InflateRect(R1, -4, 0);

      if R1.Bottom - R1.Top > 3 then
      begin
        R1.Top := R1.Top + ((R1.Bottom - R1.Top) div 2);
        R1.Bottom := R1.Top + 1;

        if not IsRectEmpty(R1) then
          with C do
          begin
            Pen.Style := psSolid;

            Pen.Color := GetBtnShadowOf(Cl);
            MoveTo(R1.Left, R1.Top);
            LineTo(R1.Right, R1.Top);

            Pen.Color := GetBtnHighlightOf(Cl);
            MoveTo(R1.Left, R1.Bottom);
            LineTo(R1.Right, R1.Bottom);
          end;
      end;
    end else
    begin
      InflateRect(R1, 0, -4);

      if R1.Right - R1.Left > 3 then
      begin
        R1.Left := R1.Left + ((R1.Right - R1.Left) div 2);
        R1.Right := R1.Left + 1;

        if not IsRectEmpty(R1) then
          with C do
          begin
            Pen.Style := psSolid;

            Pen.Color := GetBtnShadowOf(Cl);
            MoveTo(R1.Left, R1.Top);
            LineTo(R1.Left, R1.Bottom);

            Pen.Color := GetBtnHighlightOf(Cl);
            MoveTo(R1.Right, R1.Top);
            LineTo(R1.Right, R1.Bottom);
          end;
      end;
    end;
  end;
end;

procedure TSCControlScrollbar.DrawThumb(C: TCanvas; InRect: TRect);
var
  R1, R: TRect;
  Rgn, PrevRgn: HRgn;
  HasPrevRgn: Boolean;
  C1, C2, C3, Cl: TColor;
  I, J, K, L, X, Y, SR: Integer;
begin
  if (C = nil) or IsRectEmpty(InRect) or
    not (Enabled and FThumb.Visible) then
    Exit;

  R := GetThumbRect(InRect);
  if IsRectEmpty(R) then
    Exit;

  C1 := GetThumbColor;

  with C do
  begin
    R1 := R;
    if FStyle = scssSports then
      InflateRect(R1, -1, -1);

    Brush.Color := C1;
    FillRect(R1);
  end;

  if FThumbLines <> sctlNone then
    DrawThumbLines(C, R, C1);

  case FStyle of
    scssDefault:
    begin
      C2 := C1;
      C3 := Get3DDkShadowOf(C1);
      scFrame3D(C, R, C2, C3, 1, 0);

      C2 := GetBtnHighlightOf(C1);
      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C2, C3, 1, 0);
    end;
    scssDefaultEx:
    begin
      if PressedPart = scspThumb then
      begin
        C2 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C2, 1, 0);
      end else
      begin
        C2 := C1;
        C3 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C2, C3, 1, 0);

        C2 := GetBtnHighlightOf(C1);
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C3, 1, 0);
      end;
    end;
    scssFlat:
    begin
      if PressedPart = scspThumb then
      begin
        C2 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C2, 1, 0);
      end else
      begin
        C2 := GetBtnHighlightOf(C1);
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C3, 1, 0);
      end;
    end;
    scssFlatEx:
    begin
      C2 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C2, C2, 1, 0);
    end;
    scssFlatHover:
    begin
      if PressedPart = scspThumb then
      begin
        C2 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C2, 1, 0);
      end else
      if Focused or Hovered then
      begin
        C2 := C1;
        C3 := Get3DDkShadowOf(C1);
        scFrame3D(C, R, C2, C3, 1, 0);

        C2 := GetBtnHighlightOf(C1);
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C3, 1, 0);
      end else
      begin
        C2 := GetBtnHighlightOf(C1);
        C3 := GetBtnShadowOf(C1);
        scFrame3D(C, R, C2, C3, 1, 0);
      end;
    end;
    scssOffice2k:
    begin
      C2 := clHighlight;
      scFrame3D(C, R, C2, C2, 1, 0);
    end;
    scssOffice12:
    begin
      scDrawOffice12Face(Kind, C, R, C1, GetBackColor, False,
        PressedPart = scspThumb, (HotPart = scspThumb) or (PressedPart = scspThumb),
        True, True);

      DrawThumbLines(C, R, C1);
    end;
    scss3D, scss3DX:
    begin
      scDraw3DFace(Kind, C, R, C1, GetBackColor, FStyle = scss3DX,
        PressedPart = scspThumb, PressedPart = scspThumb);

      if (FThumbLines <> sctlNone) or (FStyle = scssMac) then
        DrawThumbLines(C, R, C1);
    end;
    scssSports:
    begin
      R1 := R;
      InflateRect(R1, -1, -1);

      if not IsRectEmpty(R1) then
        scFrame3D(C, R1, GetBtnHighlightOf(C1), Get3DDkShadowOf(C1), 1, 0);
    end;
    scssNew, scssNewX:
    begin
      scDrawNewFace(Kind, C, R, C1, GetBackColor, FStyle = scssNewX,
        PressedPart = scspThumb, PressedPart = scspThumb);

      if (FThumbLines <> sctlNone) or (FStyle = scssMac) then
        DrawThumbLines(C, R, C1);
    end;
    scssXP, scssXP2:
    begin
      DrawXPFace(C, R, C1, GetBackColor, True, PressedPart = scspThumb,
        (HotPart = scspThumb) and (PressedPart = scspNone));

      InflateRect(R, -2, -2);
      if FKind = scskHorizontal then
      begin
        InflateRect(R, -2, 0);
        if PressedPart = scspThumb then
          OffsetRect(R, 0, 1);
      end else
      begin
        InflateRect(R, 0, -2);
        if PressedPart = scspThumb then
          OffsetRect(R, 1, 0);
      end;

      DrawThumbLines(C, R, C1);
    end;
    scssMac:
    begin
      C2 := SCCommon.scBlendColor(C1, 48);
      C3 := SCCommon.scBlendColor(C1, -48);

      InflateRect(R, -1, -1);
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C2, C3, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := Get3DDkShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
    scssMetal:
    begin
      InflateRect(R, -3, -3);
      if not IsRectEmpty(R) then
      begin
        PrevRgn := CreateRectRgn(0, 0, 0, 0);
        try
          SR := GetClipRgn(C.Handle, PrevRgn);
          HasPrevRgn := SR > 0;

          if SR > -1 then
          begin
            if not HasPrevRgn then
            begin
              SR := IntersectClipRect(C.Handle, R.Left, R.Top, R.Right, R.Bottom);
              
              DeleteObject(PrevRgn);
              PrevRgn := 0;
            end else
            begin
              Rgn := CreateRectRgnIndirect(R);
              try
                SR := ExtSelectClipRgn(C.Handle, Rgn, RGN_AND);
              finally
                DeleteObject(Rgn);
              end;
            end;
            
            try
              if SR <> NULLREGION then
              begin
                // C2 := GetBtnHighlightOf(C1);
                C2 := SCCommon.scBlendColor(C1, 48);
                C3 := GetBtnShadowOf(C1);

                C.Pen.Width := 1;
                C.Pen.Style := psSolid;

                if FKind = scskHorizontal then
                begin
                  K := R.Right - R.Left;
                  L := (R.Bottom - R.Top) div 4;

                  for I := 0 to K do
                  begin
                    if (I = K) and not Odd(I) then
                      Break;

                    for J := 0 to L do
                    begin
                      X := I;
                      Y := 4*J;

                      Cl := C2;
                      if Odd(X) then
                      begin
                        Cl := C3;
                        Inc(Y);

                        if Odd((X - 1) div 2) then
                          Inc(Y, 2);
                      end else
                      if Odd(X div 2) then
                        Inc(Y, 2);

                      C.Pen.Color := Cl;

                      Inc(X, R.Left);
                      Inc(Y, R.Top);

                      C.MoveTo(X, Y);
                      C.LineTo(X + 1, Y);
                    end;
                  end;  
                end else
                begin
                  K := R.Bottom - R.Top;
                  L := (R.Right - R.Left) div 4;

                  for I := 0 to K do
                  begin
                    if (I = K) and not Odd(I) then
                      Break;

                    for J := 0 to L do
                    begin
                      X := 4*J;
                      Y := I;

                      Cl := C2;
                      if Odd(Y) then
                      begin
                        Cl := C3;
                        Inc(X);

                        if Odd((Y - 1) div 2) then
                          Inc(X, 2);
                      end else
                      if Odd(Y div 2) then
                        Inc(X, 2);

                      C.Pen.Color := Cl;

                      Inc(X, R.Left);
                      Inc(Y, R.Top);

                      C.MoveTo(X, Y);
                      C.LineTo(X + 1, Y);
                    end;
                  end;
                end;
              end;
            finally
              if HasPrevRgn then
                SelectClipRgn(C.Handle, PrevRgn)
              else
                SelectClipRgn(C.Handle, 0);
            end;
          end;
        finally
          if PrevRgn > 0 then
            DeleteObject(PrevRgn);
        end;
      end;

      InflateRect(R, 3, 3);

      // C2 := GetBtnHighlightOf(C1);
      C2 := SCCommon.scBlendColor(C1, 48);
      C3 := C1;

      InflateRect(R, -1, -1);
      if not IsRectEmpty(R) then
      begin
        scFrame3D(C, R, C2, C3, 1, 0);
        InflateRect(R, 1, 1);
      end;

      InflateRect(R, 1, 1);

      C3 := GetBtnShadowOf(C1);
      scFrame3D(C, R, C3, C3, 1, 0);
    end;
  end;
end;

procedure TSCControlScrollbar.DrawThumbLines(C: TCanvas; R: TRect; Cl: TColor);
var
  R1, R2: TRect;
  C1, C2, C3: TColor;
  Tl: TSCScrollThumbline;
  I, J, Cnt, L, T, X, Y, H: Integer;
begin
  if (C = nil) or IsRectEmpty(R) or
    (FThumbLines = sctlNone) or (FStyle = scssMetal) then
    Exit;

  R1 := R;
  InflateRect(R1, -3, -3);
  if IsRectEmpty(R1) then Exit;

  C1 := GetBtnHighlightOf(Cl);
  C2 := GetBtnShadowOf(Cl);

  Tl := FThumbLines;
  if (Tl = sctlNone) and (FStyle = scssOffice12) then
    Tl := sctlDash;

  if Tl in [sctlLowered, sctlDots] then
  begin
    C3 := C1;
    C1 := C2;
    C2 := C3;
  end;

  if FKind = scskHorizontal then
  begin
    if Tl = sctlDash then
    begin
      if FStyle = scssOffice12 then
        C1 := C2;
        
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C1;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C1;
      end;

      X := (R1.Right - R1.Left) div 2;
      if X > 4 then X := 4;

      H := R1.Bottom - R1.Top - 2;
      if H > 16 then H := 16;

      L := R1.Left + ((R1.Right - R1.Left - (2*X - 1)) div 2);
      T := R1.Top + ((R1.Bottom - R1.Top - H) div 2);

      for I := 0 to X - 1 do
      begin
        R2 := Rect(L, T, L + 1, T + H);
        C.FillRect(R2);
        Inc(L, 2);
      end;
      
      Exit;
    end;

    if Tl = sctlWideDash then
    begin
      if FStyle = scssOffice12 then
        C1 := C2;
        
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C1;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C1;
      end;

      X := (R1.Right - R1.Left) div 4;
      if X > 4 then X := 4;

      H := R1.Bottom - R1.Top - 2;
      if H > 16 then H := 16;

      L := R1.Left + ((R1.Right - R1.Left - (4*X - 2)) div 2);
      T := R1.Top + ((R1.Bottom - R1.Top - H) div 2);

      for I := 0 to X - 1 do
      begin
        R2 := Rect(L, T, L + 2, T + H);
        C.FillRect(R2);
        Inc(L, 4);
      end;
      
      Exit;
    end;
    
    if Tl = sctlDots then
    begin
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C1;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C2;
      end;

      X := (R1.Right - R1.Left) div 4;
      if X > 5 then X := 5;

      Y := (R1.Bottom - R1.Top) div 4;
      if Y > 3 then Y := 3;

      L := R1.Left + ((R1.Right - R1.Left) div 2) + (1 - 2*X);
      for I := 0 to X-1 do
      begin
        T := R1.Top + ((R1.Bottom - R1.Top) div 2) + (1 - 2*Y);

        for J := 0 to Y-1 do
        begin
          R2 := Rect(L, T, L + 2, T + 2);
          with C do
          begin
            Brush.Color := C1;
            FillRect(R2);

            Inc(R2.Left);
            Inc(R2.Top);

            Brush.Color := C2;
            FillRect(R2);
          end;

          Inc(T, 4);
        end;

        Inc(L, 4);
      end;

      Exit;
    end;

    Cnt := (R1.Right - R1.Left) div 2;
    if Cnt > 4 then Cnt := 4
    else
    if Cnt <= 0 then Exit;

    R1.Left  := R1.Left + ((R1.Right - R1.Left) div 2);
    R1.Right := R1.Left;

    Dec(R1.Left, Cnt);
    Inc(R1.Right, Cnt);

    with C do
    begin
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := C1;
      for I := 0 to Cnt-1 do
      begin
        MoveTo(R1.Left + 2*I, R1.Top);
        LineTo(R1.Left + 2*I, R1.Bottom - 1);
      end;

      Pen.Color := C2;
      for I := 0 to Cnt-1 do
      begin
        MoveTo(R1.Left + 1 + 2*I, R1.Top + 1);
        LineTo(R1.Left + 1 + 2*I, R1.Bottom);
      end;
    end;
  end else
  begin
    if Tl = sctlDash then
    begin
      if FStyle = scssOffice12 then
        C1 := C2;

      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C1;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C1;
      end;

      Y := (R1.Bottom - R1.Top) div 2;
      if Y > 4 then Y := 4;

      H := R1.Right - R1.Left - 2;
      if H > 16 then H := 16;

      L := R1.Left + ((R1.Right - R1.Left - H) div 2);
      T := R1.Top + ((R1.Bottom - R1.Top - (2*Y - 1)) div 2);

      for I := 0 to Y - 1 do
      begin
        R2 := Rect(L, T, L + H, T + 1);
        C.FillRect(R2);
        Inc(T, 2);
      end;

      Exit;
    end;

    if Tl = sctlWideDash then
    begin
      if FStyle = scssOffice12 then
        C1 := C2;

      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C1;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C1;
      end;

      Y := (R1.Bottom - R1.Top) div 4;
      if Y > 4 then Y := 4;

      H := R1.Right - R1.Left - 2;
      if H > 16 then H := 16;

      L := R1.Left + ((R1.Right - R1.Left - H) div 2);
      T := R1.Top + ((R1.Bottom - R1.Top - (4*Y - 2)) div 2);

      for I := 0 to Y - 1 do
      begin
        R2 := Rect(L, T, L + H, T + 2);
        C.FillRect(R2);
        Inc(T, 4);
      end;

      Exit;
    end;

    if Tl = sctlDots then
    begin
      with C do
      begin
        Brush.Style := bsSolid;
        Brush.Color := C1;

        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Width := 1;
        Pen.Color := C2;
      end;

      X := (R1.Right - R1.Left) div 4;
      if X > 3 then X := 3;

      Y := (R1.Bottom - R1.Top) div 4;
      if Y > 5 then Y := 5;

      L := R1.Left + ((R1.Right - R1.Left) div 2) + (1 - 2*X);
      for I := 0 to X-1 do
      begin
        T := R1.Top + ((R1.Bottom - R1.Top) div 2) + (1 - 2*Y);

        for J := 0 to Y-1 do
        begin
          R2 := Rect(L, T, L + 2, T + 2);
          with C do
          begin
            Brush.Color := C1;
            FillRect(R2);

            Inc(R2.Left);
            Inc(R2.Top);

            Brush.Color := C2;
            FillRect(R2);
          end;

          Inc(T, 4);
        end;

        Inc(L, 4);
      end;

      Exit;
    end;

    Cnt := (R1.Bottom - R1.Top) div 2;
    if Cnt > 4 then Cnt := 4
    else
    if Cnt <= 0 then Exit;

    R1.Top  := R1.Top + ((R1.Bottom - R1.Top) div 2);
    R1.Bottom := R1.Top;

    Dec(R1.Top, Cnt);
    Inc(R1.Bottom, Cnt);

    with C do
    begin
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
      Pen.Width := 1;

      Pen.Color := C1;
      for I := 0 to Cnt-1 do
      begin
        MoveTo(R1.Left,      R1.Top + 2*I);
        LineTo(R1.Right - 1, R1.Top + 2*I);
      end;

      Pen.Color := C2;
      for I := 0 to Cnt-1 do
      begin
        MoveTo(R1.Left + 1, R1.Top + 1 + 2*I);
        LineTo(R1.Right,    R1.Top + 1 + 2*I);
      end;
    end;
  end;
end;

procedure TSCControlScrollbar.DrawXPFace(C: TCanvas; R: TRect; Cl,
  BkCl: TColor; IsThumb, IsDown, IsHot: Boolean);
begin
  if FStyle = scssXP then
    scDrawXPFace(FKind, C, R, Cl, BkCl, IsDown, IsHot)
  else
    scDrawXPFace2(FKind, C, R, Cl, BkCl, IsThumb, IsDown, IsHot);
end;

procedure TSCControlScrollbar.Paint(Canvas: TCanvas; R: TRect);
begin
  if (Canvas <> nil) and not IsRectEmpty(R) then
  begin
    DrawScrollBack(Canvas, R);
    DrawBorder(Canvas, R);
    DrawLeftButton(Canvas, R);
    DrawRightButton(Canvas, R);
    DrawExtraButton(Canvas, R);
    DrawThumb(Canvas, R);            
  end;
end;

{ TSCScrollbarBkground }

constructor TSCScrollbarBkground.Create(AOwner: TSCCustomControlScrollbar);
begin
  inherited Create(AOwner);
  FBlend := True;
  FDownColor := cl3DDkShadow;
end;

{ TSCControlBorderProps }

procedure TSCControlBorderProps.Assign(Source: TPersistent);
begin
  if Source is TSCControlBorderProps then
  begin
    with TSCControlBorderProps(Source) do
    begin
      Self.Border := Border;
      Self.Color := Color;
      Self.ExDraw := ExDraw;
      Self.FlatColor := FlatColor;
      Self.FocusColor := FocusColor;
      Self.FlatInnerColor := FlatInnerColor;
      Self.InnerBorder := InnerBorder;
      Self.Width := Width;
    end;
  end else
  if Source is TSCStyleBorderProps then
  begin
    with TSCStyleBorderProps(Source) do
    begin
      Self.Border := Border;
      Self.Color := Color;
      Self.ExDraw := ExDraw;
      Self.FlatColor := FlatColor;
      Self.FocusColor := FocusColor;
      Self.FlatInnerColor := FlatInnerColor;
      Self.InnerBorder := InnerBorder;
      Self.Width := Width;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCControlBorderProps.Create(AOwner: TSCCustomControl);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCControlBorderProps.GetBorder: TSCControlBorder;
begin
  Result := sccbNone;
  if FOwner <> nil then Result := FOwner.Border;
end;

function TSCControlBorderProps.GetBorderColor: TColor;
begin
  Result := clBtnFace;
  if FOwner <> nil then Result := FOwner.BorderColor;
end;

function TSCControlBorderProps.GetBorderEx: Boolean;
begin
  Result := False;
  if FOwner <> nil then Result := FOwner.BorderEx;
end;

function TSCControlBorderProps.GetBorderInner: TSCControlBorder;
begin
  Result := sccbNone;
  if FOwner <> nil then Result := FOwner.BorderInner;
end;

function TSCControlBorderProps.GetBorderWidth: TBorderWidth;
begin
  Result := 0;
  if FOwner <> nil then Result := FOwner.BorderWidth;
end;

function TSCControlBorderProps.GetFlatColor: TColor;
begin
  Result := clBtnShadow;
  if FOwner <> nil then Result := FOwner.FlatColor;
end;

function TSCControlBorderProps.GetFlatInnerColor: TColor;
begin
  Result := clBtnShadow;
  if FOwner <> nil then Result := FOwner.FlatInnerColor;
end;

function TSCControlBorderProps.GetFocusColor: TColor;
begin
  Result := clNone;
  if FOwner <> nil then Result := FOwner.BorderFocusColor;
end;

function TSCControlBorderProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCControlBorderProps.SetBorder(Value: TSCControlBorder);
begin
  if FOwner <> nil then FOwner.Border := Value;
end;

procedure TSCControlBorderProps.SetBorderColor(Value: TColor);
begin
  if FOwner <> nil then FOwner.BorderColor := Value;
end;

procedure TSCControlBorderProps.SetBorderEx(Value: Boolean);
begin
  if FOwner <> nil then FOwner.BorderEx := Value;
end;

procedure TSCControlBorderProps.SetBorderInner(Value: TSCControlBorder);
begin
  if FOwner <> nil then FOwner.BorderInner := Value;
end;

procedure TSCControlBorderProps.SetBorderWidth(Value: TBorderWidth);
begin
  if FOwner <> nil then FOwner.BorderWidth := Value;
end;

procedure TSCControlBorderProps.SetFlatColor(Value: TColor);
begin
  if FOwner <> nil then FOwner.FlatColor := Value;
end;

procedure TSCControlBorderProps.SetFlatInnerColor(Value: TColor);
begin
  if FOwner <> nil then FOwner.FlatInnerColor := Value;
end;

procedure TSCControlBorderProps.SetFocusColor(Value: TColor);
begin
  if FOwner <> nil then FOwner.BorderFocusColor := Value;
end;

{ TSCControlCustomScrollbars }

procedure TSCControlCustomScrollbars.Assign(Source: TPersistent);
begin
  if Source is TSCControlCustomScrollbars then
  begin
    with TSCControlCustomScrollbars(Source) do
    begin
      Self.ExtraButton := ExtraButton;
      Self.Height := Height;
      Self.Horizontal := Horizontal;
      Self.Layout := Layout;
      Self.ScrollbarType := ScrollbarType;
      Self.Style := Style;
      Self.ThumbLines := ThumbLines;
      Self.Vertical := Vertical;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCControlCustomScrollbars.Create(AOwner: TSCCustomScrollControl);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TSCControlCustomScrollbars.GetExtraButton: Boolean;
begin
  Result := False;
  if FOwner <> nil then
    Result := FOwner.ScrollbarExtraButton;
end;

function TSCControlCustomScrollbars.GetHeight: Integer;
begin
  Result := -1;
  if FOwner <> nil then
    Result := FOwner.ScrollbarHeight;
end;

function TSCControlCustomScrollbars.GetHorizontal: TSCCustomControlScrollbar;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.ScrollbarHorz;
end;

function TSCControlCustomScrollbars.GetLayout: TSCScrollButtonLayout;
begin
  Result := scsbDefault;
  if FOwner <> nil then
    Result := FOwner.ScrollButtonsLayout;
end;

function TSCControlCustomScrollbars.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TSCControlCustomScrollbars.GetStyle: TSCScrollbarStyle;
begin
  Result := scssDefault;
  if FOwner <> nil then
    Result := FOwner.ScrollbarStyle;
end;

function TSCControlCustomScrollbars.GetThumbLines: TSCScrollThumbline;
begin
  Result := sctlNone;
  if FOwner <> nil then
    Result := FOwner.ScrollbarThumbLines;
end;

function TSCControlCustomScrollbars.GetType: TSCScrollbarType;
begin
  Result := scsbtSweet;
  if FOwner <> nil then
    Result := FOwner.ScrollbarType;
end;

function TSCControlCustomScrollbars.GetVertical: TSCCustomControlScrollbar;
begin
  Result := nil;
  if FOwner <> nil then
    Result := FOwner.ScrollbarVert;
end;

procedure TSCControlCustomScrollbars.SetExtraButton(Value: Boolean);
begin
  if FOwner <> nil then
    FOwner.ScrollbarExtraButton := Value;
end;

procedure TSCControlCustomScrollbars.SetHeight(Value: Integer);
begin
  if FOwner <> nil then
    FOwner.ScrollbarHeight := Value;
end;

procedure TSCControlCustomScrollbars.SetHorizontal(Value: TSCCustomControlScrollbar);
begin
  if FOwner <> nil then
    FOwner.ScrollbarHorz := Value;
end;

procedure TSCControlCustomScrollbars.SetLayout(Value: TSCScrollButtonLayout);
begin
  if FOwner <> nil then
    FOwner.ScrollButtonsLayout := Value;
end;

procedure TSCControlCustomScrollbars.SetSmooth(Value: Boolean);
begin
  Horizontal.Smooth := Value;
  Vertical.Smooth := Value;
end;

procedure TSCControlCustomScrollbars.SetStyle(Value: TSCScrollbarStyle);
begin
  if FOwner <> nil then
    FOwner.ScrollbarStyle := Value;
end;

procedure TSCControlCustomScrollbars.SetThumbLines(Value: TSCScrollThumbline);
begin
  if FOwner <> nil then
    FOwner.ScrollbarThumbLines := Value;
end;

procedure TSCControlCustomScrollbars.SetType(Value: TSCScrollbarType);
begin
  if FOwner <> nil then
    FOwner.ScrollbarType := Value;
end;

procedure TSCControlCustomScrollbars.SetVertical(Value: TSCCustomControlScrollbar);
begin
  if FOwner <> nil then
    FOwner.ScrollbarVert := Value;
end;

{ TSCPictureList }

procedure TSCPictureList.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

constructor TSCPictureList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPictures := TSCPictureListItems.Create(Self);
end;

destructor TSCPictureList.Destroy;
begin
  Destroying;
  if FNotifyList <> nil then
  begin
    ItemsChanged(scpcaDestroyed);
    FreeAndNil(FNotifyList);
  end;

  FPictures.FOwner := nil;
  FreeAndNil(FPictures);
  inherited Destroy;
end;

function TSCPictureList.GetPicture(Index: Integer): TPicture;
begin
  Result := nil;
  if (Index > -1) and (Index < FPictures.Count) then
    Result := FPictures[Index].Picture;
end;

procedure TSCPictureList.EndUpdate;
begin
  if FUpdateCount > 0 then
    Dec(FUpdateCount);
end;

function TSCPictureList.GetPicture(AName: String): TPicture;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FPictures.Count-1 do
    if AnsiSameText(FPictures[I].Name, AName) then
    begin
      Result := FPictures[I].Picture;
      Exit;
    end;
end;

function TSCPictureList.InUpdate: Boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TSCPictureList.ItemsChanged(Action: TSCPictureChangeAction);
var
  I: Integer;
  N: TSCPictureNotifier;
begin
  if (FNotifyList <> nil) and ((Action = scpcaDestroyed) or not InUpdate) then
    for I := 0 to FNotifyList.Count-1 do
    begin
      try
        N := FNotifyList.Items[I];
        N.DoChange(Self, Action);
      except
      end;
    end;
end;

procedure TSCPictureList.RegisterNotifier(Sender: TSCPictureNotifier);
begin
  if Sender <> nil then
  begin
    if FNotifyList = nil then
      FNotifyList := TList.Create;

    if FNotifyList.IndexOf(Sender) = -1 then
      FNotifyList.Add(Sender);
  end;
end;

procedure TSCPictureList.SetPictures(Value: TSCPictureListItems);
begin
  FPictures.Assign(Value)
end;

procedure TSCPictureList.UnregisterNotifier(Sender: TSCPictureNotifier);
var
  Index: Integer;
begin
  if Sender <> nil then
  begin
    Index := -1;
    if FNotifyList <> nil then
      Index := FNotifyList.IndexOf(Sender);

    if Index > -1 then
    begin
      FNotifyList.Delete(Index);
      if FNotifyList.Count = 0 then
        FreeAndNil(FNotifyList);
    end;
  end;
end;

procedure TSCPictureList.NotifyAll;
begin
  ItemsChanged(scpcaChanged);
end;

procedure TSCPictureList.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TSCPictureList then
    with TSCPictureList(Source) do
      Self.Pictures := Pictures;
end;

function TSCPictureList.GetCount: Integer;
begin
  Result := 0;
  if FPictures <> nil then Result := FPictures.Count;
end;

{ TSCPictureNotifier }

procedure TSCPictureNotifier.DoChange(Sender: TSCPictureList; Action: TSCPictureChangeAction);
begin
  if Assigned(FOnChange) then
    FOnChange(Sender, Action);
end;

{ TSCPictureListItems }

function TSCPictureListItems.Add: TSCPictureListItem;
begin
  Result := TSCPictureListItem(inherited Add);
end;

constructor TSCPictureListItems.Create(AOwner: TSCPictureList);
begin
  inherited Create(TSCPictureListItem);
  FOwner := AOwner;
end;

function TSCPictureListItems.GetItem(Index: Integer): TSCPictureListItem;
begin
  Result := TSCPictureListItem(inherited GetItem(Index));
end;

function TSCPictureListItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCPictureListItems.SetItem(Index: Integer;
  Value: TSCPictureListItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TSCPictureListItems.Update(Item: TCollectionItem);
begin
  if FOwner <> nil then
    FOwner.ItemsChanged(scpcaChanged);
end;

{ TSCPictureListItem }

procedure TSCPictureListItem.Assign(Source: TPersistent);
begin
  if Source is TSCPictureListItem then
  begin
    BeginUpdate;
    try
      with TSCPictureListItem(Source) do
      begin
        Self.Picture := Picture;
        Self.Caption := Caption;
        Self.Name := Name;
        Self.Description := Description;
      end;
    finally
      EndUpdate;
    end;
  end else
    inherited Assign(Source);
end;

procedure TSCPictureListItem.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

constructor TSCPictureListItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;

  FDescription := TStringList.Create;
  TStringList(FDescription).OnChange := DescriptionChanged;
end;

procedure TSCPictureListItem.DescriptionChanged(Sender: TObject);
begin
  DoChanged;
end;

destructor TSCPictureListItem.Destroy;
begin
  TStringList(FDescription).OnChange := nil;
  FreeAndNil(FDescription);
  FPicture.OnChange := nil;
  FreeAndNil(FPicture);
  inherited Destroy;
end;

procedure TSCPictureListItem.DoChanged;
begin
  if not InUpdate then
    Changed(True);
end;

procedure TSCPictureListItem.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      DoChanged;
  end;
end;

function TSCPictureListItem.GetDisplayName: string;
begin
  Result := FName;
  if Result = '' then Result := FCaption;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TSCPictureListItem.InUpdate: Boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TSCPictureListItem.PictureChanged(Sender: TObject);
begin
  DoChanged;
end;

procedure TSCPictureListItem.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    DoChanged;
  end;
end;

procedure TSCPictureListItem.SetDescription(Value: TStrings);
begin
  FDescription.Assign(Value);
end;

procedure TSCPictureListItem.SetName(const Value: String);
begin
  if FName <> Value then
  begin
    FName := Value;
    DoChanged;
  end;
end;

procedure TSCPictureListItem.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

{ TSCCustomStyleController }

procedure TSCCustomStyleController.Changed(Props: TSCCustomStyleProps);
var
  I: Integer;
begin
  for I := 0 to FControls.Count-1 do
    TSCCustomControl(FControls[I]).NotifyStyleChange(Props);
end;

constructor TSCCustomStyleController.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FControls := TList.Create;
  FBorderProps := TSCStyleBorderProps.Create(Self);
end;

destructor TSCCustomStyleController.Destroy;
begin
  FControls.Free;
  FBorderProps.Free;
  inherited Destroy;
end;

procedure TSCCustomStyleController.RegisterChanges(Control: TSCCustomControl);
begin
  if (Control <> nil) and (FControls.IndexOf(Control) = -1) then
  begin
    FControls.Add(Control);
    Control.NotifyStyleChange;
  end;
end;

procedure TSCCustomStyleController.SetBorderProps(Value: TSCStyleBorderProps);
begin
  FBorderProps.Assign(Value);
end;

procedure TSCCustomStyleController.UnregisterChanges(Control: TSCCustomControl);
var
  Index: Integer;
begin
  if Control <> nil then
  begin
    Index :=  FControls.IndexOf(Control);
    if Index > -1 then
    begin
      FControls.Remove(Control);
      Control.NotifyStyleChange;
    end;
  end;
end;

{ TSCCustomStyleProps }

procedure TSCCustomStyleProps.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TSCCustomStyleProps.Changed;
begin
  if (FOwner <> nil) and (FUpdateCount = 0) then
    FOwner.Changed(Self);
end;

constructor TSCCustomStyleProps.Create(AOwner: TSCCustomStyleController);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TSCCustomStyleProps.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      Changed;
  end;
end;

function TSCCustomStyleProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

{ TSCStyleBorderProps }

procedure TSCStyleBorderProps.Assign(Source: TPersistent);
begin
  if Source is TSCStyleBorderProps then
  begin
    BeginUpdate;
    try
      with TSCStyleBorderProps(Source) do
      begin
        Self.FBorder := FBorder;
        Self.FBorderColor := FBorderColor;
        Self.FBorderEx := FBorderEx;
        Self.FFlatColor := FFlatColor;
        Self.FFlatInnerColor := FFlatInnerColor;
        Self.FBorderInner := FBorderInner;
        Self.FBorderWidth := FBorderWidth;
      end;
    finally
      EndUpdate;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCStyleBorderProps.Create(AOwner: TSCCustomStyleController);
begin
  inherited Create(AOwner);
  FBorder := sccbNone;
  FBorderColor := clBtnFace;
  FBorderEx := False;
  FFlatColor := clBtnShadow;
  FFlatInnerColor := clBtnShadow;
  FBorderInner := sccbNone;
  FBorderWidth := 0;
end;

procedure TSCStyleBorderProps.SetBorder(Value: TSCControlBorder);
begin
  if FBorder <> Value then
  begin
    FBorder := Value;
    Changed;
  end;
end;

procedure TSCStyleBorderProps.SetBorderColor(Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Changed;
  end;
end;

procedure TSCStyleBorderProps.SetBorderEx(Value: Boolean);
begin
  if FBorderEx <> Value then
  begin
    FBorderEx := Value;
    Changed;
  end;
end;

procedure TSCStyleBorderProps.SetBorderInner(Value: TSCControlBorder);
begin
  if FBorderInner <> Value then
  begin
    FBorderInner := Value;
    Changed;
  end;
end;

procedure TSCStyleBorderProps.SetBorderWidth(Value: TBorderWidth);
begin
  if FBorderWidth <> Value then
  begin
    FBorderWidth := Value;
    Changed;
  end;
end;

procedure TSCStyleBorderProps.SetFlatColor(Value: TColor);
begin
  if FFlatColor <> Value then
  begin
    FFlatColor := Value;
    Changed;
  end;
end;

procedure TSCStyleBorderProps.SetFlatInnerColor(Value: TColor);
begin
  if FFlatInnerColor <> Value then
  begin
    FFlatInnerColor := Value;
    Changed;
  end;
end;

{ TSCGraphicBorderProps }

procedure TSCGraphicBorderProps.Assign(Source: TPersistent);
begin
  if Source is TSCGraphicBorderProps then
  begin
    with TSCGraphicBorderProps(Source) do
    begin
      Self.FBorder := Border;
      Self.FColor := Color;
      Self.FExDraw := ExDraw;
      Self.FFlatColor := FlatColor;
      Self.FFlatInnerColor := FlatInnerColor;
      Self.FInnerBorder := InnerBorder;
      Self.FWidth := Width;
    end;
    
    DoChange;
  end else
    inherited Assign(Source);
end;

constructor TSCGraphicBorderProps.Create(AOwner: TSCGraphicControl);
begin
  inherited Create;
  FOwner := AOwner;
  FBorder := sccbNone;
  FColor := clBtnFace;
  FExDraw := False;
  FFlatColor := clBtnShadow;
  FFlatInnerColor := clBtnShadow;
  FInnerBorder := sccbNone;
  FWidth := 0;
end;

procedure TSCGraphicBorderProps.DoChange;
begin
  if FOwner <> nil then
    FOwner.DoBorderChanged;
end;

function TSCGraphicBorderProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCGraphicBorderProps.SetBorder(Value: TSCControlBorder);
begin
  if (FBorder <> Value) and ((FOwner = nil) or
    FOwner.CanSetBorder(Value)) then
  begin
    FBorder := Value;
    DoChange;
  end;
end;

procedure TSCGraphicBorderProps.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    DoChange;
  end;
end;

procedure TSCGraphicBorderProps.SetExDraw(Value: Boolean);
begin
  if FExDraw <> Value then
  begin
    FExDraw := Value;
    DoChange;
  end;
end;

procedure TSCGraphicBorderProps.SetInnerBorder(Value: TSCControlBorder);
begin
  if (FInnerBorder <> Value) and ((FOwner = nil) or
    FOwner.CanSetInnerBorder(Value)) then
  begin
    FInnerBorder := Value;
    DoChange;
  end;
end;

procedure TSCGraphicBorderProps.SetWidth(Value: TBorderWidth);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    DoChange;
  end;
end;

procedure TSCGraphicBorderProps.SetFlatColor(Value: TColor);
begin
  if FFlatColor <> Value then
  begin
    FFlatColor := Value;
    DoChange;
  end;
end;

procedure TSCGraphicBorderProps.SetFlatInnerColor(Value: TColor);
begin
  if FFlatInnerColor <> Value then
  begin
    FFlatInnerColor := Value;
    DoChange;
  end;
end;

{ TSCGraphicControlActionLink }

procedure TSCGraphicControlActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  FClient := AClient as TSCGraphicControl;
end;

function TSCGraphicControlActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and
    AnsiSameText(FClient.Caption, (Action as TCustomAction).Caption);
end;

function TSCGraphicControlActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and
    (FClient.Enabled = (Action as TCustomAction).Enabled);
end;

function TSCGraphicControlActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and
    (FClient.Hint = (Action as TCustomAction).Hint);
end;

function TSCGraphicControlActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and
    (FClient.ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TSCGraphicControlActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and
    (@FClient.OnClick = @Action.OnExecute);
end;

function TSCGraphicControlActionLink.IsShortCutLinked: Boolean;
begin
  Result := False;
end;

function TSCGraphicControlActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and
    (FClient.Visible = (Action as TCustomAction).Visible);
end;

procedure TSCGraphicControlActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then FClient.Caption := Value;
end;

procedure TSCGraphicControlActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then FClient.Enabled := Value;
end;

procedure TSCGraphicControlActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then FClient.Hint := Value;
end;

procedure TSCGraphicControlActionLink.SetImageIndex(Value: Integer);
begin
  if IsImageIndexLinked then FClient.ImageIndex := Value;
end;

procedure TSCGraphicControlActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then FClient.OnClick := Value;
end;

procedure TSCGraphicControlActionLink.SetShortCut(Value: TShortCut);
begin
  inherited;
end;

procedure TSCGraphicControlActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then FClient.Visible := Value;
end;

{ TSCGraphicControl }

constructor TSCGraphicControl.Create(AOwner: TComponent);
begin
  FCreatingControl := True;
  FImageIndex := -1;
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csCaptureMouse, csClickEvents,
    csDoubleClicks, csReplicatable];

  FBorderProps := GetBorderPropsClass.Create(Self);
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;

  FAutoSize   := False;
  {$IFDEF SC_DELPHI6_UP}
  AutoSize    := False;
  {$ENDIF}

  FPictureIndex := -1;
  FPictureNotifier := TSCPictureNotifier.Create;
  FPictureNotifier.OnChange := PictureListChanged;

  FMouseDownPoint := Point(-1, -1);
  FImageLayout := scilLeft;
  FSpacing     := 4;

  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;

  AdjustBounds;

  FTransparent := True;
end;

destructor TSCGraphicControl.Destroy;
begin
  if GetCaptureControl = Self then
    SetCaptureControl(nil);

  FreeAndNil(FImageChangeLink);
  FreeAndNil(FBorderProps);
  FreeAndNil(FCanvas);

  FPictureNotifier.OnChange := nil;
  if FPictureList <> nil then
    FPictureList.UnregisterNotifier(FPictureNotifier);

  FreeAndNil(FPictureNotifier);
  inherited Destroy;
end;

procedure TSCGraphicControl.WMPaint(var Message: TWMPaint);
var
  R: TRect;
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
begin
  if Message.DC = 0 then
    Exit;

  if (Parent = nil) or not FDoubleBuffered then
    ProcessPaint(Message.DC)
  else begin
    R := Rect(0, 0, Width, Height);

    DC := GetDC(0);
    MemBitmap := CreateCompatibleBitmap(DC, R.Right, R.Bottom);
    ReleaseDC(0, DC);
    MemDC := CreateCompatibleDC(0);

    OldBitmap := SelectObject(MemDC, MemBitmap);
    try
      if IsTransparent then PaintParentOn(MemDC);

      Perform(WM_ERASEBKGND, MemDC, MemDC);
      ProcessPaint(MemDC);
      BitBlt(Message.DC, 0, 0, R.Right, R.Bottom, MemDC, 0, 0, SRCCOPY);
    finally
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
    end;
  end;
end;

procedure TSCGraphicControl.Paint;
begin
  //
end;

procedure TSCGraphicControl.AfterPaint;
begin
  //
end;

procedure TSCGraphicControl.BeforePaint;
begin
  //
end;

function TSCGraphicControl.GetClientRect: TRect;
begin
  Result := inherited GetClientRect;
  CalculateBorder(Result);
end;

procedure TSCGraphicControl.ProcessPaint(DC: HDC);
var
  R: TRect;
  C: TColor;
begin
  if DC <> 0 then
  begin
    Canvas.Lock;
    try
      Canvas.Handle := DC;
      try
        if not IsTransparent then
        begin
          R := ClientRect;
          if not IsRectEmpty(R) then
          begin
            C := Self.Color;
            if C = clNone then
            begin
              if Parent <> nil then
                C := TSCParentControl(Parent).Color;
                
              if C = clNone then C := clWindow;
            end;

            with Canvas do
            begin
              try
                Brush.Style := bsSolid;
                Brush.Color := C;

                FillRect(R);
              finally
                Brush.Style := bsClear;
              end;
            end;
          end;
        end;

        BeforePaint;
        Paint;
        AfterPaint;
        DrawBorder;
      finally
        Canvas.Handle := 0;
      end;
    finally
      Canvas.Unlock;
    end;
  end;
end;

procedure TSCGraphicControl.DrawBorder;
var
  DC: HDC;
  R, BRect: TRect;
  OldDCPen: HPen;
  FramePen: TPen;
  Points: array[0..4] of TPoint;
  C1, AColor: TColor;
  Bs, Offset: Integer;
begin
  if IsDestroying or (Canvas.Handle = 0) then
    Exit;

  DC := Canvas.Handle;

  AColor := Self.Color;
  if BorderProps.Color <> clNone then
    AColor := BorderProps.Color;

  if AColor = clNone then AColor := clBtnFace;

  FramePen := TPen.Create;
  with FramePen do
  begin
    Style := psInsideFrame;
    Color := AColor;
  end;

  OldDCPen := 0;
  try
    Offset := BorderProps.Width div 2;

    R := BoundsRect;
    OffsetRect(R, -R.Left, -R.Top);

    BRect := R;
    InflateRect(R, -Offset, -Offset);

    if Odd(BorderProps.Width) then
    begin
      Dec(R.Right);
      if R.Right < R.Left then
        R.Right := R.Left;

      Dec(R.Bottom);
      if R.Bottom < R.Top then
        R.Bottom := R.Top;
    end;

    if BorderProps.Width > 0 then
      FramePen.Width := BorderProps.Width;

    OldDCPen := SelectObject(DC, FramePen.Handle);
    SetROP2(DC, SCPenModes[FramePen.Mode]);

    Bs := GetBorderSize;

    if (BorderProps.Width > 0) and (BorderProps.Color <> clNone) then
    begin
      InflateRect(R, -Bs, -Bs);

      Points[0] := Point(R.Left, R.Top);
      Points[1] := Point(R.Right, R.Top);
      Points[2] := Point(R.Right, R.Bottom);
      Points[3] := Point(R.Left, R.Bottom);
      Points[4] := Point(R.Left, R.Top);

      Windows.MoveToEx(DC, Points[0].X - Offset, Points[0].Y, nil);
      Windows.LineTo(DC, Points[1].X + Offset, Points[1].Y);

      Windows.MoveToEx(DC, Points[1].X, Points[1].Y - Offset, nil);
      Windows.LineTo(DC, Points[2].X, Points[2].Y + Offset);

      Windows.MoveToEx(DC, Points[2].X + Offset, Points[2].Y, nil);
      Windows.LineTo(DC, Points[3].X - Offset, Points[3].Y);

      Windows.MoveToEx(DC, Points[3].X, Points[3].Y + Offset, nil);
      Windows.LineTo(DC, Points[4].X, Points[4].Y - Offset);
    end;

    R := BRect;
    if not IsRectEmpty(R) and (BorderProps.Border <> sccbNone) then
    begin
      if BorderProps.ExDraw then
      begin
        C1 := GetBorderExColor;
        if C1 = clNone then C1 := Self.Color;
        if C1 = clNone then C1 := clWindow;

        if BorderProps.Border in [sccbFlat, sccbFlatBold] then
          C1 := GetBtnShadowOf(C1);

        scDrawBevelEx(DC, R, C1, TSCFakeControl(Parent).Color, False, BorderProps.Border);
      end else
      begin
        C1 := BorderProps.FlatColor;
        if C1 = clNone then C1 := Self.Color;
        if C1 = clNone then C1 := clWindow;

        scDrawEdgeEx(DC, R, C1, TSCFakeControl(Parent).Color, False, BorderProps.Border);
      end;

      InflateRect(BRect, -Bs, -Bs);
    end;

    R := BRect;
    InflateRect(R, -BorderProps.Width, -BorderProps.Width);

    if not IsRectEmpty(BRect) then
    begin
      if BorderProps.ExDraw then
      begin
        C1 := GetBorderExColor;
        if C1 = clNone then C1 := Self.Color;
        if C1 = clNone then C1 := clWindow;

        if BorderProps.InnerBorder in [sccbFlat, sccbFlatBold] then
          C1 := GetBtnShadowOf(C1);

        scDrawBevelEx(DC, R, C1, TSCFakeControl(Parent).Color, False, BorderProps.InnerBorder);
      end else
      begin
        C1 := BorderProps.FlatInnerColor;
        if C1 = clNone then C1 := Self.Color;
        if C1 = clNone then C1 := clWindow;

        scDrawEdgeEx(DC, R, C1, TSCFakeControl(Parent).Color, False, BorderProps.InnerBorder);
      end;
    end;
  finally
    if OldDCPen <> 0 then
      SelectObject(DC, OldDCPen);

    FramePen.Free;
  end;
end;

procedure TSCGraphicControl.BorderChanged;
begin
  //
end;

procedure TSCGraphicControl.CalculateBorder(var R: TRect);
var
  B: Integer;
begin
  B := GetBorderSize + FBorderProps.Width + GetInnerBorderSize;
  InflateRect(R, -B, -B);
end;

function TSCGraphicControl.GetBorderSize: Integer;
begin
  Result := 0;
  if FBorderProps.Border in [sccbRaised, sccbLowered, sccbFlat,
    sccbColor] then
    Result := 1
  else
  if FBorderProps.Border in [sccbFlatBold, sccbFlatRounded, sccbFlatBoldRounded,
    sccb3DRaised, sccb3DLowered, sccbBumped, sccbEtched, sccbMacLowered,
    sccbMacRaised, sccbMetal, sccbSoftLowered, sccbSoftRaised] then
    Result := 2;
end;

function TSCGraphicControl.GetInnerBorderSize: Integer;
begin
  Result := 0;
  if FBorderProps.InnerBorder in [sccbRaised, sccbLowered, sccbFlat,
    sccbColor] then
    Result := 1
  else
  if FBorderProps.Border in [sccbFlatBold, sccbFlatRounded, sccbFlatBoldRounded,
    sccb3DRaised, sccb3DLowered, sccbBumped, sccbEtched, sccbMacLowered,
    sccbMacRaised, sccbMetal, sccbSoftLowered, sccbSoftRaised] then
    Result := 2;
end;

procedure TSCGraphicControl.SetBorderProps(Value: TSCGraphicBorderProps);
begin
  FBorderProps.Assign(Value);
end;

procedure TSCGraphicControl.SetTransparent(Value: Boolean);
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    Invalidate;
  end;
end;

function TSCGraphicControl.GetTransparent: Boolean;
begin
  Result := FTransparent;
end;

function TSCGraphicControl.GetBorderExColor: TColor;
begin
  Result := Self.Color;
end;

procedure TSCGraphicControl.DoBorderChanged;
begin
  Invalidate;
  BorderChanged;
end;

procedure TSCGraphicControl.StopTracking;
begin
  //
end;

procedure TSCGraphicControl.CMChanged(var Message: TMessage);
begin
  inherited;
  if FInChange = 0 then
    Change;
end;

procedure TSCGraphicControl.CMColorChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TSCGraphicControl.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
  EnabledChanged;

  FMouseIsDown := False;
  FMouseDownPoint := Point(-1, -1);
  FMouseInControl := False;
  if Enabled then UpdateTracking;
  MouseInControlChanged;
end;

procedure TSCGraphicControl.CMFontChanged(var Message: TMessage);
begin
  inherited;
  AdjustBounds;
  Invalidate;
end;

procedure TSCGraphicControl.CMMouseEnter(var Message: TMessage);
begin
  if Enabled and not IsDesigning then
  begin
    FMouseInControl := True;
    inherited;
    MouseInControlChanged;

    if Assigned(FOnMouseEnter) then
      FOnMouseEnter(Self);
  end else
    inherited;
end;

procedure TSCGraphicControl.CMMouseLeave(var Message: TMessage);
begin
  if Enabled and not IsDesigning then
  begin
    FMouseInControl := False;
    inherited;
    MouseInControlChanged;

    if Assigned(FOnMouseLeave) then
      FOnMouseLeave(Self);
  end else
    inherited;
end;

procedure TSCGraphicControl.CMParentColorChanged(var Message: TWMNoParams);
begin
  inherited;
  Invalidate;
end;

procedure TSCGraphicControl.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  SystemColorsChanged;
  Invalidate;
end;

procedure TSCGraphicControl.CMTextChanged(var Message: TMessage);
begin
  inherited;
  AdjustBounds;
  Invalidate;
end;

procedure TSCGraphicControl.WMCancelMode(var Message: TMessage);
begin
  StopTracking;
  inherited;
end;

procedure TSCGraphicControl.WMPrint(var Message: TMessage);
begin
  if (Message.WParam = 0) or
    ((Message.LParam and PRF_CHECKVISIBLE) <> PRF_CHECKVISIBLE) then
    Exit;

  ProcessPaint(HDC(Message.WParam));
end;

procedure TSCGraphicControl.WMSettingChange(var Message: TWMSettingChange);
begin
  inherited;
  Invalidate;
end;

procedure TSCGraphicControl.Change;
begin
  Inc(FInChange);
  try
    Changed;
  finally
    Dec(FInChange);
  end;

  DoChange;
  if Assigned(FOnChange) and not IsLoading then
    FOnChange(Self);
end;

procedure TSCGraphicControl.DoChange;
begin
  //
end;

procedure TSCGraphicControl.AdjustBounds;
begin
  //
end;

procedure TSCGraphicControl.AutoSizeChanged;
begin
  //
end;

procedure TSCGraphicControl.DoAutoSize(Value: Boolean);
begin
  if (FAutoSize = Value) or (inherited AutoSize <> Value) then
  begin
    FAutoSize := Value;

    AutoSizeChanged;

    {$IFDEF SC_DELPHI6_UP}
    inherited SetAutoSize(Value);
    {$ELSE}
    inherited AutoSize := Value;
    {$ENDIF}
    AdjustBounds;
  end;
end;

procedure TSCGraphicControl.EnabledChanged;
begin
  //
end;

function TSCGraphicControl.GetAdjustedRect(NewWidth, NewHeight: Integer): TRect;
var
  B: Integer;
begin
  Result := Rect(Left, Top, Left + NewWidth, Top + NewHeight);

  B := 2*(GetBorderSize + FBorderProps.Width + GetInnerBorderSize);

  Inc(Result.Right, B);
  Inc(Result.Bottom, B);
end;

procedure TSCGraphicControl.SetAutoSize(Value: Boolean);
begin
  DoAutoSize(Value);
end;

procedure TSCGraphicControl.Loaded;
begin
  inherited Loaded;
  AdjustBounds;
end;

procedure TSCGraphicControl.MouseInControlChanged;
begin
  //
end;

procedure TSCGraphicControl.SystemColorsChanged;
begin
  //
end;

function TSCGraphicControl.CanAutoSize(var NewWidth,
  NewHeight: Integer): Boolean;
var
  R: TRect;
begin
  Result := AutoSize and inherited CanAutoSize(NewWidth, NewHeight);
  if Result then
  begin
    R := GetAdjustedRect(NewWidth, NewHeight);

    NewWidth := R.Right - R.Left;
    if NewWidth < 0 then NewWidth := 0;

    NewHeight := R.Bottom - R.Top;
    if NewHeight < 0 then NewHeight := 0;
  end;
end;

function TSCGraphicControl.CanSetBorder(Value: TSCControlBorder): Boolean;
begin
  Result := True;
end;

function TSCGraphicControl.CanSetInnerBorder(
  Value: TSCControlBorder): Boolean;
begin
  Result := True;
end;

procedure TSCGraphicControl.UpdateTracking;
var
  P: TPoint;
begin
  FMouseInControl := False;
  if Enabled and not IsDesigning then
  begin
    GetCursorPos(P);
    FMouseInControl := not (FindDragTarget(P, True) = Self);

    if FMouseInControl then
      Perform(CM_MOUSELEAVE, 0, 0)
    else
      Perform(CM_MOUSEENTER, 0, 0);
  end;
end;

procedure TSCGraphicControl.TranslateMouseMove(var Message: TWMMouse);
begin
  if not (csNoStdEvents in ControlStyle) then
    with Message do
      DoMouseMove(KeysToShiftState(Keys), XPos, YPos);
end;

procedure TSCGraphicControl.WMMouseMove(var Message: TWMMouseMove);
begin
  if not IsDesigning then
    TranslateMouseMove(Message);
  inherited;
end;

procedure TSCGraphicControl.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
      if not CheckDefaults or (Self.ImageIndex = -1) then
        Self.ImageIndex := ImageIndex;
end;

function TSCGraphicControl.CalculateImageRect: TRect;
var
  ARect: TRect;
begin
  Result := GetImageRect;
  if FImages = nil then
    Exit;

  OffsetRect(Result, (ClientWidth - Images.Width) div 2,
    (ClientHeight - Images.Height) div 2);

  ARect := GetTextRect;
  if (ARect.Right <= ARect.Left) or
    (ARect.Bottom <= ARect.Top) then Exit;

  case ImageLayout of
    scilBottom:
      OffsetRect(Result, 0, (((ARect.Bottom - ARect.Top) + 2) div 2));
    scilLeft:
      OffsetRect(Result, -(((ARect.Right - ARect.Left) + 2) div 2) - GetIndent, 0);
    scilRight:
      OffsetRect(Result, (((ARect.Right - ARect.Left) + 2) div 2) + GetIndent, 0);
    scilTop:
      OffsetRect(Result, 0, -(((ARect.Bottom - ARect.Top) + 2) div 2));
  end;
end;

function TSCGraphicControl.CalculateTextRect: TRect;
var
  ARect: TRect;
  TW, TH: Integer;
begin
  Result := GetTextRect;

  TW := Result.Right - Result.Left;
  TH := Result.Bottom - Result.Top;
  OffsetRect(Result, (ClientWidth - TW) div 2,
    (ClientHeight - TH) div 2);

  if (Images = nil) or (ImageIndex = -1) or
    ((Images <> nil) and (ImageIndex > Images.Count-1)) then Exit;

  ARect := GetImageRect;
  if (ARect.Right <= ARect.Left) or
    (ARect.Bottom <= ARect.Top) then Exit;

  case ImageLayout of
    scilBottom:
      OffsetRect(Result, 0, -(((ARect.Bottom - ARect.Top) + 2) div 2));
    scilLeft:
      OffsetRect(Result, (((ARect.Right - ARect.Left) + 2) div 2) + GetIndent, 0);
    scilRight:
      OffsetRect(Result, -(((ARect.Right - ARect.Left) + 2) div 2) - GetIndent, 0);
    scilTop:
      OffsetRect(Result, 0, (((ARect.Bottom - ARect.Top) + 2) div 2));
  end;
end;

function TSCGraphicControl.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TSCGraphicControlActionLink;
end;

function TSCGraphicControl.GetImageRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if FImages <> nil then
    Result := Rect(0, 0, Images.Width, Images.Height);
end;

function TSCGraphicControl.GetIndent: Integer;
begin
  Result := -1;
  if (ImageLayout in [scilLeft, scilRight]) and 
    IsValidImage(FImageIndex) and (Caption <> '') then
    Result := FIndent;
end;

function TSCGraphicControl.GetTextCalculateFont: TFont;
begin
  Result := Self.Font;
end;

function TSCGraphicControl.GetTextHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  try
    SaveFont := SelectObject(DC, GetTextCalculateFont.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
  finally
    ReleaseDC(0, DC);
  end;

  Result := Metrics.tmHeight;
end;

function TSCGraphicControl.GetTextRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if Caption <> '' then
  begin
    Canvas.Font.Assign(Self.Font);
    Result := Rect(0, 0, ClientWidth, 0);
    DrawText(Canvas.Handle, PChar(Caption), Length(Caption),
      Result, DT_CALCRECT);
  end;
end;

procedure TSCGraphicControl.ImageListChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TSCGraphicControl.IndentChanged;
begin
  Invalidate;
end;

procedure TSCGraphicControl.SetIndent(Value: Integer);
begin
  if FIndent <> Value then
  begin
    FIndent := Value;

    AdjustBounds;
    IndentChanged;
  end;
end;

procedure TSCGraphicControl.SetSpacing(Value: Integer);
begin
  if Value < 0 then Value := 0;

  if FSpacing <> Value then
  begin
    FSpacing := Value;

    AdjustBounds;
    SpacingChanged;
  end;
end;

procedure TSCGraphicControl.SpacingChanged;
begin
  Invalidate;
end;

procedure TSCGraphicControl.UpdateLocked;
begin
  //
end;

procedure TSCGraphicControl.UpdateUnlocked;
begin
  //
end;

procedure TSCGraphicControl.AfterConstruction;
begin
  FCreatingControl := False;
  inherited AfterConstruction;
end;

procedure TSCGraphicControl.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if FImages <> nil then
      Invalidate;
  end;
end;

procedure TSCGraphicControl.SetImageLayout(const Value: TSCImageLayout);
begin
  FImageLayout := Value;
end;

procedure TSCGraphicControl.SetImages(const Value: TCustomImageList);
var
  FOldImages: TCustomImageList;
begin
  FOldImages := FImages;
  if FImages <> nil then
  begin
  {$IFDEF SC_DELPHI5_UP}
    FImages.RemoveFreeNotification(Self);
  {$ENDIF}
    FImages.UnRegisterChanges(FImageChangeLink);
  end;

  FImages := Value;
  if FImages <> nil then
  begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(Self);
  end;

  if FOldImages <> FImages then
  begin
    Invalidate;
    ImageListChange(FImages);
  end;
end;

procedure TSCGraphicControl.SetPictureIndex(Value: Integer);
begin
  if Value < -1 then Value := -1;

  if FPictureIndex <> Value then
  begin
    FPictureIndex := Value;
    if FPictureList <> nil then
      PictureListChanged(nil, scpcaChanged);
  end;
end;

procedure TSCGraphicControl.SetPictureList(const Value: TSCPictureList);
begin
  if FPictureList <> Value then
  begin
    if FPictureList <> nil then
      FPictureList.UnregisterNotifier(FPictureNotifier);

    FPictureList := Value;
    if FPictureList <> nil then
      FPictureList.RegisterNotifier(FPictureNotifier);

    PictureListChanged(FPictureList, scpcaChanged);
  end;
end;

procedure TSCGraphicControl.DoPictureListChanged;
begin
  //
end;

procedure TSCGraphicControl.PictureListChanged(Sender: TSCPictureList;
  Action: TSCPictureChangeAction);
begin
  if (Action = scpcaDestroyed) and (Sender <> nil) and (Sender = FPictureList) then
  begin
    FPictureList.UnregisterNotifier(FPictureNotifier);
    FPictureList := nil;
  end;

  DoPictureListChanged;
end;

procedure TSCGraphicControl.BeginUpdate;
begin
  Inc(FUpdateCount);
  if FUpdateCount = 1 then UpdateLocked;
end;

procedure TSCGraphicControl.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then UpdateLocked;
  end;
end;

function TSCGraphicControl.GetAbout: TSCAboutString;
begin
  Result := SC_VersionStr;
end;

function TSCGraphicControl.InUpdate: Boolean;
begin
  Result := FUpdateCount > 0;
end;

function TSCGraphicControl.IsValidImage(Indx: Integer): Boolean;
var
  Img: TCustomImageList;
begin
  Img := GetImages;
  Result := (Indx > -1) and (Img <> nil) and
    (Img.Count > 0) and (Indx < Img.Count);
end;

procedure TSCGraphicControl.SetAbout(const Value: TSCAboutString);
begin
  //
end;

procedure TSCGraphicControl.DoMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and IsActive and IsInClientRect(X, Y) and
    ((ssLeft in Shift) or (ssDouble in Shift)) then
  begin
    FMouseIsDown := True;
    FMouseDownPoint := Point(X, Y);
  end;
end;

procedure TSCGraphicControl.DoMouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if not (FMouseIsDown or FMouseInControl) then
    UpdateTracking;
end;

procedure TSCGraphicControl.DoMouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseIsDown := False;
  FMouseDownPoint := Point(-1, -1);
end;

function TSCGraphicControl.IsActive: Boolean;
begin
  Result := True;
end;

function TSCGraphicControl.IsInClientRect(X, Y: Integer): Boolean;
var
  R: TRect;
  P: TPoint;
begin
  P := Point(X, Y);
  R := GetClientRect;

  Result := PtInRect(R, P);
end;

procedure TSCGraphicControl.TranslateMouseDown(var Message: TWMMouse;
  Button: TMouseButton; Shift: TShiftState);
begin
  if not (csNoStdEvents in ControlStyle) then
    with Message do
      DoMouseDown(Button, KeysToShiftState(Keys) + Shift, XPos, YPos);
end;

procedure TSCGraphicControl.TranslateMouseUp(var Message: TWMMouse;
  Button: TMouseButton);
begin
  if not (csNoStdEvents in ControlStyle) then
    with Message do
      DoMouseUp(Button, KeysToShiftState(Keys), XPos, YPos);
end;

procedure TSCGraphicControl.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if not IsDesigning then
  begin
    SendCancelMode(Self);
    if csCaptureMouse in ControlStyle then MouseCapture := True;
    TranslateMouseDown(Message, mbLeft, [ssDouble]);
  end;
  inherited;
end;

procedure TSCGraphicControl.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if not IsDesigning then
  begin
    SendCancelMode(Self);
    TranslateMouseDown(Message, mbLeft, []);
  end;
  inherited;
end;

procedure TSCGraphicControl.WMLButtonUp(var Message: TWMLButtonUp);
begin
  if not IsDesigning then
    TranslateMouseUp(Message, mbLeft);
  inherited;
end;

procedure TSCGraphicControl.WMMButtonDblClk(var Message: TWMMButtonDblClk);
begin
  if not IsDesigning then
    TranslateMouseDown(Message, mbMiddle, [ssDouble]);
  inherited;
end;

procedure TSCGraphicControl.WMMButtonDown(var Message: TWMMButtonDown);
begin
  if not IsDesigning then
    TranslateMouseDown(Message, mbMiddle, []);
  inherited;
end;

procedure TSCGraphicControl.WMMButtonUp(var Message: TWMMButtonUp);
begin
  if not IsDesigning then
    TranslateMouseUp(Message, mbMiddle);
  inherited;
end;

procedure TSCGraphicControl.WMRButtonDblClk(var Message: TWMRButtonDblClk);
begin
  if not IsDesigning then
    TranslateMouseDown(Message, mbRight, [ssDouble]);
  inherited;
end;

procedure TSCGraphicControl.WMRButtonDown(var Message: TWMRButtonDown);
begin
  if not IsDesigning then
    TranslateMouseDown(Message, mbRight, []);
  inherited;
end;

procedure TSCGraphicControl.WMRButtonUp(var Message: TWMRButtonUp);
begin
  if not IsDesigning then
    TranslateMouseUp(Message, mbRight);
  inherited;
end;

function TSCGraphicControl.CanGetClientRect: Boolean;
begin
  Result := True;
end;

function TSCGraphicControl.GetBorderPropsClass: TSCGraphicBorderPropsClass;
begin
  Result := TSCGraphicBorderProps;
end;

procedure TSCGraphicControl.PaintParentOn(DC: HDC);
var
  InDesign: Boolean;
  Ctrl: TControl;
  R, R2, CR, CtlR,
  SelfR, ParentR: TRect;
  I, X, Y, Cnt, SaveIndex: Integer;
begin
  if (Parent = nil) or (DC = 0) then
    Exit;

  ParentR := Parent.ClientRect;
  if IsRectEmpty(ParentR) then
    Exit;

  SelfR := GetClientRect;
  with SelfR do
  begin
    TopLeft := Self.ClientToScreen(TopLeft);
    BottomRight := Self.ClientToScreen(BottomRight);

    TopLeft := Parent.ScreenToClient(TopLeft);
    BottomRight := Parent.ScreenToClient(BottomRight);
  end;

  X := -SelfR.Left;
  Y := -SelfR.Top;

  IntersectRect(SelfR, SelfR, ParentR);
  if IsRectEmpty(SelfR) then
    Exit;

  // Copy parent control image
  SaveIndex := SaveDC(DC);
  try
    SetViewportOrgEx(DC, X, Y, nil);
    IntersectClipRect(DC, 0, 0, ParentR.Right - ParentR.Left, ParentR.Bottom - ParentR.Top);
    Self.Parent.Perform(WM_ERASEBKGND, WParam(DC), 0);
    TSCParentControl(Self.Parent).PaintWindow(DC);
  finally
    RestoreDC(DC, SaveIndex);
  end;  

  //Copy images of parent controls
  InDesign := IsDesigning;

  Cnt := Parent.ControlCount;
  for I := 0 to Cnt - 1 do begin
    if Parent.Controls[I] <> nil then
    begin
      Ctrl := Parent.Controls[I];
      if Ctrl = Self then
        Break;

      if Ctrl is TWinControl then
        Continue;
        
      with Ctrl do
      begin
        CtlR := Bounds(Ctrl.Left, Ctrl.Top, Ctrl.Width, Ctrl.Height);

        if Bool(IntersectRect(R, SelfR, CtlR)) and (Visible or InDesign) then
        begin
          CR := ClientRect;
          R2 := CR;

          with R2 do
          begin
            TopLeft := ClientToScreen(TopLeft);
            BottomRight := ClientToScreen(BottomRight);

            TopLeft := Parent.ScreenToClient(TopLeft);
            BottomRight := Parent.ScreenToClient(BottomRight);
          end;

          SaveIndex := SaveDC(DC);
          try
            SetViewportOrgEx(DC, Left + X, Top + Y, nil);
            IntersectClipRect(DC, 0, 0, Width, Height);

            Perform(WM_PRINT, DC, PRF_NONCLIENT or PRF_CLIENT or
              PRF_ERASEBKGND or PRF_CHILDREN);

            SetViewportOrgEx(DC, R2.Left + X, R2.Top + Y, nil);
            IntersectClipRect(DC, CR.Left, CR.Top, CR.Right, CR.Bottom);
            Perform(WM_PAINT, DC, 0);
          finally
            RestoreDC(DC, SaveIndex);
          end;
        end;
      end;
    end;
  end;
end;

function TSCGraphicControl.GetImageIndex: TImageIndex;
begin
  Result := FImageIndex;
end;

function TSCGraphicControl.GetImages: TCustomImageList;
begin
  Result := FImages;
end;

function TSCGraphicControl.IsTransparent: Boolean;
begin
  Result := FTransparent;
end;

procedure TSCGraphicControl.AdjustClientRect(var Rect: TRect);
var
  B: Integer;
begin
  B := GetBorderSize + FBorderProps.Width + GetInnerBorderSize;
  InflateRect(Rect, -B, -B);
end;

procedure TSCGraphicControl.Assign(Source: TPersistent);
begin
  if Source is TControl then
  begin
    with TControl(Source) do
    begin
      Self.Align := Align;
      Self.Anchors := Anchors;
      Self.BiDiMode := BiDiMode;
      Self.Caption := Caption;
      Self.Color := Color;
      Self.Constraints := Constraints;
      Self.Cursor := Cursor;
      Self.DragCursor := DragCursor;
      Self.DragKind := DragKind;
      Self.DragMode := DragMode;
      Self.Enabled := Enabled;
      Self.Font := Font;
      Self.Hint := Hint;
      Self.ParentBiDiMode := ParentBiDiMode;
      Self.ParentColor := ParentColor;
      Self.ParentFont := ParentFont;
      Self.ShowHint := ShowHint;
      Self.Visible := Visible;
      Self.Width := Width;
      Self.Height := Height;
    end;

    if Source is TSCGraphicControl then
    begin
      with TSCGraphicControl(Source) do
      begin
        Self.DoubleBuffered := DoubleBuffered;
        Self.BorderProps := BorderProps;
        Self.MouseInControl := MouseInControl;
        Self.MouseIsDown := MouseIsDown;
        Self.ImageIndex := ImageIndex;
        Self.ImageLayout := ImageLayout;
        Self.Images := Images;
        Self.Indent := Indent;
        Self.MouseDownPoint := MouseDownPoint;
        Self.PictureIndex := PictureIndex;
        Self.PictureList := PictureList;
        Self.Spacing := Spacing;
        Self.Transparent := Transparent;
      end;
    end;
  end else
    inherited Assign(Source);
end;

function TSCGraphicControl.GetDefaultBackColor: TColor;
begin
  Result := Self.Color;
  if Result = clNone then
    Result := clBtnFace;
end;

function TSCGraphicControl.GetDefaultForeColor: TColor;
begin
  Result := Self.Font.Color;
  if Result = clNone then
    Result := clBtnText;
end;

function TSCGraphicControl.IsDesigning: Boolean;
begin
  Result := csDesigning in ComponentState;
end;

function TSCGraphicControl.IsDestroying: Boolean;
begin
  Result := csDestroying in ComponentState;
end;

function TSCGraphicControl.IsLoading: Boolean;
begin
  Result := csLoading in ComponentState;
end;

function TSCGraphicControl.IsLocked: Boolean;
begin
  Result := InUpdate or IsLoading or IsDestroying;
end;

function TSCGraphicControl.IsUpdating: Boolean;
begin
  Result := csUpdating in ComponentState;
end;

{$I SCVerRec.inc}

end.
