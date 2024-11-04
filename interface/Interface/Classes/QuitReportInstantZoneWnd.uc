//================================================================================
// QuitReportInstantZoneWnd.
//================================================================================

class QuitReportInstantZoneWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle PlayReportWnd;
var TextureHandle texQuitReportWnd_Groupbox1;
var TextureHandle texQuitReportWnd_Groupbox3;
var TextureHandle PlayReportWnd_Groupbox;
var TextBoxHandle txtPlayReportWnd_Title;
var TextBoxHandle txtPlayReportWnd_expHead;
var TextBoxHandle txtPlayReportWnd_adenaHead;
var TextBoxHandle txtPlayReportWnd_itemHead;
var TextBoxHandle txtPlayReportWnd_exp;
var TextBoxHandle txtPlayReportWnd_adena;
var TextBoxHandle txtPlayReportWnd_item;
var ButtonHandle ITEMButton_Right;
var ButtonHandle ITEMButton_Reset;
var ButtonHandle btnCancel;
var INT64 beforeExp;
var INT64 Exp;
var INT64 beforeAdena;
var INT64 Adena;
var bool firstSetting;
var bool firstAdenaSetting;
var array<ItemInfo> getItemInfoArray;
var L2Util util;
var InventoryWnd inventoryWndScript;
var QuitReportDrawerInstantZoneWnd QuitReportDrawerWndScript;
var UserInfo PlayerInfo;
var bool bGainStart;
const TIMER_ID= 999001;

function OnRegisterEvent ()
{
  RegisterEvent(EV_Restart);
  RegisterEvent(EV_UpdateUserInfo);
  RegisterEvent(EV_AdenaInvenCount);
  RegisterEvent(EV_ChangedSubjob);
}

function OnLoad ()
{
  SetClosingOnESC();
  Initialize();
}

function OnShow ()
{
  Me.SetFocus();
  UpdateUserInfoHandler();
}

function OnHide ()
{
  bGainStart = False;
}

function Initialize ()
{
  Me = GetWindowHandle("QuitReportInstantZoneWnd");
  texQuitReportWnd_Groupbox1 = GetTextureHandle("QuitReportInstantZoneWnd.texQuitReportWnd_Groupbox1");
  texQuitReportWnd_Groupbox3 = GetTextureHandle("QuitReportInstantZoneWnd.texQuitReportWnd_Groupbox3");
  PlayReportWnd_Groupbox = GetTextureHandle("QuitReportInstantZoneWnd.PlayReportWnd.PlayReportWnd_Groupbox");
  txtPlayReportWnd_Title = GetTextBoxHandle("QuitReportInstantZoneWnd.PlayReportWnd.txtPlayReportWnd_Title");
  txtPlayReportWnd_expHead = GetTextBoxHandle("QuitReportInstantZoneWnd.PlayReportWnd.txtPlayReportWnd_expHead");
  txtPlayReportWnd_adenaHead = GetTextBoxHandle("QuitReportInstantZoneWnd.PlayReportWnd.txtPlayReportWnd_adenaHead");
  txtPlayReportWnd_itemHead = GetTextBoxHandle("QuitReportInstantZoneWnd.PlayReportWnd.txtPlayReportWnd_itemHead");
  txtPlayReportWnd_item = GetTextBoxHandle("QuitReportInstantZoneWnd.PlayReportWnd.txtPlayReportWnd_item");
  txtPlayReportWnd_exp = GetTextBoxHandle("QuitReportInstantZoneWnd.PlayReportWnd.txtPlayReportWnd_exp");
  txtPlayReportWnd_adena = GetTextBoxHandle("QuitReportInstantZoneWnd.PlayReportWnd.txtPlayReportWnd_adena");
  ITEMButton_Right = GetButtonHandle("QuitReportInstantZoneWnd.PlayReportWnd.ITEMButton_Right");
  ITEMButton_Reset = GetButtonHandle("QuitReportInstantZoneWnd.PlayReportWnd.ITEMButton_Reset");
  btnCancel = GetButtonHandle("QuitReportInstantZoneWnd.BtnCancel");
  util = L2Util(GetScript("L2Util"));
  inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
  QuitReportDrawerWndScript = QuitReportDrawerInstantZoneWnd(GetScript("QuitReportDrawerInstantZoneWnd"));
  Init();
}

function Init ()
{
  beforeExp = 0;
  Exp = 0;
  Adena = 0;
  beforeAdena = GetAdena();
  firstSetting = False;
  firstAdenaSetting = False;
  txtPlayReportWnd_exp.SetText(MakeFullSystemMsg(GetSystemMessage(4323),"0"));
  txtPlayReportWnd_item.SetText(MakeFullSystemMsg(GetSystemMessage(1983),"0"));
  txtPlayReportWnd_adena.SetText(MakeFullSystemMsg(GetSystemMessage(2932),"0"));
  if ( GetWindowHandle("QuitReportDrawerInstantZoneWnd").IsShowWindow() )
  {
    setDrawerButtonState(True);
    GetWindowHandle("QuitReportDrawerInstantZoneWnd").HideWindow();
  }
}

function setDrawerButtonState (bool bShow)
{
  if ( bShow )
  {
    ITEMButton_Right.SetTexture("L2UI_CT1.Button.Button_DF_Right_Down","L2UI_CT1.Button.Button_DF_Right_Down","L2UI_CT1.Button.Button_DF_Right_Over");
  } else {
    ITEMButton_Right.SetTexture("L2UI_CT1.Button.Button_DF_Left_Down","L2UI_CT1.Button.Button_DF_Left_Down","L2UI_CT1.Button.Button_DF_Left_Over");
  }
}

function OnClickButton (string Name)
{
  switch (Name)
  {
    case "ITEMButton_Right":
    if (  !GetWindowHandle("QuitReportDrawerInstantZoneWnd").IsShowWindow() )
    {
      setDrawerButtonState(False);
      GetWindowHandle("QuitReportDrawerInstantZoneWnd").ShowWindow();
    } else {
      setDrawerButtonState(True);
      GetWindowHandle("QuitReportDrawerInstantZoneWnd").HideWindow();
    }
    break;
    case "ITEMButton_Reset":
    OnITEMButton_ResetClick();
    break;
    case "BtnCancel":
    OnbtnCancelClick();
    break;
    default:
  }
}

function InfoGainStart ()
{
  bGainStart = True;
  OnITEMButton_ResetClick();
}

function InfoGainResult ()
{
  bGainStart = False;
  Me.ShowWindow();
}

function OnITEMButton_ResetClick ()
{
  GetPlayerInfo(PlayerInfo);
  beforeExp = PlayerInfo.nCurExp;
  Exp = 0;
  Adena = 0;
  beforeAdena = GetAdena();
  firstSetting = True;
  firstAdenaSetting = True;
  QuitReportDrawerWndScript.Init();
  txtPlayReportWnd_exp.SetText(MakeFullSystemMsg(GetSystemMessage(4323),"0"));
  txtPlayReportWnd_item.SetText(MakeFullSystemMsg(GetSystemMessage(1983),"0"));
  txtPlayReportWnd_adena.SetText(MakeFullSystemMsg(GetSystemMessage(2932),"0"));
  if ( GetWindowHandle("QuitReportDrawerInstantZoneWnd").IsShowWindow() )
  {
    setDrawerButtonState(True);
    GetWindowHandle("QuitReportDrawerInstantZoneWnd").HideWindow();
  }
}

function OnbtnCancelClick ()
{
  Me.HideWindow();
}

function OnEvent (int a_EventID, string a_Param)
{
  local INT64 pAdena;

  if ( a_EventID == EV_AdenaInvenCount )
  {
    if (  !bGainStart )
    {
      return;
    }
    ParseINT64(a_Param,"Adena",pAdena);
    UpdateAdena(pAdena);
  } else {
    if ( a_EventID == EV_Restart )
    {
      Init();
      QuitReportDrawerWndScript.Init();
    } else {
      if ( a_EventID == EV_UpdateUserInfo )
      {
        if (  !bGainStart )
        {
          return;
        }
        UpdateUserInfoHandler();
      } else {
        if ( a_EventID == EV_ChangedSubjob )
        {
          firstSetting = False;
          beforeExp = 0;
          Exp = 0;
          txtPlayReportWnd_exp.SetText(MakeFullSystemMsg(GetSystemMessage(4323),"0"));
        }
      }
    }
  }
}

function addInzoneListItem (string inzoneName, string remainTimeStr)
{
  local LVDataRecord Record;

  Record.LVDataList.Length = 2;
  Record.LVDataList[0].szData = inzoneName;
  Record.LVDataList[1].szData = remainTimeStr;
}

function string setTimeString (int tmpTime)
{
  local string timeStr;
  local int timeHour;
  local int timeMin;

  if ( tmpTime < 60 )
  {
    timeStr = MakeFullSystemMsg(GetSystemMessage(3390),string(1));
    timeStr = MakeFullSystemMsg(GetSystemMessage(3408),timeStr);
  } else {
    if ( tmpTime < 3600 )
    {
      tmpTime = tmpTime / 60;
      timeStr = MakeFullSystemMsg(GetSystemMessage(3390),string(tmpTime));
    } else {
      timeHour = tmpTime / 3600;
      timeMin = (tmpTime - timeHour * 3600) / 60;
      if ( timeMin > 0 )
      {
        timeStr = MakeFullSystemMsg(GetSystemMessage(3406),string(timeHour)) @ MakeFullSystemMsg(GetSystemMessage(3390),string(timeMin));
      } else {
        timeStr = MakeFullSystemMsg(GetSystemMessage(3406),string(timeHour));
      }
    }
  }
  return timeStr;
}

function UpdateAdena(INT64 pAdena)
{
	if(firstAdenaSetting == false)
	{
		Adena = 0;
		beforeAdena = pAdena;
		firstAdenaSetting = true;
	}
	if(pAdena > beforeAdena)
	{
		Adena = Adena + (pAdena - beforeAdena);
	}
	beforeAdena = pAdena;
	if(Adena > 0)
	{
		txtPlayReportWnd_adena.SetText(MakeFullSystemMsg(GetSystemMessage(2932), MakeCostString(string(Adena))));
	}
	else
	{
		txtPlayReportWnd_adena.SetText(MakeFullSystemMsg(GetSystemMessage(2932), "0"));
	}
}

function UpdateUserInfoHandler()
{
	local INT64 ItemCount;

	if(GetGameStateName() != "GAMINGSTATE")
		return;

	GetPlayerInfo(PlayerInfo);

	if(firstSetting == false)
	{
		firstSetting = true;
		beforeExp = PlayerInfo.nCurExp;
		Exp = 0;

		if(Me.IsShowWindow())
		{
			if(Exp > 0)
			{
				txtPlayReportWnd_exp.SetText(MakeFullSystemMsg(GetSystemMessage(4323), MakeCostString(string(Exp))));
			}
			else
			{
				txtPlayReportWnd_exp.SetText(MakeFullSystemMsg(GetSystemMessage(4323), "0"));
			}
		}
	}

	if(PlayerInfo.nCurExp > beforeExp)
	{
		Exp = Exp + (PlayerInfo.nCurExp - beforeExp);
	}
	beforeExp = PlayerInfo.nCurExp;

	if(Me.IsShowWindow())
	{
		ItemCount = int64(QuitReportDrawerWndScript.getTotalItemCount());

		if(Exp > 0)
		{
			txtPlayReportWnd_exp.SetText(MakeFullSystemMsg(GetSystemMessage(4323), MakeCostString(string(Exp))));
		}
		else
		{
			txtPlayReportWnd_exp.SetText(MakeFullSystemMsg(GetSystemMessage(4323), "0"));
		}

		if(ItemCount > 0)
		{
			txtPlayReportWnd_item.SetText(MakeFullSystemMsg(GetSystemMessage(1983), MakeCostString(string(ItemCount))));
		}
		else
		{
			txtPlayReportWnd_item.SetText(MakeFullSystemMsg(GetSystemMessage(1983), "0"));
		}
	}
}

function OnTimer (int TimerID)
{
  if ( TimerID == TIMER_ID )
  {
    beforeAdena = GetAdena();
    Me.KillTimer(TIMER_ID);
  }
}

function externalAddItem (ItemInfo addItemInfo)
{
  if (  !bGainStart )
  {
    return;
  }
  QuitReportDrawerWndScript.externalAddItem(addItemInfo);
}

function OnReceivedCloseUI ()
{
  PlayConsoleSound(IFST_WINDOW_CLOSE);
  GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
