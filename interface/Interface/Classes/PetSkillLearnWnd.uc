class PetSkillLearnWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle LearningSkillTitle_Text;
var ButtonHandle SkillLearnEnter_Btn;
var RichListCtrlHandle LearningSkillList_RichList;
var TextureHandle LearningSkillBG_tex;
var WindowHandle LearningSkillCondition_Window;
var TextBoxHandle LearningSkillCondition01_text;
var TextBoxHandle LearningSkillCondition02_text;
var TextBoxHandle NoCost_text;
var ItemWindowHandle SkillCostIcon01_ItemWindow;
var ItemWindowHandle SkillCostIcon02_ItemWindow;
var TextBoxHandle SkillCost01_Txt;
var TextBoxHandle SkillCost02_Txt;
var TextBoxHandle SkillMyCost01_Txt;
var TextBoxHandle SkillMyCost02_Txt;
var PetWndClassic PetWndClassicScript;
var array<PetAcquireSkillInfo> arrAcquireSkill;
var int selectedListIndex;
var int needItemArrIndex;
var int beforeSelectedIndex;
var bool bLearningCondition;

function OnRegisterEvent ()
{
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_PetSkillList);
}

function OnLoad ()
{
	Initialize();
	Load();
}

function Initialize ()
{
	Me = GetWindowHandle("PetSkillLearnWnd");
	LearningSkillTitle_Text = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillTitle_Text");
	SkillLearnEnter_Btn = GetButtonHandle("PetSkillLearnWnd.SkillLearnEnter_Btn");
	NoCost_text = GetTextBoxHandle("PetSkillLearnWnd.NoCost_text");
	LearningSkillList_RichList = GetRichListCtrlHandle("PetSkillLearnWnd.LearningSkillList_RichList");
	LearningSkillBG_tex = GetTextureHandle("PetSkillLearnWnd.LearningSkillBG_tex");
	LearningSkillCondition_Window = GetWindowHandle("PetSkillLearnWnd.LearningSkillCondition_Window");
	LearningSkillCondition01_text = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.LearningSkillCondition01_text");
	LearningSkillCondition02_text = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.LearningSkillCondition02_text");
	SkillCostIcon01_ItemWindow = GetItemWindowHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCostIcon01_ItemWindow");
	SkillCostIcon02_ItemWindow = GetItemWindowHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCostIcon02_ItemWindow");
	SkillCost01_Txt = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCost01_Txt");
	SkillCost02_Txt = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCost02_Txt");
	SkillMyCost01_Txt = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillMyCost01_Txt");
	SkillMyCost02_Txt = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillMyCost02_Txt");
	PetWndClassicScript = PetWndClassic(GetScript("PetWndClassic"));
	LearningSkillList_RichList.SetSelectedSelTooltip(False);
	LearningSkillList_RichList.SetAppearTooltipAtMouseX(True);
	LearningSkillList_RichList.SetTooltipType("Skill");
}

function Load ()
{
}

function OnShow ()
{
	ClearAll();
	refreshAcquireSkill();
}

function refreshAcquireSkill ()
{
	local int i;

	needItemArrIndex = -1;
	Class'PetAPI'.static.GetPetAcquireSkillList(PetWndClassicScript.nEvolvePetID,PetWndClassicScript.nPetLevel,PetWndClassicScript.nEvolutionStep,arrAcquireSkill);

	arrAcquireSkill.Sort( OnSortCompare );

	LearningSkillList_RichList.DeleteAllItem();
	
	for ( i = 0;i < arrAcquireSkill.Length;i++ )
	{
		addSkillList(arrAcquireSkill[i].SkillID,arrAcquireSkill[i].SkillLevel,arrAcquireSkill[i].bEnable);
	}
	if ( arrAcquireSkill.Length > 0 )
	{
		if ( getSkillSelectedIndex() <= beforeSelectedIndex )
		{
			LearningSkillList_RichList.SetSelectedIndex(getSkillSelectedIndex(),True);
		} else {
			LearningSkillList_RichList.SetSelectedIndex(beforeSelectedIndex,True);
		}
		OnClickListCtrlRecord("LearningSkillList_RichList");
	} else {
		LearningSkillCondition01_text.SetText("");
		LearningSkillCondition02_text.SetText("");
		clearNeedCost();
	}
}

function int getSkillSelectedIndex ()
{
	local int i;

	for ( i = 0;i < arrAcquireSkill.Length;i++ )
	{
		if ( arrAcquireSkill[i].bEnable == False )
		{
			if ( i - 1 >= 0 )
			{
				return i - 1;
			} else {
				return i;
			}
		}
	}
	if ( i == 0 )
	{
		return 0;
	}
	return i - 1;
}

function updateNeedItem ()
{
	local int i;
	local bool bUpgradeEnable;

	if ( !Me.IsShowWindow() )
	{
		return;
	}
	clearNeedCost();
	bUpgradeEnable = True;
	if ( (needItemArrIndex > -1) && (arrAcquireSkill.Length > 0) )
	{
		if ( arrAcquireSkill[needItemArrIndex].NeedItem.Length > 0 )
		{
			for ( i = 0;i < arrAcquireSkill[needItemArrIndex].NeedItem.Length;i++ )
			{
				setNeedCost(i + 1, arrAcquireSkill[needItemArrIndex].NeedItem[i].Id, arrAcquireSkill[needItemArrIndex].NeedItem[i].Amount);
				if ( getInventoryItemNumByClassID(arrAcquireSkill[needItemArrIndex].NeedItem[i].Id) >= arrAcquireSkill[needItemArrIndex].NeedItem[i].Amount )
				{
					continue;
				}
				bUpgradeEnable = False;
			}
		}
	}
	if ( arrAcquireSkill[needItemArrIndex].NeedItem.Length > 0 )
	{
		NoCost_text.HideWindow();
	} else {
		NoCost_text.ShowWindow();
	}

	if ( bUpgradeEnable && bLearningCondition )
	{
		SkillLearnEnter_Btn.EnableWindow();
	} else {
		SkillLearnEnter_Btn.DisableWindow();
	}
}

function int getSkillArrayIndex (int SkillID, int SkillLevel)
{
	local int i;

	for ( i = 0;i < arrAcquireSkill.Length;i++ )
	{
		if ( (arrAcquireSkill[i].SkillID == SkillID) && (arrAcquireSkill[i].SkillLevel == SkillLevel) )
		{
			return i;
		}
	}
	return -1;
}

function setNeedCost (int SlotIndex, int ItemID, INT64 ItemCount)
{
	local TextBoxHandle myCostText;
	local TextBoxHandle needCostText;
	local ItemWindowHandle SkillCostItemWindow;
	local TextureHandle SkillCostIconBg_Texture;
	local INT64 itemCountMine;
	local ItemInfo costItem;

	needCostText = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCost0" $ string(SlotIndex) $ "_Txt");
	myCostText = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillMyCost0" $ string(SlotIndex) $ "_Txt");
	SkillCostItemWindow = GetItemWindowHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCostIcon0" $ string(SlotIndex) $ "_ItemWindow");
	SkillCostIconBg_Texture = GetTextureHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCostIconBg0" $ string(SlotIndex) $ "_Tex");
	if ( ItemID > 0 )
	{
		costItem = GetItemInfoByClassID(ItemID);
		needCostText.SetText("x" $ MakeCostString(string(ItemCount)));
		SkillCostIconBg_Texture.ShowWindow();
		SkillCostItemWindow.ShowWindow();
		SkillCostItemWindow.Clear();
		SkillCostItemWindow.AddItem(costItem);
		itemCountMine = GetInstanceL2UIInventory().GetInventoryItemCount(GetItemID(ItemID));
		myCostText.SetText(("(" $ MakeCostString(string(itemCountMine))) $ ")");

		if(ItemCount > itemCountMine)
		{
			myCostText.SetTextColor(GTColor().DRed);
		}
		else
		{
			myCostText.SetTextColor(GTColor().BLUE01);
		}
	}
	else
	{
		needCostText.SetText("");
		myCostText.SetText("");
		SkillCostItemWindow.HideWindow();
		SkillCostItemWindow.Clear();
		SkillCostIconBg_Texture.HideWindow();
	}
}

function clearNeedCost ()
{
	setNeedCost(1,0,0);
	setNeedCost(2,0,0);
}

function OnEvent (int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_PetSkillList:
			ParsePacket_S_EX_PET_SKILL_LIST(param);
			break;
		case EV_AdenaInvenCount:
			updateNeedItem();
			break;
	}
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "SkillLearnEnter_Btn":
			OnSkillLearnEnter_BtnClick();
			break;
		case "Close_BTN":
			Me.HideWindow();
			break;
	}
}

function OnSkillLearnEnter_BtnClick ()
{
	if ( needItemArrIndex > -1 )
	{
		if ( arrAcquireSkill[needItemArrIndex].SkillID > 0 )
		{
			beforeSelectedIndex = LearningSkillList_RichList.GetSelectedIndex();
			API_C_EX_ACQUIRE_PET_SKILL(arrAcquireSkill[needItemArrIndex].SkillID,arrAcquireSkill[needItemArrIndex].SkillLevel);
		} else {
			Debug("SkillId 가 잘못되었습니다" @ string(arrAcquireSkill[needItemArrIndex].SkillID));
		}
	}
}

function setLearningCondition (int nLevel, int evolStep)
{
	LearningSkillCondition01_text.SetText("Lv : " $ MakeFullSystemMsg(GetSystemMessage(7028),string(nLevel)));
	LearningSkillCondition02_text.SetText(GetSystemString(3792) $ " : " $ MakeFullSystemMsg(GetSystemMessage(7028)," " $ MakeFullSystemMsg(GetSystemMessage(5203),string(evolStep))));
	bLearningCondition = True;
	if ( PetWndClassicScript.nPetLevel >= nLevel )
	{
		LearningSkillCondition01_text.SetTextColor(GTColor().White);
	} else {
		bLearningCondition = False;
		LearningSkillCondition01_text.SetTextColor(GTColor().Red);
	}
	if ( PetWndClassicScript.nEvolutionStep >= evolStep )
	{
		LearningSkillCondition02_text.SetTextColor(GTColor().White);
	} else {
		bLearningCondition = False;
		LearningSkillCondition02_text.SetTextColor(GTColor().Red);
	}
	if ( arrAcquireSkill[needItemArrIndex].bEnable == False )
	{
		bLearningCondition = False;
	}
}

function API_C_EX_ACQUIRE_PET_SKILL (int SkillID, int skillLv)
{
	local array<byte> stream;
	local UIPacket._C_EX_ACQUIRE_PET_SKILL packet;

	packet.nSkillID = SkillID;
	packet.nSkillLv = skillLv;
	if ( !Class'UIPacket'.static.Encode_C_EX_ACQUIRE_PET_SKILL(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_ACQUIRE_PET_SKILL,stream);
	Debug("----> Api Call : API_C_EX_ACQUIRE_PET_SKILL");
}

function ParsePacket_S_EX_PET_SKILL_LIST (string param)
{
	Debug("- Decode_S_EX_PET_SKILL_LIST : " @ param);
	ClearAll();
	refreshAcquireSkill();
}

function addSkillList (int SkillID, int SkillLevel, bool bLearning)
{
	local RichListCtrlRowData rowData;
	local SkillInfo Info;
	local int nW;
	local int nH;
	local Color applyColor;

	rowData.cellDataList.Length = 1;
	if ( GetSkillInfo(SkillID,SkillLevel,0,Info) )
	{
		if ( bLearning )
		{
			applyColor = GTColor().White;
		} else {
			applyColor = GTColor().Gray;
		}
		GetTextSizeDefault(Info.SkillName,nW,nH);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems,Info.TexName,32,32,5);
		if ( Info.IconPanel != "" )
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems,Info.IconPanel,32,32,-32);
		}
		switch (Class'UIDATA_SKILL'.static.GetAutomaticUseSkillType(GetItemID(SkillID)))
		{
			case AUST_BUFF_SKILL:
			case AUST_SEQUENTIAL_SKILL:
				addRichListCtrlTexture(rowData.cellDataList[0].drawitems,"Icon.autoskill_panel_01",32,32,-32);
				break;
		}
		if ( isActiveSkill(Info.IconType) )
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems,"l2ui_ct1.SkillWnd_DF_ListIcon_Active",32,32,-32);
		} else {
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems,"l2ui_ct1.SkillWnd_DF_ListIcon_Passive",32,32,-32);
		}
		if ( bLearning == False )
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems,"L2UI_CT1.ItemWindow.ItemWindow_IconDisable",32,32,-32,0);
		}
		addRichListCtrlString(rowData.cellDataList[0].drawitems,Info.SkillName,applyColor,False,5,1);
		addRichListCtrlString(rowData.cellDataList[0].drawitems,"Lv" $ string(SkillLevel),applyColor,False, -nW,nH + 2);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems,"l2ui_ct1.SkillWnd_DF_ListIcon_MP",16,16,5,2);
		addRichListCtrlString(rowData.cellDataList[0].drawitems,getInstanceL2Util().MakeTimeString1(Info.MpConsume),applyColor,False,-2,-2);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems,"l2ui_ct1.SkillWnd_DF_ListIcon_use",16,16,5,2);
		addRichListCtrlString(rowData.cellDataList[0].drawitems,getInstanceL2Util().MakeTimeString1(Info.HitTime + Info.CoolTime),applyColor,False,-2,-2);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems,"l2ui_ct1.SkillWnd_DF_ListIcon_Reuse",16,16,5,2);
		addRichListCtrlString(rowData.cellDataList[0].drawitems,getInstanceL2Util().MakeTimeString1(Info.ReuseDelay),applyColor,False,-2,-2);
		rowData.nReserved1 = SkillID;
		rowData.nReserved2 = SkillLevel;
		rowData.nReserved3 = 0;
		LearningSkillList_RichList.InsertRecord(rowData);
	}
}

function OnClickListCtrlRecord (string strID)
{
	local int idx;
	local RichListCtrlRowData rowData;

	if ( strID == "LearningSkillList_RichList" )
	{
		idx = LearningSkillList_RichList.GetSelectedIndex();
		if ( idx <= -1 )
		{
			return;
		}
		LearningSkillList_RichList.GetRec(idx,rowData);
		if ( rowData.nReserved1 > -1 )
		{
			selectedListIndex = idx;
			needItemArrIndex = getSkillArrayIndex(int(rowData.nReserved1), int(rowData.nReserved2));
			setLearningCondition(arrAcquireSkill[needItemArrIndex].NeedPetLevel, arrAcquireSkill[needItemArrIndex].NeedPetEvolveStep);
			updateNeedItem();
		}
		Debug("RowData.nReserved1" @ string(rowData.nReserved1));
	}
}

delegate int OnSortCompare (PetAcquireSkillInfo A, PetAcquireSkillInfo B)
{
	Debug("Sort");
	if ( (A.bEnable == False) && (B.bEnable == True) )
	{
		return -1;
	} else {
		return 0;
	}
}

function ClearAll ()
{
	LearningSkillList_RichList.DeleteAllItem();
	LearningSkillCondition01_text.SetText("");
	LearningSkillCondition02_text.SetText("");
	clearNeedCost();
	SkillLearnEnter_Btn.DisableWindow();
}

function OnHide ()
{
	ClearAll();
}

defaultproperties
{
}
