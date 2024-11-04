package npc.model;

import java.util.StringTokenizer;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.model.entity.olympiad.Olympiad;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExResponseBeautyListPacket;
import l2s.gameserver.network.l2.s2c.ExResponseResetListPacket;
import l2s.gameserver.network.l2.s2c.ExShowBeautyMenuPacket;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author Bonux
 */
public class BeautyShopInstance extends NpcInstance
{
	public BeautyShopInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public String getHtmlFilename(int val, Player player)
	{
		String filename;
		if(val == 0)
			filename = "beauty_lavianrose001.htm";
		else
			filename = "beauty_lavianrose00" + (val - 1) + ".htm";
		return filename;
	}

	@Override
	public void onMenuSelect(Player player, int ask, long reply, int state) {
		if (ask == -81588) {
			if (reply == 1) {   // Воспользоваться салоном
				showChatWindow(player, "default/beauty_lavianrose002.htm", false);
			} else if (reply == 2) {    // Помощь
				showChatWindow(player, "default/beauty_lavianrose004.htm", false);
			} else if (reply == 3) {    // Восстановить внешность
				showChatWindow(player, "default/beauty_lavianrose005.htm", false);
			} else if (reply == 4 || reply == 5) {    // Войти в салон
				if(Olympiad.isRegisteredInComp(player))
				{
					player.sendPacket(SystemMsg.YOU_CANNOT_USE_THE_BEAUTY_SHOP_WHILE_REGISTERED_IN_THE_OLYMPIAD);
					return;
				}

				if(player.isRegisteredInChaosFestival())
				{
					player.sendPacket(SystemMsg.YOU_CANNOT_USE_THE_BEAUTY_SHOP_WHILE_REGISTERED_IN_THE_CEREMONY_OF_CHAOS);
					return;
				}

				if(reply == 4)  // Изменить
				{
					if(player.getLevel() >= 76 && player.getClassLevel().ordinal() >= ClassLevel.THIRD.ordinal()) {
						player.block();
						player.sendPacket(new ExShowBeautyMenuPacket(player, ExShowBeautyMenuPacket.CHANGE_STYLE));
						player.sendPacket(new ExResponseBeautyListPacket(player, ExResponseBeautyListPacket.HAIR_LIST));
					} else
						showChatWindow(player, "default/beauty_lavianrose003.htm", false);
				}
				else if(reply == 5) // Отменить
				{
					if(player.getBeautyHairStyle() > 0 || player.getBeautyFace() > 0)
					{
						player.block();
						player.sendPacket(new ExShowBeautyMenuPacket(player, ExShowBeautyMenuPacket.RESTORE_STYLE));
						player.sendPacket(new ExResponseResetListPacket(player));
					} else
						showChatWindow(player, "default/beauty_lavianrose006.htm", false);
				}
			} else if (reply == 6) {    // Отмена
				//
			}
		} else
			super.onMenuSelect(player, ask, reply, state);
	}
}
