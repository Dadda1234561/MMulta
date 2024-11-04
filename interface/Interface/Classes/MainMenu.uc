//------------------------------------------------------------------------------------------------------------------------
//
// ����         : MainMenu  ���� SystemMenuWnd�� �������� ���� - SCALEFORM UI
//              : MenuWnd.uc + SystemMenuWnd.uc
//                ���� �޴�
//
//------------------------------------------------------------------------------------------------------------------------
class MainMenu extends L2UIGFxScript;
/*
//�÷��� �ɼ� ��ǥ
const FLASH_XPOS = 0;
const FLASH_YPOS = -21;

//SubMenu ���� Flash �ִ� 250 ~ �ּ� 166���� ���Ƴ���.
const SUBMENUWIDTH  = 166;
// �߱� ���� �޴��� ��10��, ���� 5�� (202�ȼ�), �ѱ���166 ����4�� ,���� �� 8��
const MAINMENUWIDTH = 166; 

//���� �޴� ����Ʈ �迭
var array<string> LIST;
//���� �޴� ���� �迭
var array<string> LISTCOMMAND;
//���� �޴� �̸� �迭
var array<int> LISTMENUNAME;
//����1 �޴� ����Ʈ �迭
var array<string> LISTSUB1;
//����2 �޴��� ����1 �迭
var array<int> LISTSUB2NUM;
//����1 �޴� ���� �迭
var array<string> LISTSUB1COMMAND;
//����2 �޴� ����Ʈ �迭
var array<string> LISTSUB2;

//���� ���� PeaceZone�ΰ�
var int IsPeaceZone;		

//�޴��� �ѹ� ����� ���� ����
var bool IsStart;

//UI�� UC
var L2Util util;

var toolTipWnd toolTipWndGFXScript;

//����Ű ������
var string groupName;

const DIALOGID_Gohome = 4420;
*/
function OnRegisterEvent()
{
	/*
	RegisterEvent( EV_GamingStateEnter );
	RegisterEvent( EV_ShowWindow );

	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );

	RegisterEvent( EV_StateChanged );
	RegisterEvent( EV_SetRadarZoneCode ); //branch 111109*/
}

function OnLoad()
{
	/*
	SetClosingOnESC();

	registerState( "MainMenu", "GamingState" );
	//SetAlwaysFullAlpha( true );
	SetHavingFocus( false );
	
	SetHUD();//nextFocus �� ���� �������� SetDefaultShow �� �Ѵ� ó�� ������ �и� 
	SetDefaultShow(true);
	SetAnchor( "", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0 );
	//SetAnchor( "", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_BottomRight, FLASH_XPOS, FLASH_YPOS );
	

	groupName = "GamingStateShortcut";
	IsStart = false;

	//���� �޴� ������ �迭 ����
	SetLISTDATA();	

	util = L2Util(GetScript("L2Util"));	

	toolTipWndGFXScript = toolTipWnd(GetScript("toolTipWnd"));	*/
}
/*
function OnShow()
{
	// empty
	
}

function OnFlashLoaded()
{
	// empty
}	

function OnHide(){}

function OnFocus(bool bFlag, bool bTransparency)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args,2);	
	args[0].setbool(bflag);
	args[1].setbool(bTransparency);
	AllocGFxValue(invokeResult);
		
	Invoke("_root.onFocus", args, invokeResult);

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);	
}

function OnCallUCLogic( int logicID, string param )
{	
	local string strSection;

	ParseString(param, "strSection", strSection);
	
	if( logicID == 0 )
	{
		switch( strSection )
		{
			//����Ʈ
			case "Quest":
				ToggleOpenQuestWnd();
				break;
			//���;׼�
			case "Clan":
				ToggleOpenClanWnd();
				break;
			//�θư���
			case "Personal":
				ToggleOpenPersonalConnectionsWnd();
				break;
			//��ų&����
			case "Skill":
				ToggleOpenSkillWnd();
				break;
			//ĳ���� ����
			case "Char":
				ToggleOpenCharInfoWnd();
				break;
			//�κ��丮
			case "Inven":
				ToggleOpenInventoryWnd();
				break;
			//�׼�
			case "Action":
				ToggleOpenActionWnd();
				break;
			//����
			case "Map":
				RequestOpenMinimap();
				break;
		}
	}

	//Sub1 �޴����� ������ ��
	else if( logicID == 1 )
	{
		switch( strSection )
		{
			case "Quit":
				ExecuteEvent(EV_OpenDialogQuit);
				break;
			case "Restart":
				ExecuteEvent(EV_OpenDialogRestart);
				break;
			//�ɼ�â ����
			case "Option":
				HandleShowOptionWnd();
				break;
			//��ũ��
			case "Macro":
				ExecuteEvent(EV_MacroShowListWnd);
				break;
			//����Ű
			case "Shortcut":
				HandleShowShortcutAssignWnd();
				break;
			//����
			case "Service":
				//����
				break;
			//�߰����
			case "Add":
				//����
				break;
			//����
			case "Map":
				RequestOpenMinimap();
				break;
			//�ڹ��� > ����20121109
			/*
			case "Museum":
				ExecuteEvent(EV_StatisticWndshow);
				break;
			*/
			//�Խ���
			case "Board":
				HandleShowBoardWnd();
				break;
			//�Խ���/������ϱ�
			case "QABoard":
				handleShowQABoardWnd();
				break;
			//�θư���
			case "Personal":
				ToggleOpenPersonalConnectionsWnd();
				break;
			//��Ƽ��Ī
			case "Party":
				HandlePartyMatchWnd();
				break;
			//������
			case "Post":
				HandleShowPostBoxWnd();
				break;
			//���λ���
			case "Shop":
				//����
				break;
			//��ǰ �κ��丮
			case "Product":
				HandleShowProductInventory();
				break;
			//����
			case "Help":
				HandleShowHelpHtmlWnd();
				break;
			//����
			case "Petition":
				HandleShowPetitionBegin();
				break;
			case "instanceZone":
				HandleShowInstanceZone();
				break;
			//PC�� �̺�Ʈ
			case "PC":
				HandleShowPCWnd();
				break;
			//24Hz
			/*
			case "24Hz":
				W24HzShowWnd();
				break;
			*/      
			//������ ��ȭ
			case "Rec":
				HandleShowMovieCaptureWnd();
				break;
			//���÷��� ��ȭ
			case "reRec":
				DoAction( class'UICommonAPI'.static.GetItemID(55) );
				break;
			//Ȩ������
			case "Home":
				linkHomePage();
				break;
			//�ǸŻ���
			case "SellStore":
				DoAction( class'UICommonAPI'.static.GetItemID(10) );
				break;
			//���Ż���
			case "BuyStore":
				DoAction( class'UICommonAPI'.static.GetItemID(28) );
				break;
			//�ϰ��ǸŻ���
			case "AllSell":
				DoAction( class'UICommonAPI'.static.GetItemID(61) );
				break;
			//�����˻�
			case "StoreSearch":
				DoAction( class'UICommonAPI'.static.GetItemID(57) );
				break;
			case "ClanSearch":
				HandleShowClanSearch();
				break;

			case "IngameNoticeWnd":
				handleShowInGameNoticeWnd();
		
				break;
			case "PathToAwakening":
				//9800 ����
				ExecuteEvent( EV_ShowWebPathMainPage );
				break;
			
		}
	}
	// ���� ����
	else if( logicID == 10001 )
	{
		toolTipWndGFXScript.externalCall(1, param);
	}
	// ���� ����
	else if( logicID == 10002 )
	{
		toolTipWndGFXScript.externalCall(2, "");
	}
}

function handleShowInGameNoticeWnd()
{
	local IngameNoticeWnd script;
	
	script = IngameNoticeWnd ( GetScript("IngameNoticeWnd") );
	script.MainMenuShow();
}

function HandleShowClanSearch()
{
	local string windowName;  

	windowName = "ClanSearch";

	if ( class'UIAPI_WINDOW'.static.IsShowWindow (windowName) )
	{
		class'UIAPI_WINDOW'.static.HideWindow(windowName);
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow(windowName);
	}
	
}


function OnEvent(int Event_ID, string param)
{
	local int zonetype;

	if( Event_ID == EV_GamingStateEnter )
	{
		if( IsStart == false )
		{
			SetShowWindow();

			CreateMainMenu();
			CreateMainMenuTooltip();

			CreateMenuWidth();

			CreateSub1Menu();
			CreateSUB1Tooltip();

			CreateSub2Menu();
			IsStart = true;
		}
		else
		{
			SetShowWindow();
			CreateSub1Menu();
			CreateSUB1Tooltip();
			CreateSub2Menu();
		}
	}
	else if ( Event_ID == EV_SetRadarZoneCode )
	{
		ParseInt( param, "ZoneCode", zonetype );		
		if (zonetype == 12)
		{
			IsPeaceZone = 1;
		}
		else
		{
			IsPeaceZone = 0;
		}
	}
	else if( Event_ID == EV_DialogOK )
	{
		HandleDialogOK();
	}
	else if( Event_ID == EV_ShowWindow )
	{
		HandleSubMenuOpen( param );
	}
	else if( Event_ID == EV_StateChanged )
	{
		HandleStateChange( param );
	}
}

function changeEnterChat( string str )
{
	groupName = str;
	updateTooltip();
}


function updateTooltip()
{		
	CreateMainMenuTooltip();
	CreateSUB1Tooltip();
}


function HandleStateChange( String state )
{
	local	FlightShipCtrlWnd			scriptShip;
	local	FlightTransformCtrlWnd		scriptTrans;
	
	if( state == "GAMINGSTATE" )
	{
		scriptShip = FlightShipCtrlWnd ( GetScript("FlightShipCtrlWnd") );
		scriptTrans = FlightTransformCtrlWnd ( GetScript("FlightTransformCtrlWnd") ); 

		if(GetOptionBool( "CommunIcation", "EnterChatting" ))
		{	
			changeEnterChat( "TempStateShortcut" );			
		}
		else
		{
			changeEnterChat( "GamingStateShortcut" );
		}
		
		//
		if(scriptShip.isNowActiveFlightShipShortcut) 	// ������ ���� �����		
		{
			//if(GetOptionBool( "Game", "EnterChatting" ))	{class'ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");}
			//Debug("isNowActiveFlightShipShortcut???? ������ ���� �����");
			changeEnterChat( "FlightStateShortcut" );
			//class'ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");
		}
		else if (scriptTrans.isNowActiveFlightTransShortcut ) // ���� ����ü �����
		{
			//Debug("isNowActiveFlightTransShortcut????  ���� ����ü ���");
			changeEnterChat("FlightTransformShortcut");
			//if(GetOptionBool( "Game", "EnterChatting" ))	{class'ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");}
			//class'ShortcutAPI'.static.ActivateGroup("FlightTransformShortcut");
		}
	}
}


function HandleSubMenuOpen( string a_Param )
{
	local string WNDName;
	ParseString(a_Param, "Name", WNDName);

	if( WNDName == "SystemMenuWnd" )
	{
		//ShowWindowWithFocus();
		ShowWindow();
		SetFocus();
		OpenSub1Menu();
	}
}

/**
 * ���� �޴� �����. 
 * 0�� ȣ��
 */
function CreateMainMenu()
{
	dispatchEventToFlash_String(0 , TransArrayToString(LIST));
}

/**
 * �޴� ���� 
 */
function CreateMenuWidth()
{
	// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);		
	AllocGFxValue(invokeResult);

	// ���� �˶� : �̺�Ʈ ��ȣ 5��
	args[0].SetInt( 5 );

	CreateObject(args[1]);
	args[1].SetMemberInt( "MAINMENUWIDTH" , MAINMENUWIDTH );
	args[1].SetMemberInt( "SUBMENUWIDTH"  , SUBMENUWIDTH );	
	 
	Invoke( "_root.onEvent", args, invokeResult );

	DeallocGFxValue( invokeResult );
	DeallocGFxValues( args );	
}

/**
 * Sub1 �޴� �����.
 */
function CreateSub1Menu()
{
	
	LISTSUB1.remove( 0, LISTSUB1.Length );
	SetLISTSUB1DATA();	
	dispatchEventToFlash_String(10 , TransArrayToString(LISTSUB1));		
	//Debug("! --- CreateSub1Menu create" @ LISTSUB1.length );
}

/**
 * Sub2 �޴� �����.
 */
function CreateSub2Menu()
{
	
	LISTSUB2.remove( 0, LISTSUB2.Length );
	SetLISTSUB2DATA();	
	dispatchEventToFlash_String(20 , TransArrayToString(LISTSUB2));		
	//Debug("! --- CreateSub2Menu create" @ LISTSUB2.length);
}

/**
 * ���� �޴� ����.
 */
function OpenSub1Menu()
{
	dispatchEventToFlash_String(100 , "");		
}



/**
 * �ѱ��� ���� �޴� ����.
 */
function SetLISTDATA()
{	
	local int MAINum;
	MAINum = 0;
	SetLIST(  MAINum, 434, "Char", "DetailStatusWnd" );     //ĳ���� ����
	SetLIST(++MAINum, 1,   "Inven","InventoryWnd");         //�κ��丮
	SetLIST(++MAINum, 197, "Action","ActionWnd");           //�׼�
	SetLIST(++MAINum, 196, "Skill","MagicSkillWnd");        //��ų
	SetLIST(++MAINum, 198, "Quest","QuestTreeWnd");         //����Ʈ
	SetLIST(++MAINum, 314, "Clan", "ClanWnd");              //���;׼�
	SetLIST(++MAINum, 447, "Map", "MinimapWnd" );           //��
	SetLIST(++MAINum, 2641,"Total","SystemMenuWnd");        //���ո޴�
}

function SetLIST (int MAINum, int stringNum, string menuID, string tooltipCommand)
{
	local string MenuName;
	MenuName = GetSystemString(stringNum);		
	LIST[MAINum] = MAINum $ "|" $ MenuName $ "|" $ menuID $ "|<NORMAL_FONT13>" $ MenuName $ "<br/>&lt;����Ű:&gt;";	
	LISTMENUNAME[MAINum]= stringNum;
	LISTCOMMAND[MAINum] = tooltipCommand;
}

function CreateMainMenuTooltip()
{
	local int i;
	local array<string> LISTToolTip;
	for (i=0; i< LISTCOMMAND.Length ; i++)
	{
//		Debug("CreateMainMenuTooltip" @ LISTMENUNAME[i] @  LISTCOMMAND[i]);
		LISTToolTip[i] = setMainShortcutString( LISTMENUNAME[i], LISTCOMMAND[i]);
	}
	dispatchEventToFlash_String(1 , TransArrayToString(LISTToolTip));	
}

function string TransArrayToString( array<string> arr )
{
	local int i;
	local string str;

	for( i = 0 ; i < arr.Length ; i ++ )
	{
		if( i !=  arr.Length - 1 )
		{
			str = str $ arr[i] $ "!";
		}
		else
		{
			str = str $ arr[i];
		}
	}
	return str;
}

function SetLISTSUB1DATA()
{
	local ELanguageType Language;	
	local int sub1num;
	local int bValue;

	local bool isClassic;
	
	isClassic = getInstanceUIData().getIsClassicServer();

	Language = GetLanguage();
	sub1num=0;

	setLISTSUB1(  sub1num, 148,  "Quit",    false, 1, "");                  //���� ����
	setLISTSUB1(++sub1num, 147,  "Restart", false, 1, "");                  //����ŸƮ
	inputDivision( ); //�и���--------------------------------------------------------------------
	setLISTSUB1(++sub1num, 146,  "Option",  false, 1, "OptionWnd");         //�ɼ�
	setLISTSUB1(++sub1num, 711,  "Macro",   false, 1, "MacroWnd");          //��ũ��
	setLISTSUB1(++sub1num, 1523, "Shortcut",false, 1, "");	                //����Ű
	inputDivision( ); //�и���--------------------------------------------------------------------
	setLISTSUB1(++sub1num, 2643, "Service", true,  1, "");                  //����	
	inputDivision( ); //�и���--------------------------------------------------------------------
	setLISTSUB1(++sub1num, 2642, "Add_Tooltip", true, 1, "");	            //�߰����	
	//inputDivision( ); //�и���--------------------------------------------------------------------
	//setLISTSUB1(++sub1num, 2600, "Museum",  false, 1, "");                  //�ڹ��� > ����20121109
	inputDivision( ); //�и���--------------------------------------------------------------------
	setLISTSUB1(++sub1num, 387,  "Board",   false, 1, "BoardWnd");          //�Խ���
	//13.02.27 ���� �߰� �˴ϴ�.

	//�ؿܿ��� ��� ���� �ʴ� �޴� 2013.12.06��;
	if (Language != ELanguageType.LANG_Korean) bValue = 0;else bValue = 1;	
	if ( isClassic ) bValue = 0;
	setLISTSUB1(++sub1num, 3136,  "QABoard",   false, bValue, "");          //�Խ���/������ϱ�	
	//setLISTSUB1(++sub1num, 387,  "QABoard",   false, 1, "QABoardWnd");          //�Խ���/������ϱ�	

	//13.01.23 ���� ���� �˴ϴ�.
	// �߱� �ʿ��� msn �� ����.�׿� ���� ���� ó��
	//if (Language == ELanguageType.LANG_Chinese) GetINIBool("Localize", "UseMsn", bValue, "L2.ini"); //���� ����
	//else bValue = 1;
	//setLISTSUB1(++sub1num, 896,  "MSN",     false, bValue, "");               //�޽���

	setLISTSUB1(++sub1num, 2383, "Personal",false, 1, "PersonalConnectionsWnd");  //�θ�
	setLISTSUB1(++sub1num, 389,  "Party",   false, 1, "PartyMatchWnd");     //��Ƽ��Ī
	setLISTSUB1(++sub1num, 3068,  "ClanSearch",  false, 1, "");             //���� ����
	setLISTSUB1(++sub1num, 2074, "Post",    false, 1, "PostWnd");	        //������
	inputDivision( ); //�и���--------------------------------------------------------------------
	setLISTSUB1(++sub1num, 498,  "Shop",    true , 1, "");	                //���λ���

	GetINIBool("PrimeShop", "UseGoodsInventory", bValue, "L2.ini");         //���� ����
	setLISTSUB1(++sub1num, 2469, "Product", false, bValue, "");             //��ǰ�κ��丮
}

function setLISTSUB1(int sub1num, int stringNUm, string menuName,  bool useSubMenu, int bValue, string tooltip)
{
	if (bValue == 1)	//�ش� ������ ������
	{
		LISTSUB1[LISTSUB1.Length] = sub1num$"|"$GetSystemString(stringNUm)$"|"$menuName$"|"; // �޴� �Է� �ƴϸ� ����
	}
	if ( useSubMenu )   //���� �޴��� ������
	{
			LISTSUB2NUM[LISTSUB2NUM.Length] = sub1num;  //����޴� ��ȣ �Է�
	}	
	LISTSUB1COMMAND[sub1num] = tooltip; //������ Ŀ�ǵ� �Է�
}

function CreateSUB1Tooltip( )
{	
	local int i;	
	local array<string> LISTSUB1ToolTip;
	for ( i =0 ; i< LISTSUB1COMMAND.Length ; i++)
	{
		LISTSUB1ToolTip[i] = setSubShortcutString(LISTSUB1COMMAND[i]);
	}
	dispatchEventToFlash_String(15 , TransArrayToString(LISTSUB1ToolTip));	
}

function inputDivision( ) 
{
	local string divisionStr ;
	divisionStr = "999|�и���Divi|false|Tooltip";
	if ( LISTSUB1[LISTSUB1.Length - 1] != divisionStr ) //�ɼǿ� ���� �޴��� ��°�� ������� ��� ������� �ι� ���� �� ���� 
	{		
		LISTSUB1[LISTSUB1.Length] = divisionStr;	
	}	
}

function SetLISTSUB2DATA()
{	
	local int bValue ;
	local int sub2num ;
	local bool isClassic;

	local ELanguageType Language;	
	
	isClassic = getInstanceUIData().getIsClassicServer();
	Language = GetLanguage();

	sub2num =0;

	setLISTSUB2(LISTSUB2NUM[2],   sub2num, 2644, "|SellStore|false", 1);    //�ǸŻ���
	setLISTSUB2(LISTSUB2NUM[2], ++sub2num, 2645, "|BuyStore|false", 1);     //���Ż���
	setLISTSUB2(LISTSUB2NUM[2], ++sub2num, 2646, "|AllSell|false", 1);      //�ϰ��ǸŻ���
	setLISTSUB2(LISTSUB2NUM[2], ++sub2num, 1283, "|StoreSearch|false", 1);  //�����˻�
	/*-----------------------------------------------------------------------------------------------------------------------------*/		
	if ( isClassic ) bValue = 0;else bValue = 1;
	setLISTSUB2(LISTSUB2NUM[1], ++sub2num, 2796, "|InstanceZone|false", bValue); //�ν��Ͻ� ��
	
	//Ŭ���� ���������� PC�� ����Ʈ�� ������ ����.
	GetINIBool("Localize", "UsePCBangPoint", bValue, "L2.ini");             //���ǰ˻�
	if ( isClassic ) bValue = 0;
	setLISTSUB2(LISTSUB2NUM[1], ++sub2num, 1277, "|PC|false", bValue);      //PC�� �̺�Ʈ

	//GetINIBool("URL", "bUse24HZ", bValue, "L2.ini");                        //���� �˻�
	//setLISTSUB2(LISTSUB2NUM[1], ++sub2num, 2410, "|24Hz|false", bValue);    //24Hz
	setLISTSUB2(LISTSUB2NUM[1], ++sub2num, 2448, "|Rec|false",  1);         //������ ��ȭ
	setLISTSUB2(LISTSUB2NUM[1], ++sub2num, 2647, "|reRec|false",  1);	    //���÷��� ��ȭ
	/*-----------------------------------------------------------------------------------------------------------------------------*/
	if ( isClassic ) bValue = 0;else bValue = 1;
	setLISTSUB2(LISTSUB2NUM[0], ++sub2num, 145, "|Help|false",  bValue);	    //����
	
	//�ѱ� �ܿ����� 1:1 ���� ���ǰ� ���� �׿� �ٸ� ���� ó��
	if (Language != ELanguageType.LANG_Korean) bValue = 0;else bValue = 1;	
	setLISTSUB2(LISTSUB2NUM[0], ++sub2num, 470, "|Petition|false",  bValue);    //����
	//�ؿܿ��� ��� ���� �ʴ� �޴� 2013.12.0
	if (Language != ELanguageType.LANG_Korean) bValue = 0;else bValue = 1;	
	setLISTSUB2(LISTSUB2NUM[0], ++sub2num, 3169, "|IngameNoticeWnd|false",  bValue);    //���Ӱ���â
	setLISTSUB2(LISTSUB2NUM[0], ++sub2num, 2257, "|Home|false",  1);       //Ȩ������
	//�佺 �� �����ū
	if ( !GetINIBool("Localize", "UsePathToAwakening", bValue, "L2.ini")) bValue = 0;
	setLISTSUB2(LISTSUB2NUM[0], ++sub2num, 5178, "|PathToAwakening|false", bValue); 
}

function setLISTSUB2(int snub1num, int sub2num, int stringNUm, string etc,  int  bValue)					
{
	if (bValue == 1)
		 LISTSUB2[LISTSUB2.Length] = snub1num $ "||" $ sub2num $ "|" $ GetSystemString(stringNUm) $ etc;//Tool";
}



/**
 * ShowWindow â�� ���� ������ �ٽ� ���� �ʱ�.
 */
function SetShowWindow()
{	
	if( IsShowWindow() == false )
	{
		ShowWindow();
	}
}


function string setMainShortcutString( int sysNum, string commandName )
{
	local ShortcutCommandItem   commandItem;
	local string                strShort;
	local OptionWnd     Script;

	Script = OptionWnd( GetScript( "OptionWnd" ) );

	strShort = "<NORMAL_FONT13>" $ GetSystemString( sysNum ) $ "<br>&lt;" $ GetSystemString(1523) $ ": ";

	//����Ʈ
	class'ShortcutAPI'.static.GetAssignedKeyFromCommand( groupName, "ShowWindow Name=" $ commandName, commandItem);

	//����Ű ����...
	if( commandItem.subkey1 != "" )
	{
		strShort = strShort $ Script.GetUserReadableKeyName( commandItem.subkey1 ) $ "+";
	}
	if( commandItem.subkey2 != "" )
	{
		strShort = strShort $ Script.GetUserReadableKeyName( commandItem.subkey2 ) $ "+";
	}
	if( commandItem.Key != "" )
	{
		if( commandName == "InventoryWnd" )
		{
			strShort = strShort $ Script.GetUserReadableKeyName( commandItem.Key ) $ ",";			
		}
		else
			strShort = strShort $ Script.GetUserReadableKeyName( commandItem.Key ) $ "&gt;</NORMAL_FONT13>";
	}

	if( commandItem.subkey1 == "" && commandItem.subkey2 == "" && commandItem.Key == "" )
	{
		strShort = strShort $ "����&gt;</NORMAL_FONT13>";
	}

	if( commandName == "InventoryWnd" )
	{
		class'ShortcutAPI'.static.GetAssignedKeyFromCommand( "GamingStateShortcut", "TabShowInventoryWindow", commandItem);

		if( commandItem.subkey1 != "" )
		{
			strShort =  strShort $ Script.GetUserReadableKeyName( commandItem.subkey1 ) $ "+";
		}
		if( commandItem.subkey2 != "" )
		{
			strShort = strShort $ Script.GetUserReadableKeyName( commandItem.subkey2 ) $ "+";
		}
		if( commandItem.Key != "" )
		{
			strShort = strShort $ Script.GetUserReadableKeyName( commandItem.Key ) $ "&gt;</NORMAL_FONT13>";
		}	
	}

	return strShort;
}

function string setSubShortcutString( string commandName )
{
	local ShortcutCommandItem   commandItem;
	local string                strShort;
	local OptionWnd     Script;

	if( commandName == "" )
	{
		return "";
	}

	Script = OptionWnd( GetScript( "OptionWnd" ) );

	strShort = "<NORMAL_FONT13>&lt;" $ GetSystemString(1523) $ ": ";

	//����Ʈ
	class'ShortcutAPI'.static.GetAssignedKeyFromCommand( groupName, "ShowWindow Name=" $ commandName, commandItem);

	//����Ű ����...
	if( commandItem.subkey1 != "" )
	{
		strShort = strShort $ Script.GetUserReadableKeyName( commandItem.subkey1 ) $ "+";
	}
	if( commandItem.subkey2 != "" )
	{
		strShort = strShort $ Script.GetUserReadableKeyName( commandItem.subkey2 ) $ "+";
	}
	if( commandItem.Key != "" )
	{
		strShort = strShort $ Script.GetUserReadableKeyName( commandItem.Key ) $ "&gt;</NORMAL_FONT13>";
	}

	if( commandItem.subkey1 == "" && commandItem.subkey2 == "" && commandItem.Key == "" )
	{
		class'ShortcutAPI'.static.GetAssignedKeyFromCommand( "GamingStateShortcut", "ShowWindow Name=" $ commandName, commandItem);
		if( commandItem.subkey1 != "" )
		{
		strShort = strShort $ Script.GetUserReadableKeyName( commandItem.subkey1 ) $ "+";
		}
		if( commandItem.subkey2 != "" )
		{
			strShort = strShort $ Script.GetUserReadableKeyName( commandItem.subkey2 ) $ "+";
		}
		if( commandItem.Key != "" )
		{
			strShort = strShort $ Script.GetUserReadableKeyName( commandItem.Key ) $ "&gt;</NORMAL_FONT13>";
		}
	}

	if( commandItem.subkey1 == "" && commandItem.subkey2 == "" && commandItem.Key == "" )
	{
		strShort = "";
	}

	//strShort = substitute( strShort, "<", "&lt;", true );
	//strShort = substitute( strShort, ">", "&gt;", true );

	return strShort;
}

/*
function int Split( string strInput, string delim, out array<string> arrToken )
{
	local int arrSize;
	
	while ( InStr(strInput, delim)>0 )
	{
		arrToken.Insert(arrToken.Length, 1);
		arrToken[arrToken.Length-1] = Left(strInput, InStr(strInput, delim));
		strInput = Mid(strInput, InStr(strInput, delim)+1);
		arrSize = arrSize + 1;
	}
	arrToken.Insert(arrToken.Length, 1);
	arrToken[arrToken.Length-1] = strInput;
	arrSize = arrSize + 1;
	
	return arrSize;
}
*/



/**
 * ����Ʈ â ����
 */
function ToggleOpenQuestWnd()
{
	local WindowHandle win;	
	win = GetWindowHandle( "QuestTreeWnd" );
	
	if( win.IsShowWindow() )
	{
		win.HideWindow();
		PlaySound("InterfaceSound.map_close_01");
	}
	else
	{
		win.ShowWindow();
		win.SetFocus();
		PlaySound("InterfaceSound.map_open_01");
		
	}	
}

/**
 * ���� â ����
 */
function ToggleOpenClanWnd()
{
	local WindowHandle win;

	win = getWindowHandleCheckClassic( "ClanWnd" );
	
	if( win.IsShowWindow() )
	{
		win.HideWindow();
		PlaySound("InterfaceSound.charstat_close_01");
	}
	else
	{
		win.ShowWindow();
		win.SetFocus();
		PlaySound("InterfaceSound.charstat_open_01");			
	}
}

/**
 * �θư��� �ý��� ���� 
 */
function ToggleOpenPersonalConnectionsWnd ()
{
	local WindowHandle win;
	win = GetWindowHandle( "PersonalConnectionsWnd" );
	
	if( win.IsShowWindow() )
	{
		win.HideWindow();
		PlaySound("ItemSound.window_close");
	}
	else
	{
		win.ShowWindow();
		win.SetFocus();
		PlaySound("ItemSound.window_open");			
	}
}

/** 
 * ��ų â ����
 */
function ToggleOpenSkillWnd()
{
	local WindowHandle win;
	win = GetWindowHandle( "MagicSkillWnd" );
	
	if( win.IsShowWindow() )
	{
		win.HideWindow();
		PlayConsoleSound(IFST_MAPWND_OPEN);
		
	}
	else
	{
		win.ShowWindow();
		win.SetFocus();
		PlayConsoleSound(IFST_MAPWND_CLOSE);
	}
}


function WindowHandle getWindowHandleCheckClassic( String winName)
{
	local WindowHandle win;
	//local bool _isClassicServer;
	//local UIData script;
	//script = getInstanceUIData();
	//_isClassicServer = true;	
	//Debug ( "isclassic?" @script.getIsClassicServer() );
	if ( getInstanceUIData().getIsClassicServer() )
	{
		//Debug ( "classic");
		win = GetWindowHandle( winName $ "Classic" );		
	}
	else 
	{
		//Debug ( "normal");
		win = GetWindowHandle( winName );
	}
	return win;
}

/**
 * �ɸ��� ���� â ����
 */
function ToggleOpenCharInfoWnd()
{
	local WindowHandle win;

	win = getWindowHandleCheckClassic( "DetailStatusWnd" );

	
	if( win.IsShowWindow() )
	{
		win.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);
	}
	else
	{
		win.ShowWindow();
		win.SetFocus();
		PlayConsoleSound(IFST_WINDOW_OPEN);
	}
}

/**
 * �κ��丮 â ����
 */
function ToggleOpenInventoryWnd()
{
	local WindowHandle win;
	win = GetWindowHandle( "InventoryWnd" );
	
	if( win.IsShowWindow() )
	{
		win.HideWindow();
		PlaySound("InterfaceSound.inventory_close_01");
	}
	else
	{
		ExecuteEvent(EV_InventoryToggleWindow);
		PlaySound("InterfaceSound.inventory_open_01");	
	}
}

/**
 * �׼� â ����
 */
function ToggleOpenActionWnd()
{
	local WindowHandle win;
	win = GetWindowHandle( "ActionWnd" );
	
	if( win.IsShowWindow() )
	{
		win.HideWindow();
		PlayConsoleSound(IFST_WINDOW_OPEN);
	}
	else
	{
		win.ShowWindow();
		win.SetFocus();
		ExecuteEvent(EV_ActionListStart);
		ExecuteEvent(EV_ActionList);
		ExecuteEvent(EV_LanguageChanged);
		ExecuteEvent(EV_ActionListNew);
		PlayConsoleSound(IFST_WINDOW_CLOSE);				
	}
}

/**
 * �ɼ� â ����
 */
function HandleShowOptionWnd()
{
	local OptionWnd win;
	win = OptionWnd( GetScript("OptionWnd") );
	win.ToggleOpenMeWnd(false); //�ɼ�â�� ����
	//ExecuteEvent( EV_OptionWndShow ) ;//����Ű â ���� 
}

/**
 * ����Ű â ����
 */
function HandleShowShortcutAssignWnd()
{

	local OptionWnd win;	
	win = OptionWnd( GetScript("OptionWnd") );
	win.ToggleOpenMeWnd(true);  //���� â���� ���� 

}

/**
 * �Խ��� ����
 */
function HandleShowBoardWnd()
{
	local string strParam;
	ParamAdd(strParam, "Init", "1");
	ExecuteEvent(EV_ShowBBS, strParam);
}

//�Խ���/���� ���ϱ�
function handleShowQABoardWnd()
{
	local string strParam;
	ParamAdd(strParam, "Index", "8");
	ExecuteEvent(EV_ShowBBS, strParam);
}

/**
 * ��Ƽ��Ī ����
 */
function HandlePartyMatchWnd()
{	
	ExecuteEvent( EV_ShowWindow, "Name=PartyMatchWnd" );	
}

/**
 * ������ ����
 */
function HandleShowPostBoxWnd()
{
	local WindowHandle win;
	win = GetWindowHandle( "PostBoxWnd" );
	
	if( win.IsShowWindow() )
	{
		win.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		RequestRequestReceivedPostList();
		if (IsPeaceZone == 0)
			AddSystemMessage(3066);	
	}
}

/**
 * ���� ����
 */
function HandleShowHelpHtmlWnd()
{
	local AgeWnd script;	// ���ǥ�� ��ũ��Ʈ ��������
	
	local string strParam;
	ParamAdd(strParam, "FilePath", "..\\L2text\\help.htm");
	ExecuteEvent(EV_ShowHelp, strParam);
	
	script = AgeWnd( GetScript("AgeWnd") );
	
	if(script.bBlock == false)	script.startAge();	//���ǥ�ø� ���ش�. 
}
/**
 * �ν��Ͻ� �� â ����
 */
function HandleShowInstanceZone()
{
	//Debug(" HandleShowInstanceZone" );
	RequestInzoneWaitingTime();
}

/**
 * ���� â ����
 */
function HandleShowPetitionBegin()
{
	local WindowHandle win;	
	local WindowHandle win1;	
	local WindowHandle win2;	
	local PetitionMethod useNewPetition;

	win = GetWindowHandle( "NewUserPetitionWnd" );
	win1 = GetWindowHandle( "UserPetitionWnd" );
	win2 = GetWindowHandle( "WebPetitionWnd" );

	useNewPetition = GetPetitionMethod();

	if( useNewPetition == PetitionMethod_New )
	{
		if(win.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			RequestShowPetitionAsMethod();
		}
	}
	else if( useNewPetition == PetitionMethod_Default )
	{
		if (win1.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win1.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			win1.ShowWindow();
			win1.SetFocus();
		}
	}
	else if( useNewPetition == PetitionMethod_Web )
	{
		if (win2.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win2.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			RequestShowPetitionAsMethod();
		}
	}
}

/**
 * PC�� �̺�Ʈ ����
 */
function HandleShowPCWnd()
{
	local PCCafeEventWnd script;	
	script = PCCafeEventWnd( GetScript("PCCafeEventWnd") );
	
	script.HandleToggleShowPCCafeEventWnd();
	PlayConsoleSound(IFST_WINDOW_OPEN);
}

/**
 * 24Hz ����
 
function W24HzShowWnd()
{
	local WindowHandle win;	
	win = GetWindowHandle( "W24HzWnd" );

	//�������� �ݱ�
	if( win.isShowWindow())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		win.HideWindow();
	}
	//�ƴϸ� ����
	else 
	{	
		PlayConsoleSound(IFST_WINDOW_OPEN);
		win.ShowWindow();
		win.SetFocus();
	}
}
*/

/**
 * ������ ��ȭ â ����
 */
function HandleShowMovieCaptureWnd()
{
	local bool tmpBool;
	local WindowHandle win;	
	local WindowHandle win1;	

	win = GetWindowHandle( "MovieCaptureWnd_Expand" );
	win1 = GetWindowHandle( "MovieCaptureWnd" );

	tmpBool =IsNowMovieCapturing();

	//���� �ǰ� �ִٸ�
	if(tmpBool)
	{
		win.HideWindow();
		//Ȯ�� â�� ���� ���ٸ�
		if ( win.IsShowWindow() )
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win.HideWindow();
		}
		else 
		{			
			PlayConsoleSound(IFST_WINDOW_OPEN);
			win.ShowWindow();
			win.SetFocus();
		}
	} 
	//�ƴ϶�� �Ϲ� â ���� �ݱ�
	else 
	{
		if (win1.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win1.HideWindow();
		} 
		else
		{	
			PlayConsoleSound(IFST_WINDOW_OPEN);
			win1.ShowWindow();
			win1.SetFocus();

		}
	}	
}

/**
 * Ȩ������ ����
 */
function linkHomePage()
{
	class'UICommonAPI'.static.DialogSetID( DIALOGID_Gohome );
	class'UICommonAPI'.static.DialogShow( DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage( 3208 ), string(Self));
}

//Ȩ������ ��ũ(10.1.18 ������ �߰�)
function HandleDialogOK()
{	
	if( ! class'UICommonAPI'.static.DialogIsOwnedBy( string(Self) ) )
		return;

	switch( class'UICommonAPI'.static.DialogGetID() )
	{
	case DIALOGID_Gohome:
		OpenL2Home();
		break;
	}
}

//��ǰ �κ��丮 ����
function HandleShowProductInventory()
{
	local WindowHandle win;	
	local WindowHandle win1;	

	//local ShortcutAssignWnd sc;
	//sc = ShortcutAssignWnd( GetScript("ShortcutAssignWnd") );
	//debug( ">>>>>" $ sc.GetShortcutItemNameWithID(1) );

	win = GetWindowHandle( "ProductInventoryWnd" );
	win1 = GetWindowHandle( "ShopWnd" );

	//�������� �ݱ�
	if( win.isShowWindow())
	{
		PlayConsoleSound(IFST_INVENWND_CLOSE);
		win.HideWindow();
	}
	//�ƴϸ� ����
	else 
	{	
		util.ItemRelationWindowHide( "ProductInventoryWnd" );

		if( !win1.IsShowWindow() )
		{
			PlayConsoleSound(IFST_INVENWND_OPEN);
			win.ShowWindow();
			win.SetFocus();
		}
	}
}

//Flash�� ���콺 ������ �̺�Ʈ �߻�.
event OnMouseOver( WindowHandle w )
{	
	
}
//Flash�� ���콺 �ƿ��� �̺�Ʈ �߻�.
event OnMouseOut( WindowHandle w )
{
	//������ ���콺 ��ġ�� 0,0����.
	ForceToMoveMousePos( 0, 0 );
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 **/
function OnReceivedCloseUI()
{	
	local array<GFxValue> args;
	local GFxValue invokeResult;
	
	AllocGFxValues(args, 1);		
	
	Invoke("_root.onReceivedCloseUI", args, invokeResult);

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);	
}


function dispatchEventToFlash_String(int Event_ID, string argString){
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	args[0].SetInt(Event_ID);
	CreateObject(args[1]);

//	Debug("argString"@argString);
	args[1].SetMemberString("list", argString );

	Invoke("_root.onEvent", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
}
*/


//function changeEnterChat( string str )
//{
//	//groupName = str;
//	//updateTooltip();
//}
//function updateTooltip()
//{		
//}

defaultproperties
{
}
