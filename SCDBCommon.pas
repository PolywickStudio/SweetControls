{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCDbCommon;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, Db, {$IFDEF SC_DELPHI6_UP} Variants, {$ENDIF} SCConsts, SCCommon,
  SCControl, SCResStrs;

type
  TSCDbInvalidText = (scitAuto, scitMinValue, scitNull, scitZero);

  TSCFieldDataLink = class(TDataLink)
  private
    FField: TField;
    FFieldName: string;
    FControl: TComponent;
    FEditing: Boolean;
    FModified: Boolean;
    FOnDataChange: TNotifyEvent;
    FOnEditingChange: TNotifyEvent;
    FOnUpdateData: TNotifyEvent;
    FOnActiveChange: TNotifyEvent;
    function  GetCanModify: Boolean;
    procedure SetEditing(Value: Boolean);
    procedure SetField(Value: TField);
    procedure SetFieldName(const Value: string);
    procedure UpdateField;
    procedure UpdateRightToLeft;
  protected
    procedure ActiveChanged; override;
    procedure EditingChanged; override;
    procedure FocusControl(Field: TFieldRef); override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure UpdateData; override;
  public
    constructor Create;

    function  Edit: Boolean;
    procedure Modified;
    function  GetModified: Boolean;
    procedure Reset;

    property CanModify: Boolean read GetCanModify;
    property Control: TComponent read FControl write FControl;
    property Editing: Boolean read FEditing;
    property Field: TField read FField;
    property FieldName: string read FFieldName write SetFieldName;
    property OnDataChange: TNotifyEvent read FOnDataChange write FOnDataChange;
    property OnEditingChange: TNotifyEvent read FOnEditingChange write FOnEditingChange;
    property OnUpdateData: TNotifyEvent read FOnUpdateData write FOnUpdateData;
    property OnActiveChange: TNotifyEvent read FOnActiveChange write FOnActiveChange;
  end;

  TSCPaintControl = class
  private
    FOwner: TWinControl;
    FClassName: string;
    FHandle: HWnd;
    FObjectInstance: Pointer;
    FDefWindowProc: Pointer;
    FCtl3dButton: Boolean;
    function GetHandle: HWnd;
    procedure SetCtl3DButton(Value: Boolean);
    procedure WndProc(var Message: TMessage);
  public
    constructor Create(AOwner: TWinControl; const ClassName: string);
    destructor Destroy; override;
    procedure DestroyHandle;
    property Ctl3DButton: Boolean read FCtl3dButton write SetCtl3dButton;
    property Handle: HWnd read GetHandle;
  end;

  TSCCustomDBLookupData = class;

  TSCDataSourceLink = class(TDataLink)
  private
    FDBLookupProps: TSCCustomDBLookupData;
  protected
    procedure FocusControl(Field: TFieldRef); override;
    procedure ActiveChanged; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;

    property LookupProps: TSCCustomDBLookupData read FDBLookupProps;
  public
    constructor Create(ALookup: TSCCustomDBLookupData);
  end;

  TSCListSourceLink = class(TDataLink)
  private
    FDBLookupProps: TSCCustomDBLookupData;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure LayoutChanged; override;

    property LookupProps: TSCCustomDBLookupData read FDBLookupProps;
  public
    constructor Create(ALookup: TSCCustomDBLookupData);
  end;

  TSCLookupEmptyData = class(TPersistent)
  private
    FCaption: string;
    FValue: string;
    FIsNull: Boolean;
    FOwner: TSCCustomDBLookupData;
    FOnCaptionChange: TNotifyEvent;
    FOnIsNullChange: TNotifyEvent;
    FOnValueChange: TNotifyEvent;
    procedure SetCaption(const Value: string);
    procedure SetValue(const Value: string);
    procedure SetIsNull(const Value: Boolean);

    function  StoreEmpty: Boolean;
  protected
    function  ValueIsEmpty(const S: string): Boolean;
    function  GetOwner: TPersistent; override;

    property OnCaptionChange: TNotifyEvent read FOnCaptionChange write FOnCaptionChange;
    property OnIsNullChange: TNotifyEvent read FOnIsNullChange write FOnIsNullChange;
    property OnValueChange: TNotifyEvent read FOnValueChange write FOnValueChange;
  public
    constructor Create(AOwner: TSCCustomDBLookupData); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Caption: string read FCaption write SetCaption;
    property Value: string read FValue write SetValue stored StoreEmpty;
    property IsNull: Boolean read FIsNull write SetIsNull default True;
  end;

  TSCCustomDBLookupData = class(TPersistent)
  private
    FControl: TSCCustomControl;
    FLookupSource: TDataSource;
    FDataLink: TSCDataSourceLink;
    FListLink: TSCListSourceLink;
    FDataFieldName: string;
    FKeyFieldName: string;
    FListFieldName: string;
    FListFieldIndex: Integer;
    FDataField: TField;
    FMasterField: TField;
    FKeyField: TField;
    FListField: TField;
    FListFields: TList;
    FKeyValue: Variant;
    FSearchText: string;
    FLookupMode: Boolean;
    FListActive: Boolean;
    FNotifier: TSCNotifier;
    FEmptyData: TSCLookupEmptyData;
    FOnKeyValueChange: TNotifyEvent;
    FOnListLinkDataChange: TNotifyEvent;
    FOnUpdateDataFields: TNotifyEvent;
    FOnUpdateListFields: TNotifyEvent;
    FOnEmptyCaptionChange: TNotifyEvent;
    FOnEmptyValueChange: TNotifyEvent;
    FOnEmptyStrIsNullChange: TNotifyEvent;
    function  GetControl: TSCCustomControl;
    function  GetDataSource: TDataSource;
    procedure SetDataFieldName(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    function  GetKeyFieldName: string;
    procedure SetKeyFieldName(const Value: string);
    procedure SetKeyValue(const Value: Variant);
    procedure SetListFieldName(const Value: string);
    function  GetListSource: TDataSource;
    procedure SetListSource(Value: TDataSource);
    procedure SetLookupMode(Value: Boolean);
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    procedure SetEmptyData(Value: TSCLookupEmptyData);

    procedure CheckNotCircular;
    procedure CheckNotLookup;

    procedure DoKeyValueChanged;
    procedure DoListLinkDataChanged;
    procedure DoUpdateDataFields;
    procedure DoUpdateListFields;
    procedure DoDataLinkRecordChanged(Field: TField);
  protected
    procedure Notification(Sender: TObject; AComponent: TComponent;
      Operation: TOperation); virtual;
    function  GetOwner: TPersistent; override;
    procedure ComponentRemoved(AComponent: TComponent); virtual;

    procedure UpdateEmptyCaption(const Value: string); virtual;
    procedure EmptyCaptionChanged(Sender: TObject); virtual;
    procedure EmptyValueChanged(Sender: TObject); virtual;
    procedure EmptyStrIsNullChanged(Sender: TObject); virtual;

    procedure SetFieldValue(Field: TField; const Value: string); virtual;

    function  CanModify: Boolean; virtual;
    procedure KeyValueChanged; virtual;
    procedure ListLinkDataChanged; virtual;
    function  LocateKey: Boolean; virtual;
    procedure ProcessSearchKey(Key: Char); virtual;
    procedure SelectKeyValue(const Value: Variant); virtual;
    procedure UpdateDataFields; virtual;
    procedure UpdateListFields; virtual;

    function  Handle: THandle;
    function  ComponentState: TComponentState;
    function  GetHasFocus: Boolean;
    function  CanFocus: Boolean;
    procedure SetFocus;

    property Field: TField read FDataField;
    property KeyFieldObj: TField read FKeyField;
    property ListFieldObj: TField read FListField;

    property Control: TSCCustomControl read GetControl;
    property DataField: String read FDataFieldName write SetDataFieldName;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataLink: TSCDataSourceLink read FDataLink;
    property HasFocus: Boolean read GetHasFocus;
    property KeyField: String read GetKeyFieldName write SetKeyFieldName;
    property KeyValue: Variant read FKeyValue write SetKeyValue;
    property LookupMode: Boolean read FLookupMode write SetLookupMode;
    property ListActive: Boolean read FListActive;
    property ListField: String read FListFieldName write SetListFieldName;
    property ListFieldIndex: Integer read FListFieldIndex write FListFieldIndex default 0;
    property ListFields: TList read FListFields;
    property ListLink: TSCListSourceLink read FListLink;
    property ListSource: TDataSource read GetListSource write SetListSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property SearchText: String read FSearchText write FSearchText;
    property EmptyData: TSCLookupEmptyData read FEmptyData write SetEmptyData;
    property OnEmptyCaptionChange: TNotifyEvent read FOnEmptyCaptionChange write FOnEmptyCaptionChange;
    property OnEmptyStrIsNullChange: TNotifyEvent read FOnEmptyStrIsNullChange write FOnEmptyStrIsNullChange;
    property OnEmptyValueChange: TNotifyEvent read FOnEmptyValueChange write FOnEmptyValueChange;
    property OnKeyValueChange: TNotifyEvent read FOnKeyValueChange write FOnKeyValueChange;
    property OnListLinkDataChange: TNotifyEvent read FOnListLinkDataChange write FOnListLinkDataChange;
    property OnUpdateDataFields: TNotifyEvent read FOnUpdateDataFields write FOnUpdateDataFields;
    property OnUpdateListFields: TNotifyEvent read FOnUpdateListFields write FOnUpdateListFields;
  public
    constructor Create(AControl: TSCCustomControl); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;


function GetNavigateTypeRec(NavType: TSCNavigateType): TSCNavButtonRec;
function OkToChangeFieldAlignment(AField: TField; Alignment: TAlignment): Boolean;
function DBUseRightToLeftAlignment(AControl: TControl; AField: TField): Boolean;

{$R SweetDBImages.res}

var
  SCDBImages: TCustomImageList;

implementation

procedure LoadDBImages;
var
  I: Integer;
  Bmp: TBitmap;
  TmpImgList: TImageList;
begin
  SCDBImages := TImageList.CreateSize(16, 16);

  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromResourceName(HInstance, 'SCDBIMAGES');

    TmpImgList := TImageList.CreateSize(SCDBImages.Width, SCDBImages.Height);
    try
      with TmpImgList do
      begin
        Add(Bmp, nil);
        for I := 0 to Count - 1 do
        begin
          GetBitmap(I, Bmp);
          SCDBImages.AddMasked(Bmp, clFuchsia);
        end;
      end;
    finally
      TmpImgList.Free;
    end;
  finally
    Bmp.Free;
  end;
end;

procedure ReleaseDBImages;
begin
  FreeAndNil(SCDBImages);
end;

function GetNavigateTypeRec(NavType: TSCNavigateType): TSCNavButtonRec;
var
  I: Integer;
begin
  with Result do
  begin
    NavType := scntFirst;
    Caption := 'First';
    Hint := 'First record';
  end;

  for I := Low(scNavButtonRecords) to High(scNavButtonRecords) do
    if NavType = scNavButtonRecords[I].NavType then
    begin
      Result := scNavButtonRecords[I];
      Break;
    end;
end;

function OkToChangeFieldAlignment(AField: TField; Alignment: TAlignment): Boolean;
begin
  { dont change the alignment for these fields:
    ftSmallInt     ftInteger      ftWord         ftFloat        ftCurrency
    ftBCD          ftDate         ftTime         ftDateTime     ftAutoInc }
  if Assigned(AField) then
  begin
    with AField do
    begin
      Result := (DataType < ftSmallInt) or (DataType = ftBoolean) or
                ((DataType > ftDateTime) and (DataType <> ftAutoInc));
    end;
  end else
    Result := Alignment <> taCenter;
end;

{ AField is needed because TDBLookupComboBox, for its combobox, uses FListField
  for its alignment characteristics not FField }
function DBUseRightToLeftAlignment(AControl: TControl; AField: TField): Boolean;
var
  AAlignment: TAlignment;
begin
  if Assigned(AField) then
    AAlignment := AField.Alignment
  else
    AAlignment := taLeftJustify;

  Result := (SysLocale.MiddleEast) and (AControl.BiDiMode = bdRightToLeft) and
    (OkToChangeFieldAlignment(AField, AAlignment));
end;

type
  TFakeControl = class(TWinControl);
  TWinControlAccess = class(TWinControl);

{ TSCFieldDataLink }

constructor TSCFieldDataLink.Create;
begin
  inherited Create;
  VisualControl := True;
end;

procedure TSCFieldDataLink.SetEditing(Value: Boolean);
begin
  if FEditing <> Value then
  begin
    FEditing := Value;
    FModified := False;

    if Assigned(FOnEditingChange) then
      FOnEditingChange(Self);
  end;
end;

procedure TSCFieldDataLink.SetFieldName(const Value: string);
begin
  if FFieldName <> Value then
  begin
    FFieldName :=  Value;
    UpdateField;
  end;
end;

procedure TSCFieldDataLink.SetField(Value: TField);
begin
  if FField <> Value then
  begin
    FField := Value;
    EditingChanged;
    RecordChanged(nil);
    UpdateRightToLeft;
  end;
end;

procedure TSCFieldDataLink.UpdateField;
begin
  if Active and (FFieldName <> '') then
  begin
    if Assigned(Control) then
      SetField(GetFieldProperty(DataSource.DataSet, Control, FFieldName))
    else
      SetField(DataSource.DataSet.FieldByName(FFieldName));
  end else
    SetField(nil);
end;

procedure TSCFieldDataLink.UpdateRightToLeft;
var
  IsRightAligned: Boolean;
  AUseRightToLeftAlignment: Boolean;
begin
  if Assigned(Control) and (Control is TWinControl) then
    with Control as TWinControl do
    begin
      if IsRightToLeft then
      begin
        IsRightAligned :=
          (GetWindowLong(Handle, GWL_EXSTYLE) and WS_EX_RIGHT) = WS_EX_RIGHT;

        AUseRightToLeftAlignment :=
          DBUseRightToLeftAlignment(TControl(Control), Field);

        if (IsRightAligned and (not AUseRightToLeftAlignment)) or
           ((not IsRightAligned) and AUseRightToLeftAlignment) then
          Perform(CM_RECREATEWND, 0, 0);
      end;
    end;  
end;

function TSCFieldDataLink.Edit: Boolean;
begin
  if CanModify then
    inherited Edit;
  Result := FEditing;
end;

function TSCFieldDataLink.GetCanModify: Boolean;
begin
  Result := not ReadOnly and (Field <> nil) and Field.CanModify;
end;

procedure TSCFieldDataLink.Modified;
begin
  FModified := True;
end;

procedure TSCFieldDataLink.Reset;
begin
  RecordChanged(nil);
end;

procedure TSCFieldDataLink.ActiveChanged;
begin
  UpdateField;
  if Assigned(FOnActiveChange) then
    FOnActiveChange(Self);
end;

procedure TSCFieldDataLink.EditingChanged;
begin
  SetEditing(inherited Editing and CanModify);
end;

procedure TSCFieldDataLink.FocusControl(Field: TFieldRef);
begin
  if (Field^ <> nil) and (Field^ = FField) and (Control is TWinControl) then
    if TWinControl(Control).CanFocus then
    begin
      Field^ := nil;
      TWinControl(Control).SetFocus;
    end;
end;

procedure TSCFieldDataLink.RecordChanged(Field: TField);
begin
  if (Field = nil) or (Field = FField) then
  begin
    if Assigned(FOnDataChange) then
      FOnDataChange(Self);

    FModified := False;
  end;
end;

procedure TSCFieldDataLink.LayoutChanged;
begin
  UpdateField;
end;

procedure TSCFieldDataLink.UpdateData;
begin
  if FModified then
  begin
    if (Field <> nil) and Assigned(FOnUpdateData) then
      FOnUpdateData(Self);

    FModified := False;
  end;
end;

function TSCFieldDataLink.GetModified: Boolean;
begin
  Result := FModified;
end;

{ TSCPaintControl }

constructor TSCPaintControl.Create(AOwner: TWinControl; const ClassName: string);
begin
  FOwner := AOwner;
  FClassName := ClassName;
end;

destructor TSCPaintControl.Destroy;
begin
  DestroyHandle;
end;

procedure TSCPaintControl.DestroyHandle;
begin
  if FHandle <> 0 then DestroyWindow(FHandle);
{$IFDEF SC_DELPHI6_UP}
{$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}
  FreeObjectInstance(FObjectInstance);
{$IFDEF SC_DELPHI6_UP}
{$WARN SYMBOL_DEPRECATED ON}
{$ENDIF}
  FHandle := 0;
  FObjectInstance := nil;
end;

function TSCPaintControl.GetHandle: HWnd;
var
  Params: TCreateParams;
begin
  if FHandle = 0 then
  begin
{$IFDEF SC_DELPHI6_UP}
{$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}
    FObjectInstance := MakeObjectInstance(WndProc);
{$IFDEF SC_DELPHI6_UP}
{$WARN SYMBOL_DEPRECATED ON}
{$ENDIF}
    TWinControlAccess(FOwner).CreateParams(Params);
    Params.Style := Params.Style and not (WS_HSCROLL or WS_VSCROLL);
    with Params do
      FHandle := CreateWindowEx(ExStyle, PChar(FClassName),
        PChar(TWinControlAccess(FOwner).Text), Style or WS_VISIBLE,
        X, Y, Width, Height, Application.Handle, 0, HInstance, nil);
    FDefWindowProc := Pointer(GetWindowLong(FHandle, GWL_WNDPROC));
    SetWindowLong(FHandle, GWL_WNDPROC, Integer(FObjectInstance));
    SendMessage(FHandle, WM_SETFONT,
      TWinControlAccess(FOwner).Font.Handle, 1);
  end;
  Result := FHandle;
end;

procedure TSCPaintControl.SetCtl3DButton(Value: Boolean);
begin
  if FHandle <> 0 then DestroyHandle;
  FCtl3DButton := Value;
end;

procedure TSCPaintControl.WndProc(var Message: TMessage);
begin
  with Message do
    if (Msg >= CN_CTLCOLORMSGBOX) and (Msg <= CN_CTLCOLORSTATIC) then
      Result := FOwner.Perform(Msg, WParam, LParam) else
      Result := CallWindowProc(FDefWindowProc, FHandle, Msg, WParam, LParam);
end;

{ TSCCustomDBLookupData }

function VarEquals(const V1, V2: Variant): Boolean;
begin
  Result := False;
  try
    Result := V1 = V2;
  except
  end;
end;

var
  SearchTickCount: Integer = 0;

function TSCCustomDBLookupData.CanFocus: Boolean;
begin
  Result := (Control <> nil) and Control.CanFocus;
end;

function TSCCustomDBLookupData.CanModify: Boolean;
begin
  Result := FListActive and not ReadOnly and ((FDataLink.DataSource = nil) or
    (FMasterField <> nil) and FMasterField.CanModify);
end;

procedure TSCCustomDBLookupData.CheckNotCircular;
begin
  if FListLink.Active and FListLink.DataSet.IsLinkedTo(DataSource) then
    DatabaseError(SSCCircularDataLink);
end;

procedure TSCCustomDBLookupData.CheckNotLookup;
begin
  if FLookupMode then DatabaseError(SSCPropDefByLookup);
  if FDataLink.DataSourceFixed then
    DatabaseError(SSCDataSourceFixed);
end;

procedure TSCCustomDBLookupData.ComponentRemoved(AComponent: TComponent);
begin
  if (FDataLink <> nil) and (AComponent = DataSource) then
    DataSource := nil;
  if (FListLink <> nil) and (AComponent = ListSource) then
    ListSource := nil;
end;

function TSCCustomDBLookupData.ComponentState: TComponentState;
begin
  Result := [];
  if Control <> nil then
    Result := Control.ComponentState;
end;

constructor TSCCustomDBLookupData.Create(AControl: TSCCustomControl);
begin
  inherited Create;
  FControl := AControl;

  FEmptyData := TSCLookupEmptyData.Create(Self);

  FEmptyData.OnCaptionChange := EmptyCaptionChanged;
  FEmptyData.OnIsNullChange := EmptyStrIsNullChanged;
  FEmptyData.OnValueChange := EmptyValueChanged;

  if Control <> nil then
  begin
    FNotifier := TSCNotifier.Create;
    FNotifier.OnNotification := Notification;

    Control.RegisterNotifier(FNotifier);
  end;

  FLookupSource := TDataSource.Create(Control);

  FDataLink := TSCDataSourceLink.Create(Self);
  FListLink := TSCListSourceLink.Create(Self);
  
  FListFields := TList.Create;
  FKeyValue := Null;
end;

procedure TSCCustomDBLookupData.DoDataLinkRecordChanged(Field: TField);
begin
  if (Field = nil) or (Field = FMasterField) then
  begin
    if FMasterField <> nil then
      SetKeyValue(FMasterField.Value)
    else
      SetKeyValue(Null);
  end;    
end;

destructor TSCCustomDBLookupData.Destroy;
begin
  FEmptyData.OnCaptionChange := nil;
  FEmptyData.OnIsNullChange := nil;
  FEmptyData.OnValueChange := nil;

  FreeAndNil(FEmptyData);

  if FNotifier <> nil then
  begin
    FNotifier.OnNotification := nil;
    if FControl <> nil then
      FControl.UnregisterNotifier(FNotifier);
      
    FreeAndNil(FNotifier);
  end;
  
  FControl := nil;

  FreeAndNil(FListFields);

  FListLink.FDBLookupProps := nil;
  FreeAndNil(FListLink);

  FDataLink.FDBLookupProps := nil;
  FreeAndNil(FDataLink);

  inherited Destroy;
end;

procedure TSCCustomDBLookupData.DoListLinkDataChanged;
begin
  ListLinkDataChanged;
  if Assigned(FOnListLinkDataChange) then
    FOnListLinkDataChange(Self);
end;

procedure TSCCustomDBLookupData.DoUpdateDataFields;
begin
  UpdateDataFields;
  if Assigned(FOnUpdateDataFields) then
    FOnUpdateDataFields(Self);
end;

procedure TSCCustomDBLookupData.DoUpdateListFields;
begin
  UpdateListFields;
  if Assigned(FOnUpdateListFields) then
    FOnUpdateListFields(Self);
end;

function TSCCustomDBLookupData.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TSCCustomDBLookupData.GetHasFocus: Boolean;
begin
  Result := (Control <> nil) and Control.HasFocus;
end;

function TSCCustomDBLookupData.GetKeyFieldName: string;
begin
  Result := '';
  if not FLookupMode then
    Result := FKeyFieldName;
end;

function TSCCustomDBLookupData.GetListSource: TDataSource;
begin
  Result := nil;
  if not FLookupMode then
    Result := FListLink.DataSource;
end;

function TSCCustomDBLookupData.GetOwner: TPersistent;
begin
  Result := Control;
end;

function TSCCustomDBLookupData.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

function TSCCustomDBLookupData.Handle: THandle;
begin
  Result := 0;
  if (Control <> nil) and Control.HandleAllocated then
    Result := Control.Handle;
end;

procedure TSCCustomDBLookupData.KeyValueChanged;
begin
  //
end;

procedure TSCCustomDBLookupData.ListLinkDataChanged;
begin
  //
end;

function TSCCustomDBLookupData.LocateKey: Boolean;
var
  KeySave: Variant;
begin
  Result := False;
  try
    KeySave := FKeyValue;
    if not VarIsNull(FKeyValue) and FListLink.DataSet.Active and
      FListLink.DataSet.Locate(FKeyFieldName, FKeyValue, []) then
    begin
      Result := True;
      FKeyValue := KeySave;
    end;
  except
  end;
end;

procedure TSCCustomDBLookupData.ProcessSearchKey(Key: Char);
var
  TickCount: Integer;
  S: string;
  CharMsg: TMsg;
begin
  if (FListField <> nil) and (FListField.FieldKind in [fkData, fkInternalCalc]) and
    (FListField.DataType in [ftString, ftWideString]) then
    case Key of
      #8, #27: SearchText := '';
      #32..#255:
        if CanModify then
        begin
          TickCount := GetTickCount;
          if TickCount - SearchTickCount > 2000 then SearchText := '';
          SearchTickCount := TickCount;
          if SysLocale.FarEast and (Key in LeadBytes) then
            if PeekMessage(CharMsg, Handle, WM_CHAR, WM_CHAR, PM_REMOVE) then
            begin
              if CharMsg.Message = WM_Quit then
              begin
                PostQuitMessage(CharMsg.wparam);
                Exit;
              end;
              SearchText := SearchText + Key;
              Key := Char(CharMsg.wParam);
            end;
          if Length(SearchText) < 32 then
          begin
            S := SearchText + Key;
            try
              if FListLink.DataSet.Locate(FListField.FieldName, S,
                [loCaseInsensitive, loPartialKey]) then
              begin
                SelectKeyValue(FKeyField.Value);
                SearchText := S;
              end;
            except
              { If you attempt to search for a string larger than what the field
                can hold, and exception will be raised.  Just trap it and
                reset the SearchText back to the old value. }
              SearchText := S;
            end;
          end;
        end;
    end;
end;

procedure TSCCustomDBLookupData.SelectKeyValue(const Value: Variant);
begin
  if FMasterField <> nil then
  begin
    if FDataLink.Edit then
      FMasterField.Value := Value;
  end else
    SetKeyValue(Value);

  if Control <> nil then
  begin
    Control.Repaint;
    TFakeControl(Control).Click;
  end;
end;

procedure TSCCustomDBLookupData.SetDataFieldName(const Value: string);
begin
  if FDataFieldName <> Value then
  begin
    FDataFieldName := Value;
    DoUpdateDataFields;
  end;
end;

procedure TSCCustomDBLookupData.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
  begin
    {$IFDEF SC_DELPHI5_UP}
    if (Control <> nil) and (FDataLink.DataSource <> nil) then
      FDataLink.DataSource.RemoveFreeNotification(Control);
    {$ENDIF}

    FDataLink.DataSource := Value;
    if (Control <> nil) and (Value <> nil) then
      Value.FreeNotification(Control);
  end;    
end;

procedure TSCCustomDBLookupData.SetFocus;
begin
  if Control <> nil then
    Control.SetFocus;
end;

procedure TSCCustomDBLookupData.SetKeyFieldName(const Value: string);
begin
  CheckNotLookup;
  if FKeyFieldName <> Value then
  begin
    FKeyFieldName := Value;
    DoUpdateListFields;
  end;
end;

procedure TSCCustomDBLookupData.SetKeyValue(const Value: Variant);
begin
  if not VarEquals(FKeyValue, Value) then
  begin
    FKeyValue := Value;
    DoKeyValueChanged;
  end;
end;

procedure TSCCustomDBLookupData.SetListFieldName(const Value: string);
begin
  if FListFieldName <> Value then
  begin
    FListFieldName := Value;
    DoUpdateListFields;
  end;
end;

procedure TSCCustomDBLookupData.SetListSource(Value: TDataSource);
begin
  CheckNotLookup;
  {$IFDEF SC_DELPHI5_UP}
  if (Control <> nil) and (FListLink.DataSource <> nil) then
    FListLink.DataSource.RemoveFreeNotification(Control);
  {$ENDIF}

  FListLink.DataSource := Value;

  if (Control <> nil) and (Value <> nil) then
    Value.FreeNotification(Control);
end;

procedure TSCCustomDBLookupData.SetLookupMode(Value: Boolean);
begin
  if FLookupMode <> Value then
    if Value and (Control <> nil) then
    begin
      FMasterField := GetFieldProperty(FDataField.DataSet, Control, FDataField.KeyFields);
      FLookupSource.DataSet := FDataField.LookupDataSet;
      FKeyFieldName := FDataField.LookupKeyFields;
      FLookupMode := True;
      FListLink.DataSource := FLookupSource;
    end else
    begin
      FListLink.DataSource := nil;
      FLookupMode := False;
      FKeyFieldName := '';
      FLookupSource.DataSet := nil;
      FMasterField := FDataField;
    end;
end;

procedure TSCCustomDBLookupData.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TSCCustomDBLookupData.UpdateDataFields;
begin
  FDataField := nil;
  FMasterField := nil;

  if (Control <> nil) and FDataLink.Active and (FDataFieldName <> '') then
  begin
    CheckNotCircular;
    FDataField := GetFieldProperty(FDataLink.DataSet, Control, FDataFieldName);

    if FDataField.FieldKind = fkLookup then
      FMasterField := GetFieldProperty(FDataLink.DataSet, Control, FDataField.KeyFields)
    else
      FMasterField := FDataField;
  end;

  SetLookupMode((FDataField <> nil) and (FDataField.FieldKind = fkLookup));
  DoDataLinkRecordChanged(nil);
end;

procedure TSCCustomDBLookupData.UpdateListFields;
var
  DataSet: TDataSet;
  ResultField: TField;
begin
  FListActive := False;
  FKeyField := nil;
  FListField := nil;
  FListFields.Clear;

  if (Control <> nil) and FListLink.Active and (FKeyFieldName <> '') then
  begin
    CheckNotCircular;

    DataSet := FListLink.DataSet;
    FKeyField := GetFieldProperty(DataSet, Control, FKeyFieldName);
    try
      DataSet.GetFieldList(FListFields, FListFieldName);
    except
      DatabaseErrorFmt(SSCFieldNotFound, [Control.Name, FListFieldName]);
    end;

    if FLookupMode then
    begin
      ResultField := GetFieldProperty(DataSet, Control, FDataField.LookupResultField);
      if FListFields.IndexOf(ResultField) < 0 then
        FListFields.Insert(0, ResultField);

      FListField := ResultField;
    end else
    begin
      if FListFields.Count = 0 then
        FListFields.Add(FKeyField);

      if (FListFieldIndex >= 0) and (FListFieldIndex < FListFields.Count) then
        FListField := FListFields[FListFieldIndex]
      else
        FListField := FListFields[0];
    end;
    FListActive := True;
  end;
end;

procedure TSCCustomDBLookupData.Assign(Source: TPersistent);
begin
  if Source is TSCCustomDBLookupData then
  begin
    with TSCCustomDBLookupData(Source) do
    begin
      Self.DataField := DataField;
      Self.DataSource := DataSource;
      Self.KeyField := KeyField;
      Self.KeyValue := KeyValue;
      Self.ListField := ListField;
      Self.ListFieldIndex := ListFieldIndex;
      Self.ListSource := ListSource;
      Self.ReadOnly := ReadOnly;
      Self.SearchText := SearchText;
    end;
  end else
    inherited Assign(Source);
end;

procedure TSCCustomDBLookupData.Notification(Sender: TObject;
  AComponent: TComponent; Operation: TOperation);
begin
  if Operation = opRemove then
  begin
    if (FControl <> nil) and (AComponent = FControl) then
      FControl := nil;
    if (FDataLink <> nil) and (AComponent = DataSource) then
      DataSource := nil;
    if (FListLink <> nil) and (AComponent = ListSource) then
      ListSource := nil;
  end;
end;

procedure TSCCustomDBLookupData.DoKeyValueChanged;
begin
  KeyValueChanged;
  if Assigned(FOnKeyValueChange) then
    FOnKeyValueChange(Self);
end;

function TSCCustomDBLookupData.GetControl: TSCCustomControl;
begin
  Result := FControl;
end;

procedure TSCCustomDBLookupData.UpdateEmptyCaption(const Value: string);
begin
end;

procedure TSCCustomDBLookupData.SetFieldValue(Field: TField;
  const Value: string);
begin
  if Value = FEmptyData.Value then
    if (FEmptyData.Value = EmptyStr) and FEmptyData.IsNull then
      Field.Clear
    else
      Field.AsString := FEmptyData.Value
  else
    Field.AsString := Value;
end;

procedure TSCCustomDBLookupData.EmptyCaptionChanged(Sender: TObject);
begin

end;

procedure TSCCustomDBLookupData.EmptyStrIsNullChanged(Sender: TObject);
begin
  if CanModify and (FDataLink.DataSource <> nil) and FDataLink.Edit then
    if FMasterField <> nil then
      SetFieldValue(FMasterField, KeyValue)
    else
      SetFieldValue(FDataField, KeyValue);
end;

procedure TSCCustomDBLookupData.EmptyValueChanged(Sender: TObject);
begin

end;

procedure TSCCustomDBLookupData.SetEmptyData(Value: TSCLookupEmptyData);
begin
  FEmptyData.Assign(Value);
end;

{ TSCDataSourceLink }

constructor TSCDataSourceLink.Create(ALookup: TSCCustomDBLookupData);
begin
  inherited Create;
  FDBLookupProps := ALookup;
  VisualControl := True;
end;

procedure TSCDataSourceLink.ActiveChanged;
begin
  if FDBLookupProps <> nil then
    FDBLookupProps.DoUpdateDataFields;
end;

procedure TSCDataSourceLink.FocusControl(Field: TFieldRef);
begin
  if (Field^ <> nil) and (FDBLookupProps <> nil) and
    (Field^ = FDBLookupProps.Field) and FDBLookupProps.CanFocus then
  begin
    Field^ := nil;
    FDBLookupProps.SetFocus;
  end;
end;

procedure TSCDataSourceLink.LayoutChanged;
begin
  if FDBLookupProps <> nil then
    FDBLookupProps.DoUpdateDataFields;
end;

procedure TSCDataSourceLink.RecordChanged(Field: TField);
begin
  if FDBLookupProps <> nil then
    FDBLookupProps.DoDataLinkRecordChanged(Field);
end;

{ TSCListSourceLink }

constructor TSCListSourceLink.Create(ALookup: TSCCustomDBLookupData);
begin
  inherited Create;
  FDBLookupProps := ALookup;
  VisualControl := True;
end;

procedure TSCListSourceLink.ActiveChanged;
begin
  if FDBLookupProps <> nil then
    FDBLookupProps.DoUpdateListFields;
end;

procedure TSCListSourceLink.DataSetChanged;
begin
  if FDBLookupProps <> nil then
    FDBLookupProps.DoListLinkDataChanged;
end;

procedure TSCListSourceLink.LayoutChanged;
begin
  if FDBLookupProps <> nil then
    FDBLookupProps.DoUpdateListFields;
end;

{ TSCLookupEmptyData }

procedure TSCLookupEmptyData.Assign(Source: TPersistent);
begin
  if Source is TSCLookupEmptyData then
  begin
    with TSCLookupEmptyData(Source) do
    begin
      Self.Caption := Caption;
      Self.Value := Value;
      Self.IsNull := IsNull;
    end;
  end else
    inherited Assign(Source);
end;

constructor TSCLookupEmptyData.Create(AOwner: TSCCustomDBLookupData);
begin

end;

function TSCLookupEmptyData.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TSCLookupEmptyData.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    if FOwner <> nil then
      FOwner.UpdateEmptyCaption(Value);

    FCaption := Value;
    if Assigned(FOnCaptionChange) then
      FOnCaptionChange(Self);
  end;
end;

procedure TSCLookupEmptyData.SetIsNull(const Value: Boolean);
begin
  if FIsNull <> Value then
  begin
    FIsNull := Value;
    if Assigned(FOnIsNullChange) then
      FOnIsNullChange(Self);
  end;
end;

procedure TSCLookupEmptyData.SetValue(const Value: string);
begin
  if FValue <> Value then
  begin
    FValue := Value;
    if Assigned(FOnValueChange) then
      FOnValueChange(Self);
  end;
end;

function TSCLookupEmptyData.StoreEmpty: Boolean;
begin
  Result := FValue <> EmptyStr;
end;

function TSCLookupEmptyData.ValueIsEmpty(const S: string): Boolean;
begin
  Result := S = FValue;
end;

initialization
  LoadDBImages;

finalization
  ReleaseDBImages;

end.
