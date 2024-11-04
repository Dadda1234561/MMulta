class MagicSkillWnd extends UICommonAPI;

const Skill_MAX_COUNT = 24;

//��ų ���� ����
const SKILL_COL_COUNT = 7;

const Skill_GROUP_COUNT = 13; //��Ƽ�� ī�װ� ��
const Skill_GROUP_COUNT_P = 9; //�нú� ī�װ� �� 

const SKILL_ITEMWND_WIDTH = 260;
const SKILL_SLOTBG_WIDTH = 252;
const TOP_MARGIN = 5;
const NAME_WND_HEIGHT = 20;
const BETWEEN_NAME_ITEM = 3;

// ��ų �׷� ��ȣ
const SKILL_NORMAL = 0; //���� ��ų. ������ �� ��, ���� ����.
const SKILL_BUF = 1; //����
const SKILL_DEBUF = 2; // �����
const SKILL_TOGGLE = 3; //���
const SKILL_SONG_DANCE = 4;	// �۴�
const SKILL_ITEM = 5; // ������ ��ų
const SKILL_HERO = 6; // ���� ��ų
const SKILL_CHANGE = 7; // ���� ��ų


//////////////////////////////////////////////////////////////////////////////
// CONST
//////////////////////////////////////////////////////////////////////////////
const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -17;

struct SubjobInfo
{
	var int Id;
	var int ClassID;
	var int Level;
	var int Type;
};

var WindowHandle m_wndTop;
var WindowHandle m_wndSkillDrawWnd;
// ��Ƽ���
var WindowHandle m_wndName[Skill_GROUP_COUNT];
var TextBoxHandle m_NameStr[Skill_GROUP_COUNT];
var TextureHandle m_NameBtn[Skill_GROUP_COUNT];
var TextureHandle m_ItemBg[Skill_GROUP_COUNT];
var WindowHandle m_wnd[Skill_GROUP_COUNT];
var ItemWindowHandle m_Item[Skill_GROUP_COUNT];
var ButtonHandle m_HiddenBtn[Skill_GROUP_COUNT];
var WindowHandle areaScroll;
//�нú��
var WindowHandle m_wndName_p[Skill_GROUP_COUNT_P];
var TextBoxHandle m_NameStr_p[Skill_GROUP_COUNT_P];
var TextureHandle m_NameBtn_p[Skill_GROUP_COUNT_P];
var TextureHandle m_ItemBg_p[Skill_GROUP_COUNT_P];
var WindowHandle m_wnd_p[Skill_GROUP_COUNT_P];
var ItemWindowHandle m_Item_p[Skill_GROUP_COUNT_P];
var ButtonHandle m_HiddenBtn_p[Skill_GROUP_COUNT_P];
var WindowHandle areaScroll_p;

//var array<int> m_HeroSkillID;
//var array<int> m_ItemSkillID;
//var array<int> m_ChangeSkillID;

var bool m_bShow;
var string m_WindowName;
// ��Ƽ���
var int m_bExistSkill[Skill_GROUP_COUNT]; //1�̸� �ش� �׷� ��ų�� ���°�, 2�̸� �ش� �׷� ��ų�� �ְ� �����ִ� ��. 3 �̸� �ش� �׷� ��ų�� �ְ� ���� �ִ� ��
var int nScrollHeight; //��ü �������� ��ũ�� ũ�� ����

// �нú��
var int m_bExistSkill_p[Skill_GROUP_COUNT_P];
var int nScrollHeight_p; //��ü �������� ��ũ�� ũ�� ����

var WindowHandle Drawer;

//��ų ����� ����
var L2Util util;

var bool bDrawBgTree1;
var bool bDrawBgTree2;
var bool bDrawBgTree3;

var string treeName;
var string ROOTNAME;
var string LIST1;
var string LIST2;
var string LIST3;

var string beforeTreeName;

var AnimTextureHandle TexTabLightActive;

var AnimTextureHandle TexTabLightPassive;

var TreeHandle m_UITree;

var ButtonHandle ResearchButton;

// Ʈ�� ��� �̸� �迭
var array<string> treeNodeNameNewSkillArray;
var array<string> treeNodeNameLevelUpArray;
var string clickedTreeNodeName;

var int clickedTreeNodeIndex;

var WindowHandle SkillTrainInfoWndScript;

var int levelUpSkillIndex;
var int newSkillIndex;
var bool _isSkillLearnNotice;

// ��������
var array<SubjobInfo> subjobInfoArray;
var SubjobInfo beforeSubjobInfo;

// ���� ��� Ŭ���� �������� �ִ°�?
var bool isDualClass;

var int mainLevel;
var int dualLevel;
var int currentType;

function OnRegisterEvent()
{
	// End:0x0B
	if(IsUseRenewalSkillWnd())
	{
		return;
	}
	RegisterEvent(EV_SkillListStart);
	RegisterEvent(EV_SkillList);
	RegisterEvent(EV_LanguageChanged);
	RegisterEvent(Ev_SkillEnchantInfoWndShow);

	RegisterEvent(EV_ApplySkillAvailability);

	//��ų���� �׽�Ʈ��
	RegisterEvent(EV_SkillLearningTabAddSkillBegin);
	RegisterEvent(EV_SkillLearningTabAddSkillItem);
	RegisterEvent(EV_SkillLearningTabAddSkillEnd);
	RegisterEvent(EV_SkillListEnd);

	RegisterEvent(EV_SkillLearningNewArrival);

	//���Ŭ�����׼���Ŭ��������Ʈ
	RegisterEvent(EV_NotifySubjob);
	RegisterEvent(EV_CreatedSubjob);
	RegisterEvent(EV_ChangedSubjob);
	RegisterEvent(EV_UpdateUserInfo);
	// CurrentSubjobClassID=3 Count=3 SubjobID_1 SubjobClassID_1=44 SubjobLevel_1=55 SubjobType_1

	RegisterEvent(EV_NeedResetUIData);
}

function OnLoad()
{
	SetClosingOnESC();

	InitHandle();

	util = L2Util(GetScript("L2Util"));
	SkillTrainInfoWndScript = GetWindowHandle("SkillLearnWnd");

	m_bShow = false;

	// End:0x6A
	if(getInstanceUIData().getIsArenaServer())
	{
		ResearchButton.HideWindow();
	}
}

function InitHandle()
{
	local int i;

	m_UITree = GetTreeHandle("MagicSkillWnd.SkillTrainTree");

	m_wndTop = GetWindowHandle(m_WindowName);
	Drawer = GetWindowHandle("MagicSkillDrawerWnd");
	areaScroll = GetWindowHandle(m_WindowName $ ".ASkillScroll");
	areaScroll_p = GetWindowHandle(m_WindowName $ ".PSkillScroll");

	TexTabLightActive = GetAnimTextureHandle("MagicSkillWnd.TexTabLightActive");
	TexTabLightPassive = GetAnimTextureHandle("MagicSkillWnd.TexTabLightPassive");

	ResearchButton = GetButtonHandle("MagicSkillWnd.ResearchButton");
	
	for(i=0;i<Skill_GROUP_COUNT ;i++)
	{
		m_wndName[i] = GetWindowHandle(m_WindowName $".ASkill.ASkillName" $ i);
		m_wnd[i] = GetWindowHandle(m_WindowName $ ".ASkill.ASkill" $ i);
		m_NameStr[i] = GetTextBoxHandle(m_WindowName $ ".ASkill.ASkillName" $ i $ ".ASkillNameStr" $ i);
		m_NameBtn[i] = GetTextureHandle(m_WindowName $ ".ASkill.ASkillName" $ i $ ".ASkillBtn" $ i);
		m_Item[i] = GetItemWindowHandle(m_WindowName $ ".ASkill.ASkill" $ i $ ".ASkillItem" $ i);
		m_ItemBg[i] = GetTextureHandle(m_WindowName $ ".ASkill.ASkill" $ i $ ".ASkillSlotBg" $ i);
		m_HiddenBtn[i] = GetButtonHandle(m_WindowName $ ".ASkill.ASkillName" $ i $ ".ASkillHiddenBtn" $ i);
		m_HiddenBtn[i].SetAlpha(255);
	}
	
	for(i=0;i<Skill_GROUP_COUNT_P ;i++)
	{
		m_wndName_p[i] = GetWindowHandle(m_WindowName $".PSkill.PSkillName" $ i);
		m_wnd_p[i] = GetWindowHandle(m_WindowName $ ".PSkill.PSkill" $ i);
		m_NameStr_p[i] = GetTextBoxHandle(m_WindowName $ ".PSkill.PSkillName" $ i $ ".PSkillNameStr" $ i);
		m_NameBtn_p[i] = GetTextureHandle(m_WindowName $ ".PSkill.PSkillName" $ i $ ".PSkillBtn" $ i);
		m_Item_p[i] = GetItemWindowHandle(m_WindowName $ ".PSkill.PSkill" $ i $ ".PSkillItem" $ i);
		m_ItemBg_p[i] = GetTextureHandle(m_WindowName $ ".PSkill.PSkill" $ i $ ".PSkillSlotBg" $ i);
		m_HiddenBtn_p[i] = GetButtonHandle(m_WindowName $ ".PSkill.PSkillName" $ i $ ".PSkillHiddenBtn" $ i);
		m_HiddenBtn_p[i].SetAlpha(255);
	}

	TexTabLightActive.HideWindow();
	TexTabLightPassive.HideWindow();
}

function OnShow()
{
	// ���� Ŭ�� ���� �ʱ�ȭ
	clickedTreeNodeName = "";
	clickedTreeNodeIndex = -1;
	RequestSkillList();
	m_bShow = true;
	GetWindowHandle("ActionWnd").HideWindow();
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "ActionWnd");
	m_wndTop.SetFocus();	
}

function OnHide()
{
	m_bShow = false;
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "ActionWnd");
	MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).setMagicSkillItemsType(false);
	MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).OnTextureAnimEnd(MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).EnchantProgressAnim);
	// End:0xD3
	if(Drawer.IsShowWindow())
	{
		Drawer.HideWindow();
		MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).isHiding = true;
	}
	SkillTrainInfoWndScript.HideWindow();
	// End:0xF3
	if(! DialogIsMine())
	{
		DialogHide();
	}
}

function OnEvent(int Event_ID, string param)
{
	local int NewSkillID;
	local SkillInfo SkillInfo;
	local UserInfo UserInfo;

	// End:0x0B
	if(IsUseRenewalSkillWnd())
	{
		return;
	}
	// End:0x18
	if(Event_ID == EV_SkillListStart)
	{
		HandleSkillListStart();
	}

	// ������ �� �������� ������ �����Ѵ�
	else if(Event_ID == EV_UpdateUserInfo)              //180
	{
		GetPlayerInfo(userinfo);
		
		if(currentType == 0)
			mainLevel = userinfo.nLevel;
		else if(currentType == 1)
			dualLevel = userinfo.nLevel;
	}
	
	else if(Event_ID == EV_NotifySubjob)
	{
		updateSubjobInfo(param, Event_ID);	
	}

	else if(Event_ID == EV_CreatedSubjob)
	{
		updateSubjobInfo(param, Event_ID);	
	}

	else if(Event_ID == EV_ChangedSubjob)
	{	
		updateSubjobInfo(param, Event_ID);
		ExecuteEvent(EV_NPCDialogWndHide);
		class'UIAPI_WINDOW'.static.HideWindow("MagicSkillWnd");
	}

	else if(Event_ID == EV_SkillList)                  //1290
	{

		HandleSkillList(param);
		//ComputeItemWndHeight();
		//ComputeItemWndAnchor();
	}
	else if(Event_ID == EV_LanguageChanged)
	{
		HandleLanguageChanged();
	}
	/*
	else if(Event_ID == Ev_SkillEnchantInfoWndShow)
	{

		if(m_wndTop.IsShowWindow()) 
		{
			Debug("MagicSkill Ev_SkillEnchantInfoWndShow" @  m_wndTop.IsShowWindow());
			Drawer.ShowWindow();
		}
	}
	*/
	else if(Event_ID == EV_ApplySkillAvailability)
	{
		ApplySkillAvailability();
	}
	//��ų���� �׽�Ʈ��
	else if(Event_ID == EV_SkillLearningTabAddSkillBegin)            //2055
	{			
		TreeClear();
		ShowSkillTree();
		levelUpSkillIndex = 0;
		newSkillIndex = 0;
		treeNodeNameNewSkillArray.Remove(0, treeNodeNameNewSkillArray.Length);
		treeNodeNameLevelUpArray.Remove(0, treeNodeNameLevelUpArray.Length);
	}
	else if(Event_ID == EV_SkillLearningTabAddSkillItem)             //2056
	{
		//ParseString(param, "strIconName", strIconName);
		//ParseString(param, "strName", strName);
		//ParseInt(param, "iID", iID);
		//ParseInt(param, "iLevel", iLevel);
		//ParseInt(param, "iSPConsume", iSPConsume);
		//ParseString(param, "strEnchantName", strEnchantName);

		//AddSkillTrainListItem(strIconName, strName, iID, iLevel, iSPConsume, strEnchantName);		
		AddSkillTrainListItem(param);
	}
	else if(Event_ID == EV_SkillListEnd)                              //1291
	{
		ComputeItemWndHeight();
		ComputeItemWndAnchor();

		ParseInt(param, "NewSkillID", NewSkillID);
		// !���� �ִ��� Ȯ�� 
		GetSkillInfo(NewSkillID , 1, 0, skillInfo);
		
		//Debug("EV_SkillListEnd>>>>>>>>>>>>>>>>>>>>>>>" $ string(TypeCheck(skillinfo)) $ param);
		if(NewSkillID != 0)
		{
			if(TypeCheck(skillinfo) == true)
			//if(class'UIDATA_SKILL'.static.GetOperateType(GetItemID(NewSkillID), 1) == GetSystemString(311))
			{
				TexTabLightActive.ShowWindow();
				TexTabLightActive.SetLoopCount(1);		
				TexTabLightActive.Stop();
				TexTabLightActive.Play();
			}
			//else if(class'UIDATA_SKILL'.static.GetOperateType(GetItemID(NewSkillID), 1) == GetSystemString(312))
			else
			{
				TexTabLightPassive.ShowWindow();
				TexTabLightPassive.SetLoopCount(1);
				TexTabLightPassive.Stop();
				TexTabLightPassive.Play();
			}
		}
	}
	else if(Event_ID == EV_SkillLearningNewArrival)                   //2059
	{
		// Debug("EV_SkillLearningNewArrivalEV_SkillLearningNewArrivalEV_SkillLearningNewArrivalEV_SkillLearningNewArrival");
		RequestSkillList();
	}

	else if(Event_ID == EV_SkillLearningTabAddSkillEnd)               //2057
	{
		
		switch(Left(clickedTreeNodeName, 15))
		{
			case "root.SKILLLIST1" : 
									 if(treeNodeNameNewSkillArray.Length - 1 >= clickedTreeNodeIndex)
									 {
										beforeTreeName = treeNodeNameNewSkillArray[clickedTreeNodeIndex];

										// �������̸� ������ �ʵ���, ���� ��� ��ų�� �ݺ� ������ �ϴ°� �ƴ϶�, �ٽ� ���� â�� ������
										// �ʰ� �ص� �ȴ�.
										if(treeNodeNameNewSkillArray.Length - 1 != clickedTreeNodeIndex)
											OnClickButton(treeNodeNameNewSkillArray[clickedTreeNodeIndex]);
									 }
									 break;

			case "root.SKILLLIST2" :
									 if(treeNodeNameLevelUpArray.Length - 1 >= clickedTreeNodeIndex)
									 {
										 beforeTreeName = treeNodeNameLevelUpArray[clickedTreeNodeIndex];
										 OnClickButton(treeNodeNameLevelUpArray[clickedTreeNodeIndex]);
									 }
									 break;
		}

	}
	else if(Event_ID == EV_NeedResetUIData)  
	{
		checkClassicForm();
	}
}

function checkClassicForm()
{
	ResearchButton.SetButtonName(2070);	
}

//��ų�� Ŭ��
function OnClickItem(string strID, int Index)
{
	local ItemInfo infItem;
	local int GroupID;
	local MagicSkillDrawerWnd script_a;
	
	if(InStr(strID, "ASkillItem") > -1 && Index>-1)
	{
		GroupID = int(Mid(strID, Len("ASkillItem"), Len(strID) - 1));
		// End:0xE0
		if(m_Item[GroupID].GetItem(Index, infItem))
		{
			// End:0xC6
			if(Drawer.IsShowWindow())
			{
				script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));
				script_a.handleSetCurrentSkill(infItem);				
			}
			else
			{
				// 10.04.5 ������ ���� ��û 
				UseSkill(infItem.Id, infItem.ShortcutType);
			}
		}
	}
}

// ��ưŬ�� �̺�Ʈ
function OnClickButton(string strID)
{
	local int i;				// for�� ������ ���� ����
	local int index;
	local int nWndWidth, nWndHeight; //������ ������ �ޱ� ����
	local MagicSkillDrawerWnd script_a;

	//Tree�� ����
	local Array<string> Result;
	local string treelist;
	local array<string> SkillIDLevel;	
	
	index = int(Right(strID, 1));	//��ư�� ���� �� ���ڸ� ������. 

	treelist = Left(strID, 4);
	
	// Debug("Ʈ�� Ŭ�� " @ strID);
	if(InStr(strID ,"ASkillHiddenBtn") > -1)
	{
		if(m_bExistSkill[index] == 1)		// ������ ������ �����ش�. 
		{
			m_wnd[index].GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;;Height�� ���
			nScrollHeight = nScrollHeight - nWndHeight - BETWEEN_NAME_ITEM;	// ����� ���߱� ������ ��ũ�� ���̸� �������ش�. 
			m_NameBtn[index].SetTexture("l2ui_ch3.QuestWnd.QuestWndPlusBtn");
			m_bExistSkill[index] = 2;
			m_wnd[index].HideWindow();	
			
			// ���� �������� ��Ŀ�� �������ش�. (���� �ٷ� �ؿ� �ٿ���)
			if(index <Skill_GROUP_COUNT)
			{
				for(i = index + 1 ;i<Skill_GROUP_COUNT ;i++)	
				{
					if(m_bExistSkill[i]  >0)	// ���� �����찡 �������� ������ �ִ����� �Ű澲�� �ʴ´�. 
					{
						m_wndName[i].ClearAnchor();
						m_wndName[i].SetAnchor(m_WindowName $ ".ASkill.ASkillName" $ index, "BottomCenter", "TopCenter", 0, TOP_MARGIN);
						break;
					}
				}
			}
		}
		else if(m_bExistSkill[index] == 2)		// ���������� ���ش�.
		{
			m_wnd[index].GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;;Height�� ���
			nScrollHeight = nScrollHeight + nWndHeight + BETWEEN_NAME_ITEM;	// ����� ���߱� ������ ��ũ�� ���̸� �������ش�. 
			m_NameBtn[index].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
			m_bExistSkill[index] = 1;
			m_wnd[index].ShowWindow();
			
			// ���� �������� ��Ŀ�� �������ش�. 
			if(index <Skill_GROUP_COUNT)
			{
				for(i = index + 1;i<Skill_GROUP_COUNT ;i++)	
				{
					if(m_bExistSkill[i]  >0)	// ���� �����찡 �������� ������ �ִ����� �Ű澲�� �ʴ´�. 
					{
						m_wndName[i].ClearAnchor();
						m_wndName[i].SetAnchor(m_WindowName $ ".ASkill.ASkillName" $ index, "BottomCenter", "TopCenter", 0, nWndHeight + BETWEEN_NAME_ITEM + TOP_MARGIN);
						break;
					}
				}
			}
		}
		areaScroll.SetScrollHeight(nScrollHeight);
		//areaScroll.SetScrollPosition(0);
	}
	else if(InStr(strID ,"PSkillHiddenBtn") > -1)
	{
		if(m_bExistSkill_p[index] == 1)		// ������ ������ �����ش�. 
		{
			m_wnd_p[index].GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;;Height�� ���
			nScrollHeight_p = nScrollHeight_p - nWndHeight - BETWEEN_NAME_ITEM;	// ����� ���߱� ������ ��ũ�� ���̸� �������ش�. 
			m_NameBtn_p[index].SetTexture("l2ui_ch3.QuestWnd.QuestWndPlusBtn");
			m_bExistSkill_p[index] = 2;
			m_wnd_p[index].HideWindow();	
			
			// ���� �������� ��Ŀ�� �������ش�. (���� �ٷ� �ؿ� �ٿ���)
			if(index <Skill_GROUP_COUNT_P)
			{
				for(i = index + 1 ;i<Skill_GROUP_COUNT_P ;i++)	
				{
					if(m_bExistSkill_p[i]  >0)	// ���� �����찡 �������� ������ �ִ����� �Ű澲�� �ʴ´�. 
					{
						m_wndName_p[i].ClearAnchor();
						m_wndName_p[i].SetAnchor(m_WindowName $ ".PSkill.PSkillName" $ index, "BottomCenter", "TopCenter", 0, TOP_MARGIN);
						break;
					}
				}
			}
		}
		else if(m_bExistSkill_p[index] == 2)		// ���������� ���ش�.
		{
			m_wnd_p[index].GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;;Height�� ���
			nScrollHeight_p = nScrollHeight_p + nWndHeight + BETWEEN_NAME_ITEM;	// ����� ���߱� ������ ��ũ�� ���̸� �������ش�. 
			m_NameBtn_p[index].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
			m_bExistSkill_p[index] = 1;
			m_wnd_p[index].ShowWindow();
			
			// ���� �������� ��Ŀ�� �������ش�. 
			if(index <Skill_GROUP_COUNT_P)
			{
				for(i = index + 1;i<Skill_GROUP_COUNT_P ;i++)	
				{
					if(m_bExistSkill_p[i]  >0)	// ���� �����찡 �������� ������ �ִ����� �Ű澲�� �ʴ´�. 
					{
						m_wndName_p[i].ClearAnchor();
						m_wndName_p[i].SetAnchor(m_WindowName $ ".PSkill.PSkillName" $ index, "BottomCenter", "TopCenter", 0, nWndHeight + BETWEEN_NAME_ITEM + TOP_MARGIN);
						break;
					}
				}
			}
		}
		areaScroll_p.SetScrollHeight(nScrollHeight_p);
	}
	
	else if(strID == "ResearchButton") //��ų ��æƮ ��ư Ŭ��
	{
		script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));
		// End:0x685
		if(Drawer.IsShowWindow())
		{
			Drawer.HideWindow();
			script_a.isHiding = true;
			script_a.setMagicSkillItemsType(false);
			script_a.SkillInfoClear();
			RequestSkillList();					
		}
		else
		{
			Drawer.ShowWindow();
			script_a.SkillInfoClear();
			script_a.txtMySp.SetText(MakeCostString(string(GetuserSP())));
			RequestSkillList();
		}
	}
	// End:0x82D
	if(treelist == ROOTNAME)
	{
		Split(strID, ".", Result);
		// End:0x82D
		if(Result.Length > 2)
		{
			// End:0x7A0
			if(Result[1] == LIST1 || Result[1] == LIST2)
			{
				// End:0x77D
				if(beforeTreeName != strID)
				{
					m_UITree.SetExpandedNode(beforeTreeName, false);
				}
				else
				{
					m_UITree.SetExpandedNode(beforeTreeName, true);
				}
				beforeTreeName = strID;
			}
			else
			{
				m_UITree.SetExpandedNode(strID, false);
			}
			// End:0x82D
			if(Result[1] == LIST1 || Result[1] == LIST2)
			{
				Split(Result[2], ",", SkillIDLevel);
				clickedTreeNodeName = strID;
				clickedTreeNodeIndex = int(SkillIDLevel[2]);
				RequestAcquireSkillInfo(int(SkillIDLevel[0]), int(SkillIDLevel[1]), int(SkillIDLevel[3]), 0);
			}
		}
	}
	// End:0x886
	if(strID == "TabCtrl0")
	{
		// End:0x865
		if(! getInstanceUIData().getIsArenaServer())
		{
			ResearchButton.ShowWindow();
		}
		TexTabLightActive.HideWindow();
		SkillTrainInfoWndScript.HideWindow();
	}
	else if(strID == "TabCtrl1")
	{
		// End:0x8BE
		if(! getInstanceUIData().getIsArenaServer())
		{
			ResearchButton.ShowWindow();
		}
		TexTabLightPassive.HideWindow();
		SkillTrainInfoWndScript.HideWindow();
	}
	else if(strID == "TabCtrl2")
	{
		// End:0x99B
		if(Drawer.IsShowWindow())
		{
			Drawer.HideWindow();
			MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).isHiding = true;
			MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).SkillInfoClear();
			MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).setMagicSkillItemsType(false);
			RequestSkillList();
		}
		ResearchButton.HideWindow();
	}
	// End:0x9DE
	if(strID == "ActionTap_Btn")
	{
		GetWindowHandle("ActionWnd").ShowWindow();
	}	
}

function HandleLanguageChanged()
{
	RequestSkillList();
}

function ApplySkillAvailability()
{
	local int i, j, ItemNum, Id, Level, SubLevel,
		SkillDisabled;

	//active
	// End:0xD3 [Loop If]
	for(i = 0; i < Skill_GROUP_COUNT; i++)
	{
		ItemNum = m_Item[i].GetItemNum();
		for(j = 0; j < ItemNum; j++)
		{
			m_Item[i].GetItemIdLevel(j, id, level, subLevel);
			if(Id > 0 && Level > 0)
			{
				skillDisabled = GetSkillAvailability(Id, Level, SubLevel);

				m_Item[i].SetItemSkillDisabled(j, SkillDisabled);
			}
		}
	}

	//passive
	for(i = 0;i < Skill_GROUP_COUNT_P; i++)
	{
		ItemNum = m_Item_p[i].GetItemNum();
		for(j = 0; j < itemNum; j++)
		{
			m_Item_p[i].GetItemIdLevel(j, Id, Level, SubLevel);

			if(Id > 0 && Level> 0)
			{
				SkillDisabled = GetSkillAvailability(Id, Level, SubLevel);
				m_Item_p[i].SetItemSkillDisabled(j, SkillDisabled);
			}
		}
	}
}

function HandleSkillListStart()
{
	Clear();
}

function Clear()
{
	local int i;

	// ��ų �÷��� �ʱ�ȭ
	for(i =0; i < Skill_GROUP_COUNT; i++)
	{
		m_bExistSkill[i] = 0;
		m_NameBtn[i].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
		m_wnd[i].HideWindow();
		m_wndName[i].HideWindow();
		m_Item[i].Clear();
		m_NameStr[i].SetText("");
	}
	
	for(i =0; i < Skill_GROUP_COUNT_P; i++)
	{
		m_bExistSkill_p[i] = 0;
		m_NameBtn_p[i].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
		m_wnd_p[i].HideWindow();
		m_wndName_p[i].HideWindow();
		m_Item_p[i].Clear();
		m_NameStr_p[i].SetText("");
	}
}

function HandleSkillList(string param)
{
	local int Tmp;
	//local ESkillCategory Type;
	local int SkillLevel;
	local int SkillSubLevel;
	local int SkillLock;
	local string strIconName;
	local string strSkillName;
	local string strDescription;
	local string strEnchantName;
	local string strCommand;
	local string strIconPanel;
	local int iCanEnchant;
	local int ReuseDelayShareGroupID;
	local int iSkillDisabled;

	local ItemInfo	infItem;

	ParseItemID(param, infItem.Id);
	ParseInt(param, "Type", Tmp);
	ParseInt(param, "Level", SkillLevel);
	ParseInt(param, "SubLevel", SkillSubLevel);
	ParseInt(param, "SkillLock", SkillLock);
	ParseString(param, "Name", strSkillName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "IconPanel", strIconPanel);
	ParseString(param, "Description", strDescription);
	ParseString(param, "EnchantName", strEnchantName);
	ParseString(param, "Command", strCommand);
	ParseInt(param, "CanEnchant", iCanEnchant);
	ParseInt(param, "ReuseDelayShareGroupID", ReuseDelayShareGroupID);
	ParseInt(param, "iSkillDisabled", iSkillDisabled);
	
	//Debug(" Type : " $ Tmp $ "SkillLevel : " $ SkillLevel $ " strSkillName : " $ strSkillName $ " Command : " $ strCommand  $ "strEnchantName: " $ strEnchantName);
	//Debug("panel: " $ strIconPanel);
	//Debug("CanEnchant"$iCanEnchant);

	infItem.Level = SkillLevel;
	infItem.SubLevel = SkillSubLevel;
	infItem.Name = strSkillName;
	infItem.AdditionalName = strEnchantName;
	infItem.IconName = strIconName;
	infItem.IconPanel = strIconPanel;
	infItem.Description = strDescription;
	infItem.ShortcutType = int(EShortCutItemType.SCIT_SKILL);
	infItem.MacroCommand = strCommand;
	infItem.ReuseDelayShareGroupID = ReuseDelayShareGroupID;
	
	infItem.iSkillDisabled = iSkillDisabled;

	// �ʿ���� ���� ����, ithing
	if(SkillLock > 0)
	{
//		infItem.bSkillLock = true;
		infItem.bDisabled = 1;
	}
	else
	{
//		infItem.bSkillLock = false;
		infItem.bDisabled = 0;
	}

	infItem.Reserved = iCanEnchant;
	// End:0x296
	if(Drawer.IsShowWindow())
	{
		// End:0x28A
		if(iCanEnchant > 0)
		{
			infItem.bDisabled = 0;			
		}
		else
		{
			infItem.bDisabled = 1;
		}
	}
	GroupingSkill(infItem.Id.ClassID, SkillLevel, SkillSubLevel, infItem);
}

function ComputeItemWndHeight()
{	
	local int i;			// for���� ������ ���� ����
	local int nItemNum;	// �ش� ������ �����쿡 ����ִ� ��ų�� ����
	local int nItemWndHeight;	// �������������� ����
	local int nWndWidth;	
	
	//---------------- ��Ƽ�� ��ų�� ���� ���
	nScrollHeight = 0;
	for(i=0 ;i<Skill_GROUP_COUNT ;i++)
	{
		nItemNum = m_Item[i].GetItemNum();
		
		if(nItemNum <1)	// ��ų�� ������
		{			
			m_bExistSkill[i] = 0;//â�� �������� �ʴ´�. �ʱ�ȭ�� �������� �׷��� Ȥ�� �𸣴ϱ�!
			m_wnd[i].GetWindowSize(nWndWidth, nItemWndHeight);	
			m_wnd[i].SetWindowSize(nWndWidth, 0);
		}
		else
		{			
			m_bExistSkill[i] = 1; //������. ����� Ŭ���̺�Ʈ����
			
			nItemWndHeight =((nItemNum - 1) / SKILL_COL_COUNT + 1) * 32 +((nItemNum - 1) / SKILL_COL_COUNT) * 4 + 12;	// ���Ʒ� �� + �׷�ڽ� ������ ��ġ�� 12!!
			m_wnd[i].SetWindowSize(SKILL_ITEMWND_WIDTH , nItemWndHeight);
			m_ItemBg[i].SetWindowSize(SKILL_SLOTBG_WIDTH , nItemWndHeight - 8);
			m_Item[i].SetRow((nItemNum - 1) / SKILL_COL_COUNT + 2);	//??
			
			// â�� �ȶ������� ����ش�. 
			if(!m_wnd[i].IsShowWindow()) m_wnd[i].ShowWindow();
			if(!m_wndName[i] .IsShowWindow()) m_wndName[i].ShowWindow();
			
			nScrollHeight = nScrollHeight + TOP_MARGIN + NAME_WND_HEIGHT + BETWEEN_NAME_ITEM + nItemWndHeight ;	// ������Ų��
			//debug("!!!!SKill !! Height " $"   " $i $"    " $nScrollHeight $"  " $nItemWndHeight);
		}
	}	
	//debug("!!!Skill!!! Height ������" $ nScrollHeight);
	if(areaScroll.IsShowWindow())
		areaScroll.SetScrollHeight(nScrollHeight);
	//debug("!!!Skill!!! Height Refresh");
	if(!areaScroll.IsShowWindow())
		areaScroll.SetScrollPosition(0);
	
	// ---------------�нú� ��ų�� ���� ���
	
	nScrollHeight_p = 0;
	for(i=0 ;i<Skill_GROUP_COUNT_P ;i++)
	{
		nItemNum = m_Item_p[i].GetItemNum();
		
		if(nItemNum <1)	// ��ų�� ������
		{
			m_bExistSkill_p[i] = 0;//â�� �������� �ʴ´�. �ʱ�ȭ�� �������� �׷��� Ȥ�� �𸣴ϱ�!
			m_wnd_p[i].GetWindowSize(nWndWidth, nItemWndHeight);	
			m_wnd_p[i].SetWindowSize(nWndWidth, 0);
		}
		else
		{
			m_bExistSkill_p[i] = 1; //������. ����� Ŭ���̺�Ʈ����
			
			nItemWndHeight =((nItemNum - 1) / SKILL_COL_COUNT + 1) * 32 +((nItemNum - 1) / SKILL_COL_COUNT) * 4 + 12;	// ���Ʒ� �� + �׷�ڽ� ������ ��ġ�� 12!!
			m_wnd_p[i].SetWindowSize(SKILL_ITEMWND_WIDTH , nItemWndHeight);
			m_ItemBg_p[i].SetWindowSize(SKILL_SLOTBG_WIDTH , nItemWndHeight - 8);
			m_Item_p[i].SetRow((nItemNum - 1) / SKILL_COL_COUNT + 2);	//??
			
			// â�� �ȶ������� ����ش�. 
			if(!m_wnd_p[i].IsShowWindow()) m_wnd_p[i].ShowWindow();
			if(!m_wndName_p[i] .IsShowWindow()) m_wndName_p[i].ShowWindow();
			
			nScrollHeight_p = nScrollHeight_p + TOP_MARGIN + NAME_WND_HEIGHT + BETWEEN_NAME_ITEM + nItemWndHeight ;	// ������Ų��
			//debug("!!!!SKill2 !! Height " $"   " $i $"    " $nScrollHeight_p $"  " $nItemWndHeight);
		}
	}
	
	//debug("!!!Skill2!!! Height ������" $ nScrollHeight_p);
	if(areaScroll_p.IsShowWindow())
	areaScroll_p.SetScrollHeight(nScrollHeight_p);
	//debug("!!!Skill2!!! Height Refresh");
	if(!areaScroll_p.IsShowWindow())
		areaScroll_p.SetScrollPosition(0);
}

function ComputeItemWndAnchor()
{	
	local int i, j;			// for���� ������ ���� ����
	local int nWndWidth, nWndHeight;	// ������ ������ �ޱ� ����
	
	//------------- ��Ƽ���� ��Ŀ ����ֱ�
	//ù��° â�� �������� ���

	//areaScroll.SetScrollPosition(0);
	//Debug("--ComputeItemWndAnchor");
	areaScroll.SetScrollPosition(0);

	//ù ��ų �׷��� ������ ���� ��� ���� ��ų�� ���� ���
	if(m_bExistSkill[0] == 0) 
	{
		for(i = 1 ;i < Skill_GROUP_COUNT ;i++)
		{
			// Ȱ��ȭ ���� ù��° â�� �ٿ��ش�. 
			if(m_bExistSkill[i] > 0)
			{				
				m_wndName[i].SetAnchor(m_WindowName $ ".ASkillScroll", "TopLeft", "TopLeft", 5, 4);	// ��ũ���� ����Ǵ� ������ ����
				//m_wndName[i].SetAnchor(m_WindowName $ ".ASkillScroll", "TopLeft", "TopLeft", 5, -50);	// ��ũ���� ����Ǵ� ������ ����
				//Debug("ComputeItemWndAnchor m_wndName" @ m_wndName[i]);
				m_wndName[i].ClearAnchor();
				break;
			}		
		}
	}


	
	// 0��°�� ������� �ʾƵ� �ȴ�. 
	for(i = 0 ;i < Skill_GROUP_COUNT ;i++)
	{
		// Ȱ��ȭ ���϶��� ��Ŀ
		if(m_bExistSkill[i] > 0)
		{
			for(j=i+1 ;j<Skill_GROUP_COUNT;j++)
			{
				if(m_bExistSkill[j] > 0)	// ���� Ȱ��ȭ�� â�� �˻� �� �ٿ��ش�.
				{
					if(m_bExistSkill[i] == 1)	// ������ �����찡 �������� ���
					{
						m_wnd[i].GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;;
						m_wndName[j].SetAnchor(m_WindowName $ ".ASkill.ASkillName" $ i, "BottomCenter", "TopCenter", 0, nWndHeight + BETWEEN_NAME_ITEM + TOP_MARGIN);
						break;
					}
					else if(m_bExistSkill[i] == 2)	// ������ �����찡 �������� ���
					{	
						m_wndName[j].SetAnchor(m_WindowName $ ".ASkill.ASkillName" $ i, "BottomCenter", "TopCenter", 0, TOP_MARGIN);
						break;
					}
				}
			}			
		}		
	}
	
	//------------- �нú��� ��Ŀ ����ֱ�
	//ù��° â�� �������� ���
	if(m_bExistSkill_p[0] == 0) 
	{
		for(i = 1 ;i < Skill_GROUP_COUNT_P ;i++)
		{
			// Ȱ��ȭ ���� ù��° â�� �ٿ��ش�. 
			if(m_bExistSkill_p[i] > 0)
			{
				m_wndName_p[i].SetAnchor(m_WindowName $ ".PSkillScroll", "TopLeft", "TopLeft", 5, 4);	// ��ũ���� ����Ǵ� ������ ����
				m_wndName_p[i].ClearAnchor();
				break;
			}		
		}
	}
	
	// 0��°�� ������� �ʾƵ� �ȴ�. 
	for(i = 0 ;i < Skill_GROUP_COUNT_P ;i++)
	{
		// Ȱ��ȭ ���϶��� ��Ŀ
		if(m_bExistSkill_p[i] > 0)
		{
			for(j=i+1 ;j<Skill_GROUP_COUNT_P;j++)
			{
				if(m_bExistSkill_p[j] > 0)	// ���� Ȱ��ȭ�� â�� �˻� �� �ٿ��ش�.
				{
					if(m_bExistSkill_p[i] == 1)	// ������ �����찡 �������� ���
					{
						m_wnd_p[i].GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;;
						m_wndName_p[j].SetAnchor(m_WindowName $ ".PSkill.PSkillName" $ i, "BottomCenter", "TopCenter", 0, nWndHeight + BETWEEN_NAME_ITEM + TOP_MARGIN);
						break;
					}
					else if(m_bExistSkill_p[i] == 2)	// ������ �����찡 �������� ���
					{	
						m_wndName_p[j].SetAnchor(m_WindowName $ ".PSkill.PSkillName" $ i, "BottomCenter", "TopCenter", 0, TOP_MARGIN);
						break;
					}
				}
			}			
		}		
	}
}

// ��ų�迭, index �� ���� 
function int getItemTypeIndex(int nItemType)
{
	local int nIndex;

	switch(nItemType)
	{
		// End:0x0B
		case 0:
		// End:0x0F
		case 1:
		// End:0x14
		case 2:
		// End:0x19
		case 3:
		// End:0x1E
		case 4:
		// End:0x23
		case 5:
		// End:0x28
		case 6:
		// End:0x3B
		case 7:
			nIndex = nItemType;
			// End:0x126
			break;
		// End:0x4B
		case 9:
			nIndex = 8;
			// End:0x126
			break;
		// End:0x50
		case 21:
		// End:0x55
		case 22:
		// End:0x5A
		case 23:
		// End:0x5F
		case 24:
		// End:0x64
		case 25:
		// End:0x69
		case 26:
		// End:0x6E
		case 27:
		// End:0x73
		case 28:
		// End:0x78
		case 29:
		// End:0x7D
		case 30:
		// End:0x82
		case 31:
		// End:0x99
		case 32:
			nIndex = nItemType - 21;
			// End:0x126
			break;
		// End:0xA9
		case 51:  // ����ü ��ų(2018-11-13)
			nIndex = 12;
			// End:0x126
			break;
		// End:0xAE
		case 11:
		// End:0xB3
		case 12:
		// End:0xB8
		case 13:
		// End:0xBD
		case 14:
		// End:0xC2
		case 15:
		// End:0xC7
		case 16:
		// End:0xCC
		case 17:
		// End:0xE3
		case 18:
			nIndex = nItemType - 11;
			// End:0x126
			break;
		// End:0xE8
		case 35:
		// End:0xED
		case 36:
		// End:0xF2
		case 37:
		// End:0xF7
		case 38:
		// End:0xFC
		case 39:
		// End:0x113
		case 40:
			nIndex = nItemType - 35;
			// End:0x126
			break;
		// End:0x123
		case 52:
			nIndex = 6;
			// End:0x126
			break;
	}

	return nIndex;
}

// ID�� ������ ������ ���� �ش� ��ų�� ������ Ȯ�����´�.
function GroupingSkill(int SkillID, int SkillLevel, int SkillSubLevel, ItemInfo infItem)
{
	local SkillInfo Info;

	// ID�� ������ ��ų�� ������ ���´�. ������ �߰� ����.
	// End:0x40
	if(!GetSkillInfo(SkillID, SkillLevel, SkillSubLevel, Info))
	{
		Debug("ERROR - no skill info!!");
		return;
	}

	// ���� �Ӽ� ������
	// End:0x60
	if(Info.IconType == 8)
	{
		infItem.ShortcutType = int(EShortCutItemType.SCIT_ATTRIBUTE);
	}
	// End:0xF2
	if(isActiveSkill(Info.IconType))
	{
		// End:0xCA
		if(m_NameStr[getItemTypeIndex(Info.IconType)].GetText() == "")
		{
			m_NameStr[getItemTypeIndex(Info.IconType)].SetText(getSkillTypeString(Info.IconType));
		}
		m_Item[getItemTypeIndex(Info.IconType)].AddItem(infItem);
	}
	else
	{
		// End:0x149
		if(m_NameStr_p[getItemTypeIndex(Info.IconType)].GetText() == "")
		{
			m_NameStr_p[getItemTypeIndex(Info.IconType)].SetText(getSkillTypeString(Info.IconType));
		}

		//------------------ �нú�
		// 50���� ���Ž�ų�� ��Ƽ��, �нú� �Ѵ� �ƴ�(�ؿܿ��� �߰�)
		// End:0x17F
		if(Info.IconType != 50)
		{
			m_Item_p[getItemTypeIndex(Info.IconType)].AddItem(infItem);
		}
	}
}

//���� ��ų �˻�
function bool IsHeroSkillID(int SkillID)
{
	switch(SkillID)
	{
		// End:0x0F
		case 395:
		// End:0x17
		case 396:
		// End:0x1F
		case 1374:
		// End:0x27
		case 1375:
		// End:0x31
		case 1376:
			return true;
		// End:0xFFFF
		default:
			return false;
	}
}

// ������ ��ų �˻�
function bool IsItemSkillID(int SkillID)
{
	switch(SkillID)
	{
		// End:0xFFFF
		default:
			return false;
	}
}

//���� ��ų �˻�
function bool IsChangeSkillID(int SkillID)
{
	switch(SkillID)
	{
		// End:0xFFFF
		default:
			return false;
	}
}


function OnDropItem(String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
	local MagicSkillDrawerWnd script_a;
	local string dragsrcName;

	script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));

	dragsrcName = Left(a_ItemInfo.DragSrcName,10);
	//RequestSkillList();

	
	//debug("CanEnchant");
	switch(a_WindowID)
	{		
		case "ResearchButton":
			if(dragsrcName== "PSkillItem" || dragsrcName == "ASkillItem")
			{
				if(a_ItemInfo.Reserved == 0)
				{
					RequestSkillList();
					script_a.SkillInfoClear();
					script_a.SetAdenaSpInfo();
					script_a.ResearchGuideDesc.SetText(GetSystemString(2041));
					script_a.AddSystemMessage(3070);//�ٲ�� ��
				}
				else
				{
					RequestExEnchantSkillInfo(a_ItemInfo.ID.ClassID, a_ItemInfo.Level, a_ItemInfo.SubLevel);
					script_a.SetCurSkillInfo(a_ItemInfo);
					script_a.txtMySp.SetText(MakeCostString(string(GetuserSP())));
					RequestSkillList();
				}
			}
			break;
	}
}

//SP ��ġ�� ǥ���Ѵ�.
function INT64 GetuserSP()
{
	local UserInfo infoPlayer;
	local INT64 iPlayerSP;

	GetPlayerInfo(infoPlayer);
	iPlayerSP = infoPlayer.nSP;
	return iPlayerSP;
}

// Ʈ�� ����
function TreeClear()
{
	class'UIAPI_TREECTRL'.static.Clear(treeName);
}

function ShowSkillTree()
{
	//Root ��� ����.
	util.TreeHandleInsertRootNode(m_UITree, ROOTNAME, "", 0, 4);
	//+��ư �ִ� ���� ��� ����
	util.TreeHandleInsertExpandBtnNode(m_UITree, LIST1, ROOTNAME);
	//���� ��忡 �۾� ������ �߰�
	util.TreeHandleInsertTextNodeItem(m_UITree, ROOTNAME $ "."$LIST1, GetSystemString(2370), 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true);
	//+��ư �ִ� ���� ��� ����
	util.TreeHandleInsertExpandBtnNode(m_UITree, LIST2, ROOTNAME);
	//���� ��忡 �۾� ������ �߰�
	util.TreeHandleInsertTextNodeItem(m_UITree, ROOTNAME $ "."$LIST2, GetSystemString(2371), 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true);

	//+��ư �ִ� ���� ��� ����
	util.TreeHandleInsertExpandBtnNode(m_UITree, LIST3, ROOTNAME);
	//���� ��忡 �۾� ������ �߰�
	util.TreeHandleInsertTextNodeItem(m_UITree, ROOTNAME $ "."$LIST3, GetSystemString(2372), 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true);

	m_UITree.SetExpandedNode(ROOTNAME$"."$LIST1, true);
	m_UITree.SetExpandedNode(ROOTNAME$"."$LIST2, true);
	m_UITree.SetExpandedNode(ROOTNAME$"."$LIST3, true);
}

/**
 *  ���ʵ����¼�����, �������������޾Ʊ���Ѵ�.
 **/
function updateSubjobInfo(string param, int Event_ID)
{
	local int count, i;

	local int currentSubjobClassID;
	
	local UserInfo myUserInfo;

	//local SubjobInfo tempSubjobInfo;

	// ����
	local int  race;
	//local bool bFlag;
	isDualClass = false;

	//GetMyUserInfo(myUserInfo);
	GetPlayerInfo(myUserInfo);
	
	// �ش������������Ϲ޴´�.
	ParseInt(param, "Count"  , count);
	
	// ��������Ŭ�������̵�
	ParseInt(param, "currentSubjobClassID", currentSubjobClassID);

	if(subjobInfoArray.Length > 0)
	{
		subjobInfoArray.Remove(0, subjobInfoArray.Length);
	}
	
	ParseInt(param, "Race", race);

	//_currentSubjobClassID = currentSubjobClassID;

	// �����⸮��Ʈ���޴´�.(0����, ������1,2,3(�ִ�))
	for(i = 0;i < count;i++)
	{
		subjobInfoArray.Insert(subjobInfoArray.Length, 1);
		
		ParseInt(param, "SubjobClassID_" $ i, subjobInfoArray[i].ClassID);
		ParseInt(param, "SubjobID_"      $ i, subjobInfoArray[i].Id);
		ParseInt(param, "SubjobLevel_"   $ i, subjobInfoArray[i].Level);
		ParseInt(param, "SubjobType_"    $ i, subjobInfoArray[i].Type);

		// ��� Ŭ������ �ϳ��� �ִٸ�..
		// End:0x186
		if(subjobInfoArray[i].Type == 1)
		{
			isDualClass = true;
		}
	}
	for(i = 0;i < count;i++)
	{
		if(subjobInfoArray[i].Type == 0)
			mainLevel = subjobInfoArray[i].Level;
		else if(subjobInfoArray[i].Type == 1)
			dualLevel = subjobInfoArray[i].Level;

		if(currentSubjobClassID == subjobInfoArray[i].ClassID)
		{
			currentType = subjobInfoArray[i].Type;
		}
	}
}

function AddSkillTrainListItem(string param)
{
	local SkillInfo skillinfo;
	
	//��ų ���̵�.
	local int ID;
	//��ų ����
	local int Level;
	local int SubLevel;
	//�Ҹ� SP
	local INT64 SpConsume;
	//�䱸����(�÷��̾��� ���� ������ ���ؼ� ������ �������� �Ǵ��ϸ��)
	local int RequiredLevel;
	//�䱸����(�÷��̾��� ��� Ŭ���� ������ �� �Ͽ� �� ���� �������� �Ǵ�.)
	local int RequiredDualLevel;

	//Player ����
	local UserInfo userinfo;

	//��ų ���̵�.
	local ItemID cID;

	local string strRetName;
	local CustomTooltip T;

	local string strName;
	local string strIconName;

	local string setTreeName;

	local string panelName;
	
	local int currentMainLevel;
	local int currentDualLevel;

	local int _currentMainLevel;
	local int _currentDualLevel;

	//local UserInfo myUserInfo;

	ParseInt(param, "ID", ID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "SubLevel", SubLevel);	
	ParseInt64(param, "SpConsume", SpConsume);
	ParseInt(param, "RequiredLevel", RequiredLevel);
	ParseInt(param, "RequiredDualLevel", RequiredDualLevel);	
 
	//Debug("����� �� ��� �� AddSkillTrainListItem" @ SubLevel) ;
	cID = GetItemID(ID);
	GetSkillInfo(ID , Level, SubLevel, skillInfo);
	GetPlayerInfo(userinfo);

	strName = skillInfo.SkillName;
	strIconName = class'UIDATA_SKILL'.static.GetIconName(cID, Level, SubLevel);
	panelName = skillInfo.IconPanel;	

	//��������.
	util.setCustomTooltip(T);
	util.ToopTipMinWidth(200);
	
	MakeSkillToolTip(strName, cID, Level, SubLevel, param);	

	if(RequiredDualLevel > 0)
	{
		currentMainLevel = mainLevel;	
		currentDualLevel = dualLevel;
	}
	else
	{
		currentMainLevel = userinfo.nLevel;
		currentDualLevel = userinfo.nLevel;
	}	
	
	if(RequiredLevel <= currentMainLevel && RequiredDualLevel <= currentDualLevel)
	{
		if(class'UIDATA_SKILL'.static.SkillIsNewOrUp(cID) == 0)
		{		
			// ���� ��� ��ų
			setTreeName = ROOTNAME$"."$LIST1;			
			strRetName = util.TreeInsertItemTooltipNode(TREENAME, ""$ ID $","$ Level  $","$ newSkillIndex $","$SubLevel, setTreeName, -7, 0, 38, 0, 30, 38, util.getCustomToolTip());

			treeNodeNameNewSkillArray[newSkillIndex] = strRetName;
			//Debug("treeNodeNameNewSkillArray[newSkillIndex]->" @ treeNodeNameNewSkillArray[newSkillIndex]);
			newSkillIndex++;

			if(bDrawBgTree1)
			{
				//Insert Node Item - ������ ���?
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CH3.etc.textbackline", 262, 38, , , , ,14);
			}
			else
			{
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.EmptyBtn", 262, 38);
			}

			bDrawBgTree1 = !bDrawBgTree1;

			//********************************************************************************************************************************************************************

			//Insert Node Item - �����۽��� ���
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
			//Insert Node Item - ������ ������
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, strIconName, 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1);
			
			//-----------------------------------------------IconPanel--------------------------------------------------------------------------------------->
			if(skillInfo.IconPanel != "")
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, panelName, 32, 32, -32, OFFSET_Y_ICON_TEXTURE - 1);
			//<--------------------------------------------------------------------------------------------------------------------------------------------------

			//Operate Type(��Ƽ��/�нú�)
			if(TypeCheck(skillinfo) == true)
			//if(class'UIDATA_SKILL'.static.GetOperateType(cID, Level) == GetSystemString(311))
			{
				//Insert Node Item - ������ ������
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -33, OFFSET_Y_ICON_TEXTURE - 2);
				strName = makeShortStringByPixel(strName, 202, "...");
				//Insert Node Item - ������ �̸�
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true);
				//Insert Node Item - "Lv"
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY, true, true);
				//Insert Node Item - ���� ��
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GOLD);
				//Insert Node Item - MP���� ������(�Ҹ���)
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_MP", 15, 15, 5, OFFSET_Y_SECONDLINE + 1);
				//Insert Node Item - "�Ҹ��� ��"
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(skillInfo.MpConsume), 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY);
				//Insert Node Item - �ð� ������(�����ð�)
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_use", 15, 15, 5, OFFSET_Y_SECONDLINE + 1);
				//Insert Node Item - "�����ð� ��"
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, util.MakeTimeString(skillInfo.HitTime, skillInfo.CoolTime), 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY);
				//Insert Node Item - �ð� ������(����ð�)
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_Reuse", 15, 15, 5, OFFSET_Y_SECONDLINE + 1);
				//Insert Node Item - "����ð� ��"
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, util.MakeTimeString(skillInfo.ReuseDelay) , 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY);
			}
			else
			{
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Passive", 32, 32, -33, OFFSET_Y_ICON_TEXTURE - 2);
				strName = makeShortStringByPixel(strName, 202, "...");
				//Insert Node Item - ������ �̸�
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true);
				//Insert Node Item - "Lv"
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY, true, true);
				//Insert Node Item - ���� ��
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GOLD);
			}

			//********************************************************************************************************************************************************************

		}
		else
		{	
			//����Ŭ���� ������ ���Ŭ���� ������ ���Ѵ�.
			//if(RequiredLevel <=  currentMainLevel && RequiredDualLevel <= currentDualLevel)
			if(RequiredDualLevel > 0)
			{
				_currentMainLevel = mainLevel;
				_currentDualLevel = dualLevel;
				
			}
			else
			{
				_currentMainLevel = userinfo.nLevel;
				_currentDualLevel = userinfo.nLevel;
				
			}
			

			if(RequiredLevel <= _currentMainLevel && RequiredDualLevel <= _currentDualLevel)
			{
				// ������ �� ��ų 
				setTreeName = ROOTNAME$"."$LIST2;
				strRetName = util.TreeInsertItemTooltipNode(TREENAME, ""$ ID $","$ Level $","$ levelUpSkillIndex $","$SubLevel , setTreeName, -7, 0, 38, 0, 32, 38, util.getCustomToolTip());
				treeNodeNameLevelUpArray[levelUpSkillIndex] = strRetName;
				//Debug("treeNodeNameNewSkillArray[newSkillIndex]->" @ treeNodeNameLevelUpArray[levelUpSkillIndex]);

				levelUpSkillIndex++;

				if(bDrawBgTree2)
				{
					//Insert Node Item - ������ ���?
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CH3.etc.textbackline", 257, 38, , , , ,14);
				}
				else
				{
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.EmptyBtn", 257, 38);
				}

				bDrawBgTree2 = !bDrawBgTree2;

				//********************************************************************************************************************************************************************

				//Insert Node Item - �����۽��� ���
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
				//Insert Node Item - ������ ������
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, strIconName, 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1);

				//-----------------------------------------------IconPanel--------------------------------------------------------------------------------------->
				if(skillInfo.IconPanel != "")
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, panelName, 32, 32, -32, OFFSET_Y_ICON_TEXTURE - 1);
				//<--------------------------------------------------------------------------------------------------------------------------------------------------
				
				//Operate Type(��Ƽ��/�нú�)
				//if(class'UIDATA_SKILL'.static.GetOperateType(cID, Level) == GetSystemString(311))
				if(TypeCheck(skillinfo) == true)
				{
					//Insert Node Item - ������ ������
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1);
					strName = makeShortStringByPixel(strName, 206, "...");
					//Insert Node Item - ������ �̸�
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true);
					//Insert Node Item - "Lv"
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY, true, true);
					//Insert Node Item - ���� ��
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GOLD);
					//Insert Node Item - MP���� ������(�Ҹ���)
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_MP", 15, 15, 5, OFFSET_Y_SECONDLINE + 1);
					//Insert Node Item - "�Ҹ��� ��"
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(skillInfo.MpConsume), 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY);
					//Insert Node Item - �ð� ������(�����ð�)
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_use", 15, 15, 5, OFFSET_Y_SECONDLINE + 1);
					//Insert Node Item - "�����ð� ��"
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, util.MakeTimeString(skillInfo.HitTime, skillInfo.CoolTime), 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY);
					//Insert Node Item - �ð� ������(����ð�)
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_Reuse", 15, 15, 5, OFFSET_Y_SECONDLINE + 1);
					//Insert Node Item - "����ð� ��"
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, util.MakeTimeString(skillInfo.ReuseDelay) , 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY);
				}
				else
				{
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Passive", 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1);
					strName = makeShortStringByPixel(strName, 206, "...");
					//Insert Node Item - ������ �̸�
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true);
					//Insert Node Item - "Lv"
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY, true, true);
					//Insert Node Item - ���� ��
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GOLD);
				}
			}
			//********************************************************************************************************************************************************************
		}	
	}
	else
	{		
		setTreeName = ROOTNAME$"."$LIST3;
		strRetName = util.TreeInsertItemTooltipNode(TREENAME, ""$ ID $","$ Level, setTreeName, -7, 0, 38, 0, 32, 38, util.getCustomToolTip());

		if(bDrawBgTree3)
		{
			//Insert Node Item - ������ ���?
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CH3.etc.textbackline", 257, 38, , , , ,14);
		}
		else
		{
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.EmptyBtn", 257, 38);
		}

		bDrawBgTree3 = !bDrawBgTree3;

		//********************************************************************************************************************************************************************

		//Insert Node Item - �����۽��� ���
		util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
		//Insert Node Item - ������ ������
		util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, strIconName, 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1);

		util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.ItemWindow_IconDisable", 32, 32, -32, OFFSET_Y_ICON_TEXTURE - 1);

		//Operate Type(��Ƽ��/�нú�)
		//if(class'UIDATA_SKILL'.static.GetOperateType(cID, Level) == GetSystemString(311))
		if(TypeCheck(skillinfo) == true)
		{
			//Insert Node Item - ������ ������
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1);		}
		else
		{
			//Insert Node Item - ������ ������
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Passive", 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1);
		}
		strName = makeShortStringByPixel(strName, 206, "...");
		//Insert Node Item - ������ �̸�
		util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true);

		//Insert Node Item - "ĳ���� Lv"
		util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(2381) $ " : ", 46, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY, true, true);

		//Insert Node Item - �䱸 ���� ��
		util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(RequiredLevel), 2, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_RED);
		//********************************************************************************************************************************************************************
	}
}

function MakeSkillToolTip(string strName, ItemID ID, int Level, int SubLevel, string param)
{	
	local SkillInfo skillinfo;

	local int skillID;

	//�䱸����(�÷��̾��� ���� ������ ���ؼ� ������ �������� �Ǵ��ϸ��)
	local int RequiredLevel;
	//�䱸����(�÷��̾��� ��� Ŭ���� ������ �� �Ͽ� �� ���� �������� �Ǵ�.)
	local int RequiredDualLevel;

	//��ų�� �ʿ��� ������ ���� 
	local int RequiredItemTotalCnt;
	//ItemID(���� �� ������ŭ �ݺ�) 
	local int requiredItemID;
	//Item �ʿ䰹��(���� �� ������ŭ �ݺ�) 
	local INT64 requiredItemCnt;


	//��ų�� �ʿ��� ���� ��ų ���� 
	local INT64 RequiredSkillCnt;
	//�ʿ� Skill�� ID(���� �� ������ŭ �ݺ�) 
	local int requiredSkillID;
	//�ʿ� Skill�� level(���� �� ������ŭ �ݺ�) 
	local int requiredSkillLevel;


	local itemID requiredID;

	local int i;

	//local string additionalName;
	local int nTmp;

	if(!m_bShow) return;

	ParseInt(param, "ID", skillID);

	GetSkillInfo(skillID , Level, SubLevel, skillInfo);

	ParseInt(param, "RequiredLevel", RequiredLevel);
	ParseInt(param, "RequiredDualLevel", RequiredDualLevel);

	ParseInt(param, "RequiredItemTotalCnt", RequiredItemTotalCnt);
	ParseINT64(param, "RequiredSkillCnt", RequiredSkillCnt);
	
	//additionalName = class'UIDATA_ITEM'.static.GetItemAdditionalName(ID);

	//������ �̸�
	util.ToopTipInsertText(strName, true);	
	//ex) " Lv "
	util.ToopTipInsertText(" " $ GetSystemString(88), true, false, util.ETooltipTextType.COLOR_GRAY);
	//��ų ����
	util.ToopTipInsertText(" " $ string(Level), true, false, util.ETooltipTextType.COLOR_GOLD);
	
	//��æƮ ����
	//util.ToopTipInsertText(additionalName, true, false, util.ETooltipTextType.COLOR_GOLD, 5);

	//Operate Type(��Ƽ��/�нú�)
	util.ToopTipInsertText(getSkillTypeString(SkillInfo.IconType),true,true,util.ETooltipTextType.COLOR_GOLD,0,6);

	util.TooltipInsertItemBlank(6);

	//�Ҹ�HP
	nTmp = class'UIDATA_SKILL'.static.GetHpConsume(ID, Level, SubLevel);
	if(nTmp>0)
	{
		util.TwoWordCombineColon(GetSystemString(1195), string(nTmp), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true);
	}

	//�Ҹ�MP
	nTmp = class'UIDATA_SKILL'.static.GetMpConsume(ID, Level, SubLevel);
	if(nTmp>0)
	{
		util.TwoWordCombineColon(GetSystemString(320), string(nTmp), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true);
	}

	//��ȿ�Ÿ�
	nTmp = class'UIDATA_SKILL'.static.GetCastRange(ID, Level, SubLevel);
	if(nTmp>=0)
	{
		util.TwoWordCombineColon(GetSystemString(321), string(nTmp), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true);
	}
	
	//�����ð� ��
	if(class'UIDATA_SKILL'.static.GetOperateType(Id, Level, SubLevel) == GetSystemString(311))
	{
		util.TwoWordCombineColon(GetSystemString(2377), util.MakeTimeString(skillInfo.HitTime, skillInfo.CoolTime), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true);
	}

	//����ð�
	if(class'UIDATA_SKILL'.static.GetOperateType(Id, Level, SubLevel) == GetSystemString(311))
	{
		util.TwoWordCombineColon(GetSystemString(2378), util.MakeTimeString(skillInfo.ReuseDelay), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true);
	}

	//��ų ����
	util.ToopTipInsertText(class'UIDATA_SKILL'.static.GetDescription(ID, Level, SubLevel), false, true, util.ETooltipTextType.COLOR_GRAY, 0, 6);

	util.TooltipInsertItemBlank(6);
	util.TooltipInsertItemLine();
	util.TooltipInsertItemBlank(3);

	//<���� ����>
	util.ToopTipInsertText("<"$GetSystemString(2375)$">", true, true);
	util.TwoWordCombineColon(GetSystemString(2381), string(RequiredLevel), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true);

	//���Ŭ���� ����
	if(RequiredDualLevel > 0)
	{
		//��� Ŭ���� Lv
		util.TwoWordCombineColon(GetSystemString(2969), string(RequiredDualLevel), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true);
	}

	//�ʿ� ������	
	if(RequiredItemTotalCnt > 0)
	{
		util.TooltipInsertItemBlank(6);
		util.ToopTipInsertText("<"$GetSystemString(2380)$">", true, true);

		for( i = 1 ;i <= RequiredItemTotalCnt ;i++)
		{
			Parseint(param, "requiredItemID"$i, requiredItemID);
			ParseINT64(param, "requiredItemCnt"$i, requiredItemCnt);
			util.ToopTipInsertText(class'UIDATA_ITEM'.static.GetItemName(GetItemID(requiredItemID)) $ " X " $MakeCostStringINT64(requiredItemCnt), false, true, util.ETooltipTextType.COLOR_GOLD);
		}   
	}
	
	//��ų�� �ʿ��� ���� ��ų ���� 
	if(RequiredSkillCnt > 0)
	{
		util.TooltipInsertItemBlank(6);
		util.ToopTipInsertText("<"$GetSystemString(2376)$">", true);

		for(i = 1 ;i <= RequiredSkillCnt ;i++)
		{			
			ParseInt(param, "requiredSkillID"$i, requiredSkillID);
			ParseInt(param, "requiredSkillLevel"$i, requiredSkillLevel);
			
			requiredID = GetItemID(requiredSkillID);
			
			util.TooltipInsertItemBlank(3);
			// !���� �ִ��� Ȯ�� �� �� 
			util.ToopTipInsertTexture(class'UIDATA_SKILL'.static.GetIconName(requiredID, requiredSkillLevel, 0), true, true);
			if(class'UIDATA_SKILL'.static.SkillIsNewOrUp(requiredID) == 0)
			{
				util.ToopTipInsertTexture("l2ui_ct1.ItemWindow_IconDisable" , , , -16);
				util.ToopTipInsertText(class'UIDATA_SKILL'.static.GetName(requiredID, requiredSkillLevel, 0), true, false, util.ETooltipTextType.COLOR_GRAY, 5);
			}
			else
			{
				util.ToopTipInsertText(class'UIDATA_SKILL'.static.GetName(requiredID, requiredSkillLevel, 0), true, false, , 5);
			}
		}
	}
}

function bool TypeCheck(SkillInfo Info)
{
	return isActiveSkill(Info.IconType);
}

/**
 * �ܺο��� ��ų �н��� ��ﶧ �� �Ѵ�.
 **/
function externalCallLearnSkill()
{
	if(IsUseRenewalSkillWnd())
	{
		_isSkillLearnNotice = true;
		class'UIAPI_WINDOW'.static.ShowWindow("SkillWnd");
		return;
	}
	// ������ ����
	m_wndTop.ShowWindow();
	m_wndTop.SetFocus();
	GetWindowHandle("MagicSkillWnd").SetFocus();
	// ��ų ���� ������ �̵�
	m_UITree.SetFocus();
	GetTabHandle("MagicSkillWnd.TabCtrl").SetTopOrder(2, false);

	// �� ���� ��� ó�� 
	OnClickButton("TabCtrl2");
}

/**
 * �ܺο��� ��ų �н��� ��ﶧ �� �Ѵ�.
 **/
function bool isSkillLearnTab()
{
	// ��ų ���� ���̸�.. true
	return GetTabHandle("MagicSkillWnd.TabCtrl").GetTopIndex() == 2;
}

/**
 * 
 */
function closeTreeNode()
{
	m_UITree.SetExpandedNode(beforeTreeName, false);
	beforeTreeName = "";
}


/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="MagicSkillWnd"
     treeName="MagicSkillWnd.SkillTrainTree"
     ROOTNAME="root"
     LIST1="SKILLLIST1"
     LIST2="SKILLLIST2"
     LIST3="SKILLLIST3"
}
