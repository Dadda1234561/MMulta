//------------------------------------------------------------------------------------------------------------------------
//
// ¡¶∏Ò         : ¿Œ∞‘¿”ò?- SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class FactionWnd extends L2UIGFxScript;

const TYPE_FACTION_START_NPC = 2;

function OnRegisterEvent()
{	
	// 10080
	registerGfxEvent( EV_FactionInfo );		
	registerGfxEvent( EV_FactionInfoRewardIcon );	
}

function OnLoad()
{
	AddState( "GAMINGSTATE" );
	SetContainerWindow(WINDOWTYPE_DECO_NORMAL, 3443);
}

function OnHide()
{	
}

function OnShow()
{
}

// Ω√¿€ NPC ¿ßƒ° æ∆¿Ãƒ‹ ∏∏µÈ±‚
function MinimapRegionInfo makeRegionInfo( string tooltipString,  Vector pLoc )
{
	local MinimapRegionInfo regionInfoForMapIcon;
	local MinimapRegionIconData iconData;
	local string toolTipParam;

	toolTipParam = "";
	ParamAdd(toolTipParam, "tooltipString", tooltipString);
	ParamAdd(toolTipParam, "Type", String ( int ( EMinimapRegionType.MRT_Etc )));
	regionInfoForMapIcon.strTooltip = toolTipParam;

	regionInfoForMapIcon.eType = EMinimapRegionType.MRT_Etc;
	regionInfoForMapIcon.nIndex = TYPE_FACTION_START_NPC; //huntingZoneData.nSearchZoneID;
	//regionInfoForMapIcon.strDesc = tooltipString;

	iconData.nWidth = 32;
	iconData.nHeight = 32;
	iconData.nWorldLocX = pLoc.x;// - iconData.nIconOffsetX; // 3197;  // - 3197 ¿∫ ±‚»π(¡∂¡ﬂ∞Ô), 16«»ºøø° «ÿ¥Á«œ¥¬∞™.
	iconData.nWorldLocY = pLoc.y;// - iconData.nIconOffsetY; // 3197;
	iconData.nWorldLocZ = pLoc.z;
	iconData.nIconOffsetX = -3;
    iconData.nIconOffsetY = -20;

	iconData.strIconNormal = "L2UI_CT1.Minimap.Minimap_DF_Icon_Pin_Campaign_Over";
	iconData.strIconOver   = "L2UI_CT1.Minimap.Minimap_DF_Icon_Pin_Campaign";
	iconData.strIconPushed = "L2UI_CT1.Minimap.Minimap_DF_Icon_Pin_Campaign_Over";		

	regionInfoForMapIcon.iconData = IconData ;
	return regionInfoForMapIcon ;
}

defaultproperties
{
}
