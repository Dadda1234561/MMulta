package l2s.gameserver.model.instances;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.lang.ArrayUtils;
import l2s.gameserver.Announcements;
import l2s.gameserver.Config;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.player.OnAnswerListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.entity.events.Event;
import l2s.gameserver.model.reward.RewardItem;
import l2s.gameserver.model.reward.RewardList;
import l2s.gameserver.network.l2.components.ChatType;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ConfirmDlgPacket;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.templates.npc.NpcTemplate;

import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

import static org.apache.commons.lang3.ArrayUtils.contains;

public class EventRaidBossInstance extends RaidBossInstance {

    private final AtomicBoolean _isKilled = new AtomicBoolean(false);

    public EventRaidBossInstance(int objectId, NpcTemplate template, MultiValueSet<String> set) {
        super(objectId, template, set);
    }

    @Override
    public double getDropChanceMod(Player player) {
        return 1.0d;
    }

    @Override
    public double getDropCountMod(Player player) {
        return 1.0d;
    }

    /**
     * Check if player can teleport to the boss spawn location
     * @param player
     * @return
     */
    private boolean isTeleportUnavailable(Player player) {

        // Check if player is offline
        if (player == null || !player.isOnline()) {
            return true;
        }

        // Check if player is holding a flag
        if (player.getActiveWeaponFlagAttachment() != null) {
            player.sendPacket(SystemMsg.YOU_CANNOT_TELEPORT_WHILE_IN_POSSESSION_OF_A_WARD);
            return true;
        }

        // Check if player is at oly match
        if (player.isInOlympiadMode()) {
            player.sendPacket(SystemMsg.THE_REQUEST_CANNOT_BE_MADE_BECAUSE_THE_REQUIREMENTS_HAVE_NOT_BEEN_MET);
            return true;
        }

        // Check if player is in observer mode
        if (player.isInObserverMode()) {
            player.sendPacket(new SystemMessagePacket(SystemMsg.THE_REQUEST_CANNOT_BE_MADE_BECAUSE_THE_REQUIREMENTS_HAVE_NOT_BEEN_MET));
            return true;
        }

        // Check if player is in event
        for (Event e : player.getEvents()) {
            if (!e.canUseTeleport(player)) {
                player.sendPacket(new SystemMessagePacket(SystemMsg.THE_REQUEST_CANNOT_BE_MADE_BECAUSE_THE_REQUIREMENTS_HAVE_NOT_BEEN_MET));
                return true;
            }
        }
        return false;
    }

    @Override
    protected void onReduceCurrentHp(double damage, Creature attacker, Skill skill, boolean awake, boolean standUp, boolean directHp, boolean isDot, boolean isStatic) {
        super.onReduceCurrentHp(damage, attacker, skill, awake, standUp, directHp, isDot, isStatic);
        boolean flagAttacker = getParameter("flagAttacker", false);
        if (!flagAttacker) {
            return;
        }
        // Check if attacker is a player
        if (attacker instanceof Player) {
            Player player = attacker.getPlayer();
            if (player.getPvpFlag() <= 0) {
                player.startPvPFlag(null);
                player.setLastPvPAttack(System.currentTimeMillis() - Config.PVP_TIME + 21000);
            }
        }
    }

    @Override
    protected void onSpawn() {
        super.onSpawn();

        _isKilled.set(true);

        // Announce the boss spawn
        Announcements.getInstance().announceByCustomMessage("EventRaidBoss.spawn.announce", new String[] {getName()}, ChatType.BATTLEFIELD);

        for (Player player : GameObjectsStorage.getAllPlayersForIterate()) {
            // Check if player is offline
            if (isTeleportUnavailable(player)) {
                continue;
            }

            player.ask(new ConfirmDlgPacket(SystemMsg.S1, 30000).addString(new CustomMessage("EventRaidBoss.spawn.askTeleport").toString(player)), new OnAnswerListener() {
                @Override
                public void sayYes() {
                    if (isTeleportUnavailable(player)) return;

                    // Teleport player to the boss spawn location
                    player.teleToLocation(Location.findAroundPosition(getSpawnedLoc(), 150, getGeoIndex()), getReflection());
                }

                @Override
                public void sayNo() {

                }
            });
        }
    }

    @Override
    protected void onDelete() {
        super.onDelete();
        if (_isKilled.get()) {
            return;
        }
        // Announce the boss despawn
        Announcements.getInstance().announceByCustomMessage("EventRaidBoss.despawn.announce", new String[] {getName()}, ChatType.BATTLEFIELD);
    }

    @Override
    protected void onDeath(Creature killer) {
        super.onDeath(killer);
        Player player = killer.getPlayer();
        if (player == null) {
            return;
        }
        _isKilled.set(true);
        // Announce last hit
        Announcements.getInstance().announceByCustomMessage("EventRaidBoss.lasthit.announce", new String[] {player.getName(), getName()}, ChatType.BATTLEFIELD);
        for(RewardList rewardList : getRewardLists())
            rollRewards(rewardList, player);
    }

    public void rollRewards(RewardList list, Creature lastAttacker)
    {
        final Player activePlayer = lastAttacker.getPlayer();
        if(activePlayer == null)
            return;

        List<RewardItem> rewardItems = list.roll(activePlayer, 1., this);
        for(RewardItem drop : rewardItems)
        {
            dropItem(activePlayer, drop.itemId, drop.count);
        }
    }
}
