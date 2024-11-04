//================================================================================
// EventFestivalWnd.
//================================================================================

class EventFestivalWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle HelpButton;
var EffectViewportWndHandle ResultEffectViewport;
var WindowHandle Result_Wnd;
var RichListCtrlHandle ResultItemList_ListCtrl;
var WindowHandle CharacterView;
var CharacterViewportWindowHandle ObjectViewport;
var ItemWindowHandle TicketItemWindow;
var TextBoxHandle CostText;
var ButtonHandle ParticipationBtn;
var ButtonHandle StopBtn;
var TextBoxHandle ParticipationText;
var TextBoxHandle TimeText;
var RichListCtrlHandle Star2Item_ListCtrl;
var RichListCtrlHandle Star1Item_ListCtrl;
var CheckBoxHandle autoCheckBox;
var L2Util util;
var EventFestivalWndWindowTooltip eventFestivalWndWindowTooltipScript;
var int nIsUseFestival;
var int FestivalID;
var int TicketItemID;
var int TicketItemNum;
var bool bSpawnNPC;
var bool bFirstListUpdate;
var bool bResultParticipation;
var int nTicketItemNumPerGame;
var array<UIControlNeedItem> UIControlNeedItemScripts;
var L2UITimerObject uiTimer;

function OnRegisterEvent()
{
	RegisterEvent(20260);
	RegisterEvent(20290);
	RegisterEvent(20270);
	RegisterEvent(20280);
	RegisterEvent(40);
}

function OnShow()
{
	RequestFestivalInfo(true);
	if(bSpawnNPC == false)
	{
		ObjectViewport.SpawnNPC();
		bSpawnNPC = true;
	}
	UpdateTime();
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_WindowName, Me.IsShowWindow());
	Me.SetFocus();
}

function OnHide()
{
	RequestFestivalInfo(false);
	bSpawnNPC = false;
	bFirstListUpdate = false;
	bResultParticipation = false;
	GetWindowHandle("EventFestivalWnd.Result_Wnd").HideWindow();
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_WindowName, Me.IsShowWindow());
	ParticipationBtn.ShowWindow();
	StopBtn.HideWindow();	
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	InitUIControlNeedItem();
	uiTimer = class'L2UITimer'.static.Inst()._AddNewTimerObject();
	uiTimer._DelegateOnEnd = HandleOnTimeEnd;	
}

function Initialize ()
{
	m_WindowName = getCurrentWindowName(string(self));
	util = L2Util(GetScript("L2Util"));
	eventFestivalWndWindowTooltipScript = EventFestivalWndWindowTooltip(GetScript("EventFestivalWndWindowTooltip"));
	Me = GetWindowHandle("EventFestivalWnd");
	HelpButton = GetButtonHandle("EventFestivalWnd.HelpButton");
	// End:0xC3
	if(! getInstanceUIData().getIsClassicServer())
	{
		HelpButton.HideWindow();
	}
	ResultEffectViewport = GetEffectViewportWndHandle("EventFestivalWnd.ResultEffectViewport");
	Result_Wnd = GetWindowHandle("EventFestivalWnd.Result_Wnd");
	ResultItemList_ListCtrl = GetRichListCtrlHandle("EventFestivalWnd.Result_Wnd.ResultItemList_ListCtrl");
	ObjectViewport = GetCharacterViewportWindowHandle("EventFestivalWnd.CharacterView.ObjectViewport");
	ParticipationBtn = GetButtonHandle("EventFestivalWnd.ParticipationBtn");
	StopBtn = GetButtonHandle("EventFestivalWnd.StopBtn");
	ParticipationText = GetTextBoxHandle("EventFestivalWnd.FestivalTime_wnd.ParticipationText");
	TimeText = GetTextBoxHandle("EventFestivalWnd.FestivalTime_wnd.TimeText");
	Star2Item_ListCtrl = GetRichListCtrlHandle("EventFestivalWnd.Star2Item_ListCtrl");
	Star1Item_ListCtrl = GetRichListCtrlHandle("EventFestivalWnd.Star1Item_ListCtrl");
	Star1Item_ListCtrl.SetSelectable(false);
	Star1Item_ListCtrl.SetAppearTooltipAtMouseX(true);
	Star1Item_ListCtrl.SetSelectedSelTooltip(false);
	Star2Item_ListCtrl.SetSelectable(false);
	Star2Item_ListCtrl.SetAppearTooltipAtMouseX(true);
	Star2Item_ListCtrl.SetSelectedSelTooltip(false);
	GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_1Wnd.ItemWindow").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_2Wnd.ItemWindow").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_3Wnd.ItemWindow").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	autoCheckBox = GetCheckBoxHandle("EventFestivalWnd.autoCheckBox_Wnd.autoCheckBox");
	autoCheckBox.SetCheck(false);
	ParticipationBtn.ShowWindow();
	StopBtn.HideWindow();

	if(! getInstanceUIData().getIsClassicServer())
	{
		setViewPortParams(19652, 1, 3, 1.0f, 34000, 100);
		GetMeWindow("autoCheckBox_Wnd").ShowWindow();		
	}
	else if(IsAdenServer())
	{
		setViewPortParams(18482, 1, 3, 1.0f, 34000, 100);
		GetMeWindow("autoCheckBox_Wnd").HideWindow();			
	}
	else
	{
		setViewPortParams(18464, 1, 3, 1.0f, 34000, 100);
		GetMeWindow("autoCheckBox_Wnd").HideWindow();
	}
}

function initTopSlot()
{
	local int i;

	
	for ( i = 1;i <= 3;i++ )
	{
		GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(i) $ "Wnd.ItemWindow").Clear();
		GetTextBoxHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(i) $ "Wnd.ItemName_Text").SetText("");
		GetTextBoxHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(i) $ "Wnd.ItemNumber_Text").SetText("");
		GetTextureHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(i) $ "Wnd.SoldOutImg").HideWindow();
	}
}

function UpdateTime ()
{
	if ( eventFestivalWndWindowTooltipScript.getFestivalEndTime() <= 0 )
	{
		GetTextureHandle("EventFestivalWnd.FestivalTime_wnd.ParticipationOnoff_Tex").SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
	} else {
		if ( nIsUseFestival == 1 )
		{
			GetTextureHandle("EventFestivalWnd.FestivalTime_wnd.ParticipationOnoff_Tex").SetTexture("L2UI_CT1.OlympiadWnd.ONICON");
		} else {
			if ( nIsUseFestival == 2 )
			{
				GetTextureHandle("EventFestivalWnd.FestivalTime_wnd.ParticipationOnoff_Tex").SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
			}
		}
	}
	TimeText.SetText(GetSystemString(1108) $ " : " $ eventFestivalWndWindowTooltipScript.GetSecToTimeStr(eventFestivalWndWindowTooltipScript.getFestivalEndTime()));
	checkEnableParticipationBtn();
}

function checkEnableParticipationBtn ()
{
	if(UIControlNeedItemScripts[0].canBuy() == false || eventFestivalWndWindowTooltipScript.getFestivalEndTime() <= 0)
	{
		ParticipationBtn.DisableWindow();
		// End:0x6D
		if(autoCheckBox.IsShowWindow())
		{
			StopBtn.HideWindow();
			ParticipationBtn.ShowWindow();
		}
	} else {
		ParticipationBtn.EnableWindow();
	}
}

function OnClickCheckBox(string strID)
{
	Debug("strID" @ strID @ string(autoCheckBox.IsChecked()));
	// End:0x5A
	if(autoCheckBox.IsChecked() == false)
	{
		ParticipationBtn.ShowWindow();
		StopBtn.HideWindow();
	}
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "HelpButton":
			OnHelpButtonClick();
			break;
		case "ParticipationBtn":
			OnParticipationBtnClick();
			break;
		case "StopBtn":
			ParticipationBtn.ShowWindow();
			StopBtn.HideWindow();
			// End:0xB6
			break;
		case "RefreshButton":
			Debug("Api Call -> RequestFestivalInfo(true)");
			RequestFestivalInfo(true);
			break;
	}
}

function OnHelpButtonClick ()
{
	Debug("-> Help Id: 200219");
	ExecuteEvent(EV_ShowHelp,"200219");
}


function OnParticipationBtnClick ()
{
	// End:0x79
	if(bResultParticipation == false)
	{
		// End:0x5E
		if(GetCanInventoryWeight())
		{
			// End:0x45
			if(autoCheckBox.IsChecked())
			{
				StopBtn.ShowWindow();
				ParticipationBtn.HideWindow();
			}
			ParticipationBtn.DisableWindow();
			bResultParticipation = true;
			RequestFestivalGame();
			Debug("Api Call -> RequestFestivalGame()");			
		}
		else
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(6196));
			// End:0xD9
			if(autoCheckBox.IsChecked())
			{
				StopBtn.HideWindow();
				ParticipationBtn.ShowWindow();
			}
		}
	}
}

function bool GetCanInventoryWeight()
{
	local UserInfo uInfo;
	local float Per;

	// End:0x3B
	if(GetPlayerInfo(uInfo))
	{
		Per = uInfo.nCarringWeight / uInfo.nCarryWeight;
		return Per <= 0.90f;
	}
	return false;
}

function OnEvent (int Event_ID, string param)
{
	if ( Event_ID == 20260 )
	{
		Debug("EV_FestivalInfo :" @ param);
		ParseInt(param,"TicketItemID",TicketItemID);
		ParseInt(param,"TicketItemNum",TicketItemNum);
		ParseInt(param,"TicketItemNumPerGame",nTicketItemNumPerGame);
		updateNeedItem(TicketItemID,nTicketItemNumPerGame);
	} else {
		if ( Event_ID == 20270 )
		{
			Debug("EV_FestivalAllItemInfo :" @ param);
			setListRewardItem(param);
		} else {
			if ( Event_ID == 20280 )
			{
				Debug("EV_FestivalTopItemInfo	:" @ param);
				updateTopItem(param);
			} else {
				if ( Event_ID == 20290 )
				{
					Debug("EV_FestivalGame :" @ param);
					resultWindow(param);
				} else {
					if ( Event_ID == 40 )
					{
						bResultParticipation = False;
						bSpawnNPC = False;
						autoCheckBox.SetCheck(false);
						ParticipationBtn.ShowWindow();
						StopBtn.HideWindow();
					}
				}
			}
		}
	}
}

function setListRewardItem (string param)
{
	local int ListCount;
	local int newFestivalID;
	local int Grade;
	local int ItemID;
	local int RemainItemNum;
	local int MaxItemNum;
	local int i;
	local int gradeItemCount;
	local int beforeGradeItem;
	local int ListNum;
	local ItemInfo Info;
	local string itemParam;
	local bool bUpdate;
	local int rGradeCount;

	ParseInt(param,"ListCount",ListCount);
	ParseInt(param,"FestivalID",newFestivalID);
	ParseInt(param,"TicketItemID",TicketItemID);
	ParseInt(param,"TicketItemNum",TicketItemNum);
	checkEnableParticipationBtn();
	if ( bFirstListUpdate && (FestivalID == newFestivalID) )
	{
		bUpdate = True;
	} else {
		Star1Item_ListCtrl.DeleteAllItem();
		Star2Item_ListCtrl.DeleteAllItem();
	}
	initTopSlot();
	FestivalID = newFestivalID;
	
	for ( i = 0;i < ListCount;i++ )
	{
		beforeGradeItem = Grade;
		ParseInt(param,"Grade" $ string(i),Grade);
		ParseInt(param,"itemID" $ string(i),ItemID);
		ParseInt(param,"MaxItemNum" $ string(i),MaxItemNum);
		ParseInt(param,"RemainItemNum" $ string(i),RemainItemNum);
		if ( beforeGradeItem == Grade )
		{
			gradeItemCount++;
		} else {
			gradeItemCount = 0;
		}
		Info = GetItemInfoByClassID(ItemID);
		ItemInfoToParam(Info,itemParam);
		if ( Grade == 1 )
		{
			GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount + 1) $ "Wnd.ItemWindow").Clear();
			GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount + 1) $ "Wnd.ItemWindow").AddItem(Info);
			GetTextBoxHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount + 1) $ "Wnd.ItemName_Text").SetText(makeShortStringByPixel(Info.Name,200,".."));
			GetTextBoxHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount + 1) $ "Wnd.ItemNumber_Text").SetText(string(RemainItemNum) $ "/" $ string(MaxItemNum));
			if ( RemainItemNum <= 0 )
			{
				GetTextBoxHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount + 1) $ "Wnd.ItemName_Text").SetTextColor(GTColor().Gray);
				GetTextBoxHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount + 1) $ "Wnd.ItemNumber_Text").SetTextColor(GTColor().Gray);
				GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount + 1) $ "Wnd.ItemWindow").DisableWindow();
				GetTextureHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount + 1) $ "Wnd.SoldOutImg").ShowWindow();
			} else {
				GetTextBoxHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount + 1) $ "Wnd.ItemName_Text").SetTextColor(GTColor().White);
				GetTextBoxHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount + 1) $ "Wnd.ItemNumber_Text").SetTextColor(GTColor().Yellow);
				GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount + 1) $ "Wnd.ItemWindow").EnableWindow();
				GetTextureHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount + 1) $ "Wnd.SoldOutImg").HideWindow();
			}
			rGradeCount++;
			continue;
		}
		else if ( Grade == 2 )
		{
			addRichItemList(Star2Item_ListCtrl,bUpdate,Info.Id.ClassID,string(RemainItemNum) $ "/" $ string(MaxItemNum),RemainItemNum,itemParam);
		} else if ( Grade == 3 )
		{
			addRichItemList(Star1Item_ListCtrl,bUpdate,Info.Id.ClassID,string(RemainItemNum) $ "/" $ string(MaxItemNum),RemainItemNum,itemParam);
		}
		ListNum++;
		bFirstListUpdate = True;
	}
}

function addRichItemList (RichListCtrlHandle rList, bool bModify, int nItemID, string itemNumStr, int RemainItemNum, string itemParam)
{
	local RichListCtrlRowData rowData;
	local int W;
	local int h;
	local int updateListNum;
	local string ItemName;

	rowData.cellDataList.Length = 1;
	rowData.szReserved = itemParam;
	rowData.nReserved1 = nItemID;
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems,"L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2",36,36,3,4);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems,Class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(nItemID)),32,32,-34,1);
	if ( RemainItemNum <= 0 )
	{
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems,"L2UI_CT1.ItemWindow.ItemWindow_IconDisable",32,32,-32,0);
	}
	ItemName = Class'UIDATA_ITEM'.static.GetItemName(GetItemID(nItemID));
	GetTextSizeDefault(ItemName,W,h);
	if ( RemainItemNum <= 0 )
	{
		addRichListCtrlString(rowData.cellDataList[0].drawitems,ItemName,GTColor().Gray,False,5,4);
		addRichListCtrlString(rowData.cellDataList[0].drawitems,itemNumStr,GTColor().Gray,False, -W,12);
	} else {
		addRichListCtrlString(rowData.cellDataList[0].drawitems,ItemName,GTColor().White,False,5,4);
		addRichListCtrlString(rowData.cellDataList[0].drawitems,itemNumStr,GTColor().Yellow,False, -W,12);
	}
	if ( bModify )
	{
		updateListNum = findListNumhRichItemList(rList,nItemID);
		if ( updateListNum > -1 )
		{
			rList.ModifyRecord(updateListNum,rowData);
		}
	} else {
		rList.InsertRecord(rowData);
	}
}

function int findListNumhRichItemList (RichListCtrlHandle rList, int nItemID)
{
	local int i;
	local RichListCtrlRowData rowData;

	
	for ( i = 0;i < rList.GetRecordCount();i++ )
	{
		rList.GetRec(i,rowData);
		if ( rowData.nReserved1 == nItemID )
		{
			return i;
		}
	}
	return -1;
}

function updateTopItem (string param)
{
	local int Grade;
	local int ItemID;
	local int RemainItemNum;
	local int MaxItemNum;
	local int i;
	local int gradeItemCount;
	local ItemInfo Info;

	ParseInt(param,"IsUseFestival",nIsUseFestival);
	if ( nIsUseFestival == 0 )
	{
		Me.HideWindow();
		return;
	}
	// TODO: 286 WTF??? мб цикл?
	i = 0;
	ParseInt(param,"Grade" $ string(i),Grade);
	ParseInt(param,"itemID" $ string(i),ItemID);
	ParseInt(param,"MaxItemNum" $ string(i),MaxItemNum);
	ParseInt(param,"RemainItemNum" $ string(i),RemainItemNum);
	if ( Grade == 1 )
	{
		for ( gradeItemCount = 1;gradeItemCount <= 3;gradeItemCount++ )
		{
			GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount) $ "Wnd.ItemWindow").GetItem(0,Info);
			if ( Info.Id.ClassID == ItemID )
			{
				GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount) $ "Wnd.ItemWindow").Clear();
				GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount) $ "Wnd.ItemWindow").AddItem(Info);
				GetTextBoxHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount) $ "Wnd.ItemName_Text").SetText(makeShortStringByPixel(Info.Name,200,".."));
				GetTextBoxHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount) $ "Wnd.ItemNumber_Text").SetText(string(RemainItemNum) $ "/" $ string(MaxItemNum));
				break;
			}
		}
	}
}

function playResultEffectViewPort (string effectPath)
{
	local Vector offset;

	ResultEffectViewport.SpawnEffect("");
	if ( effectPath == "LineageEffect2.ui_upgrade_succ" )
	{
		offset.X = 10.0;
		offset.Y = -5.0;
		ResultEffectViewport.SetScale(6.0);
		ResultEffectViewport.SetCameraDistance(1300.0);
		ResultEffectViewport.SetOffset(offset);
	} else {
		if ( effectPath == "LineageEffect.d_firework_b" )
		{
			offset.X = 10.0;
			offset.Y = -5.0;
			ResultEffectViewport.SetScale(6.0);
			ResultEffectViewport.SetCameraDistance(1300.0);
			ResultEffectViewport.SetOffset(offset);
		} else {
			if ( effectPath == "LineageEffect_br.br_e_firebox_fire_b" )
			{
				offset.X = 10.0;
				offset.Y = -5.0;
				ResultEffectViewport.SetScale(6.0);
				ResultEffectViewport.SetCameraDistance(1300.0);
				ResultEffectViewport.SetOffset(offset);
			}
		}
	}
	GetWindowHandle("EventFestivalWnd.Result_Wnd").ShowWindow();
	ResultEffectViewport.SpawnEffect(effectPath);
}

function resultWindow (string param)
{
	local ItemInfo Info;
	local ItemInfo ticketInfo;
	local int FestivalResult;
	local int RewardItemID;
	local int RewardItemNum;
	local int RewardItemGrade;

	ParseInt(param, "FestivalResult",FestivalResult);
	ParseInt(param, "RewardItemGrade",RewardItemGrade);
	ParseInt(param, "TicketItemID",TicketItemID);
	ParseInt(param, "TicketItemNum",TicketItemNum);
	ParseInt(param, "RewardItemID",RewardItemID);
	ParseInt(param, "RewardItemNum",RewardItemNum);
	ParseInt(param, "TicketItemNumPerGame",nTicketItemNumPerGame);
	bResultParticipation = False;
	if ( FestivalResult > 0 )
	{
		updateNeedItem(TicketItemID,nTicketItemNumPerGame);
		if ( RewardItemGrade == 1 )
		{
			playResultEffectViewPort("LineageEffect_br.br_e_firebox_fire_b");
		}
		else if ( RewardItemGrade == 2 )
		{
			playResultEffectViewPort("LineageEffect.d_firework_b");
		}
		else
		{
			playResultEffectViewPort("LineageEffect2.ui_upgrade_succ");
		}
		GetWindowHandle("EventFestivalWnd.Result_Wnd").ShowWindow();
		Info = GetItemInfoByClassID(RewardItemID);
		Info.ItemNum = RewardItemNum;
		ticketInfo = GetItemInfoByClassID(TicketItemID);
		ticketInfo.ItemNum = TicketItemNum;
		checkEnableParticipationBtn();
		GetItemWindowHandle("EventFestivalWnd.Result_Wnd.Itemwnd.ItemWindow").Clear();
		GetItemWindowHandle("EventFestivalWnd.Result_Wnd.Itemwnd.ItemWindow").AddItem(Info);
		GetTextBoxHandle("EventFestivalWnd.Result_Wnd.Itemwnd.ItemName_Text").SetText(makeShortStringByPixel(Info.Name,250,".."));
		GetTextBoxHandle("EventFestivalWnd.Result_Wnd.Itemwnd.ItemNum_Text").SetText("x" $ string(Info.ItemNum));
		if(RewardItemGrade == 1)
		{
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(1889), Info.Name));
		}
		// End:0x3E3
		if(autoCheckBox.IsChecked() && getInstanceUIData().getIsLiveServer() && Me.IsShowWindow() && StopBtn.IsShowWindow())
		{
			uiTimer._time = 1;
			uiTimer._Play();
		}
		// End:0x416
		if(autoCheckBox.IsChecked() == false)
		{
			ParticipationBtn.ShowWindow();
			StopBtn.HideWindow();
		}
	}
	else
	{
		Me.HideWindow();
	}
}

function HandleOnTimeEnd()
{
	uiTimer._Stop();
	// End:0x75
	if((UIControlNeedItemScripts[0].canBuy() && eventFestivalWndWindowTooltipScript.getFestivalEndTime() > 0) && Me.IsShowWindow())
	{
		ParticipationBtn.HideWindow();
		StopBtn.ShowWindow();
		OnParticipationBtnClick();		
	}
	else
	{
		ParticipationBtn.ShowWindow();
		StopBtn.HideWindow();
	}	
}

function setViewPortParams(int NpcID, int OffsetX, int OffsetY, float viewSale, int Rotation, int Distance)
{
	ObjectViewport.SetNPCInfo(NpcID);
	ObjectViewport.SetCharacterOffsetX(OffsetX);
	ObjectViewport.SetCharacterOffsetY(OffsetY);
	ObjectViewport.SetCharacterScale(viewSale);
	ObjectViewport.SetCurrentRotation(Rotation);
	ObjectViewport.SetCameraDistance(Distance);
}

function InitUIControlNeedItem()
{
	local int i;
	local string WindowName;

	WindowName = "EventFestivalWnd.CostWnd";
	
	for (i = 0; i < 1; i++)
	{
		GetWindowHandle(WindowName).SetScript("UIControlNeedItem");
		UIControlNeedItemScripts[i] = UIControlNeedItem(GetWindowHandle(WindowName).GetScript());
		UIControlNeedItemScripts[i].Init(WindowName);
		UIControlNeedItemScripts[i].DelegateItemUpdate = PeeItemUpdated;
	}
}

function PeeItemUpdated(UIControlNeedItem script)
{
	checkEnableParticipationBtn();
}

function updateNeedItem(int ItemClassID, int Amount)
{
	UIControlNeedItemScripts[0].setId(GetItemID(ItemClassID));
	UIControlNeedItemScripts[0].SetNumNeed(Amount);
}

function OnReceivedCloseUI()
{
	// End:0x24
	if(StopBtn.IsShowWindow())
	{
		OnClickButton("StopBtn");		
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
}

defaultproperties
{
}
