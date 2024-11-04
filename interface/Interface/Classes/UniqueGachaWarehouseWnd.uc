class UniqueGachaWarehouseWnd extends UICommonAPI;

const MAX_GACHA_INVEN = 1100;
const DIALOG_TOP_TO_BOTTOM = 1111;
const DIALOG_BOTTOM_TO_TOP = 2222;

var WindowHandle Me;
var string m_WindowName;
var ItemWindowHandle m_topList;
var ItemWindowHandle m_bottomList;
var int m_numPossibleSlotCount;
var int m_maxInventoryCount;
var array<int> hasStackableItemArray;

function OnRegisterEvent()
{
	RegisterEvent(100000 + class'UIPacket'.const.S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST);
	RegisterEvent(100000 + class'UIPacket'.const.S_EX_UNIQUE_GACHA_INVEN_GET_ITEM);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(2070);
	RegisterEvent(10140);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
}

function DelegateOnHide()
{
	m_topList.EnableWindow();
	m_bottomList.EnableWindow();
	Debug("DelegateOnHide");
}

function Initialize()
{
	Me = GetWindowHandle("UniqueGachaWarehouseWnd");
	m_topList = GetItemWindowHandle(m_WindowName $ ".TopList");
	m_bottomList = GetItemWindowHandle(m_WindowName $ ".BottomList");
}

function Load()
{
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "SortButton":
			OnSortButtonClick();
			break;
		case "OKButton":
			OnOKButtonClick();
			break;
		case "CancelButton":
			OnCancelButtonClick();
			break;
	}
}

function OnSortButtonClick()
{
	getInstanceL2Util().SortItem(m_topList);
}

function OnOKButtonClick()
{
	API_C_EX_UNIQUE_GACHA_INVEN_GET_ITEM();
	Me.HideWindow();
}

function OnCancelButtonClick()
{
	Me.HideWindow();
}

function OnShow()
{
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
	}
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	hasStackableItemArray.Remove(0, hasStackableItemArray.Length);
	m_bottomList.Clear();
	m_topList.DisableWindow();
	m_bottomList.DisableWindow();
	checkEnableOKButton();
	class'UIAPI_INVENWEIGHT'.static.ZeroWeight("UniqueGachaWarehouseWnd.InvenWeight");
	refreshPossibleSlotCount();
	API_C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST();
}

function checkEnableOKButton()
{
	if(m_bottomList.GetItemNum() > 0)
	{
		GetMeButton("OKButton").EnableWindow();		
	}
	else
	{
		GetMeButton("OKButton").DisableWindow();
	}
}

function OnHide()
{
	if((DialogIsMine()) && IsShowWindow("DialogBox"))
	{
		DialogHide();
	}
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	local int Index, nItemCount;

	if((strID == "TopList") && Info.DragSrcName == "BottomList")
	{
		Index = m_bottomList.FindItemWithAllProperty(Info);

		if(Index >= 0)
		{
			if(HasStackableItemCheck(Info.Id.ClassID))
			{
				MoveItemBottomToTop(Index, Info.AllItemCount > 0);
			}
		}		
	}
	else
	{
		if((strID == "BottomList") && Info.DragSrcName == "TopList")
		{
			Index = m_topList.FindItemWithAllProperty(Info);

			if(m_bottomList.GetItemNum() > 0)
			{
				nItemCount = m_bottomList.GetItemNum() - hasStackableItemArray.Length;				
			}
			else
			{
				nItemCount = 0;
			}
			if(Index >= 0)
			{
				if((m_numPossibleSlotCount > nItemCount) || ((HasStackableItemCheck(Info.Id.ClassID)) && IsStackableItem(Info.ConsumeType)) && m_numPossibleSlotCount >= nItemCount)
				{
					MoveItemTopToBottom(Index, Info.AllItemCount > 0);					
				}
				else
				{
					AddSystemMessage(3675);
				}
			}
		}
	}
}

function bool HasStackableItemCheck(int ItemClassID)
{
	local bool bReturn;

	if(IsStackableItem(GetItemInfoByClassID(ItemClassID).ConsumeType))
	{
		bReturn = class'UIDATA_INVENTORY'.static.HasItemByClassID(ItemClassID);
	}
	Debug("HasStackableItemCheck" @ string(bReturn));
	return bReturn;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
	local ItemInfo topInfo, bottomInfo;
	local int bottomIndex;

	if(m_topList.GetItem(Index, topInfo))
	{
		if((!bAllItem && IsStackableItem(topInfo.ConsumeType)) && topInfo.ItemNum > 1)
		{
			m_topList.DisableWindow();
			m_bottomList.DisableWindow();
			DialogSetID(1111);
			DialogSetReservedItemID(topInfo.Id);
			DialogSetParamInt64(topInfo.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), topInfo.Name, ""), string(self));
			class'DialogBox'.static.Inst().__DelegateOnHide__Delegate = DelegateOnHide;			
		}
		else
		{
			bottomIndex = m_bottomList.FindItem(topInfo.Id);

			if((bottomIndex != -1) && IsStackableItem(topInfo.ConsumeType))
			{
				m_bottomList.GetItem(bottomIndex, bottomInfo);
				bottomInfo.ItemNum += topInfo.ItemNum;
				m_bottomList.SetItem(bottomIndex, bottomInfo);				
			}
			else
			{
				m_bottomList.AddItem(topInfo);
			}
			m_topList.DeleteItem(Index);
			class'UIAPI_INVENWEIGHT'.static.AddWeight("UniqueGachaWarehouseWnd.InvenWeight", topInfo.ItemNum * topInfo.Weight);

			if(HasStackableItemCheck(topInfo.Id.ClassID))
			{
				addHasStackableItemArray(topInfo.Id.ClassID);
			}
			refreshPossibleSlotCount();
			checkEnableOKButton();
		}
	}
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
	local ItemInfo bottomInfo, topInfo;
	local int topIndex;

	if(m_bottomList.GetItem(Index, bottomInfo))
	{
		if((!bAllItem && IsStackableItem(bottomInfo.ConsumeType)) && bottomInfo.ItemNum > 1)
		{
			m_topList.DisableWindow();
			m_bottomList.DisableWindow();
			DialogSetID(2222);
			DialogSetReservedItemID(bottomInfo.Id);
			DialogSetParamInt64(bottomInfo.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), bottomInfo.Name, ""), string(self));
			class'DialogBox'.static.Inst().__DelegateOnHide__Delegate = DelegateOnHide;
		}
		else
		{
			topIndex = m_topList.FindItem(bottomInfo.Id);

			if((topIndex != -1) && IsStackableItem(bottomInfo.ConsumeType))
			{
				m_topList.GetItem(topIndex, topInfo);
				topInfo.ItemNum += bottomInfo.ItemNum;
				m_topList.SetItem(topIndex, topInfo);				
			}
			else
			{
				m_topList.AddItem(bottomInfo);
			}
			m_bottomList.DeleteItem(Index);
			class'UIAPI_INVENWEIGHT'.static.ReduceWeight("UniqueGachaWarehouseWnd.InvenWeight", bottomInfo.ItemNum * bottomInfo.Weight);

			if((findHasStackableItemArray(bottomInfo.Id.ClassID)) != -1)
			{
				removeHasStackableItemArray(bottomInfo.Id.ClassID);
			}
			refreshPossibleSlotCount();
			checkEnableOKButton();
		}
	}
}

function HandleDialogOK()
{
	local int Id, Index, topIndex;
	local INT64 Num;
	local ItemInfo Info, topInfo;
	local ItemID cID;

	if(DialogIsMine())
	{
		m_topList.EnableWindow();
		m_bottomList.EnableWindow();
		Id = DialogGetID();
		Num = INT64(DialogGetString());
		cID = DialogGetReservedItemID();

		if(Id == 1111 && Num > 0)
		{
			topIndex = m_topList.FindItem(cID);

			if(topIndex >= 0)
			{
				m_topList.GetItem(topIndex, topInfo);
				Num = Min64(Num, topInfo.ItemNum);
				Index = m_bottomList.FindItem(cID);

				if(Index >= 0)
				{
					m_bottomList.GetItem(Index, Info);
					Info.ItemNum += Num;
					m_bottomList.SetItem(Index, Info);					
				}
				else
				{
					Info = topInfo;
					Info.ItemNum = Num;
					m_bottomList.AddItem(Info);
				}
				class'UIAPI_INVENWEIGHT'.static.AddWeight("UniqueGachaWarehouseWnd.InvenWeight", Num * Info.Weight);
				topInfo.ItemNum -= Num;

				if(topInfo.ItemNum <= 0)
				{
					m_topList.DeleteItem(topIndex);					
				}
				else
				{
					m_topList.SetItem(topIndex, topInfo);
				}

				if(HasStackableItemCheck(topInfo.Id.ClassID))
				{
					addHasStackableItemArray(topInfo.Id.ClassID);
				}
			}			
		}
		else
		{
			if(Id == 2222 && Num > 0)
			{
				Index = m_bottomList.FindItem(cID);

				if(Index >= 0)
				{
					m_bottomList.GetItem(Index, Info);
					Num = Min64(Num, Info.ItemNum);
					Info.ItemNum -= Num;

					if(Info.ItemNum > 0)
					{
						m_bottomList.SetItem(Index, Info);						
					}
					else
					{
						if((findHasStackableItemArray(Info.Id.ClassID)) != -1)
						{
							removeHasStackableItemArray(Info.Id.ClassID);
						}
						m_bottomList.DeleteItem(Index);
					}
					topIndex = m_topList.FindItem(cID);

					if((topIndex >= 0) && IsStackableItem(Info.ConsumeType))
					{
						m_topList.GetItem(topIndex, topInfo);
						topInfo.ItemNum += Num;
						m_topList.SetItem(topIndex, topInfo);						
					}
					else
					{
						Info.ItemNum = Num;
						m_topList.AddItem(Info);
					}
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight("UniqueGachaWarehouseWnd.InvenWeight", Num * Info.Weight);
				}
			}
		}
		refreshPossibleSlotCount();
		checkEnableOKButton();
	}
}

function refreshPossibleSlotCount()
{
	GetMeTextBox("TopCountText").SetText((string(m_topList.GetItemNum()) $ "/") $ string(1100));
	m_numPossibleSlotCount = m_maxInventoryCount - (InventoryWnd(GetScript("InventoryWnd")).m_NormalInvenCount + InventoryWnd(GetScript("InventoryWnd")).EquipNormalItemGetItemNum());
	GetMeTextBox("BottomCountText").SetText((string(m_bottomList.GetItemNum() - hasStackableItemArray.Length) $ "/") $ string(m_numPossibleSlotCount));
	Debug("hasStackableItemArray.Length" @ string(hasStackableItemArray.Length));
}

function OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;
	local int nItemCount;

	if(ControlName == "TopList")
	{
		if(Index >= 0)
		{
			m_topList.GetSelectedItem(Info);

			if(m_bottomList.GetItemNum() > 0)
			{
				nItemCount = m_bottomList.GetItemNum() - hasStackableItemArray.Length;				
			}
			else
			{
				nItemCount = 0;
			}
			if((m_numPossibleSlotCount > nItemCount) || ((HasStackableItemCheck(Info.Id.ClassID)) && IsStackableItem(Info.ConsumeType)) && m_numPossibleSlotCount >= nItemCount)
			{
				MoveItemTopToBottom(Index, class'InputAPI'.static.IsAltPressed());				
			}
			else
			{
				AddSystemMessage(3675);
			}
		}		
	}
	else
	{
		if(ControlName == "BottomList")
		{
			MoveItemBottomToTop(Index, class'InputAPI'.static.IsAltPressed());
		}
	}
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case EV_PacketID(class'UIPacket'.const.S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST):
			ParsePacket_S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_UNIQUE_GACHA_INVEN_GET_ITEM):
			ParsePacket_S_EX_UNIQUE_GACHA_INVEN_GET_ITEM();
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			Debug("EV_DialogCancel" @ a_Param);
			break;
		case 2070:
			HandleSetMaxCount(a_Param);
			break;
		case 10140:
			if(Me.IsShowWindow())
			{
				Me.HideWindow();
			}
			break;
	}
}

function HandleSetMaxCount(string param)
{
	ParseInt(param, "Inventory", m_maxInventoryCount);
}

function API_C_EX_UNIQUE_GACHA_INVEN_GET_ITEM()
{
	local array<byte> stream;
	local UIPacket._C_EX_UNIQUE_GACHA_INVEN_GET_ITEM packet;
	local int i;
	local ItemInfo Info;

	if(m_bottomList.GetItemNum() > 0)
	{
		packet.getItems.Length = m_bottomList.GetItemNum();

		for(i = 0; i < m_bottomList.GetItemNum(); i++)
		{
			m_bottomList.GetItem(i, Info);
			packet.getItems[i].nItemType = Info.Id.ClassID;
			packet.getItems[i].nAmount = Info.ItemNum;
		}
		if(!class'UIPacket'.static.Encode_C_EX_UNIQUE_GACHA_INVEN_GET_ITEM(stream, packet))
		{
			return;
		}
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_UNIQUE_GACHA_INVEN_GET_ITEM, stream);
		Debug("API C_EX_UNIQUE_GACHA_INVEN_GET_ITEM :" @ string(packet.getItems.Length));
	}
}

function API_C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST packet;

	packet.cInvenType = 0;

	if(!class'UIPacket'.static.Encode_C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST(stream, packet))
	{
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST, stream);
	Debug("API C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST :");
}

function ParsePacket_S_EX_UNIQUE_GACHA_INVEN_GET_ITEM()
{
	local UIPacket._S_EX_UNIQUE_GACHA_INVEN_GET_ITEM packet;

	if(!class'UIPacket'.static.Decode_S_EX_UNIQUE_GACHA_INVEN_GET_ITEM(packet))
	{
	}
	Debug(" -->  Decode_S_EX_UNIQUE_GACHA_INVEN_GET_ITEM :  " @ string(packet.cResult));

	if(packet.cResult == 1)
	{
		AddSystemMessage(6236);
	}
	Me.HideWindow();
}

function ParsePacket_S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST()
{
	local UIPacket._S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST packet;
	local int i;
	local ItemInfo Info;

	if(!class'UIPacket'.static.Decode_S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST :  " @ string(packet.cPage)) @ string(packet.cMaxPage));

	if(packet.cPage == 1)
	{
		m_topList.Clear();
	}
	Debug("packet.myItems.length" @ string(packet.myItems.Length));

	for(i = 0; i < packet.myItems.Length; i++)
	{
		Debug("myItems nItemType: " @ string(packet.myItems[i].nItemType));
		Debug("myItems nAmount  : " @ (packet.myItems[i].nAmount));
		Info = GetItemInfoByClassID(packet.myItems[i].nItemType);
		Info.ItemNum = packet.myItems[i].nAmount;

		if(IsStackableItem(Info.ConsumeType))
		{
			Info.bShowCount = true;
		}
		m_topList.AddItem(Info);
	}
	if(packet.cPage == packet.cMaxPage)
	{
		Debug("??? ???");
		refreshPossibleSlotCount();
		m_topList.EnableWindow();
		m_bottomList.EnableWindow();
	}
}

function addHasStackableItemArray(int ClassID)
{
	if((findHasStackableItemArray(ClassID)) == -1)
	{
		hasStackableItemArray[hasStackableItemArray.Length] = ClassID;
	}
}

function int findHasStackableItemArray(int ClassID)
{
	local int i, returnV;

	returnV = -1;

	for(i = 0; i < hasStackableItemArray.Length; i++)
	{
		if(hasStackableItemArray[i] == ClassID)
		{
			returnV = i;
		}
	}

	return returnV;
}

function removeHasStackableItemArray(int ClassID)
{
	local int Index;

	Index = findHasStackableItemArray(ClassID);

	if(Index != -1)
	{
		hasStackableItemArray.Remove(Index, 1);
	}
}

function OnReceivedCloseUI()
{
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
	m_WindowName="UniqueGachaWarehouseWnd"
}