//================================================================================
// TreeHandle.
//================================================================================

class TreeHandle extends WindowHandle
	native;

// Export UTreeHandle::execInsertNode(FFrame&, void* const)
native final function string InsertNode(string strParentName, XMLTreeNodeInfo infNode);

// Export UTreeHandle::execInsertNodeItem(FFrame&, void* const)
native final function InsertNodeItem(string NodeName, XMLTreeNodeItemInfo infNodeItem);

// Export UTreeHandle::execClear(FFrame&, void* const)
native final function Clear();

// Export UTreeHandle::execSetExpandedNode(FFrame&, void* const)
native final function SetExpandedNode(string NodeName, bool bExpanded);

// Export UTreeHandle::execGetExpandedNode(FFrame&, void* const)
native final function string GetExpandedNode(string NodeName);

// Export UTreeHandle::execDeleteNode(FFrame&, void* const)
native final function bool DeleteNode(string NodeName);

// Export UTreeHandle::execIsNodeNameExist(FFrame&, void* const)
native final function bool IsNodeNameExist(string NodeName);

// Export UTreeHandle::execIsExpandedNode(FFrame&, void* const)
native final function bool IsExpandedNode(string NodeName);

// Export UTreeHandle::execGetChildNode(FFrame&, void* const)
native final function string GetChildNode(string NodeName);

// Export UTreeHandle::execGetParentNode(FFrame&, void* const)
native final function string GetParentNode(string NodeName);

// Export UTreeHandle::execShowScrollBar(FFrame&, void* const)
native final function ShowScrollBar(bool bShow);

// Export UTreeHandle::execSetNodeItemText(FFrame&, void* const)
native final function SetNodeItemText(string NodeName, int nTextID, string strText);

// Export UTreeHandle::execSetNodeItemTexture(FFrame&, void* const)
native final function SetNodeItemTexture(string NodeName, int nTextID, string strTexture, int nWidth, int nHeight, int nType);

defaultproperties
{
}
