package l2s.gameserver.handler.admincommands.impl;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.dao.CharacterDAO;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.handler.admincommands.IAdminCommandHandler;
import l2s.gameserver.geodata.GeoEngine;
import l2s.gameserver.instancemanager.RankManager;
import l2s.gameserver.model.GameObject;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.actor.instances.player.AutoFarm;
import l2s.gameserver.model.actor.instances.player.AutoShortCuts;
import l2s.gameserver.model.actor.instances.player.ShortCut;
import l2s.gameserver.network.l2.c2s.EnterWorld;
import l2s.gameserver.network.l2.components.SystemMsg;
import org.napile.primitive.iterators.IntIterator;
import org.napile.primitive.sets.IntSet;

/**
 * @author Bonux
**/
public class AdminDebug implements IAdminCommandHandler
{
	private static enum Commands
	{
		admin_cansee,
		admin_saverank,
		admin_migraterank,
		admin_loadplayers,
		admin_unloadplayers,
	}

	@Override
	public boolean useAdminCommand(Enum<?> comm, String[] wordList, String fullString, Player activeChar)
	{
		Commands command = (Commands) comm;

		if(!activeChar.getPlayerAccess().CanEditNPC)
			return false;

		switch(command)
		{
			case admin_cansee:
				GameObject target = activeChar.getTarget();
				if(target != null)
				{
					boolean seeActiveChar = GeoEngine.canSeeTarget(activeChar, target);
					boolean seeTarget = GeoEngine.canSeeTarget(target, activeChar);
					activeChar.sendMessage("You" + (seeActiveChar ? "" : " DOES NOT") + " SEE TARGET, target" + (seeTarget ? "" : " DOES NOT") + " SEE YOU!");
				}
				else
					activeChar.sendPacket(SystemMsg.INVALID_TARGET);
				break;
			case admin_saverank: {
				RankManager.getInstance().refreshRankInfo();
				break;
			}
			case admin_migraterank: {
				RankManager.getInstance().migrate();
				break;
			}
			case admin_loadplayers: {
				ThreadPoolManager.getInstance().execute(() -> restoreCharacters(activeChar));
				break;
			}
			case admin_unloadplayers: {
				ThreadPoolManager.getInstance().execute(() -> unloadCharacters(activeChar));
				break;
			}
		}

		return true;
	}

	private void unloadCharacters(Player activeChar) {
		for (Player player : GameObjectsStorage.getPlayers(true, false)) {
			if (player.getObjectId() == activeChar.getObjectId()) {
				continue;
			}
			try {
				player.logout();
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private void restoreCharacters(Player activeChar) {
		IntSet ids = CharacterDAO.getInstance().getAllPlayersObjectIds();
		long total = ids.size();
		long done = 0;
		IntIterator iterator = ids.iterator();
		while (iterator.hasNext() && done < 50) {
			int charId = iterator.next();
			if (charId == activeChar.getObjectId()) {
				continue;
			}
			Player character = Player.restore(charId, true);
			if (character != null) {
				EnterWorld.onEnterWorld(character);
				AutoFarm autoFarm = character.getAutoFarm();
				if (autoFarm != null) {
					autoFarm.doAutoFarm();
//					System.out.println(character.getName() + " Started auto farm!");
				}
				AutoShortCuts autoShortCuts = character.getAutoShortCuts();
				if (autoShortCuts != null) {
					for (ShortCut shortCut : character.getAllShortCuts()) {
						if (shortCut.getType().equals(ShortCut.ShortCutType.SKILL)) {
							int skillId = shortCut.getId();
							Skill skill = SkillHolder.getInstance().getSkill(skillId, 1);
							if (skill == null) {
								continue;
							}
							if (skill.getAutoUseType().equals(Skill.SkillAutoUseType.ATTACK) || skill.getAutoUseType().equals(Skill.SkillAutoUseType.BUFF)) {
								shortCut.toggle();
							}
						}
						if (shortCut.isToggled()) {
							switch (shortCut.getType()) {
								case ITEM: {
									if (character.getInventory().getItemByObjectId(shortCut.getId()) == null) {
										continue;
									}
									break;
								} case SKILL: {
									if (character.getKnownSkill(shortCut.getId()) == null) {
										continue;
									}
									break;
								}
							}

							autoShortCuts.activate(shortCut.getSlot(), shortCut.getPage(), true, false);
						}
					}
				}

				if (done > 0 && (done % 50 == 0 || done == total)) {
					System.out.println("Loaded " + done + " phantoms.");
				}

				done++;

				if (done == total) {
					System.out.println("Loading finished.");
				}
			}
		}
	}

	@Override
	public Enum<?>[] getAdminCommandEnum()
	{
		return Commands.values();
	}
}