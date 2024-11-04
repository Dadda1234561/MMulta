class LocalStorageEX extends L2UIGFxScript;

var WindowHandle Me;
var array<string> DebugArray;

static function LocalStorageEX Inst()
{
  return LocalStorageEX(GetScript("LocalStorageEX"));
}

event OnLoad()
{
    Initialize();
}

function Initialize()
{
  Me = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath);
  SetContainerHUD("none",0);
}

function bool GetLevelInfo (out LevelInfo outLevelInfo)
{
  outLevelInfo = LevelInfo(FindObject(getCurrentMapSquareText() $ "_Classic.LevelInfo0", None));
  if ( outLevelInfo == None ) {
    outLevelInfo = LevelInfo(FindObject(getCurrentMapSquareText() $ ".LevelInfo0", None));
  }
  if ( outLevelInfo == None ) {
    return False;
  } 
  else {
    return True;
  }
}

function bool RenewCurentPlayerController (out PlayerController hPlayerController)
{
  local LevelInfo LocalLevelInfo;
  local GameInfo GInfo;
  local PlayerController PC;

  if ( !GetLevelInfo(LocalLevelInfo) ) {
    return False;
  }

  foreach LocalLevelInfo.RadiusActors(class'GameInfo', GInfo, float(10000)) {
    foreach GInfo.DynamicActors(class'PlayerController', PC) {
      if ( Viewport(PC.Player) != None ) {
        hPlayerController = PC;
        return True;
      }
    }
  }

  return False;
}

function string getCurrentMapSquareText ()
{
  local string outputString;
  local int mapX;
  local int mapY;
  local UserInfo UI;

  GetPlayerInfo(UI);
  
  mapX = int((327680 + UI.loc.X)) / 32768 + 10;
  mapY = int((262144 + UI.loc.Y)) / 32768 + 10;
  outputString = string(mapX) $ "_" $ string(mapY);
  return outputString;
}

