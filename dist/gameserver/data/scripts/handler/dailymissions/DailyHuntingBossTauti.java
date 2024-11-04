package handler.dailymissions;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.OnCurrentHpDamageListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;

public class DailyHuntingBossTauti extends ProgressDailyMissionHandler
{
    private static final int TAUTI = 29233;

    private class HandlerListeners implements OnCurrentHpDamageListener
    {
        @Override
        public void onCurrentHpDamage(Creature victim, double damage, Creature attacker, Skill skill)
        {
            calculateDamage(attacker, victim, damage, skill);
        }
    }

    private final HandlerListeners _handlerListeners = new HandlerListeners();

    private void calculateDamage(Creature attacker, Creature victim, double damage, Skill skill)
    {
        Player player = attacker.getPlayer();
        if (player != null && victim.getNpcId() == TAUTI)
        {
            progressMission(player, (int) damage, true, player.getLevel(), player.getRebirthCount());
        }
    }

    @Override
    public CharListener getListener()
    {
        return _handlerListeners;
    }
}
