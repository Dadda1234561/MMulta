class CollectionSystemCategoryComponent extends UICommonAPI;

const STATE_SELECTED = 'stateSelected';
const STATE_NORMAL = 'stateNormal';

enum DOTTYPE
{
	non,
	canregist,
	notEnough,
	empty,
	Over,
	Max
};

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var ButtonHandle ItemBTN;
var TextBoxHandle buttonName;
var StatusBarHandle Progress;
var CollectionSystem collectionSystemScript;
var array<CollectionSystemStandComponent> collectionSystemStandComponentScripts;
var int Index;
var bool bOver;
var bool bDown;
var bool bSelected;
var TextureHandle Icon_Tex;
var TextureHandle TooltipTexture;
var DOTTYPE currentDotType;
var TextureHandle ItemInsufficient_Tex;
var TextureHandle ItemRegistration_Tex;
var TextureHandle ItemOverEnchant_Tex;
var Color selectedEmptyColor;

delegate DelegateOnButtonClick(string Name)
{

}

delegate DelegateOnOver()
{

}

function Initialize()
{
	util = L2Util(GetScript("L2Util"));
	collectionSystemScript = CollectionSystem(GetScript("collectionSystem"));
	buttonName = GetTextBoxHandle(m_WindowName $ ".buttonName_Txt");
	ItemBTN = GetButtonHandle(m_WindowName $ ".Item_Btn");
	Progress = GetStatusBarHandle(m_WindowName $ ".progress");
	Icon_Tex = GetTextureHandle(m_WindowName $ ".Icon_Tex");
	TooltipTexture = GetTextureHandle(m_WindowName $ ".TooltipTexture");
	ItemRegistration_Tex = GetTextureHandle(m_WindowName $ ".ItemRegistration_Tex");
	ItemInsufficient_Tex = GetTextureHandle(m_WindowName $ ".ItemInsufficient_Tex");
	ItemOverEnchant_Tex = GetTextureHandle(m_WindowName $ ".ItemOverEnchant_Tex");
	TooltipTexture.SetAlpha(0);
	selectedEmptyColor = GetColor(115, 85, 0, 255);
}

function Init(string WindowName, string _buttonName, int Category)
{
	m_WindowName = WindowName;
	Me = GetWindowHandle(m_WindowName);
	Index = Category - 1;
	Initialize();
	SetStandComponetScript(Category);
	Progress.SetDrawPoint(false);
	buttonName.SetText(_buttonName);
}

function SetStandComponetScript(int Category)
{
	local int i;

	// End:0x2E
	if(Category == collectionSystemScript.favoriteCategory)
	{
		collectionSystemStandComponentScripts = collectionSystemScript.collectionSystemStandComponentFavoriteScript;
		return;
	}

	for(i = 0; i < collectionSystemScript.collectionSystemStandComponentScripts.Length; i++)
	{
		// End:0x9B
		if(collectionSystemScript.collectionSystemStandComponentScripts[i].cMainData.Category == Category)
		{
			collectionSystemStandComponentScripts[collectionSystemStandComponentScripts.Length] = collectionSystemScript.collectionSystemStandComponentScripts[i];
		}
	}
}

event OnClickButton(string btnName)
{
	// End:0x0B
	if(bSelected)
	{
		return;
	}
	switch(btnName)
	{
		// End:0x41
		case "Item_Btn":
			bDown = false;
			collectionSystemScript.SetCurrentCategory(Index + 1);
			// End:0x44
			break;
	}
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	// End:0x0B
	if(bSelected)
	{
		return;
	}
	switch(a_WindowHandle)
	{
		// End:0x80
		case ItemBTN:
			bDown = true;
			Icon_Tex.SetTexture(("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index)) $ "_down");
			// End:0x83
			break;
	}
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	// End:0x0B
	if(bSelected)
	{
		return;
	}
	switch(a_WindowHandle)
	{
		// End:0x2B
		case ItemBTN:
			bDown = false;
			HandleBtnOut();
			// End:0x2E
			break;
	}
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	// End:0x0B
	if(bSelected)
	{
		return;
	}
	switch(a_WindowHandle)
	{
		case ItemBTN:
			HandleBtnOver();
			// End:0x26
			break;
	}
}

function SetSelecte()
{
	bSelected = true;
	bOver = false;
	bDown = false;
	Icon_Tex.SetTexture(("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index)) $ "_selected");
	ItemBTN.SetEnable(false);
	SetFontColor();
	HandleBtnOuts();
}

function HandleBtnOuts()
{
	local int i;

	// End:0x36 [Loop If]
	for(i = 0; i < collectionSystemStandComponentScripts.Length; i++)
	{
		collectionSystemStandComponentScripts[i].HandleBtnOut();
	}
}

function SetDeselecte()
{
	bSelected = false;
	ItemBTN.SetEnable(true);
	Icon_Tex.SetTexture("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index));
	SetFontColor();
}

function HandleBtnOver()
{
	// End:0x84
	if(collectionSystemScript.Me.IsShowWindow())
	{
		bOver = true;
		Icon_Tex.SetTexture("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index) $ "_over");
		HandleBtnOvers();
	}
}

function HandleBtnOvers()
{
	local int i;

	for(i = 0; i < collectionSystemStandComponentScripts.Length; i++)
	{
		collectionSystemStandComponentScripts[i].HandleBtnOver();
	}
}

function HandleBtnOut()
{
	// End:0x7B
	if(collectionSystemScript.Me.IsShowWindow())
	{
		bOver = false;
		Icon_Tex.SetTexture("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index));
		HandleBtnOuts();
	}
}

function SetBtnOver()
{
	// End:0xA0
	if((collectionSystemScript.Me.IsShowWindow() && ! bOver) && ! bSelected)
	{
		ItemBTN.SetEnable(false);
		Icon_Tex.SetTexture(("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index)) $ "_over");
	}
}

function SetBtnOut()
{
	// End:0x8A
	if(collectionSystemScript.Me.IsShowWindow() && ! bSelected)
	{
		ItemBTN.SetEnable(true);
		Icon_Tex.SetTexture("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index));
	}
}

function SetPoint(int Min, int Max)
{
	local string ToolTipString;

	Progress.SetPoint(Min, Max);
	ToolTipString = (string(int((float(Min) / float(Max)) * float(100))) $ "%") @ GetSystemString(898);
	ItemBTN.SetTooltipCustomType(MakeTooltipSimpleText(ToolTipString));
	TooltipTexture.SetTooltipCustomType(MakeTooltipSimpleText(ToolTipString));
}

function HideDot()
{
	currentDotType = non;
	Icon_Tex.SetColorModify(GetColor(255, 255, 255, 255));
	ItemRegistration_Tex.HideWindow();
	ItemInsufficient_Tex.HideWindow();
	ItemOverEnchant_Tex.HideWindow();
	SetFontColor();
}

function ShowDot(int Type)
{
	//currentDotType = DOTTYPE(Type);
	switch(currentDotType)
	{
		case DOTTYPE.non:
			HideDot();
			break;
		// End:0x65
		case DOTTYPE.canregist:
			Icon_Tex.SetColorModify(GetColor(255, 255, 255, 255));
			ItemRegistration_Tex.ShowWindow();
			ItemInsufficient_Tex.HideWindow();
			ItemOverEnchant_Tex.HideWindow();
			// End:0xEE
			break;
		// End:0xA8
		case DOTTYPE.notEnough:
			Icon_Tex.SetColorModify(GetColor(255, 255, 255, 255));
			ItemRegistration_Tex.HideWindow();
			ItemInsufficient_Tex.ShowWindow();
			ItemOverEnchant_Tex.HideWindow();
			// End:0xEE
			break;
		// End:0xEB
		case DOTTYPE.empty:
			Icon_Tex.SetColorModify(GetColor(80, 80, 80, 255));
			ItemRegistration_Tex.HideWindow();
			ItemInsufficient_Tex.HideWindow();
			ItemOverEnchant_Tex.HideWindow();
			// End:0xEE
			break;
		case DOTTYPE.Over/*4*/:
			Icon_Tex.SetColorModify(GetColor(255, 255, 255, 255));
			ItemRegistration_Tex.HideWindow();
			ItemInsufficient_Tex.HideWindow();
			ItemOverEnchant_Tex.ShowWindow();
			// End:0x16D
			break;
	}
	SetFontColor();
}

function SetFontColor()
{
	// End:0x51
	if(currentDotType == DOTTYPE.empty)
	{
		// End:0x30
		if(bSelected)
		{
			buttonName.SetTextColor(selectedEmptyColor);
		}
		else
		{
			buttonName.SetTextColor(getInstanceL2Util().DarkGray);
		}
	}
	else
	{
		// End:0x7B
		if(bSelected)
		{
			buttonName.SetTextColor(getInstanceL2Util().Yellow);
		}
		else
		{
			buttonName.SetTextColor(getInstanceL2Util().White);
		}
	}
}

defaultproperties
{
}
