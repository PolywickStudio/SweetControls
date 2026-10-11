{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCPropertyEditors;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {$IFDEF SC_DELPHI6_UP} Types, DesignEditors, DesignIntf, VCLEditors, {$ELSE}
  DsgnIntf, {$ENDIF} TypInfo, DB, ImgList, Menus, SCConsts, SCCommon, SCControl,
  SCStdControls, SCAdvEdits, SCButtonSet, SCPanels, SCEdits, SCMaskEdit,
  SCMaskEditor, SCMaskInputEditor, SCSimpleListbox, SCRadioGroup, SCCheckGroup,
  SCPageControl, SCTreeList, SCTreeListEditor, SCTreeColsEditor, SCNavBar;

type
  {$IFDEF SC_DELPHI6_UP}
  TSCCustomImageIndexProperty = class(TIntegerProperty, ICustomPropertyListDrawing)
  {$ELSE}
  TSCCustomImageIndexProperty = class(TIntegerProperty)
  {$ENDIF}
  public
    function  GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function  GetImageListAt(Index: Integer): TCustomImageList; virtual;

    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer); {$IFDEF SC_DELPHI5} override; {$ENDIF}
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer); {$IFDEF SC_DELPHI5} override; {$ENDIF}
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean); {$IFDEF SC_DELPHI5} override; {$ENDIF}
  end;

  {$IFDEF SC_DELPHI6_UP}
  TSCCustomPictureIndexProperty = class(TIntegerProperty, ICustomPropertyListDrawing)
  {$ELSE}
  TSCCustomPictureIndexProperty = class(TIntegerProperty)
  {$ENDIF}
  public
    function  GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function  GetPictureListAt(Index: Integer): TSCPictureList; virtual;

    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer); {$IFDEF SC_DELPHI5} override; {$ENDIF}
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer); {$IFDEF SC_DELPHI5} override; {$ENDIF}
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean); {$IFDEF SC_DELPHI5} override; {$ENDIF}
  end;

  TSCAboutProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

  TSCPictureIndexProperty = class(TSCCustomPictureIndexProperty)
  public
    function GetPictureListAt(Index: Integer): TSCPictureList; override;
  end;

  TSCImageIndexProperty = class(TSCCustomImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCNavTabLargeImageIndexProperty = class(TSCCustomImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCNavBarSheetLargeImageIndexProperty = class(TSCCustomImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCGraphicControlImageIndexProperty = class(TSCCustomImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCTreeColumnImageIndexProperty = class(TSCCustomImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCListboxExItemImageIndexProperty = class(TSCImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCComboboxExItemImageIndexProperty = class(TSCImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCEditButtonImageIndexProperty = class(TSCImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCAdvGroupCaptionImageIndexProperty = class(TSCImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCAdvGroupCaptionIconIndexProperty = class(TSCImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCLGroupStyleImageIndexProperty = class(TSCImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCLGroupStyleLargeImageIndexProperty = class(TSCImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCLGroupItemImageIndexProperty = class(TSCImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCLGroupItemLargeImageIndexProperty = class(TSCImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCLGroupScrollerImageIndexProperty = class(TSCImageIndexProperty)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TSCDataFieldProperty = class(TStringProperty)
  public
    function  GetAttributes: TPropertyAttributes; override;
    function  GetDataSourcePropName: string; virtual;
    procedure GetValueList(List: TStrings); virtual;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TSCListFieldProperty = class(TSCDataFieldProperty)
  public
    function GetDataSourcePropName: string; override;
  end;

  {$IFDEF SC_DELPHI6_UP}
  TSCCustomCompEditor = TDefaultEditor;
  {$ELSE}
  TSCCustomCompEditor = TComponentEditor;
  {$ENDIF}

  TSCComponentEditor = class(TSCCustomCompEditor)
  protected
    VerbIndex: Integer;
    {$IFDEF SC_DELPHI6_UP}
    procedure EditProperty(const PropertyEditor: IProperty;
      var Continue: Boolean); override;
    {$ELSE}
    FContinue : Boolean;
    procedure CheckEditP(PropertyEditor: TPropertyEditor); dynamic;
    {$ENDIF}
    function  GetItemName(Index: Integer): String; dynamic;
    function  CanExecute(Index: Integer): Boolean; dynamic;
    function  ExecuteCount: Integer; dynamic;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function  GetVerbCount: Integer; override;
  end;

  TSCAboutEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function  GetVerb(Index: Integer): string; override;
    function  GetVerbCount: Integer; override;
  end;

  TSCLoadSaveEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function  GetVerb(Index: Integer): string; override;
    function  GetVerbCount: Integer; override;
  end;

  TSCDefaultPropEditor = class(TSCComponentEditor)
  protected
    function GetVersionIndex: Integer; dynamic;
    function ExecuteCount: Integer; override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
  end;

  TSCNavTabControlEditor = class(TSCDefaultPropEditor)
  protected
    function NavTabControl: TSCNavTabControl;
    function ExecuteCount: Integer; override;
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

  TSCNavBarControlEditor = class(TSCDefaultPropEditor)
  protected
    function NavBarControl: TSCCustomNavBarControl;
    function ExecuteCount: Integer; override;
    function GetItemName(Index: Integer): String; override;
  public
    procedure Edit; override;
    function  GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

  TSCTreeListEditor = class(TSCDefaultPropEditor)
  protected
    function TreeList: TSCTreeList;
    function ExecuteCount: Integer; override;
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

  TSCTabControlEditor = class(TSCDefaultPropEditor)
  protected
    function TabControl: TSCTabControl;
    function ExecuteCount: Integer; override;
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

  TSCPageControlEditor = class(TSCDefaultPropEditor)
  protected
    function PageControl: TSCCustomPageControl;
    function ExecuteCount: Integer; override;
    function GetItemName(Index: Integer): String; override;
  public
    procedure Edit; override;
    function  GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

  TSCSimpleListboxItemsEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCPictureListItemsEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCComboboxItemEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCListboxExItemEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCComboboxExItemEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCStaticEditItemEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCListGroupItemEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCButtonSetButtonEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCRadioGroupButtonEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCCheckGroupButtonEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCHeaderColumnEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCStatusBarPanelEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCTabsetTabEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCEditMaskProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function  GetAttributes: TPropertyAttributes; override;
  end;

  TSCEditMaskInputProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function  GetAttributes: TPropertyAttributes; override;
  end;

  TSCImageBoxPictureEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

  TSCMeterSegmentEditor = class(TSCDefaultPropEditor)
  protected
    function GetItemName(Index: Integer): String; override;
  public
    function GetVerb(Index: Integer): string; override;
  end;

function UniqueName(AComponent: TComponent): string;

implementation

type
  TSCFakeCustomControl = class(TSCCustomControl);
  TSCFakePictureProps = class(TSCCustomPictureProps);
  TSCFakeGraphicControl = class(TSCGraphicControl);
  TSCFakeListboxExItem = class(TSCListboxExItem);
  TSCFakeEditButton = class(TSCEditButton);
  TSCFakeAdvGroupCaption = class(TSCAdvGroupCaption);
  TSCFakeListGroupItem = class(TSCListGroupItem);
  TSCFakeListGroupScroller = class(TSCListGroupScroller);
  TSCFakeComboboxExItem = class(TSCComboboxExItem);
  TSCFakeNavBarControl = class(TSCCustomNavControl);
  TSCFakeNavTabItems = class(TSCNavTabItems);

function TestName(const AName: string; AComponent: TComponent): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to AComponent.ComponentCount-1 do
    if CompareText(AComponent.Components[I].Name, AName) = 0 then
      Exit;

  Result := True;
end;

function UniqueName(AComponent: TComponent): string;
var
  I: Integer;
  Fmt: string;
begin
  Fmt := AComponent.ClassName + '%d';
  if CompareText(Copy(AComponent.ClassName, 1, 3), 'TSC') = 0 then
    Fmt := Copy(AComponent.ClassName, 4, 255) + '%d';

  if AComponent.Owner = nil then
  begin
    Result := Format(Fmt, [1]);
    Exit;
  end else
    for I := 1 to High(Integer) do
    begin
      Result := Format(Fmt, [I]);
      if TestName(Result, AComponent.Owner) then
        Exit;
    end;
end;

{ TSCCustomImageIndexProperty }

function TSCCustomImageIndexProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paRevertable];
end;

function TSCCustomImageIndexProperty.GetImageListAt(
  Index: Integer): TCustomImageList;
begin
  Result := nil;
end;

procedure TSCCustomImageIndexProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  ImgList: TCustomImageList;
begin
  ImgList := GetImageListAt(0);
  if Assigned(ImgList) then
    for I := 0 to ImgList.Count-1 do
      Proc(IntToStr(I));
end;

procedure TSCCustomImageIndexProperty.ListDrawValue(const Value: string;
  ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
var
  X: Integer;
  ImgList: TCustomImageList;
begin
  ImgList := GetImageListAt(0);
  ACanvas.FillRect(ARect);

  X := ARect.Left + 2;
  if Assigned(ImgList) then
  begin
    ImgList.Draw(ACanvas, X, ARect.Top + 2, StrToInt(Value));
    Inc (X, ImgList.Width);
  end;

  ACanvas.TextOut(X + 3, ARect.Top + 1, Value);
end;

procedure TSCCustomImageIndexProperty.ListMeasureHeight(
  const Value: string; ACanvas: TCanvas; var AHeight: Integer);
var
  ImgList: TCustomImageList;
begin
  ImgList := GetImageListAt(0);
  AHeight := ACanvas.TextHeight(Value) + 2;
  if Assigned(ImgList) and (ImgList.Height + 4 > AHeight) then
    AHeight := ImgList.Height + 4;
end;

procedure TSCCustomImageIndexProperty.ListMeasureWidth(
  const Value: string; ACanvas: TCanvas; var AWidth: Integer);
var
  ImgList: TCustomImageList;
begin
  ImgList := GetImageListAt(0);
  AWidth := ACanvas.TextWidth(Value) + 4;
  if Assigned(ImgList) then
    Inc (AWidth, ImgList.Width);
end;

{ TSCCustomPictureIndexProperty }

function TSCCustomPictureIndexProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paRevertable];
end;

function TSCCustomPictureIndexProperty.GetPictureListAt(
  Index: Integer): TSCPictureList;
begin
  Result := nil;
end;

procedure TSCCustomPictureIndexProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  PicList: TSCPictureList;
begin
  PicList := GetPictureListAt(0);
  if Assigned(PicList) and Assigned(PicList.Pictures) then
    for I := 0 to PicList.Pictures.Count-1 do
      Proc(IntToStr(I));
end;

procedure TSCCustomPictureIndexProperty.ListDrawValue(const Value: string;
  ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
var
  R: TRect;
  P: TPicture;
  X, Index: Integer;
  PicList: TSCPictureList;
begin
  PicList := GetPictureListAt(0);
  ACanvas.FillRect(ARect);

  X := ARect.Left + 2;
  if Assigned(PicList) and Assigned(PicList.Pictures) then
  begin
    Index := StrToIntDef(Value, -1);

    if (Index > -1) and (Index < PicList.Pictures.Count) then
    begin
      P := PicList.Pictures[Index].Picture;

      if Assigned(P) and Assigned(P.Graphic) and
        not P.Graphic.Empty and (P.Width > 0) and (P.Height > 0) then
      begin
        R := Rect(X, ARect.Top + 2, X + 20, ARect.Top + 22);
        ACanvas.StretchDraw(R, P.Graphic);
      end;
    end;
    
    Inc(X, 20);
  end;

  ACanvas.TextOut(X + 3, ARect.Top + 1, Value);
end;

procedure TSCCustomPictureIndexProperty.ListMeasureHeight(
  const Value: string; ACanvas: TCanvas; var AHeight: Integer);
var
  PicList: TSCPictureList;
begin
  PicList := GetPictureListAt(0);
  AHeight := ACanvas.TextHeight(Value) + 2;
  if Assigned(PicList) and (24 > AHeight) then
    AHeight := 24;
end;

procedure TSCCustomPictureIndexProperty.ListMeasureWidth(
  const Value: string; ACanvas: TCanvas; var AWidth: Integer);
var
  PicList: TSCPictureList;
begin
  PicList := GetPictureListAt(0);
  AWidth := ACanvas.TextWidth(Value) + 4;
  if Assigned(PicList) then
    Inc(AWidth, 20);
end;

{ TSCPictureIndexProperty }

function TSCPictureIndexProperty.GetPictureListAt(Index: Integer): TSCPictureList;
var
  C: TPersistent;
  Pp: TSCFakePictureProps;
  Gc: TSCFakeGraphicControl;
  Cc: TSCFakeCustomControl;
begin
  Result := nil;
  C := GetComponent(Index);
  if C is TSCCustomControl then
  begin
    Cc := TSCFakeCustomControl(C);
    Result := Cc.PictureList;
  end else
  if C is TSCGraphicControl then
  begin
    Gc := TSCFakeGraphicControl(C);
    Result := Gc.PictureList;
  end else
  if C is TSCCustomPictureProps then
  begin
    Pp := TSCFakePictureProps(C);
    Result := Pp.PictureList;
  end;
end;

{ TSCImageIndexProperty }

function TSCImageIndexProperty.GetImageListAt(Index: Integer): TCustomImageList;
var
  C: TPersistent;
  Item: TSCFakeCustomControl;
begin
  Result := nil;
  C := GetComponent(Index);
  if C is TSCCustomControl then
  begin
    Item := TSCFakeCustomControl(C);
    Result := Item.GetImages;
  end;
end;

{ TSCNavTabLargeImageIndexProperty }

function TSCNavTabLargeImageIndexProperty.GetImageListAt(Index: Integer): TCustomImageList;
var
  C: TPersistent;
  Collection: TSCNavTabItems;
  Item: TSCFakeNavBarControl;
begin
  Result := nil;
  C := GetComponent(Index);
  if (C is TSCNavTabItem) then
  begin
    Collection := TSCNavTabItems(TSCNavTabItem(C).Collection);

    if Collection <> nil then
    begin
      Item := TSCFakeNavBarControl(TSCFakeNavTabItems(Collection).GetOwner);
      if Item <> nil then
        Result := Item.GetLargeImages;
    end;
  end;
end;

{ TSCNavBarSheetLargeImageIndexProperty }

function TSCNavBarSheetLargeImageIndexProperty.GetImageListAt(Index: Integer): TCustomImageList;
var
  C: TPersistent;
  Item: TSCFakeNavBarControl;
begin
  Result := nil;
  C := GetComponent(Index);
  if (C is TSCNavBarSheet) and (TSCNavBarSheet(C).Parent is TSCCustomNavBarControl) then
  begin
    Item := TSCFakeNavBarControl(TSCNavBarSheet(C).Parent);
    if Item <> nil then
      Result := Item.GetLargeImages;
  end;
end;

{ TSCGraphicControlImageIndexProperty }

function TSCGraphicControlImageIndexProperty.GetImageListAt(Index: Integer): TCustomImageList;
var
  C: TPersistent;
  Item: TSCFakeGraphicControl;
begin
  Result := nil;
  C := GetComponent(Index);
  if C is TSCGraphicControl then
  begin
    Item := TSCFakeGraphicControl(C);
    Result := Item.GetImages;
  end;
end;

{ TSCTreeColumnImageIndexProperty }

function TSCTreeColumnImageIndexProperty.GetImageListAt(Index: Integer): TCustomImageList;
var
  C: TPersistent;
begin
  Result := nil;
  C := GetComponent(Index);

  if C is TSCTreeColumn then
    Result := TSCTreeColumn(C).ImageList;
end;

{ TSCListboxExItemImageIndexProperty }

function TSCListboxExItemImageIndexProperty.GetImageListAt(Index: Integer): TCustomImageList;
var
  C: TPersistent;
begin
  Result := nil;
  C := GetComponent(Index);

  if (C <> nil) and (C is TSCListboxExItem) then
    Result := TSCFakeListboxExItem(C).GetImages;
end;

{ TSCEditButtonImageIndexProperty }

function TSCEditButtonImageIndexProperty.GetImageListAt(Index: Integer): TCustomImageList;
var
  C: TPersistent;
begin
  Result := nil;
  C := GetComponent(Index);

  if (C <> nil) and (C is TSCEditButton) then
    Result := TSCFakeEditButton(C).GetImages;
end;

{ TSCAdvGroupCaptionImageIndexProperty }

function TSCAdvGroupCaptionImageIndexProperty.GetImageListAt(
  Index: Integer): TCustomImageList;
var
  C: TPersistent;
begin
  Result := nil;
  C := GetComponent(Index);

  if (C <> nil) and (C is TSCAdvGroupCaption) then
    Result := TSCFakeAdvGroupCaption(C).GetImages;
end;

{ TSCAdvGroupCaptionIconIndexProperty }

function TSCAdvGroupCaptionIconIndexProperty.GetImageListAt(
  Index: Integer): TCustomImageList;
var
  C: TPersistent;
begin
  Result := nil;
  C := GetComponent(Index);

  if (C <> nil) and (C is TSCAdvGroupCaption) then
    Result := TSCFakeAdvGroupCaption(C).GetIcons;
end;

{ TSCLGroupStyleImageIndexProperty }

function TSCLGroupStyleImageIndexProperty.GetImageListAt(Index: Integer): TCustomImageList;
var
  C: TPersistent;
begin
  Result := nil;
  C := GetComponent(Index);

  if (C <> nil) and (C is TSCListGroupStyle) then
    Result := TSCListGroupStyle(C).Images;
end;

{ TSCLGroupStyleLargeImageIndexProperty }

function TSCLGroupStyleLargeImageIndexProperty.GetImageListAt(Index: Integer): TCustomImageList;
var
  C: TPersistent;
begin
  Result := nil;
  C := GetComponent(Index);

  if (C <> nil) and (C is TSCListGroupStyle) then
    Result := TSCListGroupStyle(C).LargeImages;
end;

{ TSCLGroupItemImageIndexProperty }

function TSCLGroupItemImageIndexProperty.GetImageListAt(Index: Integer): TCustomImageList;
var
  C: TPersistent;
begin
  Result := nil;
  C := GetComponent(Index);

  if (C <> nil) and (C is TSCListGroupItem) then
    Result := TSCFakeListGroupItem(C).GetImages;
end;

{ TSCLGroupItemLargeImageIndexProperty }

function TSCLGroupItemLargeImageIndexProperty.GetImageListAt(
  Index: Integer): TCustomImageList;
var
  C: TPersistent;
begin
  Result := nil;
  C := GetComponent(Index);

  if (C <> nil) and (C is TSCListGroupItem) then
    Result := TSCFakeListGroupItem(C).GetLargeImages;
end;

{ TSCLGroupScrollerImageIndexProperty }

function TSCLGroupScrollerImageIndexProperty.GetImageListAt(Index: Integer): TCustomImageList;
var
  C: TPersistent;
begin
  Result := nil;
  C := GetComponent(Index);

  if (C <> nil) and (C is TSCListGroupScroller) then
    Result := TSCFakeListGroupScroller(C).GetImages;
end;

{ TSCDataFieldProperty }

function GetPropertyValue(Instance: TPersistent; const PropName: string): TPersistent;
var
  PropInfo: PPropInfo;
begin
  Result := nil;
  PropInfo := TypInfo.GetPropInfo(Instance.ClassInfo, PropName);
  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkClass) then
    Result := TObject(GetOrdProp(Instance, PropInfo)) as TPersistent;
end;

function TSCDataFieldProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

function TSCDataFieldProperty.GetDataSourcePropName: string;
begin
  Result := 'DataSource';
end;

procedure TSCDataFieldProperty.GetValueList(List: TStrings);
var
  DataSource: TDataSource;
begin
  DataSource := GetPropertyValue(GetComponent(0), GetDataSourcePropName) as TDataSource;
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    DataSource.DataSet.GetFieldNames(List);
end;

procedure TSCDataFieldProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

{ TSCListFieldProperty }

function TSCListFieldProperty.GetDataSourcePropName: string;
begin
  Result := 'ListSource';
end;

{ TSCComponentEditor }

function TSCComponentEditor.GetItemName(Index: Integer): String;
begin
  Result := '';
end;

{$IFDEF SC_DELPHI6_UP}
procedure TSCComponentEditor.EditProperty(const PropertyEditor: IProperty;
  var Continue: Boolean);
var
  PropName: string;
begin
  if not CanExecute(VerbIndex) then
  begin
    inherited EditProperty(PropertyEditor, Continue);
    Exit;
  end;

  PropName := PropertyEditor.GetName;
  if CompareText(PropertyEditor.GetName, GetItemName(VerbIndex)) = 0 then
  begin
    PropertyEditor.Edit;
    Continue := False;
    VerbIndex := 0;
  end;
end;
{$ELSE}
procedure TSCComponentEditor.CheckEditP(PropertyEditor: TPropertyEditor);
begin
  try
    if FContinue and CanExecute(VerbIndex) and
      (CompareText(PropertyEditor.GetName, GetItemName(VerbIndex)) = 0) then
    begin
      PropertyEditor.Edit;
      FContinue := False;
    end;
  finally
    PropertyEditor.Free;
  end;
end;
{$ENDIF}

procedure TSCComponentEditor.ExecuteVerb(Index: Integer);
{$IFNDEF SC_DELPHI6_UP}
var
  {$IFDEF SC_DELPHI5}
  Components: TDesignerSelectionList;
  {$ELSE}
  Components: TComponentList;
  {$ENDIF}
{$ENDIF}
begin
  VerbIndex := -1;
  if not CanExecute(Index) then
  begin
    inherited ExecuteVerb(Index);
    Exit;
  end;

  VerbIndex := Index;
  {$IFDEF SC_DELPHI6_UP}
  Edit;
  {$ELSE}
  {$IFDEF SC_DELPHI5}
  Components := TDesignerSelectionList.Create;
  {$ELSE}
  Components := TComponentList.Create;
  {$ENDIF}
  try
    FContinue := True;
    Components.Add(Component);
    GetComponentProperties(Components, tkAny, Designer, CheckEditP);
  finally
    Components.Free;
  end;
  {$ENDIF}
  Designer.Modified;
end;

function TSCComponentEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TSCComponentEditor.CanExecute(Index: Integer): Boolean;
begin
  Result := (Index > -1) and (Index < GetVerbCount) and
    (ExecuteCount > 0) and (Index < ExecuteCount);
end;

function TSCComponentEditor.ExecuteCount: Integer;
begin
  Result := 0;
end;

{ TSCAboutEditor }

function TSCAboutEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := SC_VersionStr
  else
  if Index = 1 then
    Result := '-';
end;

procedure TSCAboutEditor.ExecuteVerb(Index: Integer);
begin
  //
end;

function TSCAboutEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

{ TSCLoadSaveEditor }

function TSCLoadSaveEditor.GetVerb(Index: Integer): string;
begin
  Result := '';
  case Index of
    0: Result := SC_VersionStr;
    1: Result := '-';
    2: Result := 'Save to file ...';
    3: Result := 'Load from file ...';
    4: Result := '-';
  end;
end;

procedure TSCLoadSaveEditor.ExecuteVerb(Index: Integer);
var
  S, Ext: String;
  Sd: TSaveDialog;
  Od: TOpenDialog;
begin
  if Component is TSCCustomControl then
  begin
    case Index of
      2:
      begin
        Sd := TSaveDialog.Create(Application);
        try
          Sd.Filter := 'SweetControl Properties file (*.scp)|*.scp';
          Sd.FilterIndex := 1;
          Sd.DefaultExt := 'scf';
          Sd.Title := 'Save control properties ...';

          Sd.Options := Sd.Options + [ofOverwritePrompt];

          if Sd.Execute then
          begin
            S := Sd.FileName;
            Ext := ExtractFileExt(S);

            if not AnsiSameText('.scp', Ext) then
              S := S + '.scp';

            TSCCustomControl(Component).SaveToFile(S);
          end;  
        finally
          Sd.Free;
        end;
      end;
      3:
      begin
        Od := TOpenDialog.Create(Application);
        try
          Od.Filter := 'SweetControl file (*.scp)|*.scp';
          Od.FilterIndex := 1;
          Od.Title := 'Load control properties ...';

          if Od.Execute and FileExists(Od.FileName) then
            TSCCustomControl(Component).LoadFromFile(Od.FileName);
        finally
          Od.Free;
        end;
      end;
    end;
  end;  
end;

function TSCLoadSaveEditor.GetVerbCount: Integer;
begin
  {$IFDEF SC_DELPHI5}
    Result := 5;
  {$ELSE}
    Result := 4;
  {$ENDIF}
end;

{ TSCDefaultPropEditor }

function TSCDefaultPropEditor.ExecuteCount: Integer;
begin
  Result := 1;
end;

function TSCDefaultPropEditor.GetVerb(Index: Integer): string;
var
  VerbCnt, ExCnt: Integer;
begin
  VerbCnt := GetVerbCount;
  ExCnt   := ExecuteCount;

  if ExCnt > VerbCnt then ExCnt := VerbCnt;
  if ExCnt < 0 then ExCnt := 0;

  Result := '';

  if ExCnt = 0 then
  begin
    if Index = 0 then
      Result := SC_VersionStr
    else
    if Index = 1 then
      Result := '-';
  end else
  begin
    if Index = ExCnt then
      Result := '-'
    else
    if Index = ExCnt + 1 then
      Result := SC_VersionStr
    else
    if Index = ExCnt + 2 then
      Result := '-';
  end;
end;

function TSCDefaultPropEditor.GetVerbCount: Integer;
begin
  Result := ExecuteCount;
  if Result < 0 then Result := 0;

  Inc(Result, 2);
end;

function TSCDefaultPropEditor.GetVersionIndex: Integer;
var
  VerbCnt, ExCnt: Integer;
begin
  VerbCnt := GetVerbCount;
  ExCnt   := ExecuteCount;

  if ExCnt > VerbCnt then ExCnt := VerbCnt;
  if ExCnt < 0 then ExCnt := 0;

  Result := -1;
  if VerbCnt > 0 then
  begin
    Result := 0;
    if ExCnt > 0 then Result := ExCnt + 1;
  end;
end;

{ TSCListboxExItemEditor }

function TSCListboxExItemEditor.GetItemName(Index: Integer): String;
begin
  Result := 'ItemsEx';
end;

function TSCListboxExItemEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Items Editor...';
end;

{ TSCListGroupItemEditor }

function TSCListGroupItemEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Items';
end;

function TSCListGroupItemEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Items Editor...';
end;

{ TSCButtonSetButtonEditor }

function TSCButtonSetButtonEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Buttons';
end;

function TSCButtonSetButtonEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Buttons Editor...';
end;

{ TSCRadioGroupButtonEditor }

function TSCRadioGroupButtonEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Items';
end;

function TSCRadioGroupButtonEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Items Editor...';
end;

{ TSCCheckGroupButtonEditor }

function TSCCheckGroupButtonEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Items';
end;

function TSCCheckGroupButtonEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Items Editor...';
end;

{ TSCHeaderColumnEditor }

function TSCHeaderColumnEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Columns';
end;

function TSCHeaderColumnEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Columns Editor...';
end;

{ TSCStatusBarPanelEditor }

function TSCStatusBarPanelEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Panels';
end;

function TSCStatusBarPanelEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Panels Editor...';
end;

{ TSCTabsetTabEditor }

function TSCTabsetTabEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Tabs';
end;

function TSCTabsetTabEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Tabs Editor...';
end;

{ TSCEditMaskProperty }

procedure TSCEditMaskProperty.Edit;
var
  C: TPersistent;
  MaskDlg: TSCMaskEditorForm;
begin
  C := GetComponent(0);

  if C is TSCCustomMaskEdit then
  begin
    MaskDlg := TSCMaskEditorForm.Create(Application);
    try
      MaskDlg.Mask := TSCMaskEdit(C).EditMask;

      if (MaskDlg.ShowModal = mrOK) and
        (MaskDlg.Mask <> TSCMaskEdit(C).EditMask) then
      begin
        TSCMaskEdit(C).EditMask := MaskDlg.Mask;
        Designer.Modified;
      end;
    finally
      MaskDlg.Free;
    end;
  end;
end;

function TSCEditMaskProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{ TSCEditMaskInputProperty }

procedure TSCEditMaskInputProperty.Edit;
var
  C: TPersistent;
  MaskInputDlg: TSCMaskInputForm;
begin
  C := GetComponent(0);

  if C is TSCMaskEdit then
  begin
    MaskInputDlg := TSCMaskInputForm.Create(Application);
    try
      MaskInputDlg.Mask := TSCMaskEdit(C).EditMask;

      if (MaskInputDlg.ShowModal = mrOK) and
        (MaskInputDlg.Mask <> TSCMaskEdit(C).EditMask) then
      begin
        TSCMaskEdit(C).EditMask := MaskInputDlg.Mask;
        Designer.Modified;
      end;
    finally
      MaskInputDlg.Free;
    end;
  end;
end;

function TSCEditMaskInputProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{ TSCComboboxExItemImageIndexProperty }

function TSCComboboxExItemImageIndexProperty.GetImageListAt(
  Index: Integer): TCustomImageList;
var
  C: TPersistent;
begin
  Result := nil;
  C := GetComponent(Index);

  if (C <> nil) and (C is TSCComboboxExItem) then
    Result := TSCFakeComboboxExItem(C).GetImages;
end;

{ TSCComboboxExItemEditor }

function TSCComboboxExItemEditor.GetItemName(Index: Integer): String;
begin
  Result := 'ItemsEx';
end;

function TSCComboboxExItemEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Items Editor...';
end;

{ TSCStaticEditItemEditor }

function TSCStaticEditItemEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Items';
end;

function TSCStaticEditItemEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Items Editor...';
end;

{ TSCNavTabControlEditor }

function TSCNavTabControlEditor.ExecuteCount: Integer;
begin
  Result := inherited ExecuteCount + 2;
end;

function TSCNavTabControlEditor.GetItemName(Index: Integer): String;
begin
  Result := '';
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetItemName(Index)
  else if Index = 0 then
    Result := 'Tabs';
end;

function TSCNavTabControlEditor.GetVerb(Index: Integer): string;
begin
  Result := inherited GetVerb(Index);
  if Index = 0 then
    Result := 'Tabs Editor...'
  else if Index = 1 then
    Result := 'Next Tab'
  else if Index = 2 then
    Result := 'Previous Tab';
end;

function TSCNavTabControlEditor.NavTabControl: TSCNavTabControl;
begin
  Result := nil;
  if Component is TSCNavTabControl then
    Result := TSCNavTabControl(Component);
end;

procedure TSCNavTabControlEditor.ExecuteVerb(Index: Integer);
var
  I, ActiveIndex: Integer;
  NavTabCtrl: TSCNavTabControl;
begin
  NavTabCtrl := NavTabControl;

  if NavTabCtrl <> nil then
  begin
    case Index of
      1:
      begin
        ActiveIndex := -1;
        for I := NavTabCtrl.TabIndex+1 to NavTabCtrl.TabCount-1 do
          if NavTabCtrl.Tabs[I].Visible then
          begin
            ActiveIndex := I;
            Break;
          end;

        if ActiveIndex = -1 then
          for I := 0 to NavTabCtrl.TabCount-1 do
            if NavTabCtrl.Tabs[I].Visible then
            begin
              ActiveIndex := I;
              Break;
            end;

        NavTabCtrl.TabIndex := ActiveIndex;
      end;
      2:
      begin
        ActiveIndex := -1;
        for I := NavTabCtrl.TabIndex-1 downto 0 do
          if NavTabCtrl.Tabs[I].Visible then
          begin
            ActiveIndex := I;
            Break;
          end;

        if ActiveIndex = -1 then
          for I := NavTabCtrl.TabCount-1 downto 0 do
            if NavTabCtrl.Tabs[I].Visible then
            begin
              ActiveIndex := I;
              Break;
            end;

        NavTabCtrl.TabIndex := ActiveIndex;
      end;
      else
        inherited ExecuteVerb(Index);
    end;
  end;
end;

{ TSCNavBarControlEditor }

function TSCNavBarControlEditor.NavBarControl: TSCCustomNavBarControl;
begin
  Result := nil;
  if Component is TSCCustomNavBarControl then
    Result := TSCCustomNavBarControl(Component)
  else if Component is TSCNavBarSheet then
    Result := TSCNavBarSheet(Component).NavBarControl;
end;

function TSCNavBarControlEditor.ExecuteCount: Integer;
begin
  Result := inherited ExecuteCount + 2;
end;

function TSCNavBarControlEditor.GetItemName(Index: Integer): String;
begin
  Result := inherited GetItemName(Index);
end;

function TSCNavBarControlEditor.GetVerb(Index: Integer): string;
begin
  Result := inherited GetVerb(Index);
  if Index = 0 then
    Result := 'New Bar'
  else if Index = 1 then
    Result := 'Next Bar'
  else if Index = 2 then
    Result := 'Previous Bar';
end;

procedure TSCNavBarControlEditor.ExecuteVerb(Index: Integer);
var
  Bar: TSCNavBarSheet;
  NavBarCtrl: TSCCustomNavBarControl;
  I, BarIndex: Integer;
  {$IFDEF SC_DELPHI6_UP}
  Designer: IDesigner;
  {$ELSE}
  Designer: IFormDesigner;
  {$ENDIF}
begin
  NavBarCtrl := NavBarControl;

  if NavBarCtrl <> nil then
  begin
    Designer := Self.Designer;

    case Index of
      0:
      begin
        {$IFDEF SC_DELPHI6_UP}
        Bar := TSCNavBarSheet.Create(Designer.Root);
        {$ELSE}
        Bar := TSCNavBarSheet.Create(Designer.GetRoot);
        {$ENDIF}

        try
          Bar.Name := UniqueName(Bar);
          Bar.NavBarControl := NavBarCtrl;
        except
          Bar.Free;
          raise;
        end;

        NavBarCtrl.ActiveBar := Bar;
        Designer.SelectComponent(Bar);
        Designer.Modified;
      end;
      1:
      begin
        BarIndex := -1;
        for I := NavBarCtrl.ActiveBarIndex + 1 to NavBarCtrl.BarCount - 1 do
          if NavBarCtrl.Bars[I].Visible then
          begin
            BarIndex := I;
            Break;
          end;

        if BarIndex = -1 then
          for I := 0 to NavBarCtrl.BarCount - 1 do
            if NavBarCtrl.Bars[I].Visible then
            begin
              BarIndex := I;
              Break;
            end;

        if (BarIndex > -1) and (BarIndex < NavBarCtrl.BarCount) then
          NavBarCtrl.ActiveBarIndex := BarIndex;
      end;
      2:
      begin
        BarIndex := -1;
        for I := NavBarCtrl.ActiveBarIndex - 1 downto 0 do
          if NavBarCtrl.Bars[I].Visible then
          begin
            BarIndex := I;
            Break;
          end;

        if BarIndex = -1 then
          for I := NavBarCtrl.BarCount-1 downto 0 do
            if NavBarCtrl.Bars[I].Visible then
            begin
              BarIndex := I;
              Break;
            end;

        if (BarIndex > -1) and (BarIndex < NavBarCtrl.BarCount) then
          NavBarCtrl.ActiveBarIndex := BarIndex;
      end;
    end;
  end;
end;

procedure TSCNavBarControlEditor.Edit;
begin
  //
end;

{ TSCTreeListEditor }

function TSCTreeListEditor.ExecuteCount: Integer;
begin
  Result := inherited ExecuteCount;
end;

function TSCTreeListEditor.GetItemName(Index: Integer): String;
begin
  Result := '';
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetItemName(Index)
  else if Index = 0 then
    Result := 'Columns'
  else if Index = 1 then
    Result := 'Items';
end;

function TSCTreeListEditor.GetVerb(Index: Integer): string;
begin
  Result := inherited GetVerb(Index);
  if Index = 0 then
    Result := 'Columns Editor...'
  else if Index = 1 then
    Result := 'Items Editor...';
end;

function TSCTreeListEditor.TreeList: TSCTreeList;
begin
  Result := nil;
  if Component is TSCTreeList then
    Result := TSCTreeList(Component);
end;

procedure TSCTreeListEditor.ExecuteVerb(Index: Integer);
begin
  if TreeList <> nil then
  begin
    if Index = 0 then
      TSCTreeColsForm.ShowEditor(TreeList, Pointer(Designer))
    else
    if Index = 1 then
    begin
      if TTreeListEditorForm.ShowEditor(TreeList) then
        Designer.Modified;
    end;
  end;
end;

{ TSCTabControlEditor }

function TSCTabControlEditor.ExecuteCount: Integer;
begin
  Result := inherited ExecuteCount + 2;
end;

function TSCTabControlEditor.GetItemName(Index: Integer): String;
begin
  Result := '';
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetItemName(Index)
  else if Index = 0 then
    Result := 'Tabs';
end;

function TSCTabControlEditor.GetVerb(Index: Integer): string;
begin
  Result := inherited GetVerb(Index);
  if Index = 0 then
    Result := 'Tabs Editor...'
  else if Index = 1 then
    Result := 'Next Tab'
  else if Index = 2 then
    Result := 'Previous Tab';
end;

function TSCTabControlEditor.TabControl: TSCTabControl;
begin
  Result := nil;
  if Component is TSCTabControl then
    Result := TSCTabControl(Component);
end;

procedure TSCTabControlEditor.ExecuteVerb(Index: Integer);
var
  I, TabIndex: Integer;
  TabCtrl: TSCTabControl;
begin
  TabCtrl := TabControl;

  if TabCtrl <> nil then
  begin
    case Index of
      1:
      begin
        TabIndex := -1;
        for I := TabCtrl.TabIndex+1 to TabCtrl.Tabs.Count-1 do
          if TabCtrl.Tabs[I].Visible then
          begin
            TabIndex := I;
            Break;
          end;

        if TabIndex = -1 then
          for I := 0 to TabCtrl.Tabs.Count-1 do
            if TabCtrl.Tabs[I].Visible then
            begin
              TabIndex := I;
              Break;
            end;

        TabCtrl.TabIndex := TabIndex;
      end;
      2:
      begin
        TabIndex := -1;
        for I := TabCtrl.TabIndex-1 downto 0 do
          if TabCtrl.Tabs[I].Visible then
          begin
            TabIndex := I;
            Break;
          end;

        if TabIndex = -1 then
          for I := TabCtrl.Tabs.Count-1 downto 0 do
            if TabCtrl.Tabs[I].Visible then
            begin
              TabIndex := I;
              Break;
            end;

        TabCtrl.TabIndex := TabIndex;
      end;
      else
        inherited ExecuteVerb(Index);
    end;
  end;
end;

{ TSCPageControlEditor }

function TSCPageControlEditor.PageControl: TSCCustomPageControl;
begin
  Result := nil;
  if Component is TSCCustomPageControl then
    Result := TSCCustomPageControl(Component)
  else if Component is TSCTabSheet then
    Result := TSCTabSheet(Component).PageControl;
end;

function TSCPageControlEditor.ExecuteCount: Integer;
begin
  Result := inherited ExecuteCount + 2;
end;

function TSCPageControlEditor.GetItemName(Index: Integer): String;
begin
  Result := inherited GetItemName(Index);
end;

function TSCPageControlEditor.GetVerb(Index: Integer): string;
begin
  Result := inherited GetVerb(Index);
  if Index = 0 then
    Result := 'New Page'
  else if Index = 1 then
    Result := 'Next Page'
  else if Index = 2 then
    Result := 'Previous Page';
end;

procedure TSCPageControlEditor.ExecuteVerb(Index: Integer);
var
  Page: TSCTabSheet;
  PgCtrl: TSCCustomPageControl;
  I, PgIndex: Integer;
  {$IFDEF SC_DELPHI6_UP}
  Designer: IDesigner;
  {$ELSE}
  Designer: IFormDesigner;
  {$ENDIF}
begin
  PgCtrl := PageControl;

  if PgCtrl <> nil then
  begin
    Designer := Self.Designer;

    case Index of
      0:
      begin
        {$IFDEF SC_DELPHI6_UP}
        Page := TSCTabSheet.Create(Designer.Root);
        {$ELSE}
        Page := TSCTabSheet.Create(Designer.GetRoot);
        {$ENDIF}

        try
          Page.Name := UniqueName(Page);
          Page.PageControl := PgCtrl;
        except
          Page.Free;
          raise;
        end;

        PgCtrl.ActivePage := Page;
        Designer.SelectComponent(Page);
        Designer.Modified;
      end;
      1:
      begin
        PgIndex := -1;
        for I := PgCtrl.ActivePageIndex + 1 to PgCtrl.PageCount - 1 do
          if PgCtrl.Pages[I].TabVisible then
          begin
            PgIndex := I;
            Break;
          end;

        if PgIndex = -1 then
          for I := 0 to PgCtrl.PageCount - 1 do
            if PgCtrl.Pages[I].TabVisible then
            begin
              PgIndex := I;
              Break;
            end;

        if (PgIndex > -1) and (PgIndex < PgCtrl.PageCount) then
          PgCtrl.ActivePageIndex := PgIndex;
      end;
      2:
      begin
        PgIndex := -1;
        for I := PgCtrl.ActivePageIndex - 1 downto 0 do
          if PgCtrl.Pages[I].TabVisible then
          begin
            PgIndex := I;
            Break;
          end;

        if PgIndex = -1 then
          for I := PgCtrl.PageCount-1 downto 0 do
            if PgCtrl.Pages[I].TabVisible then
            begin
              PgIndex := I;
              Break;
            end;

        if (PgIndex > -1) and (PgIndex < PgCtrl.PageCount) then
          PgCtrl.ActivePageIndex := PgIndex;
      end;
    end;
  end;
end;

procedure TSCPageControlEditor.Edit;
begin
  //
end;

{ TSCSimpleListboxItemsEditor }

function TSCSimpleListboxItemsEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Items';
end;

function TSCSimpleListboxItemsEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Items Editor...';
end;

{ TSCComboboxItemEditor }

function TSCComboboxItemEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Items';
end;

function TSCComboboxItemEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Items Editor...';
end;

{ TSCAboutProperty }

function TSCAboutProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paReadOnly];
end;

{ TSCPictureListItemsEditor }

function TSCPictureListItemsEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Pictures';
end;

function TSCPictureListItemsEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Pictures Editor...';
end;

{ TSCImageBoxPictureEditor }

function TSCImageBoxPictureEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Picture';
end;

function TSCImageBoxPictureEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Picture Editor...';
end;

{ TSCMeterSegmentEditor }

function TSCMeterSegmentEditor.GetItemName(Index: Integer): String;
begin
  Result := 'Segments';
end;

function TSCMeterSegmentEditor.GetVerb(Index: Integer): string;
begin
  if (ExecuteCount = 0) or (Index >= ExecuteCount) then
    Result := inherited GetVerb(Index)
  else
    Result := 'Segments ...';
end;

{$I SCVerRec.inc}

end.
