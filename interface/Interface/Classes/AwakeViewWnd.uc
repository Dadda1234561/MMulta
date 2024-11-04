//------------------------------------------------------------------------------------------------------------------------
//
// ����        : AwakeViewWnd  ( ������ ���� ���̾�α� (Ŀ���� ��) ) - SCALEFORM UI - 
//
// linkage ���̾�α� ��� :
// 4�� ���� - ���� �Խ� ���̾�α� : AwakeNoticeDialog   
//------------------------------------------------------------------------------------------------------------------------
class AwakeViewWnd extends L2UIGFxScript;

//const DIALOGID_detailInform = 7893;
//var string Url;

function OnRegisterEvent()
{
	RegisterGFxEvent(EV_ChangeToAwakenedClass);
	//RegisterGFxEvent(EV_OptionHasApplied);
	//registerEvent( EV_DialogOK );
	//registerEvent( EV_DialogCancel );
}

function OnLoad()
{
	registerState( getCurrentWindowName(String(self)), "GamingState" );

	SetContainerWindow( WINDOWTYPE_DECO_NORMAL, 2491);
	AddState("GAMINGSTATE");	


	///registerState( "AwakeViewWnd", "GamingState" );
	//SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0, 0);

	//SetClosingOnESC();
}
/*

function OnShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
}

function OnHide()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}


function OnFlashLoaded()
{
	// empty
}
*/

function OnCallUCFunction( string funcName, string param )
{
	if (funcName == "1")
	{
		//Debug("���� �ϱ�! " @ param);
		RequestChangeToAwakenedClass(1);
	}
	else 
	{
		//Debug("���� ���Ѵ�! " @ param);
		RequestChangeToAwakenedClass(0);
	}
}

/*
function OnCallUCLogic( int logicID, string param )
{
	if (logicID == 1)
	{
		Debug("���� �ϱ�! " @ param);
		RequestChangeToAwakenedClass(1);
	}
	else 
	{
		Debug("���� ���Ѵ�! " @ param);
		RequestChangeToAwakenedClass(0);
	}
}*/

/*
function HandleDialogOK()
{	
	if( ! class'UICommonAPI'.static.DialogIsOwnedBy( string(Self) ) )
		return;

	switch( class'UICommonAPI'.static.DialogGetID() )
	{
	case DIALOGID_detailInform:
		OpenGivenURL( Url );
		break;
	}
}
*/

/*
// Class=139 ����..8��.
// 5480
// video/awake1.usm ������ �־����.
function OnEvent(int Event_ID, string param)
{	
	// GFX 
	//local array<GFxValue> args;
	//local GFxValue invokeResult;

	local int classID;
	local string LanguageType;

	switch ( Event_ID) {
		case EV_ChangeToAwakenedClass :
			ParseInt(param,"Class", classID);
			ParseString(param,"LanguageType", LanguageType);
			showAwakeFlashWindow(classID, LanguageType);
			break;	
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_DialogCancel:
			break;
	}
	/*
	// �ɼ��� ���ŵǾ��ٸ�..
	else if (Event_ID == EV_OptionHasApplied)
	{
		if (IsShowWindow())
		{
			// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
			AllocGFxValues(args, 2);		
			AllocGFxValue(invokeResult);

			// ������ �ؽ�Ʈ ����, �̺�Ʈ ��ȣ 1��
			args[0].SetInt(4);
				
			CreateObject(args[1]);

			// ��� ���� ���� 
			args[1].SetMemberInt    ("soundVolume"    , getAudioVolume()); 

			Invoke("_root.onEvent", args, invokeResult);

			DeallocGFxValue(invokeResult);
			DeallocGFxValues(args);
		}
	}
	*/
}
*/

/*
 *2013.10 Ŭ���� Ÿ���� �Ƹ�Ʈ�̾� ���� ���ǹ� �ϹǷ� Ŭ����ID�� Ÿ�� üũ
 *������ ����� ��� ���� �����Ƿ� �ּ� ó�� ��
 */
/*
function showAwakeFlashWindow(int classID, string LanguageType)
{		
	local array<GFxValue> args;

	local GFxValue invokeResult;

	//local string filePath;
	local int    classType;

	local string roleTypeString;
	local string className;

	local L2Util util;
	util = L2Util(GetScript("L2Util"));		
	
	//classType = getAwakeClassType(classID);
	
	//filePath = "../video/awake" $ string(classType) $ "" $ LanguageType $ ".usm";	

	roleTypeString = GetClassRoleName(classID) ;	

	className = GetClassType( classID );

	Url = GetSystemString( 2265 );

	// Debug("classType" @ classType);
	// Debug("file" @ filePath);

	if (classType > -1)
	{
		ShowWindow();
		
		// �Ҵ� 
		AllocGFxValues(args, 2);		
		AllocGFxValue(invokeResult);

		// �̺�Ʈ ��ȣ 1��
		args[0].SetInt(1);
			
		CreateObject(args[1]);
		
		// usm ������ ��� 
		//args[1].SetMemberString("filePath"  , filePath);
		
		// Ŭ���� Ÿ�� 
		//args[1].SetMemberInt   ("classType"     , classType);		
		args[1].SetMemberString("roleTypeString", roleTypeString);	
		args[1].SetMemberString("className"     , className);
		args[1].SetMemberInt   ("classID"       , classID);
		
		// ���� ��� 
		args[1].SetMemberInt    ("soundVolume", getAudioVolume()); 
		// args[1].SetMemberInt    ("soundVolume", 10); 
		
		Invoke("_root.onEvent", args, invokeResult);

		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);	
		
	}
	else
	{
		Debug("Error ���� ������ ��� ���� �߻� ClassID : " @ classID);
	}

}
*/

/*
function linkDetailInform()
{
	class'UICommonAPI'.static.DialogSetID( DIALOGID_detailInform );
	class'UICommonAPI'.static.DialogShow( DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage( 3208 ), string(Self));
}
*/


/*
/** 4�� ���� Ÿ�� ����  
 *  �׳� Ŭ���� id���� 147�� ���ְ� �־���... 
 *  */
function int getAwakeClassType(int classID)
{
	local int returnV;
	returnV = classID - 147;

	if ( returnV < 0 ) returnV = -1;

	// �ϵ� �ڵ� �κ� 
	/*
	switch(classID)
	{

		case 139 : returnV = 1; break;
		case 140 : returnV = 2; break;
		case 141 : returnV = 3; break;
		case 142 : returnV = 4; break;
		case 143 : returnV = 5; break;
		case 144 : returnV = 6; break;
		case 145 : returnV = 7; break;
		case 146 : returnV = 8; break;
		20120829 �Ʒ��� [GD30]  ����ȭ �� ���� > ���� 139 ~ 146 �� ����
		case 148 : returnV = 9; break;
		case 149 : returnV = 10; break;
		case 150 : returnV = 11; break;
		case 151 : returnV = 12; break;
		case 152 : returnV = 13; break;
		case 153 : returnV = 14; break;
		case 154 : returnV = 15; break;
		case 155 : returnV = 16; break;
		case 156 : returnV = 17; break;
		case 157 : returnV = 18; break;
		case 158 : returnV = 19; break;
		case 159 : returnV = 10; break;
		case 160 : returnV = 21; break;
		case 161 : returnV = 22; break;
		case 162 : returnV = 23; break;
		case 163 : returnV = 24; break;
		case 164 : returnV = 25; break;
		case 165 : returnV = 26; break;
		case 166 : returnV = 27; break;
		case 167 : returnV = 28; break;
		case 168 : returnV = 29; break;
		case 169 : returnV = 30; break;
		case 170 : returnV = 31; break;
		case 171 : returnV = 32; break;
		case 172 : returnV = 33; break;
		case 173 : returnV = 34; break;
		case 174 : returnV = 35; break;
		case 175 : returnV = 36; break;
		case 176 : returnV = 37; break;
		case 177 : returnV = 38; break;
		case 178 : returnV = 39; break;
		case 179 : returnV = 40; break;
		case 180 : returnV = 41; break;
		case 181 : returnV = 42; break;
	}*/
	return returnV;
}
*/

/*
/**
 *  ��� ���� ���� ���
 **/
function int getAudioVolume ()
{
	local int   iMusicVolume;
	local float fMusicVolume;
	local float fSoundVolume;
	
	fMusicVolume = GetOptionFloat( "Audio", "MusicVolume" );

	fSoundVolume = GetOptionFloat( "Audio", "SoundVolume" );
	
	if( 0.0f <= fMusicVolume && fMusicVolume < 0.2f )
		iMusicVolume=0;
	else if( 0.2f <= fMusicVolume && fMusicVolume < 0.4f )
		iMusicVolume=20;
	else if( 0.4f <= fMusicVolume && fMusicVolume < 0.6f )
		iMusicVolume=40;
	else if( 0.6f <= fMusicVolume && fMusicVolume < 0.8f )
		iMusicVolume=60;
	else if( 0.8f <= fMusicVolume && fMusicVolume < 1.0f )
		iMusicVolume=80;
	else if( 1.0f <= fMusicVolume )
		iMusicVolume=100;

	// ��ü ���尪�� 0�̸� �翬�� ��浵 0 ���� ���� 
	if(GetOptionFloat( "Audio", "SoundVolume" ) <= 0) iMusicVolume = 0;
	else iMusicVolume = ((fSoundVolume * 100) * iMusicVolume) / 100;

	// ��ü ���ҰŸ� üũ�� ���� 0 
	if (GetOptionBool( "Audio", "AudioMuteOn" )) iMusicVolume = 0;

	return iMusicVolume;
}
*/

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***
function OnReceivedCloseUI()
{
	local array<GFxValue> args;

	local GFxValue invokeResult;

	AllocGFxValues(args, 1);		
	
	Invoke("_root.onReceivedCloseUI", args, invokeResult);

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);	
	
}
*/

defaultproperties
{
}
