package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.Config;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Request;
import l2s.gameserver.model.Request.L2RequestType;
import l2s.gameserver.model.World;
import l2s.gameserver.model.actor.instances.player.Mentee;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExMentorAdd;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;

/**
 * @author Cain
 */
public class RequestMenteeAdd extends L2GameClientPacket
{
	private String _newMentee;

	@Override
	protected boolean readImpl()
	{
		_newMentee = readS();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		if(!Config.MENTOR_ENABLE){
			activeChar.sendMessage(activeChar.isLangRus() ? "Сервис отключен!" : "Service disabled!");
			return;
		}

		if(Config.MENTOR_ONLY_PA && !activeChar.hasPremiumAccount())
		{
			/* На оффе вроде нету сообщения.
			activeChar.sendMessage("This feature allowed if you have premium account!");*/
			return;
		}

		// Попытка стать наставником себе
		if(activeChar.getName().equals(_newMentee))
		{
			activeChar.sendPacket(new SystemMessagePacket(SystemMsg.YOU_CANNOT_BECOME_YOUR_OWN_MENTEE));
			return;
		}

		// Только после перерождения можно стать наставником
		if(!activeChar.getClassId().isAwaked())
		{
			activeChar.sendPacket(new SystemMessagePacket(SystemMsg.YOU_MUST_AWAKEN_IN_ORDER_TO_BECOME_A_MENTOR));
			return;
		}

		// Уже 3 ученика у наставника
		if(activeChar.getMenteeList().size() >= 3)
		{
			activeChar.sendPacket(new SystemMessagePacket(SystemMsg.A_MENTOR_CAN_HAVE_UP_TO_3_MENTEES_AT_THE_SAME_TIME));
			return;
		}

		long mentorPenalty = activeChar.getVarLong("mentorPenalty", 0L);
		if(mentorPenalty > System.currentTimeMillis())
		{
			long milisPenalty = mentorPenalty - System.currentTimeMillis();
			double numSecs = milisPenalty / 1000 % 60;
			double countDown = (milisPenalty / 1000 - numSecs) / 60;
			int numMins = (int) Math.floor(countDown % 60);
			countDown = (countDown - numMins) / 60;
			int numHours = (int) Math.floor(countDown % 24);
			int numDays = (int) Math.floor((countDown - numHours) / 24);
			activeChar.sendPacket(new SystemMessagePacket(SystemMsg.YOU_CAN_BOND_WITH_A_NEW_MENTEE_IN_S1_DAYS_S2_HOUR_S3_MINUTE).addInteger(numDays).addInteger(numHours).addInteger(numMins));
			return;
		}

		Player newMentee = World.getPlayer(_newMentee);
		if(newMentee == null) // Чар онлайн?
		{
			activeChar.sendPacket(new SystemMessagePacket(SystemMsg.THAT_PLAYER_IS_NOT_ONLINE));
			return;
		}

		if(Config.MENTOR_ONLY_PA && !newMentee.hasPremiumAccount())
		{
			/* На оффе вроде нету сообщения.
			activeChar.sendMessage("This feature allowed if your mentee has premium account!");
			newMentee.sendMessage("This feature allowed if you have premium account!");*/
			return;
		}

		// Уже есть наставник
		if(newMentee.getMenteeList().getMentor() != 0)
		{
			activeChar.sendPacket(new SystemMessagePacket(SystemMsg.S1_ALREADY_HAS_A_MENTOR).addName(newMentee));
			return;
		}

		// Выбраный чар уже в списке у наставника
		for(Mentee m : activeChar.getMenteeList().values())
		{
			if(m.getName() != null && m.getName().equals(_newMentee))
				return;
		}

		// Выше 104 лвла
		if(newMentee.getLevel() > 104)
		{
			activeChar.sendPacket(new SystemMessagePacket(SystemMsg.S1_IS_LV_105_OR_HIGHER_AND_CANNOT_BECOME_A_MENTEE).addName(newMentee));
			return;
		}

		// no sub classes
		if(!newMentee.isBaseClassActive())
		{
			activeChar.sendPacket(new SystemMessagePacket(SystemMsg.INVITATION_CAN_OCCUR_ONLY_WHEN_THE_MENTEE_IS_IN_MAIN_CLASS_STATUS));
			return;
		}

		if(newMentee.isInTrainingCamp())
		{
			activeChar.sendPacket(SystemMsg.YOU_CANNOT_REQUEST_TO_A_CHARACTER_WHO_IS_ENTERING_THE_TRAINING_CAMP);
			return;
		}

		new Request(L2RequestType.MENTEE, activeChar, newMentee).setTimeout(10000L);
		activeChar.sendPacket(new SystemMessagePacket(SystemMsg.YOU_HAVE_OFFERED_TO_BECOME_S1_MENTOR).addName(newMentee));
		newMentee.sendPacket(new ExMentorAdd(activeChar));
	}
}