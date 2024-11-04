class HennaInfoWnd extends UICommonAPI;

// ?�®?з ?¤?? ?©µµ?м?? »???
const HENNA_EQUIP=1;		// ?�®?з»?±в±в
const HENNA_UNEQUIP=2;		// ?�®?з???м±в
const DIALOG_ID_ADD = 12302;
const DIALOG_ID_DEL = 12303;

var int m_iState;
var int m_iHennaID;
var int m_iClassID;
var int m_iSeverID;

function OnRegisterEvent()
{
	RegisterEvent(EV_HennaInfoWndShowHideEquip);
	RegisterEvent(EV_HennaInfoWndShowHideUnEquip);
	RegisterEvent(EV_NeedResetUIData);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_EQUIP);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_UNEQUIP);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
}

function OnLoad()
{
	SetClosingOnESC();

	OnRegisterEvent();

	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtSTRString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3366), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtDEXString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3368), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtCONString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3370), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtINTString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3367), 154));

	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtWITString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3369), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtMENString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3371), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtLUCString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3372), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtCHAString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3373), 154));
	
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnPrev" :
			if(m_iState==HENNA_EQUIP)
			{
				RequestHennaItemList();
			}
			class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd");
			// End:0xFB
			break;
		case "btnOK" :
			if(m_iState==HENNA_EQUIP)
			{
				DialogSetID(12302);
				DialogSetCancelD(12302);
				DialogSetDefaultCancle();
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(13906), string(self));
			}
			// End:0xFB
			break;
		// End:0xE2
		case "btnextract":
			// End:0xDF
			if(m_iState == HENNA_UNEQUIP)
			{
				DialogSetID(12303);
				DialogSetCancelD(12303);
				DialogSetDefaultCancle();
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(13907), string(self));
			}
			// End:0xFB
			break;
		// End:0xF8
		case "EXIT_Btn":
			OnReceivedCloseUI();
			// End:0xFB
			break;
	}
}

function OnShow()
{
	// »????? µ?¶? ?©µµ?¦ ???©?Ц°н ??°Ь?Э???Щ
	if(m_iState == HENNA_EQUIP)
	{
		// ?????? - ?�®?з»?±в±в
		setWindowTitleByString(GetSystemString(651));
		class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.HennaInfoWndUnEquip");
		class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.HennaInfoWndEquip");
	}
	else if(m_iState==HENNA_UNEQUIP)
	{
		// ?????? - ?�®?з???м±в
		setWindowTitleByString(GetSystemString(652));
		class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.HennaInfoWndEquip");
		class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.HennaInfoWndUnEquip");
	}
	else
	{
		//debug("??·???·? ??»???»?~~");
	}
}

function OnHide()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "HennaListWnd");
	// End:0x36
	if(DialogIsMine())
	{
		DialogHide();
	}
}

function OnEvent(int Event_ID, string param)
{
	// End:0x17
	if( getInstanceUIData().getIsClassicServer())
	{
		return;
	}
	switch(Event_ID)
	{
		// End:0x89
		case EV_DialogOK:
			// End:0x86
			if(DialogIsMine())
			{
				// End:0x70
				if((DialogGetID()) == 12302)
				{
					API_C_EX_NEW_HENNA_EQUIP(HennaMenuWnd(GetScript("HennaMenuWnd")).getSelectIndexSlot(), m_iSeverID);					
				}
				else if((DialogGetID()) == 12303)
				{
					API_C_EX_NEW_HENNA_UNEQUIP();
				}
			}
			// End:0x4B3
			break;
		// End:0x94
		case EV_DialogCancel:
			// End:0x4B3
			break;
	case EV_HennaInfoWndShowHideEquip :
			m_iState=HENNA_EQUIP;		// »????¦ "?�®?з»?±в±в"·? ?�Щ?Я???Щ.
			GetButtonHandle("HennaInfoWnd.btnPrev").ShowWindow();
			GetButtonHandle("HennaInfoWnd.btnOK").ShowWindow();
			GetButtonHandle("HennaInfoWnd.btnextract").HideWindow();
			ShowHennaInfoWnd(param);
			break;
	case EV_HennaInfoWndShowHideUnEquip :
			m_iState=HENNA_UNEQUIP;		// »????¦ "?�®?з???м±в"·? ?�Щ?Я???Щ.
			GetButtonHandle("HennaInfoWnd.btnPrev").HideWindow();
			GetButtonHandle("HennaInfoWnd.btnOK").HideWindow();
			GetButtonHandle("HennaInfoWnd.btnextract").ShowWindow();
			ShowHennaInfoWnd(param);
			break;
	case EV_NeedResetUIData :       // »????¦ LUC, CHA?¦ ?­?�? ?????? µ?¶? ????°??? ?????? ??°Ф ?Х???Щ.
		
		if(!getInstanceUIData().getIsClassicServer())
		{
			class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtLUCString");
			class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtLUCBefore");
			class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtLUCArrow");
			class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtLUCAfter");
			class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtCHAString");
			class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtCHABefore");
			class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtCHAArrow");
			class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtCHAAfter");		
		}
		else 
		{
			class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtLUCString");
			class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtLUCBefore");
			class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtLUCArrow");
			class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtLUCAfter");
			class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtCHAString");
			class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtCHABefore");
			class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtCHAArrow");
			class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtCHAAfter");		
		}
		break;
		// End:0x48F
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_EQUIP:
			ParsePacket_S_EX_NEW_HENNA_EQUIP();
			// End:0x4B3
			break;
		// End:0x4B0
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_UNEQUIP:
			ParsePacket_S_EX_NEW_HENNA_UNEQUIP();
			// End:0x4B3
			break;
	}
}

function ParsePacket_S_EX_NEW_HENNA_EQUIP()
{
	local UIPacket._S_EX_NEW_HENNA_EQUIP packet;
	local ItemInfo dyeItemInfo;
	local int dyeItemClassID;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_NEW_HENNA_EQUIP(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_NEW_HENNA_EQUIP :  " @ string(packet.cSlotID) @ string(packet.nHennaID) @ string(packet.cSuccess));
	class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd");
	class'UIAPI_WINDOW'.static.ShowWindow("HennaMenuWnd");
	class'UIAPI_WINDOW'.static.SetFocus("HennaMenuWnd");
	class'UIDATA_HENNA'.static.GetHennaDyeItemClassID(packet.nHennaID, dyeItemClassID);
	dyeItemInfo = GetItemInfoByClassID(dyeItemClassID);
	Debug("?�착 dyeItemInfo" @ dyeItemInfo.Name);
	// End:0x147
	if(packet.cSuccess > 0)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(877));
	}
}

function ParsePacket_S_EX_NEW_HENNA_UNEQUIP()
{
	local UIPacket._S_EX_NEW_HENNA_UNEQUIP packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_NEW_HENNA_UNEQUIP(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_NEW_HENNA_UNEQUIP :  " @ string(packet.cSlotID) @ string(packet.cSuccess));
	class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd");
	class'UIAPI_WINDOW'.static.ShowWindow("HennaMenuWnd");
	class'UIAPI_WINDOW'.static.SetFocus("HennaMenuWnd");
	// End:0xE8
	if(packet.cSuccess > 0)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(878));
	}
}

function ShowHennaInfoWnd(string param)
{
	local string strAdenaComma;

	local INT64 iAdena;
	local string strDyeName;			// ?°·б
	local string strDyeIconName;
	local int iHennaID;
	local int iClassID;
	local INT64 iNum;
	local INT64 iFee;

	local string strTattooName;			// ?�®?з
	local string strTattooAddName;		// ?�®?з
	local string strTattooIconName;

	local int iINTnow, iINTchange, iSTRnow, iSTRchange, iCONnow, iCONchange,
		iMENnow, iMENchange, iDEXnow, iDEXchange, iWITnow,
		iWITchange, iLUCnow, iLUCchange, iCHAnow, iCHAchange,
		dyeItemlevel, iNeedCount, iCancelCount;

	local color col;
	local array<ItemInfo> itemInfoArray;

	ParseINT64(param, "Adena", iAdena);						// ??µ???
	ParseString(param, "DyeIconName", strDyeIconName);		// ?°·б Icon ???§
	ParseString(param, "DyeName", strDyeName);				// ?°·б???§
	ParseInt(param, "HennaID", iHennaID);				 
	ParseInt(param, "ClassID", iClassID);
	ParseINT64(param, "NumOfItem", iNum);
	ParseINT64(param, "Fee", iFee);

	ParseString(param, "TattooIconName", strTattooIconName);	// ?�®?з?????Ь???§
	ParseString(param, "TattooName", strTattooName);		// ?�®?з???§
	ParseString(param, "TattooAddName", strTattooAddName);	// ?�®?з?¤?? - ??????µ??Ш???® 

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
	
	//??±Ф???? ·°?°, ?«?®???¶
	ParseInt(param, "LUCnow", iLUCnow);
	ParseInt(param, "LUCchange", iLUCchange);
	ParseInt(param, "CHAnow", iCHAnow);
	ParseInt(param, "CHAchange", iCHAchange);


	m_iHennaID=iHennaID;		// ?�®?з?» »?±в°??? ?¦°??Т¶§ ???д???�?·? ID?¦ ???е?ШµУ???Щ
	m_iClassID = iClassID;
	class'UIDATA_HENNA'.static.GetHennaDyeItemLevel(iHennaID, dyeItemlevel);
	class'UIDATA_INVENTORY'.static.FindItemByClassID(m_iClassID, itemInfoArray);
	m_iSeverID = itemInfoArray[0].Id.ServerID;
	// End:0x67B
	if(m_iState == HENNA_EQUIP)
	{
		ParseInt(param, "NeedCount", iNeedCount);
		// ?°·б
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeInfo", GetSystemString(638));			// "?°·б?¤??"
		class'UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureDyeIconName", strDyeIconName);	// ?°·б Icon
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeName", strDyeName);						// ?°·б???§

		col.R=168;
		col.G=168;
		col.B=168;
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtFee", GetSystemString(637)$ " : ");		// "????·б : "
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtFee", col);		

		strAdenaComma = MakeCostString(string(iFee));
		col= GetNumericColor(strAdenaComma);
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdena", strAdenaComma);		// ????·б ??µ??? ???Ъ
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdena", col);

		col.R=255;
		col.G=255;
		col.B=0;
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdenaString", GetSystemString(469));		// "??µ???"
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdenaString", col);		


		// ?�®?з
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooInfo", GetSystemString(639));		// "?�®?з?¤??"
		class'UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureTattooIconName", strTattooIconName);	// ?�®?з Icon
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooName", strTattooName);		// ?�®?з???§
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooAddName", strTattooAddName);
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeNeedItem", MakeFullSystemMsg(GetSystemMessage(2781), string(iNeedCount)));
	}
	else if(m_iState==HENNA_UNEQUIP)
	{
		ParseInt(param, "CancelCount", iCancelCount);
		// ?�®?з
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooInfoUnEquip", GetSystemString(639));		// "?�®?з?¤??"
		class'UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureTattooIconNameUnEquip", strTattooIconName);	// ?�®?з Icon
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooNameUnEquip", GetSystemString(652)$":"$strTattooName);		// ?�®?з???§
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooAddNameUnEquip", strTattooAddName);		// ?�®?з??°??¤??

		// ?°·б
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeInfoUnEquip", GetSystemString(638));			// "?°·б?¤??"
		class'UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureDyeIconNameUnEquip", strDyeIconName);	// ?°·б Icon
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeNameUnEquip", strDyeName);						// ?°·б???§

		col.R=168;
		col.G=168;
		col.B=168;
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtFeeUnEquip", GetSystemString(637)$ " : ");		// "????·б : "
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtFeeUnEquip", col);		

		strAdenaComma = MakeCostString(string(iFee));
		col= GetNumericColor(strAdenaComma);
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdenaUnEquip", strAdenaComma);		// ????·б ??µ??? ???Ъ
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdenaUnEquip", col);

		col.R=255;
		col.G=255;
		col.B=0;
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdenaStringUnEquip", GetSystemString(469));		// "??µ???"
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdenaStringUnEquip", col);		
			class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.HennaInfoWndUnEquip.txtTattooNameStepUnEquip", MakeFullSystemMsg(GetSystemMessage(5203), string(dyeItemlevel)));
			class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.HennaInfoWndUnEquip.txtDyeExtractItemUnEquip", MakeFullSystemMsg(GetSystemMessage(2781), string(iCancelCount)));
	}

	// End:0xB1E
	if(iNeedCount <= iNum)
	{
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtDyeNeedItem", GTColor().White);		
	}
	else
	{
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtDyeNeedItem", GTColor().Red);
	}
	class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooNameStep", MakeFullSystemMsg(GetSystemMessage(5203), string(dyeItemlevel)));
	// ???????­
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtSTRBefore", iSTRnow);		// STR ???з
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtSTRAfter", iSTRchange);		// STR ???­??
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtDEXBefore", iDEXnow);		// DEX ???з
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtDEXAfter", iDEXchange);		// DEX ???­??
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCONBefore", iCONnow);		// CON ???з
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCONAfter", iCONchange);		// CON ???­??
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtINTBefore", iINTnow);		// INT ???з
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtINTAfter", iINTchange);		// INT ???­??
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtWITBefore", iWITnow);		// WIT ???з
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtWITAfter", iWITchange);		// WIT ???­??
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtMENBefore", iMENnow);		// MEN ???з
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtMENAfter", iMENchange);		// MEN ???­??

	//??±Ф???? ·°?°, ?«?®???¶
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtLUCBefore", iLUCnow);		// LUC ???з
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtLUCAfter", iLUCchange);		// LUC ???­??
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCHABefore", iCHAnow);		// CHA ???з
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCHAAfter", iCHAchange);		// CHA ???­??

	//??µ???(,)
	strAdenaComma = MakeCostString(string(iAdena));
	col = GetNumericColor(strAdenaComma);
	class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtHaveAdena", strAdenaComma);		// ??µ??? ???Ъ
	class'UIAPI_TEXTBOX'.static.SetTooltipString("HennaInfoWnd.txtHaveAdena", ConvertNumToText(string(iAdena)));

	class'UIAPI_WINDOW'.static.HideWindow("HennaListWnd");

	class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd");
	class'UIAPI_WINDOW'.static.SetFocus("HennaInfoWnd");
}

function API_C_EX_NEW_HENNA_EQUIP(int nSlotID, int nItemSid)
{
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_EQUIP packet;

	packet.cSlotID = nSlotID;
	packet.nItemSid = nItemSid;
	// End:0x40
	if(! class'UIPacket'.static.Encode_C_EX_NEW_HENNA_EQUIP(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_NEW_HENNA_EQUIP, stream);
	Debug("Api Call -----> C_EX_NEW_HENNA_EQUIP" @ string(packet.cSlotID) @ string(packet.nItemSid));
}

function API_C_EX_NEW_HENNA_UNEQUIP()
{
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_UNEQUIP packet;

	packet.cSlotID = HennaMenuWnd(GetScript("HennaMenuWnd")).getSelectIndexSlot();
	// End:0x4E
	if(! class'UIPacket'.static.Encode_C_EX_NEW_HENNA_UNEQUIP(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_NEW_HENNA_UNEQUIP, stream);
	Debug("Api Call -----> C_EX_NEW_HENNA_UNEQUIP" @ string(packet.cSlotID));
}

/**
 * ?©µµ?м ESC ?°·? ?Э±в ???® 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("HennaInfoWnd").HideWindow();
	ShowWindowWithFocus("HennaMenuWnd");
}

defaultproperties
{
}
