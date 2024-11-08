package l2s.gameserver.network.l2.s2c;

import org.apache.commons.lang3.StringUtils;

import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Servitor;
import l2s.gameserver.model.base.TeamType;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.instances.PetInstance;
import l2s.gameserver.model.instances.SummonInstance;
import l2s.gameserver.model.pledge.Alliance;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.updatetype.IUpdateTypeComponent;
import l2s.gameserver.network.l2.s2c.updatetype.NpcInfoType;
import l2s.gameserver.skills.AbnormalEffect;

/**
 * @author UnAfraid
 * reworked by Bonux
 */
public class NpcInfoPacket extends AbstractMaskPacket<NpcInfoType>
{
	public static class SummonInfoPacket extends NpcInfoPacket
	{
		public SummonInfoPacket(SummonInstance summon, Creature attacker)
		{
			super(summon, attacker);
		}
	}

	public static class PetInfoPacket extends NpcInfoPacket
	{
		public PetInfoPacket(PetInstance summon, Creature attacker)
		{
			super(summon, attacker);
		}
	}

	// Flags
	private static final int IS_IN_COMBAT = 1 << 0;
	private static final int IS_ALIKE_DEAD = 1 << 1;
	private static final int IS_TARGETABLE = 1 << 2;
	private static final int IS_SHOW_NAME = 1 << 3;

	private final byte[] _masks = new byte[]
			{
					(byte) 0x00,
					(byte) 0x0C,
					(byte) 0x0C,
					(byte) 0x00,
					(byte) 0x00
			};

	private final Creature _creature;
	private final int _npcId;
	private final boolean _isAttackable;
	private final int _rHand, _lHand;
	private final String _name, _title;
	private final int _state;
	private final NpcString _nameNpcString, _titleNpcString;

	private int _initSize = 0;
	private int _blockSize = 0;

	private int _statusMask = 0;

	private int _showSpawnAnimation;
	private int _npcObjId;
	private Location _loc;
	private int _pAtkSpd, _mAtkSpd;
	private double _atkSpdMul, _runSpdMul;
	private int _pvpFlag, _karma;
	private boolean _alive, _running, _flying, _inWater;
	private TeamType _team;
	private int _currentHP, _currentMP;
	private int _maxHP, _maxMP;
	private int _enchantEffect;
	private int _transformId;
	private AbnormalEffect[] _abnormalEffects;
	private int _clanId, _clanCrestId, _largeClanCrestId;
	private int _allyId, _allyCrestId;

	public NpcInfoPacket(NpcInstance npc, Creature attacker)
	{
		_creature = npc;
		_name = npc.getVisibleName(attacker.getPlayer());
		_title = npc.getVisibleTitle(attacker.getPlayer());
		_npcId = npc.getDisplayId() != 0 ? npc.getDisplayId() : npc.getNpcId();
		_isAttackable = !npc.isAlikeDead() && npc.isAutoAttackable(attacker);
		_rHand = npc.getRightHandItem();
		_lHand = npc.getLeftHandItem();
		_showSpawnAnimation = npc.getSpawnAnimation();
		_state = npc.getNpcState();

		NpcString nameNpcString = npc.getNameNpcString();
		_nameNpcString = nameNpcString != null ? nameNpcString : NpcString.NONE;

		NpcString titleNpcString = npc.getTitleNpcString();
		_titleNpcString = titleNpcString != null ? titleNpcString : NpcString.NONE;

		if(npc.isTargetable(attacker))
			_statusMask |= IS_TARGETABLE;

		if(npc.isShowName())
			_statusMask |= IS_SHOW_NAME;

		common(attacker.getPlayer());
	}

	public NpcInfoPacket(Servitor servitor, Creature attacker)
	{
		_creature = servitor;
		_name = servitor.getVisibleName(attacker.getPlayer());
		_title = servitor.getVisibleTitle(attacker.getPlayer());
		_npcId = servitor.getDisplayId() != 0 ? servitor.getDisplayId() : servitor.getNpcId();
		_isAttackable = servitor.isAutoAttackable(attacker);
		_rHand = servitor.getTemplate().rhand;
		_lHand = servitor.getTemplate().lhand;
		_showSpawnAnimation = servitor.getSpawnAnimation();
		_state = servitor.getNpcState();
		_nameNpcString = NpcString.NONE;
		_titleNpcString = NpcString.NONE;

		if(servitor.isTargetable(attacker))
			_statusMask |= IS_TARGETABLE;

		if(servitor.isShowName())
			_statusMask |= IS_SHOW_NAME;

		common(attacker.getPlayer());
	}

	private void common(Player attacker)
	{
		_npcObjId = _creature.getObjectId();
		_loc = _creature.getLoc();
		_pAtkSpd = _creature.getPAtkSpd();
		_mAtkSpd = _creature.getMAtkSpd();
		_atkSpdMul = _creature.getAttackSpeedMultiplier();
		_runSpdMul = _creature.getMovementSpeedMultiplier();
		_pvpFlag = _creature.getPvpFlag();
		_karma = _creature.getKarma();
		_alive = !_creature.isAlikeDead();
		_running = _creature.isRunning();
		_flying = _creature.isFlying();
		_inWater = _creature.isInWater();
		_team = _creature.getTeam();
		_currentHP = attacker != null && attacker.canReceiveStatusUpdate(_creature, StatusUpdatePacket.UpdateType.DEFAULT, StatusUpdatePacket.CUR_HP) ? (int) _creature.getCurrentHp() : (int) _creature.getCurrentHpPercents();
		_currentMP = attacker != null && attacker.canReceiveStatusUpdate(_creature, StatusUpdatePacket.UpdateType.DEFAULT, StatusUpdatePacket.CUR_MP) ? (int) _creature.getCurrentMp() : (int) _creature.getCurrentMpPercents();
		_maxHP = attacker != null && attacker.canReceiveStatusUpdate(_creature, StatusUpdatePacket.UpdateType.DEFAULT, StatusUpdatePacket.MAX_HP) ? _creature.getMaxHp() : 100;
		_maxMP = attacker != null && attacker.canReceiveStatusUpdate(_creature, StatusUpdatePacket.UpdateType.DEFAULT, StatusUpdatePacket.MAX_MP) ? _creature.getMaxMp() : 100;
		_enchantEffect = _creature.getEnchantEffect();
		_transformId = _creature.getVisualTransformId();
		_abnormalEffects = _creature.getAbnormalEffectsArray();

		Clan clan = _creature.getClan();
		Alliance alliance = clan == null ? null : clan.getAlliance();

		_clanId = clan == null ? 0 : clan.getClanId();
		_clanCrestId = clan == null ? 0 : clan.getCrestId();
		_largeClanCrestId = clan == null ? 0 : clan.getCrestLargeId();
		_allyId = alliance == null ? 0 : alliance.getAllyId();
		_allyCrestId = alliance == null ? 0 : alliance.getAllyCrestId();
	}

	public NpcInfoPacket init()
	{
		addComponentType(NpcInfoType.ATTACKABLE, NpcInfoType.UNKNOWN1, NpcInfoType.ID, NpcInfoType.POSITION, NpcInfoType.ALIVE, NpcInfoType.RUNNING);

		if(_name != StringUtils.EMPTY)
		{
			//_masks[2] |= 0x10;
			addComponentType(NpcInfoType.NAME);
		}

		if(_title != StringUtils.EMPTY)
			addComponentType(NpcInfoType.TITLE);

		if(_loc.h > 0)
			addComponentType(NpcInfoType.HEADING);

		if(_pAtkSpd > 0 || _mAtkSpd > 0)
			addComponentType(NpcInfoType.ATK_CAST_SPEED);

		if(_running && _creature.getRunSpeed() > 0 || !_running && _creature.getWalkSpeed() > 0)
			addComponentType(NpcInfoType.SPEED_MULTIPLIER);

		if(_rHand > 0 || _lHand > 0)
			addComponentType(NpcInfoType.EQUIPPED);

		if(_team != TeamType.NONE)
			addComponentType(NpcInfoType.TEAM);

		if(_state > 0)
			addComponentType(NpcInfoType.DISPLAY_EFFECT);

		if(_inWater || _flying)
			addComponentType(NpcInfoType.SWIM_OR_FLY);

		if(_flying)
			addComponentType(NpcInfoType.FLYING);

		if(_maxHP > 0)
			addComponentType(NpcInfoType.MAX_HP);

		if(_maxMP > 0)
			addComponentType(NpcInfoType.MAX_MP);

		if(_currentHP <= _maxHP)
			addComponentType(NpcInfoType.CURRENT_HP);

		if(_currentMP <= _maxMP)
			addComponentType(NpcInfoType.CURRENT_MP);

		if(_abnormalEffects.length > 0)
			addComponentType(NpcInfoType.ABNORMALS);

		if(_enchantEffect > 0)
			addComponentType(NpcInfoType.ENCHANT);

		if(_transformId > 0)
			addComponentType(NpcInfoType.TRANSFORMATION);

		if(_clanId > 0)
			addComponentType(NpcInfoType.CLAN);

		addComponentType(NpcInfoType.UNKNOWN8);

		if(_creature.getPvpFlag() > 0)
			addComponentType(NpcInfoType.PVP_FLAG);

		if(_creature.getKarma() != 0)
			addComponentType(NpcInfoType.REPUTATION);

		if(_creature.isInCombat())
			_statusMask |= IS_IN_COMBAT;

		if(_creature.isAlikeDead())
			_statusMask |= IS_ALIKE_DEAD;

		if(_statusMask != 0)
			addComponentType(NpcInfoType.VISUAL_STATE);

		if(_nameNpcString != NpcString.NONE)
			addComponentType(NpcInfoType.NAME_NPCSTRINGID);

		if(_titleNpcString != NpcString.NONE)
			addComponentType(NpcInfoType.TITLE_NPCSTRINGID);

		return this;
	}

	public NpcInfoPacket update(IUpdateTypeComponent... components)
	{
		_showSpawnAnimation = 1;

		//TODO: Проверить какие на оффе посылаются при обновлении в обазательном порядке.
		addComponentType(NpcInfoType.ATTACKABLE, NpcInfoType.UNKNOWN1, NpcInfoType.ID, NpcInfoType.POSITION, NpcInfoType.ALIVE, NpcInfoType.RUNNING);

		for(IUpdateTypeComponent component : components)
		{
			if(component instanceof NpcInfoType)
				addComponentType((NpcInfoType) component);
		}
		return this;
	}

	@Override
	protected byte[] getMasks()
	{
		return _masks;
	}

	@Override
	protected void onNewMaskAdded(NpcInfoType component)
	{
		switch(component)
		{
			case ATTACKABLE:
			case UNKNOWN1:
			{
				_initSize += component.getBlockLength();
				break;
			}
			case TITLE:
			{
				_initSize += component.getBlockLength() + (_title.length() * 2);
				break;
			}
			case NAME:
			{
				_blockSize += component.getBlockLength() + (_name.length() * 2);
				break;
			}
			default:
			{
				_blockSize += component.getBlockLength();
				break;
			}
		}
	}

	@Override
	protected void writeImpl()
	{
		writeD(_npcObjId);
		writeC(_showSpawnAnimation); // // 0=teleported 1=default 2=summoned
		writeH(38); // mask_bits_37
		writeB(_masks);

		// Block 1
		writeC(_initSize);

		if(containsMask(NpcInfoType.ATTACKABLE))
			writeC(_isAttackable);

		if(containsMask(NpcInfoType.UNKNOWN1))
			writeD(0x00); // unknown

		if(containsMask(NpcInfoType.TITLE))
			writeS(_title);

		// Block 2
		writeH(_blockSize);

		if(containsMask(NpcInfoType.ID))
			writeD(_npcId + 1000000);

		if(containsMask(NpcInfoType.POSITION))
		{
			writeD(_loc.x);
			writeD(_loc.y);
			writeD(_loc.z);
		}

		if(containsMask(NpcInfoType.HEADING))
			writeD(_loc.h);

		if(containsMask(NpcInfoType.UNKNOWN2))
			writeD(0x00); // Unknown

		if(containsMask(NpcInfoType.ATK_CAST_SPEED))
		{
			writeD(_pAtkSpd);
			writeD(_mAtkSpd);
		}

		if(containsMask(NpcInfoType.SPEED_MULTIPLIER))
		{
			writeCutF(_runSpdMul);
			writeCutF(_atkSpdMul);
		}

		if(containsMask(NpcInfoType.EQUIPPED))
		{
			writeD(_rHand);
			writeD(0x00); // Armor id?
			writeD(_lHand);
		}

		if(containsMask(NpcInfoType.ALIVE))
			writeC(_alive);

		if(containsMask(NpcInfoType.RUNNING))
			writeC(_running);

		if(containsMask(NpcInfoType.SWIM_OR_FLY))
			writeC(_inWater ? 1 : _flying ? 2 : 0);

		if(containsMask(NpcInfoType.TEAM))
			writeC(_team.ordinal());

		if(containsMask(NpcInfoType.ENCHANT))
			writeD(_enchantEffect);

		if(containsMask(NpcInfoType.FLYING))
			writeD(_flying);

		if(containsMask(NpcInfoType.CLONE))
			writeD(0x00); // Player ObjectId with Decoy

		if(containsMask(NpcInfoType.UNKNOWN8))
		{
			// No visual effect
			writeD(0x00); // Unknown
		}

		if(containsMask(NpcInfoType.DISPLAY_EFFECT))
			writeD(_state);

		if(containsMask(NpcInfoType.TRANSFORMATION))
			writeD(_transformId);

		if(containsMask(NpcInfoType.CURRENT_HP))
			writeD(_currentHP);

		if(containsMask(NpcInfoType.CURRENT_MP))
			writeD(_currentMP);

		if(containsMask(NpcInfoType.MAX_HP))
			writeD(_maxHP);

		if(containsMask(NpcInfoType.MAX_MP))
			writeD(_maxMP);

		if(containsMask(NpcInfoType.SUMMONED))
			writeC(0x00);	// тип клона 1 == приманка, 2 = клон у ножа

		if(containsMask(NpcInfoType.UNKNOWN12))
		{
			writeD(0x00);
			writeD(0x00);
		}

		if(containsMask(NpcInfoType.NAME))
			writeS(_name);

		if(containsMask(NpcInfoType.NAME_NPCSTRINGID))
			writeD(_nameNpcString.getId()); // NPCStringId for name

		if(containsMask(NpcInfoType.TITLE_NPCSTRINGID))
			writeD(_titleNpcString.getId()); // NPCStringId for title

		if(containsMask(NpcInfoType.PVP_FLAG))
			writeC(_pvpFlag); // PVP flag

		if(containsMask(NpcInfoType.REPUTATION))
			writeD(_karma); // Karma

		if(containsMask(NpcInfoType.CLAN))
		{
			writeD(_clanId);
			writeD(_clanCrestId);
			writeD(_largeClanCrestId);
			writeD(_allyId);
			writeD(_allyCrestId);
		}

		if(containsMask(NpcInfoType.VISUAL_STATE))
			writeD(_statusMask);

		if(containsMask(NpcInfoType.ABNORMALS))
		{
			writeH(_abnormalEffects.length);
			for(AbnormalEffect abnormal : _abnormalEffects)
				writeH(abnormal.getId());
		}
	}
}