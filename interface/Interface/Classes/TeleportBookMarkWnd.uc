class TeleportBookMarkWnd extends UICommonAPI;

const TEMPLATEICONNAME = "L2ui_ct1.TeleportBookMark_DF_Icon_";

var WindowHandle Me;
var WindowHandle BookMarkEditWnd;
var TextBoxHandle txtTeleportLoc;
var ItemWindowHandle ItemBookMarkItem;
var TextBoxHandle txtSlotAvailability;
var TextBoxHandle txtSavedTeleportList;
var TextBoxHandle txtRequiredItemCount;
var ButtonHandle ItemDelete;
var ButtonHandle ItemEdit;
var ButtonHandle btnSaveMyLoc;
var TeleportBookMarkDrawerWnd m_Script;
var TextBoxHandle txtNoticeMessage;
var TextBoxHandle txtNoticeMessage2;
var TextureHandle TexDeactivated;


var ItemID	m_CurBookMarkItemID;
var ItemID  m_DeleteBookMarkItemID;
var int m_totalableSlotNum;

event OnShow()
{
	// End:0x3E
	if(class'UIDATA_PLAYER'.static.IsInPrison())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));
		Me.HideWindow();
		return;
	}
	if ( getInstanceL2Util().checkIsPrologueGrowType( string(self)) ) return;

	class'BookMarkAPI'.static.RequestBookMarkSlotInfo();
	class'BookMarkAPI'.static.RequestShowBookMark();
	GetTeleportItemCnt();
	Me.SetFocus();
}

function GetTeleportItemCnt()
{
	//debug ("GetTeleportBookMarkCount" @ GetTeleportBookMarkCount());
	txtSavedTeleportList.SetText(MakeFullSystemMsg(GetSystemMessage(2360), String(GetTeleportBookMarkCount()), ""));
}

event OnLoad()
{
	SetClosingOnESC();
	
	InitializeCOD();

	Load();
	txtNoticeMessage.ShowWindow();
	txtNoticeMessage2.ShowWindow();
	ClearItemID(m_CurBookMarkItemID);
	//~ SetUnActiveSlots();
	
	//~ txtNoticeMessage.HideWindow();
	//~ txtNoticeMessage2.HideWindow();
}

function InitializeCOD()
{
	Me = GetWindowHandle( "TeleportBookMarkWnd" );
	BookMarkEditWnd = GetWindowHandle( "TeleportBookMarkDrawerWnd" );
	txtTeleportLoc = GetTextBoxHandle( "TeleportBookMarkWnd.txtTeleportLoc" );
	ItemBookMarkItem = GetItemWindowHandle ( "TeleportBookMarkWnd.ItemBookMarkItem" );
	txtSlotAvailability = GetTextBoxHandle( "TeleportBookMarkWnd.txtSlotAvailability" );
	txtSavedTeleportList = GetTextBoxHandle( "TeleportBookMarkWnd.txtSavedTeleportList" );
	txtRequiredItemCount = GetTextBoxHandle( "TeleportBookMarkWnd.txtRequiredItemCount" );
	ItemDelete = GetButtonHandle ( "TeleportBookMarkWnd.ItemDelete" );
	ItemEdit = GetButtonHandle ( "TeleportBookMarkWnd.ItemEdit" );
	btnSaveMyLoc = GetButtonHandle ( "TeleportBookMarkWnd.btnSaveMyLoc" );
	TexDeactivated = GetTextureHandle ("TeleportBookMarkWnd.TexDeactivated");
	txtNoticeMessage = GetTextBoxHandle ("TeleportBookMarkWnd.txtNoticeMessage");
	txtNoticeMessage2 = GetTextBoxHandle ("TeleportBookMarkWnd.txtNoticeMessage2");
	m_Script = TeleportBookMarkDrawerWnd(GetScript("TeleportBookMarkDrawerWnd"));
}

event Load()
{
	ClearItemID(m_CurBookMarkItemID);
}

event OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_BookMarkList);
	RegisterEvent( EV_BookMarkShow );
	RegisterEvent( EV_BeginShowZoneTitleWnd );
	RegisterEvent( EV_SystemMessage );
}

event OnClickButton( string Name )
{
	switch( Name )
	{
		case "btnSaveMyLoc":
			OnbtnSaveMyLocClick();
			break;
	}
}

event OnEvent(int Event_ID, String param)
{
	local int 		SystemMsgIndex;
	if (Event_ID == EV_BookMarkList)
	{
		HandleBookMarkList(param);
	}	
	else if (Event_ID == EV_DialogOK )
	{
		if (DialogIsMine())
		{
			if (IsValidItemID(m_DeleteBookMarkItemID))
			{
				class'BookMarkAPI'.static.RequestDeleteBookMarkSlot(m_DeleteBookMarkItemID);			
				ClearItemID(m_DeleteBookMarkItemID);						
			}
		}
	}	
	else if (Event_ID == EV_BeginShowZoneTitleWnd)
	{
		GetTeleportItemCnt();
	}
	else if (Event_ID == EV_BookMarkShow)
	{
		OpenWindow();
	}
	else if (Event_ID == EV_SystemMessage)
	{
		ParseInt ( param, "Index", SystemMsgIndex );
		HandleUpdateItemCountSystemMessage(SystemMsgIndex);
	}
		
}

function HandleUpdateItemCountSystemMessage( int Index)
{
	switch(Index)
	{
		case 301:
		case 302:
		case 301:
		case 377:
			GetTeleportItemCnt();
			break;
	}
}

function OpenWindow()
{
	Me.ShowWindow();
	Me.SetFocus();
}

//Trash아이콘으로의 DropITem
event OnDropItem( string strID, ItemInfo formInfItem, int x, int y)
{	
	switch( strID )
	{
	case "ItemDelete":
		OnDeleteBookMarkSlot(formInfItem);
		break;
	case "ItemEdit":
		OnModifyBookMarkSlot(formInfItem);
		break;
	case "ItemBookMarkItem" :
		handleSwap (  formInfItem, x, y  ) ;
		break;
	}
}

event OnTick()
{
	Me.DisableTick();
	class'UIAPI_WINDOW'.static.HideWindow("MiniMapGfxWnd");
	GetWindowHandle("ActionWnd").HideWindow();	
}

function handleSwap ( ItemInfo formInfItem, int x, int y ) 
{
	local int toIndex, fromIndex;
	local ItemInfo toItemInfo;
	
	if ( formInfItem.DragSrcName  != "ItemBookMarkItem"  ) return;

	toIndex = ItemBookMarkItem.GetIndexAt( x, y, 1, 1 ); 

	if( toIndex >= 0 )
	{
		fromIndex = ItemBookMarkItem.FindItem(formInfItem.ID);
		if( toIndex != fromIndex )
		{
			ItemBookMarkItem.GetItem( toIndex,  toItemInfo) ;
			
			formInfItem.ID.classID =  fromIndex + 1 ; 
			toItemInfo.ID.classID = toIndex + 1 ;
			
			class'BookMarkAPI'.static.RequestChangeBookMarkSlot( formInfItem.ID, toItemInfo.ID ) ;
			//ItemBookMarkItem.SwapItems( fromIndex, toIndex );
		}
			
	}
}


function SetUnActiveSlots()
{
	//~ local int idx;
	//~ local ItemInfo ClearItem;
	//~ ClearItemID( ClearItem.ID );
	//~ ClearItem.IconName = "L2ui_ct1.ItemWindow_DF_SlotBox_Disable";
	
	//~ for(idx=0; idx<30; ++idx)
	//~ {
		//~ ItemBookMarkItem.AddItem(ClearItem);
	//~ }
	TexDeactivated.ShowWindow();
}

function HandleBookMarkList(string param)
{
	local int idx;	
	local int ableSlotNum;
	local int curSlotNum;
	//~ local int slotID, 
	local int iconID;
	local string strSlotTitle;
	local string strIconTitle;
	local ItemInfo infItem;
	local ItemInfo ClearItem;
	local int	 emptySlot;
	local vector loc;
	
	ClearItemID( ClearItem.ID );
	ClearItem.IconName = "L2ui_ct1.emptyBtn";
	Clear();
	ParseInt(param, "Count", ableSlotNum);
	curSlotNum = 0;
	m_totalableSlotNum = ableSlotNum;	

	if (ableSlotNum == 0)
	{
		txtNoticeMessage.ShowWindow();
		txtNoticeMessage2.ShowWindow();
		TexDeactivated.ShowWindow();
		SetUnActiveSlots();
	}
	else
	{
		txtNoticeMessage.HideWindow();
		txtNoticeMessage2.HideWindow();
		TexDeactivated.HideWindow();
	}
	
	for(idx=0; idx<ableSlotNum; ++idx)
	{
		strSlotTitle = "";
		strIconTitle = "";

		ParseInt(param, "EmptySlot_" $ idx, emptySlot);
		if (emptySlot == 1)
		{
			ItemBookMarkItem.AddItem(ClearItem);
		}
		else
		{
			ParseItemIDWithIndex(param, infItem.ID, idx);
			ParseString(param, "SlotName_" $ idx, strSlotTitle);
			ParseInt(param, "IconID_" $ idx, iconID);
			ParseString(param, "IconName_" $ idx, strIconTitle);
			ParseFloat(param,"XPos_" $ idx, loc.X);
			ParseFloat(param,"YPos_" $ idx, loc.Y);
			ParseFloat(param,"ZPos_" $ idx, loc.Z);
			 
	
			infItem.Name = strSlotTitle;
			infItem.AdditionalName = strIconTitle;
			infItem.IconName = TEMPLATEICONNAME $ itoStr(iconID);
			infItem.Description = strIconTitle;
			infItem.ShortcutType = int(EShortCutItemType.SCIT_BOOKMARK);
			
			ItemBookMarkItem.AddItem(infItem);
			curSlotNum++;
		}			
	}
	SetBookMarkCount(ableSlotNum, curSlotNum);
}

function OnDeleteBookMarkSlot(ItemInfo infItem)
{
	local string strMsg;
	
	if (infItem.ShortcutType != int(EShortCutItemType.SCIT_BOOKMARK))
		return;
		
	strMsg = MakeFullSystemMsg(GetSystemMessage(2362), infItem.Name, "");
	m_DeleteBookMarkItemID = infItem.ID;
	DialogShow(DialogModalType_Modalless,DialogType_Warning, strMsg, string(Self));
	
	
}

function OnModifyBookMarkSlot(ItemInfo infItem)
{

	local vector loc;
	//local TextBoxHandle txtTeleportBookMarkDrawerWndNameHead;
					
	m_Script.txtTeleportBookMarkDrawerWndNameHead.SetText(GetSystemString(1762));
	//txtTeleportBookMarkDrawerWndNameHead = TextBoxHandle(GetHandle("TeleportBookMarkDrawerWnd.txtTeleportBookMarkDrawerWndNameHead"));
	//txtTeleportBookMarkDrawerWndNameHead.SetText(GetSystemString(1762));

	if (infItem.ShortcutType != int(EShortCutItemType.SCIT_BOOKMARK))
		return;
	
	m_CurBookMarkItemID = infItem.ID;	
	//이름
	class'UIAPI_EDITBOX'.static.SetString( "TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkName", infItem.Name);
	//단축이름
	class'UIAPI_EDITBOX'.static.SetString( "TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkIcn", infItem.AdditionalName);
	
	class'BookMarkAPI'.static.RequestGetBookMarkPos(infItem.ID, loc);			
	
	m_Script.m_CurIconNum = Int(Right(infItem.IconName,2));
	m_Script.ItemBookMarkItem.SetSelectedNum( m_Script.m_CurIconNum -1 ) ;
	m_Script.UpdateIcon();

	if(!BookMarkEditWnd.IsShowWindow())
	{
		BookMarkEditWnd.ShowWindow();
		BookMarkEditWnd.SetFocus();
	}	
}


/* function OnModifyBookMarkSlotWithClick(ItemInfo infItem)
{

	local vector loc;
	local TextBoxHandle txtTeleportBookMarkDrawerWndNameHead;
	txtTeleportBookMarkDrawerWndNameHead = TextBoxHandle(GetHandle("TeleportBookMarkDrawerWnd.txtTeleportBookMarkDrawerWndNameHead"));
	m_CurBookMarkItemID = infItem.ID;	
	g
	class'UIAPI_EDITBOX'.static.SetString( "TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkName", infItem.Name);
	class'UIAPI_EDITBOX'.static.SetString( "TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkIcn", infItem.AdditionalName);
	
	class'BookMarkAPI'.static.RequestGetBookMarkPos(infItem.ID, loc);				
	
	m_Script.m_CurIconNum = Int(Right(infItem.IconName,1));
	m_Script.UpdateIcon();
	
	txtTeleportBookMarkDrawerWndNameHead.SetText(GetSystemString(1762));
	SetLocatorOnMiniMap(loc);
} */

function OnbtnSaveMyLocClick()
{	
	ClearItemID(m_CurBookMarkItemID);
	if ( BookMarkEditWnd.IsShowWindow())
	{
		BookMarkEditWnd.HideWindow();
	}
	else
	{		
		m_Script.InitializeUI();
		m_Script.UpdateCurrentLocation();
		BookMarkEditWnd.ShowWindow();
		ShowGFXYellowPin(GetPlayerPosition(), GetSystemString(887));
	}
	GetTeleportItemCnt();
}

event OnHide ()
{
	CallGFxFunction("MiniMapGfxWnd","TeleportBookMarkWnd_HidePosition","");
}

function Clear()
{
	ItemBookMarkItem.Clear();
}

//매크로의 클릭
event OnDBClickItem( string strID, int index )
{
	local ItemInfo 	infItem;
	
	if (strID == "ItemBookMarkItem" && index>-1)
	{
		if (ItemBookMarkItem.GetItem(index, infItem))
		{
			if (infItem.ID.ClassID > 0 )
				class'BookMarkAPI'.static.RequestTeleportBookMark(infItem.ID);
		}
	}
	GetTeleportItemCnt();
	// End:0x9F
	if(getInstanceUIData().getIsClassicServer())
	{
		Me.EnableTick();
		Me.HideWindow();
	}
}

event OnClickItem( string strID, int index )
{
	local ItemInfo 	infItem;
	local vector 	loc;
	if (strID == "ItemBookMarkItem" && index>-1)
	{
		if (ItemBookMarkItem.GetItem(index, infItem))
		{
			if (infItem.ID.ClassID > 0 )
			{								
				class'BookMarkAPI'.static.RequestGetBookMarkPos(infItem.ID, loc);
				ShowGFXYellowPin(Loc, infItem.Name);
			}
		}		
	}
	GetTeleportItemCnt();
}

function SetBookMarkCount(int ableSlotNum, int curSlotNum)
{
	txtSlotAvailability.SetText("(" $ string(curSlotNum) $ "/" $ string(ableslotNum) $ ")");
	//~ txtSavedTeleportList.SetText("");
}

function ShowGFXYellowPin (Vector XYZ, string TargetName)
{
	local string param;

	if( XYZ.X == 0 && XYZ.Y == 0 && XYZ.Z == 0 )
		return;

	param = "";
	ParamAdd(param,"X",string(XYZ.X));
	ParamAdd(param,"Y",string(XYZ.Y));
	ParamAdd(param,"Z",string(XYZ.Z));
	ParamAdd(param,"targetName",TargetName);
	ParamAdd(param,"questName","");
	CallGFxFunction("MiniMapGfxWnd","TeleportBookMarkWnd_ShowPoisition",param);
}

function AdjustToMyPosition ()
{
	CallGFxFunction("MiniMapGfxWnd","AdjustToMyPosition","0");
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "TeleportBookMarkWnd" ).HideWindow();
}

function string itoStr(int tmpNum){
	local string tmpStr;
	if(tmpNum<10){
		tmpStr = ("0"$string(tmpNum));
	} else 
	{		
		tmpStr = string(tmpNum);
	}	
	return tmpStr;
}

defaultproperties
{
}
