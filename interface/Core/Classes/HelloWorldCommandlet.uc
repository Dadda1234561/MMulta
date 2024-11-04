//=============================================================================
/// UnrealScript "hello world" sample Commandlet.
///
/// Usage:
///     ucc.exe HelloWorld
//=============================================================================
class HelloWorldCommandlet
	extends Commandlet;

var int intparm;
var string strparm;

function int Main(string Parms)
{
	log("Hello, world!");
	if( Parms!="" )
		log( "Command line parameters=" $ Parms );
	if( intparm!=0 )
		log( "You specified intparm=" $ intparm );
	if( strparm!="" )
		log( "You specified strparm=" $ strparm );
	return 0;
}