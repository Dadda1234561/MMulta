//================================================================================
// DrawPanelHandle.
//================================================================================

class DrawPanelHandle extends WindowHandle
	native;

// Export UDrawPanelHandle::execInsertDrawItem(FFrame&, void* const)
native final function InsertDrawItem(DrawItemInfo infNodeItem);

// Export UDrawPanelHandle::execClear(FFrame&, void* const)
native final function Clear();

// Export UDrawPanelHandle::execPreCheckPanelSize(FFrame&, void* const)
native final function PreCheckPanelSize(out int Width, out int Height);

// Export UDrawPanelHandle::execSetMiddleAlign(FFrame&, void* const)
native final function SetMiddleAlign(bool bMiddle, int Width);

defaultproperties
{
}
