//================================================================================
// StatusIconHandle.
//================================================================================

class StatusIconHandle extends WindowHandle
	native;

// Export UStatusIconHandle::execAddRow(FFrame&, void* const)
native final function AddRow();

// Export UStatusIconHandle::execAddCol(FFrame&, void* const)
native final function AddCol(int a_Row, StatusIconInfo a_Info);

// Export UStatusIconHandle::execInsertRow(FFrame&, void* const)
native final function InsertRow(int a_Row);

// Export UStatusIconHandle::execInsertCol(FFrame&, void* const)
native final function InsertCol(int a_Row, int a_Col, StatusIconInfo a_Info);

// Export UStatusIconHandle::execGetRowCount(FFrame&, void* const)
native final function int GetRowCount();

// Export UStatusIconHandle::execGetColCount(FFrame&, void* const)
native final function int GetColCount(int a_Row);

// Export UStatusIconHandle::execGetItem(FFrame&, void* const)
native final function GetItem(int a_Row, int a_Col, out StatusIconInfo a_Info);

// Export UStatusIconHandle::execSetItem(FFrame&, void* const)
native final function SetItem(int a_Row, int a_Col, StatusIconInfo a_Info);

// Export UStatusIconHandle::execDelItem(FFrame&, void* const)
native final function DelItem(int a_Row, int a_Col);

// Export UStatusIconHandle::execSetIconSize(FFrame&, void* const)
native final function SetIconSize(int a_Size);

// Export UStatusIconHandle::execClear(FFrame&, void* const)
native final function Clear();

defaultproperties
{
}
