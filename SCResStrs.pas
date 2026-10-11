{*******************************************************}
{                                                       }
{         CA SweetControls Component Library            }
{                                                       }
{  Copyright (c) 1996,2004 CodeAccelerate Corporation   }
{                                                       }
{*******************************************************}

unit SCResStrs;

interface

resourcestring
  SSCNotValidColumnIndex = '%d is not a valid column index.';
  SSCNotValidItemIndex = '%d is not a valid item index.';
  SSCMaskErr = 'Invalid input value. ''%s''';
  SSCMaskEditErr = 'Invalid input value. Use escape key to abandon changes';
  SSCDuplicateString = 'String list does not allow duplicates';
  SSCSortedListError = 'Operation not allowed on sorted string list';
  SSCListIndexError = 'List index out of bounds (%d)';
  SSCError = 'Error';
  SSCCalcError = 'Calculation error';
  SSCMenuUndo = 'Undo';
  SSCMenuRedo = 'Redo';
  SSCMenuCopy = 'Copy';
  SSCMenuCut = 'Cut';
  SSCMenuPaste = 'Paste';
  SSCMenuDelete = 'Delete';
  SSCMenuSelectAll = 'Select All';
  SSCCalClear = 'Clear';
  SSCCalToday = 'Today';
  SSCWarning = 'Warning';
  SSCSchemeChangeWarning = 'Changing sheme will clear your current custom cell settings.' +
    #13 + 'Do you want to apply new sheme?';
  SSCCircularDataLink = 'Circular datalinks are not allowed';
  SSCFieldNotFound = 'Field ''%s'' not found';
  SSCDataSourceFixed = 'Operation not allowed in a DBCtrlGrid';
  SSCPropDefByLookup = 'Property already defined by lookup field';
  SSCOSError = 'System Error.  Code: %d.' + #13#10 + '%s';
  SSCUnkOSError = 'A call to an OS function failed';

implementation

end.