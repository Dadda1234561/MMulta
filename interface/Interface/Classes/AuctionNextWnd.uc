/**
 * 
 *  ������� ���� ���� ������ ���� UI
 *  2016-04
 *  
 **/


class AuctionNextWnd extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle AuctionNextItem;

var TextBoxHandle txtItemName;

var TextBoxHandle AuctionNextTime;

var TextureHandle GroupBox_AuctionNextTime;
var ButtonHandle  BtnClose;

//var TextBoxHandle txtItemDesc;
//var WindowHandle  areaScroll;

var HtmlHandle HtmlViewer;

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle( "AuctionNextWnd" );

	txtItemName     = GetTextBoxHandle( "AuctionNextWnd.txtItemName" );
	AuctionNextTime = GetTextBoxHandle( "AuctionNextWnd.AuctionNextTime" );

	AuctionNextItem = GetItemWindowHandle( "AuctionNextWnd.AuctionNextItem" );

	BtnClose        = GetButtonHandle( "AuctionNextWnd.BtnClose" );

	//txtItemDesc     = GetTextBoxHandle( "AuctionNextWnd.scrollDesc.txtItemDesc" );
	//areaScroll      = GetWindowHandle( "AuctionNextWnd.scrollDesc" );
	HtmlViewer      = GetHtmlHandle("AuctionNextWnd.HtmlViewer");
}

function OnRegisterEvent()
{
	RegisterEvent( EV_ITEM_AUCTION_NEXT_INFO );
	RegisterEvent( EV_ITEM_AUCTION_NEXT_NOTEXIST );
}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "BtnClose":
			 OnBtnCloseClick();
			 break;
	}
}

function OnBtnCloseClick()
{
	Me.HideWindow();
}

// event 
function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// 3051
		case EV_ITEM_AUCTION_NEXT_INFO :
			Debug("EV_ITEM_AUCTION_NEXT_INFO" @ param);
			HandleAuctionNextInfo(param);
			break;

		// 3052
		case EV_ITEM_AUCTION_NEXT_NOTEXIST :
			Debug("EV_ITEM_AUCTION_NEXT_NOTEXIST" @ param);
			HandleAuctionNextInfo(param, true);
			break;
	}
}

function HandleAuctionNextInfo(string param, optional bool bNoItem)
{
	local int startYear, startMon, startDay, startMin, startHour;
	local int64 startPrice;
	local ItemInfo info;

	debug("HandleAuctionNextInfo param = " $ param);
	
	Me.ShowWindow();
	Me.SetFocus();

	ParseInt(param, "startTimeYear", startYear);
	ParseInt(param, "startTimeMonth", startMon);
	ParseInt(param, "startTimeDay", startDay);
	ParseInt(param, "startTimeHour", startHour);
	ParseInt(param, "startTimeMinute", startMin);
	ParseInt64(param, "startPrice", startPrice);


	// class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(24861), info);	

	if (bNoItem)
	{
		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(15625), info);	
		AuctionNextItem.clear();
		AuctionNextItem.AddItem( info );
		AuctionNextItem.ClearTooltip();
		AuctionNextItem.SetTooltipType("text");

		txtItemName.setText( GetSystemString(584) );  // ���� 
		
		HtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(GetSystemString(3552)) );  // ���� 
	}
	else
	{
		// class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(17671), info);
		ParamToItemInfo( param, info );		
		AuctionNextItem.clear();
		AuctionNextItem.AddItem( info );
		AuctionNextItem.SetTooltipType( "Inventory");

		txtItemName.setText( info.Name );
		HtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(info.Description));
	}

	if (startMin >= 10)
	{
		AuctionNextTime.SetText(startYear$"/"$startMon$"/"$startDay$"  "$startHour$":"$startMin);
	}
	
	else if ( startMin < 10 || startMin >= 0)
	{
		AuctionNextTime.SetText(startYear$"/"$startMon$"/"$startDay$"  "$startHour$":"$"0"$startMin);
	}
}

//function ComputeScrollHeight(string tempStr)
//{
//	local int nHeight;
//	local int nWidth;
	
//	local Rect rectWnd;
	
//	rectWnd = txtItemDesc.GetRect();
	
//	GetTextSizeDefault(tempStr, nWidth, nHeight);		// ����� �޾Ƽ�
	
//	areaScroll.SetScrollHeight((nHeight + 1) * (nWidth / rectWnd.nWidth + 1));
//	areaScroll.SetScrollPosition( 0 );
//}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "AuctionNextWnd" ).HideWindow();
}



//// ���� �ڵ� �޾ƿ���.
//var WindowHandle Me;
//var ButtonHandle BtnAuctionWndShowNext;
//var ButtonHandle BtnClose;
//var ItemWindowHandle AuctionItem;
//var TextBoxHandle txtItemDesc;
//var TextBoxHandle txtItemName;
//var WindowHandle areaScroll;
//var TextBoxHandle NextAuctionTime;


//function OnRegisterEvent()
//{
//	// �̺�Ʈ ��� 
//	RegisterEvent( EV_ITEM_AUCTION_NEXT_INFO );
//}

//function OnLoad()
//{
//	Initialize();
//}

//function OnShow()
//{
//	BtnAuctionWndShowNext.DisableWindow();
//}

//function Initialize()
//{
//	Me = GetWindowHandle( "NextAuctionDrawerWnd" );
//	BtnAuctionWndShowNext = GetButtonHandle( "AuctionWnd.BtnNextAuction" );
//	BtnClose = GetButtonHandle( "NextAuctionDrawerWnd.BtnClose" );
//	AuctionItem = GetItemWindowHandle ( "NextAuctionDrawerWnd.NextAuctionItem" );
//	txtItemDesc = GetTextBoxHandle( "NextAuctionDrawerWnd.scrollDesc.txtItemDesc" );
//	txtItemName = GetTextBoxHandle( "NextAuctionDrawerWnd.txtItemName" );
//	areaScroll = GetWindowHandle( "NextAuctionDrawerWnd.scrollDesc" );
//	NextAuctionTime = GetTextBoxHandle( "NextAuctionDrawerWnd.NextAuctionTime" );
//}

//function OnEvent(int Event_ID, string param)
//{
//	switch(Event_ID)
//	{
//	case EV_ITEM_AUCTION_NEXT_INFO:
//		HandleAuctionNextInfo(param);
//		break;
//	}
//}

//function HandleAuctionNextInfo(string param)
//{
//	local int startYear, startMon, startDay, startMin, startHour;
//	local int64 startPrice;
//	local ItemInfo info;
//	local ItemInfo curInfo;		//CT26P4

//	//debug("HandleAuctionNextInfo param = " $ param);
	
//	ParseInt(param, "startTimeYear", startYear);
//	ParseInt(param, "startTimeMonth", startMon);
//	ParseInt(param, "startTimeDay", startDay);
//	ParseInt(param, "startTimeHour", startHour);
//	ParseInt(param, "startTimeMinute", startMin);
//	ParseInt64(param, "startPrice", startPrice);
//	ParamToItemInfo( param, info );

//	//CT26P4
//	//�Ϲ� ��Ŷ�� Next ������ ���� �ͼ� ���ʸ��� �� �Լ��� �ҷ��� ���� ������ ����
//	//������ ������ �ٲ� ���� �Ʒ� �۾� �����ϵ��� ���� by enyheid
//	AuctionItem.GetItem(0, curInfo);

//	if (info.Id.ServerID != curInfo.Id.ServerID)
//	{
//		debug("====== " $ info.Id.ServerID $ "," $ curInfo.Id.ServerID );
//		AuctionItem.clear();
//		AuctionItem.AddItem( info );
//		AuctionItem.SetTooltipType( "Inventory");
		
//		txtItemName.setText( info.Name );
//		ComputeScrollHeight( info.Description );	//���̸� ������ش�. 
//		txtItemDesc.setText( info.Description );
//	}

//	if (startMin >= 10)
//	{
//		NextAuctionTime.SetText(startYear$"/"$startMon$"/"$startDay$"  "$startHour$":"$startMin);
//	}
	
//	else if ( startMin < 10 || startMin >= 0)
//	{
//		NextAuctionTime.SetText(startYear$"/"$startMon$"/"$startDay$"  "$startHour$":"$"0"$startMin);
//	}
//}

//function ComputeScrollHeight(string tempStr)
//{
//	local int nHeight;
//	local int nWidth;
	
//	local Rect rectWnd;
	
//	rectWnd = txtItemDesc.GetRect();
	
//	GetTextSizeDefault(tempStr, nWidth, nHeight);		// ����� �޾Ƽ�
	
//	areaScroll.SetScrollHeight((nHeight + 1) * (nWidth / rectWnd.nWidth + 1));
//	areaScroll.SetScrollPosition( 0 );
//}

//function OnClickButton( string Name )
//{
//	switch(Name)
//	{
//	case "BtnClose":
//		Me.HideWindow();
//		BtnAuctionWndShowNext.EnableWindow();
//		break;
//	}
//}

defaultproperties
{
}
