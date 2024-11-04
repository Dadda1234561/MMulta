//================================================================================
// FestivalRankingBonusWnd.
// emu-dev.ru
//================================================================================
class ViewPortCostumeWnd extends ViewPortWndBase;

function OnRegisterEvent()
{
	RegisterEvent(EV_ChangeCharacterPawn);
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_ChangeCharacterPawn:
			HandleChangeCharacterPawn(param);
			break;
	}
}

function OnShow()
{
	Debug("--------- viewport OnShow");
	//Me.BringToFront();
}

function InitializeCOD()
{
	Me = GetWindowHandle(m_WindowName);
	m_ObjectViewport = GetCharacterViewportWindowHandle(m_WindowName $ ".EffectStageWnd.ObjectViewport");
	m_ObjectViewport.SetSpawnDuration(0.2);
	m_ObjectViewport.SetDragRotationRate(300);
	Me.DisableWindow();
}

function HandleChangeCharacterPawn(string param)
{
	local int m_MeshType;

	Debug("HandleChangeCharacterPawn" @ param);
	ParseInt(param, "MeshType", m_MeshType);

	switch(m_MeshType)
	{
		case 0:
			// 휴먼_전사_남
			m_ObjectViewport.SetCharacterScale(0.95f);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 1:
			// 휴먼_전사_여
			m_ObjectViewport.SetCharacterScale(0.95f);
			m_ObjectViewport.SetCharacterOffsetX(-30);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			break;
		case 8:
			// 휴먼_법사_남
			m_ObjectViewport.SetCharacterScale(1f);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
		case 9:
			// 휴먼_법사_여
			m_ObjectViewport.SetCharacterScale(1f);
			m_ObjectViewport.SetCharacterOffsetX(-21);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
		case 6:
			// 엘프_전사_남
			m_ObjectViewport.SetCharacterScale(0.94f);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			break;
		case 7:
			// 엘프_전사_여
			m_ObjectViewport.SetCharacterScale(0.96f);
			m_ObjectViewport.SetCharacterOffsetX(-35);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
			// case q
			// 엘프_법사_남
			m_ObjectViewport.SetCharacterScale(0.94f);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			// 엘프_법사_여
			m_ObjectViewport.SetCharacterScale(0.96f);
			m_ObjectViewport.SetCharacterOffsetX(-35);
			m_ObjectViewport.SetCharacterOffsetY(-7);
		case 2:
			// 다엘_전사_남
			m_ObjectViewport.SetCharacterScale(0.97f);
			m_ObjectViewport.SetCharacterOffsetX(-10);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			break;
		case 3:
			// 다엘_전사_여
			m_ObjectViewport.SetCharacterScale(0.96f);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			break;
         // 다엘_법사_남
			m_ObjectViewport.SetCharacterScale(0.97f);
			m_ObjectViewport.SetCharacterOffsetX(-10);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			// 다엘_법사_여
			m_ObjectViewport.SetCharacterScale(0.96f);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-6);
		case 10:
			// 오크_전사_남
			m_ObjectViewport.SetCharacterScale(0.93f);
			m_ObjectViewport.SetCharacterOffsetX(-10);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
		case 11:
			// 오크_전사_여
			m_ObjectViewport.SetCharacterScale(0.93f);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
		case 12:
			// 오크_법사_남
			m_ObjectViewport.SetCharacterScale(0.93f);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
		case 13:
			// 오크_법사_여
			m_ObjectViewport.SetCharacterScale(0.91f);
			m_ObjectViewport.SetCharacterOffsetX(-30);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
		case 4:
			// 드워프_남
			m_ObjectViewport.SetCharacterScale(0.99f);
			m_ObjectViewport.SetCharacterOffsetX(-10);
			m_ObjectViewport.SetCharacterOffsetY(0);
			break;
		case 5:
			// 드워프_여
			m_ObjectViewport.SetCharacterScale(1f);
			m_ObjectViewport.SetCharacterOffsetX(-30);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 14:
			// 카마엘_남
			m_ObjectViewport.SetCharacterScale(0.93f);
			m_ObjectViewport.SetCharacterOffsetX(-25);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 15:
			// 카마엘_여
			m_ObjectViewport.SetCharacterScale(1.01f);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		case 17:
			// 아르테이어
			m_ObjectViewport.SetCharacterScale(1.015f);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(14);
			break;
	}
}

//테스트용 함수
function OnCallUCFunction(string functionName, string param)
{
	// Debug("sampe's onCallUCFunction" @ m_WindowName @ functionName @ param);
	switch(functionName)
	{
		// 이펙트를 교체
		case "SpawnEffect":
			m_ObjectViewport.SpawnEffect(param);
			//m_ObjectViewport.PlayAnimation(int(param));
			break;
		// 소환 된 몬스터 교체
		case "SpawnNPC":
			m_ObjectViewport.SpawnNPC();
			break;
		case "changeMonsterAnimation":
			m_ObjectViewport.PlayAnimation(int(param));
			break;
		case "StartRotation":
			m_ObjectViewport.StartRotation(bool(param)); //bRight
			break;
		case "EndRotation":
			m_ObjectViewport.EndRotation();
			break;
		case "StartZoom":
			m_ObjectViewport.StartZoom(bool(param)); //bOut
			break;
		case "EndZoom":
			m_ObjectViewport.EndZoom();
			break;
		case "SetCharacterScale":
			m_ObjectViewport.SetCharacterScale(float(param)); //fCharacterScale
			break;
		case "SetCharacterOffsetX":
			m_ObjectViewport.SetCharacterOffsetX(int(param)); //nOffsetX
			break;
		case "SetCharacterOffsetY":
			m_ObjectViewport.SetCharacterOffsetY(int(param)); //nOffsetY
			break;
		case "PlayAttackAnimation":
			m_ObjectViewport.PlayAttackAnimation(int(param)); //index
			break;
		case "AutoAttacking":
			m_ObjectViewport.AutoAttacking(bool(param)); //bAttack
			break;
		case "ShowNPC":
			m_ObjectViewport.ShowNPC(float(param)); //Duration
			break;
		case "HideNPC":
			m_ObjectViewport.HideNPC(float(param)); //Duration
			break;
		case "SetNPCInfo":
			m_ObjectViewport.SetNPCInfo(int(param)); //id
			break;
		case "SetDragRotationRate":
			m_ObjectViewport.SetDragRotationRate(int(param)); //nRotationRate
			break;
		case "SetCurrentRotation":
			m_ObjectViewport.SetCurrentRotation(int(param)); //nRotation
			break;
		case "SetCameraDistance":
			m_ObjectViewport.SetCameraDistance(int(param)); //nDist
			break;
		case "SetSpawnDuration":
			m_ObjectViewport.SetSpawnDuration(float(param)); //fDuration
			break;
		case "SpawnNPC":
			m_ObjectViewport.SpawnNPC();
			break;
		case "ApplyPreviewCostumeItem":
			Debug("ApplyPreviewCostumeItem" @ param);
			m_ObjectViewport.ApplyPreviewCostumeItem(int(param));
			break;
		case "SetBackgroundTex":
			m_ObjectViewport.SetBackgroundTex(param);
			break;
	}
	Me.BringToFront();
}

defaultproperties
{
}
