package instances;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.listener.actor.OnDeathListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExSendUIEventPacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;

/**
 * @author pchayka
 */

public class SufferingHallAttack extends Reflection
{
	private static final int AliveTumor = 18704;
	private static final int DeadTumor = 32531;
	private static final int Yehan = 25665;
	public int timeSpent;

	private long _savedTime = 0;
	private DeathListener _deathListener = new DeathListener();

	@Override
	protected void onCreate()
	{
		super.onCreate();
		_savedTime = System.currentTimeMillis();
		timeSpent = 0;
		spawnRoom(1);
	}

	private class DeathListener implements OnDeathListener
	{
		@Override
		public void onDeath(Creature self, Creature killer)
		{
			if(!self.isNpc())
				return;
			if(self.getNpcId() == AliveTumor)
			{
				if(self.isInZone("[soi_hos_attack_1]"))
				{
					addSpawnWithoutRespawn(DeadTumor, self.getLoc(), 0);
					self.deleteMe();
					getZone("[soi_hos_attack_defenceup_1]").setActive(false);
					getZone("[soi_hos_attack_attackup_1]").setActive(false);
					spawnRoom(2);
				}
				else if(self.isInZone("[soi_hos_attack_2]"))
				{
					addSpawnWithoutRespawn(DeadTumor, self.getLoc(), 0);
					self.deleteMe();
					getZone("[soi_hos_attack_defenceup_2]").setActive(false);
					getZone("[soi_hos_attack_attackup_2]").setActive(false);
					spawnRoom(3);
				}
				else if(self.isInZone("[soi_hos_attack_3]"))
				{
					addSpawnWithoutRespawn(DeadTumor, self.getLoc(), 0);
					self.deleteMe();
					getZone("[soi_hos_attack_defenceup_3]").setActive(false);
					getZone("[soi_hos_attack_attackup_3]").setActive(false);
					spawnRoom(4);
				}
				else if(self.isInZone("[soi_hos_attack_4]"))
				{
					addSpawnWithoutRespawn(DeadTumor, self.getLoc(), 0);
					self.deleteMe();
					getZone("[soi_hos_attack_defenceup_4]").setActive(false);
					getZone("[soi_hos_attack_attackup_4]").setActive(false);
					spawnRoom(5);
				}
				else if(self.isInZone("[soi_hos_attack_5]"))
				{
					addSpawnWithoutRespawn(DeadTumor, self.getLoc(), 0);
					self.deleteMe();
					getZone("[soi_hos_attack_defenceup_5]").setActive(false);
					getZone("[soi_hos_attack_attackup_5]").setActive(false);
					spawnRoom(6);
				}
			}
			else if(self.getNpcId() == Yehan)
			{
				ThreadPoolManager.getInstance().schedule(() ->
				{
					spawnRoom(7);
					setReenterTime(System.currentTimeMillis(), true);
					for(Player p : getPlayers())
					{
						p.sendPacket(new ExSendUIEventPacket(p, 1, 1, 0, 0));
					}
					startCollapseTimer(5, true);
					timeSpent = (int) (System.currentTimeMillis() - _savedTime) / 1000;
				}, 10000L);
			}
		}
	}

	private void invokeDeathListener()
	{
		for(NpcInstance npc : getNpcs())
			npc.addListener(_deathListener);
	}

	private void spawnRoom(int id)
	{
		switch(id)
		{
			case 1:
				spawnByGroup("soi_hos_attack_1");
				getZone("[soi_hos_attack_attackup_1]").setActive(true);
				getZone("[soi_hos_attack_defenceup_1]").setActive(true);
				break;
			case 2:
				spawnByGroup("soi_hos_attack_2");
				getZone("[soi_hos_attack_attackup_2]").setActive(true);
				getZone("[soi_hos_attack_defenceup_2]").setActive(true);
				break;
			case 3:
				spawnByGroup("soi_hos_attack_3");
				getZone("[soi_hos_attack_attackup_3]").setActive(true);
				getZone("[soi_hos_attack_defenceup_3]").setActive(true);
				break;
			case 4:
				spawnByGroup("soi_hos_attack_4");
				getZone("[soi_hos_attack_attackup_4]").setActive(true);
				getZone("[soi_hos_attack_defenceup_4]").setActive(true);
				break;
			case 5:
				spawnByGroup("soi_hos_attack_5");
				getZone("[soi_hos_attack_attackup_5]").setActive(true);
				getZone("[soi_hos_attack_defenceup_5]").setActive(true);
				break;
			case 6:
				spawnByGroup("soi_hos_attack_6");
				getZone("[soi_hos_attack_pcbuff_6]").setActive(true);
				break;
			case 7:
				spawnByGroup("soi_hos_attack_7");
				getZone("[soi_hos_attack_pcbuff_6]").setActive(false);
				break;
			default:
				break;
		}
		invokeDeathListener();
	}

	@Override
	public void onPlayerEnter(Player player)
	{
		super.onPlayerEnter(player);
		player.sendPacket(new ExSendUIEventPacket(player, 0, 1, (int) (System.currentTimeMillis() - _savedTime) / 1000, 0, NpcString.NONE));
	}

	@Override
	public void onPlayerExit(Player player)
	{
		super.onPlayerExit(player);
		player.sendPacket(new ExSendUIEventPacket(player, 1, 1, 0, 0));
	}


}