package npc.model;

import java.util.*;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.htm.HtmTemplates;
import l2s.gameserver.data.xml.holder.SkillAcquireHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.SkillLearn;
import l2s.gameserver.model.base.AcquireType;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.model.base.Experience;
import l2s.gameserver.model.base.DualClassType;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExSubjobInfo;
import l2s.gameserver.network.l2.s2c.SocialActionPacket;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.tables.DualClassTable;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.HtmlUtils;
import l2s.gameserver.utils.ItemFunctions;

import org.apache.commons.lang3.ArrayUtils;

/**
 * @author Bonux
 */
public final class DualClassManagerInstance extends NpcInstance
{
	private static final int CHAOS_POMANDER = 37375;
	private static final int PAULINA_EQUIPMENT_SET_PACK = 80956;
	
	
	public DualClassManagerInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(final Player player, final String command)
	{
		final StringTokenizer st = new StringTokenizer(command, "_");
		final String cmd = st.nextToken();
		if(cmd.equalsIgnoreCase("reawake"))
		{
			if(!player.isDualClassActive() || !player.getClassId().isOfLevel(ClassLevel.AWAKED))
			{
				showChatWindow(player, "default/" + getNpcId() + "-reawake_no.htm", false);
				return;
			}

			if(!player.isQuestContinuationPossible(false))
			{
				showChatWindow(player, "default/" + getNpcId() + "-reawake_no_weight.htm", false);
				return;
			}

			final int cost = calcReawakeCost(player);
			if(player.getAdena() < cost)
			{
				showChatWindow(player, "default/" + getNpcId() + "-reawake_no_adena.htm", false, "<?reawake_price?>", String.valueOf(cost));
				return;
			}

			/*final int cloakId = getCloakId(player.getClassId());
			if(cloakId == 0 || ItemFunctions.getItemCount(player, cloakId) == 0)
			{
				// [Bonux] На оффе нету отдельного диалога при отсутствии плаща. На оффе выводится диалог отсутствия адены.
				showChatWindow(player, "default/" + getNpcId() + "-reawake_no_adena.htm", false, "<?reawake_price?>", String.valueOf(cost));
				return;
			}*/

			if(player.isTransformed())
			{
				showChatWindow(player, "default/" + getNpcId() + "-reawake_no_transform.htm", false);
				return;
			}

			if(player.hasServitor())
			{
				showChatWindow(player, "default/" + getNpcId() + "-reawake_no_servitor.htm", false);
				return;
			}

			if(!st.hasMoreTokens())
			{
				showChatWindow(player, "default/" + getNpcId() + "-reawake_continue.htm", false, "<?reawake_price?>", String.valueOf(cost));
				return;
			}

			final String cmd2 = st.nextToken();
			if(cmd2.equalsIgnoreCase("continue"))
			{
				if(!st.hasMoreTokens())
				{
					final HtmTemplates tpls = HtmCache.getInstance().getTemplates("default/" + getNpcId() + "-reawake_list.htm", player);
					final String html = tpls.get(0);
					String bypass = tpls.get(1);

					final StringBuilder classes = new StringBuilder();
					final int changeClassId = player.getClassId().getId();
					for(ClassId clsId : ClassId.VALUES)
					{
						if(!clsId.isOutdated())
							continue;

						if(!clsId.isOfLevel(ClassLevel.AWAKED))
							continue;

						classes.append(bypass.replace("<?change_class_id?>", String.valueOf(changeClassId)).replace("<?class_id?>", String.valueOf(clsId.getId())).replace("<?class_name?>", getClassIdNames(player, clsId.getId())));
					}

					showChatWindow(player, html, false, "<?CLASS_LIST?>", classes.toString());
					return;
				}
				else
				{
					final int playerClassId = player.getClassId().getId();
					final int changeClassId = Integer.parseInt(st.nextToken());
					final int newClassId = Integer.parseInt(st.nextToken());

					if(changeClassId != playerClassId) // На всякий пожарный..
						return;

					if(!st.hasMoreTokens())
					{
						final int[] availClasses = DualClassTable.getInstance().getAvailableDualClasses(player, changeClassId, ClassLevel.AWAKED);
						final ClassId newClsId = ClassId.VALUES[newClassId];

						final HtmTemplates tpls = HtmCache.getInstance().getTemplates("default/" + getNpcId() + "-reawake_last_list.htm", player);
						final String html = tpls.get(0);
						String bypass = tpls.get(1);

						boolean avail = false;

						final StringBuilder classes = new StringBuilder();
						for(ClassId c : ClassId.VALUES)
						{
							if(c.getBaseAwakedClassId() != newClsId)
								continue;

							if(!ArrayUtils.contains(availClasses, c.getId()))
								continue;

							classes.append(bypass.replace("<?change_class_id?>", String.valueOf(changeClassId)).replace("<?class_id?>", String.valueOf(c.getId())).replace("<?class_name?>", c.getName(player)));
							avail = true;
						}

						if(!avail)
						{
							showChatWindow(player, "default/" + getNpcId() + "-reawake_no_avail.htm", false);
							return;
						}

						showChatWindow(player, html, false, "<?CLASS_LIST?>", classes.toString());
						return;
					}
					else
					{
						final String cmd3 = st.nextToken();
						if(cmd3.equalsIgnoreCase("finish"))
						{
							if(changeClassId == newClassId || playerClassId == newClassId) // На всякий пожарный..
								return;

							if(player.modifyDualClass(changeClassId, newClassId, true))
							{
								// Сбрасываем до 1 уровня.
								final long newExp = Experience.getExpForLevel(1) - player.getExp();
								player.addExpAndSp(newExp, 1000000, true);

								player.reduceAdena(cost, true);

								long count = player.getInventory().getCountOf(CHAOS_POMANDER);
								
								//ItemFunctions.deleteItem(player, cloakId, 1, true);
								ItemFunctions.deleteItem(player, CHAOS_POMANDER, count);
								
								//ItemFunctions.addItem(player, getPowerItemId(ClassId.VALUES[newClassId]), 1, true);
								ItemFunctions.addItem(player, CHAOS_POMANDER, 2);
								ItemFunctions.addItem(player, PAULINA_EQUIPMENT_SET_PACK, 1);
								
								// removal of dual skills
								Collection<SkillLearn> skillLearnList = SkillAcquireHolder.getInstance().getAvailableSkills(null, AcquireType.DUAL_CERTIFICATION);
								for(SkillLearn learn : skillLearnList)
								{
									SkillEntry skillEntry = player.getKnownSkill(learn.getId());
									if(skillEntry == null)
										continue;

									player.removeSkill(skillEntry, true);
								}
								player.getDualClass().setDualCertification(0);

								player.sendPacket(new ExSubjobInfo(player, true));
								player.sendPacket(new SystemMessagePacket(SystemMsg.THE_NEW_SUBCLASS_S1_HAS_BEEN_ADDED).addClassName(newClassId));
								player.broadcastPacket(new SocialActionPacket(player.getObjectId(), SocialActionPacket.REAWAKENING));

								showChatWindow(player, "default/" + getNpcId() + "-reawake_success.htm", false);
								return;
							}
							else
							{
								showChatWindow(player, "default/" + getNpcId() + "-reawake_error.htm", false);
								return;
							}
						}
					}
				}
			}
		}
		else if(cmd.equalsIgnoreCase("dualclass"))
		{
			if(player.getLevel() < 85)
			{
				showChatWindow(player, "default/" + getNpcId() + "-dualclass_no_level.htm", false);
				return;
			}

			if(player.isTransformed())
			{
				showChatWindow(player, "default/" + getNpcId() + "-dualclass_no_transform.htm", false);
				return;
			}

			if(player.hasServitor())
			{
				showChatWindow(player, "default/" + getNpcId() + "-dualclass_no_servitor.htm", false);
				return;
			}

			final String cmd2 = st.nextToken();
			if(cmd2.equalsIgnoreCase("add"))
			{
				if(!st.hasMoreTokens())
				{
					final HtmTemplates tpls = HtmCache.getInstance().getTemplates("default/" + getNpcId() + "-dualclass_add_list.htm", player);
					final String html = tpls.get(0);
					String bypass = tpls.get(1);

					final StringBuilder classes = new StringBuilder();
					for(ClassId clsId : ClassId.VALUES)
					{
						Set<ClassId> excludedClasses = new HashSet<>(Arrays.asList(
								ClassId.OVERLORD, ClassId.WARCRYER, ClassId.WARSMITH, ClassId.F_SOUL_BREAKER,
								ClassId.DEATH_BERSERKER, ClassId.RIPPER, ClassId.STRATOMANCER, ClassId.WARLORD,
								ClassId.PALADIN, ClassId.DARK_AVENGER, ClassId.TREASURE_HUNTER, ClassId.HAWKEYE,
								ClassId.NECROMANCER, ClassId.WARLOCK, ClassId.BISHOP, ClassId.PROPHET,
								ClassId.TEMPLE_KNIGHT, ClassId.SWORDSINGER, ClassId.PLAIN_WALKER, ClassId.SILVER_RANGER,
								ClassId.SPELLSINGER, ClassId.ELEMENTAL_SUMMONER, ClassId.SHILLEN_KNIGHT, ClassId.BLADEDANCER,
								ClassId.ABYSS_WALKER, ClassId.PHANTOM_RANGER, ClassId.SPELLHOWLER, ClassId.PHANTOM_SUMMONER,
								ClassId.SHILLEN_ELDER, ClassId.DESTROYER, ClassId.TYRANT, ClassId.BOUNTY_HUNTER,
								ClassId.BERSERKER, ClassId.M_SOUL_BREAKER, ClassId.ARBALESTER, ClassId.ELDER
						));

						if (!clsId.isOfLevel(ClassLevel.SECOND) || excludedClasses.contains(clsId)) {
							continue;
						}


						classes.append(bypass.replace("<?class_id?>", String.valueOf(clsId.getId())).replace("<?class_name?>", getClassIdNames(player, clsId.getId())));
					}
					showChatWindow(player, html, false, "<?CLASS_LIST?>", classes.toString());
					return;
				}
				else
				{
					final int newClassId = Integer.parseInt(st.nextToken());

					if(!player.isQuestContinuationPossible(false))
					{
						player.sendPacket(SystemMsg.A_SUBCLASS_CANNOT_BE_CREATED_OR_CHANGED_BECAUSE_YOU_HAVE_EXCEEDED_YOUR_INVENTORY_LIMIT);
						showChatWindow(player, "default/" + getNpcId() + "-dualclass_no_weight.htm", false);
						return;
					}

					if(player.addClass(newClassId, true, 0, DualClassType.DUAL_CLASS, Experience.getExpForLevel(1), 1000000))
					{
						player.sendPacket(new ExSubjobInfo(player, true));
						player.sendPacket(new SystemMessagePacket(SystemMsg.THE_NEW_SUBCLASS_S1_HAS_BEEN_ADDED).addClassName(newClassId));
						player.broadcastPacket(new SocialActionPacket(player.getObjectId(), SocialActionPacket.REAWAKENING));
						showChatWindow(player, "default/" + getNpcId() + "-dualclass_add_success.htm", false);
                    }
					else
					{
						showChatWindow(player, "default/" + getNpcId() + "-dualclass_add_error.htm", false);
                    }
                }
			}
		}
		else
			super.onBypassFeedback(player, command);
	}

	private static int calcReawakeCost(Player player)
	{
		int level = player.getLevel();
		switch(level)
		{
			case 85:
				return 100000000;
			case 86:
				return 90000000;
			case 87:
				return 80000000;
			case 88:
				return 70000000;
			case 89:
				return 60000000;
			case 90:
				return 50000000;
			case 91:
				return 40000000;
			case 92:
				return 30000000;
			case 93:
				return 20000000;
		}
		return 10000000;
	}

	private static String getClassIdNames(Player player, int id)
	{
		final ClassId classId = ClassId.VALUES[id];
		final StringBuilder className = new StringBuilder();
		if(classId.isOfLevel(ClassLevel.THIRD))
		{
			final ClassId parent = classId.getParent(player.getSex().ordinal());
			if(parent != null)
			{
				/*className.append(HtmlUtils.htmlClassName(parent.getId()));
				className.append("/");*/
			}
			className.append(HtmlUtils.htmlClassName(classId.getId()));
		}
		else if(classId.isOfLevel(ClassLevel.SECOND))
		{
			className.append(getClassType(player, classId.getId()));
			for (ClassId child : ClassId.VALUES)
			{
				if(child.isOfLevel(ClassLevel.THIRD) && child.getParent(player.getSex().ordinal()) == classId)
				{
					/*className.append("/");
					className.append(HtmlUtils.htmlClassName(child.getId()));*/
					break;
				}
			}
		}
		else
			className.append(HtmlUtils.htmlClassName(classId.getId()));
		return className.toString();
	}

	private static String getClassType(Player player, int classId)
	{
		if (classId == 2) {
			return player.isLangRus() ? "Физический класс" : "Physical Class";
		} else if (classId == 12) {
			return player.isLangRus() ? "Магический класс" : "Magical Class";
		}
		return "Неизвестный класс";
	}


	/*private static int getCloakId(ClassId classId)
	{
		if(!classId.isOfLevel(ClassLevel.AWAKED))
			return 0;

		final ClassId baseAwakedClassId = classId.getBaseAwakedClassId();
		if(baseAwakedClassId == null)
			return 0;

		switch(baseAwakedClassId)
		{
			case SIGEL_KNIGHT:
				return 30310;
			case TYRR_WARRIOR:
				return 30311;
			case OTHELL_ROGUE:
				return 30312;
			case YUL_ARCHER:
				return 30313;
			case FEOH_WIZARD:
				return 30314;
			case WYNN_SUMMONER:
				return 30315;
			case ISS_ENCHANTER:
				return 30316;
			case AEORE_HEALER:
				return 30317;
		}
		return 0;
	}*/
	
	/*private static int getPowerItemId(ClassId classId)
	{
		if(!classId.isOfLevel(ClassLevel.AWAKED))
			return 0;

		final ClassId baseAwakedClassId = classId.getBaseAwakedClassId();
		if(baseAwakedClassId == null)
			return 0;

		switch(baseAwakedClassId)
		{
			case SIGEL_KNIGHT:
				return 32264;
			case TYRR_WARRIOR:
				return 32265;
			case OTHELL_ROGUE:
				return 32266;
			case YUL_ARCHER:
				return 32267;
			case FEOH_WIZARD:
				return 32268;
			case WYNN_SUMMONER:
				return 32269;
			case ISS_ENCHANTER:
				return 32270;
			case AEORE_HEALER:
				return 32271;
		}
		return 0;
	}*/
}