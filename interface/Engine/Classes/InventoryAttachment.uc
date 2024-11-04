class InventoryAttachment extends Actor
	native
	nativereplication;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var bool bFastAttachmentReplication; // only replicates the subset of actor properties needed by basic attachments whose 
									 // common properties don't vary from their defaults

function InitFor(Inventory I)
{
	Instigator = I.Instigator;
}
		

// Decompiled with UE Explorer.
defaultproperties
{
    bFastAttachmentReplication=true
    DrawType=2
    bOnlyDrawIfAttached=true
    bOnlyDirtyReplication=true
    RemoteRole=2
    NetUpdateFrequency=10
    AttachmentBone=righthand
    bUseLightingFromBase=true
}