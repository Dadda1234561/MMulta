package npc.model;

import instances.RimPailaka;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.entity.residence.ResidenceType;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ReflectionUtils;

/**
 * @author pchayka
 */

public final class PailakaGatekeeperInstance extends NpcInstance
{
	private static final int rimIzId = 80;

	public PailakaGatekeeperInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.equalsIgnoreCase("rimentrance"))
		{
			Reflection r = player.getActiveReflection();
			if(r != null)
			{
				if(player.canReenterInstance(rimIzId))
					player.teleToLocation(r.getTeleportLoc(), r);
			}
			else if(player.canEnterInstance(rimIzId))
			{
				if(checkGroup(player))
				{
					ReflectionUtils.enterReflection(player, new RimPailaka(), rimIzId);
				}
				else
					//FIXME [G1ta0] кастом сообщение
					player.sendMessage("Failed to enter Rim Pailaka due to improper conditions");
			}
		}
		else
			super.onBypassFeedback(player, command);
	}

	private boolean checkGroup(Player p)
	{
		if(!p.isInParty())
			return false;
		for(Player member : p.getParty().getPartyMembers())
		{
			if(member.getClan() == null)
				return false;
			if(member.getClan().getResidenceId(ResidenceType.CASTLE) == 0 && member.getClan().getResidenceId(ResidenceType.FORTRESS) == 0)
				return false;
		}
		return true;
	}
}