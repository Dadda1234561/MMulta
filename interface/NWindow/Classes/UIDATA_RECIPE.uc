//================================================================================
// UIDATA_RECIPE.
//================================================================================

class UIDATA_RECIPE extends UIDataManager
	native;

// Export UUIDATA_RECIPE::execGetRecipeItemID(FFrame&, void* const)
native static function ItemID GetRecipeItemID(int Id);

// Export UUIDATA_RECIPE::execGetRecipeIconName(FFrame&, void* const)
native static function string GetRecipeIconName(int Id);

// Export UUIDATA_RECIPE::execGetRecipeProductID(FFrame&, void* const)
native static function int GetRecipeProductID(int Id);

// Export UUIDATA_RECIPE::execGetRecipeProductNum(FFrame&, void* const)
native static function int GetRecipeProductNum(int Id);

// Export UUIDATA_RECIPE::execGetRecipeCrystalType(FFrame&, void* const)
native static function int GetRecipeCrystalType(int Id);

// Export UUIDATA_RECIPE::execGetRecipeMpConsume(FFrame&, void* const)
native static function int GetRecipeMpConsume(int Id);

// Export UUIDATA_RECIPE::execGetRecipeLevel(FFrame&, void* const)
native static function int GetRecipeLevel(int Id);

// Export UUIDATA_RECIPE::execGetRecipeDescription(FFrame&, void* const)
native static function string GetRecipeDescription(int Id);

// Export UUIDATA_RECIPE::execGetRecipeSuccessRate(FFrame&, void* const)
native static function int GetRecipeSuccessRate(int Id);

// Export UUIDATA_RECIPE::execGetRecipeIsMultipleProduct(FFrame&, void* const)
native static function int GetRecipeIsMultipleProduct(int Id);

// Export UUIDATA_RECIPE::execGetRecipeMaterialItem(FFrame&, void* const)
native static function string GetRecipeMaterialItem(int Id);

// Export UUIDATA_RECIPE::execIsOfferingItem(FFrame&, void* const)
native static function bool IsOfferingItem(ItemID Id, optional bool IsShop);

defaultproperties
{
}
