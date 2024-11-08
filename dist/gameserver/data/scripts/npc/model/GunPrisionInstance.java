package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.World;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.network.l2.s2c.EarthQuakePacket;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.MagicSkillUse;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.Functions;
import l2s.gameserver.utils.NpcUtils;

public final class GunPrisionInstance extends NpcInstance
{
	/**
	 * @author cruel
	 */
	 
	private boolean checkShot = true;
	
	private static Location[] point_bombs = { new Location(176856, 144152, -11875), new Location(176808, 141384, -11859), new Location(174264, 141208, -11874), new Location(174056, 144056, -11870) };
		
	private static Location[] point_bombs_spezion = { new Location(186056, 144152, -11851), new Location(186072, 141320, -11855), new Location(183720, 141256, -11859), new Location(183672, 143944, -11841) };
	
	public GunPrisionInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
		setTitle("Empty Cannon");
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.equalsIgnoreCase("zalp"))
		{
			if(!checkShot) 
			{
				Functions.npcSay(this, NpcString.CANNON_IS_LOADING);
				player.sendPacket(new HtmlMessage(this).setHtml("Cannon:<br><br>Preparations are underway to re-activate the cannon. This process can take up to 5 minutes."));
				return;
			}
			else if(!player.getInventory().destroyItemByItemId(17611, 1))
			{
				player.sendPacket(new HtmlMessage(this).setHtml("Cannon:<br><br>\"Huge Charges\" not available."));
				return;
			}

			broadcastPacketToOthers(new MagicSkillUse(this, this, 14175, 1, 3000, 0));
			broadcastPacket(new EarthQuakePacket(player.getLoc(), 10, 7));
			ThreadPoolManager.getInstance().schedule(new Shot(), 300 * 1000L);
			checkShot = false;
			ThreadPoolManager.getInstance().schedule(() ->
			{
				decayMe();
				spawnMe();
			}, 3100);
			setTitle("Cannon is loading");

			Location loc = point_bombs[getNpcId()-32939];
			
			for (NpcInstance monster : World.getAroundNpc(loc, getCurrentRegion(), getReflectionId(), 650, 500))
			{
				if (monster == null || !monster.isNpc() || monster.getNpcId() != 22966 && monster.getNpcId() != 22965 && monster.getNpcId() != 22967)
					continue;
			
				if (monster.getNpcId() == 22966)
					NpcUtils.spawnSingle(22980, monster.getLoc());
				else if (monster.getNpcId() == 22965)
					NpcUtils.spawnSingle(22979, monster.getLoc());
				else if (monster.getNpcId() == 22967)
					NpcUtils.spawnSingle(22981, monster.getLoc());
					
				monster.decayMe();
				monster.doDie(this);
			}	
		} else if (command.equalsIgnoreCase("spezion_bomb"))
		{
			if(!checkShot){
				Functions.npcSay(this, NpcString.CANNON_IS_LOADING);
				player.sendPacket(new HtmlMessage(this).setHtml("Cannon:<br><br>Preparations are underway to re-activate the cannon. This process can take up to 5 minutes."));
				return;
			}
			else if(!player.getInventory().destroyItemByItemId(17611, 1))
			{
				player.sendPacket(new HtmlMessage(this).setHtml("Cannon:<br><br>\"Huge Charges\" not available."));
				return;
			}
			
			checkShot = false;
			broadcastPacketToOthers(new MagicSkillUse(this, this, 14175, 1, 3000, 0));
			broadcastPacket(new EarthQuakePacket(player.getLoc(), 10, 7));
			ThreadPoolManager.getInstance().schedule(() ->
			{
				checkShot = true;
				setTitle("Empty Cannon");
			}, 60000);
			ThreadPoolManager.getInstance().schedule(() ->
			{
				decayMe();
				spawnMe();
			}, 3100);
			setTitle("Cannon is loading");
			
			Location loc = point_bombs_spezion[getNpcId()-33288];
			
			for (NpcInstance monster : World.getAroundNpc(loc, getCurrentRegion(), getReflectionId(), 700, 500))
			{
				if (monster == null || !monster.isNpc() || (monster.getNpcId() != 25779 && monster.getNpcId() != 25867))
					continue;
				monster.getAbnormalList().stop(14190);
				monster.setNpcState(2);
				ThreadPoolManager.getInstance().schedule(new Buff(monster), 60 * 1000L);
			}	
		}
		else
			super.onBypassFeedback(player, command);
	}
	
	private class Buff implements Runnable
	{
		private NpcInstance _monster;

		public Buff(NpcInstance monster)
		{
			_monster = monster;
		}
		@Override
		public void run()
		{
			Skill fp = SkillHolder.getInstance().getSkill(14190, 1);
			fp.getEffects(_monster, _monster);
			_monster.setNpcState(1);
		}
	}
	
	private class Shot implements Runnable
	{
		@Override
		public void run()
		{
			checkShot = true;
			setTitle("Empty Cannon");
			decayMe();
			spawnMe();
		}
	}

}