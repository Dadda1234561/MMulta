package npc.model;

import instances.AltarShilen;
import l2s.commons.collections.MultiValueSet;
import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.DoorInstance;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.network.l2.s2c.ExSendUIEventPacket;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.NpcUtils;
import l2s.gameserver.utils.ReflectionUtils;
import l2s.gameserver.geometry.Location;

/**
 * @author L2-scripts.com - (SanyaDC)
 */

public final class ControlPanelGigantsInstance extends NpcInstance
{
	int z;

	private static Zone zone1 = ReflectionUtils.getZone("[control_pannel_gigant1]");
	private static Zone zone2 = ReflectionUtils.getZone("[control_pannel_gigant2]");
	private static Zone zone3 = ReflectionUtils.getZone("[control_pannel_gigant3]");
	private static Zone zone4 = ReflectionUtils.getZone("[control_pannel_gigant4]");
	private static Zone zone5 = ReflectionUtils.getZone("[control_pannel_gigant5]");
	private static Zone zone6 = ReflectionUtils.getZone("[control_pannel_gigant6]");
	private static Zone zone7 = ReflectionUtils.getZone("[control_pannel_gigant7]");

	public ControlPanelGigantsInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}



	public int getZoneid() {
		return z;
	}

	public void setZoneid(int z) {
		this.z = z;
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{	ItemInstance i = player.getInventory().getItemByItemId(46757);
		if (command.startsWith("enterdevice") && player.isInZone(zone1)) {
			player.getInventory().destroyItem(i,1);
			setZoneid(1);
			ThreadPoolManager.getInstance().schedule(new BombScheduleTimerTask(this), 10000L);
			ReflectionUtils.getDoor(25190027).openMe(player, true);

		}
		else if (command.startsWith("enterdevice") && player.isInZone(zone2)) {
			player.getInventory().destroyItem(i,1);
			setZoneid(2);
			ThreadPoolManager.getInstance().schedule(new BombScheduleTimerTask(this), 10000L);
			ReflectionUtils.getDoor(25190026).openMe(player, true);

		}
		else if (command.startsWith("enterdevice") && player.isInZone(zone3)) {
			player.getInventory().destroyItem(i,1);
			setZoneid(3);
			ThreadPoolManager.getInstance().schedule(new BombScheduleTimerTask(this), 10000L);
			ReflectionUtils.getDoor(25190025).openMe(player, true);
		}
		else if (command.startsWith("enterdevice") && player.isInZone(zone4)) {
			player.getInventory().destroyItem(i,1);
			setZoneid(4);
			ThreadPoolManager.getInstance().schedule(new BombScheduleTimerTask(this), 10000L);
			ReflectionUtils.getDoor(25190024).openMe(player, true);
		}
		else if (command.startsWith("enterdevice") && player.isInZone(zone5)) {
			player.getInventory().destroyItem(i,1);
			setZoneid(5);
			ThreadPoolManager.getInstance().schedule(new BombScheduleTimerTask(this), 10000L);
			ReflectionUtils.getDoor(25190021).openMe(player, true);
		}
		else if (command.startsWith("enterdevice") && player.isInZone(zone6)) {
			player.getInventory().destroyItem(i,1);
			setZoneid(6);
			ThreadPoolManager.getInstance().schedule(new BombScheduleTimerTask(this), 10000L);
			ReflectionUtils.getDoor(25190022).openMe(player, true);
		}
		else if (command.startsWith("enterdevice") && player.isInZone(zone7)) {
			player.getInventory().destroyItem(i,1);
			setZoneid(7);
			ThreadPoolManager.getInstance().schedule(new BombScheduleTimerTask(this), 10000L);
			ReflectionUtils.getDoor(25190023).openMe(player, true);
		}

	}
	public class BombScheduleTimerTask implements Runnable
	{
		NpcInstance _npc = null;

		public BombScheduleTimerTask(NpcInstance npc)
		{
			_npc = npc;
		}

		@Override
		public void run()
		{
			if(getZoneid()==1){
				setZoneid(0);
				ReflectionUtils.getDoor(25190027).closeMe();
				if(Rnd.chance(96)) {
					getReflection().addSpawnWithoutRespawn(23730, new Location(186424, 60744, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23731, new Location(186008, 60728, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23732, new Location(186184, 61032, -7232, 0), 0);
				}
				else
					NpcUtils.spawnSingle(19636, new Location(186168,60920,-7232, 0), getReflection(), 40000);
			}
			if(getZoneid()==2){
				setZoneid(0);
				ReflectionUtils.getDoor(25190026).closeMe();
				if(Rnd.chance(96)) {
					getReflection().addSpawnWithoutRespawn(23730, new Location(185256, 60760, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23731, new Location(184872, 60744, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23732, new Location(185048, 61096, -7232, 0), 0);
				}
				else
					NpcUtils.spawnSingle(19636, new Location(185064,60984,-7232, 0), getReflection(), 40000);
			}
			if(getZoneid()==3){
				setZoneid(0);
				ReflectionUtils.getDoor(25190025).closeMe();
				if(Rnd.chance(96)) {
					getReflection().addSpawnWithoutRespawn(23730, new Location(184168, 60728, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23731, new Location(183688, 60712, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23732, new Location(184040, 61032, -7232, 0), 0);
				}
				else
				NpcUtils.spawnSingle(19636, new Location(183880,61000,-7232, 0), getReflection(), 40000);
			}
			if(getZoneid()==4){
				setZoneid(0);
				ReflectionUtils.getDoor(25190024).closeMe();
				if(Rnd.chance(96)) {
					getReflection().addSpawnWithoutRespawn(23730, new Location(182760, 60680, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23731, new Location(182376, 60696, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23732, new Location(182568, 61144, -7232, 0), 0);
				}
				else
					NpcUtils.spawnSingle(19636, new Location(182584,61032,-7232, 0), getReflection(), 40000);
			}
			if(getZoneid()==5){
				setZoneid(0);
				ReflectionUtils.getDoor(25190021).closeMe();
				if(Rnd.chance(96)) {
					getReflection().addSpawnWithoutRespawn(23730, new Location(183048, 59240, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23731, new Location(183496, 59240, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23732, new Location(183288, 58824, -7232, 0), 0);
				}
				else
					NpcUtils.spawnSingle(19636, new Location(183272,58984,-7232, 0), getReflection(), 40000);
			}
			if(getZoneid()==6){
				setZoneid(0);
				ReflectionUtils.getDoor(25190022).closeMe();
				if(Rnd.chance(96)) {
					getReflection().addSpawnWithoutRespawn(23730, new Location(184184, 59208, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23731, new Location(184632, 59224, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23732, new Location(184440, 58824, -7232, 0), 0);
				}
				else
					NpcUtils.spawnSingle(19636, new Location(184440,58984,-7232, 0), getReflection(), 40000);
			}
			if(getZoneid()==7){
				setZoneid(0);
				ReflectionUtils.getDoor(25190023).closeMe();
				if(Rnd.chance(96)) {
					getReflection().addSpawnWithoutRespawn(23730, new Location(185352, 59272, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23731, new Location(185720, 59256, -7232, 0), 0);
					getReflection().addSpawnWithoutRespawn(23732, new Location(185560, 58824, -7232, 0), 0);
				}
				else
					NpcUtils.spawnSingle(19636, new Location(185560,58936,-7232, 0), getReflection(), 40000);
			}

		}
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... replace)
	{
		ItemInstance i = player.getInventory().getItemByItemId(46757);
		HtmlMessage htmlMessage = new HtmlMessage(getObjectId()).setPlayVoice(firstTalk);
		if(player.getInventory().getItemByItemId(46757)==null)
		htmlMessage.setFile("default/34226-1.htm");
		else
			htmlMessage.setFile("default/34226.htm");

		player.sendPacket(htmlMessage);
	}
}