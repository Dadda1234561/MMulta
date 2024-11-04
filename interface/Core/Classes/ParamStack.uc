class ParamStack extends object
	native
	noexport;
	
var int stack; //실제로는 l2paramstack 포인터를 사용하지만 4byte 사이즈를 맞추기 위해 int로...

// Export UParamStack::execGetString(FFrame&, void* const)
native function string GetString();

// Export UParamStack::execGetInt(FFrame&, void* const)
native function int	GetInt();

// Export UParamStack::execPushInt(FFrame&, void* const)
native function float GetFloat();

//2006.6 ttmayrin
// Export UParamStack::execPushInt(FFrame&, void* const)
native function PushInt(int item);

// Export UParamStack::execPushString(FFrame&, void* const)
native function PushString(string item);