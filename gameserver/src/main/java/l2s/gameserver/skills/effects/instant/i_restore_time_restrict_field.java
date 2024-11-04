package l2s.gameserver.skills.effects.instant;

import l2s.gameserver.data.xml.holder.TimeRestrictFieldHolder;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.timerestrictfield.ExTimeRestrictFieldUserChargeResult;
import l2s.gameserver.templates.TimeRestrictFieldInfo;
import l2s.gameserver.templates.skill.EffectTemplate;

/**
 * @author nexvill
 **/
public class i_restore_time_restrict_field extends i_abstract_effect
{
    public i_restore_time_restrict_field(EffectTemplate template)
    {
        super(template);
    }

    @Override
    protected boolean checkCondition(Creature effector, Creature effected)
    {
        return effected.isPlayer();
    }


    public boolean canDeleteRestrictItem(Creature effected)
    {
        final int fieldId = (int) getValue();

        final Player player = effected.getPlayer();

        final TimeRestrictFieldInfo field = TimeRestrictFieldHolder.getInstance().getFields().get(fieldId);
        if (field == null)
        {
            return false;
        }

        int reflectionId = player.convertFieldIdToReflectionId(fieldId);

        int remainTimeRefill = player.getVarInt(PlayerVariables.RESTRICT_FIELD_TIMELEFT + "_" + reflectionId + "_refill", 0);

        return (remainTimeRefill > 0);

    }

    @Override
    public void instantUse(Creature effector, Creature effected, boolean reflected)
    {
        final int fieldId = (int) getValue();

        final Player player = effected.getPlayer();

        final TimeRestrictFieldInfo field = TimeRestrictFieldHolder.getInstance().getFields().get(fieldId);
        if (field == null)
        {
            return;
        }
        l2s.gameserver.model.Skill skill = getSkill();
        int restore_time = skill.getRestoreTime() * 60;
        int reflectionId = player.convertFieldIdToReflectionId(fieldId);

        //int remainTimeMax = field.getRemainTimeMax();
        int remainTimeBase = field.getRemainTimeBase();
        int remainTimeRefill = player.getVarInt(PlayerVariables.RESTRICT_FIELD_TIMELEFT + "_" + reflectionId + "_refill", 0);
        long now = System.currentTimeMillis();
        long startTime = player.getVarLong(PlayerVariables.RESTRICT_FIELD_TIMESTART + "_" + reflectionId, now);
        int remainTime = field.getRemainingTime(player);
        int secondsSpent = (int) (System.currentTimeMillis() - startTime) / 1000;
        int remainingTime = remainTime - secondsSpent;

        if (remainTimeRefill > 0)
        {
            player.stopTimedHuntingZoneTask(false);
            int newRemainTimeRefill = remainTimeRefill - restore_time;

            if (newRemainTimeRefill < 0)
            {
                newRemainTimeRefill = 0;
                restore_time = remainTimeRefill;
            }

            player.setVar(PlayerVariables.RESTRICT_FIELD_TIMELEFT + "_" + reflectionId + "_refill", newRemainTimeRefill == 0 ? -1 : newRemainTimeRefill);

            remainingTime += restore_time;

            player.setVar(PlayerVariables.RESTRICT_FIELD_TIMELEFT + "_" + reflectionId, remainingTime);

            player.sendPacket(new ExTimeRestrictFieldUserChargeResult(fieldId, remainingTime, newRemainTimeRefill, restore_time));

            player.sendPacket(new ExShowScreenMessage("Ко времени пребывания в локации добавлено " + (restore_time / 60) + " мин.", 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true));

            //isInTimeRestrictField checking
            if (player.getReflection().getId() < -4)
            {
                player.startTimeRestrictField();
            }
        }
        else
        {
            player.sendPacket(SystemMsg.YOU_WILL_EXCEED_THE_MAX_AMOUNT_OF_TIME_FOR_THE_HUNTING_ZONE_SO_YOU_CANNOT_ADD_ANY_MORE_TIME);
        }
    }
}