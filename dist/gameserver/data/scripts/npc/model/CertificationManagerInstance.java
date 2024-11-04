package npc.model;

import java.util.Collection;
import java.util.StringTokenizer;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.data.xml.holder.SkillAcquireHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.SkillLearn;
import l2s.gameserver.model.actor.instances.player.DualClass;
import l2s.gameserver.model.base.AcquireType;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;

/**
 * @author Bonux
 */
public final class CertificationManagerInstance extends NpcInstance
{
	private static final int DUALCERTIFICATION_ITEM = 36078; // Сертификат - Новые Навыки
	private static final int IMPROVED_DUALCERTIFICATION_ITEM = 81731;
	private static final long DUALCERTIFICATIN_CANCEL_PRICE = 20000000L;

	public CertificationManagerInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public String getHtmlDir(String filename, Player player)
	{
		return "dualclass_certification/";
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		StringTokenizer st = new StringTokenizer(command, "_");
		String cmd = st.nextToken();
		if(cmd.equalsIgnoreCase("dualcertification")) // TODO: [Bonux] Сверить с оффом Хтмлки.
		{
			// Действия с сертификациями.
			String cmd2 = st.nextToken();
			if(cmd2.equalsIgnoreCase("get"))
			{
				if(!player.isDualClassActive())
				{
					showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_dual.htm", false);
					return;
				}

				if(player.getLevel() < 85)
				{
					showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_level.htm", false);
					return;
				}

				DualClass dualClass = player.getActiveDualClass();

				if(!st.hasMoreTokens())
				{
					if(dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_85) && dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_90) && dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_95) && dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_99) && dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_101) && dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_103) && dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_105))
					{
						showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_all_ceritficate_gived.htm", false);
						return;
					}
					showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_certification_list.htm", false);
					return;
				}
				else
				{
					int certificationLvl = Integer.parseInt(st.nextToken());

					if(player.getLevel() < certificationLvl)
					{
						showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_level_" + certificationLvl + ".htm", false);
						return;
					}

					switch(certificationLvl)
					{
						case 85:
							if(dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_85))
							{
								showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_already_received.htm", false);
								return;
							}
							break;
						case 90:
							if(dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_90))
							{
								showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_already_received.htm", false);
								return;
							}
							break;
						case 95:
							if(dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_95))
							{
								showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_already_received.htm", false);
								return;
							}
							break;
						case 99:
							if(dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_99))
							{
								showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_already_received.htm", false);
								return;
							}
							break;
						case 101:
							if(dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_101))
							{
								showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_already_received.htm", false);
								return;
							}
							break;
						case 103:
							if(dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_103))
							{
								showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_already_received.htm", false);
								return;
							}
							break;
						case 105:
							if(dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_105))
							{
								showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_already_received.htm", false);
								return;
							}
							break;
						default:
							return;
					}

					if(!st.hasMoreTokens())
					{
						showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_get_certification_" + certificationLvl + ".htm", false);
						return;
					}
					else
					{
						String cmd3 = st.nextToken();
						if(cmd3.equalsIgnoreCase("give"))
						{
							switch(certificationLvl)
							{
								case 85:
									dualClass.addDualCertification(DualClass.DUALCERTIFICATION_85);
									break;
								case 90:
									dualClass.addDualCertification(DualClass.DUALCERTIFICATION_90);
									break;
								case 95:
									dualClass.addDualCertification(DualClass.DUALCERTIFICATION_95);
									break;
								case 99:
									dualClass.addDualCertification(DualClass.DUALCERTIFICATION_99);
									break;
								case 101:
									dualClass.addDualCertification(DualClass.DUALCERTIFICATION_101);
									break;
								case 103:
									dualClass.addDualCertification(DualClass.DUALCERTIFICATION_103);
									break;
								case 105:
									dualClass.addDualCertification(DualClass.DUALCERTIFICATION_105);
									break;
								default:
									return;
							}

							ItemFunctions.addItem(player, DUALCERTIFICATION_ITEM, 1, true);
							player.store(true);
							showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_give_certification.htm", false);
							return;
						}
					}
				}
			}
			else if(cmd2.equalsIgnoreCase("getimproved"))
			{
				if(!player.isDualClassActive())
				{
					showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_dual.htm", false);
					return;
				}

				if(player.getLevel() < 85)
				{
					showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_level.htm", false);
					return;
				}

				DualClass dualClass = player.getActiveDualClass();

				if(!st.hasMoreTokens())
				{
					if(dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_107) && dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_109) && dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_110))
					{
						showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_all_ceritficate_gived.htm", false);
						return;
					}
					showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_certification_list_improved.htm", false);
					return;
				}
				else
				{
					int certificationLvl = Integer.parseInt(st.nextToken());

					if(player.getLevel() < certificationLvl)
					{
						showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_level_" + certificationLvl + ".htm", false);
						return;
					}

					switch(certificationLvl)
					{
						case 107:
							if(dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_107))
							{
								showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_already_received.htm", false);
								return;
							}
							break;
						case 109:
							if(dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_109))
							{
								showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_already_received.htm", false);
								return;
							}
							break;
						case 110:
							if(dualClass.isDualCertificationGet(DualClass.DUALCERTIFICATION_110))
							{
								showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_already_received.htm", false);
								return;
							}
							break;
						default:
							return;
					}

					if(!st.hasMoreTokens())
					{
						showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_get_certification_" + certificationLvl + ".htm", false);
						return;
					}
					else
					{
						String cmd3 = st.nextToken();
						if(cmd3.equalsIgnoreCase("give"))
						{
							switch(certificationLvl)
							{
								case 107:
									dualClass.addDualCertification(DualClass.DUALCERTIFICATION_107);
									break;
								case 109:
									dualClass.addDualCertification(DualClass.DUALCERTIFICATION_109);
									break;
								case 110:
									dualClass.addDualCertification(DualClass.DUALCERTIFICATION_110);
									break;
								default:
									return;
							}

							ItemFunctions.addItem(player, IMPROVED_DUALCERTIFICATION_ITEM, 1, true);
							player.store(true);
							showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_give_certification.htm", false);
							return;
						}
					}
				}
			}
			else if(cmd2.equalsIgnoreCase("skills"))
			{
				if(!st.hasMoreTokens())
					return;

				String cmd3 = st.nextToken();
				if(cmd3.equalsIgnoreCase("learn"))
				{
					showAcquireList(AcquireType.DUAL_CERTIFICATION, player);
					return;
				}
				else if(cmd3.equalsIgnoreCase("cancel"))
				{
					if(player.getAdena() < DUALCERTIFICATIN_CANCEL_PRICE) // ok
					{
						showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_adena_cancel.htm", false);
						return;
					}

					if(!player.isBaseClassActive())
					{
						showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_base.htm", false);
						return;
					}

					boolean hasCertification = false;
					for(DualClass dualClass : player.getDualClassList().values())
					{
						if(dualClass.isBase())
							continue;

						if(dualClass.getDualCertification() == 0)
							continue;

						dualClass.setDualCertification(0);
						hasCertification = true;
					}

					if(!hasCertification)
					{
						showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_no_cancel.htm", false);
						return;
					}

					player.store(true);

					Collection<SkillLearn> skillLearnList = SkillAcquireHolder.getInstance().getAvailableSkills(null, AcquireType.DUAL_CERTIFICATION);
					for(SkillLearn learn : skillLearnList)
					{
						SkillEntry skillEntry = player.getKnownSkill(learn.getId());
						if(skillEntry == null)
							continue;

						player.removeSkill(skillEntry, true);
					}

					player.reduceAdena(DUALCERTIFICATIN_CANCEL_PRICE, true);
					ItemFunctions.deleteItem(player, DUALCERTIFICATION_ITEM, ItemFunctions.getItemCount(player, DUALCERTIFICATION_ITEM), true);
					showChatWindow(player, "dualclass_certification/" + getNpcId() + "-d_certification_cancel.htm", false);
					return;
				}
			}
		}
		else
			super.onBypassFeedback(player, command);
	}
}