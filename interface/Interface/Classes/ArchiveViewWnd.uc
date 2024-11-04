//------------------------------------------------------------------------------------------------------------------------
//
// ����         : ArchiveViewWnd  ( �ڹ��� UI ) - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class ArchiveViewWnd extends GFxUIScript;

//�÷��� �ɼ� ��ǥ
const FLASH_XPOS = 0;
const FLASH_YPOS = -50;


var int currentScreenWidth, currentScreenHeight;

var bool isFlashLoaded;

var int preloadedPledgeID;
var int preloadedCrestID;

const cuttingCriteria = 1000000000 ; //10�� 9�ڸ����� ����
const cuttingCriteriaCipher = 9;//10�� 9�ڸ����� ����


/*
enum EStatisticUnitType
{
	SUT_NONE,
	SUT_HOUR,
	SUT_MINUTE,
	SUT_SECOND,
	SUT_RAID,
};*/


function OnRegisterEvent()
{
	//Ŭ���� �������� �ε� �ϸ鼭 ũ���ø� �߻� ��Ű�� ����� ��� �ּ� ó�� 20140827
	// registerEvent(EV_ReceiveOlympiadGameList);
	//registerEvent(EV_Test_6);
	//registerEvent(EV_Test_7);
	
	//registerEvent(EV_StatisticWndshow);
	//registerEvent(EV_StatisticWorldRecord);

	//registerEvent(EV_StatisticUserRecord);

	//registerEvent(EV_NotifyImportedCrestImage );


	//Ŭ���� �������� �ε� �ϸ鼭 ũ���ø� �߻� ��Ŵ 20140814
	//RegisterEvent( EV_GamingStateEnter );
	//RegisterEvent( EV_Restart );//Restart �̺�Ʈ

}

function OnLoad()
{
	
	registerState( "ArchiveViewWnd", "GamingState" );
	//string class'StatisticAPI'.static.RequestServerStatistic();
	
	SetClosingOnESC();
	isFlashLoaded = false;
	
}

function OnShow()
{
	PlayConsoleSound(IFST_MAPWND_OPEN);
}

function OnHide()
{
	PlayConsoleSound(IFST_MAPWND_CLOSE);
	dispatchEventToFlash_String(11 ,"" ) ;
}


function dispatchEventToFlash_String(int Event_ID, string argString){
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	args[0].SetInt(Event_ID);
	CreateObject(args[1]);

//	Debug("argString"@argString);
	args[1].SetMemberString("string", argString );

	Invoke("_root.onEvent", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
}


function OnFlashLoaded()
{	
	local array<GFxValue> args;
	local GFxValue invokeResult;

	local float xLoc;
	local float yLoc;	

	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Statistic);
	// ���̺� �ޱ�
	setTableContent(class'StatisticAPI'.static.GetTableOfContent());
	
	/*
	GetVariable(obj,"_root.l2SysStringTranslator");
	
	GetFunction(l2SysStringTranslator, EExternalFunctionType.EFunc_SysStringTranslator);

	Debug(debugNum@i++);
	//obj.SetMemberValue("getTranslatedString", l2SysStringTranslator); // ���� ��
	Debug(debugNum@i++);

	DeallocGFxValue(l2SysStringTranslator);
	DeallocGFxValue(obj);*/
	
	beforeFlashLoadedEvent();
	isFlashLoaded = true;
	
	//â�� �⺻ ��ġ ���� �� ���̺� �� â��ġ�� �̵�.
	if( IsSavedInfo() )
	{
		SetGFxFromSavedInfo();
	}
	else
	{		
		// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����		
		AllocGFxValues(args, 2);		
		AllocGFxValue(invokeResult);

		GetAnchorPointFromWindow( xLoc, yLoc, EAnchorPointType.ANCHORPOINT_CenterCenter );

		args[0].SetInt( int(xLoc) + FLASH_XPOS );
		args[1].SetInt( int(yLoc) + FLASH_YPOS );

		Invoke( "_root.onMove", args, invokeResult );

		DeallocGFxValue( invokeResult );
		DeallocGFxValues( args );
	}
}

function beforeFlashLoadedEvent(){ // �÷��� �ε� ���� ���Ӵ� ���� �̺�Ʈ ���� �ε�
	

}

function OnDefaultPosition()
{	
//	Debug("ArchiveViewWnd.uc.onDefaultPosition()");
}
function OnCallUCLogic( int logicID, string param )
{
}

function OnFocus(bool bFlag, bool bTransparency)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args,2);	
	args[0].setbool(bflag);
	args[1].setbool(bTransparency);
	AllocGFxValue(invokeResult);
		
	Invoke("_root.onFocus", args, invokeResult);

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);	
}

// skillID=1 level=1 time=5 altFlag=1 ctrlFlag=1 shiftFlag=0 totalCoolTime=10 remainCoolTime=10 mainKey=a
// 5130
function setTableContent(string param){
	
	local UserInfo userinfo;

	local int i;//for �� ��
	local int j;//for �� ��
	local int k;//for �� ��

	local int depth2Max;//2���� �� ��
	local int depth3Max;//3���� �� ��

	local int tmpSize0;//0�� Size
	
	local int tmpID1;//�ļ��� �ӽ� 1�� ID
	local string tmpName1;//�ļ��� �ӽ� 1�� Name
	local int tmpSize1;//�ļ��� �ӽ� 1�� ������

	local int tmpID2;
	local string tmpName2;
	local int tmpSize2;

	local int tmpID3;
	local string tmpName3;
	local int tmpSize3;

	//local string Unit;

	local array<GFxValue> args;
	local GFxValue invokeResult;	

	local GFxValue argArray_1;
	local GFxValue argArray_2;
	local GFxValue argArray_3;
	local GFxValue ArrayElem;
	
//	Debug(param);

	AllocGFxValues(args,2);

		AllocGFxValue(argArray_1);//1����
		AllocGFxValue(argArray_2);//2����
		AllocGFxValue(argArray_3);//3����
		AllocGFxValue(invokeResult);
		AllocGFxValue(ArrayElem);

		// ��ȣ 4������ ��� �� �ޱ�.
		args[0].SetInt(4);

		// ���� ��ü ����
		CreateObject(args[1]);

		// ���� �迭 ���� 
		CreateArray(argArray_1);
		CreateArray(argArray_2);
		CreateArray(argArray_3);

		depth2Max = 0;
		depth3Max = 0;

		/*param���� ������
Content_Size=4 
Content_0_ID=10 Content_0_Name=a10 Content_0_Size=1 
Content_1_ID=11 Content_1_Name=b10 Content_1_Size=4 
Content_2_ID=12 Content_2_Name=c10 Content_2_Size=1
Content_3_ID=13 Content_3_Name=d10 Content_3_Size=1
						
 Content_0_0_ID=20 Content_0_0_Name=a20 Content_0_0_Size=0							

 Content_1_0_ID=21 Content_1_0_Name=b20 Content_1_0_Size=2
 Content_1_1_ID=22 Content_1_1_Name=b21 Content_1_1_Size=0 
 Content_1_2_ID=23 Content_1_2_Name=b23 Content_1_2_Size=2 
 Content_1_3_ID=24 Content_1_3_Name=b24 Content_1_3_Size=0 

 Content_2_0_ID=23 Content_2_0_Name=c20 Content_2_0_Size=0 

 Content_3_0_ID=24 Content_3_0_Name=d20 Content_3_0_Size=0 
			
  Content_1_0_0_ID=30 Content_1_0_0_Name=b30 Content_1_0_0_Size=0 
  Content_1_0_1_ID=31 Content_1_0_1_Name=b31 Content_1_0_1_Size=0   

  Content_1_2_0_ID=34 Content_1_2_0_Name=b34 Content_1_2_0_Size=0 
  Content_1_2_1_ID=35 Content_1_2_1_Name=b35 Content_1_2_1_Size=0 

					
		*/

		/*param���� �Է¿�
		 *

Content_Size=4 Content_0_ID=10 Content_0_Name=a10 Content_0_Size=1 Content_1_ID=11 Content_1_Name=b10 Content_1_Size=4 Content_2_ID=12 Content_2_Name=c10 Content_2_Size=1 Content_3_ID=13 Content_3_Name=d10 Content_3_Size=1 Content_0_0_ID=20 Content_0_0_Name=a20 Content_0_0_Size=0 Content_1_0_ID=21 Content_1_0_Name=b20 Content_1_0_Size=2 Content_1_1_ID=22 Content_1_1_Name=b21 Content_1_1_Size=0 Content_1_2_ID=23 Content_1_2_Name=b23 Content_1_2_Size=2 Content_1_3_ID=24 Content_1_3_Name=b24 Content_1_3_Size=0 Content_2_0_ID=23 Content_2_0_Name=c20 Content_2_0_Size=0 Content_3_0_ID=24 Content_3_0_Name=d20 Content_3_0_Size=0 Content_1_0_0_ID=30 Content_1_0_0_Name=b30 Content_1_0_0_Size=0 Content_1_0_1_ID=31 Content_1_0_1_Name=b31 Content_1_0_1_Size=0 Content_1_2_0_ID=34 Content_1_2_0_Name=b34 Content_1_2_0_Size=0 Content_1_2_1_ID=35 Content_1_2_1_Name=b35 Content_1_2_1_Size=0
					
		*/		
		
		ParseInt (param, "Content_Size", tmpSize0);
		args[1].SetMemberInt("depth0Size", tmpsize0);
		
		GetPlayerInfo( userinfo );
		args[1].SetMemberString("userName", userinfo.name);

//		Debug("nClanID:"$userinfo.nClanID);
//      Debug("nAllianceID:"$userInfo.nAllianceID );

		for(i = 0 ; i < tmpSize0 ; i++){
			CreateObject(ArrayElem);

			ParseInt(param, "Content_" $ i $ "_ID", tmpID1);
			ParseString(param, "Content_" $ i $ "_Name", tmpName1);
			ParseInt(param, "Content_" $ i $ "_Size", tmpSize1);
			
			ArrayElem.SetMemberInt("ID", tmpID1);
			//Debug( "==========depth1 ID" @ tmpID1);
			ArrayElem.SetMemberString("name", tmpName1);
			ArrayElem.SetMemberInt("size", tmpSize1);

			argArray_1.SetElement(i, ArrayElem);

			for(j=0;j<tmpSize1;j++){
				CreateObject(ArrayElem);
				ParseInt(param, "Content_" $ i $ "_" $ j $ "_ID", tmpID2 );
				//Debug( "==========depth2 ID" @ tmpID2);
				ParseString(param, "Content_" $ i $ "_" $ j $ "_Name", tmpName2 );
				ParseInt(param, "Content_" $ i $ "_" $ j $ "_Size", tmpSize2 );

				ArrayElem.SetMemberInt("ID", tmpID2);
				ArrayElem.SetMemberString("name", tmpName2);
				ArrayElem.SetMemberInt("size", tmpSize2);

			//	if(tmpSize2 == 0){
			//		ParseString( class'StatisticAPI'.static.GetContentInfo(tmpID2), "Unit", Unit);	
			//		ArrayElem.SetMemberInt("Unit", Unit);
			//	}

				argArray_2.SetElement( depth2Max + j , ArrayElem);
			
				for(k=0;k<tmpSize2;k++){
					CreateObject(ArrayElem);
					ParseInt(param, "Content_" $ i $ "_" $ j $ "_" $ k $ "_ID", tmpID3 );
					ParseString(param, "Content_" $ i $ "_" $ j $ "_" $ k $ "_Name", tmpName3 );
					ParseInt(param, "Content_" $ i $ "_" $ j $ "_" $ k $ "_Size", tmpSize3 );

					ArrayElem.SetMemberInt("ID", tmpID3);
					//Debug( "==========depth3 ID" @ tmpID3);
					ArrayElem.SetMemberString("name", tmpName3);
					ArrayElem.SetMemberInt("size", tmpSize3);
					
			//		ParseString( class'StatisticAPI'.static.GetContentInfo(tmpID3), "Unit", Unit);	
			//		ArrayElem.SetMemberInt("Unit", Unit);
				

					argArray_3.SetElement( depth3Max + k, ArrayElem);
				}
				depth3Max = depth3Max + tmpSize2; //�� �� �ø�
			}
			depth2Max = depth2Max + tmpSize1; //�� �� �ø�
		}
		//args[1].SetMemberInt("depth1ListArray", tmpSize0);//����0 ����� �ѱ� ������ �װ��� �����Ǿ� �ִ� ����.
		args[1].SetMemberValue("depth1ListArray", argArray_1);
		args[1].SetMemberValue("depth2ListArray", argArray_2);
		args[1].SetMemberValue("depth3ListArray", argArray_3);		

		Invoke("_root.onEvent", args, invokeResult);

		DeallocGFxValue(argArray_1);
		DeallocGFxValue(argArray_2);
		DeallocGFxValue(argArray_3);
		DeallocGFxValue(ArrayElem);
		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);


}


function OnEvent(int Event_ID, string param)
{

	//////////////////////////////////////���� �Է� �׽�Ʈ �� 
	/*
	
	local int j;//for for
	local int k;//for for

	local int depth2Max;//2���� �� �� 
	local int depth3Max;//3���� �� ��

	local int tmpSize0;//0�� Size
	
	local int tmpID1;//�ļ��� �ӽ� 1�� ID
	local string tmpName1;//�ļ��� �ӽ� 1�� Name
	local int tmpSize1;//�ļ��� �ӽ� 1�� ������

	local int tmpID2;
	local string tmpName2;
	local int tmpSize2;

	local int tmpID3;
	local string tmpName3;
	local int tmpSize3;

	local GFxValue argArray_1;
	local GFxValue argArray_2;
	local GFxValue argArray_3;
	*/
	//////////////////////////////���� �Է� �׽�Ʈ ��


	local int i;//for for

	local int               ID;
	local EStatisticUnitType    Type;
	local int               tmpSize;
	local string            tmpName;
	local INT64             tmpValue;
	local INT64             tmpValue2;
	local int               tmpDiff;              //ȭ��ǥ ����. -1�� �϶�, 0�� �⺻, 1�� ���.
	local int               tmpPledgeID;
	local int               tmpPledgeCrestID;	


	local int               ZeroInvisible; //0���� ��� ������ �Ȱ� ó�� �ϴ� ���� ��
//	local int curRanking; //���� ������
	//local INT64 curRankerValue; //���� ���� ��
	

//	local texture	texPledge;
//	local texture	texAlliance;	
	
	local string            Unit;     //�Ƶ�, ��, �� �� ���� ��Ʈ��
	local int               UnitType; //���� ���� ���� ����

	local string            content;

	local UserInfo          userinfo;

	local GFxValue          argArray_Month;
	local GFxValue          argArray_Total;
	local GFxValue          argArray_Record;

	/////////////////////////////////���� ����

	local array<GFxValue>   args;
	local GFxValue          invokeResult;	

	local GFxValue          ArrayElem;
	

	//Debug("Show ArchiveViewWnd" @ Event_ID);
	//Debug(" param : " @ param);
	
	if ( Event_ID == EV_GamingStateEnter) { 		
		AllocGFxValues(args,2);
		AllocGFxValue(invokeResult);		
		args[0].SetInt(2);	
		
		CreateObject(args[1]);

		GetPlayerInfo( userinfo ) ;

		args[1].SetMemberString("userName", userinfo.name);


		Invoke("_root.onEvent", args, invokeResult);
		
		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);

	} else if( Event_ID == EV_Restart ){
		AllocGFxValues(args,2);
		AllocGFxValue(invokeResult);
		args[0].SetInt(3);

		Invoke("_root.onEvent", args, invokeResult);
		
		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);

	} else if( Event_ID == EV_StatisticWndShow){
		if( IsShowWindow() == false )
		{
			ShowWindow();
		}
		else
		{
			HideWindow();
		}
		//showFlash("archiveViewWnd");
		//Debug("EV_StatisticWndShow");
		//ShowWindow();
		
	} else if(Event_ID == EV_StatisticWorldRecord){//5594
		//
		//Debug("EV_StatisticWorldRecord:"$param);
		
		AllocGFxValues(args,2);
		AllocGFxValue(argArray_Month);
		AllocGFxValue(argArray_Total);
		AllocGFxValue(invokeResult);
		AllocGFxValue(ArrayElem);

		args[0].SetInt(5);
		CreateObject(args[1]);
		CreateArray(argArray_Month);
		CreateArray(argArray_Total);
		
		/*
ID=3 
SizeOfMonth=5 
MonthName_0=forTest3 MonthValue_0=100 MonthDiff_0=-1 MonthPledgeID_0=690 MonthPledgeCrestID_0=28
MonthName_1=name11 MonthValue_1=101 MonthDiff_1=-1 MonthPledgeID_1=690 MonthPledgeCrestID_1=28
MonthName_2=name12 MonthValue_2=102 MonthDiff_2=0 MonthPledgeID_2=690 MonthPledgeCrestID_2=28
MonthName_3=name13 MonthValue_3=103 MonthDiff_3=1 MonthPledgeID_3=690 MonthPledgeCrestID_3=28
MonthName_4=name14 MonthValue_4=104 MonthDiff_4=1 MonthPledgeID_4=690 MonthPledgeCrestID_4=28



SizeOfTotal=5 
TotalName_0=name20 TotalValue_0=200 TotalDiff_0=1 MonthPledgeID_0=690 MonthPledgeCrestID_0=28
TotalName_1=name21 TotalValue_1=201 TotalDiff_1=1
TotalName_2=name22 TotalValue_2=202 TotalDiff_2=0
TotalName_3=name23 TotalValue_3=203 TotalDiff_3=-1
TotalName_4=name24 TotalValue_4=204 TotalDiff_4=-1



ID=3 SizeOfMonth=1  MonthName_0=forTest3 MonthValue_0=100 MonthDiff_0=-1 MonthPledgeID_0=690 MonthPledgeCrestID_0=28 SizeOfTotal=1 TotalName_0=name20 TotalValue_0=200 TotalDiff_0=1 MonthPledgeID_0=690 MonthPledgeCrestID_0=28


//���� ���� 690 
ID=3 SizeOfMonth=1  MonthName_0=forTest3 MonthValue_0=100 MonthDiff_0=-1 MonthPledgeID_0=690 MonthPledgeCrestID_0=690 SizeOfTotal=1 TotalName_0=name20 TotalValue_0=200 TotalDiff_0=1 MonthPledgeID_0=690 MonthPledgeCrestID_0=690

//���͵��� ��ũ ���ֱ�
ID=3 SizeOfMonth=1  MonthName_0=forTest3 MonthValue_0=100 MonthDiff_0=-1 MonthPledgeID_0=0 MonthPledgeCrestID_0=0 SizeOfTotal=1 TotalName_0=name20 TotalValue_0=200 TotalDiff_0=1 MonthPledgeID_0=0 MonthPledgeCrestID_0=0

//���� ��ũ ���ֱ�
ID=3 SizeOfMonth=1  MonthName_0=forTest3 MonthValue_0=100 MonthDiff_0=-1 MonthPledgeID_0=0 MonthPledgeCrestID_0=690 SizeOfTotal=1 TotalName_0=name20 TotalValue_0=200 TotalDiff_0=1 MonthPledgeID_0=0 MonthPledgeCrestID_0=690

//���� ��ũ ���ֱ�
ID=3 SizeOfMonth=1  MonthName_0=forTest3 MonthValue_0=100 MonthDiff_0=-1 MonthPledgeID_0=690 MonthPledgeCrestID_0=0 SizeOfTotal=1 TotalName_0=name20 TotalValue_0=200 TotalDiff_0=1 MonthPledgeID_0=690 MonthPledgeCrestID_0=0


*/
		ParseInt(param, "ID",ID);		
		ParseInt( class'StatisticAPI'.static.GetContentInfo(ID), "UnitType", UnitType);
		Type = EStatisticUnitType(UnitType);		
		if (Type == SUT_NONE ||  Type == SUT_RAID)
			ParseString( class'StatisticAPI'.static.GetContentInfo(ID), "Unit", Unit);
		else Unit = "";
		args[1].SetMemberString("Unit", Unit);

		///////////////////////////////////// Month /////////////////////////////////
		ParseInt(param,"SizeOfMonth",tmpSize);


		//if(tmpSize > 100){ tmpSize = 100; }///////////////////////////   100�� ������ ���� //////////////////////////////////////////			
		args[1].SetMemberInt("SizeOfMonth", tmpSize);

		//curRanking = 0;	//���� ��ŷ ��
		for(i=0;i<tmpSize;i++){

			CreateObject(ArrayElem);			
			
			ParseString(param, "MonthName_" $ i , tmpName); 
			ParseINT64(param, "MonthValue_" $ i , tmpValue);//64�� �ٱ� ��� ��.
			ParseInt(param, "MonthDiff_" $ i , tmpDiff);			

			ParseInt(param, "MonthPledgeID_"$ i, tmpPledgeID);
			ParseInt(param, "MonthPledgeCrestID_"$ i, tmpPledgeCrestID);
			
			//class'UIDATA_CLAN'.static.GetCrestTexture(tmpPledgeID, texPledge); �۵� ��.
			//class'UIDATA_CLAN'.static.GetAllianceCrestTexture(tmpPledgeCrestID, texAlliance); �۵� ��.
			//Debug("mark:"$texPledge$", "$texAlliance);

			ArrayElem.SetMemberString("name", tmpName);			

			if (Type == SUT_NONE ||  Type == SUT_RAID){
				//ArrayElem.SetMemberString("value", MakeCostString(String(tmpValue))); //����ó��
				ArrayElem.SetMemberString("value", valueNumToStr(tmpValue));//����ó��
			} else {
				ArrayElem.SetMemberString("value", setTimeString(tmpValue));//�ð�ó�� 
			}


			ArrayElem.SetMemberInt("diff", tmpDiff);
			ArrayElem.SetMemberInt("pledgeID", tmpPledgeID);
			ArrayElem.SetMemberInt("pledgeCrestID", tmpPledgeCrestID);			
			
			/*/���� ��ŷ ����
			if(curRankerValue != tmpValue){
				curRankerValue = tmpValue;
				curRanking ++;
			}  
			ArrayElem.SetMemberInt("ranking", curRanking);
*/
			argArray_Month.SetElement(i, ArrayElem);
			
			//Debug( "Month_" $ i $"="$ tmpName $", "$ tmpValue $", "$ tmpDiff $", "$ tmpPledgeID $", "$ tmpPledgeCrestID);
		}
		
		


		///////////////////////////////////// Total /////////////////////////////////
		ParseInt(param,"SizeOfTotal",tmpSize);

		//if(tmpSize > 100){ tmpSize = 100; }///////////////////////////   100�� ������ ���� //////////////////////////////////////////


		args[1].SetMemberInt("SizeOfTotal", tmpSize);
		
		//curRanking = 0;//���� ��ŷ ��

		for(i=0;i<tmpSize;i++){

			CreateObject(ArrayElem);
			ParseString(param, "TotalName_" $ i , tmpName);
			ParseINT64(param, "TotalValue_" $ i , tmpValue);
			Parseint(param, "TotalDiff_" $ i , tmpDiff);

			ParseInt(param, "TotalPledgeID_"$ i, tmpPledgeID);
			ParseInt(param, "TotalPledgeCrestID_"$ i, tmpPledgeCrestID);
			
			ArrayElem.SetMemberString("name", tmpName);
			//ArrayElem.SetMemberString("value", MakeCostString(String(tmpValue)));//õ ���� �� ����ó��

			if (Type == SUT_NONE ||  Type == SUT_RAID){
				ArrayElem.SetMemberString("value", valueNumToStr(tmpValue));//����ó��
			} else {
				ArrayElem.SetMemberString("value", setTimeString(tmpValue));//�ð�ó��			
			}
			

			ArrayElem.SetMemberInt("diff", tmpDiff);

			ArrayElem.SetMemberInt("pledgeID", tmpPledgeID);
			ArrayElem.SetMemberInt("pledgeCrestID", tmpPledgeCrestID);

			/*/���� ��ŷ ����
			if(curRankerValue != tmpValue){
				curRankerValue = tmpValue;
				curRanking ++;
			}  
			ArrayElem.SetMemberInt("ranking", curRanking);
*/

			argArray_Total.SetElement(i, ArrayElem);

//			Debug( "Total_" $ i $"="$ tmpName $", "$ tmpValue $", "$ tmpDiff $", "$ tmpPledgeID $", "$ tmpPledgeCrestID);
		}
//		Debug("argArray_Total:"$argArray_Total);
		
		args[1].SetMemberValue("array_Total", argArray_Total);
		args[1].SetMemberValue("array_Month", argArray_Month);
		//Debug(args);

		Invoke("_root.onEvent", args, invokeResult);

		DeallocGFxValue(argArray_Month);
		DeallocGFxValue(argArray_Total);		
		DeallocGFxValue(ArrayElem);
		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);

	} else if(Event_ID == EV_StatisticUserRecord){ //5595
		/*

SizeOfRecord=5 
ID_0=name10 MonthValue_0=100 TotalValue_0=200
ID_1=name11 MonthValue_1=101 TotalValue_1=201
ID_2=name12 MonthValue_2=102 TotalValue_2=202
ID_3=name13 MonthValue_3=103 TotalValue_3=203
ID_4=name14 MonthValue_4=104 TotalValue_4=204

SizeOfRecord=5 ID_0=name10 MonthValue_0=100 TotalValue_0=200 ID_1=name11 MonthValue_1=101 TotalValue_1=201 ID_2=name12 MonthValue_2=102 TotalValue_2=202 ID_3=name13 MonthValue_3=103 TotalValue_3=203 ID_4=name14 MonthValue_4=104 TotalValue_4=204
*/

		
//		Debug("EV_StatisticUserRecord:"$param);			

		AllocGFxValues(args,2);
		AllocGFxValue(argArray_Record);
		AllocGFxValue(invokeResult);
		AllocGFxValue(ArrayElem);

		args[0].SetInt(6);
		CreateObject(args[1]);
		CreateArray(argArray_Record);
		
		GetPlayerInfo( userinfo ) ;
		//Debug( "�ڹ��� EV_GamingStateEnter , userName :" @ userinfo.name);
		args[1].SetMemberString("userName", userinfo.name);

		ParseInt(param,"SizeOfRecord",tmpSize);
		args[1].SetMemberInt("SizeOfRecord", tmpSize);

		for(i=0;i<tmpSize;i++){
			
			CreateObject(ArrayElem);
			ParseInt(param, "ID_" $ i , ID);
			content = class'StatisticAPI'.static.GetContentInfo(ID);						
			ParseInt(content, "UnitType", UnitType);
			Type = EStatisticUnitType(UnitType);
			if (Type == SUT_NONE ||  Type == SUT_RAID)
			{				
				ParseString(content, "Unit", Unit) ;
			} 
			else 
			{   
				Unit = "";			
			}

			ParseInt(content, "ZeroInvisible", ZeroInvisible) ;

			//�׽�Ʈ �����
			//Debug ("ZeroInvisible" @ ZeroInvisible);
			
			//if ( ZeroInvisible != 0 ) Debug ("ZeroInvisible" @ ZeroInvisible);
			//Debug ("UnitType" @ UnitType);
			//ParseInt(content, "UnitType", UnitType) ;
			//Debug ("Unit" @ Unit);
			tmpName = class'StatisticAPI'.static.GetTitleNameOfStatistic(ID);
			//ParseString(content, "name",tmpName);
			//Debug("class'StatisticAPI'.static.GetTitleNameOfStatistic(ID);"@tmpName);
			//Debug("================================" @ ID @ tmpName);

			
			ParseINT64(param, "MonthValue_" $ i , tmpValue);
			ParseINT64(param, "TotalValue_" $ i , tmpValue2);

			ArrayElem.SetMemberString("Unit", Unit);			
			ArrayElem.SetMemberString("name", tmpName);	

			if (Type == SUT_NONE ||  Type == SUT_RAID)
			{
				ArrayElem.SetMemberString("MonthValue", valueNumToStr(tmpValue));//����ó��
				ArrayElem.SetMemberString("TotalValue", valueNumToStr(tmpValue2));//����ó��
				//ArrayElem.SetMemberString("MonthValue", MakeCostString(String(tmpValue)));
				//ArrayElem.SetMemberString("TotalValue", MakeCostString(String(tmpValue2)));
			} 
			else 
			{
				ArrayElem.SetMemberString("MonthValue", setTimeString(tmpValue ));//�ð�ó��
				ArrayElem.SetMemberString("TotalValue", setTimeString(tmpValue2));//�ð�ó��
			}
			ArrayElem.SetMemberInt("ZeroInvisible", ZeroInvisible);
			//Debug("ZeroInvisible"@ZeroInvisible);
			argArray_Record.SetElement(i, ArrayElem);			
		}

		args[1].SetMemberValue("array_Record", argArray_Record);

		Invoke("_root.onEvent", args, invokeResult);

		DeallocGFxValue(argArray_Record);
		DeallocGFxValue(ArrayElem);
		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);

	} if ( Event_ID == EV_NotifyImportedCrestImage) { //9220
		ParseInt(param, "PledgeID", tmpPledgeID);
		ParseInt(param, "CrestID", tmpPledgeCrestID);
		if(isFlashLoaded){
			AllocGFxValues(args,2);
			AllocGFxValue(invokeResult);		
			args[0].SetInt(10);	
			CreateObject(args[1]);							
			args[1].SetMemberInt("PledgeID", tmpPledgeID );
			args[1].SetMemberInt("CrestID", tmpPledgeCrestID );	
			Invoke("_root.onEvent", args, invokeResult);			
			DeallocGFxValue(invokeResult);
			DeallocGFxValues(args);
		} else {
			preloadedPledgeID = tmpPledgeID;
			preloadedCrestID = tmpPledgeCrestID;
		}
	}
}

function string valueNumToStr(INT64 tmpValue){
	local string returnStr;	
	if( tmpValue > 0 ) {
		returnStr = getValueCuttingCriteria(tmpValue, cuttingCriteria, 0);
		returnStr = ConvertNumToTextNoAdena(returnStr);
		return returnStr;
	}
	return "0";
	
	
}

function string getValueCuttingCriteria(INT64 tmpValue, INT64 criteria , int num){	
	if ( num > 5){//10���� 5���� �Ѱ�� �д�.
		return "0";
	}
	if ( tmpValue > criteria  ) {
		return getValueCuttingCriteria (tmpValue,  criteria * cuttingCriteria, num + 1 );
	}else {		
		return CeilingNum (String (tmpValue), cuttingCriteriaCipher * num  );//cuttingCriteriaCipher �� 9, �ڸ��� 9 * num �ڸ����� ����
	}	
}

function string setTimeString(INT64 tmpTime){
	local INT64 tmpDay;
	local INT64 tmpHou;
	local INT64 tmpMin;	
	local string timeStr;
	
	
	local int minToHou;
	local int minToDay;
	
	minToHou = 60;
	minToDay = minToHou * 24;
	
	tmpMin = tmpTime/60; 

	if ( tmpMin > minToDay ) {//�� // �ð���		
		tmpHou = tmpMin/60;
		tmpDay = tmpHou/24;
		tmpHou = tmpHou - tmpDay*24;	
		if ( tmpHou != 0 ){
			timeStr = MakeFullSystemMsg( GetSystemMessage(3503), MakeCostString(String(tmpDay)), string (tmpHou) );
		} else {
			timeStr = MakeFullSystemMsg( GetSystemMessage(3418), MakeCostString (String(tmpDay)));
		}
	} else if ( tmpMin > 60 ) {//�ð� �и�
		tmpHou = tmpMin/60;
		tmpMin = tmpMin - tmpHou*60;
		if( tmpMin != 0 ){
			timeStr = MakeFullSystemMsg( GetSystemMessage(3304), string(tmpHou), string (tmpMin) );
		} else {
			timeStr = MakeFullSystemMsg( GetSystemMessage(3406), string(tmpHou) );
		}

	} else {//�и�
		timeStr = MakeFullSystemMsg( GetSystemMessage(3390), string (tmpMin));
	}

	return timeStr;
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	local array<GFxValue> args;

	local GFxValue invokeResult;

	AllocGFxValues(args, 1);		
	
	Invoke("_root.onReceivedCloseUI", args, invokeResult);

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);	
}

defaultproperties
{
}
