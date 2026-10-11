unit SCTreeListEditor;

{$I SweetControls.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  {$IFDEF SC_DELPHI6_UP} Variants, Types, {$ENDIF} Dialogs, SCControl,
  SCStdControls, SCTreeList, StdCtrls, SCEdits, SCMaskEdit, SCAdvEdits,
  SCPopupColors;

type
  TTreeListEditorForm = class(TForm)
    ButtonPanel: TSCPanel;
    LinePanel: TSCPanel;
    OKButton: TSCButton;
    CancelButton: TSCButton;
    RightPanel: TSCPanel;
    ClientPanel: TSCPanel;
    DsgnTree: TSCTreeList;
    NewButton: TSCButton;
    SubButton: TSCButton;
    DeleteButton: TSCButton;
    Label1: TLabel;
    ImageCombo: TSCComboboxEx;
    Label2: TLabel;
    SelectedCombo: TSCComboboxEx;
    Label3: TLabel;
    HotCombo: TSCComboboxEx;
    Label4: TLabel;
    StateCombo: TSCComboboxEx;
    Label5: TLabel;
    FlagCombo: TSCComboboxEx;
    LinePanel2: TSCPanel;
    ClearButton: TSCButton;
    Label6: TLabel;
    Label7: TLabel;
    ColorCombo: TSCPopupColors;
    Label8: TLabel;
    EnabledCheck: TSCCheckbox;
    Label9: TLabel;
    Label10: TLabel;
    HeaderCheck: TSCCheckbox;
    Label11: TLabel;
    ButtonCombo: TSCComboboxEx;
    Label12: TLabel;
    AllowGrayedCheck: TSCCheckbox;
    Label13: TLabel;
    Label14: TLabel;
    PreviewCheck: TSCCheckbox;
    PreviewEdit: TSCFrameEdit;
    ColorDialog1: TColorDialog;
    procedure NewButtonClick(Sender: TObject);
    procedure SubButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure ImageComboChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonComboCloseUp(Sender: TObject);
    procedure ColorComboCloseUp(Sender: TObject);
    procedure ImageComboCloseUp(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DsgnTreeFocusedNodeChange(Sender: TObject);
    procedure PreviewEditChange(Sender: TObject);
    procedure ColorComboMoreButtonClick(Sender: TObject);
  private
    FUpdating: Boolean;
    procedure WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure UpdateNode;
  public
    class function ShowEditor(ATreeList: TSCTreeList): Boolean;
  end;

var
  TreeListEditorForm: TTreeListEditorForm;

implementation

{$R *.DFM}

{ TTreeListEditorForm }

procedure TTreeListEditorForm.WMGetMinMaxInfo(
  var Message: TWMGetMinMaxInfo);
begin
  Message.MinMaxInfo^.ptMinTrackSize := Point(400, 455);
  inherited;
end;

procedure TTreeListEditorForm.NewButtonClick(Sender: TObject);
var
  ANode, AParent: TSCTreeNode;
begin
  FUpdating := True;
  try
    if DsgnTree.FocusedNode = nil then
      ANode := DsgnTree.Add
    else begin
      AParent := DsgnTree.FocusedNode.Parent;
      
      if AParent = nil then
        ANode := DsgnTree.Add
      else ANode := AParent.AddChild;
    end;

    if ANode <> nil then
      with DsgnTree do
      begin
        if CanFocus then
          SetFocus;

        FocusedNode := ANode;
        MakeNodeVisible(ANode, False);

        ShowEditor;
      end;
  finally
    FUpdating := False;
  end;
end;

procedure TTreeListEditorForm.SubButtonClick(Sender: TObject);
var
  ANode, AParent: TSCTreeNode;
begin
  FUpdating := True;
  try
    if DsgnTree.FocusedNode <> nil then
    begin
      AParent := DsgnTree.FocusedNode;
      ANode := AParent.AddChild;

      if ANode <> nil then
        with DsgnTree do
        begin
          if CanFocus then
            SetFocus;

          FocusedNode := ANode;
          MakeNodeVisible(ANode, False);

          ShowEditor;
        end;
    end;
  finally
    FUpdating := False;
  end;
end;

procedure TTreeListEditorForm.DeleteButtonClick(Sender: TObject);
begin
  DsgnTree.DeleteSelection;
end;

procedure TTreeListEditorForm.ClearButtonClick(Sender: TObject);
begin
  FUpdating := True;
  try
    DsgnTree.ClearNodes;
  finally
    FUpdating := False;
    DsgnTreeFocusedNodeChange(DsgnTree);
  end;
end;

procedure TTreeListEditorForm.ImageComboChange(Sender: TObject);
begin
  if DsgnTree.CanFocus then
    DsgnTree.SetFocus;
  UpdateNode;
end;

procedure TTreeListEditorForm.UpdateNode;
var
  ANode: TSCTreeNode;
  AType: TSCTreeCheckButton;
begin
  if FUpdating then
    Exit;

  ANode := DsgnTree.FocusedNode;
  if ANode = nil then
    Exit;

  FUpdating := True;
  try
    if ImageCombo.Images <> nil then
      ANode.ImageIndex := ImageCombo.ItemIndex - 1;

    if SelectedCombo.Images <> nil then
      ANode.SelectedIndex := SelectedCombo.ItemIndex - 1;

    if HotCombo.Images <> nil then
      ANode.HotIndex := HotCombo.ItemIndex - 1;

    if StateCombo.Images <> nil then
      ANode.StateIndex := StateCombo.ItemIndex - 1;
      
    if FlagCombo.Images <> nil then
      ANode.FlagIndex := FlagCombo.ItemIndex - 1;

    ANode.Color := ColorCombo.SelectedColor;
    ANode.Enabled := EnabledCheck.Checked;
    ANode.GroupHeader := HeaderCheck.Checked;

    ANode.AllowGrayed := AllowGrayedCheck.Checked;
    AllowGrayedCheck.Checked := ANode.AllowGrayed;

    AType := ANode.ButtonType;
    if ButtonCombo.ItemIndex = 0 then
      AType := sctcbNone
    else
    if ButtonCombo.ItemIndex = 1 then
      AType := sctcbCheckbox
    else
    if ButtonCombo.ItemIndex = 2 then
      AType := sctcbRadioButton;

    ANode.ButtonType := AType;

    ANode.Preview := PreviewCheck.Checked;
    ANode.PreviewText := PreviewEdit.Text;
  finally
    FUpdating := False;
  end;
end;

class function TTreeListEditorForm.ShowEditor(ATreeList: TSCTreeList): Boolean;
var
  I: integer;
  AForm: TTreeListEditorForm;
begin
  Result := False;
  if ATreeList = nil then
    Exit;

  AForm := TTreeListEditorForm.Create(nil);
  try
    with AForm do
    begin
      Caption := 'SweetControls TreeList Editor (' + ATreeList.Name + ')';

      ImageCombo.Images := ATreeList.Images;
      ImageCombo.Enabled := ImageCombo.Images <> nil;

      ImageCombo.ItemsEx.BeginUpdate;
      try
        ImageCombo.ItemsEx.Clear;

        with ImageCombo.ItemsEx.Add do
        begin
          ImageIndex := -1;
          Text := 'None';
        end;

        if ImageCombo.Images <> nil then
          for I := 0 to ImageCombo.Images.Count-1 do
            with ImageCombo.ItemsEx.Add do
            begin
              ImageIndex := I;
              Text := IntToStr(I);
            end;
      finally
        ImageCombo.ItemsEx.EndUpdate;
      end;

      SelectedCombo.Images := ATreeList.Images;
      SelectedCombo.Enabled := SelectedCombo.Images <> nil;

      SelectedCombo.ItemsEx.BeginUpdate;
      try
        SelectedCombo.ItemsEx.Clear;

        with SelectedCombo.ItemsEx.Add do
        begin
          ImageIndex := -1;
          Text := 'None';
        end;

        if SelectedCombo.Images <> nil then
          for I := 0 to SelectedCombo.Images.Count-1 do
            with SelectedCombo.ItemsEx.Add do
            begin
              ImageIndex := I;
              Text := IntToStr(I);
            end;
      finally
        SelectedCombo.ItemsEx.EndUpdate;
      end;

      HotCombo.Images := ATreeList.Images;
      HotCombo.Enabled := HotCombo.Images <> nil;

      HotCombo.ItemsEx.BeginUpdate;
      try
        HotCombo.ItemsEx.Clear;

        with HotCombo.ItemsEx.Add do
        begin
          ImageIndex := -1;
          Text := 'None';
        end;

        if HotCombo.Images <> nil then
          for I := 0 to HotCombo.Images.Count-1 do
            with HotCombo.ItemsEx.Add do
            begin
              ImageIndex := I;
              Text := IntToStr(I);
            end;
      finally
        HotCombo.ItemsEx.EndUpdate;
      end;

      StateCombo.Images := ATreeList.StateImages;
      StateCombo.Enabled := StateCombo.Images <> nil;

      StateCombo.ItemsEx.BeginUpdate;
      try
        StateCombo.ItemsEx.Clear;

        with StateCombo.ItemsEx.Add do
        begin
          ImageIndex := -1;
          Text := 'None';
        end;

        if StateCombo.Images <> nil then
          for I := 0 to StateCombo.Images.Count-1 do
            with StateCombo.ItemsEx.Add do
            begin
              ImageIndex := I;
              Text := IntToStr(I);
            end;
      finally
        StateCombo.ItemsEx.EndUpdate;
      end;

      FlagCombo.Images := ATreeList.FlagImages;
      FlagCombo.Enabled := FlagCombo.Images <> nil;

      FlagCombo.ItemsEx.BeginUpdate;
      try
        FlagCombo.ItemsEx.Clear;

        with FlagCombo.ItemsEx.Add do
        begin
          ImageIndex := -1;
          Text := 'None';
        end;

        if FlagCombo.Images <> nil then
          for I := 0 to FlagCombo.Images.Count-1 do
            with FlagCombo.ItemsEx.Add do
            begin
              ImageIndex := I;
              Text := IntToStr(I);
            end;
      finally
        FlagCombo.ItemsEx.EndUpdate;
      end;
    end;

    with AForm.DsgnTree do
    begin
      BeginUpdate;
      try
        BorderProps := ATreeList.BorderProps;
        Buttons := ATreeList.Buttons;
        CheckButtonStyle := ATreeList.CheckButtonStyle;
        Color := ATreeList.Color;
        Colors := ATreeList.Colors;
        FlagImages := ATreeList.FlagImages;
        Font := ATreeList.Font;
        Hottrack := ATreeList.Hottrack;
        Images := ATreeList.Images;
        Indent := ATreeList.Indent;
        Indicator := ATreeList.Indicator;
        LineStyle := ATreeList.LineStyle;
        LookAndFeel := ATreeList.LookAndFeel;
        NodeIndent := ATreeList.NodeIndent;
        
        Colors.HideSelectionColor := clBtnFace;
        Colors.HideSelectionTextColor := clBtnText;

        OptionsBehaviour := ATreeList.OptionsBehaviour -
          [sctboImmediateEditor] + [sctboAllowEditing, sctboAutoDragMove];

        OptionsView := ATreeList.OptionsView - [sctvoHideSelection];

        PaintStyle := ATreeList.PaintStyle;
        Picture := ATreeList.Picture;
        PictureProps := ATreeList.PictureProps;
        RowHeight := ATreeList.RowHeight;
        Scrollbars := ATreeList.Scrollbars;
        StateImages := ATreeList.StateImages;
        UnderlineStyle := ATreeList.UnderlineStyle;

        AssignNodes(ATreeList);
        // FullExpand;
      finally
        EndUpdate;
      end;
    end;

    if AForm.ShowModal = mrOk then
    begin
      Result := True;
      
      ATreeList.AssignNodes(AForm.DsgnTree);
      // ATreeList.FullExpand;
    end;
  finally
    AForm.Free;
  end;
end;

procedure TTreeListEditorForm.FormCreate(Sender: TObject);
begin
  FUpdating := False;
end;

procedure TTreeListEditorForm.ButtonComboCloseUp(Sender: TObject);
begin
  if DsgnTree.CanFocus then
    DsgnTree.SetFocus;
end;

procedure TTreeListEditorForm.ColorComboCloseUp(Sender: TObject);
begin
  if DsgnTree.CanFocus then
    DsgnTree.SetFocus;
end;

procedure TTreeListEditorForm.ImageComboCloseUp(Sender: TObject);
begin
  if DsgnTree.CanFocus then
    DsgnTree.SetFocus;
end;

procedure TTreeListEditorForm.FormShow(Sender: TObject);
begin
  if DsgnTree.Count > 0 then
    with DsgnTree do
    begin
      FocusedNode := Items[0];
      MakeNodeVisible(Items[0], False);
    end;
end;

procedure TTreeListEditorForm.DsgnTreeFocusedNodeChange(Sender: TObject);
var
  AIndex: Integer;
  ANode: TSCTreeNode;
begin
  if FUpdating then
    Exit;

  ANode := DsgnTree.FocusedNode;
  FUpdating := True;
  try
    if ANode = nil then
    begin
      ImageCombo.ItemIndex := 0;
      SelectedCombo.ItemIndex := 0;
      HotCombo.ItemIndex := 0;
      StateCombo.ItemIndex := 0;
      FlagCombo.ItemIndex := 0;

      ColorCombo.SelectedColor := clNone;
      EnabledCheck.Checked := False;
      HeaderCheck.Checked := False;
      AllowGrayedCheck.Checked := False;
      ButtonCombo.ItemIndex := 0;

      PreviewCheck.Checked := True;
      PreviewEdit.Text := '';
    end else
    begin
      ImageCombo.ItemIndex := ANode.ImageIndex + 1;
      SelectedCombo.ItemIndex := ANode.SelectedIndex + 1;
      HotCombo.ItemIndex := ANode.HotIndex + 1;
      StateCombo.ItemIndex := ANode.StateIndex + 1;
      FlagCombo.ItemIndex := ANode.FlagIndex + 1;

      ColorCombo.SelectedColor := ANode.Color;
      EnabledCheck.Checked := ANode.Enabled;
      HeaderCheck.Checked := ANode.GroupHeader;
      AllowGrayedCheck.Checked := ANode.AllowGrayed;

      AIndex := 0;
      if ANode.ButtonType = sctcbCheckbox then
        AIndex := 1
      else if ANode.ButtonType = sctcbRadioButton then
        AIndex := 2;

      ButtonCombo.ItemIndex := AIndex;


      PreviewCheck.Checked := ANode.Preview;
      PreviewEdit.Text := ANode.PreviewText;
    end;
  finally
    FUpdating := False;
  end;
end;

procedure TTreeListEditorForm.PreviewEditChange(Sender: TObject);
begin
  UpdateNode;
end;

procedure TTreeListEditorForm.ColorComboMoreButtonClick(Sender: TObject);
begin
  ColorDialog1.Color := ColorCombo.SelectedColor;
  if ColorDialog1.Execute then
    ColorCombo.SelectedColor := ColorDialog1.Color;
end;

end.
