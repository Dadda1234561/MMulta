package l2s.gameserver.model.entity.events.impl.fightclub;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.util.Rnd;
import l2s.gameserver.Announcements;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Servitor;
import l2s.gameserver.model.base.RestartType;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubPlayer;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubTeam;
import l2s.gameserver.model.entity.events.fightclubmanager.enums.CatTransformType;
import l2s.gameserver.model.entity.events.fightclubmanager.enums.EventState;
import l2s.gameserver.model.entity.events.fightclubmanager.enums.MessageType;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.network.l2.s2c.SayPacket2;
import l2s.gameserver.skills.AbnormalEffect;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author sharp https://t.me/sharp1que
 */
public class CatRoyalEvent extends TeamVSTeamEvent {

    private static final int MAX_KILLS = 300; // скіки-скіки ?
    private final AtomicInteger _killsDone = new AtomicInteger(0);
    private final AtomicInteger _minutesLeft = new AtomicInteger(5);
    private final AtomicInteger _secondsLeft = new AtomicInteger(10);
    private final Map<Integer, CatTransformType> _playerTransforms = new ConcurrentHashMap<>();
    private final List<ScheduledFuture<?>> _tasks = new ArrayList<>();


    private ScheduledFuture<?> _regAnnounceTask = null;
    private ScheduledFuture<?> _tpAnnounceTask = null;
    private long _startTime = 0;
    private boolean _isLoaded = false;

    public CatRoyalEvent(MultiValueSet<String> set) {
        super(set);
    }

    @Override
    protected void teleportRegisteredPlayers() {
        super.teleportRegisteredPlayers();
        for (FightClubPlayer fPlayer : getPlayers(FIGHTING_PLAYERS)) {
            Player player = fPlayer.getPlayer();
            if (player != null) {
                // get random transformation
                CatTransformType transform = Rnd.get(CatTransformType.values());
                // save given transformation
                if (transform != null) {
                    _playerTransforms.put(player.getObjectId(), transform);
                    player.setTransform(transform.getTransformId());
                }

                // Daily event handler
                player.getListeners().onParticipateInEvent("CatRoyal", false);
            }
        }
    }

    @Override
    public void onKilled(Creature actor, Creature victim) {
        super.onKilled(actor, victim);
        Player victimPlayer = victim.getPlayer();
        if (victimPlayer != null && victim.isDead() && getRespawnTime() > 0) {
            requestRespawn(victimPlayer, RestartType.TO_FLAG);
        }
        if ((!EventState.NOT_ACTIVE.equals(getState()) && _killsDone.incrementAndGet() >= MAX_KILLS)) {
            stopEvent(true);
        }
    }

    @Override
    public void stopEvent(boolean force) {

        for (FightClubPlayer fPlayer : getPlayers(FIGHTING_PLAYERS)) {
            Player player = fPlayer.getPlayer();
            if (player != null) {
                player.setTransform(0);
                String teamName = getTeamName(fPlayer.getTeam());
                AbnormalEffect effect = Objects.equals(teamName, "Мурлыкающие Мстители") ? AbnormalEffect.RED_TEAM : AbnormalEffect.BLUE_TEAM;
                player.stopAbnormalEffect(effect);
            }
        }

        initVariables();
        super.stopEvent(force);

        Announcements.announceToAll(String.format("\"%s\": Ивент - закончен!", getName()));
    }


    @Override
    protected void announceWinnerTeam(boolean wholeEvent, FightClubTeam winnerOfTheRound) {
        int bestScore = -1;
        FightClubTeam bestTeam = null;
        boolean draw = false;
        if (wholeEvent) {
            for (FightClubTeam team : getTeams()) {
                if (team.getScore() > bestScore) {
                    draw = false;
                    bestScore = team.getScore();
                    bestTeam = team;
                } else if (team.getScore() == bestScore) {
                    draw = true;
                }
            }
        } else {
            bestTeam = winnerOfTheRound;
        }

        SayPacket2 packet;
        if (!draw)
        {
            final CustomMessage message = new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.catroyale.teamWin").addString(getName()).addString(getTeamName(bestTeam));
            for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
            {
                sendMessageToPlayer(iFPlayer, MessageType.NORMAL_MESSAGE, message);
            }
        }
        updateScreenScores();
    }

    @Override
    public void announceTopKillers(FightClubPlayer[] topKillers) {
        if (topKillers == null)
        {
            return;
        }

        for (FightClubPlayer fPlayer : topKillers)
        {
            if (fPlayer != null)
            {
                CustomMessage message = new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.catroyale.beastPlayer").addString(getName()).addString(fPlayer.getPlayer().getName());

            }
        }
    }

    @Override
    public void initEvent() {
        super.initEvent();
        initVariables();
        if (_isLoaded) {
            handleAnnounces();
        }
        _isLoaded = true;
    }

    private void handleAnnounces() {
        Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.start", getName());

        setState(EventState.STARTED);

        _minutesLeft.set(5);
        _secondsLeft.set(10);

        if (_regAnnounceTask != null)
        {
            _regAnnounceTask.cancel(false);
            _regAnnounceTask = null;
        }

        // reg announce close task
        _regAnnounceTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(() ->
        {
            if (_minutesLeft.get() > 0)
            {
                if (_minutesLeft.get() == 1) {
                    Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.announce.single", getName(), _minutesLeft.get());
                } else {
                    Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.announce", getName(), _minutesLeft.get());
                }
            }
            else
            {
                if (_regAnnounceTask != null)
                {
                    _regAnnounceTask.cancel(false);
                    _regAnnounceTask = null;
                    return;
                }
            }
            _minutesLeft.decrementAndGet();
        }, 0, (60 * 1000L));

        // start tp seconds call down task
        long msDelay = (5 * 60 * 1000L) - (10 * 1000L);
        ThreadPoolManager.getInstance().schedule(() ->
        {
            Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.stop", getName());
            if (_tpAnnounceTask != null)
            {
                _tpAnnounceTask.cancel(false);
                _tpAnnounceTask = null;
            }

            _log.info("Starting tp announce task with {} seconds", _secondsLeft.get());

            _tpAnnounceTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(() ->
            {
                if (_secondsLeft.get() > 0)
                {
                    for (FightClubPlayer fPlayer : getPlayers(REGISTERED_PLAYERS))
                    {
                        sendMessageToPlayer(fPlayer, MessageType.REGISTER_ANNOUNCE, new CustomMessage("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.teleport").addString(getName()).addNumber(_secondsLeft.get()));
                    }
                }

                if (_secondsLeft.decrementAndGet() == 0)
                {
                    _tpAnnounceTask.cancel(false);
                    _tpAnnounceTask = null;
                }
            }, 0, 1000L);
        }, msDelay);
    }

    @Override
    public boolean canRessurect(Player player, Creature creature, boolean force) {
        return super.canRessurect(player, creature, force);
    }

    /**
     * Reset and set variables to default values
     */
    private void initVariables() {
        _playerTransforms.clear();
        _killsDone.set(0);
        _minutesLeft.set(5);
        _secondsLeft.set(10);
        if (_tpAnnounceTask != null) {
            _tpAnnounceTask.cancel(false);
            _tpAnnounceTask = null;
        }
        if (_regAnnounceTask != null) {
            _regAnnounceTask.cancel(false);
            _regAnnounceTask = null;
        }
        for (ScheduledFuture<?> task : _tasks) {
            if (task != null) {
                task.cancel(false);
            }
        }
        _tasks.clear();
    }

    @Override
    protected String getTeamName(FightClubTeam team)
    {
        String teamName = team.getName();

        switch (team.getName())
        {
            case "Red":
                teamName = "Мурлыкающие Мстители";
                break;
            case "Blue":
                teamName = "Пушистые Победители";
                break;
            default:
                break;
        }

        return teamName;
    }

    @Override
    protected String getScorePlayerName(FightClubPlayer fPlayer) {
        return fPlayer.getPlayer().getName() + (isTeamed() ? " (" + getTeamName(fPlayer.getTeam()) + " )" : "");
    }

    @Override
    protected void teleportSinglePlayer(FightClubPlayer fPlayer, boolean firstTime, boolean healAndRess) {
        super.teleportSinglePlayer(fPlayer, firstTime, healAndRess);
        if (healAndRess) {
            applyInvul(fPlayer);
        }
    }

    private void applyInvul(FightClubPlayer fPlayer) {
        Player player = fPlayer.getPlayer();
        if (player != null) {
            if (player.isInvulnerable()) {
                player.getFlags().getInvulnerable().stop();
                player.getFlags().getDebuffImmunity().stop();
                player.stopAbnormalEffect(AbnormalEffect.INVINCIBILITY);
                for (Servitor servitor : player.getServitors()) {
                    servitor.getFlags().getInvulnerable().stop();
                    servitor.getFlags().getDebuffImmunity().stop();
                    servitor.stopAbnormalEffect(AbnormalEffect.INVINCIBILITY);
                }
            } else {
                String teamName = getTeamName(fPlayer.getTeam());
                AbnormalEffect effect = Objects.equals(teamName, "Мурлыкающие Мстители") ? AbnormalEffect.RED_TEAM : AbnormalEffect.BLUE_TEAM;
                player.startAbnormalEffect(effect);
                player.getFlags().getInvulnerable().start();
                player.getFlags().getDebuffImmunity().start();
                player.startAbnormalEffect(AbnormalEffect.INVINCIBILITY);
                for (Servitor servitor : player.getServitors()) {
                    servitor.getFlags().getInvulnerable().start();
                    servitor.getFlags().getDebuffImmunity().start();
                    servitor.startAbnormalEffect(AbnormalEffect.INVINCIBILITY);
                }

                _tasks.add(ThreadPoolManager.getInstance().schedule(() -> applyInvul(fPlayer), 2000));
            }
        }
    }

    @Override
    public String getVisibleTitle(Player player, String currentTitle, boolean toMe) {
        final FightClubPlayer fPlayer = getFightClubPlayer(player);
        if (fPlayer == null) {
            return currentTitle;
        }
        return String.format("Kills: %d | Deaths: %d", fPlayer.getKills(true), fPlayer.getDeaths());
    }
}
