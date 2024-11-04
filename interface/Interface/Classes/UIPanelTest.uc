class UIPanelTest extends UICommonAPI;

var UIControlTilelist scrollTester;
var UIControlTilelist scrollTesterV;

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	scrollTester = class'UIControlTilelist'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd"), 3, 2);
	scrollTester.DelegateOnItemRenderer = HandleDelegateOnItemRenderer;
	scrollTester.DelegateOnClick = HandleDelegateOnClick;
	scrollTester._SetUsePage(true);
	scrollTester._SetTileListItemNumTotal(100);
	scrollTesterV = class'UIControlTilelist'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWndV"), 2, 3, true);
	scrollTesterV.DelegateOnItemRenderer = HandleDelegateOnItemRenderer;
	scrollTesterV.DelegateOnClick = HandleDelegateOnClickV;
	scrollTesterV._SetTileListItemNumTotal(100);
}

function HandleDelegateOnItemRenderer(string itemRendererID, int rendererIndex, int Position)
{
	local int diceIndex;

	diceIndex = int(float(Position) % float(scrollTester._GetItemRendererNum()));
	// End:0xA0
	if(Position >= scrollTester._GetItemNumTotal())
	{
		GetTextureHandle(itemRendererID $ ".dice").HideWindow();
		GetTextBoxHandle(itemRendererID $ ".scrollText").SetText("IDX:Disabled!" @ "POS:" $ string(Position));		
	}
	else
	{
		GetTextureHandle(itemRendererID $ ".dice").ShowWindow();
		GetTextureHandle(itemRendererID $ ".dice").SetTexture("L2UI_CH3.Br_Score" $ string(diceIndex + 1));
		GetTextBoxHandle(itemRendererID $ ".scrollText").SetText(("IDX:" $ string(rendererIndex)) @ "POS:" $ string(Position));
	}
}

function HandleDelegateOnClick(string BTNID, int rendererIndex, int itemIndex)
{
	Debug("CLicked" @ BTNID @ string(rendererIndex) @ string(itemIndex) @ string(scrollTester._Page()) $ "/" $ string(scrollTester._PageMax()));	
}

function HandleDelegateOnClickV(string BTNID, int rendererIndex, int itemIndex)
{
	Debug("CLicked" @ BTNID @ string(rendererIndex) @ string(itemIndex) @ string(scrollTester._Page()) $ "/" $ string(scrollTesterV._PageMax()));	
}

event OnCompleteEditBox(string strID)
{
	Debug("OnCompleteEditBox" @ strID @ string(int(GetEditBoxHandle(strID).GetString())));
	scrollTester._SetTileListItemNumTotal(int(GetEditBoxHandle(strID).GetString()));
	scrollTesterV._SetTileListItemNumTotal(int(GetEditBoxHandle(strID).GetString()));	
}

event OnClickButton(string strID)
{
	local int randNum;

	switch(strID)
	{
		// End:0x1B
		case "ButtonUpdate":
			// End:0x117
			break;
		// End:0x82
		case "test0Button":
			randNum = Rand(int(GetEditBoxHandle("nomOfItem").GetString()));
			Debug("click 0 :" @ string(randNum));
			scrollTester._SetSelect(randNum, true);
			// End:0x117
			break;
		// End:0xE9
		case "test1Button":
			randNum = Rand(int(GetEditBoxHandle("nomOfItem").GetString()));
			Debug("click 1 :" @ string(randNum));
			scrollTesterV._SetSelect(randNum, true);
			// End:0x117
			break;
		// End:0xFC
		case "test2Button":
			// End:0x117
			break;
		// End:0x114
		case "ButtonResetParam":
			// End:0x117
			break;
	}
	Debug("OnClickButton" @ strID);	
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
}

defaultproperties
{
}
