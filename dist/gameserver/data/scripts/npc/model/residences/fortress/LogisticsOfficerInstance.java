package npc.model.residences.fortress;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.dao.JdbcEntityState;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.residence.Fortress;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.NpcUtils;

/**
 * @author VISTALL
 */
public class LogisticsOfficerInstance extends FacilityManagerInstance
{
	private static final int[] SUPPLY_NPC = new int[]
	{
		35665,
		35697,
		35734,
		35766,
		35803,
		35834
	};

	private static final int ITEM_ID = 9910; // Blood Oath

	public LogisticsOfficerInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		Fortress fortress = getFortress();

		if(!player.isClanLeader() || fortress.getOwnerId() != player.getClanId())
		{
			showChatWindow(player, "residence2/fortress/fortress_not_authorized.htm", false);
			return;
		}

		if(command.equalsIgnoreCase("guardInfo"))
		{
			if(fortress.getContractState() != Fortress.CONTRACT_WITH_CASTLE)
			{
				showChatWindow(player, "residence2/fortress/fortress_supply_officer005.htm", false);
				return;
			}

			showChatWindow(player, "residence2/fortress/fortress_supply_officer002.htm", false, "%guard_buff_level%", fortress.getFacilityLevel(Fortress.GUARD_BUFF));
		}
		else if(command.equalsIgnoreCase("supplyInfo"))
		{
			if(fortress.getContractState() != Fortress.CONTRACT_WITH_CASTLE)
			{
				showChatWindow(player, "residence2/fortress/fortress_supply_officer005.htm", false);
				return;
			}

			showChatWindow(player, "residence2/fortress/fortress_supply_officer009.htm", false, "%supply_count%", fortress.getSupplyCount());
		}
		else if(command.equalsIgnoreCase("rewardInfo"))
		{
			showChatWindow(player, "residence2/fortress/fortress_supply_officer010.htm", false, "%blood_oaths%", fortress.getRewardCount());
		}
		else if(command.equalsIgnoreCase("receiveSupply"))
		{
			String filename;
			if(fortress.getSupplyCount() > 0)
			{
				filename = "residence2/fortress/fortress_supply_officer016.htm";

				NpcUtils.spawnSingle(SUPPLY_NPC[fortress.getSupplyCount() - 1], new Location(getX() - 23, getY() + 41, getZ()));

				fortress.setSupplyCount(0);
				fortress.setJdbcState(JdbcEntityState.UPDATED);
				fortress.update();
			}
			else
				filename ="residence2/fortress/fortress_supply_officer017.htm";

			HtmlMessage html = new HtmlMessage(this);
			html.setFile(filename);
			player.sendPacket(html);
		}
		else if(command.equalsIgnoreCase("receiveRewards"))
		{
			String filename;
			int count = fortress.getRewardCount();
			if(count > 0)
			{
				filename = "residence2/fortress/fortress_supply_officer013.htm";
				fortress.setRewardCount(0);
				fortress.setJdbcState(JdbcEntityState.UPDATED);
				fortress.update();

				ItemFunctions.addItem(player, ITEM_ID, count);
			}
			else
				filename ="residence2/fortress/fortress_supply_officer014.htm";

			HtmlMessage html = new HtmlMessage(this);
			html.setFile(filename);
			player.sendPacket(html);
		}
		else if(command.equalsIgnoreCase("toLevel1"))
			buyFacility(player, Fortress.GUARD_BUFF, 1, 100000);
		else if(command.equalsIgnoreCase("toLevel2"))
			buyFacility(player, Fortress.GUARD_BUFF, 2, 150000);
		else
			super.onBypassFeedback(player, command);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{
		showChatWindow(player, "residence2/fortress/fortress_supply_officer001.htm", firstTalk);
	}
}