class AbilitySlot extends UICommonAPI;

var WindowHandle Me;
var TextureHandle RelationShipLineTexture;
var TextureHandle skillIconTexture;
var TextureHandle Panel1Texture;
var TextureHandle SlotStateTexture;
var ButtonHandle SlotButton;
var TextureHandle DisableTexture;
var AnimTextureHandle SlotAnimTexture;
var TextBoxHandle UseApTextbox;
var AbilityUIWnd rootScript;
var int Category;
var int slotX;
var int slotY;
var int apApplied;
var int apUse;
var AbilityItemUIData Data;

function OnLoad();

function Init(WindowHandle Owner, AbilityUIWnd rootScr, int nCategory, int nSlotx, int nSlotY)
{
	local string ownerFullPath;

	rootScript = rootScr;
	ownerFullPath = Owner.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	RelationShipLineTexture = GetTextureHandle(ownerFullPath $ ".RelationShipLineTexture");
	skillIconTexture = GetTextureHandle(ownerFullPath $ ".skillIconTexture");
	Panel1Texture = GetTextureHandle(ownerFullPath $ ".Panel1Texture");
	SlotStateTexture = GetTextureHandle(ownerFullPath $ ".SlotStateTexture");
	SlotButton = GetButtonHandle(ownerFullPath $ ".SlotButton");
	DisableTexture = GetTextureHandle(ownerFullPath $ ".DisableTexture");
	SlotAnimTexture = GetAnimTextureHandle(ownerFullPath $ ".SlotAnimTexture");
	UseApTextbox = GetTextBoxHandle(ownerFullPath $ ".UseApTextbox");
	SlotAnimTexture.HideWindow();
	Category = nCategory;
	slotX = nSlotx;
	slotY = nSlotY;
	// End:0x248
	if(class'UIDataManager'.static.GetAbilityItem(nCategory + 1, nSlotY, nSlotx, Data))
	{
		Me.ShowWindow();
		skillIconTexture.SetTexture(Data.Icon);
		// End:0x22C
		if(Data.IconPanel == "" || Data.IconPanel == "none")
		{
			Panel1Texture.SetTexture("L2UI_ct1.Button.emptyBtn");			
		}
		else
		{
			Panel1Texture.SetTexture(Data.IconPanel);
		}		
	}
	else
	{
		Me.HideWindow();
		return;
	}
	_updateSlot();	
}

function setSlotState(int nState)
{
	// End:0x1D
	if(nState == 0)
	{
		SlotStateTexture.HideWindow();		
	}
	else
	{
		switch(Category)
		{
			// End:0x6B
			case 0:
				SlotStateTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityEffectRedAni00001");
				// End:0x100
				break;
			// End:0xB3
			case 1:
				SlotStateTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityEffectBlueAni00001");
				// End:0x100
				break;
			// End:0xFD
			case 2:
				SlotStateTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityEffectGreenAni00001");
				// End:0x100
				break;
		}
		SlotStateTexture.ShowWindow();
	}	
}

function CustomTooltip getCustomToolTip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local SkillInfo SkillInfo;
	local int i;
	local string Desc;

	drawListArr[drawListArr.Length] = addDrawItemText(Data.Name, GTColor().Orange2, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	// End:0xD8
	if(Data.RequireCount > 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3165) $ " : ", GTColor().White, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemText(getCategoryName(Category) $ " (" $ string(Data.RequireCount) $ "P)", GTColor().Red2, "", false, true);
	}
	// End:0x198
	if(Data.RequireAbilityID > 0)
	{
		GetSkillInfo(Data.RequireAbilityID, 1, 0, SkillInfo);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3166) $ " : ", GTColor().White, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemText(SkillInfo.SkillName $ " " $ GetSystemString(88) $ string(rootScript._findMaxRequireAbilityLev(Category, Data.RequireAbilityID)), GTColor().Red2, "", false, true);
	}

	// End:0x2FE [Loop If]
	for(i = 0; i < Data.LevelDesc.Length; i++)
	{
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		Desc = Substitute(Data.LevelDesc[i], "<br>", "\\n", false);
		// End:0x28F
		if(_getCurrentAP() == i + 1)
		{
			drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(88) $ string(i + 1), GTColor().Yellow, "", true, true);
			drawListArr[drawListArr.Length] = addDrawItemText(Desc, GTColor().Yellow, "", true, false);
			// [Explicit Continue]
			continue;
		}
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(88) $ string(i + 1), GTColor().BrightGray, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemText(Desc, GTColor().BrightGray, "", true, false);
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;	
}

function string getCategoryName(int nCategory)
{
	local string rName;

	switch(nCategory)
	{
		// End:0x1F
		case 0:
			rName = GetSystemString(3153);
			// End:0x53
			break;
		// End:0x37
		case 1:
			rName = GetSystemString(3152);
			// End:0x53
			break;
		// End:0x50
		case 2:
			rName = GetSystemString(14294);
			// End:0x53
			break;
		// End:0xFFFF
		default:
			break;
	}
	return rName;	
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	// End:0x0D
	if(! _getIsLearn())
	{
		return;
	}
	// End:0x32
	if(Data.RequireCount > rootScript._getAPCategory(Category))
	{
		return;
	}
	// End:0x1B1
	if((apUse + apApplied < Data.AbilityLev) && rootScript._getAPTotal() > 0)
	{
		apUse++;
		rootScript._useAP(Category);
		_updateSlot();
		rootScript._updateCategory(Category);
		switch(Category)
		{
			// End:0xE7
			case 0:
				SlotAnimTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityGetEffectRedAni01");
				// End:0x17C
				break;
			// End:0x12F
			case 1:
				SlotAnimTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityGetEffectBlueAni01");
				// End:0x17C
				break;
			// End:0x179
			case 2:
				SlotAnimTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityGetEffectGreenAni01");
				// End:0x17C
				break;
		}
		AnimTexturePlay(SlotAnimTexture, true, 1);
		rootScript._callBackSlotClick(Category, slotX, slotY, Data.AbilityID);
	}	
}

event OnRClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	// End:0x2A
	if(! rootScript._checkEnableRClick(Category, slotY, Data.AbilityID))
	{
		return;
	}
	// End:0x92
	if(apUse > 0)
	{
		apUse--;
		rootScript._removeAP(Category);
		_updateSlot();
		rootScript._updateCategory(Category);
		rootScript._callBackSlotClick(Category, slotX, slotY, Data.AbilityID);
	}	
}

function _cancelAP()
{
	apUse = 0;
	_updateSlot();	
}

function _initAP(bool bNoUseAPInit)
{
	// End:0x13
	if(bNoUseAPInit == false)
	{
		apUse = 0;
	}
	apApplied = 0;
	_updateSlot();	
}

function bool _isShow()
{
	return Me.IsShowWindow();	
}

function bool _getIsLearn()
{
	return Me.IsShowWindow() && ! DisableTexture.IsShowWindow();	
}

function _updateSlot()
{
	UseApTextbox.SetText(string(apUse + apApplied) $ "/" $ string(Data.AbilityLev));
	// End:0x6B
	if(apUse + apApplied == Data.AbilityLev)
	{
		UseApTextbox.SetTextColor(GetColor(255, 221, 102, 255));		
	}
	else
	{
		UseApTextbox.SetTextColor(GetColor(255, 255, 255, 255));
	}
	// End:0x100
	if((Data.RequireCount <= rootScript._getAPCategory(Category)) && rootScript._findCurrentAP(Category, Data.RequireAbilityID) >= rootScript._findMaxRequireAbilityLev(Category, Data.RequireAbilityID))
	{
		DisableTexture.HideWindow();		
	}
	else
	{
		DisableTexture.ShowWindow();
	}
	// End:0x124
	if(apApplied > 0)
	{
		setSlotState(1);		
	}
	else
	{
		setSlotState(0);
	}
	// End:0x265
	if(Data.RequireAbilityID > 0)
	{
		RelationShipLineTexture.ShowWindow();
		// End:0x19A
		if(DisableTexture.IsShowWindow())
		{
			RelationShipLineTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityArrowDisable");			
		}
		else
		{
			switch(Category)
			{
				// End:0x1DF
				case 0:
					RelationShipLineTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityArrowRed");
					// End:0x262
					break;
				// End:0x21E
				case 1:
					RelationShipLineTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityArrowBlue");
					// End:0x262
					break;
				// End:0x25F
				case 2:
					RelationShipLineTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityArrowGreen");
					// End:0x262
					break;
			}
		}		
	}
	else
	{
		RelationShipLineTexture.HideWindow();
	}
	SlotButton.SetTooltipCustomType(getCustomToolTip());	
}

function int _getMaxAbilityLev(int RequireAbilityID)
{
	// End:0x1F
	if(Data.AbilityID == RequireAbilityID)
	{
		return Data.AbilityLev;
	}	
}

function int _getRequireAbilityID()
{
	return Data.RequireAbilityID;	
}

function int _getAbilityLev()
{
	return Data.AbilityLev;	
}

function int _getRequireCount()
{
	return Data.RequireCount;	
}

function int _getAbilityID()
{
	return Data.AbilityID;	
}

function int _getCurrentAP()
{
	return apApplied + apUse;	
}

function _setAppliedAP(int updateAp)
{
	apApplied = updateAp;
	// End:0x16
	if(apUse > 0)
	{
	}
	apUse = 0;
	rootScript._setCategoryApApplied(Category, updateAp);
	_updateSlot();	
}

function int _getCurrentAppliedAP()
{
	return apApplied;	
}

function int _getCurrentUseAP()
{
	return apUse;	
}

defaultproperties
{
}
