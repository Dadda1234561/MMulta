/**
 *  ����Ʈ ��ȭâ (����)
 *  
 *  ���Ƹ�, ���� ���� �� �� ���� (�߱� ���� ����)
 *  
 **/

class QuestHTMLWnd extends UICommonAPI;


const HTML_WIDTH    = 400;
const TABLEBG_WIDTH = 272;

var WindowHandle 	Me;
var HtmlHandle		m_hHtmlViewer;
var bool			m_bDrawBg;

//
var bool			m_bPressCloseButton;
var bool			m_bReShowWndMode;
var bool			m_bReShowQuestHtmlWnd;	

var string          htmlString;
var int             htmlWidth;


var int bicIconLen; 

function OnRegisterEvent()
{
	RegisterEvent(EV_QuestHtmlWndShow);
	RegisterEvent(EV_QuestHtmlWndHide);
//	RegisterEvent(EV_NPCDialogWndHide);
	RegisterEvent(EV_QuestHtmlWndLoadHtmlFromString);
	RegisterEvent(EV_QuestIDWndLoadHtmlFromString);
	
	// register gamingstate enter/exit event 
	// - ������� ������, ó�� ȣ��ɶ� OnEnter�� OnExit�� ȣ����� ����.
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_GamingStateExit);
} 

function OnLoad()
{
	SetClosingOnESC(); 
	//getInstanceUIData().addEscCloseWindow(getCurrentWindowName(string(Self)));

	OnRegisterEvent();

	Me=GetWindowHandle("QuestHTMLWnd");
	m_hHtmlViewer=GetHtmlHandle("QuestHTMLWnd.HtmlViewer");
}

function onShow ()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(Self)), "QuestHTMLWnd,NPCDialogWnd");
}

function OnHide()
{
	ProcCloseQuestHTMLWnd();
	getInstanceL2Util().syncWindowLocAuto("QuestHTMLWnd,NPCDialogWnd");
}

function OnDefaultPosition()
{
	// empty
}

function OnEvent(int Event_ID, String param)
{
	switch(Event_ID)
	{
		case EV_QuestHtmlWndShow :
			ShowQuestHtmlWnd();
			break;
			
		case EV_QuestHtmlWndHide :	
			HideQuestHtmlWnd();
			break;
			
		case EV_QuestHtmlWndLoadHtmlFromString :
			setWindowTitleByString(GetSystemString(444));	 //Ÿ��Ʋ�� "��ȭ"�� �ٲ��ش�. 
			HandleLoadHtmlFromString(param);
			break;
			
		case EV_QuestIDWndLoadHtmlFromString:
			HandleQuestIDLoadHtmlFromString(param);
			break;

			// 19
		case EV_Test_9:
			m_hHtmlViewer.LoadHtmlFromString( param);
			break;

	}
}

// �̱� xp ǥ���� ���ؼ�..
function int getLanguageNumber()
{
	local ELanguageType Language;	
	local int languageNum;

	Language = GetLanguage();
		
	switch( Language )
	{	
		case LANG_Korean:
			languageNum = 0;
			break;	
		case LANG_English:
			languageNum = 1;
			break;
		case LANG_Japanese:
			languageNum = 2;
			break;
		case LANG_Taiwan:
			languageNum = 3;
			break;
		case LANG_Chinese:	
			languageNum = 4;
			break;
		case LANG_Thai:		
			languageNum = 5;
			break;
		case LANG_Philippine:
			languageNum = 6;
			break;
		case LANG_Indonesia:
			languageNum = 7;
			break;
		case LANG_Russia:	
			languageNum = 8;
			break;
		case LANG_Euro:	
			languageNum = 9;
			break;
		case LANG_Germany:	
			languageNum = 10;
			break;
		case LANG_France:	
			languageNum = 11;
			break;
		case LANG_Poland:	
			languageNum = 12;
			break;
		case LANG_Turkey:	
			languageNum = 13;
			break;
		//end of branch
		default:
			languageNum = 0;
			break;
	}	

	return languageNum;		

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 2.3 �������
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function HandleQuestIDLoadHtmlFromString(string param)
{
	local int QuestID;
	local Array<int> rewardIDList;
	local Array<INT64> rewardNumList;
		
	local int i;
	local string addItemHtml, iconName, itemText, itemName;

	local string rewardSmallIconHtml, rewardMsgHtml, rewardEndMsgHtml;

	local int tableIndex, smallIconIndex;

	ParseInt(param, "QuestID", QuestID);
	
	class'UIDATA_QUEST'.static.GetQuestReward(QuestID, 1, rewardIDList, rewardNumList);

	tableIndex = 0;
	smallIconIndex = 0;
	bicIconLen = 0;

	rewardSmallIconHtml = "<table width=278 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
	

	for ( i = 0 ; i < rewardIDList.Length ; i++ )
	{
		if ( rewardIDList[i] != 57 && rewardIDList[i] != 15623 && rewardIDList[i] != 15624 && rewardIDList[i] != 47130)
		{
			bicIconLen++;
		}
	}
	
	if (bicIconLen == 1)
	{
		rewardMsgHtml = "<table width=278 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
	}
	else
	{
		rewardMsgHtml = "<table width=278 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
	}

	if ( rewardIDList.length > 0 )
	{
		for( i = 0 ; i < rewardIDList.Length ; i++ )
		{

			if( i == 0 )
			{
				//addItemHtml = htmlTableAdd( "L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Up" ) $ 
				//			  "<font color=\"d4af6f\" name=name=GameDefault>" $ GetSystemString(1127) $ "</font>" $ 
				//			  "<br1><img src=L2UI_CT1.Divider.Divider_DF_Ver width=286 height=2><br1></td></tr></table>"; // ����

				addItemHtml = // htmlTableAdd( "L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Up" ) $ 
							  "<br>" $
							  htmlTableAdd( "L2UI_CT1.GroupBox.GroupBox_DF" ) $ 					
							  "<font color=\"ffcc00\" name=GameDefault>" $ GetSystemString(2006) $ "</font>" $ "</td></tr></table>"; // ���� ������
			}
							  
							  //"<br1><img src=L2UI_CT1.Divider.Divider_DF_Ver width=274 height=2><br></td></tr></table>"; // ����


			switch (rewardIDList[i])
			{
				case 57: // �Ƶ��� iconName = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(57));	
				case 15623: // ����ġ
				case 15624: // sp, ��ų����Ʈ
				case 47130: // ��ȣ�� ����Ʈ
				// End:0x612
				case 95641:
					itemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(rewardIDList[i]));
					if( rewardIDList[i] == 57 )
					{
						iconName = "L2UI_CT1.HtmlWnd.HTMLWnd_adena";
						itemName = GetSystemString(469);
					}
					else if( rewardIDList[i] == 15623 )
					{
						if (getLanguageNumber() == 1)
						{
							// �̱� 
							// ���Ŀ� xp ���������� ��ü �ϸ� �ɵ�..
						}

						iconName = "L2UI_CT1.HtmlWnd.HTMLWnd_EXP";
					}
					else if(  rewardIDList[i] == 15624 )
					{
						iconName = "L2UI_CT1.HtmlWnd.HTMLWnd_SP";
					}

					// 2015-11-23 FP �߰� (���� ������)
					else if(  rewardIDList[i] == 47130 )
					{
						iconName = "L2UI_CT1.HtmlWnd.HTMLWnd_FP";
					}
					else if(rewardIDList[i] == 95641)
					{
						IconName = "L2UI_CT1.HtmlWnd.htmlwnd_lv_point";
					}


					//����
					if (rewardNumList[i] == 0)
					{
						itemText = GetSystemString(584);
					}
					else
					{
						// SP �� ��� 
						if (rewardIDList[i] == 15624)
						{
							//itemText = string(getInstanceUIData().getSPChangedValue(rewardNumList[i]));
							itemText = (MakeCostString(String(rewardNumList[i])));
							// Debug("sp rewardNumList[i]" @ rewardNumList[i]);
						}
						// �׿�
						else
						{
							itemText = (MakeCostString(String(rewardNumList[i])));
						}
					}

					//$ " itemtooltip=\"" $ rewardIDList[i] $ "\"" 
					//rewardSmallIconHtml = rewardSmallIconHtml $ "<tr><td width=38 height=22 align=center valign=center><button width=32 height=16"											  
					//					  $	" back=\"" $ iconName $ "\"" $ " high=\"" $ iconName $ "\"" $ " fore=\"" $ iconName $ "\"></td><td height=22 width=246><font color=ba8860>" 
					//					  $ itemText $"</font>" @ htmlfontAdd(itemName) $ "</td></tr>";

					rewardSmallIconHtml = rewardSmallIconHtml $ "<tr><td width=38 height=22 align=center valign=center><Img width=32 height=16"											  
										  $	" src=\"" $ iconName $ "\"" $ "></td><td height=22 width=236><font color=ba8860>" 
										  $ itemText $"</font>" @ htmlfontAdd(itemName) $ "</td></tr>";

					smallIconIndex = smallIconIndex + 1;
					break;

				default:
					iconName = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(rewardIDList[i]));
					itemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(rewardIDList[i]));

					// Debug("iconName" @ iconName);
					// Debug("rewardIDList[i]"  @ rewardIDList[i]);

					//������ ����
					if (rewardNumList[i] == 0)
					{
						itemText = htmlfontAdd( GetSystemString(584), "ba8860" ); // ����
					}
					else
					{
						// �Ʒ��� �ش��ϴ� ��� �� "��" ǥ�ð� �ȵǾ�� �Ѵ�.
						if (rewardIDList[i] == 15623 ||   // ����ġ  
							rewardIDList[i] == 15624 ||   // ��ų ����Ʈ
							rewardIDList[i] == 15625 ||   // ����ǥ        
							rewardIDList[i] == 15626 ||   // Ȱ�� ����Ʈ
							rewardIDList[i] == 15627 ||   // ���� ����Ʈ
							rewardIDList[i] == 15628 ||   // ���� ����
							rewardIDList[i] == 15629 ||   // ������ ����
							rewardIDList[i] == 15630 ||   // �߰� ����
							rewardIDList[i] == 15631 ||   // ���� Ŭ���� ���� ȹ��
							rewardIDList[i] == 15632 ||   // PK ī��Ʈ �϶� 
							rewardIDList[i] == 15633)
						{
							itemText = htmlfontAdd((MakeCostString(string(rewardNumList[i]))), "ba8860");
						}
						else
						{    
							// $1��
							itemText =MakeFullSystemMsg(htmlfontAdd(GetSystemMessage(1983)), htmlfontAdd((MakeCostString(string(rewardNumList[i]))),"ba8860"),"");
						}
					}

					// �ѱ��� ���ٸ�.. ��ĭ���� ���� ������
					if (getLanguageNumber() == 0)
					{
						// ū������ �������� �ϳ��϶� ������ǥ �ȵǰ� 
						if( bicIconLen == 1 )
						{
							//rewardMsgHtml = rewardMsgHtml $ "<tr><td align=center valign=center width=1 height=32></td>" 
							rewardMsgHtml = rewardMsgHtml $ "<tr>" 
											$ "<td width=2 height=32></td><td align=center valign=center width=32 height=32><button width=32 height=32" 
											$ " itemtooltip=\"" $ rewardIDList[i] $ "\"" $ " back=\"" $ iconName $ "\"" $ " high=\"" $ iconName 
											$ "\"" $  " fore=\"" $ iconName $ "\"></button></td><td width=1 height=32></td><td width=234 height=32>" $ htmlfontAdd(itemName) 
											$ "<br1>"$ itemText $ "</td></tr>";
						}
						else
						{
							if( rewardIDList.Length > 0 && len(itemName) > 8 )
							{
								itemName = mid(itemName, 0 , 8) $ "..";
							}

							if( tableIndex % 2 > 0 ) // ù��° 
							{
								rewardMsgHtml = mid(rewardMsgHtml, 0 , len(rewardMsgHtml)-5);
								rewardMsgHtml = rewardMsgHtml
												$ "<td align=center valign=center width=32 height=32><button width=32 height=32" 
												$ " itemtooltip=\"" $ rewardIDList[i] $ "\"" $ " back=\"" $ iconName $ "\"" $ " high=\"" $ iconName 
												$ "\"" $  " fore=\"" $ iconName $ "\"></td><td width=110 height=32></button>" $ htmlfontAdd(itemName) 												
												$ "<br1>"$ itemText $ "<br1>" $"</td></tr>";
							}
							else 
							{
								// ���� ������ htmlTableTrAdd �Լ� ����..
								rewardMsgHtml = rewardMsgHtml $ htmlTableTrAdd() $  "<tr><td align=center valign=center width=32 height=32><button width=32 height=32" 
												$ " itemtooltip=\"" $ rewardIDList[i] $ "\"" $ " back=\"" $ iconName $ "\"" $ " high=\"" $ iconName 
												$ "\"" $  " fore=\"" $ iconName $ "\"></button></td><td width=110 height=32>" $ htmlfontAdd(itemName) 
												$ "<br1>"$ itemText $ "</td></tr>";
							}
						}
					}
					else
					{
						// �ؿܴ� ���ٷ� ���� �������� �������� ����
						itemName = makeShortStringByPixel(itemName, 230, "..");
						rewardMsgHtml = rewardMsgHtml $ "<tr>" 
										$ "<td width=2 height=32></td><td align=center valign=center width=32 height=32><button width=32 height=32" 
										$ " itemtooltip=\"" $ rewardIDList[i] $ "\"" $ " back=\"" $ iconName $ "\"" $ " high=\"" $ iconName 
										$ "\"" $  " fore=\"" $ iconName $ "\"></button></td><td width=1 height=32></td><td width=234 height=32>" $ htmlfontAdd(itemName) 
										$ "<br1>"$ itemText $ "</td></tr>";
					}

					/// Debug("iconName" @ iconName);
					tableIndex = tableIndex + 1;
			}
			// tableIndex = tableIndex + 1;
			
		}

		///////// ����Ʈ ���� ��� ����////////////////////////////////////
		if( tableIndex > 0 )
		{
			rewardMsgHtml = rewardMsgHtml $ "</table>";
		}
		else
		{
			rewardMsgHtml = "";
		}

		if( smallIconIndex > 0 )
		{
			rewardSmallIconHtml = rewardSmallIconHtml $ "</table>";
		}
		else
		{
			rewardSmallIconHtml = "";
		}
		/////////////////////////////////////////////////////////////////////
		
		htmlString = mid(htmlString, 6, len(htmlString)); //<html> �ױ� ����
		htmlString = mid(htmlString, 0, len(htmlString) - 7); //</html> �ױ� ����
		
		if (bicIconLen == 1)
			rewardEndMsgHtml = "<table width=277 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Down><tr><td width=277></td></tr></table>";
		else		
			rewardEndMsgHtml = "<table width=277 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Down><tr><td width=277></td></tr></table>";
		//rewardEndMsgHtml = "<table width=290 border=0 cellpadding=0 cellspacing=3 background=L2UI_Ct1_Cn.Deco.TitleBaseBarMini_HtmlTableDown><tr><td width=290></td></tr></table>";

		addItemHtml = htmlString $ addItemHtml $ rewardSmallIconHtml $ rewardMsgHtml $ rewardEndMsgHtml;

		addItemHtml =  "<html><body>" $ addItemHtml $ "</body></html>";
		//addItemHtml =  "<html><body>" $ addItemHtml $ "<br><table border=0 cellpadding=0 cellspacing=3 width=288 ><tr><td height=15 align=center valign=center><img src=L2UI_CT1_CN.Deco.Horizontal_Deco width=286 height=8></td></tr><tr><td></td></tr></table></body></html>";
		//addItemHtml =  "<html><body>" $ addItemHtml $ "<br><table border=0 cellpadding=0 cellspacing=2 width=274 ><tr></tr><tr><td></td></tr></table></body></html>";
		//addItemHtml =  "<html><body>" $ addItemHtml $ "<br><table border=0 cellpadding=0 cellspacing=3 width=288 ><tr><td height=15 align=center valign=center></td></tr><tr><td></td></tr></table></body></html>";

		m_hHtmlViewer.LoadHtmlFromString( addItemHtml);
	}	

	Me.ShowWindow();
	Me.SetFocus();
}

function string htmlTableAdd( optional string backgroundUrl )
{
	local string htmlStr;

	if( backgroundUrl == "" ) 
		htmlStr = "<table width=278 cellpadding=0 border=0 cellspacing=1" $ "><tr><td width=278>";
	else 
		htmlStr = "<table width=278 cellpadding=0 border=0 cellspacing=1 background="$ backgroundUrl $"><tr><td width=272>";
		// backgroundUrl = "L2UI_Ct1_Cn.Deco.TitleBaseBarMini";

	return htmlStr;
}

function string htmlTableTrAdd()
{
	return "<tr><td width=46 ></td><td width=115 ></td><td width=46 ></td><td width=115 ></td></tr>";
}

function string htmlfontAdd( string strText, optional string fontColor )
{
	local string targetHtml;
	if( fontColor == "" ) fontColor = "d3c5ae";
	
	targetHtml = "<font color=\"" $ fontColor $ "\"" $ ">" $ strText $ "</font>";

	return targetHtml;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
{
	if(a_HtmlHandle==m_hHtmlViewer)
	{
		HideQuestHTMLWnd();
	}
}

function HandleLoadHtmlFromString(string param)
{
	
	ParseString(param, "HTMLString", htmlString);

	m_hHtmlViewer.LoadHtmlFromString(htmlString);
	
	// Debug("HandleLoadHtmlFromString ----- " $ htmlString);
}


function ShowQuestHTMLWnd()
{
	ExecuteEvent(EV_NPCDialogWndHide);
	Me.ShowWindow();
	Me.SetFocus();
	m_bReShowQuestHTMLWnd = true;
}

function HideQuestHTMLWnd()
{			
	Me.HideWindow();
	m_bReShowQuestHTMLWnd = false;
}

function OnClickButton( string Name )
{
	PressCloseButton();
}

function OnExitState( name a_CurrentStateName )
{
	if( a_CurrentStateName == 'NpcZoomCameraState' )
	{
		ReShowQuestHTMLWnd();
		Clear();	
	}
}

function OnEnterState( name a_CurrentStateName )
{		
	if( a_CurrentStateName == 'NpcZoomCameraState' )
	{
		Clear();
		m_bReShowWndMode = true;
	}
}

function Clear()
{
	//
	m_bReShowWndMode	= false;	
	m_bPressCloseButton = false;
	m_bReShowQuestHtmlWnd = false;
}

function PressCloseButton()
{
	// press close button
	if( m_bReShowWndMode )
	{
		m_bPressCloseButton = true;
	}
}

function ProcCloseQuestHTMLWnd()
{	
	if( m_bPressCloseButton && m_bReShowWndMode && m_bReShowQuestHTMLWnd)
	{
		// must first m_bReShowQuestHTMLWnd be false because calling recursive function.
		m_bReShowWndMode = false;		
		RequestFinishNPCZoomCamera();		
	}
}

function ReShowQuestHTMLWnd()
{
	if( m_bReShowWndMode && m_bReShowQuestHTMLWnd )
	{
		ShowQuestHTMLWnd();			
	}	
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	PressCloseButton();
	GetWindowHandle( "QuestHTMLWnd" ).HideWindow();
}

defaultproperties
{
}
