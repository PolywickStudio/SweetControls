{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCToolBar;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdActns, ActnList, Menus, SCConsts, SCCommon,
  SCControl;

type
  TSCToolItem = class;
  TSCCustomToolBar = class;

  TSCToolItemStyle = (sctbsButton, sctbcCheck, sctbsBottomDrop,
    sctbsDropDown, sctbsRightDrop, sctbsSeparator);

  TSCToolItem = class(TCollectionItem)
  private
    FAlignment: TAlignment;
    FCaption: TCaption;
    FDropdownMenu: TPopupMenu;
    FEnabled: Boolean;
    FGroupIndex: Integer;
    FHint: String;
    FImageIndex: TImageIndex;
    FMenuItem: TMenuItem;
    FMultiline: Boolean;
    FStyle: TSCToolItemStyle;
    FVisible: Boolean;
    FWidth: Integer;
    FTag: Integer;
    FOwner: TSCCustomToolBar;
    procedure SetAlignment(Value: TAlignment);
    procedure SetCaption(const Value: TCaption);
    function  GetDown: Boolean;
    procedure SetDown(Value: Boolean);
    procedure SetDropdownMenu(Value: TPopupMenu);
    procedure SetEnabled(Value: Boolean);
    procedure SetGroupIndex(Index: Integer);
    procedure SetHint(const Value: String);
    procedure SetImageIndex(Value: TImageIndex);
    function  GetLeft: Integer;
    procedure SetMenuItem(Value: TMenuItem);
    procedure SetMultiline(Value: Boolean);
    procedure SetStyle(Value: TSCToolItemStyle);
    procedure SetVisible(Value: Boolean);
    procedure SetWidth(Value: Integer);
    function  GetParent: TSCCustomToolBar;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); virtual;
    procedure Paint(ACanvas: TCanvas); virtual;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Invalidate;

    property Parent: TSCCustomToolBar read GetParent;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Caption: TCaption read FCaption write SetCaption;
    property Down: Boolean read GetDown write SetDown default False;
    property DropdownMenu: TPopupMenu read FDropdownMenu write SetDropdownMenu;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default -1;
    property Hint: String read FHint write SetHint;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Left: Integer read GetLeft;
    property MenuItem: TMenuItem read FMenuItem write SetMenuItem;
    property Multiline: Boolean read FMultiline write SetMultiline default True;
    property Style: TSCToolItemStyle read FStyle write SetStyle default sctbsButton;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Width: Integer read FWidth write SetWidth default -1;
  end;

  TSCToolItems = class(TCollection)
  private
    FOwner: TSCCustomToolBar;
    function  GetItem(Index: Integer): TSCToolItem;
    procedure SetItem(Index: Integer; Value: TSCToolItem);
  protected
    function  GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AToolBar: TSCCustomToolBar);
    function Add: TSCToolItem;

    {$IFDEF SC_DELPHI5_AND_EARLY}
    property Owner: TSCCustomToolBar read FOwner;
    {$ENDIF}
    property Items[Index: Integer]: TSCToolItem read GetItem
      write SetItem; default;
  end;

  TSCToolItemPart = (sctbpNone, sctbpButton, sctbpDropDown);

  TSCToolItemState = (sctmsDefault, sctmsDowned, sctmsDownedSelect,
    sctmsSelect);

  TSCToolBarGetColorEvent = procedure (Sender: TObject; AItem: TSCToolItem;
    APart: TSCToolItemPart; AState: TSCToolItemState; var AColor: TColor;
    var AFaceColor: TColor);

  TSCToolBarStyle = (sctsDefault, sctsFlat, sctsMetal, sctsOffice11,
    sctsOffice12, sctsOfficeXP);

  TSCCustomToolBar = class(TSCCustomControl)
  private
    FItems: TSCToolItems;
    procedure SetItems(Value: TSCToolItems);
  public
    property Items: TSCToolItems read FItems write SetItems;
  end;

implementation

end.

