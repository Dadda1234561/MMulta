/**
 * 
 *   �ڵ� ���� �ý��� (������������ ������ �ͼ�, ���� ������ ���� ��� ���� �� �߰� ����)
 *   
 **/
class AutoShotItemWnd extends UICommonAPI;

const ITEM_ADD      =  1;
const ITEM_SET      =  2;
const ITEM_CLEAR    =  3;

const TIME_ID     = 30021;
const TIME_DELAY  = 5000;

struct slotData
{
	var bool bNoticeShow;
	var string toolTipStr;
};


var WindowHandle  Me;

var WindowHandle AutoShotItemSubWnd;

// ��(��, ����Ͼ�), ��ȯ��, 0�� ���ų� ������ ��ȯ �ȵ� ����
var int PetID, SummonID;

//var WindowHandle  AutoShotNoticeWnd;
//var TextBoxHandle AutoShotNotice_TextBox;

var TextureHandle petIconTexture;

// ���⸦ ���� �߳�?
var bool hasWeapon;

// ��ȯ��, ��, ����Ͼ� Ȱ��ȭ ����
var bool bSummon, bPet, bBeforeSummon, bBeforePet;

// ź�� ���ٰ� �޼����� ���� �� ���ΰ�?
// �˸��� ������ ī��Ʈ
var int showNoticeNum;

// ���� ���õ� ������ ��ȣ �÷��̾�1,2   ,�� 3,4
var int currentSelectSoulShotWndIndex;

var ItemInfo weaponItemInfo;
var ItemInfo beforeWeaponInfo;
var ShortcutWnd ShortcutWndScript;
//var AutoTargetWnd AutoTargetWndScript;

var AutoPotionWnd AutoPotionWndScript;
var YetiPCModeChangeWnd YetiPCModeChangeWndScript;

/**
 *  OnRegisterEvent
 **/
function OnRegisterEvent()
{
	RegisterEvent( EV_SoulShotUpdate );

	RegisterEvent( EV_BeginSoulShotUpdate );

	RegisterEvent( EV_InventoryUpdateItem );
	RegisterEvent( EV_InventoryAddItem );

	RegisterEvent( EV_Restart );

	RegisterEvent( EV_ShortcutkeyassignChanged );

	RegisterEvent(EV_GameStart); //���� ���� �� ���� �̺�Ʈ�� ��ü TT#73058
}

/**
 *  OnLoad
 **/
function OnLoad()
{
	Initialize();
}

/**
 *  Initialize
 **/
function Initialize()
{
	Me = GetWindowHandle ( "AutoShotItemWnd" );
	AutoShotItemSubWnd = GetWindowHandle( "AutoShotItemWnd.AutoShotItemSubWnd" );
	ShortcutWndScript  = ShortcutWnd(GetScript("ShortcutWnd"));
	//AutoTargetWndScript = AutoTargetWnd(GetScript("AutoTargetWnd"));
	AutoPotionWndScript = AutoPotionWnd(GetScript("AutoPotionWnd"));
	YetiPCModeChangeWndScript = YetiPCModeChangeWnd(GetScript("YetiPCModeChangeWnd"));
	init();
}

function CustomTooltip SetTooltip(string Text)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;

	Tooltip.MinimumWidth = 144;
	Tooltip.DrawList.Length = 1;

	info.eType = DIT_TEXT;
	info.t_color.R = 178;
	info.t_color.G = 190;
	info.t_color.B = 207;
	info.t_color.A = 255;
	info.t_strText = Text;
	Tooltip.DrawList[0] = info;

	return Tooltip;
}

/**
 * ����Ÿ �ʱ�ȭ
 **/
function init()
{
	local int i;
	local ItemInfo tempInfo;


	for (i = 1; i < 5; i++)
	{
		GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ i).Clear();
		GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ i).Clear();

		// �÷��̾�
		if(i == 1 || i == 2)
		{
			GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ i).SetTooltipText(GetSystemMessage(6828));
			GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ i).SetTooltipText(GetSystemMessage(6828));
			// [Explicit Continue]
			continue;
		}
		if(IsAdenServer())
		{
			GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.PetSlotGroupWnd_HorWnd.shotbg_PetWarrior_horTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_WeaponWarrior");
			GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.PetSlotGroupWnd_HorWnd.shotbg_PetMagic_horTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_WeaponMagic");
			GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.PetSlotGroupWnd_VerWnd.shotbg_PetWarrior_VerTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_WeaponWarrior");
			GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.PetSlotGroupWnd_VerWnd.shotbg_PetMagic_VerTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_WeaponWarrior");
			GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ string(i)).SetTooltipText(GetSystemMessage(6828));
			GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ string(i)).SetTooltipText(GetSystemMessage(6828));
			// [Explicit Continue]
			continue;
		}

		GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.PetSlotGroupWnd_HorWnd.shotbg_PetWarrior_horTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_PetWarrior");
		GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.PetSlotGroupWnd_HorWnd.shotbg_PetMagic_horTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_PetMagic");
		GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.PetSlotGroupWnd_VerWnd.shotbg_PetWarrior_VerTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_PetWarrior");
		GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.PetSlotGroupWnd_VerWnd.shotbg_PetMagic_VerTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_PetMagic");
		GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ string(i)).SetTooltipText(GetSystemMessage(6829));
		GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ string(i)).SetTooltipText(GetSystemMessage(6829));
	}

	PetID = 0;
	SummonID = 0;
	showNoticeNum = 0;

	hasWeapon = false;
	bBeforeSummon = false;
	bBeforePet = false;

	beforeWeaponInfo = tempInfo;
	weaponItemInfo = tempInfo;

	// ĳ���� ����
	GetWindowHandle(getSlotPath(false, 1)).HideWindow();
	GetWindowHandle(getSlotPath(true, 1)).HideWindow();

	// ��
	GetWindowHandle(getSlotPath(false, 3)).HideWindow();
	GetWindowHandle(getSlotPath(true, 3)).HideWindow();

	// ����â �����
	HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");

	// �⺻â �����
	Me.HideWindow();
	Me.KillTimer(TIME_ID);
}

function onShow()
{
	windowPositionAutoMove();
}

function OnDefaultPosition()
{
	windowPositionAutoMove();
	checkSlotShowState();
}

/** ���� ��ġ�� �ڵ� �̵� */
function windowPositionAutoMove()
{
	//Debug("GetGameStateName()" @ GetGameStateName());
	if (GetGameStateName() != "GAMINGSTATE")
	{
		return;
	}

	//Debug("windowPositionAutoMove"@ GetGameStateName());

	// �� ���� ����..
	//GetWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd").HideWindow();
	//GetWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd").HideWindow();

	// ���η� ����â�� ��ġ �Ǿ� �ֳ�?
	if(IsVertical())
	{
		if(GetWindowHandle("ShortcutWnd.ShortcutWndVertical" $ getShortcutIndexStr()).m_pTargetWnd == none)
		{
			return;
		}
		else
		{
			GetWindowHandle("AutoShotItemWnd").ClearAnchor();
			GetWindowHandle("AutoShotItemWnd").SetAnchor("ShortcutWnd.ShortcutWndVertical" $ getShortcutIndexStr(), "TopLeft", "TopRight", -1, 17);
		}
	}
	else
	{
		if(GetWindowHandle("ShortcutWnd.ShortcutWndHorizontal" $ getShortcutIndexStr()).m_pTargetWnd == none)
		{
			return;
		}
		else
		{
			GetWindowHandle("AutoShotItemWnd").ClearAnchor();
			GetWindowHandle("AutoShotItemWnd").SetAnchor("ShortcutWnd.ShortcutWndHorizontal" $ getShortcutIndexStr(), "TopLeft", "BottomLeft", 16, -1);
		}
	}

	AutoPotionWndScript.windowPositionAutoMove();
	//checkSlotShowState();
}

// ���� Ȯ�� ������ ���� ���¿� ���� �ڿ� �ٴ� ���� ���� �� string�� ����
function string getShortcutIndexStr()
{
	local int nIndex;
	local string rValue;

	nIndex = ShortcutWndScript.getExpandNum();

	if (nIndex <= 0) rValue = "";
	else rValue = "_" $ nIndex;

	return rValue;
}
/**
 * OnEvent
 **/
function OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().getIsArenaServer())
	{
		return;
	}

	// Ŭ���� ������ ����ϵ���..
	//if ( !getInstanceUIData().getIsClassicServer() ) return;

	// Debug("--�ڵ���ź-- " @ Event_ID);
	// Debug("--param    " @ param);

	switch( Event_ID )
	{
		case EV_GameStart:
			checkSlotShowState();
			windowPositionAutoMove();
			break;
		case EV_BeginSoulShotUpdate:
			beginSoulShotUpdateHandle(param);
			break;
	    case EV_SoulShotUpdate:
			soulShotUpdateHandle(param);
			break;
		case EV_InventoryUpdateItem:
		case EV_InventoryAddItem:
			syncInventory(param);
			break;
		case EV_Restart:
			init();
			break;
		case EV_ResolutionChanged:
			windowPositionAutoMove();
			Me.SetTimer(TIME_ID, TIME_DELAY);
			break;
		case EV_ShortcutkeyassignChanged:
			windowPositionAutoMove();
			break;
	}
}

/**
 *  ��ź, ����ź ���� �߰� ����!
 **/
function beginSoulShotUpdateHandle(string param)
{
	local int i;

	ParamToItemInfo(param, weaponItemInfo);

	// �˸��� ������� �ϴ� ��ź, ����ź�� ��, �ʱ�ȭ
	showNoticeNum = 0;

	//Debug("-->"@ weaponItemInfo.ID.ClassID);
	//Debug("-> beginSoulShotUpdateHandle" @ param);

	// ���� ������Ʈ
	updateSlotWeapon(weaponItemInfo);

	for(i = 0; i < 4; i++)
	{
		showTextureCounter(false, true, i + 1);
		showTextureCounter(false, false, i + 1);
	}

	windowPositionAutoMove();

	//checkSlotShowState();
}

// ���⳪ �� ��ȯ ���¿� ���� ��ź ���� �����츦 ���̰�, �Ⱥ��̰�
function checkSlotShowState()
{
	if ( GetGameStateName() != "GAMINGSTATE" )
		return;

	if ( YetiPCModeChangeWndScript.isYetiMode() )
	{
		if ( Me.IsShowWindow() )
			Me.HideWindow();
		return;
	}
	else if ( !Me.IsShowWindow() )
		Me.ShowWindow();

	if ( !Me.IsShowWindow() )
		Me.ShowWindow();

	AutoPotionWndScript.windowPositionAutoMove();
	GetWindowHandle(getSlotPath(false, 1)).HideWindow();
	GetWindowHandle(getSlotPath(true, 1)).HideWindow();
	GetWindowHandle(getSlotPath(false, 3)).HideWindow();
	GetWindowHandle(getSlotPath(true, 3)).HideWindow();
	GetWindowHandle(getSlotPath(IsVertical(), 1)).ShowWindow();
	if(hasWeapon == false)
	{
		showTextureCounter(false, true, 1);
		showTextureCounter(false, true, 2);
		showTextureCounter(false, false, 1);
		showTextureCounter(false, false, 2);
	}

	// ��ȯ��, �� �� �� �ϳ��� ������..
	if (bBeforeSummon || bBeforePet)
	{
		GetWindowHandle(getSlotPath(IsVertical(), 3)).ShowWindow();
		//if(IsVertical())
		//{
		//	showTextureCounter(true, true, 3);
		//	showTextureCounter(true, true, 4);
		//}
		//else
		//{
		//	showTextureCounter(true, false, 3);
		//	showTextureCounter(true, false, 4);
		//}
	}
	else
	{
		GetWindowHandle(getSlotPath(false, 3)).HideWindow();
		GetWindowHandle(getSlotPath(true , 3)).HideWindow();
	}
	AutoPotionWndScript.windowPositionAutoMove();
}

/**
 *  ��ź, ����ź ���� �Ϸ�!
 **/
function endSoulShotUpdateHandle()
{
	bBeforeSummon = bSummonException();
	bBeforePet = class'UIDATA_PET'.static.IsHavePet();
	beforeWeaponInfo = weaponItemInfo;
}

function bool bSummonException()
{
	local bool bSummonFlag;
	local int nPlayClassID;

	if(getInstanceUIData().getIsLiveServer())
	{
		nPlayClassID = DetailStatusWnd(GetScript("DetailStatusWnd")).CurrentSubjobClassID;
		switch(nPlayClassID)
		{
			case 176:
			case 177:
			case 178:
				bSummonFlag = false;
				break;
			default:
				bSummonFlag = numToBool(class'UIDATA_PET'.static.GetSummonNum());
		}
	}
	else
	{
		bSummonFlag = numToBool(class'UIDATA_PET'.static.GetSummonNum());
	}
	return bSummonFlag;
}

/**
 * soulShotUpdateHandle
 *
 * int type : 1.����ź, 2.����ź, 3.�߼�����ź, 4.�߼� ����ź
 * int have : 0 ����,1 �ִ�.
 * int activate : 0 ��Ȱ��ȭ 1.Ȱ��ȭ
 * ItemInfo itemInfo : ������ ����.
 *
 **/
function soulShotUpdateHandle(string param)
{
	// 1~4�� ���� , ���� ����ź�� ���� �߳�?
	local int nType, nHave;

	// Ȱ��ȭ ���� (����, ����ź)
	local int nActivate;

	// String
	local string itemCountStr, toolTipStr, gradeName;
	local int nToolTipStringMessage;

	// ����, ����ź ����, ������ ��������
	local ItemInfo targetItemInfo, beforeTargetItemInfo;

	// ������ �ֺ��� ��¦�̴� ȿ�� ���� ���� ����
	local bool bTwinkleEffect;

	// ������ ID �ӽ������
	local ItemID tempItemID;
	local string gradeString, effectPath;

	// local string meiYouEffectUIParam;

	//bShowNotice = false;

	ParseInt  (param, "type", nType);
	ParseInt  (param, "have", nHave);
	ParseInt  (param, "activate", nActivate);

	ParamToItemInfo(param, targetItemInfo);

	// debug("->" @ targetItemInfo.Name @ " " @ targetItemInfo.AdditionalName @ " " @ targetItemInfo.ItemNum);

	//Debug("----------AutoShotItemWnd-----------------------------");
	//Debug("nType"      @ nType);
	//Debug("have"       @ nHave);
	//Debug("nActivate"  @ nActivate);
	//Debug("ItemClassID"@ targetItemInfo.ID.ClassID);
	//Debug("�������뿩�� "@ hasWeapon);

	//Debug("-> "@ class'UIDATA_PET'.static.GetSummonNum());
	//Debug("-> "@ class'UIDATA_PET'.static.IsHavePet());

	bPet = class'UIDATA_PET'.static.IsHavePet();
	bSummon = bSummonException();


	//  ������ �����쿡 �߰�
	if (nType > -1)
	{
		bTwinkleEffect = true;

		// Ȱ��, ��Ȱ�� ���
		if(nActivate == 1 || nActivate == 3)
		{
			targetItemInfo.IsToggle = true;
		}
		else
		{
			targetItemInfo.IsToggle = false;
		}
		//targetItemInfo.IsToggle = (nActivate == 1 || nActivate == 3) ? true : false; //numToBool(nActivate);

		// ������ ���Կ� ���� ������..
		if (getShotItemSlot(false, nType).GetItem(0, beforeTargetItemInfo))
		{
			// ���� ���� ������ ���� ������ ������ ClassID �� ���ٸ�..��¦�̸� �ȵȴ�.
			if (beforeTargetItemInfo.ID.ClassID == targetItemInfo.ID.ClassID)
			{
				if (targetItemInfo.ItemNum > 0) bTwinkleEffect = false;
			}
			else
			{
				// Debug("bTwinkleEffect" @ bTwinkleEffect);
				// ������ ����
				//GetItemWindowHandle( "AutoShotItemWnd.ShotItemSlot" $ nType).Clear();
				setItemSlot(nType, ITEM_CLEAR);
			}
		}
		else
		{
			if (targetItemInfo.ItemNum <= 0) bTwinkleEffect = false;
		}

		// ����ź, ����ź ���ٸ�..
		if (nHave <= 0)
		{
		}
		// ����ź, ����ź ������ �ִٸ�..
		else
		{
			//GetTextureHandle("AutoShotItemWnd.meiyou" $ nType).HideWindow();

			// pc
			if (nType == 1 || nType == 2)
			{
				if (hasWeapon)
				{
					if (targetItemInfo.ID.ClassID > 0)
					{
						if (beforeTargetItemInfo.ID.ClassID == targetItemInfo.ID.ClassID)
						{
							setItemSlot(nType, ITEM_SET, targetItemInfo);
						}
						else
						{
							setItemSlot(nType, ITEM_ADD, targetItemInfo);

							// ���� ���� �ɶ� ��¦ �Ÿ��� ȿ��
							effectPath = "AutoShotItemWnd.EffectSlot" $ nType;
							if(IsVertical()) effectPath = effectPath $ "_ver_AniTex";
							else effectPath = effectPath $ "_hor_AniTex";
							GetAnimTextureHandle(effectPath).Stop();
							GetAnimTextureHandle(effectPath).Play();
							HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
						}
					}
				}
				else
				{
					bTwinkleEffect = false;
				}
			}
			// ��, ����Ͼ�, ��ȯ��
			else if (nType == 3 || nType == 4)
			{
				// �ƹ��ų� �ϳ��� ���� �Ѵٸ�..
				if (bSummon || bPet)
				{
					if (targetItemInfo.ID.ClassID > 0)
					{
						// ��ź , ����ź ���� ���ο� ����..
						if (beforeTargetItemInfo.ID.ClassID == targetItemInfo.ID.ClassID)
						{
							setItemSlot(nType, ITEM_SET, targetItemInfo);
						}
						else
						{
							setItemSlot(nType, ITEM_ADD, targetItemInfo);

							// ���� ���� �ɶ� ��¦ �Ÿ��� ȿ��
							effectPath = "AutoShotItemWnd.EffectSlot" $ nType;
							if(IsVertical()) effectPath = effectPath $ "_ver_AniTex";
							else effectPath = effectPath $ "_hor_AniTex";
							GetAnimTextureHandle(effectPath).Stop();
							GetAnimTextureHandle(effectPath).Play();
							HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
						}
					}
					else
					{
						setItemSlot(nType, ITEM_CLEAR);
					}
				}
				else
				{
					bTwinkleEffect = false;

					// ��, ��ȯ���� ���ٸ�.. ���� ���� ���� ���Ե� ����.
					setItemSlot(nType, ITEM_CLEAR);
				}
			}
		}

		// 99�� �̻� �� ��� ���� ������ ����� ���� ǥ��
		if (GetItemWindowHandle( "AutoShotItemWnd.ShotItemSlot" $ nType).GetItemNum() > 0)
		{
			if (targetItemInfo.ItemNum > 99)
			{
				itemCountStr = "99+";
			}
			else
			{
				itemCountStr = String(targetItemInfo.ItemNum);
			}
		}
	}

	endSoulShotUpdateHandle();

	checkSlotShowState();
}

/**
 * �κ��丮, ��ź, ����ź ���Կ� �߰�, ����, ����
 * ITEM_ADD, ITEM_SET, ITEM_CLEAR
 **/
function setItemSlot(int nType, int nItemCommand, optional ItemInfo info)
{
	if (nItemCommand == ITEM_ADD)
	{
		getShotItemSlot(false, nType).AddItem(info);
		getShotItemSlot(true, nType).AddItem(info);

		setTextureCounter( true, nType, info.ItemNum);
		setTextureCounter(false, nType, info.ItemNum);

		if (info.ItemNum <= 0)
		{
			showTextureCounter(false, true, nType);
			showTextureCounter(false, false, nType);
		}
	}
	else if (nItemCommand == ITEM_SET)
	{
		getShotItemSlot(false, nType).SetItem(0, info);
		getShotItemSlot(true, nType).SetItem(0, info);

		setTextureCounter(true , nType, info.ItemNum);
		setTextureCounter(false, nType, info.ItemNum);

		if (info.ItemNum <= 0)
		{
			showTextureCounter(false, true, nType);
			showTextureCounter(false, false, nType);
		}
	}
	else if (nItemCommand == ITEM_CLEAR)
	{
		getShotItemSlot(true , nType).Clear();
		getShotItemSlot(false, nType).Clear();

		showTextureCounter(false, false, nType);
		showTextureCounter(false, true, nType);
	}
}

/**
 *
 * OnTimer
 *
 **/
function OnTimer(int timerID)
{
	// �ػ� ������ �� ������ ����ٰ� �ؼ� �̺�Ʈ ���� Ÿ�̹��� ������ Ȯ����
	// ���� ������ Ÿ�̸ӷ� ���� ó���� �ϵ��� �߰� �ߴ�.
	if (timerID == TIME_ID)
	{
		windowPositionAutoMove();
		Me.KillTimer(TIME_ID);
	}
}

/** ���� ���� */
function updateSlotWeapon(ItemInfo Info)
{
	weaponItemInfo = Info;
	if(Info.Id.ClassID > 0)
	{
		hasWeapon = true;
	}
	else
	{
		hasWeapon = false;
	}
}

function ExHideSubWnd ()
{
	HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
}

function OnClickItem( string strID, int index )
{
	local ItemInfo infItem, selectItemInfo;
	local array<ItemInfo> itemInfoArray;
	local int i, wndIndex;

	// Debug("strID" @ strID);
	// ��ź ���� 1~4 �� �ϳ� Ŭ��
	if (Left(strID, 12)  == "ShotItemSlot")
	{
		// Debug("mm: " @ int(Right(strID, 1)));

		wndIndex = int(Right(strID, 1));

		// clickShotcutItem(a_WindowHandle, X, Y);
		// Debug("��ź ���� index" @ wndIndex);

		// ��� ������ ������ �� Ŭ�� �ߴٸ� �ݴ´�.
		if (currentSelectSoulShotWndIndex == wndIndex && IsShowWindow("AutoShotItemWnd.AutoShotItemSubWnd"))
		{
			currentSelectSoulShotWndIndex = -1;
			HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
			return;
		}

		//ShotItemSlot1~4
		currentSelectSoulShotWndIndex = wndIndex;

		// 1~4 �� ��츸 â�� ����.
		if (currentSelectSoulShotWndIndex > 0 && currentSelectSoulShotWndIndex < 5)
		{
			GetAutoEquipShotList(currentSelectSoulShotWndIndex, itemInfoArray);
			//toggleWindow("AutoShotItemWnd.AutoShotItemSubWnd", true);
			ShowWindowWithFocus("AutoShotItemWnd.AutoShotItemSubWnd");

			// ����
			if (IsVertical())
			{
				GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.ArrowHor_Texture_SubWnd").HideWindow();
				GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.ArrowVer_Texture_SubWnd").ShowWindow();
				GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd").SetAnchor(getSlotPath(IsVertical(), wndIndex) $ ".ShotItemSlot" $ wndIndex, "TopRight", "TopLeft", -135, 0);
			}
			// ����
			else
			{
				GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.ArrowHor_Texture_SubWnd").ShowWindow();
				GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.ArrowVer_Texture_SubWnd").HideWindow();
				GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd").SetAnchor(getSlotPath(IsVertical(), wndIndex) $ ".ShotItemSlot" $ wndIndex, "TopLeft", "TopLeft", -62, -95);
			}
		}
		else
		{
			currentSelectSoulShotWndIndex = -1;
			HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
		}

		// Debug("itemInfoArray Len : " @ itemInfoArray.Length);

		if (itemInfoArray.Length > 0)
		{
			// ���� ���Կ� ���� �ִ� ��ź ������ ���� ���
			if(getShotItemSlot(false, wndIndex).GetItemNum() > 0)
				getShotItemSlot(false, wndIndex).GetItem(0, infItem);

			GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd").Clear();
			for (i = 0; i < itemInfoArray.Length; i++)
			{
				// ���� ��ź ���Կ� ���� �ִ� ���� �ƴ� ��� ��Ͽ� �ִ´�.
				if (infItem.Id.ClassId != itemInfoArray[i].Id.ClassID)
				{
					setShowItemCount(itemInfoArray[i]);
					GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd").AddItem(itemInfoArray[i]);
				}
			}
		}
	}
	// ��ź ���� ������ ������ Ŭ��
	else if(strID == "AutoShotItem_ItemWnd_SubWnd")
	{
		// Debug("getShotItemSlot(false, wndIndex).GetItemNum()" @ getShotItemSlot(false, currentSelectSoulShotWndIndex).GetItemNum());

		GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd").GetItem(index, selectItemInfo);

		if (selectItemInfo.ID.ClassID > 0 && currentSelectSoulShotWndIndex != -1)
		{
			// Debug("���� " @ currentSelectSoulShotWndIndex);
			// Debug("��ź ���� ClassID " @ infItem.ID.ClassID);
			SoulShotSlotSelected(currentSelectSoulShotWndIndex, selectItemInfo.ID.ClassID);
			HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
		}
	}
}

function syncInventory (string param)
{
	local array<ItemInfo> itemInfoArray;
	local int Index;
	local int i;
	local ItemInfo infItem;
	local ItemInfo updatedItemInfo;
	local string Type;
	local bool bPassItem;
	local ItemWindowHandle shotSubInvenWnd;

	if ( IsShowWindow("AutoShotItemWnd.AutoShotItemSubWnd") == False )
		return;

	shotSubInvenWnd = GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd");
	if ( (currentSelectSoulShotWndIndex > 0) && (currentSelectSoulShotWndIndex < 5) )
	{
		GetAutoEquipShotList(currentSelectSoulShotWndIndex,itemInfoArray);
		if ( getShotItemSlot(False,currentSelectSoulShotWndIndex).GetItemNum() > 0 )
		{
			getShotItemSlot(False,currentSelectSoulShotWndIndex).GetItem(0,infItem);
			Index = shotSubInvenWnd.FindItemByClassID(infItem.Id);
			if ( Index > -1 )
				shotSubInvenWnd.DeleteItem(Index);
		}
	}
	ParamToItemInfo(param,updatedItemInfo);
	ParseString(param,"type",Type);

	//ShotItemSlot1~4
	switch(currentSelectSoulShotWndIndex)
	{
		case 1 : GetAutoEquipShotList(1, itemInfoArray); break;
		case 2 : GetAutoEquipShotList(2, itemInfoArray); break;
		case 3 : GetAutoEquipShotList(3, itemInfoArray); break;
		case 4 : GetAutoEquipShotList(4, itemInfoArray); break;
	}

	for ( i = 0; i < itemInfoArray.Length; i++ )
	{
		if ( itemInfoArray[i].Id.ClassID == updatedItemInfo.Id.ClassID )
		{
			bPassItem = True;
			break;
		}
	}

	if ( bPassItem == False )
		return;

	Index = shotSubInvenWnd.FindItemByClassID(updatedItemInfo.Id);
	if ( Type == "delete" )
	{
		if ( Index > -1 )
			shotSubInvenWnd.DeleteItem(Index);
	}
	else
	{
		setShowItemCount(updatedItemInfo);
		if ( Index > -1 )
			shotSubInvenWnd.SetItem(Index,updatedItemInfo);
		else if ( infItem.Id.ClassID != updatedItemInfo.Id.ClassID )
			shotSubInvenWnd.AddItem(updatedItemInfo);
	}
}

function OnRButtonUp( WindowHandle a_WindowHandle, int X, int Y )
{
	clickShotcutItem(a_WindowHandle, X, Y);
}

/**
 *  ����ź, ����ź Ȱ��ȭ, ��Ȱ�� ó��
 **/
function clickShotcutItem( WindowHandle a_WindowHandle, int X, int Y )
{
	local string targetStr, targetID;
	local itemInfo targetItemInfo;

	targetStr = a_WindowHandle.GetWindowName();
	targetID = Mid(targetStr, len(targetStr) -1, len(targetStr));

	switch (targetID)
	{
		case "1" :
		case "2" :
		case "3" :
		case "4" : if(GetItemWindowHandle( "AutoShotItemWnd.ShotItemSlot" $ targetID).GetItem(0, targetItemInfo))
				   {
					  SoulShotSlotClicked(int(targetID), targetItemInfo.ID.ClassID);
					  //Me.SetFocus();
				   }
				   break;
	}
}

// ��ź ������ ������ ���
function ItemWindowHandle getShotItemSlot(bool IsShortcutWndVertical, int slotIndex)
{
	local ItemWindowHandle itemWnd;

	// 1,2
	if(IsShortcutWndVertical)
	{
		// ��
		if (slotIndex > 2)
		{
			itemWnd = GetItemWindowHandle( "AutoShotItemWnd.AutoShotItemWnd_VerWnd.PetSlotGroupWnd_VerWnd.ShotItemSlot" $ slotIndex);
		}
		// ���� (�÷��̾�)
		else
		{
			itemWnd = GetItemWindowHandle( "AutoShotItemWnd.AutoShotItemWnd_VerWnd.WeaponSlotGroupWnd_VerWnd.ShotItemSlot" $ slotIndex);
		}
	}
	else
	{
		// ��
		if (slotIndex > 2)
		{
			itemWnd = GetItemWindowHandle( "AutoShotItemWnd.AutoShotItemWnd_HorWnd.PetSlotGroupWnd_HorWnd.ShotItemSlot" $ slotIndex);
		}
		// ���� (�÷��̾�)
		else
		{
			itemWnd = GetItemWindowHandle( "AutoShotItemWnd.AutoShotItemWnd_HorWnd.WeaponSlotGroupWnd_HorWnd.ShotItemSlot" $ slotIndex);
		}
	}

	return itemWnd;
}

// ��ź ���� �����ִ� �ؽ��� show, hide
function setTextureCounter(bool IsShortcutWndVertical, int slotIndex, INT64 count)
{
	local string tempStr, valueStr;

	if (count > 99) valueStr = "99+";
	else valueStr = String(count);

	showTextureCounter(false, IsShortcutWndVertical, slotIndex);

	tempStr = getSlotPath(IsShortcutWndVertical, slotIndex);

	switch(Len(valueStr))
	{
		// 99+
		case 3 : showTextureCounter(true, IsShortcutWndVertical, slotIndex);
				 GetTextureHandle(tempStr $ "." $ "counter100_slot" $ slotIndex $ "_texture").SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_9");
				 GetTextureHandle(tempStr $ "." $ "counter10_slot" $ slotIndex $ "_texture").SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_9");
				 GetTextureHandle(tempStr $ "." $ "counter1_slot" $ slotIndex $ "_texture").SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_Plus");
				 break;

		// 10�ڸ�
		case 2 : GetTextureHandle(tempStr $ "." $ "counter10_slot" $ slotIndex $ "_texture").ShowWindow();
				 GetTextureHandle(tempStr $ "." $ "counter10_slot" $ slotIndex $ "_texture").SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_" $ Left(valueStr, 1));

		// 1�ڸ�
		case 1 : GetTextureHandle(tempStr $ "." $ "counter1_slot" $ slotIndex $ "_texture").ShowWindow();
				 GetTextureHandle(tempStr $ "." $ "counter1_slot" $ slotIndex $ "_texture").SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_" $ Right(valueStr, 1));
	}
}

// ��ź ���� �����ִ� �ؽ��� show, hide
function showTextureCounter(bool bShow, bool IsShortcutWndVertical, int SlotIndex)
{
	local string tempStr;

	tempStr = getSlotPath(IsShortcutWndVertical, SlotIndex);
	if(bShow)
	{
		GetTextureHandle(tempStr $ "." $ "counter1_slot" $ SlotIndex $ "_texture").ShowWindow();
		GetTextureHandle(tempStr $ "." $ "counter10_slot" $ SlotIndex $ "_texture").ShowWindow();
		GetTextureHandle(tempStr $ "." $ "counter100_slot" $ SlotIndex $ "_texture").ShowWindow();
	}
	else
	{
		GetTextureHandle(tempStr $ "." $ "counter1_slot" $ SlotIndex $ "_texture").HideWindow();
		GetTextureHandle(tempStr $ "." $ "counter10_slot" $ SlotIndex $ "_texture").HideWindow();
		GetTextureHandle(tempStr $ "." $ "counter100_slot" $ SlotIndex $ "_texture").HideWindow();
	}
}


// ��ź ���� ��θ� �����Ͽ� ��Ʈ���� ����
function string getSlotPath(bool IsShortcutWndVertical, int SlotIndex)
{
	local string tempStr;

	tempStr = "AutoShotItemWnd";
	if(IsShortcutWndVertical)
	{
		tempStr = tempStr $ ".AutoShotItemWnd_VerWnd";
		if(SlotIndex > 2)
		{
			tempStr = tempStr $ ".PetSlotGroupWnd_VerWnd";
		}
		else
		{
			tempStr = tempStr $ ".WeaponSlotGroupWnd_VerWnd";
		}
	}
	else
	{
		tempStr = tempStr $ ".AutoShotItemWnd_HorWnd";
		if(SlotIndex > 2)
		{
			tempStr = tempStr $ ".PetSlotGroupWnd_HorWnd";
		}
		else
		{
			tempStr = tempStr $ ".WeaponSlotGroupWnd_HorWnd";
		}
	}

	return tempStr;
}

function bool IsVertical()
{
	return ShortcutWndScript.IsVertical();
}
