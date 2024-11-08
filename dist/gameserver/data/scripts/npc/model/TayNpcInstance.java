package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage.ScreenMessageAlign;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.ReflectionUtils;

import instances.Sansililion;

/**
 * Для работы с инстами - SOA
 */
public final class TayNpcInstance extends NpcInstance
{
	private static final int soaSansilion = 171;
	private static final Location LOC_OUT = new Location(-178465, 153685, 2488);

	public TayNpcInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.equalsIgnoreCase("request_startWorld"))
		{
			Reflection r = player.getActiveReflection();
			if(r != null)
			{
				if(r instanceof Sansililion)
				{
					Sansililion sInst = (Sansililion) r;
					if(sInst.getStatus() == 0)
						sInst.startWorld();
				}
			}
		}
		else if(command.equalsIgnoreCase("request_exchange"))
		{
			Reflection r = player.getActiveReflection();
			if(r != null)
			{
				if(r instanceof Sansililion)
				{
					Sansililion sInst = (Sansililion) r;
					if(sInst.getStatus() == 2)
					{
						int amount = 0;
						int points = Sansililion._points;
						if(points > 1 && points < 800)
							amount = 10;
						else if(points < 1600)
							amount = 60;
						else if(points < 2000)
							amount = 160;
						else if(points < 2000)
							amount = 160;
						else if(points < 2400)
							amount = 200;
						else if(points < 2800)
							amount = 240;
						else if(points < 3200)
							amount = 280;
						else if(points < 3600)
							amount = 320;
						else if(points < 4000)
							amount = 360;
						else if(points > 4000)
							amount = 400;

						if(amount > 0)
							ItemFunctions.addItem(player, 17602, amount);

						player.teleToLocation(LOC_OUT, ReflectionManager.MAIN);
						sInst.collapse();
					}
				}
			}
		}
		else
			super.onBypassFeedback(player, command);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{
		if(val == 0)
		{
			String htmlpath = null;
			Reflection r = player.getActiveReflection();
			if(r != null)
			{
				if(r instanceof Sansililion)
				{
					Sansililion sInst = (Sansililion) r;
					if(sInst.getStatus() == 2)
						htmlpath = "default/33152-1.htm";
					else if(sInst.getStatus() == 1)
					{
						if(player.getAbnormalList().contains(14228))
						{
							player.sendPacket(new ExShowScreenMessage(NpcString.SOLDER_TIE_RECEIVED_S1_PRIECES_OF_BIO_ENERGY_RESIDUE, 2000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false, 1, -1, false, "40"));
							player.getAbnormalList().stop(14228);
							Sansililion._points += 40;
							sInst._lastBuff = 0;
						}
						else
						{
							if(player.getAbnormalList().contains(14229))
							{
								player.sendPacket(new ExShowScreenMessage(NpcString.SOLDER_TIE_RECEIVED_S1_PRIECES_OF_BIO_ENERGY_RESIDUE, 2000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false, 1, -1, false, "60"));							
								player.getAbnormalList().stop(14229);
								Sansililion._points += 60;
								sInst._lastBuff = 0;
							}
							else
							{
								if(player.getAbnormalList().contains(14230))
								{
									player.sendPacket(new ExShowScreenMessage(NpcString.SOLDER_TIE_RECEIVED_S1_PRIECES_OF_BIO_ENERGY_RESIDUE, 2000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false, 1, -1, false, "80"));
									player.getAbnormalList().stop(14230);
									Sansililion._points += 80;
									sInst._lastBuff = 0;
								}
							}
						}
					}
					else
						htmlpath = "default/33152-0.htm";
					if(htmlpath != null)
						player.sendPacket(new HtmlMessage(this, htmlpath).setPlayVoice(firstTalk));
				}
			}
			else
				super.showChatWindow(player, val, firstTalk, arg);
		}
		else
			super.showChatWindow(player, val, firstTalk, arg);
	}
}
