/*------------------------------------------------------------------------------------------------------------------------

 ����     : ���� �ɼ� �ο� ���� ���� UI
<���� ���̺�> 
- ����- 
A : 46824
S �̻�: 
17416	[�︮���� ������]
17417	[�︮���� Ŀ��]
17418	[�︮���� ������]
17419	[�︮���� ���]
17420	[�︮���� ������]
17421	[�︮���� �����]
17422	[�︮���� ���ο�]
17423	[�︮���� ��Ʈ��]
17424	[�︮���� ������]
17425	[�︮���� ĳ����]
17426	[�︮���� ��Ʈ������]
17427	[�︮���� ���ҵ�]
17428	[�︮���� �����]
17429	[�︮���� ������Ʈ]



- �� -
A : 46922
S �̻� : 
19570	[���̵���� ���]
19571	[���̵���� �䰩]
19572	[���̵���� ����]
19573	[���̵���� ��Ʋ��]
19574	[���̵���� ����]
19575	[���̵���� �ǵ�]
19576	[���̵���� ���� ���]
19577	[���̵���� ���� �Ƹ�]
19578	[���̵���� ���� ���뽺]
19579	[���̵���� ���� �۷κ�]
19580	[���̵���� ���� ����]
19581	[���̵���� ��Ŭ��]
19582	[���̵���� Ʃ��]
19583	[���̵���� ȣ��]
19584	[���̵���� �۷κ�]
19585	[���̵���� ����]


- �Ǽ����� -
A : 46984
S : 47004

- ��� �Ǽ����� -
�� : 80418

<���� Ŭ����>
- ����- 
A : 8688
S : 6364

- �� -
A : 2382
S : 6373

- �Ǽ����� -
A : 858
S : 862

- ��� �Ǽ����� -
�� : 5808

Ensoul �ɼ� 490 ~ 

���� �� Ư¡ 
- ���̺� ���� S�� �̻���
//summon_attribute �� ��ȯ

- Ŭ���� S�� �̸��� 
//summon_option ���� ��ȯ
------------------------------------------------------------------------------------------------------------------------*/



class GMFindTreeWndItem extends UICommonAPI;

var WindowHandle  Me;
//var array<String> m_ComboList;
var String m_WindowName;

var TextBoxHandle textBoxEnchant;
var EditBoxHandle editBoxEnchant;

var TextBoxHandle textBoxAttribute0;
var EditBoxHandle editBoxAttribute0;
var ComboBoxHandle comboAttribute0;

var TextBoxHandle textBoxAttribute1;
var EditBoxHandle editBoxAttribute1;
var ComboBoxHandle comboAttribute1;

var TextBoxHandle textBoxAttribute2;
var EditBoxHandle editBoxAttribute2;
var ComboBoxHandle comboAttribute2;

var TextBoxHandle textBoxOptioinNormal;
var EditBoxHandle editBoxOptioinNormal;

var TextBoxHandle textBoxOptioinRandom;
var EditBoxHandle editBoxOptioinRandom;

var TextBoxHandle textBoxEnsoul0;
var EditBoxHandle editBoxEnsoul0;

var TextBoxHandle textBoxEnsoul1;
var EditBoxHandle editBoxEnsoul1;

var TextBoxHandle textBoxEnsoul2;
var EditBoxHandle editBoxEnsoul2;
var CheckBoxHandle checkBoxBless;

var GMFindTreeWnd GMFindTreeWndScript;

var ButtonHandle summonButton;

var ListCtrlHandle summonList;

var int itemID;

var L2Util util;

enum ATTRIBUTECOMBOTYPE 
{
	ATTRIBUTE_NONE  ,
	ATTRIBUTE_FIRE  , 
	ATTRIBUTE_WATER , 
	ATTRIBUTE_WIND  , 
	ATTRIBUTE_EARTH , 
	ATTRIBUTE_HOLY  , 
	ATTRIBUTE_UNHOLY 
};

/*******************************************************************************************************
 * On
 * *****************************************************************************************************/
function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle( m_WindowName );		

	textBoxEnchant = GetTextBoxHandle(m_WindowName$".textBoxEnchant");
	editBoxEnchant = GetEditBoxHandle(m_WindowName$".editBoxEnchant");

	textBoxAttribute0 = GetTextBoxHandle(m_WindowName$".textBoxAttribute0");
	editBoxAttribute0 = GetEditBoxHandle(m_WindowName$".editBoxAttribute0");
	comboAttribute0 = GetComboBoxHandle(m_WindowName$".comboAttribute0");
	AddComboxStrings (comboAttribute0);

	textBoxAttribute1 = GetTextBoxHandle(m_WindowName$".textBoxAttribute1");
	editBoxAttribute1 = GetEditBoxHandle(m_WindowName$".editBoxAttribute1");
	comboAttribute1 = GetComboBoxHandle(m_WindowName$".comboAttribute1");
	AddComboxStrings (comboAttribute1);

	textBoxAttribute2 = GetTextBoxHandle(m_WindowName$".textBoxAttribute2");
	editBoxAttribute2 = GetEditBoxHandle(m_WindowName$".editBoxAttribute2");
	comboAttribute2 = GetComboBoxHandle(m_WindowName$".comboAttribute2");
	AddComboxStrings (comboAttribute2);	

	textBoxOptioinNormal = GetTextBoxHandle(m_WindowName$".textBoxOptioinNormal");
	editBoxOptioinNormal = GetEditBoxHandle(m_WindowName$".editBoxOptioinNormal");
	textBoxOptioinRandom = GetTextBoxHandle(m_WindowName$".textBoxOptioinRandom");
	editBoxOptioinRandom = GetEditBoxHandle(m_WindowName$".editBoxOptioinRandom");

	textBoxEnsoul0 = GetTextBoxHandle(m_WindowName$".textBoxEnsoul0");
	editBoxEnsoul0 = GetEditBoxHandle(m_WindowName$".editBoxEnsoul0");
	textBoxEnsoul1 = GetTextBoxHandle(m_WindowName$".textBoxEnsoul1");
	editBoxEnsoul1 = GetEditBoxHandle(m_WindowName$".editBoxEnsoul1");
	textBoxEnsoul2 = GetTextBoxHandle(m_WindowName$".textBoxEnsoul2");
	editBoxEnsoul2 = GetEditBoxHandle(m_WindowName$".editBoxEnsoul2");

	summonButton = GetButtonHandle ( m_WindowName$".btnSummon" ) ; 

	summonList = GetListCtrlHandle ( m_WindowName$".ListFindWnd" ) ;
	checkBoxBless = GetCheckBoxHandle(m_WindowName$".CheckBoxBless");

	GMFindTreeWndScript = GMFindTreeWnd ( GetScript( "GMFindTreeWnd" )) ;

	util = L2Util(GetScript("L2Util"));	

	// ���ؿ��� ���� api , ������ Ŭ�� �� ������ �ص� ���̵���
	summonList.SetSelectedSelTooltip(false);	
	summonList.SetAppearTooltipAtMouseX(true);

	LoadLists();
}

function OnShow()
{
	//Debug( "OnShow") ;
	SetDisableAllHandles();
}

function OnClickButton( string strID )
{
	//local string summonCnt;

	switch( strID )
	{
	case "btnSummon":		
		HandleSummon (); 
		//summonCnt=m_hEdSummonCnt.GetString();
		//Summon(int(summonCnt));
		break;
	case "BtnEditUp" :
		LineUP();
		break;
	case "BtnEditDown" :
		LineDown();
		break;
	case "BtnEditAdd" :
		HandleAdd (); 
		break;
	case "BtnEditdel": 
		HandleDelete () ;
		break;	
	case "BtnEditAlldel" : 
		HandleDeleteAll();
		break;
	case "btnCopy" :
		HandleCopyBuildcommand() ;
		break;
	case "btnDetail":
		if ( GetWindowHandle("UIItemToolWnd").IsShowWindow() )
			GetWindowHandle("UIItemToolWnd").HideWindow();
		else
		{
			GetWindowHandle("UIItemToolWnd").ShowWindow();
			GetWindowHandle("UIItemToolWnd").SetFocus();
		}
		break;
	}
}

// �� �Ӽ��� �ڵ����� ���� �ʰ� �� �ش�.
function OnComboBoxItemSelected(string StrID, int IndexID)
{	
	//EditBoxString = m_hEditBox.GetString();
	//Debug( "OnComboBoxItemSelected" @ EListType ( IndexID ) );
	switch(strID)
	{
		case "comboAttribute0" :
		case "comboAttribute1" :
		case "comboAttribute2" :
			CheckAtrributeTypeChanged ( StrID, IndexID ) ;
	//		ShowList( EditBoxString , EListType( IndexID ));			
		break;
	}
}

function OnDBClickListCtrlRecord( string ListCtrlID )
{
	local LVDataRecord record;
	local int selectedIdx ;	
	local array<String> params;

	selectedIdx = summonList.GetSelectedIndex () ;
	summonList.getRec( selectedIdx, record ) ;		

	GMFindTreeWndScript.ShowList ( String (record.nReserved1) , GMFindTreeWndScript.ELISTTYPE.LISTTYPE_ITEM ) ;	

	SetItemID ( int ( record.nReserved1 ) );

	Split( Record.LVDataList[1].szData, "/", params );
	
	/* �Ӽ� �� ***************************************************************************************************/
	comboAttribute0.SetSelectedNum ( int ( params[0] ) + 1 );
	editBoxAttribute0.SetString ( params[1] );
	comboAttribute1.SetSelectedNum ( int ( params[2] ) + 1 );
	editBoxAttribute1.SetString ( params[3] );
	comboAttribute2.SetSelectedNum ( int ( params[4] ) + 1 );
	editBoxAttribute2.SetString ( params[5] );

	/* ��þƮ ***************************************************************************************************/
	editBoxEnchant.SetString ( params[6] );

	/* ���� ***************************************************************************************************/
	editBoxOptioinNormal.SetString ( params[7] );
	editBoxOptioinRandom.SetString ( params[8] );
	
	/* ��ȥ ***************************************************************************************************/
	editBoxEnsoul0.SetString ( params[9] );
	editBoxEnsoul1.SetString ( params[10] );
	editBoxEnsoul2.SetString ( params[11] );

	// Debug ( "OnDBClickListCtrlRecord" @ params[0] @ params.Length)  ;
}

function OnDrawerHideFinished () 
{
	SaveLists();
}
/*******************************************************************************************************
 * ����Ʈ ���� 
 * *****************************************************************************************************/
function LineUP ()
{
	local int selectedIdx  ;
	local LVDataRecord recordSelected, recordUp;

	selectedIdx = summonList.GetSelectedIndex ();
	if ( selectedIdx < 1 ) return;

	
	summonList.GetRec( selectedIdx, recordSelected ) ; 
	summonList.GetRec( selectedIdx - 1 , recordUp ) ; 

	summonList.ModifyRecord(selectedIdx, recordUp);
	summonList.ModifyRecord(selectedIdx - 1 , recordSelected);

	summonList.SetSelectedIndex ( selectedIdx - 1 , true ) ;
}

function LineDown () 
{
	local int selectedIdx, count ;
	local LVDataRecord recordSelected, recordDown;

	selectedIdx = summonList.GetSelectedIndex ();
	count = summonList.GetRecordCount ();
	if ( selectedIdx == -1 && selectedIdx == ( count - 1 )) return;

	summonList.GetRec( selectedIdx, recordSelected ) ; 
	summonList.GetRec( selectedIdx + 1, recordDown ) ; 

	summonList.ModifyRecord(selectedIdx, recordDown);
	summonList.ModifyRecord(selectedIdx + 1 , recordSelected);

	summonList.SetSelectedIndex ( selectedIdx + 1 , true ) ;
}

function HandleDelete() 
{
	local int selectedIdx ;
	selectedIdx = summonList.GetSelectedIndex ();
	if ( selectedIdx == -1 ) getInstanceL2Util().showGfxScreenMessage( "���� �� �������� �����ϴ�.");
	else 
	{
		RemoveINI( "GMSummon", String( summonList.GetRecordCount() - 1), "UIDEV.ini" );
		summonList.DeleteRecord ( selectedIdx );
		// ������ ����Ʈ�� ���� �ϴ� ��� 
		if ( summonList.GetRecordCount() == selectedIdx ) 
			summonList.SetSelectedIndex ( selectedIdx - 1, true ) ;
	}
}

function HandleDeleteAll () 
{
	local int i, count ; 
	count = summonList.GetRecordCount() ;

	for ( i= 0 ; i < count ; i ++ ) 
		RemoveINI( "GMSummon", String( i ), "UIDEV.ini" );

	summonList.DeleteAllItem();
}


function HandleAdd () 
{
	local int selectedIndex; 
	selectedIndex = GetIsSameRecord ();
	if ( selectedIndex > -1 ) 
	{
		summonList.SetSelectedIndex ( selectedIndex, true ) ;		
		getInstanceL2Util().showGfxScreenMessage( "��� �� �������� ���� �մϴ�.");
		return;
	}
	
	if ( itemID > 0 ) 
	{
		summonList.InsertRecord ( MakeRecord () );
		summonList.SetSelectedIndex ( summonList.GetRecordCount() -1, true) ;
	}
}


function HandleSummon () 
{
	ExecuteCommand ( MakeSummonCommand () ) ;
}

function SaveLists()
{
	local int count, i  ;
	local string param ; 
	local LVDataRecord record;

	Debug( "OnHide count 00 " $ count ) ;

	count = summonList.GetRecordCount() ;

	for ( i = 0 ; i < count  ; i ++ ) 
	{	
		summonList.GetRec( i, record ) ;
		param = "";
		ParamAdd ( param, "itemID", string(record.nReserved1)) ;
		ParamAdd ( param, "params", record.LVDataList[1].szData) ;
		
		Debug( "OnHide count" $ count  ) ;
		SetINIString("GMSummon", String(i), param, "UIDEV.ini");
	}
}

function LoadLists () 
{
	local string param, params ;
	local bool bUseParam;
	local int i, tmpItemID ;	

	i = 0 ;
	bUseParam = GetINIString("GMSummon", String(i), param, "UIDEV.ini");

	while ( bUseParam )
	{			
		parseInt( param, "itemID", tmpItemID );
		parseString ( param, "params" , params ) ;

		summonList.InsertRecord ( MakeRecordByParmas (tmpItemID, params ));
		i++ ;
		
		bUseParam = GetINIString("GMSummon", String(i), param, "UIDEV.ini");
	//  Debug ( "bUseParam" @ i  @ bUseParam  ) ;
	}
}

// ���� ���ɾ ���� ��.
function HandleCopyBuildcommand ()
{
	local string buildcommand ;
	buildcommand = MakeSummonCommand ();
	getInstanceL2Util().showGfxScreenMessage("����:" $ buildcommand) ;
	ClipboardCopy( buildcommand );
}

/*******************************************************************************************************
 * ���ڵ�  
 * *****************************************************************************************************/
function LVDataRecord MakeRecord () 
{
	return MakeRecordByParmas ( itemID , MakeParam() ) ; 
}

function LVDataRecord MakeRecordByParmas (int tmpItemID, string params ) 
{
	local LVDataRecord Record;
	local ItemInfo inItem;
	local string tooltipParam ; 
	
	Record.LVDataList.length = 2;		
	Record.nReserved1 = tmpItemID;
	
	inItem = MakeItemInfoWithParams ( tmpItemID, params ) ;

	// ������ �����ϱ� ���� param���� ���� ���
	ItemInfoToParam(inItem, tooltipParam);
	// ���� ����
	Record.szReserved = tooltipParam;	
		
	// ����Ʈ �ؽ�Ʈ
	Record.LVDataList[0].szData = inItem.Name;
	Record.LVDataList[0].textAlignment = TA_Left;

	Record.LVDataList[1].szData = params;
	Record.LVDataList[1].textAlignment = TA_CENTER;

	return  Record ;
}

// �Ķ����� ���� �� ������info �� ����.
function ItemInfo MakeItemInfoWithParams (int tmpItemID, string params ) 
{
	local itemInfo inItem;
	local array<string> paramArray ;

	inItem = GetItemInfoByClassID ( tmpItemID ) ; 

	Split ( params, "/", paramArray ) ;

	switch (inItem.itemType) 
	{
		// ���� ������ ��� ���� �Ӽ�
		// �Ӽ�, ��æ, ����, ��ȥ
		case EItemType.ITEM_WEAPON :			
			// �Ӽ�
			inItem.AttackAttributeType = int ( paramArray[0 ] ); 
			inItem.AttackAttributeValue =  int ( paramArray[1 ] ); 
			
			break;
		// �Ӽ� * 3, ��æ, ���� 
		case EItemType.ITEM_ARMOR : 
			// �Ӽ�
			GetItemWithAttribute ( int ( paramArray[0]), int (paramArray[1]), inItem )  ;
			GetItemWithAttribute ( int ( paramArray[2]), int (paramArray[3]), inItem )  ;
			GetItemWithAttribute ( int ( paramArray[4]), int (paramArray[5]), inItem )  ;
		break;
	}	

	// ��æƮ
	inItem.Enchanted = int ( paramArray[6] );
	// ����
	inItem.RefineryOp1 = int (paramArray[7]);
	inItem.RefineryOp2 = int (paramArray[8]);
	// ��ȥ
	inItem.EnsoulOption[0].OptionArray.Length = 3 ;// = 100;
	inItem.EnsoulOption[0].OptionArray[0] = int (paramArray[9]);
	inItem.EnsoulOption[0].OptionArray[1] = int (paramArray[10]);
	inItem.EnsoulOption[0].OptionArray[2] = int (paramArray[11]);	

	return inItem;
}


function String MakeParam () 
{
	local string    enchantNum, attributeType0, attributeType1, attributeType2, 
					attributeLvString0, attributeLvString1, attributeLvString2, 
					optionNormalID, optionRandomID, ensoul0, ensoul1, ensoul2,
					param;

	param = "";
	
	/* �Ӽ� �� ***************************************************************************************************/
	attributeType0 = String(GetIntAttribute ( comboAttribute0 )  ); 
	attributeLvString0 = GetStringNumWithEditBox ( editBoxAttribute0 ) ; 
	attributeType1 = String(GetIntAttribute ( comboAttribute1 ) ); 
	attributeLvString1 = GetStringNumWithEditBox ( editBoxAttribute1 ) ; 
	attributeType2 = String(GetIntAttribute ( comboAttribute2 ) ); 
	attributeLvString2 = GetStringNumWithEditBox ( editBoxAttribute2 ) ; 

	/* ��þƮ ***************************************************************************************************/
	enchantNum = GetStringNumWithEditBox ( editBoxEnchant  ) ;	

	/* ���� ***************************************************************************************************/
	optionNormalID = GetStringNumWithEditBox ( editBoxOptioinNormal );
	optionRandomID = GetStringNumWithEditBox ( editBoxOptioinRandom );
	
	/* ��ȥ ***************************************************************************************************/
	ensoul0 = GetStringNumWithEditBox ( editBoxEnsoul0 );
    ensoul1 = GetStringNumWithEditBox ( editBoxEnsoul1 );
    ensoul2 = GetStringNumWithEditBox ( editBoxEnsoul2 );

	param = attributeType0 $ "/" ;
	param = param $ attributeLvString0 $ "/" ;
	param = param $ attributeType1 $ "/" ;
	param = param $ attributeLvString1 $ "/" ;
	param = param $ attributeType2 $ "/" ;
	param = param $ attributeLvString2 $ "/" ;
	param = param $ enchantNum $ "/";
	param = param $ optionNormalID $ "/" ;
	param = param $ optionRandomID $ "/" ;
	param = param $ ensoul0 $ "/" ;
	param = param $ ensoul1 $ "/" ;
	param = param $ ensoul2;

	return param ;
}

/*******************************************************************************************************
 * ���� ���ɾ�  
 * *****************************************************************************************************/
function string MakeSummonCommand () 
{
	local string enchantNum, attributeType0, attributeType1, attributeType2, attributeLvString0, attributeLvString1, attributeLvString2, optionNormalID, optionRandomID, ensoul0, ensoul1, ensoul2;
	local int attribute0, attribute1, attribute2, attributeLv0, attributeLv1, attributeLv2, waterAttribtueLv, fireAttributeLv;
	local int isBless;

	/* ��þƮ ***************************************************************************************************/
	enchantNum = GetStringNumWithEditBox ( editBoxEnchant  ) ;	
	
	/* �Ӽ� �� ***************************************************************************************************/
	attribute0 = GetIntAttribute ( comboAttribute0 ); 
	attribute1 = GetIntAttribute ( comboAttribute1 ); 
	attribute2 = GetIntAttribute ( comboAttribute2 ); 

	// �� �Ӽ��� ��� ������ �� �Ӽ��� ������ ������ ���� �ٲ� �ش�.
	if ( attribute0 == 0 ) fireAttributeLv = int ( GetStringNumWithEditBox ( editBoxAttribute0 )) ; 
	else if ( attribute1 == 0 ) fireAttributeLv = int ( GetStringNumWithEditBox ( editBoxAttribute1 )) ; 
	else if ( attribute2 == 0 ) fireAttributeLv = int ( GetStringNumWithEditBox ( editBoxAttribute2 )) ; 

	if ( attribute0 == -1 ) { attribute0 = 0 ; attributeLv0 = fireAttributeLv ; }
	else attributeLv0 = int ( GetStringNumWithEditBox ( editBoxAttribute0 )) ; 
	if ( attribute1 == -1 ) { attribute1 = 0 ; attributeLv1 = fireAttributeLv ; }
	else attributeLv1 = int ( GetStringNumWithEditBox ( editBoxAttribute1 )) ;	
	if ( attribute2 == -1 ) { attribute2 = 0 ; attributeLv2 = fireAttributeLv ; }
	else attributeLv2 = int ( GetStringNumWithEditBox ( editBoxAttribute2 )) ;

	// �� �Ӽ��� �ִ� ��� ������ �޴´�.
	if ( attribute0 == 1 ) waterAttribtueLv = attributeLv0 ;
	else if ( attribute1 == 1 ) waterAttribtueLv = attributeLv1 ; 
	else if ( attribute2 == 1 ) waterAttribtueLv = attributeLv2 ; 
	

	// "��" �Ӽ��� �ִ� ���. "��" �Ӽ��� "��" �Ӽ����� �ٲ�
	// ������ �� �Ӽ����� ���� �ǹǷ�, ������ ���� ���� ��.
	if ( waterAttribtueLv > 0 ) 
	{
		if ( attribute0 == 0 ) { attribute0 = 1 ; attributeLv0 = waterAttribtueLv ; } 
		if ( attribute1 == 0 ) { attribute1 = 1 ; attributeLv1 = waterAttribtueLv ; } 
		if ( attribute2 == 0 ) { attribute2 = 1 ; attributeLv2 = waterAttribtueLv ; } 
	}

	attributeType0 = string (attribute0) ;
	attributeLvString0 = string ( attributeLv0 ) ;
	attributeType1 = string (attribute1);
	attributeLvString1 = string ( attributeLv1 ) ;
	attributeType2 = string (attribute2);
	attributeLvString2 = string ( attributeLv2 ) ;


	/* ���� ***************************************************************************************************/
	optionNormalID = GetStringNumWithEditBox ( editBoxOptioinNormal );
	optionRandomID = GetStringNumWithEditBox ( editBoxOptioinRandom );
	
	/* ��ȥ ***************************************************************************************************/
	ensoul0 = GetStringNumWithEditBox ( editBoxEnsoul0 );
    ensoul1 = GetStringNumWithEditBox ( editBoxEnsoul1 );
    ensoul2 = GetStringNumWithEditBox ( editBoxEnsoul2 );

	if ( checkBoxBless.IsChecked() )
		isBless = 1;
	else
		isBless = 0;

	if ( IsHairAccessary() )
	{
		if ( isBless == 1 )
		{
			getInstanceL2Util().showGfxScreenMessage("S���� ?������ ����?��+��|�������� ��??�� ����?��?��.");
			Debug("//summon_bless" @ string(ItemID) @ enchantNum);
			return "//summon_bless" @ string(ItemID) @ enchantNum;
		}
		// S��� ���ϴ� ���ø� ���� -> �̷��� ��� ���� �ʿ� ���� ��. 
		// �Ǽ�, ��� �Ǽ�, 
		else
		{
			Debug ( "//summon_option" @ itemID @ optionNormalID @ optionRandomID @  enchantNum ) ;

			return ("//summon_option" @ itemID @ optionNormalID @ optionRandomID @ enchantNum ) ;
		}
	}
	// �Ӽ��� ���� s ��� �̻�.
	// ��� ����, 
	else
	{
		Debug ( "HandleSummon : //summon_attribute" @ itemID @ attributeType0 @ attributeLvString0 @ attributeType1 @ attributeLvString1 @ attributeType2 @ attributeLvString2 
										@ enchantNum @ optionNormalID @ optionRandomID @ ensoul0 @ ensoul1 @ ensoul2 @ isBless) ;

		return ("//summon_attribute" @ itemID @ attributeType0 @ attributeLvString0 @ attributeType1 @ attributeLvString1 @ attributeType2 @ attributeLvString2 
										@ enchantNum @ optionNormalID @ optionRandomID @ ensoul0 @ ensoul1 @ ensoul2 @ isBless );
	}
}

/*******************************************************************************************************
 * ������ ���� 
 * *****************************************************************************************************/
function SetDisableAllHandles()
{
	// ��æƮ
	SetEnchant ( false ) ;
	// �Ӽ�
	SetAttribute( false, 0 ) ;
	SetAttribute( false, 1 ) ;
	SetAttribute( false, 2 ) ;
	// ����
	SetOptions ( false ) ;
	// ��ȥ
	SetEnsoul ( false ) ;
	
	SetBless(False);

	// ��ȯ ��ư
	summonButton.DisableWindow();
}


function SetItemID ( int ID )  
{
	local itemInfo infItem ;			
	
	itemID = ID ;
	infItem = GetItemInfoByClassID ( itemID ) ;	
	
	SetDisableAllHandles();
	
	switch (infItem.itemType) 
	{
		case EItemType.ITEM_WEAPON :			
			// ��æƮ
			SetEnchant ( true ) ;				
			// �Ӽ� s �� �̻� ��� �� �� �ֽ��ϴ�.
			if ( !getInstanceUIData().getIsClassicServer() && IsSGradeMoreThan())
				SetAttribute ( true , 0 ) ;
			// ����
			SetOptions ( true ) ;				
			// ��ȥ
			if ( IsSGradeMoreThan() ) SetEnsoul ( true ) ;

			if ( CanBless() )
				SetBless(True);

			summonButton.EnableWindow();
			Me.ShowWindow();
		break;
		// �Ϲ� ���� ��� ������ �� ��.
		case EItemType.ITEM_ARMOR :
			SetEnchant ( true ) ;						
			// ��� �Ǽ��縮 �� ��� ���ø� ���� ( ���� ���� �ȵǴ� ��� �Ǽ������� �ִ�. ��ũ��Ʈ���� ���� �� �� ... ) 
			if ( IsHairAccessary ())  
				SetOptions ( true );
			// Ŭ���� ������ ��� �Ӽ��� �ٸ�. s �� �̻� ����
			else if ( !getInstanceUIData().getIsClassicServer() && IsSGradeMoreThan() ) 
			{
				SetAttribute ( true , 0 ) ;
				SetAttribute ( true , 1 ) ;
				SetAttribute ( true , 2 ) ;
			}

			summonButton.EnableWindow(); 
			Me.ShowWindow();
		break;
		case EItemType.ITEM_ACCESSARY :
			SetEnchant ( true ) ;
			SetOptions ( true ) ;
			summonButton.EnableWindow();
			Me.ShowWindow();
		break;		
	}
}



/*******************************************************************************************************
 * Ȱ�� ��Ȱ��
 * 1. ��þƮ                           : SetEnchant
 * 2. �Ӽ� 1~3 ( ����� 1, ���� 3 ): SetAttribute  -> s�� �̻� ���� 
 * 3. ����                             : SetOptions    -> c�� �̻� ����
 * 4. ��ȥ                             : SetEnsoul     -> c�� �̻� ����
 * *****************************************************************************************************/
function SetEnchant( bool bEnable ) 
{
	if ( bEnable ) 
	{
		textBoxEnchant.SetTextColor ( util.Gold ) ;
		editBoxEnchant.EnableWindow();
	}
	else 
	{
		textBoxEnchant.SetTextColor ( util.Gray ) ;
		editBoxEnchant.DisableWindow();
	}
}

function SetAttribute ( bool bEnable, int Index  ) 
{
	local TextBoxHandle textBox ; 
	local EditBoxHandle editBox ;
	local ComboBoxHandle comboBox ; 

	textBox = GetTextBoxHandle ( m_WindowName$".textBoxAttribute" $ String( Index ) );
	editBox = GetEditBoxHandle(m_WindowName$".editBoxAttribute" $ String( Index ));
	comboBox = GetComboBoxHandle(m_WindowName$".comboAttribute" $ String( Index ));

	if ( bEnable ) 
	{
		textBox.SetTextColor ( util.Gold ) ;
		editBox.EnableWindow();
		comboBox.EnableWindow();
	}
	else 
	{
		textBox.SetTextColor ( util.Gray ) ;
		editBox.DisableWindow();
		comboBox.DisableWindow();
	}

}

function SetOptions ( bool bEnable ) 
{
	if ( bEnable ) 
	{
		textBoxOptioinNormal.SetTextColor ( util.Gold ) ;
		editBoxOptioinNormal.EnableWindow();
		textBoxOptioinRandom.SetTextColor ( util.Gold ) ;
		editBoxOptioinRandom.EnableWindow();

	}
	else 
	{
		textBoxOptioinNormal.SetTextColor ( util.Gray ) ;
		editBoxOptioinNormal.DisableWindow();
		textBoxOptioinRandom.SetTextColor ( util.Gray ) ;
		editBoxOptioinRandom.DisableWindow();
	}
}

function SetEnsoul ( bool bEnable ) 
{
	if ( bEnable ) 
	{
		textBoxEnsoul0.SetTextColor ( util.Gold );
		editBoxEnsoul0.EnableWindow();

		textBoxEnsoul1.SetTextColor ( util.Gold );
		editBoxEnsoul1.EnableWindow();

		textBoxEnsoul2.SetTextColor ( util.Gold );
		editBoxEnsoul2.EnableWindow();
	}
	else 
	{
		textBoxEnsoul0.SetTextColor ( util.Gray );
		editBoxEnsoul0.DisableWindow();

		textBoxEnsoul1.SetTextColor ( util.Gray );
		editBoxEnsoul1.DisableWindow();

		textBoxEnsoul2.SetTextColor ( util.Gray );
		editBoxEnsoul2.DisableWindow();
	}
}

function SetBless (bool bEnable)
{
	if ( bEnable )
		checkBoxBless.EnableWindow();
	else
		checkBoxBless.DisableWindow();
}

/*******************************************************************************************************
 * üũ
 * *****************************************************************************************************/
// ������ ���ڵ��, ���� �� ���ڵ带 �� ���� �� �ִ��� Ȯ�� �Ѵ�.
function int GetIsSameRecord () 
{
	local LVDataRecord record;
	local ItemInfo inItem;
	local string tooltipParam;
	local int i ;
	
	inItem = MakeItemInfoWithParams (itemID,  MakeParam() ) ;
	//inItem = GetItemInfoByClassID( itemID ) ;
	ItemInfoToParam (inItem, tooltipParam);

	// params = MakeParam();

	for ( i = 0 ; i < summonList.GetRecordCount() ; i ++ ) 
	{
		summonList.GetRec( i, record );
		// �Ķ��� ��ģ ������ ������ ��, �ִ� ��� return 
		if ( Record.szReserved == tooltipParam  ) 
		{
			return i ; 
		}
	}
	return -1 ; 
}

// �Ӽ� ���� ���� �ƴ��� üũ �ݴ� �Ӽ��̳�, ���� �Ӽ��� �ɷ� ��
function CheckAtrributeTypeChanged ( string StrID , int IndexID ) 
{
	local int tmpInt, i ;
	local ComboBoxHandle combobox;
	
	if ( IndexID == ATTRIBUTECOMBOTYPE.ATTRIBUTE_NONE ) return ;

	for ( i = 0 ; i < 3 ; i ++ ) 
	{
		if ( ( "comboAttribute" $ i ) == StrID ) continue ;

		combobox = GetComboBoxHandle ( m_WindowName $ ".comboAttribute" $ i  ) ;
		
		tmpInt = combobox.GetSelectedNum() ;
		if ( tmpInt == IndexID ) 
			combobox.SetSelectedNum( 0 ) ;
		else if ( IsAttributeOpposite ( IndexID, tmpInt )  ) 
		{
			combobox.SetSelectedNum( 0 );
			getInstanceL2Util().showGfxScreenMessage ( tmpInt $ "�� �� �Ӽ��� �ʱ�ȭ �߽��ϴ�." ) ;
		}
	}
}


// �� üũ ��<->��, ����<->�ٶ�, �ż�<->����
function bool IsAttributeOpposite ( int indexMine, int indexTarget ) 
{	
	switch ( indexMine ) 
	{
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_FIRE : 
			if ( indexTarget == ATTRIBUTECOMBOTYPE.ATTRIBUTE_WATER ) return true;
			break;
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_WATER : 
			if ( indexTarget == ATTRIBUTECOMBOTYPE.ATTRIBUTE_FIRE ) return true;
			break;
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_WIND : 
			if ( indexTarget == ATTRIBUTECOMBOTYPE.ATTRIBUTE_EARTH ) return true;
			break;
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_EARTH : 
			if ( indexTarget == ATTRIBUTECOMBOTYPE.ATTRIBUTE_WIND ) return true;
			break;
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_HOLY : 
			if ( indexTarget == ATTRIBUTECOMBOTYPE.ATTRIBUTE_UNHOLY ) return true;
			break;
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_UNHOLY : 
			if ( indexTarget == ATTRIBUTECOMBOTYPE.ATTRIBUTE_HOLY ) return true;
			break;
	}	
}
// ������ Ÿ���� ����, ���, ��� �Ǽ����� �� ����
function bool GetCanSummon () 
{
	local itemInfo infItem ;
	infItem = GetItemInfoByClassID ( itemID ) ;

	// ����, ��( ��� �Ǽ����� ���� ), �Ǽ�����
	switch (infItem.itemType) 
	{
		case EItemType.ITEM_WEAPON:
		case EItemType.ITEM_ARMOR:
		case EItemType.ITEM_ACCESSARY:
		break;
		default: return false; 
	}

	// ���̺� ����
	// 1. s �� �̻�
	// 2. ��� �Ǽ��縮 ( �Ϻ� ��ũ��Ʈ�� ���� �Ǿ� ���� ���� �Ǽ������� ���� ���� �ʴ´�. ) 
	if ( getInstanceUIData().getIsLiveServer() ) 
	{
		if (!IsSGradeMoreThan() ) return IsHairAccessary() ;
		return true;
	}
	
	// s�� �̻� summon_attribute�� ��� �� �� ������, Ŭ������ �Ӽ��� �޶�, �ǹ̰� ����.
	// summon_option, summon_ensoul �� �߿� �ϳ��� ���, �׷��� summon_option �� �ַ� ��� �ϴٰ� ��. 
	else if ( getInstanceUIData().getIsClassicServer() )
	{	
		return true; 
	}

	return false;
}

function bool IsSGradeMoreThan() 
{
	local itemInfo infItem ;
	infItem = GetItemInfoByClassID ( itemID ) ;

	switch ( infItem.CrystalType )
	{
		case CrystalType.CRT_S :
		case CrystalType.CRT_S80 :
		case CrystalType.CRT_S84 :
		case CrystalType.CRT_R :
		case CrystalType.CRT_R95 :
		case CrystalType.CRT_R99 :
		case CrystalType.CRT_R110 :
		return true;
	}
	return false ; 
}

function bool IsHairAccessary ( ) 
{
	local itemInfo infItem ;	
	infItem = GetItemInfoByClassID ( itemID ) ;
	if (infItem.itemType == EItemType.ITEM_ARMOR)  	
		if (infItem.SlotBitType == 65536 || infItem.SlotBitType == 524288 || infItem.SlotBitType == 262144) 
			return true;
	return false;
}

function bool CanBless ()
{
	local ItemInfo infItem;

	infItem = GetItemInfoByClassID(ItemID);
	return infItem.EnchantBlessGroupID > 0;
}

/*******************************************************************************************************
 * util 
 * *****************************************************************************************************/
// Ÿ�Կ� ���� �Ӽ� ���� ���� �� ������ info ����
function GetItemWithAttribute ( int index ,int value,  out ItemInfo inItem) 
{
	switch ( index ) 
	{
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_NONE :
			break;
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_FIRE :
			inItem.DefenseAttributeValueFire = value;
			break;
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_WATER :
			inItem.DefenseAttributeValueWater = value;
			break;
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_WIND:
			inItem.DefenseAttributeValueWind = value;
			break;
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_EARTH:
			inItem.DefenseAttributeValueEarth = value;
			break;
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_HOLY:
			inItem.DefenseAttributeValueHoly = value;
			break;
		case ATTRIBUTECOMBOTYPE.ATTRIBUTE_UNHOLY :
			inItem.DefenseAttributeValueUnholy = value;
			break;		
	}
}


// ����Ʈ �ڽ� �� ���� ���� ( Ȱ�� ��Ȱ���� ���� �ٸ�. 
function string GetStringNumWithEditBox ( EditBoxHandle editbox ) 
{
	if ( editbox.IsEnableWindow () )  return String ( int (editbox.GetString () )) ;
	return "0";
}

// �޺� �ڽ� �� ���� ����, ( Ȱ�� ��Ȱ�� �� �� ) 
function int GetIntAttribute ( ComboBoxHandle comboBox ) 
{
	local int selectedNum ; 
	selectedNum = comboBox.GetSelectedNum() ;
	if ( comboBox.IsEnableWindow() ) return selectedNum - 1 ;
	return -1;
}


/*******************************************************************************************************
 * etc
 * *****************************************************************************************************/
// ����, ��, ��, �ٶ�, ����, �ż�, ����
function AddComboxStrings ( ComboBoxHandle comboxHandle ) 
{
	comboxHandle.AddString(GetSystemString(27));
	comboxHandle.AddString(GetSystemString(1622));
	comboxHandle.AddString(GetSystemString(1623));
	comboxHandle.AddString(GetSystemString(1624));
	comboxHandle.AddString(GetSystemString(1625));
	comboxHandle.AddString(GetSystemString(1626));
	comboxHandle.AddString(GetSystemString(1627));
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( m_WindowName ).HideWindow();
}

defaultproperties
{
     m_WindowName="GMFindTreeWndItem"
}
