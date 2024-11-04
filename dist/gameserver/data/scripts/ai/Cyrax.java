package ai;



import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.*;
import l2s.gameserver.model.instances.NpcInstance;

public class Cyrax extends Fighter
{
	// NPC
	private static final int CYRAX = 29374;
	// Item
	private static final int FONDUS_STONE = 80322;

	public Cyrax(NpcInstance actor)
	{
		super(actor);

	}

	@Override
	protected void onEvtDead(Creature killer)
	{
		//NpcInstance actor = getActor();
		Party party = killer.getPlayer().getParty();
		if(killer.getPlayer().getParty()!=null && party.getCommandChannel() == null){
			killer.getPlayer().getParty().getPartyLeader().getInventory().addItem(80322,1);
			//actor.dropItem(killer.getPlayer().getParty().getPartyLeader(),80322,1);
		}
		else if(killer.getPlayer().getParty()!=null && party.getCommandChannel() != null) {
			//actor.dropItem(killer.getPlayer().getParty().getCommandChannel().getChannelLeader(),80322,1);
			killer.getPlayer().getParty().getCommandChannel().getChannelLeader().getInventory().addItem(80322, 1);
		}
		else {
			killer.getPlayer().getInventory().addItem(80322, 1);
			//actor.dropItem(killer.getPlayer(),80322,1);
		}



		super.onEvtDead(killer);
	}
}
