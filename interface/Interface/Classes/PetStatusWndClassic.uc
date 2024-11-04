class PetStatusWndClassic extends PetStatusWnd;

function OnLoad()
{
	InitializeCOD();
	Load();
}

function OnRegisterEvent()
{
	Super.OnRegisterEvent();
	RegisterEvent(EV_PetAcquireSkillAlarm);
	RegisterEvent(EV_GameStart);
}

function OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().getIsClassicServer())
	{
		if (Event_ID == EV_PetAcquireSkillAlarm)
		{
			AnimTexturePlay(GetAnimTextureHandle("PetStatusWndClassic.btnPetWndClassic_AnimTex"), true, 9999999);
		}
		if (Event_ID == EV_GameStart)
		{
			GetAnimTextureHandle("PetStatusWndClassic.btnPetWndClassic_AnimTex").HideWindow();
		}
		else
		{
			EachServerEvent(Event_ID, param);
		}
	}
}

function OnMouseOver(WindowHandle W)
{
	if (W.GetWindowName() == "btnPetWndClassic")
	{
		GetAnimTextureHandle("PetStatusWndClassic.btnPetWndClassic_AnimTex").HideWindow();
	}
}

function OnEnterState(name a_CurrentStateName)
{
	if (getInstanceUIData().getIsClassicServer())
	{
		EachServerEnterState(a_CurrentStateName);
	}
}

function OnClickButton (string strID)
{
	switch (strID)
	{
		case "btnBuff":
			OnBuffButton();
			break;
		case "btnPetWndClassic":
			TogglePetWndClassic();
			break;
	}
}

function OnHide()
{
	Super.OnHide();
	GetWindowHandle(m_WindowName $ ".AutoPotionSubWndPet").HideWindow();
}

function TogglePetWndClassic()
{
	local WindowHandle petWndClassicWnd;

	petWndClassicWnd = GetWindowHandle("PetWndClassic");
	if (petWndClassicWnd.IsShowWindow())
	{
		petWndClassicWnd.HideWindow();
	}
	else
	{
		petWndClassicWnd.ShowWindow();
		petWndClassicWnd.SetFocus();
	}
}

function SetBuffButtonTooltip()
{
	local Color b1;
	local Color b2;
	local Color b3;
	local Color b4;
	local array<DrawItemInfo> drawListArr;

	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	b4 = getInstanceL2Util().Gray;
	if(m_CurBf == 0)
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off");
	}
	else
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf), "L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf), "L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf));
	}
	switch(m_CurBf)
	{
		case 0:
			break;
		case 1:
			b1 = getInstanceL2Util().Yellow;
			break;
		case 2:
			b2 = getInstanceL2Util().Yellow;
			break;
		case 3:
			b3 = getInstanceL2Util().Yellow;
			break;
		case 4:
			b4 = getInstanceL2Util().Yellow;
			break;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1496) $ "/" $ GetSystemString(1497),b1,"", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1741), b2,"", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13440), b3,"", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2307), b4,"", true, true);
	btnBuff.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y);

defaultproperties
{
     MAX_BUFF_ICONTYPE=4
     m_WindowName="PetStatusWndClassic"
}
