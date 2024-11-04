package l2s.gameserver.model.actor.listener;

import l2s.commons.listener.Listener;
import l2s.gameserver.listener.actor.player.*;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Servitor;
import l2s.gameserver.model.SkillLearn;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.entity.events.Event;
import l2s.gameserver.model.entity.events.impl.CastleSiegeEvent;
import l2s.gameserver.model.entity.olympiad.OlympiadGame;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.c2s.RequestActionUse.Action;
import l2s.gameserver.network.l2.components.ChatType;
import l2s.gameserver.templates.item.data.ItemData;

import java.util.List;

/**
 * @author G1ta0
 */
public class PlayerListenerList extends PlayableListenerList
{
	public PlayerListenerList(Player actor)
	{
		super(actor);
	}

	@Override
	public Player getActor()
	{
		return (Player) actor;
	}

	public void onEnter()
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnPlayerEnterListener)
					((OnPlayerEnterListener) listener).onPlayerEnter(getActor());

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnPlayerEnterListener)
					((OnPlayerEnterListener) listener).onPlayerEnter(getActor());
	}

	public void onExit()
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnPlayerExitListener)
					((OnPlayerExitListener) listener).onPlayerExit(getActor());

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnPlayerExitListener)
					((OnPlayerExitListener) listener).onPlayerExit(getActor());
	}

	public void onTeleport(int x, int y, int z, Reflection reflection)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnTeleportListener)
					((OnTeleportListener) listener).onTeleport(getActor(), x, y, z, reflection);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnTeleportListener)
					((OnTeleportListener) listener).onTeleport(getActor(), x, y, z, reflection);
	}

	public void onTeleported()
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnTeleportedListener)
					((OnTeleportedListener) listener).onTeleported(getActor());

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnTeleportedListener)
					((OnTeleportedListener) listener).onTeleported(getActor());
	}

	public void onPartyInvite()
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnPlayerPartyInviteListener)
					((OnPlayerPartyInviteListener) listener).onPartyInvite(getActor());

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnPlayerPartyInviteListener)
					((OnPlayerPartyInviteListener) listener).onPartyInvite(getActor());
	}

	public void onPartyLeave()
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnPlayerPartyLeaveListener)
					((OnPlayerPartyLeaveListener) listener).onPartyLeave(getActor());

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnPlayerPartyLeaveListener)
					((OnPlayerPartyLeaveListener) listener).onPartyLeave(getActor());
	}

	public void onClanInvite()
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnPlayerClanInviteListener)
					((OnPlayerClanInviteListener) listener).onClanInvite(getActor());

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnPlayerClanInviteListener)
					((OnPlayerClanInviteListener) listener).onClanInvite(getActor());
	}

	public void onClanLeave()
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnPlayerClanLeaveListener)
					((OnPlayerClanLeaveListener) listener).onClanLeave(getActor());

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnPlayerClanLeaveListener)
					((OnPlayerClanLeaveListener) listener).onClanLeave(getActor());
	}

	public void onSummonServitor(Servitor servitor)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnPlayerSummonServitorListener)
					((OnPlayerSummonServitorListener) listener).onSummonServitor(getActor(), servitor);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnPlayerSummonServitorListener)
					((OnPlayerSummonServitorListener) listener).onSummonServitor(getActor(), servitor);
	}

	/**
	 * Called when player do action
	 */
	public void onSocialAction(Action action)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnSocialActionListener)
					((OnSocialActionListener) listener).onSocialAction(getActor(), getActor().getTarget(), action);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnSocialActionListener)
					((OnSocialActionListener) listener).onSocialAction(getActor(), getActor().getTarget(), action);
	}

	public void onLevelChange(int oldLvl, int newLvl)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnLevelChangeListener)
					((OnLevelChangeListener) listener).onLevelChange(getActor(), oldLvl, newLvl);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnLevelChangeListener)
					((OnLevelChangeListener) listener).onLevelChange(getActor(), oldLvl, newLvl);
	}

	public void onClassChange(ClassId oldClass, ClassId newClass)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnClassChangeListener)
					((OnClassChangeListener) listener).onClassChange(getActor(), oldClass, newClass);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnClassChangeListener)
					((OnClassChangeListener) listener).onClassChange(getActor(), oldClass, newClass);
	}

	public void onPickupItem(ItemInstance item)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnPickupItemListener)
					((OnPickupItemListener) listener).onPickupItem(getActor(), item);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnPickupItemListener)
					((OnPickupItemListener) listener).onPickupItem(getActor(), item);
	}

	public void onEnchantItem(ItemInstance item, boolean success)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnEnchantItemListener)
					((OnEnchantItemListener) listener).onEnchantItem(getActor(), item, success);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnEnchantItemListener)
					((OnEnchantItemListener) listener).onEnchantItem(getActor(), item, success);
	}

	public void onFishing(List<ItemData> fishRewards, boolean success)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnFishingListener)
					((OnFishingListener) listener).onFishing(getActor(), fishRewards, success);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnFishingListener)
					((OnFishingListener) listener).onFishing(getActor(), fishRewards, success);
	}

	public void onOlympiadFinishBattle(OlympiadGame olympiadGame, boolean winner)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnOlympiadFinishBattleListener)
					((OnOlympiadFinishBattleListener) listener).onOlympiadFinishBattle(getActor(), olympiadGame, winner);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnOlympiadFinishBattleListener)
					((OnOlympiadFinishBattleListener) listener).onOlympiadFinishBattle(getActor(), olympiadGame, winner);
	}

	public void onChaosFestivalFinishBattle(boolean winner, boolean lastSurvivor)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnChaosFestivalFinishBattleListener)
					((OnChaosFestivalFinishBattleListener) listener).onChaosFestivalFinishBattle(getActor(), winner, lastSurvivor);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnChaosFestivalFinishBattleListener)
					((OnChaosFestivalFinishBattleListener) listener).onChaosFestivalFinishBattle(getActor(), winner, lastSurvivor);
	}

	public void onQuestFinish(int questId)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnQuestFinishListener)
					((OnQuestFinishListener) listener).onQuestFinish(getActor(), questId);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnQuestFinishListener)
					((OnQuestFinishListener) listener).onQuestFinish(getActor(), questId);
	}

	public void onChatMessageReceive(ChatType type, String charName, String text)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnPlayerChatMessageReceive)
					((OnPlayerChatMessageReceive) listener).onChatMessageReceive(getActor(), type, charName, text);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnPlayerChatMessageReceive)
					((OnPlayerChatMessageReceive) listener).onChatMessageReceive(getActor(), type, charName, text);
	}

	public void onParticipateInEvent(String eventName, boolean isWin)
	{
		if (!global.getListeners().isEmpty())
			for (Listener<Creature> listener : global.getListeners())
				if (listener instanceof OnEventParticipateListener)
					((OnEventParticipateListener) listener).onEventParticipate(getActor(), eventName, isWin);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnEventParticipateListener)
					((OnEventParticipateListener) listener).onEventParticipate(getActor(), eventName, isWin);
	}

	public void onParticipateInCastleSiege(CastleSiegeEvent siegeEvent)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnParticipateInCastleSiegeListener)
					((OnParticipateInCastleSiegeListener) listener).onParticipateInCastleSiege(getActor(), siegeEvent);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnParticipateInCastleSiegeListener)
					((OnParticipateInCastleSiegeListener) listener).onParticipateInCastleSiege(getActor(), siegeEvent);
	}

	public void onLearnCustomSkill(SkillLearn skillLearn)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnLearnCustomSkillListener)
					((OnLearnCustomSkillListener) listener).onLearnCustomSkill(getActor(), skillLearn);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnLearnCustomSkillListener)
					((OnLearnCustomSkillListener) listener).onLearnCustomSkill(getActor(), skillLearn);
	}

	public void onExpReceive(long value, boolean hunting)
	{
		if(!global.getListeners().isEmpty())
			for(Listener<Creature> listener : global.getListeners())
				if(listener instanceof OnExpReceiveListener)
					((OnExpReceiveListener) listener).onExpReceive(getActor(), value, hunting);

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnExpReceiveListener)
					((OnExpReceiveListener) listener).onExpReceive(getActor(), value, hunting);
	}

	public void onBMFestivalRegister()
	{
		if (!global.getListeners().isEmpty())
			for (Listener<Creature> listener : global.getListeners())
				if (listener instanceof OnBMFestivalRegister)
					((OnBMFestivalRegister) listener).onBMFestivalRegister(getActor());

		if(!getListeners().isEmpty())
			for(Listener<Creature> listener : getListeners())
				if(listener instanceof OnBMFestivalRegister)
					((OnBMFestivalRegister) listener).onBMFestivalRegister(getActor());
	}
}
