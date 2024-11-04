//================================================================================
// ListBoxHandle.
//================================================================================

class ListBoxHandle extends WindowHandle
	native;

// Export UListBoxHandle::execAddString(FFrame&, void* const)
native final function AddString(string Text);

// Export UListBoxHandle::execClear(FFrame&, void* const)
native final function Clear();

// Export UListBoxHandle::execAddStringWithData(FFrame&, void* const)
native final function AddStringWithData(string Text, Color Color, int Data);

// Export UListBoxHandle::execGetSelectedString(FFrame&, void* const)
native final function string GetSelectedString();

// Export UListBoxHandle::execGetSelectedItemData(FFrame&, void* const)
native final function int GetSelectedItemData();

// Export UListBoxHandle::execSetListBoxScrollPosition(FFrame&, void* const)
native final function SetListBoxScrollPosition(int pos);

// Export UListBoxHandle::execSetDrawOffset(FFrame&, void* const)
native final function SetDrawOffset(int OffsetX, int OffsetY);

// Export UListBoxHandle::execSetMaxRow(FFrame&, void* const)
native final function SetMaxRow(int maxrow);

defaultproperties
{
}
