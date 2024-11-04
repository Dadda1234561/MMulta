class HelpWnd extends UICommonAPI;

var WindowHandle  Me;
var TreeHandle    MainTree;
var HtmlHandle    HtmlViewer;

var string ROOTNAME;
var string TREENAME;

var int bodyCount;
var int currentID;
var int bodyCountCurrent;
var string expenedNode;

var buttonHandle btnNext ;
var buttonHandle btnPrev ;
var TextBoxHandle txtNumber;

var bool indexLoaded;

const ERRORMESSAGEID = 99;

function OnRegisterEvent()
{
	RegisterEvent( EV_ShowHelp );
	RegisterEvent( EV_TutorialShowID );
	//RegisterEvent( EV_Restart );
}


function OnLoad()
{
	SetClosingOnESC();
	RegisterState(getCurrentWindowName(string(Self)), "GamingState");
	RegisterState(getCurrentWindowName(string(Self)), "LoginState");
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle( "HelpWnd" );
	MainTree = GetTreeHandle( "HelpWnd.MainTree" );
	HtmlViewer = GetHtmlHandle( "HelpWnd.HtmlViewer" );

	btnNext = GetButtonHandle( "HelpWnd.btnNext");
	btnPrev = GetButtonHandle( "HelpWnd.btnPrev");

	txtNumber = GetTextBoxHandle ( "HelpWnd.txtNumber");

	ROOTNAME = "root";
	TREENAME = "HelpWnd.MainTree";

	bodyCountCurrent = 1;
	bodyCount = 1;
	SetButtonState();
}

event onEvent ( int eventID, string param )
{
	if ( GetGameStateName() == "SERVERLISTSTATE"  ) return;
	//else if ( getInstanceUIData().getIsClassicServer() ) return;
	
	switch ( eventID )
	{	
		// �޴� �������� �� ��
		case EV_ShowHelp         : OpenHelp( param );    break;
		//case EV_Restart          : indexLoaded = false;     break;
		// ���� ���� �� ��
		case EV_TutorialShowID   : HandleTutorialShow( param ) ;   break;
		case EV_DeleteSceneClipView: ResumeState(); break;
	}
}

/** onShow */
event OnShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
}

event OnHide()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	//removeDataArray();
}


function ResumeState()
{
	Me.EnableWindow();
	Me.SetDraggable(True);
	Me.SetFocus();
}

function PauseState()
{
	Me.DisableWindow();
	Me.SetDraggable(False);
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x29
		case "btnNext":
			bodyCountCurrent++;
			SetButtonState();
			LoadHtml();
			// End:0x77
			break;
		// End:0x4B
		case "btnPrev":
			bodyCountCurrent--;
			SetButtonState();
			LoadHtml();
			break;
		default:
			ClickTreeNode(Name);
			SetButtonState();
			LoadHtml();
			MainTree.SetFocus();
			break;
	}
}

/***************************************************************************************************************
 * Ʈ�� Ŭ���Ҷ�
 * *************************************************************************************************************/
function ClickTreeNode( string Name )
{
	//Tree�� ����
	local Array<string> Result, bodyInfo;

	// DBG_SendMessageToChat( "clickTreeList > "@Name@" > "@expenedNode );	
	
	// ���� ��� Ŭ�� �� ó������ ���ƶ�.
	if ( expenedNode == Name  ) 
	{
		MainTree.SetExpandedNode( expenedNode, True );
		return;
	}

	// ������ ��尡 �ƴϸ� ���� ���� ���ƶ�.
	Split( Name, ".", Result );
	if ( Result.Length < 3 )  return;
	
	
	// ������ Ȯ���ߴ� ��带 ����
	if ( expenedNode != "" ) MainTree.SetExpandedNode( expenedNode, False );
	expenedNode = Name;	

	Split ( Result[2], ",", bodyInfo) ;

	// DBG_SendMessageToChat (  "clickTreeNode"@bodyInfo[0]@bodyInfo[1]  );
	
	// ID
	currentID = int (bodyInfo[0]);
	// count;
	bodyCount = int (bodyInfo[1]) ;
	bodyCountCurrent = 1;
}

/** ��ü ��� ����, �ݱ� */
//function allNodeExpanded( bool bOpen )
//{
	
//	local array<string>	arrSplit;	
//	local string strChildList;
//	local int i;

//	Debug ( "allNodeExpanded" );
//	strChildList = MainTree.GetChildNode( ROOTNAME );

//	Split(strChildList, "|", arrSplit);

//	// ���� 
//	for ( i = 0; i < arrSplit.length; i++)  MainTree.SetExpandedNode( arrSplit[i], bOpen);
//}


function SetButtonState()
{
	txtNumber.setText (( bodyCountCurrent )$"/"$bodyCount ); 
	if ( bodyCountCurrent == 1 ) btnPrev.DisableWindow ( ) ;
	else btnPrev.EnableWindow ( ) ;
	if ( bodyCountCurrent == bodyCount ) btnNext.DisableWindow ( ) ; 
	else btnNext.EnableWindow () ;
}

function HandleTutorialShow(string param)
{
	local int Id, Level;

	ParseInt(param, "ID", Id);
	ParseInt(param, "Level", Level);
	// End:0x4F
	if( Id > 0 )
	{
		//class'HelpWnd'.static.ShowHelp(Id, Level);
	}
}

function OpenHelp(string param)
{
	local string strPath;

	ParseString(param, "FilePath", strPath);
	if( int(param) <= 0 && strPath != "" )
	{
		// End:0x56
		if( Me.IsShowWindow() )
		{
			Me.HideWindow();
		}
		return;
	}
	//class'HelpWnd'.static.ShowHelp(int(param));
}

/******************************************************************************************************************************
 * ������ �޾� ���� �� 
 * ****************************************************************************************************************************/

/*sort*/
//delegate int OnSortCompareCategroy( TutorialIndex a, TutorialIndex b )
//{
//    if (a.Category > b.Category) // ���� ����. ���ǹ��� < �̸� ��������.
//        return -1;  // �ڸ��� �ٲ���Ҷ� -1�� ���� �ϰ� ��.
//    else
//        return 0;
//}

delegate int OnSortCompareOrder( TutorialIndex a, TutorialIndex b )
{
if (a.Order > b.Order) // ���� ����. ���ǹ��� < �̸� ��������.
return - 1;  // �ڸ��� �ٲ���Ҷ� -1�� ���� �ϰ� ��.
else
return 0;
}


/* ��� ����Ÿ �޾� �� ���� */
function HelpIndexLoad()
{
	local array<TutorialIndex> TutorialIndexs;

	// End:0x0B
	if( indexLoaded )
	{
		return;
	}
	GetTutorialIndices(TutorialIndexs);
	TutorialIndexs.Sort(OnSortCompareOrder);
	//TutorialIndexs.sort(OnSortCompareCategroy);
	SetHelpCategroyTreeNode(TutorialIndexs);
	indexLoaded = True;
}

function SetExpandedNodeByID(int Id, optional int bodyCount)
{
	local int i;
	local array<TutorialIndex> TutorialIndexs;
	local string NodeName, categoryNodeName;

	HelpIndexLoad();
	GetTutorialIndices(TutorialIndexs);

	for ( i = 0; i < TutorialIndexs.Length; i++ )
	{
		// End:0xF4
		if( TutorialIndexs[i].Id == Id )
		{
			categoryNodeName = ROOTNAME$"."$TutorialIndexs[i].Category;
			NodeName = categoryNodeName$"."$TutorialIndexs[i].Id$","$TutorialIndexs[i].LevelCount;
			MainTree.SetExpandedNode(categoryNodeName, True);
			MainTree.SetExpandedNode(NodeName, True);
			clickTreeNode(NodeName);
			bodyCountCurrent = Max(1, bodyCount);
			SetButtonState();
			LoadHtml();
			return;
		}
	}
}

//function setEcptionMsg () 
//{
//	local TutorialBody body;

//	GetTutorialBody ( ERRORMESSAGEID, 1 , body ); 	
//	//Debug ( "loadHtml" @  body.Description );
//	htmlViewer.LoadHtmlFromString(htmlSetHtmlStart(body.Description));
//	//MainTree.SetFocus();
//	HtmlViewer.SetFocus();
//}



/******************************************************************************************************************************
 * ��� ���� �ϴ� �� 
 * ****************************************************************************************************************************/
function setHelpCategroyTreeNode( array<TutorialIndex> TutorialIndexs ) 
{
	local int i, categoryIndex ;
	local string strRetName, subTreeName ;//, setTreeName;			
	
	//Debug ( "setHelpCategroyTreeNode2" @ MainTree );

	MainTree.Clear();

	//Root ��� ����.			
	getInstanceL2Util().TreeInsertRootNode( TREENAME, ROOTNAME, "", 0, 0 );

	categoryIndex = -1 ;

	for ( i = 0; i < TutorialIndexs.Length ; i++ )
	{
		// Ʈ�� ��忡 Text ������ �߰�
		// ��� �߰��� Tree ����, ��� ����, Text, x, y, ���� ETreeItemTextType
		if ( categoryIndex != TutorialIndexs[i].Category )  // �׽�Ʈ �� �� �ּ��� Ǯ��� ��. && TutorialIndexs[i].Category != 0 ) 
		{
			categoryIndex = TutorialIndexs[i].Category ;
			
			strRetName = insertExpandNode ( string(categoryIndex ), ROOTNAME) ;

			//// ��� �߰��� Tree, ��� ����, �ؽ��� �̸�, w, h,  x, y
			getInstanceL2Util().TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 190, 30, 0, -5 ) ;
			
			getInstanceL2Util().TreeInsertTextNodeItem( TREENAME, strRetName, GetSystemString ( categoryIndex ), -188, 9, getInstanceL2Util().ETreeItemTextType.COLOR_DEFAULT ) ;
		}
		
		subTreeName = insertNode ( makeNodeName ( TutorialIndexs[i] ), strRetName) ;

		if ( i % 2 == 0 ) 
			getInstanceL2Util().TreeInsertTextureNodeItem( TREENAME, subTreeName , "L2UI_CT1.EmptyBtn", 192, 20);
		else 
			getInstanceL2Util().TreeInsertTextureNodeItem( TREENAME, subTreeName , "L2UI_CH3.etc.textbackline", 192, 20, , , , , 14 );


		/* ��ǳ�� */
		getInstanceL2Util().TreeInsertTextureNodeItem( TREENAME, subTreeName, "L2UI_CT1.BTN_Icon_Normal", 16, 16, 9 - 192 , 2 );
		getInstanceL2Util().TreeInsertTextNodeItem( TREENAME, subTreeName, TutorialIndexs[i].Name, 3, 4, getInstanceL2Util().ETreeItemTextType.COLOR_GOLD );

		/* �� */
		//getInstanceL2Util().TreeInsertTextureNodeItem( TreeName, subTreeName, "L2UI_CT1.BTN_Icon_dot", 6, 6, 9 - 192 , 8 );
		//getInstanceL2Util().TreeInsertTextNodeItem( TreeName, subTreeName, TutorialIndexs[i].Name, 6, 4, getInstanceL2Util().ETreeItemTextType.COLOR_GOLD );
		
		/* �´� �ؽ�Ʈ */
		//getInstanceL2Util().TreeInsertTextNodeItem( TreeName, subTreeName, TutorialIndexs[i].Name, 4, 4, getInstanceL2Util().ETreeItemTextType.COLOR_GOLD );		 
	}
}


/**
 * PlayVideo
 */
function PlayVideo(string FileName, int MovieId)
{
	local string strPath, wndName;
	
	Me.SetDraggable(False);
	// play new video
	SceneClipView(GetScript("SceneClipView")).customPlayUsm(200, 35, 800, 600, 1, 4, FileName$".usm", MovieId, "HelpWnd");
}

// Ʃ�丮�� �ٵ� �ʿ��� ����Ÿ�� �̸��� ���� 
function string makeNodeName ( TutorialIndex tutorialIndex ) 
{
	return tutorialIndex.ID$","$tutorialIndex.LevelCount; 
}

// �� ��° ���� ��� ����
function string insertNode  ( string NodeName, string ParentName) 
{
	local XMLTreeNodeInfo		infNode;	
	local XMLTreeNodeInfo		infNodeClear;	
	
	infNode = infNodeClear ;

	infNode.bShowButton = 0;	
	infNode.strName = NodeName ;
	infNode.bFollowCursor = True ;
	infNode.nOffsetX = 2;	
	
	//Expand�Ǿ������� BackTexture����
	//��Ʈ��ġ�� �׸��� ������ ExpandedWidth�� ����. ������ -2��ŭ ����� �׸���.
	
	infNode.nTexExpandedOffSetX = 0 ;
	infNode.nTexExpandedOffSetY = 0 ;
	infNode.nTexExpandedHeight = 20 ;	
	infNode.nTexExpandedRightWidth = 0 ;
	infNode.nTexExpandedLeftUWidth = 1 ;
	infNode.nTexExpandedLeftUHeight = 15 ;

	infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";

	return class'UIAPI_TREECTRL'.static.InsertNode(TREENAME, ParentName, infNode);
}

// ù ��° ���� ��� ����
function string insertExpandNode ( string NodeName, string ParentName) 
{
	local XMLTreeNodeInfo		infNode;	
	local XMLTreeNodeInfo		infNodeClear;

	infNode = infNodeClear ;
	infNode.strName = NodeName ;//"" $ ProductID ;
	//infNode.Tooltip = MakeTooltipSimpleText(strTmp) ;
	infNode.bFollowCursor = True ;	

	infNode.bShowButton = 1;
	
	infNode.nTexBtnOffSetY = 8;
	infNode.nTexBtnWidth = 15;
	infNode.nTexBtnHeight = 15;
	infNode.strTexBtnExpand = "l2ui_ch3.QuestWnd.QuestWndPlusBtn";
	infNode.strTexBtnCollapse = "l2ui_ch3.QuestWnd.QuestWndMinusBtn";	

	return class'UIAPI_TREECTRL'.static.InsertNode(TREENAME, ParentName, infNode);
	//class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}


/******************************************************************************************************************************
 * desc�� �ҷ� ���� ��
 * ****************************************************************************************************************************/
function LoadHtml()
{
	local array<string> info;
	local string FileName;
	local int MovieId;

	local TutorialBody body;
	GetTutorialBody ( currentID, bodyCountCurrent , body ); 
	ExecuteEvent(EV_DeleteSceneClipView, "");
	if ( body.DisplayType == 1 ) 
	{
		// FileName;MovieId;Html
		Split(body.Description, ";", info);
		FileName = info[0];
		MovieId = int(info[1]);
		htmlViewer.LoadHtmlFromString(htmlSetHtmlStart(info[2]));
		if ( FileName != "" )
		{
			if( MovieId > 0 )
			{
				PlayVideo(FileName, MovieId);
				return;
			}
		}
	}
	else
	{
		htmlViewer.LoadHtmlFromString(htmlSetHtmlStart(body.Description));
	}
	
}


//function string htmlSetHtmlStart(string targetHtml)
//{
//	return "<html><body scroll='no'><body>" $ targetHtml $ "</body></html>";
//}

static function ShowHelp(optional int Id, optional int bodyCount)
{
	local HelpWnd helpWndScr;

	helpWndScr = HelpWnd(GetScript("HelpWnd"));
	// End:0x4F
	if( helpWndScr.Me.IsShowWindow() )
	{
		helpWndScr.Me.HideWindow();
		return;
	}
	helpWndScr.SetExpandedNodeByID(Id, bodyCount);
	helpWndScr.Me.ShowWindow();
	helpWndScr.HtmlViewer.SetFocus();
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(Self))).HideWindow();
}

defaultproperties
{
}
