package l2s.gameserver.model.instances;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.Race;
import l2s.gameserver.model.entity.events.impl.SiegeEvent;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.model.pledge.SubUnit;
import l2s.gameserver.model.pledge.UnitMember;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.c2s.pledge.RequestExCreatePledge;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExShowUpgradeSystem;
import l2s.gameserver.network.l2.s2c.ExShowUpgradeSystemNormal;
import l2s.gameserver.network.l2.s2c.pledge.ExShowCreatePledge;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.SiegeUtils;

import java.util.StringTokenizer;

public final class VillageMasterInstance extends NpcInstance
{
	public VillageMasterInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.equals("manage_clan"))
		{
			showChatWindow(player, "pledge/pl001.htm", false);
		}
		else if(command.equals("manage_alliance"))
		{
			showChatWindow(player, "pledge/al001.htm", false);
		}
		else if(command.equals("create_clan_check"))
		{
			if(player.getLevel() <= 9)
				showChatWindow(player, "pledge/pl002.htm", false);
			else if(player.isClanLeader())
				showChatWindow(player, "pledge/pl003.htm", false);
			else if(player.getClan() != null)
				showChatWindow(player, "pledge/pl004.htm", false);
			else
				player.sendPacket(ExShowCreatePledge.STATIC);
		}
		else if(command.equals("lvlup_clan_check"))
		{
			if(!player.isClanLeader())
			{
				showChatWindow(player, "pledge/pl014.htm", false);
				return;
			}
			showChatWindow(player, "pledge/pl013.htm", false);
		}
		else if(command.equals("disband_clan_check"))
		{
			if(!player.isClanLeader())
			{
				showChatWindow(player, "pledge/pl_err_master.htm", false);
				return;
			}
			showChatWindow(player, "pledge/pl007.htm", false);
		}
		else if(command.equals("restore_clan_check"))
		{
			if(!player.isClanLeader())
			{
				showChatWindow(player, "pledge/pl011.htm", false);
				return;
			}
			showChatWindow(player, "pledge/pl010.htm", false);
		}
		else if(command.equals("change_leader_check"))
		{
			showChatWindow(player, "pledge/pl_master.htm", false);
		}
		else if(command.startsWith("request_change_leader_check"))
		{
			if(!player.isClanLeader())
			{
				showChatWindow(player, "pledge/pl_err_master.htm", false);
				return;
			}
			showChatWindow(player, "pledge/pl_transfer_master.htm", false);
		}
		else if(command.startsWith("cancel_change_leader_check"))
		{
			if(!player.isClanLeader())
			{
				showChatWindow(player, "pledge/pl_err_master.htm", false);
				return;
			}
			showChatWindow(player, "pledge/pl_cancel_master.htm", false);
		}
		else if(command.equals("academy_manage_check"))
		{
			showChatWindow(player, "pledge/pl_aca_help.htm", false);
		}
		else if(command.equals("guards_manage_check"))
		{
			showChatWindow(player, "pledge/pl_sub_help.htm", false);
		}
		else if(command.equals("knights_manage_check"))
		{
			showChatWindow(player, "pledge/pl_sub2_help.htm", false);
		}
		else if(command.startsWith("change_leader"))
		{
			StringTokenizer tokenizer = new StringTokenizer(command);
			if(tokenizer.countTokens() != 3)
				return;

			tokenizer.nextToken();

			VillageMasterPledgeBypasses.changeLeader(this, player, Integer.parseInt(tokenizer.nextToken()), tokenizer.nextToken());
		}
		else if(command.startsWith("check_subpledge_exists"))
		{
			StringTokenizer tokenizer = new StringTokenizer(command);
			tokenizer.nextToken();

			if(!VillageMasterPledgeBypasses.checkPlayerForClanLeader(this, player))
				return;

			int subunitId = Integer.parseInt(tokenizer.nextToken());
			String errorDialog = tokenizer.nextToken();
			String nextDialog = tokenizer.nextToken();

			Clan clan = player.getClan();
			SubUnit subUnit = clan.getSubUnit(subunitId);
			if(subUnit == null)
				showChatWindow(player, errorDialog, false);
			else
				showChatWindow(player, nextDialog, false);
		}
		else if(command.startsWith("cancel_change_leader"))
			VillageMasterPledgeBypasses.cancelLeaderChange(this, player);
		else if(command.startsWith("check_create_ally"))
			showChatWindow(player, "pledge/al005.htm", false);
		else if(command.startsWith("create_ally"))
		{
			if(command.length() > 12)
			{
				String val = command.substring(12);
				if(VillageMasterPledgeBypasses.createAlly(player, val))
					showChatWindow(player, "pledge/al006.htm", false);
			}
		}
		else if(command.startsWith("dissolve_clan"))
			VillageMasterPledgeBypasses.dissolveClan(this, player);
		else if(command.startsWith("restore_clan"))
			VillageMasterPledgeBypasses.restoreClan(this, player);
		else if(command.startsWith("ShowCouponExchange"))
		{
			if(ItemFunctions.getItemCount(player, 8869) > 0 || ItemFunctions.getItemCount(player, 8870) > 0)
				command = "Multisell 800";
			else
				command = "Link villagemaster/reflect_weapon_master_noticket.htm";
			super.onBypassFeedback(player, command);
		}
		else
			super.onBypassFeedback(player, command);
	}

	@Override
	public void onMenuSelect(Player player, int ask, long reply, int state)
	{
		if(ask == -2418)
		{
			if(reply == 1)
			{
				player.sendPacket(new ExShowUpgradeSystem(1));
			}
			else if(reply == 2)
			{
				player.sendPacket(new ExShowUpgradeSystemNormal(1));
			}
			else if(reply == 3)
			{
				player.sendPacket(new ExShowUpgradeSystemNormal(2));
			}
			else if(reply == 4)
			{
				showChatWindow(player, "villagemaster/upgrade_system001a.htm", false);
			}
		}
		else
			super.onMenuSelect(player, ask, reply, state);
	}

	@Override
	public String getHtmlDir(String filename, Player player)
	{
		return "villagemaster/";
	}

	public void setLeader(Player leader, String newLeader)
	{
		if(!leader.isClanLeader())
		{
			leader.sendPacket(SystemMsg.ONLY_THE_CLAN_LEADER_IS_ENABLED);
			return;
		}

		if(leader.containsEvent(SiegeEvent.class))
		{
			leader.sendMessage(new CustomMessage("scripts.services.Rename.SiegeNow"));
			return;
		}

		Clan clan = leader.getClan();
		UnitMember member = clan.getAnyMember(newLeader);
		if(member == null)
		{
			showChatWindow(leader, "pledge/pl_err_man.htm", false);
			return;
		}

		if(member.isClanLeader())
		{
			leader.sendMessage(new CustomMessage("l2s.gameserver.model.instances.L2VillageMasterInstance.CannotAssignUnitLeader"));
			return;
		}
		setLeader(leader, clan, member);
	}

	public static void setLeader(Player player, Clan clan, UnitMember newLeader)
	{
		player.sendMessage(new CustomMessage("l2s.gameserver.model.instances.L2VillageMasterInstance.ClanLeaderWillBeChangedFromS1ToS2").addString(clan.getLeaderName()).addString(newLeader.getName()));

		if(clan.getLevel() >= SiegeUtils.MIN_CLAN_SIEGE_LEVEL)
		{
			if(clan.getLeader() != null)
			{
				Player oldLeaderPlayer = clan.getLeader().getPlayer();
				if(oldLeaderPlayer != null)
					SiegeUtils.removeSiegeSkills(oldLeaderPlayer);
			}
			Player newLeaderPlayer = newLeader.getPlayer();
			if(newLeaderPlayer != null)
				SiegeUtils.addSiegeSkills(newLeaderPlayer);
		}

		clan.setLeader(newLeader.getObjectId(), true);
		clan.broadcastClanStatus(true, true, false);
	}

	private Race getVillageMasterRace()
	{
		switch(getTemplate().getRace())
		{
			case 14:
				return Race.HUMAN;
			case 15:
				return Race.ELF;
			case 16:
				return Race.DARKELF;
			case 17:
				return Race.ORC;
			case 18:
				return Race.DWARF;
			case 25:
				return Race.KAMAEL;
		}
		return null;
	}

	@Override
	public boolean canPassPacket(Player player, Class<? extends L2GameClientPacket> packet, Object... arg)
	{
		if(packet == RequestExCreatePledge.class)
			return true;
		return super.canPassPacket(player, packet, arg);
	}
}