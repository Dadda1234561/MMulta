/***
 * 
 *  ��Ƽ��Ʈ ����â
 * 
 * */
 class ArtifactEnchantSubWnd extends UICommonAPI;

 //const ARTIFACTTYE_NORMAL = 4398046511104;
 //const ARTIFACTTYE_TYPE1  = 18014398509481984;
 //const ARTIFACTTYE_TYPE2  = 144115188075855872;
 //const ARTIFACTTYE_TYPE3  = 1152921504606846976;
 
 var WindowHandle Me;
 var ItemWindowHandle SubWnd_Item1;
 var WindowHandle  DescriptionMsgWnd;
 
 var TextBoxHandle Inventory_Title_TextBox;
 var TextBoxHandle descTextBox;
 
 //var L2Util util;
 var InventoryWnd inventoryWndScript;
 
 var ArtifactEnchantWnd ArtifactEnchantWndScript;
 
 function OnRegisterEvent()
 {
	 //RegisterEvent(  );
 }
 
 function OnLoad()
 {
	 Initialize();
 }
 
 function Initialize()
 {
	 ArtifactEnchantWndScript = ArtifactEnchantWnd(GetScript("ArtifactEnchantWnd"));
 
	 Me = GetWindowHandle( "ArtifactEnchantSubWnd" );
	 Inventory_Title_TextBox = GetTextBoxHandle( "ArtifactEnchantSubWnd.Inventory_Title_TextBox" );
 
	 SubWnd_Item1 = GetItemWindowHandle( "ArtifactEnchantSubWnd.SubWnd_Item1" );
 
	 DescriptionMsgWnd = GetWindowHandle( "ArtifactEnchantSubWnd.DescriptionMsgWnd" );
	 descTextBox       = GetTextBoxHandle( "ArtifactEnchantSubWnd.DescriptionMsgWnd.descTextBox" );
 
	 inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
 }
 
 function OnRClickItem( String strID, int index )
 {
	 OnDBClickItem(strID, index);
 }
 
 function OnDBClickItem( string ControlName, int index )
 {
	 local ItemInfo info;
 
	 SubWnd_Item1.GetItem(index, info);
 
	 if (info.Id.ClassID > 0) ArtifactEnchantWndScript.dropProcess(info);
 }
 
 // â ��Ȱ��
 function setEnable(bool bFlag)
 {
	 if (bFlag)
	 {
		 DescriptionMsgWnd.HideWindow();
	 }
	 else
	 {		
		 DescriptionMsgWnd.ShowWindow();		
	 }
 }
 
 // ��Ƽ��Ʈ ��ũ��Ʈ���� ������ ���� ���ؼ�, ���� �������� ��� �׸� �ִ��� ��ȸ
 function bool isInArtifactGroup(out array<int> materialIDArray, int targetClassID)
 {
	 local int i;
 
	 for(i = 0; i < materialIDArray.Length; i++)
	 {
		 // Debug("materialIDArray[ " @ i @ "] : " @ materialIDArray[i]);
		 if (materialIDArray[i] == targetClassID)
		 {
			 // Debug("��� ���ǿ� ���Ե� ������ ID" @ targetClassID);
			 return true;
		 }
	 }
 
	 return false;
 }
 
 // ����, ��ȥ�� ���� ������ ������ ������Ʈ
 // ��Ƽ��Ʈ �׷�, �䱸�ϴ� �ּ� ��æƮ �� 
 function syncInventory(int artifactGroupID, int reqMinEnchantedNum)
{
	local array<ItemInfo> itemArray;
	local array<int> materialIDArray;

	local array<ItemInfo> artifactItemArray;
	local int i;
	local bool bDoNotNeedGroupID;

	local int tmGroupID, materialCount, resultProb;

	SubWnd_Item1.Clear();
	class'UIDATA_INVENTORY'.static.GetAllArtifactItem(itemArray);
	
	// ��Ʈ��Ʈ �׷� üũ ����.
	if (artifactGroupID == -1)
	{
		bDoNotNeedGroupID = true;
	}

	class'UIDATA_ARTIFACT'.static.GetArtifactMaterialGroupList(artifactGroupID, materialIDArray);

	//Debug("bDoNotNeedGroupID:"  @ bDoNotNeedGroupID);
	//Debug("reqMinEnchantedNum" @ reqMinEnchantedNum);

	for (i = 0; i < itemArray.Length;i++)
	{
		// ��ᰡ 0�̸� ��æƮ �Ұ�, �߰� ����.
		materialCount = 0;

		// ��ȥUI���� ��� ���� �������� �ƴ϶��..,  
		// ���� �� �������� �ƴ϶��..,
		// ������ �׷� ��Ƽ��Ʈ �������ΰ�?
		if (!ArtifactEnchantWndScript.externalCheckUsingItem(itemArray[i]) && 
			!itemArray[i].bSecurityLock &&
			(isInArtifactGroup(materialIDArray, itemArray[i].Id.ClassID) || bDoNotNeedGroupID) &&
			itemArray[i].Enchanted >= reqMinEnchantedNum)
			
		{

			// ttp 83409, �־ �� �̻� �Ұ����� ��Ƽ��Ʈ�� �������Կ� ������ �ʵ��� �Ѵ�.
			// ��Ƽ��Ʈ�� �ϳ��� �Ȳ��� ���¿����� üũ
			if (ArtifactEnchantWndScript.getSlot(0).GetItemNum() == 0)
			{
				class'UIDATA_ARTIFACT'.static.GetArtifactEnchantCondition(itemArray[i].Id.ClassID, itemArray[i].Enchanted, tmGroupID, materialCount, resultProb);
			
				//Debug("name" @ itemArray[i].Name);
				//Debug("materialCount" @ materialCount);
				//Debug("itemArray[i].Enchanted" @ itemArray[i].Enchanted);
				//Debug("======> resultProb:::: " @ resultProb);

				// ��� ������ ���ٸ� �߰� ���� ������, �н� 
				if (materialCount <= 0) continue;
			}
				
			artifactItemArray[artifactItemArray.Length] = itemArray[i];
		}
	}

	if (artifactItemArray.Length > 0) 
	{
		SortAttifactItemAndAddITem(artifactItemArray);
		descTextBox.SetText("");
	}
	else 
	{
		descTextBox.SetText(GetSystemMessage(4222));
	}


	if(SubWnd_Item1.GetItemNum() > 0)
	{
		setEnable(true);
	}
	else
	{
		setEnable(false);
	}
}
 
 
 /********************************************************************************************
  * ����
  * ******************************************************************************************/
 function SortAttifactItemAndAddITem (array<ItemInfo> ArtifactList) 
 {
	 local int i ;
	 local Array<ItemInfo> ArtifactListNormal, ArtifactListType1, ArtifactListType2, ArtifactListType3;
	 
	 
	 // ��æƮ ��ġ�� ���߰� 
	 ArtifactList = getInstanceL2Util().sortByEnchanted( ArtifactList ) ;
	 
	 // �̸����� ���߰� 
	 ArtifactList = getInstanceL2Util().sortByName( ArtifactList ) ;
	 
	 for  ( i = 0 ;i < ArtifactList.Length ; i++ ) 
	 {
		 switch ( ArtifactList[i].slotBitType ) 
		 {	
			 case INT64("18014398509481984"):
				  ArtifactListType1[ArtifactListType1.Length]   = ArtifactList[i];				
				  break;
 
			 case INT64("144115188075855870"):
				  ArtifactListType2[ArtifactListType2.Length]   = ArtifactList[i];				
				  break;
 
			 case INT64("1152921504606847000"):
				  ArtifactListType3[ArtifactListType3.Length]   = ArtifactList[i];				
				  break;
 
			 case INT64("4398046511104") :
			 case 4398046511104:
				  ArtifactListNormal[ArtifactListNormal.Length] = ArtifactList[i];				
				  break;
		 }
	 }
 
	 SubWnd_Item1.Clear();
 
	
	 // �����۸�Ͽ� �߰�
	 for  ( i = 0 ; i < ArtifactListType1.Length ; i ++ ) 
		 SubWnd_Item1.AddItem(ArtifactListType1[i]);
 
	 for  ( i = 0 ; i < ArtifactListType2.Length ; i ++ ) 
		 SubWnd_Item1.AddItem(ArtifactListType2[i]);
 
	 for  ( i = 0 ; i < ArtifactListType3.Length ; i ++ ) 
		 SubWnd_Item1.AddItem(ArtifactListType3[i]);
 
	 for  ( i = 0 ; i < ArtifactListNormal.Length ; i ++ ) 
		 SubWnd_Item1.AddItem(ArtifactListNormal[i]);
 }
 defaultproperties
 {
 }
 