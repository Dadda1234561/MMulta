class SkillTrainInfoWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// CONSTc
//////////////////////////////////////////////////////////////////////////////

const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;

const OFFSET_Y_MPCONSUME = 3;
const OFFSET_Y_CASTRANGE = 0;
const OFFSET_Y_SP = 120;

const SKILLTYPE_ALCHEMYSKILL = 140;

var int m_iType;
var int m_iID;
var int m_iLevel;
var int m_iSubLevel;

var TreeHandle SkillTrainInfoTree;
var L2Util util;
var string treeName;
var Rect rectWnd;

function OnRegisterEvent()
{
	RegisterEvent(EV_SkillTrainInfoWndShow);
	RegisterEvent(EV_SkillTrainInfoWndHide);
	RegisterEvent(EV_SkillTrainInfoWndAddExtendInfo);
}

function OnLoad()
{
	SetClosingOnESC();

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	util = L2Util(GetScript("L2Util"));
	rectWnd = GetWindowHandle("SkillTrainInfoWnd").GetRect();
}

function OnClickButton(string strBtnID)
{
	switch(strBtnID)
	{
		case "btnLearn":
			OnLearn();
			break;
		case "btnGoBackList":
			//HideWindow("SkillTrainInfoWnd");
			ShowWindowWithFocus("SkillTrainListWnd");
			break;
	}
}

function OnLearn()
{
	// �ӽ� - lancelot 2007. 3. 26.
	//local int type;
	//type=-1;
	
	//switch(m_iType)
	//{
	//case ESTT_NORMAL :
	//case ESTT_FISHING :
	//case ESTT_CLAN :
	//case ESTT_TRANSFORM :
	//case 5:
	//		// �����⽺ų
	//case 6:
	//		//ä����ų
	RequestAcquireSkill(m_iID, m_iLevel, m_iSubLevel, m_iType);
		//case ESTT_SUB_CLAN:
		//RequestAcquireSkillSubClan(m_iID, m_iLevel, m_iType, 0);			// ���� 4��° ���ڷ� ���� ������ �ε����� ���� ��. -lpislhy
		//break;
	//default:
	//	break;
	//}
}


function OnEvent(int Event_ID, string param)
{
	local int iType;

	local string strIconName;
	local string strName;
	local int iID;
	local int iLevel;
	local int iSubLevel;
	local INT64 iSPConsume;
	local INT64 iEXPConsume;

	local string strDescription;
	local string strOperateType;

	local int iMPConsume;
	local int iCastRange;
	local INT64 iNumOfItem;

	local string strEnchantName;
	local string strEnchantDesc;

	local int iPercent;

	//Debug("SkillTrainList Event_ID " @ Event_ID);
	//Debug ( "onEvent " @ Event_ID @ param );

	switch(Event_ID)
	{
		case EV_SkillTrainInfoWndShow:
			// Debug("--EV_SkillTrainInfoWndShow" @ param);
			ParseInt(param, "Type", iType);
			m_iType=iType;

			if(m_iType == SKILLTYPE_ALCHEMYSKILL) return; // ���ݼ� �����, ���� �̺�Ʈ�� ������ Ÿ���� �ٸ���.(140)
			if(m_iType == ESTT_SUB_CLAN) return; // �����δ� ��ų�̸� ����
			ParseString(param, "strIconName", strIconName);
			ParseString(param, "strName", strName);
			ParseInt(param, "iID", iID);
			ParseInt(param, "iLevel", iLevel);
			ParseInt(param, "iSubLevel", iSubLevel);
			ParseString(param, "strOperateType", strOperateType);
			ParseInt(param, "iMPConsume", iMPConsume);
			ParseInt(param, "iCastRange", iCastRange);
			ParseINT64(param, "iSPConsume", iSPConsume);
			ParseString(param, "strDescription", strDescription);
			ParseINT64(param, "iEXPConsume", iEXPConsume);
			ParseString(param, "strEnchantName", strEnchantName);
			ParseString(param, "strEnchantDesc", strEnchantDesc);
			ParseInt(param, "iPercent", iPercent);
			m_iType = iType;
			m_iID = iID;
			m_iLevel = iLevel;
			m_iSubLevel = iSubLevel;
			ShowSkillTrainInfoWnd();
			AddSkillTrainInfo(strIconName, strName, iID, iLevel, iSubLevel, strOperateType, iMPConsume, iCastRange, strDescription, iSPConsume, iEXPConsume, strEnchantName, strEnchantDesc, iPercent);
			break;
		case EV_SkillTrainInfoWndAddExtendInfo:
			// Debug("EV_SkillTrainInfoWndAddExtendInfo" @ param);
			if(m_iType == SKILLTYPE_ALCHEMYSKILL) return; // ���ݼ� �����, ���� �̺�Ʈ�� ������ Ÿ���� �ٸ���.(140)
			if(m_iType == ESTT_SUB_CLAN) return; // �����δ� ��ų�̸� ����
			ParseString(param, "strIconName", strIconName);
			ParseString(param, "strName", strName);
			ParseINT64(param, "iNumOfItem", iNumOfItem);
			AddSkillTrainInfoExtend(strIconName, strName, iNumOfItem);
			ShowNeedItems();
			break;
		case EV_SkillTrainInfoWndHide:
			if(m_iType == SKILLTYPE_ALCHEMYSKILL) return; // ���ݼ� �����, ���� �̺�Ʈ�� ������ Ÿ���� �ٸ���.(140)
			if(m_iType == ESTT_SUB_CLAN) return;		// �����δ� ��ų�̸� ����
			if(IsShowWindow("SkillTrainInfoWnd"))
				HideWindow("SkillTrainInfoWnd");
		break;
	}
}



// ��ų Ʈ���̴� ������ �ʱ�ȭ ��Ŵ
function ShowSkillTrainInfoWnd()
{
	local int iWindowTitle;
	local int iSPIdx;

	local UserInfo infoPlayer;
	local int64 iPlayerSP;
	//local INT64 iPlayerEXP;

	GetPlayerInfo(infoPlayer);
	switch(m_iType)
	{
		case ESTT_CLAN :
		case ESTT_SUB_CLAN:
			HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
			HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
			HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIconSlot");
			HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon1");
			HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName1");
			HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIconSlot1");
			iWindowTitle=1436;
			iSPIdx=1372;
			iPlayerSP=INT64(GetClanNameValue(infoPlayer.nClanID));
			break;
		//case ESTT_NORMAL :
		//case ESTT_FISHING :
		default:
			iWindowTitle=477;
			iSPIdx=92;
			iPlayerSP=infoPlayer.nSP;
			//iPlayerEXP=infoPlayer.nCurExp;
			break;
	}

	setWindowTitleBySysStringNum(iWindowTitle); // ���� Ÿ��Ʋ ����
	//SetBackTex("L2UI_CH3.SkillTrainWnd.SkillTrain2"); // 9������� �����ϸ鼭 ����
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtSPString", GetSystemString(iSPIdx));	// SP or ���͸�ġ �۾�
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtSP", String(iPlayerSP)); // SP or ���͸�ġ
	GetTextureHandle("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon").SetTexture("");
	GetTextureHandle("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon1").SetTexture("");
	GetTextBoxHandle("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName").SetText("");
	GetTextBoxHandle("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName1").SetText("");
	ShowWindowWithFocus("SkillTrainInfoWnd");
}

function AddSkillTrainInfo(string strIconName, string strName, int iID, int iLevel, int iSubLevel, string strOperateType, int iMPConsume, int iCastRange, string strDescription, INT64 iSPConsume, INT64 iEXPConsume, string strEnchantName, string strEnchantDesc, int iPercent)
{
	local SkillInfo skillinfo;
	local string strIconPanel;

	GetSkillInfo(iID, iLevel, iSubLevel, skillInfo);
	ChangeSize(false);
	// ������ ������
	class'UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.texIcon", strIconName);


	//----------------------------------------PanelIcon---------------------------------------------------------------------->

	if(skillInfo.IconPanel != "") { strIconPanel = skillInfo.IconPanel;}
	else strIconPanel = "";
	class'UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.IconPanel", strIconPanel);
	//<---------------------------------------------------------------------------------------------------------------------------


	// ��ų�̸�
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtName", strName);

	// level ����
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtLevel", iLevel);
	// �۵�Ÿ��
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtOperateType", strOperateType);
	// �Ҹ�MP
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtMP", iMPConsume);
	// ��ų���� 
	//class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtDescription", strDescription);

	//��ų ����	
	util.TreeClear(treeName);
	//Root ��� ����.
	util.TreeInsertRootNode(treeName, "root", "");
	//Insert Node Item - ������ �̸�
	util.TreeInsertTextNodeItem(treeName, "root", strDescription); //class'UIDATA_SKILL'.static.GetDescription( iID, iLevel ) );

	switch(m_iType)
	{
	case ESTT_CLAN :			// ���ͽ�ų�϶��� �ʿ� ���͸�ġ
	case ESTT_SUB_CLAN:
			// End:0x231
			if(! getInstanceUIData().getIsClassicServer())
			{
				class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString", GetSystemString(1437));
			}
			else
			{
				ChangeSize(true);
			}
		break;
	//case ESTT_NORMAL :			// �׳��� �ʿ�SP
	//case ESTT_FISHING :
	default:
		class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString", GetSystemString(365));
		break;
	}
	// �ʿ�SP ����
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSP", String( iSPConsume ));
	
	if(iCastRange>=0)
	{
		// �����ְ�
		ShowWindow("SkillTrainInfoWnd.txtCastRangeString");
		ShowWindow("SkillTrainInfoWnd.txtColoneCastRange");
		ShowWindow("SkillTrainInfoWnd.txtCastRange");
		class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtCastRange", iCastRange);
	}
	else
	{
		// �����ش�
		HideWindow("SkillTrainInfoWnd.txtCastRangeString");
		HideWindow("SkillTrainInfoWnd.txtColoneCastRange");
		HideWindow("SkillTrainInfoWnd.txtCastRange");
	}
}

function AddSkillTrainInfoExtend(string strIconName, string strName, INT64 iNumOfItem)
{
	// End:0xE2
	if(GetTextBoxHandle("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName").GetText() == "")
	{
		class'UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon", strIconName);
		class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName", (strName $ " X ") $ string(iNumOfItem));		
	}
	else
	{
		class'UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon1", strIconName);
		class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName1", (strName $ " X ") $ string(iNumOfItem));
	}
}

function OnShow()
{
	HideWindow("SkillTrainInfoWnd.SubWndEnchant");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal");
	// �ʿ��� ������ ���� �����ش�	
	HideWindow("SkillTrainInfoWnd.SkillTrainInfoSubWndClanClassic");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIconSlot");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon1");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName1");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIconSlot1");	
	//~ ShowWindow("SkillTrainInfoWnd.txtColoneCastRange");
	if(IsShowWindow("SkillTrainListWnd"))
	{
		HideWindow("SkillTrainListWnd");
	}
	class'UIAPI_WINDOW'.static.SetAnchor("SkillTrainInfoWnd", "SkillTrainListWnd", "TopLeft", "TopLeft", 0, 0);//�⺻ �������� �Ǿ� ������ �̻��ϰ� �� �Ӽ��� ������ Ȯ�� â�� �巡�װ� �ȵ�.
}

function ShowNeedItems()
{	
	// �����۾����ܰ� �̸�
	ShowWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal.texIconSlotBg");
	// End:0x18B
	if(GetTextBoxHandle("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName1").GetText() != "")
	{
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon1");
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName1");
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.texIconSlotBg1");
	}
}

function ChangeSize(bool B)
{
	// End:0x294
	if(B)
	{
		HideWindow("SkillTrainListWnd.txtSPString");
		HideWindow("SkillTrainListWnd.txtSP");
		HideWindow("SkillTrainInfoWnd.SubWndNormal.txtSPString");
		HideWindow("SkillTrainInfoWnd.txtSP");
		HideWindow("SkillTrainInfoWnd.spTextBg");
		HideWindow("SkillTrainInfoWnd.spBg");
		HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString");
		HideWindow("SkillTrainInfoWnd.SubWndNormal.txtColone3");
		HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedSP");
		GetTextureHandle("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon").SetAnchor("SkillTrainInfoWnd", "TopLeft", "TopLeft", 12, 294 - 16);
		GetTextureHandle("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon1").SetAnchor("SkillTrainInfoWnd", "TopLeft", "TopLeft", 12, 332 - 16);
		GetWindowHandle("SkillTrainInfoWnd").SetWindowSize(rectWnd.nWidth, rectWnd.nHeight - 30);		
	}
	else
	{
		ShowWindow("SkillTrainListWnd.txtSPString");
		ShowWindow("SkillTrainListWnd.txtSP");
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtSPString");
		ShowWindow("SkillTrainInfoWnd.txtSP");
		ShowWindow("SkillTrainInfoWnd.spTextBg");
		ShowWindow("SkillTrainInfoWnd.spBg");
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString");
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtColone3");
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedSP");
		GetTextureHandle("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon").SetAnchor("SkillTrainInfoWnd", "TopLeft", "TopLeft", 12, 294);
		GetWindowHandle("SkillTrainInfoWnd").SetWindowSize(rectWnd.nWidth, rectWnd.nHeight);
	}	
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("SkillTrainInfoWnd").HideWindow();
}

defaultproperties
{
     treeName="SkillTrainInfoWnd.SubWndNormal.SkillTrainInfoTree"
}
