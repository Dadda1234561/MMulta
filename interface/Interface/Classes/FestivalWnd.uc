/**
 *  [�ؿ�] ������ ����(Festival) ������ ����
 *  
 *  http://l2-redmine/redmine/issues/7803
 *  http://l2-redmine/redmine/issues/7751
 *  
 *  
 *  *** �佺Ƽ�� ���� ���� �׽�Ʈ
 *  //festivalbm start [on/off]
 *  
 *  
 *  *** �佺Ƽ�� �ֿ� ��ũ ������ ���� ������ ����.
 *  //festivalbm top 
 *  
 */
class FestivalWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle PopUpWnd;
var ItemWindowHandle PopUpCostItemWindow;
var TextBoxHandle PopUpDescriptionText;
var WindowHandle disableWnd;
var WindowHandle CharacterView;
var CharacterViewportWindowHandle ObjectViewport;
var TextureHandle CharacterViewBG;
var TextBoxHandle TicketText;
var ItemWindowHandle TicketItemWindow;
var TextBoxHandle TicketNumberText;
var TextBoxHandle CostText;
var ItemWindowHandle CostItemWindow;
var TextBoxHandle CostNumberText;
var ButtonHandle ParticipationBtn;
var TextBoxHandle TimeNumberText;
var TextBoxHandle GoldNumberText;
var ListCtrlHandle FestivalItemListCtrl;
var EffectViewportWndHandle ResultEffectViewport;
var FestivalSubWnd FestivalSubWndScript;
var L2Util util;

var int nIsUseFestival;      // 0 �佺Ƽ�� ����, 1 �佺Ƽ�� ������, 2 �佺Ƽ�� �̺�Ʈ�� ���� �������� �̺�Ʈ ��ǰ�� ��� ����.
var int FestivalID;          // �̺�Ʈ ���̵�
//var int FestivalStartTime; // �̹�ȸ�� ���۱��� ���� �ð� (second)
//var int FestivalEndTime;     // �̹�ȸ�� ������� ���� �ð� (second)

// EV_FestivalInfo
var int TicketItemID;  // Ƽ�Ͼ����� ���̵�
var int TicketItemNum; // Ƽ�� ����

var bool bSpawnNPC;
var bool bFirstListUpdate;

var int nTicketItemNumPerGame;

function OnRegisterEvent()
{
	RegisterEvent(EV_FestivalInfo);
	RegisterEvent(EV_FestivalGame);
	RegisterEvent(EV_FestivalAllItemInfo);
	RegisterEvent(EV_FestivalTopItemInfo);
	RegisterEvent(EV_RESTART);
}

function OnLoad()
{
	SetClosingOnESC();

	Initialize();
	Load();
}

function Initialize()
{
	//resetUI();

	util = L2Util(GetScript("L2Util"));

	FestivalSubWndScript = FestivalSubWnd(GetScript("FestivalSubWnd"));

	Me = GetWindowHandle("FestivalWnd");

	PopUpWnd = GetWindowHandle("FestivalWnd.PopUpWnd");
	PopUpCostItemWindow = GetItemWindowHandle("FestivalWnd.PopUpWnd.PopUpCostItemWindow");
	PopUpDescriptionText = GetTextBoxHandle("FestivalWnd.PopUpWnd.PopUpDescriptionText");

	disableWnd = GetWindowHandle("FestivalWnd.DisableWnd");

	//CharacterView = GetWindowHandle("FestivalWnd.CharacterView");
	ObjectViewport = GetCharacterViewportWindowHandle("FestivalWnd.CharacterView.ObjectViewport");

	ResultEffectViewport = GetEffectViewportWndHandle("FestivalWnd.ResultEffectViewport");

	TicketItemWindow = GetItemWindowHandle("FestivalWnd.TicketItemWindow");
	TicketNumberText = GetTextBoxHandle("FestivalWnd.TicketNumberText");
	CostItemWindow = GetItemWindowHandle("FestivalWnd.CostItemWindow");
	CostNumberText = GetTextBoxHandle("FestivalWnd.CostNumberText");

	ParticipationBtn = GetButtonHandle("FestivalWnd.ParticipationBtn");

	TimeNumberText = GetTextBoxHandle("FestivalWnd.TimeNumberText");

	GoldNumberText = GetTextBoxHandle("FestivalWnd.GoldNumberText");

	FestivalItemListCtrl = GetListCtrlHandle("FestivalWnd.FestivalItemListCtrl");
	FestivalItemListCtrl.SetSelectedSelTooltip(false);
	FestivalItemListCtrl.SetAppearTooltipAtMouseX(true);

	setViewPortParams(8534, 1, 6, 1, 34000, 140);

	// ĳ���� ����
	//setViewPortParams(13566, 0, 3, 1.0f,34000, 140);
}

function Load()
{
}

function OnShow()
{
	if(bSpawnNPC == false)
	{
		ObjectViewport.SpawnNPC();
		bSpawnNPC = true;
	}

	UpdateTime();
}

function OnHide()
{
	ResetUI();
}

function ResetUI()
{
	bSpawnNPC = false;
	bFirstListUpdate = false;
	GetWindowHandle("FestivalWnd.ResultWnd").HideWindow();
	OnPopUpCancelBtnClick();

	GetTextureHandle("FestivalWnd.ResultFrame").HideWindow();
}

function UpdateTime()
{
	TimeNumberText.SetText(getTimeStringBySec(FestivalSubWndScript.getFestivalEndTime(), false));
	checkEnableParticipationBtn();
}

function OnEvent(int Event_ID, string param)
{
	// x=3 y=5 rotation=34000 scale=01f distance=140 animation=4 npcID=8534 
	// �⺻ ����, ���� Ƽ�� ����, Ƽ�� ���̵�
	if(Event_ID == EV_FestivalInfo)
	{
		//debug("EV_FestivalInfo :" @ param);

		ParseInt(param, "TicketItemID", TicketItemID);
		ParseInt(param, "TicketItemNum", TicketItemNum);
		ParseInt(param, "TicketItemNumPerGame", nTicketItemNumPerGame);

		CostNumberText.SetText("x" $ nTicketItemNumPerGame);

		CostItemWindow.Clear();
		CostItemWindow.AddItem(GetItemInfoByClassID(TicketItemID));
		TicketNumberText.SetText(string(TicketItemNum));
	}
	// ���� ������ ����
	else if(Event_ID == EV_FestivalAllItemInfo)
	{
		//debug("EV_FestivalAllItemInfo :" @ param);

		setListRewardItem(param);
	}
	else if(Event_ID == EV_FestivalTopItemInfo)
	{
		Debug("EV_FestivalTopItemInfo  :" @ param);
		updateTopItem(param);
	}
	else if(Event_ID == EV_FestivalGame)
	{
		Debug("EV_FestivalGame :" @ param);
		resultWindow(param);
	}
	else if(Event_ID == EV_RESTART)
	{
		bSpawnNPC = false;
	}
}

function updateTopItem(string param)
{
	local int Grade, ItemID, RemainItemNum, MAXITEMNUM, i, gradeItemCount;

	local ItemInfo Info;

	ParseInt(param, "IsUseFestival", nIsUseFestival);

	// ������ ���̸� ����
	// 0 �佺Ƽ�� ����, 1 �佺Ƽ�� ������, 2 �佺Ƽ�� �̺�Ʈ�� ���� �������� �̺�Ʈ ��ǰ�� ��� ����.
	if(nIsUseFestival == 0)
	{
		Me.HideWindow();
		return;
	}
	i = 0;
	ParseInt(param, "Grade" $ i, Grade);   // 1�� ���� ���
	ParseInt(param, "itemID" $ i, ItemID);
	ParseInt(param, "MaxItemNum" $ i, MAXITEMNUM);
	ParseInt(param, "RemainItemNum" $ i, RemainItemNum);

	//ParseInt(param, "FestivalEndTime", FestivalEndTime);

	// 1�� ���� �ѹ�
	//Me.KillTimer(TIMER_ID);
	//Me.SetTimer(TIMER_ID, 1000);

	if(Grade == 1)
	{
		for(gradeItemCount = 0; gradeItemCount < 3; gradeItemCount++)
		{
			GetItemWindowHandle("FestivalWnd.Gold" $ gradeItemCount + 1 $ "Window.GoldItemWindow").GetItem(0, Info);

			if(Info.Id.ClassID == ItemID)
			{
				GetItemWindowHandle("FestivalWnd.Gold" $ gradeItemCount + 1 $ "Window.GoldItemWindow").Clear();
				GetItemWindowHandle("FestivalWnd.Gold" $ gradeItemCount + 1 $ "Window.GoldItemWindow").AddItem(Info);

				GetTextBoxHandle("FestivalWnd.Gold" $ gradeItemCount + 1 $ "Window.GoldText").SetText(makeShortStringByPixel(Info.Name, 100, ".."));
				GetTextBoxHandle("FestivalWnd.Gold" $ gradeItemCount + 1 $ "Window.GoldNumberText").SetText(RemainItemNum $ "/" $ MAXITEMNUM);
				break;
			}
		}
	}
}

// playResultEffectViewPort("LineageEffect2.ui_upgrade_succ")
// playResultEffectViewPort("LineageEffect.d_firework_a")

function playResultEffectViewPort(string effectPath)
{
	local Vector offset;

	if(effectPath == "LineageEffect2.ui_upgrade_succ")
	{
		offset.X = 10;
		offset.Y = -5;
		ResultEffectViewport.SetScale(6f);
		ResultEffectViewport.SetCameraDistance(1300f);
		ResultEffectViewport.SetOffset(offset);

		// ������ ���� �߿��� �ִ� 
		ObjectViewport.PlayAnimation(4);
	}
	else if(effectPath == "LineageEffect.d_firework_a")
	{
		offset.X = 10;
		offset.Y = -5;
		ResultEffectViewport.SetScale(6f);
		ResultEffectViewport.SetCameraDistance(1300f);
		ResultEffectViewport.SetOffset(offset);

		ObjectViewport.PlayAnimation(5);
	}

	GetTextureHandle("FestivalWnd.ResultFrame").ShowWindow();
	ResultEffectViewport.SetFocus();
	ResultEffectViewport.SpawnEffect(effectPath);
}

// ���
function resultWindow(string param)
{
	local ItemInfo Info, ticketInfo;
	local int FestivalResult, RewardItemID, RewardItemNum, RewardItemGrade;

	ParseInt(param, "FestivalResult", FestivalResult);

	ParseInt(param, "RewardItemGrade", RewardItemGrade);

	ParseInt(param, "TicketItemID", TicketItemID);
	ParseInt(param, "TicketItemNum", TicketItemNum);

	ParseInt(param, "RewardItemID", RewardItemID);
	ParseInt(param, "RewardItemNum", RewardItemNum);

	ParseInt(param, "TicketItemNumPerGame", nTicketItemNumPerGame);

	DisableCurrentWindow(false);

	if(FestivalResult > 0)
	{
		CostNumberText.SetText("x" $ nTicketItemNumPerGame);

		if(RewardItemGrade == 1)
		{
			playResultEffectViewPort("LineageEffect2.ui_upgrade_succ");
		}
		else
		{
			playResultEffectViewPort("LineageEffect.d_firework_a");
		}

		GetWindowHandle("FestivalWnd.ResultWnd").ShowWindow();
		GetWindowHandle("FestivalWnd.ResultWnd").SetFocus();

		Info = GetItemInfoByClassID(RewardItemID);
		Info.ItemNum = RewardItemNum;

		CostItemWindow.Clear();

		ticketInfo = GetItemInfoByClassID(TicketItemID);
		ticketInfo.ItemNum = TicketItemNum;

		if(TicketItemNum <= 0)
		{
			ParticipationBtn.DisableWindow();
		}
		else
		{
			ParticipationBtn.EnableWindow();
		}

		CostItemWindow.AddItem(ticketInfo);
		TicketNumberText.SetText(string(TicketItemNum));

		//TicketItemID
		GetItemWindowHandle("FestivalWnd.ResultWnd.ResultItemWindow").Clear();
		GetItemWindowHandle("FestivalWnd.ResultWnd.ResultItemWindow").AddItem(Info);

		//GetTextBoxHandle("FestivalWnd.ResultWnd.ResultText").SetText(info.Name);

		GetTextBoxHandle("FestivalWnd.ResultWnd.ResultText").SetText(makeShortStringByPixel(Info.Name, 250, ".."));

		GetTextBoxHandle("FestivalWnd.ResultWnd.ResultNumberText").SetText("x" $ RewardItemNum);

		// �����մϴ�. $s1%�� ���޹޾ҽ��ϴ�.
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(1889), Info.Name));
	}
	else
	{
		Me.HideWindow();
	}
}

function checkEnableParticipationBtn()
{
	if(TicketItemNum <= 0 || FestivalSubWndScript.getFestivalEndTime() <= 0)
	{
		ParticipationBtn.DisableWindow();
	}
	else
	{
		ParticipationBtn.EnableWindow();
	}
}

function initGoldSlot()
{
	local int i;

	for(i = 0; i < 3; i++)
	{
		GetItemWindowHandle("FestivalWnd.Gold" $ i + 1 $ "Window.GoldItemWindow").Clear();

		GetTextBoxHandle("FestivalWnd.Gold" $ i + 1 $ "Window.GoldText").SetText("");
		GetTextBoxHandle("FestivalWnd.Gold" $ i + 1 $ "Window.GoldNumberText").SetText("");
	}
}

function setListRewardItem(string param)
{
	local Rect rectWnd;
	local int ListCount, newFestivalID, Grade, ItemID, RemainItemNum, MAXITEMNUM,
		i, gradeItemCount, beforeGradeItem, ListNum;

	local ItemInfo Info;
	local LVDataRecord Record, tmRecord;

	local string itemParam, symbolTexture;
	local bool bUpdate;

	// �ְ� ��� ��ǰ�� ���� ���� ��ġ�� ��� 
	local int rGradeCount;

	rectWnd = GetWindowHandle("FestivalWnd.FestivalPattern").GetRect();

	ParseInt(param, "ListCount", ListCount);
	ParseInt(param, "FestivalID", newFestivalID);
	//ParseInt(param, "FestivalEndTime", FestivalEndTime);

	ParseInt(param, "TicketItemID", TicketItemID);
	ParseInt(param, "TicketItemNum", TicketItemNum);

	checkEnableParticipationBtn();
	CostItemWindow.Clear();
	CostItemWindow.AddItem(GetItemInfoByClassID(TicketItemID));
	TicketNumberText.SetText(string(TicketItemNum));

	// ���� ���� ���� �ð�
	//TimeNumberText.SetText(getTimeStringBySec(FestivalEndTime, false));

	// 1�� ���� �ѹ�
	//Me.KillTimer(TIMER_ID);
	//Me.SetTimer(TIMER_ID, 1000);		

	// â�� ����, �ѹ��̶� ����� �߰� �Ǿ���, ������Ʈ�� FestivalID �� ���� ���� newFestivalID ���� ���ٸ�..
	// ������Ʈ

	if(bFirstListUpdate && FestivalID == newFestivalID)
	{
		bUpdate = true;
	}
	// ���� ����
	else
	{
		// ����Ʈ�� ������ ������ ������Ʈ
		FestivalItemListCtrl.DeleteAllItem();
	}

	// ������ ������ ���� ���� �ؾ���.
	initGoldSlot();

	FestivalID = newFestivalID;

	for(i = 0; i < ListCount; i++)
	{
		Record = tmRecord;
		beforeGradeItem = Grade;

		ParseInt(param, "Grade" $ i, Grade);   // 1�� ���� ���
		ParseInt(param, "itemID" $ i, ItemID);
		ParseInt(param, "MaxItemNum" $ i, MAXITEMNUM);
		ParseInt(param, "RemainItemNum" $ i, RemainItemNum);

		if(beforeGradeItem == Grade)
		{
			gradeItemCount++;
		}
		else
		{
			gradeItemCount = 0;
		}

		Info = GetItemInfoByClassID(ItemID);

		//Debug("------- Grade" @ Grade);
		// �ֻ����� ����Ʈ�� �ƴ�.
		if(Grade == 1)
		{
			GetItemWindowHandle("FestivalWnd.Gold" $ gradeItemCount + 1 $ "Window.GoldItemWindow").ShowWindow();
			GetItemWindowHandle("FestivalWnd.Gold" $ gradeItemCount + 1 $ "Window.GoldItemWindow").Clear();
			GetItemWindowHandle("FestivalWnd.Gold" $ gradeItemCount + 1 $ "Window.GoldItemWindow").AddItem(Info);

			GetTextBoxHandle("FestivalWnd.Gold" $ gradeItemCount + 1 $ "Window.GoldText").SetText(makeShortStringByPixel(Info.Name, 100, ".."));
			GetTextBoxHandle("FestivalWnd.Gold" $ gradeItemCount + 1 $ "Window.GoldNumberText").SetText(RemainItemNum $ "/" $ MAXITEMNUM);
			rGradeCount++;

			//Debug("rGradeCount" @ rGradeCount);

			//GetItemWindowHandle("FestivalWnd.Gold" $ gradeItemCount + 1 $ "ItemWindow" ).MoveTo(rectWnd.nX + 200, rectWnd.nY + 140);
			continue;
		}

		ItemInfoToParam(Info, itemParam);
		Record.szReserved = itemParam;

		// ���ڵ� ����
		Record.LVDataList.Length = 3;

		//Record.LVDataList[0].szData = "2342423424";

		if(gradeItemCount == 0)
		{
			if(Grade == 2)
			{
				symbolTexture = "l2ui_ct1.FestivalWnd.FestivalWnd_Flag_Silver1";
			}
			else if(Grade == 3)
			{
				symbolTexture = "l2ui_ct1.FestivalWnd.FestivalWnd_Flag_Bronze1";
			}

			if(Grade == 2 || Grade == 3)
			{
				Record.LVDataList[0].arrTexture.Length = 1;
				lvTextureAdd(Record.LVDataList[0].arrTexture[0], symbolTexture, 0, 0, 50, 50);
			}			
		}
		else if(gradeItemCount == 1)
		{
			if(Grade == 2)
			{
				symbolTexture = "l2ui_ct1.FestivalWnd.FestivalWnd_Flag_Silver2";
			}
			else if(Grade == 3)
			{
				symbolTexture = "l2ui_ct1.FestivalWnd.FestivalWnd_Flag_Bronze2";
			}

			if(Grade == 2 || Grade == 3)
			{
				Record.LVDataList[0].arrTexture.Length = 1;
				lvTextureAdd(Record.LVDataList[0].arrTexture[0], symbolTexture, 0, -1, 50, 50);
			}
		}

		Record.LVDataList[1].szData = Info.Name;
		Record.LVDataList[1].hasIcon = true;
		Record.LVDataList[1].nTextureWidth = 32;
		Record.LVDataList[1].nTextureHeight = 32;
		Record.LVDataList[1].nTextureU = 32;
		Record.LVDataList[1].nTextureV = 32;
		Record.LVDataList[1].szTexture = Info.IconName;
		Record.LVDataList[1].IconPosX = 4;
		Record.LVDataList[1].FirstLineOffsetX = 6;

		// �г�
		Record.LVDataList[1].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
		Record.LVDataList[1].backTexOffsetXFromIconPosX = -2;
		Record.LVDataList[1].backTexOffsetYFromIconPosY = -1;
		Record.LVDataList[1].backTexWidth = 36;
		Record.LVDataList[1].backTexHeight = 36;
		Record.LVDataList[1].backTexUL = 36;
		Record.LVDataList[1].backTexVL = 36;

		Record.LVDataList[2].bUseTextColor = true;

		Record.LVDataList[2].TextColor = GetColor(170, 153, 119, 255);
		Record.LVDataList[2].szData = RemainItemNum $ "/" $ MAXITEMNUM;

		Record.LVDataList[2].textAlignment = TA_Center;

		if(bUpdate)
		{
			FestivalItemListCtrl.ModifyRecord(ListNum, Record);
		}
		else
		{
			FestivalItemListCtrl.InsertRecord(Record);
		}

		ListNum++;
		bFirstListUpdate = true;
		//FestivalItemListCtrl.SetFocus();
	}

	GetWindowHandle("FestivalWnd.Gold1Window").HideWindow();
	GetWindowHandle("FestivalWnd.Gold2Window").HideWindow();
	GetWindowHandle("FestivalWnd.Gold3Window").HideWindow();

	// Debug("rGradeCount" @ rGradeCount);
	// �ֻ�� ���� ������ ������ ���� ��ġ ����
	if(rGradeCount == 1)
	{
		setGoldItem(1, rectWnd, 156, 110);
	}
	else if(rGradeCount == 2)
	{
		setGoldItem(1, rectWnd, 80, 110);
		setGoldItem(2, rectWnd, 232, 110);
	}
	else if(rGradeCount == 3)
	{
		setGoldItem(1, rectWnd, 20, 110);
		setGoldItem(2, rectWnd, 156, 110);
		setGoldItem(3, rectWnd, 292, 110);
	}
}

function setGoldItem(int windowNum, Rect rectWnd, int X, int Y)
{
	GetWindowHandle("FestivalWnd.Gold" $ windowNum $ "Window").ShowWindow();
	GetWindowHandle("FestivalWnd.Gold" $ windowNum $ "Window").MoveTo(rectWnd.nX + X, rectWnd.nY + Y);
}

function testObjectView(string param)
{
	local int nX, nY, NpcID, Rotation, Distance, Animation;

	local float Scale;

	//npcID = 8534;

	ParseInt(param, "x", nX);
	ParseInt(param, "y", nY);
	ParseInt(param, "rotation", Rotation);
	ParseInt(param, "distance", Distance);
	ParseInt(param, "npcID", NpcID);

	ParseInt(param, "animation", Animation);

	ParseFloat(param, "scale", Scale);

	//x=0 y=0 rotation=0 distance=0 animation=1 npcID=8534 
	setViewPortParams(NpcID, nX, nY, Scale, Rotation, Distance);

	ObjectViewport.SpawnNPC();
	ObjectViewport.PlayAnimation(Animation);
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "PopUpOkBtn":
			OnPopUpOkBtnClick();
			break;
		case "PopUpCancelBtn":
			OnPopUpCancelBtnClick();
			break;
		case "ParticipationBtn":
			OnParticipationBtnClick();
			break;
		case "RefreshBtn":
			Debug("Api Call -> RequestFestivalInfo(false)");
			RequestFestivalInfo(true);
			break;
		case "ResultBtn":
			// ���â �ݰ�
			GetWindowHandle("FestivalWnd.ResultWnd").HideWindow();

			// ���â ������ �����
			GetTextureHandle("FestivalWnd.ResultFrame").HideWindow();
			break;
		case "HelpButton":
			OnHelpBtnClick();
			break;
	}
}

function OnPopUpOkBtnClick()
{
	PopUpWnd.HideWindow();
	RequestFestivalGame();
}

function OnPopUpCancelBtnClick()
{
	PopUpWnd.HideWindow();
	DisableCurrentWindow(false);
}

// ���� ���� �˾�
function OnParticipationBtnClick()
{
	Debug("TicketItemNum" @ TicketItemNum);

	DisableCurrentWindow(true);

	PopUpCostItemWindow.Clear();
	PopUpCostItemWindow.AddItem(GetItemInfoByClassID(TicketItemID));
	//PopUpDescriptionText.SetText();

	GetTextBoxHandle("FestivalWnd.PopUpWnd.PopUpCostNumberText").SetText("x" $ nTicketItemNumPerGame);

	PopUpWnd.ShowWindow();
	PopUpWnd.SetFocus();
	//else
	//{
	//	getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(854), GetItemInfoByClassID(TicketItemID).Name, "1"));
	//}
}

/** 
 * ���� �����츦 ��Ȱ��ȭ �Ѵ�.
 * ������ �ֻ�ܿ� ū �����츦 �ΰ� �װɷ� �Ʒ� �ִ� ��ҵ��� Ŭ������ �ȵǵ��� �Ѵ�.
 **/
function DisableCurrentWindow(bool bFlag)
{
	if(bFlag)
	{
		disableWnd.ShowWindow();
		disableWnd.SetFocus();
	}
	else
	{
		disableWnd.HideWindow();
	}
}

// npc ����
function setViewPortParams(int NpcID, int OffsetX, int OffsetY, float viewSale, int Rotation, int Distance)
{
	Debug("setViewPortParams");
	ObjectViewport.SetNPCInfo(NpcID);
	ObjectViewport.SetCharacterOffsetX(OffsetX);
	ObjectViewport.SetCharacterOffsetY(OffsetY);
	ObjectViewport.SetCharacterScale(viewSale);
	ObjectViewport.SetCurrentRotation(Rotation);
	ObjectViewport.SetCameraDistance(Distance);
}

/**
 * ��/�ð�/�� || �ð�/�� || //�� || //1�й̸� ���� �ð� �ٲ���
 **/
function string getTimeStringBySec(int Sec, bool bRemainStr)
{
	local int timeTemp0, timeTemp1, Msg;
	local string returnStr;

	if(Sec < 0)
	{
		Sec = 0;
	}

	returnStr = "";
	//timeTemp = ((sec / 60) / 60 / 24);
	timeTemp0 = (Sec / 60) / 60;
	timeTemp1 = Sec / 60;

	if(timeTemp0 > 0)
	{
		//�ð�/��
		if(bRemainStr)
		{
			Msg = 6210;			
		}
		else
		{
			Msg = 3304;
		}
		returnStr = MakeFullSystemMsg(GetSystemMessage(Msg), string(timeTemp0), string(int(float(Sec / 60) % 60)));
	}
	else if(timeTemp1 > 0)
	{
		//��
		if(bRemainStr)
		{
			Msg = 6211;				
		}
		else
		{
			Msg = 3390;
		}
		returnStr = MakeFullSystemMsg(GetSystemMessage(Msg), string(timeTemp1));
	}
	else
	{
		//1�й̸�
		//��
		if(bRemainStr)
		{
			Msg = 6211;				
		}
		else
		{
			Msg = 4360;
		}
		returnStr = MakeFullSystemMsg(GetSystemMessage(Msg), string(1));
	}
	return returnStr;
}

// ���� ����
function OnHelpBtnClick()
{
	local string strParam;
	local HelpHtmlWnd script;

	script = HelpHtmlWnd(GetScript("HelpHtmlWnd"));
	ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "festival_help002.htm");
	script.HandleShowHelp(strParam);
}

function string htmlSetHtmlStart(string targetHtml)
{
	return "<html><body>" $ targetHtml $ "</body></html>";
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	if(PopUpWnd.IsShowWindow())
	{
		OnPopUpCancelBtnClick();
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
