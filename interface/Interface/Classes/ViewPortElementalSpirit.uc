class ViewPortElementalSpirit extends ViewPortWndBase;

var int currentNpcInfoID;

function SetNPCInfo(int Index)
{
	if(currentNpcInfoID == Index)
	{
		return;
	}
	currentNpcInfoID = Index;
	m_ObjectViewport.SetNPCInfo(Index);
}

defaultproperties
{
}
