package l2s.gameserver.network.l2;

import l2s.commons.net.nio.impl.IClientFactory;
import l2s.commons.net.nio.impl.IMMOExecutor;
import l2s.commons.net.nio.impl.IPacketHandler;
import l2s.commons.net.nio.impl.MMOConnection;
import l2s.commons.net.nio.impl.ReceivablePacket;
import l2s.gameserver.Config;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.network.l2.c2s.*;
import l2s.gameserver.network.l2.c2s.collection.RequestExCollectionCloseUI;
import l2s.gameserver.network.l2.c2s.collection.RequestExCollectionFavoriteList;
import l2s.gameserver.network.l2.c2s.collection.RequestExCollectionList;
import l2s.gameserver.network.l2.c2s.collection.RequestExCollectionOpenUI;
import l2s.gameserver.network.l2.c2s.collection.RequestExCollectionReceiveReward;
import l2s.gameserver.network.l2.c2s.collection.RequestExCollectionRegister;
import l2s.gameserver.network.l2.c2s.collection.RequestExCollectionSummary;
import l2s.gameserver.network.l2.c2s.collection.RequestExCollectionUpdateFavorite;
import l2s.gameserver.network.l2.c2s.compound.RequestNewEnchantClose;
import l2s.gameserver.network.l2.c2s.compound.RequestNewEnchantPushOne;
import l2s.gameserver.network.l2.c2s.compound.RequestNewEnchantPushTwo;
import l2s.gameserver.network.l2.c2s.compound.RequestNewEnchantRemoveOne;
import l2s.gameserver.network.l2.c2s.compound.RequestNewEnchantRemoveTwo;
import l2s.gameserver.network.l2.c2s.compound.RequestNewEnchantRetryToPutItems;
import l2s.gameserver.network.l2.c2s.compound.RequestNewEnchantTry;
import l2s.gameserver.network.l2.c2s.costume.RequestExCostumeChangeShortcut;
import l2s.gameserver.network.l2.c2s.costume.RequestExCostumeCollectionSkillActive;
import l2s.gameserver.network.l2.c2s.costume.RequestExCostumeEvolution;
import l2s.gameserver.network.l2.c2s.costume.RequestExCostumeExtract;
import l2s.gameserver.network.l2.c2s.costume.RequestExCostumeList;
import l2s.gameserver.network.l2.c2s.costume.RequestExCostumeLock;
import l2s.gameserver.network.l2.c2s.costume.RequestExCostumeUseItem;
import l2s.gameserver.network.l2.c2s.enchant.RequestExAddEnchantScrollItem;
import l2s.gameserver.network.l2.c2s.enchant.RequestExCancelEnchantItem;
import l2s.gameserver.network.l2.c2s.enchant.RequestExEnchantFailRewardInfo;
import l2s.gameserver.network.l2.c2s.enchant.RequestExFinishMultiEnchantScroll;
import l2s.gameserver.network.l2.c2s.enchant.RequestExMultiEnchantItemList;
import l2s.gameserver.network.l2.c2s.enchant.RequestExSetMultiEnchantItemList;
import l2s.gameserver.network.l2.c2s.enchant.RequestExStartMultiEnchantScroll;
import l2s.gameserver.network.l2.c2s.enchant.RequestExViewEnchantResult;
import l2s.gameserver.network.l2.c2s.enchant.RequestExViewMultiEnchantResult;
import l2s.gameserver.network.l2.c2s.events.RequestExBalrogWarGetReward;
import l2s.gameserver.network.l2.c2s.events.RequestExBalrogWarShowRanking;
import l2s.gameserver.network.l2.c2s.events.RequestExBalrogWarShowUI;
import l2s.gameserver.network.l2.c2s.events.RequestExBalrogWarTeleport;
import l2s.gameserver.network.l2.c2s.events.RequestExFestivalBMGame;
import l2s.gameserver.network.l2.c2s.events.RequestExFestivalBMInfo;
import l2s.gameserver.network.l2.c2s.events.RequestExLetterCollectorTakeReward;
import l2s.gameserver.network.l2.c2s.herobook.RequestHeroBookCharge;
import l2s.gameserver.network.l2.c2s.herobook.RequestHeroBookEnchant;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExActivateHomunculus;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExDeleteHomunculusData;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExEnchantHomunculusSkill;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExHomunculusActiveSlot;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExHomunculusCreateStart;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExHomunculusEnchantExp;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExHomunculusGetEnchantPoint;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExHomunculusInitPoint;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExHomunculusInsert;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExHomunculusProbList;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExHomunculusSummon;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExShowHomunculusInfo;
import l2s.gameserver.network.l2.c2s.homunculus.RequestExSummonHomunculusCoupon;
import l2s.gameserver.network.l2.c2s.items.autopeel.RequestExItemAutoPeel;
import l2s.gameserver.network.l2.c2s.items.autopeel.RequestExReadyItemAutoPeel;
import l2s.gameserver.network.l2.c2s.items.autopeel.RequestExStopItemAutoPeel;
import l2s.gameserver.network.l2.c2s.magiclamp.RequestExMagicLampGameInfo;
import l2s.gameserver.network.l2.c2s.magiclamp.RequestExMagicLampGameStart;
import l2s.gameserver.network.l2.c2s.newhenna.*;
import l2s.gameserver.network.l2.c2s.pledge.RequestAnswerJoinPledge;
import l2s.gameserver.network.l2.c2s.pledge.RequestExCreatePledge;
import l2s.gameserver.network.l2.c2s.pledge.RequestExPledgeAnnounce;
import l2s.gameserver.network.l2.c2s.pledge.RequestExPledgeContributionInfo;
import l2s.gameserver.network.l2.c2s.pledge.RequestExPledgeContributionRank;
import l2s.gameserver.network.l2.c2s.pledge.RequestExPledgeContributionReward;
import l2s.gameserver.network.l2.c2s.pledge.RequestExPledgeItemBuy;
import l2s.gameserver.network.l2.c2s.pledge.RequestExPledgeItemList;
import l2s.gameserver.network.l2.c2s.pledge.RequestExPledgeLevelUp;
import l2s.gameserver.network.l2.c2s.pledge.RequestExPledgeMasteryInfo;
import l2s.gameserver.network.l2.c2s.pledge.RequestExPledgeMasteryReset;
import l2s.gameserver.network.l2.c2s.pledge.RequestExPledgeMasterySet;
import l2s.gameserver.network.l2.c2s.pledge.RequestExPledgeSkillActivate;
import l2s.gameserver.network.l2.c2s.pledge.RequestExPledgeSkillInfo;
import l2s.gameserver.network.l2.c2s.pledge.RequestExSetPledgeCrestLargeFirstPart;
import l2s.gameserver.network.l2.c2s.pledge.RequestJoinPledge;
import l2s.gameserver.network.l2.c2s.pledge.RequestJoinPledgeByName;
import l2s.gameserver.network.l2.c2s.pledge.RequestOustPledgeMember;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeCrest;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeCrestLarge;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeDraftListApply;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeDraftListSearch;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeExtendedInfo;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeInfo;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeJoinSys;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeMemberInfo;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeMemberList;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeMemberPowerInfo;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeMissionInfo;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeMissionReward;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgePower;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgePowerGradeList;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeRecruitApplyInfo;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeRecruitBoardAccess;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeRecruitBoardDetail;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeRecruitBoardSearch;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeRecruitInfo;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeReorganizeMember;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeSetAcademyMaster;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeSetMemberPowerGrade;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeSignInForOpenJoiningMethod;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeWaitingApplied;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeWaitingApply;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeWaitingList;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeWaitingUser;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeWaitingUserAccept;
import l2s.gameserver.network.l2.c2s.pledge.RequestPledgeWarList;
import l2s.gameserver.network.l2.c2s.pledge.RequestSetPledgeCrest;
import l2s.gameserver.network.l2.c2s.pledge.RequestStartPledgeWar;
import l2s.gameserver.network.l2.c2s.pledge.RequestStopPledgeWar;
import l2s.gameserver.network.l2.c2s.pledge.RequestWithdrawalPledge;
import l2s.gameserver.network.l2.c2s.randomcraft.*;
import l2s.gameserver.network.l2.c2s.ranking.RequestExOlympiadHeroAndLegendInfo;
import l2s.gameserver.network.l2.c2s.ranking.RequestExPvPRankingList;
import l2s.gameserver.network.l2.c2s.ranking.RequestExPvPRankingMyInfo;
import l2s.gameserver.network.l2.c2s.ranking.RequestExRankingCharHistory;
import l2s.gameserver.network.l2.c2s.ranking.RequestExRankingCharInfo;
import l2s.gameserver.network.l2.c2s.ranking.RequestExRankingCharRankers;
import l2s.gameserver.network.l2.c2s.teleport.RequestExRequestTeleport;
import l2s.gameserver.network.l2.c2s.teleport.RequestExTeleportFavoritesAddDel;
import l2s.gameserver.network.l2.c2s.teleport.RequestExTeleportFavoritesList;
import l2s.gameserver.network.l2.c2s.teleport.RequestExTeleportFavoritesUIToggle;
import l2s.gameserver.network.l2.c2s.teleport.RequestExTeleportUI;
import l2s.gameserver.network.l2.c2s.timerestrictfield.RequestExTimeRestrictFieldHostUserEnter;
import l2s.gameserver.network.l2.c2s.timerestrictfield.RequestExTimeRestrictFieldHostUserLeave;
import l2s.gameserver.network.l2.c2s.timerestrictfield.RequestExTimeRestrictFieldList;
import l2s.gameserver.network.l2.c2s.timerestrictfield.RequestExTimeRestrictFieldUserEnter;
import l2s.gameserver.network.l2.c2s.timerestrictfield.RequestExTimeRestrictFieldUserLeave;
import l2s.gameserver.network.l2.c2s.worldexchange.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.nio.BufferUnderflowException;
import java.nio.ByteBuffer;

public final class GamePacketHandler implements IPacketHandler<GameClient>, IClientFactory<GameClient>, IMMOExecutor<GameClient>
{
	private static final Logger _log = LoggerFactory.getLogger(GamePacketHandler.class);

	@Override
	public ReceivablePacket<GameClient> handlePacket(ByteBuffer buf, GameClient client)
	{
		int id = buf.get() & 0xFF;

		ReceivablePacket<GameClient> msg = null;

		try
		{
			switch(client.getState())
			{
				case CONNECTED:
					switch(id)
					{
						case 0x00:
							msg = new RequestStatus();
							break;
						case 0x0e:
							msg = new ProtocolVersion();
							break;
						case 0x1F:
							// UNK
							break;
						case 0x2b:
							msg = new AuthLogin();
							break;
						case 0xcb:
							msg = new ReplyGameGuardQuery();
							break;
						case 0xd0:
							int id3 = buf.getShort() & 0xffff;
							switch(id3)
							{
								case 0x103:
									msg = new ExSendClientINI();
									break;
								case 0x249:
									msg = new RequestExBrVersion();
									break;
								default:
									client.onUnknownPacket();
									_log.warn("Unknown client packet! State: CONNECTED, packet ID: " + Integer.toHexString(id).toUpperCase() + ":" + Integer.toHexString(id3).toUpperCase());
									break;
							}
							break;
						default:
							client.onUnknownPacket();
							_log.warn("Unknown client packet! State: CONNECTED, packet ID: " + Integer.toHexString(id).toUpperCase());
							break;
					}
					break;
				case AUTHED:
					switch(id)
					{
						case 0x00:
							msg = new Logout();
							break;
						case 0x0c:
							msg = new CharacterCreate(); //RequestCharacterCreate();
							break;
						case 0x0d:
							msg = new CharacterDelete(); //RequestCharacterDelete();
							break;
						case 0x12:
							msg = new CharacterSelected(); //CharacterSelect();
							break;
						case 0x13:
							msg = new NewCharacter(); //RequestNewCharacter();
							break;
						case 0x7b:
							msg = new CharacterRestore(); //RequestCharacterRestore();
							break;
						case 0xcb:
							msg = new ReplyGameGuardQuery();
							break;
						case 0xd0:
							int id3 = buf.getShort() & 0xffff;
							switch(id3)
							{
								case 0x01:
									msg = new RequestManorList();
									break;
								case 0x21:
									msg = new RequestKeyMapping();
									break;
								case 0x33:
									msg = new GotoLobby();
									break;
								case 0x3A:
									msg = new RequestAllFortressInfo();
									break;
								case 0xA6:
									msg = new RequestEx2ndPasswordCheck();
									break;
								case 0xA7:
									msg = new RequestEx2ndPasswordVerify();
									break;
								case 0xA8:
									msg = new RequestEx2ndPasswordReq();
									break;
								case 0xA9:
									msg = new RequestCharacterNameCreatable();
									break;
								case 0xD1:
									msg = new RequestBR_NewIConCashBtnWnd();
									break;
								case 0x103:
									// UNK
									break;
								case 0x104:
									msg = new ExSendClientINI();
									break;
								case 0x11D:
									msg = new RequestTodoList();
									break;
								case 0x138:
									msg = new RequestUserBanInfo();
									break;
								case 0x15E:
									//TODO
									break;
								case 0x15F:
									//TODO
									break;
								case 0x15D:
                                    //client.getActiveChar().sendActionFailed();
									// EX_USER_BAN_INFO
									break;
								case 0x249:
									// EX BR VERSION packet
									break;
								default:
									client.onUnknownPacket();
									_log.warn("Unknown client packet! State: AUTHED, packet ID: " + Integer.toHexString(id).toUpperCase() + ":" + Integer.toHexString(id3).toUpperCase());
									break;
							}
							break;
						default:
							client.onUnknownPacket();
							_log.warn("Unknown client packet! State: AUTHE, packet ID: " + Integer.toHexString(id).toUpperCase());
							break;
					}
					break;
				case IN_GAME:
					switch(id)
					{
						case 0x00:
							msg = new Logout();
							break;
						case 0x01:
							msg = new AttackRequest();
							break;
						case 0x02:
							//	msg = new RequestExMoveBackwardToLocation();
							break;
						case 0x03:
							msg = new RequestStartPledgeWar();
							break;
						case 0x04:
							// NOT_IN_USE
							break;
						case 0x05:
							msg = new RequestStopPledgeWar();
							break;
						case 0x06:
							// NOT_IN_USE
							break;
						case 0x07:
							// NOT_IN_USE
							break;
						case 0x08:
							// NOT_IN_USE
							break;
						case 0x09:
							msg = new RequestSetPledgeCrest();
							break;
						case 0x0a:
							// NOT_IN_USE
							break;
						case 0x0b:
							msg = new RequestGiveNickName();
							break;
						case 0x0c:
							//	wtf???
							break;
						case 0x0d:
							//	wtf???
							break;
						case 0x0f:
							msg = new MoveBackwardToLocation();
							break;
						case 0x10:
							// NOT_IN_USE
							break;
						case 0x11:
							msg = new EnterWorld();
							break;
						case 0x12:
							//	wtf???
							break;
						case 0x14:
							msg = new RequestItemList();
							break;
						case 0x15:
							// NOT_IN_USE
							break;
						case 0x16:
							msg = new RequestUnEquipItem();
							break;
						case 0x17:
							msg = new RequestDropItem();
							break;
						case 0x18:
							//	msg = new RequestGetItem();
							break;
						case 0x19:
							msg = new UseItem();
							break;
						case 0x1a:
							msg = new TradeRequest();
							break;
						case 0x1b:
							msg = new AddTradeItem();
							break;
						case 0x1c:
							msg = new TradeDone();
							break;
						case 0x1d:
							// NOT_IN_USE
							break;
						case 0x1e:
							// NOT_IN_USE
							break;
						case 0x1f:
							msg = new Action();
							break;
						case 0x20:
							// NOT_IN_USE
							break;
						case 0x21:
							// NOT_IN_USE
							break;
						case 0x22:
							msg = new RequestLinkHtml();
							break;
						case 0x23:
							msg = new RequestBypassToServer();
							break;
						case 0x24:
							msg = new RequestBBSwrite(); //RequestBBSWrite();
							break;
						case 0x25:
							// NOT_IN_USE
							break;
						case 0x26:
							msg = new RequestJoinPledge();
							break;
						case 0x27:
							msg = new RequestAnswerJoinPledge();
							break;
						case 0x28:
							msg = new RequestWithdrawalPledge();
							break;
						case 0x29:
							msg = new RequestOustPledgeMember();
							break;
						case 0x2a:
							// NOT_IN_USE
							break;
						case 0x2c:
							msg = new RequestGetItemFromPet();
							break;
						case 0x2d:
							// NOT_IN_USE
							break;
						case 0x2e:
							msg = new RequestAllyInfo();
							break;
						case 0x2f:
							msg = new RequestCrystallizeItem();
							break;
						case 0x30:
							// NOT_IN_USE
							break;
						case 0x31:
							msg = new SetPrivateStoreSellList();
							break;
						case 0x32:
							// RequestPrivateStoreManageCancel, устарел
							break;
						case 0x33:
							// NOT_IN_USE
							break;
						case 0x34:
							//msg = new RequestSocialAction();
							break;
						case 0x35:
							// ChangeMoveType, устарел
							break;
						case 0x36:
							// ChangeWaitTypePacket, устарел
							break;
						case 0x37:
							msg = new RequestSellItem();
							break;
						case 0x38:
							msg = new RequestMagicSkillList();
							break;
						case 0x39:
							msg = new RequestMagicSkillUse();
							break;
						case 0x3a:
							msg = new Appearing(); //Appering();
							break;
						case 0x3b:
							if(Config.ALLOW_WAREHOUSE)
								msg = new SendWareHouseDepositList();
							break;
						case 0x3c:
							msg = new SendWareHouseWithDrawList();
							break;
						case 0x3d:
							msg = new RequestShortCutReg();
							break;
						case 0x3e:
							// NOT_IN_USE
							break;
						case 0x3f:
							msg = new RequestShortCutDel();
							break;
						case 0x40:
							msg = new RequestBuyItem();
							break;
						case 0x41:
							// NOT_IN_USE
							break;
						case 0x42:
							msg = new RequestJoinParty();
							break;
						case 0x43:
							msg = new RequestAnswerJoinParty();
							break;
						case 0x44:
							msg = new RequestWithDrawalParty();
							break;
						case 0x45:
							msg = new RequestOustPartyMember();
							break;
						case 0x46:
							msg = new RequestDismissParty();
							break;
						case 0x47:
							msg = new CannotMoveAnymore();
							break;
						case 0x48:
							msg = new RequestTargetCanceld();
							break;
						case 0x49:
							msg = new Say2C();
							break;
						// -- maybe GM packet's
						case 0x4a:
							// NOT_IN_USE
							break;
						case 0x4b:
							// NOT_IN_USE
							break;
						case 0x4c:
							// NOT_IN_USE
							break;
						case 0x4d:
							msg = new RequestPledgeMemberList();
							break;
						case 0x4e:
							// NOT_IN_USE
							break;
						case 0x4f:
							// NOT_IN_USE
							break;
						case 0x50:
							msg = new RequestSkillList(); // trigger
							break;
						case 0x51:
							// NOT_IN_USE
							break;
						case 0x52:
							msg = new MoveWithDelta();
							break;
						case 0x53:
							msg = new RequestGetOnVehicle();
							break;
						case 0x54:
							msg = new RequestGetOffVehicle();
							break;
						case 0x55:
							msg = new AnswerTradeRequest();
							break;
						case 0x56:
							msg = new RequestActionUse();
							break;
						case 0x57:
							msg = new RequestRestart();
							break;
						case 0x58:
							// NOT_IN_USE
							break;
						case 0x59:
							msg = new ValidatePosition();
							break;
						case 0x5a:
							msg = new RequestSEKCustom();
							break;
						case 0x5b:
							msg = new StartRotatingC();
							break;
						case 0x5c:
							msg = new FinishRotatingC();
							break;
						case 0x5d:
							// NOT_IN_USE
							break;
						case 0x5e:
							msg = new RequestShowBoard();
							break;
						case 0x5f:
							msg = new RequestEnchantItem();
							break;
						case 0x60:
							msg = new RequestDestroyItem();
							break;
						case 0x61:
							// msg = new RequestTargetUserFromMenu();
							break;
						case 0x62:
							msg = new RequestQuestList();
							break;
						case 0x63:
							msg = new RequestQuestAbort(); //RequestDestroyQuest();
							break;
						case 0x64:
							// NOT_IN_USE
							break;
						case 0x65:
							msg = new RequestPledgeInfo();
							break;
						case 0x66:
							msg = new RequestPledgeExtendedInfo();
							break;
						case 0x67:
							msg = new RequestPledgeCrest();
							break;
						case 0x68:
							// NOT_IN_USE
							break;
						case 0x69:
							// NOT_IN_USE
							break;
						case 0x6a:
							msg = new RequestFriendInfoList();
							break;
						case 0x6b:
							msg = new RequestSendL2FriendSay();
							break;
						case 0x6c:
							msg = new RequestShowMiniMap(); //RequestOpenMinimap();
							break;
						case 0x6d:
							msg = new RequestSendMsnChatLog();
							break;
						case 0x6e:
							msg = new RequestReload(); // record video
							break;
						case 0x6f:
							msg = new RequestHennaEquip();
							break;
						case 0x70:
							msg = new RequestHennaUnequipList();
							break;
						case 0x71:
							msg = new RequestHennaUnequipInfo();
							break;
						case 0x72:
							msg = new RequestHennaUnequip();
							break;
						case 0x73:
							msg = new RequestAquireSkillInfo(); //RequestAcquireSkillInfo();
							break;
						case 0x74:
							msg = new SendBypassBuildCmd();
							break;
						case 0x75:
							msg = new RequestMoveToLocationInVehicle();
							break;
						case 0x76:
							msg = new CannotMoveAnymore.Vehicle();
							break;
						case 0x77:
							msg = new RequestFriendInvite();
							break;
						case 0x78:
							msg = new RequestFriendAddReply();
							break;
						case 0x79:
							//msg = new RequestFriendList();
							break;
						case 0x7a:
							msg = new RequestFriendDel();
							break;
						case 0x7c:
							msg = new RequestAquireSkill();
							break;
						case 0x7d:
							msg = new RequestRestartPoint();
							break;
						case 0x7e:
							msg = new RequestGMCommand();
							break;
						case 0x7f:
							msg = new RequestPartyMatchConfig();
							break;
						case 0x80:
							msg = new RequestPartyMatchList();
							break;
						case 0x81:
							msg = new RequestPartyMatchDetail();
							break;
						case 0x82:
							// NOT_IN_USE
							break;
						case 0x83:
							msg = new RequestPrivateStoreBuy();
							break;
						case 0x84:
							// NOT_IN_USE
							break;
						case 0x85:
							msg = new RequestTutorialLinkHtml();
							break;
						case 0x86:
							msg = new RequestTutorialPassCmdToServer();
							break;
						case 0x87:
							msg = new RequestTutorialQuestionMark(); //RequestTutorialQuestionMarkPressed();
							break;
						case 0x88:
							msg = new RequestTutorialClientEvent();
							break;
						case 0x89:
							msg = new RequestPetition();
							break;
						case 0x8a:
							msg = new RequestPetitionCancel();
							break;
						case 0x8b:
							msg = new RequestGmList();
							break;
						case 0x8c:
							msg = new RequestJoinAlly();
							break;
						case 0x8d:
							msg = new RequestAnswerJoinAlly();
							break;
						case 0x8e:
							// Команда /allyleave - выйти из альянса
							msg = new RequestWithdrawAlly();
							break;
						case 0x8f:
							// Команда /allydismiss - выгнать клан из альянса
							msg = new RequestOustAlly();
							break;
						case 0x90:
							// Команда /allydissolve - распустить альянс
							msg = new RequestDismissAlly();
							break;
						case 0x91:
							msg = new RequestSetAllyCrest();
							break;
						case 0x92:
							msg = new RequestAllyCrest();
							break;
						case 0x93:
							msg = new RequestChangePetName();
							break;
						case 0x94:
							msg = new RequestPetUseItem();
							break;
						case 0x95:
							msg = new RequestGiveItemToPet();
							break;
						case 0x96:
							msg = new RequestPrivateStoreQuitSell();
							break;
						case 0x97:
							msg = new SetPrivateStoreMsgSell();
							break;
						case 0x98:
							msg = new RequestPetGetItem();
							break;
						case 0x99:
							// NOT_IN_USE
							break;
						case 0x9a:
							msg = new SetPrivateStoreBuyList();
							break;
						case 0x9b:
							// msg = new RequestPrivateStoreBuyManageCancel();
							break;
						case 0x9c:
							msg = new RequestPrivateStoreQuitBuy();
							break;
						case 0x9d:
							msg = new SetPrivateStoreMsgBuy();
							break;
						case 0x9e:
							// NOT_IN_USE
							break;
						case 0x9f:
							msg = new RequestPrivateStoreBuySellList();
							break;
						case 0xa0:
							// NOT_IN_USE
							break;
						case 0xa1:
							// NOT_IN_USE
							break;
						case 0xa2:
							// NOT_IN_USE
							break;
						case 0xa3:
							// NOT_IN_USE
							break;
						case 0xa4:
							// NOT_IN_USE
							break;
						case 0xa5:
							// NOT_IN_USE
							break;
						case 0xa6:
							msg = new RequestSkillCoolTime();
							break;
						case 0xa7:
							msg = new RequestPackageSendableItemList();
							break;
						case 0xa8:
							msg = new RequestPackageSend();
							break;
						case 0xa9:
							msg = new RequestBlock();
							break;
						case 0xaa:
							//	msg = new RequestCastleSiegeInfo(); // format: cd ?
							break;
						case 0xab:
							msg = new RequestCastleSiegeAttackerList();
							break;
						case 0xac:
							msg = new RequestCastleSiegeDefenderList();
							break;
						case 0xad:
							msg = new RequestJoinCastleSiege();
							break;
						case 0xae:
							msg = new RequestConfirmCastleSiegeWaitingList();
							break;
						case 0xaf:
							msg = new RequestSetCastleSiegeTime();
							break;
						case 0xb0:
							msg = new RequestMultiSellChoose();
							break;
						case 0xb1:
							msg = new NetPing();
							break;
						case 0xb2:
							msg = new RequestRemainTime();
							break;
						case 0xb3:
							msg = new BypassUserCmd();
							break;
						case 0xb4:
							msg = new SnoopQuit();
							break;
						case 0xb5:
							msg = new RequestRecipeBookOpen();
							break;
						case 0xb6:
							msg = new RequestRecipeItemDelete();
							break;
						case 0xb7:
							msg = new RequestRecipeItemMakeInfo();
							break;
						case 0xb8:
							msg = new RequestRecipeItemMakeSelf();
							break;
						case 0xb9:
							// NOT_IN_USE
							break;
						case 0xba:
							msg = new RequestRecipeShopMessageSet();
							break;
						case 0xbb:
							msg = new RequestRecipeShopListSet();
							break;
						case 0xbc:
							msg = new RequestRecipeShopManageQuit();
							break;
						case 0xbd:
							msg = new RequestRecipeShopManageCancel();
							break;
						case 0xbe:
							msg = new RequestRecipeShopMakeInfo();
							break;
						case 0xbf:
							msg = new RequestRecipeShopMakeDo();
							break;
						case 0xc0:
							msg = new RequestRecipeShopSellList();
							break;
						case 0xc1:
							msg = new RequestObserverEnd();
							break;
						case 0xc2:
							//msg = new VoteSociality(); // Recommend
							break;
						case 0xc3:
							msg = new RequestHennaList(); //RequestHennaItemList();
							break;
						case 0xc4:
							msg = new RequestHennaItemInfo();
							break;
						case 0xc5:
							msg = new RequestBuySeed();
							break;
						case 0xc6:
							msg = new ConfirmDlg();
							break;
						case 0xc7:
							msg = new RequestPreviewItem();
							break;
						case 0xc8:
							msg = new RequestSSQStatus();
							break;
						case 0xc9:
							msg = new PetitionVote();
							break;
						case 0xca:
							// NOT_IN_USE
							break;
						case 0xcb:
							msg = new ReplyGameGuardQuery();
							break;
						case 0xcc:
							msg = new RequestPledgePower();
							break;
						case 0xcd:
							msg = new RequestMakeMacro();
							break;
						case 0xce:
							msg = new RequestDeleteMacro();
							break;
						case 0xcf:
							// NOT_IN_USE
							break;
						case 0xd0:
							int id3 = buf.getShort() & 0xffff;
							switch(id3)
							{
								case 0x00:
									// msg = RequestExDummy();
									break;
								case 0x01:
									msg = new RequestManorList();
									break;
								case 0x02:
									msg = new RequestProcureCropList();
									break;
								case 0x03:
									msg = new RequestSetSeed();
									break;
								case 0x04:
									msg = new RequestSetCrop();
									break;
								case 0x05:
									msg = new RequestWriteHeroWords();
									break;
								case 0x06:
									msg = new RequestExMPCCAskJoin(); // RequestExAskJoinMPCC();
									break;
								case 0x07:
									msg = new RequestExMPCCAcceptJoin(); // RequestExAcceptJoinMPCC();
									break;
								case 0x08:
									msg = new RequestExOustFromMPCC();
									break;
								case 0x09:
									msg = new RequestOustFromPartyRoom();
									break;
								case 0x0A:
									msg = new RequestDismissPartyRoom();
									break;
								case 0x0B:
									msg = new RequestWithdrawPartyRoom();
									break;
								case 0x0C:
									msg = new RequestHandOverPartyMaster();
									break;
								case 0x0D:
									msg = new RequestAutoSoulShot();
									break;
								case 0x0E:
									msg = new RequestExEnchantSkillInfo();
									break;
								case 0x0F:
									int type = buf.getInt();
									switch(type)
									{
										case 0x00:
											msg = new RequestExEnchantSkill();
											break;
										case 0x01:
											msg = new RequestExEnchantSkillSafe();
											break;
										case 0x02:
											msg = new RequestExEnchantSkillUntrain();
											break;
										case 0x03:
											msg = new RequestExEnchantSkillRouteChange();
											break;
										case 0x04:
											msg = new RequestExEnchantSkillImmortal();
											break;
										default:
											client.onUnknownPacket();
											_log.warn("Unknown client packet! State: IN_GAME, packet ID: " + Integer.toHexString(id).toUpperCase() + ":" + Integer.toHexString(id3).toUpperCase() + ":" + Integer.toHexString(type).toUpperCase());
											break;
									}
									break;
								case 0x10:
									msg = new RequestPledgeCrestLarge();
									break;
								case 0x11:
									msg = new RequestExSetPledgeCrestLargeFirstPart();
									break;
								case 0x12:
									msg = new RequestPledgeSetAcademyMaster();
									break;
								case 0x13:
									msg = new RequestPledgePowerGradeList();
									break;
								case 0x14:
									msg = new RequestPledgeMemberPowerInfo();
									break;
								case 0x15:
									msg = new RequestPledgeSetMemberPowerGrade();
									break;
								case 0x16:
									msg = new RequestPledgeMemberInfo();
									break;
								case 0x17:
									msg = new RequestPledgeWarList();
									break;
								case 0x18:
									//msg = new RequestExFishRanking();
									break;
								case 0x19:
									msg = new RequestPCCafeCouponUse();
									break;
								case 0x1A:
									//msg = new RequestOrcMove();
									break;
								case 0x1B:
									msg = new RequestDuelStart();
									break;
								case 0x1C:
									msg = new RequestDuelAnswerStart();
									break;
								case 0x1D:
									msg = new RequestTutorialClientEvent(); // RequestExSetTutorial(); Format: d / требует отладки, ИМХО, это совсем другой пакет (с) Drin
									break;
								case 0x1E:
									msg = new RequestExRqItemLink();
									break;
								case 0x1F:
									msg = new CannotMoveAnymore.AirShip(); // () (ddddd)
									break;
								case 0x20:
									msg = new RequestExMoveToLocationInAirShip();
									break;
								case 0x21:
									msg = new RequestKeyMapping();
									break;
								case 0x22:
									msg = new RequestSaveKeyMapping();
									break;
								case 0x23:
									msg = new RequestExRemoveItemAttribute();
									break;
								case 0x24:
									msg = new RequestSaveInventoryOrder();
									break;
								case 0x25:
									msg = new RequestExitPartyMatchingWaitingRoom();
									break;
								case 0x26:
									msg = new RequestConfirmTargetItem();
									break;
								case 0x27:
									msg = new RequestConfirmRefinerItem();
									break;
								case 0x28:
									msg = new RequestConfirmGemStone();
									break;
								case 0x29:
									msg = new RequestOlympiadObserverEnd();
									break;
								case 0x2A:
									msg = new RequestCursedWeaponList();
									break;
								case 0x2B:
									msg = new RequestCursedWeaponLocation();
									break;
								case 0x2C:
									msg = new RequestPledgeReorganizeMember();
									break;
								case 0x2D:
									msg = new RequestExMPCCShowPartyMembersInfo();
									break;
								case 0x2E:
									msg = new RequestExOlympiadObserverEnd(); // не уверен (в клиенте называется RequestOlympiadMatchList)
									break;
								case 0x2F:
									msg = new RequestAskJoinPartyRoom();
									break;
								case 0x30:
									msg = new AnswerJoinPartyRoom();
									break;
								case 0x31:
									msg = new RequestListPartyMatchingWaitingRoom();
									break;
								case 0x32:
									msg = new RequestEnchantItemAttribute();
									break;
								case 0x33:
									//msg = new RequestGotoLobby();
									break;
								case 0x35:
									msg = new RequestExMoveToLocationAirShip();
									break;
								case 0x36:
									msg = new RequestBidItemAuction();
									break;
								case 0x37:
									msg = new RequestInfoItemAuction();
									break;
								case 0x38:
									msg = new RequestExChangeName();
									break;
								case 0x39:
									msg = new RequestAllCastleInfo();
									break;
								case 0x3A:
									msg = new RequestAllFortressInfo();
									break;
								case 0x3B:
									msg = new RequestAllAgitInfo();
									break;
								case 0x3C:
									msg = new RequestFortressSiegeInfo();
									break;
								case 0x3D:
									//msg = new RequestGetBossRecord();
									break;
								case 0x3E:
									msg = new RequestRefine();
									break;
								case 0x3F:
									msg = new RequestConfirmCancelItem();
									break;
								case 0x40:
									msg = new RequestRefineCancel();
									break;
								case 0x41:
									msg = new RequestExMagicSkillUseGround();
									break;
								case 0x42:
									msg = new RequestDuelSurrender();
									break;
								case 0x43:
									msg = new RequestExEnchantSkillInfoDetail();
									break;
								case 0x44:
									// msg = new RequestExAntiFreeServer();
									break;
								case 0x45:
									msg = new RequestFortressMapInfo();
									break;
								case 0x46:
									msg = new RequestPVPMatchRecord();
									break;
								case 0x47:
									msg = new SetPrivateStoreWholeMsg();
									break;
								case 0x48:
									msg = new RequestDispel();
									break;
								case 0x49:
									msg = new RequestExTryToPutEnchantTargetItem();
									break;
								case 0x4A:
									msg = new RequestExTryToPutEnchantSupportItem();
									break;
								case 0x4B:
									msg = new RequestExCancelEnchantItem();
									break;
								case 0x4C:
									//msg = new RequestChangeNicknameColor();
									break;
								case 0x4D:
									msg = new RequestResetNickname();
									break;
								case 0x4E:
									int id4 = buf.getInt();
									switch (id4)
									{
										case 0x00:
											msg = new RequestBookMarkSlotInfo();
											break;
										case 0x01:
											msg = new RequestSaveBookMarkSlot();
											break;
										case 0x02:
											msg = new RequestModifyBookMarkSlot();
											break;
										case 0x03:
											msg = new RequestDeleteBookMarkSlot();
											break;
										case 0x04:
											msg = new RequestTeleportBookMark();
											break;
										case 0x05:
											msg = new RequestChangeBookMarkSlot();
											break;
										default:
											client.onUnknownPacket();
											_log.warn("Unknown client packet! State: IN_GAME, packet ID: " + Integer.toHexString(id).toUpperCase() + ":" + Integer.toHexString(id3).toUpperCase() + ":" + Integer.toHexString(id4).toUpperCase());
											break;
									}
									break;
								case 0x4F:
									msg = new RequestWithDrawPremiumItem();
									break;
								case 0x50:
									msg = new RequestExJump();
									break;
								case 0x51:
									msg = new RequestExStartShowCrataeCubeRank();
									break;
								case 0x52:
									msg = new RequestExStopShowCrataeCubeRank();
									break;
								case 0x53:
									msg = new NotifyStartMiniGame();
									break;
								case 0x54:
									msg = new RequestExJoinDominionWar();
									break;
								case 0x55:
									msg = new RequestExDominionInfo();
									break;
								case 0x56:
									msg = new RequestExCleftEnter();
									break;
								case 0x57:
									msg = new RequestExCubeGameChangeTeam();
									break;
								case 0x58:
									msg = new RequestExEndScenePlayer();
									break;
								case 0x59:
									msg = new RequestExCubeGameReadyAnswer(); // RequestExBlockGameVote
									break;
								case 0x5A:
									msg = new RequestExListMpccWaiting();
									break;
								case 0x5B:
									msg = new RequestExManageMpccRoom();
									break;
								case 0x5C:
									msg = new RequestExJoinMpccRoom();
									break;
								case 0x5D:
									msg = new RequestExOustFromMpccRoom();
									break;
								case 0x5E:
									msg = new RequestExDismissMpccRoom();
									break;
								case 0x5F:
									msg = new RequestExWithdrawMpccRoom();
									break;
								case 0x60:
									msg = new RequestExSeedPhase();
									break;
								case 0x61:
									msg = new RequestExMpccPartymasterList();
									break;
								case 0x62:
									msg = new RequestExPostItemList();
									break;
								case 0x63:
									msg = new RequestExSendPost();
									break;
								case 0x64:
									msg = new RequestExRequestReceivedPostList();
									break;
								case 0x65:
									msg = new RequestExDeleteReceivedPost();
									break;
								case 0x66:
									msg = new RequestExRequestReceivedPost();
									break;
								case 0x67:
									msg = new RequestExReceivePost();
									break;
								case 0x68:
									msg = new RequestExRejectPost();
									break;
								case 0x69:
									msg = new RequestExRequestSentPostList();
									break;
								case 0x6A:
									msg = new RequestExDeleteSentPost();
									break;
								case 0x6B:
									msg = new RequestExRequestSentPost();
									break;
								case 0x6C:
									msg = new RequestExCancelSentPost();
									break;
								case 0x6D:
									msg = new RequestExShowNewUserPetition();
									break;
								case 0x6E:
									msg = new RequestExShowStepTwo();
									break;
								case 0x6F:
									msg = new RequestExShowStepThree();
									break;
								case 0x70:
									// msg = new ExConnectToRaidServer(); (chddd)
									break;
								case 0x71:
									// msg = new ExReturnFromRaidServer(); (chd)
									break;
								case 0x72:
									msg = new RequestExRefundItem();
									break;
								case 0x73:
									msg = new RequestExBuySellUIClose();
									break;
								case 0x74:
									msg = new RequestExEventMatchObserverEnd();
									break;
								case 0x75:
									msg = new RequestPartyLootModification();
									break;
								case 0x76:
									msg = new AnswerPartyLootModification();
									break;
								case 0x77:
									msg = new AnswerCoupleAction();
									break;
								case 0x78:
									msg = new RequestExBR_EventRankerList();
									break;
								case 0x79:
									// msg = new RequestAskMemberShip();
									break;
								case 0x7A:
									msg = new RequestAddExpandQuestAlarm();
									break;
								case 0x7B:
									msg = new RequestVoteNew();
									break;
								case 0x7C:
									msg = new RequestGetOnShuttle();
									break;
								case 0x7D:
									msg = new RequestGetOffShuttle();
									break;
								case 0x7E:
									msg = new RequestMoveToLocationInShuttle();
									break;
								case 0x7F:
									msg = new CannotMoveAnymore.Shuttle(); // CannotMoveAnymoreInShuttle(); (chddddd)
									break;
								case 0x80:
									int id5 = buf.getInt();
									switch (id5)
									{
										case 0x01:
											//msg = new RequestExAgitInitialize chd 0x01
											break;
										case 0x02:
											//msg = new RequestExAgitDetailInfo chdcd 0x02
											break;
										case 0x03:
											//msg = new RequestExMyAgitState chd 0x03
											break;
										case 0x04:
											//msg = new RequestExRegisterAgitForBidStep1 chd 0x04
											break;
										case 0x05:
											//msg = new RequestExRegisterAgitForBidStep2 chddQd 0x05 //msg = new RequestExRegisterAgitForBidStep3 chddQd 0x05 -no error? 0x05
											break;
										case 0x07:
											//msg = new RequestExConfirmCancelRegisteringAgit chd 0x07
											break;
										case 0x08:
											//msg = new RequestExProceedCancelRegisteringAgit chd 0x08
											break;
										case 0x09:
											//msg = new RequestExConfirmCancelAgitBid chdd 0x09
											break;
										case 0x10:
											//msg = new RequestExReBid chdd 0x10
											break;
										case 0x11:
											//msg = new RequestExAgitListForLot chd 0x11
											break;
										case 0x12:
											//msg = new RequestExApplyForAgitLotStep1 chdc 0x12
											break;
										case 0x13:
											//msg = new RequestExApplyForAgitLotStep2 chdc 0x13
											break;
										case 0x14:
											//msg = new RequestExAgitListForBid chdd 0x14
											break;
										case 0x0D:
											//msg = new RequestExApplyForBidStep1 chdd 0x0D
											break;
										case 0x0E:
											//msg = new RequestExApplyForBidStep2 chddQ 0x0E
											break;
										case 0x0F:
											//msg = new RequestExApplyForBidStep3 chddQ 0x0F
											break;
										//case 0x09:
										//msg = new RequestExConfirmCancelAgitLot chdc 0x09
										//break;
										case 0x0A:
											//msg = new RequestExProceedCancelAgitLot chdc 0x0A
											break;
										default:
											client.onUnknownPacket();
											_log.warn("Unknown client packet! State: IN_GAME, packet ID: " + Integer.toHexString(id).toUpperCase() + ":" + Integer.toHexString(id3).toUpperCase() + ":" + Integer.toHexString(id5).toUpperCase());
											break;
										//case 0x0A:
										//msg = new RequestExProceedCancelAgitBid chdd 0x0A
										//break;
									}
									break;
								case 0x81:
									msg = new RequestExAddPostFriendForPostBox();
									break;
								case 0x82:
									msg = new RequestExDeletePostFriendForPostBox();
									break;
								case 0x83:
									msg = new RequestExShowPostFriendListForPostBox();
									break;
								case 0x84:
									msg = new RequestExFriendListForPostBox(); // TODO[K] - по сути является 84 у оверов, но в клиенте никак не используется!
									break;
								case 0x85:
									msg = new RequestOlympiadMatchList(); // TODO[K] - должен работать в буфере (на 00 позиции). Может заготовка корейцев на будущее О_О?
									break;
								case 0x86:
									msg = new RequestExBR_GamePoint();
									break;
								case 0x87:
									msg = new RequestExBR_ProductList();
									break;
								case 0x88:
									msg = new RequestExBR_ProductInfo();
									break;
								case 0x89:
									msg = new RequestExBR_BuyProduct();
									break;
								case 0x8A:
									msg = new RequestExBR_RecentProductList();
									break;
								case 0x8B:
									msg = new RequestBR_MiniGameLoadScores();
									break;
								case 0x8C:
									msg = new RequestBR_MiniGameInsertScore();
									break;
								case 0x8D:
									msg = new RequestExBR_LectureMark();
									break;
								case 0x8E:
									msg = new RequestCrystallizeEstimate();
									break;
								case 0x8F:
									msg = new RequestCrystallizeItemCancel();
									break;
								case 0x90:
									msg = new RequestExEscapeScene();
									break;
								case 0x91:
									msg = new RequestFlyMove();
									break;
								case 0x92:
									//msg = new RequestSurrenderPledgeWarEX(); (chS)
									break;
								case 0x93:
									int id6 = buf.get();
									switch (id6)
									{
										case 0x02:
											msg = new RequestDynamicQuestProgressInfo();
											break;
										case 0x03:
											msg = new RequestDynamicQuestScoreBoard();
											break;
										case 0x04:
											msg = new RequestDynamicQuestHTML();
											break;
										default:
											client.onUnknownPacket();
											_log.warn("Unknown client packet! State: IN_GAME, packet ID: " + Integer.toHexString(id).toUpperCase() + ":" + Integer.toHexString(id3).toUpperCase() + ":" + Integer.toHexString(id6).toUpperCase());
											break;
									}
									break;
								case 0x94:
									msg = new RequestFriendDetailInfo();
									break;
								case 0x95:
									msg = new RequestUpdateFriendMemo();
									break;
								case 0x96:
									msg = new RequestUpdateBlockMemo();
									break;
								case 0x97:
									//msg = new RequestInzonePartyInfoHistory(); (ch) TODO[K]
									break;
								case 0x98:
									msg = new RequestCommissionRegistrableItemList();
									break;
								case 0x99:
									msg = new RequestCommissionInfo();
									break;
								case 0x9A:
									msg = new RequestCommissionRegister();
									break;
								case 0x9B:
									msg = new RequestCommissionCancel();
									break;
								case 0x9C:
									msg = new RequestCommissionDelete();
									break;
								case 0x9D:
									msg = new RequestCommissionList();
									break;
								case 0x9E:
									msg = new RequestCommissionBuyInfo();
									break;
								case 0x9F:
									msg = new RequestCommissionBuyItem();
									break;
								case 0xA0:
									msg = new RequestCommissionRegisteredItem();
									break;
								case 0xA1:
									msg = new RequestCallToChangeClass();
									break;
								case 0xA2:
									msg = new RequestChangeToAwakenedClass();
									break;
								case 0xA3:
									// NOT_IN_USE
									break;
								case 0xA4:
									// NOT_IN_USE
									break;
								case 0xA5:
									msg = new RequestRegistPartySubstitute();
									break;
								case 0xA6:
									msg = new RequestDeletePartySubstitute();
									break;
								case 0xA7:
									msg = new RequestRegistWaitingSubstitute();
									break;
								case 0xA8:
									msg = new RequestAcceptWaitingSubstitute();
									break;
								case 0xA9:
									//msg = new RequestExCheckCharName();
									break;
								case 0xAA:
									msg = new RequestGoodsInventoryInfo();
									break;
								case 0xAB:
									int id7 = buf.getInt();
									switch(id7)
									{
										case 0x00:
											//msg = new RequestUseGoodsInventoryItem();
											break;
										case 0x01:
											//msg = new RequestUseGoodsInventoryItem();
											break;
										default:
											client.onUnknownPacket();
											_log.warn("Unknown client packet! State: IN_GAME, packet ID: " + Integer.toHexString(id).toUpperCase() + ":" + Integer.toHexString(id7).toUpperCase());
									}
									break;
								case 0xAC:
									msg = new RequestFirstPlayStart();
									break;
								case 0xAD:
									msg = new RequestFlyMoveStart();
									break;
								case 0xAE:
									msg = new RequestHardWareInfo();
									break;
								case 0xB0:
									msg = new SendChangeAttributeTargetItem();
									break;
								case 0xB1:
									msg = new RequestChangeAttributeItem();
									break;
								case 0xB2:
									msg = new RequestChangeAttributeCancel();
									break;
								case 0xB3:
									msg = new RequestBR_PresentBuyProduct();
									break;
								case 0xB4:
									msg = new ConfirmMenteeAdd();
									break;
								case 0xB5:
									msg = new RequestMentorCancel();
									break;
								case 0xB6:
									msg = new RequestMentorList();
									break;
								case 0xB7:
									msg = new RequestMenteeAdd();
									break;
								case 0xB8:
									msg = new RequestMenteeWaitingList();
									break;
								case 0xB9:
									msg = new RequestJoinPledgeByName();
									break;
								case 0xBA:
									msg = new RequestInzoneWaitingTime();
									break;
								case 0xBB:
									msg = new RequestJoinCuriousHouse();
									break;
								case 0xBC:
									msg = new RequestCancelCuriousHouse();
									break;
								case 0xBD:
									msg = new RequestLeaveCuriousHouse();
									break;
								case 0xBE:
									msg = new RequestObservingListCuriousHouse();
									break;
								case 0xBF:
									msg = new RequestObservingCuriousHouse();
									break;
								case 0xC0:
									msg = new RequestLeaveObservingCuriousHouse();
									break;
								case 0xC1:
									msg = new RequestCuriousHouseHtml();
									break;
								case 0xC2:
									msg = new RequestCuriousHouseRecord();
									break;
								case 0xC3:
									//msg = new ExSysstring();
									break;
								case 0xC4:
									msg = new RequestExTryToPutShapeShiftingTargetItem();
									break;
								case 0xC5:
									msg = new RequestExTryToPutShapeShiftingEnchantSupportItem();
									break;
								case 0xC6:
									msg = new RequestExCancelShapeShiftingItem();
									break;
								case 0xC7:
									msg = new RequestShapeShiftingItem();
									break;
								case 0xC8:
									//msg = new NCGuardSendDataToServer();
									break;
								case 0xC9:
									//msg = new RequestEventKalieToken();
									break;
								case 0xCA:
									msg = new RequestShowBeautyList();
									break;
								case 0xCB:
									msg = new RequestRegistBeauty();
									break;
								case 0xCC:
									//msg = new RequestExShowResetBeauty();
									break;
								case 0xCD:
									msg = new RequestShowResetShopList(); // (ch) TODO[K]
									break;
								case 0xCE:
									//msg = new NetPing();
									break;
								case 0xCF:
									//msg = new RequestBR_AddBasketProductInfo();
									break;
								case 0xD0:
									//msg = new RequestBR_DeleteBasketProductInfo();
									break;
								case 0xD1:
									msg = new RequestBR_NewIConCashBtnWnd();
									break;
								case 0xD2:
									//msg = new RequestExEvent_Campaign_Info();
									break;
								case 0xD3:
									msg = new RequestPledgeRecruitInfo();
									break;
								case 0xD4:
									msg = new RequestPledgeRecruitBoardSearch();
									break;
								case 0xD5:
									msg = new RequestPledgeRecruitBoardAccess();
									break;
								case 0xD6:
									msg = new RequestPledgeRecruitBoardDetail();
									break;
								case 0xD7:
									msg = new RequestPledgeWaitingApply();
									break;
								case 0xD8:
									msg = new RequestPledgeWaitingApplied();
									break;
								case 0xD9:
									msg = new RequestPledgeWaitingList();
									break;
								case 0xDA:
									msg = new RequestPledgeWaitingUser();
									break;
								case 0xDB:
									msg = new RequestPledgeWaitingUserAccept();
									break;
								case 0xDC:
									msg = new RequestPledgeDraftListSearch();
									break;
								case 0xDD:
									msg = new RequestPledgeDraftListApply();
									break;
								case 0xDE:
									msg = new RequestPledgeRecruitApplyInfo();
									break;
								case 0xDF:
									msg = new RequestPledgeJoinSys();
									break;
								case 0xE0:
									//msg = new ResponsePetitionAlarm();
									break;
								case 0xE1:
									msg = new NotifyExitBeautyshop();
									break;
								case 0xE2:
									//msg = new RequestRegisterXMasWishCard();
									break;
								case 0xE3:
									msg = new RequestExAddEnchantScrollItem();
									break;
								case 0xE4:
									msg = new RequestExRemoveEnchantSupportItem();
									break;
								case 0xE5:
									//msg = new RequestCardReward();
									break;
								case 0xE6:
									msg = new RequestDivideAdenaStart();
									break;
								case 0xE7:
									msg = new RequestDivideAdenaCancel();
									break;
								case 0xE8:
									msg = new RequestDivideAdena();
									break;
								case 0xE9:
									msg = new RequestAcquireAbilityList();
									break;
								case 0xEA:
									msg = new RequestAbilityList();
									break;
								case 0xEB:
									msg = new RequestResetAbilityPoint();
									break;
								case 0xEC:
									//msg = new RequestChangeAbilityPoint();
									break;
								case 0xED:
									msg = new RequestStopMove();
									break;
								case 0xEE:
									msg = new RequestAbilityWndOpen();
									break;
								case 0xEF:
									msg = new RequestAbilityWndClose();
									break;
								case 0xF0:
									msg = new RequestLuckyGameStartInfo();
									break;
								case 0xF1:
									msg = new RequestLuckyGamePlay();
									break;
								case 0xF2:
									msg = new NotifyTrainingRoomEnd();
									break;
								case 0xF3:
									msg = new RequestNewEnchantPushOne();
									break;
								case 0xF4:
									msg = new RequestNewEnchantRemoveOne();
									break;
								case 0xF5:
									msg = new RequestNewEnchantPushTwo();
									break;
								case 0xF6:
									msg = new RequestNewEnchantRemoveTwo();
									break;
								case 0xF7:
									msg = new RequestNewEnchantClose();
									break;
								case 0xF8:
									msg = new RequestNewEnchantTry();
									break;
								case 0xF9:
									msg = new RequestNewEnchantRetryToPutItems();
									break;
								case 0xFA:
									//msg = new RequestCardRewardList();
									break;
								case 0xFB:
									//msg = RequestAccountAttendanceInfo();
									break;
								case 0xFC:
									//msg = RequestAccountAttendanceReward();
									break;
								case 0xFD:
									msg = new RequestTargetActionMenu();
									break;
								case 0xFE:
									msg = new ExSendSelectedQuestZoneID();
									break;
								case 0xFF:
									msg = new RequestAlchemySkillList();
									break;
								case 0x100:
									msg = new RequestAlchemyTryMixCube();
									break;
								case 0x101:
									msg = new RequestAlchemyConversion();
									break;
								case 0x102:
									//msg = new ExExecutedUIEventsCount(); // C_EX_EXECUTED_UIEVENTS_COUNT
									break;
								case 0x103:
									msg = new ExSendClientINI();
									break;
								case 0x104:
									msg = new RequestExAutoFish();
									break;
								case 0x105:
									msg = new RequestVipAttendanceItemList();
									break;
								case 0x106:
									msg = new RequestVipAttendanceCheck();
									break;
								case 0x107:
									msg = new RequestItemEnsoul();
									break;
								case 0x108:
									//msg = new RequestCastleWarSeasonReward();
									break;
								case 0x109:
									//msg = new RequestVipProductList();
									break;
								case 0x10A:
									//msg = new RequestVipLuckyGameInfo();
									break;
								case 0x10B:
									//msg = new RequestVipLuckyGameItemList();
									break;
								case 0x10C:
									//msg = new RequestVipLuckyGameBonus();
									break;
								case 0x10D:
									//msg = new ExRequestVipInfo();
									break;
								case 0x10E:
									//msg = new RequestCaptchaAnswer();
									break;
								case 0x10F:
									//msg = new RequestRefreshCaptchaImage();
									break;
								case 0x110:
									msg = new RequestPledgeSignInForOpenJoiningMethod();
									break;
								case 0x111:
									//msg = new ExRequestMatchArena();
									break;
								case 0x112:
									//msg = new ExConfirmMatchArena();
									break;
								case 0x113:
									//msg = new ExCancelMatchArena();
									break;
								case 0x114:
									//msg = new ExChangeClassArena();
									break;
								case 0x115:
									//msg = new ExConfirmClassArena();
									break;
								case 0x116:
									//msg = new RequestOpenDecoNPCUI();
									break;
								case 0x117:
									//msg = new RequestCheckAgitDecoAvailability();
									break;
								case 0x118:
									msg = new RequestUserFactionInfo();
									break;
								case 0x119:
									//msg = new ExExitArena();
									break;
								case 0x11A:
									//msg = new RequestEventBalthusToken();
									break;
								case 0x11B:
									msg = new RequestPartyMatchingHistory();
									break;
								case 0x11C:
									//msg = new ExArenaCustomNotification();
									break;
								case 0x11D:
									msg = new RequestTodoList();
									break;
								case 0x11E:
									msg = new RequestTodoListHTML();
									break;
								case 0x11F:
									msg = new RequestOneDayRewardReceive();
									break;
								case 0x120:
									//msg = new RequestQueueTicket();
									break;
								case 0x121:
									//msg = new RequestPledgeBonusOpen();
									break;
								case 0x122:
									//msg = new RequestPledgeBonusRewardList();
									break;
								case 0x123:
									//msg = new RequestPledgeBonusReward();
									break;
								case 0x124:
									//msg = new RequestSSOAuthnToken();
									break;
								case 0x125:
									//msg = new RequestQueueTicketLogin();
									break;
								case 0x126:
									msg = new RequestBlockMemoInfo();
									break;
								case 0x127:
									msg = new RequestTryEnSoulExtraction();
									break;
								case 0x128:
									msg = new RequestRaidBossSpawnInfo();
									break;
								case 0x129:
									msg = new RequestRaidServerInfo();
									break;
								case 0x12A:
									msg = new RequestShowAgitSiegeInfo();
									break;
								case 0x12B:
									msg = new RequestItemAuctionStatus();
									break;
								case 0x12C:
									//msg = new RequestMonsterBookOpen();
									break;
								case 0x12D:
									//msg = new RequestMonsterBookClose();
									break;
								case 0x12E:
									//msg = new RequestMonsterBookReward();
									break;
								case 0x12F:
									//msg = new ExRequestMatchGroup();
									break;
								case 0x130:
									//msg = new ExRequestMatchGroupAsk();
									break;
								case 0x131:
									//msg = new ExRequestMatchGroupAnswer();
									break;
								case 0x132:
									//msg = new ExRequestMatchGroupWithdraw();
									break;
								case 0x133:
									//msg = new ExRequestMatchGroupOust();
									break;
								case 0x134:
									//msg = new ExRequestMatchGroupChangeMaster();
									break;
								case 0x135:
									msg = new RequestUpgradeSystemResult();
									break;
								case 0x136:
									//msg = new RequestCardUpdownGamePickNumber();
									break;
								case 0x137:
									//msg = new RequestCardUpdownGameReward();
									break;
								case 0x138:
									//msg = new RequestCardUpdownGameRetry();
									break;
								case 0x139:
									//msg = new RequestCardUpdownGameQuit();
									break;
								case 0x13A:
									//msg = new ExRequestArenaRankAll();
									break;
								case 0x13B:
									//msg = new ExRequestArenaMyRank();
									break;
								case 0x13C:
									msg = new RequestSwapAgathionSlotItems();
									break;
								case 0x13D:
									msg = new RequestExPledgeContributionRank();
									break;
								case 0x13E:
									msg = new RequestExPledgeContributionInfo();
									break;
								case 0x13F:
									msg = new RequestExPledgeContributionReward();
									break;
								case 0x140:
									msg = new RequestExPledgeLevelUp();
									break;
								case 0x141:
									msg = new RequestPledgeMissionInfo();
									break;
								case 0x142:
									msg = new RequestPledgeMissionReward();
									break;
								case 0x143:
									msg = new RequestExPledgeMasteryInfo();
									break;
								case 0x144:
									msg = new RequestExPledgeMasterySet();
									break;
								case 0x145:
									msg = new RequestExPledgeMasteryReset();
									break;
								case 0x146:
									msg = new RequestExPledgeSkillInfo();
									break;
								case 0x147:
									msg = new RequestExPledgeSkillActivate();
									break;
								case 0x148:
									msg = new RequestExPledgeItemList();
									break;
								case 0x149:
									//msg = new RequestExPledgeItemActivate();
									break;
								case 0x14A:
									msg = new RequestExPledgeAnnounce();
									break;
								case 0x14B:
									//msg = new RequestExPledgeAnnounceSet();
									break;
								case 0x14C:
									msg = new RequestExCreatePledge();
									break;
								case 0x14D:
									//msg = new RequestExPledgeItemInfo();
									break;
								case 0x14E:
									msg = new RequestExPledgeItemBuy();
									break;
								case 0x14F:
									//msg = new RequestExElementalSpiritInfo();
									break;
								case 0x150:
									//msg = new RequestExElementalSpiritExtractInfo();
									break;
								case 0x151:
									//msg = new RequestExElementalSpiritExtract();
									break;
								case 0x152:
									//msg = new RequestExElementalSpiritEvolutionInfo();
									break;
								case 0x153:
									//msg = new RequestExElementalSpiritEvolution();
									break;
								case 0x154:
									//msg = new RequestExElementalSpiritSetTalent();
									break;
								case 0x155:
									//msg = new RequestExElementalSpiritInitTalent();
									break;
								case 0x156:
									//msg = new RequestExElementalSpiritAbsorbInfo();
									break;
								case 0x157:
									//msg = new RequestExElementalSpiritAbsorb();
									break;
								case 0x158:
									//msg = new RequestExRequestLockedItem();
									break;
								case 0x159:
									//msg = new RequestExRequestUnlockedItem();
									break;
								case 0x15A:
									//msg = new RequestExLockedItemCancel();
									break;
								case 0x15B:
									//msg = new RequestExUnLockedItemCancel();
									break;
								case 0x15C:
									//C_EX_BLOCK_PACKET_FOR_AD
									break;
								case 0x15D:
                                    client.getActiveChar().sendActionFailed();
									//C_EX_USER_BAN_INFO
									break;
								case 0x15E:
									//C_EX_INTERACT_MODIFY
									break;
								case 0x15F:
									msg = new RequestExTryEnchantArtifact(); //C_EX_TRY_ENCHANT_ARTIFACT
									break;
								case 0x160:
									msg = new ExUpgradeSystemNormalRequest();
									break;
								case 0x161:
									msg = new RequestExPurchaseLimitShopItemList();//C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST
									break;
								case 0x162:
									msg = new RequestExPurchaseLimitShopItemBuy();//C_EX_PURCHASE_LIMIT_SHOP_ITEM_BUY
									break;
								case 0x163:
									msg = new RequestExPurchaseLimitShopHtmlOpen(); //C_EX_PURCHASE_LIMIT_SHOP_HTML_OPEN
									break;
								case 0x164:
									msg = new RequestExRequestClassChange();    //C_EX_REQUEST_CLASS_CHANGE
									break;
								case 0x165:
									msg = new RequestExRequestClassChangeVerifying();   //C_EX_REQUEST_CLASS_CHANGE_VERIFYING
									break;
								case 0x166:
									msg = new RequestExRequestTeleport();   //C_EX_REQUEST_TELEPORT
									break;
								case 0x167:
									msg = new RequestExCostumeUseItem();    //C_EX_COSTUME_USE_ITEM
									break;
								case 0x168:
									msg = new RequestExCostumeList();   //C_EX_COSTUME_LIST
									break;
								case 0x169:
									msg = new RequestExCostumeCollectionSkillActive();  //C_EX_COSTUME_COLLECTION_SKILL_ACTIVE
									break;
								case 0x16A:
									msg = new RequestExCostumeEvolution();  //C_EX_COSTUME_EVOLUTION
									break;
								case 0x16B:
									msg = new RequestExCostumeExtract();    //C_EX_COSTUME_EXTRACT/
									break;
								case 0x16C:
									msg = new RequestExCostumeLock();   //C_EX_COSTUME_LOCK
									break;
								case 0x16D:
									msg = new RequestExCostumeChangeShortcut(); //C_EX_COSTUME_CHANGE_SHORTCUT
									break;
								case 0x16E:
									msg = new RequestExMagicLampGameInfo(); // C_EX_MAGICLAMP_GAME_INFO
									break;
								case 0x16F:
									msg = new RequestExMagicLampGameStart(); // C_ EX_MAGICLAMP_GAME_START
									break;
								case 0x170:
									msg = new RequestExActivateAutoShortcut(); //C_EX_ACTIVATE_AUTO_SHORTCUT
									break;
								case 0x171:
									msg = new RequestExPremiumManagerLinkHtml(); //C_EX_PREMIUM_MANAGER_LINK_HTML
									break;
								case 0x172:
									msg = new RequestExPremiumManagerPassCmdToServer(); //C_EX_PREMIUM_MANAGER_PASS_CMD_TO_SERVER
									break;
								case 0x173:
									msg = new RequestTreasureBoxLocation();
									break;
								case 0x174:
									//C_EX_PAYBACK_LIST
									break;
								case 0x175:
									//C_EX_PAYBACK_GIVE_REWARD
									break;
								case 0x176:
									msg = new RequestExAutoplaySetting(); //C_EX_AUTOPLAY_SETTING
									break;
								case 0x177:
									//C_EX_OLYMPIAD_MATCH_MAKING
									break;
								case 0x178:
									//C_EX_OLYMPIAD_MATCH_MAKING_CANCEL
									break;
								case 0x179:
									msg = new RequestExFestivalBMInfo(); //C_EX_FESTIVAL_BM_INFO
									break;
								case 0x17A:
									msg = new RequestExFestivalBMGame(); //C_EX_FESTIVAL_BM_GAME
									break;
								case 0x17B:
									//C_EX_GACHA_SHOP_INFO
									break;
								case 0x17C:
									//C_EX_GACHA_SHOP_GACHA_GROUP
									break;
								case 0x17D:
									//C_EX_GACHA_SHOP_GACHA_ITEM
									break;
								case 0x17E:
									msg = new RequestExTimeRestrictFieldList(); // C_EX_TIME_RESTRICT_FIELD_LIST
									break;
								case 0x17F:
									msg = new RequestExTimeRestrictFieldUserEnter(); // C_EX_TIME_RESTRICT_FIELD_USER_ENTER
									break;
								case 0x180:
									msg = new RequestExTimeRestrictFieldUserLeave(); // C_EX_TIME_RESTRICT_FIELD_USER_LEAVE
									break;
								case 0x181:
									msg = new RequestExRankingCharInfo();
									break;
								case 0x182:
									msg = new RequestExRankingCharHistory();
									break;
								case 0x183:
									msg = new RequestExRankingCharRankers();
									break;
								case 0x184:
									//msg = new RequestExRankingCharSpawnBuffzoneNpc();
									break;
								case 0x185:
									//msg = new RequestExRankingCharBuffzoneNpcPosition();
									break;
								case 0x186:
									//msg = new RequestExPledgeMercenaryRecruitInfoSet();
									break;
								case 0x187:
									//msg = new RequestExMercenaryCastleWarCastleInfo();
									break;
								case 0x188:
									//msg = new RequestExMercenaryCastleWarCastleSiegeInfo();
									break;
								case 0x189:
									//msg = new RequestExMercenaryCastleWarCastleSiegeAttackerList();
									break;
								case 0x18A:
									//msg = new RequestExMercenaryCastleWarCastleSiegeDefenderList();
									break;
								case 0x18B:
									//msg = new RequestExPledgeMercenaryMemberList();
									break;
								case 0x18C:
									//msg = new RequestExPledgeMercenaryMemberJoin();
									break;
								case 0x18D:
									//msg = new RequestExPvpBookList();
									break;
								case 0x18E:
									//msg = new RequestExPvpBookKillerLocation();
									break;
								case 0x18F:
									//msg = new RequestExPvpbookTeleportToKiller();
									break;
								case 0x190:
									msg = new RequestExLetterCollectorTakeReward();
									break;
								case 0x191:
									msg = new RequestExSetStatusBonus();
									break;
								case 0x192:
									//msg = new RequestExResetStatusBonus();
									break;
								case 0x193:
									//C_EX_OLYMPIAD_MY_RANKING_INFO
									break;
								case 0x194:
									//C_EX_OLYMPIAD_RANKING_INFO
									break;
								case 0x195:
									msg = new RequestExOlympiadHeroAndLegendInfo(); //C_EX_OLYMPIAD_HERO_AND_LEGEND_INFO
									break;
								case 0x196:
									//C_EX_CASTLEWAR_OBSERVER_START
									break;
								case 0x197:
									msg = new RequestExRaidTeleportInfo();
									break;
								case 0x198:
									//msg = new RequestExTeleportToRaidPosition();
									break;
								case 0x199:
                                    msg = new RequestExCraftExtract(); //C_EX_CRAFT_EXTRACT
									break;
								case 0x19A:
                                    msg = new RequestExCraftRandomInfo(); //C_EX_CRAFT_RANDOM_INFO
									break;
								case 0x19B:
                                    msg = new RequestExCraftRandomLockSlot(); //C_EX_CRAFT_RANDOM_LOCK_SLOT
									break;
								case 0x19C:
                                    msg = new RequestExCraftRandomRefresh(); //C_EX_CRAFT_RANDOM_REFRESH
									break;
								case 0x19D:
                                    msg = new RequestExCraftRandomMake(); //C_EX_CRAFT_RANDOM_MAKE
									break;
								case 0x19E:
									//C_EX_MULTI_SELL_LIST
									break;
								case 0x19F:
									//C_EX_SAVE_ITEM_ANNOUNCE_SETTING
									break;
								case 0x1A0:
									msg = new RequestExOlympiadUI(); //C_EX_OLYMPIAD_UI
									break;
								case 0x1A1:
									//C_EX_SHARED_POSITION_SHARING_UI
									break;
								case 0x1A2:
									//C_EX_SHARED_POSITION_TELEPORT_UI
									break;
								case 0x1A3:
									//C_EX_SHARED_POSITION_TELEPORT
									break;
								case 0x1A4:
									// C_EX_AUTH_RECONNECT
									break;
								case 0x1A5:
									// C_EX_PET_EQUIP_ITEM
									break;
								case 0x1A6:
									// C_EX_PET_UNEQUIP_ITEM
									break;
								case 0x1A7:
									msg = new RequestExShowHomunculusInfo();// C_EX_SHOW_HOMUNCULUS_INFO
									break;
								case 0x1A8:
									msg = new RequestExHomunculusCreateStart();// C_EX_HOMUNCULUS_CREATE_START
									break;
								case 0x1A9:
									msg = new RequestExHomunculusInsert();// C_EX_HOMUNCULUS_INSERT
									break;
								case 0x1AA:
									msg = new RequestExHomunculusSummon();// C_EX_HOMUNCULUS_SUMMON
									break;
								case 0x1AB:
									msg = new RequestExDeleteHomunculusData();// C_EX_DELETE_HOMUNCULUS_DATA
									break;
								case 0x1AC:
									msg = new RequestExActivateHomunculus();// C_EX_REQUEST_ACTIVATE_HOMUNCULUS
									break;
								case 0x1AD:
									msg = new RequestExHomunculusGetEnchantPoint();// C_EX_HOMUNCULUS_GET_ENCHANT_POINT
									break;
								case 0x1AE:
									msg = new RequestExHomunculusInitPoint();
									break;
								case 0x1AF:
									//msg = new RequestExEvolvePet();
									break;
								case 0x1B0:
									msg = new RequestExEnchantHomunculusSkill();// C_EX_ENCHANT_HOMUNCULUS_SKILL
									break;
								case 0x1B1:
									msg = new RequestExHomunculusEnchantExp();// C_EX_HOMUNCULUS_ENCHANT_EXP
									break;
								case 0x1B2:
									msg = new RequestExTeleportFavoritesList();// C_EX_TELEPORT_FAVORITES_LIST
									break;
								case 0x1B3:
									msg = new RequestExTeleportFavoritesUIToggle();// C_EX_TELEPORT_FAVORITES_UI_TOGGLE
									break;
								case 0x1B4:
									msg = new RequestExTeleportFavoritesAddDel(); // C_EX_TELEPORT_FAVORITES_ADD_DEL
									break;
								case 0x1B5:
									// C_EX_ANTIBOT
									break;
								case 0x1B6:
									// C_EX_DPSVR
									break;
								case 0x1B7:
									// C_EX_TENPROTECT_DECRYPT_ERROR
									break;
								case 0x1B8:
									// C_EX_NET_LATENCY
									break;
								case 0x1B9:
									// C_EX_MABLE_GAME_OPEN
									break;
								case 0x1BA:
									// C_EX_MABLE_GAME_ROLL_DICE
									break;
								case 0x1BB:
									// C_EX_MABLE_GAME_POPUP_OK
									break;
								case 0x1BC:
									// C_EX_MABLE_GAME_RESET
									break;
								case 0x1BD:
									// C_EX_MABLE_GAME_CLOSE
									break;
								case 0x1BE:
									// C_EX_RETURN_TO_ORIGIN
									break;
								case 0x1BF:
									msg = new RequestExPkPenaltyList();
									break;
								case 0x1C0:
									msg = new RequestExPkPenaltyListOnlyLoc();
									break;
								case 0x1C1:
									// msg = new RequestExBlessOptionPutItem();
									break;
								case 0x1C2:
									// msg = new RequestExBlessOptionEnchant();
									break;
								case 0x1C3:
									// msg = new RequestExBlessOptionCancel();
									break;
								case 0x1C4:
									 msg = new RequestExPvPRankingMyInfo();
									break;
								case 0x1C5:
									 msg = new RequestExPvPRankingList();
									break;
								case 0x1C6:
									// msg = new RequestExAcquirePetSkill();
									break;
								case 0x1C7:
									// msg = new RequestExPledgeV3Info();
									break;
								case 0x1C8:
									// msg = new RequestExPledgeEnemyInfoList();
									break;
								case 0x1C9:
									// msg = new RequestExPledgeEnemyRegister();
									break;
								case 0x1CA:
									// msg = new RequestExPledgeEnemyDelete();
									break;
								case 0x1CB:
									//msg = new RequestExPetExtractSystem();
									break;
								case 0x1CC:
									//msg = new RequestExPledgeV3SetAnnonce();
									break;
								case 0x1CD:
									//msg = new RequestExRankingFestivalOpen();
									break;
								case 0x1CE:
									// msg = new RequestExRankingFestivalBuy();
									break;
								case 0x1CF:
									// msg = new RequestExRankingFestivalBonus();
									break;
								case 0x1D0:
									// msg = new RequestExRankingFestivalRanking();
									break;
								case 0x1D1:
									// msg = new RequestExRankingFestivalMyReceivedBonus();
									break;
								case 0x1D2:
									// msg = new RequestExRankingFestivalMyReceivedReward();
									break;
								case 0x1D3:
									// msg = new RequestExTimerCheck();
									break;
								case 0x1D4:
									// msg = new RequestExSteadyBoxLoad();
									break;
								case 0x1D5:
									// msg = new RequestExSteadyOpenSlot();
									break;
								case 0x1D6:
									// msg = new RequestExSteadyOpenBox();
									break;
								case 0x1D7:
									// msg = new RequestExSteadyGetReward();
									break;
								case 0x1D8:
									// msg = new RequestExPetRankingMyInfo();
									break;
								case 0x1D9:
									// msg = new RequestExRankingList();
									break;
								case 0x1DA:
									msg = new RequestExCollectionOpenUI();
									break;
								case 0x1DB:
									msg = new RequestExCollectionCloseUI();
									break;
								case 0x1DC:
									msg = new RequestExCollectionList();
									break;
								case 0x1DD:
									msg = new RequestExCollectionUpdateFavorite();
									break;
								case 0x1DE:
									 msg = new RequestExCollectionFavoriteList();
									break;
								case 0x1DF:
									msg = new RequestExCollectionSummary();
									break;
								case 0x1E0:
									 msg = new RequestExCollectionRegister();
									break;
								case 0x1E1:
									 msg = new RequestExCollectionReceiveReward();
									break;
								case 0x1E2:
									// msg = new RequestExPvpbookShareRevengeList();
									break;
								case 0x1E3:
									// msg = new RequestExPvpbookShareRevengeReqShareRevengeinfo();
									break;
								case 0x1E4:
									// msg = new RequestExPvpbookShareRevengeKillerLocation();
									break;
								case 0x1E5:
									// msg = new RequestExPvpbookShareRevengeTeleportToKiller();
									break;
								case 0x1E6:
									// msg = new RequestExPvpbookShareRevengeSharedTeleportToKiller();
									break;
								case 0x1E7:
									// msg = new RequestExPenaltyItemList();
									break;
								case 0x1E8:
									// msg = new RequestExPenaltyItemRestore();
									break;
								case 0x1E9:
									// msg = new RequestExUserWatcherTargetList();
									break;
								case 0x1EA:
									// msg = new RequestExUserWatcherAdd();
									break;
								case 0x1EB:
									// msg = new RequestExUserWatcherDelete();
									break;
								case 0x1EC:
									 msg = new RequestExHomunculusActiveSlot();
									break;
								case 0x1ED:
									 msg = new RequestExSummonHomunculusCoupon();
									break;
								case 0x1EE:
									// msg = new RequestExSubjugationList();
									break;
								case 0x1EF:
									// msg = new RequestExSubjugationRanking();
									break;
								case 0x1F0:
									// msg = new RequestExItemSubjugationGachaUi();
									break;
								case 0x1F1:
									// msg = new RequestExSubjugationGacha();
									break;
								case 0x1F2:
									// msg = new RequestExPledgeDonationInfo();
									break;
								case 0x1F3:
									// msg = new RequestExPledgeDonationRequest();
									break;
								case 0x1F4:
									// msg = new RequestExPledgeContriburionList();
									break;
								case 0x1F5:
									// msg = new RequestExPledgeRankingMyInfo();
									break;
								case 0x1F6:
									// msg = new RequestPledgeRankingList();
									break;
								case 0x1F7:
									// msg = new RequestExItemRestorList();
									break;
								case 0x1F8:
									// msg = new RequestExRestore();
									break;
								case 0x1F9:
									// msg = new RequestExDethroneInfo();
									break;
								case 0x1FA:
									// msg = new RequestExDethroneRankingInfo();
									break;
								case 0x1FB:
									// msg = new RequestExDethroneServerInfo();
									break;
								case 0x1FC:
									// msg = new RequestExDethroneDistrictOccupationInfo();
									break;
								case 0x1FD:
									// msg = new RequestExDethroneDailyMissionInfo();
									break;
								case 0x1FE:
									// msg = new RequestExDethroneDailyMissionGetReward();
									break;
								case 0x1FF:
									// msg = new RequestExDethronePrevSeasonInfo();
									break;
								case 0x200:
									// msg = new RequestExDethroneGetReward();
									break;
								case 0x201:
									// msg = new RequestExDethroneEnter();
									break;
								case 0x202:
									// msg = new RequestExDethroneLeave();
									break;
								case 0x203:
									// msg = new RequestExDethroneCheckName();
									break;
								case 0x204:
									// msg = new RequestExDethroneChangeName();
									break;
								case 0x205:
									// msg = new RequestExDethroneConnectCastle();
									break;
								case 0x206:
									// msg = new RequestExDethroneDisconnectCastle();
									break;
								case 0x207:
									msg = new RequestChangeNicknameColorIcon();
									break;
								case 0x208:
									// msg = new RequestExWorldcastlewarMoveToHost();
									break;
								case 0x209:
									// msg = new RequestExWorldcastlewarReturnToOriginPeer();
									break;
								case 0x20A:
									// msg = new RequestExWorldcastlewarCastleInfo();
									break;
								case 0x20B:
									// msg = new RequestExWorldcastlewarCastleSiegeInfo();
									break;
								case 0x20C:
									// msg = new RequestExWorldcastlewarCastleSiegeInfo();
									break;
								case 0x20D:
									// msg = new RequestExWorldcastlewarCastleSiegeAttackerList();
									break;
								case 0x20E:
									// msg = new RequestExWorldcastlewarCastleSiegePledgeMercenaryRecruitInfoSet();
									break;
								case 0x20F:
									// msg = new RequestExWorldcastlewarCastleSiegePledgeMercenaryMemberList();
									break;
								case 0x210:
									// msg = new RequestExWorldcastlewarCastleSiegePledgeMercenaryMemberJoin();
									break;
								case 0x211:
									// msg = new RequestExWorldcastlewarTeleport();
									break;
								case 0x212:
									// msg = new RequestExWorldcastlewarObserverStart();
									break;
								case 0x213:
									// msg = new RequestExPrivateStoreSearchList();
									break;
								case 0x214:
									// msg = new RequestExPrivateStoreSearchStatistics();
									break;
								case 0x215:
									// msg = new RequestExWorldcastlewarHostCastleSiegeRankingInfo();
									break;
								case 0x216:
									// msg = new RequestExWorldcastlewarCastleSiegeRankingInfo();
									break;
								case 0x217:
									// msg = new RequestExWorldcastlewarSiegeMainbattleHudInfo();
									break;
								case 0x218:
									msg = new RequestExNewHennaList();
									break;
								case 0x219:
									msg = new RequestExNewHennaEquip();
									break;
								case 0x21A:
									msg = new RequestExNewHennaUnequip();
									break;
								case 0x21B:
									msg = new RequestExNewHennaPotenSelect();
									break;
								case 0x21C:
									msg = new RequestExNewHennaPotenEnchant();
									break;
								case 0x21D:
									msg = new RequestExNewHennaCompose();
									break;
								case 0x21E:
									// msg = new RequestExRequestInviteParty();
									break;
								case 0x21F:
									msg = new RequestExItemUsableList();
									break;
								case 0x220:
									// C_EX_PACKETREADCOUNTPERSECOND
									break;
								case 0x221:
									// C_EX_SELECT_GLOBAL_EVENT_UI
									break;
								case 0x222:
									//C_EX_L2PASS_INFO
									break;
								case 0x223:
									//C_EX_L2PASS_REQUEST_REWARD
									break;
								case 0x224:
									//C_EX_L2PASS_REQUEST_REWARD_ALL
									break;
								case 0x225:
									//C_EX_L2PASS_BUY_PREMIUM	0x226
									break;
								case 0x226:
									//C_EX_SAYHAS_SUPPORT_TOGGLE
									break;
								case 0x227:
									msg = new RequestExEnchantFailRewardInfo();
									break;
								case 0x228:
									//C_EX_SET_ENCHANT_CHALLENGE_POINT
									break;
								case 0x229:
									//C_EX_RESET_ENCHANT_CHALLENGE_POINT
									break;
								case 0x22A:
									msg = new RequestExViewEnchantResult(); // C_EX_REQ_VIEW_ENCHANT_RESULT
									break;
								case 0x22B:
									msg = new RequestExStartMultiEnchantScroll(); // C_EX_REQ_START_MULTI_ENCHANT_SCROLL
									break;
								case 0x22C:
									msg = new RequestExViewMultiEnchantResult(); // C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT
									break;
								case 0x22D:
									msg = new RequestExFinishMultiEnchantScroll(); // C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL
									break;
								case 0x22E:
									// C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL
									break;
								case 0x22F:
									msg = new RequestExSetMultiEnchantItemList(); // C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST
									break;
								case 0x230:
									msg = new RequestExMultiEnchantItemList(); // C_EX_REQ_MULTI_ENCHANT_ITEM_LIST
									break;
								case 0x231:
									//C_EX_WORLDCASTLEWAR_SUPPORT_PLEDGE_FLAG_SET
									break;
								case 0x232:
									//C_EX_WORLDCASTLEWAR_SUPPORT_PLEDGE_INFO_SET
									break;
								case 0x233:
									msg = new RequestExHomunculusProbList();
									break;
								case 0x234:
									//C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_ALL_RANKING_INFO
									break;
								case 0x235:
									//C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ALL_RANKING_INFO
									break;
								case 0x236:
                                    client.getActiveChar().sendActionFailed();
									//C_EX_MISSION_LEVEL_REWARD_LIST
									break;
								case 0x237:
									//C_EX_MISSION_LEVEL_RECEIVE_REWARD
									break;
								case 0x238:
                                    msg = new RequestExBalrogWarTeleport(); // C_EX_BALROGWAR_TELEPORT
									break;
								case 0x239:
                                    msg = new RequestExBalrogWarShowUI(); // C_EX_BALROGWAR_SHOW_UI
									break;
								case 0x23A:
                                    msg = new RequestExBalrogWarShowRanking(); // C_EX_BALROGWAR_SHOW_RANKING
									break;
								case 0x23B:
                                    msg = new RequestExBalrogWarGetReward(); // C_EX_BALROGWAR_GET_REWARD
									break;
								case 0x23D:
									msg = new ExWorldExchangeItemList(); // C_EX_WORLD_EXCHANGE_ITEM_LIST
									break;
								case 0x23E:
									msg = new ExWorldExchangeRegisterItem(); // C_EX_WORLD_EXCHANGE_REGI_ITEM
									break;
								case 0x23F:
									msg = new ExWorldExchangeBuyItem();  // C_EX_WORLD_EXCHANGE_BUY_ITEM
									break;
								case 0x240:
									msg = new ExWorldExchangeSettleList(); // C_EX_WORLD_EXCHANGE_SETTLE_LIST
									break;
								case 0x241:
									msg = new ExWorldExchangeSettleRecvResult(); // C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT
									break;
								case 0x242:
									msg = new RequestExReadyItemAutoPeel(); // C_EX_READY_ITEM_AUTO_PEEL
									break;
								case 0x243:
									msg = new RequestExItemAutoPeel(); // C_EX_REQUEST_ITEM_AUTO_PEEL
									break;
								case 0x244:
									msg = new RequestExStopItemAutoPeel(); // C_EX_STOP_ITEM_AUTO_PEEL
									break;
								case 0x245:
									//C_EX_VARIATION_OPEN_UI
									break;
								case 0x246:
									msg = new RequestExVariationCloseUi();
									break;
								case 0x247:
									msg = new RequestExApplyVariationOption();
									break;
								case 0x248:
									//C_EX_REQUEST_AUDIO_LOG_SAVE
									break;
								case 0x249:
									//C_EX_BR_VERSION
									break;
								case 0x24A:
									//C_EX_WRANKING_FESTIVAL_INFO
									break;
								case 0x24B:
									//C_EX_WRANKING_FESTIVAL_OPEN
									break;
								case 0x24C:
									//C_EX_WRANKING_FESTIVAL_BUY
									break;
								case 0x24D:
									//C_EX_WRANKING_FESTIVAL_BONUS
									break;
								case 0x24E:
									//C_EX_WRANKING_FESTIVAL_RANKING
									break;
								case 0x24F:
									//C_EX_WRANKING_FESTIVAL_MY_RECEIVED_BONUS
									break;
								case 0x250:
									//C_EX_WRANKING_FESTIVAL_REWARD
									break;
								case 0x251:
									msg = new RequestHennaUnequipInfo();
									break;
								case 0x252:
									msg = new RequestHeroBookCharge();
									break;
								case 0x253:
									msg = new RequestHeroBookEnchant();
									break;
								case 0x254:
									msg = new RequestExTeleportUI();
									break;
								case 0x255:
									//C_EX_GOODS_GIFT_LIST_INFO
									break;
								case 0x256:
									//C_EX_GOODS_GIFT_ACCEPT
									break;
								case 0x257:
									//C_EX_GOODS_GIFT_REFUSE
									break;
								case 0x258:
									msg = new ExRequestWorldExchangeAveragePrice(); //C_EX_WORLD_EXCHANGE_AVERAGE_PRICE
									break;
								case 0x259:
									msg = new ExRequestWorldExchangeTotalList(); //C_EX_WORLD_EXCHANGE_TOTAL_LIST
									break;
								case 0x25A:
									//C_EX_PRISON_USER_INFO
									break;
								case 0x25B:
									//C_EX_PRISON_USER_DONATION
									break;
								case 0x25C:
									// C_EX_TRADE_LIMIT_INFO
									break;
								case 0x25D:
									// C_EX_UNIQUE_GACHA_OPEN
									break;
								case 0x25E:
									// C_EX_UNIQUE_GACHA_GAME
									break;
								case 0x25F:
									// C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST
									break;
								case 0x260:
									// C_EX_UNIQUE_GACHA_INVEN_GET_ITEM
									break;
								case 0x261:
									// C_EX_UNIQUE_GACHA_HISTORY
									break;
								case 0x262:
									// C_EX_SET_PLEDGE_CREST_PRESET
									break;
								case 0x263:
									// C_EX_GET_PLEDGE_CREST_PRESET
									break;
								case 0x264:
									// C_EX_DUAL_INVENTORY_SWAP
									break;
								case 0x265:
									// C_EX_SP_EXTRACT_INFO
									break;
								case 0x266:
									// C_EX_SP_EXTRACT_ITEM
									break;
								case 0x267:
									// C_EX_QUEST_TELEPORT
									break;
								case 0x268:
									// C_EX_QUEST_ACCEPT
									break;
								case 0x269:
									// C_EX_QUEST_CANCEL
									break;
								case 0x26A:
									// C_EX_QUEST_COMPLETE
									break;
								case 0x26B:
									// C_EX_QUEST_NOTIFICATION_ALL
									break;
								case 0x26C:
									// C_EX_QUEST_UI
									break;
								case 0x26D:
									// C_EX_QUEST_ACCEPTABLE_LIST
									break;
								case 0x26E:
									// C_EX_SKILL_ENCHANT_INFO
									break;
								case 0x26F:
									// C_EX_SKILL_ENCHANT_CHARGE
									break;
								case 0x270:
									 msg = new RequestExTimeRestrictFieldHostUserEnter();
									break;
								case 0x271:
									 msg = new RequestExTimeRestrictFieldHostUserLeave();
									break;
								case 0x272:
									// C_EX_DETHRONE_SHOP_OPEN_UI
									break;
								case 0x273:
									// C_EX_DETHRONE_SHOP_BUY
									break;
								case 0x274:
									// C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI
									break;
								case 0x275:
									// C_EX_ENHANCED_ABILITY_OF_FIRE_INIT
									break;
								case 0x276:
									// C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP
									break;
								case 0x277:
									// C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP
									break;
								case 0x278:
									// C_EX_HOLY_FIRE_OPEN_UI
									break;
								case 0x279:
									// C_EX_PRIVATE_STORE_BUY_SELL
									break;
								case 0x27A:
									// C_EX_MAX
									break;
								default:
									client.onUnknownPacket();
									//_log.warn("Unknown client packet! State: IN_GAME, packet ID: " + Integer.toHexString(id).toUpperCase() + ":" + Integer.toHexString(id3).toUpperCase());
									break;
							}
							if (Config.ENABLE_PACKET_LOG) {
								if (msg != null) {
									System.out.println(String.format("<= [IN][EX][%s][0xD0:0x%s][%d]", String.valueOf(msg.getClass().getSimpleName()), Integer.toHexString(id3).toUpperCase(), id3));
								} else {
									System.out.println(String.format("<= [IN][EX][UNK][0xD0:0x%s][%d]", Integer.toHexString(id3).toUpperCase(), id3));
								}
							}
							break;
						default:
						{
							client.onUnknownPacket();
							break;
						}
					}
					if (Config.ENABLE_PACKET_LOG) {
						if (id != 0xD0) {
							if (msg != null) {
								System.out.println(String.format("<= [IN][%s][0x%s][%d]", String.valueOf(msg.getClass().getSimpleName()), Integer.toHexString(id).toUpperCase(), id));
							} else {
								System.out.println(String.format("<= [IN][UNK][0x%s][%d]", Integer.toHexString(id).toUpperCase(), id));
							}
						}
					}
					break;
			}
		}
		catch(BufferUnderflowException e)
		{
			client.onPacketReadFail();
		}
		return msg;
	}

	@Override
	public GameClient create(MMOConnection<GameClient> con)
	{
		return new GameClient(con);
	}

	@Override
	public void execute(Runnable r)
	{
		ThreadPoolManager.getInstance().execute(r);
	}
}