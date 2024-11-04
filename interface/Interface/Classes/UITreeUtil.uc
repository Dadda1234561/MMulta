class UITreeUtil extends UIEventManager;

var TreeHandle m_UITree;
var string beforeClickedNode;
var UIMapStringObject MapStringReserved;

function _InitTree(TreeHandle tree)
{
	MapStringReserved = new class'UIMapStringObject';
	MapStringReserved.RemoveAll();
	m_UITree = tree;
	m_UITree.Clear();
	beforeClickedNode = "";
}

function string _makeNodeRoot(string MakeNodeName, optional int OffsetX, optional int OffsetY)
{
	local XMLTreeNodeInfo infNode;

	infNode.strName = MakeNodeName;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	return m_UITree.InsertNode("", infNode);
}

function string _makeEmptyNode(string ParentName, string MakeNodeName, optional bool bFollowCursor, optional int OffsetX, optional int OffsetY, optional CustomTooltip pCustomTooltip)
{
	local XMLTreeNodeInfo infNode;

	infNode.strName = MakeNodeName;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.bFollowCursor = bFollowCursor;
	infNode.ToolTip = pCustomTooltip;
	return m_UITree.InsertNode(ParentName, infNode);
}

function string _makeSelectNode(string ParentName, string MakeNodeName, optional int OffsetX, optional int OffsetY, optional int nTexExpandedHeight, optional CustomTooltip pCustomTooltip, optional int nTexExpandedOffSetX, optional int nTexExpandedOffSetY, optional int nTexExpandedLeftUWidth, optional int nTexExpandedLeftUHeight, optional string strTexExpandedLeft)
{
	local XMLTreeNodeInfo infNode;

	infNode.ToolTip = pCustomTooltip;
	infNode.strName = MakeNodeName;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.bFollowCursor = true;
	infNode.bShowButton = 0;
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;
	infNode.nTexExpandedHeight = nTexExpandedHeight;
	// End:0xD2
	if(strTexExpandedLeft == "")
	{
		strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
		infNode.nTexExpandedLeftUWidth = 32;
		infNode.nTexExpandedLeftUHeight = 38;		
	}
	else
	{
		infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth;
		infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	}
	infNode.strTexExpandedLeft = strTexExpandedLeft;
	return m_UITree.InsertNode(ParentName, infNode);
}

function string _makeExpandBtnNode(string ParentName, string MakeNodeName, optional int nTexBtnWidth, optional int nTexBtnHeight, optional string strTexBtnExpand, optional string strTexBtnExpand_Over, optional string strTexBtnCollapse, optional string strTexBtnCollapse_Over, optional int OffsetX, optional int OffsetY, optional CustomTooltip pCustomTooltip)
{
	local XMLTreeNodeInfo infNode;

	infNode.ToolTip = pCustomTooltip;
	// End:0x23
	if(nTexBtnWidth == 0)
	{
		nTexBtnWidth = 15;
	}
	// End:0x36
	if(nTexBtnHeight == 0)
	{
		nTexBtnHeight = 15;
	}
	// End:0x6B
	if(strTexBtnExpand == "")
	{
		strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndPlusBtn";
	}
	// End:0xA5
	if(strTexBtnExpand_Over == "")
	{
		strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndPlusBtn_over";
	}
	// End:0xDB
	if(strTexBtnCollapse == "")
	{
		strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndMinusBtn";
	}
	// End:0x116
	if(strTexBtnCollapse_Over == "")
	{
		strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndMinusBtn_over";
	}
	infNode.strName = MakeNodeName;
	infNode.bShowButton = 1;
	infNode.nTexBtnWidth = nTexBtnWidth;
	infNode.nTexBtnHeight = nTexBtnHeight;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.strTexBtnExpand = strTexBtnExpand;
	infNode.strTexBtnExpand_Over = strTexBtnExpand_Over;
	infNode.strTexBtnCollapse = strTexBtnCollapse;
	infNode.strTexBtnCollapse_Over = strTexBtnCollapse_Over;
	return m_UITree.InsertNode(ParentName, infNode);
}

function _makeTextItem(string NodeName, string strText, optional int OffsetX, optional int OffsetY, optional Color TextColor, optional bool oneline, optional bool bLineBreak, optional int nMaxHeight, optional int nMaxWidth, optional ETextVAlign eAlign, optional int nReserved, optional int nReserved2)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strText;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = OffsetX;
	infNodeItem.nOffSetY = OffsetY;
	infNodeItem.t_nMaxHeight = nMaxHeight;
	infNodeItem.t_nMaxWidth = nMaxWidth;
	// End:0xA1
	if(eAlign != TVA_Undefined)
	{
		infNodeItem.t_vAlign = eAlign;
	}
	infNodeItem.t_color = TextColor;
	// End:0xCC
	if(nReserved != 0)
	{
		infNodeItem.nReserved = nReserved;
	}
	// End:0xE7
	if(nReserved2 != 0)
	{
		infNodeItem.nReserved2 = nReserved2;
	}
	m_UITree.InsertNodeItem(NodeName, infNodeItem);
}

function _makeTextureItem(string NodeName, string TextureName, int TextureWidth, int TextureHeight, optional int OffsetX, optional int OffsetY, optional bool oneline, optional bool bLineBreak, optional int nTextureUWidth, optional int TextureUHeight, optional string strTextureMouseOn, optional string strTextureExpanded, optional int t_nTextID, optional int nReserved, optional int nReserved2)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = OffsetX;
	infNodeItem.nOffSetY = OffsetY;
	infNodeItem.t_nTextID = t_nTextID;
	infNodeItem.u_nTextureUWidth = nTextureUWidth;
	infNodeItem.u_nTextureUHeight = TextureUHeight;
	infNodeItem.u_nTextureWidth = TextureWidth;
	infNodeItem.u_nTextureHeight = TextureHeight;
	// End:0xC6
	if(TextureName == "")
	{
		TextureName = "L2UI_CT1.EmptyBtn";
	}
	infNodeItem.u_strTexture = TextureName;
	infNodeItem.u_strTextureMouseOn = strTextureMouseOn;
	infNodeItem.u_strTextureExpanded = strTextureExpanded;
	// End:0x111
	if(nReserved != 0)
	{
		infNodeItem.nReserved = nReserved;
	}
	// End:0x12C
	if(nReserved2 != 0)
	{
		infNodeItem.nReserved2 = nReserved2;
	}
	m_UITree.InsertNodeItem(NodeName, infNodeItem);
}

function _AllNodeExpanded(string NodeName, bool bOpen)
{
	local array<string> arrSplit;
	local string strChildList;
	local int i;

	strChildList = m_UITree.GetChildNode(NodeName);
	class'UICommonAPI'.static.Split(strChildList, "|", arrSplit);

	// End:0x77 [Loop If]
	for(i = 0; i < arrSplit.Length; i++)
	{
		m_UITree.SetExpandedNode(arrSplit[i], bOpen);
	}
}

function _ClickSelectNode(string NodeName)
{
	// End:0x24
	if(NodeName != beforeClickedNode)
	{
		m_UITree.SetExpandedNode(beforeClickedNode, false);
	}
	beforeClickedNode = NodeName;
}

function string _InsertNode(string ParentName, XMLTreeNodeInfo infNode)
{
	return m_UITree.InsertNode(ParentName, infNode);
}

function _InsertNodeItem(string ParentName, XMLTreeNodeItemInfo nodeItemInfo)
{
	m_UITree.InsertNodeItem(ParentName, nodeItemInfo);
}

function _SetExpandedNode(string NodeName, bool bExpanded)
{
	m_UITree.SetExpandedNode(NodeName, bExpanded);
}

function _SetNodeItemText(string NodeName, int nTextID, string strText)
{
	m_UITree.SetNodeItemText(NodeName, nTextID, strText);
}

function _SetNodeItemTexture(string NodeName, int nTextureID, string strTexture, int nWidth, int nHeight, optional int nType)
{
	m_UITree.SetNodeItemTexture(NodeName, nTextureID, strTexture, nWidth, nHeight, nType);
}

function string _GetExpandedNode(string NodeName)
{
	return m_UITree.GetExpandedNode(NodeName);
}

function string _GetParentNode(string NodeName)
{
	return m_UITree.GetParentNode(NodeName);
}

function string getMapStringReserved(string KeyStr)
{
	return MapStringReserved.Find(KeyStr);
}

function setMapStringReserved(string KeyStr, string dataStr)
{
	MapStringReserved.Add(KeyStr, dataStr);
}

function _TreeClear()
{
	m_UITree.Clear();
}

defaultproperties
{
}
