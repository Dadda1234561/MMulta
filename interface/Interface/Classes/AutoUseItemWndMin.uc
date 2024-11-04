/**
 * 
 *   �Ҹ�ǰ �ڵ� ���, �̴ϸ� ������ 
 * 
 **/
class AutoUseItemWndMin extends UICommonAPI;

var WindowHandle Me;
var AnimTextureHandle ToggleEffect_Anim;

var AutoUseItemWnd AutoUseItemWndScript;

// �ڵ�Ÿ��
var AnimTextureHandle AutoTargetToggleEffect_Anim;

function OnRegisterEvent()
{
	RegisterEvent(EV_StateChanged);
}

function OnShow()
{
//	getInstanceL2Util().syncWindowLoc("AutoUseItemWnd", getCurrentWindowName(string(Self)), 115, 56);
//	getInstanceL2Util().fixWindowLocOverResolution("AutoUseItemWndMin");
	
	if ( getInstanceUIData().getIsClassicServer() )
	{
		Me.HideWindow();
		return;
	}
	setPlayActiveAnim();
	setPlayAutoTargetActiveAnim();
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle("AutoUseItemWndMin");
	ToggleEffect_Anim = GetAnimTextureHandle("AutoUseItemWndMin.AutoAllON_Win.ToggleEffect_Anim" );
	AutoTargetToggleEffect_Anim = GetAnimTextureHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllON_Win.ToggleEffect_Anim" );
	AutoUseItemWndScript = AutoUseItemWnd(GetScript("AutoUseItemWnd"));
}

function Load()
{
}

function OnEvent(int Event_ID, string param)
{
	// End:0x15
	if(getInstanceUIData().getIsClassicServer())
	{
		return;
	}
	switch(Event_ID)
	{
		// End:0xA9
		case 3410:
			// End:0xA6
			if(param == "COLLECTIONSTATE")
			{
				// End:0xA6
				if(AutoUseItemWnd(GetScript("AutoUseItemWnd")).nMinimal == 1)
				{
					getInstanceL2Util().syncWindowLoc("AutoUseItemWndMin", "AutoUseItemWnd", -115, -98);
				}
			}
			// End:0xAC
			break;
	}	
}

function OnRButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	// ��ü ���� ���
	OnClickButton(a_WindowHandle.GetWindowName());
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "AutoAll_BTN":
			AutoUseItemWndScript.onClickButton("AutoAll_BTN");
			break;
		// �κ��丮 
		case "Inventory_Button":
			AutoUseItemWndScript.forceShowInven();
		// ū ������� ����
		case "WinExpandButton_Button":
			SetINIBool("AutoUseItemWnd", "l", false, "windowsInfo.ini");
			AutoUseItemWnd(GetScript("AutoUseItemWnd")).nMinimal = 0;
			Me.HideWindow();
			ShowWindowWithFocus("AutoUseItemWnd");
			getInstanceL2Util().syncWindowLoc("AutoUseItemWndMin", "AutoUseItemWnd", -115, -98);
			getInstanceL2Util().fixWindowLocOverResolution("AutoUseItemWnd");
			break;
		// ��ũ�� ���� ����
		case "MacroWnd_Button":
			ExecuteEvent(EV_MacroShowListWnd);
			SetINIBool("AutoUseItemWnd", "l", false, "windowsInfo.ini");
			Me.HideWindow();
			OnClickButton("WinExpandButton_Button");
			break;
		case "AutoTarget_AutoAll_BTN":	
			AutoUseItemWndScript.onClickButton("AutoTargetAll_BTN"); 
			//AutoUseItemWndScript.toggleAutoTargetWithMacroOnFF();
			break;
	}
}

// ������ �ڵ� ��� �ִ� 
function setPlayActiveAnim()
{
	if(!Me.IsShowWindow())
		return;
	if (AutoUseItemWndScript.getActivateAll())
	{
		AnimTexturePlay(ToggleEffect_Anim, true);
		GetWindowHandle("AutoUseItemWndMin.AutoAllON_Win").ShowWindow();
		GetWindowHandle("AutoUseItemWndMin.AutoAllOFF_Win").HideWindow();
	}
	else
	{
		AnimTextureStop(ToggleEffect_Anim, true);
		GetWindowHandle("AutoUseItemWndMin.AutoAllON_Win").HideWindow();
		GetWindowHandle("AutoUseItemWndMin.AutoAllOFF_Win").ShowWindow();
	}
}

function setPlayAutoTargetActiveAnim()
{
	if(!Me.IsShowWindow())
		return;

	//Debug("##### AutoUseItemWndScript.getUseAutoTarget(): " @ AutoUseItemWndScript.getUseAutoTarget());

	if (AutoUseItemWndScript.getUseAutoTarget())
	{
		AnimTexturePlay(AutoTargetToggleEffect_Anim, true);
		GetWindowHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllON_Win").ShowWindow();
		GetWindowHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllOFF_Win").HideWindow();
	}
	else
	{
		AnimTextureStop(AutoTargetToggleEffect_Anim, true);
		GetWindowHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllON_Win").HideWindow();
		GetWindowHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllOFF_Win").ShowWindow();
	}
}

function setShortcutTooltip(string tooltipStr)
{
	GetButtonHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTarget_AutoAll_BTN").SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(2165),getInstanceL2Util().White,,True,tooltipStr,getInstanceL2Util().BWhite,,True));
}

defaultproperties
{
}
