class WorldserverExitWnd extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;
var L2Util util;

function Initialize ()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	util = L2Util(GetScript("L2Util"));
}

function OnRegisterEvent ()
{
	RegisterEvent(EV_GamingStateEnter);
}

function OnLoad ()
{
	Initialize();
}

function OnEvent (int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_GamingStateEnter:
			if ( IsPlayerOnWorldRaidServer() )
			{
				if (getInstanceUIData().getIsClassicServer())
				{
					
				}
			}
			break;
	}
}

function OnTimer(int TimerID)
{
	
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "WorldserverExit_Btn":
			API_C_EX_RETURN_TO_ORIGIN();
			break;
	}
}

function API_C_EX_RETURN_TO_ORIGIN()
{
	local array<byte> stream;

	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RETURN_TO_ORIGIN, stream);
	Debug("C_EX_RETURN_TO_ORIGIN call 차원 사냥터 나가기");
}

function ClearAll ()
{
}

defaultproperties
{
}
