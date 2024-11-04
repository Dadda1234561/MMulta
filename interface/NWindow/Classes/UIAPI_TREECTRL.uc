//================================================================================
// UIAPI_TREECTRL.
//================================================================================

class UIAPI_TREECTRL extends UIAPI_WINDOW
	native;

// Export UUIAPI_TREECTRL::execInsertNode(FFrame&, void* const)
native static function string InsertNode(string ControlName, string strParentName, XMLTreeNodeInfo infNode);

// Export UUIAPI_TREECTRL::execInsertNodeItem(FFrame&, void* const)
native static function InsertNodeItem(string ControlName, string NodeName, XMLTreeNodeItemInfo infNodeItem);

// Export UUIAPI_TREECTRL::execClear(FFrame&, void* const)
native static function Clear(string ControlName);

// Export UUIAPI_TREECTRL::execSetExpandedNode(FFrame&, void* const)
native static function SetExpandedNode(string ControlName, string NodeName, bool bExpanded);

// Export UUIAPI_TREECTRL::execGetExpandedNode(FFrame&, void* const)
native static function string GetExpandedNode(string ControlName, string NodeName);

// Export UUIAPI_TREECTRL::execDeleteNode(FFrame&, void* const)
native static function bool DeleteNode(string ControlName, string NodeName);

// Export UUIAPI_TREECTRL::execIsNodeNameExist(FFrame&, void* const)
native static function bool IsNodeNameExist(string ControlName, string NodeName);

// Export UUIAPI_TREECTRL::execIsExpandedNode(FFrame&, void* const)
native static function bool IsExpandedNode(string ControlName, string NodeName);

// Export UUIAPI_TREECTRL::execGetChildNode(FFrame&, void* const)
native static function string GetChildNode(string ControlName, string NodeName);

// Export UUIAPI_TREECTRL::execGetParentNode(FFrame&, void* const)
native static function string GetParentNode(string ControlName, string NodeName);

// Export UUIAPI_TREECTRL::execShowScrollBar(FFrame&, void* const)
native static function ShowScrollBar(string ControlName, bool bShow);

// Export UUIAPI_TREECTRL::execSetNodeItemText(FFrame&, void* const)
native static function SetNodeItemText(string ControlName, string NodeName, int nTextID, string strText);

// Export UUIAPI_TREECTRL::execSetNodeItemTexture(FFrame&, void* const)
native static function SetNodeItemTexture(string ControlName, string NodeName, int nTextID, string strTexture, int nWidth, int nHeight, int nType);

defaultproperties
{
}
