class HomunculusWndEnchantCommunionDiceItem extends UICommonAPI;

const TWEENKEYHIDE= 12;
const TWEENKEYSHOW= 11;
const TWEENKEYNONE= 0;
const ROTATEMAX= 4;
const DICETIME_FIRST= 100;
const DICE_H= 120;

var WindowHandle Me;
var string m_WindowName;
var int Index;
var TextureHandle dice0;
var TextureHandle DiceSwap00;
var TextureHandle DiceSwap01;
var AnimTextureHandle DiceComplete;
var AnimTextureHandle DiceSame;
var TextureHandle FlagMask_tex;
var int dicePointSwap0;
var int dicePointSwap1;
var int diceTime0;
var int diceNumb0;
var int diceTarget0;
var bool isDiceSame;
var int currentDiceIndex;
var L2UITween l2uiTweenScript;
var int time_Add;
var HomunculusWndEnchantCommunionDice homunculusWndEnchantCommunionDiceScript;

function Init(string WindowName)
{
	m_WindowName = WindowName;
	Me = GetWindowHandle(m_WindowName);
	Index = int(Right(m_WindowName, 1));
	DiceSwap00 = GetTextureHandle(m_WindowName $ ".DiceAni.DiceSwap00");
	DiceSwap01 = GetTextureHandle(m_WindowName $ ".DiceAni.DiceSwap01");
	DiceComplete = GetAnimTextureHandle(m_WindowName $ ".DiceComplete");
	DiceSame = GetAnimTextureHandle(m_WindowName $ ".DiceSame");
	FlagMask_tex = GetTextureHandle(m_WindowName $ ".DiceAni.FlagMask_tex");
	switch(Index)
	{
		case 0:
			FlagMask_tex.SetTexture("L2UI_EPIC.HomunCulusWnd.HomunDiceBG_SystemMask");
			break;
		case 1:
		case 2:
			break;
	}
	DiceComplete.Stop();
	homunculusWndEnchantCommunionDiceScript = HomunculusWndEnchantCommunionDice(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionDice"));
	l2uiTweenScript = L2UITween(GetScript("L2UITween"));
	time_Add =	-DICETIME_FIRST / (ROTATEMAX + 6);
	currentDiceIndex = TWEENKEYSHOW;
}

function Clear()
{
	l2uiTweenScript.StopTween("HomunculusWnd." $ m_WindowName,TWEENKEYNONE);
	l2uiTweenScript.StopTween("HomunculusWnd." $ m_WindowName,TWEENKEYHIDE);
	l2uiTweenScript.StopTween("HomunculusWnd." $ m_WindowName,TWEENKEYSHOW);
	if ( currentDiceIndex == TWEENKEYSHOW )
	{
		DiceSwap00.MoveC(0,0);
		DiceSwap01.MoveC(0, -DICE_H);
	} else {
		DiceSwap00.MoveC(0, -DICE_H);
		DiceSwap01.MoveC(0,0);
	}
	diceTime0 = DICETIME_FIRST;
	diceNumb0 = 0;
	DiceComplete.Stop();
	DiceSame.Stop();
	isDiceSame = False;
}

function OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case l2uiTweenScript.TWEENEND:
			HandleComplete(int(param));
			break;
	}
}

function ShowSame()
{
	if(isDiceSame)
	{
		DiceSame.SetLoopCount(99999);
		DiceSame.Play();
	}
}

function HandleComplete(int Id)
{
	if ( diceNumb0 >= ROTATEMAX )
	{
		if ( diceTarget0 == dicePointSwap0 + 1 )
		{
			if ( Id != TWEENKEYNONE )
			{
				Debug("HandleComplete" @ string(diceTarget0) @ string(dicePointSwap0) @ string(Index) @ string(Id));
				DiceComplete.Play();
				homunculusWndEnchantCommunionDiceScript.CompletedDice();
			}
			return;
		}
	}
	if(Id == 12)
	{
		dicePointSwap0++;
		if ( dicePointSwap0 == 6 )
		{
			dicePointSwap0 = 0;
		}
		DiceSwap00.SetTexture("L2UI_CH3.Br_Score" $ string(dicePointSwap0 + 1));
		currentDiceIndex = TWEENKEYSHOW;
		MakeChargeObjectHide(DiceSwap01);
		MakeChargeObjectShow(DiceSwap00,currentDiceIndex);
	} else {
		if ( Id == TWEENKEYSHOW )
		{
			diceTime0 = diceTime0 + time_Add;
			diceNumb0++;
			dicePointSwap0++;
			if ( dicePointSwap0 == 6 )
			{
				dicePointSwap0 = 0;
			}
			DiceSwap01.SetTexture("L2UI_CH3.Br_Score" $ string(dicePointSwap0 + 1));
			currentDiceIndex = TWEENKEYHIDE;
			MakeChargeObjectShow(DiceSwap01);
			MakeChargeObjectHide(DiceSwap00, currentDiceIndex);
		}
	}
}

function MakeChargeObjectHide(TextureHandle Target, optional int Id)
{
	MakeChargeObject(Target,Id);
}

function MakeChargeObjectShow(TextureHandle Target, optional int Id)
{
	Target.MoveC(0, -DICE_H);
	MakeChargeObject(Target,Id);
}

function Dice()
{
	if ( currentDiceIndex == TWEENKEYSHOW )
	{
		MakeChargeObjectShow(DiceSwap01);
		MakeChargeObjectHide(DiceSwap00,TWEENKEYHIDE);
	} else {
		MakeChargeObjectHide(DiceSwap01);
		MakeChargeObjectShow(DiceSwap00,TWEENKEYSHOW);
	}
}

function SetTargetNum (int targetNum)
{
	isDiceSame = false;
	diceTarget0 = targetNum;
}

function MakeChargeObject(TextureHandle Target, int Id)
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = "HomunculusWnd." $ m_WindowName;
	tweenObjectData.Id = Id;
	tweenObjectData.Target = Target;
	tweenObjectData.Duration = diceTime0;
	tweenObjectData.MoveY = 120.0;
	tweenObjectData.ease = l2uiTweenScript.easeType.EASENONE;
	l2uiTweenScript.AddTweenObject(tweenObjectData);
}

defaultproperties
{
}
