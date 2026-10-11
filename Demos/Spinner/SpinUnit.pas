unit SpinUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCControl, SCStdControls, StdCtrls, SCEdits, SCMaskEdit, SCAdvEdits,
  SCSpinEdits;

type
  TForm1 = class(TForm)
    SCSpinButton1: TSCSpinButton;
    Label1: TLabel;
    SCIntSpinEdit1: TSCIntSpinEdit;
    Label2: TLabel;
    SCIntSpinEdit2: TSCIntSpinEdit;
    Label3: TLabel;
    SCIntSpinEdit3: TSCIntSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SCIntSpinEdit4: TSCIntSpinEdit;
    Label7: TLabel;
    procedure SCSpinButton1Change(Sender: TObject);
    procedure SCIntSpinEdit1Change(Sender: TObject);
    procedure SCIntSpinEdit2Change(Sender: TObject);
    procedure SCIntSpinEdit3Change(Sender: TObject);
    procedure SCIntSpinEdit4Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SCSpinButton1Change(Sender: TObject);
begin
  Label1.Caption := IntToStr(SCSpinButton1.Position);
end;

procedure TForm1.SCIntSpinEdit1Change(Sender: TObject);
begin
  SCSpinButton1.Min := SCIntSpinEdit1.IntValue;
  SCIntSpinEdit2.IntValue := SCSpinButton1.Max;
end;

procedure TForm1.SCIntSpinEdit2Change(Sender: TObject);
begin
  SCSpinButton1.Max := SCIntSpinEdit2.IntValue;
  SCIntSpinEdit1.IntValue := SCSpinButton1.Min;
end;

procedure TForm1.SCIntSpinEdit3Change(Sender: TObject);
begin
  SCSpinButton1.Interval := SCIntSpinEdit3.IntValue;
end;

procedure TForm1.SCIntSpinEdit4Change(Sender: TObject);
begin
  SCSpinButton1.Increment := SCIntSpinEdit4.IntValue;
end;

end.
