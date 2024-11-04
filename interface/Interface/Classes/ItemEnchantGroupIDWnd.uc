class ItemEnchantGroupIDWnd extends UICommonAPI;

var UIMapInt64Object groupIDs;

function _Init()
{
	local int i, Id;

	m_hOwnerWnd.HideWindow();
	groupIDs = new class'UIMapInt64Object';

	// End:0xC7 [Loop If]
	for(i = 0; GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0" $ string(i)).m_pTargetWnd != none; i++)
	{
		Id = i + 1;
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0" $ string(i) $ ".selectedTexture").HideWindow();
		_SetCurrentGroupIDPoint(Id, 0);
	}
}

function SetTooltips()
{
	local int i;

	// End:0x151 [Loop If]
	for(i = 0; GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0" $ string(i)).m_pTargetWnd != none; i++)
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0" $ string(i) $ ".point00Icon_Tex").ClearTooltip();
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0" $ string(i) $ ".point00Icon_Tex").SetTooltipType("text");
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0" $ string(i) $ ".point00Icon_Tex").SetTooltipCustomType(MakeTooltipSimpleText(GetTooltipByIndex(i)));
	}
}

function string GetTooltipByIndex(int Index)
{
	// End:0x4B
	if(! IsAdenServer() && getInstanceUIData().getIsClassicServer())
	{
		switch(Index)
		{
			// End:0x37
			case 1:
				return GetNpcString(1600080);
			// End:0x48
			case 2:
				return GetNpcString(1600081);
		}
	}
	switch(Index)
	{
		case 0:
			return GetNpcString(1600077);
		case 1:
			return GetNpcString(1600078);
		case 2:
			return GetNpcString(1600079);
		default:
			return "";
	}
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_ENCHANT_CHALLENGE_POINT_INFO));
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_GameStart);
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_ENCHANT_CHALLENGE_POINT_INFO):
			Handle_S_EX_ENCHANT_CHALLENGE_POINT_INFO();
			// End:0xCC
			break;
		// End:0x35
		case EV_Restart:
			ResetPoinsts();
			// End:0xCC
			break;
		// End:0xC9
		case EV_GameStart:
			// End:0xC0
			if(getInstanceUIData().getIsClassicServer())
			{
				// End:0x8E
				if(IsAdenServer())
				{
					GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd00").ShowWindow();					
				}
				else
				{
					GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd00").HideWindow();
				}
			}
			SetTooltips();
			// End:0xCC
			break;
	}
}

private function ResetPoinsts()
{
	local int i, Id;

	// End:0x6A [Loop If]
	for(i = 0; GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0" $ string(i)).m_pTargetWnd != none; i++)
	{
		Id = i + 1;
		_SetCurrentGroupIDPoint(Id, 0);
	}
}

private function Handle_S_EX_ENCHANT_CHALLENGE_POINT_INFO()
{
	local int i;
	local UIPacket._S_EX_ENCHANT_CHALLENGE_POINT_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_ENCHANT_CHALLENGE_POINT_INFO(packet))
	{
		return;
	}

	// End:0x71 [Loop If]
	for(i = 0; i < packet.vCurrentPointInfo.Length; i++)
	{
		_SetCurrentGroupIDPoint(packet.vCurrentPointInfo[i].nPointGroupId, packet.vCurrentPointInfo[i].nChallengePoint);
	}
}

function _AddCurrentGroupID(int Id)
{
	// End:0x0D
	if(Id <= 0)
	{
		return;
	}
	GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0" $ string(Id - 1) $ ".selectedTexture").ShowWindow();
}

function _HideCurrentGroupID()
{
	local int i;

	// End:0x9E [Loop If]
	for(i = 0; GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0" $ string(i)).m_pTargetWnd != none; i++)
	{
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0" $ string(i) $ ".selectedTexture").HideWindow();
	}
}

function _SetCurrentGroupID(int Id)
{
	local string Path;

	_HideCurrentGroupID();
	// End:0x13
	if(Id <= 0)
	{
		return;
	}
	Path = m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0" $ string(Id - 1);
	GetTextureHandle(Path $ ".selectedTexture").ShowWindow();
}

function _SetCurrentGroupIDPoint(int Id, int pnt)
{
	local string Path;

	Path = m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0" $ string(Id - 1) $ ".pnt_txt";
	groupIDs.Add(Id, pnt);
	GetTextBoxHandle(Path).SetText(string(pnt) $ "/" $ string(_GetMaxPoint()));
}

function int _GetPoint(int GroupID)
{
	return int(groupIDs.Find(GroupID));
}

function int _GetMaxPoint()
{
	local EnchantChallengePointSettingUIData o_data;

	API_GetEnchantChallengePointSettingData(o_data);
	return o_data.MaxPoint;
}

function _SetDisable()
{
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_tex").ShowWindow();
}

function _SetEnable()
{
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_tex").HideWindow();
}

function _ToggleShowHide()
{
	// End:0x1B
	if(m_hOwnerWnd.IsShowWindow())
	{
		_Hide();		
	}
	else
	{
		_Show();
	}
}

function _CheckShowHide()
{
	local int V;

	GetINIBool("ItemEnchantGroupIDWnd", "v", V, "Option.ini");
	Debug("_CheckShowHide" @ string(GetINIBool("ItemEnchantGroupIDWnd", "v", V, "Option.ini")) @ string(m_hOwnerWnd.IsShowWindow()) @ string(V));
	// End:0xFB
	if(GetINIBool("ItemEnchantGroupIDWnd", "v", V, "Option.ini"))
	{
		// End:0xE9
		if(V == 1)
		{
			m_hOwnerWnd.ShowWindow();			
		}
		else
		{
			m_hOwnerWnd.HideWindow();
		}		
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
	}
}

function _Show()
{
	m_hOwnerWnd.ShowWindow();
	SetINIBool("ItemEnchantGroupIDWnd", "v", true, "Option.ini");
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
	SetINIBool("ItemEnchantGroupIDWnd", "v", false, "Option.ini");
}

private function ItemInfo _GetItemInfoPoint(int GroupID)
{
	local ItemInfo iInfo;

	class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(_GetClassIDPoint(GroupID)), iInfo);
	return iInfo;
}

static function int _GetClassIDPoint(int GroupID)
{
	switch(GroupID)
	{
		// End:0x11
		case 1:
			return 96949;
		// End:0x1C
		case 2:
			return 96950;
		// End:0x27
		case 3:
			return 96951;
	}
}

function API_GetEnchantChallengePointSettingData(out EnchantChallengePointSettingUIData o_data)
{
	class'UIDATA_ITEM'.static.GetEnchantChallengePointSettingData(o_data);
}

defaultproperties
{
}
