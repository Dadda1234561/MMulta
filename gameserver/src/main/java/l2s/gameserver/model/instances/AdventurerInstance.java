package l2s.gameserver.model.instances;

import l2s.commons.time.cron.SchedulingPattern;
import java.util.StringTokenizer;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.data.xml.holder.MultiSellHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.ExShowQuestInfoPacket;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.TimeUtils;

public class AdventurerInstance extends NpcInstance
{
	private static final int ADVENTURERS_MARK_LOYALTY = 17739;	// Знак Путешественника - Верность
	private static final int ADVENTURERS_MARK_PLEDGE = 17740;	// Знак Путешественника - Обет
	private static final int ADVENTURERS_MARK_SINCERITY = 17741;	// Знак Путешественника - Искренность
	private static final int ADVENTURERS_MARK_SPIRIT = 17742;	// Знак Путешественника - Воля

	private static final int SEAL_OF_LOYALTY = 17743;	// Печать Верности
	private static final int SEAL_OF_PLEDGE = 17744;	// Печать Обета
	private static final int SEAL_OF_SINCERITY = 17745;	// Печать Искренности
	private static final int SEAL_OF_SPIRIT = 17746;	// Печать Воли

	private static final SchedulingPattern REUSE_PATTERN = TimeUtils.DAILY_DATE_PATTERN;

	public AdventurerInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		StringTokenizer st = new StringTokenizer(command, "_");
		String cmd = st.nextToken();
		if(cmd.equals("questlist"))
			player.sendPacket(ExShowQuestInfoPacket.STATIC);
		else if(cmd.equals("exchangemark"))
		{
			if(!st.hasMoreTokens())
				return;

			String cmd2 = st.nextToken();
			if(cmd2.equals("loyalty"))
			{
				if(!player.getClassId().isAwaked())
					showChatWindow(player, "adventurer_guildsman/voucher_trader1003c.htm", false);
				else if(REUSE_PATTERN.next(player.getVarInt("exchangemark_loyalty") * 1000L) > System.currentTimeMillis())
					showChatWindow(player, "adventurer_guildsman/voucher_trader1002.htm", false);
				else if(ItemFunctions.deleteItem(player, ADVENTURERS_MARK_LOYALTY, 1))
				{
					ItemFunctions.addItem(player, SEAL_OF_LOYALTY, 20);
					player.addExpAndSp(60000000, 0);
					player.setVar("exchangemark_loyalty", (int) (System.currentTimeMillis() / 1000));
					showChatWindow(player, "adventurer_guildsman/voucher_trader1003a.htm", false);
				}
				else
					showChatWindow(player, "adventurer_guildsman/voucher_trader1003b.htm", false);
			}
			else if(cmd2.equals("pledge"))
			{
				if(!player.getClassId().isAwaked())
					showChatWindow(player, "adventurer_guildsman/voucher_trader2003c.htm", false);
				else if(REUSE_PATTERN.next(player.getVarInt("exchangemark_pledge") * 1000L) > System.currentTimeMillis())
					showChatWindow(player, "adventurer_guildsman/voucher_trader2002.htm", false);
				else if(ItemFunctions.deleteItem(player, ADVENTURERS_MARK_PLEDGE, 1))
				{
					ItemFunctions.addItem(player, SEAL_OF_PLEDGE, 20);
					player.addExpAndSp(60000000, 0);
					player.setVar("exchangemark_pledge", (int) (System.currentTimeMillis() / 1000));
					showChatWindow(player, "adventurer_guildsman/voucher_trader2003a.htm", false);
				}
				else
					showChatWindow(player, "adventurer_guildsman/voucher_trader2003b.htm", false);
			}
			else if(cmd2.equals("sincerity"))
			{
				if(!player.getClassId().isAwaked())
					showChatWindow(player, "adventurer_guildsman/voucher_trader3003c.htm", false);
				else if(REUSE_PATTERN.next(player.getVarInt("exchangemark_sincerity") * 1000L) > System.currentTimeMillis())
					showChatWindow(player, "adventurer_guildsman/voucher_trader3002.htm", false);
				else if(ItemFunctions.deleteItem(player, ADVENTURERS_MARK_SINCERITY, 1))
				{
					ItemFunctions.addItem(player, SEAL_OF_SINCERITY, 20);
					player.addExpAndSp(60000000, 0);
					player.setVar("exchangemark_sincerity", (int) (System.currentTimeMillis() / 1000));
					showChatWindow(player, "adventurer_guildsman/voucher_trader3003a.htm", false);
				}
				else
					showChatWindow(player, "adventurer_guildsman/voucher_trader3003b.htm", false);
			}
			else if(cmd2.equals("spirit"))
			{
				if(!player.getClassId().isAwaked())
					showChatWindow(player, "adventurer_guildsman/voucher_trader4003c.htm", false);
				else if(REUSE_PATTERN.next(player.getVarInt("exchangemark_spirit") * 1000L) > System.currentTimeMillis())
					showChatWindow(player, "adventurer_guildsman/voucher_trader4002.htm", false);
				else if(ItemFunctions.deleteItem(player, ADVENTURERS_MARK_SPIRIT, 1))
				{
					ItemFunctions.addItem(player, SEAL_OF_SPIRIT, 20);
					player.addExpAndSp(60000000, 0);
					player.setVar("exchangemark_spirit", (int) (System.currentTimeMillis() / 1000));
					showChatWindow(player, "adventurer_guildsman/voucher_trader4003a.htm", false);
				}
				else
					showChatWindow(player, "adventurer_guildsman/voucher_trader4003b.htm", false);
			}
		}
		else if(cmd.equals("buyclasstalisman"))
		{
			if(!st.hasMoreTokens())
				return;

			String cmd2 = st.nextToken();
			if(cmd2.equals("loyalty"))
			{
				switch(player.getClassId().getBaseAwakedClassId().getId())
				{
					case 139:
						MultiSellHolder.getInstance().SeparateAndSend(735, player, 0);
						break;
					case 140:
						MultiSellHolder.getInstance().SeparateAndSend(736, player, 0);
						break;
					case 141:
						MultiSellHolder.getInstance().SeparateAndSend(737, player, 0);
						break;
					case 142:
						MultiSellHolder.getInstance().SeparateAndSend(738, player, 0);
						break;
					case 143:
						MultiSellHolder.getInstance().SeparateAndSend(739, player, 0);
						break;
					case 144:
						MultiSellHolder.getInstance().SeparateAndSend(740, player, 0);
						break;
					case 145:
						MultiSellHolder.getInstance().SeparateAndSend(741, player, 0);
						break;
					case 146:
						MultiSellHolder.getInstance().SeparateAndSend(742, player, 0);
					//TODO: Add multisells for Ertheia race.
				}
			}
			else if(cmd2.equals("pledge"))
			{
				switch(player.getClassId().getBaseAwakedClassId().getId())
				{
					case 139:
						MultiSellHolder.getInstance().SeparateAndSend(743, player, 0);
						break;
					case 140:
						MultiSellHolder.getInstance().SeparateAndSend(744, player, 0);
						break;
					case 141:
						MultiSellHolder.getInstance().SeparateAndSend(745, player, 0);
						break;
					case 142:
						MultiSellHolder.getInstance().SeparateAndSend(746, player, 0);
						break;
					case 143:
						MultiSellHolder.getInstance().SeparateAndSend(747, player, 0);
						break;
					case 144:
						MultiSellHolder.getInstance().SeparateAndSend(748, player, 0);
						break;
					case 145:
						MultiSellHolder.getInstance().SeparateAndSend(749, player, 0);
						break;
					case 146:
						MultiSellHolder.getInstance().SeparateAndSend(750, player, 0);
					//TODO: Add multisells for Ertheia race.
				}
			}
			else if(cmd2.equals("sincerity"))
			{
				switch(player.getClassId().getBaseAwakedClassId().getId())
				{
					case 139:
						MultiSellHolder.getInstance().SeparateAndSend(751, player, 0);
						break;
					case 140:
						MultiSellHolder.getInstance().SeparateAndSend(752, player, 0);
						break;
					case 141:
						MultiSellHolder.getInstance().SeparateAndSend(753, player, 0);
						break;
					case 142:
						MultiSellHolder.getInstance().SeparateAndSend(754, player, 0);
						break;
					case 143:
						MultiSellHolder.getInstance().SeparateAndSend(755, player, 0);
						break;
					case 144:
						MultiSellHolder.getInstance().SeparateAndSend(756, player, 0);
						break;
					case 145:
						MultiSellHolder.getInstance().SeparateAndSend(757, player, 0);
						break;
					case 146:
						MultiSellHolder.getInstance().SeparateAndSend(758, player, 0);
					//TODO: Add multisells for Ertheia race.
				}
			}
			/*else if(cmd2.equals("spirit"))
			{
				switch(player.getClassId())
				{
					case SIGEL_KNIGHT:
					case SIGEL_PHOENIX_KNIGHT:
					case SIGEL_HELL_KNIGHT:
					case SIGEL_EVAS_TEMPLAR:
					case SIGEL_SHILLIEN_TEMPLAR:
						MultiSellHolder.getInstance().SeparateAndSend(759, player, 0);
						break;
					case TYRR_WARRIOR:
					case TYRR_DUELIST:
					case TYRR_DREADNOUGHT:
					case TYRR_TITAN:
					case TYRR_GRAND_KHAVATARI:
					case TYRR_MAESTRO:
					case TYRR_DOOMBRINGER:
					case EVISCERATOR: // TODO: Check.
						MultiSellHolder.getInstance().SeparateAndSend(760, player, 0);
						break;
					case OTHELL_ROGUE:
					case OTHELL_ADVENTURER:
					case OTHELL_WIND_RIDER:
					case OTHELL_GHOST_HUNTER:
					case OTHELL_FORTUNE_SEEKER:
						MultiSellHolder.getInstance().SeparateAndSend(761, player, 0);
						break;
					case YUL_ARCHER:
					case YUL_SAGITTARIUS:
					case YUL_MOONLIGHT_SENTINEL:
					case YUL_GHOST_SENTINEL:
					case YUL_TRICKSTER:
						MultiSellHolder.getInstance().SeparateAndSend(762, player, 0);
						break;
					case FEOH_WIZARD:
					case FEOH_ARCHMAGE:
					case FEOH_SOULTAKER:
					case FEOH_MYSTIC_MUSE:
					case FEOH_STORM_SCREAMER:
					case FEOH_SOUL_HOUND:
					case SAYHA_SEER: // TODO: Check.
						MultiSellHolder.getInstance().SeparateAndSend(763, player, 0);
						break;
					case ISS_ENCHANTER:
					case ISS_HIEROPHANT:
					case ISS_SWORD_MUSE:
					case ISS_SPECTRAL_DANCER:
					case ISS_DOMINATOR:
					case ISS_DOOMCRYER:
						MultiSellHolder.getInstance().SeparateAndSend(764, player, 0);
						break;
					case WYNN_SUMMONER:
					case WYNN_ARCANA_LORD:
					case WYNN_ELEMENTAL_MASTER:
					case WYNN_SPECTRAL_MASTER:
						MultiSellHolder.getInstance().SeparateAndSend(765, player, 0);
						break;
					case AEORE_HEALER:
					case AEORE_CARDINAL:
					case AEORE_EVAS_SAINT:
					case AEORE_SHILLIEN_SAINT:
						MultiSellHolder.getInstance().SeparateAndSend(766, player, 0);
						break;
				}
			}*/
		}
		else
			super.onBypassFeedback(player, command);
	}

	@Override
	public String getHtmlDir(String filename, Player player)
	{
		return "adventurer_guildsman/";
	}
}