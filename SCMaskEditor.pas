{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCMaskEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCCommon, StdCtrls, SCControl, SCStdControls, SCEdits, SCMaskEdit, ComCtrls;

type
  TSCMaskEditorForm = class(TForm)
    TestInput: TSCMaskEdit;
    InputMaskLabel: TLabel;
    SampleMasks: TListView;
    SampleLabel: TLabel;
    BlankEdit: TSCEdit;
    BlankLabel: TLabel;
    SaveLiterals: TSCCheckbox;
    InputMask: TSCEdit;
    TestLabel: TLabel;
    MasksButton: TSCButton;
    OKButton: TSCButton;
    CancelButton: TSCButton;
    OpenMaskDialog: TOpenDialog;
    procedure SampleMasksChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure InputMaskChange(Sender: TObject);
    procedure BlankEditChange(Sender: TObject);
    procedure SaveLiteralsChange(Sender: TObject);
    procedure MasksButtonClick(Sender: TObject);
  private
    FInApply: Boolean;
    FShemeList: TSCShemeList;
    procedure AddToSampleMasks(S: String);
    procedure ApplyMask(S: String);
    procedure ApplyBlankChar(C: Char);
    procedure ApplySaveLiterals(B: Boolean);
    function  GetMask: string;
    procedure SetMask(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Mask: string read GetMask write SetMask;
  end;

implementation

{$R *.DFM}

const
  SampleMaskStrs: array[0..7] of String = (
    'Phone | 4155551212 | !\(999\)000-0000;1;_',
    'Extension | 15450 | !99999;1;_',
    'Social Security | 555555555 | 000\-00\-0000;1;_',
    'Short Zip Code | 90504 | 00000;1;_',
    'Long Zip Code | 905040000 | 00000\-9999;1;_',
    'Date | 062794 | !99/99/00;1;_',
    'Long Time | 090515PM | !90:00:00>LL;1;_',
    'Short Time | 1345 | !90:00;1;_'
    );

{ TSCMaskEditorForm }

procedure TSCMaskEditorForm.AddToSampleMasks(S: String);
var
  P: Integer;
  Item: TListItem;
  Cap, Data: String;
  Sampler: TSCShemeList;
begin
  if S = '' then
    Exit;

  P := AnsiPos(' | ', S);
  if P = 0 then
    Exit;

  Cap := Copy(S, 1, P);
  Delete(S, 1, P + 2);

  P := AnsiPos(' | ', S);
  if P = 0 then
    Exit;

  Data := Copy(S, 1, P);
  Delete(S, 1, P + 2);

  if S = '' then
    Exit;

  Sampler := TSCShemeList.Create;
  try
    Sampler.Mask := S;

    Item := SampleMasks.Items.Add;

    Item.Caption := Cap;
    Item.SubItems.Add(Sampler.ApplyMaskToText(Data));
    Item.SubItems.Add(S);
  finally
    Sampler.Free;
  end;
end;

procedure TSCMaskEditorForm.ApplyMask(S: String);
var
  C: Char;
begin
  if FInApply or (FShemeList = nil) then
    Exit;

  FInApply := True;
  try
    if S = '' then
    begin
      InputMask.Text := '';

      TestInput.EditMask := '';
      TestInput.Text := '';

      Exit;
    end;

    FShemeList.Mask := S;

    InputMask.Text  := S;
    C := FShemeList.BlankChar;

    if C = #0 then
      BlankEdit.Text := ''
    else
      BlankEdit.Text := C;

    SaveLiterals.Checked := FShemeList.SaveLiterals;
    TestInput.EditMask := S;
  finally
    FInApply := False;
  end;
end;

constructor TSCMaskEditorForm.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);

  FInApply := False;
  FShemeList := TSCShemeList.Create;

  for I := Low(SampleMaskStrs) to High(SampleMaskStrs) do
    AddToSampleMasks(SampleMaskStrs[I]);
end;

destructor TSCMaskEditorForm.Destroy;
begin
  FreeAndNil(FShemeList);
  inherited Destroy;
end;

procedure TSCMaskEditorForm.SampleMasksChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var
  S: String;
begin
  if (Item <> nil) and (Change = ctState) then
  begin
    S := '';
    if Item.SubItems.Count > 1 then
      S := Item.SubItems[1];

    ApplyMask(S);  
  end;
end;

procedure TSCMaskEditorForm.InputMaskChange(Sender: TObject);
begin
  ApplyMask(InputMask.Text);
end;

procedure TSCMaskEditorForm.ApplyBlankChar(C: Char);
begin
  if FInApply then
    Exit;

  FInApply := True;
  try
    if InputMask.Text = '' then
    begin
      TestInput.EditMask := '';
      TestInput.Text := '';

      Exit;
    end;

    FShemeList.BlankChar := C;

    InputMask.Text := FShemeList.GetEditMask(False);
    if C = #0 then
      BlankEdit.Text := ''
    else
      BlankEdit.Text := C;

    SaveLiterals.Checked := FShemeList.SaveLiterals;
    TestInput.EditMask := FShemeList.Mask;
  finally
    FInApply := False;
  end;
end;

procedure TSCMaskEditorForm.ApplySaveLiterals(B: Boolean);
var
  C: Char;
begin
  if FInApply then
    Exit;

  FInApply := True;
  try
    if InputMask.Text = '' then
    begin
      TestInput.EditMask := '';
      TestInput.Text := '';

      Exit;
    end;

    FShemeList.SaveLiterals := B;
    InputMask.Text := FShemeList.GetEditMask(False);

    C := FShemeList.BlankChar;
    if C = #0 then
      BlankEdit.Text := ''
    else
      BlankEdit.Text := C;

    SaveLiterals.Checked := B;
    TestInput.EditMask := FShemeList.Mask;
  finally
    FInApply := False;
  end;
end;

procedure TSCMaskEditorForm.BlankEditChange(Sender: TObject);
var
  C: Char;
begin
  C := #0;
  if BlankEdit.Text <> '' then
    C := BlankEdit.Text[1];

  ApplyBlankChar(C);
end;

procedure TSCMaskEditorForm.SaveLiteralsChange(Sender: TObject);
begin
  ApplySaveLiterals(SaveLiterals.Checked);
end;

procedure TSCMaskEditorForm.MasksButtonClick(Sender: TObject);
var
  S: String;
  I: Integer;
  Fl: TStringList;
begin
  if OpenMaskDialog.Execute then
  begin
    Fl := TStringList.Create;
    try
      Fl.LoadFromFile(OpenMaskDialog.FileName);
      if Fl.Count = 0 then
        Exit;

      S := Fl.Strings[0];
      if AnsiPos(' | ', S) = 0 then
        Exit;

      SampleMasks.Items.Clear;  
      for I := 0 to Fl.Count-1 do
        AddToSampleMasks(Fl.Strings[I]);
    finally
      Fl.Free;
    end;
  end;
end;

function TSCMaskEditorForm.GetMask: string;
begin
  Result := InputMask.Text;
end;

procedure TSCMaskEditorForm.SetMask(const Value: string);
begin
  InputMask.Text := Value;
end;

end.
