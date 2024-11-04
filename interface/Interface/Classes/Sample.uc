class Sample extends GFxUIScript;


var string testMember;
var Sample sampleWnd;

function OnRegisterEvent()
{
	RegisterGFxEvent(77777);
}

function OnLoad()
{
	testMember = "testMember uc 데이타";
	SetClosingOnESC();
	RegisterState("Sample", "GamingState");
	SetContainer("ContainerWindow");
	SetStateChangeNotification();
	sampleWnd = Sample(GetScript("Sample"));
}

//ЕЧЅєЖ®їл ЗФјц
function OnCallUCFunction( string functionName, string param )
{
	Debug("sampe's onCallUCFunction" @ functionName @ param);
	switch (functionName)
	{
		case "ouputCheck" :
			ouputCheck( param );
		break;
	}
}

//GetVariable ЕЧЅєЖ®їл ЗФјц 
function ouputCheck( string param )
{
	local GFxValue obj;
	local string    test1;
	local int       test2;
	local Float     test3;
	local Bool      test4;

	local string    data1;
	local string    data2;
	local string    data3;
	local string    data4;

	PlayConsoleSound(IFST_MAPWND_OPEN);
	
	AllocGFxValue(obj);
	
	ParseString( param, "d1", data1 );
	ParseString( param, "d2", data2 );
	ParseString( param, "d3", data3 );
	ParseString( param, "d4", data4 );

	Debug ( "sample.GetVariable" @  sampleWnd.GetVariable(obj, "getValTest1") ) ;
	test1 = obj.getString();
	Debug ( "sample.GetVariable" @  sampleWnd.GetVariable(obj, "getValTest2") ) ;
	test2 = obj.getInt();
	Debug ( "sample.GetVariable" @  sampleWnd.GetVariable(obj, "getValTest3") ) ;
	test3 = obj.getFloat();
	Debug ( "sample.GetVariable" @  sampleWnd.GetVariable(obj, "getValTest4") ) ;
	test4 = obj.getBool();
	
	Debug("ouputCheck" @ data1 @ test1 @ data2 @ test2  @ data3 @ test3 @data4 @ test4);

	DeallocGFxValue(obj);
}

defaultproperties
{
}
