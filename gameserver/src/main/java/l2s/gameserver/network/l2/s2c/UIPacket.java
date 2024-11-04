package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.NpcHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Party;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.base.Element;
import l2s.gameserver.model.base.Experience;
import l2s.gameserver.model.base.Race;
import l2s.gameserver.model.base.Sex;
import l2s.gameserver.model.base.TeamType;
import l2s.gameserver.model.entity.Hero;
import l2s.gameserver.model.entity.events.Event;
import l2s.gameserver.model.entity.events.impl.AbstractFightClub;
import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.model.matching.MatchingRoom;
import l2s.gameserver.model.pledge.Alliance;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.s2c.updatetype.UserInfoType;
import l2s.gameserver.utils.ItemFunctions;

/**
 * @reworked by Bonux
 */
public class UIPacket extends AbstractMaskPacket<UserInfoType>
{
	public static final int USER_RELATION_IN_BATTLE_FIELD = 0x01;
	public static final int USER_RELATION_GUILTY = 0x02;
	public static final int USER_RELATION_CHAOTIC = 0x04;
	public static final int USER_RELATION_PARTY_MEMBER = 0x08;
	public static final int USER_RELATION_PARTY_LEADER = 0x10;
	public static final int USER_RELATION_CLAN_MEMBER = 0x20;
	public static final int USER_RELATION_CLAN_LEADER = 0x40;
	public static final int USER_RELATION_IN_SIEGE = 0x80;
	public static final int USER_RELATION_ATTACKER_IN_SIEGE = 0x100;
	public static final int USER_RELATION_ALLIANCE_MEMBER = 0x1000;
	public static final int USER_RELATION_ALLIANCE_MASTER = 0x2000;
	public static final int USER_RELATION_ALLIANCE_IN_WAR = 0x4000;
	public static final int USER_RELATION_PARTICIPANT_IN_DOMINION_SIEGE = 0x6000;

	// Params
	private boolean _canWrite = false, partyRoom;
	private int _runSpd, _walkSpd, _swimRunSpd, _swimWalkSpd, _flRunSpd, _flWalkSpd, _flyRunSpd, _flyWalkSpd, _relation;
	private double move_speed, attack_speed, col_radius, col_height;
	private Location _loc;
	private int obj_id, vehicle_obj_id, _race, sex, base_class, level, curCp, maxCp, _weaponEnchant, _armorSetEnchant, _weaponFlag;
	private long _exp, _sp;
	private int curHp, maxHp, curMp, maxMp, rec_left, rec_have;
	private int _str, _con, _dex, _int, _wit, _men, _luc, _cha, ClanPrivs, InventoryLimit;
	private int _patkspd, _pdef, _matkspd;
	private Number _matk, _patk;
	private int _pEvasion, _pAccuracy, _pCrit, _mEvasion, _mAccuracy, _mCrit;
	private int _mdef, pvp_flag, karma, hair_style, hair_color, face, gm_commands, fame, raidPoints, gearScore, vitality, dk_color;
	private int clan_id, _isClanLeader, clan_crest_id, ally_id, ally_crest_id, large_clan_crest_id;
	private int private_store, can_crystalize, pk_kills, pvp_kills, class_id;
	private int noble, hero;
	private int name_color, running, pledge_class, pledge_type, title_color;
	private int defenceFire, defenceWater, defenceWind, defenceEarth, defenceHoly, defenceUnholy;
	private int attackFire, attackWater, attackWind, attackEarth, attackHoly, attackUnholy;
	private int mount_type;
	private String _name, _title;
	private Element attackElement;
	private int attackElementValue;
	private int _moveType;
	private int talismans;
	private int _jewelsLimit;
	private boolean _activeMainAgathionSlot;
	private int _subAgathionsLimit;
	private int _artifactsLimit;
	private double _expPercent;
	private TeamType _team;
	private int _availableAbilitiesPoints;
	private final boolean _hideHeadAccessories;
	private boolean _chaosFestivalWinner;
	private boolean _haveitem;
	private int _symbolSealPoints;
	private int ranking;
	private int waitingAnimation;

	private final byte[] _masks = new byte[]
			{
					(byte) 0x00,
					(byte) 0x00,
					(byte) 0x00,
					(byte) 0x00
			};

	private int _initSize = 5;

	public UIPacket(Player player)
	{
		this(player, true);
	}

	public UIPacket(Player player, boolean addAll)
	{
		_name = player.getVisibleName(player);
		name_color = player.getVisibleNameColor(player);
		_title = player.getVisibleTitle(player);
		title_color = player.getVisibleTitleColor(player);

		if(player.isPledgeVisible(player))
		{
			Clan clan = player.getClan();
			Alliance alliance = clan == null ? null : clan.getAlliance();
			//
			clan_id = clan == null ? 0 : clan.getClanId();
			_isClanLeader = player.isClanLeader() ? 1 : 0;
			clan_crest_id = clan == null ? 0 : clan.getCrestId();
			large_clan_crest_id = clan == null ? 0 : clan.getCrestLargeId();
			//
			ally_id = alliance == null ? 0 : alliance.getAllyId();
			ally_crest_id = alliance == null ? 0 : alliance.getAllyCrestId();
		}

		if(player.isGMInvisible())
			_title += "[I]";
		if(player.isPolymorphed())
		{
			if(NpcHolder.getInstance().getTemplate(player.getPolyId()) != null)
				_title += "[" + NpcHolder.getInstance().getTemplate(player.getPolyId()).name + "]";
			else
				_title += "[Polymorphed]";
		}

		if(player.isMounted())
		{
			_weaponEnchant = 0;
			mount_type = player.getMountType().ordinal();
		}
		else
		{
			_weaponEnchant = player.getEnchantEffect();
			mount_type = 0;
		}

		_weaponFlag = player.getActiveWeaponInstance() == null ? 0x14 : 0x28;

		move_speed = player.getMovementSpeedMultiplier();
		_runSpd = (int) (player.getRunSpeed() / move_speed);
		_walkSpd = (int) (player.getWalkSpeed() / move_speed);

		_flRunSpd = 0; // TODO
		_flWalkSpd = 0; // TODO

		if(player.isFlying())
		{
			_flyRunSpd = _runSpd;
			_flyWalkSpd = _walkSpd;
		}
		else
		{
			_flyRunSpd = 0;
			_flyWalkSpd = 0;
		}

		_swimRunSpd = (int) (player.getSwimRunSpeed() / move_speed);
		_swimWalkSpd = (int) (player.getSwimWalkSpeed() / move_speed);

		if (player.isInZoneBattle())
		{
			_relation |= USER_RELATION_IN_BATTLE_FIELD;
		}

		if (player.getPvpFlag() != 0)
		{
			_relation |= USER_RELATION_GUILTY;
		}

		if (player.getKarma() > 0)
		{
			_relation |= USER_RELATION_CHAOTIC;
		}

		Party party = player.getParty();
		if(party != null)
		{
			_relation |= USER_RELATION_PARTY_MEMBER;

			if(party.isLeader(player))
				_relation |= USER_RELATION_PARTY_LEADER;
		}

		if(player.getClan() != null)
		{
			_relation |= USER_RELATION_CLAN_MEMBER;
			if(player.isClanLeader())
				_relation |= USER_RELATION_CLAN_LEADER;
		}

		for(Event e : player.getEvents())
			_relation = e.getUserRelation(player, _relation);

		_loc = player.getLoc();
		obj_id = player.getObjectId();
		vehicle_obj_id = player.isInBoat() ? player.getBoat().getBoatId() : 0x00;
		_race = player.getVisualRace() != null ? player.getVisualRace().ordinal() : player.getRace().ordinal();
		sex = getVisualSex(player);
		base_class = getVisualClassId(player, true);
		level = player.getLevel();
		_exp = player.getExp();
		_expPercent = Experience.getExpPercent(player.getLevel(), player.getExp());
		_str = player.getSTR();
		_dex = player.getDEX();
		_con = player.getCON();
		_int = player.getINT();
		_wit = player.getWIT();
		_men = player.getMEN();
		_luc = player.getLUC();
		_cha = player.getCHA();
		curHp = (int) player.getCurrentHp();
		maxHp = player.getMaxHp();
		curMp = (int) player.getCurrentMp();
		maxMp = player.getMaxMp();
		_sp = player.getSp();
		_patk = player.getPAtk(null);
		_patkspd = player.getPAtkSpd();
		_pdef = (int) player.getPDef(null);
		_pEvasion = player.getPEvasionRate(null);
		_pAccuracy = player.getPAccuracy();
		_pCrit = player.getPCriticalHit(null);
		_mEvasion = player.getMEvasionRate(null);
		_mAccuracy = player.getMAccuracy();
		_mCrit = player.getMCriticalHit(null, null);
		_matk = player.getMAtk(null, null);
		_matkspd = player.getMAtkSpd();
		_mdef = player.getMDef(null, null);
		pvp_flag = player.getPvpFlag(); // 0=white, 1=purple, 2=purpleblink
		karma = player.getKarma();
		attack_speed = player.getAttackSpeedMultiplier();
		col_radius = player.getCurrentCollisionRadius();
		col_height = player.getCurrentCollisionHeight();
		if(player.getInventory().getPaperdollItemId(Inventory.PAPERDOLL_HAIR) > 0){
			hair_style = sex;
			hair_color = player.getHairColor();
		} else {
			hair_style = player.getBeautyHairStyle() > 0 ? player.getBeautyHairStyle() : player.getHairStyle();
			hair_color = player.getBeautyHairColor() > 0 ? player.getBeautyHairColor() : player.getHairColor();
		}
		dk_color = player.getHairColor() + 1;
		face = player.getBeautyFace() > 0 ? player.getBeautyFace() : player.getFace();
		gm_commands = player.isGM() || player.getPlayerAccess().CanUseAltG ? 1 : 0;
		// builder level активирует в клиенте админские команды
		clan_id = player.getClanId();
		ally_id = player.getAllyId();
		private_store = (player.isInBuffStore() ? 0 : player.getPrivateStoreType());
		can_crystalize = player.getSkillLevel(Skill.SKILL_CRYSTALLIZE) > 0 ? 1 : 0;
		pk_kills = player.getPkKills();
		pvp_kills = player.getPvpKills();
		ClanPrivs = player.getClanPrivileges();
		rec_left = player.getRecomLeft(); //c2 recommendations remaining
		rec_have = player.getRecomHave(); //c2 recommendations received
		InventoryLimit = player.getInventoryLimit();
		class_id = getVisualClassId(player, false);
		maxCp = player.getMaxCp();
		curCp = (int) player.getCurrentCp();
		_team = player.getTeam();
		noble = player.getNobleType().ordinal(); //0x01: symbol on char menu ctrl+I
		if(noble == 0 && player.isGM() && Config.GM_HERO_AURA)
			noble = 1;
		hero = player.isHero() || player.isGM() && Config.GM_HERO_AURA ? 2 : 0; //0x01: Hero Aura and symbol
		if(hero == 0)
			hero = Hero.getInstance().isInactiveHero(obj_id) ? 1 : 0;
		_haveitem = ItemFunctions.haveItem(player, 999999999, 1);
		_chaosFestivalWinner = player.isChaosFestivalWinner();
		if(_chaosFestivalWinner == false){
			if(_haveitem){
				_chaosFestivalWinner = true;
			}
			else{
				_chaosFestivalWinner = false;
			}
		}
		running = player.isRunning() ? 0x01 : 0x00; //changes the Speed display on Status Window
		pledge_class = player.getPledgeRank().ordinal();
		pledge_type = player.getPledgeType();
		attackElement = player.getAttackElement();
		attackElementValue = player.getAttack(attackElement);

		attackFire = player.getAttack(Element.FIRE);
		attackWater = player.getAttack(Element.WATER);
		attackWind = player.getAttack(Element.WIND);
		attackEarth = player.getAttack(Element.EARTH);

		defenceFire = player.getDefence(Element.FIRE);
		defenceWater = player.getDefence(Element.WATER);
		defenceWind = player.getDefence(Element.WIND);
		defenceEarth = player.getDefence(Element.EARTH);

		defenceHoly = player.getDefence(Element.HOLY);
		defenceUnholy = player.getDefence(Element.UNHOLY);

		fame = player.getFame();
		raidPoints = player.getRaidPoints();
		gearScore = player.getGearScore().getPoints();
		vitality = player.getVitality();
		partyRoom = player.getMatchingRoom() != null && player.getMatchingRoom().getType() == MatchingRoom.PARTY_MATCHING && player.getMatchingRoom().getLeader() == player;
		_moveType = player.isInFlyingTransform() ? 0x02 : (player.isInWater() ? 0x01 : 0x00);
		talismans = player.getTalismanCount();
		_jewelsLimit = player.getJewelsLimit();
		_activeMainAgathionSlot = player.isActiveMainAgathionSlot();
		_subAgathionsLimit = player.getSubAgathionsLimit();
		_artifactsLimit = player.getArtifactsLimit();
		_availableAbilitiesPoints = 0;
		if (player.isAllowAbilities()) {
			_availableAbilitiesPoints = Math.max(0, (player.getAvailableAbilityPoints() - player.getUsedAbilityPoints()));
		}
		_hideHeadAccessories = player.hideHeadAccessories();
		_armorSetEnchant = player.getArmorSetEnchant();
		_symbolSealPoints = (int) player.getSymbolSealPoints();
		ranking = player.isTopRank() ? 1 : player.isTopRaceRank() ? 2 : 0;
		waitingAnimation = ((player.getClan() != null) && (player.getClan().getCastle() != 0)) ? player.isClanLeader() ? 100 : 101 : 0;

		if (player.isInFightClub())
		{
			AbstractFightClub fightClubEvent = player.getFightClubEvent();
			_name = fightClubEvent.getVisibleName(player, _name, true);
			_title = fightClubEvent.getVisibleTitle(player, _title, true);
			title_color = fightClubEvent.getVisibleTitleColor(player, title_color, true);
			name_color = fightClubEvent.getVisibleNameColor(player, name_color, true);
		}

		_canWrite = true;

		if(addAll)
			addComponentType(UserInfoType.values());
	}

	@Override
	protected byte[] getMasks()
	{
		return _masks;
	}

	@Override
	protected void onNewMaskAdded(UserInfoType component)
	{
		calcBlockSize(component);
	}

	private void calcBlockSize(UserInfoType type)
	{
		switch(type)
		{
			case BASIC_INFO:
			{
				_initSize += type.getBlockLength() + (_name.length() * 2);
				break;
			}
			case CLAN:
			{
				_initSize += type.getBlockLength() + (_title.length() * 2);
				break;
			}
			default:
			{
				_initSize += type.getBlockLength();
				break;
			}
		}
	}

	@Override
	protected boolean canWrite()
	{
		return _canWrite;
	}

	@Override
	protected final void writeImpl()
	{
		writeD(obj_id);

		writeD(_initSize);
		writeH(29);
		writeB(_masks);

		if(containsMask(UserInfoType.RELATION))
		{
			writeD(_relation);
		}

		if(containsMask(UserInfoType.BASIC_INFO))
		{
			writeH(UserInfoType.BASIC_INFO.getBlockLength() + (_name.length() * 2));
			writeString(_name);
			writeC(gm_commands);
			writeC(_race);
			writeC(sex);
			writeD(base_class);
			writeD(class_id);
			writeD(level);
			writeD(class_id); // 286 - again class
		}

		if(containsMask(UserInfoType.BASE_STATS))
		{
			writeH(UserInfoType.BASE_STATS.getBlockLength());
			writeH(_str);
			writeH(_dex);
			writeH(_con);
			writeH(_int);
			writeH(_wit);
			writeH(_men);
			writeH(_luc);
			writeH(_cha);
		}

		if(containsMask(UserInfoType.MAX_HPCPMP))
		{
			writeH(UserInfoType.MAX_HPCPMP.getBlockLength());
			writeD(maxHp);
			writeD(maxMp);
			writeD(maxCp);
		}

		if(containsMask(UserInfoType.CURRENT_HPMPCP_EXP_SP))
		{
			writeH(UserInfoType.CURRENT_HPMPCP_EXP_SP.getBlockLength());
			writeD(curHp);
			writeD(curMp);
			writeD(curCp);
			writeQ(_sp);
			writeQ(_exp);
			writeF(_expPercent);
		}

		if(containsMask(UserInfoType.ENCHANTLEVEL))
		{
			writeH(UserInfoType.ENCHANTLEVEL.getBlockLength());
			writeC(_weaponEnchant);
			writeC(_armorSetEnchant);
			writeC(0);
		}

		if(containsMask(UserInfoType.APPAREANCE))
		{
			writeH(UserInfoType.APPAREANCE.getBlockLength());
			writeD(hair_style);
			writeD(hair_color);
			writeD(face);
			writeC(!_hideHeadAccessories);  //переключения прически/головного убора
			writeD(dk_color);
		}// NADA 4 byte INT hotya score ne budet bolshe shorta

		if(containsMask(UserInfoType.STATUS))
		{
			writeH(UserInfoType.STATUS.getBlockLength());
			writeC(mount_type);
			writeC(private_store);
			writeC(can_crystalize);
			writeC(_availableAbilitiesPoints);
		}

		if(containsMask(UserInfoType.STATS))
		{
			writeH(UserInfoType.STATS.getBlockLength());
			writeH(_weaponFlag);

			writeD(limitStat(_patk));
			writeD(_patkspd);
			writeD(_pdef);
			writeD(_pEvasion);
			writeD(_pAccuracy);
			writeD(_pCrit);
			writeD(limitStat(_matk));
			writeD(_matkspd);
			writeD(_patkspd);
			writeD(_mEvasion);
			writeD(_mdef);
			writeD(_mAccuracy);
			writeD(_mCrit);
			writeD(0x00); // unk 272 // getWeaponBonusPAtk
			writeD(0x00); // unk 272 // getWeaponBonusMAtk
		}

		if(containsMask(UserInfoType.ELEMENTALS))
		{
			writeH(UserInfoType.ELEMENTALS.getBlockLength());
			writeH(defenceFire);
			writeH(defenceWater);
			writeH(defenceWind);
			writeH(defenceEarth);
			writeH(defenceHoly);
			writeH(defenceUnholy);
		}

		if(containsMask(UserInfoType.POSITION))
		{
			writeH(UserInfoType.POSITION.getBlockLength());
			writeD(_loc.x);
			writeD(_loc.y);
			writeD(_loc.z);
			writeD(vehicle_obj_id);
		}

		if(containsMask(UserInfoType.SPEED))
		{
			writeH(UserInfoType.SPEED.getBlockLength());
			writeH(_runSpd);
			writeH(_walkSpd);
			writeH(_swimRunSpd);
			writeH(_swimWalkSpd);
			writeH(_flRunSpd);
			writeH(_flWalkSpd);
			writeH(_flyRunSpd);
			writeH(_flyWalkSpd);
		}

		if(containsMask(UserInfoType.MULTIPLIER))
		{
			writeH(UserInfoType.MULTIPLIER.getBlockLength());
			writeF(move_speed);
			writeF(attack_speed);
		}

		if(containsMask(UserInfoType.COL_RADIUS_HEIGHT))
		{
			writeH(UserInfoType.COL_RADIUS_HEIGHT.getBlockLength());
			writeF(col_radius);
			writeF(col_height);
		}

		if(containsMask(UserInfoType.ATK_ELEMENTAL))
		{
			writeH(UserInfoType.ATK_ELEMENTAL.getBlockLength());
			writeC(attackElement.getId());
			writeH(attackElementValue);
		}

		if(containsMask(UserInfoType.CLAN))
		{
			writeH(UserInfoType.CLAN.getBlockLength() + (_title.length() * 2));
			writeString(_title);
			writeH(pledge_type);
			writeD(clan_id);
			writeD(large_clan_crest_id);
			writeD(clan_crest_id);
			writeD(ClanPrivs);
			writeC(_isClanLeader);
			writeD(ally_id);
			writeD(ally_crest_id);
			writeC(partyRoom ? 0x01 : 0x00);
		}

		if(containsMask(UserInfoType.SOCIAL))
		{
			writeH(UserInfoType.SOCIAL.getBlockLength());
			writeC(pvp_flag);
			writeD(karma);
			writeC(noble);
			writeC(hero);
			writeC(pledge_class);
			writeD(pk_kills);
			writeD(pvp_kills);
			writeH(rec_left);
			writeH(rec_have);
			writeD(waitingAnimation);
			writeH(0x00); // Claim left
			writeH(0x00); // Claim have
		}

		if(containsMask(UserInfoType.VITA_FAME))
		{
			writeH(UserInfoType.VITA_FAME.getBlockLength());
			writeD(vitality);
			writeC(0x00); // Vita Bonus
			writeD(fame);
			writeD(raidPoints); // Рейдовые Очки
			writeC(0x00);	// todo 196 protocol
			writeH(_symbolSealPoints);
			writeC(0x00); // unk
		}

		if(containsMask(UserInfoType.SLOTS))
		{
			writeH(UserInfoType.SLOTS.getBlockLength());
			writeC(talismans);
			writeC(_jewelsLimit);
			writeC(_team.ordinal());
			writeC(0x00); // (1 = Red, 2 = White, 3 = White Pink) dotted ring on the floor
			writeC(0x00);
			writeC(0x00);
			writeC(0x00);
			writeC(_activeMainAgathionSlot);	// 140 PROTOCOL
			writeC(_subAgathionsLimit);	// 140 PROTOCOL
			writeC(_artifactsLimit); // Artifact set slots // 152
		}

		if(containsMask(UserInfoType.MOVEMENTS))
		{
			writeH(UserInfoType.MOVEMENTS.getBlockLength());
			writeC(_moveType);
			writeC(running);
		}

		if(containsMask(UserInfoType.COLOR))
		{
			writeH(UserInfoType.COLOR.getBlockLength());
			writeD(name_color);
			writeD(title_color);
		}

		if(containsMask(UserInfoType.INVENTORY_LIMIT))
		{
			writeH(UserInfoType.INVENTORY_LIMIT.getBlockLength());
			writeH(0x00);
			writeH(0x00);
			writeH(InventoryLimit);
			writeC(0); //при 1 не показывает титул
			writeD(0x00);	// Меняет имя на название итема (Item ID)
		}

		if(containsMask(UserInfoType.TRUE_HERO))
		{
			writeH(UserInfoType.TRUE_HERO.getBlockLength());
			writeD(0x00);
			writeH(0x00);
			writeC(_chaosFestivalWinner ? 100 : 0);
		}

		if(containsMask(UserInfoType.ELEMENTAL))
		{
			writeH(UserInfoType.ELEMENTAL.getBlockLength());
			writeD(attackFire);
			writeD(attackWater);
			writeD(attackWind);
			writeD(attackEarth);
			writeD(defenceFire);
			writeD(defenceWater);
			writeD(defenceEarth);
			writeD(defenceWind);
		}

		if(containsMask(UserInfoType.RANKING))
		{
			writeH(UserInfoType.RANKING.getBlockLength());
			writeD(ranking); // Rank
		}

		if(containsMask(UserInfoType.STATS_INCREASE))
		{
			writeH(UserInfoType.STATS_INCREASE.getBlockLength());
			writeH(0x00); // Available Total Points
			writeH(0x00); // STR additional points
			writeH(0x00); // DEX additional points
			writeH(0x00); // CON additional points
			writeH(0x00); // INT additional points
			writeH(0x00); // WIT additional points
			writeH(0x00); // MEN additional points
		}

		if(containsMask(UserInfoType.STAT_ABILITIES))
		{
			writeH(UserInfoType.STAT_ABILITIES.getBlockLength());
			writeH(0x00); // UNK 235
			writeH(0x00); // UNK 235
			writeH(0x00); // UNK 235
			writeH(0x00); // UNK 235
			writeH(0x00); // UNK 235
			writeH(0x00); // UNK 235
			writeH(0x00); // UNK 235
			writeH(0x00); // UNK 235
		}

		if (containsMask(UserInfoType.ELIXIR_USED))
		{
			writeH(UserInfoType.ELIXIR_USED.getBlockLength());
			writeH(gearScore);
		}

		if (containsMask(UserInfoType.VANGUARD_MOUNT))
		{
			writeC(0);
		}
	}

	private int limitStat(Number stat) {
		return stat.longValue() > Integer.MAX_VALUE ? Integer.MAX_VALUE : stat.intValue();
	}

	private int getVisualSex(Player player) {
		String raceName = player.getVar(Player.VISUAL_RACE, "");
		switch(raceName) {
			case "DEATH_KNIGHT":
				return Sex.MALE.ordinal();
			case "ERTHEIA":
				return Sex.FEMALE.ordinal();
			default:
				return player.getSex().ordinal();
		}
	}

	private int getVisualClassId(Player player, boolean isBaseClass) {
		String raceName = player.getVar(Player.VISUAL_RACE, "");
		if (raceName.equals("DEATH_KNIGHT")) {
			return isBaseClass ? ClassId.DEATH_SOLDIER.getId() : player.getActiveClassId();
		} else if (raceName.equals("ORC") && isBaseClass) {
			return player.getClassId().isMage() ? ClassId.ORC_MAGE.getId() :  ClassId.ORC_FIGHTER.getId();
		} else if (raceName.equals("HUMAN") && isBaseClass) {
			return player.getClassId().isMage() ? ClassId.HUMAN_MAGE.getId() : ClassId.HUMAN_FIGHTER.getId();
		} else {
			return isBaseClass ? player.getActiveClassId() : player.getClassId().getId();
		}
	}
}