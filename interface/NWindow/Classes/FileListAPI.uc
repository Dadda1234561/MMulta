//================================================================================
// FileListAPI.
//================================================================================

class FileListAPI extends UIEventManager
	native;

// Export UFileListAPI::execGetFileInfoList(FFrame&, void* const)
native static function array<FileNameInfo> GetFileInfoList(string filePath, array<string> arrFileExt);

// Export UFileListAPI::execGetDriveInfoList(FFrame&, void* const)
native static function array<DriveInfo> GetDriveInfoList();

// Export UFileListAPI::execShowFlash(FFrame&, void* const)
native static function bool ShowFlash(string filePath);

defaultproperties
{
}
