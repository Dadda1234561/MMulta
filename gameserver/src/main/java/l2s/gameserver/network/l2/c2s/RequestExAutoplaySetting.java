package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.AutoFarm;
import l2s.gameserver.network.l2.s2c.ExAutoplaySetting;

public class RequestExAutoplaySetting extends L2GameClientPacket
{
	private int _options, _nextTargetMode, _healPercent, _petPotionPercent, _macroIndex;
	private boolean _farmActivate, _autoPickUpItems, _meleeAttackMode, _politeFarm;;

	@Override
	protected boolean readImpl()
	{
		//cchcdch
		_options = readH(); // 16 UNK
		_farmActivate = readC() > 0; // Auto Farm Enabled
		_autoPickUpItems = readC() > 0; // Auto Pick Up items
		_nextTargetMode = readH();
		_meleeAttackMode = readC() > 0;
		_healPercent = readD(); // Auto Heal Percent
		_petPotionPercent = readD();
		_politeFarm = readC() > 0;
		_macroIndex = readC();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player player = getClient().getActiveChar();
		if (player == null)
			return;

		AutoFarm autoFarm = player.getAutoFarm();
		autoFarm.setOptions(_options);
		autoFarm.setFarmActivate(_farmActivate);
//		autoFarm.setAutoPickUpItems(_autoPickUpItems);
		autoFarm.setTargetRaid(player.getAutoFarm().isTargetRaid());
		autoFarm.setNextTargetMode(_nextTargetMode);
		autoFarm.setMeleeAttackMode(_meleeAttackMode);
		autoFarm.setHealPercent(_healPercent);
		autoFarm.setPetHealPercent(_petPotionPercent);
		autoFarm.setPoliteFarm(_politeFarm);
		autoFarm.setMacroIndex(_macroIndex);
		autoFarm.doAutoFarm();

		player.sendPacket(new ExAutoplaySetting(player));
	}
}