//================================================================================
// MultiEditBoxHandle.
//================================================================================

class MultiEditBoxHandle extends WindowHandle
	native;

// Export UMultiEditBoxHandle::execGetString(FFrame&, void* const)
native final function string GetString();

// Export UMultiEditBoxHandle::execSetString(FFrame&, void* const)
native final function SetString(string Str);

// Export UMultiEditBoxHandle::execSetMaxSizeOfText(FFrame&, void* const)
native final function SetMaxSizeOfText(int maxSizeOfText);

// Export UMultiEditBoxHandle::execGetTotalSizeOfText(FFrame&, void* const)
native final function int GetTotalSizeOfText();

defaultproperties
{
}
