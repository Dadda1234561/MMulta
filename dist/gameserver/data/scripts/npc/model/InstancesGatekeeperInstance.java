package npc.model;

import instances.*;
import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.InstantZoneHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.instancemanager.SoHManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.templates.InstantZone;
import l2s.gameserver.templates.InstantZoneEntryType;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ReflectionUtils;

public class InstancesGatekeeperInstance extends NpcInstance
{
	private static final int HELIOS_INSTANCE_ID = 2023;
	private static final int OCTAVIS_INSTANCE_ID = 2022;
	private static final int BAYLOR_INSTANCE_ID = 2021;
	private static final int FAFURION_INSTANCE_ID = 2020;
	private static final int LINDVIOR_INSTANCE_ID = 2019;
	private static final int ICE_GOLEM_INSTANCE_ID = 2018;
	private static final int NAME4_INSTANCE_ID = 2017;
	private static final int NAME3_INSTANCE_ID = 2016;
	private static final int NAME2_INSTANCE_ID = 2015;
	private static final int NAME1_INSTANCE_ID = 2014;
	private static final int NAME_INSTANCE_ID = 2013;
	private static final int VALAKAS_INSTANCE_ID = 2012;
	private static final int ANTHARAS_INSTANCE_ID = 2011;
	private static final int BAIUM_INSTANCE_ID = 2010;
	private static final int AQ_INSTANCE_ID = 2009;
	private static final int ORFEN_INSTANCE_ID = 2008;
	private static final int CORE_INSTANCE_ID = 2007;

	private static final int OVERTHROW_1 = 2024;
	private static final int OVERTHROW_2 = 2025;
	private static final int OVERTHROW_3 = 2026;
	private static final int OVERTHROW_4 = 2027;
	private static final int OVERTHROW_5 = 2028;
	private static final int OVERTHROW_6 = 2029;
	private static final int OVERTHROW_7 = 2030;
	private static final int OVERTHROW_8 = 2031;
	private static final int OVERTHROW_9 = 2032;
	private static final int OVERTHROW_idinaxui = 2033;
	private static final int DARK_REALM = 2034;
	private static final int STUDENT_AEGIS = 2035;

	private static final int ZAKEN_INSTANCE_ID = 2003;
	private static final int FREYA_INSTANCE_ID = 2000;
	private static final int FRINTEZZA_INSTANCE_ID = 2002;
	private static final int BLESS_FREYA_INSTANCE_ID = 2001;
	private static final int LILIT_INSTANCE_ID = 2006;
	private static final int ANAKIM_INSTANCE_ID = 2005;
	private static final int TIAT_INSTANCE_ID = 2004;
	private static final int ISTHINA_INSTANCE_ID = 170;
	private static final int WALLOCK_INSTANCE_ID = 167;
	private static final int TAIDJAN_INSTANCE_ID = 160;

	private static final int frintezzaIzId = 287;
	private static final int BaylorInstance = 166;
	private static final int hardOctavisInstId = 303;
	private static final int AntarInstance = 304;
	private static final int TAUTI_EXTREME_INSTANCE_ID = 219;
	private static final int Eternal = 258;
	private static final int Camp = 260;
	private static final int KASTIA_100 = 298;
	private static final int KASTIA_105 = 299;
	private static final int KASTIA_110 = 300;
	private static final int KASTIA_115 = 305;
	private static final int KASTIA_120 = 306;

	private static final int C_KAMALOKA_1 = 63;
	private static final int C_KAMALOKA_2 = 64;
	private static final int C_KAMALOKA_3 = 75;

	private static final int B_KAMALOKA_1 = 66;
	private static final int B_KAMALOKA_2 = 67;
	private static final int B_KAMALOKA_3 = 76;

	private static final int A_KAMALOKA_1 = 69;
	private static final int A_KAMALOKA_2 = 70;
	private static final int A_KAMALOKA_3 = 77;

	private static final int S_KAMALOKA_1 = 72;
	private static final int S_KAMALOKA_2 = 78;
	private static final int S_KAMALOKA_3 = 134;
	private static final Location TAUTI_ROOM_TELEPORT = new Location(-147262, 211318, -10040);

	public InstancesGatekeeperInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	public void onBypassFeedback(Player player, String command)
	{
		Reflection reflection = player.getReflection();

		if(command.startsWith("request_AshenShadow"))
		{
			Reflection r = player.getActiveReflection();
			if(r != null)
			{
				if(player.canReenterInstance(Camp))
				{
					player.teleToLocation(r.getTeleportLoc(), r);
				}
			}
			else if(player.canEnterInstance(Camp))
			{
				ReflectionUtils.enterReflection(player, new AshenShadowCamp(), Camp);
			}
		}
		else if(command.startsWith("request_start"))
		{
			final AshenShadowCamp ashen = (AshenShadowCamp) reflection;
			ashen.Start(player);
		}
		else if(command.startsWith("request_leave"))
		{
			player.teleToLocation(-14072, 122984, -3120, ReflectionManager.MAIN);
		}
		else if (command.startsWith("request_C_KAMALOKA_1"))
		{
			if (player.getRebirthCount() >= 3) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(C_KAMALOKA_1)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(C_KAMALOKA_1)) {
					ReflectionUtils.enterReflection(player, new C_KAMALOKA_1(), C_KAMALOKA_1);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_C_KAMALOKA_2"))
		{
			if (player.getRebirthCount() >= 3) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(C_KAMALOKA_2)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(C_KAMALOKA_2)) {
					ReflectionUtils.enterReflection(player, new C_KAMALOKA_2(), C_KAMALOKA_2);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_C_KAMALOKA_3"))
		{
			if (player.getRebirthCount() >= 3) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(C_KAMALOKA_3)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(C_KAMALOKA_3)) {
					ReflectionUtils.enterReflection(player, new C_KAMALOKA_3(), C_KAMALOKA_3);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_B_KAMALOKA_1"))
		{
			if (player.getRebirthCount() >= 10) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(B_KAMALOKA_1)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(B_KAMALOKA_1)) {
					ReflectionUtils.enterReflection(player, new B_KAMALOKA_1(), B_KAMALOKA_1);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_B_KAMALOKA_2"))
		{
			if (player.getRebirthCount() >= 10) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(B_KAMALOKA_2)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(B_KAMALOKA_2)) {
					ReflectionUtils.enterReflection(player, new B_KAMALOKA_2(), B_KAMALOKA_2);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_B_KAMALOKA_3"))
		{
			if (player.getRebirthCount() >= 10) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(B_KAMALOKA_3)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(B_KAMALOKA_3)) {
					ReflectionUtils.enterReflection(player, new B_KAMALOKA_3(), B_KAMALOKA_3);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_A_KAMALOKA_1"))
		{
			if (player.getRebirthCount() >= 20) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(A_KAMALOKA_1)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(A_KAMALOKA_1)) {
					ReflectionUtils.enterReflection(player, new A_KAMALOKA_1(), A_KAMALOKA_1);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_A_KAMALOKA_2"))
		{
			if (player.getRebirthCount() >= 20) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(A_KAMALOKA_2)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(A_KAMALOKA_2)) {
					ReflectionUtils.enterReflection(player, new A_KAMALOKA_2(), A_KAMALOKA_2);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_A_KAMALOKA_3"))
		{
			if (player.getRebirthCount() >= 20) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(A_KAMALOKA_3)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(A_KAMALOKA_3)) {
					ReflectionUtils.enterReflection(player, new A_KAMALOKA_3(), A_KAMALOKA_3);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_S_KAMALOKA_1"))
		{
			if (player.getRebirthCount() >= 30) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(S_KAMALOKA_1)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(S_KAMALOKA_1)) {
					ReflectionUtils.enterReflection(player, new S_KAMALOKA_1(), S_KAMALOKA_1);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_S_KAMALOKA_2"))
		{
			if (player.getRebirthCount() >= 30) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(S_KAMALOKA_2)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(S_KAMALOKA_2)) {
					ReflectionUtils.enterReflection(player, new S_KAMALOKA_2(), S_KAMALOKA_2);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_S_KAMALOKA_3"))
		{
			if (player.getRebirthCount() >= 30) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(S_KAMALOKA_3)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(S_KAMALOKA_3)) {
					ReflectionUtils.enterReflection(player, new S_KAMALOKA_3(), S_KAMALOKA_3);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_NightmareKamaloka"))
		{
			Reflection r = player.getActiveReflection();
			if (r != null)
			{
				if (player.canReenterInstance(Eternal))
				{
					player.teleToLocation(r.getTeleportLoc(), r);
				}
			}
			else if (player.canEnterInstance(Eternal))
			{
				ReflectionUtils.enterReflection(player, new EternalRefuge(), Eternal);
			}
			else
			{
				showChatWindow(player, "default/30870-1.htm", false);
			}
		}
		else if (command.startsWith("request_Zaken"))
		{
			if (player.getRebirthCount() >= 10) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(ZAKEN_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(ZAKEN_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new ZakenReborn(), ZAKEN_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_overthrow_1"))
		{
			if (player.getRebirthCount() >= 20) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(OVERTHROW_1)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(OVERTHROW_1)) {
					ReflectionUtils.enterReflection(player, new NeedName(), OVERTHROW_1);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_overthrow_2"))
		{
			if (player.getRebirthCount() >= 40) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(OVERTHROW_2)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(OVERTHROW_2)) {
					ReflectionUtils.enterReflection(player, new NeedName(), OVERTHROW_2);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_overthrow_3"))
		{
			if (player.getRebirthCount() >= 60) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(OVERTHROW_3)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(OVERTHROW_3)) {
					ReflectionUtils.enterReflection(player, new NeedName(), OVERTHROW_3);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_overthrow_4"))
		{
			if (player.getRebirthCount() >= 80) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(OVERTHROW_4)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(OVERTHROW_4)) {
					ReflectionUtils.enterReflection(player, new NeedName(), OVERTHROW_4);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_overthrow_5"))
		{
			if (player.getRebirthCount() >= 100) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(OVERTHROW_5)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(OVERTHROW_5)) {
					ReflectionUtils.enterReflection(player, new NeedName(), OVERTHROW_5);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_overthrow_6"))
		{
			if (player.getRebirthCount() >= 120) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(OVERTHROW_6)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(OVERTHROW_6)) {
					ReflectionUtils.enterReflection(player, new NeedName(), OVERTHROW_6);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_overthrow_7"))
		{
			if (player.getRebirthCount() >= 140) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(OVERTHROW_7)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(OVERTHROW_7)) {
					ReflectionUtils.enterReflection(player, new NeedName(), OVERTHROW_7);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_overthrow_8"))
		{
			if (player.getRebirthCount() >= 160) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(OVERTHROW_8)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(OVERTHROW_8)) {
					ReflectionUtils.enterReflection(player, new NeedName(), OVERTHROW_8);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_overthrow_9"))
		{
			if (player.getRebirthCount() >= 180) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(OVERTHROW_9)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(OVERTHROW_9)) {
					ReflectionUtils.enterReflection(player, new NeedName(), OVERTHROW_9);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_overthrow_idinaxui"))
		{
			if (player.getRebirthCount() >= 200) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(OVERTHROW_idinaxui)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(OVERTHROW_idinaxui)) {
					ReflectionUtils.enterReflection(player, new NeedName(), OVERTHROW_idinaxui);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Name"))
		{
			if (player.getRebirthCount() >= 5) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(NAME_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(NAME_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new NeedName(), NAME_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_2Name"))
		{
			if (player.getRebirthCount() >= 10) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(NAME1_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(NAME1_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new NeedName1(), NAME1_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_3Name"))
		{
			if (player.getRebirthCount() >= 15) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(NAME2_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(NAME2_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new NeedName2(), NAME2_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_4Name"))
		{
			if (player.getRebirthCount() >= 15) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(NAME3_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(NAME3_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new NeedName3(), NAME3_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_5Name"))
		{
			if (player.getRebirthCount() >= 20) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(NAME4_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(NAME4_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new NeedName4(), NAME4_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Core"))
		{
			if (player.getRebirthCount() >= 50) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(CORE_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(CORE_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new CoreReborn(), CORE_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Orfen"))
		{
			if (player.getRebirthCount() >= 60) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(ORFEN_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(ORFEN_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new OrfenReborn(), ORFEN_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_AntQueen"))
		{
			if (player.getRebirthCount() >= 70) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(AQ_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(AQ_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new AntQueenReborn(), AQ_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Baium"))
		{
			if (player.getRebirthCount() >= 80) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(BAIUM_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(BAIUM_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new BaiumReborn(), BAIUM_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Antharas"))
		{
			if (player.getRebirthCount() >= 90) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(ANTHARAS_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(ANTHARAS_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new AntharasReborn(), ANTHARAS_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Valakas"))
		{
			if (player.getRebirthCount() >= 100) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(VALAKAS_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(VALAKAS_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new ValakasReborn(), VALAKAS_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}

		else if (command.startsWith("request_Freya"))
		{
			if (player.getRebirthCount() >= 20)
			{
				Reflection r = player.getActiveReflection();
				if (r != null)
				{
					if (player.canReenterInstance(FREYA_INSTANCE_ID))
					{
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				}
				else if (player.canEnterInstance(FREYA_INSTANCE_ID))
				{
					ReflectionUtils.enterReflection(player, new NormalFreyaReborn(), FREYA_INSTANCE_ID);
				}
				else
				{
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Frintezza_Reborn"))
		{
			if (player.getRebirthCount() >= 50) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(FRINTEZZA_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(FRINTEZZA_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new FrintezzaReborn(), FRINTEZZA_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_ice_golem_Reborn"))
		{
			if (player.getRebirthCount() >= 70) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(ICE_GOLEM_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(ICE_GOLEM_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new IceGolem(), ICE_GOLEM_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Bless_Freya"))
		{
			if (player.getRebirthCount() >= 30) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(BLESS_FREYA_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(BLESS_FREYA_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new BlessFreyaReborn(), BLESS_FREYA_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Lilit"))
		{
			if (player.getRebirthCount() >= 25) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(LILIT_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(LILIT_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new LilitReborn(), LILIT_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Anakim"))
		{
			if (player.getRebirthCount() >= 30) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(ANAKIM_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(ANAKIM_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new AnakimReborn(), ANAKIM_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Tiat"))
		{
			if (player.getRebirthCount() >= 100) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(TIAT_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(TIAT_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new TiadReborn(), TIAT_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Isthina"))
		{
			if (player.getRebirthCount() >= 80) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(ISTHINA_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(ISTHINA_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new Isthina(), ISTHINA_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Wallock"))
		{
			if (player.getRebirthCount() >= 90) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(WALLOCK_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(WALLOCK_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new Balok(), WALLOCK_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if (command.startsWith("request_Trajan"))
		{
			if (player.getRebirthCount() >= 100) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(TAIDJAN_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(TAIDJAN_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new Teredor(), TAIDJAN_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if(command.startsWith("request_Baylor"))
		{
			if (player.getRebirthCount() >= 160) {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(BaylorInstance)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(BaylorInstance)) {
					ReflectionUtils.enterReflection(player, new Baylor(), BaylorInstance);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if(command.startsWith("request_tauti_extreme_battle"))
		{
			if (player.getRebirthCount() >= 50)
			{
				/*if (SoHManager.getCurrentStage() != 2 && !Config.ENABLE_TAUTI_FREE_ENTRANCE)
				{
					showChatWindow(player, "tauti_keeper/sofa_aku002h.htm", false);
					return;
				}*/

				InstantZone iz = InstantZoneHolder.getInstance().getInstantZone(TAUTI_EXTREME_INSTANCE_ID);
				if (iz == null) {
					showChatWindow(player, "Error! Write to administator.", false);
					return;
				}

				Reflection r = player.getActiveReflection();
				if (r != null)
				{
					if (player.canReenterInstance(TAUTI_EXTREME_INSTANCE_ID))
						showChatWindow(player, "tauti_keeper/sofa_aku002g.htm", false);
				}
				else if (player.canEnterInstance(TAUTI_EXTREME_INSTANCE_ID))
				{
					ReflectionUtils.enterReflection(player, new Tauti(), TAUTI_EXTREME_INSTANCE_ID);
					showChatWindow(player, "tauti_keeper/sofa_aku002a.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if(command.startsWith("reenter_tauti_extreme_battle"))
		{
			if (player.getRebirthCount() >= 50)
			{
				Reflection r = player.getActiveReflection();
				if (r != null)
				{
					if (player.canReenterInstance(TAUTI_EXTREME_INSTANCE_ID))
					{
						if (r.getInstancedZoneId() == TAUTI_EXTREME_INSTANCE_ID) {
							if (((Tauti) r).getInstanceStage() == 2) {
								player.teleToLocation(TAUTI_ROOM_TELEPORT, reflection);
							}
						}
						else
							player.teleToLocation(reflection.getTeleportLoc(), reflection);


						showChatWindow(player, "tauti_keeper/sofa_aku002f.htm", false);
					}
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if(command.equalsIgnoreCase("request_hardoctavis"))
		{
			if (player.getRebirthCount() >= 70)
			{
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(hardOctavisInstId)) {
						player.teleToLocation(208404, 120572, -10014, r);
					}
				}
				else if (player.canEnterInstance(hardOctavisInstId)) {
					ReflectionUtils.enterReflection(player, new Octavis(), hardOctavisInstId);
				}
				else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
			else
			{
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		}
		else if(command.equalsIgnoreCase("request_frintezza"))
		{
			Reflection r = player.getActiveReflection();
			if(r != null)
			{
				if(player.canReenterInstance(frintezzaIzId))
					player.teleToLocation(r.getTeleportLoc(), r);
			}
			else if(player.canEnterInstance(frintezzaIzId))
			{
				ReflectionUtils.enterReflection(player, new Frintezza(), frintezzaIzId);
			}
		}
		else if(command.startsWith("request_balthus"))
		{
			Reflection r = player.getActiveReflection();
			if(r != null)
			{
				if(player.canReenterInstance(AntarInstance))
				{
					player.teleToLocation(r.getTeleportLoc(), r);
				}
			}
			else if(player.canEnterInstance(AntarInstance))
			{
				ReflectionUtils.enterReflection(player, new BaltusKnight(), AntarInstance);
			}
		}
		else if (command.startsWith("request_kastia100"))
		{
			Reflection r = player.getActiveReflection();
			if(r != null)
			{
				if(player.canReenterInstance(KASTIA_100))
				{
					player.teleToLocation(r.getTeleportLoc(), r);
				}
			}
			else if(player.canEnterInstance(KASTIA_120) //
					&& player.canEnterInstance(KASTIA_115) //
					&& player.canEnterInstance(KASTIA_110) //
					&& player.canEnterInstance(KASTIA_105) //
					&& player.canEnterInstance(KASTIA_100))
			{
				ReflectionUtils.enterReflection(player, new Kastia(), KASTIA_100);
			}
		}
		else if (command.startsWith("request_kastia105"))
		{
			Reflection r = player.getActiveReflection();
			if(r != null)
			{
				if(player.canReenterInstance(KASTIA_105))
				{
					player.teleToLocation(r.getTeleportLoc(), r);
				}
			}
			else if(player.canEnterInstance(KASTIA_120) //
					&& player.canEnterInstance(KASTIA_115) //
					&& player.canEnterInstance(KASTIA_110) //
					&& player.canEnterInstance(KASTIA_105) //
					&& player.canEnterInstance(KASTIA_100))
			{
				ReflectionUtils.enterReflection(player, new Kastia(), KASTIA_105);
			}
		}
		else if (command.startsWith("request_kastia110"))
		{
			Reflection r = player.getActiveReflection();
			if(r != null)
			{
				if(player.canReenterInstance(KASTIA_110))
				{
					player.teleToLocation(r.getTeleportLoc(), r);
				}
			}
			else if(player.canEnterInstance(KASTIA_120) //
					&& player.canEnterInstance(KASTIA_115) //
					&& player.canEnterInstance(KASTIA_110) //
					&& player.canEnterInstance(KASTIA_105) //
					&& player.canEnterInstance(KASTIA_100))
			{
				ReflectionUtils.enterReflection(player, new Kastia(), KASTIA_110);
			}
		}
		else if (command.startsWith("request_kastia115"))
		{
			Reflection r = player.getActiveReflection();
			if(r != null)
			{
				if(player.canReenterInstance(KASTIA_115))
				{
					player.teleToLocation(r.getTeleportLoc(), r);
				}
			}
			else if(player.canEnterInstance(KASTIA_120) //
					&& player.canEnterInstance(KASTIA_115) //
					&& player.canEnterInstance(KASTIA_110) //
					&& player.canEnterInstance(KASTIA_105) //
					&& player.canEnterInstance(KASTIA_100))
			{
				ReflectionUtils.enterReflection(player, new Kastia(), KASTIA_115);
			}
		}
		else if (command.startsWith("request_kastia120"))
		{
			Reflection r = player.getActiveReflection();
			if(r != null)
			{
				if(player.canReenterInstance(KASTIA_120))
				{
					player.teleToLocation(r.getTeleportLoc(), r);
				}
			}
			else if(player.canEnterInstance(KASTIA_120) //
					&& player.canEnterInstance(KASTIA_115) //
					&& player.canEnterInstance(KASTIA_110) //
					&& player.canEnterInstance(KASTIA_105) //
					&& player.canEnterInstance(KASTIA_100))
			{
				ReflectionUtils.enterReflection(player, new Kastia(), KASTIA_120);
			}
		}
		else if (command.startsWith("request_Lindvior")) {
			if (player.getRebirthCount() < 120) {
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			} else {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(LINDVIOR_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(LINDVIOR_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new AntharasReborn(), LINDVIOR_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
		} else if (command.startsWith("request_Fafurion")) {
			if (player.getRebirthCount() < 140) {
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			} else {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(FAFURION_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(FAFURION_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new AntharasReborn(), FAFURION_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
		} else if (command.startsWith("request_Baylor")) {
			if (player.getRebirthCount() < 160) {
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			} else {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(BAYLOR_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(BAYLOR_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new AntharasReborn(), BAYLOR_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
		} else if (command.startsWith("request_Octavis")) {
			if (player.getRebirthCount() < 180) {
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			} else {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(OCTAVIS_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(OCTAVIS_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new AntharasReborn(), OCTAVIS_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
		} else if (command.startsWith("request_Helios")) {
			if (player.getRebirthCount() < 200) {
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			} else {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(HELIOS_INSTANCE_ID)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(HELIOS_INSTANCE_ID)) {
					ReflectionUtils.enterReflection(player, new AntharasReborn(), HELIOS_INSTANCE_ID);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
		} else if (command.startsWith("request_Dark_Realm")) {
			if (player.getRebirthCount() < 230) {
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			} else {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(DARK_REALM)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(DARK_REALM)) {
					ReflectionUtils.enterReflection(player, new AntharasReborn(), DARK_REALM);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
		} else if (command.startsWith("request_Student_Aegis")) {
			if (player.getRebirthCount() < 270) {
				player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			} else {
				Reflection r = player.getActiveReflection();
				if (r != null) {
					if (player.canReenterInstance(STUDENT_AEGIS)) {
						player.teleToLocation(r.getTeleportLoc(), r);
					}
				} else if (player.canEnterInstance(STUDENT_AEGIS)) {
					ReflectionUtils.enterReflection(player, new AntharasReborn(), STUDENT_AEGIS);
				} else {
					showChatWindow(player, "default/30870-1.htm", false);
				}
			}
		}
		else
			super.onBypassFeedback(player, command);
	}
}
