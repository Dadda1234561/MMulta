//================================================================================
// StatusBaseHandle.
//================================================================================

class StatusBaseHandle extends WindowHandle
	native;

enum StatusBarSplitType {
	SBST_BackLeft, // 0
	SBST_BackCenter, // 1
	SBST_BackRight, // 2
	SBST_RegenLeft, // 3
	SBST_RegenCenter, // 4
	SBST_RegenRight, // 5
	SBST_ForeLeft, // 6
	SBST_ForeCenter, // 7
	SBST_ForeRight, // 8
	SBST_OverlayLeft, // 9
	SBST_OverlayCenter,
	SBST_OverlayRight,
	SBST_WarnLeft,
	SBST_WarnCenter,
	SBST_WarnRight,
	SBST_ForeLeft01,
	SBST_ForeCenter01,
	SBST_ForeRight01,
	SBST_ForeLeft02,
	SBST_ForeCenter02,
	SBST_ForeRight02,
	SBST_Trailer
};

enum StatusRoundSplitType {
	SRST_Back,
	SRST_Main,
	SRST_Trailer,
	SRST_Mask1,
	SRST_Mask2,
	SRST_Overlay
};

struct GaugeTextureSplitData
{
	var string strTexture;
	var Texture pTexture;
	var int BarUSize;
	var int BarVSize;
	var Color Color;
	var int ratio;
};

// Export UStatusBaseHandle::execGetSelfScript(FFrame&, void* const)
native final function StatusBaseHandle GetSelfScript();

// Export UStatusBaseHandle::execGetGaugeTexture(FFrame&, void* const)
native final function string GetGaugeTexture(int Type);

// Export UStatusBaseHandle::execSetGaugeTexture(FFrame&, void* const)
native final function SetGaugeTexture(int Type, string strTexture, optional int size1, optional int size2);

// Export UStatusBaseHandle::execGetGaugeColor(FFrame&, void* const)
native final function Color GetGaugeColor(int Type);

// Export UStatusBaseHandle::execSetGaugeColor(FFrame&, void* const)
native final function SetGaugeColor(int Type, Color Color);

// Export UStatusBaseHandle::execGetPoint(FFrame&, void* const)
native final function GetPoint(out INT64 CurrentValue, out INT64 MaxValue, optional out INT64 MinValue);

// Export UStatusBaseHandle::execClearPoint(FFrame&, void* const)
native final function ClearPoint();

// Export UStatusBaseHandle::execSetPoint(FFrame&, void* const)
native final function SetPoint(INT64 CurrentValue, INT64 MaxValue);

// Export UStatusBaseHandle::execSetPointPercent(FFrame&, void* const)
native final function SetPointPercent(INT64 CurrentValue, INT64 MinValue, INT64 MaxValue);

// Export UStatusBaseHandle::execSetPointExpPercentRate(FFrame&, void* const)
native final function SetPointExpPercentRate(float CurrentPercentRate);

// Export UStatusBaseHandle::execSetRegenInfo(FFrame&, void* const)
native final function SetRegenInfo(int Duration, int ticks, float Amount);

defaultproperties
{
}
