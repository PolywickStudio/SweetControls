unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  JPeg, SCConsts, SCCommon, SCPanels, SCControl, ExtCtrls, SCPopupColors,
  ImgList, SCStatusBar, SCSplitter, SCStdControls, SCMaskEdit, SCAdvEdits,
  SCEdits, SCImageBox, SCSimpleListbox, SCTrackbar, SCScrollbars,
  SCButtonSet, SCTabSet, SCExtControls, System.ImageList;

type
  TForm1 = class(TForm)
    SCGroupContainer1: TSCGroupContainer;
    SCListGroup1: TSCListGroup;
    Notebook1: TNotebook;
    SCSplitter1: TSCSplitter;
    SCStatusBar1: TSCStatusBar;
    SCLabel1: TSCLabel;
    ImageList1: TImageList;
    ImageList2: TImageList;
    SCEdit1: TSCEdit;
    SCComboboxEx1: TSCComboboxEx;
    SCLabel17: TSCLabel;
    SCLabel18: TSCLabel;
    SCComboboxEx2: TSCComboboxEx;
    SCLabel19: TSCLabel;
    SCEdit2: TSCEdit;
    ImageList3: TImageList;
    SCLabel16: TSCLabel;
    SCCheckbox1: TSCCheckbox;
    SCCheckbox2: TSCCheckbox;
    SCComboboxEx3: TSCComboboxEx;
    SCLabel20: TSCLabel;
    SCCheckbox3: TSCCheckbox;
    SCImageBox1: TSCImageBox;
    SCCheckbox4: TSCCheckbox;
    SCPopupColors1: TSCPopupColors;
    SCLabel21: TSCLabel;
    SCComboboxEx4: TSCComboboxEx;
    SCLabel22: TSCLabel;
    SCButton1: TSCButton;
    SCButton2: TSCButton;
    SCCheckbox5: TSCCheckbox;
    SCCheckbox6: TSCCheckbox;
    SCPopupColors2: TSCPopupColors;
    SCLabel23: TSCLabel;
    SCCheckbox7: TSCCheckbox;
    Panel2: TPanel;
    SCRadioButton1: TSCRadioButton;
    SCListboxEx1: TSCListboxEx;
    ImageList4: TImageList;
    SCPictureList1: TSCPictureList;
    SCLabel26: TSCLabel;
    SCComboboxEx5: TSCComboboxEx;
    SCLabel27: TSCLabel;
    SCComboboxEx6: TSCComboboxEx;
    SCLabel28: TSCLabel;
    SCPopupColors3: TSCPopupColors;
    SCLabel29: TSCLabel;
    SCLabel30: TSCLabel;
    SCLabel31: TSCLabel;
    SCPopupColors4: TSCPopupColors;
    SCLabel32: TSCLabel;
    SCPopupColors5: TSCPopupColors;
    SCPopupColors6: TSCPopupColors;
    SCLabel33: TSCLabel;
    SCPopupColors7: TSCPopupColors;
    SCPopupColors8: TSCPopupColors;
    SCLabel34: TSCLabel;
    SCPopupColors9: TSCPopupColors;
    SCPopupColors10: TSCPopupColors;
    SCLabel35: TSCLabel;
    SCPopupColors11: TSCPopupColors;
    SCPopupColors12: TSCPopupColors;
    SCPopupColors13: TSCPopupColors;
    SCPopupColors14: TSCPopupColors;
    SCCheckbox15: TSCCheckbox;
    SCCheckbox16: TSCCheckbox;
    SCCheckbox17: TSCCheckbox;
    SCCheckbox18: TSCCheckbox;
    SCCheckbox19: TSCCheckbox;
    SCLabel36: TSCLabel;
    SCComboboxEx7: TSCComboboxEx;
    SCCheckbox20: TSCCheckbox;
    SCLabel37: TSCLabel;
    SCPopupColors15: TSCPopupColors;
    SCLabel38: TSCLabel;
    SCPopupColors16: TSCPopupColors;
    SCLabel39: TSCLabel;
    SCPopupColors17: TSCPopupColors;
    SCCheckbox21: TSCCheckbox;
    SCComboboxEx8: TSCComboboxEx;
    SCLabel40: TSCLabel;
    Panel1: TPanel;
    SCComboboxEx9: TSCComboboxEx;
    SCLabel24: TSCLabel;
    SCRadioButton2: TSCRadioButton;
    SCLabel25: TSCLabel;
    SCComboboxEx10: TSCComboboxEx;
    SCCheckbox8: TSCCheckbox;
    Panel3: TPanel;
    SCProgress1: TSCProgress;
    SCLabel41: TSCLabel;
    SCComboboxEx11: TSCComboboxEx;
    SCLabel42: TSCLabel;
    SCComboboxEx12: TSCComboboxEx;
    SCLabel43: TSCLabel;
    SCLabel44: TSCLabel;
    SCPopupColors18: TSCPopupColors;
    SCPopupColors19: TSCPopupColors;
    SCLabel45: TSCLabel;
    SCTrackbar1: TSCTrackbar;
    Panel4: TPanel;
    SCSpinButton1: TSCSpinButton;
    SCSpinButton2: TSCSpinButton;
    SCLabel46: TSCLabel;
    SCComboboxEx13: TSCComboboxEx;
    SCLabel47: TSCLabel;
    SCComboboxEx14: TSCComboboxEx;
    SCLabel2: TSCLabel;
    SCComboboxEx15: TSCComboboxEx;
    SCLabel3: TSCLabel;
    SCPopupColors21: TSCPopupColors;
    SCCheckbox9: TSCCheckbox;
    SCLabel6: TSCLabel;
    SCComboboxEx16: TSCComboboxEx;
    SCLabel5: TSCLabel;
    SCPopupColors22: TSCPopupColors;
    SCPopupColors20: TSCPopupColors;
    SCLabel4: TSCLabel;
    SCLabel7: TSCLabel;
    SCPopupColors23: TSCPopupColors;
    SCPopupColors24: TSCPopupColors;
    SCLabel8: TSCLabel;
    SCCheckbox10: TSCCheckbox;
    SCPanel1: TSCPanel;
    SCCheckbox11: TSCCheckbox;
    SCLabel9: TSCLabel;
    SCPopupColors25: TSCPopupColors;
    SCCheckbox12: TSCCheckbox;
    SCEdit3: TSCEdit;
    SCLabel10: TSCLabel;
    SCCheckbox13: TSCCheckbox;
    SCTrackbar2: TSCTrackbar;
    SCLabel11: TSCLabel;
    SCComboboxEx17: TSCComboboxEx;
    SCLabel12: TSCLabel;
    SCComboboxEx18: TSCComboboxEx;
    ImageList5: TImageList;
    SCComboboxEx19: TSCComboboxEx;
    SCLabel13: TSCLabel;
    SCLabel14: TSCLabel;
    SCComboboxEx20: TSCComboboxEx;
    SCLabel15: TSCLabel;
    SCLabel48: TSCLabel;
    SCLabel49: TSCLabel;
    SCPopupColors26: TSCPopupColors;
    SCPopupColors27: TSCPopupColors;
    SCComboboxEx21: TSCComboboxEx;
    SCLabel50: TSCLabel;
    SCScrollbar1: TSCScrollbar;
    Panel5: TPanel;
    SCLabel51: TSCLabel;
    SCPopupColors28: TSCPopupColors;
    SCLabel52: TSCLabel;
    SCLabel53: TSCLabel;
    SCLabel54: TSCLabel;
    SCPopupColors29: TSCPopupColors;
    SCLabel55: TSCLabel;
    SCPopupColors30: TSCPopupColors;
    SCPopupColors31: TSCPopupColors;
    SCLabel56: TSCLabel;
    SCPopupColors32: TSCPopupColors;
    SCPopupColors33: TSCPopupColors;
    SCLabel57: TSCLabel;
    SCPopupColors34: TSCPopupColors;
    SCPopupColors35: TSCPopupColors;
    SCLabel58: TSCLabel;
    SCPopupColors36: TSCPopupColors;
    SCPopupColors37: TSCPopupColors;
    SCPopupColors38: TSCPopupColors;
    SCPopupColors39: TSCPopupColors;
    SCLabel59: TSCLabel;
    SCComboboxEx22: TSCComboboxEx;
    SCLabel60: TSCLabel;
    SCComboboxEx23: TSCComboboxEx;
    SCScrollbar2: TSCScrollbar;
    SCButtonSet1: TSCButtonSet;
    SCLabel61: TSCLabel;
    SCComboboxEx24: TSCComboboxEx;
    ImageList6: TImageList;
    SCLabel62: TSCLabel;
    SCComboboxEx25: TSCComboboxEx;
    Panel6: TPanel;
    SCTabset1: TSCTabset;
    SCLabel63: TSCLabel;
    SCComboboxEx26: TSCComboboxEx;
    SCCheckbox14: TSCCheckbox;
    SCLabel64: TSCLabel;
    SCPopupColors40: TSCPopupColors;
    SCLabel65: TSCLabel;
    SCPopupColors41: TSCPopupColors;
    SCLabel66: TSCLabel;
    SCPopupColors42: TSCPopupColors;
    SCLabel67: TSCLabel;
    SCPopupColors43: TSCPopupColors;
    SCLabel68: TSCLabel;
    SCPopupColors44: TSCPopupColors;
    SCCheckbox22: TSCCheckbox;
    SCHeader1: TSCHeader;
    SCLabel69: TSCLabel;
    SCComboboxEx27: TSCComboboxEx;
    SCLabel70: TSCLabel;
    SCPopupColors45: TSCPopupColors;
    SCPopupColors46: TSCPopupColors;
    SCLabel71: TSCLabel;
    SCPopupColors47: TSCPopupColors;
    SCLabel72: TSCLabel;
    Panel7: TPanel;
    SCPanel2: TSCPanel;
    SCStatusBar2: TSCStatusBar;
    SCLabel73: TSCLabel;
    SCComboboxEx28: TSCComboboxEx;
    SCLabel74: TSCLabel;
    SCComboboxEx29: TSCComboboxEx;
    procedure SCComboboxEx1Change(Sender: TObject);
    procedure SCCheckbox1Change(Sender: TObject);
    procedure SCCheckbox2Change(Sender: TObject);
    procedure SCComboboxEx3Change(Sender: TObject);
    procedure SCCheckbox3Change(Sender: TObject);
    procedure SCCheckbox4Change(Sender: TObject);
    procedure SCPopupColors1SelectedColorChange(Sender: TObject);
    procedure SCComboboxEx4Change(Sender: TObject);
    procedure SCCheckbox5Change(Sender: TObject);
    procedure SCComboboxEx5Change(Sender: TObject);
    procedure SCComboboxEx6Change(Sender: TObject);
    procedure SCPopupColors3SelectedColorChange(Sender: TObject);
    procedure SCCheckbox15Change(Sender: TObject);
    procedure SCComboboxEx7Change(Sender: TObject);
    procedure SCComboboxEx8Change(Sender: TObject);
    procedure SCComboboxEx9Change(Sender: TObject);
    procedure SCComboboxEx10Change(Sender: TObject);
    procedure SCComboboxEx11Change(Sender: TObject);
    procedure SCComboboxEx12Change(Sender: TObject);
    procedure SCTrackbar1Change(Sender: TObject);
    procedure SCComboboxEx13Change(Sender: TObject);
    procedure SCComboboxEx14Change(Sender: TObject);
    procedure SCComboboxEx15Change(Sender: TObject);
    procedure SCPopupColors21SelectedColorChange(Sender: TObject);
    procedure SCComboboxEx16Change(Sender: TObject);
    procedure SCPopupColors23SelectedColorChange(Sender: TObject);
    procedure SCCheckbox11Change(Sender: TObject);
    procedure SCComboboxEx17Change(Sender: TObject);
    procedure SCComboboxEx20Change(Sender: TObject);
    procedure SCPopupColors28SelectedColorChange(Sender: TObject);
    procedure SCComboboxEx22Change(Sender: TObject);
    procedure SCComboboxEx24Change(Sender: TObject);
    procedure SCComboboxEx26Change(Sender: TObject);
    procedure SCComboboxEx27Change(Sender: TObject);
    procedure SCComboboxEx28Change(Sender: TObject);
    procedure SCListGroup1ItemClick(Sender: TObject; AItem: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SCComboboxEx1Change(Sender: TObject);
var
  S: string;
  PsIndx, PsImg: Integer;
begin
  PsIndx := SCComboboxEx1.ItemIndex;
  if PsIndx < 0 then PsIndx := 0;

  case PsIndx of
    0: SCEdit1.PasswordStyle := scpsNone;
    1: SCEdit1.PasswordStyle := scpsChar;
    2: SCEdit1.PasswordStyle := scpsImage;
  end;

  PsImg := SCComboboxEx2.ItemIndex;
  if PsImg < 0 then PsImg := 0;

  SCComboboxEx2.ImageIndex := PsImg;

  if PsIndx <> 0 then
  begin
    SCEdit1.PasswordImage := PsImg;

    S := '*';
    if SCEdit2.Text <> '' then S := SCEdit2.Text;

    SCEdit1.PasswordChar := S[1];
  end;
end;

procedure TForm1.SCCheckbox1Change(Sender: TObject);
begin
  SCEdit1.CanDragSelection := SCCheckbox1.Checked;
end;

procedure TForm1.SCCheckbox2Change(Sender: TObject);
begin
  SCEdit1.Checkbox.Visible := SCCheckbox2.Checked;
end;

procedure TForm1.SCComboboxEx3Change(Sender: TObject);
var
  ImgIndx: Integer;
begin
  ImgIndx := SCComboboxEx3.ItemIndex - 1;
  if ImgIndx > -1 then Inc(ImgIndx, 3);

  SCEdit1.UseImage := ImgIndx > -1;
  SCEdit1.ImageIndex := ImgIndx;
end;

procedure TForm1.SCCheckbox3Change(Sender: TObject);
begin
  TSCEditPictureProps(SCEdit1.PictureProps).Visible := SCCheckbox3.Checked;

  if SCCheckbox3.Checked or SCCheckbox4.Checked then
    SCEdit1.Font.Color := clWhite
  else
    SCEdit1.ParentFont := True;
end;

procedure TForm1.SCCheckbox4Change(Sender: TObject);
begin
  SCEdit1.Transparent := SCCheckbox4.Checked;
  SCImageBox1.Visible := SCCheckbox4.Checked;

  if SCCheckbox4.Checked or SCCheckbox3.Checked then
    SCEdit1.Font.Color := clWhite
  else
    SCEdit1.ParentFont := True;
end;

procedure TForm1.SCPopupColors1SelectedColorChange(Sender: TObject);
begin
  TSCEditColors(SCEdit1.Colors).HighlightColor := SCPopupColors1.SelectedColor;
end;

procedure TForm1.SCComboboxEx4Change(Sender: TObject);
begin
  if SCComboboxEx4.ItemIndex = 1 then
    SCEdit1.EditMode := scemOverwrite
  else
    SCEdit1.EditMode := scemInsert;
end;

procedure TForm1.SCCheckbox5Change(Sender: TObject);
var
  I: Integer;
  C: TControl;
begin
  for I := 0 to SCCheckbox5.Parent.ControlCount-1 do
  begin
    C := SCCheckbox5.Parent.Controls[I];

    if C is TSCButton then
      with TSCButton(C) do
      begin
        Color := SCPopupColors2.SelectedColor;

        AllowAllUp := SCCheckbox6.Checked;
        GroupIndex := 1;

        if not SCCheckbox5.Checked then
        begin
          Down := False;
          GroupIndex := 0;
        end;
      end;
  end;
end;

procedure TForm1.SCComboboxEx5Change(Sender: TObject);
var
  Cb: TSCControlBorder;
begin
  Cb := sccb3DLowered;
  case SCComboboxEx5.ItemIndex of
    0: Cb := sccbNone;
    1: Cb := sccb3DLowered;
    2: Cb := sccb3DRaised;
    3: Cb := sccbBumped;
    4: Cb := sccbEtched;
    5: Cb := sccbFlat;
    6: Cb := sccbLowered;
    7: Cb := sccbRaised;
    8: Cb := sccbMacLowered;
    9: Cb := sccbMacRaised;
    10: Cb := sccbSoftLowered;
    11: Cb := sccbSoftRaised;
  end;

  TSCListBorderProps(SCListboxEx1.BorderProps).Border := Cb;
end;

procedure TForm1.SCComboboxEx6Change(Sender: TObject);
var
  Ss: TSCScrollbarStyle;
begin
  Ss := scssDefault;

  case SCComboboxEx6.ItemIndex of
    0: Ss := scssDefault;
    1: Ss := scssDefaultEx;
    2: Ss := scssFlat;
    3: Ss := scssFlatEx;
    4: Ss := scssOffice2k;
    5: Ss := scssXP;
    6: Ss := scssXP2;
    7: Ss := scss3D;
    8: Ss := scss3DX;
    9: Ss := TSCScrollbarStyle.scssNew;
    10: Ss := scssNewX;
    11: Ss := scssMac;
    12: Ss := scssSports;
  end;

  TSCListScrollbars(SCListboxEx1.Scrollbars).Style := Ss;
end;

type
  TSCFakeScrollbarPart = class(TSCScrollbarPart);

procedure TForm1.SCPopupColors3SelectedColorChange(Sender: TObject);
begin
  with TSCListScrollbars(SCListboxEx1.Scrollbars), TSCListboxScrollbar(Horizontal) do
  begin
    with TSCFakeScrollbarPart(Background) do
    begin
      Color := SCPopupColors3.SelectedColor;
      HotColor := SCPopupColors4.SelectedColor;
      DownColor := SCPopupColors11.SelectedColor;
    end;

    with TSCFakeScrollbarPart(ButtonColors) do
    begin
      Color := SCPopupColors5.SelectedColor;
      HotColor := SCPopupColors6.SelectedColor;
      DownColor := SCPopupColors12.SelectedColor;
    end;

    with TSCFakeScrollbarPart(Thumb) do
    begin
      Color := SCPopupColors7.SelectedColor;
      HotColor := SCPopupColors8.SelectedColor;
      DownColor := SCPopupColors13.SelectedColor;
    end;

    with TSCFakeScrollbarPart(Icons) do
    begin
      Color := SCPopupColors9.SelectedColor;
      HotColor := SCPopupColors10.SelectedColor;
      DownColor := SCPopupColors14.SelectedColor;
    end;
  end;

  with TSCListScrollbars(SCListboxEx1.Scrollbars), TSCListboxScrollbar(Vertical) do
  begin
    with TSCFakeScrollbarPart(Background) do
    begin
      Color := SCPopupColors3.SelectedColor;
      HotColor := SCPopupColors4.SelectedColor;
      DownColor := SCPopupColors11.SelectedColor;
    end;

    with TSCFakeScrollbarPart(ButtonColors) do
    begin
      Color := SCPopupColors5.SelectedColor;
      HotColor := SCPopupColors6.SelectedColor;
      DownColor := SCPopupColors12.SelectedColor;
    end;

    with TSCFakeScrollbarPart(Thumb) do
    begin
      Color := SCPopupColors7.SelectedColor;
      HotColor := SCPopupColors8.SelectedColor;
      DownColor := SCPopupColors13.SelectedColor;
    end;

    with TSCFakeScrollbarPart(Icons) do
    begin
      Color := SCPopupColors9.SelectedColor;
      HotColor := SCPopupColors10.SelectedColor;
      DownColor := SCPopupColors14.SelectedColor;
    end;
  end;
end;

procedure TForm1.SCCheckbox15Change(Sender: TObject);
begin
  SCListboxEx1.ShowCheckboxes := SCCheckbox15.Checked;
  SCListboxEx1.AllowGrayed := SCCheckbox16.Checked;
  SCListboxEx1.EndEllipsis := SCCheckbox17.Checked;
  SCListboxEx1.ShowItemHints := SCCheckbox18.Checked;
  SCListboxEx1.LineSelect := SCCheckbox19.Checked;
  SCListboxEx1.Hottrack := SCCheckbox20.Checked;

  TSCListPictureProps(SCListboxEx1.PictureProps).Visible := SCCheckbox21.Checked;

  SCListboxEx1.HottrackColor := SCPopupColors15.SelectedColor;
  with TSCListColors(SCListboxEx1.Colors) do
  begin
    HighlightColor := SCPopupColors16.SelectedColor;
    HighlightTextColor := SCPopupColors17.SelectedColor;
  end;
end;

procedure TForm1.SCComboboxEx7Change(Sender: TObject);
var
  Flat: TSCSimpleCheckFlat;
begin
  Flat := scsfFlat;
  case SCComboboxEx7.ItemIndex of
    0: Flat := scsfDefault;
    1: Flat := scsfDoubleFlat;
    2: Flat := scsfFlat;
    3: Flat := scsfFlatEx;
  end;

  SCListboxEx1.Flat := Flat;
end;

procedure TForm1.SCComboboxEx8Change(Sender: TObject);
var
  I: Integer;
  C: TControl;
  BtnStyle: TSCButtonStyle;
begin
  BtnStyle := scbsWin2k;
  case SCComboboxEx8.ItemIndex of
    0: BtnStyle := scbsCorel;
    1: BtnStyle := scbsFlatMacSpeed;
    2: BtnStyle := scbsHower;
    3: BtnStyle := scbsMacSpeed;
    4: BtnStyle := scbsNew;
    5: BtnStyle := scbsOfficeXP;
    6: BtnStyle := scbsRaisedShadow;
    7: BtnStyle := scbsSpeed;
    8: BtnStyle := scbsWin2k;
    9: BtnStyle := scbsXP;
  end;

  for I := 0 to SCCheckbox5.Parent.ControlCount-1 do
  begin
    C := SCCheckbox5.Parent.Controls[I];
    if C is TSCButton then
      TSCButton(C).Style := BtnStyle;
  end;
end;

procedure TForm1.SCComboboxEx9Change(Sender: TObject);
var
  Cs: TSCCheckboxStyle;
begin
  Cs := sccsWin2k;
  case SCComboboxEx9.ItemIndex of
    0: Cs := sccsCorel;
    1: Cs := sccsFlat;
    2: Cs := sccsFlatEx;
    3: Cs := sccsFlatDouble;
    4: Cs := sccsMac;
    5: Cs := sccsOfficeXP;
    6: Cs := sccsWin2k;
    7: Cs := sccsXP;
  end;

  SCCheckbox7.Style := Cs;
end;

procedure TForm1.SCComboboxEx10Change(Sender: TObject);
var
  Cs: TSCRadioStyle;
begin
  Cs := scrsWin2k;
  case SCComboboxEx10.ItemIndex of
    0: Cs := scrsCorel;
    1: Cs := scrsFlat;
    2: Cs := scrsMac;
    3: Cs := scrsOfficeXP;
    4: Cs := scrsWin2k;
    5: Cs := scrsXP;
  end;

  SCRadioButton1.Style := Cs;
  SCRadioButton2.Style := Cs;

  SCRadioButton1.AsCheckbox := SCCheckbox8.Checked;
  SCRadioButton2.AsCheckbox := SCCheckbox8.Checked;
end;

procedure TForm1.SCComboboxEx11Change(Sender: TObject);
var
  Cb: TSCControlBorder;
begin
  Cb := sccb3DLowered;
  case SCComboboxEx11.ItemIndex of
    0: Cb := sccbNone;
    1: Cb := sccb3DLowered;
    2: Cb := sccb3DRaised;
    3: Cb := sccbBumped;
    4: Cb := sccbEtched;
    5: Cb := sccbFlat;
    6: Cb := sccbLowered;
    7: Cb := sccbRaised;
    8: Cb := sccbMacLowered;
    9: Cb := sccbMacRaised;
    10: Cb := sccbSoftLowered;
    11: Cb := sccbSoftRaised;
  end;

  TSCProgressBorderProps(SCProgress1.BorderProps).Border := Cb;
end;

procedure TForm1.SCComboboxEx12Change(Sender: TObject);
var
  Ps: TSCProgressStyle;
begin
  Ps := scpsClassic;
  case SCComboboxEx12.ItemIndex of
    0: Ps := scps3D;
    1: Ps := scpsClassic;
    2: Ps := scpsGradient3D;
    3: Ps := scpsGradientFull;
    4: Ps := scpsGradientComplementary;
    5: Ps := scpsRaised;
    6: Ps := scpsSliced;
    7: Ps := scpsSlicedGradient;
    8: Ps := scpsXP;
  end;

  SCProgress1.Style := Ps;
  SCProgress1.PositionColor := SCPopupColors18.SelectedColor;
  SCProgress1.PositionEndColor := SCPopupColors19.SelectedColor;
end;

procedure TForm1.SCTrackbar1Change(Sender: TObject);
begin
  SCProgress1.Position := SCTrackbar1.Position;
end;

procedure TForm1.SCComboboxEx13Change(Sender: TObject);
var
  Ss: TSCSpinButtonStyle;
begin
  Ss := scsbsWindows;
  case SCComboboxEx13.ItemIndex of
    0: Ss := scsbsOfficeXP;
    1: Ss := scsbsWindows;
    2: Ss := scsbsWindowsEx;
    3: Ss := scsbsWindowsFlat;
    4: Ss := scsbsWindowsFlatEx;
    5: Ss := scsbsMac;
    6: Ss := scsbsWindowsXP;
  end;

  SCSpinButton1.Style := Ss;
  SCSpinButton2.Style := Ss;
end;

procedure TForm1.SCComboboxEx14Change(Sender: TObject);
var
  Cb: TSCControlBorder;
begin
  Cb := sccb3DLowered;
  case SCComboboxEx14.ItemIndex of
    0: Cb := sccbNone;
    1: Cb := sccb3DLowered;
    2: Cb := sccb3DRaised;
    3: Cb := sccbBumped;
    4: Cb := sccbEtched;
    5: Cb := sccbFlat;
    6: Cb := sccbLowered;
    7: Cb := sccbRaised;
    8: Cb := sccbMacLowered;
    9: Cb := sccbMacRaised;
    10: Cb := sccbSoftLowered;
    11: Cb := sccbSoftRaised;
  end;

  TSCBorderProps(SCEdit1.BorderProps).Border := Cb;
end;

procedure TForm1.SCComboboxEx15Change(Sender: TObject);
var
  Cb: TSCControlBorder;
begin
  Cb := sccbNone;
  case SCComboboxEx15.ItemIndex of
    0: Cb := sccbNone;
    1: Cb := sccb3DLowered;
    2: Cb := sccb3DRaised;
    3: Cb := sccbBumped;
    4: Cb := sccbEtched;
    5: Cb := sccbFlat;
    6: Cb := sccbLowered;
    7: Cb := sccbRaised;
    8: Cb := sccbMacLowered;
    9: Cb := sccbMacRaised;
    10: Cb := sccbSoftLowered;
    11: Cb := sccbSoftRaised;
  end;

  TSCBorderProps(SCLabel1.BorderProps).Border := Cb;
  TSCBorderProps(SCPanel1.BorderProps).Border := Cb;
end;

procedure TForm1.SCPopupColors21SelectedColorChange(Sender: TObject);
begin
  SCLabel1.Color := SCPopupColors21.SelectedColor;
  SCLabel1.GradientMid := SCPopupColors22.SelectedColor;
  SCLabel1.GradientEnd := SCPopupColors20.SelectedColor;

  SCLabel1.GradientUsesMid := SCCheckbox9.Checked;

  SCPanel1.Color := SCPopupColors21.SelectedColor;
  SCPanel1.GradientMid := SCPopupColors22.SelectedColor;
  SCPanel1.GradientEnd := SCPopupColors20.SelectedColor;

  SCPanel1.GradientUsesMid := SCCheckbox9.Checked;
end;

procedure TForm1.SCComboboxEx16Change(Sender: TObject);
var
  G: TSCGradient;
begin
  G := scgNone;
  case SCComboboxEx16.ItemIndex of
    0: G := scgNone;
    1: G := scgLeftToRight;
    2: G := scgRightToLeft;
    3: G := scgTopToBottom;
    4: G := scgBottomToTop;
  end;

  SCLabel1.Gradient := G;
  SCPanel1.Gradient := G;
end;

procedure TForm1.SCPopupColors23SelectedColorChange(Sender: TObject);
begin
  SCLabel1.Hottrack := SCCheckbox10.Checked;
  SCLabel1.HottrackColor := SCPopupColors23.SelectedColor;
  SCLabel1.HighlightColor := SCPopupColors24.SelectedColor;
end;

procedure TForm1.SCCheckbox11Change(Sender: TObject);
begin
  SCPanel1.ShowStatusbar := SCCheckbox11.Checked;
  SCPanel1.ShowSizeGrip := SCCheckbox12.Checked;

  SCPanel1.StatusbarColor := SCPopupColors25.SelectedColor;
  SCPanel1.StatusbarText := SCEdit3.Text;

  TSCPanelPictureProps(SCPanel1.PictureProps).Visible := SCCheckbox13.Checked;
end;

procedure TForm1.SCComboboxEx17Change(Sender: TObject);
var
  Indx: Integer;
  Ss: TScTrackStyle;
  Cb: TSCControlBorder;
begin
  Cb := sccbNone;
  case SCComboboxEx17.ItemIndex of
    0: Cb := sccbNone;
    1: Cb := sccb3DLowered;
    2: Cb := sccb3DRaised;
    3: Cb := sccbBumped;
    4: Cb := sccbEtched;
    5: Cb := sccbFlat;
    6: Cb := sccbLowered;
    7: Cb := sccbRaised;
    8: Cb := sccbMacLowered;
    9: Cb := sccbMacRaised;
    10: Cb := sccbSoftLowered;
    11: Cb := sccbSoftRaised;
  end;

  TSCBorderProps(SCTrackbar2.BorderProps).Border := Cb;

  Ss := scthWindows;
  case SCComboboxEx18.ItemIndex of
    0: Ss := scthImage;
    1: Ss := scthMac;
    2: Ss := scthNew;
    3: Ss := scthPS;
    4: Ss := scthPSNew;
    5: Ss := scthWindows;
  end;

  SCTrackbar2.Slider.Style := Ss;

  Indx := SCComboboxEx19.ItemIndex;
  if Indx < 0 then Indx := 0;

  SCComboboxEx19.ImageIndex := Indx;
  SCTrackbar2.ImageIndex := Indx;
end;

procedure TForm1.SCComboboxEx20Change(Sender: TObject);
var
  Cb: TSCControlBorder;
  Ps: TScTrackProgressStyle;
begin
  Cb := sccb3DLowered;
  case SCComboboxEx21.ItemIndex of
    0: Cb := sccbNone;
    1: Cb := sccb3DLowered;
    2: Cb := sccb3DRaised;
    3: Cb := sccbBumped;
    4: Cb := sccbEtched;
    5: Cb := sccbFlat;
    6: Cb := sccbLowered;
    7: Cb := sccbRaised;
    8: Cb := sccbMacLowered;
    9: Cb := sccbMacRaised;
    10: Cb := sccbSoftLowered;
    11: Cb := sccbSoftRaised;
  end;

  Ps := sctpClassic;
  case SCComboboxEx20.ItemIndex of
    0: Ps := sctp3D;
    1: Ps := sctpClassic;
    2: Ps := sctpGradient3D;
    3: Ps := sctpGradientFull;
    4: Ps := sctpGradientComplementary;
    5: Ps := sctpRaised;
    6: Ps := sctpSliced;
    7: Ps := sctpSlicedGradient;
    8: Ps := sctpXP;
  end;

  SCTrackbar2.Progress.Border := Cb;
  SCTrackbar2.Progress.Style := Ps;
  SCTrackbar2.Progress.Color := SCPopupColors27.SelectedColor;
  SCTrackbar2.Progress.EndColor := SCPopupColors26.SelectedColor;
end;

procedure TForm1.SCPopupColors28SelectedColorChange(Sender: TObject);
begin
  with SCScrollbar1.BackColors do
  begin
    DefaultColor := SCPopupColors28.SelectedColor;
    ActiveColor := SCPopupColors29.SelectedColor;
    DownColor := SCPopupColors36.SelectedColor;
  end;

  with SCScrollbar1.ButtonColors do
  begin
    DefaultColor := SCPopupColors30.SelectedColor;
    ActiveColor := SCPopupColors31.SelectedColor;
    DownColor := SCPopupColors37.SelectedColor;
  end;

  with SCScrollbar1.ButtonIconColors do
  begin
    DefaultColor := SCPopupColors34.SelectedColor;
    ActiveColor := SCPopupColors35.SelectedColor;
    DownColor := SCPopupColors39.SelectedColor;
  end;

  with SCScrollbar1.ThumbColors do
  begin
    DefaultColor := SCPopupColors32.SelectedColor;
    ActiveColor := SCPopupColors33.SelectedColor;
    DownColor := SCPopupColors38.SelectedColor;
  end;

  with SCScrollbar2.BackColors do
  begin
    DefaultColor := SCPopupColors28.SelectedColor;
    ActiveColor := SCPopupColors29.SelectedColor;
    DownColor := SCPopupColors36.SelectedColor;
  end;

  with SCScrollbar2.ButtonColors do
  begin
    DefaultColor := SCPopupColors30.SelectedColor;
    ActiveColor := SCPopupColors31.SelectedColor;
    DownColor := SCPopupColors37.SelectedColor;
  end;

  with SCScrollbar2.ButtonIconColors do
  begin
    DefaultColor := SCPopupColors34.SelectedColor;
    ActiveColor := SCPopupColors35.SelectedColor;
    DownColor := SCPopupColors39.SelectedColor;
  end;

  with SCScrollbar2.ThumbColors do
  begin
    DefaultColor := SCPopupColors32.SelectedColor;
    ActiveColor := SCPopupColors33.SelectedColor;
    DownColor := SCPopupColors38.SelectedColor;
  end;
end;

procedure TForm1.SCComboboxEx22Change(Sender: TObject);
var
  Ss: TSCScrollbarStyle;
  Tl: TSCScrollThumbline;
begin
  Ss := scssDefault;
  case SCComboboxEx22.ItemIndex of
    0: Ss := scssDefault;
    1: Ss := scssDefaultEx;
    2: Ss := scssFlat;
    3: Ss := scssFlatEx;
    4: Ss := scssOffice2k;
    5: Ss := scssXP;
    6: Ss := scssXP2;
    7: Ss := scss3D;
    8: Ss := scss3DX;
    9: Ss := TSCScrollbarStyle.scssNew;
    10: Ss := scssNewX;
    11: Ss := scssMac;
    12: Ss := scssSports;
  end;

  Tl := sctlRised;
  case SCComboboxEx23.ItemIndex of
    0: Tl := sctlNone;
    1: Tl := sctlLowered;
    2: Tl := sctlRised;
  end;

  SCScrollbar1.Style := Ss;
  SCScrollbar1.ThumbLines := Tl;

  SCScrollbar2.Style := Ss;
  SCScrollbar2.ThumbLines := Tl;
end;

procedure TForm1.SCComboboxEx24Change(Sender: TObject);
var
  Bs: TSCButtonSetStyle;
  Ps: TSCButtonSetPaintStyle;
begin
  Ps := scbpsNew;
  case SCComboboxEx24.ItemIndex of
    0: Ps := scbpsDefault;
    1: Ps := scbpsFlat;
    2: Ps := scbpsMac;
    3: Ps := scbpsMacSquare;
    4: Ps := scbpsMacDefault;
    5: Ps := scbpsMacSpeed;
    6: Ps := scbpsNew;
    7: Ps := scbpsOfficeXP;
    8: Ps := scbpsSpeed;
    9: Ps := scbpsXP;
  end;

  SCButtonSet1.PaintStyle := Ps;

  Bs := scbsDefault;
  case SCComboboxEx25.ItemIndex of
    0: Bs := scbsDefault;
    1: Bs := scbsChecked;
    2: Bs := scbsRadio;
  end;

  SCButtonSet1.Style := Bs;
end;

procedure TForm1.SCComboboxEx26Change(Sender: TObject);
var
  Cl: TColor;
  I: Integer;
  Ts: TSCTabsetStyle;
begin
  Ts := sctsWindows;
  case SCComboboxEx26.ItemIndex of
    0: Ts := sctsDotNet;
    1: Ts := sctsMac;
    2: Ts := sctsWindows;
    3: Ts := sctsWinXP;
    4: Ts := sctsOfficeXP;
  end;

  SCTabset1.Style := Ts;
  SCTabset1.ButtonVisible := SCCheckbox14.Checked;
  SCTabset1.FlatButton := SCCheckbox22.Checked;

  SCTabset1.SelectedColor := SCPopupColors41.SelectedColor;
  SCTabset1.ButtonColor := SCPopupColors42.SelectedColor;
  SCTabset1.ScrollerColor := SCPopupColors43.SelectedColor;
  SCTabset1.ScrollArrowColor := SCPopupColors44.SelectedColor;

  Cl := SCPopupColors40.SelectedColor;
  SCTabset1.Color := Cl;

  for I := 0 to SCTabset1.Tabs.Count-1 do
    SCTabset1.Tabs[I].Color := Cl;
end;

procedure TForm1.SCComboboxEx27Change(Sender: TObject);
var
  I: Integer;
  Cl: TColor;
  Bv: TSCHeaderColBevel;
begin
  Bv := schbWinXP;
  case SCComboboxEx27.ItemIndex of
    0: Bv := schbNone;
    1: Bv := schbRaised;
    2: Bv := schbFlat;
    3: Bv := schb3DRaised;
    4: Bv := schbSpace;
    5: Bv := schbMac;
    6: Bv := schbWinXP;
  end;

  SCHeader1.ClientBevel := Bv;
  SCHeader1.DefaultBevel := Bv;

  SCHeader1.ArrowColor := SCPopupColors47.SelectedColor;
  SCHeader1.HotTrackFontColor := SCPopupColors46.SelectedColor;

  Cl := SCPopupColors45.SelectedColor;

  SCHeader1.Color := Cl;
  for I := 0 to SCHeader1.Columns.Count-1 do
    SCHeader1.Columns[I].Color := Cl;
end;

procedure TForm1.SCComboboxEx28Change(Sender: TObject);
var
  I: Integer;
  Bs: TSCBarStyle;
  Cb: TSCStatusPanelBevel;
begin
  Bs := scbsStatusWindows;
  case SCComboboxEx28.ItemIndex of
    0: Bs := scbsStatusWindows;
    1: Bs := scbsStatusMac;
    2: Bs := scbsStatusXP;
  end;

  SCStatusBar2.Style := Bs;

  Cb := scpbLowered;
  case SCComboboxEx29.ItemIndex of
    0: Cb := scpbNone;
    1: Cb := scpbLowered;
    2: Cb := scpbRaised;
    3: Cb := scpbFlat;
    4: Cb := scpb3DLowered;
    5: Cb := scpb3DRaised;
  end;

  for I := 0 to SCStatusBar2.Panels.Count-1 do
    SCStatusBar2.Panels[I].Bevel := Cb;
end;

procedure TForm1.SCListGroup1ItemClick(Sender: TObject; AItem: Integer);
begin
  case AItem of
    0, 1:
      Notebook1.PageIndex := 0;
    2..6:
      Notebook1.PageIndex := 1;
    7:
      Notebook1.PageIndex := 2;
    8:
      Notebook1.PageIndex := 3;
    9, 10:
      Notebook1.PageIndex := 4;
    11, 12:
      Notebook1.PageIndex := 5;
    13, 14:
      Notebook1.PageIndex := 6;
  end;
end;

end.
