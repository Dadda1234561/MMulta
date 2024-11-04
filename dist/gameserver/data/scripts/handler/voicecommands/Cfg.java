package handler.voicecommands;

import org.apache.commons.lang3.math.NumberUtils;

import l2s.gameserver.Config;
import l2s.gameserver.data.string.StringsHolder;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.htm.HtmTemplates;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.utils.Functions;
import l2s.gameserver.utils.Language;

public class Cfg extends ScriptVoiceCommandHandler
{
	private String[] COMMANDS = new String[] { "lang", "cfg" };

	@Override
	public boolean useVoicedCommand(String command, Player activeChar, String args)
	{
		if(command.equals("cfg"))
			if(args != null)
			{
				String[] param = args.split(" ");
				if(param.length == 2)
				{
					if(param[0].equalsIgnoreCase("lang"))
					{
						if(!Config.USE_CLIENT_LANG && Config.CAN_SELECT_LANGUAGE)
							activeChar.setLanguage(param[1]);
						else
							activeChar.sendMessage(new CustomMessage("l2s.gameserver.handler.voicecommands.impl.Cfg.useVoicedCommand.Lang"));
					}

					if(param[0].equalsIgnoreCase("noe"))
						if(param[1].equalsIgnoreCase("on"))
							activeChar.setVar("NoExp", "1", -1);
						else if(param[1].equalsIgnoreCase("of"))
							activeChar.unsetVar("NoExp");

					if(param[0].equalsIgnoreCase(Player.NO_TRADERS_VAR))
						if(param[1].equalsIgnoreCase("on"))
						{
							activeChar.setNotShowTraders(true);
							activeChar.setVar(Player.NO_TRADERS_VAR, "1", -1);
						}
						else if(param[1].equalsIgnoreCase("of"))
						{
							activeChar.setNotShowTraders(false);
							activeChar.unsetVar(Player.NO_TRADERS_VAR);
						}

					if (param[0].equals(Player.HIT_RAID_VAR)) {
						if (param[1].equals("on")) {
							activeChar.setTargetRaid(true);
							activeChar.setVar(Player.HIT_RAID_VAR, "1", -1);
						} else if (param[1].equals("of")) {
							activeChar.setTargetRaid(false);
							activeChar.unsetVar(Player.HIT_RAID_VAR);
						}
					}

					if(param[0].equalsIgnoreCase(Player.NO_ANIMATION_OF_CAST_VAR))
						if(param[1].equalsIgnoreCase("on"))
						{
							activeChar.setNotShowBuffAnim(true);
							activeChar.setVar(Player.NO_ANIMATION_OF_CAST_VAR, true, -1);
						}
						else if(param[1].equalsIgnoreCase("of"))
						{
							activeChar.setNotShowBuffAnim(false);
							activeChar.unsetVar(Player.NO_ANIMATION_OF_CAST_VAR);
						}

					if(Config.SERVICES_ENABLE_NO_CARRIER && param[0].equalsIgnoreCase("noCarrier"))
					{
						int time = NumberUtils.toInt(param[1], Config.SERVICES_NO_CARRIER_DEFAULT_TIME);

						if(time > Config.SERVICES_NO_CARRIER_MAX_TIME)
							time = Config.SERVICES_NO_CARRIER_MAX_TIME;
						else if(time < Config.SERVICES_NO_CARRIER_MIN_TIME)
							time = Config.SERVICES_NO_CARRIER_MIN_TIME;

						activeChar.setVar("noCarrier", String.valueOf(time), -1);
					}

					if(param[0].equalsIgnoreCase("translit"))
					{
						if(param[1].equalsIgnoreCase("on"))
							activeChar.setVar("translit", "tl", -1);
						else if(param[1].equalsIgnoreCase("la"))
							activeChar.setVar("translit", "tc", -1);
						else if(param[1].equalsIgnoreCase("of"))
							activeChar.unsetVar("translit");
					}

					if(Config.AUTO_LOOT_INDIVIDUAL)
					{
						if(param[0].equalsIgnoreCase("autoloot")){
							activeChar.setAutoLoot(Boolean.parseBoolean(param[1]));
						}
						if(Config.AUTO_LOOT_ONLY_ADENA && param[0].equalsIgnoreCase("autolootonlyadena"))
							activeChar.setAutoLootOnlyAdena(Boolean.parseBoolean(param[1]));
						if(param[0].equalsIgnoreCase("autolooth"))
							activeChar.setAutoLootHerbs(Boolean.parseBoolean(param[1]));
					}
					if(param[0].equalsIgnoreCase("autoloot_autofarm")){
						activeChar.getAutoFarm().setAutoPickUpItems(Boolean.parseBoolean(param[1]));
					}
					if (param[0].equalsIgnoreCase("stateLearnButton")) {
						if (Config.MULTICLASS_SKILL_LEVEL_MAX) {
							activeChar.setLearnSkillMaxLevel(!activeChar.isLearnSkillMaxLevelEnable());
						} else {
							//activeChar.sendAdminMessage(!activeChar.isLangRus() ? "Function disabled." : "Функция отключена.");
							activeChar.sendActionFailed();
							return true;
						}
					}

					if (param[0].equalsIgnoreCase("changeChampionLvl"))
					{
						if(param[1].equalsIgnoreCase("0"))
						{
							activeChar.setChampionLvlChange(0);
						}
						if(param[1].equalsIgnoreCase("1"))
						{
							activeChar.setChampionLvlChange(1);
						}
						else if(param[1].equalsIgnoreCase("2"))
						{
							activeChar.setChampionLvlChange(2);
						}
						else if(param[1].equalsIgnoreCase("3"))
						{
							activeChar.setChampionLvlChange(3);
						}
						else if(param[1].equalsIgnoreCase("4"))
						{
							activeChar.setChampionLvlChange(4);
						}
						else if(param[1].equalsIgnoreCase("5"))
						{
							activeChar.setChampionLvlChange(5);
						}
					}

					if (param[0].equalsIgnoreCase(PlayerVariables.CHANGE_UP_MONSTER_LVL)) {
						int nextLevel = activeChar.getUpMonsterChange();
						try {
							nextLevel = Integer.parseInt(param[1]);
							if (canUpMonster(activeChar, nextLevel)) {
								activeChar.setUpMonsterChange(nextLevel);
							}
						} catch (NumberFormatException e) {
							e.printStackTrace();
						}
					}

					/* if (param[0].equalsIgnoreCase("setRangeCfg"))
					{
						if(param[1].equalsIgnoreCase("1"))
						{
							activeChar.setRangeCfg(1000);
						}
						else if(param[1].equalsIgnoreCase("2"))
						{
							activeChar.setRangeCfg(1500);
						}
						else if(param[1].equalsIgnoreCase("3"))
						{
							activeChar.setRangeCfg(2000);
						}
						else if(param[1].equalsIgnoreCase("4"))
						{
							activeChar.setRangeCfg(2500);
						}
						else if(param[1].equalsIgnoreCase("5"))
						{
							activeChar.setRangeCfg(3000);
						}
					} */
				}
			}

		HtmTemplates templates = HtmCache.getInstance().getTemplates("command/cfg.htm", activeChar);

		String langBlock = "";
		if(!Config.USE_CLIENT_LANG && Config.CAN_SELECT_LANGUAGE)
		{
			boolean haveMoreLanguages = false;
			StringBuilder languagesButtons = new StringBuilder();

			final String langButton = templates.get(2);
			for(Language lang : Config.AVAILABLE_LANGUAGES)
			{
				if(activeChar.getLanguage() == lang)
					continue;

				haveMoreLanguages = true;

				String button = langButton;
				button = button.replace("<?short_lang_name?>", lang.getShortName());
				button = button.replace("<?lang_name?>", StringsHolder.getInstance().getString("LangFull", lang));

				languagesButtons.append(button);
			}

			if(haveMoreLanguages)
			{
				langBlock = templates.get(1);
				langBlock = langBlock.replace("<?current_lang?>", new CustomMessage("LangFull").toString(activeChar));
				langBlock = langBlock.replace("<?available_languages?>", languagesButtons.toString());
			}
		}

		final String disableMessage = new CustomMessage("common.Disable").toString(activeChar);
		final String enableMessage = new CustomMessage("common.Enable").toString(activeChar);

		String autolootBlock = "";
		if(Config.AUTO_LOOT_INDIVIDUAL)
		{
			autolootBlock = templates.get(3);

			String autolootAdena = "";
			if(Config.AUTO_LOOT_ONLY_ADENA)
			{
				autolootAdena = templates.get(4);

				autolootAdena = autolootAdena.replace("<?value_adena?>", String.valueOf(!activeChar.isAutoLootOnlyAdenaEnabled()));
				if(activeChar.isAutoLootOnlyAdenaEnabled())
					autolootAdena = autolootAdena.replace("<?value_name_adena?>", disableMessage);
				else
					autolootAdena = autolootAdena.replace("<?value_name_adena?>", enableMessage);
			}

			autolootBlock = autolootBlock.replace("<?adena_autoloot?>", autolootAdena);

			autolootBlock = autolootBlock.replace("<?value_items?>", String.valueOf(!activeChar.isAutoLootEnabled()));
			autolootBlock = autolootBlock.replace("<?autoloot_autofarm?>", String.valueOf(!activeChar.getAutoFarm().isAutoPickUpItems()));
			if(activeChar.isAutoLootEnabled())
				autolootBlock = autolootBlock.replace("<?value_name_items?>", disableMessage);
			else
				autolootBlock = autolootBlock.replace("<?value_name_items?>", enableMessage);
			autolootBlock = autolootBlock.replace("<?value_herbs?>", String.valueOf(!activeChar.isAutoLootHerbsEnabled()));
			if(activeChar.isAutoLootHerbsEnabled())
				autolootBlock = autolootBlock.replace("<?value_name_herbs?>", disableMessage);
			else
				autolootBlock = autolootBlock.replace("<?value_name_herbs?>", enableMessage);

			if(activeChar.getAutoFarm().isAutoPickUpItems())
				autolootBlock = autolootBlock.replace("<?autoloot_autofarm_name?>", disableMessage);
			else
				autolootBlock = autolootBlock.replace("<?autoloot_autofarm_name?>", enableMessage);
		}

		String noCarrierBlock = "";
		if(Config.SERVICES_ENABLE_NO_CARRIER)
		{
			noCarrierBlock = templates.get(5);
			noCarrierBlock = noCarrierBlock.replace("<?no_carrier_time?>", Config.SERVICES_ENABLE_NO_CARRIER ? (activeChar.getVarBoolean("noCarrier") ? activeChar.getVar("noCarrier") : "0") : "N/A");
		}

		String dialog = templates.get(0);
		dialog = dialog.replace("<?lang_block?>", langBlock);
		dialog = dialog.replace("<?autoloot_block?>", autolootBlock);
		dialog = dialog.replace("<?no_carrier_block?>", noCarrierBlock);

		if(activeChar.getVarBoolean("NoExp"))
		{
			dialog = dialog.replace("<?value_noe?>", "of");
			dialog = dialog.replace("<?value_name_noe?>", disableMessage);
		}
		else
		{
			dialog = dialog.replace("<?value_noe?>", "on");
			dialog = dialog.replace("<?value_name_noe?>", enableMessage);
		}

		if(activeChar.isTargetRaid())
		{
			dialog = dialog.replace("<?value_hitraid?>", "of");
			dialog = dialog.replace("<?value_name_hitraid?>", disableMessage);
		}
		else
		{
			dialog = dialog.replace("<?value_hitraid?>", "on");
			dialog = dialog.replace("<?value_name_hitraid?>", enableMessage);
		}

		if(activeChar.getVarBoolean("notraders"))
		{
			dialog = dialog.replace("<?value_notraders?>", "of");
			dialog = dialog.replace("<?value_name_notraders?>", disableMessage);
		}
		else
		{
			dialog = dialog.replace("<?value_notraders?>", "on");
			dialog = dialog.replace("<?value_name_notraders?>", enableMessage);
		}

		if(activeChar.getVarBoolean("notShowBuffAnim"))
		{
			dialog = dialog.replace("<?value_notShowBuffAnim?>", "of");
			dialog = dialog.replace("<?value_name_notShowBuffAnim?>", disableMessage);
		}
		else
		{
			dialog = dialog.replace("<?value_notShowBuffAnim?>", "on");
			dialog = dialog.replace("<?value_name_notShowBuffAnim?>", enableMessage);
		}

		String tl = activeChar.getVar("translit");
		if(tl == null)
		{
			dialog = dialog.replace("<?value_translit?>", "on");
			dialog = dialog.replace("<?value_name_translit?>", enableMessage);
		}
		else if(tl.equals("tl"))
		{
			dialog = dialog.replace("<?value_translit?>", "la");
			dialog = dialog.replace("<?value_name_translit?>", "Lt");
		}
		else if(tl.equals("tc"))
		{
			dialog = dialog.replace("<?value_translit?>", "of");
			dialog = dialog.replace("<?value_name_translit?>", disableMessage);
		}

		String cLc = activeChar.getVar("championLvlChange");
		if(cLc == null)
		{
			activeChar.setChampionLvlChange((short) 0);
			dialog = dialog.replace("<?block_0?>", "+");
			dialog = dialog.replace("<?block_1?>", "-");
			dialog = dialog.replace("<?block_2?>", "-");
			dialog = dialog.replace("<?block_3?>", "-");
			dialog = dialog.replace("<?block_4?>", "-");
			dialog = dialog.replace("<?block_5?>", "-");
		}
		 else if(cLc.equals("0"))
		{
			dialog = dialog.replace("<?block_0?>", "+");
			dialog = dialog.replace("<?block_1?>", "-");
			dialog = dialog.replace("<?block_2?>", "-");
			dialog = dialog.replace("<?block_3?>", "-");
			dialog = dialog.replace("<?block_4?>", "-");
			dialog = dialog.replace("<?block_5?>", "-");
		}
		else if(cLc.equals("1"))
		{
			dialog = dialog.replace("<?block_0?>", "-");
			dialog = dialog.replace("<?block_1?>", "+");
			dialog = dialog.replace("<?block_2?>", "-");
			dialog = dialog.replace("<?block_3?>", "-");
			dialog = dialog.replace("<?block_4?>", "-");
			dialog = dialog.replace("<?block_5?>", "-");
		}
		else if(cLc.equals("2"))
		{
			dialog = dialog.replace("<?block_0?>", "-");
			dialog = dialog.replace("<?block_1?>", "-");
			dialog = dialog.replace("<?block_2?>", "+");
			dialog = dialog.replace("<?block_3?>", "-");
			dialog = dialog.replace("<?block_4?>", "-");
			dialog = dialog.replace("<?block_5?>", "-");
		}
		else if(cLc.equals("3"))
		{
			dialog = dialog.replace("<?block_0?>", "-");
			dialog = dialog.replace("<?block_1?>", "-");
			dialog = dialog.replace("<?block_2?>", "-");
			dialog = dialog.replace("<?block_3?>", "+");
			dialog = dialog.replace("<?block_4?>", "-");
			dialog = dialog.replace("<?block_5?>", "-");
		}
		else if(cLc.equals("4"))
		{
			dialog = dialog.replace("<?block_0?>", "-");
			dialog = dialog.replace("<?block_1?>", "-");
			dialog = dialog.replace("<?block_2?>", "-");
			dialog = dialog.replace("<?block_3?>", "-");
			dialog = dialog.replace("<?block_4?>", "+");
			dialog = dialog.replace("<?block_5?>", "-");
		}
		else if(cLc.equals("5"))
		{
			dialog = dialog.replace("<?block_0?>", "-");
			dialog = dialog.replace("<?block_1?>", "-");
			dialog = dialog.replace("<?block_2?>", "-");
			dialog = dialog.replace("<?block_3?>", "-");
			dialog = dialog.replace("<?block_4?>", "-");
			dialog = dialog.replace("<?block_5?>", "+");
		}

		String monstUp = activeChar.getVar(PlayerVariables.CHANGE_UP_MONSTER_LVL, "0");
		if(monstUp.equals("0"))
		{
			dialog = dialog.replace("<?cblock_0?>", "+");
			dialog = dialog.replace("<?cblock_1?>", "-");
			dialog = dialog.replace("<?cblock_2?>", "-");
			dialog = dialog.replace("<?cblock_3?>", "-");
			dialog = dialog.replace("<?cblock_4?>", "-");
			dialog = dialog.replace("<?cblock_5?>", "-");
		}
		else if(monstUp.equals("1"))
		{
			dialog = dialog.replace("<?cblock_0?>", "-");
			dialog = dialog.replace("<?cblock_1?>", "+");
			dialog = dialog.replace("<?cblock_2?>", "-");
			dialog = dialog.replace("<?cblock_3?>", "-");
			dialog = dialog.replace("<?cblock_4?>", "-");
			dialog = dialog.replace("<?cblock_5?>", "-");
		}
		else if(monstUp.equals("2"))
		{
			dialog = dialog.replace("<?cblock_0?>", "-");
			dialog = dialog.replace("<?cblock_1?>", "-");
			dialog = dialog.replace("<?cblock_2?>", "+");
			dialog = dialog.replace("<?cblock_3?>", "-");
			dialog = dialog.replace("<?cblock_4?>", "-");
			dialog = dialog.replace("<?cblock_5?>", "-");
		}
		else if(monstUp.equals("3"))
		{
			dialog = dialog.replace("<?cblock_0?>", "-");
			dialog = dialog.replace("<?cblock_1?>", "-");
			dialog = dialog.replace("<?cblock_2?>", "-");
			dialog = dialog.replace("<?cblock_3?>", "+");
			dialog = dialog.replace("<?cblock_4?>", "-");
			dialog = dialog.replace("<?cblock_5?>", "-");
		}
		else if(monstUp.equals("4"))
		{
			dialog = dialog.replace("<?cblock_0?>", "-");
			dialog = dialog.replace("<?cblock_1?>", "-");
			dialog = dialog.replace("<?cblock_2?>", "-");
			dialog = dialog.replace("<?cblock_3?>", "-");
			dialog = dialog.replace("<?cblock_4?>", "+");
			dialog = dialog.replace("<?cblock_5?>", "-");
		}
		else if(monstUp.equals("5"))
		{
			dialog = dialog.replace("<?cblock_0?>", "-");
			dialog = dialog.replace("<?cblock_1?>", "-");
			dialog = dialog.replace("<?cblock_2?>", "-");
			dialog = dialog.replace("<?cblock_3?>", "-");
			dialog = dialog.replace("<?cblock_4?>", "-");
			dialog = dialog.replace("<?cblock_5?>", "+");
		}

		String changeAvailableMessage = new CustomMessage("common.ChangeAvailable").toString(activeChar);
		int currentMonsterUpLevel = Integer.parseInt(monstUp);
		for (int level = 0; level < 6; level++) 
		{
			int rebirthsRequired = (level * 50);
			String target = "%" + level + "_up_monster_status%";
			String replacement = (currentMonsterUpLevel >= level) ? changeAvailableMessage : new CustomMessage("common.ChangeUnavailable").addNumber(rebirthsRequired).toString(activeChar);
			dialog = dialog.replace(target, replacement);
		}

		if(Config.MULTICLASS_SKILL_LEVEL_MAX) {
			if(activeChar.isLearnSkillMaxLevelEnable())
				dialog = dialog.replace("<?learnMaxLevelButton?>", "false");
			else
				dialog = dialog.replace("<?learnMaxLevelButton?>", "true");
			dialog = dialog.replace("<?learnMaxLevel?>", activeChar.isLearnSkillMaxLevelEnable() ? disableMessage : enableMessage);
		}

		String range = activeChar.getVar("setRangeCfg");
		if(range == null)
		{
			// activeChar.setRangeCfg(1000);
			dialog = dialog.replace("<?b_1?>", "+");
			dialog = dialog.replace("<?b_2?>", "-");
			dialog = dialog.replace("<?b_3?>", "-");
			dialog = dialog.replace("<?b_4?>", "-");
			dialog = dialog.replace("<?b_5?>", "-");
		}
		else if(range.equals("1000"))
		{
			dialog = dialog.replace("<?b_1?>", "+");
			dialog = dialog.replace("<?b_2?>", "-");
			dialog = dialog.replace("<?b_3?>", "-");
			dialog = dialog.replace("<?b_4?>", "-");
			dialog = dialog.replace("<?b_5?>", "-");
		}
		else if(range.equals("1500"))
		{
			dialog = dialog.replace("<?b_1?>", "-");
			dialog = dialog.replace("<?b_2?>", "+");
			dialog = dialog.replace("<?b_3?>", "-");
			dialog = dialog.replace("<?b_4?>", "-");
			dialog = dialog.replace("<?b_5?>", "-");
		}
		else if(range.equals("2000"))
		{
			dialog = dialog.replace("<?b_1?>", "-");
			dialog = dialog.replace("<?b_2?>", "-");
			dialog = dialog.replace("<?b_3?>", "+");
			dialog = dialog.replace("<?b_4?>", "-");
			dialog = dialog.replace("<?b_5?>", "-");
		}
		else if(range.equals("2500"))
		{
			dialog = dialog.replace("<?b_1?>", "-");
			dialog = dialog.replace("<?b_2?>", "-");
			dialog = dialog.replace("<?b_3?>", "-");
			dialog = dialog.replace("<?b_4?>", "+");
			dialog = dialog.replace("<?b_5?>", "-");
		}
		else if(range.equals("3000"))
		{
			dialog = dialog.replace("<?b_1?>", "-");
			dialog = dialog.replace("<?b_2?>", "-");
			dialog = dialog.replace("<?b_3?>", "-");
			dialog = dialog.replace("<?b_4?>", "-");
			dialog = dialog.replace("<?b_5?>", "+");
		}

		Functions.show(dialog, activeChar);

		return true;
	}

	private boolean canUpMonster(Player activeChar, int nextLevel) {
		final int rebirthCount = activeChar.getRebirthCount();
		int requiredRebirths;
		switch (nextLevel) {
			case 1: {
				requiredRebirths = 100;
				break;
			}
			case 2: {
				requiredRebirths = 150;
				break;
			}
			case 3: {
				requiredRebirths = 200;
				break;
			}
			case 4: {
				requiredRebirths = 230;
				break;
			}
			case 5: {
				requiredRebirths = 270;
				break;
			}
			default: {
				requiredRebirths = 0;
			}
		}

		if (rebirthCount < requiredRebirths) {
			activeChar.sendMessage("Необходимо " + requiredRebirths + " или более перерождений, чтобы активировать данную функцию.");
			activeChar.sendScreenMessage("Необходимо " + requiredRebirths + " или более перерождений, чтобы активировать данную функцию.");
			return false;
		}
		return true;
	}

	@Override
	public String[] getVoicedCommandList()
	{
		return COMMANDS;
	}
}