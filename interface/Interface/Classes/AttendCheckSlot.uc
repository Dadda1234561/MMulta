class AttendCheckSlot extends UICommonAPI
	dependson(AttendCheckWnd);

// јэАЪ ЕШЅєГД µЪїЎ 0~9 ±оБц Б¶ЗХЗПї© јэАЪё¦ ёёµл.
const DATE_TEXTURE_PATH = "L2UI_CT1.AttendCheckWnd.Attend_DateNum_";

var WindowHandle Me;
var AttendCheckWnd parentWnd;
var TextBoxHandle itemAmountTextBox;
var TextureHandle dayFirstTex;
var TextureHandle daySecondTex;
var TextureHandle checkedBgTex;
var TextureHandle highlightTex;
var TextureHandle stampTex;
var AnimTextureHandle availableAnimTex;
var AnimTextureHandle stampAnimTex;
var ItemWindowHandle itemWnd;
var WindowHandle disableContainer;
var AttendCheckWnd.AttendCheckStepInfo _info;

delegate DelegateOnItemClicked(AttendCheckSlot Owner);

function Init(WindowHandle Owner, AttendCheckWnd Parent)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	parentWnd = Parent;
	Me = GetWindowHandle(ownerFullPath);
	itemWnd = GetItemWindowHandle(ownerFullPath $ ".AttendMonth_ItemWindow");
	itemAmountTextBox = GetTextBoxHandle(ownerFullPath $ ".AttendDayCount_TextBox");
	daySecondTex = GetTextureHandle(ownerFullPath $ ".DateNum_Month_10_Texture");
	dayFirstTex = GetTextureHandle(ownerFullPath $ ".DateNum_Month_1_Texture");
	checkedBgTex = GetTextureHandle(ownerFullPath $ ".StampBG_Texture");
	highlightTex = GetTextureHandle(ownerFullPath $ ".SlotHighlight_Texture");
	stampTex = GetTextureHandle(ownerFullPath $ ".StampRed_Texture");
	availableAnimTex = GetAnimTextureHandle(ownerFullPath $ ".TodayTwinkle_AnimTex");
	stampAnimTex = GetAnimTextureHandle(ownerFullPath $ ".TodayStampRed_AnimText");
	disableContainer = GetWindowHandle(ownerFullPath $ ".Empty_Wnd");	
}

function SetInfo(AttendCheckWnd.AttendCheckStepInfo Info)
{
	_info = Info;
	SetDisable(false);
	SetItemInfoControl(Info.ItemID, Info.ItemAmount);
	SetDayTexture(Info.Day);
	SetSlotState(Info.State);
	SetSlotHighlightControl(Info.isHighLight);	
}

function SetDisable(bool bDisable)
{
	// End:0x39
	if(bDisable)
	{
		itemWnd.HideWindow();
		itemAmountTextBox.HideWindow();
		disableContainer.ShowWindow();		
	}
	else
	{
		itemWnd.ShowWindow();
		itemAmountTextBox.ShowWindow();
		disableContainer.HideWindow();
	}	
}

function SetItemInfoControl(int ItemID, INT64 ItemAmount)
{
	local ItemInfo ItemInfo;
	local string amountStr;

	ItemInfo = GetItemInfoByClassID(ItemID);
	// End:0x44
	if(IsStackableItem(ItemInfo.ConsumeType) && ItemAmount > 0)
	{
		ItemInfo.ItemNum = ItemAmount;
	}
	itemWnd.Clear();
	itemWnd.AddItem(ItemInfo);
	amountStr = "x" $ string(ItemAmount);
	// End:0x99
	if(ItemAmount == 0)
	{
		itemAmountTextBox.HideWindow();		
	}
	else
	{
		itemAmountTextBox.SetText(amountStr);
		itemAmountTextBox.ShowWindow();
	}	
}

function SetDayTexture(int Day)
{
	local string ten, one;

	StrDaySplit(Day, ten, one);
	dayFirstTex.SetTexture(DATE_TEXTURE_PATH $ ten);
	daySecondTex.SetTexture(DATE_TEXTURE_PATH $ one);	
}

function SetSlotHighlightControl(bool isHighLight)
{
	// End:0x1B
	if(isHighLight)
	{
		highlightTex.ShowWindow();		
	}
	else
	{
		highlightTex.HideWindow();
	}	
}

function SetSlotState(AttendCheckWnd.EAttendCheckState State)
{
	stampAnimTex.HideWindow();
	stampAnimTex.Stop();
	switch(State)
	{
		// End:0x72
		case Checked:
			checkedBgTex.ShowWindow();
			stampTex.ShowWindow();
			availableAnimTex.HideWindow();
			availableAnimTex.Stop();
			// End:0x132
			break;
		// End:0xE2
		case Available:
			checkedBgTex.HideWindow();
			stampTex.HideWindow();
			availableAnimTex.ShowWindow();
			availableAnimTex.Stop();
			availableAnimTex.SetLoopCount(99999);
			availableAnimTex.Play();
			// End:0x132
			break;
		// End:0x12F
		case Unchecked:
			checkedBgTex.HideWindow();
			stampTex.HideWindow();
			availableAnimTex.HideWindow();
			availableAnimTex.Stop();
			// End:0x132
			break;
	}	
}

function PlayStampAnimTexture()
{
	stampAnimTex.Stop();
	stampAnimTex.ShowWindow();
	stampAnimTex.Play();	
}

function StopAnimation()
{
	availableAnimTex.Stop();
	stampAnimTex.Stop();	
}

function CheckAndPlayStampAnimation()
{
	// End:0x67
	if(_info.State == Available)
	{
		PlayStampAnimTexture();
		stampTex.ShowWindow();
		availableAnimTex.HideWindow();
		availableAnimTex.Stop();
		_info.State = Checked;
	}
}

function StrDaySplit(int nDay, out string ten, out string one)
{
	// End:0x31
	if(nDay > 9)
	{
		ten = Mid(string(nDay), 0, 1);
		one = Mid(string(nDay), 1, 1);		
	}
	else
	{
		ten = "0";
		one = string(nDay);
	}	
}

event OnClickItem(string strID, int Index)
{
	// End:0x4D
	if(strID == "AttendMonth_ItemWindow" && _info.State == Available)
	{
		DelegateOnItemClicked(self);
	}
}

defaultproperties
{
}
