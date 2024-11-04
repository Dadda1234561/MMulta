/**
 * 
 *   ����
 *  
 *  Memo :
 *  2016.04.04 �������: �ڵ�� ���� �״��, ������ ���ַ� ������, 
 *  ���� ��� ���� ��ư ����, ������ �ޱ� �߰�, �ְ� ������ ������ ��ȭ(�ؽ�Ʈ�� �о��ֱ�)
 *  
 **/
class AuctionWnd extends UICommonAPI;

// Sets Timer Value
const TIMER_ID=777; 
const TIMER_DELAY=1000; 

const DIALOG_ASK_AUCTION_PRICE	= 321;	// ���� ���� ���� �Է� ���̾�α� ID
const DIALOG_CONFIRM_PRICE		= 432;	// ���� ������ Ȯ���ϴ� ���̾�α� ID

const ADENA_OVER_FLOW = "1000000000000";		//���� �����÷ο�

// ���� �ڵ� �޾ƿ���.
var WindowHandle Me;
var TextBoxHandle txtRemainStr;
var TextBoxHandle txtTimeHour;
var TextBoxHandle txtTimeMin;
var TextBoxHandle txtTimeSec;
var TextBoxHandle txtHighBid;
var TextBoxHandle txtMyAdenaStr;
var TextBoxHandle txtMyAdena;
var TextBoxHandle txtItemInfoStr;

var ButtonHandle BtnBid1;
var ButtonHandle BtnBid2;
var ButtonHandle BtnBid3;
var ButtonHandle BtnBid4;
var ButtonHandle BtnBidInput;
var TextBoxHandle txtHighBidStr;
//var TextBoxHandle txtInfo;

var ButtonHandle BtnClose;
var ButtonHandle BtnNext;
var ItemWindowHandle AuctionItem;
//var TextBoxHandle txtItemDesc;
var TextBoxHandle txtItemName;
//var WindowHandle areaScroll;
//var WindowHandle NextAuctionWnd;

var TextBoxHandle txtHighBid_word;

// ������
var INT64 m_myLastBidPrice;		 // ���������� �ڽ��� �����ߴ� ������ �����صд�. 
var INT64 m_myBidPrice;		     // ������ �õ��ϴ� ����
var INT64 m_currentPrice;		 // ���� �ְ� ������
var int m_auctionID;		     // ���� ���� �ִ� �������� ���� ���̵�
var ItemInfo 	m_auctionItem;	 // ��ſ� �ö��ִ� �������� ����

var int 		bShowUI;
var int 		iAuctionID;
var INT64		iCurrentPrice;
var int 		iRemainSecond;

function OnRegisterEvent()
{
	// �̺�Ʈ ��� 
	RegisterEvent( EV_ITEM_AUCTION_INFO );
	RegisterEvent( EV_AdenaInvenCount );
	RegisterEvent( EV_DialogOK );
}

function OnLoad()
{
	SetClosingOnESC();

	Initialize();
	Load();
	
}

function Initialize()
{

	Me = GetWindowHandle( "AuctionWnd" );
	txtRemainStr = GetTextBoxHandle( "AuctionWnd.txtRemainStr" );
	txtTimeHour = GetTextBoxHandle( "AuctionWnd.txtTimeHour" );
	txtTimeMin = GetTextBoxHandle( "AuctionWnd.txtTimeMin" );
	txtTimeSec = GetTextBoxHandle( "AuctionWnd.txtTimeSec" );
	txtHighBid = GetTextBoxHandle( "AuctionWnd.txtHighBid" );

	txtMyAdenaStr = GetTextBoxHandle( "AuctionWnd.txtMyAdenaStr" );
	txtMyAdena = GetTextBoxHandle( "AuctionWnd.txtMyAdena" );
	txtItemInfoStr = GetTextBoxHandle( "AuctionWnd.txtItemInfoStr" );

	BtnBid1 = GetButtonHandle( "AuctionWnd.BtnBid1" );
	BtnBid2 = GetButtonHandle( "AuctionWnd.BtnBid2" );
	BtnBid3 = GetButtonHandle( "AuctionWnd.BtnBid3" );
	BtnBid4 = GetButtonHandle( "AuctionWnd.BtnBid4" );	
	BtnBidInput = GetButtonHandle( "AuctionWnd.BtnBidInput" );
	txtHighBidStr = GetTextBoxHandle( "AuctionWnd.txtHighBidStr" );

	//txtInfo = GetTextBoxHandle( "AuctionWnd.txtInfo" );

	BtnClose = GetButtonHandle( "AuctionWnd.BtnClose" );
	AuctionItem = GetItemWindowHandle ( "AuctionWnd.AuctionItem" );
	//txtItemDesc = GetTextBoxHandle( "AuctionWnd.scrollDesc.txtItemDesc" );
	txtItemName = GetTextBoxHandle( "AuctionWnd.txtItemName" );
	//areaScroll = GetWindowHandle( "AuctionWnd.scrollDesc" );
	BtnNext = GetButtonHandle( "AuctionWnd.BtnNextAuction" );
	//NextAuctionWnd = GetWindowHandle( "NextAuctionDrawerWnd" );

	// �ְ� ������ ������ ���� (�о� �ֱ� 5�� �̷���)
	txtHighBid_word = GetTextBoxHandle("AuctionWnd.txtHighBid_word");
}

function Load()
{
}

// �̺�Ʈ�� �޾� �����͸� �Ľ��Ѵ�. 
function OnEvent(int Event_ID, string param)
{
	//�̺�Ʈ�� �޴� ����
	local ItemInfo 	info;
	
	switch(Event_ID)
	{
		//�⺻ ��� �̺�Ʈ
		case EV_ITEM_AUCTION_INFO:
		//case 0:
			ParseInt(param, "ShowUI", bShowUI);
			ParseInt(param, "AuctionID", iAuctionID);
			ParseInt64(param, "CurrentPrice", iCurrentPrice);
			ParseInt(param, "RemainSecond", iRemainSecond);		
			ParamToItemInfo( param, info );
		
			//���� ������ �������ش�. 
			m_currentPrice = iCurrentPrice;	
			m_auctionID = iAuctionID;
			m_auctionItem = info;
		
			if( bShowUI == 1)
			{
				// ������ ���� �߰� 
				InsertAuctionItem();
				
				// â�� ó�� ������ Ÿ�̸Ӹ� �Ҵ�.
				m_hOwnerWnd.SetTimer( TIMER_ID, TIMER_DELAY );	
				Me.ShowWindow();	
				Me.SetFocus();
			}
			
			//debug("bShowUI : " $ bShowUI $ "iAuctionID : " $ iAuctionID $ " iCurrentPrice : " $ iCurrentPrice $ "iRemainSecond : " $ iRemainSecond);
				
			// ������ �������ִ� �Լ� ȣ��
			UpdateAuctionWnd();
			break;
			
		case EV_AdenaInvenCount :
			myUpdateAdena();
			break;

		// ���� ���� �Է� Ȯ�ν�		
		case EV_DialogOK:	
			HandleDialogOK();
			break;
	}
}

function OnTimer(int TimerID)
{
	// Sending packet in Timer may be very dangerous and unhealthy.
	// Be aware of its influence over performance. If you are uncertain always contact client team member.
	if(TimerID == TIMER_ID)
	{
		class'AuctionAPI'.static.RequestInfoItemAuction( m_auctionID  );	// ���� ���� ��û
	}
}

function InsertAuctionItem()
{
	AuctionItem.clear();
	AuctionItem.AddItem( m_auctionItem );
	AuctionItem.SetTooltipType( "Inventory");
	
	//class'UIDATA_ITEM'.static.GetItemInfo( info.Id , tempInfo);
	txtItemName.setText( m_auctionItem.Name );
	//txtItemDesc.setText( info.Name $ ": ����¯���� ������. õ�� �Ƶ����� �Ʊ��� ��Ÿ" );
	//ComputeScrollHeight( m_auctionItem.Description );	//���̸� ������ش�. 
	//txtItemDesc.setText( m_auctionItem.Description );
}

//function ComputeScrollHeight(string tempStr)
//{
//	local int nHeight;
//	local int nWidth;
	
//	local Rect rectWnd;
	
//	rectWnd = txtItemDesc.GetRect();
	
//	GetTextSizeDefault(tempStr, nWidth, nHeight);		// ����� �޾Ƽ�
	
//	areaScroll.SetScrollHeight((nHeight + 1) * (nWidth / rectWnd.nWidth + 1));
//	//debug("nHeight : " $ nHeight $ " nWidth : " $ nWidth $ "nWidth / rectWnd.nWidth : " $ (nWidth / rectWnd.nWidth));
//	areaScroll.SetScrollPosition( 0 );
//}

function OnShow()
{
	BtnNext.EnableWindow();
	BtnBid1.EnableWindow();
	BtnBid2.EnableWindow();
	BtnBid3.EnableWindow();
	BtnBid4.EnableWindow();
	BtnBidInput.EnableWindow();
}

function OnHide()
{
	// â�� ���� ��� Ÿ�̸Ӹ� ����� �Ѵ�. 
	class'UIAPI_WINDOW'.static.KillUITimer("AuctionWnd",Timer_ID);  	// Ÿ�̸� ����
	class'UIAPI_ITEMWINDOW'.static.Clear("AuctionWnd.AuctionItem");	// ������ ������ Ŭ����
	//NextAuctionWnd.HideWindow();
}

function OnClickButton( string Name )
{
	m_myBidPrice = -1;


	switch( Name )
	{
		case "BtnBid1":	// 2��
			m_myBidPrice = m_currentPrice * 2;
			if (m_myBidPrice > INT64(ADENA_OVER_FLOW) || m_myBidPrice< 0)	//���� Ȥ�� 21���� ������ ���� ����
			{			
				BtnBid1.DisableWindow();
				BtnBid1.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2157)));
			}
			else
			{
				DialogSetID( DIALOG_CONFIRM_PRICE );
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg( GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(string(m_myBidPrice) )), string(Self) );
			}
			//class'AuctionAPI'.static.RequestBidItemAuction( m_auctionID ,  m_myBidPrice);	// ������ �õ��մϴ�.
			break;

		case "BtnBid2":	// 50%
			//m_myBidPrice = m_currentPrice * 0.5 + m_currentPrice;
			m_myBidPrice = ((m_currentPrice * 5) / 10)  + m_currentPrice;
			
			if (m_myBidPrice > INT64(ADENA_OVER_FLOW) || m_myBidPrice< 0)	//���� Ȥ�� 21���� ������ ���� ����
			{
				BtnBid2.DisableWindow();
				BtnBid2.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2157)));
			}
			else
			{
				DialogSetID( DIALOG_CONFIRM_PRICE );
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg( GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(string(m_myBidPrice) ) ), string(Self));
			}
			//class'AuctionAPI'.static.RequestBidItemAuction( m_auctionID ,  m_myBidPrice);	// ������ �õ��մϴ�.
			break;

		case "BtnBid3":
			m_myBidPrice = (m_currentPrice / 10) + m_currentPrice;
			if (m_myBidPrice > INT64(ADENA_OVER_FLOW) || m_myBidPrice< 0)	//���� Ȥ�� 21���� ������ ���� ����
			{
				BtnBid3.DisableWindow();
				BtnBid3.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2157)));
			}
			else
			{
				DialogSetID( DIALOG_CONFIRM_PRICE );
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg( GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(string(m_myBidPrice) )), string(Self) );
			}
			//class'AuctionAPI'.static.RequestBidItemAuction( m_auctionID ,  m_myBidPrice);	// ������ �õ��մϴ�.
			break;
		case "BtnBid4":

			m_myBidPrice = ((m_currentPrice * 5) / 100) + m_currentPrice;

			Debug("m_myBidPrice" @  m_myBidPrice);
			if (m_myBidPrice > INT64(ADENA_OVER_FLOW) || m_myBidPrice< 0)	//���� Ȥ�� 21���� ������ ���� ����
			{
				BtnBid4.DisableWindow();
				BtnBid4.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2157)));
			}
			else
			{
				DialogSetID( DIALOG_CONFIRM_PRICE );
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg( GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(string(m_myBidPrice) )), string(Self) );

				Debug("MakeCostString(string(m_myBidPrice) )" @ MakeCostString(string(m_myBidPrice) ));
			}
			//class'AuctionAPI'.static.RequestBidItemAuction( m_auctionID ,  m_myBidPrice);	// ������ �õ��մϴ�.
			break;		

		case "BtnBidInput":
			OnBtnBidInputClick();
			break;

		case "BtnClose":
			if( IsShowWindow("AuctionWnd"))
				HideWindow("AuctionWnd");
			//NextAuctionWnd.HideWindow();
			break;

		// ������ �ޱ� 2016-04-04 �߰�
		case "BtnFailBid" :
			// ������ �ޱ� 
			RequestBypassToServer( "item_auction_withdraw" );
			Debug("������ �ޱ� ����!");
			break;
	}
}

function myUpdateAdena()
{
	local CustomTooltip cTooltip;

	// �� ������ ����.
	//txtMyAdena.setText(MakeCostString( string(GetAdena()) ) $ " " $ GetSystemString(469));
	txtMyAdena.setText(MakeCostString( string(GetAdena()) ) );

	// �Ƶ��� �о� �ִ� ���� �߰�
	addToolTipDrawList(cTooltip, addDrawItemText(ConvertNumToTextNoAdena(String(GetAdena())) $ " " $ GetSystemString(469), getInstanceL2Util().White , "", false));
	txtMyAdena.SetTooltipCustomType(cTooltip);
}

function UpdateAuctionWnd()
{
	local int temp1;
	local int m_timeHour;
	local int m_timeMin;
	local int m_timeSec;

		
	local string tempStr;
	//local int myAdena;

	local INT64 tempPrice;
	
	
	// ���� �ְ��� �������ش�.  
	//txtHighBid.setText( MakeCostString( string(m_currentPrice) ) $ " adena");
	txtHighBid.setText( MakeCostString( string(m_currentPrice) ) $ " " $ GetSystemString(469));
	txtHighBid.SetTextColor( GetNumericColor( string(m_currentPrice) ) );

	// �Ƶ��� �о� �ֱ�
	txtHighBid_word.SetTextColor( GetNumericColor( string(m_currentPrice) ) );
	txtHighBid_word.SetText(ConvertNumToTextNoAdena(string(m_currentPrice)) $ " " $ GetSystemString(469));

	//MyAdena.SetTooltipString( ConvertNumToText(string(GetAdena())) );

	myUpdateAdena();

	// �ð� ����. 
	m_timeSec = iRemainSecond % 60;	// ��
	temp1 = iRemainSecond / 60;
	m_timeHour = temp1 / 60;			// ��
	m_timeMin = temp1 % 60;			// ��?
	
	//debug(" m_timeHour : " $ m_timeHour $ "m_timeMin : "  $ m_timeMin$ "m_timeSec : "  $ m_timeSec);
	
	// �ø� �׷��ش�.
	if(m_timeHour > 0)
	{
		if (m_timeHour < 10 ) txtTimeHour.setText( "0" $ string( m_timeHour ));
		else txtTimeHour.setText( string( m_timeHour ));
	}
	else
	{
		txtTimeHour.setText( "00");
	}
	
	// ���� �׷��ش�.
	if( m_timeMin > 0)
	{
		if (m_timeMin < 10 ) txtTimeMin.setText( "0" $ string( m_timeMin ));
		else txtTimeMin.setText( string( m_timeMin ));
	}
	else
	{
		txtTimeMin.setText( "00");
	}
		
	// �ʸ� �׷��ش�. 
	if(m_timeSec > 0)
	{
		if (m_timeSec < 10 ) txtTimeSec.setText( "0" $ string( m_timeSec ));
		else txtTimeSec.setText( string( m_timeSec ));
	}
	else
	{
		txtTimeSec.setText( "00");
	}
	//txtRemainTime.setText( string( m_timeHour ) $ " : " $ string( m_timeMin ) $ " : " $ string( m_timeSec ) );
	
	//��ư�� ������ ������ �����ش�. 
	tempPrice = m_currentPrice * 2;
	if(tempPrice > INT64(ADENA_OVER_FLOW) || tempPrice < 0 )
	{
		BtnBid1.DisableWindow();
		BtnBid1.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2076)));
	}
	else
	{
		if(!BtnBid1.IsEnableWindow()) BtnBid1.EnableWindow();
		tempStr = MakeFullSystemMsg( GetSystemMessage(2157), MakeCostString(string(tempPrice) ) );
		//BtnBid1.SetTooltipCustomType( MakeTooltipSimpleText(tempStr));

   		BtnBid1.SetTooltipCustomType(MakeTooltipMultiText(tempStr, getInstanceL2Util().White, "",false,
									   					  "(" $ ConvertNumToText(string(tempPrice)) $ ")", GetNumericColor(string(tempPrice)), "",true));
	}
	
	//temp1 = m_currentPrice * 15 / 10;
	tempPrice = ((m_currentPrice * 5) / 10) + m_currentPrice;
	if(tempPrice > INT64(ADENA_OVER_FLOW) || tempPrice < 0 )
	{
		BtnBid2.DisableWindow();
		BtnBid2.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2076)));
	}
	else
	{
		if(!BtnBid2.IsEnableWindow()) BtnBid2.EnableWindow();
		tempStr = MakeFullSystemMsg( GetSystemMessage(2157), MakeCostString(string(tempPrice)));
		//BtnBid2.SetTooltipCustomType( MakeTooltipSimpleText(tempStr));

   		BtnBid2.SetTooltipCustomType(MakeTooltipMultiText(tempStr, getInstanceL2Util().White, "",false,
									   					  "(" $ ConvertNumToText(string(tempPrice)) $ ")", GetNumericColor(string(tempPrice)), "",true));
	}
	
	//temp1 = m_currentPrice * 11 /10;
	tempPrice = (m_currentPrice / 10) + m_currentPrice;
	if(tempPrice > INT64(ADENA_OVER_FLOW) || tempPrice < 0 )
	{
		BtnBid3.DisableWindow();
		BtnBid3.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2076)));
	}
	else
	{
		if(!BtnBid3.IsEnableWindow()) BtnBid3.EnableWindow();
		tempStr = MakeFullSystemMsg( GetSystemMessage(2157), MakeCostString(string(tempPrice) ) );
		//BtnBid3.SetTooltipCustomType( MakeTooltipSimpleText(tempStr));
   		BtnBid3.SetTooltipCustomType(MakeTooltipMultiText(tempStr, getInstanceL2Util().White, "",false,
									   					  "(" $ ConvertNumToText(string(tempPrice)) $ ")", GetNumericColor(string(tempPrice)), "",true));

	}
	
	//temp1 = m_currentPrice * 105 / 100;		//ũ��
	tempPrice = ((m_currentPrice * 5) / 100) + m_currentPrice;
	//debug("temp 1 : " $ m_currentPrice  * 0.05 + m_currentPrice);
	if(tempPrice > INT64(ADENA_OVER_FLOW) || tempPrice < 0 )
	{
		BtnBid4.DisableWindow();
		BtnBid4.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2076)));
	}
	else
	{
		if(!BtnBid4.IsEnableWindow()) BtnBid4.EnableWindow();
		tempStr = MakeFullSystemMsg( GetSystemMessage(2157), MakeCostString(string(tempPrice) ) );
		//BtnBid4.SetTooltipCustomType( MakeTooltipSimpleText(tempStr));

   		BtnBid4.SetTooltipCustomType(MakeTooltipMultiText(tempStr, getInstanceL2Util().White, "",false,
									   					  "(" $ ConvertNumToText(string(tempPrice)) $ ")", GetNumericColor(string(tempPrice)), "",true));

	}
	
	if(m_timeHour == 0 && m_timeMin == 0 && m_timeSec == 0)	//��Ű� ������ Ÿ�̸Ӹ� ���δ�.
	{
		m_hOwnerWnd.KillTimer( TIMER_ID );
	}
	
	if(iRemainSecond == 0)
	{
		// iRemainSecond�� 0�̸� �̹� ��Ŵ� ����� ����. ���� ��� ���� â�� �����ش�.
		BtnBid1.DisableWindow();
		BtnBid2.DisableWindow();
		BtnBid3.DisableWindow();
		BtnBid4.DisableWindow();
		BtnBidInput.DisableWindow();
		
		//NextAuctionWnd.ShowWindow();
		BtnClose.EnableWindow();
	}
}

function OnBtnBidInputClick()
{
	DialogSetID( DIALOG_ASK_AUCTION_PRICE );
	//DialogSetReservedItemID( info.ID );				// ClassID
	DialogSetEditType("number");
	DialogSetParamInt64( -1 );
	DialogSetDefaultOK();	
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(2138), string(Self) );
}

function HandleDialogOK()
{
	local int id;				//���̾�α� ���̵� �޾ƿ´�. 
	if( DialogIsMine() )
	{
		id = DialogGetID();
		if( id == DIALOG_ASK_AUCTION_PRICE)
		{
			// �����÷ο� üũ �ؾ���.
			m_myBidPrice = INT64( DialogGetString() );
			DialogSetID( DIALOG_CONFIRM_PRICE );
			DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg( GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(string(m_myBidPrice) ) ), string(Self));
			
			//class'AuctionAPI'.static.RequestBidItemAuction( m_auctionID ,  m_myBidPrice);	// ������ �õ��մϴ�.
		}
		else if( id == DIALOG_CONFIRM_PRICE)
		{
			class'AuctionAPI'.static.RequestBidItemAuction( m_auctionID ,  m_myBidPrice);	// ������ �õ��մϴ�.
		}
	}
	
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	OnClickButton("BtnClose");
}

defaultproperties
{
}
