class L2SceneInfo extends Object
	native
	dynamicrecompile		
	hidecategories(Object);


var		int					SceneID;
var		string				SceneDesc;

var		array<L2SceneItem>	SceneInfo;
var		bool				ForceToPlay;
var		bool				IsEscapable;

var		bool				IsShowMyPC;
var		bool				IsShowOtherPCs;

var		float				PlayRate;
var		float				NearClippingPlane;
var		float				FarClippingPlane;


// Decompiled with UE Explorer.
defaultproperties
{
    IsEscapable=true
    IsShowOtherPCs=true
    PlayRate=1
    NearClippingPlane=-1
    FarClippingPlane=-1
}