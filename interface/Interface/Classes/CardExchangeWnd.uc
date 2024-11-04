class CardExchangeWnd extends UICommonAPI;

const Red = true;
const Yellow = false;

var WindowHandle Me;
var TextBoxHandle DescTitle_TextBox;

// 카드 이벤트 타입 번호 각, 이벤트 마다 고유 번호
var int currentCardEventType;
var int currentRewardListID;

var int currentRewardListCount;
var int currentCardCount;

// 카드 가로 세로 최다 카드수 
var int maxCardWCount;
var int maxCardHCount;

var array<int> cardRewardListIDArray;

function OnRegisterEvent()
{
	RegisterEvent(EV_CardRewardStart);
	RegisterEvent(EV_CardListProperty);
	RegisterEvent(EV_CardProperty);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle("CardExchangeWnd");
	DescTitle_TextBox = GetTextBoxHandle("CardExchangeWnd.DescTitle_TextBox");
}

function OnEvent(int Event_ID, string param)
{
	//Debug( "Card OnEvent " @ Event_ID  @ param);

	if(Event_ID == EV_CardRewardStart)
	{
		Debug("EV_CardRewardStart " @ param);
		cardRewardStartHandler(param);
	}
	else if(Event_ID == EV_CardListProperty)
	{
		Debug("EV_CardListProperty " @ param);
		cardListPropertyHandler(param);
	}
	else if(Event_ID == EV_CardProperty)
	{
		Debug("EV_CardProperty " @ param);
		cardPropertyHandler(param);
	}
}

function cardRewardStartHandler(string a_Param)
{
	ParseInt(a_Param, "CardEventType", currentCardEventType);
	ParseInt(a_Param, "RewardListNum", maxCardHCount);

	// 카드셋 대략, 7개 배열 만들어 놓고.. 현재는 7개
	// 초기화
	cardRewardListIDArray.Length = 0;
	// 7개
	cardRewardListIDArray.Length = 7;
	currentRewardListCount = 0;
	maxCardWCount = 0;
}

function cardListPropertyHandler(string a_Param)
{
	local int nRewardListID, nRewardCardNum, nIsEnableReward;
	local string subTitleStr;

	ParseInt(a_Param, "RewardListID", nRewardListID);
	ParseInt(a_Param, "RewardCardNum", nRewardCardNum);
	ParseInt(a_Param, "IsEnableReward", nIsEnableReward);
	GetSubTitle(currentCardEventType, nRewardListID, subTitleStr);
	currentRewardListID = nRewardListID;
	cardRewardListIDArray[currentRewardListCount] = nRewardListID;

	// 카드 라인 수 증가
	currentRewardListCount++;
	currentCardCount = 1;

	// 카드 셋 제목 세팅
	setCardSetText(currentRewardListCount, subTitleStr);

	// 일단 카드셋 한줄을 모두 숨기고..
	showCardLine(currentRewardListCount, false);

	checkEnableReceiveButton(currentRewardListCount, nIsEnableReward);

	// 가로 최대 줄 지정
	if(maxCardWCount < nRewardCardNum)
	{
		maxCardWCount = nRewardCardNum;
	}

	//Debug("currentRewardListCount" @ currentRewardListCount);
	//Debug("maxCardHCount" @ maxCardHCount);

	// 마지막 줄이면 창 사이즈 변경
	if(currentRewardListCount >= maxCardHCount)
	{
		setUISize(maxCardWCount, maxCardHCount);
		Me.ShowWindow();
		Me.SetFocus();
	}
}

function checkEnableReceiveButton(int nSetNum, int nIsEnableReward)
{
	GetButtonHandle("CardExchangeWnd.CardList0" $ nSetNum $ "_Wnd.Receive_Button").SetEnable(numToBool(nIsEnableReward));
}

function cardPropertyHandler(string a_Param)
{
	local int nCardID, nCardNeededNum, nCardNum;
	local string texNameStr;
	local bool bHasCard;

	ParseInt(a_Param, "CardID", nCardID);
	ParseInt(a_Param, "CardNeededNum", nCardNeededNum);
	ParseInt(a_Param, "CardNum", nCardNum);

	GetRewardCardTexName(currentCardEventType, currentRewardListID, nCardID, texNameStr);

	//Debug("currentCardEventType" @ currentCardEventType);
	//Debug("currentRewardListID" @ currentRewardListID);
	//Debug("nCardID" @ nCardID);
	//Debug("texNameStr" @ texNameStr);
	
	//Debug("nCardNeededNum" @ nCardNeededNum);
	//Debug("nCardNum" @ nCardNum);

	if(nCardNum >= nCardNeededNum)
	{
		bHasCard = true;
	}
	else
	{
		bHasCard = false;
	}
	setCardInfo(currentRewardListCount, currentCardCount, nCardID, bHasCard, texNameStr);

	currentCardCount++;
}

function setCardInfo(int nSetNum, int nCardNum, int nCardID, bool bHasCard, string cardTexture)
{
	showCard(nSetNum, nCardNum, true);

	//Debug("cardTexture :" @ cardTexture);
	GetTextureHandle("CardExchangeWnd.CardList0" $ nSetNum $ "_Wnd.Card0" $ nCardNum $ "_Wnd.Card_Texture").SetTexture(cardTexture);
	GetButtonHandle("CardExchangeWnd.CardList0" $ nSetNum $ "_Wnd.Card0" $ nCardNum $ "_Wnd.Card_Btn").SetTooltipCustomType(getCardToolTip(GetItemInfoByClassID(nCardID)));

	//Debug("bHasCard"  @ bHasCard);

	// 카드 소유 여부
	if(bHasCard)
	{
		GetTextureHandle("CardExchangeWnd.CardList0" $ nSetNum $ "_Wnd.Card0" $ nCardNum $ "_Wnd.Card_Disable_Texture").HideWindow();
	}
	else
	{
		GetTextureHandle("CardExchangeWnd.CardList0" $ nSetNum $ "_Wnd.Card0" $ nCardNum $ "_Wnd.Card_Disable_Texture").ShowWindow();
	}
}

/**
 * 카드용 커스텀툴팁(서브잡클래스변환버튼에사용)
 **/
function CustomTooltip getCardToolTip(ItemInfo item)
{
	local CustomTooltip m_Tooltip;

	m_Tooltip.DrawList.Length = 2;
	//m_Tooltip.MinimumWidth = 210;//160->183px 로 수정됨
	m_Tooltip.DrawList[0].eType = DIT_TEXT;
	m_Tooltip.DrawList[0].t_color.R = 255;
	m_Tooltip.DrawList[0].t_color.G = 255;
	m_Tooltip.DrawList[0].t_color.B = 255;
	m_Tooltip.DrawList[0].t_color.A = 255;

	m_Tooltip.DrawList[0].t_strText = item.Name;
	m_Tooltip.DrawList[0].bLineBreak = true;

	m_Tooltip.DrawList[1].eType = DIT_TEXTURE;
	m_Tooltip.DrawList[1].u_nTextureWidth = 242;
	m_Tooltip.DrawList[1].u_nTextureHeight = 344;
	m_Tooltip.DrawList[1].u_strTexture = item.tooltipTexutre;
	m_Tooltip.DrawList[1].bLineBreak = true;

	return m_Tooltip;
}

// 보상 받기 버튼
function OnClickButtonWithHandle(ButtonHandle ButtonHandle)
{
	switch(ButtonHandle.GetWindowName())
	{
		case "Receive_Button":
			OnReceive_ButtonClick(ButtonHandle.GetParentWindowName());
			break;
	}
}

function OnReceive_ButtonClick(string parentWndName)
{
	local int btnIndex;

	Debug("parentWndName" @ parentWndName);

	btnIndex = int(Mid(parentWndName, 9, 1)) - 1;

	if(cardRewardListIDArray[btnIndex] > 0)
	{
		Debug("-- RequestCardReward -> 카드셋 id " @ cardRewardListIDArray[btnIndex]);
		RequestCardReward(cardRewardListIDArray[btnIndex]);
	}
}

// 실제 윈도우 사이즈 변경
function setUISize(int nW, int nH)
{
	// 전체 윈도우 사이즈 조절
	Me.SetWindowSize(getWindowSizeW(nW), getWindowSizeH(nH));
	//setAllWCardCount(nW);
	hideCardSet(nH);
	showCardSet(nH);

	// 윈도우 사이즈가 변경되면 위치 갱신을 위해서, 다시 텍스트를 적용 시킨다.
	DescTitle_TextBox.SetText(GetSystemString(3128));
}

function int getWindowSizeW(int cardCount)
{
	//54씩 빼면 될듯.
	if(cardCount == 7)
	{
		return 543;
	}
	else if(cardCount == 6)
	{
		return 489;
	}
	else
	{
		return 435;
	}
}

function int getWindowSizeH(int cardSetLine)
{
	if(cardSetLine == 5)
	{
		return 639;
	}
	else if(cardSetLine == 4)
	{
		return 531;
	}
	else
	{
		return 423;
	}
}

// 세로 카드 세트, 숨기기
function hideCardSet(int nUseCardSet)
{
	switch(nUseCardSet)
	{
		case 1:
		case 2:
			GetWindowHandle("CardExchangeWnd.CardList03_Wnd").HideWindow();
		case 3:
			GetWindowHandle("CardExchangeWnd.CardList04_Wnd").HideWindow();
		case 4:
			GetWindowHandle("CardExchangeWnd.CardList05_Wnd").HideWindow();
		//case 5:
		//	GetWindowHandle( "CardExchangeWnd.CardList06_Wnd" ).HideWindow();
		//case 6:
		//	GetWindowHandle( "CardExchangeWnd.CardList07_Wnd" ).HideWindow();  
	}
}

// 세로 카드 세트, 보이기
function showCardSet(int nUseCardSet)
{
	switch(nUseCardSet)
	{
		//case 7:
		//	GetWindowHandle("CardExchangeWnd.CardList07_Wnd").ShowWindow();
		//case 6:
		//	GetWindowHandle("CardExchangeWnd.CardList06_Wnd").ShowWindow();
		case 5:
			GetWindowHandle("CardExchangeWnd.CardList05_Wnd").ShowWindow();
		case 4:
			GetWindowHandle("CardExchangeWnd.CardList04_Wnd").ShowWindow();
		case 3:
			GetWindowHandle("CardExchangeWnd.CardList03_Wnd").ShowWindow();
		case 2:
			GetWindowHandle("CardExchangeWnd.CardList02_Wnd").ShowWindow();
		case 1:
			GetWindowHandle("CardExchangeWnd.CardList01_Wnd").ShowWindow();
	}
}

//  세로 카드 세트 수는 3 ~ 5, 
//  가로 카드수는 nCardNum 5 ~ 7, 
function showCard(int nSetNum, int nCardNum, bool bShow)
{
	if(bShow)
	{
		GetWindowHandle("CardExchangeWnd.CardList0" $ nSetNum $ "_Wnd.Card0" $ nCardNum $ "_Wnd").ShowWindow();
	}
	else
	{
		GetWindowHandle("CardExchangeWnd.CardList0" $ nSetNum $ "_Wnd.Card0" $ nCardNum $ "_Wnd").HideWindow();
	}
}

function setCardSetText(int nSetNum, string textStr)
{
	GetTextBoxHandle("CardExchangeWnd.CardList0" $ nSetNum $ "_Wnd.Title_TextBox").SetText(textStr);
}

// 카드 세트, show, hide
function showCardLine(int nSetNum, bool bShow)
{
	local int i;

	for(i = 1; i < 8; i++)
	{
		showCard(nSetNum, i, bShow);
	}
}

// 가로 카드수
function setAllWCardCount(int maxCardW)
{
	local int h, W;

	for(h = 1; h < 6; h++)
	{
		showCardLine(h, false);

		for(W = 1; W < (maxCardW + 1); W++)
		{
			showCard(h, W, true);
		}
	}
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
