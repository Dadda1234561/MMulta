/**
 * ����Ʈ NPC ��ġ ����â
 * 
 * http://wallis-devsub/redmine/issues/2053#change-6920
 * 
 **/
class AgitDecoDrawerWnd extends UICommonAPI;

const DIALOG_ID_ASK_DELOPY = 10212322;

const POWER_ENVOY_TYPE = 1000; //���� ������ type
const TOTAL_COMBO_TYPE = 9999; //��ü �޺� Ÿ��

var WindowHandle Me;

var TextBoxHandle Title_Faction_text;
var TextBoxHandle Title_NPCtype_text;
var TextBoxHandle Title_NPCcontents_text;

var ComboBoxHandle NPCType_Combobox;

var WindowHandle AgitNPC_ListWnd;
var ListCtrlHandle AgitNPCListCtrl;

var ButtonHandle Place_Button;
var ButtonHandle Close_Button;

var AgitDecoWnd AgitDecoWndScript;

var array<AgitDecoNPCData> AgitDecoNPCDataArray;
var array<AgitDecoNPCTypeList> NpcTypeArray;  

// �����̵� �޴��� ��Ÿ����, Ŭ���� �����ϴ� üũ 
var bool listClickedEnable;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );	
}

function OnDrawerHideFinished()
{
	listClickedEnable = false;
}

function OnDrawerShowFinished()
{
	// ������Ʈ �ɶ��� Ŭ�� ������ ���� �� ���´�.
	listClickedEnable = true;
	// Debug("���� ��������.");
}

function OnShow()
{
	local int i;
	SetClosingOnESC();

		//Debug("AgitDecoWndScript.getDomainGrade()" @ AgitDecoWndScript.getDomainGrade());
	NpcTypeArray.Length = 0;
	AgitDecoNPCDataArray.Length = 0;

	class'UIDATA_AGIT'.static.GetAllDecoNPCInfo(AgitDecoNPCDataArray, NpcTypeArray, AgitDecoWndScript.getDomainGrade(), AgitDecoWndScript.getDomainArray());

	//Debug("AgitDecoNPCDataArray len:" @ AgitDecoNPCDataArray.Length);
	//Debug("NpcTypeArray len" @ NpcTypeArray.Length);
	// NPCType �ĺ��ڽ� ��ü, �Ѽ� ������, ��������, ������ ���� 

	NPCType_Combobox.Clear();
	NPCType_Combobox.AddStringWithReserved(GetSystemString(1046), TOTAL_COMBO_TYPE);

	for(i = 0; i < NpcTypeArray.Length; i++)
	{
		//Debug("NpcTypeArray[i].NpcType" @ NpcTypeArray[i].NpcType);
		//Debug("NpcTypeArray[i].NpcTypeIdx" @ NpcTypeArray[i].NpcTypeIdx);
		NPCType_Combobox.AddStringWithReserved(GetSystemString(NpcTypeArray[i].NpcTypeIdx), NpcTypeArray[i].NpcType);
	}

	if (NpcTypeArray.Length > 0) 
	{
		NPCType_Combobox.SetSelectedNum(0);
		upateAgitDecoNpcData(NPCType_Combobox.GetReserved(0));
	}
}

// npc �޺��� ����� ������Ʈ �Ѵ�. 
function updateComboAndList(int npcType)
{
	local int i;

	// �Ѽ� �������� �Ѽ� �����ܸ� ������
	if (npcType == POWER_ENVOY_TYPE)
	{		
		NPCType_Combobox.AddStringWithReserved(GetSystemString(NpcTypeArray[0].NpcTypeIdx), NpcTypeArray[0].NpcType);
		NPCType_Combobox.DisableWindow();

		upateAgitDecoNpcData(NpcTypeArray[0].NpcType);
	}
	else // ��������, ������ ���� �� ���´�.
	{
		NPCType_Combobox.EnableWindow();

		// NPCType �ĺ��ڽ� ��ü, �Ѽ� ������, ��������, ������ ���� 
		NPCType_Combobox.Clear();
		NPCType_Combobox.AddStringWithReserved(GetSystemString(1046), TOTAL_COMBO_TYPE);

		// ���� �������� ��, ���� ����, ������ ���� �� �������� 1����
		for(i = 1; i < NpcTypeArray.Length; i++)
		{
			NPCType_Combobox.AddStringWithReserved(GetSystemString(NpcTypeArray[i].NpcTypeIdx), NpcTypeArray[i].NpcType);
		}

		// ��ü�� �⺻���� ������Ʈ �Ѵ�.
		NPCType_Combobox.SetSelectedNum(0);
		upateAgitDecoNpcData(TOTAL_COMBO_TYPE);
	}
}


// npcID�� ����Ʈ ���� ����ü�� ���� �޴´�.
function AgitDecoNPCData getAgitDecoNPCDataByNpcID(int npcId)
{
	local int i;
	local AgitDecoNPCData rAgitDecoNPCData;

	for(i = 0; i < AgitDecoNPCDataArray.Length; i++)
	{
		if (AgitDecoNPCDataArray[i].NpcId == npcId)
		{
			rAgitDecoNPCData = AgitDecoNPCDataArray[i];
			break;			
		}
	}

	return rAgitDecoNPCData;
}

//function string getDecoNpcTypeString(int decoNpcType)
//{
//	local int i;

//	for(i = 0; i < NpcTypeArray.Length; i++)
//	{
//		Debug("NpcTypeArray[i].NpcType" @ NpcTypeArray[i].NpcType);
//		Debug("NpcTypeArray[i].NpcTypeIdx" @ NpcTypeArray[i].NpcTypeIdx);

//		if (NpcTypeArray[i].NpcType == decoNpcType)
//		{
//			return GetSystemString(NpcTypeArray[i].NpcTypeIdx);
//		}
//	}

//	return "";
//}

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle( "AgitDecoDrawerWnd" );
	
	Title_Faction_text = GetTextBoxHandle( "AgitDecoDrawerWnd.Title_Faction_text" );
	Title_NPCtype_text = GetTextBoxHandle( "AgitDecoDrawerWnd.Title_NPCtype_text" );
	Title_NPCcontents_text = GetTextBoxHandle( "AgitDecoDrawerWnd.Title_NPCcontents_text" );

	NPCType_Combobox = GetComboBoxHandle( "AgitDecoDrawerWnd.NPCType_Combobox" );
	AgitNPCListCtrl  = GetListCtrlHandle( "AgitDecoDrawerWnd.AgitNPC_ListWnd.AgitNPCListCtrl");

	Place_Button = GetButtonHandle( "AgitDecoDrawerWnd.Place_Button" );
	Close_Button = GetButtonHandle( "AgitDecoDrawerWnd.Close_Button" );

	AgitNPCListCtrl.DeleteAllItem();

	// ���� �������� �ִ� api , ���� ����
	AgitNPCListCtrl.SetSelectedSelTooltip(false);	
	AgitNPCListCtrl.SetAppearTooltipAtMouseX(true);

	AgitDecoWndScript = AgitDecoWnd(GetScript("AgitDecoWnd"));

	AgitDecoNPCDataArray.Length = 0;
}

function upateAgitDecoNpcData(int selectedNpcType)
{	
	local int i, n;

	local int currentDecoNpcType;

	// ��ġ ���(������ �����ϱ� ���ؼ� String ���� ��ȯ)(�Ƶ���, ��ū ����)
	local string priceTokenParam;

	local L2FactionUIData factionData;

	local string titleStr;
	local bool bDeployMent, bUseButton;
	local int addAdenaCnt;
	
	currentDecoNpcType = AgitDecoWndScript.getCurrentNpcType();

	Debug("currentDecoNpcType" @ currentDecoNpcType);

	AgitNPCListCtrl.DeleteAllItem();
	
	// ��� ���� , �߰�
	if (currentDecoNpcType != POWER_ENVOY_TYPE || (currentDecoNpcType <= 0)) // �Ѽ� �������� �Ѽ� �����ܸ� ���;� �ϰ�, ��ġ ������ ��� ���� ����.
	{
		addItem(GetSystemString(869), priceTokenParam, "", 0, 0, false);
	}

	for (i = 0; i < AgitDecoNPCDataArray.Length; i++)
	{		
		// ���� ������ ���� ����.  
		if (selectedNpcType != AgitDecoNPCDataArray[i].NpcType && selectedNpcType != TOTAL_COMBO_TYPE) continue;

		// ���� ������ ��ư�� ������ ��Ȳ�� �ƴ� ���, ���� ������ ����� �������� �ʴ´�.
		if (selectedNpcType != POWER_ENVOY_TYPE && AgitDecoNPCDataArray[i].NpcType == POWER_ENVOY_TYPE) continue;

		// ��ġ ���
		priceTokenParam = "";
		addAdenaCnt = 0;
		if (AgitDecoNPCDataArray[i].PriceAdena > 0) addAdenaCnt++;
		ParamAdd(priceTokenParam, "totalCnt", String(addAdenaCnt + AgitDecoNPCDataArray[i].PriceToken.Length));

		// �Ƶ��� 
		ParamAdd(priceTokenParam, "item_0", String(57)); // �Ƶ��� ItemId = 57
		ParamAdd(priceTokenParam, "count_0", String(AgitDecoNPCDataArray[i].PriceAdena));
		
			
		// ��ū
		for(n = 0; n < AgitDecoNPCDataArray[i].PriceToken.Length; n++)
		{
			ParamAdd(priceTokenParam, "item_" $ String(n + 1) , String(AgitDecoNPCDataArray[i].PriceToken[n].ItemClassID));
			ParamAdd(priceTokenParam, "count_" $ String(n + 1), String(AgitDecoNPCDataArray[i].PriceToken[n].Cnt));
		}		

		ParamAdd(priceTokenParam, "desc", AgitDecoNPCDataArray[i].Desc);
		ParamAdd(priceTokenParam, "period", String(AgitDecoNPCDataArray[i].Period));

		// http://wallis-devsub/redmine/issues/2113
		// ��� String ����  Level + Sub_type_desc + "-" + faction

		// Debug("AgitDecoNPCDataArray[i].FactionType" @ AgitDecoNPCDataArray[i].FactionType);

		if (AgitDecoNPCDataArray[i].FactionType > 0)	
		{
			GetFactionData(AgitDecoNPCDataArray[i].FactionType, factionData);
			titleStr = "Lv." $ AgitDecoNPCDataArray[i].Level $ " " $ 
					    factionData.strFactionName $ "-" $ GetSystemString(AgitDecoNPCDataArray[i].SubTypeIdx);
		}
		else
		{
			titleStr = "Lv." $ AgitDecoNPCDataArray[i].Level $ " " $ 
					   GetSystemString(AgitDecoNPCDataArray[i].SubTypeIdx);
		}

		//Debug("priceTokenParam" @ priceTokenParam);

		// ��ġ �Ǿ��� üũ
		bDeployMent = AgitDecoWndScript.getCurrentDeployMentSlotByNpcID(AgitDecoNPCDataArray[i].DecoNpcId);

		if (bDeployMent) bUseButton = true;
			
		addItem(titleStr, priceTokenParam, AgitDecoNPCDataArray[i].Desc, AgitDecoNPCDataArray[i].Period, AgitDecoNPCDataArray[i].DecoNpcId, bDeployMent);
	}
	// ��ġ �� ���¿��� �Ѽ� ������ ����̸� ���ġ �Ǵ� ��ġ ������ �ȵȴ�.
	if (bUseButton && currentDecoNpcType == POWER_ENVOY_TYPE)
	{
		Place_Button.DisableWindow();
	}
	else
	{
		Place_Button.EnableWindow();
	}
}

/** 
 * �������� �߰� �Ѵ�.
 * - ��Ʈ��, ��ġ����  
 **/
function addItem(string viewStr, string tokenPriceParam, string functionDesc, int periodSec, int decoNpcId, bool bDeployment)
{
	local LVDataRecord Record;

	Record.LVDataList.length = 1;

	Record.nReserved1 = decoNpcId;
	Record.nReserved2 = boolToNum(bDeployment);
	// ������ 

	// "��ġ��" �� ��� Į�� ���� �ٸ��� �Ѵ�.
	if (bDeployment) 
	{
		record.LVDataList[0].buseTextColor = True;
		Record.LVDataList[0].textColor = getColor(238, 170, 34, 255);
		viewStr = viewStr $ " " $ "(" $ GetSystemString(3441) $ ")"; // ��ġ ��
	}

	// ��� �� ��, �̸� Į�� ���� ���� ��Ų��.
	if (viewStr == GetSystemString(869))
	{
		record.LVDataList[0].buseTextColor = True;
		Record.LVDataList[0].textColor = getColor(255, 102, 102, 255);
	}
	
	// ����Ʈ �ؽ�Ʈ
	Record.LVDataList[0].szData = viewStr;

	Record.LVDataList[0].textAlignment = TA_Left;
	//	Record.LVDataList[1].HiddenStringForSorting = String(info.ItemNum);

	// ���, �Ƶ�Ÿ, ��ū param ������
	Record.szReserved = tokenPriceParam;

	AgitNPCListCtrl.InsertRecord( Record );
}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "Place_Button":
			 OnPlace_ButtonClick();
			 break;

		case "Close_Button":
			 OnClose_ButtonClick();
	 		 break;
	}
}

function OnPlace_ButtonClick()
{
	Debug("��ġ Ŭ��");
	selectListNpc();
}

function OnClose_ButtonClick()
{
	Me.HideWindow();
}

//���ڵ带 Ŭ���ϸ�....
function OnDBClickListCtrlRecord( string ListCtrlID )
{
	switch(ListCtrlID)
	{
		case "AgitNPCListCtrl":
			
			// select = record.LVDataList[0].szData;			
			if (listClickedEnable) selectListNpc();
			break;
	}
}

function selectListNpc()
{
	local LVDataRecord record;
	local int messageNum;
	//select = record.LVDataList[0].szData;			
	
	if(Place_Button.IsEnableWindow())
	{
		if (AgitNPCListCtrl.GetSelectedIndex() >= 0)
		{
			AgitNPCListCtrl.GetSelectedRec( record );

			if (record.nReserved2 == 0)
			{
				Debug("record.LVDataList[0].szData" @ record.LVDataList[0].szData);

				DialogSetID( DIALOG_ID_ASK_DELOPY );

				//  �Ѽ� ������
				if(AgitDecoWndScript.getCurrentNpcType() == POWER_ENVOY_TYPE)
				{
					///���� ���������� ��ġ ����� �����ϴ�. ��ġ�� ���� ���������� ��ġ �Ⱓ ���� ������ ������ �Ұ��� �ϸ�, ��ġ �Ⱓ ����Ǹ� �ڵ����� ö���մϴ�.
					// ��� �����Ͻðڽ��ϱ�?
					messageNum = 4383;
				}
				else 
				{
					// "��� �� ��" �̸�..
					if (Record.LVDataList[0].szData == GetSystemString(869))
					{
						//���� ��ġ�Ǿ� �ִ� �������� ö����ŵ�ϴ�. ��ġ ����� ȯ�ҵ��� �ʽ��ϴ�. ��� �����Ͻðڽ��ϱ�?
						messageNum = 4384;
					}
					else
					{
						// ��ġ ����� ������ �Ⱓ���� �ڵ����� ���� â���� ����ǰ�, ����� ������ ��� �ڵ����� �ʱ�ȭ �˴ϴ�.��� �����Ͻðڽ��ϱ�?
						messageNum = 4366;
					}
				}
				DialogShow(DialogModalType_Modal, DialogType_OKCancel, GetSystemMessage(messageNum) , string(self));
			}
			else
			{
				Debug("�̹� ��ġ �� ����");
			}
		}
	}
	//DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage( systemMessageNum ) , string(self));	 
}

function OnEvent( int Event_ID, string param )
{
	if ( Event_ID == EV_DialogOK )
	{
		HandleDialogOK();	
	} 
	else if ( Event_ID == EV_DialogCancel )
	{	
		HandleDialogCancel();
	}
}

//���� �̸� ���� �� Ȯ�� ��ư Ŭ�� �̺�Ʈ 
function HandleDialogOK()
{
	if( DialogIsMine() )
	{
		switch( DialogGetID() )
		{
			case DIALOG_ID_ASK_DELOPY:
				 requestDeployment();
				 break;
		}
	}
}

// ��ġ�� ��û 
function requestDeployment()
{
	local int agitID, slotNum, decoNpcId;
	local LVDataRecord record;

	//select = record.LVDataList[0].szData;			

	AgitNPCListCtrl.GetSelectedRec( record );
	
	agitID    = AgitDecoWndScript.getCurrentAgitID();
	slotNum   = AgitDecoWndScript.getCurrentSelectedSlotNum();
	decoNpcId = int(record.nReserved1);

	class'UIDATA_AGIT'.static.RequestCheckAvailability(agitID, slotNum, decoNpcId);

	Debug("Call---- > RequestCheckAvailability()");
	Debug("agitID:"    @ agitID);
	Debug("slotNum:"   @ slotNum);
	Debug("decoNpcId:" @ decoNpcId);
}


//���� �̸� ���� �� ��� ��ư Ŭ�� �̺�Ʈ 
function HandleDialogCancel()
{
	if( DialogIsMine() )
	{
		switch( DialogGetID() )
		{
			case DIALOG_ID_ASK_DELOPY:
		         Debug("���� �ƹ��͵�");
				 break;
		}
	}
}

function OnComboBoxItemSelected(string StrID, int IndexID)
{
	switch(strID)
	{
		case "NPCType_Combobox" : 			 
			 upateAgitDecoNpcData(NPCType_Combobox.GetReserved(IndexID));
			 break;
	}
}

function array<AgitDecoNPCTypeList> getNpcTypeArray()
{
	return NpcTypeArray;
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
