class HennaInfoPremiumWnd extends UICommonAPI;

// 문양 정보 윈도우의 상태
const HENNA_EQUIP = 1; // 문양새기기
const HENNA_UNEQUIP = 2; // 문양지우기

var int m_iState;
var int m_iHennaID;
var WindowHandle HennaInfoWndEquip;
var WindowHandle HennaInfoWndUnEquip;
var TextBoxHandle HennaJobText;
var ButtonHandle btnOk;
var UIControlNeedItem needItemScript;
var array<TextureHandle> EffectSkillSlotDisables;
var int nSubClass;
var bool bEnoughItemnum;

event OnRegisterEvent()
{
	RegisterEvent( EV_HennaInfoWndShowHidePremiumEquip);
	RegisterEvent( EV_HennaInfoWndShowHidePremiumUnEquip);
}

event OnLoad()
{
	SetClosingOnESC();
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtSTRString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3366), 154));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtDEXString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3368), 154));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtCONString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3370), 154));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtINTString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3367), 154));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtWITString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3369), 154));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtMENString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3371), 154));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtLUCString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3372), 154));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtCHAString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3373), 154));
	HennaInfoWndEquip = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip");
	HennaInfoWndUnEquip = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip");
	InitNeetItemScript();
}

event OnClickButton(string strID)
{
	class'UIAPI_WINDOW'.static.HideWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	switch(strID)
	{
		case "btnPrev" :
			if(m_iState==HENNA_EQUIP)
				RequestHennaItemList();
			else if(m_iState==HENNA_UNEQUIP)
				RequestHennaUnEquipList();
			GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).SetAnchor("HennaListWndLive", "TopLeft", "TopLeft", 0, 0);
			// End:0xDD
			break;
		case "btnOK" :
			if(m_iState==HENNA_EQUIP)
				RequestHennaEquip(m_iHennaID);
			else if(m_iState==HENNA_UNEQUIP)
				RequestHennaUnEquip(m_iHennaID);
			break;
	}
}

event OnEvent(int Event_ID, string param)
{
	Debug("OnEvent ! " @ string(Event_ID) @ param);
	switch(Event_ID)
	{
		case EV_HennaInfoWndShowHidePremiumEquip:
			SetFormEquip();
			ShowHennaInfoPremiumWnd(param);
			break;
		case EV_HennaInfoWndShowHidePremiumUnEquip :
			SetFormUnEQUIP();
			ShowHennaInfoPremiumWnd(param);
			break;
	}
}

private function SetFormEquip()
{
	local UserInfo Info;

	m_iState = HENNA_EQUIP;
	class'UIAPI_WINDOW'.static.SetWindowTitleByText(m_hOwnerWnd.m_WindowNameWithFullPath, GetSystemString(651));
	HennaInfoWndEquip.ShowWindow();
	HennaInfoWndUnEquip.HideWindow();
	GetPlayerInfo(Info);
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.HennaJobText").SetText(GetClassType(Info.nSubClass));	
}

private function SetFormUnEQUIP()
{
	m_iState = HENNA_UNEQUIP;
	class'UIAPI_WINDOW'.static.SetWindowTitleByText(m_hOwnerWnd.m_WindowNameWithFullPath, GetSystemString(652));
	HennaInfoWndEquip.HideWindow();
	HennaInfoWndUnEquip.ShowWindow();	
}

function ShowHennaInfoPremiumWnd(string param)
{
	local INT64 iAdena;
	local string strDyeName;			// 염료
	local string strDyeIconName;
	local int iHennaID;
	local int iClassID;
	local INT64 iFee;

	local string strTattooName;			// 문양
	local string strTattooAddName;		// 문양
	local string strTattooIconName;

	local int iINTnow;
	local int iINTchange;
	local int iSTRnow;
	local int iSTRchange;
	local int iCONnow;
	local int iCONchange;
	local int iMENnow;
	local int iMENchange;
	local int iDEXnow;
	local int iDEXchange;
	local int iWITnow;
	local int iWITchange, iLUCnow, iLUCchange, iCHAnow, iCHAchange;

	local string Description;
	local INT64 needCount, iNum;

	ParseINT64(param, "Adena", iAdena); // 아데나
	ParseString(param, "DyeIconName", strDyeIconName); // 염료 Icon 이름
	ParseString(param, "DyeName", strDyeName); // 염료이름
	ParseInt(param, "HennaID", iHennaID);
	ParseInt(param, "ClassID", iClassID);
	ParseINT64(param, "NumOfItem", iNum);
	ParseINT64(param, "Fee", iFee);
	ParseString(param, "TattooIconName", strTattooIconName);	// 문양아이콘이름
	ParseString(param, "TattooName", strTattooName);		// 문양이름
	ParseString(param, "TattooAddName", strTattooAddName);	// 문양정보 - 수치변동텍스트 
	ParseInt(param, "INTnow", iINTnow);
	ParseInt(param, "INTchange", iINTchange);
	ParseInt(param, "STRnow", iSTRnow);
	ParseInt(param, "STRchange", iSTRchange);
	ParseInt(param, "CONnow", iCONnow);
	ParseInt(param, "CONchange", iCONchange);
	ParseInt(param, "MENnow", iMENnow);
	ParseInt(param, "MENchange", iMENchange);
	ParseInt(param, "DEXnow", iDEXnow);
	ParseInt(param, "DEXchange", iDEXchange);
	ParseInt(param, "WITnow", iWITnow);
	ParseInt(param, "WITchange", iWITchange);
	ParseInt(param, "LUCnow", iLUCnow);
	ParseInt(param, "LUCchange", iLUCchange);
	ParseInt(param, "CHAnow", iCHAnow);
	ParseInt(param, "CHAchange", iCHAchange);
	ParseString(param, "Description", Description);
	m_iHennaID = iHennaID;
	// End:0x6F2
	if(m_iState == 1)
	{
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtDyeInfo", GetSystemString(638));
		class'UIAPI_TEXTURECTRL'.static.SetTexture(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.textureDyeIconName", strDyeIconName);
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtDyeName", strDyeName);
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtNeedItemString", GetSystemString(2380) $ " : ");
		ParseINT64(param, "NeedCount", needCount);
		bEnoughItemnum = iNum >= needCount;
		// End:0x491
		if(! bEnoughItemnum)
		{
			class'UIAPI_TEXTBOX'.static.SetTextColor(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtCurrentItemNum", GetColor(255, 0, 0, 255));			
		}
		else
		{
			class'UIAPI_TEXTBOX'.static.SetTextColor(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtCurrentItemNum", GetColor(0, 176, 255, 255));
		}
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtCurrentItemNum", string(iNum));
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtNeedItemNum", "/" $ string(needCount));
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtTattooInfo", GetSystemString(639));
		class'UIAPI_TEXTURECTRL'.static.SetTexture(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.textureTattooIconName", strTattooIconName);
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtTattooName", strTattooName);
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtTattooAddName", strTattooAddName);
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.HennaDescTextBox", Description);		
	}
	else if(m_iState == HENNA_UNEQUIP)
	{
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtTattooInfoUnEquip", GetSystemString(639));
		class'UIAPI_TEXTURECTRL'.static.SetTexture(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.textureTattooIconNameUnEquip", strTattooIconName);
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtTattooNameUnEquip", strTattooName);
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtTattooAddNameUnEquip", strTattooAddName);
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtDyeInfoUnEquip", GetSystemString(638));
		class'UIAPI_TEXTURECTRL'.static.SetTexture(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.textureDyeIconNameUnEquip", strDyeIconName);
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtDyeNameUnEquip", strDyeName);
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtNeedItemString", "");
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtCurrentItemNum", "");
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtNeedItemNum", "");
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtAdenaStringUnEquip", GetSystemString(469));
		class'UIAPI_TEXTBOX'.static.SetTextColor(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtAdenaStringUnEquip", GetColor(255, 255, 0, 255));
		class'UIAPI_TEXTBOX'.static.SetText(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.HennaDescTextBox", Description);
	}
	updateNeedItem(iFee);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtSTRBefore", iSTRnow);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtSTRAfter", iSTRchange);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtDEXBefore", iDEXnow);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtDEXAfter", iDEXchange);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtCONBefore", iCONnow);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtCONAfter", iCONchange);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtINTBefore", iINTnow);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtINTAfter", iINTchange);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtWITBefore", iWITnow);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtWITAfter", iWITchange);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtMENBefore", iMENnow);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtMENAfter", iMENchange);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtLUCBefore", iLUCnow);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtLUCAfter", iLUCchange);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtCHABefore", iCHAnow);
	class'UIAPI_TEXTBOX'.static.SetInt(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtCHAAfter", iCHAchange);
	class'UIAPI_WINDOW'.static.HideWindow("HennaListWndLive");
	class'UIAPI_WINDOW'.static.ShowWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	class'UIAPI_WINDOW'.static.SetFocus(m_hOwnerWnd.m_WindowNameWithFullPath);
	GetWindowHandle("HennaListWndLive").SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 0, 0);	
}

private function updateNeedItem(INT64 needNum)
{
	local WindowHandle needItemWnd;

	needItemScript.SetNumNeed(needNum);
	Debug("UpdateNeedItem" @ string(needNum) @ string(needItemScript.canBuy()) @ string(needItemWnd.IsShowWindow()) @ needItemWnd.GetWindowName());
}

private function InitNeetItemScript()
{
	local WindowHandle needItemWnd;

	needItemWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem");
	needItemWnd.SetScript("UIControlNeedItem");
	needItemScript = UIControlNeedItem(needItemWnd.GetScript());
	needItemScript.Init(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem");
	needItemScript.setId(GetItemID(57));
	needItemScript.DelegateItemUpdate = DelegateNeedItemOnUpdateItem;	
}

private function DelegateNeedItemOnUpdateItem(UIControlNeedItem script)
{
	// End:0x48
	if(script.canBuy() && bEnoughItemnum)
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnOK").EnableWindow();		
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnOK").DisableWindow();
	}	
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).HideWindow();
}

defaultproperties
{
}
