/**
 *  ����Ʈ NPC ��ġ UI
 *  
 *  http://wallis-devsub/redmine/issues/2053#change-6920
 *  http://wallis-devsub/redmine/issues/2113
 *  
 **/
class AgitDecoWnd extends UICommonAPI;

const POWER_ENVOY_TYPE = 1000; //���� ������ type

const TOP_MARGIN = 7;
const MAX_SLOT = 5;

// �� ���Ժ� ���� ���� 
struct AgitDecoSlotData
{
	var int slotNum;                   // ���� ��ȣ 0 ���� ����.
	var int decoNpcID;                 // ���� npcID
	var int npcType;                   //
	var int factionType;
	var bool bResponseAvailability;    // ��ġ�� �Ǿ� �ֳ�?
};

var WindowHandle Me;
var ButtonHandle Close_Button;
var WindowHandle AgitSlot_Scroll;
	
var WindowHandle AgitSlot1, AgitSlot2, AgitSlot3, AgitSlot4, AgitSlot5;

// ��� �ϴ� ���� ������ �� 
var int nUseSlotNum;

// ���� ���õ� ���� ����
var int nCurrentSlotNum;
var int nAgitID;

var array<int> domainArray;
var int domainGrade;

// ���� ���Կ� ��ġ�� decoNpcID
var int currentDecoNPCId;

var AgitDecoDrawerWnd AgitDecoDrawerWndScript;
var array<AgitDecoSlotData> agitDecoSlotDataArray;

	//getNpcTypeArray
function OnRegisterEvent()
{
	//RegisterEvent(  );
	RegisterEvent( EV_SendAgitFuncInfo );              // 10100
	RegisterEvent( EV_ResponseDecoNPCAvalability );    // 10110
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function OnHide()
{
	nCurrentSlotNum = -1;
	nAgitID = -1;
	agitDecoSlotDataArray.Length = 0;

	GetWindowHandle("AgitDecoDrawerWnd").HideWindow();
}

function Initialize()
{	
	Me           = GetWindowHandle( "AgitDecoWnd" );

	Close_Button = GetButtonHandle( "AgitDecoWnd.Close_Button" );

	AgitSlot_Scroll  = GetWindowHandle( "AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot_Scroll" );

	AgitSlot1 = GetWindowHandle( "AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot1" );
	AgitSlot2 = GetWindowHandle( "AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot2" );
	AgitSlot3 = GetWindowHandle( "AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot3" );
	AgitSlot4 = GetWindowHandle( "AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot4" );
	AgitSlot5 = GetWindowHandle( "AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot5" );

	agitDecoSlotDataArray.Length = 0;
	
	AgitDecoDrawerWndScript = AgitDecoDrawerWnd(GetScript("AgitDecoDrawerWnd"));

	hideAllSelect();
	//initWindowLoc();
}

// ������ ���� ��ġ(��ġ �� ��ũ�� ������ ����)
function initWindowLoc()
{
	local int i, nWndWidth, nWndHeight;

	//nUseSlotNum = 2;

	// ��ü ���� ������ ������ ���� ��ŭ show, hide 
	for(i = 1; i <= MAX_SLOT ;i++)	
	{
		if (i <= nUseSlotNum) getAgitSlotWnd(i).ShowWindow();
		else getAgitSlotWnd(i).HideWindow();
	}

	// ���� �������� ��Ŀ�� �������ش�. 
	for(i = 2; i <= nUseSlotNum ;i++)	
	{
		getAgitSlotWnd(i - 1).GetWindowSize(nWndWidth, nWndHeight);
		getAgitSlotWnd(i).ClearAnchor();
		getAgitSlotWnd(i).SetAnchor("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(i - 1), 
						 "BottomCenter", "TopCenter", 0, TOP_MARGIN);
	}
		
	// ��ũ�� ����� �缳��
	getAgitSlotWnd(nUseSlotNum - 1).GetWindowSize(nWndWidth, nWndHeight);
	AgitSlot_Scroll.SetScrollHeight((nWndHeight + TOP_MARGIN) * nUseSlotNum);
}

// ���� ���� �� ������1~5
function WindowHandle getAgitSlotWnd(int i)
{
	return GetWindowHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ String(i));
}

// ���� �����찡 ���õǸ� ���õǾ��ٴ� ǥ���� �ؽ��ĸ� �����ش�. �װ� ���� Ű�� ���
function setSelectSlot(int index, bool flag)
{
	if (flag)
	{
		GetTextureHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ index $ ".AgitSlot" $ index $ "_Selectbox_texture").ShowWindow();
		GetWindowHandle("AgitDecoDrawerWnd").ShowWindow();
		GetWindowHandle("AgitDecoDrawerWnd").SetFocus();

		GetTextBoxHandle("AgitDecoDrawerWnd.Title_Faction_text").SetText
			(GetTextBoxHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ index $ ".AgitSlot" $ index $ "Title_text").GetText());
	}
	else 
	{
		GetTextureHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ index $ ".AgitSlot" $ index $ "_Selectbox_texture").HideWindow();
	}

	nCurrentSlotNum = index - 1;	 
}

// ���� �ؽ��� ���� �Ⱥ��̰�..
function hideAllSelect()
{
	local int i;
	for(i = 1; i <= MAX_SLOT; i++) setSelectSlot(i, false);		
}

// ���� ������ ���׸� ���� �ִ´�.
function setAgitSlotPropert(int index, string title, string npcName, string npcDesc, int remainingPeriodSec)
{
	local int dotWidth, dotHeight;

	Debug("-----------------------------------------");
	Debug("index:" @ index);
	Debug("title:" @ title);
	Debug("npcName:" @ npcName);
	Debug("npcDesc:" @ npcDesc);
	Debug("remainingPeriodSec:" @ remainingPeriodSec);

	GetTextBoxHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ index $ ".AgitSlot" $ index $ "Title_text").SetText(title);
	GetTextBoxHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ index $ ".AgitSlot" $ index $ "NPCname_text").SetText(npcName);

	// npcDesc ���� pixel
	GetTextSize(npcDesc, "GameDefault", dotWidth, dotHeight);
	if (dotWidth > 185) 
	{		
		GetTextBoxHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ index $ ".AgitSlot" $ index $ "_ItemContents_text").SetText(makeShortStringByPixel(npcDesc, 186, ".."));
		GetButtonHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ String(index) $ ".AgitSlot" $ index $ "_MouseOverButton").SetTooltipType("text");
		GetButtonHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ String(index) $ ".AgitSlot" $ index $ "_MouseOverButton").SetTooltipCustomType(MakeTooltipSimpleText(npcDesc, 200));
	}
	else
	{
		GetTextBoxHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ index $ ".AgitSlot" $ index $ "_ItemContents_text").SetText(npcDesc);
		GetButtonHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ String(index) $ ".AgitSlot" $ index $ "_MouseOverButton").ClearTooltip();		
	}

	if (remainingPeriodSec >= 0)
		GetTextBoxHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ index $ ".AgitSlot" $ index $ "_ItemDateContents_text").SetText(getStringDayAndTime(remainingPeriodSec));
	else 
		GetTextBoxHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ index $ ".AgitSlot" $ index $ "_ItemDateContents_text").SetText(GetSystemString(27));
}

function OnEvent( int Event_ID, string param )
{
	// npc���� ��ȭ�� �ɾ ���� ���� �Ҷ�..
	if (Event_ID == EV_SendAgitFuncInfo)
	{		
		sendAgitFuncInfoHandler(param);		
	} 
	// deco npc�� ��ġ �� ���
	else if (Event_ID == EV_ResponseDecoNPCAvalability)
	{
		ResponseDecoNPCAvalabilityHandler(param);
	}
}

/**
    deco npc�� ��ġ �� ���

	��SlotNum : ��ġ�� ������ ��ȣ
	��ResponseAvailability (bool ��, true �� ��ġ����, false �� �Ұ�)
	��DecoNPCId : �����κ��� Ȯ�ι��� ���� npc �� id
*/
function ResponseDecoNPCAvalabilityHandler(string param)
{
	local int result;
	//local int decoNPCId, expireTime, slotNum;
		
	// ParseInt( param, "SlotNum"  , slotNum );
	ParseInt( param, "Result", result );
	// ParseInt( param, "DecoNPCId", decoNPCId );
	// ParseInt( param, "ExpireTime ", expireTime );

	Debug("��� ---> ResponseDecoNPCAvalability param : " @ param); 

	// 0 �� ��찡 ����, ��� ����
	if (result == 0) class'UIDATA_AGIT'.static.RequestOpenDecoNPC(nAgitID);
}

// ������ ���� �̸��� �����Ѵ�. (��ȹ�ʿ��� ������..)
function string getSlotName(int slotNum)
{   
	local string slotName;

	if(slotNum == 0)
	{
		// �Ѽ� ������
		slotName = GetSystemString(3432);
	}
	else
	{
		// ������ �� ���ǰ 1~
		slotName = GetSystemString(3447) $ " " $ string(slotNum);
	}

	return slotName;
}

/**
 * 
	��AgitID : ���� UI �� ��� ����Ʈ�� id
	��TotalCnt : int, -1�̸� â�� �� ������ ����. 0 >= �̸� ���� �������ִ� deco npc ��
	(�Ʒ� ������ TotalCnt ����ŭ ��ŷ�Ǿ� ���޵�)
	��SlotNum : ��� ���Կ� ��ġ�Ǿ� �ִ���
	��subType : UI �� ǥ��� ���Ǿ� ���� �̸�����, SysString ���� ġȯ ����
	��Desc : �ش� Ư����� npc �� ���� ����
	��RemainingPeriod : ���� ��밡�ɱⰣ -> �� ������ ���޵� 
	����� ���� -> ���� ���� ���� ����
*/
function sendAgitFuncInfoHandler(string param)
{
	local int totalCnt, slotNum, subType, remainingPeriodSec, factionType, decoNpcId, npcType;
	local string npcDesc, npcStr;
	local int domainCnt, domainValue;
	local int i, level;

	local L2FactionUIData factionData;

	Debug("sendAgitFuncInfoHandler Param: " @ param);

	ParseInt( param, "AgitID"  , nAgitID );
	ParseInt( param, "TotalCnt", totalCnt );

	if (totalCnt <= -1) return;
	else if(!Me.IsShowWindow()) Me.ShowWindow();

	// ����â�� �ݾ� ���´�.
	GetWindowHandle("AgitDecoDrawerWnd").HideWindow();

	ParseInt( param, "Grade"    , domainGrade );
	ParseInt( param, "DomainCnt", domainCnt  );
	
	agitDecoSlotDataArray.Length = 0;
	domainArray.Length = 0;

	hideAllSelect();

	//Debug("domainCnt" @ domainCnt);

	for(i = 0; i < domainCnt; i++)
	{
		ParseInt( param, "Domain_" $ string(i), domainValue );	

		domainArray.Insert(domainArray.Length, 1);
		domainArray[i] = domainValue;

		//Debug("domainValue" @ domainValue);
	}

	// Debug("domainArray len " @ domainArray.Length);

	// ������ ���� ��ġ(��ġ �� ��ũ�� ������ ����)
	nUseSlotNum = totalCnt;
	initWindowLoc();

	for (i = 0; i < totalCnt; i++)
	{	
		npcType = 0;
		ParseInt( param, "SlotNum_" $ i, slotNum );
		ParseInt( param, "SubType_" $ i, subType );
		ParseInt( param, "RemainingPeriod_" $ i, remainingPeriodSec );
		ParseInt( param, "FactionType_" $ i, factionType );
		ParseInt( param, "DecoNPCId_" $ i, decoNpcId );
		ParseInt( param, "Level_" $ i, level );
		ParseInt( param, "NPCType_" $ i, npcType );

		ParseString( param, "Desc_" $ i, npcDesc);

		agitDecoSlotDataArray.Insert(agitDecoSlotDataArray.Length, 1);

		agitDecoSlotDataArray[i].slotNum = i;
		if (decoNpcId > 0) agitDecoSlotDataArray[i].bResponseAvailability = true;
		else agitDecoSlotDataArray[i].bResponseAvailability = false;
		agitDecoSlotDataArray[i].decoNpcID = decoNpcId;
		agitDecoSlotDataArray[i].factionType = factionType;

		// slotNum == 0 �̸� ���� �������̴�. ���� �������� npcType�� 1000
		if (slotNum == 0)
			agitDecoSlotDataArray[i].npcType = POWER_ENVOY_TYPE;
		else 
			agitDecoSlotDataArray[i].npcType = npcType;
		
		if (factionType > 0)	
		{
			GetFactionData(factionType, factionData);
			npcStr = "Lv." $ level $ " " $ factionData.strFactionName $ "-" $ GetSystemString(subType);
		}
		else
		{
			npcStr = "Lv." $ level $ GetSystemString(subType);
		}
		
		// decoNpcId �� ���ο� ���� ��ġ�� npc�� �ֳ� ���ĸ� �Ǵ��Ѵ�.
		if(decoNpcId > 0)
		{
			setAgitSlotPropert(slotNum + 1, getSlotName(slotNum), npcStr, npcDesc, remainingPeriodSec);
		}
		else
		{
			setAgitSlotPropert(slotNum + 1, getSlotName(slotNum), GetSystemString(27), GetSystemString(27), -1);
		}
	}
}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "Close_Button":
			 OnClose_ButtonClick();
			 break;
			
		case "AgitSlot1_MouseOverButton" : hideAllSelect(); setSelectSlot(1, true); AgitDecoDrawerWndScript.updateComboAndList(getCurrentNpcType()); break;
		case "AgitSlot2_MouseOverButton" : hideAllSelect(); setSelectSlot(2, true); AgitDecoDrawerWndScript.updateComboAndList(getCurrentNpcType()); break;
		case "AgitSlot3_MouseOverButton" : hideAllSelect(); setSelectSlot(3, true); AgitDecoDrawerWndScript.updateComboAndList(getCurrentNpcType()); break;
		case "AgitSlot4_MouseOverButton" : hideAllSelect(); setSelectSlot(4, true); AgitDecoDrawerWndScript.updateComboAndList(getCurrentNpcType()); break;
		case "AgitSlot5_MouseOverButton" : hideAllSelect(); setSelectSlot(5, true); AgitDecoDrawerWndScript.updateComboAndList(getCurrentNpcType()); break;
	}
}

function OnClose_ButtonClick()
{
	Me.HideWindow();
}

//---------------------------------------------------------------------------------------------------------
// �ܺο��� ���� ���� �� �� �ִ� �Լ�
//---------------------------------------------------------------------------------------------------------
// ���� ���õǾ� �ִ� ������ ��ȣ -1 �̸� ���� �ȵ� ��
function int getCurrentSelectedSlotNum()
{
	return nCurrentSlotNum;
}

function int getCurrentAgitID()
{
	return nAgitID;
}

function int getDomainGrade()
{
	return domainGrade;
}

function array<int> getDomainArray()
{
	return domainArray;
}

// ���� ��ġ�� �����ΰ�? , decoNpcID�� �˻� 
function bool getCurrentDeployMentSlotByNpcID(int decoNpcID)
{
	local int i;

	for(i = 0; i < agitDecoSlotDataArray.Length; i++)
	{
		
		if (agitDecoSlotDataArray[i].slotNum == nCurrentSlotNum)
		{
			if (agitDecoSlotDataArray[i].decoNpcID == decoNpcID)
			{
				return true;
			}
		}
	}

	return false;
}


// ���� ������ �Ѽ� Ÿ��
function int getCurrentFactionTypeBySlotNum(int slotNum)
{
	local int i;

	for(i = 0; i < agitDecoSlotDataArray.Length; i++)
	{
		
		if (agitDecoSlotDataArray[i].slotNum == slotNum)
		{
			return agitDecoSlotDataArray[i].factionType;
		}
	}

	return -1;
}


function onShow () 
{
	Me.SetFocus();
}


// ���� ��ġ�� �����ΰ�? , decoNpcID�� �˻� 
function int getCurrentNpcType()
{
	local int i;

	for(i = 0; i < agitDecoSlotDataArray.Length; i++)
	{		
		if (agitDecoSlotDataArray[i].slotNum == nCurrentSlotNum)
		{
			return agitDecoSlotDataArray[i].npcType;
		}
	}

	return -1;
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
}

defaultproperties
{
}
