class HomunculusWndMainListItem extends UICommonAPI;

enum type_State 
{
	Lock,
	NOTACTIVE,
	READY,
	Normal
};

var WindowHandle Me;
var string m_WindowName;
var int Index;
var ButtonHandle mainBtn;
var TextBoxHandle text0;
var AnimTextureHandle texGrade;
var TextureHandle texGradepanel;
var TextureHandle texNew;
var AnimTextureHandle texCommunion;
var TextureHandle texMonster;
var WindowHandle conditionWnd;
var HomunculusWndMainList homunculusWndMainListScript;
var HomunculusWnd HomunculusWndScript;
var HomunculusAPI.HomunculusData currHomunculusData;
var bool Selected;
var bool Enable;
var type_State currState;

function Initialize ()
{
	homunculusWndMainListScript = HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	mainBtn = GetButtonHandle(m_WindowName $ ".mainBtn");
	text0 = GetTextBoxHandle(m_WindowName $ ".text0");
	texGrade = GetAnimTextureHandle(m_WindowName $ ".texGrade");
	texGradepanel = GetTextureHandle(m_WindowName $ ".texGradepanel");
	texNew = GetTextureHandle(m_WindowName $ ".texNew");
	texMonster = GetTextureHandle(m_WindowName $ ".texMonster");
	texCommunion = GetAnimTextureHandle(m_WindowName $ ".texCommunion");
	conditionWnd = GetWindowHandle(m_WindowName $ ".conditionWnd");
}

function Init (string WindowName)
{
	m_WindowName = WindowName;
	Me = GetWindowHandle(m_WindowName);
	Index = int(Right(m_WindowName, 1));
	Initialize();
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "MainBtn":
			if ( !Enable )
			{
				return;
			}
			homunculusWndMainListScript.HandleListItemClicked(Index);
			if ( currHomunculusData.IsNew )
			{
				SetNew(false);
			}
			break;
	}
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	// End:0x29
	if(Selected)
	{
		SetNew(false);
		homunculusWndMainListScript.RemNew(currHomunculusData.idx);
	}
}

function SetLevel (int L)
{
	text0.SetText(GetSystemString(88) @ string(L));
}

function SetGrade (int G)
{
	texGrade.Stop();
	switch (G)
	{
		case 0:
			texGradepanel.SetTexture("L2UI_EPIC.HomunCulusWnd.Homun_CubeGrade01");
			texGrade.SetTexture("L2UI_EPIC.HomunCulusWndAni.Grade01Ani_0000");
			texGrade.ShowWindow();
			texGrade.SetLoopCount(99999);
			texGrade.Play();
			texGradepanel.ShowWindow();
			break;
		case 1:
			texGradepanel.SetTexture("L2UI_EPIC.HomunCulusWnd.Homun_CubeGrade02");
			texGrade.SetTexture("L2UI_EPIC.HomunCulusWndAni.Grade02Ani_0000");
			texGrade.ShowWindow();
			texGrade.SetLoopCount(99999);
			texGrade.Play();
			texGradepanel.ShowWindow();
			break;
		case 2:
			texGradepanel.SetTexture("L2UI_EPIC.HomunCulusWnd.Homun_CubeGrade03");
			texGrade.SetTexture("L2UI_EPIC.HomunCulusWndAni.Grade03Ani_0000");
			texGrade.ShowWindow();
			texGrade.SetLoopCount(99999);
			texGrade.Play();
			texGradepanel.ShowWindow();
			break;
		default:
			texGradepanel.HideWindow();
			texGrade.HideWindow();
			break;
	}
}

function SetNew (bool IsNew)
{
	if ( IsNew )
	{
		texNew.ShowWindow();
	} else {
		texNew.HideWindow();
	}
}

function SetActive (bool IsActive)
{
	currHomunculusData.Activate = IsActive;
	if ( IsActive )
	{
		texCommunion.ShowWindow();
		texCommunion.Stop();
		texCommunion.SetLoopCount(99999);
		texCommunion.Play();
	} else {
		texCommunion.Stop();
		texCommunion.HideWindow();
	}
}

function SetOnBirth ()
{
	conditionWnd.ShowWindow();
}

function SetEnable ()
{
	Enable = True;
	switch (currState)
	{
		case type_State.READY:
			mainBtn.SetTexture("L2UI_EPIC.HomunCulusWnd.CubeListBG_Plus","L2UI_EPIC.HomunCulusWnd.CubeListBG_Plus_over","L2UI_EPIC.HomunCulusWnd.CubeListBG_Plus_down");
			// End:0x1E8
			break;
		case type_State.NOTACTIVE:
			mainBtn.SetTexture("L2UI_EPIC.HomunCulusWnd.CubeListBG_lockActive", "L2UI_EPIC.HomunCulusWnd.CubeListBG_lock_over", "L2UI_EPIC.HomunCulusWnd.CubeListBG_lock_down");
			// End:0x1E8
			break;
		case type_State.Normal:
			mainBtn.SetTexture("L2UI_EPIC.HomunCulusWnd.CubeListBTN_Empty", "L2UI_EPIC.HomunCulusWnd.CubeListBTN_over", "L2UI_EPIC.HomunCulusWnd. CubeListBTN_Empty");
			break;
	}
}

function ClearAll ()
{
	SetState(Lock);
	mainBtn.ClearTooltip();
}

function SetHomunculusData (HomunculusAPI.HomunculusData Data)
{
	local HomunculusAPI.HomunculusNpcData npcData;

	currHomunculusData = Data;
	SetLevel(currHomunculusData.Level);
	SetGrade(currHomunculusData.Type);
	SetActive(currHomunculusData.Activate);
	npcData = HomunculusWndScript.GetHomunculusNpcData(currHomunculusData.Id);
	if ( npcData.ImgName == "" )
	{
		texMonster.SetTexture(GetRandomTexture(currHomunculusData.Id));
	} else {
		texMonster.SetTexture(npcData.ImgName);
	}
	SetNew(currHomunculusData.IsNew);
	SetTooltip();
}

function SetTooltip ()
{
	local HomunculusAPI.HomunculusNpcData npcData;
	local string NpcName;
	local string gradeString;
	local CustomTooltip t;

	getInstanceL2Util().setCustomTooltip(t);
	getInstanceL2Util().ToopTipMinWidth(10);
	npcData = HomunculusWndScript.GetHomunculusNpcData(currHomunculusData.Id);
	NpcName = Class'UIDATA_NPC'.static.GetNPCName(npcData.NpcID);
	gradeString = HomunculusWndScript.GetGradeString(currHomunculusData.Type);
	getInstanceL2Util().ToopTipInsertColorText(GetSystemString(88) $ "." $ string(currHomunculusData.Level) @ NpcName,True,True);
	getInstanceL2Util().ToopTipInsertColorText(gradeString,True,True);
	mainBtn.SetTooltipCustomType(getInstanceL2Util().getCustomToolTip());
}

function SetState (type_State toState)
{
	currState = toState;
	conditionWnd.HideWindow();
	Enable = False;
	switch (currState)
	{
		case READY:
			mainBtn.ClearTooltip();
			mainBtn.SetTexture("L2UI_EPIC.HomunCulusWnd.CubeListBG_PlusDisable","L2UI_EPIC.HomunCulusWnd.CubeListBG_PlusDisable","L2UI_EPIC.HomunCulusWnd.CubeListBG_PlusDisable");
			mainBtn.ShowWindow();
			text0.SetText("");
			SetGrade(-1);
			SetNew(false);
			SetActive(false);
			mainBtn.EnableWindow();
			texMonster.HideWindow();
			break;
		case Lock:
			mainBtn.ClearTooltip();
			mainBtn.HideWindow();
			text0.SetText("");
			SetGrade(-1);
			SetNew(False);
			SetActive(False);
			mainBtn.DisableWindow();
			texMonster.HideWindow();
			break;
		case Normal:
			mainBtn.SetTexture("L2UI_EPIC.HomunCulusWnd.CubeListBTN_Empty","L2UI_EPIC.HomunCulusWnd.CubeListBTN_over","L2UI_EPIC.HomunCulusWnd. CubeListBTN_Empty");
			mainBtn.ShowWindow();
			SetSelected(Selected);
			texMonster.ShowWindow();
			break;
		// End:0x36E
		case NOTACTIVE:
			mainBtn.ClearTooltip();
			mainBtn.SetTexture("L2UI_EPIC.HomunCulusWnd.CubeListBG_lockActive", "L2UI_EPIC.HomunCulusWnd.CubeListBG_lock_over", "L2UI_EPIC.HomunCulusWnd.CubeListBG_lock_down");
			mainBtn.ShowWindow();
			text0.SetText("");
			SetGrade(-1);
			SetNew(false);
			SetActive(false);
			mainBtn.EnableWindow();
			texMonster.HideWindow();
			// End:0x371
			break;
	}
}

function SetSelected (bool isSelect)
{
	Selected = isSelect;
	if ( Selected )
	{
		mainBtn.DisableWindow();
	} else {
		mainBtn.EnableWindow();
	}
}

function string GetRandomTexture (int Id)
{
	local int Per;

	Per = (Id - 1) / 3;
	switch (Per)
	{
		case 0:
			return "L2UI_EPIC.HomunCulusWnd.HomunNPC_Chu";
		case 1:
			return "L2UI_EPIC.HomunCulusWnd.HomunNPC_Utanka";
		case 2:
			return "L2UI_EPIC.HomunCulusWnd.HomunNPC_Buffalo";
		case 3:
			return "L2UI_EPIC.HomunCulusWnd.HomunNPC_Chick";
		case 4:
			return "L2UI_EPIC.HomunCulusWnd.HomunNPC_Hatchling";
	}
	return "";
}

defaultproperties
{
}
