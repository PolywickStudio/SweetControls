unit Ffactwin;

{ This application shows how to display Paradox style memo and graphic
 fields in a form. Table1's DatabaseName property should point to the
 Delphi sample database. Table1's TableName property should be set to 
 the BIOLIFE table. }

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, DBCtrls, DBGrids, DB, DBTables, Buttons,
  Grids, ExtCtrls, SCStdControls, SCDbCtrls, SCLinkedControls, SCControl,
  SCImageBox, SCAdvEdits, SCDbExtCtrls, SCEdits, SCMaskEdit, SCExtControls,
  SCGraphicButton, SCDbNavButton;

type
  TForm1 = class(TForm)
    DataSource1: TDataSource;
    Table1: TTable;
    Table1Common_Name: TStringField;
    Table1Graphic: TBlobField;
    Table1Category: TStringField;
    Table1SpeciesName: TStringField;
    Table1Lengthcm: TFloatField;
    Table1Length_In: TFloatField;
    Table1Notes: TMemoField;
    SCDBIntSpinEdit1: TSCDBIntSpinEdit;
    SCDBFloatSpinEdit1: TSCDBFloatSpinEdit;
    SCDBImage1: TSCDBImage;
    SCDBMemo1: TSCDBMemo;
    SCPanel1: TSCPanel;
    SCDBLabel1: TSCDBLabel;
    SCDBLabel2: TSCDBLabel;
    SCLabel1: TSCLabel;
    SCLabel2: TSCLabel;
    SCLabel3: TSCLabel;
    SCDBEdit1: TSCDBEdit;
    SCLabel4: TSCLabel;
    SCDBEdit2: TSCDBEdit;
    SCNavButton1: TSCNavButton;
    SCNavButton2: TSCNavButton;
    SCNavButton3: TSCNavButton;
    SCNavButton4: TSCNavButton;
    SCNavButton5: TSCNavButton;
    SCNavButton6: TSCNavButton;
    SCNavButton7: TSCNavButton;
    SCNavButton8: TSCNavButton;
    SCNavButton9: TSCNavButton;
    SCNavButton10: TSCNavButton;
    SCNavButton11: TSCNavButton;
    SCBevel1: TSCBevel;
    SCButton1: TSCButton;
    SCDBCheckBox1: TSCDBCheckBox;
    procedure SCButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SCButton1Click(Sender: TObject);
begin
  Close;
end;

end.
