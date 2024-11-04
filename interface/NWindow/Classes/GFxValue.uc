//================================================================================
// GFxValue.
//================================================================================

class GFxValue extends Object
	native
	noexport
	instanced;

// Export UGFxValue::execSetMemberFloat(FFrame&, void* const)
native final function bool SetMemberFloat(string Name, float Value);

// Export UGFxValue::execSetMemberInt(FFrame&, void* const)
native final function bool SetMemberInt(string Name, int Value);

// Export UGFxValue::execSetMemberString(FFrame&, void* const)
native final function bool SetMemberString(string Name, string Value);

// Export UGFxValue::execSetMemberValue(FFrame&, void* const)
native final function bool SetMemberValue(string Name, out GFxValue Value);

// Export UGFxValue::execSetMemberBool(FFrame&, void* const)
native final function bool SetMemberBool(string Name, bool Value);

// Export UGFxValue::execSetFloat(FFrame&, void* const)
native final function SetFloat(float Value);

// Export UGFxValue::execSetInt(FFrame&, void* const)
native final function SetInt(int Value);

// Export UGFxValue::execSetBool(FFrame&, void* const)
native final function SetBool(bool Value);

// Export UGFxValue::execSetElement(FFrame&, void* const)
native final function bool SetElement(int Index, out GFxValue Value);

// Export UGFxValue::execGetString(FFrame&, void* const)
native final function string GetString();

// Export UGFxValue::execGetBool(FFrame&, void* const)
native final function bool GetBool();

// Export UGFxValue::execGetInt(FFrame&, void* const)
native final function int GetInt();

// Export UGFxValue::execGetFloat(FFrame&, void* const)
native final function float GetFloat();

defaultproperties
{
}
