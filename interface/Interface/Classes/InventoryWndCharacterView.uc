/*******************************************************************************
 * InventoryWndCharacterView generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2022 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
 class InventoryWndCharacterView extends UICommonAPI;

 const ORCRIDERSCALE = 0.803f;
 const ORCRIDERX = 0;
 const ORCRIDERY = 1;
 const TIMER_ID_ANIMATION = 19;
 const TIMER_DELAY = 2000;
 const TIMER_ID_CLICK = 2;
 const TIMER_DELAY_CLICK = 150;
 const ROOTNAME = "root";
 
 struct ArtifactSkillInfoStruct
 {
	 var ItemID Id;
	 var int SkillID;
	 var int Level;
	 var string Name;
	 var string IconName;
	 var string IconPanel;
	 var string Description;
	 var int ArtifactType;
	 var int ArtifactPage;
 };
 
 var WindowHandle Me;
 var string m_WindowName;
 var ButtonHandle m_CloseButton;
 var CharacterViewportWindowHandle m_ObjectViewport;
 var ButtonHandle m_BtnRotateLeft;
 var ButtonHandle m_BtnRotateRight;
 var bool isDown;
 var bool isAniPlaing;
 var int m_MeshType;
 var TreeHandle MainTree;
 
 function OnRegisterEvent()
 {
	 RegisterEvent(3810);
	 return;
 }
 
 function OnLoad()
 {
	 InitHandleCOD();
	 return;
 }
 
 function OnEvent(int Event_ID, string param)
 {
	 switch(Event_ID)
	 {
		 // End:0x1D
		 case 3810:
			 HandleChangeCharacterPawn(param);
			 // End:0x23
			 break;
		 // End:0xFFFF
		 default:
			 // End:0x23
			 break;
			 break;
	 }
	 return;
 }
 
 function OnClickButton(string strID)
 {
	 switch(strID)
	 {
		 // End:0x20
		 case "CloseButton":
			 ToggleMe();
			 // End:0x6F
			 break;
		 // End:0x4F
		 case "btnAllList":
			 toggleWindow("ArtifactItemListWnd", true, true);
			 // End:0x6F
			 break;
		 // End:0xFFFF
		 default:
			 ClickTreeNode(strID);
			 MainTree.SetFocus();
			 // End:0x6F
			 break;
			 break;
	 }
	 return;
 }
 
 function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
 {
	 // End:0x22
	 if(a_WindowHandle == m_BtnRotateLeft)
	 {
		 m_ObjectViewport.StartRotation(false);        
	 }
	 else
	 {
		 // End:0x44
		 if(a_WindowHandle == m_BtnRotateRight)
		 {
			 m_ObjectViewport.StartRotation(true);            
		 }
		 else
		 {
			 // End:0x6E
			 if(a_WindowHandle == m_ObjectViewport)
			 {
				 Me.SetTimer(2, 150);
				 isDown = true;
			 }
		 }
	 }
	 return;
 }
 
 function OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
 {
	 // End:0x21
	 if(a_WindowHandle == m_BtnRotateLeft)
	 {
		 m_ObjectViewport.EndRotation();        
	 }
	 else
	 {
		 // End:0x42
		 if(a_WindowHandle == m_BtnRotateRight)
		 {
			 m_ObjectViewport.EndRotation();            
		 }
		 else
		 {
			 // End:0xCC
			 if((!isAniPlaing && isDown) && a_WindowHandle == m_ObjectViewport)
			 {
				 isAniPlaing = true;
				 // End:0x9F
				 if((m_MeshType == 18) || m_MeshType == 19)
				 {
					 m_ObjectViewport.PlayAnimation(3);                    
				 }
				 else
				 {
					 PlayRandAttackAnimation();
				 }
				 Me.KillTimer(19);
				 Me.SetTimer(19, 2000);
			 }
		 }
	 }
	 Me.KillTimer(2);
	 isDown = false;
	 return;
 }
 
 function OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
 {
	 // End:0x5C
	 if((!isAniPlaing && isDown) && a_WindowHandle == m_ObjectViewport)
	 {
		 isAniPlaing = true;
		 PlayRandAnimation();
		 Me.KillTimer(19);
		 Me.SetTimer(19, 2000);
	 }
	 Me.KillTimer(2);
	 isDown = false;
	 return;
 }
 
 function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
 {
	 // End:0x2A
	 if(a_WindowHandle == m_ObjectViewport)
	 {
		 Me.SetTimer(2, 150);
		 isDown = true;
	 }
	 return;
 }
 
 function OnTimer(int TimerID)
 {
	 switch(TimerID)
	 {
		 // End:0x28
		 case 19:
			 Me.KillTimer(19);
			 isAniPlaing = false;
			 // End:0x4C
			 break;
		 // End:0x49
		 case 2:
			 Me.KillTimer(2);
			 isDown = false;
			 // End:0x4C
			 break;
		 // End:0xFFFF
		 default:
			 break;
	 }
	 return;
 }
 
 function PlayRandAttackAnimation()
 {
	 local int aniType;
 
	 aniType = Rand(3) + 1;
	 m_ObjectViewport.PlayAttackAnimation(aniType);
	 return;
 }
 
 function PlayRandAnimation()
 {
	 local int aniType;
 
	 aniType = Rand(13) + 1;
	 m_ObjectViewport.PlayAnimation(aniType);
	 return;
 }
 
 function InitHandleCOD()
 {
	 Me = GetWindowHandle(m_WindowName);
	 m_BtnRotateLeft = GetButtonHandle(m_WindowName $ ".TabCharacterView.BtnRotateLeft");
	 m_BtnRotateRight = GetButtonHandle(m_WindowName $ ".TabCharacterView.BtnRotateRight");
	 m_CloseButton = GetButtonHandle(m_WindowName $ ".CloseButton");
	 m_ObjectViewport = GetCharacterViewportWindowHandle(m_WindowName $ ".TabCharacterView.ObjectViewport");
	 m_ObjectViewport.SetDragRotationRate(300);
	 // End:0x122
	 if(getInstanceUIData().getIsLiveServer())
	 {
		 MainTree = GetTreeHandle(m_WindowName $ ".TabBounsView.MainTree");
	 }
	 return;
 }
 
 function HandleChangeCharacterPawn(string param)
 {
	 local UserInfo uInfo;
 
	 ParseInt(param, "MeshType", m_MeshType);
	 switch(m_MeshType)
	 {
		 // End:0x64
		 case 0:
			 m_ObjectViewport.SetCharacterScale(1);
			 m_ObjectViewport.SetCharacterOffsetX(-2);
			 m_ObjectViewport.SetCharacterOffsetY(-3);
			 // End:0x566
			 break;
		 // End:0xA7
		 case 1:
			 m_ObjectViewport.SetCharacterScale(1.03);
			 m_ObjectViewport.SetCharacterOffsetX(-2);
			 m_ObjectViewport.SetCharacterOffsetY(-5);
			 // End:0x566
			 break;
		 // End:0xE8
		 case 8:
			 m_ObjectViewport.SetCharacterScale(1.047);
			 m_ObjectViewport.SetCharacterOffsetX(2);
			 m_ObjectViewport.SetCharacterOffsetY(-5);
			 // End:0x566
			 break;
		 // End:0x12C
		 case 9:
			 m_ObjectViewport.SetCharacterScale(1.07);
			 m_ObjectViewport.SetCharacterOffsetX(-1);
			 m_ObjectViewport.SetCharacterOffsetY(-6);
			 // End:0x566
			 break;
		 // End:0x170
		 case 6:
			 m_ObjectViewport.SetCharacterScale(0.98);
			 m_ObjectViewport.SetCharacterOffsetX(-2);
			 m_ObjectViewport.SetCharacterOffsetY(-4);
			 // End:0x566
			 break;
		 // End:0x1B4
		 case 7:
			 m_ObjectViewport.SetCharacterScale(1.04);
			 m_ObjectViewport.SetCharacterOffsetX(-4);
			 m_ObjectViewport.SetCharacterOffsetY(-5);
			 // End:0x566
			 break;
		 // End:0x1F8
		 case 2:
			 m_ObjectViewport.SetCharacterScale(0.99);
			 m_ObjectViewport.SetCharacterOffsetX(-1);
			 m_ObjectViewport.SetCharacterOffsetY(-4);
			 // End:0x566
			 break;
		 // End:0x23C
		 case 3:
			 m_ObjectViewport.SetCharacterScale(1.015);
			 m_ObjectViewport.SetCharacterOffsetX(-1);
			 m_ObjectViewport.SetCharacterOffsetY(-4);
			 // End:0x566
			 break;
		 // End:0x2D2
		 case 10:
			 // End:0x2CF
			 if(GetPlayerInfo(uInfo))
			 {
				 // End:0x297
				 if(uInfo.Class == 217)
				 {
					 m_ObjectViewport.SetCharacterScale(0.803);
					 m_ObjectViewport.SetCharacterOffsetX(0);
					 m_ObjectViewport.SetCharacterOffsetY(1);                    
				 }
				 else
				 {
					 m_ObjectViewport.SetCharacterScale(0.953);
					 m_ObjectViewport.SetCharacterOffsetX(0);
					 m_ObjectViewport.SetCharacterOffsetY(-6);
				 }
			 }
			 // End:0x566
			 break;
		 // End:0x313
		 case 11:
			 m_ObjectViewport.SetCharacterScale(0.97);
			 m_ObjectViewport.SetCharacterOffsetX(2);
			 m_ObjectViewport.SetCharacterOffsetY(-5);
			 // End:0x566
			 break;
		 // End:0x357
		 case 12:
			 m_ObjectViewport.SetCharacterScale(0.955);
			 m_ObjectViewport.SetCharacterOffsetX(-2);
			 m_ObjectViewport.SetCharacterOffsetY(-5);
			 // End:0x566
			 break;
		 // End:0x397
		 case 13:
			 m_ObjectViewport.SetCharacterScale(0.985);
			 m_ObjectViewport.SetCharacterOffsetX(0);
			 m_ObjectViewport.SetCharacterOffsetY(-5);
			 // End:0x566
			 break;
		 // End:0x3D3
		 case 4:
			 m_ObjectViewport.SetCharacterScale(1.043);
			 m_ObjectViewport.SetCharacterOffsetX(0);
			 m_ObjectViewport.SetCharacterOffsetY(1);
			 // End:0x566
			 break;
		 // End:0x413
		 case 5:
			 m_ObjectViewport.SetCharacterScale(1.09);
			 m_ObjectViewport.SetCharacterOffsetX(0);
			 m_ObjectViewport.SetCharacterOffsetY(-3);
			 // End:0x566
			 break;
		 // End:0x457
		 case 14:
			 m_ObjectViewport.SetCharacterScale(0.993);
			 m_ObjectViewport.SetCharacterOffsetX(-5);
			 m_ObjectViewport.SetCharacterOffsetY(-4);
			 // End:0x566
			 break;
		 // End:0x497
		 case 15:
			 m_ObjectViewport.SetCharacterScale(1.01);
			 m_ObjectViewport.SetCharacterOffsetX(0);
			 m_ObjectViewport.SetCharacterOffsetY(-3);
			 // End:0x566
			 break;
		 // End:0x4DB
		 case 17:
			 m_ObjectViewport.SetCharacterScale(1.015);
			 m_ObjectViewport.SetCharacterOffsetX(-1);
			 m_ObjectViewport.SetCharacterOffsetY(-1);
			 // End:0x566
			 break;
		 // End:0x51F
		 case 18:
			 m_ObjectViewport.SetCharacterScale(1.015);
			 m_ObjectViewport.SetCharacterOffsetX(-1);
			 m_ObjectViewport.SetCharacterOffsetY(-1);
			 // End:0x566
			 break;
		 // End:0x563
		 case 19:
			 m_ObjectViewport.SetCharacterScale(1.015);
			 m_ObjectViewport.SetCharacterOffsetX(-1);
			 m_ObjectViewport.SetCharacterOffsetY(-1);
			 // End:0x566
			 break;
		 // End:0xFFFF
		 default:
			 break;
	 }
	 return;
 }
 
 function int GetInitClassID(int currentClassID)
 {
	 local array<int> EnableClassIndexList;
 
	 Class'UIDataManager'.static.GetEnableClassIndexList(currentClassID, EnableClassIndexList);
	 return EnableClassIndexList[0];
 }
 
 function TreeInsertBlankNodeItem(string NodeName, int gabY)
 {
	 local XMLTreeNodeItemInfo infNodeItem;
 
	 infNodeItem.eType = EXMLTreeNodeItemType.XTNITEM_BLANK;
	 infNodeItem.bStopMouseFocus = true;
	 infNodeItem.b_nHeight = gabY;
	 MainTree.InsertNodeItem(NodeName, infNodeItem);
	 return;
 }
 
 function ArtifactSkillInfoStruct HandleArtifactItemList2SkillInfo(ItemInfo Info)
 {
	 local ArtifactSkillInfoStruct artifactSkillInfo;
	 local ArtifactUIData ArtifactData;
	 local SkillInfo SkillInfo;
 
	 Class'UIDATA_ARTIFACT'.static.FindArtifactData(Info.Id.ClassID, ArtifactData);
	 GetSkillInfo(ArtifactData.EnchantSkillID, Info.Enchanted + 1, 0, SkillInfo);
	 artifactSkillInfo.Name = SkillInfo.SkillName;
	 artifactSkillInfo.Level = SkillInfo.SkillLevel;
	 artifactSkillInfo.IconName = SkillInfo.TexName;
	 artifactSkillInfo.IconPanel = SkillInfo.IconPanel;
	 artifactSkillInfo.Description = SkillInfo.SkillDesc;
	 artifactSkillInfo.SkillID = SkillInfo.SkillID;
	 artifactSkillInfo.Id = Info.Id;
	 return artifactSkillInfo;
 }
 
 function MakeNodes(array<ArtifactSkillInfoStruct> artifactSkillInfos, int ArtifactType)
 {
	 local int i, MaxW;
	 local string strNodeName;
	 local Color enchantedColor, NameColor;
	 local array<int> nodeNums;
 
	 enchantedColor.R = 170;
	 enchantedColor.G = 108;
	 enchantedColor.B = 231;
	 enchantedColor.A = byte(255);
	 NameColor.R = 220;
	 NameColor.G = 220;
	 NameColor.B = 220;
	 NameColor.A = byte(255);
	 nodeNums.Length = 3;
	 MaxW = 218;
 
	 for(i = 0; i < artifactSkillInfos.Length; i++)
	 {
		 strNodeName = makeNode(string(nodeNums[ArtifactType]), ("root" $ ".") $ string(ArtifactType));
		 if(nodeNums[ArtifactType] == 0)
		 {
			 TreeInsertBlankNodeItem(strNodeName, 5);
		 }
		 if((float(nodeNums[ArtifactType]) % float(2)) == float(0))
		 {
			 getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, "L2UI_CT1.EmptyBtn", 260, 38);            
		 }
		 else
		 {
			 getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, "L2UI_CH3.etc.textbackline", 260, 38,,,,, 14);
		 }
		 getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, "L2UI_CT1.ItemWindow.ItemWindow_DF_SlotBox_Default", 36, 36, -260, 1);
		 getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, artifactSkillInfos[i].IconName, 32, 32, -34, 2);
		 getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, artifactSkillInfos[i].IconPanel, 32, 32, -32, 2);
		 if(artifactSkillInfos[i].Level > 1)
		 {
			 TreeHandleInsertTextNodeItem(strNodeName, "+" $ string(artifactSkillInfos[i].Level - 1), 3, 4, enchantedColor, true);
			 TreeHandleInsertTextNodeItem(strNodeName, GetEllipsisString(artifactSkillInfos[i].Name, MaxW - 44), 10, 4, NameColor, true);            
		 }
		 else
		 {
			 TreeHandleInsertTextNodeItem(strNodeName, GetEllipsisString(artifactSkillInfos[i].Name, MaxW), 3, 4, NameColor, true);
		 }
		//  getInstanceL2Util().TreeHandleInsertTextNodeItem(MainTree, strNodeName, GetEllipsisString(artifactSkillInfos[i].Description, MaxW), 37, -17, ETreeItemTextType.COLOR_GOLD, true, true);
		 nodeNums[ArtifactType]++;
	 }
	 artifactSkillInfos.Length = 0;
 }
 
 function Clear()
 {
	 MainTree.Clear();
	 return;
 }
 
 function StartTreeWnd(string param)
 {
	 Clear();
	 return;
 }
 
 function ExpandNodes()
 {
	 local int i;
 
	 for(i = 0; i < 3; i ++)
	 {
		 if(MainTree.GetChildNode(("root" $ ".") $ string(i)) != "")
		 {
			 MainTree.SetExpandedNode(("root" $ ".") $ string(i), true);
			 continue;
		 }
		 MainTree.SetExpandedNode(("root" $ ".") $ string(i), false);
	 }
	 return;
 }
 
 function MakeRootNodes()
 {
	 local XMLTreeNodeInfo infNode;
	 local int i;
 
	 infNode.strName = "root";    
	 MainTree.InsertNode("root", infNode);

	 for(i = 0; i < 3; i++)
	 {        
		 InsertExpandNode(i);
	 }
 }
 
 function string makeNode(string NodeName, string parentname)
 {
	 local XMLTreeNodeInfo infNode, infNodeClear;
 
	 infNode = infNodeClear;
	 infNode.strName = NodeName;
	 infNode.nOffSetX = 2;
	 return MainTree.InsertNode(parentname, infNode);
 }
 
 function string InsertExpandNode(int NodeNum)
 {
	 local string NodeName;
	 local Color NameColor;
 
	 NameColor.R = 220;
	 NameColor.G = 220;
	 NameColor.B = 220;
	 NameColor.A = byte(255);
	 NodeName = ("root" $ ".") $ string(NodeNum);
	 getInstanceL2Util().TreeHandleInsertExpandBtnNode(MainTree, string(NodeNum), "root",,,,,,,, 7);
	 TreeHandleInsertTextNodeItem(NodeName, GetSystemString(3881) @ string(NodeNum + 1), 2, 1, NameColor, true);
	 return NodeName;
 }
 
 function TreeHandleInsertTextNodeItem(string NodeName, string ItemName, int OffsetX, int OffsetY, Color C, bool oneline)
 {
	 local XMLTreeNodeItemInfo infNodeItem;
 
	 infNodeItem.eType = EXMLTreeNodeItemType.XTNITEM_TEXT;
	 infNodeItem.t_strText = ItemName;
	 infNodeItem.nOffSetX = OffsetX;
	 infNodeItem.nOffSetY = OffsetY;
	 infNodeItem.t_bDrawOneLine = oneline;
	 infNodeItem.t_color.R = C.R;
	 infNodeItem.t_color.G = C.G;
	 infNodeItem.t_color.B = C.B;
	 infNodeItem.t_color.A = C.A;
	 MainTree.InsertNodeItem(NodeName, infNodeItem);
 }
 
 function ResetArtifactSkillList()
 {
	 local int currentActiveNum;
	 local InventoryWnd inventoryWndScript;
 
	 inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	 Clear();
	 MakeRootNodes();
	 if(inventoryWndScript.IsSlotEmpty(37))
	 {
		 inventoryWndScript.SetArtifactEffectByStoneState(-1);
		 inventoryWndScript.SetArtifactActiveStone(0);
		 inventoryWndScript.SetArtifactActiveSet(0, false);
		 inventoryWndScript.SetArtifactActiveSet(1, false);
		 inventoryWndScript.SetArtifactActiveSet(2, false);
		 return;
	 }
	 if(ResetArtifactSkill(0))
	 {
		 currentActiveNum++;
	 }
	 if(ResetArtifactSkill(1))
	 {
		 currentActiveNum++;
	 }
	 if(ResetArtifactSkill(2))
	 {
		 currentActiveNum++;
	 }
	 inventoryWndScript.SetArtifactActiveStone(currentActiveNum);
	 inventoryWndScript.SetArtifactEffectByStoneState(currentActiveNum);
	 ExpandNodes();
	 return;
 }
 
 function bool ResetArtifactSkill(int ArtifactType)
 {
	 local InventoryWnd inventoryWndScript;
	 local bool IsActive;
	 local int i;
	 local array<ItemInfo> infos;
	 local array<ArtifactSkillInfoStruct> artifactSkills;
 
	 // End:0x17
	 if(!getInstanceUIData().getIsLiveServer())
	 {
		 return false;
	 }
	 inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	 infos = inventoryWndScript.GetArtifactEquipedList(ArtifactType);
	 artifactSkills.Length = infos.Length;
 
	 for(i = 0; i < infos.Length; i++)
	 {
		 artifactSkills[i] = HandleArtifactItemList2SkillInfo(infos[i]);
	 }
	 MakeNodes(artifactSkills, ArtifactType);
	 IsActive = infos.Length >= 7;
	 if(IsActive)
	 {
		 inventoryWndScript.SetArtifactActiveSet(ArtifactType, true);        
	 }
	 else
	 {
		 inventoryWndScript.SetArtifactActiveSet(ArtifactType, false);
	 }
	 return IsActive;
 }
 
 function ClickTreeNode(string Name)
 {
	 local string childNodes;
 
	 childNodes = MainTree.GetChildNode(Name);
	 // End:0x3B
	 if(childNodes == "")
	 {
		 MainTree.SetExpandedNode(Name, false);
	 }
	 return;
 }
 
 function ToggleMe()
 {
	 local InventoryWnd inventoryWndScript;
 
	 inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	 inventoryWndScript.toogleCharacterViewPort(!Me.IsShowWindow());
	 return;
 }
 
 function string GetEllipsisString(string Str, int MaxWidth)
 {
	 local string fixedString;
	 local int nWidth, nHeight;
 
	 GetTextSizeDefault(Str $ "...", nWidth, nHeight);
	 // End:0x31
	 if(nWidth < MaxWidth)
	 {
		 return Str;
	 }
	 fixedString = DivideStringWithWidth(Str, MaxWidth);
	 // End:0x68
	 if(fixedString != Str)
	 {
		 fixedString = fixedString $ "...";
	 }
	 return fixedString;
 }
 
 function ArtifactClicked()
 {
	 // End:0x1A
	 if(!Me.IsShowWindow())
	 {
		 ToggleMe();
	 }
	 GetTabHandle(m_WindowName $ ".CharacterTab").SetTopOrder(1, true);
	 return;
 }
 
 function CharacterClickec()
 {
	 // End:0x1A
	 if(!Me.IsShowWindow())
	 {
		 ToggleMe();
	 }
	 GetTabHandle(m_WindowName $ ".CharacterTab").SetTopOrder(0, true);
	 return;
 }
 
 defaultproperties
 {
	 m_WindowName="InventoryWndCharacterView"
 }