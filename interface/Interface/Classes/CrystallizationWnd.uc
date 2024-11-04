//------------------------------------------------------------------------------------------------------------------------
//
// ����         : ����ȭ �ý��� 
//
// ����         : 4�� ���� ���Ŀ��� ������̿��� ��� ������ ����ȭ�� �� �� �ִ�.
//                ����ȭ �� ���� �Ӹ��ƴ϶� �������� �ٸ� ���� �����۵��� ���� �� �ִ� ����� �߰� �Ǿ���.
//                ����ȭ �����츦 ȣ���ϴ� �κ��� InventoryWnd.uc �̴�.
//------------------------------------------------------------------------------------------------------------------------

class CrystallizationWnd extends UICommonAPI;

const LINE_MAX = 6;

var string       m_WindowName;
var WindowHandle Me;

var ItemWindowHandle CrystallizationItem;
var TextBoxHandle CrystallizationItemName;
var WindowHandle CrystallizationGetItemWnd;

var ButtonHandle OKButton;
var ButtonHandle CancelButton;

// ����ȭ �õ��� ������ ����
var ItemInfo tryItemInfo;

// ����ȭ �� ���� ������ Height 
var int cHeight;

// ����ȭ ���� ������ �� 
var int lineCount;

var bool isCrystallizeItem;

/**
 * 
 * OnRegisterEvent
 * 
 **/
function OnRegisterEvent()
{
	//RegisterEvent(EV_Restart);
	RegisterEvent(EV_CrystalizingEstimationList);
	RegisterEvent(EV_CrystalizingEstimationListEnd);
	RegisterEvent(EV_CrystalizingFail);	
}

/**
 *  
 * OnLoad
 * 
 **/
function OnLoad()
{
	SetClosingOnESC();

	Initialize();
	//PlayConsoleSound(IFST_WINDOW_OPEN);
}

function onShow()
{
	// ������ �����츦 ������ �ݱ� ��� 
	PlayConsoleSound(IFST_WINDOW_OPEN);
	isCrystallizeItem = false;
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)), "InventoryWnd");
}

function onHide()
{
	//���� ��ư �������� ������� ���ƶ� > x�� â�� ���� ��, �Ǹ� ���� �ý����� ��� ���� �ʴ� ������ �߰� �� 121106
	if ( isCrystallizeItem )
	{
		RequestCrystallizeItem(tryItemInfo.ID, 1);
	}
	else 
	{
		RequestCrystallizeItemCancel();
	}
}

/**
 * 
 * Initialize
 * 
 **/
function Initialize()
{
	Me = GetWindowHandle( "CrystallizationWnd" );

	CrystallizationItem       = GetItemWindowHandle( "CrystallizationWnd.CrystallizationItem" );
	CrystallizationItemName   = GetTextBoxHandle( "CrystallizationWnd.CrystallizationItemName" );
	CrystallizationGetItemWnd = GetWindowHandle( "CrystallizationWnd.CrystallizationGetItemWnd" );

	OKButton     = GetButtonHandle( "CrystallizationWnd.OKButton" );
	CancelButton = GetButtonHandle( "CrystallizationWnd.CancelButton" );
}

/**
 *
 *  ����ȭ�ý��� �����̺�Ʈ
 *  const EV_CrystalizingEstimationList = 5140; //����ȭ ����
 *  const EV_CrystalizingEstimationListEnd = 5141; //����ȭ ���� ����
 *  const EV_CrystalizingFail = 5142; //����ȭ ����
 **/
function OnEvent(int Event_ID, string param)
{

	//debug("Event_ID :" @ Event_ID @ " param:" @ param);

	switch( Event_ID )
	{
		case EV_CrystalizingEstimationList:
			getCrystalizingEstimation(param);
			break;

		case EV_CrystalizingEstimationListEnd:

			showCrystalizingEstimationList();
			break;

		case EV_CrystalizingFail:

			// ����ȭ ��� 
			cancelCystallizeItem();
			break;
	}
}

/**
 * �κ��丮���� ����ȭ �� �������� ������ ������ ������.
 * ����ȭ�� �õ� �ϸ� �κ��丮���� �� �Լ��� ȣ�� �Ѵ�.
 * �� ���� ���� ����Ǵ� �Լ���.
 **/
function setItemInfo( ItemInfo cItemInfo)
{
	local int lineNum;

	// Ȥ�� ���� ���� �۾����� ���
	RequestCrystallizeItemCancel();

	tryItemInfo = cItemInfo;

	cHeight = 0;
	lineCount = 0;	

	CrystallizationItem.Clear();
	CrystallizationItemName.SetText("");

	for (lineNum = 1; lineNum <= LINE_MAX; lineNum++)
	{
		GetItemWindowHandle( "CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItem0" $ lineNum).Clear();
		GetTextBoxHandle( "CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemName0" $ lineNum).SetText("");
		GetTextBoxHandle( "CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemCount0" $ lineNum).SetText("");
		GetTextBoxHandle( "CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationItemProbability0" $ lineNum).SetText("");
	}
}
/**
 *  �������� ����ȭ ������ ������ ������ ����Ʈ�� �޴´�.
 **/
function getCrystalizingEstimation( string param )
{
	local int nitemID;
	local int crystalCnt;
	local float probability;
	
	local ItemID   cItemID;
	local ItemInfo cItemInfo;

	lineCount++;

	CrystallizationItem.AddItem(tryItemInfo);
	//CrystallizationItemName.SetText(tryItemInfo.Name);

	getInstanceL2Util().textBox_setToolTipWithShortString(CrystallizationItemName, tryItemInfo.Name, -4);

	CrystallizationItem.SetSelectedNum(0);
	
	ParseInt(param, "ItemID", nitemID);
	ParseInt(param, "CrystalCnt", crystalCnt);
	ParseFloat(param, "Probability", probability);
	
	//cItemID.ClassID = nitemID;
	cItemID = GetItemID(nitemID);
	
	class'UIDATA_ITEM'.static.GetItemInfo(cItemID, cItemInfo );
	
	//cItemInfo.Description = class'UIDATA_ITEM'.static.GetItemDescription(cItemID);
	// cItemInfo.Weight = class'UIDATA_ITEM'.static.GetItemWeight(cItemID);
	cItemInfo.ItemNum = INT64(crystalCnt);
	
	//Debug(cItemInfo.Description);

	// ������ ������ �ϱ� ���ؼ� ��ü ���Ը� ���Ѵ�.

	//cItemInfo.Weight = class'UIDATA_ITEM'.static.GetItemWeight(infItem.ID);
	// cItemInfo.Weight = 1000;
	// Debug("nitemID" @ nitemID);
	// Debug("����:"@ class'UIDATA_ITEM'.static.GetItemWeight(cItemID));
	
	setItemLine(lineCount, cItemInfo, crystalCnt, probability);	
}


/**
 * â�� ���� ������� ���ؼ� ������ ũ��� ���� �Ѵ�.
 **/
function showCrystalizingEstimationList ()
{

	cHeight = cHeight + (38 * (5 - lineCount));
	CrystallizationGetItemWnd.SetWindowSize(286, (194 - cHeight) );

//	Me.SetWindowSize(298, 420 - (cHeight));
	
	Me.ShowWindow();
	Me.SetFocus();
}

/**
 *  �������� ����ȭ ������ ������ ������ ����Ʈ�� �޴´�.
 *   - ����ȭ �� ȹ�� ���� ������ �� ������ ���� ��ȣ
 *   - itemInfo 
 *   - ȹ�� ������ ������ �� 
 *   - ȹ�� ���ɼ�
 **/
function setItemLine(int lineNum, ItemInfo cItemInfo, int crystalCnt, float probability)
{
	local string probabilityStr;
	local array<string>	arrSplit;
	local TextBoxHandle tx;

	if (probability <= 10)
	{
		probabilityStr = "???";
	}
	else
	{
		if (probability == 100)
		{
			probabilityStr = "100%";
			
		}
		else
		{
			// �Ҽ��� 99.00 ���ڸ� �� ��������..
			Split( string(probability), ".", arrSplit);
			if (arrSplit.Length == 2)
			{
				if (Len(arrSplit[1]) >= 2)
				{
					probabilityStr = arrSplit[0] $ "." $ Mid(arrSplit[1],0,2) $ "%";
				}
				else 
				{
					
					probabilityStr = string(probability) $ "%";
				}
			}
			else
			{
				probabilityStr = string(probability) $ "%";
			}
		}
	}

	GetItemWindowHandle( "CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItem0" $ lineNum).AddItem(cItemInfo);
	//GetTextBoxHandle( "CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemName0" $ lineNum).SetText(cItemInfo.Name);

	tx = GetTextBoxHandle( "CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemName0" $ lineNum);
	getInstanceL2Util().textBox_setToolTipWithShortString(tx, cItemInfo.Name, -7);
	
	GetTextBoxHandle( "CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemCount0" $ lineNum).SetText(string(crystalCnt) $ GetSystemString(932));	
	GetTextBoxHandle( "CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationItemProbability0" $ lineNum).SetText(probabilityStr);
}

/**
 *  OnClickButton
 **/
function OnClickButton( string Name )
{
	switch( Name )
	{
		case "OKButton":
			OnOKButtonClick();

			break;
		case "CancelButton":
			cancelCystallizeItem();
			break;
	}
}

/**
 *  ����ȭ �ϱ�
 **/
function OnOKButtonClick()
{
	isCrystallizeItem = true;
		
	Me.HideWindow();
}

/**
 *  ����ȭ ���
 **/
function cancelCystallizeItem()
{		
	Me.HideWindow();
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	cancelCystallizeItem();
}

defaultproperties
{
     m_WindowName="CrystallizationWnd"
}
