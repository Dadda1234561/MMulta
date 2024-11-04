//================================================================================
// BookMarkAPI.
//================================================================================

class BookMarkAPI extends UIEventManager
	native;

// Export UBookMarkAPI::execRequestBookMarkSlotInfo(FFrame&, void* const)
native static function bool RequestBookMarkSlotInfo();

// Export UBookMarkAPI::execRequestShowBookMark(FFrame&, void* const)
native static function bool RequestShowBookMark();

// Export UBookMarkAPI::execRequestSaveBookMarkSlot(FFrame&, void* const)
native static function bool RequestSaveBookMarkSlot(string slotTitle, int IconID, string iconTitle);

// Export UBookMarkAPI::execRequestModifyBookMarkSlot(FFrame&, void* const)
native static function bool RequestModifyBookMarkSlot(ItemID SlotID, string slotTitle, int IconID, string iconTitle);

// Export UBookMarkAPI::execRequestDeleteBookMarkSlot(FFrame&, void* const)
native static function bool RequestDeleteBookMarkSlot(ItemID SlotID);

// Export UBookMarkAPI::execRequestTelePortBookMark(FFrame&, void* const)
native static function bool RequestTelePortBookMark(ItemID SlotID);

// Export UBookMarkAPI::execRequestChangeBookMarkSlot(FFrame&, void* const)
native static function bool RequestChangeBookMarkSlot(ItemID slotID1, ItemID slotID2);

// Export UBookMarkAPI::execRequestGetBookMarkPos(FFrame&, void* const)
native static function bool RequestGetBookMarkPos(ItemID SlotID, out Vector pos);

defaultproperties
{
}
