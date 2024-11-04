//------------------------------------------------------------------------------------------------------------------------
//
// 제목        : gfxDialog  ( 스케일 폼용 다이얼로그 (커스텀 등) ) - SCALEFORM UI - 
//
// linkage 다이얼로그 목록 :
// 4차 전직 - 각성 게시 다이얼로그 : Gfx 스크린 메시지 SetRenderOnTop를 사용하지 않는 중간 뎁스 용이다.
// SetAlwaysOnTop(true) 로 
//------------------------------------------------------------------------------------------------------------------------
class GfxScreenMessageBG extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent( EV_GFxScrMessage );
	RegisterGFxEvent( EV_HtmlWithNPCViewport );
	RegisterGFxEvent( EV_HtmlWithNPCViewportClose );
	//RegisterEvent( EV_GFxScrMessage );

	//RegisterEvent( EV_Test_2 );
}

function OnLoad()
{	
//	registerState( getCurrentWindowName(String(self)), "GAMINGSTATE" );	
	registerState( getCurrentWindowName(String(self)), "ARENAPICKSTATE" );	
	registerState( getCurrentWindowName(String(self)), "ARENAGAMINGSTATE" );	
	registerState( getCurrentWindowName(String(self)), "ARENABATTLESTATE" );		
//	registerState( getCurrentWindowName(String(self)), "OLYMPIADOBSERVERSTATE" );
	//항상 위에
	//
	//항상 보임
	SetDefaultShow (true) ;
	//반투명 없음
	SetAlwaysFullAlpha(true);
	//포커스 잡지 않음
	//
	SetAlwaysOnTop(true);
	//클릭 되지 않음.
	//SetMsgPassThrough(true);

	setHUD();
	
	
}

function OnFlashLoaded()
{
	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0 , 0);	
	//SetHavingFocus( false );
	//항상 상위에 그리도록 함.
	//SetRenderOnTop(true);
	//SetAlwaysFullAlpha(true);
	//IgnoreUIEvent(true);
	//SetAlwaysOnTop(true);
	//Debug ("OnFlashLoaded" @ getCurrentWindowName(String(self)));
}


function onEvent ( int ID, string param )
{
	//local L2Util util;
	//util = L2Util( GetScript( "L2Util"));
	//util.showGfxScreenMessage( "Msg는 인체에 해가 없다고 합니다." ) ;
	local string label;
	local string labelIndex;
	local string motionType;
	local string useSystemMessage;
	local string delay;
	local string locY;

	switch ( ID ) 
	{
		// event 번호 : 12
		// Msg=1 type=3 label=round labelIndex=3 motionType=1 delay=0.1 locY=55
		case EV_Test_2 :
			ParseString(param, "label", label);
			ParseString(param, "labelIndex", labelIndex);
			ParseString(param, "motionType", motionType);
			ParseString(param, "delay", delay);
			ParseString(param, "locY", locY);
			
			ParseString(param, "useSystemMessage", useSystemMessage);

			if (useSystemMessage == "1")
			{
				
				AddSystemMessage(int(labelIndex));
			}
			else
			{
				showTestGfxScreenMessage(label, labelIndex, motionType, delay, locY);
			}
			break;
	}
}


/*
 *  Gfx 스크린 메시지 
 *
 */
function showTestGfxScreenMessage ( string label, optional string labelIndex, optional string motionType, optional string delay , optional string locY) 
{
	local string strParam;

	strParam = "";

	ParamAdd(strParam, "Msg", "1");
	ParamAdd(strParam, "type", string(getInstanceL2Util().EGfxScreenMsgType.MSGType_Matching));
	
	ParamAdd(strParam, "label", label );
	ParamAdd(strParam, "labelIndex", labelIndex );
	ParamAdd(strParam, "motionType", motionType );	
	ParamAdd(strParam, "delay", delay );	
	ParamAdd(strParam, "locY", locY );	
	CallGFxFunction ( "GfxScreenMessageBG" , "showMessage", strParam );
}

defaultproperties
{
}
