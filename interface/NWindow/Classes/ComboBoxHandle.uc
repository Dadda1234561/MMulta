//================================================================================
// ComboBoxHandle.
//================================================================================

class ComboBoxHandle extends WindowHandle
	native;

// Export UComboBoxHandle::execAddString(FFrame&, void* const)
native final function AddString(string Str);

// Export UComboBoxHandle::execAddStringWithGap(FFrame&, void* const)
native final function AddStringWithGap(string Str, optional int gap_mode);

// Export UComboBoxHandle::execSYS_AddString(FFrame&, void* const)
native final function SYS_AddString(int Index);

// Export UComboBoxHandle::execAddStringWithReserved(FFrame&, void* const)
native final function AddStringWithReserved(string Str, int Reserved);

// Export UComboBoxHandle::execSYS_AddStringWithReserved(FFrame&, void* const)
native final function SYS_AddStringWithReserved(int Index, int Reserved);

// Export UComboBoxHandle::execGetString(FFrame&, void* const)
native final function string GetString(int Num);

// Export UComboBoxHandle::execGetReserved(FFrame&, void* const)
native final function int GetReserved(int Num);

// Export UComboBoxHandle::execGetSelectedNum(FFrame&, void* const)
native final function int GetSelectedNum();

// Export UComboBoxHandle::execSetSelectedNum(FFrame&, void* const)
native final function SetSelectedNum(int Num);

// Export UComboBoxHandle::execClear(FFrame&, void* const)
native final function Clear();

// Export UComboBoxHandle::execGetNumOfItems(FFrame&, void* const)
native final function int GetNumOfItems();

// Export UComboBoxHandle::execAddStringWithColor(FFrame&, void* const)
native final function int AddStringWithColor(string Str, Color Col);

// Export UComboBoxHandle::execGetFileExtInfo(FFrame&, void* const)
native final function array<string> GetFileExtInfo(int Num);

// Export UComboBoxHandle::execAddStringWithFileExt(FFrame&, void* const)
native final function AddStringWithFileExt(string Str, array<string> strArray);

// Export UComboBoxHandle::execAddStringWithIcon(FFrame&, void* const)
native final function AddStringWithIcon(string Str, string Icontex);

// Export UComboBoxHandle::execAddStringWithIconWithGap(FFrame&, void* const)
native final function AddStringWithIconWithGap(string Str, string Icontex, optional int gap_mode);

// Export UComboBoxHandle::execAddStringWithIconWithStr(FFrame&, void* const)
native final function AddStringWithIconWithStr(string Str, string Icontex, string additionalstr);

// Export UComboBoxHandle::execAddStringWithIconWithGapWithStr(FFrame&, void* const)
native final function AddStringWithIconWithGapWithStr(string Str, string Icontex, int gap_mode, string additionalstr);

// Export UComboBoxHandle::execGetAdditionalString(FFrame&, void* const)
native final function string GetAdditionalString(int Num);

defaultproperties
{
}
