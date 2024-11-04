class L2PassData extends UICommonAPI;

const L2PASS_TEXTURE_PATH = "L2UI_NewTex.L2passWnd.";

enum EL2PassType 
{
	Hunt,
	Advance,
	Max
};

enum EL2PassStepState 
{
	NotInProgress,
	InProgress,
	CompleteNotRewardStep,
	CompleteRewardReady,
	CompleteRewarded
};

struct L2PassStepInfo
{
	var int Index;
	var EL2PassType PassType;
	var EL2PassStepState stepState;
	var bool isPremiumStep;
	var bool isPremiumActivated;
	var int rewardType;
	var int RewardItemID;
	var int rewardItemCnt;
	var int missionMaxCnt;
	var int missionCnt;
};

struct L2PassSayhasSupportInfo
{
	var bool isOn;
	var int usedTime;
	var int earnedTime;
	var int maxTIme;
};

struct L2PassInfo
{
	var EL2PassType PassType;
	var bool isOn;
	var bool isPremiumActivated;
	var int maxStep;
	var int currentStep;
	var int freeStepNum;
	var int premiumStepNum;
	var int maxStepPage;
	var int currentStepPage;
	var int rewardStep;
	var int premiumRewardStep;
	var int currentMissionCnt;
	var int maxMissionCnt;
	var int notReceivedRewardNum;
	var int LeftTime;
	var array<L2PassStepInfo> stepInfos;
	var array<L2PassStepInfo> premiumStepInfos;
};
