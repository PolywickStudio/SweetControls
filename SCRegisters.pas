{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCRegisters;

{$I SweetControls.inc}

interface

uses
  {$IFDEF SC_DELPHI6_UP} Types, DesignEditors, DesignIntf {$ELSE}
  TypInfo, DsgnIntf {$ENDIF};

procedure Register;

implementation

{$R *.dcr}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Extctrls, ImgList, StdActns, ActnList, Menus, SCConsts, SCPropertyEditors,
  SCCommon, SCControl, SCStdControls, SCEdits, SCMaskEdit, SCAdvEdits,
  SCSpinEdits, SCHotkeyEdit, SCSimpleListbox, SCExtControls, SCTabSet,
  SCTrackbar, SCPanels, SCButtonSet, SCStatusBar, SCScrollbars, SCFontsAndColors,
  SCColorControls, SCColorbox, SCPopupColors, SCImageBox, SCDateTimeControls,
  SCSplitter, SCStyleController, SCVirtualListBox, SCVirtualCombobox, SCDbCtrls,
  SCDbEdits, SCDbExtCtrls, SCLinkedControls, SCRadioGroup, SCCheckGroup,
  SCDbNavButton, SCGraphicButton, SCCalculator, SCDBCommon, SCLookups,
  SCTreeList, SCPageControl, SCInstrumentation, SCScrollbox, SCStaticEdit,
  SCInputs, SCNavBar;

procedure Register;
begin
  RegisterComponentEditor(TSCCustomControl, TSCAboutEditor);
  RegisterComponentEditor(TSCCustomControl, TSCLoadSaveEditor);

  RegisterComponentEditor(TSCPictureList, TSCPictureListItemsEditor);
  RegisterComponentEditor(TSCSimpleListbox, TSCSimpleListboxItemsEditor);
  RegisterComponentEditor(TSCCustomListboxEx, TSCListboxExItemEditor);
  RegisterComponentEditor(TSCTabset, TSCTabsetTabEditor);
  RegisterComponentEditor(TSCHeader, TSCHeaderColumnEditor);
  RegisterComponentEditor(TSCButtonSet, TSCButtonSetButtonEditor);
  RegisterComponentEditor(TSCStatusBar, TSCStatusBarPanelEditor);
  RegisterComponentEditor(TSCListGroup, TSCListGroupItemEditor);
  RegisterComponentEditor(TSCCustomComboboxEx, TSCComboboxExItemEditor);
  RegisterComponentEditor(TSCStaticEdit, TSCStaticEditItemEditor);
  RegisterComponentEditor(TSCCombobox, TSCComboboxItemEditor);
  RegisterComponentEditor(TSCCustomImageBox, TSCImageBoxPictureEditor);
  RegisterComponentEditor(TSCRadioGroup, TSCRadioGroupButtonEditor);
  RegisterComponentEditor(TSCCheckGroup, TSCCheckGroupButtonEditor);
  RegisterComponentEditor(TSCMeter, TSCMeterSegmentEditor);
  RegisterComponentEditor(TSCTabControl, TSCTabControlEditor);
  RegisterComponentEditor(TSCCustomPageControl, TSCPageControlEditor);
  RegisterComponentEditor(TSCTabSheet, TSCPageControlEditor);
  RegisterComponentEditor(TSCTreeList, TSCTreeListEditor);

  RegisterComponentEditor(TSCNavBarControl, TSCNavBarControlEditor);
  RegisterComponentEditor(TSCNavTabControl, TSCNavTabControlEditor);
  RegisterComponentEditor(TSCNavBarSheet, TSCNavBarControlEditor);

  RegisterPropertyEditor(TypeInfo(TSCAboutString), TSCCustomControl,
    'About', TSCAboutProperty);

  RegisterPropertyEditor(TypeInfo(Integer), TSCCustomControl,
    'PictureIndex', TSCPictureIndexProperty);
  RegisterPropertyEditor(TypeInfo(Integer), TSCCustomPictureProps,
    'PictureIndex', TSCPictureIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCustomControl,
    'ImageIndex', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCGraphicControl,
    'ImageIndex', TSCGraphicControlImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCustomEdit,
    'PasswordImage', TSCImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(string), TSCCustomMaskEdit,
    'EditMask', TSCEditMaskProperty);
  RegisterPropertyEditor(TypeInfo(string), TSCMaskEdit, 'Text',
    TSCEditMaskInputProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCustomSpinnerEdit,
    'ButtonDownImage', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCustomSpinnerEdit,
    'ButtonUpImage', TSCImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckbox,
    'ImageChecked', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckbox,
    'ImageDisabled', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckbox,
    'ImageGrayed', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckbox,
    'ImageToggle', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckbox,
    'ImageUnchecked', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckbox,
    'ImageMark', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckbox,
    'ImageMarkGrayed', TSCImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCRadioButton,
    'ImageChecked', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCRadioButton,
    'ImageDisabled', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCRadioButton,
    'ImageToggle', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCRadioButton,
    'ImageUnchecked', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCRadioButton,
    'ImageMark', TSCImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckGroup,
    'ImageChecked', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckGroup,
    'ImageDisabled', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckGroup,
    'ImageGrayed', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckGroup,
    'ImageToggle', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckGroup,
    'ImageUnchecked', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckGroup,
    'ImageMark', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCheckGroup,
    'ImageMarkGrayed', TSCImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCRadioGroup,
    'ImageChecked', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCRadioGroup,
    'ImageDisabled', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCRadioGroup,
    'ImageToggle', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCRadioGroup,
    'ImageUnchecked', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCRadioGroup,
    'ImageMark', TSCImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCalendar,
    'ImageHighlight', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCalendar,
    'ImageSelection', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCalendar,
    'ImageToday', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCalendar,
    'NavigatorLeft', TSCImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCCalendar,
    'NavigatorRight', TSCImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCLabel, 'HotImage',
    TSCImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCListboxExItem,
   'ImageIndex', TSCListboxExItemImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCComboboxExItem,
    'ImageIndex', TSCComboboxExItemImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCAdvGroupCaption,
    'Icon', TSCAdvGroupCaptionIconIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCAdvGroupCaption,
    'CloseButton', TSCAdvGroupCaptionImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCAdvGroupCaption,
    'DownButton', TSCAdvGroupCaptionImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCAdvGroupCaption,
    'UpButton', TSCAdvGroupCaptionImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCListGroupStyle,
    'ImageIndex', TSCLGroupStyleImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCListGroupStyle,
    'LargeImageIndex', TSCLGroupStyleLargeImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCListGroupItem,
    'ImageIndex', TSCLGroupItemImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCListGroupItem,
    'LargeImageIndex', TSCLGroupItemLargeImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCListGroupScroller,
    'ImageDefault', TSCLGroupScrollerImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCListGroupScroller,
    'ImageDisabled', TSCLGroupScrollerImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCListGroupScroller,
    'ImageHot', TSCLGroupScrollerImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCListGroupScroller,
    'ImagePressed', TSCLGroupScrollerImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCAdvGroupCaption,
    'Icon', TSCAdvGroupCaptionIconIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCEditButton,
    'Image', TSCEditButtonImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCPopupbox,
    'ButtonImage', TSCImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCTreeColumn,
    'ImageIndex', TSCTreeColumnImageIndexProperty);

  RegisterPropertyEditor(TypeInfo(String), TSCCustomDBLookupData,
    'DataField', TSCDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(String), TSCCustomDBLookupData,
    'KeyField', TSCListFieldProperty);
  RegisterPropertyEditor(TypeInfo(String), TSCCustomDBLookupData,
    'ListField', TSCListFieldProperty);

  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCNavTabItem,
    'LargeImageIndex', TSCNavTabLargeImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSCNavBarSheet,
    'LargeImageIndex', TSCNavBarSheetLargeImageIndexProperty);

  RegisterComponents('Sweet Standard', [TSCLabel, TSCEdit, TSCMemo, TSCButton,
    TSCCheckBox, TSCRadioButton, TSCSimpleListbox, TSCPanel, TSCProgress,
    TSCSpinButton, TSCScrollbar, TSCGroupBox, TSCTrackbar, TSCButtonSet,
    TSCTabset, TSCHeader, TSCStatusBar, TSCControlSizer]);

  RegisterComponents('Sweet Additional', [TSCSpeedButton, TSCPictureList,
    TSCImageBox, TSCScrollbox, TSCMaskEdit, TSCCheckGroup, TSCRadioGroup,
    TSCListboxEx, TSCVirtualListbox, TSCComboboxEx, TSCVirtualCombobox,
    TSCCalendar, TSCSplitter, TSCBevel, TSCCalculator, TSCPictureLister,
    TSCImageLister, TSCTabControl, TSCPageControl, TSCStaticEdit,
    TSCSlider, TSCTreeList, TSCNavTabControl, TSCNavBarControl,
    TSCNavPanel ]);

  RegisterComponents('Sweet Edits', [TSCFrameEdit, TSCCombobox, TSCPopupbox,
    TSCButtonEdit, TSCHyperlinkEdit, TSCHotkeyEdit, TSCNavEdit, TSCSpinnerEdit,
    TSCIntSpinEdit, TSCFloatSpinEdit, TSCCurrencySpinEdit, TSCTimeEdit,
    TSCPopupCalendar, TSCPopupColors, TSCPopupCalculator, TSCIPInput,
    TSCTimeInput, TSCDateInput ]);

  RegisterComponents('Sweet Data Controls', [TSCDBLabel, TSCDBEdit, TSCDBMemo,
    TSCNavButton, TSCDBButtonEdit, TSCDBHyperlinkEdit, TSCDBIntSpinEdit,
    TSCDBFloatSpinEdit, TSCDBSpinnerEdit, TSCDBCurrencySpinEdit, TSCDBCheckBox,
    TDBSCRadioGroup, TSCDBComboBox, TSCDBComboboxEx, TSCDBListBox, TSCDBListBoxEx,
    TSCDBImage, TSCDBPopupCalendar, TSCDBTimeEdit, TSCDBPopupCalculator, TSCDBProgress,
    TSCDBTrackbar, TSCDBScrollbar, TSCDBLookupListbox, TSCDBLookupComboBox ]);

  RegisterComponents('Sweet Instrumentation', [TSCMeter, TSCMarixDisplay,
    TSCSevenSegment, TSCHistoryGraph, TSCSwitch, TSCRunningLeds ]);

  RegisterComponents('Sweet Panels', [TSCGroupContainer, TSCAdvPanel,
    TSCListGroup, TSCListGroupStyle ]);

  RegisterComponents('Sweet Fonts && Colors', [TSCFontListbox, TSCFontCombobox,
    TSCColorListbox, TSCColorCombobox, TSCFontSizeListbox, TSCFontSizeCombobox,
    TSCFontCharsetListbox, TSCFontCharsetCombobox, TSCBrushStyleListbox,
    TSCBrushStyleCombobox, TSCPenStyleListbox, TSCPenStyleCombobox,
    TSCPenModeListbox, TSCPenModeCombobox ]);

  RegisterComponents('Sweet Colors', [TSCColorbox, TSCColorPalette,
    TSCColorSelectBox, TSCColorSelector, TSCColorGradient, TSCHSVGradient,
    TSCHueSlider, TSCLumSlider, TSCRGBRoller, TSCRGBSlider ]);
end;

end.
