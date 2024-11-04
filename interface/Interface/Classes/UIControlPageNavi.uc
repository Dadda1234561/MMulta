class UIControlPageNavi extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var TextBoxHandle currPageText;
var TextBoxHandle nextPageText;
var TextBoxHandle dividPageText;
var ButtonHandle NextBtn;
var ButtonHandle PrevBtn;
var ButtonHandle nextMaxBtn;
var ButtonHandle prevMaxBtn;
var ButtonHandle EmptyBtn;
var int TotalPage;
var int currPage;
var bool bDisabled;
var bool bUseMax;
var bool bNoUseGo;

delegate DelegeOnChangePage(int Page)
{
}

delegate DelegateOnClickButton(string strName)
{
}

static function UIControlPageNavi InitScript(WindowHandle wnd)
{
	local UIControlPageNavi scr;

	wnd.SetScript("UIControlPageNavi");
	scr = UIControlPageNavi(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	Init(m_hOwnerWnd.m_WindowNameWithFullPath);
}

function Init(string WindowName)
{
	m_WindowName = WindowName;
	Me = GetWindowHandle(m_WindowName);
	currPageText = GetTextBoxHandle(m_WindowName $ ".ControlNavi_currPageText");
	nextPageText = GetTextBoxHandle(m_WindowName $ ".ControlNavi_nextPageText");
	dividPageText = GetTextBoxHandle(m_WindowName $ ".ControlNavi_dividPageText");
	NextBtn = GetButtonHandle(m_WindowName $ ".ControlNavi_nextBtn");
	PrevBtn = GetButtonHandle(m_WindowName $ ".ControlNavi_prevBtn");
	if(bUseMax)
	{
		nextMaxBtn = GetButtonHandle(m_WindowName $ ".ControlNavi_nextMaxBtn");
		prevMaxBtn = GetButtonHandle(m_WindowName $ ".ControlNavi_prevMaxBtn");
	}
	currPage = -1;
	SetDisable(false);
}

function OnClickButton(string Name)
{
	DelegateOnClickButton(Name);
	switch(Name)
	{
		case "ControlNavi_nextBtn":
			// End:0x48
			if(bNoUseGo == false)
			{
				Go(currPage + 1);
			}
			break;
		case "ControlNavi_prevBtn":
			// End:0x7D
			if(bNoUseGo == false)
			{
				Go(currPage - 1);
			}
			break;
		case "ControlNavi_nextMaxBtn":
			Go(TotalPage);
			break;
		case "ControlNavi_prevMaxBtn":
			Go(1);
			break;
	}
}

function SetDisable(bool bDisable)
{
	local Color tmpColor, currTmpColor;

	bDisabled = bDisable;
	if(bDisabled)
	{
		tmpColor = GetColor(153, 153, 153, 255);
		currTmpColor = tmpColor;		
	}
	else
	{
		tmpColor = GetColor(189, 189, 189, 255);
		currTmpColor = getInstanceL2Util().Yellow;
	}
	BtnCheck();
	currPageText.SetTextColor(currTmpColor);
	nextPageText.SetTextColor(tmpColor);
	dividPageText.SetTextColor(tmpColor);
}

function SetNoUseGo(bool bNoUseGoP)
{
	bNoUseGo = bNoUseGoP;	
}

function Go(int Page)
{
	if(Page <= 1)
	{
		Page = 1;
	}
	if(Page > TotalPage)
	{
		Page = TotalPage;
	}
	if(Page == currPage)
	{
		return;
	}
	currPage = Page;
	BtnCheck();
	currPageText.SetText(string(currPage));
	if(currPage != -1)
	{
		DelegeOnChangePage(currPage);
	}
}

function setPageText(int Page)
{
	// End:0x12
	if(Page <= 1)
	{
		Page = 1;
	}
	// End:0x2C
	if(Page > TotalPage)
	{
		Page = TotalPage;
	}
	currPage = Page;
	BtnCheck();
	currPageText.SetText(string(currPage));	
}

function SetTotalPage(int Page)
{
	TotalPage = Page;
	if(Page > TotalPage)
	{
		Page = TotalPage;
		Go(Page);
	}
	nextPageText.SetText(string(Page));
}

function int GetPage()
{
	return currPage;
}

function int GetTotalPage()
{
	return TotalPage;
}

function bool IsDisalbed()
{
	return bDisabled;
}

function BtnCheck()
{
	// End:0x51
	if(bDisabled)
	{
		PrevBtn.DisableWindow();
		NextBtn.DisableWindow();
		// End:0x4E
		if(bUseMax)
		{
			nextMaxBtn.DisableWindow();
			prevMaxBtn.DisableWindow();
		}		
	}
	else
	{
		// End:0x86
		if(currPage == 1)
		{
			PrevBtn.DisableWindow();
			// End:0x83
			if(bUseMax)
			{
				prevMaxBtn.DisableWindow();
			}			
		}
		else
		{
			PrevBtn.EnableWindow();
			// End:0xAD
			if(bUseMax)
			{
				prevMaxBtn.EnableWindow();
			}
		}
		// End:0xE6
		if(currPage == TotalPage)
		{
			NextBtn.DisableWindow();
			// End:0xE3
			if(bUseMax)
			{
				nextMaxBtn.DisableWindow();
			}			
		}
		else
		{
			NextBtn.EnableWindow();
			// End:0x10D
			if(bUseMax)
			{
				nextMaxBtn.EnableWindow();
			}
		}
	}
}

function string Int2Str2(int i)
{
	// End:0x19
	if(i < 10)
	{
		return "0" $ string(i);
	}
	return string(i);
}

defaultproperties
{
}
