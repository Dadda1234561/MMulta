//================================================================================
// SceneEditorAPI.
//================================================================================

class SceneEditorAPI extends Object
	native
	export;

// Export USceneEditorAPI::execInitSceneEditorData(FFrame&, void* const)
native static function InitSceneEditorData();

// Export USceneEditorAPI::execPlayScene(FFrame&, void* const)
native static function PlayScene(int SkipSceneNo, int EndSceneNo, int Option, bool bShowInfo, bool bReShow);

// Export USceneEditorAPI::execAddScene(FFrame&, void* const)
native static function AddScene(int Index);

// Export USceneEditorAPI::execDeleteScene(FFrame&, void* const)
native static function DeleteScene(int Index);

// Export USceneEditorAPI::execCopyScene(FFrame&, void* const)
native static function CopyScene(int SrcIndex, int DestIndex);

// Export USceneEditorAPI::execIsReloadSceneData(FFrame&, void* const)
native static function bool IsReloadSceneData();

// Export USceneEditorAPI::execReloadSceneData(FFrame&, void* const)
native static function ReloadSceneData();

// Export USceneEditorAPI::execLoadSceneData(FFrame&, void* const)
native static function LoadSceneData(string Filename);

// Export USceneEditorAPI::execSaveSceneData(FFrame&, void* const)
native static function bool SaveSceneData(string Filename, string CurPath, bool bForceToPlay, bool bEscapable, bool bShowMyPC, bool bShowOtherPCs, float PlayRate, optional float NearClippingPlane, optional float FarClippingPlane);

// Export USceneEditorAPI::execGetCurSceneTimeAndDesc(FFrame&, void* const)
native static function GetCurSceneTimeAndDesc(int Index, out int Time, out string Desc);

// Export USceneEditorAPI::execGetCurScenePlayRate(FFrame&, void* const)
native static function GetCurScenePlayRate(int Index, out float PlayRate);

// Export USceneEditorAPI::execSaveCurSceneTimeAndDesc(FFrame&, void* const)
native static function SaveCurSceneTimeAndDesc(int Index, int Time, string Desc, float PlayRate);

// Export USceneEditorAPI::execSetSceneInfoAttribute(FFrame&, void* const)
native static function SetSceneInfoAttribute(bool bForceToPlay, bool bEscapable, bool bShowMyPC, bool bShowOtherPCs, float PlayRate, float NearClippingPlane, float FarClippingPlane);

defaultproperties
{
}
