unit SCTreeColsEditor;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCommon, SCControl, SCStdControls, SCSimpleListbox, SCTreeList,
  {$IFDEF SC_DELPHI6_UP} Variants, Types, DesignWindows, DesignIntf {$ELSE}
  DsgnWnds, DsgnIntf {$ENDIF};

type
  TSCTreeColsForm = class(TDesignWindow)
    BackPanel: TSCPanel;
    ButtonPanel: TSCPanel;
    AddButton: TSCButton;
    DeleteButton: TSCButton;
    MoveUpButton: TSCButton;
    MoveDownButton: TSCButton;
    ColumnsListbox: TSCSimpleListbox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ColumnsListboxClick(Sender: TObject);
    procedure ColumnsListboxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure MoveUpButtonClick(Sender: TObject);
    procedure MoveDownButtonClick(Sender: TObject);
  private
    FClosed: Boolean;
    PDesigner: Pointer;
    FTreeList: TSCTreeList;

    procedure UpdateDesigner;
    procedure ReleaseTreeList;
    procedure ColumnChangeCaption(Sender: TObject);
    procedure ColumnDestroyed(Sender: TObject);

    procedure WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function  UniqueName(Component: TComponent): string; override;
    procedure Activated; override;

    procedure FillColumnList;
    procedure UpdateEditor(ATreeList: TSCTreeList; Designer: Pointer);

    {$IFDEF SC_DELPHI6_UP}
    function ObjectInList(ASelection: IDesignerSelections; AItem: TPersistent): Boolean;
    {$ELSE}
      {$IFDEF SC_DELPHI5_UP}
      function ObjectInList(ASelection: TDesignerSelectionList; AItem: TPersistent): Boolean;
      {$ELSE}
      function ObjectInList(ASelection: TComponentList; AItem: TPersistent): Boolean;
      {$ENDIF}
    {$ENDIF}

    {$IFDEF SC_DELPHI6_UP}
    function SelectItems(ASelection: IDesignerSelections; AFlagCheck: Boolean): Boolean;
    {$ELSE}
      {$IFDEF SC_DELPHI5_UP}
      function SelectItems(ASelection: TDesignerSelectionList; AFlagCheck: Boolean): Boolean;
      {$ELSE}
      function SelectItems(ASelection: TComponentList; AFlagCheck: Boolean): Boolean;
      {$ENDIF}
    {$ENDIF}
  public
    destructor Destroy; override;
    {$IFDEF SC_DELPHI6_UP}
    procedure DesignerClosed(const Designer: IDesigner; AGoingDormant: Boolean); override;
    procedure SelectionChanged(const ADesigner: IDesigner; const ASelection: IDesignerSelections); override;
    {$ELSE}
      procedure FormClosed(AForm: TCustomForm); override;
      {$IFDEF SC_DELPHI5_UP}
      procedure SelectionChanged(ASelection: TDesignerSelectionList); override;
      {$ELSE}
      procedure SelectionChanged(ASelection: TComponentList); override;
      {$ENDIF}
    {$ENDIF}

    class procedure ShowEditor(ATreeList: TSCTreeList; Designer: Pointer);
  end;

implementation

{$R *.DFM}

type
  TSCFakeTreeColumn = class(TSCTreeColumn);

var
  ScreenForms: TList;

{ TSCTreeColsForm }

class procedure TSCTreeColsForm.ShowEditor(ATreeList: TSCTreeList;
  Designer: Pointer);
var
  I: Integer;
  AForm: TSCTreeColsForm;
begin
  for I := 0 to ScreenForms.Count-1 do
  begin
    AForm := TSCTreeColsForm(ScreenForms[I]);
    
    if AForm.FTreeList = ATreeList then
    begin
      AForm.Show;
      Exit;
    end;
  end;

  AForm := TSCTreeColsForm.Create(nil);
  ScreenForms.Add(AForm);

  AForm.UpdateEditor(ATreeList, Designer);
  AForm.Show;
end;

procedure TSCTreeColsForm.UpdateEditor(ATreeList: TSCTreeList;
  Designer: Pointer);
begin
  Self.Caption := 'SweetControls TreeList Editor';

  PDesigner := Designer;
  FTreeList := ATreeList;

  with ColumnsListbox do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;

      if FTreeList <> nil then
      begin
        FTreeList.FreeNotification(Self);

        Self.Caption := Self.Caption + ' (' + ATreeList.Name + ')';
        FillColumnList;
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TSCTreeColsForm.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  Message.MinMaxInfo^.ptMinTrackSize := Point(350, 240);
  inherited;
end;

procedure TSCTreeColsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  I: Integer;
  AForm: TSCTreeColsForm;
begin
  Action := caFree;
  FClosed := True;

  if Assigned(ScreenForms) then
    for I := 0 to ScreenForms.Count-1 do
    begin
      AForm := TSCTreeColsForm(ScreenForms[I]);

      if AForm.FTreeList = Self.FTreeList then
      begin
        ScreenForms.Delete(I);
        Break;
      end;
    end;

  ReleaseTreeList;
end;

procedure TSCTreeColsForm.Activated;
begin
  ColumnsListboxClick(nil);
end;

procedure TSCTreeColsForm.ColumnsListboxClick(Sender: TObject);
var
  {$IFDEF SC_DELPHI6_UP}
    List: IDesignerSelections;
  {$ELSE}
    List: {$IFDEF SC_DELPHI5_UP}TDesignerSelectionList{$ELSE}TComponentList{$ENDIF};
  {$ENDIF}
  AIndex: Integer;
begin
  if (FTreeList <> nil) and (PDesigner <> nil) then
  begin
    {$IFDEF SC_DELPHI6_UP}
      List := CreateSelectionList;
    {$ELSE}
      List := {$IFDEF SC_DELPHI5_UP}TDesignerSelectionList{$ELSE}TComponentList{$ENDIF}.Create;
    {$ENDIF}

    try
      if ColumnsListbox.Items.Count > 0 then
      begin
        AIndex := ColumnsListbox.ItemIndex;

        if AIndex > -1 then
          {$IFNDEF SC_DELPHI4_UP}
          List.Add(TComponent(ColumnsListbox.Items.Objects[AIndex]));
          {$ELSE}
          List.Add(TPersistent(ColumnsListbox.Items.Objects[AIndex]));
          {$ENDIF}
      end;

      {$IFDEF SC_DELPHI6_UP}
      if List.Count > 0 then
        IDesigner(PDesigner).SetSelections(List)
      else
        IDesigner(PDesigner).SelectComponent(nil);
      {$ELSE}
      if List.Count > 0 then
        {$IFDEF SC_DELPHI4_UP}
        IFormDesigner(PDesigner).SetSelections(List)
        {$ELSE}
        TFormDesigner(PDesigner).SetSelections(List)
        {$ENDIF}
      else
        {$IFDEF SC_DELPHI4_UP}
        IFormDesigner(PDesigner).SelectComponent(nil);
        {$ELSE}
        TFormDesigner(PDesigner).SelectComponent(nil);
        {$ENDIF}
      {$ENDIF}
    finally
      {$IFNDEF SC_DELPHI6_UP}
      List.Free;
      {$ENDIF}
    end;
  end;

  AIndex := ColumnsListbox.ItemIndex;

  DeleteButton.Enabled := AIndex > -1;
  MoveUpButton.Enabled := AIndex > -1;
  MoveDownButton.Enabled := AIndex > -1;
end;

procedure TSCTreeColsForm.ColumnsListboxKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
const
  ArrowKeys = [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN,
    VK_NEXT, VK_PRIOR, VK_TAB, VK_HOME, VK_END];
begin
  if Key = VK_RETURN then
  begin
    ActivateInspector(#0);
    Key := 0;
  end else
  if (Key > 32) and not (Key in ArrowKeys) then
  begin
    ActivateInspector(Char(Key));
    Key := 0;
  end;
end;

procedure TSCTreeColsForm.UpdateDesigner;
begin
  if (PDesigner <> nil) and not (csDestroying in ComponentState) then
    {$IFDEF SC_DELPHI6_UP}
      IDesigner(PDesigner).Modified;
    {$ELSE}
      {$IFDEF SC_DELPHI4_UP}
      IFormDesigner(PDesigner).Modified;
      {$ELSE}
      TFormDesigner(PDesigner).Modified;
      {$ENDIF}
    {$ENDIF}
end;

procedure TSCTreeColsForm.ColumnChangeCaption(Sender: TObject);
var
  I, AIndex: Integer;
begin
  if (FTreeList <> nil) and (Sender is TSCTreeColumn) then
    with ColumnsListbox do
    begin
      AIndex := -1;
      for I := 0 to Items.Count - 1 do
        if Items.Objects[I] = Sender then
        begin
          AIndex := I;
          Break;
        end;

      if (AIndex > -1) and (AIndex < Items.Count) then
      begin
        Items[AIndex] := TSCTreeColumn(Sender).DisplayText;
        ItemIndex := AIndex;
      end;
    end;
end;

destructor TSCTreeColsForm.Destroy;
var
  I: Integer;
  AForm: TCustomForm;
begin
  Destroying;

  if (FTreeList <> nil) and not (csDestroying in FTreeList.ComponentState) then
  begin
    AForm := GetParentForm(FTreeList);
    if AForm <> nil then
    begin
      if (AForm.Designer <> nil) and Active then
      begin
        {$IFDEF SC_DELPHI6_UP}
          IDesigner(PDesigner).SelectComponent(nil);
        {$ELSE}
          {$IFDEF SC_DELPHI4_UP}
          IFormDesigner(PDesigner).SelectComponent(nil);
          {$ELSE}
          TFormDesigner(PDesigner).SelectComponent(nil);
          {$ENDIF}
        {$ENDIF}
      end;
      
      if Assigned(FTreeList) and not (csDestroying in FTreeList.ComponentState) then
        for I := 0 to FTreeList.ColumnCount - 1 do
          with TSCFakeTreeColumn(FTreeList.Columns[I]) do
          begin
            OnDestroy := nil;
            OnChangeCaption := nil;
          end;
    end;
  end;

  inherited Destroy;
end;

{$IFDEF SC_DELPHI6_UP}
function TSCTreeColsForm.ObjectInList(ASelection: IDesignerSelections; AItem: TPersistent): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to ASelection.Count - 1 do
    if AItem = ASelection[I] then
    begin
      Result := True;
      Break;
    end;
end;

function TSCTreeColsForm.SelectItems(ASelection: IDesignerSelections; AFlagCheck: Boolean): Boolean;
var
  I: Integer;
begin
  Result := False;
  with ColumnsListBox do
    for I := 0 to Items.Count - 1 do
      if ObjectInList(ASelection, TPersistent(Items.Objects[I])) then
      begin
        Result := True;
        if not AFlagCheck then
          ItemIndex := I;

        Break;
      end;
end;

procedure TSCTreeColsForm.DesignerClosed(const Designer: IDesigner; AGoingDormant: Boolean);
begin
  if Designer = Self.Designer then
  begin
    FClosed := True;

    ReleaseTreeList;
    Self.Close;
  end;
end;

procedure TSCTreeColsForm.SelectionChanged(const ADesigner: IDesigner; const ASelection: IDesignerSelections); 
begin
  if not (FClosed or Active) and (ADesigner = Self.Designer) and
    SelectItems(ASelection, True) then
  begin
    ColumnsListbox.ItemIndex := -1;
    SelectItems(ASelection, False);
  end;
end;
{$ELSE}
procedure TSCTreeColsForm.FormClosed(AForm: TCustomForm); 
begin
  if AForm <> nil then
  begin
    FClosed := True;

    ReleaseTreeList;
    Self.Close;
  end;
end;

{$IFDEF SC_DELPHI5_UP}
function TSCTreeColsForm.ObjectInList(ASelection: TDesignerSelectionList; AItem: TPersistent): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to ASelection.Count - 1 do
    if AItem = ASelection[I] then
    begin
      Result := True;
      Break;
    end;
end;

function TSCTreeColsForm.SelectItems(ASelection: TDesignerSelectionList; AFlagCheck: Boolean): Boolean;
var
  I: Integer;
begin
  Result := False;
  with ColumnsListBox do
    for I := 0 to Items.Count - 1 do
      if ObjectInList(ASelection, TPersistent(Items.Objects[I])) then
      begin
        Result := True;
        if not AFlagCheck then
          ItemIndex := I;

        Break;
      end;
end;

procedure TSCTreeColsForm.SelectionChanged(ASelection: TDesignerSelectionList);
begin
  if (ASelection <> nil) and not (FClosed or Active) and
    SelectItems(ASelection, True) then
  begin
    ColumnsListbox.ItemIndex := -1;
    SelectItems(ASelection, False);
  end;
end;
{$ELSE}
function TSCTreeColsForm.ObjectInList(ASelection: TComponentList; AItem: TPersistent): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to ASelection.Count - 1 do
    if AItem = ASelection[I] then
    begin
      Result := True;
      Break;
    end;
end;

function TSCTreeColsForm.SelectItems(ASelection: TComponentList; AFlagCheck: Boolean): Boolean;
var
  I: Integer;
begin
  Result := False;
  with ColumnsListBox do
    for I := 0 to Items.Count - 1 do
      if ObjectInList(ASelection, TPersistent(Items.Objects[I])) then
      begin
        Result := True;
        if not AFlagCheck then
          ItemIndex := I;

        Break;
      end;
end;

procedure TSCTreeColsForm.SelectionChanged(ASelection: TComponentList); 
begin
  if (ASelection <> nil) and not (FClosed or Active) and
    SelectItems(ASelection, True) then
  begin
    ColumnsListbox.ItemIndex := -1;
    SelectItems(ASelection, False);
  end;
end;
{$ENDIF}
{$ENDIF}

function TSCTreeColsForm.UniqueName(Component: TComponent): string;
begin
end;

procedure TSCTreeColsForm.AddButtonClick(Sender: TObject);
var
  Col: TSCTreeColumn;
begin
  if FTreeList <> nil then
  begin
    with ColumnsListBox do
    begin
      Items.BeginUpdate;
      try
        Col := TSCTreeColumn.Create(FTreeList);

        with TSCFakeTreeColumn(Col) do
        begin
          OnChangeCaption := ColumnChangeCaption;
          OnDestroy := ColumnDestroyed;
        end;

        Items.AddObject(Col.DisplayText, Col);
        ItemIndex := Items.Count-1;
      finally
        Items.EndUpdate;
      end;
    end;

    if ColumnsListBox.CanFocus then
      ColumnsListBox.SetFocus;
      
    ColumnsListBoxClick(nil);
    UpdateDesigner;
  end;
end;

procedure TSCTreeColsForm.DeleteButtonClick(Sender: TObject);
var
  OldIndex: Integer;
  Col: TSCTreeColumn;
begin
  if (FTreeList <> nil) and (ColumnsListbox.Count > 0) and
    (ColumnsListbox.ItemIndex > -1) then
  begin
    with ColumnsListbox do
    begin
      OldIndex := ItemIndex;
      Col := TSCTreeColumn(Items.Objects[ItemIndex]);

      with TSCFakeTreeColumn(Col) do
      begin
        OnChangeCaption := nil;
        OnDestroy := nil;
      end;

      Items.BeginUpdate;
      try
        ItemIndex := -1;
        Items.Delete(OldIndex);

        with FTreeList do
        begin
          BeginUpdate;
          try
            Col.Free;
          finally
            EndUpdate;
          end;
        end;

        // FillColumnList;

        if OldIndex >= Items.Count then
          OldIndex := Items.Count-1;

        if (OldIndex > -1) and (Items.Count > 0) then
          ItemIndex := OldIndex;
      finally
        Items.EndUpdate;
      end;
    end;

    if ColumnsListBox.CanFocus then
      ColumnsListBox.SetFocus;

    ColumnsListBoxClick(nil);
    UpdateDesigner;
  end;
end;

procedure TSCTreeColsForm.FillColumnList;
var
  I: Integer;
  Col: TSCTreeColumn;
begin
  with ColumnsListBox do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;

      if FTreeList <> nil then
        for I := 0 to FTreeList.ColumnCount - 1 do
        begin
          Col := FTreeList.Columns[I];

          Items.AddObject(Col.DisplayText, Col);

          with TSCFakeTreeColumn(Col) do
          begin
            OnChangeCaption := ColumnChangeCaption;
            OnDestroy := ColumnDestroyed;
          end;
        end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TSCTreeColsForm.MoveUpButtonClick(Sender: TObject);
var
  CurIndex: Integer;
  Col: TSCTreeColumn;
begin
  if (FTreeList <> nil) and (ColumnsListbox.Count > 1) then
  begin
    CurIndex := ColumnsListbox.ItemIndex;
    if CurIndex < 1 then
      Exit;

    Col := TSCTreeColumn(ColumnsListbox.Items.Objects[CurIndex]);
    if CurIndex <> FTreeList.IndexOfColumn(Col) then
      Exit;

    FTreeList.MoveColumn(CurIndex, CurIndex - 1);
    ColumnsListbox.Items.Move(CurIndex, CurIndex - 1);

    ColumnsListbox.ItemIndex := CurIndex - 1;

    if ColumnsListBox.CanFocus then
      ColumnsListBox.SetFocus;

    ColumnsListBoxClick(nil);
    UpdateDesigner;
  end;
end;

procedure TSCTreeColsForm.MoveDownButtonClick(Sender: TObject);
var
  CurIndex: Integer;
  Col: TSCTreeColumn;
begin
  if (FTreeList <> nil) and (ColumnsListbox.Count > 1) then
  begin
    CurIndex := ColumnsListbox.ItemIndex;
    if CurIndex > ColumnsListbox.Items.Count-2 then
      Exit;

    Col := TSCTreeColumn(ColumnsListbox.Items.Objects[CurIndex]);
    if CurIndex <> FTreeList.IndexOfColumn(Col) then
      Exit;

    FTreeList.MoveColumn(CurIndex, CurIndex + 1);
    ColumnsListbox.Items.Move(CurIndex, CurIndex + 1);

    ColumnsListbox.ItemIndex := CurIndex + 1;

    if ColumnsListBox.CanFocus then
      ColumnsListBox.SetFocus;

    ColumnsListBoxClick(nil);
    UpdateDesigner;
  end;
end;

procedure TSCTreeColsForm.ColumnDestroyed(Sender: TObject);
var
  I: Integer;
begin
  if (Sender = nil) or (csDestroying in ComponentState) then
    Exit;

  if Assigned(FTreeList) and (csDestroying in FTreeList.ComponentState) then
    Exit;

  with ColumnsListbox do
  begin
    for I := 0 to Items.Count - 1 do
      if TSCTreeColumn(Items.Objects[I]) = Sender then
      begin
        Items.Delete(I);
        ItemIndex := -1;

        with TSCFakeTreeColumn(Sender) do
        begin
          OnChangeCaption := nil;
          OnDestroy := nil;
        end;

        if (PDesigner <> nil) and (FTreeList <> nil) then
          {$IFDEF SC_DELPHI6_UP}
            IDesigner(PDesigner).SelectComponent(nil);
          {$ELSE}
            {$IFDEF SC_DELPHI4_UP}
            IFormDesigner(PDesigner).SelectComponent(nil);
            {$ELSE}
            TFormDesigner(PDesigner).SelectComponent(nil);
            {$ENDIF}
          {$ENDIF}

        Break;
      end;
  end;
end;

procedure TSCTreeColsForm.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (csDestroying in ComponentState) then
    Exit;

  if (Operation = opRemove) and (AComponent = FTreeList) then
  begin
    ReleaseTreeList;
    Self.Close;
  end;
end;

procedure TSCTreeColsForm.ReleaseTreeList;
var
  I: Integer;
begin
  FTreeList := nil;
  PDesigner := nil;

  with ColumnsListbox do
  begin
    Items.BeginUpdate;
    try
      for I := Items.Count - 1 downto 0 do
      begin
        if Items.Objects[I] <> nil then
          with TSCFakeTreeColumn(Items.Objects[I]) do
          begin
            OnChangeCaption := nil;
            OnDestroy := nil;
          end;

        Items.Delete(I);
      end;
    finally
      Items.EndUpdate;
    end;
  end;

  ColumnsListboxClick(nil);
end;

initialization
  ScreenForms := TList.Create;

finalization
  FreeAndNil(ScreenForms);

end.
