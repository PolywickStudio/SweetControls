{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCAboutForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SCControl, SCStdControls;

type
  TSCAboutForm_ = class(TForm)
    OKButton: TSCButton;
    SCLabel2: TSCLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SCAboutForm_: TSCAboutForm_;

implementation

{$R *.DFM}

end.
