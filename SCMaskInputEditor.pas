{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCMaskInputEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCControl, SCStdControls, SCMaskEdit, StdCtrls, SCEdits;

type
  TSCMaskInputForm = class(TForm)
    OKButton: TSCButton;
    CancelButton: TSCButton;
    InputLabel: TLabel;
    InputEdit: TSCMaskEdit;
    MaskCaptionLabel: TLabel;
    MaskLabel: TLabel;
  private
    function  GetMask: String;
    procedure SetMask(const Value: String);
  public
    property Mask: String read GetMask write SetMask;
  end;

var
  SCMaskInputForm: TSCMaskInputForm;

implementation

{$R *.DFM}

{ TSCMaskInputForm }

function TSCMaskInputForm.GetMask: String;
begin
  Result := InputEdit.EditMask;
end;

procedure TSCMaskInputForm.SetMask(const Value: String);
begin
  InputEdit.EditMask := Value;
  MaskLabel.Caption  := Value;
  if Value = '' then
    MaskLabel.Caption := 'None';
end;

end.
