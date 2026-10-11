{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCConsts;

{$I SweetControls.inc}

{$P+,S-,W-,R-,T-,X+,H+}
{$C PRELOAD}

interface

uses
  Windows, SysUtils, Classes, Messages, Graphics;

type
  {$IFDEF SC_DELPHI4_AND_EARLY}
    TImageIndex = Integer;
  {$ENDIF}

  TSCAboutString = String;

  TSCImageLayout = (scilBottom, scilLeft, scilRight, scilTop);
  TSCEditLayout = (scelBottom, scelCenter, scelTop);

  TSCLayout = (sclaBottom, sclaMiddle, sclaTop);
  TSCRotation = (scroLeft, scroRight, scroTop);

  TSCEllipsis = (scelNone, scelEndEllipsis, scelPathEllipsis);

  TSCButtonStyle = (scbsCorel, scbsDarkling, scbsFlatMacSpeed, scbsHower,
    scbsMacSpeed, scbsMetal, scbsNew, scbsOfficeXP, scbsOffice12,
    scbsOffice2003, scbsRaisedShadow, scbsSpeed, scbsWin2k, scbsXP);

  TSCButtonGradient = (scbgLeftToRight, scbgTopToBottom);
  TSCButtonLayout = (scblBottom, scblLeft, scblRight, scblTop);

  TSCCheckState = (sccbUnchecked, sccbChecked, sccbGrayed);
                                     
  TSCSimpleCheckFlat = (scsfDefault, scsfDoubleFlat, scsfFlat, scsfFlatEx);

  TSCArrowKeys = set of 0..255;

  TSCBevelWidth = 0..MaxInt;

  TSCBorder = (sccbNone, sccb3DRaised, sccb3DLowered, sccbRaised, sccbLowered,
    sccbBumped, sccbEtched, sccbMacLowered, sccbMacRaised, sccbMetal,
    sccbSoftLowered, sccbSoftRaised, sccbColor, sccbFlat, sccbFlatBold,
    sccbFlatRounded, sccbFlatBoldRounded);

  TSCControlBevel = TSCBorder;

  TSCControlBorder = sccbNone..sccbFlatBold;

  TSCBorderEdge = (scbeLeft, scbeRight, scbeTop, scbeBottom);

  TSCBorderEdges = set of TSCBorderEdge;

  TSCPictureOrient = (scpoTopLeft, scpoTopRight, scpoBottomLeft,
    scpoBottomRight, scpoCenter, scpoTiled);

  TSCGroupBoxAlignment = (scgaTopLeft, scgaTopCenter, scgaTopRight,
    scgaBottomLeft, scgaBottomCenter, scgaBottomRight, scgaLeftTop,
    scgaLeftCenter, scgaLeftBottom, scgaRightTop, scgaRightCenter,
    scgaRightBottom, scgaCenter);

  TSCScrollButtonLayout = (scsbDefault, scsbLeftTop, scsbRightBottom);

  TSCScrollbarKind = (scskHorizontal, scskVertical);

  TSCScrollbarHitKind = (scshkNone, scshkHorizontal, scshkVertical);
  TSCScrollerHitPart = (scspNone, scspLeftSpare, scspRightSpare, scspThumb,
    scspExtraButton, scspLeftButton, scspRightButton);

  TSCScrollbarInc = 1..32767;

  TSCScrollbarType = (scsbtDefault, scsbtSweet);

  TSCScrollbarStyle = (scssDefault, scssDefaultEx, scssFlat, scssFlatEx,
    scssFlatHover, scssOffice12, scssOffice2k, scssMetal, scssXP, scssXP2,
    scss3D, scss3DX, scssNew, scssNewX, scssMac, scssSports);

  TSCScrollThumbline = (sctlNone, sctlLowered, sctlRised, sctlDots, sctlDash,
    sctlWideDash);

  TSCMonth = (scmJanuary, scmFebruary, scmMarch, scmApril, scmMay, scmJune,
    scmJuly, scmAugust, scmSeptember, scmOctober, scmNovember, scmDecember);

  TSCMonths = set of TSCMonth;

  TSCDay = (scdMonday, scdTuesday, scdWednesday, scdThursday, scdFriday,
    scdSaturday, scdSunday);

  TSCDays = set of TSCDay;

  TSCTimeValidation = (sctvSetToNow, sctvDontUpdate, sctvRaiseError);
  TSCDateValidation = (scdvSetToNull, scdvSetToToday, scdvDontUpdate, scdvRaiseError);

  TSCNavigateType = (scntFirst, scntPrior, scntNext, scntLast, scntAppend,
    scntInsert, scntDelete, scntEdit, scntPost, scntCancel, scntRefresh);
    
  TSCNavigateTypes = set of TSCNavigateType;

  TSCNavButtonRec = record
    NavType: TSCNavigateType;
    Caption: String;
    Hint: String;
  end;

  TSCNoneColorStyle = (scncNone, scnsSolidColor, scncDiagonal, scncDiagonalCross);
  
  TSCScrollEvent = procedure(Sender: TObject; Kind: TSCScrollbarKind;
    CurPos: Integer; var ScrollPos: Integer; var CanScroll: Boolean) of object;

  TSCDuplicates = (scdpIgnore, scdpAccept, scdpError);
    
var
  scNegativeSign: Char = '-';
  scNegativeFormat: Byte = 1;
  scNegativeCurFormat: Byte = 1;
  scDefaultLCID: LCID;
  scSystemLCID: LCID;
  scSysDecimalSeparator: Char = '.';
  scCurThousandSeparator: Char = ',';
  scCurDecimalSeparator: Char = '.';

const
  SC_VersionStr = 'CA SweetControls v4.200';

  scNavButtons: TSCNavigateTypes = [scntFirst, scntPrior, scntNext, scntLast,
    scntAppend, scntInsert, scntDelete, scntEdit, scntPost, scntCancel, scntRefresh];

  SC_BUTTON_REPEATTIMERID = 4321;
  SC_TAB_REPEATTIMERID = 54321;
  SC_TAB_REPEATTIME = 80; 
  SC_HTBASE = $0500;

  SC_HTNONE            = SC_HTBASE;
  SC_HTOUTTERBORDER    = SC_HTBASE +  1;
  SC_HTBORDER          = SC_HTBASE +  2;
  SC_HTINNERBORDER     = SC_HTBASE +  3;

  SC_HTSTATUSBAR       = SC_HTBASE +  4;
  SC_HTSIZEGRIP        = SC_HTBASE +  5;

  SC_HTHSCROLLBAR      = SC_HTBASE +  6;
  SC_HTHSB_EXTRABTN    = SC_HTBASE +  7;
  SC_HTHSB_LEFTBTN     = SC_HTBASE +  8;
  SC_HTHSB_RIGHTBTN    = SC_HTBASE +  9;
  SC_HTHSB_THUMB       = SC_HTBASE + 10;
  SC_HTHSB_LEFTSPARE   = SC_HTBASE + 11;
  SC_HTHSB_RIGHTSPARE  = SC_HTBASE + 12;

  SC_HTVSCROLLBAR      = SC_HTBASE + 13;
  SC_HTVSB_EXTRABTN    = SC_HTBASE + 14;
  SC_HTVSB_LEFTBTN     = SC_HTBASE + 15;
  SC_HTVSB_RIGHTBTN    = SC_HTBASE + 16;
  SC_HTVSB_THUMB       = SC_HTBASE + 17;
  SC_HTVSB_LEFTSPARE   = SC_HTBASE + 18;
  SC_HTVSB_RIGHTSPARE  = SC_HTBASE + 19;
  

  CM_SCMESSAGEBASE   = WM_APP + 1919;
  CM_SCDROPDOWNPOPUP = CM_SCMESSAGEBASE + 1;
  CM_SCJUMPTONEXT    = CM_SCMESSAGEBASE + 2;
  CM_SCISVISIBLECHILD = CM_SCMESSAGEBASE + 3;

  SCAllBorderEdges = [scbeLeft, scbeRight, scbeTop, scbeBottom];

  SCMonthArray: array[0..11] of TSCMonth = (scmJanuary, scmFebruary, scmMarch,
    scmApril, scmMay, scmJune, scmJuly, scmAugust, scmSeptember, scmOctober,
    scmNovember, scmDecember);

  SCDay: array[0..6] of TSCDay = (scdMonday, scdTuesday, scdWednesday, scdThursday,
    scdFriday, scdSaturday, scdSunday);

  SC_MenuUndo   = 100;
  SC_MenuRedo   = 101;
  SC_MenuCopy   = 102;
  SC_MenuCut    = 103;
  SC_MenuPaste  = 104;
  SC_MenuDelete = 105;
  SC_MenuSelectAll = 106;

  SC_HighlightColor = $00FCA070;
  SC_HottrackColor  = $0000ACFF;
  SC_AlertColor     = $00A8A8FF;
  SC_FlashColor     = $0063CFFE;

  { operating system (OS)constants }
  cOsUnknown  = -1;
  cOsBelow95  =  0;
  cOsWin95    =  1;
  cOsWin98    =  2;
  cOsWin98SE  =  3;
  cOsWinME    =  4;
  cOsWinNT    =  5;
  cOsWin2000  =  6;
  cOsXP       =  7;
  cOsOverXP   =  8;

var
  scCurrentOperatingSystem: Integer = cOsUnknown;

const
  scPenModes: array[TPenMode] of Word =
    (R2_BLACK, R2_WHITE, R2_NOP, R2_NOT, R2_COPYPEN, R2_NOTCOPYPEN, R2_MERGEPENNOT,
     R2_MASKPENNOT, R2_MERGENOTPEN, R2_MASKNOTPEN, R2_MERGEPEN, R2_NOTMERGEPEN,
     R2_MASKPEN, R2_NOTMASKPEN, R2_XORPEN, R2_NOTXORPEN);

  SCArrowKeys: TSCArrowKeys = [VK_UP, VK_LEFT, VK_DOWN, VK_RIGHT,
    VK_PRIOR, VK_NEXT, VK_END, VK_HOME];

  { Panel colors }
  clPanelDisabledColor = $00A8A8A8;
  clPanelDownColor     = $00C65577;
  clPanelHotColor      = $00F04B0D;
  clExplorerColor      = $00E4DBD6;
  clExplorerBackColor  = $00C6A39B;
  clIconDownColor      = $00C65577;
  clIconHotColor       = $00F04B0D;
  clAdvXPBarColor      = $00F8DED8;
  clAdvXPGrpStartColor = $00E6A080;
  clAdvXPGrpEndColor   = $00AA4628;

  { Web colors }
  clAliceBlue            = $FFF8F0;
  clAntiqueWhite         = $D7EBFA;
  clAqua                 = $FFFF00;
  clAquamarine           = $D4FF7F;
  clAzure                = $FFFFF0;
  clBeige                = $DCF5F5;
  clBisque               = $C4E4FF;
  clBlanchedAlmond       = $CDEBFF;
  clBlueViolet           = $E22B8A;
  clBurlyWood            = $87B8DE;
  clCadetBlue            = $A09E5F;
  clChartreuse           = $00FF7F;
  clChocolate            = $1E69D2;
  clCoral                = $507FFF;
  clCornflowerBlue       = $ED9564;
  clCornsilk             = $DCF8FF;
  clCrimson              = $3C14DC;
  clCyan                 = $FFFF00;
  clDarkBlue             = $8B0000;
  clDarkCyan             = $8B8B00;
  clDarkGoldenrod        = $0B86B8;
  clDarkGray             = $A9A9A9;
  clDarkGreen            = $006400;
  clDarkKhaki            = $6BB7BD;
  clDarkMagenta          = $8B008B;
  clDarkOliveGreen       = $2F6B55;
  clDarkOrange           = $008CFF;
  clDarkOrchid           = $CC3299;
  clDarkRed              = $00008B;
  clDarkSalmon           = $7A96E9;
  clDarkSeaGreen         = $8BBC8F;
  clDarkSlateBlue        = $8B3D48;
  clDarkSlateGray        = $4F4F2F;
  clDarkTurquoise        = $D1CE00;
  clDarkViolet           = $D30094;
  clDeepPink             = $9314FF;
  clDeepSkyBlue          = $FFBF00;
  clDimGray              = $696969;
  clDodgerBlue           = $FF901E;
  clFirebrick            = $2222B2;
  clFloralWhite          = $F0FAFF;
  clForestGreen          = $228B22;
  clGainsboro            = $DCDCDC;
  clGhostWhite           = $FFF8F8;
  clGold                 = $00D7FF;
  clGoldenrod            = $20A5DA;
  clGreenYellow          = $2FFFAD;
  clHoneydew             = $F0FFF0;
  clHotPink              = $B469FF;
  clIndianRed            = $5C5CCD;
  clIndigo               = $82004B;
  clIvory                = $F0FFFF;
  clKhaki                = $8CE6F0;
  clLavender             = $FAE6E6;
  clLavenderBlush        = $F5F0FF;
  clLawnGreen            = $00FC7C;
  clLemonChiffon         = $CDFAFF;
  clLightBlue            = $E6D8AD;
  clLightCoral           = $8080F0;
  clLightCyan            = $FFFFE0;
  clLightGoldenrodYellow = $D2FAFA;
  clLightGray            = $D3D3D3;
  clLightGreen           = $90EE90;
  clLightPink            = $C1B6FF;
  clLightSalmon          = $7AA0FF;
  clLightSeaGreen        = $AAB220;
  clLightSkyBlue         = $FACE87;
  clLightSlateGray       = $998877;
  clLightSteelBlue       = $DEC4B0;
  clLightYellow          = $E0FFFF;
  clLimeGreen            = $32CD32;
  clLinen                = $E6F0FA;
  clMagenta              = $FF00FF;
  clMediumAquamarine     = $AACD66;
  clMediumBlue           = $CD0000;
  clMediumOrchid         = $D355BA;
  clMediumPurple         = $DB7093;
  clMediumSeaGreen       = $71B33C;
  clMediumSlateBlue      = $EE687B;
  clMediumSpringGreen    = $9AFA00;
  clMediumTurquoise      = $CCD148;
  clMediumVioletRed      = $8515C7;
  clMidnightBlue         = $701919;
  clMintCream            = $FAFFF5;
  clMistyRose            = $E1E4FF;
  clMoccasin             = $B5E4FF;
  clNavajoWhite          = $ADDEFF;
  clOldLace              = $E6F5FD;
  clOliveDrab            = $238E6B;
  clOrange               = $00A5FF;
  clOrangeRed            = $0045FF;
  clOrchid               = $D670DA;
  clPaleGoldenrod        = $AAE8EE;
  clPaleGreen            = $98FB98;
  clPaleTurquoise        = $EEEEAF;
  clPaleVioletRed        = $9370DB;
  clPapayaWhip           = $D5EFFF;
  clPeachPuff            = $B9DAFF;
  clPeru                 = $3F85CD;
  clPink                 = $CBC0FF;
  clPlum                 = $DDA0DD;
  clPowderBlue           = $E6E0B0;
  clRosyBrown            = $8F8FBC;
  clRoyalBlue            = $E16941;
  clSaddleBrown          = $13458B;
  clSalmon               = $7280FA;
  clSandyBrown           = $60A4F4;
  clSeaGreen             = $578B2E;
  clSeaShell             = $EEF5FF;
  clSienna               = $2D52A0;
  clSkyBlue              = $EBCE87;
  clSlateBlue            = $CD5A6A;
  clSlateGray            = $908070;
  clSnow                 = $FAFAFF;
  clSpringGreen          = $7FFF00;
  clSteelBlue            = $B48246;
  clTan                  = $8CB4D2;
  clThistle              = $D8BFD8;
  clTomato               = $4763FF;
  clTurquoise            = $D0E040;
  clViolet               = $EE82EE;
  clWheat                = $B3DEF5;
  clWhiteSmoke           = $F5F5F5;
  clYellowGreen          = $32CD9A;

  scBrushStyleMap: array[0..7] of TIdentMapEntry = (
    (Value: Integer(bsSolid); Name: 'Solid'),
    (Value: Integer(bsClear); Name: 'Clear'),
    (Value: Integer(bsHorizontal); Name: 'Horizontal'),
    (Value: Integer(bsVertical); Name: 'Vertical'),
    (Value: Integer(bsFDiagonal); Name: 'FDiagonal'),
    (Value: Integer(bsBDiagonal); Name: 'BDiagonal'),
    (Value: Integer(bsCross); Name: 'Cross'),
    (Value: Integer(bsDiagCross); Name: 'DiagCross'));

  scPenStyleMap: array[0..6] of TIdentMapEntry = (
    (Value: Integer(psSolid); Name: 'Solid'),
    (Value: Integer(psDash); Name: 'Dash'),
    (Value: Integer(psDot); Name: 'Dot'),
    (Value: Integer(psDashDot); Name: 'DashDot'),
    (Value: Integer(psDashDotDot); Name: 'DashDotDot'),
    (Value: Integer(psClear); Name: 'Clear'),
    (Value: Integer(psInsideFrame); Name: 'InsideFrame'));

  scPenModeMap: array[0..15] of TIdentMapEntry = (
    (Value: Integer(pmBlack); Name: 'Black'),
    (Value: Integer(pmWhite); Name: 'White'),
    (Value: Integer(pmNop); Name: 'Nop'),
    (Value: Integer(pmNot); Name: 'Not'),
    (Value: Integer(pmCopy); Name: 'Copy'),
    (Value: Integer(pmNotCopy); Name: 'NotCopy'),
    (Value: Integer(pmMergePenNot); Name: 'MergePenNot'),
    (Value: Integer(pmMaskPenNot); Name: 'MaskPenNot'),
    (Value: Integer(pmMergeNotPen); Name: 'MergeNotPen'),
    (Value: Integer(pmMaskNotPen); Name: 'MaskNotPen'),
    (Value: Integer(pmMerge); Name: 'Merge'),
    (Value: Integer(pmNotMerge); Name: 'NotMerge'),
    (Value: Integer(pmMask); Name: 'Mask'),
    (Value: Integer(pmNotMask); Name: 'NotMask'),
    (Value: Integer(pmXor); Name: 'Xor'),
    (Value: Integer(pmNotXor); Name: 'NotXor'));

  { Color Palette Shemes }
  scGrays_C: array[1..8] of TColor = (
     $FFFFFF, $CCCCCC, $C0C0C0, $999999, $808080, $666666, $333333, $000000);

  sc16_C : array [0..15] of TColor = (
    $FFFFFF, $FFFF00, $FF00FF, $FF0000, $00FFFF, $00FF00, $0000FF, $C0C0C0, $808080, $808000,
    $800080, $800000, $008080, $008000, $000080, $000000);

  scWin256_C : array [0..255] of TColor = (
    $FFFFFF, $FFFF00, $FF00FF, $FF0000, $00FFFF, $00FF00, $0000FF, $808080, $A4A0A0, $F0FBFF,
    $F8F8F8, $F1F1F1, $EAEAEA, $E3E3E3, $DDDDDD, $D7D7D7, $B2B2B2, $CBCBCB, $969696, $868686,
    $777777, $5F5F5F, $2100A5, $FFFF66, $FF66FF, $FF6666, $66FFFF, $66FF66, $6666FF, $FFFFCC,
    $FFFF99, $CCFF66, $FFFF33, $FFCCFF, $FFCCCC, $FFCC99, $FFCC66, $FFCC33, $FFCC00, $FF99FF,
    $FF99CC, $FF9999, $FF9966, $FF9933, $FF9900, $CC66FF, $FF66CC, $FF6699, $CC6666, $FF6633,
    $FF6600, $FF33FF, $FF33CC, $FF3399, $FF3366, $FF3333, $CC3300, $FF0099, $FF0066, $CC0033,
    $CCFFFF, $CCFFCC, $CCFF99, $99FF66, $CCFF33, $CCFF00, $CCCCFF, $CCCCCC, $CCCC99, $CCCC66,
    $CCCC33, $CCCC00, $CC99FF, $CC99CC, $CC9999, $CC9966, $CC9933, $CC9900, $9966FF, $CC66CC,
    $CC6699, $996666, $CC6633, $CC6600, $CC33FF, $CC33CC, $CC3399, $CC3366, $CC3333, $993300,
    $CC00CC, $CC0099, $CC0066, $990033, $CC0000, $99FFFF, $99FFCC, $99FF99, $99CC66, $99FF33, 
    $99FF00, $99CCFF, $99CCCC, $99CC99, $66CC66, $99CC33, $99CC00, $9999FF, $9999CC, $999999, 
    $999966, $999933, $9933FF, $9966CC, $996699, $993366, $996633, $996600, $9900FF, $9933CC, 
    $990066, $993333, $990000, $9900CC, $990099, $993399, $999900, $FF00CC, $CC00FF, $66FFCC, 
    $66FF99, $66FF33, $66FF00, $66CCFF, $66CCCC, $66CC99, $66CC33, $66CC00, $6699FF, $6699CC, 
    $669999, $669966, $669933, $669900, $6666CC, $666699, $666666, $666633, $666600, $6633FF, 
    $6633CC, $663399, $663366, $663333, $663300, $6600FF, $6600CC, $660099, $660066, $660033,
    $660000, $33FFFF, $33FFCC, $33FF99, $33FF66, $33FF33, $33CCFF, $33CCCC, $33CC99, $33CC66, 
    $33CC33, $33CC00, $3399FF, $3399CC, $339999, $339966, $339933, $339900, $3366FF, $3366CC, 
    $336699, $336666, $336633, $336600, $3333FF, $3333CC, $333399, $333366, $333333, $FF3300, 
    $3300FF, $3300CC, $330099, $330066, $FF0033, $33FF00, $00FFCC, $00FF99, $00FF66, $00CCFF,
    $00CCCC, $00CC99, $00CC66, $00CC33, $00CC00, $0099FF, $0099CC, $009999, $009966, $009933, 
    $009900, $0066FF, $0066CC, $006699, $006666, $006633, $006600, $0033FF, $0033CC, $003399, 
    $003366, $003333, $003300, $0000CC, $000099, $000066, $00FF33, $90A9AD, $D6E7E7, $C6D6EF,
    $FFECCC, $9300D6, $5050FF, $807CFF, $393939, $424242, $4D4D4D, $555555, $292929, $222222, 
    $1C1C1C, $161616, $333300, $330033, $000033, $330000, $F0CAA6, $C0DCC0, $C0C0C0, $808000, 
    $800080, $800000, $008080, $008000, $000080, $000000);

  scIE140_C : array [0..139] of TColor = (
    $F0F8FF, $FAEBD7, $00FFFF, $7FFFD4, $F0FFFF, $F5F5DC, $FFE4C4, $000000, $FFEBCD, $0000FF,
    $8A2BE2, $A52A2A, $DEB887, $5F9EA0, $7FFF00, $D2691E, $FF7F50, $6495ED, $FFF8DC, $DC143C,
    $00FFFF, $00008B, $008B8B, $B8860B, $A9A9A9, $006400, $BDB76B, $8B008B, $556B2F, $FF8C00,
    $9932CC, $8B0000, $E9967A, $8FBC8B, $483D8B, $2F4F4F, $00CED1, $9400D3, $FF1493, $00BFFF,
    $696969, $1E90FF, $B22222, $FFFAF0, $228B22, $FF00FF, $DCDCDC, $F8F8FF, $FFD700, $DAA520,
    $808080, $008000, $ADFF2F, $F0FFF0, $FF69B4, $CD5C5C, $4B0082, $FFFFF0, $F0E68C, $E6E6FA,
    $FFF0F5, $7CFC00, $FFFACD, $ADD8E6, $F08080, $E0FFFF, $FAFAD2, $90EE90, $D3D3D3, $FFB6C1,
    $FFA07A, $20B2AA, $87CEFA, $778899, $B0C4DE, $FFFFE0, $00FF00, $32CD32, $FAF0E6, $FF00FF,
    $800000, $66CDAA, $0000CD, $BA55D3, $9370DB, $3CB371, $7B68EE, $00FA9A, $48D1CC, $C71585,
    $191970, $F5FFFA, $FFE4E1, $FFE4B5, $FFDEAD, $000080, $FDF5E6, $808000, $6B8E23, $FFA500,
    $FF4500, $DA70D6, $EEE8AA, $98FB98, $AFEEEE, $DB7093, $FFEFD5, $FFDAB9, $CD853F, $FFC0CB,
    $DDA0DD, $B0E0E6, $800080, $FF0000, $BC8F8F, $4169E1, $8B4513, $FA8072, $F4A460, $2E8B57,
    $FFF5EE, $A0522D, $C0C0C0, $87CEEB, $6A5ACD, $708090, $FFFAFA, $00FF7F, $4682B4, $D2B48C,
    $008080, $D8BFD8, $FF6347, $40E0D0, $EE82EE, $F5DEB3, $FFFFFF, $F5F5F5, $FFFF00, $9ACD32);

  scNetscape216_C_1 : array [0..215] of TColor = (
    $330000, $333300, $336600, $339900, $33CC00, $33FF00, $66FF00, $66CC00, $669900, $666600,
    $663300, $660000, $FF0000, $FF3300, $FF6600, $FF9900, $FFCC00, $FFFF00, $330033, $333333,
    $336633, $339933, $33CC33, $33FF33, $66FF33, $66CC33, $669933, $666633, $663333, $660033,
    $FF0033, $FF3333, $FF6633, $FF9933, $FFCC33, $FFFF33, $330066, $333366, $336666, $339966,
    $33CC66, $33FF66, $66FF66, $66CC66, $669966, $666666, $663366, $660066, $FF0066, $FF3366,
    $FF6666, $FF9966, $FFCC66, $FFFF66, $330099, $333399, $336699, $339999, $33CC99, $33FF99,
    $66FF99, $66CC99, $669999, $666699, $663399, $660099, $FF0099, $FF3399, $FF6699, $FF9999,
    $FFCC99, $FFFF99, $3300CC, $3333CC, $3366CC, $3399CC, $33CCCC, $33FFCC, $66FFCC, $66CCCC,
    $6699CC, $6666CC, $6633CC, $6600CC, $FF00CC, $FF33CC, $FF66CC, $FF99CC, $FFCCCC, $FFFFCC,
    $3300FF, $3333FF, $3366FF, $3399FF, $33CCFF, $33FFFF, $66FFFF, $66CCFF, $6699FF, $6666FF,
    $6633FF, $6600FF, $FF00FF, $FF33FF, $FF66FF, $FF99FF, $FFCCFF, $FFFFFF, $0000FF, $0033FF,
    $0066FF, $0099FF, $00CCFF, $00FFFF, $99FFFF, $99CCFF, $9999FF, $9966FF, $9933FF, $9900FF,
    $CC00FF, $CC33FF, $CC66FF, $CC99FF, $CCCCFF, $CCFFFF, $0000CC, $0033CC, $0066CC, $0099CC,
    $00CCCC, $00FFCC, $99FFCC, $99CCCC, $9999CC, $9966CC, $9933CC, $9900CC, $CC00CC, $CC33CC,
    $CC66CC, $CC99CC, $CCCCCC, $CCFFCC, $000099, $003399, $006699, $009999, $00CC99, $00FF99,
    $99FF99, $99CC99, $999999, $996699, $993399, $990099, $CC0099, $CC3399, $CC6699, $CC9999,
    $CCCC99, $CCFF99, $000066, $003366, $006666, $009966, $00CC66, $00FF66, $99FF66, $99CC66,
    $999966, $996666, $993366, $990066, $CC0066, $CC3366, $CC6666, $CC9966, $CCCC66, $CCFF66,
    $000033, $003333, $006633, $009933, $00CC33, $00FF33, $99FF33, $99CC33, $999933, $996633,
    $993333, $990033, $CC0033, $CC3333, $CC6633, $CC9933, $CCCC33, $CCFF33, $000000, $003300,
    $006600, $009900, $00CC00, $00FF00, $99FF00, $99CC00, $999900, $996600, $993300, $990000,
    $CC0000, $CC3300, $CC6600, $CC9900, $CCCC00, $CCFF00);

  scNetscape216_C_2 : array [0..215] of TColor = (
    $000000, $003300, $006600, $009900, $00CC00, $00FF00, $330000, $333300, $336600,
    $339900, $33CC00, $33FF00, $660000, $663300, $666600, $669900, $66CC00, $66FF00,
    $000033, $003333, $006633, $009933, $00CC33, $00FF33, $330033, $333333, $336633,
    $339933, $33CC33, $33FF33, $660033, $663333, $666633, $669933, $66CC33, $66FF33,
    $000066, $003366, $006666, $009966, $00CC66, $00FF66, $330066, $333366, $336666,
    $339966, $33CC66, $33FF66, $660066, $663366, $666666, $669966, $66CC66, $66FF66,
    $000099, $003399, $006699, $009999, $00CC99, $00FF99, $330099, $333399, $336699,
    $339999, $33CC99, $33FF99, $660099, $663399, $666699, $669999, $66CC99, $66FF99,
    $0000CC, $0033CC, $0066CC, $0099CC, $00CCCC, $00FFCC, $3300CC, $3333CC, $3366CC,
    $3399CC, $33CCCC, $33FFCC, $6600CC, $6633CC, $6666CC, $6699CC, $66CCCC, $66FFCC,
    $0000FF, $0033FF, $0066FF, $0099FF, $00CCFF, $00FFFF, $3300FF, $3333FF, $3366FF,
    $3399FF, $33CCFF, $33FFFF, $6600FF, $6633FF, $6666FF, $6699FF, $66CCFF, $66FFFF,
    $990000, $993300, $996600, $999900, $99CC00, $99FF00, $CC0000, $CC3300, $CC6600,
    $CC9900, $CCCC00, $CCFF00, $FF0000, $FF3300, $FF6600, $FF9900, $FFCC00, $FFFF00,
    $990033, $993333, $996633, $999933, $99CC33, $99FF33, $CC0033, $CC3333, $CC6633,
    $CC9933, $CCCC33, $CCFF33, $FF0033, $FF3333, $FF6633, $FF9933, $FFCC33, $FFFF33,
    $990066, $993366, $996666, $999966, $99CC66, $99FF66, $CC0066, $CC3366, $CC6666,
    $CC9966, $CCCC66, $CCFF66, $FF0066, $FF3366, $FF6666, $FF9966, $FFCC66, $FFFF66,
    $990099, $993399, $996699, $999999, $99CC99, $99FF99, $CC0099, $CC3399, $CC6699,
    $CC9999, $CCCC99, $CCFF99, $FF0099, $FF3399, $FF6699, $FF9999, $FFCC99, $FFFF99,
    $9900CC, $9933CC, $9966CC, $9999CC, $99CCCC, $99FFCC, $CC00CC, $CC33CC, $CC66CC,
    $CC99CC, $CCCCCC, $CCFFCC, $FF00CC, $FF33CC, $FF66CC, $FF99CC, $FFCCCC, $FFFFCC,
    $9900FF, $9933FF, $9966FF, $9999FF, $99CCFF, $99FFFF, $CC00FF, $CC33FF, $CC66FF,
    $CC99FF, $CCCCFF, $CCFFFF, $FF00FF, $FF33FF, $FF66FF, $FF99FF, $FFCCFF, $FFFFFF);

  scNetscape3_C : array [0..454] of TColor = (
    $FFFAFA, $F8F8FF, $F5F5F5, $DCDCDC, $FFFAF0, $FDF5E6, $FAF0E6, $FAEBD7, $FFEFD5, $FFEBCD,
    $FFE4C4, $FFDAB9, $FFDEAD, $FFE4B5, $FFF8DC, $FFFFF0, $FFFACD, $FFF5EE, $F0FFF0, $F5FFFA,
    $F0FFFF, $F0F8FF, $E6E6FA, $FFF0F5, $FFE4E1, $FFFFFF, $000000, $2F4F4F, $696969, $708090,
    $778899, $BEBEBE, $D3D3D3, $191970, $000080, $6495ED, $483D8B, $6A5ACD, $7B68EE, $8470FF,
    $0000CD, $4169E1, $0000FF, $1E90FF, $00BFFF, $87CEEB, $87CEFA, $4682B4, $B0C4DE, $ADD8E6,
    $B0E0E6, $AFEEEE, $00CED1, $48D1CC, $40E0D0, $00FFFF, $E0FFFF, $5F9EA0, $66CDAA, $7FFFD4,
    $006400, $556B2F, $8FBC8F, $2E8B57, $3CB371, $20B2AA, $98FB98, $00FF7F, $7CFC00, $00FF00,
    $7FFF00, $00FA9A, $ADFF2F, $32CD32, $9ACD32, $228B22, $6B8E23, $BDB76B, $EEE8AA, $FAFAD2,
    $FFFFE0, $FFFF00, $FFD700, $EEDD82, $DAA520, $B8860B, $BC8F8F, $CD5C5C, $8B4513, $A0522D,
    $CD853F, $DEB887, $F5F5DC, $F5DEB3, $F4A460, $D2B48C, $D2691E, $B22222, $A52A2A, $E9967A,
    $FA8072, $FFA07A, $FFA500, $FF8C00, $FF7F50, $F08080, $FF6347, $FF4500, $FF0000, $FF69B4,
    $FF1493, $FFC0CB, $FFB6C1, $DB7093, $B03060, $C71585, $D02090, $FF00FF, $EE82EE, $DDA0DD,
    $DA70D6, $BA55D3, $9932CC, $9400D3, $8A2BE2, $A020F0, $9370DB, $D8BFD8, $FFFAFA, $EEE9E9,
    $CDC9C9, $8B8989, $FFF5EE, $EEE5DE, $CDC5BF, $8B8682, $FFEFDB, $EEDFCC, $CDC0B0, $8B8378,
    $FFE4C4, $EED5B7, $CDB79E, $8B7D6B, $FFDAB9, $EECBAD, $CDAF95, $8B7765, $FFDEAD, $EECFA1,
    $CDB38B, $8B795E, $FFFACD, $EEE9BF, $CDC9A5, $8B8970, $FFF8DC, $EEE8CD, $CDC8B1, $8B8878,
    $FFFFF0, $EEEEE0, $CDCDC1, $8B8B83, $F0FFF0, $E0EEE0, $C1CDC1, $838B83, $FFF0F5, $EEE0E5,
    $CDC1C5, $8B8386, $FFE4E1, $EED5D2, $CDB7B5, $8B7D7B, $F0FFFF, $E0EEEE, $C1CDCD, $838B8B,
    $836FFF, $7A67EE, $6959CD, $473C8B, $4876FF, $436EEE, $3A5FCD, $27408B, $0000FF, $0000EE,
    $0000CD, $00008B, $1E90FF, $1C86EE, $1874CD, $104E8B, $63B8FF, $5CACEE, $4F94CD, $36648B,
    $00BFFF, $00B2EE, $009ACD, $00688B, $87CEFF, $7EC0EE, $6CA6CD, $4A708B, $B0E2FF, $A4D3EE,
    $8DB6CD, $607B8B, $C6E2FF, $B9D3EE, $9FB6CD, $6C7B8B, $CAE1FF, $BCD2EE, $A2B5CD, $6E7B8B,
    $BFEFFF, $B2DFEE, $9AC0CD, $68838B, $E0FFFF, $D1EEEE, $B4CDCD, $7A8B8B, $BBFFFF, $AEEEEE,
    $96CDCD, $668B8B, $98F5FF, $8EE5EE, $7AC5CD, $53868B, $00F5FF, $00E5EE, $00C5CD, $00868B,
    $00FFFF, $00EEEE, $00CDCD, $008B8B, $97FFFF, $8DEEEE, $79CDCD, $528B8B, $7FFFD4, $76EEC6,
    $66CDAA, $458B74, $C1FFC1, $B4EEB4, $9BCD9B, $698B69, $54FF9F, $4EEE94, $43CD80, $2E8B57,
    $9AFF9A, $90EE90, $7CCD7C, $548B54, $00FF7F, $00EE76, $00CD66, $008B45, $00FF00, $00EE00,
    $00CD00, $008B00, $7FFF00, $76EE00, $66CD00, $458B00, $C0FF3E, $B3EE3A, $9ACD32, $698B22,
    $CAFF70, $BCEE68, $A2CD5A, $6E8B3D, $FFF68F, $EEE685, $CDC673, $8B864E, $FFEC8B, $EEDC82,
    $CDBE70, $8B814C, $FFFFE0, $EEEED1, $CDCDB4, $8B8B7A, $FFFF00, $EEEE00, $CDCD00, $8B8B00,
    $FFD700, $EEC900, $CDAD00, $8B7500, $FFC125, $EEB422, $CD9B1D, $8B6914, $FFB90F, $EEAD0E,
    $CD950C, $8B658B, $FFC1C1, $EEB4B4, $CD9B9B, $8B6969, $FF6A6A, $EE6363, $CD5555, $8B3A3A,
    $FF8247, $EE7942, $CD6839, $8B4726, $FFD39B, $EEC591, $CDAA7D, $8B7355, $FFE7BA, $EED8AE,
    $CDBA96, $8B7E66, $FFA54F, $EE9A49, $CD853F, $8B5A2B, $FF7F24, $EE7621, $CD661D, $8B4513,
    $FF3030, $EE2C2C, $CD2626, $8B1A1A, $FF4040, $EE3B3B, $CD3333, $8B2323, $FF8C69, $EE8262,
    $CD7054, $8B4C39, $FFA07A, $EE9572, $CD8162, $8B5742, $FFA500, $EE9A00, $CD8500, $8B5A00,
    $FF7F00, $EE7600, $CD6600, $8B4500, $FF7256, $EE6A50, $CD5B45, $8B3E2F, $FF6347, $EE5C42,
    $CD4F39, $8B3626, $FF4500, $EE4000, $CD3700, $8B2500, $FF0000, $EE0000, $CD0000, $8B0000,
    $FF1493, $EE1289, $CD1076, $8B0A50, $FF6EB4, $EE6AA7, $CD6090, $8B3A62, $FFB5C5, $EEA9B8,
    $CD919E, $8B636C, $FFAEB9, $EEA2AD, $CD8C95, $8B5F65, $FF82AB, $EE799F, $CD6889, $8B475D,
    $FF34B3, $EE30A7, $CD2990, $8B1C62, $FF3E96, $EE3A8C, $CD3278, $8B2252, $FF00FF, $EE00EE,
    $CD00CD, $8B008B, $FF83FA, $EE7AE9, $CD69C9, $8B4789, $FFBBFF, $EEAEEE, $CD96CD, $8B668B,
    $E066FF, $D15FEE, $B452CD, $7A378B, $BF3EFF, $B23AEE, $9A32CD, $68228B, $9B30FF, $912CEE,
    $7D26CD, $551A8B, $AB82FF, $9F79EE, $8968CD, $5D478B, $FFE1FF, $EED2EE, $CDB5CD, $8B7B8B,
    $1C1C1C, $363636, $4F4F4F, $696969, $828282, $9C9C9C, $B5B5B5, $CFCFCF, $E8E8E8, $A9A9A9,
    $00008B, $008B8B, $8B008B, $8B0000, $90EE90);

  scColors: array[0..41] of TIdentMapEntry = (
    // Standart colors
    (Value: clBlack; Name: 'clBlack'),
    (Value: clMaroon; Name: 'clMaroon'),
    (Value: clGreen; Name: 'clGreen'),
    (Value: clOlive; Name: 'clOlive'),
    (Value: clNavy; Name: 'clNavy'),
    (Value: clPurple; Name: 'clPurple'),
    (Value: clTeal; Name: 'clTeal'),
    (Value: clGray; Name: 'clGray'),
    (Value: clSilver; Name: 'clSilver'),
    (Value: clRed; Name: 'clRed'),
    (Value: clLime; Name: 'clLime'),
    (Value: clYellow; Name: 'clYellow'),
    (Value: clBlue; Name: 'clBlue'),
    (Value: clFuchsia; Name: 'clFuchsia'),
    (Value: clAqua; Name: 'clAqua'),
    (Value: clWhite; Name: 'clWhite'),
    // System colors
    (Value: clScrollBar; Name: 'clScrollBar'),
    (Value: clBackground; Name: 'clBackground'),
    (Value: clActiveCaption; Name: 'clActiveCaption'),
    (Value: clInactiveCaption; Name: 'clInactiveCaption'),
    (Value: clMenu; Name: 'clMenu'),
    (Value: clWindow; Name: 'clWindow'),
    (Value: clWindowFrame; Name: 'clWindowFrame'),
    (Value: clMenuText; Name: 'clMenuText'),
    (Value: clWindowText; Name: 'clWindowText'),
    (Value: clCaptionText; Name: 'clCaptionText'),
    (Value: clActiveBorder; Name: 'clActiveBorder'),
    (Value: clInactiveBorder; Name: 'clInactiveBorder'),
    (Value: clAppWorkSpace; Name: 'clAppWorkSpace'),
    (Value: clHighlight; Name: 'clHighlight'),
    (Value: clHighlightText; Name: 'clHighlightText'),
    (Value: clBtnFace; Name: 'clBtnFace'),
    (Value: clBtnShadow; Name: 'clBtnShadow'),
    (Value: clGrayText; Name: 'clGrayText'),
    (Value: clBtnText; Name: 'clBtnText'),
    (Value: clInactiveCaptionText; Name: 'clInactiveCaptionText'),
    (Value: clBtnHighlight; Name: 'clBtnHighlight'),
    (Value: cl3DDkShadow; Name: 'cl3DDkShadow'),
    (Value: cl3DLight; Name: 'cl3DLight'),
    (Value: clInfoText; Name: 'clInfoText'),
    (Value: clInfoBk; Name: 'clInfoBk'),
    (Value: clNone; Name: 'clNone'));

  // Web safe colors
  scWebSafeColors: array[0..139] of TIdentMapEntry = (
    (Value: $FFF8F0; Name: 'clAliceBlue'),
    (Value: $D7EBFA; Name: 'clAntiqueWhite'),
    (Value: $FFFF00; Name: 'clAqua'),
    (Value: $D4FF7F; Name: 'clAquamarine'),
    (Value: $FFFFF0; Name: 'clAzure'),
    (Value: $DCF5F5; Name: 'clBeige'),
    (Value: $C4E4FF; Name: 'clBisque'),
    (Value: $000000; Name: 'clBlack'),
    (Value: $CDEBFF; Name: 'clBlanchedAlmond'),
    (Value: $FF0000; Name: 'clBlue'),
    (Value: $E22B8A; Name: 'clBlueViolet'),
    (Value: $2A2AA5; Name: 'clBrown'),
    (Value: $87B8DE; Name: 'clBurlyWood'),
    (Value: $A09E5F; Name: 'clCadetBlue'),
    (Value: $00FF7F; Name: 'clChartreuse'),
    (Value: $1E69D2; Name: 'clChocolate'),
    (Value: $507FFF; Name: 'clCoral'),
    (Value: $ED9564; Name: 'clCornflowerBlue'),
    (Value: $DCF8FF; Name: 'clCornsilk'),
    (Value: $3C14DC; Name: 'clCrimson'),
    (Value: $FFFF00; Name: 'clCyan'),
    (Value: $8B0000; Name: 'clDarkBlue'),
    (Value: $8B8B00; Name: 'clDarkCyan'),
    (Value: $0B86B8; Name: 'clDarkGoldenrod'),
    (Value: $A9A9A9; Name: 'clDarkGray'),
    (Value: $006400; Name: 'clDarkGreen'),
    (Value: $6BB7BD; Name: 'clDarkKhaki'),
    (Value: $8B008B; Name: 'clDarkMagenta'),
    (Value: $2F6B55; Name: 'clDarkOliveGreen'),
    (Value: $008CFF; Name: 'clDarkOrange'),
    (Value: $CC3299; Name: 'clDarkOrchid'),
    (Value: $00008B; Name: 'clDarkRed'),
    (Value: $7A96E9; Name: 'clDarkSalmon'),
    (Value: $8BBC8F; Name: 'clDarkSeaGreen'),
    (Value: $8B3D48; Name: 'clDarkSlateBlue'),
    (Value: $4F4F2F; Name: 'clDarkSlateGray'),
    (Value: $D1CE00; Name: 'clDarkTurquoise'),
    (Value: $D30094; Name: 'clDarkViolet'),
    (Value: $9314FF; Name: 'clDeepPink'),
    (Value: $FFBF00; Name: 'clDeepSkyBlue'),
    (Value: $696969; Name: 'clDimGray'),
    (Value: $FF901E; Name: 'clDodgerBlue'),
    (Value: $2222B2; Name: 'clFirebrick'),
    (Value: $F0FAFF; Name: 'clFloralWhite'),
    (Value: $228B22; Name: 'clForestGreen'),
    (Value: $FF00FF; Name: 'clFuchsia'),
    (Value: $DCDCDC; Name: 'clGainsboro'),
    (Value: $FFF8F8; Name: 'clGhostWhite'),
    (Value: $00D7FF; Name: 'clGold'),
    (Value: $20A5DA; Name: 'clGoldenrod'),
    (Value: $808080; Name: 'clGray'),
    (Value: $008000; Name: 'clGreen'),
    (Value: $2FFFAD; Name: 'clGreenYellow'),
    (Value: $F0FFF0; Name: 'clHoneydew'),
    (Value: $B469FF; Name: 'clHotPink'),
    (Value: $5C5CCD; Name: 'clIndianRed'),
    (Value: $82004B; Name: 'clIndigo'),
    (Value: $F0FFFF; Name: 'clIvory'),
    (Value: $8CE6F0; Name: 'clKhaki'),
    (Value: $FAE6E6; Name: 'clLavender'),
    (Value: $F5F0FF; Name: 'clLavenderBlush'),
    (Value: $00FC7C; Name: 'clLawnGreen'),
    (Value: $CDFAFF; Name: 'clLemonChiffon'),
    (Value: $E6D8AD; Name: 'clLightBlue'),
    (Value: $8080F0; Name: 'clLightCoral'),
    (Value: $FFFFE0; Name: 'clLightCyan'),
    (Value: $D2FAFA; Name: 'clLightGoldenrodYellow'),
    (Value: $D3D3D3; Name: 'clLightGray'),
    (Value: $90EE90; Name: 'clLightGreen'),
    (Value: $C1B6FF; Name: 'clLightPink'),
    (Value: $7AA0FF; Name: 'clLightSalmon'),
    (Value: $AAB220; Name: 'clLightSeaGreen'),
    (Value: $FACE87; Name: 'clLightSkyBlue'),
    (Value: $998877; Name: 'clLightSlateGray'),
    (Value: $DEC4B0; Name: 'clLightSteelBlue'),
    (Value: $E0FFFF; Name: 'clLightYellow'),
    (Value: $00FF00; Name: 'clLime'),
    (Value: $32CD32; Name: 'clLimeGreen'),
    (Value: $E6F0FA; Name: 'clLinen'),
    (Value: $FF00FF; Name: 'clMagenta'),
    (Value: $000080; Name: 'clMaroon'),
    (Value: $AACD66; Name: 'clMediumAquamarine'),
    (Value: $CD0000; Name: 'clMediumBlue'),
    (Value: $D355BA; Name: 'clMediumOrchid'),
    (Value: $DB7093; Name: 'clMediumPurple'),
    (Value: $71B33C; Name: 'clMediumSeaGreen'),
    (Value: $EE687B; Name: 'clMediumSlateBlue'),
    (Value: $9AFA00; Name: 'clMediumSpringGreen'),
    (Value: $CCD148; Name: 'clMediumTurquoise'),
    (Value: $8515C7; Name: 'clMediumVioletRed'),
    (Value: $701919; Name: 'clMidnightBlue'),
    (Value: $FAFFF5; Name: 'clMintCream'),
    (Value: $E1E4FF; Name: 'clMistyRose'),
    (Value: $B5E4FF; Name: 'clMoccasin'),
    (Value: $ADDEFF; Name: 'clNavajoWhite'),
    (Value: $800000; Name: 'clNavy'),
    (Value: $E6F5FD; Name: 'clOldLace'),
    (Value: $008080; Name: 'clOlive'),
    (Value: $238E6B; Name: 'clOliveDrab'),
    (Value: $00A5FF; Name: 'clOrange'),
    (Value: $0045FF; Name: 'clOrangeRed'),
    (Value: $D670DA; Name: 'clOrchid'),
    (Value: $AAE8EE; Name: 'clPaleGoldenrod'),
    (Value: $98FB98; Name: 'clPaleGreen'),
    (Value: $EEEEAF; Name: 'clPaleTurquoise'),
    (Value: $9370DB; Name: 'clPaleVioletRed'),
    (Value: $D5EFFF; Name: 'clPapayaWhip'),
    (Value: $B9DAFF; Name: 'clPeachPuff'),
    (Value: $3F85CD; Name: 'clPeru'),
    (Value: $CBC0FF; Name: 'clPink'),
    (Value: $DDA0DD; Name: 'clPlum'),
    (Value: $E6E0B0; Name: 'clPowderBlue'),
    (Value: $800080; Name: 'clPurple'),
    (Value: $0000FF; Name: 'clRed'),
    (Value: $8F8FBC; Name: 'clRosyBrown'),
    (Value: $E16941; Name: 'clRoyalBlue'),
    (Value: $13458B; Name: 'clSaddleBrown'),
    (Value: $7280FA; Name: 'clSalmon'),
    (Value: $60A4F4; Name: 'clSandyBrown'),
    (Value: $578B2E; Name: 'clSeaGreen'),
    (Value: $EEF5FF; Name: 'clSeaShell'),
    (Value: $2D52A0; Name: 'clSienna'),
    (Value: $C0C0C0; Name: 'clSilver'),
    (Value: $EBCE87; Name: 'clSkyBlue'),
    (Value: $CD5A6A; Name: 'clSlateBlue'),
    (Value: $908070; Name: 'clSlateGray'),
    (Value: $FAFAFF; Name: 'clSnow'),
    (Value: $7FFF00; Name: 'clSpringGreen'),
    (Value: $B48246; Name: 'clSteelBlue'),
    (Value: $8CB4D2; Name: 'clTan'),
    (Value: $808000; Name: 'clTeal'),
    (Value: $D8BFD8; Name: 'clThistle'),
    (Value: $4763FF; Name: 'clTomato'),
    (Value: $D0E040; Name: 'clTurquoise'),
    (Value: $EE82EE; Name: 'clViolet'),
    (Value: $B3DEF5; Name: 'clWheat'),
    (Value: $FFFFFF; Name: 'clWhite'),
    (Value: $F5F5F5; Name: 'clWhiteSmoke'),
    (Value: $00FFFF; Name: 'clYellow'),
    (Value: $32CD9A; Name: 'clYellowGreen')
    );

  // Web safe colors ordered by colors
  scWebSafeColorsForBox: array[0..137] of TIdentMapEntry = (
    (Value: $000000; Name: 'clBlack'),
    (Value: $696969; Name: 'clDimGray'),
    (Value: $808080; Name: 'clGray'),
    (Value: $A9A9A9; Name: 'clDarkGray'),
    (Value: $C0C0C0; Name: 'clSilver'),
    (Value: $D3D3D3; Name: 'clLightGray'),
    (Value: $DCDCDC; Name: 'clGainsboro'),
    (Value: $F5F5F5; Name: 'clWhiteSmoke'),
    (Value: $FFFFFF; Name: 'clWhite'),
    (Value: $8F8FBC; Name: 'clRosyBrown'),
    (Value: $5C5CCD; Name: 'clIndianRed'),
    (Value: $2A2AA5; Name: 'clBrown'),
    (Value: $2222B2; Name: 'clFirebrick'),
    (Value: $8080F0; Name: 'clLightCoral'),
    (Value: $000080; Name: 'clMaroon'),
    (Value: $00008B; Name: 'clDarkRed'),
    (Value: $0000FF; Name: 'clRed'),
    (Value: $FAFAFF; Name: 'clSnow'),
    (Value: $E1E4FF; Name: 'clMistyRose'),
    (Value: $7280FA; Name: 'clSalmon'),
    (Value: $4763FF; Name: 'clTomato'),
    (Value: $7A96E9; Name: 'clDarkSalmon'),
    (Value: $507FFF; Name: 'clCoral'),
    (Value: $0045FF; Name: 'clOrangeRed'),
    (Value: $7AA0FF; Name: 'clLightSalmon'),
    (Value: $2D52A0; Name: 'clSienna'),
    (Value: $EEF5FF; Name: 'clSeaShell'),
    (Value: $1E69D2; Name: 'clChocolate'),
    (Value: $13458B; Name: 'clSaddleBrown'),
    (Value: $60A4F4; Name: 'clSandyBrown'),
    (Value: $B9DAFF; Name: 'clPeachPuff'),
    (Value: $3F85CD; Name: 'clPeru'),
    (Value: $E6F0FA; Name: 'clLinen'),
    (Value: $C4E4FF; Name: 'clBisque'),
    (Value: $008CFF; Name: 'clDarkOrange'),
    (Value: $87B8DE; Name: 'clBurlyWood'),
    (Value: $8CB4D2; Name: 'clTan'),
    (Value: $D7EBFA; Name: 'clAntiqueWhite'),
    (Value: $ADDEFF; Name: 'clNavajoWhite'),
    (Value: $CDEBFF; Name: 'clBlanchedAlmond'),
    (Value: $D5EFFF; Name: 'clPapayaWhip'),
    (Value: $B5E4FF; Name: 'clMoccasin'),
    (Value: $00A5FF; Name: 'clOrange'),
    (Value: $B3DEF5; Name: 'clWheat'),
    (Value: $E6F5FD; Name: 'clOldLace'),
    (Value: $F0FAFF; Name: 'clFloralWhite'),
    (Value: $0B86B8; Name: 'clDarkGoldenrod'),
    (Value: $20A5DA; Name: 'clGoldenrod'),
    (Value: $DCF8FF; Name: 'clCornsilk'),
    (Value: $00D7FF; Name: 'clGold'),
    (Value: $8CE6F0; Name: 'clKhaki'),
    (Value: $CDFAFF; Name: 'clLemonChiffon'),
    (Value: $AAE8EE; Name: 'clPaleGoldenrod'),
    (Value: $6BB7BD; Name: 'clDarkKhaki'),
    (Value: $DCF5F5; Name: 'clBeige'),
    (Value: $D2FAFA; Name: 'clLightGoldenrodYellow'),
    (Value: $008080; Name: 'clOlive'),
    (Value: $00FFFF; Name: 'clYellow'),
    (Value: $E0FFFF; Name: 'clLightYellow'),
    (Value: $F0FFFF; Name: 'clIvory'),
    (Value: $238E6B; Name: 'clOliveDrab'),
    (Value: $32CD9A; Name: 'clYellowGreen'),
    (Value: $2F6B55; Name: 'clDarkOliveGreen'),
    (Value: $2FFFAD; Name: 'clGreenYellow'),
    (Value: $00FF7F; Name: 'clChartreuse'),
    (Value: $00FC7C; Name: 'clLawnGreen'),
    (Value: $8BBC8F; Name: 'clDarkSeaGreen'),
    (Value: $228B22; Name: 'clForestGreen'),
    (Value: $32CD32; Name: 'clLimeGreen'),
    (Value: $90EE90; Name: 'clLightGreen'),
    (Value: $98FB98; Name: 'clPaleGreen'),
    (Value: $006400; Name: 'clDarkGreen'),
    (Value: $008000; Name: 'clGreen'),
    (Value: $00FF00; Name: 'clLime'),
    (Value: $F0FFF0; Name: 'clHoneydew'),
    (Value: $578B2E; Name: 'clSeaGreen'),
    (Value: $71B33C; Name: 'clMediumSeaGreen'),
    (Value: $7FFF00; Name: 'clSpringGreen'),
    (Value: $FAFFF5; Name: 'clMintCream'),
    (Value: $9AFA00; Name: 'clMediumSpringGreen'),
    (Value: $AACD66; Name: 'clMediumAquamarine'),
    (Value: $D4FF7F; Name: 'clAquamarine'),
    (Value: $D0E040; Name: 'clTurquoise'),
    (Value: $AAB220; Name: 'clLightSeaGreen'),
    (Value: $CCD148; Name: 'clMediumTurquoise'),
    (Value: $4F4F2F; Name: 'clDarkSlateGray'),
    (Value: $EEEEAF; Name: 'clPaleTurquoise'),
    (Value: $808000; Name: 'clTeal'),
    (Value: $8B8B00; Name: 'clDarkCyan'),
    // (Value: $FFFF00; Name: 'clAqua'),
    (Value: $FFFF00; Name: 'clCyan'),
    (Value: $FFFFE0; Name: 'clLightCyan'),
    (Value: $FFFFF0; Name: 'clAzure'),
    (Value: $D1CE00; Name: 'clDarkTurquoise'),
    (Value: $A09E5F; Name: 'clCadetBlue'),
    (Value: $E6E0B0; Name: 'clPowderBlue'),
    (Value: $E6D8AD; Name: 'clLightBlue'),
    (Value: $FFBF00; Name: 'clDeepSkyBlue'),
    (Value: $EBCE87; Name: 'clSkyBlue'),
    (Value: $FACE87; Name: 'clLightSkyBlue'),
    (Value: $B48246; Name: 'clSteelBlue'),
    (Value: $FFF8F0; Name: 'clAliceBlue'),
    (Value: $FF901E; Name: 'clDodgerBlue'),
    (Value: $908070; Name: 'clSlateGray'),
    (Value: $998877; Name: 'clLightSlateGray'),
    (Value: $DEC4B0; Name: 'clLightSteelBlue'),
    (Value: $ED9564; Name: 'clCornflowerBlue'),
    (Value: $E16941; Name: 'clRoyalBlue'),
    (Value: $701919; Name: 'clMidnightBlue'),
    (Value: $FAE6E6; Name: 'clLavender'),
    (Value: $800000; Name: 'clNavy'),
    (Value: $8B0000; Name: 'clDarkBlue'),
    (Value: $CD0000; Name: 'clMediumBlue'),
    (Value: $FF0000; Name: 'clBlue'),
    (Value: $FFF8F8; Name: 'clGhostWhite'),
    (Value: $CD5A6A; Name: 'clSlateBlue'),
    (Value: $8B3D48; Name: 'clDarkSlateBlue'),
    (Value: $EE687B; Name: 'clMediumSlateBlue'),
    (Value: $DB7093; Name: 'clMediumPurple'),
    (Value: $E22B8A; Name: 'clBlueViolet'),
    (Value: $82004B; Name: 'clIndigo'),
    (Value: $CC3299; Name: 'clDarkOrchid'),
    (Value: $D30094; Name: 'clDarkViolet'),
    (Value: $D355BA; Name: 'clMediumOrchid'),
    (Value: $D8BFD8; Name: 'clThistle'),
    (Value: $DDA0DD; Name: 'clPlum'),
    (Value: $EE82EE; Name: 'clViolet'),
    (Value: $800080; Name: 'clPurple'),
    (Value: $8B008B; Name: 'clDarkMagenta'),
    (Value: $FF00FF; Name: 'clMagenta'),
    // (Value: $FF00FF; Name: 'clFuchsia'),
    (Value: $D670DA; Name: 'clOrchid'),
    (Value: $8515C7; Name: 'clMediumVioletRed'),
    (Value: $9314FF; Name: 'clDeepPink'),
    (Value: $B469FF; Name: 'clHotPink'),
    (Value: $F5F0FF; Name: 'clLavenderBlush'),
    (Value: $9370DB; Name: 'clPaleVioletRed'),
    (Value: $3C14DC; Name: 'clCrimson'),
    (Value: $CBC0FF; Name: 'clPink'),
    (Value: $C1B6FF; Name: 'clLightPink')
    );

  scBaseColors: array[0..39] of TIdentMapEntry = (
    (Value: $00000000; Name: 'clBlack'),
    (Value: $00003399; Name: 'clBrown'),
    (Value: $00003333; Name: 'clOliveGreen'),
    (Value: $00003300; Name: 'clDarkGreen'),
    (Value: $00663300; Name: 'clDarkTeal'),
    (Value: $00800000; Name: 'clDarkBlue'),
    (Value: $00993333; Name: 'clIndigo'),
    (Value: $00333333; Name: 'clGray80'),
    (Value: $00000080; Name: 'clMaroon'),
    (Value: $000066FF; Name: 'clOrange'),
    (Value: $00008080; Name: 'clOlive'),
    (Value: $00008000; Name: 'clGreen'),
    (Value: $00808000; Name: 'clTeal'),
    (Value: $00FF0000; Name: 'clBlue'),
    (Value: $00996666; Name: 'clBlueGray'),
    (Value: $00808080; Name: 'clGray50'),
    (Value: $000000FF; Name: 'clRed'),
    (Value: $000099FF; Name: 'clLightOrange'),
    (Value: $0000CC99; Name: 'clLime'),
    (Value: $00669933; Name: 'clSeaGreen'),
    (Value: $00999933; Name: 'clSeaBlue'),
    (Value: $00FF6633; Name: 'clLightBlue'),
    (Value: $00800080; Name: 'clViolet'),
    (Value: $00999999; Name: 'clGray40'),
    (Value: $00FF00FF; Name: 'clFuchsia'),
    (Value: $0000CCFF; Name: 'clGold'),
    (Value: $0000FFFF; Name: 'clYellow'),
    (Value: $0000FF00; Name: 'clLime'),
    (Value: $00FFFF00; Name: 'clAqua'),
    (Value: $00FFCC00; Name: 'clSkyBlue'),
    (Value: $00663399; Name: 'clPlum'),
    (Value: $00C0C0C0; Name: 'clGray25'),
    (Value: $00CC99FF; Name: 'clRose'),
    (Value: $0099CCFF; Name: 'clTan'),
    (Value: $0099FFFF; Name: 'clLightYellow'),
    (Value: $00CCFFCC; Name: 'clLightGreen'),
    (Value: $00FFFFCC; Name: 'clLightTurquoise'),
    (Value: $00FFCC99; Name: 'clPaleBlue'),
    (Value: $00FF99CC; Name: 'clLavender'),
    (Value: $00FFFFFF; Name: 'clWhite'));

{$IFDEF SC_DELPHI6_AND_EARLY}
  {$EXTERNALSYM COLOR_MENUHILIGHT}
  COLOR_MENUHILIGHT = 29;
  {$EXTERNALSYM COLOR_MENUBAR}
  COLOR_MENUBAR = 30;

  clHotLight                = TColor(COLOR_HOTLIGHT or $80000000);

  clMenuHighlight           = TColor(COLOR_MENUHILIGHT or $80000000);
  clMenuBar                 = TColor(COLOR_MENUBAR or $80000000);

  {$IFDEF SC_DELPHI5_AND_EARLY}
  clGradientActiveCaption   = TColor(COLOR_GRADIENTACTIVECAPTION or $80000000);
  clGradientInactiveCaption = TColor(COLOR_GRADIENTINACTIVECAPTION or $80000000);
  {$ENDIF}
{$ENDIF}

  scSystemColors: array[0..29] of TIdentMapEntry = (
    (Value: clScrollBar;               Name: 'clScrollBar'),
    (Value: clBackground;              Name: 'clBackground'),
    (Value: clActiveCaption;           Name: 'clActiveCaption'),
    (Value: clInactiveCaption;         Name: 'clInactiveCaption'),
    (Value: clMenu;                    Name: 'clMenu'),
    (Value: clWindow;                  Name: 'clWindow'),
    (Value: clWindowFrame;             Name: 'clWindowFrame'),
    (Value: clMenuText;                Name: 'clMenuText'),
    (Value: clWindowText;              Name: 'clWindowText'),
    (Value: clCaptionText;             Name: 'clCaptionText'),
    (Value: clActiveBorder;            Name: 'clActiveBorder'),
    (Value: clInactiveBorder;          Name: 'clInactiveBorder'),
    (Value: clAppWorkSpace;            Name: 'clAppWorkSpace'),
    (Value: clHighlight;               Name: 'clHighlight'),
    (Value: clHighlightText;           Name: 'clHighlightText'),
    (Value: clBtnFace;                 Name: 'clBtnFace'),
    (Value: clBtnShadow;               Name: 'clBtnShadow'),
    (Value: clGrayText;                Name: 'clGrayText'),
    (Value: clBtnText;                 Name: 'clBtnText'),
    (Value: clInactiveCaptionText;     Name: 'clInactiveCaptionText'),
    (Value: clBtnHighlight;            Name: 'clBtnHighlight'),
    (Value: cl3DDkShadow;              Name: 'cl3DDkShadow'),
    (Value: cl3DLight;                 Name: 'cl3DLight'),
    (Value: clInfoText;                Name: 'clInfoText'),
    (Value: clInfoBk;                  Name: 'clInfoBk'),
    (Value: clHotLight;                Name: 'clHotLight'),
    (Value: clGradientActiveCaption;   Name: 'clGradientActiveCaption'),
    (Value: clGradientInactiveCaption; Name: 'clGradientInactiveCaption'),
    (Value: clMenuHighlight;           Name: 'clMenuHighlight'),
    (Value: clMenuBar;                 Name: 'clMenuBar'));

    
  scNavButtonRecords: array[0..10] of TSCNavButtonRec = (
    (NavType: scntAppend;  Caption: 'Append';  Hint: 'Append record'),
    (NavType: scntCancel;  Caption: 'Cancel';  Hint: 'Cancel record'),
    (NavType: scntDelete;  Caption: 'Delete';  Hint: 'Delete record'),
    (NavType: scntEdit;    Caption: 'Edit';    Hint: 'Edit record'),
    (NavType: scntFirst;   Caption: 'First';   Hint: 'First record'),
    (NavType: scntInsert;  Caption: 'Insert';  Hint: 'Insert record'),
    (NavType: scntLast;    Caption: 'Last';    Hint: 'Last record'),
    (NavType: scntNext;    Caption: 'Next';    Hint: 'Next record'),
    (NavType: scntPost;    Caption: 'Post';    Hint: 'Post record'),
    (NavType: scntPrior;   Caption: 'Prior';   Hint: 'Prior record'),
    (NavType: scntRefresh; Caption: 'Refresh'; Hint: 'Refresh record'));

  AlignStyle : array[Boolean, TAlignment] of DWORD =
   ((WS_EX_LEFT, WS_EX_RIGHT, WS_EX_LEFT), (WS_EX_RIGHT, WS_EX_LEFT, WS_EX_LEFT));

  scskNone = 'None';
  scskBkSp = 'BkSp';
  scskTab = 'Tab';
  scskEsc = 'Esc';
  scskEnter = 'Enter';
  scskSpace = 'Space';
  scskPgUp = 'PgUp';
  scskPgDn = 'PgDn';
  scskEnd = 'End';
  scskHome = 'Home';
  scskLeft = 'Left';
  scskUp = 'Up';
  scskRight = 'Right';
  scskDown = 'Down';
  scskIns = 'Ins';
  scskDel = 'Del';
  scskShift = 'Shift+';
  scskCtrl = 'Ctrl+';
  scskAlt = 'Alt+';

  {$EXTERNALSYM SC_LBUTTON}
  SC_LBUTTON = 1;
  {$EXTERNALSYM SC_RBUTTON}
  SC_RBUTTON = 2;
  {$EXTERNALSYM SC_SHIFT}
  SC_SHIFT = 4;
  {$EXTERNALSYM SC_CONTROL}
  SC_CONTROL = 8;
  {$EXTERNALSYM SC_MBUTTON}
  SC_MBUTTON = 16;
  {$EXTERNALSYM SC_MENU}
  SC_MENU = 32;

{$IFDEF SC_DELPHI5_AND_EARLY}
var
  clActiveCaptionGradient: TColor = Word(clActiveCaption);
  clInactiveCaptionGradient: TColor = Word(clInactiveCaption);
{$ENDIF}

implementation

{$IFDEF SC_DELPHI5_AND_EARLY}
uses
  SCCommon;
{$ENDIF}

{$IFDEF SC_DELPHI5_AND_EARLY}
procedure SetInitializeValues;
var
  S: String;
begin
  scDefaultLCID := GetThreadLocale;
  scSystemLCID := GetSystemDefaultLCID;

  {$IFDEF MSWINDOWS}
  try
    scNegativeFormat := 1;
    scNegativeFormat := StrToIntDef(GetLocaleStr(scDefaultLCID, LOCALE_INEGNUMBER, '0'), 1);
  except
    scNegativeFormat := 1;
  end;

  try
    scNegativeSign := '-';
    S := GetLocaleStr(scDefaultLCID, LOCALE_SNEGATIVESIGN, '-');
    if Length(S) > 0 then scNegativeSign := S[1];
  except
    scNegativeSign := '-';
  end;

  try
    scNegativeCurFormat := 1;
    scNegativeCurFormat := StrToIntDef(GetLocaleStr(scDefaultLCID, LOCALE_INEGCURR, '0'), 1);
  except
    scNegativeCurFormat := 1;
  end;

  try
    scSysDecimalSeparator := '.';
    S := GetLocaleChar(scSystemLCID, LOCALE_SDECIMAL, '.');
    if Length(S) = 0 then
      scSysDecimalSeparator := '.'
    else
      scSysDecimalSeparator := S[1];
  except
    scSysDecimalSeparator := '.';
  end;

  try
    scCurThousandSeparator := ',';
    S := GetLocaleChar(scDefaultLCID, LOCALE_SMONTHOUSANDSEP, ',');
    if Length(S) = 0 then
      scCurThousandSeparator := ','
    else
      scCurThousandSeparator := S[1];
  except
    scCurThousandSeparator := ',';
  end;

  try
    scCurDecimalSeparator := '.';
    S := GetLocaleChar(scDefaultLCID, LOCALE_SMONDECIMALSEP, '.');
    if Length(S) = 0 then
      scCurDecimalSeparator := '.'
    else
      scCurDecimalSeparator := S[1];
  except
    scCurDecimalSeparator := '.';
  end;
  {$ENDIF}
end;

initialization
  SetInitializeValues;
{$ENDIF}

end.
