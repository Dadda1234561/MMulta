//----------------------------------------------------------------------------------------------------------------
//
// ��Ƽ��Ʈ ��æƮ 2018.05 �߰�
//
//----------------------------------------------------------------------------------------------------------------

class ArtifactEnchantWnd extends UICommonAPI;

const ANIM_SUCCESS  = 1;
const ANIM_FAIL     = 2;
const ANIM_PROGRESS = 3;

const TIMER_BUTTONDELAY_ID = 100221;
const MAX_USER_LEVEL                   = 99;

var WindowHandle  Me;

var AnimTextureHandle EnchantProgressAnim;

var TextBoxHandle Instruction_Txt;
var TextBoxHandle EnchantNotice_Txt;

var ItemWindowHandle MaterialSlot1_ItemWnd;
var ItemWindowHandle MaterialSlot2_ItemWnd;
var ItemWindowHandle MaterialSlot3_ItemWnd;
var ItemWindowHandle ArtifactItemSlot_ItemWnd;

var TextureHandle MaterialSlotBack1_Texture;
var TextureHandle MaterialSlotBack2_Texture;
var TextureHandle MaterialSlotBack3_Texture;
var TextureHandle ArtifactItemSlotBack_Texture;

var ButtonHandle Reset_Btn;
var ButtonHandle Enchant_Btn;
var ButtonHandle Close_Btn;


var TextureHandle MaterialSlot1_DropHighlight_Texure;
var TextureHandle MaterialSlot2_DropHighlight_Texure;
var TextureHandle MaterialSlot3_DropHighlight_Texure;
var TextureHandle ArtifactItemSlot_DropHighlight_Texure;

var ProgressCtrlHandle EnchantProgress;
var TextBoxHandle ProbabilityNum_Txt;
var TextBoxHandle Probability_Txt;

//var CharacterViewportWindowHandle EffectViewport;

var bool isProgress, isResult;
var int  nNeedMaterialCount;
var int  nNeedGroupID;

var ArtifactEnchantSubWnd ArtifactEnchantSubWndScript;

//----------------------------------------------------------------------------------------------------------------
// INIT
//----------------------------------------------------------------------------------------------------------------
function OnRegisterEvent()
{
	RegisterEvent( EV_Restart );

	RegisterEvent( EV_Enchant_Artifact_Result );
}

function OnLoad()
{
	SetClosingOnESC();

	Initialize();

	initControl();
}

function Initialize()
{
	ArtifactEnchantSubWndScript = ArtifactEnchantSubWnd(GetScript("ArtifactEnchantSubWnd"));

	Me = GetWindowHandle( "ArtifactEnchantWnd" );

	EnchantProgress    = GetProgressCtrlHandle( "ArtifactEnchantWnd.EnchantProgress" );

	EnchantProgressAnim = GetAnimTextureHandle( "ArtifactEnchantWnd.EnchantProgressAnim" );

	Instruction_Txt   = GetTextBoxHandle( "ArtifactEnchantWnd.Instruction_Txt" );
	EnchantNotice_Txt = GetTextBoxHandle( "ArtifactEnchantWnd.EnchantNotice_Txt" );

	ArtifactItemSlot_ItemWnd = GetItemWindowHandle( "ArtifactEnchantWnd.ArtifactItemSlot_ItemWnd" );

	MaterialSlot1_ItemWnd = GetItemWindowHandle( "ArtifactEnchantWnd.MaterialSlot1_ItemWnd" );
	MaterialSlot2_ItemWnd = GetItemWindowHandle( "ArtifactEnchantWnd.MaterialSlot2_ItemWnd" );
	MaterialSlot3_ItemWnd = GetItemWindowHandle( "ArtifactEnchantWnd.MaterialSlot3_ItemWnd" );

	MaterialSlotBack1_Texture = GetTextureHandle( "ArtifactEnchantWnd.MaterialSlotBack1_Texture" );
	MaterialSlotBack2_Texture = GetTextureHandle( "ArtifactEnchantWnd.MaterialSlotBack2_Texture" );
	MaterialSlotBack3_Texture = GetTextureHandle( "ArtifactEnchantWnd.MaterialSlotBack3_Texture" );

	ArtifactItemSlotBack_Texture = GetTextureHandle( "ArtifactEnchantWnd.ArtifactItemSlotBack_Texture" );

	Enchant_Btn = GetButtonHandle( "ArtifactEnchantWnd.Enchant_Btn" );
	Reset_Btn   = GetButtonHandle( "ArtifactEnchantWnd.Reset_Btn" );	
	Close_Btn   = GetButtonHandle( "ArtifactEnchantWnd.Close_Btn" );

	MaterialSlot1_DropHighlight_Texure = GetTextureHandle( "ArtifactEnchantWnd.MaterialSlot1_DropHighlight_Texure" );
	MaterialSlot2_DropHighlight_Texure = GetTextureHandle( "ArtifactEnchantWnd.MaterialSlot2_DropHighlight_Texure" );
	MaterialSlot3_DropHighlight_Texure = GetTextureHandle( "ArtifactEnchantWnd.MaterialSlot3_DropHighlight_Texure" );
	ArtifactItemSlot_DropHighlight_Texure = GetTextureHandle( "ArtifactEnchantWnd.ArtifactItemSlot_DropHighlight_Texure" );

	//EffectViewport = GetCharacterViewportWindowHandle("ArtifactEnchantWnd.EffectViewport");

	//EffectViewport.SetNPCInfo( 19671) ;
	//EffectViewport.SetUISound( true); //IsUISound	
	Probability_Txt = GetTextBoxHandle("ArtifactEnchantWnd.Probability_Txt");
	ProbabilityNum_Txt = GetTextBoxHandle("ArtifactEnchantWnd.ProbabilityNum_Txt");
}


function initControl()
{
	ResetUI();

	EnchantProgress.SetProgressTime(1500);
	EnchantProgress.SetPos(0);
	EnchantProgress.Reset();
}

//----------------------------------------------------------------------------------------------------------------
// OnEvent
//----------------------------------------------------------------------------------------------------------------

function OnEvent(int Event_ID, string param)
{
	//Debug( "OnEvent " @ Event_ID  @ param) ;
	if (Event_ID == EV_Restart) 
	{
		initControl();
	}
	else if (Event_ID == EV_Enchant_Artifact_Result) 
	{
		Debug("EV_Enchant_Artifact_Result" @ param);
		resultHandler(param);
	}
}

function OnTimer(int TimerID)
{
	if(TimerID == TIMER_BUTTONDELAY_ID)
	{
		// ��� ��ư Ȱ��ȭ
		Enchant_Btn.EnableWindow();
		Me.KillTimer( TIMER_BUTTONDELAY_ID );
	}
}

function resultHandler(string Param)
{
	local int nResult, nEnchant;
	local ItemInfo resultItemInfo;

	// Result: ���(0:����, 1:����, 2:����� ������ ���� ����)
	ParseInt(Param, "Result", nResult);
	ParseInt(Param, "Enchant", nEnchant);

	isResult = true;

	// ���� ���� ���� ���� �ʱ�ȭ ��ư Ȱ��ȭ
	Reset_Btn.EnableWindow();

	// �����̶��..
	// End:0x199
	if(nResult == 0)
	{
		// ���ν��� ������ Info�� �����ͼ�..
		if(getSlot(0).GetItemNum() > 0)	
		{
			// ��� ������ �����
			MaterialSlot1_ItemWnd.HideWindow();
			MaterialSlot2_ItemWnd.HideWindow();
			MaterialSlot3_ItemWnd.HideWindow();

			getSlot(0).GetItem(0, resultItemInfo);
			getSlot(0).Clear();
			
			resultItemInfo.Enchanted = nEnchant;

			getSlot(0).SetItem( 0, resultItemInfo );

			getSlot(0).AddItem(resultItemInfo);

			Debug("resultItemInfo ��æƮ " @ resultItemInfo.Enchanted);

			// ��ȭ ����
			Instruction_Txt.SetText(GetSystemString(3885));

			// ��� ��ư�� ���� ��ȭ�� �ٽ� ������ �� �ֽ��ϴ�.
			EnchantNotice_Txt.SetText(GetSystemString(3890));

			// ��ư ������� ����
			Enchant_Btn.SetNameText( GetSystemString(3135) );	// 3135 ���, 5005 ��ȭ
			
			playEffectAnim(ANIM_SUCCESS);

			// ��ư ��Ȱ��ȭ ����
			Me.SetTimer(TIMER_BUTTONDELAY_ID, 1000);
		}
	}
	else if(nResult == 1) 
	{
		Debug("��ȭ ����!");

		// ��� ������ �����
		MaterialSlot1_ItemWnd.HideWindow();
		MaterialSlot2_ItemWnd.HideWindow();
		MaterialSlot3_ItemWnd.HideWindow();

		// ��ȭ ����
		Instruction_Txt.SetText(GetSystemString(3886));

		// ��� ��ư�� ���� ��ȭ�� �ٽ� ������ �� �ֽ��ϴ�.
		EnchantNotice_Txt.SetText(GetSystemString(3890));

		// ��ư ������� ����
		Enchant_Btn.SetNameText( GetSystemString(3135) );	// 3135 ���, 5005 ��ȭ

		playEffectAnim(ANIM_FAIL);

		// ��ư ��Ȱ��ȭ ����
		Me.SetTimer(TIMER_BUTTONDELAY_ID, 1000);
	}
	else
	{
		 Debug("���� : ��ᰡ �߸��Ǿ��ų� ������ ���ܼ� ��Ƽ��Ʈ ��ȭ�� ������ ���");
		 ResetUI();
		 AddSystemMessage(4559);
		 Me.HideWindow();
	}	
}

// ��� ����� ���� �� �̺�Ʈ ó��
function OnTextureAnimEnd( AnimTextureHandle a_WindowHandle )
{
	local itemInfo info;
	local array<int> materialServerIDArray;
	local int i;

	EnchantProgressAnim.Stop();
	EnchantProgressAnim.HideWindow();

	switch ( a_WindowHandle )
	{
		case EnchantProgressAnim:
			if (isProgress)
			{
				isProgress = false;
				//Debug("RequestEnchantItem" @ SelectItemInfo.ID.ClassID @ SelectHelperItemInfo.ID.ClassID);
				//class'EnchantAPI'.static.RequestEnchantItem(SelectItemInfo.ID, SelectHelperItemInfo.ID);
				i = 1;
				// ��� 1,2,3 �� ������ ���Կ� ���� ������ �迭�� �߰� 
				i = addMetialArr(i, materialServerIDArray);
				i = addMetialArr(i, materialServerIDArray);
				i = addMetialArr(i, materialServerIDArray);

				//RequestEnchantArtifact(
				if(getSlot(0).GetItemNum() > 0)
				{
					getSlot(0).GetItem(0, info);

					RequestEnchantArtifact(info.Id.ServerID, materialServerIDArray);

					Debug("----> Call Api RequestEnchantArtifact " @ info.Id.ServerID @", len: "@materialServerIDArray.Length);
					for(i = 0; i < materialServerIDArray.Length; i++)
					{						
						Debug("materialServerIDArray:  " @ i  @ materialServerIDArray[i]);
					}

					Enchant_Btn.DisableWindow();
				}
				//getSlot(0).GetItem(0, info)
			}
					
		break;
	}
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)));
	GetWindowHandle("ArtifactEnchantSubWnd").ShowWindow();

	//EffectViewport.SpawnNPC();
	//EffectViewport.ShowNPC(0.1f);
	//EffectViewport.SpawnEffect( "LineageEffect2.bg_astatine_portal") ;

	setSlotHighlightFocus(0);

	ArtifactEnchantSubWndScript.setEnable(true);
	ArtifactEnchantSubWndScript.syncInventory(-1, -1);
}

function OnHide()
{
	ResetUI();
}

//----------------------------------------------------------------------------------------------------------------
// OnClickButton
//----------------------------------------------------------------------------------------------------------------
function OnClickButton( string Name )
{
	switch( Name )
	{
		case "Reset_Btn":
			OnReset_BtnClick();
			break;

		case "Enchant_Btn":
			OnEnchant_BtnClick();
			break;

		case "Close_Btn":
			OnClose_BtnClick();
			break;
	}
}

//----------------------------------------------------------------------------------------------------------------
// ClickHandler
//----------------------------------------------------------------------------------------------------------------

function OnReset_BtnClick()
{
	ResetUI();
	ArtifactEnchantSubWndScript.syncInventory(-1, -1);
}

function OnClose_BtnClick()
{	
	if(isProgress)
	{
		progressBarCancel();
	}
	else
	{
		ResetUI();
		//ArtifactEnchantSubWndScript.syncInventory(-1, -1);
		Me.HideWindow();
	}
}

function OnEnchant_BtnClick()
{
	local ItemInfo info;

	// ��� ���¿���, ����� ���� ���
	if (isResult)
	{
		if(getSlot(0).GetItemNum() > 0)
		{
			getSlot(0).GetItem(0, info);
			getSlot(0).Clear();

			ResetUI();
			// �ٽ� ù��° ���Կ� �ֱ�
			dropProcess(info);
		}		
	}
	else
	{
		// ����â ��Ȱ��ȭ
		ArtifactEnchantSubWndScript.setEnable(false);

		// ��Ŀ�� �ؽ��� �����
		setSlotHighlightFocus(-1);

		// ��æƮ ���� �غ� ���
		playEffectAnim(ANIM_PROGRESS);

		//DropHighlight_enchantitem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
		//DropHighlight_enchantscript.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
		//DropHighlight_CloverItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");	
		
		// ��� ���� ��� ����� ����
		EnchantProgress.SetProgressTime(1500);
		EnchantProgress.SetPos(0);
		EnchantProgress.Reset();

		EnchantProgress.Start();
		
		// ��ġ�� �Ʒ��� ���� �Ǿ� �ִ�. 
		// 1   2
		// ��Ƽ��Ʈ
		//   3
		
		// �ڷ� �̵� ��� 
		MaterialSlot1_ItemWnd.EnableTick();
		MaterialSlot2_ItemWnd.EnableTick();
		MaterialSlot3_ItemWnd.EnableTick();

		MaterialSlot1_ItemWnd.ClearAnchor();
		MaterialSlot2_ItemWnd.ClearAnchor();
		MaterialSlot3_ItemWnd.ClearAnchor();

		MaterialSlot1_ItemWnd.Move( 72,  29, 1.5f);
		MaterialSlot2_ItemWnd.Move(-64,  29, 1.5f);
		MaterialSlot3_ItemWnd.Move(  0, -71, 1.5f);

		// ��ư �̸� ����
		Close_Btn.SetNameText( GetSystemString(141) ); // ��� 141,  �ݱ� 646

		Enchant_Btn.SetNameText( GetSystemString(5005) );	// 3135 ���, 5005 ��ȭ

		isProgress = true;
		setEnchantButtonCheck();
	}
}

// �ʱ�ȭ, ��ȭ ��ư ����
function setEnchantButtonCheck()
{
	//local ItemInfo info;
	local int filledSlotCount, i;
	//local bool bEnable;

	// �������̸� ������ ��ư ��Ȱ��ȭ
	if (isProgress) 
	{
		Enchant_Btn.DisableWindow();
		Reset_Btn.DisableWindow();
		return;
	}

	// ��ώ�Ը� üũ
	// ������ ���ִ� ���� üũ 1,2,3 , 3���� ��Ḹ üũ (0)�� ��æƮ�� ���
	for(i = 1; i < 4; i++)
	{
		if(getSlot(i).GetItemNum() > 0)
		{
			filledSlotCount++;
		}
	}

	// ���� ���Ե� üũ
	if (filledSlotCount > 0 || getSlot(0).GetItemNum() > 0)
	{
		// ���� �� ���� ��ġ�� ���� �˴ϴ�.
		Instruction_Txt.SetText(GetSystemString(3884));
		Reset_Btn.EnableWindow();
	}
	else
	{
		Reset_Btn.EnableWindow();
	}
	// �ʿ��� ��ᰡ ä�� ������..
	if (nNeedMaterialCount == filledSlotCount)
	{
		// �Ʒ��� ��ȭ ��ư�� ���� ��Ƽ��Ʈ ��ȭ�� �����ϼ���.
		EnchantNotice_Txt.SetText(GetSystemString(3889));
		Enchant_Btn.EnableWindow();
	}
	else
	{
		Enchant_Btn.DisableWindow();
	}
}

function setInitButtonCheck()
{

}

// ������ ���� ��� ���Կ��� ������, ���� ���̵� �迭�� �ֱ�
function int addMetialArr(int i, out array<int> materialServerIDArray)
{
	local itemInfo info;
	if(getSlot(i).GetItemNum() > 0)
	{					
		getSlot(i).GetItem(0, info);
		if (info.Id.ServerID > 0)
		{
			materialServerIDArray[i - 1] = info.Id.ServerID;
			i++;

			Debug("���� Id.ClassID" @ info.Id.ClassID);
		}
	}

	return i;
}

function ResetUI()
{
	Reset_Btn.DisableWindow();
	// ����â ��Ȱ��ȭ
	ArtifactEnchantSubWndScript.setEnable(true);

	EnchantProgress.SetPos(0);
	EnchantProgress.Reset();

	EnchantProgressAnim.Stop();
	EnchantProgressAnim.HideWindow();

	ArtifactItemSlot_ItemWnd.Clear();
	
	MaterialSlot1_ItemWnd.Clear();
	MaterialSlot2_ItemWnd.Clear();
	MaterialSlot3_ItemWnd.Clear();

	MaterialSlot1_ItemWnd.ShowWindow();
	MaterialSlot2_ItemWnd.ShowWindow();
	MaterialSlot3_ItemWnd.ShowWindow();
	
	MaterialSlot1_ItemWnd.DisableTick();
	MaterialSlot2_ItemWnd.DisableTick();
	MaterialSlot3_ItemWnd.DisableTick();

	// ��ġ �ʱ�ȭ
	MaterialSlot1_ItemWnd.MoveC(94 ,  106);
	MaterialSlot2_ItemWnd.MoveC(231,  106);
	MaterialSlot3_ItemWnd.MoveC(167,  205);

	MaterialSlotBack1_Texture.ShowWindow();
	MaterialSlotBack2_Texture.ShowWindow();
	MaterialSlotBack3_Texture.ShowWindow();

	setSlotHighlightFocus(0);

	Me.KillTimer( TIMER_BUTTONDELAY_ID );
	Enchant_Btn.DisableWindow();

	// ��ȭ, �ؽ�Ʈ ����
	Enchant_Btn.SetNameText(GetSystemString(5005));

	// �ݱ�, �ؽ�Ʈ ����
	Close_Btn.SetNameText(GetSystemString(646));

	isProgress = false;

	isResult = false;

	// �ƹ��͵� �ȳ�����.
	Instruction_Txt.SetText("");

	// ��ȭ�� �������� ��� ���ּ���.
	EnchantNotice_Txt.SetText(GetSystemString(3887));
	Probability_Txt.HideWindow();
	ProbabilityNum_Txt.SetText("");
}

function progressBarCancel()
{
	isProgress = false;

	EnchantProgress.SetPos(0);
	EnchantProgress.Reset();

	EnchantProgressAnim.Stop();
	EnchantProgressAnim.HideWindow();

	// ��ġ �ʱ�ȭ
	MaterialSlot1_ItemWnd.DisableTick();
	MaterialSlot2_ItemWnd.DisableTick();
	MaterialSlot3_ItemWnd.DisableTick();

	MaterialSlot1_ItemWnd.MoveC(94, 106);
	MaterialSlot2_ItemWnd.MoveC(231, 106);
	MaterialSlot3_ItemWnd.MoveC(167, 205);

	// ��ȭ, �ؽ�Ʈ ����
	Enchant_Btn.SetNameText(GetSystemString(5005));
	//Enchant_Btn.EnableWindow();

	// ��ȭ ��ư Ȱ��ȭ ���� üũ 
	setEnchantButtonCheck();

	// �ݱ�, �ؽ�Ʈ ����
	Close_Btn.SetNameText(GetSystemString(646));

	// ����â ����
	ArtifactEnchantSubWndScript.setEnable(true);
}

function OnRClickItem( String strID, int index )
{
	OnDBClickItem(strID, index);
}

function OnDBClickItem( string ControlName, int index )
{
	local ItemInfo info;
	local ItemWindowHandle targetItemWnd;
	//SubWnd_Item1.GetItem(index, info);

	if (isProgress) return;
	if (isResult) return;

	switch(ControlName)
	{
		case "MaterialSlot1_ItemWnd" :
			 targetItemWnd = MaterialSlot1_ItemWnd;
			 break;
		case "MaterialSlot2_ItemWnd" :
			 targetItemWnd = MaterialSlot2_ItemWnd;
			 break;
		case "MaterialSlot3_ItemWnd" :
			 targetItemWnd = MaterialSlot3_ItemWnd;
			 break;
		case "ArtifactItemSlot_ItemWnd" :
			 //targetItemWnd = ArtifactItemSlot_ItemWnd;
			 ResetUI();
			 ArtifactEnchantSubWndScript.syncInventory(-1, -1);
			 return;			 
	}

	if (ControlName == "") return;
	
	targetItemWnd.GetItem(0, info);
	
	//Debug("info.Id.ClassID" @ info.Id.ClassID);

	if (info.Id.ClassID > 0) 
	{
		targetItemWnd.Clear();
		// �����ؾ�..

		ArtifactEnchantSubWndScript.syncInventory(nNeedGroupID, minArtifactEnchantNum());

		//ArtifactEnchantSubWndScript.syncInventory(-1, -1);

		setSlotHighlightFocus(findEmptySlotIndex());
	}	
}


function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{	
	//if (a_ItemInfo.ShortcutType == EShortCutItemType.SCIT_MACRO) return;
	//Debug("a_ItemInfo.DragSrcName" @ a_ItemInfo.DragSrcName);

	if (a_ItemInfo.DragSrcName != "SubWnd_Item1") return;
	
	dropProcess(a_ItemInfo);
}

function dropProcess(itemInfo a_ItemInfo)
{
	local int emptySlotIndex;
	local int resultProb;
	// �󽽷� ã��
	emptySlotIndex = findEmptySlotIndex();

	// Debug("�󽽷� ��ȣ" @ emptySlotIndex);

	if(emptySlotIndex <= -1) return;// emptyItemID;
	
	// ù��° ������ ��������..
	// ��Ƽ��Ʈ ��æƮ ������ ������
	// End:0x1E1
	if(emptySlotIndex == 0)
	{
		Debug("--------------------------------------------------------------------------");
		class'UIDATA_ARTIFACT'.static.GetArtifactEnchantCondition(a_ItemInfo.Id.ClassID, a_ItemInfo.Enchanted, nNeedGroupID, nNeedMaterialCount, resultProb);
		Debug("���� ���� ��ȭ ��� ������: " @ a_ItemInfo.Name @ a_ItemInfo.Id.ClassID @ a_ItemInfo.Enchanted);
		Debug("groupID       : " @ nNeedGroupID);
		Debug("materialCount : " @ nNeedMaterialCount);
		Debug("resultProb    : " @ resultProb);
		Debug("--------------------------------------------------------------------------");
		Probability_Txt.ShowWindow();
		ProbabilityNum_Txt.SetText(string(ResultProb) $ "%");
	}

	//class'UIDATA_ARTIFACT'.static.GetArtifactMinEnchantMaterial(

	// Debug("resultProb      : " @ resultProb);    //���� Ȱ���ε� ��� ����.
	
	// �󽽷Կ� �Ŵ´�.
	getSlot(emptySlotIndex).AddItem(a_ItemInfo);

	// ��� ���� Ȱ��ȭ, ��Ȱ��ȭ ����.
	setActiveMaterialSlot(nNeedMaterialCount);

	//GetArtifactMinEnchantMaterial

	ArtifactEnchantSubWndScript.syncInventory(nNeedGroupID, minArtifactEnchantNum());

	//Debug("- �߰�" @ a_ItemInfo.Name);	
	//Debug("- findEmptySlotIndex()" @ findEmptySlotIndex());
	setSlotHighlightFocus(findEmptySlotIndex());

	// ��ȭ ��ư Ȱ��ȭ ���� üũ 
	setEnchantButtonCheck();
}

//----------------------------------------------------------------------------------------------------------------
// UTIL
//----------------------------------------------------------------------------------------------------------------

function int minArtifactEnchantNum()
{
	local ItemInfo info;
	local int minEnchantNum;

	minEnchantNum = -1;

	// ���� ������ ������ ������ ���ͼ� �䱸 �ϴ� �ּ� �ڷ� ��æƮ ��ġ�� ��´�.
	if(getSlot(0).GetItemNum() > 0)
	{
		getSlot(0).GetItem(0, info);
		minEnchantNum = class'UIDATA_ARTIFACT'.static.GetArtifactMinEnchantMaterial(info.Enchanted);

		//Debug("---info.Id.ClassID" @ info.Id.ClassID);
		//Debug("---minEnchantNum: " @ minEnchantNum);
	}

	return minEnchantNum;
}

// ��� ���� Ȱ��ȭ 
function setActiveMaterialSlot (int activeMaterialCount)
{
	getSlot(3).DisableWindow();
	getSlot(2).DisableWindow();
	getSlot(1).DisableWindow();

	MaterialSlotBack1_Texture.HideWindow();
	MaterialSlotBack2_Texture.HideWindow();
	MaterialSlotBack3_Texture.HideWindow();

	// Debug(" ��� ���� Ȱ��ȭ ����.");
	switch(activeMaterialCount)
	{
		case 3 : getSlot(3).EnableWindow(); MaterialSlotBack3_Texture.ShowWindow();
		case 2 : getSlot(2).EnableWindow(); MaterialSlotBack2_Texture.ShowWindow();
		case 1 : getSlot(1).EnableWindow(); MaterialSlotBack1_Texture.ShowWindow();
	}
}

// �󽽷� ��ȣ 0�� ��� ����, 1 2, 3 ��� 
function int findEmptySlotIndex()
{
	
	if(ArtifactItemSlot_ItemWnd.GetItemNum() <= 0 && ArtifactItemSlot_ItemWnd.IsEnableWindow()) return 0;
	else if(MaterialSlot1_ItemWnd.GetItemNum() <= 0 && MaterialSlot1_ItemWnd.IsEnableWindow()) return 1;
	else if(MaterialSlot2_ItemWnd.GetItemNum() <= 0 && MaterialSlot2_ItemWnd.IsEnableWindow()) return 2;
	else if(MaterialSlot3_ItemWnd.GetItemNum() <= 0 && MaterialSlot3_ItemWnd.IsEnableWindow()) return 3;
	
	return -1;
}


// 0�� ����, ��� 1,2,3
function setSlotHighlightFocus(int slotIndex)
{
	local int limitEnchantNum;

	MaterialSlot1_DropHighlight_Texure.HideWindow();
	MaterialSlot2_DropHighlight_Texure.HideWindow();
	MaterialSlot3_DropHighlight_Texure.HideWindow();
	ArtifactItemSlot_DropHighlight_Texure.HideWindow();
	
	limitEnchantNum = minArtifactEnchantNum();
	switch(slotIndex)
	{
		// 1,  2
		//   3    ��� ���� 
		case 1: if (MaterialSlot1_ItemWnd.IsEnableWindow()) 
				{
					MaterialSlot1_DropHighlight_Texure.ShowWindow(); 
					
					// +$s1 �̻��� ��ᰡ �ʿ� �մϴ�.
					if(limitEnchantNum > 0)
						EnchantNotice_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(5217), string(limitEnchantNum))); 
					else						
						EnchantNotice_Txt.SetText(GetSystemString(3888)); // ��ȭ�� ��Ḧ ������ּ���.					
				}
			    break;

		case 2: if (MaterialSlot2_ItemWnd.IsEnableWindow()) 
				{
					MaterialSlot2_DropHighlight_Texure.ShowWindow(); 

					// +$s1 �̻��� ��ᰡ �ʿ� �մϴ�.
					if(limitEnchantNum > 0)
						EnchantNotice_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(5217), string(limitEnchantNum))); 
					else						
						EnchantNotice_Txt.SetText(GetSystemString(3888)); // ��ȭ�� ��Ḧ ������ּ���.					
				}
			    break;

		case 3: if (MaterialSlot3_ItemWnd.IsEnableWindow()) 
				{
					MaterialSlot3_DropHighlight_Texure.ShowWindow(); 

					// +$s1 �̻��� ��ᰡ �ʿ� �մϴ�.
					if(limitEnchantNum > 0)
						EnchantNotice_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(5217), string(limitEnchantNum))); 
					else						
						EnchantNotice_Txt.SetText(GetSystemString(3888)); // ��ȭ�� ��Ḧ ������ּ���.					
				}
			    break;

		// ��� ���� ����
		case 0: ArtifactItemSlot_DropHighlight_Texure.ShowWindow(); 
				// ��ȭ�� �������� ������ּ���.
				EnchantNotice_Txt.SetText(GetSystemString(3887));
			    break;
	}

}

// 0 ~ 3 ��ȭ â�� ���� 4���� itemInfo�� ���� �ϴ� �뵵 
function ItemInfo getSlotItemInfo(int slotIndex)
{  
	local ItemInfo tmInfo;
	 
	switch(slotIndex)
	{
		case 1: if(MaterialSlot1_ItemWnd.GetItemNum() > 0) MaterialSlot1_ItemWnd.GetItem(0, tmInfo); break;
		case 2: if(MaterialSlot2_ItemWnd.GetItemNum() > 0) MaterialSlot2_ItemWnd.GetItem(0, tmInfo); break;
		case 3:	if(MaterialSlot3_ItemWnd.GetItemNum() > 0) MaterialSlot3_ItemWnd.GetItem(0, tmInfo); break;
		case 0:	if(ArtifactItemSlot_ItemWnd.GetItemNum() > 0) ArtifactItemSlot_ItemWnd.GetItem(0, tmInfo); break;

		default : Debug("** ��� : ArtifactEnchantWnd �� getSlotItemInfo�� �Է°��� �߸��� :" @ slotIndex);
	}

	return tmInfo;
}

// 0 ~ 3 ��ȭ â�� ���� 4���� itemInfo�� ���� �ϴ� �뵵 
function ItemWindowHandle getSlot(int slotIndex)
{  
	local ItemWindowHandle tm;

	switch(slotIndex)
	{
		case 1: tm = MaterialSlot1_ItemWnd; break;
		case 2: tm = MaterialSlot2_ItemWnd; break;
		case 3:	tm = MaterialSlot3_ItemWnd; break;
		case 0:	tm = ArtifactItemSlot_ItemWnd; break;

		default : Debug("** ��� : ArtifactEnchantWnd �� getSlot�� �Է°��� �߸��� :" @ slotIndex);
	}

	return tm;
}

// ���� ���Կ� �žƼ� ��� ���� ������ �� ������ �ֳ� üũ , ���� �κ����� ���
function bool externalCheckUsingItem(ItemInfo info)
{
	local bool rValue;

	local int i;
	
	for (i = 0; i < 4; i++)
	{
		if (getSlotItemInfo(i).Id == Info.Id) rValue = true;
	}

	return rValue;
}

// �ִ� �ؽ��ĸ� �÷��� ���� �ش�
function playEffectAnim(int animType)
{
	EnchantProgressAnim.SetLoopCount( 1 );

	if (animType == ANIM_SUCCESS)
	{
		Playsound("ItemSound3.enchant_success");
		EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
		EnchantProgressAnim.Stop();
		EnchantProgressAnim.Play();
	}
	else if (animType == ANIM_FAIL)
	{
		Playsound("ItemSound3.enchant_fail");
		EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
		EnchantProgressAnim.Stop();
		EnchantProgressAnim.Play();		
	}
	else // if (animType == ANIM_PROGRESS)
	{
		// ��æƮ ���� �غ� ���
		Playsound("ItemSound3.enchant_process");	
		EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Loading_01");
		EnchantProgressAnim.Stop();
		EnchantProgressAnim.Play();	
	}

	EnchantProgressAnim.ShowWindow();
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
}

defaultproperties
{
}
